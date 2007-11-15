From: Martin Peschke <mp3@de.ibm.com>
Subject: [Patch 2/2] zfcp: fix cleanup of dismissed error recovery actions
Date: Thu, 15 Nov 2007 13:57:17 +0100
Message-ID: <1195131437.16786.33.camel@dix>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate3.uk.ibm.com ([195.212.29.136]:10269 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755880AbXKOM5e (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Nov 2007 07:57:34 -0500
Received: from d06nrmr1407.portsmouth.uk.ibm.com (d06nrmr1407.portsmouth.uk.ibm.com [9.149.38.185])
	by mtagate3.uk.ibm.com (8.13.8/8.13.8) with ESMTP id lAFCvVLv029578
	for <linux-scsi@vger.kernel.org>; Thu, 15 Nov 2007 12:57:31 GMT
Received: from d06av02.portsmouth.uk.ibm.com (d06av02.portsmouth.uk.ibm.com [9.149.37.228])
	by d06nrmr1407.portsmouth.uk.ibm.com (8.13.8/8.13.8/NCO v8.6) with ESMTP id lAFCvUYh2723968
	for <linux-scsi@vger.kernel.org>; Thu, 15 Nov 2007 12:57:31 GMT
Received: from d06av02.portsmouth.uk.ibm.com (loopback [127.0.0.1])
	by d06av02.portsmouth.uk.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id lAFCvOuD015158
	for <linux-scsi@vger.kernel.org>; Thu, 15 Nov 2007 12:57:24 GMT
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Swen Schillig <swen@vnet.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

Calling zfcp_erp_strategy_check_action() after zfcp_erp_action_to_running()
in zfcp_erp_strategy() might cause an unbalanced up() for erp_ready_sem,
which makes the zfcp recovery fail somewhere along the way:


erp thread processing erp_action:
|
|	someone waking up erp thread for erp_action
|	|
|	|		someone else dismissing erp_action:
|	|		|
V	V		V

	write_lock_irqsave(&adapter->erp_lock, flags);
	...
	if (zfcp_erp_action_exists(erp_action) == ZFCP_ERP_ACTION_RUNNING) {
		zfcp_erp_action_to_ready(erp_action);
		up(&adapter->erp_ready_sem);	/* first up() for erp_action */
	}
	write_unlock_irqrestore(&adapter->erp_lock, flags);


write_lock_irqsave(&adapter->erp_lock, flags);
...
zfcp_erp_action_to_running(erp_action);
write_unlock_restore(&adapter->erp_lock, flags);
/* processing erp_action */


			write_lock_irqsave(&adapter->erp_lock, flags);
			...
			erp_action->status |= ZFCP_STATUS_ERP_DISMISSED;
			if (zfcp_erp_action_exists(erp_action) ==
						ZFCP_ERP_ACTION_RUNNING) {
				zfcp_erp_action_to_ready(erp_action);
				up(&adapter->erp_ready_sem);
				/* second, unbalanced up() for erp_action */
			}
			...
			write_unlock_restore(&adapter->erp_lock, flags);


write_lock_irqsave(&adapter->erp_lock, flags);
if (erp_action->status & ZFCP_STATUS_ERP_DISMISSED) {
	zfcp_erp_action_dequeue(erp_action);
	retval = ZFCP_ERP_DISMISSED;
}
...
write_unlock_restore(&adapter->erp_lock, flags);
down(&adapter->erp_ready_sem);
/* this down() is meant to balance the first up() */


The erp thread must not dismiss an erp_action after moving that action to
erp_running_head. Instead it should just go through the down() operation,
which balances the first up(), and run through zfcp_erp_strategy one more
time for the second up(), which eventually cleans up erp_action. Which
is similar to the normal processing of an event for erp_action doing
something asynchronously (e.g. waiting for the completion of an fsf_req).

This only works if we make sure that a dismissed erp_action is passed to
zfcp_erp_strategy() prior to the other action, which caused actions to be
dismissed. Therefore the patch implements this rule: running actions go to
the head of the ready list; new actions go to the tail of the ready list;
the erp thread picks actions to be processed from the ready list's head.

Signed-off-by: Martin Peschke <mp3@de.ibm.com>
Acked-by: Swen Schillig <swen@vnet.ibm.com>

---
 drivers/s390/scsi/zfcp_erp.c |   14 ++++++--------
 1 files changed, 6 insertions(+), 8 deletions(-)

--- linux-2.6.24-rc2-git5.orig/drivers/s390/scsi/zfcp_erp.c
+++ linux-2.6.24-rc2-git5/drivers/s390/scsi/zfcp_erp.c
@@ -1065,7 +1065,7 @@ zfcp_erp_thread(void *data)
 				 &adapter->status)) {
 
 		write_lock_irqsave(&adapter->erp_lock, flags);
-		next = adapter->erp_ready_head.prev;
+		next = adapter->erp_ready_head.next;
 		write_unlock_irqrestore(&adapter->erp_lock, flags);
 
 		if (next != &adapter->erp_ready_head) {
@@ -1155,15 +1155,13 @@ zfcp_erp_strategy(struct zfcp_erp_action
 
 	/*
 	 * check for dismissed status again to avoid follow-up actions,
-	 * failing of targets and so on for dismissed actions
+	 * failing of targets and so on for dismissed actions,
+	 * we go through down() here because there has been an up()
 	 */
-	retval = zfcp_erp_strategy_check_action(erp_action, retval);
+	if (erp_action->status & ZFCP_STATUS_ERP_DISMISSED)
+		retval = ZFCP_ERP_CONTINUES;
 
 	switch (retval) {
-	case ZFCP_ERP_DISMISSED:
-		/* leave since this action has ridden to its ancestors */
-		debug_text_event(adapter->erp_dbf, 6, "a_st_dis2");
-		goto unlock;
 	case ZFCP_ERP_NOMEM:
 		/* no memory to continue immediately, let it sleep */
 		if (!(erp_action->status & ZFCP_STATUS_ERP_LOWMEM)) {
@@ -3091,7 +3089,7 @@ zfcp_erp_action_enqueue(int action,
 	++adapter->erp_total_count;
 
 	/* finally put it into 'ready' queue and kick erp thread */
-	list_add(&erp_action->list, &adapter->erp_ready_head);
+	list_add_tail(&erp_action->list, &adapter->erp_ready_head);
 	up(&adapter->erp_ready_sem);
 	retval = 0;
  out:



From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 3/5] scsi: Unlock accesses to eh_deadline
Date: Tue,  5 Nov 2013 08:05:43 +0100
Message-ID: <1383635145-112651-4-git-send-email-hare@suse.de>
References: <1383635145-112651-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55889 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752804Ab3KEHFy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 5 Nov 2013 02:05:54 -0500
In-Reply-To: <1383635145-112651-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Ren Mingxin <renmx@cn.fujitsu.com>, Joern Engel <joern@logfs.org>, James Smart <james.smart@emulex.com>, Hannes Reinecke <hare@suse.de>

32bit accesses are guaranteed to be atomic, so we can remove
the spinlock when checking for eh_deadline. We only need to
make sure to catch any updates which might happened during
the call to time_before(); if so we just recheck with the
correct value.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_error.c | 44 +++++++++-----------------------------------
 1 file changed, 9 insertions(+), 35 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 7eecbb5..a3f8988 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -94,8 +94,15 @@ static int scsi_host_eh_past_deadline(struct Scsi_Host *shost)
 	if (!shost->last_reset || !shost->eh_deadline)
 		return 0;
 
-	if (time_before(jiffies,
-			shost->last_reset + shost->eh_deadline))
+	/*
+	 * 32bit accesses are guaranteed to be atomic
+	 * (on all supported architectures), so instead
+	 * of using a spinlock we can as well double check
+	 * if eh_deadline has been unset during the
+	 * time_before call.
+	 */
+	if (time_before(jiffies, shost->last_reset + shost->eh_deadline) &&
+	    shost->eh_deadline != 0)
 		return 0;
 
 	return 1;
@@ -111,18 +118,14 @@ scmd_eh_abort_handler(struct work_struct *work)
 	struct scsi_cmnd *scmd =
 		container_of(work, struct scsi_cmnd, abort_work.work);
 	struct scsi_device *sdev = scmd->device;
-	unsigned long flags;
 	int rtn;
 
-	spin_lock_irqsave(sdev->host->host_lock, flags);
 	if (scsi_host_eh_past_deadline(sdev->host)) {
-		spin_unlock_irqrestore(sdev->host->host_lock, flags);
 		SCSI_LOG_ERROR_RECOVERY(3,
 			scmd_printk(KERN_INFO, scmd,
 				    "scmd %p eh timeout, not aborting\n",
 				    scmd));
 	} else {
-		spin_unlock_irqrestore(sdev->host->host_lock, flags);
 		SCSI_LOG_ERROR_RECOVERY(3,
 			scmd_printk(KERN_INFO, scmd,
 				    "aborting command %p\n", scmd));
@@ -1132,7 +1135,6 @@ int scsi_eh_get_sense(struct list_head *work_q,
 	struct scsi_cmnd *scmd, *next;
 	struct Scsi_Host *shost;
 	int rtn;
-	unsigned long flags;
 
 	list_for_each_entry_safe(scmd, next, work_q, eh_entry) {
 		if ((scmd->eh_eflags & SCSI_EH_CANCEL_CMD) ||
@@ -1140,16 +1142,13 @@ int scsi_eh_get_sense(struct list_head *work_q,
 			continue;
 
 		shost = scmd->device->host;
-		spin_lock_irqsave(shost->host_lock, flags);
 		if (scsi_host_eh_past_deadline(shost)) {
-			spin_unlock_irqrestore(shost->host_lock, flags);
 			SCSI_LOG_ERROR_RECOVERY(3,
 				shost_printk(KERN_INFO, shost,
 					    "skip %s, past eh deadline\n",
 					     __func__));
 			break;
 		}
-		spin_unlock_irqrestore(shost->host_lock, flags);
 		SCSI_LOG_ERROR_RECOVERY(2, scmd_printk(KERN_INFO, scmd,
 						  "%s: requesting sense\n",
 						  current->comm));
@@ -1235,26 +1234,21 @@ static int scsi_eh_test_devices(struct list_head *cmd_list,
 	struct scsi_cmnd *scmd, *next;
 	struct scsi_device *sdev;
 	int finish_cmds;
-	unsigned long flags;
 
 	while (!list_empty(cmd_list)) {
 		scmd = list_entry(cmd_list->next, struct scsi_cmnd, eh_entry);
 		sdev = scmd->device;
 
 		if (!try_stu) {
-			spin_lock_irqsave(sdev->host->host_lock, flags);
 			if (scsi_host_eh_past_deadline(sdev->host)) {
 				/* Push items back onto work_q */
 				list_splice_init(cmd_list, work_q);
-				spin_unlock_irqrestore(sdev->host->host_lock,
-						       flags);
 				SCSI_LOG_ERROR_RECOVERY(3,
 					shost_printk(KERN_INFO, sdev->host,
 						     "skip %s, past eh deadline",
 						     __func__));
 				break;
 			}
-			spin_unlock_irqrestore(sdev->host->host_lock, flags);
 		}
 
 		finish_cmds = !scsi_device_online(scmd->device) ||
@@ -1295,15 +1289,12 @@ static int scsi_eh_abort_cmds(struct list_head *work_q,
 	LIST_HEAD(check_list);
 	int rtn;
 	struct Scsi_Host *shost;
-	unsigned long flags;
 
 	list_for_each_entry_safe(scmd, next, work_q, eh_entry) {
 		if (!(scmd->eh_eflags & SCSI_EH_CANCEL_CMD))
 			continue;
 		shost = scmd->device->host;
-		spin_lock_irqsave(shost->host_lock, flags);
 		if (scsi_host_eh_past_deadline(shost)) {
-			spin_unlock_irqrestore(shost->host_lock, flags);
 			list_splice_init(&check_list, work_q);
 			SCSI_LOG_ERROR_RECOVERY(3,
 				shost_printk(KERN_INFO, shost,
@@ -1311,7 +1302,6 @@ static int scsi_eh_abort_cmds(struct list_head *work_q,
 					     __func__));
 			return list_empty(work_q);
 		}
-		spin_unlock_irqrestore(shost->host_lock, flags);
 		SCSI_LOG_ERROR_RECOVERY(3, printk("%s: aborting cmd:"
 						  "0x%p\n", current->comm,
 						  scmd));
@@ -1375,19 +1365,15 @@ static int scsi_eh_stu(struct Scsi_Host *shost,
 {
 	struct scsi_cmnd *scmd, *stu_scmd, *next;
 	struct scsi_device *sdev;
-	unsigned long flags;
 
 	shost_for_each_device(sdev, shost) {
-		spin_lock_irqsave(shost->host_lock, flags);
 		if (scsi_host_eh_past_deadline(shost)) {
-			spin_unlock_irqrestore(shost->host_lock, flags);
 			SCSI_LOG_ERROR_RECOVERY(3,
 				shost_printk(KERN_INFO, shost,
 					    "skip %s, past eh deadline\n",
 					     __func__));
 			break;
 		}
-		spin_unlock_irqrestore(shost->host_lock, flags);
 		stu_scmd = NULL;
 		list_for_each_entry(scmd, work_q, eh_entry)
 			if (scmd->device == sdev && SCSI_SENSE_VALID(scmd) &&
@@ -1441,20 +1427,16 @@ static int scsi_eh_bus_device_reset(struct Scsi_Host *shost,
 {
 	struct scsi_cmnd *scmd, *bdr_scmd, *next;
 	struct scsi_device *sdev;
-	unsigned long flags;
 	int rtn;
 
 	shost_for_each_device(sdev, shost) {
-		spin_lock_irqsave(shost->host_lock, flags);
 		if (scsi_host_eh_past_deadline(shost)) {
-			spin_unlock_irqrestore(shost->host_lock, flags);
 			SCSI_LOG_ERROR_RECOVERY(3,
 				shost_printk(KERN_INFO, shost,
 					    "skip %s, past eh deadline\n",
 					     __func__));
 			break;
 		}
-		spin_unlock_irqrestore(shost->host_lock, flags);
 		bdr_scmd = NULL;
 		list_for_each_entry(scmd, work_q, eh_entry)
 			if (scmd->device == sdev) {
@@ -1515,11 +1497,8 @@ static int scsi_eh_target_reset(struct Scsi_Host *shost,
 		struct scsi_cmnd *next, *scmd;
 		int rtn;
 		unsigned int id;
-		unsigned long flags;
 
-		spin_lock_irqsave(shost->host_lock, flags);
 		if (scsi_host_eh_past_deadline(shost)) {
-			spin_unlock_irqrestore(shost->host_lock, flags);
 			/* push back on work queue for further processing */
 			list_splice_init(&check_list, work_q);
 			list_splice_init(&tmp_list, work_q);
@@ -1529,7 +1508,6 @@ static int scsi_eh_target_reset(struct Scsi_Host *shost,
 					     __func__));
 			return list_empty(work_q);
 		}
-		spin_unlock_irqrestore(shost->host_lock, flags);
 
 		scmd = list_entry(tmp_list.next, struct scsi_cmnd, eh_entry);
 		id = scmd_id(scmd);
@@ -1574,7 +1552,6 @@ static int scsi_eh_bus_reset(struct Scsi_Host *shost,
 	LIST_HEAD(check_list);
 	unsigned int channel;
 	int rtn;
-	unsigned long flags;
 
 	/*
 	 * we really want to loop over the various channels, and do this on
@@ -1584,9 +1561,7 @@ static int scsi_eh_bus_reset(struct Scsi_Host *shost,
 	 */
 
 	for (channel = 0; channel <= shost->max_channel; channel++) {
-		spin_lock_irqsave(shost->host_lock, flags);
 		if (scsi_host_eh_past_deadline(shost)) {
-			spin_unlock_irqrestore(shost->host_lock, flags);
 			list_splice_init(&check_list, work_q);
 			SCSI_LOG_ERROR_RECOVERY(3,
 				shost_printk(KERN_INFO, shost,
@@ -1594,7 +1569,6 @@ static int scsi_eh_bus_reset(struct Scsi_Host *shost,
 					     __func__));
 			return list_empty(work_q);
 		}
-		spin_unlock_irqrestore(shost->host_lock, flags);
 
 		chan_scmd = NULL;
 		list_for_each_entry(scmd, work_q, eh_entry) {
-- 
1.7.12.4


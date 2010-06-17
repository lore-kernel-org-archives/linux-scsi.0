From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 2/4] ibmvscsi: Fix error path deadlock
Date: Thu, 17 Jun 2010 13:56:02 -0500
Message-ID: <201006171856.o5HIu2a5013034@d03av02.boulder.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:56636 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760659Ab0FQS4K (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Jun 2010 14:56:10 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e34.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id o5HImDg6027588
	for <linux-scsi@vger.kernel.org>; Thu, 17 Jun 2010 12:48:13 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id o5HIu5IE122648
	for <linux-scsi@vger.kernel.org>; Thu, 17 Jun 2010 12:56:06 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id o5HIu30L013096
	for <linux-scsi@vger.kernel.org>; Thu, 17 Jun 2010 12:56:04 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com


Fixes a deadlock that can occur if we hit a command timeout
during the virtual adapter initialization. The event done
functions are written with the assumption that no locks are held,
however, when purging requests this is not true. Fix up the
purge function to drop the lock so that the done function
is not called with the lock held, which can cause a deadlock.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ibmvscsi/ibmvscsi.c |   31 +++++++++++++++++--------------
 1 file changed, 17 insertions(+), 14 deletions(-)

diff -puN drivers/scsi/ibmvscsi/ibmvscsi.c~ibmvscsi_purge_lock_fix drivers/scsi/ibmvscsi/ibmvscsi.c
--- linux-2.6/drivers/scsi/ibmvscsi/ibmvscsi.c~ibmvscsi_purge_lock_fix	2010-06-17 13:39:43.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ibmvscsi/ibmvscsi.c	2010-06-17 13:39:43.000000000 -0500
@@ -474,23 +474,26 @@ static int map_data_for_srp_cmd(struct s
  */
 static void purge_requests(struct ibmvscsi_host_data *hostdata, int error_code)
 {
-	struct srp_event_struct *tmp_evt, *pos;
+	struct srp_event_struct *evt;
 	unsigned long flags;
 
 	spin_lock_irqsave(hostdata->host->host_lock, flags);
-	list_for_each_entry_safe(tmp_evt, pos, &hostdata->sent, list) {
-		list_del(&tmp_evt->list);
-		del_timer(&tmp_evt->timer);
-		if (tmp_evt->cmnd) {
-			tmp_evt->cmnd->result = (error_code << 16);
-			unmap_cmd_data(&tmp_evt->iu.srp.cmd,
-				       tmp_evt,
-				       tmp_evt->hostdata->dev);
-			if (tmp_evt->cmnd_done)
-				tmp_evt->cmnd_done(tmp_evt->cmnd);
-		} else if (tmp_evt->done)
-			tmp_evt->done(tmp_evt);
-		free_event_struct(&tmp_evt->hostdata->pool, tmp_evt);
+	while (!list_empty(&hostdata->sent)) {
+		evt = list_first_entry(&hostdata->sent, struct srp_event_struct, list);
+		list_del(&evt->list);
+		del_timer(&evt->timer);
+
+		spin_unlock_irqrestore(hostdata->host->host_lock, flags);
+		if (evt->cmnd) {
+			evt->cmnd->result = (error_code << 16);
+			unmap_cmd_data(&evt->iu.srp.cmd, evt,
+				       evt->hostdata->dev);
+			if (evt->cmnd_done)
+				evt->cmnd_done(evt->cmnd);
+		} else if (evt->done)
+			evt->done(evt);
+		free_event_struct(&evt->hostdata->pool, evt);
+		spin_lock_irqsave(hostdata->host->host_lock, flags);
 	}
 	spin_unlock_irqrestore(hostdata->host->host_lock, flags);
 }
_

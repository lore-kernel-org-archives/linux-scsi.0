From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH Repost 1/2] Block I/O while SG reset operation in progress
	- the midlayer patch
Date: Wed, 08 Mar 2006 14:50:12 -0500
Message-ID: <1141847412.28879.6.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:2549 "EHLO emulex.emulex.com")
	by vger.kernel.org with ESMTP id S932207AbWCHTuP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Mar 2006 14:50:15 -0500
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.12.10/8.12.10) with ESMTP id k28JoErf005032
	for <linux-scsi@vger.kernel.org>; Wed, 8 Mar 2006 11:50:14 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


The scsi midlayer portion of the patch

Signed-off-by: James Smart <James.Smart@emulex.com>

diff -upNr a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
--- a/drivers/scsi/scsi_error.c	2006-02-06 12:00:11.000000000 -0500
+++ b/drivers/scsi/scsi_error.c	2006-03-08 14:29:29.000000000 -0500
@@ -1654,7 +1654,9 @@ int
 scsi_reset_provider(struct scsi_device *dev, int flag)
 {
 	struct scsi_cmnd *scmd = scsi_get_command(dev, GFP_KERNEL);
+	struct Scsi_Host *shost = dev->host;
 	struct request req;
+	unsigned long flags;
 	int rtn;
 
 	scmd->request = &req;
@@ -1684,6 +1686,10 @@ scsi_reset_provider(struct scsi_device *
 	 */
 	scmd->pid			= 0;
 
+	spin_lock_irqsave(shost->host_lock, flags);
+	shost->tmf_in_progress = 1;
+	spin_unlock_irqrestore(shost->host_lock, flags);
+
 	switch (flag) {
 	case SCSI_TRY_RESET_DEVICE:
 		rtn = scsi_try_bus_device_reset(scmd);
@@ -1702,6 +1708,22 @@ scsi_reset_provider(struct scsi_device *
 		rtn = FAILED;
 	}
 
+	spin_lock_irqsave(shost->host_lock, flags);
+	shost->tmf_in_progress = 0;
+	spin_unlock_irqrestore(shost->host_lock, flags);
+
+	/*
+	 * be sure to wake up anyone who was sleeping or had their queue
+	 * suspended while we performed the TMF.
+	 */
+	SCSI_LOG_ERROR_RECOVERY(3,
+		printk("%s: waking up host to restart after TMF\n",
+		__FUNCTION__));
+
+	wake_up(&shost->host_wait);
+
+	scsi_run_host_queues(shost);
+
 	scsi_next_command(scmd);
 	return rtn;
 }
diff -upNr a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
--- a/include/scsi/scsi_host.h	2006-02-06 12:00:33.000000000 -0500
+++ b/include/scsi/scsi_host.h	2006-02-13 10:21:01.000000000 -0500
@@ -556,6 +556,9 @@ struct Scsi_Host {
 	 */
 	unsigned ordered_tag:1;
 
+	/* task mgmt function in progress */
+	unsigned tmf_in_progress:1;
+
 	/*
 	 * Optional work queue to be utilized by the transport
 	 */
@@ -633,7 +636,8 @@ static inline int scsi_host_in_recovery(
 {
 	return shost->shost_state == SHOST_RECOVERY ||
 		shost->shost_state == SHOST_CANCEL_RECOVERY ||
-		shost->shost_state == SHOST_DEL_RECOVERY;
+		shost->shost_state == SHOST_DEL_RECOVERY ||
+		shost->tmf_in_progress;
 }
 
 extern int scsi_queue_work(struct Scsi_Host *, struct work_struct *);



From: Lee Duncan <lduncan@suse.com>
Subject: [PATCH] scsi: ioctl reset should wait for IOs to complete
Date: Tue, 26 Sep 2017 10:22:35 -0700
Message-ID: <20170926172235.29530-1-lduncan@suse.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38067 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S935367AbdIZRYH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 26 Sep 2017 13:24:07 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.com>, Lee Duncan <lduncan@suse.com>

The SCSI ioctl reset path is smart enough to set the
flag tmf_in_progress when a user-requested reset is
processed, but it does not wait for IO that is in
flight. This can result in lost IOs and hung
processes. We should wait for a reasonable amount
of time for either the IOs to complete or to fail
the request.

Signed-off-by: Lee Duncan <lduncan@suse.com>
---
 drivers/scsi/scsi_error.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 38942050b265..b964152611c3 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -57,6 +57,14 @@
 #define BUS_RESET_SETTLE_TIME   (10)
 #define HOST_RESET_SETTLE_TIME  (10)
 
+/*
+ * Time to wait for outstanding IOs when about to send
+ * a device reset, e.g. sg_reset. The msecs to wait must
+ * be an multiple of the msecs to wait per try.
+ */
+#define MSECS_PER_TRY_FOR_IO_ON_RESET	500
+#define MSECS_TO_WAIT_FOR_IO_ON_RESET	(MSECS_PER_TRY_FOR_IO_ON_RESET * 10)
+
 static int scsi_eh_try_stu(struct scsi_cmnd *scmd);
 static int scsi_try_to_abort_cmd(struct scsi_host_template *,
 				 struct scsi_cmnd *);
@@ -2269,6 +2277,7 @@ void scsi_report_device_reset(struct Scsi_Host *shost, int channel, int target)
 	struct request *rq;
 	unsigned long flags;
 	int error = 0, rtn, val;
+	unsigned int msecs_to_wait = MSECS_TO_WAIT_FOR_IO_ON_RESET;
 
 	if (!capable(CAP_SYS_ADMIN) || !capable(CAP_SYS_RAWIO))
 		return -EACCES;
@@ -2301,6 +2310,22 @@ void scsi_report_device_reset(struct Scsi_Host *shost, int channel, int target)
 
 	spin_lock_irqsave(shost->host_lock, flags);
 	shost->tmf_in_progress = 1;
+
+	/* if any IOs in progress wait for them a while */
+	while ((atomic_read(&shost->host_busy) > 0) && (msecs_to_wait > 0)) {
+		spin_unlock_irqrestore(shost->host_lock, flags);
+		msleep(MSECS_PER_TRY_FOR_IO_ON_RESET);
+		msecs_to_wait -= MSECS_PER_TRY_FOR_IO_ON_RESET;
+		spin_lock_irqsave(shost->host_lock, flags);
+	}
+	if (atomic_read(&shost->host_busy)) {
+		shost->tmf_in_progress = 0;
+		spin_unlock_irqrestore(shost->host_lock, flags);
+		SCSI_LOG_ERROR_RECOVERY(3,
+		    printk("%s: device reset failed: outstanding IO\n", __func__));
+		goto out_put_scmd_and_free;
+	}
+
 	spin_unlock_irqrestore(shost->host_lock, flags);
 
 	switch (val & ~SG_SCSI_RESET_NO_ESCALATE) {
@@ -2349,6 +2374,7 @@ void scsi_report_device_reset(struct Scsi_Host *shost, int channel, int target)
 	wake_up(&shost->host_wait);
 	scsi_run_host_queues(shost);
 
+out_put_scmd_and_free:
 	scsi_put_command(scmd);
 	kfree(rq);
 
-- 
1.8.5.6

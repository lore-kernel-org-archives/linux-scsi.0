From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: [PATCH v6 32/37] cxlflash: Fix to avoid potential deadlock on EEH
Date: Wed, 21 Oct 2015 15:15:52 -0500
Message-ID: <1445458552-61150-1-git-send-email-mrochs@linux.vnet.ibm.com>
References: <1445458134-63197-1-git-send-email-mrochs@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e39.co.us.ibm.com ([32.97.110.160]:44687 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756418AbbJUURP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Oct 2015 16:17:15 -0400
Received: from localhost
	by e39.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Wed, 21 Oct 2015 14:17:14 -0600
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
	by d01dlp02.pok.ibm.com (Postfix) with ESMTP id 7CDAA6E804A
	for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2015 16:05:23 -0400 (EDT)
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t9LKHBXH52559950
	for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2015 20:17:11 GMT
Received: from d01av02.pok.ibm.com (localhost [127.0.0.1])
	by d01av02.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t9LKHAmH001344
	for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2015 16:17:11 -0400
In-Reply-To: <1445458134-63197-1-git-send-email-mrochs@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Brian King <brking@linux.vnet.ibm.com>, Ian Munsie <imunsie@au1.ibm.com>, Daniel Axtens <dja@ozlabs.au.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Tomas Henzl <thenzl@redhat.com>, David Laight <David.Laight@ACULAB.COM>
Cc: Michael Neuling <mikey@neuling.org>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org

Ioctl threads that use scsi_execute() can run for an excessive amount
of time due to the fact that they have lengthy timeouts and retry logic
built in. Under normal operation this is not an issue. However, once EEH
enters the picture, a long execution time coupled with the possibility
that a timeout can trigger entry to the driver via registered reset
callbacks becomes a liability.

In particular, a deadlock can occur when an EEH event is encountered
while in running in scsi_execute(). As part of the recovery, the EEH
handler drains all currently running ioctls, waiting until they have
completed before proceeding with a reset. As the scsi_execute()'s are
situated on the ioctl path, the EEH handler will wait until they (and
the remainder of the ioctl handler they're associated with) have
completed. Normally this would not be much of an issue aside from the
longer recovery period. Unfortunately, the scsi_execute() triggers a
reset when it times out. The reset handler will see that the device is
already being reset and wait until that reset completed. This creates
a condition where the EEH handler becomes stuck, infinitely waiting for
the ioctl thread to complete.

To avoid this behavior, temporarily unmark the scsi_execute() threads
as an ioctl thread by releasing the ioctl read semaphore. This allows
the EEH handler to proceed with a recovery while the thread is still
running. Once the scsi_execute() returns, the ioctl read semaphore is
reacquired and the adapter state is rechecked in case it changed while
inside of scsi_execute(). The state check will wait if the adapter is
still being recovered or returns a failure if the recovery failed. In
the event that the adapter reset failed, the failure is simply returned
as the ioctl would be unable to continue.

Reported-by: Brian King <brking@linux.vnet.ibm.com>
Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
Signed-off-by: Manoj N. Kumar <manoj@linux.vnet.ibm.com>
Reviewed-by: Brian King <brking@linux.vnet.ibm.com>
Reviewed-by: Daniel Axtens <dja@axtens.net>
---
 drivers/scsi/cxlflash/superpipe.c | 30 +++++++++++++++++++++++++++++-
 drivers/scsi/cxlflash/superpipe.h |  2 ++
 drivers/scsi/cxlflash/vlun.c      | 29 +++++++++++++++++++++++++++++
 3 files changed, 60 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/cxlflash/superpipe.c b/drivers/scsi/cxlflash/superpipe.c
index f625e07..8af7cdc 100644
--- a/drivers/scsi/cxlflash/superpipe.c
+++ b/drivers/scsi/cxlflash/superpipe.c
@@ -283,6 +283,24 @@ out:
  * @sdev:	SCSI device associated with LUN.
  * @lli:	LUN destined for capacity request.
  *
+ * The READ_CAP16 can take quite a while to complete. Should an EEH occur while
+ * in scsi_execute(), the EEH handler will attempt to recover. As part of the
+ * recovery, the handler drains all currently running ioctls, waiting until they
+ * have completed before proceeding with a reset. As this routine is used on the
+ * ioctl path, this can create a condition where the EEH handler becomes stuck,
+ * infinitely waiting for this ioctl thread. To avoid this behavior, temporarily
+ * unmark this thread as an ioctl thread by releasing the ioctl read semaphore.
+ * This will allow the EEH handler to proceed with a recovery while this thread
+ * is still running. Once the scsi_execute() returns, reacquire the ioctl read
+ * semaphore and check the adapter state in case it changed while inside of
+ * scsi_execute(). The state check will wait if the adapter is still being
+ * recovered or return a failure if the recovery failed. In the event that the
+ * adapter reset failed, simply return the failure as the ioctl would be unable
+ * to continue.
+ *
+ * Note that the above puts a requirement on this routine to only be called on
+ * an ioctl thread.
+ *
  * Return: 0 on success, -errno on failure
  */
 static int read_cap16(struct scsi_device *sdev, struct llun_info *lli)
@@ -314,8 +332,18 @@ retry:
 	dev_dbg(dev, "%s: %ssending cmd(0x%x)\n", __func__,
 		retry_cnt ? "re" : "", scsi_cmd[0]);
 
+	/* Drop the ioctl read semahpore across lengthy call */
+	up_read(&cfg->ioctl_rwsem);
 	result = scsi_execute(sdev, scsi_cmd, DMA_FROM_DEVICE, cmd_buf,
 			      CMD_BUFSIZE, sense_buf, to, CMD_RETRIES, 0, NULL);
+	down_read(&cfg->ioctl_rwsem);
+	rc = check_state(cfg);
+	if (rc) {
+		dev_err(dev, "%s: Failed state! result=0x08%X\n",
+			__func__, result);
+		rc = -ENODEV;
+		goto out;
+	}
 
 	if (driver_byte(result) == DRIVER_SENSE) {
 		result &= ~(0xFF<<24); /* DRIVER_SENSE is not an error */
@@ -1221,7 +1249,7 @@ static const struct file_operations null_fops = {
  *
  * Return: 0 on success, -errno on failure
  */
-static int check_state(struct cxlflash_cfg *cfg)
+int check_state(struct cxlflash_cfg *cfg)
 {
 	struct device *dev = &cfg->dev->dev;
 	int rc = 0;
diff --git a/drivers/scsi/cxlflash/superpipe.h b/drivers/scsi/cxlflash/superpipe.h
index 7df88ee..06a805a 100644
--- a/drivers/scsi/cxlflash/superpipe.h
+++ b/drivers/scsi/cxlflash/superpipe.h
@@ -147,4 +147,6 @@ void cxlflash_ba_terminate(struct ba_lun *);
 
 int cxlflash_manage_lun(struct scsi_device *, struct dk_cxlflash_manage_lun *);
 
+int check_state(struct cxlflash_cfg *);
+
 #endif /* ifndef _CXLFLASH_SUPERPIPE_H */
diff --git a/drivers/scsi/cxlflash/vlun.c b/drivers/scsi/cxlflash/vlun.c
index b0eaf55..a53f583 100644
--- a/drivers/scsi/cxlflash/vlun.c
+++ b/drivers/scsi/cxlflash/vlun.c
@@ -400,6 +400,24 @@ static int init_vlun(struct llun_info *lli)
  * @lba:	Logical block address to start write same.
  * @nblks:	Number of logical blocks to write same.
  *
+ * The SCSI WRITE_SAME16 can take quite a while to complete. Should an EEH occur
+ * while in scsi_execute(), the EEH handler will attempt to recover. As part of
+ * the recovery, the handler drains all currently running ioctls, waiting until
+ * they have completed before proceeding with a reset. As this routine is used
+ * on the ioctl path, this can create a condition where the EEH handler becomes
+ * stuck, infinitely waiting for this ioctl thread. To avoid this behavior,
+ * temporarily unmark this thread as an ioctl thread by releasing the ioctl read
+ * semaphore. This will allow the EEH handler to proceed with a recovery while
+ * this thread is still running. Once the scsi_execute() returns, reacquire the
+ * ioctl read semaphore and check the adapter state in case it changed while
+ * inside of scsi_execute(). The state check will wait if the adapter is still
+ * being recovered or return a failure if the recovery failed. In the event that
+ * the adapter reset failed, simply return the failure as the ioctl would be
+ * unable to continue.
+ *
+ * Note that the above puts a requirement on this routine to only be called on
+ * an ioctl thread.
+ *
  * Return: 0 on success, -errno on failure
  */
 static int write_same16(struct scsi_device *sdev,
@@ -433,9 +451,20 @@ static int write_same16(struct scsi_device *sdev,
 		put_unaligned_be32(ws_limit < left ? ws_limit : left,
 				   &scsi_cmd[10]);
 
+		/* Drop the ioctl read semahpore across lengthy call */
+		up_read(&cfg->ioctl_rwsem);
 		result = scsi_execute(sdev, scsi_cmd, DMA_TO_DEVICE, cmd_buf,
 				      CMD_BUFSIZE, sense_buf, to, CMD_RETRIES,
 				      0, NULL);
+		down_read(&cfg->ioctl_rwsem);
+		rc = check_state(cfg);
+		if (rc) {
+			dev_err(dev, "%s: Failed state! result=0x08%X\n",
+				__func__, result);
+			rc = -ENODEV;
+			goto out;
+		}
+
 		if (result) {
 			dev_err_ratelimited(dev, "%s: command failed for "
 					    "offset %lld result=0x%x\n",
-- 
2.1.0


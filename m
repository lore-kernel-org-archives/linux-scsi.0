From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: [PATCH 1/1] cxlflash: Fix to resolve dead-lock during EEH recovery
Date: Tue,  3 May 2016 11:27:34 -0500
Message-ID: <1462292854-34014-1-git-send-email-ukrishn@linux.vnet.ibm.com>
References: <1462292801-33954-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e19.ny.us.ibm.com ([129.33.205.209]:44144 "EHLO
	e19.ny.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933608AbcECQ3D (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 May 2016 12:29:03 -0400
Received: from localhost
	by e19.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <ukrishn@linux.vnet.ibm.com>;
	Tue, 3 May 2016 12:29:02 -0400
In-Reply-To: <1462292801-33954-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Cc: Brian King <brking@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>

From: "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>

When a cxlflash adapter goes into EEH recovery and multiple processes
(each having established its own context) are active, the EEH recovery
can hang if the processes attempt to recover in parallel. The symptom
logged after a couple of minutes is:

INFO: task eehd:48 blocked for more than 120 seconds.
Not tainted 4.5.0-491-26f710d+ #1
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
eehd            0    48      2
Call Trace:
__switch_to+0x2f0/0x410
__schedule+0x300/0x980
schedule+0x48/0xc0
rwsem_down_write_failed+0x294/0x410
down_write+0x88/0xb0
cxlflash_pci_error_detected+0x100/0x1c0 [cxlflash]
cxl_vphb_error_detected+0x88/0x110 [cxl]
cxl_pci_error_detected+0xb0/0x1d0 [cxl]
eeh_report_error+0xbc/0x130
eeh_pe_dev_traverse+0x94/0x160
eeh_handle_normal_event+0x17c/0x450
eeh_handle_event+0x184/0x370
eeh_event_handler+0x1c8/0x1d0
kthread+0x110/0x130
ret_from_kernel_thread+0x5c/0xa4
INFO: task blockio:33215 blocked for more than 120 seconds.

Not tainted 4.5.0-491-26f710d+ #1
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
blockio         0 33215  33213
Call Trace:
0x1 (unreliable)
__switch_to+0x2f0/0x410
__schedule+0x300/0x980
schedule+0x48/0xc0
rwsem_down_read_failed+0x124/0x1d0
down_read+0x68/0x80
cxlflash_ioctl+0x70/0x6f0 [cxlflash]
scsi_ioctl+0x3b0/0x4c0
sg_ioctl+0x960/0x1010
do_vfs_ioctl+0xd8/0x8c0
SyS_ioctl+0xd4/0xf0
system_call+0x38/0xb4
INFO: task eehd:48 blocked for more than 120 seconds.

The hang is because of a 3 way dead-lock:

Process A holds the recovery mutex, and waits for eehd to complete.
Process B holds the semaphore and waits for the recovery mutex.
eehd waits for semaphore.

The fix is to have Process B above release the semaphore before
attempting to acquire the recovery mutex. This will allow
eehd to proceed to completion.

Signed-off-by: Manoj N. Kumar <manoj@linux.vnet.ibm.com>
---
 drivers/scsi/cxlflash/superpipe.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/scsi/cxlflash/superpipe.c b/drivers/scsi/cxlflash/superpipe.c
index d8a5cb3..ce15070 100644
--- a/drivers/scsi/cxlflash/superpipe.c
+++ b/drivers/scsi/cxlflash/superpipe.c
@@ -1615,6 +1615,13 @@ err1:
  * place at the same time and the failure was due to CXL services being
  * unable to keep up.
  *
+ * As this routine is called on ioctl context, it holds the ioctl r/w
+ * semaphore that is used to drain ioctls in recovery scenarios. The
+ * implementation to achieve the pacing described above (a local mutex)
+ * requires that the ioctl r/w semaphore be dropped and reacquired to
+ * avoid a 3-way deadlock when multiple process recoveries operate in
+ * parallel.
+ *
  * Because a user can detect an error condition before the kernel, it is
  * quite possible for this routine to act as the kernel's EEH detection
  * source (MMIO read of mbox_r). Because of this, there is a window of
@@ -1642,9 +1649,17 @@ static int cxlflash_afu_recover(struct scsi_device *sdev,
 	int rc = 0;
 
 	atomic_inc(&cfg->recovery_threads);
+	up_read(&cfg->ioctl_rwsem);
 	rc = mutex_lock_interruptible(mutex);
+	down_read(&cfg->ioctl_rwsem);
 	if (rc)
 		goto out;
+	rc = check_state(cfg);
+	if (rc) {
+		dev_err(dev, "%s: Failed state! rc=%d\n", __func__, rc);
+		rc = -ENODEV;
+		goto out;
+	}
 
 	dev_dbg(dev, "%s: reason 0x%016llX rctxid=%016llX\n",
 		__func__, recover->reason, rctxid);
-- 
2.1.0


From: Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: [PATCH RESEND] scsi_sysfs: protect against double execution of __scsi_remove_device()
Date: Fri,  6 Nov 2015 16:49:29 +0100
Message-ID: <1446824969-7049-1-git-send-email-vkuznets@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "K. Y. Srinivasan" <kys@microsoft.com>, Bart Van Assche <bart.vanassche@sandisk.com>
List-Id: linux-scsi@vger.kernel.org

On some host errors storvsc module tries to remove sdev by scheduling a job
which does the following:

   sdev = scsi_device_lookup(wrk->host, 0, 0, wrk->lun);
   if (sdev) {
       scsi_remove_device(sdev);
       scsi_device_put(sdev);
   }

While this code seems correct the following crash is observed:

 general protection fault: 0000 [#1] SMP DEBUG_PAGEALLOC
 RIP: 0010:[<ffffffff81169979>]  [<ffffffff81169979>] bdi_destroy+0x39/0x220
 ...
 [<ffffffff814aecdc>] ? _raw_spin_unlock_irq+0x2c/0x40
 [<ffffffff8127b7db>] blk_cleanup_queue+0x17b/0x270
 [<ffffffffa00b54c4>] __scsi_remove_device+0x54/0xd0 [scsi_mod]
 [<ffffffffa00b556b>] scsi_remove_device+0x2b/0x40 [scsi_mod]
 [<ffffffffa00ec47d>] storvsc_remove_lun+0x3d/0x60 [hv_storvsc]
 [<ffffffff81080791>] process_one_work+0x1b1/0x530
 ...

The problem comes with the fact that many such jobs (for the same device)
are being scheduled simultaneously. While scsi_remove_device() uses
shost->scan_mutex and scsi_device_lookup() will fail for a device in
SDEV_DEL state there is no protection against someone who did
scsi_device_lookup() before we actually entered __scsi_remove_device(). So
the whole scenario looks like that: two callers do simultaneous (or
preemption happens) calls to scsi_device_lookup() ant these calls succeed
for both of them, after that they try doing scsi_remove_device().
shost->scan_mutex only serializes their calls to __scsi_remove_device()
and we end up doing the cleanup path twice.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 drivers/scsi/scsi_sysfs.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index dff8faf..3b7e2bb 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -1078,6 +1078,14 @@ void __scsi_remove_device(struct scsi_device *sdev)
 {
 	struct device *dev = &sdev->sdev_gendev;
 
+	/*
+	 * This cleanup path is not reentrant and while it is impossible
+	 * to get a new reference with scsi_device_get() someone can still
+	 * hold a previously acquired one.
+	 */
+	if (sdev->sdev_state == SDEV_DEL)
+		return;
+
 	if (sdev->is_visible) {
 		if (scsi_device_set_state(sdev, SDEV_CANCEL) != 0)
 			return;
-- 
2.4.3

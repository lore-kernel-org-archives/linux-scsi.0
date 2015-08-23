From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 4.2-rc7
Date: Sun, 23 Aug 2015 09:00:13 -0700
Message-ID: <1440345613.2910.4.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:58919 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751444AbbHWQAP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 23 Aug 2015 12:00:15 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

A couple of major (hang and deadlock) fixes with fortunately fairly rare
triggering conditions.  The PM oops is only really triggered by people
using enclosure services (rare) and the fnic driver is mostly used in
enterprise environments.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Alan Stern (1):
      SCSI: Fix NULL pointer dereference in runtime PM

Hiral Shah (1):
      fnic: Use the local variable instead of I/O flag to acquire io_req_lock in fnic_queuecommand() to avoid deadloack

And the diffstat:

 drivers/scsi/fnic/fnic.h      |  2 +-
 drivers/scsi/fnic/fnic_scsi.c |  4 +++-
 drivers/scsi/scsi_pm.c        | 22 +++++++++++-----------
 3 files changed, 15 insertions(+), 13 deletions(-)

With full diff below.

James

---

diff --git a/drivers/scsi/fnic/fnic.h b/drivers/scsi/fnic/fnic.h
index 26270c3..ce129e5 100644
--- a/drivers/scsi/fnic/fnic.h
+++ b/drivers/scsi/fnic/fnic.h
@@ -39,7 +39,7 @@
 
 #define DRV_NAME		"fnic"
 #define DRV_DESCRIPTION		"Cisco FCoE HBA Driver"
-#define DRV_VERSION		"1.6.0.17"
+#define DRV_VERSION		"1.6.0.17a"
 #define PFX			DRV_NAME ": "
 #define DFX                     DRV_NAME "%d: "
 
diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
index 155b286..25436cd 100644
--- a/drivers/scsi/fnic/fnic_scsi.c
+++ b/drivers/scsi/fnic/fnic_scsi.c
@@ -425,6 +425,7 @@ static int fnic_queuecommand_lck(struct scsi_cmnd *sc, void (*done)(struct scsi_
 	unsigned long ptr;
 	struct fc_rport_priv *rdata;
 	spinlock_t *io_lock = NULL;
+	int io_lock_acquired = 0;
 
 	if (unlikely(fnic_chk_state_flags_locked(fnic, FNIC_FLAGS_IO_BLOCKED)))
 		return SCSI_MLQUEUE_HOST_BUSY;
@@ -518,6 +519,7 @@ static int fnic_queuecommand_lck(struct scsi_cmnd *sc, void (*done)(struct scsi_
 	spin_lock_irqsave(io_lock, flags);
 
 	/* initialize rest of io_req */
+	io_lock_acquired = 1;
 	io_req->port_id = rport->port_id;
 	io_req->start_time = jiffies;
 	CMD_STATE(sc) = FNIC_IOREQ_CMD_PENDING;
@@ -571,7 +573,7 @@ out:
 		  (((u64)CMD_FLAGS(sc) >> 32) | CMD_STATE(sc)));
 
 	/* if only we issued IO, will we have the io lock */
-	if (CMD_FLAGS(sc) & FNIC_IO_INITIALIZED)
+	if (io_lock_acquired)
 		spin_unlock_irqrestore(io_lock, flags);
 
 	atomic_dec(&fnic->in_flight);
diff --git a/drivers/scsi/scsi_pm.c b/drivers/scsi/scsi_pm.c
index 9e43ae1..e4b7998 100644
--- a/drivers/scsi/scsi_pm.c
+++ b/drivers/scsi/scsi_pm.c
@@ -217,15 +217,15 @@ static int sdev_runtime_suspend(struct device *dev)
 {
 	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
 	struct scsi_device *sdev = to_scsi_device(dev);
-	int err;
+	int err = 0;
 
-	err = blk_pre_runtime_suspend(sdev->request_queue);
-	if (err)
-		return err;
-	if (pm && pm->runtime_suspend)
+	if (pm && pm->runtime_suspend) {
+		err = blk_pre_runtime_suspend(sdev->request_queue);
+		if (err)
+			return err;
 		err = pm->runtime_suspend(dev);
-	blk_post_runtime_suspend(sdev->request_queue, err);
-
+		blk_post_runtime_suspend(sdev->request_queue, err);
+	}
 	return err;
 }
 
@@ -248,11 +248,11 @@ static int sdev_runtime_resume(struct device *dev)
 	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
 	int err = 0;
 
-	blk_pre_runtime_resume(sdev->request_queue);
-	if (pm && pm->runtime_resume)
+	if (pm && pm->runtime_resume) {
+		blk_pre_runtime_resume(sdev->request_queue);
 		err = pm->runtime_resume(dev);
-	blk_post_runtime_resume(sdev->request_queue, err);
-
+		blk_post_runtime_resume(sdev->request_queue, err);
+	}
 	return err;
 }
 



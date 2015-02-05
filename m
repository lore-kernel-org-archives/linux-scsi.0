From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 3.19-rc7
Date: Thu, 05 Feb 2015 09:53:17 -0800
Message-ID: <1423158797.5848.10.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

This patch set is fixing two serious problems which have turned up late
in the release cycle.  The first fixes a problem with 4k sector disks
where the transfer length (amount of data sent to the disk) was getting
increased every time the disk was revalidated leading to potential for
overflows.  The other is a regression oops fix for some of our last
merge window code.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Brian King (1):
      sd: Fix max transfer length for 4k disks

Mike Christie (1):
      scsi: fix device handler detach oops

And the diffstat

 drivers/scsi/device_handler/scsi_dh.c | 3 ++-
 drivers/scsi/sd.c                     | 6 ++++--
 2 files changed, 6 insertions(+), 3 deletions(-)

With the full diff below.

James

---

diff --git a/drivers/scsi/device_handler/scsi_dh.c b/drivers/scsi/device_handler/scsi_dh.c
index 1dba62c..1efebc9 100644
--- a/drivers/scsi/device_handler/scsi_dh.c
+++ b/drivers/scsi/device_handler/scsi_dh.c
@@ -136,11 +136,12 @@ static void __detach_handler (struct kref *kref)
 	struct scsi_device_handler *scsi_dh = scsi_dh_data->scsi_dh;
 	struct scsi_device *sdev = scsi_dh_data->sdev;
 
+	scsi_dh->detach(sdev);
+
 	spin_lock_irq(sdev->request_queue->queue_lock);
 	sdev->scsi_dh_data = NULL;
 	spin_unlock_irq(sdev->request_queue->queue_lock);
 
-	scsi_dh->detach(sdev);
 	sdev_printk(KERN_NOTICE, sdev, "%s: Detached\n", scsi_dh->name);
 	module_put(scsi_dh->module);
 }
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 3995169..05ea0d4 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2800,9 +2800,11 @@ static int sd_revalidate_disk(struct gendisk *disk)
 	 */
 	sd_set_flush_flag(sdkp);
 
-	max_xfer = min_not_zero(queue_max_hw_sectors(sdkp->disk->queue),
-				sdkp->max_xfer_blocks);
+	max_xfer = sdkp->max_xfer_blocks;
 	max_xfer <<= ilog2(sdp->sector_size) - 9;
+
+	max_xfer = min_not_zero(queue_max_hw_sectors(sdkp->disk->queue),
+				max_xfer);
 	blk_queue_max_hw_sectors(sdkp->disk->queue, max_xfer);
 	set_capacity(disk, sdkp->capacity);
 	sd_config_write_same(sdkp);

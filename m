From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 4.5-rc1
Date: Fri, 29 Jan 2016 16:28:52 +0000
Message-ID: <1454084932.2484.30.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:55372 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932477AbcA2Q3G (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 29 Jan 2016 11:29:06 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

Four fixes: one to try to fix our repeated intermittent crashes in
suspend/resume, one to correct a regression in the optimal I/O size
reporting and a couple for randconfig build failures in the hisi_sas
driver.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Alan Stern (1):
      SCSI: fix crashes in sd and sr runtime PM

Geert Uytterhoeven (2):
      hisi_sas: Restrict SCSI_HISI_SAS to arm64
      hisi_sas: SCSI_HISI_SAS should depend on HAS_DMA

Martin K. Petersen (1):
      sd: Optimal I/O size is in bytes, not sectors

and the diffstat:

 drivers/scsi/hisi_sas/Kconfig | 2 ++
 drivers/scsi/sd.c             | 9 ++++++---
 drivers/scsi/sr.c             | 4 ++++
 3 files changed, 12 insertions(+), 3 deletions(-)

With full diff below.

James

---

diff --git a/drivers/scsi/hisi_sas/Kconfig b/drivers/scsi/hisi_sas/Kconfig
index 37a0c71..b676618 100644
--- a/drivers/scsi/hisi_sas/Kconfig
+++ b/drivers/scsi/hisi_sas/Kconfig
@@ -1,5 +1,7 @@
 config SCSI_HISI_SAS
 	tristate "HiSilicon SAS"
+	depends on HAS_DMA
+	depends on ARM64 || COMPILE_TEST
 	select SCSI_SAS_LIBSAS
 	select BLK_DEV_INTEGRITY
 	help
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 4e08d1cd..bb669d3 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2893,7 +2893,7 @@ static int sd_revalidate_disk(struct gendisk *disk)
 	    sdkp->opt_xfer_blocks <= SD_DEF_XFER_BLOCKS &&
 	    sdkp->opt_xfer_blocks * sdp->sector_size >= PAGE_CACHE_SIZE)
 		rw_max = q->limits.io_opt =
-			logical_to_sectors(sdp, sdkp->opt_xfer_blocks);
+			sdkp->opt_xfer_blocks * sdp->sector_size;
 	else
 		rw_max = BLK_DEF_MAX_SECTORS;
 
@@ -3268,8 +3268,8 @@ static int sd_suspend_common(struct device *dev, bool ignore_stop_errors)
 	struct scsi_disk *sdkp = dev_get_drvdata(dev);
 	int ret = 0;
 
-	if (!sdkp)
-		return 0;	/* this can happen */
+	if (!sdkp)	/* E.g.: runtime suspend following sd_remove() */
+		return 0;
 
 	if (sdkp->WCE && sdkp->media_present) {
 		sd_printk(KERN_NOTICE, sdkp, "Synchronizing SCSI cache\n");
@@ -3308,6 +3308,9 @@ static int sd_resume(struct device *dev)
 {
 	struct scsi_disk *sdkp = dev_get_drvdata(dev);
 
+	if (!sdkp)	/* E.g.: runtime resume at the start of sd_probe() */
+		return 0;
+
 	if (!sdkp->device->manage_start_stop)
 		return 0;
 
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 8bd54a6..64c8674 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -144,6 +144,9 @@ static int sr_runtime_suspend(struct device *dev)
 {
 	struct scsi_cd *cd = dev_get_drvdata(dev);
 
+	if (!cd)	/* E.g.: runtime suspend following sr_remove() */
+		return 0;
+
 	if (cd->media_present)
 		return -EBUSY;
 	else
@@ -985,6 +988,7 @@ static int sr_remove(struct device *dev)
 	scsi_autopm_get_device(cd->device);
 
 	del_gendisk(cd->disk);
+	dev_set_drvdata(dev, NULL);
 
 	mutex_lock(&sr_ref_mutex);
 	kref_put(&cd->kref, sr_kref_release);

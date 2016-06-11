From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 4.7-rc2
Date: Sat, 11 Jun 2016 11:09:32 -0700
Message-ID: <1465668572.2364.26.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:59050 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751328AbcFKSJh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 11 Jun 2016 14:09:37 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

Two current fixes: one affects Qemu CD ROM emulation, which stopped
working after the updates in SCSI to require VPD pages from all
conformant devices.  Fix temporarily by blacklisting Qemu (we can relax
later when they come into compliance).  The other is a fix to the
optimal transfer size.  We set up a minefield for ourselves by being
confused about whether the limits are in bytes or sectors (SCSI optimal
is in blocks and the queue parameter is in bytes).  This tries to fix
the problem (wrong setting for queue limits max_sectors) and make the
problem more obvious by introducing a wrapper function.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Ewan D. Milne (1):
      scsi: Add QEMU CD-ROM to VPD Inquiry Blacklist

Martin K. Petersen (1):
      sd: Fix rw_max for devices that report an optimal xfer size

And the diffstat:

 drivers/scsi/scsi_devinfo.c | 1 +
 drivers/scsi/sd.c           | 8 ++++----
 drivers/scsi/sd.h           | 5 +++++
 3 files changed, 10 insertions(+), 4 deletions(-)

With full diff below.

James

---

diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
index 3408578..ff41c31 100644
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -230,6 +230,7 @@ static struct {
 	{"PIONEER", "CD-ROM DRM-624X", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
 	{"Promise", "VTrak E610f", NULL, BLIST_SPARSELUN | BLIST_NO_RSOC},
 	{"Promise", "", NULL, BLIST_SPARSELUN},
+	{"QEMU", "QEMU CD-ROM", NULL, BLIST_SKIP_VPD_PAGES},
 	{"QNAP", "iSCSI Storage", NULL, BLIST_MAX_1024},
 	{"SYNOLOGY", "iSCSI Storage", NULL, BLIST_MAX_1024},
 	{"QUANTUM", "XP34301", "1071", BLIST_NOTQ},
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index f459dff..60bff78 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2867,10 +2867,10 @@ static int sd_revalidate_disk(struct gendisk *disk)
 	if (sdkp->opt_xfer_blocks &&
 	    sdkp->opt_xfer_blocks <= dev_max &&
 	    sdkp->opt_xfer_blocks <= SD_DEF_XFER_BLOCKS &&
-	    sdkp->opt_xfer_blocks * sdp->sector_size >= PAGE_SIZE)
-		rw_max = q->limits.io_opt =
-			sdkp->opt_xfer_blocks * sdp->sector_size;
-	else
+	    logical_to_bytes(sdp, sdkp->opt_xfer_blocks) >= PAGE_SIZE) {
+		q->limits.io_opt = logical_to_bytes(sdp, sdkp->opt_xfer_blocks);
+		rw_max = logical_to_sectors(sdp, sdkp->opt_xfer_blocks);
+	} else
 		rw_max = BLK_DEF_MAX_SECTORS;
 
 	/* Combine with controller limits */
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index 654630b..765a6f1 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -151,6 +151,11 @@ static inline sector_t logical_to_sectors(struct scsi_device *sdev, sector_t blo
 	return blocks << (ilog2(sdev->sector_size) - 9);
 }
 
+static inline unsigned int logical_to_bytes(struct scsi_device *sdev, sector_t blocks)
+{
+	return blocks * sdev->sector_size;
+}
+
 /*
  * A DIF-capable target device can be formatted with different
  * protection schemes.  Currently 0 through 3 are defined:

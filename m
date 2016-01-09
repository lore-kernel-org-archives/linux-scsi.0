From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 4.4-rc8
Date: Sat, 09 Jan 2016 09:51:24 -0800
Message-ID: <1452361884.2361.20.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Single fix for machines with pages > 4k (PPC mostly).  There's a bug in
our optimal transfer size code where we don't account for pages > 4k
and can set the transfer size to be less than the page size causing
nasty failures.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Martin K. Petersen (1):
      sd: Reject optimal transfer length smaller than page size

And the diffstat:

 drivers/scsi/sd.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

With full diff below.

James

---

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 3d22fc3..4e08d1cd 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2885,10 +2885,13 @@ static int sd_revalidate_disk(struct gendisk *disk)
 
 	/*
 	 * Use the device's preferred I/O size for reads and writes
-	 * unless the reported value is unreasonably large (or garbage).
+	 * unless the reported value is unreasonably small, large, or
+	 * garbage.
 	 */
-	if (sdkp->opt_xfer_blocks && sdkp->opt_xfer_blocks <= dev_max &&
-	    sdkp->opt_xfer_blocks <= SD_DEF_XFER_BLOCKS)
+	if (sdkp->opt_xfer_blocks &&
+	    sdkp->opt_xfer_blocks <= dev_max &&
+	    sdkp->opt_xfer_blocks <= SD_DEF_XFER_BLOCKS &&
+	    sdkp->opt_xfer_blocks * sdp->sector_size >= PAGE_CACHE_SIZE)
 		rw_max = q->limits.io_opt =
 			logical_to_sectors(sdp, sdkp->opt_xfer_blocks);
 	else

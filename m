From: Simon Arlott <simon@fire.lp0.eu>
Subject: [PATCH] scsi/sd: Fix capacity output to show MB/GB/TB/...
Date: Sat, 30 Aug 2008 22:03:04 +0100
Message-ID: <48B9B588.7060709@simon.arlott.org.uk>
References: <48B9546B.4010004@simon.arlott.org.uk> <1220117091.3615.3.camel@localhost.localdomain> <20080830174516.GD1239@parisc-linux.org> <48B9B552.8060406@simon.arlott.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1756965AbYH3VDU@vger.kernel.org>
In-Reply-To: <48B9B552.8060406@simon.arlott.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

The capacity printk'd in bytes is divided by 1000000,
whereas 1048576 would be more consistent with the rest
of the OS and disk-related utilities ('df' etc.).

This change replaces the (sz - (sz/625 - 974))/1950
calculation with a simple right shift to output with
five significant digits the capacity in KB, MB, GB, TB,
PB, or EB. Anything beyond this becomes too large...
---
 drivers/scsi/sd.c |   62 ++++++++++++++++++++++++++++++++++------------------
 1 files changed, 40 insertions(+), 22 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index e5e7d78..c47a071 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1290,6 +1290,8 @@ sd_read_capacity(struct scsi_disk *sdkp, unsigned char *buffer)
 	struct scsi_sense_hdr sshdr;
 	int sense_valid = 0;
 	struct scsi_device *sdp = sdkp->device;
+	unsigned long long orig_capacity, sz;
+	char *units;
 
 repeat:
 	retries = 3;
@@ -1429,30 +1431,16 @@ got_data:
 		 */
 		sector_size = 512;
 	}
-	{
-		/*
-		 * The msdos fs needs to know the hardware sector size
-		 * So I have created this table. See ll_rw_blk.c
-		 * Jacques Gelinas (Jacques@solucorp.qc.ca)
-		 */
-		int hard_sector = sector_size;
-		sector_t sz = (sdkp->capacity/2) * (hard_sector/256);
-		struct request_queue *queue = sdp->request_queue;
-		sector_t mb = sz;
-
-		blk_queue_hardsect_size(queue, hard_sector);
-		/* avoid 64-bit division on 32-bit platforms */
-		sector_div(sz, 625);
-		mb -= sz - 974;
-		sector_div(mb, 1950);
 
-		sd_printk(KERN_NOTICE, sdkp,
-			  "%llu %d-byte hardware sectors (%llu MB)\n",
-			  (unsigned long long)sdkp->capacity,
-			  hard_sector, (unsigned long long)mb);
-	}
+	/*
+	 * The msdos fs needs to know the hardware sector size
+	 * So I have created this table. See ll_rw_blk.c
+	 * Jacques Gelinas (Jacques@solucorp.qc.ca)
+	 */
+	blk_queue_hardsect_size(sdp->request_queue, sector_size);
 
 	/* Rescale capacity to 512-byte units */
+	orig_capacity = sdkp->capacity;
 	if (sector_size == 4096)
 		sdkp->capacity <<= 3;
 	else if (sector_size == 2048)
@@ -1463,6 +1451,36 @@ got_data:
 		sdkp->capacity >>= 1;
 
 	sdkp->device->sector_size = sector_size;
+
+	/* Output device size with at most 5 digits,
+	 * this assumes sz is based on a 512-byte
+	 * sector size.
+	 */
+	sz = sdkp->capacity;
+	if (sz >= (unsigned long long)100000*((unsigned long long)2<<40)) {
+		// 100000PB
+		sz >>= 51;
+		units = "EB";
+	} else if (sz >= (unsigned long long)100000*(2<<30)) { // 100000TB
+		sz >>= 41;
+		units = "PB";
+	} else if (sz >= (unsigned long long)100000*(2<<20)) { // 100000GB
+		sz >>= 31;
+		units = "TB";
+	} else if (sz >= 100000*(2<<10)) { // 100000MB
+		sz >>= 21;
+		units = "GB";
+	} else if (sz >= 100000*2) { // 100000KB
+		sz >>= 11;
+		units = "MB";
+	} else {
+		sz >>= 1;
+		units = "KB";
+	}
+	sd_printk(KERN_NOTICE, sdkp,
+		  "%llu %d-byte hardware sectors (%llu %s)\n",
+		  (unsigned long long)orig_capacity, sector_size,
+		  (unsigned long long)sz, units);
 }
 
 /* called with buffer of length 512 */
-- 
1.5.6.5

-- 
Simon Arlott

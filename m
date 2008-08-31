From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 2/2] sd: use generic helper to print capacities in both
	binary and SI
Date: Sun, 31 Aug 2008 10:15:24 -0500
Message-ID: <1220195724.4021.12.camel@localhost.localdomain>
References: <48B9546B.4010004@simon.arlott.org.uk>
	 <1220117091.3615.3.camel@localhost.localdomain>
	 <20080830174516.GD1239@parisc-linux.org>
	 <48B9B552.8060406@simon.arlott.org.uk>
	 <48B9B588.7060709@simon.arlott.org.uk>
	 <1220147947.3615.18.camel@localhost.localdomain>
	 <20080831025412.GJ1239@parisc-linux.org>
	 <1220195310.4021.4.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:55493 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751197AbYHaPPX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 31 Aug 2008 11:15:23 -0400
In-Reply-To: <1220195310.4021.4.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Simon Arlott <simon@fire.lp0.eu>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

James

---

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index e5e7d78..a9f919e 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -47,6 +47,7 @@
 #include <linux/blkpg.h>
 #include <linux/delay.h>
 #include <linux/mutex.h>
+#include <linux/string_helpers.h>
 #include <asm/uaccess.h>
 
 #include <scsi/scsi.h>
@@ -1429,29 +1430,8 @@ got_data:
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
-
-		sd_printk(KERN_NOTICE, sdkp,
-			  "%llu %d-byte hardware sectors (%llu MB)\n",
-			  (unsigned long long)sdkp->capacity,
-			  hard_sector, (unsigned long long)mb);
-	}
-
+	blk_queue_hardsect_size(sdp->request_queue, sector_size);
+		
 	/* Rescale capacity to 512-byte units */
 	if (sector_size == 4096)
 		sdkp->capacity <<= 3;
@@ -1463,6 +1443,21 @@ got_data:
 		sdkp->capacity >>= 1;
 
 	sdkp->device->sector_size = sector_size;
+	{
+		char cap_str_2[10], cap_str_10[10];
+		u64 sz = sdkp->capacity << 9;
+
+		string_get_size(sz, STRING_UNITS_2, cap_str_2,
+				sizeof(cap_str_2));
+		string_get_size(sz, STRING_UNITS_10, cap_str_10,
+				sizeof(cap_str_10));
+
+		sd_printk(KERN_NOTICE, sdkp,
+			  "%llu %d-byte hardware sectors: (%s/%s)\n",
+			  (unsigned long long)sdkp->capacity,
+			  sector_size, cap_str_10, cap_str_2);
+	}
+
 }
 
 /* called with buffer of length 512 */



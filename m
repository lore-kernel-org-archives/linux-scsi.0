From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/2] lib: add generic helper to print sizes rounded to
	the	correct SI range
Date: Sun, 31 Aug 2008 10:41:52 -0500
Message-ID: <1220197312.4021.19.camel@localhost.localdomain>
References: <48B9546B.4010004@simon.arlott.org.uk>
	 <1220117091.3615.3.camel@localhost.localdomain>
	 <20080830174516.GD1239@parisc-linux.org>
	 <48B9B552.8060406@simon.arlott.org.uk>
	 <48B9B588.7060709@simon.arlott.org.uk>
	 <1220147947.3615.18.camel@localhost.localdomain>
	 <20080831025412.GJ1239@parisc-linux.org>
	 <1220195310.4021.4.camel@localhost.localdomain>
	 <1220195634.4021.9.camel@localhost.localdomain>
	 <48BAB6C4.20007@simon.arlott.org.uk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:55423 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752379AbYHaPlw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 31 Aug 2008 11:41:52 -0400
In-Reply-To: <48BAB6C4.20007@simon.arlott.org.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Simon Arlott <simon@fire.lp0.eu>
Cc: Matthew Wilcox <matthew@wil.cx>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Sun, 2008-08-31 at 16:20 +0100, Simon Arlott wrote:
> On 31/08/08 16:13, James Bottomley wrote:
> > This patch adds the ability to print sizes in either units of 10^3 (SI)
> > or 2^10 (Binary) units.  It rounds up to three significant figures and
> > can be used for either memory or storage capacities.
> 
> > +	const char *units_2[] = {"B", "Kib", "MiB", "GiB", "TiB", "PiB",
> 
> I think this should have been "KiB".

Yes, shift slip.

> I'd prefer an option to display these without the "i"...

If anyone ever finds a use for that, possibly ... but with the i is the
NIST way now, so we follow the standards.

> Oh and you need to store the original capacity before it's re-scaled to 
> 512 bytes. Outputting sdkp->capacity at that stage it'll be a count of 
> 512-byte sectors.

Yes, just trying to avoid a multiplication.  I should have just used ffz
instead.

James

---

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index e5e7d78..ef1c06c 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -47,6 +47,7 @@
 #include <linux/blkpg.h>
 #include <linux/delay.h>
 #include <linux/mutex.h>
+#include <linux/string_helpers.h>
 #include <asm/uaccess.h>
 
 #include <scsi/scsi.h>
@@ -1429,27 +1430,21 @@ got_data:
 		 */
 		sector_size = 512;
 	}
+	blk_queue_hardsect_size(sdp->request_queue, sector_size);
+		
 	{
-		/*
-		 * The msdos fs needs to know the hardware sector size
-		 * So I have created this table. See ll_rw_blk.c
-		 * Jacques Gelinas (Jacques@solucorp.qc.ca)
-		 */
-		int hard_sector = sector_size;
-		sector_t sz = (sdkp->capacity/2) * (hard_sector/256);
-		struct request_queue *queue = sdp->request_queue;
-		sector_t mb = sz;
+		char cap_str_2[10], cap_str_10[10];
+		u64 sz = sdkp->capacity << ffz(~sector_size);
 
-		blk_queue_hardsect_size(queue, hard_sector);
-		/* avoid 64-bit division on 32-bit platforms */
-		sector_div(sz, 625);
-		mb -= sz - 974;
-		sector_div(mb, 1950);
+		string_get_size(sz, STRING_UNITS_2, cap_str_2,
+				sizeof(cap_str_2));
+		string_get_size(sz, STRING_UNITS_10, cap_str_10,
+				sizeof(cap_str_10));
 
 		sd_printk(KERN_NOTICE, sdkp,
-			  "%llu %d-byte hardware sectors (%llu MB)\n",
+			  "%llu %d-byte hardware sectors: (%s/%s)\n",
 			  (unsigned long long)sdkp->capacity,
-			  hard_sector, (unsigned long long)mb);
+			  sector_size, cap_str_10, cap_str_2);
 	}
 
 	/* Rescale capacity to 512-byte units */




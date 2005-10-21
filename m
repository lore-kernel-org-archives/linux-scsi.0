From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] scsi disk: report size without overflow
Date: Fri, 21 Oct 2005 12:20:49 -0500
Message-ID: <1129915249.3440.42.camel@mulgrave>
References: <20051020205532.16b65fa7.rdunlap@xenotime.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:57222 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S965038AbVJURUw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Oct 2005 13:20:52 -0400
In-Reply-To: <20051020205532.16b65fa7.rdunlap@xenotime.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Randy.Dunlap" <rdunlap@xenotime.net>
Cc: scsi <linux-scsi@vger.kernel.org>, akpm <akpm@osdl.org>, Dale Blount <linux-kernel@dale.us>

On Thu, 2005-10-20 at 20:55 -0700, Randy.Dunlap wrote:
> With CONFIG_LBD=n, 'sz' (32 bits) can overflow when capacity is
> multiplied (even * 2), as seen in a report from Dale Blount
> on lkml.  Also make sure that 'mb' will not overflow.
> 
> Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>

Mathematically, it doesn't look like we need to use 64 bits at all;
what's wrong with the attached?  It looks like the code once allowed 256
byte sectors, but the if statement above now forbids them.

I'm really not terribly sympathetic to anyone trying Terrabyte discs on
a non-LBD 32 bit kernel.  The potential for overflow (and consequent
data loss) is pretty huge. 

James

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1253,14 +1253,13 @@ got_data:
 		 * Jacques Gelinas (Jacques@solucorp.qc.ca)
 		 */
 		int hard_sector = sector_size;
-		sector_t sz = sdkp->capacity * (hard_sector/256);
+		sector_t sz = sdkp->capacity * (hard_sector/512);
 		request_queue_t *queue = sdp->request_queue;
-		sector_t mb;
+		sector_t mb = sz;
 
 		blk_queue_hardsect_size(queue, hard_sector);
 		/* avoid 64-bit division on 32-bit platforms */
-		mb = sz >> 1;
-		sector_div(sz, 1250);
+		sector_div(sz, 625);
 		mb -= sz - 974;
 		sector_div(mb, 1950);
 



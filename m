From: akpm@osdl.org
Subject: [patch 3/5] scsi disk: report size without overflow
Date: Fri, 28 Oct 2005 15:07:51 -0700
Message-ID: <200510282207.j9SM7XvR022280@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:44214 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1751886AbVJ1WHf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Oct 2005 18:07:35 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, rdunlap@xenotime.net


From: Randy Dunlap <rdunlap@xenotime.net>

With CONFIG_LBD=n, 'sz' (32 bits) can overflow when capacity is multiplied
(even * 2), as seen in a report from Dale Blount on lkml.  Also make sure
that 'mb' will not overflow.

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/sd.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff -puN drivers/scsi/sd.c~scsi-disk-report-size-without-overflow drivers/scsi/sd.c
--- 25/drivers/scsi/sd.c~scsi-disk-report-size-without-overflow	Fri Oct 28 15:06:07 2005
+++ 25-akpm/drivers/scsi/sd.c	Fri Oct 28 15:06:07 2005
@@ -49,6 +49,7 @@
 #include <linux/blkpg.h>
 #include <linux/kref.h>
 #include <linux/delay.h>
+#include <asm/div64.h>
 #include <asm/uaccess.h>
 
 #include <scsi/scsi.h>
@@ -1253,16 +1254,16 @@ got_data:
 		 * Jacques Gelinas (Jacques@solucorp.qc.ca)
 		 */
 		int hard_sector = sector_size;
-		sector_t sz = sdkp->capacity * (hard_sector/256);
+		u64 sz = sdkp->capacity * (hard_sector/256);
 		request_queue_t *queue = sdp->request_queue;
-		sector_t mb;
+		u64 mb;
 
 		blk_queue_hardsect_size(queue, hard_sector);
 		/* avoid 64-bit division on 32-bit platforms */
 		mb = sz >> 1;
-		sector_div(sz, 1250);
+		do_div(sz, 1250);
 		mb -= sz - 974;
-		sector_div(mb, 1950);
+		do_div(mb, 1950);
 
 		printk(KERN_NOTICE "SCSI device %s: "
 		       "%llu %d-byte hdwr sectors (%llu MB)\n",
_

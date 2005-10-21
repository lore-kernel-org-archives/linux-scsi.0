From: "Randy.Dunlap" <rdunlap@xenotime.net>
Subject: [PATCH] scsi disk: report size without overflow
Date: Thu, 20 Oct 2005 20:55:32 -0700
Message-ID: <20051020205532.16b65fa7.rdunlap@xenotime.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xenotime.net ([66.160.160.81]:21980 "HELO xenotime.net")
	by vger.kernel.org with SMTP id S964859AbVJUDzf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Oct 2005 23:55:35 -0400
Received: from midway ([71.111.157.99]) by xenotime.net for <linux-scsi@vger.kernel.org>; Thu, 20 Oct 2005 20:55:33 -0700
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scsi <linux-scsi@vger.kernel.org>, jejb <james.bottomley@steeleye.com>
Cc: akpm <akpm@osdl.org>, Dale Blount <linux-kernel@dale.us>

From: Randy Dunlap <rdunlap@xenotime.net>

With CONFIG_LBD=n, 'sz' (32 bits) can overflow when capacity is
multiplied (even * 2), as seen in a report from Dale Blount
on lkml.  Also make sure that 'mb' will not overflow.

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
---

 drivers/scsi/sd.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff -Naurp linux-2614-rc5/drivers/scsi/sd.c~scsi_disk_capacity linux-2614-rc5/drivers/scsi/sd.c
--- linux-2614-rc5/drivers/scsi/sd.c~scsi_disk_capacity	2005-10-20 18:55:35.000000000 -0700
+++ linux-2614-rc5/drivers/scsi/sd.c	2005-10-20 20:44:44.000000000 -0700
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


---

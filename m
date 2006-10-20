From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH] cciss: Fix warnings (and bug on 1TB discs)
Date: Thu, 19 Oct 2006 21:23:36 -0600
Message-ID: <20061020032336.GP2602@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:46317 "EHLO
	mail.parisc-linux.org") by vger.kernel.org with ESMTP
	id S1751629AbWJTDXj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Oct 2006 23:23:39 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Miller <mike.miller@hp.com>
Cc: iss_storagedev@hp.com, linux-scsi@vger.kernel.org


CCISS was producing warnings about shifts being greater than the size
of the type and pointers being of incompatible type.  Turns out this
is because it's calling do_div on a 32-bit quantity.  Upon further
investigation, the sector_t total_size is being assigned to an int,
and then we're calling do_div on that int.  Obviously, sector_div is
called for here, and I took the chance to refactor the code a little.

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index dcccaf2..bc66026 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -1923,7 +1923,6 @@ static void cciss_geometry_inquiry(int c
 {
 	int return_code;
 	unsigned long t;
-	unsigned long rem;
 
 	memset(inq_buff, 0, sizeof(InquiryData_struct));
 	if (withirq)
@@ -1939,26 +1938,23 @@ static void cciss_geometry_inquiry(int c
 			printk(KERN_WARNING
 			       "cciss: reading geometry failed, volume "
 			       "does not support reading geometry\n");
-			drv->block_size = block_size;
-			drv->nr_blocks = total_size;
 			drv->heads = 255;
 			drv->sectors = 32;	// Sectors per track
-			t = drv->heads * drv->sectors;
-			drv->cylinders = total_size;
-			rem = do_div(drv->cylinders, t);
 		} else {
-			drv->block_size = block_size;
-			drv->nr_blocks = total_size;
 			drv->heads = inq_buff->data_byte[6];
 			drv->sectors = inq_buff->data_byte[7];
 			drv->cylinders = (inq_buff->data_byte[4] & 0xff) << 8;
 			drv->cylinders += inq_buff->data_byte[5];
 			drv->raid_level = inq_buff->data_byte[8];
-			t = drv->heads * drv->sectors;
-			if (t > 1) {
-				drv->cylinders = total_size;
-				rem = do_div(drv->cylinders, t);
-			}
+		}
+		drv->block_size = block_size;
+		drv->nr_blocks = total_size;
+		t = drv->heads * drv->sectors;
+		if (t > 1) {
+			unsigned rem = sector_div(total_size, t);
+			if (rem)
+				total_size++;
+			drv->cylinders = total_size;
 		}
 	} else {		/* Get geometry failed */
 		printk(KERN_WARNING "cciss: reading geometry failed\n");

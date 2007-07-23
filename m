From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 2/2] bsg: remove unnecessary code and comments
Date: Mon, 23 Jul 2007 09:33:27 +0900
Message-ID: <20070723093327M.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:61830 "EHLO
	tama5.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763916AbXGWAdy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 22 Jul 2007 20:33:54 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: jens.axboe@oracle.com, linux-scsi@vger.kernel.org

- kill uhdr in bsg_command structure
- it's not necessary to put SG v4 stuff to block/scsi_ioctl.c

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 block/bsg.c |    9 ---------
 1 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/block/bsg.c b/block/bsg.c
index f0259c2..2b5e72b 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -9,13 +9,6 @@
  *  archive for more details.
  *
  */
-/*
- * TODO
- *	- Should this get merged, block/scsi_ioctl.c will be migrated into
- *	  this file. To keep maintenance down, it's easier to have them
- *	  seperated right now.
- *
- */
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/file.h>
@@ -92,7 +85,6 @@ struct bsg_command {
 	struct bio *bidi_bio;
 	int err;
 	struct sg_io_v4 hdr;
-	struct sg_io_v4 __user *uhdr;
 	char sense[SCSI_SENSE_BUFFERSIZE];
 };
 
@@ -620,7 +612,6 @@ static int __bsg_write(struct bsg_device *bd, const char __user *buf,
 			break;
 		}
 
-		bc->uhdr = (struct sg_io_v4 __user *) buf;
 		if (copy_from_user(&bc->hdr, buf, sizeof(bc->hdr))) {
 			ret = -EFAULT;
 			break;
-- 
1.5.2.4


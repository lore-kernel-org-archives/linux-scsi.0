From: mike.miller@hp.com
Subject: [patch 2/2] cciss: cleans up warnings in the pass thru ioctl
Date: Thu, 21 Oct 2004 16:20:58 -0500
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20041021212058.GB10462@beardog.cca.cpqcorp.net>
Reply-To: mikem@beardog.cca.cpqcorp.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel=40m.gmane.org-S270991AbUJUViF@vger.kernel.org>
Content-Disposition: inline
To: marcelo.tosatti@cyclades.com, axboe@suse.de
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Patch 2 of 2 for 20041021.
This patch cleans up a warning with some versions of gcc.
Under gcc version 3.3.3 a warning is generated that the comparsion will always
be false due to the limits of the data type. buf_size is declared as a WORD
which limits it to 64k. If the app needs to transfer larger amounts of data
it should use the CCISS_BIG_PASSTHRU.
Please consider this for inclusion. Built against 2.4.28-pre4.
Please apply in order.

 cciss.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletion(-)

Signed off by Mike Miller.
-------------------------------------------------------------------------------
diff -burNp lx2428-pre4-p001/drivers/block/cciss.c lx2428-pre4/drivers/block/cciss.c
--- lx2428-pre4-p001/drivers/block/cciss.c	2004-10-21 15:59:09.881439840 -0500
+++ lx2428-pre4/drivers/block/cciss.c	2004-10-21 13:24:26.616710592 -0500
@@ -958,8 +958,10 @@ static int cciss_ioctl(struct inode *ino
 			return -EINVAL;
 		} 
 		/* Check kmalloc limits */
-		if (iocommand.buf_size > 128000)
+		if (iocommand.buf_size > 64000) {
+			printk(KERN_WARNING "cciss: use CCISS_BIG_PASSTHRU\n");
 			return -EINVAL;
+		}
 		if (iocommand.buf_size > 0) {
 			buff =  kmalloc(iocommand.buf_size, GFP_KERNEL);
 			if (buff == NULL) 

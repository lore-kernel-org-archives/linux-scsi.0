From: "Hironobu Ishii" <ishii.hironobu@jp.fujitsu.com>
Subject: [PATCH] Adding device name to messages from sr.c
Date: Wed, 31 Mar 2004 21:30:43 +0900
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <040901c4171c$4e4870f0$2987110a@lsd.css.fujitsu.com>
Reply-To: "Hironobu Ishii" <ishii.hironobu@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:28327 "EHLO
	fgwmail6.fujitsu.co.jp") by vger.kernel.org with ESMTP
	id S261932AbUCaMdg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 31 Mar 2004 07:33:36 -0500
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

Hi Jens,

sr.c has some messages that does not tell us the error device.
This patch adds device name to such messages.
This is a patch for linux-2.6.5-rc3.

Please apply!

Thanks,
Hironobu Ishii


diff -urN linux-2.6.5-rc3/drivers/scsi/sr.c linux-2.6.5-rc3-work/drivers/scsi/sr.c
--- linux-2.6.5-rc3/drivers/scsi/sr.c 2004-03-30 19:02:47.000000000 +0900
+++ linux-2.6.5-rc3-work/drivers/scsi/sr.c 2004-03-30 20:39:16.000000000 +0900
@@ -321,11 +321,13 @@
   if (!in_interrupt())
    sr_set_blocklength(cd, 2048);
   else
-   printk("sr: can't switch blocksize: in interrupt\n");
+   printk("%s: can't switch blocksize: in interrupt\n",
+    cd->cdi.name);
  }
 
  if (s_size != 512 && s_size != 1024 && s_size != 2048) {
-  printk("sr: bad sector size %d\n", s_size);
+  printk("%s: bad sector size %d\n", 
+   cd->cdi.name, s_size);
   return 0;
  }
 
@@ -349,7 +351,8 @@
    size += sg[i].length;
 
   if (size != SCpnt->request_bufflen && SCpnt->use_sg) {
-   printk(KERN_ERR "sr: mismatch count %d, bytes %d\n",
+   printk(KERN_ERR "%s: mismatch count %d, bytes %d\n",
+     cd->cdi.name,
      size, SCpnt->request_bufflen);
    if (SCpnt->request_bufflen > size)
     SCpnt->request_bufflen = SCpnt->bufflen = size;
@@ -361,7 +364,7 @@
   */
  if (((unsigned int)SCpnt->request->sector % (s_size >> 9)) ||
      (SCpnt->request_bufflen % s_size)) {
-  printk("sr: unaligned transfer\n");
+  printk("%s: unaligned transfer\n", cd->cdi.name);
   return 0;
  }
 
@@ -724,15 +727,15 @@
  /* allocate a request for the TEST_UNIT_READY */
  SRpnt = scsi_allocate_request(cd->device, GFP_KERNEL);
  if (!SRpnt) {
-  printk(KERN_WARNING "(get_capabilities:) Request allocation "
-         "failure.\n");
+  printk(KERN_WARNING "%s: (get_capabilities:) Request allocation "
+   "failure.\n", cd->cdi.name);
   return;
  }
 
  /* allocate transfer buffer */
  buffer = kmalloc(512, GFP_KERNEL | GFP_DMA);
  if (!buffer) {
-  printk(KERN_ERR "sr: out of memory.\n");
+  printk(KERN_ERR "%s: out of memory.\n", cd->cdi.name);
   scsi_release_request(SRpnt);
   return;
  }


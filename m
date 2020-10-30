Return-Path: <SRS0=glVe=EF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C64FC4741F
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Oct 2020 00:11:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE99920782
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Oct 2020 00:11:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726073AbgJ3ALw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Oct 2020 20:11:52 -0400
Received: from smtprelay0132.hostedemail.com ([216.40.44.132]:56254 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725846AbgJ3ALw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 29 Oct 2020 20:11:52 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay06.hostedemail.com (Postfix) with ESMTP id 4AEA618224D75;
        Fri, 30 Oct 2020 00:11:50 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: watch11_400bb4e27291
X-Filterd-Recvd-Size: 14105
Received: from XPS-9350.home (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf18.hostedemail.com (Postfix) with ESMTPA;
        Fri, 30 Oct 2020 00:11:47 +0000 (UTC)
Message-ID: <4945b720d67e9f67b8c8ba02a29c6af1ffa15b08.camel@perches.com>
Subject: [PATCH] z2ram: MODULE_LICENSE update and neatening
From:   Joe Perches <joe@perches.com>
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Denis Efremov <efremov@linux.com>,
        "David S. Miller" <davem@davemloft.net>,
        Song Liu <song@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Finn Thain <fthain@telegraphics.com.au>,
        Michael Schmitz <schmitzmic@gmail.com>,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-m68k@lists.linux-m68k.org,
        Hannes Reinecke <hare@suse.de>
Date:   Thu, 29 Oct 2020 17:11:46 -0700
In-Reply-To: <20201029145841.144173-18-hch@lst.de>
References: <20201029145841.144173-1-hch@lst.de>
         <20201029145841.144173-18-hch@lst.de>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.38.1-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Additional style neatenings.

Miscellanea:

o Make MODULE_LICENSE match the actual license text
o Comment neatening
o alloc failure message removals as there is already a dump_stack()
o Add pr_fmt() and convert printks to pr_<level>
o Unindent code blocks by using continue
o Return early z2open when current_device != 1 and unindent code block
o Add and remove braces where appropriate

Signed-off-by: Joe Perches <joe@perches.com>
---

Uncompiled/untested.

On top of Christoph's changes.
This file still does not have an SPDX line.  What should it be?
Is this still used by anyone?

 drivers/block/z2ram.c | 304 ++++++++++++++++++++++----------------------------
 1 file changed, 132 insertions(+), 172 deletions(-)

diff --git a/drivers/block/z2ram.c b/drivers/block/z2ram.c
index c1d20818e649..4e6c5564f1e8 100644
--- a/drivers/block/z2ram.c
+++ b/drivers/block/z2ram.c
@@ -1,30 +1,31 @@
 /*
-** z2ram - Amiga pseudo-driver to access 16bit-RAM in ZorroII space
-**         as a block device, to be used as a RAM disk or swap space
-** 
-** Copyright (C) 1994 by Ingo Wilken (Ingo.Wilken@informatik.uni-oldenburg.de)
-**
-** ++Geert: support for zorro_unused_z2ram, better range checking
-** ++roman: translate accesses via an array
-** ++Milan: support for ChipRAM usage
-** ++yambo: converted to 2.0 kernel
-** ++yambo: modularized and support added for 3 minor devices including:
-**          MAJOR  MINOR  DESCRIPTION
-**          -----  -----  ----------------------------------------------
-**          37     0       Use Zorro II and Chip ram
-**          37     1       Use only Zorro II ram
-**          37     2       Use only Chip ram
-**          37     4-7     Use memory list entry 1-4 (first is 0)
-** ++jskov: support for 1-4th memory list entry.
-**
-** Permission to use, copy, modify, and distribute this software and its
-** documentation for any purpose and without fee is hereby granted, provided
-** that the above copyright notice appear in all copies and that both that
-** copyright notice and this permission notice appear in supporting
-** documentation.  This software is provided "as is" without express or
-** implied warranty.
-*/
-
+ * z2ram - Amiga pseudo-driver to access 16bit-RAM in ZorroII space
+ *         as a block device, to be used as a RAM disk or swap space
+ *
+ * Copyright (C) 1994 by Ingo Wilken (Ingo.Wilken@informatik.uni-oldenburg.de)
+ *
+ * ++Geert: support for zorro_unused_z2ram, better range checking
+ * ++roman: translate accesses via an array
+ * ++Milan: support for ChipRAM usage
+ * ++yambo: converted to 2.0 kernel
+ * ++yambo: modularized and support added for 3 minor devices including:
+ *          MAJOR  MINOR  DESCRIPTION
+ *          -----  -----  ----------------------------------------------
+ *          37     0       Use Zorro II and Chip ram
+ *          37     1       Use only Zorro II ram
+ *          37     2       Use only Chip ram
+ *          37     4-7     Use memory list entry 1-4 (first is 0)
+ * ++jskov: support for 1-4th memory list entry.
+ *
+ * Permission to use, copy, modify, and distribute this software and its
+ * documentation for any purpose and without fee is hereby granted, provided
+ * that the above copyright notice appear in all copies and that both that
+ * copyright notice and this permission notice appear in supporting
+ * documentation.  This software is provided "as is" without express or
+ * implied warranty.
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 #define DEVICE_NAME "Z2RAM"
 
 #include <linux/major.h>
@@ -51,7 +52,7 @@
 #define Z2MINOR_MEMLIST4      (7)
 #define Z2MINOR_COUNT         (8)	/* Move this down when adding a new minor */
 
-#define Z2RAM_CHUNK1024       ( Z2RAM_CHUNKSIZE >> 10 )
+#define Z2RAM_CHUNK1024       (Z2RAM_CHUNKSIZE >> 10)
 
 static DEFINE_MUTEX(z2ram_mutex);
 static u_long *z2ram_map = NULL;
@@ -75,8 +76,7 @@ static blk_status_t z2_queue_rq(struct blk_mq_hw_ctx *hctx,
 	blk_mq_start_request(req);
 
 	if (start + len > z2ram_size) {
-		pr_err(DEVICE_NAME ": bad access: block=%llu, "
-		       "count=%u\n",
+		pr_err("bad access: block=%llu, count=%u\n",
 		       (unsigned long long)blk_rq_pos(req),
 		       blk_rq_cur_sectors(req));
 		return BLK_STS_IOERR;
@@ -93,9 +93,9 @@ static blk_status_t z2_queue_rq(struct blk_mq_hw_ctx *hctx,
 			size = len;
 		addr += z2ram_map[start >> Z2RAM_CHUNKSHIFT];
 		if (rq_data_dir(req) == READ)
-			memcpy(buffer, (char *)addr, size);
+			memcpy(buffer, (void *)addr, size);
 		else
-			memcpy((char *)addr, buffer, size);
+			memcpy((void *)addr, buffer, size);
 		start += size;
 		len -= size;
 	}
@@ -107,37 +107,29 @@ static blk_status_t z2_queue_rq(struct blk_mq_hw_ctx *hctx,
 
 static void get_z2ram(void)
 {
+	unsigned long vaddr = (unsigned long)ZTWO_VADDR(Z2RAM_START);
 	int i;
 
 	for (i = 0; i < Z2RAM_SIZE / Z2RAM_CHUNKSIZE; i++) {
-		if (test_bit(i, zorro_unused_z2ram)) {
-			z2_count++;
-			z2ram_map[z2ram_size++] =
-			    (unsigned long)ZTWO_VADDR(Z2RAM_START) +
-			    (i << Z2RAM_CHUNKSHIFT);
-			clear_bit(i, zorro_unused_z2ram);
-		}
+		if (!test_and_clear_bit(i, zorro_unused_z2ram))
+			continue;
+		z2_count++;
+		z2ram_map[z2ram_size++] = vaddr + (i << Z2RAM_CHUNKSHIFT);
 	}
-
-	return;
 }
 
 static void get_chipram(void)
 {
-
 	while (amiga_chip_avail() > (Z2RAM_CHUNKSIZE * 4)) {
 		chip_count++;
 		z2ram_map[z2ram_size] =
-		    (u_long) amiga_chip_alloc(Z2RAM_CHUNKSIZE, "z2ram");
+		    (u_long)amiga_chip_alloc(Z2RAM_CHUNKSIZE, "z2ram");
 
-		if (z2ram_map[z2ram_size] == 0) {
+		if (z2ram_map[z2ram_size] == 0)
 			break;
-		}
 
 		z2ram_size++;
 	}
-
-	return;
 }
 
 static int z2_open(struct block_device *bdev, fmode_t mode)
@@ -146,146 +138,120 @@ static int z2_open(struct block_device *bdev, fmode_t mode)
 	int max_z2_map = (Z2RAM_SIZE / Z2RAM_CHUNKSIZE) * sizeof(z2ram_map[0]);
 	int max_chip_map = (amiga_chip_size / Z2RAM_CHUNKSIZE) *
 	    sizeof(z2ram_map[0]);
-	int rc = -ENOMEM;
+	int ret = -ENOMEM;
 
 	device = MINOR(bdev->bd_dev);
 
 	mutex_lock(&z2ram_mutex);
-	if (current_device != -1 && current_device != device) {
-		rc = -EBUSY;
-		goto err_out;
+	if (current_device != -1) {
+		ret = (current_device != device) ? -EBUSY : 0;
+		mutex_unlock(&z2ram_mutex);
+		return ret;
 	}
 
-	if (current_device == -1) {
-		z2_count = 0;
-		chip_count = 0;
-		list_count = 0;
-		z2ram_size = 0;
-
-		/* Use a specific list entry. */
-		if (device >= Z2MINOR_MEMLIST1 && device <= Z2MINOR_MEMLIST4) {
-			int index = device - Z2MINOR_MEMLIST1 + 1;
-			unsigned long size, paddr, vaddr;
-
-			if (index >= m68k_realnum_memory) {
-				printk(KERN_ERR DEVICE_NAME
-				       ": no such entry in z2ram_map\n");
-				goto err_out;
-			}
+	z2_count = 0;
+	chip_count = 0;
+	list_count = 0;
+	z2ram_size = 0;
 
-			paddr = m68k_memory[index].addr;
-			size = m68k_memory[index].size & ~(Z2RAM_CHUNKSIZE - 1);
+	/* Use a specific list entry. */
+	if (device >= Z2MINOR_MEMLIST1 && device <= Z2MINOR_MEMLIST4) {
+		int index = device - Z2MINOR_MEMLIST1 + 1;
+		unsigned long size, paddr, vaddr;
+
+		if (index >= m68k_realnum_memory) {
+			pr_err("no such entry in z2ram_map\n");
+			goto err_out;
+		}
+
+		paddr = m68k_memory[index].addr;
+		size = m68k_memory[index].size & ~(Z2RAM_CHUNKSIZE - 1);
 
 #ifdef __powerpc__
-			/* FIXME: ioremap doesn't build correct memory tables. */
-			{
-				vfree(vmalloc(size));
-			}
+		/* FIXME: ioremap doesn't build correct memory tables. */
+		{
+			vfree(vmalloc(size));
+		}
 
-			vaddr = (unsigned long)ioremap_wt(paddr, size);
+		vaddr = (unsigned long)ioremap_wt(paddr, size);
 
 #else
-			vaddr =
-			    (unsigned long)z_remap_nocache_nonser(paddr, size);
+		vaddr = (unsigned long)z_remap_nocache_nonser(paddr, size);
 #endif
-			z2ram_map =
-			    kmalloc_array(size / Z2RAM_CHUNKSIZE,
+		z2ram_map = kmalloc_array(size / Z2RAM_CHUNKSIZE,
 					  sizeof(z2ram_map[0]), GFP_KERNEL);
-			if (z2ram_map == NULL) {
-				printk(KERN_ERR DEVICE_NAME
-				       ": cannot get mem for z2ram_map\n");
+		if (!z2ram_map)
+			goto err_out;
+
+		while (size) {
+			z2ram_map[z2ram_size++] = vaddr;
+			size -= Z2RAM_CHUNKSIZE;
+			vaddr += Z2RAM_CHUNKSIZE;
+			list_count++;
+		}
+
+		if (z2ram_size != 0)
+			pr_info("using %iK List Entry %d Memory\n",
+				list_count * Z2RAM_CHUNK1024, index);
+	} else {
+		switch (device) {
+		case Z2MINOR_COMBINED:
+
+			z2ram_map = kmalloc(max_z2_map + max_chip_map,
+					    GFP_KERNEL);
+			if (!z2ram_map)
 				goto err_out;
-			}
 
-			while (size) {
-				z2ram_map[z2ram_size++] = vaddr;
-				size -= Z2RAM_CHUNKSIZE;
-				vaddr += Z2RAM_CHUNKSIZE;
-				list_count++;
-			}
+			get_z2ram();
+			get_chipram();
 
 			if (z2ram_size != 0)
-				printk(KERN_INFO DEVICE_NAME
-				       ": using %iK List Entry %d Memory\n",
-				       list_count * Z2RAM_CHUNK1024, index);
-		} else
-			switch (device) {
-			case Z2MINOR_COMBINED:
-
-				z2ram_map =
-				    kmalloc(max_z2_map + max_chip_map,
-					    GFP_KERNEL);
-				if (z2ram_map == NULL) {
-					printk(KERN_ERR DEVICE_NAME
-					       ": cannot get mem for z2ram_map\n");
-					goto err_out;
-				}
-
-				get_z2ram();
-				get_chipram();
-
-				if (z2ram_size != 0)
-					printk(KERN_INFO DEVICE_NAME
-					       ": using %iK Zorro II RAM and %iK Chip RAM (Total %dK)\n",
-					       z2_count * Z2RAM_CHUNK1024,
-					       chip_count * Z2RAM_CHUNK1024,
-					       (z2_count +
-						chip_count) * Z2RAM_CHUNK1024);
-
-				break;
-
-			case Z2MINOR_Z2ONLY:
-				z2ram_map = kmalloc(max_z2_map, GFP_KERNEL);
-				if (z2ram_map == NULL) {
-					printk(KERN_ERR DEVICE_NAME
-					       ": cannot get mem for z2ram_map\n");
-					goto err_out;
-				}
-
-				get_z2ram();
-
-				if (z2ram_size != 0)
-					printk(KERN_INFO DEVICE_NAME
-					       ": using %iK of Zorro II RAM\n",
-					       z2_count * Z2RAM_CHUNK1024);
-
-				break;
-
-			case Z2MINOR_CHIPONLY:
-				z2ram_map = kmalloc(max_chip_map, GFP_KERNEL);
-				if (z2ram_map == NULL) {
-					printk(KERN_ERR DEVICE_NAME
-					       ": cannot get mem for z2ram_map\n");
-					goto err_out;
-				}
-
-				get_chipram();
-
-				if (z2ram_size != 0)
-					printk(KERN_INFO DEVICE_NAME
-					       ": using %iK Chip RAM\n",
-					       chip_count * Z2RAM_CHUNK1024);
-
-				break;
-
-			default:
-				rc = -ENODEV;
+				pr_info("using %iK Zorro II RAM and %iK Chip RAM (Total %dK)\n",
+					z2_count * Z2RAM_CHUNK1024,
+					chip_count * Z2RAM_CHUNK1024,
+					(z2_count + chip_count) * Z2RAM_CHUNK1024);
+
+			break;
+
+		case Z2MINOR_Z2ONLY:
+			z2ram_map = kmalloc(max_z2_map, GFP_KERNEL);
+			if (!z2ram_map)
+				goto err_out;
+
+			get_z2ram();
+
+			if (z2ram_size != 0)
+				pr_info("using %iK of Zorro II RAM\n",
+					z2_count * Z2RAM_CHUNK1024);
+			break;
+
+		case Z2MINOR_CHIPONLY:
+			z2ram_map = kmalloc(max_chip_map, GFP_KERNEL);
+			if (!z2ram_map)
 				goto err_out;
 
-				break;
-			}
+			get_chipram();
 
-		if (z2ram_size == 0) {
-			printk(KERN_NOTICE DEVICE_NAME
-			       ": no unused ZII/Chip RAM found\n");
-			goto err_out_kfree;
+			if (z2ram_size != 0)
+				pr_info("using %iK Chip RAM\n",
+					chip_count * Z2RAM_CHUNK1024);
+			break;
+
+		default:
+			ret = -ENODEV;
+			goto err_out;
 		}
+	}
 
-		current_device = device;
-		z2ram_size <<= Z2RAM_CHUNKSHIFT;
-		set_capacity(z2ram_gendisk[device], z2ram_size >> 9);
+	if (z2ram_size == 0) {
+		pr_notice("no unused ZII/Chip RAM found\n");
+		goto err_out_kfree;
 	}
 
+	current_device = device;
+	z2ram_size <<= Z2RAM_CHUNKSHIFT;
+	set_capacity(z2ram_gendisk[device], z2ram_size >> 9);
+
 	mutex_unlock(&z2ram_mutex);
 	return 0;
 
@@ -293,7 +259,7 @@ static int z2_open(struct block_device *bdev, fmode_t mode)
 	kfree(z2ram_map);
 err_out:
 	mutex_unlock(&z2ram_mutex);
-	return rc;
+	return ret;
 }
 
 static void z2_release(struct gendisk *disk, fmode_t mode)
@@ -401,24 +367,18 @@ static void __exit z2_exit(void)
 	if (current_device != -1) {
 		i = 0;
 
-		for (j = 0; j < z2_count; j++) {
+		for (j = 0; j < z2_count; j++)
 			set_bit(i++, zorro_unused_z2ram);
-		}
 
 		for (j = 0; j < chip_count; j++) {
-			if (z2ram_map[i]) {
+			if (z2ram_map[i])
 				amiga_chip_free((void *)z2ram_map[i++]);
-			}
 		}
 
-		if (z2ram_map != NULL) {
-			kfree(z2ram_map);
-		}
+		kfree(z2ram_map);
 	}
-
-	return;
 }
 
 module_init(z2_init);
 module_exit(z2_exit);
-MODULE_LICENSE("GPL");
+MODULE_LICENSE("GPL and additional rights");


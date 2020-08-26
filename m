Return-Path: <SRS0=243Y=CE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C58BFC433E1
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Aug 2020 14:52:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9D9A42177B
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Aug 2020 14:52:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728080AbgHZOwG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 26 Aug 2020 10:52:06 -0400
Received: from smtprelay0022.hostedemail.com ([216.40.44.22]:57342 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727115AbgHZOwA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 26 Aug 2020 10:52:00 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay08.hostedemail.com (Postfix) with ESMTP id 6E608182CF66C;
        Wed, 26 Aug 2020 14:51:50 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: spy71_140719227065
X-Filterd-Recvd-Size: 11777
Received: from XPS-9350.home (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf11.hostedemail.com (Postfix) with ESMTPA;
        Wed, 26 Aug 2020 14:51:47 +0000 (UTC)
Message-ID: <b88538f92386f41b938c502ae2daec5800a85dcf.camel@perches.com>
Subject: Re: [PATCH 17/19] z2ram: reindent
From:   Joe Perches <joe@perches.com>
To:     John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Denis Efremov <efremov@linux.com>,
        "David S. Miller" <davem@davemloft.net>,
        Song Liu <song@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-m68k@lists.linux-m68k.org
Date:   Wed, 26 Aug 2020 07:51:46 -0700
In-Reply-To: <EF673A30-F88D-4E4E-8A2B-E942153830AC@physik.fu-berlin.de>
References: <8570915f668159f93ba2eb845a3bbc05f8ee3a99.camel@perches.com>
         <EF673A30-F88D-4E4E-8A2B-E942153830AC@physik.fu-berlin.de>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2020-08-26 at 11:49 +0200, John Paul Adrian Glaubitz wrote:
> > On Aug 26, 2020, at 11:21 AM, Joe Perches <joe@perches.com> wrote:
> > 
> > ﻿On Wed, 2020-08-26 at 08:24 +0200, Christoph Hellwig wrote:
> > > reindent the driver using Lident as the code style was far away from
> > > normal Linux code.
> > 
> > Why?  Does anyone use this anymore?
> 
> Yes, the Amiga and Linux/m68k is very well and alive.

That's fine.  My question was why ancient code should be modified
if it's not in use.

>  There is new hardware being developed and new drivers being developed and so on.

OK, fine.

btw:

If style only changes are to be done on this code then
I believe these changes on top should also be made done
for style:
---
From 0eb1b25575abe52415ecb0139e14ae57ba4f57cb Mon Sep 17 00:00:00 2001
Message-Id: <0eb1b25575abe52415ecb0139e14ae57ba4f57cb.1598453361.git.joe@perches.com>
From: Joe Perches <joe@perches.com>
Date: Wed, 26 Aug 2020 02:20:14 -0700
Subject: [PATCH] z2ram: Use more current coding style

Use pr_fmt and pr_<level>, continue, and remove tests against NULL.
Use more typical brace styles, add and remove them as appropriate.
Simplify logic in z2_open, rename err_out label to out, unindent a
large block by reversing the test and using goto.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/block/z2ram.c | 261 +++++++++++++++++++-----------------------
 1 file changed, 118 insertions(+), 143 deletions(-)

diff --git a/drivers/block/z2ram.c b/drivers/block/z2ram.c
index 566c653399d8..ea490fe4417e 100644
--- a/drivers/block/z2ram.c
+++ b/drivers/block/z2ram.c
@@ -1,7 +1,7 @@
 /*
 ** z2ram - Amiga pseudo-driver to access 16bit-RAM in ZorroII space
 **         as a block device, to be used as a RAM disk or swap space
-** 
+**
 ** Copyright (C) 1994 by Ingo Wilken (Ingo.Wilken@informatik.uni-oldenburg.de)
 **
 ** ++Geert: support for zorro_unused_z2ram, better range checking
@@ -25,6 +25,8 @@
 ** implied warranty.
 */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #define DEVICE_NAME "Z2RAM"
 
 #include <linux/major.h>
@@ -75,7 +77,7 @@ static blk_status_t z2_queue_rq(struct blk_mq_hw_ctx *hctx,
 	blk_mq_start_request(req);
 
 	if (start + len > z2ram_size) {
-		pr_err(DEVICE_NAME ": bad access: block=%llu, count=%u\n",
+		pr_err("bad access: block=%llu, count=%u\n",
 		       (unsigned long long)blk_rq_pos(req),
 		       blk_rq_cur_sectors(req));
 		return BLK_STS_IOERR;
@@ -109,34 +111,28 @@ static void get_z2ram(void)
 	int i;
 
 	for (i = 0; i < Z2RAM_SIZE / Z2RAM_CHUNKSIZE; i++) {
-		if (test_bit(i, zorro_unused_z2ram)) {
-			z2_count++;
-			z2ram_map[z2ram_size++] =
-			    (unsigned long)ZTWO_VADDR(Z2RAM_START) +
-			    (i << Z2RAM_CHUNKSHIFT);
-			clear_bit(i, zorro_unused_z2ram);
-		}
+		if (!test_bit(i, zorro_unused_z2ram))
+			continue;
+		z2_count++;
+		z2ram_map[z2ram_size++] =
+			(unsigned long)ZTWO_VADDR(Z2RAM_START) +
+			(i << Z2RAM_CHUNKSHIFT);
+		clear_bit(i, zorro_unused_z2ram);
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
 		    (u_long) amiga_chip_alloc(Z2RAM_CHUNKSIZE, "z2ram");
 
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
@@ -152,144 +148,127 @@ static int z2_open(struct block_device *bdev, fmode_t mode)
 	mutex_lock(&z2ram_mutex);
 	if (current_device != -1 && current_device != device) {
 		rc = -EBUSY;
-		goto err_out;
+		goto out;
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
+	if (current_device != -1) {
+		rc = 0;
+		goto out;
+	}
 
-			paddr = m68k_memory[index].addr;
-			size = m68k_memory[index].size & ~(Z2RAM_CHUNKSIZE - 1);
+	z2_count = 0;
+	chip_count = 0;
+	list_count = 0;
+	z2ram_size = 0;
 
-#ifdef __powerpc__
-			/*
-			 * FIXME: ioremap doesn't build correct memory tables.
-			 */
-			vfree(vmalloc(size));
-			vaddr = (unsigned long)ioremap_wt(paddr, size);
+	/* Use a specific list entry. */
+	if (device >= Z2MINOR_MEMLIST1 && device <= Z2MINOR_MEMLIST4) {
+		int index = device - Z2MINOR_MEMLIST1 + 1;
+		unsigned long size, paddr, vaddr;
+
+		if (index >= m68k_realnum_memory) {
+			pr_err("no such entry in z2ram_map\n");
+			goto out;
+		}
 
+		paddr = m68k_memory[index].addr;
+		size = m68k_memory[index].size & ~(Z2RAM_CHUNKSIZE - 1);
+
+#ifdef __powerpc__
+		/*
+		 * FIXME: ioremap doesn't build correct memory tables.
+		 */
+		vfree(vmalloc(size));
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
-				goto err_out;
+		if (!z2ram_map) {
+			pr_err("cannot get mem for z2ram_map\n");
+			goto out;
+		}
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
+			z2ram_map = kmalloc(max_z2_map + max_chip_map,
+					    GFP_KERNEL);
+			if (!z2ram_map) {
+				pr_err("cannot get mem for z2ram_map\n");
+				goto out;
 			}
 
-			while (size) {
-				z2ram_map[z2ram_size++] = vaddr;
-				size -= Z2RAM_CHUNKSIZE;
-				vaddr += Z2RAM_CHUNKSIZE;
-				list_count++;
+			get_z2ram();
+			get_chipram();
+
+			if (z2ram_size != 0)
+				pr_info("using %iK Zorro II RAM and %iK Chip RAM (Total %dK)\n",
+					z2_count * Z2RAM_CHUNK1024,
+					chip_count * Z2RAM_CHUNK1024,
+					(z2_count + chip_count) * Z2RAM_CHUNK1024);
+
+			break;
+
+		case Z2MINOR_Z2ONLY:
+			z2ram_map = kmalloc(max_z2_map, GFP_KERNEL);
+			if (!z2ram_map) {
+				pr_err("cannot get mem for z2ram_map\n");
+				goto out;
 			}
 
+			get_z2ram();
+
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
-				goto err_out;
-
-				break;
+				pr_info("using %iK of Zorro II RAM\n",
+					z2_count * Z2RAM_CHUNK1024);
+
+			break;
+
+		case Z2MINOR_CHIPONLY:
+			z2ram_map = kmalloc(max_chip_map, GFP_KERNEL);
+			if (!z2ram_map) {
+				pr_err("cannot get mem for z2ram_map\n");
+				goto out;
 			}
 
-		if (z2ram_size == 0) {
-			printk(KERN_NOTICE DEVICE_NAME
-			       ": no unused ZII/Chip RAM found\n");
-			goto err_out_kfree;
+			get_chipram();
+
+			if (z2ram_size != 0)
+				pr_info("using %iK Chip RAM\n",
+					chip_count * Z2RAM_CHUNK1024);
+
+			break;
+
+		default:
+			rc = -ENODEV;
+			goto out;
 		}
+	}
 
-		current_device = device;
-		z2ram_size <<= Z2RAM_CHUNKSHIFT;
-		set_capacity(z2ram_gendisk, z2ram_size >> 9);
+	if (z2ram_size == 0) {
+		pr_notice("no unused ZII/Chip RAM found\n");
+		kfree(z2ram_map);
+		goto out;
 	}
 
-	mutex_unlock(&z2ram_mutex);
-	return 0;
+	current_device = device;
+	z2ram_size <<= Z2RAM_CHUNKSHIFT;
+	set_capacity(z2ram_gendisk, z2ram_size >> 9);
+	rc = 0;
 
-err_out_kfree:
-	kfree(z2ram_map);
-err_out:
+out:
 	mutex_unlock(&z2ram_mutex);
 	return rc;
 }
@@ -372,7 +351,6 @@ static int __init z2_init(void)
 
 static void __exit z2_exit(void)
 {
-	int i, j;
 	blk_unregister_region(MKDEV(Z2RAM_MAJOR, 0), Z2MINOR_COUNT);
 	unregister_blkdev(Z2RAM_MAJOR, DEVICE_NAME);
 	del_gendisk(z2ram_gendisk);
@@ -381,24 +359,21 @@ static void __exit z2_exit(void)
 	blk_mq_free_tag_set(&tag_set);
 
 	if (current_device != -1) {
+		int i, j;
+
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
+		if (z2ram_map)
 			kfree(z2ram_map);
-		}
 	}
-
-	return;
 }
 
 module_init(z2_init);
-- 
2.26.0



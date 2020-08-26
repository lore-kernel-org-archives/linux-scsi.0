Return-Path: <SRS0=243Y=CE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AFBBC433DF
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Aug 2020 06:29:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 293592076C
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Aug 2020 06:29:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="POAOciC7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726723AbgHZG3Q (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 26 Aug 2020 02:29:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725786AbgHZG3P (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Aug 2020 02:29:15 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9655C061574;
        Tue, 25 Aug 2020 23:29:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=fqxehQh20NrUpl/SD72j9k2F7K2qBABbI+vFeJu48nw=; b=POAOciC7kyLlHW/EUwN/1Bakq8
        U63+XXkyPpWFR6Df6bIZ7HhKafZs9qD0RaONQIiU87WtdZ61uvGuuSG/7hhwgY8dIeJoOKhSpFbCW
        rmpq8FLcfriscssg5XM9qw042ucX9f57Tzz0G0rSLb4Q8ZaF5WYI4Gz8t0CVoALLcXhXcp8eFJXID
        Eg0+4gtUL2pCmytTG/mTVqV7tEDVf6i7rd7Ugm8k40rb0I6Tz9TZJr4k/NGuv0Uf0y2YKMM3EQMUf
        vf3Qv/c5WHXIwTObA1J4D0SWStqjAueG2fufW2ECri9+XtAi4Ac0NKZWhNHrJv2gAMp2Oro2KLUpN
        UIbZM91w==;
Received: from 213-225-6-196.nat.highway.a1.net ([213.225.6.196] helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kAovk-0000u6-JT; Wed, 26 Aug 2020 06:29:08 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Denis Efremov <efremov@linux.com>,
        "David S. Miller" <davem@davemloft.net>,
        Song Liu <song@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-m68k@lists.linux-m68k.org
Subject: [PATCH 01/19] char_dev: replace cdev_map with an xarray
Date:   Wed, 26 Aug 2020 08:24:28 +0200
Message-Id: <20200826062446.31860-2-hch@lst.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200826062446.31860-1-hch@lst.de>
References: <20200826062446.31860-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

None of the complicated overlapping regions bits of the kobj_map are
required for the character device lookup, so just a trivial xarray
instead.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/char_dev.c | 94 +++++++++++++++++++++++++--------------------------
 fs/dcache.c   |  1 -
 fs/internal.h |  5 ---
 3 files changed, 46 insertions(+), 54 deletions(-)

diff --git a/fs/char_dev.c b/fs/char_dev.c
index ba0ded7842a779..6c4d6c4938f14b 100644
--- a/fs/char_dev.c
+++ b/fs/char_dev.c
@@ -17,7 +17,6 @@
 #include <linux/seq_file.h>
 
 #include <linux/kobject.h>
-#include <linux/kobj_map.h>
 #include <linux/cdev.h>
 #include <linux/mutex.h>
 #include <linux/backing-dev.h>
@@ -25,8 +24,7 @@
 
 #include "internal.h"
 
-static struct kobj_map *cdev_map;
-
+static DEFINE_XARRAY(cdev_map);
 static DEFINE_MUTEX(chrdevs_lock);
 
 #define CHRDEV_MAJOR_HASH_SIZE 255
@@ -367,6 +365,29 @@ void cdev_put(struct cdev *p)
 	}
 }
 
+static struct cdev *cdev_lookup(dev_t dev)
+{
+	struct cdev *cdev;
+
+retry:
+	mutex_lock(&chrdevs_lock);
+	cdev = xa_load(&cdev_map, dev);
+	if (!cdev) {
+		mutex_unlock(&chrdevs_lock);
+
+		if (request_module("char-major-%d-%d",
+				   MAJOR(dev), MINOR(dev)) > 0)
+			/* Make old-style 2.4 aliases work */
+			request_module("char-major-%d", MAJOR(dev));
+		goto retry;
+	}
+
+	if (!cdev_get(cdev))
+		cdev = NULL;
+	mutex_unlock(&chrdevs_lock);
+	return cdev;
+}
+
 /*
  * Called every time a character special file is opened
  */
@@ -380,13 +401,10 @@ static int chrdev_open(struct inode *inode, struct file *filp)
 	spin_lock(&cdev_lock);
 	p = inode->i_cdev;
 	if (!p) {
-		struct kobject *kobj;
-		int idx;
 		spin_unlock(&cdev_lock);
-		kobj = kobj_lookup(cdev_map, inode->i_rdev, &idx);
-		if (!kobj)
+		new = cdev_lookup(inode->i_rdev);
+		if (!new)
 			return -ENXIO;
-		new = container_of(kobj, struct cdev, kobj);
 		spin_lock(&cdev_lock);
 		/* Check i_cdev again in case somebody beat us to it while
 		   we dropped the lock. */
@@ -454,18 +472,6 @@ const struct file_operations def_chr_fops = {
 	.llseek = noop_llseek,
 };
 
-static struct kobject *exact_match(dev_t dev, int *part, void *data)
-{
-	struct cdev *p = data;
-	return &p->kobj;
-}
-
-static int exact_lock(dev_t dev, void *data)
-{
-	struct cdev *p = data;
-	return cdev_get(p) ? 0 : -1;
-}
-
 /**
  * cdev_add() - add a char device to the system
  * @p: the cdev structure for the device
@@ -478,7 +484,7 @@ static int exact_lock(dev_t dev, void *data)
  */
 int cdev_add(struct cdev *p, dev_t dev, unsigned count)
 {
-	int error;
+	int error, i;
 
 	p->dev = dev;
 	p->count = count;
@@ -486,14 +492,22 @@ int cdev_add(struct cdev *p, dev_t dev, unsigned count)
 	if (WARN_ON(dev == WHITEOUT_DEV))
 		return -EBUSY;
 
-	error = kobj_map(cdev_map, dev, count, NULL,
-			 exact_match, exact_lock, p);
-	if (error)
-		return error;
+	mutex_lock(&chrdevs_lock);
+	for (i = 0; i < count; i++) {
+		error = xa_insert(&cdev_map, dev + i, p, GFP_KERNEL);
+		if (error)
+			goto out_unwind;
+	}
+	mutex_unlock(&chrdevs_lock);
 
 	kobject_get(p->kobj.parent);
-
 	return 0;
+
+out_unwind:
+	while (--i >= 0)
+		xa_erase(&cdev_map, dev + i);
+	mutex_unlock(&chrdevs_lock);
+	return error;
 }
 
 /**
@@ -575,11 +589,6 @@ void cdev_device_del(struct cdev *cdev, struct device *dev)
 		cdev_del(cdev);
 }
 
-static void cdev_unmap(dev_t dev, unsigned count)
-{
-	kobj_unmap(cdev_map, dev, count);
-}
-
 /**
  * cdev_del() - remove a cdev from the system
  * @p: the cdev structure to be removed
@@ -593,10 +602,13 @@ static void cdev_unmap(dev_t dev, unsigned count)
  */
 void cdev_del(struct cdev *p)
 {
-	cdev_unmap(p->dev, p->count);
-	kobject_put(&p->kobj);
-}
+	int i;
 
+	mutex_lock(&chrdevs_lock);
+	for (i = 0; i < p->count; i++)
+		xa_erase(&cdev_map, p->dev + i);
+	mutex_unlock(&chrdevs_lock);
+}
 
 static void cdev_default_release(struct kobject *kobj)
 {
@@ -656,20 +668,6 @@ void cdev_init(struct cdev *cdev, const struct file_operations *fops)
 	cdev->ops = fops;
 }
 
-static struct kobject *base_probe(dev_t dev, int *part, void *data)
-{
-	if (request_module("char-major-%d-%d", MAJOR(dev), MINOR(dev)) > 0)
-		/* Make old-style 2.4 aliases work */
-		request_module("char-major-%d", MAJOR(dev));
-	return NULL;
-}
-
-void __init chrdev_init(void)
-{
-	cdev_map = kobj_map_init(base_probe, &chrdevs_lock);
-}
-
-
 /* Let modules do char dev stuff */
 EXPORT_SYMBOL(register_chrdev_region);
 EXPORT_SYMBOL(unregister_chrdev_region);
diff --git a/fs/dcache.c b/fs/dcache.c
index ea0485861d9377..55e534ad6f8f7f 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -3233,5 +3233,4 @@ void __init vfs_caches_init(void)
 	files_maxfiles_init();
 	mnt_init();
 	bdev_cache_init();
-	chrdev_init();
 }
diff --git a/fs/internal.h b/fs/internal.h
index 10517ece45167f..110e952e75a8aa 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -54,11 +54,6 @@ static inline void bd_forget(struct inode *inode)
 extern int __block_write_begin_int(struct page *page, loff_t pos, unsigned len,
 		get_block_t *get_block, struct iomap *iomap);
 
-/*
- * char_dev.c
- */
-extern void __init chrdev_init(void);
-
 /*
  * fs_context.c
  */
-- 
2.28.0


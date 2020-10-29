Return-Path: <SRS0=Vgdy=EE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6C24C56201
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Oct 2020 15:05:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5CCDE2076E
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Oct 2020 15:05:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ASnCR9qI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728025AbgJ2PFd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Oct 2020 11:05:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727048AbgJ2PFc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Oct 2020 11:05:32 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE056C0613D2;
        Thu, 29 Oct 2020 08:05:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=1xf9vIrBcurBVDY7G2ISkg6IFgku9NAy9qOlTzU7bWc=; b=ASnCR9qIaY/6KL3KbEYVs6xQkM
        2SaAzJcPo639CQk11qq+g/3pDHxdXVpAGpEEB+w+flTOh+9jN1fCcE+Ld99LG/O07j5siXEK/hmqr
        25WsdUcQm36FO+wyAkvNLRKUSkdlsL/3aizVHPwdX/nREv3fYPYdHId4yjFGZ0huM9RAdN8Zny8os
        Cf546oWodcUWSlrvDVrF/cbauRcmmOlJTauVTctzWFQlQlLWvaY69qGI3xfUiXbqPDZWl4cOBuGgw
        wodZycr5yfA6b5ZNf2s6SkTZsS8Fj2e0SptHSlKKD7qv7nsd+lC+hILCcDfJGR19bT8KDe7iVxeko
        /Q3wCMAw==;
Received: from 089144193201.atnat0002.highway.a1.net ([89.144.193.201] helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kY9UO-0005jJ-K6; Thu, 29 Oct 2020 15:05:22 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Denis Efremov <efremov@linux.com>,
        "David S. Miller" <davem@davemloft.net>,
        Song Liu <song@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Finn Thain <fthain@telegraphics.com.au>,
        Michael Schmitz <schmitzmic@gmail.com>,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-m68k@lists.linux-m68k.org
Subject: [PATCH 02/18] block: open code kobj_map into in block/genhd.c
Date:   Thu, 29 Oct 2020 15:58:25 +0100
Message-Id: <20201029145841.144173-3-hch@lst.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201029145841.144173-1-hch@lst.de>
References: <20201029145841.144173-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Copy and paste the kobj_map functionality in the block code in preparation
for completely rewriting it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/genhd.c | 130 +++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 117 insertions(+), 13 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index 3ed591970ea640..0e22ca64aca09e 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -17,7 +17,6 @@
 #include <linux/seq_file.h>
 #include <linux/slab.h>
 #include <linux/kmod.h>
-#include <linux/kobj_map.h>
 #include <linux/mutex.h>
 #include <linux/idr.h>
 #include <linux/log2.h>
@@ -29,6 +28,16 @@
 static DEFINE_MUTEX(block_class_lock);
 static struct kobject *block_depr;
 
+struct bdev_map {
+	struct bdev_map *next;
+	dev_t dev;
+	unsigned long range;
+	struct module *owner;
+	struct kobject *(*probe)(dev_t, int *, void *);
+	int (*lock)(dev_t, void *);
+	void *data;
+} *bdev_map[255];
+
 /* for extended dynamic devt allocation, currently only one major is used */
 #define NR_EXT_DEVT		(1 << MINORBITS)
 
@@ -517,8 +526,6 @@ void unregister_blkdev(unsigned int major, const char *name)
 
 EXPORT_SYMBOL(unregister_blkdev);
 
-static struct kobj_map *bdev_map;
-
 /**
  * blk_mangle_minor - scatter minor numbers apart
  * @minor: minor number to mangle
@@ -645,16 +652,60 @@ void blk_register_region(dev_t devt, unsigned long range, struct module *module,
 			 struct kobject *(*probe)(dev_t, int *, void *),
 			 int (*lock)(dev_t, void *), void *data)
 {
-	kobj_map(bdev_map, devt, range, module, probe, lock, data);
-}
+	unsigned n = MAJOR(devt + range - 1) - MAJOR(devt) + 1;
+	unsigned index = MAJOR(devt);
+	unsigned i;
+	struct bdev_map *p;
+
+	n = min(n, 255u);
+	p = kmalloc_array(n, sizeof(struct bdev_map), GFP_KERNEL);
+	if (p == NULL)
+		return;
 
+	for (i = 0; i < n; i++, p++) {
+		p->owner = module;
+		p->probe = probe;
+		p->lock = lock;
+		p->dev = devt;
+		p->range = range;
+		p->data = data;
+	}
+
+	mutex_lock(&block_class_lock);
+	for (i = 0, p -= n; i < n; i++, p++, index++) {
+		struct bdev_map **s = &bdev_map[index % 255];
+		while (*s && (*s)->range < range)
+			s = &(*s)->next;
+		p->next = *s;
+		*s = p;
+	}
+	mutex_unlock(&block_class_lock);
+}
 EXPORT_SYMBOL(blk_register_region);
 
 void blk_unregister_region(dev_t devt, unsigned long range)
 {
-	kobj_unmap(bdev_map, devt, range);
-}
+	unsigned n = MAJOR(devt + range - 1) - MAJOR(devt) + 1;
+	unsigned index = MAJOR(devt);
+	unsigned i;
+	struct bdev_map *found = NULL;
 
+	mutex_lock(&block_class_lock);
+	for (i = 0; i < min(n, 255u); i++, index++) {
+		struct bdev_map **s;
+		for (s = &bdev_map[index % 255]; *s; s = &(*s)->next) {
+			struct bdev_map *p = *s;
+			if (p->dev == devt && p->range == range) {
+				*s = p->next;
+				if (!found)
+					found = p;
+				break;
+			}
+		}
+	}
+	mutex_unlock(&block_class_lock);
+	kfree(found);
+}
 EXPORT_SYMBOL(blk_unregister_region);
 
 static struct kobject *exact_match(dev_t devt, int *partno, void *data)
@@ -976,6 +1027,47 @@ static ssize_t disk_badblocks_store(struct device *dev,
 	return badblocks_store(disk->bb, page, len, 0);
 }
 
+static struct gendisk *lookup_gendisk(dev_t dev, int *partno)
+{
+	struct kobject *kobj;
+	struct bdev_map *p;
+	unsigned long best = ~0UL;
+
+retry:
+	mutex_lock(&block_class_lock);
+	for (p = bdev_map[MAJOR(dev) % 255]; p; p = p->next) {
+		struct kobject *(*probe)(dev_t, int *, void *);
+		struct module *owner;
+		void *data;
+
+		if (p->dev > dev || p->dev + p->range - 1 < dev)
+			continue;
+		if (p->range - 1 >= best)
+			break;
+		if (!try_module_get(p->owner))
+			continue;
+		owner = p->owner;
+		data = p->data;
+		probe = p->probe;
+		best = p->range - 1;
+		*partno = dev - p->dev;
+		if (p->lock && p->lock(dev, data) < 0) {
+			module_put(owner);
+			continue;
+		}
+		mutex_unlock(&block_class_lock);
+		kobj = probe(dev, partno, data);
+		/* Currently ->owner protects _only_ ->probe() itself. */
+		module_put(owner);
+		if (kobj)
+			return dev_to_disk(kobj_to_dev(kobj));
+		goto retry;
+	}
+	mutex_unlock(&block_class_lock);
+	return NULL;
+}
+
+
 /**
  * get_gendisk - get partitioning information for a given device
  * @devt: device to get partitioning information for
@@ -993,11 +1085,7 @@ struct gendisk *get_gendisk(dev_t devt, int *partno)
 	might_sleep();
 
 	if (MAJOR(devt) != BLOCK_EXT_MAJOR) {
-		struct kobject *kobj;
-
-		kobj = kobj_lookup(bdev_map, devt, partno);
-		if (kobj)
-			disk = dev_to_disk(kobj_to_dev(kobj));
+		disk = lookup_gendisk(devt, partno);
 	} else {
 		struct hd_struct *part;
 
@@ -1210,6 +1298,22 @@ static struct kobject *base_probe(dev_t devt, int *partno, void *data)
 	return NULL;
 }
 
+static void bdev_map_init(void)
+{
+	struct bdev_map *base;
+	int i;
+
+	base = kzalloc(sizeof(*base), GFP_KERNEL);
+	if (!base)
+		panic("cannot allocate bdev_map");
+
+	base->dev = 1;
+	base->range = ~0 ;
+	base->probe = base_probe;
+	for (i = 0; i < 255; i++)
+		bdev_map[i] = base;
+}
+
 static int __init genhd_device_init(void)
 {
 	int error;
@@ -1218,7 +1322,7 @@ static int __init genhd_device_init(void)
 	error = class_register(&block_class);
 	if (unlikely(error))
 		return error;
-	bdev_map = kobj_map_init(base_probe, &block_class_lock);
+	bdev_map_init();
 	blk_dev_init();
 
 	register_blkdev(BLOCK_EXT_MAJOR, "blkext");
-- 
2.28.0


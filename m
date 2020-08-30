Return-Path: <SRS0=rOw5=CI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0916EC433E7
	for <linux-scsi@archiver.kernel.org>; Sun, 30 Aug 2020 06:27:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D1C6820693
	for <linux-scsi@archiver.kernel.org>; Sun, 30 Aug 2020 06:27:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="B6aPzeo2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728897AbgH3G1d (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 30 Aug 2020 02:27:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726013AbgH3GY6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 30 Aug 2020 02:24:58 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A68BC061575;
        Sat, 29 Aug 2020 23:24:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=d3Q4H4zEkwust7I5kHwM1otkI4VOyWTpVXJQ7pTIBR8=; b=B6aPzeo2k/zT2VMlnfIkZQ/5C0
        R3qm9aCDkCA/0MsypUDTeZhXxd888x7b1AS0e8S6GyWtcfjXwnz40ObQzMuIA0PUBnuf3y8bxMkIu
        3oyit5XPc7qcWIsxdB38BugVucRbQsUybMTjkt2LwK8SU6FpwsMkA4nhT6XcemTUabmuzUHEQ/rb6
        Chb99raglcWiygM8HY0dbpKXDoBJHcPekQ9N6wNnKfrYVj1q3O4L5XdTjpLtdj7hdkqF+1GQ5ui+R
        cMEGxx08Fie90zXT1qox8TwSSMralganC7uyVDP1n0QnjvQCeiR/ilj/D9laGzfU+IQ62yfaHx27d
        fXoP4Afw==;
Received: from [2001:4bb8:18c:45ba:9892:9e86:5202:32f0] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kCGlj-0002MG-Sr; Sun, 30 Aug 2020 06:24:48 +0000
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
Subject: [PATCH 02/19] block: merge drivers/base/map.c into block/genhd.c
Date:   Sun, 30 Aug 2020 08:24:28 +0200
Message-Id: <20200830062445.1199128-3-hch@lst.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200830062445.1199128-1-hch@lst.de>
References: <20200830062445.1199128-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Now that there is just a single user of the kobj_map functionality left,
merge it into the user to prepare for additional simplications.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/genhd.c            | 130 +++++++++++++++++++++++++++++----
 drivers/base/Makefile    |   2 +-
 drivers/base/map.c       | 154 ---------------------------------------
 include/linux/kobj_map.h |  20 -----
 4 files changed, 118 insertions(+), 188 deletions(-)
 delete mode 100644 drivers/base/map.c
 delete mode 100644 include/linux/kobj_map.h

diff --git a/block/genhd.c b/block/genhd.c
index 99c64641c3148c..cb9a51be35b053 100644
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
 
@@ -520,8 +529,6 @@ void unregister_blkdev(unsigned int major, const char *name)
 
 EXPORT_SYMBOL(unregister_blkdev);
 
-static struct kobj_map *bdev_map;
-
 /**
  * blk_mangle_minor - scatter minor numbers apart
  * @minor: minor number to mangle
@@ -648,16 +655,60 @@ void blk_register_region(dev_t devt, unsigned long range, struct module *module,
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
@@ -983,6 +1034,47 @@ static ssize_t disk_badblocks_store(struct device *dev,
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
@@ -1000,11 +1092,7 @@ struct gendisk *get_gendisk(dev_t devt, int *partno)
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
 
@@ -1217,6 +1305,22 @@ static struct kobject *base_probe(dev_t devt, int *partno, void *data)
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
@@ -1225,7 +1329,7 @@ static int __init genhd_device_init(void)
 	error = class_register(&block_class);
 	if (unlikely(error))
 		return error;
-	bdev_map = kobj_map_init(base_probe, &block_class_lock);
+	bdev_map_init();
 	blk_dev_init();
 
 	register_blkdev(BLOCK_EXT_MAJOR, "blkext");
diff --git a/drivers/base/Makefile b/drivers/base/Makefile
index 157452080f3d7f..4ffd2a785f5ed3 100644
--- a/drivers/base/Makefile
+++ b/drivers/base/Makefile
@@ -3,7 +3,7 @@
 
 obj-y			:= component.o core.o bus.o dd.o syscore.o \
 			   driver.o class.o platform.o \
-			   cpu.o firmware.o init.o map.o devres.o \
+			   cpu.o firmware.o init.o devres.o \
 			   attribute_container.o transport_class.o \
 			   topology.o container.o property.o cacheinfo.o \
 			   devcon.o swnode.o
diff --git a/drivers/base/map.c b/drivers/base/map.c
deleted file mode 100644
index 5650ab2b247ada..00000000000000
--- a/drivers/base/map.c
+++ /dev/null
@@ -1,154 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-/*
- *  linux/drivers/base/map.c
- *
- * (C) Copyright Al Viro 2002,2003
- *
- * NOTE: data structure needs to be changed.  It works, but for large dev_t
- * it will be too slow.  It is isolated, though, so these changes will be
- * local to that file.
- */
-
-#include <linux/module.h>
-#include <linux/slab.h>
-#include <linux/mutex.h>
-#include <linux/kdev_t.h>
-#include <linux/kobject.h>
-#include <linux/kobj_map.h>
-
-struct kobj_map {
-	struct probe {
-		struct probe *next;
-		dev_t dev;
-		unsigned long range;
-		struct module *owner;
-		kobj_probe_t *get;
-		int (*lock)(dev_t, void *);
-		void *data;
-	} *probes[255];
-	struct mutex *lock;
-};
-
-int kobj_map(struct kobj_map *domain, dev_t dev, unsigned long range,
-	     struct module *module, kobj_probe_t *probe,
-	     int (*lock)(dev_t, void *), void *data)
-{
-	unsigned n = MAJOR(dev + range - 1) - MAJOR(dev) + 1;
-	unsigned index = MAJOR(dev);
-	unsigned i;
-	struct probe *p;
-
-	if (n > 255)
-		n = 255;
-
-	p = kmalloc_array(n, sizeof(struct probe), GFP_KERNEL);
-	if (p == NULL)
-		return -ENOMEM;
-
-	for (i = 0; i < n; i++, p++) {
-		p->owner = module;
-		p->get = probe;
-		p->lock = lock;
-		p->dev = dev;
-		p->range = range;
-		p->data = data;
-	}
-	mutex_lock(domain->lock);
-	for (i = 0, p -= n; i < n; i++, p++, index++) {
-		struct probe **s = &domain->probes[index % 255];
-		while (*s && (*s)->range < range)
-			s = &(*s)->next;
-		p->next = *s;
-		*s = p;
-	}
-	mutex_unlock(domain->lock);
-	return 0;
-}
-
-void kobj_unmap(struct kobj_map *domain, dev_t dev, unsigned long range)
-{
-	unsigned n = MAJOR(dev + range - 1) - MAJOR(dev) + 1;
-	unsigned index = MAJOR(dev);
-	unsigned i;
-	struct probe *found = NULL;
-
-	if (n > 255)
-		n = 255;
-
-	mutex_lock(domain->lock);
-	for (i = 0; i < n; i++, index++) {
-		struct probe **s;
-		for (s = &domain->probes[index % 255]; *s; s = &(*s)->next) {
-			struct probe *p = *s;
-			if (p->dev == dev && p->range == range) {
-				*s = p->next;
-				if (!found)
-					found = p;
-				break;
-			}
-		}
-	}
-	mutex_unlock(domain->lock);
-	kfree(found);
-}
-
-struct kobject *kobj_lookup(struct kobj_map *domain, dev_t dev, int *index)
-{
-	struct kobject *kobj;
-	struct probe *p;
-	unsigned long best = ~0UL;
-
-retry:
-	mutex_lock(domain->lock);
-	for (p = domain->probes[MAJOR(dev) % 255]; p; p = p->next) {
-		struct kobject *(*probe)(dev_t, int *, void *);
-		struct module *owner;
-		void *data;
-
-		if (p->dev > dev || p->dev + p->range - 1 < dev)
-			continue;
-		if (p->range - 1 >= best)
-			break;
-		if (!try_module_get(p->owner))
-			continue;
-		owner = p->owner;
-		data = p->data;
-		probe = p->get;
-		best = p->range - 1;
-		*index = dev - p->dev;
-		if (p->lock && p->lock(dev, data) < 0) {
-			module_put(owner);
-			continue;
-		}
-		mutex_unlock(domain->lock);
-		kobj = probe(dev, index, data);
-		/* Currently ->owner protects _only_ ->probe() itself. */
-		module_put(owner);
-		if (kobj)
-			return kobj;
-		goto retry;
-	}
-	mutex_unlock(domain->lock);
-	return NULL;
-}
-
-struct kobj_map *kobj_map_init(kobj_probe_t *base_probe, struct mutex *lock)
-{
-	struct kobj_map *p = kmalloc(sizeof(struct kobj_map), GFP_KERNEL);
-	struct probe *base = kzalloc(sizeof(*base), GFP_KERNEL);
-	int i;
-
-	if ((p == NULL) || (base == NULL)) {
-		kfree(p);
-		kfree(base);
-		return NULL;
-	}
-
-	base->dev = 1;
-	base->range = ~0;
-	base->get = base_probe;
-	for (i = 0; i < 255; i++)
-		p->probes[i] = base;
-	p->lock = lock;
-	return p;
-}
diff --git a/include/linux/kobj_map.h b/include/linux/kobj_map.h
deleted file mode 100644
index c9919f8b22932c..00000000000000
--- a/include/linux/kobj_map.h
+++ /dev/null
@@ -1,20 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-/*
- * kobj_map.h
- */
-
-#ifndef _KOBJ_MAP_H_
-#define _KOBJ_MAP_H_
-
-#include <linux/mutex.h>
-
-typedef struct kobject *kobj_probe_t(dev_t, int *, void *);
-struct kobj_map;
-
-int kobj_map(struct kobj_map *, dev_t, unsigned long, struct module *,
-	     kobj_probe_t *, int (*)(dev_t, void *), void *);
-void kobj_unmap(struct kobj_map *, dev_t, unsigned long);
-struct kobject *kobj_lookup(struct kobj_map *, dev_t, int *);
-struct kobj_map *kobj_map_init(kobj_probe_t *, struct mutex *);
-
-#endif /* _KOBJ_MAP_H_ */
-- 
2.28.0


Return-Path: <SRS0=Vgdy=EE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6AA8C2D0A3
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Oct 2020 15:07:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 78CBC206FB
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Oct 2020 15:07:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="GQ0PsaVH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727910AbgJ2PHt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Oct 2020 11:07:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725909AbgJ2PHt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Oct 2020 11:07:49 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D53D1C0613D2;
        Thu, 29 Oct 2020 08:07:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=nkQlXxLcmCUCqPvhQGt7l6kE2o4Q0JEsan7yV2eUQms=; b=GQ0PsaVH5XcVQzkI5bw5HSt3C+
        7poxbEhmMfjy28na6QcgySUx8RhAftSTUT+/yyfCsdv4i2Q7UWaJpFLfaot7MCbCBmRLYnccGOgyk
        lkBa2qKdVTo2LmNuybutpSq5OxNK5nG0NQFbOn4Epn8yZ2B38pBk2TW679oGxV/VSzwWqtkUjhnuk
        lebrR3xcJve0IgMwc07kEqWOzScKU8k5N5TYJI/xX8yZcK9Dbr49TCR6dk8VnB6ePKW6UwFmyplBx
        ZD/qpxajcEysQRCM7hAjTNnIyKsjHnP4NqPPY/8y8Wv7SXlsrZVltsfT4bp60B/A3z7nLnU8DiFV5
        Ugwb7Exw==;
Received: from 089144193201.atnat0002.highway.a1.net ([89.144.193.201] helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kY9WX-0005qY-MX; Thu, 29 Oct 2020 15:07:38 +0000
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
        linux-scsi@vger.kernel.org, linux-m68k@lists.linux-m68k.org,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH 03/18] block: split block_class_lock
Date:   Thu, 29 Oct 2020 15:58:26 +0100
Message-Id: <20201029145841.144173-4-hch@lst.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201029145841.144173-1-hch@lst.de>
References: <20201029145841.144173-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Split the block_class_lock mutex into one each to protect bdev_map
and major_names.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 block/genhd.c | 29 +++++++++++++++--------------
 1 file changed, 15 insertions(+), 14 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index 0e22ca64aca09e..8be38725aad4e5 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -25,7 +25,6 @@
 
 #include "blk.h"
 
-static DEFINE_MUTEX(block_class_lock);
 static struct kobject *block_depr;
 
 struct bdev_map {
@@ -37,6 +36,7 @@ struct bdev_map {
 	int (*lock)(dev_t, void *);
 	void *data;
 } *bdev_map[255];
+static DEFINE_MUTEX(bdev_map_lock);
 
 /* for extended dynamic devt allocation, currently only one major is used */
 #define NR_EXT_DEVT		(1 << MINORBITS)
@@ -400,6 +400,7 @@ static struct blk_major_name {
 	int major;
 	char name[16];
 } *major_names[BLKDEV_MAJOR_HASH_SIZE];
+static DEFINE_MUTEX(major_names_lock);
 
 /* index in the above - for now: assume no multimajor ranges */
 static inline int major_to_index(unsigned major)
@@ -412,11 +413,11 @@ void blkdev_show(struct seq_file *seqf, off_t offset)
 {
 	struct blk_major_name *dp;
 
-	mutex_lock(&block_class_lock);
+	mutex_lock(&major_names_lock);
 	for (dp = major_names[major_to_index(offset)]; dp; dp = dp->next)
 		if (dp->major == offset)
 			seq_printf(seqf, "%3d %s\n", dp->major, dp->name);
-	mutex_unlock(&block_class_lock);
+	mutex_unlock(&major_names_lock);
 }
 #endif /* CONFIG_PROC_FS */
 
@@ -445,7 +446,7 @@ int register_blkdev(unsigned int major, const char *name)
 	struct blk_major_name **n, *p;
 	int index, ret = 0;
 
-	mutex_lock(&block_class_lock);
+	mutex_lock(&major_names_lock);
 
 	/* temporary */
 	if (major == 0) {
@@ -498,7 +499,7 @@ int register_blkdev(unsigned int major, const char *name)
 		kfree(p);
 	}
 out:
-	mutex_unlock(&block_class_lock);
+	mutex_unlock(&major_names_lock);
 	return ret;
 }
 
@@ -510,7 +511,7 @@ void unregister_blkdev(unsigned int major, const char *name)
 	struct blk_major_name *p = NULL;
 	int index = major_to_index(major);
 
-	mutex_lock(&block_class_lock);
+	mutex_lock(&major_names_lock);
 	for (n = &major_names[index]; *n; n = &(*n)->next)
 		if ((*n)->major == major)
 			break;
@@ -520,7 +521,7 @@ void unregister_blkdev(unsigned int major, const char *name)
 		p = *n;
 		*n = p->next;
 	}
-	mutex_unlock(&block_class_lock);
+	mutex_unlock(&major_names_lock);
 	kfree(p);
 }
 
@@ -671,7 +672,7 @@ void blk_register_region(dev_t devt, unsigned long range, struct module *module,
 		p->data = data;
 	}
 
-	mutex_lock(&block_class_lock);
+	mutex_lock(&bdev_map_lock);
 	for (i = 0, p -= n; i < n; i++, p++, index++) {
 		struct bdev_map **s = &bdev_map[index % 255];
 		while (*s && (*s)->range < range)
@@ -679,7 +680,7 @@ void blk_register_region(dev_t devt, unsigned long range, struct module *module,
 		p->next = *s;
 		*s = p;
 	}
-	mutex_unlock(&block_class_lock);
+	mutex_unlock(&bdev_map_lock);
 }
 EXPORT_SYMBOL(blk_register_region);
 
@@ -690,7 +691,7 @@ void blk_unregister_region(dev_t devt, unsigned long range)
 	unsigned i;
 	struct bdev_map *found = NULL;
 
-	mutex_lock(&block_class_lock);
+	mutex_lock(&bdev_map_lock);
 	for (i = 0; i < min(n, 255u); i++, index++) {
 		struct bdev_map **s;
 		for (s = &bdev_map[index % 255]; *s; s = &(*s)->next) {
@@ -703,7 +704,7 @@ void blk_unregister_region(dev_t devt, unsigned long range)
 			}
 		}
 	}
-	mutex_unlock(&block_class_lock);
+	mutex_unlock(&bdev_map_lock);
 	kfree(found);
 }
 EXPORT_SYMBOL(blk_unregister_region);
@@ -1034,7 +1035,7 @@ static struct gendisk *lookup_gendisk(dev_t dev, int *partno)
 	unsigned long best = ~0UL;
 
 retry:
-	mutex_lock(&block_class_lock);
+	mutex_lock(&bdev_map_lock);
 	for (p = bdev_map[MAJOR(dev) % 255]; p; p = p->next) {
 		struct kobject *(*probe)(dev_t, int *, void *);
 		struct module *owner;
@@ -1055,7 +1056,7 @@ static struct gendisk *lookup_gendisk(dev_t dev, int *partno)
 			module_put(owner);
 			continue;
 		}
-		mutex_unlock(&block_class_lock);
+		mutex_unlock(&bdev_map_lock);
 		kobj = probe(dev, partno, data);
 		/* Currently ->owner protects _only_ ->probe() itself. */
 		module_put(owner);
@@ -1063,7 +1064,7 @@ static struct gendisk *lookup_gendisk(dev_t dev, int *partno)
 			return dev_to_disk(kobj_to_dev(kobj));
 		goto retry;
 	}
-	mutex_unlock(&block_class_lock);
+	mutex_unlock(&bdev_map_lock);
 	return NULL;
 }
 
-- 
2.28.0


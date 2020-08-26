Return-Path: <SRS0=243Y=CE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 219BDC433DF
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Aug 2020 06:49:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F1276206FA
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Aug 2020 06:49:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="YiLxOYJO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726826AbgHZGs5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 26 Aug 2020 02:48:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726802AbgHZGs4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Aug 2020 02:48:56 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2D03C061574;
        Tue, 25 Aug 2020 23:48:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=zPuO1RiCFtAaXcTW9QuEi3RCIZQfS8nNc4ZkqYoXzUI=; b=YiLxOYJOTiPSK93YHWXjt6hbg7
        5zxkDTAslMxGwVPQtiLuBup4zhgAWdNwN70t1PkFj0ZfDpjHlT+wVEa3a43wHcGHbfMSoTGFcIw8S
        hdkLfYAqVGekybJYABcIrl21WiFMGIQojs3CiP7JJxKMV2EH+8tOnj0JWLHVsuNCHM+ejB8qyMrgk
        JhwFsh9p0BV2OvTtSvmmLrijDnD1HavDA3s4d5Jort//Xfl3sSmO+5WJl9tn/UdncXxaxEMCgLKgL
        gcTflF4T3H5cdyfRKtvZj19m42xEqfICf/b4Abee9bw4S7/haVwULFXaTFY8dWCkeBvWmQm/HzLqC
        pNatWPmQ==;
Received: from 213-225-6-196.nat.highway.a1.net ([213.225.6.196] helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kApEo-0002wj-AO; Wed, 26 Aug 2020 06:48:50 +0000
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
Subject: [PATCH 10/19] brd: use __register_blkdev to allocate devices on demand
Date:   Wed, 26 Aug 2020 08:24:37 +0200
Message-Id: <20200826062446.31860-11-hch@lst.de>
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

Use the simpler mechanism attached to major_name to allocate a brd device
when a currently unregistered minor is accessed.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/block/brd.c | 39 +++++++++++----------------------------
 1 file changed, 11 insertions(+), 28 deletions(-)

diff --git a/drivers/block/brd.c b/drivers/block/brd.c
index 2723a70eb85593..c8ac36351115ef 100644
--- a/drivers/block/brd.c
+++ b/drivers/block/brd.c
@@ -427,14 +427,15 @@ static void brd_free(struct brd_device *brd)
 	kfree(brd);
 }
 
-static struct brd_device *brd_init_one(int i, bool *new)
+static void brd_probe(dev_t dev)
 {
 	struct brd_device *brd;
+	int i = MINOR(dev) / max_part;
 
-	*new = false;
+	mutex_lock(&brd_devices_mutex);
 	list_for_each_entry(brd, &brd_devices, brd_list) {
 		if (brd->brd_number == i)
-			goto out;
+			goto out_unlock;
 	}
 
 	brd = brd_alloc(i);
@@ -443,9 +444,9 @@ static struct brd_device *brd_init_one(int i, bool *new)
 		add_disk(brd->brd_disk);
 		list_add_tail(&brd->brd_list, &brd_devices);
 	}
-	*new = true;
-out:
-	return brd;
+
+out_unlock:
+	mutex_unlock(&brd_devices_mutex);
 }
 
 static void brd_del_one(struct brd_device *brd)
@@ -455,23 +456,6 @@ static void brd_del_one(struct brd_device *brd)
 	brd_free(brd);
 }
 
-static struct kobject *brd_probe(dev_t dev, int *part, void *data)
-{
-	struct brd_device *brd;
-	struct kobject *kobj;
-	bool new;
-
-	mutex_lock(&brd_devices_mutex);
-	brd = brd_init_one(MINOR(dev) / max_part, &new);
-	kobj = brd ? get_disk_and_module(brd->brd_disk) : NULL;
-	mutex_unlock(&brd_devices_mutex);
-
-	if (new)
-		*part = 0;
-
-	return kobj;
-}
-
 static inline void brd_check_and_reset_par(void)
 {
 	if (unlikely(!max_part))
@@ -511,11 +495,12 @@ static int __init brd_init(void)
 	 *	dynamically.
 	 */
 
-	if (register_blkdev(RAMDISK_MAJOR, "ramdisk"))
+	if (__register_blkdev(RAMDISK_MAJOR, "ramdisk", brd_probe))
 		return -EIO;
 
 	brd_check_and_reset_par();
 
+	mutex_lock(&brd_devices_mutex);
 	for (i = 0; i < rd_nr; i++) {
 		brd = brd_alloc(i);
 		if (!brd)
@@ -533,9 +518,7 @@ static int __init brd_init(void)
 		brd->brd_disk->queue = brd->brd_queue;
 		add_disk(brd->brd_disk);
 	}
-
-	blk_register_region(MKDEV(RAMDISK_MAJOR, 0), 1UL << MINORBITS,
-				  THIS_MODULE, brd_probe, NULL, NULL);
+	mutex_unlock(&brd_devices_mutex);
 
 	pr_info("brd: module loaded\n");
 	return 0;
@@ -545,6 +528,7 @@ static int __init brd_init(void)
 		list_del(&brd->brd_list);
 		brd_free(brd);
 	}
+	mutex_unlock(&brd_devices_mutex);
 	unregister_blkdev(RAMDISK_MAJOR, "ramdisk");
 
 	pr_info("brd: module NOT loaded !!!\n");
@@ -558,7 +542,6 @@ static void __exit brd_exit(void)
 	list_for_each_entry_safe(brd, next, &brd_devices, brd_list)
 		brd_del_one(brd);
 
-	blk_unregister_region(MKDEV(RAMDISK_MAJOR, 0), 1UL << MINORBITS);
 	unregister_blkdev(RAMDISK_MAJOR, "ramdisk");
 
 	pr_info("brd: module unloaded\n");
-- 
2.28.0


Return-Path: <SRS0=Vgdy=EE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDD71C2D0A3
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Oct 2020 15:31:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8B960206F4
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Oct 2020 15:31:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="HrC9j+ri"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728360AbgJ2PbB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Oct 2020 11:31:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728249AbgJ2Pa7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Oct 2020 11:30:59 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 687AFC0613D3;
        Thu, 29 Oct 2020 08:21:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=gVY2C3Yr3hbZHWXTJ3PuAFR8cZ/e33HSpQGIidM7NRQ=; b=HrC9j+riyfO1S9gr/g++5iI0N3
        74NLSLyzTtNUKZ9XF3rwp2K1v/s+fjg2qcSYjf8QOmUICfgBrPeOSA1jbxUxF7r9HJB4hbyRx7eHk
        FojcS1VgBVwdrVokJXM0BtgkFwqQskJ3K8Dx40UqDdugqgQFIJHy1X4dw53zzQAjv29HotPTRtdHB
        3MOvjgI/R4rDuc4u757UYn1+KcRPt8DRgowi8eh9QpLFKw9ZJA3a4+GIU3UDH6ViAVvzgnqkn6GmD
        fohXz6rwzElTUCRi/NGIC3TGBpsu/Az9PdclZijenq0WSNuZgbFUF38rLy8pFKTK4Ov2TQ1iwWu7X
        6bFOAwYg==;
Received: from 089144193201.atnat0002.highway.a1.net ([89.144.193.201] helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kY9jQ-0006nN-Gz; Thu, 29 Oct 2020 15:20:55 +0000
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
Subject: [PATCH 09/18] brd: use __register_blkdev to allocate devices on demand
Date:   Thu, 29 Oct 2020 15:58:32 +0100
Message-Id: <20201029145841.144173-10-hch@lst.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201029145841.144173-1-hch@lst.de>
References: <20201029145841.144173-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use the simpler mechanism attached to major_name to allocate a brd device
when a currently unregistered minor is accessed.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 drivers/block/brd.c | 39 +++++++++++----------------------------
 1 file changed, 11 insertions(+), 28 deletions(-)

diff --git a/drivers/block/brd.c b/drivers/block/brd.c
index cc49a921339f77..c43a6ab4b1f39f 100644
--- a/drivers/block/brd.c
+++ b/drivers/block/brd.c
@@ -426,14 +426,15 @@ static void brd_free(struct brd_device *brd)
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
@@ -442,9 +443,9 @@ static struct brd_device *brd_init_one(int i, bool *new)
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
@@ -454,23 +455,6 @@ static void brd_del_one(struct brd_device *brd)
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
@@ -510,11 +494,12 @@ static int __init brd_init(void)
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
@@ -532,9 +517,7 @@ static int __init brd_init(void)
 		brd->brd_disk->queue = brd->brd_queue;
 		add_disk(brd->brd_disk);
 	}
-
-	blk_register_region(MKDEV(RAMDISK_MAJOR, 0), 1UL << MINORBITS,
-				  THIS_MODULE, brd_probe, NULL, NULL);
+	mutex_unlock(&brd_devices_mutex);
 
 	pr_info("brd: module loaded\n");
 	return 0;
@@ -544,6 +527,7 @@ static int __init brd_init(void)
 		list_del(&brd->brd_list);
 		brd_free(brd);
 	}
+	mutex_unlock(&brd_devices_mutex);
 	unregister_blkdev(RAMDISK_MAJOR, "ramdisk");
 
 	pr_info("brd: module NOT loaded !!!\n");
@@ -557,7 +541,6 @@ static void __exit brd_exit(void)
 	list_for_each_entry_safe(brd, next, &brd_devices, brd_list)
 		brd_del_one(brd);
 
-	blk_unregister_region(MKDEV(RAMDISK_MAJOR, 0), 1UL << MINORBITS);
 	unregister_blkdev(RAMDISK_MAJOR, "ramdisk");
 
 	pr_info("brd: module unloaded\n");
-- 
2.28.0


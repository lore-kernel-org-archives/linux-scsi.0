Return-Path: <SRS0=rOw5=CI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B529C433E2
	for <linux-scsi@archiver.kernel.org>; Sun, 30 Aug 2020 06:27:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 082912083E
	for <linux-scsi@archiver.kernel.org>; Sun, 30 Aug 2020 06:27:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="nYPNx+tP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728780AbgH3G0g (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 30 Aug 2020 02:26:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726510AbgH3GZE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 30 Aug 2020 02:25:04 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09318C06123F;
        Sat, 29 Aug 2020 23:25:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=z8bYioKTAu+DXMBCJGN6zlrMSBVFyPMVFFEmATTqveo=; b=nYPNx+tPNNm9zijkazoAdLuRMV
        qCtAySZZw8dJNhsulDQwANuZHFuRvk0B3wqqFSNrZ8WW4zCkkXH4cvGKTC7svvW9/V9EUZ5sbSPc8
        13RVWLV9k9omYWiR4bQtvJfNQ28H5ia+TgzoBYpPhhZZpKS4jnpFv1hF5y1zeMtxuAAEzx6WRt7dZ
        /FZMhShUrZU9VUfPzDYDiwJlyPP2d2da2c/m4htd+VNBWdjfF6ZbEak0fWbGwN5n8Z7BxLuBx8oDx
        Vz1p+hxOq7HeD6aNNhv5X9zhBvGSmjLG1bxdjXQIU2ms9/fBOQeyPTWzQxkIbUwG+25g+fy4zC6Xd
        hY6IDfvQ==;
Received: from [2001:4bb8:18c:45ba:9892:9e86:5202:32f0] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kCGlt-0002Nm-G0; Sun, 30 Aug 2020 06:24:57 +0000
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
Subject: [PATCH 11/19] loop: use __register_blkdev to allocate devices on demand
Date:   Sun, 30 Aug 2020 08:24:37 +0200
Message-Id: <20200830062445.1199128-12-hch@lst.de>
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

Use the simpler mechanism attached to major_name to allocate a brd device
when a currently unregistered minor is accessed.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/block/loop.c | 30 ++++++++----------------------
 1 file changed, 8 insertions(+), 22 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 5a991510136225..7c944a425f718f 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -2234,24 +2234,18 @@ static int loop_lookup(struct loop_device **l, int i)
 	return ret;
 }
 
-static struct kobject *loop_probe(dev_t dev, int *part, void *data)
+static void loop_probe(dev_t dev)
 {
+	int idx = MINOR(dev) >> part_shift;
 	struct loop_device *lo;
-	struct kobject *kobj;
-	int err;
+
+	if (max_loop && idx >= max_loop)
+		return;
 
 	mutex_lock(&loop_ctl_mutex);
-	err = loop_lookup(&lo, MINOR(dev) >> part_shift);
-	if (err < 0)
-		err = loop_add(&lo, MINOR(dev) >> part_shift);
-	if (err < 0)
-		kobj = NULL;
-	else
-		kobj = get_disk_and_module(lo->lo_disk);
+	if (loop_lookup(&lo, idx) < 0)
+		loop_add(&lo, idx);
 	mutex_unlock(&loop_ctl_mutex);
-
-	*part = 0;
-	return kobj;
 }
 
 static long loop_control_ioctl(struct file *file, unsigned int cmd,
@@ -2371,14 +2365,11 @@ static int __init loop_init(void)
 		goto err_out;
 
 
-	if (register_blkdev(LOOP_MAJOR, "loop")) {
+	if (__register_blkdev(LOOP_MAJOR, "loop", loop_probe)) {
 		err = -EIO;
 		goto misc_out;
 	}
 
-	blk_register_region(MKDEV(LOOP_MAJOR, 0), range,
-				  THIS_MODULE, loop_probe, NULL, NULL);
-
 	/* pre-create number of devices given by config or max_loop */
 	mutex_lock(&loop_ctl_mutex);
 	for (i = 0; i < nr; i++)
@@ -2404,16 +2395,11 @@ static int loop_exit_cb(int id, void *ptr, void *data)
 
 static void __exit loop_exit(void)
 {
-	unsigned long range;
-
-	range = max_loop ? max_loop << part_shift : 1UL << MINORBITS;
-
 	mutex_lock(&loop_ctl_mutex);
 
 	idr_for_each(&loop_index_idr, &loop_exit_cb, NULL);
 	idr_destroy(&loop_index_idr);
 
-	blk_unregister_region(MKDEV(LOOP_MAJOR, 0), range);
 	unregister_blkdev(LOOP_MAJOR, "loop");
 
 	misc_deregister(&loop_misc);
-- 
2.28.0


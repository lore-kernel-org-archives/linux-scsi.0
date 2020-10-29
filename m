Return-Path: <SRS0=Vgdy=EE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B224C4363A
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Oct 2020 15:23:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C7CDD20759
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Oct 2020 15:23:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="vR/Jm3z8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727966AbgJ2PXu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Oct 2020 11:23:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727290AbgJ2PXt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Oct 2020 11:23:49 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B063FC0613D5;
        Thu, 29 Oct 2020 08:23:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=rzOI4QCPdeUBt7iroEvX7J7kxhOvoRKyq17CwVGIqM4=; b=vR/Jm3z8d9K0oxW6DXsT69gAY5
        20bUZmv8n7eDonTdt/aMCMvWgW/eVeys3u+Mp0MhrvQHdhuIx3m7aGekNeQzQzAcBN8Mf5Zd1P2bK
        IQXTVnxw0xiSSPIhy1rvulyQwGQ6KnftMGNFgUtzBS/jZOZLl8TnOwSvT329MARsg319fKbT7NNxW
        zB5eCreSgvPF4zlaKdihnm4h6kFG52rPWXYROQ2guwA3FTrcEsAN/pyCTBlM0OwykiARxpUixc3Sd
        3gx10FBTuR7Q3fMTMBFHxy2rqwgaX10C2zaAGK8av6gjChId2wxfe6GdFxMZHD7++7rYyaUHw/hNO
        krDB+F3w==;
Received: from 089144193201.atnat0002.highway.a1.net ([89.144.193.201] helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kY9ld-0006ud-OP; Thu, 29 Oct 2020 15:23:17 +0000
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
Subject: [PATCH 10/18] loop: use __register_blkdev to allocate devices on demand
Date:   Thu, 29 Oct 2020 15:58:33 +0100
Message-Id: <20201029145841.144173-11-hch@lst.de>
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
 drivers/block/loop.c | 30 ++++++++----------------------
 1 file changed, 8 insertions(+), 22 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index cb1191d6e945f2..15b5a0ea7cc4a9 100644
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


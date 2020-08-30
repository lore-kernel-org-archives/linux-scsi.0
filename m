Return-Path: <SRS0=rOw5=CI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FBF5C43461
	for <linux-scsi@archiver.kernel.org>; Sun, 30 Aug 2020 06:26:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6DC5420693
	for <linux-scsi@archiver.kernel.org>; Sun, 30 Aug 2020 06:26:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="q3FCUuh4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728789AbgH3G0h (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 30 Aug 2020 02:26:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726512AbgH3GZE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 30 Aug 2020 02:25:04 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 567BEC061236;
        Sat, 29 Aug 2020 23:25:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=c08ZBBf2Ljp4vy8bDSx+N2cDnE5BI6ajAcLFHwYPExE=; b=q3FCUuh4TR1KTsEUR4o8GwJd8M
        L+HJ+VKN6SVmABkj+AnVyFDrcmQBMqt4xJTjU7FZjgue0RPrdgD9Wy+HdTCKvM8+jfJtVruZgFSaU
        94OjIwiKYHxYW+ScdQuK9JF747Y6SzSdzSz4Jl9ZxLXSjrg9Z1esAHgY51U7JnAcMKf0p9MLdWTQa
        eg4JMXvOBjainKOUfD6CHTT6YTHL2YWcQtnIj1Jw1PLkIYFjMSgbrpMEQt/Hqsaz80nSGH9Dbo1R6
        kTcvwXXliCLNF2aTdQGa7iLs0UgNn7WlLQTTxyHZ6pvjwD17TK3BOBuaVX4zJhwOtJxu+yNDa1TM4
        tdoW8s+Q==;
Received: from [2001:4bb8:18c:45ba:9892:9e86:5202:32f0] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kCGlu-0002O2-Ho; Sun, 30 Aug 2020 06:24:58 +0000
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
Subject: [PATCH 12/19] md: use __register_blkdev to allocate devices on demand
Date:   Sun, 30 Aug 2020 08:24:38 +0200
Message-Id: <20200830062445.1199128-13-hch@lst.de>
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
Acked-by: Song Liu <song@kernel.org>
---
 drivers/md/md.c | 21 ++++++++-------------
 1 file changed, 8 insertions(+), 13 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 60727820702300..3c4ef862ac5fb0 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5766,11 +5766,12 @@ static int md_alloc(dev_t dev, char *name)
 	return error;
 }
 
-static struct kobject *md_probe(dev_t dev, int *part, void *data)
+static void md_probe(dev_t dev)
 {
+	if (MAJOR(dev) == MD_MAJOR && MINOR(dev) >= 512)
+		return;
 	if (create_on_open)
 		md_alloc(dev, NULL);
-	return NULL;
 }
 
 static int add_named_array(const char *val, const struct kernel_param *kp)
@@ -6536,7 +6537,7 @@ static void autorun_devices(int part)
 			break;
 		}
 
-		md_probe(dev, NULL, NULL);
+		md_probe(dev);
 		mddev = mddev_find(dev);
 		if (!mddev || !mddev->gendisk) {
 			if (mddev)
@@ -9548,18 +9549,15 @@ static int __init md_init(void)
 	if (!md_misc_wq)
 		goto err_rdev_misc_wq;
 
-	if ((ret = register_blkdev(MD_MAJOR, "md")) < 0)
+	ret = __register_blkdev(MD_MAJOR, "md", md_probe);
+	if (ret < 0)
 		goto err_md;
 
-	if ((ret = register_blkdev(0, "mdp")) < 0)
+	ret = __register_blkdev(0, "mdp", md_probe);
+	if (ret < 0)
 		goto err_mdp;
 	mdp_major = ret;
 
-	blk_register_region(MKDEV(MD_MAJOR, 0), 512, THIS_MODULE,
-			    md_probe, NULL, NULL);
-	blk_register_region(MKDEV(mdp_major, 0), 1UL<<MINORBITS, THIS_MODULE,
-			    md_probe, NULL, NULL);
-
 	register_reboot_notifier(&md_notifier);
 	raid_table_header = register_sysctl_table(raid_root_table);
 
@@ -9826,9 +9824,6 @@ static __exit void md_exit(void)
 	struct list_head *tmp;
 	int delay = 1;
 
-	blk_unregister_region(MKDEV(MD_MAJOR,0), 512);
-	blk_unregister_region(MKDEV(mdp_major,0), 1U << MINORBITS);
-
 	unregister_blkdev(MD_MAJOR,"md");
 	unregister_blkdev(mdp_major, "mdp");
 	unregister_reboot_notifier(&md_notifier);
-- 
2.28.0


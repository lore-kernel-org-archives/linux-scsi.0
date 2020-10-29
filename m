Return-Path: <SRS0=Vgdy=EE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FC63C5DF9D
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Oct 2020 15:25:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CECFC20759
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Oct 2020 15:25:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="bXoWAyru"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728194AbgJ2PZy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Oct 2020 11:25:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728182AbgJ2PZx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Oct 2020 11:25:53 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEF93C0613D5;
        Thu, 29 Oct 2020 08:25:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=WGAEDjR1MpLpwo4exBP6K4ael/u9RgiEEnr9boaRFDc=; b=bXoWAyruF4nlHTpqki2Om3inhz
        2ssNEEGuFLPI/idGcdAb7xqytvf3DUBSc1tuA3jsa0DS1gue3jVBgjrOb9l30DM3eIYSJWKIT+iUK
        U/bRhCZ4gp9E84SkyI8/h/seTbWreck6+Fc8+wyp45nv6YmAyWRdJ0wyn0Pjnc4+LWP43h3scJ6h4
        Bxi075Rq05EZnyQ7rJhfg1gdp0gYcA+7IiXCBTdKZbgTu9wuAFHLporpM/b6FFLId4Mqi7NAlSqtV
        lLQtgQtHSf/CJ5OE4N+dXniz5CsPpJxAdayThGSJBrADBOm5LN+Mg4jT//i0pfJpPPBqN8yjbmVtI
        IBhkja6Q==;
Received: from 089144193201.atnat0002.highway.a1.net ([89.144.193.201] helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kY9nx-00075y-0T; Thu, 29 Oct 2020 15:25:38 +0000
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
Subject: [PATCH 11/18] md: use __register_blkdev to allocate devices on demand
Date:   Thu, 29 Oct 2020 15:58:34 +0100
Message-Id: <20201029145841.144173-12-hch@lst.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201029145841.144173-1-hch@lst.de>
References: <20201029145841.144173-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use the simpler mechanism attached to major_name to allocate a md device
when a currently unregistered minor is accessed.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Song Liu <song@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 drivers/md/md.c | 21 ++++++++-------------
 1 file changed, 8 insertions(+), 13 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 98bac4f304ae26..2268bd92a2267b 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5765,11 +5765,12 @@ static int md_alloc(dev_t dev, char *name)
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
@@ -6535,7 +6536,7 @@ static void autorun_devices(int part)
 			break;
 		}
 
-		md_probe(dev, NULL, NULL);
+		md_probe(dev);
 		mddev = mddev_find(dev);
 		if (!mddev || !mddev->gendisk) {
 			if (mddev)
@@ -9567,18 +9568,15 @@ static int __init md_init(void)
 	if (!md_rdev_misc_wq)
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
 
@@ -9845,9 +9843,6 @@ static __exit void md_exit(void)
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


Return-Path: <SRS0=Vgdy=EE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4098C4363A
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Oct 2020 15:10:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2F40220724
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Oct 2020 15:10:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="vq5w9rg0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727972AbgJ2PKB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Oct 2020 11:10:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726375AbgJ2PKB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Oct 2020 11:10:01 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14B53C0613D2;
        Thu, 29 Oct 2020 08:10:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=TnGAEpkZ/0zC8eY9jGiWDpr7H52LuhMLPz8kpv+9n58=; b=vq5w9rg0P9jXHeKT7rHZdj8ecW
        FK13YnA7DeJdsavREXbV90tozPTHXWQmF0zHrDfppkazHXF9OTAdWgwpr4aRnemHv5omzuimHQ5CA
        SWKcxCBLJWzZ0uQ5pZNEeyVqiN7a4AyCdeNIIN0Bw4+c8ng966O2GWF0qI9519RK2vUWVDmZ+lvXz
        sGfzj43etJY4EkfHQj5C1me6yWc2mg5wc8XT8rpaHw6pc0VUML4h+U51h1T8fckt4hP1iANGW6E+/
        ie2uS3xuKAOWzXCFbqV1LZQQoe/2GYQxb7DusRspAwM707m0GB5ofq1+qAUyY7Kn8PkJgIyRgvLwr
        Lufwqbvw==;
Received: from 089144193201.atnat0002.highway.a1.net ([89.144.193.201] helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kY9Yk-0005yR-UT; Thu, 29 Oct 2020 15:09:51 +0000
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
Subject: [PATCH 04/18] block: rework requesting modules for unclaimed devices
Date:   Thu, 29 Oct 2020 15:58:27 +0100
Message-Id: <20201029145841.144173-5-hch@lst.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201029145841.144173-1-hch@lst.de>
References: <20201029145841.144173-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Instead of reusing the ranges in bdev_map, add a new helper that is
called if no ranges was found.  This is a first step to unpeel and
eventually remove the complex ranges structure.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 block/genhd.c | 25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index 8be38725aad4e5..0e9f67e79c53fd 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -1028,6 +1028,13 @@ static ssize_t disk_badblocks_store(struct device *dev,
 	return badblocks_store(disk->bb, page, len, 0);
 }
 
+static void request_gendisk_module(dev_t devt)
+{
+	if (request_module("block-major-%d-%d", MAJOR(devt), MINOR(devt)) > 0)
+		/* Make old-style 2.4 aliases work */
+		request_module("block-major-%d", MAJOR(devt));
+}
+
 static struct gendisk *lookup_gendisk(dev_t dev, int *partno)
 {
 	struct kobject *kobj;
@@ -1052,6 +1059,14 @@ static struct gendisk *lookup_gendisk(dev_t dev, int *partno)
 		probe = p->probe;
 		best = p->range - 1;
 		*partno = dev - p->dev;
+
+		if (!probe) {
+			mutex_unlock(&bdev_map_lock);
+			module_put(owner);
+			request_gendisk_module(dev);
+			goto retry;
+		}
+
 		if (p->lock && p->lock(dev, data) < 0) {
 			module_put(owner);
 			continue;
@@ -1290,15 +1305,6 @@ static const struct seq_operations partitions_op = {
 };
 #endif
 
-
-static struct kobject *base_probe(dev_t devt, int *partno, void *data)
-{
-	if (request_module("block-major-%d-%d", MAJOR(devt), MINOR(devt)) > 0)
-		/* Make old-style 2.4 aliases work */
-		request_module("block-major-%d", MAJOR(devt));
-	return NULL;
-}
-
 static void bdev_map_init(void)
 {
 	struct bdev_map *base;
@@ -1310,7 +1316,6 @@ static void bdev_map_init(void)
 
 	base->dev = 1;
 	base->range = ~0 ;
-	base->probe = base_probe;
 	for (i = 0; i < 255; i++)
 		bdev_map[i] = base;
 }
-- 
2.28.0


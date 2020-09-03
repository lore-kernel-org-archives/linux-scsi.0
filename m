Return-Path: <SRS0=xo/b=CM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DB15C433E7
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Sep 2020 08:15:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3AEB12071B
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Sep 2020 08:15:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="tjsiLJ/4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728855AbgICIOr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Sep 2020 04:14:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728266AbgICIBj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Sep 2020 04:01:39 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6382C061244;
        Thu,  3 Sep 2020 01:01:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=B9nqgl0BizoCFTSZ0GvnyJ44eULa8ACIMrdc+XZNiS8=; b=tjsiLJ/42vQ0JOAtgixQhgUqn0
        WtrjjJky4JCaffqwjO709FpZCONklHjF0B0FQUZ3wtEJiU2vJAL/idMw0XK0vCf73t4ahJmpb7wUx
        Sb0F9THKCJGaCp5OarG0d3ygdhmIwMEoVe8gnwkfbfwYKfOufvgV5iump5I0ZtQso4MYArl0Z2u5V
        fqfwCdfDr5laybHPSMVhBctMcd2u0JdmQ9P9jY5Wk42cxnBp3q3EgN1mqqtIuFCb16uVtiDbeXNDG
        vYK8hc8U9xtUq5DmPkQcwkTULvCjNb8AzE63FE2aV7T+30HYMxHudXedDa3fHO+N3C9ZnYdgGRjQz
        uEXOODtw==;
Received: from [2001:4bb8:184:af1:c70:4a89:bc61:2] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kDkBY-0006bU-9M; Thu, 03 Sep 2020 08:01:32 +0000
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
Subject: [PATCH 08/19] swim: don't call blk_register_region
Date:   Thu,  3 Sep 2020 10:01:08 +0200
Message-Id: <20200903080119.441674-9-hch@lst.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200903080119.441674-1-hch@lst.de>
References: <20200903080119.441674-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The swim driver (unlike various other floppy drivers) doesn't have
magic device nodes for certain modes, and already registers a gendisk
for each of the floppies supported by a device.  Thus the region
registered is a no-op and can be removed.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/block/swim.c | 17 -----------------
 1 file changed, 17 deletions(-)

diff --git a/drivers/block/swim.c b/drivers/block/swim.c
index dd34504382e533..5a8f5932f9bde4 100644
--- a/drivers/block/swim.c
+++ b/drivers/block/swim.c
@@ -763,18 +763,6 @@ static const struct block_device_operations floppy_fops = {
 	.revalidate_disk = floppy_revalidate,
 };
 
-static struct kobject *floppy_find(dev_t dev, int *part, void *data)
-{
-	struct swim_priv *swd = data;
-	int drive = (*part & 3);
-
-	if (drive >= swd->floppy_count)
-		return NULL;
-
-	*part = 0;
-	return get_disk_and_module(swd->unit[drive].disk);
-}
-
 static int swim_add_floppy(struct swim_priv *swd, enum drive_location location)
 {
 	struct floppy_state *fs = &swd->unit[swd->floppy_count];
@@ -864,9 +852,6 @@ static int swim_floppy_init(struct swim_priv *swd)
 		add_disk(swd->unit[drive].disk);
 	}
 
-	blk_register_region(MKDEV(FLOPPY_MAJOR, 0), 256, THIS_MODULE,
-			    floppy_find, NULL, swd);
-
 	return 0;
 
 exit_put_disks:
@@ -950,8 +935,6 @@ static int swim_remove(struct platform_device *dev)
 	int drive;
 	struct resource *res;
 
-	blk_unregister_region(MKDEV(FLOPPY_MAJOR, 0), 256);
-
 	for (drive = 0; drive < swd->floppy_count; drive++) {
 		del_gendisk(swd->unit[drive].disk);
 		blk_cleanup_queue(swd->unit[drive].disk->queue);
-- 
2.28.0


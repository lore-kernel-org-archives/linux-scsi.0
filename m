Return-Path: <SRS0=Vgdy=EE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11A39C4363A
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Oct 2020 15:16:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A5C86207DE
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Oct 2020 15:16:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="bgcgVcwA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728151AbgJ2PQg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Oct 2020 11:16:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726604AbgJ2PQf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Oct 2020 11:16:35 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 167CAC0613CF;
        Thu, 29 Oct 2020 08:16:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=PYRAbvj07xt3bbBv7VOzHsFSKjgGbnfrYRY5d+fKMdQ=; b=bgcgVcwALzHCiQR12PgkldBt2H
        R4Hxay4lUn7ji1IciTaZVsSXY78A4iurfZLN7d6nA2rjELHLoU02JSpIsssgVkvz0uNmZ6RCyYN/X
        Yf6xxGDw+G4r8ym74xkRpkpJs3W+NuQXhXFygD+Q9UEiwqELreYv2ZtE9W2G+nUJxBws1Ln7OsViT
        pKnAOPbgbIXteHUPTElfO/wkCwub+LOE14e2x03gDfibtj5t5bX2uvflFyMLhJw4j2og1UZipmOLJ
        0q605+guA1eiuG9ejedApHw6JtYzgyo2Fug+tL0kejTD3pgB4YfD1vJ4TYPWzK7aiETAT8t4jsXXK
        bPvyWAIw==;
Received: from 089144193201.atnat0002.highway.a1.net ([89.144.193.201] helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kY9f8-0006Uf-7s; Thu, 29 Oct 2020 15:16:26 +0000
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
Subject: [PATCH 07/18] swim: don't call blk_register_region
Date:   Thu, 29 Oct 2020 15:58:30 +0100
Message-Id: <20201029145841.144173-8-hch@lst.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201029145841.144173-1-hch@lst.de>
References: <20201029145841.144173-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The swim driver (unlike various other floppy drivers) doesn't have
magic device nodes for certain modes, and already registers a gendisk
for each of the floppies supported by a device.  Thus the region
registered is a no-op and can be removed.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 drivers/block/swim.c | 17 -----------------
 1 file changed, 17 deletions(-)

diff --git a/drivers/block/swim.c b/drivers/block/swim.c
index 52dd1efa00f9c5..cc6a0bc6c005a7 100644
--- a/drivers/block/swim.c
+++ b/drivers/block/swim.c
@@ -745,18 +745,6 @@ static const struct block_device_operations floppy_fops = {
 	.check_events	 = floppy_check_events,
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
@@ -846,9 +834,6 @@ static int swim_floppy_init(struct swim_priv *swd)
 		add_disk(swd->unit[drive].disk);
 	}
 
-	blk_register_region(MKDEV(FLOPPY_MAJOR, 0), 256, THIS_MODULE,
-			    floppy_find, NULL, swd);
-
 	return 0;
 
 exit_put_disks:
@@ -932,8 +917,6 @@ static int swim_remove(struct platform_device *dev)
 	int drive;
 	struct resource *res;
 
-	blk_unregister_region(MKDEV(FLOPPY_MAJOR, 0), 256);
-
 	for (drive = 0; drive < swd->floppy_count; drive++) {
 		del_gendisk(swd->unit[drive].disk);
 		blk_cleanup_queue(swd->unit[drive].disk->queue);
-- 
2.28.0


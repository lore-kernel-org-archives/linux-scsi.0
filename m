Return-Path: <SRS0=rOw5=CI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A334DC433E6
	for <linux-scsi@archiver.kernel.org>; Sun, 30 Aug 2020 06:26:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F73B20693
	for <linux-scsi@archiver.kernel.org>; Sun, 30 Aug 2020 06:26:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Hi5+wI6Y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728797AbgH3G0h (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 30 Aug 2020 02:26:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725874AbgH3GZG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 30 Aug 2020 02:25:06 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98B4CC061239;
        Sat, 29 Aug 2020 23:25:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=34hr4y/kC5XT7kH5TAn/CeLpg6Bsmo1oeMdH990fres=; b=Hi5+wI6YBzEK9jiwVa6ethgB/j
        mGKPpYQc0zWCkuk33ZQFglAnwHCQCbN4xXry3LsSU+bQIsp8i/CiQvm3U1yrzJOZrPEzRkYhsyCaY
        uDv0oOYRsXISIJqpShUHq6eybzn8uAakbNZygPEwnw2TqaoJAwLs6n0dHFCPPKRyF6PfFMbFHEK43
        XdtPk92jX8Lw7QZKkfDi0RJ7Vhzz/L4dcl5zcqr/IGzdnwyT+IB3OOlshzbpS5bi+HFKssKoa0Q8J
        y/C0bcQX8YBGPdR+XXbU6rWudzle8WCoT3BYf+uuwMShIiMbvB/uc8IvaG1ECkYZ9ikODVhLHnZIW
        ccSlyFfw==;
Received: from [2001:4bb8:18c:45ba:9892:9e86:5202:32f0] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kCGlv-0002OB-Hc; Sun, 30 Aug 2020 06:24:59 +0000
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
Subject: [PATCH 13/19] ide: switch to __register_blkdev for command set probing
Date:   Sun, 30 Aug 2020 08:24:39 +0200
Message-Id: <20200830062445.1199128-14-hch@lst.de>
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

ide is the last user of the blk_register_region framework except for the
tracking of allocated gendisk.  Switch to __register_blkdev, even if that
doesn't allow us to trivially find out which command set to probe for.
That means we now always request all modules when a user tries to access
an unclaimed ide device node, but except for a few potentially loaded
modules for a fringe use case of a deprecated and soon to be removed
driver that doesn't make a difference.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/ide/ide-probe.c | 34 ++++++----------------------------
 1 file changed, 6 insertions(+), 28 deletions(-)

diff --git a/drivers/ide/ide-probe.c b/drivers/ide/ide-probe.c
index 076d34b381720f..1c1567bb519429 100644
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -902,31 +902,12 @@ static int init_irq (ide_hwif_t *hwif)
 	return 1;
 }
 
-static int ata_lock(dev_t dev, void *data)
+static void ata_probe(dev_t dev)
 {
-	/* FIXME: we want to pin hwif down */
-	return 0;
-}
-
-static struct kobject *ata_probe(dev_t dev, int *part, void *data)
-{
-	ide_hwif_t *hwif = data;
-	int unit = *part >> PARTN_BITS;
-	ide_drive_t *drive = hwif->devices[unit];
-
-	if ((drive->dev_flags & IDE_DFLAG_PRESENT) == 0)
-		return NULL;
-
-	if (drive->media == ide_disk)
-		request_module("ide-disk");
-	if (drive->media == ide_cdrom || drive->media == ide_optical)
-		request_module("ide-cd");
-	if (drive->media == ide_tape)
-		request_module("ide-tape");
-	if (drive->media == ide_floppy)
-		request_module("ide-floppy");
-
-	return NULL;
+	request_module("ide-disk");
+	request_module("ide-cd");
+	request_module("ide-tape");
+	request_module("ide-floppy");
 }
 
 void ide_init_disk(struct gendisk *disk, ide_drive_t *drive)
@@ -967,7 +948,7 @@ static int hwif_init(ide_hwif_t *hwif)
 		return 0;
 	}
 
-	if (register_blkdev(hwif->major, hwif->name))
+	if (__register_blkdev(hwif->major, hwif->name, ata_probe))
 		return 0;
 
 	if (!hwif->sg_max_nents)
@@ -989,8 +970,6 @@ static int hwif_init(ide_hwif_t *hwif)
 		goto out;
 	}
 
-	blk_register_region(MKDEV(hwif->major, 0), MAX_DRIVES << PARTN_BITS,
-			    THIS_MODULE, ata_probe, ata_lock, hwif);
 	return 1;
 
 out:
@@ -1582,7 +1561,6 @@ static void ide_unregister(ide_hwif_t *hwif)
 	/*
 	 * Remove us from the kernel's knowledge
 	 */
-	blk_unregister_region(MKDEV(hwif->major, 0), MAX_DRIVES<<PARTN_BITS);
 	kfree(hwif->sg_table);
 	unregister_blkdev(hwif->major, hwif->name);
 
-- 
2.28.0


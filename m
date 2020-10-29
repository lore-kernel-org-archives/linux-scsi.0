Return-Path: <SRS0=Vgdy=EE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EEA4C4363A
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Oct 2020 15:14:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9CBB22087E
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Oct 2020 15:14:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="WOoJXKxs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728065AbgJ2POX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Oct 2020 11:14:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725782AbgJ2POW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Oct 2020 11:14:22 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41C7CC0613CF;
        Thu, 29 Oct 2020 08:14:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=Uj41iOAMkP7S3mZAmNJpmZ6/dEDHQisWxtxi5roZGEc=; b=WOoJXKxs0Ah8hxyQPY5NpabQIp
        DZGdo4EjSnwBBWHvtr9nawYumB2qkSn0TYUQfUNejXw/x/t6GYh/tW/APTP07QjB7y5V6Vlp6pmvY
        gcboxo/BCfQCFY8yRx4oW6Np/3sphGHCcT8TDkJi06ytLn9wTSPDgtQpFtu/s2QjREpIlbFF6HEKf
        dFlfvWQjvFX5JBY4CRRViLEacyI2Syicu4xErRtPx/gAhrAFctCEU3b5SvAiSv0afJTRg6hE8XPMQ
        ZAIKUho2gBtliUxXOAiTePKOxlcO7urRJsooQOHYcGBQICcOxPUnbCJjlPaJW244Ty8B5DuXINTrY
        tWFZKtPg==;
Received: from 089144193201.atnat0002.highway.a1.net ([89.144.193.201] helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kY9d1-0006JD-41; Thu, 29 Oct 2020 15:14:15 +0000
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
Subject: [PATCH 06/18] ide: remove ide_{,un}register_region
Date:   Thu, 29 Oct 2020 15:58:29 +0100
Message-Id: <20201029145841.144173-7-hch@lst.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201029145841.144173-1-hch@lst.de>
References: <20201029145841.144173-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

There is no need to ever register the fake gendisk used for ide-tape.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 drivers/ide/ide-probe.c | 32 --------------------------------
 drivers/ide/ide-tape.c  |  2 --
 include/linux/ide.h     |  3 ---
 3 files changed, 37 deletions(-)

diff --git a/drivers/ide/ide-probe.c b/drivers/ide/ide-probe.c
index 1ddc45a04418cd..076d34b381720f 100644
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -929,38 +929,6 @@ static struct kobject *ata_probe(dev_t dev, int *part, void *data)
 	return NULL;
 }
 
-static struct kobject *exact_match(dev_t dev, int *part, void *data)
-{
-	struct gendisk *p = data;
-	*part &= (1 << PARTN_BITS) - 1;
-	return &disk_to_dev(p)->kobj;
-}
-
-static int exact_lock(dev_t dev, void *data)
-{
-	struct gendisk *p = data;
-
-	if (!get_disk_and_module(p))
-		return -1;
-	return 0;
-}
-
-void ide_register_region(struct gendisk *disk)
-{
-	blk_register_region(MKDEV(disk->major, disk->first_minor),
-			    disk->minors, NULL, exact_match, exact_lock, disk);
-}
-
-EXPORT_SYMBOL_GPL(ide_register_region);
-
-void ide_unregister_region(struct gendisk *disk)
-{
-	blk_unregister_region(MKDEV(disk->major, disk->first_minor),
-			      disk->minors);
-}
-
-EXPORT_SYMBOL_GPL(ide_unregister_region);
-
 void ide_init_disk(struct gendisk *disk, ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index 6f26634b22bbec..88b96437b22e62 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -1822,7 +1822,6 @@ static void ide_tape_remove(ide_drive_t *drive)
 
 	ide_proc_unregister_driver(drive, tape->driver);
 	device_del(&tape->dev);
-	ide_unregister_region(tape->disk);
 
 	mutex_lock(&idetape_ref_mutex);
 	put_device(&tape->dev);
@@ -2026,7 +2025,6 @@ static int ide_tape_probe(ide_drive_t *drive)
 		      "n%s", tape->name);
 
 	g->fops = &idetape_block_ops;
-	ide_register_region(g);
 
 	return 0;
 
diff --git a/include/linux/ide.h b/include/linux/ide.h
index 62653769509f89..2c300689a51a5c 100644
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -1493,9 +1493,6 @@ static inline void ide_acpi_port_init_devices(ide_hwif_t *hwif) { ; }
 static inline void ide_acpi_set_state(ide_hwif_t *hwif, int on) {}
 #endif
 
-void ide_register_region(struct gendisk *);
-void ide_unregister_region(struct gendisk *);
-
 void ide_check_nien_quirk_list(ide_drive_t *);
 void ide_undecoded_slave(ide_drive_t *);
 
-- 
2.28.0


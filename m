Return-Path: <SRS0=rOw5=CI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75312C433E2
	for <linux-scsi@archiver.kernel.org>; Sun, 30 Aug 2020 06:25:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5239320757
	for <linux-scsi@archiver.kernel.org>; Sun, 30 Aug 2020 06:25:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="nJp9JPCQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726607AbgH3GZT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 30 Aug 2020 02:25:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726255AbgH3GZA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 30 Aug 2020 02:25:00 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51E34C06123B;
        Sat, 29 Aug 2020 23:25:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=O5kxaoNfuWYD/r3zIuYk6jhw3GIKgkKxiecYTnoQ+yQ=; b=nJp9JPCQJZCvybID+bJVssaqag
        zsWo/Bt10oyUkIBbplh1kxs5Ht4fXhKQEDjk+IVZ+DTOxlnvfPj9i90Js7tBvkQY8oGaESGd2lpFN
        f0lzOSmT7JVKX4eQQbnw50GiLonM6VIOYF1LFAn/huPMCdbL3iwHHkxMZpchWmg5TJEjCbjpXQs90
        PjHPEPT/UactfqAaZhozApb44kWx4mndRhoQK8p5X0uwXEjRmVVNN3jAREBwmRG/4f9jwIM457ebe
        uDbPY94GmBLeNBPr/XOYorCse9U8CYEqLJ7ee8cFCYXlbMVagm69UFlkXv/pjaTuc12Sl6qphelwm
        Y2zq41Bg==;
Received: from [2001:4bb8:18c:45ba:9892:9e86:5202:32f0] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kCGlp-0002Ms-BG; Sun, 30 Aug 2020 06:24:53 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Denis Efremov <efremov@linux.com>,
        "David S. Miller" <davem@davemloft.net>,
        Song Liu <song@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-m68k@lists.linux-m68k.org,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH 07/19] ide: remove ide_{,un}register_region
Date:   Sun, 30 Aug 2020 08:24:33 +0200
Message-Id: <20200830062445.1199128-8-hch@lst.de>
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
index a254841bd3156d..cfa9e4b0c325a4 100644
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -1495,9 +1495,6 @@ static inline void ide_acpi_port_init_devices(ide_hwif_t *hwif) { ; }
 static inline void ide_acpi_set_state(ide_hwif_t *hwif, int on) {}
 #endif
 
-void ide_register_region(struct gendisk *);
-void ide_unregister_region(struct gendisk *);
-
 void ide_check_nien_quirk_list(ide_drive_t *);
 void ide_undecoded_slave(ide_drive_t *);
 
-- 
2.28.0


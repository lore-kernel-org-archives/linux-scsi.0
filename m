Return-Path: <SRS0=xo/b=CM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77BEEC433E7
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Sep 2020 08:15:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 47BBE21527
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Sep 2020 08:15:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Z3zq4Zdm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728662AbgICIPa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Sep 2020 04:15:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728073AbgICIBi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Sep 2020 04:01:38 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0302DC061244;
        Thu,  3 Sep 2020 01:01:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=O5kxaoNfuWYD/r3zIuYk6jhw3GIKgkKxiecYTnoQ+yQ=; b=Z3zq4ZdmxKan/1dFcAY0JXiu+R
        ACjLeO1G+TtdQ4L3y7SZeSrNKiCY9VjSm91OeuWNL5H4MKRQHVyQiolMSm3F+PMjHN1YlA3xgM0JV
        yVSXecevS42IeGuU7GY0eq94F9JLawFGTlRLmQMRUaiTgcGkBC6ZRMzXSmiH/nzYorBN04nfP1pcF
        nK18kjrn+MgempCgu58FZWcVE7evxQy2WPUuOFqwN9YRhK6rYIIiD8yZNVBL/6eytVG17s2DUIL4h
        Y43fw4GxrYxMgXKY/B6b3SGRzz5nk8+uwwFz0kpLmEhZ+VNnQkD7IoSlhB3rr6UFnIqFcqFMgxzQF
        wfb3zcmQ==;
Received: from [2001:4bb8:184:af1:c70:4a89:bc61:2] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kDkBW-0006bF-Vm; Thu, 03 Sep 2020 08:01:31 +0000
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
Subject: [PATCH 07/19] ide: remove ide_{,un}register_region
Date:   Thu,  3 Sep 2020 10:01:07 +0200
Message-Id: <20200903080119.441674-8-hch@lst.de>
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


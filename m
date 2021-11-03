Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA901C433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Nov 2021 23:05:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9A722604DC
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Nov 2021 23:05:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231803AbhKCXIA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Nov 2021 19:08:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230344AbhKCXH3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Nov 2021 19:07:29 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAADDC06120B;
        Wed,  3 Nov 2021 16:04:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=6F6/MHoHoSAu2CAZTHoDqGh5PrTxaWh5AmIhl3qLu6Q=; b=Ftm4rjwBLCjcN3KplZsGkMhu8r
        IJPKQgYC8A1x2DZiiCDtxXXMqVVF1jYcAP/g3lygL3JL6STkD0iE/GZM/Q8S1g9JI3b4/7lFlGJBk
        TjdPa/+CIMGGB64U6rDznHdNJSqg+u80mVjlAtmqQhhZxAKFZPjM2uisBj2OGIEnlpMBiB7hxl2gM
        PG3zx5kxdmymAEzn8gnNNGu19DFIi3T3mpXUieEt1TtJY0zYtFtCQEDSdnVBV/ZUPovP40mwWaMno
        d9f/BXjckWPb5PJkcl5ReslcM2QSVDyrz/fZIT+yCwa6off79+CIAKjdqFYm1LbdmGU1DLk4MNjtn
        5AuewsrA==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1miPJ8-006seh-SO; Wed, 03 Nov 2021 23:04:38 +0000
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     axboe@kernel.dk, hch@lst.de, penguin-kernel@i-love.sakura.ne.jp,
        dan.j.williams@intel.com, vishal.l.verma@intel.com,
        dave.jiang@intel.com, ira.weiny@intel.com, richard@nod.at,
        miquel.raynal@bootlin.com, vigneshr@ti.com, efremov@linux.com,
        song@kernel.org, martin.petersen@oracle.com, hare@suse.de,
        jack@suse.cz, ming.lei@redhat.com, tj@kernel.org, mcgrof@kernel.org
Cc:     linux-mtd@lists.infradead.org, linux-scsi@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v5 12/14] ataflop: address add_disk() error handling on probe
Date:   Wed,  3 Nov 2021 16:04:35 -0700
Message-Id: <20211103230437.1639990-13-mcgrof@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211103230437.1639990-1-mcgrof@kernel.org>
References: <20211103230437.1639990-1-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Luis Chamberlain <mcgrof@infradead.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We need to cleanup resources on the probe() callback registered
with __register_blkdev(), now that add_disk() error handling is
supported. Address this.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 drivers/block/ataflop.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/block/ataflop.c b/drivers/block/ataflop.c
index 170dd193cef6..de8c3785899a 100644
--- a/drivers/block/ataflop.c
+++ b/drivers/block/ataflop.c
@@ -2018,12 +2018,18 @@ static void ataflop_probe(dev_t dev)
 
 	if (drive >= FD_MAX_UNITS || type >= NUM_DISK_MINORS)
 		return;
-	if (!unit[drive].disk[type]) {
-		if (ataflop_alloc_disk(drive, type) == 0) {
-			add_disk(unit[drive].disk[type]);
-			unit[drive].registered[type] = true;
-		}
-	}
+	if (unit[drive].disk[type])
+		return
+	if (ataflop_alloc_disk(drive, type))
+		return;
+	if (add_disk(unit[drive].disk[type]))
+		goto cleanup_disk;
+	unit[drive].registered[type] = true;
+	return;
+
+cleanup_disk:
+	blk_cleanup_disk(unit[drive].disk[type]);
+	unit[drive].disk[type] = NULL;
 }
 
 static void atari_floppy_cleanup(void)
-- 
2.33.0


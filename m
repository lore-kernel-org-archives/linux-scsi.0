Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21488C433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Nov 2021 18:13:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 110AA610E7
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Nov 2021 18:13:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231590AbhKCSQK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Nov 2021 14:16:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231345AbhKCSQE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Nov 2021 14:16:04 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 289E4C061714;
        Wed,  3 Nov 2021 11:13:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=7+hD9NoEwudZFuVmk78ozQWIhfst9nLgIC7pZG4lA28=; b=yDjLlasRgH999cIdBWjfzGuZbW
        B3XBm7aKgSPbukHcGcr7RzETO/d3SVEFhPofIkpxrYjBIY0BdyGALIg1ydwPaK8bdjrnfDOagXmAd
        jgpq1vYIKoDtYLA75wWO9HkV4JCSN65NZPn9rpQiPkjmZSa57AhF8m95lOPyA5dXOho1JEbn5VkXZ
        iIp/oNrKA9pgi5ZBBQSPHR8lOlp9ss+kRZJp7McUbYD75D9j8A1Wyfx+RcurggTKL9VkI8X86XAhY
        czFjXnL6OWFkNGriWDtFCoTIz1qvY55Ok7ebNwzjr0v7pMu6lKEOFns2gjg5691qhhNCH3GIloQ0Z
        T5CGZQpw==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1miKkt-0068XJ-Tc; Wed, 03 Nov 2021 18:12:59 +0000
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
Subject: [PATCH v4 2/4] ataflop: address add_disk() error handling on probe
Date:   Wed,  3 Nov 2021 11:12:56 -0700
Message-Id: <20211103181258.1462704-3-mcgrof@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211103181258.1462704-1-mcgrof@kernel.org>
References: <20211103181258.1462704-1-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Luis Chamberlain <mcgrof@infradead.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We need to cleanup resources on the probe() callback registered
with __register_blkdev(), now that add_disk() error handling is
supported. Address this.

Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 drivers/block/ataflop.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/block/ataflop.c b/drivers/block/ataflop.c
index 170dd193cef6..e981b351f37e 100644
--- a/drivers/block/ataflop.c
+++ b/drivers/block/ataflop.c
@@ -2012,6 +2012,7 @@ static void ataflop_probe(dev_t dev)
 {
 	int drive = MINOR(dev) & 3;
 	int type  = MINOR(dev) >> 2;
+	int err = 0;
 
 	if (type)
 		type--;
@@ -2019,11 +2020,20 @@ static void ataflop_probe(dev_t dev)
 	if (drive >= FD_MAX_UNITS || type >= NUM_DISK_MINORS)
 		return;
 	if (!unit[drive].disk[type]) {
-		if (ataflop_alloc_disk(drive, type) == 0) {
-			add_disk(unit[drive].disk[type]);
-			unit[drive].registered[type] = true;
+		err = ataflop_alloc_disk(drive, type);
+		if (err == 0) {
+			err = add_disk(unit[drive].disk[type]);
+			if (err)
+				goto err_out;
+			else
+				unit[drive].registered[type] = true;
 		}
 	}
+	return;
+
+err_out:
+	blk_cleanup_disk(unit[drive].disk[type]);
+	unit[drive].disk[type] = NULL;
 }
 
 static void atari_floppy_cleanup(void)
-- 
2.33.0


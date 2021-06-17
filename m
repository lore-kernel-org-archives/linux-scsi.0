Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C8ECC48BE5
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Jun 2021 11:55:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 00B326141B
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Jun 2021 11:55:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232331AbhFQL5b (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Jun 2021 07:57:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230269AbhFQL52 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Jun 2021 07:57:28 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB3EAC061574
        for <linux-scsi@vger.kernel.org>; Thu, 17 Jun 2021 04:55:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=yV/fGYh1B9uhMroJQJxoF4hGJ1/kJQCy137cbxQm+S0=; b=lD3Qv5gqooSZrqQNoKtNMLyYBa
        65jcLUmrUP3o79BMRwSZCJn5YA5JlDUPs/UAPG4RG4GOoGd/bZUKWEceCPR4tuLeZTBk7rq0WLviA
        8Xpnm3ql16cbLUX6+DvYOZl83rpWFGiKg9ERFkpryvjYfsUyyZ0pxDk2KuxjHM2WT64NB7fIMdY2X
        T2ArLITvu/SHYuJ/56QYLEYuwDphoQM9eFImIAh/AvEGC5pLYTvXOtWrDIQpNTJ86AKSZ/g4cW7o9
        WGbKxA7qPunoyyjtXb14R8n+Cdnnma4OGqkUWptrnk8O4KNighjT9pbTnlT1o+g9lcd40fUIHpS45
        i7uhXHug==;
Received: from [2001:4bb8:19b:fdce:dccf:26cc:e207:71f6] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ltqbx-0095fi-CK; Thu, 17 Jun 2021 11:55:07 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, Xiang Chen <chenxiang66@hisilicon.com>
Subject: [PATCH] sd: call sd_revalidate_disk ioctl(BLKRRPART)
Date:   Thu, 17 Jun 2021 13:55:04 +0200
Message-Id: <20210617115504.1732350-1-hch@lst.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

While the disk state has nothing to do with partitions, BLKRRPART is used
to force a full revalidate after things like a format for historical
reasons.  Restore that behavior.

Fixes: 471bd0af544b ("sd: use bdev_check_media_change")
Reported-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Tested-by: Xiang Chen <chenxiang66@hisilicon.com>
---
 drivers/scsi/sd.c | 22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 5c8b5c5356a3..6d2d63629a90 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1387,6 +1387,22 @@ static void sd_uninit_command(struct scsi_cmnd *SCpnt)
 	}
 }
 
+static bool sd_need_revalidate(struct block_device *bdev,
+		struct scsi_disk *sdkp)
+{
+	if (sdkp->device->removable || sdkp->write_prot) {
+		if (bdev_check_media_change(bdev))
+			return true;
+	}
+
+	/*
+	 * Force a full rescan after ioctl(BLKRRPART).  While the disk state has
+	 * nothing to do with partitions, BLKRRPART is used to force a full
+	 * revalidate after things like a format for historical reasons.
+	 */
+	return test_bit(GD_NEED_PART_SCAN, &bdev->bd_disk->state);
+}
+
 /**
  *	sd_open - open a scsi disk device
  *	@bdev: Block device of the scsi disk to open
@@ -1423,10 +1439,8 @@ static int sd_open(struct block_device *bdev, fmode_t mode)
 	if (!scsi_block_when_processing_errors(sdev))
 		goto error_out;
 
-	if (sdev->removable || sdkp->write_prot) {
-		if (bdev_check_media_change(bdev))
-			sd_revalidate_disk(bdev->bd_disk);
-	}
+	if (sd_need_revalidate(bdev, sdkp))
+		sd_revalidate_disk(bdev->bd_disk);
 
 	/*
 	 * If the drive is empty, just let the open fail.
-- 
2.30.2


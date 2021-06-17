Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02A6FC2B9F4
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Jun 2021 10:29:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CEB7D610A1
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Jun 2021 10:29:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231496AbhFQKbr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Jun 2021 06:31:47 -0400
Received: from verein.lst.de ([213.95.11.211]:58162 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229716AbhFQKbr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 17 Jun 2021 06:31:47 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id F04C168CFE; Thu, 17 Jun 2021 12:29:36 +0200 (CEST)
Date:   Thu, 17 Jun 2021 12:29:36 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "chenxiang (M)" <chenxiang66@hisilicon.com>
Cc:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Tim Waugh <tim@cyberelk.net>, martin.petersen@oracle.com,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "linuxarm@huawei.com" <linuxarm@huawei.com>
Subject: Re: remove ->revalidate_disk (resend)
Message-ID: <20210617102936.GA12756@lst.de>
References: <20210308074550.422714-1-hch@lst.de> <96011dbd-084f-8a07-3506-fc7717122866@hisilicon.com> <20210616135015.GA30671@lst.de> <709468de-c8fd-0eeb-a3f9-5eb40650034b@hisilicon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <709468de-c8fd-0eeb-a3f9-5eb40650034b@hisilicon.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Can you try the patch below?

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

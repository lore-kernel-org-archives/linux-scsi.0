Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B73D3C4167D
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Nov 2021 13:06:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239473AbhKVNJz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Nov 2021 08:09:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239552AbhKVNJx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Nov 2021 08:09:53 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 495C6C06173E;
        Mon, 22 Nov 2021 05:06:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=aoQsvDG2YnMv/XYYmtyzLOIg2f6d5rmmgJX2H38TISs=; b=Wty6wdG6v7kGWP8c6JNLOk+6QZ
        Bw77JDYqzTHBxFPKgP/l04d2TH4eJEtBDgp/hvzEGY+9PYquUpDvaal1iKZalY4YsBZN+0l0seC5o
        fOUvpb4GZxJpJeTd7YAxhBP7Y/vgcQQq6N9J7YO4FVRucMs+dNyrefgJFjokyzaZHHZ9ZZT9OeDfT
        eHxTpDEzwftBNxD8M32Qq03Cwxq1/oM/z6/AGqsWJpP6BdvvKGlWYR4hKJExDpRmFMxMWRv2fFHRw
        lLO7LChXDTN/HyuPwItesa22pNn64yJTlSHkPt4bZFXA+MWPlh4fAi7sS4TdlrRtmv1fhoCwax6jy
        xla06ZSg==;
Received: from [2001:4bb8:180:22b2:9649:4579:dcf9:9fb2] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mp91w-00Crtb-AY; Mon, 22 Nov 2021 13:06:45 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ulf Hansson <ulf.hansson@linaro.org>, linux-block@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: [PATCH 14/14] sr: set GENHD_FL_REMOVABLE earlier
Date:   Mon, 22 Nov 2021 14:06:25 +0100
Message-Id: <20211122130625.1136848-15-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211122130625.1136848-1-hch@lst.de>
References: <20211122130625.1136848-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Set up GENHD_FL_REMOVABLE together with the rest of the gendisk fields.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/sr.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index cf093387e42a1..411e2b01966e8 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -684,7 +684,7 @@ static int sr_probe(struct device *dev)
 	disk->minors = 1;
 	sprintf(disk->disk_name, "sr%d", minor);
 	disk->fops = &sr_bdops;
-	disk->flags |= GENHD_FL_NO_PART;
+	disk->flags |= GENHD_FL_REMOVABLE | GENHD_FL_NO_PART;
 	disk->events = DISK_EVENT_MEDIA_CHANGE | DISK_EVENT_EJECT_REQUEST;
 	disk->event_flags = DISK_EVENT_FLAG_POLL | DISK_EVENT_FLAG_UEVENT |
 				DISK_EVENT_FLAG_BLOCK_ON_EXCL_WRITE;
@@ -726,7 +726,6 @@ static int sr_probe(struct device *dev)
 	blk_pm_runtime_init(sdev->request_queue, dev);
 
 	dev_set_drvdata(dev, cd);
-	disk->flags |= GENHD_FL_REMOVABLE;
 	sr_revalidate_disk(cd);
 
 	error = device_add_disk(&sdev->sdev_gendev, disk, NULL);
-- 
2.30.2


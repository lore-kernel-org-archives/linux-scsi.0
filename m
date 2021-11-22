Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A8B4C4167B
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Nov 2021 13:06:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239413AbhKVNJs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Nov 2021 08:09:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238762AbhKVNJp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Nov 2021 08:09:45 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35B38C061758;
        Mon, 22 Nov 2021 05:06:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=KhZX3vkQuaBjtE8mPyMM/mQikzUCttlaMjmvtv2/Lpc=; b=iNbNTB0mDFOoKY+kw6XhYKYu6m
        lqYw8q0ZZtdM4vJB85oS8zkBAeS51gfkCigc0y4ivhBMdKKsbNTTfsYeSAx5vIetJaRYEWeiyXxNv
        Os8kDMjdLvsFrjRYBUJs/tEn+YZo2oRdOcqkbtM3otlq5qR4uhhL1fkQCcm7RoRiNriBEg8cJDMad
        ccfQ8PRHCBptblzGpBkVzRaWlJsSOKCjv+sTYOD6Y/66DbtHqZCkJ+w0WdA2UXCcCHbM6n6wm+Ku7
        QZKYwGJVusPwHKYOvWZn35ui/GgcZ5OrYKB6u2bkY8XdhvJxO1Gkm8Aj/61ZLDVEFcKu5W6U3JMTl
        Ls+zO6uw==;
Received: from [2001:4bb8:180:22b2:9649:4579:dcf9:9fb2] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mp91m-00Crrs-VM; Mon, 22 Nov 2021 13:06:36 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ulf Hansson <ulf.hansson@linaro.org>, linux-block@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: [PATCH 07/14] block: remove the GENHD_FL_HIDDEN check in blkdev_get_no_open
Date:   Mon, 22 Nov 2021 14:06:18 +0100
Message-Id: <20211122130625.1136848-8-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211122130625.1136848-1-hch@lst.de>
References: <20211122130625.1136848-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hidden gendisks never hash the block device inode, so this can't happen.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/bdev.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/block/bdev.c b/block/bdev.c
index cf29c6508bff2..ae063041f2910 100644
--- a/block/bdev.c
+++ b/block/bdev.c
@@ -753,8 +753,7 @@ struct block_device *blkdev_get_no_open(dev_t dev)
 
 	if (!bdev)
 		return NULL;
-	if ((bdev->bd_disk->flags & GENHD_FL_HIDDEN) ||
-	    !try_module_get(bdev->bd_disk->fops->owner)) {
+	if (!try_module_get(bdev->bd_disk->fops->owner)) {
 		put_device(&bdev->bd_device);
 		return NULL;
 	}
-- 
2.30.2


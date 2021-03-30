Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D29CBC433E2
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Mar 2021 16:18:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A5CA3619D4
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Mar 2021 16:18:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231752AbhC3QSJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Mar 2021 12:18:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231951AbhC3QRm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Mar 2021 12:17:42 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0AD4C061762;
        Tue, 30 Mar 2021 09:17:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=nGAZ/xM8Mx4+9DVBn7L/9DNXZELRNObgOzid/KBGpHQ=; b=zRV68zTBPzgjiVmJhp0hMiHEUS
        wdvtxworgSsfxi1V064WIjS0gZLE+amGlHrHyMRbGOTFOuHCL/xFaLHkTBE3Xq7MpSq0z5gwvD3F6
        SONkPBKFiQRTcNt6shFCvdFWPkcdXobhxHkLcd1NOTqswzppxfarkdeTxUl1Ul1D3h5Q6YbvFjQUv
        sjRC9dfA6f04r6JueOLmEZ3YcE/xwPk/onaQtWiEs3I87qiGZzn1+aR0DMAagkuFujFpw4YxmCjP2
        qJCql/G3agFT4MF4UFa8jPtjSWd0k1YYo9mNAvGzSYBFeqIh3uU0jDbxCLFaZUw/jJ5Zw18s3fQ0A
        uV+61n/g==;
Received: from [185.12.131.45] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lRH3d-008aJl-Pm; Tue, 30 Mar 2021 16:17:34 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>, Song Liu <song@kernel.org>
Cc:     Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        =?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>,
        Minchan Kim <minchan@kernel.org>,
        Nitin Gupta <ngupta@vflare.org>,
        Stefan Haberland <sth@linux.ibm.com>,
        Jan Hoeppner <hoeppner@linux.ibm.com>,
        linux-block@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: [PATCH 01/15] md: remove the code to flush an old instance in md_open
Date:   Tue, 30 Mar 2021 18:17:13 +0200
Message-Id: <20210330161727.2297292-2-hch@lst.de>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210330161727.2297292-1-hch@lst.de>
References: <20210330161727.2297292-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Due to the flush_workqueue() call in md_alloc no previous instance of
mddev can still be around at this point.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/md.c | 35 +++++++----------------------------
 1 file changed, 7 insertions(+), 28 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 368cad6cd53a6e..cd2d825dd4f881 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -7807,43 +7807,22 @@ static int md_open(struct block_device *bdev, fmode_t mode)
 	 * Succeed if we can lock the mddev, which confirms that
 	 * it isn't being stopped right now.
 	 */
-	struct mddev *mddev = mddev_find(bdev->bd_dev);
+	struct mddev *mddev = bdev->bd_disk->private_data;
 	int err;
 
-	if (!mddev)
-		return -ENODEV;
-
-	if (mddev->gendisk != bdev->bd_disk) {
-		/* we are racing with mddev_put which is discarding this
-		 * bd_disk.
-		 */
-		mddev_put(mddev);
-		/* Wait until bdev->bd_disk is definitely gone */
-		if (work_pending(&mddev->del_work))
-			flush_workqueue(md_misc_wq);
-		/* Then retry the open from the top */
-		return -ERESTARTSYS;
-	}
-	BUG_ON(mddev != bdev->bd_disk->private_data);
-
-	if ((err = mutex_lock_interruptible(&mddev->open_mutex)))
-		goto out;
-
+	err = mutex_lock_interruptible(&mddev->open_mutex);
+	if (err)
+		return err;
 	if (test_bit(MD_CLOSING, &mddev->flags)) {
 		mutex_unlock(&mddev->open_mutex);
-		err = -ENODEV;
-		goto out;
+		return -ENODEV;
 	}
-
-	err = 0;
+	mddev_get(mddev);
 	atomic_inc(&mddev->openers);
 	mutex_unlock(&mddev->open_mutex);
 
 	bdev_check_media_change(bdev);
- out:
-	if (err)
-		mddev_put(mddev);
-	return err;
+	return 0;
 }
 
 static void md_release(struct gendisk *disk, fmode_t mode)
-- 
2.30.1


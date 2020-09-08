Return-Path: <SRS0=d5MZ=CR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD889C433E2
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Sep 2020 20:08:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C3DE204FD
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Sep 2020 20:08:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ko5s17TL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731882AbgIHUIv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Sep 2020 16:08:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730193AbgIHPTN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Sep 2020 11:19:13 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6CF8C0A3BF2;
        Tue,  8 Sep 2020 07:55:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=+zVHcucQifdjecrPBhxjClZkm2NjkT/RLZsD1fxF4P4=; b=ko5s17TLYKi28rzQRAAoq31zQ/
        sfC2GOdl69IRxmLKZcQsa/k8a0GXiZ+umVW//0HgO5Fgv7b8S76wsrPhdwLL7Q4R1Xt2g0uB5iddx
        l8OX+RO3CUFt6vACrGggetnHxpCNWp/RirodlGWGie0rjYr7aThkH4wHBbrXc8w4onm4vTbqciTqe
        VJVnW+pXbo4wFQHSkUyCHgnbNDUtMRNfDJNinXDaGeW2X5VxRJAeQywpHRa/2Iot7BXopGkS2qY7/
        AcJtui0CXtCixYCs94tac4VyaoOkq2lZhIP4OMyv9OqI4ny6ad+vb4CrcFqGt15GhiiRsHBuJ+CFU
        ZGcTfpkw==;
Received: from [2001:4bb8:184:af1:3dc3:9c83:fc6c:e0f] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kFf1A-0002zJ-TG; Tue, 08 Sep 2020 14:54:45 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Denis Efremov <efremov@linux.com>, Tim Waugh <tim@cyberelk.net>,
        Michal Simek <michal.simek@xilinx.com>,
        Borislav Petkov <bp@alien8.de>,
        "David S. Miller" <davem@davemloft.net>,
        Song Liu <song@kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Finn Thain <fthain@telegraphics.com.au>,
        Michael Schmitz <schmitzmic@gmail.com>,
        linux-m68k@lists.linux-m68k.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH 15/19] md: use bdev_check_media_change
Date:   Tue,  8 Sep 2020 16:53:43 +0200
Message-Id: <20200908145347.2992670-16-hch@lst.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908145347.2992670-1-hch@lst.de>
References: <20200908145347.2992670-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The md driver does not have a ->revalidate_disk method, so it can just
use bdev_check_media_change without any additional changes.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 drivers/md/md.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 9562ef598ae1f4..27ed61197014ef 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -7848,7 +7848,7 @@ static int md_open(struct block_device *bdev, fmode_t mode)
 	atomic_inc(&mddev->openers);
 	mutex_unlock(&mddev->open_mutex);
 
-	check_disk_change(bdev);
+	bdev_check_media_change(bdev);
  out:
 	if (err)
 		mddev_put(mddev);
-- 
2.28.0


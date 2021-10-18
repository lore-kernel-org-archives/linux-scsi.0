Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A96EC433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Oct 2021 06:51:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 58E556103D
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Oct 2021 06:51:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230355AbhJRGxK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Oct 2021 02:53:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230222AbhJRGxI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Oct 2021 02:53:08 -0400
Received: from bombadil.infradead.org (unknown [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B730EC06161C;
        Sun, 17 Oct 2021 23:50:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=uXEB/JS8NCDVfNV3a8g8vQ/HIHrJoEIRIzXIpC6nNvA=; b=JWCo8NmIaP43uv+GJWcAeZz7MP
        kkh//kMf7JLNz0rcfbue5t65WurWmMxqc4+omq0UdwLq2L18LLgjAJroqORYbsUI8XWV5SuLZ7eCQ
        fFdm4F41OGfyG2ofW8d1B74Ut4DvpOptvs/AZ4p7TYtADjk4JcfCqR9nodnZ+MVSY95by/dWaLeB8
        XGXZDacunhDVeFdSFxiC0ilQF3IU2bZNPS4cv/31MkwdfurPS9C0hdBxRKyse3mLe7DDRMfVBUGUY
        nyDX8peOn4cpJ5gKrBmaHcUWeazQKOHUEv2QdCbDwResVgqmzF30Gkq8ELaFa8WLRQAsdD3zTCtc/
        YAEaSM4w==;
Received: from [2001:4bb8:199:73c5:3de2:2f89:c99b:8fe2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mcMU4-00ENxT-K6; Mon, 18 Oct 2021 06:50:57 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] target: stop using bdevname
Date:   Mon, 18 Oct 2021 08:50:52 +0200
Message-Id: <20211018065052.1822500-1-hch@lst.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Just use the %pg format specifier instead.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/target/target_core_iblock.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index 4069a1edcfa34..3113c4440735a 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -634,12 +634,10 @@ static ssize_t iblock_show_configfs_dev_params(struct se_device *dev, char *b)
 {
 	struct iblock_dev *ib_dev = IBLOCK_DEV(dev);
 	struct block_device *bd = ib_dev->ibd_bd;
-	char buf[BDEVNAME_SIZE];
 	ssize_t bl = 0;
 
 	if (bd)
-		bl += sprintf(b + bl, "iBlock device: %s",
-				bdevname(bd, buf));
+		bl += sprintf(b + bl, "iBlock device: %pg", bd);
 	if (ib_dev->ibd_flags & IBDF_HAS_UDEV_PATH)
 		bl += sprintf(b + bl, "  UDEV PATH: %s",
 				ib_dev->ibd_udev_path);
-- 
2.30.2


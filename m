Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0015C433FE
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Dec 2021 09:03:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236700AbhLVJDu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Dec 2021 04:03:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243706AbhLVJD0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Dec 2021 04:03:26 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09382C06175C
        for <linux-scsi@vger.kernel.org>; Wed, 22 Dec 2021 01:03:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=Mcd9LNpyYeE+O89xMhsMW5HZ4Ypv84Ujnj1IkGOO4Oo=; b=f1HmBKrHmDcsFy0ZJa6D80yV10
        k4+SJ93DFHYQqQ9urNkm1+Tmj2qi2T1JRnfFR0NXKdBxFOdTLyZmHx/GxgzfGJWXDb9Ftwr2QkRT9
        4TYg5y9+XLpNb95kMpdDX7j3evcwfPev53cx0xmww4t5nXLRfksJwgJZ4WsSq+W6RCDB+kbeN5yJG
        6esryzyVAX7qm2oI1azUBdbW3pgr5Iwhzk6izjOAV69YLN9kTzm0UiuBm74sVzrSMrPSDoui9YIRN
        trZMJEg9gctZhbZ8MgOQ07H1cBz3wnosNih87+QSCejVKvQDxqDO3ZeXZPP994V9LGS8erXlmAd3Z
        rlgzyEZA==;
Received: from [2001:4bb8:190:3b1b:96b5:489:ff97:f4cf] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mzxWi-003E8K-0i; Wed, 22 Dec 2021 09:03:12 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org
Subject: [PATCH] ch: don't use GFP_DMA
Date:   Wed, 22 Dec 2021 10:03:11 +0100
Message-Id: <20211222090311.916624-1-hch@lst.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The allocated buffers are used as a command payload, for which the block
layer and/or DMA API do the proper bounce buffering if needed.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/ch.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/ch.c b/drivers/scsi/ch.c
index 6fa300daa31ea..9088548698646 100644
--- a/drivers/scsi/ch.c
+++ b/drivers/scsi/ch.c
@@ -239,7 +239,7 @@ ch_read_element_status(scsi_changer *ch, u_int elem, char *data)
 	u_char  *buffer;
 	int     result;
 
-	buffer = kmalloc(512, GFP_KERNEL | GFP_DMA);
+	buffer = kmalloc(512, GFP_KERNEL);
 	if(!buffer)
 		return -ENOMEM;
 
@@ -297,7 +297,7 @@ ch_readconfig(scsi_changer *ch)
 	int     result,id,lun,i;
 	u_int   elem;
 
-	buffer = kzalloc(512, GFP_KERNEL | GFP_DMA);
+	buffer = kzalloc(512, GFP_KERNEL);
 	if (!buffer)
 		return -ENOMEM;
 
@@ -783,7 +783,7 @@ static long ch_ioctl(struct file *file,
 			return -EINVAL;
 		elem = ch->firsts[cge.cge_type] + cge.cge_unit;
 
-		buffer = kmalloc(512, GFP_KERNEL | GFP_DMA);
+		buffer = kmalloc(512, GFP_KERNEL);
 		if (!buffer)
 			return -ENOMEM;
 		mutex_lock(&ch->lock);
-- 
2.30.2


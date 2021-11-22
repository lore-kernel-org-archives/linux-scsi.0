Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A39FC4332F
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Nov 2021 13:06:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239220AbhKVNJt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Nov 2021 08:09:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237621AbhKVNJp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Nov 2021 08:09:45 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68B8FC06175A;
        Mon, 22 Nov 2021 05:06:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=wBu+QTBVEM/yEVf/ZCvJYHC4Ubf7CB3x+fS1oP2AOrE=; b=OOwpbQuuEf6R6imRQwYYKWkoTF
        Wvaif1h/fvaUC3L3e9hNFnJyMK4KAQKYkQS7GN4xT36zgCRxDXM4dRGwZgXy9yXPOwNrbKeC4uDm/
        HduGaDLOfvTfPIcJrOB8q9FrQPb0P9ydwyIrMkegtF2KK6c+bitUDf/YsvGaWEUy4gVeR3v2X2PG5
        J38fY3glhfHPtLzNa6iZ+5u1GfxyK8sIefH3hIWejj8A+nL/VOY6d4VmeRxVQp3ttjsL0afD75O8B
        PbtlkfSQolqxyYfh+vV7f4XZWbxNBrtZNHJks0UAyZfRTgqjLuwGPQNIr5ORNSpDkKH3/IJHWDgcc
        vp0TNRRw==;
Received: from [2001:4bb8:180:22b2:9649:4579:dcf9:9fb2] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mp91o-00Crs3-Hz; Mon, 22 Nov 2021 13:06:37 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ulf Hansson <ulf.hansson@linaro.org>, linux-block@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: [PATCH 08/14] null_blk: don't suppress partitioning information
Date:   Mon, 22 Nov 2021 14:06:19 +0100
Message-Id: <20211122130625.1136848-9-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211122130625.1136848-1-hch@lst.de>
References: <20211122130625.1136848-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This manually reverts commit 27290b469051 ("null_blk: suppress invalid
partition info").  The message in that commit log can't appearch as
the flag is never checked during probing, and there is no good reason
to treat null_blk special in /proc/partitions.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/block/null_blk/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/null_blk/main.c b/drivers/block/null_blk/main.c
index 323af5c9c8026..eb17def1f265e 100644
--- a/drivers/block/null_blk/main.c
+++ b/drivers/block/null_blk/main.c
@@ -1850,7 +1850,7 @@ static int null_gendisk_register(struct nullb *nullb)
 
 	set_capacity(disk, size);
 
-	disk->flags |= GENHD_FL_EXT_DEVT | GENHD_FL_SUPPRESS_PARTITION_INFO;
+	disk->flags |= GENHD_FL_EXT_DEVT;
 	disk->major		= null_major;
 	disk->first_minor	= nullb->index;
 	disk->minors		= 1;
-- 
2.30.2


Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55D09C4332F
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Nov 2021 13:06:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239192AbhKVNJq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Nov 2021 08:09:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238838AbhKVNJm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Nov 2021 08:09:42 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03B9BC06173E;
        Mon, 22 Nov 2021 05:06:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=YgoVvS/2icoWCylvgE0+nRzjiKPdxDKOpRTsYAzQ6aE=; b=OTq+XPZNKDNgiMNAI0enA9ucfh
        D8Gx4R8p63Cfw/HrfvqD0U9+FIH/L5qWHe0wLQGcCSLiY2aRTzN5f+3rk1uT2Bx7Uq5TK6/mjdcCA
        DtJk4oVUAIkfLk5CuDH4aqKVIoGwkPb9z/kI72wd0EjZGoPu6suhN8Sr2jZE/Km/5y7IDkGptmDCP
        sUkFaPY93L4nXxa5ZIWMzgGS3P7rZgz3qGAW1alqfp7CEFJy9yKhHxD64v6Z0w0uyMsM1lLIJ4q8a
        4rZFpCNQLVYBCVX0oOBjmWDQ4VUdBOudvgIIuiKiu7sCepEtk28PP6LZrbd65tMgH7afnftytwpAR
        6271JG1g==;
Received: from [2001:4bb8:180:22b2:9649:4579:dcf9:9fb2] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mp91j-00Crqv-48; Mon, 22 Nov 2021 13:06:32 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ulf Hansson <ulf.hansson@linaro.org>, linux-block@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: [PATCH 04/14] block: remove a dead check in show_partition
Date:   Mon, 22 Nov 2021 14:06:15 +0100
Message-Id: <20211122130625.1136848-5-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211122130625.1136848-1-hch@lst.de>
References: <20211122130625.1136848-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

disk_max_parts never returns 0 given that ->minors for devices not using
the extended dev_t must be non-zero, and disk_max_parts always returns
DISK_MAX_PARTS for the latter.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/genhd.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index c5392cc24d37e..b1c0f62505bf0 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -814,9 +814,7 @@ static int show_partition(struct seq_file *seqf, void *v)
 	struct block_device *part;
 	unsigned long idx;
 
-	/* Don't show non-partitionable removeable devices or empty devices */
-	if (!get_capacity(sgp) || (!disk_max_parts(sgp) &&
-				   (sgp->flags & GENHD_FL_REMOVABLE)))
+	if (!get_capacity(sgp))
 		return 0;
 	if (sgp->flags & GENHD_FL_SUPPRESS_PARTITION_INFO)
 		return 0;
-- 
2.30.2


Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51A3DC433FE
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Nov 2022 20:58:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236332AbiKWU6d (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Nov 2022 15:58:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239286AbiKWU6N (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Nov 2022 15:58:13 -0500
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C88A140C0;
        Wed, 23 Nov 2022 12:58:13 -0800 (PST)
Received: by mail-pj1-f49.google.com with SMTP id k5so16838660pjo.5;
        Wed, 23 Nov 2022 12:58:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Wi2GoAyFUTgrX+Rf06IdeXck2r4WJc+cBT1lfqDw3xY=;
        b=7KPdZBcRl5RL7CrSyKMqzzyRnqgBH5TwreJ7FaUVAI//sjzPB87lhz5nP7zNqbCHZK
         oTBejhcCEEeqSoZSI+eotpHOSpNWkHLRGNYz9nzP/ul6TRxrlxo26PcpERlL+oiQbKBS
         Nx5AuVxvJ3t/WpLMxelQe/FW05Jr+/z/RxxULulzcNyMtsPmV36I8kde0vRkC36jwBt0
         6UL6k1/5Eq/B6EmEMCq5NAT7rcPJNuEzmfB37GziNyrUcRe16c4LE1KLHDJBOhHs/HDS
         Yl/7NvXpQBZwWX8g9iie+Rv5G+pY/dWhf4oe8h/FTSG98/CBXXzoXL/Td90wnTOAefPY
         iDDQ==
X-Gm-Message-State: ANoB5pnyDaQCx7UPxJgD+2nIKe1alHCp/h83VZK/T3NR1M5E4HX8XE8r
        eVC5tE3BM5nIAxJFK+h/bdg=
X-Google-Smtp-Source: AA0mqf7JLxx2EB1MmUPgcoW8eaI7dcQjvOeS5t4YGMA4EzQEoDZFVU7fffM1286cjbbLsUKB7y5xTw==
X-Received: by 2002:a17:90a:7b8f:b0:218:b477:98e0 with SMTP id z15-20020a17090a7b8f00b00218b47798e0mr16210151pjc.173.1669237092704;
        Wed, 23 Nov 2022 12:58:12 -0800 (PST)
Received: from bvanassche-glaptop2.roam.corp.google.com ([2601:642:4c02:686d:4311:4764:eee7:ac6d])
        by smtp.gmail.com with ESMTPSA id i89-20020a17090a3de200b0020b2082e0acsm1858809pjc.0.2022.11.23.12.58.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Nov 2022 12:58:11 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Ming Lei <ming.lei@redhat.com>, Keith Busch <kbusch@kernel.org>
Subject: [PATCH v2 5/8] block: Add support for small segments in blk_rq_map_user_iov()
Date:   Wed, 23 Nov 2022 12:57:37 -0800
Message-Id: <20221123205740.463185-6-bvanassche@acm.org>
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
In-Reply-To: <20221123205740.463185-1-bvanassche@acm.org>
References: <20221123205740.463185-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Before changing the return value of bio_add_hw_page() into a value in
the range [0, len], make blk_rq_map_user_iov() fall back to copying data
if mapping the data is not possible due to the segment limit.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Keith Busch <kbusch@kernel.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 block/blk-map.c | 27 ++++++++++++++++++++++-----
 1 file changed, 22 insertions(+), 5 deletions(-)

diff --git a/block/blk-map.c b/block/blk-map.c
index d2d6ee098514..f3f2ed9c6183 100644
--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -308,17 +308,26 @@ static int bio_map_user_iov(struct request *rq, struct iov_iter *iter,
 		else {
 			for (j = 0; j < npages; j++) {
 				struct page *page = pages[j];
-				unsigned int n = PAGE_SIZE - offs;
+				unsigned int n = PAGE_SIZE - offs, added;
 				bool same_page = false;
 
 				if (n > bytes)
 					n = bytes;
 
-				if (!bio_add_hw_page(rq->q, bio, page, n, offs,
-						     max_sectors, &same_page)) {
+				added = bio_add_hw_page(rq->q, bio, page, n,
+						offs, max_sectors, &same_page);
+				if (added == 0) {
 					if (same_page)
 						put_page(page);
 					break;
+				} else if (added != n) {
+					/*
+					 * The segment size is smaller than the
+					 * page size and an iov exceeds the
+					 * segment size. Give up.
+					 */
+					ret = -EREMOTEIO;
+					goto out_unmap;
 				}
 
 				bytes -= n;
@@ -672,10 +681,18 @@ int blk_rq_map_user_iov(struct request_queue *q, struct request *rq,
 
 	i = *iter;
 	do {
-		if (copy)
+		if (copy) {
 			ret = bio_copy_user_iov(rq, map_data, &i, gfp_mask);
-		else
+		} else {
 			ret = bio_map_user_iov(rq, &i, gfp_mask);
+			/*
+			 * Fall back to copying the data if bio_map_user_iov()
+			 * returns -EREMOTEIO.
+			 */
+			if (ret == -EREMOTEIO)
+				ret = bio_copy_user_iov(rq, map_data, &i,
+							gfp_mask);
+		}
 		if (ret)
 			goto unmap_rq;
 		if (!bio)

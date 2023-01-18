Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D49FC32793
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Jan 2023 22:55:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230083AbjARWz3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 Jan 2023 17:55:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230100AbjARWzE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Jan 2023 17:55:04 -0500
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 109334EE3;
        Wed, 18 Jan 2023 14:55:04 -0800 (PST)
Received: by mail-pj1-f50.google.com with SMTP id dw9so565991pjb.5;
        Wed, 18 Jan 2023 14:55:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8FHeIkpZ3n/K79o6PVCquebIpeBJv71/l9JcoJvwK1g=;
        b=eeM3hXll1YYtfuBXhg4gvHADZYnNATGIjjYGkrImacQzs/E1QZXHvtbrFDT9CivoHH
         aDZX/p20mU0DZvj/sH39CwcBowfbD8nOBeMpk5C5HTSdIPLmxGOOoFiDPQncxpulW4T2
         twqno8y5qCDF9tuaebINXSxITaICvzMPP8Rize5hMHvEfIAtqOCvIrYA+syPDE35ibwb
         QRJEawrQO3xWJUyNRiYfrkykp+UsvjxywDMHk5itApL4isuzJLAg9kTjnk1j43m1RWZu
         LKtrPY+SqexztkUyTVBoRvvpkIq6rbe4oD4uKMHJutplfuC01L9euO7vu0fSXarSYN3h
         lqSw==
X-Gm-Message-State: AFqh2krDdwZujXBEk/9VyfPzmU6201txygdl5SGFwiQjJoJXrFEhzCUG
        ndYcRTJQHOgC6+GiboO94/I=
X-Google-Smtp-Source: AMrXdXuFtPzD624UHf0yDyzCeTMwsNc4xwl52ec0sndI+H7slfBmvrjTlMV3kqUAdURi2AOXftymUw==
X-Received: by 2002:a17:902:8a98:b0:194:9c0d:9732 with SMTP id p24-20020a1709028a9800b001949c0d9732mr9130265plo.46.1674082503545;
        Wed, 18 Jan 2023 14:55:03 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:22ae:3ae3:fde6:2308])
        by smtp.gmail.com with ESMTPSA id u7-20020a17090341c700b00186e34524e3sm23649466ple.136.2023.01.18.14.55.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 14:55:02 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Keith Busch <kbusch@kernel.org>
Subject: [PATCH v3 5/9] block: Add support for small segments in blk_rq_map_user_iov()
Date:   Wed, 18 Jan 2023 14:54:43 -0800
Message-Id: <20230118225447.2809787-6-bvanassche@acm.org>
X-Mailer: git-send-email 2.39.0.246.g2a6d74b583-goog
In-Reply-To: <20230118225447.2809787-1-bvanassche@acm.org>
References: <20230118225447.2809787-1-bvanassche@acm.org>
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
index 4270db88e2c2..83163f9b2335 100644
--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -307,17 +307,26 @@ static int bio_map_user_iov(struct request *rq, struct iov_iter *iter,
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
@@ -671,10 +680,18 @@ int blk_rq_map_user_iov(struct request_queue *q, struct request *rq,
 
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

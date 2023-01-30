Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4963DC6379F
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Jan 2023 21:27:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231130AbjA3V1Q (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 30 Jan 2023 16:27:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230513AbjA3V1N (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Jan 2023 16:27:13 -0500
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F88636FD8;
        Mon, 30 Jan 2023 13:27:13 -0800 (PST)
Received: by mail-pl1-f174.google.com with SMTP id m13so1146938plx.13;
        Mon, 30 Jan 2023 13:27:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rtucAFCDyuLZyrm6z27M/7hQlUm2l9x/qBJJhm+fNmU=;
        b=nbLprZAxrbq+6CTEVxAAhbkwXujmC2CeZ62qcKuIgDaw7yQ6C5w9n4A55yVRXOYFFQ
         Yz6z4F0/E3yQEtyU1tqdVTyPdNU6FStpjGUjTJovBBIxUwnGkSpyrM/ar97SumsBTj6H
         n1i54/6ZDe6S/XDXZpncWXAOmlHLh1rrxGxIxEQ0b00L1+9/Hy+ZWc2+Oc8ivAoV37vc
         j0IwoAbWE9y4+lmkQtgPLLuWkTuYD2JbtMssNclmxkwVXlU+v/RhECPa58pH48OgDcu+
         ESmbiMWAIAGaGBTsl7E2SukJv0uzWccQx131j5R4Cx8MXe00W7e/b9B1Ri9A4DLZsN5t
         pSHQ==
X-Gm-Message-State: AFqh2kprDdFO1ClLM3A/yU8typMYTvKnyecDFrA6XOSJVfAgsENYQd2M
        HEhOKcwhyfauVnmwSbPXIho=
X-Google-Smtp-Source: AMrXdXtlZP1XxVoQCk5h0aRRePW2d8tgHgY7Xxu8XR1dpG1TYt/mXu08DHFujMUaY5mJx99pADsEag==
X-Received: by 2002:a17:903:248f:b0:189:6ab3:9e64 with SMTP id p15-20020a170903248f00b001896ab39e64mr47521682plw.34.1675114032726;
        Mon, 30 Jan 2023 13:27:12 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:5016:3bcd:59fe:334b])
        by smtp.gmail.com with ESMTPSA id u18-20020a170902e5d200b00196087a3d7csm7425613plf.77.2023.01.30.13.27.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jan 2023 13:27:12 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Keith Busch <kbusch@kernel.org>
Subject: [PATCH v4 5/7] block: Add support for small segments in blk_rq_map_user_iov()
Date:   Mon, 30 Jan 2023 13:26:54 -0800
Message-Id: <20230130212656.876311-6-bvanassche@acm.org>
X-Mailer: git-send-email 2.39.1.456.gfc5497dd1b-goog
In-Reply-To: <20230130212656.876311-1-bvanassche@acm.org>
References: <20230130212656.876311-1-bvanassche@acm.org>
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
index eb059d3a1be2..b1dad4690472 100644
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
@@ -657,10 +666,18 @@ int blk_rq_map_user_iov(struct request_queue *q, struct request *rq,
 
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

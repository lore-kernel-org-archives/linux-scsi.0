Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DDB1CDB483
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Oct 2023 20:48:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235005AbjJQUsZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Oct 2023 16:48:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234920AbjJQUsW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Oct 2023 16:48:22 -0400
Received: from mail-ot1-f46.google.com (mail-ot1-f46.google.com [209.85.210.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28C73F0;
        Tue, 17 Oct 2023 13:48:20 -0700 (PDT)
Received: by mail-ot1-f46.google.com with SMTP id 46e09a7af769-6bd04558784so4295711a34.3;
        Tue, 17 Oct 2023 13:48:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697575699; x=1698180499;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0zKJwlNU37xBJ2eHozPULDjMADCdbgGWOVklVioEvRw=;
        b=Gxlro9T61b1KesibqkjGemRoap/RNCyK/8Ee2ueiuBbn/a3JD2GtbtESncvg9wEgCP
         snXF6aOXfo2/cwlBdWmc5qPXRdjDxokeB7+zqkYYJMC3/lGzfRyXaVmM+daR0bqJLnwV
         uWpBSTZuQ+OYIPnNKgLGcKrv5yaoQ06TI/lO1sSdhZL5aoi1jlW1Z7HyODyWXA5bPiHP
         vk/PEzDKHaWDMqxdohrtAvUKEMdU5CIIc4dSced8/EuqWcJ2BFIitSwa2H+VO/26ADok
         C6P31FC24jakwi9xd/Xq+ltKRjzyqGF4dh4VxTEi/23CWsZcCCKKojTJhtabR7q5Go/c
         jbwg==
X-Gm-Message-State: AOJu0Yz8w6FtUUwwxK1cZCwEBPMl0uCBENN5j9wqoEB7QfSMTsQvXJ9a
        qnJbo+navUeVtw6gI+DUHig=
X-Google-Smtp-Source: AGHT+IEE6N0vYqYBGbaDDPav+vLSuM2Vwj8TQAV4LWIeBTn/WK/tEcpCesHGpwI+JsErwXCHOyTl/g==
X-Received: by 2002:a9d:4811:0:b0:6c4:fc45:8681 with SMTP id c17-20020a9d4811000000b006c4fc458681mr3499731otf.25.1697575699367;
        Tue, 17 Oct 2023 13:48:19 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:8f02:2919:9600:ac09])
        by smtp.gmail.com with ESMTPSA id fa36-20020a056a002d2400b006b2e07a6235sm1874704pfb.136.2023.10.17.13.48.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Oct 2023 13:48:19 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Niklas Cassel <Niklas.Cassel@wdc.com>,
        Avri Altman <Avri.Altman@wdc.com>,
        Bean Huo <huobean@gmail.com>,
        Daejun Park <daejun7.park@samsung.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Damien Le Moal <dlemoal@kernel.org>
Subject: [PATCH v3 02/14] block: Restore data lifetime support in struct bio and struct request
Date:   Tue, 17 Oct 2023 13:47:10 -0700
Message-ID: <20231017204739.3409052-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.42.0.655.g421f12c284-goog
In-Reply-To: <20231017204739.3409052-1-bvanassche@acm.org>
References: <20231017204739.3409052-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Provide a mechanism for filesystems to pass data lifetime information
to block drivers. Data lifetime information can be used by block devices
with append/erase storage technology (NAND flash) to reduce garbage
collection activity.

This patch restores a subset of the functionality that was removed by
commit c75e707fe1aa ("block: remove the per-bio/request write hint").

Cc: Christoph Hellwig <hch@lst.de>
Cc: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 block/bio.c                 | 2 ++
 block/blk-crypto-fallback.c | 1 +
 block/blk-merge.c           | 6 ++++++
 block/blk-mq.c              | 1 +
 block/bounce.c              | 1 +
 include/linux/blk-mq.h      | 2 ++
 include/linux/blk_types.h   | 2 ++
 7 files changed, 15 insertions(+)

diff --git a/block/bio.c b/block/bio.c
index 816d412c06e9..1a3733635079 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -251,6 +251,7 @@ void bio_init(struct bio *bio, struct block_device *bdev, struct bio_vec *table,
 	bio->bi_opf = opf;
 	bio->bi_flags = 0;
 	bio->bi_ioprio = 0;
+	bio->bi_lifetime = 0;
 	bio->bi_status = 0;
 	bio->bi_iter.bi_sector = 0;
 	bio->bi_iter.bi_size = 0;
@@ -813,6 +814,7 @@ static int __bio_clone(struct bio *bio, struct bio *bio_src, gfp_t gfp)
 {
 	bio_set_flag(bio, BIO_CLONED);
 	bio->bi_ioprio = bio_src->bi_ioprio;
+	bio->bi_lifetime = bio_src->bi_lifetime;
 	bio->bi_iter = bio_src->bi_iter;
 
 	if (bio->bi_bdev) {
diff --git a/block/blk-crypto-fallback.c b/block/blk-crypto-fallback.c
index e6468eab2681..e25a6d551594 100644
--- a/block/blk-crypto-fallback.c
+++ b/block/blk-crypto-fallback.c
@@ -172,6 +172,7 @@ static struct bio *blk_crypto_fallback_clone_bio(struct bio *bio_src)
 	if (bio_flagged(bio_src, BIO_REMAPPED))
 		bio_set_flag(bio, BIO_REMAPPED);
 	bio->bi_ioprio		= bio_src->bi_ioprio;
+	bio->bi_lifetime	= bio_src->bi_lifetime;
 	bio->bi_iter.bi_sector	= bio_src->bi_iter.bi_sector;
 	bio->bi_iter.bi_size	= bio_src->bi_iter.bi_size;
 
diff --git a/block/blk-merge.c b/block/blk-merge.c
index 65e75efa9bd3..62718cc871bd 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -814,6 +814,9 @@ static struct request *attempt_merge(struct request_queue *q,
 	if (rq_data_dir(req) != rq_data_dir(next))
 		return NULL;
 
+	if (req->lifetime != next->lifetime)
+		return NULL;
+
 	if (req->ioprio != next->ioprio)
 		return NULL;
 
@@ -941,6 +944,9 @@ bool blk_rq_merge_ok(struct request *rq, struct bio *bio)
 	if (!bio_crypt_rq_ctx_compatible(rq, bio))
 		return false;
 
+	if (rq->lifetime != bio->bi_lifetime)
+		return NULL;
+
 	if (rq->ioprio != bio_prio(bio))
 		return false;
 
diff --git a/block/blk-mq.c b/block/blk-mq.c
index a815403f375c..10540a3b3c49 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -3148,6 +3148,7 @@ int blk_rq_prep_clone(struct request *rq, struct request *rq_src,
 	}
 	rq->nr_phys_segments = rq_src->nr_phys_segments;
 	rq->ioprio = rq_src->ioprio;
+	rq->lifetime = rq_src->lifetime;
 
 	if (rq->bio && blk_crypto_rq_bio_prep(rq, rq->bio, gfp_mask) < 0)
 		goto free_and_out;
diff --git a/block/bounce.c b/block/bounce.c
index 7cfcb242f9a1..b03e4944ace8 100644
--- a/block/bounce.c
+++ b/block/bounce.c
@@ -169,6 +169,7 @@ static struct bio *bounce_clone_bio(struct bio *bio_src)
 	if (bio_flagged(bio_src, BIO_REMAPPED))
 		bio_set_flag(bio, BIO_REMAPPED);
 	bio->bi_ioprio		= bio_src->bi_ioprio;
+	bio->bi_lifetime	= bio_src->bi_lifetime;
 	bio->bi_iter.bi_sector	= bio_src->bi_iter.bi_sector;
 	bio->bi_iter.bi_size	= bio_src->bi_iter.bi_size;
 
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 1ab3081c82ed..1afd731432fe 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -136,6 +136,7 @@ struct request {
 #endif
 
 	unsigned short ioprio;
+	enum rw_hint lifetime;
 
 	enum mq_rq_state state;
 	atomic_t ref;
@@ -957,6 +958,7 @@ static inline void blk_rq_bio_prep(struct request *rq, struct bio *bio,
 	rq->__data_len = bio->bi_iter.bi_size;
 	rq->bio = rq->biotail = bio;
 	rq->ioprio = bio_prio(bio);
+	rq->lifetime = bio->bi_lifetime;
 }
 
 void blk_mq_hctx_set_fq_lock_class(struct blk_mq_hw_ctx *hctx,
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index d5c5e59ddbd2..5e21f44141fb 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -10,6 +10,7 @@
 #include <linux/bvec.h>
 #include <linux/device.h>
 #include <linux/ktime.h>
+#include <linux/rw_hint.h>
 
 struct bio_set;
 struct bio;
@@ -269,6 +270,7 @@ struct bio {
 						 */
 	unsigned short		bi_flags;	/* BIO_* below */
 	unsigned short		bi_ioprio;
+	enum rw_hint		bi_lifetime;	/* data lifetime */
 	blk_status_t		bi_status;
 	atomic_t		__bi_remaining;
 

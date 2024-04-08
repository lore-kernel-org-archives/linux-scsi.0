Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F00E6FBF;
	Mon,  8 Apr 2024 01:41:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712540500; cv=none; b=SSLxPsxKxJnVN66gksPgozYzEq8bMq6WaW9ZC15ausfiu+x7/PU20uai/1j3SGlq7P9DNF0gcfrwa2gU4qBWASAqpSbD2hm0X27ZBnByCt2/TeKAnCXt0cgIcrfK04Wiubq1KoG5K0F7187kCS+0lgOP3xlopM3IIkbaqObTeJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712540500; c=relaxed/simple;
	bh=mhbZvPP+15TDS1MY0Yw0EBLbI5487ds6Bv343XngRvA=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UbpIFTXpFJXKrR82oBbc7t1WqPFJs61TRxf6F/OpEs+be0P9we9JzJe+cqr76EzrmEyBJ+AxS47EAq4vGuUxhW1D4p88Kll2TRtQDGeW8pwFrWdtj3vT9U2318S0PnEfgyOgdMMRIWKHQj52G5pUAMjdbXGK82RoiGn07eA5mWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lYvdo4qd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lYvdo4qd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90901C433C7;
	Mon,  8 Apr 2024 01:41:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712540500;
	bh=mhbZvPP+15TDS1MY0Yw0EBLbI5487ds6Bv343XngRvA=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=lYvdo4qdM2Kq1CpvUPioziDdhXfOMdCtiW2uzOIQ4MDk7YoZABzZdBF/ihsbh9+F0
	 mayMwjN1W/wixnQlnrlUzfnM0gaTFuLslXzmqWKGIbMZhnNRTdBWcCZGzxPKshxSF6
	 mjwiBECIta3fM9ufvx2p9kael1Voe6CVvCF7mO5j4vHCAcmU4FHGshsZyX73bn/WvW
	 ob9sNVqEe51I4DA1vFZoGe0nbqccH4c3avvNyzYQt1hgtmcbqhPdLrVWDOpHTbZS7b
	 eW7RcQxQWXyKDhd2uA2jCOakcDu4BwOswTWuUy4vUjuxyYO0AxaNgcQhtGZsDxzSpt
	 IiBdxku2blHQA==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	dm-devel@lists.linux.dev,
	Mike Snitzer <snitzer@redhat.com>,
	linux-nvme@lists.infradead.org,
	Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH v7 05/28] block: Allow using bio_attempt_back_merge() internally
Date: Mon,  8 Apr 2024 10:41:05 +0900
Message-ID: <20240408014128.205141-6-dlemoal@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408014128.205141-1-dlemoal@kernel.org>
References: <20240408014128.205141-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Remove "static" from the definition of bio_attempt_back_merge() and
declare this function in block/blk.h to allow using it internally from
other block layer files. The definition of enum bio_merge_status is
also moved to block/blk.h.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Tested-by: Hans Holmberg <hans.holmberg@wdc.com>
Tested-by: Dennis Maisenbacher <dennis.maisenbacher@wdc.com>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 block/blk-merge.c | 8 +-------
 block/blk.h       | 8 ++++++++
 2 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/block/blk-merge.c b/block/blk-merge.c
index 4e3483a16b75..3363b1321908 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -972,13 +972,7 @@ static void blk_account_io_merge_bio(struct request *req)
 	part_stat_unlock();
 }
 
-enum bio_merge_status {
-	BIO_MERGE_OK,
-	BIO_MERGE_NONE,
-	BIO_MERGE_FAILED,
-};
-
-static enum bio_merge_status bio_attempt_back_merge(struct request *req,
+enum bio_merge_status bio_attempt_back_merge(struct request *req,
 		struct bio *bio, unsigned int nr_segs)
 {
 	const blk_opf_t ff = bio_failfast(bio);
diff --git a/block/blk.h b/block/blk.h
index 17786052f32d..bca50a9510c8 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -269,6 +269,14 @@ static inline void bio_integrity_free(struct bio *bio)
 unsigned long blk_rq_timeout(unsigned long timeout);
 void blk_add_timer(struct request *req);
 
+enum bio_merge_status {
+	BIO_MERGE_OK,
+	BIO_MERGE_NONE,
+	BIO_MERGE_FAILED,
+};
+
+enum bio_merge_status bio_attempt_back_merge(struct request *req,
+		struct bio *bio, unsigned int nr_segs);
 bool blk_attempt_plug_merge(struct request_queue *q, struct bio *bio,
 		unsigned int nr_segs);
 bool blk_bio_list_merge(struct request_queue *q, struct list_head *list,
-- 
2.44.0


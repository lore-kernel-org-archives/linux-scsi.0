Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FC416FE2A;
	Wed,  3 Apr 2024 08:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712133778; cv=none; b=hJIPq7dlODnVF7U9t0XuXjEyuY+uLvOUgNE8mFL0rJy6FFqslwMidhgSlO2Z7Aq4Z2RpAbV/IYjmYgjnS+RtP9+TkOOhXddfeDE4gMB0uOhhfk0AioxoNR4UgtWz+53wIltOPQeq++ODW3PyYmJWwnIA8ZDMmrhCFoNsufHt1UA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712133778; c=relaxed/simple;
	bh=qXjGHVWjqr2orY91/Ggfq1GwyhXXkL7+eIYmUkoNTtc=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LCvrurX781x517gXsJTLEvhgp442gheh7fGEnfh9+RQPeHyd0+60HCSTpcytTvV+P5xfhMtKzXd/giRB7BnvknBOU/v7ncMA1DAYZMgpvEAj5Z9HEebvXKA6pKnZ8KuCZKeLwiQCmf3UxIIhzw23MF2LqbV1w6h0IiYo0G5ZKyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qnocDY2n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qnocDY2n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86A4BC43390;
	Wed,  3 Apr 2024 08:42:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712133777;
	bh=qXjGHVWjqr2orY91/Ggfq1GwyhXXkL7+eIYmUkoNTtc=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=qnocDY2nWpqIHsLzg62VbQ/9I5csk1aJLi460L3JNpSaRryb9xuRLQnu+kY2DEa3V
	 bnAXguSv80t8YnjifAleke7Lh1+9LHzJ/6omzmS4TXorzzcCU6CtOle94epM1PVHgf
	 RNFBb4hjXgs+uvDEqJxf68Y/xJLLEpylxWB0ANxfReZEdxVLSAyhcQpWh6rN5czInt
	 6memPzSMPKvCvOV4iQbDUdxQLqxlr6X0NfROoivYSmZ9ZuIcWNrkmDHr+aCR/iMR81
	 HbQoA0E+WH409bAVBmW5R3eQsiPLmeUDVT7lsZlL5ybH4U+GgVUsfNgCd5UAE14084
	 LuLZwkAPiTi7g==
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
Subject: [PATCH v5 05/28] block: Allow using bio_attempt_back_merge() internally
Date: Wed,  3 Apr 2024 17:42:24 +0900
Message-ID: <20240403084247.856481-6-dlemoal@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240403084247.856481-1-dlemoal@kernel.org>
References: <20240403084247.856481-1-dlemoal@kernel.org>
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


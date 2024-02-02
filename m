Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7F1317998;
	Fri,  2 Feb 2024 07:31:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706859075; cv=none; b=XyVTJJJaRiIvB6w5qcha06CVgEvfyj6NMvmZ0B3cyAFfOGeEq7CmOz0pV4Vh6vVbMMzJkzuQEP3XVj8ArDEIdmAz0JoNm7JaMC3mmf9ou5COseu6+egrF4mtFZyCkKBYO/W0zZk3WG8yltAOYOAOtPfn+nQ9B12iOfaqjBbC6Yw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706859075; c=relaxed/simple;
	bh=PKmt4teAnQCPFNGrbo7NJPs+GbxyF6dMFp0LwfNph5E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hTh62oWRmz6Vn/3MCG5kf+D06QEOcuiFzW73ezOQYozMBpV2ULsGaxmn9rZV1sDIPARiRwem8dVJH4Hz8dEyBGr0YCbY56z/S73F4kmYdlepvHiGnZughik5pykMmrd17iQmaiZTkTZNiBF90KENu78WRon+J5j8dA/pmi1EUbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eX2Vtkjd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eX2Vtkjd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5486CC433C7;
	Fri,  2 Feb 2024 07:31:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706859074;
	bh=PKmt4teAnQCPFNGrbo7NJPs+GbxyF6dMFp0LwfNph5E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eX2Vtkjd6JpF+BLXgL3Gd5tPvW7OEQg9sZ+HdVaXyp2AoiwsDRNt6TVMgVrrEp37X
	 uWP2vOlIfqOOPp4Nb0m4ogy/Bm+lmrg0X8rlfcViVQPxU9NvtNSvbko8ber8oJpqof
	 e9F0JfNhLr+x59CJY/6M/OxyzdoEFO8yci2din4q7YwofZh2TgVwSdDDj1gqjRDmwr
	 LQyiMtJMRxBU7D/S+YoNCepneTCqlS3nXz082cVCMkHNFgc/MfPrZxk++1/+ADmBYO
	 CQpgVA8kpIbnfU9d1g2nJk4hmI++gn7FDb+Zqle+pt4E/4uAvG5tphaoXCAAynz7Rz
	 gFHW/AghWoUGg==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	dm-devel@lists.linux.dev,
	Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 05/26] block: Allow using bio_attempt_back_merge() internally
Date: Fri,  2 Feb 2024 16:30:43 +0900
Message-ID: <20240202073104.2418230-6-dlemoal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240202073104.2418230-1-dlemoal@kernel.org>
References: <20240202073104.2418230-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Remove the static definition of bio_attempt_back_merge() to allow using
this function internally from other block layer files. Add the
definition of enum bio_merge_status and the declaration of
bio_attempt_back_merge() to block/blk.h.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 block/blk-merge.c | 8 +-------
 block/blk.h       | 8 ++++++++
 2 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/block/blk-merge.c b/block/blk-merge.c
index 2d470cf2173e..a1ef61b03e31 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -964,13 +964,7 @@ static void blk_account_io_merge_bio(struct request *req)
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
index 23f76b452e70..5180e103ed9c 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -256,6 +256,14 @@ static inline void bio_integrity_free(struct bio *bio)
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
2.43.0


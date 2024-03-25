Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFD9F1C3226;
	Mon, 25 Mar 2024 04:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711341904; cv=none; b=iCb+s6DYur00MihJ3t0LeOsNh61GoVeJFAHn9ZVcdPQimPEG6hcxmlG/wI9oK0wk7qIF4OG6raYCARrukrZfiUW20YGegfF7SRawK/bMxFW2mZhn1lyzP0AymQHJXEP7A4qq/nAIWbIsQy/Via6e7RWAgQgRqDG6SuEfEbu/+ps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711341904; c=relaxed/simple;
	bh=CkPyHDMXj/emYxOVYSrpv0KfBhMWGJbbF1G8OvaM55I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lum0Ws8A5pmx9VK0QKjgtTDUKnvasQwSgda7tSuZxFOoSD9R0D9EZhQD9f//UHn8J+HQZkAGGVAT5jPZiN/egj3FpLZBlDDtaoMWpwgNksGyvw/ETMRlqLMJSP5NLx24Hcu5dmHAjs+FPma99GE0q8MN3xJkdYH7iyIAmkmGNd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EdHdyJVl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EdHdyJVl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1522C433C7;
	Mon, 25 Mar 2024 04:45:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711341904;
	bh=CkPyHDMXj/emYxOVYSrpv0KfBhMWGJbbF1G8OvaM55I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EdHdyJVlP6K4jK85XhV1PdCaIVxQPBWpX0hQ+Fa+jGAWKdV0iJI8dUjgyOcAyxCNG
	 nmTCgrwyePSr3yr3PYc44Tymtt2SCO7cht9UjgC6i3IK9wyEvF8Wg9Mksy0sBZ3mvq
	 PktNjtRYxoq8qprIrpvH7AHZO4FDkRyaji6RIKgfr6PwAtLG4ILbXchZjhdtCvAByH
	 Sy1m7SwxpQ1+CQENRRTCM+Dpuawu+y/28rkqprOVuQV2Okwb4NY7ga9vIiXWa8/ghw
	 wmtKBD8zgGi/pBDILOE0bwgotFiniQa2+MtbHSj4ac9QivGG1auQvdby+WfK5nnMOe
	 cMznGkTGkdwOQ==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	dm-devel@lists.linux.dev,
	Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Subject: [PATCH v2 05/28] block: Allow using bio_attempt_back_merge() internally
Date: Mon, 25 Mar 2024 13:44:29 +0900
Message-ID: <20240325044452.3125418-6-dlemoal@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240325044452.3125418-1-dlemoal@kernel.org>
References: <20240325044452.3125418-1-dlemoal@kernel.org>
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
---
 block/blk-merge.c | 8 +-------
 block/blk.h       | 8 ++++++++
 2 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/block/blk-merge.c b/block/blk-merge.c
index 2a06fd33039d..88367c10c8bc 100644
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
index a12cde1d45de..f2a521b72f9d 100644
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


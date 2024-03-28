Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41EBB2B9CC;
	Thu, 28 Mar 2024 00:44:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711586664; cv=none; b=TV7mM116k4F5t/mKJV9KejZMwwqTdqz0OJaxotlDC9O4JPTOcYa8CbokX9HqARwSbhiPaz1yJwOkLfrzEL01WvJIS7IhpcLp2g3pQpbWCFDRmpYuPk4jGYx0NGCOgzqn9PLZW3BvVdaVXRcHbvIbkjA17iUDJCYPoMNvjwmIfLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711586664; c=relaxed/simple;
	bh=GRSnttSon36Brl7D5Dx+9ESml44bLMxHIragGuHvzQM=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oGCM67iwTonp7FxeIOg0JeiOpBlTHaNLBgCZ1OZ5bieVaLnCiv71xVuw5NAch/P95B9RJC9KY2DF6hWP0LAmHp8Y0MSxGlFF2Wr8ozoBREhbUF1W5lD1aZ3G3CR7JqjqiBYXeaKxKYrl4HBuN0h7k4ym2oXZcWoFAy/j4UQu0lw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XSaBxRRf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XSaBxRRf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68234C43394;
	Thu, 28 Mar 2024 00:44:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711586663;
	bh=GRSnttSon36Brl7D5Dx+9ESml44bLMxHIragGuHvzQM=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=XSaBxRRfeqVCTRVCby32lohAfjvxsK7E4403PRBbuP0ZpI6o6IWZaPNTl55Gutdbp
	 OlvPNvhg5VtqlQEdd2gpdpv3DrIql2hchehu1IkM9JmH22RFogmwicgOk0/APK3TrF
	 FdYI/LFEJU7f7jcWFRk3lEwZ1ra3ThQuJF+MEeMUKPYImPJbBXsenMaq0D54Yv2QCF
	 0gHdcXSbMpCovo8NfM/evozz6m62Qr7w77DmuYhNsmUDEXii+bu4LVAP0mw6R5tk6B
	 /wgBaIIgcO1wcu18uR9Ao83Whxzis1sYhFhoCV7anhdfcbkMc8I6U095Hhy+d2uYqM
	 VvU4mlJz9d6yg==
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
Subject: [PATCH v3 06/30] block: Allow using bio_attempt_back_merge() internally
Date: Thu, 28 Mar 2024 09:43:45 +0900
Message-ID: <20240328004409.594888-7-dlemoal@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240328004409.594888-1-dlemoal@kernel.org>
References: <20240328004409.594888-1-dlemoal@kernel.org>
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


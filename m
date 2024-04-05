Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 175CD24B26;
	Fri,  5 Apr 2024 04:42:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712292137; cv=none; b=r8KYRG0sv6pGJ29tjTioFI49CAXzpK+A+BwS3K21kTTqE6ZKwx7inkbNqr3OcxXq2a8t63lFpjxCwsHoW/7iiJNbFEi7XIFSzeotteVDOIrc8Y7MQsdHqlEsN9pmanHghuqabxPT29mWK786+hntB5YFz49XUDF/lTG9SM3x87E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712292137; c=relaxed/simple;
	bh=Psfl/jmWSX5gl8cykLhLSXQA1aPpWSzL1AVZwTM+VIc=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NMDN8Hqf8NKSFNQgAoOvJz178ZQDqKinPO7Oz9z+meEjEOxWXuTqQW17Hb1c13zkdCHaFKtGB2jb4gDajHMg00+2l9Y/bA7LXJH7yEVoc5FANulD9WSVFUsDS5L863H7wLCkapeO4ZlZM6Z13LtVqQQcokxLCFjPqZAcAqovZrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HUL8/poB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HUL8/poB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5561C433B2;
	Fri,  5 Apr 2024 04:42:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712292136;
	bh=Psfl/jmWSX5gl8cykLhLSXQA1aPpWSzL1AVZwTM+VIc=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=HUL8/poB3QOW7waEYho9vvystJ0O3nU3TAUP8SbPmpQ1d+udWUTMvZvXGO9bU0Xf+
	 nO8CMRMNAKFS0+WeB/QUqbbi8L9yXRhsOTl1SuAn/gu7WA1FrTcREfaujTQxjSwKir
	 dVidztx/46eTtRqPWG1biOtZ3ND6zyfKNxNEW8+bm8F8r8MDekN61ytQq77fijeHDR
	 rGw6itKrcMLhlVdDdXkZaSSxoVwfwud0mvogp6JFOqkZGAJklozJN8vkwYHW337n0X
	 bZx5Tahj61lHmGtU1+L2S4HD4bZVc4+oqpt4WGJ6SwFm36TBu1nSgtrhBvkd6TKECE
	 E8MDgQ6f8AwUQ==
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
Subject: [PATCH v6 05/28] block: Allow using bio_attempt_back_merge() internally
Date: Fri,  5 Apr 2024 13:41:44 +0900
Message-ID: <20240405044207.1123462-6-dlemoal@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240405044207.1123462-1-dlemoal@kernel.org>
References: <20240405044207.1123462-1-dlemoal@kernel.org>
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


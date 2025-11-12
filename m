Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B1E52D662F
	for <linux-scsi@vger.kernel.org>; Wed, 12 Nov 2025 18:24:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762971881; cv=none; b=WR7frW5OXbxT75Xx7LCZfnDroPVlMl/kgKLrfEHDT7sw5wOnPB3KmRkQEnywGXs9AYTPW2TCarcB01QTOErBvUy8YuULmbuu4lrb/hBAaZwYgdTWvwm08OqGeh8+Tpe8pceMBZcU4GEawRT6u3gLovMLQTYAkieBw0cqNLzfJc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762971881; c=relaxed/simple;
	bh=mS6wigkQ+U6OXCvvldfQxi8FdkXq/nn2p1OjcwwPINU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Q58GJTRHQJ5i0xgRJv9g2VTsSerbxVvCbo4Ckhlx2KNK2ejy0MOIsY4ByGbm2NasKMZhuXykLcv2WzP2pdQNKEDmDroccT/Jpghd21CrKHmXkwau7pyfvP3oFmcJRDkRfRh41X/xKkXs6YTpCvP+RgXw8Mnj7fqKMO4Sv3yjI28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=pn4oYFEP; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="pn4oYFEP"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4d6BdL4H9zzltJ2g;
	Wed, 12 Nov 2025 18:24:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1762971877; x=1765563878; bh=dzT4N1IhUtGwYn0VFk500z953Ex2t2XmzKL
	JiKJxzpw=; b=pn4oYFEP+oqQiOrJr7ZbsZhVSfJzDd1PhWDJ8GQnabUTpo1EQPQ
	SADGAaY/dHme2W2UZ76p5bgzll0zaFTYFvjFlBTLVSO00MEw8n7GcUh3XEcSscI9
	+WN9qWs1J+460FWgzuOW232hygKabnJtCpHPYlOs+xVXFbSV0220GB7DfpMcr+SO
	Jbnr3RC1qPm0ofKzvukxC0fYAumBJbL26VkLxESxpSYRmyu3hYpDtSu3+Pdjx5JT
	Gq8F1VQeaI0faZ4nFIv26ZrnJzVFX9Groi4/NljxS/TGtaLYpP2NHY0kWpsq3Sdb
	SDaBdcuHReGkkHpImosM+2XQg6LgR9Kn9Yg==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id DM30niI0FwMD; Wed, 12 Nov 2025 18:24:37 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4d6BdD5g3lzlng1b;
	Wed, 12 Nov 2025 18:24:32 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] blk-zoned: Document disk_zone_wplug_schedule_bio_work() locking
Date: Wed, 12 Nov 2025 10:24:21 -0800
Message-ID: <20251112182421.3047074-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.2.1041.gc1ab5b90ca-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Document that all callers hold this lock because the code in
disk_zone_wplug_schedule_bio_work() depends on this.

Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 block/blk-zoned.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index 57ab2b365c2d..5487d5eb2650 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -1188,6 +1188,8 @@ void blk_zone_mgmt_bio_endio(struct bio *bio)
 static void disk_zone_wplug_schedule_bio_work(struct gendisk *disk,
 					      struct blk_zone_wplug *zwplug)
 {
+	lockdep_assert_held(&zwplug->lock);
+
 	/*
 	 * Take a reference on the zone write plug and schedule the submission
 	 * of the next plugged BIO. blk_zone_wplug_bio_work() will release the

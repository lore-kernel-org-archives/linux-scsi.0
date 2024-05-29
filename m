Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C10A615B96F;
	Wed, 29 May 2024 05:05:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716959129; cv=none; b=kV0GAQ7Y7e3AB0w/wv8T+1m0EideVu1+WvIBU7QVHDLLio0nsUZ1wyOaewWtyoFyH2Rmd7tB5D33GsB7da6YdkVzQCab3aHJ4ChKPT8xPtTMnf/FDeTbxF6m5DGD7gZcl7b9jPT0Wu1NN9Yo3ocfflqSb8iZUPfA5zLH9+65hi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716959129; c=relaxed/simple;
	bh=1jB5uk+EXpM6R9rMgfS3hbrOYPXAn2MKuAQmgkZdGMw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GpsyiQtbSWPYkgJchEdTKUrS619Tnh1JwoAdga1xpQElmwrdvhDkDeZHA+H+i76CJShD/EIejY439/l2asOJQNFr0G9WdqsxSkGxKw0LHQBfEOIFjBkFdFvxmDQ+FXemBMCT6jDB6v+vI07gNY9OtYBjgCdwrru6R7u6oRnKGyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=rkKRbg5+; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="rkKRbg5+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=TFSwqKWMmudUxPiHaYQymKxOAPLlhLvIfGoe7lZ0Qm8=; b=rkKRbg5+hgq4FGzAhQuNxXCeww
	mYQ8LVxno936/Ke445SPr6vK77vH49ODPijMtTeGT6y17DO9VfLcNXcbJC5f4YwikvZ/giTD5aSWr
	2/AHxlrhMzrmMO9T4Siy0wWkSgBb4UwcUKe9nErCSp2M0KBoTzzxuF7KCfENr2yMCRDFL5eOvmh5m
	DeI3cPeP2Ved5/finWngzKaglnh7GYz6CIk2ozhCEb5yygEKOZrT2sr+DGXVaF5ohZ5wPEa/h0W27
	kIoeJXcGLgBclxYAHBILjIeu4JHHgDvp6JkiOgDF6dY2FxeqMeWGRaO5M9Fa1XPikTiqcIhm1oz/O
	/sPDQu3w==;
Received: from 2a02-8389-2341-5b80-7775-b725-99f7-3344.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:7775:b725:99f7:3344] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sCBV5-00000002pXT-2RwQ;
	Wed, 29 May 2024 05:05:24 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Richard Weinberger <richard@nod.at>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Josef Bacik <josef@toxicpanda.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Dongsheng Yang <dongsheng.yang@easystack.cn>,
	=?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>,
	linux-um@lists.infradead.org,
	linux-block@vger.kernel.org,
	nbd@other.debian.org,
	ceph-devel@vger.kernel.org,
	xen-devel@lists.xenproject.org,
	linux-scsi@vger.kernel.org
Subject: [PATCH 05/12] sd: add a sd_disable_write_same helper
Date: Wed, 29 May 2024 07:04:07 +0200
Message-ID: <20240529050507.1392041-6-hch@lst.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240529050507.1392041-1-hch@lst.de>
References: <20240529050507.1392041-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Add helper to disable WRITE SAME when it is not supported and use it
instead of sd_config_write_same in the I/O completion handler.  This
avoids touching more fields than required in the I/O completion handler
and  prepares for converting sd to use the atomic queue limits API.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/sd.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index a8838381823254..09ffe9d826aeac 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1004,6 +1004,13 @@ static blk_status_t sd_setup_write_zeroes_cmnd(struct scsi_cmnd *cmd)
 	return sd_setup_write_same10_cmnd(cmd, false);
 }
 
+static void sd_disable_write_same(struct scsi_disk *sdkp)
+{
+	sdkp->device->no_write_same = 1;
+	sdkp->max_ws_blocks = 0;
+	blk_queue_max_write_zeroes_sectors(sdkp->disk->queue, 0);
+}
+
 static void sd_config_write_same(struct scsi_disk *sdkp)
 {
 	struct request_queue *q = sdkp->disk->queue;
@@ -2258,8 +2265,7 @@ static int sd_done(struct scsi_cmnd *SCpnt)
 				if (SCpnt->cmnd[1] & 8) { /* UNMAP */
 					sd_disable_discard(sdkp);
 				} else {
-					sdkp->device->no_write_same = 1;
-					sd_config_write_same(sdkp);
+					sd_disable_write_same(sdkp);
 					req->rq_flags |= RQF_QUIET;
 				}
 				break;
-- 
2.43.0


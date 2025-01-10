Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1BEF38FB0;
	Fri, 10 Jan 2025 05:47:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736488081; cv=none; b=pHmK4DF9CqdQNK164mvdfn9rMgiNpm6FPA32uw6HMujmVZg4c5KtN7cj5Dr2k1OZ1zZXDXxgrEFEMGwavL8EngYqnuoJJM6ADjsyCI08yyCoIuY8s8JqR6t9LE0+YkFm6wYfaBKgHqNJH9RVuNDj6yNhV5q/2+yPxoR8nCfX8tk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736488081; c=relaxed/simple;
	bh=VuikUYicmto3+EyEIp4aEWZ63s8C57wQbbO14B09+d0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WkDoT+Wt2sNTOFMiFOXnflK7oukhYhNZAdZ3I0UQJv02m7/nKGS5yC/TmIw/s15Nb75qaxXNr1ho9gWARFhqN9L2Uvr5b7BMnfUDoim2E2i2ekjXXe0zf55k/T9vyex7G9cvGMQVQRilZLG790moJTJrNes8ZFThtwzjfwqYmO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=xXxPJBUy; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="xXxPJBUy"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=XXeZfDK7dJVOyTo0xukyM87qHprt43czTsxZpCM1/Ns=; b=xXxPJBUyXLvo3VV5VyRYA2GbJA
	olLJK/bw+wcxnP60YVRYtQ79DpaWB+gSqUji5RMF5qMcvfSzM1KcEqfkKYw3HLUFSWqYLGvv7/N92
	orfUHpGt77DDa5dLCuuSVcyE7wqJckr/AZyrP6oJoeqbJiI/M5HPFPrPQcASaUqGO21z3w21p6iJj
	CoLlRdhdNdvqG5JVVZjss/jBht02+tF5OMIgT1mUrnrTACccEem1QLG2OjduLjMS8gUzasSaPfQrJ
	e1CXl/TRzHH7MfBGJ1s8oYwIIvOuhU1PxyN15DF+rtf1PcO0Jz/A2zU7IRYtOk94RM0GtIf5pjX+j
	l8r8X0bQ==;
Received: from 2a02-8389-2341-5b80-76c3-a3dc-14f6-94e8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:76c3:a3dc:14f6:94e8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tW7sC-0000000E54X-3y9C;
	Fri, 10 Jan 2025 05:47:57 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Ming Lei <ming.lei@redhat.com>,
	Nilay Shroff <nilay@linux.ibm.com>,
	linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	nbd@other.debian.org,
	linux-scsi@vger.kernel.org,
	usb-storage@lists.one-eyed-alien.net,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH 11/11] loop: fix queue freeze vs limits lock order
Date: Fri, 10 Jan 2025 06:47:19 +0100
Message-ID: <20250110054726.1499538-12-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250110054726.1499538-1-hch@lst.de>
References: <20250110054726.1499538-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Match the locking order used by the core block code by only freezing
the queue after taking the limits lock using the
queue_limits_commit_update_frozen helper and document the callers that
do not freeze the queue at all.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Reviewed-by: Nilay Shroff <nilay@linux.ibm.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 drivers/block/loop.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 560d6d5879d6..15e486baa223 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -311,6 +311,13 @@ static void loop_clear_limits(struct loop_device *lo, int mode)
 		lim.discard_granularity = 0;
 	}
 
+	/*
+	 * XXX: this updates the queue limits without freezing the queue, which
+	 * is against the locking protocol and dangerous.  But we can't just
+	 * freeze the queue as we're inside the ->queue_rq method here.  So this
+	 * should move out into a workqueue unless we get the file operations to
+	 * advertise if they support specific fallocate operations.
+	 */
 	queue_limits_commit_update(lo->lo_queue, &lim);
 }
 
@@ -1091,6 +1098,7 @@ static int loop_configure(struct loop_device *lo, blk_mode_t mode,
 
 	lim = queue_limits_start_update(lo->lo_queue);
 	loop_update_limits(lo, &lim, config->block_size);
+	/* No need to freeze the queue as the device isn't bound yet. */
 	error = queue_limits_commit_update(lo->lo_queue, &lim);
 	if (error)
 		goto out_unlock;
@@ -1151,7 +1159,12 @@ static void __loop_clr_fd(struct loop_device *lo)
 	lo->lo_sizelimit = 0;
 	memset(lo->lo_file_name, 0, LO_NAME_SIZE);
 
-	/* reset the block size to the default */
+	/*
+	 * Reset the block size to the default.
+	 *
+	 * No queue freezing needed because this is called from the final
+	 * ->release call only, so there can't be any outstanding I/O.
+	 */
 	lim = queue_limits_start_update(lo->lo_queue);
 	lim.logical_block_size = SECTOR_SIZE;
 	lim.physical_block_size = SECTOR_SIZE;
@@ -1471,9 +1484,10 @@ static int loop_set_block_size(struct loop_device *lo, unsigned long arg)
 	sync_blockdev(lo->lo_device);
 	invalidate_bdev(lo->lo_device);
 
-	blk_mq_freeze_queue(lo->lo_queue);
 	lim = queue_limits_start_update(lo->lo_queue);
 	loop_update_limits(lo, &lim, arg);
+
+	blk_mq_freeze_queue(lo->lo_queue);
 	err = queue_limits_commit_update(lo->lo_queue, &lim);
 	loop_update_dio(lo);
 	blk_mq_unfreeze_queue(lo->lo_queue);
-- 
2.45.2


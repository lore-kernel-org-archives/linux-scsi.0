Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E7C71DFE0F;
	Wed,  8 Jan 2025 09:25:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736328329; cv=none; b=hQLgjinxtrbyU04zb9+jTyeK1pTDnP+VslvfkLau199iRF0WWuFRkJC7i7uNDV8qT+GmwF3++8qdTsAnfW5cghzdXTJdan+HMinCD1AfEUA9Nh6v0Dd/xVVMPhJ880weJg4d90iQv3OdOdd/dhykf5IMPBfPtxeeuPAx5CPHcOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736328329; c=relaxed/simple;
	bh=51OdyArMhA13t1sHHIo3Yq4bAJmUU8545KUPgdYpLsQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s4EC6TKBmy1oL9pSiqRW6Ua/oD8dJECmbMHCdFDjgniIz3Icr7qbeLAB5UZyx7x3HoBbtqTdrKJ+pNyx6IkxtKZ+1CsLVrCwYV9xaJKjUeHwnmWiKb0UBmwi6BUChYk+bPDLk8a2fLtNizQGne/3brpqq6hlZbYL680Q557t5wk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=CqRbcX46; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="CqRbcX46"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=jNlH9hTwzoW9j2vVQOHx5Cm68J7JBPjoUbePjMLTFwc=; b=CqRbcX46KEG0w/Ywr42ah7hkfW
	SgYrDXTIfIw5Xwxoa93Iu28DbMuibDKq0hEulHTHwe8IYMTqRGQIzlY1ref1gF2vrbbKY6avWG+4v
	KsnKm3CP6y4A0zqXKn78lz5V/3KXCfU9U5+8ymfHOguLnhWH+NPBqyJjj+RCswBbmIgcCMx8+D8TG
	OJ8gy0PWoahfqED/PjfZyZyfdlubHsV6kNECMynhK+mweGE3tOeYwvKxW3KVNt/qhKQPLKNzSKWuF
	nubr6Ou3BUJ77EDko8pTqyE2CVQupKejrRFLvBhbd6kpincxIInz2Akq0Wh0y3WIge9b64UryIbyl
	dmzxhlHg==;
Received: from 2a02-8389-2341-5b80-e44b-b36a-6403-8f06.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:e44b:b36a:6403:8f06] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tVSJZ-00000007lPu-4C7k;
	Wed, 08 Jan 2025 09:25:27 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Ming Lei <ming.lei@redhat.com>,
	Nilay Shroff <nilay@linux.ibm.com>,
	linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	nbd@other.debian.org,
	linux-scsi@vger.kernel.org,
	usb-storage@lists.one-eyed-alien.net
Subject: [PATCH 01/10] block: fix docs for freezing of queue limits updates
Date: Wed,  8 Jan 2025 10:24:58 +0100
Message-ID: <20250108092520.1325324-2-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250108092520.1325324-1-hch@lst.de>
References: <20250108092520.1325324-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

queue_limits_commit_update is the function that needs to operate on a
frozen queue, not queue_limits_start_update.  Update the kerneldoc
comments to reflect that.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Nilay Shroff <nilay@linux.ibm.com>
---
 block/blk-settings.c   | 3 ++-
 include/linux/blkdev.h | 3 +--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index 8f09e33f41f6..89d8366fd43c 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -413,7 +413,8 @@ int blk_set_default_limits(struct queue_limits *lim)
  * @lim:	limits to apply
  *
  * Apply the limits in @lim that were obtained from queue_limits_start_update()
- * and updated by the caller to @q.
+ * and updated by the caller to @q.  The caller must have frozen the queue or
+ * ensure that there are no outstanding I/Os by other means.
  *
  * Returns 0 if successful, else a negative error code.
  */
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 5d40af2ef971..e781d4e6f92d 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -944,8 +944,7 @@ static inline unsigned int blk_boundary_sectors_left(sector_t offset,
  * the caller can modify.  The caller must call queue_limits_commit_update()
  * to finish the update.
  *
- * Context: process context.  The caller must have frozen the queue or ensured
- * that there is outstanding I/O by other means.
+ * Context: process context.
  */
 static inline struct queue_limits
 queue_limits_start_update(struct request_queue *q)
-- 
2.45.2


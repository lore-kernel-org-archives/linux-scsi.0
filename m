Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DCC04F8BB;
	Thu, 23 May 2024 18:26:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716488792; cv=none; b=fm3gdKA9RRRIXrXcQ7SyNb18X/ptVEW0JGcDRBrRSeTTZ82fFZRTsMrQ5VgErNR3Q60QkxPYctIEGyRJrx8yTTUOSqK4QZbaAjZX9aIXdVWiYjLypztH2OIzyhBqlzdQi0Y7mwTulJX763OSO0aOiMGCwmmrlYzMSxsJcJkRqiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716488792; c=relaxed/simple;
	bh=FEkbrR4RVP7X5is4cPrFKiWWVk/5nbFmRPASHoFWGks=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bpip+wjv5I00qO4CWN/dxR+9wpktdKNTgj5FV3dQfXdL00INjgTsGxm3cJo5tzvUo2I5RO/k3lspuR+c1HK+qzHarGEp8c6F/qahfVVGRmHuM3Trc3AcpVHniFPIdEmoQO/SBP4Sw7DWSB1gQKRNCYx5y+S9iEO7m3NsWkgaWQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=gdutvfu2; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="gdutvfu2"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=XE7qBJnuFjyYMkqKnKDGyEubnvbqFLxQ7afyBE57uIc=; b=gdutvfu2RAH2BsAe+rZ7zyvdAS
	VJzv21967qhv3DNkGwjYLVNBLILdLLwhWSFHDr7JZ2/z/XV5tMYidKzPgbhdJVK/4hPwkfNi0u6zy
	03fql/B9CKds5t4UZQ/b2l1FjMOc1FGV6oOLrq5Tn85vhlCYcMa+v0TO+GZwEVv8Ui7VXB0iT9N2q
	iu9JpiCaGfVzUzmU+u2Ccv3VNkiKjtgNBndguS34IJ2j4UGHkK1z/Z1q9sKPptpNI+W6xWJVWMgh0
	kzgYrumErB5WkJmSZPRCI/6Xo62SoHJUtcV3FRc/BGB27+UqBNze60BHmKqqKW9ROypEDeqkT4p4U
	LCCQXkUg==;
Received: from [2001:4bb8:2d0:ea45:284:cf8f:6784:4c64] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sAD93-000000070rG-49UW;
	Thu, 23 May 2024 18:26:30 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
	Mike Snitzer <snitzer@kernel.org>,
	linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org
Subject: [PATCH 2/2] block: stack max_user_sectors
Date: Thu, 23 May 2024 20:26:14 +0200
Message-ID: <20240523182618.602003-3-hch@lst.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240523182618.602003-1-hch@lst.de>
References: <20240523182618.602003-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

The max_user_sectors is one of the three factors determining the actual
max_sectors limit for READ/WRITE requests.  Because of that it needs to
be stacked at least for the device mapper multi-path case where requests
are directly inserted on the lower device.  For SCSI disks this is
important because the sd driver actually sets it's own advisory limit
that is lower than max_hw_sectors based on the block limits VPD page.
While this is a bit odd an unusual, the same effect can happen if a
user or udev script tweaks the value manually.

Fixes: 4f563a64732d ("block: add a max_user_discard_sectors queue limit")
Reported-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Mike Snitzer <snitzer@kernel.org>
---
 block/blk-settings.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index a7fe8e90240a6e..7a672021daee6a 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -611,6 +611,8 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
 	unsigned int top, bottom, alignment, ret = 0;
 
 	t->max_sectors = min_not_zero(t->max_sectors, b->max_sectors);
+	t->max_user_sectors = min_not_zero(t->max_user_sectors,
+			b->max_user_sectors);
 	t->max_hw_sectors = min_not_zero(t->max_hw_sectors, b->max_hw_sectors);
 	t->max_dev_sectors = min_not_zero(t->max_dev_sectors, b->max_dev_sectors);
 	t->max_write_zeroes_sectors = min(t->max_write_zeroes_sectors,
-- 
2.43.0


Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1636D770EE;
	Fri, 31 May 2024 07:48:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717141738; cv=none; b=jSmhOGPPEq3PPFhDfgp720ctJcryM0OSt6cgSOm2q4//T57g+21n3IfppfkWANqfsjBE4nzgyIovOiFmjY+Sp/2uvwQPfyH2XYv6/DMPhOfJwT4RB+nR64haYqZ4YztGmqzdAIvz22P0Pag1sLIM9Fhhy7JxX/zgR0xVH11wGY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717141738; c=relaxed/simple;
	bh=p/E9HpdBg2UQgknNtgIi3vtLTqwRaCIQ8zlRIQfAFV4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HZTnOYxpHmx1CJNc2wPU0o5j2e3/+n6+lCQRB6dXxbrfEyXA06r7uUgz1zDEVpVC11Lu10Tv2GwG0KDZ80TtDkLQjylGwBH+wv1zPFcR+YFMFzaxcTbhCFvCtuUqB2tU98yocR2t4X0t20gXhZLDirS50kWwAs4xpU3NpUOym/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=NQeQhA2U; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="NQeQhA2U"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=0q2p+u53R9YY1ujQIkkIYHdGljvaoYfmRjVYZa1pGUw=; b=NQeQhA2UOUYImH9TH8f84PjtdO
	ObERM3qoC8ul3CKlxRBe0dwRdXaSSfDKIuJPDJKIXddbCk4DuIEOabi0xeClPM4iSB5KZs7KRVBke
	QXuG41cYK3YbO5bkABYuBrfzr2b20SayGqug5sRun1euqWYw8yIMYgwVe7df1qO/MfVZyOgF1Y4jH
	8S8LuTfmFWj0aSfI2cvZCNBbal2QtT+CQ6/gS37bIRRARF26B6AGUCKpsAA2d+30Zq8U6sLyU8dBv
	Bk3tXLY8MqgLz5OO3tA8AK0iTNwDc6TpStdHEqtPrSKHpQTid5SoU4/Ug1OFPywaZgXzR2J5gCky/
	tKVHxQ0Q==;
Received: from 2a02-8389-2341-5b80-5ba9-f4da-76fa-44a9.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:5ba9:f4da:76fa:44a9] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sCx0N-00000009XXW-22Ka;
	Fri, 31 May 2024 07:48:52 +0000
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
Subject: [PATCH 03/14] rbd: increase io_opt again
Date: Fri, 31 May 2024 09:47:58 +0200
Message-ID: <20240531074837.1648501-4-hch@lst.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240531074837.1648501-1-hch@lst.de>
References: <20240531074837.1648501-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Commit 16d80c54ad42 ("rbd: set io_min, io_opt and discard_granularity to
alloc_size") lowered the io_opt size for rbd from objset_bytes which is
4MB for typical setup to alloc_size which is typically 64KB.

The commit mostly talks about discard behavior and does mention io_min
in passing.  Reducing io_opt means reducing the readahead size, which
seems counter-intuitive given that rbd currently abuses the user
max_sectors setting to actually increase the I/O size.  Switch back
to the old setting to allow larger reads (the readahead size despite it's
name actually limits the size of any buffered read) and to prepare
for using io_opt in the max_sectors calculation and getting drivers out
of the business of overriding the max_user_sectors value.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/block/rbd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index 26ff5cd2bf0abc..46dc487ccc17eb 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -4955,8 +4955,8 @@ static int rbd_init_disk(struct rbd_device *rbd_dev)
 	struct queue_limits lim = {
 		.max_hw_sectors		= objset_bytes >> SECTOR_SHIFT,
 		.max_user_sectors	= objset_bytes >> SECTOR_SHIFT,
+		.io_opt			= objset_bytes,
 		.io_min			= rbd_dev->opts->alloc_size,
-		.io_opt			= rbd_dev->opts->alloc_size,
 		.max_segments		= USHRT_MAX,
 		.max_segment_size	= UINT_MAX,
 	};
-- 
2.43.0


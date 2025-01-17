Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B7491F667B;
	Fri, 17 Jan 2025 07:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737099892; cv=none; b=Etpkm61nYr8/6R3ixfk3F965aKwNLejGWArkOotX5P+ssibtNqpTkWUw4A3qMrr/Is/oQgM7d4weZRn5mbxGkXe6B5Ukp60361/pE6QYUsSyx5f54S9L6BTOgDQ3xz3RNEgayJgBMKZerqdE1H9Epu4oA0dyFLEFsxUbMh9nHQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737099892; c=relaxed/simple;
	bh=iLFeFgJBQq+EVVLfnkAn0BkZsnZrrM/rF8e8ZzHoevA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KxjtOeM4GWo8ioc4hwgZWqNRIUYTOkJOLhWNntOGZKm0NuMBZnnIRoPnrGxySxDXNm8sGYvSh0P78ZtNUWcoAxjtmYn41qjd4b/3+uM63NckMU8sg3KDcjl2750CECmiUNH0DgPaMbylvBBXnLUooQhibjPAYoIaZvE/4JCjXQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=2dEUUUR5; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="2dEUUUR5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=MJqlvj+lu/Tzo60R4fD2XZkdHzGxsT6TPL3RonbMnlI=; b=2dEUUUR515Jj2FeyOOf2Ibp6wG
	oO4a0DXalSwp+GhtzaUsv05dGHjMtcHNLohdl5EdyV0PDSVGzFFgbOIlQKxDUBq0Z0X/WLLnMg+vY
	t3O+CSWdT1hJfem+0QgjhjfCYCJIGFChJI6oMElR5w8IDAoXdL1HAdNLmnzqiY4f9fhjUoHxIu6I/
	KK4jMqKNaZ8iuV2F6NdPjYJoQyN/1wSOxv56Lahl7bOmN0+Sudvv+Yd3qniMsgwmHARfrNVTn6jl+
	+0IxdBUmqleJpl1EHIVpinZdoOY29nlaIqI53iJI0lAYPnTUefirspdb7V2xaXlUVCOhDER4tai9L
	lui9Cujg==;
Received: from 2a02-8389-2341-5b80-41c4-d87f-051e-5808.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:41c4:d87f:51e:5808] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tYh28-0000000HECO-38Y1;
	Fri, 17 Jan 2025 07:44:49 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: Ming Lei <ming.lei@redhat.com>,
	linux-block@vger.kernel.org,
	nbd@other.debian.org,
	ceph-devel@vger.kernel.org,
	virtualization@lists.linux.dev,
	linux-mtd@lists.infradead.org,
	linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org
Subject: [PATCH 1/2] loop: force GFP_NOIO for underlying file systems allocations
Date: Fri, 17 Jan 2025 08:44:07 +0100
Message-ID: <20250117074442.256705-2-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250117074442.256705-1-hch@lst.de>
References: <20250117074442.256705-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

File systems can and often do allocate memory in the read-write path.
If these allocations are done with __GFP_IO or __GFP_FS set they can
recurse into the file system or swap device on top of the loop device
and cause deadlocks.  Prevent this by forcing a noio scope over the
calls into the file system.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/block/loop.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 1ec7417c7f00..71eccc5cfffb 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -1905,6 +1905,15 @@ static void loop_handle_cmd(struct loop_cmd *cmd)
 	int ret = 0;
 	struct mem_cgroup *old_memcg = NULL;
 	const bool use_aio = cmd->use_aio;
+	unsigned int memflags;
+
+	/*
+	 * We're calling into file system which could do be doing memory
+	 * allocations.  Ensure the memory reclaim does not cause I/O,
+	 * because that could end up in the user of this loop devices again and
+	 * deadlock.
+	 */
+	memflags = memalloc_noio_save();
 
 	if (write && (lo->lo_flags & LO_FLAGS_READ_ONLY)) {
 		ret = -EIO;
@@ -1942,6 +1951,7 @@ static void loop_handle_cmd(struct loop_cmd *cmd)
 		if (likely(!blk_should_fake_timeout(rq->q)))
 			blk_mq_complete_request(rq);
 	}
+	memalloc_noio_restore(memflags);
 }
 
 static void loop_process_work(struct loop_worker *worker,
-- 
2.45.2


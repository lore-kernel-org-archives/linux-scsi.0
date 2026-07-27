Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 820DF363C6F
	for <linux-scsi@vger.kernel.org>; Mon, 27 Jul 2026 02:45:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785120310; cv=none; b=KBV1EOIm8S4qQGUmHAAzakCNG+7R2r8/UByKPgEzpX/1V40RqogMy9fAlM524OX9fgeFlgJ6//15zQmE5LcGbpV5gD/fwmZOQQO+T2uBCPwnTw1G9JLQKwmG1/aETOqmYWUjE/93Z/Ew4egzHKTBfNCgI1Wgh4y3mscrAa5y0Io=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785120310; c=relaxed/simple;
	bh=fID5X1Rlt0gJdWicRbYWAwRqvT0svu8PSHmpBC4hhJQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rT8qgtHGMm8iONhExTczqhJ3ozc9gCAc+chHZJGqZ366imjR622jBK3TJtUuZDd9mWoZud5/ck+qOuJA3xDFfKVwgsSMu1JRBL2M9secD0x7Hta5hGIJWZgGX6/eFqrUVA/QsXEj3nIzyZYhBRXOB5Ugvod6hRYWpKq7jgvPU5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=kWKyxZGG; arc=none smtp.client-ip=220.197.31.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="kWKyxZGG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version:
	Content-Type; bh=fID5X1Rlt0gJdWicRbYWAwRqvT0svu8PSHmpBC4hhJQ=;
	b=kWKyxZGGXMLF2Ljjb602gZ6Yt7bBnRPfXCV9HA749Vl6L0NzGhb+vE5/S5NHnq
	K0qYZQHNwYaPL1Foe+l38p/u7m7wmB7ts7lOvNH1HSeX2ni04c0cypUTjqaVvL6o
	xEK9OBq7kmsv33LN3dYXh+OkiKol5uPeNKS/HVqLOiGYg=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g0-3 (Coremail) with SMTP id _____wDX3RccxmZqpLJ2Lw--.60073S2;
	Mon, 27 Jul 2026 10:44:45 +0800 (CST)
From: Yang Xiuwei <yangxiuwei@kylinos.cn>
To: sashiko-bot@kernel.org
Cc: linux-scsi@vger.kernel.org,
	sashiko-reviews@lists.linux.dev
Subject: Re: [PATCH v2 2/2] scsi: bsg: map io_uring user buffers with GFP_KERNEL
Date: Mon, 27 Jul 2026 10:44:44 +0800
Message-Id: <20260727024444.1917979-1-yangxiuwei@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260727015542.D929B1F000E9@smtp.kernel.org>
References: <20260727015542.D929B1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDX3RccxmZqpLJ2Lw--.60073S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7uFykKry3tw4xXr45XFyfCrg_yoW8Gw1DpF
	s5K3Z7GFWUGF1SqF9rWFsrWr10kw4xAa45GF4rXr45Zrn8Xw1Ikr4agFW09FW5Zw1fCFWj
	qF40gF97Ar1UAa7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0zRVWlPUUUUU=
Sender: yangxiuwei2025@163.com
X-CM-SenderInfo: p1dqw55lxzvxisqskqqrwthudrp/xtbCwR3sfWpmxh0tCQAA3+

On Mon, Jul 27, 2026 at 01:55:42AM +0000, sashiko-bot wrote:
> [Severity: High]
> This is a pre-existing issue, but does using GFP_KERNEL here cause a tag
> exhaustion deadlock?
>
> Prior to this call, scsi_alloc_request() consumes a hardware tag. If
> GFP_KERNEL enters direct reclaim and needs to write dirty pages back to the
> same block device, the filesystem will attempt to allocate another tag.
>
> If all tags are currently held by blocked BSG tasks, won't the system deadlock?

This is not introduced by this patch.

> [Severity: High]
> Does removing the GFP_NOWAIT fallback for the non-blocking io_uring issue
> path introduce a permanent task_work deadlock?
>
> If a user submits more than 256 IORING_OP_URING_CMD operations in a single
> batch, the bio allocations will exhaust the fs_bio_set mempool. By passing
> GFP_KERNEL to blk_rq_map_user_iov(), mempool_alloc() will put the submitter
> thread to sleep waiting for a bio to be freed.
>
> Since these bios are freed when their completions run via task_work
> (scsi_bsg_uring_task_cb), which must be executed by the very submitter thread
> now permanently blocked in mempool_alloc(), does this create an unresolvable
> circular dependency?

No. A large submit batch alone does not force mempool wait, and fs_bio_set
is shared — progress does not depend only on this task's task_work. This
matches the nvme io_uring passthrough path.

Thanks,
Yang Xiuwei


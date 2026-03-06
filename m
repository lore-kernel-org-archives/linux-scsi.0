Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD448366837;
	Fri,  6 Mar 2026 02:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772765802; cv=none; b=ISUwd0h+ebNgkaSgXIruDtasY8YTRQj2I88VVGCZz9DiAy6XbjSiKzjx5miUbpGWzhMq9fcnvfI6qBheniA7wEzMxLeV/Q/okZQk877AY8CBMHxNhPXULQ8/JCrmb5etzstp1OYY7XFd+8LyA9G5TCGMwiwc8FX8dDN7KTLFpR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772765802; c=relaxed/simple;
	bh=QdmCK8n9xPoYfTeCR+DIHI7weIfZDv8rCQmKfAkXeb0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=H5d0QzAlokVZ/bTxM54NY8ChHBvHk3/ipVLeHuKT4Z8veFr4BGLa0II+P+xgpr+Mk+Z0seVHY+p0kvmY7yPU0ltif9Q0DL4/urTuBB9kfT5EohSsXcoFepZUes9Df86cD3LvL0gmVtMNFn0K7fRzsuVSezGe2peaIOwqbCjyLGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=PXKdJHpn; arc=none smtp.client-ip=220.197.31.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="PXKdJHpn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=Qd
	mCK8n9xPoYfTeCR+DIHI7weIfZDv8rCQmKfAkXeb0=; b=PXKdJHpnpZ+Hs8EJaN
	xbclhb134MfTb1QURbSPArssmwyXDULilBsdTPufYxF4GBTNja1ttjuM9mgmMgX2
	9HhkdfUSXCGM9WYXlIvfPxSs7jotfw1CZWWCkECLot6W5ldJNBm5CpbQw9XbFgt8
	DyfQnVNODiYLPS8he+lRX0P9g=
Received: from localhost.localdomain (unknown [])
	by gzsmtp1 (Coremail) with SMTP id PCgvCgA3IvLyQappXRjwQQ--.604S2;
	Fri, 06 Mar 2026 10:54:44 +0800 (CST)
From: Yang Xiuwei <yangxiuwei@kylinos.cn>
To: bvanassche@acm.org
Cc: fujita.tomonori@lab.ntt.co.jp,
	axboe@kernel.dk,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	yangxiuwei@kylinos.cn,
	linux-scsi@vger.kernel.org,
	linux-block@vger.kernel.org,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 1/3] bsg: add bsg_uring_cmd uapi structure
Date: Fri,  6 Mar 2026 10:54:42 +0800
Message-Id: <20260306025442.70173-1-yangxiuwei@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <7ca36cbb-c9d9-47b8-be1b-b51ab8da16c0@acm.org>
References: <20260304080313.675768-1-yangxiuwei@kylinos.cn> <20260305012857.2136525-1-yangxiuwei@kylinos.cn> <20260305012857.2136525-2-yangxiuwei@kylinos.cn> <7ca36cbb-c9d9-47b8-be1b-b51ab8da16c0@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PCgvCgA3IvLyQappXRjwQQ--.604S2
X-Coremail-Antispam: 1Uf129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvjxUb6wZDUUUU
Sender: yangxiuwei2025@163.com
X-CM-SenderInfo: p1dqw55lxzvxisqskqqrwthudrp/xtbCwRSSI2mqQfSuPwAA3D

On 2026-03-05 15:14, Bart Van Assche wrote:
> Please document what flags are supported and what their meaning is.

After analysis, I've decided to remove the flags field entirely since
io_uring already provides sufficient control mechanisms (sqe->flags,
sqe->uring_cmd_flags, issue_flags). The flags field is not used in the
current implementation and is not needed for future functionality, as
io_uring's existing flags cover all necessary control aspects.

Will remove the flags field in v7.

Best regards,
Yang Xiuwei


Received: from mail-m49197.qiye.163.com (mail-m49197.qiye.163.com [45.254.49.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F03D33A6F0F;
	Sat, 26 Sep 2026 09:22:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.254.49.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790414533; cv=none; b=OM314eyj6L7jNRHIFDp4BQVZDGP7OTUg/f02fmhY/V30Ce9jrzWEl2SQ9DZ845O88DP/mJXnd8kt7U9uUFi38lMaky3Bofv/46UXXNkkAQ6HdfZphWI7dNNI8TLnL7MvllvcJCye1Y1rN84edBMjBpMzz9UoZP94zUzmMzscKb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790414533; c=relaxed/simple;
	bh=DOThejXWVqAfk3OaqwNpRk1a5A1+irOq8Jh0nrn3g5g=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ceW1EXOq2bWcl2h5uKfUSwsM+Q8HzMt9rjAhcxB1fqjXFjj+BNPskz/DP5gETGff6oLlS1BrVx1QF+CJ7FfP6xdFJkghOofWLdJjhVDV+7n7sMQww25pW1EcUVbiP83nytxHQIfoww6aJtHfNDEet3rtkR5LR3fbnWz7YaLDmik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn; spf=pass smtp.mailfrom=seu.edu.cn; dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b=Fz/VZxVz; arc=none smtp.client-ip=45.254.49.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b="Fz/VZxVz"
Received: from PC-202605011814.localdomain (unknown [222.191.246.242])
	by smtp.qiye.163.com (Hmail) with ESMTP id 4f2ff7121;
	Sat, 26 Sep 2026 17:21:53 +0800 (GMT+08:00)
From: Runyu Xiao <runyu.xiao@seu.edu.cn>
To: Christoph Hellwig <hch@lst.de>
Cc: Breno Leitao <leitao@debian.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Keith Busch <kbusch@kernel.org>,
	Logan Gunthorpe <logang@deltatee.com>,
	"Martin K. Petersen" <mkp@kernel.org>,
	Lee Duncan <lduncan@suse.com>,
	Hannes Reinecke <hare@suse.com>,
	Nicholas Bellinger <nab@linux-iscsi.org>,
	linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Jianhao Xu <jianhao.xu@seu.edu.cn>
Subject: [PATCH v6 0/4] nvmet: avoid recursive configfs open
Date: Sat, 26 Sep 2026 17:21:44 +0800
Message-Id: <20260926092148.128937-1-runyu.xiao@seu.edu.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa0dd05665c03a1kunmac953e9e17aa20
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkZHRlOVkoYSR1NH05JSx9MSVYeHw
	5VEwETFhoSFyQUDg9ZV1kYEgtZQVlJSUlVSkJKVUlPTVVJT0lZV1kWGg8SFR0UWUFZT0tIVUpLSE
	pPSExVSktLVUpCS0tZBg++
DKIM-Signature: a=rsa-sha256;
	b=Fz/VZxVz/PWuYCuYwrwz2XrVbk7oBRQJFvoIkAQjyzm3u5XfLgCSd7SWmD6EcMU6sDrYmxsVwY6svKD/85IA5eFN2to5zJWJRHY23+9yFz6mSt98fzMiXlaZRganuymXlYzX0PMzQOhXguFQcStAP7QhXSzTKa9XAP1CbdNBdFY=; c=relaxed/relaxed; s=default; d=seu.edu.cn; v=1;
	bh=a2KrQAmn3m5S4sDMBQfBCI0DjfyHtfNQlht7r6HJ/4Y=;
	h=date:mime-version:subject:message-id:from;

Several configfs store callbacks open user-configured paths while holding
the item's frag_sem.  If a configured path resolves into configfs, the open
can re-enter __configfs_open_file() and try to acquire the same
non-recursive semaphore again.

Add helpers in configfs for opening non-configfs paths, then use them in the
nvmet file-backed namespace and passthru paths.  The series also pins the
target-core db_root path and uses the root-relative helper for ALUA and APTPL
metadata, so the helper has its target-core consumer in the same series.

Changes since v5:
- Add the target-core db_root patch as 4/4 and use configfs_open_root() for
  validation and metadata opens.
- Replace the verbose helper kerneldoc with concise interface descriptions.
- Keep the Reviewed-by tags on the unchanged nvmet patches.

Runyu Xiao (4):
  fs: configfs: add helpers for opening non-configfs paths
  nvmet: avoid recursive configfs open for file-backed namespaces
  nvmet: avoid recursive configfs open for passthru
  scsi: target: pin db_root for metadata writes

 drivers/nvme/target/io-cmd-file.c     |   3 +-
 drivers/nvme/target/passthru.c        |   3 +-
 drivers/target/target_core_alua.c     |  42 +++++-----
 drivers/target/target_core_configfs.c | 116 ++++++++++++++++++++------
 drivers/target/target_core_internal.h |   3 +
 drivers/target/target_core_pr.c       |  21 +++--
 fs/configfs/mount.c                   |  53 ++++++++++++
 include/linux/configfs.h              |   5 ++
 8 files changed, 189 insertions(+), 57 deletions(-)


base-commit: df2908090cda368b01ff43709f51890076c56157
-- 
2.34.1

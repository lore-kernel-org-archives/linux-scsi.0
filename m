Received: from mail-m155101.qiye.163.com (mail-m155101.qiye.163.com [101.71.155.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12418260565;
	Sun, 27 Sep 2026 08:20:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=101.71.155.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790497233; cv=none; b=HNzYp8Fr2JEzrS+1YAT0WLMXp/OX20d+zniw6RitkQ9t/ZZzMRsyUrbZuEUsZPtxxY/fdK1HV4ohowFFXjtFuJai4BOEwWFRpUtywX8SXHF2tXda8ZTc8Hd5MVvM1RgKzHWbKuvAi84adnXnpmk9SoZIczbj+I2O6C0EIkJR2QI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790497233; c=relaxed/simple;
	bh=fALS5WyBoTBGjrQoxPuSSOQ4DyJxHITYum2wTqT7r1M=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=R6gy03z8udoTeHvjrW/gg/e1GOctkya+pR3kFxwp8lFkBYF1n/amB31ftMPIKGN0+5k12slezNunrQUlR6we+6BLroNuAbyr4UyRUHochBpbJK6rd3JyutDgAthJi/fhEee3pkAzgZ+LT/XSfgP0mvKR8JFaxbT7z071zX8UvF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn; spf=pass smtp.mailfrom=seu.edu.cn; dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b=CwU78sMv; arc=none smtp.client-ip=101.71.155.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b="CwU78sMv"
Received: from PC-202605011814.localdomain (unknown [222.191.246.242])
	by smtp.qiye.163.com (Hmail) with ESMTP id 4f3a443f6;
	Sun, 27 Sep 2026 16:20:22 +0800 (GMT+08:00)
From: Runyu Xiao <runyu.xiao@seu.edu.cn>
To: Christoph Hellwig <hch@lst.de>
Cc: Breno Leitao <leitao@debian.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Keith Busch <kbusch@kernel.org>,
	Logan Gunthorpe <logang@deltatee.com>,
	"Martin K . Petersen" <mkp@kernel.org>,
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
Subject: [PATCH v7 0/4] nvmet: avoid recursive configfs open
Date: Sun, 27 Sep 2026 16:20:07 +0800
Message-Id: <20260927082011.638723-1-runyu.xiao@seu.edu.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa0e1f36f2c03a1kunm12f6b69c1ac324
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkaQh0YVh4aH0hIGBpKTkJOSVYeHw
	5VEwETFhoSFyQUDg9ZV1kYEgtZQVlJSUlVSkJKVUlPTVVJT0lZV1kWGg8SFR0UWUFZT0tIVUpLSE
	pPSExVSktLVUpCS0tZBg++
DKIM-Signature: a=rsa-sha256;
	b=CwU78sMvDEsOExt0w+ZbN1oR1EIflpiWsDeKOcKPl1d2iF4JrnrQb1RTUCnW7rCWG14K1qOW5yp6HyQcyQ5xvXIWKviazvbR72a7LBPRG4mMIc4Oq3VM7Ihaig2dc+thj6ikXEr2tROgyasyPEKlx4GLLj32YloHpPAqUZl4xHY=; c=relaxed/relaxed; s=default; d=seu.edu.cn; v=1;
	bh=V2dwCmnh4jcZ0MUl2mHzbEQ5hr9TbVsuwLEVbpur9Q0=;
	h=date:mime-version:subject:message-id:from;

Several configfs store callbacks open user-configured paths while holding
the item's frag_sem.  If a configured path resolves into configfs, the open
can re-enter __configfs_open_file() and try to acquire the same
non-recursive semaphore again.

Add helpers in configfs for opening non-configfs paths, then use them in the
nvmet file-backed namespace and passthru paths.  The series also pins the
target-core db_root path and uses the root-relative helper for ALUA and APTPL
metadata, with a dedicated lock protecting the path and its configuration.

Changes since v6:
- Honor O_NOFOLLOW when resolving paths in configfs_file_open().
- Protect db_root and db_root_path against concurrent metadata writes and
  configfs updates.
- Return an error when a db_root update races with target device creation.

Checks:
- scripts/checkpatch.pl --strict: all 4 patches pass.
- Built the affected configfs, nvmet, and target-core objects.
- Applied the complete series to the stated base commit with git am.

Runyu Xiao (4):
  fs: configfs: add helpers for opening non-configfs paths
  nvmet: avoid recursive configfs open for file-backed namespaces
  nvmet: avoid recursive configfs open for passthru
  scsi: target: pin db_root for metadata writes

 drivers/nvme/target/io-cmd-file.c     |   3 +-
 drivers/nvme/target/passthru.c        |   3 +-
 drivers/target/target_core_alua.c     |  42 ++++----
 drivers/target/target_core_configfs.c | 142 +++++++++++++++++++++-----
 drivers/target/target_core_internal.h |   5 +
 drivers/target/target_core_pr.c       |  19 ++--
 fs/configfs/mount.c                   |  57 +++++++++++
 include/linux/configfs.h              |   5 +
 8 files changed, 219 insertions(+), 57 deletions(-)


base-commit: f741eaa40d2a8e199a31ceb683f30867537def70
-- 
2.34.1

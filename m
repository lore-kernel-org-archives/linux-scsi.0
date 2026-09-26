Received: from mail-m155101.qiye.163.com (mail-m155101.qiye.163.com [101.71.155.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 737BC3ACA42;
	Sat, 26 Sep 2026 09:22:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=101.71.155.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790414543; cv=none; b=XSitJOX4dqGJrbdu932mn9rmh+dqjhQ7a+V2oTXiy/BuOZqzlk9tka9mKxZbmfCQz2EfBfSIeh1JS2VSHNfca/XiE9AorVG/aoY/h52UbgRKK/L3EDLnMv/E9yzM1MTOxyw9SEFVr++QThbl2b0nUEB8RB+h5VYR0yzlpUpm6vc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790414543; c=relaxed/simple;
	bh=gwbthItRhuypYUcH713iH/hnNoRFDlBtn4qTU9lz7/M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=XqQ3PoX06eJv5WZ52SWcYtbNpXEYvlkhe0sd2jGEK+3+ddFgqRfX4M8/XUNozFkk+VE3lEhjc2qrg5Zsud3bpvQlafZ8oiiN5FfBDs9R2xmSexU5TALwEB3F/90oqkPQl+ZCXad+2br6FK/F8968pkF7iN/7gM6YrO6t31ho2Gs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn; spf=pass smtp.mailfrom=seu.edu.cn; dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b=nhe3qNpX; arc=none smtp.client-ip=101.71.155.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b="nhe3qNpX"
Received: from PC-202605011814.localdomain (unknown [222.191.246.242])
	by smtp.qiye.163.com (Hmail) with ESMTP id 4f2ff7124;
	Sat, 26 Sep 2026 17:21:59 +0800 (GMT+08:00)
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
Subject: [PATCH v6 3/4] nvmet: avoid recursive configfs open for passthru
Date: Sat, 26 Sep 2026 17:21:47 +0800
Message-Id: <20260926092148.128937-4-runyu.xiao@seu.edu.cn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260926092148.128937-1-runyu.xiao@seu.edu.cn>
References: <20260926092148.128937-1-runyu.xiao@seu.edu.cn>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa0dd057d8403a1kunmac953e9e17aa28
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlCGk1CVh4dTUJKT0pKHhlLH1YeHw
	5VEwETFhoSFyQUDg9ZV1kYEgtZQVlJSUlVSkJKVUlPTVVJT0lZV1kWGg8SFR0UWUFZT0tIVUpLSE
	pPSExVSktLVUpCS0tZBg++
DKIM-Signature: a=rsa-sha256;
	b=nhe3qNpXgDUMS3kn2OffuxQfVSDATnAw3eHki1sI8zzfv9M9lvdtNz2KJ8zQEqwq1JycETPsNWX5Y+ZbPlD3tsOCwJe2Z47mtH5n8sZRPEom1P6lDQRSqqA4QQrr5R8mJqiDwZxe3d/eKIaMbEyUDsHjWYE8ZfEWsigBnrT/i1A=; c=relaxed/relaxed; s=default; d=seu.edu.cn; v=1;
	bh=/H/LFwbci3Eh6MNU8eJOEho61nt5VkkYkF/xMDqVmas=;
	h=date:mime-version:subject:message-id:from;

nvmet_passthru_enable_store() runs as a configfs store callback while
configfs holds the item frag_sem. Passthru enable used filp_open() on the
configured controller path, so a path into configfs could re-enter
__configfs_open_file() and try to acquire the same semaphore again.

Use configfs_file_open() so the path is resolved before opening,
configfs-backed paths are rejected, and the resolved path is opened with
file_open_root() while retaining the normal open-time permission and
security checks.

Fixes: cae5b01a2afc ("nvmet: introduce the passthru configfs interface")
Cc: stable@vger.kernel.org
Reviewed-by: Christoph Hellwig <hch@lst.de>
Assisted-by: LLM Codex
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
---
 drivers/nvme/target/passthru.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/target/passthru.c b/drivers/nvme/target/passthru.c
index fa6527c537e26..d60256004e6cf 100644
--- a/drivers/nvme/target/passthru.c
+++ b/drivers/nvme/target/passthru.c
@@ -9,6 +9,7 @@
  */
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 #include <linux/module.h>
+#include <linux/configfs.h>
 
 #include "../host/nvme.h"
 #include "nvmet.h"
@@ -602,7 +603,7 @@ int nvmet_passthru_ctrl_enable(struct nvmet_subsys *subsys)
 		goto out_unlock;
 	}
 
-	file = filp_open(subsys->passthru_ctrl_path, O_RDWR, 0);
+	file = configfs_file_open(subsys->passthru_ctrl_path, O_RDWR, 0);
 	if (IS_ERR(file)) {
 		ret = PTR_ERR(file);
 		goto out_unlock;
-- 
2.34.1


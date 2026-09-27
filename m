Received: from mail-m49197.qiye.163.com (mail-m49197.qiye.163.com [45.254.49.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07A55380FCA;
	Sun, 27 Sep 2026 08:20:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.254.49.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790497234; cv=none; b=m06BrA3qWYSjaaCdeoTtJRk0WhRCNrPOYtJ7NtfP1xttRly6Lg5mRzrfukT31sRyQUE9cgaSlhilqfocWMESAsdbiFzXvt7rAhJ57RylQprQjKmkx7xJXqCdOwhl5RAxHZO9YokISQWgfTDs95I38Tx6mWlHhOWC2QHQfuyj6UI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790497234; c=relaxed/simple;
	bh=N08GINapGkfvCosW7+xLnWZKpuPPjBW9LdLNoq/FvI0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Mcx03fFXKRS1LvvTjSiUUjYDYVsS+2qFsWIwGY/HDS8jcz4zxLd8oNFRsZOBAAhfUT7onP8ydU37+ETMJ3Mm7bc524CkiEAwlDWbNHyBvF5pNP2VMVUCiQnXzBMkIgjJ/yr6jpVVjE8f07zHFe7sqAu8lc2evxqz/BqzBLC65VE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn; spf=pass smtp.mailfrom=seu.edu.cn; dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b=EkGWP8qd; arc=none smtp.client-ip=45.254.49.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b="EkGWP8qd"
Received: from PC-202605011814.localdomain (unknown [222.191.246.242])
	by smtp.qiye.163.com (Hmail) with ESMTP id 4f3a443fc;
	Sun, 27 Sep 2026 16:20:26 +0800 (GMT+08:00)
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
Subject: [PATCH v7 2/4] nvmet: avoid recursive configfs open for file-backed namespaces
Date: Sun, 27 Sep 2026 16:20:09 +0800
Message-Id: <20260927082011.638723-3-runyu.xiao@seu.edu.cn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260927082011.638723-1-runyu.xiao@seu.edu.cn>
References: <20260927082011.638723-1-runyu.xiao@seu.edu.cn>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa0e1f37d1d03a1kunm12f6b69c1ac33a
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlCTB0aVklCSRgfGB4dGk9PTVYeHw
	5VEwETFhoSFyQUDg9ZV1kYEgtZQVlJSUlVSkJKVUlPTVVJT0lZV1kWGg8SFR0UWUFZT0tIVUpLSE
	pPSExVSktLVUpCS0tZBg++
DKIM-Signature: a=rsa-sha256;
	b=EkGWP8qdG+5LiGL046+jDR7uE+tkvN9/pv/AqCEZ+0VOtrpTtvc8uSnQLJSI0Dpn/RXEjZNtfPhs+Z8yxpLgy/xGKSVsaAyTqh+gdjPTqa3ZQx2kS3jPbrGtRP5j/T5YCEMfVAg9c8gJJB1KlksGzjTLQ0EoJ49jUtRgwBRQNhM=; c=relaxed/relaxed; s=default; d=seu.edu.cn; v=1;
	bh=Tcbi5MYjrLiwUZJP1iBOkaEwqrphN9t9A1anWrBn1xQ=;
	h=date:mime-version:subject:message-id:from;

nvmet_ns_enable_store() runs as a configfs store callback while configfs
holds the item frag_sem. File-backed namespace enable used filp_open() on
the configured device_path, so a path into configfs could re-enter
__configfs_open_file() and try to acquire the same semaphore again.

Use configfs_file_open() so the path is resolved before opening,
configfs-backed paths are rejected, and the resolved path is opened with
file_open_root() while retaining the normal open-time permission and
security checks.

Fixes: d5eff33ee6f8 ("nvmet: add simple file backed ns support")
Cc: stable@vger.kernel.org
Reviewed-by: Christoph Hellwig <hch@lst.de>
Assisted-by: LLM Codex
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
---
 drivers/nvme/target/io-cmd-file.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/target/io-cmd-file.c b/drivers/nvme/target/io-cmd-file.c
index 0b22d183f9279..2a4f25de94ba1 100644
--- a/drivers/nvme/target/io-cmd-file.c
+++ b/drivers/nvme/target/io-cmd-file.c
@@ -8,6 +8,7 @@
 #include <linux/uio.h>
 #include <linux/falloc.h>
 #include <linux/file.h>
+#include <linux/configfs.h>
 #include <linux/fs.h>
 #include "nvmet.h"
 
@@ -38,7 +39,7 @@ int nvmet_file_ns_enable(struct nvmet_ns *ns)
 	if (!ns->buffered_io)
 		flags |= O_DIRECT;
 
-	ns->file = filp_open(ns->device_path, flags, 0);
+	ns->file = configfs_file_open(ns->device_path, flags, 0);
 	if (IS_ERR(ns->file)) {
 		ret = PTR_ERR(ns->file);
 		pr_err("failed to open file %s: (%d)\n",
-- 
2.34.1


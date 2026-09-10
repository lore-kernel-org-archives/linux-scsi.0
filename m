Received: from mail-m49197.qiye.163.com (mail-m49197.qiye.163.com [45.254.49.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2228A472076;
	Thu, 10 Sep 2026 11:29:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.254.49.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789039803; cv=none; b=e197G+MLwynwZYRV9Hbj/jA3odx5o0TxZjcK/tnzMAxPiceJwdgJuxddp1Zey6U2RAlZMKn9cHI/Yz1KRq6PW4fcOqqvLnyM8Q+N9ZtwR74zIXKPafylh4RNl+r+Sb/aygFhoR4I2AjfyWgS8ch3RAU1LLlv7MfIFimC3x7gi/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789039803; c=relaxed/simple;
	bh=RJydT2Dk8RQ1sONS+iE0RGlzWiAtuS02wqiSMmED05k=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=LgJqxht+EXPVLzDLwnXetY2TjY+NtVPrrF8KVYZDGOHG4x+sYMvpkiLnjIZ+hZ8UXP5R980n1gEZFm2L+Q3pGVDkbhZ4Vin9ZvgZvptUeqg475rOsdL8UcTD67+xxkQzgtfolI2yps3jkaPQLZnobcK5Bd0T8TBICJECPWwjy5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn; spf=pass smtp.mailfrom=seu.edu.cn; dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b=MJX8IkEl; arc=none smtp.client-ip=45.254.49.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b="MJX8IkEl"
Received: from PC-202605011814.localdomain (unknown [58.241.16.34])
	by smtp.qiye.163.com (Hmail) with ESMTP id 4d48b9218;
	Thu, 10 Sep 2026 19:29:54 +0800 (GMT+08:00)
From: Runyu Xiao <runyu.xiao@seu.edu.cn>
To: Nilesh Javali <njavali@marvell.com>,
	Manish Rangankar <mrangankar@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jianhao Xu <jianhao.xu@seu.edu.cn>,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	stable@vger.kernel.org
Subject: [PATCH] scsi: qedi: Initialize callback state before registration
Date: Thu, 10 Sep 2026 19:29:47 +0800
Message-Id: <20260910112947.1350877-1-runyu.xiao@seu.edu.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa08b14d79e03a1kunm4cd477181957dc
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkaTkhDVkIZHkJOS09LGk8aQ1YeHw
	5VEwETFhoSFyQUDg9ZV1kYEgtZQVlOQ1VJT0pVSk1VSE9ZV1kWGg8SFR0UWUFZT0tIVUpLSEpPSE
	xVSktLVUpCS0tZBg++
DKIM-Signature: a=rsa-sha256;
	b=MJX8IkElxBmJQSMYRpR1YU5I07TTijyk3IYW1AD8H1I17+g5IGHA3UuTvxxaOlLSVgct36WaAwJQLfXPGdLU2ZbolvoGMnvD9C9SI8/yuvyAGbhsIDNgT2lvTS/SRGAbAE0WhlCoglZWHgznda5fPyPW6cpGKnOXdUT0HQer8ZE=; c=relaxed/relaxed; s=default; d=seu.edu.cn; v=1;
	bh=2QLnkcGLYs1KfcKJLaEcqelOoy7bY8ls7NzfuQq15P8=;
	h=date:mime-version:subject:message-id:from;

qedi_get_protocol_tlv_data() can be called asynchronously by QED after
qedi_ops->register_ops(). It takes stats_lock and reads ll2_mtu, but
__qedi_probe() currently registers the callback before initializing the
mutex and assigning the default MTU on the normal probe path.

Initialize the callback-visible state before registering qedi_cb_ops. Keep
the recovery path from reinitializing state because it reuses the existing
qedi context.

Fixes: 3cc5746e5ad7 ("scsi: qedi: Initialize the stats mutex lock")
Cc: stable@vger.kernel.org

Assisted-by: LLM Codex
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
---
 drivers/scsi/qedi/qedi_main.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/qedi/qedi_main.c b/drivers/scsi/qedi/qedi_main.c
index 227ff7bd1..f394fcbb9 100644
--- a/drivers/scsi/qedi/qedi_main.c
+++ b/drivers/scsi/qedi/qedi_main.c
@@ -2652,8 +2652,6 @@ static int __qedi_probe(struct pci_dev *pdev, int mode)
 	snprintf(host_buf, sizeof(host_buf), "host_%d", qedi->shost->host_no);
 	qedi_ops->common->set_name(qedi->cdev, host_buf);
 
-	qedi_ops->register_ops(qedi->cdev, &qedi_cb_ops, qedi);
-
 	memset(&params, 0, sizeof(params));
 	params.mtu = DEF_PATH_MTU + IPV6_HDR_LEN + TCP_HDR_LEN;
 	qedi->ll2_mtu = DEF_PATH_MTU;
@@ -2670,6 +2668,7 @@ static int __qedi_probe(struct pci_dev *pdev, int mode)
 		spin_lock_init(&qedi->task_idx_lock);
 		mutex_init(&qedi->stats_lock);
 	}
+	qedi_ops->register_ops(qedi->cdev, &qedi_cb_ops, qedi);
 	qedi_ops->ll2->register_cb_ops(qedi->cdev, &qedi_ll2_cb_ops, qedi);
 	qedi_ops->ll2->start(qedi->cdev, &params);
 
-- 
2.34.1


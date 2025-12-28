Received: from mail-m49197.qiye.163.com (mail-m49197.qiye.163.com [45.254.49.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B64212D594F;
	Sun, 28 Dec 2025 12:55:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.254.49.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766926528; cv=none; b=FTC6WJEglhN+ZYGig+6yNEvVaPgFMt+/j0apuDDbW9R3+i/YXLm0Xmeb7DXGV9cWp1cEf9X+OBcrnGME34fBEcV6pBXXl8fBDAfUOmD9/vVXH/WVOgo9W8P18q6gu7aIuzu+PbsvehOk+yYB2FBPtSad7FEYiWBVnSv6aMs52cs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766926528; c=relaxed/simple;
	bh=kn+/6Mh22DUxYCUd8TlIXCIlF8p0PoJjjlwUurmTT2A=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=e1Sx+9y9mEtpnPC3g2vhofwUMpV97+o5QHoCh17GL0RxcQWT5NO1HVkIKTbfGp/Dta+yqXU3QEHI8TrDiuD+KfOdymgjPrPelLaSFG/vcDExtXhi7VGCqgE+UdBMo1IsYFaDlnGTGA44FoNkq30Q3lzHyCPIhcNbHcqhXGclpY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn; spf=pass smtp.mailfrom=seu.edu.cn; dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b=WwU9uv/M; arc=none smtp.client-ip=45.254.49.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b="WwU9uv/M"
Received: from LAPTOP-N070L597.localdomain (unknown [222.191.246.242])
	by smtp.qiye.163.com (Hmail) with ESMTP id 2ecacd03a;
	Sun, 28 Dec 2025 20:55:22 +0800 (GMT+08:00)
From: Zilin Guan <zilin@seu.edu.cn>
To: njavali@marvell.com
Cc: GR-QLogic-Storage-Upstream@marvell.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Zilin Guan <zilin@seu.edu.cn>,
	Jianhao Xu <jianhao.xu@seu.edu.cn>
Subject: [PATCH] scsi: qla2xxx: Fix memory leak in qlt_get_port_database()
Date: Sun, 28 Dec 2025 12:55:19 +0000
Message-Id: <20251228125519.3687097-1-zilin@seu.edu.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9b6507163103a1kunm8f00a120a5b76
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWS1ZQUlXWQ8JGhUIEh9ZQVkaGE5OVh0aTx0fTU1DSx4YSFYeHw5VEwETFhoSFy
	QUDg9ZV1kYEgtZQVlJSUlVSkJKVUlPTVVJT0lZV1kWGg8SFR0UWUFZT0tIVUpLSUhOQ0NVSktLVU
	tZBg++
DKIM-Signature: a=rsa-sha256;
	b=WwU9uv/Ml85GZcb5I8ZPlpDTrBXs1fSELqu/Z5xPVxKtEZYw82Wr3xqRdj84HOvv5Y+Bvuw57HWVbUaY1FHTFiXcI4goXGHAaNb+barNswkOBj0vVj6OwOpurzePIO5c+Ie9Ha53OhlWlVcdYqGpZ5S781n+XDbzrL4KZlHilYI=; s=default; c=relaxed/relaxed; d=seu.edu.cn; v=1;
	bh=5pdfIvJ0noDps4OwT1Ait7Bd2fmw86HWqfIKi8zYRqc=;
	h=date:mime-version:subject:message-id:from;

In qlt_get_port_database(), qla2x00_alloc_fcport() internally calls
dma_alloc_coherent() to allocate fcport->ct_desc.ct_sns. If
qla24xx_gpdb_wait() fails, the function only frees fcport but not
fcport->ct_desc.ct_sns, which leads to a memory leak.

Fix this by replacing kfree() with qla2x00_free_fcport() in this error
case.

Fixes: 2d70c103fd2a ("[SCSI] qla2xxx: Add LLD target-mode infrastructure for >= 24xx series")
Co-developed-by: Jianhao Xu <jianhao.xu@seu.edu.cn>
Signed-off-by: Jianhao Xu <jianhao.xu@seu.edu.cn>
Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
---
 drivers/scsi/qla2xxx/qla_target.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index d772136984c9..bf48a7b0509f 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -7210,7 +7210,7 @@ static fc_port_t *qlt_get_port_database(struct scsi_qla_host *vha,
 		    "qla_target(%d): Failed to retrieve fcport "
 		    "information -- get_port_database() returned %x "
 		    "(loop_id=0x%04x)", vha->vp_idx, rc, loop_id);
-		kfree(fcport);
+		qla2x00_free_fcport(fcport);
 		return NULL;
 	}
 
-- 
2.34.1


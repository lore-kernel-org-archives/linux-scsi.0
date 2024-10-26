Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 679CC17C7C6
	for <linux-scsi@vger.kernel.org>; Sat, 26 Oct 2024 12:57:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729947471; cv=none; b=P6BTgXgGI3VOti1ehcv/lldAn9iC5isbMQ7AM2CCMxi2pi+C1W/Q/lne32Li0+EVwxp19TPVBwI8d7oKjmp1YXNPqd+Ayi6j6Puzk/jokZr19pr6n2dinB4dNOPfMa5IA7uc5knYZO9XgmaDdEo94EDrXkGE38BktuYTtuNAw+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729947471; c=relaxed/simple;
	bh=ndkKFCKuBseyF0bkgSUIo66Gi5jwTA7fuOTGX5ys3lg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=j3nNPPjVebN+DRHuvEukt9M8YhRSN7ysB+aNAi9gOQzJ+vyuUofqpF5DhNyqsl499sdBvHWdPw6oudbug6UFSgyHE2tb/8EkMyHuLZopTg/kimfl9Q4wHWh3PQC/kMMuj3Dy7xTzUdJ9HnPInMDakIMMuxroc58G85FAvTGuyXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.17])
	by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4XbKQp2LXVz1SCY0;
	Sat, 26 Oct 2024 20:56:18 +0800 (CST)
Received: from dggpemf100006.china.huawei.com (unknown [7.185.36.228])
	by mail.maildlp.com (Postfix) with ESMTPS id 0D1AC1A0188;
	Sat, 26 Oct 2024 20:57:46 +0800 (CST)
Received: from thunder-town.china.huawei.com (10.174.178.55) by
 dggpemf100006.china.huawei.com (7.185.36.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 26 Oct 2024 20:57:45 +0800
From: Zhen Lei <thunder.leizhen@huawei.com>
To: Saurav Kashyap <skashyap@marvell.com>, Javed Hasan <jhasan@marvell.com>,
	<GR-QLogic-Storage-Upstream@marvell.com>, "James E . J . Bottomley"
	<James.Bottomley@HansenPartnership.com>, "Martin K . Petersen"
	<martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>, Nilesh Javali
	<njavali@marvell.com>, Manish Rangankar <mrangankar@marvell.com>
CC: Zhen Lei <thunder.leizhen@huawei.com>
Subject: [PATCH 1/2] scsi: qedf: Fix a possible memory leak in qedf_alloc_and_init_sb()
Date: Sat, 26 Oct 2024 20:57:10 +0800
Message-ID: <20241026125711.484-2-thunder.leizhen@huawei.com>
X-Mailer: git-send-email 2.37.3.windows.1
In-Reply-To: <20241026125711.484-1-thunder.leizhen@huawei.com>
References: <20241026125711.484-1-thunder.leizhen@huawei.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemf100006.china.huawei.com (7.185.36.228)

Hook "qed_ops->common->sb_init = qed_sb_init" does not release the dma
memory sb_virt when it fails. Add dma_free_coherent() to free it. This
is the same way as qedr_alloc_mem_sb() and qede_alloc_mem_sb().

Fixes: 61d8658b4a43 ("scsi: qedf: Add QLogic FastLinQ offload FCoE driver framework.")
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
---
 drivers/scsi/qedf/qedf_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index cf13148ba281c1e..e979ec1478c1844 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -2738,6 +2738,7 @@ static int qedf_alloc_and_init_sb(struct qedf_ctx *qedf,
 	    sb_id, QED_SB_TYPE_STORAGE);
 
 	if (ret) {
+		dma_free_coherent(&qedf->pdev->dev, sizeof(*sb_virt), sb_virt, sb_phys);
 		QEDF_ERR(&qedf->dbg_ctx,
 			 "Status block initialization failed (0x%x) for id = %d.\n",
 			 ret, sb_id);
-- 
2.34.1


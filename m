Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D61AE1D47DC
	for <linux-scsi@vger.kernel.org>; Sat, 26 Oct 2024 12:57:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729947473; cv=none; b=rKTpdK2/7BzyZ02QdQ8PIkOx+6zSYRW5lLF/Lu/GfywfICcEQzmUzYOQ7VPbneAAErLxyzy+mTVxOgi1HVd8ZDPDLFrBiRI623geGFN4FJOQcvixDDaGM3FuoJALUlStpSC1DqzXB0iUxtcnJapO49pCoGIuI+7dmiqvhTZifjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729947473; c=relaxed/simple;
	bh=JHcYNTW+0FW6tMU7bdNmbVGO+/8V6wvNHHxwauV+tJ8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NQVpH+kl+FyfMb5VsjnODAdH0YK+fnrLte/Z5fVQL9pYW/1zMILoQW2JQ/LjF49Hn6regCG+GZmLz90CegmGGPZvPMAUHFZNHVJqWiTmn1ARH+WFZg2Qybd+iqDTFNTnvXaoCEfk450LyOE+lgq8EsLRELv1IHWOW+3glt0VJeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4XbKQp6hjgz1SCp4;
	Sat, 26 Oct 2024 20:56:18 +0800 (CST)
Received: from dggpemf100006.china.huawei.com (unknown [7.185.36.228])
	by mail.maildlp.com (Postfix) with ESMTPS id A36631402E0;
	Sat, 26 Oct 2024 20:57:46 +0800 (CST)
Received: from thunder-town.china.huawei.com (10.174.178.55) by
 dggpemf100006.china.huawei.com (7.185.36.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 26 Oct 2024 20:57:46 +0800
From: Zhen Lei <thunder.leizhen@huawei.com>
To: Saurav Kashyap <skashyap@marvell.com>, Javed Hasan <jhasan@marvell.com>,
	<GR-QLogic-Storage-Upstream@marvell.com>, "James E . J . Bottomley"
	<James.Bottomley@HansenPartnership.com>, "Martin K . Petersen"
	<martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>, Nilesh Javali
	<njavali@marvell.com>, Manish Rangankar <mrangankar@marvell.com>
CC: Zhen Lei <thunder.leizhen@huawei.com>
Subject: [PATCH 2/2] scsi: qedi: Fix a possible memory leak in qedi_alloc_and_init_sb()
Date: Sat, 26 Oct 2024 20:57:11 +0800
Message-ID: <20241026125711.484-3-thunder.leizhen@huawei.com>
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

Hook "qedi_ops->common->sb_init = qed_sb_init" does not release the dma
memory sb_virt when it fails. Add dma_free_coherent() to free it. This
is the same way as qedr_alloc_mem_sb() and qede_alloc_mem_sb().

Fixes: ace7f46ba5fd ("scsi: qedi: Add QLogic FastLinQ offload iSCSI driver framework.")
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
---
 drivers/scsi/qedi/qedi_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/qedi/qedi_main.c b/drivers/scsi/qedi/qedi_main.c
index c5aec26019d6abe..628d59dda20cc40 100644
--- a/drivers/scsi/qedi/qedi_main.c
+++ b/drivers/scsi/qedi/qedi_main.c
@@ -369,6 +369,7 @@ static int qedi_alloc_and_init_sb(struct qedi_ctx *qedi,
 	ret = qedi_ops->common->sb_init(qedi->cdev, sb_info, sb_virt, sb_phys,
 				       sb_id, QED_SB_TYPE_STORAGE);
 	if (ret) {
+		dma_free_coherent(&qedi->pdev->dev, sizeof(*sb_virt), sb_virt, sb_phys);
 		QEDI_ERR(&qedi->dbg_ctx,
 			 "Status block initialization failed for id = %d.\n",
 			  sb_id);
-- 
2.34.1


Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98821182BB
	for <linux-scsi@vger.kernel.org>; Wed,  3 Jan 2024 09:12:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="MX2q4EUS"
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.17.1.24/8.17.1.24) with ESMTP id 4037Xfqv021043;
	Wed, 3 Jan 2024 01:12:04 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding:content-type; s=
	pfpt0220; bh=WmUyq/kxfUsyQn4LpZ/kv754p13WkC0G9aUbi1IE0DM=; b=MX2
	q4EUS+/c9snFKI0DQjcioAnxPd/Hj/J9kmpr+v4gTck1QCUYZ4cWBx9GQ6h2oouK
	q0pVWV09qeRZQUDNpd68mUByK684slIv4uTSDXo8ATcw8q3U4693H6hFBahNkbs+
	ZDSTXjA+Wo6pS9DI4nDBnd7CUru17Czd6FwOvF8EpuA5D8/tb70zOyzTZ3wOOcX8
	qhDD6UhzktY20jrTeKEzJKQiesKcCM+zfcQZixbGN8EJc7XIpnhajO1gSSEjKhUG
	IUeOZvUkhBtRqpENLLaIYlTcW/aiCTC0ibGKtGKgUrWew02dILftoxP6cvOnfJFr
	+TUdTfk/QJ+pc+4wr1Q==
Received: from dc5-exch02.marvell.com ([199.233.59.182])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3vd39q8ewt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
	Wed, 03 Jan 2024 01:12:04 -0800 (PST)
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Wed, 3 Jan
 2024 01:12:02 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Wed, 3 Jan 2024 01:12:02 -0800
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.187])
	by maili.marvell.com (Postfix) with ESMTP id 09FC83F707C;
	Wed,  3 Jan 2024 01:11:59 -0800 (PST)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>, <lduncan@suse.com>, <cleech@redhat.com>
CC: <linux-scsi@vger.kernel.org>, <GR-QLogic-Storage-Upstream@marvell.com>,
        <jmeneghi@redhat.com>
Subject: [PATCH v2 3/3] cnic,bnx2,bnx2x: page align uio mmap allocations
Date: Wed, 3 Jan 2024 14:41:37 +0530
Message-ID: <20240103091137.27142-4-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20240103091137.27142-1-njavali@marvell.com>
References: <20240103091137.27142-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: DO-yufqaaI3JXg0fIUkrIeHPu_iiyfXH
X-Proofpoint-GUID: DO-yufqaaI3JXg0fIUkrIeHPu_iiyfXH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-12-09_02,2023-12-07_01,2023-05-22_02

From: Chris Leech <cleech@redhat.com>

Allocations in these drivers that will be mmaped through a uio device
should be made in multiples of PAGE_SIZE to avoid exposing additional
kernel memory unintentionally.

Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Chris Leech <cleech@redhat.com>
---
 drivers/net/ethernet/broadcom/bnx2.c             | 1 +
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c | 8 ++++----
 drivers/net/ethernet/broadcom/cnic.c             | 8 +++++---
 3 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2.c b/drivers/net/ethernet/broadcom/bnx2.c
index b65b8592ad75..490f88ad3bd2 100644
--- a/drivers/net/ethernet/broadcom/bnx2.c
+++ b/drivers/net/ethernet/broadcom/bnx2.c
@@ -838,6 +838,7 @@ bnx2_alloc_stats_blk(struct net_device *dev)
 						 BNX2_SBLK_MSIX_ALIGN_SIZE);
 	bp->status_stats_size = status_blk_size +
 				sizeof(struct statistics_block);
+	bp->status_stats_size = PAGE_ALIGN(bp->status_stats_size);
 	status_blk = dma_alloc_coherent(&bp->pdev->dev, bp->status_stats_size,
 					&bp->status_blk_mapping, GFP_KERNEL);
 	if (!status_blk)
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
index 678829646cec..1d7be7b7c63f 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
@@ -8270,10 +8270,10 @@ void bnx2x_free_mem_cnic(struct bnx2x *bp)
 
 	if (!CHIP_IS_E1x(bp))
 		BNX2X_PCI_FREE(bp->cnic_sb.e2_sb, bp->cnic_sb_mapping,
-			       sizeof(struct host_hc_status_block_e2));
+			       PAGE_ALIGN(sizeof(struct host_hc_status_block_e2)));
 	else
 		BNX2X_PCI_FREE(bp->cnic_sb.e1x_sb, bp->cnic_sb_mapping,
-			       sizeof(struct host_hc_status_block_e1x));
+			       PAGE_ALIGN(sizeof(struct host_hc_status_block_e1x)));
 
 	BNX2X_PCI_FREE(bp->t2, bp->t2_mapping, SRC_T2_SZ);
 }
@@ -8316,12 +8316,12 @@ int bnx2x_alloc_mem_cnic(struct bnx2x *bp)
 	if (!CHIP_IS_E1x(bp)) {
 		/* size = the status block + ramrod buffers */
 		bp->cnic_sb.e2_sb = BNX2X_PCI_ALLOC(&bp->cnic_sb_mapping,
-						    sizeof(struct host_hc_status_block_e2));
+						    PAGE_ALIGN(sizeof(struct host_hc_status_block_e2)));
 		if (!bp->cnic_sb.e2_sb)
 			goto alloc_mem_err;
 	} else {
 		bp->cnic_sb.e1x_sb = BNX2X_PCI_ALLOC(&bp->cnic_sb_mapping,
-						     sizeof(struct host_hc_status_block_e1x));
+						     PAGE_ALIGN(sizeof(struct host_hc_status_block_e1x)));
 		if (!bp->cnic_sb.e1x_sb)
 			goto alloc_mem_err;
 	}
diff --git a/drivers/net/ethernet/broadcom/cnic.c b/drivers/net/ethernet/broadcom/cnic.c
index d9b52dc6d060..11a25d336221 100644
--- a/drivers/net/ethernet/broadcom/cnic.c
+++ b/drivers/net/ethernet/broadcom/cnic.c
@@ -1026,6 +1026,7 @@ static int __cnic_alloc_uio_rings(struct cnic_uio_dev *udev, int pages)
 		return 0;
 
 	udev->l2_ring_size = pages * CNIC_PAGE_SIZE;
+	udev->l2_ring_size = PAGE_ALIGN(udev->l2_ring_size);
 	udev->l2_ring = dma_alloc_coherent(&udev->pdev->dev, udev->l2_ring_size,
 					   &udev->l2_ring_map, GFP_KERNEL);
 	if (!udev->l2_ring)
@@ -1033,6 +1034,7 @@ static int __cnic_alloc_uio_rings(struct cnic_uio_dev *udev, int pages)
 
 	udev->l2_buf_size = (cp->l2_rx_ring_size + 1) * cp->l2_single_buf_size;
 	udev->l2_buf_size = CNIC_PAGE_ALIGN(udev->l2_buf_size);
+	udev->l2_buf_size = PAGE_ALIGN(udev->l2_buf_size);
 	udev->l2_buf = dma_alloc_coherent(&udev->pdev->dev, udev->l2_buf_size,
 					  &udev->l2_buf_map, GFP_KERNEL);
 	if (!udev->l2_buf) {
@@ -1109,9 +1111,9 @@ static int cnic_init_uio(struct cnic_dev *dev)
 					CNIC_PAGE_MASK;
 		uinfo->mem[1].dma_addr = cp->status_blk_map;
 		if (cp->ethdev->drv_state & CNIC_DRV_STATE_USING_MSIX)
-			uinfo->mem[1].size = BNX2_SBLK_MSIX_ALIGN_SIZE * 9;
+			uinfo->mem[1].size = PAGE_ALIGN(BNX2_SBLK_MSIX_ALIGN_SIZE * 9);
 		else
-			uinfo->mem[1].size = BNX2_SBLK_MSIX_ALIGN_SIZE;
+			uinfo->mem[1].size = PAGE_ALIGN(BNX2_SBLK_MSIX_ALIGN_SIZE);
 
 		uinfo->name = "bnx2_cnic";
 	} else if (test_bit(CNIC_F_BNX2X_CLASS, &dev->flags)) {
@@ -1120,7 +1122,7 @@ static int cnic_init_uio(struct cnic_dev *dev)
 		uinfo->mem[1].addr = (phys_addr_t)cp->bnx2x_def_status_blk &
 			CNIC_PAGE_MASK;
 		uinfo->mem[1].dma_addr = cp->status_blk_map;
-		uinfo->mem[1].size = sizeof(*cp->bnx2x_def_status_blk);
+		uinfo->mem[1].size = PAGE_ALIGN(sizeof(*cp->bnx2x_def_status_blk));
 
 		uinfo->name = "bnx2x_cnic";
 	}
-- 
2.23.1


Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 932FC381B5
	for <linux-scsi@vger.kernel.org>; Tue,  9 Jan 2024 12:15:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="B0hxFZiT"
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.17.1.24/8.17.1.24) with ESMTP id 409Bvalg018237;
	Tue, 9 Jan 2024 04:15:26 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding:content-type; s=
	pfpt0220; bh=vpOTykXRxJH4boh4qu3+H+w+jfHTB4Kab7aYQJdVAGU=; b=B0h
	xFZiTvag8u45FTDSeK543hSH2sPG8EEID4yaZHMflemZ0dm/bQiy/8UlPKsJHUEB
	xy/3CbDLKXPL14jZ8htT8r5bKWJXBTMhDe+8YGF33/PlpzQa+QnWFGoTjHYz23M3
	S9osYnpFBfUOXEvQbAM3koSBwzDN9mKLxI1yDKTOuVC7/EpA+sveSsyTrK78mLku
	030wCJjXqxQNNzMh6+Yo1IIYx0kCXyL4yO57bk0dccuHHYKBsZOo7sNmMEnalbYG
	p85LikxnlIS01Ge1dTKe+utyZe+zMmqXr5zTDZvsCk0FVjhS2lL3e3zhIKYRgMQ5
	+zCOL3Xsz0RBZC6Wt/g==
Received: from dc5-exch01.marvell.com ([199.233.59.181])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3vh5qt02tm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
	Tue, 09 Jan 2024 04:15:26 -0800 (PST)
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Tue, 9 Jan
 2024 04:15:25 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Tue, 9 Jan 2024 04:15:24 -0800
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.187])
	by maili.marvell.com (Postfix) with ESMTP id DBB633F708E;
	Tue,  9 Jan 2024 04:15:22 -0800 (PST)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>, <lduncan@suse.com>, <cleech@redhat.com>
CC: <linux-scsi@vger.kernel.org>, <GR-QLogic-Storage-Upstream@marvell.com>,
        <jmeneghi@redhat.com>
Subject: [PATCH v3 3/3] cnic,bnx2,bnx2x: page align uio mmap allocations
Date: Tue, 9 Jan 2024 17:44:58 +0530
Message-ID: <20240109121458.26475-4-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20240109121458.26475-1-njavali@marvell.com>
References: <20240109121458.26475-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: mXUjLIKGQ0fMnWQBLnJ8nDDZ97c-ZLuN
X-Proofpoint-GUID: mXUjLIKGQ0fMnWQBLnJ8nDDZ97c-ZLuN
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
index e2069a984764..ec4333e1ac9b 100644
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
 		uinfo->mem[1].addr = (unsigned long) cp->bnx2x_def_status_blk &
 			CNIC_PAGE_MASK;
 		uinfo->mem[1].dma_addr = cp->status_blk_map;
-		uinfo->mem[1].size = sizeof(*cp->bnx2x_def_status_blk);
+		uinfo->mem[1].size = PAGE_ALIGN(sizeof(*cp->bnx2x_def_status_blk));
 
 		uinfo->name = "bnx2x_cnic";
 	}
-- 
2.23.1


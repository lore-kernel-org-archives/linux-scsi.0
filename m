Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0177338FBE
	for <linux-scsi@vger.kernel.org>; Tue,  9 Jan 2024 12:15:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="MU8+i2Vx"
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.17.1.24/8.17.1.24) with ESMTP id 4096AZhx024464;
	Tue, 9 Jan 2024 04:15:25 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding:content-type; s=
	pfpt0220; bh=vTiIeVkMq4dR2FlBibGzRwKRP88JdYSzJJijUKUJgP8=; b=MU8
	+i2Vx5X72SJqgjo9FMZbiY9hhKKpF7pOsn6BEn886ZWuHdeNsSAsYQVsvDB/KlOM
	S80gickQwQAdjntm0xKmunoZVz0qH3nCUuEnvYOy9TC4RWdjKLaMkUg96XMVOx3h
	nB9XCCDhpOhn4cDhu90K2vEcAnt8X1cQ9tTzyrsYoAvwglYTDCgcMTkJSZ90EqSB
	Id3EMwvNY6RyiEKIfnhto6bQzlTEf4zLngNO0xtoxEtZ1lsrYOeCEory17a63Jev
	Xnc4CCGuVPnwZSY4yKQuOGwsI3Xh1+TgvEeZXLm5jvQIREJc91lahdLB6QhKVkjN
	Dmz9k4+pTAYtTRbmIMw==
Received: from dc5-exch01.marvell.com ([199.233.59.181])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3vgptf3973-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
	Tue, 09 Jan 2024 04:15:24 -0800 (PST)
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Tue, 9 Jan
 2024 04:15:22 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Tue, 9 Jan 2024 04:15:22 -0800
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.187])
	by maili.marvell.com (Postfix) with ESMTP id 598643F704A;
	Tue,  9 Jan 2024 04:15:20 -0800 (PST)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>, <lduncan@suse.com>, <cleech@redhat.com>
CC: <linux-scsi@vger.kernel.org>, <GR-QLogic-Storage-Upstream@marvell.com>,
        <jmeneghi@redhat.com>
Subject: [PATCH v3 2/3] cnic,bnx2,bnx2x: use UIO_MEM_DMA_COHERENT
Date: Tue, 9 Jan 2024 17:44:57 +0530
Message-ID: <20240109121458.26475-3-njavali@marvell.com>
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
X-Proofpoint-ORIG-GUID: hdvUe6tA4Zo23ZVFaBiefBkNV86J_sMc
X-Proofpoint-GUID: hdvUe6tA4Zo23ZVFaBiefBkNV86J_sMc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-12-09_02,2023-12-07_01,2023-05-22_02

From: Chris Leech <cleech@redhat.com>

Use new UIO_MEM_DMA_COHERENT type to properly handle
mmap for dma_alloc_coherent buffers.

The cnic l2_ring and l2_buf mmaps have caused page
refcount issues as the dma_alloc_coherent no more
provide __GFP_COMP allocation as per commit,
dma-mapping: reject __GFP_COMP in dma_alloc_attrs.

Fix this by having the uio device use dma_mmap_coherent.

The bnx2 and bnx2x status block allocations are also dma_alloc_coherent,
and should use dma_mmap_coherent. They didn't allocate multiple pages,
but also didn't seem to work correctly with an iommu enabled.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202401051255.Qa1W34Jr-lkp@intel.com/
Fixes: bb73955c0b1d ("cnic: don't pass bogus GFP_ flags to dma_alloc_coherent")
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Chris Leech <cleech@redhat.com>
---
v3:
- fix warnings reported by kernel test robot
v2:
- expose only the dma_addr from cnic to uio
- Cleanup newly added unions comprising virtual_addr
  and struct device
 drivers/net/ethernet/broadcom/bnx2.c             |  1 +
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c |  2 ++
 drivers/net/ethernet/broadcom/cnic.c             | 12 +++++++++---
 drivers/net/ethernet/broadcom/cnic.h             |  1 +
 drivers/net/ethernet/broadcom/cnic_if.h          |  1 +
 5 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2.c b/drivers/net/ethernet/broadcom/bnx2.c
index 0d917a9699c5..b65b8592ad75 100644
--- a/drivers/net/ethernet/broadcom/bnx2.c
+++ b/drivers/net/ethernet/broadcom/bnx2.c
@@ -367,6 +367,7 @@ static void bnx2_setup_cnic_irq_info(struct bnx2 *bp)
 	cp->irq_arr[0].status_blk = (void *)
 		((unsigned long) bnapi->status_blk.msi +
 		(BNX2_SBLK_MSIX_ALIGN_SIZE * sb_id));
+	cp->irq_arr[0].status_blk_map = bp->status_blk_mapping;
 	cp->irq_arr[0].status_blk_num = sb_id;
 	cp->num_irq = 1;
 }
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
index 0d8e61c63c7c..678829646cec 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
@@ -14912,9 +14912,11 @@ void bnx2x_setup_cnic_irq_info(struct bnx2x *bp)
 	else
 		cp->irq_arr[0].status_blk = (void *)bp->cnic_sb.e1x_sb;
 
+	cp->irq_arr[0].status_blk_map = bp->cnic_sb_mapping;
 	cp->irq_arr[0].status_blk_num =  bnx2x_cnic_fw_sb_id(bp);
 	cp->irq_arr[0].status_blk_num2 = bnx2x_cnic_igu_sb_id(bp);
 	cp->irq_arr[1].status_blk = bp->def_status_blk;
+	cp->irq_arr[1].status_blk_map = bp->def_status_blk_mapping;
 	cp->irq_arr[1].status_blk_num = DEF_SB_ID;
 	cp->irq_arr[1].status_blk_num2 = DEF_SB_IGU_ID;
 
diff --git a/drivers/net/ethernet/broadcom/cnic.c b/drivers/net/ethernet/broadcom/cnic.c
index 7926aaef8f0c..e2069a984764 100644
--- a/drivers/net/ethernet/broadcom/cnic.c
+++ b/drivers/net/ethernet/broadcom/cnic.c
@@ -1107,6 +1107,7 @@ static int cnic_init_uio(struct cnic_dev *dev)
 						     TX_MAX_TSS_RINGS + 1);
 		uinfo->mem[1].addr = (unsigned long) cp->status_blk.gen &
 					CNIC_PAGE_MASK;
+		uinfo->mem[1].dma_addr = cp->status_blk_map;
 		if (cp->ethdev->drv_state & CNIC_DRV_STATE_USING_MSIX)
 			uinfo->mem[1].size = BNX2_SBLK_MSIX_ALIGN_SIZE * 9;
 		else
@@ -1118,20 +1119,23 @@ static int cnic_init_uio(struct cnic_dev *dev)
 
 		uinfo->mem[1].addr = (unsigned long) cp->bnx2x_def_status_blk &
 			CNIC_PAGE_MASK;
+		uinfo->mem[1].dma_addr = cp->status_blk_map;
 		uinfo->mem[1].size = sizeof(*cp->bnx2x_def_status_blk);
 
 		uinfo->name = "bnx2x_cnic";
 	}
 
-	uinfo->mem[1].memtype = UIO_MEM_LOGICAL;
+	uinfo->mem[1].memtype = UIO_MEM_DMA_COHERENT;
 
 	uinfo->mem[2].addr = (unsigned long) udev->l2_ring;
+	uinfo->mem[2].dma_addr = udev->l2_ring_map;
 	uinfo->mem[2].size = udev->l2_ring_size;
-	uinfo->mem[2].memtype = UIO_MEM_LOGICAL;
+	uinfo->mem[2].memtype = UIO_MEM_DMA_COHERENT;
 
 	uinfo->mem[3].addr = (unsigned long) udev->l2_buf;
+	uinfo->mem[3].dma_addr = udev->l2_buf_map;
 	uinfo->mem[3].size = udev->l2_buf_size;
-	uinfo->mem[3].memtype = UIO_MEM_LOGICAL;
+	uinfo->mem[3].memtype = UIO_MEM_DMA_COHERENT;
 
 	uinfo->version = CNIC_MODULE_VERSION;
 	uinfo->irq = UIO_IRQ_CUSTOM;
@@ -1313,6 +1317,7 @@ static int cnic_alloc_bnx2x_resc(struct cnic_dev *dev)
 		return 0;
 
 	cp->bnx2x_def_status_blk = cp->ethdev->irq_arr[1].status_blk;
+	cp->status_blk_map = cp->ethdev->irq_arr[1].status_blk_map;
 
 	cp->l2_rx_ring_size = 15;
 
@@ -5323,6 +5328,7 @@ static int cnic_start_hw(struct cnic_dev *dev)
 	pci_dev_get(dev->pcidev);
 	cp->func = PCI_FUNC(dev->pcidev->devfn);
 	cp->status_blk.gen = ethdev->irq_arr[0].status_blk;
+	cp->status_blk_map = ethdev->irq_arr[0].status_blk_map;
 	cp->status_blk_num = ethdev->irq_arr[0].status_blk_num;
 
 	err = cp->alloc_resc(dev);
diff --git a/drivers/net/ethernet/broadcom/cnic.h b/drivers/net/ethernet/broadcom/cnic.h
index 4baea81bae7a..fedc84ada937 100644
--- a/drivers/net/ethernet/broadcom/cnic.h
+++ b/drivers/net/ethernet/broadcom/cnic.h
@@ -260,6 +260,7 @@ struct cnic_local {
 		#define SM_RX_ID		0
 		#define SM_TX_ID		1
 	} status_blk;
+	dma_addr_t status_blk_map;
 
 	struct host_sp_status_block	*bnx2x_def_status_blk;
 
diff --git a/drivers/net/ethernet/broadcom/cnic_if.h b/drivers/net/ethernet/broadcom/cnic_if.h
index 789e5c7e9311..49a11ec80b36 100644
--- a/drivers/net/ethernet/broadcom/cnic_if.h
+++ b/drivers/net/ethernet/broadcom/cnic_if.h
@@ -190,6 +190,7 @@ struct cnic_ops {
 struct cnic_irq {
 	unsigned int	vector;
 	void		*status_blk;
+	dma_addr_t	status_blk_map;
 	u32		status_blk_num;
 	u32		status_blk_num2;
 	u32		irq_flags;
-- 
2.23.1


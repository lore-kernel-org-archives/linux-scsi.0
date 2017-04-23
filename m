From: Alexey Khoroshilov <khoroshilov@ispras.ru>
Subject: [PATCH] scsi: mvumi: remove code handling zero scsi_sg_count(scmd) case
Date: Mon, 24 Apr 2017 02:01:00 +0300
Message-ID: <1492988460-453-1-git-send-email-khoroshilov@ispras.ru>
References: <20170423084133.GE30869@infradead.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170423084133.GE30869@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
List-Id: linux-scsi@vger.kernel.org

As Christoph Hellwig noted, SCSI commands that transfer data
always have a SG entry. The patch removes dead code in
mvumi_make_sgl(),  mvumi_complete_cmd() and mvumi_timed_out()
that handle zero scsi_sg_count(scmd) case.

Also the patch adds pci_unmap_sg() on failure path in mvumi_make_sgl().

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/scsi/mvumi.c | 85 ++++++++++++++++------------------------------------
 1 file changed, 26 insertions(+), 59 deletions(-)

diff --git a/drivers/scsi/mvumi.c b/drivers/scsi/mvumi.c
index 247df5e79b71..fe97401ad192 100644
--- a/drivers/scsi/mvumi.c
+++ b/drivers/scsi/mvumi.c
@@ -210,39 +210,27 @@ static int mvumi_make_sgl(struct mvumi_hba *mhba, struct scsi_cmnd *scmd,
 	unsigned int sgnum = scsi_sg_count(scmd);
 	dma_addr_t busaddr;
 
-	if (sgnum) {
-		sg = scsi_sglist(scmd);
-		*sg_count = pci_map_sg(mhba->pdev, sg, sgnum,
-				(int) scmd->sc_data_direction);
-		if (*sg_count > mhba->max_sge) {
-			dev_err(&mhba->pdev->dev, "sg count[0x%x] is bigger "
-						"than max sg[0x%x].\n",
-						*sg_count, mhba->max_sge);
-			return -1;
-		}
-		for (i = 0; i < *sg_count; i++) {
-			busaddr = sg_dma_address(&sg[i]);
-			m_sg->baseaddr_l = cpu_to_le32(lower_32_bits(busaddr));
-			m_sg->baseaddr_h = cpu_to_le32(upper_32_bits(busaddr));
-			m_sg->flags = 0;
-			sgd_setsz(mhba, m_sg, cpu_to_le32(sg_dma_len(&sg[i])));
-			if ((i + 1) == *sg_count)
-				m_sg->flags |= 1U << mhba->eot_flag;
-
-			sgd_inc(mhba, m_sg);
-		}
-	} else {
-		scmd->SCp.dma_handle = scsi_bufflen(scmd) ?
-			pci_map_single(mhba->pdev, scsi_sglist(scmd),
-				scsi_bufflen(scmd),
-				(int) scmd->sc_data_direction)
-			: 0;
-		busaddr = scmd->SCp.dma_handle;
+	sg = scsi_sglist(scmd);
+	*sg_count = pci_map_sg(mhba->pdev, sg, sgnum,
+			       (int) scmd->sc_data_direction);
+	if (*sg_count > mhba->max_sge) {
+		dev_err(&mhba->pdev->dev,
+			"sg count[0x%x] is bigger than max sg[0x%x].\n",
+			*sg_count, mhba->max_sge);
+		pci_unmap_sg(mhba->pdev, sg, sgnum,
+			     (int) scmd->sc_data_direction);
+		return -1;
+	}
+	for (i = 0; i < *sg_count; i++) {
+		busaddr = sg_dma_address(&sg[i]);
 		m_sg->baseaddr_l = cpu_to_le32(lower_32_bits(busaddr));
 		m_sg->baseaddr_h = cpu_to_le32(upper_32_bits(busaddr));
-		m_sg->flags = 1U << mhba->eot_flag;
-		sgd_setsz(mhba, m_sg, cpu_to_le32(scsi_bufflen(scmd)));
-		*sg_count = 1;
+		m_sg->flags = 0;
+		sgd_setsz(mhba, m_sg, cpu_to_le32(sg_dma_len(&sg[i])));
+		if ((i + 1) == *sg_count)
+			m_sg->flags |= 1U << mhba->eot_flag;
+
+		sgd_inc(mhba, m_sg);
 	}
 
 	return 0;
@@ -1350,21 +1338,10 @@ static void mvumi_complete_cmd(struct mvumi_hba *mhba, struct mvumi_cmd *cmd,
 		break;
 	}
 
-	if (scsi_bufflen(scmd)) {
-		if (scsi_sg_count(scmd)) {
-			pci_unmap_sg(mhba->pdev,
-				scsi_sglist(scmd),
-				scsi_sg_count(scmd),
-				(int) scmd->sc_data_direction);
-		} else {
-			pci_unmap_single(mhba->pdev,
-				scmd->SCp.dma_handle,
-				scsi_bufflen(scmd),
-				(int) scmd->sc_data_direction);
-
-			scmd->SCp.dma_handle = 0;
-		}
-	}
+	if (scsi_bufflen(scmd))
+		pci_unmap_sg(mhba->pdev, scsi_sglist(scmd),
+			     scsi_sg_count(scmd),
+			     (int) scmd->sc_data_direction);
 	cmd->scmd->scsi_done(scmd);
 	mvumi_return_cmd(mhba, cmd);
 }
@@ -2171,19 +2148,9 @@ static enum blk_eh_timer_return mvumi_timed_out(struct scsi_cmnd *scmd)
 	scmd->result = (DRIVER_INVALID << 24) | (DID_ABORT << 16);
 	scmd->SCp.ptr = NULL;
 	if (scsi_bufflen(scmd)) {
-		if (scsi_sg_count(scmd)) {
-			pci_unmap_sg(mhba->pdev,
-				scsi_sglist(scmd),
-				scsi_sg_count(scmd),
-				(int)scmd->sc_data_direction);
-		} else {
-			pci_unmap_single(mhba->pdev,
-				scmd->SCp.dma_handle,
-				scsi_bufflen(scmd),
-				(int)scmd->sc_data_direction);
-
-			scmd->SCp.dma_handle = 0;
-		}
+		pci_unmap_sg(mhba->pdev, scsi_sglist(scmd),
+			     scsi_sg_count(scmd),
+			     (int)scmd->sc_data_direction);
 	}
 	mvumi_return_cmd(mhba, cmd);
 	spin_unlock_irqrestore(mhba->shost->host_lock, flags);
-- 
2.7.4

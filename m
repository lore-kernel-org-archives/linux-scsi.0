From: Alexey Khoroshilov <khoroshilov@ispras.ru>
Subject: [PATCH] scsi: mvumi: add check for dma mapping errors
Date: Sat, 22 Apr 2017 02:17:50 +0300
Message-ID: <1492816670-25795-1-git-send-email-khoroshilov@ispras.ru>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
List-Id: linux-scsi@vger.kernel.org

mvumi_make_sgl() does not check if mapping dma memory succeed.

The patch adds return error code if the mapping failed and
if scsi_bufflen(scmd) is zero. The latter is just in case
since the only call site of mvumi_make_sgl() check the scsi_bufflen(scmd)
before the call.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/scsi/mvumi.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/mvumi.c b/drivers/scsi/mvumi.c
index 247df5e79b71..49f8b20f5d91 100644
--- a/drivers/scsi/mvumi.c
+++ b/drivers/scsi/mvumi.c
@@ -232,11 +232,14 @@ static int mvumi_make_sgl(struct mvumi_hba *mhba, struct scsi_cmnd *scmd,
 			sgd_inc(mhba, m_sg);
 		}
 	} else {
-		scmd->SCp.dma_handle = scsi_bufflen(scmd) ?
-			pci_map_single(mhba->pdev, scsi_sglist(scmd),
-				scsi_bufflen(scmd),
-				(int) scmd->sc_data_direction)
-			: 0;
+		if (!scsi_bufflen(scmd))
+			return -1;
+		scmd->SCp.dma_handle = pci_map_single(mhba->pdev,
+						scsi_sglist(scmd),
+						scsi_bufflen(scmd),
+						(int) scmd->sc_data_direction);
+		if (pci_dma_mapping_error(mhba->pdev, scmd->SCp.dma_handle))
+			return -1;
 		busaddr = scmd->SCp.dma_handle;
 		m_sg->baseaddr_l = cpu_to_le32(lower_32_bits(busaddr));
 		m_sg->baseaddr_h = cpu_to_le32(upper_32_bits(busaddr));
-- 
2.7.4

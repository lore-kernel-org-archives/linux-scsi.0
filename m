From: Sinan Kaya <okaya@codeaurora.org>
Subject: [PATCH v4 4/7] scsi: lpfc: Eliminate duplicate barriers on weakly-ordered archs
Date: Mon, 19 Mar 2018 22:50:04 -0400
Message-ID: <1521514207-10695-5-git-send-email-okaya@codeaurora.org>
References: <1521514207-10695-1-git-send-email-okaya@codeaurora.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1521514207-10695-1-git-send-email-okaya@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, timur@codeaurora.org, sulrich@codeaurora.org
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Sinan Kaya <okaya@codeaurora.org>, James Smart <james.smart@broadcom.com>, Dick Kennedy <dick.kennedy@broadcom.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Code includes barrier() followed by writel(). writel() already has a
barrier
on some architectures like arm64.

This ends up CPU observing two barriers back to back before executing the
register write.

Since code already has an explicit barrier call, changing writel() to
writel_relaxed().

Signed-off-by: Sinan Kaya <okaya@codeaurora.org>
---
 drivers/scsi/lpfc/lpfc_sli.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 5f5528a..7dae7d3 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -1647,7 +1647,7 @@ lpfc_sli_update_full_ring(struct lpfc_hba *phba, struct lpfc_sli_ring *pring)
 	 * Set ring 'ringno' to SET R0CE_REQ in Chip Att register.
 	 * The HBA will tell us when an IOCB entry is available.
 	 */
-	writel((CA_R0ATT|CA_R0CE_REQ) << (ringno*4), phba->CAregaddr);
+	writel_relaxed((CA_R0ATT|CA_R0CE_REQ) << (ringno*4), phba->CAregaddr);
 	readl(phba->CAregaddr); /* flush */
 
 	pring->stats.iocb_cmd_full++;
@@ -1672,7 +1672,7 @@ lpfc_sli_update_ring(struct lpfc_hba *phba, struct lpfc_sli_ring *pring)
 	 */
 	if (!(phba->sli3_options & LPFC_SLI3_CRP_ENABLED)) {
 		wmb();
-		writel(CA_R0ATT << (ringno * 4), phba->CAregaddr);
+		writel_relaxed(CA_R0ATT << (ringno * 4), phba->CAregaddr);
 		readl(phba->CAregaddr); /* flush */
 	}
 }
-- 
2.7.4

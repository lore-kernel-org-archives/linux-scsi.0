From: Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 015/258] scsi: lpfc: Correct LCB RJT handling
Date: Mon, 28 Jan 2019 10:55:21 -0500
Message-ID: <20190128155924.51521-15-sashal@kernel.org>
References: <20190128155924.51521-1-sashal@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190128155924.51521-1-sashal@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: James Smart <jsmart2021@gmail.com>, Dick Kennedy <dick.kennedy@broadcom.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: James Smart <jsmart2021@gmail.com>

[ Upstream commit b114d9009d386276bfc3352289fc235781ae3353 ]

When LCB's are rejected, if beaconing was already in progress, the
Reason Code Explanation was not being set. Should have been set to
command in progress.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_els.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 4dda969e947c..56a4f626349c 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -5701,6 +5701,9 @@ lpfc_els_lcb_rsp(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 	stat = (struct ls_rjt *)(pcmd + sizeof(uint32_t));
 	stat->un.b.lsRjtRsnCode = LSRJT_UNABLE_TPC;
 
+	if (shdr_add_status == ADD_STATUS_OPERATION_ALREADY_ACTIVE)
+		stat->un.b.lsRjtRsnCodeExp = LSEXP_CMD_IN_PROGRESS;
+
 	elsiocb->iocb_cmpl = lpfc_cmpl_els_rsp;
 	phba->fc_stat.elsXmitLSRJT++;
 	rc = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, elsiocb, 0);
-- 
2.19.1

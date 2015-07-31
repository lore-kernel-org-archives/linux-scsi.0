From: Colin King <colin.king@canonical.com>
Subject: [PATCH] lpfc: fix double free on mp
Date: Fri, 31 Jul 2015 17:15:24 +0100
Message-ID: <1438359324-8834-1-git-send-email-colin.king@canonical.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: James Smart <james.smart@avagotech.com>, Dick Kennedy <dick.kennedy@avagotech.com>, "James E.J. Bottomley" <JBottomley@odin.com>, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The error path when the call to lpfc_sli_issue_mbox returns
MBX_NOT_FINISHED results in the code freeing mp and calling
lpfc_mbuf_free twice.   Fix this by jumping to the correct
part of the error clean up path.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/lpfc/lpfc_mbox.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_mbox.c b/drivers/scsi/lpfc/lpfc_mbox.c
index eb62772..750f34d 100644
--- a/drivers/scsi/lpfc/lpfc_mbox.c
+++ b/drivers/scsi/lpfc/lpfc_mbox.c
@@ -2299,13 +2299,14 @@ lpfc_mbx_cmpl_rdp_page_a2(struct lpfc_hba *phba, LPFC_MBOXQ_t *mbox)
 	mbox->mbox_cmpl = lpfc_mbx_cmpl_rdp_link_stat;
 	mbox->context2 = (struct lpfc_rdp_context *) rdp_context;
 	if (lpfc_sli_issue_mbox(phba, mbox, MBX_NOWAIT) == MBX_NOT_FINISHED)
-		goto error;
+		goto cmd_free;
 
 	return;
 
 error:
 	lpfc_mbuf_free(phba, mp->virt, mp->phys);
 	kfree(mp);
+cmd_free:
 	lpfc_sli4_mbox_cmd_free(phba, mbox);
 	rdp_context->cmpl(phba, rdp_context, FAILURE);
 }
-- 
2.5.0

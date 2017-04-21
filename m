From: Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH-v0 1/2] Fix panic on BFS configuration.
Date: Fri, 21 Apr 2017 11:42:25 -0700
Message-ID: <1492800146-24218-2-git-send-email-dick.kennedy@broadcom.com>
References: <1492800146-24218-1-git-send-email-dick.kennedy@broadcom.com>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1492800146-24218-1-git-send-email-dick.kennedy@broadcom.com>
Sender: linux-block-owner@vger.kernel.org
To: linux-block@vger.kernel.org, linux-scsi@vreg.kernel.org
Cc: martin.petersen@orcale.com, jthumshirn@suse.de, emilne@redhat.com, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>
List-Id: linux-scsi@vger.kernel.org

The previous revison of FW had already started when the driver
started to init. The driver is trying to get the WWPN through the
mailbox slim register which is only for bootstraping the fw.

The fix is to reset the fw get the wwpn and then start the fw.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_crtn.h | 1 +
 drivers/scsi/lpfc/lpfc_init.c | 7 +++++++
 drivers/scsi/lpfc/lpfc_sli.c  | 2 +-
 3 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
index 944b32c..62016d6 100644
--- a/drivers/scsi/lpfc/lpfc_crtn.h
+++ b/drivers/scsi/lpfc/lpfc_crtn.h
@@ -294,6 +294,7 @@ int lpfc_selective_reset(struct lpfc_hba *);
 void lpfc_reset_barrier(struct lpfc_hba *);
 int lpfc_sli_brdready(struct lpfc_hba *, uint32_t);
 int lpfc_sli_brdkill(struct lpfc_hba *);
+int lpfc_sli_chipset_init(struct lpfc_hba *);
 int lpfc_sli_brdreset(struct lpfc_hba *);
 int lpfc_sli_brdrestart(struct lpfc_hba *);
 int lpfc_sli_hba_setup(struct lpfc_hba *);
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 90ae354..e85f273 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -3602,6 +3602,13 @@ lpfc_get_wwpn(struct lpfc_hba *phba)
 	LPFC_MBOXQ_t *mboxq;
 	MAILBOX_t *mb;
 
+	if (phba->sli_rev < LPFC_SLI_REV4) {
+		/* Reset the port first */
+		lpfc_sli_brdrestart(phba);
+		rc = lpfc_sli_chipset_init(phba);
+		if (rc)
+			return (uint64_t)-1;
+	}
 
 	mboxq = (LPFC_MBOXQ_t *) mempool_alloc(phba->mbox_mem_pool,
 						GFP_KERNEL);
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index cf19f49..22862b7 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -4446,7 +4446,7 @@ lpfc_sli_brdrestart(struct lpfc_hba *phba)
  * iteration, the function will restart the HBA again. The function returns
  * zero if HBA successfully restarted else returns negative error code.
  **/
-static int
+int
 lpfc_sli_chipset_init(struct lpfc_hba *phba)
 {
 	uint32_t status, i = 0;
-- 
2.1.0

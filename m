From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH] lpfc: Correct MDS diag and nvmet configuration
Date: Thu, 16 Aug 2018 16:04:05 -0700
Message-ID: <20180816230405.14272-1-jsmart2021@gmail.com>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Smart <jsmart2021@gmail.com>, stable@vger.kernel.org, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>
List-Id: linux-scsi@vger.kernel.org

A recent change added some MDS processing in the lpfc_drain_txq
routine that relies on the fcp_wq being allocated. For nvmet operation
the fcp_wq is not allocated because it can only be an nvme-target.
When the original MDS support was added LS_MDS_LOOPBACK was
defined wrong, (0x16) it should have been 0x10 (decimal value used for
hex setting). This incorrect value allowed MDS_LOOPBACK to be set
simultaneously with LS_NPIV_FAB_SUPPORTED, causing the driver to
crash when it accesses the non-existent fcp_wq.

Correct the bad value setting for LS_MDS_LOOPBACK.

Fixes: 	ae9e28f36a6c  ("lpfc: Add MDS Diagnostic support.")
Cc: <stable@vger.kernel.org> # 4.12
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index e0d0da5f43d6..43732e8d1347 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -672,7 +672,7 @@ struct lpfc_hba {
 #define LS_NPIV_FAB_SUPPORTED 0x2	/* Fabric supports NPIV */
 #define LS_IGNORE_ERATT       0x4	/* intr handler should ignore ERATT */
 #define LS_MDS_LINK_DOWN      0x8	/* MDS Diagnostics Link Down */
-#define LS_MDS_LOOPBACK      0x16	/* MDS Diagnostics Link Up (Loopback) */
+#define LS_MDS_LOOPBACK      0x10	/* MDS Diagnostics Link Up (Loopback) */
 
 	uint32_t hba_flag;	/* hba generic flags */
 #define HBA_ERATT_HANDLED	0x1 /* This flag is set when eratt handled */
-- 
2.13.1

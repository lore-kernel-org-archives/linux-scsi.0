From: Nathan Chancellor <natechancellor@gmail.com>
Subject: [PATCH] scsi: lpfc: Avoid unused function warnings
Date: Wed,  5 Jun 2019 22:24:21 -0700
Message-ID: <20190606052421.103469-1-natechancellor@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: James Smart <james.smart@broadcom.com>, Dick Kennedy <dick.kennedy@broadcom.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>, Nathan Chancellor <natechancellor@gmail.com>
List-Id: linux-scsi@vger.kernel.org

When building powerpc pseries_defconfig or powernv_defconfig:

drivers/scsi/lpfc/lpfc_nvmet.c:224:1: error: unused function
'lpfc_nvmet_get_ctx_for_xri' [-Werror,-Wunused-function]
drivers/scsi/lpfc/lpfc_nvmet.c:246:1: error: unused function
'lpfc_nvmet_get_ctx_for_oxid' [-Werror,-Wunused-function]

These functions are only compiled when CONFIG_NVME_TARGET_FC is enabled.
Use that same condition so there is no more warning. While the fixes
commit did not introduce these functions, it caused these warnings.

Fixes: 4064b27417a7 ("scsi: lpfc: Make some symbols static")
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
---
 drivers/scsi/lpfc/lpfc_nvmet.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_nvmet.c b/drivers/scsi/lpfc/lpfc_nvmet.c
index e471bbcca838..f3d9a5545164 100644
--- a/drivers/scsi/lpfc/lpfc_nvmet.c
+++ b/drivers/scsi/lpfc/lpfc_nvmet.c
@@ -220,6 +220,7 @@ lpfc_nvmet_cmd_template(void)
 	/* Word 12, 13, 14, 15 - is zero */
 }
 
+#if (IS_ENABLED(CONFIG_NVME_TARGET_FC))
 static struct lpfc_nvmet_rcv_ctx *
 lpfc_nvmet_get_ctx_for_xri(struct lpfc_hba *phba, u16 xri)
 {
@@ -263,6 +264,7 @@ lpfc_nvmet_get_ctx_for_oxid(struct lpfc_hba *phba, u16 oxid, u32 sid)
 
 	return NULL;
 }
+#endif
 
 static void
 lpfc_nvmet_defer_release(struct lpfc_hba *phba, struct lpfc_nvmet_rcv_ctx *ctxp)
-- 
2.22.0.rc3

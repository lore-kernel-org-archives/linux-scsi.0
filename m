From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 4.20-rc3
Date: Wed, 21 Nov 2018 21:34:13 -0800
Message-ID: <1542864853.23253.6.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Two small fixes.  The qla2xxx is a regression from 4.18 and the ufs one
is a device enablement fix.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Bill Kuzeja (1):
      scsi: qla2xxx: Timeouts occur on surprise removal of QLogic adapter

Wei Li (1):
      scsi: ufs: Fix hynix ufs bug with quirk on hi36xx SoC

And the diffstat:

 drivers/scsi/qla2xxx/qla_os.c | 10 ++++++++--
 drivers/scsi/ufs/ufs-hisi.c   |  9 +++++++++
 drivers/scsi/ufs/ufs_quirks.h |  6 ++++++
 drivers/scsi/ufs/ufshcd.c     |  2 ++
 4 files changed, 25 insertions(+), 2 deletions(-)

With full diff below.

James

---

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 20c85eed1a75..b658b9a5eb1e 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1749,7 +1749,7 @@ qla2x00_loop_reset(scsi_qla_host_t *vha)
 static void
 __qla2x00_abort_all_cmds(struct qla_qpair *qp, int res)
 {
-	int cnt;
+	int cnt, status;
 	unsigned long flags;
 	srb_t *sp;
 	scsi_qla_host_t *vha = qp->vha;
@@ -1799,10 +1799,16 @@ __qla2x00_abort_all_cmds(struct qla_qpair *qp, int res)
 					if (!sp_get(sp)) {
 						spin_unlock_irqrestore
 							(qp->qp_lock_ptr, flags);
-						qla2xxx_eh_abort(
+						status = qla2xxx_eh_abort(
 							GET_CMD_SP(sp));
 						spin_lock_irqsave
 							(qp->qp_lock_ptr, flags);
+						/*
+						 * Get rid of extra reference caused
+						 * by early exit from qla2xxx_eh_abort
+						 */
+						if (status == FAST_IO_FAIL)
+							atomic_dec(&sp->ref_count);
 					}
 				}
 				sp->done(sp, res);
diff --git a/drivers/scsi/ufs/ufs-hisi.c b/drivers/scsi/ufs/ufs-hisi.c
index 46df707e6f2c..452e19f8fb47 100644
--- a/drivers/scsi/ufs/ufs-hisi.c
+++ b/drivers/scsi/ufs/ufs-hisi.c
@@ -20,6 +20,7 @@
 #include "unipro.h"
 #include "ufs-hisi.h"
 #include "ufshci.h"
+#include "ufs_quirks.h"
 
 static int ufs_hisi_check_hibern8(struct ufs_hba *hba)
 {
@@ -390,6 +391,14 @@ static void ufs_hisi_set_dev_cap(struct ufs_hisi_dev_params *hisi_param)
 
 static void ufs_hisi_pwr_change_pre_change(struct ufs_hba *hba)
 {
+	if (hba->dev_quirks & UFS_DEVICE_QUIRK_HOST_VS_DEBUGSAVECONFIGTIME) {
+		pr_info("ufs flash device must set VS_DebugSaveConfigTime 0x10\n");
+		/* VS_DebugSaveConfigTime */
+		ufshcd_dme_set(hba, UIC_ARG_MIB(0xD0A0), 0x10);
+		/* sync length */
+		ufshcd_dme_set(hba, UIC_ARG_MIB(0x1556), 0x48);
+	}
+
 	/* update */
 	ufshcd_dme_set(hba, UIC_ARG_MIB(0x15A8), 0x1);
 	/* PA_TxSkip */
diff --git a/drivers/scsi/ufs/ufs_quirks.h b/drivers/scsi/ufs/ufs_quirks.h
index 71f73d1d1ad1..5d2dfdb41a6f 100644
--- a/drivers/scsi/ufs/ufs_quirks.h
+++ b/drivers/scsi/ufs/ufs_quirks.h
@@ -131,4 +131,10 @@ struct ufs_dev_fix {
  */
 #define UFS_DEVICE_QUIRK_HOST_PA_SAVECONFIGTIME	(1 << 8)
 
+/*
+ * Some UFS devices require VS_DebugSaveConfigTime is 0x10,
+ * enabling this quirk ensure this.
+ */
+#define UFS_DEVICE_QUIRK_HOST_VS_DEBUGSAVECONFIGTIME	(1 << 9)
+
 #endif /* UFS_QUIRKS_H_ */
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 27db55b0ca7f..f1c57cd33b5b 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -231,6 +231,8 @@ static struct ufs_dev_fix ufs_fixups[] = {
 	UFS_FIX(UFS_VENDOR_SKHYNIX, UFS_ANY_MODEL, UFS_DEVICE_NO_VCCQ),
 	UFS_FIX(UFS_VENDOR_SKHYNIX, UFS_ANY_MODEL,
 		UFS_DEVICE_QUIRK_HOST_PA_SAVECONFIGTIME),
+	UFS_FIX(UFS_VENDOR_SKHYNIX, "hB8aL1" /*H28U62301AMR*/,
+		UFS_DEVICE_QUIRK_HOST_VS_DEBUGSAVECONFIGTIME),
 
 	END_FIX
 };

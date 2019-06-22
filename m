From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 5.2-rc5
Date: Sat, 22 Jun 2019 08:31:49 -0700
Message-ID: <1561217509.3260.5.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Three driver fixes (and one version number update): a suspend hang in
ufs, a qla hard lock on module removal and a qedi panic during
discovery.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Arun Easi (1):
      scsi: qla2xxx: Fix hardlockup in abort command during driver remove

Nilesh Javali (2):
      scsi: qedi: update driver version to 8.37.0.20
      scsi: qedi: Check targetname while finding boot target information

Stanley Chu (1):
      scsi: ufs: Avoid runtime suspend possibly being blocked forever


And the diffstat:

 drivers/scsi/qedi/qedi_main.c    |  3 +++
 drivers/scsi/qedi/qedi_version.h |  6 +++---
 drivers/scsi/qla2xxx/qla_os.c    |  2 +-
 drivers/scsi/ufs/ufshcd-pltfrm.c | 11 ++++-------
 4 files changed, 11 insertions(+), 11 deletions(-)

With full diff below

James

---

diff --git a/drivers/scsi/qedi/qedi_main.c b/drivers/scsi/qedi/qedi_main.c
index e5db9a9954dc..a6ff7be0210a 100644
--- a/drivers/scsi/qedi/qedi_main.c
+++ b/drivers/scsi/qedi/qedi_main.c
@@ -990,6 +990,9 @@ static int qedi_find_boot_info(struct qedi_ctx *qedi,
 		if (!iscsi_is_session_online(cls_sess))
 			continue;
 
+		if (!sess->targetname)
+			continue;
+
 		if (pri_ctrl_flags) {
 			if (!strcmp(pri_tgt->iscsi_name, sess->targetname) &&
 			    !strcmp(pri_tgt->ip_addr, ep_ip_addr)) {
diff --git a/drivers/scsi/qedi/qedi_version.h b/drivers/scsi/qedi/qedi_version.h
index 41bcbbafebd4..2c17544c7785 100644
--- a/drivers/scsi/qedi/qedi_version.h
+++ b/drivers/scsi/qedi/qedi_version.h
@@ -7,8 +7,8 @@
  * this source tree.
  */
 
-#define QEDI_MODULE_VERSION	"8.33.0.21"
+#define QEDI_MODULE_VERSION	"8.37.0.20"
 #define QEDI_DRIVER_MAJOR_VER		8
-#define QEDI_DRIVER_MINOR_VER		33
+#define QEDI_DRIVER_MINOR_VER		37
 #define QEDI_DRIVER_REV_VER		0
-#define QEDI_DRIVER_ENG_VER		21
+#define QEDI_DRIVER_ENG_VER		20
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 172ef21827dd..d056f5e7cf93 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1731,8 +1731,8 @@ static void qla2x00_abort_srb(struct qla_qpair *qp, srb_t *sp, const int res,
 	     !test_bit(ABORT_ISP_ACTIVE, &vha->dpc_flags) &&
 	     !qla2x00_isp_reg_stat(ha))) {
 		sp->comp = &comp;
-		rval = ha->isp_ops->abort_command(sp);
 		spin_unlock_irqrestore(qp->qp_lock_ptr, *flags);
+		rval = ha->isp_ops->abort_command(sp);
 
 		switch (rval) {
 		case QLA_SUCCESS:
diff --git a/drivers/scsi/ufs/ufshcd-pltfrm.c b/drivers/scsi/ufs/ufshcd-pltfrm.c
index 8a74ec30c3d2..d7d521b394c3 100644
--- a/drivers/scsi/ufs/ufshcd-pltfrm.c
+++ b/drivers/scsi/ufs/ufshcd-pltfrm.c
@@ -430,24 +430,21 @@ int ufshcd_pltfrm_init(struct platform_device *pdev,
 		goto dealloc_host;
 	}
 
-	pm_runtime_set_active(&pdev->dev);
-	pm_runtime_enable(&pdev->dev);
-
 	ufshcd_init_lanes_per_dir(hba);
 
 	err = ufshcd_init(hba, mmio_base, irq);
 	if (err) {
 		dev_err(dev, "Initialization failed\n");
-		goto out_disable_rpm;
+		goto dealloc_host;
 	}
 
 	platform_set_drvdata(pdev, hba);
 
+	pm_runtime_set_active(&pdev->dev);
+	pm_runtime_enable(&pdev->dev);
+
 	return 0;
 
-out_disable_rpm:
-	pm_runtime_disable(&pdev->dev);
-	pm_runtime_set_suspended(&pdev->dev);
 dealloc_host:
 	ufshcd_dealloc_host(hba);
 out:

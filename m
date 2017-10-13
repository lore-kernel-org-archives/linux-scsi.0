From: "Madhani, Madhani" <himanshu.madhani@cavium.com>
Subject: [PATCH v2 1/5] qla2xxx: Add module param ql2xenablemsix
Date: Fri, 13 Oct 2017 09:34:03 -0700
Message-ID: <20171013163407.8038-2-himanshu.madhani@cavium.com>
References: <20171013163407.8038-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-co1nam03on0072.outbound.protection.outlook.com ([104.47.40.72]:54601
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751964AbdJMQeN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 13 Oct 2017 12:34:13 -0400
In-Reply-To: <20171013163407.8038-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

From: Himanshu Madhani <himanshu.madhani@cavium.com>

Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_gbl.h | 1 +
 drivers/scsi/qla2xxx/qla_isr.c | 9 ++++++---
 drivers/scsi/qla2xxx/qla_os.c  | 9 +++++++++
 3 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index f852ca60c49f..46c7822c20fc 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -145,6 +145,7 @@ extern int ql2xmvasynctoatio;
 extern int ql2xuctrlirq;
 extern int ql2xnvmeenable;
 extern int ql2xautodetectsfp;
+extern int ql2xenablemsix;
 
 extern int qla2x00_loop_reset(scsi_qla_host_t *);
 extern void qla2x00_abort_all_cmds(scsi_qla_host_t *, int);
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 9d9668aac6f6..ef7afd5eefe3 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -3486,11 +3486,14 @@ qla2x00_request_irqs(struct qla_hw_data *ha, struct rsp_que *rsp)
 	scsi_qla_host_t *vha = pci_get_drvdata(ha->pdev);
 
 	/* If possible, enable MSI-X. */
-	if (!IS_QLA2432(ha) && !IS_QLA2532(ha) && !IS_QLA8432(ha) &&
-	    !IS_CNA_CAPABLE(ha) && !IS_QLA2031(ha) && !IS_QLAFX00(ha) &&
-	    !IS_QLA27XX(ha))
+	if (ql2xenablemsix == 0 || (!IS_QLA2432(ha) && !IS_QLA2532(ha) &&
+	    !IS_QLA8432(ha) && !IS_CNA_CAPABLE(ha) && !IS_QLA2031(ha) &&
+	    !IS_QLAFX00(ha) && !IS_QLA27XX(ha)))
 		goto skip_msi;
 
+	if (ql2xenablemsix == 2)
+		goto skip_msix;
+
 	if (ha->pdev->subsystem_vendor == PCI_VENDOR_ID_HP &&
 		(ha->pdev->subsystem_device == 0x7040 ||
 		ha->pdev->subsystem_device == 0x7041 ||
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 937209805baf..cb719345aa0d 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -268,6 +268,15 @@ MODULE_PARM_DESC(ql2xautodetectsfp,
 		 "Detect SFP range and set appropriate distance.\n"
 		 "1 (Default): Enable\n");
 
+int ql2xenablemsix = 1;
+module_param(ql2xenablemsix, int, 0444);
+MODULE_PARM_DESC(ql2xenablemsix,
+    "Set to enable MSI or MSI-X interrupt mechanism.\n"
+    " Default is 1, enable MSI-X interrupt mechanism.\n"
+    " 0 -- enable traditional pin-based mechanism.\n"
+    " 1 -- enable MSI-X interrupt mechanism.\n"
+    " 2 -- enable MSI interrupt mechanism.\n");
+
 /*
  * SCSI host template entry points
  */
-- 
2.12.0

From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 06/43] qla2xxx: Fix stale mem access for IRQ name
Date: Tue, 19 Dec 2017 22:56:07 -0800
Message-ID: <20171220065644.21511-7-himanshu.madhani@cavium.com>
References: <20171220065644.21511-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-co1nam03on0062.outbound.protection.outlook.com ([104.47.40.62]:60343
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932295AbdLTG47 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 20 Dec 2017 01:56:59 -0500
In-Reply-To: <20171220065644.21511-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

From: Quinn Tran <quinn.tran@cavium.com>

IRQ name pointer for INTx/MSI was pointing at stale stack frame.
cat /proc/interrupts will trigger stale mem access. Fix it by
creating dedicated space for IRQ name.

Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_def.h |  4 +++-
 drivers/scsi/qla2xxx/qla_isr.c | 10 +++++++++-
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index ca3ef9360ab9..5e509763a419 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -3140,12 +3140,13 @@ struct scsi_qla_host;
 
 #define QLA83XX_RSPQ_MSIX_ENTRY_NUMBER 1 /* refer to qla83xx_msix_entries */
 
+#define IRQNAME_SZ 32
 struct qla_msix_entry {
 	int have_irq;
 	int in_use;
 	uint32_t vector;
 	uint16_t entry;
-	char name[30];
+	char name[IRQNAME_SZ];
 	void *handle;
 	int cpuid;
 };
@@ -4025,6 +4026,7 @@ struct qla_hw_data {
 	uint16_t        zio_timer;
 
 	struct qla_msix_entry *msix_entries;
+	u8 irqname[IRQNAME_SZ];	/* msi/intx */
 
 	struct list_head        vp_list;        /* list of VP */
 	unsigned long   vp_idx_map[(MAX_MULTI_ID_FABRIC / 8) /
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index a265c2d8c9cc..33865e0bb29f 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -3607,9 +3607,17 @@ qla2x00_request_irqs(struct qla_hw_data *ha, struct rsp_que *rsp)
 	if (!ha->flags.msi_enabled && IS_QLA82XX(ha))
 		return QLA_FUNCTION_FAILED;
 
+	memset(ha->irqname, 0, IRQNAME_SZ);
+	if (ha->flags.msi_enabled)
+		scnprintf(ha->irqname, IRQNAME_SZ,
+		    "qla2xxx%lu_msi", vha->host_no);
+	else
+		scnprintf(ha->irqname, IRQNAME_SZ,
+		    "qla2xxx%lu_intx", vha->host_no);
 	ret = request_irq(ha->pdev->irq, ha->isp_ops->intr_handler,
 	    ha->flags.msi_enabled ? 0 : IRQF_SHARED,
-	    QLA2XXX_DRIVER_NAME, rsp);
+	    ha->irqname, rsp);
+
 	if (ret) {
 		ql_log(ql_log_warn, vha, 0x003a,
 		    "Failed to reserve interrupt %d already in use.\n",
-- 
2.12.0

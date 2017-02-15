From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 3/3] qla2xxx: Fix Regression introduced by pci_alloc_irq_vectors_affinity call.
Date: Wed, 15 Feb 2017 15:37:21 -0800
Message-ID: <1487201841-28846-4-git-send-email-himanshu.madhani@cavium.com>
References: <1487201841-28846-1-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam01on0076.outbound.protection.outlook.com ([104.47.34.76]:21408
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1755553AbdBOXi3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 15 Feb 2017 18:38:29 -0500
In-Reply-To: <1487201841-28846-1-git-send-email-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

From: Michael Hernandez <michael.hernandez@cavium.com>

For target mode, we need to increase minimum vectors value by one to
account for ATIO queue.

Following stack trace will be seen

Call Trace:
qla24xx_config_rings+0x15a/0x230 [qla2xxx]
qla2x00_init_rings+0x1a1/0x3a0 [qla2xxx]
qla2x00_restart_isp+0x5c/0x120 [qla2xxx]
qla2x00_abort_isp+0x138/0x430 [qla2xxx]
? __schedule+0x260/0x580
qla2x00_do_dpc+0x3bc/0x920 [qla2xxx]
? qla2x00_relogin+0x290/0x290 [qla2xxx]
? schedule+0x3a/0xa0
? qla2x00_relogin+0x290/0x290 [qla2xxx]
kthread+0x103/0x140
? __kthread_init_worker+0x40/0x40
ret_from_fork+0x29/0x40

RIP: qlt_24xx_config_rings+0x6c/0x90

Fixes: 17e5fc5 ("scsi: qla2xxx: fix MSI-X vector affinity")
Signed-off-by: Michael Hernandez <michael.hernandez@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_isr.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 6e0a0f1..6b324ac 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -3013,14 +3013,17 @@ struct qla_init_msix_entry {
 	int i, ret;
 	struct qla_msix_entry *qentry;
 	scsi_qla_host_t *vha = pci_get_drvdata(ha->pdev);
+	int min_vecs = QLA_BASE_VECTORS;
 	struct irq_affinity desc = {
 		.pre_vectors = QLA_BASE_VECTORS,
 	};
 
-	if (QLA_TGT_MODE_ENABLED() && IS_ATIO_MSIX_CAPABLE(ha))
+	if (QLA_TGT_MODE_ENABLED() && IS_ATIO_MSIX_CAPABLE(ha)) {
 		desc.pre_vectors++;
+		min_vecs++;
+	}
 
-	ret = pci_alloc_irq_vectors_affinity(ha->pdev, QLA_BASE_VECTORS,
+	ret = pci_alloc_irq_vectors_affinity(ha->pdev, min_vecs,
 			ha->msix_count, PCI_IRQ_MSIX | PCI_IRQ_AFFINITY,
 			&desc);
 
-- 
1.8.3.1

From: Alexander Gordeev <agordeev@redhat.com>
Subject: [PATCH v3 07/13] qla2xxx: Use pci_enable_msix_range() instead of pci_enable_msix()
Date: Mon, 18 Aug 2014 08:01:47 +0200
Message-ID: <6d02c05e9135b0f91de9345d36f097daac9e95cb.1408335523.git.agordeev@redhat.com>
References: <cover.1408335523.git.agordeev@redhat.com>
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <cover.1408335523.git.agordeev@redhat.com>
Sender: linux-pci-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>, qla2xxx-upstream@qlogic.com, linux-scsi@vger.kernel.org, linux-pci@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

As result of deprecation of MSI-X/MSI enablement functions
pci_enable_msix() and pci_enable_msi_block() all drivers
using these two interfaces need to be updated to use the
new pci_enable_msi_range()  or pci_enable_msi_exact()
and pci_enable_msix_range() or pci_enable_msix_exact()
interfaces.

Log message code 0x00c6 preserved, although it is reported
after successful call to pci_enable_msix_range(), not before
possibly unsuccessful call to pci_enable_msix(). Consumers
of the error code should not notice the difference.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Acked-by: Chad Dupuis <chad.dupuis@qlogic.com>
Cc: qla2xxx-upstream@qlogic.com
Cc: linux-scsi@vger.kernel.org
Cc: linux-pci@vger.kernel.org
---
 drivers/scsi/qla2xxx/qla_isr.c | 27 +++++++++++----------------
 1 file changed, 11 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 550a4a3..a485578 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -2923,27 +2923,22 @@ qla24xx_enable_msix(struct qla_hw_data *ha, struct rsp_que *rsp)
 	for (i = 0; i < ha->msix_count; i++)
 		entries[i].entry = i;
 
-	ret = pci_enable_msix(ha->pdev, entries, ha->msix_count);
-	if (ret) {
-		if (ret < MIN_MSIX_COUNT)
-			goto msix_failed;
-
+	ret = pci_enable_msix_range(ha->pdev,
+				    entries, MIN_MSIX_COUNT, ha->msix_count);
+	if (ret < 0) {
+		ql_log(ql_log_fatal, vha, 0x00c7,
+		    "MSI-X: Failed to enable support, "
+		    "giving   up -- %d/%d.\n",
+		    ha->msix_count, ret);
+		goto msix_out;
+	} else if (ret < ha->msix_count) {
 		ql_log(ql_log_warn, vha, 0x00c6,
 		    "MSI-X: Failed to enable support "
 		    "-- %d/%d\n Retry with %d vectors.\n",
 		    ha->msix_count, ret, ret);
-		ha->msix_count = ret;
-		ret = pci_enable_msix(ha->pdev, entries, ha->msix_count);
-		if (ret) {
-msix_failed:
-			ql_log(ql_log_fatal, vha, 0x00c7,
-			    "MSI-X: Failed to enable support, "
-			    "giving   up -- %d/%d.\n",
-			    ha->msix_count, ret);
-			goto msix_out;
-		}
-		ha->max_rsp_queues = ha->msix_count - 1;
 	}
+	ha->msix_count = ret;
+	ha->max_rsp_queues = ha->msix_count - 1;
 	ha->msix_entries = kzalloc(sizeof(struct qla_msix_entry) *
 				ha->msix_count, GFP_KERNEL);
 	if (!ha->msix_entries) {
-- 
1.9.3

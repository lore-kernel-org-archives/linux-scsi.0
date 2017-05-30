From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH v2 07/17] qla2xxx: Use flag PFLG_DISCONNECTED.
Date: Tue, 30 May 2017 10:54:22 -0700
Message-ID: <20170530175432.26984-8-himanshu.madhani@cavium.com>
References: <20170530175432.26984-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-cys01nam02on0078.outbound.protection.outlook.com ([104.47.37.78]:40215
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751157AbdE3RzA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 30 May 2017 13:55:00 -0400
In-Reply-To: <20170530175432.26984-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

From: Sawan Chandak <sawan.chandak@cavium.com>

There is already flag defined PFLG_DISCONNECTED, which is set
for PCI or register disconnect error condition. There is no need to have
flag PCI_ERR, which has same purpose. Remove use of PCI_ERR flag and use
PFLG_DISCONNECTED flag during error condition.

Signed-off-by: Sawan Chandak <sawan.chandak@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_def.h | 1 -
 drivers/scsi/qla2xxx/qla_mbx.c | 5 ++---
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index eddbc1218a39..4127f35b669c 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -4017,7 +4017,6 @@ typedef struct scsi_qla_host {
 #define PFLG_DISCONNECTED	0	/* PCI device removed */
 #define PFLG_DRIVER_REMOVING	1	/* PCI driver .remove */
 #define PFLG_DRIVER_PROBING	2	/* PCI driver .probe */
-#define PCI_ERR			30
 
 	uint32_t	device_flags;
 #define SWITCH_FOUND		BIT_0
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index cba1fc5e8be9..fffa1f7cd8d2 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -124,7 +124,8 @@ qla2x00_mailbox_command(scsi_qla_host_t *vha, mbx_cmd_t *mcp)
 	}
 
 	/* if PCI error, then avoid mbx processing.*/
-	if (test_bit(PCI_ERR, &base_vha->dpc_flags)) {
+	if (test_bit(PFLG_DISCONNECTED, &base_vha->dpc_flags) &&
+	    test_bit(UNLOADING, &base_vha->dpc_flags)) {
 		ql_log(ql_log_warn, vha, 0x1191,
 		    "PCI error, exiting.\n");
 		return QLA_FUNCTION_TIMEOUT;
@@ -384,8 +385,6 @@ qla2x00_mailbox_command(scsi_qla_host_t *vha, mbx_cmd_t *mcp)
 				 * then only PCI ERR flag would be set.
 				 * we will do premature exit for above case.
 				 */
-				if (test_bit(UNLOADING, &base_vha->dpc_flags))
-					set_bit(PCI_ERR, &base_vha->dpc_flags);
 				ha->flags.mbox_busy = 0;
 				rval = QLA_FUNCTION_TIMEOUT;
 				goto premature_exit;
-- 
2.12.0

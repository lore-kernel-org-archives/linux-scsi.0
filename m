From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 09/31] qla2xxx: Fix NPIV host enable after chip reset
Date: Wed, 23 Aug 2017 15:05:03 -0700
Message-ID: <20170823220525.3115-10-himanshu.madhani@cavium.com>
References: <20170823220525.3115-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam01on0085.outbound.protection.outlook.com ([104.47.32.85]:62336
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751133AbdHWWFm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 23 Aug 2017 18:05:42 -0400
In-Reply-To: <20170823220525.3115-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

From: Quinn Tran <quinn.tran@qlogic.com>

For NPIV ports, call configure_hba() so that NPIV ports
can proceed to loop initialization.

Signed-off-by: Quinn Tran <quinn.tran@qlogic.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_dbg.c  | 2 +-
 drivers/scsi/qla2xxx/qla_init.c | 2 +-
 drivers/scsi/qla2xxx/qla_mbx.c  | 2 ++
 drivers/scsi/qla2xxx/qla_mid.c  | 5 +++++
 4 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index 7b74973d5788..7e7cd79038be 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -41,7 +41,7 @@
  * |                              |                    | 0x70ad-0x70ae  |
  * |                              |                    | 0x70d0-0x70d6	|
  * |                              |                    | 0x70d7-0x70db  |
- * | Task Management              |       0x8042       | 0x8000,0x800b  |
+ * | Task Management              |       0x8042       | 0x8000         |
  * |                              |                    | 0x8019         |
  * |                              |                    | 0x8025,0x8026  |
  * |                              |                    | 0x8031,0x8032  |
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 988fb5d0f9e7..8f84cedab853 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -5913,7 +5913,7 @@ qla2x00_abort_isp(scsi_qla_host_t *vha)
 
 	if (!status) {
 		ql_dbg(ql_dbg_taskm, vha, 0x8022, "%s succeeded.\n", __func__);
-
+		qla2x00_configure_hba(vha);
 		spin_lock_irqsave(&ha->vport_slock, flags);
 		list_for_each_entry(vp, &ha->vp_list, list) {
 			if (vp->vp_idx) {
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 6164a2c9a1f4..f101aaa5254b 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -55,6 +55,8 @@ static struct rom_cmd {
 	{ MBC_GET_RETRY_COUNT },
 	{ MBC_TRACE_CONTROL },
 	{ MBC_INITIALIZE_MULTIQ },
+	{ MBC_IOCB_COMMAND_A64 },
+	{ MBC_GET_ADAPTER_LOOP_ID },
 };
 
 static int is_rom_cmd(uint16_t cmd)
diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
index 608d1aeb97be..c0f8f6c17b79 100644
--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -187,6 +187,11 @@ qla24xx_enable_vp(scsi_qla_host_t *vha)
 		!(ha->current_topology & ISP_CFG_F)) {
 		vha->vp_err_state =  VP_ERR_PORTDWN;
 		fc_vport_set_state(vha->fc_vport, FC_VPORT_LINKDOWN);
+		ql_dbg(ql_dbg_taskm, vha, 0x800b,
+		    "%s skip enable. loop_state %x topo %x\n",
+		    __func__, base_vha->loop_state.counter,
+		    ha->current_topology);
+
 		goto enable_failed;
 	}
 
-- 
2.12.0

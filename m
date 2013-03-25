From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 1/5] Revert "qla2xxx: Add setting of driver version string for vendor application."
Date: Mon, 25 Mar 2013 02:21:36 -0400
Message-ID: <1364192500-17013-2-git-send-email-saurav.kashyap@qlogic.com>
References: <1364192500-17013-1-git-send-email-saurav.kashyap@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:42271 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1755344Ab3CYGo0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Mar 2013 02:44:26 -0400
In-Reply-To: <1364192500-17013-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Joe Carnuccio <joe.carnuccio@qlogic.com>

The original patch was not covering all the adapters and firmwares.

This commit reverts 3a11711ad00caebee07e262d188cea66f3473c38.

Signed-off-by: Joe Carnuccio <joe.carnuccio@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_dbg.c  |    1 +
 drivers/scsi/qla2xxx/qla_def.h  |    1 -
 drivers/scsi/qla2xxx/qla_gbl.h  |    3 --
 drivers/scsi/qla2xxx/qla_init.c |    2 -
 drivers/scsi/qla2xxx/qla_mbx.c  |   58 ---------------------------------------
 5 files changed, 1 insertions(+), 64 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index 1626de5..2bf0214 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -15,6 +15,7 @@
  * | Mailbox commands             |       0x115b       | 0x111a-0x111b  |
  * |                              |                    | 0x112c-0x112e  |
  * |                              |                    | 0x113a         |
+ * |                              |                    | 0x1155-0x1158  |
  * | Device Discovery             |       0x2087       | 0x2020-0x2022, |
  * |                              |                    | 0x2016         |
  * | Queue Command and IO tracing |       0x3031       | 0x3006-0x300b  |
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index c650991..65c5ff7 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -863,7 +863,6 @@ typedef struct {
 #define	MBX_1		BIT_1
 #define	MBX_0		BIT_0
 
-#define RNID_TYPE_SET_VERSION	0x9
 #define RNID_TYPE_ASIC_TEMP	0xC
 
 /*
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index eb3ca21..b310fa9 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -358,9 +358,6 @@ extern int
 qla2x00_disable_fce_trace(scsi_qla_host_t *, uint64_t *, uint64_t *);
 
 extern int
-qla2x00_set_driver_version(scsi_qla_host_t *, char *);
-
-extern int
 qla2x00_read_sfp(scsi_qla_host_t *, dma_addr_t, uint8_t *,
 	uint16_t, uint16_t, uint16_t, uint16_t);
 
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index edf4d14..09eae54 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -619,8 +619,6 @@ qla2x00_initialize_adapter(scsi_qla_host_t *vha)
 	if (IS_QLA24XX_TYPE(ha) || IS_QLA25XX(ha))
 		qla24xx_read_fcp_prio_cfg(vha);
 
-	qla2x00_set_driver_version(vha, QLA2XXX_VERSION);
-
 	return (rval);
 }
 
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 186dd59..43345af 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -3866,64 +3866,6 @@ qla81xx_restart_mpi_firmware(scsi_qla_host_t *vha)
 	return rval;
 }
 
-int
-qla2x00_set_driver_version(scsi_qla_host_t *vha, char *version)
-{
-	int rval;
-	mbx_cmd_t mc;
-	mbx_cmd_t *mcp = &mc;
-	int len;
-	uint16_t dwlen;
-	uint8_t *str;
-	dma_addr_t str_dma;
-	struct qla_hw_data *ha = vha->hw;
-
-	if (!IS_FWI2_CAPABLE(ha) || IS_QLA82XX(ha))
-		return QLA_FUNCTION_FAILED;
-
-	ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x1155,
-	    "Entered %s.\n", __func__);
-
-	str = dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL, &str_dma);
-	if (!str) {
-		ql_log(ql_log_warn, vha, 0x1156,
-		    "Failed to allocate driver version param.\n");
-		return QLA_MEMORY_ALLOC_FAILED;
-	}
-
-	memcpy(str, "\x7\x3\x11\x0", 4);
-	dwlen = str[0];
-	len = dwlen * sizeof(uint32_t) - 4;
-	memset(str + 4, 0, len);
-	if (len > strlen(version))
-		len = strlen(version);
-	memcpy(str + 4, version, len);
-
-	mcp->mb[0] = MBC_SET_RNID_PARAMS;
-	mcp->mb[1] = RNID_TYPE_SET_VERSION << 8 | dwlen;
-	mcp->mb[2] = MSW(LSD(str_dma));
-	mcp->mb[3] = LSW(LSD(str_dma));
-	mcp->mb[6] = MSW(MSD(str_dma));
-	mcp->mb[7] = LSW(MSD(str_dma));
-	mcp->out_mb = MBX_7|MBX_6|MBX_3|MBX_2|MBX_1|MBX_0;
-	mcp->in_mb = MBX_0;
-	mcp->tov = MBX_TOV_SECONDS;
-	mcp->flags = 0;
-	rval = qla2x00_mailbox_command(vha, mcp);
-
-	if (rval != QLA_SUCCESS) {
-		ql_dbg(ql_dbg_mbx, vha, 0x1157,
-		    "Failed=%x mb[0]=%x.\n", rval, mcp->mb[0]);
-	} else {
-		ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x1158,
-		    "Done %s.\n", __func__);
-	}
-
-	dma_pool_free(ha->s_dma_pool, str, str_dma);
-
-	return rval;
-}
-
 static int
 qla2x00_read_asic_temperature(scsi_qla_host_t *vha, uint16_t *temp)
 {
-- 
1.7.7


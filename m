From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 18/43] qla2xxx: Tweak resource count dump
Date: Tue, 19 Dec 2017 22:56:19 -0800
Message-ID: <20171220065644.21511-19-himanshu.madhani@cavium.com>
References: <20171220065644.21511-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2nam02on0078.outbound.protection.outlook.com ([104.47.38.78]:2080
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932425AbdLTG5N (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 20 Dec 2017 01:57:13 -0500
In-Reply-To: <20171220065644.21511-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

From: Quinn Tran <quinn.tran@qlogic.com>

Fetch actual data from firmware instead of static data
at chip reset time.

Signed-off-by: Quinn Tran <quinn.tran@qlogic.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_dfs.c | 30 ++++++++++++++++--------------
 drivers/scsi/qla2xxx/qla_gbl.h |  1 +
 drivers/scsi/qla2xxx/qla_mbx.c | 30 ++++++++++++++++++++++++++++++
 3 files changed, 47 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_dfs.c b/drivers/scsi/qla2xxx/qla_dfs.c
index 87a18a00d509..4f0415e158cb 100644
--- a/drivers/scsi/qla2xxx/qla_dfs.c
+++ b/drivers/scsi/qla2xxx/qla_dfs.c
@@ -127,21 +127,23 @@ static int
 qla_dfs_fw_resource_cnt_show(struct seq_file *s, void *unused)
 {
 	struct scsi_qla_host *vha = s->private;
-	struct qla_hw_data *ha = vha->hw;
+	uint16_t mb[MAX_IOCB_MB_REG];
+	int rc;
 
-	seq_puts(s, "FW Resource count\n\n");
-	seq_printf(s, "Original TGT exchg count[%d]\n",
-	    ha->orig_fw_tgt_xcb_count);
-	seq_printf(s, "current TGT exchg count[%d]\n",
-	    ha->cur_fw_tgt_xcb_count);
-	seq_printf(s, "original Initiator Exchange count[%d]\n",
-	    ha->orig_fw_xcb_count);
-	seq_printf(s, "Current Initiator Exchange count[%d]\n",
-	    ha->cur_fw_xcb_count);
-	seq_printf(s, "Original IOCB count[%d]\n", ha->orig_fw_iocb_count);
-	seq_printf(s, "Current IOCB count[%d]\n", ha->cur_fw_iocb_count);
-	seq_printf(s, "MAX VP count[%d]\n", ha->max_npiv_vports);
-	seq_printf(s, "MAX FCF count[%d]\n", ha->fw_max_fcf_count);
+	rc = qla24xx_res_count_wait(vha, mb, SIZEOF_IOCB_MB_REG);
+	if (rc != QLA_SUCCESS) {
+		seq_printf(s, "Mailbox Command failed %d, mb %#x", rc, mb[0]);
+	} else {
+		seq_puts(s, "FW Resource count\n\n");
+		seq_printf(s, "Original TGT exchg count[%d]\n", mb[1]);
+		seq_printf(s, "current TGT exchg count[%d]\n", mb[2]);
+		seq_printf(s, "original Initiator Exchange count[%d]\n", mb[3]);
+		seq_printf(s, "Current Initiator Exchange count[%d]\n", mb[6]);
+		seq_printf(s, "Original IOCB count[%d]\n", mb[7]);
+		seq_printf(s, "Current IOCB count[%d]\n", mb[10]);
+		seq_printf(s, "MAX VP count[%d]\n", mb[11]);
+		seq_printf(s, "MAX FCF count[%d]\n", mb[12]);
+	}
 
 	return 0;
 }
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index ea8f24e07409..2e0907994579 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -504,6 +504,7 @@ int qla24xx_get_port_login_templ(scsi_qla_host_t *, dma_addr_t,
 
 extern int qla27xx_get_zio_threshold(scsi_qla_host_t *, uint16_t *);
 extern int qla27xx_set_zio_threshold(scsi_qla_host_t *, uint16_t);
+int qla24xx_res_count_wait(struct scsi_qla_host *, uint16_t *, int);
 
 /*
  * Global Function Prototypes in qla_isr.c source file.
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 956d121cc396..0c8ad7b31294 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -18,6 +18,7 @@ static struct mb_cmd_name {
 	{MBC_GET_PORT_DATABASE,		"GPDB"},
 	{MBC_GET_ID_LIST,		"GIDList"},
 	{MBC_GET_LINK_PRIV_STATS,	"Stats"},
+	{MBC_GET_RESOURCE_COUNTS,	"ResCnt"},
 };
 
 static const char *mb_to_str(uint16_t cmd)
@@ -6273,3 +6274,32 @@ qla2x00_read_sfp_dev(struct scsi_qla_host *vha, char *buf, int count)
 
 	return rval;
 }
+
+int qla24xx_res_count_wait(struct scsi_qla_host *vha,
+    uint16_t *out_mb, int out_mb_sz)
+{
+	int rval = QLA_FUNCTION_FAILED;
+	mbx_cmd_t mc;
+
+	if (!vha->hw->flags.fw_started)
+		goto done;
+
+	memset(&mc, 0, sizeof(mc));
+	mc.mb[0] = MBC_GET_RESOURCE_COUNTS;
+
+	rval = qla24xx_send_mb_cmd(vha, &mc);
+	if (rval != QLA_SUCCESS) {
+		ql_dbg(ql_dbg_mbx, vha, 0xffff,
+			"%s:  fail\n", __func__);
+	} else {
+		if (out_mb_sz <= SIZEOF_IOCB_MB_REG)
+			memcpy(out_mb, mc.mb, out_mb_sz);
+		else
+			memcpy(out_mb, mc.mb, SIZEOF_IOCB_MB_REG);
+
+		ql_dbg(ql_dbg_mbx, vha, 0xffff,
+			"%s:  done\n", __func__);
+	}
+done:
+	return rval;
+}
-- 
2.12.0

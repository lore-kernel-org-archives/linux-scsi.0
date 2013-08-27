From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 09/29] qla2xxx: Add setting of driver version string for vendor application.
Date: Tue, 27 Aug 2013 01:37:35 -0400
Message-ID: <1377581875-8574-10-git-send-email-saurav.kashyap@qlogic.com>
References: <1377581875-8574-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:51759 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752691Ab3H0GGh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Aug 2013 02:06:37 -0400
Received: from pps.filterd (m0000643.ppops.net [127.0.0.1])
	by mx0b-0016ce01.pphosted.com (8.14.5/8.14.5) with SMTP id r7R64Oi0012247
	for <linux-scsi@vger.kernel.org>; Mon, 26 Aug 2013 23:06:37 -0700
Received: from avcashub1.qlogic.com (avcashub1.qlogic.com [198.70.193.115])
	by mx0b-0016ce01.pphosted.com with ESMTP id 1e5gq13pa9-2
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 26 Aug 2013 23:06:36 -0700
In-Reply-To: <1377581875-8574-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Joe Carnuccio <joe.carnuccio@qlogic.com>

Signed-off-by: Joe Carnuccio <joe.carnuccio@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_dbg.c  |    2 +-
 drivers/scsi/qla2xxx/qla_def.h  |    1 +
 drivers/scsi/qla2xxx/qla_gbl.h  |    6 ++
 drivers/scsi/qla2xxx/qla_init.c |    5 ++
 drivers/scsi/qla2xxx/qla_mbx.c  |  106 +++++++++++++++++++++++++++++++++++++++
 5 files changed, 119 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index 6ee4fcb..ecaafe4 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -12,7 +12,7 @@
  * |             Level            |   Last Value Used  |     Holes	|
  * ----------------------------------------------------------------------
  * | Module Init and Probe        |       0x0151       | 0x4b,0xba,0xfa |
- * | Mailbox commands             |       0x117a       | 0x111a-0x111b  |
+ * | Mailbox commands             |       0x1181       | 0x111a-0x111b  |
  * |                              |                    | 0x1155-0x1158  |
  * | Device Discovery             |       0x2095       | 0x2020-0x2022, |
  * |                              |                    | 0x2011-0x2012, |
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 58e4f19..f393d24 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -999,6 +999,7 @@ struct mbx_cmd_32 {
 #define	MBX_1		BIT_1
 #define	MBX_0		BIT_0
 
+#define RNID_TYPE_SET_VERSION	0x9
 #define RNID_TYPE_ASIC_TEMP	0xC
 
 /*
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 9ce9131..dc14ac2 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -357,6 +357,12 @@ extern int
 qla2x00_disable_fce_trace(scsi_qla_host_t *, uint64_t *, uint64_t *);
 
 extern int
+qla82xx_set_driver_version(scsi_qla_host_t *, char *);
+
+extern int
+qla25xx_set_driver_version(scsi_qla_host_t *, char *);
+
+extern int
 qla2x00_read_sfp(scsi_qla_host_t *, dma_addr_t, uint8_t *,
 	uint16_t, uint16_t, uint16_t, uint16_t);
 
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index a92b166a..71cbdeb 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -626,6 +626,11 @@ qla2x00_initialize_adapter(scsi_qla_host_t *vha)
 	if (IS_QLA24XX_TYPE(ha) || IS_QLA25XX(ha))
 		qla24xx_read_fcp_prio_cfg(vha);
 
+	if (IS_P3P_TYPE(ha))
+		qla82xx_set_driver_version(vha, QLA2XXX_VERSION);
+	else
+		qla25xx_set_driver_version(vha, QLA2XXX_VERSION);
+
 	return (rval);
 }
 
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index bce41f4..ce76110 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -3862,6 +3862,112 @@ qla81xx_restart_mpi_firmware(scsi_qla_host_t *vha)
 	return rval;
 }
 
+int
+qla82xx_set_driver_version(scsi_qla_host_t *vha, char *version)
+{
+	int rval;
+	mbx_cmd_t mc;
+	mbx_cmd_t *mcp = &mc;
+	int i;
+	int len;
+	uint16_t *str;
+	struct qla_hw_data *ha = vha->hw;
+
+	if (!IS_P3P_TYPE(ha))
+		return QLA_FUNCTION_FAILED;
+
+	ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x117b,
+	    "Entered %s.\n", __func__);
+
+	str = (void *)version;
+	len = strlen(version);
+
+	mcp->mb[0] = MBC_SET_RNID_PARAMS;
+	mcp->mb[1] = RNID_TYPE_SET_VERSION << 8;
+	mcp->out_mb = MBX_1|MBX_0;
+	for (i = 4; i < 16 && len; i++, str++, len -= 2) {
+		mcp->mb[i] = cpu_to_le16p(str);
+		mcp->out_mb |= 1<<i;
+	}
+	for (; i < 16; i++) {
+		mcp->mb[i] = 0;
+		mcp->out_mb |= 1<<i;
+	}
+	mcp->in_mb = MBX_1|MBX_0;
+	mcp->tov = MBX_TOV_SECONDS;
+	mcp->flags = 0;
+	rval = qla2x00_mailbox_command(vha, mcp);
+
+	if (rval != QLA_SUCCESS) {
+		ql_dbg(ql_dbg_mbx, vha, 0x117c,
+		    "Failed=%x mb[0]=%x,%x.\n", rval, mcp->mb[0], mcp->mb[1]);
+	} else {
+		ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x117d,
+		    "Done %s.\n", __func__);
+	}
+
+	return rval;
+}
+
+int
+qla25xx_set_driver_version(scsi_qla_host_t *vha, char *version)
+{
+	int rval;
+	mbx_cmd_t mc;
+	mbx_cmd_t *mcp = &mc;
+	int len;
+	uint16_t dwlen;
+	uint8_t *str;
+	dma_addr_t str_dma;
+	struct qla_hw_data *ha = vha->hw;
+
+	if (!IS_FWI2_CAPABLE(ha) || IS_QLA24XX_TYPE(ha) || IS_QLA81XX(ha) ||
+	    IS_P3P_TYPE(ha))
+		return QLA_FUNCTION_FAILED;
+
+	ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x117e,
+	    "Entered %s.\n", __func__);
+
+	str = dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL, &str_dma);
+	if (!str) {
+		ql_log(ql_log_warn, vha, 0x117f,
+		    "Failed to allocate driver version param.\n");
+		return QLA_MEMORY_ALLOC_FAILED;
+	}
+
+	memcpy(str, "\x7\x3\x11\x0", 4);
+	dwlen = str[0];
+	len = dwlen * 4 - 4;
+	memset(str + 4, 0, len);
+	if (len > strlen(version))
+		len = strlen(version);
+	memcpy(str + 4, version, len);
+
+	mcp->mb[0] = MBC_SET_RNID_PARAMS;
+	mcp->mb[1] = RNID_TYPE_SET_VERSION << 8 | dwlen;
+	mcp->mb[2] = MSW(LSD(str_dma));
+	mcp->mb[3] = LSW(LSD(str_dma));
+	mcp->mb[6] = MSW(MSD(str_dma));
+	mcp->mb[7] = LSW(MSD(str_dma));
+	mcp->out_mb = MBX_7|MBX_6|MBX_3|MBX_2|MBX_1|MBX_0;
+	mcp->in_mb = MBX_1|MBX_0;
+	mcp->tov = MBX_TOV_SECONDS;
+	mcp->flags = 0;
+	rval = qla2x00_mailbox_command(vha, mcp);
+
+	if (rval != QLA_SUCCESS) {
+		ql_dbg(ql_dbg_mbx, vha, 0x1180,
+		    "Failed=%x mb[0]=%x,%x.\n", rval, mcp->mb[0], mcp->mb[1]);
+	} else {
+		ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x1181,
+		    "Done %s.\n", __func__);
+	}
+
+	dma_pool_free(ha->s_dma_pool, str, str_dma);
+
+	return rval;
+}
+
 static int
 qla2x00_read_asic_temperature(scsi_qla_host_t *vha, uint16_t *temp)
 {
-- 
1.7.7


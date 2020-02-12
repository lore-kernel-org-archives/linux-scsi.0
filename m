Return-Path: <SRS0=6k2I=4A=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C952CC352A4
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Feb 2020 21:47:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 898C82168B
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Feb 2020 21:47:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="GN6Q3Qpg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728603AbgBLVrC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 Feb 2020 16:47:02 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:12128 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727564AbgBLVrC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 12 Feb 2020 16:47:02 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01CLeYCl001625;
        Wed, 12 Feb 2020 13:44:59 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=Ir6cx/8ImU+UFfLq/HS+PWpAQKFz8Rr1rAPhJwZ5tVE=;
 b=GN6Q3QpgQK2LOnV9oREMZAeB7Y+a34naRI6X0DUpu6ObX3KUOswaKRf8QSUoqxh0cClk
 5e75ZFM2AfQ5y5k/qnch0h73KeVU4Er4NANDT5siFUtnhsYPwsCkz2MDsctn8jM1TN+E
 KEN8I89pFcoOQ0CBrqL+X0J16wbNOk/jgbcrXAdhXRINmS1Gegq5xkO7Q6t1d2h64HB8
 jAqtPP8DZSC6/XNEYTx17Xep0v3krbl70HtS3L/OLvKrEWzbxbrgnaZOF/PqJN5jAC7h
 qoaxOxUv9gR3j09N2v8bs8Y5onABIi6nIFpkxXwXyOqu7YoZtMAdJFfC2p6CEcBGLFqb vg== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0b-0016f401.pphosted.com with ESMTP id 2y4j5jt4w3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 12 Feb 2020 13:44:59 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 12 Feb
 2020 13:44:57 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 12 Feb
 2020 13:44:55 -0800
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 12 Feb 2020 13:44:55 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id A7E9C3F703F;
        Wed, 12 Feb 2020 13:44:55 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 01CLitIJ025592;
        Wed, 12 Feb 2020 13:44:55 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 01CLitdh025591;
        Wed, 12 Feb 2020 13:44:55 -0800
From:   Himanshu Madhani <hmadhani@marvell.com>
To:     <James.Bottomley@HansenPartnership.com>,
        <martin.petersen@oracle.com>
CC:     <hmadhani@marvell.com>, <linux-scsi@vger.kernel.org>
Subject: [PATCH 06/25] qla2xxx: Add changes in preparation for vendor extended FDMI/RDP
Date:   Wed, 12 Feb 2020 13:44:17 -0800
Message-ID: <20200212214436.25532-7-hmadhani@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20200212214436.25532-1-hmadhani@marvell.com>
References: <20200212214436.25532-1-hmadhani@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-12_10:2020-02-12,2020-02-12 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Joe Carnuccio <joe.carnuccio@qlogic.com>

This patch prepares code for implementing Vendor specific
extended FDMI/RDP commands. It also addes support for
MBC_GET_PORT_DATABASE and MBC_GET_RNID_PARAMS commands.

Signed-off-by: Joe Carnuccio <joe.carnuccio@qlogic.com>
Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
---
 drivers/scsi/qla2xxx/qla_def.h  |   3 +
 drivers/scsi/qla2xxx/qla_fw.h   |   4 ++
 drivers/scsi/qla2xxx/qla_gbl.h  |  12 +++-
 drivers/scsi/qla2xxx/qla_gs.c   |  15 +++--
 drivers/scsi/qla2xxx/qla_init.c |  28 +++++++---
 drivers/scsi/qla2xxx/qla_mbx.c  | 121 ++++++++++++++++++++++++++++++++++------
 drivers/scsi/qla2xxx/qla_mid.c  |   3 +
 drivers/scsi/qla2xxx/qla_os.c   |   4 +-
 8 files changed, 155 insertions(+), 35 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 209491a1d022..917939c5e5be 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -1261,7 +1261,9 @@ static inline bool qla2xxx_is_valid_mbs(unsigned int mbs)
 #define	MBX_1		BIT_1
 #define	MBX_0		BIT_0
 
+#define RNID_TYPE_ELS_CMD	0x5
 #define RNID_TYPE_PORT_LOGIN	0x7
+#define RNID_BUFFER_CREDITS	0x8
 #define RNID_TYPE_SET_VERSION	0x9
 #define RNID_TYPE_ASIC_TEMP	0xC
 
@@ -4458,6 +4460,7 @@ typedef struct scsi_qla_host {
 	uint8_t		node_name[WWN_SIZE];
 	uint8_t		port_name[WWN_SIZE];
 	uint8_t		fabric_node_name[WWN_SIZE];
+	uint8_t		fabric_port_name[WWN_SIZE];
 
 	struct		nvme_fc_local_port *nvme_local_port;
 	struct completion nvme_del_done;
diff --git a/drivers/scsi/qla2xxx/qla_fw.h b/drivers/scsi/qla2xxx/qla_fw.h
index d641918cdd46..02c1dbb4abc8 100644
--- a/drivers/scsi/qla2xxx/qla_fw.h
+++ b/drivers/scsi/qla2xxx/qla_fw.h
@@ -31,6 +31,9 @@
 #define PDO_FORCE_ADISC		BIT_1
 #define PDO_FORCE_PLOGI		BIT_0
 
+struct buffer_credit_24xx {
+	u32 parameter[28];
+};
 
 #define	PORT_DATABASE_24XX_SIZE		64
 struct port_database_24xx {
@@ -1883,6 +1886,7 @@ struct nvram_81xx {
 	 * BIT 6-15 = Unused
 	 */
 	uint16_t enhanced_features;
+
 	uint16_t reserved_24[4];
 
 	/* Offset 416. */
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 156ad11a15c4..b40a3fb46c00 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -32,6 +32,8 @@ extern int qla81xx_nvram_config(struct scsi_qla_host *);
 extern void qla2x00_update_fw_options(struct scsi_qla_host *);
 extern void qla24xx_update_fw_options(scsi_qla_host_t *);
 extern void qla81xx_update_fw_options(scsi_qla_host_t *);
+extern void qla83xx_update_fw_options(scsi_qla_host_t *);
+
 extern int qla2x00_load_risc(struct scsi_qla_host *, uint32_t *);
 extern int qla24xx_load_risc(scsi_qla_host_t *, uint32_t *);
 extern int qla81xx_load_risc(scsi_qla_host_t *, uint32_t *);
@@ -142,6 +144,7 @@ extern int qlport_down_retry;
 extern int ql2xplogiabsentdevice;
 extern int ql2xloginretrycount;
 extern int ql2xfdmienable;
+extern int ql2xsmartsan;
 extern int ql2xallocfwdump;
 extern int ql2xextended_error_logging;
 extern int ql2xiidmaenable;
@@ -354,6 +357,9 @@ extern int
 qla2x00_get_port_database(scsi_qla_host_t *, fc_port_t *, uint8_t);
 
 extern int
+qla24xx_get_port_database(scsi_qla_host_t *, u16, struct port_database_24xx *);
+
+extern int
 qla2x00_get_firmware_state(scsi_qla_host_t *, uint16_t *);
 
 extern int
@@ -452,6 +458,10 @@ extern int
 qla25xx_set_driver_version(scsi_qla_host_t *, char *);
 
 extern int
+qla24xx_get_buffer_credits(scsi_qla_host_t *, struct buffer_credit_24xx *,
+    dma_addr_t);
+
+extern int
 qla2x00_read_sfp(scsi_qla_host_t *, dma_addr_t, uint8_t *,
 	uint16_t, uint16_t, uint16_t, uint16_t);
 
@@ -656,7 +666,7 @@ extern void *qla24xx_prep_ms_fdmi_iocb(scsi_qla_host_t *, uint32_t, uint32_t);
 extern int qla2x00_fdmi_register(scsi_qla_host_t *);
 extern int qla2x00_gfpn_id(scsi_qla_host_t *, sw_info_t *);
 extern int qla2x00_gpsc(scsi_qla_host_t *, sw_info_t *);
-extern void qla2x00_get_sym_node_name(scsi_qla_host_t *, uint8_t *, size_t);
+extern size_t qla2x00_get_sym_node_name(scsi_qla_host_t *, uint8_t *, size_t);
 extern int qla2x00_chk_ms_status(scsi_qla_host_t *, ms_iocb_entry_t *,
 	struct ct_sns_rsp *, const char *);
 extern void qla2x00_async_iocb_timeout(void *data);
diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index aaa4a5bbf2ff..c01eb87c709f 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -844,19 +844,18 @@ static int qla_async_rnnid(scsi_qla_host_t *vha, port_id_t *d_id,
 	return rval;
 }
 
-void
+size_t
 qla2x00_get_sym_node_name(scsi_qla_host_t *vha, uint8_t *snn, size_t size)
 {
 	struct qla_hw_data *ha = vha->hw;
 
 	if (IS_QLAFX00(ha))
-		snprintf(snn, size, "%s FW:v%s DVR:v%s", ha->model_number,
-		    ha->mr.fw_version, qla2x00_version_str);
-	else
-		snprintf(snn, size,
-		    "%s FW:v%d.%02d.%02d DVR:v%s", ha->model_number,
-		    ha->fw_major_version, ha->fw_minor_version,
-		    ha->fw_subminor_version, qla2x00_version_str);
+		return scnprintf(snn, size, "%s FW:v%s DVR:v%s",
+		    ha->model_number, ha->mr.fw_version, qla2x00_version_str);
+
+	return scnprintf(snn, size, "%s FW:v%d.%02d.%02d DVR:v%s",
+	    ha->model_number, ha->fw_major_version, ha->fw_minor_version,
+	    ha->fw_subminor_version, qla2x00_version_str);
 }
 
 /**
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 9e6b56527b25..9887602529a3 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -5541,24 +5541,22 @@ qla2x00_configure_fabric(scsi_qla_host_t *vha)
 	}
 	vha->device_flags |= SWITCH_FOUND;
 
+	rval = qla2x00_get_port_name(vha, loop_id, vha->fabric_port_name, 0);
+	if (rval != QLA_SUCCESS)
+		ql_dbg(ql_dbg_disc, vha, 0x20ff,
+		    "Failed to get Fabric Port Name\n");
 
 	if (qla_tgt_mode_enabled(vha) || qla_dual_mode_enabled(vha)) {
 		rval = qla2x00_send_change_request(vha, 0x3, 0);
 		if (rval != QLA_SUCCESS)
 			ql_log(ql_log_warn, vha, 0x121,
-				"Failed to enable receiving of RSCN requests: 0x%x.\n",
-				rval);
+			    "Failed to enable receiving of RSCN requests: 0x%x.\n",
+			    rval);
 	}
 
-
 	do {
 		qla2x00_mgmt_svr_login(vha);
 
-		/* FDMI support. */
-		if (ql2xfdmienable &&
-		    test_and_clear_bit(REGISTER_FDMI_NEEDED, &vha->dpc_flags))
-			qla2x00_fdmi_register(vha);
-
 		/* Ensure we are logged into the SNS. */
 		loop_id = NPH_SNS_LID(ha);
 		rval = ha->isp_ops->fabric_login(vha, loop_id, 0xff, 0xff,
@@ -5570,6 +5568,12 @@ qla2x00_configure_fabric(scsi_qla_host_t *vha)
 			set_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags);
 			return rval;
 		}
+
+		/* FDMI support. */
+		if (ql2xfdmienable &&
+		    test_and_clear_bit(REGISTER_FDMI_NEEDED, &vha->dpc_flags))
+			qla2x00_fdmi_register(vha);
+
 		if (test_and_clear_bit(REGISTER_FC4_NEEDED, &vha->dpc_flags)) {
 			if (qla2x00_rft_id(vha)) {
 				/* EMPTY */
@@ -8664,6 +8668,14 @@ qla82xx_restart_isp(scsi_qla_host_t *vha)
 }
 
 void
+qla83xx_update_fw_options(scsi_qla_host_t *vha)
+{
+	struct qla_hw_data *ha = vha->hw;
+
+	qla2x00_set_fw_options(vha, ha->fw_options);
+}
+
+void
 qla81xx_update_fw_options(scsi_qla_host_t *vha)
 {
 	struct qla_hw_data *ha = vha->hw;
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index e1916bec5e36..f295bd73128f 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -643,7 +643,6 @@ qla2x00_load_ram(scsi_qla_host_t *vha, dma_addr_t req_dma, uint32_t risc_addr,
 	return rval;
 }
 
-#define	EXTENDED_BB_CREDITS	BIT_0
 #define	NVME_ENABLE_FLAG	BIT_3
 static inline uint16_t qla25xx_set_sfp_lr_dist(struct qla_hw_data *ha)
 {
@@ -1410,12 +1409,12 @@ qla2x00_issue_iocb_timeout(scsi_qla_host_t *vha, void *buffer,
 
 	mcp->mb[0] = MBC_IOCB_COMMAND_A64;
 	mcp->mb[1] = 0;
-	mcp->mb[2] = MSW(phys_addr);
-	mcp->mb[3] = LSW(phys_addr);
+	mcp->mb[2] = MSW(LSD(phys_addr));
+	mcp->mb[3] = LSW(LSD(phys_addr));
 	mcp->mb[6] = MSW(MSD(phys_addr));
 	mcp->mb[7] = LSW(MSD(phys_addr));
 	mcp->out_mb = MBX_7|MBX_6|MBX_3|MBX_2|MBX_1|MBX_0;
-	mcp->in_mb = MBX_2|MBX_0;
+	mcp->in_mb = MBX_1|MBX_0;
 	mcp->tov = tov;
 	mcp->flags = 0;
 	rval = qla2x00_mailbox_command(vha, mcp);
@@ -1424,13 +1423,14 @@ qla2x00_issue_iocb_timeout(scsi_qla_host_t *vha, void *buffer,
 		/*EMPTY*/
 		ql_dbg(ql_dbg_mbx, vha, 0x1039, "Failed=%x.\n", rval);
 	} else {
-		sts_entry_t *sts_entry = (sts_entry_t *) buffer;
+		sts_entry_t *sts_entry = buffer;
 
 		/* Mask reserved bits. */
 		sts_entry->entry_status &=
 		    IS_FWI2_CAPABLE(vha->hw) ? RF_MASK_24XX : RF_MASK;
 		ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x103a,
-		    "Done %s.\n", __func__);
+		    "Done %s (status=%x).\n", __func__,
+		    sts_entry->entry_status);
 	}
 
 	return rval;
@@ -2045,6 +2045,57 @@ qla2x00_get_port_database(scsi_qla_host_t *vha, fc_port_t *fcport, uint8_t opt)
 	return rval;
 }
 
+int
+qla24xx_get_port_database(scsi_qla_host_t *vha, u16 nport_handle,
+    struct port_database_24xx *pdb)
+{
+	mbx_cmd_t mc;
+	mbx_cmd_t *mcp = &mc;
+	dma_addr_t pdb_dma;
+	int rval;
+
+	ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x1115,
+	    "Entered %s.\n", __func__);
+
+	memset(pdb, 0, sizeof(*pdb));
+
+	pdb_dma = dma_map_single(&vha->hw->pdev->dev, pdb,
+	    sizeof(*pdb), DMA_FROM_DEVICE);
+	if (!pdb_dma) {
+		ql_log(ql_log_warn, vha, 0x1116, "Failed to map dma buffer.\n");
+		return QLA_MEMORY_ALLOC_FAILED;
+	}
+
+	mcp->mb[0] = MBC_GET_PORT_DATABASE;
+	mcp->mb[1] = nport_handle;
+	mcp->mb[2] = MSW(LSD(pdb_dma));
+	mcp->mb[3] = LSW(LSD(pdb_dma));
+	mcp->mb[6] = MSW(MSD(pdb_dma));
+	mcp->mb[7] = LSW(MSD(pdb_dma));
+	mcp->mb[9] = 0;
+	mcp->mb[10] = 0;
+	mcp->out_mb = MBX_10|MBX_9|MBX_7|MBX_6|MBX_3|MBX_2|MBX_1|MBX_0;
+	mcp->in_mb = MBX_1|MBX_0;
+	mcp->buf_size = sizeof(*pdb);
+	mcp->flags = MBX_DMA_IN;
+	mcp->tov = vha->hw->login_timeout * 2;
+	rval = qla2x00_mailbox_command(vha, mcp);
+
+	if (rval != QLA_SUCCESS) {
+		ql_dbg(ql_dbg_mbx, vha, 0x111a,
+		    "Failed=%x mb[0]=%x mb[1]=%x.\n",
+		    rval, mcp->mb[0], mcp->mb[1]);
+	} else {
+		ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x111b,
+		    "Done %s.\n", __func__);
+	}
+
+	dma_unmap_single(&vha->hw->pdev->dev, pdb_dma,
+	    sizeof(*pdb), DMA_FROM_DEVICE);
+
+	return rval;
+}
+
 /*
  * qla2x00_get_firmware_state
  *	Get adapter firmware state.
@@ -3060,18 +3111,19 @@ qla24xx_get_isp_stats(scsi_qla_host_t *vha, struct link_statistics *stats,
 	int rval;
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
-	uint32_t *iter, dwords;
+	uint32_t *iter = (void *)stats;
+	ushort dwords = sizeof(*stats)/sizeof(*iter);
 
 	ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x1088,
 	    "Entered %s.\n", __func__);
 
 	memset(&mc, 0, sizeof(mc));
 	mc.mb[0] = MBC_GET_LINK_PRIV_STATS;
-	mc.mb[2] = MSW(stats_dma);
-	mc.mb[3] = LSW(stats_dma);
+	mc.mb[2] = MSW(LSD(stats_dma));
+	mc.mb[3] = LSW(LSD(stats_dma));
 	mc.mb[6] = MSW(MSD(stats_dma));
 	mc.mb[7] = LSW(MSD(stats_dma));
-	mc.mb[8] = sizeof(struct link_statistics) / 4;
+	mc.mb[8] = dwords;
 	mc.mb[9] = cpu_to_le16(vha->vp_idx);
 	mc.mb[10] = cpu_to_le16(options);
 
@@ -3086,8 +3138,6 @@ qla24xx_get_isp_stats(scsi_qla_host_t *vha, struct link_statistics *stats,
 			ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x108a,
 			    "Done %s.\n", __func__);
 			/* Re-endianize - firmware data is le32. */
-			dwords = sizeof(struct link_statistics) / 4;
-			iter = &stats->link_fail_cnt;
 			for ( ; dwords--; iter++)
 				le32_to_cpus(iter);
 		}
@@ -4827,6 +4877,45 @@ qla24xx_get_port_login_templ(scsi_qla_host_t *vha, dma_addr_t buf_dma,
 	return rval;
 }
 
+int
+qla24xx_get_buffer_credits(scsi_qla_host_t *vha, struct buffer_credit_24xx *bbc,
+    dma_addr_t bbc_dma)
+{
+	mbx_cmd_t mc;
+	mbx_cmd_t *mcp = &mc;
+	int rval;
+
+	if (!IS_FWI2_CAPABLE(vha->hw))
+		return QLA_FUNCTION_FAILED;
+
+	ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x118e,
+	    "Entered %s.\n", __func__);
+
+	mcp->mb[0] = MBC_GET_RNID_PARAMS;
+	mcp->mb[1] = RNID_BUFFER_CREDITS << 8;
+	mcp->mb[2] = MSW(LSD(bbc_dma));
+	mcp->mb[3] = LSW(LSD(bbc_dma));
+	mcp->mb[6] = MSW(MSD(bbc_dma));
+	mcp->mb[7] = LSW(MSD(bbc_dma));
+	mcp->mb[8] = sizeof(*bbc) / sizeof(*bbc->parameter);
+	mcp->out_mb = MBX_8|MBX_7|MBX_6|MBX_3|MBX_2|MBX_1|MBX_0;
+	mcp->in_mb = MBX_1|MBX_0;
+	mcp->buf_size = sizeof(*bbc);
+	mcp->flags = MBX_DMA_IN;
+	mcp->tov = MBX_TOV_SECONDS;
+	rval = qla2x00_mailbox_command(vha, mcp);
+
+	if (rval != QLA_SUCCESS) {
+		ql_dbg(ql_dbg_mbx, vha, 0x118f,
+		    "Failed=%x mb[0]=%x,%x.\n", rval, mcp->mb[0], mcp->mb[1]);
+	} else {
+		ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x1190,
+		    "Done %s.\n", __func__);
+	}
+
+	return rval;
+}
+
 static int
 qla2x00_read_asic_temperature(scsi_qla_host_t *vha, uint16_t *temp)
 {
@@ -4880,8 +4969,8 @@ qla2x00_read_sfp(scsi_qla_host_t *vha, dma_addr_t sfp_dma, uint8_t *sfp,
 
 	mcp->mb[0] = MBC_READ_SFP;
 	mcp->mb[1] = dev;
-	mcp->mb[2] = MSW(sfp_dma);
-	mcp->mb[3] = LSW(sfp_dma);
+	mcp->mb[2] = MSW(LSD(sfp_dma));
+	mcp->mb[3] = LSW(LSD(sfp_dma));
 	mcp->mb[6] = MSW(MSD(sfp_dma));
 	mcp->mb[7] = LSW(MSD(sfp_dma));
 	mcp->mb[8] = len;
@@ -4934,8 +5023,8 @@ qla2x00_write_sfp(scsi_qla_host_t *vha, dma_addr_t sfp_dma, uint8_t *sfp,
 
 	mcp->mb[0] = MBC_WRITE_SFP;
 	mcp->mb[1] = dev;
-	mcp->mb[2] = MSW(sfp_dma);
-	mcp->mb[3] = LSW(sfp_dma);
+	mcp->mb[2] = MSW(LSD(sfp_dma));
+	mcp->mb[3] = LSW(LSD(sfp_dma));
 	mcp->mb[6] = MSW(MSD(sfp_dma));
 	mcp->mb[7] = LSW(MSD(sfp_dma));
 	mcp->mb[8] = len;
diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
index 8ae639d089d1..d211f803c699 100644
--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -509,6 +509,9 @@ qla24xx_create_vhost(struct fc_vport *fc_vport)
 	vha->mgmt_svr_loop_id = qla2x00_reserve_mgmt_server_loop_id(vha);
 
 	vha->dpc_flags = 0L;
+	ha->dpc_active = 0;
+	set_bit(REGISTER_FDMI_NEEDED, &vha->dpc_flags);
+	set_bit(REGISTER_FC4_NEEDED, &vha->dpc_flags);
 
 	/*
 	 * To fix the issue of processing a parent's RSCN for the vport before
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 7f8b5ab0c4c4..39d75de84db6 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -2286,7 +2286,7 @@ static struct isp_operations qla81xx_isp_ops = {
 	.config_rings		= qla24xx_config_rings,
 	.reset_adapter		= qla24xx_reset_adapter,
 	.nvram_config		= qla81xx_nvram_config,
-	.update_fw_options	= qla81xx_update_fw_options,
+	.update_fw_options	= qla83xx_update_fw_options,
 	.load_risc		= qla81xx_load_risc,
 	.pci_info_str		= qla24xx_pci_info_str,
 	.fw_version_str		= qla24xx_fw_version_str,
@@ -2403,7 +2403,7 @@ static struct isp_operations qla83xx_isp_ops = {
 	.config_rings		= qla24xx_config_rings,
 	.reset_adapter		= qla24xx_reset_adapter,
 	.nvram_config		= qla81xx_nvram_config,
-	.update_fw_options	= qla81xx_update_fw_options,
+	.update_fw_options	= qla83xx_update_fw_options,
 	.load_risc		= qla81xx_load_risc,
 	.pci_info_str		= qla24xx_pci_info_str,
 	.fw_version_str		= qla24xx_fw_version_str,
-- 
2.12.0


Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDA8DC433E2
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Mar 2021 08:59:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CE49E601FD
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Mar 2021 08:59:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233822AbhC2I7M (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Mar 2021 04:59:12 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:35034 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S236807AbhC2I4L (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 29 Mar 2021 04:56:11 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12T8sREZ008737;
        Mon, 29 Mar 2021 01:56:09 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=6+BONzhm5XFDZTFARXpUu5KLH9aorYBfUUhD0IGYUFs=;
 b=MLBn/tLHUGv/wjahScJqgqjid12+1P6r48DvaLxX7McRibEppXrnfwzCLSTOWfV2THRL
 eWgYmiR0xtYsaNUbU59a3pqoputMq+iIJlq2rR8ZNXx/Yk53iio6W9hj2VXEc/pUhrYI
 hNBFNDuZJw0G+tBysHFKEPpNTCK+HROJKMDYgf6rdCOnGBs5DSEaRnFcpXhM+ijhK4h7
 ejsnAeSGaSyeIi+V+hjCMBM9ERiYjHrJA3xwOrUI787Os5a3wvUMIn2UNd4XBeWR5Jsu
 0/ghATPLB8u7hZMmyZz5PvOfBchZL+D8rdneNJWhk9t4E4POnfS2cUXjUaR3Ys0h+sMM vQ== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 37k63b8vnw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 29 Mar 2021 01:56:08 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 29 Mar
 2021 01:56:07 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 29 Mar 2021 01:56:07 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 2C0E33F703F;
        Mon, 29 Mar 2021 01:56:07 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 12T8u6sm004467;
        Mon, 29 Mar 2021 01:56:06 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 12T8u6Ov004458;
        Mon, 29 Mar 2021 01:56:06 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <loberman@redhat.com>
Subject: [PATCH v2 08/12] qla2xxx: fix crash in PCIe error handling
Date:   Mon, 29 Mar 2021 01:52:25 -0700
Message-ID: <20210329085229.4367-9-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20210329085229.4367-1-njavali@marvell.com>
References: <20210329085229.4367-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: 9q6w2GHw2XF0BPY7XBS3LRqXWy7EOywL
X-Proofpoint-GUID: 9q6w2GHw2XF0BPY7XBS3LRqXWy7EOywL
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-29_04:2021-03-26,2021-03-29 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

BUG: unable to handle kernel NULL pointer dereference at (null)
IP: qla2x00_abort_isp+0x21/0x6b0 [qla2xxx] PGD 0 P4D 0
Oops: 0000 [#1] SMP PTI
CPU: 0 PID: 1715 Comm: kworker/0:2
Tainted: GOE 4.12.14-122.37-default #1 SLE12-SP5
Hardware name: HPE Superdome Flex/Superdome Flex, BIOS
Bundle:3.30.100 SFW:IP147.007.004.017.000.2009211957 09/21/2020
Workqueue: events aer_recover_work_func
task: ffff9e399c14ca80 task.stack: ffffc1c58e4ac000
RIP: 0010:qla2x00_abort_isp+0x21/0x6b0 [qla2xxx]
RSP: 0018:ffffc1c58e4afd50 EFLAGS: 00010282
RAX: 0000000000000000 RBX: ffff9e419cdef480 RCX: 0000000000000000
RDX: ffff9e399c14ca80 RSI: 0000000000000246 RDI: ffff9e419bbc27b8
RBP: ffff9e419bbc27b8 R08: 0000000000000004 R09: 00000000a0440000
R10: 0000000000000000 R11: ffff9e399416d1a0 R12: ffff9e419cdef000
R13: ffff9e3a7cfae800 R14: ffff9e3a7cfae800 R15: 00000000000000c0
FS:  0000000000000000(0000) GS:ffff9e39a0000000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 00000006cd00a005 CR4: 00000000007606f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
PKRU: 55555554
Call Trace:
  qla2xxx_pci_slot_reset+0x141/0x160 [qla2xxx]
  report_slot_reset+0x41/0x80
  ? merge_result.part.4+0x30/0x30
  pci_walk_bus+0x70/0x90
  pcie_do_recovery+0x1db/0x2e0
  aer_recover_work_func+0xc2/0xf0
  process_one_work+0x14c/0x390

Disable board_disable logic where driver resources are freed
while OS is in the process of recovering the adapter.

Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Tested-by: Laurence Oberman <loberman@redhat.com>
---
 drivers/scsi/qla2xxx/qla_dbg.c    |  16 ++-
 drivers/scsi/qla2xxx/qla_def.h    |  10 ++
 drivers/scsi/qla2xxx/qla_gbl.h    |   3 +
 drivers/scsi/qla2xxx/qla_init.c   |  40 ++++---
 drivers/scsi/qla2xxx/qla_inline.h |  46 ++++++++
 drivers/scsi/qla2xxx/qla_iocb.c   |  60 +++++++++--
 drivers/scsi/qla2xxx/qla_isr.c    |   9 +-
 drivers/scsi/qla2xxx/qla_mbx.c    |   3 +-
 drivers/scsi/qla2xxx/qla_nvme.c   |  10 +-
 drivers/scsi/qla2xxx/qla_os.c     | 173 ++++++++++++++++++------------
 10 files changed, 265 insertions(+), 105 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index 144a893e7335..f2d05592c1e2 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -113,8 +113,13 @@ qla27xx_dump_mpi_ram(struct qla_hw_data *ha, uint32_t addr, uint32_t *ram,
 	uint32_t stat;
 	ulong i, j, timer = 6000000;
 	int rval = QLA_FUNCTION_FAILED;
+	scsi_qla_host_t *vha = pci_get_drvdata(ha->pdev);
 
 	clear_bit(MBX_INTERRUPT, &ha->mbx_cmd_flags);
+
+	if (qla_pci_disconnected(vha, reg))
+		return rval;
+
 	for (i = 0; i < ram_dwords; i += dwords, addr += dwords) {
 		if (i + dwords > ram_dwords)
 			dwords = ram_dwords - i;
@@ -138,6 +143,9 @@ qla27xx_dump_mpi_ram(struct qla_hw_data *ha, uint32_t addr, uint32_t *ram,
 		while (timer--) {
 			udelay(5);
 
+			if (qla_pci_disconnected(vha, reg))
+				return rval;
+
 			stat = rd_reg_dword(&reg->host_status);
 			/* Check for pending interrupts. */
 			if (!(stat & HSRX_RISC_INT))
@@ -192,9 +200,13 @@ qla24xx_dump_ram(struct qla_hw_data *ha, uint32_t addr, __be32 *ram,
 	uint32_t dwords = qla2x00_gid_list_size(ha) / 4;
 	uint32_t stat;
 	ulong i, j, timer = 6000000;
+	scsi_qla_host_t *vha = pci_get_drvdata(ha->pdev);
 
 	clear_bit(MBX_INTERRUPT, &ha->mbx_cmd_flags);
 
+	if (qla_pci_disconnected(vha, reg))
+		return rval;
+
 	for (i = 0; i < ram_dwords; i += dwords, addr += dwords) {
 		if (i + dwords > ram_dwords)
 			dwords = ram_dwords - i;
@@ -216,8 +228,10 @@ qla24xx_dump_ram(struct qla_hw_data *ha, uint32_t addr, __be32 *ram,
 		ha->flags.mbox_int = 0;
 		while (timer--) {
 			udelay(5);
-			stat = rd_reg_dword(&reg->host_status);
+			if (qla_pci_disconnected(vha, reg))
+				return rval;
 
+			stat = rd_reg_dword(&reg->host_status);
 			/* Check for pending interrupts. */
 			if (!(stat & HSRX_RISC_INT))
 				continue;
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 3d09f31895e7..cfe337427fdc 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -396,6 +396,7 @@ typedef union {
 	} b;
 } port_id_t;
 #define INVALID_PORT_ID	0xFFFFFF
+#define ISP_REG16_DISCONNECT 0xFFFF
 
 static inline le_id_t be_id_to_le(be_id_t id)
 {
@@ -3857,6 +3858,13 @@ struct qla_hw_data_stat {
 	u32 num_mpi_reset;
 };
 
+/* refer to pcie_do_recovery reference */
+typedef enum {
+	QLA_PCI_RESUME,
+	QLA_PCI_ERR_DETECTED,
+	QLA_PCI_MMIO_ENABLED,
+	QLA_PCI_SLOT_RESET,
+} pci_error_state_t;
 /*
  * Qlogic host adapter specific data structure.
 */
@@ -4607,6 +4615,7 @@ struct qla_hw_data {
 #define DEFAULT_ZIO_THRESHOLD 5
 
 	struct qla_hw_data_stat stat;
+	pci_error_state_t pci_error_state;
 };
 
 struct active_regions {
@@ -4727,6 +4736,7 @@ typedef struct scsi_qla_host {
 #define FX00_CRITEMP_RECOVERY	25
 #define FX00_HOST_INFO_RESEND	26
 #define QPAIR_ONLINE_CHECK_NEEDED	27
+#define DO_EEH_RECOVERY		28
 #define DETECT_SFP_CHANGE	29
 #define N2N_LOGIN_NEEDED	30
 #define IOCB_WORK_ACTIVE	31
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 6486f97d649e..fae5cae6f0a8 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -224,6 +224,7 @@ extern int qla2x00_post_uevent_work(struct scsi_qla_host *, u32);
 
 extern int qla2x00_post_uevent_work(struct scsi_qla_host *, u32);
 extern void qla2x00_disable_board_on_pci_error(struct work_struct *);
+extern void qla_eeh_work(struct work_struct *);
 extern void qla2x00_sp_compl(srb_t *sp, int);
 extern void qla2xxx_qpair_sp_free_dma(srb_t *sp);
 extern void qla2xxx_qpair_sp_compl(srb_t *sp, int);
@@ -235,6 +236,8 @@ int qla24xx_post_relogin_work(struct scsi_qla_host *vha);
 void qla2x00_wait_for_sess_deletion(scsi_qla_host_t *);
 void qla24xx_process_purex_rdp(struct scsi_qla_host *vha,
 			       struct purex_item *pkt);
+void qla_pci_set_eeh_busy(struct scsi_qla_host *);
+void qla_schedule_eeh_work(struct scsi_qla_host *);
 
 /*
  * Global Functions in qla_mid.c source file.
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 19681d3c5b7a..9c5782e946e0 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -6932,22 +6932,18 @@ qla2x00_abort_isp_cleanup(scsi_qla_host_t *vha)
 	}
 	spin_unlock_irqrestore(&ha->vport_slock, flags);
 
-	if (!ha->flags.eeh_busy) {
-		/* Make sure for ISP 82XX IO DMA is complete */
-		if (IS_P3P_TYPE(ha)) {
-			qla82xx_chip_reset_cleanup(vha);
-			ql_log(ql_log_info, vha, 0x00b4,
-			    "Done chip reset cleanup.\n");
-
-			/* Done waiting for pending commands.
-			 * Reset the online flag.
-			 */
-			vha->flags.online = 0;
-		}
+	/* Make sure for ISP 82XX IO DMA is complete */
+	if (IS_P3P_TYPE(ha)) {
+		qla82xx_chip_reset_cleanup(vha);
+		ql_log(ql_log_info, vha, 0x00b4,
+		       "Done chip reset cleanup.\n");
 
-		/* Requeue all commands in outstanding command list. */
-		qla2x00_abort_all_cmds(vha, DID_RESET << 16);
+		/* Done waiting for pending commands. Reset online flag */
+		vha->flags.online = 0;
 	}
+
+	/* Requeue all commands in outstanding command list. */
+	qla2x00_abort_all_cmds(vha, DID_RESET << 16);
 	/* memory barrier */
 	wmb();
 }
@@ -6978,6 +6974,12 @@ qla2x00_abort_isp(scsi_qla_host_t *vha)
 		if (vha->hw->flags.port_isolated)
 			return status;
 
+		if (qla2x00_isp_reg_stat(ha)) {
+			ql_log(ql_log_info, vha, 0x803f,
+			       "ISP Abort - ISP reg disconnect, exiting.\n");
+			return status;
+		}
+
 		if (test_and_clear_bit(ISP_ABORT_TO_ROM, &vha->dpc_flags)) {
 			ha->flags.chip_reset_done = 1;
 			vha->flags.online = 1;
@@ -7017,8 +7019,18 @@ qla2x00_abort_isp(scsi_qla_host_t *vha)
 
 		ha->isp_ops->get_flash_version(vha, req->ring);
 
+		if (qla2x00_isp_reg_stat(ha)) {
+			ql_log(ql_log_info, vha, 0x803f,
+			       "ISP Abort - ISP reg disconnect pre nvram config, exiting.\n");
+			return status;
+		}
 		ha->isp_ops->nvram_config(vha);
 
+		if (qla2x00_isp_reg_stat(ha)) {
+			ql_log(ql_log_info, vha, 0x803f,
+			       "ISP Abort - ISP reg disconnect post nvmram config, exiting.\n");
+			return status;
+		}
 		if (!qla2x00_restart_isp(vha)) {
 			clear_bit(RESET_MARKER_NEEDED, &vha->dpc_flags);
 
diff --git a/drivers/scsi/qla2xxx/qla_inline.h b/drivers/scsi/qla2xxx/qla_inline.h
index e80e41b6c9e1..82937c6bd9c4 100644
--- a/drivers/scsi/qla2xxx/qla_inline.h
+++ b/drivers/scsi/qla2xxx/qla_inline.h
@@ -432,3 +432,49 @@ qla_put_iocbs(struct qla_qpair *qp, struct iocb_resource *iores)
 	}
 	iores->res_type = RESOURCE_NONE;
 }
+
+#define ISP_REG_DISCONNECT 0xffffffffU
+/**************************************************************************
+ * qla2x00_isp_reg_stat
+ *
+ * Description:
+ *        Read the host status register of ISP before aborting the command.
+ *
+ * Input:
+ *       ha = pointer to host adapter structure.
+ *
+ *
+ * Returns:
+ *       Either true or false.
+ *
+ * Note: Return true if there is register disconnect.
+ **************************************************************************/
+static inline
+uint32_t qla2x00_isp_reg_stat(struct qla_hw_data *ha)
+{
+	struct device_reg_24xx __iomem *reg = &ha->iobase->isp24;
+	struct device_reg_82xx __iomem *reg82 = &ha->iobase->isp82;
+
+	if (IS_P3P_TYPE(ha))
+		return ((rd_reg_dword(&reg82->host_int)) == ISP_REG_DISCONNECT);
+	else
+		return ((rd_reg_dword(&reg->host_status)) ==
+			ISP_REG_DISCONNECT);
+}
+
+static inline
+bool qla_pci_disconnected(struct scsi_qla_host *vha,
+			  struct device_reg_24xx __iomem *reg)
+{
+	uint32_t stat;
+	bool ret = false;
+
+	stat = rd_reg_dword(&reg->host_status);
+	if (stat == 0xffffffff) {
+		ql_log(ql_log_info, vha, 0x8041,
+		       "detected PCI disconnect.\n");
+		qla_schedule_eeh_work(vha);
+		ret = true;
+	}
+	return ret;
+}
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index f26a7a14fce9..a86a856215c5 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -1645,8 +1645,14 @@ qla24xx_start_scsi(srb_t *sp)
 		goto queuing_error;
 
 	if (req->cnt < (req_cnt + 2)) {
-		cnt = IS_SHADOW_REG_CAPABLE(ha) ? *req->out_ptr :
-		    rd_reg_dword_relaxed(req->req_q_out);
+		if (IS_SHADOW_REG_CAPABLE(ha)) {
+			cnt = *req->out_ptr;
+		} else {
+			cnt = rd_reg_dword_relaxed(req->req_q_out);
+			if (qla2x00_check_reg16_for_disconnect(vha, cnt))
+				goto queuing_error;
+		}
+
 		if (req->ring_index < cnt)
 			req->cnt = cnt - req->ring_index;
 		else
@@ -1842,8 +1848,13 @@ qla24xx_dif_start_scsi(srb_t *sp)
 		goto queuing_error;
 
 	if (req->cnt < (req_cnt + 2)) {
-		cnt = IS_SHADOW_REG_CAPABLE(ha) ? *req->out_ptr :
-		    rd_reg_dword_relaxed(req->req_q_out);
+		if (IS_SHADOW_REG_CAPABLE(ha)) {
+			cnt = *req->out_ptr;
+		} else {
+			cnt = rd_reg_dword_relaxed(req->req_q_out);
+			if (qla2x00_check_reg16_for_disconnect(vha, cnt))
+				goto queuing_error;
+		}
 		if (req->ring_index < cnt)
 			req->cnt = cnt - req->ring_index;
 		else
@@ -1922,6 +1933,7 @@ qla24xx_dif_start_scsi(srb_t *sp)
 
 	qla_put_iocbs(sp->qpair, &sp->iores);
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+
 	return QLA_FUNCTION_FAILED;
 }
 
@@ -1991,8 +2003,14 @@ qla2xxx_start_scsi_mq(srb_t *sp)
 		goto queuing_error;
 
 	if (req->cnt < (req_cnt + 2)) {
-		cnt = IS_SHADOW_REG_CAPABLE(ha) ? *req->out_ptr :
-		    rd_reg_dword_relaxed(req->req_q_out);
+		if (IS_SHADOW_REG_CAPABLE(ha)) {
+			cnt = *req->out_ptr;
+		} else {
+			cnt = rd_reg_dword_relaxed(req->req_q_out);
+			if (qla2x00_check_reg16_for_disconnect(vha, cnt))
+				goto queuing_error;
+		}
+
 		if (req->ring_index < cnt)
 			req->cnt = cnt - req->ring_index;
 		else
@@ -2203,8 +2221,14 @@ qla2xxx_dif_start_scsi_mq(srb_t *sp)
 		goto queuing_error;
 
 	if (req->cnt < (req_cnt + 2)) {
-		cnt = IS_SHADOW_REG_CAPABLE(ha) ? *req->out_ptr :
-		    rd_reg_dword_relaxed(req->req_q_out);
+		if (IS_SHADOW_REG_CAPABLE(ha)) {
+			cnt = *req->out_ptr;
+		} else {
+			cnt = rd_reg_dword_relaxed(req->req_q_out);
+			if (qla2x00_check_reg16_for_disconnect(vha, cnt))
+				goto queuing_error;
+		}
+
 		if (req->ring_index < cnt)
 			req->cnt = cnt - req->ring_index;
 		else
@@ -2281,6 +2305,7 @@ qla2xxx_dif_start_scsi_mq(srb_t *sp)
 
 	qla_put_iocbs(sp->qpair, &sp->iores);
 	spin_unlock_irqrestore(&qpair->qp_lock, flags);
+
 	return QLA_FUNCTION_FAILED;
 }
 
@@ -2325,6 +2350,11 @@ __qla2x00_alloc_iocbs(struct qla_qpair *qpair, srb_t *sp)
 			cnt = qla2x00_debounce_register(
 			    ISP_REQ_Q_OUT(ha, &reg->isp));
 
+		if (!qpair->use_shadow_reg && cnt == ISP_REG16_DISCONNECT) {
+			qla_schedule_eeh_work(vha);
+			return NULL;
+		}
+
 		if  (req->ring_index < cnt)
 			req->cnt = cnt - req->ring_index;
 		else
@@ -3739,6 +3769,9 @@ qla2x00_start_sp(srb_t *sp)
 	void *pkt;
 	unsigned long flags;
 
+	if (vha->hw->flags.eeh_busy)
+		return -EIO;
+
 	spin_lock_irqsave(qp->qp_lock_ptr, flags);
 	pkt = __qla2x00_alloc_iocbs(sp->qpair, sp);
 	if (!pkt) {
@@ -3956,8 +3989,14 @@ qla2x00_start_bidir(srb_t *sp, struct scsi_qla_host *vha, uint32_t tot_dsds)
 
 	/* Check for room on request queue. */
 	if (req->cnt < req_cnt + 2) {
-		cnt = IS_SHADOW_REG_CAPABLE(ha) ? *req->out_ptr :
-		    rd_reg_dword_relaxed(req->req_q_out);
+		if (IS_SHADOW_REG_CAPABLE(ha)) {
+			cnt = *req->out_ptr;
+		} else {
+			cnt = rd_reg_dword_relaxed(req->req_q_out);
+			if (qla2x00_check_reg16_for_disconnect(vha, cnt))
+				goto queuing_error;
+		}
+
 		if  (req->ring_index < cnt)
 			req->cnt = cnt - req->ring_index;
 		else
@@ -3996,5 +4035,6 @@ qla2x00_start_bidir(srb_t *sp, struct scsi_qla_host *vha, uint32_t tot_dsds)
 	qla2x00_start_iocbs(vha, req);
 queuing_error:
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+
 	return rval;
 }
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 5e188375c871..f21007c8ca51 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -270,12 +270,7 @@ qla2x00_check_reg32_for_disconnect(scsi_qla_host_t *vha, uint32_t reg)
 		if (!test_and_set_bit(PFLG_DISCONNECTED, &vha->pci_flags) &&
 		    !test_bit(PFLG_DRIVER_REMOVING, &vha->pci_flags) &&
 		    !test_bit(PFLG_DRIVER_PROBING, &vha->pci_flags)) {
-			/*
-			 * Schedule this (only once) on the default system
-			 * workqueue so that all the adapter workqueues and the
-			 * DPC thread can be shutdown cleanly.
-			 */
-			schedule_work(&vha->hw->board_disable);
+			qla_schedule_eeh_work(vha);
 		}
 		return true;
 	} else
@@ -1657,8 +1652,6 @@ qla2x00_async_event(scsi_qla_host_t *vha, struct rsp_que *rsp, uint16_t *mb)
 	case MBA_TEMPERATURE_ALERT:
 		ql_dbg(ql_dbg_async, vha, 0x505e,
 		    "TEMPERATURE ALERT: %04x %04x %04x\n", mb[1], mb[2], mb[3]);
-		if (mb[1] == 0x12)
-			schedule_work(&ha->board_disable);
 		break;
 
 	case MBA_TRANS_INSERT:
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 06c99963b2c9..0149f84cdd8e 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -161,7 +161,8 @@ qla2x00_mailbox_command(scsi_qla_host_t *vha, mbx_cmd_t *mcp)
 	/* check if ISP abort is active and return cmd with timeout */
 	if ((test_bit(ABORT_ISP_ACTIVE, &base_vha->dpc_flags) ||
 	    test_bit(ISP_ABORT_RETRY, &base_vha->dpc_flags) ||
-	    test_bit(ISP_ABORT_NEEDED, &base_vha->dpc_flags)) &&
+	    test_bit(ISP_ABORT_NEEDED, &base_vha->dpc_flags) ||
+	    ha->flags.eeh_busy) &&
 	    !is_rom_cmd(mcp->mb[0])) {
 		ql_log(ql_log_info, vha, 0x1005,
 		    "Cmd 0x%x aborted with timeout since ISP Abort is pending\n",
diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_nvme.c
index 0237588f48b0..0cacb667a88b 100644
--- a/drivers/scsi/qla2xxx/qla_nvme.c
+++ b/drivers/scsi/qla2xxx/qla_nvme.c
@@ -398,8 +398,13 @@ static inline int qla2x00_start_nvme_mq(srb_t *sp)
 	}
 	req_cnt = qla24xx_calc_iocbs(vha, tot_dsds);
 	if (req->cnt < (req_cnt + 2)) {
-		cnt = IS_SHADOW_REG_CAPABLE(ha) ? *req->out_ptr :
-		    rd_reg_dword_relaxed(req->req_q_out);
+		if (IS_SHADOW_REG_CAPABLE(ha)) {
+			cnt = *req->out_ptr;
+		} else {
+			cnt = rd_reg_dword_relaxed(req->req_q_out);
+			if (qla2x00_check_reg16_for_disconnect(vha, cnt))
+				goto queuing_error;
+		}
 
 		if (req->ring_index < cnt)
 			req->cnt = cnt - req->ring_index;
@@ -536,6 +541,7 @@ static inline int qla2x00_start_nvme_mq(srb_t *sp)
 
 queuing_error:
 	spin_unlock_irqrestore(&qpair->qp_lock, flags);
+
 	return rval;
 }
 
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 6a57399b515f..b3888a5c4e3c 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -971,6 +971,13 @@ qla2xxx_mqueuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd,
 		goto qc24_fail_command;
 	}
 
+	if (!qpair->online) {
+		ql_dbg(ql_dbg_io, vha, 0x3077,
+		       "qpair not online. eeh_busy=%d.\n", ha->flags.eeh_busy);
+		cmd->result = DID_NO_CONNECT << 16;
+		goto qc24_fail_command;
+	}
+
 	if (!fcport || fcport->deleted) {
 		cmd->result = DID_IMM_RETRY << 16;
 		goto qc24_fail_command;
@@ -1200,35 +1207,6 @@ qla2x00_wait_for_chip_reset(scsi_qla_host_t *vha)
 	return return_status;
 }
 
-#define ISP_REG_DISCONNECT 0xffffffffU
-/**************************************************************************
-* qla2x00_isp_reg_stat
-*
-* Description:
-*	Read the host status register of ISP before aborting the command.
-*
-* Input:
-*	ha = pointer to host adapter structure.
-*
-*
-* Returns:
-*	Either true or false.
-*
-* Note:	Return true if there is register disconnect.
-**************************************************************************/
-static inline
-uint32_t qla2x00_isp_reg_stat(struct qla_hw_data *ha)
-{
-	struct device_reg_24xx __iomem *reg = &ha->iobase->isp24;
-	struct device_reg_82xx __iomem *reg82 = &ha->iobase->isp82;
-
-	if (IS_P3P_TYPE(ha))
-		return ((rd_reg_dword(&reg82->host_int)) == ISP_REG_DISCONNECT);
-	else
-		return ((rd_reg_dword(&reg->host_status)) ==
-			ISP_REG_DISCONNECT);
-}
-
 /**************************************************************************
 * qla2xxx_eh_abort
 *
@@ -1262,6 +1240,7 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
 	if (qla2x00_isp_reg_stat(ha)) {
 		ql_log(ql_log_info, vha, 0x8042,
 		    "PCI/Register disconnect, exiting.\n");
+		qla_pci_set_eeh_busy(vha);
 		return FAILED;
 	}
 
@@ -1455,6 +1434,7 @@ qla2xxx_eh_device_reset(struct scsi_cmnd *cmd)
 	if (qla2x00_isp_reg_stat(ha)) {
 		ql_log(ql_log_info, vha, 0x803e,
 		    "PCI/Register disconnect, exiting.\n");
+		qla_pci_set_eeh_busy(vha);
 		return FAILED;
 	}
 
@@ -1471,6 +1451,7 @@ qla2xxx_eh_target_reset(struct scsi_cmnd *cmd)
 	if (qla2x00_isp_reg_stat(ha)) {
 		ql_log(ql_log_info, vha, 0x803f,
 		    "PCI/Register disconnect, exiting.\n");
+		qla_pci_set_eeh_busy(vha);
 		return FAILED;
 	}
 
@@ -1506,6 +1487,7 @@ qla2xxx_eh_bus_reset(struct scsi_cmnd *cmd)
 	if (qla2x00_isp_reg_stat(ha)) {
 		ql_log(ql_log_info, vha, 0x8040,
 		    "PCI/Register disconnect, exiting.\n");
+		qla_pci_set_eeh_busy(vha);
 		return FAILED;
 	}
 
@@ -1583,7 +1565,7 @@ qla2xxx_eh_host_reset(struct scsi_cmnd *cmd)
 	if (qla2x00_isp_reg_stat(ha)) {
 		ql_log(ql_log_info, vha, 0x8041,
 		    "PCI/Register disconnect, exiting.\n");
-		schedule_work(&ha->board_disable);
+		qla_pci_set_eeh_busy(vha);
 		return SUCCESS;
 	}
 
@@ -6669,6 +6651,9 @@ qla2x00_do_dpc(void *data)
 
 		schedule();
 
+		if (test_and_clear_bit(DO_EEH_RECOVERY, &base_vha->dpc_flags))
+			qla_pci_set_eeh_busy(base_vha);
+
 		if (!base_vha->flags.init_done || ha->flags.mbox_busy)
 			goto end_loop;
 
@@ -7385,6 +7370,8 @@ static void qla_pci_error_cleanup(scsi_qla_host_t *vha)
 	int i;
 	unsigned long flags;
 
+	ql_dbg(ql_dbg_aer, vha, 0x9000,
+	       "%s\n", __func__);
 	ha->chip_reset++;
 
 	ha->base_qpair->chip_reset = ha->chip_reset;
@@ -7394,28 +7381,16 @@ static void qla_pci_error_cleanup(scsi_qla_host_t *vha)
 			    ha->base_qpair->chip_reset;
 	}
 
-	/* purge MBox commands */
-	if (atomic_read(&ha->num_pend_mbx_stage3)) {
-		clear_bit(MBX_INTR_WAIT, &ha->mbx_cmd_flags);
-		complete(&ha->mbx_intr_comp);
-	}
-
-	i = 0;
-
-	while (atomic_read(&ha->num_pend_mbx_stage3) ||
-	    atomic_read(&ha->num_pend_mbx_stage2) ||
-	    atomic_read(&ha->num_pend_mbx_stage1)) {
-		msleep(20);
-		i++;
-		if (i > 50)
-			break;
-	}
-
-	ha->flags.purge_mbox = 0;
+	/*
+	 * purge mailbox might take a while. Slot Reset/chip reset
+	 * will take care of the purge
+	 */
 
 	mutex_lock(&ha->mq_lock);
+	ha->base_qpair->online = 0;
 	list_for_each_entry(qpair, &base_vha->qp_list, qp_list_elem)
 		qpair->online = 0;
+	wmb();
 	mutex_unlock(&ha->mq_lock);
 
 	qla2x00_mark_all_devices_lost(vha);
@@ -7452,14 +7427,17 @@ qla2xxx_pci_error_detected(struct pci_dev *pdev, pci_channel_state_t state)
 {
 	scsi_qla_host_t *vha = pci_get_drvdata(pdev);
 	struct qla_hw_data *ha = vha->hw;
+	pci_ers_result_t ret = PCI_ERS_RESULT_NEED_RESET;
 
-	ql_dbg(ql_dbg_aer, vha, 0x9000,
-	    "PCI error detected, state %x.\n", state);
+	ql_log(ql_log_warn, vha, 0x9000,
+	       "PCI error detected, state %x.\n", state);
+	ha->pci_error_state = QLA_PCI_ERR_DETECTED;
 
 	if (!atomic_read(&pdev->enable_cnt)) {
 		ql_log(ql_log_info, vha, 0xffff,
 			"PCI device is disabled,state %x\n", state);
-		return PCI_ERS_RESULT_NEED_RESET;
+		ret = PCI_ERS_RESULT_NEED_RESET;
+		goto out;
 	}
 
 	switch (state) {
@@ -7469,11 +7447,12 @@ qla2xxx_pci_error_detected(struct pci_dev *pdev, pci_channel_state_t state)
 			set_bit(QPAIR_ONLINE_CHECK_NEEDED, &vha->dpc_flags);
 			qla2xxx_wake_dpc(vha);
 		}
-		return PCI_ERS_RESULT_CAN_RECOVER;
+		ret = PCI_ERS_RESULT_CAN_RECOVER;
+		break;
 	case pci_channel_io_frozen:
-		ha->flags.eeh_busy = 1;
-		qla_pci_error_cleanup(vha);
-		return PCI_ERS_RESULT_NEED_RESET;
+		qla_pci_set_eeh_busy(vha);
+		ret = PCI_ERS_RESULT_NEED_RESET;
+		break;
 	case pci_channel_io_perm_failure:
 		ha->flags.pci_channel_io_perm_failure = 1;
 		qla2x00_abort_all_cmds(vha, DID_NO_CONNECT << 16);
@@ -7481,9 +7460,12 @@ qla2xxx_pci_error_detected(struct pci_dev *pdev, pci_channel_state_t state)
 			set_bit(QPAIR_ONLINE_CHECK_NEEDED, &vha->dpc_flags);
 			qla2xxx_wake_dpc(vha);
 		}
-		return PCI_ERS_RESULT_DISCONNECT;
+		ret = PCI_ERS_RESULT_DISCONNECT;
 	}
-	return PCI_ERS_RESULT_NEED_RESET;
+out:
+	ql_dbg(ql_dbg_aer, vha, 0x600d,
+	       "PCI error detected returning [%x].\n", ret);
+	return ret;
 }
 
 static pci_ers_result_t
@@ -7497,6 +7479,10 @@ qla2xxx_pci_mmio_enabled(struct pci_dev *pdev)
 	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
 	struct device_reg_24xx __iomem *reg24 = &ha->iobase->isp24;
 
+	ql_log(ql_log_warn, base_vha, 0x9000,
+	       "mmio enabled\n");
+
+	ha->pci_error_state = QLA_PCI_MMIO_ENABLED;
 	if (IS_QLA82XX(ha))
 		return PCI_ERS_RESULT_RECOVERED;
 
@@ -7520,10 +7506,11 @@ qla2xxx_pci_mmio_enabled(struct pci_dev *pdev)
 		ql_log(ql_log_info, base_vha, 0x9003,
 		    "RISC paused -- mmio_enabled, Dumping firmware.\n");
 		qla2xxx_dump_fw(base_vha);
-
-		return PCI_ERS_RESULT_NEED_RESET;
-	} else
-		return PCI_ERS_RESULT_RECOVERED;
+	}
+	/* set PCI_ERS_RESULT_NEED_RESET to trigger call to qla2xxx_pci_slot_reset */
+	ql_dbg(ql_dbg_aer, base_vha, 0x600d,
+	       "mmio enabled returning.\n");
+	return PCI_ERS_RESULT_NEED_RESET;
 }
 
 static pci_ers_result_t
@@ -7535,9 +7522,10 @@ qla2xxx_pci_slot_reset(struct pci_dev *pdev)
 	int rc;
 	struct qla_qpair *qpair = NULL;
 
-	ql_dbg(ql_dbg_aer, base_vha, 0x9004,
-	    "Slot Reset.\n");
+	ql_log(ql_log_warn, base_vha, 0x9004,
+	       "Slot Reset.\n");
 
+	ha->pci_error_state = QLA_PCI_SLOT_RESET;
 	/* Workaround: qla2xxx driver which access hardware earlier
 	 * needs error state to be pci_channel_io_online.
 	 * Otherwise mailbox command timesout.
@@ -7571,16 +7559,24 @@ qla2xxx_pci_slot_reset(struct pci_dev *pdev)
 		qpair->online = 1;
 	mutex_unlock(&ha->mq_lock);
 
+	ha->flags.eeh_busy = 0;
 	base_vha->flags.online = 1;
 	set_bit(ABORT_ISP_ACTIVE, &base_vha->dpc_flags);
-	if (ha->isp_ops->abort_isp(base_vha) == QLA_SUCCESS)
-		ret =  PCI_ERS_RESULT_RECOVERED;
+	ha->isp_ops->abort_isp(base_vha);
 	clear_bit(ABORT_ISP_ACTIVE, &base_vha->dpc_flags);
 
+	if (qla2x00_isp_reg_stat(ha)) {
+		ha->flags.eeh_busy = 1;
+		qla_pci_error_cleanup(base_vha);
+		ql_log(ql_log_warn, base_vha, 0x9005,
+		       "Device unable to recover from PCI error.\n");
+	} else {
+		ret =  PCI_ERS_RESULT_RECOVERED;
+	}
 
 exit_slot_reset:
 	ql_dbg(ql_dbg_aer, base_vha, 0x900e,
-	    "slot_reset return %x.\n", ret);
+	    "Slot Reset returning %x.\n", ret);
 
 	return ret;
 }
@@ -7592,16 +7588,55 @@ qla2xxx_pci_resume(struct pci_dev *pdev)
 	struct qla_hw_data *ha = base_vha->hw;
 	int ret;
 
-	ql_dbg(ql_dbg_aer, base_vha, 0x900f,
-	    "pci_resume.\n");
+	ql_log(ql_log_warn, base_vha, 0x900f,
+	       "Pci Resume.\n");
 
-	ha->flags.eeh_busy = 0;
 
 	ret = qla2x00_wait_for_hba_online(base_vha);
 	if (ret != QLA_SUCCESS) {
 		ql_log(ql_log_fatal, base_vha, 0x9002,
 		    "The device failed to resume I/O from slot/link_reset.\n");
 	}
+	ha->pci_error_state = QLA_PCI_RESUME;
+	ql_dbg(ql_dbg_aer, base_vha, 0x600d,
+	       "Pci Resume returning.\n");
+}
+
+void qla_pci_set_eeh_busy(struct scsi_qla_host *vha)
+{
+	struct qla_hw_data *ha = vha->hw;
+	struct scsi_qla_host *base_vha = pci_get_drvdata(ha->pdev);
+	bool do_cleanup = false;
+	unsigned long flags;
+
+	if (ha->flags.eeh_busy)
+		return;
+
+	spin_lock_irqsave(&base_vha->work_lock, flags);
+	if (!ha->flags.eeh_busy) {
+		ha->flags.eeh_busy = 1;
+		do_cleanup = true;
+	}
+	spin_unlock_irqrestore(&base_vha->work_lock, flags);
+
+	if (do_cleanup)
+		qla_pci_error_cleanup(base_vha);
+}
+
+/*
+ * this routine will schedule a task to pause IO from interrupt context
+ * if caller sees a PCIE error event (register read = 0xf's)
+ */
+void qla_schedule_eeh_work(struct scsi_qla_host *vha)
+{
+	struct qla_hw_data *ha = vha->hw;
+	struct scsi_qla_host *base_vha = pci_get_drvdata(ha->pdev);
+
+	if (ha->flags.eeh_busy)
+		return;
+
+	set_bit(DO_EEH_RECOVERY, &base_vha->dpc_flags);
+	qla2xxx_wake_dpc(base_vha);
 }
 
 static void
-- 
2.19.0.rc0


Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B133AC433B4
	for <linux-scsi@archiver.kernel.org>; Fri,  7 May 2021 13:25:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3A34E61443
	for <linux-scsi@archiver.kernel.org>; Fri,  7 May 2021 13:25:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237248AbhEGN0g (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 7 May 2021 09:26:36 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:45122 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230499AbhEGN0f (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 7 May 2021 09:26:35 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 147DJqnZ030573
        for <linux-scsi@vger.kernel.org>; Fri, 7 May 2021 06:25:35 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=PfTw3n5kp9X3muiIssJQbVO+y8GdOeFnUEOlb8Ohwf0=;
 b=DM3PCivapXvyBpcub3aI4JUYXmM2kS4P2Lk5IryoCAeJ/boAk1yxbcW8JtmM/+C9EJOq
 +qoDVLR9usgVqlcOQbnWuasv2+4l/tyo7V23YBwB2TYmjsCZHjYg3ILdYhypDqguKoU4
 7nOQkI16Gkx86MJwZ6QFVuQOSog79nGNm9QfGdJjMU+vtwRmyqBtmzc2hWtRZti4YT06
 EiEoKFdqGhc7PLhn1Kd46EiT4sJu5kApIEVWU2t8X1lS5gKfLb3KAv/rW4+nswajdO+G
 DAw1dhr9QfHPhB5Q6vAMU7vJrLS8/V6Qljiz2XWSd2Ncyk8rgFIjBAFOE08OcY11fFp0 WA== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 38csptjb9p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Fri, 07 May 2021 06:25:33 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 7 May
 2021 06:25:30 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 7 May 2021 06:25:30 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 3FC805B6942;
        Fri,  7 May 2021 06:25:30 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 147DPU9P014135;
        Fri, 7 May 2021 06:25:30 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 147DPTbl014134;
        Fri, 7 May 2021 06:25:29 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH 1/1] qla2xxx: Add EDIF support
Date:   Fri, 7 May 2021 06:25:05 -0700
Message-ID: <20210507132505.14100-1-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: gKFdi1amVcOqgl6oT-6m_t2a8JHQwcD_
X-Proofpoint-GUID: gKFdi1amVcOqgl6oT-6m_t2a8JHQwcD_
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-07_04:2021-05-06,2021-05-07 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

Add Encryption for Data In Flight (EDIF) support. This feature allows
data of 2 end points to be encrypted. A user application is required
to play the role of authentication for both sides. On completion of
authentication, user app shall provide a set of Tx/Rx keys and spi's
for HW to program into the session.

modprobe qla2xxx ql2xsecenable=1

Signed-off-by: Larry Wisneski <Larry.Wisneski@marvell.com>
Signed-off-by: Duane Grigsby <duane.grigsby@marvell.com>
Signed-off-by: Rick Hicksted Jr <rhicksted@marvell.com>
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/Makefile       |    3 +-
 drivers/scsi/qla2xxx/qla_attr.c     |    6 +-
 drivers/scsi/qla2xxx/qla_bsg.c      |   95 +-
 drivers/scsi/qla2xxx/qla_bsg.h      |    3 +
 drivers/scsi/qla2xxx/qla_dbg.h      |    1 +
 drivers/scsi/qla2xxx/qla_def.h      |  250 +-
 drivers/scsi/qla2xxx/qla_edif.c     | 3638 +++++++++++++++++++++++++++
 drivers/scsi/qla2xxx/qla_edif.h     |  160 ++
 drivers/scsi/qla2xxx/qla_edif_bsg.h |  225 ++
 drivers/scsi/qla2xxx/qla_fw.h       |   15 +-
 drivers/scsi/qla2xxx/qla_gbl.h      |   64 +-
 drivers/scsi/qla2xxx/qla_gs.c       |    4 +
 drivers/scsi/qla2xxx/qla_init.c     |  183 +-
 drivers/scsi/qla2xxx/qla_iocb.c     |   85 +-
 drivers/scsi/qla2xxx/qla_isr.c      |  313 ++-
 drivers/scsi/qla2xxx/qla_mbx.c      |   45 +-
 drivers/scsi/qla2xxx/qla_mid.c      |    7 +-
 drivers/scsi/qla2xxx/qla_nvme.c     |    4 +
 drivers/scsi/qla2xxx/qla_os.c       |  123 +-
 drivers/scsi/qla2xxx/qla_target.c   |  170 +-
 drivers/scsi/qla2xxx/qla_target.h   |   22 +-
 21 files changed, 5254 insertions(+), 162 deletions(-)
 create mode 100644 drivers/scsi/qla2xxx/qla_edif.c
 create mode 100644 drivers/scsi/qla2xxx/qla_edif.h
 create mode 100644 drivers/scsi/qla2xxx/qla_edif_bsg.h

diff --git a/drivers/scsi/qla2xxx/Makefile b/drivers/scsi/qla2xxx/Makefile
index 17d5bc1cc56b..cbc1303e761e 100644
--- a/drivers/scsi/qla2xxx/Makefile
+++ b/drivers/scsi/qla2xxx/Makefile
@@ -1,7 +1,8 @@
 # SPDX-License-Identifier: GPL-2.0
 qla2xxx-y := qla_os.o qla_init.o qla_mbx.o qla_iocb.o qla_isr.o qla_gs.o \
 		qla_dbg.o qla_sup.o qla_attr.o qla_mid.o qla_dfs.o qla_bsg.o \
-		qla_nx.o qla_mr.o qla_nx2.o qla_target.o qla_tmpl.o qla_nvme.o
+		qla_nx.o qla_mr.o qla_nx2.o qla_target.o qla_tmpl.o qla_nvme.o \
+		qla_edif.o
 
 obj-$(CONFIG_SCSI_QLA_FC) += qla2xxx.o
 obj-$(CONFIG_TCM_QLA2XXX) += tcm_qla2xxx.o
diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 3aa9869f6fae..2b88bac3a68c 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -2435,6 +2435,7 @@ static DEVICE_ATTR(port_speed, 0644, qla2x00_port_speed_show,
     qla2x00_port_speed_store);
 static DEVICE_ATTR(port_no, 0444, qla2x00_port_no_show, NULL);
 static DEVICE_ATTR(fw_attr, 0444, qla2x00_fw_attr_show, NULL);
+static DEVICE_ATTR_RO(edif_doorbell);
 
 
 struct device_attribute *qla2x00_host_attrs[] = {
@@ -2480,6 +2481,7 @@ struct device_attribute *qla2x00_host_attrs[] = {
 	&dev_attr_port_no,
 	&dev_attr_fw_attr,
 	&dev_attr_dport_diagnostics,
+	&dev_attr_edif_doorbell,
 	NULL, /* reserve for qlini_mode */
 	NULL, /* reserve for ql2xiniexchg */
 	NULL, /* reserve for ql2xexchoffld */
@@ -3104,9 +3106,11 @@ qla24xx_vport_delete(struct fc_vport *fc_vport)
 
 
 	qla24xx_disable_vp(vha);
-	qla2x00_wait_for_sess_deletion(vha);
 
 	qla_nvme_delete(vha);
+	qla_enode_stop(vha);
+	qla_edb_stop(vha);
+
 	vha->flags.delete_progress = 1;
 
 	qlt_remove_target(ha, vha);
diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index d42b2ad84049..a885e48607f1 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -27,6 +27,10 @@ void qla2x00_bsg_job_done(srb_t *sp, int res)
 
 	sp->free(sp);
 
+	ql_dbg(ql_dbg_user, sp->vha, 0x7009,
+	    "%s: sp hdl %x, result=%x bsg ptr %p\n",
+	    __func__, sp->handle, res, bsg_job);
+
 	bsg_reply->result = res;
 	bsg_job_done(bsg_job, bsg_reply->result,
 		       bsg_reply->reply_payload_rcv_len);
@@ -53,11 +57,19 @@ void qla2x00_bsg_sp_free(srb_t *sp)
 			    bsg_job->reply_payload.sg_list,
 			    bsg_job->reply_payload.sg_cnt, DMA_FROM_DEVICE);
 	} else {
-		dma_unmap_sg(&ha->pdev->dev, bsg_job->request_payload.sg_list,
-		    bsg_job->request_payload.sg_cnt, DMA_TO_DEVICE);
 
-		dma_unmap_sg(&ha->pdev->dev, bsg_job->reply_payload.sg_list,
-		    bsg_job->reply_payload.sg_cnt, DMA_FROM_DEVICE);
+		if (sp->remap.remapped) {
+			dma_pool_free(ha->purex_dma_pool, sp->remap.rsp.buf,
+			    sp->remap.rsp.dma);
+			dma_pool_free(ha->purex_dma_pool, sp->remap.req.buf,
+			    sp->remap.req.dma);
+		} else {
+			dma_unmap_sg(&ha->pdev->dev, bsg_job->request_payload.sg_list,
+				bsg_job->request_payload.sg_cnt, DMA_TO_DEVICE);
+
+			dma_unmap_sg(&ha->pdev->dev, bsg_job->reply_payload.sg_list,
+				bsg_job->reply_payload.sg_cnt, DMA_FROM_DEVICE);
+		}
 	}
 
 	if (sp->type == SRB_CT_CMD ||
@@ -266,6 +278,7 @@ qla2x00_process_els(struct bsg_job *bsg_job)
 	int req_sg_cnt, rsp_sg_cnt;
 	int rval =  (DID_ERROR << 16);
 	uint16_t nextlid = 0;
+	uint32_t els_cmd = 0;
 
 	if (bsg_request->msgcode == FC_BSG_RPT_ELS) {
 		rport = fc_bsg_to_rport(bsg_job);
@@ -279,6 +292,9 @@ qla2x00_process_els(struct bsg_job *bsg_job)
 		vha = shost_priv(host);
 		ha = vha->hw;
 		type = "FC_BSG_HST_ELS_NOLOGIN";
+		els_cmd = bsg_request->rqst_data.h_els.command_code;
+		if (els_cmd == ELS_AUTH_ELS)
+			return qla_edif_process_els(vha, bsg_job);
 	}
 
 	if (!vha->flags.online) {
@@ -297,7 +313,7 @@ qla2x00_process_els(struct bsg_job *bsg_job)
 
 	/*  Multiple SG's are not supported for ELS requests */
 	if (bsg_job->request_payload.sg_cnt > 1 ||
-		bsg_job->reply_payload.sg_cnt > 1) {
+	    bsg_job->reply_payload.sg_cnt > 1) {
 		ql_dbg(ql_dbg_user, vha, 0x7002,
 		    "Multiple SG's are not supported for ELS requests, "
 		    "request_sg_cnt=%x reply_sg_cnt=%x.\n",
@@ -356,7 +372,7 @@ qla2x00_process_els(struct bsg_job *bsg_job)
 
 	rsp_sg_cnt = dma_map_sg(&ha->pdev->dev, bsg_job->reply_payload.sg_list,
 		bsg_job->reply_payload.sg_cnt, DMA_FROM_DEVICE);
-        if (!rsp_sg_cnt) {
+	if (!rsp_sg_cnt) {
 		dma_unmap_sg(&ha->pdev->dev, bsg_job->reply_payload.sg_list,
 		    bsg_job->reply_payload.sg_cnt, DMA_FROM_DEVICE);
 		rval = -ENOMEM;
@@ -373,7 +389,6 @@ qla2x00_process_els(struct bsg_job *bsg_job)
 		rval = -EAGAIN;
 		goto done_unmap_sg;
 	}
-
 	/* Alloc SRB structure */
 	sp = qla2x00_get_sp(vha, fcport, GFP_KERNEL);
 	if (!sp) {
@@ -2768,10 +2783,13 @@ qla2x00_manage_host_port(struct bsg_job *bsg_job)
 }
 
 static int
-qla2x00_process_vendor_specific(struct bsg_job *bsg_job)
+qla2x00_process_vendor_specific(struct scsi_qla_host *vha, struct bsg_job *bsg_job)
 {
 	struct fc_bsg_request *bsg_request = bsg_job->request;
 
+	ql_dbg(ql_dbg_edif, vha, 0x911b, "%s FC_BSG_HST_VENDOR cmd[0]=0x%x\n",
+	    __func__, bsg_request->rqst_data.h_vendor.vendor_cmd[0]);
+
 	switch (bsg_request->rqst_data.h_vendor.vendor_cmd[0]) {
 	case QL_VND_LOOPBACK:
 		return qla2x00_process_loopback(bsg_job);
@@ -2840,6 +2858,9 @@ qla2x00_process_vendor_specific(struct bsg_job *bsg_job)
 	case QL_VND_DPORT_DIAGNOSTICS:
 		return qla2x00_do_dport_diagnostics(bsg_job);
 
+	case QL_VND_EDIF_MGMT:
+		return qla_edif_app_mgmt(bsg_job);
+
 	case QL_VND_SS_GET_FLASH_IMAGE_STATUS:
 		return qla2x00_get_flash_image_status(bsg_job);
 
@@ -2897,12 +2918,19 @@ qla24xx_bsg_request(struct bsg_job *bsg_job)
 		ql_dbg(ql_dbg_user, vha, 0x709f,
 		    "BSG: ISP abort active/needed -- cmd=%d.\n",
 		    bsg_request->msgcode);
+		SET_DID_STATUS(bsg_reply->result, DID_ERROR);
 		return -EBUSY;
 	}
 
+	if (test_bit(PFLG_DRIVER_REMOVING, &vha->pci_flags)) {
+		SET_DID_STATUS(bsg_reply->result, DID_ERROR);
+		return -EIO;
+	}
+
 skip_chip_chk:
-	ql_dbg(ql_dbg_user, vha, 0x7000,
-	    "Entered %s msgcode=0x%x.\n", __func__, bsg_request->msgcode);
+	ql_dbg(ql_dbg_user + ql_dbg_verbose, vha, 0x7000,
+	    "Entered %s msgcode=0x%x. bsg ptr %px\n",
+	    __func__, bsg_request->msgcode, bsg_job);
 
 	switch (bsg_request->msgcode) {
 	case FC_BSG_RPT_ELS:
@@ -2913,7 +2941,7 @@ qla24xx_bsg_request(struct bsg_job *bsg_job)
 		ret = qla2x00_process_ct(bsg_job);
 		break;
 	case FC_BSG_HST_VENDOR:
-		ret = qla2x00_process_vendor_specific(bsg_job);
+		ret = qla2x00_process_vendor_specific(vha, bsg_job);
 		break;
 	case FC_BSG_HST_ADD_RPORT:
 	case FC_BSG_HST_DEL_RPORT:
@@ -2922,6 +2950,10 @@ qla24xx_bsg_request(struct bsg_job *bsg_job)
 		ql_log(ql_log_warn, vha, 0x705a, "Unsupported BSG request.\n");
 		break;
 	}
+
+	ql_dbg(ql_dbg_user + ql_dbg_verbose, vha, 0x7000,
+	    "%s done with return %x\n", __func__, ret);
+
 	return ret;
 }
 
@@ -2936,6 +2968,8 @@ qla24xx_bsg_timeout(struct bsg_job *bsg_job)
 	unsigned long flags;
 	struct req_que *req;
 
+	ql_log(ql_log_info, vha, 0x708b, "%s CMD timeout. bsg ptr %p.\n",
+	    __func__, bsg_job);
 	/* find the bsg job from the active list of commands */
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 	for (que = 0; que < ha->max_req_queues; que++) {
@@ -2945,27 +2979,26 @@ qla24xx_bsg_timeout(struct bsg_job *bsg_job)
 
 		for (cnt = 1; cnt < req->num_outstanding_cmds; cnt++) {
 			sp = req->outstanding_cmds[cnt];
-			if (sp) {
-				if (((sp->type == SRB_CT_CMD) ||
-					(sp->type == SRB_ELS_CMD_HST) ||
-					(sp->type == SRB_FXIOCB_BCMD))
-					&& (sp->u.bsg_job == bsg_job)) {
-					req->outstanding_cmds[cnt] = NULL;
-					spin_unlock_irqrestore(&ha->hardware_lock, flags);
-					if (ha->isp_ops->abort_command(sp)) {
-						ql_log(ql_log_warn, vha, 0x7089,
-						    "mbx abort_command "
-						    "failed.\n");
-						bsg_reply->result = -EIO;
-					} else {
-						ql_dbg(ql_dbg_user, vha, 0x708a,
-						    "mbx abort_command "
-						    "success.\n");
-						bsg_reply->result = 0;
-					}
-					spin_lock_irqsave(&ha->hardware_lock, flags);
-					goto done;
+			if (sp &&
+			    (sp->type == SRB_CT_CMD ||
+			     sp->type == SRB_ELS_CMD_HST ||
+			     sp->type == SRB_ELS_CMD_HST_NOLOGIN ||
+			     sp->type == SRB_FXIOCB_BCMD) &&
+			    sp->u.bsg_job == bsg_job) {
+				req->outstanding_cmds[cnt] = NULL;
+				spin_unlock_irqrestore(&ha->hardware_lock, flags);
+				if (ha->isp_ops->abort_command(sp)) {
+					ql_log(ql_log_warn, vha, 0x7089,
+					    "mbx abort_command failed.\n");
+					bsg_reply->result = -EIO;
+				} else {
+					ql_dbg(ql_dbg_user, vha, 0x708a,
+					    "mbx abort_command success.\n");
+					bsg_reply->result = 0;
 				}
+				spin_lock_irqsave(&ha->hardware_lock, flags);
+				goto done;
+
 			}
 		}
 	}
diff --git a/drivers/scsi/qla2xxx/qla_bsg.h b/drivers/scsi/qla2xxx/qla_bsg.h
index 0274e99e4a12..dd793cf8bc1e 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.h
+++ b/drivers/scsi/qla2xxx/qla_bsg.h
@@ -31,6 +31,7 @@
 #define QL_VND_DPORT_DIAGNOSTICS	0x19
 #define QL_VND_GET_PRIV_STATS_EX	0x1A
 #define QL_VND_SS_GET_FLASH_IMAGE_STATUS	0x1E
+#define QL_VND_EDIF_MGMT                0X1F
 #define QL_VND_MANAGE_HOST_STATS	0x23
 #define QL_VND_GET_HOST_STATS		0x24
 #define QL_VND_GET_TGT_STATS		0x25
@@ -294,4 +295,6 @@ struct qla_active_regions {
 	uint8_t reserved[32];
 } __packed;
 
+#include "qla_edif_bsg.h"
+
 #endif
diff --git a/drivers/scsi/qla2xxx/qla_dbg.h b/drivers/scsi/qla2xxx/qla_dbg.h
index 9eb708e5e22e..f1f6c740bdcd 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.h
+++ b/drivers/scsi/qla2xxx/qla_dbg.h
@@ -367,6 +367,7 @@ ql_log_qp(uint32_t, struct qla_qpair *, int32_t, const char *fmt, ...);
 #define ql_dbg_tgt_mgt	0x00002000 /* Target mode management */
 #define ql_dbg_tgt_tmr	0x00001000 /* Target mode task management */
 #define ql_dbg_tgt_dif  0x00000800 /* Target mode dif */
+#define ql_dbg_edif	0x00000400 /* edif and purex debug */
 
 extern int qla27xx_dump_mpi_ram(struct qla_hw_data *, uint32_t, uint32_t *,
 	uint32_t, void **);
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index def4d99f80e9..6edb8c83980b 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -33,6 +33,7 @@
 #include <scsi/scsi_transport_fc.h>
 #include <scsi/scsi_bsg_fc.h>
 
+#include <uapi/scsi/fc/fc_fs.h>
 #include <uapi/scsi/fc/fc_els.h>
 
 /* Big endian Fibre Channel S_ID (source ID) or D_ID (destination ID). */
@@ -49,11 +50,45 @@ typedef struct {
 	uint8_t domain;
 } le_id_t;
 
+/*
+ * 24 bit port ID type definition.
+ */
+typedef union {
+	uint32_t b24 : 24;
+	struct {
+#ifdef __BIG_ENDIAN
+		uint8_t domain;
+		uint8_t area;
+		uint8_t al_pa;
+#elif defined(__LITTLE_ENDIAN)
+		uint8_t al_pa;
+		uint8_t area;
+		uint8_t domain;
+#else
+#error "__BIG_ENDIAN or __LITTLE_ENDIAN must be defined!"
+#endif
+		uint8_t rsvd_1;
+	} b;
+} port_id_t;
+#define INVALID_PORT_ID	0xFFFFFF
+
 #include "qla_bsg.h"
 #include "qla_dsd.h"
 #include "qla_nx.h"
 #include "qla_nx2.h"
 #include "qla_nvme.h"
+
+struct auth_els_header {
+	uint8_t         els_code;
+	uint8_t         els_flags;
+	uint8_t         message_code;
+	uint8_t         protocol_version;
+#define AUTH_ELS_PROTOCOL_VERSION   2
+	uint32_t        message_length;
+	uint32_t        transaction_identifier;
+	uint8_t         payload[0];                 /* payload for cmd */
+} __packed;
+
 #define QLA2XXX_DRIVER_NAME	"qla2xxx"
 #define QLA2XXX_APIDEV		"ql2xapidev"
 #define QLA2XXX_MANUFACTURER	"QLogic Corporation"
@@ -319,6 +354,13 @@ struct name_list_extended {
 	u32			size;
 	u8			sent;
 };
+
+struct els_reject {
+	struct fc_els_ls_rjt *c;
+	dma_addr_t  cdma;
+	u16 size;
+};
+
 /*
  * Timeout timer counts in seconds
  */
@@ -345,6 +387,8 @@ struct name_list_extended {
 #define FW_MAX_EXCHANGES_CNT (32 * 1024)
 #define REDUCE_EXCHANGES_CNT  (8 * 1024)
 
+#define SET_DID_STATUS(stat_var, status) (stat_var = status << 16)
+
 struct req_que;
 struct qla_tgt_sess;
 
@@ -370,33 +414,13 @@ struct srb_cmd {
 #define SRB_CRC_CTX_DSD_VALID		BIT_5	/* DIF: dsd_list valid */
 #define SRB_WAKEUP_ON_COMP		BIT_6
 #define SRB_DIF_BUNDL_DMA_VALID		BIT_7   /* DIF: DMA list valid */
+#define SRB_EDIF_CLEANUP_DELETE		BIT_9
 
 /* To identify if a srb is of T10-CRC type. @sp => srb_t pointer */
 #define IS_PROT_IO(sp)	(sp->flags & SRB_CRC_CTX_DSD_VALID)
-
-/*
- * 24 bit port ID type definition.
- */
-typedef union {
-	uint32_t b24 : 24;
-
-	struct {
-#ifdef __BIG_ENDIAN
-		uint8_t domain;
-		uint8_t area;
-		uint8_t al_pa;
-#elif defined(__LITTLE_ENDIAN)
-		uint8_t al_pa;
-		uint8_t area;
-		uint8_t domain;
-#else
-#error "__BIG_ENDIAN or __LITTLE_ENDIAN must be defined!"
-#endif
-		uint8_t rsvd_1;
-	} b;
-} port_id_t;
-#define INVALID_PORT_ID	0xFFFFFF
 #define ISP_REG16_DISCONNECT 0xFFFF
+/* This sp is an internal delete */
+#define IS_EDIF_CLEANUP_DELETE(sp) (sp->flags & SRB_EDIF_CLEANUP_DELETE)
 
 static inline le_id_t be_id_to_le(be_id_t id)
 {
@@ -483,6 +507,7 @@ struct srb_iocb {
 #define SRB_LOGIN_SKIP_PRLI	BIT_2
 #define SRB_LOGIN_NVME_PRLI	BIT_3
 #define SRB_LOGIN_PRLI_ONLY	BIT_4
+#define SRB_LOGIN_FCSP		BIT_5
 			uint16_t data[2];
 			u32 iop[2];
 		} logio;
@@ -587,6 +612,10 @@ struct srb_iocb {
 			u16 cmd;
 			u16 vp_index;
 		} ctrlvp;
+		struct {
+			struct edif_sa_ctl	*sa_ctl;
+			struct qla_sa_update_frame sa_frame;
+		} sa_update;
 	} u;
 
 	struct timer_list timer;
@@ -617,6 +646,21 @@ struct srb_iocb {
 #define SRB_PRLI_CMD	21
 #define SRB_CTRL_VP	22
 #define SRB_PRLO_CMD	23
+#define SRB_SA_UPDATE	25
+#define SRB_ELS_CMD_HST_NOLOGIN 26
+#define SRB_SA_REPLACE	27
+
+struct qla_els_pt_arg {
+	u8 els_opcode;
+	u8 vp_idx;
+	__le16 nport_handle;
+	u16 control_flags;
+	__le32 rx_xchg_address;
+	port_id_t did;
+	u32 tx_len, tx_byte_count, rx_len, rx_byte_count;
+	dma_addr_t tx_addr, rx_addr;
+
+};
 
 enum {
 	TYPE_SRB,
@@ -630,6 +674,13 @@ struct iocb_resource {
 	u16 iocb_cnt;
 };
 
+struct bsg_cmd {
+	struct bsg_job *bsg_job;
+	union {
+		struct qla_els_pt_arg els_arg;
+	} u;
+};
+
 typedef struct srb {
 	/*
 	 * Do not move cmd_type field, it needs to
@@ -662,7 +713,21 @@ typedef struct srb {
 		struct srb_iocb iocb_cmd;
 		struct bsg_job *bsg_job;
 		struct srb_cmd scmd;
+		struct bsg_cmd bsg_cmd;
 	} u;
+	struct {
+		bool remapped;
+		struct {
+			dma_addr_t dma;
+			void *buf;
+			uint len;
+		} req;
+		struct {
+			dma_addr_t dma;
+			void *buf;
+			uint len;
+		} rsp;
+	} remap;
 	/*
 	 * Report completion status @res and call sp_put(@sp). @res is
 	 * an NVMe status code, a SCSI result (e.g. DID_OK << 16) or a
@@ -2294,6 +2359,7 @@ struct imm_ntfy_from_isp {
 			__le16	nport_handle;
 			uint16_t reserved_2;
 			__le16	flags;
+#define NOTIFY24XX_FLAGS_FCSP		BIT_5
 #define NOTIFY24XX_FLAGS_GLOBAL_TPRLO   BIT_1
 #define NOTIFY24XX_FLAGS_PUREX_IOCB     BIT_0
 			__le16	srr_rx_id;
@@ -2424,6 +2490,7 @@ enum discovery_state {
 	DSC_LOGIN_COMPLETE,
 	DSC_ADISC,
 	DSC_DELETE_PEND,
+	DSC_LOGIN_AUTH_PEND,
 };
 
 enum login_state {	/* FW control Target side */
@@ -2467,6 +2534,8 @@ typedef struct fc_port {
 	unsigned int n2n_flag:1;
 	unsigned int explicit_logout:1;
 	unsigned int prli_pend_timer:1;
+	unsigned int explicit_prlo:1;
+
 	uint8_t nvme_flag;
 
 	uint8_t node_name[WWN_SIZE];
@@ -2510,6 +2579,7 @@ typedef struct fc_port {
 	uint16_t tgt_id;
 	uint16_t old_tgt_id;
 	uint16_t sec_since_registration;
+	uint16_t prlo_rc;
 
 	uint8_t fcp_prio;
 
@@ -2563,6 +2633,62 @@ typedef struct fc_port {
 	u64 tgt_short_link_down_cnt;
 	u64 tgt_link_down_time;
 	u64 dev_loss_tmo;
+#define	TTYPE_PRLI	1
+#define	TTYPE_KSHRED	2
+
+// edif timer types
+#define	EDIF_TICK	1	// timer tick incremental value (seconds)
+#define	EDIF_PRLI_TO	120	// default for prli timeout (seconds)
+#define	EDIF_KSHRED_TO	30	// default for old key shred (seconds)
+#define	EDIF_TO_MIN	25
+#define	EDIF_MAX_SA_SLOTS	2	/* Number of SA slots */
+	/*
+	 * EDIF parameters for encryption.
+	 */
+	struct {
+		uint16_t	enable:1;	// device is edif enabled/req'd
+		uint16_t	new_sa:1;	// new/updated sa needed
+		uint16_t	db_sent:1;	// app notified new sa needed
+		uint16_t	rekey_nocnt:1;	// no byte or time limit
+		uint16_t	rekey_mode:1;	// 1-time based, 0-bytes based
+		uint16_t	app_stop:2;
+#define APP_STOPPED  0
+#define APP_STOPPING 1
+		uint16_t	app_started:1;
+		uint16_t	secured_login:1;
+		uint16_t	aes_gmac:1;
+		uint16_t	app_sess_online:1;
+		uint16_t	rekey_cnt;	// num of times rekeyed
+		uint32_t	login_gen;	// saved count
+		uint32_t	rscn_gen;	// saved rscn cnt
+		uint32_t	prli_to;	// timeout for prli to complete
+		int64_t		reload_value;	// time or bytes; 0=unlimited
+		int64_t		rekey;		// amt left before rekey needed
+		struct timer_list timer;	// prli and shred timer
+		uint8_t		auth_state;	/* cureent auth state */
+		uint8_t		tx_sa_set;
+		uint8_t		rx_sa_set;
+		uint8_t		tx_sa_pending;
+		uint8_t		rx_sa_pending;
+		uint8_t		reserved[3];
+		uint32_t	tx_rekey_cnt;
+		uint32_t	rx_rekey_cnt;
+		uint32_t	tx_sa_selold;	/* Select older SA */
+		uint32_t	rx_sa_selold;
+		uint32_t	stall_io;	/* Stall I/O on this port */
+
+		// delayed rx delete data structure list
+		uint64_t	tx_bytes;
+		uint64_t	rx_bytes;
+		uint8_t		non_secured_login;
+		struct list_head edif_indx_list;
+		spinlock_t  indx_list_lock;  // protects the edif index list
+
+		struct list_head tx_sa_list;
+		struct list_head rx_sa_list;
+		spinlock_t	sa_list_lock;       /* protects list */
+	} edif;
+
 } fc_port_t;
 
 enum {
@@ -2604,7 +2730,8 @@ static const char * const port_dstate_str[] = {
 	"UPD_FCPORT",
 	"LOGIN_COMPLETE",
 	"ADISC",
-	"DELETE_PEND"
+	"DELETE_PEND",
+	"LOGIN_AUTH_PEND",
 };
 
 /*
@@ -2616,6 +2743,8 @@ static const char * const port_dstate_str[] = {
 #define FCF_ASYNC_SENT		BIT_3
 #define FCF_CONF_COMP_SUPPORTED BIT_4
 #define FCF_ASYNC_ACTIVE	BIT_5
+#define FCF_FCSP_DEVICE		BIT_6
+#define FCF_EDIF_DELETE		BIT_7
 
 /* No loop ID flag. */
 #define FC_NO_LOOP_ID		0x1000
@@ -3386,6 +3515,7 @@ enum qla_work_type {
 	QLA_EVT_SP_RETRY,
 	QLA_EVT_IIDMA,
 	QLA_EVT_ELS_PLOGI,
+	QLA_EVT_SA_REPLACE,
 };
 
 
@@ -3444,6 +3574,11 @@ struct qla_work_evt {
 			u8 fc4_type;
 			srb_t *sp;
 		} gpnft;
+		struct {
+			struct edif_sa_ctl	*sa_ctl;
+			fc_port_t *fcport;
+			uint16_t nport_handle;
+		} sa_update;
 	 } u;
 };
 
@@ -3563,6 +3698,8 @@ struct rsp_que {
 	srb_t *status_srb; /* status continuation entry */
 	struct qla_qpair *qpair;
 
+	port_id_t pur_sid;
+	int	pur_entcnt;
 	dma_addr_t  dma_fx00;
 	response_t *ring_fx00;
 	uint16_t  length_fx00;
@@ -3843,7 +3980,9 @@ struct qlt_hw_data {
 	int num_act_qpairs;
 #define DEFAULT_NAQP 2
 	spinlock_t atio_lock ____cacheline_aligned;
-	struct btree_head32 host_map;
+	dma_addr_t fast_dig_dma;
+	char       *fast_dig_ptr;
+	char       *fast_sw_sha;
 };
 
 #define MAX_QFULL_CMDS_ALLOC	8192
@@ -3933,6 +4072,7 @@ struct qla_hw_data {
 		uint32_t	scm_supported_f:1;
 				/* Enabled in Driver */
 		uint32_t	scm_enabled:1;
+		uint32_t	edif_enabled:1;
 		uint32_t	max_req_queue_warned:1;
 		uint32_t	plogi_template_valid:1;
 		uint32_t	port_isolated:1;
@@ -4616,7 +4756,22 @@ struct qla_hw_data {
 
 	struct qla_hw_data_stat stat;
 	pci_error_state_t pci_error_state;
+	unsigned short plogi_commfeat;
+	struct dma_pool *purex_dma_pool;
+	struct btree_head32 host_map;
+
+	#define EDIF_NUM_SA_INDEX	512
+	#define EDIF_TX_SA_INDEX_BASE	EDIF_NUM_SA_INDEX
+	void *edif_rx_sa_id_map;
+	void *edif_tx_sa_id_map;
+	spinlock_t sadb_fp_lock;
+
+	struct list_head sadb_tx_index_list;
+	struct list_head sadb_rx_index_list;
+	spinlock_t sadb_lock;	/* protects list */
+	struct els_reject elsrej;
 };
+#define RX_ELS_SIZE (roundup(sizeof(struct enode) + ELS_MAX_PAYLOAD, SMP_CACHE_BYTES))
 
 struct active_regions {
 	uint8_t global;
@@ -4626,6 +4781,7 @@ struct active_regions {
 		uint8_t npiv_config_0_1;
 		uint8_t npiv_config_2_3;
 	} aux;
+	unsigned short plogi_commfeat;
 };
 
 #define FW_ABILITY_MAX_SPEED_MASK	0xFUL
@@ -4656,6 +4812,8 @@ struct purex_item {
 	} iocb;
 };
 
+#include "qla_edif.h"
+
 #define SCM_FLAG_RDF_REJECT		0x00
 #define SCM_FLAG_RDF_COMPLETED		0x01
 
@@ -4743,6 +4901,7 @@ typedef struct scsi_qla_host {
 #define SET_ZIO_THRESHOLD_NEEDED 32
 #define ISP_ABORT_TO_ROM	33
 #define VPORT_DELETE		34
+#define EDIF_TICK_NEEDED	36
 
 #define PROCESS_PUREX_IOCB	63
 
@@ -4776,6 +4935,8 @@ typedef struct scsi_qla_host {
 	uint8_t         loop_down_abort_time;    /* port down timer */
 	atomic_t        loop_down_timer;         /* loop down timer */
 	uint8_t         link_down_timeout;       /* link down timeout */
+	uint16_t	edif_prli_timeout;
+	uint16_t	edif_kshred_timeout;
 
 	uint32_t        timer_active;
 	struct timer_list        timer;
@@ -4884,6 +5045,8 @@ typedef struct scsi_qla_host {
 	u64 reset_cmd_err_cnt;
 	u64 link_down_time;
 	u64 short_link_down_cnt;
+	struct edif_dbell e_dbell;
+	struct pur_core pur_cinfo;
 } scsi_qla_host_t;
 
 struct qla27xx_image_status {
@@ -5084,6 +5247,43 @@ enum nexus_wait_type {
 	WAIT_LUN,
 };
 
+#define INVALID_EDIF_SA_INDEX	0xffff
+#define RX_DELETE_NO_EDIF_SA_INDEX	0xfffe
+
+#define QLA_SKIP_HANDLE QLA_TGT_SKIP_HANDLE
+
+/* edif hash element */
+struct edif_list_entry {
+	uint16_t handle;			/* nport_handle */
+	uint32_t update_sa_index;
+	uint32_t delete_sa_index;
+	uint32_t count;				/* counter for filtering sa_index */
+#define EDIF_ENTRY_FLAGS_CLEANUP	0x01	/* this index is being cleaned up */
+	uint32_t flags;				/* used by sadb cleanup code */
+	fc_port_t *fcport;			/* needed by rx delay timer function */
+	struct timer_list timer;		/* rx delay timer */
+	struct list_head next;
+};
+
+#define EDIF_TX_INDX_BASE 512
+#define EDIF_RX_INDX_BASE 0
+#define EDIF_RX_DELETE_FILTER_COUNT 3	/* delay queuing rx delete until this many */
+
+/* entry in the sa_index free pool */
+
+struct sa_index_pair {
+	uint16_t sa_index;
+	uint32_t spi;
+};
+
+/* edif sa_index data structure */
+struct edif_sa_index_entry {
+	struct sa_index_pair sa_pair[2];
+	fc_port_t *fcport;
+	uint16_t handle;
+	struct list_head next;
+};
+
 /* Refer to SNIA SFF 8247 */
 struct sff_8247_a0 {
 	u8 txid;	/* transceiver id */
diff --git a/drivers/scsi/qla2xxx/qla_edif.c b/drivers/scsi/qla2xxx/qla_edif.c
new file mode 100644
index 000000000000..52eada5521fa
--- /dev/null
+++ b/drivers/scsi/qla2xxx/qla_edif.c
@@ -0,0 +1,3638 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Marvell Fibre Channel HBA Driver
+ * Copyright (c)  2021     Marvell
+ */
+#include "qla_def.h"
+#include "qla_edif.h"
+
+#include <linux/kthread.h>
+#include <linux/vmalloc.h>
+#include <linux/delay.h>
+#include <scsi/scsi_tcq.h>
+
+static struct edif_sa_index_entry *qla_edif_sadb_find_sa_index_entry(uint16_t nport_handle,
+		struct list_head *sa_list);
+static uint16_t qla_edif_sadb_get_sa_index(fc_port_t *fcport,
+		struct qla_sa_update_frame *sa_frame);
+static int qla_edif_sadb_delete_sa_index(fc_port_t *fcport, uint16_t nport_handle,
+		uint16_t sa_index);
+static int qla_pur_get_pending(scsi_qla_host_t *, fc_port_t *, struct bsg_job *);
+
+struct edb_node {
+	struct  list_head	list;
+	uint32_t		ntype;
+	uint32_t		lstate;
+	union {
+		port_id_t	plogi_did;
+		uint32_t	async;
+		port_id_t	els_sid;
+		struct edif_sa_update_aen	sa_aen;
+	} u;
+};
+
+static struct els_sub_cmd {
+	uint16_t cmd;
+	const char *str;
+} sc_str[] = {
+	{SEND_ELS, "send ELS"},
+	{SEND_ELS_REPLY, "send ELS Reply"},
+	{PULL_ELS, "retrieve ELS"},
+};
+
+const char *sc_to_str(uint16_t cmd)
+{
+	int i;
+	struct els_sub_cmd *e;
+
+	for (i = 0; i < ARRAY_SIZE(sc_str); i++) {
+		e = sc_str + i;
+		if (cmd == e->cmd)
+			return e->str;
+	}
+	return "unknown";
+}
+
+/* find an edif list entry for an nport_handle */
+struct edif_list_entry *qla_edif_list_find_sa_index(fc_port_t *fcport,
+		uint16_t handle)
+{
+	struct edif_list_entry *entry;
+	struct edif_list_entry *tentry;
+	struct list_head *indx_list = &fcport->edif.edif_indx_list;
+
+	list_for_each_entry_safe(entry, tentry, indx_list, next) {
+		if (entry->handle == handle)
+			return entry;
+	}
+	return NULL;
+}
+
+/* timeout called when no traffic and delayed rx sa_index delete */
+static void qla2x00_sa_replace_iocb_timeout(struct timer_list *t)
+{
+	struct edif_list_entry *edif_entry = from_timer(edif_entry, t, timer);
+	fc_port_t *fcport = edif_entry->fcport;
+
+	struct scsi_qla_host *vha = fcport->vha;
+	struct  edif_sa_ctl *sa_ctl;
+	uint16_t nport_handle;
+	unsigned long flags = 0;
+
+	ql_dbg(ql_dbg_edif, vha, 0x3069,
+	    "%s:  nport_handle 0x%x,  SA REPL Delay Timeout, %8phC portid=%06x\n",
+	    __func__, edif_entry->handle, fcport->port_name, fcport->d_id.b24);
+
+	/*
+	 * if delete_sa_index is valid then no one has serviced this
+	 * delayed delete
+	 */
+	spin_lock_irqsave(&fcport->edif.indx_list_lock, flags);
+
+	/*
+	 * delete_sa_index is invalidated when we find the new sa_index in
+	 * the incoming data stream.  If it is not invalidated then we are
+	 * still looking for the new sa_index because there is no I/O and we
+	 * need to just force the rx delete and move on.  Otherwise
+	 * we could get another rekey which will result in an error 66.
+	 */
+	if (edif_entry->delete_sa_index != INVALID_EDIF_SA_INDEX) {
+		uint16_t delete_sa_index = edif_entry->delete_sa_index;
+
+		edif_entry->delete_sa_index = INVALID_EDIF_SA_INDEX;
+		nport_handle = edif_entry->handle;
+		spin_unlock_irqrestore(&fcport->edif.indx_list_lock, flags);
+
+		sa_ctl = qla_edif_find_sa_ctl_by_index(fcport,
+		    delete_sa_index, 0);
+
+		if (sa_ctl) {
+			ql_dbg(ql_dbg_edif, vha, 0x3063,
+	"%s: POST SA DELETE TIMEOUT  sa_ctl: %p, delete index %d, update index: %d, lid: 0x%x\n",
+			    __func__, sa_ctl, delete_sa_index,
+			    edif_entry->update_sa_index, nport_handle);
+
+			sa_ctl->flags = EDIF_SA_CTL_FLG_DEL;
+			set_bit(EDIF_SA_CTL_REPL, &sa_ctl->state);
+			qla_post_sa_replace_work(fcport->vha, fcport,
+			    nport_handle, sa_ctl);
+
+		} else {
+			ql_dbg(ql_dbg_edif, vha, 0x3063,
+	"%s: POST SA DELETE TIMEOUT  sa_ctl not found for delete_sa_index: %d\n",
+			    __func__, edif_entry->delete_sa_index);
+		}
+	} else {
+		spin_unlock_irqrestore(&fcport->edif.indx_list_lock, flags);
+	}
+}
+
+/*
+ * create a new list entry for this nport handle and
+ * add an sa_update index to the list - called for sa_update
+ */
+static int qla_edif_list_add_sa_update_index(fc_port_t *fcport,
+		uint16_t sa_index, uint16_t handle)
+{
+	struct edif_list_entry *entry;
+	unsigned long flags = 0;
+
+	/* if the entry exists, then just update the sa_index */
+	entry = qla_edif_list_find_sa_index(fcport, handle);
+	if (entry) {
+		entry->update_sa_index = sa_index;
+		entry->count = 0;
+		return 0;
+	}
+
+	/*
+	 * This is the normal path - there should be no existing entry
+	 * when update is called.  The exception is at startup
+	 * when update is called for the first two sa_indexes
+	 * followed by a delete of the first sa_index
+	 */
+	entry = kzalloc((sizeof(struct edif_list_entry)), GFP_ATOMIC);
+	if (!entry)
+		return -1;
+
+	INIT_LIST_HEAD(&entry->next);
+	entry->handle = handle;
+	entry->update_sa_index = sa_index;
+	entry->delete_sa_index = INVALID_EDIF_SA_INDEX;
+	entry->count = 0;
+	entry->flags = 0;
+	timer_setup(&entry->timer, qla2x00_sa_replace_iocb_timeout, 0);
+	spin_lock_irqsave(&fcport->edif.indx_list_lock, flags);
+	list_add_tail(&entry->next, &fcport->edif.edif_indx_list);
+	spin_unlock_irqrestore(&fcport->edif.indx_list_lock, flags);
+	return 0;
+}
+
+/* remove an entry from the list */
+static void qla_edif_list_delete_sa_index(fc_port_t *fcport, struct edif_list_entry *entry)
+{
+	unsigned long flags = 0;
+
+	spin_lock_irqsave(&fcport->edif.indx_list_lock, flags);
+	list_del(&entry->next);
+	spin_unlock_irqrestore(&fcport->edif.indx_list_lock, flags);
+}
+
+int qla_post_sa_replace_work(struct scsi_qla_host *vha,
+	 fc_port_t *fcport, uint16_t nport_handle, struct edif_sa_ctl *sa_ctl)
+{
+	struct qla_work_evt *e;
+
+	e = qla2x00_alloc_work(vha, QLA_EVT_SA_REPLACE);
+	if (!e)
+		return QLA_FUNCTION_FAILED;
+
+	e->u.sa_update.fcport = fcport;
+	e->u.sa_update.sa_ctl = sa_ctl;
+	e->u.sa_update.nport_handle = nport_handle;
+	fcport->flags |= FCF_ASYNC_ACTIVE;
+	return qla2x00_post_work(vha, e);
+}
+
+static void
+qla_edif_sa_ctl_init(scsi_qla_host_t *vha, struct fc_port  *fcport)
+{
+	ql_dbg(ql_dbg_edif, vha, 0x2058,
+		"Init SA_CTL List for fcport - nn %8phN pn %8phN portid=%02x%02x%02x.\n",
+		fcport->node_name, fcport->port_name,
+		fcport->d_id.b.domain, fcport->d_id.b.area,
+		fcport->d_id.b.al_pa);
+
+	fcport->edif.tx_rekey_cnt = 0;
+	fcport->edif.rx_rekey_cnt = 0;
+
+	fcport->edif.tx_bytes = 0;
+	fcport->edif.rx_bytes = 0;
+}
+
+static int qla_bsg_check(scsi_qla_host_t *vha, struct bsg_job *bsg_job,
+fc_port_t *fcport)
+{
+	struct extra_auth_els *p;
+	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
+	struct qla_bsg_auth_els_request *req =
+	    (struct qla_bsg_auth_els_request *)bsg_job->request;
+
+	if (!vha->hw->flags.edif_enabled) {
+		/* edif support not enabled */
+		ql_dbg(ql_dbg_edif, vha, 0x9105,
+		    "%s edif not enabled\n", __func__);
+		goto done;
+	}
+	if (vha->e_dbell.db_flags != EDB_ACTIVE) {
+		/* doorbell list not enabled */
+		ql_dbg(ql_dbg_edif, vha, 0x09102,
+		    "%s doorbell not enabled\n", __func__);
+		goto done;
+	}
+
+	p = &req->e;
+
+	/* Get response */
+	if (p->sub_cmd == PULL_ELS) {
+		struct qla_bsg_auth_els_reply *rpl =
+			(struct qla_bsg_auth_els_reply *)bsg_job->reply;
+
+		qla_pur_get_pending(vha, fcport, bsg_job);
+
+		ql_dbg(ql_dbg_edif, vha, 0x911d,
+			"%s %s %8phN sid=%x. xchg %x, nb=%xh bsg ptr %p\n",
+			__func__, sc_to_str(p->sub_cmd), fcport->port_name,
+			fcport->d_id.b24, rpl->rx_xchg_address,
+			rpl->r.reply_payload_rcv_len, bsg_job);
+
+		goto done;
+	}
+	return 0;
+
+done:
+
+	bsg_job_done(bsg_job, bsg_reply->result,
+			bsg_reply->reply_payload_rcv_len);
+	return -EIO;
+}
+
+fc_port_t *
+qla2x00_find_fcport_by_pid(scsi_qla_host_t *vha, port_id_t *id)
+{
+	fc_port_t *f, *tf;
+
+	f = NULL;
+	list_for_each_entry_safe(f, tf, &vha->vp_fcports, list) {
+		if ((f->flags & FCF_FCSP_DEVICE)) {
+			ql_dbg(ql_dbg_edif + ql_dbg_verbose, vha, 0x2058,
+	"Found secure fcport - nn %8phN pn %8phN portid=%02x%02x%02x, 0x%x, 0x%x.\n",
+			    f->node_name, f->port_name,
+			    f->d_id.b.domain, f->d_id.b.area,
+			    f->d_id.b.al_pa, f->d_id.b24, id->b24);
+			if (f->d_id.b24 == id->b24)
+				return f;
+		}
+	}
+	return NULL;
+}
+
+int qla2x00_check_rdp_test(uint32_t cmd, uint32_t port)
+{
+	if (cmd == ELS_RDP && port == 0xFEFFFF)
+		return 1;
+	else
+		return 0;
+}
+
+static int
+qla_edif_app_check(scsi_qla_host_t *vha, struct app_id appid)
+{
+	int rval = 0;	/* assume failure */
+
+	/* check that the app is allow/known to the driver */
+
+	/* TODO: edif: implement key/cert check for permitted apps... */
+
+	if (appid.app_vid == 0x73730001) {
+		rval = 1;
+		ql_dbg(ql_dbg_edif + ql_dbg_verbose, vha, 0x911d, "%s app id ok\n", __func__);
+	} else {
+		ql_dbg(ql_dbg_edif, vha, 0x911d, "%s app id not ok (%x)",
+		    __func__, appid.app_vid);
+	}
+
+	return rval;
+}
+
+/*
+ * reset the session to auth wait.
+ */
+static void qla_edif_reset_auth_wait(struct fc_port *fcport, int state,
+		int waitonly)
+{
+	int cnt, max_cnt = 200;
+	bool traced = false;
+
+	fcport->keep_nport_handle = 1;
+
+	if (!waitonly) {
+		qla2x00_set_fcport_disc_state(fcport, state);
+		qlt_schedule_sess_for_deletion(fcport);
+	} else {
+		qla2x00_set_fcport_disc_state(fcport, state);
+	}
+
+	ql_dbg(ql_dbg_edif, fcport->vha, 0xf086,
+		"%s: waiting for session, max_cnt=%u\n",
+		__func__, max_cnt);
+
+	cnt = 0;
+
+	if (waitonly) {
+		/* Marker wait min 10 msecs. */
+		msleep(50);
+		cnt += 50;
+	}
+	while (1) {
+		if (!traced) {
+			ql_dbg(ql_dbg_edif, fcport->vha, 0xf086,
+			"%s: session sleep.\n",
+			__func__);
+			traced = true;
+		}
+		msleep(20);
+		cnt++;
+		if (waitonly && (fcport->disc_state == state ||
+			fcport->disc_state == DSC_LOGIN_COMPLETE))
+			break;
+		if (fcport->disc_state == DSC_LOGIN_AUTH_PEND)
+			break;
+		if (cnt > max_cnt)
+			break;
+	}
+
+	if (!waitonly) {
+		ql_dbg(ql_dbg_edif, fcport->vha, 0xf086,
+	"%s: waited for session - %8phC, loopid=%x portid=%06x fcport=%p state=%u, cnt=%u\n",
+		    __func__, fcport->port_name, fcport->loop_id,
+		    fcport->d_id.b24, fcport, fcport->disc_state, cnt);
+	} else {
+		ql_dbg(ql_dbg_edif, fcport->vha, 0xf086,
+	"%s: waited ONLY for session - %8phC, loopid=%x portid=%06x fcport=%p state=%u, cnt=%u\n",
+		    __func__, fcport->port_name, fcport->loop_id,
+		    fcport->d_id.b24, fcport, fcport->disc_state, cnt);
+	}
+}
+
+static void
+qla_edif_free_sa_ctl(fc_port_t *fcport, struct edif_sa_ctl *sa_ctl,
+	int index)
+{
+	unsigned long flags = 0;
+
+	spin_lock_irqsave(&fcport->edif.sa_list_lock, flags);
+	list_del(&sa_ctl->next);
+	spin_unlock_irqrestore(&fcport->edif.sa_list_lock, flags);
+	if (index >= 512)
+		fcport->edif.tx_rekey_cnt--;
+	else
+		fcport->edif.rx_rekey_cnt--;
+	kfree(sa_ctl);
+}
+
+/* return an index to the freepool */
+static void qla_edif_add_sa_index_to_freepool(fc_port_t *fcport, int dir,
+		uint16_t sa_index)
+{
+	void *sa_id_map;
+	struct scsi_qla_host *vha = fcport->vha;
+	struct qla_hw_data *ha = vha->hw;
+	unsigned long flags = 0;
+	u16 lsa_index = sa_index;
+
+	ql_dbg(ql_dbg_edif + ql_dbg_verbose, vha, 0x3063,
+	    "%s: entry\n", __func__);
+
+	if (dir) {
+		sa_id_map = ha->edif_tx_sa_id_map;
+		lsa_index -= EDIF_TX_SA_INDEX_BASE;
+	} else {
+		sa_id_map = ha->edif_rx_sa_id_map;
+	}
+
+	spin_lock_irqsave(&ha->sadb_fp_lock, flags);
+	clear_bit(lsa_index, sa_id_map);
+	spin_unlock_irqrestore(&ha->sadb_fp_lock, flags);
+	ql_dbg(ql_dbg_edif, vha, 0x3063,
+	    "%s: index %d added to free pool\n", __func__, sa_index);
+}
+
+static void __qla2x00_release_all_sadb(struct scsi_qla_host *vha,
+	struct fc_port *fcport, struct edif_sa_index_entry *entry,
+	int pdir)
+{
+	struct edif_list_entry *edif_entry;
+	struct  edif_sa_ctl *sa_ctl;
+	int i, dir;
+	int key_cnt = 0;
+
+	for (i = 0; i < 2; i++) {
+		if (entry->sa_pair[i].sa_index == INVALID_EDIF_SA_INDEX)
+			continue;
+
+		if (fcport->loop_id != entry->handle) {
+			ql_dbg(ql_dbg_edif, vha, 0x3063,
+	"%s: ** WARNING %d** entry handle: 0x%x, fcport nport_handle: 0x%x, sa_index: %d\n",
+				__func__, i, entry->handle,
+				fcport->loop_id,
+				entry->sa_pair[i].sa_index);
+		}
+
+		/* release the sa_ctl */
+		sa_ctl = qla_edif_find_sa_ctl_by_index(fcport,
+				entry->sa_pair[i].sa_index, pdir);
+		if (sa_ctl &&
+		    qla_edif_find_sa_ctl_by_index(fcport, sa_ctl->index, pdir)) {
+			ql_dbg(ql_dbg_edif, vha, 0x3063,
+					"%s: freeing sa_ctl for index %d\n",
+					__func__, sa_ctl->index);
+			qla_edif_free_sa_ctl(fcport, sa_ctl, sa_ctl->index);
+		} else {
+			ql_dbg(ql_dbg_edif, vha, 0x3063,
+				"%s: sa_ctl NOT freed, sa_ctl: %p\n",
+				__func__, sa_ctl);
+		}
+
+		/* Release the index */
+		ql_dbg(ql_dbg_edif, vha, 0x3063,
+			"%s: freeing sa_index %d, nph: 0x%x\n",
+			__func__, entry->sa_pair[i].sa_index, entry->handle);
+
+		dir = (entry->sa_pair[i].sa_index <
+			EDIF_TX_SA_INDEX_BASE) ? 0 : 1;
+		qla_edif_add_sa_index_to_freepool(fcport, dir,
+			entry->sa_pair[i].sa_index);
+
+		/* Delete timer on RX */
+		if (pdir != SAU_FLG_TX) {
+			edif_entry =
+				qla_edif_list_find_sa_index(fcport, entry->handle);
+			if (edif_entry) {
+				ql_dbg(ql_dbg_edif, vha, 0x5033,
+	"%s: removing edif_entry %p, update_sa_index: 0x%x, delete_sa_index: 0x%x\n",
+					__func__, edif_entry, edif_entry->update_sa_index,
+					edif_entry->delete_sa_index);
+				qla_edif_list_delete_sa_index(fcport, edif_entry);
+				/*
+				 * valid delete_sa_index indicates there is a rx
+				 * delayed delete queued
+				 */
+				if (edif_entry->delete_sa_index !=
+						INVALID_EDIF_SA_INDEX) {
+					del_timer(&edif_entry->timer);
+
+					/* build and send the aen */
+					fcport->edif.rx_sa_set = 1;
+					fcport->edif.rx_sa_pending = 0;
+					qla_edb_eventcreate(vha,
+							VND_CMD_AUTH_STATE_SAUPDATE_COMPL,
+							QL_VND_SA_STAT_SUCCESS,
+							QL_VND_RX_SA_KEY, fcport);
+				}
+				ql_dbg(ql_dbg_edif, vha, 0x5033,
+	"%s: releasing edif_entry %p, update_sa_index: 0x%x, delete_sa_index: 0x%x\n",
+					__func__, edif_entry,
+					edif_entry->update_sa_index,
+					edif_entry->delete_sa_index);
+
+				kfree(edif_entry);
+			}
+		}
+		key_cnt++;
+	}
+	ql_dbg(ql_dbg_edif, vha, 0x3063,
+	    "%s: %d %s keys released\n",
+	    __func__, key_cnt, pdir ? "tx" : "rx");
+}
+
+/* find an release all outstanding sadb sa_indicies */
+void qla2x00_release_all_sadb(struct scsi_qla_host *vha, struct fc_port *fcport)
+{
+	struct edif_sa_index_entry *entry, *tmp;
+	struct qla_hw_data *ha = vha->hw;
+	unsigned long flags;
+
+	ql_dbg(ql_dbg_edif + ql_dbg_verbose, vha, 0x3063,
+	    "%s: Starting...\n", __func__);
+
+	spin_lock_irqsave(&ha->sadb_lock, flags);
+
+	list_for_each_entry_safe(entry, tmp, &ha->sadb_rx_index_list, next) {
+		if (entry->fcport == fcport) {
+			list_del(&entry->next);
+			spin_unlock_irqrestore(&ha->sadb_lock, flags);
+			__qla2x00_release_all_sadb(vha, fcport, entry, 0);
+			kfree(entry);
+			spin_lock_irqsave(&ha->sadb_lock, flags);
+			break;
+		}
+	}
+
+	list_for_each_entry_safe(entry, tmp, &ha->sadb_tx_index_list, next) {
+		if (entry->fcport == fcport) {
+			list_del(&entry->next);
+			spin_unlock_irqrestore(&ha->sadb_lock, flags);
+
+			__qla2x00_release_all_sadb(vha, fcport, entry, SAU_FLG_TX);
+
+			kfree(entry);
+			spin_lock_irqsave(&ha->sadb_lock, flags);
+			break;
+		}
+	}
+	spin_unlock_irqrestore(&ha->sadb_lock, flags);
+}
+
+/*
+ * event that the app has started. Clear and start doorbell
+ */
+static int
+qla_edif_app_start(scsi_qla_host_t *vha, struct bsg_job *bsg_job)
+{
+	int32_t			rval = 0;
+	struct fc_bsg_reply	*bsg_reply = bsg_job->reply;
+	struct app_start	appstart;
+	struct app_start_reply	appreply;
+	struct fc_port  *fcport, *tf;
+
+	ql_dbg(ql_dbg_edif, vha, 0x911d, "%s app start\n", __func__);
+
+	sg_copy_to_buffer(bsg_job->request_payload.sg_list,
+	    bsg_job->request_payload.sg_cnt, &appstart,
+	    sizeof(struct app_start));
+
+	ql_dbg(ql_dbg_edif, vha, 0x911d, "%s app_vid=%x app_start_flags %x\n",
+	     __func__, appstart.app_info.app_vid, appstart.app_start_flags);
+
+	vha->edif_prli_timeout = (appstart.prli_to > EDIF_TO_MIN ?
+	    appstart.prli_to : EDIF_PRLI_TO);
+	vha->edif_kshred_timeout = (appstart.key_shred > EDIF_TO_MIN ?
+	    appstart.key_shred : EDIF_KSHRED_TO);
+	ql_dbg(ql_dbg_edif, vha, 0x911e,
+	    "%s: PRLI Timeout %d, KSHRED Timeout %d\n",
+	    __func__, vha->edif_prli_timeout, vha->edif_kshred_timeout);
+
+	if (vha->e_dbell.db_flags != EDB_ACTIVE) {
+		/* mark doorbell as active since an app is now present */
+		vha->e_dbell.db_flags = EDB_ACTIVE;
+	} else {
+		ql_dbg(ql_dbg_edif, vha, 0x911e, "%s doorbell already active\n",
+		     __func__);
+	}
+
+	list_for_each_entry_safe(fcport, tf, &vha->vp_fcports, list) {
+		if ((fcport->flags & FCF_FCSP_DEVICE)) {
+			ql_dbg(ql_dbg_edif, vha, 0xf084,
+			    "%s: sess %p %8phC lid %#04x s_id %06x logout %d\n",
+			    __func__, fcport, fcport->port_name,
+			    fcport->loop_id, fcport->d_id.b24,
+			    fcport->logout_on_delete);
+
+			ql_dbg(ql_dbg_edif, vha, 0xf084,
+			    "keep %d els_logo %d disc state %d auth state %d stop state %d\n",
+			    fcport->keep_nport_handle,
+			    fcport->send_els_logo, fcport->disc_state,
+			    fcport->edif.auth_state, fcport->edif.app_stop);
+
+			if (atomic_read(&vha->loop_state) == LOOP_DOWN)
+				break;
+
+			if (!fcport->edif.secured_login)
+				continue;
+
+			fcport->edif.app_started = 1;
+			if (fcport->edif.app_stop ||
+			    (fcport->disc_state != DSC_LOGIN_COMPLETE &&
+			     fcport->disc_state != DSC_LOGIN_PEND &&
+			     fcport->disc_state != DSC_DELETED)) {
+				/* no activity */
+				fcport->edif.app_stop = 0;
+
+				ql_dbg(ql_dbg_edif, vha, 0x911e,
+				    "%s wwpn %8phC calling qla_edif_reset_auth_wait\n",
+				    __func__, fcport->port_name);
+				fcport->edif.app_sess_online = 1;
+				qla_edif_reset_auth_wait(fcport, DSC_LOGIN_PEND, 0);
+			}
+			qla_edif_sa_ctl_init(vha, fcport);
+		}
+	}
+
+	if (vha->pur_cinfo.enode_flags != ENODE_ACTIVE) {
+		/* mark as active since an app is now present */
+		vha->pur_cinfo.enode_flags = ENODE_ACTIVE;
+	} else {
+		ql_dbg(ql_dbg_edif, vha, 0x911f, "%s enode already active\n",
+		     __func__);
+	}
+
+	appreply.host_support_edif = vha->hw->flags.edif_enabled;
+	appreply.edif_enode_active = vha->pur_cinfo.enode_flags;
+	appreply.edif_edb_active = vha->e_dbell.db_flags;
+
+	bsg_job->reply_len = sizeof(struct fc_bsg_reply) +
+	    sizeof(struct app_start_reply);
+
+	SET_DID_STATUS(bsg_reply->result, DID_OK);
+
+	sg_copy_from_buffer(bsg_job->reply_payload.sg_list,
+	    bsg_job->reply_payload.sg_cnt, &appreply,
+	    sizeof(struct app_start_reply));
+
+	ql_dbg(ql_dbg_edif, vha, 0x911d,
+	    "%s app start completed with 0x%x\n",
+	    __func__, rval);
+
+	return rval;
+}
+
+/*
+ * notification from the app that the app is stopping.
+ * actions:	stop and doorbell
+ *		stop and clear enode
+ */
+static int
+qla_edif_app_stop(scsi_qla_host_t *vha, struct bsg_job *bsg_job)
+{
+	int32_t                 rval = 0;
+	struct app_stop         appstop;
+	struct fc_bsg_reply     *bsg_reply = bsg_job->reply;
+	struct fc_port  *fcport, *tf;
+
+	sg_copy_to_buffer(bsg_job->request_payload.sg_list,
+	    bsg_job->request_payload.sg_cnt, &appstop,
+	    sizeof(struct app_stop));
+
+	ql_dbg(ql_dbg_edif, vha, 0x911d, "%s Stopping APP: app_vid=%x\n",
+	    __func__, appstop.app_info.app_vid);
+
+	/* Call db stop and enode stop functions */
+
+	/* if we leave this running short waits are operational < 16 secs */
+	qla_enode_stop(vha);        /* stop enode */
+	qla_edb_stop(vha);          /* stop db */
+
+	list_for_each_entry_safe(fcport, tf, &vha->vp_fcports, list) {
+		if (fcport->edif.non_secured_login)
+			continue;
+
+		if (fcport->flags & FCF_FCSP_DEVICE) {
+			ql_dbg(ql_dbg_edif, vha, 0xf084,
+	"%s: sess %p from port %8phC lid %#04x s_id %06x logout %d keep %d els_logo %d\n",
+			    __func__, fcport,
+			    fcport->port_name, fcport->loop_id,
+			    fcport->d_id.b24, fcport->logout_on_delete,
+			    fcport->keep_nport_handle, fcport->send_els_logo);
+
+			if (atomic_read(&vha->loop_state) == LOOP_DOWN)
+				break;
+
+			fcport->edif.app_stop = APP_STOPPING;
+			ql_dbg(ql_dbg_edif, vha, 0x911e,
+				"%s wwpn %8phC calling qla_edif_reset_auth_wait\n",
+				__func__, fcport->port_name);
+
+			fcport->send_els_logo = 1;
+			qlt_schedule_sess_for_deletion(fcport);
+
+			/* qla_edif_flush_sa_ctl_lists(fcport); */
+			fcport->edif.app_started = 0;
+		}
+	}
+
+	bsg_job->reply_len = sizeof(struct fc_bsg_reply);
+	SET_DID_STATUS(bsg_reply->result, DID_OK);
+
+	/* no return interface to app - it assumes we cleaned up ok */
+
+	return rval;
+}
+
+static int
+qla_edif_app_chk_sa_update(scsi_qla_host_t *vha, fc_port_t *fcport,
+		struct app_plogi_reply *appplogireply)
+{
+	int	ret = 0;
+
+	fcport->edif.db_sent = 0;
+	if (!(fcport->edif.rx_sa_set && fcport->edif.tx_sa_set)) {
+		ql_dbg(ql_dbg_edif, vha, 0x911e,
+		    "%s: wwpn %8phC Both SA indexes has not been SET TX %d, RX %d.\n",
+		    __func__, fcport->port_name, fcport->edif.tx_sa_set,
+		    fcport->edif.rx_sa_set);
+		appplogireply->prli_status = 0;
+		ret = 1;
+	} else  {
+		ql_dbg(ql_dbg_edif, vha, 0x911e,
+		    "%s wwpn %8phC Both SA(s) updated.\n", __func__,
+		    fcport->port_name);
+		fcport->edif.rx_sa_set = fcport->edif.tx_sa_set = 0;
+		fcport->edif.rx_sa_pending = fcport->edif.tx_sa_pending = 0;
+		appplogireply->prli_status = 1;
+	}
+	return ret;
+}
+
+/*
+ * event that the app has approved plogi to complete (e.g., finish
+ * up with prli
+ */
+static int
+qla_edif_app_authok(scsi_qla_host_t *vha, struct bsg_job *bsg_job)
+{
+	int32_t			rval = 0;
+	struct auth_complete_cmd appplogiok;
+	struct app_plogi_reply	appplogireply = {0};
+	struct fc_bsg_reply	*bsg_reply = bsg_job->reply;
+	fc_port_t		*fcport = NULL;
+	port_id_t		portid = {0};
+	/* port_id_t		portid = {0x10100}; */
+	/* int i; */
+
+	/* ql_dbg(ql_dbg_edif, vha, 0x911d, "%s app auth ok\n", __func__); */
+
+	sg_copy_to_buffer(bsg_job->request_payload.sg_list,
+	    bsg_job->request_payload.sg_cnt, &appplogiok,
+	    sizeof(struct auth_complete_cmd));
+
+	switch (appplogiok.type) {
+	case PL_TYPE_WWPN:
+		fcport = qla2x00_find_fcport_by_wwpn(vha,
+		    appplogiok.u.wwpn, 0);
+		if (!fcport)
+			ql_dbg(ql_dbg_edif, vha, 0x911d,
+			    "%s wwpn lookup failed: %8phC\n",
+			    __func__, appplogiok.u.wwpn);
+		break;
+	case PL_TYPE_DID:
+		fcport = qla2x00_find_fcport_by_pid(vha, &appplogiok.u.d_id);
+		if (!fcport)
+			ql_dbg(ql_dbg_edif, vha, 0x911d,
+			    "%s d_id lookup failed: %x\n", __func__,
+			    portid.b24);
+		break;
+	default:
+		ql_dbg(ql_dbg_edif, vha, 0x911d,
+		    "%s undefined type: %x\n", __func__,
+		    appplogiok.type);
+		break;
+	}
+
+	if (!fcport) {
+		SET_DID_STATUS(bsg_reply->result, DID_ERROR);
+		goto errstate_exit;
+	}
+
+	/* TODO: edif: Kill prli timer... */
+
+	/*
+	 * if port is online then this is a REKEY operation
+	 * Only do sa update checking
+	 */
+	if (atomic_read(&fcport->state) == FCS_ONLINE) {
+		ql_dbg(ql_dbg_edif, vha, 0x911d,
+		    "%s Skipping PRLI complete based on rekey\n", __func__);
+		appplogireply.prli_status = 1;
+		SET_DID_STATUS(bsg_reply->result, DID_OK);
+		qla_edif_app_chk_sa_update(vha, fcport, &appplogireply);
+		goto errstate_exit;
+	}
+
+	/* make sure in AUTH_PENDING or else reject */
+	if (fcport->disc_state != DSC_LOGIN_AUTH_PEND) {
+		ql_dbg(ql_dbg_edif, vha, 0x911e,
+		    "%s wwpn %8phC is not in auth pending state (%x)\n",
+		    __func__, fcport->port_name, fcport->disc_state);
+		/* SET_DID_STATUS(bsg_reply->result, DID_ERROR); */
+		/* App can't fix us - initaitor will retry */
+		SET_DID_STATUS(bsg_reply->result, DID_OK);
+		appplogireply.prli_status = 0;
+		goto errstate_exit;
+	}
+
+	SET_DID_STATUS(bsg_reply->result, DID_OK);
+	appplogireply.prli_status = 1;
+	fcport->edif.db_sent = 0;
+	if (!(fcport->edif.rx_sa_set && fcport->edif.tx_sa_set)) {
+		ql_dbg(ql_dbg_edif, vha, 0x911e,
+		    "%s: wwpn %8phC Both SA indexes has not been SET TX %d, RX %d.\n",
+		    __func__, fcport->port_name, fcport->edif.tx_sa_set,
+		    fcport->edif.rx_sa_set);
+		SET_DID_STATUS(bsg_reply->result, DID_OK);
+		appplogireply.prli_status = 0;
+		goto errstate_exit;
+
+	} else {
+		ql_dbg(ql_dbg_edif, vha, 0x911e,
+		    "%s wwpn %8phC Both SA(s) updated.\n", __func__,
+		    fcport->port_name);
+		fcport->edif.rx_sa_set = fcport->edif.tx_sa_set = 0;
+		fcport->edif.rx_sa_pending = fcport->edif.tx_sa_pending = 0;
+	}
+	/* qla_edif_app_chk_sa_update(vha, fcport, &appplogireply); */
+	/*
+	 * TODO: edif: check this - discovery state changed by prli work?
+	 * TODO: Can't call this for target mode
+	 */
+	if (qla_ini_mode_enabled(vha)) {
+		ql_dbg(ql_dbg_edif, vha, 0x911e,
+		    "%s AUTH complete - RESUME with prli for wwpn %8phC\n",
+		    __func__, fcport->port_name);
+		qla_edif_reset_auth_wait(fcport, DSC_LOGIN_PEND, 1);
+		/* qla2x00_set_fcport_disc_state(fcport, DSC_LOGIN_PEND); */
+		qla24xx_post_prli_work(vha, fcport);
+	}
+
+errstate_exit:
+
+	bsg_job->reply_len = sizeof(struct fc_bsg_reply);
+	sg_copy_from_buffer(bsg_job->reply_payload.sg_list,
+	    bsg_job->reply_payload.sg_cnt, &appplogireply,
+	    sizeof(struct app_plogi_reply));
+
+	return rval;
+}
+
+/*
+ * event that the app has failed the plogi. logout the device (tbd)
+ */
+static int
+qla_edif_app_authfail(scsi_qla_host_t *vha, struct bsg_job *bsg_job)
+{
+	int32_t			rval = 0;
+	struct auth_complete_cmd appplogifail;
+	struct fc_bsg_reply	*bsg_reply = bsg_job->reply;
+	fc_port_t		*fcport = NULL;
+	port_id_t		portid = {0};
+
+	ql_dbg(ql_dbg_edif, vha, 0x911d, "%s app auth fail\n", __func__);
+
+	sg_copy_to_buffer(bsg_job->request_payload.sg_list,
+	    bsg_job->request_payload.sg_cnt, &appplogifail,
+	    sizeof(struct auth_complete_cmd));
+
+	/*
+	 * TODO: edif: app has failed this plogi. Inform driver to
+	 * take any action (if any).
+	 */
+	switch (appplogifail.type) {
+	case PL_TYPE_WWPN:
+		fcport = qla2x00_find_fcport_by_wwpn(vha,
+		    appplogifail.u.wwpn, 0);
+		SET_DID_STATUS(bsg_reply->result, DID_OK);
+		break;
+	case PL_TYPE_DID:
+		fcport = qla2x00_find_fcport_by_pid(vha, &appplogifail.u.d_id);
+		if (!fcport)
+			ql_dbg(ql_dbg_edif, vha, 0x911d,
+			    "%s d_id lookup failed: %x\n", __func__,
+			    portid.b24);
+		SET_DID_STATUS(bsg_reply->result, DID_OK);
+		break;
+	default:
+		ql_dbg(ql_dbg_edif, vha, 0x911e,
+		    "%s undefined type: %x\n", __func__,
+		    appplogifail.type);
+		bsg_job->reply_len = sizeof(struct fc_bsg_reply);
+		SET_DID_STATUS(bsg_reply->result, DID_ERROR);
+		rval = -1;
+		break;
+	}
+
+	ql_dbg(ql_dbg_edif, vha, 0x911d,
+	    "%s fcport is 0x%p\n", __func__, fcport);
+
+	if (fcport) {
+		/* set/reset edif values and flags */
+		ql_dbg(ql_dbg_edif, vha, 0x911e,
+		    "%s reset the auth process - %8phC, loopid=%x portid=%06x.\n",
+		    __func__, fcport->port_name, fcport->loop_id,
+		    fcport->d_id.b24);
+
+		if (qla_ini_mode_enabled(fcport->vha)) {
+			fcport->send_els_logo = 1;
+			qla_edif_reset_auth_wait(fcport, DSC_LOGIN_PEND, 0);
+		}
+	}
+
+	return rval;
+}
+
+/*
+ * event that the app has sent down new rekey trigger parameters
+ */
+static int
+qla_edif_app_rekey(scsi_qla_host_t *vha, struct bsg_job *bsg_job)
+{
+	int32_t			rval = 0;
+	struct app_rekey_cfg	app_recfg;
+	struct fc_bsg_reply	*bsg_reply = bsg_job->reply;
+	struct fc_port		*fcport = NULL, *tf;
+	port_id_t		did;
+
+	SET_DID_STATUS(bsg_reply->result, DID_OK);
+
+	ql_dbg(ql_dbg_edif, vha, 0x911d, "%s app rekey config\n", __func__);
+
+	sg_copy_to_buffer(bsg_job->request_payload.sg_list,
+	    bsg_job->request_payload.sg_cnt, &app_recfg,
+	    sizeof(struct app_rekey_cfg));
+
+	did = app_recfg.d_id;
+
+	list_for_each_entry_safe(fcport, tf, &vha->vp_fcports, list) {
+		if (fcport->edif.enable) {
+			/* this device has edif support */
+			if (did.b24 == 0 ||
+			    did.b24 == fcport->d_id.b24) {
+				if (app_recfg.rekey_mode == RECFG_TIME) {
+					fcport->edif.rekey_mode = 1;
+					fcport->edif.reload_value =
+					    fcport->edif.rekey =
+					    app_recfg.rky_units.time;
+				} else if (app_recfg.rekey_mode == RECFG_BYTES) {
+					fcport->edif.rekey_mode = 0;
+					fcport->edif.reload_value =
+					    fcport->edif.rekey =
+					    app_recfg.rky_units.bytes;
+				} else {
+					/* invalid rekey mode passed */
+					ql_dbg(ql_dbg_edif, vha, 0x911d,
+					    "%s invalid rekey passed (%x)\n",
+					     __func__, app_recfg.rekey_mode);
+					SET_DID_STATUS(bsg_reply->result, DID_ERROR);
+					break;
+				}
+
+				/*
+				 * dpc to check and generate db event to app
+				 * if (app_recfg.force == 1)
+				 */
+				/* fcport->edif.new_sa = 1; */
+
+				if (did.b24 != 0)
+					break;
+			}
+		}
+	}
+
+	return rval;
+}
+
+/*
+ * event that the app needs fc port info (either all or individual d_id)
+ */
+static int
+qla_edif_app_getfcinfo(scsi_qla_host_t *vha, struct bsg_job *bsg_job)
+{
+	int32_t			rval = 0;
+	int32_t			num_cnt = 1;
+	struct fc_bsg_reply	*bsg_reply = bsg_job->reply;
+	struct app_pinfo_req	app_req;
+	struct app_pinfo_reply	*app_reply;
+	port_id_t		tdid;
+
+	ql_dbg(ql_dbg_edif, vha, 0x911d, "%s app get fcinfo\n", __func__);
+
+	sg_copy_to_buffer(bsg_job->request_payload.sg_list,
+	    bsg_job->request_payload.sg_cnt, &app_req,
+	    sizeof(struct app_pinfo_req));
+
+	num_cnt =  app_req.num_ports;	/* num of ports alloc'd by app */
+
+	app_reply = kzalloc((sizeof(struct app_pinfo_reply) +
+	    sizeof(struct app_pinfo) * num_cnt), GFP_KERNEL);
+	if (!app_reply) {
+		SET_DID_STATUS(bsg_reply->result, DID_ERROR);
+		rval = -1;
+	} else {
+		struct fc_port	*fcport = NULL, *tf;
+		uint32_t	pcnt = 0;
+
+		list_for_each_entry_safe(fcport, tf, &vha->vp_fcports, list) {
+			if (!(fcport->flags & FCF_FCSP_DEVICE))
+				continue;
+
+			tdid = app_req.remote_pid;
+
+			ql_dbg(ql_dbg_edif, vha, 0x2058,
+			    "APP request entry - portid=%02x%02x%02x.\n",
+			    tdid.b.domain, tdid.b.area, tdid.b.al_pa);
+
+			/* Ran out of space */
+			if (pcnt > app_req.num_ports)
+				break;
+
+			if (tdid.b24 != 0 && tdid.b24 != fcport->d_id.b24)
+				continue;
+
+			/* we are interested in this one */
+
+			app_reply->ports[pcnt].rekey_mode =
+				fcport->edif.rekey_mode;
+			app_reply->ports[pcnt].rekey_count =
+				fcport->edif.rekey_cnt;
+			app_reply->ports[pcnt].rekey_config_value =
+				fcport->edif.reload_value;
+			app_reply->ports[pcnt].rekey_consumed_value =
+				fcport->edif.rekey;
+
+			app_reply->ports[pcnt].remote_type =
+				VND_CMD_RTYPE_UNKNOWN;
+			if (fcport->port_type & (FCT_NVME_TARGET | FCT_TARGET))
+				app_reply->ports[pcnt].remote_type |=
+					VND_CMD_RTYPE_TARGET;
+			if (fcport->port_type & (FCT_NVME_INITIATOR | FCT_INITIATOR))
+				app_reply->ports[pcnt].remote_type |=
+					VND_CMD_RTYPE_INITIATOR;
+
+			app_reply->ports[pcnt].remote_pid = fcport->d_id;
+
+			ql_dbg(ql_dbg_edif, vha, 0x2058,
+	"Found FC_SP fcport - nn %8phN pn %8phN pcnt %d portid=%02x%02x%02x.\n",
+			    fcport->node_name, fcport->port_name, pcnt,
+			    fcport->d_id.b.domain, fcport->d_id.b.area,
+			    fcport->d_id.b.al_pa);
+
+			switch (fcport->edif.auth_state) {
+			case VND_CMD_AUTH_STATE_ELS_RCVD:
+				if (fcport->disc_state == DSC_LOGIN_AUTH_PEND) {
+					fcport->edif.auth_state = VND_CMD_AUTH_STATE_NEEDED;
+					app_reply->ports[pcnt].auth_state =
+						VND_CMD_AUTH_STATE_NEEDED;
+				} else {
+					app_reply->ports[pcnt].auth_state =
+						VND_CMD_AUTH_STATE_ELS_RCVD;
+				}
+				break;
+			default:
+				app_reply->ports[pcnt].auth_state = fcport->edif.auth_state;
+				break;
+			}
+
+			memcpy(app_reply->ports[pcnt].remote_wwpn,
+			    fcport->port_name, 8);
+
+			app_reply->ports[pcnt].remote_state =
+				(atomic_read(&fcport->state) ==
+				    FCS_ONLINE ? 1 : 0);
+
+			pcnt++;
+
+			if (tdid.b24 != 0)
+				break;  /* found the one req'd */
+		}
+		app_reply->port_count = pcnt;
+		SET_DID_STATUS(bsg_reply->result, DID_OK);
+	}
+
+	sg_copy_from_buffer(bsg_job->reply_payload.sg_list,
+	    bsg_job->reply_payload.sg_cnt, app_reply,
+	    sizeof(struct app_pinfo_reply) + sizeof(struct app_pinfo) * num_cnt);
+
+	kfree(app_reply);
+
+	return rval;
+}
+
+/*
+ * return edif stats (TBD) to app
+ */
+static int32_t
+qla_edif_app_getstats(scsi_qla_host_t *vha, struct bsg_job *bsg_job)
+{
+	int32_t			rval = 0;
+	struct fc_bsg_reply	*bsg_reply = bsg_job->reply;
+	uint32_t ret_size, size;
+
+	struct app_sinfo_req	app_req;
+	struct app_stats_reply	*app_reply;
+
+	sg_copy_to_buffer(bsg_job->request_payload.sg_list,
+	    bsg_job->request_payload.sg_cnt, &app_req,
+	    sizeof(struct app_sinfo_req));
+	if (app_req.num_ports == 0) {
+		ql_dbg(ql_dbg_async, vha, 0x911d,
+		   "%s app did not indicate number of ports to return\n",
+		    __func__);
+		SET_DID_STATUS(bsg_reply->result, DID_ERROR);
+		rval = -1;
+	}
+
+	size = sizeof(struct app_stats_reply) +
+	    (sizeof(struct app_sinfo) * app_req.num_ports);
+
+	if (size > bsg_job->reply_payload.payload_len)
+		ret_size = bsg_job->reply_payload.payload_len;
+	else
+		ret_size = size;
+
+	app_reply = kzalloc(size, GFP_KERNEL);
+	if (!app_reply) {
+		SET_DID_STATUS(bsg_reply->result, DID_ERROR);
+		rval = -1;
+	} else {
+		struct fc_port	*fcport = NULL, *tf;
+		uint32_t	pcnt = 0;
+
+		list_for_each_entry_safe(fcport, tf, &vha->vp_fcports, list) {
+			if (fcport->edif.enable) {
+				if (pcnt > app_req.num_ports)
+					break;
+
+				app_reply->elem[pcnt].rekey_mode =
+				    fcport->edif.rekey_mode ? RECFG_TIME : RECFG_BYTES;
+				app_reply->elem[pcnt].rekey_count =
+				    fcport->edif.rekey_cnt;
+				app_reply->elem[pcnt].tx_bytes =
+				    fcport->edif.tx_bytes;
+				app_reply->elem[pcnt].rx_bytes =
+				    fcport->edif.rx_bytes;
+
+				memcpy(app_reply->elem[pcnt].remote_wwpn,
+				    fcport->port_name, 8);
+
+				pcnt++;
+			}
+		}
+		app_reply->elem_count = pcnt;
+		SET_DID_STATUS(bsg_reply->result, DID_OK);
+	}
+
+	bsg_reply->reply_payload_rcv_len =
+	    sg_copy_from_buffer(bsg_job->reply_payload.sg_list,
+	       bsg_job->reply_payload.sg_cnt, app_reply, ret_size);
+
+	kfree(app_reply);
+
+	return rval;
+}
+
+int32_t
+qla_edif_app_mgmt(struct bsg_job *bsg_job)
+{
+	struct fc_bsg_request	*bsg_request = bsg_job->request;
+	struct fc_bsg_reply	*bsg_reply = bsg_job->reply;
+	struct Scsi_Host *host = fc_bsg_to_shost(bsg_job);
+	scsi_qla_host_t		*vha = shost_priv(host);
+	struct app_id		appcheck;
+	bool done = true;
+	int32_t         rval = 0;
+	uint32_t	vnd_sc = bsg_request->rqst_data.h_vendor.vendor_cmd[1];
+
+	ql_dbg(ql_dbg_edif, vha, 0x911d, "%s vnd subcmd=%x\n",
+	    __func__, vnd_sc);
+
+	sg_copy_to_buffer(bsg_job->request_payload.sg_list,
+	    bsg_job->request_payload.sg_cnt, &appcheck,
+	    sizeof(struct app_id));
+
+	if (!vha->hw->flags.edif_enabled ||
+		test_bit(VPORT_DELETE, &vha->dpc_flags)) {
+		ql_dbg(ql_dbg_edif, vha, 0x911d,
+		    "%s edif not enabled or vp delete. bsg ptr done %p\n",
+		    __func__, bsg_job);
+
+		SET_DID_STATUS(bsg_reply->result, DID_ERROR);
+		goto done;
+	}
+
+	if (qla_edif_app_check(vha, appcheck) == 0) {
+		ql_dbg(ql_dbg_edif, vha, 0x911d,
+		    "%s app checked failed.\n",
+		    __func__);
+
+		bsg_job->reply_len = sizeof(struct fc_bsg_reply);
+		SET_DID_STATUS(bsg_reply->result, DID_ERROR);
+		goto done;
+	}
+
+	switch (vnd_sc) {
+	case QL_VND_SC_SA_UPDATE:
+		done = false;
+		rval = qla24xx_sadb_update(bsg_job);
+		break;
+	case QL_VND_SC_APP_START:
+		rval = qla_edif_app_start(vha, bsg_job);
+		break;
+	case QL_VND_SC_APP_STOP:
+		rval = qla_edif_app_stop(vha, bsg_job);
+		break;
+	case QL_VND_SC_AUTH_OK:
+		rval = qla_edif_app_authok(vha, bsg_job);
+		break;
+	case QL_VND_SC_AUTH_FAIL:
+		rval = qla_edif_app_authfail(vha, bsg_job);
+		break;
+	case QL_VND_SC_REKEY_CONFIG:
+		rval = qla_edif_app_rekey(vha, bsg_job);
+		break;
+	case QL_VND_SC_GET_FCINFO:
+		rval = qla_edif_app_getfcinfo(vha, bsg_job);
+		break;
+	case QL_VND_SC_GET_STATS:
+		rval = qla_edif_app_getstats(vha, bsg_job);
+		break;
+	default:
+		ql_dbg(ql_dbg_edif, vha, 0x911d, "%s unknown cmd=%x\n",
+		    __func__,
+		    bsg_request->rqst_data.h_vendor.vendor_cmd[1]);
+		rval = EXT_STATUS_INVALID_PARAM;
+		bsg_job->reply_len = sizeof(struct fc_bsg_reply);
+		SET_DID_STATUS(bsg_reply->result, DID_ERROR);
+		break;
+	}
+
+done:
+	if (done) {
+		ql_dbg(ql_dbg_user, vha, 0x7009,
+		    "%s: %d  bsg ptr done %p\n", __func__, __LINE__, bsg_job);
+		bsg_job_done(bsg_job, bsg_reply->result,
+		    bsg_reply->reply_payload_rcv_len);
+	}
+
+	return rval;
+}
+
+static struct edif_sa_ctl *
+qla_edif_add_sa_ctl(fc_port_t *fcport, struct qla_sa_update_frame *sa_frame,
+	int dir)
+{
+	struct	edif_sa_ctl *sa_ctl;
+	struct qla_sa_update_frame *sap;
+	int	index = sa_frame->fast_sa_index;
+	unsigned long flags = 0;
+
+	sa_ctl = kzalloc(sizeof(*sa_ctl), GFP_KERNEL);
+	if (!sa_ctl) {
+		/* couldn't get space */
+		ql_dbg(ql_dbg_edif, fcport->vha, 0x9100,
+		    "unable to allocate SA CTL\n");
+		return NULL;
+	}
+
+	/*
+	 * need to allocate sa_index here and save it
+	 * in both sa_ctl->index and sa_frame->fast_sa_index;
+	 * If alloc fails then delete sa_ctl and return NULL
+	 */
+	INIT_LIST_HEAD(&sa_ctl->next);
+	sap = &sa_ctl->sa_frame;
+	*sap = *sa_frame;
+	sa_ctl->index = index;
+	sa_ctl->fcport = fcport;
+	sa_ctl->flags = 0;
+	sa_ctl->state = 0L;
+	ql_dbg(ql_dbg_edif, fcport->vha, 0x9100,
+	    "%s: Added sa_ctl %p, index %d, state 0x%lx\n",
+	    __func__, sa_ctl, sa_ctl->index, sa_ctl->state);
+	spin_lock_irqsave(&fcport->edif.sa_list_lock, flags);
+	if (dir == SAU_FLG_TX)
+		list_add_tail(&sa_ctl->next, &fcport->edif.tx_sa_list);
+	else
+		list_add_tail(&sa_ctl->next, &fcport->edif.rx_sa_list);
+	spin_unlock_irqrestore(&fcport->edif.sa_list_lock, flags);
+	return sa_ctl;
+}
+
+void
+qla_edif_flush_sa_ctl_lists(fc_port_t *fcport)
+{
+	struct edif_sa_ctl *sa_ctl, *tsa_ctl;
+	unsigned long flags = 0;
+
+	spin_lock_irqsave(&fcport->edif.sa_list_lock, flags);
+
+	list_for_each_entry_safe(sa_ctl, tsa_ctl, &fcport->edif.tx_sa_list,
+	    next) {
+		list_del(&sa_ctl->next);
+		kfree(sa_ctl);
+	}
+
+	list_for_each_entry_safe(sa_ctl, tsa_ctl, &fcport->edif.rx_sa_list,
+	    next) {
+		list_del(&sa_ctl->next);
+		kfree(sa_ctl);
+	}
+
+	spin_unlock_irqrestore(&fcport->edif.sa_list_lock, flags);
+}
+
+struct edif_sa_ctl *
+qla_edif_find_sa_ctl_by_index(fc_port_t *fcport, int index, int dir)
+{
+	struct edif_sa_ctl *sa_ctl, *tsa_ctl;
+	struct list_head *sa_list;
+
+	if (dir == SAU_FLG_TX)
+		sa_list = &fcport->edif.tx_sa_list;
+	else
+		sa_list = &fcport->edif.rx_sa_list;
+	list_for_each_entry_safe(sa_ctl, tsa_ctl, sa_list, next) {
+		if (test_bit(EDIF_SA_CTL_USED, &sa_ctl->state) &&
+		    sa_ctl->index == index)
+			return sa_ctl;
+	}
+	return NULL;
+}
+
+/* add the sa to the correct list */
+static int
+qla24xx_check_sadb_avail_slot(struct bsg_job *bsg_job, fc_port_t *fcport,
+	struct qla_sa_update_frame *sa_frame)
+{
+	struct edif_sa_ctl *sa_ctl = NULL;
+	int dir;
+	uint16_t sa_index;
+
+	dir = (sa_frame->flags & SAU_FLG_TX);
+
+	/* map the spi to an sa_index */
+	sa_index = qla_edif_sadb_get_sa_index(fcport, sa_frame);
+	if (sa_index == RX_DELETE_NO_EDIF_SA_INDEX) {
+		/* process rx delete */
+		ql_dbg(ql_dbg_edif, fcport->vha, 0x3063,
+		    "%s: rx delete for lid 0x%x, spi 0x%x, no entry found\n",
+		    __func__, fcport->loop_id, sa_frame->spi);
+
+		/* build and send the aen */
+		fcport->edif.rx_sa_set = 1;
+		fcport->edif.rx_sa_pending = 0;
+		qla_edb_eventcreate(fcport->vha,
+		    VND_CMD_AUTH_STATE_SAUPDATE_COMPL,
+		    QL_VND_SA_STAT_SUCCESS,
+		    QL_VND_RX_SA_KEY, fcport);
+
+		/* force a return of good bsg status; */
+		return RX_DELETE_NO_EDIF_SA_INDEX;
+	} else if (sa_index == INVALID_EDIF_SA_INDEX) {
+		ql_dbg(ql_dbg_edif, fcport->vha, 0x9100,
+		    "%s: Failed to get sa_index for spi 0x%x, dir: %d\n",
+		    __func__, sa_frame->spi, dir);
+		return INVALID_EDIF_SA_INDEX;
+	}
+
+	ql_dbg(ql_dbg_edif, fcport->vha, 0x9100,
+	    "%s: index %d allocated to spi 0x%x, dir: %d, nport_handle: 0x%x\n",
+	    __func__, sa_index, sa_frame->spi, dir, fcport->loop_id);
+
+	/* This is a local copy of sa_frame. */
+	sa_frame->fast_sa_index = sa_index;
+	/* create the sa_ctl */
+	sa_ctl = qla_edif_add_sa_ctl(fcport, sa_frame, dir);
+	if (!sa_ctl) {
+		ql_dbg(ql_dbg_edif, fcport->vha, 0x9100,
+		    "%s: Failed to add sa_ctl for spi 0x%x, dir: %d, sa_index: %d\n",
+		    __func__, sa_frame->spi, dir, sa_index);
+		return -1;
+	}
+
+	set_bit(EDIF_SA_CTL_USED, &sa_ctl->state);
+
+	if (dir == SAU_FLG_TX)
+		fcport->edif.tx_rekey_cnt++;
+	else
+		fcport->edif.rx_rekey_cnt++;
+
+	ql_dbg(ql_dbg_edif, fcport->vha, 0x9100,
+	    "%s: Found sa_ctl %p, index %d, state 0x%lx, tx_cnt %d, rx_cnt %d, nport_handle: 0x%x\n",
+	    __func__, sa_ctl, sa_ctl->index, sa_ctl->state,
+	    fcport->edif.tx_rekey_cnt,
+	    fcport->edif.rx_rekey_cnt, fcport->loop_id);
+	return 0;
+}
+
+#define QLA_SA_UPDATE_FLAGS_RX_KEY      0x0
+#define QLA_SA_UPDATE_FLAGS_TX_KEY      0x2
+
+int
+qla24xx_sadb_update(struct bsg_job *bsg_job)
+{
+	struct	fc_bsg_reply	*bsg_reply = bsg_job->reply;
+	struct Scsi_Host *host = fc_bsg_to_shost(bsg_job);
+	scsi_qla_host_t *vha = shost_priv(host);
+	fc_port_t		*fcport = NULL;
+	srb_t			*sp = NULL;
+	struct edif_list_entry *edif_entry = NULL;
+	int			found = 0;
+	int			rval = 0;
+	int result = 0;
+	struct qla_sa_update_frame sa_frame;
+	struct srb_iocb *iocb_cmd;
+
+	ql_dbg(ql_dbg_edif + ql_dbg_verbose, vha, 0x911d,
+	    "%s entered, vha: 0x%p\n", __func__, vha);
+
+	sg_copy_to_buffer(bsg_job->request_payload.sg_list,
+	    bsg_job->request_payload.sg_cnt, &sa_frame,
+	    sizeof(struct qla_sa_update_frame));
+
+	/* Check if host is online */
+	if (!vha->flags.online) {
+		ql_log(ql_log_warn, vha, 0x70a1, "Host is not online\n");
+		rval = -EIO;
+		SET_DID_STATUS(bsg_reply->result, DID_ERROR);
+		goto done;
+	}
+
+	if (vha->e_dbell.db_flags != EDB_ACTIVE) {
+		ql_log(ql_log_warn, vha, 0x70a1, "App not started\n");
+		rval = -EIO;
+		SET_DID_STATUS(bsg_reply->result, DID_ERROR);
+		goto done;
+	}
+
+	fcport = qla2x00_find_fcport_by_pid(vha, &sa_frame.port_id);
+	if (fcport) {
+		found = 1;
+		if (sa_frame.flags == QLA_SA_UPDATE_FLAGS_TX_KEY)
+			fcport->edif.tx_bytes = 0;
+		if (sa_frame.flags == QLA_SA_UPDATE_FLAGS_RX_KEY)
+			fcport->edif.rx_bytes = 0;
+	}
+
+	if (!found) {
+		ql_dbg(ql_dbg_edif, vha, 0x70a3, "Failed to find port= %06x\n",
+		    sa_frame.port_id.b24);
+		rval = -EINVAL;
+		SET_DID_STATUS(bsg_reply->result, DID_TARGET_FAILURE);
+		goto done;
+	}
+
+	/* make sure the nport_handle is valid */
+	if (fcport->loop_id == FC_NO_LOOP_ID) {
+		ql_dbg(ql_dbg_edif, vha, 0x70e1,
+		    "%s: %8phNn lid=FC_NO_LOOP_ID, spi: 0x%x, DS %d, returning NO_CONNECT\n",
+		    __func__, fcport->port_name, sa_frame.spi,
+		    fcport->disc_state);
+		rval = -EINVAL;
+		SET_DID_STATUS(bsg_reply->result, DID_NO_CONNECT);
+		goto done;
+	}
+
+	/* allocate and queue an sa_ctl */
+	result = qla24xx_check_sadb_avail_slot(bsg_job, fcport, &sa_frame);
+
+	/* failure of bsg */
+	if (result == INVALID_EDIF_SA_INDEX) {
+		ql_dbg(ql_dbg_edif, vha, 0x70e1,
+		    "%s: %8phNn, skipping update.\n",
+		    __func__, fcport->port_name);
+		rval = -EINVAL;
+		SET_DID_STATUS(bsg_reply->result, DID_ERROR);
+		goto done;
+
+	/* rx delete failure */
+	} else if (result == RX_DELETE_NO_EDIF_SA_INDEX) {
+		ql_dbg(ql_dbg_edif, vha, 0x70e1,
+		    "%s: %8phNn, skipping rx delete.\n",
+		    __func__, fcport->port_name);
+		SET_DID_STATUS(bsg_reply->result, DID_OK);
+		goto done;
+	}
+
+	ql_dbg(ql_dbg_edif, vha, 0x70e1,
+	    "%s: %8phNn, sa_index in sa_frame: %d flags %xh\n",
+	    __func__, fcport->port_name, sa_frame.fast_sa_index,
+	    sa_frame.flags);
+
+	/* looking for rx index and delete */
+	if (((sa_frame.flags & SAU_FLG_TX) == 0) &&
+	    (sa_frame.flags & SAU_FLG_INV)) {
+		uint16_t nport_handle = fcport->loop_id;
+		uint16_t sa_index = sa_frame.fast_sa_index;
+
+		/*
+		 * make sure we have an existing rx key, otherwise just process
+		 * this as a straight delete just like TX
+		 * This is NOT a normal case, it indicates an error recovery or key cleanup
+		 * by the ipsec code above us.
+		 */
+		edif_entry = qla_edif_list_find_sa_index(fcport, fcport->loop_id);
+		if (!edif_entry) {
+			ql_dbg(ql_dbg_edif, vha, 0x911d,
+	"%s: WARNING: no active sa_index for nport_handle 0x%x, forcing delete for sa_index 0x%x\n",
+			    __func__, fcport->loop_id, sa_index);
+			goto force_rx_delete;
+		}
+
+		/*
+		 * if we have a forced delete for rx, remove the sa_index from the edif list
+		 * and proceed with normal delete.  The rx delay timer should not be running
+		 */
+		if ((sa_frame.flags & SAU_FLG_FORCE_DELETE) == SAU_FLG_FORCE_DELETE) {
+			qla_edif_list_delete_sa_index(fcport, edif_entry);
+			ql_dbg(ql_dbg_edif, vha, 0x911d,
+	"%s: FORCE DELETE flag found for nport_handle 0x%x, sa_index 0x%x, forcing DELETE\n",
+			    __func__, fcport->loop_id, sa_index);
+			kfree(edif_entry);
+			goto force_rx_delete;
+		}
+
+		/*
+		 * delayed rx delete
+		 *
+		 * if delete_sa_index is not invalid then there is already
+		 * a delayed index in progress, return bsg bad status
+		 */
+		if (edif_entry->delete_sa_index != INVALID_EDIF_SA_INDEX) {
+			struct edif_sa_ctl *sa_ctl;
+
+			ql_dbg(ql_dbg_edif, vha, 0x911d,
+			    "%s: delete for lid 0x%x, delete_sa_index %d is pending\n",
+			    __func__, edif_entry->handle,
+			    edif_entry->delete_sa_index);
+
+			/* free up the sa_ctl that was allocated with the sa_index */
+			sa_ctl = qla_edif_find_sa_ctl_by_index(fcport, sa_index,
+			    (sa_frame.flags & SAU_FLG_TX));
+			if (sa_ctl) {
+				ql_dbg(ql_dbg_edif, vha, 0x3063,
+				    "%s: freeing sa_ctl for index %d\n",
+				    __func__, sa_ctl->index);
+				qla_edif_free_sa_ctl(fcport, sa_ctl, sa_ctl->index);
+			}
+
+			/* release the sa_index */
+			ql_dbg(ql_dbg_edif, vha, 0x3063,
+			    "%s: freeing sa_index %d, nph: 0x%x\n",
+			    __func__, sa_index, nport_handle);
+			qla_edif_sadb_delete_sa_index(fcport, nport_handle, sa_index);
+
+			rval = -EINVAL;
+			SET_DID_STATUS(bsg_reply->result, DID_ERROR);
+			goto done;
+		}
+
+		/* clean up edif flags/state */
+		fcport->edif.new_sa = 0;
+		fcport->edif.db_sent = 0;
+		fcport->edif.rekey = fcport->edif.reload_value;
+		fcport->edif.rekey_cnt++;
+
+		/* configure and start the rx delay timer */
+		edif_entry->fcport = fcport;
+		edif_entry->timer.expires = jiffies + RX_DELAY_DELETE_TIMEOUT * HZ;
+
+		ql_dbg(ql_dbg_edif, vha, 0x911d,
+	"%s: adding timer, entry: %p, delete sa_index %d, lid 0x%x to edif_list\n",
+		    __func__, edif_entry, sa_index, nport_handle);
+
+		/*
+		 * Start the timer when we queue the delayed rx delete.
+		 * This is an activity timer that goes off if we have not
+		 * received packets with the new sa_index
+		 */
+		add_timer(&edif_entry->timer);
+
+		/*
+		 * sa_delete for rx key with an active rx key including this one
+		 * add the delete rx sa index to the hash so we can look for it
+		 * in the rsp queue.  Do this after making any changes to the
+		 * edif_entry as part of the rx delete.
+		 */
+
+		ql_dbg(ql_dbg_edif, vha, 0x911d,
+		    "%s: delete sa_index %d, lid 0x%x to edif_list. bsg done ptr %p\n",
+		    __func__, sa_index, nport_handle, bsg_job);
+
+		edif_entry->delete_sa_index = sa_index;
+
+		bsg_job->reply_len = sizeof(struct fc_bsg_reply);
+		bsg_reply->result = DID_OK << 16;
+
+		goto done;
+
+	/*
+	 * rx index and update
+	 * add the index to the list and continue with normal update
+	 */
+	} else if (((sa_frame.flags & SAU_FLG_TX) == 0) &&
+	    ((sa_frame.flags & SAU_FLG_INV) == 0)) {
+		/* sa_update for rx key */
+		uint32_t nport_handle = fcport->loop_id;
+		uint16_t sa_index = sa_frame.fast_sa_index;
+		int result;
+
+		/*
+		 * add the update rx sa index to the hash so we can look for it
+		 * in the rsp queue and continue normally
+		 */
+
+		ql_dbg(ql_dbg_edif, vha, 0x911d,
+		    "%s:  adding update sa_index %d, lid 0x%x to edif_list\n",
+		    __func__, sa_index, nport_handle);
+
+		result = qla_edif_list_add_sa_update_index(fcport, sa_index,
+		    nport_handle);
+		if (result) {
+			ql_dbg(ql_dbg_edif, vha, 0x911d,
+	"%s: SA_UPDATE failed to add new sa index %d to list for lid 0x%x\n",
+			    __func__, sa_index, nport_handle);
+		}
+	}
+	if (sa_frame.flags & SAU_FLG_GMAC_MODE)
+		fcport->edif.aes_gmac = 1;
+	else
+		fcport->edif.aes_gmac = 0;
+
+force_rx_delete:
+	/*
+	 * sa_update for both rx and tx keys, sa_delete for tx key
+	 * immediately process the request
+	 */
+	sp = qla2x00_get_sp(vha, fcport, GFP_KERNEL);
+	if (!sp) {
+		rval = -ENOMEM;
+		SET_DID_STATUS(bsg_reply->result, DID_IMM_RETRY);
+		goto done;
+	}
+
+	sp->type = SRB_SA_UPDATE;
+	sp->name = "bsg_sa_update";
+	sp->u.bsg_job = bsg_job;
+	/* sp->free = qla2x00_bsg_sp_free; */
+	sp->free = qla2x00_rel_sp;
+	sp->done = qla2x00_bsg_job_done;
+	iocb_cmd = &sp->u.iocb_cmd;
+	iocb_cmd->u.sa_update.sa_frame  = sa_frame;
+
+	rval = qla2x00_start_sp(sp);
+	if (rval != QLA_SUCCESS) {
+		ql_log(ql_dbg_edif, vha, 0x70e3,
+		    "qla2x00_start_sp failed=%d.\n", rval);
+
+		qla2x00_rel_sp(sp);
+		rval = -EIO;
+		SET_DID_STATUS(bsg_reply->result, DID_IMM_RETRY);
+		goto done;
+	}
+
+	/* clean up edif flags/state */
+	fcport->edif.new_sa = 0;			/* NOT USED ??? */
+	fcport->edif.db_sent = 0;			/* NOT USED ??? */
+	fcport->edif.rekey = fcport->edif.reload_value;
+
+	ql_dbg(ql_dbg_edif, vha, 0x911d,
+	    "%s:  %s sent, hdl=%x, portid=%06x.\n",
+	    __func__, sp->name, sp->handle, fcport->d_id.b24);
+
+	fcport->edif.rekey_cnt++;
+	bsg_job->reply_len = sizeof(struct fc_bsg_reply);
+	SET_DID_STATUS(bsg_reply->result, DID_OK);
+
+	return 0;
+
+/*
+ * send back error status
+ */
+done:
+	bsg_job->reply_len = sizeof(struct fc_bsg_reply);
+	ql_dbg(ql_dbg_edif, vha, 0x911d,
+	    "%s:status: FAIL, result: 0x%x, bsg ptr done %p\n",
+	    __func__, bsg_reply->result, bsg_job);
+	bsg_job_done(bsg_job, bsg_reply->result,
+	    bsg_reply->reply_payload_rcv_len);
+	return 0;
+}
+
+static void
+qla_enode_free(scsi_qla_host_t *vha, struct enode *node)
+{
+	/*
+	 * releases the space held by this enode entry
+	 * this function does _not_ free the enode itself
+	 * NB: the pur node entry passed should not be on any list
+	 */
+
+	if (!node) {
+		ql_dbg(ql_dbg_edif, vha, 0x09122,
+		    "%s error - no valid node passed\n", __func__);
+		return;
+	}
+
+	node->dinfo.lstate = LSTATE_DEST;
+	node->ntype = N_UNDEF;
+	kfree(node);
+}
+
+/*
+ * function to initialize enode structs & lock
+ * NB: should only be called when driver attaching
+ */
+void
+qla_enode_init(scsi_qla_host_t *vha)
+{
+	struct	qla_hw_data *ha = vha->hw;
+	char	name[32];
+
+	if (vha->pur_cinfo.enode_flags == ENODE_ACTIVE) {
+		/* list still active - error */
+		ql_dbg(ql_dbg_edif, vha, 0x09102, "%s enode still active\n",
+		    __func__);
+		return;
+	}
+
+	/* initialize lock which protects pur_core & init list */
+	spin_lock_init(&vha->pur_cinfo.pur_lock);
+	INIT_LIST_HEAD(&vha->pur_cinfo.head);
+
+	snprintf(name, sizeof(name), "%s_%d_purex", QLA2XXX_DRIVER_NAME,
+	    ha->pdev->device);
+}
+
+/*
+ * function to stop and clear and enode data
+ * called when app notified it is stopping
+ */
+
+void
+qla_enode_stop(scsi_qla_host_t *vha)
+{
+	unsigned long flags;
+	struct enode *node, *q;
+
+	if (vha->pur_cinfo.enode_flags != ENODE_ACTIVE) {
+		/* doorbell list not enabled */
+		ql_dbg(ql_dbg_edif, vha, 0x09102,
+		    "%s enode not active\n", __func__);
+		return;
+	}
+
+	/* grab lock so list doesn't move */
+	spin_lock_irqsave(&vha->pur_cinfo.pur_lock, flags);
+
+	vha->pur_cinfo.enode_flags &= ~ENODE_ACTIVE; /* mark it not active */
+
+	/* hopefully this is a null list at this point */
+	list_for_each_entry_safe(node, q, &vha->pur_cinfo.head, list) {
+		ql_dbg(ql_dbg_edif, vha, 0x910f,
+		    "%s freeing enode type=%x, cnt=%x\n", __func__, node->ntype,
+		    node->dinfo.nodecnt);
+		list_del_init(&node->list);
+		spin_unlock_irqrestore(&vha->pur_cinfo.pur_lock, flags);
+		qla_enode_free(vha, node);
+		spin_lock_irqsave(&vha->pur_cinfo.pur_lock, flags);
+	}
+	spin_unlock_irqrestore(&vha->pur_cinfo.pur_lock, flags);
+}
+
+/*
+ *  allocate enode struct and populate buffer
+ *  returns: enode pointer with buffers
+ *           NULL on error
+ */
+static struct enode *
+qla_enode_alloc(scsi_qla_host_t *vha, uint32_t ntype)
+{
+	struct enode		*node;
+	struct purexevent	*purex;
+
+	node = kzalloc(RX_ELS_SIZE, GFP_ATOMIC);
+	if (!node)
+		return NULL;
+
+	purex = &node->u.purexinfo;
+	purex->msgp = (u8 *)(node + 1);
+	purex->msgp_len = ELS_MAX_PAYLOAD;
+
+	node->dinfo.lstate = LSTATE_OFF;
+
+	node->ntype = ntype;
+	INIT_LIST_HEAD(&node->list);
+	return node;
+}
+
+/* adds a already alllocated enode to the linked list */
+static bool
+qla_enode_add(scsi_qla_host_t *vha, struct enode *ptr)
+{
+	unsigned long flags;
+
+	ql_dbg(ql_dbg_edif + ql_dbg_verbose, vha, 0x9109,
+	    "%s add enode for type=%x, cnt=%x\n",
+	    __func__, ptr->ntype, ptr->dinfo.nodecnt);
+
+	spin_lock_irqsave(&vha->pur_cinfo.pur_lock, flags);
+	ptr->dinfo.lstate = LSTATE_ON;
+	list_add_tail(&ptr->list, &vha->pur_cinfo.head);
+	spin_unlock_irqrestore(&vha->pur_cinfo.pur_lock, flags);
+
+	return true;
+}
+
+static struct enode *
+qla_enode_find(scsi_qla_host_t *vha, uint32_t ntype, uint32_t p1, uint32_t p2)
+{
+	struct enode			*node_rtn = NULL;
+	struct enode			*list_node = NULL;
+	unsigned long		flags;
+	struct list_head	*pos, *q;
+
+	uint32_t		sid;
+	uint32_t		rw_flag;
+
+	struct purexevent		*purex;
+
+	/* secure the list from moving under us */
+	spin_lock_irqsave(&vha->pur_cinfo.pur_lock, flags);
+
+	list_for_each_safe(pos, q, &vha->pur_cinfo.head) {
+		list_node = list_entry(pos, struct enode, list);
+
+		/* node type determines what p1 and p2 are */
+
+			purex = &list_node->u.purexinfo;
+			sid = p1;
+			rw_flag = p2;
+
+			if (purex->pur_info.pur_sid.b24 == sid) {
+				if (purex->pur_info.pur_pend == 1 &&
+				    rw_flag == PUR_GET) {
+					/*
+					 * if the receive is in progress
+					 * and its a read/get then can't
+					 * transfer yet
+					 */
+					ql_dbg(ql_dbg_edif, vha, 0x9106,
+					    "%s purex xfer in progress for sid=%x\n",
+					    __func__, sid);
+				} else {
+					/* found it and its complete */
+					node_rtn = list_node;
+				}
+			}
+
+		if (node_rtn) {
+			/*
+			 * found node that we're looking for so take it
+			 * off the list and return it to the caller
+			 */
+			list_del(pos);
+			list_node->dinfo.lstate = LSTATE_OFF;
+			break;
+		}
+	}
+
+	spin_unlock_irqrestore(&vha->pur_cinfo.pur_lock, flags);
+
+	return node_rtn;
+}
+
+/*
+ * Return number of bytes of purex payload pending for consumption
+ */
+static int
+qla_pur_get_pending(scsi_qla_host_t *vha, fc_port_t *fcport, struct bsg_job *bsg_job)
+{
+	struct enode		*ptr;
+	struct purexevent	*purex;
+	struct qla_bsg_auth_els_reply *rpl =
+	    (struct qla_bsg_auth_els_reply *)bsg_job->reply;
+
+	bsg_job->reply_len = sizeof(*rpl);
+
+	ptr = qla_enode_find(vha, N_PUREX, fcport->d_id.b24, PUR_GET);
+	if (!ptr) {
+		ql_dbg(ql_dbg_edif, vha, 0x9111,
+		    "%s no enode data found for %8phN sid=%06x\n",
+		    __func__, fcport->port_name, fcport->d_id.b24);
+		SET_DID_STATUS(rpl->r.result, DID_IMM_RETRY);
+		return -EIO;
+	}
+
+	/*
+	 * enode is now off the linked list and is ours to deal with
+	 */
+	purex = &ptr->u.purexinfo;
+
+	/* Copy info back to caller */
+	rpl->rx_xchg_address = purex->pur_info.pur_rx_xchg_address;
+
+	SET_DID_STATUS(rpl->r.result, DID_OK);
+	rpl->r.reply_payload_rcv_len =
+	    sg_pcopy_from_buffer(bsg_job->reply_payload.sg_list,
+		bsg_job->reply_payload.sg_cnt, purex->msgp,
+		purex->pur_info.pur_bytes_rcvd, 0);
+
+	/* data copy / passback completed - destroy enode */
+	qla_enode_free(vha, ptr);
+
+	return 0;
+}
+
+/* it is assume qpair lock is held */
+static int
+qla_els_reject_iocb(scsi_qla_host_t *vha, struct qla_qpair *qp,
+	struct qla_els_pt_arg *a)
+{
+	struct els_entry_24xx *els_iocb;
+
+	els_iocb = __qla2x00_alloc_iocbs(qp, NULL);
+	if (!els_iocb) {
+		ql_log(ql_log_warn, vha, 0x700c,
+		    "qla2x00_alloc_iocbs failed.\n");
+		return QLA_FUNCTION_FAILED;
+	}
+
+	qla_els_pt_iocb(vha, els_iocb, a);
+
+	ql_dbg(ql_dbg_edif, vha, 0x0183,
+	    "Sending ELS reject...\n");
+	ql_dump_buffer(ql_dbg_edif + ql_dbg_verbose, vha, 0x0185,
+	    vha->hw->elsrej.c, sizeof(*vha->hw->elsrej.c));
+	/* -- */
+	wmb();
+	qla2x00_start_iocbs(vha, qp->req);
+	return 0;
+}
+
+void
+qla_edb_init(scsi_qla_host_t *vha)
+{
+	if (vha->e_dbell.db_flags == EDB_ACTIVE) {
+		/* list already init'd - error */
+		ql_dbg(ql_dbg_edif, vha, 0x09102,
+		    "edif db already initialized, cannot reinit\n");
+		return;
+	}
+
+	/* initialize lock which protects doorbell & init list */
+	spin_lock_init(&vha->e_dbell.db_lock);
+	INIT_LIST_HEAD(&vha->e_dbell.head);
+
+	/* create and initialize doorbell */
+	init_completion(&vha->e_dbell.dbell);
+}
+
+static void
+qla_edb_node_free(scsi_qla_host_t *vha, struct edb_node *node)
+{
+	/*
+	 * releases the space held by this edb node entry
+	 * this function does _not_ free the edb node itself
+	 * NB: the edb node entry passed should not be on any list
+	 *
+	 * currently for doorbell there's no additional cleanup
+	 * needed, but here as a placeholder for furture use.
+	 */
+
+	if (!node) {
+		ql_dbg(ql_dbg_edif, vha, 0x09122,
+		    "%s error - no valid node passed\n", __func__);
+		return;
+	}
+
+	node->lstate = LSTATE_DEST;
+	node->ntype = N_UNDEF;
+}
+
+/* function called when app is stopping */
+
+void
+qla_edb_stop(scsi_qla_host_t *vha)
+{
+	unsigned long flags;
+	struct edb_node *node, *q;
+
+	if (vha->e_dbell.db_flags != EDB_ACTIVE) {
+		/* doorbell list not enabled */
+		ql_dbg(ql_dbg_edif, vha, 0x09102,
+		    "%s doorbell not enabled\n", __func__);
+		return;
+	}
+
+	/* grab lock so list doesn't move */
+	spin_lock_irqsave(&vha->e_dbell.db_lock, flags);
+
+	vha->e_dbell.db_flags &= ~EDB_ACTIVE; /* mark it not active */
+	/* hopefully this is a null list at this point */
+	list_for_each_entry_safe(node, q, &vha->e_dbell.head, list) {
+		ql_dbg(ql_dbg_edif, vha, 0x910f,
+		    "%s freeing edb_node type=%x\n",
+		    __func__, node->ntype);
+		qla_edb_node_free(vha, node);
+		list_del(&node->list);
+
+		spin_unlock_irqrestore(&vha->e_dbell.db_lock, flags);
+		kfree(node);
+		spin_lock_irqsave(&vha->e_dbell.db_lock, flags);
+	}
+	spin_unlock_irqrestore(&vha->e_dbell.db_lock, flags);
+
+	/* wake up doorbell waiters - they'll be dismissed with error code */
+	complete_all(&vha->e_dbell.dbell);
+}
+
+static struct edb_node *
+qla_edb_node_alloc(scsi_qla_host_t *vha, uint32_t ntype)
+{
+	struct edb_node	*node;
+
+	node = kzalloc(sizeof(*node), GFP_ATOMIC);
+	if (!node) {
+		/* couldn't get space */
+		ql_dbg(ql_dbg_edif, vha, 0x9100,
+		    "edb node unable to be allocated\n");
+		return NULL;
+	}
+
+	node->lstate = LSTATE_OFF;
+	node->ntype = ntype;
+	INIT_LIST_HEAD(&node->list);
+	return node;
+}
+
+/* adds a already alllocated enode to the linked list */
+static bool
+qla_edb_node_add(scsi_qla_host_t *vha, struct edb_node *ptr)
+{
+	unsigned long		flags;
+
+	if (ptr->lstate != LSTATE_OFF) {
+		ql_dbg(ql_dbg_edif, vha, 0x911a,
+		    "%s error edb node(%p) state=%x\n",
+		    __func__, ptr, ptr->lstate);
+		return false;
+	}
+
+	if (vha->e_dbell.db_flags != EDB_ACTIVE) {
+		/* doorbell list not enabled */
+		ql_dbg(ql_dbg_edif, vha, 0x09102,
+		    "%s doorbell not enabled\n", __func__);
+		return false;
+	}
+
+	spin_lock_irqsave(&vha->e_dbell.db_lock, flags);
+	ptr->lstate = LSTATE_ON;
+	list_add_tail(&ptr->list, &vha->e_dbell.head);
+	spin_unlock_irqrestore(&vha->e_dbell.db_lock, flags);
+
+	/* ring doorbell for waiters */
+	complete(&vha->e_dbell.dbell);
+
+	return true;
+}
+
+/* adds event to doorbell list */
+void
+qla_edb_eventcreate(scsi_qla_host_t *vha, uint32_t dbtype,
+	uint32_t data, uint32_t data2, fc_port_t	*sfcport)
+{
+	struct edb_node	*edbnode;
+	fc_port_t *fcport = sfcport;
+	port_id_t id;
+
+	if (!vha->hw->flags.edif_enabled) {
+		/* edif not enabled */
+		return;
+	}
+
+	if (vha->e_dbell.db_flags != EDB_ACTIVE) {
+		if (fcport)
+			fcport->edif.auth_state = dbtype;
+		/* doorbell list not enabled */
+		ql_dbg(ql_dbg_edif, vha, 0x09102,
+		    "%s doorbell not enabled (type=%d\n", __func__, dbtype);
+		return;
+	}
+
+	edbnode = qla_edb_node_alloc(vha, dbtype);
+	if (!edbnode) {
+		ql_dbg(ql_dbg_edif, vha, 0x09102,
+		    "%s unable to alloc db node\n", __func__);
+		return;
+	}
+
+	if (!fcport) {
+		id.b.domain = (data >> 16) & 0xff;
+		id.b.area = (data >> 8) & 0xff;
+		id.b.al_pa = data & 0xff;
+		ql_dbg(ql_dbg_edif, vha, 0x09222,
+		    "%s: Arrived s_id: %06x\n", __func__,
+		    id.b24);
+		fcport = qla2x00_find_fcport_by_pid(vha, &id);
+		if (!fcport) {
+			ql_dbg(ql_dbg_edif, vha, 0x09102,
+			    "%s can't find fcport for sid= 0x%x - ignoring\n",
+			__func__, id.b24);
+			kfree(edbnode);
+			return;
+		}
+	}
+
+	/* populate the edb node */
+	switch (dbtype) {
+	case VND_CMD_AUTH_STATE_NEEDED:
+	case VND_CMD_AUTH_STATE_SESSION_SHUTDOWN:
+		edbnode->u.plogi_did.b24 = fcport->d_id.b24;
+		break;
+	case VND_CMD_AUTH_STATE_ELS_RCVD:
+		edbnode->u.els_sid.b24 = fcport->d_id.b24;
+		break;
+	case VND_CMD_AUTH_STATE_SAUPDATE_COMPL:
+		edbnode->u.sa_aen.port_id = fcport->d_id;
+		edbnode->u.sa_aen.status =  data;
+		edbnode->u.sa_aen.key_type =  data2;
+		break;
+	default:
+		ql_dbg(ql_dbg_edif, vha, 0x09102,
+			"%s unknown type: %x\n", __func__, dbtype);
+		qla_edb_node_free(vha, edbnode);
+		kfree(edbnode);
+		edbnode = NULL;
+		break;
+	}
+
+	if (edbnode && (!qla_edb_node_add(vha, edbnode))) {
+		ql_dbg(ql_dbg_edif, vha, 0x09102,
+		    "%s unable to add dbnode\n", __func__);
+		qla_edb_node_free(vha, edbnode);
+		kfree(edbnode);
+		return;
+	}
+	if (edbnode && fcport)
+		fcport->edif.auth_state = dbtype;
+	ql_dbg(ql_dbg_edif, vha, 0x09102,
+	    "%s Doorbell produced : type=%d %p\n", __func__, dbtype, edbnode);
+}
+
+static struct edb_node *
+qla_edb_getnext(scsi_qla_host_t *vha)
+{
+	unsigned long	flags;
+	struct edb_node	*edbnode = NULL;
+
+	spin_lock_irqsave(&vha->e_dbell.db_lock, flags);
+
+	/* db nodes are fifo - no qualifications done */
+	if (!list_empty(&vha->e_dbell.head)) {
+		edbnode = list_first_entry(&vha->e_dbell.head,
+		    struct edb_node, list);
+		list_del(&edbnode->list);
+		edbnode->lstate = LSTATE_OFF;
+	}
+
+	spin_unlock_irqrestore(&vha->e_dbell.db_lock, flags);
+
+	return edbnode;
+}
+
+/*
+ * dec timer for edif enabled devices which are time based.
+ * check all edif enabled devices for rekey notification
+ */
+void
+qla_edif_timer_check(scsi_qla_host_t *vha)
+{
+	struct fc_port	*fcport, *tf;
+
+	list_for_each_entry_safe(fcport, tf, &vha->vp_fcports, list) {
+		if (fcport->edif.enable &&
+		    fcport->disc_state == DSC_LOGIN_AUTH_PEND) {
+			fcport->edif.prli_to -= EDIF_TICK;
+			if (fcport->edif.prli_to == 0) {
+				ql_dbg(ql_dbg_edif, vha, 0x09222,
+					"%s login timeout for d_id: %06x / wwpn:%8phC\n",
+					__func__, fcport->d_id.b24,
+					fcport->port_name);
+
+				/* timeout waiting for app - cleanup */
+				/* qlt_schedule_sess_for_deletion(fcport); */
+			}
+		}
+	}
+}
+
+/*
+ * app uses separate thread to read this. It'll wait until the doorbell
+ * is rung by the driver or the max wait time has expired
+ */
+ssize_t
+edif_doorbell_show(struct device *dev, struct device_attribute *attr,
+		char *buf)
+{
+	scsi_qla_host_t *vha = shost_priv(class_to_shost(dev));
+	struct edb_node	*dbnode = NULL;
+	struct edif_app_dbell *ap = (struct edif_app_dbell *)buf;
+	uint32_t dat_siz, buf_size, sz;
+
+	sz = 256; /* app currently hardcode to 256. */
+
+	/* stop new threads from waiting if we're not init'd */
+	if (vha->e_dbell.db_flags != EDB_ACTIVE) {
+		ql_dbg(ql_dbg_edif + ql_dbg_verbose, vha, 0x09122,
+		    "%s error - edif db not enabled\n", __func__);
+		return 0;
+	}
+
+	if (!vha->hw->flags.edif_enabled) {
+		/* edif not enabled */
+		ql_dbg(ql_dbg_edif + ql_dbg_verbose, vha, 0x09122,
+		    "%s error - edif not enabled\n", __func__);
+		return -1;
+	}
+
+	buf_size = 0;
+	while ((sz - buf_size) >= sizeof(struct edb_node)) {
+		/* remove the next item from the doorbell list */
+		dat_siz = 0;
+		dbnode = qla_edb_getnext(vha);
+		if (dbnode) {
+			ap->event_code = dbnode->ntype;
+			switch (dbnode->ntype) {
+			case VND_CMD_AUTH_STATE_SESSION_SHUTDOWN:
+			case VND_CMD_AUTH_STATE_NEEDED:
+				ap->port_id = dbnode->u.plogi_did;
+				dat_siz += sizeof(ap->port_id);
+				break;
+			case VND_CMD_AUTH_STATE_ELS_RCVD:
+				ap->port_id = dbnode->u.els_sid;
+				dat_siz += sizeof(ap->port_id);
+				break;
+			case VND_CMD_AUTH_STATE_SAUPDATE_COMPL:
+				ap->port_id = dbnode->u.sa_aen.port_id;
+				memcpy(ap->event_data, &dbnode->u,
+						sizeof(struct edif_sa_update_aen));
+				dat_siz += sizeof(struct edif_sa_update_aen);
+				break;
+			default:
+				/* unknown node type, rtn unknown ntype */
+				ap->event_code = VND_CMD_AUTH_STATE_UNDEF;
+				memcpy(ap->event_data, &dbnode->ntype, 4);
+				dat_siz += 4;
+				break;
+			}
+
+			ql_dbg(ql_dbg_edif, vha, 0x09102,
+				"%s Doorbell consumed : type=%d %p\n",
+				__func__, dbnode->ntype, dbnode);
+			/* we're done with the db node, so free it up */
+			qla_edb_node_free(vha, dbnode);
+			kfree(dbnode);
+		} else {
+			break;
+		}
+
+		ap->event_data_size = dat_siz;
+		/* 8bytes = ap->event_code + ap->event_data_size */
+		buf_size += dat_siz + 8;
+		ap = (struct edif_app_dbell *)(buf + buf_size);
+	}
+	return buf_size;
+}
+
+void
+ql_print_bsg_sglist(uint level, scsi_qla_host_t *vha, uint id, char *str,
+		struct bsg_buffer *p)
+{
+	struct scatterlist *sg;
+	uint i;
+
+	ql_dbg(level, vha, id,
+	    "%s->(sg_cnt=%#x payload_len=%#x):\n",
+	    str, p->sg_cnt, p->payload_len);
+	for_each_sg(p->sg_list, sg, p->sg_cnt, i) {
+		ql_dbg(level, vha, id,
+		    "%x: dma(adr=%#llx len=%#x) off=%#x len=%#x\n",
+		    i, sg_dma_address(sg), sg_dma_len(sg), sg->offset,
+		    sg->length);
+	}
+}
+
+static void qla_noop_sp_done(srb_t *sp, int res)
+{
+	sp->free(sp);
+}
+
+/*
+ * Called from work queue
+ * build and send the sa_update iocb to delete an rx sa_index
+ */
+int
+qla24xx_issue_sa_replace_iocb(scsi_qla_host_t *vha, struct qla_work_evt *e)
+{
+	srb_t *sp;
+	fc_port_t	*fcport = NULL;
+	struct srb_iocb *iocb_cmd = NULL;
+	int rval = QLA_SUCCESS;
+	struct	edif_sa_ctl *sa_ctl = e->u.sa_update.sa_ctl;
+	uint16_t nport_handle = e->u.sa_update.nport_handle;
+
+	ql_dbg(ql_dbg_edif, vha, 0x70e6,
+	    "%s: starting,  sa_ctl: %p\n", __func__, sa_ctl);
+
+	if (!sa_ctl) {
+		ql_dbg(ql_dbg_edif, vha, 0x70e6,
+		    "sa_ctl allocation failed\n");
+		return -ENOMEM;
+	}
+
+	fcport = sa_ctl->fcport;
+
+	/* Alloc SRB structure */
+	sp = qla2x00_get_sp(vha, fcport, GFP_KERNEL);
+	if (!sp) {
+		ql_dbg(ql_dbg_edif, vha, 0x70e6,
+		 "SRB allocation failed\n");
+		return -ENOMEM;
+	}
+
+	fcport->flags |= FCF_ASYNC_SENT;
+	iocb_cmd = &sp->u.iocb_cmd;
+	iocb_cmd->u.sa_update.sa_ctl = sa_ctl;
+
+	ql_dbg(ql_dbg_edif, vha, 0x3073,
+	    "Enter: SA REPL portid=%06x, sa_ctl %p, index %x, nport_handle: 0x%x\n",
+	    fcport->d_id.b24, sa_ctl, sa_ctl->index, nport_handle);
+	/*
+	 * if this is a sadb cleanup delete, mark it so the isr can
+	 * take the correct action
+	 */
+	if (sa_ctl->flags & EDIF_SA_CTL_FLG_CLEANUP_DEL) {
+		/* mark this srb as a cleanup delete */
+		sp->flags |= SRB_EDIF_CLEANUP_DELETE;
+		ql_dbg(ql_dbg_edif, vha, 0x70e6,
+		    "%s: sp 0x%p flagged as cleanup delete\n", __func__, sp);
+	}
+
+	sp->type = SRB_SA_REPLACE;
+	sp->name = "SA_REPLACE";
+	sp->fcport = fcport;
+	sp->free = qla2x00_rel_sp;
+	sp->done = qla_noop_sp_done;
+
+	rval = qla2x00_start_sp(sp);
+
+	if (rval != QLA_SUCCESS)
+		rval = QLA_FUNCTION_FAILED;
+
+	return rval;
+}
+
+void qla24xx_sa_update_iocb(srb_t *sp, struct sa_update_28xx *sa_update_iocb)
+{
+	int	itr = 0;
+	struct	scsi_qla_host		*vha = sp->vha;
+	struct	qla_sa_update_frame	*sa_frame =
+		&sp->u.iocb_cmd.u.sa_update.sa_frame;
+	u8 flags = 0;
+
+	switch (sa_frame->flags & (SAU_FLG_INV | SAU_FLG_TX)) {
+	case 0:
+		ql_dbg(ql_dbg_edif, vha, 0x911d,
+		    "%s: EDIF SA UPDATE RX IOCB  vha: 0x%p  index: %d\n",
+		    __func__, vha, sa_frame->fast_sa_index);
+		break;
+	case 1:
+		ql_dbg(ql_dbg_edif, vha, 0x911d,
+		    "%s: EDIF SA DELETE RX IOCB  vha: 0x%p  index: %d\n",
+		    __func__, vha, sa_frame->fast_sa_index);
+		flags |= SA_FLAG_INVALIDATE;
+		break;
+	case 2:
+		ql_dbg(ql_dbg_edif, vha, 0x911d,
+		    "%s: EDIF SA UPDATE TX IOCB  vha: 0x%p  index: %d\n",
+		    __func__, vha, sa_frame->fast_sa_index);
+		flags |= SA_FLAG_TX;
+		break;
+	case 3:
+		ql_dbg(ql_dbg_edif, vha, 0x911d,
+		    "%s: EDIF SA DELETE TX IOCB  vha: 0x%p  index: %d\n",
+		    __func__, vha, sa_frame->fast_sa_index);
+		flags |= SA_FLAG_TX | SA_FLAG_INVALIDATE;
+		break;
+	}
+
+	sa_update_iocb->entry_type = SA_UPDATE_IOCB_TYPE;
+	sa_update_iocb->entry_count = 1;
+	sa_update_iocb->sys_define = 0;
+	sa_update_iocb->entry_status = 0;
+	sa_update_iocb->handle = sp->handle;
+	sa_update_iocb->u.nport_handle = cpu_to_le16(sp->fcport->loop_id);
+	sa_update_iocb->vp_index = sp->fcport->vha->vp_idx;
+	sa_update_iocb->port_id[0] = sp->fcport->d_id.b.al_pa;
+	sa_update_iocb->port_id[1] = sp->fcport->d_id.b.area;
+	sa_update_iocb->port_id[2] = sp->fcport->d_id.b.domain;
+
+	sa_update_iocb->flags = flags;
+	sa_update_iocb->salt = cpu_to_le32(sa_frame->salt);
+	sa_update_iocb->spi = cpu_to_le32(sa_frame->spi);
+	sa_update_iocb->sa_index = cpu_to_le16(sa_frame->fast_sa_index);
+
+	sa_update_iocb->sa_control |= SA_CNTL_ENC_FCSP;
+	if (sp->fcport->edif.aes_gmac)
+		sa_update_iocb->sa_control |= SA_CNTL_AES_GMAC;
+
+	if (sa_frame->flags & SAU_FLG_KEY256) {
+		sa_update_iocb->sa_control |= SA_CNTL_KEY256;
+		for (itr = 0; itr < 32; itr++)
+			sa_update_iocb->sa_key[itr] = sa_frame->sa_key[itr];
+
+		ql_dbg(ql_dbg_edif + ql_dbg_verbose, vha, 0x921f, "%s 256 sa key=%32phN\n",
+		    __func__, sa_update_iocb->sa_key);
+	} else {
+		sa_update_iocb->sa_control |= SA_CNTL_KEY128;
+		for (itr = 0; itr < 16; itr++)
+			sa_update_iocb->sa_key[itr] = sa_frame->sa_key[itr];
+
+		ql_dbg(ql_dbg_edif +  ql_dbg_verbose, vha, 0x921f, "%s 128 sa key=%16phN\n",
+		    __func__, sa_update_iocb->sa_key);
+	}
+
+	ql_dbg(ql_dbg_edif, vha, 0x921d,
+"%s SAU Port ID = %02x:%02x:%02x, flags=%xh, index=%u, ctl=%xh, SPI 0x%x user flags 0x%x hdl=%x gmac %d\n",
+	    __func__, sa_update_iocb->port_id[2],
+	    sa_update_iocb->port_id[1], sa_update_iocb->port_id[0],
+	    sa_update_iocb->flags, sa_update_iocb->sa_index,
+	    sa_update_iocb->sa_control, sa_update_iocb->spi,
+	    sa_frame->flags, sp->handle, sp->fcport->edif.aes_gmac);
+
+	if (sa_frame->flags & SAU_FLG_TX)
+		sp->fcport->edif.tx_sa_pending = 1;
+	else
+		sp->fcport->edif.rx_sa_pending = 1;
+
+	sp->fcport->vha->qla_stats.control_requests++;
+}
+
+void
+qla24xx_sa_replace_iocb(srb_t *sp, struct sa_update_28xx *sa_update_iocb)
+{
+	struct	scsi_qla_host		*vha = sp->vha;
+	struct srb_iocb *srb_iocb = &sp->u.iocb_cmd;
+	struct	edif_sa_ctl		*sa_ctl = srb_iocb->u.sa_update.sa_ctl;
+	uint16_t nport_handle = sp->fcport->loop_id;
+
+	sa_update_iocb->entry_type = SA_UPDATE_IOCB_TYPE;
+	sa_update_iocb->entry_count = 1;
+	sa_update_iocb->sys_define = 0;
+	sa_update_iocb->entry_status = 0;
+	sa_update_iocb->handle = sp->handle;
+
+	sa_update_iocb->u.nport_handle = cpu_to_le16(nport_handle);
+
+	sa_update_iocb->vp_index = sp->fcport->vha->vp_idx;
+	sa_update_iocb->port_id[0] = sp->fcport->d_id.b.al_pa;
+	sa_update_iocb->port_id[1] = sp->fcport->d_id.b.area;
+	sa_update_iocb->port_id[2] = sp->fcport->d_id.b.domain;
+
+	/* Invalidate the index. salt, spi, control & key are ignore */
+	sa_update_iocb->flags = SA_FLAG_INVALIDATE;
+	sa_update_iocb->salt = 0;
+	sa_update_iocb->spi = 0;
+	sa_update_iocb->sa_index = cpu_to_le16(sa_ctl->index);
+	sa_update_iocb->sa_control = 0;
+
+	ql_dbg(ql_dbg_edif, vha, 0x921d,
+	    "%s SAU DELETE RX Port ID = %02x:%02x:%02x, lid %d flags=%xh, index=%u, hdl=%x\n",
+	    __func__, sa_update_iocb->port_id[2],
+	    sa_update_iocb->port_id[1], sa_update_iocb->port_id[0],
+	    nport_handle, sa_update_iocb->flags, sa_update_iocb->sa_index,
+	    sp->handle);
+
+	sp->fcport->vha->qla_stats.control_requests++;
+}
+
+void qla24xx_auth_els(scsi_qla_host_t *vha, void **pkt, struct rsp_que **rsp)
+{
+	struct purex_entry_24xx *p = *pkt;
+	struct enode		*ptr;
+	int		sid;
+	u16 totlen;
+	struct purexevent	*purex;
+	struct scsi_qla_host *host = NULL;
+	int rc;
+	struct fc_port *fcport;
+	struct qla_els_pt_arg a;
+	be_id_t beid;
+
+	memset(&a, 0, sizeof(a));
+
+	a.els_opcode = ELS_AUTH_ELS;
+	a.nport_handle = p->nport_handle;
+	a.rx_xchg_address = p->rx_xchg_addr;
+	a.did.b.domain = p->s_id[2];
+	a.did.b.area   = p->s_id[1];
+	a.did.b.al_pa  = p->s_id[0];
+	a.tx_byte_count = a.tx_len = sizeof(struct fc_els_ls_rjt);
+	a.tx_addr = vha->hw->elsrej.cdma;
+	a.vp_idx = vha->vp_idx;
+	a.control_flags = EPD_ELS_RJT;
+
+	sid = p->s_id[0] | (p->s_id[1] << 8) | (p->s_id[2] << 16);
+	/*
+	 * ql_dbg(ql_dbg_edif, vha, 0x09108,
+	 *	  "%s rec'vd sid=0x%x\n", __func__, sid);
+	 */
+
+	totlen = (le16_to_cpu(p->frame_size) & 0x0fff) - PURX_ELS_HEADER_SIZE;
+	if (le16_to_cpu(p->status_flags) & 0x8000) {
+		totlen = le16_to_cpu(p->trunc_frame_size);
+		qla_els_reject_iocb(vha, (*rsp)->qpair, &a);
+		__qla_consume_iocb(vha, pkt, rsp);
+		return;
+	}
+
+	if (totlen > MAX_PAYLOAD) {
+		ql_dbg(ql_dbg_edif, vha, 0x0910d,
+		    "%s WARNING: verbose ELS frame received (totlen=%x)\n",
+		    __func__, totlen);
+		qla_els_reject_iocb(vha, (*rsp)->qpair, &a);
+		__qla_consume_iocb(vha, pkt, rsp);
+		return;
+	}
+
+	if (!vha->hw->flags.edif_enabled) {
+		/* edif support not enabled */
+		ql_dbg(ql_dbg_edif, vha, 0x910e, "%s edif not enabled\n",
+		    __func__);
+		qla_els_reject_iocb(vha, (*rsp)->qpair, &a);
+		__qla_consume_iocb(vha, pkt, rsp);
+		return;
+	}
+
+	ptr = qla_enode_alloc(vha, N_PUREX);
+	if (!ptr) {
+		ql_dbg(ql_dbg_edif, vha, 0x09109,
+		    "WARNING: enode allloc failed for sid=%x\n",
+		    sid);
+		qla_els_reject_iocb(vha, (*rsp)->qpair, &a);
+		__qla_consume_iocb(vha, pkt, rsp);
+		return;
+	}
+
+	purex = &ptr->u.purexinfo;
+	purex->pur_info.pur_sid = a.did;
+	purex->pur_info.pur_pend = 0;
+	purex->pur_info.pur_bytes_rcvd = totlen;
+	purex->pur_info.pur_rx_xchg_address = le32_to_cpu(p->rx_xchg_addr);
+	purex->pur_info.pur_nphdl = le16_to_cpu(p->nport_handle);
+	purex->pur_info.pur_did.b.domain =  p->d_id[2];
+	purex->pur_info.pur_did.b.area =  p->d_id[1];
+	purex->pur_info.pur_did.b.al_pa =  p->d_id[0];
+	purex->pur_info.vp_idx = p->vp_idx;
+
+	rc = __qla_copy_purex_to_buffer(vha, pkt, rsp, purex->msgp,
+		purex->msgp_len);
+	if (rc) {
+		qla_els_reject_iocb(vha, (*rsp)->qpair, &a);
+		qla_enode_free(vha, ptr);
+		return;
+	}
+	/*
+	 * ql_dump_buffer(ql_dbg_edif, vha, 0x70e0,
+	 *   purex->msgp, purex->pur_info.pur_bytes_rcvd);
+	 */
+	beid.al_pa = purex->pur_info.pur_did.b.al_pa;
+	beid.area   = purex->pur_info.pur_did.b.area;
+	beid.domain = purex->pur_info.pur_did.b.domain;
+	host = qla_find_host_by_d_id(vha, beid);
+	if (!host) {
+		ql_log(ql_log_fatal, vha, 0x508b,
+		    "%s Drop ELS due to unable to find host %06x\n",
+		    __func__, purex->pur_info.pur_did.b24);
+
+		qla_els_reject_iocb(vha, (*rsp)->qpair, &a);
+		qla_enode_free(vha, ptr);
+		return;
+	}
+
+	fcport = qla2x00_find_fcport_by_pid(host, &purex->pur_info.pur_sid);
+
+	if (host->e_dbell.db_flags != EDB_ACTIVE ||
+	    (fcport && fcport->loop_id == FC_NO_LOOP_ID)) {
+		ql_dbg(ql_dbg_edif, host, 0x0910c, "%s e_dbell.db_flags =%x %06x\n",
+		    __func__, host->e_dbell.db_flags,
+		    fcport ? fcport->d_id.b24 : 0);
+
+		qla_els_reject_iocb(host, (*rsp)->qpair, &a);
+		qla_enode_free(host, ptr);
+		return;
+	}
+
+	/* add the local enode to the list */
+	qla_enode_add(host, ptr);
+
+	ql_dbg(ql_dbg_edif, host, 0x0910c,
+	    "%s COMPLETE purex->pur_info.pur_bytes_rcvd =%xh s:%06x -> d:%06x xchg=%xh\n",
+	    __func__, purex->pur_info.pur_bytes_rcvd,
+	    purex->pur_info.pur_sid.b24,
+	    purex->pur_info.pur_did.b24, p->rx_xchg_addr);
+
+	qla_edb_eventcreate(host, VND_CMD_AUTH_STATE_ELS_RCVD, sid, 0, NULL);
+}
+
+static uint16_t  qla_edif_get_sa_index_from_freepool(fc_port_t *fcport, int dir)
+{
+	struct scsi_qla_host *vha = fcport->vha;
+	struct qla_hw_data *ha = vha->hw;
+	void *sa_id_map;
+	unsigned long flags = 0;
+	u16 sa_index;
+
+	ql_dbg(ql_dbg_edif + ql_dbg_verbose, vha, 0x3063,
+	    "%s: entry\n", __func__);
+
+	if (dir)
+		sa_id_map = ha->edif_tx_sa_id_map;
+	else
+		sa_id_map = ha->edif_rx_sa_id_map;
+
+	spin_lock_irqsave(&ha->sadb_fp_lock, flags);
+	sa_index = find_first_zero_bit(sa_id_map, EDIF_NUM_SA_INDEX);
+	if (sa_index >=  EDIF_NUM_SA_INDEX) {
+		spin_unlock_irqrestore(&ha->sadb_fp_lock, flags);
+		return INVALID_EDIF_SA_INDEX;
+	}
+	set_bit(sa_index, sa_id_map);
+	spin_unlock_irqrestore(&ha->sadb_fp_lock, flags);
+
+	if (dir)
+		sa_index += EDIF_TX_SA_INDEX_BASE;
+
+	ql_dbg(ql_dbg_edif, vha, 0x3063,
+	    "%s: index retrieved from free pool %d\n", __func__, sa_index);
+
+	return sa_index;
+}
+
+/* find an sadb entry for an nport_handle */
+static struct edif_sa_index_entry *
+qla_edif_sadb_find_sa_index_entry(uint16_t nport_handle,
+		struct list_head *sa_list)
+{
+	struct edif_sa_index_entry *entry;
+	struct edif_sa_index_entry *tentry;
+	struct list_head *indx_list = sa_list;
+
+	list_for_each_entry_safe(entry, tentry, indx_list, next) {
+		if (entry->handle == nport_handle)
+			return entry;
+	}
+	return NULL;
+}
+
+/* remove an sa_index from the nport_handle and return it to the free pool */
+static int qla_edif_sadb_delete_sa_index(fc_port_t *fcport, uint16_t nport_handle,
+		uint16_t sa_index)
+{
+	struct edif_sa_index_entry *entry;
+	struct list_head *sa_list;
+	int dir = (sa_index < EDIF_TX_SA_INDEX_BASE) ? 0 : 1;
+	int slot = 0;
+	int free_slot_count = 0;
+	scsi_qla_host_t *vha = fcport->vha;
+	struct qla_hw_data *ha = vha->hw;
+	unsigned long flags = 0;
+
+	ql_dbg(ql_dbg_edif, vha, 0x3063,
+	    "%s: entry\n", __func__);
+
+	if (dir)
+		sa_list = &ha->sadb_tx_index_list;
+	else
+		sa_list = &ha->sadb_rx_index_list;
+
+	entry = qla_edif_sadb_find_sa_index_entry(nport_handle, sa_list);
+	if (!entry) {
+		ql_dbg(ql_dbg_edif, vha, 0x3063,
+		    "%s: no entry found for nport_handle 0x%x\n",
+		    __func__, nport_handle);
+		return -1;
+	}
+
+	spin_lock_irqsave(&ha->sadb_lock, flags);
+	for (slot = 0; slot < 2; slot++) {
+		if (entry->sa_pair[slot].sa_index == sa_index) {
+			entry->sa_pair[slot].sa_index = INVALID_EDIF_SA_INDEX;
+			entry->sa_pair[slot].spi = 0;
+			free_slot_count++;
+			qla_edif_add_sa_index_to_freepool(fcport, dir, sa_index);
+		} else if (entry->sa_pair[slot].sa_index == INVALID_EDIF_SA_INDEX) {
+			free_slot_count++;
+		}
+	}
+
+	if (free_slot_count == 2) {
+		list_del(&entry->next);
+		kfree(entry);
+	}
+	spin_unlock_irqrestore(&ha->sadb_lock, flags);
+
+	ql_dbg(ql_dbg_edif, vha, 0x3063,
+	    "%s: sa_index %d removed, free_slot_count: %d\n",
+	    __func__, sa_index, free_slot_count);
+
+	return 0;
+}
+
+void
+qla28xx_sa_update_iocb_entry(scsi_qla_host_t *v, struct req_que *req,
+		struct sa_update_28xx *pkt)
+{
+	const char *func = "SA_UPDATE_RESPONSE_IOCB";
+	srb_t *sp;
+	struct edif_sa_ctl *sa_ctl;
+	int old_sa_deleted = 1;
+	uint16_t nport_handle;
+	struct scsi_qla_host *vha;
+
+	sp = qla2x00_get_sp_from_handle(v, func, req, pkt);
+
+	if (!sp) {
+		ql_dbg(ql_dbg_edif, v, 0x3063,
+			"%s: no sp found for pkt\n", __func__);
+		return;
+	}
+	/* use sp->vha due to npiv */
+	vha = sp->vha;
+
+	switch (pkt->flags & (SA_FLAG_INVALIDATE | SA_FLAG_TX)) {
+	case 0:
+		ql_dbg(ql_dbg_edif, vha, 0x3063,
+		    "%s: EDIF SA UPDATE RX IOCB  vha: 0x%p  index: %d\n",
+		    __func__, vha, pkt->sa_index);
+		break;
+	case 1:
+		ql_dbg(ql_dbg_edif, vha, 0x3063,
+		    "%s: EDIF SA DELETE RX IOCB  vha: 0x%p  index: %d\n",
+		    __func__, vha, pkt->sa_index);
+		break;
+	case 2:
+		ql_dbg(ql_dbg_edif, vha, 0x3063,
+		    "%s: EDIF SA UPDATE TX IOCB  vha: 0x%p  index: %d\n",
+		    __func__, vha, pkt->sa_index);
+		break;
+	case 3:
+		ql_dbg(ql_dbg_edif, vha, 0x3063,
+		    "%s: EDIF SA DELETE TX IOCB  vha: 0x%p  index: %d\n",
+		    __func__, vha, pkt->sa_index);
+		break;
+	}
+
+	/*
+	 * dig the nport handle out of the iocb, fcport->loop_id can not be trusted
+	 * to be correct during cleanup sa_update iocbs.
+	 */
+	nport_handle = sp->fcport->loop_id;
+
+	ql_dbg(ql_dbg_edif, vha, 0x3063,
+"%s: %8phN comp status=%x old_sa_info=%x new_sa_info=%x lid %d, index=0x%x pkt_flags %xh hdl=%x\n",
+	    __func__, sp->fcport->port_name,
+	    pkt->u.comp_sts, pkt->old_sa_info, pkt->new_sa_info, nport_handle,
+	    pkt->sa_index, pkt->flags, sp->handle);
+
+	/* if rx delete, remove the timer */
+	if ((pkt->flags & (SA_FLAG_INVALIDATE | SA_FLAG_TX)) ==  SA_FLAG_INVALIDATE) {
+		struct edif_list_entry *edif_entry;
+
+		sp->fcport->flags &= ~(FCF_ASYNC_SENT | FCF_ASYNC_ACTIVE);
+
+		edif_entry = qla_edif_list_find_sa_index(sp->fcport, nport_handle);
+		if (edif_entry) {
+			ql_dbg(ql_dbg_edif, vha, 0x5033,
+			    "%s: removing edif_entry %p, new sa_index: 0x%x\n",
+			    __func__, edif_entry, pkt->sa_index);
+			qla_edif_list_delete_sa_index(sp->fcport, edif_entry);
+			del_timer(&edif_entry->timer);
+
+			ql_dbg(ql_dbg_edif, vha, 0x5033,
+			    "%s: releasing edif_entry %p, new sa_index: 0x%x\n",
+			    __func__, edif_entry, pkt->sa_index);
+
+			kfree(edif_entry);
+		}
+	}
+
+	/*
+	 * if this is a delete for either tx or rx, make sure it succeeded.
+	 * The new_sa_info field should be 0xffff on success
+	 */
+	if (pkt->flags & SA_FLAG_INVALIDATE)
+		old_sa_deleted = (le16_to_cpu(pkt->new_sa_info) == 0xffff) ? 1 : 0;
+
+	/* Process update and delete the same way */
+
+	/* If this is an sadb cleanup delete, bypass sending events to IPSEC */
+	if (sp->flags & SRB_EDIF_CLEANUP_DELETE) {
+		sp->fcport->flags &= ~(FCF_ASYNC_SENT | FCF_ASYNC_ACTIVE);
+		ql_dbg(ql_dbg_edif, vha, 0x3063,
+		    "%s: nph 0x%x, sa_index %d removed from fw\n",
+		    __func__, sp->fcport->loop_id, pkt->sa_index);
+
+	} else if ((pkt->entry_status == 0) && (pkt->u.comp_sts == 0) &&
+	    old_sa_deleted) {
+		/*
+		 * Note: Wa are only keeping track of latest SA,
+		 * so we know when we can start enableing encryption per I/O.
+		 * If all SA's get deleted, let FW reject the IOCB.
+
+		 * TODO: edif: don't set enabled here I think
+		 * TODO: edif: prli complete is where it should be set
+		 */
+		ql_dbg(ql_dbg_edif + ql_dbg_verbose, vha, 0x3063,
+			"SA(%x)updated for s_id %02x%02x%02x\n",
+			pkt->new_sa_info,
+			pkt->port_id[2], pkt->port_id[1], pkt->port_id[0]);
+		sp->fcport->edif.enable = 1;
+		if (pkt->flags & SA_FLAG_TX) {
+			sp->fcport->edif.tx_sa_set = 1;
+			sp->fcport->edif.tx_sa_pending = 0;
+			qla_edb_eventcreate(vha, VND_CMD_AUTH_STATE_SAUPDATE_COMPL,
+				QL_VND_SA_STAT_SUCCESS,
+				QL_VND_TX_SA_KEY, sp->fcport);
+		} else {
+			sp->fcport->edif.rx_sa_set = 1;
+			sp->fcport->edif.rx_sa_pending = 0;
+			qla_edb_eventcreate(vha, VND_CMD_AUTH_STATE_SAUPDATE_COMPL,
+				QL_VND_SA_STAT_SUCCESS,
+				QL_VND_RX_SA_KEY, sp->fcport);
+		}
+	} else {
+		ql_dbg(ql_dbg_edif, vha, 0x3063,
+		    "%s: %8phN SA update FAILED: sa_index: %d, new_sa_info %d, %02x%02x%02x -- dumping\n",
+		    __func__, sp->fcport->port_name,
+		    pkt->sa_index, pkt->new_sa_info, pkt->port_id[2],
+		    pkt->port_id[1], pkt->port_id[0]);
+
+		if (pkt->flags & SA_FLAG_TX)
+			qla_edb_eventcreate(vha, VND_CMD_AUTH_STATE_SAUPDATE_COMPL,
+				(le16_to_cpu(pkt->u.comp_sts) << 16) | QL_VND_SA_STAT_FAILED,
+				QL_VND_TX_SA_KEY, sp->fcport);
+		else
+			qla_edb_eventcreate(vha, VND_CMD_AUTH_STATE_SAUPDATE_COMPL,
+				(le16_to_cpu(pkt->u.comp_sts) << 16) | QL_VND_SA_STAT_FAILED,
+				QL_VND_RX_SA_KEY, sp->fcport);
+	}
+
+	/* for delete, release sa_ctl, sa_index */
+	if (pkt->flags & SA_FLAG_INVALIDATE) {
+		/* release the sa_ctl */
+		sa_ctl = qla_edif_find_sa_ctl_by_index(sp->fcport,
+		    le16_to_cpu(pkt->sa_index), (pkt->flags & SA_FLAG_TX));
+		if (sa_ctl &&
+		    qla_edif_find_sa_ctl_by_index(sp->fcport, sa_ctl->index,
+			(pkt->flags & SA_FLAG_TX)) != NULL) {
+			ql_dbg(ql_dbg_edif + ql_dbg_verbose, vha, 0x3063,
+			    "%s: freeing sa_ctl for index %d\n",
+			    __func__, sa_ctl->index);
+			qla_edif_free_sa_ctl(sp->fcport, sa_ctl, sa_ctl->index);
+		} else {
+			ql_dbg(ql_dbg_edif, vha, 0x3063,
+			    "%s: sa_ctl NOT freed, sa_ctl: %p\n",
+			    __func__, sa_ctl);
+		}
+		ql_dbg(ql_dbg_edif, vha, 0x3063,
+		    "%s: freeing sa_index %d, nph: 0x%x\n",
+		    __func__, le16_to_cpu(pkt->sa_index), nport_handle);
+		qla_edif_sadb_delete_sa_index(sp->fcport, nport_handle,
+		    le16_to_cpu(pkt->sa_index));
+	/*
+	 * check for a failed sa_update and remove
+	 * the sadb entry.
+	 */
+	} else if (pkt->u.comp_sts) {
+		ql_dbg(ql_dbg_edif, vha, 0x3063,
+		    "%s: freeing sa_index %d, nph: 0x%x\n",
+		    __func__, pkt->sa_index, nport_handle);
+		qla_edif_sadb_delete_sa_index(sp->fcport, nport_handle,
+		    le16_to_cpu(pkt->sa_index));
+	}
+
+	sp->done(sp, 0);
+}
+
+/*
+ * qla28xx_start_scsi_edif() - Send a SCSI type 6 command ot the ISP
+ * @sp: command to send to the ISP
+ * req/rsp queue to use for this request
+ * lock to protect submission
+ *
+ * Returns non-zero if a failure occurred, else zero.
+ */
+int
+qla28xx_start_scsi_edif(srb_t *sp)
+{
+	int             nseg;
+	unsigned long   flags;
+	struct scsi_cmnd *cmd;
+	uint32_t        *clr_ptr;
+	uint32_t        index, i;
+	uint32_t        handle;
+	uint16_t        cnt;
+	int16_t        req_cnt;
+	uint16_t        tot_dsds;
+	__be32 *fcp_dl;
+	uint8_t additional_cdb_len;
+	struct ct6_dsd *ctx;
+	struct scsi_qla_host *vha = sp->vha;
+	struct qla_hw_data *ha = vha->hw;
+	struct cmd_type_6 *cmd_pkt;
+	struct dsd64	*cur_dsd;
+	uint8_t		avail_dsds = 0;
+	struct scatterlist *sg;
+	struct req_que *req = sp->qpair->req;
+	spinlock_t *lock = sp->qpair->qp_lock_ptr;
+
+	/* Setup device pointers. */
+	cmd = GET_CMD_SP(sp);
+
+	/* So we know we haven't pci_map'ed anything yet */
+	tot_dsds = 0;
+
+	/* Send marker if required */
+	if (vha->marker_needed != 0) {
+		if (qla2x00_marker(vha, sp->qpair, 0, 0, MK_SYNC_ALL) !=
+			QLA_SUCCESS) {
+			ql_log(ql_log_warn, vha, 0x300c,
+			    "qla2x00_marker failed for cmd=%p.\n", cmd);
+			return QLA_FUNCTION_FAILED;
+		}
+		vha->marker_needed = 0;
+	}
+
+	/* Acquire ring specific lock */
+	spin_lock_irqsave(lock, flags);
+
+	/* Check for room in outstanding command list. */
+	handle = req->current_outstanding_cmd;
+	for (index = 1; index < req->num_outstanding_cmds; index++) {
+		handle++;
+		if (handle == req->num_outstanding_cmds)
+			handle = 1;
+		if (!req->outstanding_cmds[handle])
+			break;
+	}
+	if (index == req->num_outstanding_cmds)
+		goto queuing_error;
+
+	/* Map the sg table so we have an accurate count of sg entries needed */
+	if (scsi_sg_count(cmd)) {
+		nseg = dma_map_sg(&ha->pdev->dev, scsi_sglist(cmd),
+		    scsi_sg_count(cmd), cmd->sc_data_direction);
+		if (unlikely(!nseg))
+			goto queuing_error;
+	} else {
+		nseg = 0;
+	}
+
+	tot_dsds = nseg;
+	req_cnt = qla24xx_calc_iocbs(vha, tot_dsds);
+	if (req->cnt < (req_cnt + 2)) {
+		cnt = IS_SHADOW_REG_CAPABLE(ha) ? *req->out_ptr :
+		    rd_reg_dword(req->req_q_out);
+		if (req->ring_index < cnt)
+			req->cnt = cnt - req->ring_index;
+		else
+			req->cnt = req->length -
+			    (req->ring_index - cnt);
+		if (req->cnt < (req_cnt + 2))
+			goto queuing_error;
+	}
+
+	ctx = sp->u.scmd.ct6_ctx =
+	    mempool_alloc(ha->ctx_mempool, GFP_ATOMIC);
+	if (!ctx) {
+		ql_log(ql_log_fatal, vha, 0x3010,
+		    "Failed to allocate ctx for cmd=%p.\n", cmd);
+		goto queuing_error;
+	}
+
+	memset(ctx, 0, sizeof(struct ct6_dsd));
+	ctx->fcp_cmnd = dma_pool_zalloc(ha->fcp_cmnd_dma_pool,
+	    GFP_ATOMIC, &ctx->fcp_cmnd_dma);
+	if (!ctx->fcp_cmnd) {
+		ql_log(ql_log_fatal, vha, 0x3011,
+		    "Failed to allocate fcp_cmnd for cmd=%p.\n", cmd);
+		goto queuing_error;
+	}
+
+	/* Initialize the DSD list and dma handle */
+	INIT_LIST_HEAD(&ctx->dsd_list);
+	ctx->dsd_use_cnt = 0;
+
+	if (cmd->cmd_len > 16) {
+		additional_cdb_len = cmd->cmd_len - 16;
+		if ((cmd->cmd_len % 4) != 0) {
+			/*
+			 * SCSI command bigger than 16 bytes must be
+			 * multiple of 4
+			 */
+			ql_log(ql_log_warn, vha, 0x3012,
+			    "scsi cmd len %d not multiple of 4 for cmd=%p.\n",
+			    cmd->cmd_len, cmd);
+			goto queuing_error_fcp_cmnd;
+		}
+		ctx->fcp_cmnd_len = 12 + cmd->cmd_len + 4;
+	} else {
+		additional_cdb_len = 0;
+		ctx->fcp_cmnd_len = 12 + 16 + 4;
+	}
+
+	cmd_pkt = (struct cmd_type_6 *)req->ring_ptr;
+	cmd_pkt->handle = make_handle(req->id, handle);
+
+	/*
+	 * Zero out remaining portion of packet.
+	 * tagged queuing modifier -- default is TSK_SIMPLE (0).
+	 */
+	clr_ptr = (uint32_t *)cmd_pkt + 2;
+	memset(clr_ptr, 0, REQUEST_ENTRY_SIZE - 8);
+	cmd_pkt->dseg_count = cpu_to_le16(tot_dsds);
+
+	/* No data transfer */
+	if (!scsi_bufflen(cmd) || cmd->sc_data_direction == DMA_NONE) {
+		cmd_pkt->byte_count = cpu_to_le32(0);
+		goto no_dsds;
+	}
+
+	/* Set transfer direction */
+	if (cmd->sc_data_direction == DMA_TO_DEVICE) {
+		cmd_pkt->control_flags = cpu_to_le16(CF_WRITE_DATA);
+		vha->qla_stats.output_bytes += scsi_bufflen(cmd);
+		vha->qla_stats.output_requests++;
+		sp->fcport->edif.tx_bytes += scsi_bufflen(cmd);
+	} else if (cmd->sc_data_direction == DMA_FROM_DEVICE) {
+		cmd_pkt->control_flags = cpu_to_le16(CF_READ_DATA);
+		vha->qla_stats.input_bytes += scsi_bufflen(cmd);
+		vha->qla_stats.input_requests++;
+		sp->fcport->edif.rx_bytes += scsi_bufflen(cmd);
+	}
+
+	cmd_pkt->control_flags |= cpu_to_le16(CF_EN_EDIF);
+	cmd_pkt->control_flags &= ~(cpu_to_le16(CF_NEW_SA));
+
+	/* One DSD is available in the Command Type 6 IOCB */
+	avail_dsds = 1;
+	cur_dsd = &cmd_pkt->fcp_dsd;
+
+	/* Load data segments */
+	scsi_for_each_sg(cmd, sg, tot_dsds, i) {
+		dma_addr_t      sle_dma;
+		cont_a64_entry_t *cont_pkt;
+
+		/* Allocate additional continuation packets? */
+		if (avail_dsds == 0) {
+			/*
+			 * Five DSDs are available in the Continuation
+			 * Type 1 IOCB.
+			 */
+			cont_pkt = qla2x00_prep_cont_type1_iocb(vha, req);
+			cur_dsd = cont_pkt->dsd;
+			avail_dsds = 5;
+		}
+
+		sle_dma = sg_dma_address(sg);
+		put_unaligned_le64(sle_dma, &cur_dsd->address);
+		cur_dsd->length = cpu_to_le32(sg_dma_len(sg));
+		cur_dsd++;
+		avail_dsds--;
+	}
+
+no_dsds:
+	/* Set NPORT-ID and LUN number*/
+	cmd_pkt->nport_handle = cpu_to_le16(sp->fcport->loop_id);
+	cmd_pkt->port_id[0] = sp->fcport->d_id.b.al_pa;
+	cmd_pkt->port_id[1] = sp->fcport->d_id.b.area;
+	cmd_pkt->port_id[2] = sp->fcport->d_id.b.domain;
+	cmd_pkt->vp_index = sp->vha->vp_idx;
+
+	cmd_pkt->entry_type = COMMAND_TYPE_6;
+
+	/* Set total data segment count. */
+	cmd_pkt->entry_count = (uint8_t)req_cnt;
+
+	int_to_scsilun(cmd->device->lun, &cmd_pkt->lun);
+	host_to_fcp_swap((uint8_t *)&cmd_pkt->lun, sizeof(cmd_pkt->lun));
+
+	/* build FCP_CMND IU */
+	int_to_scsilun(cmd->device->lun, &ctx->fcp_cmnd->lun);
+	ctx->fcp_cmnd->additional_cdb_len = additional_cdb_len;
+
+	if (cmd->sc_data_direction == DMA_TO_DEVICE)
+		ctx->fcp_cmnd->additional_cdb_len |= 1;
+	else if (cmd->sc_data_direction == DMA_FROM_DEVICE)
+		ctx->fcp_cmnd->additional_cdb_len |= 2;
+
+	/* Populate the FCP_PRIO. */
+	if (ha->flags.fcp_prio_enabled)
+		ctx->fcp_cmnd->task_attribute |=
+		    sp->fcport->fcp_prio << 3;
+
+	memcpy(ctx->fcp_cmnd->cdb, cmd->cmnd, cmd->cmd_len);
+
+	fcp_dl = (__be32 *)(ctx->fcp_cmnd->cdb + 16 +
+	    additional_cdb_len);
+	*fcp_dl = htonl((uint32_t)scsi_bufflen(cmd));
+
+	cmd_pkt->fcp_cmnd_dseg_len = cpu_to_le16(ctx->fcp_cmnd_len);
+	put_unaligned_le64(ctx->fcp_cmnd_dma, &cmd_pkt->fcp_cmnd_dseg_address);
+
+	sp->flags |= SRB_FCP_CMND_DMA_VALID;
+	cmd_pkt->byte_count = cpu_to_le32((uint32_t)scsi_bufflen(cmd));
+	/* Set total data segment count. */
+	cmd_pkt->entry_count = (uint8_t)req_cnt;
+	cmd_pkt->entry_status = 0;
+
+	/* Build command packet. */
+	req->current_outstanding_cmd = handle;
+	req->outstanding_cmds[handle] = sp;
+	sp->handle = handle;
+	cmd->host_scribble = (unsigned char *)(unsigned long)handle;
+	req->cnt -= req_cnt;
+
+	/* Adjust ring index. */
+	wmb();
+	req->ring_index++;
+	if (req->ring_index == req->length) {
+		req->ring_index = 0;
+		req->ring_ptr = req->ring;
+	} else {
+		req->ring_ptr++;
+	}
+
+	/* Set chip new ring index. */
+	wrt_reg_dword(req->req_q_in, req->ring_index);
+
+	spin_unlock_irqrestore(lock, flags);
+	return QLA_SUCCESS;
+
+queuing_error_fcp_cmnd:
+	dma_pool_free(ha->fcp_cmnd_dma_pool, ctx->fcp_cmnd, ctx->fcp_cmnd_dma);
+queuing_error:
+	if (tot_dsds)
+		scsi_dma_unmap(cmd);
+
+	if (sp->u.scmd.ct6_ctx) {
+		mempool_free(sp->u.scmd.ct6_ctx, ha->ctx_mempool);
+		sp->u.scmd.ct6_ctx = NULL;
+	}
+	spin_unlock_irqrestore(lock, flags);
+
+	return QLA_FUNCTION_FAILED;
+}
+
+/**********************************************
+ * edif update/delete sa_index list functions *
+ **********************************************/
+
+/* clear the edif_indx_list for this port */
+void qla_edif_list_del(fc_port_t *fcport)
+{
+	struct edif_list_entry *indx_lst;
+	struct edif_list_entry *tindx_lst;
+	struct list_head *indx_list = &fcport->edif.edif_indx_list;
+	unsigned long flags = 0;
+
+	list_for_each_entry_safe(indx_lst, tindx_lst, indx_list, next) {
+		spin_lock_irqsave(&fcport->edif.indx_list_lock, flags);
+		list_del(&indx_lst->next);
+		spin_unlock_irqrestore(&fcport->edif.indx_list_lock, flags);
+		kfree(indx_lst);
+	}
+}
+
+/******************
+ * SADB functions *
+ ******************/
+
+/* allocate/retrieve an sa_index for a given spi */
+static uint16_t qla_edif_sadb_get_sa_index(fc_port_t *fcport,
+		struct qla_sa_update_frame *sa_frame)
+{
+	struct edif_sa_index_entry *entry;
+	struct list_head *sa_list;
+	uint16_t sa_index;
+	int dir = sa_frame->flags & SAU_FLG_TX;
+	int slot = 0;
+	int free_slot = -1;
+	scsi_qla_host_t *vha = fcport->vha;
+	struct qla_hw_data *ha = vha->hw;
+	unsigned long flags = 0;
+	uint16_t nport_handle = fcport->loop_id;
+
+	ql_dbg(ql_dbg_edif, vha, 0x3063,
+	    "%s: entry  fc_port: %p, nport_handle: 0x%x\n",
+	    __func__, fcport, nport_handle);
+
+	if (dir)
+		sa_list = &ha->sadb_tx_index_list;
+	else
+		sa_list = &ha->sadb_rx_index_list;
+
+	entry = qla_edif_sadb_find_sa_index_entry(nport_handle, sa_list);
+	if (!entry) {
+		if ((sa_frame->flags & (SAU_FLG_TX | SAU_FLG_INV)) == SAU_FLG_INV) {
+			ql_dbg(ql_dbg_edif, vha, 0x3063,
+			    "%s: rx delete request with no entry\n", __func__);
+			return RX_DELETE_NO_EDIF_SA_INDEX;
+		}
+
+		/* if there is no entry for this nport, add one */
+		entry = kzalloc((sizeof(struct edif_sa_index_entry)), GFP_ATOMIC);
+		if (!entry)
+			return INVALID_EDIF_SA_INDEX;
+
+		sa_index = qla_edif_get_sa_index_from_freepool(fcport, dir);
+		if (sa_index == INVALID_EDIF_SA_INDEX) {
+			kfree(entry);
+			return INVALID_EDIF_SA_INDEX;
+		}
+
+		INIT_LIST_HEAD(&entry->next);
+		entry->handle = nport_handle;
+		entry->fcport = fcport;
+		entry->sa_pair[0].spi = sa_frame->spi;
+		entry->sa_pair[0].sa_index = sa_index;
+		entry->sa_pair[1].spi = 0;
+		entry->sa_pair[1].sa_index = INVALID_EDIF_SA_INDEX;
+		spin_lock_irqsave(&ha->sadb_lock, flags);
+		list_add_tail(&entry->next, sa_list);
+		spin_unlock_irqrestore(&ha->sadb_lock, flags);
+		ql_dbg(ql_dbg_edif, vha, 0x3063,
+"%s: Created new sadb entry for nport_handle 0x%x, spi 0x%x, returning sa_index %d\n",
+		    __func__, nport_handle, sa_frame->spi, sa_index);
+		return sa_index;
+	} else {
+		spin_lock_irqsave(&ha->sadb_lock, flags);
+
+		/* see if we already have an entry for this spi */
+		for (slot = 0; slot < 2; slot++) {
+			if (entry->sa_pair[slot].sa_index == INVALID_EDIF_SA_INDEX) {
+				free_slot = slot;
+			} else {
+				if (entry->sa_pair[slot].spi == sa_frame->spi) {
+					spin_unlock_irqrestore(&ha->sadb_lock, flags);
+					ql_dbg(ql_dbg_edif, vha, 0x3063,
+"%s: sadb slot %d entry for lid 0x%x, spi 0x%x found, sa_index %d\n",
+					    __func__, slot, entry->handle,
+					    sa_frame->spi, entry->sa_pair[slot].sa_index);
+					return entry->sa_pair[slot].sa_index;
+				}
+			}
+		}
+		spin_unlock_irqrestore(&ha->sadb_lock, flags);
+
+		/* both slots are used */
+		if (free_slot == -1) {
+			ql_dbg(ql_dbg_edif, vha, 0x3063,
+			    "%s: WARNING: No free slots in sadb for nport_handle 0x%x, spi: 0x%x\n",
+			    __func__, entry->handle, sa_frame->spi);
+			ql_dbg(ql_dbg_edif, vha, 0x3063,
+			    "%s:   Slot 0  spi: 0x%x  sa_index: %d\n",
+			    __func__, entry->sa_pair[0].spi,
+			    entry->sa_pair[0].sa_index);
+			ql_dbg(ql_dbg_edif, vha, 0x3063,
+			    "%s:   Slot 1  spi: 0x%x  sa_index: %d\n",
+			    __func__, entry->sa_pair[1].spi,
+			    entry->sa_pair[1].sa_index);
+
+			return INVALID_EDIF_SA_INDEX;
+		}
+
+		/* there is at least one free slot, use it */
+		sa_index = qla_edif_get_sa_index_from_freepool(fcport, dir);
+		if (sa_index == INVALID_EDIF_SA_INDEX) {
+			ql_dbg(ql_dbg_edif, fcport->vha, 0x3063,
+			    "%s: empty freepool!!\n", __func__);
+			return INVALID_EDIF_SA_INDEX;
+		}
+
+		spin_lock_irqsave(&ha->sadb_lock, flags);
+		entry->sa_pair[free_slot].spi = sa_frame->spi;
+		entry->sa_pair[free_slot].sa_index = sa_index;
+		spin_unlock_irqrestore(&ha->sadb_lock, flags);
+		ql_dbg(ql_dbg_edif, fcport->vha, 0x3063,
+"%s: sadb slot %d entry for nport_handle 0x%x, spi 0x%x added, returning sa_index %d\n",
+		    __func__, free_slot, entry->handle, sa_frame->spi,
+		    sa_index);
+
+		return sa_index;
+	}
+}
+
+/* release any sadb entries -- only done at teardown */
+void qla_edif_sadb_release(struct qla_hw_data *ha)
+{
+	struct list_head *pos;
+	struct list_head *tmp;
+	struct edif_sa_index_entry *entry;
+
+	list_for_each_safe(pos, tmp, &ha->sadb_rx_index_list) {
+		entry = list_entry(pos, struct edif_sa_index_entry, next);
+		list_del(&entry->next);
+		kfree(entry);
+	}
+
+	list_for_each_safe(pos, tmp, &ha->sadb_tx_index_list) {
+		entry = list_entry(pos, struct edif_sa_index_entry, next);
+		list_del(&entry->next);
+		kfree(entry);
+	}
+}
+
+/**************************
+ * sadb freepool functions
+ **************************/
+
+/* build the rx and tx sa_index free pools -- only done at fcport init */
+int qla_edif_sadb_build_free_pool(struct qla_hw_data *ha)
+{
+	ha->edif_tx_sa_id_map =
+	    kcalloc(BITS_TO_LONGS(EDIF_NUM_SA_INDEX), sizeof(long), GFP_KERNEL);
+
+	if (!ha->edif_tx_sa_id_map) {
+		ql_log_pci(ql_log_fatal, ha->pdev, 0x0009,
+		    "Unable to allocate memory for sadb tx.\n");
+		return -ENOMEM;
+	}
+
+	ha->edif_rx_sa_id_map =
+	    kcalloc(BITS_TO_LONGS(EDIF_NUM_SA_INDEX), sizeof(long), GFP_KERNEL);
+	if (!ha->edif_rx_sa_id_map) {
+		kfree(ha->edif_tx_sa_id_map);
+		ha->edif_tx_sa_id_map = NULL;
+		ql_log_pci(ql_log_fatal, ha->pdev, 0x0009,
+		    "Unable to allocate memory for sadb rx.\n");
+		return -ENOMEM;
+	}
+	return 0;
+}
+
+/* release the free pool - only done during fcport teardown */
+void qla_edif_sadb_release_free_pool(struct qla_hw_data *ha)
+{
+	kfree(ha->edif_tx_sa_id_map);
+	ha->edif_tx_sa_id_map = NULL;
+	kfree(ha->edif_rx_sa_id_map);
+	ha->edif_rx_sa_id_map = NULL;
+}
+
+static void __chk_edif_rx_sa_delete_pending(scsi_qla_host_t *vha,
+		fc_port_t *fcport, uint32_t handle, uint16_t sa_index)
+{
+	struct edif_list_entry *edif_entry;
+	struct edif_sa_ctl *sa_ctl;
+	uint16_t delete_sa_index = INVALID_EDIF_SA_INDEX;
+	unsigned long flags = 0;
+	uint16_t nport_handle = fcport->loop_id;
+	uint16_t cached_nport_handle;
+
+	spin_lock_irqsave(&fcport->edif.indx_list_lock, flags);
+	edif_entry = qla_edif_list_find_sa_index(fcport, nport_handle);
+	if (!edif_entry) {
+		spin_unlock_irqrestore(&fcport->edif.indx_list_lock, flags);
+		return;		/* no pending delete for this handle */
+	}
+
+	/*
+	 * check for no pending delete for this index or iocb does not
+	 * match rx sa_index
+	 */
+	if (edif_entry->delete_sa_index == INVALID_EDIF_SA_INDEX ||
+	    edif_entry->update_sa_index != sa_index) {
+		spin_unlock_irqrestore(&fcport->edif.indx_list_lock, flags);
+		return;
+	}
+
+	/*
+	 * wait until we have seen at least EDIF_DELAY_COUNT transfers before
+	 * queueing RX delete
+	 */
+	if (edif_entry->count++ < EDIF_RX_DELETE_FILTER_COUNT) {
+		spin_unlock_irqrestore(&fcport->edif.indx_list_lock, flags);
+		return;
+	}
+
+	ql_dbg(ql_dbg_edif, vha, 0x5033,
+"%s: invalidating delete_sa_index,  update_sa_index: 0x%x sa_index: 0x%x, delete_sa_index: 0x%x\n",
+	    __func__, edif_entry->update_sa_index, sa_index,
+	    edif_entry->delete_sa_index);
+
+	delete_sa_index = edif_entry->delete_sa_index;
+	edif_entry->delete_sa_index = INVALID_EDIF_SA_INDEX;
+	cached_nport_handle = edif_entry->handle;
+	spin_unlock_irqrestore(&fcport->edif.indx_list_lock, flags);
+
+	/* sanity check on the nport handle */
+	if (nport_handle != cached_nport_handle) {
+		ql_dbg(ql_dbg_edif, vha, 0x3063,
+"%s: POST SA DELETE nport_handle mismatch: lid: 0x%x, edif_entry nph: 0x%x\n",
+		    __func__, nport_handle, cached_nport_handle);
+	}
+
+	/* find the sa_ctl for the delete and schedule the delete */
+	sa_ctl = qla_edif_find_sa_ctl_by_index(fcport, delete_sa_index, 0);
+	if (sa_ctl) {
+		ql_dbg(ql_dbg_edif, vha, 0x3063,
+		    "%s: POST SA DELETE sa_ctl: %p, index recvd %d\n",
+		    __func__, sa_ctl, sa_index);
+		ql_dbg(ql_dbg_edif, vha, 0x3063,
+		    "delete index %d, update index: %d, nport handle: 0x%x, handle: 0x%x\n",
+		    delete_sa_index,
+		    edif_entry->update_sa_index, nport_handle, handle);
+
+		sa_ctl->flags = EDIF_SA_CTL_FLG_DEL;
+		set_bit(EDIF_SA_CTL_REPL, &sa_ctl->state);
+		qla_post_sa_replace_work(fcport->vha, fcport,
+		    nport_handle, sa_ctl);
+	} else {
+		ql_dbg(ql_dbg_edif, vha, 0x3063,
+		    "%s: POST SA DELETE sa_ctl not found for delete_sa_index: %d\n",
+		    __func__, delete_sa_index);
+	}
+}
+
+void qla_chk_edif_rx_sa_delete_pending(scsi_qla_host_t *vha,
+		srb_t *sp, struct sts_entry_24xx *sts24)
+{
+	fc_port_t *fcport = sp->fcport;
+	/* sa_index used by this iocb */
+	struct scsi_cmnd *cmd = GET_CMD_SP(sp);
+	uint32_t handle;
+
+	handle = (uint32_t)LSW(sts24->handle);
+
+	/* find out if this status iosb is for a scsi read */
+	if (cmd->sc_data_direction != DMA_FROM_DEVICE)
+		return;
+
+	return __chk_edif_rx_sa_delete_pending(vha, fcport, handle,
+	   le16_to_cpu(sts24->edif_sa_index));
+}
+
+void qlt_chk_edif_rx_sa_delete_pending(scsi_qla_host_t *vha, fc_port_t *fcport,
+		struct ctio7_from_24xx *pkt)
+{
+	__chk_edif_rx_sa_delete_pending(vha, fcport,
+	    pkt->handle, le16_to_cpu(pkt->edif_sa_index));
+}
+
+void qla_parse_auth_els_ctl(struct srb *sp)
+{
+	struct qla_els_pt_arg *a = &sp->u.bsg_cmd.u.els_arg;
+	struct bsg_job *bsg_job = sp->u.bsg_cmd.bsg_job;
+	struct fc_bsg_request *request = bsg_job->request;
+	struct qla_bsg_auth_els_request *p =
+	    (struct qla_bsg_auth_els_request *)bsg_job->request;
+
+	a->tx_len = a->tx_byte_count = sp->remap.req.len;
+	a->tx_addr = sp->remap.req.dma;
+	a->rx_len = a->rx_byte_count = sp->remap.rsp.len;
+	a->rx_addr = sp->remap.rsp.dma;
+
+	if (p->e.sub_cmd == SEND_ELS_REPLY) {
+		a->control_flags = p->e.extra_control_flags << 13;
+		a->rx_xchg_address = cpu_to_le32(p->e.extra_rx_xchg_address);
+		if (p->e.extra_control_flags == BSG_CTL_FLAG_LS_ACC)
+			a->els_opcode = ELS_LS_ACC;
+		else if (p->e.extra_control_flags == BSG_CTL_FLAG_LS_RJT)
+			a->els_opcode = ELS_LS_RJT;
+	}
+	a->did = sp->fcport->d_id;
+	a->els_opcode =  request->rqst_data.h_els.command_code;
+	a->nport_handle = cpu_to_le16(sp->fcport->loop_id);
+	a->vp_idx = sp->vha->vp_idx;
+}
+
+int qla_edif_process_els(scsi_qla_host_t *vha, struct bsg_job *bsg_job)
+{
+	struct fc_bsg_request *bsg_request = bsg_job->request;
+	struct fc_bsg_reply *bsg_reply = bsg_job->reply;
+	fc_port_t *fcport = NULL;
+	struct qla_hw_data *ha = vha->hw;
+	srb_t *sp;
+	int rval =  (DID_ERROR << 16);
+	port_id_t d_id;
+	struct qla_bsg_auth_els_request *p =
+	    (struct qla_bsg_auth_els_request *)bsg_job->request;
+
+	d_id.b.al_pa = bsg_request->rqst_data.h_els.port_id[2];
+	d_id.b.area = bsg_request->rqst_data.h_els.port_id[1];
+	d_id.b.domain = bsg_request->rqst_data.h_els.port_id[0];
+
+	/* find matching d_id in fcport list */
+	fcport = qla2x00_find_fcport_by_pid(vha, &d_id);
+	if (!fcport) {
+		ql_dbg(ql_dbg_edif, vha, 0x911a,
+		    "%s fcport not find online portid=%06x.\n",
+		    __func__, d_id.b24);
+		SET_DID_STATUS(bsg_reply->result, DID_ERROR);
+		return -EIO;
+	}
+
+	if (qla_bsg_check(vha, bsg_job, fcport))
+		return 0;
+
+	if (fcport->loop_id == FC_NO_LOOP_ID) {
+		ql_dbg(ql_dbg_edif, vha, 0x910d,
+		    "%s ELS code %x, no loop id.\n", __func__,
+		    bsg_request->rqst_data.r_els.els_code);
+		SET_DID_STATUS(bsg_reply->result, DID_BAD_TARGET);
+		return -ENXIO;
+	}
+
+	if (!vha->flags.online) {
+		ql_log(ql_log_warn, vha, 0x7005, "Host not online.\n");
+		SET_DID_STATUS(bsg_reply->result, DID_BAD_TARGET);
+		rval = -EIO;
+		goto done;
+	}
+
+	/* pass through is supported only for ISP 4Gb or higher */
+	if (!IS_FWI2_CAPABLE(ha)) {
+		ql_dbg(ql_dbg_user, vha, 0x7001,
+		    "ELS passthru not supported for ISP23xx based adapters.\n");
+		SET_DID_STATUS(bsg_reply->result, DID_BAD_TARGET);
+		rval = -EPERM;
+		goto done;
+	}
+
+	/* Alloc SRB structure */
+	sp = qla2x00_get_sp(vha, fcport, GFP_KERNEL);
+	if (!sp) {
+		ql_dbg(ql_dbg_user, vha, 0x7004,
+		    "Failed get sp pid=%06x\n", fcport->d_id.b24);
+		rval = -ENOMEM;
+		SET_DID_STATUS(bsg_reply->result, DID_IMM_RETRY);
+		goto done;
+	}
+
+	sp->remap.req.len = bsg_job->request_payload.payload_len;
+	sp->remap.req.buf = dma_pool_alloc(ha->purex_dma_pool,
+	    GFP_KERNEL, &sp->remap.req.dma);
+	if (!sp->remap.req.buf) {
+		ql_dbg(ql_dbg_user, vha, 0x7005,
+		    "Failed allocate request dma len=%x\n",
+		    bsg_job->request_payload.payload_len);
+		rval = -ENOMEM;
+		SET_DID_STATUS(bsg_reply->result, DID_IMM_RETRY);
+		goto done_free_sp;
+	}
+
+	sp->remap.rsp.len = bsg_job->reply_payload.payload_len;
+	sp->remap.rsp.buf = dma_pool_alloc(ha->purex_dma_pool,
+	    GFP_KERNEL, &sp->remap.rsp.dma);
+	if (!sp->remap.rsp.buf) {
+		ql_dbg(ql_dbg_user, vha, 0x7006,
+		    "Failed allocate response dma len=%x\n",
+		    bsg_job->reply_payload.payload_len);
+		rval = -ENOMEM;
+		SET_DID_STATUS(bsg_reply->result, DID_IMM_RETRY);
+		goto done_free_remap_req;
+	}
+	/*
+	 * ql_print_bsg_sglist(ql_dbg_user, vha, 0x7008,
+	 *     "SG bsg->request", &bsg_job->request_payload);
+	 */
+	sg_copy_to_buffer(bsg_job->request_payload.sg_list,
+	    bsg_job->request_payload.sg_cnt, sp->remap.req.buf,
+	    sp->remap.req.len);
+	sp->remap.remapped = true;
+	/*
+	 * ql_dump_buffer(ql_dbg_edif, vha, 0x70e0,
+	 * sp->remap.req.buf, bsg_job->request_payload.payload_len);
+	 */
+
+	sp->type = SRB_ELS_CMD_HST_NOLOGIN;
+	sp->name = "SPCN_BSG_HST_NOLOGIN";
+	sp->u.bsg_cmd.bsg_job = bsg_job;
+	qla_parse_auth_els_ctl(sp);
+
+	sp->free = qla2x00_bsg_sp_free;
+	sp->done = qla2x00_bsg_job_done;
+
+	rval = qla2x00_start_sp(sp);
+
+	ql_dbg(ql_dbg_edif, vha, 0x700a,
+	    "%s %s %8phN xchg %x ctlflag %x hdl %x reqlen %xh bsg ptr %p\n",
+	    __func__, sc_to_str(p->e.sub_cmd), fcport->port_name,
+	    p->e.extra_rx_xchg_address, p->e.extra_control_flags,
+	    sp->handle, sp->remap.req.len, bsg_job);
+
+	if (rval != QLA_SUCCESS) {
+		ql_log(ql_log_warn, vha, 0x700e,
+		    "qla2x00_start_sp failed = %d\n", rval);
+		SET_DID_STATUS(bsg_reply->result, DID_IMM_RETRY);
+		rval = -EIO;
+		goto done_free_remap_rsp;
+	}
+	return rval;
+
+done_free_remap_rsp:
+	dma_pool_free(ha->purex_dma_pool, sp->remap.rsp.buf,
+	    sp->remap.rsp.dma);
+done_free_remap_req:
+	dma_pool_free(ha->purex_dma_pool, sp->remap.req.buf,
+	    sp->remap.req.dma);
+done_free_sp:
+	qla2x00_rel_sp(sp);
+
+done:
+	return rval;
+}
+
+void qla_edif_sess_down(struct scsi_qla_host *vha, struct fc_port *sess)
+{
+	if (sess->edif.app_sess_online && vha->e_dbell.db_flags & EDB_ACTIVE) {
+		ql_dbg(ql_dbg_disc, vha, 0xf09c,
+			"%s: sess %8phN send port_offline event\n",
+			__func__, sess->port_name);
+		sess->edif.app_sess_online = 0;
+		qla_edb_eventcreate(vha, VND_CMD_AUTH_STATE_SESSION_SHUTDOWN,
+		    sess->d_id.b24, 0, sess);
+		qla2x00_post_aen_work(vha, FCH_EVT_PORT_OFFLINE, sess->d_id.b24);
+	}
+}
diff --git a/drivers/scsi/qla2xxx/qla_edif.h b/drivers/scsi/qla2xxx/qla_edif.h
new file mode 100644
index 000000000000..e753d026ff48
--- /dev/null
+++ b/drivers/scsi/qla2xxx/qla_edif.h
@@ -0,0 +1,160 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Marvell Fibre Channel HBA Driver
+ * Copyright (c)  2021    Marvell
+ */
+#ifndef __QLA_EDIF_H
+#define __QLA_EDIF_H
+
+struct qla_scsi_host;
+
+#define EDIF_MAX_INDEX	2048
+struct edif_sa_ctl {
+	struct list_head next;
+	uint16_t	del_index;
+	uint16_t	index;
+	uint16_t	slot;
+	uint16_t	flags;
+#define	EDIF_SA_CTL_FLG_REPL		BIT_0
+#define	EDIF_SA_CTL_FLG_DEL		BIT_1
+#define EDIF_SA_CTL_FLG_CLEANUP_DEL BIT_4
+	// Invalidate Index bit and mirrors QLA_SA_UPDATE_FLAGS_DELETE
+	unsigned long   state;
+#define EDIF_SA_CTL_USED	1	/* Active Sa update  */
+#define EDIF_SA_CTL_PEND	2	/* Waiting for slot */
+#define EDIF_SA_CTL_REPL	3	/* Active Replace and Delete */
+#define EDIF_SA_CTL_DEL		4	/* Delete Pending */
+	struct fc_port	*fcport;
+	struct bsg_job *bsg_job;
+	struct qla_sa_update_frame sa_frame;
+};
+
+enum enode_flags_t {
+	ENODE_ACTIVE = 0x1,	// means that app has started
+};
+
+struct pur_core {
+	enum enode_flags_t	enode_flags;
+	spinlock_t		pur_lock;       /* protects list */
+	struct  list_head	head;
+};
+
+enum db_flags_t {
+	EDB_ACTIVE = 0x1,
+};
+
+struct edif_dbell {
+	enum db_flags_t		db_flags;
+	spinlock_t		db_lock;	/* protects list */
+	struct  list_head	head;
+	struct	completion	dbell;		/* doorbell ring */
+};
+
+#define IS_FAST_CAPABLE(ha)     ((IS_QLA27XX(ha) || IS_QLA28XX(ha)) && \
+		((ha)->fw_attributes_ext[0] & BIT_5))
+
+#define SA_UPDATE_IOCB_TYPE            0x71    /* Security Association Update IOCB entry */
+struct sa_update_28xx {
+	uint8_t entry_type;             /* Entry type. */
+	uint8_t entry_count;            /* Entry count. */
+	uint8_t sys_define;             /* System Defined. */
+	uint8_t entry_status;           /* Entry Status. */
+
+	uint32_t handle;                /* IOCB System handle. */
+
+	union {
+		__le16 nport_handle;  /* in: N_PORT handle. */
+		__le16 comp_sts;              /* out: completion status */
+#define CS_PORT_EDIF_SUPP_NOT_RDY 0x64
+#define CS_PORT_EDIF_INV_REQ      0x66
+	} u;
+	uint8_t vp_index;
+	uint8_t reserved_1;
+	uint8_t port_id[3];
+	uint8_t flags;
+#define SA_FLAG_INVALIDATE BIT_0
+#define SA_FLAG_TX	   BIT_1 // 1=tx, 0=rx
+
+	uint8_t sa_key[32];     /* 256 bit key */
+	__le32 salt;
+	__le32 spi;
+	uint8_t sa_control;
+#define SA_CNTL_ENC_FCSP        (1 << 3)
+#define SA_CNTL_ENC_OPD         (2 << 3)
+#define SA_CNTL_ENC_MSK         (3 << 3)  // mask bits 4,3
+#define SA_CNTL_AES_GMAC	(1 << 2)
+#define SA_CNTL_KEY256          (2 << 0)
+#define SA_CNTL_KEY128          0
+
+	uint8_t reserved_2;
+	__le16 sa_index;   // reserve: bit 11-15
+	__le16 old_sa_info;
+	__le16 new_sa_info;
+};
+
+#define        NUM_ENTRIES     256
+#define        MAX_PAYLOAD     1024
+#define        PUR_GET         1
+#define        PUR_WRITE       2
+
+#define	LSTATE_OFF	1	// node not on list
+#define	LSTATE_ON	2	// node on list
+#define	LSTATE_DEST	3	// node destoyed
+
+struct dinfo {
+	int		nodecnt;	// create seq count
+	int		lstate;		// node's list state
+};
+
+struct pur_ninfo {
+	unsigned int	pur_pend:1;
+	port_id_t       pur_sid;
+	port_id_t	pur_did;
+	uint8_t		vp_idx;
+	short           pur_bytes_rcvd;
+	unsigned short  pur_nphdl;
+	unsigned int    pur_rx_xchg_address;
+};
+
+struct fclistevent {
+	uint32_t	fclistnum;	// # of fclist info entries
+	uint8_t		fclistinfo[64];	// TODO: get info & change to struct
+};
+
+struct asyncevent {
+	uint32_t	nasync;		// async event number
+	uint8_t		asyncinfo[64];	// TODO: get info & change to struct
+};
+
+struct plogievent {
+	uint32_t	plogi_did;	// d_id of tgt to fionish plogi
+	uint8_t		plogiinfo[64];	// TODO: get info & change to struct
+};
+
+struct purexevent {
+	struct  pur_ninfo	pur_info;
+	unsigned char		*msgp;
+	u32			msgp_len;
+};
+
+#define	N_UNDEF		0	// node not used/defined
+#define	N_PUREX		1	// purex info
+#define	N_FCPORT	2	// fcport list info
+#define	N_ASYNC		3	// async event info
+#define	N_AUTH		4	// plogi auth info
+
+struct enode {
+	struct list_head	list;
+	struct dinfo		dinfo;
+	uint32_t		ntype;
+	union {
+		struct purexevent	purexinfo;
+		struct fclistevent	fclistinfo;
+		struct asyncevent	asyncinfo;
+		struct plogievent	plogiinfo;
+
+	} u;
+};
+
+#define EDIF_STOP(_sess) (_sess->edif.enable && _sess->edif.app_stop)
+#endif	/* __QLA_EDIF_H */
diff --git a/drivers/scsi/qla2xxx/qla_edif_bsg.h b/drivers/scsi/qla2xxx/qla_edif_bsg.h
new file mode 100644
index 000000000000..9c05b78253e7
--- /dev/null
+++ b/drivers/scsi/qla2xxx/qla_edif_bsg.h
@@ -0,0 +1,225 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Marvell Fibre Channel HBA Driver
+ * Copyright (C)  2018-	    Marvell
+ *
+ */
+#ifndef __QLA_EDIF_BSG_H
+#define __QLA_EDIF_BSG_H
+
+/* BSG Vendor specific commands */
+#define	ELS_MAX_PAYLOAD		1024
+#ifndef	WWN_SIZE
+#define WWN_SIZE		8       /* Size of WWPN, WWN & WWNN */
+#endif
+#define	VND_CMD_APP_RESERVED_SIZE	32
+
+enum auth_els_sub_cmd {
+	SEND_ELS = 0,
+	SEND_ELS_REPLY,
+	PULL_ELS,
+};
+
+struct extra_auth_els {
+	enum auth_els_sub_cmd sub_cmd;
+	uint32_t        extra_rx_xchg_address; // FC_ELS_ACC | FC_ELS_RJT
+	uint8_t         extra_control_flags;
+#define BSG_CTL_FLAG_INIT       0
+#define BSG_CTL_FLAG_LS_ACC     1
+#define BSG_CTL_FLAG_LS_RJT     2
+#define BSG_CTL_FLAG_TRM        3
+	uint8_t         extra_rsvd[3];
+} __packed;
+
+struct qla_bsg_auth_els_request {
+	struct fc_bsg_request r;
+	struct extra_auth_els e;
+};
+
+struct qla_bsg_auth_els_reply {
+	struct fc_bsg_reply r;
+	uint32_t rx_xchg_address;
+};
+
+struct app_id {
+	int		app_vid;
+	uint8_t		app_key[32];
+} __packed;
+
+struct app_start_reply {
+	uint32_t	host_support_edif;	// 0=disable, 1=enable
+	uint32_t	edif_enode_active;	// 0=disable, 1=enable
+	uint32_t	edif_edb_active;	// 0=disable, 1=enable
+	uint32_t	reserved[VND_CMD_APP_RESERVED_SIZE];
+} __packed;
+
+struct app_start {
+	struct app_id	app_info;
+	uint32_t	prli_to;	// timer plogi/prli to complete
+	uint32_t	key_shred;	// timer before shredding old keys
+	uint8_t         app_start_flags;
+	uint8_t         reserved[VND_CMD_APP_RESERVED_SIZE - 1];
+} __packed;
+
+struct app_stop {
+	struct app_id	app_info;
+	char		buf[16];
+} __packed;
+
+struct app_plogi_reply {
+	uint32_t	prli_status;  // 0=failed, 1=succeeded
+	uint8_t		reserved[VND_CMD_APP_RESERVED_SIZE];
+} __packed;
+
+#define	RECFG_TIME	1
+#define	RECFG_BYTES	2
+
+struct app_rekey_cfg {
+	struct app_id app_info;
+	uint8_t	 rekey_mode;	// 1=time based (in sec), 2: bytes based
+	port_id_t d_id;		// 000 = all entries; anything else
+				//    specifies a specific d_id
+	uint8_t	 force;		// 0=no force to change config if
+				//    existing rekey mode changed,
+				// 1=force to re auth and change
+				//    existing rekey mode if different
+	union {
+		int64_t bytes;	// # of bytes before rekey, 0=no limit
+		int64_t time;	// # of seconds before rekey, 0=no time limit
+	} rky_units;
+
+	uint8_t		reserved[VND_CMD_APP_RESERVED_SIZE];
+} __packed;
+
+struct app_pinfo_req {
+	struct app_id app_info;
+	uint8_t	 num_ports;	// space allocated for app_pinfo_reply_t.ports[]
+	port_id_t remote_pid;
+	uint8_t	 reserved[VND_CMD_APP_RESERVED_SIZE];
+} __packed;
+
+struct app_pinfo {
+	port_id_t remote_pid;   // contains device d_id
+	uint8_t	remote_wwpn[WWN_SIZE];
+	uint8_t	remote_type;	// contains TGT or INIT
+#define	VND_CMD_RTYPE_UNKNOWN		0
+#define	VND_CMD_RTYPE_TARGET		1
+#define	VND_CMD_RTYPE_INITIATOR		2
+	uint8_t	remote_state;	// 0=bad, 1=good
+	uint8_t	auth_state;	// 0=auth N/A (unsecured fcport),
+				// 1=auth req'd
+				// 2=auth done
+	uint8_t	rekey_mode;	// 1=time based, 2=bytes based
+	int64_t	rekey_count;	// # of times device rekeyed
+	int64_t	rekey_config_value;     // orig rekey value (MB or sec)
+					// (0 for no limit)
+	int64_t	rekey_consumed_value;   // remaining MB/time,0=no limit
+
+	uint8_t	reserved[VND_CMD_APP_RESERVED_SIZE];
+} __packed;
+
+/* AUTH States */
+#define	VND_CMD_AUTH_STATE_UNDEF	0
+#define	VND_CMD_AUTH_STATE_SESSION_SHUTDOWN	1
+#define	VND_CMD_AUTH_STATE_NEEDED	2
+#define	VND_CMD_AUTH_STATE_ELS_RCVD	3
+#define	VND_CMD_AUTH_STATE_SAUPDATE_COMPL 4
+
+struct app_pinfo_reply {
+	uint8_t		port_count;	// possible value => 0 to 255
+	uint8_t		reserved[VND_CMD_APP_RESERVED_SIZE];
+	struct app_pinfo ports[0];	// variable - specified by app_pinfo_req num_ports
+} __packed;
+
+struct app_sinfo_req {
+	struct app_id	app_info;
+	uint8_t		num_ports;	// app space alloc for elem[]
+	uint8_t		reserved[VND_CMD_APP_RESERVED_SIZE];
+} __packed;
+
+// temp data - actual data TBD
+struct app_sinfo {
+	uint8_t	remote_wwpn[WWN_SIZE];
+	int64_t	rekey_count;	// # of times device rekeyed
+	uint8_t	rekey_mode;	// 1=time based (in sec), 2: bytes based
+	int64_t	tx_bytes;	// orig rekey value
+	int64_t	rx_bytes;	// amount left
+} __packed;
+
+struct app_stats_reply {
+	uint8_t		elem_count;	// possible value => 0 to 255
+	struct app_sinfo elem[0];	// specified by app_sinfo_t elem_count
+} __packed;
+
+struct qla_sa_update_frame {
+	struct app_id	app_info;
+	uint16_t	flags;
+#define SAU_FLG_INV		0x01	// delete key
+#define SAU_FLG_TX		0x02	// 1=tx, 0 = rx
+#define SAU_FLG_FORCE_DELETE	0x08	// force RX sa_index delete
+#define SAU_FLG_GMAC_MODE	0x20	// GMAC mode is cleartext for the IO (i.e. NULL encryption)
+#define SAU_FLG_KEY128          0x40
+#define SAU_FLG_KEY256          0x80
+	uint16_t        fast_sa_index:10,
+			reserved:6;
+	uint32_t	salt;
+	uint32_t	spi;
+	uint8_t		sa_key[32];
+	uint8_t		node_name[WWN_SIZE];
+	uint8_t		port_name[WWN_SIZE];
+	port_id_t	port_id;
+} __packed;
+
+// used for edif mgmt bsg interface
+#define	QL_VND_SC_UNDEF		0
+#define	QL_VND_SC_SA_UPDATE	1	// sa key info
+#define	QL_VND_SC_APP_START	2	// app started event
+#define	QL_VND_SC_APP_STOP	3	// app stopped event
+#define	QL_VND_SC_AUTH_OK	4	// plogi auth'd ok
+#define	QL_VND_SC_AUTH_FAIL	5	// plogi auth bad
+#define	QL_VND_SC_REKEY_CONFIG	6	// auth rekey set parms (time/data)
+#define	QL_VND_SC_GET_FCINFO	7	// get port info
+#define	QL_VND_SC_GET_STATS	8	// get edif stats
+
+/* Application interface data structure for rtn data */
+#define	EXT_DEF_EVENT_DATA_SIZE	64
+struct edif_app_dbell {
+	uint32_t	event_code;
+	uint32_t	event_data_size;
+	union  {
+		port_id_t	port_id;
+		uint8_t		event_data[EXT_DEF_EVENT_DATA_SIZE];
+	};
+} __packed;
+
+struct edif_sa_update_aen {
+	port_id_t port_id;
+	uint32_t key_type;	/* Tx (1) or RX (2) */
+	uint32_t status;	/* 0 succes,  1 failed, 2 timeout , 3 error */
+	uint8_t		reserved[16];
+} __packed;
+
+#define	QL_VND_SA_STAT_SUCCESS	0
+#define	QL_VND_SA_STAT_FAILED	1
+#define	QL_VND_SA_STAT_TIMEOUT	2
+#define	QL_VND_SA_STAT_ERROR	3
+
+#define	QL_VND_RX_SA_KEY	1
+#define	QL_VND_TX_SA_KEY	2
+
+/* App defines for plogi auth'd ok and plogi auth bad requests */
+struct auth_complete_cmd {
+	struct app_id app_info;
+#define PL_TYPE_WWPN    1
+#define PL_TYPE_DID     2
+	uint32_t    type;
+	union {
+		uint8_t  wwpn[WWN_SIZE];
+		port_id_t d_id;
+	} u;
+	uint32_t reserved[VND_CMD_APP_RESERVED_SIZE];
+} __packed;
+
+#define RX_DELAY_DELETE_TIMEOUT 20			// 30 second timeout
+
+#endif	/* QLA_EDIF_BSG_H */
diff --git a/drivers/scsi/qla2xxx/qla_fw.h b/drivers/scsi/qla2xxx/qla_fw.h
index 49df418030e4..71e5c00011f0 100644
--- a/drivers/scsi/qla2xxx/qla_fw.h
+++ b/drivers/scsi/qla2xxx/qla_fw.h
@@ -82,10 +82,11 @@ struct port_database_24xx {
 	uint8_t port_name[WWN_SIZE];
 	uint8_t node_name[WWN_SIZE];
 
-	uint8_t reserved_3[4];
+	uint8_t reserved_3[2];
+	uint16_t nvme_first_burst_size;
 	uint16_t prli_nvme_svc_param_word_0;	/* Bits 15-0 of word 0 */
 	uint16_t prli_nvme_svc_param_word_3;	/* Bits 15-0 of word 3 */
-	uint16_t nvme_first_burst_size;
+	uint8_t secure_login;
 	uint8_t reserved_4[14];
 };
 
@@ -489,6 +490,9 @@ struct cmd_type_6 {
 	struct scsi_lun lun;		/* FCP LUN (BE). */
 
 	__le16	control_flags;		/* Control flags. */
+#define CF_NEW_SA			BIT_12
+#define CF_EN_EDIF			BIT_9
+#define CF_ADDITIONAL_PARAM_BLK		BIT_8
 #define CF_DIF_SEG_DESCR_ENABLE		BIT_3
 #define CF_DATA_SEG_DESCR_ENABLE	BIT_2
 #define CF_READ_DATA			BIT_1
@@ -611,6 +615,7 @@ struct sts_entry_24xx {
 	union {
 		__le16 reserved_1;
 		__le16	nvme_rsp_pyld_len;
+		__le16 edif_sa_index;	 /* edif sa_index used for initiator read data */
 	};
 
 	__le16	state_flags;		/* State flags. */
@@ -896,6 +901,7 @@ struct logio_entry_24xx {
 #define LCF_FCP2_OVERRIDE	BIT_9	/* Set/Reset word 3 of PRLI. */
 #define LCF_CLASS_2		BIT_8	/* Enable class 2 during PLOGI. */
 #define LCF_FREE_NPORT		BIT_7	/* Release NPORT handle after LOGO. */
+#define LCF_COMMON_FEAT		BIT_7	/* PLOGI - Set Common Features Field */
 #define LCF_EXPL_LOGO		BIT_6	/* Perform an explicit LOGO. */
 #define LCF_NVME_PRLI		BIT_6   /* Perform NVME FC4 PRLI */
 #define LCF_SKIP_PRLI		BIT_5	/* Skip PRLI after PLOGI. */
@@ -920,6 +926,8 @@ struct logio_entry_24xx {
 	uint8_t rsp_size;		/* Response size in 32bit words. */
 
 	__le32	io_parameter[11];	/* General I/O parameters. */
+#define LIO_COMM_FEAT_FCSP	BIT_21
+#define LIO_COMM_FEAT_CIO	BIT_31
 #define LSC_SCODE_NOLINK	0x01
 #define LSC_SCODE_NOIOCB	0x02
 #define LSC_SCODE_NOXCB		0x03
@@ -938,6 +946,9 @@ struct logio_entry_24xx {
 #define LSC_SCODE_NOFLOGI_ACC	0x1F
 };
 
+#define PRLO_TYPE_CODE_EXT 0x10
+#define PRLO_CMD_LEN 20
+
 #define TSK_MGMT_IOCB_TYPE	0x14
 struct tsk_mgmt_entry {
 	uint8_t entry_type;		/* Entry type. */
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index fae5cae6f0a8..5f34454de593 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -12,6 +12,7 @@
  * Global Function Prototypes in qla_init.c source file.
  */
 extern int qla2x00_initialize_adapter(scsi_qla_host_t *);
+extern int qla24xx_post_prli_work(struct scsi_qla_host *vha, fc_port_t *fcport);
 
 extern int qla2100_pci_config(struct scsi_qla_host *);
 extern int qla2300_pci_config(struct scsi_qla_host *);
@@ -130,6 +131,24 @@ void qla24xx_free_purex_item(struct purex_item *item);
 extern bool qla24xx_risc_firmware_invalid(uint32_t *);
 void qla_init_iocb_limit(scsi_qla_host_t *);
 
+struct edif_list_entry;
+
+struct edif_list_entry *qla_edif_list_find_sa_index(fc_port_t *fcport, uint16_t handle);
+void qla_edif_list_del(fc_port_t *fcport);
+int edif_sadb_delete_sa_index(fc_port_t *fcport, uint16_t nport_handle, uint16_t sa_index);
+void qla_edif_sadb_release(struct qla_hw_data *ha);
+int qla_edif_sadb_build_free_pool(struct qla_hw_data *ha);
+void qla_edif_sadb_release_free_pool(struct qla_hw_data *ha);
+void qla_chk_edif_rx_sa_delete_pending(scsi_qla_host_t *vha,
+		srb_t *sp, struct sts_entry_24xx *sts24);
+void qlt_chk_edif_rx_sa_delete_pending(scsi_qla_host_t *vha, fc_port_t *fcport,
+		struct ctio7_from_24xx *ctio);
+
+void qla2x00_release_all_sadb(struct scsi_qla_host *vha, struct fc_port *fcport);
+int qla_edif_process_els(scsi_qla_host_t *vha, struct bsg_job *bsgjob);
+void qla_edif_sess_down(struct scsi_qla_host *vha, struct fc_port *sess);
+const char *sc_to_str(uint16_t cmd);
+
 
 /*
  * Global Data in qla_os.c source file.
@@ -176,6 +195,7 @@ extern int qla2xuseresexchforels;
 extern int ql2xexlogins;
 extern int ql2xdifbundlinginternalbuffers;
 extern int ql2xfulldump_on_mpifail;
+extern int ql2xsecenable;
 extern int ql2xenforce_iocb_limit;
 extern int ql2xabts_wait_nvme;
 
@@ -238,6 +258,8 @@ void qla24xx_process_purex_rdp(struct scsi_qla_host *vha,
 			       struct purex_item *pkt);
 void qla_pci_set_eeh_busy(struct scsi_qla_host *);
 void qla_schedule_eeh_work(struct scsi_qla_host *);
+struct edif_sa_ctl *qla_edif_find_sa_ctl_by_index(fc_port_t *fcport,
+						  int index, int dir);
 
 /*
  * Global Functions in qla_mid.c source file.
@@ -282,7 +304,10 @@ extern int  qla2x00_vp_abort_isp(scsi_qla_host_t *);
 /*
  * Global Function Prototypes in qla_iocb.c source file.
  */
-
+void qla_els_pt_iocb(struct scsi_qla_host *vha,
+	struct els_entry_24xx *pkt, struct qla_els_pt_arg *a);
+cont_a64_entry_t *qla2x00_prep_cont_type1_iocb(scsi_qla_host_t *vha,
+		struct req_que *que);
 extern uint16_t qla2x00_calc_iocbs_32(uint16_t);
 extern uint16_t qla2x00_calc_iocbs_64(uint16_t);
 extern void qla2x00_build_scsi_iocbs_32(srb_t *, cmd_entry_t *, uint16_t);
@@ -312,6 +337,8 @@ extern int qla24xx_walk_and_build_prot_sglist(struct qla_hw_data *, srb_t *,
 	struct dsd64 *, uint16_t, struct qla_tgt_cmd *);
 extern int qla24xx_get_one_block_sg(uint32_t, struct qla2_sgx *, uint32_t *);
 extern int qla24xx_configure_prot_mode(srb_t *, uint16_t *);
+extern int qla24xx_issue_sa_replace_iocb(scsi_qla_host_t *vha,
+	struct qla_work_evt *e);
 
 /*
  * Global Function Prototypes in qla_mbx.c source file.
@@ -579,6 +606,9 @@ qla2xxx_msix_rsp_q_hs(int irq, void *dev_id);
 fc_port_t *qla2x00_find_fcport_by_loopid(scsi_qla_host_t *, uint16_t);
 fc_port_t *qla2x00_find_fcport_by_wwpn(scsi_qla_host_t *, u8 *, u8);
 fc_port_t *qla2x00_find_fcport_by_nportid(scsi_qla_host_t *, port_id_t *, u8);
+void qla24xx_queue_purex_item(scsi_qla_host_t *vha, struct purex_item *pkt,
+	void (*process_item)(struct scsi_qla_host *, struct purex_item *));
+void __qla_consume_iocb(struct scsi_qla_host *vha, void **pkt, struct rsp_que **rsp);
 
 /*
  * Global Function Prototypes in qla_sup.c source file.
@@ -641,6 +671,8 @@ extern int qla2xxx_get_vpd_field(scsi_qla_host_t *, char *, char *, size_t);
 
 extern void qla2xxx_flash_npiv_conf(scsi_qla_host_t *);
 extern int qla24xx_read_fcp_prio_cfg(scsi_qla_host_t *);
+int __qla_copy_purex_to_buffer(struct scsi_qla_host *vha, void **pkt,
+	struct rsp_que **rsp, u8 *buf, u32 buf_len);
 
 /*
  * Global Function Prototypes in qla_dbg.c source file.
@@ -882,6 +914,9 @@ extern int qla2x00_issue_iocb_timeout(scsi_qla_host_t *, void *,
 	dma_addr_t, size_t, uint32_t);
 extern int qla2x00_get_idma_speed(scsi_qla_host_t *, uint16_t,
 	uint16_t *, uint16_t *);
+extern int qla24xx_sadb_update(struct bsg_job *bsg_job);
+extern int qla_post_sa_replace_work(struct scsi_qla_host *vha,
+	 fc_port_t *fcport, uint16_t nport_handle, struct edif_sa_ctl *sa_ctl);
 
 /* 83xx related functions */
 void qla83xx_fw_dump(scsi_qla_host_t *vha);
@@ -926,6 +961,7 @@ extern int qla_set_exchoffld_mem_cfg(scsi_qla_host_t *);
 extern void qlt_handle_abts_recv(struct scsi_qla_host *, struct rsp_que *,
 	response_t *);
 
+struct scsi_qla_host *qla_find_host_by_d_id(struct scsi_qla_host *vha, be_id_t d_id);
 int qla24xx_async_notify_ack(scsi_qla_host_t *, fc_port_t *,
 	struct imm_ntfy_from_isp *, int);
 void qla24xx_do_nack_work(struct scsi_qla_host *, struct qla_work_evt *);
@@ -938,7 +974,7 @@ extern struct fc_port *qlt_find_sess_invalidate_other(scsi_qla_host_t *,
 void qla24xx_delete_sess_fn(struct work_struct *);
 void qlt_unknown_atio_work_fn(struct work_struct *);
 void qlt_update_host_map(struct scsi_qla_host *, port_id_t);
-void qlt_remove_target_resources(struct qla_hw_data *);
+void qla_remove_hostmap(struct qla_hw_data *ha);
 void qlt_clr_qp_table(struct scsi_qla_host *vha);
 void qlt_set_mode(struct scsi_qla_host *);
 int qla2x00_set_data_rate(scsi_qla_host_t *vha, uint16_t mode);
@@ -953,6 +989,30 @@ extern void qla_nvme_abort_process_comp_status
 
 /* nvme.c */
 void qla_nvme_unregister_remote_port(struct fc_port *fcport);
+
+/* qla_edif.c */
+fc_port_t *qla2x00_find_fcport_by_pid(scsi_qla_host_t *vha, port_id_t *id);
+void qla_edb_eventcreate(scsi_qla_host_t *vha, uint32_t dbtype, uint32_t data, uint32_t data2,
+		fc_port_t *fcport);
+void qla_edb_stop(scsi_qla_host_t *vha);
+ssize_t edif_doorbell_show(struct device *dev, struct device_attribute *attr, char *buf);
+void ql_print_bsg_sglist(uint level, scsi_qla_host_t *vha, uint id, char *str,
+		struct bsg_buffer *p);
+int32_t qla_edif_app_mgmt(struct bsg_job *bsg_job);
+int qla2x00_check_rdp_test(uint32_t cmd, uint32_t port);
+void qla_enode_init(scsi_qla_host_t *vha);
+void qla_enode_stop(scsi_qla_host_t *vha);
+void qla_edif_flush_sa_ctl_lists(fc_port_t *fcport);
+void qla_edb_init(scsi_qla_host_t *vha);
+void qla_edif_timer_check(scsi_qla_host_t *vha);
+int qla28xx_start_scsi_edif(srb_t *sp);
+void qla24xx_sa_update_iocb(srb_t *sp, struct sa_update_28xx *sa_update_iocb);
+void qla24xx_sa_replace_iocb(srb_t *sp, struct sa_update_28xx *sa_update_iocb);
+void qla24xx_auth_els(scsi_qla_host_t *vha, void **pkt, struct rsp_que **rsp);
+void qla28xx_sa_update_iocb_entry(scsi_qla_host_t *vha, struct req_que *req,
+		struct sa_update_28xx *pkt);
+void qla_parse_auth_els_ctl(struct srb *sp);
+
 void qla_handle_els_plogi_done(scsi_qla_host_t *vha, struct event_arg *ea);
 
 #define QLA2XX_HW_ERROR			BIT_0
diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index 5b6e04a91a18..99fb330053ae 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -2826,6 +2826,10 @@ void qla24xx_handle_gpsc_event(scsi_qla_host_t *vha, struct event_arg *ea)
 	if (fcport->disc_state == DSC_DELETE_PEND)
 		return;
 
+	/* We will figure-out what happen after AUTH completes */
+	if (fcport->disc_state == DSC_LOGIN_AUTH_PEND)
+		return;
+
 	if (ea->sp->gen2 != fcport->login_gen) {
 		/* target side must have changed it. */
 		ql_dbg(ql_dbg_disc, vha, 0x20d3,
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 0de250570e39..d26f8f723ff6 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -34,7 +34,6 @@ static int qla2x00_restart_isp(scsi_qla_host_t *);
 static struct qla_chip_state_84xx *qla84xx_get_chip(struct scsi_qla_host *);
 static int qla84xx_init_chip(scsi_qla_host_t *);
 static int qla25xx_init_queues(struct qla_hw_data *);
-static int qla24xx_post_prli_work(struct scsi_qla_host*, fc_port_t *);
 static void qla24xx_handle_gpdb_event(scsi_qla_host_t *vha,
 				      struct event_arg *ea);
 static void qla24xx_handle_prli_done_event(struct scsi_qla_host *,
@@ -343,8 +342,25 @@ qla2x00_async_login(struct scsi_qla_host *vha, fc_port_t *fcport,
 	qla2x00_init_timer(sp, qla2x00_get_async_timeout(vha) + 2);
 
 	sp->done = qla2x00_async_login_sp_done;
-	if (N2N_TOPO(fcport->vha->hw) && fcport_is_bigger(fcport))
+	if (N2N_TOPO(fcport->vha->hw) && fcport_is_bigger(fcport)) {
 		lio->u.logio.flags |= SRB_LOGIN_PRLI_ONLY;
+	} else {
+		if (vha->hw->flags.edif_enabled) {
+			if (fcport->edif.non_secured_login == 0) {
+				lio->u.logio.flags |=
+					(SRB_LOGIN_FCSP | SRB_LOGIN_SKIP_PRLI);
+				ql_dbg(ql_dbg_disc, vha, 0x2072,
+	"Async-login: w/ FCSP %8phC hdl=%x, loopid=%x portid=%06x\n",
+				    fcport->port_name, sp->handle,
+				    fcport->loop_id,
+				    fcport->d_id.b24);
+			}
+		} else {
+			lio->u.logio.flags |= SRB_LOGIN_COND_PLOGI;
+		}
+	}
+	if (fcport->edif.enable)
+		fcport->edif.prli_to = EDIF_PRLI_TO;    // prli wait
 	else
 		lio->u.logio.flags |= SRB_LOGIN_COND_PLOGI;
 
@@ -378,7 +394,7 @@ static void qla2x00_async_logout_sp_done(srb_t *sp, int res)
 {
 	sp->fcport->flags &= ~(FCF_ASYNC_SENT | FCF_ASYNC_ACTIVE);
 	sp->fcport->login_gen++;
-	qlt_logo_completion_handler(sp->fcport, res);
+	qlt_logo_completion_handler(sp->fcport, sp->u.iocb_cmd.u.logio.data[0]);
 	sp->free(sp);
 }
 
@@ -404,10 +420,10 @@ qla2x00_async_logout(struct scsi_qla_host *vha, fc_port_t *fcport)
 	sp->done = qla2x00_async_logout_sp_done;
 
 	ql_dbg(ql_dbg_disc, vha, 0x2070,
-	    "Async-logout - hdl=%x loop-id=%x portid=%02x%02x%02x %8phC.\n",
+	    "Async-logout - hdl=%x loop-id=%x portid=%02x%02x%02x %8phC explicit %d.\n",
 	    sp->handle, fcport->loop_id, fcport->d_id.b.domain,
 		fcport->d_id.b.area, fcport->d_id.b.al_pa,
-		fcport->port_name);
+		fcport->port_name, fcport->explicit_logout);
 
 	rval = qla2x00_start_sp(sp);
 	if (rval != QLA_SUCCESS)
@@ -429,6 +445,7 @@ qla2x00_async_prlo_done(struct scsi_qla_host *vha, fc_port_t *fcport,
 	/* Don't re-login in target mode */
 	if (!fcport->tgt_session)
 		qla2x00_mark_device_lost(vha, fcport, 1);
+	fcport->prlo_rc = data[0];
 	qlt_logo_completion_handler(fcport, data[0]);
 }
 
@@ -466,9 +483,9 @@ qla2x00_async_prlo(struct scsi_qla_host *vha, fc_port_t *fcport)
 	sp->done = qla2x00_async_prlo_sp_done;
 
 	ql_dbg(ql_dbg_disc, vha, 0x2070,
-	    "Async-prlo - hdl=%x loop-id=%x portid=%02x%02x%02x.\n",
+	    "Async-prlo - hdl=%x loop-id=%x portid=%02x%02x%02x explicit %d.\n",
 	    sp->handle, fcport->loop_id, fcport->d_id.b.domain,
-	    fcport->d_id.b.area, fcport->d_id.b.al_pa);
+	    fcport->d_id.b.area, fcport->d_id.b.al_pa, fcport->explicit_prlo);
 
 	rval = qla2x00_start_sp(sp);
 	if (rval != QLA_SUCCESS)
@@ -479,7 +496,6 @@ qla2x00_async_prlo(struct scsi_qla_host *vha, fc_port_t *fcport)
 done_free_sp:
 	sp->free(sp);
 done:
-	fcport->flags &= ~FCF_ASYNC_ACTIVE;
 	return rval;
 }
 
@@ -656,7 +672,7 @@ static int qla2x00_find_new_loop_id(scsi_qla_host_t *vha, fc_port_t *dev)
 	spin_unlock_irqrestore(&ha->vport_slock, flags);
 
 	if (rval == QLA_SUCCESS)
-		ql_dbg(ql_dbg_disc, dev->vha, 0x2086,
+		ql_dbg(ql_dbg_disc + ql_dbg_verbose, dev->vha, 0x2086,
 		       "Assigning new loopid=%x, portid=%x.\n",
 		       dev->loop_id, dev->d_id.b24);
 	else
@@ -692,11 +708,11 @@ static void qla24xx_handle_gnl_done_event(scsi_qla_host_t *vha,
 
 	fcport = ea->fcport;
 	ql_dbg(ql_dbg_disc, vha, 0xffff,
-	    "%s %8phC DS %d LS rc %d %d login %d|%d rscn %d|%d lid %d\n",
+	    "%s %8phC DS %d LS rc %d %d login %d|%d rscn %d|%d lid %d edif %d\n",
 	    __func__, fcport->port_name, fcport->disc_state,
 	    fcport->fw_login_state, ea->rc,
 	    fcport->login_gen, fcport->last_login_gen,
-	    fcport->rscn_gen, fcport->last_rscn_gen, vha->loop_id);
+	    fcport->rscn_gen, fcport->last_rscn_gen, vha->loop_id, fcport->edif.enable);
 
 	if (fcport->disc_state == DSC_DELETE_PEND)
 		return;
@@ -822,6 +838,13 @@ static void qla24xx_handle_gnl_done_event(scsi_qla_host_t *vha,
 				qla2x00_post_async_adisc_work(vha, fcport,
 				    data);
 				break;
+			case DSC_LS_PLOGI_COMP:
+				if (vha->hw->flags.edif_enabled) {
+					/* check to see if he support Secure */
+					qla24xx_post_gpdb_work(vha, fcport, 0);
+					break;
+				}
+				fallthrough;
 			case DSC_LS_PORT_UNAVAIL:
 			default:
 				if (fcport->loop_id == FC_NO_LOOP_ID) {
@@ -1191,7 +1214,7 @@ static void qla24xx_async_gpdb_sp_done(srb_t *sp, int res)
 	sp->free(sp);
 }
 
-static int qla24xx_post_prli_work(struct scsi_qla_host *vha, fc_port_t *fcport)
+int qla24xx_post_prli_work(struct scsi_qla_host *vha, fc_port_t *fcport)
 {
 	struct qla_work_evt *e;
 
@@ -1397,6 +1420,12 @@ void __qla24xx_handle_gpdb_event(scsi_qla_host_t *vha, struct event_arg *ea)
 	ea->fcport->deleted = 0;
 	ea->fcport->logout_on_delete = 1;
 
+	ql_dbg(ql_dbg_disc, vha, 0x20dc,
+	    "%s:  %8phC login_succ %x , loop_id=%x, portid=%02x%02x%02x.\n",
+	    __func__, ea->fcport->port_name, ea->fcport->login_succ,
+	    ea->fcport->loop_id, ea->fcport->d_id.b.domain,
+	    ea->fcport->d_id.b.area, ea->fcport->d_id.b.al_pa);
+
 	if (!ea->fcport->login_succ && !IS_SW_RESV_ADDR(ea->fcport->d_id)) {
 		vha->fcport_count++;
 		ea->fcport->login_succ = 1;
@@ -1418,6 +1447,62 @@ void __qla24xx_handle_gpdb_event(scsi_qla_host_t *vha, struct event_arg *ea)
 	spin_unlock_irqrestore(&vha->hw->tgt.sess_lock, flags);
 }
 
+static int	qla_chk_secure_login(scsi_qla_host_t	*vha, fc_port_t *fcport,
+	struct port_database_24xx *pd)
+{
+	int rc = 0;
+
+	if (pd->secure_login) {
+		ql_dbg(ql_dbg_disc, vha, 0x104d,
+		    "Secure Login established on %8phC\n",
+		    fcport->port_name);
+		fcport->edif.secured_login = 1;
+		fcport->edif.non_secured_login = 0;
+		fcport->flags |= FCF_FCSP_DEVICE;
+	} else {
+		ql_dbg(ql_dbg_disc, vha, 0x104d,
+		    "non-Secure Login %8phC",
+		    fcport->port_name);
+		fcport->edif.secured_login = 0;
+		fcport->edif.non_secured_login = 1;
+	}
+	if (vha->hw->flags.edif_enabled) {
+		if (fcport->flags & FCF_FCSP_DEVICE) {
+			qla2x00_set_fcport_disc_state(fcport, DSC_LOGIN_AUTH_PEND);
+			/* Start edif prli timer & ring doorbell for app */
+			fcport->edif.rx_sa_set = 0;
+			fcport->edif.tx_sa_set = 0;
+			fcport->edif.rx_sa_pending = 0;
+			fcport->edif.tx_sa_pending = 0;
+			fcport->edif.rx_sa_selold = 1;
+			fcport->edif.tx_sa_selold = 1;
+
+			qla2x00_post_aen_work(vha, FCH_EVT_PORT_ONLINE,
+			    fcport->d_id.b24);
+
+			if (vha->e_dbell.db_flags ==  EDB_ACTIVE) {
+				ql_dbg(ql_dbg_disc, vha, 0x20ef,
+				    "%s %d %8phC EDIF: post DB_AUTH: AUTH needed\n",
+				    __func__, __LINE__, fcport->port_name);
+				fcport->edif.app_started = 1;
+				fcport->edif.app_sess_online = 1;
+
+				qla_edb_eventcreate(vha, VND_CMD_AUTH_STATE_NEEDED,
+				    fcport->d_id.b24, 0, fcport);
+			}
+
+			rc = 1;
+		} else {
+			ql_dbg(ql_dbg_disc, vha, 0x2117,
+			    "%s %d %8phC post prli\n",
+			    __func__, __LINE__, fcport->port_name);
+			qla24xx_post_prli_work(vha, fcport);
+			rc = 1;
+		}
+	}
+	return rc;
+}
+
 static
 void qla24xx_handle_gpdb_event(scsi_qla_host_t *vha, struct event_arg *ea)
 {
@@ -1460,8 +1545,11 @@ void qla24xx_handle_gpdb_event(scsi_qla_host_t *vha, struct event_arg *ea)
 	case PDS_PRLI_COMPLETE:
 		__qla24xx_parse_gpdb(vha, fcport, pd);
 		break;
-	case PDS_PLOGI_PENDING:
 	case PDS_PLOGI_COMPLETE:
+		if (qla_chk_secure_login(vha, fcport, pd))
+			return;
+		fallthrough;
+	case PDS_PLOGI_PENDING:
 	case PDS_PRLI_PENDING:
 	case PDS_PRLI2_PENDING:
 		/* Set discovery state back to GNL to Relogin attempt */
@@ -2053,26 +2141,38 @@ qla24xx_handle_plogi_done_event(struct scsi_qla_host *vha, struct event_arg *ea)
 		 * force a relogin attempt via implicit LOGO, PLOGI, and PRLI
 		 * requests.
 		 */
-		if (NVME_TARGET(vha->hw, ea->fcport)) {
-			ql_dbg(ql_dbg_disc, vha, 0x2117,
-				"%s %d %8phC post prli\n",
-				__func__, __LINE__, ea->fcport->port_name);
-			qla24xx_post_prli_work(vha, ea->fcport);
-		} else {
-			ql_dbg(ql_dbg_disc, vha, 0x20ea,
-			    "%s %d %8phC LoopID 0x%x in use with %06x. post gpdb\n",
-			    __func__, __LINE__, ea->fcport->port_name,
-			    ea->fcport->loop_id, ea->fcport->d_id.b24);
-
+		if (vha->hw->flags.edif_enabled) {
 			set_bit(ea->fcport->loop_id, vha->hw->loop_id_map);
 			spin_lock_irqsave(&vha->hw->tgt.sess_lock, flags);
 			ea->fcport->chip_reset = vha->hw->base_qpair->chip_reset;
 			ea->fcport->logout_on_delete = 1;
 			ea->fcport->send_els_logo = 0;
-			ea->fcport->fw_login_state = DSC_LS_PRLI_COMP;
+			ea->fcport->fw_login_state = DSC_LS_PLOGI_COMP;
 			spin_unlock_irqrestore(&vha->hw->tgt.sess_lock, flags);
 
 			qla24xx_post_gpdb_work(vha, ea->fcport, 0);
+		} else {
+			if (NVME_TARGET(vha->hw, fcport)) {
+				ql_dbg(ql_dbg_disc, vha, 0x2117,
+				    "%s %d %8phC post prli\n",
+				    __func__, __LINE__, fcport->port_name);
+				qla24xx_post_prli_work(vha, fcport);
+			} else {
+				ql_dbg(ql_dbg_disc, vha, 0x20ea,
+				    "%s %d %8phC LoopID 0x%x in use with %06x. post gpdb\n",
+				    __func__, __LINE__, fcport->port_name,
+				    fcport->loop_id, fcport->d_id.b24);
+
+				set_bit(fcport->loop_id, vha->hw->loop_id_map);
+				spin_lock_irqsave(&vha->hw->tgt.sess_lock, flags);
+				fcport->chip_reset = vha->hw->base_qpair->chip_reset;
+				fcport->logout_on_delete = 1;
+				fcport->send_els_logo = 0;
+				fcport->fw_login_state = DSC_LS_PRLI_COMP;
+				spin_unlock_irqrestore(&vha->hw->tgt.sess_lock, flags);
+
+				qla24xx_post_gpdb_work(vha, fcport, 0);
+			}
 		}
 		break;
 	case MBS_COMMAND_ERROR:
@@ -3877,7 +3977,8 @@ qla2x00_setup_chip(scsi_qla_host_t *vha)
 		}
 
 		/* Enable PUREX PASSTHRU */
-		if (ql2xrdpenable || ha->flags.scm_supported_f)
+		if (ql2xrdpenable || ha->flags.scm_supported_f ||
+		    ha->flags.edif_enabled)
 			qla25xx_set_els_cmds_supported(vha);
 	} else
 		goto failed;
@@ -4062,7 +4163,7 @@ qla24xx_update_fw_options(scsi_qla_host_t *vha)
 	}
 
 	/* Move PUREX, ABTS RX & RIDA to ATIOQ */
-	if (ql2xmvasynctoatio &&
+	if (ql2xmvasynctoatio && !ha->flags.edif_enabled &&
 	    (IS_QLA83XX(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha))) {
 		if (qla_tgt_mode_enabled(vha) ||
 		    qla_dual_mode_enabled(vha))
@@ -4090,7 +4191,8 @@ qla24xx_update_fw_options(scsi_qla_host_t *vha)
 			ha->fw_options[2] &= ~BIT_8;
 	}
 
-	if (ql2xrdpenable || ha->flags.scm_supported_f)
+	if (ql2xrdpenable || ha->flags.scm_supported_f ||
+	    ha->flags.edif_enabled)
 		ha->fw_options[1] |= ADD_FO1_ENABLE_PUREX_IOCB;
 
 	/* Enable Async 8130/8131 events -- transceiver insertion/removal */
@@ -5073,6 +5175,17 @@ qla2x00_alloc_fcport(scsi_qla_host_t *vha, gfp_t flags)
 	INIT_LIST_HEAD(&fcport->sess_cmd_list);
 	spin_lock_init(&fcport->sess_cmd_lock);
 
+	spin_lock_init(&fcport->edif.sa_list_lock);
+	INIT_LIST_HEAD(&fcport->edif.tx_sa_list);
+	INIT_LIST_HEAD(&fcport->edif.rx_sa_list);
+
+	if (vha->e_dbell.db_flags == EDB_ACTIVE)
+		fcport->edif.app_started = 1;
+
+	// edif rx delete data structure
+	spin_lock_init(&fcport->edif.indx_list_lock);
+	INIT_LIST_HEAD(&fcport->edif.edif_indx_list);
+
 	return fcport;
 }
 
@@ -5086,8 +5199,13 @@ qla2x00_free_fcport(fc_port_t *fcport)
 
 		fcport->ct_desc.ct_sns = NULL;
 	}
+
+	qla_edif_flush_sa_ctl_lists(fcport);
 	list_del(&fcport->list);
 	qla2x00_clear_loop_id(fcport);
+
+	qla_edif_list_del(fcport);
+
 	kfree(fcport);
 }
 
@@ -5206,6 +5324,12 @@ qla2x00_configure_loop(scsi_qla_host_t *vha)
 			    "LOOP READY.\n");
 			ha->flags.fw_init_done = 1;
 
+			if (vha->hw->flags.edif_enabled &&
+			    vha->e_dbell.db_flags != EDB_ACTIVE) {
+				/* wake up authentication app to get ready */
+				qla2x00_post_aen_work(vha, FCH_EVT_PORT_ONLINE, 0);
+			}
+
 			/*
 			 * Process any ATIO queue entries that came in
 			 * while we weren't online.
@@ -5225,7 +5349,8 @@ qla2x00_configure_loop(scsi_qla_host_t *vha)
 		    "%s *** FAILED ***.\n", __func__);
 	} else {
 		ql_dbg(ql_dbg_disc, vha, 0x206b,
-		    "%s: exiting normally.\n", __func__);
+		    "%s: exiting normally. local port wwpn %8phN id %06x)\n",
+		    __func__, vha->port_name, vha->d_id.b24);
 	}
 
 	/* Restore state if a resync event occurred during processing */
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 38b5bdde2405..75ec1e22179a 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -118,7 +118,7 @@ qla2x00_prep_cont_type0_iocb(struct scsi_qla_host *vha)
  *
  * Returns a pointer to the continuation type 1 IOCB packet.
  */
-static inline cont_a64_entry_t *
+cont_a64_entry_t *
 qla2x00_prep_cont_type1_iocb(scsi_qla_host_t *vha, struct req_que *req)
 {
 	cont_a64_entry_t *cont_pkt;
@@ -1605,6 +1605,9 @@ qla24xx_start_scsi(srb_t *sp)
 	struct scsi_qla_host *vha = sp->vha;
 	struct qla_hw_data *ha = vha->hw;
 
+	if (sp->fcport->edif.enable)
+		return qla28xx_start_scsi_edif(sp);
+
 	/* Setup device pointers. */
 	req = vha->req;
 	rsp = req->rsp;
@@ -1961,6 +1964,9 @@ qla2xxx_start_scsi_mq(srb_t *sp)
 	struct qla_hw_data *ha = vha->hw;
 	struct qla_qpair *qpair = sp->qpair;
 
+	if (sp->fcport->edif.enable)
+		return qla28xx_start_scsi_edif(sp);
+
 	/* Acquire qpair specific lock */
 	spin_lock_irqsave(&qpair->qp_lock, flags);
 
@@ -2462,6 +2468,12 @@ qla24xx_login_iocb(srb_t *sp, struct logio_entry_24xx *logio)
 			logio->control_flags |= cpu_to_le16(LCF_COND_PLOGI);
 		if (lio->u.logio.flags & SRB_LOGIN_SKIP_PRLI)
 			logio->control_flags |= cpu_to_le16(LCF_SKIP_PRLI);
+		if (lio->u.logio.flags & SRB_LOGIN_FCSP) {
+			logio->control_flags |=
+			    cpu_to_le16(LCF_COMMON_FEAT | LCF_SKIP_PRLI);
+			logio->io_parameter[0] =
+			    cpu_to_le32(LIO_COMM_FEAT_FCSP | LIO_COMM_FEAT_CIO);
+		}
 	}
 	logio->nport_handle = cpu_to_le16(sp->fcport->loop_id);
 	logio->port_id[0] = sp->fcport->d_id.b.al_pa;
@@ -2802,7 +2814,7 @@ qla24xx_els_logo_iocb(srb_t *sp, struct els_entry_24xx *els_iocb)
 		    (uint8_t *)els_iocb,
 		    sizeof(*els_iocb));
 	} else {
-		els_iocb->control_flags = cpu_to_le16(1 << 13);
+		//els_iocb->control_flags = cpu_to_le16(1 << 13);
 		els_iocb->tx_byte_count =
 			cpu_to_le32(sizeof(struct els_logo_payload));
 		put_unaligned_le64(elsio->u.els_logo.els_logo_pyld_dma,
@@ -3102,6 +3114,44 @@ qla24xx_els_dcmd2_iocb(scsi_qla_host_t *vha, int els_opcode,
 	return rval;
 }
 
+/* it is assume qpair lock is held */
+void qla_els_pt_iocb(struct scsi_qla_host *vha,
+	struct els_entry_24xx *els_iocb,
+	struct qla_els_pt_arg *a)
+{
+	els_iocb->entry_type = ELS_IOCB_TYPE;
+	els_iocb->entry_count = 1;
+	els_iocb->sys_define = 0;
+	els_iocb->entry_status = 0;
+	els_iocb->handle = QLA_SKIP_HANDLE;
+	els_iocb->nport_handle = a->nport_handle;
+	// no need for endiance conversion.
+	els_iocb->rx_xchg_address = a->rx_xchg_address;
+	els_iocb->tx_dsd_count = cpu_to_le16(1);
+	els_iocb->vp_index = a->vp_idx;
+	els_iocb->sof_type = EST_SOFI3;
+	els_iocb->rx_dsd_count = cpu_to_le16(0);
+	els_iocb->opcode = a->els_opcode;
+
+	els_iocb->d_id[0] = a->did.b.al_pa;
+	els_iocb->d_id[1] = a->did.b.area;
+	els_iocb->d_id[2] = a->did.b.domain;
+	/* For SID the byte order is different than DID */
+	els_iocb->s_id[1] = vha->d_id.b.al_pa;
+	els_iocb->s_id[2] = vha->d_id.b.area;
+	els_iocb->s_id[0] = vha->d_id.b.domain;
+
+	els_iocb->control_flags = cpu_to_le16(a->control_flags);
+
+	els_iocb->tx_byte_count = cpu_to_le32(a->tx_byte_count);
+	els_iocb->tx_len = cpu_to_le32(a->tx_len);
+	put_unaligned_le64(a->tx_addr, &els_iocb->tx_address);
+
+	els_iocb->rx_byte_count = cpu_to_le32(a->rx_byte_count);
+	els_iocb->rx_len = cpu_to_le32(a->rx_len);
+	put_unaligned_le64(a->rx_addr, &els_iocb->rx_address);
+}
+
 static void
 qla24xx_els_iocb(srb_t *sp, struct els_entry_24xx *els_iocb)
 {
@@ -3696,6 +3746,16 @@ static void qla2x00_send_notify_ack_iocb(srb_t *sp,
 	nack->u.isp24.srr_reject_code = 0;
 	nack->u.isp24.srr_reject_code_expl = 0;
 	nack->u.isp24.vp_index = ntfy->u.isp24.vp_index;
+
+	if (ntfy->u.isp24.status_subcode == ELS_PLOGI &&
+	    (le16_to_cpu(ntfy->u.isp24.flags) & NOTIFY24XX_FLAGS_FCSP) &&
+	    sp->vha->hw->flags.edif_enabled) {
+		ql_dbg(ql_dbg_disc, sp->vha, 0x3074,
+		    "%s PLOGI NACK sent with FC SECURITY bit, hdl=%x, loopid=%x, to pid %06x\n",
+		    sp->name, sp->handle, sp->fcport->loop_id,
+		    sp->fcport->d_id.b24);
+		nack->u.isp24.flags |= cpu_to_le16(NOTIFY_ACK_FLAGS_FCSP);
+	}
 }
 
 /*
@@ -3750,9 +3810,14 @@ static void
 qla24xx_prlo_iocb(srb_t *sp, struct logio_entry_24xx *logio)
 {
 	logio->entry_type = LOGINOUT_PORT_IOCB_TYPE;
-	logio->control_flags =
-	    cpu_to_le16(LCF_COMMAND_PRLO|LCF_IMPL_PRLO);
-
+	if (sp->fcport->explicit_prlo) {
+		logio->control_flags = cpu_to_le16(LCF_COMMAND_PRLO);
+		logio->io_parameter[0] = cpu_to_le32(ELS_PRLO << 24|
+		    PRLO_TYPE_CODE_EXT << 16 | PRLO_CMD_LEN);
+	} else {
+		logio->control_flags =
+		   cpu_to_le16(LCF_COMMAND_PRLO|LCF_IMPL_PRLO);
+	}
 	logio->nport_handle = cpu_to_le16(sp->fcport->loop_id);
 	logio->port_id[0] = sp->fcport->d_id.b.al_pa;
 	logio->port_id[1] = sp->fcport->d_id.b.area;
@@ -3800,6 +3865,10 @@ qla2x00_start_sp(srb_t *sp)
 	case SRB_ELS_CMD_HST:
 		qla24xx_els_iocb(sp, pkt);
 		break;
+	case SRB_ELS_CMD_HST_NOLOGIN:
+		qla_els_pt_iocb(sp->vha, pkt,  &sp->u.bsg_cmd.u.els_arg);
+		((struct els_entry_24xx *)pkt)->handle = sp->handle;
+		break;
 	case SRB_CT_CMD:
 		IS_FWI2_CAPABLE(ha) ?
 		    qla24xx_ct_iocb(sp, pkt) :
@@ -3847,6 +3916,12 @@ qla2x00_start_sp(srb_t *sp)
 	case SRB_PRLO_CMD:
 		qla24xx_prlo_iocb(sp, pkt);
 		break;
+	case SRB_SA_UPDATE:
+		qla24xx_sa_update_iocb(sp, pkt);
+		break;
+	case SRB_SA_REPLACE:
+		qla24xx_sa_replace_iocb(sp, pkt);
+		break;
 	default:
 		break;
 	}
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 6e8f737a4af3..b78da7657629 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -169,6 +169,128 @@ qla24xx_process_abts(struct scsi_qla_host *vha, struct purex_item *pkt)
 	dma_free_coherent(&ha->pdev->dev, sizeof(*rsp_els), rsp_els, dma);
 }
 
+/* it is assumed pkt is the head iocb, not the continuation iocb */
+void __qla_consume_iocb(struct scsi_qla_host *vha,
+	void **pkt, struct rsp_que **rsp)
+{
+	struct rsp_que *rsp_q = *rsp;
+	response_t *new_pkt;
+	uint16_t entry_count_remaining;
+	struct purex_entry_24xx *purex = *pkt;
+
+	entry_count_remaining = purex->entry_count;
+	while (entry_count_remaining > 0) {
+		new_pkt = rsp_q->ring_ptr;
+		*pkt = new_pkt;
+
+		rsp_q->ring_index++;
+		if (rsp_q->ring_index == rsp_q->length) {
+			rsp_q->ring_index = 0;
+			rsp_q->ring_ptr = rsp_q->ring;
+		} else {
+			rsp_q->ring_ptr++;
+		}
+
+		new_pkt->signature = RESPONSE_PROCESSED;
+		// flush signature
+		wmb();
+		--entry_count_remaining;
+	}
+}
+
+int __qla_copy_purex_to_buffer(struct scsi_qla_host *vha,
+	void **pkt, struct rsp_que **rsp, u8 *buf, u32 buf_len)
+{
+	struct purex_entry_24xx *purex = *pkt;
+	struct rsp_que *rsp_q = *rsp;
+	sts_cont_entry_t *new_pkt;
+	uint16_t no_bytes = 0, total_bytes = 0, pending_bytes = 0;
+	uint16_t buffer_copy_offset = 0;
+	uint16_t entry_count_remaining;
+	u16 tpad;
+
+	entry_count_remaining = purex->entry_count;
+	total_bytes = (le16_to_cpu(purex->frame_size) & 0x0FFF)
+		- PURX_ELS_HEADER_SIZE;
+
+	/* end of payload may not end in 4bytes boundary.  Need to
+	 * round up / pad for room to swap, before saving data
+	 */
+	tpad = roundup(total_bytes, 4);
+
+	if (buf_len < tpad) {
+		ql_dbg(ql_dbg_async, vha, 0x5084,
+		    "%s buffer is too small %d < %d\n",
+		    __func__, buf_len, tpad);
+		__qla_consume_iocb(vha, pkt, rsp);
+		return -EIO;
+	}
+
+	pending_bytes = total_bytes = tpad;
+	no_bytes = (pending_bytes > sizeof(purex->els_frame_payload))  ?
+	sizeof(purex->els_frame_payload) : pending_bytes;
+
+	memcpy(buf, &purex->els_frame_payload[0], no_bytes);
+	buffer_copy_offset += no_bytes;
+	pending_bytes -= no_bytes;
+	--entry_count_remaining;
+
+	((response_t *)purex)->signature = RESPONSE_PROCESSED;
+	// flush signature
+	wmb();
+
+	do {
+		while ((total_bytes > 0) && (entry_count_remaining > 0)) {
+			new_pkt = (sts_cont_entry_t *)rsp_q->ring_ptr;
+			*pkt = new_pkt;
+
+			if (new_pkt->entry_type != STATUS_CONT_TYPE) {
+				ql_log(ql_log_warn, vha, 0x507a,
+				    "Unexpected IOCB type, partial data 0x%x\n",
+				    buffer_copy_offset);
+				break;
+			}
+
+			rsp_q->ring_index++;
+			if (rsp_q->ring_index == rsp_q->length) {
+				rsp_q->ring_index = 0;
+				rsp_q->ring_ptr = rsp_q->ring;
+			} else {
+				rsp_q->ring_ptr++;
+			}
+			no_bytes = (pending_bytes > sizeof(new_pkt->data)) ?
+			    sizeof(new_pkt->data) : pending_bytes;
+			if ((buffer_copy_offset + no_bytes) <= total_bytes) {
+				memcpy((buf + buffer_copy_offset), new_pkt->data,
+				    no_bytes);
+				buffer_copy_offset += no_bytes;
+				pending_bytes -= no_bytes;
+				--entry_count_remaining;
+			} else {
+				ql_log(ql_log_warn, vha, 0x5044,
+				    "Attempt to copy more that we got, optimizing..%x\n",
+				    buffer_copy_offset);
+				memcpy((buf + buffer_copy_offset), new_pkt->data,
+				    total_bytes - buffer_copy_offset);
+			}
+
+			((response_t *)new_pkt)->signature = RESPONSE_PROCESSED;
+			// flush signature
+			wmb();
+		}
+
+		if (pending_bytes != 0 || entry_count_remaining != 0) {
+			ql_log(ql_log_fatal, vha, 0x508b,
+			    "Dropping partial Data, underrun bytes = 0x%x, entry cnts 0x%x\n",
+			    total_bytes, entry_count_remaining);
+			return -EIO;
+		}
+	} while (entry_count_remaining > 0);
+
+	be32_to_cpu_array((u32 *)buf, (__be32 *)buf, total_bytes >> 2);
+	return 0;
+}
+
 /**
  * qla2100_intr_handler() - Process interrupts for the ISP2100 and ISP2200.
  * @irq: interrupt number
@@ -815,7 +937,7 @@ qla24xx_alloc_purex_item(scsi_qla_host_t *vha, uint16_t size)
 	return item;
 }
 
-static void
+void
 qla24xx_queue_purex_item(scsi_qla_host_t *vha, struct purex_item *pkt,
 			 void (*process_item)(struct scsi_qla_host *vha,
 					      struct purex_item *pkt))
@@ -1192,6 +1314,11 @@ qla2x00_async_event(scsi_qla_host_t *vha, struct rsp_que *rsp, uint16_t *mb)
 		ha->current_topology = 0;
 		vha->link_down_time = 0;
 
+		// TODO: edif: Disable global SAs
+		// TODO: edif: index's were moved (?) - invalidate new indexes
+		// vha->hw->fast_tx_sa_index = INVALID_SAIDX;
+		// vha->hw->fast_rx_sa_index = INVALID_SAIDX;
+
 		mbx = (IS_QLA81XX(ha) || IS_QLA8031(ha))
 			? rd_reg_word(&reg24->mailbox4) : 0;
 		mbx = (IS_P3P_TYPE(ha)) ? rd_reg_word(&reg82->mailbox_out[4])
@@ -1330,6 +1457,13 @@ qla2x00_async_event(scsi_qla_host_t *vha, struct rsp_que *rsp, uint16_t *mb)
 		set_bit(LOCAL_LOOP_UPDATE, &vha->dpc_flags);
 		break;
 
+// TODO: edif: index's were moved - invalidate new indexes
+// TODO: edif: Is this case still valid?
+//	case MBA_FAST_LOGIN:		/* Port database update */
+//		// Disable global SAs
+//		vha->hw->fast_tx_sa_index = INVALID_SAIDX;
+//		vha->hw->fast_rx_sa_index = INVALID_SAIDX;
+//		mb[2] &= 0xFF;
 	case MBA_PORT_UPDATE:		/* Port database update */
 		/*
 		 * Handle only global and vn-port update events
@@ -1727,6 +1861,9 @@ qla2x00_get_sp_from_handle(scsi_qla_host_t *vha, const char *func,
 	srb_t *sp;
 	uint16_t index;
 
+	if (pkt->handle == QLA_SKIP_HANDLE)
+		return NULL;
+
 	index = LSW(pkt->handle);
 	if (index >= req->num_outstanding_cmds) {
 		ql_log(ql_log_warn, vha, 0x5031,
@@ -1971,7 +2108,7 @@ qla2x00_ct_entry(scsi_qla_host_t *vha, struct req_que *req,
 }
 
 static void
-qla24xx_els_ct_entry(scsi_qla_host_t *vha, struct req_que *req,
+qla24xx_els_ct_entry(scsi_qla_host_t *v, struct req_que *req,
     struct sts_entry_24xx *pkt, int iocb_type)
 {
 	struct els_sts_entry_24xx *ese = (struct els_sts_entry_24xx *)pkt;
@@ -1982,18 +2119,62 @@ qla24xx_els_ct_entry(scsi_qla_host_t *vha, struct req_que *req,
 	struct fc_bsg_reply *bsg_reply;
 	uint16_t comp_status;
 	uint32_t fw_status[3];
-	int res;
+	int res, logit = 1;
 	struct srb_iocb *els;
+	uint n;
+	scsi_qla_host_t *vha;
+	struct els_sts_entry_24xx *e = (struct els_sts_entry_24xx *)pkt;
 
-	sp = qla2x00_get_sp_from_handle(vha, func, req, pkt);
+	sp = qla2x00_get_sp_from_handle(v, func, req, pkt);
 	if (!sp)
 		return;
+	bsg_job = sp->u.bsg_job;
+	vha = sp->vha;
 
 	type = NULL;
+
+	comp_status = fw_status[0] = le16_to_cpu(pkt->comp_status);
+	fw_status[1] = le32_to_cpu(((struct els_sts_entry_24xx *)pkt)->error_subcode_1);
+	fw_status[2] = le32_to_cpu(((struct els_sts_entry_24xx *)pkt)->error_subcode_2);
+
 	switch (sp->type) {
 	case SRB_ELS_CMD_RPT:
 	case SRB_ELS_CMD_HST:
+		type = "rpt hst";
+		break;
+	case SRB_ELS_CMD_HST_NOLOGIN:
 		type = "els";
+		{
+			struct els_entry_24xx *els = (void *)pkt;
+			struct qla_bsg_auth_els_request *p =
+				(struct qla_bsg_auth_els_request *)bsg_job->request;
+
+			ql_dbg(ql_dbg_user, vha, 0x700f,
+			     "%s %s. portid=%02x%02x%02x status %x xchg %x bsg ptr %p\n",
+			     __func__, sc_to_str(p->e.sub_cmd),
+			     e->d_id[2], e->d_id[1], e->d_id[0],
+			     comp_status, p->e.extra_rx_xchg_address, bsg_job);
+
+			if (!(le16_to_cpu(els->control_flags) & ECF_PAYLOAD_DESCR_MASK)) {
+				if (sp->remap.remapped) {
+					n = sg_copy_from_buffer(bsg_job->reply_payload.sg_list,
+						bsg_job->reply_payload.sg_cnt,
+						sp->remap.rsp.buf,
+						sp->remap.rsp.len);
+					ql_dbg(ql_dbg_user + ql_dbg_verbose, vha, 0x700e,
+					   "%s: SG copied %x of %x\n",
+					   __func__, n, sp->remap.rsp.len);
+					ql_print_bsg_sglist(ql_dbg_user + ql_dbg_verbose,
+						vha, 0x700f,
+						"SG bsg->reply",
+						&bsg_job->reply_payload);
+				} else {
+					ql_dbg(ql_dbg_user, vha, 0x700f,
+					   "%s: NOT REMAPPED (error)...!!!\n",
+					   __func__);
+				}
+			}
+		}
 		break;
 	case SRB_CT_CMD:
 		type = "ct pass-through";
@@ -2023,10 +2204,6 @@ qla24xx_els_ct_entry(scsi_qla_host_t *vha, struct req_que *req,
 		return;
 	}
 
-	comp_status = fw_status[0] = le16_to_cpu(pkt->comp_status);
-	fw_status[1] = le32_to_cpu(ese->error_subcode_1);
-	fw_status[2] = le32_to_cpu(ese->error_subcode_2);
-
 	if (iocb_type == ELS_IOCB_TYPE) {
 		els = &sp->u.iocb_cmd;
 		els->u.els_plogi.fw_status[0] = cpu_to_le32(fw_status[0]);
@@ -2040,15 +2217,52 @@ qla24xx_els_ct_entry(scsi_qla_host_t *vha, struct req_que *req,
 				res =  DID_OK << 16;
 				els->u.els_plogi.len = cpu_to_le16(le32_to_cpu(
 					ese->total_byte_count));
+
+				if (sp->remap.remapped &&
+				    ((u8 *)sp->remap.rsp.buf)[0] == ELS_LS_ACC) {
+					ql_dbg(ql_dbg_user, vha, 0x503f,
+					    "%s IOCB Done LS_ACC %02x%02x%02x -> %02x%02x%02x",
+					    __func__, e->s_id[0], e->s_id[2], e->s_id[1],
+					    e->d_id[2], e->d_id[1], e->d_id[0]);
+					logit = 0;
+				}
+
+			} else if (comp_status == CS_PORT_LOGGED_OUT) {
+				els->u.els_plogi.len = 0;
+				res = DID_IMM_RETRY << 16;
 			} else {
 				els->u.els_plogi.len = 0;
 				res = DID_ERROR << 16;
 			}
+
+			if (logit) {
+				if (sp->remap.remapped &&
+				    ((u8 *)sp->remap.rsp.buf)[0] == ELS_LS_RJT) {
+					ql_dbg(ql_dbg_user, vha, 0x503f,
+					    "%s IOCB Done LS_RJT hdl=%x comp_status=0x%x\n",
+					    type, sp->handle, comp_status);
+
+					ql_dbg(ql_dbg_user, vha, 0x503f,
+					    "subcode 1=0x%x subcode 2=0x%x bytes=0x%x %02x%02x%02x -> %02x%02x%02x\n",
+					    fw_status[1], fw_status[2],
+					    le32_to_cpu(((struct els_sts_entry_24xx *)
+						pkt)->total_byte_count),
+					    e->s_id[0], e->s_id[2], e->s_id[1],
+					    e->d_id[2], e->d_id[1], e->d_id[0]);
+				} else {
+					ql_log(ql_log_info, vha, 0x503f,
+					    "%s IOCB Done hdl=%x comp_status=0x%x\n",
+					    type, sp->handle, comp_status);
+					ql_log(ql_log_info, vha, 0x503f,
+					    "subcode 1=0x%x subcode 2=0x%x bytes=0x%x %02x%02x%02x -> %02x%02x%02x\n",
+					    fw_status[1], fw_status[2],
+					    le32_to_cpu(((struct els_sts_entry_24xx *)
+						pkt)->total_byte_count),
+					    e->s_id[0], e->s_id[2], e->s_id[1],
+					    e->d_id[2], e->d_id[1], e->d_id[0]);
+				}
+			} //logit
 		}
-		ql_dbg(ql_dbg_disc, vha, 0x503f,
-		    "ELS IOCB Done -%s hdl=%x comp_status=0x%x error subcode 1=0x%x error subcode 2=0x%x total_byte=0x%x\n",
-		    type, sp->handle, comp_status, fw_status[1], fw_status[2],
-		    le32_to_cpu(ese->total_byte_count));
 		goto els_ct_done;
 	}
 
@@ -2153,6 +2367,10 @@ qla24xx_logio_entry(scsi_qla_host_t *vha, struct req_que *req,
 		if (sp->type != SRB_LOGIN_CMD)
 			goto logio_done;
 
+		lio->u.logio.iop[1] = le32_to_cpu(logio->io_parameter[5]); // common features
+		if (le32_to_cpu(logio->io_parameter[5]) & LIO_COMM_FEAT_FCSP)
+			fcport->flags |= FCF_FCSP_DEVICE;
+
 		iop[0] = le32_to_cpu(logio->io_parameter[0]);
 		if (iop[0] & BIT_4) {
 			fcport->port_type = FCT_TARGET;
@@ -2977,6 +3195,8 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, void *pkt)
 	}
 
 	/* Fast path completion. */
+	qla_chk_edif_rx_sa_delete_pending(vha, sp, sts24);
+
 	if (comp_status == CS_COMPLETE && scsi_status == 0) {
 		qla2x00_process_completed_request(vha, req, handle);
 
@@ -3338,7 +3558,8 @@ qla2x00_error_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, sts_entry_t *pkt)
 	struct req_que *req = NULL;
 	int res = DID_ERROR << 16;
 
-	ql_dbg(ql_dbg_async, vha, 0x502a,
+	// ql_dbg(ql_dbg_async, vha, 0x502a,
+	ql_log(ql_log_warn, vha, 0x3014,
 	    "iocb type %xh with error status %xh, handle %xh, rspq id %d\n",
 	    pkt->entry_type, pkt->entry_status, pkt->handle, rsp->id);
 
@@ -3371,6 +3592,9 @@ qla2x00_error_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, sts_entry_t *pkt)
 		}
 		break;
 
+	case SA_UPDATE_IOCB_TYPE:
+		return 1;	// let sa_update_iocb_entry cleanup everything
+
 	case ABTS_RESP_24XX:
 	case CTIO_TYPE7:
 	case CTIO_CRC2:
@@ -3457,6 +3681,55 @@ void qla24xx_nvme_ls4_iocb(struct scsi_qla_host *vha,
 	sp->done(sp, comp_status);
 }
 
+/* check for all continuation iocbs are available. */
+static int qla_chk_cont_iocb_avail(struct scsi_qla_host *vha,
+	struct rsp_que *rsp, response_t *pkt)
+{
+	int start_pkt_ring_index, end_pkt_ring_index, n_ring_index;
+	response_t *end_pkt;
+	int rc = 0;
+	u32 rsp_q_in;
+
+	if (pkt->entry_count == 1)
+		return rc;
+
+	/* ring_index was pre-increment. set it back to current pkt */
+	if (rsp->ring_index == 0)
+		start_pkt_ring_index = rsp->length - 1;
+	else
+		start_pkt_ring_index = rsp->ring_index - 1;
+
+	if ((start_pkt_ring_index + pkt->entry_count) >= rsp->length)
+		end_pkt_ring_index = start_pkt_ring_index + pkt->entry_count -
+			rsp->length - 1;
+	else
+		end_pkt_ring_index = start_pkt_ring_index + pkt->entry_count - 1;
+
+	end_pkt = rsp->ring + end_pkt_ring_index;
+
+	//  next pkt = end_pkt + 1
+	n_ring_index = end_pkt_ring_index + 1;
+	if (n_ring_index >= rsp->length)
+		n_ring_index = 0;
+
+	rsp_q_in = rsp->qpair->use_shadow_reg ? *rsp->in_ptr :
+		rd_reg_dword(rsp->rsp_q_in);
+
+	/* rsp_q_in is either wrapped or pointing beyond endpkt */
+	if ((rsp_q_in < start_pkt_ring_index && rsp_q_in < n_ring_index) ||
+			rsp_q_in >= n_ring_index)
+		// all IOCBs arrived.
+		rc = 0;
+	else
+		rc = -EIO;
+
+	ql_dbg(ql_dbg_init + ql_dbg_verbose, vha, 0x5091,
+		"%s - ring %p pkt %p end pkt %p entry count %#x rsp_q_in %d rc %d\n",
+		__func__, rsp->ring, pkt, end_pkt, pkt->entry_count,
+		rsp_q_in, rc);
+	return rc;
+}
+
 /**
  * qla24xx_process_response_queue() - Process response queue entries.
  * @vha: SCSI driver HA context
@@ -3597,12 +3870,26 @@ void qla24xx_process_response_queue(struct scsi_qla_host *vha,
 						 qla27xx_process_purex_fpin);
 				break;
 
+			case ELS_AUTH_ELS:
+				if (qla_chk_cont_iocb_avail(vha, rsp, (response_t *)pkt)) {
+					ql_dbg(ql_dbg_init, vha, 0x5091,
+					    "Defer processing ELS opcode %#x...\n",
+					    purex_entry->els_frame_payload[3]);
+					return;
+				}
+				qla24xx_auth_els(vha, (void **)&pkt, &rsp);
+				break;
 			default:
 				ql_log(ql_log_warn, vha, 0x509c,
 				       "Discarding ELS Request opcode 0x%x\n",
 				       purex_entry->els_frame_payload[3]);
 			}
 			break;
+		case SA_UPDATE_IOCB_TYPE:
+			qla28xx_sa_update_iocb_entry(vha, rsp->req,
+				(struct sa_update_28xx *)pkt);
+			break;
+
 		default:
 			/* Type Not Supported. */
 			ql_dbg(ql_dbg_async, vha, 0x5042,
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 0bcd8afdc0ff..08d35d1aff1c 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -61,6 +61,7 @@ static struct rom_cmd {
 	{ MBC_SET_RNID_PARAMS },
 	{ MBC_GET_RNID_PARAMS },
 	{ MBC_GET_SET_ZIO_THRESHOLD },
+	{ MBC_GET_RNID_PARAMS },
 };
 
 static int is_rom_cmd(uint16_t cmd)
@@ -739,7 +740,7 @@ qla2x00_execute_fw(scsi_qla_host_t *vha, uint32_t risc_addr)
 			mcp->mb[11] |= EXE_FW_FORCE_SEMAPHORE;
 
 		mcp->out_mb |= MBX_4 | MBX_3 | MBX_2 | MBX_1 | MBX_11;
-		mcp->in_mb |= MBX_3 | MBX_2 | MBX_1;
+		mcp->in_mb |= MBX_5|MBX_3|MBX_2|MBX_1;
 	} else {
 		mcp->mb[1] = LSW(risc_addr);
 		mcp->out_mb |= MBX_1;
@@ -795,6 +796,12 @@ qla2x00_execute_fw(scsi_qla_host_t *vha, uint32_t risc_addr)
 		}
 	}
 
+	if (IS_QLA28XX(ha) && (mcp->mb[5] & BIT_10) && ql2xsecenable) {
+		ha->flags.edif_enabled = 1;
+		ql_log(ql_log_info + ql_dbg_edif, vha, 0xffff,
+		    "%s: edif is enabled\n", __func__);
+	}
+
 done:
 	ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x1028,
 	    "Done %s.\n", __func__);
@@ -2768,9 +2775,14 @@ qla24xx_fabric_logout(scsi_qla_host_t *vha, uint16_t loop_id, uint8_t domain,
 	lg->entry_count = 1;
 	lg->handle = make_handle(req->id, lg->handle);
 	lg->nport_handle = cpu_to_le16(loop_id);
-	lg->control_flags =
-	    cpu_to_le16(LCF_COMMAND_LOGO|LCF_IMPL_LOGO|
-		LCF_FREE_NPORT);
+	if (!ha->flags.edif_enabled) {
+		lg->control_flags =
+		    cpu_to_le16(LCF_COMMAND_LOGO|LCF_IMPL_LOGO|
+			LCF_FREE_NPORT);
+	} else {
+		lg->control_flags =
+		    cpu_to_le16(LCF_COMMAND_LOGO|LCF_IMPL_LOGO);
+	}
 	lg->port_id[0] = al_pa;
 	lg->port_id[1] = area;
 	lg->port_id[2] = domain;
@@ -4946,7 +4958,7 @@ qla24xx_get_port_login_templ(scsi_qla_host_t *vha, dma_addr_t buf_dma,
 	return rval;
 }
 
-#define PUREX_CMD_COUNT	2
+#define PUREX_CMD_COUNT	4
 int
 qla25xx_set_els_cmds_supported(scsi_qla_host_t *vha)
 {
@@ -4954,6 +4966,7 @@ qla25xx_set_els_cmds_supported(scsi_qla_host_t *vha)
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
 	uint8_t *els_cmd_map;
+	uint8_t active_cnt = 0;
 	dma_addr_t els_cmd_map_dma;
 	uint8_t cmd_opcode[PUREX_CMD_COUNT];
 	uint8_t i, index, purex_bit;
@@ -4975,10 +4988,20 @@ qla25xx_set_els_cmds_supported(scsi_qla_host_t *vha)
 	}
 
 	/* List of Purex ELS */
-	cmd_opcode[0] = ELS_FPIN;
-	cmd_opcode[1] = ELS_RDP;
+	if (ql2xrdpenable) {
+		cmd_opcode[active_cnt] = ELS_RDP;
+		active_cnt++;
+	}
+	if (ha->flags.scm_supported_f) {
+		cmd_opcode[active_cnt] = ELS_FPIN;
+		active_cnt++;
+	}
+	if (ha->flags.edif_enabled) {
+		cmd_opcode[active_cnt] = ELS_AUTH_ELS;
+		active_cnt++;
+	}
 
-	for (i = 0; i < PUREX_CMD_COUNT; i++) {
+	for (i = 0; i < active_cnt; i++) {
 		index = cmd_opcode[i] / 8;
 		purex_bit = cmd_opcode[i] % 8;
 		els_cmd_map[index] |= 1 << purex_bit;
@@ -6588,6 +6611,12 @@ int __qla24xx_parse_gpdb(struct scsi_qla_host *vha, fc_port_t *fcport,
 	fcport->d_id.b.al_pa = pd->port_id[2];
 	fcport->d_id.b.rsvd_1 = 0;
 
+	ql_dbg(ql_dbg_disc, vha, 0x2062,
+	     "%8phC SVC Param w3 %02x%02x",
+	     fcport->port_name,
+	     pd->prli_svc_param_word_3[1],
+	     pd->prli_svc_param_word_3[0]);
+
 	if (NVME_TARGET(vha->hw, fcport)) {
 		fcport->port_type = FCT_NVME;
 		if ((pd->prli_svc_param_word_3[0] & BIT_5) == 0)
diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
index c7caf322f445..432fbba47922 100644
--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -158,6 +158,10 @@ qla24xx_disable_vp(scsi_qla_host_t *vha)
 	int ret = QLA_SUCCESS;
 	fc_port_t *fcport;
 
+	if (vha->hw->flags.edif_enabled)
+		// delete sessions and flush sa_indexes
+		qla2x00_wait_for_sess_deletion(vha);
+
 	if (vha->hw->flags.fw_started)
 		ret = qla24xx_control_vp(vha, VCE_COMMAND_DISABLE_VPS_LOGO_ALL);
 
@@ -166,7 +170,8 @@ qla24xx_disable_vp(scsi_qla_host_t *vha)
 	list_for_each_entry(fcport, &vha->vp_fcports, list)
 		fcport->logout_on_delete = 0;
 
-	qla2x00_mark_all_devices_lost(vha);
+	if (!vha->hw->flags.edif_enabled)
+		qla2x00_wait_for_sess_deletion(vha);
 
 	/* Remove port id from vp target map */
 	spin_lock_irqsave(&vha->hw->hardware_lock, flags);
diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_nvme.c
index 0cacb667a88b..bec3df3d9ace 100644
--- a/drivers/scsi/qla2xxx/qla_nvme.c
+++ b/drivers/scsi/qla2xxx/qla_nvme.c
@@ -463,6 +463,10 @@ static inline int qla2x00_start_nvme_mq(srb_t *sp)
 	} else if (fd->io_dir == 0) {
 		cmd_pkt->control_flags = 0;
 	}
+	if (sp->fcport->edif.enable && fd->io_dir != 0) {
+		cmd_pkt->control_flags |= cpu_to_le16(CF_EN_EDIF);
+		cmd_pkt->control_flags &= ~(cpu_to_le16(CF_NEW_SA));
+	}
 	/* Set BIT_13 of control flags for Async event */
 	if (vha->flags.nvme2_enabled &&
 	    cmd->sqe.common.opcode == nvme_admin_async_event) {
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 4eab564ea6a0..07a109ee3814 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -53,6 +53,11 @@ static struct kmem_cache *ctx_cachep;
  */
 uint ql_errlev = 0x8001;
 
+int ql2xsecenable;
+module_param(ql2xsecenable, int, S_IRUGO);
+MODULE_PARM_DESC(ql2xsecenable,
+	"Enable/disable security. 0(Default) - Security disabled. 1 - Security enabled.");
+
 static int ql2xenableclass2;
 module_param(ql2xenableclass2, int, S_IRUGO|S_IRUSR);
 MODULE_PARM_DESC(ql2xenableclass2,
@@ -1119,13 +1124,28 @@ static inline int test_fcport_count(scsi_qla_host_t *vha)
 {
 	struct qla_hw_data *ha = vha->hw;
 	unsigned long flags;
-	int res;
+	int res; // 0 = sleep, x=wake
 
 	spin_lock_irqsave(&ha->tgt.sess_lock, flags);
 	ql_dbg(ql_dbg_init, vha, 0x00ec,
 	    "tgt %p, fcport_count=%d\n",
 	    vha, vha->fcport_count);
 	res = (vha->fcport_count == 0);
+	if  (res) {
+		struct fc_port *fcport;
+
+		list_for_each_entry(fcport, &vha->vp_fcports, list) {
+			if (fcport->deleted != QLA_SESS_DELETED) {
+				/* session(s) may not be fully logged in
+				 * (ie fcport_count=0), but session
+				 * deletion thread(s) may be inflight.
+				 */
+
+				res = 0;
+				break;
+			}
+		}
+	}
 	spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
 
 	return res;
@@ -2835,6 +2855,20 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	spin_lock_init(&ha->tgt.sess_lock);
 	spin_lock_init(&ha->tgt.atio_lock);
 
+	// edif sadb
+	spin_lock_init(&ha->sadb_lock);
+	INIT_LIST_HEAD(&ha->sadb_tx_index_list);
+	INIT_LIST_HEAD(&ha->sadb_rx_index_list);
+
+	// edif sa_index free pool
+	spin_lock_init(&ha->sadb_fp_lock);
+
+	// build the sadb sa_index free pool
+	if (qla_edif_sadb_build_free_pool(ha)) {
+		kfree(ha);
+		goto  disable_device;
+	}
+
 	atomic_set(&ha->nvme_active_aen_cnt, 0);
 
 	/* Clear our data area */
@@ -3460,6 +3494,8 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	return 0;
 
 probe_failed:
+	qla_enode_stop(base_vha);
+	qla_edb_stop(base_vha);
 	if (base_vha->gnl.l) {
 		dma_free_coherent(&ha->pdev->dev, base_vha->gnl.size,
 				base_vha->gnl.l, base_vha->gnl.ldma);
@@ -3762,6 +3798,8 @@ qla2x00_remove_one(struct pci_dev *pdev)
 		base_vha->gnl.size, base_vha->gnl.l, base_vha->gnl.ldma);
 
 	base_vha->gnl.l = NULL;
+	qla_enode_stop(base_vha);
+	qla_edb_stop(base_vha);
 
 	vfree(base_vha->scan.l);
 
@@ -3795,7 +3833,6 @@ qla2x00_remove_one(struct pci_dev *pdev)
 	qla2x00_free_sysfs_attr(base_vha, true);
 
 	fc_remove_host(base_vha->host);
-	qlt_remove_target_resources(ha);
 
 	scsi_remove_host(base_vha->host);
 
@@ -3867,6 +3904,9 @@ qla2x00_free_device(scsi_qla_host_t *vha)
 
 	qla82xx_md_free(vha);
 
+	qla_edif_sadb_release_free_pool(ha);
+	qla_edif_sadb_release(ha);
+
 	qla2x00_free_queues(ha);
 }
 
@@ -3918,7 +3958,10 @@ void qla2x00_mark_device_lost(scsi_qla_host_t *vha, fc_port_t *fcport,
 	    vha->vp_idx == fcport->vha->vp_idx) {
 		qla2x00_set_fcport_state(fcport, FCS_DEVICE_LOST);
 		qla2x00_schedule_rport_del(vha, fcport);
+
 	}
+
+	qla_edif_sess_down(vha, fcport);
 	/*
 	 * We may need to retry the login, so don't change the state of the
 	 * port but do the retries.
@@ -3972,15 +4015,20 @@ qla2x00_mem_alloc(struct qla_hw_data *ha, uint16_t req_len, uint16_t rsp_len,
 	struct req_que **req, struct rsp_que **rsp)
 {
 	char	name[16];
+	int rc;
 
 	ha->init_cb = dma_alloc_coherent(&ha->pdev->dev, ha->init_cb_size,
 		&ha->init_cb_dma, GFP_KERNEL);
 	if (!ha->init_cb)
 		goto fail;
 
-	if (qlt_mem_alloc(ha) < 0)
+	rc = btree_init32(&ha->host_map);
+	if (rc)
 		goto fail_free_init_cb;
 
+	if (qlt_mem_alloc(ha) < 0)
+		goto fail_free_btree;
+
 	ha->gid_list = dma_alloc_coherent(&ha->pdev->dev,
 		qla2x00_gid_list_size(ha), &ha->gid_list_dma, GFP_KERNEL);
 	if (!ha->gid_list)
@@ -3990,7 +4038,7 @@ qla2x00_mem_alloc(struct qla_hw_data *ha, uint16_t req_len, uint16_t rsp_len,
 	if (!ha->srb_mempool)
 		goto fail_free_gid_list;
 
-	if (IS_P3P_TYPE(ha)) {
+	if (IS_P3P_TYPE(ha) || IS_QLA27XX(ha) || (ql2xsecenable & IS_QLA28XX(ha))) {
 		/* Allocate cache for CT6 Ctx. */
 		if (!ctx_cachep) {
 			ctx_cachep = kmem_cache_create("qla2xxx_ctx",
@@ -4024,7 +4072,7 @@ qla2x00_mem_alloc(struct qla_hw_data *ha, uint16_t req_len, uint16_t rsp_len,
 	    "init_cb=%p gid_list=%p, srb_mempool=%p s_dma_pool=%p.\n",
 	    ha->init_cb, ha->gid_list, ha->srb_mempool, ha->s_dma_pool);
 
-	if (IS_P3P_TYPE(ha) || ql2xenabledif) {
+	if (IS_P3P_TYPE(ha) || ql2xenabledif || (IS_QLA28XX(ha) & ql2xsecenable)) {
 		ha->dl_dma_pool = dma_pool_create(name, &ha->pdev->dev,
 			DSD_LIST_DMA_POOL_SIZE, 8, 0);
 		if (!ha->dl_dma_pool) {
@@ -4264,8 +4312,37 @@ qla2x00_mem_alloc(struct qla_hw_data *ha, uint16_t req_len, uint16_t rsp_len,
 		goto fail_flt_buffer;
 	}
 
+	/* allocate the purex dma pool */
+	// TODO: check alignment value of 8 --> sb 8k?
+	ha->purex_dma_pool = dma_pool_create(name, &ha->pdev->dev,
+	    MAX_PAYLOAD, 8, 0);
+
+	if (!ha->purex_dma_pool) {
+		ql_dbg_pci(ql_dbg_init, ha->pdev, 0x011b,
+		    "Unable to allocate purex_dma_pool.\n");
+		goto fail_flt;
+	}
+
+	ha->elsrej.size = sizeof(struct fc_els_ls_rjt) + 16;
+	ha->elsrej.c = dma_alloc_coherent(&ha->pdev->dev,
+	    ha->elsrej.size, &ha->elsrej.cdma, GFP_KERNEL);
+
+	if (!ha->elsrej.c) {
+		ql_dbg_pci(ql_dbg_init, ha->pdev, 0xffff,
+		    "Alloc failed for els reject cmd.\n");
+		goto fail_elsrej;
+	}
+	ha->elsrej.c->er_cmd = ELS_LS_RJT;
+	ha->elsrej.c->er_reason = ELS_RJT_BUSY;
+	ha->elsrej.c->er_explan = ELS_EXPL_UNAB_DATA;
 	return 0;
 
+fail_elsrej:
+	dma_pool_destroy(ha->purex_dma_pool);
+fail_flt:
+	dma_free_coherent(&ha->pdev->dev, SFP_DEV_SIZE,
+	    ha->flt, ha->flt_dma);
+
 fail_flt_buffer:
 	dma_free_coherent(&ha->pdev->dev, SFP_DEV_SIZE,
 	    ha->sfp_data, ha->sfp_data_dma);
@@ -4356,6 +4433,8 @@ qla2x00_mem_alloc(struct qla_hw_data *ha, uint16_t req_len, uint16_t rsp_len,
 	ha->gid_list_dma = 0;
 fail_free_tgt_mem:
 	qlt_mem_free(ha);
+fail_free_btree:
+	btree_destroy32(&ha->host_map);
 fail_free_init_cb:
 	dma_free_coherent(&ha->pdev->dev, ha->init_cb_size, ha->init_cb,
 	ha->init_cb_dma);
@@ -4772,10 +4851,21 @@ qla2x00_mem_free(struct qla_hw_data *ha)
 	ha->dif_bundl_pool = NULL;
 
 	qlt_mem_free(ha);
+	qla_remove_hostmap(ha);
 
 	if (ha->init_cb)
 		dma_free_coherent(&ha->pdev->dev, ha->init_cb_size,
 			ha->init_cb, ha->init_cb_dma);
+
+	dma_pool_destroy(ha->purex_dma_pool);
+	ha->purex_dma_pool = NULL;
+
+	if (ha->elsrej.c) {
+		dma_free_coherent(&ha->pdev->dev, ha->elsrej.size,
+		    ha->elsrej.c, ha->elsrej.cdma);
+		ha->elsrej.c = NULL;
+	}
+
 	ha->init_cb = NULL;
 	ha->init_cb_dma = 0;
 
@@ -4837,6 +4927,9 @@ struct scsi_qla_host *qla2x00_create_host(struct scsi_host_template *sht,
 	spin_lock_init(&vha->cmd_list_lock);
 	init_waitqueue_head(&vha->fcport_waitQ);
 	init_waitqueue_head(&vha->vref_waitq);
+	qla_enode_init(vha);
+	qla_edb_init(vha);
+
 
 	vha->gnl.size = sizeof(struct get_name_list_extended) *
 			(ha->max_loop_id + 1);
@@ -5327,6 +5420,9 @@ qla2x00_do_work(struct scsi_qla_host *vha)
 			qla24xx_els_dcmd2_iocb(vha, ELS_DCMD_PLOGI,
 			    e->u.fcport.fcport, false);
 			break;
+		case QLA_EVT_SA_REPLACE:
+			qla24xx_issue_sa_replace_iocb(vha, e);
+			break;
 		}
 
 		if (rc == EAGAIN) {
@@ -5376,6 +5472,7 @@ void qla2x00_relogin(struct scsi_qla_host *vha)
 		if (atomic_read(&fcport->state) != FCS_ONLINE &&
 		    fcport->login_retry) {
 			if (fcport->scan_state != QLA_FCPORT_FOUND ||
+			    fcport->disc_state == DSC_LOGIN_AUTH_PEND ||
 			    fcport->disc_state == DSC_LOGIN_COMPLETE)
 				continue;
 
@@ -6960,6 +7057,9 @@ qla2x00_do_dpc(void *data)
 				       threshold);
 			}
 		}
+		if (test_and_clear_bit(EDIF_TICK_NEEDED,
+		    &base_vha->dpc_flags))
+			qla_edif_timer_check(base_vha);
 
 		if (!IS_QLAFX00(ha))
 			qla2x00_do_dpc_all_vps(base_vha);
@@ -7168,6 +7268,12 @@ qla2x00_timer(struct timer_list *t)
 		}
 	}
 
+	/* check if edif running */
+	if (vha->hw->flags.edif_enabled) {
+		set_bit(EDIF_TICK_NEEDED, &vha->dpc_flags);
+		start_dpc++;
+	}
+
 	/* Process any deferred work. */
 	if (!list_empty(&vha->work_list)) {
 		unsigned long flags;
@@ -7220,15 +7326,14 @@ qla2x00_timer(struct timer_list *t)
 	    test_bit(FCOE_CTX_RESET_NEEDED, &vha->dpc_flags) ||
 	    test_bit(VP_DPC_NEEDED, &vha->dpc_flags) ||
 	    test_bit(RELOGIN_NEEDED, &vha->dpc_flags) ||
+	    test_bit(EDIF_TICK_NEEDED, &vha->dpc_flags) ||
 	    test_bit(PROCESS_PUREX_IOCB, &vha->dpc_flags))) {
 		ql_dbg(ql_dbg_timer, vha, 0x600b,
-		    "isp_abort_needed=%d loop_resync_needed=%d "
-		    "fcport_update_needed=%d start_dpc=%d "
-		    "reset_marker_needed=%d",
+"isp_abort_needed=%d loop_resync_needed=%d fcport_update_needed=%d start_dpc=%d edif=%d reset_marker_needed=%d",
 		    test_bit(ISP_ABORT_NEEDED, &vha->dpc_flags),
 		    test_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags),
 		    test_bit(FCPORT_UPDATE_NEEDED, &vha->dpc_flags),
-		    start_dpc,
+		    start_dpc, test_bit(EDIF_TICK_NEEDED, &vha->dpc_flags),
 		    test_bit(RESET_MARKER_NEEDED, &vha->dpc_flags));
 		ql_dbg(ql_dbg_timer, vha, 0x600c,
 		    "beacon_blink_needed=%d isp_unrecoverable=%d "
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index b2008fb1dd38..0a8e05fde695 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -184,8 +184,7 @@ static inline int qlt_issue_marker(struct scsi_qla_host *vha, int vha_locked)
 	return QLA_SUCCESS;
 }
 
-static inline
-struct scsi_qla_host *qlt_find_host_by_d_id(struct scsi_qla_host *vha,
+struct scsi_qla_host *qla_find_host_by_d_id(struct scsi_qla_host *vha,
 					    be_id_t d_id)
 {
 	struct scsi_qla_host *host;
@@ -198,11 +197,13 @@ struct scsi_qla_host *qlt_find_host_by_d_id(struct scsi_qla_host *vha,
 
 	key = be_to_port_id(d_id).b24;
 
-	host = btree_lookup32(&vha->hw->tgt.host_map, key);
+	host = btree_lookup32(&vha->hw->host_map, key);
 	if (!host)
 		ql_dbg(ql_dbg_tgt_mgt + ql_dbg_verbose, vha, 0xf005,
 		    "Unable to find host %06x\n", key);
 
+	ql_dbg(ql_dbg_tgt_mgt, vha, 0xf005,
+	    "find host %06x host %p\n", key, host);
 	return host;
 }
 
@@ -299,7 +300,7 @@ static void qlt_try_to_dequeue_unknown_atios(struct scsi_qla_host *vha,
 			goto abort;
 		}
 
-		host = qlt_find_host_by_d_id(vha, u->atio.u.isp24.fcp_hdr.d_id);
+		host = qla_find_host_by_d_id(vha, u->atio.u.isp24.fcp_hdr.d_id);
 		if (host != NULL) {
 			ql_dbg(ql_dbg_async + ql_dbg_verbose, vha, 0x502f,
 			    "Requeuing unknown ATIO_TYPE7 %p\n", u);
@@ -348,7 +349,7 @@ static bool qlt_24xx_atio_pkt_all_vps(struct scsi_qla_host *vha,
 	switch (atio->u.raw.entry_type) {
 	case ATIO_TYPE7:
 	{
-		struct scsi_qla_host *host = qlt_find_host_by_d_id(vha,
+		struct scsi_qla_host *host = qla_find_host_by_d_id(vha,
 		    atio->u.isp24.fcp_hdr.d_id);
 		if (unlikely(NULL == host)) {
 			ql_dbg(ql_dbg_tgt, vha, 0xe03e,
@@ -577,6 +578,18 @@ static void qla2x00_async_nack_sp_done(srb_t *sp, int res)
 		sp->fcport->logout_on_delete = 1;
 		sp->fcport->plogi_nack_done_deadline = jiffies + HZ;
 		sp->fcport->send_els_logo = 0;
+
+		if (sp->fcport->flags & FCF_FCSP_DEVICE) {
+			ql_dbg(ql_dbg_edif, vha, 0x20ef,
+			    "%s %8phC edif: PLOGI- AUTH WAIT\n", __func__,
+			    sp->fcport->port_name);
+			qla2x00_set_fcport_disc_state(sp->fcport,
+			    DSC_LOGIN_AUTH_PEND);
+			qla2x00_post_aen_work(vha, FCH_EVT_PORT_ONLINE,
+			    sp->fcport->d_id.b24);
+			qla_edb_eventcreate(vha, VND_CMD_AUTH_STATE_NEEDED, sp->fcport->d_id.b24,
+			    0, sp->fcport);
+		}
 		break;
 
 	case SRB_NACK_PRLI:
@@ -624,6 +637,10 @@ int qla24xx_async_notify_ack(scsi_qla_host_t *vha, fc_port_t *fcport,
 	case SRB_NACK_PLOGI:
 		fcport->fw_login_state = DSC_LS_PLOGI_PEND;
 		c = "PLOGI";
+		if (vha->hw->flags.edif_enabled &&
+		    (le16_to_cpu(ntfy->u.isp24.flags) & NOTIFY24XX_FLAGS_FCSP)) {
+			fcport->flags |= FCF_FCSP_DEVICE;
+		}
 		break;
 	case SRB_NACK_PRLI:
 		fcport->fw_login_state = DSC_LS_PRLI_PEND;
@@ -693,7 +710,12 @@ void qla24xx_do_nack_work(struct scsi_qla_host *vha, struct qla_work_evt *e)
 void qla24xx_delete_sess_fn(struct work_struct *work)
 {
 	fc_port_t *fcport = container_of(work, struct fc_port, del_work);
-	struct qla_hw_data *ha = fcport->vha->hw;
+	struct qla_hw_data *ha = NULL;
+
+	if (!fcport || !fcport->vha || !fcport->vha->hw)
+		return;
+
+	ha = fcport->vha->hw;
 
 	if (fcport->se_sess) {
 		ha->tgt.tgt_ops->shutdown_sess(fcport);
@@ -965,6 +987,19 @@ void qlt_free_session_done(struct work_struct *work)
 		sess->send_els_logo);
 
 	if (!IS_SW_RESV_ADDR(sess->d_id)) {
+		if (ha->flags.edif_enabled &&
+		    (!own || own->iocb.u.isp24.status_subcode == ELS_PLOGI)) {
+			if (!ha->flags.host_shutting_down) {
+				ql_dbg(ql_dbg_edif, vha, 0x911e,
+					"%s wwpn %8phC calling qla2x00_release_all_sadb\n",
+					__func__, sess->port_name);
+				qla2x00_release_all_sadb(vha, sess);
+			} else {
+				ql_dbg(ql_dbg_edif, vha, 0x911e,
+					"%s bypassing release_all_sadb\n",
+					__func__);
+			}
+		}
 		qla2x00_mark_device_lost(vha, sess, 0);
 
 		if (sess->send_els_logo) {
@@ -972,8 +1007,11 @@ void qlt_free_session_done(struct work_struct *work)
 
 			logo.id = sess->d_id;
 			logo.cmd_count = 0;
-			if (!own)
+			INIT_LIST_HEAD(&logo.list);
+			if (!own) {
 				qlt_send_first_logo(vha, &logo);
+				msleep(100);
+			}
 			sess->send_els_logo = 0;
 		}
 
@@ -982,6 +1020,7 @@ void qlt_free_session_done(struct work_struct *work)
 
 			if (!own ||
 			     (own->iocb.u.isp24.status_subcode == ELS_PLOGI)) {
+				sess->logout_completed = 0;
 				rc = qla2x00_post_async_logout_work(vha, sess,
 				    NULL);
 				if (rc != QLA_SUCCESS)
@@ -992,6 +1031,13 @@ void qlt_free_session_done(struct work_struct *work)
 					logout_started = true;
 			} else if (own && (own->iocb.u.isp24.status_subcode ==
 				ELS_PRLI) && ha->flags.rida_fmt2) {
+				sess->prlo_rc = MBS_COMMAND_COMPLETE;
+
+				ql_dbg(ql_dbg_disc, vha, 0xf084,
+	"%s: se_sess %p / sess %p from port %8phC loop_id %#04x  Schedule PRLO",
+				    __func__, sess->se_sess, sess,
+				    sess->port_name, sess->loop_id);
+
 				rc = qla2x00_post_async_prlo_work(vha, sess,
 				    NULL);
 				if (rc != QLA_SUCCESS)
@@ -1111,7 +1157,7 @@ void qlt_free_session_done(struct work_struct *work)
 		}
 	}
 
-	sess->explicit_logout = 0;
+	sess->explicit_logout = sess->explicit_prlo =  0;
 	spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
 	sess->free_pending = 0;
 
@@ -1718,6 +1764,12 @@ static void qlt_send_notify_ack(struct qla_qpair *qpair,
 	nack->u.isp24.srr_reject_code_expl = srr_explan;
 	nack->u.isp24.vp_index = ntfy->u.isp24.vp_index;
 
+	// TODO qualify this with EDIF enable
+	if (ntfy->u.isp24.status_subcode == ELS_PLOGI &&
+	    (le16_to_cpu(ntfy->u.isp24.flags) & NOTIFY24XX_FLAGS_FCSP)) {
+		nack->u.isp24.flags |= cpu_to_le16(NOTIFY_ACK_FLAGS_FCSP);
+	}
+
 	ql_dbg(ql_dbg_tgt, vha, 0xe005,
 	    "qla_target(%d): Sending 24xx Notify Ack %d\n",
 	    vha->vp_idx, nack->u.isp24.status);
@@ -2569,6 +2621,14 @@ static int qlt_24xx_build_ctio_pkt(struct qla_qpair *qpair,
 	struct ctio7_to_24xx *pkt;
 	struct atio_from_isp *atio = &prm->cmd->atio;
 	uint16_t temp;
+	uint32_t byte_count = 0;
+	struct qla_tgt_cmd      *cmd = prm->cmd;
+
+	byte_count = cmd->bufflen;
+	if (cmd->dma_data_direction == DMA_TO_DEVICE)
+		prm->cmd->sess->edif.rx_bytes += byte_count;
+	if (cmd->dma_data_direction == DMA_FROM_DEVICE)
+		prm->cmd->sess->edif.tx_bytes += byte_count;
 
 	pkt = (struct ctio7_to_24xx *)qpair->req->ring_ptr;
 	prm->pkt = pkt;
@@ -2601,6 +2661,11 @@ static int qlt_24xx_build_ctio_pkt(struct qla_qpair *qpair,
 	pkt->u.status0.ox_id = cpu_to_le16(temp);
 	pkt->u.status0.relative_offset = cpu_to_le32(prm->cmd->offset);
 
+	if (prm->cmd->edif) {
+		pkt->u.status0.edif_flags |= EF_EN_EDIF;
+		pkt->u.status0.edif_flags &= ~CF_NEW_SA;
+	}
+
 	return 0;
 }
 
@@ -3022,6 +3087,9 @@ qlt_build_ctio_crc2_pkt(struct qla_qpair *qpair, struct qla_tgt_prm *prm)
 	uint16_t t16;
 	scsi_qla_host_t *vha = cmd->vha;
 
+	// TODO need to address this for edif.  FW is only
+	// supporting ctio crc4.
+
 	ha = vha->hw;
 
 	pkt = (struct ctio_crc2_to_fw *)qpair->req->ring_ptr;
@@ -3291,8 +3359,8 @@ int qlt_xmit_response(struct qla_tgt_cmd *cmd, int xmit_type,
 			if (xmit_type & QLA_TGT_XMIT_STATUS) {
 				pkt->u.status0.scsi_status =
 				    cpu_to_le16(prm.rq_result);
-				pkt->u.status0.residual =
-				    cpu_to_le32(prm.residual);
+				//pkt->u.status0.residual =
+				//    cpu_to_le32(prm.residual);
 				pkt->u.status0.flags |= cpu_to_le16(
 				    CTIO7_FLAGS_SEND_STATUS);
 				if (qlt_need_explicit_conf(cmd, 0)) {
@@ -3939,6 +4007,12 @@ static void qlt_do_ctio_completion(struct scsi_qla_host *vha,
 	if (cmd == NULL)
 		return;
 
+	if ((le16_to_cpu(((struct ctio7_from_24xx *)ctio)->flags) & CTIO7_FLAGS_DATA_OUT) &&
+	    cmd->sess) {
+		qlt_chk_edif_rx_sa_delete_pending(vha, cmd->sess,
+		    (struct ctio7_from_24xx *)ctio);
+	}
+
 	se_cmd = &cmd->se_cmd;
 	cmd->cmd_sent_to_fw = 0;
 
@@ -4009,6 +4083,16 @@ static void qlt_do_ctio_completion(struct scsi_qla_host *vha,
 			qlt_handle_dif_error(qpair, cmd, ctio);
 			return;
 		}
+
+		case CTIO_FAST_AUTH_ERR:
+		case CTIO_FAST_INCOMP_PAD_LEN:
+		case CTIO_FAST_INVALID_REQ:
+		case CTIO_FAST_SPI_ERR:
+			ql_dbg(ql_dbg_tgt_mgt, vha, 0xf05b,
+	"qla_target(%d): CTIO with EDIF error status 0x%x received (state %x, se_cmd %p\n",
+			    vha->vp_idx, status, cmd->state, se_cmd);
+			break;
+
 		default:
 			ql_dbg(ql_dbg_tgt_mgt, vha, 0xf05b,
 			    "qla_target(%d): CTIO with error status 0x%x received (state %x, se_cmd %p\n",
@@ -4310,6 +4394,7 @@ static struct qla_tgt_cmd *qlt_get_tag(scsi_qla_host_t *vha,
 	qlt_assign_qpair(vha, cmd);
 	cmd->reset_count = vha->hw->base_qpair->chip_reset;
 	cmd->vp_idx = vha->vp_idx;
+	cmd->edif = sess->edif.enable;
 
 	return cmd;
 }
@@ -4725,6 +4810,15 @@ static int qlt_handle_login(struct scsi_qla_host *vha,
 		goto out;
 	}
 
+	if (vha->hw->flags.edif_enabled &&
+	    vha->e_dbell.db_flags != EDB_ACTIVE) {
+		ql_dbg(ql_dbg_disc, vha, 0xffff,
+			"%s %d Term INOT due to app not available lid=%d, NportID %06X ",
+			__func__, __LINE__, loop_id, port_id.b24);
+		qlt_send_term_imm_notif(vha, iocb, 1);
+		goto out;
+	}
+
 	pla = qlt_plogi_ack_find_add(vha, &port_id, iocb);
 	if (!pla) {
 		ql_dbg(ql_dbg_disc + ql_dbg_verbose, vha, 0xffff,
@@ -4744,7 +4838,7 @@ static int qlt_handle_login(struct scsi_qla_host *vha,
 	if (!sess) {
 		pla->ref_count++;
 		ql_dbg(ql_dbg_disc, vha, 0xffff,
-		    "%s %d %8phC post new sess\n",
+		    "%s %d %8phC post new sess 1\n",
 		    __func__, __LINE__, iocb->u.isp24.port_name);
 		if (iocb->u.isp24.status_subcode == ELS_PLOGI)
 			qla24xx_post_newsess_work(vha, &port_id,
@@ -4790,6 +4884,16 @@ static int qlt_handle_login(struct scsi_qla_host *vha,
 	qlt_plogi_ack_link(vha, pla, sess, QLT_PLOGI_LINK_SAME_WWN);
 	sess->d_id = port_id;
 	sess->login_gen++;
+	sess->loop_id = loop_id;
+
+	if (iocb->u.isp24.status_subcode == ELS_PLOGI) {
+		ql_dbg(ql_dbg_disc, vha, 0xffff,
+		    "%s %8phC - send port online\n",
+		    __func__, sess->port_name);
+
+		qla2x00_post_aen_work(vha, FCH_EVT_PORT_ONLINE,
+		    sess->d_id.b24);
+	}
 
 	if (iocb->u.isp24.status_subcode == ELS_PRLI) {
 		sess->fw_login_state = DSC_LS_PRLI_PEND;
@@ -4807,9 +4911,11 @@ static int qlt_handle_login(struct scsi_qla_host *vha,
 		else
 			sess->port_type = FCT_TARGET;
 
-	} else
+	} else {
 		sess->fw_login_state = DSC_LS_PLOGI_PEND;
-
+		/* TODO: Enable fcport here */
+		// if (vha->flags.edif_enabled)
+	}
 
 	ql_dbg(ql_dbg_disc, vha, 0x20f9,
 	    "%s %d %8phC  DS %d\n",
@@ -5953,6 +6059,10 @@ void qlt_async_event(uint16_t code, struct scsi_qla_host *vha,
 	case MBA_LIP_OCCURRED:
 	case MBA_LOOP_DOWN:
 	case MBA_LIP_RESET:
+		// Disable global SAs
+		// TODO: moved - still need to do?
+		//vha->hw->fast_tx_sa_index = INVALID_SAIDX;
+		//vha->hw->fast_rx_sa_index = INVALID_SAIDX;
 	case MBA_RSCN_UPDATE:
 		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf03c,
 		    "qla_target(%d): Async event %#x occurred "
@@ -6443,15 +6553,15 @@ int qlt_remove_target(struct qla_hw_data *ha, struct scsi_qla_host *vha)
 	return 0;
 }
 
-void qlt_remove_target_resources(struct qla_hw_data *ha)
+void qla_remove_hostmap(struct qla_hw_data *ha)
 {
 	struct scsi_qla_host *node;
 	u32 key = 0;
 
-	btree_for_each_safe32(&ha->tgt.host_map, key, node)
-		btree_remove32(&ha->tgt.host_map, key);
+	btree_for_each_safe32(&ha->host_map, key, node)
+		btree_remove32(&ha->host_map, key);
 
-	btree_destroy32(&ha->tgt.host_map);
+	btree_destroy32(&ha->host_map);
 }
 
 static void qlt_lport_dump(struct scsi_qla_host *vha, u64 wwpn,
@@ -7079,8 +7189,7 @@ qlt_modify_vp_config(struct scsi_qla_host *vha,
 void
 qlt_probe_one_stage1(struct scsi_qla_host *base_vha, struct qla_hw_data *ha)
 {
-	int rc;
-
+	mutex_init(&base_vha->vha_tgt.tgt_mutex);
 	if (!QLA_TGT_MODE_ENABLED())
 		return;
 
@@ -7093,7 +7202,6 @@ qlt_probe_one_stage1(struct scsi_qla_host *base_vha, struct qla_hw_data *ha)
 		ISP_ATIO_Q_OUT(base_vha) = &ha->iobase->isp24.atio_q_out;
 	}
 
-	mutex_init(&base_vha->vha_tgt.tgt_mutex);
 	mutex_init(&base_vha->vha_tgt.tgt_host_action_mutex);
 
 	INIT_LIST_HEAD(&base_vha->unknown_atio_list);
@@ -7102,11 +7210,6 @@ qlt_probe_one_stage1(struct scsi_qla_host *base_vha, struct qla_hw_data *ha)
 
 	qlt_clear_mode(base_vha);
 
-	rc = btree_init32(&ha->tgt.host_map);
-	if (rc)
-		ql_log(ql_log_info, base_vha, 0xd03d,
-		    "Unable to initialize ha->host_map btree\n");
-
 	qlt_update_vp_map(base_vha, SET_VP_IDX);
 }
 
@@ -7227,21 +7330,20 @@ qlt_update_vp_map(struct scsi_qla_host *vha, int cmd)
 	u32 key;
 	int rc;
 
-	if (!QLA_TGT_MODE_ENABLED())
-		return;
-
 	key = vha->d_id.b24;
 
 	switch (cmd) {
 	case SET_VP_IDX:
+		if (!QLA_TGT_MODE_ENABLED())
+			return;
 		vha->hw->tgt.tgt_vp_map[vha->vp_idx].vha = vha;
 		break;
 	case SET_AL_PA:
-		slot = btree_lookup32(&vha->hw->tgt.host_map, key);
+		slot = btree_lookup32(&vha->hw->host_map, key);
 		if (!slot) {
 			ql_dbg(ql_dbg_tgt_mgt, vha, 0xf018,
 			    "Save vha in host_map %p %06x\n", vha, key);
-			rc = btree_insert32(&vha->hw->tgt.host_map,
+			rc = btree_insert32(&vha->hw->host_map,
 				key, vha, GFP_ATOMIC);
 			if (rc)
 				ql_log(ql_log_info, vha, 0xd03e,
@@ -7251,17 +7353,19 @@ qlt_update_vp_map(struct scsi_qla_host *vha, int cmd)
 		}
 		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf019,
 		    "replace existing vha in host_map %p %06x\n", vha, key);
-		btree_update32(&vha->hw->tgt.host_map, key, vha);
+		btree_update32(&vha->hw->host_map, key, vha);
 		break;
 	case RESET_VP_IDX:
+		if (!QLA_TGT_MODE_ENABLED())
+			return;
 		vha->hw->tgt.tgt_vp_map[vha->vp_idx].vha = NULL;
 		break;
 	case RESET_AL_PA:
 		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf01a,
 		   "clear vha in host_map %p %06x\n", vha, key);
-		slot = btree_lookup32(&vha->hw->tgt.host_map, key);
+		slot = btree_lookup32(&vha->hw->host_map, key);
 		if (slot)
-			btree_remove32(&vha->hw->tgt.host_map, key);
+			btree_remove32(&vha->hw->host_map, key);
 		vha->d_id.b24 = 0;
 		break;
 	}
diff --git a/drivers/scsi/qla2xxx/qla_target.h b/drivers/scsi/qla2xxx/qla_target.h
index 01620f3eab39..d015c7c5a718 100644
--- a/drivers/scsi/qla2xxx/qla_target.h
+++ b/drivers/scsi/qla2xxx/qla_target.h
@@ -176,6 +176,7 @@ struct nack_to_isp {
 	uint8_t  reserved[2];
 	__le16	ox_id;
 } __packed;
+#define NOTIFY_ACK_FLAGS_FCSP		BIT_5
 #define NOTIFY_ACK_FLAGS_TERMINATE	BIT_3
 #define NOTIFY_ACK_SRR_FLAGS_ACCEPT	0
 #define NOTIFY_ACK_SRR_FLAGS_REJECT	1
@@ -238,6 +239,10 @@ struct ctio_to_2xxx {
 #define CTIO_PORT_LOGGED_OUT		0x29
 #define CTIO_PORT_CONF_CHANGED		0x2A
 #define CTIO_SRR_RECEIVED		0x45
+#define CTIO_FAST_AUTH_ERR		0x63
+#define CTIO_FAST_INCOMP_PAD_LEN	0x65
+#define CTIO_FAST_INVALID_REQ		0x66
+#define CTIO_FAST_SPI_ERR		0x67
 #endif
 
 #ifndef CTIO_RET_TYPE
@@ -408,7 +413,16 @@ struct ctio7_to_24xx {
 		struct {
 			__le16	reserved1;
 			__le16 flags;
-			__le32	residual;
+			union {
+				__le32	residual;
+				struct {
+					uint8_t rsvd1;
+					uint8_t edif_flags;
+#define EF_EN_EDIF	BIT_0
+#define EF_NEW_SA	BIT_1
+					uint16_t rsvd2;
+				};
+			};
 			__le16 ox_id;
 			__le16	scsi_status;
 			__le32	relative_offset;
@@ -446,7 +460,7 @@ struct ctio7_from_24xx {
 	uint8_t  vp_index;
 	uint8_t  reserved1[5];
 	__le32	exchange_address;
-	__le16	reserved2;
+	__le16	edif_sa_index;
 	__le16	flags;
 	__le32	residual;
 	__le16	ox_id;
@@ -875,6 +889,7 @@ struct qla_tgt_cmd {
 	unsigned int term_exchg:1;
 	unsigned int cmd_sent_to_fw:1;
 	unsigned int cmd_in_wq:1;
+	unsigned int edif:1;
 
 	/*
 	 * This variable may be set from outside the LIO and I/O completion
@@ -991,6 +1006,9 @@ struct qla_tgt_prm {
 #define QLA_TGT_XMIT_STATUS		2
 #define QLA_TGT_XMIT_ALL		(QLA_TGT_XMIT_STATUS|QLA_TGT_XMIT_DATA)
 
+#define PRLO_ACK_NEEDED(_sess) \
+	(_sess->logo_ack_needed && \
+	 ((struct imm_ntfy_from_isp *)_sess->iocb)->u.isp24.status_subcode == ELS_PRLO)
 
 extern struct qla_tgt_data qla_target;
 
-- 
2.19.0.rc0


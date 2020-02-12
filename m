Return-Path: <SRS0=6k2I=4A=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22B39C352A4
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Feb 2020 21:47:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DFF38206DB
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Feb 2020 21:47:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="uJNJ58Xg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729103AbgBLVrP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 Feb 2020 16:47:15 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:6562 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728603AbgBLVrP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 12 Feb 2020 16:47:15 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01CLexG1001688;
        Wed, 12 Feb 2020 13:45:14 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=oi6T0hz9qtHHs/bfQYTSrLvMZvaW08mZT+iyEuxMnGw=;
 b=uJNJ58Xg1UKaJkptUXwkNdx7s8Ac/ufBTYLO2FgNxz5GEnIOn3z97DUzkklElEvx6S9F
 42iX8FyjwbYoxZPz7DKWBVVu6gUqsgsVOKLF4iHLRqe3724wY+6IEj7H9Ixz61GLAeSL
 2lEKrNzJeId964IB4freXX1/vEWTvClMxUE5n7f9nZMcqCNJQTSEpWmjKGhi85l8gbVn
 Gc2XAtQWsofoEOd9IqfgbzXFM7+ITS3mnQ6EYS1qm35mcmLn2s3IMtQ7JM1UGa5p4PwL
 QGKmGlgQfe/I4UW/uAxtx/hqXTOQLOFHZQdpnScEDcJstF3JCwy4b9vmnnTzexwalIl/ Hw== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0b-0016f401.pphosted.com with ESMTP id 2y4j5jt4y4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 12 Feb 2020 13:45:14 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 12 Feb
 2020 13:45:12 -0800
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 12 Feb 2020 13:45:11 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id E17513F7044;
        Wed, 12 Feb 2020 13:45:11 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 01CLjB1g025624;
        Wed, 12 Feb 2020 13:45:11 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 01CLjBqG025623;
        Wed, 12 Feb 2020 13:45:11 -0800
From:   Himanshu Madhani <hmadhani@marvell.com>
To:     <James.Bottomley@HansenPartnership.com>,
        <martin.petersen@oracle.com>
CC:     <hmadhani@marvell.com>, <linux-scsi@vger.kernel.org>
Subject: [PATCH 12/25] qla2xxx: Cleanup ELS/PUREX iocb fields
Date:   Wed, 12 Feb 2020 13:44:23 -0800
Message-ID: <20200212214436.25532-13-hmadhani@marvell.com>
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

From: Joe Carnuccio <joe.carnuccio@cavium.com>

This patch does following to improve RDP processing

- Rename field port_id to d_id in ELS and PUREX iocb structs
  to match FW spec.
- Remove redundant comments from ELS and PUREX iocb structs.
- Refactor fields in ELS iocb struct for error subcode
  common access.
- Properly use error subcode fields in rdp processing routine.
- Add print logs for alloc failure in purex rdp processing routine.

Signed-off-by: Joe Carnuccio <joe.carnuccio@cavium.com>
Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
---
 drivers/scsi/qla2xxx/qla_fw.h   | 39 +++++++++++++++++++++++++--------------
 drivers/scsi/qla2xxx/qla_iocb.c | 12 ++++++------
 drivers/scsi/qla2xxx/qla_os.c   | 28 +++++++++++++++++-----------
 3 files changed, 48 insertions(+), 31 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_fw.h b/drivers/scsi/qla2xxx/qla_fw.h
index 649bdfd61bc5..f7a40dcda7ce 100644
--- a/drivers/scsi/qla2xxx/qla_fw.h
+++ b/drivers/scsi/qla2xxx/qla_fw.h
@@ -779,9 +779,8 @@ struct els_entry_24xx {
 
 	uint32_t handle;		/* System handle. */
 
-	uint16_t reserved_1;
-
-	uint16_t nport_handle;		/* N_PORT handle. */
+	uint16_t comp_status;		/* response only */
+	uint16_t nport_handle;
 
 	uint16_t tx_dsd_count;
 
@@ -796,7 +795,7 @@ struct els_entry_24xx {
 	uint8_t opcode;
 	uint8_t reserved_2;
 
-	uint8_t port_id[3];
+	uint8_t d_id[3];
 	uint8_t s_id[3];
 
 	uint16_t control_flags;		/* Control flags. */
@@ -808,13 +807,24 @@ struct els_entry_24xx {
 #define ECF_CLR_PASSTHRU_PEND	BIT_12
 #define ECF_INCL_FRAME_HDR	BIT_11
 
-	__le32	 rx_byte_count;
-	__le32	 tx_byte_count;
+	union {
+		struct {
+			__le32	 rx_byte_count;
+			__le32	 tx_byte_count;
 
-	__le64	 tx_address __packed;	/* Data segment 0 address. */
-	__le32	 tx_len;		/* Data segment 0 length. */
-	__le64	 rx_address __packed;	/* Data segment 1 address. */
-	__le32	 rx_len;		/* Data segment 1 length. */
+			__le64	 tx_address __packed;	/* DSD 0 address. */
+			__le32	 tx_len;		/* DSD 0 length. */
+
+			__le64	 rx_address __packed;	/* DSD 1 address. */
+			__le32	 rx_len;		/* DSD 1 length. */
+		};
+		struct {
+			uint32_t total_byte_count;
+			uint32_t error_subcode_1;
+			uint32_t error_subcode_2;
+			uint32_t error_subcode_3;
+		};
+	};
 };
 
 struct els_sts_entry_24xx {
@@ -840,15 +850,16 @@ struct els_sts_entry_24xx {
 	uint8_t opcode;
 	uint8_t reserved_3;
 
-	uint8_t port_id[3];
-	uint8_t reserved_4;
-
-	uint16_t reserved_5;
+	uint8_t d_id[3];
+	uint8_t s_id[3];
 
 	uint16_t control_flags;		/* Control flags. */
 	uint32_t total_byte_count;
 	uint32_t error_subcode_1;
 	uint32_t error_subcode_2;
+	uint32_t error_subcode_3;
+
+	uint32_t reserved_4[4];
 };
 /*
  * ISP queue - Mailbox Command entry structure definition.
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 47bf60a9490a..5b73d09da739 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -2684,9 +2684,9 @@ qla24xx_els_logo_iocb(srb_t *sp, struct els_entry_24xx *els_iocb)
 	els_iocb->rx_dsd_count = 0;
 	els_iocb->opcode = elsio->u.els_logo.els_cmd;
 
-	els_iocb->port_id[0] = sp->fcport->d_id.b.al_pa;
-	els_iocb->port_id[1] = sp->fcport->d_id.b.area;
-	els_iocb->port_id[2] = sp->fcport->d_id.b.domain;
+	els_iocb->d_id[0] = sp->fcport->d_id.b.al_pa;
+	els_iocb->d_id[1] = sp->fcport->d_id.b.area;
+	els_iocb->d_id[2] = sp->fcport->d_id.b.domain;
 	/* For SID the byte order is different than DID */
 	els_iocb->s_id[1] = vha->d_id.b.al_pa;
 	els_iocb->s_id[2] = vha->d_id.b.area;
@@ -3030,9 +3030,9 @@ qla24xx_els_iocb(srb_t *sp, struct els_entry_24xx *els_iocb)
 	    sp->type == SRB_ELS_CMD_RPT ?
 	    bsg_request->rqst_data.r_els.els_code :
 	    bsg_request->rqst_data.h_els.command_code;
-        els_iocb->port_id[0] = sp->fcport->d_id.b.al_pa;
-        els_iocb->port_id[1] = sp->fcport->d_id.b.area;
-        els_iocb->port_id[2] = sp->fcport->d_id.b.domain;
+	els_iocb->d_id[0] = sp->fcport->d_id.b.al_pa;
+	els_iocb->d_id[1] = sp->fcport->d_id.b.area;
+	els_iocb->d_id[2] = sp->fcport->d_id.b.domain;
         els_iocb->control_flags = 0;
         els_iocb->rx_byte_count =
             cpu_to_le32(bsg_job->reply_payload.payload_len);
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index dbbe20c7fbaf..295c7fec0918 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -5886,13 +5886,19 @@ static int qla24xx_process_purex_iocb(struct scsi_qla_host *vha, void *pkt)
 
 	rsp_els = dma_alloc_coherent(&ha->pdev->dev, sizeof(*rsp_els),
 	    &rsp_els_dma, GFP_KERNEL);
-	if (!rsp_els)
+	if (!rsp_els) {
+		ql_log(ql_log_warn, vha, 0x0183,
+		    "Failed allocate dma buffer ELS RSP.\n");
 		goto dealloc;
+	}
 
 	rsp_payload = dma_alloc_coherent(&ha->pdev->dev, sizeof(*rsp_payload),
 	    &rsp_payload_dma, GFP_KERNEL);
-	if (!rsp_payload)
+	if (!rsp_payload) {
+		ql_log(ql_log_warn, vha, 0x0184,
+		    "Failed allocate dma buffer ELS RSP payload.\n");
 		goto dealloc;
+	}
 
 	sfp = dma_alloc_coherent(&ha->pdev->dev, SFP_RTDI_LEN,
 	    &sfp_dma, GFP_KERNEL);
@@ -5918,9 +5924,9 @@ static int qla24xx_process_purex_iocb(struct scsi_qla_host *vha, void *pkt)
 	rsp_els->rx_dsd_count = 0;
 	rsp_els->opcode = purex->els_frame_payload[0];
 
-	rsp_els->port_id[0] = purex->s_id[0];
-	rsp_els->port_id[1] = purex->s_id[1];
-	rsp_els->port_id[2] = purex->s_id[2];
+	rsp_els->d_id[0] = purex->s_id[0];
+	rsp_els->d_id[1] = purex->s_id[1];
+	rsp_els->d_id[2] = purex->s_id[2];
 
 	rsp_els->control_flags = EPD_ELS_ACC;
 	rsp_els->rx_byte_count = 0;
@@ -6263,14 +6269,14 @@ static int qla24xx_process_purex_iocb(struct scsi_qla_host *vha, void *pkt)
 
 	rval = qla2x00_issue_iocb(vha, rsp_els, rsp_els_dma, 0);
 
-	if (rval != QLA_SUCCESS) {
+	if (rval) {
 		ql_log(ql_log_warn, vha, 0x0188,
-		    "%s: failed to issue IOCB (%x).\n", __func__, rval);
-	} else if (rsp_els->entry_status != 0) {
+		    "%s: iocb failed to execute -> %x\n", __func__, rval);
+	} else if (rsp_els->comp_status) {
 		ql_log(ql_log_warn, vha, 0x0189,
-		    "%s: failed to complete IOCB -- error status (%x).\n",
-		    __func__, rsp_els->entry_status);
-		rval = QLA_FUNCTION_FAILED;
+		    "%s: iocb failed to complete -> completion=%#x subcode=(%#x,%#x)\n",
+		    __func__, rsp_els->comp_status,
+		    rsp_els->error_subcode_1, rsp_els->error_subcode_2);
 	} else {
 		ql_dbg(ql_dbg_init, vha, 0x018a, "%s: done.\n", __func__);
 	}
-- 
2.12.0


Return-Path: <SRS0=mj/2=4O=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D107FC4BA24
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Feb 2020 22:43:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9185D20658
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Feb 2020 22:43:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="D7YhoFuy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727837AbgBZWnC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 26 Feb 2020 17:43:02 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:6604 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727761AbgBZWnC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 26 Feb 2020 17:43:02 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01QMeN61006111;
        Wed, 26 Feb 2020 14:41:01 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=ZwQLFnmmlAwbL+gKjt7ggZhJrfy6nBc3U1yyDfn4Srw=;
 b=D7YhoFuy1McbMtpxM52yIElhwIGOayuSi4GyEBLg29oM4/o3zj8D4ZFdEbH5NtRUwKWh
 Dd74JccS2Qlrmn5++oMVUwdmyGH58Geaabm0Yi0EcdBFWzB9iEnRW+rDZwcKgyASMvRy
 6N3xNvHEdziKsMjwEsMA5PfbnuOg9T7pHTsx/hgMuUgWFEj8Z6YCfuXNCotWYbU/ikMV
 yDe4d6qHsgOT8cbMjB2X1rCItkKhB/824IwP8ZTvePqeUq4IHmgKqCvmbag4UWCBodKt
 eQZX3jQ3DP47tcxEIdP+Rvdu+JD9K7rb4tKUuBmlhlBXAmWpSJMdaoSUTDrAyu3SmQ9s Uw== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 2ydchtd6n4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 26 Feb 2020 14:41:01 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 26 Feb
 2020 14:40:58 -0800
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 26 Feb 2020 14:40:58 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id BB82E3F703F;
        Wed, 26 Feb 2020 14:40:58 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 01QMewU2024609;
        Wed, 26 Feb 2020 14:40:58 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 01QMewUi024608;
        Wed, 26 Feb 2020 14:40:58 -0800
From:   Himanshu Madhani <hmadhani@marvell.com>
To:     <James.Bottomley@HansenPartnership.com>,
        <martin.petersen@oracle.com>
CC:     <hmadhani@marvell.com>, <linux-scsi@vger.kernel.org>
Subject: [PATCH 12/18] qla2xxx: Fix RDP respond data format
Date:   Wed, 26 Feb 2020 14:40:16 -0800
Message-ID: <20200226224022.24518-13-hmadhani@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20200226224022.24518-1-hmadhani@marvell.com>
References: <20200226224022.24518-1-hmadhani@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-26_09:2020-02-26,2020-02-26 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

RPD information failed to dispay by switch cli command.
This is caused by driver failure to properly format RDP
respond data with data descriptor to allow switch to parse it
corretly.

Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
---
 drivers/scsi/qla2xxx/qla_os.c | 102 +++++++++++++++++++-----------------------
 1 file changed, 47 insertions(+), 55 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 5772f788661b..ede4529c4718 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -5972,7 +5972,6 @@ void qla24xx_process_purex_rdp(struct scsi_qla_host *vha, void *pkt)
 	    &bbc_dma, GFP_KERNEL);
 
 	/* Prepare Response IOCB */
-	memset(rsp_els, 0, sizeof(*rsp_els));
 	rsp_els->entry_type = ELS_IOCB_TYPE;
 	rsp_els->entry_count = 1;
 	rsp_els->sys_define = 0;
@@ -6019,6 +6018,11 @@ void qla24xx_process_purex_rdp(struct scsi_qla_host *vha, void *pkt)
 	rsp_payload->ls_req_info_desc2.req_payload_word_0 =
 	    cpu_to_be32p((uint32_t *)purex->els_frame_payload);
 
+
+	rsp_payload->sfp_diag_desc.desc_tag = cpu_to_be32(0x10000);
+	rsp_payload->sfp_diag_desc.desc_len =
+		cpu_to_be32(RDP_DESC_LEN(rsp_payload->sfp_diag_desc));
+
 	if (sfp) {
 		/* SFP Flags */
 		memset(sfp, 0, SFP_RTDI_LEN);
@@ -6042,23 +6046,18 @@ void qla24xx_process_purex_rdp(struct scsi_qla_host *vha, void *pkt)
 				sfp_flags |= BIT_6; /* sfp+ */
 		}
 
+		rsp_payload->sfp_diag_desc.sfp_flags = cpu_to_be16(sfp_flags);
+
 		/* SFP Diagnostics */
 		memset(sfp, 0, SFP_RTDI_LEN);
 		rval = qla2x00_read_sfp(vha, sfp_dma, sfp, 0xa2, 0x60, 10, 0);
-		if (!rval && sfp_flags) {
+		if (!rval) {
 			uint16_t *trx = (void *)sfp; /* already be16 */
-
-			rsp_payload->sfp_diag_desc.desc_tag =
-			    cpu_to_be32(0x10000);
-			rsp_payload->sfp_diag_desc.desc_len =
-			    cpu_to_be32(RDP_DESC_LEN(rsp_payload->sfp_diag_desc));
 			rsp_payload->sfp_diag_desc.temperature = trx[0];
 			rsp_payload->sfp_diag_desc.vcc = trx[1];
 			rsp_payload->sfp_diag_desc.tx_bias = trx[2];
 			rsp_payload->sfp_diag_desc.tx_power = trx[3];
 			rsp_payload->sfp_diag_desc.rx_power = trx[4];
-			rsp_payload->sfp_diag_desc.sfp_flags =
-			    cpu_to_be16(sfp_flags);
 		}
 	}
 
@@ -6071,14 +6070,14 @@ void qla24xx_process_purex_rdp(struct scsi_qla_host *vha, void *pkt)
 	rsp_payload->port_speed_desc.operating_speed = cpu_to_be16(
 	    qla25xx_rdp_port_speed_currently(ha));
 
+	/* Link Error Status Descriptor */
+	rsp_payload->ls_err_desc.desc_tag = cpu_to_be32(0x10002);
+	rsp_payload->ls_err_desc.desc_len =
+		cpu_to_be32(RDP_DESC_LEN(rsp_payload->ls_err_desc));
+
 	if (stat) {
 		rval = qla24xx_get_isp_stats(vha, stat, stat_dma, 0);
 		if (!rval) {
-			/* Link Error Status Descriptor */
-			rsp_payload->ls_err_desc.desc_tag =
-			    cpu_to_be32(0x10002);
-			rsp_payload->ls_err_desc.desc_len =
-			    cpu_to_be32(RDP_DESC_LEN(rsp_payload->ls_err_desc));
 			rsp_payload->ls_err_desc.link_fail_cnt =
 			    cpu_to_be32(stat->link_fail_cnt);
 			rsp_payload->ls_err_desc.loss_sync_cnt =
@@ -6117,28 +6116,47 @@ void qla24xx_process_purex_rdp(struct scsi_qla_host *vha, void *pkt)
 	    vha->fabric_port_name,
 	    sizeof(rsp_payload->port_name_direct_desc.WWPN));
 
+	/* Bufer Credit Descriptor */
+	rsp_payload->buffer_credit_desc.desc_tag = cpu_to_be32(0x10006);
+	rsp_payload->buffer_credit_desc.desc_len =
+		cpu_to_be32(RDP_DESC_LEN(rsp_payload->buffer_credit_desc));
+	rsp_payload->buffer_credit_desc.fcport_b2b = 0;
+	rsp_payload->buffer_credit_desc.attached_fcport_b2b = cpu_to_be32(0);
+	rsp_payload->buffer_credit_desc.fcport_rtt = cpu_to_be32(0);
+
 	if (bbc) {
 		memset(bbc, 0, sizeof(*bbc));
 		rval = qla24xx_get_buffer_credits(vha, bbc, bbc_dma);
 		if (!rval) {
-			/* Bufer Credit Descriptor */
-			rsp_payload->buffer_credit_desc.desc_tag =
-			    cpu_to_be32(0x10006);
-			rsp_payload->buffer_credit_desc.desc_len =
-			    cpu_to_be32(RDP_DESC_LEN(
-				rsp_payload->buffer_credit_desc));
 			rsp_payload->buffer_credit_desc.fcport_b2b =
 			    cpu_to_be32(LSW(bbc->parameter[0]));
-			rsp_payload->buffer_credit_desc.attached_fcport_b2b =
-			    cpu_to_be32(0);
-			rsp_payload->buffer_credit_desc.fcport_rtt =
-			    cpu_to_be32(0);
 		}
 	}
 
 	if (rsp_payload_length < sizeof(*rsp_payload))
 		goto send;
 
+	/* Optical Element Descriptor, Temperature */
+	rsp_payload->optical_elmt_desc[0].desc_tag = cpu_to_be32(0x10007);
+	rsp_payload->optical_elmt_desc[0].desc_len =
+		cpu_to_be32(RDP_DESC_LEN(*rsp_payload->optical_elmt_desc));
+	/* Optical Element Descriptor, Voltage */
+	rsp_payload->optical_elmt_desc[1].desc_tag = cpu_to_be32(0x10007);
+	rsp_payload->optical_elmt_desc[1].desc_len =
+		cpu_to_be32(RDP_DESC_LEN(*rsp_payload->optical_elmt_desc));
+	/* Optical Element Descriptor, Tx Bias Current */
+	rsp_payload->optical_elmt_desc[2].desc_tag = cpu_to_be32(0x10007);
+	rsp_payload->optical_elmt_desc[2].desc_len =
+		cpu_to_be32(RDP_DESC_LEN(*rsp_payload->optical_elmt_desc));
+	/* Optical Element Descriptor, Tx Power */
+	rsp_payload->optical_elmt_desc[3].desc_tag = cpu_to_be32(0x10007);
+	rsp_payload->optical_elmt_desc[3].desc_len =
+		cpu_to_be32(RDP_DESC_LEN(*rsp_payload->optical_elmt_desc));
+	/* Optical Element Descriptor, Rx Power */
+	rsp_payload->optical_elmt_desc[4].desc_tag = cpu_to_be32(0x10007);
+	rsp_payload->optical_elmt_desc[4].desc_len =
+		cpu_to_be32(RDP_DESC_LEN(*rsp_payload->optical_elmt_desc));
+
 	if (sfp) {
 		memset(sfp, 0, SFP_RTDI_LEN);
 		rval = qla2x00_read_sfp(vha, sfp_dma, sfp, 0xa2, 0, 64, 0);
@@ -6146,11 +6164,6 @@ void qla24xx_process_purex_rdp(struct scsi_qla_host *vha, void *pkt)
 			uint16_t *trx = (void *)sfp; /* already be16 */
 
 			/* Optical Element Descriptor, Temperature */
-			rsp_payload->optical_elmt_desc[0].desc_tag =
-			    cpu_to_be32(0x10007);
-			rsp_payload->optical_elmt_desc[0].desc_len =
-			    cpu_to_be32(RDP_DESC_LEN(
-				*rsp_payload->optical_elmt_desc));
 			rsp_payload->optical_elmt_desc[0].high_alarm = trx[0];
 			rsp_payload->optical_elmt_desc[0].low_alarm = trx[1];
 			rsp_payload->optical_elmt_desc[0].high_warn = trx[2];
@@ -6159,11 +6172,6 @@ void qla24xx_process_purex_rdp(struct scsi_qla_host *vha, void *pkt)
 			    cpu_to_be32(1 << 28);
 
 			/* Optical Element Descriptor, Voltage */
-			rsp_payload->optical_elmt_desc[1].desc_tag =
-			    cpu_to_be32(0x10007);
-			rsp_payload->optical_elmt_desc[1].desc_len =
-			    cpu_to_be32(RDP_DESC_LEN(
-				*rsp_payload->optical_elmt_desc));
 			rsp_payload->optical_elmt_desc[1].high_alarm = trx[4];
 			rsp_payload->optical_elmt_desc[1].low_alarm = trx[5];
 			rsp_payload->optical_elmt_desc[1].high_warn = trx[6];
@@ -6172,11 +6180,6 @@ void qla24xx_process_purex_rdp(struct scsi_qla_host *vha, void *pkt)
 			    cpu_to_be32(2 << 28);
 
 			/* Optical Element Descriptor, Tx Bias Current */
-			rsp_payload->optical_elmt_desc[2].desc_tag =
-			    cpu_to_be32(0x10007);
-			rsp_payload->optical_elmt_desc[2].desc_len =
-			    cpu_to_be32(RDP_DESC_LEN(
-				*rsp_payload->optical_elmt_desc));
 			rsp_payload->optical_elmt_desc[2].high_alarm = trx[8];
 			rsp_payload->optical_elmt_desc[2].low_alarm = trx[9];
 			rsp_payload->optical_elmt_desc[2].high_warn = trx[10];
@@ -6185,11 +6188,6 @@ void qla24xx_process_purex_rdp(struct scsi_qla_host *vha, void *pkt)
 			    cpu_to_be32(3 << 28);
 
 			/* Optical Element Descriptor, Tx Power */
-			rsp_payload->optical_elmt_desc[3].desc_tag =
-			    cpu_to_be32(0x10007);
-			rsp_payload->optical_elmt_desc[3].desc_len =
-			    cpu_to_be32(RDP_DESC_LEN(
-				*rsp_payload->optical_elmt_desc));
 			rsp_payload->optical_elmt_desc[3].high_alarm = trx[12];
 			rsp_payload->optical_elmt_desc[3].low_alarm = trx[13];
 			rsp_payload->optical_elmt_desc[3].high_warn = trx[14];
@@ -6198,11 +6196,6 @@ void qla24xx_process_purex_rdp(struct scsi_qla_host *vha, void *pkt)
 			    cpu_to_be32(4 << 28);
 
 			/* Optical Element Descriptor, Rx Power */
-			rsp_payload->optical_elmt_desc[4].desc_tag =
-			    cpu_to_be32(0x10007);
-			rsp_payload->optical_elmt_desc[4].desc_len =
-			    cpu_to_be32(RDP_DESC_LEN(
-				*rsp_payload->optical_elmt_desc));
 			rsp_payload->optical_elmt_desc[4].high_alarm = trx[16];
 			rsp_payload->optical_elmt_desc[4].low_alarm = trx[17];
 			rsp_payload->optical_elmt_desc[4].high_warn = trx[18];
@@ -6256,16 +6249,15 @@ void qla24xx_process_purex_rdp(struct scsi_qla_host *vha, void *pkt)
 		}
 	}
 
+	/* Optical Product Data Descriptor */
+	rsp_payload->optical_prod_desc.desc_tag = cpu_to_be32(0x10008);
+	rsp_payload->optical_prod_desc.desc_len =
+		cpu_to_be32(RDP_DESC_LEN(rsp_payload->optical_prod_desc));
+
 	if (sfp) {
 		memset(sfp, 0, SFP_RTDI_LEN);
 		rval = qla2x00_read_sfp(vha, sfp_dma, sfp, 0xa0, 20, 64, 0);
 		if (!rval) {
-			/* Optical Product Data Descriptor */
-			rsp_payload->optical_prod_desc.desc_tag =
-			    cpu_to_be32(0x10008);
-			rsp_payload->optical_prod_desc.desc_len =
-			    cpu_to_be32(RDP_DESC_LEN(
-				rsp_payload->optical_prod_desc));
 			memcpy(rsp_payload->optical_prod_desc.vendor_name,
 			    sfp + 0,
 			    sizeof(rsp_payload->optical_prod_desc.vendor_name));
-- 
2.12.0


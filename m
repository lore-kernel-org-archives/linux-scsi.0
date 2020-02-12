Return-Path: <SRS0=6k2I=4A=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDC31C352A4
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Feb 2020 21:45:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9233524671
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Feb 2020 21:45:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="L2ZH4Lnl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729103AbgBLVpZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 Feb 2020 16:45:25 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:50144 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728447AbgBLVpZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 12 Feb 2020 16:45:25 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01CLe3Cp006707;
        Wed, 12 Feb 2020 13:45:20 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=XxgY0x3lJle+Fxs8h1cMlwugTawm0r8oTs9Sj1nnlEg=;
 b=L2ZH4LnlXhwr9FONScuHfZNb05N+bQP0bYwgJpOxfmJu2jL2R74y0/lUyRxZqZg/C49q
 ilY23xY8NKWBWhcBcazp4NHokrtJgG2qE8lipeoL+Ohb7+F+PSF30mTAkHSkaXD6mpii
 qDfTKhJCLfWUE/3nnTmmcgNZOpde21KN9Lb4Vl84Rs4o2+v1HAhX+Mf0MuCnh4FBYkhw
 vdEi7lqKcbuwOAAUOidlUk8swGRqRq2wlMo6j7s8ocvRWO6a09d76nJg3zi4j4XJPVrA
 qUkbY2cwpkNaYvHRW0l1cGYYjr0hKtcz3+kFHwTKnt1DFHNO/jTS18RresbNOcd5dBVb Mg== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 2y4be2bpm9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 12 Feb 2020 13:45:20 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 12 Feb
 2020 13:45:19 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 12 Feb
 2020 13:45:18 -0800
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 12 Feb 2020 13:45:18 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 889E43F7041;
        Wed, 12 Feb 2020 13:45:18 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 01CLjIgI025632;
        Wed, 12 Feb 2020 13:45:18 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 01CLjI3e025631;
        Wed, 12 Feb 2020 13:45:18 -0800
From:   Himanshu Madhani <hmadhani@marvell.com>
To:     <James.Bottomley@HansenPartnership.com>,
        <martin.petersen@oracle.com>
CC:     <hmadhani@marvell.com>, <linux-scsi@vger.kernel.org>
Subject: [PATCH 14/25] qla2xxx: Handle cases for limiting RDP response payload length
Date:   Wed, 12 Feb 2020 13:44:25 -0800
Message-ID: <20200212214436.25532-15-hmadhani@marvell.com>
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

This patch reduces RDP response payload length, if
requesting port is a domain Controller (sid 0xfffc01)
and fw is earlier than 8.09.00 and fw is not 8.05.65
then limit the RDP response payload length to maximum
of 256 bytes by terminating the response just before the
optical element descriptor.

Signed-off-by: Joe Carnuccio <joe.carnuccio@cavium.com>
Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
---
 drivers/scsi/qla2xxx/qla_os.c | 42 ++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 40 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 1aad4b9ce4b6..d06fa318f378 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -5767,6 +5767,32 @@ qla83xx_idc_lock(scsi_qla_host_t *base_vha, uint16_t requester_id)
 	return;
 }
 
+static bool
+qla25xx_rdp_rsp_reduce_size(struct scsi_qla_host *vha,
+    struct purex_entry_24xx *purex)
+{
+	char fwstr[16];
+	u32 sid = purex->s_id[2] << 16 | purex->s_id[1] << 8 | purex->s_id[0];
+
+	/* Domain Controller is always logged-out. */
+	/* if RDP request is not from Domain Controller: */
+	if (sid != 0xfffc01)
+		return false;
+
+	ql_dbg(ql_dbg_init, vha, 0x0181, "%s: s_id=%#x\n", __func__, sid);
+
+	vha->hw->isp_ops->fw_version_str(vha, fwstr, sizeof(fwstr));
+	fwstr[strcspn(fwstr, " ")] = 0;
+	/* if FW version allows RDP response length upto 2048 bytes: */
+	if (strcmp(fwstr, "8.09.00") > 0 || strcmp(fwstr, "8.05.65") == 0)
+		return false;
+
+	ql_dbg(ql_dbg_init, vha, 0x0181, "%s: fw=%s\n", __func__, fwstr);
+
+	/* RDP response length is to be reduced to maximum 256 bytes */
+	return true;
+}
+
 static uint
 qla25xx_rdp_port_speed_capability(struct qla_hw_data *ha)
 {
@@ -5885,6 +5911,7 @@ void qla24xx_process_purex_rdp(struct scsi_qla_host *vha, void *pkt)
 	struct buffer_credit_24xx *bbc = NULL;
 	uint8_t *sfp = NULL;
 	uint16_t sfp_flags = 0;
+	uint rsp_payload_length = sizeof(*rsp_payload);
 	int rval;
 
 	ql_dbg(ql_dbg_init + ql_dbg_verbose, vha, 0x0180,
@@ -5895,6 +5922,14 @@ void qla24xx_process_purex_rdp(struct scsi_qla_host *vha, void *pkt)
 	ql_dump_buffer(ql_dbg_init + ql_dbg_verbose, vha, 0x0182,
 	    (void *)purex, sizeof(*purex));
 
+	if (qla25xx_rdp_rsp_reduce_size(vha, purex)) {
+		rsp_payload_length =
+		    offsetof(typeof(*rsp_payload), optical_elmt_desc);
+		ql_dbg(ql_dbg_init, vha, 0x0181,
+		    "Reducing RSP payload length to %u bytes...\n",
+		    rsp_payload_length);
+	}
+
 	rsp_els = dma_alloc_coherent(&ha->pdev->dev, sizeof(*rsp_els),
 	    &rsp_els_dma, GFP_KERNEL);
 	if (!rsp_els) {
@@ -5941,7 +5976,7 @@ void qla24xx_process_purex_rdp(struct scsi_qla_host *vha, void *pkt)
 
 	rsp_els->control_flags = EPD_ELS_ACC;
 	rsp_els->rx_byte_count = 0;
-	rsp_els->tx_byte_count = cpu_to_le32(sizeof(*rsp_payload));
+	rsp_els->tx_byte_count = cpu_to_le32(rsp_payload_length);
 
 	put_unaligned_le64(rsp_payload_dma, &rsp_els->tx_address);
 	rsp_els->tx_len = rsp_els->tx_byte_count;
@@ -6116,6 +6151,9 @@ void qla24xx_process_purex_rdp(struct scsi_qla_host *vha, void *pkt)
 		}
 	}
 
+	if (rsp_payload_length < sizeof(*rsp_payload))
+		goto send;
+
 	if (sfp) {
 		memset(sfp, 0, SFP_RTDI_LEN);
 		rval = qla2x00_read_sfp(vha, sfp_dma, sfp, 0xa2, 0, 64, 0);
@@ -6276,7 +6314,7 @@ void qla24xx_process_purex_rdp(struct scsi_qla_host *vha, void *pkt)
 	ql_dbg(ql_dbg_init + ql_dbg_verbose, vha, 0x0186,
 	    "-------- ELS RSP PAYLOAD -------\n");
 	ql_dump_buffer(ql_dbg_init + ql_dbg_verbose, vha, 0x0187,
-	    (void *)rsp_payload, rsp_els->tx_byte_count);
+	    (void *)rsp_payload, rsp_payload_length);
 
 	rval = qla2x00_issue_iocb(vha, rsp_els, rsp_els_dma, 0);
 
-- 
2.12.0


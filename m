Return-Path: <SRS0=6k2I=4A=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20AA9C3B187
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Feb 2020 21:47:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E6A60206DB
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Feb 2020 21:47:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="xce6IODH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729127AbgBLVrZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 Feb 2020 16:47:25 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:18890 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728185AbgBLVrZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 12 Feb 2020 16:47:25 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01CLexG5001688;
        Wed, 12 Feb 2020 13:45:23 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=JabxKFR6LRJalAn5ZjHRRQqBYxkxcwtwTzn6ns85tZg=;
 b=xce6IODHosBOAteFTsZ+/shVgFc234Oa82w0m38Bdf7wg8/cgUyW57kdf0FCrlzLS5oQ
 bO8lCyqzVZPkGcR/jFecQQ7FIanGiCbLmN27kkrKJScPjga+rQDYsJBgnouPazT2iU61
 w6FoiIAkDOZBWaM0+30f6B6BIMvd2AVMJm3tyJhjmD49VteacjPdhGAp0NmvCptarIkL
 caRhXMeI8Y2nRmX008wK6Vunv1gP1uD+/SwpQyxByHFHw5D15KuZeg9znXqlY1sl6hwi
 hPGCOOacb/v/wXHVseuG+DXTSfZXbtp2CbVtnkar6pQZvYuvNEMO/9nM2LFPRjey6YH1 mg== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0b-0016f401.pphosted.com with ESMTP id 2y4j5jt505-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 12 Feb 2020 13:45:23 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 12 Feb
 2020 13:45:21 -0800
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 12 Feb 2020 13:45:21 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id B80BF3F7041;
        Wed, 12 Feb 2020 13:45:21 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 01CLjL8X025636;
        Wed, 12 Feb 2020 13:45:21 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 01CLjLne025635;
        Wed, 12 Feb 2020 13:45:21 -0800
From:   Himanshu Madhani <hmadhani@marvell.com>
To:     <James.Bottomley@HansenPartnership.com>,
        <martin.petersen@oracle.com>
CC:     <hmadhani@marvell.com>, <linux-scsi@vger.kernel.org>
Subject: [PATCH 15/25] qla2xxx: Fix RDP response size
Date:   Wed, 12 Feb 2020 13:44:26 -0800
Message-ID: <20200212214436.25532-16-hmadhani@marvell.com>
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

This patch fixes RDP length in case when driver
needs to reduce length of RDP response

Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
---
 drivers/scsi/qla2xxx/qla_os.c | 53 ++++++++++++++++---------------------------
 1 file changed, 19 insertions(+), 34 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index d06fa318f378..b24813051766 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -5773,6 +5773,7 @@ qla25xx_rdp_rsp_reduce_size(struct scsi_qla_host *vha,
 {
 	char fwstr[16];
 	u32 sid = purex->s_id[2] << 16 | purex->s_id[1] << 8 | purex->s_id[0];
+	struct port_database_24xx *pdb;
 
 	/* Domain Controller is always logged-out. */
 	/* if RDP request is not from Domain Controller: */
@@ -5781,6 +5782,24 @@ qla25xx_rdp_rsp_reduce_size(struct scsi_qla_host *vha,
 
 	ql_dbg(ql_dbg_init, vha, 0x0181, "%s: s_id=%#x\n", __func__, sid);
 
+	pdb = kzalloc(sizeof(*pdb), GFP_KERNEL);
+	if (!pdb) {
+		ql_dbg(ql_dbg_init, vha, 0x0181,
+		    "%s: Failed allocate pdb\n", __func__);
+	} else if (qla24xx_get_port_database(vha, purex->nport_handle, pdb)) {
+		ql_dbg(ql_dbg_init, vha, 0x0181,
+		    "%s: Failed get pdb sid=%x\n", __func__, sid);
+	} else if (pdb->current_login_state != PDS_PLOGI_COMPLETE &&
+	    pdb->current_login_state != PDS_PRLI_COMPLETE) {
+		ql_dbg(ql_dbg_init, vha, 0x0181,
+		    "%s: Port not logged in sid=%#x\n", __func__, sid);
+	} else {
+		/* RDP request is from logged in port */
+		kfree(pdb);
+		return false;
+	}
+	kfree(pdb);
+
 	vha->hw->isp_ops->fw_version_str(vha, fwstr, sizeof(fwstr));
 	fwstr[strcspn(fwstr, " ")] = 0;
 	/* if FW version allows RDP response length upto 2048 bytes: */
@@ -5899,7 +5918,6 @@ void qla24xx_process_purex_rdp(struct scsi_qla_host *vha, void *pkt)
 {
 	struct qla_hw_data *ha = vha->hw;
 	struct purex_entry_24xx *purex = pkt;
-	struct port_database_24xx *pdb = NULL;
 	dma_addr_t rsp_els_dma;
 	dma_addr_t rsp_payload_dma;
 	dma_addr_t stat_dma;
@@ -5984,34 +6002,6 @@ void qla24xx_process_purex_rdp(struct scsi_qla_host *vha, void *pkt)
 	rsp_els->rx_address = 0;
 	rsp_els->rx_len = 0;
 
-	if (sizeof(*rsp_payload) <= 0x100)
-		goto accept;
-
-	pdb = kzalloc(sizeof(*pdb), GFP_KERNEL);
-	if (!pdb)
-		goto reduce;
-
-	rval = qla24xx_get_port_database(vha, purex->nport_handle, pdb);
-	if (rval)
-		goto reduce;
-
-	if (pdb->port_id[0] != purex->s_id[2] ||
-	    pdb->port_id[1] != purex->s_id[1] ||
-	    pdb->port_id[2] != purex->s_id[0])
-		goto reduce;
-
-	if (pdb->current_login_state == PDS_PLOGI_COMPLETE ||
-	    pdb->current_login_state == PDS_PRLI_COMPLETE)
-		goto accept;
-
-reduce:
-	ql_dbg(ql_dbg_init, vha, 0x016e, "Requesting port is not logged in.\n");
-	rsp_els->tx_byte_count = rsp_els->tx_len =
-	    offsetof(struct rdp_rsp_payload, buffer_credit_desc);
-	ql_dbg(ql_dbg_init, vha, 0x016f, "Reduced response payload size %u.\n",
-	    rsp_els->tx_byte_count);
-
-accept:
 	/* Prepare Response Payload */
 	rsp_payload->hdr.cmd = cpu_to_be32(0x2 << 24); /* LS_ACC */
 	rsp_payload->hdr.len = cpu_to_be32(
@@ -6129,9 +6119,6 @@ void qla24xx_process_purex_rdp(struct scsi_qla_host *vha, void *pkt)
 	    vha->fabric_port_name,
 	    sizeof(rsp_payload->port_name_direct_desc.WWPN));
 
-	if (rsp_els->tx_byte_count < sizeof(*rsp_payload))
-		goto send;
-
 	if (bbc) {
 		memset(bbc, 0, sizeof(*bbc));
 		rval = qla24xx_get_buffer_credits(vha, bbc, bbc_dma);
@@ -6331,8 +6318,6 @@ void qla24xx_process_purex_rdp(struct scsi_qla_host *vha, void *pkt)
 	}
 
 dealloc:
-	kfree(pdb);
-
 	if (bbc)
 		dma_free_coherent(&ha->pdev->dev, sizeof(*bbc),
 		    bbc, bbc_dma);
-- 
2.12.0


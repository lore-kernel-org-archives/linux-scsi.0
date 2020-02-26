Return-Path: <SRS0=mj/2=4O=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49157C4BA24
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Feb 2020 22:41:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1AD4620658
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Feb 2020 22:41:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="unDVa8mM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727877AbgBZWlQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 26 Feb 2020 17:41:16 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:2522 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727802AbgBZWlQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 26 Feb 2020 17:41:16 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01QMVSLh003745;
        Wed, 26 Feb 2020 14:41:15 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=XlGs0N2HTsNUaQf5WAoeEQeJBnsTcZEEd/IQAw0U50M=;
 b=unDVa8mMBnLN07lpB0p2gYvSor7ZNpz4QMv8wCA7bj2L1WBm5iu1BNvJbcana2QNFw/0
 wfge6FiQBZ38NDEyRhGtqZQYkxfIbuxBbhdMQjj7OGJB5KJXsqXJsnOOb0qM106DYB5o
 ERBe4f3oi0V4INh4rTYen8pMfC1RA0s3vvVNZxgO8a7HvrVrvkCypIOVXNKYmPc1pPwF
 GDatEsfFsIGoEMKZG0kWQpo+ylhNDtGiJE7Wc2MWP4wxtgBXDj3JyjdB37HCqSji9L8U
 pMeYZH3As9nApphO75YKqiWsclyemIeBvy71GaMW0m8X5QMnXPmJOlSL4jm9LiOFWgQD TQ== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 2ydcm15b9t-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 26 Feb 2020 14:41:15 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 26 Feb
 2020 14:41:12 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 26 Feb
 2020 14:41:11 -0800
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 26 Feb 2020 14:41:11 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 8603E3F703F;
        Wed, 26 Feb 2020 14:41:11 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 01QMfBGW024625;
        Wed, 26 Feb 2020 14:41:11 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 01QMfBB8024624;
        Wed, 26 Feb 2020 14:41:11 -0800
From:   Himanshu Madhani <hmadhani@marvell.com>
To:     <James.Bottomley@HansenPartnership.com>,
        <martin.petersen@oracle.com>
CC:     <hmadhani@marvell.com>, <linux-scsi@vger.kernel.org>
Subject: [PATCH 16/18] qla2xxx: Handle NVME status iocb correctly
Date:   Wed, 26 Feb 2020 14:40:20 -0800
Message-ID: <20200226224022.24518-17-hmadhani@marvell.com>
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

From: Arun Easi <aeasi@marvell.com>

Certain state flags bit combinations are not checked
and not handled correctly. Plus, do not log a normal
underrun situation, where there is no frame drop.

Signed-off-by: Arun Easi <aeasi@marvell.com>
Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
---
 drivers/scsi/qla2xxx/qla_isr.c | 47 +++++++++++++++++++++++++++++++++++-------
 1 file changed, 39 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 0217a3456705..3699d3a29135 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -2064,6 +2064,7 @@ static void qla24xx_nvme_iocb_entry(scsi_qla_host_t *vha, struct req_que *req,
 	struct nvmefc_fcp_req *fd;
 	uint16_t        ret = QLA_SUCCESS;
 	uint16_t	comp_status = le16_to_cpu(sts->comp_status);
+	int		logit = 0;
 
 	iocb = &sp->u.iocb_cmd;
 	fcport = sp->fcport;
@@ -2074,6 +2075,12 @@ static void qla24xx_nvme_iocb_entry(scsi_qla_host_t *vha, struct req_que *req,
 	if (unlikely(iocb->u.nvme.aen_op))
 		atomic_dec(&sp->vha->hw->nvme_active_aen_cnt);
 
+	if (unlikely(comp_status != CS_COMPLETE))
+		logit = 1;
+
+	fd->transferred_length = fd->payload_length -
+	    le32_to_cpu(sts->residual_len);
+
 	/*
 	 * State flags: Bit 6 and 0.
 	 * If 0 is set, we don't care about 6.
@@ -2084,8 +2091,20 @@ static void qla24xx_nvme_iocb_entry(scsi_qla_host_t *vha, struct req_que *req,
 	 */
 	if (!(state_flags & (SF_FCP_RSP_DMA | SF_NVME_ERSP))) {
 		iocb->u.nvme.rsp_pyld_len = 0;
-	} else if ((state_flags & SF_FCP_RSP_DMA)) {
+	} else if ((state_flags & (SF_FCP_RSP_DMA | SF_NVME_ERSP)) ==
+			(SF_FCP_RSP_DMA | SF_NVME_ERSP)) {
+		/* Response already DMA'd to fd->rspaddr. */
 		iocb->u.nvme.rsp_pyld_len = le16_to_cpu(sts->nvme_rsp_pyld_len);
+	} else if ((state_flags & SF_FCP_RSP_DMA)) {
+		/*
+		 * Non-zero value in first 12 bytes of NVMe_RSP IU, treat this
+		 * as an error.
+		 */
+		iocb->u.nvme.rsp_pyld_len = 0;
+		fd->transferred_length = 0;
+		ql_dbg(ql_dbg_io, fcport->vha, 0x307a,
+			"Unexpected values in NVMe_RSP IU.\n");
+		logit = 1;
 	} else if (state_flags & SF_NVME_ERSP) {
 		uint32_t *inbuf, *outbuf;
 		uint16_t iter;
@@ -2108,16 +2127,28 @@ static void qla24xx_nvme_iocb_entry(scsi_qla_host_t *vha, struct req_que *req,
 		iter = iocb->u.nvme.rsp_pyld_len >> 2;
 		for (; iter; iter--)
 			*outbuf++ = swab32(*inbuf++);
-	} else { /* unhandled case */
-	    ql_log(ql_log_warn, fcport->vha, 0x503a,
-		"NVME-%s error. Unhandled state_flags of %x\n",
-		sp->name, state_flags);
 	}
 
-	fd->transferred_length = fd->payload_length -
-	    le32_to_cpu(sts->residual_len);
+	if (state_flags & SF_NVME_ERSP) {
+		struct nvme_fc_ersp_iu *rsp_iu = fd->rspaddr;
+		u32 tgt_xfer_len;
 
-	if (unlikely(comp_status != CS_COMPLETE))
+		tgt_xfer_len = be32_to_cpu(rsp_iu->xfrd_len);
+		if (fd->transferred_length != tgt_xfer_len) {
+			ql_dbg(ql_dbg_io, fcport->vha, 0x3079,
+				"Dropped frame(s) detected (sent/rcvd=%u/%u).\n",
+				tgt_xfer_len, fd->transferred_length);
+			logit = 1;
+		} else if (comp_status == CS_DATA_UNDERRUN) {
+			/*
+			 * Do not log if this is just an underflow and there
+			 * is no data loss.
+			 */
+			logit = 0;
+		}
+	}
+
+	if (unlikely(logit))
 		ql_log(ql_log_warn, fcport->vha, 0x5060,
 		   "NVME-%s ERR Handling - hdl=%x status(%x) tr_len:%x resid=%x  ox_id=%x\n",
 		   sp->name, sp->handle, comp_status,
-- 
2.12.0


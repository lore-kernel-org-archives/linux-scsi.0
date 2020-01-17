Return-Path: <SRS0=Mkh6=3G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5FDAC33C9E
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jan 2020 20:31:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BC96220748
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jan 2020 20:31:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="UQnU4JkY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729684AbgAQUbb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Jan 2020 15:31:31 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:45596 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727519AbgAQUbb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 17 Jan 2020 15:31:31 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00HKVSQt006853;
        Fri, 17 Jan 2020 12:31:28 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0818;
 bh=RTTWIaS/Dg8T/jocgMzKY29JbwtrfT3/yoVysGR40kA=;
 b=UQnU4JkYIeYbkfXyRWLbXHzVjh5pJ5ChClUsXvViTCNr2DYTb/H558edSaefcQ4qkdev
 ETbp+sHNd1Q4yldDO1bqnJOOyxWear+jiQ2Ubob4eqXpsgWHIefEqlOYzmpR5W72IK9f
 pHH+L5sbAUE/mS5X02+2RRfv2xwSQp+DM2ZcFq7gRpiO3peBKeFF7xe+3Y3K8z1oIfnT
 X8bxpe8A8GLKz28t4GOQnAe6YxmMi4ikbEesHrR2vwckWsCNqVkDXBBjOMrdvrfBwa+0
 rJDxawVhtAudY2NyrFq1NdNInQboQYF4HB6mLNxDh4yToNV8iLsrzEYUtgCAcLWdShs2 gA== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 2xk0s4m6na-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 17 Jan 2020 12:31:28 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 17 Jan
 2020 12:31:27 -0800
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 17 Jan 2020 12:31:27 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 455D23F7040;
        Fri, 17 Jan 2020 12:31:27 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 00HKVRdV004781;
        Fri, 17 Jan 2020 12:31:27 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 00HKVQiJ004777;
        Fri, 17 Jan 2020 12:31:26 -0800
From:   Himanshu Madhani <hmadhani@marvell.com>
To:     <James.Bottomley@HansenPartnership.com>,
        <martin.petersen@oracle.com>
CC:     <hmadhani@marvell.com>, <linux-scsi@vger.kernel.org>
Subject: [PATCH v3] qla2xxx: Fix unbound NVME response length
Date:   Fri, 17 Jan 2020 12:31:26 -0800
Message-ID: <20200117203126.4738-1-hmadhani@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-17_05:2020-01-16,2020-01-17 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Arun Easi <aeasi@marvell.com>

On certain cases when response length is less than 32, NVME response data
is supplied inline in IOCB. This is indicated by some combination of state
flags. There was an instance when a high, and incorrect, response length was
indicated causing driver to overrun buffers. Fix this by checking and
limiting the response payload length.

Fixes: 7401bc18d1ee3 ("scsi: qla2xxx: Add FC-NVMe command handling")
Cc: stable@vger.kernel.org
Signed-off-by: Arun Easi <aeasi@marvell.com>
Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
---
Hi Martin,

We discovered issue with our newer Gen7 adapter when response length
happens to be larger than 32 bytes, could result into crash.

Please apply this to 5.5/scsi-fixes branch at your earliest convenience.

Changes from v2 -> v3

o Use "sizeof(struct nvme_fc_ersp_iu)" to indicate response payload size.

Changes from v1 -> v2

o Fixed the tag for stable.
o Removed logit which got spilled from other patch to prevent compile failure.

Thanks,
Himanshu
---
 drivers/scsi/qla2xxx/qla_isr.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index e7bad0bfffda..2f26f8910d0b 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1939,6 +1939,15 @@ static void qla24xx_nvme_iocb_entry(scsi_qla_host_t *vha, struct req_que *req,
 		inbuf = (uint32_t *)&sts->nvme_ersp_data;
 		outbuf = (uint32_t *)fd->rspaddr;
 		iocb->u.nvme.rsp_pyld_len = le16_to_cpu(sts->nvme_rsp_pyld_len);
+		if (unlikely(iocb->u.nvme.rsp_pyld_len > 32)) {
+			WARN_ONCE(1, "Unexpected response payload length %u.\n",
+					iocb->u.nvme.rsp_pyld_len);
+			ql_log(ql_log_warn, fcport->vha, 0x5100,
+				"Unexpected response payload length %u.\n",
+				iocb->u.nvme.rsp_pyld_len);
+			iocb->u.nvme.rsp_pyld_len =
+			    sizeof(struct nvme_fc_ersp_iu);
+		}
 		iter = iocb->u.nvme.rsp_pyld_len >> 2;
 		for (; iter; iter--)
 			*outbuf++ = swab32(*inbuf++);
-- 
2.12.0


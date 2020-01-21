Return-Path: <SRS0=h99Q=3K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76D0AC2D0CE
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jan 2020 19:15:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 401CA217F4
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jan 2020 19:15:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="p+9sbXIg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727350AbgAUTPw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Jan 2020 14:15:52 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:35976 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726229AbgAUTPv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 21 Jan 2020 14:15:51 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00LJEU9W022353;
        Tue, 21 Jan 2020 11:15:49 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0818;
 bh=4frmz7CVyWytDscyFGAZD4kix2Vmd6K1+LAXfsb0mHA=;
 b=p+9sbXIgEdAmTLBpC97V7X52IgfAMQXGLDEvhMqey0JeGw9yEUEfefHX5UzUOvhCgpc7
 yYsXHQKjB2XmwvsAmuK17zWxgic3Xxj3ouJHc7oq2A9CC137bg9rHzl6J4+Hiul5ZPu1
 kQvIbV7BFekAGsAMYWG1cYFo/vNJwSrWREj5i1LOD4Vkef7a7V6X+imABDIas3cGRthr
 GPSlVZ79bODjpu7056t71d9dtQnNqtQQXyHf+r246Ni65lMzK+ouuUglmg5XloMe3aTA
 F9hRaSflQvCLmAGZ7dYQ4/X8DO87W4SWEnDF7pDbCh0tvNWFcjYP5csR//5cOpqd4evX bg== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 2xm2dt3mcy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 21 Jan 2020 11:15:49 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 21 Jan
 2020 11:15:46 -0800
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 21 Jan 2020 11:15:46 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id F33603F703F;
        Tue, 21 Jan 2020 11:15:46 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 00LJFkt4031878;
        Tue, 21 Jan 2020 11:15:46 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 00LJFkN8031877;
        Tue, 21 Jan 2020 11:15:46 -0800
From:   Himanshu Madhani <hmadhani@marvell.com>
To:     <James.Bottomley@HansenPartnership.com>,
        <martin.petersen@oracle.com>
CC:     <hmadhani@marvell.com>, <linux-scsi@vger.kernel.org>
Subject: [PATCH 1/1] qla2xxx: Fix unbound NVME response length
Date:   Tue, 21 Jan 2020 11:15:46 -0800
Message-ID: <20200121191546.31843-1-hmadhani@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.634
 definitions=2020-01-21_06:2020-01-21,2020-01-21 signatures=0
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

Changes from v3 -> v2

o use "sizeof(struct nvme_fc_ersp_iu)" in missed place.

Changes from v2 -> v3

o Use "sizeof(struct nvme_fc_ersp_iu)" to indicate response payload size.

Changes from v1 -> v2

o Fixed the tag for stable.
o Removed logit which got spilled from other patch to prevent compile failure.

Thanks,
Himanshu
---
 drivers/scsi/qla2xxx/qla_isr.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index e7bad0bfffda..4caec94d8e99 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1939,6 +1939,16 @@ static void qla24xx_nvme_iocb_entry(scsi_qla_host_t *vha, struct req_que *req,
 		inbuf = (uint32_t *)&sts->nvme_ersp_data;
 		outbuf = (uint32_t *)fd->rspaddr;
 		iocb->u.nvme.rsp_pyld_len = le16_to_cpu(sts->nvme_rsp_pyld_len);
+		if (unlikely(iocb->u.nvme.rsp_pyld_len >
+		    sizeof(struct nvme_fc_ersp_iu))) {
+			WARN_ONCE(1, "Unexpected response payload length %u.\n",
+			    iocb->u.nvme.rsp_pyld_len);
+			ql_log(ql_log_warn, fcport->vha, 0x5100,
+			    "Unexpected response payload length %u.\n",
+			    iocb->u.nvme.rsp_pyld_len);
+			iocb->u.nvme.rsp_pyld_len =
+			    sizeof(struct nvme_fc_ersp_iu);
+		}
 		iter = iocb->u.nvme.rsp_pyld_len >> 2;
 		for (; iter; iter--)
 			*outbuf++ = swab32(*inbuf++);
-- 
2.12.0


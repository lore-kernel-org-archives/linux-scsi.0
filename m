Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9685C433E9
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Jan 2021 10:42:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B4E15227C3
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Jan 2021 10:42:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728220AbhAEKlz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Jan 2021 05:41:55 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:18974 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728006AbhAEKlz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Jan 2021 05:41:55 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 105AemNk014395
        for <linux-scsi@vger.kernel.org>; Tue, 5 Jan 2021 02:41:14 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=BvGPA9oq+j6/fRmLkVAavSsMr4ZCtVGYLkZ9WzhXaRg=;
 b=LPTuvcNg7F8s3/pfAQQ927TVDg6XZxqaNj5evtGzWnRIBSS+DpajNZrIwYbV9Hd4vf0O
 /qrk+Yc9od7EJinOeJvG4NO1S8IT8vLPtiS/ZgUaOa+5BxJ+VINbiTam2DMTHCK56Vb8
 Y4dkjZbcAN/USOviLdzhEVN8syeGrbg8LgwKCjmwLVrxRgZs+rlzGoI17rSNzmWBbr8f
 EiYe7p9rmKjnXIeZRyJbSMD15do0GbpPIodMxgr6RMZH0iG7v8sA5comfSwX46YFwuEZ
 IXDs1BlYP8D68os7wdX+mOSAEtL7fKPkIBaQcyF9Op8GI/y7gfF5QxKa/8XwTIViUCVo iw== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 35tq2ue6yj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 05 Jan 2021 02:41:14 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 5 Jan
 2021 02:41:13 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 5 Jan
 2021 02:41:12 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 5 Jan 2021 02:41:12 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 727493F703F;
        Tue,  5 Jan 2021 02:41:12 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 105AfCEq025215;
        Tue, 5 Jan 2021 02:41:12 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 105AfCMR025213;
        Tue, 5 Jan 2021 02:41:12 -0800
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH v3 5/7] qla2xxx: Fix mailbox Ch erroneous error
Date:   Tue, 5 Jan 2021 02:38:45 -0800
Message-ID: <20210105103847.25041-6-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20210105103847.25041-1-njavali@marvell.com>
References: <20210105103847.25041-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-05_01:2021-01-05,2021-01-05 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

Mailbox Ch/dump ram extend expects mb register 10 to be
set. If not set/clear, firmware can pick up garbage from previous
invocation of this mailbox. Example: mctp dump can set mb10.
On subsequent flash read which use mailbox cmd Ch, mb10 can
retain previous value.

Cc: stable@vger.kernel.org
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_dbg.c | 1 +
 drivers/scsi/qla2xxx/qla_mbx.c | 3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index bb7431912d41..144a893e7335 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -202,6 +202,7 @@ qla24xx_dump_ram(struct qla_hw_data *ha, uint32_t addr, __be32 *ram,
 		wrt_reg_word(&reg->mailbox0, MBC_DUMP_RISC_RAM_EXTENDED);
 		wrt_reg_word(&reg->mailbox1, LSW(addr));
 		wrt_reg_word(&reg->mailbox8, MSW(addr));
+		wrt_reg_word(&reg->mailbox10, 0);
 
 		wrt_reg_word(&reg->mailbox2, MSW(LSD(dump_dma)));
 		wrt_reg_word(&reg->mailbox3, LSW(LSD(dump_dma)));
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 629af6fe8c55..06c99963b2c9 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -4291,7 +4291,8 @@ qla2x00_dump_ram(scsi_qla_host_t *vha, dma_addr_t req_dma, uint32_t addr,
 	if (MSW(addr) || IS_FWI2_CAPABLE(vha->hw)) {
 		mcp->mb[0] = MBC_DUMP_RISC_RAM_EXTENDED;
 		mcp->mb[8] = MSW(addr);
-		mcp->out_mb = MBX_8|MBX_0;
+		mcp->mb[10] = 0;
+		mcp->out_mb = MBX_10|MBX_8|MBX_0;
 	} else {
 		mcp->mb[0] = MBC_DUMP_RISC_RAM;
 		mcp->out_mb = MBX_0;
-- 
2.19.0.rc0


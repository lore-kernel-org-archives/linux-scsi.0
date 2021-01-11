Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8299C433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Jan 2021 09:34:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A2A5A22516
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Jan 2021 09:34:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728430AbhAKJen (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Jan 2021 04:34:43 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:40568 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728179AbhAKJem (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 11 Jan 2021 04:34:42 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10B9VPGn013541
        for <linux-scsi@vger.kernel.org>; Mon, 11 Jan 2021 01:34:01 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=mQuL8GP3A1JcX+WkcB455KMYsQEbwP/PVjlZ2Ubx7Co=;
 b=e4vuPi1dh0PeKKGg1Hw7k5jTqxKoC2phwVfXJ8u4OtisKg90PM6nhfjMj8uObVYM9geR
 2MxjvvIC26PqsVTERRBjAbXseKMN/WV4fI2ZPae2SPwhRkBh13KJQql5Ztms2hnJMj/8
 XNq8AqtWNGwa8L/MUWNz20qO26iveaUzvZxySBNLqsV9fdU0dJpw8BWLWKFTZUIz2lhr
 udxaOevBfW++IAV7Aqu0GXhTl9y3SnM0iXN/aqQePIlxY/jbQSzrUZs2/ZYPDdKSo7EY
 ad4A5jzNOuOEROx05s0vBESX1FMdaKSovrcPgyo/a7M9AaN6uGrhOk95kypP3nivVsI7 VQ== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 35ycvpkg4e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 11 Jan 2021 01:34:01 -0800
Received: from SC-EXCH02.marvell.com (10.93.176.82) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 11 Jan
 2021 01:33:59 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 11 Jan
 2021 01:33:59 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 11 Jan 2021 01:33:59 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 123693F7043;
        Mon, 11 Jan 2021 01:33:59 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 10B9Xwtn001290;
        Mon, 11 Jan 2021 01:33:58 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 10B9Xwwu001289;
        Mon, 11 Jan 2021 01:33:58 -0800
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH v4 5/7] qla2xxx: Fix mailbox Ch erroneous error
Date:   Mon, 11 Jan 2021 01:31:32 -0800
Message-ID: <20210111093134.1206-6-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20210111093134.1206-1-njavali@marvell.com>
References: <20210111093134.1206-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-09_13:2021-01-07,2021-01-09 signatures=0
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
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
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


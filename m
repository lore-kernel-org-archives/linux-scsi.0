Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40425C433C1
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Mar 2021 04:47:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EE111619A5
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Mar 2021 04:47:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229493AbhCWEqk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 Mar 2021 00:46:40 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:44646 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229547AbhCWEqN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 23 Mar 2021 00:46:13 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12N4jUgY021133
        for <linux-scsi@vger.kernel.org>; Mon, 22 Mar 2021 21:46:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=c5CUQh+c0D6i9y2wx6ZS3wiElk3vPfG/cNTTD7n0+OE=;
 b=gQAKLoq3eVUG4uYkX4MqUWGa9yZNrf1ysJpLq6IUHooJNMfwWinGx69J17IY5tiDM1H0
 hIAQnqnjK02arcVflSzChL1jAEjeIHXNaHAcn/RnIIt0mhN5LkS4QtAWnj52Lo9d2UHU
 28xnC0JteojTGiRtz0la1pPPUh1Nh4tgTd7H4fX5lvDh/9g/30fXhDuZ0Kk/TdGbVvAQ
 Gei1/rSxByuuaA2gaH/+d+p+Q/v2Z0yMYW9+qHgzDSmYSRRHMjPlhgKz7BdNXQ67RAaX
 xpYalS+s/G1eBumKyaqs048aRxiqfN2W1T9fRxlprtXXJWM7igvInRbsIz1bjm1hFNNr lw== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 37dgjnygyb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 22 Mar 2021 21:46:13 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 22 Mar
 2021 21:46:11 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 22 Mar 2021 21:46:11 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 0D7723F7040;
        Mon, 22 Mar 2021 21:46:11 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 12N4kA8C026753;
        Mon, 22 Mar 2021 21:46:10 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 12N4kAMu026744;
        Mon, 22 Mar 2021 21:46:10 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH 07/11] qla2xxx: fix RISC RESET completion polling
Date:   Mon, 22 Mar 2021 21:42:53 -0700
Message-ID: <20210323044257.26664-8-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20210323044257.26664-1-njavali@marvell.com>
References: <20210323044257.26664-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-23_01:2021-03-22,2021-03-23 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

After risc reset, the poll time for risc reset completion is
too short. Fix the completion polling time.

Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_init.c | 65 ++++++++++++++++++++++++++++++---
 1 file changed, 59 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index f6dc8166e7ba..19681d3c5b7a 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -2767,6 +2767,49 @@ qla81xx_reset_mpi(scsi_qla_host_t *vha)
 	return qla81xx_write_mpi_register(vha, mb);
 }
 
+static int
+qla_chk_risc_recovery(scsi_qla_host_t *vha)
+{
+	struct qla_hw_data *ha = vha->hw;
+	struct device_reg_24xx __iomem *reg = &ha->iobase->isp24;
+	__le16 __iomem *mbptr = &reg->mailbox0;
+	int i;
+	u16 mb[32];
+	int rc = QLA_SUCCESS;
+
+	if (!IS_QLA27XX(ha) && !IS_QLA28XX(ha))
+		return rc;
+
+	/* this check is only valid after RISC reset */
+	mb[0] = rd_reg_word(mbptr);
+	mbptr++;
+	if (mb[0] == 0xf) {
+		rc = QLA_FUNCTION_FAILED;
+
+		for (i = 1; i < 32; i++) {
+			mb[i] = rd_reg_word(mbptr);
+			mbptr++;
+		}
+
+		ql_log(ql_log_warn, vha, 0x1015,
+		       "RISC reset failed. mb[0-7] %04xh %04xh %04xh %04xh %04xh %04xh %04xh %04xh\n",
+		       mb[0], mb[1], mb[2], mb[3], mb[4], mb[5], mb[6], mb[7]);
+		ql_log(ql_log_warn, vha, 0x1015,
+		       "RISC reset failed. mb[8-15] %04xh %04xh %04xh %04xh %04xh %04xh %04xh %04xh\n",
+		       mb[8], mb[9], mb[10], mb[11], mb[12], mb[13], mb[14],
+		       mb[15]);
+		ql_log(ql_log_warn, vha, 0x1015,
+		       "RISC reset failed. mb[16-23] %04xh %04xh %04xh %04xh %04xh %04xh %04xh %04xh\n",
+		       mb[16], mb[17], mb[18], mb[19], mb[20], mb[21], mb[22],
+		       mb[23]);
+		ql_log(ql_log_warn, vha, 0x1015,
+		       "RISC reset failed. mb[24-31] %04xh %04xh %04xh %04xh %04xh %04xh %04xh %04xh\n",
+		       mb[24], mb[25], mb[26], mb[27], mb[28], mb[29], mb[30],
+		       mb[31]);
+	}
+	return rc;
+}
+
 /**
  * qla24xx_reset_risc() - Perform full reset of ISP24xx RISC.
  * @vha: HA context
@@ -2783,6 +2826,7 @@ qla24xx_reset_risc(scsi_qla_host_t *vha)
 	uint16_t wd;
 	static int abts_cnt; /* ISP abort retry counts */
 	int rval = QLA_SUCCESS;
+	int print = 1;
 
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 
@@ -2871,17 +2915,26 @@ qla24xx_reset_risc(scsi_qla_host_t *vha)
 	rd_reg_dword(&reg->hccr);
 
 	wrt_reg_dword(&reg->hccr, HCCRX_CLR_RISC_RESET);
+	mdelay(10);
 	rd_reg_dword(&reg->hccr);
 
-	rd_reg_word(&reg->mailbox0);
-	for (cnt = 60; rd_reg_word(&reg->mailbox0) != 0 &&
-	    rval == QLA_SUCCESS; cnt--) {
+	wd = rd_reg_word(&reg->mailbox0);
+	for (cnt = 300; wd != 0 && rval == QLA_SUCCESS; cnt--) {
 		barrier();
-		if (cnt)
-			udelay(5);
-		else
+		if (cnt) {
+			mdelay(1);
+			if (print && qla_chk_risc_recovery(vha))
+				print = 0;
+
+			wd = rd_reg_word(&reg->mailbox0);
+		} else {
 			rval = QLA_FUNCTION_TIMEOUT;
+
+			ql_log(ql_log_warn, vha, 0x015e,
+			       "RISC reset timeout\n");
+		}
 	}
+
 	if (rval == QLA_SUCCESS)
 		set_bit(RISC_RDY_AFT_RESET, &ha->fw_dump_cap_flags);
 
-- 
2.19.0.rc0


Return-Path: <SRS0=g50V=BP=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFA06C433DF
	for <linux-scsi@archiver.kernel.org>; Wed,  5 Aug 2020 04:46:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B58FF2177B
	for <linux-scsi@archiver.kernel.org>; Wed,  5 Aug 2020 04:46:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=marvell.com header.i=@marvell.com header.b="JX6bt9DB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725950AbgHEEqb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 5 Aug 2020 00:46:31 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:54710 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725904AbgHEEqb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Aug 2020 00:46:31 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0754ZYlg023945
        for <linux-scsi@vger.kernel.org>; Tue, 4 Aug 2020 21:46:29 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=CK+pwEY7yXMx5FPOvNySpmEM8kfvgkg448tLdaFjMMY=;
 b=JX6bt9DBJh0iD1DZaGN6so4KlDQN28eZeRrKj9jXUzroELaApKJIluuyOjbiag6xGEt6
 RfbtbW5D0IKysxxRCU/F13Aw2U2g+77v6uEQp4UQZcm7pBmpZXnRZu8DzKudIG7hAWSv
 1fWxROUgGOauEyAbiUjypTOtW53clPlVhXar8W9V4WQdBUcudpV2NkQFFICLzAsKKwgA
 jFi/OTUfh9+goCIr2ONO/YfZtBdF7NzT0cnrlOmF6KOORc3S0CdS30JWNbf1qpRDHWEG
 t+fZ1EXfqZhRSmzj4U8aC9diBEh1xho7CM+zJB3vCSP13IiUwyu2LZ7C8ZDzybqapxYg TQ== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 32n8fex8fn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 04 Aug 2020 21:46:29 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 4 Aug
 2020 21:46:27 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 4 Aug 2020 21:46:28 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id BCB4F3F703F;
        Tue,  4 Aug 2020 21:46:27 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 0754kRcU030616;
        Tue, 4 Aug 2020 21:46:27 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 0754kRwC030615;
        Tue, 4 Aug 2020 21:46:27 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH 05/10] qla2xxx: reduce noisy debug message
Date:   Tue, 4 Aug 2020 21:43:57 -0700
Message-ID: <20200805044402.30543-6-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20200805044402.30543-1-njavali@marvell.com>
References: <20200805044402.30543-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-05_03:2020-08-03,2020-08-05 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

Update debug level and message for ELS IOCB done.

Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_isr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 27bcd346af7c..ab5275dbc338 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -2024,8 +2024,8 @@ qla24xx_els_ct_entry(scsi_qla_host_t *vha, struct req_que *req,
 				res = DID_ERROR << 16;
 			}
 		}
-		ql_dbg(ql_dbg_user, vha, 0x503f,
-		    "ELS IOCB Done -%s error hdl=%x comp_status=0x%x error subcode 1=0x%x error subcode 2=0x%x total_byte=0x%x\n",
+		ql_dbg(ql_dbg_disc, vha, 0x503f,
+		    "ELS IOCB Done -%s hdl=%x comp_status=0x%x error subcode 1=0x%x error subcode 2=0x%x total_byte=0x%x\n",
 		    type, sp->handle, comp_status, fw_status[1], fw_status[2],
 		    le32_to_cpu(ese->total_byte_count));
 		goto els_ct_done;
-- 
2.19.0.rc0


Return-Path: <SRS0=JvOq=BQ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A9D2C4345D
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Aug 2020 11:17:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DA9A122D37
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Aug 2020 11:17:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=marvell.com header.i=@marvell.com header.b="EoGqLkDk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725927AbgHFLNu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 6 Aug 2020 07:13:50 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:50630 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726464AbgHFLNb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Aug 2020 07:13:31 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 076BA2vf021194
        for <linux-scsi@vger.kernel.org>; Thu, 6 Aug 2020 04:12:42 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=CK+pwEY7yXMx5FPOvNySpmEM8kfvgkg448tLdaFjMMY=;
 b=EoGqLkDkI9jPD1Dfz5ev53FrE3nRVRRK3HEaa79QTQtneoNB9y91mWGnoUjatX6ffaGn
 Eu2HoPUtxX71fY4P3Y1/pZOfGi/PaBahB/0EflD1tNWpobOmIWR9VnH9xG8tcbqIi1ON
 u6G2Ejkmdp6iM0xTXENWIZixIco14R3yHjpBvPDSbUrqIHcWvq0xET5ls3QsNuGOonE9
 Kc0gS5++1uju6WYcZByIaTI20+WiJu48VvrYJbjxBYJKy0Jbj0lFcl+eM8S+PkcaHSpJ
 CPjggj+Qxs8kyGPsfo6QfWjhcWhtRmUWS7+AT3e9zUOFqeUEirGHbtvfhEFRUvuth5kf 6Q== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 32n8ff3x95-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 06 Aug 2020 04:12:42 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 6 Aug
 2020 04:12:40 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 6 Aug
 2020 04:12:39 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 6 Aug 2020 04:12:39 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 6336A3F703F;
        Thu,  6 Aug 2020 04:12:39 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 076BCdCl028506;
        Thu, 6 Aug 2020 04:12:39 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 076BCdsh028505;
        Thu, 6 Aug 2020 04:12:39 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH v2 05/11] qla2xxx: reduce noisy debug message
Date:   Thu, 6 Aug 2020 04:10:08 -0700
Message-ID: <20200806111014.28434-6-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20200806111014.28434-1-njavali@marvell.com>
References: <20200806111014.28434-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-06_06:2020-08-06,2020-08-06 signatures=0
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


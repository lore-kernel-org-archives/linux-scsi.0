Return-Path: <SRS0=mj/2=4O=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28CF9C4BA24
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Feb 2020 22:42:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F3CCA24672
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Feb 2020 22:42:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="hbSibUYb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727846AbgBZWm4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 26 Feb 2020 17:42:56 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:65310 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727761AbgBZWm4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 26 Feb 2020 17:42:56 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01QMeN60006111;
        Wed, 26 Feb 2020 14:40:55 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=sHF4c/FFcPXhqMyfelKCwoVFJP3Jx31YGyrTr2j1oCU=;
 b=hbSibUYbB0IYzaj+UJuonDDKbV8Te0uRE/2uapFIy8G+87maqo8V5pyknlOMzgvD8Dcz
 5+9MOVpjH3FdwhN3Jd+zxCqzkreTsBbegrDh7jtgqnaVk4NAIS4JpFmcP+oGi14V+ZsT
 gjgf1U3xgOOlYqYZlJkerzP/ZeF5pdPdWw/i1mbXN3kC9gAOvESqq+7kdu57ZOO3E9da
 RXSwmNtoXQjeD7FcJPXjt73XRF/mBbLuATQpmjoNlWEKLOZBVVIYHO4rU+U8V4tjCbe/
 o2979OTDV3YTO4EhJWNLEw4hlx/doLPV/fCyXhRZNyafpGLYz5LQtLxVxSHNqde3hui5 3Q== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 2ydchtd6mr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 26 Feb 2020 14:40:54 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 26 Feb
 2020 14:40:53 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 26 Feb
 2020 14:40:52 -0800
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 26 Feb 2020 14:40:52 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 57D193F7040;
        Wed, 26 Feb 2020 14:40:52 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 01QMeq1I024601;
        Wed, 26 Feb 2020 14:40:52 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 01QMeqch024600;
        Wed, 26 Feb 2020 14:40:52 -0800
From:   Himanshu Madhani <hmadhani@marvell.com>
To:     <James.Bottomley@HansenPartnership.com>,
        <martin.petersen@oracle.com>
CC:     <hmadhani@marvell.com>, <linux-scsi@vger.kernel.org>
Subject: [PATCH 10/18] qla2xxx: add more FW debug information
Date:   Wed, 26 Feb 2020 14:40:14 -0800
Message-ID: <20200226224022.24518-11-hmadhani@marvell.com>
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

From: Quinn Tran <qutran@marvell.com>

Per FW request, MB 1-7 should be logged for 8002 error.

Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
---
 drivers/scsi/qla2xxx/qla_isr.c | 24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 785f5319aa1b..0217a3456705 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -854,12 +854,24 @@ qla2x00_async_event(scsi_qla_host_t *vha, struct rsp_que *rsp, uint16_t *mb)
 		break;
 
 	case MBA_SYSTEM_ERR:		/* System Error */
-		mbx = (IS_QLA81XX(ha) || IS_QLA83XX(ha) || IS_QLA27XX(ha) ||
-		    IS_QLA28XX(ha)) ?
-			RD_REG_WORD(&reg24->mailbox7) : 0;
-		ql_log(ql_log_warn, vha, 0x5003,
-		    "ISP System Error - mbx1=%xh mbx2=%xh mbx3=%xh "
-		    "mbx7=%xh.\n", mb[1], mb[2], mb[3], mbx);
+		mbx = 0;
+		if (IS_QLA81XX(ha) || IS_QLA83XX(ha) ||
+		    IS_QLA27XX(ha) || IS_QLA28XX(ha)) {
+			u16 m[4];
+
+			m[0] = RD_REG_WORD(&reg24->mailbox4);
+			m[1] = RD_REG_WORD(&reg24->mailbox5);
+			m[2] = RD_REG_WORD(&reg24->mailbox6);
+			mbx = m[3] = RD_REG_WORD(&reg24->mailbox7);
+
+			ql_log(ql_log_warn, vha, 0x5003,
+			    "ISP System Error - mbx1=%xh mbx2=%xh mbx3=%xh mbx4=%xh mbx5=%xh mbx6=%xh mbx7=%xh.\n",
+			    mb[1], mb[2], mb[3], m[0], m[1], m[2], m[3]);
+		} else
+			ql_log(ql_log_warn, vha, 0x5003,
+			    "ISP System Error - mbx1=%xh mbx2=%xh mbx3=%xh.\n ",
+			    mb[1], mb[2], mb[3]);
+
 		ha->fw_dump_mpi =
 		    (IS_QLA27XX(ha) || IS_QLA28XX(ha)) &&
 		    RD_REG_WORD(&reg24->mailbox7) & BIT_8;
-- 
2.12.0


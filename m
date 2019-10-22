Return-Path: <SRS0=5qjn=YP=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A868ACA9EB7
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Oct 2019 19:36:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7947E214B2
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Oct 2019 19:36:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="aTeko+Z6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388136AbfJVTgz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Oct 2019 15:36:55 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:55906 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732623AbfJVTgz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 22 Oct 2019 15:36:55 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9MJZe1B007872;
        Tue, 22 Oct 2019 12:36:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=WeF2NDmeJM35579Gy7dFq6s67RlMX/UKTbJQDpqcBRI=;
 b=aTeko+Z6HG3tummM4wA3cf6YtmU/QcjXXCBGiA31E7swAwPdIK3YNjUU0T3GuISMMJla
 E1LWAUVBxWS07KXs1W48ad/Tg59E72BnvsgwB5LiHWWxVnUvVhMXx/S5jlO30N6YRjvj
 C3n6ZwrRy6ZQKLZt1Tk8xhg9J8ok/AMKZXhyxVFBbyyTilADxgVcgpxwjRBG4WNcTapF
 7lL+Mcuv2qXbepX0R8veNERpPFF/iHg9EJQZB0/toaBYwHtxHUGkrBjKvhPHOmyDQ6Ua
 LsgEEcYqihtHzETM3Q1syVd3pGpY/a8hfCauRh3iTu25+5D6DeDiiKZNQ2TPZD4nukwM 6A== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 2vsw612f9q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 22 Oct 2019 12:36:49 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Tue, 22 Oct
 2019 12:36:47 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1367.3 via Frontend
 Transport; Tue, 22 Oct 2019 12:36:47 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 752783F7040;
        Tue, 22 Oct 2019 12:36:47 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id x9MJalJO007115;
        Tue, 22 Oct 2019 12:36:47 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id x9MJalW0007114;
        Tue, 22 Oct 2019 12:36:47 -0700
From:   Himanshu Madhani <hmadhani@marvell.com>
To:     <James.Bottomley@HansenPartnership.com>,
        <martin.petersen@oracle.com>
CC:     <hmadhani@marvell.com>, <linux-scsi@vger.kernel.org>
Subject: [PATCH 1/2] qla2xxx: Initialized mailbox to prevent driver load failure
Date:   Tue, 22 Oct 2019 12:36:42 -0700
Message-ID: <20191022193643.7076-2-hmadhani@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20191022193643.7076-1-hmadhani@marvell.com>
References: <20191022193643.7076-1-hmadhani@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-22_06:2019-10-22,2019-10-22 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch fixes issue with Gen7 adapter in a blade enviornment,
where one of the port will not be detected by driver. Firmware
expectes mailbox 11 to be set or clear by driver for newer ISP.

Following message is seen in the log file

[   18.810892] qla2xxx [0000:d8:00.0]-1820:1: **** Failed=102 mb[0]=4005 mb[1]=37 mb[2]=20 mb[3]=8
[   18.819596]  cmd=2 ****

Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
---
 drivers/scsi/qla2xxx/qla_mbx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 1cc6913f76c4..4a1f21c11758 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -702,6 +702,7 @@ qla2x00_execute_fw(scsi_qla_host_t *vha, uint32_t risc_addr)
 		mcp->mb[2] = LSW(risc_addr);
 		mcp->mb[3] = 0;
 		mcp->mb[4] = 0;
+		mcp->mb[11] = 0;
 		ha->flags.using_lr_setting = 0;
 		if (IS_QLA25XX(ha) || IS_QLA81XX(ha) || IS_QLA83XX(ha) ||
 		    IS_QLA27XX(ha) || IS_QLA28XX(ha)) {
@@ -746,7 +747,7 @@ qla2x00_execute_fw(scsi_qla_host_t *vha, uint32_t risc_addr)
 		if (ha->flags.exchoffld_enabled)
 			mcp->mb[4] |= ENABLE_EXCHANGE_OFFLD;
 
-		mcp->out_mb |= MBX_4|MBX_3|MBX_2|MBX_1;
+		mcp->out_mb |= MBX_4 | MBX_3 | MBX_2 | MBX_1 | MBX_11;
 		mcp->in_mb |= MBX_3 | MBX_2 | MBX_1;
 	} else {
 		mcp->mb[1] = LSW(risc_addr);
-- 
2.12.0


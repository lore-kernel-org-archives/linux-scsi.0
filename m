Return-Path: <SRS0=Uiav=5Q=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96D66C2D0EE
	for <linux-scsi@archiver.kernel.org>; Tue, 31 Mar 2020 10:40:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6539320772
	for <linux-scsi@archiver.kernel.org>; Tue, 31 Mar 2020 10:40:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="vfnq071E"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730106AbgCaKkZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 31 Mar 2020 06:40:25 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:22372 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729925AbgCaKkZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 31 Mar 2020 06:40:25 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02VAZQQA008541
        for <linux-scsi@vger.kernel.org>; Tue, 31 Mar 2020 03:40:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=PaCq28cRf3ZV0xV4IR46OPJHzq4zWjcnx1yuMZ0IxxE=;
 b=vfnq071EXdaTa6+4o7wYccgtDEZqv3vW8NnVZmmTcZnj2gyi+utGYmhgtqDP1j6wmlZk
 Ag9SZ2490RK04k+8yGg+NNkMz9R0iMIRHE3yicy4CTAj74pt2tAP4AP6JymulIMxhjki
 SlJXDlMM8ujlujbvYfkQt6hpwolTuM8WTUvUw8kAU/bVSAn3Ru5SB5Kxw010BViPwufx
 APJWhNcNH0utHkxqiJq8dMd+lmyt1RUGYm0PpCUabydEuFyFnr28po6L958n7D0ovd8e
 NOomyMHshNtGNYyD4T3R73plsO6ODdmg8nGG0+8fSqZh6W0di9ncnWXRlPhlr+vWdBZg Pg== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 3023xp2pcj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 31 Mar 2020 03:40:24 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 31 Mar
 2020 03:40:22 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 31 Mar
 2020 03:40:22 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 31 Mar 2020 03:40:21 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id BD9723F7043;
        Tue, 31 Mar 2020 03:40:21 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 02VAeLb0024911;
        Tue, 31 Mar 2020 03:40:21 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 02VAeLTa024910;
        Tue, 31 Mar 2020 03:40:21 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH v3 2/3] qla2xxx: Fix hang when issuing nvme disconnect-all in NPIV.
Date:   Tue, 31 Mar 2020 03:40:14 -0700
Message-ID: <20200331104015.24868-3-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20200331104015.24868-1-njavali@marvell.com>
References: <20200331104015.24868-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-03-31_04:2020-03-30,2020-03-31 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Arun Easi <aeasi@marvell.com>

In NPIV environment, a NPIV host may use a queue pair created
by base host or other NPIVs, so the check for a queue pair
created by this NPIV is not correct, and can cause an abort
to fail, which in turn means the NVME command not returned.
This leads to hang in nvme_fc layer in nvme_fc_delete_association()
which waits for all I/Os to be returned, which is seen as hang
in the application.

Signed-off-by: Arun Easi <aeasi@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
---
 drivers/scsi/qla2xxx/qla_mbx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 9fd83d1bffe0..7cefe35d61d1 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -3153,7 +3153,7 @@ qla24xx_abort_command(srb_t *sp)
 	ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x108c,
 	    "Entered %s.\n", __func__);
 
-	if (vha->flags.qpairs_available && sp->qpair)
+	if (sp->qpair)
 		req = sp->qpair->req;
 	else
 		return QLA_FUNCTION_FAILED;
-- 
2.19.0.rc0


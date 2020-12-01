Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9BE6C64E7A
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Dec 2020 08:33:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 73D8921D7A
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Dec 2020 08:33:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="h8XutENJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726415AbgLAIdw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Dec 2020 03:33:52 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:11230 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726041AbgLAIdw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Dec 2020 03:33:52 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0B18Vrv5026049
        for <linux-scsi@vger.kernel.org>; Tue, 1 Dec 2020 00:33:10 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=o/sgOlLFPE65UtETC3D7Ams51ehl/SL8c4L2V/4LM0o=;
 b=h8XutENJVdUeb/RcSWSwgbLG3CSuH+QqFqN57esuZ0TxKYL59iutvocQO8SqPb9ClR8p
 Mt6LrDecO731OEGHzxJ4e6BsjniprJL5IOGP1cpCx7CIM2RTEoMOm/BdOTroM6zcDf2M
 hkoT4m6ltUVf/pbNR/F+IhvKXKJpTiGZlXvZA7g/NrYjiwjznU1i9C2rCITbpU12/9Ap
 6LshRV4odM3ODrghgUBM1EbqV0t7LERrP5ixPjNCn2D/VLBW/nJuEL/RkGqZ+T2JDHPQ
 xiOwnnh89sg0rI2IOh6XEYHBK/ZpAOhw4VPGasdkGXKOB61UvMGFPrlVSFcObmYv4Lrs Hw== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 353pxsf7ph-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 01 Dec 2020 00:33:10 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 1 Dec
 2020 00:33:08 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 1 Dec 2020 00:33:09 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id C77193F703F;
        Tue,  1 Dec 2020 00:33:08 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 0B18X8Hd024349;
        Tue, 1 Dec 2020 00:33:08 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 0B18X8iW024348;
        Tue, 1 Dec 2020 00:33:08 -0800
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH 13/15] qla2xxx: If fcport is undergoing deletion return IO with retry
Date:   Tue, 1 Dec 2020 00:27:28 -0800
Message-ID: <20201201082730.24158-14-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20201201082730.24158-1-njavali@marvell.com>
References: <20201201082730.24158-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-01_01:2020-11-30,2020-12-01 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Saurav Kashyap <skashyap@marvell.com>

Driver unload with IOs causes server to crash.
Return IO with retry if fcport undergoing deletion.

Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_os.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index a75edba2b334..be9d10092dd3 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -884,8 +884,8 @@ qla2xxx_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 			goto qc24_fail_command;
 	}
 
-	if (!fcport) {
-		cmd->result = DID_NO_CONNECT << 16;
+	if (!fcport || fcport->deleted) {
+		cmd->result = DID_IMM_RETRY << 16;
 		goto qc24_fail_command;
 	}
 
@@ -966,8 +966,8 @@ qla2xxx_mqueuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd,
 		goto qc24_fail_command;
 	}
 
-	if (!fcport) {
-		cmd->result = DID_NO_CONNECT << 16;
+	if (!fcport || fcport->deleted) {
+		cmd->result = DID_IMM_RETRY << 16;
 		goto qc24_fail_command;
 	}
 
-- 
2.19.0.rc0


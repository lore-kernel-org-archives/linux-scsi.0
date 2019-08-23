Return-Path: <SRS0=qm3h=WT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9FF2C3A5A2
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Aug 2019 09:52:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A200D22CE3
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Aug 2019 09:52:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="JsyK40eA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389119AbfHWJw4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 23 Aug 2019 05:52:56 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:3814 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732878AbfHWJw4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 23 Aug 2019 05:52:56 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x7N9nsaq003696
        for <linux-scsi@vger.kernel.org>; Fri, 23 Aug 2019 02:52:55 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=4IqxsISt+3qMvELL/nt0+9mR90i0654soXHcDfjbu3M=;
 b=JsyK40eAjg5U2+SVNjKan+Rlo/ubsoZ+lt2pKpEf5q2bK+46I791dUICOKRtMAQ49Fog
 nJbQw8oP1J5mX+HMha7OdW4qhYUvwyQQNQpnIFvU1SEaDBtAYje0dw3MpDGWBXcy1bl1
 ziqq6dz6xFWzhBw+JNyePFHNYk7i5+MYTy9h7uGnuX9wa0nemQpwbnOENQmZLbCjXBBV
 9qNXc9A3G3FB8IVXq3czBihIpCBlk7k5IcVTozEs4bMWDryrGz8PR+Ar/FSDzpVagFuM
 QOHPG9HbArY6/hi1Z9uIVOe7uk9luaJpC7jJBBnUyjqjAX7f6BXOo1gw1unrapupGNKo 1w== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 2uhad40730-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Fri, 23 Aug 2019 02:52:55 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Fri, 23 Aug
 2019 02:52:54 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server id 15.0.1367.3 via Frontend
 Transport; Fri, 23 Aug 2019 02:52:54 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 22EF63F703F;
        Fri, 23 Aug 2019 02:52:54 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id x7N9qrb5007877;
        Fri, 23 Aug 2019 02:52:54 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id x7N9qrv6007876;
        Fri, 23 Aug 2019 02:52:53 -0700
From:   Saurav Kashyap <skashyap@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <gbasrur@marvell.com>, <svernekar@marvell.com>,
        <linux-scsi@vger.kernel.org>
Subject: [PATCH 03/14] qedf: Fix crash during sg_reset.
Date:   Fri, 23 Aug 2019 02:52:33 -0700
Message-ID: <20190823095244.7830-4-skashyap@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20190823095244.7830-1-skashyap@marvell.com>
References: <20190823095244.7830-1-skashyap@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:5.22.84,1.0.8
 definitions=2019-08-23_03:2019-08-21,2019-08-23 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Arun Easi <aeasi@marvell.com>

Driver was attempting to print cdb[0], which is not set for resets
coming from SCSI ioctls. Check for cmd_len before accessing cmnd.

Crash info:
[84790.864747] BUG: unable to handle kernel NULL pointer dereference at (null)
[84790.864783] IP: qedf_initiate_tmf+0x7a/0x6e0 [qedf]
[84790.865204] Call Trace:
[84790.865246]  scsi_try_target_reset+0x2b/0x90 [scsi_mod]
[84790.865266]  scsi_ioctl_reset+0x20f/0x2a0 [scsi_mod]
[84790.865284]  scsi_ioctl+0x131/0x3a0 [scsi_mod]

Signed-off-by: Arun Easi <aeasi@marvell.com>
Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
---
 drivers/scsi/qedf/qedf_io.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qedf/qedf_io.c b/drivers/scsi/qedf/qedf_io.c
index 5b42892..7377a53 100644
--- a/drivers/scsi/qedf/qedf_io.c
+++ b/drivers/scsi/qedf/qedf_io.c
@@ -2403,8 +2403,8 @@ int qedf_initiate_tmf(struct scsi_cmnd *sc_cmd, u8 tm_flags)
 
 	QEDF_ERR(NULL,
 		 "tm_flags 0x%x sc_cmd %p op = 0x%02x target_id = 0x%x lun=%d\n",
-		 tm_flags, sc_cmd, sc_cmd->cmnd[0], rport->scsi_target_id,
-		 (int)sc_cmd->device->lun);
+		 tm_flags, sc_cmd, sc_cmd->cmd_len ? sc_cmd->cmnd[0] : 0xff,
+		 rport->scsi_target_id, (int)sc_cmd->device->lun);
 
 	if (!rdata || !kref_get_unless_zero(&rdata->kref)) {
 		QEDF_ERR(NULL, "stale rport\n");
-- 
1.8.3.1


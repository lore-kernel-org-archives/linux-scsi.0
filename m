Return-Path: <SRS0=mj/2=4O=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A978DC4BA2D
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Feb 2020 22:40:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7BC6C21D7E
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Feb 2020 22:40:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="gqkJGSiU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727837AbgBZWko (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 26 Feb 2020 17:40:44 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:8612 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727761AbgBZWko (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 26 Feb 2020 17:40:44 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01QMePCK006141;
        Wed, 26 Feb 2020 14:40:41 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=7XqXdHOFMOYTjwlGMDKrNzyYt1zjiGk8OsbBiNGdXB4=;
 b=gqkJGSiUtAADm7k1v88xGP1t57DpaNlhdE38k/68n/cbCQVKO83FazttK+bMi5qxu4ds
 +uZKUDssVy9fBlEX0iOUOedf96Iwx8snFTz3YVdzqtjIAjW7WTymWW5oXgDqduXZT5hK
 LBrGiymboGFZhCt26/WOtvpONsUpaT6FNwm56/4cGlhQKmWrRmmNg4DjSkn5DDeEhKR/
 O6CShr3p9bSRLSW5tfbfgS2KZqH3C5zHSYb4iCtCvbHGM+y7gPHq2Ju+amnuegqTVNpz
 dqT/QmNyQ+FM3dEsBu0NYHhdeTi0WdVgucxLRIwV352ro96G4bjdES3IdVIcUzpLOJ9L fQ== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 2ydchtd6kd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 26 Feb 2020 14:40:41 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 26 Feb
 2020 14:40:39 -0800
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 26 Feb 2020 14:40:39 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 620583F703F;
        Wed, 26 Feb 2020 14:40:39 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 01QMedUm024573;
        Wed, 26 Feb 2020 14:40:39 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 01QMedST024572;
        Wed, 26 Feb 2020 14:40:39 -0800
From:   Himanshu Madhani <hmadhani@marvell.com>
To:     <James.Bottomley@HansenPartnership.com>,
        <martin.petersen@oracle.com>
CC:     <hmadhani@marvell.com>, <linux-scsi@vger.kernel.org>
Subject: [PATCH 05/18] qla2xxx: Improved secure flash support messages
Date:   Wed, 26 Feb 2020 14:40:09 -0800
Message-ID: <20200226224022.24518-6-hmadhani@marvell.com>
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

From: Michael Hernandez <mhernandez@marvell.com>

This patch improved message for Secure Flash support.
No functionality has been changed.

Signed-off-by: Michael Hernandez <mhernandez@marvell.com>
Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
---
 drivers/scsi/qla2xxx/qla_init.c |  6 +++---
 drivers/scsi/qla2xxx/qla_mbx.c  | 10 ++++++----
 2 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index f1793d768c07..b440a4fdba36 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -2219,10 +2219,10 @@ qla2x00_initialize_adapter(scsi_qla_host_t *vha)
 
 	/* Check for secure flash support */
 	if (IS_QLA28XX(ha)) {
-		if (RD_REG_DWORD(&reg->mailbox12) & BIT_0) {
-			ql_log(ql_log_info, vha, 0xffff, "Adapter is Secure\n");
+		if (RD_REG_DWORD(&reg->mailbox12) & BIT_0)
 			ha->flags.secure_adapter = 1;
-		}
+		ql_log(ql_log_info, vha, 0xffff, "Secure Adapter: %s\n",
+		    (ha->flags.secure_adapter) ? "Yes" : "No");
 	}
 
 
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 3bb6ab6f254a..d0297bc4fe0d 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -1136,11 +1136,13 @@ qla2x00_get_fw_version(scsi_qla_host_t *vha)
 		ha->fw_ddr_ram_start = (mcp->mb[23] << 16) | mcp->mb[22];
 		ha->fw_ddr_ram_end = (mcp->mb[25] << 16) | mcp->mb[24];
 		if (IS_QLA28XX(ha)) {
-			if (mcp->mb[16] & BIT_10) {
-				ql_log(ql_log_info, vha, 0xffff,
-				    "FW support secure flash updates\n");
+			if (mcp->mb[16] & BIT_10)
 				ha->flags.secure_fw = 1;
-			}
+
+			ql_log(ql_log_info, vha, 0xffff,
+			    "Secure Flash Update in FW: %s\n",
+			    (ha->flags.secure_fw) ? "Supported" :
+			    "Not Supported");
 		}
 	}
 
-- 
2.12.0


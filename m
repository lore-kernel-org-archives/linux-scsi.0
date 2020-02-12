Return-Path: <SRS0=6k2I=4A=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86021C352A4
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Feb 2020 21:44:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 58A5324671
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Feb 2020 21:44:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="WWw9BDTZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729054AbgBLVoy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 Feb 2020 16:44:54 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:59414 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728185AbgBLVox (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 12 Feb 2020 16:44:53 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01CLeYH3001619;
        Wed, 12 Feb 2020 13:44:51 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=VxkGSY9wk2zxgvFBrgTGX/J1PhZ57hA/in/KR4y/EXg=;
 b=WWw9BDTZL0kCeZrGpsp8aUavHEy41KSdR8VsCDZXP7vZVSFiUGLjEtXwYbF4h7zMDf/d
 8F0D0Q3Ta31N78lfRpWJDttWsulNWYy3WiLmUs+4/0mwRdJ1rVvnMZ/ktOblvwvo1Jxo
 PwmMgl7bcJAcoHcVnTnwbCNb0CdPM7Kc46m/uCUvDmjHYnXp+XSeBAU7eYDE9HUjEdwK
 MG2/ZoLVkKCrWP20Mi5ot77rRtnKvWSlMVRXuWkhGcwEAUOPNMpbEO7KGzxvWAwVE2+Q
 BC8Zfq7MOCf6kqWKyiBppXTxdCkF6dUyeD6FDmMh+9OwY7GtXtcFHLOlCLEKOAhWrL+D 4w== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 2y4j5jt4us-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 12 Feb 2020 13:44:51 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 12 Feb
 2020 13:44:50 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 12 Feb
 2020 13:44:49 -0800
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 12 Feb 2020 13:44:49 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 2E2C03F703F;
        Wed, 12 Feb 2020 13:44:49 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 01CLinKf025584;
        Wed, 12 Feb 2020 13:44:49 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 01CLinpU025583;
        Wed, 12 Feb 2020 13:44:49 -0800
From:   Himanshu Madhani <hmadhani@marvell.com>
To:     <James.Bottomley@HansenPartnership.com>,
        <martin.petersen@oracle.com>
CC:     <hmadhani@marvell.com>, <linux-scsi@vger.kernel.org>
Subject: [PATCH 04/25] qla2xxx: Remove all DIX-0 references
Date:   Wed, 12 Feb 2020 13:44:15 -0800
Message-ID: <20200212214436.25532-5-hmadhani@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20200212214436.25532-1-hmadhani@marvell.com>
References: <20200212214436.25532-1-hmadhani@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-12_10:2020-02-12,2020-02-12 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Anil Gurumurthy <anil.gurumurthy@qlogic.com>

This patch removes DIX-0 refrence from the source
as its not used anymore and should not be allowed
as supported option.

Signed-off-by: Anil Gurumurthy <anil.gurumurthy@qlogic.com>
Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
---
 drivers/scsi/qla2xxx/qla_attr.c | 3 +--
 drivers/scsi/qla2xxx/qla_def.h  | 1 -
 drivers/scsi/qla2xxx/qla_os.c   | 4 +---
 3 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index de1930cd53fb..becde75d0fbc 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -2942,8 +2942,7 @@ qla24xx_vport_create(struct fc_vport *fc_vport, bool disable)
 
 			guard = SHOST_DIX_GUARD_CRC;
 
-			if (IS_PI_IPGUARD_CAPABLE(ha) &&
-			    (ql2xenabledif > 1 || IS_PI_DIFB_DIX0_CAPABLE(ha)))
+			if (IS_PI_IPGUARD_CAPABLE(ha) && ql2xenabledif)
 				guard |= SHOST_DIX_GUARD_IP;
 
 			scsi_host_set_guard(vha->host, guard);
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 22f859bef778..063ba73c7372 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -3906,7 +3906,6 @@ struct qla_hw_data {
 				((ha)->fw_attributes_ext[0] & BIT_0))
 #define IS_PI_UNINIT_CAPABLE(ha)	(IS_QLA83XX(ha) || IS_QLA27XX(ha))
 #define IS_PI_IPGUARD_CAPABLE(ha)	(IS_QLA83XX(ha) || IS_QLA27XX(ha))
-#define IS_PI_DIFB_DIX0_CAPABLE(ha)	(0)
 #define IS_PI_SPLIT_DET_CAPABLE_HBA(ha)	(IS_QLA83XX(ha) || IS_QLA27XX(ha) || \
 					IS_QLA28XX(ha))
 #define IS_PI_SPLIT_DET_CAPABLE(ha)	(IS_PI_SPLIT_DET_CAPABLE_HBA(ha) && \
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 79387ac8936f..7f8b5ab0c4c4 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -132,7 +132,6 @@ MODULE_PARM_DESC(ql2xenabledif,
 		" Enable T10-CRC-DIF:\n"
 		" Default is 2.\n"
 		"  0 -- No DIF Support\n"
-		"  1 -- Enable DIF for all types\n"
 		"  2 -- Enable DIF for all types, except Type 0.\n");
 
 #if (IS_ENABLED(CONFIG_NVME_FC))
@@ -3370,8 +3369,7 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 
 			guard = SHOST_DIX_GUARD_CRC;
 
-			if (IS_PI_IPGUARD_CAPABLE(ha) &&
-			    (ql2xenabledif > 1 || IS_PI_DIFB_DIX0_CAPABLE(ha)))
+			if (IS_PI_IPGUARD_CAPABLE(ha) && ql2xenabledif)
 				guard |= SHOST_DIX_GUARD_IP;
 
 			if (ql2xprotguard)
-- 
2.12.0


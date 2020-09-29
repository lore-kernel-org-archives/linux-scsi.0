Return-Path: <SRS0=Opo1=DG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEC86C4346E
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Sep 2020 10:23:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7A101208FE
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Sep 2020 10:23:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="VowAp4e5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725826AbgI2KXb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 29 Sep 2020 06:23:31 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:46596 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725372AbgI2KXb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 29 Sep 2020 06:23:31 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08TALrSg005982
        for <linux-scsi@vger.kernel.org>; Tue, 29 Sep 2020 03:23:29 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=n33VcpdG/yDAZCXJpa84CiLvt1EztZ7EKH6PWWKKzLc=;
 b=VowAp4e5XN05qz3s/0B8DAwaPmqJP1xlFl5xJSnupjfBfuw9px/AYD0P6A60oepNDh8x
 VbN1Y8rfERS/KJCnb3Bsh77I0C6fWLLUEUP+OcIrTkXB85Qb0sN82A+Ra3fUFg919X5G
 BxqJPzJ1zBpSgsVpGaOstCrPQeJFh2h+6GN/XBwbzyA+NsCJejYgV2K5Unkl67AVPVx7
 ev7OszCDE7Cyxop4NE1HwVb0N0qfsRkc0M8ly0+aFkkMoXK3yQuPMA6o/SC6V3Hi+esL
 fcrmk/mtXXB/yiZWtg1EFnFMv3OVWL7GF+eJZuFCNJA/3rvKpdfPnrPuBQBdz6BeW3yf zw== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 33t55p5g23-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 29 Sep 2020 03:23:29 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 29 Sep
 2020 03:23:28 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 29 Sep 2020 03:23:28 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id C72E93F703F;
        Tue, 29 Sep 2020 03:23:28 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 08TANSgt032341;
        Tue, 29 Sep 2020 03:23:28 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 08TANSoJ032332;
        Tue, 29 Sep 2020 03:23:28 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH v2 3/7] qla2xxx: Fix MPI reset needed message
Date:   Tue, 29 Sep 2020 03:21:48 -0700
Message-ID: <20200929102152.32278-4-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20200929102152.32278-1-njavali@marvell.com>
References: <20200929102152.32278-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-29_01:2020-09-29,2020-09-29 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Arun Easi <aeasi@marvell.com>

When printing the message:
"MPI Heartbeat stop. MPI reset is not needed.."

..the wrong register was checked leading to always printing that MPI reset
is not needed, even when it is needed.
Fix the MPI reset message.

Fixes: cbb01c2f2f630 ("scsi: qla2xxx: Fix MPI failure AEN (8200) handling")
Cc: stable@vger.kernel.org
Signed-off-by: Arun Easi <aeasi@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
---
 drivers/scsi/qla2xxx/qla_isr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index bb3beaa77d39..27c2a89bd2ff 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -767,7 +767,7 @@ qla27xx_handle_8200_aen(scsi_qla_host_t *vha, uint16_t *mb)
 	ql_log(ql_log_warn, vha, 0x02f0,
 	       "MPI Heartbeat stop. MPI reset is%s needed. "
 	       "MB0[%xh] MB1[%xh] MB2[%xh] MB3[%xh]\n",
-	       mb[0] & BIT_8 ? "" : " not",
+	       mb[1] & BIT_8 ? "" : " not",
 	       mb[0], mb[1], mb[2], mb[3]);
 
 	if ((mb[1] & BIT_8) == 0)
-- 
2.19.0.rc0


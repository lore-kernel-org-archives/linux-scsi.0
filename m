Return-Path: <SRS0=6k2I=4A=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 273BCC352A4
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Feb 2020 21:47:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F10E821734
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Feb 2020 21:47:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="dfvi/aHs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729128AbgBLVre (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 Feb 2020 16:47:34 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:30186 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728185AbgBLVre (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 12 Feb 2020 16:47:34 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01CLeuJp001683;
        Wed, 12 Feb 2020 13:45:33 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=M98g8ufdykvz7Drx04xMl1EjmzfFGfjWgpjXQ/IEd30=;
 b=dfvi/aHsw+uZ+p88bmjuN8NZ60VAHOmpU7to2EgFpQCF/aCM0Tw34KWZ+tNrEFmw/A15
 KOCuiZh6B8gJN9wpnGI1Zhbafa19QLjA1vDcmNAabnaw6JMpCJ0cNFYWT0f2bB0ijBEz
 l5TqnRlzPjmBnz4GGJTd8Et0hNrth8zS515ysRZo8r64uZc7npSXXmMDuNqadXRzuwWp
 P7cRJEzXqLGTA2qSXTT56B6H+6g6/TVOLi91VYG37su190aOVsARWen+ikecWdREpGJ0
 Ba1vVqyAHg7AqBhxk/gzXYH6eh5gOSZoJ95kku6vjM2NpjxO/eUJHMVjwBRaB4mOLewd Gg== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0b-0016f401.pphosted.com with ESMTP id 2y4j5jt50x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 12 Feb 2020 13:45:33 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 12 Feb
 2020 13:45:31 -0800
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 12 Feb 2020 13:45:31 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 6E7A33F703F;
        Wed, 12 Feb 2020 13:45:31 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 01CLjVfG025648;
        Wed, 12 Feb 2020 13:45:31 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 01CLjVDt025647;
        Wed, 12 Feb 2020 13:45:31 -0800
From:   Himanshu Madhani <hmadhani@marvell.com>
To:     <James.Bottomley@HansenPartnership.com>,
        <martin.petersen@oracle.com>
CC:     <hmadhani@marvell.com>, <linux-scsi@vger.kernel.org>
Subject: [PATCH 18/25] qla2xxx: Fix qla2x00_echo_test() based on ISP type
Date:   Wed, 12 Feb 2020 13:44:29 -0800
Message-ID: <20200212214436.25532-19-hmadhani@marvell.com>
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

From: Joe Carnuccio <joe.carnuccio@cavium.com>

Ths patch fixes MBX in-direction for setting right
bits for qla2x00_echo_test()

Signed-off-by: Joe Carnuccio <joe.carnuccio@cavium.com>
Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
---
 drivers/scsi/qla2xxx/qla_mbx.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 9d73ae165a98..c81081c3d9b8 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -5317,10 +5317,11 @@ qla2x00_echo_test(scsi_qla_host_t *vha, struct msg_echo_lb *mreq,
 		mcp->out_mb |= MBX_2;
 
 	mcp->in_mb = MBX_0;
-	if (IS_QLA24XX_TYPE(ha) || IS_QLA25XX(ha) ||
-	    IS_CNA_CAPABLE(ha) || IS_QLA2031(ha))
+	if (IS_CNA_CAPABLE(ha) || IS_QLA24XX_TYPE(ha) || IS_QLA25XX(ha) ||
+	    IS_QLA2031(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha))
 		mcp->in_mb |= MBX_1;
-	if (IS_CNA_CAPABLE(ha) || IS_QLA2031(ha))
+	if (IS_CNA_CAPABLE(ha) || IS_QLA2031(ha) || IS_QLA27XX(ha) ||
+	    IS_QLA28XX(ha))
 		mcp->in_mb |= MBX_3;
 
 	mcp->tov = MBX_TOV_SECONDS;
-- 
2.12.0


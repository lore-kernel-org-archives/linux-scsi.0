Return-Path: <SRS0=JIM3=DF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2E01C4741F
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Sep 2020 05:53:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9A12C207E8
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Sep 2020 05:53:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="YhhFwhEM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726583AbgI1Fxk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 28 Sep 2020 01:53:40 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:44840 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726504AbgI1Fxj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 28 Sep 2020 01:53:39 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08S5o5au022900
        for <linux-scsi@vger.kernel.org>; Sun, 27 Sep 2020 22:53:38 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=ea0ZUIGk9AD+J2NWFawoOhIQbobwVK5RaDukmOs+Fow=;
 b=YhhFwhEMM2OY5BLBaMiWltZrCLrFRpiVmQwprAsGRFhiSatRzz5ph3Fon+ud45c1z3SX
 k/FNOoMwRYPnzGDfQSGFhaNY9kqTxPBWEHj18M4O+YwqOhbvPS53GAcZ5oDkDFgvOQTh
 dF7Uprf7ACkSRpE/zWDq/HGvcWY5AenNFWkNTUGxf23aspEjedcMnG+bWI8/ssu2kglS
 9IX1yL4Sc3O5IH3MIb9Q0qUAAeraVePtRUgFfLUfQxyXbdt/XyjuAH4uEPv0LTPgIJIP
 RLbwsXlWz1EbPGF3vZOXLWQvoO/LH6rlGmrjLMZZbE75zVmrxR9ruoHkFynwVsdl7z1/ CA== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 33t55nyxe8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Sun, 27 Sep 2020 22:53:38 -0700
Received: from SC-EXCH04.marvell.com (10.93.176.84) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 27 Sep
 2020 22:53:37 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 27 Sep
 2020 22:53:36 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 27 Sep 2020 22:53:36 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id D07E53F703F;
        Sun, 27 Sep 2020 22:53:36 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 08S5rasE004037;
        Sun, 27 Sep 2020 22:53:36 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 08S5raQR004036;
        Sun, 27 Sep 2020 22:53:36 -0700
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH 7/7] qla2xxx: Update version to 10.02.00.103-k
Date:   Sun, 27 Sep 2020 22:50:23 -0700
Message-ID: <20200928055023.3950-8-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20200928055023.3950-1-njavali@marvell.com>
References: <20200928055023.3950-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-28_05:2020-09-24,2020-09-28 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_version.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_version.h b/drivers/scsi/qla2xxx/qla_version.h
index 0f5a5f17dcef..120e511d2ed5 100644
--- a/drivers/scsi/qla2xxx/qla_version.h
+++ b/drivers/scsi/qla2xxx/qla_version.h
@@ -7,9 +7,9 @@
 /*
  * Driver version
  */
-#define QLA2XXX_VERSION      "10.02.00.102-k"
+#define QLA2XXX_VERSION      "10.02.00.103-k"
 
 #define QLA_DRIVER_MAJOR_VER	10
 #define QLA_DRIVER_MINOR_VER	2
 #define QLA_DRIVER_PATCH_VER	0
-#define QLA_DRIVER_BETA_VER	102
+#define QLA_DRIVER_BETA_VER	103
-- 
2.19.0.rc0


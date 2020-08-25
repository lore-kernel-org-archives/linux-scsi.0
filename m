Return-Path: <SRS0=BOoC=CD=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0213C433E3
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Aug 2020 06:44:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD5BD2071E
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Aug 2020 06:44:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="b35IFPV1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729076AbgHYGoq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 Aug 2020 02:44:46 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:45914 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729137AbgHYGoo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 25 Aug 2020 02:44:44 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07P6Utop031823
        for <linux-scsi@vger.kernel.org>; Mon, 24 Aug 2020 23:44:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=+5QyD6UCD7Dr3XqQw3z+Fl6NEiZv3z/ZToe9msndXD4=;
 b=b35IFPV12gy1OU4kEFCtMmlP/5eTp6GJ/LkuMST/XJ5/hUDiF1HDtczI7EU7ov4G78tf
 cwYP1LKFTANx7XpGuxb5xKS36vHysTcEbP7Ap7jzyAqpCdVfzfFGWswV6+DdbD8e/kf+
 Ao8bTSamEgWqFVqow9J4+RL96DMWcE2JagQ3ARI3AUPcKzSTr+jR/pQ+SsRLRE+L09Jg
 YIN1UHyvchsrMiO/6a2kieJ5PPtmslloVsrr+bFeTu01DhkL5SeoIIQRsLk7PAeplojc
 ncixoNg6J4sfw0yCHWgM4Efuo6BqFOqd7U0z249sPTzGsqTiTLa4v9Zaogaku4t/VW9d Rg== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 3330qpjuap-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 24 Aug 2020 23:44:43 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 24 Aug
 2020 23:44:42 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 24 Aug 2020 23:44:42 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 991EE3F703F;
        Mon, 24 Aug 2020 23:44:42 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 07P6igQa016410;
        Mon, 24 Aug 2020 23:44:42 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 07P6igOl016407;
        Mon, 24 Aug 2020 23:44:42 -0700
From:   Javed Hasan <jhasan@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <jhasan@marvell.com>
Subject: [PATCH 1/8] qedf: Changed the debug parameter permission from read to read & write.
Date:   Mon, 24 Aug 2020 23:43:47 -0700
Message-ID: <20200825064354.16361-2-jhasan@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20200825064354.16361-1-jhasan@marvell.com>
References: <20200825064354.16361-1-jhasan@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-24_12:2020-08-24,2020-08-24 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

 -Changed the debug parameter permission from read to
   read & write.


Signed-off-by: Javed Hasan <jhasan@marvell.com>
---
 drivers/scsi/qedf/qedf_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index 86b9479..5770692 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -40,7 +40,7 @@
 	"remote ports (default 60)");
 
 uint qedf_debug = QEDF_LOG_INFO;
-module_param_named(debug, qedf_debug, uint, S_IRUGO);
+module_param_named(debug, qedf_debug, uint, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(debug, " Debug mask. Pass '1' to enable default debugging"
 	" mask");
 
-- 
1.8.3.1


Return-Path: <SRS0=wipa=CQ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7E63C43461
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Sep 2020 17:49:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8B90B206E7
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Sep 2020 17:49:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="Zm2yv/u0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729285AbgIGMQ7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Sep 2020 08:16:59 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:40474 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729183AbgIGMPl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Sep 2020 08:15:41 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 087C4vR5017293
        for <linux-scsi@vger.kernel.org>; Mon, 7 Sep 2020 05:15:35 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=Emj55TWu8GdSl8Gl32qzKBMqEHxBXFQDEQsnur2quMQ=;
 b=Zm2yv/u0pzCLfU46AEMIkPsaYHa707j/EiDVMLz9BIGC3MjIT7HreoBv2W7FpfQIkbs9
 8PHu4wt6xCVKsLz2MU/E3k+PkTPsp9UVVL2cIYwtGjnoozVSABiTFEv2FrsPxtPGkEKf
 5D607qVeIzXxmv98phuu7BUfrjzcEDm4GnZmpQzla/fzLKW/C1qtLH/l/FWPl1v6iaxe
 eaSKf6Fw2dx8jFBSFbBsi2K/HQoOsqbItoM4m7CGqBXt9egte8DLBpmpBBYlM7ezPJFC
 Q0cCMhgJu6vonJTIswyIe2MJaODv8hd9izL4oYjtYY1NuDc4eMSJZcvLheT2+dnhjauj yw== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 33ccvqxn9m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 07 Sep 2020 05:15:34 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 7 Sep
 2020 05:15:33 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 7 Sep
 2020 05:15:32 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 7 Sep 2020 05:15:32 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 115383F703F;
        Mon,  7 Sep 2020 05:15:32 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 087CFV02005198;
        Mon, 7 Sep 2020 05:15:31 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 087CFV10005197;
        Mon, 7 Sep 2020 05:15:31 -0700
From:   Javed Hasan <jhasan@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <jhasan@marvell.com>
Subject: [PATCH 1/8] qedf: Changed the debug parameter permission to read & write
Date:   Mon, 7 Sep 2020 05:14:36 -0700
Message-ID: <20200907121443.5150-2-jhasan@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20200907121443.5150-1-jhasan@marvell.com>
References: <20200907121443.5150-1-jhasan@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-07_06:2020-09-07,2020-09-07 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

 Changed the debug parameter permission to read & write.
 Gives flexibility to change the debug verbosity dynamically.

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


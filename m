Return-Path: <SRS0=r6FR=ZK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62961C432C0
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Nov 2019 03:54:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3AE46206B6
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Nov 2019 03:54:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="fngapajs";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="UpjnFmxn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726721AbfKRDyz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 17 Nov 2019 22:54:55 -0500
Received: from a27-187.smtp-out.us-west-2.amazonses.com ([54.240.27.187]:55150
        "EHLO a27-187.smtp-out.us-west-2.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726266AbfKRDyz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 17 Nov 2019 22:54:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=zsmsymrwgfyinv5wlfyidntwsjeeldzt; d=codeaurora.org; t=1574049294;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References;
        bh=yS7tcmi0zJKos+vnngJjKR10cU5qpZky+FIWMuq11SM=;
        b=fngapajs2SGLpSvRU/vxAwBWdLaLM0xvfqfNyUIbqhSOBnGpru7zMxJ+xLEaSlqK
        IIvIRhT8YvKyTSk+wOTOG5N6ZwTSrUliz0+UCh0Cl5UH5rpNgU10PNL5CcJs0u32Y3D
        SldQ8WLtU6GVJ0BOegXp4aCMSeKGjnL35uc3KF+w=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=gdwg2y3kokkkj5a55z2ilkup5wp5hhxx; d=amazonses.com; t=1574049294;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:Feedback-ID;
        bh=yS7tcmi0zJKos+vnngJjKR10cU5qpZky+FIWMuq11SM=;
        b=UpjnFmxnDqVU3Xn8fGN2q4tXWFvJlIS39fT58Dissnv+MZopdtvaYRbjG4pVC/fs
        t8IZpiOQ14MrRMEJAs3d4e+07uUT4yvRS3MbUQVGTZbE5aSYmziaNpF4Bjm8lnGOisu
        boMMV64ozgEGYepvuCMOotxtrdfDaZAt5Ac0dhIs=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 45A03C43383
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=cang@codeaurora.org
From:   Can Guo <cang@codeaurora.org>
To:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com,
        cang@codeaurora.org
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Tomas Winkler <tomas.winkler@intel.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2 2/4] scsi: ufs: Update VCCQ2 and VCCQ min/max voltage hard codes
Date:   Mon, 18 Nov 2019 03:54:54 +0000
Message-ID: <0101016e7ca62853-73f33b23-b1d4-4f2e-aec1-e6aa9cd34dfe-000000@us-west-2.amazonses.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1574049277-13477-1-git-send-email-cang@codeaurora.org>
References: <1574049277-13477-1-git-send-email-cang@codeaurora.org>
X-SES-Outgoing: 2019.11.18-54.240.27.187
Feedback-ID: 1.us-west-2.CZuq2qbDmUIuT3qdvXlRHZZCpfZqZ4GtG9v3VKgRyF0=:AmazonSES
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Per UFS 3.0 JEDEC standard, the VCCQ2 min voltage is 1.7v and the VCCQ
voltage range is 1.14v ~ 1.26v. Update their hard codes accordingly to
make sure they work in a safe range compliant for ver 1.0/2.0/2.1/3.0
UFS devices.

Signed-off-by: Can Guo <cang@codeaurora.org>
---
 drivers/scsi/ufs/ufs.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
index 385bac8..9df4f4d 100644
--- a/drivers/scsi/ufs/ufs.h
+++ b/drivers/scsi/ufs/ufs.h
@@ -500,9 +500,9 @@ struct ufs_query_res {
 #define UFS_VREG_VCC_MAX_UV	   3600000 /* uV */
 #define UFS_VREG_VCC_1P8_MIN_UV    1700000 /* uV */
 #define UFS_VREG_VCC_1P8_MAX_UV    1950000 /* uV */
-#define UFS_VREG_VCCQ_MIN_UV	   1100000 /* uV */
+#define UFS_VREG_VCCQ_MIN_UV	   1140000 /* uV */
 #define UFS_VREG_VCCQ_MAX_UV	   1300000 /* uV */
-#define UFS_VREG_VCCQ2_MIN_UV	   1650000 /* uV */
+#define UFS_VREG_VCCQ2_MIN_UV	   1700000 /* uV */
 #define UFS_VREG_VCCQ2_MAX_UV	   1950000 /* uV */
 
 /*
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project


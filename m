Return-Path: <SRS0=v3DL=ZS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46A92C432C0
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Nov 2019 06:54:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2A7EE20727
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Nov 2019 06:54:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727217AbfKZGx7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Nov 2019 01:53:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:43328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725765AbfKZGx6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 26 Nov 2019 01:53:58 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id C6662C447BD; Tue, 26 Nov 2019 06:53:57 +0000 (UTC)
Received: from pacamara-linux.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 6A8A3C447B8;
        Tue, 26 Nov 2019 06:53:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 6A8A3C447B8
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=pass (p=none dis=none) header.from=qti.qualcomm.com
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=pass smtp.mailfrom=cang@qti.qualcomm.com
From:   Can Guo <cang@qti.qualcomm.com>
To:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com,
        cang@codeaurora.org
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v3 2/4] scsi: ufs: Update VCCQ2 and VCCQ min/max voltage hard codes
Date:   Mon, 25 Nov 2019 22:53:31 -0800
Message-Id: <1574751214-8321-3-git-send-email-cang@qti.qualcomm.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1574751214-8321-1-git-send-email-cang@qti.qualcomm.com>
References: <1574751214-8321-1-git-send-email-cang@qti.qualcomm.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Can Guo <cang@codeaurora.org>

Per UFS 3.0 JEDEC standard, the VCCQ2 min voltage is 1.7v and the VCCQ
voltage range is 1.14v ~ 1.26v. Update their hard codes accordingly to
make sure they work in a safe range compliant for ver 1.0/1.1/2.0/2.1/3.0
UFS devices.

Signed-off-by: Can Guo <cang@codeaurora.org>
---
 drivers/scsi/ufs/ufs.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
index 385bac8..0ded95e 100644
--- a/drivers/scsi/ufs/ufs.h
+++ b/drivers/scsi/ufs/ufs.h
@@ -500,9 +500,9 @@ struct ufs_query_res {
 #define UFS_VREG_VCC_MAX_UV	   3600000 /* uV */
 #define UFS_VREG_VCC_1P8_MIN_UV    1700000 /* uV */
 #define UFS_VREG_VCC_1P8_MAX_UV    1950000 /* uV */
-#define UFS_VREG_VCCQ_MIN_UV	   1100000 /* uV */
-#define UFS_VREG_VCCQ_MAX_UV	   1300000 /* uV */
-#define UFS_VREG_VCCQ2_MIN_UV	   1650000 /* uV */
+#define UFS_VREG_VCCQ_MIN_UV	   1140000 /* uV */
+#define UFS_VREG_VCCQ_MAX_UV	   1260000 /* uV */
+#define UFS_VREG_VCCQ2_MIN_UV	   1700000 /* uV */
 #define UFS_VREG_VCCQ2_MAX_UV	   1950000 /* uV */
 
 /*
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project


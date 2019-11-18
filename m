Return-Path: <SRS0=r6FR=ZK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB71AC432C0
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Nov 2019 03:51:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BD34C2071E
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Nov 2019 03:51:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726621AbfKRDvS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 17 Nov 2019 22:51:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:53088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726266AbfKRDvS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 17 Nov 2019 22:51:18 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id F3386C447B4; Mon, 18 Nov 2019 03:51:17 +0000 (UTC)
Received: from pacamara-linux.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id C4C1EC447B0;
        Mon, 18 Nov 2019 03:51:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org C4C1EC447B0
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
        Stanley Chu <stanley.chu@mediatek.com>,
        Tomas Winkler <tomas.winkler@intel.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2 2/4] scsi: ufs: Update VCCQ2 and VCCQ min/max voltage hard codes
Date:   Sun, 17 Nov 2019 19:50:58 -0800
Message-Id: <1574049061-11417-3-git-send-email-cang@qti.qualcomm.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1574049061-11417-1-git-send-email-cang@qti.qualcomm.com>
References: <1574049061-11417-1-git-send-email-cang@qti.qualcomm.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Can Guo <cang@codeaurora.org>

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


Return-Path: <SRS0=OHhN=ZA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A7D3C5DF60
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Nov 2019 08:16:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6FB7B21D6C
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Nov 2019 08:16:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="W7tMygJM";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="mnOdZFe1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730553AbfKHIQI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Nov 2019 03:16:08 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:49870 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729873AbfKHIQH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Nov 2019 03:16:07 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 6E26F60F5E; Fri,  8 Nov 2019 08:16:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1573200967;
        bh=/6MGWDPZHo0XAVvtZ763ks6PHCdXkReKGAgOGLAcvVo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W7tMygJMSxI+mYlFb8QlTOSlwcytK10CthljljWsECEADlNBA5KqUq7hrchm4D9kK
         O1Xj3JdoarBecX00QfG73kTkeNYwd99P2pV1SrZwCq/lVjhl+lvZ8EYdTU6TxwwaTq
         VApY4XPfTgd6Ye/k01H2WfmDIk4LHC52b2IxXQQI=
Received: from pacamara-linux.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: cang@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 1C82660D46;
        Fri,  8 Nov 2019 08:16:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1573200964;
        bh=/6MGWDPZHo0XAVvtZ763ks6PHCdXkReKGAgOGLAcvVo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mnOdZFe1iNS8xeQlMW9hiMRc81lQZ9CDARqGa5Vt6kBpgF9ST0wlojIXGrZCIEuGh
         MhvUBlJqcZ3wYdOOd8q+mvGzXrDfCLhcKfJAoBwSacNXDNq02A9pAlDQaj+XMqj0I2
         x6DdxE35BRlq3j/hy5TRrPvwFK4LRzm0+9PfQtPs=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 1C82660D46
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=cang@codeaurora.org
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
        Tomas Winkler <tomas.winkler@intel.com>,
        Subhash Jadavani <subhashj@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v1 3/5] scsi: ufs: Update VCCQ2 and VCCQ min voltage hard codes
Date:   Fri,  8 Nov 2019 00:15:29 -0800
Message-Id: <1573200932-384-4-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1573200932-384-1-git-send-email-cang@codeaurora.org>
References: <1573200932-384-1-git-send-email-cang@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Per UFS 3.0 JEDEC standard, the VCCQ2 min voltage is 1.7v and the VCCQ min
voltage is 1.14v, update their hard codes accordingly.

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


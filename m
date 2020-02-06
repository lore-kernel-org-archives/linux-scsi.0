Return-Path: <SRS0=lyXb=32=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CDDAC2D0B1
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Feb 2020 08:22:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4F71A217BA
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Feb 2020 08:22:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="xRDgK4KJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727826AbgBFIWN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 6 Feb 2020 03:22:13 -0500
Received: from mail26.static.mailgun.info ([104.130.122.26]:43738 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726673AbgBFIWN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Feb 2020 03:22:13 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1580977333; h=Message-Id: Date: Subject: Cc: To: From:
 Sender; bh=uocbTJhDPsW4enmeP/qChZAINPxWnPLpniJ6nWtfYH0=; b=xRDgK4KJlYU4VauWAzumvLvnw8VBFIWdupBPEdcSTXHuK6XfuUsYRCfHh8lNaRBTA7ibddY1
 MPM7dqdmGTmr0UILa+poSQTAfVzzIRCExSC4EsocUImgECeifqusbV/J3R9Amvol+Q/EsGg8
 ONBGbrLaPKrjTTZDwTi0TKDjctM=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e3bccb0.7f6a03e14e30-smtp-out-n03;
 Thu, 06 Feb 2020 08:22:08 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id A059CC447A3; Thu,  6 Feb 2020 08:22:06 +0000 (UTC)
Received: from pacamara-linux.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 1A17BC433CB;
        Thu,  6 Feb 2020 08:22:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 1A17BC433CB
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=cang@codeaurora.org
From:   Can Guo <cang@codeaurora.org>
To:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, rnayak@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        saravanak@google.com, salyzyn@google.com, cang@codeaurora.org
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Venkat Gopalakrishnan <venkatg@codeaurora.org>,
        Tomas Winkler <tomas.winkler@intel.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] scsi: ufs: Enable HOST_PA_TACTIVATE quirk for WDC UFS devices
Date:   Thu,  6 Feb 2020 00:21:50 -0800
Message-Id: <1580977315-19321-1-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Western Digital UFS devices require host PA_TACTIVATE to be lower than
device PA_TACTIVATE, otherwise it may get stuck during hibern8 sequence.

Signed-off-by: Can Guo <cang@codeaurora.org>

diff --git a/drivers/scsi/ufs/ufs_quirks.h b/drivers/scsi/ufs/ufs_quirks.h
index d0ab147..df7a1e6 100644
--- a/drivers/scsi/ufs/ufs_quirks.h
+++ b/drivers/scsi/ufs/ufs_quirks.h
@@ -15,6 +15,7 @@
 #define UFS_VENDOR_TOSHIBA     0x198
 #define UFS_VENDOR_SAMSUNG     0x1CE
 #define UFS_VENDOR_SKHYNIX     0x1AD
+#define UFS_VENDOR_WDC         0x145
 
 /**
  * ufs_dev_fix - ufs device quirk info
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 1fe0a97..a066f00 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -239,6 +239,8 @@ struct ufs_pm_lvl_states ufs_pm_lvl_states[] = {
 		UFS_DEVICE_QUIRK_HOST_PA_SAVECONFIGTIME),
 	UFS_FIX(UFS_VENDOR_SKHYNIX, "hB8aL1" /*H28U62301AMR*/,
 		UFS_DEVICE_QUIRK_HOST_VS_DEBUGSAVECONFIGTIME),
+	UFS_FIX(UFS_VENDOR_WDC, UFS_ANY_MODEL,
+		UFS_DEVICE_QUIRK_HOST_PA_TACTIVATE),
 
 	END_FIX
 };
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

Return-Path: <SRS0=0hmW=3X=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D5EEC3524D
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Feb 2020 09:18:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2CD3A20842
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Feb 2020 09:18:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="wcPheB0j"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727714AbgBCJSr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 3 Feb 2020 04:18:47 -0500
Received: from mail25.static.mailgun.info ([104.130.122.25]:45948 "EHLO
        mail25.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727902AbgBCJSr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Feb 2020 04:18:47 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1580721527; h=References: In-Reply-To: Message-Id: Date:
 Subject: Cc: To: From: Sender;
 bh=V+8m5T4YfK9wEr3fxSe/8uMdxEMj2GnvJiyPlUOKVy0=; b=wcPheB0jFcC9wnkqLQWrt+dhGslpr+uRbQv0kFRnVW1HwJSiBp8q9csYx1BQl+Pgcc/o5Vi6
 iXW1ZL1fxcHeq4qZrFVGWFZDIaF7L/0LdDv2Hhs4Wj9YX8MfdI12gsqpy/Aw1L5KBRuGBb2e
 lHyN0NszQ//xQEYn0NrdsUrG/Yc=
X-Mailgun-Sending-Ip: 104.130.122.25
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e37e573.7f0d8e32fea0-smtp-out-n03;
 Mon, 03 Feb 2020 09:18:43 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 283DFC447B1; Mon,  3 Feb 2020 09:18:40 +0000 (UTC)
Received: from pacamara-linux.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 2F6A7C447A1;
        Mon,  3 Feb 2020 09:18:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 2F6A7C447A1
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
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Venkat Gopalakrishnan <venkatg@codeaurora.org>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Allison Randal <allison@lohutok.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Pedro Sousa <sousa@synopsys.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v5 8/8] scsi: ufs: Select INITIAL adapt for HS Gear4
Date:   Mon,  3 Feb 2020 01:17:50 -0800
Message-Id: <1580721472-10784-9-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1580721472-10784-1-git-send-email-cang@codeaurora.org>
References: <1580721472-10784-1-git-send-email-cang@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

ADAPT is added specifically for HS Gear4 mode only, select INITIAL adapt
before do power mode change to G4 and select no adapt before switch to
non-G4 modes.

Signed-off-by: Can Guo <cang@codeaurora.org>
Reviewed-by: Asutosh Das <asutoshd@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd.c | 14 +++++++++++++-
 drivers/scsi/ufs/ufshci.h |  1 +
 drivers/scsi/ufs/unipro.h |  7 +++++++
 3 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index d5c547b..0ac5d47 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -4077,6 +4077,17 @@ static int ufshcd_change_power_mode(struct ufs_hba *hba,
 		ufshcd_dme_set(hba, UIC_ARG_MIB(PA_HSSERIES),
 						pwr_mode->hs_rate);
 
+	if (hba->ufs_version >= UFSHCI_VERSION_30) {
+		if (pwr_mode->gear_tx == UFS_HS_G4)
+			/* INITIAL ADAPT */
+			ufshcd_dme_set(hba, UIC_ARG_MIB(PA_TXHSADAPTTYPE),
+					PA_INITIAL_ADAPT);
+		else
+			/* NO ADAPT */
+			ufshcd_dme_set(hba, UIC_ARG_MIB(PA_TXHSADAPTTYPE),
+					PA_NO_ADAPT);
+	}
+
 	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_PWRMODEUSERDATA0),
 			DL_FC0ProtectionTimeOutVal_Default);
 	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_PWRMODEUSERDATA1),
@@ -8455,7 +8466,8 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 	if ((hba->ufs_version != UFSHCI_VERSION_10) &&
 	    (hba->ufs_version != UFSHCI_VERSION_11) &&
 	    (hba->ufs_version != UFSHCI_VERSION_20) &&
-	    (hba->ufs_version != UFSHCI_VERSION_21))
+	    (hba->ufs_version != UFSHCI_VERSION_21) &&
+	    (hba->ufs_version != UFSHCI_VERSION_30))
 		dev_err(hba->dev, "invalid UFS version 0x%x\n",
 			hba->ufs_version);
 
diff --git a/drivers/scsi/ufs/ufshci.h b/drivers/scsi/ufs/ufshci.h
index c2961d3..f2ee816 100644
--- a/drivers/scsi/ufs/ufshci.h
+++ b/drivers/scsi/ufs/ufshci.h
@@ -104,6 +104,7 @@ enum {
 	UFSHCI_VERSION_11 = 0x00010100, /* 1.1 */
 	UFSHCI_VERSION_20 = 0x00000200, /* 2.0 */
 	UFSHCI_VERSION_21 = 0x00000210, /* 2.1 */
+	UFSHCI_VERSION_30 = 0x00000300, /* 3.0 */
 };
 
 /*
diff --git a/drivers/scsi/ufs/unipro.h b/drivers/scsi/ufs/unipro.h
index 3dc4d8b..5a724b2 100644
--- a/drivers/scsi/ufs/unipro.h
+++ b/drivers/scsi/ufs/unipro.h
@@ -146,6 +146,12 @@
 #define PA_SLEEPNOCONFIGTIME	0x15A2
 #define PA_STALLNOCONFIGTIME	0x15A3
 #define PA_SAVECONFIGTIME	0x15A4
+#define PA_TXHSADAPTTYPE	0x15D4
+
+/* Adpat type for PA_TXHSADAPTTYPE attribute */
+#define PA_REFRESH_ADAPT	0x00
+#define PA_INITIAL_ADAPT	0x01
+#define PA_NO_ADAPT		0x03
 
 #define PA_TACTIVATE_TIME_UNIT_US	10
 #define PA_HIBERN8_TIME_UNIT_US		100
@@ -203,6 +209,7 @@ enum ufs_hs_gear_tag {
 	UFS_HS_G1,		/* HS Gear 1 (default for reset) */
 	UFS_HS_G2,		/* HS Gear 2 */
 	UFS_HS_G3,		/* HS Gear 3 */
+	UFS_HS_G4,		/* HS Gear 4 */
 };
 
 enum ufs_unipro_ver {
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

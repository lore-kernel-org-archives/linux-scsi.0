Return-Path: <SRS0=WAUG=ZF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0262BC43331
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Nov 2019 06:00:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C960A222D3
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Nov 2019 06:00:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="ZpmK77HP";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="JgyBd6Nm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726473AbfKMGAy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Nov 2019 01:00:54 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:35992 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725858AbfKMGAx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Nov 2019 01:00:53 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id CFA9460D7C; Wed, 13 Nov 2019 06:00:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1573624852;
        bh=zJ/sdUT9LdfUduAIerBsTnBGlicQBgtK9DzFB+Isqqs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZpmK77HPrgeHQdSNABY2KAPkwN3jGi5VePZanfhgA81QWGnFAyWdhUa1zjp6ms2WA
         61i2eKaOoBfhwK614a5V0wAuD2UyiLvwNHsVCrmoIIIS4vBv8sVC1lYOqDLux1AcQ5
         LWgflp4X00eGezlAMii9B5seiL8Jd/695otmeOdA=
Received: from pacamara-linux.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: cang@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 98FCC60D37;
        Wed, 13 Nov 2019 06:00:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1573624850;
        bh=zJ/sdUT9LdfUduAIerBsTnBGlicQBgtK9DzFB+Isqqs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JgyBd6Nm2mWqVzSwviHmgx1WmWRziSBEIp9WBcDjttf+QZE0vtOMFRQVHBy+toFXH
         yT4Tyw/7ROL6XY1yjVO/wX2q6wogDN3mMIdxnUKzvittfDe8FVD+krdhHmqvTpGJtT
         AOHnrKnggpX2Xcx0wRPAr0j7KWkPVbZW/31tyVSQ=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 98FCC60D37
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
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Allison Randal <allison@lohutok.net>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v4 4/5] scsi: ufs: Do not clear the DL layer timers
Date:   Tue, 12 Nov 2019 22:00:22 -0800
Message-Id: <1573624824-671-5-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1573624824-671-1-git-send-email-cang@codeaurora.org>
References: <1573624824-671-1-git-send-email-cang@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

During power mode change, PACP_PWR_Req frame sends
PAPowerModeUserData parameters (and they are considered valid by device if
Flags[4] - UserDataValid bit is set in the same frame).
Currently we don't set these PAPowerModeUserData parameters and hardware
always sets UserDataValid bit which would clear all the DL layer timeout
values of the peer device after the power mode change.

This change sets the PAPowerModeUserData[0..5] to UniPro specification
recommended default values, in addition we are also setting the relevant
DME_LOCAL_* timer attributes as required by UFS HCI specification.

Signed-off-by: Can Guo <cang@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd.c | 20 ++++++++++++++++++++
 drivers/scsi/ufs/unipro.h | 11 +++++++++++
 2 files changed, 31 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 9e44506..086d359 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -4084,6 +4084,26 @@ static int ufshcd_change_power_mode(struct ufs_hba *hba,
 		ufshcd_dme_set(hba, UIC_ARG_MIB(PA_HSSERIES),
 						pwr_mode->hs_rate);
 
+	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_PWRMODEUSERDATA0),
+			DL_FC0ProtectionTimeOutVal_Default);
+	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_PWRMODEUSERDATA1),
+			DL_TC0ReplayTimeOutVal_Default);
+	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_PWRMODEUSERDATA2),
+			DL_AFC0ReqTimeOutVal_Default);
+	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_PWRMODEUSERDATA3),
+			DL_FC1ProtectionTimeOutVal_Default);
+	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_PWRMODEUSERDATA4),
+			DL_TC1ReplayTimeOutVal_Default);
+	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_PWRMODEUSERDATA5),
+			DL_AFC1ReqTimeOutVal_Default);
+
+	ufshcd_dme_set(hba, UIC_ARG_MIB(DME_LocalFC0ProtectionTimeOutVal),
+			DL_FC0ProtectionTimeOutVal_Default);
+	ufshcd_dme_set(hba, UIC_ARG_MIB(DME_LocalTC0ReplayTimeOutVal),
+			DL_TC0ReplayTimeOutVal_Default);
+	ufshcd_dme_set(hba, UIC_ARG_MIB(DME_LocalAFC0ReqTimeOutVal),
+			DL_AFC0ReqTimeOutVal_Default);
+
 	ret = ufshcd_uic_change_pwr_mode(hba, pwr_mode->pwr_rx << 4
 			| pwr_mode->pwr_tx);
 
diff --git a/drivers/scsi/ufs/unipro.h b/drivers/scsi/ufs/unipro.h
index f539f87..3dc4d8b 100644
--- a/drivers/scsi/ufs/unipro.h
+++ b/drivers/scsi/ufs/unipro.h
@@ -161,6 +161,17 @@
 /* PHY Adapter Protocol Constants */
 #define PA_MAXDATALANES	4
 
+#define DL_FC0ProtectionTimeOutVal_Default	8191
+#define DL_TC0ReplayTimeOutVal_Default		65535
+#define DL_AFC0ReqTimeOutVal_Default		32767
+#define DL_FC1ProtectionTimeOutVal_Default	8191
+#define DL_TC1ReplayTimeOutVal_Default		65535
+#define DL_AFC1ReqTimeOutVal_Default		32767
+
+#define DME_LocalFC0ProtectionTimeOutVal	0xD041
+#define DME_LocalTC0ReplayTimeOutVal		0xD042
+#define DME_LocalAFC0ReqTimeOutVal		0xD043
+
 /* PA power modes */
 enum {
 	FAST_MODE	= 1,
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project


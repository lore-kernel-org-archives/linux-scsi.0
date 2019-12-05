Return-Path: <SRS0=amAE=Z3=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15CA2C43603
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Dec 2019 02:14:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DC40F21823
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Dec 2019 02:14:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="gNZvpa9H";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="RA4m0tCo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728849AbfLECOn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Dec 2019 21:14:43 -0500
Received: from a27-18.smtp-out.us-west-2.amazonses.com ([54.240.27.18]:52482
        "EHLO a27-18.smtp-out.us-west-2.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728393AbfLECOn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Dec 2019 21:14:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=zsmsymrwgfyinv5wlfyidntwsjeeldzt; d=codeaurora.org; t=1575512082;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References;
        bh=3BmlSqDZ/c76uJvMJBqsZlxszKJC6+iSVGfJOfIeKoY=;
        b=gNZvpa9HBN2piPrVw/JA64nrz97xuMpwt2LpDgkW1qRaoHC/wQ/lxp6FAXp5IIBx
        ZrhXfhuc1OpiIUIudcCqLCrKIBO576jIjDma+pv+M67nQYVAhj4EbLbYQX0W/bbOPFo
        2aMvz+ot27DRVYq7umxw5MPlP71Q9AEyD2dT9Y5A=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=gdwg2y3kokkkj5a55z2ilkup5wp5hhxx; d=amazonses.com; t=1575512082;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:Feedback-ID;
        bh=3BmlSqDZ/c76uJvMJBqsZlxszKJC6+iSVGfJOfIeKoY=;
        b=RA4m0tCoarBPcdK1eQGioa4rDrTpO3XVSDBjDRoXlinVbBc7UhsJOcN0RYLYXbnR
        COQqi+LSXqz0HlQznc39953lXv1xNnAMegh4peG1ClIP7/VKX2jGLBLpFTywaCcd+yN
        M/YuspotV/I5z4H4gu+1U4XkgGOQGq9OPpmObTXM=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 16070C64330
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
        Bean Huo <beanhuo@micron.com>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Allison Randal <allison@lohutok.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v6 4/5] scsi: ufs: Do not clear the DL layer timers
Date:   Thu, 5 Dec 2019 02:14:42 +0000
Message-ID: <0101016ed3d688a4-cfaeb1c9-238b-46c4-9c89-d48c410ba325-000000@us-west-2.amazonses.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1575512052-15999-1-git-send-email-cang@codeaurora.org>
References: <1575512052-15999-1-git-send-email-cang@codeaurora.org>
X-SES-Outgoing: 2019.12.05-54.240.27.18
Feedback-ID: 1.us-west-2.CZuq2qbDmUIuT3qdvXlRHZZCpfZqZ4GtG9v3VKgRyF0=:AmazonSES
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
Reviewed-by: Avri Altman <avri.altman@wdc.com>
Reviewed-by: Bean Huo <beanhuo@micron.com>
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


Return-Path: <SRS0=wJ7M=YV=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 176DCCA9EA0
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Oct 2019 03:50:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D651721783
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Oct 2019 03:50:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="n6f+P6jK";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="EvILnX+z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731308AbfJ1Duu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 27 Oct 2019 23:50:50 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:45166 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729328AbfJ1Duu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 27 Oct 2019 23:50:50 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 05D1F607C3; Mon, 28 Oct 2019 03:50:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1572234649;
        bh=2CeJJiynBfiiPtkhT7KuxPuZD1ERpgqHk8mmRQakQ0Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n6f+P6jK/V/8/IbIPvRVa67o6nXGMO7y+RcGl7KVylER+7cd9mE5TCziSw+Y8F0CV
         /hDwylCW7CSVBIjAS5oUwu1/UWiYyXoG9wPjMbpBV1WFi+Osbt/c/7V5zuzqyo9265
         23vmXwPhKirEJ23RGVrw6yQ4g/Euyx2wy5/DdPfk=
Received: from pacamara-linux.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: cang@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 4D7E2602DA;
        Mon, 28 Oct 2019 03:50:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1572234647;
        bh=2CeJJiynBfiiPtkhT7KuxPuZD1ERpgqHk8mmRQakQ0Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EvILnX+zrqGP0AaTtuOzEl+rz/bulC8ONZduPcwlda5OAbMRNZ5tFrdTyZZThAbwj
         STnfsS3sxc9CCUWpDu51VFGeNauaawJZabupDQj8wpTnrxRlLrKU+N3m61Ws1y599C
         lPGmoIKUJ2CaLRSDpgfSkdxnAgV0unSiBvcqmrUc=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 4D7E2602DA
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
        Subhash Jadavani <subhashj@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Allison Randal <allison@lohutok.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v1 4/5] scsi: ufs: Do not clear the DL layer timers
Date:   Sun, 27 Oct 2019 20:50:06 -0700
Message-Id: <1572234608-32654-5-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1572234608-32654-1-git-send-email-cang@codeaurora.org>
References: <1572234608-32654-1-git-send-email-cang@codeaurora.org>
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

Change-Id: I1a8c02832a185dc4ce9043eee6572ddee89bdcdb
Signed-off-by: Can Guo <cang@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd.c | 20 ++++++++++++++++++++
 drivers/scsi/ufs/unipro.h | 11 +++++++++++
 2 files changed, 31 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 6e9236a..34efa8a 100644
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


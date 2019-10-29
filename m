Return-Path: <SRS0=POaH=YW=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE40ACA9EC0
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Oct 2019 03:13:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A855421479
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Oct 2019 03:13:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="aYRbNw7G";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="B4F25mVY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728254AbfJ2DNt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 28 Oct 2019 23:13:49 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:35498 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726464AbfJ2DNt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Oct 2019 23:13:49 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 7C22660D90; Tue, 29 Oct 2019 03:13:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1572318827;
        bh=scuAnT5H3nEdJxrQRggDSKVMJUJJS7VQFEZmMK5pJLE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aYRbNw7GzDyJVFZtUXqxXDE0d8H+D43Xe1rGb3Dm0Zaljoi/VGM0lRW2bUNLcW/3L
         RH/8n1zfsvq3krjFJDO8QqeZ/1VLtvutfnUAPOfxi8jB4yNnquY6nvCJR4uqOVvVSP
         keuummUd7dMFOojKby5vPXID6YbBtyFaRm/wD+go=
Received: from pacamara-linux.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: cang@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id F312C60CDD;
        Tue, 29 Oct 2019 03:13:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1572318825;
        bh=scuAnT5H3nEdJxrQRggDSKVMJUJJS7VQFEZmMK5pJLE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B4F25mVYUQFmzJrCitT2mqxz1WPlQ1YbFP3pylRCDNBa+0wx2zUwElifiq49HLxF6
         cCkNXZelCLy5SiOgMKa61qewwq5FMLzfoXWkMr/RrGtYN4ZsgmQJ5by0edxjLRng05
         M1WVHAEM+rh74dFlv2IdEKaG+6t8X3t7CsBdNOPQ=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org F312C60CDD
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
        Allison Randal <allison@lohutok.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2 4/5] scsi: ufs: Do not clear the DL layer timers
Date:   Mon, 28 Oct 2019 20:10:53 -0700
Message-Id: <1572318655-28772-5-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1572318655-28772-1-git-send-email-cang@codeaurora.org>
References: <1572318655-28772-1-git-send-email-cang@codeaurora.org>
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


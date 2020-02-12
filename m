Return-Path: <SRS0=6k2I=4A=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 345B1C2BA83
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Feb 2020 05:43:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 004AA2073C
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Feb 2020 05:43:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="C/jtI4ck"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726194AbgBLFnz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 Feb 2020 00:43:55 -0500
Received: from mail27.static.mailgun.info ([104.130.122.27]:64893 "EHLO
        mail27.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725601AbgBLFnz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 12 Feb 2020 00:43:55 -0500
X-Greylist: delayed 300 seconds by postgrey-1.27 at vger.kernel.org; Wed, 12 Feb 2020 00:43:54 EST
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1581486234; h=References: In-Reply-To: Message-Id: Date:
 Subject: Cc: To: From: Sender;
 bh=NMBFWs/iu5Xy2+tnmYgtFh5bOJ2ma0Oeqgf2koL0U1Y=; b=C/jtI4ck/lHi+LdYPqvWbUG5fZobVB3BaUIx5EHCcTisOj+Jo4YpyqKNQI26gLOPJwVr0E5n
 QcupE0xbIJZAjWLVIryaSwKJR/jz3RgDHpObO2eRKFeIQCghX3Tx94T5siwC0ldmla1h5JWN
 FZGlkvXl5dT6JKR72Ao+kpPXlUw=
X-Mailgun-Sending-Ip: 104.130.122.27
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e438f6d.7f8efb658228-smtp-out-n03;
 Wed, 12 Feb 2020 05:38:53 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id A0ADDC447A6; Wed, 12 Feb 2020 05:38:51 +0000 (UTC)
Received: from pacamara-linux.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 0E591C43383;
        Wed, 12 Feb 2020 05:38:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 0E591C43383
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=cang@codeaurora.org
From:   Can Guo <cang@codeaurora.org>
To:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, rnayak@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        saravanak@google.com, salyzyn@google.com, cang@codeaurora.org
Cc:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pedro Sousa <sousa@synopsys.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-msm@vger.kernel.org (open list:ARM/QUALCOMM SUPPORT),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v1 2/2] scsi: ufs: Select INITIAL ADAPT type for HS Gear4
Date:   Tue, 11 Feb 2020 21:38:29 -0800
Message-Id: <1581485910-8307-3-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1581485910-8307-1-git-send-email-cang@codeaurora.org>
References: <1581485910-8307-1-git-send-email-cang@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

ADAPT is added specifically for HS Gear4 mode only, select INITIAL ADAPT
before do power mode change to G4 and select NO ADAPT before switch to
non-G4 modes.

Signed-off-by: Can Guo <cang@codeaurora.org>
---
 drivers/scsi/ufs/ufs-qcom.c | 14 ++++++++++++++
 drivers/scsi/ufs/unipro.h   |  7 +++++++
 2 files changed, 21 insertions(+)

diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
index d593523..6a905bb 100644
--- a/drivers/scsi/ufs/ufs-qcom.c
+++ b/drivers/scsi/ufs/ufs-qcom.c
@@ -942,6 +942,20 @@ static int ufs_qcom_pwr_change_notify(struct ufs_hba *hba,
 		if (!ufshcd_is_hs_mode(&hba->pwr_info) &&
 			ufshcd_is_hs_mode(dev_req_params))
 			ufs_qcom_dev_ref_clk_ctrl(host, true);
+
+		if (host->hw_ver.major >= 0x4) {
+			if (dev_req_params->gear_tx == UFS_HS_G4) {
+				/* INITIAL ADAPT */
+				ufshcd_dme_set(hba,
+					       UIC_ARG_MIB(PA_TXHSADAPTTYPE),
+					       PA_INITIAL_ADAPT);
+			} else {
+				/* NO ADAPT */
+				ufshcd_dme_set(hba,
+					       UIC_ARG_MIB(PA_TXHSADAPTTYPE),
+					       PA_NO_ADAPT);
+			}
+		}
 		break;
 	case POST_CHANGE:
 		if (ufs_qcom_cfg_timers(hba, dev_req_params->gear_rx,
diff --git a/drivers/scsi/ufs/unipro.h b/drivers/scsi/ufs/unipro.h
index 3dc4d8b..766d551 100644
--- a/drivers/scsi/ufs/unipro.h
+++ b/drivers/scsi/ufs/unipro.h
@@ -146,6 +146,12 @@
 #define PA_SLEEPNOCONFIGTIME	0x15A2
 #define PA_STALLNOCONFIGTIME	0x15A3
 #define PA_SAVECONFIGTIME	0x15A4
+#define PA_TXHSADAPTTYPE       0x15D4
+
+/* Adpat type for PA_TXHSADAPTTYPE attribute */
+#define PA_REFRESH_ADAPT       0x00
+#define PA_INITIAL_ADAPT       0x01
+#define PA_NO_ADAPT            0x03
 
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

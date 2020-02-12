Return-Path: <SRS0=6k2I=4A=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45E2BC3B187
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Feb 2020 05:38:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1C6EB2073C
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Feb 2020 05:38:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="SHfuzzMK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728167AbgBLFit (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 Feb 2020 00:38:49 -0500
Received: from mail26.static.mailgun.info ([104.130.122.26]:50032 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725843AbgBLFit (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 12 Feb 2020 00:38:49 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1581485928; h=References: In-Reply-To: Message-Id: Date:
 Subject: Cc: To: From: Sender;
 bh=6NE0YXxrnIXzyTT7QZua7RXaVGt+Knpk/FaEsKYpTwk=; b=SHfuzzMKfwhp8b99eR+h/Hn16hXVH7OhtEVgfN53c/1Fn5Vr6TpwR9qcxEjtfFpcRjvOG4Jf
 tdkMCm3RuiVmv/iqWmWj75usmT9FNMzbhb1ErvL6p2hpb6TuiyNSM78o/iVi6sImPMSxWctm
 CjBMH2J0K5CVnhxqKPd1Yt6QdSY=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e438f68.7f6c0281e928-smtp-out-n02;
 Wed, 12 Feb 2020 05:38:48 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 74EF6C433A2; Wed, 12 Feb 2020 05:38:47 +0000 (UTC)
Received: from pacamara-linux.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id AD35AC43383;
        Wed, 12 Feb 2020 05:38:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org AD35AC43383
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
        Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Venkat Gopalakrishnan <venkatg@codeaurora.org>,
        Tomas Winkler <tomas.winkler@intel.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v1 1/2] scsi: ufs: Use ufshcd_config_pwr_mode() when scale gear
Date:   Tue, 11 Feb 2020 21:38:28 -0800
Message-Id: <1581485910-8307-2-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1581485910-8307-1-git-send-email-cang@codeaurora.org>
References: <1581485910-8307-1-git-send-email-cang@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When scale gear, use ufshcd_config_pwr_mode() instead of
ufshcd_change_power_mode() so that vops_pwr_change_notify(PRE_CHANGE)
can be utilized to allow vendors use customized settings before change
the power mode.

Signed-off-by: Can Guo <cang@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index adcce41..67bd4f2 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -1059,8 +1059,7 @@ static int ufshcd_scale_gear(struct ufs_hba *hba, bool scale_up)
 	}
 
 	/* check if the power mode needs to be changed or not? */
-	ret = ufshcd_change_power_mode(hba, &new_pwr_info);
-
+	ret = ufshcd_config_pwr_mode(hba, &new_pwr_info);
 	if (ret)
 		dev_err(hba->dev, "%s: failed err %d, old gear: (tx %d rx %d), new gear: (tx %d rx %d)",
 			__func__, ret,
@@ -4126,8 +4125,6 @@ int ufshcd_config_pwr_mode(struct ufs_hba *hba,
 		memcpy(&final_params, desired_pwr_mode, sizeof(final_params));
 
 	ret = ufshcd_change_power_mode(hba, &final_params);
-	if (!ret)
-		ufshcd_print_pwr_info(hba);
 
 	return ret;
 }
@@ -7157,6 +7154,7 @@ static int ufshcd_probe_hba(struct ufs_hba *hba, bool async)
 					__func__, ret);
 			goto out;
 		}
+		ufshcd_print_pwr_info(hba);
 	}
 
 	/* set the state as operational after switching to desired gear */
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

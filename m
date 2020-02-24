Return-Path: <SRS0=fKRq=4M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A874AC35679
	for <linux-scsi@archiver.kernel.org>; Mon, 24 Feb 2020 04:10:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 80AC920880
	for <linux-scsi@archiver.kernel.org>; Mon, 24 Feb 2020 04:10:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="YzLb8/bF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727249AbgBXEKG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 23 Feb 2020 23:10:06 -0500
Received: from mail26.static.mailgun.info ([104.130.122.26]:29955 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727207AbgBXEKF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 23 Feb 2020 23:10:05 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1582517404; h=References: In-Reply-To: Message-Id: Date:
 Subject: Cc: To: From: Sender;
 bh=t5BJ5aFBD9UMUe9X6zgCFjhoAHrfuzcXqsWzLsVqcss=; b=YzLb8/bF3SKVG/3gOLPJTyypBAiv1jRrZtCR2Zs9heWB+9ZrCG0HfXf1udZjvp3JYZLJ8r1j
 hjo7sOUsLDU9eDjbsfiPXXq+ZArcNJiWkcFWKuf0v8HOaqcofH/b7qaxAvMWYUgk+tY++8SU
 E/yY/MbwszVYXbJOBXcebOggiOc=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e534c8c.7fa67f5ca378-smtp-out-n02;
 Mon, 24 Feb 2020 04:09:48 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 17DE5C447A9; Mon, 24 Feb 2020 04:09:45 +0000 (UTC)
Received: from pacamara-linux.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 89709C433A2;
        Mon, 24 Feb 2020 04:09:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 89709C433A2
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
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2 1/2] scsi: ufs: Allow vendor apply device quirks in advance
Date:   Sun, 23 Feb 2020 20:09:21 -0800
Message-Id: <1582517363-11536-2-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1582517363-11536-1-git-send-email-cang@codeaurora.org>
References: <1582517363-11536-1-git-send-email-cang@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Currently ufshcd_vops_apply_dev_quirks() comes after all UniPro parameters
have been tuned. Move it up so that vendors have a chance to apply device
quirks in advance.

Signed-off-by: Can Guo <cang@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index abd0e6b..03af432 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -6804,14 +6804,14 @@ static void ufshcd_tune_unipro_params(struct ufs_hba *hba)
 		ufshcd_tune_pa_hibern8time(hba);
 	}
 
+	ufshcd_vops_apply_dev_quirks(hba);
+
 	if (hba->dev_quirks & UFS_DEVICE_QUIRK_PA_TACTIVATE)
 		/* set 1ms timeout for PA_TACTIVATE */
 		ufshcd_dme_set(hba, UIC_ARG_MIB(PA_TACTIVATE), 10);
 
 	if (hba->dev_quirks & UFS_DEVICE_QUIRK_HOST_PA_TACTIVATE)
 		ufshcd_quirk_tune_host_pa_tactivate(hba);
-
-	ufshcd_vops_apply_dev_quirks(hba);
 }
 
 static void ufshcd_clear_dbg_ufs_stats(struct ufs_hba *hba)
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

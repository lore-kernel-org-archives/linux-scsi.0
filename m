Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24D2BC433B4
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Apr 2021 02:26:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E3D9F60FE9
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Apr 2021 02:26:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231608AbhDZC13 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 25 Apr 2021 22:27:29 -0400
Received: from labrats.qualcomm.com ([199.106.110.90]:5466 "EHLO
        labrats.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231502AbhDZC13 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 25 Apr 2021 22:27:29 -0400
IronPort-SDR: QarQzRzHI/dDDUu33b78cmZiTFVbXbXTRLJOSEKrDkAIdrrv9O/4XM+bN+g0qfO1qklQTQ9sMx
 8cqYMx7RBoyzDswypWUfqF6HebCjevGXKjJ/+fWZOThXZ17wc8Fgjh9JhfIC+enavgU8d0PHnu
 /Uv1G4+T8eRSCJNxOgcex/oUeU0qAPj+eARXr/F/S7PM8A0p/Aie4a77xjwXUi1D4nItjXCFRn
 E9jBRG13edJ+AxAZi6AhQBy0UClukbR5SfzYDhnmoO0j2ncErQ3sDB/4HXxXWP4NIaXa21Jncb
 R4c=
X-IronPort-AV: E=Sophos;i="5.82,251,1613462400"; 
   d="scan'208";a="29759455"
Received: from unknown (HELO ironmsg04-sd.qualcomm.com) ([10.53.140.144])
  by labrats.qualcomm.com with ESMTP; 25 Apr 2021 19:26:48 -0700
X-QCInternal: smtphost
Received: from stor-presley.qualcomm.com ([192.168.140.85])
  by ironmsg04-sd.qualcomm.com with ESMTP; 25 Apr 2021 19:26:47 -0700
Received: by stor-presley.qualcomm.com (Postfix, from userid 359480)
        id ED4072113E; Sun, 25 Apr 2021 19:26:47 -0700 (PDT)
From:   Can Guo <cang@codeaurora.org>
To:     asutoshd@codeaurora.org, ziqichen@codeaurora.org,
        nguyenb@codeaurora.org, hongwus@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        cang@codeaurora.org
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v1 1/3] scsi: ufs: Do not put UFS power into LPM if link is broken
Date:   Sun, 25 Apr 2021 19:24:35 -0700
Message-Id: <1619403878-28330-2-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1619403878-28330-1-git-send-email-cang@codeaurora.org>
References: <1619403878-28330-1-git-send-email-cang@codeaurora.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

During resume, if link is broken due to AH8 failure, make sure
ufshcd_resume() do not put UFS power back into LPM.

Fixes: 4db7a23605973 ("scsi: ufs: Fix concurrency of error handler and other error recovery paths")
Signed-off-by: Can Guo <cang@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index a8c5bd9..7ab6b12 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -8666,7 +8666,7 @@ static void ufshcd_vreg_set_lpm(struct ufs_hba *hba)
 	} else if (!ufshcd_is_ufs_dev_active(hba)) {
 		ufshcd_toggle_vreg(hba->dev, hba->vreg_info.vcc, false);
 		vcc_off = true;
-		if (!ufshcd_is_link_active(hba)) {
+		if (ufshcd_is_link_hibern8(hba) || ufshcd_is_link_off(hba)) {
 			ufshcd_config_vreg_lpm(hba, hba->vreg_info.vccq);
 			ufshcd_config_vreg_lpm(hba, hba->vreg_info.vccq2);
 		}
@@ -8688,7 +8688,7 @@ static int ufshcd_vreg_set_hpm(struct ufs_hba *hba)
 	    !hba->dev_info.is_lu_power_on_wp) {
 		ret = ufshcd_setup_vreg(hba, true);
 	} else if (!ufshcd_is_ufs_dev_active(hba)) {
-		if (!ret && !ufshcd_is_link_active(hba)) {
+		if (!ufshcd_is_link_active(hba)) {
 			ret = ufshcd_config_vreg_hpm(hba, hba->vreg_info.vccq);
 			if (ret)
 				goto vcc_disable;
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.


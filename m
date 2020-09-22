Return-Path: <SRS0=VSHB=C7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49A30C2D0E2
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Sep 2020 07:13:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F150223A61
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Sep 2020 07:13:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729676AbgIVHNN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Sep 2020 03:13:13 -0400
Received: from labrats.qualcomm.com ([199.106.110.90]:9654 "EHLO
        labrats.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728526AbgIVHNN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Sep 2020 03:13:13 -0400
IronPort-SDR: e7YpYL10wF24JN8gGfcVAhUbG85jKVpKaDX25U3G+TtfcH+0agOiqCM1tlBnKKscgFdsFUueFj
 FfykhwMzS1WXRbUaQ/IpQhySUMYX7yw4d0DYh3ztmebWHCUctl/p/m2cjElqemzh5AFN5pjjBu
 lVqgVDvqaDsdoYqumvrJOENQM+Zxe2J9IQGgGyV/hl3k4kXt5JeqD52PzS14prcvXR0+Ml2Ibo
 xmlXtiqdpCmqu/LHTOaZO/rv/YPTvMWfYn+5lkidd05zU7iWPjvc+FouVdA+6K4yNbHZq956fp
 +Vs=
X-IronPort-AV: E=Sophos;i="5.77,289,1596524400"; 
   d="scan'208";a="47332985"
Received: from unknown (HELO ironmsg05-sd.qualcomm.com) ([10.53.140.145])
  by labrats.qualcomm.com with ESMTP; 22 Sep 2020 00:09:12 -0700
Received: from wsp769891wss.qualcomm.com (HELO stor-presley.qualcomm.com) ([192.168.140.85])
  by ironmsg05-sd.qualcomm.com with ESMTP; 22 Sep 2020 00:09:10 -0700
Received: by stor-presley.qualcomm.com (Postfix, from userid 359480)
        id C9F3B21653; Tue, 22 Sep 2020 00:09:09 -0700 (PDT)
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
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] scsi: ufs: Make sure clk scaling happens only when hba is runtime ACTIVE
Date:   Tue, 22 Sep 2020 00:09:04 -0700
Message-Id: <1600758548-28576-1-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If someone plays with the UFS clk scaling devfreq governor through sysfs,
ufshcd_devfreq_scale may be called even when hba is not runtime ACTIVE,
which can lead to unexpected error. We cannot just protect it by calling
pm_runtime_get_sync, because that may cause racing problem since hba
runtime suspend ops needs to suspend clk scaling. In order to fix it, call
pm_runtime_get_noresume and check hba's runtime status, then only proceed
if hba is runtime ACTIVE, otherwise just bail.

governor_store
 devfreq_performance_handler
  update_devfreq
   devfreq_set_target
    ufshcd_devfreq_target
     ufshcd_devfreq_scale

Signed-off-by: Can Guo <cang@codeaurora.org>

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index e4cb994..847f355 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -1294,8 +1294,15 @@ static int ufshcd_devfreq_target(struct device *dev,
 	}
 	spin_unlock_irqrestore(hba->host->host_lock, irq_flags);
 
+	pm_runtime_get_noresume(hba->dev);
+	if (!pm_runtime_active(hba->dev)) {
+		pm_runtime_put_noidle(hba->dev);
+		ret = -EAGAIN;
+		goto out;
+	}
 	start = ktime_get();
 	ret = ufshcd_devfreq_scale(hba, scale_up);
+	pm_runtime_put(hba->dev);
 
 	trace_ufshcd_profile_clk_scaling(dev_name(hba->dev),
 		(scale_up ? "up" : "down"),
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.


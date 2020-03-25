Return-Path: <SRS0=rA/a=5K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E9F6C2D0E5
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Mar 2020 18:29:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 649DE2078A
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Mar 2020 18:29:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727865AbgCYS3W (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 25 Mar 2020 14:29:22 -0400
Received: from alexa-out-sd-01.qualcomm.com ([199.106.114.38]:27404 "EHLO
        alexa-out-sd-01.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727129AbgCYS3V (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 25 Mar 2020 14:29:21 -0400
Received: from unknown (HELO ironmsg01-sd.qualcomm.com) ([10.53.140.141])
  by alexa-out-sd-01.qualcomm.com with ESMTP; 25 Mar 2020 11:29:21 -0700
Received: from asutoshd-linux1.qualcomm.com ([10.46.160.39])
  by ironmsg01-sd.qualcomm.com with ESMTP; 25 Mar 2020 11:29:20 -0700
Received: by asutoshd-linux1.qualcomm.com (Postfix, from userid 92687)
        id A1480208CE; Wed, 25 Mar 2020 11:29:20 -0700 (PDT)
From:   Asutosh Das <asutoshd@codeaurora.org>
To:     Avri.Altman@wdc.com, cang@codeaurora.org,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc:     Asutosh Das <asutoshd@codeaurora.org>,
        linux-arm-msm@vger.kernel.org, Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2 3/3] scsi: ufs-qcom: Override devfreq parameters
Date:   Wed, 25 Mar 2020 11:29:02 -0700
Message-Id: <b6875729b6072134985c9113a820cf60a2af22e7.1585160616.git.asutoshd@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1585160616.git.asutoshd@codeaurora.org>
References: <cover.1585160616.git.asutoshd@codeaurora.org>
In-Reply-To: <cover.1585160616.git.asutoshd@codeaurora.org>
References: <cover.1585160616.git.asutoshd@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Override devfreq parameters for power-performance
trade-off.

Signed-off-by: Asutosh Das <asutoshd@codeaurora.org>
---
 drivers/scsi/ufs/ufs-qcom.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
index 6115ac6..19aa5c4 100644
--- a/drivers/scsi/ufs/ufs-qcom.c
+++ b/drivers/scsi/ufs/ufs-qcom.c
@@ -10,6 +10,7 @@
 #include <linux/phy/phy.h>
 #include <linux/gpio/consumer.h>
 #include <linux/reset-controller.h>
+#include <linux/devfreq.h>
 
 #include "ufshcd.h"
 #include "ufshcd-pltfrm.h"
@@ -1689,6 +1690,29 @@ static void ufs_qcom_device_reset(struct ufs_hba *hba)
 	usleep_range(10, 15);
 }
 
+#if IS_ENABLED(CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND)
+static void ufs_qcom_config_scaling_param(struct ufs_hba *hba,
+					  struct devfreq_dev_profile *p,
+					  void *data)
+{
+	static struct devfreq_simple_ondemand_data *d;
+
+	if (!data)
+		return;
+
+	d = (struct devfreq_simple_ondemand_data *)data;
+	p->polling_ms = 60;
+	d->upthreshold = 70;
+	d->downdifferential = 5;
+}
+#else
+static void ufs_qcom_config_scaling_param(struct ufs_hba *hba,
+					  struct devfreq_dev_profile *p,
+					  void *data)
+{
+}
+#endif
+
 /**
  * struct ufs_hba_qcom_vops - UFS QCOM specific variant operations
  *
@@ -1710,6 +1734,7 @@ static const struct ufs_hba_variant_ops ufs_hba_qcom_vops = {
 	.resume			= ufs_qcom_resume,
 	.dbg_register_dump	= ufs_qcom_dump_dbg_regs,
 	.device_reset		= ufs_qcom_device_reset,
+	.config_scaling_param = ufs_qcom_config_scaling_param,
 };
 
 /**
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.


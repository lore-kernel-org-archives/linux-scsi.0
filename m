Return-Path: <SRS0=d7EE=5G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1552C43333
	for <linux-scsi@archiver.kernel.org>; Sat, 21 Mar 2020 01:00:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 81B5E20722
	for <linux-scsi@archiver.kernel.org>; Sat, 21 Mar 2020 01:00:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727783AbgCUBAI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 20 Mar 2020 21:00:08 -0400
Received: from alexa-out-sd-02.qualcomm.com ([199.106.114.39]:24787 "EHLO
        alexa-out-sd-02.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727046AbgCUBAH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 20 Mar 2020 21:00:07 -0400
Received: from unknown (HELO ironmsg-SD-alpha.qualcomm.com) ([10.53.140.30])
  by alexa-out-sd-02.qualcomm.com with ESMTP; 20 Mar 2020 18:00:06 -0700
Received: from asutoshd-linux1.qualcomm.com ([10.46.160.39])
  by ironmsg-SD-alpha.qualcomm.com with ESMTP; 20 Mar 2020 18:00:05 -0700
Received: by asutoshd-linux1.qualcomm.com (Postfix, from userid 92687)
        id E0EFF1FFE7; Fri, 20 Mar 2020 18:00:05 -0700 (PDT)
From:   Asutosh Das <asutoshd@codeaurora.org>
To:     cang@codeaurora.org, Avri.Altman@wdc.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc:     Asutosh Das <asutoshd@codeaurora.org>,
        linux-arm-msm@vger.kernel.org, Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [<RFC RESEND PATCH v2> 2/3] ufs-qcom: scsi: configure write booster type
Date:   Fri, 20 Mar 2020 17:59:19 -0700
Message-Id: <116b8c6bed27ffbee9da6ccfd52a2fdc612648b4.1584752043.git.asutoshd@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1584752043.git.asutoshd@codeaurora.org>
References: <cover.1584752043.git.asutoshd@codeaurora.org>
In-Reply-To: <cover.1584752043.git.asutoshd@codeaurora.org>
References: <cover.1584752043.git.asutoshd@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Configure the WriteBooster type to preserve user-space mode.
This would ensure that no user-space capacity is reduced
when write booster is enabled.

Change-Id: I4144531a73ea3b5d5ede76beae45722366b1e75c
Signed-off-by: Asutosh Das <asutoshd@codeaurora.org>
---
 drivers/scsi/ufs/ufs-qcom.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
index 6115ac6..59f3243 100644
--- a/drivers/scsi/ufs/ufs-qcom.c
+++ b/drivers/scsi/ufs/ufs-qcom.c
@@ -1689,6 +1689,12 @@ static void ufs_qcom_device_reset(struct ufs_hba *hba)
 	usleep_range(10, 15);
 }
 
+static u32 ufs_qcom_wb_get_user_cap_mode(struct ufs_hba *hba)
+{
+	/* QCom prefers no user-space reduction mode */
+	return UFS_WB_BUFF_PRESERVE_USER_SPACE;
+}
+
 /**
  * struct ufs_hba_qcom_vops - UFS QCOM specific variant operations
  *
@@ -1710,6 +1716,7 @@ static const struct ufs_hba_variant_ops ufs_hba_qcom_vops = {
 	.resume			= ufs_qcom_resume,
 	.dbg_register_dump	= ufs_qcom_dump_dbg_regs,
 	.device_reset		= ufs_qcom_device_reset,
+	.wb_get_user_cap_mode	= ufs_qcom_wb_get_user_cap_mode,
 };
 
 /**
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.


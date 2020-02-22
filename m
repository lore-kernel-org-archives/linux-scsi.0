Return-Path: <SRS0=uhQV=4K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 792B4C35670
	for <linux-scsi@archiver.kernel.org>; Sat, 22 Feb 2020 00:47:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4CEA1207FD
	for <linux-scsi@archiver.kernel.org>; Sat, 22 Feb 2020 00:47:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727520AbgBVArk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 21 Feb 2020 19:47:40 -0500
Received: from alexa-out-sd-01.qualcomm.com ([199.106.114.38]:28033 "EHLO
        alexa-out-sd-01.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727268AbgBVArj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 21 Feb 2020 19:47:39 -0500
Received: from unknown (HELO ironmsg03-sd.qualcomm.com) ([10.53.140.143])
  by alexa-out-sd-01.qualcomm.com with ESMTP; 21 Feb 2020 16:47:39 -0800
Received: from asutoshd-linux1.qualcomm.com ([10.46.160.39])
  by ironmsg03-sd.qualcomm.com with ESMTP; 21 Feb 2020 16:47:38 -0800
Received: by asutoshd-linux1.qualcomm.com (Postfix, from userid 92687)
        id A5E3E216F4; Fri, 21 Feb 2020 16:47:38 -0800 (PST)
From:   Asutosh Das <asutoshd@codeaurora.org>
To:     subhashj@codeaurora.org, cang@codeaurora.org,
        rnayak@codeaurora.org, vinholikatti@gmail.com,
        jejb@linux.vnet.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org
Cc:     Asutosh Das <asutoshd@codeaurora.org>,
        linux-arm-msm@vger.kernel.org, Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [<RFC PATCH v1> 2/2] ufs-qcom: scsi: configure write booster type
Date:   Fri, 21 Feb 2020 16:47:21 -0800
Message-Id:
 <a67a815764ba60aea2f8b2890f6c65c9ea87aafc.1582330473.git.asutoshd@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1582330473.git.asutoshd@codeaurora.org>
References: <cover.1582330473.git.asutoshd@codeaurora.org>
In-Reply-To: <cover.1582330473.git.asutoshd@codeaurora.org>
References: <cover.1582330473.git.asutoshd@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org
Message-ID: <20200222004721._IZDQ3iyv_f9BGq-SX6psIDAtEC4VnEhoQX_lX80kNg@z>

Configure the WriteBooster type to preserve user-space mode.
This would ensure that no user-space capacity is reduced
when write booster is enabled.

Signed-off-by: Asutosh Das <asutoshd@codeaurora.org>
---
 drivers/scsi/ufs/ufs-qcom.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
index 8339050..313b4a2 100644
--- a/drivers/scsi/ufs/ufs-qcom.c
+++ b/drivers/scsi/ufs/ufs-qcom.c
@@ -1686,6 +1686,12 @@ static void ufs_qcom_device_reset(struct ufs_hba *hba)
 	usleep_range(10, 15);
 }
 
+static u32 ufs_qcom_get_user_cap_mode(struct ufs_hba *hba)
+{
+	/* QCom prefers no user-space reduction mode */
+	return UFS_WB_BUFF_PRESERVE_USER_SPACE;
+}
+
 /**
  * struct ufs_hba_qcom_vops - UFS QCOM specific variant operations
  *
@@ -1707,6 +1713,7 @@ static const struct ufs_hba_variant_ops ufs_hba_qcom_vops = {
 	.resume			= ufs_qcom_resume,
 	.dbg_register_dump	= ufs_qcom_dump_dbg_regs,
 	.device_reset		= ufs_qcom_device_reset,
+	.get_user_cap_mode	= ufs_qcom_get_user_cap_mode,
 };
 
 /**
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.


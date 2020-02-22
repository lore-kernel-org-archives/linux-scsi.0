Return-Path: <SRS0=uhQV=4K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC82EC3566F
	for <linux-scsi@archiver.kernel.org>; Sat, 22 Feb 2020 00:38:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A137220722
	for <linux-scsi@archiver.kernel.org>; Sat, 22 Feb 2020 00:38:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726733AbgBVAiu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 21 Feb 2020 19:38:50 -0500
Received: from alexa-out-sd-01.qualcomm.com ([199.106.114.38]:7979 "EHLO
        alexa-out-sd-01.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726613AbgBVAit (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 21 Feb 2020 19:38:49 -0500
Received: from unknown (HELO ironmsg01-sd.qualcomm.com) ([10.53.140.141])
  by alexa-out-sd-01.qualcomm.com with ESMTP; 21 Feb 2020 16:38:48 -0800
Received: from asutoshd-linux1.qualcomm.com ([10.46.160.39])
  by ironmsg01-sd.qualcomm.com with ESMTP; 21 Feb 2020 16:38:48 -0800
Received: by asutoshd-linux1.qualcomm.com (Postfix, from userid 92687)
        id 4882A216F4; Fri, 21 Feb 2020 16:38:48 -0800 (PST)
From:   Asutosh Das <asutoshd@codeaurora.org>
To:     asutoshd@qti.qualcomm.com, linux-scsi@vger.kernel.org
Subject: [<RFC PATCH v1> 2/2] ufs-qcom: scsi: configure write booster type
Date:   Fri, 21 Feb 2020 16:38:47 -0800
Message-Id: <a67a815764ba60aea2f8b2890f6c65c9ea87aafc.1582330473.git.asutoshd@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1582330473.git.asutoshd@codeaurora.org>
References: <cover.1582330473.git.asutoshd@codeaurora.org>
In-Reply-To: <cover.1582330473.git.asutoshd@codeaurora.org>
References: <cover.1582330473.git.asutoshd@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

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


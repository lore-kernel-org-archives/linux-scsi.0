Return-Path: <SRS0=JunS=BC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DB27C433E3
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jul 2020 11:46:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7484D20825
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jul 2020 11:46:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728690AbgGWLqg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 23 Jul 2020 07:46:36 -0400
Received: from labrats.qualcomm.com ([199.106.110.90]:3550 "EHLO
        labrats.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728635AbgGWLqf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Jul 2020 07:46:35 -0400
IronPort-SDR: fZl7Q/x8Rie1wDqtV3QYiYFccdxBT/VaDhHCtxFm93DPiusz0i9MBqthZ8zyRh5KiruAuIf2gI
 PhwcOOuGe8tRfuFzTaFVyCmr7lInM4LlmKH61UaUfFK+R8tNRHTlDv896zP/GsieOUwk0MdzVI
 56baQIuKs1l1uZ728sfnv6EHM9dlf4k/v/1tOk/UWUMwLAocKIoBPcaUxYbQKdffnOLFTfaxkj
 kSS2TVP9Fxfu0ZJhvw2NGtZTIBigqLi36CuPODmXhBVceNX+dBEio5ku+W8f4EE/VOTPuZZjus
 x9E=
X-IronPort-AV: E=Sophos;i="5.75,386,1589266800"; 
   d="scan'208";a="29048252"
Received: from unknown (HELO ironmsg-SD-alpha.qualcomm.com) ([10.53.140.30])
  by labrats.qualcomm.com with ESMTP; 23 Jul 2020 04:46:35 -0700
Received: from pacamara-linux.qualcomm.com ([192.168.140.135])
  by ironmsg-SD-alpha.qualcomm.com with ESMTP; 23 Jul 2020 04:46:34 -0700
Received: by pacamara-linux.qualcomm.com (Postfix, from userid 359480)
        id 0834222E23; Thu, 23 Jul 2020 04:46:34 -0700 (PDT)
From:   Can Guo <cang@codeaurora.org>
To:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, rnayak@codeaurora.org,
        sh425.lee@samsung.com, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com,
        cang@codeaurora.org
Cc:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-arm-msm@vger.kernel.org (open list:ARM/QUALCOMM SUPPORT),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v6 3/8] scsi: ufs-qcom: Fix schedule while atomic error in ufs_qcom_dump_dbg_regs
Date:   Thu, 23 Jul 2020 04:46:21 -0700
Message-Id: <1595504787-19429-4-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1595504787-19429-1-git-send-email-cang@codeaurora.org>
References: <1595504787-19429-1-git-send-email-cang@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Dumping testbus registers needs to sleep a bit intermittently as there are
too many of them. Skip them for those contexts where sleep is not allowed.

Signed-off-by: Can Guo <cang@codeaurora.org>
---
 drivers/scsi/ufs/ufs-qcom.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
index 7da27ee..7831b2b 100644
--- a/drivers/scsi/ufs/ufs-qcom.c
+++ b/drivers/scsi/ufs/ufs-qcom.c
@@ -1651,13 +1651,16 @@ static void ufs_qcom_dump_dbg_regs(struct ufs_hba *hba)
 	ufshcd_dump_regs(hba, REG_UFS_SYS1CLK_1US, 16 * 4,
 			 "HCI Vendor Specific Registers ");
 
-	/* sleep a bit intermittently as we are dumping too much data */
 	ufs_qcom_print_hw_debug_reg_all(hba, NULL, ufs_qcom_dump_regs_wrapper);
-	udelay(1000);
-	ufs_qcom_testbus_read(hba);
-	udelay(1000);
-	ufs_qcom_print_unipro_testbus(hba);
-	udelay(1000);
+
+	if (in_task()) {
+		/* sleep a bit intermittently as we are dumping too much data */
+		usleep_range(1000, 1100);
+		ufs_qcom_testbus_read(hba);
+		usleep_range(1000, 1100);
+		ufs_qcom_print_unipro_testbus(hba);
+		usleep_range(1000, 1100);
+	}
 }
 
 /**
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.


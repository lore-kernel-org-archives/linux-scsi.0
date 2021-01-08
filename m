Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0207C433DB
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Jan 2021 15:09:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 92CC823998
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Jan 2021 15:09:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727468AbhAHPI7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Jan 2021 10:08:59 -0500
Received: from alexa-out.qualcomm.com ([129.46.98.28]:7185 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725806AbhAHPI7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Jan 2021 10:08:59 -0500
Received: from ironmsg07-lv.qualcomm.com (HELO ironmsg07-lv.qulacomm.com) ([10.47.202.151])
  by alexa-out.qualcomm.com with ESMTP; 08 Jan 2021 07:08:19 -0800
X-QCInternal: smtphost
Received: from ironmsg02-blr.qualcomm.com ([10.86.208.131])
  by ironmsg07-lv.qulacomm.com with ESMTP/TLS/AES256-SHA; 08 Jan 2021 07:08:17 -0800
X-QCInternal: smtphost
Received: from nitirawa-linux.qualcomm.com ([10.206.25.176])
  by ironmsg02-blr.qualcomm.com with ESMTP; 08 Jan 2021 20:37:56 +0530
Received: by nitirawa-linux.qualcomm.com (Postfix, from userid 2342877)
        id 20AE81A5C; Fri,  8 Jan 2021 20:37:56 +0530 (IST)
From:   Nitin Rawat <nitirawa@codeaurora.org>
To:     asutoshd@codeaurora.org, stummala@codeaurora.org,
        vbadigan@codeaurora.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, cang@codeaurora.org,
        stanley.chu@mediatek.com, beanhuo@micron.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nitin Rawat <nitirawa@codeaurora.org>
Subject: [PATCH V1] scsi: ufs: Add UFS3.0 in ufs HCI version check
Date:   Fri,  8 Jan 2021 20:37:53 +0530
Message-Id: <1610118473-21021-1-git-send-email-nitirawa@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

As per JESD223D UFS HCI v3.0 specs, HCI version 3.0
is also supported. Hence Adding UFS3.0 in UFS HCI
version check to avoid logging the error message.

Signed-off-by: Nitin Rawat <nitirawa@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd.c | 5 +++--
 drivers/scsi/ufs/ufshci.h | 1 +
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 82ad317..54ca765 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -9255,8 +9255,9 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 	if ((hba->ufs_version != UFSHCI_VERSION_10) &&
 	    (hba->ufs_version != UFSHCI_VERSION_11) &&
 	    (hba->ufs_version != UFSHCI_VERSION_20) &&
-	    (hba->ufs_version != UFSHCI_VERSION_21))
-		dev_err(hba->dev, "invalid UFS version 0x%x\n",
+	    (hba->ufs_version != UFSHCI_VERSION_21) &&
+	    (hba->ufs_version != UFSHCI_VERSION_30))
+		dev_err(hba->dev, "invalid UFS HCI version 0x%x\n",
 			hba->ufs_version);

 	/* Get Interrupt bit mask per version */
diff --git a/drivers/scsi/ufs/ufshci.h b/drivers/scsi/ufs/ufshci.h
index 6795e1f..48f6c19 100644
--- a/drivers/scsi/ufs/ufshci.h
+++ b/drivers/scsi/ufs/ufshci.h
@@ -80,6 +80,7 @@ enum {
 	UFSHCI_VERSION_11 = 0x00010100, /* 1.1 */
 	UFSHCI_VERSION_20 = 0x00000200, /* 2.0 */
 	UFSHCI_VERSION_21 = 0x00000210, /* 2.1 */
+	UFSHCI_VERSION_30 = 0x00000300, /* 3.0 */
 };

 /*
--
2.7.4


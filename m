Return-Path: <SRS0=dT41=YQ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5AC6CA9EB9
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Oct 2019 04:14:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 91DA021872
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Oct 2019 04:14:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Z8HSfTGj";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="K80r7HEO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730047AbfJWENy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Oct 2019 00:13:54 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:41860 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726283AbfJWENx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Oct 2019 00:13:53 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 50AEE60A23; Wed, 23 Oct 2019 04:13:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1571804032;
        bh=uC8LiLkcBv7RD3c+BU2tghu/rE7vS/ZQkF3t3atOtTA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z8HSfTGjyWVo6B49E2VeIruMZfEiwM/XikkHjOFF1tqYEZ6zcAr1RjWmTrUBL1mjI
         oicFOOlqVLCMLrnRYKt4aK+2avH1ob+frUt/IXaXEwcraUado3jBRWLx3FmozRdiZS
         nCGJhByZPLbLPwgN6xDTxUd4g1h8SE1nIMiiw5+4=
Received: from pacamara-linux.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: cang@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id DA47F609D4;
        Wed, 23 Oct 2019 04:13:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1571804030;
        bh=uC8LiLkcBv7RD3c+BU2tghu/rE7vS/ZQkF3t3atOtTA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K80r7HEO25ljHqcNN1pBm3RqPC2q9c0PR744S/QPevts9vKq9K5cPovp7BJBxDc7i
         iq2aq0q6VsqBkzG3Dh3x0KW0NkPcOIF1MR4C+AHH2XfDMMXzKAgpHYGoZB+M5TM7r1
         j2ze8ERHm66kJYBV2/sGTaKt4lzRPRCXUk4WSPS8=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org DA47F609D4
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=cang@codeaurora.org
From:   Can Guo <cang@codeaurora.org>
To:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com,
        cang@codeaurora.org
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Subhash Jadavani <subhashj@codeaurora.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v1 1/2] scsi: ufs: Introduce a vops for resetting host controller
Date:   Tue, 22 Oct 2019 21:13:27 -0700
Message-Id: <1571804009-29787-2-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1571804009-29787-1-git-send-email-cang@codeaurora.org>
References: <1571804009-29787-1-git-send-email-cang@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Some UFS host controllers need their specific implementations of resetting
to get them into a good state. Provide a new vops to allow the platform
driver to implement this own reset operation.

Signed-off-by: Can Guo <cang@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd.c | 16 ++++++++++++++++
 drivers/scsi/ufs/ufshcd.h | 10 ++++++++++
 2 files changed, 26 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index c28c144..161e3c4 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -3859,6 +3859,14 @@ static int ufshcd_link_recovery(struct ufs_hba *hba)
 	ufshcd_set_eh_in_progress(hba);
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 
+	ret = ufshcd_vops_full_reset(hba);
+	if (ret)
+		dev_warn(hba->dev, "%s: full reset returned %d\n",
+				  __func__, ret);
+
+	/* Reset the attached device */
+	ufshcd_vops_device_reset(hba);
+
 	ret = ufshcd_host_reset_and_restore(hba);
 
 	spin_lock_irqsave(hba->host->host_lock, flags);
@@ -6241,6 +6249,11 @@ static int ufshcd_reset_and_restore(struct ufs_hba *hba)
 	int retries = MAX_HOST_RESET_RETRIES;
 
 	do {
+		err = ufshcd_vops_full_reset(hba);
+		if (err)
+			dev_warn(hba->dev, "%s: full reset returned %d\n",
+					__func__, err);
+
 		/* Reset the attached device */
 		ufshcd_vops_device_reset(hba);
 
@@ -8384,6 +8397,9 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 		goto exit_gating;
 	}
 
+	/* Reset controller to power on reset (POR) state */
+	ufshcd_vops_full_reset(hba);
+
 	/* Reset the attached device */
 	ufshcd_vops_device_reset(hba);
 
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index e0fe247..253b9ea 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -296,6 +296,8 @@ struct ufs_pwr_mode_info {
  * @apply_dev_quirks: called to apply device specific quirks
  * @suspend: called during host controller PM callback
  * @resume: called during host controller PM callback
+ * @full_reset: called for handling variant specific implementations of
+ *              resetting the hci
  * @dbg_register_dump: used to dump controller debug information
  * @phy_initialization: used to initialize phys
  * @device_reset: called to issue a reset pulse on the UFS device
@@ -325,6 +327,7 @@ struct ufs_hba_variant_ops {
 	int	(*apply_dev_quirks)(struct ufs_hba *);
 	int     (*suspend)(struct ufs_hba *, enum ufs_pm_op);
 	int     (*resume)(struct ufs_hba *, enum ufs_pm_op);
+	int	(*full_reset)(struct ufs_hba *hba);
 	void	(*dbg_register_dump)(struct ufs_hba *hba);
 	int	(*phy_initialization)(struct ufs_hba *);
 	void	(*device_reset)(struct ufs_hba *hba);
@@ -1076,6 +1079,13 @@ static inline int ufshcd_vops_resume(struct ufs_hba *hba, enum ufs_pm_op op)
 	return 0;
 }
 
+static inline int ufshcd_vops_full_reset(struct ufs_hba *hba)
+{
+	if (hba->vops && hba->vops->full_reset)
+		return hba->vops->full_reset(hba);
+	return 0;
+}
+
 static inline void ufshcd_vops_dbg_register_dump(struct ufs_hba *hba)
 {
 	if (hba->vops && hba->vops->dbg_register_dump)
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project


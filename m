From: Yaniv Gardi <ygardi@codeaurora.org>
Subject: [PATCH v1 10/10] scsi: ufs-qcom: enable UFSHCD_QUIRK_BROKEN_UFS_HCI_VERSION
Date: Sun, 17 May 2015 18:55:06 +0300
Message-ID: <1431878106-30579-11-git-send-email-ygardi@codeaurora.org>
References: <1431878106-30579-1-git-send-email-ygardi@codeaurora.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:52220 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753187AbbEQPz4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 17 May 2015 11:55:56 -0400
In-Reply-To: <1431878106-30579-1-git-send-email-ygardi@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, hch@infradead.org
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, subhashj@codeaurora.org, ygardi@codeaurora.org, dovl@codeaurora.org, draviv@codeaurora.org, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@odin.com>

Newer revisions of QUALCOMM Technologies UFS host controller may not
advertise the correct version information in UFS HCI VER register.
To handle this, enable UFSHCD_QUIRK_BROKEN_UFS_HCI_VERSION to let
UFS standard host controller driver call into vendor specific
operation to get right UFS HCI VER register value.

Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>

---
 drivers/scsi/ufs/ufs-qcom.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
index de9cfb0..4cdffa4 100644
--- a/drivers/scsi/ufs/ufs-qcom.c
+++ b/drivers/scsi/ufs/ufs-qcom.c
@@ -694,6 +694,16 @@ out:
 	return ret;
 }
 
+static u32 ufs_qcom_get_ufs_hci_version(struct ufs_hba *hba)
+{
+	struct ufs_qcom_host *host = hba->priv;
+
+	if (host->hw_ver.major == 0x1)
+		return UFSHCI_VERSION_11;
+	else
+		return UFSHCI_VERSION_20;
+}
+
 /**
  * ufs_qcom_advertise_quirks - advertise the known QCOM UFS controller quirks
  * @hba: host controller instance
@@ -718,6 +728,7 @@ static void ufs_qcom_advertise_quirks(struct ufs_hba *hba)
 
 	if (host->hw_ver.major >= 0x2) {
 		hba->quirks |= UFSHCD_QUIRK_BROKEN_LCC;
+		hba->quirks |= UFSHCD_QUIRK_BROKEN_UFS_HCI_VERSION;
 
 		if (!ufs_qcom_cap_qunipro(host))
 			/* Legacy UniPro mode still need following quirks */
@@ -1026,6 +1037,7 @@ static const struct ufs_hba_variant_ops ufs_hba_qcom_vops = {
 	.name                   = "qcom",
 	.init                   = ufs_qcom_init,
 	.exit                   = ufs_qcom_exit,
+	.get_ufs_hci_version	= ufs_qcom_get_ufs_hci_version,
 	.clk_scale_notify	= ufs_qcom_clk_scale_notify,
 	.setup_clocks           = ufs_qcom_setup_clocks,
 	.hce_enable_notify      = ufs_qcom_hce_enable_notify,
-- 
1.8.5.2

-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

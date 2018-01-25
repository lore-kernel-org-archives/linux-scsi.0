From: Asutosh Das <asutoshd@codeaurora.org>
Subject: [PATCH 1/1] scsi: ufs: Add LCC quirk for host and device
Date: Thu, 25 Jan 2018 15:09:18 +0530
Message-ID: <1516873158-2900-1-git-send-email-asutoshd@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: subhashj@codeaurora.org, cang@codeaurora.org, vivek.gautam@codeaurora.org, vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, Venkat Gopalakrishnan <venkatg@codeaurora.org>, Asutosh Das <asutoshd@codeaurora.org>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

From: Subhash Jadavani <subhashj@codeaurora.org>

LCC (Line Control Command) is being used for communication between
UFS host and UFS device. But some hosts might have the issue with
issuing the LCC commands to UFS device and in this case LCC could be
explicitly disabled.

But there could be a need where we don't want to disable the LCC
on both host & device; hence this change splits the quirk in 2 parts
one for host and one for device.

Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
Signed-off-by: Venkat Gopalakrishnan <venkatg@codeaurora.org>
Signed-off-by: Can Guo <cang@codeaurora.org>
Signed-off-by: Asutosh Das <asutoshd@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd.c | 16 ++++++++++++++++
 drivers/scsi/ufs/ufshcd.h | 11 +++++++++++
 2 files changed, 27 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 8af2af3..d6fc88d 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -4121,6 +4121,11 @@ static int ufshcd_disable_tx_lcc(struct ufs_hba *hba, bool peer)
 	return err;
 }
 
+static inline int ufshcd_disable_host_tx_lcc(struct ufs_hba *hba)
+{
+	return ufshcd_disable_tx_lcc(hba, false);
+}
+
 static inline int ufshcd_disable_device_tx_lcc(struct ufs_hba *hba)
 {
 	return ufshcd_disable_tx_lcc(hba, true);
@@ -4171,6 +4176,17 @@ static int ufshcd_link_startup(struct ufs_hba *hba)
 		/* failed to get the link up... retire */
 		goto out;
 
+	if (hba->quirks & UFSHCD_BROKEN_LCC_PROCESSING_ON_HOST) {
+		ret = ufshcd_disable_device_tx_lcc(hba);
+		if (ret)
+			goto out;
+	}
+
+	if (hba->quirks & UFSHCD_BROKEN_LCC_PROCESSING_ON_DEVICE) {
+		ret = ufshcd_disable_host_tx_lcc(hba);
+		if (ret)
+			goto out;
+	}
 	if (link_startup_again) {
 		link_startup_again = false;
 		retries = DME_LINKSTARTUP_RETRIES;
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 1332e54..7a2dad3 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -591,6 +591,17 @@ struct ufs_hba {
 	 */
 	#define UFSHCD_QUIRK_PRDT_BYTE_GRAN			0x80
 
+	/*
+	 * If UFS device is having issue in processing LCC (Line Control
+	 * Command) coming from UFS host controller then enable this quirk.
+	 * When this quirk is enabled, host controller driver should disable
+	 * the LCC transmission on UFS host controller (by clearing
+	 * TX_LCC_ENABLE attribute of host to 0).
+	 */
+	#define UFSHCD_BROKEN_LCC_PROCESSING_ON_DEVICE		0x100
+
+	#define UFSHCD_BROKEN_LCC_PROCESSING_ON_HOST		0x200
+
 	unsigned int quirks;	/* Deviations from standard UFSHCI spec. */
 
 	/* Device deviations from standard UFS device spec. */
-- 
Qualcomm India Private Limited, on behalf of Qualcomm Innovation Center, Inc. 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.

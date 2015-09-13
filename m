From: Yaniv Gardi <ygardi@codeaurora.org>
Subject: [PATCH v1 08/17] scsi: ufs: split broken LCC quirk
Date: Sun, 13 Sep 2015 17:52:48 +0300
Message-ID: <1442155977-7686-9-git-send-email-ygardi@codeaurora.org>
References: <1442155977-7686-1-git-send-email-ygardi@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1442155977-7686-1-git-send-email-ygardi@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, pebolle@tiscali.nl, hch@infradead.org
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, subhashj@codeaurora.org, ygardi@codeaurora.org, gbroner@codeaurora.org, draviv@codeaurora.org, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@odin.com>
List-Id: linux-scsi@vger.kernel.org

Currently when UFSHCD_BROKEN_LCC quirk is defined, LCC is getting
disabled on both host and device side but there could be a need
where we don't want to disable the LCC on both side hence this change
splits the quirk in 2 parts one for host and one for device.

Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>

---
 drivers/scsi/ufs/ufshcd.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 0803a89..411ec17 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -3048,6 +3048,11 @@ static int ufshcd_disable_tx_lcc(struct ufs_hba *hba, bool peer)
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
@@ -3095,6 +3100,12 @@ static int ufshcd_link_startup(struct ufs_hba *hba)
 			goto out;
 	}
 
+	if (hba->dev_quirks & UFS_DEVICE_QUIRK_BROKEN_LCC) {
+		ret = ufshcd_disable_host_tx_lcc(hba);
+		if (ret)
+			goto out;
+	}
+
 	/* Include any host controller configuration via UIC commands */
 	ret = ufshcd_vops_link_startup_notify(hba, POST_CHANGE);
 	if (ret)
-- 
1.8.5.2

-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

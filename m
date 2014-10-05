From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH -next] scsi: ufs: fix configuring power mode after UIC link down
Date: Sun,  5 Oct 2014 16:20:38 +0900
Message-ID: <1412493638-24522-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f178.google.com ([209.85.192.178]:63347 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898AbaJEHVL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 5 Oct 2014 03:21:11 -0400
Received: by mail-pd0-f178.google.com with SMTP id y10so1677646pdj.37
        for <linux-scsi@vger.kernel.org>; Sun, 05 Oct 2014 00:21:10 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Akinobu Mita <mita@fixstars.com>, Vinayak Holikatti <vinholikatti@gmail.com>, Santosh Y <santoshsy@gmail.com>, Dolev Raviv <draviv@codeaurora.org>, Subhash Jadavani <subhashj@codeaurora.org>, Yaniv Gardi <ygardi@codeaurora.org>, Christoph Hellwig <hch@lst.de>, "James E.J. Bottomley" <JBottomley@parallels.com>

If the UFS Power management level 5 is chosen, the UIC link is down
during suspend.  And the power mode should be configured again during
resume.  Unfortunately, it will not be configured because
ufshcd_change_power_mode() tries to avoid unnecessary power mode change
if the requested power mode and current power mode are same, but it
can't detect there has been UIC link down.

This fixes it by changing the type of hba->pwr_info to struct
ufs_pwr_mode_info in order to detect UIC link down in
ufshcd_change_power_mode(), and turn off hba->pwr_info.is_valid when UIC
link is down.

Signed-off-by: Akinobu Mita <mita@fixstars.com>
Cc: Vinayak Holikatti <vinholikatti@gmail.com>
Cc: Santosh Y <santoshsy@gmail.com>
Cc: Dolev Raviv <draviv@codeaurora.org>
Cc: Subhash Jadavani <subhashj@codeaurora.org>
Cc: Yaniv Gardi <ygardi@codeaurora.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/ufs/ufshcd.c | 22 +++++++++++++---------
 drivers/scsi/ufs/ufshcd.h |  2 +-
 2 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 497c38a..2d81578 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2240,6 +2240,7 @@ static int ufshcd_uic_hibern8_exit(struct ufs_hba *hba)
 	ret = ufshcd_uic_pwr_ctrl(hba, &uic_cmd);
 	if (ret) {
 		ufshcd_set_link_off(hba);
+		hba->pwr_info.is_valid = false;
 		ret = ufshcd_host_reset_and_restore(hba);
 	}
 
@@ -2315,13 +2316,14 @@ static int ufshcd_change_power_mode(struct ufs_hba *hba,
 	int ret;
 
 	/* if already configured to the requested pwr_mode */
-	if (pwr_mode->gear_rx == hba->pwr_info.gear_rx &&
-	    pwr_mode->gear_tx == hba->pwr_info.gear_tx &&
-	    pwr_mode->lane_rx == hba->pwr_info.lane_rx &&
-	    pwr_mode->lane_tx == hba->pwr_info.lane_tx &&
-	    pwr_mode->pwr_rx == hba->pwr_info.pwr_rx &&
-	    pwr_mode->pwr_tx == hba->pwr_info.pwr_tx &&
-	    pwr_mode->hs_rate == hba->pwr_info.hs_rate) {
+	if (hba->pwr_info.is_valid &&
+	    pwr_mode->gear_rx == hba->pwr_info.info.gear_rx &&
+	    pwr_mode->gear_tx == hba->pwr_info.info.gear_tx &&
+	    pwr_mode->lane_rx == hba->pwr_info.info.lane_rx &&
+	    pwr_mode->lane_tx == hba->pwr_info.info.lane_tx &&
+	    pwr_mode->pwr_rx == hba->pwr_info.info.pwr_rx &&
+	    pwr_mode->pwr_tx == hba->pwr_info.info.pwr_tx &&
+	    pwr_mode->hs_rate == hba->pwr_info.info.hs_rate) {
 		dev_dbg(hba->dev, "%s: power already configured\n", __func__);
 		return 0;
 	}
@@ -2368,8 +2370,8 @@ static int ufshcd_change_power_mode(struct ufs_hba *hba,
 			hba->vops->pwr_change_notify(hba,
 				POST_CHANGE, NULL, pwr_mode);
 
-		memcpy(&hba->pwr_info, pwr_mode,
-			sizeof(struct ufs_pa_layer_attr));
+		hba->pwr_info.info = *pwr_mode;
+		hba->pwr_info.is_valid = true;
 	}
 
 	return ret;
@@ -4755,6 +4757,7 @@ static int ufshcd_link_state_transition(struct ufs_hba *hba,
 		 * controller is reset
 		 */
 		ufshcd_set_link_off(hba);
+		hba->pwr_info.is_valid = false;
 	}
 
 out:
@@ -5463,6 +5466,7 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 	host->unique_id = host->host_no;
 	host->max_cmd_len = MAX_CDB_SIZE;
 
+	hba->pwr_info.is_valid = false;
 	hba->max_pwr_info.is_valid = false;
 
 	/* Initailize wait queue for task management */
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 58ecdff..b514f25 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -457,7 +457,7 @@ struct ufs_hba {
 
 	bool wlun_dev_clr_ua;
 
-	struct ufs_pa_layer_attr pwr_info;
+	struct ufs_pwr_mode_info pwr_info;
 	struct ufs_pwr_mode_info max_pwr_info;
 
 	struct ufs_clk_gating clk_gating;
-- 
1.9.1


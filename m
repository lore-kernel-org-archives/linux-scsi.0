From: Subhash Jadavani <subhashj@codeaurora.org>
Subject: [PATCH v1 07/11] scsi: ufs: issue link starup 2 times if device isn't active
Date: Wed, 23 Nov 2016 16:32:20 -0800
Message-ID: <1479947541-7176-1-git-send-email-subhashj@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: Subhash Jadavani <subhashj@codeaurora.org>, "open list:UNIVERSAL FLASH STORAGE HOST
        CONTROLLER DRIVER" <linux-scsi@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

If we issue the link startup to the device while its UniPro state is
LinkDown (and device state is sleep/power-down) then link startup
will not move the device state to Active. Device will only move to
active state if the link starup is issued when its UniPro state is
LinkUp. So in this case, we would have to issue the link startup 2
times to make sure that device moves to active state.

Reviewed-by: Gilad Broner <gbroner@codeaurora.org>
Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd.c | 23 ++++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 28cbca2..16c5c50 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -3185,7 +3185,16 @@ static int ufshcd_link_startup(struct ufs_hba *hba)
 {
 	int ret;
 	int retries = DME_LINKSTARTUP_RETRIES;
+	bool link_startup_again = false;
 
+	/*
+	 * If UFS device isn't active then we will have to issue link startup
+	 * 2 times to make sure the device state move to active.
+	 */
+	if (!ufshcd_is_ufs_dev_active(hba))
+		link_startup_again = true;
+
+link_startup:
 	do {
 		ufshcd_vops_link_startup_notify(hba, PRE_CHANGE);
 
@@ -3211,6 +3220,12 @@ static int ufshcd_link_startup(struct ufs_hba *hba)
 		/* failed to get the link up... retire */
 		goto out;
 
+	if (link_startup_again) {
+		link_startup_again = false;
+		retries = DME_LINKSTARTUP_RETRIES;
+		goto link_startup;
+	}
+
 	if (hba->quirks & UFSHCD_QUIRK_BROKEN_LCC) {
 		ret = ufshcd_disable_device_tx_lcc(hba);
 		if (ret)
@@ -6744,10 +6759,12 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 	pm_runtime_get_sync(dev);
 
 	/*
-	 * The device-initialize-sequence hasn't been invoked yet.
-	 * Set the device to power-off state
+	 * We are assuming that device wasn't put in sleep/power-down
+	 * state exclusively during the boot stage before kernel.
+	 * This assumption helps avoid doing link startup twice during
+	 * ufshcd_probe_hba().
 	 */
-	ufshcd_set_ufs_dev_poweroff(hba);
+	ufshcd_set_ufs_dev_active(hba);
 
 	async_schedule(ufshcd_async_scan, hba);
 
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

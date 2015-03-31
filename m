From: Yaniv Gardi <ygardi@codeaurora.org>
Subject: [PATCH v1 2/2] scsi: ufs: add support to allow non standard behaviours (quirks)
Date: Tue, 31 Mar 2015 17:37:14 +0300
Message-ID: <1427812635-16617-3-git-send-email-ygardi@codeaurora.org>
References: <1427812635-16617-1-git-send-email-ygardi@codeaurora.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:54900 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754854AbbCaOhk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 31 Mar 2015 10:37:40 -0400
In-Reply-To: <1427812635-16617-1-git-send-email-ygardi@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, hch@infradead.org
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, ygardi@codeaurora.org, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@parallels.com>

Some implementation of UFS host controller HW might have some non-standard
behaviours (quirks) when compared to behaviour specified by UFSHCI
specification. This patch add support to allow specifying all such quirks
to standard UFS host controller driver so standard driver takes them into
account.

In this change a UFSHCD_QUIRK_DELAY_BEFORE_DME_CMDS is introduced,
where a minimum delay of 1ms is required before DME commands for
stability purposes.

Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>

---
 drivers/scsi/ufs/ufs-qcom.c | 22 +++++++++++++++++-----
 drivers/scsi/ufs/ufs-qcom.h | 18 ++++++++++++++++++
 drivers/scsi/ufs/ufshcd.c   | 35 +++++++++++++++++++++++++++++++++++
 drivers/scsi/ufs/ufshcd.h   |  9 +++++++++
 4 files changed, 79 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
index d7cb843..6652a81 100644
--- a/drivers/scsi/ufs/ufs-qcom.c
+++ b/drivers/scsi/ufs/ufs-qcom.c
@@ -694,13 +694,24 @@ out:
  */
 static void ufs_qcom_advertise_quirks(struct ufs_hba *hba)
 {
+	struct ufs_qcom_host *host = hba->priv;
 
+	if (host->hw_ver.major == 0x1)
+		hba->quirks |= UFSHCD_QUIRK_DELAY_BEFORE_DME_CMDS;
 
-	/*
-	 * TBD
-	 * here we should be advertising controller quirks according to
-	 * controller version.
-	 */
+	if (host->hw_ver.major >= 0x2) {
+		if (!ufs_qcom_cap_qunipro(host))
+			/* Legacy UniPro mode still need following quirks */
+			hba->quirks |= UFSHCD_QUIRK_DELAY_BEFORE_DME_CMDS;
+	}
+}
+
+static void ufs_qcom_set_caps(struct ufs_hba *hba)
+{
+	struct ufs_qcom_host *host = hba->priv;
+
+	if (host->hw_ver.major >= 0x2)
+		host->caps = UFS_QCOM_CAP_QUNIPRO;
 }
 
 static int ufs_qcom_get_bus_vote(struct ufs_qcom_host *host,
@@ -938,6 +949,7 @@ static int ufs_qcom_init(struct ufs_hba *hba)
 	if (err)
 		goto out_disable_phy;
 
+	ufs_qcom_set_caps(hba);
 	ufs_qcom_advertise_quirks(hba);
 
 	hba->caps |= UFSHCD_CAP_CLK_GATING | UFSHCD_CAP_CLK_SCALING;
diff --git a/drivers/scsi/ufs/ufs-qcom.h b/drivers/scsi/ufs/ufs-qcom.h
index 9037396..db2c0a0 100644
--- a/drivers/scsi/ufs/ufs-qcom.h
+++ b/drivers/scsi/ufs/ufs-qcom.h
@@ -158,6 +158,16 @@ struct ufs_hw_version {
 	u8 major;
 };
 struct ufs_qcom_host {
+
+	/*
+	 * Set this capability if host controller supports the QUniPro mode
+	 * and if driver wants the Host controller to operate in QUniPro mode.
+	 * Note: By default this capability will be kept enabled if host
+	 * controller supports the QUniPro mode.
+	 */
+	#define UFS_QCOM_CAP_QUNIPRO	UFS_BIT(0)
+	u32 caps;
+
 	struct phy *generic_phy;
 	struct ufs_hba *hba;
 	struct ufs_qcom_bus_vote bus_vote;
@@ -175,4 +185,12 @@ struct ufs_qcom_host {
 #define ufs_qcom_is_link_active(hba) ufshcd_is_link_active(hba)
 #define ufs_qcom_is_link_hibern8(hba) ufshcd_is_link_hibern8(hba)
 
+static inline bool ufs_qcom_cap_qunipro(struct ufs_qcom_host *host)
+{
+	if (host->caps & UFS_QCOM_CAP_QUNIPRO)
+		return true;
+	else
+		return false;
+}
+
 #endif /* UFS_QCOM_H_ */
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 5d60a86..dfd72af 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -183,6 +183,7 @@ static int __ufshcd_setup_clocks(struct ufs_hba *hba, bool on,
 static int ufshcd_setup_clocks(struct ufs_hba *hba, bool on);
 static int ufshcd_uic_hibern8_exit(struct ufs_hba *hba);
 static int ufshcd_uic_hibern8_enter(struct ufs_hba *hba);
+static inline void ufshcd_add_delay_before_dme_cmd(struct ufs_hba *hba);
 static int ufshcd_host_reset_and_restore(struct ufs_hba *hba);
 static irqreturn_t ufshcd_intr(int irq, void *__hba);
 static int ufshcd_config_pwr_mode(struct ufs_hba *hba,
@@ -972,6 +973,8 @@ ufshcd_send_uic_cmd(struct ufs_hba *hba, struct uic_command *uic_cmd)
 
 	ufshcd_hold(hba, false);
 	mutex_lock(&hba->uic_cmd_mutex);
+	ufshcd_add_delay_before_dme_cmd(hba);
+
 	spin_lock_irqsave(hba->host->host_lock, flags);
 	ret = __ufshcd_send_uic_cmd(hba, uic_cmd);
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
@@ -2058,6 +2061,37 @@ static int ufshcd_dme_link_startup(struct ufs_hba *hba)
 	return ret;
 }
 
+static inline void ufshcd_add_delay_before_dme_cmd(struct ufs_hba *hba)
+{
+	#define MIN_DELAY_BEFORE_DME_CMDS_US	1000
+	unsigned long min_sleep_time_us;
+
+	if (!(hba->quirks & UFSHCD_QUIRK_DELAY_BEFORE_DME_CMDS))
+		return;
+
+	/*
+	 * last_dme_cmd_tstamp will be 0 only for 1st call to
+	 * this function
+	 */
+	if (unlikely(!ktime_to_us(hba->last_dme_cmd_tstamp))) {
+		min_sleep_time_us = MIN_DELAY_BEFORE_DME_CMDS_US;
+	} else {
+		unsigned long delta =
+			(unsigned long) ktime_to_us(
+				ktime_sub(ktime_get(),
+				hba->last_dme_cmd_tstamp));
+
+		if (delta < MIN_DELAY_BEFORE_DME_CMDS_US)
+			min_sleep_time_us =
+				MIN_DELAY_BEFORE_DME_CMDS_US - delta;
+		else
+			return; /* no more delay required */
+	}
+
+	/* allow sleep for extra 50us if needed */
+	usleep_range(min_sleep_time_us, min_sleep_time_us + 50);
+}
+
 /**
  * ufshcd_dme_set_attr - UIC command for DME_SET, DME_PEER_SET
  * @hba: per adapter instance
@@ -2157,6 +2191,7 @@ static int ufshcd_uic_pwr_ctrl(struct ufs_hba *hba, struct uic_command *cmd)
 
 	mutex_lock(&hba->uic_cmd_mutex);
 	init_completion(&uic_async_done);
+	ufshcd_add_delay_before_dme_cmd(hba);
 
 	spin_lock_irqsave(hba->host->host_lock, flags);
 	hba->uic_async_done = &uic_async_done;
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 4a574aa..b47ff07 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -366,6 +366,7 @@ struct ufs_init_prefetch {
  * @saved_err: sticky error mask
  * @saved_uic_err: sticky UIC error mask
  * @dev_cmd: ufs device management command information
+ * @last_dme_cmd_tstamp: time stamp of the last completed DME command
  * @auto_bkops_enabled: to track whether bkops is enabled in device
  * @vreg_info: UFS device voltage regulator information
  * @clk_list_head: UFS host controller clocks list node head
@@ -416,6 +417,13 @@ struct ufs_hba {
 	unsigned int irq;
 	bool is_irq_enabled;
 
+	/*
+	 * delay before each dme command is required as the unipro
+	 * layer has shown instabilities
+	 */
+	#define UFSHCD_QUIRK_DELAY_BEFORE_DME_CMDS		UFS_BIT(0)
+
+	unsigned int quirks;	/* Deviations from standard UFSHCI spec. */
 
 	wait_queue_head_t tm_wq;
 	wait_queue_head_t tm_tag_wq;
@@ -446,6 +454,7 @@ struct ufs_hba {
 
 	/* Device management request data */
 	struct ufs_dev_cmd dev_cmd;
+	ktime_t last_dme_cmd_tstamp;
 
 	/* Keeps information of the UFS device connected to this host */
 	struct ufs_dev_info dev_info;
-- 
1.8.5.2

-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

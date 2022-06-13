Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4958C43334
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jun 2022 10:07:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240846AbiFMKH0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Jun 2022 06:07:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239648AbiFMKHG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Jun 2022 06:07:06 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B011425FE
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jun 2022 03:07:05 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id m20so10124595ejj.10
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jun 2022 03:07:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nyX3Q3rQQM2IsC6FFrgRDtgxd8UP6+kxf/OJYst5UXA=;
        b=nyCWPHxIGKa2NB5OHYiSyem5xuy6+kXjlO9RrgVfZL+LLd23RIjjmQX66HJL8NIYmH
         qF2KKYqmXcquxwaqa14kZEhuU/AaqSJiy/z5rb1RcyDAu9jjVpXzvPZCA6tOSo7nzd6y
         UhKXG4bt+S6iTSMIkTYRQ228IQ5XsdvJkJ/xWrmupMtG4+0+seyCR98xMpyNx9/OXGW/
         Em9fccEdZ+yDexaflRVSWUZ4Y+OYecjtThEhqA1qoBsoKKIh01Gn+hqLqVAV0jJmUrEr
         LtltEO0pyw5S5J5cyDrPoZRpsB3XFScAYuQbtIMHlW2mXtffInZPtxQwQNKVZFK5YAmI
         xonQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nyX3Q3rQQM2IsC6FFrgRDtgxd8UP6+kxf/OJYst5UXA=;
        b=tQcp4mQY64yYvpVmJ29N2OG7mOWWmJxNc2u5bZhF9WWgSObXZRuhdV1E/gRFREZNSS
         1AMQ7fe2svAiKStSvGBRtYBk7RqkPJ+v20QOKaR8LNM4wXjjZaO+Brd+Kpbwlb4qOpoi
         z1cCTZT/BcGblQF6IQTTkE6CZlLBNty/2MTLszaQzLEvx9MXPcaVzsQHLSkcJFlOavzh
         PwJlaATpE0AjoeVndHa9LsCGutRTo157o9ppIGWGBBM+UbFJ9UwKoWYAIL37cZWNrFxN
         8RZF5q3USBc2vRnSGP+D7o1HgJ5NR9KjphngYqIHIg3oVvka01fci63OMXhMtmpV6NAK
         OtCw==
X-Gm-Message-State: AOAM532rkWODZWLpjJ1NFsAqOK9R3uYiwPDk87VbuHl/LlnG9O94EQd4
        A5TFzYmoDgouYa8OUr7FwMQwhw==
X-Google-Smtp-Source: ABdhPJzWkcnRCWVe/fTvWG3tCIJR5yjLJBH55iEtG+cyP0Xrqj/+5gHFUwbKjtBy0csgJHIUqA2EDA==
X-Received: by 2002:a17:907:1250:b0:711:d0bc:2370 with SMTP id wc16-20020a170907125000b00711d0bc2370mr34681686ejb.454.1655114824203;
        Mon, 13 Jun 2022 03:07:04 -0700 (PDT)
Received: from krzk-bin.monzoon.net (80-254-69-65.dynamic.monzoon.net. [80.254.69.65])
        by smtp.gmail.com with ESMTPSA id v2-20020a170906858200b006fe921fcb2dsm3639911ejx.49.2022.06.13.03.07.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jun 2022 03:07:03 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Doug Gilbert <dgilbert@interlog.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH v3 3/3] scsi: ufs: ufshcd: constify pointed data
Date:   Mon, 13 Jun 2022 12:06:55 +0200
Message-Id: <20220613100655.105301-4-krzysztof.kozlowski@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220613100655.105301-1-krzysztof.kozlowski@linaro.org>
References: <20220613100655.105301-1-krzysztof.kozlowski@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Constify arrays and pointers to data which is not modified for code
safety.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
---
 drivers/ufs/core/ufshcd-priv.h |  6 ++---
 drivers/ufs/core/ufshcd.c      | 42 ++++++++++++++++++----------------
 include/ufs/ufshcd.h           |  6 ++---
 3 files changed, 28 insertions(+), 26 deletions(-)

diff --git a/drivers/ufs/core/ufshcd-priv.h b/drivers/ufs/core/ufshcd-priv.h
index ffb01fc6de75..8f67db202d7b 100644
--- a/drivers/ufs/core/ufshcd-priv.h
+++ b/drivers/ufs/core/ufshcd-priv.h
@@ -215,7 +215,7 @@ static inline void ufshcd_vops_config_scaling_param(struct ufs_hba *hba,
 		hba->vops->config_scaling_param(hba, p, data);
 }
 
-extern struct ufs_pm_lvl_states ufs_pm_lvl_states[];
+extern const struct ufs_pm_lvl_states ufs_pm_lvl_states[];
 
 /**
  * ufshcd_scsi_to_upiu_lun - maps scsi LUN to UPIU LUN
@@ -234,8 +234,8 @@ static inline u8 ufshcd_scsi_to_upiu_lun(unsigned int scsi_lun)
 
 int __ufshcd_write_ee_control(struct ufs_hba *hba, u32 ee_ctrl_mask);
 int ufshcd_write_ee_control(struct ufs_hba *hba);
-int ufshcd_update_ee_control(struct ufs_hba *hba, u16 *mask, u16 *other_mask,
-			     u16 set, u16 clr);
+int ufshcd_update_ee_control(struct ufs_hba *hba, u16 *mask,
+			     const u16 *other_mask, u16 set, u16 clr);
 
 static inline int ufshcd_update_ee_drv_mask(struct ufs_hba *hba,
 					    u16 set, u16 clr)
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 01fb4bad86be..59f73d67a673 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -175,7 +175,7 @@ enum {
 #define ufshcd_clear_eh_in_progress(h) \
 	((h)->eh_flags &= ~UFSHCD_EH_IN_PROGRESS)
 
-struct ufs_pm_lvl_states ufs_pm_lvl_states[] = {
+const struct ufs_pm_lvl_states ufs_pm_lvl_states[] = {
 	[UFS_PM_LVL_0] = {UFS_ACTIVE_PWR_MODE, UIC_LINK_ACTIVE_STATE},
 	[UFS_PM_LVL_1] = {UFS_ACTIVE_PWR_MODE, UIC_LINK_HIBERN8_STATE},
 	[UFS_PM_LVL_2] = {UFS_SLEEP_PWR_MODE, UIC_LINK_ACTIVE_STATE},
@@ -363,7 +363,7 @@ static void ufshcd_add_tm_upiu_trace(struct ufs_hba *hba, unsigned int tag,
 }
 
 static void ufshcd_add_uic_command_trace(struct ufs_hba *hba,
-					 struct uic_command *ucmd,
+					 const struct uic_command *ucmd,
 					 enum ufs_trace_str_t str_t)
 {
 	u32 cmd;
@@ -443,11 +443,11 @@ static void ufshcd_print_clk_freqs(struct ufs_hba *hba)
 }
 
 static void ufshcd_print_evt(struct ufs_hba *hba, u32 id,
-			     char *err_name)
+			     const char *err_name)
 {
 	int i;
 	bool found = false;
-	struct ufs_event_hist *e;
+	const struct ufs_event_hist *e;
 
 	if (id >= UFS_EVT_CNT)
 		return;
@@ -497,7 +497,7 @@ static void ufshcd_print_evt_hist(struct ufs_hba *hba)
 static
 void ufshcd_print_trs(struct ufs_hba *hba, unsigned long bitmap, bool pr_prdt)
 {
-	struct ufshcd_lrb *lrbp;
+	const struct ufshcd_lrb *lrbp;
 	int prdt_length;
 	int tag;
 
@@ -553,7 +553,7 @@ static void ufshcd_print_tmrs(struct ufs_hba *hba, unsigned long bitmap)
 
 static void ufshcd_print_host_state(struct ufs_hba *hba)
 {
-	struct scsi_device *sdev_ufs = hba->ufs_device_wlun;
+	const struct scsi_device *sdev_ufs = hba->ufs_device_wlun;
 
 	dev_err(hba->dev, "UFS Host state=%d\n", hba->ufshcd_state);
 	dev_err(hba->dev, "outstanding reqs=0x%lx tasks=0x%lx\n",
@@ -1098,7 +1098,7 @@ static bool ufshcd_is_devfreq_scaling_required(struct ufs_hba *hba,
  */
 static u32 ufshcd_pending_cmds(struct ufs_hba *hba)
 {
-	struct scsi_device *sdev;
+	const struct scsi_device *sdev;
 	u32 pending = 0;
 
 	lockdep_assert_held(hba->host->host_lock);
@@ -2069,14 +2069,15 @@ static inline int ufshcd_monitor_opcode2dir(u8 opcode)
 static inline bool ufshcd_should_inform_monitor(struct ufs_hba *hba,
 						struct ufshcd_lrb *lrbp)
 {
-	struct ufs_hba_monitor *m = &hba->monitor;
+	const struct ufs_hba_monitor *m = &hba->monitor;
 
 	return (m->enabled && lrbp && lrbp->cmd &&
 		(!m->chunk_size || m->chunk_size == lrbp->cmd->sdb.length) &&
 		ktime_before(hba->monitor.enabled_ts, lrbp->issue_time_stamp));
 }
 
-static void ufshcd_start_monitor(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
+static void ufshcd_start_monitor(struct ufs_hba *hba,
+				 const struct ufshcd_lrb *lrbp)
 {
 	int dir = ufshcd_monitor_opcode2dir(*lrbp->cmd->cmnd);
 	unsigned long flags;
@@ -2087,14 +2088,14 @@ static void ufshcd_start_monitor(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 }
 
-static void ufshcd_update_monitor(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
+static void ufshcd_update_monitor(struct ufs_hba *hba, const struct ufshcd_lrb *lrbp)
 {
 	int dir = ufshcd_monitor_opcode2dir(*lrbp->cmd->cmnd);
 	unsigned long flags;
 
 	spin_lock_irqsave(hba->host->host_lock, flags);
 	if (dir >= 0 && hba->monitor.nr_queued[dir] > 0) {
-		struct request *req = scsi_cmd_to_rq(lrbp->cmd);
+		const struct request *req = scsi_cmd_to_rq(lrbp->cmd);
 		struct ufs_hba_monitor *m = &hba->monitor;
 		ktime_t now, inc, lat;
 
@@ -4899,7 +4900,7 @@ static int ufshcd_get_lu_wp(struct ufs_hba *hba,
  *
  */
 static inline void ufshcd_get_lu_power_on_wp_status(struct ufs_hba *hba,
-						    struct scsi_device *sdev)
+						    const struct scsi_device *sdev)
 {
 	if (hba->dev_info.f_power_on_wp_en &&
 	    !hba->dev_info.is_lu_power_on_wp) {
@@ -5418,8 +5419,8 @@ int ufshcd_write_ee_control(struct ufs_hba *hba)
 	return err;
 }
 
-int ufshcd_update_ee_control(struct ufs_hba *hba, u16 *mask, u16 *other_mask,
-			     u16 set, u16 clr)
+int ufshcd_update_ee_control(struct ufs_hba *hba, u16 *mask,
+			     const u16 *other_mask, u16 set, u16 clr)
 {
 	u16 new_mask, ee_ctrl_mask;
 	int err = 0;
@@ -7346,7 +7347,8 @@ static int ufshcd_eh_host_reset_handler(struct scsi_cmnd *cmd)
  *
  * Returns calculated max ICC level for specific regulator
  */
-static u32 ufshcd_get_max_icc_level(int sup_curr_uA, u32 start_scan, char *buff)
+static u32 ufshcd_get_max_icc_level(int sup_curr_uA, u32 start_scan,
+				    const char *buff)
 {
 	int i;
 	int curr_uA;
@@ -7393,7 +7395,7 @@ static u32 ufshcd_get_max_icc_level(int sup_curr_uA, u32 start_scan, char *buff)
  * Returns calculated ICC level
  */
 static u32 ufshcd_find_max_sup_active_icc_level(struct ufs_hba *hba,
-							u8 *desc_buf, int len)
+						const u8 *desc_buf, int len)
 {
 	u32 icc_level = 0;
 
@@ -7543,7 +7545,7 @@ static int ufshcd_scsi_add_wlus(struct ufs_hba *hba)
 	return ret;
 }
 
-static void ufshcd_wb_probe(struct ufs_hba *hba, u8 *desc_buf)
+static void ufshcd_wb_probe(struct ufs_hba *hba, const u8 *desc_buf)
 {
 	struct ufs_dev_info *dev_info = &hba->dev_info;
 	u8 lun;
@@ -7614,7 +7616,7 @@ static void ufshcd_wb_probe(struct ufs_hba *hba, u8 *desc_buf)
 	hba->caps &= ~UFSHCD_CAP_WB_EN;
 }
 
-static void ufshcd_temp_notif_probe(struct ufs_hba *hba, u8 *desc_buf)
+static void ufshcd_temp_notif_probe(struct ufs_hba *hba, const u8 *desc_buf)
 {
 	struct ufs_dev_info *dev_info = &hba->dev_info;
 	u32 ext_ufs_feature;
@@ -7848,7 +7850,7 @@ static int ufshcd_quirk_tune_host_pa_tactivate(struct ufs_hba *hba)
 	u32 granularity, peer_granularity;
 	u32 pa_tactivate, peer_pa_tactivate;
 	u32 pa_tactivate_us, peer_pa_tactivate_us;
-	u8 gran_to_us_table[] = {1, 4, 8, 16, 32, 100};
+	const u8 gran_to_us_table[] = {1, 4, 8, 16, 32, 100};
 
 	ret = ufshcd_dme_get(hba, UIC_ARG_MIB(PA_GRANULARITY),
 				  &granularity);
@@ -7965,7 +7967,7 @@ struct ufs_ref_clk {
 	enum ufs_ref_clk_freq val;
 };
 
-static struct ufs_ref_clk ufs_ref_clk_freqs[] = {
+static const struct ufs_ref_clk ufs_ref_clk_freqs[] = {
 	{19200000, REF_CLK_FREQ_19_2_MHZ},
 	{26000000, REF_CLK_FREQ_26_MHZ},
 	{38400000, REF_CLK_FREQ_38_4_MHZ},
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index a92271421718..4f0531af9141 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -1217,14 +1217,14 @@ static inline int ufshcd_vops_phy_initialization(struct ufs_hba *hba)
 	return 0;
 }
 
-extern struct ufs_pm_lvl_states ufs_pm_lvl_states[];
+extern const struct ufs_pm_lvl_states ufs_pm_lvl_states[];
 
 int ufshcd_dump_regs(struct ufs_hba *hba, size_t offset, size_t len,
 		     const char *prefix);
 
 int __ufshcd_write_ee_control(struct ufs_hba *hba, u32 ee_ctrl_mask);
 int ufshcd_write_ee_control(struct ufs_hba *hba);
-int ufshcd_update_ee_control(struct ufs_hba *hba, u16 *mask, u16 *other_mask,
-			     u16 set, u16 clr);
+int ufshcd_update_ee_control(struct ufs_hba *hba, u16 *mask,
+			     const u16 *other_mask, u16 set, u16 clr);
 
 #endif /* End of Header */
-- 
2.34.1


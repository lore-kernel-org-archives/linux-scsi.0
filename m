Return-Path: <SRS0=AKtJ=6V=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C75CC35280
	for <linux-scsi@archiver.kernel.org>; Thu,  7 May 2020 22:28:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EE7DA20870
	for <linux-scsi@archiver.kernel.org>; Thu,  7 May 2020 22:27:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726531AbgEGW17 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 May 2020 18:27:59 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:39558 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726437AbgEGW17 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 May 2020 18:27:59 -0400
Received: by mail-pg1-f195.google.com with SMTP id 207so3446657pgc.6
        for <linux-scsi@vger.kernel.org>; Thu, 07 May 2020 15:27:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=V4lYMmUbKo3pO/qc1HQ4cDH6hUpGvXDFWP1TzYRjuZ0=;
        b=hj+mm0HsN0tW/ohoTk4Ilsxjze75w3mNNs/kYUqnKgx8KWYjHmv/+MmMn+e9c31HEv
         ewSMPVHMI7PkgWHTh38zzVeHEwl+8YoDAPhx6PhnbWDyoU0LBRtvR/dpZG4jJ2E8UdEJ
         eMoxibKPT2J+7oTNOJTC6Jt8d+5SVXgBJLb4wfla5xA2uxGv08jkkHH+Q++GBLxaQffm
         jW0QHo5wb3tZdfkCKTrhho/tXQy4fFEsnjNG4Jz0a5JkPAAfs8E8aKy+UxYsbVw1SOJZ
         vvLhYxIbKNqulA1PbkwqhLh+JWVUpIA/tJ4aNudTPs40dg3lDJU0bUHEQRn1q0X83E7l
         IdjQ==
X-Gm-Message-State: AGi0PubdyLWDl7diWx907MyM/S9Q/O9+0gU8yaVxZrQmiCYsUKx6ZeSI
        A/OSAGKGsHu4VGzs0kT4xr0=
X-Google-Smtp-Source: APiQypKy4uIAD/RAEj9esE4R5ImhPdvw8C+qo62+d9ob/eoZwH5ghHTSd9tDc3CFHO+OZpHF9rEKlw==
X-Received: by 2002:a63:5055:: with SMTP id q21mr12879803pgl.127.1588890477415;
        Thu, 07 May 2020 15:27:57 -0700 (PDT)
Received: from localhost.localdomain ([2601:647:4000:d7:8ce8:d4c:1f4f:21e0])
        by smtp.gmail.com with ESMTPSA id m63sm6048425pfb.101.2020.05.07.15.27.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 May 2020 15:27:56 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Can Guo <cang@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Asutosh Das <asutoshd@codeaurora.org>
Subject: [PATCH RFC] ufs: Make ufshcd_wait_for_register() sleep instead of busy-waiting
Date:   Thu,  7 May 2020 15:27:50 -0700
Message-Id: <20200507222750.19113-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The ufshcd_wait_for_register() function either sleeps or spins until the
specified register has reached the desired value. Busy-waiting is not
only considered a bad practice but also has a bad impact on energy
consumption. Always sleep instead of spinning by making sure that all
ufshcd_wait_for_register() calls happen from a context where it is
allowed to sleep. The only function call that has to be moved is the
ufshcd_hba_stop() call in ufshcd_host_reset_and_restore().

Cc: Can Guo <cang@codeaurora.org>
Cc: Avri Altman <avri.altman@wdc.com>
Cc: Bean Huo <beanhuo@micron.com>
Cc: Alim Akhtar <alim.akhtar@samsung.com>
Cc: Asutosh Das <asutoshd@codeaurora.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshcd.c | 51 +++++++++++++++++++++------------------
 drivers/scsi/ufs/ufshcd.h |  2 +-
 2 files changed, 29 insertions(+), 24 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index bf7caea2253b..72069d4faa1e 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -563,21 +563,21 @@ void ufshcd_delay_us(unsigned long us, unsigned long tolerance)
 }
 EXPORT_SYMBOL_GPL(ufshcd_delay_us);
 
-/*
+/**
  * ufshcd_wait_for_register - wait for register value to change
- * @hba - per-adapter interface
- * @reg - mmio register offset
- * @mask - mask to apply to read register value
- * @val - wait condition
- * @interval_us - polling interval in microsecs
- * @timeout_ms - timeout in millisecs
- * @can_sleep - perform sleep or just spin
+ * @hba: per-adapter interface
+ * @reg: mmio register offset
+ * @mask: mask to apply to the read register value
+ * @val: value to wait for
+ * @interval_us: polling interval in microseconds
+ * @timeout_ms: timeout in milliseconds
  *
- * Returns -ETIMEDOUT on error, zero on success
+ * Return:
+ * -ETIMEDOUT on error, zero on success.
  */
 int ufshcd_wait_for_register(struct ufs_hba *hba, u32 reg, u32 mask,
 				u32 val, unsigned long interval_us,
-				unsigned long timeout_ms, bool can_sleep)
+				unsigned long timeout_ms)
 {
 	int err = 0;
 	unsigned long timeout = jiffies + msecs_to_jiffies(timeout_ms);
@@ -586,10 +586,7 @@ int ufshcd_wait_for_register(struct ufs_hba *hba, u32 reg, u32 mask,
 	val = val & mask;
 
 	while ((ufshcd_readl(hba, reg) & mask) != val) {
-		if (can_sleep)
-			usleep_range(interval_us, interval_us + 50);
-		else
-			udelay(interval_us);
+		usleep_range(interval_us, interval_us + 50);
 		if (time_after(jiffies, timeout)) {
 			if ((ufshcd_readl(hba, reg) & mask) != val)
 				err = -ETIMEDOUT;
@@ -2589,7 +2586,7 @@ ufshcd_clear_cmd(struct ufs_hba *hba, int tag)
 	 */
 	err = ufshcd_wait_for_register(hba,
 			REG_UTP_TRANSFER_REQ_DOOR_BELL,
-			mask, ~mask, 1000, 1000, true);
+			mask, ~mask, 1000, 1000);
 
 	return err;
 }
@@ -4258,16 +4255,23 @@ EXPORT_SYMBOL_GPL(ufshcd_make_hba_operational);
 /**
  * ufshcd_hba_stop - Send controller to reset state
  * @hba: per adapter instance
- * @can_sleep: perform sleep or just spin
  */
-static inline void ufshcd_hba_stop(struct ufs_hba *hba, bool can_sleep)
+static inline void ufshcd_hba_stop(struct ufs_hba *hba)
 {
+	unsigned long flags;
 	int err;
 
+	/*
+	 * Obtain the host lock to prevent that the controller is disabled
+	 * while the UFS interrupt handler is active on another CPU.
+	 */
+	spin_lock_irqsave(hba->host->host_lock, flags);
 	ufshcd_writel(hba, CONTROLLER_DISABLE,  REG_CONTROLLER_ENABLE);
+	spin_unlock_irqrestore(hba->host->host_lock, flags);
+
 	err = ufshcd_wait_for_register(hba, REG_CONTROLLER_ENABLE,
 					CONTROLLER_ENABLE, CONTROLLER_DISABLE,
-					10, 1, can_sleep);
+					10, 1);
 	if (err)
 		dev_err(hba->dev, "%s: Controller disable failed\n", __func__);
 }
@@ -4288,7 +4292,7 @@ int ufshcd_hba_enable(struct ufs_hba *hba)
 
 	if (!ufshcd_is_hba_active(hba))
 		/* change controller state to "reset state" */
-		ufshcd_hba_stop(hba, true);
+		ufshcd_hba_stop(hba);
 
 	/* UniPro link is disabled at this point */
 	ufshcd_set_link_off(hba);
@@ -5911,7 +5915,7 @@ static int ufshcd_clear_tm_cmd(struct ufs_hba *hba, int tag)
 	/* poll for max. 1 sec to clear door bell register by h/w */
 	err = ufshcd_wait_for_register(hba,
 			REG_UTP_TASK_REQ_DOOR_BELL,
-			mask, 0, 1000, 1000, true);
+			mask, 0, 1000, 1000);
 out:
 	return err;
 }
@@ -6478,8 +6482,9 @@ static int ufshcd_host_reset_and_restore(struct ufs_hba *hba)
 	 * Stop the host controller and complete the requests
 	 * cleared by h/w
 	 */
+	ufshcd_hba_stop(hba);
+
 	spin_lock_irqsave(hba->host->host_lock, flags);
-	ufshcd_hba_stop(hba, false);
 	hba->silence_err_logs = true;
 	ufshcd_complete_requests(hba);
 	hba->silence_err_logs = false;
@@ -7986,7 +7991,7 @@ static int ufshcd_link_state_transition(struct ufs_hba *hba,
 		 * Change controller state to "reset state" which
 		 * should also put the link in off/reset state
 		 */
-		ufshcd_hba_stop(hba, true);
+		ufshcd_hba_stop(hba);
 		/*
 		 * TODO: Check if we need any delay to make sure that
 		 * controller is reset
@@ -8545,7 +8550,7 @@ void ufshcd_remove(struct ufs_hba *hba)
 	scsi_remove_host(hba->host);
 	/* disable interrupts */
 	ufshcd_disable_intr(hba, hba->intr_mask);
-	ufshcd_hba_stop(hba, true);
+	ufshcd_hba_stop(hba);
 
 	ufshcd_exit_clk_scaling(hba);
 	ufshcd_exit_clk_gating(hba);
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 733722840794..5c944530cde5 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -822,7 +822,7 @@ int ufshcd_uic_hibern8_exit(struct ufs_hba *hba);
 void ufshcd_delay_us(unsigned long us, unsigned long tolerance);
 int ufshcd_wait_for_register(struct ufs_hba *hba, u32 reg, u32 mask,
 				u32 val, unsigned long interval_us,
-				unsigned long timeout_ms, bool can_sleep);
+				unsigned long timeout_ms);
 void ufshcd_parse_dev_ref_clk_freq(struct ufs_hba *hba, struct clk *refclk);
 void ufshcd_update_reg_hist(struct ufs_err_reg_hist *reg_hist,
 			    u32 reg);

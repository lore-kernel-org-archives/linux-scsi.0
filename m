Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 355F2C00144
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Aug 2022 04:30:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239256AbiHAEai (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Aug 2022 00:30:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238580AbiHAEae (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Aug 2022 00:30:34 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCCF7DFE4
        for <linux-scsi@vger.kernel.org>; Sun, 31 Jul 2022 21:30:32 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id s206so8700402pgs.3
        for <linux-scsi@vger.kernel.org>; Sun, 31 Jul 2022 21:30:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0osYT5Z1bgQXA5Y5s8u5vyGD4k6MEIRny7gl4f6GuA0=;
        b=F6y/VSEZNm4qfUoCV+M6vbG/66n9Pz5KLy4MeeCR34nwUZkb+2SZlcRL98su6MR8+V
         8dqhihB9MFymaRdCMzXZS2CF064/peSQvnafM9S07Ytc8RFiciV88MsaBLpHQaRA0hEU
         7PPmjXRgWEqN7fUn9aXd0DrArE/B9xQD8LtvM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0osYT5Z1bgQXA5Y5s8u5vyGD4k6MEIRny7gl4f6GuA0=;
        b=u4XeSylX4iimkLDf48CDlr9XraVnh/WLtntuTGnICOfhpThalH/5L9bDlt2n+HOom9
         GBI2KlohcSxmxz6B6Ay1rvJ+GTCBMLgFDkrXTD0T5eVCPeojwy9qU3Ys4nS9mVvpeF4Y
         Ig6AMoY9anvU/BBFyzOGLXkHNcB1VRFvicnyw1WxvsL1+ssKD7UdROnTRAmRSXrYKGOi
         5yS+5QeHyXafWZp+Yq++gTDbqretSQWEmpwc+QHnqW8CWynD1IOoMGYpoK2+3UNbXJXt
         zdpF+sQ6+kPhTCcAdVaNLxHpjM76bELoa33wAbU8+ING4uU2GoE4pXHgy1hO1ibKtAGy
         g8Nw==
X-Gm-Message-State: ACgBeo1LaPFkmDqT+YfWxRWlxBS3OLQ3qbf3xAHG+IFJ3uqqLOi9b+6Z
        LRufT7CRtA3muc2xCT8ZPeG5eg==
X-Google-Smtp-Source: AA6agR5YvYOrzNKSeMwPXo5MpJhTyaFu13eagV3J097TFMGeKJxq28Tw+1R04JsBKqLYdVCtecpWAA==
X-Received: by 2002:a62:1d86:0:b0:52d:9df0:2151 with SMTP id d128-20020a621d86000000b0052d9df02151mr625346pfd.33.1659328232296;
        Sun, 31 Jul 2022 21:30:32 -0700 (PDT)
Received: from dlunevwfh.roam.corp.google.com (n122-107-196-14.sbr2.nsw.optusnet.com.au. [122.107.196.14])
        by smtp.gmail.com with ESMTPSA id x9-20020a170902ec8900b0016c3affe60esm8498377plg.46.2022.07.31.21.30.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 Jul 2022 21:30:30 -0700 (PDT)
From:   Daniil Lunev <dlunev@chromium.org>
To:     Adrian Hunter <adrian.hunter@intel.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Stanley Chu <chu.stanley@gmail.com>
Cc:     Daniil Lunev <dlunev@chromium.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        Daejun Park <daejun7.park@samsung.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: [PATCH v2] ufs: core: ufshcd: use local_clock() for debugging timestamps
Date:   Mon,  1 Aug 2022 14:30:21 +1000
Message-Id: <20220801142931.v2.1.I699244ea7efbd326a34a6dfd9b5a31e78400cf68@changeid>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

CLOCK_MONOTONIC is not advanced when the system is in suspend. This
becomes problematic when debugging issues related to suspend-resume:
the timestamps printed by ufshcd_print_trs can not be correlated with
dmesg entries, which are timestamped with local_clock().

This patch changes the used clock to local_clock() for the informational
timestamp variables and adds mirroring *_local_clock instances for
variables used in subsequent derevations (to not change the semantics of
those derevations).

Signed-off-by: Daniil Lunev <dlunev@chromium.org>

---

Changes in v2:
- Use local clock to better align with dmesg
- Correct commit message

 drivers/ufs/core/ufshcd.c | 19 +++++++++++--------
 include/ufs/ufshcd.h      | 14 +++++++++-----
 2 files changed, 20 insertions(+), 13 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index ce86d1b790c05..86875a626ea77 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -460,7 +460,7 @@ static void ufshcd_print_evt(struct ufs_hba *hba, u32 id,
 		if (e->tstamp[p] == 0)
 			continue;
 		dev_err(hba->dev, "%s[%d] = 0x%x at %lld us\n", err_name, p,
-			e->val[p], ktime_to_us(e->tstamp[p]));
+			e->val[p], e->tstamp[p] / 1000);
 		found = true;
 	}
 
@@ -505,9 +505,9 @@ void ufshcd_print_trs(struct ufs_hba *hba, unsigned long bitmap, bool pr_prdt)
 		lrbp = &hba->lrb[tag];
 
 		dev_err(hba->dev, "UPIU[%d] - issue time %lld us\n",
-				tag, ktime_to_us(lrbp->issue_time_stamp));
+				tag, lrbp->issue_time_stamp_local_clock / 1000);
 		dev_err(hba->dev, "UPIU[%d] - complete time %lld us\n",
-				tag, ktime_to_us(lrbp->compl_time_stamp));
+				tag, lrbp->compl_time_stamp_local_clock / 1000);
 		dev_err(hba->dev,
 			"UPIU[%d] - Transfer Request Descriptor phys@0x%llx\n",
 			tag, (u64)lrbp->utrd_dma_addr);
@@ -569,10 +569,10 @@ static void ufshcd_print_host_state(struct ufs_hba *hba)
 	dev_err(hba->dev, "Clk gate=%d\n", hba->clk_gating.state);
 	dev_err(hba->dev,
 		"last_hibern8_exit_tstamp at %lld us, hibern8_exit_cnt=%d\n",
-		ktime_to_us(hba->ufs_stats.last_hibern8_exit_tstamp),
+		hba->ufs_stats.last_hibern8_exit_tstamp / 1000,
 		hba->ufs_stats.hibern8_exit_cnt);
 	dev_err(hba->dev, "last intr at %lld us, last intr status=0x%x\n",
-		ktime_to_us(hba->ufs_stats.last_intr_ts),
+		hba->ufs_stats.last_intr_ts / 1000,
 		hba->ufs_stats.last_intr_status);
 	dev_err(hba->dev, "error handling flags=0x%x, req. abort count=%d\n",
 		hba->eh_flags, hba->req_abort_count);
@@ -2142,7 +2142,9 @@ void ufshcd_send_command(struct ufs_hba *hba, unsigned int task_tag)
 	unsigned long flags;
 
 	lrbp->issue_time_stamp = ktime_get();
+	lrbp->issue_time_stamp_local_clock = local_clock();
 	lrbp->compl_time_stamp = ktime_set(0, 0);
+	lrbp->compl_time_stamp_local_clock = 0;
 	ufshcd_add_command_trace(hba, task_tag, UFS_CMD_SEND);
 	ufshcd_clk_scaling_start_busy(hba);
 	if (unlikely(ufshcd_should_inform_monitor(hba, lrbp)))
@@ -4199,7 +4201,7 @@ int ufshcd_uic_hibern8_exit(struct ufs_hba *hba)
 	} else {
 		ufshcd_vops_hibern8_notify(hba, UIC_CMD_DME_HIBER_EXIT,
 								POST_CHANGE);
-		hba->ufs_stats.last_hibern8_exit_tstamp = ktime_get();
+		hba->ufs_stats.last_hibern8_exit_tstamp = local_clock();
 		hba->ufs_stats.hibern8_exit_cnt++;
 	}
 
@@ -4696,7 +4698,7 @@ void ufshcd_update_evt_hist(struct ufs_hba *hba, u32 id, u32 val)
 
 	e = &hba->ufs_stats.event[id];
 	e->val[e->pos] = val;
-	e->tstamp[e->pos] = ktime_get();
+	e->tstamp[e->pos] = local_clock();
 	e->cnt += 1;
 	e->pos = (e->pos + 1) % UFS_EVENT_HIST_LENGTH;
 
@@ -5329,6 +5331,7 @@ static void __ufshcd_transfer_req_compl(struct ufs_hba *hba,
 	for_each_set_bit(index, &completed_reqs, hba->nutrs) {
 		lrbp = &hba->lrb[index];
 		lrbp->compl_time_stamp = ktime_get();
+		lrbp->compl_time_stamp_local_clock = local_clock();
 		cmd = lrbp->cmd;
 		if (cmd) {
 			if (unlikely(ufshcd_should_inform_monitor(hba, lrbp)))
@@ -6617,7 +6620,7 @@ static irqreturn_t ufshcd_intr(int irq, void *__hba)
 
 	intr_status = ufshcd_readl(hba, REG_INTERRUPT_STATUS);
 	hba->ufs_stats.last_intr_status = intr_status;
-	hba->ufs_stats.last_intr_ts = ktime_get();
+	hba->ufs_stats.last_intr_ts = local_clock();
 
 	/*
 	 * There could be max of hba->nutrs reqs in flight and in worst case
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index a92271421718e..2de73196bb779 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -160,8 +160,10 @@ struct ufs_pm_lvl_states {
  * @task_tag: Task tag of the command
  * @lun: LUN of the command
  * @intr_cmd: Interrupt command (doesn't participate in interrupt aggregation)
- * @issue_time_stamp: time stamp for debug purposes
- * @compl_time_stamp: time stamp for statistics
+ * @issue_time_stamp: time stamp for debug purposes (CLOCK_MONOTONIC)
+ * @issue_time_stamp_local_clock: time stamp for debug purposes (local_clock)
+ * @compl_time_stamp: time stamp for statistics (CLOCK_MONOTONIC)
+ * @compl_time_stamp_local_clock: time stamp for debug purposes (local_clock)
  * @crypto_key_slot: the key slot to use for inline crypto (-1 if none)
  * @data_unit_num: the data unit number for the first block for inline crypto
  * @req_abort_skip: skip request abort task flag
@@ -185,7 +187,9 @@ struct ufshcd_lrb {
 	u8 lun; /* UPIU LUN id field is only 8-bit wide */
 	bool intr_cmd;
 	ktime_t issue_time_stamp;
+	u64 issue_time_stamp_local_clock;
 	ktime_t compl_time_stamp;
+	u64 compl_time_stamp_local_clock;
 #ifdef CONFIG_SCSI_UFS_CRYPTO
 	int crypto_key_slot;
 	u64 data_unit_num;
@@ -430,7 +434,7 @@ struct ufs_clk_scaling {
 struct ufs_event_hist {
 	int pos;
 	u32 val[UFS_EVENT_HIST_LENGTH];
-	ktime_t tstamp[UFS_EVENT_HIST_LENGTH];
+	u64 tstamp[UFS_EVENT_HIST_LENGTH];
 	unsigned long long cnt;
 };
 
@@ -446,10 +450,10 @@ struct ufs_event_hist {
  */
 struct ufs_stats {
 	u32 last_intr_status;
-	ktime_t last_intr_ts;
+	u64 last_intr_ts;
 
 	u32 hibern8_exit_cnt;
-	ktime_t last_hibern8_exit_tstamp;
+	u64 last_hibern8_exit_tstamp;
 	struct ufs_event_hist event[UFS_EVT_CNT];
 };
 
-- 
2.31.0


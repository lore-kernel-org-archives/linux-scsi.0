Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A77DC433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Jul 2022 10:45:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231510AbiGTKpG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Jul 2022 06:45:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229983AbiGTKpF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Jul 2022 06:45:05 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66F0B6758E
        for <linux-scsi@vger.kernel.org>; Wed, 20 Jul 2022 03:45:02 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id b10so6458975pjq.5
        for <linux-scsi@vger.kernel.org>; Wed, 20 Jul 2022 03:45:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=edMiP3VKUnufxzBjIC5MgcE0lainFg/2U5cyekfrTG4=;
        b=HniASQ2L9k8UMEuAb3TlBCA54u7DbsdPTYay7uumNfTeFkxKbxuGYIiCiuktGjNw6F
         u/5e/msrL2VltXJjD4V6eIZ9/enKGtJKYciDfRu4OC8V0kkGEd7TS6Ju1/vRnft5mcZT
         XWGHWBij3Syq2YYKX6a5s7Fxa4e854C6MWTsI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=edMiP3VKUnufxzBjIC5MgcE0lainFg/2U5cyekfrTG4=;
        b=rg3kXbiEgwMrU5wSh9WnGgSsqVHPB2ylS2vYlM0cmKnlOf/DElP6/aOklIXDTYLiyU
         c1ASMPIWSycIOMn0frCUE80bYQBf0if4yCvjp0DP2AaLUOoq7J4lJA5Qp2B16gNODfb3
         F3pBm5s+45NyHxpVX8c6OHgHMKyx/7zt0rc+YLubXW5Q5/u2usj0BtXN9KbY8ZRgLhfH
         5fO4Ce7WmtvNJfuA0EQNWFNU3UJ/+2+rVvcdRgEhggER71ANL3Et2vBCBrDEQ4IRdKIl
         xoVpiT5ntKzEbbIjtbFbld0JKMODtSbk0+LlEaKgrnIlzwqu5kRDO3o5zylH2c8zTLym
         tIZQ==
X-Gm-Message-State: AJIora92WaBSVpA53DnxJprmS/SEA+e0n5XP7ZXSNY3P4fLDxrw9MARR
        U+n/tIB4bUDryhKohfnuTu+PyA==
X-Google-Smtp-Source: AGRyM1sGExFoHxztZJ83BE8q39RcOwcxm9DxL0kivjbJw+pA7cfXUirQF3MeRMAte/FYgmlaaJYXZA==
X-Received: by 2002:a17:903:40cc:b0:16c:115d:5e80 with SMTP id t12-20020a17090340cc00b0016c115d5e80mr37383248pld.0.1658313901809;
        Wed, 20 Jul 2022 03:45:01 -0700 (PDT)
Received: from dlunevwfh.roam.corp.google.com (n122-107-196-14.sbr2.nsw.optusnet.com.au. [122.107.196.14])
        by smtp.gmail.com with ESMTPSA id g9-20020a625209000000b0051bc5f4df1csm13158421pfb.154.2022.07.20.03.44.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jul 2022 03:45:01 -0700 (PDT)
From:   Daniil Lunev <dlunev@chromium.org>
To:     Adrian Hunter <adrian.hunter@intel.com>,
        Bart Van Assche <bvanassche@acm.org>
Cc:     Daniil Lunev <dlunev@chromium.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        Daejun Park <daejun7.park@samsung.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: [PATCH] ufs: core: ufshcd: use CLOCK_BOOTTIME for debugging timestamps
Date:   Wed, 20 Jul 2022 20:44:36 +1000
Message-Id: <20220720204414.1.I699244ea7efbd326a34a6dfd9b5a31e78400cf68@changeid>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

CLOCK_MONOTONIC is not advanced when the system is in suspend. This
becomes problematic when debugging issues related to suspend-resume:
the timestamps printed by ufshcd_print_trs can not be correlated with
dmesg entries, which are timestamped with CLOCK_BOOTTIME.

This CL changes the used clock to CLOCK_BOOTTIME for the informational
timestamp variables and adds mirroring CLOCK_BOOTIME instances for
variables used in subsequent derevations (to not change the semantics of
those derevations).

Signed-off-by: Daniil Lunev <dlunev@chromium.org>

---

 drivers/ufs/core/ufshcd.c | 13 ++++++++-----
 include/ufs/ufshcd.h      |  8 ++++++--
 2 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index ce86d1b790c05..7726fa93b2e2a 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -505,9 +505,9 @@ void ufshcd_print_trs(struct ufs_hba *hba, unsigned long bitmap, bool pr_prdt)
 		lrbp = &hba->lrb[tag];
 
 		dev_err(hba->dev, "UPIU[%d] - issue time %lld us\n",
-				tag, ktime_to_us(lrbp->issue_time_stamp));
+				tag, ktime_to_us(lrbp->issue_time_stamp_boottime));
 		dev_err(hba->dev, "UPIU[%d] - complete time %lld us\n",
-				tag, ktime_to_us(lrbp->compl_time_stamp));
+				tag, ktime_to_us(lrbp->compl_time_stamp_boottime));
 		dev_err(hba->dev,
 			"UPIU[%d] - Transfer Request Descriptor phys@0x%llx\n",
 			tag, (u64)lrbp->utrd_dma_addr);
@@ -2142,7 +2142,9 @@ void ufshcd_send_command(struct ufs_hba *hba, unsigned int task_tag)
 	unsigned long flags;
 
 	lrbp->issue_time_stamp = ktime_get();
+	lrbp->issue_time_stamp_boottime = ktime_get_boottime();
 	lrbp->compl_time_stamp = ktime_set(0, 0);
+	lrbp->compl_time_stamp_boottime = ktime_set(0, 0);
 	ufshcd_add_command_trace(hba, task_tag, UFS_CMD_SEND);
 	ufshcd_clk_scaling_start_busy(hba);
 	if (unlikely(ufshcd_should_inform_monitor(hba, lrbp)))
@@ -4199,7 +4201,7 @@ int ufshcd_uic_hibern8_exit(struct ufs_hba *hba)
 	} else {
 		ufshcd_vops_hibern8_notify(hba, UIC_CMD_DME_HIBER_EXIT,
 								POST_CHANGE);
-		hba->ufs_stats.last_hibern8_exit_tstamp = ktime_get();
+		hba->ufs_stats.last_hibern8_exit_tstamp = ktime_get_boottime();
 		hba->ufs_stats.hibern8_exit_cnt++;
 	}
 
@@ -4696,7 +4698,7 @@ void ufshcd_update_evt_hist(struct ufs_hba *hba, u32 id, u32 val)
 
 	e = &hba->ufs_stats.event[id];
 	e->val[e->pos] = val;
-	e->tstamp[e->pos] = ktime_get();
+	e->tstamp[e->pos] = ktime_get_boottime();
 	e->cnt += 1;
 	e->pos = (e->pos + 1) % UFS_EVENT_HIST_LENGTH;
 
@@ -5329,6 +5331,7 @@ static void __ufshcd_transfer_req_compl(struct ufs_hba *hba,
 	for_each_set_bit(index, &completed_reqs, hba->nutrs) {
 		lrbp = &hba->lrb[index];
 		lrbp->compl_time_stamp = ktime_get();
+		lrbp->compl_time_stamp_boottime = ktime_get_boottime();
 		cmd = lrbp->cmd;
 		if (cmd) {
 			if (unlikely(ufshcd_should_inform_monitor(hba, lrbp)))
@@ -6617,7 +6620,7 @@ static irqreturn_t ufshcd_intr(int irq, void *__hba)
 
 	intr_status = ufshcd_readl(hba, REG_INTERRUPT_STATUS);
 	hba->ufs_stats.last_intr_status = intr_status;
-	hba->ufs_stats.last_intr_ts = ktime_get();
+	hba->ufs_stats.last_intr_ts = ktime_get_boottime();
 
 	/*
 	 * There could be max of hba->nutrs reqs in flight and in worst case
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index a92271421718e..d4ef09910d0ef 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -160,8 +160,10 @@ struct ufs_pm_lvl_states {
  * @task_tag: Task tag of the command
  * @lun: LUN of the command
  * @intr_cmd: Interrupt command (doesn't participate in interrupt aggregation)
- * @issue_time_stamp: time stamp for debug purposes
- * @compl_time_stamp: time stamp for statistics
+ * @issue_time_stamp: time stamp for debug purposes (CLOCK_MONOTONIC)
+ * @issue_time_stamp_boottime: time stamp for debug purposes (CLOCK_BOOTTIME)
+ * @compl_time_stamp: time stamp for statistics (CLOCK_MONOTONIC)
+ * @compl_time_stamp_boottime: time stamp for debug purposes (CLOCK_BOOTTIME)
  * @crypto_key_slot: the key slot to use for inline crypto (-1 if none)
  * @data_unit_num: the data unit number for the first block for inline crypto
  * @req_abort_skip: skip request abort task flag
@@ -185,7 +187,9 @@ struct ufshcd_lrb {
 	u8 lun; /* UPIU LUN id field is only 8-bit wide */
 	bool intr_cmd;
 	ktime_t issue_time_stamp;
+	ktime_t issue_time_stamp_boottime;
 	ktime_t compl_time_stamp;
+	ktime_t compl_time_stamp_boottime;
 #ifdef CONFIG_SCSI_UFS_CRYPTO
 	int crypto_key_slot;
 	u64 data_unit_num;
-- 
2.31.0


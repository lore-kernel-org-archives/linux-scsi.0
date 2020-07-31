Return-Path: <SRS0=WBt/=BK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35BDFC433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 31 Jul 2020 14:08:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1E3322087C
	for <linux-scsi@archiver.kernel.org>; Fri, 31 Jul 2020 14:08:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387503AbgGaOIQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 31 Jul 2020 10:08:16 -0400
Received: from labrats.qualcomm.com ([199.106.110.90]:12145 "EHLO
        labrats.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387500AbgGaOIO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 31 Jul 2020 10:08:14 -0400
IronPort-SDR: UblvjyLA6DtG+TSnqJL1cmZGsCrK07cHRvAYfSPGOnuDICDfJt0iLsgPzp4MsA+1MWtS+dpjAy
 xTohbNkXP20vb2f8w+Jx8AkJ0BR/X0w0WiHClzmlgneiQU6z8QCp8a3Q0V6L+LrHdengeHUsJ2
 ETppstwcvnBEMuknnLKi/mbq8McUqU26sZ16C39b9gAUM+LVHawXWQx3WllhNlKexUku3/qbte
 EYWBlJNXug5+gcNjKQoMkTbp9bHGI6F36U2ICdqVUxNzgnj6O14RzNe2PP95snZk+EHLbkb5Fz
 OCk=
X-IronPort-AV: E=Sophos;i="5.75,418,1589266800"; 
   d="scan'208";a="47235771"
Received: from unknown (HELO ironmsg05-sd.qualcomm.com) ([10.53.140.145])
  by labrats.qualcomm.com with ESMTP; 31 Jul 2020 07:08:11 -0700
Received: from pacamara-linux.qualcomm.com ([192.168.140.135])
  by ironmsg05-sd.qualcomm.com with ESMTP; 31 Jul 2020 07:08:10 -0700
Received: by pacamara-linux.qualcomm.com (Postfix, from userid 359480)
        id 8641F22E4D; Fri, 31 Jul 2020 07:08:10 -0700 (PDT)
From:   Can Guo <cang@codeaurora.org>
To:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, rnayak@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        saravanak@google.com, salyzyn@google.com, cang@codeaurora.org
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Satya Tangirala <satyat@google.com>,
        linux-kernel@vger.kernel.org (open list),
        linux-arm-kernel@lists.infradead.org (moderated list:ARM/Mediatek SoC
        support),
        linux-mediatek@lists.infradead.org (moderated list:ARM/Mediatek SoC
        support)
Subject: [PATCH 4/8] scsi: ufs: Add some debug infos to ufshcd_print_host_state
Date:   Fri, 31 Jul 2020 07:07:52 -0700
Message-Id: <1596204478-5420-5-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1596204478-5420-1-git-send-email-cang@codeaurora.org>
References: <1596204478-5420-1-git-send-email-cang@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The infos of the last interrupt status and its timestamp are very helpful
when debug system stability issues, e.g. IRQ starvation, so add them to
ufshcd_print_host_state. Meanwhile, UFS device infos like model name and
its FW version also come in handy during debug. In addition, this change
makes cleanup to some prints in ufshcd_print_host_regs as similar prints
are already available in ufshcd_print_host_state.

Signed-off-by: Can Guo <cang@codeaurora.org>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
Reviewed-by: Hongwu Su <hongwus@codeaurora.org>
Reviewed-by: Asutosh Das <asutoshd@codeaurora.org>
Reviewed-by: Stanley Chu <stanley.chu@mediatek.com>
Reviewed-by: Bean Huo <beanhuo@micron.com>

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 99bd3e4..eda4dc6 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -411,15 +411,6 @@ static void ufshcd_print_err_hist(struct ufs_hba *hba,
 static void ufshcd_print_host_regs(struct ufs_hba *hba)
 {
 	ufshcd_dump_regs(hba, 0, UFSHCI_REG_SPACE_SIZE, "host_regs: ");
-	dev_err(hba->dev, "hba->ufs_version = 0x%x, hba->capabilities = 0x%x\n",
-		hba->ufs_version, hba->capabilities);
-	dev_err(hba->dev,
-		"hba->outstanding_reqs = 0x%x, hba->outstanding_tasks = 0x%x\n",
-		(u32)hba->outstanding_reqs, (u32)hba->outstanding_tasks);
-	dev_err(hba->dev,
-		"last_hibern8_exit_tstamp at %lld us, hibern8_exit_cnt = %d\n",
-		ktime_to_us(hba->ufs_stats.last_hibern8_exit_tstamp),
-		hba->ufs_stats.hibern8_exit_cnt);
 
 	ufshcd_print_err_hist(hba, &hba->ufs_stats.pa_err, "pa_err");
 	ufshcd_print_err_hist(hba, &hba->ufs_stats.dl_err, "dl_err");
@@ -438,8 +429,6 @@ static void ufshcd_print_host_regs(struct ufs_hba *hba)
 	ufshcd_print_err_hist(hba, &hba->ufs_stats.host_reset, "host_reset");
 	ufshcd_print_err_hist(hba, &hba->ufs_stats.task_abort, "task_abort");
 
-	ufshcd_print_clk_freqs(hba);
-
 	ufshcd_vops_dbg_register_dump(hba);
 }
 
@@ -499,6 +488,8 @@ static void ufshcd_print_tmrs(struct ufs_hba *hba, unsigned long bitmap)
 
 static void ufshcd_print_host_state(struct ufs_hba *hba)
 {
+	struct scsi_device *sdev_ufs = hba->sdev_ufs_device;
+
 	dev_err(hba->dev, "UFS Host state=%d\n", hba->ufshcd_state);
 	dev_err(hba->dev, "outstanding reqs=0x%lx tasks=0x%lx\n",
 		hba->outstanding_reqs, hba->outstanding_tasks);
@@ -511,12 +502,24 @@ static void ufshcd_print_host_state(struct ufs_hba *hba)
 	dev_err(hba->dev, "Auto BKOPS=%d, Host self-block=%d\n",
 		hba->auto_bkops_enabled, hba->host->host_self_blocked);
 	dev_err(hba->dev, "Clk gate=%d\n", hba->clk_gating.state);
+	dev_err(hba->dev,
+		"last_hibern8_exit_tstamp at %lld us, hibern8_exit_cnt=%d\n",
+		ktime_to_us(hba->ufs_stats.last_hibern8_exit_tstamp),
+		hba->ufs_stats.hibern8_exit_cnt);
+	dev_err(hba->dev, "last intr at %lld us, last intr status=0x%x\n",
+		ktime_to_us(hba->ufs_stats.last_intr_ts),
+		hba->ufs_stats.last_intr_status);
 	dev_err(hba->dev, "error handling flags=0x%x, req. abort count=%d\n",
 		hba->eh_flags, hba->req_abort_count);
-	dev_err(hba->dev, "Host capabilities=0x%x, caps=0x%x\n",
-		hba->capabilities, hba->caps);
+	dev_err(hba->dev, "hba->ufs_version=0x%x, Host capabilities=0x%x, caps=0x%x\n",
+		hba->ufs_version, hba->capabilities, hba->caps);
 	dev_err(hba->dev, "quirks=0x%x, dev. quirks=0x%x\n", hba->quirks,
 		hba->dev_quirks);
+	if (sdev_ufs)
+		dev_err(hba->dev, "UFS dev info: %.8s %.16s rev %.4s\n",
+			sdev_ufs->vendor, sdev_ufs->model, sdev_ufs->rev);
+
+	ufshcd_print_clk_freqs(hba);
 }
 
 /**
@@ -5951,6 +5954,8 @@ static irqreturn_t ufshcd_intr(int irq, void *__hba)
 
 	spin_lock(hba->host->host_lock);
 	intr_status = ufshcd_readl(hba, REG_INTERRUPT_STATUS);
+	hba->ufs_stats.last_intr_status = intr_status;
+	hba->ufs_stats.last_intr_ts = ktime_get();
 
 	/*
 	 * There could be max of hba->nutrs reqs in flight and in worst case
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 656c069..5b2cdaf 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -406,6 +406,8 @@ struct ufs_err_reg_hist {
 
 /**
  * struct ufs_stats - keeps usage/err statistics
+ * @last_intr_status: record the last interrupt status.
+ * @last_intr_ts: record the last interrupt timestamp.
  * @hibern8_exit_cnt: Counter to keep track of number of exits,
  *		reset this after link-startup.
  * @last_hibern8_exit_tstamp: Set time after the hibern8 exit.
@@ -425,6 +427,9 @@ struct ufs_err_reg_hist {
  * @tsk_abort: tracks task abort events
  */
 struct ufs_stats {
+	u32 last_intr_status;
+	ktime_t last_intr_ts;
+
 	u32 hibern8_exit_cnt;
 	ktime_t last_hibern8_exit_tstamp;
 
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.


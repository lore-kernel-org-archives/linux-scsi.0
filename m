Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38BA9C636C8
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Jul 2021 03:35:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 237E261279
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Jul 2021 03:35:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230522AbhGVCzH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Jul 2021 22:55:07 -0400
Received: from mail-pj1-f49.google.com ([209.85.216.49]:41817 "EHLO
        mail-pj1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231135AbhGVCzE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Jul 2021 22:55:04 -0400
Received: by mail-pj1-f49.google.com with SMTP id jx7-20020a17090b46c7b02901757deaf2c8so3635590pjb.0
        for <linux-scsi@vger.kernel.org>; Wed, 21 Jul 2021 20:35:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lZrlOp/r+YewIsmclgvpGDlOLO/N9nbD/l3NVgcfnkU=;
        b=Y69DMooaKLv9j0bvmeZnG4sgSbzx5f4d/U+N2XOQ+E5+CyfJheigAB1pO9axr9brPW
         HG7Q9GbxUahVo0zD5qD9W8Q97Fwi8Ivd3GBXx2xRRiaUOVz/xuqjjgnYF8wLEsRsW50B
         bZzALHrV46RLqCRCty1oE+VvBfL/VciRThlQ7KELbcsrXnO2dmlgXIuL3qwX5JAjRBKD
         oRcT5wWKPEhUeRK5Ou8L0+LBgusfd7Zu5uk11C77pUAWawnVlA0Z3Ataq+WkYuCg9LCb
         Y+R2uVWq8Kl4SF/IcfjXcsnLKlejO3SAJedtWbDdMS66wmhwQnWURmYEbsoaqxkcM6ag
         eKEg==
X-Gm-Message-State: AOAM532BPc0QtGT3IgMQg+wl+QuhO1TkXylASx4Mmy1O9Itb5OzQ0WsO
        Hz23SnPCEfeun3zetiVHcdk=
X-Google-Smtp-Source: ABdhPJwNjTGo7HWguk1ErANyvrs59WSTXuVR8LvN2+EujWGO7IFkGm6nhwzFbOe6Yw7vE72Y89f8IQ==
X-Received: by 2002:a17:90a:f0cf:: with SMTP id fa15mr38390284pjb.83.1626924939279;
        Wed, 21 Jul 2021 20:35:39 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:30e2:954a:f4a0:3224])
        by smtp.gmail.com with ESMTPSA id n6sm32060258pgb.60.2021.07.21.20.35.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jul 2021 20:35:38 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Bean Huo <beanhuo@micron.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        Keoseong Park <keosung.park@samsung.com>,
        Caleb Connolly <caleb@connolly.tech>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: [PATCH v3 11/18] scsi: ufs: Revert "Utilize Transfer Request List Completion Notification Register"
Date:   Wed, 21 Jul 2021 20:34:32 -0700
Message-Id: <20210722033439.26550-12-bvanassche@acm.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722033439.26550-1-bvanassche@acm.org>
References: <20210722033439.26550-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Using the UTRLCNR register involves two MMIO accesses in the hot path while
using the doorbell register only involves a single MMIO access. Since MMIO
accesses take time, do not use the UTRLCNR register. The spinlock contention
on the SCSI host lock that is reintroduced by this patch will be addressed
by a later patch.

This reverts commit 6f7151729647e58ac7c522081255fd0c07b38105.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Stanley Chu <stanley.chu@mediatek.com>
Cc: Can Guo <cang@codeaurora.org>
Cc: Asutosh Das <asutoshd@codeaurora.org>
Cc: Avri Altman <avri.altman@wdc.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshcd.c | 52 +++++++++++----------------------------
 drivers/scsi/ufs/ufshcd.h |  5 ----
 drivers/scsi/ufs/ufshci.h |  1 -
 3 files changed, 15 insertions(+), 43 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 4c6d832f5e81..cb588b705fbb 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2087,6 +2087,7 @@ static inline
 void ufshcd_send_command(struct ufs_hba *hba, unsigned int task_tag)
 {
 	struct ufshcd_lrb *lrbp = &hba->lrb[task_tag];
+	unsigned long flags;
 
 	lrbp->issue_time_stamp = ktime_get();
 	lrbp->compl_time_stamp = ktime_set(0, 0);
@@ -2095,19 +2096,10 @@ void ufshcd_send_command(struct ufs_hba *hba, unsigned int task_tag)
 	ufshcd_clk_scaling_start_busy(hba);
 	if (unlikely(ufshcd_should_inform_monitor(hba, lrbp)))
 		ufshcd_start_monitor(hba, lrbp);
-	if (ufshcd_has_utrlcnr(hba)) {
-		set_bit(task_tag, &hba->outstanding_reqs);
-		ufshcd_writel(hba, 1 << task_tag,
-			      REG_UTP_TRANSFER_REQ_DOOR_BELL);
-	} else {
-		unsigned long flags;
-
-		spin_lock_irqsave(hba->host->host_lock, flags);
-		set_bit(task_tag, &hba->outstanding_reqs);
-		ufshcd_writel(hba, 1 << task_tag,
-			      REG_UTP_TRANSFER_REQ_DOOR_BELL);
-		spin_unlock_irqrestore(hba->host->host_lock, flags);
-	}
+	spin_lock_irqsave(hba->host->host_lock, flags);
+	set_bit(task_tag, &hba->outstanding_reqs);
+	ufshcd_writel(hba, 1 << task_tag, REG_UTP_TRANSFER_REQ_DOOR_BELL);
+	spin_unlock_irqrestore(hba->host->host_lock, flags);
 	/* Make sure that doorbell is committed immediately */
 	wmb();
 }
@@ -5234,17 +5226,17 @@ static void __ufshcd_transfer_req_compl(struct ufs_hba *hba,
 }
 
 /**
- * ufshcd_trc_handler - handle transfer requests completion
+ * ufshcd_transfer_req_compl - handle SCSI and query command completion
  * @hba: per adapter instance
- * @use_utrlcnr: get completed requests from UTRLCNR
  *
  * Returns
  *  IRQ_HANDLED - If interrupt is valid
  *  IRQ_NONE    - If invalid interrupt
  */
-static irqreturn_t ufshcd_trc_handler(struct ufs_hba *hba, bool use_utrlcnr)
+static irqreturn_t ufshcd_transfer_req_compl(struct ufs_hba *hba)
 {
-	unsigned long completed_reqs = 0;
+	unsigned long completed_reqs, flags;
+	u32 tr_doorbell;
 
 	/* Resetting interrupt aggregation counters first and reading the
 	 * DOOR_BELL afterward allows us to handle all the completed requests.
@@ -5257,24 +5249,10 @@ static irqreturn_t ufshcd_trc_handler(struct ufs_hba *hba, bool use_utrlcnr)
 	    !(hba->quirks & UFSHCI_QUIRK_SKIP_RESET_INTR_AGGR))
 		ufshcd_reset_intr_aggr(hba);
 
-	if (use_utrlcnr) {
-		u32 utrlcnr;
-
-		utrlcnr = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_LIST_COMPL);
-		if (utrlcnr) {
-			ufshcd_writel(hba, utrlcnr,
-				      REG_UTP_TRANSFER_REQ_LIST_COMPL);
-			completed_reqs = utrlcnr;
-		}
-	} else {
-		unsigned long flags;
-		u32 tr_doorbell;
-
-		spin_lock_irqsave(hba->host->host_lock, flags);
-		tr_doorbell = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
-		completed_reqs = tr_doorbell ^ hba->outstanding_reqs;
-		spin_unlock_irqrestore(hba->host->host_lock, flags);
-	}
+	spin_lock_irqsave(hba->host->host_lock, flags);
+	tr_doorbell = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
+	completed_reqs = tr_doorbell ^ hba->outstanding_reqs;
+	spin_unlock_irqrestore(hba->host->host_lock, flags);
 
 	if (completed_reqs) {
 		__ufshcd_transfer_req_compl(hba, completed_reqs);
@@ -5756,7 +5734,7 @@ static void ufshcd_exception_event_handler(struct work_struct *work)
 /* Complete requests that have door-bell cleared */
 static void ufshcd_complete_requests(struct ufs_hba *hba)
 {
-	ufshcd_trc_handler(hba, false);
+	ufshcd_transfer_req_compl(hba);
 	ufshcd_tmc_handler(hba);
 }
 
@@ -6397,7 +6375,7 @@ static irqreturn_t ufshcd_sl_intr(struct ufs_hba *hba, u32 intr_status)
 		retval |= ufshcd_tmc_handler(hba);
 
 	if (intr_status & UTP_TRANSFER_REQ_COMPL)
-		retval |= ufshcd_trc_handler(hba, ufshcd_has_utrlcnr(hba));
+		retval |= ufshcd_transfer_req_compl(hba);
 
 	return retval;
 }
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 8dcf0df770a2..a44baec43dd5 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -1176,11 +1176,6 @@ static inline u32 ufshcd_vops_get_ufs_hci_version(struct ufs_hba *hba)
 	return ufshcd_readl(hba, REG_UFS_VERSION);
 }
 
-static inline bool ufshcd_has_utrlcnr(struct ufs_hba *hba)
-{
-	return (hba->ufs_version >= ufshci_version(3, 0));
-}
-
 static inline int ufshcd_vops_clk_scale_notify(struct ufs_hba *hba,
 			bool up, enum ufs_notify_change_status status)
 {
diff --git a/drivers/scsi/ufs/ufshci.h b/drivers/scsi/ufs/ufshci.h
index 5affb1fce5ad..de95be5d11d4 100644
--- a/drivers/scsi/ufs/ufshci.h
+++ b/drivers/scsi/ufs/ufshci.h
@@ -39,7 +39,6 @@ enum {
 	REG_UTP_TRANSFER_REQ_DOOR_BELL		= 0x58,
 	REG_UTP_TRANSFER_REQ_LIST_CLEAR		= 0x5C,
 	REG_UTP_TRANSFER_REQ_LIST_RUN_STOP	= 0x60,
-	REG_UTP_TRANSFER_REQ_LIST_COMPL		= 0x64,
 	REG_UTP_TASK_REQ_LIST_BASE_L		= 0x70,
 	REG_UTP_TASK_REQ_LIST_BASE_H		= 0x74,
 	REG_UTP_TASK_REQ_DOOR_BELL		= 0x78,

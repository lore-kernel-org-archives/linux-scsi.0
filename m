Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 214BAC04FF3
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 08:37:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F169961151
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 08:37:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232456AbhEXIi5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 24 May 2021 04:38:57 -0400
Received: from labrats.qualcomm.com ([199.106.110.90]:8834 "EHLO
        labrats.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232453AbhEXIi5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 May 2021 04:38:57 -0400
IronPort-SDR: TWa3Fhi63S60EDRXcnbhqJyFy8dhPfEshDMx4boyqFmZBRfzPijqwHNzwyMuNGUT4oo2r85BJD
 S8oBicywI3al7o/1oT79E6vCtuHZFoVWcMHaAVY/ShRH/7XNmMsDbv6J/Lq2hATtwvbvJWvD5d
 dWKc9rgJBH5ILrCHq670hnIzytXgq32XZ3EOEBiLQbcsrPW7jMTYhaSR40Ry6RUKu2omrS2ZAm
 CqZPmUrD+1ParrHaXFzyRA1DC1JnHW7vCRhA+0AEWF66ECJTJfbFiajZd5F1n5noriahUoH5kn
 EJY=
X-IronPort-AV: E=Sophos;i="5.82,319,1613462400"; 
   d="scan'208";a="29772330"
Received: from unknown (HELO ironmsg03-sd.qualcomm.com) ([10.53.140.143])
  by labrats.qualcomm.com with ESMTP; 24 May 2021 01:37:29 -0700
X-QCInternal: smtphost
Received: from stor-presley.qualcomm.com ([192.168.140.85])
  by ironmsg03-sd.qualcomm.com with ESMTP; 24 May 2021 01:37:28 -0700
Received: by stor-presley.qualcomm.com (Postfix, from userid 359480)
        id 9404621AD7; Mon, 24 May 2021 01:37:28 -0700 (PDT)
From:   Can Guo <cang@codeaurora.org>
To:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, cang@codeaurora.org
Cc:     Stanley Chu <stanley.chu@mediatek.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Bean Huo <beanhuo@micron.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        Satya Tangirala <satyat@google.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Caleb Connolly <caleb@connolly.tech>,
        linux-kernel@vger.kernel.org (open list),
        linux-arm-kernel@lists.infradead.org (moderated list:ARM/Mediatek SoC
        support),
        linux-mediatek@lists.infradead.org (moderated list:ARM/Mediatek SoC
        support)
Subject: [PATCH v1 3/3] scsi: ufs: Utilize Transfer Request List Completion Notification Register
Date:   Mon, 24 May 2021 01:36:58 -0700
Message-Id: <1621845419-14194-4-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1621845419-14194-1-git-send-email-cang@codeaurora.org>
References: <1621845419-14194-1-git-send-email-cang@codeaurora.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

By reading the UTP Transfer Request List Completion Notification Register,
which is added in UFSHCI Ver 3.0, SW can easily get the compeleted transfer
requests. Thus, SW can get rid of host lock, which is used to synchronize
the tr_doorbell and outstanding_reqs, on transfer requests dispatch and
completion paths. This can further benefit random read/write performance.

Cc: Stanley Chu <stanley.chu@mediatek.com>
Co-developed-by: Asutosh Das <asutoshd@codeaurora.org>
Signed-off-by: Asutosh Das <asutoshd@codeaurora.org>
Signed-off-by: Can Guo <cang@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd.c | 52 +++++++++++++++++++++++++++++++++--------------
 drivers/scsi/ufs/ufshcd.h |  5 +++++
 drivers/scsi/ufs/ufshci.h |  1 +
 3 files changed, 43 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index b9b5e61..2b7ad26 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2106,7 +2106,6 @@ static inline
 void ufshcd_send_command(struct ufs_hba *hba, unsigned int task_tag)
 {
 	struct ufshcd_lrb *lrbp = &hba->lrb[task_tag];
-	unsigned long flags;
 
 	lrbp->issue_time_stamp = ktime_get();
 	lrbp->compl_time_stamp = ktime_set(0, 0);
@@ -2115,10 +2114,19 @@ void ufshcd_send_command(struct ufs_hba *hba, unsigned int task_tag)
 	ufshcd_clk_scaling_start_busy(hba);
 	if (unlikely(ufshcd_should_inform_monitor(hba, lrbp)))
 		ufshcd_start_monitor(hba, lrbp);
-	spin_lock_irqsave(hba->host->host_lock, flags);
-	set_bit(task_tag, &hba->outstanding_reqs);
-	ufshcd_writel(hba, 1 << task_tag, REG_UTP_TRANSFER_REQ_DOOR_BELL);
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
+	if (ufshcd_has_utrlcnr(hba)) {
+		set_bit(task_tag, &hba->outstanding_reqs);
+		ufshcd_writel(hba, 1 << task_tag,
+			      REG_UTP_TRANSFER_REQ_DOOR_BELL);
+	} else {
+		unsigned long flags;
+
+		spin_lock_irqsave(hba->host->host_lock, flags);
+		set_bit(task_tag, &hba->outstanding_reqs);
+		ufshcd_writel(hba, 1 << task_tag,
+			      REG_UTP_TRANSFER_REQ_DOOR_BELL);
+		spin_unlock_irqrestore(hba->host->host_lock, flags);
+	}
 	/* Make sure that doorbell is committed immediately */
 	wmb();
 }
@@ -5260,17 +5268,17 @@ static void __ufshcd_transfer_req_compl(struct ufs_hba *hba,
 }
 
 /**
- * ufshcd_transfer_req_compl - handle SCSI and query command completion
+ * ufshcd_trc_handler - handle transfer requests completion
  * @hba: per adapter instance
+ * @use_utrlcnr: get completed requests from UTRLCNR
  *
  * Returns
  *  IRQ_HANDLED - If interrupt is valid
  *  IRQ_NONE    - If invalid interrupt
  */
-static irqreturn_t ufshcd_transfer_req_compl(struct ufs_hba *hba)
+static irqreturn_t ufshcd_trc_handler(struct ufs_hba *hba, bool use_utrlcnr)
 {
-	unsigned long completed_reqs, flags;
-	u32 tr_doorbell;
+	unsigned long completed_reqs = 0;
 
 	/* Resetting interrupt aggregation counters first and reading the
 	 * DOOR_BELL afterward allows us to handle all the completed requests.
@@ -5283,10 +5291,24 @@ static irqreturn_t ufshcd_transfer_req_compl(struct ufs_hba *hba)
 	    !(hba->quirks & UFSHCI_QUIRK_SKIP_RESET_INTR_AGGR))
 		ufshcd_reset_intr_aggr(hba);
 
-	spin_lock_irqsave(hba->host->host_lock, flags);
-	tr_doorbell = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
-	completed_reqs = tr_doorbell ^ hba->outstanding_reqs;
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
+	if (use_utrlcnr) {
+		u32 utrlcnr;
+
+		utrlcnr = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_LIST_COMPL);
+		if (utrlcnr) {
+			ufshcd_writel(hba, utrlcnr,
+				      REG_UTP_TRANSFER_REQ_LIST_COMPL);
+			completed_reqs = utrlcnr;
+		}
+	} else {
+		unsigned long flags;
+		u32 tr_doorbell;
+
+		spin_lock_irqsave(hba->host->host_lock, flags);
+		tr_doorbell = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
+		completed_reqs = tr_doorbell ^ hba->outstanding_reqs;
+		spin_unlock_irqrestore(hba->host->host_lock, flags);
+	}
 
 	if (completed_reqs) {
 		__ufshcd_transfer_req_compl(hba, completed_reqs);
@@ -5768,7 +5790,7 @@ static void ufshcd_exception_event_handler(struct work_struct *work)
 /* Complete requests that have door-bell cleared */
 static void ufshcd_complete_requests(struct ufs_hba *hba)
 {
-	ufshcd_transfer_req_compl(hba);
+	ufshcd_trc_handler(hba, false);
 	ufshcd_tmc_handler(hba);
 }
 
@@ -6409,7 +6431,7 @@ static irqreturn_t ufshcd_sl_intr(struct ufs_hba *hba, u32 intr_status)
 		retval |= ufshcd_tmc_handler(hba);
 
 	if (intr_status & UTP_TRANSFER_REQ_COMPL)
-		retval |= ufshcd_transfer_req_compl(hba);
+		retval |= ufshcd_trc_handler(hba, ufshcd_has_utrlcnr(hba));
 
 	return retval;
 }
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index a70daf7..d5325e8 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -1159,6 +1159,11 @@ static inline u32 ufshcd_vops_get_ufs_hci_version(struct ufs_hba *hba)
 	return ufshcd_readl(hba, REG_UFS_VERSION);
 }
 
+static inline bool ufshcd_has_utrlcnr(struct ufs_hba *hba)
+{
+	return (hba->ufs_version >= ufshci_version(3, 0));
+}
+
 static inline int ufshcd_vops_clk_scale_notify(struct ufs_hba *hba,
 			bool up, enum ufs_notify_change_status status)
 {
diff --git a/drivers/scsi/ufs/ufshci.h b/drivers/scsi/ufs/ufshci.h
index de95be5..5affb1f 100644
--- a/drivers/scsi/ufs/ufshci.h
+++ b/drivers/scsi/ufs/ufshci.h
@@ -39,6 +39,7 @@ enum {
 	REG_UTP_TRANSFER_REQ_DOOR_BELL		= 0x58,
 	REG_UTP_TRANSFER_REQ_LIST_CLEAR		= 0x5C,
 	REG_UTP_TRANSFER_REQ_LIST_RUN_STOP	= 0x60,
+	REG_UTP_TRANSFER_REQ_LIST_COMPL		= 0x64,
 	REG_UTP_TASK_REQ_LIST_BASE_L		= 0x70,
 	REG_UTP_TASK_REQ_LIST_BASE_H		= 0x74,
 	REG_UTP_TASK_REQ_DOOR_BELL		= 0x78,
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.


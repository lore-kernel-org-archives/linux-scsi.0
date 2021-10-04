Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 571B2C433EF
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Oct 2021 12:09:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 369126136F
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Oct 2021 12:09:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233068AbhJDMLe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Oct 2021 08:11:34 -0400
Received: from mga12.intel.com ([192.55.52.136]:5858 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233062AbhJDMLd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 4 Oct 2021 08:11:33 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10126"; a="205532824"
X-IronPort-AV: E=Sophos;i="5.85,345,1624345200"; 
   d="scan'208";a="205532824"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Oct 2021 05:07:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,345,1624345200"; 
   d="scan'208";a="482927073"
Received: from ahunter-desktop.fi.intel.com ([10.237.72.76])
  by fmsmga007.fm.intel.com with ESMTP; 04 Oct 2021 05:07:07 -0700
From:   Adrian Hunter <adrian.hunter@intel.com>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <huobean@gmail.com>,
        Avri Altman <avri.altman@wdc.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Bart Van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org
Subject: [PATCH RFC 2/6] scsi: ufs: Rename clk_scaling_lock to host_rw_sem
Date:   Mon,  4 Oct 2021 15:06:46 +0300
Message-Id: <20211004120650.153218-3-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211004120650.153218-1-adrian.hunter@intel.com>
References: <20211004120650.153218-1-adrian.hunter@intel.com>
MIME-Version: 1.0
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

To fit its new purpose as a more general purpose sleeping lock for the
host.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 drivers/scsi/ufs/ufshcd.c |  2 +-
 drivers/scsi/ufs/ufshcd.h | 14 +++++++-------
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 350ecfd90306..3912b74d50ae 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -9630,7 +9630,7 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 	/* Initialize mutex for exception event control */
 	mutex_init(&hba->ee_ctrl_mutex);
 
-	init_rwsem(&hba->clk_scaling_lock);
+	init_rwsem(&hba->host_rw_sem);
 
 	ufshcd_init_clk_gating(hba);
 
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 9b1ef272fb3c..495e1c0afae3 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -897,7 +897,7 @@ struct ufs_hba {
 	enum bkops_status urgent_bkops_lvl;
 	bool is_urgent_bkops_lvl_checked;
 
-	struct rw_semaphore clk_scaling_lock;
+	struct rw_semaphore host_rw_sem;
 	unsigned char desc_size[QUERY_DESC_IDN_MAX];
 	atomic_t scsi_block_reqs_cnt;
 
@@ -1420,32 +1420,32 @@ static inline int ufshcd_rpmb_rpm_put(struct ufs_hba *hba)
 
 static inline void ufshcd_down_read(struct ufs_hba *hba)
 {
-	down_read(&hba->clk_scaling_lock);
+	down_read(&hba->host_rw_sem);
 }
 
 static inline void ufshcd_up_read(struct ufs_hba *hba)
 {
-	up_read(&hba->clk_scaling_lock);
+	up_read(&hba->host_rw_sem);
 }
 
 static inline int ufshcd_down_read_trylock(struct ufs_hba *hba)
 {
-	return down_read_trylock(&hba->clk_scaling_lock);
+	return down_read_trylock(&hba->host_rw_sem);
 }
 
 static inline void ufshcd_down_write(struct ufs_hba *hba)
 {
-	down_write(&hba->clk_scaling_lock);
+	down_write(&hba->host_rw_sem);
 }
 
 static inline void ufshcd_up_write(struct ufs_hba *hba)
 {
-	up_write(&hba->clk_scaling_lock);
+	up_write(&hba->host_rw_sem);
 }
 
 static inline void ufshcd_downgrade_write(struct ufs_hba *hba)
 {
-	downgrade_write(&hba->clk_scaling_lock);
+	downgrade_write(&hba->host_rw_sem);
 }
 
 #endif /* End of Header */
-- 
2.25.1


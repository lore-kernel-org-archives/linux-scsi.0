Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5990C433EF
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Oct 2021 12:09:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 91CC86128A
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Oct 2021 12:09:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233095AbhJDMLp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Oct 2021 08:11:45 -0400
Received: from mga12.intel.com ([192.55.52.136]:5875 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233062AbhJDMLp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 4 Oct 2021 08:11:45 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10126"; a="205532841"
X-IronPort-AV: E=Sophos;i="5.85,345,1624345200"; 
   d="scan'208";a="205532841"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Oct 2021 05:07:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,345,1624345200"; 
   d="scan'208";a="482927080"
Received: from ahunter-desktop.fi.intel.com ([10.237.72.76])
  by fmsmga007.fm.intel.com with ESMTP; 04 Oct 2021 05:07:10 -0700
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
Subject: [PATCH RFC 3/6] scsi: ufs: Let ufshcd_[down/up]_read be nested within ufshcd_[down/up]_write
Date:   Mon,  4 Oct 2021 15:06:47 +0300
Message-Id: <20211004120650.153218-4-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211004120650.153218-1-adrian.hunter@intel.com>
References: <20211004120650.153218-1-adrian.hunter@intel.com>
MIME-Version: 1.0
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In preparation to hold ufshcd_down_write() lock for the entire error
handler duration.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 drivers/scsi/ufs/ufshcd.h | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 495e1c0afae3..74891947bb34 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -898,6 +898,7 @@ struct ufs_hba {
 	bool is_urgent_bkops_lvl_checked;
 
 	struct rw_semaphore host_rw_sem;
+	struct task_struct *excl_task;
 	unsigned char desc_size[QUERY_DESC_IDN_MAX];
 	atomic_t scsi_block_reqs_cnt;
 
@@ -1420,31 +1421,45 @@ static inline int ufshcd_rpmb_rpm_put(struct ufs_hba *hba)
 
 static inline void ufshcd_down_read(struct ufs_hba *hba)
 {
-	down_read(&hba->host_rw_sem);
+	if (hba->excl_task != current)
+		down_read(&hba->host_rw_sem);
 }
 
 static inline void ufshcd_up_read(struct ufs_hba *hba)
 {
-	up_read(&hba->host_rw_sem);
+	if (hba->excl_task != current)
+		up_read(&hba->host_rw_sem);
 }
 
 static inline int ufshcd_down_read_trylock(struct ufs_hba *hba)
 {
+	if (hba->excl_task == current)
+		return 1;
+
 	return down_read_trylock(&hba->host_rw_sem);
 }
 
 static inline void ufshcd_down_write(struct ufs_hba *hba)
 {
 	down_write(&hba->host_rw_sem);
+	/*
+	 * Assign exclusive access to this task, which enables bypassing
+	 * down_read/up_read, refer ufshcd_down_read() and ufshcd_up_read().
+	 * Note, if the same task will not be doing up_write(), it must set
+	 * hba->excl_task to NULL itself.
+	 */
+	hba->excl_task = current;
 }
 
 static inline void ufshcd_up_write(struct ufs_hba *hba)
 {
+	hba->excl_task = NULL;
 	up_write(&hba->host_rw_sem);
 }
 
 static inline void ufshcd_downgrade_write(struct ufs_hba *hba)
 {
+	hba->excl_task = NULL;
 	downgrade_write(&hba->host_rw_sem);
 }
 
-- 
2.25.1


Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1FDDC433EF
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Oct 2021 12:10:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CE6B66136F
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Oct 2021 12:10:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233106AbhJDMLu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Oct 2021 08:11:50 -0400
Received: from mga12.intel.com ([192.55.52.136]:5875 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233102AbhJDMLt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 4 Oct 2021 08:11:49 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10126"; a="205532856"
X-IronPort-AV: E=Sophos;i="5.85,345,1624345200"; 
   d="scan'208";a="205532856"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Oct 2021 05:07:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,345,1624345200"; 
   d="scan'208";a="482927097"
Received: from ahunter-desktop.fi.intel.com ([10.237.72.76])
  by fmsmga007.fm.intel.com with ESMTP; 04 Oct 2021 05:07:13 -0700
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
Subject: [PATCH RFC 4/6] scsi: ufs: Fix a possible dead lock in clock scaling
Date:   Mon,  4 Oct 2021 15:06:48 +0300
Message-Id: <20211004120650.153218-5-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211004120650.153218-1-adrian.hunter@intel.com>
References: <20211004120650.153218-1-adrian.hunter@intel.com>
MIME-Version: 1.0
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Instead of downgrade_write(), extend the ufshcd_down_write() to cover
ufshcd_wb_toggle() because ufshcd_down_write() now supports nesting
ufshcd_down_read() but down_read() nested within down_read() can deadlock.

Reported-by: Can Guo <cang@codeaurora.org>
Link: https://lore.kernel.org/all/fbc4d03a07f03fe4fbe697813111471f@codeaurora.org
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 drivers/scsi/ufs/ufshcd.c | 12 +++---------
 drivers/scsi/ufs/ufshcd.h |  6 ------
 2 files changed, 3 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 3912b74d50ae..64ac9e48c4d7 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -1192,12 +1192,9 @@ static int ufshcd_clock_scaling_prepare(struct ufs_hba *hba)
 	return ret;
 }
 
-static void ufshcd_clock_scaling_unprepare(struct ufs_hba *hba, bool writelock)
+static void ufshcd_clock_scaling_unprepare(struct ufs_hba *hba)
 {
-	if (writelock)
-		ufshcd_up_write(hba);
-	else
-		ufshcd_up_read(hba);
+	ufshcd_up_write(hba);
 	ufshcd_scsi_unblock_requests(hba);
 	ufshcd_release(hba);
 }
@@ -1214,7 +1211,6 @@ static void ufshcd_clock_scaling_unprepare(struct ufs_hba *hba, bool writelock)
 static int ufshcd_devfreq_scale(struct ufs_hba *hba, bool scale_up)
 {
 	int ret = 0;
-	bool is_writelock = true;
 
 	ret = ufshcd_clock_scaling_prepare(hba);
 	if (ret)
@@ -1244,12 +1240,10 @@ static int ufshcd_devfreq_scale(struct ufs_hba *hba, bool scale_up)
 	}
 
 	/* Enable Write Booster if we have scaled up else disable it */
-	ufshcd_downgrade_write(hba);
-	is_writelock = false;
 	ufshcd_wb_toggle(hba, scale_up);
 
 out_unprepare:
-	ufshcd_clock_scaling_unprepare(hba, is_writelock);
+	ufshcd_clock_scaling_unprepare(hba);
 	return ret;
 }
 
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 74891947bb34..47f81eae178c 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -1457,10 +1457,4 @@ static inline void ufshcd_up_write(struct ufs_hba *hba)
 	up_write(&hba->host_rw_sem);
 }
 
-static inline void ufshcd_downgrade_write(struct ufs_hba *hba)
-{
-	hba->excl_task = NULL;
-	downgrade_write(&hba->host_rw_sem);
-}
-
 #endif /* End of Header */
-- 
2.25.1


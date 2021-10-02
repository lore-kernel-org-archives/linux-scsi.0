Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75A1EC433FE
	for <linux-scsi@archiver.kernel.org>; Sat,  2 Oct 2021 15:46:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 52D3561B1C
	for <linux-scsi@archiver.kernel.org>; Sat,  2 Oct 2021 15:46:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233499AbhJBPr4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 2 Oct 2021 11:47:56 -0400
Received: from mga12.intel.com ([192.55.52.136]:12596 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233417AbhJBPrz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 2 Oct 2021 11:47:55 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10125"; a="205187485"
X-IronPort-AV: E=Sophos;i="5.85,342,1624345200"; 
   d="scan'208";a="205187485"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Oct 2021 08:46:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,342,1624345200"; 
   d="scan'208";a="557080987"
Received: from ahunter-desktop.fi.intel.com ([10.237.72.76])
  by FMSMGA003.fm.intel.com with ESMTP; 02 Oct 2021 08:46:05 -0700
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
Subject: [PATCH 1/2] scsi: ufs: Do not exit ufshcd_reset_and_restore() unless operational or dead
Date:   Sat,  2 Oct 2021 18:45:49 +0300
Message-Id: <20211002154550.128511-2-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211002154550.128511-1-adrian.hunter@intel.com>
References: <20211002154550.128511-1-adrian.hunter@intel.com>
MIME-Version: 1.0
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Callers of ufshcd_reset_and_restore() expect it to return in an operational
state. However, the code only checks direct errors and so the ufshcd_state
may not be UFSHCD_STATE_OPERATIONAL due to error interrupts.

Fix by checking also ufshcd_state, still allowing non-fatal errors which
are left for the error handler to deal with.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 drivers/scsi/ufs/ufshcd.c | 36 +++++++++++++++++++++++-------------
 1 file changed, 23 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 9faf02cbb9ad..16492779d3a6 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -7156,31 +7156,41 @@ static int ufshcd_host_reset_and_restore(struct ufs_hba *hba)
  */
 static int ufshcd_reset_and_restore(struct ufs_hba *hba)
 {
-	u32 saved_err;
-	u32 saved_uic_err;
+	u32 saved_err = 0;
+	u32 saved_uic_err = 0;
 	int err = 0;
 	unsigned long flags;
 	int retries = MAX_HOST_RESET_RETRIES;
 
-	/*
-	 * This is a fresh start, cache and clear saved error first,
-	 * in case new error generated during reset and restore.
-	 */
 	spin_lock_irqsave(hba->host->host_lock, flags);
-	saved_err = hba->saved_err;
-	saved_uic_err = hba->saved_uic_err;
-	hba->saved_err = 0;
-	hba->saved_uic_err = 0;
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
-
 	do {
+		/*
+		 * This is a fresh start, cache and clear saved error first,
+		 * in case new error generated during reset and restore.
+		 */
+		saved_err |= hba->saved_err;
+		saved_uic_err |= hba->saved_uic_err;
+		hba->saved_err = 0;
+		hba->saved_uic_err = 0;
+		hba->force_reset = false;
+		hba->ufshcd_state = UFSHCD_STATE_RESET;
+		spin_unlock_irqrestore(hba->host->host_lock, flags);
+
 		/* Reset the attached device */
 		ufshcd_device_reset(hba);
 
 		err = ufshcd_host_reset_and_restore(hba);
+
+		spin_lock_irqsave(hba->host->host_lock, flags);
+		if (err)
+			continue;
+		/* Do not exit unless operational or dead */
+		if (hba->ufshcd_state != UFSHCD_STATE_OPERATIONAL &&
+		    hba->ufshcd_state != UFSHCD_STATE_ERROR &&
+		    hba->ufshcd_state != UFSHCD_STATE_EH_SCHEDULED_NON_FATAL)
+			err = -EAGAIN;
 	} while (err && --retries);
 
-	spin_lock_irqsave(hba->host->host_lock, flags);
 	/*
 	 * Inform scsi mid-layer that we did reset and allow to handle
 	 * Unit Attention properly.
-- 
2.25.1


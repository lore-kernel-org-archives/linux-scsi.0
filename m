Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0997AC433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Oct 2021 15:02:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E225B60F21
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Oct 2021 15:02:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230076AbhJMPEY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Oct 2021 11:04:24 -0400
Received: from mga04.intel.com ([192.55.52.120]:64864 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233837AbhJMPEW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 13 Oct 2021 11:04:22 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10136"; a="226219391"
X-IronPort-AV: E=Sophos;i="5.85,371,1624345200"; 
   d="scan'208";a="226219391"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2021 08:01:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,371,1624345200"; 
   d="scan'208";a="715596211"
Received: from ahunter-desktop.fi.intel.com ([10.237.72.76])
  by fmsmga006.fm.intel.com with ESMTP; 13 Oct 2021 08:01:20 -0700
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
Subject: [PATCH 1/1] scsi: ufs: core: Fix task management completion timeout race
Date:   Wed, 13 Oct 2021 18:01:16 +0300
Message-Id: <20211013150116.31158-2-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211013150116.31158-1-adrian.hunter@intel.com>
References: <20211013150116.31158-1-adrian.hunter@intel.com>
MIME-Version: 1.0
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

__ufshcd_issue_tm_cmd() clears req->end_io_data after timing out,
which races with the completion function ufshcd_tmc_handler() which
expects req->end_io_data to have a value.

Note __ufshcd_issue_tm_cmd() and ufshcd_tmc_handler() are already
synchronized using hba->tmf_rqs and hba->outstanding_tasks under the
host_lock spinlock.

It is also not necessary (nor typical) to clear req->end_io_data because
the block layer does it before allocating out requests e.g. via
blk_get_request().

So fix by not clearing it.

Fixes: f5ef336fd2e4c3 ("scsi: ufs: core: Fix task management completion")
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 drivers/scsi/ufs/ufshcd.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 95be7ecdfe10..f34b3994d1aa 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -6550,11 +6550,6 @@ static int __ufshcd_issue_tm_cmd(struct ufs_hba *hba,
 	err = wait_for_completion_io_timeout(&wait,
 			msecs_to_jiffies(TM_CMD_TIMEOUT));
 	if (!err) {
-		/*
-		 * Make sure that ufshcd_compl_tm() does not trigger a
-		 * use-after-free.
-		 */
-		req->end_io_data = NULL;
 		ufshcd_add_tm_upiu_trace(hba, task_tag, UFS_TM_ERR);
 		dev_err(hba->dev, "%s: task management cmd 0x%.2x timed-out\n",
 				__func__, tm_function);
-- 
2.25.1


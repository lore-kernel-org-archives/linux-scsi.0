Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0528C433FE
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Nov 2021 06:48:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 95BB66128B
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Nov 2021 06:48:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235454AbhKHGvg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 8 Nov 2021 01:51:36 -0500
Received: from mga05.intel.com ([192.55.52.43]:52846 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236168AbhKHGvc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 8 Nov 2021 01:51:32 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10161"; a="318373243"
X-IronPort-AV: E=Sophos;i="5.87,217,1631602800"; 
   d="scan'208";a="318373243"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2021 22:48:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,217,1631602800"; 
   d="scan'208";a="451358994"
Received: from ahunter-desktop.fi.intel.com ([10.237.72.76])
  by orsmga006.jf.intel.com with ESMTP; 07 Nov 2021 22:48:22 -0800
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
Subject: [PATCH V2 2/2] scsi: ufs: core: Fix another task management completion race
Date:   Mon,  8 Nov 2021 08:48:15 +0200
Message-Id: <20211108064815.569494-3-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211108064815.569494-1-adrian.hunter@intel.com>
References: <20211108064815.569494-1-adrian.hunter@intel.com>
MIME-Version: 1.0
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

hba->outstanding_tasks, which is read under host_lock spinlock, tells
the interrupt handler what task management tags are in use by the driver.
The doorbell register bits indicate which tags are in use by the hardware.
A doorbell bit that is 0 is because the bit has yet to be set by the
driver, or because the task is complete. It is only possible to
disambiguate the 2 cases, if reading/writing the doorbell register is
synchronized with reading/writing hba->outstanding_tasks.

For that reason, reading REG_UTP_TASK_REQ_DOOR_BELL must be done under
spinlock.

Fixes: f5ef336fd2e4c3 ("scsi: ufs: core: Fix task management completion")
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 drivers/scsi/ufs/ufshcd.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index a904531ba528..a1519b2b6cfe 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -6453,9 +6453,8 @@ static irqreturn_t ufshcd_tmc_handler(struct ufs_hba *hba)
 	irqreturn_t ret = IRQ_NONE;
 	int tag;
 
-	pending = ufshcd_readl(hba, REG_UTP_TASK_REQ_DOOR_BELL);
-
 	spin_lock_irqsave(hba->host->host_lock, flags);
+	pending = ufshcd_readl(hba, REG_UTP_TASK_REQ_DOOR_BELL);
 	issued = hba->outstanding_tasks & ~pending;
 	for_each_set_bit(tag, &issued, hba->nutmrs) {
 		struct request *req = hba->tmf_rqs[tag];
-- 
2.25.1


Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD47BC433F5
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Oct 2021 08:41:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 910416103C
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Oct 2021 08:41:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234234AbhJHIm4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Oct 2021 04:42:56 -0400
Received: from mga09.intel.com ([134.134.136.24]:1380 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235662AbhJHIms (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 8 Oct 2021 04:42:48 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10130"; a="226364893"
X-IronPort-AV: E=Sophos;i="5.85,357,1624345200"; 
   d="scan'208";a="226364893"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2021 01:40:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,357,1624345200"; 
   d="scan'208";a="478899126"
Received: from ahunter-desktop.fi.intel.com ([10.237.72.76])
  by orsmga007.jf.intel.com with ESMTP; 08 Oct 2021 01:40:49 -0700
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
Subject: [PATCH V2] scsi: ufs: core: Fix synchronization between scsi_unjam_host() and ufshcd_queuecommand()
Date:   Fri,  8 Oct 2021 11:40:48 +0300
Message-Id: <20211008084048.257498-1-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The SCSI error handler calls scsi_unjam_host() which can call the queue
function ufshcd_queuecommand() indirectly. The error handler changes the
state to UFSHCD_STATE_RESET while running, but error interrupts that
happen while the error handler is running could change the state to
UFSHCD_STATE_EH_SCHEDULED_NON_FATAL which would allow requests to go
through ufshcd_queuecommand() even though the error handler is running.
Block that hole by checking whether the error handler is in progress.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---

Changes in V2:

	Add comment

 drivers/scsi/ufs/ufshcd.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index f34227add27d..29d202207b18 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2688,7 +2688,19 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 
 	switch (hba->ufshcd_state) {
 	case UFSHCD_STATE_OPERATIONAL:
+		break;
 	case UFSHCD_STATE_EH_SCHEDULED_NON_FATAL:
+		/*
+		 * SCSI error handler can call ->queuecommand() while UFS error
+		 * handler is in progress. Error interrupts could change the
+		 * state from UFSHCD_STATE_RESET to
+		 * UFSHCD_STATE_EH_SCHEDULED_NON_FATAL. Prevent requests
+		 * being issued in that case.
+		 */
+		if (ufshcd_eh_in_progress(hba)) {
+			err = SCSI_MLQUEUE_HOST_BUSY;
+			goto out;
+		}
 		break;
 	case UFSHCD_STATE_EH_SCHEDULED_FATAL:
 		/*
-- 
2.25.1


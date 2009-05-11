From: Andy Yan <ayan@marvell.com>
Subject: [PATCH 3/5] mvsas: bug fix, null pointer may be used
Date: Tue, 12 May 2009 01:22:16 +0800
Message-ID: <20090511172216.GC9698@Andy.marvell.com>
Reply-To: ayan@marvell.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host2.marvell.com ([65.219.4.2]:22215 "EHLO maili.marvell.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752181AbZEKIbb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 May 2009 04:31:31 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: james.bottomley@hansenpartnership.com, jeff@garzik.org

>From d4529158b4e32d68b41a052c9b66de7243e0c4ce Mon Sep 17 00:00:00 2001
From: Andy Yan <ayan@marvell.com>
Date: Mon, 11 May 2009 21:49:52 +0800
Subject: [PATCH 3/5] mvsas: bug fix, null pointer may be used

Null pointer check to avoid corruption.

Signed-off-by: Ying Chu <jasonchu@marvell.com>
Signed-off-by: Andy Yan <ayan@marvell.com>
Signed-off-by: Ke Wei <kewei@marvell.com>

---
 drivers/scsi/mvsas/mv_sas.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/mvsas/mv_sas.c b/drivers/scsi/mvsas/mv_sas.c
index 4279b5e..3fc396f 100644
--- a/drivers/scsi/mvsas/mv_sas.c
+++ b/drivers/scsi/mvsas/mv_sas.c
@@ -1873,11 +1873,11 @@ int mvs_slot_complete(struct mvs_info *mvi, u32 rx_desc, u32 flags)
 	}
 
 out:
-	if (mvi_dev)
+	if (mvi_dev) {
 		mvi_dev->runing_req--;
-	if (sas_protocol_ata(task->task_proto))
-		mvs_free_reg_set(mvi, mvi_dev);
-
+		if (sas_protocol_ata(task->task_proto))
+			mvs_free_reg_set(mvi, mvi_dev);
+	}
 	mvs_slot_task_free(mvi, task, slot, slot_idx);
 	sts = tstat->stat;
 
-- 
1.6.2.1


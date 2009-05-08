From: Ying Chu <jasonchu@marvell.com>
Subject: [PATCH 1/4] mvsas: bugfix for NULL pointer execption
Date: Fri, 8 May 2009 14:15:04 +0800
Message-ID: <20090508061504.GA1880@jason.marvell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host2.marvell.com ([65.219.4.2]:48857 "EHLO maili.marvell.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752462AbZEHGPN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 8 May 2009 02:15:13 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jeff@garzik.org, james.bottomley@hansenpartnership.com

>From 347191384292c6e9a9a572c657049bc11615fb82 Mon Sep 17 00:00:00 2001
From: Andy <ayan@marvell.com>
Date: Mon, 4 May 2009 23:29:26 +0800
Subject: [PATCH 1/4] mvsas: bug fix, null pointer may be used

Null pointer exception when mvi_dev is null.

Signed-off-by: Ying Chu <jasonchu@marvell.com>
Signed-off-by: Andy Yan <ayan@marvell.com>
Signed-off-by: Ke Wei <kewei@marvell.com>
---
 drivers/scsi/mvsas/mv_sas.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/mvsas/mv_sas.c b/drivers/scsi/mvsas/mv_sas.c
index d79ac17..318ec01 100644
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
1.6.0.3

-- 
Regards,
Ying Chu

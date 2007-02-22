From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 2/2]: sas_ata: Don't reset the phy in post_internal_command
Date: Thu, 22 Feb 2007 13:39:58 -0800
Message-ID: <45DE0DAE.5040402@us.ibm.com>
References: <20070130091814.31530.23152.stgit@elm3a70.beaverton.ibm.com> <20070130091841.31530.81645.stgit@elm3a70.beaverton.ibm.com> <45C98421.7020907@gmail.com>
Reply-To: "Darrick J. Wong" <djwong@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:49902 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751936AbXBVVkA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Feb 2007 16:40:00 -0500
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e33.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l1MLe0u4013247
	for <linux-scsi@vger.kernel.org>; Thu, 22 Feb 2007 16:40:00 -0500
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.2) with ESMTP id l1MLdxEP491800
	for <linux-scsi@vger.kernel.org>; Thu, 22 Feb 2007 14:39:59 -0700
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l1MLdxNI002586
	for <linux-scsi@vger.kernel.org>; Thu, 22 Feb 2007 14:39:59 -0700
In-Reply-To: <45C98421.7020907@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Tejun Heo <htejun@gmail.com>, alexisb@us.ibm.com

We don't need to reset the SAS phy in sas_ata_post_internal; all
that is necessary is to clear out the task from the SAS HA.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 drivers/scsi/libsas/sas_ata.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index c92f4b6..d91c5ba 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -281,11 +281,6 @@ static void sas_ata_post_internal(struct
 
 		qc->driver_data = NULL;
 		if (task) {
-			/* Should this be a AT(API) device reset? */
-			spin_lock_irqsave(&task->task_state_lock, flags);
-			task->task_state_flags |= SAS_TASK_NEED_DEV_RESET;
-			spin_unlock_irqrestore(&task->task_state_lock, flags);
-
 			task->uldd_task = NULL;
 			__sas_task_abort(task);
 		}

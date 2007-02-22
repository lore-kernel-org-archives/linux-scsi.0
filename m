From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 1/2] sas_ata: Rename ata_queued_cmd->lldd_task to driver_data
Date: Thu, 22 Feb 2007 13:39:53 -0800
Message-ID: <45DE0DA9.7000200@us.ibm.com>
References: <20070130091814.31530.23152.stgit@elm3a70.beaverton.ibm.com> <20070130091841.31530.81645.stgit@elm3a70.beaverton.ibm.com> <45C98421.7020907@gmail.com>
Reply-To: "Darrick J. Wong" <djwong@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:49735 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751926AbXBVVj4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Feb 2007 16:39:56 -0500
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e33.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l1MLdtUg013041
	for <linux-scsi@vger.kernel.org>; Thu, 22 Feb 2007 16:39:55 -0500
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.2) with ESMTP id l1MLdtGG501842
	for <linux-scsi@vger.kernel.org>; Thu, 22 Feb 2007 14:39:55 -0700
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l1MLdsfb002263
	for <linux-scsi@vger.kernel.org>; Thu, 22 Feb 2007 14:39:54 -0700
In-Reply-To: <45C98421.7020907@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Tejun Heo <htejun@gmail.com>, alexisb@us.ibm.com

Per Tejun's request, rename the lldd_task field and add comments about it.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 drivers/scsi/libsas/sas_ata.c |    8 ++++----
 include/linux/libata.h        |    4 +++-
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index 2db2589..c92f4b6 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -122,7 +122,7 @@ static void sas_ata_task_done(struct sas
 		}
 	}
 
-	qc->lldd_task = NULL;
+	qc->driver_data = NULL;
 	if (qc->scsicmd)
 		ASSIGN_SAS_TASK(qc->scsicmd, NULL);
 	ata_qc_complete(qc);
@@ -192,7 +192,7 @@ static unsigned int sas_ata_qc_issue(str
 	task->scatter = qc->__sg;
 	task->ata_task.retry_count = 1;
 	task->task_state_flags = SAS_TASK_STATE_PENDING;
-	qc->lldd_task = task;
+	qc->driver_data = task;
 
 	switch (qc->tf.protocol) {
 	case ATA_PROT_NCQ:
@@ -276,10 +276,10 @@ static void sas_ata_post_internal(struct
 		 * bother with sas_ata_task_done.  But we still
 		 * ought to abort the task.
 		 */
-		struct sas_task *task = qc->lldd_task;
+		struct sas_task *task = qc->driver_data;
 		unsigned long flags;
 
-		qc->lldd_task = NULL;
+		qc->driver_data = NULL;
 		if (task) {
 			/* Should this be a AT(API) device reset? */
 			spin_lock_irqsave(&task->task_state_lock, flags);
diff --git a/include/linux/libata.h b/include/linux/libata.h
index a20646c..a8eafc7 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -445,7 +445,9 @@ struct ata_queued_cmd {
 	ata_qc_cb_t		complete_fn;
 
 	void			*private_data;
-	void			*lldd_task;
+
+	/* This is owned by a low level libata client */
+	void			*driver_data;
 };
 
 struct ata_port_stats {

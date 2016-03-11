From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 10/11] scsi: bnx2fc: fix hotplug race in bnx2fc_process_new_cqes()
Date: Fri, 11 Mar 2016 16:29:02 +0100
Message-ID: <1457710143-29182-11-git-send-email-bigeasy@linutronix.de>
References: <1457710143-29182-1-git-send-email-bigeasy@linutronix.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from www.linutronix.de ([62.245.132.108]:37923 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932567AbcCKP3Z (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Mar 2016 10:29:25 -0500
In-Reply-To: <1457710143-29182-1-git-send-email-bigeasy@linutronix.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, rt@linutronix.de, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, QLogic-Storage-Upstream@qlogic.com, Christoph Hellwig <hch@lst.de>

The ->iothread is accessed without holding the lock. Take this:

 CPU A                                  CPU B
-------                                -------
bnx2fc_process_new_cqes()               bnx2fc_percpu_thread_destroy()
 spin_lock_bh(fp_work_lock);
 fps->iothread != NULL
 list_add_tail(work)
 spin_unlock_bh(&fps->fp_work_lock);     spin_lock_bh(&fps->fp_work_lock);
                                         fps->iothread = NULL
 if (fps->iothread && work)
	...
 else
  bnx2fc_process_cq_compl(work)          bnx2fc_process_cq_compl(work);

CPU A will process wqe despite having it added to the work list of CPU
B which will at the same time clean up the queued wqe.

The fix is to add the item to the list and wakeup the thread while still
holding the lock. If the item was not added to the list then the
`process' variable is still true in which case we have to do manually.

Cc: QLogic-Storage-Upstream@qlogic.com
Cc: "James E.J. Bottomley" <JBottomley@odin.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/scsi/bnx2fc/bnx2fc_hwi.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_hwi.c b/drivers/scsi/bnx2fc/bnx2fc_hwi.c
index 28c671b609b2..1427062e86f0 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_hwi.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_hwi.c
@@ -1045,6 +1045,7 @@ int bnx2fc_process_new_cqes(struct bnx2fc_rport *tgt)
 			struct bnx2fc_work *work = NULL;
 			struct bnx2fc_percpu_s *fps = NULL;
 			unsigned int cpu = wqe % num_possible_cpus();
+			bool process = true;
 
 			fps = &per_cpu(bnx2fc_percpu, cpu);
 			spin_lock_bh(&fps->fp_work_lock);
@@ -1052,16 +1053,16 @@ int bnx2fc_process_new_cqes(struct bnx2fc_rport *tgt)
 				goto unlock;
 
 			work = bnx2fc_alloc_work(tgt, wqe);
-			if (work)
+			if (work) {
 				list_add_tail(&work->list,
 					      &fps->work_list);
+				wake_up_process(fps->iothread);
+				process = false;
+			}
 unlock:
 			spin_unlock_bh(&fps->fp_work_lock);
 
-			/* Pending work request completion */
-			if (fps->iothread && work)
-				wake_up_process(fps->iothread);
-			else
+			if (process)
 				bnx2fc_process_cq_compl(tgt, wqe);
 			num_free_sqes++;
 		}
-- 
2.7.0


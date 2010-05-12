From: Dan Carpenter <error27@gmail.com>
Subject: [patch] libsas: potential null dereference
Date: Thu, 13 May 2010 00:53:41 +0200
Message-ID: <20100512225341.GA5695@bicker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@suse.de>
Cc: Tejun Heo <tj@kernel.org>, Vasu Dev <vasu.dev@intel.com>, Mike Christie <michaelc@cs.wisc.edu>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The "sc" variable can potentially be null here, so we have to initialize
"q" later.  This was introduced in: 70b25f890 "[SCSI] fix locking around
blk_abort_request()"

Signed-off-by: Dan Carpenter <error27@gmail.com>
---
I appologize if I sent this already.  I was having trouble with my email 
earlier today and I don't see this in my gmail outbox.

diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index 8228350..96dc7d0 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -1030,7 +1030,7 @@ int __sas_task_abort(struct sas_task *task)
 void sas_task_abort(struct sas_task *task)
 {
 	struct scsi_cmnd *sc = task->uldd_task;
-	struct request_queue *q = sc->device->request_queue;
+	struct request_queue *q;
 	unsigned long flags;
 
 	/* Escape for libsas internal commands */
@@ -1046,6 +1046,7 @@ void sas_task_abort(struct sas_task *task)
 		return;
 	}
 
+	q = sc->device->request_queue;
 	spin_lock_irqsave(q->queue_lock, flags);
 	blk_abort_request(sc->request);
 	spin_unlock_irqrestore(q->queue_lock, flags);

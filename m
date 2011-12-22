From: Shaohua Li <shaohua.li@intel.com>
Subject: [patch 1/2]scsi: scsi_run_queue() doesn't use local list to handle
 starved sdev
Date: Thu, 22 Dec 2011 11:10:12 +0800
Message-ID: <1324523412.22361.471.camel@sli10-conroe>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: lkml <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org
Cc: JBottomley@Parallels.com, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>, Ted Ts'o <tytso@mit.edu>, "Wu, Fengguang" <fengguang.wu@intel.com>, "Darrick J. Wong" <djwong@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org

scsi_run_queue() picks off all sdev from host starved_list to a local list,
then handle them. If there are multiple threads running scsi_run_queue(),
the starved_list will get messed. This is quite common, because request
rq_affinity is on by default.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
---
 drivers/scsi/scsi_lib.c |   21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

Index: linux/drivers/scsi/scsi_lib.c
===================================================================
--- linux.orig/drivers/scsi/scsi_lib.c	2011-12-21 16:56:23.000000000 +0800
+++ linux/drivers/scsi/scsi_lib.c	2011-12-22 09:33:09.000000000 +0800
@@ -401,9 +401,8 @@ static inline int scsi_host_is_busy(stru
  */
 static void scsi_run_queue(struct request_queue *q)
 {
-	struct scsi_device *sdev = q->queuedata;
+	struct scsi_device *sdev = q->queuedata, *head_sdev = NULL;
 	struct Scsi_Host *shost;
-	LIST_HEAD(starved_list);
 	unsigned long flags;
 
 	/* if the device is dead, sdev will be NULL, so no queue to run */
@@ -415,9 +414,8 @@ static void scsi_run_queue(struct reques
 		scsi_single_lun_run(sdev);
 
 	spin_lock_irqsave(shost->host_lock, flags);
-	list_splice_init(&shost->starved_list, &starved_list);
 
-	while (!list_empty(&starved_list)) {
+	while (!list_empty(&shost->starved_list)) {
 		/*
 		 * As long as shost is accepting commands and we have
 		 * starved queues, call blk_run_queue. scsi_request_fn
@@ -431,8 +429,13 @@ static void scsi_run_queue(struct reques
 		if (scsi_host_is_busy(shost))
 			break;
 
-		sdev = list_entry(starved_list.next,
+		sdev = list_entry(shost->starved_list.next,
 				  struct scsi_device, starved_entry);
+		if (sdev == head_sdev)
+			break;
+		if (!head_sdev)
+			head_sdev = sdev;
+
 		list_del_init(&sdev->starved_entry);
 		if (scsi_target_is_busy(scsi_target(sdev))) {
 			list_move_tail(&sdev->starved_entry,
@@ -445,9 +448,13 @@ static void scsi_run_queue(struct reques
 		__blk_run_queue(sdev->request_queue);
 		spin_unlock(sdev->request_queue->queue_lock);
 		spin_lock(shost->host_lock);
+		/*
+		 * the head sdev is no longer starved and removed from the
+		 * starved list, select a new sdev as head.
+		 */
+		if (head_sdev == sdev && list_empty(&sdev->starved_entry))
+			head_sdev = NULL;
 	}
-	/* put any unprocessed entries back */
-	list_splice(&starved_list, &shost->starved_list);
 	spin_unlock_irqrestore(shost->host_lock, flags);
 
 	blk_run_queue(q);

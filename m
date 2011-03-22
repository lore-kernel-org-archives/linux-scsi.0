From: "Bhanu Gollapudi" <bprakash@broadcom.com>
Subject: [PATCH] bnx2fc: IO completion not processed due to missed
 wakeup
Date: Mon, 21 Mar 2011 18:51:13 -0700
Message-ID: <1300758673.644.435.camel@LTSJC-BPRAKASH.corp.ad.broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=cp1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4613 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756269Ab1CVBv0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Mar 2011 21:51:26 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James.Bottomley@suse.de" <James.Bottomley@suse.de>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "devel@open-fcoe.org" <devel@open-fcoe.org>, mchan@broadcom.com

Driver does not detect a new CQE (completion queue entry) if a thread receives
the wakup when it is in TASK_RUNNING state. Fix is to set the state to
TASK_INTERRUPTIBLE while holding the fp_work_lock.

Also, Use __set_current_task() since it is now set inside a spinlock with
synchronization.

Two other related optimizations:

1.  After we exit the while (!kthread_should_stop()) loop, use
__set_current_state() since synchronization is no longer needed.

2.  Remove set_current_state(TASK_RUNNING) after schedule() since it
should always be TASK_RUNNING after schedule().

Reviewed-by: Michael Chan <mchan@broadcom.com>
Signed-off-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
---
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index 2056890..e2e6475 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -437,17 +437,16 @@ static int bnx2fc_l2_rcv_thread(void *arg)
 	set_current_state(TASK_INTERRUPTIBLE);
 	while (!kthread_should_stop()) {
 		schedule();
-		set_current_state(TASK_RUNNING);
 		spin_lock_bh(&bg->fcoe_rx_list.lock);
 		while ((skb = __skb_dequeue(&bg->fcoe_rx_list)) != NULL) {
 			spin_unlock_bh(&bg->fcoe_rx_list.lock);
 			bnx2fc_recv_frame(skb);
 			spin_lock_bh(&bg->fcoe_rx_list.lock);
 		}
+		__set_current_state(TASK_INTERRUPTIBLE);
 		spin_unlock_bh(&bg->fcoe_rx_list.lock);
-		set_current_state(TASK_INTERRUPTIBLE);
 	}
-	set_current_state(TASK_RUNNING);
+	__set_current_state(TASK_RUNNING);
 	return 0;
 }
 
@@ -569,7 +568,6 @@ int bnx2fc_percpu_io_thread(void *arg)
 	set_current_state(TASK_INTERRUPTIBLE);
 	while (!kthread_should_stop()) {
 		schedule();
-		set_current_state(TASK_RUNNING);
 		spin_lock_bh(&p->fp_work_lock);
 		while (!list_empty(&p->work_list)) {
 			list_splice_init(&p->work_list, &work_list);
@@ -583,10 +581,10 @@ int bnx2fc_percpu_io_thread(void *arg)
 
 			spin_lock_bh(&p->fp_work_lock);
 		}
+		__set_current_state(TASK_INTERRUPTIBLE);
 		spin_unlock_bh(&p->fp_work_lock);
-		set_current_state(TASK_INTERRUPTIBLE);
 	}
-	set_current_state(TASK_RUNNING);
+	__set_current_state(TASK_RUNNING);
 
 	return 0;
 }
-- 
1.7.0.6





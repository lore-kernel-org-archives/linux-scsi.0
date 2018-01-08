From: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Subject: [PATCH 4/4] IB/srp: Fix a sleep-in-invalid-context bug
Date: Mon,  8 Jan 2018 10:50:11 -0800
Message-ID: <20180108185011.30018-5-bart.vanassche@wdc.com>
References: <20180108185011.30018-1-bart.vanassche@wdc.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180108185011.30018-1-bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Cc: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Martin K . Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

The previous two patches guarantee that srp_queuecommand() does not get
invoked while reconnecting occurs. Hence remove the code from
srp_queuecommand() that prevents command queueing while reconnecting.
This patch avoids that the following can appear in the kernel log:

BUG: sleeping function called from invalid context at kernel/locking/mutex.c:747
in_atomic(): 1, irqs_disabled(): 0, pid: 5600, name: scsi_eh_9
1 lock held by scsi_eh_9/5600:
 #0:  (rcu_read_lock){....}, at: [<00000000cbb798c7>] __blk_mq_run_hw_queue+0xf1/0x1e0
Preemption disabled at:
[<00000000139badf2>] __blk_mq_delay_run_hw_queue+0x78/0xf0
CPU: 9 PID: 5600 Comm: scsi_eh_9 Tainted: G        W        4.15.0-rc4-dbg+ #1
Hardware name: Dell Inc. PowerEdge R720/0VWT90, BIOS 2.5.4 01/22/2016
Call Trace:
 dump_stack+0x67/0x99
 ___might_sleep+0x16a/0x250 [ib_srp]
 __mutex_lock+0x46/0x9d0
 srp_queuecommand+0x356/0x420 [ib_srp]
 scsi_dispatch_cmd+0xf6/0x3f0
 scsi_queue_rq+0x4a8/0x5f0
 blk_mq_dispatch_rq_list+0x73/0x440
 blk_mq_sched_dispatch_requests+0x109/0x1a0
 __blk_mq_run_hw_queue+0x131/0x1e0
 __blk_mq_delay_run_hw_queue+0x9a/0xf0
 blk_mq_run_hw_queue+0xc0/0x1e0
 blk_mq_start_hw_queues+0x2c/0x40
 scsi_run_queue+0x18e/0x2d0
 scsi_run_host_queues+0x22/0x40
 scsi_error_handler+0x18d/0x5f0
 kthread+0x11c/0x140
 ret_from_fork+0x24/0x30

Signed-off-by: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Cc: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 21 ++-------------------
 1 file changed, 2 insertions(+), 19 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 972d4b3c5223..670f187ecb91 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -2149,7 +2149,6 @@ static void srp_handle_qp_err(struct ib_cq *cq, struct ib_wc *wc,
 static int srp_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *scmnd)
 {
 	struct srp_target_port *target = host_to_target(shost);
-	struct srp_rport *rport = target->rport;
 	struct srp_rdma_ch *ch;
 	struct srp_request *req;
 	struct srp_iu *iu;
@@ -2159,16 +2158,6 @@ static int srp_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *scmnd)
 	u32 tag;
 	u16 idx;
 	int len, ret;
-	const bool in_scsi_eh = !in_interrupt() && current == shost->ehandler;
-
-	/*
-	 * The SCSI EH thread is the only context from which srp_queuecommand()
-	 * can get invoked for blocked devices (SDEV_BLOCK /
-	 * SDEV_CREATED_BLOCK). Avoid racing with srp_reconnect_rport() by
-	 * locking the rport mutex if invoked from inside the SCSI EH.
-	 */
-	if (in_scsi_eh)
-		mutex_lock(&rport->mutex);
 
 	scmnd->result = srp_chkready(target->rport);
 	if (unlikely(scmnd->result))
@@ -2230,13 +2219,7 @@ static int srp_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *scmnd)
 		goto err_unmap;
 	}
 
-	ret = 0;
-
-unlock_rport:
-	if (in_scsi_eh)
-		mutex_unlock(&rport->mutex);
-
-	return ret;
+	return 0;
 
 err_unmap:
 	srp_unmap_data(scmnd, ch, req);
@@ -2258,7 +2241,7 @@ static int srp_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *scmnd)
 		ret = SCSI_MLQUEUE_HOST_BUSY;
 	}
 
-	goto unlock_rport;
+	return ret;
 }
 
 /*
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

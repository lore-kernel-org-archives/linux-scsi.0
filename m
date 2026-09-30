Received: from mta0.migadu.com (out-23.mta0.migadu.com [91.218.175.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAF9C4D2EFE
	for <linux-scsi@vger.kernel.org>; Wed, 30 Sep 2026 14:56:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.23
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790780185; cv=none; b=dHJcVr2VpqrAj7gYfjYtM//ARdDeg+TobcYQ2PULWbwYTuLR1O3Av8MCqXa/RYXK1USXqe5G65F5dRuGOBEukZjqktDzBW8yE7Tlqm6/Cj8U/8K0mLfQN1QrKmPtSrzi2oO2fvzRgW47otN6MBQcoCNTeOShk9TunQSQUwwYoyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790780185; c=relaxed/simple;
	bh=pasrZaPKb/TAYHbVtyzjAjGrmwQkA+1eWsbA5GYcaXs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bUv37+gQmUs5y78P/iJ6s9t+wMSxkBni4/b4zWdhp8J6XX/8CbDLOmeONHn4iqXwXjvpYa1ZRhNY5e3Sza9jcrs8FDLTUFRT2gXHjj22K8fnsyxy0CP2QBpGAGtTrZzc3dPqSgSWazhJ3kc78I2kNxlDmFQ9lYL6JcdD33J34ek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=LhXbJXiD; arc=none smtp.client-ip=91.218.175.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="LhXbJXiD"
X-Envelope-To: linux-scsi@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=pasrZaPKb/TAYHbVtyzjAjGrmwQkA+1eWsbA5GYcaXs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790780174; v=1; x=1791384974;
 b=LhXbJXiDfLtJ2rEgGWRjpMVt3u2d5xxA6LGQVH03sOxnchvglsonIjfKE7ImG4azfPIhZFv9
 cbPxJgNg2H/6NPY6wI7cb/Bxp1go9RAp6xjTBCKucSHVx4ACMVf93oeYhQnSECCqrkixDzJSo5i
 O9fyaU5MhDqEKbPpGflrZdT4=
X-Envelope-To: linux-scsi@vger.kernel.org
Received: by mta12.migadu.com with ESMTPS id e1b0546c58819580;
	Wed, 30 Sep 2026 14:56:13 +0000
X-Mizu-Trace-ID: e1b0546c58819580
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: mkp@kernel.org,
	sathya.prakash@broadcom.com,
	kashyap.desai@broadcom.com,
	sumit.saxena@broadcom.com,
	sreekanth.reddy@broadcom.com,
	mpi3mr-linuxdrv.pdl@broadcom.com,
	James.Bottomley@HansenPartnership.com,
	ranjan.kumar@broadcom.com,
	chandrakanth.patil@broadcom.com,
	thenzl@redhat.com,
	hare@suse.de,
	himanshu.madhani@oracle.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Usama Arif <usama.arif@linux.dev>
Subject: [PATCH 2/2] scsi: mpi3mr: Stop IRQ polling when no reply is ready
Date: Wed, 30 Sep 2026 07:55:49 -0700
Message-ID: <20260930145606.2632749-3-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260930145606.2632749-1-usama.arif@linux.dev>
References: <20260930145606.2632749-1-usama.arif@linux.dev>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Once more than MPI3MR_IRQ_POLL_TRIGGER_IOCOUNT I/Os are pending on a reply
queue, the next interrupt hands the queue to the SCHED_FIFO IRQ thread,
which polls it until no I/O is pending or it has processed max_host_ios
replies. Busy HDD queues almost always have I/O pending, so polling runs
for about 45 seconds, waking every ~20us for replies that arrive ~5ms
apart.

On a machine configured like Meta's HDD storage hosts, with 36 SATA HDDs
behind a SAS40xx HBA, 4k random reads at 16 I/Os per disk make the IRQ
threads wake up 236 times per I/O. They use 2.2 CPUs, plus 2.3 CPUs of
timer interrupts, for 6.4K IOPS, and a CPU-bound task on the same CPUs
loses 30% of its throughput.

Let's go back to interrupts once a poll after a sleep finds the queue
empty. A later reply raises an interrupt, which enable_irq() replays if it
arrived while polling, and a handler that finds the queue busy hands it
back to the thread. The empty check must be made while owning the queue:
a busy queue's owner may have missed the reply whose interrupt woke the
thread, leaving nothing to replay. If more than
MPI3MR_IRQ_POLL_TRIGGER_IOCOUNT I/Os remain, enable_irq_poll is set again
so the next interrupt resumes polling. It is cleared first and pend_ios
is rechecked after a full barrier pairing with atomic_inc_return() in
mpi3mr_op_request_post(), so a concurrent submitter's trigger is not lost.

In the HDD test, the IRQ threads now wake up twice per I/O instead of 236
times and use 0.03 CPUs instead of 2.2, and the CPU-bound task loses 0.6%
instead of 30%. Faster queues are mostly unaffected: one that finds a
reply on every poll keeps polling, and one whose replies are further apart
than the poll interval switches to interrupts without losing throughput,
as drive-cache reads at 270K IOPS show. The exception is a single reply
queue whose CPU is saturated by both submission and completion: its polls
sometimes find the queue empty, and the extra interrupts cost about 5% of
its IOPS.

Also mark all enable_irq_poll accesses with READ_ONCE() and WRITE_ONCE().
Submitters, the hard IRQ and the IRQ thread read and write
the flag on different CPUs without a common lock. Plain accesses would
let the compiler assume that no other CPU changes it, and the memory
model only guarantees the barrier pairing above for marked accesses.

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 drivers/scsi/mpi3mr/mpi3mr.h    |  2 +-
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 60 ++++++++++++++++++++++++---------
 drivers/scsi/mpi3mr/mpi3mr_os.c |  2 +-
 3 files changed, 46 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index d6e16707fd97c..4012757d2cf3b 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -1525,7 +1525,7 @@ void mpi3mr_check_rh_fault_ioc(struct mpi3mr_ioc *mrioc, u32 reason_code);
 void mpi3mr_print_fault_info(struct mpi3mr_ioc *mrioc);
 void mpi3mr_check_rh_fault_ioc(struct mpi3mr_ioc *mrioc, u32 reason_code);
 int mpi3mr_process_op_reply_q(struct mpi3mr_ioc *mrioc,
-	struct op_reply_qinfo *op_reply_q);
+	struct op_reply_qinfo *op_reply_q, bool *checked_empty);
 int mpi3mr_blk_mq_poll(struct Scsi_Host *shost, unsigned int queue_num);
 void mpi3mr_bsg_init(struct mpi3mr_ioc *mrioc);
 void mpi3mr_bsg_exit(struct mpi3mr_ioc *mrioc);
diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index 102f84667a5cf..6f113d8625bb4 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -564,16 +564,18 @@ mpi3mr_get_reply_desc(struct op_reply_qinfo *op_reply_q, u32 reply_ci)
  * mpi3mr_process_op_reply_q - Operational reply queue handler
  * @mrioc: Adapter instance reference
  * @op_reply_q: Operational reply queue info
+ * @checked_empty: Optional, set to true if the queue was owned and had no
+ *		   reply ready, false otherwise
  *
  * Checks the specific operational reply queue and drains the
  * reply queue entries until the queue is empty and process the
  * individual reply descriptors.
  *
- * Return: 0 if queue is already processed,or number of reply
- *	    descriptors processed.
+ * Return: Number of reply descriptors processed, 0 if no reply was ready or
+ *	   another context is processing the queue.
  */
 int mpi3mr_process_op_reply_q(struct mpi3mr_ioc *mrioc,
-	struct op_reply_qinfo *op_reply_q)
+	struct op_reply_qinfo *op_reply_q, bool *checked_empty)
 {
 	struct op_req_qinfo *op_req_q;
 	u32 exp_phase;
@@ -583,6 +585,9 @@ int mpi3mr_process_op_reply_q(struct mpi3mr_ioc *mrioc,
 	struct mpi3_default_reply_descriptor *reply_desc;
 	u16 req_q_idx = 0, reply_qidx, threshold_comps = 0;
 
+	if (checked_empty)
+		*checked_empty = false;
+
 	if (!op_reply_q)
 		return 0;
 
@@ -605,6 +610,8 @@ int mpi3mr_process_op_reply_q(struct mpi3mr_ioc *mrioc,
 		if ((le16_to_cpu(reply_desc->reply_flags) &
 		    MPI3_REPLY_DESCRIPT_FLAGS_PHASE_MASK) == exp_phase)
 			goto process_desc;
+		if (checked_empty)
+			*checked_empty = true;
 		atomic_dec(&op_reply_q->in_use);
 		return 0;
 	}
@@ -667,7 +674,7 @@ int mpi3mr_process_op_reply_q(struct mpi3mr_ioc *mrioc,
 		 */
 		if ((num_op_reply > mrioc->max_host_ios) &&
 			(threaded_isr_poll == true)) {
-			op_reply_q->enable_irq_poll = true;
+			WRITE_ONCE(op_reply_q->enable_irq_poll, true);
 			break;
 		}
 #endif
@@ -712,7 +719,7 @@ int mpi3mr_blk_mq_poll(struct Scsi_Host *shost, unsigned int queue_num)
 		return 0;
 
 	num_entries = mpi3mr_process_op_reply_q(mrioc,
-			&mrioc->op_reply_qinfo[queue_num]);
+			&mrioc->op_reply_qinfo[queue_num], NULL);
 
 	return num_entries;
 }
@@ -739,7 +746,8 @@ static irqreturn_t mpi3mr_isr_primary(int irq, void *privdata)
 		num_admin_replies = mpi3mr_process_admin_reply_q(mrioc);
 	op_reply_q = READ_ONCE(intr_info->op_reply_q);
 	if (op_reply_q)
-		num_op_reply = mpi3mr_process_op_reply_q(mrioc, op_reply_q);
+		num_op_reply = mpi3mr_process_op_reply_q(mrioc, op_reply_q,
+							 NULL);
 
 	if (num_admin_replies || num_op_reply)
 		return IRQ_HANDLED;
@@ -769,7 +777,7 @@ static irqreturn_t mpi3mr_isr(int irq, void *privdata)
 	if ((threaded_isr_poll == false) || !op_reply_q)
 		return ret;
 
-	if (!op_reply_q->enable_irq_poll ||
+	if (!READ_ONCE(op_reply_q->enable_irq_poll) ||
 	    !atomic_read(&op_reply_q->pend_ios))
 		return ret;
 
@@ -783,8 +791,9 @@ static irqreturn_t mpi3mr_isr(int irq, void *privdata)
  * @irq: IRQ
  * @privdata: Interrupt info
  *
- * poll for pending I/O completions in a loop until pending I/Os
- * present or controller queue depth I/Os are processed.
+ * Poll for pending I/O completions until no I/Os are pending, a post-sleep
+ * check finds no reply ready while owning the queue, or controller queue
+ * depth I/Os are processed.
  *
  * Return: IRQ_NONE or IRQ_HANDLED
  */
@@ -795,6 +804,7 @@ static irqreturn_t mpi3mr_isr_poll(int irq, void *privdata)
 	struct op_reply_qinfo *op_reply_q;
 	u16 midx;
 	u32 num_op_reply = 0;
+	bool slept = false, idle = false, checked_empty;
 
 	if (!intr_info)
 		return IRQ_NONE;
@@ -819,17 +829,34 @@ static irqreturn_t mpi3mr_isr_poll(int irq, void *privdata)
 
 		if (!midx)
 			mpi3mr_process_admin_reply_q(mrioc);
-		num_op_reply +=
-		    mpi3mr_process_op_reply_q(mrioc, op_reply_q);
+		num_op_reply += mpi3mr_process_op_reply_q(mrioc, op_reply_q,
+							  &checked_empty);
+		/* Stop only on an empty check made while owning the queue */
+		if (slept && checked_empty) {
+			idle = true;
+			break;
+		}
 		if (!atomic_read(&op_reply_q->pend_ios))
 			break;
 
 		usleep_range(MPI3MR_IRQ_POLL_SLEEP, 10 * MPI3MR_IRQ_POLL_SLEEP);
+		slept = true;
 
 	} while (num_op_reply < mrioc->max_host_ios);
 
-	if (op_reply_q)
-		op_reply_q->enable_irq_poll = false;
+	if (op_reply_q) {
+		WRITE_ONCE(op_reply_q->enable_irq_poll, false);
+		if (idle) {
+			/*
+			 * Recheck after clearing, pairs with atomic_inc_return()
+			 * in mpi3mr_op_request_post().
+			 */
+			smp_mb();
+			if (atomic_read(&op_reply_q->pend_ios) >
+			    MPI3MR_IRQ_POLL_TRIGGER_IOCOUNT)
+				WRITE_ONCE(op_reply_q->enable_irq_poll, true);
+		}
+	}
 	enable_irq(intr_info->os_irq);
 
 	return IRQ_HANDLED;
@@ -2337,7 +2364,7 @@ static int mpi3mr_create_op_reply_q(struct mpi3mr_ioc *mrioc, u16 qidx)
 	op_reply_q->ephase = 1;
 	atomic_set(&op_reply_q->pend_ios, 0);
 	atomic_set(&op_reply_q->in_use, 0);
-	op_reply_q->enable_irq_poll = false;
+	WRITE_ONCE(op_reply_q->enable_irq_poll, false);
 	op_reply_q->qfull_watermark =
 		op_reply_q->num_replies - (MPI3MR_THRESHOLD_REPLY_COUNT * 2);
 
@@ -2688,7 +2715,7 @@ int mpi3mr_op_request_post(struct mpi3mr_ioc *mrioc,
 		midx = REPLY_QUEUE_IDX_TO_MSIX_IDX(
 		    reply_qidx, mrioc->op_reply_q_offset);
 		mpi3mr_process_op_reply_q(mrioc,
-		    READ_ONCE(mrioc->intr_info[midx].op_reply_q));
+		    READ_ONCE(mrioc->intr_info[midx].op_reply_q), NULL);
 
 		if (mpi3mr_check_req_qfull(op_req_q)) {
 
@@ -2740,7 +2767,8 @@ int mpi3mr_op_request_post(struct mpi3mr_ioc *mrioc,
 #ifndef CONFIG_PREEMPT_RT
 	if (atomic_inc_return(&mrioc->op_reply_qinfo[reply_qidx].pend_ios)
 	    > MPI3MR_IRQ_POLL_TRIGGER_IOCOUNT)
-		mrioc->op_reply_qinfo[reply_qidx].enable_irq_poll = true;
+		WRITE_ONCE(mrioc->op_reply_qinfo[reply_qidx].enable_irq_poll,
+			   true);
 #else
 	atomic_inc_return(&mrioc->op_reply_qinfo[reply_qidx].pend_ios);
 #endif
diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index 6b0156e54d454..ec5e0ddb04deb 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -4063,7 +4063,7 @@ inline void mpi3mr_poll_pend_io_completions(struct mpi3mr_ioc *mrioc)
 
 	for (i = mrioc->op_reply_q_offset; i < num_of_reply_queues; i++)
 		mpi3mr_process_op_reply_q(mrioc,
-		    READ_ONCE(mrioc->intr_info[i].op_reply_q));
+		    READ_ONCE(mrioc->intr_info[i].op_reply_q), NULL);
 }
 
 /**
-- 
2.53.0-Meta


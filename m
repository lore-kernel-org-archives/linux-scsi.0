From: Douglas Gilbert <dgilbert@interlog.com>
Subject: [PATCH 09/12] scsi_debug: add multiple queue support
Date: Mon, 25 Apr 2016 12:16:36 -0400
Message-ID: <1461600999-28893-10-git-send-email-dgilbert@interlog.com>
References: <1461600999-28893-1-git-send-email-dgilbert@interlog.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:36996 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933004AbcDYQRN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Apr 2016 12:17:13 -0400
In-Reply-To: <1461600999-28893-1-git-send-email-dgilbert@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, tomas.winkler@intel.com, emilne@redhat.com

Add submit_queue parameter (minimum and default: 1; maximum:
nr_cpu_ids) that controls how many queues are built, each with
their own lock and in_use bit vector. Add statistics parameter
which is default on.

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/scsi_debug.c | 662 +++++++++++++++++++++++++++++-----------------
 1 file changed, 416 insertions(+), 246 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index eac62b8..bdc9ece 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -135,6 +135,8 @@ static const char *sdebug_version_date = "20160422";
 #define DEF_VPD_USE_HOSTNO 1
 #define DEF_WRITESAME_LENGTH 0xFFFF
 #define DEF_STRICT 0
+#define DEF_STATISTICS true
+#define DEF_SUBMIT_QUEUES 1
 #define JDELAY_OVERRIDDEN -9999
 
 /* bit mask values for sdebug_opts */
@@ -200,19 +202,14 @@ static const char *sdebug_version_date = "20160422";
 #define SAM2_LUN_ADDRESS_METHOD 0
 
 /* SCSI_DEBUG_CANQUEUE is the maximum number of commands that can be queued
- * (for response) at one time. Can be reduced by max_queue option. Command
- * responses are not queued when jdelay=0 and ndelay=0. The per-device
- * DEF_CMD_PER_LUN can be changed via sysfs:
- * /sys/class/scsi_device/<h:c:t:l>/device/queue_depth but cannot exceed
- * SCSI_DEBUG_CANQUEUE. */
-#define SCSI_DEBUG_CANQUEUE_WORDS  9	/* a WORD is bits in a long */
+ * (for response) per submit queue at one time. Can be reduced by max_queue
+ * option. Command responses are not queued when jdelay=0 and ndelay=0. The
+ * per-device DEF_CMD_PER_LUN can be changed via sysfs:
+ * /sys/class/scsi_device/<h:c:t:l>/device/queue_depth but . */
+#define SCSI_DEBUG_CANQUEUE_WORDS  3	/* a WORD is bits in a long */
 #define SCSI_DEBUG_CANQUEUE  (SCSI_DEBUG_CANQUEUE_WORDS * BITS_PER_LONG)
 #define DEF_CMD_PER_LUN  255
 
-#if DEF_CMD_PER_LUN > SCSI_DEBUG_CANQUEUE
-#warning "Expect DEF_CMD_PER_LUN <= SCSI_DEBUG_CANQUEUE"
-#endif
-
 #define F_D_IN			1
 #define F_D_OUT			2
 #define F_D_OUT_MAYBE		4	/* WRITE SAME, NDOB bit */
@@ -243,7 +240,7 @@ struct sdebug_dev_info {
 	struct sdebug_host_info *sdbg_host;
 	unsigned long uas_bm[1];
 	atomic_t num_in_q;
-	char stopped;		/* TODO: should be atomic */
+	atomic_t stopped;
 	bool used;
 };
 
@@ -260,21 +257,30 @@ struct sdebug_host_info {
 struct sdebug_defer {
 	struct hrtimer hrt;
 	struct execute_work ew;
-	int qa_indx;
+	int qc_indx;
+	int sq_indx;
 };
 
 struct sdebug_queued_cmd {
-	/* in_use flagged by a bit in queued_in_use_bm[] */
+	/* a bit in in_use_bm[] in struct sdebug_queue flags if in use */
 	struct sdebug_defer *sd_dp;
 	struct scsi_cmnd *a_cmnd;
+	unsigned int inj_recovered:1;
+	unsigned int inj_transport:1;
+	unsigned int inj_dif:1;
+	unsigned int inj_dix:1;
+	unsigned int inj_short:1;
 };
 
-struct sdebug_scmd_extra_t {
-	bool inj_recovered;
-	bool inj_transport;
-	bool inj_dif;
-	bool inj_dix;
-	bool inj_short;
+struct sdebug_queue {
+	struct sdebug_queued_cmd qc_arr[SCSI_DEBUG_CANQUEUE];
+	unsigned long in_use_bm[SCSI_DEBUG_CANQUEUE_WORDS];
+	spinlock_t qc_lock;
+	atomic_t blocked;	/* to temporarily stop more being queued */
+	atomic_t cmnd_count;	/* number of incoming commands */
+	atomic_t completions;	/* only command with deferred responses */
+	atomic_t misqueues;	/* completion q different from submission q */
+	atomic_t a_tsf;		/* 'almost task set full' event counter */
 };
 
 struct opcode_info_t {
@@ -324,6 +330,7 @@ enum sdeb_opcode_index {
 	SDEB_I_LAST_ELEMENT = 30,	/* keep this last */
 };
 
+
 static const unsigned char opcode_ind_arr[256] = {
 /* 0x0; 0x0->0x1f: 6 byte cdbs */
 	SDEB_I_TEST_UNIT_READY, SDEB_I_REZERO_UNIT, 0, SDEB_I_REQUEST_SENSE,
@@ -561,7 +568,7 @@ static int sdebug_fake_rw = DEF_FAKE_RW;
 static unsigned int sdebug_guard = DEF_GUARD;
 static int sdebug_lowest_aligned = DEF_LOWEST_ALIGNED;
 static int sdebug_max_luns = DEF_MAX_LUNS;
-static int sdebug_max_queue = SCSI_DEBUG_CANQUEUE;
+static int sdebug_max_queue = SCSI_DEBUG_CANQUEUE;	/* per submit queue */
 static atomic_t retired_max_queue;	/* if > 0 then was prior max_queue */
 static int sdebug_ndelay = DEF_NDELAY;	/* if > 0 then unit is nanoseconds */
 static int sdebug_no_lun_0 = DEF_NO_LUN_0;
@@ -592,10 +599,8 @@ static bool sdebug_strict = DEF_STRICT;
 static bool sdebug_any_injecting_opt;
 static bool sdebug_verbose;
 static bool have_dif_prot;
-
-static atomic_t sdebug_cmnd_count;
-static atomic_t sdebug_completions;
-static atomic_t sdebug_a_tsf;		/* counter of 'almost' TSFs */
+static bool sdebug_statistics = DEF_STATISTICS;
+static bool sdebug_mq_available;
 
 static unsigned int sdebug_store_sectors;
 static sector_t sdebug_capacity;	/* in sectors */
@@ -623,10 +628,9 @@ static int dix_writes;
 static int dix_reads;
 static int dif_errors;
 
-static struct sdebug_queued_cmd queued_arr[SCSI_DEBUG_CANQUEUE];
-static unsigned long queued_in_use_bm[SCSI_DEBUG_CANQUEUE_WORDS];
+static int submit_queues = DEF_SUBMIT_QUEUES;  /* > 1 for multi-queue (mq) */
+static struct sdebug_queue *sdebug_q_arr;  /* ptr to array of submit queues */
 
-static DEFINE_SPINLOCK(queued_arr_lock);
 static DEFINE_RWLOCK(atomic_rw);
 
 static char sdebug_proc_name[] = MY_NAME;
@@ -1425,16 +1429,15 @@ static int resp_start_stop(struct scsi_cmnd * scp,
 			   struct sdebug_dev_info * devip)
 {
 	unsigned char *cmd = scp->cmnd;
-	int power_cond, start;
+	int power_cond, stop;
 
 	power_cond = (cmd[4] & 0xf0) >> 4;
 	if (power_cond) {
 		mk_sense_invalid_fld(scp, SDEB_IN_CDB, 4, 7);
 		return check_condition_result;
 	}
-	start = cmd[4] & 1;
-	if (start == devip->stopped)
-		devip->stopped = !start;
+	stop = !(cmd[4] & 1);
+	atomic_xchg(&devip->stopped, stop);
 	return 0;
 }
 
@@ -2447,6 +2450,7 @@ static int prot_verify_read(struct scsi_cmnd *SCpnt, sector_t start_sec,
 static int resp_read_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 {
 	u8 *cmd = scp->cmnd;
+	struct sdebug_queued_cmd *sqcp;
 	u64 lba;
 	u32 num;
 	u32 ei_lba;
@@ -2506,11 +2510,14 @@ static int resp_read_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 				    "to DIF device\n");
 	}
 	if (unlikely(sdebug_any_injecting_opt)) {
-		struct sdebug_scmd_extra_t *ep = scsi_cmd_priv(scp);
+		sqcp = (struct sdebug_queued_cmd *)scp->host_scribble;
 
-		if (ep->inj_short)
-			num /= 2;
-	}
+		if (sqcp) {
+			if (sqcp->inj_short)
+				num /= 2;
+		}
+	} else
+		sqcp = NULL;
 
 	/* inline check_device_access_params() */
 	if (unlikely(lba + num > sdebug_capacity)) {
@@ -2560,22 +2567,20 @@ static int resp_read_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 
 	scsi_in(scp)->resid = scsi_bufflen(scp) - ret;
 
-	if (unlikely(sdebug_any_injecting_opt)) {
-		struct sdebug_scmd_extra_t *ep = scsi_cmd_priv(scp);
-
-		if (ep->inj_recovered) {
+	if (unlikely(sqcp)) {
+		if (sqcp->inj_recovered) {
 			mk_sense_buffer(scp, RECOVERED_ERROR,
 					THRESHOLD_EXCEEDED, 0);
 			return check_condition_result;
-		} else if (ep->inj_transport) {
+		} else if (sqcp->inj_transport) {
 			mk_sense_buffer(scp, ABORTED_COMMAND,
 					TRANSPORT_PROBLEM, ACK_NAK_TO);
 			return check_condition_result;
-		} else if (ep->inj_dif) {
+		} else if (sqcp->inj_dif) {
 			/* Logical block guard check failed */
 			mk_sense_buffer(scp, ABORTED_COMMAND, 0x10, 1);
 			return illegal_condition_result;
-		} else if (ep->inj_dix) {
+		} else if (sqcp->inj_dix) {
 			mk_sense_buffer(scp, ILLEGAL_REQUEST, 0x10, 1);
 			return illegal_condition_result;
 		}
@@ -2848,25 +2853,29 @@ static int resp_write_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	write_unlock_irqrestore(&atomic_rw, iflags);
 	if (unlikely(-1 == ret))
 		return DID_ERROR << 16;
-	else if (sdebug_verbose && (ret < (num * sdebug_sector_size)))
+	else if (unlikely(sdebug_verbose &&
+			  (ret < (num * sdebug_sector_size))))
 		sdev_printk(KERN_INFO, scp->device,
 			    "%s: write: cdb indicated=%u, IO sent=%d bytes\n",
 			    my_name, num * sdebug_sector_size, ret);
 
 	if (unlikely(sdebug_any_injecting_opt)) {
-		struct sdebug_scmd_extra_t *ep = scsi_cmd_priv(scp);
+		struct sdebug_queued_cmd *sqcp =
+				(struct sdebug_queued_cmd *)scp->host_scribble;
 
-		if (ep->inj_recovered) {
-			mk_sense_buffer(scp, RECOVERED_ERROR,
-					THRESHOLD_EXCEEDED, 0);
-			return check_condition_result;
-		} else if (ep->inj_dif) {
-			/* Logical block guard check failed */
-			mk_sense_buffer(scp, ABORTED_COMMAND, 0x10, 1);
-			return illegal_condition_result;
-		} else if (ep->inj_dix) {
-			mk_sense_buffer(scp, ILLEGAL_REQUEST, 0x10, 1);
-			return illegal_condition_result;
+		if (sqcp) {
+			if (sqcp->inj_recovered) {
+				mk_sense_buffer(scp, RECOVERED_ERROR,
+						THRESHOLD_EXCEEDED, 0);
+				return check_condition_result;
+			} else if (sqcp->inj_dif) {
+				/* Logical block guard check failed */
+				mk_sense_buffer(scp, ABORTED_COMMAND, 0x10, 1);
+				return illegal_condition_result;
+			} else if (sqcp->inj_dix) {
+				mk_sense_buffer(scp, ILLEGAL_REQUEST, 0x10, 1);
+				return illegal_condition_result;
+			}
 		}
 	}
 	return 0;
@@ -3362,27 +3371,40 @@ static int resp_xdwriteread_10(struct scsi_cmnd *scp,
 	return resp_xdwriteread(scp, lba, num, devip);
 }
 
+static struct sdebug_queue *get_queue(void)
+{
+	struct sdebug_queue *sqp = sdebug_q_arr;
+
+	return sqp + (raw_smp_processor_id() % submit_queues);
+}
+
 /* Queued command completions converge here. */
 static void sdebug_q_cmd_complete(struct sdebug_defer *sd_dp)
 {
-	int qa_indx;
+	int qc_indx;
 	int retiring = 0;
 	unsigned long iflags;
+	struct sdebug_queue *sqp;
 	struct sdebug_queued_cmd *sqcp;
 	struct scsi_cmnd *scp;
 	struct sdebug_dev_info *devip;
 
-	atomic_inc(&sdebug_completions);
-	qa_indx = sd_dp->qa_indx;
-	if (unlikely((qa_indx < 0) || (qa_indx >= SCSI_DEBUG_CANQUEUE))) {
-		pr_err("wild qa_indx=%d\n", qa_indx);
+	sqp = sdebug_q_arr + sd_dp->sq_indx;
+	if (sdebug_statistics) {
+		atomic_inc(&sqp->completions);
+		if (get_queue() != sqp)
+			atomic_inc(&sqp->misqueues);
+	}
+	qc_indx = sd_dp->qc_indx;
+	if (unlikely((qc_indx < 0) || (qc_indx >= SCSI_DEBUG_CANQUEUE))) {
+		pr_err("wild qc_indx=%d\n", qc_indx);
 		return;
 	}
-	spin_lock_irqsave(&queued_arr_lock, iflags);
-	sqcp = &queued_arr[qa_indx];
+	spin_lock_irqsave(&sqp->qc_lock, iflags);
+	sqcp = &sqp->qc_arr[qc_indx];
 	scp = sqcp->a_cmnd;
 	if (unlikely(NULL == scp)) {
-		spin_unlock_irqrestore(&queued_arr_lock, iflags);
+		spin_unlock_irqrestore(&sqp->qc_lock, iflags);
 		pr_err("scp is NULL\n");
 		return;
 	}
@@ -3395,8 +3417,8 @@ static void sdebug_q_cmd_complete(struct sdebug_defer *sd_dp)
 		retiring = 1;
 
 	sqcp->a_cmnd = NULL;
-	if (unlikely(!test_and_clear_bit(qa_indx, queued_in_use_bm))) {
-		spin_unlock_irqrestore(&queued_arr_lock, iflags);
+	if (unlikely(!test_and_clear_bit(qc_indx, sqp->in_use_bm))) {
+		spin_unlock_irqrestore(&sqp->qc_lock, iflags);
 		pr_err("Unexpected completion\n");
 		return;
 	}
@@ -3405,18 +3427,18 @@ static void sdebug_q_cmd_complete(struct sdebug_defer *sd_dp)
 		int k, retval;
 
 		retval = atomic_read(&retired_max_queue);
-		if (qa_indx >= retval) {
-			spin_unlock_irqrestore(&queued_arr_lock, iflags);
+		if (qc_indx >= retval) {
+			spin_unlock_irqrestore(&sqp->qc_lock, iflags);
 			pr_err("index %d too large\n", retval);
 			return;
 		}
-		k = find_last_bit(queued_in_use_bm, retval);
+		k = find_last_bit(sqp->in_use_bm, retval);
 		if ((k < sdebug_max_queue) || (k == retval))
 			atomic_set(&retired_max_queue, 0);
 		else
 			atomic_set(&retired_max_queue, k + 1);
 	}
-	spin_unlock_irqrestore(&queued_arr_lock, iflags);
+	spin_unlock_irqrestore(&sqp->qc_lock, iflags);
 	scp->scsi_done(scp); /* callback to mid level */
 }
 
@@ -3535,47 +3557,53 @@ static void scsi_debug_slave_destroy(struct scsi_device *sdp)
 	}
 }
 
+static void stop_qc_helper(struct sdebug_defer *sd_dp)
+{
+	if (!sd_dp)
+		return;
+	if ((sdebug_jdelay > 0) || (sdebug_ndelay > 0))
+		hrtimer_cancel(&sd_dp->hrt);
+	else if (sdebug_jdelay < 0)
+		cancel_work_sync(&sd_dp->ew.work);
+}
+
 /* If @cmnd found deletes its timer or work queue and returns true; else
    returns false */
 static bool stop_queued_cmnd(struct scsi_cmnd *cmnd)
 {
 	unsigned long iflags;
-	int k, qmax, r_qmax;
+	int j, k, qmax, r_qmax;
+	struct sdebug_queue *sqp;
 	struct sdebug_queued_cmd *sqcp;
 	struct sdebug_dev_info *devip;
 	struct sdebug_defer *sd_dp;
 
-	spin_lock_irqsave(&queued_arr_lock, iflags);
-	qmax = sdebug_max_queue;
-	r_qmax = atomic_read(&retired_max_queue);
-	if (r_qmax > qmax)
-		qmax = r_qmax;
-	for (k = 0; k < qmax; ++k) {
-		if (test_bit(k, queued_in_use_bm)) {
-			sqcp = &queued_arr[k];
-			if (cmnd != sqcp->a_cmnd)
-				continue;
-			/* found command */
-			devip = (struct sdebug_dev_info *)
-				cmnd->device->hostdata;
-			if (devip)
-				atomic_dec(&devip->num_in_q);
-			sqcp->a_cmnd = NULL;
-			sd_dp = sqcp->sd_dp;
-			spin_unlock_irqrestore(&queued_arr_lock,
-					       iflags);
-			if ((sdebug_jdelay > 0) || (sdebug_ndelay > 0)) {
-				if (sd_dp)
-					hrtimer_cancel(&sd_dp->hrt);
-			} else if (sdebug_jdelay < 0) {
-				if (sd_dp)
-					cancel_work_sync(&sd_dp->ew.work);
+	for (j = 0, sqp = sdebug_q_arr; j < submit_queues; ++j, ++sqp) {
+		spin_lock_irqsave(&sqp->qc_lock, iflags);
+		qmax = sdebug_max_queue;
+		r_qmax = atomic_read(&retired_max_queue);
+		if (r_qmax > qmax)
+			qmax = r_qmax;
+		for (k = 0; k < qmax; ++k) {
+			if (test_bit(k, sqp->in_use_bm)) {
+				sqcp = &sqp->qc_arr[k];
+				if (cmnd != sqcp->a_cmnd)
+					continue;
+				/* found */
+				devip = (struct sdebug_dev_info *)
+						cmnd->device->hostdata;
+				if (devip)
+					atomic_dec(&devip->num_in_q);
+				sqcp->a_cmnd = NULL;
+				sd_dp = sqcp->sd_dp;
+				spin_unlock_irqrestore(&sqp->qc_lock, iflags);
+				stop_qc_helper(sd_dp);
+				clear_bit(k, sqp->in_use_bm);
+				return true;
 			}
-			clear_bit(k, queued_in_use_bm);
-			return true;
 		}
+		spin_unlock_irqrestore(&sqp->qc_lock, iflags);
 	}
-	spin_unlock_irqrestore(&queued_arr_lock, iflags);
 	return false;
 }
 
@@ -3583,48 +3611,48 @@ static bool stop_queued_cmnd(struct scsi_cmnd *cmnd)
 static void stop_all_queued(void)
 {
 	unsigned long iflags;
-	int k;
+	int j, k;
+	struct sdebug_queue *sqp;
 	struct sdebug_queued_cmd *sqcp;
 	struct sdebug_dev_info *devip;
 	struct sdebug_defer *sd_dp;
 
-	spin_lock_irqsave(&queued_arr_lock, iflags);
-	for (k = 0; k < SCSI_DEBUG_CANQUEUE; ++k) {
-		if (test_bit(k, queued_in_use_bm)) {
-			sqcp = &queued_arr[k];
-			if (NULL == sqcp->a_cmnd)
-				continue;
-			devip = (struct sdebug_dev_info *)
-				sqcp->a_cmnd->device->hostdata;
-			if (devip)
-				atomic_dec(&devip->num_in_q);
-			sqcp->a_cmnd = NULL;
-			sd_dp = sqcp->sd_dp;
-			spin_unlock_irqrestore(&queued_arr_lock, iflags);
-			if ((sdebug_jdelay > 0) || (sdebug_ndelay > 0)) {
-				if (sd_dp)
-					hrtimer_cancel(&sd_dp->hrt);
-			} else if (sdebug_jdelay < 0) {
-				if (sd_dp)
-					cancel_work_sync(&sd_dp->ew.work);
+	for (j = 0, sqp = sdebug_q_arr; j < submit_queues; ++j, ++sqp) {
+		spin_lock_irqsave(&sqp->qc_lock, iflags);
+		for (k = 0; k < SCSI_DEBUG_CANQUEUE; ++k) {
+			if (test_bit(k, sqp->in_use_bm)) {
+				sqcp = &sqp->qc_arr[k];
+				if (NULL == sqcp->a_cmnd)
+					continue;
+				devip = (struct sdebug_dev_info *)
+					sqcp->a_cmnd->device->hostdata;
+				if (devip)
+					atomic_dec(&devip->num_in_q);
+				sqcp->a_cmnd = NULL;
+				sd_dp = sqcp->sd_dp;
+				spin_unlock_irqrestore(&sqp->qc_lock, iflags);
+				stop_qc_helper(sd_dp);
+				clear_bit(k, sqp->in_use_bm);
+				spin_lock_irqsave(&sqp->qc_lock, iflags);
 			}
-			clear_bit(k, queued_in_use_bm);
-			spin_lock_irqsave(&queued_arr_lock, iflags);
 		}
+		spin_unlock_irqrestore(&sqp->qc_lock, iflags);
 	}
-	spin_unlock_irqrestore(&queued_arr_lock, iflags);
 }
 
 /* Free queued command memory on heap */
 static void free_all_queued(void)
 {
-	int k;
+	int j, k;
+	struct sdebug_queue *sqp;
 	struct sdebug_queued_cmd *sqcp;
 
-	for (k = 0; k < SCSI_DEBUG_CANQUEUE; ++k) {
-		sqcp = &queued_arr[k];
-		kfree(sqcp->sd_dp);
-		sqcp->sd_dp = NULL;
+	for (j = 0, sqp = sdebug_q_arr; j < submit_queues; ++j, ++sqp) {
+		for (k = 0; k < SCSI_DEBUG_CANQUEUE; ++k) {
+			sqcp = &sqp->qc_arr[k];
+			kfree(sqcp->sd_dp);
+			sqcp->sd_dp = NULL;
+		}
 	}
 }
 
@@ -3803,24 +3831,77 @@ static void __init sdebug_build_parts(unsigned char *ramp,
 	}
 }
 
+static void block_unblock_all_queues(bool block)
+{
+	int j;
+	struct sdebug_queue *sqp;
+
+	for (j = 0, sqp = sdebug_q_arr; j < submit_queues; ++j, ++sqp)
+		atomic_set(&sqp->blocked, (int)block);
+}
+
+/* Adjust (by rounding down) each cmnd_count so abs(every_nth)-1 commands
+ * will be processed normally on each queue before triggers occur. */
+static void tweak_cmnd_count(void)
+{
+	int j, count, modulo;
+	struct sdebug_queue *sqp;
+
+	modulo = abs(sdebug_every_nth);
+	if (modulo < 2)
+		return;
+	block_unblock_all_queues(true);
+	for (j = 0, sqp = sdebug_q_arr; j < submit_queues; ++j, ++sqp) {
+		count = atomic_read(&sqp->cmnd_count);
+		atomic_set(&sqp->cmnd_count, (count / modulo) * modulo);
+	}
+	block_unblock_all_queues(false);
+}
+
+static void clear_queue_stats(void)
+{
+	int j;
+	struct sdebug_queue *sqp;
+
+	for (j = 0, sqp = sdebug_q_arr; j < submit_queues; ++j, ++sqp) {
+		atomic_set(&sqp->cmnd_count, 0);
+		atomic_set(&sqp->completions, 0);
+		atomic_set(&sqp->misqueues, 0);
+		atomic_set(&sqp->a_tsf, 0);
+	}
+}
+
+static void setup_inject(struct sdebug_queue *sqp,
+			 struct sdebug_queued_cmd *sqcp)
+{
+	if ((atomic_read(&sqp->cmnd_count) % abs(sdebug_every_nth)) > 0)
+		return;
+	sqcp->inj_recovered = !!(SDEBUG_OPT_RECOVERED_ERR & sdebug_opts);
+	sqcp->inj_transport = !!(SDEBUG_OPT_TRANSPORT_ERR & sdebug_opts);
+	sqcp->inj_dif = !!(SDEBUG_OPT_DIF_ERR & sdebug_opts);
+	sqcp->inj_dix = !!(SDEBUG_OPT_DIX_ERR & sdebug_opts);
+	sqcp->inj_short = !!(SDEBUG_OPT_SHORT_TRANSFER & sdebug_opts);
+}
+
+/* Complete the processing of the thread that queued a SCSI command to this
+ * driver. It either completes the command by calling cmnd_done() or
+ * schedules a hr timer or work queue then returns 0. Returns
+ * SCSI_MLQUEUE_HOST_BUSY if temporarily out of resources. */
 static int schedule_resp(struct scsi_cmnd *cmnd, struct sdebug_dev_info *devip,
 			 int scsi_result, int delta_jiff)
 {
 	unsigned long iflags;
 	int k, num_in_q, qdepth, inject;
+	struct sdebug_queue *sqp;
 	struct sdebug_queued_cmd *sqcp = NULL;
 	struct scsi_device *sdp;
 	struct sdebug_defer *sd_dp;
 
-	if (unlikely(WARN_ON(!cmnd)))
-		return SCSI_MLQUEUE_HOST_BUSY;
-
 	if (unlikely(NULL == devip)) {
 		if (0 == scsi_result)
 			scsi_result = DID_NO_CONNECT << 16;
 		goto respond_in_thread;
 	}
-
 	sdp = cmnd->device;
 
 	if (unlikely(sdebug_verbose && scsi_result))
@@ -3830,31 +3911,36 @@ static int schedule_resp(struct scsi_cmnd *cmnd, struct sdebug_dev_info *devip,
 		goto respond_in_thread;
 
 	/* schedule the response at a later time if resources permit */
-	spin_lock_irqsave(&queued_arr_lock, iflags);
+	sqp = get_queue();
+	spin_lock_irqsave(&sqp->qc_lock, iflags);
+	if (unlikely(atomic_read(&sqp->blocked))) {
+		spin_unlock_irqrestore(&sqp->qc_lock, iflags);
+		return SCSI_MLQUEUE_HOST_BUSY;
+	}
 	num_in_q = atomic_read(&devip->num_in_q);
 	qdepth = cmnd->device->queue_depth;
 	inject = 0;
 	if (unlikely((qdepth > 0) && (num_in_q >= qdepth))) {
 		if (scsi_result) {
-			spin_unlock_irqrestore(&queued_arr_lock, iflags);
+			spin_unlock_irqrestore(&sqp->qc_lock, iflags);
 			goto respond_in_thread;
 		} else
 			scsi_result = device_qfull_result;
-	} else if (unlikely((sdebug_every_nth != 0) &&
+	} else if (unlikely(sdebug_every_nth &&
 			    (SDEBUG_OPT_RARE_TSF & sdebug_opts) &&
 			    (scsi_result == 0))) {
 		if ((num_in_q == (qdepth - 1)) &&
-		    (atomic_inc_return(&sdebug_a_tsf) >=
+		    (atomic_inc_return(&sqp->a_tsf) >=
 		     abs(sdebug_every_nth))) {
-			atomic_set(&sdebug_a_tsf, 0);
+			atomic_set(&sqp->a_tsf, 0);
 			inject = 1;
 			scsi_result = device_qfull_result;
 		}
 	}
 
-	k = find_first_zero_bit(queued_in_use_bm, sdebug_max_queue);
+	k = find_first_zero_bit(sqp->in_use_bm, sdebug_max_queue);
 	if (unlikely(k >= sdebug_max_queue)) {
-		spin_unlock_irqrestore(&queued_arr_lock, iflags);
+		spin_unlock_irqrestore(&sqp->qc_lock, iflags);
 		if (scsi_result)
 			goto respond_in_thread;
 		else if (SDEBUG_OPT_ALL_TSF & sdebug_opts)
@@ -3870,13 +3956,16 @@ static int schedule_resp(struct scsi_cmnd *cmnd, struct sdebug_dev_info *devip,
 		else
 			return SCSI_MLQUEUE_HOST_BUSY;
 	}
-	__set_bit(k, queued_in_use_bm);
+	__set_bit(k, sqp->in_use_bm);
 	atomic_inc(&devip->num_in_q);
-	sqcp = &queued_arr[k];
+	sqcp = &sqp->qc_arr[k];
 	sqcp->a_cmnd = cmnd;
+	cmnd->host_scribble = (unsigned char *)sqcp;
 	cmnd->result = scsi_result;
-	spin_unlock_irqrestore(&queued_arr_lock, iflags);
 	sd_dp = sqcp->sd_dp;
+	spin_unlock_irqrestore(&sqp->qc_lock, iflags);
+	if (unlikely(sdebug_every_nth && sdebug_any_injecting_opt))
+		setup_inject(sqp, sqcp);
 	if ((delta_jiff > 0) || (sdebug_ndelay > 0)) {
 		ktime_t kt;
 
@@ -3893,18 +3982,20 @@ static int schedule_resp(struct scsi_cmnd *cmnd, struct sdebug_dev_info *devip,
 				return SCSI_MLQUEUE_HOST_BUSY;
 			sqcp->sd_dp = sd_dp;
 			hrtimer_init(&sd_dp->hrt, CLOCK_MONOTONIC,
-				     HRTIMER_MODE_REL);
+				     HRTIMER_MODE_REL_PINNED);
 			sd_dp->hrt.function = sdebug_q_cmd_hrt_complete;
-			sd_dp->qa_indx = k;
+			sd_dp->sq_indx = sqp - sdebug_q_arr;
+			sd_dp->qc_indx = k;
 		}
-		hrtimer_start(&sd_dp->hrt, kt, HRTIMER_MODE_REL);
-	} else {	/* jdelay < 0 */
+		hrtimer_start(&sd_dp->hrt, kt, HRTIMER_MODE_REL_PINNED);
+	} else {	/* jdelay < 0, use work queue */
 		if (NULL == sd_dp) {
 			sd_dp = kzalloc(sizeof(*sqcp->sd_dp), GFP_ATOMIC);
 			if (NULL == sd_dp)
 				return SCSI_MLQUEUE_HOST_BUSY;
 			sqcp->sd_dp = sd_dp;
-			sd_dp->qa_indx = k;
+			sd_dp->sq_indx = sqp - sdebug_q_arr;
+			sd_dp->qc_indx = k;
 			INIT_WORK(&sd_dp->ew.work, sdebug_q_cmd_wq_complete);
 		}
 		schedule_work(&sd_dp->ew.work);
@@ -3960,7 +4051,9 @@ module_param_named(ptype, sdebug_ptype, int, S_IRUGO | S_IWUSR);
 module_param_named(removable, sdebug_removable, bool, S_IRUGO | S_IWUSR);
 module_param_named(scsi_level, sdebug_scsi_level, int, S_IRUGO);
 module_param_named(sector_size, sdebug_sector_size, int, S_IRUGO);
+module_param_named(statistics, sdebug_statistics, bool, S_IRUGO | S_IWUSR);
 module_param_named(strict, sdebug_strict, bool, S_IRUGO | S_IWUSR);
+module_param_named(submit_queues, submit_queues, int, S_IRUGO);
 module_param_named(unmap_alignment, sdebug_unmap_alignment, int, S_IRUGO);
 module_param_named(unmap_granularity, sdebug_unmap_granularity, int, S_IRUGO);
 module_param_named(unmap_max_blocks, sdebug_unmap_max_blocks, int, S_IRUGO);
@@ -4007,7 +4100,9 @@ MODULE_PARM_DESC(ptype, "SCSI peripheral type(def=0[disk])");
 MODULE_PARM_DESC(removable, "claim to have removable media (def=0)");
 MODULE_PARM_DESC(scsi_level, "SCSI level to simulate(def=6[SPC-4])");
 MODULE_PARM_DESC(sector_size, "logical block size in bytes (def=512)");
+MODULE_PARM_DESC(statistics, "collect statistics on commands, queues (def=1)");
 MODULE_PARM_DESC(strict, "stricter checks: reserved field in cdb (def=0)");
+MODULE_PARM_DESC(submit_queues, "support for block multi-queue (def=1)");
 MODULE_PARM_DESC(unmap_alignment, "lowest aligned thin provisioning lba (def=0)");
 MODULE_PARM_DESC(unmap_granularity, "thin provisioning granularity in blocks (def=1)");
 MODULE_PARM_DESC(unmap_max_blocks, "max # of blocks can be unmapped in one cmd (def=0xffffffff)");
@@ -4020,9 +4115,17 @@ static char sdebug_info[256];
 
 static const char * scsi_debug_info(struct Scsi_Host * shp)
 {
-	sprintf(sdebug_info, "scsi_debug, version %s [%s], "
-		"dev_size_mb=%d, opts=0x%x", SCSI_DEBUG_VERSION,
-		sdebug_version_date, sdebug_dev_size_mb, sdebug_opts);
+	int k;
+
+	k = scnprintf(sdebug_info, sizeof(sdebug_info),
+		      "%s: version %s [%s], dev_size_mb=%d, opts=0x%x\n",
+		      my_name, SCSI_DEBUG_VERSION, sdebug_version_date,
+		      sdebug_dev_size_mb, sdebug_opts);
+	if (k >= (sizeof(sdebug_info) - 1))
+		return sdebug_info;
+	scnprintf(sdebug_info + k, sizeof(sdebug_info) - k,
+		  "%s: submit_queues=%d, statistics=%d\n", my_name,
+		  submit_queues, (int)sdebug_statistics);
 	return sdebug_info;
 }
 
@@ -4044,7 +4147,7 @@ static int scsi_debug_write_info(struct Scsi_Host *host, char *buffer,
 	sdebug_verbose = !!(SDEBUG_OPT_NOISE & opts);
 	sdebug_any_injecting_opt = !!(SDEBUG_OPT_ALL_INJECTING & opts);
 	if (sdebug_every_nth != 0)
-		atomic_set(&sdebug_cmnd_count, 0);
+		tweak_cmnd_count();
 	return length;
 }
 
@@ -4053,39 +4156,42 @@ static int scsi_debug_write_info(struct Scsi_Host *host, char *buffer,
  * output are not atomics so might be inaccurate in a busy system. */
 static int scsi_debug_show_info(struct seq_file *m, struct Scsi_Host *host)
 {
-	int f, l;
-	char b[32];
-
-	if (sdebug_every_nth > 0)
-		snprintf(b, sizeof(b), " (curr:%d)",
-			 ((SDEBUG_OPT_RARE_TSF & sdebug_opts) ?
-				atomic_read(&sdebug_a_tsf) :
-				atomic_read(&sdebug_cmnd_count)));
-	else
-		b[0] = '\0';
-
-	seq_printf(m, "scsi_debug adapter driver, version %s [%s]\n"
-		"num_tgts=%d, shared (ram) size=%d MB, opts=0x%x, "
-		"every_nth=%d%s\n"
-		"delay=%d, ndelay=%d, max_luns=%d, q_completions=%d\n"
-		"sector_size=%d bytes, cylinders=%d, heads=%d, sectors=%d\n"
-		"command aborts=%d; RESETs: device=%d, target=%d, bus=%d, "
-		"host=%d\ndix_reads=%d dix_writes=%d dif_errors=%d "
-		"usec_in_jiffy=%lu\n",
-		SCSI_DEBUG_VERSION, sdebug_version_date,
-		sdebug_num_tgts, sdebug_dev_size_mb, sdebug_opts,
-		sdebug_every_nth, b, sdebug_jdelay, sdebug_ndelay,
-		sdebug_max_luns, atomic_read(&sdebug_completions),
-		sdebug_sector_size, sdebug_cylinders_per, sdebug_heads,
-		sdebug_sectors_per, num_aborts, num_dev_resets,
-		num_target_resets, num_bus_resets, num_host_resets,
-		dix_reads, dix_writes, dif_errors, TICK_NSEC / 1000);
-
-	f = find_first_bit(queued_in_use_bm, sdebug_max_queue);
-	if (f != sdebug_max_queue) {
-		l = find_last_bit(queued_in_use_bm, sdebug_max_queue);
-		seq_printf(m, "   %s BUSY: first,last bits set: %d,%d\n",
-			   "queued_in_use_bm", f, l);
+	int f, j, l;
+	struct sdebug_queue *sqp;
+
+	seq_printf(m, "scsi_debug adapter driver, version %s [%s]\n",
+		   SCSI_DEBUG_VERSION, sdebug_version_date);
+	seq_printf(m, "num_tgts=%d, %ssize=%d MB, opts=0x%x, every_nth=%d\n",
+		   sdebug_num_tgts, "shared (ram) ", sdebug_dev_size_mb,
+		   sdebug_opts, sdebug_every_nth);
+	seq_printf(m, "delay=%d, ndelay=%d, max_luns=%d, sector_size=%d %s\n",
+		   sdebug_jdelay, sdebug_ndelay, sdebug_max_luns,
+		   sdebug_sector_size, "bytes");
+	seq_printf(m, "cylinders=%d, heads=%d, sectors=%d, command aborts=%d\n",
+		   sdebug_cylinders_per, sdebug_heads, sdebug_sectors_per,
+		   num_aborts);
+	seq_printf(m, "RESETs: device=%d, target=%d, bus=%d, host=%d\n",
+		   num_dev_resets, num_target_resets, num_bus_resets,
+		   num_host_resets);
+	seq_printf(m, "dix_reads=%d, dix_writes=%d, dif_errors=%d\n",
+		   dix_reads, dix_writes, dif_errors);
+	seq_printf(m, "%s=%lu, %s=%d, mq_available=%d, submit_queues=%d\n",
+		   "usec_in_jiffy", TICK_NSEC / 1000, "statistics",
+		   sdebug_statistics, sdebug_mq_available, submit_queues);
+
+	for (j = 0, sqp = sdebug_q_arr; j < submit_queues; ++j, ++sqp) {
+		seq_printf(m, "queue %d:\n", j);
+		seq_printf(m, "    cmnd_count=%d, %s=%d, %s=%d, a_tsf=%d\n",
+			   atomic_read(&sqp->cmnd_count),
+			   "completions", atomic_read(&sqp->completions),
+			   "misqueues", atomic_read(&sqp->misqueues),
+			   atomic_read(&sqp->a_tsf));
+		f = find_first_bit(sqp->in_use_bm, sdebug_max_queue);
+		if (f != sdebug_max_queue) {
+			l = find_last_bit(sqp->in_use_bm, sdebug_max_queue);
+			seq_printf(m, "    in_use_bm BUSY: %s: %d,%d\n",
+				   "first,last bits", f, l);
+		}
 	}
 	return 0;
 }
@@ -4094,7 +4200,8 @@ static ssize_t delay_show(struct device_driver *ddp, char *buf)
 {
 	return scnprintf(buf, PAGE_SIZE, "%d\n", sdebug_jdelay);
 }
-/* Returns -EBUSY if jdelay is being changed and commands are queued */
+/* Returns -EBUSY if jdelay is being changed and commands are queued. The unit
+ * of delay is jiffies. */
 static ssize_t delay_store(struct device_driver *ddp, const char *buf,
 			   size_t count)
 {
@@ -4103,21 +4210,27 @@ static ssize_t delay_store(struct device_driver *ddp, const char *buf,
 	if ((count > 0) && (1 == sscanf(buf, "%d", &jdelay))) {
 		res = count;
 		if (sdebug_jdelay != jdelay) {
-			unsigned long iflags;
-			int k;
-
-			spin_lock_irqsave(&queued_arr_lock, iflags);
-			k = find_first_bit(queued_in_use_bm, sdebug_max_queue);
-			if (k != sdebug_max_queue)
-				res = -EBUSY;	/* have queued commands */
-			else {
+			int j, k;
+			struct sdebug_queue *sqp;
+
+			block_unblock_all_queues(true);
+			for (j = 0, sqp = sdebug_q_arr; j < submit_queues;
+			     ++j, ++sqp) {
+				k = find_first_bit(sqp->in_use_bm,
+						   sdebug_max_queue);
+				if (k != sdebug_max_queue) {
+					res = -EBUSY;   /* queued commands */
+					break;
+				}
+			}
+			if (res > 0) {
 				/* make sure sdebug_defer instances get
 				 * re-allocated for new delay variant */
 				free_all_queued();
 				sdebug_jdelay = jdelay;
 				sdebug_ndelay = 0;
 			}
-			spin_unlock_irqrestore(&queued_arr_lock, iflags);
+			block_unblock_all_queues(false);
 		}
 		return res;
 	}
@@ -4134,18 +4247,26 @@ static ssize_t ndelay_show(struct device_driver *ddp, char *buf)
 static ssize_t ndelay_store(struct device_driver *ddp, const char *buf,
 			    size_t count)
 {
-	unsigned long iflags;
-	int ndelay, res, k;
+	int ndelay, res;
 
 	if ((count > 0) && (1 == sscanf(buf, "%d", &ndelay)) &&
-	    (ndelay >= 0) && (ndelay < 1000000000)) {
+	    (ndelay >= 0) && (ndelay < (1000 * 1000 * 1000))) {
 		res = count;
 		if (sdebug_ndelay != ndelay) {
-			spin_lock_irqsave(&queued_arr_lock, iflags);
-			k = find_first_bit(queued_in_use_bm, sdebug_max_queue);
-			if (k != sdebug_max_queue)
-				res = -EBUSY;	/* have queued commands */
-			else {
+			int j, k;
+			struct sdebug_queue *sqp;
+
+			block_unblock_all_queues(true);
+			for (j = 0, sqp = sdebug_q_arr; j < submit_queues;
+			     ++j, ++sqp) {
+				k = find_first_bit(sqp->in_use_bm,
+						   sdebug_max_queue);
+				if (k != sdebug_max_queue) {
+					res = -EBUSY;   /* queued commands */
+					break;
+				}
+			}
+			if (res > 0) {
 				/* make sure sdebug_defer instances get
 				 * re-allocated for new delay variant */
 				free_all_queued();
@@ -4153,7 +4274,7 @@ static ssize_t ndelay_store(struct device_driver *ddp, const char *buf,
 				sdebug_jdelay = ndelay  ? JDELAY_OVERRIDDEN
 							: DEF_JDELAY;
 			}
-			spin_unlock_irqrestore(&queued_arr_lock, iflags);
+			block_unblock_all_queues(false);
 		}
 		return res;
 	}
@@ -4186,8 +4307,7 @@ opts_done:
 	sdebug_opts = opts;
 	sdebug_verbose = !!(SDEBUG_OPT_NOISE & opts);
 	sdebug_any_injecting_opt = !!(SDEBUG_OPT_ALL_INJECTING & opts);
-	atomic_set(&sdebug_cmnd_count, 0);
-	atomic_set(&sdebug_a_tsf, 0);
+	tweak_cmnd_count();
 	return count;
 }
 static DRIVER_ATTR_RW(opts);
@@ -4317,7 +4437,7 @@ static ssize_t every_nth_store(struct device_driver *ddp, const char *buf,
 
 	if ((count > 0) && (1 == sscanf(buf, "%d", &nth))) {
 		sdebug_every_nth = nth;
-		atomic_set(&sdebug_cmnd_count, 0);
+		tweak_cmnd_count();
 		return count;
 	}
 	return -EINVAL;
@@ -4372,13 +4492,19 @@ static ssize_t max_queue_show(struct device_driver *ddp, char *buf)
 static ssize_t max_queue_store(struct device_driver *ddp, const char *buf,
 			       size_t count)
 {
-	unsigned long iflags;
-	int n, k;
+	int j, n, k, a;
+	struct sdebug_queue *sqp;
 
 	if ((count > 0) && (1 == sscanf(buf, "%d", &n)) && (n > 0) &&
 	    (n <= SCSI_DEBUG_CANQUEUE)) {
-		spin_lock_irqsave(&queued_arr_lock, iflags);
-		k = find_last_bit(queued_in_use_bm, SCSI_DEBUG_CANQUEUE);
+		block_unblock_all_queues(true);
+		k = 0;
+		for (j = 0, sqp = sdebug_q_arr; j < submit_queues;
+		     ++j, ++sqp) {
+			a = find_last_bit(sqp->in_use_bm, SCSI_DEBUG_CANQUEUE);
+			if (a > k)
+				k = a;
+		}
 		sdebug_max_queue = n;
 		if (SCSI_DEBUG_CANQUEUE == k)
 			atomic_set(&retired_max_queue, 0);
@@ -4386,7 +4512,7 @@ static ssize_t max_queue_store(struct device_driver *ddp, const char *buf,
 			atomic_set(&retired_max_queue, k + 1);
 		else
 			atomic_set(&retired_max_queue, 0);
-		spin_unlock_irqrestore(&queued_arr_lock, iflags);
+		block_unblock_all_queues(false);
 		return count;
 	}
 	return -EINVAL;
@@ -4485,12 +4611,40 @@ static ssize_t vpd_use_hostno_store(struct device_driver *ddp, const char *buf,
 }
 static DRIVER_ATTR_RW(vpd_use_hostno);
 
+static ssize_t statistics_show(struct device_driver *ddp, char *buf)
+{
+	return scnprintf(buf, PAGE_SIZE, "%d\n", (int)sdebug_statistics);
+}
+static ssize_t statistics_store(struct device_driver *ddp, const char *buf,
+				size_t count)
+{
+	int n;
+
+	if ((count > 0) && (1 == sscanf(buf, "%d", &n)) && (n >= 0)) {
+		if (n > 0)
+			sdebug_statistics = true;
+		else {
+			clear_queue_stats();
+			sdebug_statistics = false;
+		}
+		return count;
+	}
+	return -EINVAL;
+}
+static DRIVER_ATTR_RW(statistics);
+
 static ssize_t sector_size_show(struct device_driver *ddp, char *buf)
 {
 	return scnprintf(buf, PAGE_SIZE, "%u\n", sdebug_sector_size);
 }
 static DRIVER_ATTR_RO(sector_size);
 
+static ssize_t submit_queues_show(struct device_driver *ddp, char *buf)
+{
+	return scnprintf(buf, PAGE_SIZE, "%d\n", submit_queues);
+}
+static DRIVER_ATTR_RO(submit_queues);
+
 static ssize_t dix_show(struct device_driver *ddp, char *buf)
 {
 	return scnprintf(buf, PAGE_SIZE, "%d\n", sdebug_dix);
@@ -4611,6 +4765,8 @@ static struct attribute *sdebug_drv_attrs[] = {
 	&driver_attr_add_host.attr,
 	&driver_attr_vpd_use_hostno.attr,
 	&driver_attr_sector_size.attr,
+	&driver_attr_statistics.attr,
+	&driver_attr_submit_queues.attr,
 	&driver_attr_dix.attr,
 	&driver_attr_dif.attr,
 	&driver_attr_guard.attr,
@@ -4633,8 +4789,6 @@ static int __init scsi_debug_init(void)
 	int k;
 	int ret;
 
-	atomic_set(&sdebug_cmnd_count, 0);
-	atomic_set(&sdebug_completions, 0);
 	atomic_set(&retired_max_queue, 0);
 
 	if (sdebug_ndelay >= 1000 * 1000 * 1000) {
@@ -4693,6 +4847,19 @@ static int __init scsi_debug_init(void)
 		return -EINVAL;
 	}
 
+	if (submit_queues < 1) {
+		pr_err("submit_queues must be 1 or more\n");
+		return -EINVAL;
+	}
+	sdebug_q_arr = kzalloc(sizeof(struct sdebug_queue) * submit_queues,
+			       GFP_KERNEL);
+	if (NULL == sdebug_q_arr) {
+		pr_err("sdebug_q_arr out of memory\n");
+		return -ENOMEM;
+	}
+	for (k = 0; k < submit_queues; ++k)
+		spin_lock_init(&sdebug_q_arr[k].qc_lock);
+
 	if (sdebug_dev_size_mb < 1)
 		sdebug_dev_size_mb = 1;  /* force minimum 1 MB ramdisk */
 	sz = (unsigned long)sdebug_dev_size_mb * 1048576;
@@ -4720,7 +4887,8 @@ static int __init scsi_debug_init(void)
 		fake_storep = vmalloc(sz);
 		if (NULL == fake_storep) {
 			pr_err("out of memory, 1\n");
-			return -ENOMEM;
+			ret = -ENOMEM;
+			goto free_q_arr;
 		}
 		memset(fake_storep, 0, sz);
 		if (sdebug_num_parts > 0)
@@ -4759,7 +4927,8 @@ static int __init scsi_debug_init(void)
 		    sdebug_unmap_granularity <=
 		    sdebug_unmap_alignment) {
 			pr_err("ERR: unmap_granularity <= unmap_alignment\n");
-			return -EINVAL;
+			ret = -EINVAL;
+			goto free_vm;
 		}
 
 		map_size = lba_to_map_index(sdebug_store_sectors - 1) + 1;
@@ -4820,7 +4989,8 @@ free_vm:
 	vfree(map_storep);
 	vfree(dif_storep);
 	vfree(fake_storep);
-
+free_q_arr:
+	kfree(sdebug_q_arr);
 	return ret;
 }
 
@@ -4838,6 +5008,7 @@ static void __exit scsi_debug_exit(void)
 
 	vfree(dif_storep);
 	vfree(fake_storep);
+	kfree(sdebug_q_arr);
 }
 
 device_initcall(scsi_debug_init);
@@ -4926,62 +5097,45 @@ static void sdebug_remove_adapter(void)
 static int sdebug_change_qdepth(struct scsi_device *sdev, int qdepth)
 {
 	int num_in_q = 0;
-	unsigned long iflags;
 	struct sdebug_dev_info *devip;
 
-	spin_lock_irqsave(&queued_arr_lock, iflags);
+	block_unblock_all_queues(true);
 	devip = (struct sdebug_dev_info *)sdev->hostdata;
 	if (NULL == devip) {
-		spin_unlock_irqrestore(&queued_arr_lock, iflags);
+		block_unblock_all_queues(false);
 		return	-ENODEV;
 	}
 	num_in_q = atomic_read(&devip->num_in_q);
-	spin_unlock_irqrestore(&queued_arr_lock, iflags);
 
 	if (qdepth < 1)
 		qdepth = 1;
-	/* allow to exceed max host queued_arr elements for testing */
+	/* allow to exceed max host qc_arr elements for testing */
 	if (qdepth > SCSI_DEBUG_CANQUEUE + 10)
 		qdepth = SCSI_DEBUG_CANQUEUE + 10;
 	scsi_change_queue_depth(sdev, qdepth);
 
 	if (SDEBUG_OPT_Q_NOISE & sdebug_opts) {
-		sdev_printk(KERN_INFO, sdev,
-			    "%s: qdepth=%d, num_in_q=%d\n",
+		sdev_printk(KERN_INFO, sdev, "%s: qdepth=%d, num_in_q=%d\n",
 			    __func__, qdepth, num_in_q);
 	}
+	block_unblock_all_queues(false);
 	return sdev->queue_depth;
 }
 
-static int check_inject(struct scsi_cmnd *scp)
+static bool fake_timeout(struct sdebug_queue *sqp, struct scsi_cmnd *scp)
 {
-	struct sdebug_scmd_extra_t *ep = scsi_cmd_priv(scp);
-
-	memset(ep, 0, sizeof(struct sdebug_scmd_extra_t));
-
-	if (atomic_inc_return(&sdebug_cmnd_count) >= abs(sdebug_every_nth)) {
-		atomic_set(&sdebug_cmnd_count, 0);
+	if (NULL == sqp)
+		sqp = get_queue();
+	if (0 == (atomic_read(&sqp->cmnd_count) % abs(sdebug_every_nth))) {
 		if (sdebug_every_nth < -1)
 			sdebug_every_nth = -1;
 		if (SDEBUG_OPT_TIMEOUT & sdebug_opts)
-			return 1; /* ignore command causing timeout */
+			return true; /* ignore command causing timeout */
 		else if (SDEBUG_OPT_MAC_TIMEOUT & sdebug_opts &&
 			 scsi_medium_access_command(scp))
-			return 1; /* time out reads and writes */
-		if (sdebug_any_injecting_opt) {
-			if (SDEBUG_OPT_RECOVERED_ERR & sdebug_opts)
-				ep->inj_recovered = true;
-			if (SDEBUG_OPT_TRANSPORT_ERR & sdebug_opts)
-				ep->inj_transport = true;
-			if (SDEBUG_OPT_DIF_ERR & sdebug_opts)
-				ep->inj_dif = true;
-			if (SDEBUG_OPT_DIX_ERR & sdebug_opts)
-				ep->inj_dix = true;
-			if (SDEBUG_OPT_SHORT_TRANSFER & sdebug_opts)
-				ep->inj_short = true;
-		}
+			return true; /* time out reads and writes */
 	}
-	return 0;
+	return false;
 }
 
 static int scsi_debug_queuecommand(struct Scsi_Host *shost,
@@ -4992,6 +5146,7 @@ static int scsi_debug_queuecommand(struct Scsi_Host *shost,
 	const struct opcode_info_t *oip;
 	const struct opcode_info_t *r_oip;
 	struct sdebug_dev_info *devip;
+	struct sdebug_queue *sqp = NULL;
 	u8 *cmd = scp->cmnd;
 	int (*r_pfp)(struct scsi_cmnd *, struct sdebug_dev_info *);
 	int k, na;
@@ -5002,6 +5157,10 @@ static int scsi_debug_queuecommand(struct Scsi_Host *shost,
 	bool has_wlun_rl;
 
 	scsi_set_resid(scp, 0);
+	if (sdebug_statistics) {
+		sqp = get_queue();
+		atomic_inc(&sqp->cmnd_count);
+	}
 	if (unlikely(sdebug_verbose &&
 		     !(SDEBUG_OPT_NO_CDB_NOISE & sdebug_opts))) {
 		char b[120];
@@ -5094,7 +5253,7 @@ static int scsi_debug_queuecommand(struct Scsi_Host *shost,
 		if (errsts)
 			goto check_cond;
 	}
-	if (unlikely((F_M_ACCESS & flags) && devip->stopped)) {
+	if (unlikely((F_M_ACCESS & flags) && atomic_read(&devip->stopped))) {
 		mk_sense_buffer(scp, NOT_READY, LOGICAL_UNIT_NOT_READY, 0x2);
 		if (sdebug_verbose)
 			sdev_printk(KERN_INFO, sdp, "%s reports: Not ready: "
@@ -5106,7 +5265,7 @@ static int scsi_debug_queuecommand(struct Scsi_Host *shost,
 	if (sdebug_fake_rw && (F_FAKE_RW & flags))
 		goto fini;
 	if (unlikely(sdebug_every_nth)) {
-		if (check_inject(scp))
+		if (fake_timeout(sqp, scp))
 			return 0;	/* ignore command: make trouble */
 	}
 	if (likely(oip->pfp))
@@ -5148,7 +5307,6 @@ static struct scsi_host_template sdebug_driver_template = {
 	.use_clustering = 	DISABLE_CLUSTERING,
 	.module =		THIS_MODULE,
 	.track_queue_depth =	1,
-	.cmd_size =		sizeof(struct sdebug_scmd_extra_t),
 };
 
 static int sdebug_driver_probe(struct device * dev)
@@ -5169,6 +5327,16 @@ static int sdebug_driver_probe(struct device * dev)
 		error = -ENODEV;
 		return error;
 	}
+	if (submit_queues > nr_cpu_ids) {
+		pr_warn("%s: trim submit_queues (was %d) to nr_cpu_ids=%d\n",
+			my_name, submit_queues, nr_cpu_ids);
+		submit_queues = nr_cpu_ids;
+	}
+	/* Decide whether to tell scsi subsystem that we want mq */
+	/* Following should give the same answer for each host */
+	sdebug_mq_available = shost_use_blk_mq(hpnt);
+	if (sdebug_mq_available && (submit_queues > 1))
+		hpnt->nr_hw_queues = submit_queues;
 
         sdbg_host->shost = hpnt;
 	*((struct sdebug_host_info **)hpnt->hostdata) = sdbg_host;
@@ -5226,6 +5394,8 @@ static int sdebug_driver_probe(struct device * dev)
 
 	sdebug_verbose = !!(SDEBUG_OPT_NOISE & sdebug_opts);
 	sdebug_any_injecting_opt = !!(SDEBUG_OPT_ALL_INJECTING & sdebug_opts);
+	if (sdebug_every_nth)	/* need stats counters for every_nth */
+		sdebug_statistics = true;
         error = scsi_add_host(hpnt, &sdbg_host->dev);
         if (error) {
 		pr_err("scsi_add_host failed\n");
-- 
2.7.4


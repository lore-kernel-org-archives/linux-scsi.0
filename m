From: Douglas Gilbert <dgilbert@interlog.com>
Subject: [PATCH v3 3/6] scsi_debug: add multiple queue support
Date: Fri,  6 May 2016 00:40:26 -0400
Message-ID: <1462509629-24282-4-git-send-email-dgilbert@interlog.com>
References: <1462509629-24282-1-git-send-email-dgilbert@interlog.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:55630 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751342AbcEFEkp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 May 2016 00:40:45 -0400
In-Reply-To: <1462509629-24282-1-git-send-email-dgilbert@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, tomas.winkler@intel.com, emilne@redhat.com, bart.vanassche@sandisk.com

Add submit_queue parameter (minimum and default: 1; maximum:
nr_cpu_ids) that controls how many queues are built, each with
their own lock and in_use bit vector. Add statistics parameter
which is default off.

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/scsi_debug.c | 702 +++++++++++++++++++++++++++++-----------------
 1 file changed, 446 insertions(+), 256 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index e97ddf0..2ee55d5 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -135,6 +135,8 @@ static const char *sdebug_version_date = "20160430";
 #define DEF_VPD_USE_HOSTNO 1
 #define DEF_WRITESAME_LENGTH 0xFFFF
 #define DEF_STRICT 0
+#define DEF_STATISTICS false
+#define DEF_SUBMIT_QUEUES 1
 #define JDELAY_OVERRIDDEN -9999
 
 #define SDEBUG_LUN_0_VAL 0
@@ -201,20 +203,17 @@ static const char *sdebug_version_date = "20160430";
  * or "peripheral device" addressing (value 0) */
 #define SAM2_LUN_ADDRESS_METHOD 0
 
-/* SCSI_DEBUG_CANQUEUE is the maximum number of commands that can be queued
- * (for response) at one time. Can be reduced by max_queue option. Command
- * responses are not queued when jdelay=0 and ndelay=0. The per-device
- * DEF_CMD_PER_LUN can be changed via sysfs:
- * /sys/class/scsi_device/<h:c:t:l>/device/queue_depth but cannot exceed
- * SCSI_DEBUG_CANQUEUE. */
-#define SCSI_DEBUG_CANQUEUE_WORDS  9	/* a WORD is bits in a long */
-#define SCSI_DEBUG_CANQUEUE  (SCSI_DEBUG_CANQUEUE_WORDS * BITS_PER_LONG)
+/* SDEBUG_CANQUEUE is the maximum number of commands that can be queued
+ * (for response) per submit queue at one time. Can be reduced by max_queue
+ * option. Command responses are not queued when jdelay=0 and ndelay=0. The
+ * per-device DEF_CMD_PER_LUN can be changed via sysfs:
+ * /sys/class/scsi_device/<h:c:t:l>/device/queue_depth
+ * but cannot exceed SDEBUG_CANQUEUE .
+ */
+#define SDEBUG_CANQUEUE_WORDS  3	/* a WORD is bits in a long */
+#define SDEBUG_CANQUEUE  (SDEBUG_CANQUEUE_WORDS * BITS_PER_LONG)
 #define DEF_CMD_PER_LUN  255
 
-#if DEF_CMD_PER_LUN > SCSI_DEBUG_CANQUEUE
-#warning "Expect DEF_CMD_PER_LUN <= SCSI_DEBUG_CANQUEUE"
-#endif
-
 #define F_D_IN			1
 #define F_D_OUT			2
 #define F_D_OUT_MAYBE		4	/* WRITE SAME, NDOB bit */
@@ -245,7 +244,7 @@ struct sdebug_dev_info {
 	struct sdebug_host_info *sdbg_host;
 	unsigned long uas_bm[1];
 	atomic_t num_in_q;
-	char stopped;		/* TODO: should be atomic */
+	atomic_t stopped;
 	bool used;
 };
 
@@ -262,23 +261,36 @@ struct sdebug_host_info {
 struct sdebug_defer {
 	struct hrtimer hrt;
 	struct execute_work ew;
-	int qa_indx;
+	int sqa_idx;	/* index of sdebug_queue array */
+	int qc_idx;	/* index of sdebug_queued_cmd array within sqa_idx */
+	int issuing_cpu;
 };
 
 struct sdebug_queued_cmd {
-	/* in_use flagged by a bit in queued_in_use_bm[] */
+	/* corresponding bit set in in_use_bm[] in owning struct sdebug_queue
+	 * instance indicates this slot is in use.
+	 */
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
+	struct sdebug_queued_cmd qc_arr[SDEBUG_CANQUEUE];
+	unsigned long in_use_bm[SDEBUG_CANQUEUE_WORDS];
+	spinlock_t qc_lock;
+	atomic_t blocked;	/* to temporarily stop more being queued */
 };
 
+static atomic_t sdebug_cmnd_count;   /* number of incoming commands */
+static atomic_t sdebug_completions;  /* count of deferred completions */
+static atomic_t sdebug_miss_cpus;    /* submission + completion cpus differ */
+static atomic_t sdebug_a_tsf;	     /* 'almost task set full' counter */
+
 struct opcode_info_t {
 	u8 num_attached;	/* 0 if this is it (i.e. a leaf); use 0xff */
 				/* for terminating element */
@@ -326,6 +338,7 @@ enum sdeb_opcode_index {
 	SDEB_I_LAST_ELEMENT = 30,	/* keep this last */
 };
 
+
 static const unsigned char opcode_ind_arr[256] = {
 /* 0x0; 0x0->0x1f: 6 byte cdbs */
 	SDEB_I_TEST_UNIT_READY, SDEB_I_REZERO_UNIT, 0, SDEB_I_REQUEST_SENSE,
@@ -563,7 +576,7 @@ static int sdebug_fake_rw = DEF_FAKE_RW;
 static unsigned int sdebug_guard = DEF_GUARD;
 static int sdebug_lowest_aligned = DEF_LOWEST_ALIGNED;
 static int sdebug_max_luns = DEF_MAX_LUNS;
-static int sdebug_max_queue = SCSI_DEBUG_CANQUEUE;
+static int sdebug_max_queue = SDEBUG_CANQUEUE;	/* per submit queue */
 static atomic_t retired_max_queue;	/* if > 0 then was prior max_queue */
 static int sdebug_ndelay = DEF_NDELAY;	/* if > 0 then unit is nanoseconds */
 static int sdebug_no_lun_0 = DEF_NO_LUN_0;
@@ -594,10 +607,8 @@ static bool sdebug_strict = DEF_STRICT;
 static bool sdebug_any_injecting_opt;
 static bool sdebug_verbose;
 static bool have_dif_prot;
-
-static atomic_t sdebug_cmnd_count;
-static atomic_t sdebug_completions;
-static atomic_t sdebug_a_tsf;		/* counter of 'almost' TSFs */
+static bool sdebug_statistics = DEF_STATISTICS;
+static bool sdebug_mq_active;
 
 static unsigned int sdebug_store_sectors;
 static sector_t sdebug_capacity;	/* in sectors */
@@ -625,10 +636,9 @@ static int dix_writes;
 static int dix_reads;
 static int dif_errors;
 
-static struct sdebug_queued_cmd queued_arr[SCSI_DEBUG_CANQUEUE];
-static unsigned long queued_in_use_bm[SCSI_DEBUG_CANQUEUE_WORDS];
+static int submit_queues = DEF_SUBMIT_QUEUES;  /* > 1 for multi-queue (mq) */
+static struct sdebug_queue *sdebug_q_arr;  /* ptr to array of submit queues */
 
-static DEFINE_SPINLOCK(queued_arr_lock);
 static DEFINE_RWLOCK(atomic_rw);
 
 static char sdebug_proc_name[] = MY_NAME;
@@ -1428,16 +1438,15 @@ static int resp_start_stop(struct scsi_cmnd * scp,
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
 
@@ -2450,6 +2459,7 @@ static int prot_verify_read(struct scsi_cmnd *SCpnt, sector_t start_sec,
 static int resp_read_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 {
 	u8 *cmd = scp->cmnd;
+	struct sdebug_queued_cmd *sqcp;
 	u64 lba;
 	u32 num;
 	u32 ei_lba;
@@ -2509,11 +2519,14 @@ static int resp_read_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
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
@@ -2563,22 +2576,20 @@ static int resp_read_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 
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
@@ -2851,25 +2862,29 @@ static int resp_write_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
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
@@ -3360,28 +3375,53 @@ static int resp_xdwriteread_10(struct scsi_cmnd *scp,
 	return resp_xdwriteread(scp, lba, num, devip);
 }
 
-/* Queued command completions converge here. */
+static struct sdebug_queue *get_queue(struct scsi_cmnd *cmnd)
+{
+	struct sdebug_queue *sqp = sdebug_q_arr;
+
+	if (sdebug_mq_active) {
+		u32 tag = blk_mq_unique_tag(cmnd->request);
+		u16 hwq = blk_mq_unique_tag_to_hwq(tag);
+
+		if (unlikely(hwq >= submit_queues)) {
+			pr_warn("Unexpected hwq=%d, apply modulo\n", hwq);
+			hwq %= submit_queues;
+		}
+		pr_debug("tag=%u, hwq=%d\n", tag, hwq);
+		return sqp + hwq;
+	} else
+		return sqp;
+}
+
+/* Queued (deferred) command completions converge here. */
 static void sdebug_q_cmd_complete(struct sdebug_defer *sd_dp)
 {
-	int qa_indx;
+	int qc_idx;
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
+	qc_idx = sd_dp->qc_idx;
+	sqp = sdebug_q_arr + sd_dp->sqa_idx;
+	if (sdebug_statistics) {
+		atomic_inc(&sdebug_completions);
+		if (raw_smp_processor_id() != sd_dp->issuing_cpu)
+			atomic_inc(&sdebug_miss_cpus);
+	}
+	if (unlikely((qc_idx < 0) || (qc_idx >= SDEBUG_CANQUEUE))) {
+		pr_err("wild qc_idx=%d\n", qc_idx);
 		return;
 	}
-	spin_lock_irqsave(&queued_arr_lock, iflags);
-	sqcp = &queued_arr[qa_indx];
+	spin_lock_irqsave(&sqp->qc_lock, iflags);
+	sqcp = &sqp->qc_arr[qc_idx];
 	scp = sqcp->a_cmnd;
 	if (unlikely(scp == NULL)) {
-		spin_unlock_irqrestore(&queued_arr_lock, iflags);
-		pr_err("scp is NULL\n");
+		spin_unlock_irqrestore(&sqp->qc_lock, iflags);
+		pr_err("scp is NULL, sqa_idx=%d, qc_idx=%d\n",
+		       sd_dp->sqa_idx, qc_idx);
 		return;
 	}
 	devip = (struct sdebug_dev_info *)scp->device->hostdata;
@@ -3393,8 +3433,8 @@ static void sdebug_q_cmd_complete(struct sdebug_defer *sd_dp)
 		retiring = 1;
 
 	sqcp->a_cmnd = NULL;
-	if (unlikely(!test_and_clear_bit(qa_indx, queued_in_use_bm))) {
-		spin_unlock_irqrestore(&queued_arr_lock, iflags);
+	if (unlikely(!test_and_clear_bit(qc_idx, sqp->in_use_bm))) {
+		spin_unlock_irqrestore(&sqp->qc_lock, iflags);
 		pr_err("Unexpected completion\n");
 		return;
 	}
@@ -3403,18 +3443,18 @@ static void sdebug_q_cmd_complete(struct sdebug_defer *sd_dp)
 		int k, retval;
 
 		retval = atomic_read(&retired_max_queue);
-		if (qa_indx >= retval) {
-			spin_unlock_irqrestore(&queued_arr_lock, iflags);
+		if (qc_idx >= retval) {
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
 
@@ -3533,47 +3573,53 @@ static void scsi_debug_slave_destroy(struct scsi_device *sdp)
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
-			if (sdebug_jdelay > 0 || sdebug_ndelay > 0) {
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
 
@@ -3581,48 +3627,48 @@ static bool stop_queued_cmnd(struct scsi_cmnd *cmnd)
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
-			if (sdebug_jdelay > 0 || sdebug_ndelay > 0) {
-				if (sd_dp)
-					hrtimer_cancel(&sd_dp->hrt);
-			} else if (sdebug_jdelay < 0) {
-				if (sd_dp)
-					cancel_work_sync(&sd_dp->ew.work);
+	for (j = 0, sqp = sdebug_q_arr; j < submit_queues; ++j, ++sqp) {
+		spin_lock_irqsave(&sqp->qc_lock, iflags);
+		for (k = 0; k < SDEBUG_CANQUEUE; ++k) {
+			if (test_bit(k, sqp->in_use_bm)) {
+				sqcp = &sqp->qc_arr[k];
+				if (sqcp->a_cmnd == NULL)
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
+		for (k = 0; k < SDEBUG_CANQUEUE; ++k) {
+			sqcp = &sqp->qc_arr[k];
+			kfree(sqcp->sd_dp);
+			sqcp->sd_dp = NULL;
+		}
 	}
 }
 
@@ -3801,24 +3847,71 @@ static void __init sdebug_build_parts(unsigned char *ramp,
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
+/* Adjust (by rounding down) the sdebug_cmnd_count so abs(every_nth)-1
+ * commands will be processed normally before triggers occur.
+ */
+static void tweak_cmnd_count(void)
+{
+	int count, modulo;
+
+	modulo = abs(sdebug_every_nth);
+	if (modulo < 2)
+		return;
+	block_unblock_all_queues(true);
+	count = atomic_read(&sdebug_cmnd_count);
+	atomic_set(&sdebug_cmnd_count, (count / modulo) * modulo);
+	block_unblock_all_queues(false);
+}
+
+static void clear_queue_stats(void)
+{
+	atomic_set(&sdebug_cmnd_count, 0);
+	atomic_set(&sdebug_completions, 0);
+	atomic_set(&sdebug_miss_cpus, 0);
+	atomic_set(&sdebug_a_tsf, 0);
+}
+
+static void setup_inject(struct sdebug_queue *sqp,
+			 struct sdebug_queued_cmd *sqcp)
+{
+	if ((atomic_read(&sdebug_cmnd_count) % abs(sdebug_every_nth)) > 0)
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
+ * SCSI_MLQUEUE_HOST_BUSY if temporarily out of resources.
+ */
 static int schedule_resp(struct scsi_cmnd *cmnd, struct sdebug_dev_info *devip,
 			 int scsi_result, int delta_jiff)
 {
 	unsigned long iflags;
 	int k, num_in_q, qdepth, inject;
-	struct sdebug_queued_cmd *sqcp = NULL;
+	struct sdebug_queue *sqp;
+	struct sdebug_queued_cmd *sqcp;
 	struct scsi_device *sdp;
 	struct sdebug_defer *sd_dp;
 
-	if (unlikely(WARN_ON(!cmnd)))
-		return SCSI_MLQUEUE_HOST_BUSY;
-
 	if (unlikely(devip == NULL)) {
 		if (scsi_result == 0)
 			scsi_result = DID_NO_CONNECT << 16;
 		goto respond_in_thread;
 	}
-
 	sdp = cmnd->device;
 
 	if (unlikely(sdebug_verbose && scsi_result))
@@ -3828,17 +3921,22 @@ static int schedule_resp(struct scsi_cmnd *cmnd, struct sdebug_dev_info *devip,
 		goto respond_in_thread;
 
 	/* schedule the response at a later time if resources permit */
-	spin_lock_irqsave(&queued_arr_lock, iflags);
+	sqp = get_queue(cmnd);
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
@@ -3850,9 +3948,9 @@ static int schedule_resp(struct scsi_cmnd *cmnd, struct sdebug_dev_info *devip,
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
@@ -3868,13 +3966,16 @@ static int schedule_resp(struct scsi_cmnd *cmnd, struct sdebug_dev_info *devip,
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
 	if (delta_jiff > 0 || sdebug_ndelay > 0) {
 		ktime_t kt;
 
@@ -3891,20 +3992,26 @@ static int schedule_resp(struct scsi_cmnd *cmnd, struct sdebug_dev_info *devip,
 				return SCSI_MLQUEUE_HOST_BUSY;
 			sqcp->sd_dp = sd_dp;
 			hrtimer_init(&sd_dp->hrt, CLOCK_MONOTONIC,
-				     HRTIMER_MODE_REL);
+				     HRTIMER_MODE_REL_PINNED);
 			sd_dp->hrt.function = sdebug_q_cmd_hrt_complete;
-			sd_dp->qa_indx = k;
+			sd_dp->sqa_idx = sqp - sdebug_q_arr;
+			sd_dp->qc_idx = k;
 		}
-		hrtimer_start(&sd_dp->hrt, kt, HRTIMER_MODE_REL);
-	} else {	/* jdelay < 0 */
+		if (sdebug_statistics)
+			sd_dp->issuing_cpu = raw_smp_processor_id();
+		hrtimer_start(&sd_dp->hrt, kt, HRTIMER_MODE_REL_PINNED);
+	} else {	/* jdelay < 0, use work queue */
 		if (NULL == sd_dp) {
 			sd_dp = kzalloc(sizeof(*sqcp->sd_dp), GFP_ATOMIC);
 			if (NULL == sd_dp)
 				return SCSI_MLQUEUE_HOST_BUSY;
 			sqcp->sd_dp = sd_dp;
-			sd_dp->qa_indx = k;
+			sd_dp->sqa_idx = sqp - sdebug_q_arr;
+			sd_dp->qc_idx = k;
 			INIT_WORK(&sd_dp->ew.work, sdebug_q_cmd_wq_complete);
 		}
+		if (sdebug_statistics)
+			sd_dp->issuing_cpu = raw_smp_processor_id();
 		schedule_work(&sd_dp->ew.work);
 	}
 	if (unlikely((SDEBUG_OPT_Q_NOISE & sdebug_opts) &&
@@ -3958,7 +4065,9 @@ module_param_named(ptype, sdebug_ptype, int, S_IRUGO | S_IWUSR);
 module_param_named(removable, sdebug_removable, bool, S_IRUGO | S_IWUSR);
 module_param_named(scsi_level, sdebug_scsi_level, int, S_IRUGO);
 module_param_named(sector_size, sdebug_sector_size, int, S_IRUGO);
+module_param_named(statistics, sdebug_statistics, bool, S_IRUGO | S_IWUSR);
 module_param_named(strict, sdebug_strict, bool, S_IRUGO | S_IWUSR);
+module_param_named(submit_queues, submit_queues, int, S_IRUGO);
 module_param_named(unmap_alignment, sdebug_unmap_alignment, int, S_IRUGO);
 module_param_named(unmap_granularity, sdebug_unmap_granularity, int, S_IRUGO);
 module_param_named(unmap_max_blocks, sdebug_unmap_max_blocks, int, S_IRUGO);
@@ -4005,7 +4114,9 @@ MODULE_PARM_DESC(ptype, "SCSI peripheral type(def=0[disk])");
 MODULE_PARM_DESC(removable, "claim to have removable media (def=0)");
 MODULE_PARM_DESC(scsi_level, "SCSI level to simulate(def=6[SPC-4])");
 MODULE_PARM_DESC(sector_size, "logical block size in bytes (def=512)");
+MODULE_PARM_DESC(statistics, "collect statistics on commands, queues (def=0)");
 MODULE_PARM_DESC(strict, "stricter checks: reserved field in cdb (def=0)");
+MODULE_PARM_DESC(submit_queues, "support for block multi-queue (def=1)");
 MODULE_PARM_DESC(unmap_alignment, "lowest aligned thin provisioning lba (def=0)");
 MODULE_PARM_DESC(unmap_granularity, "thin provisioning granularity in blocks (def=1)");
 MODULE_PARM_DESC(unmap_max_blocks, "max # of blocks can be unmapped in one cmd (def=0xffffffff)");
@@ -4018,10 +4129,17 @@ static char sdebug_info[256];
 
 static const char * scsi_debug_info(struct Scsi_Host * shp)
 {
-	sprintf(sdebug_info,
-		"scsi_debug, version %s [%s], dev_size_mb=%d, opts=0x%x",
-		SDEBUG_VERSION, sdebug_version_date, sdebug_dev_size_mb,
-		sdebug_opts);
+	int k;
+
+	k = scnprintf(sdebug_info, sizeof(sdebug_info),
+		      "%s: version %s [%s], dev_size_mb=%d, opts=0x%x\n",
+		      my_name, SDEBUG_VERSION, sdebug_version_date,
+		      sdebug_dev_size_mb, sdebug_opts);
+	if (k >= (sizeof(sdebug_info) - 1))
+		return sdebug_info;
+	scnprintf(sdebug_info + k, sizeof(sdebug_info) - k,
+		  "%s: submit_queues=%d, statistics=%d\n", my_name,
+		  submit_queues, (int)sdebug_statistics);
 	return sdebug_info;
 }
 
@@ -4043,7 +4161,7 @@ static int scsi_debug_write_info(struct Scsi_Host *host, char *buffer,
 	sdebug_verbose = !!(SDEBUG_OPT_NOISE & opts);
 	sdebug_any_injecting_opt = !!(SDEBUG_OPT_ALL_INJECTING & opts);
 	if (sdebug_every_nth != 0)
-		atomic_set(&sdebug_cmnd_count, 0);
+		tweak_cmnd_count();
 	return length;
 }
 
@@ -4052,39 +4170,43 @@ static int scsi_debug_write_info(struct Scsi_Host *host, char *buffer,
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
-		SDEBUG_VERSION, sdebug_version_date,
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
+		   SDEBUG_VERSION, sdebug_version_date);
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
+	seq_printf(m, "usec_in_jiffy=%lu, %s=%d, mq_active=%d\n",
+		   TICK_NSEC / 1000, "statistics", sdebug_statistics,
+		   sdebug_mq_active);
+	seq_printf(m, "cmnd_count=%d, completions=%d, %s=%d, a_tsf=%d\n",
+		   atomic_read(&sdebug_cmnd_count),
+		   atomic_read(&sdebug_completions),
+		   "miss_cpus", atomic_read(&sdebug_miss_cpus),
+		   atomic_read(&sdebug_a_tsf));
+
+	seq_printf(m, "submit_queues=%d\n", submit_queues);
+	for (j = 0, sqp = sdebug_q_arr; j < submit_queues; ++j, ++sqp) {
+		seq_printf(m, "  queue %d:\n", j);
+		f = find_first_bit(sqp->in_use_bm, sdebug_max_queue);
+		if (f != sdebug_max_queue) {
+			l = find_last_bit(sqp->in_use_bm, sdebug_max_queue);
+			seq_printf(m, "    in_use_bm BUSY: %s: %d,%d\n",
+				   "first,last bits", f, l);
+		}
 	}
 	return 0;
 }
@@ -4093,7 +4215,9 @@ static ssize_t delay_show(struct device_driver *ddp, char *buf)
 {
 	return scnprintf(buf, PAGE_SIZE, "%d\n", sdebug_jdelay);
 }
-/* Returns -EBUSY if jdelay is being changed and commands are queued */
+/* Returns -EBUSY if jdelay is being changed and commands are queued. The unit
+ * of delay is jiffies.
+ */
 static ssize_t delay_store(struct device_driver *ddp, const char *buf,
 			   size_t count)
 {
@@ -4102,21 +4226,27 @@ static ssize_t delay_store(struct device_driver *ddp, const char *buf,
 	if (count > 0 && sscanf(buf, "%d", &jdelay) == 1) {
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
@@ -4133,18 +4263,26 @@ static ssize_t ndelay_show(struct device_driver *ddp, char *buf)
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
@@ -4152,7 +4290,7 @@ static ssize_t ndelay_store(struct device_driver *ddp, const char *buf,
 				sdebug_jdelay = ndelay  ? JDELAY_OVERRIDDEN
 							: DEF_JDELAY;
 			}
-			spin_unlock_irqrestore(&queued_arr_lock, iflags);
+			block_unblock_all_queues(false);
 		}
 		return res;
 	}
@@ -4185,8 +4323,7 @@ opts_done:
 	sdebug_opts = opts;
 	sdebug_verbose = !!(SDEBUG_OPT_NOISE & opts);
 	sdebug_any_injecting_opt = !!(SDEBUG_OPT_ALL_INJECTING & opts);
-	atomic_set(&sdebug_cmnd_count, 0);
-	atomic_set(&sdebug_a_tsf, 0);
+	tweak_cmnd_count();
 	return count;
 }
 static DRIVER_ATTR_RW(opts);
@@ -4316,7 +4453,11 @@ static ssize_t every_nth_store(struct device_driver *ddp, const char *buf,
 
 	if ((count > 0) && (1 == sscanf(buf, "%d", &nth))) {
 		sdebug_every_nth = nth;
-		atomic_set(&sdebug_cmnd_count, 0);
+		if (nth && !sdebug_statistics) {
+			pr_info("every_nth needs statistics=1, set it\n");
+			sdebug_statistics = true;
+		}
+		tweak_cmnd_count();
 		return count;
 	}
 	return -EINVAL;
@@ -4371,21 +4512,27 @@ static ssize_t max_queue_show(struct device_driver *ddp, char *buf)
 static ssize_t max_queue_store(struct device_driver *ddp, const char *buf,
 			       size_t count)
 {
-	unsigned long iflags;
-	int n, k;
+	int j, n, k, a;
+	struct sdebug_queue *sqp;
 
 	if ((count > 0) && (1 == sscanf(buf, "%d", &n)) && (n > 0) &&
-	    (n <= SCSI_DEBUG_CANQUEUE)) {
-		spin_lock_irqsave(&queued_arr_lock, iflags);
-		k = find_last_bit(queued_in_use_bm, SCSI_DEBUG_CANQUEUE);
+	    (n <= SDEBUG_CANQUEUE)) {
+		block_unblock_all_queues(true);
+		k = 0;
+		for (j = 0, sqp = sdebug_q_arr; j < submit_queues;
+		     ++j, ++sqp) {
+			a = find_last_bit(sqp->in_use_bm, SDEBUG_CANQUEUE);
+			if (a > k)
+				k = a;
+		}
 		sdebug_max_queue = n;
-		if (SCSI_DEBUG_CANQUEUE == k)
+		if (k == SDEBUG_CANQUEUE)
 			atomic_set(&retired_max_queue, 0);
 		else if (k >= n)
 			atomic_set(&retired_max_queue, k + 1);
 		else
 			atomic_set(&retired_max_queue, 0);
-		spin_unlock_irqrestore(&queued_arr_lock, iflags);
+		block_unblock_all_queues(false);
 		return count;
 	}
 	return -EINVAL;
@@ -4484,12 +4631,40 @@ static ssize_t vpd_use_hostno_store(struct device_driver *ddp, const char *buf,
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
+	if ((count > 0) && (sscanf(buf, "%d", &n) == 1) && (n >= 0)) {
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
@@ -4610,6 +4785,8 @@ static struct attribute *sdebug_drv_attrs[] = {
 	&driver_attr_add_host.attr,
 	&driver_attr_vpd_use_hostno.attr,
 	&driver_attr_sector_size.attr,
+	&driver_attr_statistics.attr,
+	&driver_attr_submit_queues.attr,
 	&driver_attr_dix.attr,
 	&driver_attr_dif.attr,
 	&driver_attr_guard.attr,
@@ -4632,8 +4809,6 @@ static int __init scsi_debug_init(void)
 	int k;
 	int ret;
 
-	atomic_set(&sdebug_cmnd_count, 0);
-	atomic_set(&sdebug_completions, 0);
 	atomic_set(&retired_max_queue, 0);
 
 	if (sdebug_ndelay >= 1000 * 1000 * 1000) {
@@ -4692,6 +4867,17 @@ static int __init scsi_debug_init(void)
 		return -EINVAL;
 	}
 
+	if (submit_queues < 1) {
+		pr_err("submit_queues must be 1 or more\n");
+		return -EINVAL;
+	}
+	sdebug_q_arr = kcalloc(submit_queues, sizeof(struct sdebug_queue),
+			       GFP_KERNEL);
+	if (sdebug_q_arr == NULL)
+		return -ENOMEM;
+	for (k = 0; k < submit_queues; ++k)
+		spin_lock_init(&sdebug_q_arr[k].qc_lock);
+
 	if (sdebug_dev_size_mb < 1)
 		sdebug_dev_size_mb = 1;  /* force minimum 1 MB ramdisk */
 	sz = (unsigned long)sdebug_dev_size_mb * 1048576;
@@ -4719,7 +4905,8 @@ static int __init scsi_debug_init(void)
 		fake_storep = vmalloc(sz);
 		if (NULL == fake_storep) {
 			pr_err("out of memory, 1\n");
-			return -ENOMEM;
+			ret = -ENOMEM;
+			goto free_q_arr;
 		}
 		memset(fake_storep, 0, sz);
 		if (sdebug_num_parts > 0)
@@ -4758,7 +4945,8 @@ static int __init scsi_debug_init(void)
 		    sdebug_unmap_granularity <=
 		    sdebug_unmap_alignment) {
 			pr_err("ERR: unmap_granularity <= unmap_alignment\n");
-			return -EINVAL;
+			ret = -EINVAL;
+			goto free_vm;
 		}
 
 		map_size = lba_to_map_index(sdebug_store_sectors - 1) + 1;
@@ -4819,7 +5007,8 @@ free_vm:
 	vfree(map_storep);
 	vfree(dif_storep);
 	vfree(fake_storep);
-
+free_q_arr:
+	kfree(sdebug_q_arr);
 	return ret;
 }
 
@@ -4837,6 +5026,7 @@ static void __exit scsi_debug_exit(void)
 
 	vfree(dif_storep);
 	vfree(fake_storep);
+	kfree(sdebug_q_arr);
 }
 
 device_initcall(scsi_debug_init);
@@ -4925,62 +5115,43 @@ static void sdebug_remove_adapter(void)
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
-	if (qdepth > SCSI_DEBUG_CANQUEUE + 10)
-		qdepth = SCSI_DEBUG_CANQUEUE + 10;
+	/* allow to exceed max host qc_arr elements for testing */
+	if (qdepth > SDEBUG_CANQUEUE + 10)
+		qdepth = SDEBUG_CANQUEUE + 10;
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
+static bool fake_timeout(struct scsi_cmnd *scp)
 {
-	struct sdebug_scmd_extra_t *ep = scsi_cmd_priv(scp);
-
-	memset(ep, 0, sizeof(struct sdebug_scmd_extra_t));
-
-	if (atomic_inc_return(&sdebug_cmnd_count) >= abs(sdebug_every_nth)) {
-		atomic_set(&sdebug_cmnd_count, 0);
+	if (0 == (atomic_read(&sdebug_cmnd_count) % abs(sdebug_every_nth))) {
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
@@ -5001,6 +5172,8 @@ static int scsi_debug_queuecommand(struct Scsi_Host *shost,
 	bool has_wlun_rl;
 
 	scsi_set_resid(scp, 0);
+	if (sdebug_statistics)
+		atomic_inc(&sdebug_cmnd_count);
 	if (unlikely(sdebug_verbose &&
 		     !(SDEBUG_OPT_NO_CDB_NOISE & sdebug_opts))) {
 		char b[120];
@@ -5015,7 +5188,13 @@ static int scsi_debug_queuecommand(struct Scsi_Host *shost,
 				n += scnprintf(b + n, sb - n, "%02x ",
 					       (u32)cmd[k]);
 		}
-		sdev_printk(KERN_INFO, sdp, "%s: cmd %s\n", my_name, b);
+		if (sdebug_mq_active)
+			sdev_printk(KERN_INFO, sdp, "%s: tag=%u, cmd %s\n",
+				    my_name, blk_mq_unique_tag(scp->request),
+				    b);
+		else
+			sdev_printk(KERN_INFO, sdp, "%s: cmd %s\n", my_name,
+				    b);
 	}
 	has_wlun_rl = (sdp->lun == SCSI_W_LUN_REPORT_LUNS);
 	if (unlikely((sdp->lun >= sdebug_max_luns) && !has_wlun_rl))
@@ -5093,7 +5272,7 @@ static int scsi_debug_queuecommand(struct Scsi_Host *shost,
 		if (errsts)
 			goto check_cond;
 	}
-	if (unlikely((F_M_ACCESS & flags) && devip->stopped)) {
+	if (unlikely((F_M_ACCESS & flags) && atomic_read(&devip->stopped))) {
 		mk_sense_buffer(scp, NOT_READY, LOGICAL_UNIT_NOT_READY, 0x2);
 		if (sdebug_verbose)
 			sdev_printk(KERN_INFO, sdp, "%s reports: Not ready: "
@@ -5105,7 +5284,7 @@ static int scsi_debug_queuecommand(struct Scsi_Host *shost,
 	if (sdebug_fake_rw && (F_FAKE_RW & flags))
 		goto fini;
 	if (unlikely(sdebug_every_nth)) {
-		if (check_inject(scp))
+		if (fake_timeout(scp))
 			return 0;	/* ignore command: make trouble */
 	}
 	if (likely(oip->pfp))
@@ -5139,7 +5318,7 @@ static struct scsi_host_template sdebug_driver_template = {
 	.eh_target_reset_handler = scsi_debug_target_reset,
 	.eh_bus_reset_handler = scsi_debug_bus_reset,
 	.eh_host_reset_handler = scsi_debug_host_reset,
-	.can_queue =		SCSI_DEBUG_CANQUEUE,
+	.can_queue =		SDEBUG_CANQUEUE,
 	.this_id =		7,
 	.sg_tablesize =		SG_MAX_SEGMENTS,
 	.cmd_per_lun =		DEF_CMD_PER_LUN,
@@ -5147,7 +5326,6 @@ static struct scsi_host_template sdebug_driver_template = {
 	.use_clustering = 	DISABLE_CLUSTERING,
 	.module =		THIS_MODULE,
 	.track_queue_depth =	1,
-	.cmd_size =		sizeof(struct sdebug_scmd_extra_t),
 };
 
 static int sdebug_driver_probe(struct device * dev)
@@ -5168,6 +5346,16 @@ static int sdebug_driver_probe(struct device * dev)
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
+	sdebug_mq_active = shost_use_blk_mq(hpnt) && (submit_queues > 1);
+	if (sdebug_mq_active)
+		hpnt->nr_hw_queues = submit_queues;
 
         sdbg_host->shost = hpnt;
 	*((struct sdebug_host_info **)hpnt->hostdata) = sdbg_host;
@@ -5225,6 +5413,8 @@ static int sdebug_driver_probe(struct device * dev)
 
 	sdebug_verbose = !!(SDEBUG_OPT_NOISE & sdebug_opts);
 	sdebug_any_injecting_opt = !!(SDEBUG_OPT_ALL_INJECTING & sdebug_opts);
+	if (sdebug_every_nth)	/* need stats counters for every_nth */
+		sdebug_statistics = true;
         error = scsi_add_host(hpnt, &sdbg_host->dev);
         if (error) {
 		pr_err("scsi_add_host failed\n");
-- 
2.7.4


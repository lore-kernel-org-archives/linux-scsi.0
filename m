From: David Dillow <dillowda@ornl.gov>
Subject: [PATCH 01/11] IB/srp: enlarge block layer timeout
Date: Sun, 25 Nov 2012 23:44:06 -0500
Message-ID: <47dc2dd2b59cf5d4e5124d0ad8a5f988b2f1a87e.1353903448.git.dillowda@ornl.gov>
References: <cover.1353903448.git.dillowda@ornl.gov>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from matrix.voodoobox.net ([75.127.97.206]:38059 "EHLO
	matrix.voodoobox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754205Ab2KZEzI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 25 Nov 2012 23:55:08 -0500
In-Reply-To: <cover.1353903448.git.dillowda@ornl.gov>
In-Reply-To: <cover.1353903448.git.dillowda@ornl.gov>
References: <cover.1353903448.git.dillowda@ornl.gov>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-rdma@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, bvanassche@acm.org, roland@purestorage.com

From: Bart Van Assche <bvanassche@acm.org>

Enlarge the block layer timeout for disks such that it is above
the InfiniBand transport layer timeout.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: David Dillow <dillowda@ornl.gov>
---
 drivers/infiniband/ulp/srp/ib_srp.c |   45 +++++++++++++++++++++++++++++++++++
 drivers/infiniband/ulp/srp/ib_srp.h |    2 +
 2 files changed, 47 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 922d845..6c0cd66 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -1419,6 +1419,33 @@ err:
 	return -ENOMEM;
 }
 
+static uint32_t srp_compute_rq_tmo(struct ib_qp_attr *qp_attr, int attr_mask)
+{
+	uint64_t T_tr_ns, max_compl_time_ms;
+	uint32_t rq_tmo_jiffies;
+
+	/*
+	 * According to section 11.2.4.2 in the IBTA spec (Modify Queue Pair,
+	 * table 91), both the QP timeout and the retry count have to be set
+	 * for RC QP's during the RTR to RTS transition.
+	 */
+	WARN_ON((attr_mask & (IB_QP_TIMEOUT | IB_QP_RETRY_CNT)) !=
+		(IB_QP_TIMEOUT | IB_QP_RETRY_CNT));
+
+	/*
+	 * Set target->rq_tmo_jiffies to one second more than the largest time
+	 * it can take before an error completion is generated. See also
+	 * C9-140..142 in the IBTA spec for more information about how to
+	 * convert the QP Local ACK Timeout value to nanoseconds.
+	 */
+	T_tr_ns = 4096 * (1ULL << qp_attr->timeout);
+	max_compl_time_ms = qp_attr->retry_cnt * 4 * T_tr_ns;
+	do_div(max_compl_time_ms, NSEC_PER_MSEC);
+	rq_tmo_jiffies = msecs_to_jiffies(max_compl_time_ms + 1000);
+
+	return rq_tmo_jiffies;
+}
+
 static void srp_cm_rep_handler(struct ib_cm_id *cm_id,
 			       struct srp_login_rsp *lrsp,
 			       struct srp_target_port *target)
@@ -1478,6 +1505,8 @@ static void srp_cm_rep_handler(struct ib_cm_id *cm_id,
 	if (ret)
 		goto error_free;
 
+	target->rq_tmo_jiffies = srp_compute_rq_tmo(qp_attr, attr_mask);
+
 	ret = ib_modify_qp(target->qp, qp_attr, attr_mask);
 	if (ret)
 		goto error_free;
@@ -1729,6 +1758,21 @@ static int srp_reset_host(struct scsi_cmnd *scmnd)
 	return ret;
 }
 
+static int srp_slave_configure(struct scsi_device *sdev)
+{
+	struct Scsi_Host *shost = sdev->host;
+	struct srp_target_port *target = host_to_target(shost);
+	struct request_queue *q = sdev->request_queue;
+	unsigned long timeout;
+
+	if (sdev->type == TYPE_DISK) {
+		timeout = max_t(unsigned, 30 * HZ, target->rq_tmo_jiffies);
+		blk_queue_rq_timeout(q, timeout);
+	}
+
+	return 0;
+}
+
 static ssize_t show_id_ext(struct device *dev, struct device_attribute *attr,
 			   char *buf)
 {
@@ -1861,6 +1905,7 @@ static struct scsi_host_template srp_template = {
 	.module				= THIS_MODULE,
 	.name				= "InfiniBand SRP initiator",
 	.proc_name			= DRV_NAME,
+	.slave_configure		= srp_slave_configure,
 	.info				= srp_target_info,
 	.queuecommand			= srp_queuecommand,
 	.eh_abort_handler		= srp_abort,
diff --git a/drivers/infiniband/ulp/srp/ib_srp.h b/drivers/infiniband/ulp/srp/ib_srp.h
index 020caf0..e3a6304 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.h
+++ b/drivers/infiniband/ulp/srp/ib_srp.h
@@ -163,6 +163,8 @@ struct srp_target_port {
 	struct ib_sa_query     *path_query;
 	int			path_query_id;
 
+	u32			rq_tmo_jiffies;
+
 	struct ib_cm_id	       *cm_id;
 
 	int			max_ti_iu_len;
-- 
1.7.7.6


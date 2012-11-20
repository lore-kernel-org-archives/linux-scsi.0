From: Bart Van Assche <bvanassche@acm.org>
Subject: SCSI LLDs, the SCSI error handler and host resource lifetime
Date: Tue, 20 Nov 2012 15:24:06 +0100
Message-ID: <50AB9286.8040403@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gerard.telenet-ops.be ([195.130.132.48]:53069 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993Ab2KTOYK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Nov 2012 09:24:10 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

Hello,

If I interpret the SCSI error handler source code correctly then
scsi_unjam_host() may proceed concurrently with scsi_remove_host().
This means that the LLD eh_abort_handler callback may get invoked after
scsi_remove_host() finished. At least the SRP initiator (ib_srp) cleans
up resources necessary for aborting commands as soon as
scsi_remove_host() returns. That looks like a race condition to me. As
far as I can see it is only safe to clean up such resources after the
EH thread has been stopped. Any opinions about adding an additional
callback for this purpose in struct scsi_host_template ?

Note: it doesn't look like a good idea to me to let scsi_remove_host()
wait until error recovery has finished since scsi_remove_host() may get
invoked from the context of a workqueue. If any work gets queued on the
same workqueue related to SCSI error handling letting scsi_remove_host()
wait for the error handler to finish might result in a deadlock.

The patch below is a request for comments patch that does not only add a
callback to struct scsi_host_template but also fixes a (hard to trigger)
race condition in ib_srp: avoid that ib_destroy_cm_id() frees the IB RC
connection while srp_send_tsk_mgmt() is using it.

Thanks,

Bart.

---
 drivers/infiniband/ulp/srp/ib_srp.c |   13 ++++++++-----
 drivers/scsi/hosts.c                |    4 ++++
 include/scsi/scsi_host.h            |   10 ++++++++++
 3 files changed, 22 insertions(+), 5 deletions(-)
---
diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 0d4d39b..406bb92 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -504,10 +504,16 @@ static void srp_remove_work(struct work_struct *work)
 	srp_del_scsi_host_attr(target->scsi_host);
 	srp_remove_host(target->scsi_host);
 	scsi_remove_host(target->scsi_host);
+	scsi_host_put(target->scsi_host);
+}
+
+static void srp_host_release(struct Scsi_Host *shost)
+{
+	struct srp_target_port *target = host_to_target(shost);
+
 	ib_destroy_cm_id(target->cm_id);
 	srp_free_target_ib(target);
 	srp_free_req_data(target);
-	scsi_host_put(target->scsi_host);
 }
 
 static int srp_connect_target(struct srp_target_port *target)
@@ -1629,10 +1635,6 @@ static int srp_send_tsk_mgmt(struct srp_target_port *target,
 	struct srp_iu *iu;
 	struct srp_tsk_mgmt *tsk_mgmt;
 
-	if (target->state == SRP_TARGET_DEAD ||
-	    target->state == SRP_TARGET_REMOVED)
-		return -1;
-
 	init_completion(&target->tsk_mgmt_done);
 
 	spin_lock_irq(&target->lock);
@@ -1859,6 +1861,7 @@ static struct scsi_host_template srp_template = {
 	.eh_abort_handler		= srp_abort,
 	.eh_device_reset_handler	= srp_reset_device,
 	.eh_host_reset_handler		= srp_reset_host,
+	.host_release			= srp_host_release,
 	.sg_tablesize			= SRP_DEF_SG_TABLESIZE,
 	.can_queue			= SRP_CMD_SQ_SIZE,
 	.this_id			= -1,
diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 593085a..e7554be 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -296,6 +296,10 @@ static void scsi_host_dev_release(struct device *dev)
 
 	if (shost->ehandler)
 		kthread_stop(shost->ehandler);
+
+	if (shost->hostt->host_release)
+		shost->hostt->host_release(shost);
+
 	if (shost->work_q)
 		destroy_workqueue(shost->work_q);
 	q = shost->uspace_req_q;
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 4908480..67f6684 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -367,6 +367,16 @@ struct scsi_host_template {
 #define SCSI_ADAPTER_RESET	1
 #define SCSI_FIRMWARE_RESET	2
 
+	/*
+	 * Callback function invoked after the host device reference count
+	 * dropped to zero, after the SCSI EH thread has stopped and before
+	 * SCSI host resources are freed. Useful to free resources that are
+	 * needed by the eh_* callback functions. See also scsi_host_get() and
+	 * scsi_host_put().
+	 *
+	 * Status: OPTIONAL
+	 */
+	void (*host_release)(struct Scsi_Host *shost);
 
 	/*
 	 * Name of proc directory

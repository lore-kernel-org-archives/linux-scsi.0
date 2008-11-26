From: Bernd Schubert <bs@q-leap.de>
Subject: [PATCH 5/7] time needs to be adjusted when eh was running
Date: Wed, 26 Nov 2008 19:29:25 +0100
Message-ID: <200811261929.25959.bs@q-leap.de>
References: <200811261840.45360.bs@q-leap.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns2.q-leap.de ([88.79.172.217]:57607 "EHLO mail.q-leap.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751449AbYKZS3b (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 Nov 2008 13:29:31 -0500
In-Reply-To: <200811261840.45360.bs@q-leap.de>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>

If the error handler was active and we use the normal command timeout,
the command will probably fail, even though the error handler may have
succeeded to recover the device.

Signed-off-by: Bernd Schubert <bs@q-leap.de>


 drivers/scsi/scsi_error.c |    3 +++
 drivers/scsi/scsi_lib.c   |   13 ++++++++++++-
 include/scsi/scsi_host.h  |    2 ++
 3 files changed, 17 insertions(+), 1 deletion(-)

Index: linux-2.6/drivers/scsi/scsi_lib.c
===================================================================
--- linux-2.6.orig/drivers/scsi/scsi_lib.c
+++ linux-2.6/drivers/scsi/scsi_lib.c
@@ -1537,7 +1537,9 @@ static void scsi_softirq_done(struct req
 {
 	struct scsi_cmnd *cmd = rq->special;
 	unsigned long wait_for = (cmd->allowed + 1) * rq->timeout;
+	unsigned long cmd_start;
 	int disposition;
+	struct Scsi_Host *shost = cmd->device->host;
 
 	INIT_LIST_HEAD(&cmd->eh_entry);
 
@@ -1550,9 +1552,18 @@ static void scsi_softirq_done(struct req
 	if (cmd->result)
 		atomic_inc(&cmd->device->ioerr_cnt);
 
+	/*
+	 * If the error handler was active, the command will need more time,
+	 * of course.
+	 */
+	if (shost->last_recovery > cmd->jiffies_at_alloc)
+		cmd_start = shost->last_recovery;
+	else
+		cmd_start = cmd->jiffies_at_alloc;
+
 	disposition = scsi_decide_disposition(cmd);
 	if (disposition != SUCCESS &&
-	    time_before(cmd->jiffies_at_alloc + wait_for, jiffies)) {
+	    time_before(cmd_start + wait_for, jiffies)) {
 		sdev_printk(KERN_ERR, cmd->device,
 			    "timing out command, waited %lus\n",
 			    wait_for/HZ);
Index: linux-2.6/include/scsi/scsi_host.h
===================================================================
--- linux-2.6.orig/include/scsi/scsi_host.h
+++ linux-2.6/include/scsi/scsi_host.h
@@ -521,6 +521,8 @@ struct Scsi_Host {
 	struct task_struct    * ehandler;  /* Error recovery thread. */
 	struct completion     * eh_action; /* Wait for specific actions on the
 					      host. */
+	unsigned long		last_recovery;  /* last time eh completed */
+
 	wait_queue_head_t       host_wait;
 	struct scsi_host_template *hostt;
 	struct scsi_transport_template *transportt;
Index: linux-2.6/drivers/scsi/scsi_error.c
===================================================================
--- linux-2.6.orig/drivers/scsi/scsi_error.c
+++ linux-2.6/drivers/scsi/scsi_error.c
@@ -1559,6 +1559,9 @@ static void scsi_restart_operations(stru
 			BUG_ON(scsi_host_set_state(shost, SHOST_DEL));
 	spin_unlock_irqrestore(shost->host_lock, flags);
 
+	/* before starting the queues save the time of recovery */
+	shost->last_recovery = jiffies;
+
 	wake_up(&shost->host_wait);
 
 	/*


-- 
Bernd Schubert
Q-Leap Networks GmbH

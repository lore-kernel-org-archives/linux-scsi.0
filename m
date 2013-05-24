From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 4/4] scsi_transport_fc: FC timeout handler
Date: Fri, 24 May 2013 11:50:50 +0200
Message-ID: <1369389050-118628-5-git-send-email-hare@suse.de>
References: <1369389050-118628-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40926 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751596Ab3EXJux (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 May 2013 05:50:53 -0400
In-Reply-To: <1369389050-118628-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Ewan Milne <emilne@redhat.com>, James Smart <james.smart@emulex.com>, Bryn Reeves <bmr@redhat.com>, Roland Dreier <roland@purestorage.com>, Hannes Reinecke <hare@suse.de>

When a command runs into a timeout we need to send an 'ABORT TASK'
TMF. This is typically done by the 'eh_abort_handler' LLDD callback.

Conceptually, however, this function is a normal SCSI command, so
there is no need to enter the error handler.

This patch implements a new FC timeout handler which invokes
the 'eh_abort_handler' directly when the timeout occurs without
entering the error handler.

If the 'eh_abort_handler' returns SUCCESS or FAST_IO_FAIL the
command will be retried if possible. If no retries are allowed
the command will be returned immediately, as we have to assume
the TMF succeeded and the command is completed with the LLDD.
For any other return code from 'eh_abort_handler' the command
will be pushed onto the existing SCSI EH handler, or aborted
with an error if that fails.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_transport_fc.c | 63 +++++++++++++++++++++++++++++++++++++++-
 include/scsi/scsi_transport_fc.h |  2 ++
 2 files changed, 64 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index e106c27..370b263 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -2048,6 +2048,51 @@ static int fc_vport_match(struct attribute_container *cont,
 	return &i->vport_attr_cont.ac == cont;
 }
 
+/**
+ * fc_rport_eh_handler - FC-specific error handler
+ * @work:	remote port on which the error occurred.
+ */
+static void
+fc_rport_eh_handler(struct work_struct *work)
+{
+	struct fc_rport *rport =
+		container_of(work, struct fc_rport, rport_eh_work);
+	struct Scsi_Host *shost = rport_to_shost(rport);
+	struct scsi_cmnd *scmd, *tmp;
+	unsigned long flags;
+	int rtn;
+
+	spin_lock_irqsave(shost->host_lock, flags);
+	list_for_each_entry_safe(scmd, tmp, &rport->eh_work_q, eh_entry) {
+		list_del_init(&scmd->eh_entry);
+		spin_unlock_irqrestore(shost->host_lock, flags);
+		dev_printk(KERN_WARNING, &rport->dev,
+			   "trying to abort scmd %p", scmd);
+		rtn = scsi_try_to_abort_cmd(shost->hostt, scmd);
+		if (rtn == SUCCESS || rtn == FAST_IO_FAIL) {
+			if (!scsi_noretry_cmd(scmd) &&
+			    (++scmd->retries <= scmd->allowed)) {
+				dev_printk(KERN_WARNING, &rport->dev,
+					   "retry scmd %p", scmd);
+				scsi_queue_insert(scmd, SCSI_MLQUEUE_EH_RETRY);
+			} else {
+				dev_printk(KERN_WARNING, &rport->dev,
+					   "fast fail scmd %p", scmd);
+				scmd->result |= DID_TRANSPORT_FAILFAST << 16;
+				scsi_finish_command(scmd);
+			}
+		} else {
+			if (!scsi_eh_scmd_add(scmd, 0)) {
+				dev_printk(KERN_WARNING, &rport->dev,
+					   "terminate scmd %p", scmd);
+				scmd->result |= DID_TIME_OUT << 16;
+				scsi_finish_command(scmd);
+			}
+		}
+		spin_lock_irqsave(shost->host_lock, flags);
+	}
+	spin_unlock_irqrestore(shost->host_lock, flags);
+}
 
 /**
  * fc_timed_out - FC Transport I/O timeout intercept handler
@@ -2075,11 +2120,25 @@ static enum blk_eh_timer_return
 fc_timed_out(struct scsi_cmnd *scmd)
 {
 	struct fc_rport *rport = starget_to_rport(scsi_target(scmd->device));
+	struct Scsi_Host *shost = rport_to_shost(rport);
+	unsigned long flags;
+	int kick_worker = 0;
 
 	if (rport->port_state == FC_PORTSTATE_BLOCKED)
 		return BLK_EH_RESET_TIMER;
 
-	return BLK_EH_NOT_HANDLED;
+	spin_lock_irqsave(shost->host_lock, flags);
+	if (list_empty(&rport->eh_work_q))
+		kick_worker = 1;
+	list_add(&scmd->eh_entry, &rport->eh_work_q);
+	dev_printk(KERN_WARNING, &rport->dev,
+		   "scmd %p added to eh queue\n", scmd);
+	spin_unlock_irqrestore(shost->host_lock, flags);
+
+	if (kick_worker)
+		fc_queue_work(shost, &rport->rport_eh_work);
+
+	return BLK_EH_SCHEDULED;
 }
 
 /*
@@ -2630,11 +2689,13 @@ fc_rport_create(struct Scsi_Host *shost, int channel,
 	rport->channel = channel;
 	rport->fast_io_fail_tmo = -1;
 
+	INIT_LIST_HEAD(&rport->eh_work_q);
 	INIT_DELAYED_WORK(&rport->dev_loss_work, fc_timeout_deleted_rport);
 	INIT_DELAYED_WORK(&rport->fail_io_work, fc_timeout_fail_rport_io);
 	INIT_WORK(&rport->scan_work, fc_scsi_scan_rport);
 	INIT_WORK(&rport->stgt_delete_work, fc_starget_delete);
 	INIT_WORK(&rport->rport_delete_work, fc_rport_final_delete);
+	INIT_WORK(&rport->rport_eh_work, fc_rport_eh_handler);
 
 	spin_lock_irqsave(shost->host_lock, flags);
 
diff --git a/include/scsi/scsi_transport_fc.h b/include/scsi/scsi_transport_fc.h
index b797e8f..ecf8934 100644
--- a/include/scsi/scsi_transport_fc.h
+++ b/include/scsi/scsi_transport_fc.h
@@ -345,12 +345,14 @@ struct fc_rport {	/* aka fc_starget_attrs */
 	u32 number;
 	u8 flags;
 	struct list_head peers;
+	struct list_head eh_work_q;
 	struct device dev;
  	struct delayed_work dev_loss_work;
  	struct work_struct scan_work;
  	struct delayed_work fail_io_work;
  	struct work_struct stgt_delete_work;
 	struct work_struct rport_delete_work;
+	struct work_struct rport_eh_work;
 	struct request_queue *rqst_q;	/* bsg support */
 } __attribute__((aligned(sizeof(unsigned long))));
 
-- 
1.7.12.4


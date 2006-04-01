From: Tejun Heo <htejun@gmail.com>
Subject: [PATCH] SCSI: implement scsi_eh_schedule()
Date: Sat, 1 Apr 2006 19:38:57 +0900
Message-ID: <20060401103857.GG13172@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-ide-owner@vger.kernel.org
To: hch@lst.de, James.Bottomley@SteelEye.com, Jeff Garzik <jgarzik@pobox.com>, alan@lxorguk.ukuu.org.uk, albertcc@tw.ibm.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

[PATCH] SCSI: implement scsi_eh_schedule()

This patch implements scsi_eh_schedule() which provides a way to
directly invoke SCSI EH from drivers which implement EH using
->eh_strategy_handler.  Combined with scsi_eh_flush_done_q(), this
gives such drivers complete control over when and how to invoke EH and
handle failed commands.

scsi_eh_schedule() can also be invoked without a scmd.  This is useful
for handling exception conditions occurring while no command is in
progress.  New Scsi_Host field host_eh_invoked is added for this.

Signed-off-by: Tejun Heo <htejun@gmail.com>

---

Hello, all.

This patch is in preparation for new libata EH implementation.  As
described above, this is to allow LLDD's direct access to SCSI EH
rather than invoking it indirectly with CHECK SENSE without sense data
hack.

This patch applies cleanly to both scsi-misc-2.6 and libata-dev.  If
this gets ACKed, it would be better to merge via libata-dev as this
change is necessary for new libata EH.

Thanks.

 drivers/scsi/scsi_error.c |   40 +++++++++++++++++++++++++++++++++++++++-
 include/scsi/scsi_eh.h    |    1 +
 include/scsi/scsi_host.h  |    1 +
 3 files changed, 41 insertions(+), 1 deletion(-)

Index: work/drivers/scsi/scsi_error.c
===================================================================
--- work.orig/drivers/scsi/scsi_error.c	2006-04-01 16:42:51.000000000 +0900
+++ work/drivers/scsi/scsi_error.c	2006-04-01 16:42:58.000000000 +0900
@@ -90,6 +90,44 @@ int scsi_eh_scmd_add(struct scsi_cmnd *s
 }
 
 /**
+ * scsi_eh_schedule - schedule error handling.
+ * @shost:	SCSI host to invoke error handling on.
+ * @scmd:	scmd to run eh on (can be NULL)
+ *
+ * Return value:
+ *	0 on failure.
+ **/
+int scsi_eh_schedule(struct Scsi_Host *shost, struct scsi_cmnd *scmd)
+{
+	unsigned long flags;
+	int ret = 0;
+
+	WARN_ON(!shost->hostt->eh_strategy_handler);
+
+	if (!shost->ehandler)
+		return 0;
+
+	if (scmd && !scsi_delete_timer(scmd))
+		return 0;	/* timeout won */
+
+	spin_lock_irqsave(shost->host_lock, flags);
+	if (scsi_host_set_state(shost, SHOST_RECOVERY))
+		if (scsi_host_set_state(shost, SHOST_CANCEL_RECOVERY))
+			goto out_unlock;
+	ret = 1;
+	if (scmd) {
+		list_add_tail(&scmd->eh_entry, &shost->eh_cmd_q);
+		shost->host_failed++;
+	} else
+		shost->host_eh_invoked++;
+	scsi_eh_wakeup(shost);
+ out_unlock:
+	spin_unlock_irqrestore(shost->host_lock, flags);
+	return ret;
+}
+EXPORT_SYMBOL(scsi_eh_schedule);
+
+/**
  * scsi_add_timer - Start timeout timer for a single scsi command.
  * @scmd:	scsi command that is about to start running.
  * @timeout:	amount of time to allow this command to run.
@@ -1517,7 +1555,7 @@ int scsi_error_handler(void *data)
 	 */
 	set_current_state(TASK_INTERRUPTIBLE);
 	while (!kthread_should_stop()) {
-		if (shost->host_failed == 0 ||
+		if ((shost->host_failed == 0 && shost->host_eh_invoked == 0) ||
 		    shost->host_failed != shost->host_busy) {
 			SCSI_LOG_ERROR_RECOVERY(1,
 				printk("Error handler scsi_eh_%d sleeping\n",
Index: work/include/scsi/scsi_eh.h
===================================================================
--- work.orig/include/scsi/scsi_eh.h	2006-04-01 16:42:51.000000000 +0900
+++ work/include/scsi/scsi_eh.h	2006-04-01 16:42:58.000000000 +0900
@@ -35,6 +35,7 @@ static inline int scsi_sense_valid(struc
 }
 
 
+extern int scsi_eh_schedule(struct Scsi_Host *shost, struct scsi_cmnd *scmd);
 extern void scsi_eh_finish_cmd(struct scsi_cmnd *scmd,
 			       struct list_head *done_q);
 extern void scsi_eh_flush_done_q(struct list_head *done_q);
Index: work/include/scsi/scsi_host.h
===================================================================
--- work.orig/include/scsi/scsi_host.h	2006-04-01 16:42:51.000000000 +0900
+++ work/include/scsi/scsi_host.h	2006-04-01 16:42:58.000000000 +0900
@@ -473,6 +473,7 @@ struct Scsi_Host {
 	 */
 	unsigned int host_busy;		   /* commands actually active on low-level */
 	unsigned int host_failed;	   /* commands that failed. */
+	unsigned int host_eh_invoked;	   /* EH invocations without command */
     
 	unsigned short host_no;  /* Used for IOCTL_GET_IDLUN, /proc/scsi et al. */
 	int resetting; /* if set, it means that last_reset is a valid value */

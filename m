From: Tejun Heo <htejun@gmail.com>
Subject: [PATCH 2/2] SCSI: implement scsi_eh_schedule_host()
Date: Mon, 3 Apr 2006 01:06:46 +0900
Message-ID: <20060402160646.GN13172@htj.dyndns.org>
References: <20060401103857.GG13172@htj.dyndns.org> <442EDF1F.6000001@pobox.com> <442F25BD.8040000@gmail.com> <20060402160414.GM13172@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20060402160414.GM13172@htj.dyndns.org>
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: hch@lst.de, James.Bottomley@SteelEye.com, alan@lxorguk.ukuu.org.uk, albertcc@tw.ibm.com, arjan@infradead.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This patch implements scsi_eh_schedule_host() which provides a way to
directly invoke SCSI EH without SCSI command from drivers implementing
->eh_strategy_handler.  This allows such drivers to use EH to handle
exception conditions which are not associated with particular SCSI
command.

Signed-off-by: Tejun Heo <htejun@gmail.com>

---

Jeff, I think using separate variable (->host_eh_scheduled) is the
simplest way to implement this.  Adding more semantics to ->host_busy
and failed doesn't sound very attractive to me.

 drivers/scsi/scsi_error.c |   38 +++++++++++++++++++++++++++++++++++++-
 include/scsi/scsi_eh.h    |    1 +
 include/scsi/scsi_host.h  |    1 +
 3 files changed, 39 insertions(+), 1 deletions(-)

544d293f756e7041f676ac30152445339111a9c8
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index c314095..bc8a253 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -114,6 +114,42 @@ int scsi_eh_schedule_cmd(struct scsi_cmn
 EXPORT_SYMBOL_GPL(scsi_eh_schedule_cmd);
 
 /**
+ * scsi_eh_schedule_host - schedule scsi host for error handling
+ * @shost:	SCSI host to invoke error handling on.
+ *
+ * Description:
+ *	This function is used by LLDDs which don't use standard SCSI
+ *	EH to schedule @shost for EH.  This allows such LLDDs to use
+ *	EH for handling exceptions not associated with command.
+ *
+ * Return value:
+ *	0 on failure.
+ **/
+int scsi_eh_schedule_host(struct Scsi_Host *shost)
+{
+	unsigned long flags;
+	int ret = 0;
+
+	WARN_ON(!shost->hostt->eh_strategy_handler);
+
+	if (!shost->ehandler)
+		return 0;
+
+	spin_lock_irqsave(shost->host_lock, flags);
+	if (scsi_host_set_state(shost, SHOST_RECOVERY))
+		if (scsi_host_set_state(shost, SHOST_CANCEL_RECOVERY))
+			goto out_unlock;
+
+	ret = 1;
+	shost->host_eh_scheduled++;
+	scsi_eh_wakeup(shost);
+ out_unlock:
+	spin_unlock_irqrestore(shost->host_lock, flags);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(scsi_eh_schedule_host);
+
+/**
  * scsi_add_timer - Start timeout timer for a single scsi command.
  * @scmd:	scsi command that is about to start running.
  * @timeout:	amount of time to allow this command to run.
@@ -1541,7 +1577,7 @@ int scsi_error_handler(void *data)
 	 */
 	set_current_state(TASK_INTERRUPTIBLE);
 	while (!kthread_should_stop()) {
-		if (shost->host_failed == 0 ||
+		if ((shost->host_failed == 0 && shost->host_eh_scheduled == 0) ||
 		    shost->host_failed != shost->host_busy) {
 			SCSI_LOG_ERROR_RECOVERY(1,
 				printk("Error handler scsi_eh_%d sleeping\n",
diff --git a/include/scsi/scsi_eh.h b/include/scsi/scsi_eh.h
index dd0a50e..b1c09f4 100644
--- a/include/scsi/scsi_eh.h
+++ b/include/scsi/scsi_eh.h
@@ -36,6 +36,7 @@ static inline int scsi_sense_valid(struc
 
 
 extern int scsi_eh_schedule_cmd(struct scsi_cmnd *scmd);
+extern int scsi_eh_schedule_host(struct Scsi_Host *shost);
 extern void scsi_eh_finish_cmd(struct scsi_cmnd *scmd,
 			       struct list_head *done_q);
 extern void scsi_eh_flush_done_q(struct list_head *done_q);
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index dc6862d..a991b9c 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -473,6 +473,7 @@ struct Scsi_Host {
 	 */
 	unsigned int host_busy;		   /* commands actually active on low-level */
 	unsigned int host_failed;	   /* commands that failed. */
+	unsigned int host_eh_scheduled;	   /* EH scheduled without command */
     
 	unsigned short host_no;  /* Used for IOCTL_GET_IDLUN, /proc/scsi et al. */
 	int resetting; /* if set, it means that last_reset is a valid value */
-- 
1.2.4


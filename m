From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH]: Flexible timeout infrastructure
Date: 16 Jun 2004 10:58:36 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1087401518.1747.21.camel@mulgrave>
References: <40CF0F9F.4050902@adaptec.com><1087313492.1796.37.camel@mulgrave>
	<40CF4A15.9060005@adaptec.com><1087329285.2048.94.camel@mulgrave>
	<20040616152758.GB4288@us.ibm.com> <1087400228.1747.16.camel@mulgrave>
	<40D06BD7.1050605@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:31377 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S264082AbUFPP6v (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Jun 2004 11:58:51 -0400
In-Reply-To: <40D06BD7.1050605@adaptec.com>
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: Mike Anderson <andmike@us.ibm.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wed, 2004-06-16 at 10:48, Luben Tuikov wrote:
> Anyway, do we have a patch for *this* solution?

Here's a sketch of the implementation (without all the comments etc that
would need to be done) so people can visualise it

James

===== drivers/scsi/scsi.c 1.143 vs edited =====
--- 1.143/drivers/scsi/scsi.c	2004-04-28 11:32:09 -05:00
+++ edited/drivers/scsi/scsi.c	2004-06-16 10:47:05 -05:00
@@ -689,8 +689,6 @@
  */
 void scsi_done(struct scsi_cmnd *cmd)
 {
-	unsigned long flags;
-
 	/*
 	 * We don't have to worry about this one timing out any more.
 	 * If we are unable to remove the timer, then the command
@@ -701,6 +699,14 @@
 	 */
 	if (!scsi_delete_timer(cmd))
 		return;
+	__scsi_done(cmd);
+}
+
+/* Private entry to scsi_done() to complete a command when the timer
+ * isn't running --- used by scsi_times_out */
+void __scsi_done(struct scsi_cmnd *cmd)
+{
+	unsigned long flags;
 
 	/*
 	 * Set the serial numbers back to zero
===== drivers/scsi/scsi_error.c 1.77 vs edited =====
--- 1.77/drivers/scsi/scsi_error.c	2004-06-06 06:19:15 -05:00
+++ edited/drivers/scsi/scsi_error.c	2004-06-16 10:53:02 -05:00
@@ -162,6 +162,24 @@
 void scsi_times_out(struct scsi_cmnd *scmd)
 {
 	scsi_log_completion(scmd, TIMEOUT_ERROR);
+
+	if (scmd->device->host->hostt->eh_timed_out)
+		switch (scmd->device->host->hostt->eh_timed_out(scmd)) {
+		case EH_HANDLED:
+			__scsi_done(scmd);
+			return;
+		case EH_RESET_TIMER:
+			/* This allows a single retry even of a command
+			 * with allowed == 0 */
+			if (scmd->retries++ > scmd->allowed)
+				break;
+			scsi_add_timer(scmd, scmd->timeout_per_command,
+				       scsi_times_out);
+			return;
+		case EH_NOT_HANDLED:
+			break;
+		}
+
 	if (unlikely(!scsi_eh_scmd_add(scmd, SCSI_EH_CANCEL_CMD))) {
 		panic("Error handler thread not present at %p %p %s %d",
 		      scmd, scmd->device->host, __FILE__, __LINE__);
===== drivers/scsi/scsi_priv.h 1.32 vs edited =====
--- 1.32/drivers/scsi/scsi_priv.h	2004-03-10 22:20:08 -06:00
+++ edited/drivers/scsi/scsi_priv.h	2004-06-16 10:45:44 -05:00
@@ -82,6 +82,7 @@
 extern void scsi_init_cmd_from_req(struct scsi_cmnd *cmd,
 		struct scsi_request *sreq);
 extern void __scsi_release_request(struct scsi_request *sreq);
+extern void __scsi_done(struct scsi_cmnd *cmd);
 #ifdef CONFIG_SCSI_LOGGING
 void scsi_log_send(struct scsi_cmnd *cmd);
 void scsi_log_completion(struct scsi_cmnd *cmd, int disposition);
===== include/scsi/scsi_host.h 1.17 vs edited =====
--- 1.17/include/scsi/scsi_host.h	2004-06-04 11:51:31 -05:00
+++ edited/include/scsi/scsi_host.h	2004-06-16 10:36:23 -05:00
@@ -30,6 +30,12 @@
 #define DISABLE_CLUSTERING 0
 #define ENABLE_CLUSTERING 1
 
+enum scsi_eh_timer_return {
+	EH_NOT_HANDLED,
+	EH_HANDLED,
+	EH_RESET_TIMER,
+};
+
 
 struct scsi_host_template {
 	struct module *module;
@@ -124,6 +130,8 @@
 	int (* eh_device_reset_handler)(struct scsi_cmnd *);
 	int (* eh_bus_reset_handler)(struct scsi_cmnd *);
 	int (* eh_host_reset_handler)(struct scsi_cmnd *);
+
+	enum scsi_eh_timer_return (* eh_timed_out)(struct scsi_cmnd *);
 
 	/*
 	 * Old EH handlers, no longer used. Make them warn the user of old


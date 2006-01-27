From: Luben Tuikov <ltuikov@yahoo.com>
Subject: [PATCH] SCSI: Introduce scsi_req_abort_cmd
Date: Thu, 26 Jan 2006 21:22:26 -0800 (PST)
Message-ID: <20060127052226.39927.qmail@web31808.mail.mud.yahoo.com>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31808.mail.mud.yahoo.com ([68.142.207.71]:49784 "HELO
	web31808.mail.mud.yahoo.com") by vger.kernel.org with SMTP
	id S932423AbWA0FW3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Jan 2006 00:22:29 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

Introduce scsi_req_abort_cmd(struct scsi_cmnd *).
This function requests that SCSI Core start recovery for the
command by deleting the timer and adding the command to the eh
queue.  It can be called by either LLDDs or SCSI Core.  LLDDs who
implement their own error recovery MAY ignore the timeout event if
they generated scsi_req_abort_cmd.

Signed-off-by: Luben Tuikov <ltuikov@yahoo.com>

---

 drivers/scsi/scsi.c      |   18 ++++++++++++++++++
 include/scsi/scsi_cmnd.h |    1 +
 2 files changed, 19 insertions(+), 0 deletions(-)

51df19a1669bd502b536178d6c294e68be25ce79
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 245ca99..1af9795 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -721,6 +721,24 @@ void scsi_init_cmd_from_req(struct scsi_
 static DEFINE_PER_CPU(struct list_head, scsi_done_q);
 
 /**
+ * scsi_req_abort_cmd -- Request command recovery for the specified command
+ * cmd: pointer to the SCSI command of interest
+ *
+ * This function requests that SCSI Core start recovery for the
+ * command by deleting the timer and adding the command to the eh
+ * queue.  It can be called by either LLDDs or SCSI Core.  LLDDs who
+ * implement their own error recovery MAY ignore the timeout event if
+ * they generated scsi_req_abort_cmd.
+ */
+void scsi_req_abort_cmd(struct scsi_cmnd *cmd)
+{
+	if (!scsi_delete_timer(cmd))
+		return;
+	scsi_times_out(cmd);
+}
+EXPORT_SYMBOL(scsi_req_abort_cmd);
+
+/**
  * scsi_done - Enqueue the finished SCSI command into the done queue.
  * @cmd: The SCSI Command for which a low-level device driver (LLDD) gives
  * ownership back to SCSI Core -- i.e. the LLDD has finished with it.
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index 7529f43..8b9ad8c 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -151,5 +151,6 @@ extern struct scsi_cmnd *scsi_get_comman
 extern void scsi_put_command(struct scsi_cmnd *);
 extern void scsi_io_completion(struct scsi_cmnd *, unsigned int, unsigned int);
 extern void scsi_finish_command(struct scsi_cmnd *cmd);
+extern void scsi_req_abort_cmd(struct scsi_cmnd *cmd);
 
 #endif /* _SCSI_SCSI_CMND_H */
-- 
1.1.4.gb737


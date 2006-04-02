From: Tejun Heo <htejun@gmail.com>
Subject: [PATCH 1/2] SCSI: implement scsi_eh_schedule_cmd()
Date: Mon, 3 Apr 2006 01:04:14 +0900
Message-ID: <20060402160414.GM13172@htj.dyndns.org>
References: <20060401103857.GG13172@htj.dyndns.org> <442EDF1F.6000001@pobox.com> <442F25BD.8040000@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <442F25BD.8040000@gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: hch@lst.de, James.Bottomley@SteelEye.com, alan@lxorguk.ukuu.org.uk, albertcc@tw.ibm.com, arjan@infradead.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This patch implements scsi_eh_schedule_cmd() which provides a way to
directly invoke SCSI EH from drivers implementing
->eh_strategy_handler.  Combined with scsi_eh_flush_done_q(), this
gives such drivers complete control over when and how to invoke EH and
handle failed commands.

Signed-off-by: Tejun Heo <htejun@gmail.com>

---

 drivers/scsi/scsi_error.c |   24 ++++++++++++++++++++++++
 include/scsi/scsi_eh.h    |    1 +
 2 files changed, 25 insertions(+), 0 deletions(-)

caaed524eab41fab88be717d06627bd50cf66ee2
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 5f0fdfb..c314095 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -90,6 +90,30 @@ int scsi_eh_scmd_add(struct scsi_cmnd *s
 }
 
 /**
+ * scsi_eh_schedule_cmd - schedule scsi cmd for error handling.
+ * @scmd:	scmd to run eh on.
+ *
+ * Description:
+ *	This function is used by LLDDs which don't use standard SCSI
+ *	EH to schedule scmd for EH.
+ *
+ * Return value:
+ *	0 on failure.
+ **/
+int scsi_eh_schedule_cmd(struct scsi_cmnd *scmd)
+{
+	struct Scsi_Host *shost = scmd->device->host;
+
+	WARN_ON(!shost->hostt->eh_strategy_handler);
+
+	if (!scsi_delete_timer(scmd))
+		return 0;	/* timeout won */
+
+	return scsi_eh_scmd_add(scmd, 0);
+}
+EXPORT_SYMBOL_GPL(scsi_eh_schedule_cmd);
+
+/**
  * scsi_add_timer - Start timeout timer for a single scsi command.
  * @scmd:	scsi command that is about to start running.
  * @timeout:	amount of time to allow this command to run.
diff --git a/include/scsi/scsi_eh.h b/include/scsi/scsi_eh.h
index d160880..dd0a50e 100644
--- a/include/scsi/scsi_eh.h
+++ b/include/scsi/scsi_eh.h
@@ -35,6 +35,7 @@ static inline int scsi_sense_valid(struc
 }
 
 
+extern int scsi_eh_schedule_cmd(struct scsi_cmnd *scmd);
 extern void scsi_eh_finish_cmd(struct scsi_cmnd *scmd,
 			       struct list_head *done_q);
 extern void scsi_eh_flush_done_q(struct list_head *done_q);
-- 
1.2.4


From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] scsi: Convert scsi_host->cmd_serial_number to odd numbered atomic_t counter
Date: Thu, 11 Nov 2010 02:46:45 -0800
Message-ID: <1289472405-31003-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>, James Bottomley <James.Bottomley@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch converts struct scsi_host->cmd_serial_number to a 'odd incremented by 2'
atomic_t counter in scsi_cmd_get_serial(), and moves the host_lock held call in
jgarzik's DEF_SCSI_QCMD() wrapper back into it's original location in scsi_dispatch_cmd().

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/scsi/hosts.c     |    1 +
 drivers/scsi/scsi.c      |   20 ++++++++++++++------
 include/scsi/scsi_host.h |    7 ++-----
 3 files changed, 17 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 4f7a582..317af8e 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -381,6 +381,7 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
 	shost->unchecked_isa_dma = sht->unchecked_isa_dma;
 	shost->use_clustering = sht->use_clustering;
 	shost->ordered_tag = sht->ordered_tag;
+	atomic_set(&shost->cmd_serial_number, 1);
 
 	if (sht->supported_mode == MODE_UNKNOWN)
 		/* means we didn't set it ... default to INITIATOR */
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index e3d0629..bdc0837 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -632,15 +632,17 @@ void scsi_log_completion(struct scsi_cmnd *cmd, int disposition)
  * @cmd: command to assign serial number to
  *
  * Description: a serial number identifies a request for error recovery
- * and debugging purposes.  Protected by the Host_Lock of host.
+ * and debugging purposes.  Called directly by scsi_dispatch_cmd() for all LLDs
+ * after the great host_lock pushdown. 
  */
-void scsi_cmd_get_serial(struct Scsi_Host *host, struct scsi_cmnd *cmd)
+static inline void scsi_cmd_get_serial(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 {
-	cmd->serial_number = host->cmd_serial_number++;
-	if (cmd->serial_number == 0) 
-		cmd->serial_number = host->cmd_serial_number++;
+	/*
+	 * Increment the host->cmd_serial_number by 2 so cmd->serial_number
+	 * is always odd and wraps to 1 instead of 0.
+	 */
+	cmd->serial_number = atomic_add_return(2, &host->cmd_serial_number);
 }
-EXPORT_SYMBOL(scsi_cmd_get_serial);
 
 /**
  * scsi_dispatch_command - Dispatch a command to the low-level driver.
@@ -736,6 +738,12 @@ int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
 		scsi_done(cmd);
 		goto out;
 	}
+	/*
+	 * Assign a cmd->serial_number from host->cmd_serial_number that
+	 * is used by scsi_softirq_done() to signal scsi_try_to_abort_cmd()
+	 * that a outstanding cmd has been completed.
+	 */
+	scsi_cmd_get_serial(host, cmd);
 
 	if (unlikely(host->shost_state == SHOST_DEL)) {
 		cmd->result = (DID_NO_CONNECT << 16);
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index cea74ba..6909038 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -518,7 +518,6 @@ struct scsi_host_template {
 		int rc;							\
 		struct Scsi_Host *shost = cmd->device->host;		\
 		spin_lock_irqsave(shost->host_lock, irq_flags);		\
-		scsi_cmd_get_serial(shost, cmd);			\
 		rc = func_name##_lck (cmd, done);			\
 		spin_unlock_irqrestore(shost->host_lock, irq_flags);	\
 		return rc;						\
@@ -625,10 +624,9 @@ struct Scsi_Host {
 	short unsigned int max_sectors;
 	unsigned long dma_boundary;
 	/* 
-	 * Used to assign serial numbers to the cmds.
-	 * Protected by the host lock.
+	 * Used to assign serial numbers to the cmds in scsi_cmd_get_serial()
 	 */
-	unsigned long cmd_serial_number;
+	atomic_t cmd_serial_number;
 	
 	unsigned active_mode:2;
 	unsigned unchecked_isa_dma:1;
@@ -773,7 +771,6 @@ extern struct Scsi_Host *scsi_host_get(struct Scsi_Host *);
 extern void scsi_host_put(struct Scsi_Host *t);
 extern struct Scsi_Host *scsi_host_lookup(unsigned short);
 extern const char *scsi_host_state_name(enum scsi_host_state);
-extern void scsi_cmd_get_serial(struct Scsi_Host *, struct scsi_cmnd *);
 
 extern u64 scsi_calculate_bounce_limit(struct Scsi_Host *);
 
-- 
1.5.6.5

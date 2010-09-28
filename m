From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [RFC v4 01/19] scsi: Add SHT->unlocked_qcmd for host_lock less SHT->queuecommand() dispatch
Date: Mon, 27 Sep 2010 19:05:12 -0700
Message-ID: <1285639512-7224-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Vasu Dev <vasu.dev@linux.intel.com>, Tim Chen <tim.c.chen@linux.intel.com>, Andi Kleen <ak@linux>
Cc: James Smart <james.smart@emulex.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Hannes Reinecke <hare@suse.de>, Joe Eykholt <jeykholt@cisco.com>, Christoph Hellwig <hch@lst.de>, Jon Hawley <warthog9@kernel.org>, MPTFusionLinux <DL-MPTFusionLinux@lsi.com>, "eata.c maintainer" <dario.ballabio@inwind.it>, Luben Tuikov <ltuikov@yahoo.com>, mvsas maintainer <kewei@marvell.com>, pm8001 maintainer Jack Wang <jack_wang@usish.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds scsi_dispatch_cmd_unlocked() and scsi_dispatch_cmd_locked()
which are now called directly from scsi_dispatch_cmd() depending upon what
is reported by SHT->unlocked_qcmd on a per driver basis.  Note that by default
unlocked_qcmd is disabled, and all LLDs not defining a SHT->unlocked_qcmd will
be using the legacy scsi_dispatch_cmd_locked().

This patch also drops the usage of scsi_cmd_get_serial() in scsi_dispatch_cmd()
and assumes the legacy SCSI LLDs that depend upon struct scsi_cmnd->serial_number
will call the now EXPORT_SYMBOL()'ed scsi_cmd_get_serial() call.

This patch also adds a Jen's recommended blk_test_rq_complete(), which is used
by scsi_error.c:scsi_try_to_abort_cmd() here:

	if (blk_test_rq_complete(scmd->request))
                return SUCCESS;

instead of checking for the legacy (scmd->serial_number == 0).

Finally, this patch also converts the remaining struct Scsi_Host->cmd_serial_number
to atomic_t following a recommedation by Joe Eykholt to start struct Scsi_Host->
cmd_serial_number at 1, and increment each serial_number by 2 so that the
serial is odd, and wraps to 1 instead of 0.  struct Scsi_Host->cmd_serial_number
is initialized to '1' in drivers/scsi/hosts.c:scsi_host_alloc().

Many thanks to Vasu Dev, Tim Chen, Mike Christie, Joe Eykholt, Mike Anderson,
Christof Schmitt, Brian King and Jens Axboe for their help with this series!

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 block/blk.h               |    4 ++
 drivers/scsi/hosts.c      |    5 +++
 drivers/scsi/scsi.c       |   89 ++++++++++++++++++++++++++++++++++-----------
 drivers/scsi/scsi_error.c |   10 ++++--
 include/scsi/scsi_cmnd.h  |    1 +
 include/scsi/scsi_host.h  |   16 +++++++--
 6 files changed, 98 insertions(+), 27 deletions(-)

diff --git a/block/blk.h b/block/blk.h
index d6b911a..6f3ca9c 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -46,6 +46,10 @@ static inline void blk_clear_rq_complete(struct request *rq)
 	clear_bit(REQ_ATOM_COMPLETE, &rq->atomic_flags);
 }
 
+static inline int blk_test_rq_complete(struct request *rq)
+{
+	return test_bit(REQ_ATOM_COMPLETE, &rq->atomic_flags);
+}
 /*
  * Internal elevator interface
  */
diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 8a8f803..1ca6bce 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -380,6 +380,11 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
 	shost->unchecked_isa_dma = sht->unchecked_isa_dma;
 	shost->use_clustering = sht->use_clustering;
 	shost->ordered_tag = sht->ordered_tag;
+	shost->unlocked_qcmd = sht->unlocked_qcmd;
+	/*
+	 * Set the default shost->cmd_serial_number to 1.
+	 */
+	atomic_set(&shost->cmd_serial_number, 1);
 
 	if (sht->supported_mode == MODE_UNKNOWN)
 		/* means we didn't set it ... default to INITIATOR */
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index ad0ed21..abd3fa5 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -628,17 +628,69 @@ void scsi_log_completion(struct scsi_cmnd *cmd, int disposition)
 
 /**
  * scsi_cmd_get_serial - Assign a serial number to a command
- * @host: the scsi host
  * @cmd: command to assign serial number to
  *
  * Description: a serial number identifies a request for error recovery
- * and debugging purposes.  Protected by the Host_Lock of host.
+ * and debugging purposes.  Called directly by SCSI LLDs that have a
+ * legacy requirement for struct scsi_cmnd->serial_number.
  */
-static inline void scsi_cmd_get_serial(struct Scsi_Host *host, struct scsi_cmnd *cmd)
+void scsi_cmd_get_serial(struct scsi_cmnd *cmd)
 {
-	cmd->serial_number = host->cmd_serial_number++;
-	if (cmd->serial_number == 0) 
-		cmd->serial_number = host->cmd_serial_number++;
+	struct Scsi_Host *host = cmd->device->host;
+	/*
+	 * Increment the host->cmd_serial_number by 2 so cmd->serial_number
+	 * is always odd and wraps to 1 instead of 0.
+	 */
+	cmd->serial_number = atomic_add_return(2, &host->cmd_serial_number);
+}
+EXPORT_SYMBOL(scsi_cmd_get_serial);
+
+/*
+ * scsi_dispatch_cmd_unlocked() - Dispatch a cmd w/o host_lock
+ * @cmd: command to dispatch.
+ * @host: SCSI host of the passed command
+ *
+ * Description: Used by modern SCSI LLDs that do not require that
+ * struct Scsi_Host->host_lock is held during a dispatch call to
+ * SHT->queuecommand().
+ */
+
+static inline int scsi_dispatch_cmd_unlocked(struct scsi_cmnd *cmd,
+					struct Scsi_Host *host)
+{
+	int rtn = 0;
+
+	if (unlikely(host->shost_state == SHOST_DEL)) {
+		cmd->result = (DID_NO_CONNECT << 16);
+		scsi_done(cmd);
+	} else {
+		trace_scsi_dispatch_cmd_start(cmd);
+		rtn = host->hostt->queuecommand(cmd, scsi_done);
+	}
+
+	return rtn;
+}
+
+/*
+ * scsi_dispatch_cmd_locked() - Dispatch a cmd w/ host_lock
+ * @cmd: command to dispatch.
+ * @host: SCSI host of the passed command
+ *
+ * Description: Used by kegacy SCSI LLDs that require that
+ * struct Scsi_Host->host_lock is held during a dispatch call to
+ * SHT->queuecommand().
+ */
+static inline int scsi_dispatch_cmd_locked(struct scsi_cmnd *cmd,
+					struct Scsi_Host *host)
+{
+	unsigned long flags;
+	int rtn = 0;
+
+	spin_lock_irqsave(host->host_lock, flags);
+	rtn = scsi_dispatch_cmd_unlocked(cmd, host);
+	spin_unlock_irqrestore(host->host_lock, flags);
+
+	return rtn;
 }
 
 /**
@@ -651,7 +703,6 @@ static inline void scsi_cmd_get_serial(struct Scsi_Host *host, struct scsi_cmnd
 int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
 {
 	struct Scsi_Host *host = cmd->device->host;
-	unsigned long flags = 0;
 	unsigned long timeout;
 	int rtn = 0;
 
@@ -736,24 +787,20 @@ int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
 		scsi_done(cmd);
 		goto out;
 	}
-
-	spin_lock_irqsave(host->host_lock, flags);
 	/*
-	 * AK: unlikely race here: for some reason the timer could
-	 * expire before the serial number is set up below.
+	 * Note that scsi_cmd_get_serial() used to be called here, but
+	 * now we expect the legacy SCSI LLDs that actually need this
+	 * to call it directly within their SHT->queuecommand() caller.
 	 *
-	 * TODO: kill serial or move to blk layer
+	 * Also check for the new unlocked_qcmd bit to signal that the
+	 * underlying LLD SHT->queuecommand() code is safe to run w/o
+	 * struct Scsi_Host->host_lock held.
 	 */
-	scsi_cmd_get_serial(host, cmd); 
+	if (host->unlocked_qcmd)
+		rtn = scsi_dispatch_cmd_unlocked(cmd, host);
+	else
+		rtn = scsi_dispatch_cmd_locked(cmd, host);
 
-	if (unlikely(host->shost_state == SHOST_DEL)) {
-		cmd->result = (DID_NO_CONNECT << 16);
-		scsi_done(cmd);
-	} else {
-		trace_scsi_dispatch_cmd_start(cmd);
-		rtn = host->hostt->queuecommand(cmd, scsi_done);
-	}
-	spin_unlock_irqrestore(host->host_lock, flags);
 	if (rtn) {
 		trace_scsi_dispatch_cmd_error(cmd, rtn);
 		if (rtn != SCSI_MLQUEUE_DEVICE_BUSY &&
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 1de30eb..6e496c3 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -39,6 +39,8 @@
 #include "scsi_logging.h"
 #include "scsi_transport_api.h"
 
+#include <../block/blk.h> /* For REQ_ATOM_COMPLETE */
+
 #include <trace/events/scsi.h>
 
 #define SENSE_TIMEOUT		(10*HZ)
@@ -645,11 +647,13 @@ static int __scsi_try_to_abort_cmd(struct scsi_cmnd *scmd)
 static int scsi_try_to_abort_cmd(struct scsi_cmnd *scmd)
 {
 	/*
-	 * scsi_done was called just after the command timed out and before
-	 * we had a chance to process it. (db)
+	 * Use the struct request atomic_flags here to check if
+	 * block/blk.h:blk_mark_rq_complete() has already been called
+	 * from the block softirq
 	 */
-	if (scmd->serial_number == 0)
+	if (blk_test_rq_complete(scmd->request))
 		return SUCCESS;
+
 	return __scsi_try_to_abort_cmd(scmd);
 }
 
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index a5e885a..bbba4fa 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -136,6 +136,7 @@ extern struct scsi_cmnd *__scsi_get_command(struct Scsi_Host *, gfp_t);
 extern void scsi_put_command(struct scsi_cmnd *);
 extern void __scsi_put_command(struct Scsi_Host *, struct scsi_cmnd *,
 			       struct device *);
+extern void scsi_cmd_get_serial(struct scsi_cmnd *);
 extern void scsi_finish_command(struct scsi_cmnd *cmd);
 
 extern void *scsi_kmap_atomic_sg(struct scatterlist *sg, int sg_count,
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index b7bdecb..f9ddf94 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -460,6 +460,12 @@ struct scsi_host_template {
 	 */
 	unsigned ordered_tag:1;
 
+        /*
+	 * True if the LLD allows for unlocked struct Scsi_Host->host_lock
+	 * SHT->queuecommand() calls to increase performance.
+	 */
+	unsigned unlocked_qcmd:1;
+
 	/*
 	 * Countdown for host blocking with no commands outstanding.
 	 */
@@ -602,10 +608,9 @@ struct Scsi_Host {
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
@@ -630,6 +635,11 @@ struct Scsi_Host {
 	 */
 	unsigned ordered_tag:1;
 
+	/*
+	 * Unlocked scsi_dispatch_cmd() -> SHT->queuecommand() support
+	 */
+	unsigned unlocked_qcmd:1;
+
 	/* Task mgmt function in progress */
 	unsigned tmf_in_progress:1;
 
-- 
1.7.3

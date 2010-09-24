From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [RFC v3 01/15] scsi: Drop struct Scsi_Host->host_lock usage in scsi_dispatch_cmd()
Date: Thu, 23 Sep 2010 17:46:04 -0700
Message-ID: <1285289164-16890-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Vasu Dev <vasu.dev@linux.intel.com>, Tim Chen <tim.c.chen@linux.intel.com>, Andi Kleen <ak@linux>
Cc: James Smart <james.smart@emulex.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Hannes Reinecke <hare@suse.de>, Joe Eykholt <jeykholt@cisco.com>, Christoph Hellwig <hch@lst.de>, MPTFusionLinux <DL-MPTFusionLinux@lsi.com>, "eata.c maintainer" <dario.ballabio@inwind.it>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Hi Guys,

This is a quick re-spin of patch #1 that was missing the hosts.c:scsi_host_alloc()
initialization of struct Scsi_Host->cmd_serial_number.  Thanks to Joe for
spotting this.

--------------------------------------------------------------------------------

This patch converts scsi_dispatch_cmd() drop the struct Scsi_Host->host_lock
legacy usage so that SHT->queuecommand() can be called without this lock held
softirq interrupts disabled via spin_lock_irq()

This patch drops the usage of scsi_cmd_get_serial() in scsi_dispatch_cmd()
and assumes the legacy SCSI LLDs that depend upon struct scsi_cmnd->serial_number
will call the now EXPORT_SYMBOL()'ed scsi_cmd_get_serial() call.

This patch also updates scsi_error.c:scsi_try_to_abort_cmd() to use:

        if (test_bit(REQ_ATOM_COMPLETE, &scmd->request->atomic_flags))
                return SUCCESS;

instead of checking for (scmd->serial_number == 0) following a recommendation
by Mike Christie.

This patch also converts the remaining struct Scsi_Host->cmd_serial_number to
atomic_t following a recommedation by Joe Eykholt to start struct Scsi_Host->
cmd_serial_number at 1, and increment each serial_number by 2 so that the
serial is odd, and wraps to 1 instead of 0.  struct Scsi_Host->cmd_serial_number
is initialized to '1' in drivers/scsi/hosts.c:scsi_host_alloc().

Many thanks to Vasu Dev, Tim Chen, Mike and Joe for their help with particular
series!

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/scsi/hosts.c      |    4 ++++
 drivers/scsi/scsi.c       |   29 ++++++++++++++---------------
 drivers/scsi/scsi_error.c |   10 +++++++---
 include/scsi/scsi_cmnd.h  |    1 +
 include/scsi/scsi_host.h  |    5 ++---
 5 files changed, 28 insertions(+), 21 deletions(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 8a8f803..aff1c9c 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -380,6 +380,10 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
 	shost->unchecked_isa_dma = sht->unchecked_isa_dma;
 	shost->use_clustering = sht->use_clustering;
 	shost->ordered_tag = sht->ordered_tag;
+	/*
+	 * Set the default shost->cmd_serial_number to 1.
+	 */
+	atomic_set(&shost->cmd_serial_number, 1);
 
 	if (sht->supported_mode == MODE_UNKNOWN)
 		/* means we didn't set it ... default to INITIATOR */
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index ad0ed21..84dbe76 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -628,18 +628,22 @@ void scsi_log_completion(struct scsi_cmnd *cmd, int disposition)
 
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
 }
+EXPORT_SYMBOL(scsi_cmd_get_serial);
 
 /**
  * scsi_dispatch_command - Dispatch a command to the low-level driver.
@@ -651,7 +655,6 @@ static inline void scsi_cmd_get_serial(struct Scsi_Host *host, struct scsi_cmnd
 int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
 {
 	struct Scsi_Host *host = cmd->device->host;
-	unsigned long flags = 0;
 	unsigned long timeout;
 	int rtn = 0;
 
@@ -736,15 +739,11 @@ int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
 		scsi_done(cmd);
 		goto out;
 	}
-
-	spin_lock_irqsave(host->host_lock, flags);
 	/*
-	 * AK: unlikely race here: for some reason the timer could
-	 * expire before the serial number is set up below.
-	 *
-	 * TODO: kill serial or move to blk layer
+	 * Note that scsi_cmd_get_serial() used to be called here, but
+	 * now we expect the legacy SCSI LLDs that actually need this
+	 * to call it directly within their SHT->queuecommand() caller.
 	 */
-	scsi_cmd_get_serial(host, cmd); 
 
 	if (unlikely(host->shost_state == SHOST_DEL)) {
 		cmd->result = (DID_NO_CONNECT << 16);
@@ -753,7 +752,7 @@ int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
 		trace_scsi_dispatch_cmd_start(cmd);
 		rtn = host->hostt->queuecommand(cmd, scsi_done);
 	}
-	spin_unlock_irqrestore(host->host_lock, flags);
+
 	if (rtn) {
 		trace_scsi_dispatch_cmd_error(cmd, rtn);
 		if (rtn != SCSI_MLQUEUE_DEVICE_BUSY &&
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 1de30eb..34a4fce 100644
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
+	if (test_bit(REQ_ATOM_COMPLETE, &scmd->request->atomic_flags))
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
index b7bdecb..1b69511 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -602,10 +602,9 @@ struct Scsi_Host {
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
-- 
1.7.3

From: Paul Mackerras <paulus@samba.org>
Subject: [PATCH] update MESH scsi driver
Date: Sun, 23 Mar 2003 15:10:59 +1100 (EST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <15997.13267.498276.509580@nanango.paulus.ozlabs.org>
Reply-To: paulus@samba.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, torvalds@transmeta.com

This patch updates the `mesh' scsi driver used on older powermacs to
correspond with recent changes in the scsi subsystem (things like
using cmd->device->id instead of cmd->target).

Paul.

diff -urN linux-2.5/drivers/scsi/mesh.c linuxppc-2.5/drivers/scsi/mesh.c
--- linux-2.5/drivers/scsi/mesh.c	2002-10-23 06:53:01.000000000 +1000
+++ linuxppc-2.5/drivers/scsi/mesh.c	2003-02-09 16:38:15.000000000 +1100
@@ -80,7 +80,7 @@
 #define ALLOW_SYNC(tgt)		((sync_targets >> (tgt)) & 1)
 #define ALLOW_RESEL(tgt)	((resel_targets >> (tgt)) & 1)
 #define ALLOW_DEBUG(tgt)	((debug_targets >> (tgt)) & 1)
-#define DEBUG_TARGET(cmd)	((cmd) && ALLOW_DEBUG((cmd)->target))
+#define DEBUG_TARGET(cmd)	((cmd) && ALLOW_DEBUG((cmd)->device->id))
 
 #undef MESH_DBG
 #define N_DBG_LOG	50
@@ -465,7 +465,7 @@
 	cmd->scsi_done = done;
 	cmd->host_scribble = NULL;
 
-	ms = (struct mesh_state *) cmd->host->hostdata;
+	ms = (struct mesh_state *) cmd->device->host->hostdata;
 
 	if (ms->request_q == NULL)
 		ms->request_q = cmd;
@@ -486,15 +486,12 @@
 int
 mesh_abort(Scsi_Cmnd *cmd)
 {
-	struct mesh_state *ms = (struct mesh_state *) cmd->host->hostdata;
-	unsigned long flags;
+	struct mesh_state *ms = (struct mesh_state *) cmd->device->host->hostdata;
 
 	printk(KERN_DEBUG "mesh_abort(%p)\n", cmd);
-	spin_lock_irqsave(ms->host->host_lock, flags);
 	mesh_dump_regs(ms);
-	dumplog(ms, cmd->target);
+	dumplog(ms, cmd->device->id);
 	dumpslog(ms);
-	spin_unlock_irqrestore(ms->host->host_lock, flags);
 	return SCSI_ABORT_SNOOZE;
 }
 
@@ -540,7 +537,7 @@
 int
 mesh_host_reset(Scsi_Cmnd *cmd)
 {
-	struct mesh_state *ms = (struct mesh_state *) cmd->host->hostdata;
+	struct mesh_state *ms = (struct mesh_state *) cmd->device->host->hostdata;
 	volatile struct mesh_regs *mr = ms->mesh;
 	volatile struct dbdma_regs *md = ms->dma;
 
@@ -661,7 +658,7 @@
 		for (cmd = ms->request_q; ; cmd = (Scsi_Cmnd *) cmd->host_scribble) {
 			if (cmd == NULL)
 				return;
-			if (ms->tgts[cmd->target].current_req == NULL)
+			if (ms->tgts[cmd->device->id].current_req == NULL)
 				break;
 			prev = cmd;
 		}
@@ -681,17 +678,18 @@
 mesh_start_cmd(struct mesh_state *ms, Scsi_Cmnd *cmd)
 {
 	volatile struct mesh_regs *mr = ms->mesh;
-	int t;
+	int t, id;
 
+	id = cmd->device->id;
 	ms->current_req = cmd;
-	ms->tgts[cmd->target].data_goes_out = data_goes_out(cmd);
-	ms->tgts[cmd->target].current_req = cmd;
+	ms->tgts[id].data_goes_out = data_goes_out(cmd);
+	ms->tgts[id].current_req = cmd;
 
 #if 1
 	if (DEBUG_TARGET(cmd)) {
 		int i;
 		printk(KERN_DEBUG "mesh_start: %p ser=%lu tgt=%d cmd=",
-		       cmd, cmd->serial_number, cmd->target);
+		       cmd, cmd->serial_number, id);
 		for (i = 0; i < cmd->cmd_len; ++i)
 			printk(" %x", cmd->cmnd[i]);
 		printk(" use_sg=%d buffer=%p bufflen=%u\n",
@@ -708,12 +706,12 @@
 	ms->n_msgout = 0;
 	ms->last_n_msgout = 0;
 	ms->expect_reply = 0;
-	ms->conn_tgt = cmd->target;
-	ms->tgts[cmd->target].saved_ptr = 0;
+	ms->conn_tgt = id;
+	ms->tgts[id].saved_ptr = 0;
 	ms->stat = DID_OK;
 	ms->aborting = 0;
 #ifdef MESH_DBG
-	ms->tgts[cmd->target].n_log = 0;
+	ms->tgts[id].n_log = 0;
 	dlog(ms, "start cmd=%x", (int) cmd);
 #endif
 
@@ -1160,7 +1158,7 @@
 		case selecting:
 			dlog(ms, "Selecting phase at command completion",0);
 			ms->msgout[0] = IDENTIFY(ALLOW_RESEL(ms->conn_tgt),
-						 (cmd? cmd->lun: 0));
+						 (cmd? cmd->device->lun: 0));
 			ms->n_msgout = 1;
 			ms->expect_reply = 0;
 			if (ms->aborting) {
@@ -1331,7 +1329,7 @@
 			if (ms->request_q == NULL)
 				ms->request_qtail = cmd;
 			ms->request_q = cmd;
-			tp = &ms->tgts[cmd->target];
+			tp = &ms->tgts[cmd->device->id];
 			tp->current_req = NULL;
 		}
 		break;
@@ -1714,10 +1712,10 @@
 			if (cmd == NULL) {
 				do_abort(ms);
 				ms->msgphase = msg_out;
-			} else if (code != cmd->lun + IDENTIFY_BASE) {
+			} else if (code != cmd->device->lun + IDENTIFY_BASE) {
 				printk(KERN_WARNING "mesh: lun mismatch "
 				       "(%d != %d) on reselection from "
-				       "target %d\n", i, cmd->lun,
+				       "target %d\n", i, cmd->device->lun,
 				       ms->conn_tgt);
 			}
 			break;
@@ -1902,12 +1900,19 @@
 
 /*
  * Work out whether we expect data to go out from the host adaptor or into it.
- * (If this information is available from somewhere else in the scsi
- * code, somebody please let me know :-)
  */
 static int
 data_goes_out(Scsi_Cmnd *cmd)
 {
+	switch (cmd->sc_data_direction) {
+	case SCSI_DATA_WRITE:
+		return 1;
+	case SCSI_DATA_READ:
+		return 0;
+	}
+
+	/* for SCSI_DATA_UNKNOWN or SCSI_DATA_NONE, fall back on the
+	   old method for now... */
 	switch (cmd->cmnd[0]) {
 	case CHANGE_DEFINITION: 
 	case COMPARE:	  
@@ -2036,6 +2041,22 @@
 }
 #endif /* MESH_DBG */
 
-static Scsi_Host_Template driver_template = SCSI_MESH;
+static Scsi_Host_Template driver_template = {
+	.proc_name			= "mesh",
+	.name				= "MESH",
+	.detect				= mesh_detect,
+	.release			= mesh_release,
+	.command			= NULL,
+	.queuecommand			= mesh_queue,
+	.eh_abort_handler		= mesh_abort,
+	.eh_device_reset_handler	= NULL,
+	.eh_bus_reset_handler		= NULL,
+	.eh_host_reset_handler		= mesh_host_reset,
+	.can_queue			= 20,
+	.this_id			= 7,
+	.sg_tablesize			= SG_ALL,
+	.cmd_per_lun			= 2,
+	.use_clustering			= DISABLE_CLUSTERING,
+};
 
 #include "scsi_module.c"
diff -urN linux-2.5/drivers/scsi/mesh.h linuxppc-2.5/drivers/scsi/mesh.h
--- linux-2.5/drivers/scsi/mesh.h	2002-12-11 07:28:33.000000000 +1100
+++ linuxppc-2.5/drivers/scsi/mesh.h	2003-02-09 16:38:15.000000000 +1100
@@ -7,30 +7,6 @@
 #ifndef _MESH_H
 #define _MESH_H
 
-int mesh_detect(Scsi_Host_Template *);
-int mesh_release(struct Scsi_Host *);
-int mesh_queue(Scsi_Cmnd *, void (*done)(Scsi_Cmnd *));
-int mesh_abort(Scsi_Cmnd *);
-int mesh_host_reset(Scsi_Cmnd *);
-
-#define SCSI_MESH {						\
-	.proc_name			= "mesh",			\
-	.name				= "MESH",			\
-	.detect				= mesh_detect,		\
-	.release			= mesh_release,		\
-	.command			= NULL,			\
-	.queuecommand			= mesh_queue,		\
-	.eh_abort_handler		= mesh_abort,		\
-	.eh_device_reset_handler	= NULL,			\
-	.eh_bus_reset_handler		= NULL,			\
-	.eh_host_reset_handler		= mesh_host_reset,	\
-	.can_queue			= 20,			\
-	.this_id			= 7,			\
-	.sg_tablesize			= SG_ALL,			\
-	.cmd_per_lun			= 2,			\
-	.use_clustering			= DISABLE_CLUSTERING,	\
-}
-
 /*
  * Registers in the MESH controller.
  */

From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 4.3-rc4
Date: Sun, 11 Oct 2015 00:01:17 -0700
Message-ID: <1444546877.2200.17.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:56520 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750838AbbJKHBT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 11 Oct 2015 03:01:19 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

This is a set of three bug fixes, two of which are regressions from
recent updates (the 3ware one from 4.1 and the device handler fixes from
4.2).

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Ariel Nahum (1):
      libiscsi: Fix iscsi_check_transport_timeouts possible infinite loop

Christoph Hellwig (1):
      3w-9xxx: don't unmap bounce buffered commands

Paul Mackerras (1):
      scsi_dh: Use the correct module name when loading device handler

And the diffstat:

 drivers/scsi/3w-9xxx.c  | 28 +++++++++++++++++++++-------
 drivers/scsi/libiscsi.c | 17 +++++++++++------
 drivers/scsi/scsi_dh.c  |  2 +-
 3 files changed, 33 insertions(+), 14 deletions(-)

With full diffs below.

James

---

diff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
index add419d..a56a7b2 100644
--- a/drivers/scsi/3w-9xxx.c
+++ b/drivers/scsi/3w-9xxx.c
@@ -212,6 +212,17 @@ static const struct file_operations twa_fops = {
 	.llseek		= noop_llseek,
 };
 
+/*
+ * The controllers use an inline buffer instead of a mapped SGL for small,
+ * single entry buffers.  Note that we treat a zero-length transfer like
+ * a mapped SGL.
+ */
+static bool twa_command_mapped(struct scsi_cmnd *cmd)
+{
+	return scsi_sg_count(cmd) != 1 ||
+		scsi_bufflen(cmd) >= TW_MIN_SGL_LENGTH;
+}
+
 /* This function will complete an aen request from the isr */
 static int twa_aen_complete(TW_Device_Extension *tw_dev, int request_id)
 {
@@ -1339,7 +1350,8 @@ static irqreturn_t twa_interrupt(int irq, void *dev_instance)
 				}
 
 				/* Now complete the io */
-				scsi_dma_unmap(cmd);
+				if (twa_command_mapped(cmd))
+					scsi_dma_unmap(cmd);
 				cmd->scsi_done(cmd);
 				tw_dev->state[request_id] = TW_S_COMPLETED;
 				twa_free_request_id(tw_dev, request_id);
@@ -1582,7 +1594,8 @@ static int twa_reset_device_extension(TW_Device_Extension *tw_dev)
 				struct scsi_cmnd *cmd = tw_dev->srb[i];
 
 				cmd->result = (DID_RESET << 16);
-				scsi_dma_unmap(cmd);
+				if (twa_command_mapped(cmd))
+					scsi_dma_unmap(cmd);
 				cmd->scsi_done(cmd);
 			}
 		}
@@ -1765,12 +1778,14 @@ static int twa_scsi_queue_lck(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_
 	retval = twa_scsiop_execute_scsi(tw_dev, request_id, NULL, 0, NULL);
 	switch (retval) {
 	case SCSI_MLQUEUE_HOST_BUSY:
-		scsi_dma_unmap(SCpnt);
+		if (twa_command_mapped(SCpnt))
+			scsi_dma_unmap(SCpnt);
 		twa_free_request_id(tw_dev, request_id);
 		break;
 	case 1:
 		SCpnt->result = (DID_ERROR << 16);
-		scsi_dma_unmap(SCpnt);
+		if (twa_command_mapped(SCpnt))
+			scsi_dma_unmap(SCpnt);
 		done(SCpnt);
 		tw_dev->state[request_id] = TW_S_COMPLETED;
 		twa_free_request_id(tw_dev, request_id);
@@ -1831,8 +1846,7 @@ static int twa_scsiop_execute_scsi(TW_Device_Extension *tw_dev, int request_id,
 		/* Map sglist from scsi layer to cmd packet */
 
 		if (scsi_sg_count(srb)) {
-			if ((scsi_sg_count(srb) == 1) &&
-			    (scsi_bufflen(srb) < TW_MIN_SGL_LENGTH)) {
+			if (!twa_command_mapped(srb)) {
 				if (srb->sc_data_direction == DMA_TO_DEVICE ||
 				    srb->sc_data_direction == DMA_BIDIRECTIONAL)
 					scsi_sg_copy_to_buffer(srb,
@@ -1905,7 +1919,7 @@ static void twa_scsiop_execute_scsi_complete(TW_Device_Extension *tw_dev, int re
 {
 	struct scsi_cmnd *cmd = tw_dev->srb[request_id];
 
-	if (scsi_bufflen(cmd) < TW_MIN_SGL_LENGTH &&
+	if (!twa_command_mapped(cmd) &&
 	    (cmd->sc_data_direction == DMA_FROM_DEVICE ||
 	     cmd->sc_data_direction == DMA_BIDIRECTIONAL)) {
 		if (scsi_sg_count(cmd) == 1) {
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 33c74d3..6bffd91 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -976,13 +976,13 @@ static void iscsi_tmf_rsp(struct iscsi_conn *conn, struct iscsi_hdr *hdr)
 	wake_up(&conn->ehwait);
 }
 
-static void iscsi_send_nopout(struct iscsi_conn *conn, struct iscsi_nopin *rhdr)
+static int iscsi_send_nopout(struct iscsi_conn *conn, struct iscsi_nopin *rhdr)
 {
         struct iscsi_nopout hdr;
 	struct iscsi_task *task;
 
 	if (!rhdr && conn->ping_task)
-		return;
+		return -EINVAL;
 
 	memset(&hdr, 0, sizeof(struct iscsi_nopout));
 	hdr.opcode = ISCSI_OP_NOOP_OUT | ISCSI_OP_IMMEDIATE;
@@ -996,13 +996,16 @@ static void iscsi_send_nopout(struct iscsi_conn *conn, struct iscsi_nopin *rhdr)
 		hdr.ttt = RESERVED_ITT;
 
 	task = __iscsi_conn_send_pdu(conn, (struct iscsi_hdr *)&hdr, NULL, 0);
-	if (!task)
+	if (!task) {
 		iscsi_conn_printk(KERN_ERR, conn, "Could not send nopout\n");
-	else if (!rhdr) {
+		return -EIO;
+	} else if (!rhdr) {
 		/* only track our nops */
 		conn->ping_task = task;
 		conn->last_ping = jiffies;
 	}
+
+	return 0;
 }
 
 static int iscsi_nop_out_rsp(struct iscsi_task *task,
@@ -2092,8 +2095,10 @@ static void iscsi_check_transport_timeouts(unsigned long data)
 	if (time_before_eq(last_recv + recv_timeout, jiffies)) {
 		/* send a ping to try to provoke some traffic */
 		ISCSI_DBG_CONN(conn, "Sending nopout as ping\n");
-		iscsi_send_nopout(conn, NULL);
-		next_timeout = conn->last_ping + (conn->ping_timeout * HZ);
+		if (iscsi_send_nopout(conn, NULL))
+			next_timeout = jiffies + (1 * HZ);
+		else
+			next_timeout = conn->last_ping + (conn->ping_timeout * HZ);
 	} else
 		next_timeout = last_recv + recv_timeout;
 
diff --git a/drivers/scsi/scsi_dh.c b/drivers/scsi/scsi_dh.c
index edb044a..0a2168e 100644
--- a/drivers/scsi/scsi_dh.c
+++ b/drivers/scsi/scsi_dh.c
@@ -111,7 +111,7 @@ static struct scsi_device_handler *scsi_dh_lookup(const char *name)
 
 	dh = __scsi_dh_lookup(name);
 	if (!dh) {
-		request_module(name);
+		request_module("scsi_dh_%s", name);
 		dh = __scsi_dh_lookup(name);
 	}
 



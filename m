From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] firewire: sbp2: omit Scsi_Host lock from queuecommand
Date: Fri, 22 Apr 2011 12:21:44 +0200
Message-ID: <20110422122144.532ddbe3@stein>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:36859 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754196Ab1DVKVz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Apr 2011 06:21:55 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux1394-devel@lists.sourceforge.net
Cc: linux-scsi@vger.kernel.org

firewire-sbp2 already takes care for internal serialization where
required (ORB list accesses), and it does not use cmd->serial_number
internally.  Hence it is safe to not grab the shost lock around
queuecommand.

While we are at housekeeping, drop a redundant struct member:
sbp2_command_orb.done is set once in a hot path and dereferenced once in
a hot path.  We can as well dereference sbp2_command_orb.cmd->scsi_done
instead.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/sbp2.c |   20 ++++++--------------
 1 file changed, 6 insertions(+), 14 deletions(-)

Index: b/drivers/firewire/sbp2.c
===================================================================
--- a/drivers/firewire/sbp2.c
+++ b/drivers/firewire/sbp2.c
@@ -125,9 +125,6 @@ MODULE_PARM_DESC(workarounds, "Work arou
 	", override internal blacklist = " __stringify(SBP2_WORKAROUND_OVERRIDE)
 	", or a combination)");
 
-/* I don't know why the SCSI stack doesn't define something like this... */
-typedef void (*scsi_done_fn_t)(struct scsi_cmnd *);
-
 static const char sbp2_driver_name[] = "sbp2";
 
 /*
@@ -314,7 +311,6 @@ struct sbp2_command_orb {
 		u8 command_block[SBP2_MAX_CDB_SIZE];
 	} request;
 	struct scsi_cmnd *cmd;
-	scsi_done_fn_t done;
 	struct sbp2_logical_unit *lu;
 
 	struct sbp2_pointer page_table[SG_ALL] __attribute__((aligned(8)));
@@ -1398,7 +1394,7 @@ static void complete_command_orb(struct 
 	sbp2_unmap_scatterlist(device->card->device, orb);
 
 	orb->cmd->result = result;
-	orb->done(orb->cmd);
+	orb->cmd->scsi_done(orb->cmd);
 }
 
 static int sbp2_map_scatterlist(struct sbp2_command_orb *orb,
@@ -1463,7 +1459,8 @@ static int sbp2_map_scatterlist(struct s
 
 /* SCSI stack integration */
 
-static int sbp2_scsi_queuecommand_lck(struct scsi_cmnd *cmd, scsi_done_fn_t done)
+static int sbp2_scsi_queuecommand(struct Scsi_Host *shost,
+				  struct scsi_cmnd *cmd)
 {
 	struct sbp2_logical_unit *lu = cmd->device->hostdata;
 	struct fw_device *device = target_device(lu->tgt);
@@ -1477,7 +1474,7 @@ static int sbp2_scsi_queuecommand_lck(st
 	if (cmd->sc_data_direction == DMA_BIDIRECTIONAL) {
 		fw_error("Can't handle DMA_BIDIRECTIONAL, rejecting command\n");
 		cmd->result = DID_ERROR << 16;
-		done(cmd);
+		cmd->scsi_done(cmd);
 		return 0;
 	}
 
@@ -1490,11 +1487,8 @@ static int sbp2_scsi_queuecommand_lck(st
 	/* Initialize rcode to something not RCODE_COMPLETE. */
 	orb->base.rcode = -1;
 	kref_init(&orb->base.kref);
-
-	orb->lu   = lu;
-	orb->done = done;
-	orb->cmd  = cmd;
-
+	orb->lu = lu;
+	orb->cmd = cmd;
 	orb->request.next.high = cpu_to_be32(SBP2_ORB_NULL);
 	orb->request.misc = cpu_to_be32(
 		COMMAND_ORB_MAX_PAYLOAD(lu->tgt->max_payload) |
@@ -1529,8 +1523,6 @@ static int sbp2_scsi_queuecommand_lck(st
 	return retval;
 }
 
-static DEF_SCSI_QCMD(sbp2_scsi_queuecommand)
-
 static int sbp2_scsi_slave_alloc(struct scsi_device *sdev)
 {
 	struct sbp2_logical_unit *lu = sdev->hostdata;


-- 
Stefan Richter
-=====-==-== -=-- =-==-
http://arcgraph.de/sr/

From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH 11/13] hpsa: Convert SCSI LLD ->queuecommand() for host_lock
 less operation
Date: Fri, 14 Nov 2014 17:27:19 -0600
Message-ID: <20141114232719.20808.77460.stgit@don-ProLiant-MicroServer-Gen8>
References: <20141114231145.20808.76898.stgit@don-ProLiant-MicroServer-Gen8>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3427.houston.hp.com ([15.201.208.55]:46464 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422933AbaKNXZo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Nov 2014 18:25:44 -0500
In-Reply-To: <20141114231145.20808.76898.stgit@don-ProLiant-MicroServer-Gen8>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hch@infradead.org, webb.scales@hp.com, james.bottomley@parallels.com, brace@pmcs.com
Cc: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

There isn't anything in hpsa that requires the host lock to be held
during queuecommand.

Signed-off-by: Don Brace <don.brace@pmcs.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Reviewed-by: Stephen M. Cameron <stephenmcameron@gmail.com>
---
 drivers/scsi/hpsa.c |   16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 58f6847..761612d 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -3881,8 +3881,11 @@ static int hpsa_scsi_ioaccel_raid_map(struct ctlr_info *h,
 						dev->scsi3addr);
 }
 
-static int hpsa_scsi_queue_command_lck(struct scsi_cmnd *cmd,
-	void (*done)(struct scsi_cmnd *))
+/*
+ * Running in struct Scsi_Host->host_lock less mode using LLD internal
+ * struct ctlr_info *h->lock w/ spin_lock_irqsave() protection.
+ */
+static int hpsa_scsi_queue_command(struct Scsi_Host *sh, struct scsi_cmnd *cmd)
 {
 	struct ctlr_info *h;
 	struct hpsa_scsi_dev_t *dev;
@@ -3895,14 +3898,14 @@ static int hpsa_scsi_queue_command_lck(struct scsi_cmnd *cmd,
 	dev = cmd->device->hostdata;
 	if (!dev) {
 		cmd->result = DID_NO_CONNECT << 16;
-		done(cmd);
+		cmd->scsi_done(cmd);
 		return 0;
 	}
 	memcpy(scsi3addr, dev->scsi3addr, sizeof(scsi3addr));
 
 	if (unlikely(lockup_detected(h))) {
 		cmd->result = DID_ERROR << 16;
-		done(cmd);
+		cmd->scsi_done(cmd);
 		return 0;
 	}
 	c = cmd_alloc(h);
@@ -3912,9 +3915,6 @@ static int hpsa_scsi_queue_command_lck(struct scsi_cmnd *cmd,
 	}
 
 	/* Fill in the command list header */
-
-	cmd->scsi_done = done;    /* save this for use by completion code */
-
 	/* save c in case we have to abort it  */
 	cmd->host_scribble = (unsigned char *) c;
 
@@ -4005,8 +4005,6 @@ static int hpsa_scsi_queue_command_lck(struct scsi_cmnd *cmd,
 	return 0;
 }
 
-static DEF_SCSI_QCMD(hpsa_scsi_queue_command)
-
 static int do_not_scan_if_controller_locked_up(struct ctlr_info *h)
 {
 	unsigned long flags;


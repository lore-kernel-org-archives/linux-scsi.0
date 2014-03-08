From: Arvind Kumar <arvindkumar@vmware.com>
Subject: [PATCH 1/3] VMW_PVSCSI: Fix pvscsi_abort() function.
Date: Sat, 08 Mar 2014 12:51:12 -0800
Message-ID: <1394311872.8462.20.camel@arvindkumar-dev1.eng.vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-outbound-1.vmware.com ([208.91.2.12]:60040 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751639AbaCHU6g (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 8 Mar 2014 15:58:36 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com, linux-scsi@vger.kernel.org
Cc: emilne@redhat.com, pv-drivers@vmware.com

This change ensures that pvscsi_abort() function returns SUCCESS
only when the command in question was actually completed, otherwise
returns FAILURE. The code before change, was causing a bug where
driver tries to complete a command to the mid-layer while the mid-layer
has already requested the driver to abort that command, in response
to which the driver has responded with SUCCESS causing mid-layer
to free the command struct.

Signed-off-by: Arvind Kumar <arvindkumar@vmware.com>
Cc: Ewan Milne <emilne@redhat.com>
---
 drivers/scsi/vmw_pvscsi.c |   51 +++++++++++++++++++++++++++++++++++++++++----
 drivers/scsi/vmw_pvscsi.h |    4 ++--
 2 files changed, 49 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/vmw_pvscsi.c b/drivers/scsi/vmw_pvscsi.c
index b9755ec..7c5abd7 100644
--- a/drivers/scsi/vmw_pvscsi.c
+++ b/drivers/scsi/vmw_pvscsi.c
@@ -1,7 +1,7 @@
 /*
  * Linux driver for VMware's para-virtualized SCSI HBA.
  *
- * Copyright (C) 2008-2009, VMware, Inc. All Rights Reserved.
+ * Copyright (C) 2008-2014, VMware, Inc. All Rights Reserved.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License as published by the
@@ -62,6 +62,7 @@ struct pvscsi_ctx {
 	dma_addr_t		dataPA;
 	dma_addr_t		sensePA;
 	dma_addr_t		sglPA;
+	struct completion	*abort_cmp;
 };
 
 struct pvscsi_adapter {
@@ -177,6 +178,7 @@ static void pvscsi_release_context(struct pvscsi_adapter *adapter,
 				   struct pvscsi_ctx *ctx)
 {
 	ctx->cmd = NULL;
+	ctx->abort_cmp = NULL;
 	list_add(&ctx->list, &adapter->cmd_pool);
 }
 
@@ -496,15 +498,27 @@ static void pvscsi_complete_request(struct pvscsi_adapter *adapter,
 {
 	struct pvscsi_ctx *ctx;
 	struct scsi_cmnd *cmd;
+	struct completion *abort_cmp;
 	u32 btstat = e->hostStatus;
 	u32 sdstat = e->scsiStatus;
 
 	ctx = pvscsi_get_context(adapter, e->context);
 	cmd = ctx->cmd;
+	abort_cmp = ctx->abort_cmp;
 	pvscsi_unmap_buffers(adapter, ctx);
 	pvscsi_release_context(adapter, ctx);
-	cmd->result = 0;
+	if (abort_cmp) {
+		/*
+		 * The command was requested to be aborted. Just signal that
+		 * the request completed and swallow the actual cmd completion
+		 * here. The abort handler will post a completion for this
+		 * command indicating that it got successfully aborted.
+		 */
+		complete(abort_cmp);
+		return;
+	}
 
+	cmd->result = 0;
 	if (sdstat != SAM_STAT_GOOD &&
 	    (btstat == BTSTAT_SUCCESS ||
 	     btstat == BTSTAT_LINKED_COMMAND_COMPLETED ||
@@ -726,6 +740,8 @@ static int pvscsi_abort(struct scsi_cmnd *cmd)
 	struct pvscsi_adapter *adapter = shost_priv(cmd->device->host);
 	struct pvscsi_ctx *ctx;
 	unsigned long flags;
+	int result = SUCCESS;
+	DECLARE_COMPLETION_ONSTACK(abort_cmp);
 
 	scmd_printk(KERN_DEBUG, cmd, "task abort on host %u, %p\n",
 		    adapter->host->host_no, cmd);
@@ -748,13 +764,40 @@ static int pvscsi_abort(struct scsi_cmnd *cmd)
 		goto out;
 	}
 
+	/*
+	 * Mark that the command has been requested to be aborted and issue
+	 * the abort.
+	 */
+	ctx->abort_cmp = &abort_cmp;
+
 	pvscsi_abort_cmd(adapter, ctx);
+	spin_unlock_irqrestore(&adapter->hw_lock, flags);
+	/* Wait for 2 secs for the completion. */
+	wait_for_completion_timeout(&abort_cmp, msecs_to_jiffies(2000));
+	spin_lock_irqsave(&adapter->hw_lock, flags);
 
-	pvscsi_process_completion_ring(adapter);
+	if (!completion_done(&abort_cmp)) {
+		/*
+		 * Failed to abort the command, unmark the fact that it
+		 * was requested to be aborted.
+		 */
+		ctx->abort_cmp = NULL;
+		result = FAILED;
+		scmd_printk(KERN_DEBUG, cmd,
+			    "Failed to get completion for aborted cmd %p\n",
+			    cmd);
+		goto out;
+	}
+
+	/*
+	 * Successfully aborted the command.
+	 */
+	cmd->result = (DID_ABORT << 16);
+	cmd->scsi_done(cmd);
 
 out:
 	spin_unlock_irqrestore(&adapter->hw_lock, flags);
-	return SUCCESS;
+	return result;
 }
 
 /*
diff --git a/drivers/scsi/vmw_pvscsi.h b/drivers/scsi/vmw_pvscsi.h
index 3546e86..a643775 100644
--- a/drivers/scsi/vmw_pvscsi.h
+++ b/drivers/scsi/vmw_pvscsi.h
@@ -1,7 +1,7 @@
 /*
  * VMware PVSCSI header file
  *
- * Copyright (C) 2008-2009, VMware, Inc. All Rights Reserved.
+ * Copyright (C) 2008-2014, VMware, Inc. All Rights Reserved.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License as published by the
@@ -26,7 +26,7 @@
 
 #include <linux/types.h>
 
-#define PVSCSI_DRIVER_VERSION_STRING   "1.0.2.0-k"
+#define PVSCSI_DRIVER_VERSION_STRING   "1.0.3.0-k"
 
 #define PVSCSI_MAX_NUM_SG_ENTRIES_PER_SEGMENT 128
 
-- 
1.7.9.5




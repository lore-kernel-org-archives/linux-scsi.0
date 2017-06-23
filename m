From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 19/35] aacraid: split off lun reset function
Date: Fri, 23 Jun 2017 15:02:39 +0200
Message-ID: <1498222975-71858-20-git-send-email-hare@suse.de>
References: <1498222975-71858-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:32835 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754178AbdFWND2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 23 Jun 2017 09:03:28 -0400
In-Reply-To: <1498222975-71858-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

The current host reset function does both, a LUN reset over all
LUNs followed by a host reset.
So split them off into individual functions.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/aacraid/linit.c | 70 ++++++++++++++++++++++++++------------------
 1 file changed, 41 insertions(+), 29 deletions(-)

diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 0f277df..bbacbf2 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -815,11 +815,11 @@ static int aac_eh_abort(struct scsi_cmnd* cmd)
 }
 
 /*
- *	aac_eh_reset	- Reset command handling
+ *	aac_eh_lun_reset	- LUN reset handling
  *	@scsi_cmd:	SCSI command block causing the reset
  *
  */
-static int aac_eh_reset(struct scsi_cmnd* cmd)
+static int aac_eh_lun_reset(struct scsi_cmnd * cmd)
 {
 	struct scsi_device * dev = cmd->device;
 	struct Scsi_Host * host = dev->host;
@@ -827,12 +827,6 @@ static int aac_eh_reset(struct scsi_cmnd* cmd)
 	int count;
 	u32 bus, cid;
 	int ret = FAILED;
-	int status = 0;
-	__le32 supported_options2 = 0;
-	bool is_mu_reset;
-	bool is_ignore_reset;
-	bool is_doorbell_reset;
-
 
 	bus = aac_logical_to_phys(scmd_channel(cmd));
 	cid = scmd_id(cmd);
@@ -904,26 +898,44 @@ static int aac_eh_reset(struct scsi_cmnd* cmd)
 			}
 			msleep(1000);
 		}
+		return ret;
+	}
 
-		if (ret == SUCCESS)
-			goto out;
-
-	} else {
-
-		/* Mark the assoc. FIB to not complete, eh handler does this */
-		for (count = 0;
-			count < (host->can_queue + AAC_NUM_MGT_FIB);
-			++count) {
-			struct fib *fib = &aac->fibs[count];
-
-			if (fib->hw_fib_va->header.XferState &&
-				(fib->flags & FIB_CONTEXT_FLAG) &&
-				(fib->callback_data == cmd)) {
-				fib->flags |= FIB_CONTEXT_FLAG_TIMED_OUT;
-				cmd->SCp.phase = AAC_OWNER_ERROR_HANDLER;
-			}
+	/* Mark the assoc. FIB to not complete, eh handler does this */
+	for (count = 0; count < (host->can_queue + AAC_NUM_MGT_FIB);
+	     ++count) {
+		struct fib *fib = &aac->fibs[count];
+
+		if (fib->hw_fib_va->header.XferState &&
+		    (fib->flags & FIB_CONTEXT_FLAG) &&
+		    fib->callback_data) {
+			fib->flags |= FIB_CONTEXT_FLAG_TIMED_OUT;
+			cmd = fib->callback_data;
+			cmd->SCp.phase = AAC_OWNER_ERROR_HANDLER;
+			ret = SUCCESS;
 		}
 	}
+	return ret;
+}
+
+/*
+ *	aac_eh_reset	- Reset command handling
+ *	@scsi_cmd:	SCSI command block causing the reset
+ *
+ */
+static int aac_eh_reset(struct scsi_cmnd* cmd)
+{
+	struct scsi_device * dev = cmd->device;
+	struct Scsi_Host * host = dev->host;
+	struct aac_dev * aac = (struct aac_dev *)host->hostdata;
+	int status = 0;
+	int count;
+	__le32 supported_options2 = 0;
+	bool is_mu_reset;
+	bool is_ignore_reset;
+	bool is_doorbell_reset;
+	int ret = FAILED;
+
 
 	pr_err("%s: Host adapter reset request. SCSI hang ?\n", AAC_DRIVERNAME);
 
@@ -954,11 +966,9 @@ static int aac_eh_reset(struct scsi_cmnd* cmd)
 	 && aac_check_reset
 	 && (aac_check_reset != -1 || !is_ignore_reset)) {
 		/* Bypass wait for command quiesce */
-		aac_reset_adapter(aac, 2, IOP_HWSOFT_RESET);
+		if (aac_reset_adapter(aac, 2, IOP_HWSOFT_RESET) == 0)
+			ret = SUCCESS;
 	}
-	ret = SUCCESS;
-
-out:
 	return ret;
 }
 
@@ -1382,6 +1392,7 @@ ssize_t aac_get_serial_number(struct device *device, char *buf)
 	.change_queue_depth		= aac_change_queue_depth,
 	.sdev_attrs			= aac_dev_attrs,
 	.eh_abort_handler		= aac_eh_abort,
+	.eh_device_reset_handler	= aac_eh_lun_reset,
 	.eh_host_reset_handler		= aac_eh_reset,
 	.can_queue			= AAC_NUM_IO_FIB,
 	.this_id			= MAXIMUM_NUM_CONTAINERS,
@@ -1807,6 +1818,7 @@ static void aac_flush_ios(struct aac_dev *aac)
 	for (i = 0; i < aac->scsi_host_ptr->can_queue; i++) {
 		cmd = (struct scsi_cmnd *)aac->fibs[i].callback_data;
 		if (cmd && (cmd->SCp.phase == AAC_OWNER_FIRMWARE)) {
+			aac->fibs[i].callback_data = NULL;
 			scsi_dma_unmap(cmd);
 
 			if (aac->handle_pci_error)
-- 
1.8.5.6

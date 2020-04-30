Return-Path: <SRS0=Cu6i=6O=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3B1BC8300D
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Apr 2020 13:20:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B75ED2076D
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Apr 2020 13:20:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726950AbgD3NUK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Apr 2020 09:20:10 -0400
Received: from mx2.suse.de ([195.135.220.15]:60754 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726683AbgD3NUG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 30 Apr 2020 09:20:06 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 2624CAF17;
        Thu, 30 Apr 2020 13:20:02 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        John Garry <john.garry@huawei.com>,
        Ming Lei <ming.lei@redhat.com>,
        Bart van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH RFC v3 16/41] aacraid: use scsi_host_busy_iter() to traverse commands
Date:   Thu, 30 Apr 2020 15:18:39 +0200
Message-Id: <20200430131904.5847-17-hare@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200430131904.5847-1-hare@suse.de>
References: <20200430131904.5847-1-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Now that the block layer manages all commands we can use
scsi_host_busy_iter() to traverse outstanding commands.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/aacraid/linit.c | 137 ++++++++++++++++++++-----------------------
 1 file changed, 62 insertions(+), 75 deletions(-)

diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 91a4780d9815..e3f8eac6cebe 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -680,7 +680,7 @@ static int aac_eh_abort(struct scsi_cmnd* cmd)
 	struct scsi_device * dev = cmd->device;
 	struct Scsi_Host * host = dev->host;
 	struct aac_dev * aac = (struct aac_dev *)host->hostdata;
-	int count, found;
+	int count;
 	u32 bus, cid;
 	int ret = FAILED;
 
@@ -699,17 +699,13 @@ static int aac_eh_abort(struct scsi_cmnd* cmd)
 		 AAC_DRIVERNAME,
 		 host->host_no, sdev_channel(dev), sdev_id(dev), (int)dev->lun);
 
-		found = 0;
-		for (count = 0; count < host->can_queue; ++count) {
-			fib = &aac->fibs[count];
-			if (*(u8 *)fib->hw_fib_va != 0 &&
-				(fib->flags & FIB_CONTEXT_FLAG_NATIVE_HBA) &&
-				(fib->callback_data == cmd)) {
-				found = 1;
-				break;
-			}
-		}
-		if (!found)
+		if (cmd->request->tag >= host->can_queue)
+			return ret;
+
+		fib = &aac->fibs[cmd->request->tag];
+		if (*(u8 *)fib->hw_fib_va == 0 ||
+		    !(fib->flags & FIB_CONTEXT_FLAG_NATIVE_HBA) ||
+		    (fib->callback_data != cmd))
 			return ret;
 
 		/* start a HBA_TMF_ABORT_TASK TMF request */
@@ -767,12 +763,13 @@ static int aac_eh_abort(struct scsi_cmnd* cmd)
 			/* fall through */
 		case INQUIRY:
 		case READ_CAPACITY:
+		case TEST_UNIT_READY:
 			/*
 			 * Mark associated FIB to not complete,
 			 * eh handler does this
 			 */
-			for (count = 0; count < host->can_queue; ++count) {
-				struct fib *fib = &aac->fibs[count];
+			if (cmd->request->tag < host->can_queue) {
+				struct fib *fib = &aac->fibs[cmd->request->tag];
 
 				if (fib->hw_fib_va->header.XferState &&
 				(fib->flags & FIB_CONTEXT_FLAG) &&
@@ -785,32 +782,6 @@ static int aac_eh_abort(struct scsi_cmnd* cmd)
 				}
 			}
 			break;
-		case TEST_UNIT_READY:
-			/*
-			 * Mark associated FIB to not complete,
-			 * eh handler does this
-			 */
-			for (count = 0; count < host->can_queue; ++count) {
-				struct scsi_cmnd *command;
-				struct fib *fib = &aac->fibs[count];
-
-				command = fib->callback_data;
-
-				if ((fib->hw_fib_va->header.XferState &
-					cpu_to_le32
-					(Async | NoResponseExpected)) &&
-					(fib->flags & FIB_CONTEXT_FLAG) &&
-					((command)) &&
-					(command->device == cmd->device)) {
-					fib->flags |=
-						FIB_CONTEXT_FLAG_TIMED_OUT;
-					command->SCp.phase =
-						AAC_OWNER_ERROR_HANDLER;
-					if (command == cmd)
-						ret = SUCCESS;
-				}
-			}
-			break;
 		}
 	}
 	return ret;
@@ -1016,6 +987,36 @@ static int aac_eh_target_reset(struct scsi_cmnd *cmd)
 	return ret;
 }
 
+struct aac_abort_fibs_iter_data {
+	struct aac_dev *aac;
+	u32 bus;
+};
+
+static bool aac_abort_fibs_iter(struct scsi_cmnd *scmd, void *data, bool rsvd)
+{
+	struct aac_abort_fibs_iter_data *iter_data = data;
+	struct aac_dev *aac = iter_data->aac;
+	struct fib *fib = &aac->fibs[scmd->request->tag];
+
+	if (fib->hw_fib_va->header.XferState &&
+	    (fib->flags & FIB_CONTEXT_FLAG) &&
+	    (fib->flags & FIB_CONTEXT_FLAG_SCSI_CMD)) {
+		struct aac_hba_map_info *info;
+		u32 bus, cid;
+
+		bus = aac_logical_to_phys(scmd_channel(scmd));
+		if (bus != iter_data->bus)
+			return true;
+		cid = scmd_id(scmd);
+		info = &aac->hba_map[bus][cid];
+		if (bus >= AAC_MAX_BUSES || cid >= AAC_MAX_TARGETS ||
+		    info->devtype != AAC_DEVTYPE_NATIVE_RAW) {
+			fib->flags |= FIB_CONTEXT_FLAG_EH_RESET;
+			scmd->SCp.phase = AAC_OWNER_ERROR_HANDLER;
+		}
+	}
+	return true;
+}
 /*
  *	aac_eh_bus_reset	- Bus reset command handling
  *	@scsi_cmd:	SCSI command block causing the reset
@@ -1027,34 +1028,13 @@ static int aac_eh_bus_reset(struct scsi_cmnd* cmd)
 	struct Scsi_Host * host = dev->host;
 	struct aac_dev * aac = (struct aac_dev *)host->hostdata;
 	int count;
-	u32 cmd_bus;
 	int status = 0;
+	struct aac_abort_fibs_iter_data data = {
+		.aac = aac,
+		.bus = aac_logical_to_phys(scmd_channel(cmd)),
+	};
 
-
-	cmd_bus = aac_logical_to_phys(scmd_channel(cmd));
-	/* Mark the assoc. FIB to not complete, eh handler does this */
-	for (count = 0; count < host->can_queue; ++count) {
-		struct fib *fib = &aac->fibs[count];
-
-		if (fib->hw_fib_va->header.XferState &&
-		    (fib->flags & FIB_CONTEXT_FLAG) &&
-		    (fib->flags & FIB_CONTEXT_FLAG_SCSI_CMD)) {
-			struct aac_hba_map_info *info;
-			u32 bus, cid;
-
-			cmd = (struct scsi_cmnd *)fib->callback_data;
-			bus = aac_logical_to_phys(scmd_channel(cmd));
-			if (bus != cmd_bus)
-				continue;
-			cid = scmd_id(cmd);
-			info = &aac->hba_map[bus][cid];
-			if (bus >= AAC_MAX_BUSES || cid >= AAC_MAX_TARGETS ||
-			    info->devtype != AAC_DEVTYPE_NATIVE_RAW) {
-				fib->flags |= FIB_CONTEXT_FLAG_EH_RESET;
-				cmd->SCp.phase = AAC_OWNER_ERROR_HANDLER;
-			}
-		}
-	}
+	scsi_host_busy_iter(host, aac_abort_fibs_iter, &data);
 
 	pr_err("%s: Host bus reset request. SCSI hang ?\n", AAC_DRIVERNAME);
 
@@ -1558,23 +1538,28 @@ static struct scsi_host_template aac_driver_template = {
 	.no_write_same			= 1,
 };
 
-static void __aac_shutdown(struct aac_dev * aac)
+static bool __aac_shutdown_iter(struct scsi_cmnd *scmd, void *data, bool rsvd)
 {
-	int i;
+	struct aac_dev *aac = data;
+	struct fib *fib = &aac->fibs[scmd->request->tag];
+
+	if (!(fib->hw_fib_va->header.XferState &
+	      cpu_to_le32(NoResponseExpected | Async)) &&
+	    (fib->hw_fib_va->header.XferState & cpu_to_le32(ResponseExpected)))
+		complete(&fib->event_wait);
+	return true;
+}
 
+static void __aac_shutdown(struct aac_dev * aac)
+{
 	mutex_lock(&aac->ioctl_mutex);
 	aac->adapter_shutdown = 1;
 	mutex_unlock(&aac->ioctl_mutex);
 
 	if (aac->aif_thread) {
-		int i;
 		/* Clear out events first */
-		for (i = 0; i < aac->scsi_host_ptr->can_queue; i++) {
-			struct fib *fib = &aac->fibs[i];
-			if (!(fib->hw_fib_va->header.XferState & cpu_to_le32(NoResponseExpected | Async)) &&
-			    (fib->hw_fib_va->header.XferState & cpu_to_le32(ResponseExpected)))
-				complete(&fib->event_wait);
-		}
+		scsi_host_busy_iter(aac->scsi_host_ptr,
+				    __aac_shutdown_iter, aac);
 		kthread_stop(aac->thread);
 		aac->thread = NULL;
 	}
@@ -1585,6 +1570,8 @@ static void __aac_shutdown(struct aac_dev * aac)
 
 	if (aac_is_src(aac)) {
 		if (aac->max_msix > 1) {
+			int i;
+
 			for (i = 0; i < aac->max_msix; i++) {
 				free_irq(pci_irq_vector(aac->pdev, i),
 					 &(aac->aac_msix[i]));
-- 
2.16.4


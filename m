Return-Path: <SRS0=Pfrg=43=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93D91C18E7A
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Mar 2020 16:31:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6A94820727
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Mar 2020 16:31:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727490AbgCJQbR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Mar 2020 12:31:17 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:11209 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726395AbgCJQbO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 10 Mar 2020 12:31:14 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 79EE8A4BAEFAA9321605;
        Wed, 11 Mar 2020 00:30:38 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.487.0; Wed, 11 Mar 2020 00:30:30 +0800
From:   John Garry <john.garry@huawei.com>
To:     <axboe@kernel.dk>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <hare@suse.de>,
        <ming.lei@redhat.com>, <bvanassche@acm.org>, <hch@infradead.org>
CC:     <linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        <esc.storagedev@microsemi.com>, <chenxiang66@hisilicon.com>,
        Hannes Reinecke <hare@suse.com>
Subject: [PATCH RFC v2 20/24] aacraid: use scsi_host_tagset_busy_iter() to traverse outstanding commands
Date:   Wed, 11 Mar 2020 00:25:46 +0800
Message-ID: <1583857550-12049-21-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1583857550-12049-1-git-send-email-john.garry@huawei.com>
References: <1583857550-12049-1-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Hannes Reinecke <hare@suse.de>

Instead of walking the array of potential commands and trying to figure out
which one might be pending the driver should be using
scsi_host_tagset_busy_iter() to traverse all outstanding commands.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/aacraid/commsup.c |  49 +++++----
 drivers/scsi/aacraid/linit.c   | 188 ++++++++++++++++++++-------------
 2 files changed, 142 insertions(+), 95 deletions(-)

diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
index c0c2c87c4ae3..5e82f4741d82 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -1459,6 +1459,32 @@ static void aac_schedule_bus_scan(struct aac_dev *aac)
 		aac_schedule_src_reinit_aif_worker(aac);
 }
 
+static bool aac_close_sync_fib_iter(struct scsi_cmnd *command, void *data,
+				    bool reserved)
+{
+	struct Scsi_Host *host = command->device->host;
+	struct aac_dev *aac = (struct aac_dev *)host->hostdata;
+	struct fib *fib = &aac->fibs[command->request->tag];
+	int *retval = data;
+	__le32 XferState = fib->hw_fib_va->header.XferState;
+	bool is_response_expected = false;
+
+	if (!(XferState & cpu_to_le32(NoResponseExpected | Async)) &&
+	    (XferState & cpu_to_le32(ResponseExpected)))
+		is_response_expected = true;
+
+	if (is_response_expected
+	    || fib->flags & FIB_CONTEXT_FLAG_WAIT) {
+		unsigned long flagv;
+		spin_lock_irqsave(&fib->event_lock, flagv);
+		complete(&fib->event_wait);
+		spin_unlock_irqrestore(&fib->event_lock, flagv);
+		schedule();
+		*retval = 0;
+	}
+	return true;
+}
+
 static bool aac_reset_adapter_iter(struct scsi_cmnd *command, void *data,
 				   bool reserved)
 {
@@ -1482,7 +1508,6 @@ static int _aac_reset_adapter(struct aac_dev *aac, int forced, u8 reset_type)
 	int jafo = 0;
 	int bled;
 	u64 dmamask;
-	int num_of_fibs = 0;
 
 	/*
 	 * Assumptions:
@@ -1518,27 +1543,7 @@ static int _aac_reset_adapter(struct aac_dev *aac, int forced, u8 reset_type)
 	 *	Loop through the fibs, close the synchronous FIBS
 	 */
 	retval = 1;
-	num_of_fibs = aac->scsi_host_ptr->can_queue + AAC_NUM_MGT_FIB;
-	for (index = 0; index <  num_of_fibs; index++) {
-
-		struct fib *fib = &aac->fibs[index];
-		__le32 XferState = fib->hw_fib_va->header.XferState;
-		bool is_response_expected = false;
-
-		if (!(XferState & cpu_to_le32(NoResponseExpected | Async)) &&
-		   (XferState & cpu_to_le32(ResponseExpected)))
-			is_response_expected = true;
-
-		if (is_response_expected
-		  || fib->flags & FIB_CONTEXT_FLAG_WAIT) {
-			unsigned long flagv;
-			spin_lock_irqsave(&fib->event_lock, flagv);
-			complete(&fib->event_wait);
-			spin_unlock_irqrestore(&fib->event_lock, flagv);
-			schedule();
-			retval = 0;
-		}
-	}
+	scsi_host_tagset_busy_iter(host, aac_close_sync_fib_iter, &retval);
 	/* Give some extra time for ioctls to complete. */
 	if (retval == 0)
 		ssleep(2);
diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 2da2f3bfcdc1..457bf342aa82 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -681,14 +681,87 @@ static int get_num_of_incomplete_fibs(struct aac_dev *aac)
 	return iter_data.mlcnt + iter_data.llcnt + iter_data.ehcnt + iter_data.fwcnt;
 }
 
+struct aac_eh_abort_iter_data {
+	struct aac_dev *aac;
+	struct scsi_cmnd *cmd;
+	int ret;
+};
+
+static bool aac_eh_abort_busy_iter(struct scsi_cmnd *cmd, void *data,
+				   bool reserved)
+{
+	struct aac_eh_abort_iter_data *iter_data = data;
+	struct aac_dev *aac = iter_data->aac;
+	struct fib *fib = &aac->fibs[cmd->request->tag];
+
+	if (cmd != iter_data->cmd)
+		return true;
+
+	if (*(u8 *)fib->hw_fib_va != 0 &&
+	    (fib->flags & FIB_CONTEXT_FLAG_NATIVE_HBA) &&
+	    (fib->callback_data == cmd)) {
+		iter_data->ret = SUCCESS;
+		return false;
+	}
+	return true;
+}
+
+static bool aac_eh_abort_cmd_iter(struct scsi_cmnd *cmd, void *data,
+				  bool reserved)
+{
+	struct aac_eh_abort_iter_data *iter_data = data;
+	struct fib *fib = &iter_data->aac->fibs[cmd->request->tag];
+
+	if (cmd != iter_data->cmd)
+		return true;
+
+	if (fib->hw_fib_va->header.XferState &&
+	    (fib->flags & FIB_CONTEXT_FLAG) &&
+	    (fib->callback_data == iter_data->cmd)) {
+		fib->flags |= FIB_CONTEXT_FLAG_TIMED_OUT;
+		cmd->SCp.phase = AAC_OWNER_ERROR_HANDLER;
+		iter_data->ret = SUCCESS;
+	}
+	return true;
+}
+
+static bool aac_eh_abort_tur_iter(struct scsi_cmnd *cmd, void *data,
+				  bool reserved)
+{
+	struct aac_eh_abort_iter_data *iter_data = data;
+	struct fib *fib = &iter_data->aac->fibs[cmd->request->tag];
+	struct scsi_cmnd *command;
+
+	if (cmd != iter_data->cmd)
+		return true;
+
+	command = fib->callback_data;
+	if ((fib->hw_fib_va->header.XferState &
+	     cpu_to_le32(Async | NoResponseExpected)) &&
+	    (fib->flags & FIB_CONTEXT_FLAG) &&
+	    ((command)) && (command->device == cmd->device)) {
+		fib->flags |= FIB_CONTEXT_FLAG_TIMED_OUT;
+		command->SCp.phase = AAC_OWNER_ERROR_HANDLER;
+		if (command == cmd)
+			iter_data->ret = SUCCESS;
+	}
+	return true;
+}
+
 static int aac_eh_abort(struct scsi_cmnd* cmd)
 {
 	struct scsi_device * dev = cmd->device;
 	struct Scsi_Host * host = dev->host;
 	struct aac_dev * aac = (struct aac_dev *)host->hostdata;
-	int count, found;
+	int count;
 	u32 bus, cid;
 	int ret = FAILED;
+	struct aac_eh_abort_iter_data iter_data = {
+		.aac = aac,
+		.cmd = cmd,
+		.ret = FAILED,
+	};
+
 
 	if (aac_adapter_check_health(aac))
 		return ret;
@@ -705,17 +778,9 @@ static int aac_eh_abort(struct scsi_cmnd* cmd)
 		 AAC_DRIVERNAME,
 		 host->host_no, sdev_channel(dev), sdev_id(dev), (int)dev->lun);
 
-		found = 0;
-		for (count = 0; count < (host->can_queue + AAC_NUM_MGT_FIB); ++count) {
-			fib = &aac->fibs[count];
-			if (*(u8 *)fib->hw_fib_va != 0 &&
-				(fib->flags & FIB_CONTEXT_FLAG_NATIVE_HBA) &&
-				(fib->callback_data == cmd)) {
-				found = 1;
-				break;
-			}
-		}
-		if (!found)
+		scsi_host_tagset_busy_iter(host, aac_eh_abort_busy_iter,
+					   &iter_data);
+		if (iter_data.ret == FAILED)
 			return ret;
 
 		/* start a HBA_TMF_ABORT_TASK TMF request */
@@ -773,49 +838,18 @@ static int aac_eh_abort(struct scsi_cmnd* cmd)
 			 * Mark associated FIB to not complete,
 			 * eh handler does this
 			 */
-			for (count = 0;
-				count < (host->can_queue + AAC_NUM_MGT_FIB);
-				++count) {
-				struct fib *fib = &aac->fibs[count];
-
-				if (fib->hw_fib_va->header.XferState &&
-				(fib->flags & FIB_CONTEXT_FLAG) &&
-				(fib->callback_data == cmd)) {
-					fib->flags |=
-						FIB_CONTEXT_FLAG_TIMED_OUT;
-					cmd->SCp.phase =
-						AAC_OWNER_ERROR_HANDLER;
-					ret = SUCCESS;
-				}
-			}
+			scsi_host_tagset_busy_iter(host, aac_eh_abort_cmd_iter,
+						   &iter_data);
+			ret = iter_data.ret;
 			break;
 		case TEST_UNIT_READY:
 			/*
 			 * Mark associated FIB to not complete,
 			 * eh handler does this
 			 */
-			for (count = 0;
-				count < (host->can_queue + AAC_NUM_MGT_FIB);
-				++count) {
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
+			scsi_host_tagset_busy_iter(host, aac_eh_abort_tur_iter,
+						   &iter_data);
+			ret = iter_data.ret;
 			break;
 		}
 	}
@@ -1010,6 +1044,36 @@ static int aac_eh_target_reset(struct scsi_cmnd *cmd)
 	return ret;
 }
 
+static bool aac_eh_bus_reset_iter(struct scsi_cmnd *cmd, void *data,
+				  bool reserved)
+{
+	struct Scsi_Host *host = cmd->device->host;
+	struct aac_dev *aac = (struct aac_dev *)host->hostdata;
+	struct fib *fib = &aac->fibs[cmd->request->tag];
+	int *cmd_bus = data;
+
+	if (fib->hw_fib_va->header.XferState &&
+	    (fib->flags & FIB_CONTEXT_FLAG) &&
+	    (fib->flags & FIB_CONTEXT_FLAG_SCSI_CMD)) {
+		struct aac_hba_map_info *info;
+		u32 bus, cid;
+
+		if (cmd != (struct scsi_cmnd *)fib->callback_data)
+			return true;
+		bus = aac_logical_to_phys(scmd_channel(cmd));
+		if (bus != *cmd_bus)
+			return true;
+		cid = scmd_id(cmd);
+		info = &aac->hba_map[bus][cid];
+		if (bus >= AAC_MAX_BUSES || cid >= AAC_MAX_TARGETS ||
+		    info->devtype != AAC_DEVTYPE_NATIVE_RAW) {
+			fib->flags |= FIB_CONTEXT_FLAG_EH_RESET;
+			cmd->SCp.phase = AAC_OWNER_ERROR_HANDLER;
+		}
+	}
+	return true;
+}
+
 /*
  *	aac_eh_bus_reset	- Bus reset command handling
  *	@scsi_cmd:	SCSI command block causing the reset
@@ -1024,32 +1088,10 @@ static int aac_eh_bus_reset(struct scsi_cmnd* cmd)
 	u32 cmd_bus;
 	int status = 0;
 
-
 	cmd_bus = aac_logical_to_phys(scmd_channel(cmd));
-	/* Mark the assoc. FIB to not complete, eh handler does this */
-	for (count = 0; count < (host->can_queue + AAC_NUM_MGT_FIB); ++count) {
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
 
+	/* Mark the assoc. FIB to not complete, eh handler does this */
+	scsi_host_tagset_busy_iter(host, aac_eh_bus_reset_iter, &cmd_bus);
 	pr_err("%s: Host adapter reset request. SCSI hang ?\n", AAC_DRIVERNAME);
 
 	/*
-- 
2.17.1


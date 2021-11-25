Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C8FAC433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Nov 2021 15:13:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355984AbhKYPQX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 25 Nov 2021 10:16:23 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:35638 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354025AbhKYPOO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Nov 2021 10:14:14 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 258D521B38;
        Thu, 25 Nov 2021 15:11:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1637853062; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=keKpSv4046AbkFh2rE4u4srslmWS+34773gJoORSYCU=;
        b=rrWEUK7l9nuffXBXC2fZbkmguL+bKR7CDIyrSfeMgRe3g5bb2MOzaTuugO2dBrw7fHFXbt
        U5KC5/7vcA8yHQ54WzCHn/+DjGCy/Ub0HhtMB2KWznpy0A2lwQhP5tNXsJp0RChr0lPrp3
        IvQjkUmw9TxUO+qOfUPp5Nl8or/6pVY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1637853062;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=keKpSv4046AbkFh2rE4u4srslmWS+34773gJoORSYCU=;
        b=kN3iSGsc5UMyX0t1MDSqKUWZic9nkb4A43OGtgaR1CcTbGIUKW2j47JCo+pQGJTzZTGbMs
        cIYtcBe4kAJMs0DQ==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id 1C9E3A3B96;
        Thu, 25 Nov 2021 15:11:02 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id D34A85191A0A; Thu, 25 Nov 2021 16:11:01 +0100 (CET)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, John Garry <john.garry@huawei.com>,
        Bart van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH 15/15] aacraid: use scsi_host_busy_iter() to traverse outstanding commands
Date:   Thu, 25 Nov 2021 16:10:48 +0100
Message-Id: <20211125151048.103910-16-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20211125151048.103910-1-hare@suse.de>
References: <20211125151048.103910-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Instead of walking the array of potential commands and trying to figure out
which one might be pending the driver should be using
scsi_host_busy_iter() to traverse all outstanding commands.
And for command abort we can now lookup the fibs directly as we now have
a 1:1 mapping between request tags and fibs.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/aacraid/commsup.c |  49 ++++++------
 drivers/scsi/aacraid/linit.c   | 131 ++++++++++++++-------------------
 2 files changed, 84 insertions(+), 96 deletions(-)

diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
index aaa9b5d6f55d..54ec5a3435cd 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -1465,6 +1465,32 @@ static void aac_schedule_bus_scan(struct aac_dev *aac)
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
 static int _aac_reset_adapter(struct aac_dev *aac, int forced, u8 reset_type)
 {
 	int index, quirks;
@@ -1473,7 +1499,6 @@ static int _aac_reset_adapter(struct aac_dev *aac, int forced, u8 reset_type)
 	int jafo = 0;
 	int bled;
 	u64 dmamask;
-	int num_of_fibs = 0;
 
 	/*
 	 * Assumptions:
@@ -1507,27 +1532,7 @@ static int _aac_reset_adapter(struct aac_dev *aac, int forced, u8 reset_type)
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
+	scsi_host_busy_iter(host, aac_close_sync_fib_iter, &retval);
 	/* Give some extra time for ioctls to complete. */
 	if (retval == 0)
 		ssleep(2);
diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 7268118186d1..6db6e7377cb0 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -683,7 +683,8 @@ static int aac_eh_abort(struct scsi_cmnd* cmd)
 	struct scsi_device * dev = cmd->device;
 	struct Scsi_Host * host = dev->host;
 	struct aac_dev * aac = (struct aac_dev *)host->hostdata;
-	int count, found;
+	struct fib *fib;
+	int count;
 	u32 bus, cid;
 	int ret = FAILED;
 
@@ -693,26 +694,20 @@ static int aac_eh_abort(struct scsi_cmnd* cmd)
 	bus = aac_logical_to_phys(scmd_channel(cmd));
 	cid = scmd_id(cmd);
 	if (aac->hba_map[bus][cid].devtype == AAC_DEVTYPE_NATIVE_RAW) {
-		struct fib *fib;
 		struct aac_hba_tm_req *tmf;
 		int status;
 		u64 address;
 
 		pr_err("%s: Host adapter abort request (%d,%d,%d,%d)\n",
-		 AAC_DRIVERNAME,
-		 host->host_no, sdev_channel(dev), sdev_id(dev), (int)dev->lun);
-
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
+		       AAC_DRIVERNAME, host->host_no,
+		       sdev_channel(dev), sdev_id(dev), (int)dev->lun);
+
+		fib = &aac->fibs[cmd->request->tag];
+		if (*(u8 *)fib->hw_fib_va != 0 &&
+		    (fib->flags & FIB_CONTEXT_FLAG_NATIVE_HBA) &&
+		    (fib->callback_data == cmd))
+			ret = SUCCESS;
+		if (ret == FAILED)
 			return ret;
 
 		/* start a HBA_TMF_ABORT_TASK TMF request */
@@ -774,20 +769,13 @@ static int aac_eh_abort(struct scsi_cmnd* cmd)
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
+			fib = &aac->fibs[cmd->request->tag];
+			if (fib->hw_fib_va->header.XferState &&
+			    (fib->flags & FIB_CONTEXT_FLAG) &&
+			    (fib->callback_data == cmd)) {
+				fib->flags |= FIB_CONTEXT_FLAG_TIMED_OUT;
+				cmd->SCp.phase = AAC_OWNER_ERROR_HANDLER;
+				ret = SUCCESS;
 			}
 			break;
 		case TEST_UNIT_READY:
@@ -795,27 +783,14 @@ static int aac_eh_abort(struct scsi_cmnd* cmd)
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
+			fib = &aac->fibs[cmd->request->tag];
+			if ((fib->hw_fib_va->header.XferState &
+			     cpu_to_le32(Async | NoResponseExpected)) &&
+			    (fib->flags & FIB_CONTEXT_FLAG) &&
+			    (fib->callback_data == cmd)) {
+				fib->flags |= FIB_CONTEXT_FLAG_TIMED_OUT;
+				cmd->SCp.phase = AAC_OWNER_ERROR_HANDLER;
+				ret = SUCCESS;
 			}
 			break;
 		}
@@ -1023,6 +998,36 @@ static int aac_eh_target_reset(struct scsi_cmnd *cmd)
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
@@ -1040,29 +1045,7 @@ static int aac_eh_bus_reset(struct scsi_cmnd* cmd)
 
 	cmd_bus = aac_logical_to_phys(scmd_channel(cmd));
 	/* Mark the assoc. FIB to not complete, eh handler does this */
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
-
+	scsi_host_busy_iter(host, aac_eh_bus_reset_iter, &cmd_bus);
 	pr_err("%s: Host bus reset request. SCSI hang ?\n", AAC_DRIVERNAME);
 
 	/*
-- 
2.29.2


From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: [PATCH V4 17/24] aacraid: Added support to abort cmd and reset lun
Date: Thu, 2 Feb 2017 15:53:31 -0800
Message-ID: <20170202235338.14724-18-RaghavaAditya.Renukunta@microsemi.com>
References: <20170202235338.14724-1-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam03on0059.outbound.protection.outlook.com ([104.47.42.59]:36640
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752642AbdBCGbD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 3 Feb 2017 01:31:03 -0500
In-Reply-To: <20170202235338.14724-1-RaghavaAditya.Renukunta@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: David.Carroll@microsemi.com, Gana.Sridaran@microsemi.com, Scott.Benesh@microsemi.com, jthumshirn@suse.de

Added task management command support to abort any timed out commands
in case of a eh_abort call and to reset lun's in case of eh_reset call.

Signed-off-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Signed-off-by: Dave Carroll <David.Carroll@microsemi.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
---

Changes in  V2:
Fixed  freeing of initialized address

Changes in  V3:
None

Changes in  V4:
None

 drivers/scsi/aacraid/aacraid.h |  48 ++++++
 drivers/scsi/aacraid/linit.c   | 353 +++++++++++++++++++++++++++++++----------
 drivers/scsi/aacraid/src.c     |  33 +++-
 3 files changed, 346 insertions(+), 88 deletions(-)

diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
index 2f584b4..055ab19 100644
--- a/drivers/scsi/aacraid/aacraid.h
+++ b/drivers/scsi/aacraid/aacraid.h
@@ -206,6 +206,53 @@ struct aac_hba_cmd_req {
 	 */
 };
 
+/* Task Management Functions (TMF) */
+#define HBA_TMF_ABORT_TASK	0x01
+#define HBA_TMF_LUN_RESET	0x08
+
+struct aac_hba_tm_req {
+	u8	iu_type;	/* HBA information unit type */
+	u8	reply_qid;	/* Host reply queue to post response to */
+	u8	tmf;		/* Task management function */
+	u8	reserved1;
+
+	__le32	it_nexus;	/* Device handle for the command */
+
+	u8	lun[8];		/* SCSI LUN */
+
+	/* Used to hold sender context. */
+	__le32	request_id;	/* Sender context */
+	__le32	reserved2;
+
+	/* Request identifier of managed task */
+	__le32	managed_request_id;	/* Sender context being managed */
+	__le32	reserved3;
+
+	/* Lower 32-bits of reserved error data target location on the host */
+	__le32	error_ptr_lo;
+	/* Upper 32-bits of reserved error data target location on the host */
+	__le32	error_ptr_hi;
+	/* Length of reserved error data area on the host in bytes */
+	__le32	error_length;
+};
+
+struct aac_hba_reset_req {
+	u8	iu_type;	/* HBA information unit type */
+	/* 0 - reset specified device, 1 - reset all devices */
+	u8	reset_type;
+	u8	reply_qid;	/* Host reply queue to post response to */
+	u8	reserved1;
+
+	__le32	it_nexus;	/* Device handle for the command */
+	__le32	request_id;	/* Sender context */
+	/* Lower 32-bits of reserved error data target location on the host */
+	__le32	error_ptr_lo;
+	/* Upper 32-bits of reserved error data target location on the host */
+	__le32	error_ptr_hi;
+	/* Length of reserved error data area on the host in bytes */
+	__le32	error_length;
+};
+
 struct aac_hba_resp {
 	u8	iu_type;		/* HBA information unit type */
 	u8	reserved1[3];
@@ -223,6 +270,7 @@ struct aac_hba_resp {
 struct aac_native_hba {
 	union {
 		struct aac_hba_cmd_req cmd;
+		struct aac_hba_tm_req tmr;
 		u8 cmd_bytes[AAC_MAX_NATIVE_SIZE-FW_ERROR_BUFFER_SIZE];
 	} cmd;
 	union {
diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 68a5d2d..c09b71c 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -574,46 +574,136 @@ static int aac_eh_abort(struct scsi_cmnd* cmd)
 	struct scsi_device * dev = cmd->device;
 	struct Scsi_Host * host = dev->host;
 	struct aac_dev * aac = (struct aac_dev *)host->hostdata;
-	int count;
+	int count, found;
+	u32 bus, cid;
 	int ret = FAILED;
 
-	printk(KERN_ERR "%s: Host adapter abort request (%d,%d,%d,%llu)\n",
-		AAC_DRIVERNAME,
-		host->host_no, sdev_channel(dev), sdev_id(dev), dev->lun);
-	switch (cmd->cmnd[0]) {
-	case SERVICE_ACTION_IN_16:
-		if (!(aac->raw_io_interface) ||
-		    !(aac->raw_io_64) ||
-		    ((cmd->cmnd[1] & 0x1f) != SAI_READ_CAPACITY_16))
-			break;
-	case INQUIRY:
-	case READ_CAPACITY:
-		/* Mark associated FIB to not complete, eh handler does this */
+	bus = aac_logical_to_phys(scmd_channel(cmd));
+	cid = scmd_id(cmd);
+	if (aac->hba_map[bus][cid].devtype == AAC_DEVTYPE_NATIVE_RAW) {
+		struct fib *fib;
+		struct aac_hba_tm_req *tmf;
+		int status;
+		u64 address;
+		__le32 managed_request_id;
+
+		pr_err("%s: Host adapter abort request (%d,%d,%d,%d)\n",
+		 AAC_DRIVERNAME,
+		 host->host_no, sdev_channel(dev), sdev_id(dev), (int)dev->lun);
+
+		found = 0;
 		for (count = 0; count < (host->can_queue + AAC_NUM_MGT_FIB); ++count) {
-			struct fib * fib = &aac->fibs[count];
-			if (fib->hw_fib_va->header.XferState &&
-			  (fib->flags & FIB_CONTEXT_FLAG) &&
-			  (fib->callback_data == cmd)) {
-				fib->flags |= FIB_CONTEXT_FLAG_TIMED_OUT;
-				cmd->SCp.phase = AAC_OWNER_ERROR_HANDLER;
+			fib = &aac->fibs[count];
+			if (*(u8 *)fib->hw_fib_va != 0 &&
+				(fib->flags & FIB_CONTEXT_FLAG_NATIVE_HBA) &&
+				(fib->callback_data == cmd)) {
+				found = 1;
+				managed_request_id = ((struct aac_hba_cmd_req *)
+					fib->hw_fib_va)->request_id;
+				break;
+			}
+		}
+		if (!found)
+			return ret;
+
+		/* start a HBA_TMF_ABORT_TASK TMF request */
+		fib = aac_fib_alloc(aac);
+		if (!fib)
+			return ret;
+
+		tmf = (struct aac_hba_tm_req *)fib->hw_fib_va;
+		memset(tmf, 0, sizeof(*tmf));
+		tmf->tmf = HBA_TMF_ABORT_TASK;
+		tmf->it_nexus = aac->hba_map[bus][cid].rmw_nexus;
+		tmf->lun[1] = cmd->device->lun;
+
+		address = (u64)fib->hw_error_pa;
+		tmf->error_ptr_hi = cpu_to_le32((u32)(address >> 32));
+		tmf->error_ptr_lo = cpu_to_le32((u32)(address & 0xffffffff));
+		tmf->error_length = cpu_to_le32(FW_ERROR_BUFFER_SIZE);
+
+		fib->hbacmd_size = sizeof(*tmf);
+		cmd->SCp.sent_command = 0;
+
+		status = aac_hba_send(HBA_IU_TYPE_SCSI_TM_REQ, fib,
+				  (fib_callback) aac_hba_callback,
+				  (void *) cmd);
+
+		/* Wait up to 2 minutes for completion */
+		for (count = 0; count < 120; ++count) {
+			if (cmd->SCp.sent_command) {
 				ret = SUCCESS;
+				break;
 			}
+			msleep(1000);
 		}
-		break;
-	case TEST_UNIT_READY:
-		/* Mark associated FIB to not complete, eh handler does this */
-		for (count = 0; count < (host->can_queue + AAC_NUM_MGT_FIB); ++count) {
-			struct scsi_cmnd * command;
-			struct fib * fib = &aac->fibs[count];
-			if ((fib->hw_fib_va->header.XferState & cpu_to_le32(Async | NoResponseExpected)) &&
-			  (fib->flags & FIB_CONTEXT_FLAG) &&
-			  ((command = fib->callback_data)) &&
-			  (command->device == cmd->device)) {
-				fib->flags |= FIB_CONTEXT_FLAG_TIMED_OUT;
-				command->SCp.phase = AAC_OWNER_ERROR_HANDLER;
-				if (command == cmd)
+
+		if (ret != SUCCESS)
+			pr_err("%s: Host adapter abort request timed out\n",
+			AAC_DRIVERNAME);
+	} else {
+		pr_err(
+			"%s: Host adapter abort request.\n"
+			"%s: Outstanding commands on (%d,%d,%d,%d):\n",
+			AAC_DRIVERNAME, AAC_DRIVERNAME,
+			host->host_no, sdev_channel(dev), sdev_id(dev),
+			(int)dev->lun);
+		switch (cmd->cmnd[0]) {
+		case SERVICE_ACTION_IN_16:
+			if (!(aac->raw_io_interface) ||
+			    !(aac->raw_io_64) ||
+			    ((cmd->cmnd[1] & 0x1f) != SAI_READ_CAPACITY_16))
+				break;
+		case INQUIRY:
+		case READ_CAPACITY:
+			/*
+			 * Mark associated FIB to not complete,
+			 * eh handler does this
+			 */
+			for (count = 0;
+				count < (host->can_queue + AAC_NUM_MGT_FIB);
+				++count) {
+				struct fib *fib = &aac->fibs[count];
+
+				if (fib->hw_fib_va->header.XferState &&
+				(fib->flags & FIB_CONTEXT_FLAG) &&
+				(fib->callback_data == cmd)) {
+					fib->flags |=
+						FIB_CONTEXT_FLAG_TIMED_OUT;
+					cmd->SCp.phase =
+						AAC_OWNER_ERROR_HANDLER;
 					ret = SUCCESS;
+				}
 			}
+			break;
+		case TEST_UNIT_READY:
+			/*
+			 * Mark associated FIB to not complete,
+			 * eh handler does this
+			 */
+			for (count = 0;
+				count < (host->can_queue + AAC_NUM_MGT_FIB);
+				++count) {
+				struct scsi_cmnd *command;
+				struct fib *fib = &aac->fibs[count];
+
+				command = fib->callback_data;
+
+				if ((fib->hw_fib_va->header.XferState &
+					cpu_to_le32
+					(Async | NoResponseExpected)) &&
+					(fib->flags & FIB_CONTEXT_FLAG) &&
+					((command)) &&
+					(command->device == cmd->device)) {
+					fib->flags |=
+						FIB_CONTEXT_FLAG_TIMED_OUT;
+					command->SCp.phase =
+						AAC_OWNER_ERROR_HANDLER;
+					if (command == cmd)
+						ret = SUCCESS;
+				}
+			}
+			break;
 		}
 	}
 	return ret;
@@ -628,70 +718,165 @@ static int aac_eh_reset(struct scsi_cmnd* cmd)
 {
 	struct scsi_device * dev = cmd->device;
 	struct Scsi_Host * host = dev->host;
-	struct scsi_cmnd * command;
-	int count;
 	struct aac_dev * aac = (struct aac_dev *)host->hostdata;
-	unsigned long flags;
-
-	/* Mark the associated FIB to not complete, eh handler does this */
-	for (count = 0; count < (host->can_queue + AAC_NUM_MGT_FIB); ++count) {
-		struct fib * fib = &aac->fibs[count];
-		if (fib->hw_fib_va->header.XferState &&
-		  (fib->flags & FIB_CONTEXT_FLAG) &&
-		  (fib->callback_data == cmd)) {
-			fib->flags |= FIB_CONTEXT_FLAG_TIMED_OUT;
-			cmd->SCp.phase = AAC_OWNER_ERROR_HANDLER;
+	int count;
+	u32 bus, cid;
+	int ret = FAILED;
+
+	bus = aac_logical_to_phys(scmd_channel(cmd));
+	cid = scmd_id(cmd);
+	if (bus < AAC_MAX_BUSES && cid < AAC_MAX_TARGETS &&
+		aac->hba_map[bus][cid].devtype == AAC_DEVTYPE_NATIVE_RAW) {
+		struct fib *fib;
+		int status;
+		u64 address;
+		u8 command;
+
+		pr_err("%s: Host adapter reset request. SCSI hang ?\n",
+			AAC_DRIVERNAME);
+
+		fib = aac_fib_alloc(aac);
+		if (!fib)
+			return ret;
+
+
+		if (aac->hba_map[bus][cid].reset_state == 0) {
+			struct aac_hba_tm_req *tmf;
+
+			/* start a HBA_TMF_LUN_RESET TMF request */
+			tmf = (struct aac_hba_tm_req *)fib->hw_fib_va;
+			memset(tmf, 0, sizeof(*tmf));
+			tmf->tmf = HBA_TMF_LUN_RESET;
+			tmf->it_nexus = aac->hba_map[bus][cid].rmw_nexus;
+			tmf->lun[1] = cmd->device->lun;
+
+			address = (u64)fib->hw_error_pa;
+			tmf->error_ptr_hi = cpu_to_le32
+					((u32)(address >> 32));
+			tmf->error_ptr_lo = cpu_to_le32
+					((u32)(address & 0xffffffff));
+			tmf->error_length = cpu_to_le32(FW_ERROR_BUFFER_SIZE);
+			fib->hbacmd_size = sizeof(*tmf);
+
+			command = HBA_IU_TYPE_SCSI_TM_REQ;
+			aac->hba_map[bus][cid].reset_state++;
+		} else if (aac->hba_map[bus][cid].reset_state >= 1) {
+			struct aac_hba_reset_req *rst;
+
+			/* already tried, start a hard reset now */
+			rst = (struct aac_hba_reset_req *)fib->hw_fib_va;
+			memset(rst, 0, sizeof(*rst));
+			/* reset_type is already zero... */
+			rst->it_nexus = aac->hba_map[bus][cid].rmw_nexus;
+
+			address = (u64)fib->hw_error_pa;
+			rst->error_ptr_hi = cpu_to_le32((u32)(address >> 32));
+			rst->error_ptr_lo = cpu_to_le32
+				((u32)(address & 0xffffffff));
+			rst->error_length = cpu_to_le32(FW_ERROR_BUFFER_SIZE);
+			fib->hbacmd_size = sizeof(*rst);
+
+			command = HBA_IU_TYPE_SATA_REQ;
+			aac->hba_map[bus][cid].reset_state = 0;
 		}
-	}
-	printk(KERN_ERR "%s: Host adapter reset request. SCSI hang ?\n",
-					AAC_DRIVERNAME);
+		cmd->SCp.sent_command = 0;
 
-	if ((count = aac_check_health(aac)))
-		return count;
-	/*
-	 * Wait for all commands to complete to this specific
-	 * target (block maximum 60 seconds).
-	 */
-	for (count = 60; count; --count) {
-		int active = aac->in_reset;
+		status = aac_hba_send(command, fib,
+				  (fib_callback) aac_hba_callback,
+				  (void *) cmd);
 
-		if (active == 0)
-		__shost_for_each_device(dev, host) {
-			spin_lock_irqsave(&dev->list_lock, flags);
-			list_for_each_entry(command, &dev->cmd_list, list) {
-				if ((command != cmd) &&
-				    (command->SCp.phase == AAC_OWNER_FIRMWARE)) {
-					active++;
-					break;
-				}
-			}
-			spin_unlock_irqrestore(&dev->list_lock, flags);
-			if (active)
+		/* Wait up to 2 minutes for completion */
+		for (count = 0; count < 120; ++count) {
+			if (cmd->SCp.sent_command) {
+				ret = SUCCESS;
 				break;
+			}
+			msleep(1000);
+		}
+
+		if (ret != SUCCESS)
+			pr_err("%s: Host adapter reset request timed out\n",
+			AAC_DRIVERNAME);
+	} else {
+		struct scsi_cmnd *command;
+		unsigned long flags;
+
+		/* Mark the assoc. FIB to not complete, eh handler does this */
+		for (count = 0;
+			count < (host->can_queue + AAC_NUM_MGT_FIB);
+			++count) {
+			struct fib *fib = &aac->fibs[count];
+
+			if (fib->hw_fib_va->header.XferState &&
+				(fib->flags & FIB_CONTEXT_FLAG) &&
+				(fib->callback_data == cmd)) {
+				fib->flags |= FIB_CONTEXT_FLAG_TIMED_OUT;
+				cmd->SCp.phase = AAC_OWNER_ERROR_HANDLER;
+			}
+		}
+
+		pr_err("%s: Host adapter reset request. SCSI hang ?\n",
+					AAC_DRIVERNAME);
+
+		count = aac_check_health(aac);
+		if (count)
+			return count;
+		/*
+		 * Wait for all commands to complete to this specific
+		 * target (block maximum 60 seconds).
+		 */
+		for (count = 60; count; --count) {
+			int active = aac->in_reset;
+
+			if (active == 0)
+			__shost_for_each_device(dev, host) {
+				spin_lock_irqsave(&dev->list_lock, flags);
+				list_for_each_entry(command, &dev->cmd_list,
+					list) {
+					if ((command != cmd) &&
+					(command->SCp.phase ==
+					AAC_OWNER_FIRMWARE)) {
+						active++;
+						break;
+					}
+				}
+				spin_unlock_irqrestore(&dev->list_lock, flags);
+				if (active)
+					break;
 
+			}
+			/*
+			 * We can exit If all the commands are complete
+			 */
+			if (active == 0)
+				return SUCCESS;
+			ssleep(1);
 		}
+		pr_err("%s: SCSI bus appears hung\n", AAC_DRIVERNAME);
+
 		/*
-		 * We can exit If all the commands are complete
+		 * This adapter needs a blind reset, only do so for
+		 * Adapters that support a register, instead of a commanded,
+		 * reset.
 		 */
-		if (active == 0)
-			return SUCCESS;
-		ssleep(1);
+		if (((aac->supplement_adapter_info.SupportedOptions2 &
+			  AAC_OPTION_MU_RESET) ||
+			  (aac->supplement_adapter_info.SupportedOptions2 &
+			  AAC_OPTION_DOORBELL_RESET)) &&
+			  aac_check_reset &&
+			  ((aac_check_reset != 1) ||
+			   !(aac->supplement_adapter_info.SupportedOptions2 &
+			    AAC_OPTION_IGNORE_RESET))) {
+			/* Bypass wait for command quiesce */
+			aac_reset_adapter(aac, 2);
+		}
+		ret = SUCCESS;
 	}
-	printk(KERN_ERR "%s: SCSI bus appears hung\n", AAC_DRIVERNAME);
 	/*
-	 * This adapter needs a blind reset, only do so for Adapters that
-	 * support a register, instead of a commanded, reset.
+	 * Cause an immediate retry of the command with a ten second delay
+	 * after successful tur
 	 */
-	if (((aac->supplement_adapter_info.SupportedOptions2 &
-	  AAC_OPTION_MU_RESET) ||
-	  (aac->supplement_adapter_info.SupportedOptions2 &
-	  AAC_OPTION_DOORBELL_RESET)) &&
-	  aac_check_reset &&
-	  ((aac_check_reset != 1) ||
-	   !(aac->supplement_adapter_info.SupportedOptions2 &
-	    AAC_OPTION_IGNORE_RESET)))
-		aac_reset_adapter(aac, 2); /* Bypass wait for command quiesce */
-	return SUCCESS; /* Cause an immediate retry of the command with a ten second delay after successful tur */
+	return ret;
 }
 
 /**
diff --git a/drivers/scsi/aacraid/src.c b/drivers/scsi/aacraid/src.c
index 946a010..1dd62a4 100644
--- a/drivers/scsi/aacraid/src.c
+++ b/drivers/scsi/aacraid/src.c
@@ -497,10 +497,35 @@ static int aac_src_deliver_message(struct fib *fib)
 			vector_no = fib->vector_no;
 
 		if (native_hba) {
-			((struct aac_hba_cmd_req *)fib->hw_fib_va)->reply_qid
-				= vector_no;
-			((struct aac_hba_cmd_req *)fib->hw_fib_va)->request_id
-				+= (vector_no << 16);
+			if (fib->flags & FIB_CONTEXT_FLAG_NATIVE_HBA_TMF) {
+				struct aac_hba_tm_req *tm_req;
+
+				tm_req = (struct aac_hba_tm_req *)
+						fib->hw_fib_va;
+				if (tm_req->iu_type ==
+					HBA_IU_TYPE_SCSI_TM_REQ) {
+					((struct aac_hba_tm_req *)
+						fib->hw_fib_va)->reply_qid
+							= vector_no;
+					((struct aac_hba_tm_req *)
+						fib->hw_fib_va)->request_id
+							+= (vector_no << 16);
+				} else {
+					((struct aac_hba_reset_req *)
+						fib->hw_fib_va)->reply_qid
+							= vector_no;
+					((struct aac_hba_reset_req *)
+						fib->hw_fib_va)->request_id
+							+= (vector_no << 16);
+				}
+			} else {
+				((struct aac_hba_cmd_req *)
+					fib->hw_fib_va)->reply_qid
+						= vector_no;
+				((struct aac_hba_cmd_req *)
+					fib->hw_fib_va)->request_id
+						+= (vector_no << 16);
+			}
 		} else {
 			fib->hw_fib_va->header.Handle += (vector_no << 16);
 		}
-- 
2.7.4

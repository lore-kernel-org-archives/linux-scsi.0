From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: [PATCH V2 16/24] aacraid: Add task management functionality
Date: Wed, 25 Jan 2017 10:01:03 -0800
Message-ID: <20170125180111.25401-17-RaghavaAditya.Renukunta@microsemi.com>
References: <20170125180111.25401-1-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-co1nam03on0047.outbound.protection.outlook.com ([104.47.40.47]:43947
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752063AbdAZAiT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 25 Jan 2017 19:38:19 -0500
In-Reply-To: <20170125180111.25401-1-RaghavaAditya.Renukunta@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: David.Carroll@microsemi.com, Gana.Sridaran@microsemi.com, RaghavaAditya.Renukunta@microsemi.com, Scott.Benesh@microsemi.com

Added support to send out task management commands.

Signed-off-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Signed-off-by: Dave Carroll <David.Carroll@microsemi.com>

---
 Changes in  V2:
  Fixed overflow warning

 drivers/scsi/aacraid/aachba.c | 364 +++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 360 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
index d134c8d..a5a195c 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -217,9 +217,13 @@ static long aac_build_sg64(struct scsi_cmnd *scsicmd, struct sgmap64 *psg);
 static long aac_build_sgraw(struct scsi_cmnd *scsicmd, struct sgmapraw *psg);
 static long aac_build_sgraw2(struct scsi_cmnd *scsicmd,
 				struct aac_raw_io2 *rio2, int sg_max);
+static long aac_build_sghba(struct scsi_cmnd *scsicmd,
+				struct aac_hba_cmd_req *hbacmd,
+				int sg_max, u64 sg_address);
 static int aac_convert_sgraw2(struct aac_raw_io2 *rio2,
 				int pages, int nseg, int nseg_new);
 static int aac_send_srb_fib(struct scsi_cmnd* scsicmd);
+static int aac_send_hba_fib(struct scsi_cmnd *scsicmd);
 #ifdef AAC_DETAILED_STATUS_INFO
 static char *aac_get_status_string(u32 status);
 #endif
@@ -1446,6 +1450,52 @@ static struct aac_srb * aac_scsi_common(struct fib * fib, struct scsi_cmnd * cmd
 	return srbcmd;
 }
 
+static struct aac_hba_cmd_req *aac_construct_hbacmd(struct fib *fib,
+							struct scsi_cmnd *cmd)
+{
+	struct aac_hba_cmd_req *hbacmd;
+	struct aac_dev *dev;
+	int bus, target;
+	u64 address;
+
+	dev = (struct aac_dev *)cmd->device->host->hostdata;
+
+	hbacmd = (struct aac_hba_cmd_req *)fib->hw_fib_va;
+	memset(hbacmd, 0, 96);	/* sizeof(*hbacmd) is not necessary */
+	/* iu_type is a parameter of aac_hba_send */
+	switch (cmd->sc_data_direction) {
+	case DMA_TO_DEVICE:
+		hbacmd->byte1 = 2;
+		break;
+	case DMA_FROM_DEVICE:
+	case DMA_BIDIRECTIONAL:
+		hbacmd->byte1 = 1;
+		break;
+	case DMA_NONE:
+	default:
+		break;
+	}
+	hbacmd->lun[1] = cpu_to_le32(cmd->device->lun);
+
+	bus = aac_logical_to_phys(scmd_channel(cmd));
+	target = scmd_id(cmd);
+	hbacmd->it_nexus = dev->hba_map[bus][target].rmw_nexus;
+
+	/* we fill in reply_qid later in aac_src_deliver_message */
+	/* we fill in iu_type, request_id later in aac_hba_send */
+	/* we fill in emb_data_desc_count later in aac_build_sghba */
+
+	memcpy(hbacmd->cdb, cmd->cmnd, cmd->cmd_len);
+	hbacmd->data_length = cpu_to_le32(scsi_bufflen(cmd));
+
+	address = (u64)fib->hw_error_pa;
+	hbacmd->error_ptr_hi = cpu_to_le32((u32)(address >> 32));
+	hbacmd->error_ptr_lo = cpu_to_le32((u32)(address & 0xffffffff));
+	hbacmd->error_length = cpu_to_le32(FW_ERROR_BUFFER_SIZE);
+
+	return hbacmd;
+}
+
 static void aac_srb_callback(void *context, struct fib * fibptr);
 
 static int aac_scsi_64(struct fib * fib, struct scsi_cmnd * cmd)
@@ -1516,6 +1566,31 @@ static int aac_scsi_32_64(struct fib * fib, struct scsi_cmnd * cmd)
 	return aac_scsi_32(fib, cmd);
 }
 
+static int aac_adapter_hba(struct fib *fib, struct scsi_cmnd *cmd)
+{
+	struct aac_hba_cmd_req *hbacmd = aac_construct_hbacmd(fib, cmd);
+	struct aac_dev *dev;
+	// u16 fibsize;
+	long ret;
+
+	dev = (struct aac_dev *)cmd->device->host->hostdata;
+
+	ret = aac_build_sghba(cmd, hbacmd,
+		dev->scsi_host_ptr->sg_tablesize, (u64)fib->hw_sgl_pa);
+	if (ret < 0)
+		return ret;
+
+	/*
+	 *	Now send the HBA command to the adapter
+	 */
+	fib->hbacmd_size = 64 + le32_to_cpu(hbacmd->emb_data_desc_count) *
+		sizeof(struct aac_hba_sgl);
+
+	return aac_hba_send(HBA_IU_TYPE_SCSI_CMD_REQ, fib,
+				  (fib_callback) aac_hba_callback,
+				  (void *) cmd);
+}
+
 int aac_issue_bmic_identify(struct aac_dev *dev, u32 bus, u32 target)
 {
 	struct fib *fibptr;
@@ -1528,6 +1603,7 @@ int aac_issue_bmic_identify(struct aac_dev *dev, u32 bus, u32 target)
 	u32 vbus, vid;
 	u16 temp;
 
+
 	fibptr = aac_fib_alloc(dev);
 	if (!fibptr)
 		return -ENOMEM;
@@ -2003,6 +2079,11 @@ int aac_get_adapter_info(struct aac_dev* dev)
 			  (dev->scsi_host_ptr->sg_tablesize * 8) + 112;
 		}
 	}
+	if (!dev->sync_mode && dev->sa_firmware &&
+		dev->scsi_host_ptr->sg_tablesize > HBA_MAX_SG_SEPARATE)
+		dev->scsi_host_ptr->sg_tablesize = dev->sg_tablesize =
+			HBA_MAX_SG_SEPARATE;
+
 	/* FIB should be freed only after getting the response from the F/W */
 	if (rcode != -ERESTARTSYS) {
 		aac_fib_complete(fibptr);
@@ -2559,7 +2640,7 @@ static int aac_start_stop(struct scsi_cmnd *scsicmd)
 
 int aac_scsi_cmd(struct scsi_cmnd * scsicmd)
 {
-	u32 cid;
+	u32 cid, bus;
 	struct Scsi_Host *host = scsicmd->device->host;
 	struct aac_dev *dev = (struct aac_dev *)host->hostdata;
 	struct fsa_dev_info *fsa_dev_ptr = dev->fsa_dev;
@@ -2605,8 +2686,24 @@ int aac_scsi_cmd(struct scsi_cmnd * scsicmd)
 				}
 			}
 		} else {  /* check for physical non-dasd devices */
-			if (dev->nondasd_support || expose_physicals ||
-					dev->jbod) {
+			bus = aac_logical_to_phys(scmd_channel(scsicmd));
+			if (bus < AAC_MAX_BUSES && cid < AAC_MAX_TARGETS &&
+				(dev->hba_map[bus][cid].expose
+						== AAC_HIDE_DISK)){
+				if (scsicmd->cmnd[0] == INQUIRY) {
+					scsicmd->result = DID_NO_CONNECT << 16;
+					goto scsi_done_ret;
+				}
+			}
+
+			if (bus < AAC_MAX_BUSES && cid < AAC_MAX_TARGETS &&
+				dev->hba_map[bus][cid].devtype
+					== AAC_DEVTYPE_NATIVE_RAW) {
+				if (dev->in_reset)
+					return -1;
+				return aac_send_hba_fib(scsicmd);
+			} else if (dev->nondasd_support || expose_physicals ||
+				dev->jbod) {
 				if (dev->in_reset)
 					return -1;
 				return aac_send_srb_fib(scsicmd);
@@ -3365,7 +3462,151 @@ static void aac_srb_callback(void *context, struct fib * fibptr)
 
 /**
  *
- * aac_send_scb_fib
+ * aac_hba_callback
+ * @context: the context set in the fib - here it is scsi cmd
+ * @fibptr: pointer to the fib
+ *
+ * Handles the completion of a native HBA scsi command
+ *
+ */
+void aac_hba_callback(void *context, struct fib *fibptr)
+{
+	struct aac_dev *dev;
+	struct scsi_cmnd *scsicmd;
+
+	scsicmd = (struct scsi_cmnd *) context;
+
+	if (!aac_valid_context(scsicmd, fibptr))
+		return;
+
+	WARN_ON(fibptr == NULL);
+	dev = fibptr->dev;
+
+	if (!(fibptr->flags & FIB_CONTEXT_FLAG_NATIVE_HBA_TMF))
+		scsi_dma_unmap(scsicmd);
+
+	if (fibptr->flags & FIB_CONTEXT_FLAG_FASTRESP) {
+		/* fast response */
+		scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8;
+	} else {
+		struct aac_hba_resp *err =
+			&((struct aac_native_hba *)fibptr->hw_fib_va)->resp.err;
+
+		// BUG_ON(err->iu_type != HBA_IU_TYPE_RESP);
+		if (err->service_response == HBA_RESP_SVCRES_TASK_COMPLETE) {
+			scsicmd->result = err->status;
+			/* set residual count */
+			scsi_set_resid(scsicmd,
+				le32_to_cpu(err->residual_count));
+
+			switch (err->status) {
+			case SAM_STAT_GOOD:
+				scsicmd->result |= DID_OK << 16 |
+					COMMAND_COMPLETE << 8;
+				break;
+			case SAM_STAT_CHECK_CONDITION:
+			{
+				int len;
+
+				len = min_t(u8, err->sense_response_data_len,
+					SCSI_SENSE_BUFFERSIZE);
+				if (len)
+					memcpy(scsicmd->sense_buffer,
+						err->sense_response_buf, len);
+				scsicmd->result |= DID_OK << 16 |
+					COMMAND_COMPLETE << 8;
+				break;
+			}
+			case SAM_STAT_BUSY:
+				scsicmd->result |= DID_BUS_BUSY << 16 |
+					COMMAND_COMPLETE << 8;
+				break;
+			case SAM_STAT_TASK_ABORTED:
+				scsicmd->result |= DID_ABORT << 16 |
+					ABORT << 8;
+				break;
+			case SAM_STAT_RESERVATION_CONFLICT:
+			case SAM_STAT_TASK_SET_FULL:
+			default:
+				scsicmd->result |= DID_ERROR << 16 |
+					COMMAND_COMPLETE << 8;
+				break;
+			}
+		} else if (err->service_response == HBA_RESP_SVCRES_FAILURE) {
+			switch (err->status) {
+			case HBA_RESP_STAT_HBAMODE_DISABLED:
+			{
+				u32 bus, cid;
+
+				bus = aac_logical_to_phys(
+						scmd_channel(scsicmd));
+				cid = scmd_id(scsicmd);
+				if (dev->hba_map[bus][cid].devtype ==
+					AAC_DEVTYPE_NATIVE_RAW) {
+					dev->hba_map[bus][cid].devtype =
+						AAC_DEVTYPE_ARC_RAW;
+					dev->hba_map[bus][cid].rmw_nexus =
+						0xffffffff;
+				}
+				scsicmd->result = DID_NO_CONNECT << 16 |
+					COMMAND_COMPLETE << 8;
+				break;
+			}
+			case HBA_RESP_STAT_IO_ERROR:
+			case HBA_RESP_STAT_NO_PATH_TO_DEVICE:
+				scsicmd->result = DID_OK << 16 |
+					COMMAND_COMPLETE << 8 | SAM_STAT_BUSY;
+				break;
+			case HBA_RESP_STAT_IO_ABORTED:
+				scsicmd->result = DID_ABORT << 16 |
+					ABORT << 8;
+				break;
+			case HBA_RESP_STAT_INVALID_DEVICE:
+				scsicmd->result = DID_NO_CONNECT << 16 |
+					COMMAND_COMPLETE << 8;
+				break;
+			case HBA_RESP_STAT_UNDERRUN:
+				/* UNDERRUN is OK */
+				scsicmd->result = DID_OK << 16 |
+					COMMAND_COMPLETE << 8;
+				break;
+			case HBA_RESP_STAT_OVERRUN:
+			default:
+				scsicmd->result = DID_ERROR << 16 |
+					COMMAND_COMPLETE << 8;
+				break;
+			}
+		} else if (err->service_response ==
+			HBA_RESP_SVCRES_TMF_REJECTED) {
+			scsicmd->result =
+				DID_ERROR << 16 | MESSAGE_REJECT << 8;
+		} else if (err->service_response ==
+			HBA_RESP_SVCRES_TMF_LUN_INVALID) {
+			scsicmd->result =
+				DID_NO_CONNECT << 16 | COMMAND_COMPLETE << 8;
+		} else if ((err->service_response ==
+			HBA_RESP_SVCRES_TMF_COMPLETE) ||
+			(err->service_response ==
+			HBA_RESP_SVCRES_TMF_SUCCEEDED)) {
+			scsicmd->result =
+				DID_OK << 16 | COMMAND_COMPLETE << 8;
+		} else {
+			scsicmd->result =
+				DID_ERROR << 16 | COMMAND_COMPLETE << 8;
+		}
+	}
+
+	aac_fib_complete(fibptr);
+
+	if (fibptr->flags & FIB_CONTEXT_FLAG_NATIVE_HBA_TMF)
+		scsicmd->SCp.sent_command = 1;
+	else
+		scsicmd->scsi_done(scsicmd);
+}
+
+/**
+ *
+ * aac_send_srb_fib
  * @scsicmd: the scsi command block
  *
  * This routine will form a FIB and fill in the aac_srb from the
@@ -3408,6 +3649,54 @@ static int aac_send_srb_fib(struct scsi_cmnd* scsicmd)
 	return -1;
 }
 
+/**
+ *
+ * aac_send_hba_fib
+ * @scsicmd: the scsi command block
+ *
+ * This routine will form a FIB and fill in the aac_hba_cmd_req from the
+ * scsicmd passed in.
+ */
+static int aac_send_hba_fib(struct scsi_cmnd *scsicmd)
+{
+	struct fib *cmd_fibcontext;
+	struct aac_dev *dev;
+	int status;
+
+	dev = (struct aac_dev *)scsicmd->device->host->hostdata;
+	if (scmd_id(scsicmd) >= dev->maximum_num_physicals ||
+			scsicmd->device->lun > AAC_MAX_LUN - 1) {
+		scsicmd->result = DID_NO_CONNECT << 16;
+		scsicmd->scsi_done(scsicmd);
+		return 0;
+	}
+
+	/*
+	 *	Allocate and initialize a Fib then setup a BlockWrite command
+	 */
+	cmd_fibcontext = aac_fib_alloc_tag(dev, scsicmd);
+	if (!cmd_fibcontext)
+		return -1;
+
+	status = aac_adapter_hba(cmd_fibcontext, scsicmd);
+
+	/*
+	 *	Check that the command queued to the controller
+	 */
+	if (status == -EINPROGRESS) {
+		scsicmd->SCp.phase = AAC_OWNER_FIRMWARE;
+		return 0;
+	}
+
+	pr_warn("aac_hba_cmd_req: aac_fib_send failed with status: %d\n",
+		status);
+	aac_fib_complete(cmd_fibcontext);
+	aac_fib_free(cmd_fibcontext);
+
+	return -1;
+}
+
+
 static long aac_build_sg(struct scsi_cmnd *scsicmd, struct sgmap *psg)
 {
 	struct aac_dev *dev;
@@ -3660,6 +3949,73 @@ static int aac_convert_sgraw2(struct aac_raw_io2 *rio2, int pages, int nseg, int
 	return 0;
 }
 
+static long aac_build_sghba(struct scsi_cmnd *scsicmd,
+			struct aac_hba_cmd_req *hbacmd,
+			int sg_max,
+			u64 sg_address)
+{
+	unsigned long byte_count = 0;
+	int nseg;
+
+	nseg = scsi_dma_map(scsicmd);
+	if (nseg < 0)
+		return nseg;
+	if (nseg) {
+		struct scatterlist *sg;
+		int i;
+		u32 cur_size;
+		struct aac_hba_sgl *sge;
+
+		if (nseg > HBA_MAX_SG_EMBEDDED)
+			sge = &hbacmd->sge[2];
+		else
+			sge = &hbacmd->sge[0];
+
+		scsi_for_each_sg(scsicmd, sg, nseg, i) {
+			int count = sg_dma_len(sg);
+			u64 addr = sg_dma_address(sg);
+
+			WARN_ON(i >= sg_max);
+			sge->addr_hi = cpu_to_le32((u32)(addr>>32));
+			sge->addr_lo = cpu_to_le32((u32)(addr & 0xffffffff));
+			cur_size = cpu_to_le32(count);
+			sge->len = cur_size;
+			sge->flags = 0;
+			byte_count += count;
+			sge++;
+		}
+
+		sge--;
+		/* hba wants the size to be exact */
+		if (byte_count > scsi_bufflen(scsicmd)) {
+			u32 temp = le32_to_cpu(sge->len) -
+				(byte_count - scsi_bufflen(scsicmd));
+			sge->len = cpu_to_le32(temp);
+			byte_count = scsi_bufflen(scsicmd);
+		}
+
+		if (nseg <= HBA_MAX_SG_EMBEDDED) {
+			hbacmd->emb_data_desc_count = cpu_to_le32(nseg);
+			sge->flags = cpu_to_le32(0x40000000);
+		} else {
+			/* not embedded */
+			hbacmd->sge[0].flags = cpu_to_le32(0x80000000);
+			hbacmd->emb_data_desc_count = (u8)cpu_to_le32(1);
+			hbacmd->sge[0].addr_hi =
+				(u32)cpu_to_le32(sg_address >> 32);
+			hbacmd->sge[0].addr_lo =
+				cpu_to_le32((u32)(sg_address & 0xffffffff));
+		}
+
+		/* Check for command underflow */
+		if (scsicmd->underflow && (byte_count < scsicmd->underflow)) {
+			pr_warn("aacraid: cmd len %08lX cmd underflow %08X\n",
+					byte_count, scsicmd->underflow);
+		}
+	}
+	return byte_count;
+}
+
 #ifdef AAC_DETAILED_STATUS_INFO
 
 struct aac_srb_status_info {
-- 
2.7.4


From: Sumit Saxena <sumit.saxena@avagotech.com>
Subject: RE: [PATCH RESEND 3/18] megaraid_sas : Add separate functions for
 building sysPD IOs and non RW LDIOs
Date: Mon, 20 Apr 2015 19:45:54 +0530
Message-ID: <06d14af524c57414f27d93ca7473d767@mail.gmail.com>
References: <201504201235.t3KCZ2ZC016456@palmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f177.google.com ([209.85.220.177]:35660 "EHLO
	mail-qk0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754547AbbDTOP5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Apr 2015 10:15:57 -0400
Received: by qkhg7 with SMTP id g7so190576577qkh.2
        for <linux-scsi@vger.kernel.org>; Mon, 20 Apr 2015 07:15:56 -0700 (PDT)
In-Reply-To: <201504201235.t3KCZ2ZC016456@palmhbs0.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: thenzl@redhat.com, martin.petersen@oracle.com, hch@infradead.org, jbottomley@parallels.com, Kashyap Desai <kashyap.desai@avagotech.com>

Please ignore only this patch of the series, this is based on a bit old
repo(sent mistakenly old patch). I am sending patch the right
patch(rebased against latest repo) with subject line- "[PATCH RESEND v2
3/18] megaraid_sas : Add separate functions for building sysPD IOs and non
RW LDIOs". Rest of the patches of the series are good.

Thanks,
Sumit

>-----Original Message-----
>From: Sumit.Saxena@avagotech.com [mailto:Sumit.Saxena@avagotech.com]
>Sent: Monday, April 20, 2015 6:03 PM
>To: linux-scsi@vger.kernel.org
>Cc: thenzl@redhat.com; martin.petersen@oracle.com; hch@infradead.org;
>jbottomley@parallels.com; kashyap.desai@avagotech.com;
>sumit.saxena@avagotech.com
>Subject: [PATCH RESEND 3/18] megaraid_sas : Add separate functions for
>building sysPD IOs and non RW LDIOs
>
>This patch will create separate functions for sysPD IOs and non
Read/Write
>LDIOs.
>
>Signed-off-by: Kashyap Desai <kashyap.desai@avagotech.com>
>Signed-off-by: Sumit Saxena <sumit.saxena@avagotech.com>
>
>---
> drivers/scsi/megaraid/megaraid_sas.h        |   10 +-
> drivers/scsi/megaraid/megaraid_sas_base.c   |    4 +-
> drivers/scsi/megaraid/megaraid_sas_fusion.c |  227
+++++++++++++++-------
>-----
> 3 files changed, 138 insertions(+), 103 deletions(-)
>
>diff --git a/drivers/scsi/megaraid/megaraid_sas.h
>b/drivers/scsi/megaraid/megaraid_sas.h
>index 14e5c7c..bdcf2b6 100644
>--- a/drivers/scsi/megaraid/megaraid_sas.h
>+++ b/drivers/scsi/megaraid/megaraid_sas.h
>@@ -1864,9 +1864,13 @@ struct megasas_instance_template {
> #define MEGASAS_IS_LOGICAL(scp)
>	\
> 	(scp->device->channel < MEGASAS_MAX_PD_CHANNELS) ? 0 : 1
>
>-#define MEGASAS_DEV_INDEX(inst, scp)
>	\
>-	((scp->device->channel % 2) * MEGASAS_MAX_DEV_PER_CHANNEL)
>+ 	\
>-	scp->device->id
>+#define MEGASAS_DEV_INDEX(scp)
>	\
>+	(((scp->device->channel % 2) * MEGASAS_MAX_DEV_PER_CHANNEL)
>+	\
>+	scp->device->id)
>+
>+#define MEGASAS_PD_INDEX(scp)
>	\
>+	((scp->device->channel * MEGASAS_MAX_DEV_PER_CHANNEL) +
>		\
>+	scp->device->id)
>
> struct megasas_cmd {
>
>diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c
>b/drivers/scsi/megaraid/megaraid_sas_base.c
>index bb68ba9..e6cb2bd 100644
>--- a/drivers/scsi/megaraid/megaraid_sas_base.c
>+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
>@@ -1196,7 +1196,7 @@ megasas_build_dcdb(struct megasas_instance
>*instance, struct scsi_cmnd *scp,
> 	struct megasas_pthru_frame *pthru;
>
> 	is_logical = MEGASAS_IS_LOGICAL(scp);
>-	device_id = MEGASAS_DEV_INDEX(instance, scp);
>+	device_id = MEGASAS_DEV_INDEX(scp);
> 	pthru = (struct megasas_pthru_frame *)cmd->frame;
>
> 	if (scp->sc_data_direction == PCI_DMA_TODEVICE) @@ -1294,7
>+1294,7 @@ megasas_build_ldio(struct megasas_instance *instance, struct
>scsi_cmnd *scp,
> 	u16 flags = 0;
> 	struct megasas_io_frame *ldio;
>
>-	device_id = MEGASAS_DEV_INDEX(instance, scp);
>+	device_id = MEGASAS_DEV_INDEX(scp);
> 	ldio = (struct megasas_io_frame *)cmd->frame;
>
> 	if (scp->sc_data_direction == PCI_DMA_TODEVICE) diff --git
>a/drivers/scsi/megaraid/megaraid_sas_fusion.c
>b/drivers/scsi/megaraid/megaraid_sas_fusion.c
>index 6637bea..c5619f8 100644
>--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
>+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
>@@ -1497,7 +1497,7 @@ megasas_build_ldio_fusion(struct
>megasas_instance *instance,
> 	struct MR_DRV_RAID_MAP_ALL *local_map_ptr;
> 	u8 *raidLUN;
>
>-	device_id = MEGASAS_DEV_INDEX(instance, scp);
>+	device_id = MEGASAS_DEV_INDEX(scp);
>
> 	fusion = instance->ctrl_context;
>
>@@ -1650,23 +1650,19 @@ megasas_build_ldio_fusion(struct
>megasas_instance *instance,  }
>
> /**
>- * megasas_build_dcdb_fusion -	Prepares IOs to devices
>+ * megasas_build_ld_nonrw_fusion - prepares non rw ios for virtual disk
>  * @instance:		Adapter soft state
>  * @scp:		SCSI command
>  * @cmd:		Command to be prepared
>  *
>- * Prepares the io_request frame for non-io cmds
>+ * Prepares the io_request frame for non-rw io cmds for vd.
>  */
>-static void
>-megasas_build_dcdb_fusion(struct megasas_instance *instance,
>-			  struct scsi_cmnd *scmd,
>-			  struct megasas_cmd_fusion *cmd)
>+static void megasas_build_ld_nonrw_fusion(struct megasas_instance
>*instance,
>+			  struct scsi_cmnd *scmd, struct
megasas_cmd_fusion
>*cmd)
> {
> 	u32 device_id;
> 	struct MPI2_RAID_SCSI_IO_REQUEST *io_request;
> 	u16 pd_index = 0;
>-	u16 os_timeout_value;
>-	u16 timeout_limit;
> 	struct MR_DRV_RAID_MAP_ALL *local_map_ptr;
> 	struct fusion_context *fusion = instance->ctrl_context;
> 	u8                          span, physArm;
>@@ -1674,94 +1670,48 @@ megasas_build_dcdb_fusion(struct
>megasas_instance *instance,
> 	u32                         ld, arRef, pd;
> 	struct MR_LD_RAID                  *raid;
> 	struct RAID_CONTEXT                *pRAID_Context;
>+	u8 fp_possible = 1;
>
> 	io_request = cmd->io_request;
>-	device_id = MEGASAS_DEV_INDEX(instance, scmd);
>-	pd_index = (scmd->device->channel *
>MEGASAS_MAX_DEV_PER_CHANNEL)
>-		+scmd->device->id;
>+	device_id = MEGASAS_DEV_INDEX(scmd);
>+	pd_index = MEGASAS_PD_INDEX(scmd);
> 	local_map_ptr = fusion->ld_drv_map[(instance->map_id & 1)];
>-
> 	io_request->DataLength = cpu_to_le32(scsi_bufflen(scmd));
>+	/* get RAID_Context pointer */
>+	pRAID_Context = &io_request->RaidContext;
>+	/* Check with FW team */
>+	pRAID_Context->VirtualDiskTgtId = cpu_to_le16(device_id);
>+	pRAID_Context->regLockRowLBA    = 0;
>+	pRAID_Context->regLockLength    = 0;
>
>-	if (scmd->device->channel < MEGASAS_MAX_PD_CHANNELS &&
>-	    instance->pd_list[pd_index].driveState == MR_PD_STATE_SYSTEM)
>{
>-		if (fusion->fast_path_io)
>-			io_request->DevHandle =
>-			local_map_ptr-
>>raidMap.devHndlInfo[device_id].curDevHdl;
>-		io_request->RaidContext.RAIDFlags =
>-			MR_RAID_FLAGS_IO_SUB_TYPE_SYSTEM_PD
>-			<< MR_RAID_CTX_RAID_FLAGS_IO_SUB_TYPE_SHIFT;
>-		cmd->request_desc->SCSIIO.DevHandle = io_request-
>>DevHandle;
>-		cmd->request_desc->SCSIIO.MSIxIndex =
>-			instance->msix_vectors ? smp_processor_id() %
>instance->msix_vectors : 0;
>-		os_timeout_value = scmd->request->timeout / HZ;
>-
>-		if (instance->secure_jbod_support &&
>-			(megasas_cmd_type(scmd) ==
>NON_READ_WRITE_SYSPDIO)) {
>-			/* system pd firmware path */
>-			io_request->Function  =
>-
>	MEGASAS_MPI2_FUNCTION_LD_IO_REQUEST;
>-			cmd->request_desc->SCSIIO.RequestFlags =
>-				(MPI2_REQ_DESCRIPT_FLAGS_SCSI_IO <<
>-
>	MEGASAS_REQ_DESCRIPT_FLAGS_TYPE_SHIFT);
>-			io_request->RaidContext.timeoutValue =
>-				cpu_to_le16(os_timeout_value);
>-		} else {
>-			/* system pd Fast Path */
>-			io_request->Function =
>MPI2_FUNCTION_SCSI_IO_REQUEST;
>-			io_request->RaidContext.regLockFlags = 0;
>-			io_request->RaidContext.regLockRowLBA = 0;
>-			io_request->RaidContext.regLockLength = 0;
>-			timeout_limit = (scmd->device->type == TYPE_DISK)
?
>-					255 : 0xFFFF;
>-			io_request->RaidContext.timeoutValue =
>-				cpu_to_le16((os_timeout_value >
>timeout_limit) ?
>-				timeout_limit : os_timeout_value);
>-		if ((instance->pdev->device == PCI_DEVICE_ID_LSI_INVADER)
>||
>-			(instance->pdev->device ==
>PCI_DEVICE_ID_LSI_FURY))
>-			io_request->IoFlags |=
>-
>	cpu_to_le16(MPI25_SAS_DEVICE0_FLAGS_ENABLED_FAST_PATH);
>-
>-			cmd->request_desc->SCSIIO.RequestFlags =
>-
>	(MPI2_REQ_DESCRIPT_FLAGS_HIGH_PRIORITY <<
>-
>	MEGASAS_REQ_DESCRIPT_FLAGS_TYPE_SHIFT);
>-		}
>-	} else {
>-		if (scmd->device->channel < MEGASAS_MAX_PD_CHANNELS)
>-			goto NonFastPath;
>-
>-		/*
>-		 * For older firmware, Driver should not access
ldTgtIdToLd
>-		 * beyond index 127 and for Extended VD firmware,
>ldTgtIdToLd
>-		 * should not go beyond 255.
>-		 */
>-
>-		if ((!fusion->fast_path_io) ||
>-			(device_id >= instance->fw_supported_vd_count))
>-			goto NonFastPath;
>+	if (fusion->fast_path_io && (
>+		device_id < instance->fw_supported_vd_count)) {
>
> 		ld = MR_TargetIdToLdGet(device_id, local_map_ptr);
>-
> 		if (ld >= instance->fw_supported_vd_count)
>-			goto NonFastPath;
>+			fp_possible = 0;
>
> 		raid = MR_LdRaidGet(ld, local_map_ptr);
>-
>-		/* check if this LD is FP capable */
> 		if (!(raid->capability.fpNonRWCapable))
>-			/* not FP capable, send as non-FP */
>-			goto NonFastPath;
>+			fp_possible = 0;
>+	} else
>+		fp_possible = 0;
>
>-		/* get RAID_Context pointer */
>-		pRAID_Context = &io_request->RaidContext;
>+	if (!fp_possible) {
>+		io_request->Function  =
>MEGASAS_MPI2_FUNCTION_LD_IO_REQUEST;
>+		io_request->DevHandle = cpu_to_le16(device_id);
>+		io_request->LUN[1] = scmd->device->lun;
>+		pRAID_Context->timeoutValue =
>+			cpu_to_le16 (scmd->request->timeout / HZ);
>+		cmd->request_desc->SCSIIO.RequestFlags =
>+			(MPI2_REQ_DESCRIPT_FLAGS_SCSI_IO <<
>+			MEGASAS_REQ_DESCRIPT_FLAGS_TYPE_SHIFT);
>+	} else {
>
> 		/* set RAID context values */
>-		pRAID_Context->regLockFlags     =
>REGION_TYPE_SHARED_READ;
>-		pRAID_Context->timeoutValue     = cpu_to_le16(raid-
>>fpIoTimeoutForLd);
>-		pRAID_Context->VirtualDiskTgtId = cpu_to_le16(device_id);
>-		pRAID_Context->regLockRowLBA    = 0;
>-		pRAID_Context->regLockLength    = 0;
>-		pRAID_Context->configSeqNum     = raid->seqNum;
>+		pRAID_Context->configSeqNum = raid->seqNum;
>+		pRAID_Context->regLockFlags =
>REGION_TYPE_SHARED_READ;
>+		pRAID_Context->timeoutValue = cpu_to_le16(raid-
>>fpIoTimeoutForLd);
>
> 		/* get the DevHandle for the PD (since this is
> 		   fpNonRWCapable, this is a single disk RAID0) */ @@
-1773,7
>+1723,7 @@ megasas_build_dcdb_fusion(struct megasas_instance *instance,
> 		/* build request descriptor */
> 		cmd->request_desc->SCSIIO.RequestFlags =
> 			(MPI2_REQ_DESCRIPT_FLAGS_HIGH_PRIORITY <<
>-			 MEGASAS_REQ_DESCRIPT_FLAGS_TYPE_SHIFT);
>+			MEGASAS_REQ_DESCRIPT_FLAGS_TYPE_SHIFT);
> 		cmd->request_desc->SCSIIO.DevHandle = devHandle;
>
> 		/* populate the LUN field */
>@@ -1782,18 +1732,87 @@ megasas_build_dcdb_fusion(struct
>megasas_instance *instance,
> 		/* build the raidScsiIO structure */
> 		io_request->Function = MPI2_FUNCTION_SCSI_IO_REQUEST;
> 		io_request->DevHandle = devHandle;
>+	}
>+}
>
>-		return;
>+/**
>+ * megasas_build_syspd_fusion - prepares rw/non-rw ios for syspd
>+ * @instance:		Adapter soft state
>+ * @scp:		SCSI command
>+ * @cmd:		Command to be prepared
>+ * @fp_possible:	parameter to detect fast path or firmware path io.
>+ *
>+ * Prepares the io_request frame for rw/non-rw io cmds for syspds  */
>+static void megasas_build_syspd_fusion(struct megasas_instance
>+*instance,
>+	struct scsi_cmnd *scmd, struct megasas_cmd_fusion *cmd, u8
>+fp_possible) {
>+	u32 device_id;
>+	struct MPI2_RAID_SCSI_IO_REQUEST *io_request;
>+	u16 pd_index = 0;
>+	u16 os_timeout_value;
>+	u16 timeout_limit;
>+	struct MR_DRV_RAID_MAP_ALL *local_map_ptr;
>+	struct RAID_CONTEXT	*pRAID_Context;
>+	struct fusion_context *fusion = instance->ctrl_context;
>+
>+	device_id = MEGASAS_DEV_INDEX(scmd);
>+	pd_index = MEGASAS_PD_INDEX(scmd);
>+	os_timeout_value = scmd->request->timeout / HZ;
>
>-NonFastPath:
>+	io_request = cmd->io_request;
>+	/* get RAID_Context pointer */
>+	pRAID_Context = &io_request->RaidContext;
>+	io_request->DataLength = cpu_to_le32(scsi_bufflen(scmd));
>+	io_request->LUN[1] = scmd->device->lun;
>+	pRAID_Context->RAIDFlags =
>MR_RAID_FLAGS_IO_SUB_TYPE_SYSTEM_PD
>+		<< MR_RAID_CTX_RAID_FLAGS_IO_SUB_TYPE_SHIFT;
>+
>+	pRAID_Context->VirtualDiskTgtId = cpu_to_le16(device_id);
>+	pRAID_Context->configSeqNum = 0;
>+	local_map_ptr = fusion->ld_drv_map[(instance->map_id & 1)];
>+	io_request->DevHandle =
>+		local_map_ptr->raidMap.devHndlInfo[device_id].curDevHdl;
>+
>+	cmd->request_desc->SCSIIO.DevHandle = io_request->DevHandle;
>+	cmd->request_desc->SCSIIO.MSIxIndex =
>+		instance->msix_vectors ?
>+		(smp_processor_id() % instance->msix_vectors) : 0;
>+
>+
>+	if (!fp_possible) {
>+		/* system pd firmware path */
> 		io_request->Function  =
>MEGASAS_MPI2_FUNCTION_LD_IO_REQUEST;
>-		io_request->DevHandle = cpu_to_le16(device_id);
> 		cmd->request_desc->SCSIIO.RequestFlags =
> 			(MPI2_REQ_DESCRIPT_FLAGS_SCSI_IO <<
>-			 MEGASAS_REQ_DESCRIPT_FLAGS_TYPE_SHIFT);
>+
>	MEGASAS_REQ_DESCRIPT_FLAGS_TYPE_SHIFT);
>+		pRAID_Context->timeoutValue =
>cpu_to_le16(os_timeout_value);
>+	} else {
>+		/* system pd Fast Path */
>+		io_request->Function = MPI2_FUNCTION_SCSI_IO_REQUEST;
>+		pRAID_Context->regLockFlags = 0;
>+		pRAID_Context->regLockRowLBA = 0;
>+		pRAID_Context->regLockLength = 0;
>+		timeout_limit = (scmd->device->type == TYPE_DISK) ?
>+				255 : 0xFFFF;
>+		pRAID_Context->timeoutValue =
>+			cpu_to_le16((os_timeout_value > timeout_limit) ?
>+			timeout_limit : os_timeout_value);
>+		if ((instance->pdev->device == PCI_DEVICE_ID_LSI_INVADER)
>||
>+			(instance->pdev->device ==
>PCI_DEVICE_ID_LSI_FURY)) {
>+			cmd->request_desc->SCSIIO.RequestFlags |=
>+				(MEGASAS_REQ_DESCRIPT_FLAGS_NO_LOCK
><<
>+
>	MEGASAS_REQ_DESCRIPT_FLAGS_TYPE_SHIFT);
>+			pRAID_Context->Type = MPI2_TYPE_CUDA;
>+			pRAID_Context->nseg = 0x1;
>+			io_request->IoFlags |=
>+
>	cpu_to_le16(MPI25_SAS_DEVICE0_FLAGS_ENABLED_FAST_PATH);
>+		}
>+		cmd->request_desc->SCSIIO.RequestFlags =
>+			(MPI2_REQ_DESCRIPT_FLAGS_HIGH_PRIORITY <<
>+
>	MEGASAS_REQ_DESCRIPT_FLAGS_TYPE_SHIFT);
> 	}
>-	io_request->RaidContext.VirtualDiskTgtId = cpu_to_le16(device_id);
>-	int_to_scsilun(scmd->device->lun, (struct scsi_lun *)io_request-
>>LUN);
> }
>
> /**
>@@ -1810,11 +1829,10 @@ megasas_build_io_fusion(struct
>megasas_instance *instance,
> 			struct scsi_cmnd *scp,
> 			struct megasas_cmd_fusion *cmd)
> {
>-	u32 device_id, sge_count;
>+	u32 sge_count;
>+	u8  cmd_type;
> 	struct MPI2_RAID_SCSI_IO_REQUEST *io_request = cmd-
>>io_request;
>
>-	device_id = MEGASAS_DEV_INDEX(instance, scp);
>-
> 	/* Zero out some fields so they don't get reused */
> 	memset(io_request->LUN, 0x0, 8);
> 	io_request->CDB.EEDP32.PrimaryReferenceTag = 0; @@ -1834,10
>+1852,24 @@ megasas_build_io_fusion(struct megasas_instance *instance,
> 	 */
> 	io_request->IoFlags = cpu_to_le16(scp->cmd_len);
>
>-	if (megasas_cmd_type(scp) == READ_WRITE_LDIO)
>+	switch (cmd_type = megasas_cmd_type(scp)) {
>+	case READ_WRITE_LDIO:
> 		megasas_build_ldio_fusion(instance, scp, cmd);
>-	else
>-		megasas_build_dcdb_fusion(instance, scp, cmd);
>+		break;
>+	case NON_READ_WRITE_LDIO:
>+		megasas_build_ld_nonrw_fusion(instance, scp, cmd);
>+		break;
>+	case READ_WRITE_SYSPDIO:
>+	case NON_READ_WRITE_SYSPDIO:
>+		if (instance->secure_jbod_support &&
>+			(cmd_type == NON_READ_WRITE_SYSPDIO))
>+			megasas_build_syspd_fusion(instance, scp, cmd, 0);
>+		else
>+			megasas_build_syspd_fusion(instance, scp, cmd, 1);
>+		break;
>+	default:
>+		break;
>+	}
>
> 	/*
> 	 * Construct SGL
>@@ -2013,8 +2045,7 @@ complete_cmd_fusion(struct megasas_instance
>*instance, u32 MSIxIndex)
> 		switch (scsi_io_req->Function) {
> 		case MPI2_FUNCTION_SCSI_IO_REQUEST:  /*Fast Path IO.*/
> 			/* Update load balancing info */
>-			device_id = MEGASAS_DEV_INDEX(instance,
>-						      cmd_fusion->scmd);
>+			device_id = MEGASAS_DEV_INDEX(cmd_fusion-
>>scmd);
> 			lbinfo = &fusion->load_balance_info[device_id];
> 			if (cmd_fusion->scmd->SCp.Status &
> 			    MEGASAS_LOAD_BALANCE_FLAG) {
>--
>1.7.1

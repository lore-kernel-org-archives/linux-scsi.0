From: adam radford <aradford@gmail.com>
Subject: Re: [PATCH 1/2] megaraid_sas: Add High Availability clustering
 support using shared Logical Disks
Date: Fri, 6 Sep 2013 15:27:14 -0700
Message-ID: <CAHtARFF1zP18k+N-+LJ54rKOkJuBb09tMaMsZyyBBUzMMZtonw@mail.gmail.com>
References: <CAHtARFGNHZ4u8bKksuRDUokNkxrM3sRXV0woy-Rshang3tpUBA@mail.gmail.com>
	<1378492446.2063.28.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=089e01536d7a59702204e5be8af1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qa0-f48.google.com ([209.85.216.48]:45490 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752971Ab3IFW1P (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Sep 2013 18:27:15 -0400
Received: by mail-qa0-f48.google.com with SMTP id hu16so803024qab.14
        for <linux-scsi@vger.kernel.org>; Fri, 06 Sep 2013 15:27:14 -0700 (PDT)
In-Reply-To: <1378492446.2063.28.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Kashyap Desai <Kashyap.Desai@lsi.com>

--089e01536d7a59702204e5be8af1
Content-Type: text/plain; charset=ISO-8859-1

On 9/6/13, James Bottomley <James.Bottomley@hansenpartnership.com> wrote:
> Checkpatch doesn't like this.  It thinks (correctly) that these should
> all be in megaraid_sas.h so we can't get the prototype different from
> the actual function without some type of warning.  Can you move them,
> please?

James,

Corrected patch is in-line below and also attached to this reply.

Signed-off-by: Adam Radford <aradford@gmail.com>

diff -Naur scsi-misc.old/drivers/scsi/megaraid/megaraid_sas_base.c
scsi-misc.new/drivers/scsi/megaraid/megaraid_sas_base.c
--- scsi-misc.old/drivers/scsi/megaraid/megaraid_sas_base.c	2013-08-31
16:17:56.907172388 -0700
+++ scsi-misc.new/drivers/scsi/megaraid/megaraid_sas_base.c	2013-08-31
16:23:31.077143117 -0700
@@ -92,6 +92,8 @@

 int megasas_transition_to_ready(struct megasas_instance *instance, int ocr);
 static int megasas_get_pd_list(struct megasas_instance *instance);
+static int megasas_ld_list_query(struct megasas_instance *instance,
+				 u8 query_type);
 static int megasas_issue_init_mfi(struct megasas_instance *instance);
 static int megasas_register_aen(struct megasas_instance *instance,
 				u32 seq_num, u32 class_locale_word);
@@ -3271,6 +3273,84 @@
 }

 /**
+ * megasas_ld_list_query -	Returns FW's ld_list structure
+ * @instance:				Adapter soft state
+ * @ld_list:				ld_list structure
+ *
+ * Issues an internal command (DCMD) to get the FW's controller PD
+ * list structure.  This information is mainly used to find out SYSTEM
+ * supported by the FW.
+ */
+static int
+megasas_ld_list_query(struct megasas_instance *instance, u8 query_type)
+{
+	int ret = 0, ld_index = 0, ids = 0;
+	struct megasas_cmd *cmd;
+	struct megasas_dcmd_frame *dcmd;
+	struct MR_LD_TARGETID_LIST *ci;
+	dma_addr_t ci_h = 0;
+
+	cmd = megasas_get_cmd(instance);
+
+	if (!cmd) {
+		printk(KERN_WARNING
+		       "megasas:(megasas_ld_list_query): Failed to get cmd\n");
+		return -ENOMEM;
+	}
+
+	dcmd = &cmd->frame->dcmd;
+
+	ci = pci_alloc_consistent(instance->pdev,
+				  sizeof(struct MR_LD_TARGETID_LIST), &ci_h);
+
+	if (!ci) {
+		printk(KERN_WARNING
+		       "megasas: Failed to alloc mem for ld_list_query\n");
+		megasas_return_cmd(instance, cmd);
+		return -ENOMEM;
+	}
+
+	memset(ci, 0, sizeof(*ci));
+	memset(dcmd->mbox.b, 0, MFI_MBOX_SIZE);
+
+	dcmd->mbox.b[0] = query_type;
+
+	dcmd->cmd = MFI_CMD_DCMD;
+	dcmd->cmd_status = 0xFF;
+	dcmd->sge_count = 1;
+	dcmd->flags = MFI_FRAME_DIR_READ;
+	dcmd->timeout = 0;
+	dcmd->data_xfer_len = sizeof(struct MR_LD_TARGETID_LIST);
+	dcmd->opcode = MR_DCMD_LD_LIST_QUERY;
+	dcmd->sgl.sge32[0].phys_addr = ci_h;
+	dcmd->sgl.sge32[0].length = sizeof(struct MR_LD_TARGETID_LIST);
+	dcmd->pad_0  = 0;
+
+	if (!megasas_issue_polled(instance, cmd) && !dcmd->cmd_status) {
+		ret = 0;
+	} else {
+		/* On failure, call older LD list DCMD */
+		ret = 1;
+	}
+
+	if ((ret == 0) && (ci->count <= (MAX_LOGICAL_DRIVES))) {
+		memset(instance->ld_ids, 0xff, MEGASAS_MAX_LD_IDS);
+		for (ld_index = 0; ld_index < ci->count; ld_index++) {
+			ids = ci->targetId[ld_index];
+			instance->ld_ids[ids] = ci->targetId[ld_index];
+		}
+
+	}
+
+	pci_free_consistent(instance->pdev, sizeof(struct MR_LD_TARGETID_LIST),
+			    ci, ci_h);
+
+	megasas_return_cmd(instance, cmd);
+
+	return ret;
+}
+
+/**
  * megasas_get_controller_info -	Returns FW's controller structure
  * @instance:				Adapter soft state
  * @ctrl_info:				Controller information structure
@@ -3648,7 +3728,9 @@
 	megasas_get_pd_list(instance);

 	memset(instance->ld_ids, 0xff, MEGASAS_MAX_LD_IDS);
-	megasas_get_ld_list(instance);
+	if (megasas_ld_list_query(instance,
+				  MR_LD_QUERY_TYPE_EXPOSED_TO_HOST))
+		megasas_get_ld_list(instance);

 	ctrl_info = kmalloc(sizeof(struct megasas_ctrl_info), GFP_KERNEL);

@@ -5389,7 +5471,9 @@
 		case MR_EVT_LD_OFFLINE:
 		case MR_EVT_CFG_CLEARED:
 		case MR_EVT_LD_DELETED:
-			megasas_get_ld_list(instance);
+			if (megasas_ld_list_query(instance,
+					MR_LD_QUERY_TYPE_EXPOSED_TO_HOST))
+				megasas_get_ld_list(instance);
 			for (i = 0; i < MEGASAS_MAX_LD_CHANNELS; i++) {
 				for (j = 0;
 				j < MEGASAS_MAX_DEV_PER_CHANNEL;
@@ -5399,7 +5483,7 @@
 				(i * MEGASAS_MAX_DEV_PER_CHANNEL) + j;

 				sdev1 = scsi_device_lookup(host,
-					i + MEGASAS_MAX_LD_CHANNELS,
+					MEGASAS_MAX_PD_CHANNELS + i,
 					j,
 					0);

@@ -5418,7 +5502,9 @@
 			doscan = 0;
 			break;
 		case MR_EVT_LD_CREATED:
-			megasas_get_ld_list(instance);
+			if (megasas_ld_list_query(instance,
+					MR_LD_QUERY_TYPE_EXPOSED_TO_HOST))
+				megasas_get_ld_list(instance);
 			for (i = 0; i < MEGASAS_MAX_LD_CHANNELS; i++) {
 				for (j = 0;
 					j < MEGASAS_MAX_DEV_PER_CHANNEL;
@@ -5427,14 +5513,14 @@
 					(i * MEGASAS_MAX_DEV_PER_CHANNEL) + j;

 					sdev1 = scsi_device_lookup(host,
-						i+MEGASAS_MAX_LD_CHANNELS,
+						MEGASAS_MAX_PD_CHANNELS + i,
 						j, 0);

 					if (instance->ld_ids[ld_index] !=
 								0xff) {
 						if (!sdev1) {
 							scsi_add_device(host,
-								i + 2,
+						MEGASAS_MAX_PD_CHANNELS + i,
 								j, 0);
 						}
 					}
@@ -5483,18 +5569,20 @@
 			}
 		}

-		megasas_get_ld_list(instance);
+		if (megasas_ld_list_query(instance,
+					  MR_LD_QUERY_TYPE_EXPOSED_TO_HOST))
+			megasas_get_ld_list(instance);
 		for (i = 0; i < MEGASAS_MAX_LD_CHANNELS; i++) {
 			for (j = 0; j < MEGASAS_MAX_DEV_PER_CHANNEL; j++) {
 				ld_index =
 				(i * MEGASAS_MAX_DEV_PER_CHANNEL) + j;

 				sdev1 = scsi_device_lookup(host,
-					i+MEGASAS_MAX_LD_CHANNELS, j, 0);
+					MEGASAS_MAX_PD_CHANNELS + i, j, 0);
 				if (instance->ld_ids[ld_index] != 0xff) {
 					if (!sdev1) {
 						scsi_add_device(host,
-								i+2,
+						MEGASAS_MAX_PD_CHANNELS + i,
 								j, 0);
 					} else {
 						scsi_device_put(sdev1);
diff -Naur scsi-misc.old/drivers/scsi/megaraid/megaraid_sas_fp.c
scsi-misc.new/drivers/scsi/megaraid/megaraid_sas_fp.c
--- scsi-misc.old/drivers/scsi/megaraid/megaraid_sas_fp.c	2013-08-31
16:17:56.908172637 -0700
+++ scsi-misc.new/drivers/scsi/megaraid/megaraid_sas_fp.c	2013-08-31
16:23:31.078140743 -0700
@@ -126,17 +126,17 @@
 	return map->raidMap.ldSpanMap[ld].dataArmMap[armIdx];
 }

-static u16 MR_ArPdGet(u32 ar, u32 arm, struct MR_FW_RAID_MAP_ALL *map)
+u16 MR_ArPdGet(u32 ar, u32 arm, struct MR_FW_RAID_MAP_ALL *map)
 {
 	return map->raidMap.arMapInfo[ar].pd[arm];
 }

-static u16 MR_LdSpanArrayGet(u32 ld, u32 span, struct MR_FW_RAID_MAP_ALL *map)
+u16 MR_LdSpanArrayGet(u32 ld, u32 span, struct MR_FW_RAID_MAP_ALL *map)
 {
 	return map->raidMap.ldSpanMap[ld].spanBlock[span].span.arrayRef;
 }

-static u16 MR_PdDevHandleGet(u32 pd, struct MR_FW_RAID_MAP_ALL *map)
+u16 MR_PdDevHandleGet(u32 pd, struct MR_FW_RAID_MAP_ALL *map)
 {
 	return map->raidMap.devHndlInfo[pd].curDevHdl;
 }
@@ -784,7 +784,7 @@
 MR_BuildRaidContext(struct megasas_instance *instance,
 		    struct IO_REQUEST_INFO *io_info,
 		    struct RAID_CONTEXT *pRAID_Context,
-		    struct MR_FW_RAID_MAP_ALL *map)
+		    struct MR_FW_RAID_MAP_ALL *map, u8 **raidLUN)
 {
 	struct MR_LD_RAID  *raid;
 	u32         ld, stripSize, stripe_mask;
@@ -977,6 +977,9 @@
 	pRAID_Context->regLockRowLBA    = regStart;
 	pRAID_Context->regLockLength    = regSize;
 	pRAID_Context->configSeqNum	= raid->seqNum;
+	/* save pointer to raid->LUN array */
+	*raidLUN = raid->LUN;
+

 	/*Get Phy Params only if FP capable, or else leave it to MR firmware
 	  to do the calculation.*/
diff -Naur scsi-misc.old/drivers/scsi/megaraid/megaraid_sas_fusion.c
scsi-misc.new/drivers/scsi/megaraid/megaraid_sas_fusion.c
--- scsi-misc.old/drivers/scsi/megaraid/megaraid_sas_fusion.c	2013-08-31
16:17:56.909172648 -0700
+++ scsi-misc.new/drivers/scsi/megaraid/megaraid_sas_fusion.c	2013-09-06
15:03:03.716212168 -0700
@@ -72,17 +72,6 @@
 int
 megasas_issue_polled(struct megasas_instance *instance,
 		     struct megasas_cmd *cmd);
-
-u8
-MR_BuildRaidContext(struct megasas_instance *instance,
-		    struct IO_REQUEST_INFO *io_info,
-		    struct RAID_CONTEXT *pRAID_Context,
-		    struct MR_FW_RAID_MAP_ALL *map);
-u16 MR_TargetIdToLdGet(u32 ldTgtId, struct MR_FW_RAID_MAP_ALL *map);
-struct MR_LD_RAID *MR_LdRaidGet(u32 ld, struct MR_FW_RAID_MAP_ALL *map);
-
-u16 MR_GetLDTgtId(u32 ld, struct MR_FW_RAID_MAP_ALL *map);
-
 void
 megasas_check_and_restore_queue_depth(struct megasas_instance *instance);

@@ -652,6 +641,10 @@
 		(instance->pdev->device == PCI_DEVICE_ID_LSI_FURY))
 		init_frame->driver_operations.
 			mfi_capabilities.support_additional_msix = 1;
+	/* driver supports HA / Remote LUN over Fast Path interface */
+	init_frame->driver_operations.mfi_capabilities.support_fp_remote_lun
+		= 1;
+

 	init_frame->queue_info_new_phys_addr_lo = ioc_init_handle;
 	init_frame->data_xfer_len = sizeof(struct MPI2_IOC_INIT_REQUEST);
@@ -1410,6 +1403,7 @@
 	struct IO_REQUEST_INFO io_info;
 	struct fusion_context *fusion;
 	struct MR_FW_RAID_MAP_ALL *local_map_ptr;
+	u8 *raidLUN;

 	device_id = MEGASAS_DEV_INDEX(instance, scp);

@@ -1494,7 +1488,7 @@
 	} else {
 		if (MR_BuildRaidContext(instance, &io_info,
 					&io_request->RaidContext,
-					local_map_ptr))
+					local_map_ptr, &raidLUN))
 			fp_possible = io_info.fpOkForIo;
 	}

@@ -1537,6 +1531,8 @@
 			scp->SCp.Status &= ~MEGASAS_LOAD_BALANCE_FLAG;
 		cmd->request_desc->SCSIIO.DevHandle = io_info.devHandle;
 		io_request->DevHandle = io_info.devHandle;
+		/* populate the LUN field */
+		memcpy(io_request->LUN, raidLUN, 8);
 	} else {
 		io_request->RaidContext.timeoutValue =
 			local_map_ptr->raidMap.fpPdIoTimeoutSec;
@@ -1579,6 +1575,11 @@
 	u16 pd_index = 0;
 	struct MR_FW_RAID_MAP_ALL *local_map_ptr;
 	struct fusion_context *fusion = instance->ctrl_context;
+	u8                          span, physArm;
+	u16                         devHandle;
+	u32                         ld, arRef, pd;
+	struct MR_LD_RAID                  *raid;
+	struct RAID_CONTEXT                *pRAID_Context;

 	io_request = cmd->io_request;
 	device_id = MEGASAS_DEV_INDEX(instance, scmd);
@@ -1586,6 +1587,9 @@
 		+scmd->device->id;
 	local_map_ptr = fusion->ld_map[(instance->map_id & 1)];

+	io_request->DataLength = scsi_bufflen(scmd);
+
+
 	/* Check if this is a system PD I/O */
 	if (scmd->device->channel < MEGASAS_MAX_PD_CHANNELS &&
 	    instance->pd_list[pd_index].driveState == MR_PD_STATE_SYSTEM) {
@@ -1623,6 +1627,54 @@
 					scmd->request->timeout / HZ;
 		}
 	} else {
+		if (scmd->device->channel < MEGASAS_MAX_PD_CHANNELS)
+			goto NonFastPath;
+
+		ld = MR_TargetIdToLdGet(device_id, local_map_ptr);
+		if ((ld >= MAX_LOGICAL_DRIVES) || (!fusion->fast_path_io))
+			goto NonFastPath;
+
+		raid = MR_LdRaidGet(ld, local_map_ptr);
+
+		/* check if this LD is FP capable */
+		if (!(raid->capability.fpNonRWCapable))
+			/* not FP capable, send as non-FP */
+			goto NonFastPath;
+
+		/* get RAID_Context pointer */
+		pRAID_Context = &io_request->RaidContext;
+
+		/* set RAID context values */
+		pRAID_Context->regLockFlags     = REGION_TYPE_SHARED_READ;
+		pRAID_Context->timeoutValue     = raid->fpIoTimeoutForLd;
+		pRAID_Context->VirtualDiskTgtId = device_id;
+		pRAID_Context->regLockRowLBA    = 0;
+		pRAID_Context->regLockLength    = 0;
+		pRAID_Context->configSeqNum     = raid->seqNum;
+
+		/* get the DevHandle for the PD (since this is
+		   fpNonRWCapable, this is a single disk RAID0) */
+		span = physArm = 0;
+		arRef = MR_LdSpanArrayGet(ld, span, local_map_ptr);
+		pd = MR_ArPdGet(arRef, physArm, local_map_ptr);
+		devHandle = MR_PdDevHandleGet(pd, local_map_ptr);
+
+		/* build request descriptor */
+		cmd->request_desc->SCSIIO.RequestFlags =
+			(MPI2_REQ_DESCRIPT_FLAGS_HIGH_PRIORITY <<
+			 MEGASAS_REQ_DESCRIPT_FLAGS_TYPE_SHIFT);
+		cmd->request_desc->SCSIIO.DevHandle = devHandle;
+
+		/* populate the LUN field */
+		memcpy(io_request->LUN, raid->LUN, 8);
+
+		/* build the raidScsiIO structure */
+		io_request->Function = MPI2_FUNCTION_SCSI_IO_REQUEST;
+		io_request->DevHandle = devHandle;
+
+		return;
+
+NonFastPath:
 		io_request->Function  = MEGASAS_MPI2_FUNCTION_LD_IO_REQUEST;
 		io_request->DevHandle = device_id;
 		cmd->request_desc->SCSIIO.RequestFlags =
@@ -1631,7 +1683,6 @@
 	}
 	io_request->RaidContext.VirtualDiskTgtId = device_id;
 	io_request->LUN[1] = scmd->device->lun;
-	io_request->DataLength = scsi_bufflen(scmd);
 }

 /**
diff -Naur scsi-misc.old/drivers/scsi/megaraid/megaraid_sas_fusion.h
scsi-misc.new/drivers/scsi/megaraid/megaraid_sas_fusion.h
--- scsi-misc.old/drivers/scsi/megaraid/megaraid_sas_fusion.h	2013-08-31
16:17:56.909172648 -0700
+++ scsi-misc.new/drivers/scsi/megaraid/megaraid_sas_fusion.h	2013-08-31
16:23:31.079140393 -0700
@@ -527,7 +527,8 @@
 		u32     fpReadCapable:1;
 		u32     fpWriteAcrossStripe:1;
 		u32     fpReadAcrossStripe:1;
-		u32     reserved4:8;
+		u32	fpNonRWCapable:1;
+		u32     reserved4:7;
 	} capability;
 	u32     reserved6;
 	u64     size;
@@ -551,7 +552,9 @@
 		u32 reserved:31;
 	} flags;

-	u8      reserved3[0x5C];
+	u8	LUN[8]; /* 0x24 8 byte LUN field used for SCSI IO's */
+	u8	fpIoTimeoutForLd;/*0x2C timeout value used by driver in FP IO*/
+	u8      reserved3[0x80-0x2D]; /* 0x2D */
 };

 struct MR_LD_SPAN_MAP {
diff -Naur scsi-misc.old/drivers/scsi/megaraid/megaraid_sas.h
scsi-misc.new/drivers/scsi/megaraid/megaraid_sas.h
--- scsi-misc.old/drivers/scsi/megaraid/megaraid_sas.h	2013-08-31
16:17:56.910114725 -0700
+++ scsi-misc.new/drivers/scsi/megaraid/megaraid_sas.h	2013-09-06
15:02:53.205212389 -0700
@@ -170,6 +170,7 @@

 #define MR_DCMD_CTRL_GET_INFO			0x01010000
 #define MR_DCMD_LD_GET_LIST			0x03010000
+#define MR_DCMD_LD_LIST_QUERY			0x03010100

 #define MR_DCMD_CTRL_CACHE_FLUSH		0x01101000
 #define MR_FLUSH_CTRL_CACHE			0x01
@@ -345,6 +346,15 @@
 	MR_PD_QUERY_TYPE_EXPOSED_TO_HOST    = 5,
 };

+enum MR_LD_QUERY_TYPE {
+	MR_LD_QUERY_TYPE_ALL	         = 0,
+	MR_LD_QUERY_TYPE_EXPOSED_TO_HOST = 1,
+	MR_LD_QUERY_TYPE_USED_TGT_IDS    = 2,
+	MR_LD_QUERY_TYPE_CLUSTER_ACCESS  = 3,
+	MR_LD_QUERY_TYPE_CLUSTER_LOCALE  = 4,
+};
+
+
 #define MR_EVT_CFG_CLEARED                              0x0004
 #define MR_EVT_LD_STATE_CHANGE                          0x0051
 #define MR_EVT_PD_INSERTED                              0x005b
@@ -435,6 +445,14 @@
 	} ldList[MAX_LOGICAL_DRIVES];
 } __packed;

+struct MR_LD_TARGETID_LIST {
+	u32	size;
+	u32	count;
+	u8	pad[3];
+	u8	targetId[MAX_LOGICAL_DRIVES];
+};
+
+
 /*
  * SAS controller properties
  */
@@ -863,7 +881,7 @@
  * ===============================
  */
 #define MEGASAS_MAX_PD_CHANNELS			2
-#define MEGASAS_MAX_LD_CHANNELS			2
+#define MEGASAS_MAX_LD_CHANNELS			1
 #define MEGASAS_MAX_CHANNELS			(MEGASAS_MAX_PD_CHANNELS + \
 						MEGASAS_MAX_LD_CHANNELS)
 #define MEGASAS_MAX_DEV_PER_CHANNEL		128
@@ -1656,4 +1674,16 @@
 	int max_index;
 };

+u8
+MR_BuildRaidContext(struct megasas_instance *instance,
+		    struct IO_REQUEST_INFO *io_info,
+		    struct RAID_CONTEXT *pRAID_Context,
+		    struct MR_FW_RAID_MAP_ALL *map, u8 **raidLUN);
+u16 MR_TargetIdToLdGet(u32 ldTgtId, struct MR_FW_RAID_MAP_ALL *map);
+struct MR_LD_RAID *MR_LdRaidGet(u32 ld, struct MR_FW_RAID_MAP_ALL *map);
+u16 MR_ArPdGet(u32 ar, u32 arm, struct MR_FW_RAID_MAP_ALL *map);
+u16 MR_LdSpanArrayGet(u32 ld, u32 span, struct MR_FW_RAID_MAP_ALL *map);
+u16 MR_PdDevHandleGet(u32 pd, struct MR_FW_RAID_MAP_ALL *map);
+u16 MR_GetLDTgtId(u32 ld, struct MR_FW_RAID_MAP_ALL *map);
+
 #endif				/*LSI_MEGARAID_SAS_H */

--089e01536d7a59702204e5be8af1
Content-Type: application/octet-stream; name="megaraid_sas.patch1"
Content-Disposition: attachment; filename="megaraid_sas.patch1"
Content-Transfer-Encoding: base64
X-Attachment-Id: file0

ZGlmZiAtTmF1ciBzY3NpLW1pc2Mub2xkL2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9z
YXNfYmFzZS5jIHNjc2ktbWlzYy5uZXcvZHJpdmVycy9zY3NpL21lZ2FyYWlkL21lZ2FyYWlkX3Nh
c19iYXNlLmMKLS0tIHNjc2ktbWlzYy5vbGQvZHJpdmVycy9zY3NpL21lZ2FyYWlkL21lZ2FyYWlk
X3Nhc19iYXNlLmMJMjAxMy0wOC0zMSAxNjoxNzo1Ni45MDcxNzIzODggLTA3MDAKKysrIHNjc2kt
bWlzYy5uZXcvZHJpdmVycy9zY3NpL21lZ2FyYWlkL21lZ2FyYWlkX3Nhc19iYXNlLmMJMjAxMy0w
OC0zMSAxNjoyMzozMS4wNzcxNDMxMTcgLTA3MDAKQEAgLTkyLDYgKzkyLDggQEAKIAogaW50IG1l
Z2FzYXNfdHJhbnNpdGlvbl90b19yZWFkeShzdHJ1Y3QgbWVnYXNhc19pbnN0YW5jZSAqaW5zdGFu
Y2UsIGludCBvY3IpOwogc3RhdGljIGludCBtZWdhc2FzX2dldF9wZF9saXN0KHN0cnVjdCBtZWdh
c2FzX2luc3RhbmNlICppbnN0YW5jZSk7CitzdGF0aWMgaW50IG1lZ2FzYXNfbGRfbGlzdF9xdWVy
eShzdHJ1Y3QgbWVnYXNhc19pbnN0YW5jZSAqaW5zdGFuY2UsCisJCQkJIHU4IHF1ZXJ5X3R5cGUp
Owogc3RhdGljIGludCBtZWdhc2FzX2lzc3VlX2luaXRfbWZpKHN0cnVjdCBtZWdhc2FzX2luc3Rh
bmNlICppbnN0YW5jZSk7CiBzdGF0aWMgaW50IG1lZ2FzYXNfcmVnaXN0ZXJfYWVuKHN0cnVjdCBt
ZWdhc2FzX2luc3RhbmNlICppbnN0YW5jZSwKIAkJCQl1MzIgc2VxX251bSwgdTMyIGNsYXNzX2xv
Y2FsZV93b3JkKTsKQEAgLTMyNzEsNiArMzI3Myw4NCBAQAogfQogCiAvKioKKyAqIG1lZ2FzYXNf
bGRfbGlzdF9xdWVyeSAtCVJldHVybnMgRlcncyBsZF9saXN0IHN0cnVjdHVyZQorICogQGluc3Rh
bmNlOgkJCQlBZGFwdGVyIHNvZnQgc3RhdGUKKyAqIEBsZF9saXN0OgkJCQlsZF9saXN0IHN0cnVj
dHVyZQorICoKKyAqIElzc3VlcyBhbiBpbnRlcm5hbCBjb21tYW5kIChEQ01EKSB0byBnZXQgdGhl
IEZXJ3MgY29udHJvbGxlciBQRAorICogbGlzdCBzdHJ1Y3R1cmUuICBUaGlzIGluZm9ybWF0aW9u
IGlzIG1haW5seSB1c2VkIHRvIGZpbmQgb3V0IFNZU1RFTQorICogc3VwcG9ydGVkIGJ5IHRoZSBG
Vy4KKyAqLworc3RhdGljIGludAorbWVnYXNhc19sZF9saXN0X3F1ZXJ5KHN0cnVjdCBtZWdhc2Fz
X2luc3RhbmNlICppbnN0YW5jZSwgdTggcXVlcnlfdHlwZSkKK3sKKwlpbnQgcmV0ID0gMCwgbGRf
aW5kZXggPSAwLCBpZHMgPSAwOworCXN0cnVjdCBtZWdhc2FzX2NtZCAqY21kOworCXN0cnVjdCBt
ZWdhc2FzX2RjbWRfZnJhbWUgKmRjbWQ7CisJc3RydWN0IE1SX0xEX1RBUkdFVElEX0xJU1QgKmNp
OworCWRtYV9hZGRyX3QgY2lfaCA9IDA7CisKKwljbWQgPSBtZWdhc2FzX2dldF9jbWQoaW5zdGFu
Y2UpOworCisJaWYgKCFjbWQpIHsKKwkJcHJpbnRrKEtFUk5fV0FSTklORworCQkgICAgICAgIm1l
Z2FzYXM6KG1lZ2FzYXNfbGRfbGlzdF9xdWVyeSk6IEZhaWxlZCB0byBnZXQgY21kXG4iKTsKKwkJ
cmV0dXJuIC1FTk9NRU07CisJfQorCisJZGNtZCA9ICZjbWQtPmZyYW1lLT5kY21kOworCisJY2kg
PSBwY2lfYWxsb2NfY29uc2lzdGVudChpbnN0YW5jZS0+cGRldiwKKwkJCQkgIHNpemVvZihzdHJ1
Y3QgTVJfTERfVEFSR0VUSURfTElTVCksICZjaV9oKTsKKworCWlmICghY2kpIHsKKwkJcHJpbnRr
KEtFUk5fV0FSTklORworCQkgICAgICAgIm1lZ2FzYXM6IEZhaWxlZCB0byBhbGxvYyBtZW0gZm9y
IGxkX2xpc3RfcXVlcnlcbiIpOworCQltZWdhc2FzX3JldHVybl9jbWQoaW5zdGFuY2UsIGNtZCk7
CisJCXJldHVybiAtRU5PTUVNOworCX0KKworCW1lbXNldChjaSwgMCwgc2l6ZW9mKCpjaSkpOwor
CW1lbXNldChkY21kLT5tYm94LmIsIDAsIE1GSV9NQk9YX1NJWkUpOworCisJZGNtZC0+bWJveC5i
WzBdID0gcXVlcnlfdHlwZTsKKworCWRjbWQtPmNtZCA9IE1GSV9DTURfRENNRDsKKwlkY21kLT5j
bWRfc3RhdHVzID0gMHhGRjsKKwlkY21kLT5zZ2VfY291bnQgPSAxOworCWRjbWQtPmZsYWdzID0g
TUZJX0ZSQU1FX0RJUl9SRUFEOworCWRjbWQtPnRpbWVvdXQgPSAwOworCWRjbWQtPmRhdGFfeGZl
cl9sZW4gPSBzaXplb2Yoc3RydWN0IE1SX0xEX1RBUkdFVElEX0xJU1QpOworCWRjbWQtPm9wY29k
ZSA9IE1SX0RDTURfTERfTElTVF9RVUVSWTsKKwlkY21kLT5zZ2wuc2dlMzJbMF0ucGh5c19hZGRy
ID0gY2lfaDsKKwlkY21kLT5zZ2wuc2dlMzJbMF0ubGVuZ3RoID0gc2l6ZW9mKHN0cnVjdCBNUl9M
RF9UQVJHRVRJRF9MSVNUKTsKKwlkY21kLT5wYWRfMCAgPSAwOworCisJaWYgKCFtZWdhc2FzX2lz
c3VlX3BvbGxlZChpbnN0YW5jZSwgY21kKSAmJiAhZGNtZC0+Y21kX3N0YXR1cykgeworCQlyZXQg
PSAwOworCX0gZWxzZSB7CisJCS8qIE9uIGZhaWx1cmUsIGNhbGwgb2xkZXIgTEQgbGlzdCBEQ01E
ICovCisJCXJldCA9IDE7CisJfQorCisJaWYgKChyZXQgPT0gMCkgJiYgKGNpLT5jb3VudCA8PSAo
TUFYX0xPR0lDQUxfRFJJVkVTKSkpIHsKKwkJbWVtc2V0KGluc3RhbmNlLT5sZF9pZHMsIDB4ZmYs
IE1FR0FTQVNfTUFYX0xEX0lEUyk7CisJCWZvciAobGRfaW5kZXggPSAwOyBsZF9pbmRleCA8IGNp
LT5jb3VudDsgbGRfaW5kZXgrKykgeworCQkJaWRzID0gY2ktPnRhcmdldElkW2xkX2luZGV4XTsK
KwkJCWluc3RhbmNlLT5sZF9pZHNbaWRzXSA9IGNpLT50YXJnZXRJZFtsZF9pbmRleF07CisJCX0K
KworCX0KKworCXBjaV9mcmVlX2NvbnNpc3RlbnQoaW5zdGFuY2UtPnBkZXYsIHNpemVvZihzdHJ1
Y3QgTVJfTERfVEFSR0VUSURfTElTVCksCisJCQkgICAgY2ksIGNpX2gpOworCisJbWVnYXNhc19y
ZXR1cm5fY21kKGluc3RhbmNlLCBjbWQpOworCisJcmV0dXJuIHJldDsKK30KKworLyoqCiAgKiBt
ZWdhc2FzX2dldF9jb250cm9sbGVyX2luZm8gLQlSZXR1cm5zIEZXJ3MgY29udHJvbGxlciBzdHJ1
Y3R1cmUKICAqIEBpbnN0YW5jZToJCQkJQWRhcHRlciBzb2Z0IHN0YXRlCiAgKiBAY3RybF9pbmZv
OgkJCQlDb250cm9sbGVyIGluZm9ybWF0aW9uIHN0cnVjdHVyZQpAQCAtMzY0OCw3ICszNzI4LDkg
QEAKIAltZWdhc2FzX2dldF9wZF9saXN0KGluc3RhbmNlKTsKIAogCW1lbXNldChpbnN0YW5jZS0+
bGRfaWRzLCAweGZmLCBNRUdBU0FTX01BWF9MRF9JRFMpOwotCW1lZ2FzYXNfZ2V0X2xkX2xpc3Qo
aW5zdGFuY2UpOworCWlmIChtZWdhc2FzX2xkX2xpc3RfcXVlcnkoaW5zdGFuY2UsCisJCQkJICBN
Ul9MRF9RVUVSWV9UWVBFX0VYUE9TRURfVE9fSE9TVCkpCisJCW1lZ2FzYXNfZ2V0X2xkX2xpc3Qo
aW5zdGFuY2UpOwogCiAJY3RybF9pbmZvID0ga21hbGxvYyhzaXplb2Yoc3RydWN0IG1lZ2FzYXNf
Y3RybF9pbmZvKSwgR0ZQX0tFUk5FTCk7CiAKQEAgLTUzODksNyArNTQ3MSw5IEBACiAJCWNhc2Ug
TVJfRVZUX0xEX09GRkxJTkU6CiAJCWNhc2UgTVJfRVZUX0NGR19DTEVBUkVEOgogCQljYXNlIE1S
X0VWVF9MRF9ERUxFVEVEOgotCQkJbWVnYXNhc19nZXRfbGRfbGlzdChpbnN0YW5jZSk7CisJCQlp
ZiAobWVnYXNhc19sZF9saXN0X3F1ZXJ5KGluc3RhbmNlLAorCQkJCQlNUl9MRF9RVUVSWV9UWVBF
X0VYUE9TRURfVE9fSE9TVCkpCisJCQkJbWVnYXNhc19nZXRfbGRfbGlzdChpbnN0YW5jZSk7CiAJ
CQlmb3IgKGkgPSAwOyBpIDwgTUVHQVNBU19NQVhfTERfQ0hBTk5FTFM7IGkrKykgewogCQkJCWZv
ciAoaiA9IDA7CiAJCQkJaiA8IE1FR0FTQVNfTUFYX0RFVl9QRVJfQ0hBTk5FTDsKQEAgLTUzOTks
NyArNTQ4Myw3IEBACiAJCQkJKGkgKiBNRUdBU0FTX01BWF9ERVZfUEVSX0NIQU5ORUwpICsgajsK
IAogCQkJCXNkZXYxID0gc2NzaV9kZXZpY2VfbG9va3VwKGhvc3QsCi0JCQkJCWkgKyBNRUdBU0FT
X01BWF9MRF9DSEFOTkVMUywKKwkJCQkJTUVHQVNBU19NQVhfUERfQ0hBTk5FTFMgKyBpLAogCQkJ
CQlqLAogCQkJCQkwKTsKIApAQCAtNTQxOCw3ICs1NTAyLDkgQEAKIAkJCWRvc2NhbiA9IDA7CiAJ
CQlicmVhazsKIAkJY2FzZSBNUl9FVlRfTERfQ1JFQVRFRDoKLQkJCW1lZ2FzYXNfZ2V0X2xkX2xp
c3QoaW5zdGFuY2UpOworCQkJaWYgKG1lZ2FzYXNfbGRfbGlzdF9xdWVyeShpbnN0YW5jZSwKKwkJ
CQkJTVJfTERfUVVFUllfVFlQRV9FWFBPU0VEX1RPX0hPU1QpKQorCQkJCW1lZ2FzYXNfZ2V0X2xk
X2xpc3QoaW5zdGFuY2UpOwogCQkJZm9yIChpID0gMDsgaSA8IE1FR0FTQVNfTUFYX0xEX0NIQU5O
RUxTOyBpKyspIHsKIAkJCQlmb3IgKGogPSAwOwogCQkJCQlqIDwgTUVHQVNBU19NQVhfREVWX1BF
Ul9DSEFOTkVMOwpAQCAtNTQyNywxNCArNTUxMywxNCBAQAogCQkJCQkoaSAqIE1FR0FTQVNfTUFY
X0RFVl9QRVJfQ0hBTk5FTCkgKyBqOwogCiAJCQkJCXNkZXYxID0gc2NzaV9kZXZpY2VfbG9va3Vw
KGhvc3QsCi0JCQkJCQlpK01FR0FTQVNfTUFYX0xEX0NIQU5ORUxTLAorCQkJCQkJTUVHQVNBU19N
QVhfUERfQ0hBTk5FTFMgKyBpLAogCQkJCQkJaiwgMCk7CiAKIAkJCQkJaWYgKGluc3RhbmNlLT5s
ZF9pZHNbbGRfaW5kZXhdICE9CiAJCQkJCQkJCTB4ZmYpIHsKIAkJCQkJCWlmICghc2RldjEpIHsK
IAkJCQkJCQlzY3NpX2FkZF9kZXZpY2UoaG9zdCwKLQkJCQkJCQkJaSArIDIsCisJCQkJCQlNRUdB
U0FTX01BWF9QRF9DSEFOTkVMUyArIGksCiAJCQkJCQkJCWosIDApOwogCQkJCQkJfQogCQkJCQl9
CkBAIC01NDgzLDE4ICs1NTY5LDIwIEBACiAJCQl9CiAJCX0KIAotCQltZWdhc2FzX2dldF9sZF9s
aXN0KGluc3RhbmNlKTsKKwkJaWYgKG1lZ2FzYXNfbGRfbGlzdF9xdWVyeShpbnN0YW5jZSwKKwkJ
CQkJICBNUl9MRF9RVUVSWV9UWVBFX0VYUE9TRURfVE9fSE9TVCkpCisJCQltZWdhc2FzX2dldF9s
ZF9saXN0KGluc3RhbmNlKTsKIAkJZm9yIChpID0gMDsgaSA8IE1FR0FTQVNfTUFYX0xEX0NIQU5O
RUxTOyBpKyspIHsKIAkJCWZvciAoaiA9IDA7IGogPCBNRUdBU0FTX01BWF9ERVZfUEVSX0NIQU5O
RUw7IGorKykgewogCQkJCWxkX2luZGV4ID0KIAkJCQkoaSAqIE1FR0FTQVNfTUFYX0RFVl9QRVJf
Q0hBTk5FTCkgKyBqOwogCiAJCQkJc2RldjEgPSBzY3NpX2RldmljZV9sb29rdXAoaG9zdCwKLQkJ
CQkJaStNRUdBU0FTX01BWF9MRF9DSEFOTkVMUywgaiwgMCk7CisJCQkJCU1FR0FTQVNfTUFYX1BE
X0NIQU5ORUxTICsgaSwgaiwgMCk7CiAJCQkJaWYgKGluc3RhbmNlLT5sZF9pZHNbbGRfaW5kZXhd
ICE9IDB4ZmYpIHsKIAkJCQkJaWYgKCFzZGV2MSkgewogCQkJCQkJc2NzaV9hZGRfZGV2aWNlKGhv
c3QsCi0JCQkJCQkJCWkrMiwKKwkJCQkJCU1FR0FTQVNfTUFYX1BEX0NIQU5ORUxTICsgaSwKIAkJ
CQkJCQkJaiwgMCk7CiAJCQkJCX0gZWxzZSB7CiAJCQkJCQlzY3NpX2RldmljZV9wdXQoc2RldjEp
OwpkaWZmIC1OYXVyIHNjc2ktbWlzYy5vbGQvZHJpdmVycy9zY3NpL21lZ2FyYWlkL21lZ2FyYWlk
X3Nhc19mcC5jIHNjc2ktbWlzYy5uZXcvZHJpdmVycy9zY3NpL21lZ2FyYWlkL21lZ2FyYWlkX3Nh
c19mcC5jCi0tLSBzY3NpLW1pc2Mub2xkL2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9z
YXNfZnAuYwkyMDEzLTA4LTMxIDE2OjE3OjU2LjkwODE3MjYzNyAtMDcwMAorKysgc2NzaS1taXNj
Lm5ldy9kcml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVnYXJhaWRfc2FzX2ZwLmMJMjAxMy0wOC0zMSAx
NjoyMzozMS4wNzgxNDA3NDMgLTA3MDAKQEAgLTEyNiwxNyArMTI2LDE3IEBACiAJcmV0dXJuIG1h
cC0+cmFpZE1hcC5sZFNwYW5NYXBbbGRdLmRhdGFBcm1NYXBbYXJtSWR4XTsKIH0KIAotc3RhdGlj
IHUxNiBNUl9BclBkR2V0KHUzMiBhciwgdTMyIGFybSwgc3RydWN0IE1SX0ZXX1JBSURfTUFQX0FM
TCAqbWFwKQordTE2IE1SX0FyUGRHZXQodTMyIGFyLCB1MzIgYXJtLCBzdHJ1Y3QgTVJfRldfUkFJ
RF9NQVBfQUxMICptYXApCiB7CiAJcmV0dXJuIG1hcC0+cmFpZE1hcC5hck1hcEluZm9bYXJdLnBk
W2FybV07CiB9CiAKLXN0YXRpYyB1MTYgTVJfTGRTcGFuQXJyYXlHZXQodTMyIGxkLCB1MzIgc3Bh
biwgc3RydWN0IE1SX0ZXX1JBSURfTUFQX0FMTCAqbWFwKQordTE2IE1SX0xkU3BhbkFycmF5R2V0
KHUzMiBsZCwgdTMyIHNwYW4sIHN0cnVjdCBNUl9GV19SQUlEX01BUF9BTEwgKm1hcCkKIHsKIAly
ZXR1cm4gbWFwLT5yYWlkTWFwLmxkU3Bhbk1hcFtsZF0uc3BhbkJsb2NrW3NwYW5dLnNwYW4uYXJy
YXlSZWY7CiB9CiAKLXN0YXRpYyB1MTYgTVJfUGREZXZIYW5kbGVHZXQodTMyIHBkLCBzdHJ1Y3Qg
TVJfRldfUkFJRF9NQVBfQUxMICptYXApCit1MTYgTVJfUGREZXZIYW5kbGVHZXQodTMyIHBkLCBz
dHJ1Y3QgTVJfRldfUkFJRF9NQVBfQUxMICptYXApCiB7CiAJcmV0dXJuIG1hcC0+cmFpZE1hcC5k
ZXZIbmRsSW5mb1twZF0uY3VyRGV2SGRsOwogfQpAQCAtNzg0LDcgKzc4NCw3IEBACiBNUl9CdWls
ZFJhaWRDb250ZXh0KHN0cnVjdCBtZWdhc2FzX2luc3RhbmNlICppbnN0YW5jZSwKIAkJICAgIHN0
cnVjdCBJT19SRVFVRVNUX0lORk8gKmlvX2luZm8sCiAJCSAgICBzdHJ1Y3QgUkFJRF9DT05URVhU
ICpwUkFJRF9Db250ZXh0LAotCQkgICAgc3RydWN0IE1SX0ZXX1JBSURfTUFQX0FMTCAqbWFwKQor
CQkgICAgc3RydWN0IE1SX0ZXX1JBSURfTUFQX0FMTCAqbWFwLCB1OCAqKnJhaWRMVU4pCiB7CiAJ
c3RydWN0IE1SX0xEX1JBSUQgICpyYWlkOwogCXUzMiAgICAgICAgIGxkLCBzdHJpcFNpemUsIHN0
cmlwZV9tYXNrOwpAQCAtOTc3LDYgKzk3Nyw5IEBACiAJcFJBSURfQ29udGV4dC0+cmVnTG9ja1Jv
d0xCQSAgICA9IHJlZ1N0YXJ0OwogCXBSQUlEX0NvbnRleHQtPnJlZ0xvY2tMZW5ndGggICAgPSBy
ZWdTaXplOwogCXBSQUlEX0NvbnRleHQtPmNvbmZpZ1NlcU51bQk9IHJhaWQtPnNlcU51bTsKKwkv
KiBzYXZlIHBvaW50ZXIgdG8gcmFpZC0+TFVOIGFycmF5ICovCisJKnJhaWRMVU4gPSByYWlkLT5M
VU47CisKIAogCS8qR2V0IFBoeSBQYXJhbXMgb25seSBpZiBGUCBjYXBhYmxlLCBvciBlbHNlIGxl
YXZlIGl0IHRvIE1SIGZpcm13YXJlCiAJICB0byBkbyB0aGUgY2FsY3VsYXRpb24uKi8KZGlmZiAt
TmF1ciBzY3NpLW1pc2Mub2xkL2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9zYXNfZnVz
aW9uLmMgc2NzaS1taXNjLm5ldy9kcml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVnYXJhaWRfc2FzX2Z1
c2lvbi5jCi0tLSBzY3NpLW1pc2Mub2xkL2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9z
YXNfZnVzaW9uLmMJMjAxMy0wOC0zMSAxNjoxNzo1Ni45MDkxNzI2NDggLTA3MDAKKysrIHNjc2kt
bWlzYy5uZXcvZHJpdmVycy9zY3NpL21lZ2FyYWlkL21lZ2FyYWlkX3Nhc19mdXNpb24uYwkyMDEz
LTA5LTA2IDE1OjAzOjAzLjcxNjIxMjE2OCAtMDcwMApAQCAtNzIsMTcgKzcyLDYgQEAKIGludAog
bWVnYXNhc19pc3N1ZV9wb2xsZWQoc3RydWN0IG1lZ2FzYXNfaW5zdGFuY2UgKmluc3RhbmNlLAog
CQkgICAgIHN0cnVjdCBtZWdhc2FzX2NtZCAqY21kKTsKLQotdTgKLU1SX0J1aWxkUmFpZENvbnRl
eHQoc3RydWN0IG1lZ2FzYXNfaW5zdGFuY2UgKmluc3RhbmNlLAotCQkgICAgc3RydWN0IElPX1JF
UVVFU1RfSU5GTyAqaW9faW5mbywKLQkJICAgIHN0cnVjdCBSQUlEX0NPTlRFWFQgKnBSQUlEX0Nv
bnRleHQsCi0JCSAgICBzdHJ1Y3QgTVJfRldfUkFJRF9NQVBfQUxMICptYXApOwotdTE2IE1SX1Rh
cmdldElkVG9MZEdldCh1MzIgbGRUZ3RJZCwgc3RydWN0IE1SX0ZXX1JBSURfTUFQX0FMTCAqbWFw
KTsKLXN0cnVjdCBNUl9MRF9SQUlEICpNUl9MZFJhaWRHZXQodTMyIGxkLCBzdHJ1Y3QgTVJfRldf
UkFJRF9NQVBfQUxMICptYXApOwotCi11MTYgTVJfR2V0TERUZ3RJZCh1MzIgbGQsIHN0cnVjdCBN
Ul9GV19SQUlEX01BUF9BTEwgKm1hcCk7Ci0KIHZvaWQKIG1lZ2FzYXNfY2hlY2tfYW5kX3Jlc3Rv
cmVfcXVldWVfZGVwdGgoc3RydWN0IG1lZ2FzYXNfaW5zdGFuY2UgKmluc3RhbmNlKTsKIApAQCAt
NjUyLDYgKzY0MSwxMCBAQAogCQkoaW5zdGFuY2UtPnBkZXYtPmRldmljZSA9PSBQQ0lfREVWSUNF
X0lEX0xTSV9GVVJZKSkKIAkJaW5pdF9mcmFtZS0+ZHJpdmVyX29wZXJhdGlvbnMuCiAJCQltZmlf
Y2FwYWJpbGl0aWVzLnN1cHBvcnRfYWRkaXRpb25hbF9tc2l4ID0gMTsKKwkvKiBkcml2ZXIgc3Vw
cG9ydHMgSEEgLyBSZW1vdGUgTFVOIG92ZXIgRmFzdCBQYXRoIGludGVyZmFjZSAqLworCWluaXRf
ZnJhbWUtPmRyaXZlcl9vcGVyYXRpb25zLm1maV9jYXBhYmlsaXRpZXMuc3VwcG9ydF9mcF9yZW1v
dGVfbHVuCisJCT0gMTsKKwogCiAJaW5pdF9mcmFtZS0+cXVldWVfaW5mb19uZXdfcGh5c19hZGRy
X2xvID0gaW9jX2luaXRfaGFuZGxlOwogCWluaXRfZnJhbWUtPmRhdGFfeGZlcl9sZW4gPSBzaXpl
b2Yoc3RydWN0IE1QSTJfSU9DX0lOSVRfUkVRVUVTVCk7CkBAIC0xNDEwLDYgKzE0MDMsNyBAQAog
CXN0cnVjdCBJT19SRVFVRVNUX0lORk8gaW9faW5mbzsKIAlzdHJ1Y3QgZnVzaW9uX2NvbnRleHQg
KmZ1c2lvbjsKIAlzdHJ1Y3QgTVJfRldfUkFJRF9NQVBfQUxMICpsb2NhbF9tYXBfcHRyOworCXU4
ICpyYWlkTFVOOwogCiAJZGV2aWNlX2lkID0gTUVHQVNBU19ERVZfSU5ERVgoaW5zdGFuY2UsIHNj
cCk7CiAKQEAgLTE0OTQsNyArMTQ4OCw3IEBACiAJfSBlbHNlIHsKIAkJaWYgKE1SX0J1aWxkUmFp
ZENvbnRleHQoaW5zdGFuY2UsICZpb19pbmZvLAogCQkJCQkmaW9fcmVxdWVzdC0+UmFpZENvbnRl
eHQsCi0JCQkJCWxvY2FsX21hcF9wdHIpKQorCQkJCQlsb2NhbF9tYXBfcHRyLCAmcmFpZExVTikp
CiAJCQlmcF9wb3NzaWJsZSA9IGlvX2luZm8uZnBPa0ZvcklvOwogCX0KIApAQCAtMTUzNyw2ICsx
NTMxLDggQEAKIAkJCXNjcC0+U0NwLlN0YXR1cyAmPSB+TUVHQVNBU19MT0FEX0JBTEFOQ0VfRkxB
RzsKIAkJY21kLT5yZXF1ZXN0X2Rlc2MtPlNDU0lJTy5EZXZIYW5kbGUgPSBpb19pbmZvLmRldkhh
bmRsZTsKIAkJaW9fcmVxdWVzdC0+RGV2SGFuZGxlID0gaW9faW5mby5kZXZIYW5kbGU7CisJCS8q
IHBvcHVsYXRlIHRoZSBMVU4gZmllbGQgKi8KKwkJbWVtY3B5KGlvX3JlcXVlc3QtPkxVTiwgcmFp
ZExVTiwgOCk7CiAJfSBlbHNlIHsKIAkJaW9fcmVxdWVzdC0+UmFpZENvbnRleHQudGltZW91dFZh
bHVlID0KIAkJCWxvY2FsX21hcF9wdHItPnJhaWRNYXAuZnBQZElvVGltZW91dFNlYzsKQEAgLTE1
NzksNiArMTU3NSwxMSBAQAogCXUxNiBwZF9pbmRleCA9IDA7CiAJc3RydWN0IE1SX0ZXX1JBSURf
TUFQX0FMTCAqbG9jYWxfbWFwX3B0cjsKIAlzdHJ1Y3QgZnVzaW9uX2NvbnRleHQgKmZ1c2lvbiA9
IGluc3RhbmNlLT5jdHJsX2NvbnRleHQ7CisJdTggICAgICAgICAgICAgICAgICAgICAgICAgIHNw
YW4sIHBoeXNBcm07CisJdTE2ICAgICAgICAgICAgICAgICAgICAgICAgIGRldkhhbmRsZTsKKwl1
MzIgICAgICAgICAgICAgICAgICAgICAgICAgbGQsIGFyUmVmLCBwZDsKKwlzdHJ1Y3QgTVJfTERf
UkFJRCAgICAgICAgICAgICAgICAgICpyYWlkOworCXN0cnVjdCBSQUlEX0NPTlRFWFQgICAgICAg
ICAgICAgICAgKnBSQUlEX0NvbnRleHQ7CiAKIAlpb19yZXF1ZXN0ID0gY21kLT5pb19yZXF1ZXN0
OwogCWRldmljZV9pZCA9IE1FR0FTQVNfREVWX0lOREVYKGluc3RhbmNlLCBzY21kKTsKQEAgLTE1
ODYsNiArMTU4Nyw5IEBACiAJCStzY21kLT5kZXZpY2UtPmlkOwogCWxvY2FsX21hcF9wdHIgPSBm
dXNpb24tPmxkX21hcFsoaW5zdGFuY2UtPm1hcF9pZCAmIDEpXTsKIAorCWlvX3JlcXVlc3QtPkRh
dGFMZW5ndGggPSBzY3NpX2J1ZmZsZW4oc2NtZCk7CisKKwogCS8qIENoZWNrIGlmIHRoaXMgaXMg
YSBzeXN0ZW0gUEQgSS9PICovCiAJaWYgKHNjbWQtPmRldmljZS0+Y2hhbm5lbCA8IE1FR0FTQVNf
TUFYX1BEX0NIQU5ORUxTICYmCiAJICAgIGluc3RhbmNlLT5wZF9saXN0W3BkX2luZGV4XS5kcml2
ZVN0YXRlID09IE1SX1BEX1NUQVRFX1NZU1RFTSkgewpAQCAtMTYyMyw2ICsxNjI3LDU0IEBACiAJ
CQkJCXNjbWQtPnJlcXVlc3QtPnRpbWVvdXQgLyBIWjsKIAkJfQogCX0gZWxzZSB7CisJCWlmIChz
Y21kLT5kZXZpY2UtPmNoYW5uZWwgPCBNRUdBU0FTX01BWF9QRF9DSEFOTkVMUykKKwkJCWdvdG8g
Tm9uRmFzdFBhdGg7CisKKwkJbGQgPSBNUl9UYXJnZXRJZFRvTGRHZXQoZGV2aWNlX2lkLCBsb2Nh
bF9tYXBfcHRyKTsKKwkJaWYgKChsZCA+PSBNQVhfTE9HSUNBTF9EUklWRVMpIHx8ICghZnVzaW9u
LT5mYXN0X3BhdGhfaW8pKQorCQkJZ290byBOb25GYXN0UGF0aDsKKworCQlyYWlkID0gTVJfTGRS
YWlkR2V0KGxkLCBsb2NhbF9tYXBfcHRyKTsKKworCQkvKiBjaGVjayBpZiB0aGlzIExEIGlzIEZQ
IGNhcGFibGUgKi8KKwkJaWYgKCEocmFpZC0+Y2FwYWJpbGl0eS5mcE5vblJXQ2FwYWJsZSkpCisJ
CQkvKiBub3QgRlAgY2FwYWJsZSwgc2VuZCBhcyBub24tRlAgKi8KKwkJCWdvdG8gTm9uRmFzdFBh
dGg7CisKKwkJLyogZ2V0IFJBSURfQ29udGV4dCBwb2ludGVyICovCisJCXBSQUlEX0NvbnRleHQg
PSAmaW9fcmVxdWVzdC0+UmFpZENvbnRleHQ7CisKKwkJLyogc2V0IFJBSUQgY29udGV4dCB2YWx1
ZXMgKi8KKwkJcFJBSURfQ29udGV4dC0+cmVnTG9ja0ZsYWdzICAgICA9IFJFR0lPTl9UWVBFX1NI
QVJFRF9SRUFEOworCQlwUkFJRF9Db250ZXh0LT50aW1lb3V0VmFsdWUgICAgID0gcmFpZC0+ZnBJ
b1RpbWVvdXRGb3JMZDsKKwkJcFJBSURfQ29udGV4dC0+VmlydHVhbERpc2tUZ3RJZCA9IGRldmlj
ZV9pZDsKKwkJcFJBSURfQ29udGV4dC0+cmVnTG9ja1Jvd0xCQSAgICA9IDA7CisJCXBSQUlEX0Nv
bnRleHQtPnJlZ0xvY2tMZW5ndGggICAgPSAwOworCQlwUkFJRF9Db250ZXh0LT5jb25maWdTZXFO
dW0gICAgID0gcmFpZC0+c2VxTnVtOworCisJCS8qIGdldCB0aGUgRGV2SGFuZGxlIGZvciB0aGUg
UEQgKHNpbmNlIHRoaXMgaXMKKwkJICAgZnBOb25SV0NhcGFibGUsIHRoaXMgaXMgYSBzaW5nbGUg
ZGlzayBSQUlEMCkgKi8KKwkJc3BhbiA9IHBoeXNBcm0gPSAwOworCQlhclJlZiA9IE1SX0xkU3Bh
bkFycmF5R2V0KGxkLCBzcGFuLCBsb2NhbF9tYXBfcHRyKTsKKwkJcGQgPSBNUl9BclBkR2V0KGFy
UmVmLCBwaHlzQXJtLCBsb2NhbF9tYXBfcHRyKTsKKwkJZGV2SGFuZGxlID0gTVJfUGREZXZIYW5k
bGVHZXQocGQsIGxvY2FsX21hcF9wdHIpOworCisJCS8qIGJ1aWxkIHJlcXVlc3QgZGVzY3JpcHRv
ciAqLworCQljbWQtPnJlcXVlc3RfZGVzYy0+U0NTSUlPLlJlcXVlc3RGbGFncyA9CisJCQkoTVBJ
Ml9SRVFfREVTQ1JJUFRfRkxBR1NfSElHSF9QUklPUklUWSA8PAorCQkJIE1FR0FTQVNfUkVRX0RF
U0NSSVBUX0ZMQUdTX1RZUEVfU0hJRlQpOworCQljbWQtPnJlcXVlc3RfZGVzYy0+U0NTSUlPLkRl
dkhhbmRsZSA9IGRldkhhbmRsZTsKKworCQkvKiBwb3B1bGF0ZSB0aGUgTFVOIGZpZWxkICovCisJ
CW1lbWNweShpb19yZXF1ZXN0LT5MVU4sIHJhaWQtPkxVTiwgOCk7CisKKwkJLyogYnVpbGQgdGhl
IHJhaWRTY3NpSU8gc3RydWN0dXJlICovCisJCWlvX3JlcXVlc3QtPkZ1bmN0aW9uID0gTVBJMl9G
VU5DVElPTl9TQ1NJX0lPX1JFUVVFU1Q7CisJCWlvX3JlcXVlc3QtPkRldkhhbmRsZSA9IGRldkhh
bmRsZTsKKworCQlyZXR1cm47CisKK05vbkZhc3RQYXRoOgogCQlpb19yZXF1ZXN0LT5GdW5jdGlv
biAgPSBNRUdBU0FTX01QSTJfRlVOQ1RJT05fTERfSU9fUkVRVUVTVDsKIAkJaW9fcmVxdWVzdC0+
RGV2SGFuZGxlID0gZGV2aWNlX2lkOwogCQljbWQtPnJlcXVlc3RfZGVzYy0+U0NTSUlPLlJlcXVl
c3RGbGFncyA9CkBAIC0xNjMxLDcgKzE2ODMsNiBAQAogCX0KIAlpb19yZXF1ZXN0LT5SYWlkQ29u
dGV4dC5WaXJ0dWFsRGlza1RndElkID0gZGV2aWNlX2lkOwogCWlvX3JlcXVlc3QtPkxVTlsxXSA9
IHNjbWQtPmRldmljZS0+bHVuOwotCWlvX3JlcXVlc3QtPkRhdGFMZW5ndGggPSBzY3NpX2J1ZmZs
ZW4oc2NtZCk7CiB9CiAKIC8qKgpkaWZmIC1OYXVyIHNjc2ktbWlzYy5vbGQvZHJpdmVycy9zY3Np
L21lZ2FyYWlkL21lZ2FyYWlkX3Nhc19mdXNpb24uaCBzY3NpLW1pc2MubmV3L2RyaXZlcnMvc2Nz
aS9tZWdhcmFpZC9tZWdhcmFpZF9zYXNfZnVzaW9uLmgKLS0tIHNjc2ktbWlzYy5vbGQvZHJpdmVy
cy9zY3NpL21lZ2FyYWlkL21lZ2FyYWlkX3Nhc19mdXNpb24uaAkyMDEzLTA4LTMxIDE2OjE3OjU2
LjkwOTE3MjY0OCAtMDcwMAorKysgc2NzaS1taXNjLm5ldy9kcml2ZXJzL3Njc2kvbWVnYXJhaWQv
bWVnYXJhaWRfc2FzX2Z1c2lvbi5oCTIwMTMtMDgtMzEgMTY6MjM6MzEuMDc5MTQwMzkzIC0wNzAw
CkBAIC01MjcsNyArNTI3LDggQEAKIAkJdTMyICAgICBmcFJlYWRDYXBhYmxlOjE7CiAJCXUzMiAg
ICAgZnBXcml0ZUFjcm9zc1N0cmlwZToxOwogCQl1MzIgICAgIGZwUmVhZEFjcm9zc1N0cmlwZTox
OwotCQl1MzIgICAgIHJlc2VydmVkNDo4OworCQl1MzIJZnBOb25SV0NhcGFibGU6MTsKKwkJdTMy
ICAgICByZXNlcnZlZDQ6NzsKIAl9IGNhcGFiaWxpdHk7CiAJdTMyICAgICByZXNlcnZlZDY7CiAJ
dTY0ICAgICBzaXplOwpAQCAtNTUxLDcgKzU1Miw5IEBACiAJCXUzMiByZXNlcnZlZDozMTsKIAl9
IGZsYWdzOwogCi0JdTggICAgICByZXNlcnZlZDNbMHg1Q107CisJdTgJTFVOWzhdOyAvKiAweDI0
IDggYnl0ZSBMVU4gZmllbGQgdXNlZCBmb3IgU0NTSSBJTydzICovCisJdTgJZnBJb1RpbWVvdXRG
b3JMZDsvKjB4MkMgdGltZW91dCB2YWx1ZSB1c2VkIGJ5IGRyaXZlciBpbiBGUCBJTyovCisJdTgg
ICAgICByZXNlcnZlZDNbMHg4MC0weDJEXTsgLyogMHgyRCAqLwogfTsKIAogc3RydWN0IE1SX0xE
X1NQQU5fTUFQIHsKZGlmZiAtTmF1ciBzY3NpLW1pc2Mub2xkL2RyaXZlcnMvc2NzaS9tZWdhcmFp
ZC9tZWdhcmFpZF9zYXMuaCBzY3NpLW1pc2MubmV3L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdh
cmFpZF9zYXMuaAotLS0gc2NzaS1taXNjLm9sZC9kcml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVnYXJh
aWRfc2FzLmgJMjAxMy0wOC0zMSAxNjoxNzo1Ni45MTAxMTQ3MjUgLTA3MDAKKysrIHNjc2ktbWlz
Yy5uZXcvZHJpdmVycy9zY3NpL21lZ2FyYWlkL21lZ2FyYWlkX3Nhcy5oCTIwMTMtMDktMDYgMTU6
MDI6NTMuMjA1MjEyMzg5IC0wNzAwCkBAIC0xNzAsNiArMTcwLDcgQEAKIAogI2RlZmluZSBNUl9E
Q01EX0NUUkxfR0VUX0lORk8JCQkweDAxMDEwMDAwCiAjZGVmaW5lIE1SX0RDTURfTERfR0VUX0xJ
U1QJCQkweDAzMDEwMDAwCisjZGVmaW5lIE1SX0RDTURfTERfTElTVF9RVUVSWQkJCTB4MDMwMTAx
MDAKIAogI2RlZmluZSBNUl9EQ01EX0NUUkxfQ0FDSEVfRkxVU0gJCTB4MDExMDEwMDAKICNkZWZp
bmUgTVJfRkxVU0hfQ1RSTF9DQUNIRQkJCTB4MDEKQEAgLTM0NSw2ICszNDYsMTUgQEAKIAlNUl9Q
RF9RVUVSWV9UWVBFX0VYUE9TRURfVE9fSE9TVCAgICA9IDUsCiB9OwogCitlbnVtIE1SX0xEX1FV
RVJZX1RZUEUgeworCU1SX0xEX1FVRVJZX1RZUEVfQUxMCSAgICAgICAgID0gMCwKKwlNUl9MRF9R
VUVSWV9UWVBFX0VYUE9TRURfVE9fSE9TVCA9IDEsCisJTVJfTERfUVVFUllfVFlQRV9VU0VEX1RH
VF9JRFMgICAgPSAyLAorCU1SX0xEX1FVRVJZX1RZUEVfQ0xVU1RFUl9BQ0NFU1MgID0gMywKKwlN
Ul9MRF9RVUVSWV9UWVBFX0NMVVNURVJfTE9DQUxFICA9IDQsCit9OworCisKICNkZWZpbmUgTVJf
RVZUX0NGR19DTEVBUkVEICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgMHgwMDA0CiAjZGVm
aW5lIE1SX0VWVF9MRF9TVEFURV9DSEFOR0UgICAgICAgICAgICAgICAgICAgICAgICAgIDB4MDA1
MQogI2RlZmluZSBNUl9FVlRfUERfSU5TRVJURUQgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAweDAwNWIKQEAgLTQzNSw2ICs0NDUsMTQgQEAKIAl9IGxkTGlzdFtNQVhfTE9HSUNBTF9EUklW
RVNdOwogfSBfX3BhY2tlZDsKIAorc3RydWN0IE1SX0xEX1RBUkdFVElEX0xJU1QgeworCXUzMglz
aXplOworCXUzMgljb3VudDsKKwl1OAlwYWRbM107CisJdTgJdGFyZ2V0SWRbTUFYX0xPR0lDQUxf
RFJJVkVTXTsKK307CisKKwogLyoKICAqIFNBUyBjb250cm9sbGVyIHByb3BlcnRpZXMKICAqLwpA
QCAtODYzLDcgKzg4MSw3IEBACiAgKiA9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09CiAg
Ki8KICNkZWZpbmUgTUVHQVNBU19NQVhfUERfQ0hBTk5FTFMJCQkyCi0jZGVmaW5lIE1FR0FTQVNf
TUFYX0xEX0NIQU5ORUxTCQkJMgorI2RlZmluZSBNRUdBU0FTX01BWF9MRF9DSEFOTkVMUwkJCTEK
ICNkZWZpbmUgTUVHQVNBU19NQVhfQ0hBTk5FTFMJCQkoTUVHQVNBU19NQVhfUERfQ0hBTk5FTFMg
KyBcCiAJCQkJCQlNRUdBU0FTX01BWF9MRF9DSEFOTkVMUykKICNkZWZpbmUgTUVHQVNBU19NQVhf
REVWX1BFUl9DSEFOTkVMCQkxMjgKQEAgLTE2NTYsNCArMTY3NCwxNiBAQAogCWludCBtYXhfaW5k
ZXg7CiB9OwogCit1OAorTVJfQnVpbGRSYWlkQ29udGV4dChzdHJ1Y3QgbWVnYXNhc19pbnN0YW5j
ZSAqaW5zdGFuY2UsCisJCSAgICBzdHJ1Y3QgSU9fUkVRVUVTVF9JTkZPICppb19pbmZvLAorCQkg
ICAgc3RydWN0IFJBSURfQ09OVEVYVCAqcFJBSURfQ29udGV4dCwKKwkJICAgIHN0cnVjdCBNUl9G
V19SQUlEX01BUF9BTEwgKm1hcCwgdTggKipyYWlkTFVOKTsKK3UxNiBNUl9UYXJnZXRJZFRvTGRH
ZXQodTMyIGxkVGd0SWQsIHN0cnVjdCBNUl9GV19SQUlEX01BUF9BTEwgKm1hcCk7CitzdHJ1Y3Qg
TVJfTERfUkFJRCAqTVJfTGRSYWlkR2V0KHUzMiBsZCwgc3RydWN0IE1SX0ZXX1JBSURfTUFQX0FM
TCAqbWFwKTsKK3UxNiBNUl9BclBkR2V0KHUzMiBhciwgdTMyIGFybSwgc3RydWN0IE1SX0ZXX1JB
SURfTUFQX0FMTCAqbWFwKTsKK3UxNiBNUl9MZFNwYW5BcnJheUdldCh1MzIgbGQsIHUzMiBzcGFu
LCBzdHJ1Y3QgTVJfRldfUkFJRF9NQVBfQUxMICptYXApOwordTE2IE1SX1BkRGV2SGFuZGxlR2V0
KHUzMiBwZCwgc3RydWN0IE1SX0ZXX1JBSURfTUFQX0FMTCAqbWFwKTsKK3UxNiBNUl9HZXRMRFRn
dElkKHUzMiBsZCwgc3RydWN0IE1SX0ZXX1JBSURfTUFQX0FMTCAqbWFwKTsKKwogI2VuZGlmCQkJ
CS8qTFNJX01FR0FSQUlEX1NBU19IICovCg==
--089e01536d7a59702204e5be8af1--

From: adam radford <aradford@gmail.com>
Subject: [PATCH 1/2] megaraid_sas: Add High Availability clustering support
 using shared Logical Disks
Date: Sat, 31 Aug 2013 16:54:21 -0700
Message-ID: <CAHtARFGNHZ4u8bKksuRDUokNkxrM3sRXV0woy-Rshang3tpUBA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=047d7bf1651ed914b204e5470e52
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qa0-f47.google.com ([209.85.216.47]:41338 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753128Ab3HaXyW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 31 Aug 2013 19:54:22 -0400
Received: by mail-qa0-f47.google.com with SMTP id j7so390294qaq.6
        for <linux-scsi@vger.kernel.org>; Sat, 31 Aug 2013 16:54:21 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Kashyap Desai <Kashyap.Desai@lsi.com>

--047d7bf1651ed914b204e5470e52
Content-Type: text/plain; charset=ISO-8859-1

James/linux-scsi,

The following patch for megaraid_sas will add support for High
Availability (HA)/clustering using shared Logical Disks.

Signed-off-by: Adam Radford <aradford@gmail.com>

diff -Naur scsi-misc.old/drivers/scsi/megaraid/megaraid_sas_base.c
scsi-misc.new/drivers/scsi/megaraid/megaraid_sas_base.c
--- scsi-misc.old/drivers/scsi/megaraid/megaraid_sas_base.c 2013-08-31
16:17:56.907172388 -0700
+++ scsi-misc.new/drivers/scsi/megaraid/megaraid_sas_base.c 2013-08-31
16:23:31.077143117 -0700
@@ -92,6 +92,8 @@

 int megasas_transition_to_ready(struct megasas_instance *instance, int ocr);
 static int megasas_get_pd_list(struct megasas_instance *instance);
+static int megasas_ld_list_query(struct megasas_instance *instance,
+ u8 query_type);
 static int megasas_issue_init_mfi(struct megasas_instance *instance);
 static int megasas_register_aen(struct megasas_instance *instance,
  u32 seq_num, u32 class_locale_word);
@@ -3271,6 +3273,84 @@
 }

 /**
+ * megasas_ld_list_query - Returns FW's ld_list structure
+ * @instance: Adapter soft state
+ * @ld_list: ld_list structure
+ *
+ * Issues an internal command (DCMD) to get the FW's controller PD
+ * list structure.  This information is mainly used to find out SYSTEM
+ * supported by the FW.
+ */
+static int
+megasas_ld_list_query(struct megasas_instance *instance, u8 query_type)
+{
+ int ret = 0, ld_index = 0, ids = 0;
+ struct megasas_cmd *cmd;
+ struct megasas_dcmd_frame *dcmd;
+ struct MR_LD_TARGETID_LIST *ci;
+ dma_addr_t ci_h = 0;
+
+ cmd = megasas_get_cmd(instance);
+
+ if (!cmd) {
+ printk(KERN_WARNING
+       "megasas:(megasas_ld_list_query): Failed to get cmd\n");
+ return -ENOMEM;
+ }
+
+ dcmd = &cmd->frame->dcmd;
+
+ ci = pci_alloc_consistent(instance->pdev,
+  sizeof(struct MR_LD_TARGETID_LIST), &ci_h);
+
+ if (!ci) {
+ printk(KERN_WARNING
+       "megasas: Failed to alloc mem for ld_list_query\n");
+ megasas_return_cmd(instance, cmd);
+ return -ENOMEM;
+ }
+
+ memset(ci, 0, sizeof(*ci));
+ memset(dcmd->mbox.b, 0, MFI_MBOX_SIZE);
+
+ dcmd->mbox.b[0] = query_type;
+
+ dcmd->cmd = MFI_CMD_DCMD;
+ dcmd->cmd_status = 0xFF;
+ dcmd->sge_count = 1;
+ dcmd->flags = MFI_FRAME_DIR_READ;
+ dcmd->timeout = 0;
+ dcmd->data_xfer_len = sizeof(struct MR_LD_TARGETID_LIST);
+ dcmd->opcode = MR_DCMD_LD_LIST_QUERY;
+ dcmd->sgl.sge32[0].phys_addr = ci_h;
+ dcmd->sgl.sge32[0].length = sizeof(struct MR_LD_TARGETID_LIST);
+ dcmd->pad_0  = 0;
+
+ if (!megasas_issue_polled(instance, cmd) && !dcmd->cmd_status) {
+ ret = 0;
+ } else {
+ /* On failure, call older LD list DCMD */
+ ret = 1;
+ }
+
+ if ((ret == 0) && (ci->count <= (MAX_LOGICAL_DRIVES))) {
+ memset(instance->ld_ids, 0xff, MEGASAS_MAX_LD_IDS);
+ for (ld_index = 0; ld_index < ci->count; ld_index++) {
+ ids = ci->targetId[ld_index];
+ instance->ld_ids[ids] = ci->targetId[ld_index];
+ }
+
+ }
+
+ pci_free_consistent(instance->pdev, sizeof(struct MR_LD_TARGETID_LIST),
+    ci, ci_h);
+
+ megasas_return_cmd(instance, cmd);
+
+ return ret;
+}
+
+/**
  * megasas_get_controller_info - Returns FW's controller structure
  * @instance: Adapter soft state
  * @ctrl_info: Controller information structure
@@ -3648,7 +3728,9 @@
  megasas_get_pd_list(instance);

  memset(instance->ld_ids, 0xff, MEGASAS_MAX_LD_IDS);
- megasas_get_ld_list(instance);
+ if (megasas_ld_list_query(instance,
+  MR_LD_QUERY_TYPE_EXPOSED_TO_HOST))
+ megasas_get_ld_list(instance);

  ctrl_info = kmalloc(sizeof(struct megasas_ctrl_info), GFP_KERNEL);

@@ -5389,7 +5471,9 @@
  case MR_EVT_LD_OFFLINE:
  case MR_EVT_CFG_CLEARED:
  case MR_EVT_LD_DELETED:
- megasas_get_ld_list(instance);
+ if (megasas_ld_list_query(instance,
+ MR_LD_QUERY_TYPE_EXPOSED_TO_HOST))
+ megasas_get_ld_list(instance);
  for (i = 0; i < MEGASAS_MAX_LD_CHANNELS; i++) {
  for (j = 0;
  j < MEGASAS_MAX_DEV_PER_CHANNEL;
@@ -5399,7 +5483,7 @@
  (i * MEGASAS_MAX_DEV_PER_CHANNEL) + j;

  sdev1 = scsi_device_lookup(host,
- i + MEGASAS_MAX_LD_CHANNELS,
+ MEGASAS_MAX_PD_CHANNELS + i,
  j,
  0);

@@ -5418,7 +5502,9 @@
  doscan = 0;
  break;
  case MR_EVT_LD_CREATED:
- megasas_get_ld_list(instance);
+ if (megasas_ld_list_query(instance,
+ MR_LD_QUERY_TYPE_EXPOSED_TO_HOST))
+ megasas_get_ld_list(instance);
  for (i = 0; i < MEGASAS_MAX_LD_CHANNELS; i++) {
  for (j = 0;
  j < MEGASAS_MAX_DEV_PER_CHANNEL;
@@ -5427,14 +5513,14 @@
  (i * MEGASAS_MAX_DEV_PER_CHANNEL) + j;

  sdev1 = scsi_device_lookup(host,
- i+MEGASAS_MAX_LD_CHANNELS,
+ MEGASAS_MAX_PD_CHANNELS + i,
  j, 0);

  if (instance->ld_ids[ld_index] !=
  0xff) {
  if (!sdev1) {
  scsi_add_device(host,
- i + 2,
+ MEGASAS_MAX_PD_CHANNELS + i,
  j, 0);
  }
  }
@@ -5483,18 +5569,20 @@
  }
  }

- megasas_get_ld_list(instance);
+ if (megasas_ld_list_query(instance,
+  MR_LD_QUERY_TYPE_EXPOSED_TO_HOST))
+ megasas_get_ld_list(instance);
  for (i = 0; i < MEGASAS_MAX_LD_CHANNELS; i++) {
  for (j = 0; j < MEGASAS_MAX_DEV_PER_CHANNEL; j++) {
  ld_index =
  (i * MEGASAS_MAX_DEV_PER_CHANNEL) + j;

  sdev1 = scsi_device_lookup(host,
- i+MEGASAS_MAX_LD_CHANNELS, j, 0);
+ MEGASAS_MAX_PD_CHANNELS + i, j, 0);
  if (instance->ld_ids[ld_index] != 0xff) {
  if (!sdev1) {
  scsi_add_device(host,
- i+2,
+ MEGASAS_MAX_PD_CHANNELS + i,
  j, 0);
  } else {
  scsi_device_put(sdev1);
diff -Naur scsi-misc.old/drivers/scsi/megaraid/megaraid_sas_fp.c
scsi-misc.new/drivers/scsi/megaraid/megaraid_sas_fp.c
--- scsi-misc.old/drivers/scsi/megaraid/megaraid_sas_fp.c 2013-08-31
16:17:56.908172637 -0700
+++ scsi-misc.new/drivers/scsi/megaraid/megaraid_sas_fp.c 2013-08-31
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
-    struct MR_FW_RAID_MAP_ALL *map)
+    struct MR_FW_RAID_MAP_ALL *map, u8 **raidLUN)
 {
  struct MR_LD_RAID  *raid;
  u32         ld, stripSize, stripe_mask;
@@ -977,6 +977,9 @@
  pRAID_Context->regLockRowLBA    = regStart;
  pRAID_Context->regLockLength    = regSize;
  pRAID_Context->configSeqNum = raid->seqNum;
+ /* save pointer to raid->LUN array */
+ *raidLUN = raid->LUN;
+

  /*Get Phy Params only if FP capable, or else leave it to MR firmware
   to do the calculation.*/
diff -Naur scsi-misc.old/drivers/scsi/megaraid/megaraid_sas_fusion.c
scsi-misc.new/drivers/scsi/megaraid/megaraid_sas_fusion.c
--- scsi-misc.old/drivers/scsi/megaraid/megaraid_sas_fusion.c
2013-08-31 16:17:56.909172648 -0700
+++ scsi-misc.new/drivers/scsi/megaraid/megaraid_sas_fusion.c
2013-08-31 16:24:51.861078589 -0700
@@ -77,9 +77,12 @@
 MR_BuildRaidContext(struct megasas_instance *instance,
     struct IO_REQUEST_INFO *io_info,
     struct RAID_CONTEXT *pRAID_Context,
-    struct MR_FW_RAID_MAP_ALL *map);
+    struct MR_FW_RAID_MAP_ALL *map, u8 **raidLUN);
 u16 MR_TargetIdToLdGet(u32 ldTgtId, struct MR_FW_RAID_MAP_ALL *map);
 struct MR_LD_RAID *MR_LdRaidGet(u32 ld, struct MR_FW_RAID_MAP_ALL *map);
+u16 MR_ArPdGet(u32 ar, u32 arm, struct MR_FW_RAID_MAP_ALL *map);
+u16 MR_LdSpanArrayGet(u32 ld, u32 span, struct MR_FW_RAID_MAP_ALL *map);
+u16 MR_PdDevHandleGet(u32 pd, struct MR_FW_RAID_MAP_ALL *map);

 u16 MR_GetLDTgtId(u32 ld, struct MR_FW_RAID_MAP_ALL *map);

@@ -652,6 +655,10 @@
  (instance->pdev->device == PCI_DEVICE_ID_LSI_FURY))
  init_frame->driver_operations.
  mfi_capabilities.support_additional_msix = 1;
+ /* driver supports HA / Remote LUN over Fast Path interface */
+ init_frame->driver_operations.mfi_capabilities.support_fp_remote_lun
+ = 1;
+

  init_frame->queue_info_new_phys_addr_lo = ioc_init_handle;
  init_frame->data_xfer_len = sizeof(struct MPI2_IOC_INIT_REQUEST);
@@ -1410,6 +1417,7 @@
  struct IO_REQUEST_INFO io_info;
  struct fusion_context *fusion;
  struct MR_FW_RAID_MAP_ALL *local_map_ptr;
+ u8 *raidLUN;

  device_id = MEGASAS_DEV_INDEX(instance, scp);

@@ -1494,7 +1502,7 @@
  } else {
  if (MR_BuildRaidContext(instance, &io_info,
  &io_request->RaidContext,
- local_map_ptr))
+ local_map_ptr, &raidLUN))
  fp_possible = io_info.fpOkForIo;
  }

@@ -1537,6 +1545,8 @@
  scp->SCp.Status &= ~MEGASAS_LOAD_BALANCE_FLAG;
  cmd->request_desc->SCSIIO.DevHandle = io_info.devHandle;
  io_request->DevHandle = io_info.devHandle;
+ /* populate the LUN field */
+ memcpy(io_request->LUN, raidLUN, 8);
  } else {
  io_request->RaidContext.timeoutValue =
  local_map_ptr->raidMap.fpPdIoTimeoutSec;
@@ -1579,6 +1589,11 @@
  u16 pd_index = 0;
  struct MR_FW_RAID_MAP_ALL *local_map_ptr;
  struct fusion_context *fusion = instance->ctrl_context;
+ u8                          span, physArm;
+ u16                         devHandle;
+ u32                         ld, arRef, pd;
+ struct MR_LD_RAID                  *raid;
+ struct RAID_CONTEXT                *pRAID_Context;

  io_request = cmd->io_request;
  device_id = MEGASAS_DEV_INDEX(instance, scmd);
@@ -1586,6 +1601,9 @@
  +scmd->device->id;
  local_map_ptr = fusion->ld_map[(instance->map_id & 1)];

+ io_request->DataLength = scsi_bufflen(scmd);
+
+
  /* Check if this is a system PD I/O */
  if (scmd->device->channel < MEGASAS_MAX_PD_CHANNELS &&
     instance->pd_list[pd_index].driveState == MR_PD_STATE_SYSTEM) {
@@ -1623,6 +1641,54 @@
  scmd->request->timeout / HZ;
  }
  } else {
+ if (scmd->device->channel < MEGASAS_MAX_PD_CHANNELS)
+ goto NonFastPath;
+
+ ld = MR_TargetIdToLdGet(device_id, local_map_ptr);
+ if ((ld >= MAX_LOGICAL_DRIVES) || (!fusion->fast_path_io))
+ goto NonFastPath;
+
+ raid = MR_LdRaidGet(ld, local_map_ptr);
+
+ /* check if this LD is FP capable */
+ if (!(raid->capability.fpNonRWCapable))
+ /* not FP capable, send as non-FP */
+ goto NonFastPath;
+
+ /* get RAID_Context pointer */
+ pRAID_Context = &io_request->RaidContext;
+
+ /* set RAID context values */
+ pRAID_Context->regLockFlags     = REGION_TYPE_SHARED_READ;
+ pRAID_Context->timeoutValue     = raid->fpIoTimeoutForLd;
+ pRAID_Context->VirtualDiskTgtId = device_id;
+ pRAID_Context->regLockRowLBA    = 0;
+ pRAID_Context->regLockLength    = 0;
+ pRAID_Context->configSeqNum     = raid->seqNum;
+
+ /* get the DevHandle for the PD (since this is
+   fpNonRWCapable, this is a single disk RAID0) */
+ span = physArm = 0;
+ arRef = MR_LdSpanArrayGet(ld, span, local_map_ptr);
+ pd = MR_ArPdGet(arRef, physArm, local_map_ptr);
+ devHandle = MR_PdDevHandleGet(pd, local_map_ptr);
+
+ /* build request descriptor */
+ cmd->request_desc->SCSIIO.RequestFlags =
+ (MPI2_REQ_DESCRIPT_FLAGS_HIGH_PRIORITY <<
+ MEGASAS_REQ_DESCRIPT_FLAGS_TYPE_SHIFT);
+ cmd->request_desc->SCSIIO.DevHandle = devHandle;
+
+ /* populate the LUN field */
+ memcpy(io_request->LUN, raid->LUN, 8);
+
+ /* build the raidScsiIO structure */
+ io_request->Function = MPI2_FUNCTION_SCSI_IO_REQUEST;
+ io_request->DevHandle = devHandle;
+
+ return;
+
+NonFastPath:
  io_request->Function  = MEGASAS_MPI2_FUNCTION_LD_IO_REQUEST;
  io_request->DevHandle = device_id;
  cmd->request_desc->SCSIIO.RequestFlags =
@@ -1631,7 +1697,6 @@
  }
  io_request->RaidContext.VirtualDiskTgtId = device_id;
  io_request->LUN[1] = scmd->device->lun;
- io_request->DataLength = scsi_bufflen(scmd);
 }

 /**
diff -Naur scsi-misc.old/drivers/scsi/megaraid/megaraid_sas_fusion.h
scsi-misc.new/drivers/scsi/megaraid/megaraid_sas_fusion.h
--- scsi-misc.old/drivers/scsi/megaraid/megaraid_sas_fusion.h
2013-08-31 16:17:56.909172648 -0700
+++ scsi-misc.new/drivers/scsi/megaraid/megaraid_sas_fusion.h
2013-08-31 16:23:31.079140393 -0700
@@ -527,7 +527,8 @@
  u32     fpReadCapable:1;
  u32     fpWriteAcrossStripe:1;
  u32     fpReadAcrossStripe:1;
- u32     reserved4:8;
+ u32 fpNonRWCapable:1;
+ u32     reserved4:7;
  } capability;
  u32     reserved6;
  u64     size;
@@ -551,7 +552,9 @@
  u32 reserved:31;
  } flags;

- u8      reserved3[0x5C];
+ u8 LUN[8]; /* 0x24 8 byte LUN field used for SCSI IO's */
+ u8 fpIoTimeoutForLd;/*0x2C timeout value used by driver in FP IO*/
+ u8      reserved3[0x80-0x2D]; /* 0x2D */
 };

 struct MR_LD_SPAN_MAP {
diff -Naur scsi-misc.old/drivers/scsi/megaraid/megaraid_sas.h
scsi-misc.new/drivers/scsi/megaraid/megaraid_sas.h
--- scsi-misc.old/drivers/scsi/megaraid/megaraid_sas.h 2013-08-31
16:17:56.910114725 -0700
+++ scsi-misc.new/drivers/scsi/megaraid/megaraid_sas.h 2013-08-31
16:23:31.079140393 -0700
@@ -170,6 +170,7 @@

 #define MR_DCMD_CTRL_GET_INFO 0x01010000
 #define MR_DCMD_LD_GET_LIST 0x03010000
+#define MR_DCMD_LD_LIST_QUERY 0x03010100

 #define MR_DCMD_CTRL_CACHE_FLUSH 0x01101000
 #define MR_FLUSH_CTRL_CACHE 0x01
@@ -345,6 +346,15 @@
  MR_PD_QUERY_TYPE_EXPOSED_TO_HOST    = 5,
 };

+enum MR_LD_QUERY_TYPE {
+ MR_LD_QUERY_TYPE_ALL         = 0,
+ MR_LD_QUERY_TYPE_EXPOSED_TO_HOST = 1,
+ MR_LD_QUERY_TYPE_USED_TGT_IDS    = 2,
+ MR_LD_QUERY_TYPE_CLUSTER_ACCESS  = 3,
+ MR_LD_QUERY_TYPE_CLUSTER_LOCALE  = 4,
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
+ u32 size;
+ u32 count;
+ u8 pad[3];
+ u8 targetId[MAX_LOGICAL_DRIVES];
+};
+
+
 /*
  * SAS controller properties
  */
@@ -863,7 +881,7 @@
  * ===============================
  */
 #define MEGASAS_MAX_PD_CHANNELS 2
-#define MEGASAS_MAX_LD_CHANNELS 2
+#define MEGASAS_MAX_LD_CHANNELS 1
 #define MEGASAS_MAX_CHANNELS (MEGASAS_MAX_PD_CHANNELS + \
  MEGASAS_MAX_LD_CHANNELS)
 #define MEGASAS_MAX_DEV_PER_CHANNEL 128

--047d7bf1651ed914b204e5470e52
Content-Type: application/octet-stream; name="megaraid_sas.patch1"
Content-Disposition: attachment; filename="megaraid_sas.patch1"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hl1hfyi90

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
LTA4LTMxIDE2OjI0OjUxLjg2MTA3ODU4OSAtMDcwMApAQCAtNzcsOSArNzcsMTIgQEAKIE1SX0J1
aWxkUmFpZENvbnRleHQoc3RydWN0IG1lZ2FzYXNfaW5zdGFuY2UgKmluc3RhbmNlLAogCQkgICAg
c3RydWN0IElPX1JFUVVFU1RfSU5GTyAqaW9faW5mbywKIAkJICAgIHN0cnVjdCBSQUlEX0NPTlRF
WFQgKnBSQUlEX0NvbnRleHQsCi0JCSAgICBzdHJ1Y3QgTVJfRldfUkFJRF9NQVBfQUxMICptYXAp
OworCQkgICAgc3RydWN0IE1SX0ZXX1JBSURfTUFQX0FMTCAqbWFwLCB1OCAqKnJhaWRMVU4pOwog
dTE2IE1SX1RhcmdldElkVG9MZEdldCh1MzIgbGRUZ3RJZCwgc3RydWN0IE1SX0ZXX1JBSURfTUFQ
X0FMTCAqbWFwKTsKIHN0cnVjdCBNUl9MRF9SQUlEICpNUl9MZFJhaWRHZXQodTMyIGxkLCBzdHJ1
Y3QgTVJfRldfUkFJRF9NQVBfQUxMICptYXApOwordTE2IE1SX0FyUGRHZXQodTMyIGFyLCB1MzIg
YXJtLCBzdHJ1Y3QgTVJfRldfUkFJRF9NQVBfQUxMICptYXApOwordTE2IE1SX0xkU3BhbkFycmF5
R2V0KHUzMiBsZCwgdTMyIHNwYW4sIHN0cnVjdCBNUl9GV19SQUlEX01BUF9BTEwgKm1hcCk7Cit1
MTYgTVJfUGREZXZIYW5kbGVHZXQodTMyIHBkLCBzdHJ1Y3QgTVJfRldfUkFJRF9NQVBfQUxMICpt
YXApOwogCiB1MTYgTVJfR2V0TERUZ3RJZCh1MzIgbGQsIHN0cnVjdCBNUl9GV19SQUlEX01BUF9B
TEwgKm1hcCk7CiAKQEAgLTY1Miw2ICs2NTUsMTAgQEAKIAkJKGluc3RhbmNlLT5wZGV2LT5kZXZp
Y2UgPT0gUENJX0RFVklDRV9JRF9MU0lfRlVSWSkpCiAJCWluaXRfZnJhbWUtPmRyaXZlcl9vcGVy
YXRpb25zLgogCQkJbWZpX2NhcGFiaWxpdGllcy5zdXBwb3J0X2FkZGl0aW9uYWxfbXNpeCA9IDE7
CisJLyogZHJpdmVyIHN1cHBvcnRzIEhBIC8gUmVtb3RlIExVTiBvdmVyIEZhc3QgUGF0aCBpbnRl
cmZhY2UgKi8KKwlpbml0X2ZyYW1lLT5kcml2ZXJfb3BlcmF0aW9ucy5tZmlfY2FwYWJpbGl0aWVz
LnN1cHBvcnRfZnBfcmVtb3RlX2x1bgorCQk9IDE7CisKIAogCWluaXRfZnJhbWUtPnF1ZXVlX2lu
Zm9fbmV3X3BoeXNfYWRkcl9sbyA9IGlvY19pbml0X2hhbmRsZTsKIAlpbml0X2ZyYW1lLT5kYXRh
X3hmZXJfbGVuID0gc2l6ZW9mKHN0cnVjdCBNUEkyX0lPQ19JTklUX1JFUVVFU1QpOwpAQCAtMTQx
MCw2ICsxNDE3LDcgQEAKIAlzdHJ1Y3QgSU9fUkVRVUVTVF9JTkZPIGlvX2luZm87CiAJc3RydWN0
IGZ1c2lvbl9jb250ZXh0ICpmdXNpb247CiAJc3RydWN0IE1SX0ZXX1JBSURfTUFQX0FMTCAqbG9j
YWxfbWFwX3B0cjsKKwl1OCAqcmFpZExVTjsKIAogCWRldmljZV9pZCA9IE1FR0FTQVNfREVWX0lO
REVYKGluc3RhbmNlLCBzY3ApOwogCkBAIC0xNDk0LDcgKzE1MDIsNyBAQAogCX0gZWxzZSB7CiAJ
CWlmIChNUl9CdWlsZFJhaWRDb250ZXh0KGluc3RhbmNlLCAmaW9faW5mbywKIAkJCQkJJmlvX3Jl
cXVlc3QtPlJhaWRDb250ZXh0LAotCQkJCQlsb2NhbF9tYXBfcHRyKSkKKwkJCQkJbG9jYWxfbWFw
X3B0ciwgJnJhaWRMVU4pKQogCQkJZnBfcG9zc2libGUgPSBpb19pbmZvLmZwT2tGb3JJbzsKIAl9
CiAKQEAgLTE1MzcsNiArMTU0NSw4IEBACiAJCQlzY3AtPlNDcC5TdGF0dXMgJj0gfk1FR0FTQVNf
TE9BRF9CQUxBTkNFX0ZMQUc7CiAJCWNtZC0+cmVxdWVzdF9kZXNjLT5TQ1NJSU8uRGV2SGFuZGxl
ID0gaW9faW5mby5kZXZIYW5kbGU7CiAJCWlvX3JlcXVlc3QtPkRldkhhbmRsZSA9IGlvX2luZm8u
ZGV2SGFuZGxlOworCQkvKiBwb3B1bGF0ZSB0aGUgTFVOIGZpZWxkICovCisJCW1lbWNweShpb19y
ZXF1ZXN0LT5MVU4sIHJhaWRMVU4sIDgpOwogCX0gZWxzZSB7CiAJCWlvX3JlcXVlc3QtPlJhaWRD
b250ZXh0LnRpbWVvdXRWYWx1ZSA9CiAJCQlsb2NhbF9tYXBfcHRyLT5yYWlkTWFwLmZwUGRJb1Rp
bWVvdXRTZWM7CkBAIC0xNTc5LDYgKzE1ODksMTEgQEAKIAl1MTYgcGRfaW5kZXggPSAwOwogCXN0
cnVjdCBNUl9GV19SQUlEX01BUF9BTEwgKmxvY2FsX21hcF9wdHI7CiAJc3RydWN0IGZ1c2lvbl9j
b250ZXh0ICpmdXNpb24gPSBpbnN0YW5jZS0+Y3RybF9jb250ZXh0OworCXU4ICAgICAgICAgICAg
ICAgICAgICAgICAgICBzcGFuLCBwaHlzQXJtOworCXUxNiAgICAgICAgICAgICAgICAgICAgICAg
ICBkZXZIYW5kbGU7CisJdTMyICAgICAgICAgICAgICAgICAgICAgICAgIGxkLCBhclJlZiwgcGQ7
CisJc3RydWN0IE1SX0xEX1JBSUQgICAgICAgICAgICAgICAgICAqcmFpZDsKKwlzdHJ1Y3QgUkFJ
RF9DT05URVhUICAgICAgICAgICAgICAgICpwUkFJRF9Db250ZXh0OwogCiAJaW9fcmVxdWVzdCA9
IGNtZC0+aW9fcmVxdWVzdDsKIAlkZXZpY2VfaWQgPSBNRUdBU0FTX0RFVl9JTkRFWChpbnN0YW5j
ZSwgc2NtZCk7CkBAIC0xNTg2LDYgKzE2MDEsOSBAQAogCQkrc2NtZC0+ZGV2aWNlLT5pZDsKIAls
b2NhbF9tYXBfcHRyID0gZnVzaW9uLT5sZF9tYXBbKGluc3RhbmNlLT5tYXBfaWQgJiAxKV07CiAK
Kwlpb19yZXF1ZXN0LT5EYXRhTGVuZ3RoID0gc2NzaV9idWZmbGVuKHNjbWQpOworCisKIAkvKiBD
aGVjayBpZiB0aGlzIGlzIGEgc3lzdGVtIFBEIEkvTyAqLwogCWlmIChzY21kLT5kZXZpY2UtPmNo
YW5uZWwgPCBNRUdBU0FTX01BWF9QRF9DSEFOTkVMUyAmJgogCSAgICBpbnN0YW5jZS0+cGRfbGlz
dFtwZF9pbmRleF0uZHJpdmVTdGF0ZSA9PSBNUl9QRF9TVEFURV9TWVNURU0pIHsKQEAgLTE2MjMs
NiArMTY0MSw1NCBAQAogCQkJCQlzY21kLT5yZXF1ZXN0LT50aW1lb3V0IC8gSFo7CiAJCX0KIAl9
IGVsc2UgeworCQlpZiAoc2NtZC0+ZGV2aWNlLT5jaGFubmVsIDwgTUVHQVNBU19NQVhfUERfQ0hB
Tk5FTFMpCisJCQlnb3RvIE5vbkZhc3RQYXRoOworCisJCWxkID0gTVJfVGFyZ2V0SWRUb0xkR2V0
KGRldmljZV9pZCwgbG9jYWxfbWFwX3B0cik7CisJCWlmICgobGQgPj0gTUFYX0xPR0lDQUxfRFJJ
VkVTKSB8fCAoIWZ1c2lvbi0+ZmFzdF9wYXRoX2lvKSkKKwkJCWdvdG8gTm9uRmFzdFBhdGg7CisK
KwkJcmFpZCA9IE1SX0xkUmFpZEdldChsZCwgbG9jYWxfbWFwX3B0cik7CisKKwkJLyogY2hlY2sg
aWYgdGhpcyBMRCBpcyBGUCBjYXBhYmxlICovCisJCWlmICghKHJhaWQtPmNhcGFiaWxpdHkuZnBO
b25SV0NhcGFibGUpKQorCQkJLyogbm90IEZQIGNhcGFibGUsIHNlbmQgYXMgbm9uLUZQICovCisJ
CQlnb3RvIE5vbkZhc3RQYXRoOworCisJCS8qIGdldCBSQUlEX0NvbnRleHQgcG9pbnRlciAqLwor
CQlwUkFJRF9Db250ZXh0ID0gJmlvX3JlcXVlc3QtPlJhaWRDb250ZXh0OworCisJCS8qIHNldCBS
QUlEIGNvbnRleHQgdmFsdWVzICovCisJCXBSQUlEX0NvbnRleHQtPnJlZ0xvY2tGbGFncyAgICAg
PSBSRUdJT05fVFlQRV9TSEFSRURfUkVBRDsKKwkJcFJBSURfQ29udGV4dC0+dGltZW91dFZhbHVl
ICAgICA9IHJhaWQtPmZwSW9UaW1lb3V0Rm9yTGQ7CisJCXBSQUlEX0NvbnRleHQtPlZpcnR1YWxE
aXNrVGd0SWQgPSBkZXZpY2VfaWQ7CisJCXBSQUlEX0NvbnRleHQtPnJlZ0xvY2tSb3dMQkEgICAg
PSAwOworCQlwUkFJRF9Db250ZXh0LT5yZWdMb2NrTGVuZ3RoICAgID0gMDsKKwkJcFJBSURfQ29u
dGV4dC0+Y29uZmlnU2VxTnVtICAgICA9IHJhaWQtPnNlcU51bTsKKworCQkvKiBnZXQgdGhlIERl
dkhhbmRsZSBmb3IgdGhlIFBEIChzaW5jZSB0aGlzIGlzCisJCSAgIGZwTm9uUldDYXBhYmxlLCB0
aGlzIGlzIGEgc2luZ2xlIGRpc2sgUkFJRDApICovCisJCXNwYW4gPSBwaHlzQXJtID0gMDsKKwkJ
YXJSZWYgPSBNUl9MZFNwYW5BcnJheUdldChsZCwgc3BhbiwgbG9jYWxfbWFwX3B0cik7CisJCXBk
ID0gTVJfQXJQZEdldChhclJlZiwgcGh5c0FybSwgbG9jYWxfbWFwX3B0cik7CisJCWRldkhhbmRs
ZSA9IE1SX1BkRGV2SGFuZGxlR2V0KHBkLCBsb2NhbF9tYXBfcHRyKTsKKworCQkvKiBidWlsZCBy
ZXF1ZXN0IGRlc2NyaXB0b3IgKi8KKwkJY21kLT5yZXF1ZXN0X2Rlc2MtPlNDU0lJTy5SZXF1ZXN0
RmxhZ3MgPQorCQkJKE1QSTJfUkVRX0RFU0NSSVBUX0ZMQUdTX0hJR0hfUFJJT1JJVFkgPDwKKwkJ
CSBNRUdBU0FTX1JFUV9ERVNDUklQVF9GTEFHU19UWVBFX1NISUZUKTsKKwkJY21kLT5yZXF1ZXN0
X2Rlc2MtPlNDU0lJTy5EZXZIYW5kbGUgPSBkZXZIYW5kbGU7CisKKwkJLyogcG9wdWxhdGUgdGhl
IExVTiBmaWVsZCAqLworCQltZW1jcHkoaW9fcmVxdWVzdC0+TFVOLCByYWlkLT5MVU4sIDgpOwor
CisJCS8qIGJ1aWxkIHRoZSByYWlkU2NzaUlPIHN0cnVjdHVyZSAqLworCQlpb19yZXF1ZXN0LT5G
dW5jdGlvbiA9IE1QSTJfRlVOQ1RJT05fU0NTSV9JT19SRVFVRVNUOworCQlpb19yZXF1ZXN0LT5E
ZXZIYW5kbGUgPSBkZXZIYW5kbGU7CisKKwkJcmV0dXJuOworCitOb25GYXN0UGF0aDoKIAkJaW9f
cmVxdWVzdC0+RnVuY3Rpb24gID0gTUVHQVNBU19NUEkyX0ZVTkNUSU9OX0xEX0lPX1JFUVVFU1Q7
CiAJCWlvX3JlcXVlc3QtPkRldkhhbmRsZSA9IGRldmljZV9pZDsKIAkJY21kLT5yZXF1ZXN0X2Rl
c2MtPlNDU0lJTy5SZXF1ZXN0RmxhZ3MgPQpAQCAtMTYzMSw3ICsxNjk3LDYgQEAKIAl9CiAJaW9f
cmVxdWVzdC0+UmFpZENvbnRleHQuVmlydHVhbERpc2tUZ3RJZCA9IGRldmljZV9pZDsKIAlpb19y
ZXF1ZXN0LT5MVU5bMV0gPSBzY21kLT5kZXZpY2UtPmx1bjsKLQlpb19yZXF1ZXN0LT5EYXRhTGVu
Z3RoID0gc2NzaV9idWZmbGVuKHNjbWQpOwogfQogCiAvKioKZGlmZiAtTmF1ciBzY3NpLW1pc2Mu
b2xkL2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9zYXNfZnVzaW9uLmggc2NzaS1taXNj
Lm5ldy9kcml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVnYXJhaWRfc2FzX2Z1c2lvbi5oCi0tLSBzY3Np
LW1pc2Mub2xkL2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9zYXNfZnVzaW9uLmgJMjAx
My0wOC0zMSAxNjoxNzo1Ni45MDkxNzI2NDggLTA3MDAKKysrIHNjc2ktbWlzYy5uZXcvZHJpdmVy
cy9zY3NpL21lZ2FyYWlkL21lZ2FyYWlkX3Nhc19mdXNpb24uaAkyMDEzLTA4LTMxIDE2OjIzOjMx
LjA3OTE0MDM5MyAtMDcwMApAQCAtNTI3LDcgKzUyNyw4IEBACiAJCXUzMiAgICAgZnBSZWFkQ2Fw
YWJsZToxOwogCQl1MzIgICAgIGZwV3JpdGVBY3Jvc3NTdHJpcGU6MTsKIAkJdTMyICAgICBmcFJl
YWRBY3Jvc3NTdHJpcGU6MTsKLQkJdTMyICAgICByZXNlcnZlZDQ6ODsKKwkJdTMyCWZwTm9uUldD
YXBhYmxlOjE7CisJCXUzMiAgICAgcmVzZXJ2ZWQ0Ojc7CiAJfSBjYXBhYmlsaXR5OwogCXUzMiAg
ICAgcmVzZXJ2ZWQ2OwogCXU2NCAgICAgc2l6ZTsKQEAgLTU1MSw3ICs1NTIsOSBAQAogCQl1MzIg
cmVzZXJ2ZWQ6MzE7CiAJfSBmbGFnczsKIAotCXU4ICAgICAgcmVzZXJ2ZWQzWzB4NUNdOworCXU4
CUxVTls4XTsgLyogMHgyNCA4IGJ5dGUgTFVOIGZpZWxkIHVzZWQgZm9yIFNDU0kgSU8ncyAqLwor
CXU4CWZwSW9UaW1lb3V0Rm9yTGQ7LyoweDJDIHRpbWVvdXQgdmFsdWUgdXNlZCBieSBkcml2ZXIg
aW4gRlAgSU8qLworCXU4ICAgICAgcmVzZXJ2ZWQzWzB4ODAtMHgyRF07IC8qIDB4MkQgKi8KIH07
CiAKIHN0cnVjdCBNUl9MRF9TUEFOX01BUCB7CmRpZmYgLU5hdXIgc2NzaS1taXNjLm9sZC9kcml2
ZXJzL3Njc2kvbWVnYXJhaWQvbWVnYXJhaWRfc2FzLmggc2NzaS1taXNjLm5ldy9kcml2ZXJzL3Nj
c2kvbWVnYXJhaWQvbWVnYXJhaWRfc2FzLmgKLS0tIHNjc2ktbWlzYy5vbGQvZHJpdmVycy9zY3Np
L21lZ2FyYWlkL21lZ2FyYWlkX3Nhcy5oCTIwMTMtMDgtMzEgMTY6MTc6NTYuOTEwMTE0NzI1IC0w
NzAwCisrKyBzY3NpLW1pc2MubmV3L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9zYXMu
aAkyMDEzLTA4LTMxIDE2OjIzOjMxLjA3OTE0MDM5MyAtMDcwMApAQCAtMTcwLDYgKzE3MCw3IEBA
CiAKICNkZWZpbmUgTVJfRENNRF9DVFJMX0dFVF9JTkZPCQkJMHgwMTAxMDAwMAogI2RlZmluZSBN
Ul9EQ01EX0xEX0dFVF9MSVNUCQkJMHgwMzAxMDAwMAorI2RlZmluZSBNUl9EQ01EX0xEX0xJU1Rf
UVVFUlkJCQkweDAzMDEwMTAwCiAKICNkZWZpbmUgTVJfRENNRF9DVFJMX0NBQ0hFX0ZMVVNICQkw
eDAxMTAxMDAwCiAjZGVmaW5lIE1SX0ZMVVNIX0NUUkxfQ0FDSEUJCQkweDAxCkBAIC0zNDUsNiAr
MzQ2LDE1IEBACiAJTVJfUERfUVVFUllfVFlQRV9FWFBPU0VEX1RPX0hPU1QgICAgPSA1LAogfTsK
IAorZW51bSBNUl9MRF9RVUVSWV9UWVBFIHsKKwlNUl9MRF9RVUVSWV9UWVBFX0FMTAkgICAgICAg
ICA9IDAsCisJTVJfTERfUVVFUllfVFlQRV9FWFBPU0VEX1RPX0hPU1QgPSAxLAorCU1SX0xEX1FV
RVJZX1RZUEVfVVNFRF9UR1RfSURTICAgID0gMiwKKwlNUl9MRF9RVUVSWV9UWVBFX0NMVVNURVJf
QUNDRVNTICA9IDMsCisJTVJfTERfUVVFUllfVFlQRV9DTFVTVEVSX0xPQ0FMRSAgPSA0LAorfTsK
KworCiAjZGVmaW5lIE1SX0VWVF9DRkdfQ0xFQVJFRCAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgIDB4MDAwNAogI2RlZmluZSBNUl9FVlRfTERfU1RBVEVfQ0hBTkdFICAgICAgICAgICAgICAg
ICAgICAgICAgICAweDAwNTEKICNkZWZpbmUgTVJfRVZUX1BEX0lOU0VSVEVEICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgMHgwMDViCkBAIC00MzUsNiArNDQ1LDE0IEBACiAJfSBsZExpc3Rb
TUFYX0xPR0lDQUxfRFJJVkVTXTsKIH0gX19wYWNrZWQ7CiAKK3N0cnVjdCBNUl9MRF9UQVJHRVRJ
RF9MSVNUIHsKKwl1MzIJc2l6ZTsKKwl1MzIJY291bnQ7CisJdTgJcGFkWzNdOworCXU4CXRhcmdl
dElkW01BWF9MT0dJQ0FMX0RSSVZFU107Cit9OworCisKIC8qCiAgKiBTQVMgY29udHJvbGxlciBw
cm9wZXJ0aWVzCiAgKi8KQEAgLTg2Myw3ICs4ODEsNyBAQAogICogPT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PQogICovCiAjZGVmaW5lIE1FR0FTQVNfTUFYX1BEX0NIQU5ORUxTCQkJMgot
I2RlZmluZSBNRUdBU0FTX01BWF9MRF9DSEFOTkVMUwkJCTIKKyNkZWZpbmUgTUVHQVNBU19NQVhf
TERfQ0hBTk5FTFMJCQkxCiAjZGVmaW5lIE1FR0FTQVNfTUFYX0NIQU5ORUxTCQkJKE1FR0FTQVNf
TUFYX1BEX0NIQU5ORUxTICsgXAogCQkJCQkJTUVHQVNBU19NQVhfTERfQ0hBTk5FTFMpCiAjZGVm
aW5lIE1FR0FTQVNfTUFYX0RFVl9QRVJfQ0hBTk5FTAkJMTI4Cg==
--047d7bf1651ed914b204e5470e52--

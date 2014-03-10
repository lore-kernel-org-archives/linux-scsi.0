From: adam radford <aradford@gmail.com>
Subject: [PATCH 4/5] megaraid_sas: Add Dell PowerEdge VRTX SR-IOV VF support
Date: Mon, 10 Mar 2014 02:51:56 -0700
Message-ID: <CAHtARFE4BXRFHM2noKPX1-vXas3WXCiL_ZZH_hcp8RCBGQZkcg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=20cf301af335d6105b04f43d8d79
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yk0-f175.google.com ([209.85.160.175]:54972 "EHLO
	mail-yk0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753292AbaCJJv5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Mar 2014 05:51:57 -0400
Received: by mail-yk0-f175.google.com with SMTP id 131so18515132ykp.6
        for <linux-scsi@vger.kernel.org>; Mon, 10 Mar 2014 02:51:56 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Kashyap Desai <Kashyap.Desai@lsi.com>, "Saxena, Sumit" <Sumit.Saxena@lsi.com>

--20cf301af335d6105b04f43d8d79
Content-Type: text/plain; charset=ISO-8859-1

James/linux-scsi,

The following patch for megaraid_sas adds Dell PowerEdge VRTS SR-IOV VF
support (Device ID 0x002f).

This patch has some > 80 column lines that need to be left in place
for code readability purposes.

Signed-off-by: Adam Radford <aradford@gmail.com>

diff -Naur scsi-misc.old/drivers/scsi/megaraid/megaraid_sas_base.c
scsi-misc.new/drivers/scsi/megaraid/megaraid_sas_base.c
--- scsi-misc.old/drivers/scsi/megaraid/megaraid_sas_base.c 2014-03-09
21:07:03.892980883 -0700
+++ scsi-misc.new/drivers/scsi/megaraid/megaraid_sas_base.c 2014-03-10
01:12:05.516855851 -0700
@@ -75,6 +75,10 @@
 module_param(msix_vectors, int, S_IRUGO);
 MODULE_PARM_DESC(msix_vectors, "MSI-X max vector count. Default: Set by FW");

+static int allow_vf_ioctls;
+module_param(allow_vf_ioctls, int, S_IRUGO);
+MODULE_PARM_DESC(allow_vf_ioctls, "Allow ioctls in SR-IOV VF mode.
Default: 0");
+
 static int throttlequeuedepth = MEGASAS_THROTTLE_QUEUE_DEPTH;
 module_param(throttlequeuedepth, int, S_IRUGO);
 MODULE_PARM_DESC(throttlequeuedepth,
@@ -122,6 +126,8 @@
  /* xscale IOP */
  {PCI_DEVICE(PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_LSI_FUSION)},
  /* Fusion */
+ {PCI_DEVICE(PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_LSI_PLASMA)},
+ /* Plasma */
  {PCI_DEVICE(PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_LSI_INVADER)},
  /* Invader */
  {PCI_DEVICE(PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_LSI_FURY)},
@@ -132,7 +138,7 @@
 MODULE_DEVICE_TABLE(pci, megasas_pci_table);

 static int megasas_mgmt_majorno;
-static struct megasas_mgmt_info megasas_mgmt_info;
+struct megasas_mgmt_info megasas_mgmt_info;
 static struct fasync_struct *megasas_async_queue;
 static DEFINE_MUTEX(megasas_async_queue_mutex);

@@ -171,10 +177,15 @@
 int
 megasas_sync_map_info(struct megasas_instance *instance);
 int
-wait_and_poll(struct megasas_instance *instance, struct megasas_cmd *cmd);
+wait_and_poll(struct megasas_instance *instance, struct megasas_cmd *cmd,
+ int seconds);
 void megasas_reset_reply_desc(struct megasas_instance *instance);
-int megasas_reset_fusion(struct Scsi_Host *shost);
+int megasas_reset_fusion(struct Scsi_Host *shost, int iotimeout);
 void megasas_fusion_ocr_wq(struct work_struct *work);
+static int megasas_get_ld_vf_affiliation(struct megasas_instance *instance,
+ int initial);
+int megasas_check_mpio_paths(struct megasas_instance *instance,
+     struct scsi_cmnd *scmd);

 void
 megasas_issue_dcmd(struct megasas_instance *instance, struct megasas_cmd *cmd)
@@ -224,6 +235,7 @@
  cmd->scmd = NULL;
  cmd->frame_count = 0;
  if ((instance->pdev->device != PCI_DEVICE_ID_LSI_FUSION) &&
+    (instance->pdev->device != PCI_DEVICE_ID_LSI_PLASMA) &&
     (instance->pdev->device != PCI_DEVICE_ID_LSI_INVADER) &&
     (instance->pdev->device != PCI_DEVICE_ID_LSI_FURY) &&
     (reset_devices))
@@ -877,6 +889,7 @@
 int
 megasas_issue_polled(struct megasas_instance *instance, struct
megasas_cmd *cmd)
 {
+ int seconds;

  struct megasas_header *frame_hdr = &cmd->frame->hdr;

@@ -891,7 +904,11 @@
  /*
  * Wait for cmd_status to change
  */
- return wait_and_poll(instance, cmd);
+ if (instance->requestorId)
+ seconds = MEGASAS_ROUTINE_WAIT_TIME_VF;
+ else
+ seconds = MFI_POLL_TIMEOUT_SECS;
+ return wait_and_poll(instance, cmd, seconds);
 }

 /**
@@ -1532,9 +1549,23 @@

  spin_lock_irqsave(&instance->hba_lock, flags);

+ /* Check for an mpio path and adjust behavior */
+ if (instance->adprecovery == MEGASAS_ADPRESET_SM_INFAULT) {
+ if (megasas_check_mpio_paths(instance, scmd) ==
+    (DID_RESET << 16)) {
+ spin_unlock_irqrestore(&instance->hba_lock, flags);
+ return SCSI_MLQUEUE_HOST_BUSY;
+ } else {
+ spin_unlock_irqrestore(&instance->hba_lock, flags);
+ scmd->result = DID_NO_CONNECT << 16;
+ done(scmd);
+ return 0;
+ }
+ }
+
  if (instance->adprecovery == MEGASAS_HW_CRITICAL_ERROR) {
  spin_unlock_irqrestore(&instance->hba_lock, flags);
- scmd->result = DID_ERROR << 16;
+ scmd->result = DID_NO_CONNECT << 16;
  done(scmd);
  return 0;
  }
@@ -1659,9 +1690,14 @@
  if ((instance->pdev->device == PCI_DEVICE_ID_LSI_SAS0073SKINNY) ||
     (instance->pdev->device == PCI_DEVICE_ID_LSI_SAS0071SKINNY) ||
     (instance->pdev->device == PCI_DEVICE_ID_LSI_FUSION) ||
+    (instance->pdev->device == PCI_DEVICE_ID_LSI_PLASMA) ||
     (instance->pdev->device == PCI_DEVICE_ID_LSI_INVADER) ||
     (instance->pdev->device == PCI_DEVICE_ID_LSI_FURY)) {
  writel(MFI_STOP_ADP, &instance->reg_set->doorbell);
+ /* Flush */
+ readl(&instance->reg_set->doorbell);
+ if (instance->mpio && instance->requestorId)
+ memset(instance->ld_ids, 0xff, MEGASAS_MAX_LD_IDS);
  } else {
  writel(MFI_STOP_ADP, &instance->reg_set->inbound_doorbell);
  }
@@ -1748,6 +1784,25 @@
  megasas_check_and_restore_queue_depth(instance);
 }

+/**
+ * megasas_start_timer - Initializes a timer object
+ * @instance: Adapter soft state
+ * @timer: timer object to be initialized
+ * @fn: timer function
+ * @interval: time interval between timer function call
+ *
+ */
+void megasas_start_timer(struct megasas_instance *instance,
+ struct timer_list *timer,
+ void *fn, unsigned long interval)
+{
+ init_timer(timer);
+ timer->expires = jiffies + interval;
+ timer->data = (unsigned long)instance;
+ timer->function = fn;
+ add_timer(timer);
+}
+
 static void
 megasas_internal_reset_defer_cmds(struct megasas_instance *instance);

@@ -1770,6 +1825,295 @@
  process_fw_state_change_wq(&instance->work_init);
 }

+/* This function will get the current SR-IOV LD/VF affiliation */
+static int megasas_get_ld_vf_affiliation(struct megasas_instance *instance,
+ int initial)
+{
+ struct megasas_cmd *cmd;
+ struct megasas_dcmd_frame *dcmd;
+ struct MR_LD_VF_AFFILIATION *new_affiliation = NULL;
+ struct MR_LD_VF_AFFILIATION_111 *new_affiliation_111 = NULL;
+ struct MR_LD_VF_MAP *newmap = NULL, *savedmap = NULL;
+ dma_addr_t new_affiliation_h;
+ dma_addr_t new_affiliation_111_h;
+ int ld, retval = 0;
+ u8 thisVf;
+
+ cmd = megasas_get_cmd(instance);
+
+ if (!cmd) {
+ printk(KERN_DEBUG "megasas: megasas_get_ld_vf_"
+       "affiliation: Failed to get cmd for scsi%d.\n",
+ instance->host->host_no);
+ return -ENOMEM;
+ }
+
+ dcmd = &cmd->frame->dcmd;
+
+ if (!instance->vf_affiliation && !instance->vf_affiliation_111) {
+ printk(KERN_WARNING "megasas: SR-IOV: Couldn't get LD/VF "
+       "affiliation for scsi%d.\n", instance->host->host_no);
+ megasas_return_cmd(instance, cmd);
+ return -ENOMEM;
+ }
+
+ if (initial)
+ if (instance->PlasmaFW111)
+ memset(instance->vf_affiliation_111, 0,
+       sizeof(struct MR_LD_VF_AFFILIATION_111));
+ else
+ memset(instance->vf_affiliation, 0,
+       (MAX_LOGICAL_DRIVES + 1) *
+       sizeof(struct MR_LD_VF_AFFILIATION));
+ else {
+ if (instance->PlasmaFW111)
+ new_affiliation_111 =
+ pci_alloc_consistent(instance->pdev,
+     sizeof(struct MR_LD_VF_AFFILIATION_111),
+     &new_affiliation_111_h);
+ else
+ new_affiliation =
+ pci_alloc_consistent(instance->pdev,
+     (MAX_LOGICAL_DRIVES + 1) *
+     sizeof(struct MR_LD_VF_AFFILIATION),
+     &new_affiliation_h);
+ if (!new_affiliation && !new_affiliation_111) {
+ printk(KERN_DEBUG "megasas: SR-IOV: Couldn't allocate "
+       "memory for new affiliation for scsi%d.\n",
+ instance->host->host_no);
+ megasas_return_cmd(instance, cmd);
+ return -ENOMEM;
+ }
+ if (instance->PlasmaFW111)
+ memset(new_affiliation_111, 0,
+       sizeof(struct MR_LD_VF_AFFILIATION_111));
+ else
+ memset(new_affiliation, 0, (MAX_LOGICAL_DRIVES + 1) *
+       sizeof(struct MR_LD_VF_AFFILIATION));
+ }
+
+ memset(dcmd->mbox.b, 0, MFI_MBOX_SIZE);
+
+ dcmd->cmd = MFI_CMD_DCMD;
+ dcmd->cmd_status = 0xFF;
+ dcmd->sge_count = 1;
+ dcmd->flags = MFI_FRAME_DIR_BOTH;
+ dcmd->timeout = 0;
+ dcmd->pad_0 = 0;
+ if (instance->PlasmaFW111) {
+ dcmd->data_xfer_len = sizeof(struct MR_LD_VF_AFFILIATION_111);
+ dcmd->opcode = MR_DCMD_LD_VF_MAP_GET_ALL_LDS_111;
+ } else {
+ dcmd->data_xfer_len = (MAX_LOGICAL_DRIVES + 1) *
+ sizeof(struct MR_LD_VF_AFFILIATION);
+ dcmd->opcode = MR_DCMD_LD_VF_MAP_GET_ALL_LDS;
+ }
+
+ if (initial) {
+ if (instance->PlasmaFW111)
+ dcmd->sgl.sge32[0].phys_addr =
+  instance->vf_affiliation_111_h;
+ else
+ dcmd->sgl.sge32[0].phys_addr =
+  instance->vf_affiliation_h;
+ } else {
+ if (instance->PlasmaFW111)
+ dcmd->sgl.sge32[0].phys_addr = new_affiliation_111_h;
+ else
+ dcmd->sgl.sge32[0].phys_addr = new_affiliation_h;
+ }
+ if (instance->PlasmaFW111)
+ dcmd->sgl.sge32[0].length =
+  sizeof(struct MR_LD_VF_AFFILIATION_111);
+ else
+ dcmd->sgl.sge32[0].length = (MAX_LOGICAL_DRIVES + 1) *
+ sizeof(struct MR_LD_VF_AFFILIATION);
+
+ printk(KERN_WARNING "megasas: SR-IOV: Getting LD/VF affiliation for "
+       "scsi%d\n", instance->host->host_no);
+
+ megasas_issue_blocked_cmd(instance, cmd, 0);
+
+ if (dcmd->cmd_status) {
+ printk(KERN_WARNING "megasas: SR-IOV: LD/VF affiliation DCMD"
+       " failed with status 0x%x for scsi%d.\n",
+       dcmd->cmd_status, instance->host->host_no);
+ retval = 1; /* Do a scan if we couldn't get affiliation */
+ goto out;
+ }
+
+ if (!initial) {
+ if (instance->PlasmaFW111) {
+ if (!new_affiliation_111->vdCount) {
+ printk(KERN_WARNING "megasas: SR-IOV: Got new "
+       "LD/VF affiliation for passive path "
+       "for scsi%d.\n",
+ instance->host->host_no);
+ retval = 1;
+ goto out;
+ }
+ thisVf = new_affiliation_111->thisVf;
+ for (ld = 0 ; ld < new_affiliation_111->vdCount; ld++)
+ if (instance->vf_affiliation_111->map[ld].policy[thisVf] !=
new_affiliation_111->map[ld].policy[thisVf]) {
+ printk(KERN_WARNING "megasas: SR-IOV: "
+       "Got new LD/VF affiliation "
+       "for scsi%d.\n",
+ instance->host->host_no);
+ memcpy(instance->vf_affiliation_111,
+       new_affiliation_111,
+       sizeof(struct MR_LD_VF_AFFILIATION_111));
+ retval = 1;
+ goto out;
+ }
+ } else {
+ if (!new_affiliation->ldCount) {
+ printk(KERN_WARNING "megasas: SR-IOV: Got new "
+       "LD/VF affiliation for passive "
+       "path for scsi%d.\n",
+       instance->host->host_no);
+ retval = 1;
+ goto out;
+ }
+ newmap = new_affiliation->map;
+ savedmap = instance->vf_affiliation->map;
+ thisVf = new_affiliation->thisVf;
+ for (ld = 0 ; ld < new_affiliation->ldCount; ld++) {
+ if (savedmap->policy[thisVf] !=
+    newmap->policy[thisVf]) {
+ printk(KERN_WARNING "megasas: SR-IOV: "
+       "Got new LD/VF affiliation "
+       "for scsi%d.\n",
+ instance->host->host_no);
+ memcpy(instance->vf_affiliation,
+       new_affiliation,
+       new_affiliation->size);
+ retval = 1;
+ goto out;
+ }
+ savedmap = (struct MR_LD_VF_MAP *)
+ ((unsigned char *)savedmap +
+ savedmap->size);
+ newmap = (struct MR_LD_VF_MAP *)
+ ((unsigned char *)newmap +
+ newmap->size);
+ }
+ }
+ }
+out:
+ if (new_affiliation) {
+ if (instance->PlasmaFW111)
+ pci_free_consistent(instance->pdev,
+    sizeof(struct MR_LD_VF_AFFILIATION_111),
+    new_affiliation_111,
+    new_affiliation_111_h);
+ else
+ pci_free_consistent(instance->pdev,
+    (MAX_LOGICAL_DRIVES + 1) *
+    sizeof(struct MR_LD_VF_AFFILIATION),
+    new_affiliation, new_affiliation_h);
+ }
+ megasas_return_cmd(instance, cmd);
+
+ return retval;
+}
+
+/* This function will tell FW to start the SR-IOV heartbeat */
+int megasas_sriov_start_heartbeat(struct megasas_instance *instance,
+ int initial)
+{
+ struct megasas_cmd *cmd;
+ struct megasas_dcmd_frame *dcmd;
+ int retval = 0;
+
+ cmd = megasas_get_cmd(instance);
+
+ if (!cmd) {
+ printk(KERN_DEBUG "megasas: megasas_sriov_start_heartbeat: "
+       "Failed to get cmd for scsi%d.\n",
+       instance->host->host_no);
+ return -ENOMEM;
+ }
+
+ dcmd = &cmd->frame->dcmd;
+
+ if (initial) {
+ instance->hb_host_mem =
+ pci_alloc_consistent(instance->pdev,
+     sizeof(struct MR_CTRL_HB_HOST_MEM),
+     &instance->hb_host_mem_h);
+ if (!instance->hb_host_mem) {
+ printk(KERN_DEBUG "megasas: SR-IOV: Couldn't allocate"
+       " memory for heartbeat host memory for "
+       "scsi%d.\n", instance->host->host_no);
+ retval = -ENOMEM;
+ goto out;
+ }
+ memset(instance->hb_host_mem, 0,
+       sizeof(struct MR_CTRL_HB_HOST_MEM));
+ }
+
+ memset(dcmd->mbox.b, 0, MFI_MBOX_SIZE);
+
+ dcmd->mbox.s[0] = sizeof(struct MR_CTRL_HB_HOST_MEM);
+ dcmd->cmd = MFI_CMD_DCMD;
+ dcmd->cmd_status = 0xFF;
+ dcmd->sge_count = 1;
+ dcmd->flags = MFI_FRAME_DIR_BOTH;
+ dcmd->timeout = 0;
+ dcmd->pad_0 = 0;
+ dcmd->data_xfer_len = sizeof(struct MR_CTRL_HB_HOST_MEM);
+ dcmd->opcode = MR_DCMD_CTRL_SHARED_HOST_MEM_ALLOC;
+ dcmd->sgl.sge32[0].phys_addr = instance->hb_host_mem_h;
+ dcmd->sgl.sge32[0].length = sizeof(struct MR_CTRL_HB_HOST_MEM);
+
+ printk(KERN_WARNING "megasas: SR-IOV: Starting heartbeat for scsi%d\n",
+       instance->host->host_no);
+
+ if (!megasas_issue_polled(instance, cmd)) {
+ retval = 0;
+ } else {
+ printk(KERN_WARNING "megasas: SR-IOV: MR_DCMD_CTRL_SHARED_HOST"
+       "_MEM_ALLOC DCMD timed out for scsi%d\n",
+       instance->host->host_no);
+ retval = 1;
+ goto out;
+ }
+
+
+ if (dcmd->cmd_status) {
+ printk(KERN_WARNING "megasas: SR-IOV: MR_DCMD_CTRL_SHARED_HOST"
+       "_MEM_ALLOC DCMD failed with status 0x%x for scsi%d\n",
+       dcmd->cmd_status,
+       instance->host->host_no);
+ retval = 1;
+ goto out;
+ }
+
+out:
+ megasas_return_cmd(instance, cmd);
+
+ return retval;
+}
+
+/* Handler for SR-IOV heartbeat */
+void megasas_sriov_heartbeat_handler(unsigned long instance_addr)
+{
+ struct megasas_instance *instance =
+ (struct megasas_instance *)instance_addr;
+
+ if (instance->hb_host_mem->HB.fwCounter !=
+    instance->hb_host_mem->HB.driverCounter) {
+ instance->hb_host_mem->HB.driverCounter =
+ instance->hb_host_mem->HB.fwCounter;
+ mod_timer(&instance->sriov_heartbeat_timer,
+  jiffies + MEGASAS_SRIOV_HEARTBEAT_INTERVAL_VF);
+ } else {
+ printk(KERN_WARNING "megasas: SR-IOV: Heartbeat never "
+       "completed for scsi%d\n", instance->host->host_no);
+ schedule_work(&instance->work_init);
+ }
+}
+
 /**
  * megasas_wait_for_outstanding - Wait for all outstanding cmds
  * @instance: Adapter soft state
@@ -2032,9 +2376,10 @@
  * First wait for all commands to complete
  */
  if ((instance->pdev->device == PCI_DEVICE_ID_LSI_FUSION) ||
+    (instance->pdev->device == PCI_DEVICE_ID_LSI_PLASMA) ||
     (instance->pdev->device == PCI_DEVICE_ID_LSI_INVADER) ||
     (instance->pdev->device == PCI_DEVICE_ID_LSI_FURY))
- ret = megasas_reset_fusion(scmd->device->host);
+ ret = megasas_reset_fusion(scmd->device->host, 1);
  else
  ret = megasas_generic_reset(scmd);

@@ -2749,6 +3094,8 @@
  (instance->pdev->device ==
  PCI_DEVICE_ID_LSI_FUSION) ||
  (instance->pdev->device ==
+ PCI_DEVICE_ID_LSI_PLASMA) ||
+ (instance->pdev->device ==
  PCI_DEVICE_ID_LSI_INVADER) ||
  (instance->pdev->device ==
  PCI_DEVICE_ID_LSI_FURY)) {
@@ -2773,6 +3120,8 @@
     (instance->pdev->device ==
      PCI_DEVICE_ID_LSI_FUSION) ||
     (instance->pdev->device ==
+     PCI_DEVICE_ID_LSI_PLASMA) ||
+    (instance->pdev->device ==
      PCI_DEVICE_ID_LSI_INVADER) ||
     (instance->pdev->device ==
      PCI_DEVICE_ID_LSI_FURY)) {
@@ -2798,6 +3147,8 @@
  (instance->pdev->device
  == PCI_DEVICE_ID_LSI_FUSION) ||
  (instance->pdev->device
+ == PCI_DEVICE_ID_LSI_PLASMA) ||
+ (instance->pdev->device
  == PCI_DEVICE_ID_LSI_INVADER) ||
  (instance->pdev->device
  == PCI_DEVICE_ID_LSI_FURY)) {
@@ -2806,6 +3157,8 @@
  if ((instance->pdev->device ==
  PCI_DEVICE_ID_LSI_FUSION) ||
  (instance->pdev->device ==
+ PCI_DEVICE_ID_LSI_PLASMA) ||
+ (instance->pdev->device ==
  PCI_DEVICE_ID_LSI_INVADER) ||
  (instance->pdev->device ==
  PCI_DEVICE_ID_LSI_FURY)) {
@@ -3032,6 +3385,7 @@
  cmd->frame->io.context = cpu_to_le32(cmd->index);
  cmd->frame->io.pad_0 = 0;
  if ((instance->pdev->device != PCI_DEVICE_ID_LSI_FUSION) &&
+    (instance->pdev->device != PCI_DEVICE_ID_LSI_PLASMA) &&
     (instance->pdev->device != PCI_DEVICE_ID_LSI_INVADER) &&
  (instance->pdev->device != PCI_DEVICE_ID_LSI_FURY) &&
     (reset_devices))
@@ -3638,6 +3992,7 @@
  struct megasas_ctrl_info *ctrl_info;
  unsigned long bar_list;
  int i, loop, fw_msix_count = 0;
+ struct IOV_111 *iovPtr;

  /* Find first memory bar */
  bar_list = pci_select_bars(instance->pdev, IORESOURCE_MEM);
@@ -3660,6 +4015,7 @@

  switch (instance->pdev->device) {
  case PCI_DEVICE_ID_LSI_FUSION:
+ case PCI_DEVICE_ID_LSI_PLASMA:
  case PCI_DEVICE_ID_LSI_INVADER:
  case PCI_DEVICE_ID_LSI_FURY:
  instance->instancet = &megasas_instance_template_fusion;
@@ -3714,7 +4070,8 @@
  scratch_pad_2 = readl
  (&instance->reg_set->outbound_scratch_pad_2);
  /* Check max MSI-X vectors */
- if (instance->pdev->device == PCI_DEVICE_ID_LSI_FUSION) {
+ if ((instance->pdev->device == PCI_DEVICE_ID_LSI_FUSION) ||
+    (instance->pdev->device == PCI_DEVICE_ID_LSI_PLASMA)) {
  instance->msix_vectors = (scratch_pad_2
  & MR_MAX_REPLY_QUEUES_OFFSET) + 1;
  fw_msix_count = instance->msix_vectors;
@@ -3825,6 +4182,7 @@
  ctrl_info->properties.OnOffProperties.disableOnlineCtrlReset;
  /* adapterOperations2 are converted into CPU arch*/
  le32_to_cpus((u32 *)&ctrl_info->adapterOperations2);
+ instance->mpio = ctrl_info->adapterOperations2.mpio;
  instance->UnevenSpanSupport =
  ctrl_info->adapterOperations2.supportUnevenSpans;
  if (instance->UnevenSpanSupport) {
@@ -3837,6 +4195,20 @@
  fusion->fast_path_io = 0;

  }
+ if (ctrl_info->host_interface.SRIOV) {
+ if (!ctrl_info->adapterOperations2.activePassive)
+ instance->PlasmaFW111 = 1;
+
+ if (!instance->PlasmaFW111)
+ instance->requestorId =
+ ctrl_info->iov.requestorId;
+ else {
+ iovPtr = (struct IOV_111 *)((unsigned char *)ctrl_info + IOV_111_OFFSET);
+ instance->requestorId = iovPtr->requestorId;
+ }
+ printk(KERN_WARNING "megaraid_sas: I am VF "
+       "requestorId %d\n", instance->requestorId);
+ }
  }
  instance->max_sectors_per_req = instance->max_num_sge *
  PAGE_SIZE / 512;
@@ -3869,6 +4241,17 @@
  tasklet_init(&instance->isr_tasklet, instance->instancet->tasklet,
  (unsigned long)instance);

+ /* Launch SR-IOV heartbeat timer */
+ if (instance->requestorId) {
+ if (!megasas_sriov_start_heartbeat(instance, 1))
+ megasas_start_timer(instance,
+    &instance->sriov_heartbeat_timer,
+    megasas_sriov_heartbeat_handler,
+    MEGASAS_SRIOV_HEARTBEAT_INTERVAL_VF);
+ else
+ instance->skip_heartbeat_timer_del = 1;
+ }
+
  return 0;

 fail_init_adapter:
@@ -4181,6 +4564,7 @@

  /* Fusion only supports host reset */
  if ((instance->pdev->device == PCI_DEVICE_ID_LSI_FUSION) ||
+    (instance->pdev->device == PCI_DEVICE_ID_LSI_PLASMA) ||
     (instance->pdev->device == PCI_DEVICE_ID_LSI_INVADER) ||
     (instance->pdev->device == PCI_DEVICE_ID_LSI_FURY)) {
  host->hostt->eh_device_reset_handler = NULL;
@@ -4306,6 +4690,7 @@

  switch (instance->pdev->device) {
  case PCI_DEVICE_ID_LSI_FUSION:
+ case PCI_DEVICE_ID_LSI_PLASMA:
  case PCI_DEVICE_ID_LSI_INVADER:
  case PCI_DEVICE_ID_LSI_FURY:
  {
@@ -4402,6 +4787,7 @@
  instance->UnevenSpanSupport = 0;

  if ((instance->pdev->device == PCI_DEVICE_ID_LSI_FUSION) ||
+    (instance->pdev->device == PCI_DEVICE_ID_LSI_PLASMA) ||
     (instance->pdev->device == PCI_DEVICE_ID_LSI_INVADER) ||
     (instance->pdev->device == PCI_DEVICE_ID_LSI_FURY))
  INIT_WORK(&instance->work_init, megasas_fusion_ocr_wq);
@@ -4414,6 +4800,26 @@
  if (megasas_init_fw(instance))
  goto fail_init_mfi;

+ if (instance->requestorId) {
+ if (instance->PlasmaFW111) {
+ instance->vf_affiliation_111 =
+ pci_alloc_consistent(pdev, sizeof(struct MR_LD_VF_AFFILIATION_111),
+     &instance->vf_affiliation_111_h);
+ if (!instance->vf_affiliation_111)
+ printk(KERN_WARNING "megasas: Can't allocate "
+       "memory for VF affiliation buffer\n");
+ } else {
+ instance->vf_affiliation =
+ pci_alloc_consistent(pdev,
+     (MAX_LOGICAL_DRIVES + 1) *
+     sizeof(struct MR_LD_VF_AFFILIATION),
+     &instance->vf_affiliation_h);
+ if (!instance->vf_affiliation)
+ printk(KERN_WARNING "megasas: Can't allocate "
+       "memory for VF affiliation buffer\n");
+ }
+ }
+
 retry_irq_register:
  /*
  * Register IRQ
@@ -4508,6 +4914,7 @@
  free_irq(instance->pdev->irq, &instance->irq_context[0]);
 fail_irq:
  if ((instance->pdev->device == PCI_DEVICE_ID_LSI_FUSION) ||
+    (instance->pdev->device == PCI_DEVICE_ID_LSI_PLASMA) ||
     (instance->pdev->device == PCI_DEVICE_ID_LSI_INVADER) ||
     (instance->pdev->device == PCI_DEVICE_ID_LSI_FURY))
  megasas_release_fusion(instance);
@@ -4641,6 +5048,10 @@
  host = instance->host;
  instance->unload = 1;

+ /* Shutdown SR-IOV heartbeat timer */
+ if (instance->requestorId && !instance->skip_heartbeat_timer_del)
+ del_timer_sync(&instance->sriov_heartbeat_timer);
+
  megasas_flush_cache(instance);
  megasas_shutdown_controller(instance, MR_DCMD_HIBERNATE_SHUTDOWN);

@@ -4727,6 +5138,7 @@

  switch (instance->pdev->device) {
  case PCI_DEVICE_ID_LSI_FUSION:
+ case PCI_DEVICE_ID_LSI_PLASMA:
  case PCI_DEVICE_ID_LSI_INVADER:
  case PCI_DEVICE_ID_LSI_FURY:
  {
@@ -4792,6 +5204,17 @@
  }
  }

+ /* Re-launch SR-IOV heartbeat timer */
+ if (instance->requestorId) {
+ if (!megasas_sriov_start_heartbeat(instance, 0))
+ megasas_start_timer(instance,
+    &instance->sriov_heartbeat_timer,
+    megasas_sriov_heartbeat_handler,
+    MEGASAS_SRIOV_HEARTBEAT_INTERVAL_VF);
+ else
+ instance->skip_heartbeat_timer_del = 1;
+ }
+
  instance->instancet->enable_intr(instance);
  instance->unload = 0;

@@ -4846,6 +5269,10 @@
  host = instance->host;
  fusion = instance->ctrl_context;

+ /* Shutdown SR-IOV heartbeat timer */
+ if (instance->requestorId && !instance->skip_heartbeat_timer_del)
+ del_timer_sync(&instance->sriov_heartbeat_timer);
+
  scsi_remove_host(instance->host);
  megasas_flush_cache(instance);
  megasas_shutdown_controller(instance, MR_DCMD_CTRL_SHUTDOWN);
@@ -4891,6 +5318,7 @@

  switch (instance->pdev->device) {
  case PCI_DEVICE_ID_LSI_FUSION:
+ case PCI_DEVICE_ID_LSI_PLASMA:
  case PCI_DEVICE_ID_LSI_INVADER:
  case PCI_DEVICE_ID_LSI_FURY:
  megasas_release_fusion(instance);
@@ -4917,6 +5345,24 @@
  if (instance->evt_detail)
  pci_free_consistent(pdev, sizeof(struct megasas_evt_detail),
  instance->evt_detail, instance->evt_detail_h);
+
+ if (instance->vf_affiliation)
+ pci_free_consistent(pdev, (MAX_LOGICAL_DRIVES + 1) *
+    sizeof(struct MR_LD_VF_AFFILIATION),
+    instance->vf_affiliation,
+    instance->vf_affiliation_h);
+
+ if (instance->vf_affiliation_111)
+ pci_free_consistent(pdev,
+    sizeof(struct MR_LD_VF_AFFILIATION_111),
+    instance->vf_affiliation_111,
+    instance->vf_affiliation_111_h);
+
+ if (instance->hb_host_mem)
+ pci_free_consistent(pdev, sizeof(struct MR_CTRL_HB_HOST_MEM),
+    instance->hb_host_mem,
+    instance->hb_host_mem_h);
+
  scsi_host_put(host);

  pci_disable_device(pdev);
@@ -5205,6 +5651,16 @@
  goto out_kfree_ioc;
  }

+ /* Adjust ioctl wait time for VF mode */
+ if (instance->requestorId)
+ wait_time = MEGASAS_ROUTINE_WAIT_TIME_VF;
+
+ /* Block ioctls in VF mode */
+ if (instance->requestorId && !allow_vf_ioctls) {
+ error = -ENODEV;
+ goto out_kfree_ioc;
+ }
+
  if (instance->adprecovery == MEGASAS_HW_CRITICAL_ERROR) {
  printk(KERN_ERR "Controller in crit error\n");
  error = -ENODEV;
@@ -5514,7 +5970,7 @@
  u16     pd_index = 0;
  u16 ld_index = 0;
  int     i, j, doscan = 0;
- u32 seq_num;
+ u32 seq_num, wait_time = MEGASAS_RESET_WAIT_TIME;
  int error;

  if (!instance) {
@@ -5522,6 +5978,23 @@
  kfree(ev);
  return;
  }
+
+ /* Adjust event workqueue thread wait time for VF mode */
+ if (instance->requestorId)
+ wait_time = MEGASAS_ROUTINE_WAIT_TIME_VF;
+
+ /* Don't run the event workqueue thread if OCR is running */
+ for (i = 0; i < wait_time; i++) {
+ if (instance->adprecovery == MEGASAS_HBA_OPERATIONAL)
+ break;
+ if (!(i % MEGASAS_RESET_NOTICE_INTERVAL)) {
+ printk(KERN_NOTICE "megasas: %s waiting for "
+       "controller reset to finish for scsi%d\n",
+       __func__, instance->host->host_no);
+ }
+ msleep(1000);
+ }
+
  instance->ev = NULL;
  host = instance->host;
  if (instance->evt_detail) {
@@ -5588,65 +6061,64 @@
  case MR_EVT_LD_OFFLINE:
  case MR_EVT_CFG_CLEARED:
  case MR_EVT_LD_DELETED:
- if (megasas_ld_list_query(instance,
- MR_LD_QUERY_TYPE_EXPOSED_TO_HOST))
- megasas_get_ld_list(instance);
- for (i = 0; i < MEGASAS_MAX_LD_CHANNELS; i++) {
- for (j = 0;
- j < MEGASAS_MAX_DEV_PER_CHANNEL;
- j++) {
-
- ld_index =
- (i * MEGASAS_MAX_DEV_PER_CHANNEL) + j;
-
- sdev1 = scsi_device_lookup(host,
- MEGASAS_MAX_PD_CHANNELS + i,
- j,
- 0);
-
- if (instance->ld_ids[ld_index] != 0xff) {
- if (sdev1) {
- scsi_device_put(sdev1);
- }
- } else {
- if (sdev1) {
- scsi_remove_device(sdev1);
- scsi_device_put(sdev1);
+ if (!instance->requestorId ||
+    (instance->requestorId &&
+     megasas_get_ld_vf_affiliation(instance, 0))) {
+ if (megasas_ld_list_query(instance,
+  MR_LD_QUERY_TYPE_EXPOSED_TO_HOST))
+ megasas_get_ld_list(instance);
+ for (i = 0; i < MEGASAS_MAX_LD_CHANNELS; i++) {
+ for (j = 0;
+     j < MEGASAS_MAX_DEV_PER_CHANNEL;
+     j++) {
+
+ ld_index =
+ (i * MEGASAS_MAX_DEV_PER_CHANNEL) + j;
+
+ sdev1 = scsi_device_lookup(host, MEGASAS_MAX_PD_CHANNELS + i, j, 0);
+
+ if (instance->ld_ids[ld_index]
+    != 0xff) {
+ if (sdev1)
+ scsi_device_put(sdev1);
+ } else {
+ if (sdev1) {
+ scsi_remove_device(sdev1);
+ scsi_device_put(sdev1);
+ }
+ }
  }
  }
- }
+ doscan = 0;
  }
- doscan = 0;
  break;
  case MR_EVT_LD_CREATED:
- if (megasas_ld_list_query(instance,
- MR_LD_QUERY_TYPE_EXPOSED_TO_HOST))
- megasas_get_ld_list(instance);
- for (i = 0; i < MEGASAS_MAX_LD_CHANNELS; i++) {
- for (j = 0;
- j < MEGASAS_MAX_DEV_PER_CHANNEL;
- j++) {
- ld_index =
- (i * MEGASAS_MAX_DEV_PER_CHANNEL) + j;
-
- sdev1 = scsi_device_lookup(host,
- MEGASAS_MAX_PD_CHANNELS + i,
- j, 0);
-
- if (instance->ld_ids[ld_index] !=
- 0xff) {
- if (!sdev1) {
- scsi_add_device(host,
- MEGASAS_MAX_PD_CHANNELS + i,
- j, 0);
+ if (!instance->requestorId ||
+    (instance->requestorId &&
+     megasas_get_ld_vf_affiliation(instance, 0))) {
+ if (megasas_ld_list_query(instance,
+  MR_LD_QUERY_TYPE_EXPOSED_TO_HOST))
+ megasas_get_ld_list(instance);
+ for (i = 0; i < MEGASAS_MAX_LD_CHANNELS; i++) {
+ for (j = 0;
+     j < MEGASAS_MAX_DEV_PER_CHANNEL;
+     j++) {
+ ld_index =
+ (i * MEGASAS_MAX_DEV_PER_CHANNEL) + j;
+
+ sdev1 = scsi_device_lookup(host, MEGASAS_MAX_PD_CHANNELS + i, j, 0);
+
+ if (instance->ld_ids[ld_index]
+    != 0xff) {
+ if (!sdev1)
+ scsi_add_device(host, MEGASAS_MAX_PD_CHANNELS + i, j, 0);
  }
- }
- if (sdev1) {
- scsi_device_put(sdev1);
+ if (sdev1)
+ scsi_device_put(sdev1);
  }
  }
+ doscan = 0;
  }
- doscan = 0;
  break;
  case MR_EVT_CTRL_HOST_BUS_SCAN_REQUESTED:
  case MR_EVT_FOREIGN_CFG_IMPORTED:
@@ -5664,7 +6136,8 @@
  }

  if (doscan) {
- printk(KERN_INFO "scanning ...\n");
+ printk(KERN_INFO "megaraid_sas: scanning for scsi%d...\n",
+       instance->host->host_no);
  megasas_get_pd_list(instance);
  for (i = 0; i < MEGASAS_MAX_PD_CHANNELS; i++) {
  for (j = 0; j < MEGASAS_MAX_DEV_PER_CHANNEL; j++) {
@@ -5686,28 +6159,31 @@
  }
  }

- if (megasas_ld_list_query(instance,
-  MR_LD_QUERY_TYPE_EXPOSED_TO_HOST))
- megasas_get_ld_list(instance);
- for (i = 0; i < MEGASAS_MAX_LD_CHANNELS; i++) {
- for (j = 0; j < MEGASAS_MAX_DEV_PER_CHANNEL; j++) {
- ld_index =
- (i * MEGASAS_MAX_DEV_PER_CHANNEL) + j;
+ if (!instance->requestorId ||
+    (instance->requestorId &&
+     megasas_get_ld_vf_affiliation(instance, 0))) {
+ if (megasas_ld_list_query(instance,
+  MR_LD_QUERY_TYPE_EXPOSED_TO_HOST))
+ megasas_get_ld_list(instance);
+ for (i = 0; i < MEGASAS_MAX_LD_CHANNELS; i++) {
+ for (j = 0; j < MEGASAS_MAX_DEV_PER_CHANNEL;
+     j++) {
+ ld_index =
+ (i * MEGASAS_MAX_DEV_PER_CHANNEL) + j;

- sdev1 = scsi_device_lookup(host,
- MEGASAS_MAX_PD_CHANNELS + i, j, 0);
- if (instance->ld_ids[ld_index] != 0xff) {
- if (!sdev1) {
- scsi_add_device(host,
- MEGASAS_MAX_PD_CHANNELS + i,
- j, 0);
+ sdev1 = scsi_device_lookup(host,
+   MEGASAS_MAX_PD_CHANNELS + i, j, 0);
+ if (instance->ld_ids[ld_index]
+    != 0xff) {
+ if (!sdev1)
+ scsi_add_device(host, MEGASAS_MAX_PD_CHANNELS + i, j, 0);
+ else
+ scsi_device_put(sdev1);
  } else {
- scsi_device_put(sdev1);
- }
- } else {
- if (sdev1) {
- scsi_remove_device(sdev1);
- scsi_device_put(sdev1);
+ if (sdev1) {
+ scsi_remove_device(sdev1);
+ scsi_device_put(sdev1);
+ }
  }
  }
  }
diff -Naur scsi-misc.old/drivers/scsi/megaraid/megaraid_sas_fusion.c
scsi-misc.new/drivers/scsi/megaraid/megaraid_sas_fusion.c
--- scsi-misc.old/drivers/scsi/megaraid/megaraid_sas_fusion.c
2014-03-09 21:46:54.385918392 -0700
+++ scsi-misc.new/drivers/scsi/megaraid/megaraid_sas_fusion.c
2014-03-10 01:13:30.065856275 -0700
@@ -62,7 +62,8 @@
      struct megasas_cmd *cmd, u8 alt_status);
 int megasas_is_ldio(struct scsi_cmnd *cmd);
 int
-wait_and_poll(struct megasas_instance *instance, struct megasas_cmd *cmd);
+wait_and_poll(struct megasas_instance *instance, struct megasas_cmd *cmd,
+      int seconds);

 void
 megasas_return_cmd(struct megasas_instance *instance, struct megasas_cmd *cmd);
@@ -81,6 +82,13 @@
 void megaraid_sas_kill_hba(struct megasas_instance *instance);

 extern u32 megasas_dbg_lvl;
+void megasas_sriov_heartbeat_handler(unsigned long instance_addr);
+int megasas_sriov_start_heartbeat(struct megasas_instance *instance,
+  int initial);
+void megasas_start_timer(struct megasas_instance *instance,
+ struct timer_list *timer,
+ void *fn, unsigned long interval);
+extern struct megasas_mgmt_info megasas_mgmt_info;
 extern int resetwaittime;

 /**
@@ -549,12 +557,13 @@
  * For polling, MFI requires the cmd_status to be set to 0xFF before posting.
  */
 int
-wait_and_poll(struct megasas_instance *instance, struct megasas_cmd *cmd)
+wait_and_poll(struct megasas_instance *instance, struct megasas_cmd *cmd,
+ int seconds)
 {
  int i;
  struct megasas_header *frame_hdr = &cmd->frame->hdr;

- u32 msecs = MFI_POLL_TIMEOUT_SECS * 1000;
+ u32 msecs = seconds * 1000;

  /*
  * Wait for cmd_status to change
@@ -669,7 +678,7 @@
  instance->instancet->fire_cmd(instance, req_desc.u.low,
       req_desc.u.high, instance->reg_set);

- wait_and_poll(instance, cmd);
+ wait_and_poll(instance, cmd, MFI_POLL_TIMEOUT_SECS);

  frame_hdr = &cmd->frame->hdr;
  if (frame_hdr->cmd_status != 0) {
@@ -1769,7 +1778,8 @@

  if (index >= instance->max_fw_cmds) {
  printk(KERN_ERR "megasas: Invalid SMID (0x%x)request for "
-       "descriptor\n", index);
+       "descriptor for scsi%d\n", index,
+ instance->host->host_no);
  return NULL;
  }
  fusion = instance->ctrl_context;
@@ -2037,8 +2047,11 @@
  /* If we didn't complete any commands, check for FW fault */
  fw_state = instance->instancet->read_fw_status_reg(
  instance->reg_set) & MFI_STATE_MASK;
- if (fw_state == MFI_STATE_FAULT)
+ if (fw_state == MFI_STATE_FAULT) {
+ printk(KERN_WARNING "megaraid_sas: Iop2SysDoorbellInt"
+       "for scsi%d\n", instance->host->host_no);
  schedule_work(&instance->work_init);
+ }
  }

  return IRQ_HANDLED;
@@ -2209,9 +2222,10 @@
 }

 /* This function waits for outstanding commands on fusion to complete */
-int megasas_wait_for_outstanding_fusion(struct megasas_instance *instance)
+int megasas_wait_for_outstanding_fusion(struct megasas_instance *instance,
+ int iotimeout, int *convert)
 {
- int i, outstanding, retval = 0;
+ int i, outstanding, retval = 0, hb_seconds_missed = 0;
  u32 fw_state;

  for (i = 0; i < resetwaittime; i++) {
@@ -2220,18 +2234,49 @@
  instance->reg_set) & MFI_STATE_MASK;
  if (fw_state == MFI_STATE_FAULT) {
  printk(KERN_WARNING "megasas: Found FW in FAULT state,"
-       " will reset adapter.\n");
+       " will reset adapter scsi%d.\n",
+ instance->host->host_no);
+ retval = 1;
+ goto out;
+ }
+ /* If SR-IOV VF mode & heartbeat timeout, don't wait */
+ if (instance->requestorId && !iotimeout) {
  retval = 1;
  goto out;
  }

+ /* If SR-IOV VF mode & I/O timeout, check for HB timeout */
+ if (instance->requestorId && iotimeout) {
+ if (instance->hb_host_mem->HB.fwCounter !=
+    instance->hb_host_mem->HB.driverCounter) {
+ instance->hb_host_mem->HB.driverCounter =
+ instance->hb_host_mem->HB.fwCounter;
+ hb_seconds_missed = 0;
+ } else {
+ hb_seconds_missed++;
+ if (hb_seconds_missed ==
+    (MEGASAS_SRIOV_HEARTBEAT_INTERVAL_VF/HZ)) {
+ printk(KERN_WARNING "megasas: SR-IOV:"
+       " Heartbeat never completed "
+       " while polling during I/O "
+       " timeout handling for "
+       "scsi%d.\n",
+       instance->host->host_no);
+       *convert = 1;
+       retval = 1;
+       goto out;
+ }
+ }
+ }
+
  outstanding = atomic_read(&instance->fw_outstanding);
  if (!outstanding)
  goto out;

  if (!(i % MEGASAS_RESET_NOTICE_INTERVAL)) {
  printk(KERN_NOTICE "megasas: [%2d]waiting for %d "
-       "commands to complete\n", i, outstanding);
+       "commands to complete for scsi%d\n", i,
+       outstanding, instance->host->host_no);
  megasas_complete_cmd_dpc_fusion(
  (unsigned long)instance);
  }
@@ -2240,7 +2285,8 @@

  if (atomic_read(&instance->fw_outstanding)) {
  printk("megaraid_sas: pending commands remain after waiting, "
-       "will reset adapter.\n");
+       "will reset adapter scsi%d.\n",
+       instance->host->host_no);
  retval = 1;
  }
 out:
@@ -2262,10 +2308,34 @@
  reply_desc->Words = ULLONG_MAX;
 }

+/* Check for a second path that is currently UP */
+int megasas_check_mpio_paths(struct megasas_instance *instance,
+ struct scsi_cmnd *scmd)
+{
+ int i, j, retval = (DID_RESET << 16);
+
+ if (instance->mpio && instance->requestorId) {
+ for (i = 0 ; i < MAX_MGMT_ADAPTERS ; i++)
+ for (j = 0 ; j < MAX_LOGICAL_DRIVES; j++)
+ if (megasas_mgmt_info.instance[i] &&
+    (megasas_mgmt_info.instance[i] != instance) &&
+    megasas_mgmt_info.instance[i]->mpio &&
+    megasas_mgmt_info.instance[i]->requestorId
+    &&
+    (megasas_mgmt_info.instance[i]->ld_ids[j]
+     == scmd->device->id)) {
+    retval = (DID_NO_CONNECT << 16);
+    goto out;
+ }
+ }
+out:
+ return retval;
+}
+
 /* Core fusion reset function */
-int megasas_reset_fusion(struct Scsi_Host *shost)
+int megasas_reset_fusion(struct Scsi_Host *shost, int iotimeout)
 {
- int retval = SUCCESS, i, j, retry = 0;
+ int retval = SUCCESS, i, j, retry = 0, convert = 0;
  struct megasas_instance *instance;
  struct megasas_cmd_fusion *cmd_fusion;
  struct fusion_context *fusion;
@@ -2276,28 +2346,39 @@
  instance = (struct megasas_instance *)shost->hostdata;
  fusion = instance->ctrl_context;

+ mutex_lock(&instance->reset_mutex);
+
  if (instance->adprecovery == MEGASAS_HW_CRITICAL_ERROR) {
  printk(KERN_WARNING "megaraid_sas: Hardware critical error, "
-       "returning FAILED.\n");
+       "returning FAILED for scsi%d.\n",
+ instance->host->host_no);
  return FAILED;
  }

- mutex_lock(&instance->reset_mutex);
+ if (instance->requestorId && !instance->skip_heartbeat_timer_del)
+ del_timer_sync(&instance->sriov_heartbeat_timer);
  set_bit(MEGASAS_FUSION_IN_RESET, &instance->reset_flags);
- instance->adprecovery = MEGASAS_ADPRESET_SM_INFAULT;
+ instance->adprecovery = MEGASAS_ADPRESET_SM_POLLING;
  instance->instancet->disable_intr(instance);
  msleep(1000);

  /* First try waiting for commands to complete */
- if (megasas_wait_for_outstanding_fusion(instance)) {
+ if (megasas_wait_for_outstanding_fusion(instance, iotimeout,
+ &convert)) {
+ instance->adprecovery = MEGASAS_ADPRESET_SM_INFAULT;
  printk(KERN_WARNING "megaraid_sas: resetting fusion "
-       "adapter.\n");
+       "adapter scsi%d.\n", instance->host->host_no);
+ if (convert)
+ iotimeout = 0;
+
  /* Now return commands back to the OS */
  for (i = 0 ; i < instance->max_fw_cmds; i++) {
  cmd_fusion = fusion->cmd_list[i];
  if (cmd_fusion->scmd) {
  scsi_dma_unmap(cmd_fusion->scmd);
- cmd_fusion->scmd->result = (DID_RESET << 16);
+ cmd_fusion->scmd->result =
+ megasas_check_mpio_paths(instance,
+ cmd_fusion->scmd);
  cmd_fusion->scmd->scsi_done(cmd_fusion->scmd);
  megasas_return_cmd_fusion(instance, cmd_fusion);
  atomic_dec(&instance->fw_outstanding);
@@ -2312,13 +2393,67 @@
     (abs_state == MFI_STATE_FAULT && !reset_adapter)) {
  /* Reset not supported, kill adapter */
  printk(KERN_WARNING "megaraid_sas: Reset not supported"
-       ", killing adapter.\n");
+       ", killing adapter scsi%d.\n",
+ instance->host->host_no);
  megaraid_sas_kill_hba(instance);
+ instance->skip_heartbeat_timer_del = 1;
  instance->adprecovery = MEGASAS_HW_CRITICAL_ERROR;
  retval = FAILED;
  goto out;
  }

+ /* Let SR-IOV VF & PF sync up if there was a HB failure */
+ if (instance->requestorId && !iotimeout) {
+ msleep(MEGASAS_OCR_SETTLE_TIME_VF);
+ /* Look for a late HB update after VF settle time */
+ if (abs_state == MFI_STATE_OPERATIONAL &&
+    (instance->hb_host_mem->HB.fwCounter !=
+     instance->hb_host_mem->HB.driverCounter)) {
+ instance->hb_host_mem->HB.driverCounter =
+ instance->hb_host_mem->HB.fwCounter;
+ printk(KERN_WARNING "megasas: SR-IOV:"
+       "Late FW heartbeat update for "
+       "scsi%d.\n",
+       instance->host->host_no);
+ } else {
+ /* In VF mode, first poll for FW ready */
+ for (i = 0;
+     i < (MEGASAS_RESET_WAIT_TIME * 1000);
+     i += 20) {
+ status_reg =
+ instance->instancet->
+ read_fw_status_reg(
+ instance->reg_set);
+ abs_state = status_reg &
+ MFI_STATE_MASK;
+ if (abs_state == MFI_STATE_READY) {
+ printk(KERN_WARNING "megasas"
+       ": SR-IOV: FW was found"
+       "to be in ready state "
+       "for scsi%d.\n",
+       instance->host->host_no);
+ break;
+ }
+ msleep(20);
+ }
+ if (abs_state != MFI_STATE_READY) {
+ printk(KERN_WARNING "megasas: SR-IOV: "
+       "FW not in ready state after %d"
+       " seconds for scsi%d, status_reg = "
+       "0x%x.\n",
+       MEGASAS_RESET_WAIT_TIME,
+       instance->host->host_no,
+       status_reg);
+ megaraid_sas_kill_hba(instance);
+ instance->skip_heartbeat_timer_del = 1;
+ instance->adprecovery =
+ MEGASAS_HW_CRITICAL_ERROR;
+ retval = FAILED;
+ goto out;
+ }
+ }
+ }
+
  /* Now try to reset the chip */
  for (i = 0; i < MEGASAS_FUSION_MAX_RESET_TRIES; i++) {
  writel(MPI2_WRSEQ_FLUSH_KEY_VALUE,
@@ -2345,7 +2480,9 @@
  readl(&instance->reg_set->fusion_host_diag);
  if (retry++ == 100) {
  printk(KERN_WARNING "megaraid_sas: "
-       "Host diag unlock failed!\n");
+       "Host diag unlock failed! "
+       "for scsi%d\n",
+ instance->host->host_no);
  break;
  }
  }
@@ -2367,7 +2504,8 @@
  if (retry++ == 1000) {
  printk(KERN_WARNING "megaraid_sas: "
        "Diag reset adapter never "
-       "cleared!\n");
+       "cleared for scsi%d!\n",
+ instance->host->host_no);
  break;
  }
  }
@@ -2389,29 +2527,29 @@
  if (abs_state <= MFI_STATE_FW_INIT) {
  printk(KERN_WARNING "megaraid_sas: firmware "
        "state < MFI_STATE_FW_INIT, state = "
-       "0x%x\n", abs_state);
+       "0x%x for scsi%d\n", abs_state,
+ instance->host->host_no);
  continue;
  }

  /* Wait for FW to become ready */
  if (megasas_transition_to_ready(instance, 1)) {
  printk(KERN_WARNING "megaraid_sas: Failed to "
-       "transition controller to ready.\n");
+       "transition controller to ready "
+       "for scsi%d.\n",
+       instance->host->host_no);
  continue;
  }

  megasas_reset_reply_desc(instance);
  if (megasas_ioc_init_fusion(instance)) {
  printk(KERN_WARNING "megaraid_sas: "
-       "megasas_ioc_init_fusion() failed!\n");
+       "megasas_ioc_init_fusion() failed!"
+       " for scsi%d\n",
+       instance->host->host_no);
  continue;
  }

- clear_bit(MEGASAS_FUSION_IN_RESET,
-  &instance->reset_flags);
- instance->instancet->enable_intr(instance);
- instance->adprecovery = MEGASAS_HBA_OPERATIONAL;
-
  /* Re-fire management commands */
  for (j = 0 ; j < instance->max_fw_cmds; j++) {
  cmd_fusion = fusion->cmd_list[j];
@@ -2435,7 +2573,8 @@
  if (!req_desc) {
  printk(KERN_WARNING
        "req_desc NULL"
-       "\n");
+       " for scsi%d\n",
+ instance->host->host_no);
  /* Return leaked MPT
    frame */
  megasas_return_cmd_fusion(instance, cmd_fusion);
@@ -2453,6 +2592,11 @@
  }
  }

+ clear_bit(MEGASAS_FUSION_IN_RESET,
+  &instance->reset_flags);
+ instance->instancet->enable_intr(instance);
+ instance->adprecovery = MEGASAS_HBA_OPERATIONAL;
+
  /* Reset load balance info */
  memset(fusion->load_balance_info, 0,
        sizeof(struct LD_LOAD_BALANCE_INFO)
@@ -2461,19 +2605,39 @@
  if (!megasas_get_map_info(instance))
  megasas_sync_map_info(instance);

+ /* Restart SR-IOV heartbeat */
+ if (instance->requestorId) {
+ if (!megasas_sriov_start_heartbeat(instance, 0))
+ megasas_start_timer(instance,
+    &instance->sriov_heartbeat_timer,
+    megasas_sriov_heartbeat_handler,
+    MEGASAS_SRIOV_HEARTBEAT_INTERVAL_VF);
+ else
+ instance->skip_heartbeat_timer_del = 1;
+ }
+
  /* Adapter reset completed successfully */
  printk(KERN_WARNING "megaraid_sas: Reset "
-       "successful.\n");
+       "successful for scsi%d.\n",
+ instance->host->host_no);
  retval = SUCCESS;
  goto out;
  }
  /* Reset failed, kill the adapter */
  printk(KERN_WARNING "megaraid_sas: Reset failed, killing "
-       "adapter.\n");
+       "adapter scsi%d.\n", instance->host->host_no);
  megaraid_sas_kill_hba(instance);
+ instance->skip_heartbeat_timer_del = 1;
  instance->adprecovery = MEGASAS_HW_CRITICAL_ERROR;
  retval = FAILED;
  } else {
+ /* For VF: Restart HB timer if we didn't OCR */
+ if (instance->requestorId) {
+ megasas_start_timer(instance,
+    &instance->sriov_heartbeat_timer,
+    megasas_sriov_heartbeat_handler,
+    MEGASAS_SRIOV_HEARTBEAT_INTERVAL_VF);
+ }
  clear_bit(MEGASAS_FUSION_IN_RESET, &instance->reset_flags);
  instance->instancet->enable_intr(instance);
  instance->adprecovery = MEGASAS_HBA_OPERATIONAL;
@@ -2490,7 +2654,7 @@
  struct megasas_instance *instance =
  container_of(work, struct megasas_instance, work_init);

- megasas_reset_fusion(instance->host);
+ megasas_reset_fusion(instance->host, 0);
 }

 struct megasas_instance_template megasas_instance_template_fusion = {
diff -Naur scsi-misc.old/drivers/scsi/megaraid/megaraid_sas_fusion.h
scsi-misc.new/drivers/scsi/megaraid/megaraid_sas_fusion.h
--- scsi-misc.old/drivers/scsi/megaraid/megaraid_sas_fusion.h
2014-03-09 14:53:05.000000000 -0700
+++ scsi-misc.new/drivers/scsi/megaraid/megaraid_sas_fusion.h
2014-03-10 00:28:34.934856617 -0700
@@ -485,6 +485,9 @@
 #define MAX_PHYSICAL_DEVICES 256
 #define MAX_RAIDMAP_PHYSICAL_DEVICES (MAX_PHYSICAL_DEVICES)
 #define MR_DCMD_LD_MAP_GET_INFO             0x0300e101
+#define MR_DCMD_CTRL_SHARED_HOST_MEM_ALLOC  0x010e8485   /* SR-IOV HB alloc*/
+#define MR_DCMD_LD_VF_MAP_GET_ALL_LDS_111   0x03200200
+#define MR_DCMD_LD_VF_MAP_GET_ALL_LDS       0x03150200

 struct MR_DEV_HANDLE_INFO {
  u16     curDevHdl;
diff -Naur scsi-misc.old/drivers/scsi/megaraid/megaraid_sas.h
scsi-misc.new/drivers/scsi/megaraid/megaraid_sas.h
--- scsi-misc.old/drivers/scsi/megaraid/megaraid_sas.h 2014-03-09
21:06:56.499856130 -0700
+++ scsi-misc.new/drivers/scsi/megaraid/megaraid_sas.h 2014-03-10
00:28:04.993856106 -0700
@@ -48,6 +48,7 @@
 #define PCI_DEVICE_ID_LSI_SAS0073SKINNY 0x0073
 #define PCI_DEVICE_ID_LSI_SAS0071SKINNY 0x0071
 #define PCI_DEVICE_ID_LSI_FUSION 0x005b
+#define PCI_DEVICE_ID_LSI_PLASMA 0x002f
 #define PCI_DEVICE_ID_LSI_INVADER 0x005d
 #define PCI_DEVICE_ID_LSI_FURY 0x005f

@@ -559,7 +560,8 @@
  u8 PCIE:1;
  u8 iSCSI:1;
  u8 SAS_3G:1;
- u8 reserved_0:4;
+ u8 SRIOV:1;
+ u8 reserved_0:3;
  u8 reserved_1[6];
  u8 port_count;
  u64 port_addr[8];
@@ -839,7 +841,12 @@

  struct {                                /*7A4h */
 #if   defined(__BIG_ENDIAN_BITFIELD)
- u32     reserved:11;
+ u32     reserved:5;
+ u32 activePassive:2;
+ u32 supportConfigAutoBalance:1;
+ u32 mpio:1;
+ u32 supportDataLDonSSCArray:1;
+ u32 supportPointInTimeProgress:1;
  u32     supportUnevenSpans:1;
  u32     dedicatedHotSparesLimited:1;
  u32     headlessMode:1;
@@ -886,7 +893,12 @@


  u32     supportUnevenSpans:1;
- u32     reserved:11;
+ u32 supportPointInTimeProgress:1;
+ u32 supportDataLDonSSCArray:1;
+ u32 mpio:1;
+ u32 supportConfigAutoBalance:1;
+ u32 activePassive:2;
+ u32     reserved:5;
 #endif
  } adapterOperations2;

@@ -914,8 +926,14 @@
  } cluster;

  char clusterId[16];                     /*7D4h */
+ struct {
+ u8  maxVFsSupported;            /*0x7E4*/
+ u8  numVFsEnabled;              /*0x7E5*/
+ u8  requestorId;                /*0x7E6 0:PF, 1:VF1, 2:VF2*/
+ u8  reserved;                   /*0x7E7*/
+ } iov;

- u8          pad[0x800-0x7E4];           /*7E4 */
+ u8          pad[0x800-0x7E8];           /*0x7E8 pad to 2k */
 } __packed;

 /*
@@ -986,7 +1004,9 @@

 #define MFI_OB_INTR_STATUS_MASK 0x00000002
 #define MFI_POLL_TIMEOUT_SECS 60
-
+#define MEGASAS_SRIOV_HEARTBEAT_INTERVAL_VF (5 * HZ)
+#define MEGASAS_OCR_SETTLE_TIME_VF (1000 * 30)
+#define MEGASAS_ROUTINE_WAIT_TIME_VF 300
 #define MFI_REPLY_1078_MESSAGE_INTERRUPT 0x80000000
 #define MFI_REPLY_GEN2_MESSAGE_INTERRUPT 0x00000001
 #define MFI_GEN2_ENABLE_INTERRUPT_MASK (0x00000001 | 0x00000004)
@@ -1529,6 +1549,12 @@
  dma_addr_t producer_h;
  u32 *consumer;
  dma_addr_t consumer_h;
+ struct MR_LD_VF_AFFILIATION *vf_affiliation;
+ dma_addr_t vf_affiliation_h;
+ struct MR_LD_VF_AFFILIATION_111 *vf_affiliation_111;
+ dma_addr_t vf_affiliation_111_h;
+ struct MR_CTRL_HB_HOST_MEM *hb_host_mem;
+ dma_addr_t hb_host_mem_h;

  u32 *reply_queue;
  dma_addr_t reply_queue_h;
@@ -1604,10 +1630,73 @@
  unsigned long bar;
  long reset_flags;
  struct mutex reset_mutex;
+ struct timer_list sriov_heartbeat_timer;
+ char skip_heartbeat_timer_del;
+ u8 requestorId;
+ u64 initiator_sas_address;
+ u64 ld_sas_address[64];
+ char PlasmaFW111;
+ char mpio;
  int throttlequeuedepth;
  u8 mask_interrupts;
  u8 is_imr;
 };
+struct MR_LD_VF_MAP {
+ u32 size;
+ union MR_LD_REF ref;
+ u8 ldVfCount;
+ u8 reserved[6];
+ u8 policy[1];
+};
+
+struct MR_LD_VF_AFFILIATION {
+ u32 size;
+ u8 ldCount;
+ u8 vfCount;
+ u8 thisVf;
+ u8 reserved[9];
+ struct MR_LD_VF_MAP map[1];
+};
+
+/* Plasma 1.11 FW backward compatibility structures */
+#define IOV_111_OFFSET 0x7CE
+#define MAX_VIRTUAL_FUNCTIONS 8
+
+struct IOV_111 {
+ u8 maxVFsSupported;
+ u8 numVFsEnabled;
+ u8 requestorId;
+ u8 reserved[5];
+};
+
+struct MR_LD_VF_MAP_111 {
+ u8 targetId;
+ u8 reserved[3];
+ u8 policy[MAX_VIRTUAL_FUNCTIONS];
+};
+
+struct MR_LD_VF_AFFILIATION_111 {
+ u8 vdCount;
+ u8 vfCount;
+ u8 thisVf;
+ u8 reserved[5];
+ struct MR_LD_VF_MAP_111 map[MAX_LOGICAL_DRIVES];
+};
+
+struct MR_CTRL_HB_HOST_MEM {
+ struct {
+ u32 fwCounter; /* Firmware heart beat counter */
+ struct {
+ u32 debugmode:1; /* 1=Firmware is in debug mode.
+    Heart beat will not be updated. */
+ u32 reserved:31;
+ } debug;
+ u32 reserved_fw[6];
+ u32 driverCounter; /* Driver heart beat counter.  0x20 */
+ u32 reserved_driver[7];
+ } HB;
+ u8 pad[0x400-0x40];
+};

 enum {
  MEGASAS_HBA_OPERATIONAL = 0,
@@ -1615,6 +1704,7 @@
  MEGASAS_ADPRESET_SM_FW_RESET_SUCCESS = 2,
  MEGASAS_ADPRESET_SM_OPERATIONAL = 3,
  MEGASAS_HW_CRITICAL_ERROR = 4,
+ MEGASAS_ADPRESET_SM_POLLING = 5,
  MEGASAS_ADPRESET_INPROG_SIGN = 0xDEADDEAD,
 };

--20cf301af335d6105b04f43d8d79
Content-Type: application/octet-stream; name="megaraid_sas.patch4"
Content-Disposition: attachment; filename="megaraid_sas.patch4"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hslkfzz80

ZGlmZiAtTmF1ciBzY3NpLW1pc2Mub2xkL2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9z
YXNfYmFzZS5jIHNjc2ktbWlzYy5uZXcvZHJpdmVycy9zY3NpL21lZ2FyYWlkL21lZ2FyYWlkX3Nh
c19iYXNlLmMKLS0tIHNjc2ktbWlzYy5vbGQvZHJpdmVycy9zY3NpL21lZ2FyYWlkL21lZ2FyYWlk
X3Nhc19iYXNlLmMJMjAxNC0wMy0wOSAyMTowNzowMy44OTI5ODA4ODMgLTA3MDAKKysrIHNjc2kt
bWlzYy5uZXcvZHJpdmVycy9zY3NpL21lZ2FyYWlkL21lZ2FyYWlkX3Nhc19iYXNlLmMJMjAxNC0w
My0xMCAwMToxMjowNS41MTY4NTU4NTEgLTA3MDAKQEAgLTc1LDYgKzc1LDEwIEBACiBtb2R1bGVf
cGFyYW0obXNpeF92ZWN0b3JzLCBpbnQsIFNfSVJVR08pOwogTU9EVUxFX1BBUk1fREVTQyhtc2l4
X3ZlY3RvcnMsICJNU0ktWCBtYXggdmVjdG9yIGNvdW50LiBEZWZhdWx0OiBTZXQgYnkgRlciKTsK
IAorc3RhdGljIGludCBhbGxvd192Zl9pb2N0bHM7Cittb2R1bGVfcGFyYW0oYWxsb3dfdmZfaW9j
dGxzLCBpbnQsIFNfSVJVR08pOworTU9EVUxFX1BBUk1fREVTQyhhbGxvd192Zl9pb2N0bHMsICJB
bGxvdyBpb2N0bHMgaW4gU1ItSU9WIFZGIG1vZGUuIERlZmF1bHQ6IDAiKTsKKwogc3RhdGljIGlu
dCB0aHJvdHRsZXF1ZXVlZGVwdGggPSBNRUdBU0FTX1RIUk9UVExFX1FVRVVFX0RFUFRIOwogbW9k
dWxlX3BhcmFtKHRocm90dGxlcXVldWVkZXB0aCwgaW50LCBTX0lSVUdPKTsKIE1PRFVMRV9QQVJN
X0RFU0ModGhyb3R0bGVxdWV1ZWRlcHRoLApAQCAtMTIyLDYgKzEyNiw4IEBACiAJLyogeHNjYWxl
IElPUCAqLwogCXtQQ0lfREVWSUNFKFBDSV9WRU5ET1JfSURfTFNJX0xPR0lDLCBQQ0lfREVWSUNF
X0lEX0xTSV9GVVNJT04pfSwKIAkvKiBGdXNpb24gKi8KKwl7UENJX0RFVklDRShQQ0lfVkVORE9S
X0lEX0xTSV9MT0dJQywgUENJX0RFVklDRV9JRF9MU0lfUExBU01BKX0sCisJLyogUGxhc21hICov
CiAJe1BDSV9ERVZJQ0UoUENJX1ZFTkRPUl9JRF9MU0lfTE9HSUMsIFBDSV9ERVZJQ0VfSURfTFNJ
X0lOVkFERVIpfSwKIAkvKiBJbnZhZGVyICovCiAJe1BDSV9ERVZJQ0UoUENJX1ZFTkRPUl9JRF9M
U0lfTE9HSUMsIFBDSV9ERVZJQ0VfSURfTFNJX0ZVUlkpfSwKQEAgLTEzMiw3ICsxMzgsNyBAQAog
TU9EVUxFX0RFVklDRV9UQUJMRShwY2ksIG1lZ2FzYXNfcGNpX3RhYmxlKTsKIAogc3RhdGljIGlu
dCBtZWdhc2FzX21nbXRfbWFqb3JubzsKLXN0YXRpYyBzdHJ1Y3QgbWVnYXNhc19tZ210X2luZm8g
bWVnYXNhc19tZ210X2luZm87CitzdHJ1Y3QgbWVnYXNhc19tZ210X2luZm8gbWVnYXNhc19tZ210
X2luZm87CiBzdGF0aWMgc3RydWN0IGZhc3luY19zdHJ1Y3QgKm1lZ2FzYXNfYXN5bmNfcXVldWU7
CiBzdGF0aWMgREVGSU5FX01VVEVYKG1lZ2FzYXNfYXN5bmNfcXVldWVfbXV0ZXgpOwogCkBAIC0x
NzEsMTAgKzE3NywxNSBAQAogaW50CiBtZWdhc2FzX3N5bmNfbWFwX2luZm8oc3RydWN0IG1lZ2Fz
YXNfaW5zdGFuY2UgKmluc3RhbmNlKTsKIGludAotd2FpdF9hbmRfcG9sbChzdHJ1Y3QgbWVnYXNh
c19pbnN0YW5jZSAqaW5zdGFuY2UsIHN0cnVjdCBtZWdhc2FzX2NtZCAqY21kKTsKK3dhaXRfYW5k
X3BvbGwoc3RydWN0IG1lZ2FzYXNfaW5zdGFuY2UgKmluc3RhbmNlLCBzdHJ1Y3QgbWVnYXNhc19j
bWQgKmNtZCwKKwlpbnQgc2Vjb25kcyk7CiB2b2lkIG1lZ2FzYXNfcmVzZXRfcmVwbHlfZGVzYyhz
dHJ1Y3QgbWVnYXNhc19pbnN0YW5jZSAqaW5zdGFuY2UpOwotaW50IG1lZ2FzYXNfcmVzZXRfZnVz
aW9uKHN0cnVjdCBTY3NpX0hvc3QgKnNob3N0KTsKK2ludCBtZWdhc2FzX3Jlc2V0X2Z1c2lvbihz
dHJ1Y3QgU2NzaV9Ib3N0ICpzaG9zdCwgaW50IGlvdGltZW91dCk7CiB2b2lkIG1lZ2FzYXNfZnVz
aW9uX29jcl93cShzdHJ1Y3Qgd29ya19zdHJ1Y3QgKndvcmspOworc3RhdGljIGludCBtZWdhc2Fz
X2dldF9sZF92Zl9hZmZpbGlhdGlvbihzdHJ1Y3QgbWVnYXNhc19pbnN0YW5jZSAqaW5zdGFuY2Us
CisJCQkJCSBpbnQgaW5pdGlhbCk7CitpbnQgbWVnYXNhc19jaGVja19tcGlvX3BhdGhzKHN0cnVj
dCBtZWdhc2FzX2luc3RhbmNlICppbnN0YW5jZSwKKwkJCSAgICAgc3RydWN0IHNjc2lfY21uZCAq
c2NtZCk7CiAKIHZvaWQKIG1lZ2FzYXNfaXNzdWVfZGNtZChzdHJ1Y3QgbWVnYXNhc19pbnN0YW5j
ZSAqaW5zdGFuY2UsIHN0cnVjdCBtZWdhc2FzX2NtZCAqY21kKQpAQCAtMjI0LDYgKzIzNSw3IEBA
CiAJY21kLT5zY21kID0gTlVMTDsKIAljbWQtPmZyYW1lX2NvdW50ID0gMDsKIAlpZiAoKGluc3Rh
bmNlLT5wZGV2LT5kZXZpY2UgIT0gUENJX0RFVklDRV9JRF9MU0lfRlVTSU9OKSAmJgorCSAgICAo
aW5zdGFuY2UtPnBkZXYtPmRldmljZSAhPSBQQ0lfREVWSUNFX0lEX0xTSV9QTEFTTUEpICYmCiAJ
ICAgIChpbnN0YW5jZS0+cGRldi0+ZGV2aWNlICE9IFBDSV9ERVZJQ0VfSURfTFNJX0lOVkFERVIp
ICYmCiAJICAgIChpbnN0YW5jZS0+cGRldi0+ZGV2aWNlICE9IFBDSV9ERVZJQ0VfSURfTFNJX0ZV
UlkpICYmCiAJICAgIChyZXNldF9kZXZpY2VzKSkKQEAgLTg3Nyw2ICs4ODksNyBAQAogaW50CiBt
ZWdhc2FzX2lzc3VlX3BvbGxlZChzdHJ1Y3QgbWVnYXNhc19pbnN0YW5jZSAqaW5zdGFuY2UsIHN0
cnVjdCBtZWdhc2FzX2NtZCAqY21kKQogeworCWludCBzZWNvbmRzOwogCiAJc3RydWN0IG1lZ2Fz
YXNfaGVhZGVyICpmcmFtZV9oZHIgPSAmY21kLT5mcmFtZS0+aGRyOwogCkBAIC04OTEsNyArOTA0
LDExIEBACiAJLyoKIAkgKiBXYWl0IGZvciBjbWRfc3RhdHVzIHRvIGNoYW5nZQogCSAqLwotCXJl
dHVybiB3YWl0X2FuZF9wb2xsKGluc3RhbmNlLCBjbWQpOworCWlmIChpbnN0YW5jZS0+cmVxdWVz
dG9ySWQpCisJCXNlY29uZHMgPSBNRUdBU0FTX1JPVVRJTkVfV0FJVF9USU1FX1ZGOworCWVsc2UK
KwkJc2Vjb25kcyA9IE1GSV9QT0xMX1RJTUVPVVRfU0VDUzsKKwlyZXR1cm4gd2FpdF9hbmRfcG9s
bChpbnN0YW5jZSwgY21kLCBzZWNvbmRzKTsKIH0KIAogLyoqCkBAIC0xNTMyLDkgKzE1NDksMjMg
QEAKIAogCXNwaW5fbG9ja19pcnFzYXZlKCZpbnN0YW5jZS0+aGJhX2xvY2ssIGZsYWdzKTsKIAor
CS8qIENoZWNrIGZvciBhbiBtcGlvIHBhdGggYW5kIGFkanVzdCBiZWhhdmlvciAqLworCWlmIChp
bnN0YW5jZS0+YWRwcmVjb3ZlcnkgPT0gTUVHQVNBU19BRFBSRVNFVF9TTV9JTkZBVUxUKSB7CisJ
CWlmIChtZWdhc2FzX2NoZWNrX21waW9fcGF0aHMoaW5zdGFuY2UsIHNjbWQpID09CisJCSAgICAo
RElEX1JFU0VUIDw8IDE2KSkgeworCQkJc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSgmaW5zdGFuY2Ut
PmhiYV9sb2NrLCBmbGFncyk7CisJCQlyZXR1cm4gU0NTSV9NTFFVRVVFX0hPU1RfQlVTWTsKKwkJ
fSBlbHNlIHsKKwkJCXNwaW5fdW5sb2NrX2lycXJlc3RvcmUoJmluc3RhbmNlLT5oYmFfbG9jaywg
ZmxhZ3MpOworCQkJc2NtZC0+cmVzdWx0ID0gRElEX05PX0NPTk5FQ1QgPDwgMTY7CisJCQlkb25l
KHNjbWQpOworCQkJcmV0dXJuIDA7CisJCX0KKwl9CisKIAlpZiAoaW5zdGFuY2UtPmFkcHJlY292
ZXJ5ID09IE1FR0FTQVNfSFdfQ1JJVElDQUxfRVJST1IpIHsKIAkJc3Bpbl91bmxvY2tfaXJxcmVz
dG9yZSgmaW5zdGFuY2UtPmhiYV9sb2NrLCBmbGFncyk7Ci0JCXNjbWQtPnJlc3VsdCA9IERJRF9F
UlJPUiA8PCAxNjsKKwkJc2NtZC0+cmVzdWx0ID0gRElEX05PX0NPTk5FQ1QgPDwgMTY7CiAJCWRv
bmUoc2NtZCk7CiAJCXJldHVybiAwOwogCX0KQEAgLTE2NTksOSArMTY5MCwxNCBAQAogCWlmICgo
aW5zdGFuY2UtPnBkZXYtPmRldmljZSA9PSBQQ0lfREVWSUNFX0lEX0xTSV9TQVMwMDczU0tJTk5Z
KSB8fAogCSAgICAoaW5zdGFuY2UtPnBkZXYtPmRldmljZSA9PSBQQ0lfREVWSUNFX0lEX0xTSV9T
QVMwMDcxU0tJTk5ZKSB8fAogCSAgICAoaW5zdGFuY2UtPnBkZXYtPmRldmljZSA9PSBQQ0lfREVW
SUNFX0lEX0xTSV9GVVNJT04pIHx8CisJICAgIChpbnN0YW5jZS0+cGRldi0+ZGV2aWNlID09IFBD
SV9ERVZJQ0VfSURfTFNJX1BMQVNNQSkgfHwKIAkgICAgKGluc3RhbmNlLT5wZGV2LT5kZXZpY2Ug
PT0gUENJX0RFVklDRV9JRF9MU0lfSU5WQURFUikgfHwKIAkgICAgKGluc3RhbmNlLT5wZGV2LT5k
ZXZpY2UgPT0gUENJX0RFVklDRV9JRF9MU0lfRlVSWSkpIHsKIAkJd3JpdGVsKE1GSV9TVE9QX0FE
UCwgJmluc3RhbmNlLT5yZWdfc2V0LT5kb29yYmVsbCk7CisJCS8qIEZsdXNoICovCisJCXJlYWRs
KCZpbnN0YW5jZS0+cmVnX3NldC0+ZG9vcmJlbGwpOworCQlpZiAoaW5zdGFuY2UtPm1waW8gJiYg
aW5zdGFuY2UtPnJlcXVlc3RvcklkKQorCQkJbWVtc2V0KGluc3RhbmNlLT5sZF9pZHMsIDB4ZmYs
IE1FR0FTQVNfTUFYX0xEX0lEUyk7CiAJfSBlbHNlIHsKIAkJd3JpdGVsKE1GSV9TVE9QX0FEUCwg
Jmluc3RhbmNlLT5yZWdfc2V0LT5pbmJvdW5kX2Rvb3JiZWxsKTsKIAl9CkBAIC0xNzQ4LDYgKzE3
ODQsMjUgQEAKIAltZWdhc2FzX2NoZWNrX2FuZF9yZXN0b3JlX3F1ZXVlX2RlcHRoKGluc3RhbmNl
KTsKIH0KIAorLyoqCisgKiBtZWdhc2FzX3N0YXJ0X3RpbWVyIC0gSW5pdGlhbGl6ZXMgYSB0aW1l
ciBvYmplY3QKKyAqIEBpbnN0YW5jZToJCUFkYXB0ZXIgc29mdCBzdGF0ZQorICogQHRpbWVyOgkJ
dGltZXIgb2JqZWN0IHRvIGJlIGluaXRpYWxpemVkCisgKiBAZm46CQkJdGltZXIgZnVuY3Rpb24K
KyAqIEBpbnRlcnZhbDoJCXRpbWUgaW50ZXJ2YWwgYmV0d2VlbiB0aW1lciBmdW5jdGlvbiBjYWxs
CisgKgorICovCit2b2lkIG1lZ2FzYXNfc3RhcnRfdGltZXIoc3RydWN0IG1lZ2FzYXNfaW5zdGFu
Y2UgKmluc3RhbmNlLAorCQkJc3RydWN0IHRpbWVyX2xpc3QgKnRpbWVyLAorCQkJdm9pZCAqZm4s
IHVuc2lnbmVkIGxvbmcgaW50ZXJ2YWwpCit7CisJaW5pdF90aW1lcih0aW1lcik7CisJdGltZXIt
PmV4cGlyZXMgPSBqaWZmaWVzICsgaW50ZXJ2YWw7CisJdGltZXItPmRhdGEgPSAodW5zaWduZWQg
bG9uZylpbnN0YW5jZTsKKwl0aW1lci0+ZnVuY3Rpb24gPSBmbjsKKwlhZGRfdGltZXIodGltZXIp
OworfQorCiBzdGF0aWMgdm9pZAogbWVnYXNhc19pbnRlcm5hbF9yZXNldF9kZWZlcl9jbWRzKHN0
cnVjdCBtZWdhc2FzX2luc3RhbmNlICppbnN0YW5jZSk7CiAKQEAgLTE3NzAsNiArMTgyNSwyOTUg
QEAKIAlwcm9jZXNzX2Z3X3N0YXRlX2NoYW5nZV93cSgmaW5zdGFuY2UtPndvcmtfaW5pdCk7CiB9
CiAKKy8qIFRoaXMgZnVuY3Rpb24gd2lsbCBnZXQgdGhlIGN1cnJlbnQgU1ItSU9WIExEL1ZGIGFm
ZmlsaWF0aW9uICovCitzdGF0aWMgaW50IG1lZ2FzYXNfZ2V0X2xkX3ZmX2FmZmlsaWF0aW9uKHN0
cnVjdCBtZWdhc2FzX2luc3RhbmNlICppbnN0YW5jZSwKKwlpbnQgaW5pdGlhbCkKK3sKKwlzdHJ1
Y3QgbWVnYXNhc19jbWQgKmNtZDsKKwlzdHJ1Y3QgbWVnYXNhc19kY21kX2ZyYW1lICpkY21kOwor
CXN0cnVjdCBNUl9MRF9WRl9BRkZJTElBVElPTiAqbmV3X2FmZmlsaWF0aW9uID0gTlVMTDsKKwlz
dHJ1Y3QgTVJfTERfVkZfQUZGSUxJQVRJT05fMTExICpuZXdfYWZmaWxpYXRpb25fMTExID0gTlVM
TDsKKwlzdHJ1Y3QgTVJfTERfVkZfTUFQICpuZXdtYXAgPSBOVUxMLCAqc2F2ZWRtYXAgPSBOVUxM
OworCWRtYV9hZGRyX3QgbmV3X2FmZmlsaWF0aW9uX2g7CisJZG1hX2FkZHJfdCBuZXdfYWZmaWxp
YXRpb25fMTExX2g7CisJaW50IGxkLCByZXR2YWwgPSAwOworCXU4IHRoaXNWZjsKKworCWNtZCA9
IG1lZ2FzYXNfZ2V0X2NtZChpbnN0YW5jZSk7CisKKwlpZiAoIWNtZCkgeworCQlwcmludGsoS0VS
Tl9ERUJVRyAibWVnYXNhczogbWVnYXNhc19nZXRfbGRfdmZfIgorCQkgICAgICAgImFmZmlsaWF0
aW9uOiBGYWlsZWQgdG8gZ2V0IGNtZCBmb3Igc2NzaSVkLlxuIiwKKwkJCWluc3RhbmNlLT5ob3N0
LT5ob3N0X25vKTsKKwkJcmV0dXJuIC1FTk9NRU07CisJfQorCisJZGNtZCA9ICZjbWQtPmZyYW1l
LT5kY21kOworCisJaWYgKCFpbnN0YW5jZS0+dmZfYWZmaWxpYXRpb24gJiYgIWluc3RhbmNlLT52
Zl9hZmZpbGlhdGlvbl8xMTEpIHsKKwkJcHJpbnRrKEtFUk5fV0FSTklORyAibWVnYXNhczogU1It
SU9WOiBDb3VsZG4ndCBnZXQgTEQvVkYgIgorCQkgICAgICAgImFmZmlsaWF0aW9uIGZvciBzY3Np
JWQuXG4iLCBpbnN0YW5jZS0+aG9zdC0+aG9zdF9ubyk7CisJCW1lZ2FzYXNfcmV0dXJuX2NtZChp
bnN0YW5jZSwgY21kKTsKKwkJcmV0dXJuIC1FTk9NRU07CisJfQorCisJaWYgKGluaXRpYWwpCisJ
CWlmIChpbnN0YW5jZS0+UGxhc21hRlcxMTEpCisJCQltZW1zZXQoaW5zdGFuY2UtPnZmX2FmZmls
aWF0aW9uXzExMSwgMCwKKwkJCSAgICAgICBzaXplb2Yoc3RydWN0IE1SX0xEX1ZGX0FGRklMSUFU
SU9OXzExMSkpOworCQllbHNlCisJCQltZW1zZXQoaW5zdGFuY2UtPnZmX2FmZmlsaWF0aW9uLCAw
LAorCQkJICAgICAgIChNQVhfTE9HSUNBTF9EUklWRVMgKyAxKSAqCisJCQkgICAgICAgc2l6ZW9m
KHN0cnVjdCBNUl9MRF9WRl9BRkZJTElBVElPTikpOworCWVsc2UgeworCQlpZiAoaW5zdGFuY2Ut
PlBsYXNtYUZXMTExKQorCQkJbmV3X2FmZmlsaWF0aW9uXzExMSA9CisJCQkJcGNpX2FsbG9jX2Nv
bnNpc3RlbnQoaW5zdGFuY2UtPnBkZXYsCisJCQkJCQkgICAgIHNpemVvZihzdHJ1Y3QgTVJfTERf
VkZfQUZGSUxJQVRJT05fMTExKSwKKwkJCQkJCSAgICAgJm5ld19hZmZpbGlhdGlvbl8xMTFfaCk7
CisJCWVsc2UKKwkJCW5ld19hZmZpbGlhdGlvbiA9CisJCQkJcGNpX2FsbG9jX2NvbnNpc3RlbnQo
aW5zdGFuY2UtPnBkZXYsCisJCQkJCQkgICAgIChNQVhfTE9HSUNBTF9EUklWRVMgKyAxKSAqCisJ
CQkJCQkgICAgIHNpemVvZihzdHJ1Y3QgTVJfTERfVkZfQUZGSUxJQVRJT04pLAorCQkJCQkJICAg
ICAmbmV3X2FmZmlsaWF0aW9uX2gpOworCQlpZiAoIW5ld19hZmZpbGlhdGlvbiAmJiAhbmV3X2Fm
ZmlsaWF0aW9uXzExMSkgeworCQkJcHJpbnRrKEtFUk5fREVCVUcgIm1lZ2FzYXM6IFNSLUlPVjog
Q291bGRuJ3QgYWxsb2NhdGUgIgorCQkJICAgICAgICJtZW1vcnkgZm9yIG5ldyBhZmZpbGlhdGlv
biBmb3Igc2NzaSVkLlxuIiwKKwkJCQlpbnN0YW5jZS0+aG9zdC0+aG9zdF9ubyk7CisJCQltZWdh
c2FzX3JldHVybl9jbWQoaW5zdGFuY2UsIGNtZCk7CisJCQlyZXR1cm4gLUVOT01FTTsKKwkJfQor
CQlpZiAoaW5zdGFuY2UtPlBsYXNtYUZXMTExKQorCQkJbWVtc2V0KG5ld19hZmZpbGlhdGlvbl8x
MTEsIDAsCisJCQkgICAgICAgc2l6ZW9mKHN0cnVjdCBNUl9MRF9WRl9BRkZJTElBVElPTl8xMTEp
KTsKKwkJZWxzZQorCQkJbWVtc2V0KG5ld19hZmZpbGlhdGlvbiwgMCwgKE1BWF9MT0dJQ0FMX0RS
SVZFUyArIDEpICoKKwkJCSAgICAgICBzaXplb2Yoc3RydWN0IE1SX0xEX1ZGX0FGRklMSUFUSU9O
KSk7CisJfQorCisJbWVtc2V0KGRjbWQtPm1ib3guYiwgMCwgTUZJX01CT1hfU0laRSk7CisKKwlk
Y21kLT5jbWQgPSBNRklfQ01EX0RDTUQ7CisJZGNtZC0+Y21kX3N0YXR1cyA9IDB4RkY7CisJZGNt
ZC0+c2dlX2NvdW50ID0gMTsKKwlkY21kLT5mbGFncyA9IE1GSV9GUkFNRV9ESVJfQk9USDsKKwlk
Y21kLT50aW1lb3V0ID0gMDsKKwlkY21kLT5wYWRfMCA9IDA7CisJaWYgKGluc3RhbmNlLT5QbGFz
bWFGVzExMSkgeworCQlkY21kLT5kYXRhX3hmZXJfbGVuID0gc2l6ZW9mKHN0cnVjdCBNUl9MRF9W
Rl9BRkZJTElBVElPTl8xMTEpOworCQlkY21kLT5vcGNvZGUgPSBNUl9EQ01EX0xEX1ZGX01BUF9H
RVRfQUxMX0xEU18xMTE7CisJfSBlbHNlIHsKKwkJZGNtZC0+ZGF0YV94ZmVyX2xlbiA9IChNQVhf
TE9HSUNBTF9EUklWRVMgKyAxKSAqCisJCQlzaXplb2Yoc3RydWN0IE1SX0xEX1ZGX0FGRklMSUFU
SU9OKTsKKwkJZGNtZC0+b3Bjb2RlID0gTVJfRENNRF9MRF9WRl9NQVBfR0VUX0FMTF9MRFM7CisJ
fQorCisJaWYgKGluaXRpYWwpIHsKKwkJaWYgKGluc3RhbmNlLT5QbGFzbWFGVzExMSkKKwkJCWRj
bWQtPnNnbC5zZ2UzMlswXS5waHlzX2FkZHIgPQorCQkJICBpbnN0YW5jZS0+dmZfYWZmaWxpYXRp
b25fMTExX2g7CisJCWVsc2UKKwkJCWRjbWQtPnNnbC5zZ2UzMlswXS5waHlzX2FkZHIgPQorCQkJ
ICBpbnN0YW5jZS0+dmZfYWZmaWxpYXRpb25faDsKKwl9IGVsc2UgeworCQlpZiAoaW5zdGFuY2Ut
PlBsYXNtYUZXMTExKQorCQkJZGNtZC0+c2dsLnNnZTMyWzBdLnBoeXNfYWRkciA9IG5ld19hZmZp
bGlhdGlvbl8xMTFfaDsKKwkJZWxzZQorCQkJZGNtZC0+c2dsLnNnZTMyWzBdLnBoeXNfYWRkciA9
IG5ld19hZmZpbGlhdGlvbl9oOworCX0KKwlpZiAoaW5zdGFuY2UtPlBsYXNtYUZXMTExKQorCQlk
Y21kLT5zZ2wuc2dlMzJbMF0ubGVuZ3RoID0KKwkJICBzaXplb2Yoc3RydWN0IE1SX0xEX1ZGX0FG
RklMSUFUSU9OXzExMSk7CisJZWxzZQorCQlkY21kLT5zZ2wuc2dlMzJbMF0ubGVuZ3RoID0gKE1B
WF9MT0dJQ0FMX0RSSVZFUyArIDEpICoKKwkJCXNpemVvZihzdHJ1Y3QgTVJfTERfVkZfQUZGSUxJ
QVRJT04pOworCisJcHJpbnRrKEtFUk5fV0FSTklORyAibWVnYXNhczogU1ItSU9WOiBHZXR0aW5n
IExEL1ZGIGFmZmlsaWF0aW9uIGZvciAiCisJICAgICAgICJzY3NpJWRcbiIsIGluc3RhbmNlLT5o
b3N0LT5ob3N0X25vKTsKKworCW1lZ2FzYXNfaXNzdWVfYmxvY2tlZF9jbWQoaW5zdGFuY2UsIGNt
ZCwgMCk7CisKKwlpZiAoZGNtZC0+Y21kX3N0YXR1cykgeworCQlwcmludGsoS0VSTl9XQVJOSU5H
ICJtZWdhc2FzOiBTUi1JT1Y6IExEL1ZGIGFmZmlsaWF0aW9uIERDTUQiCisJCSAgICAgICAiIGZh
aWxlZCB3aXRoIHN0YXR1cyAweCV4IGZvciBzY3NpJWQuXG4iLAorCQkgICAgICAgZGNtZC0+Y21k
X3N0YXR1cywgaW5zdGFuY2UtPmhvc3QtPmhvc3Rfbm8pOworCQlyZXR2YWwgPSAxOyAvKiBEbyBh
IHNjYW4gaWYgd2UgY291bGRuJ3QgZ2V0IGFmZmlsaWF0aW9uICovCisJCWdvdG8gb3V0OworCX0K
KworCWlmICghaW5pdGlhbCkgeworCQlpZiAoaW5zdGFuY2UtPlBsYXNtYUZXMTExKSB7CisJCQlp
ZiAoIW5ld19hZmZpbGlhdGlvbl8xMTEtPnZkQ291bnQpIHsKKwkJCQlwcmludGsoS0VSTl9XQVJO
SU5HICJtZWdhc2FzOiBTUi1JT1Y6IEdvdCBuZXcgIgorCQkJCSAgICAgICAiTEQvVkYgYWZmaWxp
YXRpb24gZm9yIHBhc3NpdmUgcGF0aCAiCisJCQkJICAgICAgICJmb3Igc2NzaSVkLlxuIiwKKwkJ
CQkJaW5zdGFuY2UtPmhvc3QtPmhvc3Rfbm8pOworCQkJCXJldHZhbCA9IDE7CisJCQkJZ290byBv
dXQ7CisJCQl9CisJCQl0aGlzVmYgPSBuZXdfYWZmaWxpYXRpb25fMTExLT50aGlzVmY7CisJCQlm
b3IgKGxkID0gMCA7IGxkIDwgbmV3X2FmZmlsaWF0aW9uXzExMS0+dmRDb3VudDsgbGQrKykKKwkJ
CQlpZiAoaW5zdGFuY2UtPnZmX2FmZmlsaWF0aW9uXzExMS0+bWFwW2xkXS5wb2xpY3lbdGhpc1Zm
XSAhPSBuZXdfYWZmaWxpYXRpb25fMTExLT5tYXBbbGRdLnBvbGljeVt0aGlzVmZdKSB7CisJCQkJ
CXByaW50ayhLRVJOX1dBUk5JTkcgIm1lZ2FzYXM6IFNSLUlPVjogIgorCQkJCQkgICAgICAgIkdv
dCBuZXcgTEQvVkYgYWZmaWxpYXRpb24gIgorCQkJCQkgICAgICAgImZvciBzY3NpJWQuXG4iLAor
CQkJCQkJaW5zdGFuY2UtPmhvc3QtPmhvc3Rfbm8pOworCQkJCQltZW1jcHkoaW5zdGFuY2UtPnZm
X2FmZmlsaWF0aW9uXzExMSwKKwkJCQkJICAgICAgIG5ld19hZmZpbGlhdGlvbl8xMTEsCisJCQkJ
CSAgICAgICBzaXplb2Yoc3RydWN0IE1SX0xEX1ZGX0FGRklMSUFUSU9OXzExMSkpOworCQkJCQly
ZXR2YWwgPSAxOworCQkJCQlnb3RvIG91dDsKKwkJCQl9CisJCX0gZWxzZSB7CisJCQlpZiAoIW5l
d19hZmZpbGlhdGlvbi0+bGRDb3VudCkgeworCQkJCXByaW50ayhLRVJOX1dBUk5JTkcgIm1lZ2Fz
YXM6IFNSLUlPVjogR290IG5ldyAiCisJCQkJICAgICAgICJMRC9WRiBhZmZpbGlhdGlvbiBmb3Ig
cGFzc2l2ZSAiCisJCQkJICAgICAgICJwYXRoIGZvciBzY3NpJWQuXG4iLAorCQkJCSAgICAgICBp
bnN0YW5jZS0+aG9zdC0+aG9zdF9ubyk7CisJCQkJcmV0dmFsID0gMTsKKwkJCQlnb3RvIG91dDsK
KwkJCX0KKwkJCW5ld21hcCA9IG5ld19hZmZpbGlhdGlvbi0+bWFwOworCQkJc2F2ZWRtYXAgPSBp
bnN0YW5jZS0+dmZfYWZmaWxpYXRpb24tPm1hcDsKKwkJCXRoaXNWZiA9IG5ld19hZmZpbGlhdGlv
bi0+dGhpc1ZmOworCQkJZm9yIChsZCA9IDAgOyBsZCA8IG5ld19hZmZpbGlhdGlvbi0+bGRDb3Vu
dDsgbGQrKykgeworCQkJCWlmIChzYXZlZG1hcC0+cG9saWN5W3RoaXNWZl0gIT0KKwkJCQkgICAg
bmV3bWFwLT5wb2xpY3lbdGhpc1ZmXSkgeworCQkJCQlwcmludGsoS0VSTl9XQVJOSU5HICJtZWdh
c2FzOiBTUi1JT1Y6ICIKKwkJCQkJICAgICAgICJHb3QgbmV3IExEL1ZGIGFmZmlsaWF0aW9uICIK
KwkJCQkJICAgICAgICJmb3Igc2NzaSVkLlxuIiwKKwkJCQkJCWluc3RhbmNlLT5ob3N0LT5ob3N0
X25vKTsKKwkJCQkJbWVtY3B5KGluc3RhbmNlLT52Zl9hZmZpbGlhdGlvbiwKKwkJCQkJICAgICAg
IG5ld19hZmZpbGlhdGlvbiwKKwkJCQkJICAgICAgIG5ld19hZmZpbGlhdGlvbi0+c2l6ZSk7CisJ
CQkJCXJldHZhbCA9IDE7CisJCQkJCWdvdG8gb3V0OworCQkJCX0KKwkJCQlzYXZlZG1hcCA9IChz
dHJ1Y3QgTVJfTERfVkZfTUFQICopCisJCQkJCSgodW5zaWduZWQgY2hhciAqKXNhdmVkbWFwICsK
KwkJCQkJIHNhdmVkbWFwLT5zaXplKTsKKwkJCQluZXdtYXAgPSAoc3RydWN0IE1SX0xEX1ZGX01B
UCAqKQorCQkJCQkoKHVuc2lnbmVkIGNoYXIgKiluZXdtYXAgKworCQkJCQkgbmV3bWFwLT5zaXpl
KTsKKwkJCX0KKwkJfQorCX0KK291dDoKKwlpZiAobmV3X2FmZmlsaWF0aW9uKSB7CisJCWlmIChp
bnN0YW5jZS0+UGxhc21hRlcxMTEpCisJCQlwY2lfZnJlZV9jb25zaXN0ZW50KGluc3RhbmNlLT5w
ZGV2LAorCQkJCQkgICAgc2l6ZW9mKHN0cnVjdCBNUl9MRF9WRl9BRkZJTElBVElPTl8xMTEpLAor
CQkJCQkgICAgbmV3X2FmZmlsaWF0aW9uXzExMSwKKwkJCQkJICAgIG5ld19hZmZpbGlhdGlvbl8x
MTFfaCk7CisJCWVsc2UKKwkJCXBjaV9mcmVlX2NvbnNpc3RlbnQoaW5zdGFuY2UtPnBkZXYsCisJ
CQkJCSAgICAoTUFYX0xPR0lDQUxfRFJJVkVTICsgMSkgKgorCQkJCQkgICAgc2l6ZW9mKHN0cnVj
dCBNUl9MRF9WRl9BRkZJTElBVElPTiksCisJCQkJCSAgICBuZXdfYWZmaWxpYXRpb24sIG5ld19h
ZmZpbGlhdGlvbl9oKTsKKwl9CisJbWVnYXNhc19yZXR1cm5fY21kKGluc3RhbmNlLCBjbWQpOwor
CisJcmV0dXJuIHJldHZhbDsKK30KKworLyogVGhpcyBmdW5jdGlvbiB3aWxsIHRlbGwgRlcgdG8g
c3RhcnQgdGhlIFNSLUlPViBoZWFydGJlYXQgKi8KK2ludCBtZWdhc2FzX3NyaW92X3N0YXJ0X2hl
YXJ0YmVhdChzdHJ1Y3QgbWVnYXNhc19pbnN0YW5jZSAqaW5zdGFuY2UsCisJCQkJCSBpbnQgaW5p
dGlhbCkKK3sKKwlzdHJ1Y3QgbWVnYXNhc19jbWQgKmNtZDsKKwlzdHJ1Y3QgbWVnYXNhc19kY21k
X2ZyYW1lICpkY21kOworCWludCByZXR2YWwgPSAwOworCisJY21kID0gbWVnYXNhc19nZXRfY21k
KGluc3RhbmNlKTsKKworCWlmICghY21kKSB7CisJCXByaW50ayhLRVJOX0RFQlVHICJtZWdhc2Fz
OiBtZWdhc2FzX3NyaW92X3N0YXJ0X2hlYXJ0YmVhdDogIgorCQkgICAgICAgIkZhaWxlZCB0byBn
ZXQgY21kIGZvciBzY3NpJWQuXG4iLAorCQkgICAgICAgaW5zdGFuY2UtPmhvc3QtPmhvc3Rfbm8p
OworCQlyZXR1cm4gLUVOT01FTTsKKwl9CisKKwlkY21kID0gJmNtZC0+ZnJhbWUtPmRjbWQ7CisK
KwlpZiAoaW5pdGlhbCkgeworCQlpbnN0YW5jZS0+aGJfaG9zdF9tZW0gPQorCQkJcGNpX2FsbG9j
X2NvbnNpc3RlbnQoaW5zdGFuY2UtPnBkZXYsCisJCQkJCSAgICAgc2l6ZW9mKHN0cnVjdCBNUl9D
VFJMX0hCX0hPU1RfTUVNKSwKKwkJCQkJICAgICAmaW5zdGFuY2UtPmhiX2hvc3RfbWVtX2gpOwor
CQlpZiAoIWluc3RhbmNlLT5oYl9ob3N0X21lbSkgeworCQkJcHJpbnRrKEtFUk5fREVCVUcgIm1l
Z2FzYXM6IFNSLUlPVjogQ291bGRuJ3QgYWxsb2NhdGUiCisJCQkgICAgICAgIiBtZW1vcnkgZm9y
IGhlYXJ0YmVhdCBob3N0IG1lbW9yeSBmb3IgIgorCQkJICAgICAgICJzY3NpJWQuXG4iLCBpbnN0
YW5jZS0+aG9zdC0+aG9zdF9ubyk7CisJCQlyZXR2YWwgPSAtRU5PTUVNOworCQkJZ290byBvdXQ7
CisJCX0KKwkJbWVtc2V0KGluc3RhbmNlLT5oYl9ob3N0X21lbSwgMCwKKwkJICAgICAgIHNpemVv
ZihzdHJ1Y3QgTVJfQ1RSTF9IQl9IT1NUX01FTSkpOworCX0KKworCW1lbXNldChkY21kLT5tYm94
LmIsIDAsIE1GSV9NQk9YX1NJWkUpOworCisJZGNtZC0+bWJveC5zWzBdID0gc2l6ZW9mKHN0cnVj
dCBNUl9DVFJMX0hCX0hPU1RfTUVNKTsKKwlkY21kLT5jbWQgPSBNRklfQ01EX0RDTUQ7CisJZGNt
ZC0+Y21kX3N0YXR1cyA9IDB4RkY7CisJZGNtZC0+c2dlX2NvdW50ID0gMTsKKwlkY21kLT5mbGFn
cyA9IE1GSV9GUkFNRV9ESVJfQk9USDsKKwlkY21kLT50aW1lb3V0ID0gMDsKKwlkY21kLT5wYWRf
MCA9IDA7CisJZGNtZC0+ZGF0YV94ZmVyX2xlbiA9IHNpemVvZihzdHJ1Y3QgTVJfQ1RSTF9IQl9I
T1NUX01FTSk7CisJZGNtZC0+b3Bjb2RlID0gTVJfRENNRF9DVFJMX1NIQVJFRF9IT1NUX01FTV9B
TExPQzsKKwlkY21kLT5zZ2wuc2dlMzJbMF0ucGh5c19hZGRyID0gaW5zdGFuY2UtPmhiX2hvc3Rf
bWVtX2g7CisJZGNtZC0+c2dsLnNnZTMyWzBdLmxlbmd0aCA9IHNpemVvZihzdHJ1Y3QgTVJfQ1RS
TF9IQl9IT1NUX01FTSk7CisKKwlwcmludGsoS0VSTl9XQVJOSU5HICJtZWdhc2FzOiBTUi1JT1Y6
IFN0YXJ0aW5nIGhlYXJ0YmVhdCBmb3Igc2NzaSVkXG4iLAorCSAgICAgICBpbnN0YW5jZS0+aG9z
dC0+aG9zdF9ubyk7CisKKwlpZiAoIW1lZ2FzYXNfaXNzdWVfcG9sbGVkKGluc3RhbmNlLCBjbWQp
KSB7CisJCXJldHZhbCA9IDA7CisJfSBlbHNlIHsKKwkJcHJpbnRrKEtFUk5fV0FSTklORyAibWVn
YXNhczogU1ItSU9WOiBNUl9EQ01EX0NUUkxfU0hBUkVEX0hPU1QiCisJCSAgICAgICAiX01FTV9B
TExPQyBEQ01EIHRpbWVkIG91dCBmb3Igc2NzaSVkXG4iLAorCQkgICAgICAgaW5zdGFuY2UtPmhv
c3QtPmhvc3Rfbm8pOworCQlyZXR2YWwgPSAxOworCQlnb3RvIG91dDsKKwl9CisKKworCWlmIChk
Y21kLT5jbWRfc3RhdHVzKSB7CisJCXByaW50ayhLRVJOX1dBUk5JTkcgIm1lZ2FzYXM6IFNSLUlP
VjogTVJfRENNRF9DVFJMX1NIQVJFRF9IT1NUIgorCQkgICAgICAgIl9NRU1fQUxMT0MgRENNRCBm
YWlsZWQgd2l0aCBzdGF0dXMgMHgleCBmb3Igc2NzaSVkXG4iLAorCQkgICAgICAgZGNtZC0+Y21k
X3N0YXR1cywKKwkJICAgICAgIGluc3RhbmNlLT5ob3N0LT5ob3N0X25vKTsKKwkJcmV0dmFsID0g
MTsKKwkJZ290byBvdXQ7CisJfQorCitvdXQ6CisJbWVnYXNhc19yZXR1cm5fY21kKGluc3RhbmNl
LCBjbWQpOworCisJcmV0dXJuIHJldHZhbDsKK30KKworLyogSGFuZGxlciBmb3IgU1ItSU9WIGhl
YXJ0YmVhdCAqLwordm9pZCBtZWdhc2FzX3NyaW92X2hlYXJ0YmVhdF9oYW5kbGVyKHVuc2lnbmVk
IGxvbmcgaW5zdGFuY2VfYWRkcikKK3sKKwlzdHJ1Y3QgbWVnYXNhc19pbnN0YW5jZSAqaW5zdGFu
Y2UgPQorCQkoc3RydWN0IG1lZ2FzYXNfaW5zdGFuY2UgKilpbnN0YW5jZV9hZGRyOworCisJaWYg
KGluc3RhbmNlLT5oYl9ob3N0X21lbS0+SEIuZndDb3VudGVyICE9CisJICAgIGluc3RhbmNlLT5o
Yl9ob3N0X21lbS0+SEIuZHJpdmVyQ291bnRlcikgeworCQlpbnN0YW5jZS0+aGJfaG9zdF9tZW0t
PkhCLmRyaXZlckNvdW50ZXIgPQorCQkJaW5zdGFuY2UtPmhiX2hvc3RfbWVtLT5IQi5md0NvdW50
ZXI7CisJCW1vZF90aW1lcigmaW5zdGFuY2UtPnNyaW92X2hlYXJ0YmVhdF90aW1lciwKKwkJCSAg
amlmZmllcyArIE1FR0FTQVNfU1JJT1ZfSEVBUlRCRUFUX0lOVEVSVkFMX1ZGKTsKKwl9IGVsc2Ug
eworCQlwcmludGsoS0VSTl9XQVJOSU5HICJtZWdhc2FzOiBTUi1JT1Y6IEhlYXJ0YmVhdCBuZXZl
ciAiCisJCSAgICAgICAiY29tcGxldGVkIGZvciBzY3NpJWRcbiIsIGluc3RhbmNlLT5ob3N0LT5o
b3N0X25vKTsKKwkJc2NoZWR1bGVfd29yaygmaW5zdGFuY2UtPndvcmtfaW5pdCk7CisJfQorfQor
CiAvKioKICAqIG1lZ2FzYXNfd2FpdF9mb3Jfb3V0c3RhbmRpbmcgLQlXYWl0IGZvciBhbGwgb3V0
c3RhbmRpbmcgY21kcwogICogQGluc3RhbmNlOgkJCQlBZGFwdGVyIHNvZnQgc3RhdGUKQEAgLTIw
MzIsOSArMjM3NiwxMCBAQAogCSAqIEZpcnN0IHdhaXQgZm9yIGFsbCBjb21tYW5kcyB0byBjb21w
bGV0ZQogCSAqLwogCWlmICgoaW5zdGFuY2UtPnBkZXYtPmRldmljZSA9PSBQQ0lfREVWSUNFX0lE
X0xTSV9GVVNJT04pIHx8CisJICAgIChpbnN0YW5jZS0+cGRldi0+ZGV2aWNlID09IFBDSV9ERVZJ
Q0VfSURfTFNJX1BMQVNNQSkgfHwKIAkgICAgKGluc3RhbmNlLT5wZGV2LT5kZXZpY2UgPT0gUENJ
X0RFVklDRV9JRF9MU0lfSU5WQURFUikgfHwKIAkgICAgKGluc3RhbmNlLT5wZGV2LT5kZXZpY2Ug
PT0gUENJX0RFVklDRV9JRF9MU0lfRlVSWSkpCi0JCXJldCA9IG1lZ2FzYXNfcmVzZXRfZnVzaW9u
KHNjbWQtPmRldmljZS0+aG9zdCk7CisJCXJldCA9IG1lZ2FzYXNfcmVzZXRfZnVzaW9uKHNjbWQt
PmRldmljZS0+aG9zdCwgMSk7CiAJZWxzZQogCQlyZXQgPSBtZWdhc2FzX2dlbmVyaWNfcmVzZXQo
c2NtZCk7CiAKQEAgLTI3NDksNiArMzA5NCw4IEBACiAJCQkJKGluc3RhbmNlLT5wZGV2LT5kZXZp
Y2UgPT0KIAkJCQlQQ0lfREVWSUNFX0lEX0xTSV9GVVNJT04pIHx8CiAJCQkJKGluc3RhbmNlLT5w
ZGV2LT5kZXZpY2UgPT0KKwkJCQlQQ0lfREVWSUNFX0lEX0xTSV9QTEFTTUEpIHx8CisJCQkJKGlu
c3RhbmNlLT5wZGV2LT5kZXZpY2UgPT0KIAkJCQlQQ0lfREVWSUNFX0lEX0xTSV9JTlZBREVSKSB8
fAogCQkJCShpbnN0YW5jZS0+cGRldi0+ZGV2aWNlID09CiAJCQkJUENJX0RFVklDRV9JRF9MU0lf
RlVSWSkpIHsKQEAgLTI3NzMsNiArMzEyMCw4IEBACiAJCQkgICAgKGluc3RhbmNlLT5wZGV2LT5k
ZXZpY2UgPT0KIAkJCSAgICAgUENJX0RFVklDRV9JRF9MU0lfRlVTSU9OKSB8fAogCQkJICAgIChp
bnN0YW5jZS0+cGRldi0+ZGV2aWNlID09CisJCQkgICAgIFBDSV9ERVZJQ0VfSURfTFNJX1BMQVNN
QSkgfHwKKwkJCSAgICAoaW5zdGFuY2UtPnBkZXYtPmRldmljZSA9PQogCQkJICAgICBQQ0lfREVW
SUNFX0lEX0xTSV9JTlZBREVSKSB8fAogCQkJICAgIChpbnN0YW5jZS0+cGRldi0+ZGV2aWNlID09
CiAJCQkgICAgIFBDSV9ERVZJQ0VfSURfTFNJX0ZVUlkpKSB7CkBAIC0yNzk4LDYgKzMxNDcsOCBA
QAogCQkJCShpbnN0YW5jZS0+cGRldi0+ZGV2aWNlCiAJCQkJCT09IFBDSV9ERVZJQ0VfSURfTFNJ
X0ZVU0lPTikgfHwKIAkJCQkoaW5zdGFuY2UtPnBkZXYtPmRldmljZQorCQkJCQk9PSBQQ0lfREVW
SUNFX0lEX0xTSV9QTEFTTUEpIHx8CisJCQkJKGluc3RhbmNlLT5wZGV2LT5kZXZpY2UKIAkJCQkJ
PT0gUENJX0RFVklDRV9JRF9MU0lfSU5WQURFUikgfHwKIAkJCQkoaW5zdGFuY2UtPnBkZXYtPmRl
dmljZQogCQkJCQk9PSBQQ0lfREVWSUNFX0lEX0xTSV9GVVJZKSkgewpAQCAtMjgwNiw2ICszMTU3
LDggQEAKIAkJCQlpZiAoKGluc3RhbmNlLT5wZGV2LT5kZXZpY2UgPT0KIAkJCQkJUENJX0RFVklD
RV9JRF9MU0lfRlVTSU9OKSB8fAogCQkJCQkoaW5zdGFuY2UtPnBkZXYtPmRldmljZSA9PQorCQkJ
CQlQQ0lfREVWSUNFX0lEX0xTSV9QTEFTTUEpIHx8CisJCQkJCShpbnN0YW5jZS0+cGRldi0+ZGV2
aWNlID09CiAJCQkJCVBDSV9ERVZJQ0VfSURfTFNJX0lOVkFERVIpIHx8CiAJCQkJCShpbnN0YW5j
ZS0+cGRldi0+ZGV2aWNlID09CiAJCQkJCVBDSV9ERVZJQ0VfSURfTFNJX0ZVUlkpKSB7CkBAIC0z
MDMyLDYgKzMzODUsNyBAQAogCQljbWQtPmZyYW1lLT5pby5jb250ZXh0ID0gY3B1X3RvX2xlMzIo
Y21kLT5pbmRleCk7CiAJCWNtZC0+ZnJhbWUtPmlvLnBhZF8wID0gMDsKIAkJaWYgKChpbnN0YW5j
ZS0+cGRldi0+ZGV2aWNlICE9IFBDSV9ERVZJQ0VfSURfTFNJX0ZVU0lPTikgJiYKKwkJICAgIChp
bnN0YW5jZS0+cGRldi0+ZGV2aWNlICE9IFBDSV9ERVZJQ0VfSURfTFNJX1BMQVNNQSkgJiYKIAkJ
ICAgIChpbnN0YW5jZS0+cGRldi0+ZGV2aWNlICE9IFBDSV9ERVZJQ0VfSURfTFNJX0lOVkFERVIp
ICYmCiAJCQkoaW5zdGFuY2UtPnBkZXYtPmRldmljZSAhPSBQQ0lfREVWSUNFX0lEX0xTSV9GVVJZ
KSAmJgogCQkgICAgKHJlc2V0X2RldmljZXMpKQpAQCAtMzYzOCw2ICszOTkyLDcgQEAKIAlzdHJ1
Y3QgbWVnYXNhc19jdHJsX2luZm8gKmN0cmxfaW5mbzsKIAl1bnNpZ25lZCBsb25nIGJhcl9saXN0
OwogCWludCBpLCBsb29wLCBmd19tc2l4X2NvdW50ID0gMDsKKwlzdHJ1Y3QgSU9WXzExMSAqaW92
UHRyOwogCiAJLyogRmluZCBmaXJzdCBtZW1vcnkgYmFyICovCiAJYmFyX2xpc3QgPSBwY2lfc2Vs
ZWN0X2JhcnMoaW5zdGFuY2UtPnBkZXYsIElPUkVTT1VSQ0VfTUVNKTsKQEAgLTM2NjAsNiArNDAx
NSw3IEBACiAKIAlzd2l0Y2ggKGluc3RhbmNlLT5wZGV2LT5kZXZpY2UpIHsKIAljYXNlIFBDSV9E
RVZJQ0VfSURfTFNJX0ZVU0lPTjoKKwljYXNlIFBDSV9ERVZJQ0VfSURfTFNJX1BMQVNNQToKIAlj
YXNlIFBDSV9ERVZJQ0VfSURfTFNJX0lOVkFERVI6CiAJY2FzZSBQQ0lfREVWSUNFX0lEX0xTSV9G
VVJZOgogCQlpbnN0YW5jZS0+aW5zdGFuY2V0ID0gJm1lZ2FzYXNfaW5zdGFuY2VfdGVtcGxhdGVf
ZnVzaW9uOwpAQCAtMzcxNCw3ICs0MDcwLDggQEAKIAkJc2NyYXRjaF9wYWRfMiA9IHJlYWRsCiAJ
CQkoJmluc3RhbmNlLT5yZWdfc2V0LT5vdXRib3VuZF9zY3JhdGNoX3BhZF8yKTsKIAkJLyogQ2hl
Y2sgbWF4IE1TSS1YIHZlY3RvcnMgKi8KLQkJaWYgKGluc3RhbmNlLT5wZGV2LT5kZXZpY2UgPT0g
UENJX0RFVklDRV9JRF9MU0lfRlVTSU9OKSB7CisJCWlmICgoaW5zdGFuY2UtPnBkZXYtPmRldmlj
ZSA9PSBQQ0lfREVWSUNFX0lEX0xTSV9GVVNJT04pIHx8CisJCSAgICAoaW5zdGFuY2UtPnBkZXYt
PmRldmljZSA9PSBQQ0lfREVWSUNFX0lEX0xTSV9QTEFTTUEpKSB7CiAJCQlpbnN0YW5jZS0+bXNp
eF92ZWN0b3JzID0gKHNjcmF0Y2hfcGFkXzIKIAkJCQkmIE1SX01BWF9SRVBMWV9RVUVVRVNfT0ZG
U0VUKSArIDE7CiAJCQlmd19tc2l4X2NvdW50ID0gaW5zdGFuY2UtPm1zaXhfdmVjdG9yczsKQEAg
LTM4MjUsNiArNDE4Miw3IEBACiAJCWN0cmxfaW5mby0+cHJvcGVydGllcy5Pbk9mZlByb3BlcnRp
ZXMuZGlzYWJsZU9ubGluZUN0cmxSZXNldDsKIAkJLyogYWRhcHRlck9wZXJhdGlvbnMyIGFyZSBj
b252ZXJ0ZWQgaW50byBDUFUgYXJjaCovCiAJCWxlMzJfdG9fY3B1cygodTMyICopJmN0cmxfaW5m
by0+YWRhcHRlck9wZXJhdGlvbnMyKTsKKwkJaW5zdGFuY2UtPm1waW8gPSBjdHJsX2luZm8tPmFk
YXB0ZXJPcGVyYXRpb25zMi5tcGlvOwogCQlpbnN0YW5jZS0+VW5ldmVuU3BhblN1cHBvcnQgPQog
CQkJY3RybF9pbmZvLT5hZGFwdGVyT3BlcmF0aW9uczIuc3VwcG9ydFVuZXZlblNwYW5zOwogCQlp
ZiAoaW5zdGFuY2UtPlVuZXZlblNwYW5TdXBwb3J0KSB7CkBAIC0zODM3LDYgKzQxOTUsMjAgQEAK
IAkJCQlmdXNpb24tPmZhc3RfcGF0aF9pbyA9IDA7CiAKIAkJfQorCQlpZiAoY3RybF9pbmZvLT5o
b3N0X2ludGVyZmFjZS5TUklPVikgeworCQkJaWYgKCFjdHJsX2luZm8tPmFkYXB0ZXJPcGVyYXRp
b25zMi5hY3RpdmVQYXNzaXZlKQorCQkJCWluc3RhbmNlLT5QbGFzbWFGVzExMSA9IDE7CisKKwkJ
CWlmICghaW5zdGFuY2UtPlBsYXNtYUZXMTExKQorCQkJCWluc3RhbmNlLT5yZXF1ZXN0b3JJZCA9
CisJCQkJCWN0cmxfaW5mby0+aW92LnJlcXVlc3RvcklkOworCQkJZWxzZSB7CisJCQkJaW92UHRy
ID0gKHN0cnVjdCBJT1ZfMTExICopKCh1bnNpZ25lZCBjaGFyICopY3RybF9pbmZvICsgSU9WXzEx
MV9PRkZTRVQpOworCQkJCWluc3RhbmNlLT5yZXF1ZXN0b3JJZCA9IGlvdlB0ci0+cmVxdWVzdG9y
SWQ7CisJCQl9CisJCQlwcmludGsoS0VSTl9XQVJOSU5HICJtZWdhcmFpZF9zYXM6IEkgYW0gVkYg
IgorCQkJICAgICAgICJyZXF1ZXN0b3JJZCAlZFxuIiwgaW5zdGFuY2UtPnJlcXVlc3RvcklkKTsK
KwkJfQogCX0KIAlpbnN0YW5jZS0+bWF4X3NlY3RvcnNfcGVyX3JlcSA9IGluc3RhbmNlLT5tYXhf
bnVtX3NnZSAqCiAJCQkJCQlQQUdFX1NJWkUgLyA1MTI7CkBAIC0zODY5LDYgKzQyNDEsMTcgQEAK
IAl0YXNrbGV0X2luaXQoJmluc3RhbmNlLT5pc3JfdGFza2xldCwgaW5zdGFuY2UtPmluc3RhbmNl
dC0+dGFza2xldCwKIAkJKHVuc2lnbmVkIGxvbmcpaW5zdGFuY2UpOwogCisJLyogTGF1bmNoIFNS
LUlPViBoZWFydGJlYXQgdGltZXIgKi8KKwlpZiAoaW5zdGFuY2UtPnJlcXVlc3RvcklkKSB7CisJ
CWlmICghbWVnYXNhc19zcmlvdl9zdGFydF9oZWFydGJlYXQoaW5zdGFuY2UsIDEpKQorCQkJbWVn
YXNhc19zdGFydF90aW1lcihpbnN0YW5jZSwKKwkJCQkJICAgICZpbnN0YW5jZS0+c3Jpb3ZfaGVh
cnRiZWF0X3RpbWVyLAorCQkJCQkgICAgbWVnYXNhc19zcmlvdl9oZWFydGJlYXRfaGFuZGxlciwK
KwkJCQkJICAgIE1FR0FTQVNfU1JJT1ZfSEVBUlRCRUFUX0lOVEVSVkFMX1ZGKTsKKwkJZWxzZQor
CQkJaW5zdGFuY2UtPnNraXBfaGVhcnRiZWF0X3RpbWVyX2RlbCA9IDE7CisJfQorCiAJcmV0dXJu
IDA7CiAKIGZhaWxfaW5pdF9hZGFwdGVyOgpAQCAtNDE4MSw2ICs0NTY0LDcgQEAKIAogCS8qIEZ1
c2lvbiBvbmx5IHN1cHBvcnRzIGhvc3QgcmVzZXQgKi8KIAlpZiAoKGluc3RhbmNlLT5wZGV2LT5k
ZXZpY2UgPT0gUENJX0RFVklDRV9JRF9MU0lfRlVTSU9OKSB8fAorCSAgICAoaW5zdGFuY2UtPnBk
ZXYtPmRldmljZSA9PSBQQ0lfREVWSUNFX0lEX0xTSV9QTEFTTUEpIHx8CiAJICAgIChpbnN0YW5j
ZS0+cGRldi0+ZGV2aWNlID09IFBDSV9ERVZJQ0VfSURfTFNJX0lOVkFERVIpIHx8CiAJICAgIChp
bnN0YW5jZS0+cGRldi0+ZGV2aWNlID09IFBDSV9ERVZJQ0VfSURfTFNJX0ZVUlkpKSB7CiAJCWhv
c3QtPmhvc3R0LT5laF9kZXZpY2VfcmVzZXRfaGFuZGxlciA9IE5VTEw7CkBAIC00MzA2LDYgKzQ2
OTAsNyBAQAogCiAJc3dpdGNoIChpbnN0YW5jZS0+cGRldi0+ZGV2aWNlKSB7CiAJY2FzZSBQQ0lf
REVWSUNFX0lEX0xTSV9GVVNJT046CisJY2FzZSBQQ0lfREVWSUNFX0lEX0xTSV9QTEFTTUE6CiAJ
Y2FzZSBQQ0lfREVWSUNFX0lEX0xTSV9JTlZBREVSOgogCWNhc2UgUENJX0RFVklDRV9JRF9MU0lf
RlVSWToKIAl7CkBAIC00NDAyLDYgKzQ3ODcsNyBAQAogCWluc3RhbmNlLT5VbmV2ZW5TcGFuU3Vw
cG9ydCA9IDA7CiAKIAlpZiAoKGluc3RhbmNlLT5wZGV2LT5kZXZpY2UgPT0gUENJX0RFVklDRV9J
RF9MU0lfRlVTSU9OKSB8fAorCSAgICAoaW5zdGFuY2UtPnBkZXYtPmRldmljZSA9PSBQQ0lfREVW
SUNFX0lEX0xTSV9QTEFTTUEpIHx8CiAJICAgIChpbnN0YW5jZS0+cGRldi0+ZGV2aWNlID09IFBD
SV9ERVZJQ0VfSURfTFNJX0lOVkFERVIpIHx8CiAJICAgIChpbnN0YW5jZS0+cGRldi0+ZGV2aWNl
ID09IFBDSV9ERVZJQ0VfSURfTFNJX0ZVUlkpKQogCQlJTklUX1dPUksoJmluc3RhbmNlLT53b3Jr
X2luaXQsIG1lZ2FzYXNfZnVzaW9uX29jcl93cSk7CkBAIC00NDE0LDYgKzQ4MDAsMjYgQEAKIAlp
ZiAobWVnYXNhc19pbml0X2Z3KGluc3RhbmNlKSkKIAkJZ290byBmYWlsX2luaXRfbWZpOwogCisJ
aWYgKGluc3RhbmNlLT5yZXF1ZXN0b3JJZCkgeworCQlpZiAoaW5zdGFuY2UtPlBsYXNtYUZXMTEx
KSB7CisJCQlpbnN0YW5jZS0+dmZfYWZmaWxpYXRpb25fMTExID0KKwkJCQlwY2lfYWxsb2NfY29u
c2lzdGVudChwZGV2LCBzaXplb2Yoc3RydWN0IE1SX0xEX1ZGX0FGRklMSUFUSU9OXzExMSksCisJ
CQkJCQkgICAgICZpbnN0YW5jZS0+dmZfYWZmaWxpYXRpb25fMTExX2gpOworCQkJaWYgKCFpbnN0
YW5jZS0+dmZfYWZmaWxpYXRpb25fMTExKQorCQkJCXByaW50ayhLRVJOX1dBUk5JTkcgIm1lZ2Fz
YXM6IENhbid0IGFsbG9jYXRlICIKKwkJCQkgICAgICAgIm1lbW9yeSBmb3IgVkYgYWZmaWxpYXRp
b24gYnVmZmVyXG4iKTsKKwkJfSBlbHNlIHsKKwkJCWluc3RhbmNlLT52Zl9hZmZpbGlhdGlvbiA9
CisJCQkJcGNpX2FsbG9jX2NvbnNpc3RlbnQocGRldiwKKwkJCQkJCSAgICAgKE1BWF9MT0dJQ0FM
X0RSSVZFUyArIDEpICoKKwkJCQkJCSAgICAgc2l6ZW9mKHN0cnVjdCBNUl9MRF9WRl9BRkZJTElB
VElPTiksCisJCQkJCQkgICAgICZpbnN0YW5jZS0+dmZfYWZmaWxpYXRpb25faCk7CisJCQlpZiAo
IWluc3RhbmNlLT52Zl9hZmZpbGlhdGlvbikKKwkJCQlwcmludGsoS0VSTl9XQVJOSU5HICJtZWdh
c2FzOiBDYW4ndCBhbGxvY2F0ZSAiCisJCQkJICAgICAgICJtZW1vcnkgZm9yIFZGIGFmZmlsaWF0
aW9uIGJ1ZmZlclxuIik7CisJCX0KKwl9CisKIHJldHJ5X2lycV9yZWdpc3RlcjoKIAkvKgogCSAq
IFJlZ2lzdGVyIElSUQpAQCAtNDUwOCw2ICs0OTE0LDcgQEAKIAkJZnJlZV9pcnEoaW5zdGFuY2Ut
PnBkZXYtPmlycSwgJmluc3RhbmNlLT5pcnFfY29udGV4dFswXSk7CiBmYWlsX2lycToKIAlpZiAo
KGluc3RhbmNlLT5wZGV2LT5kZXZpY2UgPT0gUENJX0RFVklDRV9JRF9MU0lfRlVTSU9OKSB8fAor
CSAgICAoaW5zdGFuY2UtPnBkZXYtPmRldmljZSA9PSBQQ0lfREVWSUNFX0lEX0xTSV9QTEFTTUEp
IHx8CiAJICAgIChpbnN0YW5jZS0+cGRldi0+ZGV2aWNlID09IFBDSV9ERVZJQ0VfSURfTFNJX0lO
VkFERVIpIHx8CiAJICAgIChpbnN0YW5jZS0+cGRldi0+ZGV2aWNlID09IFBDSV9ERVZJQ0VfSURf
TFNJX0ZVUlkpKQogCQltZWdhc2FzX3JlbGVhc2VfZnVzaW9uKGluc3RhbmNlKTsKQEAgLTQ2NDEs
NiArNTA0OCwxMCBAQAogCWhvc3QgPSBpbnN0YW5jZS0+aG9zdDsKIAlpbnN0YW5jZS0+dW5sb2Fk
ID0gMTsKIAorCS8qIFNodXRkb3duIFNSLUlPViBoZWFydGJlYXQgdGltZXIgKi8KKwlpZiAoaW5z
dGFuY2UtPnJlcXVlc3RvcklkICYmICFpbnN0YW5jZS0+c2tpcF9oZWFydGJlYXRfdGltZXJfZGVs
KQorCQlkZWxfdGltZXJfc3luYygmaW5zdGFuY2UtPnNyaW92X2hlYXJ0YmVhdF90aW1lcik7CisK
IAltZWdhc2FzX2ZsdXNoX2NhY2hlKGluc3RhbmNlKTsKIAltZWdhc2FzX3NodXRkb3duX2NvbnRy
b2xsZXIoaW5zdGFuY2UsIE1SX0RDTURfSElCRVJOQVRFX1NIVVRET1dOKTsKIApAQCAtNDcyNyw2
ICs1MTM4LDcgQEAKIAogCXN3aXRjaCAoaW5zdGFuY2UtPnBkZXYtPmRldmljZSkgewogCWNhc2Ug
UENJX0RFVklDRV9JRF9MU0lfRlVTSU9OOgorCWNhc2UgUENJX0RFVklDRV9JRF9MU0lfUExBU01B
OgogCWNhc2UgUENJX0RFVklDRV9JRF9MU0lfSU5WQURFUjoKIAljYXNlIFBDSV9ERVZJQ0VfSURf
TFNJX0ZVUlk6CiAJewpAQCAtNDc5Miw2ICs1MjA0LDE3IEBACiAJCX0KIAl9CiAKKwkvKiBSZS1s
YXVuY2ggU1ItSU9WIGhlYXJ0YmVhdCB0aW1lciAqLworCWlmIChpbnN0YW5jZS0+cmVxdWVzdG9y
SWQpIHsKKwkJaWYgKCFtZWdhc2FzX3NyaW92X3N0YXJ0X2hlYXJ0YmVhdChpbnN0YW5jZSwgMCkp
CisJCQltZWdhc2FzX3N0YXJ0X3RpbWVyKGluc3RhbmNlLAorCQkJCQkgICAgJmluc3RhbmNlLT5z
cmlvdl9oZWFydGJlYXRfdGltZXIsCisJCQkJCSAgICBtZWdhc2FzX3NyaW92X2hlYXJ0YmVhdF9o
YW5kbGVyLAorCQkJCQkgICAgTUVHQVNBU19TUklPVl9IRUFSVEJFQVRfSU5URVJWQUxfVkYpOwor
CQllbHNlCisJCQlpbnN0YW5jZS0+c2tpcF9oZWFydGJlYXRfdGltZXJfZGVsID0gMTsKKwl9CisK
IAlpbnN0YW5jZS0+aW5zdGFuY2V0LT5lbmFibGVfaW50cihpbnN0YW5jZSk7CiAJaW5zdGFuY2Ut
PnVubG9hZCA9IDA7CiAKQEAgLTQ4NDYsNiArNTI2OSwxMCBAQAogCWhvc3QgPSBpbnN0YW5jZS0+
aG9zdDsKIAlmdXNpb24gPSBpbnN0YW5jZS0+Y3RybF9jb250ZXh0OwogCisJLyogU2h1dGRvd24g
U1ItSU9WIGhlYXJ0YmVhdCB0aW1lciAqLworCWlmIChpbnN0YW5jZS0+cmVxdWVzdG9ySWQgJiYg
IWluc3RhbmNlLT5za2lwX2hlYXJ0YmVhdF90aW1lcl9kZWwpCisJCWRlbF90aW1lcl9zeW5jKCZp
bnN0YW5jZS0+c3Jpb3ZfaGVhcnRiZWF0X3RpbWVyKTsKKwogCXNjc2lfcmVtb3ZlX2hvc3QoaW5z
dGFuY2UtPmhvc3QpOwogCW1lZ2FzYXNfZmx1c2hfY2FjaGUoaW5zdGFuY2UpOwogCW1lZ2FzYXNf
c2h1dGRvd25fY29udHJvbGxlcihpbnN0YW5jZSwgTVJfRENNRF9DVFJMX1NIVVRET1dOKTsKQEAg
LTQ4OTEsNiArNTMxOCw3IEBACiAKIAlzd2l0Y2ggKGluc3RhbmNlLT5wZGV2LT5kZXZpY2UpIHsK
IAljYXNlIFBDSV9ERVZJQ0VfSURfTFNJX0ZVU0lPTjoKKwljYXNlIFBDSV9ERVZJQ0VfSURfTFNJ
X1BMQVNNQToKIAljYXNlIFBDSV9ERVZJQ0VfSURfTFNJX0lOVkFERVI6CiAJY2FzZSBQQ0lfREVW
SUNFX0lEX0xTSV9GVVJZOgogCQltZWdhc2FzX3JlbGVhc2VfZnVzaW9uKGluc3RhbmNlKTsKQEAg
LTQ5MTcsNiArNTM0NSwyNCBAQAogCWlmIChpbnN0YW5jZS0+ZXZ0X2RldGFpbCkKIAkJcGNpX2Zy
ZWVfY29uc2lzdGVudChwZGV2LCBzaXplb2Yoc3RydWN0IG1lZ2FzYXNfZXZ0X2RldGFpbCksCiAJ
CQkJaW5zdGFuY2UtPmV2dF9kZXRhaWwsIGluc3RhbmNlLT5ldnRfZGV0YWlsX2gpOworCisJaWYg
KGluc3RhbmNlLT52Zl9hZmZpbGlhdGlvbikKKwkJcGNpX2ZyZWVfY29uc2lzdGVudChwZGV2LCAo
TUFYX0xPR0lDQUxfRFJJVkVTICsgMSkgKgorCQkJCSAgICBzaXplb2Yoc3RydWN0IE1SX0xEX1ZG
X0FGRklMSUFUSU9OKSwKKwkJCQkgICAgaW5zdGFuY2UtPnZmX2FmZmlsaWF0aW9uLAorCQkJCSAg
ICBpbnN0YW5jZS0+dmZfYWZmaWxpYXRpb25faCk7CisKKwlpZiAoaW5zdGFuY2UtPnZmX2FmZmls
aWF0aW9uXzExMSkKKwkJcGNpX2ZyZWVfY29uc2lzdGVudChwZGV2LAorCQkJCSAgICBzaXplb2Yo
c3RydWN0IE1SX0xEX1ZGX0FGRklMSUFUSU9OXzExMSksCisJCQkJICAgIGluc3RhbmNlLT52Zl9h
ZmZpbGlhdGlvbl8xMTEsCisJCQkJICAgIGluc3RhbmNlLT52Zl9hZmZpbGlhdGlvbl8xMTFfaCk7
CisKKwlpZiAoaW5zdGFuY2UtPmhiX2hvc3RfbWVtKQorCQlwY2lfZnJlZV9jb25zaXN0ZW50KHBk
ZXYsIHNpemVvZihzdHJ1Y3QgTVJfQ1RSTF9IQl9IT1NUX01FTSksCisJCQkJICAgIGluc3RhbmNl
LT5oYl9ob3N0X21lbSwKKwkJCQkgICAgaW5zdGFuY2UtPmhiX2hvc3RfbWVtX2gpOworCiAJc2Nz
aV9ob3N0X3B1dChob3N0KTsKIAogCXBjaV9kaXNhYmxlX2RldmljZShwZGV2KTsKQEAgLTUyMDUs
NiArNTY1MSwxNiBAQAogCQlnb3RvIG91dF9rZnJlZV9pb2M7CiAJfQogCisJLyogQWRqdXN0IGlv
Y3RsIHdhaXQgdGltZSBmb3IgVkYgbW9kZSAqLworCWlmIChpbnN0YW5jZS0+cmVxdWVzdG9ySWQp
CisJCXdhaXRfdGltZSA9IE1FR0FTQVNfUk9VVElORV9XQUlUX1RJTUVfVkY7CisKKwkvKiBCbG9j
ayBpb2N0bHMgaW4gVkYgbW9kZSAqLworCWlmIChpbnN0YW5jZS0+cmVxdWVzdG9ySWQgJiYgIWFs
bG93X3ZmX2lvY3RscykgeworCQllcnJvciA9IC1FTk9ERVY7CisJCWdvdG8gb3V0X2tmcmVlX2lv
YzsKKwl9CisKIAlpZiAoaW5zdGFuY2UtPmFkcHJlY292ZXJ5ID09IE1FR0FTQVNfSFdfQ1JJVElD
QUxfRVJST1IpIHsKIAkJcHJpbnRrKEtFUk5fRVJSICJDb250cm9sbGVyIGluIGNyaXQgZXJyb3Jc
biIpOwogCQllcnJvciA9IC1FTk9ERVY7CkBAIC01NTE0LDcgKzU5NzAsNyBAQAogCXUxNiAgICAg
cGRfaW5kZXggPSAwOwogCXUxNglsZF9pbmRleCA9IDA7CiAJaW50ICAgICBpLCBqLCBkb3NjYW4g
PSAwOwotCXUzMiBzZXFfbnVtOworCXUzMiBzZXFfbnVtLCB3YWl0X3RpbWUgPSBNRUdBU0FTX1JF
U0VUX1dBSVRfVElNRTsKIAlpbnQgZXJyb3I7CiAKIAlpZiAoIWluc3RhbmNlKSB7CkBAIC01NTIy
LDYgKzU5NzgsMjMgQEAKIAkJa2ZyZWUoZXYpOwogCQlyZXR1cm47CiAJfQorCisJLyogQWRqdXN0
IGV2ZW50IHdvcmtxdWV1ZSB0aHJlYWQgd2FpdCB0aW1lIGZvciBWRiBtb2RlICovCisJaWYgKGlu
c3RhbmNlLT5yZXF1ZXN0b3JJZCkKKwkJd2FpdF90aW1lID0gTUVHQVNBU19ST1VUSU5FX1dBSVRf
VElNRV9WRjsKKworCS8qIERvbid0IHJ1biB0aGUgZXZlbnQgd29ya3F1ZXVlIHRocmVhZCBpZiBP
Q1IgaXMgcnVubmluZyAqLworCWZvciAoaSA9IDA7IGkgPCB3YWl0X3RpbWU7IGkrKykgeworCQlp
ZiAoaW5zdGFuY2UtPmFkcHJlY292ZXJ5ID09IE1FR0FTQVNfSEJBX09QRVJBVElPTkFMKQorCQkJ
YnJlYWs7CisJCWlmICghKGkgJSBNRUdBU0FTX1JFU0VUX05PVElDRV9JTlRFUlZBTCkpIHsKKwkJ
CXByaW50ayhLRVJOX05PVElDRSAibWVnYXNhczogJXMgd2FpdGluZyBmb3IgIgorCQkJICAgICAg
ICJjb250cm9sbGVyIHJlc2V0IHRvIGZpbmlzaCBmb3Igc2NzaSVkXG4iLAorCQkJICAgICAgIF9f
ZnVuY19fLCBpbnN0YW5jZS0+aG9zdC0+aG9zdF9ubyk7CisJCX0KKwkJbXNsZWVwKDEwMDApOwor
CX0KKwogCWluc3RhbmNlLT5ldiA9IE5VTEw7CiAJaG9zdCA9IGluc3RhbmNlLT5ob3N0OwogCWlm
IChpbnN0YW5jZS0+ZXZ0X2RldGFpbCkgewpAQCAtNTU4OCw2NSArNjA2MSw2NCBAQAogCQljYXNl
IE1SX0VWVF9MRF9PRkZMSU5FOgogCQljYXNlIE1SX0VWVF9DRkdfQ0xFQVJFRDoKIAkJY2FzZSBN
Ul9FVlRfTERfREVMRVRFRDoKLQkJCWlmIChtZWdhc2FzX2xkX2xpc3RfcXVlcnkoaW5zdGFuY2Us
Ci0JCQkJCU1SX0xEX1FVRVJZX1RZUEVfRVhQT1NFRF9UT19IT1NUKSkKLQkJCQltZWdhc2FzX2dl
dF9sZF9saXN0KGluc3RhbmNlKTsKLQkJCWZvciAoaSA9IDA7IGkgPCBNRUdBU0FTX01BWF9MRF9D
SEFOTkVMUzsgaSsrKSB7Ci0JCQkJZm9yIChqID0gMDsKLQkJCQlqIDwgTUVHQVNBU19NQVhfREVW
X1BFUl9DSEFOTkVMOwotCQkJCWorKykgewotCi0JCQkJbGRfaW5kZXggPQotCQkJCShpICogTUVH
QVNBU19NQVhfREVWX1BFUl9DSEFOTkVMKSArIGo7Ci0KLQkJCQlzZGV2MSA9IHNjc2lfZGV2aWNl
X2xvb2t1cChob3N0LAotCQkJCQlNRUdBU0FTX01BWF9QRF9DSEFOTkVMUyArIGksCi0JCQkJCWos
Ci0JCQkJCTApOwotCi0JCQkJaWYgKGluc3RhbmNlLT5sZF9pZHNbbGRfaW5kZXhdICE9IDB4ZmYp
IHsKLQkJCQkJaWYgKHNkZXYxKSB7Ci0JCQkJCQlzY3NpX2RldmljZV9wdXQoc2RldjEpOwotCQkJ
CQl9Ci0JCQkJfSBlbHNlIHsKLQkJCQkJaWYgKHNkZXYxKSB7Ci0JCQkJCQlzY3NpX3JlbW92ZV9k
ZXZpY2Uoc2RldjEpOwotCQkJCQkJc2NzaV9kZXZpY2VfcHV0KHNkZXYxKTsKKwkJCWlmICghaW5z
dGFuY2UtPnJlcXVlc3RvcklkIHx8CisJCQkgICAgKGluc3RhbmNlLT5yZXF1ZXN0b3JJZCAmJgor
CQkJICAgICBtZWdhc2FzX2dldF9sZF92Zl9hZmZpbGlhdGlvbihpbnN0YW5jZSwgMCkpKSB7CisJ
CQkJaWYgKG1lZ2FzYXNfbGRfbGlzdF9xdWVyeShpbnN0YW5jZSwKKwkJCQkJCQkgIE1SX0xEX1FV
RVJZX1RZUEVfRVhQT1NFRF9UT19IT1NUKSkKKwkJCQkJbWVnYXNhc19nZXRfbGRfbGlzdChpbnN0
YW5jZSk7CisJCQkJZm9yIChpID0gMDsgaSA8IE1FR0FTQVNfTUFYX0xEX0NIQU5ORUxTOyBpKysp
IHsKKwkJCQkJZm9yIChqID0gMDsKKwkJCQkJICAgICBqIDwgTUVHQVNBU19NQVhfREVWX1BFUl9D
SEFOTkVMOworCQkJCQkgICAgIGorKykgeworCisJCQkJCQlsZF9pbmRleCA9CisJCQkJCQkJKGkg
KiBNRUdBU0FTX01BWF9ERVZfUEVSX0NIQU5ORUwpICsgajsKKworCQkJCQkJc2RldjEgPSBzY3Np
X2RldmljZV9sb29rdXAoaG9zdCwgTUVHQVNBU19NQVhfUERfQ0hBTk5FTFMgKyBpLCBqLCAwKTsK
KworCQkJCQkJaWYgKGluc3RhbmNlLT5sZF9pZHNbbGRfaW5kZXhdCisJCQkJCQkgICAgIT0gMHhm
ZikgeworCQkJCQkJCWlmIChzZGV2MSkKKwkJCQkJCQkJc2NzaV9kZXZpY2VfcHV0KHNkZXYxKTsK
KwkJCQkJCX0gZWxzZSB7CisJCQkJCQkJaWYgKHNkZXYxKSB7CisJCQkJCQkJCXNjc2lfcmVtb3Zl
X2RldmljZShzZGV2MSk7CisJCQkJCQkJCXNjc2lfZGV2aWNlX3B1dChzZGV2MSk7CisJCQkJCQkJ
fQorCQkJCQkJfQogCQkJCQl9CiAJCQkJfQotCQkJCX0KKwkJCQlkb3NjYW4gPSAwOwogCQkJfQot
CQkJZG9zY2FuID0gMDsKIAkJCWJyZWFrOwogCQljYXNlIE1SX0VWVF9MRF9DUkVBVEVEOgotCQkJ
aWYgKG1lZ2FzYXNfbGRfbGlzdF9xdWVyeShpbnN0YW5jZSwKLQkJCQkJTVJfTERfUVVFUllfVFlQ
RV9FWFBPU0VEX1RPX0hPU1QpKQotCQkJCW1lZ2FzYXNfZ2V0X2xkX2xpc3QoaW5zdGFuY2UpOwot
CQkJZm9yIChpID0gMDsgaSA8IE1FR0FTQVNfTUFYX0xEX0NIQU5ORUxTOyBpKyspIHsKLQkJCQlm
b3IgKGogPSAwOwotCQkJCQlqIDwgTUVHQVNBU19NQVhfREVWX1BFUl9DSEFOTkVMOwotCQkJCQlq
KyspIHsKLQkJCQkJbGRfaW5kZXggPQotCQkJCQkoaSAqIE1FR0FTQVNfTUFYX0RFVl9QRVJfQ0hB
Tk5FTCkgKyBqOwotCi0JCQkJCXNkZXYxID0gc2NzaV9kZXZpY2VfbG9va3VwKGhvc3QsCi0JCQkJ
CQlNRUdBU0FTX01BWF9QRF9DSEFOTkVMUyArIGksCi0JCQkJCQlqLCAwKTsKLQotCQkJCQlpZiAo
aW5zdGFuY2UtPmxkX2lkc1tsZF9pbmRleF0gIT0KLQkJCQkJCQkJMHhmZikgewotCQkJCQkJaWYg
KCFzZGV2MSkgewotCQkJCQkJCXNjc2lfYWRkX2RldmljZShob3N0LAotCQkJCQkJTUVHQVNBU19N
QVhfUERfQ0hBTk5FTFMgKyBpLAotCQkJCQkJCQlqLCAwKTsKKwkJCWlmICghaW5zdGFuY2UtPnJl
cXVlc3RvcklkIHx8CisJCQkgICAgKGluc3RhbmNlLT5yZXF1ZXN0b3JJZCAmJgorCQkJICAgICBt
ZWdhc2FzX2dldF9sZF92Zl9hZmZpbGlhdGlvbihpbnN0YW5jZSwgMCkpKSB7CisJCQkJaWYgKG1l
Z2FzYXNfbGRfbGlzdF9xdWVyeShpbnN0YW5jZSwKKwkJCQkJCQkgIE1SX0xEX1FVRVJZX1RZUEVf
RVhQT1NFRF9UT19IT1NUKSkKKwkJCQkJbWVnYXNhc19nZXRfbGRfbGlzdChpbnN0YW5jZSk7CisJ
CQkJZm9yIChpID0gMDsgaSA8IE1FR0FTQVNfTUFYX0xEX0NIQU5ORUxTOyBpKyspIHsKKwkJCQkJ
Zm9yIChqID0gMDsKKwkJCQkJICAgICBqIDwgTUVHQVNBU19NQVhfREVWX1BFUl9DSEFOTkVMOwor
CQkJCQkgICAgIGorKykgeworCQkJCQkJbGRfaW5kZXggPQorCQkJCQkJCShpICogTUVHQVNBU19N
QVhfREVWX1BFUl9DSEFOTkVMKSArIGo7CisKKwkJCQkJCXNkZXYxID0gc2NzaV9kZXZpY2VfbG9v
a3VwKGhvc3QsIE1FR0FTQVNfTUFYX1BEX0NIQU5ORUxTICsgaSwgaiwgMCk7CisKKwkJCQkJCWlm
IChpbnN0YW5jZS0+bGRfaWRzW2xkX2luZGV4XQorCQkJCQkJICAgICE9IDB4ZmYpIHsKKwkJCQkJ
CQlpZiAoIXNkZXYxKQorCQkJCQkJCQlzY3NpX2FkZF9kZXZpY2UoaG9zdCwgTUVHQVNBU19NQVhf
UERfQ0hBTk5FTFMgKyBpLCBqLCAwKTsKIAkJCQkJCX0KLQkJCQkJfQotCQkJCQlpZiAoc2RldjEp
IHsKLQkJCQkJCXNjc2lfZGV2aWNlX3B1dChzZGV2MSk7CisJCQkJCQlpZiAoc2RldjEpCisJCQkJ
CQkJc2NzaV9kZXZpY2VfcHV0KHNkZXYxKTsKIAkJCQkJfQogCQkJCX0KKwkJCQlkb3NjYW4gPSAw
OwogCQkJfQotCQkJZG9zY2FuID0gMDsKIAkJCWJyZWFrOwogCQljYXNlIE1SX0VWVF9DVFJMX0hP
U1RfQlVTX1NDQU5fUkVRVUVTVEVEOgogCQljYXNlIE1SX0VWVF9GT1JFSUdOX0NGR19JTVBPUlRF
RDoKQEAgLTU2NjQsNyArNjEzNiw4IEBACiAJfQogCiAJaWYgKGRvc2NhbikgewotCQlwcmludGso
S0VSTl9JTkZPICJzY2FubmluZyAuLi5cbiIpOworCQlwcmludGsoS0VSTl9JTkZPICJtZWdhcmFp
ZF9zYXM6IHNjYW5uaW5nIGZvciBzY3NpJWQuLi5cbiIsCisJCSAgICAgICBpbnN0YW5jZS0+aG9z
dC0+aG9zdF9ubyk7CiAJCW1lZ2FzYXNfZ2V0X3BkX2xpc3QoaW5zdGFuY2UpOwogCQlmb3IgKGkg
PSAwOyBpIDwgTUVHQVNBU19NQVhfUERfQ0hBTk5FTFM7IGkrKykgewogCQkJZm9yIChqID0gMDsg
aiA8IE1FR0FTQVNfTUFYX0RFVl9QRVJfQ0hBTk5FTDsgaisrKSB7CkBAIC01Njg2LDI4ICs2MTU5
LDMxIEBACiAJCQl9CiAJCX0KIAotCQlpZiAobWVnYXNhc19sZF9saXN0X3F1ZXJ5KGluc3RhbmNl
LAotCQkJCQkgIE1SX0xEX1FVRVJZX1RZUEVfRVhQT1NFRF9UT19IT1NUKSkKLQkJCW1lZ2FzYXNf
Z2V0X2xkX2xpc3QoaW5zdGFuY2UpOwotCQlmb3IgKGkgPSAwOyBpIDwgTUVHQVNBU19NQVhfTERf
Q0hBTk5FTFM7IGkrKykgewotCQkJZm9yIChqID0gMDsgaiA8IE1FR0FTQVNfTUFYX0RFVl9QRVJf
Q0hBTk5FTDsgaisrKSB7Ci0JCQkJbGRfaW5kZXggPQotCQkJCShpICogTUVHQVNBU19NQVhfREVW
X1BFUl9DSEFOTkVMKSArIGo7CisJCWlmICghaW5zdGFuY2UtPnJlcXVlc3RvcklkIHx8CisJCSAg
ICAoaW5zdGFuY2UtPnJlcXVlc3RvcklkICYmCisJCSAgICAgbWVnYXNhc19nZXRfbGRfdmZfYWZm
aWxpYXRpb24oaW5zdGFuY2UsIDApKSkgeworCQkJaWYgKG1lZ2FzYXNfbGRfbGlzdF9xdWVyeShp
bnN0YW5jZSwKKwkJCQkJCSAgTVJfTERfUVVFUllfVFlQRV9FWFBPU0VEX1RPX0hPU1QpKQorCQkJ
CW1lZ2FzYXNfZ2V0X2xkX2xpc3QoaW5zdGFuY2UpOworCQkJZm9yIChpID0gMDsgaSA8IE1FR0FT
QVNfTUFYX0xEX0NIQU5ORUxTOyBpKyspIHsKKwkJCQlmb3IgKGogPSAwOyBqIDwgTUVHQVNBU19N
QVhfREVWX1BFUl9DSEFOTkVMOworCQkJCSAgICAgaisrKSB7CisJCQkJCWxkX2luZGV4ID0KKwkJ
CQkJCShpICogTUVHQVNBU19NQVhfREVWX1BFUl9DSEFOTkVMKSArIGo7CiAKLQkJCQlzZGV2MSA9
IHNjc2lfZGV2aWNlX2xvb2t1cChob3N0LAotCQkJCQlNRUdBU0FTX01BWF9QRF9DSEFOTkVMUyAr
IGksIGosIDApOwotCQkJCWlmIChpbnN0YW5jZS0+bGRfaWRzW2xkX2luZGV4XSAhPSAweGZmKSB7
Ci0JCQkJCWlmICghc2RldjEpIHsKLQkJCQkJCXNjc2lfYWRkX2RldmljZShob3N0LAotCQkJCQkJ
TUVHQVNBU19NQVhfUERfQ0hBTk5FTFMgKyBpLAotCQkJCQkJCQlqLCAwKTsKKwkJCQkJc2RldjEg
PSBzY3NpX2RldmljZV9sb29rdXAoaG9zdCwKKwkJCQkJCQkJICAgTUVHQVNBU19NQVhfUERfQ0hB
Tk5FTFMgKyBpLCBqLCAwKTsKKwkJCQkJaWYgKGluc3RhbmNlLT5sZF9pZHNbbGRfaW5kZXhdCisJ
CQkJCSAgICAhPSAweGZmKSB7CisJCQkJCQlpZiAoIXNkZXYxKQorCQkJCQkJCXNjc2lfYWRkX2Rl
dmljZShob3N0LCBNRUdBU0FTX01BWF9QRF9DSEFOTkVMUyArIGksIGosIDApOworCQkJCQkJZWxz
ZQorCQkJCQkJCXNjc2lfZGV2aWNlX3B1dChzZGV2MSk7CiAJCQkJCX0gZWxzZSB7Ci0JCQkJCQlz
Y3NpX2RldmljZV9wdXQoc2RldjEpOwotCQkJCQl9Ci0JCQkJfSBlbHNlIHsKLQkJCQkJaWYgKHNk
ZXYxKSB7Ci0JCQkJCQlzY3NpX3JlbW92ZV9kZXZpY2Uoc2RldjEpOwotCQkJCQkJc2NzaV9kZXZp
Y2VfcHV0KHNkZXYxKTsKKwkJCQkJCWlmIChzZGV2MSkgeworCQkJCQkJCXNjc2lfcmVtb3ZlX2Rl
dmljZShzZGV2MSk7CisJCQkJCQkJc2NzaV9kZXZpY2VfcHV0KHNkZXYxKTsKKwkJCQkJCX0KIAkJ
CQkJfQogCQkJCX0KIAkJCX0KZGlmZiAtTmF1ciBzY3NpLW1pc2Mub2xkL2RyaXZlcnMvc2NzaS9t
ZWdhcmFpZC9tZWdhcmFpZF9zYXNfZnVzaW9uLmMgc2NzaS1taXNjLm5ldy9kcml2ZXJzL3Njc2kv
bWVnYXJhaWQvbWVnYXJhaWRfc2FzX2Z1c2lvbi5jCi0tLSBzY3NpLW1pc2Mub2xkL2RyaXZlcnMv
c2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9zYXNfZnVzaW9uLmMJMjAxNC0wMy0wOSAyMTo0Njo1NC4z
ODU5MTgzOTIgLTA3MDAKKysrIHNjc2ktbWlzYy5uZXcvZHJpdmVycy9zY3NpL21lZ2FyYWlkL21l
Z2FyYWlkX3Nhc19mdXNpb24uYwkyMDE0LTAzLTEwIDAxOjEzOjMwLjA2NTg1NjI3NSAtMDcwMApA
QCAtNjIsNyArNjIsOCBAQAogCQkgICAgIHN0cnVjdCBtZWdhc2FzX2NtZCAqY21kLCB1OCBhbHRf
c3RhdHVzKTsKIGludCBtZWdhc2FzX2lzX2xkaW8oc3RydWN0IHNjc2lfY21uZCAqY21kKTsKIGlu
dAotd2FpdF9hbmRfcG9sbChzdHJ1Y3QgbWVnYXNhc19pbnN0YW5jZSAqaW5zdGFuY2UsIHN0cnVj
dCBtZWdhc2FzX2NtZCAqY21kKTsKK3dhaXRfYW5kX3BvbGwoc3RydWN0IG1lZ2FzYXNfaW5zdGFu
Y2UgKmluc3RhbmNlLCBzdHJ1Y3QgbWVnYXNhc19jbWQgKmNtZCwKKwkgICAgICBpbnQgc2Vjb25k
cyk7CiAKIHZvaWQKIG1lZ2FzYXNfcmV0dXJuX2NtZChzdHJ1Y3QgbWVnYXNhc19pbnN0YW5jZSAq
aW5zdGFuY2UsIHN0cnVjdCBtZWdhc2FzX2NtZCAqY21kKTsKQEAgLTgxLDYgKzgyLDEzIEBACiB2
b2lkIG1lZ2FyYWlkX3Nhc19raWxsX2hiYShzdHJ1Y3QgbWVnYXNhc19pbnN0YW5jZSAqaW5zdGFu
Y2UpOwogCiBleHRlcm4gdTMyIG1lZ2FzYXNfZGJnX2x2bDsKK3ZvaWQgbWVnYXNhc19zcmlvdl9o
ZWFydGJlYXRfaGFuZGxlcih1bnNpZ25lZCBsb25nIGluc3RhbmNlX2FkZHIpOworaW50IG1lZ2Fz
YXNfc3Jpb3Zfc3RhcnRfaGVhcnRiZWF0KHN0cnVjdCBtZWdhc2FzX2luc3RhbmNlICppbnN0YW5j
ZSwKKwkJCQkgIGludCBpbml0aWFsKTsKK3ZvaWQgbWVnYXNhc19zdGFydF90aW1lcihzdHJ1Y3Qg
bWVnYXNhc19pbnN0YW5jZSAqaW5zdGFuY2UsCisJCQlzdHJ1Y3QgdGltZXJfbGlzdCAqdGltZXIs
CisJCQkgdm9pZCAqZm4sIHVuc2lnbmVkIGxvbmcgaW50ZXJ2YWwpOworZXh0ZXJuIHN0cnVjdCBt
ZWdhc2FzX21nbXRfaW5mbyBtZWdhc2FzX21nbXRfaW5mbzsKIGV4dGVybiBpbnQgcmVzZXR3YWl0
dGltZTsKIAogLyoqCkBAIC01NDksMTIgKzU1NywxMyBAQAogICogRm9yIHBvbGxpbmcsIE1GSSBy
ZXF1aXJlcyB0aGUgY21kX3N0YXR1cyB0byBiZSBzZXQgdG8gMHhGRiBiZWZvcmUgcG9zdGluZy4K
ICAqLwogaW50Ci13YWl0X2FuZF9wb2xsKHN0cnVjdCBtZWdhc2FzX2luc3RhbmNlICppbnN0YW5j
ZSwgc3RydWN0IG1lZ2FzYXNfY21kICpjbWQpCit3YWl0X2FuZF9wb2xsKHN0cnVjdCBtZWdhc2Fz
X2luc3RhbmNlICppbnN0YW5jZSwgc3RydWN0IG1lZ2FzYXNfY21kICpjbWQsCisJaW50IHNlY29u
ZHMpCiB7CiAJaW50IGk7CiAJc3RydWN0IG1lZ2FzYXNfaGVhZGVyICpmcmFtZV9oZHIgPSAmY21k
LT5mcmFtZS0+aGRyOwogCi0JdTMyIG1zZWNzID0gTUZJX1BPTExfVElNRU9VVF9TRUNTICogMTAw
MDsKKwl1MzIgbXNlY3MgPSBzZWNvbmRzICogMTAwMDsKIAogCS8qCiAJICogV2FpdCBmb3IgY21k
X3N0YXR1cyB0byBjaGFuZ2UKQEAgLTY2OSw3ICs2NzgsNyBAQAogCWluc3RhbmNlLT5pbnN0YW5j
ZXQtPmZpcmVfY21kKGluc3RhbmNlLCByZXFfZGVzYy51LmxvdywKIAkJCQkgICAgICByZXFfZGVz
Yy51LmhpZ2gsIGluc3RhbmNlLT5yZWdfc2V0KTsKIAotCXdhaXRfYW5kX3BvbGwoaW5zdGFuY2Us
IGNtZCk7CisJd2FpdF9hbmRfcG9sbChpbnN0YW5jZSwgY21kLCBNRklfUE9MTF9USU1FT1VUX1NF
Q1MpOwogCiAJZnJhbWVfaGRyID0gJmNtZC0+ZnJhbWUtPmhkcjsKIAlpZiAoZnJhbWVfaGRyLT5j
bWRfc3RhdHVzICE9IDApIHsKQEAgLTE3NjksNyArMTc3OCw4IEBACiAKIAlpZiAoaW5kZXggPj0g
aW5zdGFuY2UtPm1heF9md19jbWRzKSB7CiAJCXByaW50ayhLRVJOX0VSUiAibWVnYXNhczogSW52
YWxpZCBTTUlEICgweCV4KXJlcXVlc3QgZm9yICIKLQkJICAgICAgICJkZXNjcmlwdG9yXG4iLCBp
bmRleCk7CisJCSAgICAgICAiZGVzY3JpcHRvciBmb3Igc2NzaSVkXG4iLCBpbmRleCwKKwkJCWlu
c3RhbmNlLT5ob3N0LT5ob3N0X25vKTsKIAkJcmV0dXJuIE5VTEw7CiAJfQogCWZ1c2lvbiA9IGlu
c3RhbmNlLT5jdHJsX2NvbnRleHQ7CkBAIC0yMDM3LDggKzIwNDcsMTEgQEAKIAkJLyogSWYgd2Ug
ZGlkbid0IGNvbXBsZXRlIGFueSBjb21tYW5kcywgY2hlY2sgZm9yIEZXIGZhdWx0ICovCiAJCWZ3
X3N0YXRlID0gaW5zdGFuY2UtPmluc3RhbmNldC0+cmVhZF9md19zdGF0dXNfcmVnKAogCQkJaW5z
dGFuY2UtPnJlZ19zZXQpICYgTUZJX1NUQVRFX01BU0s7Ci0JCWlmIChmd19zdGF0ZSA9PSBNRklf
U1RBVEVfRkFVTFQpCisJCWlmIChmd19zdGF0ZSA9PSBNRklfU1RBVEVfRkFVTFQpIHsKKwkJCXBy
aW50ayhLRVJOX1dBUk5JTkcgIm1lZ2FyYWlkX3NhczogSW9wMlN5c0Rvb3JiZWxsSW50IgorCQkJ
ICAgICAgICJmb3Igc2NzaSVkXG4iLCBpbnN0YW5jZS0+aG9zdC0+aG9zdF9ubyk7CiAJCQlzY2hl
ZHVsZV93b3JrKCZpbnN0YW5jZS0+d29ya19pbml0KTsKKwkJfQogCX0KIAogCXJldHVybiBJUlFf
SEFORExFRDsKQEAgLTIyMDksOSArMjIyMiwxMCBAQAogfQogCiAvKiBUaGlzIGZ1bmN0aW9uIHdh
aXRzIGZvciBvdXRzdGFuZGluZyBjb21tYW5kcyBvbiBmdXNpb24gdG8gY29tcGxldGUgKi8KLWlu
dCBtZWdhc2FzX3dhaXRfZm9yX291dHN0YW5kaW5nX2Z1c2lvbihzdHJ1Y3QgbWVnYXNhc19pbnN0
YW5jZSAqaW5zdGFuY2UpCitpbnQgbWVnYXNhc193YWl0X2Zvcl9vdXRzdGFuZGluZ19mdXNpb24o
c3RydWN0IG1lZ2FzYXNfaW5zdGFuY2UgKmluc3RhbmNlLAorCQkJCQlpbnQgaW90aW1lb3V0LCBp
bnQgKmNvbnZlcnQpCiB7Ci0JaW50IGksIG91dHN0YW5kaW5nLCByZXR2YWwgPSAwOworCWludCBp
LCBvdXRzdGFuZGluZywgcmV0dmFsID0gMCwgaGJfc2Vjb25kc19taXNzZWQgPSAwOwogCXUzMiBm
d19zdGF0ZTsKIAogCWZvciAoaSA9IDA7IGkgPCByZXNldHdhaXR0aW1lOyBpKyspIHsKQEAgLTIy
MjAsMTggKzIyMzQsNDkgQEAKIAkJCWluc3RhbmNlLT5yZWdfc2V0KSAmIE1GSV9TVEFURV9NQVNL
OwogCQlpZiAoZndfc3RhdGUgPT0gTUZJX1NUQVRFX0ZBVUxUKSB7CiAJCQlwcmludGsoS0VSTl9X
QVJOSU5HICJtZWdhc2FzOiBGb3VuZCBGVyBpbiBGQVVMVCBzdGF0ZSwiCi0JCQkgICAgICAgIiB3
aWxsIHJlc2V0IGFkYXB0ZXIuXG4iKTsKKwkJCSAgICAgICAiIHdpbGwgcmVzZXQgYWRhcHRlciBz
Y3NpJWQuXG4iLAorCQkJCWluc3RhbmNlLT5ob3N0LT5ob3N0X25vKTsKKwkJCXJldHZhbCA9IDE7
CisJCQlnb3RvIG91dDsKKwkJfQorCQkvKiBJZiBTUi1JT1YgVkYgbW9kZSAmIGhlYXJ0YmVhdCB0
aW1lb3V0LCBkb24ndCB3YWl0ICovCisJCWlmIChpbnN0YW5jZS0+cmVxdWVzdG9ySWQgJiYgIWlv
dGltZW91dCkgewogCQkJcmV0dmFsID0gMTsKIAkJCWdvdG8gb3V0OwogCQl9CiAKKwkJLyogSWYg
U1ItSU9WIFZGIG1vZGUgJiBJL08gdGltZW91dCwgY2hlY2sgZm9yIEhCIHRpbWVvdXQgKi8KKwkJ
aWYgKGluc3RhbmNlLT5yZXF1ZXN0b3JJZCAmJiBpb3RpbWVvdXQpIHsKKwkJCWlmIChpbnN0YW5j
ZS0+aGJfaG9zdF9tZW0tPkhCLmZ3Q291bnRlciAhPQorCQkJICAgIGluc3RhbmNlLT5oYl9ob3N0
X21lbS0+SEIuZHJpdmVyQ291bnRlcikgeworCQkJCWluc3RhbmNlLT5oYl9ob3N0X21lbS0+SEIu
ZHJpdmVyQ291bnRlciA9CisJCQkJCWluc3RhbmNlLT5oYl9ob3N0X21lbS0+SEIuZndDb3VudGVy
OworCQkJCWhiX3NlY29uZHNfbWlzc2VkID0gMDsKKwkJCX0gZWxzZSB7CisJCQkJaGJfc2Vjb25k
c19taXNzZWQrKzsKKwkJCQlpZiAoaGJfc2Vjb25kc19taXNzZWQgPT0KKwkJCQkgICAgKE1FR0FT
QVNfU1JJT1ZfSEVBUlRCRUFUX0lOVEVSVkFMX1ZGL0haKSkgeworCQkJCQlwcmludGsoS0VSTl9X
QVJOSU5HICJtZWdhc2FzOiBTUi1JT1Y6IgorCQkJCQkgICAgICAgIiBIZWFydGJlYXQgbmV2ZXIg
Y29tcGxldGVkICIKKwkJCQkJICAgICAgICIgd2hpbGUgcG9sbGluZyBkdXJpbmcgSS9PICIKKwkJ
CQkJICAgICAgICIgdGltZW91dCBoYW5kbGluZyBmb3IgIgorCQkJCQkgICAgICAgInNjc2klZC5c
biIsCisJCQkJCSAgICAgICBpbnN0YW5jZS0+aG9zdC0+aG9zdF9ubyk7CisJCQkJCSAgICAgICAq
Y29udmVydCA9IDE7CisJCQkJCSAgICAgICByZXR2YWwgPSAxOworCQkJCQkgICAgICAgZ290byBv
dXQ7CisJCQkJfQorCQkJfQorCQl9CisKIAkJb3V0c3RhbmRpbmcgPSBhdG9taWNfcmVhZCgmaW5z
dGFuY2UtPmZ3X291dHN0YW5kaW5nKTsKIAkJaWYgKCFvdXRzdGFuZGluZykKIAkJCWdvdG8gb3V0
OwogCiAJCWlmICghKGkgJSBNRUdBU0FTX1JFU0VUX05PVElDRV9JTlRFUlZBTCkpIHsKIAkJCXBy
aW50ayhLRVJOX05PVElDRSAibWVnYXNhczogWyUyZF13YWl0aW5nIGZvciAlZCAiCi0JCQkgICAg
ICAgImNvbW1hbmRzIHRvIGNvbXBsZXRlXG4iLCBpLCBvdXRzdGFuZGluZyk7CisJCQkgICAgICAg
ImNvbW1hbmRzIHRvIGNvbXBsZXRlIGZvciBzY3NpJWRcbiIsIGksCisJCQkgICAgICAgb3V0c3Rh
bmRpbmcsIGluc3RhbmNlLT5ob3N0LT5ob3N0X25vKTsKIAkJCW1lZ2FzYXNfY29tcGxldGVfY21k
X2RwY19mdXNpb24oCiAJCQkJKHVuc2lnbmVkIGxvbmcpaW5zdGFuY2UpOwogCQl9CkBAIC0yMjQw
LDcgKzIyODUsOCBAQAogCiAJaWYgKGF0b21pY19yZWFkKCZpbnN0YW5jZS0+Zndfb3V0c3RhbmRp
bmcpKSB7CiAJCXByaW50aygibWVnYXJhaWRfc2FzOiBwZW5kaW5nIGNvbW1hbmRzIHJlbWFpbiBh
ZnRlciB3YWl0aW5nLCAiCi0JCSAgICAgICAid2lsbCByZXNldCBhZGFwdGVyLlxuIik7CisJCSAg
ICAgICAid2lsbCByZXNldCBhZGFwdGVyIHNjc2klZC5cbiIsCisJCSAgICAgICBpbnN0YW5jZS0+
aG9zdC0+aG9zdF9ubyk7CiAJCXJldHZhbCA9IDE7CiAJfQogb3V0OgpAQCAtMjI2MiwxMCArMjMw
OCwzNCBAQAogCQlyZXBseV9kZXNjLT5Xb3JkcyA9IFVMTE9OR19NQVg7CiB9CiAKKy8qIENoZWNr
IGZvciBhIHNlY29uZCBwYXRoIHRoYXQgaXMgY3VycmVudGx5IFVQICovCitpbnQgbWVnYXNhc19j
aGVja19tcGlvX3BhdGhzKHN0cnVjdCBtZWdhc2FzX2luc3RhbmNlICppbnN0YW5jZSwKKwlzdHJ1
Y3Qgc2NzaV9jbW5kICpzY21kKQoreworCWludCBpLCBqLCByZXR2YWwgPSAoRElEX1JFU0VUIDw8
IDE2KTsKKworCWlmIChpbnN0YW5jZS0+bXBpbyAmJiBpbnN0YW5jZS0+cmVxdWVzdG9ySWQpIHsK
KwkJZm9yIChpID0gMCA7IGkgPCBNQVhfTUdNVF9BREFQVEVSUyA7IGkrKykKKwkJCWZvciAoaiA9
IDAgOyBqIDwgTUFYX0xPR0lDQUxfRFJJVkVTOyBqKyspCisJCQkJaWYgKG1lZ2FzYXNfbWdtdF9p
bmZvLmluc3RhbmNlW2ldICYmCisJCQkJICAgIChtZWdhc2FzX21nbXRfaW5mby5pbnN0YW5jZVtp
XSAhPSBpbnN0YW5jZSkgJiYKKwkJCQkgICAgbWVnYXNhc19tZ210X2luZm8uaW5zdGFuY2VbaV0t
Pm1waW8gJiYKKwkJCQkgICAgbWVnYXNhc19tZ210X2luZm8uaW5zdGFuY2VbaV0tPnJlcXVlc3Rv
cklkCisJCQkJICAgICYmCisJCQkJICAgIChtZWdhc2FzX21nbXRfaW5mby5pbnN0YW5jZVtpXS0+
bGRfaWRzW2pdCisJCQkJICAgICA9PSBzY21kLT5kZXZpY2UtPmlkKSkgeworCQkJCQkgICAgcmV0
dmFsID0gKERJRF9OT19DT05ORUNUIDw8IDE2KTsKKwkJCQkJICAgIGdvdG8gb3V0OworCQkJCX0K
Kwl9CitvdXQ6CisJcmV0dXJuIHJldHZhbDsKK30KKwogLyogQ29yZSBmdXNpb24gcmVzZXQgZnVu
Y3Rpb24gKi8KLWludCBtZWdhc2FzX3Jlc2V0X2Z1c2lvbihzdHJ1Y3QgU2NzaV9Ib3N0ICpzaG9z
dCkKK2ludCBtZWdhc2FzX3Jlc2V0X2Z1c2lvbihzdHJ1Y3QgU2NzaV9Ib3N0ICpzaG9zdCwgaW50
IGlvdGltZW91dCkKIHsKLQlpbnQgcmV0dmFsID0gU1VDQ0VTUywgaSwgaiwgcmV0cnkgPSAwOwor
CWludCByZXR2YWwgPSBTVUNDRVNTLCBpLCBqLCByZXRyeSA9IDAsIGNvbnZlcnQgPSAwOwogCXN0
cnVjdCBtZWdhc2FzX2luc3RhbmNlICppbnN0YW5jZTsKIAlzdHJ1Y3QgbWVnYXNhc19jbWRfZnVz
aW9uICpjbWRfZnVzaW9uOwogCXN0cnVjdCBmdXNpb25fY29udGV4dCAqZnVzaW9uOwpAQCAtMjI3
NiwyOCArMjM0NiwzOSBAQAogCWluc3RhbmNlID0gKHN0cnVjdCBtZWdhc2FzX2luc3RhbmNlICop
c2hvc3QtPmhvc3RkYXRhOwogCWZ1c2lvbiA9IGluc3RhbmNlLT5jdHJsX2NvbnRleHQ7CiAKKwlt
dXRleF9sb2NrKCZpbnN0YW5jZS0+cmVzZXRfbXV0ZXgpOworCiAJaWYgKGluc3RhbmNlLT5hZHBy
ZWNvdmVyeSA9PSBNRUdBU0FTX0hXX0NSSVRJQ0FMX0VSUk9SKSB7CiAJCXByaW50ayhLRVJOX1dB
Uk5JTkcgIm1lZ2FyYWlkX3NhczogSGFyZHdhcmUgY3JpdGljYWwgZXJyb3IsICIKLQkJICAgICAg
ICJyZXR1cm5pbmcgRkFJTEVELlxuIik7CisJCSAgICAgICAicmV0dXJuaW5nIEZBSUxFRCBmb3Ig
c2NzaSVkLlxuIiwKKwkJCWluc3RhbmNlLT5ob3N0LT5ob3N0X25vKTsKIAkJcmV0dXJuIEZBSUxF
RDsKIAl9CiAKLQltdXRleF9sb2NrKCZpbnN0YW5jZS0+cmVzZXRfbXV0ZXgpOworCWlmIChpbnN0
YW5jZS0+cmVxdWVzdG9ySWQgJiYgIWluc3RhbmNlLT5za2lwX2hlYXJ0YmVhdF90aW1lcl9kZWwp
CisJCWRlbF90aW1lcl9zeW5jKCZpbnN0YW5jZS0+c3Jpb3ZfaGVhcnRiZWF0X3RpbWVyKTsKIAlz
ZXRfYml0KE1FR0FTQVNfRlVTSU9OX0lOX1JFU0VULCAmaW5zdGFuY2UtPnJlc2V0X2ZsYWdzKTsK
LQlpbnN0YW5jZS0+YWRwcmVjb3ZlcnkgPSBNRUdBU0FTX0FEUFJFU0VUX1NNX0lORkFVTFQ7CisJ
aW5zdGFuY2UtPmFkcHJlY292ZXJ5ID0gTUVHQVNBU19BRFBSRVNFVF9TTV9QT0xMSU5HOwogCWlu
c3RhbmNlLT5pbnN0YW5jZXQtPmRpc2FibGVfaW50cihpbnN0YW5jZSk7CiAJbXNsZWVwKDEwMDAp
OwogCiAJLyogRmlyc3QgdHJ5IHdhaXRpbmcgZm9yIGNvbW1hbmRzIHRvIGNvbXBsZXRlICovCi0J
aWYgKG1lZ2FzYXNfd2FpdF9mb3Jfb3V0c3RhbmRpbmdfZnVzaW9uKGluc3RhbmNlKSkgeworCWlm
IChtZWdhc2FzX3dhaXRfZm9yX291dHN0YW5kaW5nX2Z1c2lvbihpbnN0YW5jZSwgaW90aW1lb3V0
LAorCQkJCQkJJmNvbnZlcnQpKSB7CisJCWluc3RhbmNlLT5hZHByZWNvdmVyeSA9IE1FR0FTQVNf
QURQUkVTRVRfU01fSU5GQVVMVDsKIAkJcHJpbnRrKEtFUk5fV0FSTklORyAibWVnYXJhaWRfc2Fz
OiByZXNldHRpbmcgZnVzaW9uICIKLQkJICAgICAgICJhZGFwdGVyLlxuIik7CisJCSAgICAgICAi
YWRhcHRlciBzY3NpJWQuXG4iLCBpbnN0YW5jZS0+aG9zdC0+aG9zdF9ubyk7CisJCWlmIChjb252
ZXJ0KQorCQkJaW90aW1lb3V0ID0gMDsKKwogCQkvKiBOb3cgcmV0dXJuIGNvbW1hbmRzIGJhY2sg
dG8gdGhlIE9TICovCiAJCWZvciAoaSA9IDAgOyBpIDwgaW5zdGFuY2UtPm1heF9md19jbWRzOyBp
KyspIHsKIAkJCWNtZF9mdXNpb24gPSBmdXNpb24tPmNtZF9saXN0W2ldOwogCQkJaWYgKGNtZF9m
dXNpb24tPnNjbWQpIHsKIAkJCQlzY3NpX2RtYV91bm1hcChjbWRfZnVzaW9uLT5zY21kKTsKLQkJ
CQljbWRfZnVzaW9uLT5zY21kLT5yZXN1bHQgPSAoRElEX1JFU0VUIDw8IDE2KTsKKwkJCQljbWRf
ZnVzaW9uLT5zY21kLT5yZXN1bHQgPQorCQkJCQltZWdhc2FzX2NoZWNrX21waW9fcGF0aHMoaW5z
dGFuY2UsCisJCQkJCQkJCSBjbWRfZnVzaW9uLT5zY21kKTsKIAkJCQljbWRfZnVzaW9uLT5zY21k
LT5zY3NpX2RvbmUoY21kX2Z1c2lvbi0+c2NtZCk7CiAJCQkJbWVnYXNhc19yZXR1cm5fY21kX2Z1
c2lvbihpbnN0YW5jZSwgY21kX2Z1c2lvbik7CiAJCQkJYXRvbWljX2RlYygmaW5zdGFuY2UtPmZ3
X291dHN0YW5kaW5nKTsKQEAgLTIzMTIsMTMgKzIzOTMsNjcgQEAKIAkJICAgIChhYnNfc3RhdGUg
PT0gTUZJX1NUQVRFX0ZBVUxUICYmICFyZXNldF9hZGFwdGVyKSkgewogCQkJLyogUmVzZXQgbm90
IHN1cHBvcnRlZCwga2lsbCBhZGFwdGVyICovCiAJCQlwcmludGsoS0VSTl9XQVJOSU5HICJtZWdh
cmFpZF9zYXM6IFJlc2V0IG5vdCBzdXBwb3J0ZWQiCi0JCQkgICAgICAgIiwga2lsbGluZyBhZGFw
dGVyLlxuIik7CisJCQkgICAgICAgIiwga2lsbGluZyBhZGFwdGVyIHNjc2klZC5cbiIsCisJCQkJ
aW5zdGFuY2UtPmhvc3QtPmhvc3Rfbm8pOwogCQkJbWVnYXJhaWRfc2FzX2tpbGxfaGJhKGluc3Rh
bmNlKTsKKwkJCWluc3RhbmNlLT5za2lwX2hlYXJ0YmVhdF90aW1lcl9kZWwgPSAxOwogCQkJaW5z
dGFuY2UtPmFkcHJlY292ZXJ5ID0gTUVHQVNBU19IV19DUklUSUNBTF9FUlJPUjsKIAkJCXJldHZh
bCA9IEZBSUxFRDsKIAkJCWdvdG8gb3V0OwogCQl9CiAKKwkJLyogTGV0IFNSLUlPViBWRiAmIFBG
IHN5bmMgdXAgaWYgdGhlcmUgd2FzIGEgSEIgZmFpbHVyZSAqLworCQlpZiAoaW5zdGFuY2UtPnJl
cXVlc3RvcklkICYmICFpb3RpbWVvdXQpIHsKKwkJCW1zbGVlcChNRUdBU0FTX09DUl9TRVRUTEVf
VElNRV9WRik7CisJCQkvKiBMb29rIGZvciBhIGxhdGUgSEIgdXBkYXRlIGFmdGVyIFZGIHNldHRs
ZSB0aW1lICovCisJCQlpZiAoYWJzX3N0YXRlID09IE1GSV9TVEFURV9PUEVSQVRJT05BTCAmJgor
CQkJICAgIChpbnN0YW5jZS0+aGJfaG9zdF9tZW0tPkhCLmZ3Q291bnRlciAhPQorCQkJICAgICBp
bnN0YW5jZS0+aGJfaG9zdF9tZW0tPkhCLmRyaXZlckNvdW50ZXIpKSB7CisJCQkJCWluc3RhbmNl
LT5oYl9ob3N0X21lbS0+SEIuZHJpdmVyQ291bnRlciA9CisJCQkJCQlpbnN0YW5jZS0+aGJfaG9z
dF9tZW0tPkhCLmZ3Q291bnRlcjsKKwkJCQkJcHJpbnRrKEtFUk5fV0FSTklORyAibWVnYXNhczog
U1ItSU9WOiIKKwkJCQkJICAgICAgICJMYXRlIEZXIGhlYXJ0YmVhdCB1cGRhdGUgZm9yICIKKwkJ
CQkJICAgICAgICJzY3NpJWQuXG4iLAorCQkJCQkgICAgICAgaW5zdGFuY2UtPmhvc3QtPmhvc3Rf
bm8pOworCQkJfSBlbHNlIHsKKwkJCQkvKiBJbiBWRiBtb2RlLCBmaXJzdCBwb2xsIGZvciBGVyBy
ZWFkeSAqLworCQkJCWZvciAoaSA9IDA7CisJCQkJICAgICBpIDwgKE1FR0FTQVNfUkVTRVRfV0FJ
VF9USU1FICogMTAwMCk7CisJCQkJICAgICBpICs9IDIwKSB7CisJCQkJCXN0YXR1c19yZWcgPQor
CQkJCQkJaW5zdGFuY2UtPmluc3RhbmNldC0+CisJCQkJCQlyZWFkX2Z3X3N0YXR1c19yZWcoCisJ
CQkJCQkJaW5zdGFuY2UtPnJlZ19zZXQpOworCQkJCQlhYnNfc3RhdGUgPSBzdGF0dXNfcmVnICYK
KwkJCQkJCU1GSV9TVEFURV9NQVNLOworCQkJCQlpZiAoYWJzX3N0YXRlID09IE1GSV9TVEFURV9S
RUFEWSkgeworCQkJCQkJcHJpbnRrKEtFUk5fV0FSTklORyAibWVnYXNhcyIKKwkJCQkJCSAgICAg
ICAiOiBTUi1JT1Y6IEZXIHdhcyBmb3VuZCIKKwkJCQkJCSAgICAgICAidG8gYmUgaW4gcmVhZHkg
c3RhdGUgIgorCQkJCQkJICAgICAgICJmb3Igc2NzaSVkLlxuIiwKKwkJCQkJCSAgICAgICBpbnN0
YW5jZS0+aG9zdC0+aG9zdF9ubyk7CisJCQkJCQlicmVhazsKKwkJCQkJfQorCQkJCQltc2xlZXAo
MjApOworCQkJCX0KKwkJCQlpZiAoYWJzX3N0YXRlICE9IE1GSV9TVEFURV9SRUFEWSkgeworCQkJ
CQlwcmludGsoS0VSTl9XQVJOSU5HICJtZWdhc2FzOiBTUi1JT1Y6ICIKKwkJCQkJICAgICAgICJG
VyBub3QgaW4gcmVhZHkgc3RhdGUgYWZ0ZXIgJWQiCisJCQkJCSAgICAgICAiIHNlY29uZHMgZm9y
IHNjc2klZCwgc3RhdHVzX3JlZyA9ICIKKwkJCQkJICAgICAgICIweCV4LlxuIiwKKwkJCQkJICAg
ICAgIE1FR0FTQVNfUkVTRVRfV0FJVF9USU1FLAorCQkJCQkgICAgICAgaW5zdGFuY2UtPmhvc3Qt
Pmhvc3Rfbm8sCisJCQkJCSAgICAgICBzdGF0dXNfcmVnKTsKKwkJCQkJbWVnYXJhaWRfc2FzX2tp
bGxfaGJhKGluc3RhbmNlKTsKKwkJCQkJaW5zdGFuY2UtPnNraXBfaGVhcnRiZWF0X3RpbWVyX2Rl
bCA9IDE7CisJCQkJCWluc3RhbmNlLT5hZHByZWNvdmVyeSA9CisJCQkJCQlNRUdBU0FTX0hXX0NS
SVRJQ0FMX0VSUk9SOworCQkJCQlyZXR2YWwgPSBGQUlMRUQ7CisJCQkJCWdvdG8gb3V0OworCQkJ
CX0KKwkJCX0KKwkJfQorCiAJCS8qIE5vdyB0cnkgdG8gcmVzZXQgdGhlIGNoaXAgKi8KIAkJZm9y
IChpID0gMDsgaSA8IE1FR0FTQVNfRlVTSU9OX01BWF9SRVNFVF9UUklFUzsgaSsrKSB7CiAJCQl3
cml0ZWwoTVBJMl9XUlNFUV9GTFVTSF9LRVlfVkFMVUUsCkBAIC0yMzQ1LDcgKzI0ODAsOSBAQAog
CQkJCXJlYWRsKCZpbnN0YW5jZS0+cmVnX3NldC0+ZnVzaW9uX2hvc3RfZGlhZyk7CiAJCQkJaWYg
KHJldHJ5KysgPT0gMTAwKSB7CiAJCQkJCXByaW50ayhLRVJOX1dBUk5JTkcgIm1lZ2FyYWlkX3Nh
czogIgotCQkJCQkgICAgICAgIkhvc3QgZGlhZyB1bmxvY2sgZmFpbGVkIVxuIik7CisJCQkJCSAg
ICAgICAiSG9zdCBkaWFnIHVubG9jayBmYWlsZWQhICIKKwkJCQkJICAgICAgICJmb3Igc2NzaSVk
XG4iLAorCQkJCQkJaW5zdGFuY2UtPmhvc3QtPmhvc3Rfbm8pOwogCQkJCQlicmVhazsKIAkJCQl9
CiAJCQl9CkBAIC0yMzY3LDcgKzI1MDQsOCBAQAogCQkJCWlmIChyZXRyeSsrID09IDEwMDApIHsK
IAkJCQkJcHJpbnRrKEtFUk5fV0FSTklORyAibWVnYXJhaWRfc2FzOiAiCiAJCQkJCSAgICAgICAi
RGlhZyByZXNldCBhZGFwdGVyIG5ldmVyICIKLQkJCQkJICAgICAgICJjbGVhcmVkIVxuIik7CisJ
CQkJCSAgICAgICAiY2xlYXJlZCBmb3Igc2NzaSVkIVxuIiwKKwkJCQkJCWluc3RhbmNlLT5ob3N0
LT5ob3N0X25vKTsKIAkJCQkJYnJlYWs7CiAJCQkJfQogCQkJfQpAQCAtMjM4OSwyOSArMjUyNywy
OSBAQAogCQkJaWYgKGFic19zdGF0ZSA8PSBNRklfU1RBVEVfRldfSU5JVCkgewogCQkJCXByaW50
ayhLRVJOX1dBUk5JTkcgIm1lZ2FyYWlkX3NhczogZmlybXdhcmUgIgogCQkJCSAgICAgICAic3Rh
dGUgPCBNRklfU1RBVEVfRldfSU5JVCwgc3RhdGUgPSAiCi0JCQkJICAgICAgICIweCV4XG4iLCBh
YnNfc3RhdGUpOworCQkJCSAgICAgICAiMHgleCBmb3Igc2NzaSVkXG4iLCBhYnNfc3RhdGUsCisJ
CQkJCWluc3RhbmNlLT5ob3N0LT5ob3N0X25vKTsKIAkJCQljb250aW51ZTsKIAkJCX0KIAogCQkJ
LyogV2FpdCBmb3IgRlcgdG8gYmVjb21lIHJlYWR5ICovCiAJCQlpZiAobWVnYXNhc190cmFuc2l0
aW9uX3RvX3JlYWR5KGluc3RhbmNlLCAxKSkgewogCQkJCXByaW50ayhLRVJOX1dBUk5JTkcgIm1l
Z2FyYWlkX3NhczogRmFpbGVkIHRvICIKLQkJCQkgICAgICAgInRyYW5zaXRpb24gY29udHJvbGxl
ciB0byByZWFkeS5cbiIpOworCQkJCSAgICAgICAidHJhbnNpdGlvbiBjb250cm9sbGVyIHRvIHJl
YWR5ICIKKwkJCQkgICAgICAgImZvciBzY3NpJWQuXG4iLAorCQkJCSAgICAgICBpbnN0YW5jZS0+
aG9zdC0+aG9zdF9ubyk7CiAJCQkJY29udGludWU7CiAJCQl9CiAKIAkJCW1lZ2FzYXNfcmVzZXRf
cmVwbHlfZGVzYyhpbnN0YW5jZSk7CiAJCQlpZiAobWVnYXNhc19pb2NfaW5pdF9mdXNpb24oaW5z
dGFuY2UpKSB7CiAJCQkJcHJpbnRrKEtFUk5fV0FSTklORyAibWVnYXJhaWRfc2FzOiAiCi0JCQkJ
ICAgICAgICJtZWdhc2FzX2lvY19pbml0X2Z1c2lvbigpIGZhaWxlZCFcbiIpOworCQkJCSAgICAg
ICAibWVnYXNhc19pb2NfaW5pdF9mdXNpb24oKSBmYWlsZWQhIgorCQkJCSAgICAgICAiIGZvciBz
Y3NpJWRcbiIsCisJCQkJICAgICAgIGluc3RhbmNlLT5ob3N0LT5ob3N0X25vKTsKIAkJCQljb250
aW51ZTsKIAkJCX0KIAotCQkJY2xlYXJfYml0KE1FR0FTQVNfRlVTSU9OX0lOX1JFU0VULAotCQkJ
CSAgJmluc3RhbmNlLT5yZXNldF9mbGFncyk7Ci0JCQlpbnN0YW5jZS0+aW5zdGFuY2V0LT5lbmFi
bGVfaW50cihpbnN0YW5jZSk7Ci0JCQlpbnN0YW5jZS0+YWRwcmVjb3ZlcnkgPSBNRUdBU0FTX0hC
QV9PUEVSQVRJT05BTDsKLQogCQkJLyogUmUtZmlyZSBtYW5hZ2VtZW50IGNvbW1hbmRzICovCiAJ
CQlmb3IgKGogPSAwIDsgaiA8IGluc3RhbmNlLT5tYXhfZndfY21kczsgaisrKSB7CiAJCQkJY21k
X2Z1c2lvbiA9IGZ1c2lvbi0+Y21kX2xpc3Rbal07CkBAIC0yNDM1LDcgKzI1NzMsOCBAQAogCQkJ
CQkJaWYgKCFyZXFfZGVzYykgewogCQkJCQkJCXByaW50ayhLRVJOX1dBUk5JTkcKIAkJCQkJCQkg
ICAgICAgInJlcV9kZXNjIE5VTEwiCi0JCQkJCQkJICAgICAgICJcbiIpOworCQkJCQkJCSAgICAg
ICAiIGZvciBzY3NpJWRcbiIsCisJCQkJCQkJCWluc3RhbmNlLT5ob3N0LT5ob3N0X25vKTsKIAkJ
CQkJCQkvKiBSZXR1cm4gbGVha2VkIE1QVAogCQkJCQkJCSAgIGZyYW1lICovCiAJCQkJCQkJbWVn
YXNhc19yZXR1cm5fY21kX2Z1c2lvbihpbnN0YW5jZSwgY21kX2Z1c2lvbik7CkBAIC0yNDUzLDYg
KzI1OTIsMTEgQEAKIAkJCQl9CiAJCQl9CiAKKwkJCWNsZWFyX2JpdChNRUdBU0FTX0ZVU0lPTl9J
Tl9SRVNFVCwKKwkJCQkgICZpbnN0YW5jZS0+cmVzZXRfZmxhZ3MpOworCQkJaW5zdGFuY2UtPmlu
c3RhbmNldC0+ZW5hYmxlX2ludHIoaW5zdGFuY2UpOworCQkJaW5zdGFuY2UtPmFkcHJlY292ZXJ5
ID0gTUVHQVNBU19IQkFfT1BFUkFUSU9OQUw7CisKIAkJCS8qIFJlc2V0IGxvYWQgYmFsYW5jZSBp
bmZvICovCiAJCQltZW1zZXQoZnVzaW9uLT5sb2FkX2JhbGFuY2VfaW5mbywgMCwKIAkJCSAgICAg
ICBzaXplb2Yoc3RydWN0IExEX0xPQURfQkFMQU5DRV9JTkZPKQpAQCAtMjQ2MSwxOSArMjYwNSwz
OSBAQAogCQkJaWYgKCFtZWdhc2FzX2dldF9tYXBfaW5mbyhpbnN0YW5jZSkpCiAJCQkJbWVnYXNh
c19zeW5jX21hcF9pbmZvKGluc3RhbmNlKTsKIAorCQkJLyogUmVzdGFydCBTUi1JT1YgaGVhcnRi
ZWF0ICovCisJCQlpZiAoaW5zdGFuY2UtPnJlcXVlc3RvcklkKSB7CisJCQkJaWYgKCFtZWdhc2Fz
X3NyaW92X3N0YXJ0X2hlYXJ0YmVhdChpbnN0YW5jZSwgMCkpCisJCQkJCW1lZ2FzYXNfc3RhcnRf
dGltZXIoaW5zdGFuY2UsCisJCQkJCQkJICAgICZpbnN0YW5jZS0+c3Jpb3ZfaGVhcnRiZWF0X3Rp
bWVyLAorCQkJCQkJCSAgICBtZWdhc2FzX3NyaW92X2hlYXJ0YmVhdF9oYW5kbGVyLAorCQkJCQkJ
CSAgICBNRUdBU0FTX1NSSU9WX0hFQVJUQkVBVF9JTlRFUlZBTF9WRik7CisJCQkJZWxzZQorCQkJ
CQlpbnN0YW5jZS0+c2tpcF9oZWFydGJlYXRfdGltZXJfZGVsID0gMTsKKwkJCX0KKwogCQkJLyog
QWRhcHRlciByZXNldCBjb21wbGV0ZWQgc3VjY2Vzc2Z1bGx5ICovCiAJCQlwcmludGsoS0VSTl9X
QVJOSU5HICJtZWdhcmFpZF9zYXM6IFJlc2V0ICIKLQkJCSAgICAgICAic3VjY2Vzc2Z1bC5cbiIp
OworCQkJICAgICAgICJzdWNjZXNzZnVsIGZvciBzY3NpJWQuXG4iLAorCQkJCWluc3RhbmNlLT5o
b3N0LT5ob3N0X25vKTsKIAkJCXJldHZhbCA9IFNVQ0NFU1M7CiAJCQlnb3RvIG91dDsKIAkJfQog
CQkvKiBSZXNldCBmYWlsZWQsIGtpbGwgdGhlIGFkYXB0ZXIgKi8KIAkJcHJpbnRrKEtFUk5fV0FS
TklORyAibWVnYXJhaWRfc2FzOiBSZXNldCBmYWlsZWQsIGtpbGxpbmcgIgotCQkgICAgICAgImFk
YXB0ZXIuXG4iKTsKKwkJICAgICAgICJhZGFwdGVyIHNjc2klZC5cbiIsIGluc3RhbmNlLT5ob3N0
LT5ob3N0X25vKTsKIAkJbWVnYXJhaWRfc2FzX2tpbGxfaGJhKGluc3RhbmNlKTsKKwkJaW5zdGFu
Y2UtPnNraXBfaGVhcnRiZWF0X3RpbWVyX2RlbCA9IDE7CiAJCWluc3RhbmNlLT5hZHByZWNvdmVy
eSA9IE1FR0FTQVNfSFdfQ1JJVElDQUxfRVJST1I7CiAJCXJldHZhbCA9IEZBSUxFRDsKIAl9IGVs
c2UgeworCQkvKiBGb3IgVkY6IFJlc3RhcnQgSEIgdGltZXIgaWYgd2UgZGlkbid0IE9DUiAqLwor
CQlpZiAoaW5zdGFuY2UtPnJlcXVlc3RvcklkKSB7CisJCQltZWdhc2FzX3N0YXJ0X3RpbWVyKGlu
c3RhbmNlLAorCQkJCQkgICAgJmluc3RhbmNlLT5zcmlvdl9oZWFydGJlYXRfdGltZXIsCisJCQkJ
CSAgICBtZWdhc2FzX3NyaW92X2hlYXJ0YmVhdF9oYW5kbGVyLAorCQkJCQkgICAgTUVHQVNBU19T
UklPVl9IRUFSVEJFQVRfSU5URVJWQUxfVkYpOworCQl9CiAJCWNsZWFyX2JpdChNRUdBU0FTX0ZV
U0lPTl9JTl9SRVNFVCwgJmluc3RhbmNlLT5yZXNldF9mbGFncyk7CiAJCWluc3RhbmNlLT5pbnN0
YW5jZXQtPmVuYWJsZV9pbnRyKGluc3RhbmNlKTsKIAkJaW5zdGFuY2UtPmFkcHJlY292ZXJ5ID0g
TUVHQVNBU19IQkFfT1BFUkFUSU9OQUw7CkBAIC0yNDkwLDcgKzI2NTQsNyBAQAogCXN0cnVjdCBt
ZWdhc2FzX2luc3RhbmNlICppbnN0YW5jZSA9CiAJCWNvbnRhaW5lcl9vZih3b3JrLCBzdHJ1Y3Qg
bWVnYXNhc19pbnN0YW5jZSwgd29ya19pbml0KTsKIAotCW1lZ2FzYXNfcmVzZXRfZnVzaW9uKGlu
c3RhbmNlLT5ob3N0KTsKKwltZWdhc2FzX3Jlc2V0X2Z1c2lvbihpbnN0YW5jZS0+aG9zdCwgMCk7
CiB9CiAKIHN0cnVjdCBtZWdhc2FzX2luc3RhbmNlX3RlbXBsYXRlIG1lZ2FzYXNfaW5zdGFuY2Vf
dGVtcGxhdGVfZnVzaW9uID0gewpkaWZmIC1OYXVyIHNjc2ktbWlzYy5vbGQvZHJpdmVycy9zY3Np
L21lZ2FyYWlkL21lZ2FyYWlkX3Nhc19mdXNpb24uaCBzY3NpLW1pc2MubmV3L2RyaXZlcnMvc2Nz
aS9tZWdhcmFpZC9tZWdhcmFpZF9zYXNfZnVzaW9uLmgKLS0tIHNjc2ktbWlzYy5vbGQvZHJpdmVy
cy9zY3NpL21lZ2FyYWlkL21lZ2FyYWlkX3Nhc19mdXNpb24uaAkyMDE0LTAzLTA5IDE0OjUzOjA1
LjAwMDAwMDAwMCAtMDcwMAorKysgc2NzaS1taXNjLm5ldy9kcml2ZXJzL3Njc2kvbWVnYXJhaWQv
bWVnYXJhaWRfc2FzX2Z1c2lvbi5oCTIwMTQtMDMtMTAgMDA6Mjg6MzQuOTM0ODU2NjE3IC0wNzAw
CkBAIC00ODUsNiArNDg1LDkgQEAKICNkZWZpbmUgTUFYX1BIWVNJQ0FMX0RFVklDRVMgMjU2CiAj
ZGVmaW5lIE1BWF9SQUlETUFQX1BIWVNJQ0FMX0RFVklDRVMgKE1BWF9QSFlTSUNBTF9ERVZJQ0VT
KQogI2RlZmluZSBNUl9EQ01EX0xEX01BUF9HRVRfSU5GTyAgICAgICAgICAgICAweDAzMDBlMTAx
CisjZGVmaW5lIE1SX0RDTURfQ1RSTF9TSEFSRURfSE9TVF9NRU1fQUxMT0MgIDB4MDEwZTg0ODUg
ICAvKiBTUi1JT1YgSEIgYWxsb2MqLworI2RlZmluZSBNUl9EQ01EX0xEX1ZGX01BUF9HRVRfQUxM
X0xEU18xMTEgICAweDAzMjAwMjAwCisjZGVmaW5lIE1SX0RDTURfTERfVkZfTUFQX0dFVF9BTExf
TERTICAgICAgIDB4MDMxNTAyMDAKIAogc3RydWN0IE1SX0RFVl9IQU5ETEVfSU5GTyB7CiAJdTE2
ICAgICBjdXJEZXZIZGw7CmRpZmYgLU5hdXIgc2NzaS1taXNjLm9sZC9kcml2ZXJzL3Njc2kvbWVn
YXJhaWQvbWVnYXJhaWRfc2FzLmggc2NzaS1taXNjLm5ldy9kcml2ZXJzL3Njc2kvbWVnYXJhaWQv
bWVnYXJhaWRfc2FzLmgKLS0tIHNjc2ktbWlzYy5vbGQvZHJpdmVycy9zY3NpL21lZ2FyYWlkL21l
Z2FyYWlkX3Nhcy5oCTIwMTQtMDMtMDkgMjE6MDY6NTYuNDk5ODU2MTMwIC0wNzAwCisrKyBzY3Np
LW1pc2MubmV3L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9zYXMuaAkyMDE0LTAzLTEw
IDAwOjI4OjA0Ljk5Mzg1NjEwNiAtMDcwMApAQCAtNDgsNiArNDgsNyBAQAogI2RlZmluZQlQQ0lf
REVWSUNFX0lEX0xTSV9TQVMwMDczU0tJTk5ZCQkweDAwNzMKICNkZWZpbmUJUENJX0RFVklDRV9J
RF9MU0lfU0FTMDA3MVNLSU5OWQkJMHgwMDcxCiAjZGVmaW5lCVBDSV9ERVZJQ0VfSURfTFNJX0ZV
U0lPTgkJMHgwMDViCisjZGVmaW5lIFBDSV9ERVZJQ0VfSURfTFNJX1BMQVNNQQkJMHgwMDJmCiAj
ZGVmaW5lIFBDSV9ERVZJQ0VfSURfTFNJX0lOVkFERVIJCTB4MDA1ZAogI2RlZmluZSBQQ0lfREVW
SUNFX0lEX0xTSV9GVVJZCQkJMHgwMDVmCiAKQEAgLTU1OSw3ICs1NjAsOCBAQAogCQl1OCBQQ0lF
OjE7CiAJCXU4IGlTQ1NJOjE7CiAJCXU4IFNBU18zRzoxOwotCQl1OCByZXNlcnZlZF8wOjQ7CisJ
CXU4IFNSSU9WOjE7CisJCXU4IHJlc2VydmVkXzA6MzsKIAkJdTggcmVzZXJ2ZWRfMVs2XTsKIAkJ
dTggcG9ydF9jb3VudDsKIAkJdTY0IHBvcnRfYWRkcls4XTsKQEAgLTgzOSw3ICs4NDEsMTIgQEAK
IAogCXN0cnVjdCB7ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAvKjdBNGggKi8KICNp
ZiAgIGRlZmluZWQoX19CSUdfRU5ESUFOX0JJVEZJRUxEKQotCQl1MzIgICAgIHJlc2VydmVkOjEx
OworCQl1MzIgICAgIHJlc2VydmVkOjU7CisJCXUzMglhY3RpdmVQYXNzaXZlOjI7CisJCXUzMglz
dXBwb3J0Q29uZmlnQXV0b0JhbGFuY2U6MTsKKwkJdTMyCW1waW86MTsKKwkJdTMyCXN1cHBvcnRE
YXRhTERvblNTQ0FycmF5OjE7CisJCXUzMglzdXBwb3J0UG9pbnRJblRpbWVQcm9ncmVzczoxOwog
CQl1MzIgICAgIHN1cHBvcnRVbmV2ZW5TcGFuczoxOwogCQl1MzIgICAgIGRlZGljYXRlZEhvdFNw
YXJlc0xpbWl0ZWQ6MTsKIAkJdTMyICAgICBoZWFkbGVzc01vZGU6MTsKQEAgLTg4Niw3ICs4OTMs
MTIgQEAKIAogCiAJCXUzMiAgICAgc3VwcG9ydFVuZXZlblNwYW5zOjE7Ci0JCXUzMiAgICAgcmVz
ZXJ2ZWQ6MTE7CisJCXUzMglzdXBwb3J0UG9pbnRJblRpbWVQcm9ncmVzczoxOworCQl1MzIJc3Vw
cG9ydERhdGFMRG9uU1NDQXJyYXk6MTsKKwkJdTMyCW1waW86MTsKKwkJdTMyCXN1cHBvcnRDb25m
aWdBdXRvQmFsYW5jZToxOworCQl1MzIJYWN0aXZlUGFzc2l2ZToyOworCQl1MzIgICAgIHJlc2Vy
dmVkOjU7CiAjZW5kaWYKIAl9IGFkYXB0ZXJPcGVyYXRpb25zMjsKIApAQCAtOTE0LDggKzkyNiwx
NCBAQAogCX0gY2x1c3RlcjsKIAogCWNoYXIgY2x1c3RlcklkWzE2XTsgICAgICAgICAgICAgICAg
ICAgICAvKjdENGggKi8KKwlzdHJ1Y3QgeworCQl1OCAgbWF4VkZzU3VwcG9ydGVkOyAgICAgICAg
ICAgIC8qMHg3RTQqLworCQl1OCAgbnVtVkZzRW5hYmxlZDsgICAgICAgICAgICAgIC8qMHg3RTUq
LworCQl1OCAgcmVxdWVzdG9ySWQ7ICAgICAgICAgICAgICAgIC8qMHg3RTYgMDpQRiwgMTpWRjEs
IDI6VkYyKi8KKwkJdTggIHJlc2VydmVkOyAgICAgICAgICAgICAgICAgICAvKjB4N0U3Ki8KKwl9
IGlvdjsKIAotCXU4ICAgICAgICAgIHBhZFsweDgwMC0weDdFNF07ICAgICAgICAgICAvKjdFNCAq
LworCXU4ICAgICAgICAgIHBhZFsweDgwMC0weDdFOF07ICAgICAgICAgICAvKjB4N0U4IHBhZCB0
byAyayAqLwogfSBfX3BhY2tlZDsKIAogLyoKQEAgLTk4Niw3ICsxMDA0LDkgQEAKIAogI2RlZmlu
ZSBNRklfT0JfSU5UUl9TVEFUVVNfTUFTSwkJCTB4MDAwMDAwMDIKICNkZWZpbmUgTUZJX1BPTExf
VElNRU9VVF9TRUNTCQkJNjAKLQorI2RlZmluZSBNRUdBU0FTX1NSSU9WX0hFQVJUQkVBVF9JTlRF
UlZBTF9WRgkoNSAqIEhaKQorI2RlZmluZSBNRUdBU0FTX09DUl9TRVRUTEVfVElNRV9WRgkJKDEw
MDAgKiAzMCkKKyNkZWZpbmUgTUVHQVNBU19ST1VUSU5FX1dBSVRfVElNRV9WRgkJMzAwCiAjZGVm
aW5lIE1GSV9SRVBMWV8xMDc4X01FU1NBR0VfSU5URVJSVVBUCTB4ODAwMDAwMDAKICNkZWZpbmUg
TUZJX1JFUExZX0dFTjJfTUVTU0FHRV9JTlRFUlJVUFQJMHgwMDAwMDAwMQogI2RlZmluZSBNRklf
R0VOMl9FTkFCTEVfSU5URVJSVVBUX01BU0sJCSgweDAwMDAwMDAxIHwgMHgwMDAwMDAwNCkKQEAg
LTE1MjksNiArMTU0OSwxMiBAQAogCWRtYV9hZGRyX3QgcHJvZHVjZXJfaDsKIAl1MzIgKmNvbnN1
bWVyOwogCWRtYV9hZGRyX3QgY29uc3VtZXJfaDsKKwlzdHJ1Y3QgTVJfTERfVkZfQUZGSUxJQVRJ
T04gKnZmX2FmZmlsaWF0aW9uOworCWRtYV9hZGRyX3QgdmZfYWZmaWxpYXRpb25faDsKKwlzdHJ1
Y3QgTVJfTERfVkZfQUZGSUxJQVRJT05fMTExICp2Zl9hZmZpbGlhdGlvbl8xMTE7CisJZG1hX2Fk
ZHJfdCB2Zl9hZmZpbGlhdGlvbl8xMTFfaDsKKwlzdHJ1Y3QgTVJfQ1RSTF9IQl9IT1NUX01FTSAq
aGJfaG9zdF9tZW07CisJZG1hX2FkZHJfdCBoYl9ob3N0X21lbV9oOwogCiAJdTMyICpyZXBseV9x
dWV1ZTsKIAlkbWFfYWRkcl90IHJlcGx5X3F1ZXVlX2g7CkBAIC0xNjA0LDEwICsxNjMwLDczIEBA
CiAJdW5zaWduZWQgbG9uZyBiYXI7CiAJbG9uZyByZXNldF9mbGFnczsKIAlzdHJ1Y3QgbXV0ZXgg
cmVzZXRfbXV0ZXg7CisJc3RydWN0IHRpbWVyX2xpc3Qgc3Jpb3ZfaGVhcnRiZWF0X3RpbWVyOwor
CWNoYXIgc2tpcF9oZWFydGJlYXRfdGltZXJfZGVsOworCXU4IHJlcXVlc3RvcklkOworCXU2NCBp
bml0aWF0b3Jfc2FzX2FkZHJlc3M7CisJdTY0IGxkX3Nhc19hZGRyZXNzWzY0XTsKKwljaGFyIFBs
YXNtYUZXMTExOworCWNoYXIgbXBpbzsKIAlpbnQgdGhyb3R0bGVxdWV1ZWRlcHRoOwogCXU4IG1h
c2tfaW50ZXJydXB0czsKIAl1OCBpc19pbXI7CiB9Oworc3RydWN0IE1SX0xEX1ZGX01BUCB7CisJ
dTMyIHNpemU7CisJdW5pb24gTVJfTERfUkVGIHJlZjsKKwl1OCBsZFZmQ291bnQ7CisJdTggcmVz
ZXJ2ZWRbNl07CisJdTggcG9saWN5WzFdOworfTsKKworc3RydWN0IE1SX0xEX1ZGX0FGRklMSUFU
SU9OIHsKKwl1MzIgc2l6ZTsKKwl1OCBsZENvdW50OworCXU4IHZmQ291bnQ7CisJdTggdGhpc1Zm
OworCXU4IHJlc2VydmVkWzldOworCXN0cnVjdCBNUl9MRF9WRl9NQVAgbWFwWzFdOworfTsKKwor
LyogUGxhc21hIDEuMTEgRlcgYmFja3dhcmQgY29tcGF0aWJpbGl0eSBzdHJ1Y3R1cmVzICovCisj
ZGVmaW5lIElPVl8xMTFfT0ZGU0VUIDB4N0NFCisjZGVmaW5lIE1BWF9WSVJUVUFMX0ZVTkNUSU9O
UyA4CisKK3N0cnVjdCBJT1ZfMTExIHsKKwl1OCBtYXhWRnNTdXBwb3J0ZWQ7CisJdTggbnVtVkZz
RW5hYmxlZDsKKwl1OCByZXF1ZXN0b3JJZDsKKwl1OCByZXNlcnZlZFs1XTsKK307CisKK3N0cnVj
dCBNUl9MRF9WRl9NQVBfMTExIHsKKwl1OCB0YXJnZXRJZDsKKwl1OCByZXNlcnZlZFszXTsKKwl1
OCBwb2xpY3lbTUFYX1ZJUlRVQUxfRlVOQ1RJT05TXTsKK307CisKK3N0cnVjdCBNUl9MRF9WRl9B
RkZJTElBVElPTl8xMTEgeworCXU4IHZkQ291bnQ7CisJdTggdmZDb3VudDsKKwl1OCB0aGlzVmY7
CisJdTggcmVzZXJ2ZWRbNV07CisJc3RydWN0IE1SX0xEX1ZGX01BUF8xMTEgbWFwW01BWF9MT0dJ
Q0FMX0RSSVZFU107Cit9OworCitzdHJ1Y3QgTVJfQ1RSTF9IQl9IT1NUX01FTSB7CisJc3RydWN0
IHsKKwkJdTMyIGZ3Q291bnRlcjsJLyogRmlybXdhcmUgaGVhcnQgYmVhdCBjb3VudGVyICovCisJ
CXN0cnVjdCB7CisJCQl1MzIgZGVidWdtb2RlOjE7IC8qIDE9RmlybXdhcmUgaXMgaW4gZGVidWcg
bW9kZS4KKwkJCQkJICAgIEhlYXJ0IGJlYXQgd2lsbCBub3QgYmUgdXBkYXRlZC4gKi8KKwkJCXUz
MiByZXNlcnZlZDozMTsKKwkJfSBkZWJ1ZzsKKwkJdTMyIHJlc2VydmVkX2Z3WzZdOworCQl1MzIg
ZHJpdmVyQ291bnRlcjsgLyogRHJpdmVyIGhlYXJ0IGJlYXQgY291bnRlci4gIDB4MjAgKi8KKwkJ
dTMyIHJlc2VydmVkX2RyaXZlcls3XTsKKwl9IEhCOworCXU4IHBhZFsweDQwMC0weDQwXTsKK307
CiAKIGVudW0gewogCU1FR0FTQVNfSEJBX09QRVJBVElPTkFMCQkJPSAwLApAQCAtMTYxNSw2ICsx
NzA0LDcgQEAKIAlNRUdBU0FTX0FEUFJFU0VUX1NNX0ZXX1JFU0VUX1NVQ0NFU1MJPSAyLAogCU1F
R0FTQVNfQURQUkVTRVRfU01fT1BFUkFUSU9OQUwJCT0gMywKIAlNRUdBU0FTX0hXX0NSSVRJQ0FM
X0VSUk9SCQk9IDQsCisJTUVHQVNBU19BRFBSRVNFVF9TTV9QT0xMSU5HCQk9IDUsCiAJTUVHQVNB
U19BRFBSRVNFVF9JTlBST0dfU0lHTgkJPSAweERFQURERUFELAogfTsKIAo=
--20cf301af335d6105b04f43d8d79--

From: "Yang, Bo" <Bo.Yang@lsi.com>
Subject: [PATCH 5/10] scsi: megaraid_sas - Fixed load/unload issue and Fire
 the system pd DCDB cmd to MegaRAID SAS FW to get the system PDs
Date: Tue, 5 May 2009 19:24:07 -0600
Message-ID: <4B6A08C587958942AA3002690DD4F8C354F61C55@cosmail02.lsi.com>
References: <4B6A08C587958942AA3002690DD4F8C354F61C50@cosmail02.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755373AbZEFBZL@vger.kernel.org>
In-Reply-To: <4B6A08C587958942AA3002690DD4F8C354F61C50@cosmail02.lsi.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Yang, Bo" <Bo.Yang@lsi.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "akpm@osdl.org" <akpm@osdl.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Austria, Winston" <Winston.Austria@lsi.com>
List-Id: linux-scsi@vger.kernel.org

Fixed the Driver load / Unload issue and Fire the system PD DCDB cmd to MegaRAID SAS FW to get the system PDs List

Signed-off-by Bo Yang<bo.yang@lsi.com>

---
drivers/scsi/megaraid/megaraid_sas.c |  105 +++++++++++++++++++++++++++++++++--
 drivers/scsi/megaraid/megaraid_sas.h |   83 +++++++++++++++++++++++++++
 2 files changed, 183 insertions(+), 5 deletions(-)

diff -rupN linux-2.6.28_orig/drivers/scsi/megaraid/megaraid_sas.c linux-2.6.28_new/drivers/scsi/megaraid/megaraid_sas.c
--- linux-2.6.28_orig/drivers/scsi/megaraid/megaraid_sas.c      2009-05-04 20:21:03.000000000 -0400
+++ linux-2.6.28_new/drivers/scsi/megaraid/megaraid_sas.c       2009-05-04 20:22:17.000000000 -0400
@@ -1686,7 +1686,7 @@ megasas_transition_to_ready(struct megas

                                writel(
                                  MFI_INIT_CLEAR_HANDSHAKE|MFI_INIT_HOTPLUG,
-                                 &instance->reg_set->reserved_0[0]);
+                                 &instance->reg_set->outbound_scratch_pad);
                        } else {
                                writel(
                                    MFI_INIT_CLEAR_HANDSHAKE|MFI_INIT_HOTPLUG,
@@ -1703,7 +1703,7 @@ megasas_transition_to_ready(struct megas
                        (instance->pdev->device ==
                                PCI_DEVICE_ID_LSI_SAS0071SKINNY)) {
                                writel(MFI_INIT_HOTPLUG,
-                               &instance->reg_set->reserved_0[0]);
+                               &instance->reg_set->outbound_scratch_pad);
                        } else
                                writel(MFI_INIT_HOTPLUG,
                                        &instance->reg_set->inbound_doorbell);
@@ -1722,7 +1722,7 @@ megasas_transition_to_ready(struct megas
                                (instance->pdev->device ==
                                PCI_DEVICE_ID_LSI_SAS0071SKINNY)) {
                                writel(MFI_RESET_FLAGS,
-                               &instance->reg_set->reserved_0[0]);
+                               &instance->reg_set->outbound_scratch_pad);
                        } else
                                writel(MFI_RESET_FLAGS,
                                &instance->reg_set->inbound_doorbell);
@@ -2031,6 +2031,97 @@ static int megasas_alloc_cmds(struct meg
        return 0;
 }

+/*
+ * megasas_get_pd_list_info -  Returns FW's pd_list structure
+ * @instance:                          Adapter soft state
+ * @pd_list:                           pd_list structure
+ *
+ * Issues an internal command (DCMD) to get the FW's controller PD
+ * list structure.  This information is mainly used to find out SYSTEM
+ * supported by the FW.
+ */
+static int
+megasas_get_pd_list(struct megasas_instance *instance)
+{
+       int ret = 0, pd_index = 0;
+       struct megasas_cmd *cmd;
+       struct megasas_dcmd_frame *dcmd;
+       struct MR_PD_LIST *ci;
+       struct MR_PD_ADDRESS *pd_addr;
+       dma_addr_t ci_h = 0;
+
+       cmd = megasas_get_cmd(instance);
+
+       if (!cmd) {
+               printk(KERN_DEBUG "megasas (get_pd_list): Failed to get cmd\n");
+               return -ENOMEM;
+       }
+
+       dcmd = &cmd->frame->dcmd;
+
+       ci = pci_alloc_consistent(instance->pdev,
+                 MEGASAS_MAX_PD * sizeof(struct MR_PD_LIST), &ci_h);
+
+       if (!ci) {
+               printk(KERN_DEBUG "Failed to alloc mem for pd_list\n");
+               megasas_return_cmd(instance, cmd);
+               return -ENOMEM;
+       }
+
+       memset(ci, 0, sizeof(*ci));
+       memset(dcmd->mbox.b, 0, MFI_MBOX_SIZE);
+
+       dcmd->mbox.b[0] = MR_PD_QUERY_TYPE_EXPOSED_TO_HOST;
+       dcmd->mbox.b[1] = 0;
+       dcmd->cmd = MFI_CMD_DCMD;
+       dcmd->cmd_status = 0xFF;
+       dcmd->sge_count = 1;
+       dcmd->flags = MFI_FRAME_DIR_READ;
+       dcmd->timeout = 0;
+       dcmd->data_xfer_len = MEGASAS_MAX_PD * sizeof(struct MR_PD_LIST);
+       dcmd->opcode = MR_DCMD_PD_LIST_QUERY;
+       dcmd->sgl.sge32[0].phys_addr = ci_h;
+       dcmd->sgl.sge32[0].length = MEGASAS_MAX_PD * sizeof(struct MR_PD_LIST);
+
+       if (!megasas_issue_polled(instance, cmd)) {
+               ret = 0;
+       } else {
+               ret = -1;
+       }
+
+       /*
+       * the following function will get the instance PD LIST.
+       */
+
+       pd_addr = ci->addr;
+
+       if ( ret == 0 &&
+               (ci->count <
+                 (MEGASAS_MAX_PD_CHANNELS * MEGASAS_MAX_DEV_PER_CHANNEL))) {
+
+               memset(instance->pd_list, 0,
+                       MEGASAS_MAX_PD * sizeof(struct megasas_pd_list));
+
+               for (pd_index = 0; pd_index < ci->count; pd_index++) {
+
+                       instance->pd_list[pd_addr->deviceId].tid        =
+                                                       pd_addr->deviceId;
+                       instance->pd_list[pd_addr->deviceId].driveType  =
+                                                       pd_addr->scsiDevType;
+                       instance->pd_list[pd_addr->deviceId].driveState =
+                                                       MR_PD_STATE_SYSTEM;
+                       pd_addr++;
+               }
+       }
+
+       pci_free_consistent(instance->pdev,
+                               MEGASAS_MAX_PD * sizeof(struct MR_PD_LIST),
+                               ci, ci_h);
+       megasas_return_cmd(instance, cmd);
+
+       return ret;
+}
+
 /**
  * megasas_get_controller_info -       Returns FW's controller structure
  * @instance:                          Adapter soft state
@@ -2310,8 +2401,8 @@ static int megasas_init_mfi(struct megas
        reply_q_sz = context_sz * (instance->max_fw_cmds + 1);

        instance->reply_queue = pci_alloc_consistent(instance->pdev,
-                                                    reply_q_sz,
-                                                    &instance->reply_queue_h);
+                                               reply_q_sz,
+                                               &instance->reply_queue_h);

        if (!instance->reply_queue) {
                printk(KERN_DEBUG "megasas: Out of DMA mem for reply queue\n");
@@ -2321,6 +2412,10 @@ static int megasas_init_mfi(struct megas
        if (megasas_issue_init_mfi(instance))
                goto fail_fw_init;

+       memset(instance->pd_list, 0 ,
+               (MEGASAS_MAX_PD * sizeof(struct megasas_pd_list)));
+       megasas_get_pd_list(instance);
+
        ctrl_info = kmalloc(sizeof(struct megasas_ctrl_info), GFP_KERNEL);

        /*
diff -rupN linux-2.6.28_orig/drivers/scsi/megaraid/megaraid_sas.h linux-2.6.28_new/drivers/scsi/megaraid/megaraid_sas.h
--- linux-2.6.28_orig/drivers/scsi/megaraid/megaraid_sas.h      2009-05-04 20:21:05.000000000 -0400
+++ linux-2.6.28_new/drivers/scsi/megaraid/megaraid_sas.h       2009-05-04 20:00:32.000000000 -0400
@@ -133,6 +133,7 @@
 #define MR_DCMD_CLUSTER                                0x08000000
 #define MR_DCMD_CLUSTER_RESET_ALL              0x08010100
 #define MR_DCMD_CLUSTER_RESET_LD               0x08010200
+#define MR_DCMD_PD_LIST_QUERY                   0x02010100

 #define MR_EVT_CFG_CLEARED                     0x0004

@@ -264,10 +265,89 @@ enum MR_EVT_ARGS {
        MR_EVT_ARGS_STR,
        MR_EVT_ARGS_TIME,
        MR_EVT_ARGS_ECC,
+       MR_EVT_ARGS_LD_PROP,
+       MR_EVT_ARGS_PD_SPARE,
+       MR_EVT_ARGS_PD_INDEX,
+       MR_EVT_ARGS_DIAG_PASS,
+       MR_EVT_ARGS_DIAG_FAIL,
+       MR_EVT_ARGS_PD_LBA_LBA,
+       MR_EVT_ARGS_PORT_PHY,
+       MR_EVT_ARGS_PD_MISSING,
+       MR_EVT_ARGS_PD_ADDRESS,
+       MR_EVT_ARGS_BITMAP,
+       MR_EVT_ARGS_CONNECTOR,
+       MR_EVT_ARGS_PD_PD,
+       MR_EVT_ARGS_PD_FRU,
+       MR_EVT_ARGS_PD_PATHINFO,
+       MR_EVT_ARGS_PD_POWER_STATE,
+       MR_EVT_ARGS_GENERIC,
+};

+/*
+ * define constants for device list query options
+ */
+enum MR_PD_QUERY_TYPE {
+       MR_PD_QUERY_TYPE_ALL                = 0,
+       MR_PD_QUERY_TYPE_STATE              = 1,
+       MR_PD_QUERY_TYPE_POWER_STATE        = 2,
+       MR_PD_QUERY_TYPE_MEDIA_TYPE         = 3,
+       MR_PD_QUERY_TYPE_SPEED              = 4,
+       MR_PD_QUERY_TYPE_EXPOSED_TO_HOST    = 5,
+} __attribute__ ((packed));
+
+enum MR_PD_STATE {
+       MR_PD_STATE_UNCONFIGURED_GOOD   = 0x00,
+       MR_PD_STATE_UNCONFIGURED_BAD    = 0x01,
+       MR_PD_STATE_HOT_SPARE           = 0x02,
+       MR_PD_STATE_OFFLINE             = 0x10,
+       MR_PD_STATE_FAILED              = 0x11,
+       MR_PD_STATE_REBUILD             = 0x14,
+       MR_PD_STATE_ONLINE              = 0x18,
+       MR_PD_STATE_COPYBACK            = 0x20,
+       MR_PD_STATE_SYSTEM              = 0x40,
 };

 /*
+ * defines the physical drive address structure
+ */
+struct MR_PD_ADDRESS {
+       u16     deviceId;
+       u16     enclDeviceId;
+
+       union {
+               struct {
+                       u8  enclIndex;
+                       u8  slotNumber;
+               } mrPdAddress;
+               struct {
+                       u8  enclPosition;
+                       u8  enclConnectorIndex;
+               } mrEnclAddress;
+       };
+       u8      scsiDevType;
+       union {
+               u8      connectedPortBitmap;
+               u8      connectedPortNumbers;
+       };
+       u64     sasAddr[2];
+} __attribute__ ((packed));
+
+/*
+ * defines the physical drive list structure
+ */
+struct MR_PD_LIST {
+       u32             size;
+       u32             count;
+       struct MR_PD_ADDRESS   addr[1];
+} __attribute__ ((packed));
+
+struct megasas_pd_list {
+       u16             tid;
+       u8             driveType;
+       u8             driveState;
+} __attribute__ ((packed));
+
+/*
  * SAS controller properties
  */
 struct megasas_ctrl_prop {
@@ -553,6 +633,8 @@ struct megasas_ctrl_info {
 #define MEGASAS_DEFAULT_INIT_ID                        -1
 #define MEGASAS_MAX_LUN                                8
 #define MEGASAS_MAX_LD                         64
+#define MEGASAS_MAX_PD                          (MEGASAS_MAX_PD_CHANNELS * \
+                                               MEGASAS_MAX_DEV_PER_CHANNEL)

 #define MEGASAS_DBG_LVL                                1

@@ -1104,6 +1186,7 @@ struct megasas_instance {

        unsigned long base_addr;
        struct megasas_register_set __iomem *reg_set;
+       struct megasas_pd_list          pd_list[MEGASAS_MAX_PD];

        s8 init_id;

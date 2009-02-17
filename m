From: "Yang, Bo" <Bo.Yang@lsi.com>
Subject: [PATCH 6/9] scsi: megaraid_sas - Report the unconfigured PD (system
 PD) to OS
Date: Tue, 17 Feb 2009 10:09:39 -0700
Message-ID: <4B6A08C587958942AA3002690DD4F8C33A07FC2B@cosmail02.lsi.com>
References: <4B6A08C587958942AA3002690DD4F8C33A07FBD2@cosmail02.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og106.obsmtp.com ([64.18.2.165]:48301 "EHLO
	exprod7og106.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752406AbZBQRJz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Feb 2009 12:09:55 -0500
In-Reply-To: <4B6A08C587958942AA3002690DD4F8C33A07FBD2@cosmail02.lsi.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Yang, Bo" <Bo.Yang@lsi.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "akpm@osdl.org" <akpm@osdl.org>li
Cc: "Austria, Winston" <Winston.Austria@lsi.com>

Add the support for reporting the unconfigured PD (system PD) to OS in MegaRAID SAS driver

Signed-off-by Bo Yang<bo.yang@lsi.com>

---
drivers/scsi/megaraid/megaraid_sas.c |  148 ++++++++++++++++++++++++++++++++++-
 drivers/scsi/megaraid/megaraid_sas.h |   92 +++++++++++++++++++++
 2 files changed, 237 insertions(+), 3 deletions(-)

diff -rupN linux-2.6.28_orig/drivers/scsi/megaraid/megaraid_sas.c linux-2.6.28_new/drivers/scsi/megaraid/megaraid_sas.c
--- linux-2.6.28_orig/drivers/scsi/megaraid/megaraid_sas.c      2009-02-12 16:16:42.000000000 -0500
+++ linux-2.6.28_new/drivers/scsi/megaraid/megaraid_sas.c       2009-02-12 16:24:41.000000000 -0500
@@ -1119,6 +1119,11 @@ megasas_queue_command(struct scsi_cmnd *

 static int megasas_slave_configure(struct scsi_device *sdev)
 {
+       u16             pd_index = 0;
+       struct  megasas_instance *instance ;
+
+       instance = megasas_lookup_instance(sdev->host->host_no);
+
        /*
         * Don't export physical disk devices to the disk driver.
         *
@@ -1126,7 +1131,17 @@ static int megasas_slave_configure(struc
         *        That will be fixed once LSI engineers have audited the
         *        firmware for possible issues.
         */
-       if (sdev->channel < MEGASAS_MAX_PD_CHANNELS && sdev->type == TYPE_DISK)
+       if (sdev->channel < MEGASAS_MAX_PD_CHANNELS &&
+                               sdev->type == TYPE_DISK) {
+               pd_index = (sdev->channel * MEGASAS_MAX_DEV_PER_CHANNEL) +
+                               sdev->id;
+
+               if (instance->pd_list[pd_index].driveState ==
+                               MR_PD_STATE_SYSTEM) {
+                       sdev->timeout = 90 * HZ;
+                       return 0;
+               }
+
                return -ENXIO;

        /*
@@ -1423,6 +1438,29 @@ megasas_service_aen(struct megasas_insta
        megasas_return_cmd(instance, cmd);
 }

+static int megasas_slave_alloc(struct scsi_device *sdev)
+{
+       u16             pd_index = 0;
+       struct megasas_instance *instance ;
+       instance = megasas_lookup_instance(sdev->host->host_no);
+
+       if (sdev->channel < MEGASAS_MAX_PD_CHANNELS) {
+               /*
+                * Open the OS scan to the SYSTEM PD
+                */
+               pd_index =
+                   (sdev->channel * MEGASAS_MAX_DEV_PER_CHANNEL) + sdev->id;
+               if ((instance->pd_list[pd_index].driveState ==
+                       MR_PD_STATE_SYSTEM) &&
+                       (instance->pd_list[pd_index].driveType ==
+                       TYPE_DISK)) {
+                       return 0;
+               }
+
+               return -ENXIO;
+       }
+       return 0;
+}
 /*
  * Scsi host template for megaraid_sas driver
  */
@@ -1432,6 +1470,7 @@ static struct scsi_host_template megasas
        .name = "LSI SAS based MegaRAID driver",
        .proc_name = "megaraid_sas",
        .slave_configure = megasas_slave_configure,
+       .slave_alloc = megasas_slave_alloc,
        .queuecommand = megasas_queue_command,
        .eh_device_reset_handler = megasas_reset_device,
        .eh_bus_reset_handler = megasas_reset_bus_host,
@@ -2143,7 +2182,7 @@ megasas_mem_to_fw(struct megasas_instanc
        cmd = megasas_get_cmd(instance);

        if (!cmd) {
-               printk(KERN_DEBUG "megasas (get_pd_list): Failed to get cmd\n");
+               printk(KERN_DEBUG "megasas (mem_to_fw): Failed to get cmd\n");
                return -ENOMEM;
        }

@@ -2152,7 +2191,7 @@ megasas_mem_to_fw(struct megasas_instanc
        memset(dcmd->mbox.b, 0, MFI_MBOX_SIZE);

        dcmd->mbox.s[0] = instance->skinny_mm_alloc_ind;
-       dcmd->mbox.s[2] = MEGASAS_SKINNY_SZ_MEM_BK / 1024;
+       dcmd->mbox.s[2] = MEGASAS_SKINNY_SZ_MEM_BK/1024;

        dcmd->cmd = MFI_CMD_DCMD;
        dcmd->cmd_status = 0xFF;
@@ -2177,6 +2216,100 @@ megasas_mem_to_fw(struct megasas_instanc
 }

 /**
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
+
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
+
+                       pd_addr++;
+               }
+
+       }
+
+       pci_free_consistent(instance->pdev, sizeof(struct megasas_ctrl_info),
+                           ci, ci_h);
+
+       megasas_return_cmd(instance, cmd);
+
+       return ret;
+}
+
+/**
  * megasas_get_controller_info -       Returns FW's controller structure
  * @instance:                          Adapter soft state
  * @ctrl_info:                         Controller information structure
@@ -2488,6 +2621,15 @@ static int megasas_init_mfi(struct megas
        if (megasas_issue_init_mfi(instance))
                goto fail_fw_init;

+       /**
+       * for passthrough
+       * the following function will get the PD LIST.
+       **/
+
+       memset(instance->pd_list, 0,
+               MEGASAS_MAX_PD * sizeof(struct megasas_pd_list));
+       megasas_get_pd_list(instance);
+
        ctrl_info = kmalloc(sizeof(struct megasas_ctrl_info), GFP_KERNEL);

        /*
diff -rupN linux-2.6.28_orig/drivers/scsi/megaraid/megaraid_sas.h linux-2.6.28_new/drivers/scsi/megaraid/megaraid_sas.h
--- linux-2.6.28_orig/drivers/scsi/megaraid/megaraid_sas.h      2009-02-12 16:16:43.000000000 -0500
+++ linux-2.6.28_new/drivers/scsi/megaraid/megaraid_sas.h       2009-02-12 15:24:58.000000000 -0500
@@ -133,6 +133,7 @@
 #define MR_DCMD_CLUSTER                                0x08000000
 #define MR_DCMD_CLUSTER_RESET_ALL              0x08010100
 #define MR_DCMD_CLUSTER_RESET_LD               0x08010200
+#define MR_DCMD_PD_LIST_QUERY                  0x02010100

 #define MR_EVT_CFG_CLEARED                     0x0004

@@ -263,9 +264,98 @@ enum MR_EVT_ARGS {
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
+    MR_PD_QUERY_TYPE_ALL                = 0,
+    MR_PD_QUERY_TYPE_STATE              = 1,
+    MR_PD_QUERY_TYPE_POWER_STATE        = 2,
+    MR_PD_QUERY_TYPE_MEDIA_TYPE         = 3,
+    MR_PD_QUERY_TYPE_SPEED              = 4,
+    MR_PD_QUERY_TYPE_EXPOSED_TO_HOST    = 5,
+} __attribute__ ((packed));
+
+#define MR_EVT_CFG_CLEARED                             0x0004
+#define MR_EVT_LD_STATE_CHANGE                         0x0051
+#define MR_EVT_PD_INSERTED                             0x005b
+#define MR_EVT_PD_REMOVED                              0x0070
+#define MR_EVT_LD_CREATED                              0x008a
+#define MR_EVT_LD_DELETED                              0x008b
+#define MR_EVT_FOREIGN_CFG_IMPORTED                    0x00db
+#define MR_EVT_LD_OFFLINE                              0x00fc
+#define MR_EVT_CTRL_HOST_BUS_SCAN_REQUESTED            0x0152
+
+
+enum MR_PD_STATE {
+    MR_PD_STATE_UNCONFIGURED_GOOD   = 0x00,
+    MR_PD_STATE_UNCONFIGURED_BAD    = 0x01,
+    MR_PD_STATE_HOT_SPARE           = 0x02,
+    MR_PD_STATE_OFFLINE             = 0x10,
+    MR_PD_STATE_FAILED              = 0x11,
+    MR_PD_STATE_REBUILD             = 0x14,
+    MR_PD_STATE_ONLINE              = 0x18,
+    MR_PD_STATE_COPYBACK            = 0x20,
+    MR_PD_STATE_SYSTEM              = 0x40,
 };

+ /*
+ * defines the physical drive address structure
+ */
+struct MR_PD_ADDRESS {
+       u16     deviceId;
+       u16     enclDeviceId;
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
+    u32             size;
+    u32             count;
+    struct MR_PD_ADDRESS   addr[1];
+} __attribute__ ((packed));
+
+struct megasas_pd_list {
+    u16             tid;
+    u8             driveType;
+    u8             driveState;
+} __attribute__ ((packed));
+
 /*
  * SAS controller properties
  */
@@ -552,6 +642,8 @@ struct megasas_ctrl_info {
 #define MEGASAS_DEFAULT_INIT_ID                        -1
 #define MEGASAS_MAX_LUN                                8
 #define MEGASAS_MAX_LD                         64
+#define MEGASAS_MAX_PD                         (MEGASAS_MAX_PD_CHANNELS * \
+                                               MEGASAS_MAX_DEV_PER_CHANNEL)

 #define MEGASAS_DBG_LVL                                1

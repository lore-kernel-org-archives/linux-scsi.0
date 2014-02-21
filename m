From: =?UTF-8?B?6buD5riF6ZqG?= <ching2048@areca.com.tw>
Subject: [PATCH v1.3 10/11] arcmsr: Fixed coding style errors and white space change
Date: Fri, 21 Feb 2014 12:35:58 +0800
Message-ID: <CAKiknE-FJg9y7CTMbvow277mr=H+oKkBLjDc1qDYjhHtpfBdZA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jbottomley@parallels.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>
Cc: fengguang.wu@intel.com, Tomas Henzl <thenzl@redhat.com>
List-Id: linux-scsi@vger.kernel.org

From: Ching <ching2048@areca.com.tw>

Fixed coding style errors and white space change.

Singed-off-by: Ching <ching2048@areca.com.tw>
---

diff -uprN a/drivers/scsi/arcmsr/arcmsr_attr.c
b/drivers/scsi/arcmsr/arcmsr_attr.c
--- a/drivers/scsi/arcmsr/arcmsr_attr.c 2014-01-15 23:41:36.000000000 +0800
+++ b/drivers/scsi/arcmsr/arcmsr_attr.c 2014-02-12 10:52:34.000000000 +0800
@@ -262,31 +262,37 @@ static struct bin_attribute arcmsr_sysfs
        .write = arcmsr_sysfs_iop_message_clear,
 };

-int arcmsr_alloc_sysfs_attr(struct AdapterControlBlock *acb)
+int
+arcmsr_alloc_sysfs_attr(struct AdapterControlBlock *acb)
 {
        struct Scsi_Host *host = acb->host;
        int error;

-       error = sysfs_create_bin_file(&host->shost_dev.kobj,
&arcmsr_sysfs_message_read_attr);
+       error = sysfs_create_bin_file(&host->shost_dev.kobj,
+               &arcmsr_sysfs_message_read_attr);
        if (error) {
-               printk(KERN_ERR "arcmsr: alloc sysfs mu_read failed\n");
+               pr_err("arcmsr: alloc sysfs mu_read failed\n");
                goto error_bin_file_message_read;
        }
-       error = sysfs_create_bin_file(&host->shost_dev.kobj,
&arcmsr_sysfs_message_write_attr);
+       error = sysfs_create_bin_file(&host->shost_dev.kobj,
+               &arcmsr_sysfs_message_write_attr);
        if (error) {
-               printk(KERN_ERR "arcmsr: alloc sysfs mu_write failed\n");
+               pr_err("arcmsr: alloc sysfs mu_write failed\n");
                goto error_bin_file_message_write;
        }
-       error = sysfs_create_bin_file(&host->shost_dev.kobj,
&arcmsr_sysfs_message_clear_attr);
+       error = sysfs_create_bin_file(&host->shost_dev.kobj,
+               &arcmsr_sysfs_message_clear_attr);
        if (error) {
-               printk(KERN_ERR "arcmsr: alloc sysfs mu_clear failed\n");
+               pr_err("arcmsr: alloc sysfs mu_clear failed\n");
                goto error_bin_file_message_clear;
        }
        return 0;
 error_bin_file_message_clear:
-       sysfs_remove_bin_file(&host->shost_dev.kobj,
&arcmsr_sysfs_message_write_attr);
+       sysfs_remove_bin_file(&host->shost_dev.kobj,
+               &arcmsr_sysfs_message_write_attr);
 error_bin_file_message_write:
-       sysfs_remove_bin_file(&host->shost_dev.kobj,
&arcmsr_sysfs_message_read_attr);
+       sysfs_remove_bin_file(&host->shost_dev.kobj,
+               &arcmsr_sysfs_message_read_attr);
 error_bin_file_message_read:
        return error;
 }
@@ -295,30 +301,29 @@ void arcmsr_free_sysfs_attr(struct Adapt
 {
        struct Scsi_Host *host = acb->host;

-       sysfs_remove_bin_file(&host->shost_dev.kobj,
&arcmsr_sysfs_message_clear_attr);
-       sysfs_remove_bin_file(&host->shost_dev.kobj,
&arcmsr_sysfs_message_write_attr);
-       sysfs_remove_bin_file(&host->shost_dev.kobj,
&arcmsr_sysfs_message_read_attr);
+       sysfs_remove_bin_file(&host->shost_dev.kobj,
+               &arcmsr_sysfs_message_clear_attr);
+       sysfs_remove_bin_file(&host->shost_dev.kobj,
+               &arcmsr_sysfs_message_write_attr);
+       sysfs_remove_bin_file(&host->shost_dev.kobj,
+               &arcmsr_sysfs_message_read_attr);
 }

-
 static ssize_t
 arcmsr_attr_host_driver_version(struct device *dev,
                                struct device_attribute *attr, char *buf)
 {
-       return snprintf(buf, PAGE_SIZE,
-                       "%s\n",
-                       ARCMSR_DRIVER_VERSION);
+       return snprintf(buf, PAGE_SIZE, "%s\n", ARCMSR_DRIVER_VERSION);
 }

 static ssize_t
 arcmsr_attr_host_driver_posted_cmd(struct device *dev,
-                                  struct device_attribute *attr, char *buf)
+                               struct device_attribute *attr, char *buf)
 {
        struct Scsi_Host *host = class_to_shost(dev);
        struct AdapterControlBlock *acb =
-               (struct AdapterControlBlock *) host->hostdata;
-       return snprintf(buf, PAGE_SIZE,
-                       "%4d\n",
+               (struct AdapterControlBlock *)host->hostdata;
+       return snprintf(buf, PAGE_SIZE, "%4d\n",
                        atomic_read(&acb->ccboutstandingcount));
 }

@@ -328,10 +333,8 @@ arcmsr_attr_host_driver_reset(struct dev
 {
        struct Scsi_Host *host = class_to_shost(dev);
        struct AdapterControlBlock *acb =
-               (struct AdapterControlBlock *) host->hostdata;
-       return snprintf(buf, PAGE_SIZE,
-                       "%4d\n",
-                       acb->num_resets);
+               (struct AdapterControlBlock *)host->hostdata;
+       return snprintf(buf, PAGE_SIZE, "%4d\n", acb->num_resets);
 }

 static ssize_t
@@ -340,22 +343,18 @@ arcmsr_attr_host_driver_abort(struct dev
 {
        struct Scsi_Host *host = class_to_shost(dev);
        struct AdapterControlBlock *acb =
-               (struct AdapterControlBlock *) host->hostdata;
-       return snprintf(buf, PAGE_SIZE,
-                       "%4d\n",
-                       acb->num_aborts);
+               (struct AdapterControlBlock *)host->hostdata;
+       return snprintf(buf, PAGE_SIZE, "%4d\n", acb->num_aborts);
 }

 static ssize_t
-arcmsr_attr_host_fw_model(struct device *dev, struct device_attribute *attr,
-                         char *buf)
+arcmsr_attr_host_fw_model(struct device *dev,
+                       struct device_attribute *attr, char *buf)
 {
        struct Scsi_Host *host = class_to_shost(dev);
        struct AdapterControlBlock *acb =
-               (struct AdapterControlBlock *) host->hostdata;
-       return snprintf(buf, PAGE_SIZE,
-                       "%s\n",
-                       acb->firm_model);
+               (struct AdapterControlBlock *)host->hostdata;
+       return snprintf(buf, PAGE_SIZE, "%s\n", acb->firm_model);
 }

 static ssize_t
@@ -364,11 +363,8 @@ arcmsr_attr_host_fw_version(struct devic
 {
        struct Scsi_Host *host = class_to_shost(dev);
        struct AdapterControlBlock *acb =
-                       (struct AdapterControlBlock *) host->hostdata;
-
-       return snprintf(buf, PAGE_SIZE,
-                       "%s\n",
-                       acb->firm_version);
+               (struct AdapterControlBlock *)host->hostdata;
+       return snprintf(buf, PAGE_SIZE, "%s\n", acb->firm_version);
 }

 static ssize_t
@@ -377,11 +373,8 @@ arcmsr_attr_host_fw_request_len(struct d
 {
        struct Scsi_Host *host = class_to_shost(dev);
        struct AdapterControlBlock *acb =
-               (struct AdapterControlBlock *) host->hostdata;
-
-       return snprintf(buf, PAGE_SIZE,
-                       "%4d\n",
-                       acb->firm_request_len);
+               (struct AdapterControlBlock *)host->hostdata;
+       return snprintf(buf, PAGE_SIZE, "%4d\n", acb->firm_request_len);
 }

 static ssize_t
@@ -390,11 +383,8 @@ arcmsr_attr_host_fw_numbers_queue(struct
 {
        struct Scsi_Host *host = class_to_shost(dev);
        struct AdapterControlBlock *acb =
-               (struct AdapterControlBlock *) host->hostdata;
-
-       return snprintf(buf, PAGE_SIZE,
-                       "%4d\n",
-                       acb->firm_numbers_queue);
+               (struct AdapterControlBlock *)host->hostdata;
+       return snprintf(buf, PAGE_SIZE, "%4d\n", acb->firm_numbers_queue);
 }

 static ssize_t
@@ -403,11 +393,8 @@ arcmsr_attr_host_fw_sdram_size(struct de
 {
        struct Scsi_Host *host = class_to_shost(dev);
        struct AdapterControlBlock *acb =
-               (struct AdapterControlBlock *) host->hostdata;
-
-       return snprintf(buf, PAGE_SIZE,
-                       "%4d\n",
-                       acb->firm_sdram_size);
+               (struct AdapterControlBlock *)host->hostdata;
+       return snprintf(buf, PAGE_SIZE, "%4d\n", acb->firm_sdram_size);
 }

 static ssize_t
@@ -416,11 +403,8 @@ arcmsr_attr_host_fw_hd_channels(struct d
 {
        struct Scsi_Host *host = class_to_shost(dev);
        struct AdapterControlBlock *acb =
-               (struct AdapterControlBlock *) host->hostdata;
-
-       return snprintf(buf, PAGE_SIZE,
-                       "%4d\n",
-                       acb->firm_hd_channels);
+               (struct AdapterControlBlock *)host->hostdata;
+       return snprintf(buf, PAGE_SIZE, "%4d\n", acb->firm_hd_channels);
 }

 static DEVICE_ATTR(host_driver_version, S_IRUGO,
arcmsr_attr_host_driver_version, NULL);
@@ -447,4 +431,3 @@ struct device_attribute *arcmsr_host_att
        &dev_attr_host_fw_hd_channels,
        NULL,
 };
-
diff -uprN a/drivers/scsi/arcmsr/arcmsr.h b/drivers/scsi/arcmsr/arcmsr.h
--- a/drivers/scsi/arcmsr/arcmsr.h      2014-02-20 23:23:30.000000000 +0800
+++ b/drivers/scsi/arcmsr/arcmsr.h      2014-02-20 20:14:42.000000000 +0800
@@ -6,7 +6,7 @@
 **   Description: SCSI RAID Device Driver for
 **                ARECA RAID Host adapter
 *******************************************************************************
-** Copyright (C) 2002 - 2005, Areca Technology Corporation All rights reserved.
+** Copyright (C) 2002 - 2014, Areca Technology Corporation All rights reserved.
 **
 **     Web site: www.areca.com.tw
 **       E-mail: support@areca.com.tw
@@ -62,26 +62,26 @@ struct device_attribute;
 #define ARCMSR_MAX_QBUFFER             4096
 #define ARCMSR_DEFAULT_SG_ENTRIES      38
 #define ARCMSR_MAX_HBB_POSTQUEUE       264
-#define ARCMSR_MAX_XFER_LEN            0x26000 /* 152K */
-#define ARCMSR_CDB_SG_PAGE_LENGTH      256
+#define ARCMSR_MAX_XFER_LEN            0x26000
+#define ARCMSR_CDB_SG_PAGE_LENGTH      256
 #define ARCMST_NUM_MSIX_VECTORS                4
 #ifndef PCI_DEVICE_ID_ARECA_1880
-#define PCI_DEVICE_ID_ARECA_1880       0x1880
+       #define PCI_DEVICE_ID_ARECA_1880        0x1880
 #endif
 /*
 **********************************************************************************
 **
 **********************************************************************************
 */
-#define ARC_SUCCESS                                                       0
-#define ARC_FAILURE                                                       1
+#define ARC_SUCCESS            0
+#define ARC_FAILURE            1
 /*
 *******************************************************************************
 **        split 64bits dma addressing
 *******************************************************************************
 */
-#define dma_addr_hi32(addr)               (uint32_t) ((addr>>16)>>16)
-#define dma_addr_lo32(addr)               (uint32_t) (addr & 0xffffffff)
+#define dma_addr_hi32(addr)    (uint32_t)((addr >> 16) >> 16)
+#define dma_addr_lo32(addr)    (uint32_t)(addr & 0xffffffff)
 /*
 *******************************************************************************
 **        MESSAGE CONTROL CODE
@@ -89,12 +89,12 @@ struct device_attribute;
 */
 struct CMD_MESSAGE
 {
-      uint32_t HeaderLength;
-      uint8_t  Signature[8];
-      uint32_t Timeout;
-      uint32_t ControlCode;
-      uint32_t ReturnCode;
-      uint32_t Length;
+       uint32_t HeaderLength;
+       uint8_t Signature[8];
+       uint32_t Timeout;
+       uint32_t ControlCode;
+       uint32_t ReturnCode;
+       uint32_t Length;
 };
 /*
 *******************************************************************************
@@ -103,44 +103,44 @@ struct CMD_MESSAGE
 */
 struct CMD_MESSAGE_FIELD
 {
-    struct CMD_MESSAGE                 cmdmessage;
-    uint8_t                            messagedatabuffer[1032];
+       struct CMD_MESSAGE cmdmessage;
+       uint8_t messagedatabuffer[1032];
 };
 /* IOP message transfer */
-#define ARCMSR_MESSAGE_FAIL                    0x0001
+#define ARCMSR_MESSAGE_FAIL            0x0001
 /* DeviceType */
-#define ARECA_SATA_RAID                                0x90000000
+#define ARECA_SATA_RAID                        0x90000000
 /* FunctionCode */
-#define FUNCTION_READ_RQBUFFER                 0x0801
-#define FUNCTION_WRITE_WQBUFFER                        0x0802
-#define FUNCTION_CLEAR_RQBUFFER                        0x0803
-#define FUNCTION_CLEAR_WQBUFFER                        0x0804
-#define FUNCTION_CLEAR_ALLQBUFFER              0x0805
-#define FUNCTION_RETURN_CODE_3F                        0x0806
-#define FUNCTION_SAY_HELLO                     0x0807
-#define FUNCTION_SAY_GOODBYE                   0x0808
-#define FUNCTION_FLUSH_ADAPTER_CACHE           0x0809
-#define FUNCTION_GET_FIRMWARE_STATUS                   0x080A
-#define FUNCTION_HARDWARE_RESET                        0x080B
+#define FUNCTION_READ_RQBUFFER         0x0801
+#define FUNCTION_WRITE_WQBUFFER                0x0802
+#define FUNCTION_CLEAR_RQBUFFER                0x0803
+#define FUNCTION_CLEAR_WQBUFFER                0x0804
+#define FUNCTION_CLEAR_ALLQBUFFER      0x0805
+#define FUNCTION_RETURN_CODE_3F                0x0806
+#define FUNCTION_SAY_HELLO             0x0807
+#define FUNCTION_SAY_GOODBYE           0x0808
+#define FUNCTION_FLUSH_ADAPTER_CACHE   0x0809
+#define FUNCTION_GET_FIRMWARE_STATUS   0x080A
+#define FUNCTION_HARDWARE_RESET                0x080B
 /* ARECA IO CONTROL CODE*/
-#define ARCMSR_MESSAGE_READ_RQBUFFER       \
-       ARECA_SATA_RAID | FUNCTION_READ_RQBUFFER
-#define ARCMSR_MESSAGE_WRITE_WQBUFFER      \
-       ARECA_SATA_RAID | FUNCTION_WRITE_WQBUFFER
-#define ARCMSR_MESSAGE_CLEAR_RQBUFFER      \
-       ARECA_SATA_RAID | FUNCTION_CLEAR_RQBUFFER
-#define ARCMSR_MESSAGE_CLEAR_WQBUFFER      \
-       ARECA_SATA_RAID | FUNCTION_CLEAR_WQBUFFER
-#define ARCMSR_MESSAGE_CLEAR_ALLQBUFFER    \
-       ARECA_SATA_RAID | FUNCTION_CLEAR_ALLQBUFFER
-#define ARCMSR_MESSAGE_RETURN_CODE_3F      \
-       ARECA_SATA_RAID | FUNCTION_RETURN_CODE_3F
-#define ARCMSR_MESSAGE_SAY_HELLO           \
-       ARECA_SATA_RAID | FUNCTION_SAY_HELLO
-#define ARCMSR_MESSAGE_SAY_GOODBYE         \
-       ARECA_SATA_RAID | FUNCTION_SAY_GOODBYE
-#define ARCMSR_MESSAGE_FLUSH_ADAPTER_CACHE \
-       ARECA_SATA_RAID | FUNCTION_FLUSH_ADAPTER_CACHE
+#define ARCMSR_MESSAGE_READ_RQBUFFER           \
+       (ARECA_SATA_RAID | FUNCTION_READ_RQBUFFER)
+#define ARCMSR_MESSAGE_WRITE_WQBUFFER  \
+       (ARECA_SATA_RAID | FUNCTION_WRITE_WQBUFFER)
+#define ARCMSR_MESSAGE_CLEAR_RQBUFFER  \
+       (ARECA_SATA_RAID | FUNCTION_CLEAR_RQBUFFER)
+#define ARCMSR_MESSAGE_CLEAR_WQBUFFER  \
+       (ARECA_SATA_RAID | FUNCTION_CLEAR_WQBUFFER)
+#define ARCMSR_MESSAGE_CLEAR_ALLQBUFFER        \
+       (ARECA_SATA_RAID | FUNCTION_CLEAR_ALLQBUFFER)
+#define ARCMSR_MESSAGE_RETURN_CODE_3F  \
+       (ARECA_SATA_RAID | FUNCTION_RETURN_CODE_3F)
+#define ARCMSR_MESSAGE_SAY_HELLO               \
+       (ARECA_SATA_RAID | FUNCTION_SAY_HELLO)
+#define ARCMSR_MESSAGE_SAY_GOODBYE             \
+       (ARECA_SATA_RAID | FUNCTION_SAY_GOODBYE)
+#define ARCMSR_MESSAGE_FLUSH_ADAPTER_CACHE     \
+       (ARECA_SATA_RAID | FUNCTION_FLUSH_ADAPTER_CACHE)
 /* ARECA IOCTL ReturnCode */
 #define ARCMSR_MESSAGE_RETURNCODE_OK           0x00000001
 #define ARCMSR_MESSAGE_RETURNCODE_ERROR                0x00000006
@@ -151,18 +151,18 @@ struct CMD_MESSAGE_FIELD
 **   structure for holding DMA address data
 *************************************************************
 */
-#define IS_DMA64                       (sizeof(dma_addr_t) == 8)
-#define IS_SG64_ADDR                0x01000000 /* bit24 */
+#define IS_DMA64       (sizeof(dma_addr_t) == 8)
+#define IS_SG64_ADDR   0x01000000 /* bit24 */
 struct  SG32ENTRY
 {
-       __le32                                  length;
-       __le32                                  address;
+       __le32 length;
+       __le32 address;
 }__attribute__ ((packed));
 struct  SG64ENTRY
 {
-       __le32                                  length;
-       __le32                                  address;
-       __le32                                  addresshigh;
+       __le32 length;
+       __le32 address;
+       __le32 addresshigh;
 }__attribute__ ((packed));
 /*
 ********************************************************************
@@ -171,8 +171,8 @@ struct  SG64ENTRY
 */
 struct QBUFFER
 {
-       uint32_t      data_len;
-       uint8_t       data[124];
+       uint32_t data_len;
+       uint8_t data[124];
 };
 /*
 *******************************************************************************
@@ -181,50 +181,50 @@ struct QBUFFER
 */
 struct FIRMWARE_INFO
 {
-       uint32_t      signature;                /*0, 00-03*/
-       uint32_t      request_len;              /*1, 04-07*/
-       uint32_t      numbers_queue;            /*2, 08-11*/
-       uint32_t      sdram_size;               /*3, 12-15*/
-       uint32_t      ide_channels;             /*4, 16-19*/
-       char          vendor[40];               /*5, 20-59*/
-       char          model[8];                 /*15, 60-67*/
-       char          firmware_ver[16];         /*17, 68-83*/
-       char          device_map[16];           /*21, 84-99*/
-       uint32_t                cfgVersion;
/*25,100-103 Added for checking of new firmware capability*/
-       uint8_t         cfgSerial[16];                  /*26,104-119*/
-       uint32_t                cfgPicStatus;                   /*30,120-123*/
+       uint32_t signature;     /*0, 00-03*/
+       uint32_t request_len;   /*1, 04-07*/
+       uint32_t numbers_queue; /*2, 08-11*/
+       uint32_t sdram_size;    /*3, 12-15*/
+       uint32_t ide_channels;  /*4, 16-19*/
+       char    vendor[40];     /*5, 20-59*/
+       char    model[8];       /*15, 60-67*/
+       char    firmware_ver[16]; /*17, 68-83*/
+       char    device_map[16]; /*21, 84-99*/
+       uint32_t cfgVersion;    /*25, 100-103*/
+       uint8_t cfgSerial[16];  /*26, 104-119*/
+       uint32_t cfgPicStatus;  /*30, 120-123*/
 };
 /* signature of set and get firmware config */
-#define ARCMSR_SIGNATURE_GET_CONFIG                  0x87974060
-#define ARCMSR_SIGNATURE_SET_CONFIG                  0x87974063
+#define ARCMSR_SIGNATURE_GET_CONFIG            0x87974060
+#define ARCMSR_SIGNATURE_SET_CONFIG            0x87974063
 /* message code of inbound message register */
-#define ARCMSR_INBOUND_MESG0_NOP                     0x00000000
-#define ARCMSR_INBOUND_MESG0_GET_CONFIG                      0x00000001
-#define ARCMSR_INBOUND_MESG0_SET_CONFIG               0x00000002
-#define ARCMSR_INBOUND_MESG0_ABORT_CMD                0x00000003
-#define ARCMSR_INBOUND_MESG0_STOP_BGRB                0x00000004
-#define ARCMSR_INBOUND_MESG0_FLUSH_CACHE              0x00000005
-#define ARCMSR_INBOUND_MESG0_START_BGRB               0x00000006
-#define ARCMSR_INBOUND_MESG0_CHK331PENDING            0x00000007
-#define ARCMSR_INBOUND_MESG0_SYNC_TIMER               0x00000008
+#define ARCMSR_INBOUND_MESG0_NOP               0x00000000
+#define ARCMSR_INBOUND_MESG0_GET_CONFIG                0x00000001
+#define ARCMSR_INBOUND_MESG0_SET_CONFIG                0x00000002
+#define ARCMSR_INBOUND_MESG0_ABORT_CMD         0x00000003
+#define ARCMSR_INBOUND_MESG0_STOP_BGRB         0x00000004
+#define ARCMSR_INBOUND_MESG0_FLUSH_CACHE       0x00000005
+#define ARCMSR_INBOUND_MESG0_START_BGRB                0x00000006
+#define ARCMSR_INBOUND_MESG0_CHK331PENDING     0x00000007
+#define ARCMSR_INBOUND_MESG0_SYNC_TIMER                0x00000008
 /* doorbell interrupt generator */
-#define ARCMSR_INBOUND_DRIVER_DATA_WRITE_OK           0x00000001
-#define ARCMSR_INBOUND_DRIVER_DATA_READ_OK            0x00000002
-#define ARCMSR_OUTBOUND_IOP331_DATA_WRITE_OK          0x00000001
-#define ARCMSR_OUTBOUND_IOP331_DATA_READ_OK           0x00000002
+#define ARCMSR_INBOUND_DRIVER_DATA_WRITE_OK    0x00000001
+#define ARCMSR_INBOUND_DRIVER_DATA_READ_OK     0x00000002
+#define ARCMSR_OUTBOUND_IOP331_DATA_WRITE_OK   0x00000001
+#define ARCMSR_OUTBOUND_IOP331_DATA_READ_OK    0x00000002
 /* ccb areca cdb flag */
-#define ARCMSR_CCBPOST_FLAG_SGL_BSIZE                 0x80000000
-#define ARCMSR_CCBPOST_FLAG_IAM_BIOS                  0x40000000
-#define ARCMSR_CCBREPLY_FLAG_IAM_BIOS                 0x40000000
-#define ARCMSR_CCBREPLY_FLAG_ERROR_MODE0              0x10000000
-#define ARCMSR_CCBREPLY_FLAG_ERROR_MODE1              0x00000001
+#define ARCMSR_CCBPOST_FLAG_SGL_BSIZE          0x80000000
+#define ARCMSR_CCBPOST_FLAG_IAM_BIOS           0x40000000
+#define ARCMSR_CCBREPLY_FLAG_IAM_BIOS          0x40000000
+#define ARCMSR_CCBREPLY_FLAG_ERROR_MODE0       0x10000000
+#define ARCMSR_CCBREPLY_FLAG_ERROR_MODE1       0x00000001
 /* outbound firmware ok */
-#define ARCMSR_OUTBOUND_MESG1_FIRMWARE_OK             0x80000000
+#define ARCMSR_OUTBOUND_MESG1_FIRMWARE_OK      0x80000000
 /* ARC-1680 Bus Reset*/
-#define ARCMSR_ARC1680_BUS_RESET                               0x00000003
+#define ARCMSR_ARC1680_BUS_RESET               0x00000003
 /* ARC-1880 Bus Reset*/
-#define ARCMSR_ARC1880_RESET_ADAPTER                           0x00000024
-#define ARCMSR_ARC1880_DiagWrite_ENABLE                        0x00000080
+#define ARCMSR_ARC1880_RESET_ADAPTER           0x00000024
+#define ARCMSR_ARC1880_DiagWrite_ENABLE                0x00000080

 /*
 ************************************************************************
@@ -233,54 +233,54 @@ struct FIRMWARE_INFO
 */
 /* ARECA HBB COMMAND for its FIRMWARE */
 /* window of "instruction flags" from driver to iop */
-#define ARCMSR_DRV2IOP_DOORBELL                       0x00020400
-#define ARCMSR_DRV2IOP_DOORBELL_MASK                  0x00020404
+#define ARCMSR_DRV2IOP_DOORBELL                0x00020400
+#define ARCMSR_DRV2IOP_DOORBELL_MASK   0x00020404
 /* window of "instruction flags" from iop to driver */
-#define ARCMSR_IOP2DRV_DOORBELL                       0x00020408
-#define ARCMSR_IOP2DRV_DOORBELL_MASK                  0x0002040C
+#define ARCMSR_IOP2DRV_DOORBELL                0x00020408
+#define ARCMSR_IOP2DRV_DOORBELL_MASK   0x0002040C
 /* ARECA FLAG LANGUAGE */
 /* ioctl transfer */
-#define ARCMSR_IOP2DRV_DATA_WRITE_OK                  0x00000001
+#define ARCMSR_IOP2DRV_DATA_WRITE_OK   0x00000001
 /* ioctl transfer */
-#define ARCMSR_IOP2DRV_DATA_READ_OK                   0x00000002
-#define ARCMSR_IOP2DRV_CDB_DONE                       0x00000004
-#define ARCMSR_IOP2DRV_MESSAGE_CMD_DONE               0x00000008
-
-#define ARCMSR_DOORBELL_HANDLE_INT                   0x0000000F
-#define ARCMSR_DOORBELL_INT_CLEAR_PATTERN            0xFF00FFF0
-#define ARCMSR_MESSAGE_INT_CLEAR_PATTERN             0xFF00FFF7
+#define ARCMSR_IOP2DRV_DATA_READ_OK    0x00000002
+#define ARCMSR_IOP2DRV_CDB_DONE                0x00000004
+#define ARCMSR_IOP2DRV_MESSAGE_CMD_DONE        0x00000008
+
+#define ARCMSR_DOORBELL_HANDLE_INT             0x0000000F
+#define ARCMSR_DOORBELL_INT_CLEAR_PATTERN      0xFF00FFF0
+#define ARCMSR_MESSAGE_INT_CLEAR_PATTERN       0xFF00FFF7
 /* (ARCMSR_INBOUND_MESG0_GET_CONFIG<<16)|ARCMSR_DRV2IOP_MESSAGE_CMD_POSTED) */
-#define ARCMSR_MESSAGE_GET_CONFIG                    0x00010008
+#define ARCMSR_MESSAGE_GET_CONFIG              0x00010008
 /* (ARCMSR_INBOUND_MESG0_SET_CONFIG<<16)|ARCMSR_DRV2IOP_MESSAGE_CMD_POSTED) */
-#define ARCMSR_MESSAGE_SET_CONFIG                    0x00020008
+#define ARCMSR_MESSAGE_SET_CONFIG              0x00020008
 /* (ARCMSR_INBOUND_MESG0_ABORT_CMD<<16)|ARCMSR_DRV2IOP_MESSAGE_CMD_POSTED) */
-#define ARCMSR_MESSAGE_ABORT_CMD                     0x00030008
+#define ARCMSR_MESSAGE_ABORT_CMD               0x00030008
 /* (ARCMSR_INBOUND_MESG0_STOP_BGRB<<16)|ARCMSR_DRV2IOP_MESSAGE_CMD_POSTED) */
-#define ARCMSR_MESSAGE_STOP_BGRB                     0x00040008
+#define ARCMSR_MESSAGE_STOP_BGRB               0x00040008
 /* (ARCMSR_INBOUND_MESG0_FLUSH_CACHE<<16)|ARCMSR_DRV2IOP_MESSAGE_CMD_POSTED) */
-#define ARCMSR_MESSAGE_FLUSH_CACHE                    0x00050008
+#define ARCMSR_MESSAGE_FLUSH_CACHE             0x00050008
 /* (ARCMSR_INBOUND_MESG0_START_BGRB<<16)|ARCMSR_DRV2IOP_MESSAGE_CMD_POSTED) */
-#define ARCMSR_MESSAGE_START_BGRB                    0x00060008
-#define ARCMSR_MESSAGE_START_DRIVER_MODE             0x000E0008
-#define ARCMSR_MESSAGE_SET_POST_WINDOW               0x000F0008
-#define ARCMSR_MESSAGE_ACTIVE_EOI_MODE             0x00100008
+#define ARCMSR_MESSAGE_START_BGRB              0x00060008
+#define ARCMSR_MESSAGE_START_DRIVER_MODE       0x000E0008
+#define ARCMSR_MESSAGE_SET_POST_WINDOW         0x000F0008
+#define ARCMSR_MESSAGE_ACTIVE_EOI_MODE         0x00100008
 /* ARCMSR_OUTBOUND_MESG1_FIRMWARE_OK */
-#define ARCMSR_MESSAGE_FIRMWARE_OK                   0x80000000
+#define ARCMSR_MESSAGE_FIRMWARE_OK             0x80000000
 /* ioctl transfer */
-#define ARCMSR_DRV2IOP_DATA_WRITE_OK                  0x00000001
+#define ARCMSR_DRV2IOP_DATA_WRITE_OK           0x00000001
 /* ioctl transfer */
-#define ARCMSR_DRV2IOP_DATA_READ_OK                   0x00000002
-#define ARCMSR_DRV2IOP_CDB_POSTED                     0x00000004
-#define ARCMSR_DRV2IOP_MESSAGE_CMD_POSTED             0x00000008
+#define ARCMSR_DRV2IOP_DATA_READ_OK            0x00000002
+#define ARCMSR_DRV2IOP_CDB_POSTED              0x00000004
+#define ARCMSR_DRV2IOP_MESSAGE_CMD_POSTED      0x00000008
 #define ARCMSR_DRV2IOP_END_OF_INTERRUPT                0x00000010

 /* data tunnel buffer between user space program and its firmware */
 /* user space data to iop 128bytes */
-#define ARCMSR_MESSAGE_WBUFFER                       0x0000fe00
+#define ARCMSR_MESSAGE_WBUFFER         0x0000fe00
 /* iop data to user space 128bytes */
-#define ARCMSR_MESSAGE_RBUFFER                       0x0000ff00
+#define ARCMSR_MESSAGE_RBUFFER         0x0000ff00
 /* iop message_rwbuffer for message command */
-#define ARCMSR_MESSAGE_RWBUFFER                              0x0000fa00
+#define ARCMSR_MESSAGE_RWBUFFER                0x0000fa00
 /*
 ************************************************************************
 **                SPEC. for Areca HBC adapter
@@ -289,45 +289,48 @@ struct FIRMWARE_INFO
 #define ARCMSR_HBC_ISR_THROTTLING_LEVEL                12
 #define ARCMSR_HBC_ISR_MAX_DONE_QUEUE          20
 /* Host Interrupt Mask */
-#define ARCMSR_HBCMU_UTILITY_A_ISR_MASK                0x00000001 /*
When clear, the Utility_A interrupt routes to the host.*/
-#define ARCMSR_HBCMU_OUTBOUND_DOORBELL_ISR_MASK        0x00000004 /*
When clear, the General Outbound Doorbell interrupt routes to the
host.*/
-#define ARCMSR_HBCMU_OUTBOUND_POSTQUEUE_ISR_MASK       0x00000008 /*
When clear, the Outbound Post List FIFO Not Empty interrupt routes to
the host.*/
-#define ARCMSR_HBCMU_ALL_INTMASKENABLE         0x0000000D /* disable all ISR */
+#define ARCMSR_HBCMU_UTILITY_A_ISR_MASK                        0x00000001
+#define ARCMSR_HBCMU_OUTBOUND_DOORBELL_ISR_MASK                0x00000004
+#define ARCMSR_HBCMU_OUTBOUND_POSTQUEUE_ISR_MASK       0x00000008
+#define ARCMSR_HBCMU_ALL_INTMASKENABLE                 0x0000000D
 /* Host Interrupt Status */
 #define ARCMSR_HBCMU_UTILITY_A_ISR                     0x00000001
-       /*
-       ** Set when the Utility_A Interrupt bit is set in the Outbound
Doorbell Register.
-       ** It clears by writing a 1 to the Utility_A bit in the
Outbound Doorbell Clear Register or through automatic clearing (if
enabled).
-       */
+/*
+** Set when the Utility_A Interrupt bit is set
+** in the Outbound Doorbell Register.
+** It clears by writing a 1 to the Utility_A
+** bit in the Outbound Doorbell Clear Register
+** or through automatic clearing (if enabled).
+*/
 #define ARCMSR_HBCMU_OUTBOUND_DOORBELL_ISR             0x00000004
-       /*
-       ** Set if Outbound Doorbell register bits 30:1 have a non-zero
-       ** value. This bit clears only when Outbound Doorbell bits
-       ** 30:1 are ALL clear. Only a write to the Outbound Doorbell
-       ** Clear register clears bits in the Outbound Doorbell register.
-       */
-#define ARCMSR_HBCMU_OUTBOUND_POSTQUEUE_ISR    0x00000008
-       /*
-       ** Set whenever the Outbound Post List Producer/Consumer
-       ** Register (FIFO) is not empty. It clears when the Outbound
-       ** Post List FIFO is empty.
-       */
+/*
+** Set if Outbound Doorbell register bits 30:1 have a non-zero
+** value. This bit clears only when Outbound Doorbell bits
+** 30:1 are ALL clear. Only a write to the Outbound Doorbell
+** Clear register clears bits in the Outbound Doorbell register.
+*/
+#define ARCMSR_HBCMU_OUTBOUND_POSTQUEUE_ISR            0x00000008
+/*
+** Set whenever the Outbound Post List Producer/Consumer
+** Register (FIFO) is not empty. It clears when the Outbound
+** Post List FIFO is empty.
+*/
 #define ARCMSR_HBCMU_SAS_ALL_INT                       0x00000010
-       /*
-       ** This bit indicates a SAS interrupt from a source external to
-       ** the PCIe core. This bit is not maskable.
-       */
-       /* DoorBell*/
-#define ARCMSR_HBCMU_DRV2IOP_DATA_WRITE_OK                     0x00000002
-#define ARCMSR_HBCMU_DRV2IOP_DATA_READ_OK                      0x00000004
+/*
+** This bit indicates a SAS interrupt from a source external to
+** the PCIe core. This bit is not maskable.
+*/
+/* DoorBell*/
+#define ARCMSR_HBCMU_DRV2IOP_DATA_WRITE_OK             0x00000002
+#define ARCMSR_HBCMU_DRV2IOP_DATA_READ_OK              0x00000004
        /*inbound message 0 ready*/
 #define ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE          0x00000008
        /*more than 12 request completed in a time*/
-#define ARCMSR_HBCMU_DRV2IOP_POSTQUEUE_THROTTLING              0x00000010
-#define ARCMSR_HBCMU_IOP2DRV_DATA_WRITE_OK                     0x00000002
+#define ARCMSR_HBCMU_DRV2IOP_POSTQUEUE_THROTTLING      0x00000010
+#define ARCMSR_HBCMU_IOP2DRV_DATA_WRITE_OK             0x00000002
        /*outbound DATA WRITE isr door bell clear*/
 #define ARCMSR_HBCMU_IOP2DRV_DATA_WRITE_DOORBELL_CLEAR 0x00000002
-#define ARCMSR_HBCMU_IOP2DRV_DATA_READ_OK                      0x00000004
+#define ARCMSR_HBCMU_IOP2DRV_DATA_READ_OK              0x00000004
        /*outbound DATA READ isr door bell clear*/
 #define ARCMSR_HBCMU_IOP2DRV_DATA_READ_DOORBELL_CLEAR  0x00000004
        /*outbound message 0 ready*/
@@ -335,7 +338,7 @@ struct FIRMWARE_INFO
        /*outbound message cmd isr door bell clear*/
 #define ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE_DOORBELL_CLEAR   0x00000008
        /*ARCMSR_HBAMU_MESSAGE_FIRMWARE_OK*/
-#define ARCMSR_HBCMU_MESSAGE_FIRMWARE_OK                       0x80000000
+#define ARCMSR_HBCMU_MESSAGE_FIRMWARE_OK               0x80000000
 /*
 *******************************************************************************
 **    ARECA SCSI COMMAND DESCRIPTOR BLOCK size 0x1F8 (504)
@@ -343,156 +346,159 @@ struct FIRMWARE_INFO
 */
 struct ARCMSR_CDB
 {
-       uint8_t                                                 Bus;
-       uint8_t                                                 TargetID;
-       uint8_t                                                 LUN;
-       uint8_t                                                 Function;
-       uint8_t                                                 CdbLength;
-       uint8_t                                                 sgcount;
-       uint8_t                                                 Flags;
-#define ARCMSR_CDB_FLAG_SGL_BSIZE          0x01
-#define ARCMSR_CDB_FLAG_BIOS               0x02
-#define ARCMSR_CDB_FLAG_WRITE              0x04
-#define ARCMSR_CDB_FLAG_SIMPLEQ            0x00
-#define ARCMSR_CDB_FLAG_HEADQ              0x08
-#define ARCMSR_CDB_FLAG_ORDEREDQ           0x10
+       uint8_t Bus;
+       uint8_t TargetID;
+       uint8_t LUN;
+       uint8_t Function;
+       uint8_t CdbLength;
+       uint8_t sgcount;
+       uint8_t Flags;
+#define ARCMSR_CDB_FLAG_SGL_BSIZE      0x01
+#define ARCMSR_CDB_FLAG_BIOS           0x02
+#define ARCMSR_CDB_FLAG_WRITE          0x04
+#define ARCMSR_CDB_FLAG_SIMPLEQ                0x00
+#define ARCMSR_CDB_FLAG_HEADQ          0x08
+#define ARCMSR_CDB_FLAG_ORDEREDQ       0x10
+
+       uint8_t msgPages;
+       uint32_t msgContext;
+       uint32_t DataLength;
+       uint8_t Cdb[16];
+       uint8_t DeviceStatus;
+#define ARCMSR_DEV_CHECK_CONDITION     0x02
+#define ARCMSR_DEV_SELECT_TIMEOUT      0xF0
+#define ARCMSR_DEV_ABORTED             0xF1
+#define ARCMSR_DEV_INIT_FAIL           0xF2

-       uint8_t                                                 msgPages;
-       uint32_t                                                msgContext;
-       uint32_t                                                DataLength;
-       uint8_t                                                 Cdb[16];
-       uint8_t                                                 DeviceStatus;
-#define ARCMSR_DEV_CHECK_CONDITION         0x02
-#define ARCMSR_DEV_SELECT_TIMEOUT          0xF0
-#define ARCMSR_DEV_ABORTED                 0xF1
-#define ARCMSR_DEV_INIT_FAIL               0xF2
-
-       uint8_t                                                 SenseData[15];
-       union
-       {
-               struct SG32ENTRY                sg32entry[1];
-               struct SG64ENTRY                sg64entry[1];
+       uint8_t SenseData[15];
+       union {
+               struct SG32ENTRY sg32entry[1];
+               struct SG64ENTRY sg64entry[1];
        } u;
 };
 /*
 *******************************************************************************
-**     Messaging Unit (MU) of the Intel R 80331 I/O processor(Type A)
and Type B processor
+**     Messaging Unit (MU) of the Intel R 80331 I/O processor(Type A)
 *******************************************************************************
 */
 struct MessageUnit_A
 {
-       uint32_t        resrved0[4];                    /*0000 000F*/
-       uint32_t        inbound_msgaddr0;               /*0010 0013*/
-       uint32_t        inbound_msgaddr1;               /*0014 0017*/
-       uint32_t        outbound_msgaddr0;              /*0018 001B*/
-       uint32_t        outbound_msgaddr1;              /*001C 001F*/
-       uint32_t        inbound_doorbell;               /*0020 0023*/
-       uint32_t        inbound_intstatus;              /*0024 0027*/
-       uint32_t        inbound_intmask;                /*0028 002B*/
-       uint32_t        outbound_doorbell;              /*002C 002F*/
-       uint32_t        outbound_intstatus;             /*0030 0033*/
-       uint32_t        outbound_intmask;               /*0034 0037*/
-       uint32_t        reserved1[2];                   /*0038 003F*/
-       uint32_t        inbound_queueport;              /*0040 0043*/
-       uint32_t        outbound_queueport;             /*0044 0047*/
-       uint32_t        reserved2[2];                   /*0048 004F*/
-       uint32_t        reserved3[492];                 /*0050 07FF 492*/
-       uint32_t        reserved4[128];                 /*0800 09FF 128*/
-       uint32_t        message_rwbuffer[256];          /*0a00 0DFF 256*/
-       uint32_t        message_wbuffer[32];            /*0E00 0E7F  32*/
-       uint32_t        reserved5[32];                  /*0E80 0EFF  32*/
-       uint32_t        message_rbuffer[32];            /*0F00 0F7F  32*/
-       uint32_t        reserved6[32];                  /*0F80 0FFF  32*/
+       uint32_t resrved0[4];           /*0000 000F*/
+       uint32_t inbound_msgaddr0;      /*0010 0013*/
+       uint32_t inbound_msgaddr1;      /*0014 0017*/
+       uint32_t outbound_msgaddr0;     /*0018 001B*/
+       uint32_t outbound_msgaddr1;     /*001C 001F*/
+       uint32_t inbound_doorbell;      /*0020 0023*/
+       uint32_t inbound_intstatus;     /*0024 0027*/
+       uint32_t inbound_intmask;       /*0028 002B*/
+       uint32_t outbound_doorbell;     /*002C 002F*/
+       uint32_t outbound_intstatus;    /*0030 0033*/
+       uint32_t outbound_intmask;      /*0034 0037*/
+       uint32_t reserved1[2];          /*0038 003F*/
+       uint32_t inbound_queueport;     /*0040 0043*/
+       uint32_t outbound_queueport;    /*0044 0047*/
+       uint32_t reserved2[2];          /*0048 004F*/
+       uint32_t reserved3[492];        /*0050 07FF 492*/
+       uint32_t reserved4[128];        /*0800 09FF 128*/
+       uint32_t message_rwbuffer[256]; /*0a00 0DFF 256*/
+       uint32_t message_wbuffer[32];   /*0E00 0E7F  32*/
+       uint32_t reserved5[32];         /*0E80 0EFF  32*/
+       uint32_t message_rbuffer[32];   /*0F00 0F7F  32*/
+       uint32_t reserved6[32];         /*0F80 0FFF  32*/
 };
-
+/*
+*******************************************************************************
+**     Messaging Unit (MU) of Type B processor
+*******************************************************************************
+*/
 struct MessageUnit_B
 {
-       uint32_t        post_qbuffer[ARCMSR_MAX_HBB_POSTQUEUE];
+       uint32_t post_qbuffer[ARCMSR_MAX_HBB_POSTQUEUE];
        volatile uint32_t done_qbuffer[ARCMSR_MAX_HBB_POSTQUEUE];
-       uint32_t        postq_index;
+       uint32_t postq_index;
        volatile uint32_t doneq_index;
-       uint32_t                __iomem *drv2iop_doorbell;
-       uint32_t                __iomem *drv2iop_doorbell_mask;
-       uint32_t                __iomem *iop2drv_doorbell;
-       uint32_t                __iomem *iop2drv_doorbell_mask;
-       uint32_t                __iomem *message_rwbuffer;
-       uint32_t                __iomem *message_wbuffer;
-       uint32_t                __iomem *message_rbuffer;
+       uint32_t __iomem *drv2iop_doorbell;
+       uint32_t __iomem *drv2iop_doorbell_mask;
+       uint32_t __iomem *iop2drv_doorbell;
+       uint32_t __iomem *iop2drv_doorbell_mask;
+       uint32_t __iomem *message_rwbuffer;
+       uint32_t __iomem *message_wbuffer;
+       uint32_t __iomem *message_rbuffer;
 };
 /*
 *********************************************************************
-** LSI
+**     Messaging Unit (MU) of Type C processor(LSI)
 *********************************************************************
 */
-struct MessageUnit_C{
-       uint32_t        message_unit_status;                    /*0000 0003*/
-       uint32_t        slave_error_attribute;                  /*0004 0007*/
-       uint32_t        slave_error_address;                    /*0008 000B*/
-       uint32_t        posted_outbound_doorbell;               /*000C 000F*/
-       uint32_t        master_error_attribute;                 /*0010 0013*/
-       uint32_t        master_error_address_low;               /*0014 0017*/
-       uint32_t        master_error_address_high;              /*0018 001B*/
-       uint32_t        hcb_size;                               /*001C 001F*/
-       uint32_t        inbound_doorbell;                       /*0020 0023*/
-       uint32_t        diagnostic_rw_data;                     /*0024 0027*/
-       uint32_t        diagnostic_rw_address_low;              /*0028 002B*/
-       uint32_t        diagnostic_rw_address_high;             /*002C 002F*/
-       uint32_t        host_int_status;
 /*0030 0033*/
-       uint32_t        host_int_mask;                          /*0034 0037*/
-       uint32_t        dcr_data;                               /*0038 003B*/
-       uint32_t        dcr_address;                            /*003C 003F*/
-       uint32_t        inbound_queueport;                      /*0040 0043*/
-       uint32_t        outbound_queueport;                     /*0044 0047*/
-       uint32_t        hcb_pci_address_low;                    /*0048 004B*/
-       uint32_t        hcb_pci_address_high;                   /*004C 004F*/
-       uint32_t        iop_int_status;                         /*0050 0053*/
-       uint32_t        iop_int_mask;                           /*0054 0057*/
-       uint32_t        iop_inbound_queue_port;                 /*0058 005B*/
-       uint32_t        iop_outbound_queue_port;                /*005C 005F*/
-       uint32_t        inbound_free_list_index;
 /*0060 0063*/
-       uint32_t        inbound_post_list_index;
 /*0064 0067*/
-       uint32_t        outbound_free_list_index;
 /*0068 006B*/
-       uint32_t        outbound_post_list_index;
 /*006C 006F*/
-       uint32_t        inbound_doorbell_clear;                 /*0070 0073*/
-       uint32_t        i2o_message_unit_control;
 /*0074 0077*/
-       uint32_t        last_used_message_source_address_low;   /*0078 007B*/
-       uint32_t        last_used_message_source_address_high;  /*007C 007F*/
-       uint32_t        pull_mode_data_byte_count[4];           /*0080 008F*/
-       uint32_t        message_dest_address_index;             /*0090 0093*/
-       uint32_t        done_queue_not_empty_int_counter_timer; /*0094 0097*/
-       uint32_t        utility_A_int_counter_timer;            /*0098 009B*/
-       uint32_t        outbound_doorbell;                      /*009C 009F*/
-       uint32_t        outbound_doorbell_clear;
 /*00A0 00A3*/
-       uint32_t        message_source_address_index;           /*00A4 00A7*/
-       uint32_t        message_done_queue_index;               /*00A8 00AB*/
-       uint32_t        reserved0;                              /*00AC 00AF*/
-       uint32_t        inbound_msgaddr0;                       /*00B0 00B3*/
-       uint32_t        inbound_msgaddr1;                       /*00B4 00B7*/
-       uint32_t        outbound_msgaddr0;                      /*00B8 00BB*/
-       uint32_t        outbound_msgaddr1;                      /*00BC 00BF*/
-       uint32_t        inbound_queueport_low;                  /*00C0 00C3*/
-       uint32_t        inbound_queueport_high;                 /*00C4 00C7*/
-       uint32_t        outbound_queueport_low;                 /*00C8 00CB*/
-       uint32_t        outbound_queueport_high;                /*00CC 00CF*/
-       uint32_t        iop_inbound_queue_port_low;             /*00D0 00D3*/
-       uint32_t        iop_inbound_queue_port_high;            /*00D4 00D7*/
-       uint32_t        iop_outbound_queue_port_low;            /*00D8 00DB*/
-       uint32_t        iop_outbound_queue_port_high;           /*00DC 00DF*/
-       uint32_t        message_dest_queue_port_low;            /*00E0 00E3*/
-       uint32_t        message_dest_queue_port_high;           /*00E4 00E7*/
-       uint32_t        last_used_message_dest_address_low;     /*00E8 00EB*/
-       uint32_t        last_used_message_dest_address_high;    /*00EC 00EF*/
-       uint32_t        message_done_queue_base_address_low;    /*00F0 00F3*/
-       uint32_t        message_done_queue_base_address_high;   /*00F4 00F7*/
-       uint32_t        host_diagnostic;
 /*00F8 00FB*/
-       uint32_t        write_sequence;                         /*00FC 00FF*/
-       uint32_t        reserved1[34];                          /*0100 0187*/
-       uint32_t        reserved2[1950];
 /*0188 1FFF*/
-       uint32_t        message_wbuffer[32];                    /*2000 207F*/
-       uint32_t        reserved3[32];                          /*2080 20FF*/
-       uint32_t        message_rbuffer[32];                    /*2100 217F*/
-       uint32_t        reserved4[32];                          /*2180 21FF*/
-       uint32_t        msgcode_rwbuffer[256];                  /*2200 23FF*/
+struct MessageUnit_C {
+       uint32_t message_unit_status;                   /*0000 0003*/
+       uint32_t slave_error_attribute;                 /*0004 0007*/
+       uint32_t slave_error_address;                   /*0008 000B*/
+       uint32_t posted_outbound_doorbell;              /*000C 000F*/
+       uint32_t master_error_attribute;                /*0010 0013*/
+       uint32_t master_error_address_low;              /*0014 0017*/
+       uint32_t master_error_address_high;             /*0018 001B*/
+       uint32_t hcb_size;                              /*001C 001F*/
+       uint32_t inbound_doorbell;                      /*0020 0023*/
+       uint32_t diagnostic_rw_data;                    /*0024 0027*/
+       uint32_t diagnostic_rw_address_low;             /*0028 002B*/
+       uint32_t diagnostic_rw_address_high;            /*002C 002F*/
+       uint32_t host_int_status;                       /*0030 0033*/
+       uint32_t host_int_mask;                         /*0034 0037*/
+       uint32_t dcr_data;                              /*0038 003B*/
+       uint32_t dcr_address;                           /*003C 003F*/
+       uint32_t inbound_queueport;                     /*0040 0043*/
+       uint32_t outbound_queueport;                    /*0044 0047*/
+       uint32_t hcb_pci_address_low;                   /*0048 004B*/
+       uint32_t hcb_pci_address_high;                  /*004C 004F*/
+       uint32_t iop_int_status;                        /*0050 0053*/
+       uint32_t iop_int_mask;                          /*0054 0057*/
+       uint32_t iop_inbound_queue_port;                /*0058 005B*/
+       uint32_t iop_outbound_queue_port;               /*005C 005F*/
+       uint32_t inbound_free_list_index;               /*0060 0063*/
+       uint32_t inbound_post_list_index;               /*0064 0067*/
+       uint32_t outbound_free_list_index;              /*0068 006B*/
+       uint32_t outbound_post_list_index;              /*006C 006F*/
+       uint32_t inbound_doorbell_clear;                /*0070 0073*/
+       uint32_t i2o_message_unit_control;              /*0074 0077*/
+       uint32_t last_used_message_source_address_low;  /*0078 007B*/
+       uint32_t last_used_message_source_address_high; /*007C 007F*/
+       uint32_t pull_mode_data_byte_count[4];          /*0080 008F*/
+       uint32_t message_dest_address_index;            /*0090 0093*/
+       uint32_t done_queue_not_empty_int_counter_timer;/*0094 0097*/
+       uint32_t utility_A_int_counter_timer;           /*0098 009B*/
+       uint32_t outbound_doorbell;                     /*009C 009F*/
+       uint32_t outbound_doorbell_clear;               /*00A0 00A3*/
+       uint32_t message_source_address_index;          /*00A4 00A7*/
+       uint32_t message_done_queue_index;              /*00A8 00AB*/
+       uint32_t reserved0;                             /*00AC 00AF*/
+       uint32_t inbound_msgaddr0;                      /*00B0 00B3*/
+       uint32_t inbound_msgaddr1;                      /*00B4 00B7*/
+       uint32_t outbound_msgaddr0;                     /*00B8 00BB*/
+       uint32_t outbound_msgaddr1;                     /*00BC 00BF*/
+       uint32_t inbound_queueport_low;                 /*00C0 00C3*/
+       uint32_t inbound_queueport_high;                /*00C4 00C7*/
+       uint32_t outbound_queueport_low;                /*00C8 00CB*/
+       uint32_t outbound_queueport_high;               /*00CC 00CF*/
+       uint32_t iop_inbound_queue_port_low;            /*00D0 00D3*/
+       uint32_t iop_inbound_queue_port_high;           /*00D4 00D7*/
+       uint32_t iop_outbound_queue_port_low;           /*00D8 00DB*/
+       uint32_t iop_outbound_queue_port_high;          /*00DC 00DF*/
+       uint32_t message_dest_queue_port_low;           /*00E0 00E3*/
+       uint32_t message_dest_queue_port_high;          /*00E4 00E7*/
+       uint32_t last_used_message_dest_address_low;    /*00E8 00EB*/
+       uint32_t last_used_message_dest_address_high;   /*00EC 00EF*/
+       uint32_t message_done_queue_base_address_low;   /*00F0 00F3*/
+       uint32_t message_done_queue_base_address_high;  /*00F4 00F7*/
+       uint32_t host_diagnostic;                       /*00F8 00FB*/
+       uint32_t write_sequence;                        /*00FC 00FF*/
+       uint32_t reserved1[34];                         /*0100 0187*/
+       uint32_t reserved2[1950];                       /*0188 1FFF*/
+       uint32_t message_wbuffer[32];                   /*2000 207F*/
+       uint32_t reserved3[32];                         /*2080 20FF*/
+       uint32_t message_rbuffer[32];                   /*2100 217F*/
+       uint32_t reserved4[32];                         /*2180 21FF*/
+       uint32_t msgcode_rwbuffer[256];                 /*2200 23FF*/
 };
 /*
 *******************************************************************************
@@ -501,107 +507,106 @@ struct MessageUnit_C{
 */
 struct AdapterControlBlock
 {
-       uint32_t  adapter_type;                /* adapter A,B..... */
-       #define ACB_ADAPTER_TYPE_A            0x00000001        /* hba I IOP */
-       #define ACB_ADAPTER_TYPE_B            0x00000002        /* hbb M IOP */
-       #define ACB_ADAPTER_TYPE_C            0x00000004        /* hbc P IOP */
-       #define ACB_ADAPTER_TYPE_D            0x00000008        /* hbd A IOP */
+       uint32_t        adapter_type;   /* adapter A,B..... */
+       #define ACB_ADAPTER_TYPE_A      0x00000001      /* hba I IOP */
+       #define ACB_ADAPTER_TYPE_B      0x00000002      /* hbb M IOP */
+       #define ACB_ADAPTER_TYPE_C      0x00000004      /* hbc P IOP */
+       #define ACB_ADAPTER_TYPE_D      0x00000008      /* hbd A IOP */
        u32             roundup_ccbsize;
-       struct pci_dev *                pdev;
-       struct Scsi_Host *              host;
-       unsigned long                   vir2phy_offset;
+       struct pci_dev  *pdev;
+       struct Scsi_Host *host;
+       unsigned long   vir2phy_offset;
        struct msix_entry       entries[ARCMST_NUM_MSIX_VECTORS];
        /* Offset is used in making arc cdb physical to virtual calculations */
-       uint32_t                        outbound_int_enable;
-       uint32_t                        cdb_phyaddr_hi32;
-       uint32_t                        reg_mu_acc_handle0;
-       spinlock_t                      eh_lock;
-       spinlock_t                      ccblist_lock;
-       spinlock_t                      rqbuffer_lock;
-       spinlock_t                      wqbuffer_lock;
+       uint32_t        outbound_int_enable;
+       uint32_t        cdb_phyaddr_hi32;
+       spinlock_t      eh_lock;
+       spinlock_t      ccblist_lock;
+       spinlock_t      rqbuffer_lock;
+       spinlock_t      wqbuffer_lock;
        union {
-               struct MessageUnit_A __iomem *pmuA;
-               struct MessageUnit_B    *pmuB;
-               struct MessageUnit_C __iomem *pmuC;
+               struct MessageUnit_A __iomem    *pmuA;
+               struct MessageUnit_B            *pmuB;
+               struct MessageUnit_C __iomem    *pmuC;
        };
        /* message unit ATU inbound base address0 */
        void __iomem    *mem_base0;
        void __iomem    *mem_base1;
        uint32_t        acb_flags;
        u16             dev_id;
-       uint8_t                                 adapter_index;
-       #define ACB_F_SCSISTOPADAPTER           0x0001
-       #define ACB_F_MSG_STOP_BGRB             0x0002
+       uint8_t         adapter_index;
+       #define ACB_F_SCSISTOPADAPTER           0x0001
+       #define ACB_F_MSG_STOP_BGRB             0x0002
        /* stop RAID background rebuild */
-       #define ACB_F_MSG_START_BGRB            0x0004
+       #define ACB_F_MSG_START_BGRB            0x0004
        /* stop RAID background rebuild */
-       #define ACB_F_IOPDATA_OVERFLOW          0x0008
+       #define ACB_F_IOPDATA_OVERFLOW          0x0008
        /* iop message data rqbuffer overflow */
        #define ACB_F_MESSAGE_WQBUFFER_CLEARED  0x0010
        /* message clear wqbuffer */
-       #define ACB_F_MESSAGE_RQBUFFER_CLEARED  0x0020
+       #define ACB_F_MESSAGE_RQBUFFER_CLEARED  0x0020
        /* message clear rqbuffer */
-       #define ACB_F_MESSAGE_WQBUFFER_READED   0x0040
-       #define ACB_F_BUS_RESET                 0x0080
-       #define ACB_F_BUS_HANG_ON               0x0800/* need hardware
reset bus */
+       #define ACB_F_MESSAGE_WQBUFFER_READED   0x0040
+       #define ACB_F_BUS_RESET                 0x0080
+       #define ACB_F_BUS_HANG_ON               0x0800

-       #define ACB_F_IOP_INITED                0x0100
+       #define ACB_F_IOP_INITED                0x0100
        /* iop init */
        #define ACB_F_ABORT                     0x0200
-       #define ACB_F_FIRMWARE_TRAP             0x0400
+       #define ACB_F_FIRMWARE_TRAP             0x0400
        #define ACB_F_MSI_ENABLED               0x1000
        #define ACB_F_MSIX_ENABLED              0x2000
-       struct CommandControlBlock *
pccb_pool[ARCMSR_MAX_FREECCB_NUM];
+       struct CommandControlBlock      *pccb_pool[ARCMSR_MAX_FREECCB_NUM];
        /* used for memory free */
-       struct list_head                ccb_free_list;
+       struct list_head        ccb_free_list;
        /* head of free ccb list */

-       atomic_t                        ccboutstandingcount;
-       /*The present outstanding command number that in the IOP that
-                                       waiting for being handled by FW*/
+       atomic_t        ccboutstandingcount;
+       /* The present outstanding command number that in the IOP that
+                                       waiting for being handled by FW */

-       void *                          dma_coherent;
+       void            *dma_coherent;
        /* dma_coherent used for memory free */
-       dma_addr_t                      dma_coherent_handle;
+       dma_addr_t      dma_coherent_handle;
        /* dma_coherent_handle used for memory free */
-       dma_addr_t                      dma_coherent_handle2;
-       void                            *dma_coherent2;
-       unsigned int                    uncache_size;
-       uint8_t                         rqbuffer[ARCMSR_MAX_QBUFFER];
+       dma_addr_t      dma_coherent_handle2;
+       void            *dma_coherent2;
+       unsigned int    uncache_size;
+       uint8_t         rqbuffer[ARCMSR_MAX_QBUFFER];
        /* data collection buffer for read from 80331 */
-       int32_t                         rqbuf_firstindex;
+       uint32_t        rqbuf_firstindex;
        /* first of read buffer  */
-       int32_t                         rqbuf_lastindex;
+       uint32_t        rqbuf_lastindex;
        /* last of read buffer   */
-       uint8_t                         wqbuffer[ARCMSR_MAX_QBUFFER];
+       uint8_t         wqbuffer[ARCMSR_MAX_QBUFFER];
        /* data collection buffer for write to 80331  */
-       int32_t                         wqbuf_firstindex;
+       uint32_t        wqbuf_firstindex;
        /* first of write buffer */
-       int32_t                         wqbuf_lastindex;
+       uint32_t        wqbuf_lastindex;
        /* last of write buffer  */
-       uint8_t
devstate[ARCMSR_MAX_TARGETID][ARCMSR_MAX_TARGETLUN];
+       uint8_t         devstate[ARCMSR_MAX_TARGETID][ARCMSR_MAX_TARGETLUN];
        /* id0 ..... id15, lun0...lun7 */
-#define ARECA_RAID_GONE               0x55
-#define ARECA_RAID_GOOD               0xaa
-       uint32_t                        num_resets;
-       uint32_t                        num_aborts;
-       uint32_t                        signature;
-       uint32_t                        firm_request_len;
-       uint32_t                        firm_numbers_queue;
-       uint32_t                        firm_sdram_size;
-       uint32_t                        firm_hd_channels;
-       uint32_t                                firm_cfg_version;
-       char                    firm_model[12];
-       char                    firm_version[20];
-       char                    device_map[20];                 /*21,84-99*/
-       struct work_struct              arcmsr_do_message_isr_bh;
-       struct timer_list               eternal_timer;
-       unsigned short          fw_flag;
-                               #define FW_NORMAL       0x0000
-                               #define FW_BOG          0x0001
-                               #define FW_DEADLOCK     0x0010
-       atomic_t                        rq_map_token;
-       atomic_t                        ante_token_value;
+       #define ARECA_RAID_GONE         0x55
+       #define ARECA_RAID_GOOD         0xaa
+       uint32_t        num_resets;
+       uint32_t        num_aborts;
+       uint32_t        signature;
+       uint32_t        firm_request_len;
+       uint32_t        firm_numbers_queue;
+       uint32_t        firm_sdram_size;
+       uint32_t        firm_hd_channels;
+       uint32_t        firm_cfg_version;
+       char            firm_model[12];
+       char            firm_version[20];
+       char            device_map[20]; /*21,84-99*/
+       struct work_struct      arcmsr_do_message_isr_bh;
+       struct timer_list       eternal_timer;
+       unsigned short  fw_flag;
+       #define FW_NORMAL       0x0000
+       #define FW_BOG          0x0001
+       #define FW_DEADLOCK     0x0010
+       atomic_t        rq_map_token;
+       atomic_t        ante_token_value;
        uint32_t        maxOutstanding;
 };/* HW_DEVICE_EXTENSION */
 /*
@@ -610,33 +615,33 @@ struct AdapterControlBlock
 **             this CCB length must be 32 bytes boundary
 *******************************************************************************
 */
-struct CommandControlBlock{
-       /*x32:sizeof struct_CCB=(32+60)byte, x64:sizeof struct_CCB=(64+60)byte*/
-       struct list_head                list;
 /*x32: 8byte, x64: 16byte*/
-       struct scsi_cmnd                *pcmd;
 /*8 bytes pointer of linux scsi command */
-       struct AdapterControlBlock      *acb;
 /*x32: 4byte, x64: 8byte*/
-       uint32_t                        cdb_phyaddr;
 /*x32: 4byte, x64: 4byte*/
-       uint32_t                        arc_cdb_size;
 /*x32:4byte,x64:4byte*/
-       uint16_t                        ccb_flags;
 /*x32: 2byte, x64: 2byte*/
-       #define                 CCB_FLAG_READ                   0x0000
-       #define                 CCB_FLAG_WRITE          0x0001
-       #define                 CCB_FLAG_ERROR          0x0002
-       #define                 CCB_FLAG_FLUSHCACHE             0x0004
-       #define                 CCB_FLAG_MASTER_ABORTED 0x0008
-       uint16_t                                startdone;
         /*x32:2byte,x32:2byte*/
-       #define                 ARCMSR_CCB_DONE                         0x0000
-       #define                 ARCMSR_CCB_START                0x55AA
-       #define                 ARCMSR_CCB_ABORTED              0xAA55
-       #define                 ARCMSR_CCB_ILLEGAL              0xFFFF
-       #if BITS_PER_LONG == 64
+struct CommandControlBlock {
+/*x32:sizeof struct_CCB=(32+60)byte, x64:sizeof struct_CCB=(64+60)byte*/
+       struct list_head        list;
+       struct scsi_cmnd        *pcmd;
+       struct AdapterControlBlock      *acb;
+       uint32_t        cdb_phyaddr;
+       uint32_t        arc_cdb_size;
+       uint16_t        ccb_flags;
+       #define CCB_FLAG_READ           0x0000
+       #define CCB_FLAG_WRITE          0x0001
+       #define CCB_FLAG_ERROR          0x0002
+       #define CCB_FLAG_FLUSHCACHE     0x0004
+       #define CCB_FLAG_MASTER_ABORTED 0x0008
+       uint16_t        startdone;
+       #define ARCMSR_CCB_DONE         0x0000
+       #define ARCMSR_CCB_START        0x55AA
+       #define ARCMSR_CCB_ABORTED      0xAA55
+       #define ARCMSR_CCB_ILLEGAL      0xFFFF
+#if BITS_PER_LONG == 64
        /*  ======================512+64 bytes========================  */
-               uint32_t                                reserved[5];
         /*24 byte*/
-       #else
-       /*  ======================512+32 bytes========================  */
-               uint32_t                                reserved;
         /*8  byte*/
-       #endif
-       /*  =======================================================   */
-       struct ARCMSR_CDB               arcmsr_cdb;
+       uint32_t        reserved[5];    /*24 byte*/
+#else
+       /*======================512+32 bytes========================*/
+       uint32_t        reserved;       /*8  byte*/
+#endif
+       /*=======================================================*/
+       struct ARCMSR_CDB       arcmsr_cdb;
 };
 /*
 *******************************************************************************
@@ -645,53 +650,53 @@ struct CommandControlBlock{
 */
 struct SENSE_DATA
 {
-       uint8_t                         ErrorCode:7;
+       uint8_t ErrorCode:7;
 #define SCSI_SENSE_CURRENT_ERRORS      0x70
 #define SCSI_SENSE_DEFERRED_ERRORS     0x71
-       uint8_t                         Valid:1;
-       uint8_t                         SegmentNumber;
-       uint8_t                         SenseKey:4;
-       uint8_t                         Reserved:1;
-       uint8_t                         IncorrectLength:1;
-       uint8_t                         EndOfMedia:1;
-       uint8_t                         FileMark:1;
-       uint8_t                         Information[4];
-       uint8_t                         AdditionalSenseLength;
-       uint8_t                         CommandSpecificInformation[4];
-       uint8_t                         AdditionalSenseCode;
-       uint8_t                         AdditionalSenseCodeQualifier;
-       uint8_t                         FieldReplaceableUnitCode;
-       uint8_t                         SenseKeySpecific[3];
+       uint8_t Valid:1;
+       uint8_t SegmentNumber;
+       uint8_t SenseKey:4;
+       uint8_t Reserved:1;
+       uint8_t IncorrectLength:1;
+       uint8_t EndOfMedia:1;
+       uint8_t FileMark:1;
+       uint8_t Information[4];
+       uint8_t AdditionalSenseLength;
+       uint8_t CommandSpecificInformation[4];
+       uint8_t AdditionalSenseCode;
+       uint8_t AdditionalSenseCodeQualifier;
+       uint8_t FieldReplaceableUnitCode;
+       uint8_t SenseKeySpecific[3];
 };
 /*
 *******************************************************************************
 **  Outbound Interrupt Status Register - OISR
 *******************************************************************************
 */
-#define     ARCMSR_MU_OUTBOUND_INTERRUPT_STATUS_REG                 0x30
-#define     ARCMSR_MU_OUTBOUND_PCI_INT                              0x10
-#define     ARCMSR_MU_OUTBOUND_POSTQUEUE_INT                        0x08
-#define     ARCMSR_MU_OUTBOUND_DOORBELL_INT                         0x04
-#define     ARCMSR_MU_OUTBOUND_MESSAGE1_INT                         0x02
-#define     ARCMSR_MU_OUTBOUND_MESSAGE0_INT                         0x01
-#define     ARCMSR_MU_OUTBOUND_HANDLE_INT                 \
-                    (ARCMSR_MU_OUTBOUND_MESSAGE0_INT      \
-                     |ARCMSR_MU_OUTBOUND_MESSAGE1_INT     \
-                     |ARCMSR_MU_OUTBOUND_DOORBELL_INT     \
-                     |ARCMSR_MU_OUTBOUND_POSTQUEUE_INT    \
-                     |ARCMSR_MU_OUTBOUND_PCI_INT)
+#define ARCMSR_MU_OUTBOUND_INTERRUPT_STATUS_REG        0x30
+#define ARCMSR_MU_OUTBOUND_PCI_INT             0x10
+#define ARCMSR_MU_OUTBOUND_POSTQUEUE_INT       0x08
+#define ARCMSR_MU_OUTBOUND_DOORBELL_INT                0x04
+#define ARCMSR_MU_OUTBOUND_MESSAGE1_INT                0x02
+#define ARCMSR_MU_OUTBOUND_MESSAGE0_INT                0x01
+#define ARCMSR_MU_OUTBOUND_HANDLE_INT  \
+       (ARCMSR_MU_OUTBOUND_MESSAGE0_INT        \
+       |ARCMSR_MU_OUTBOUND_MESSAGE1_INT        \
+       |ARCMSR_MU_OUTBOUND_DOORBELL_INT        \
+       |ARCMSR_MU_OUTBOUND_POSTQUEUE_INT       \
+       |ARCMSR_MU_OUTBOUND_PCI_INT)
 /*
 *******************************************************************************
 **  Outbound Interrupt Mask Register - OIMR
 *******************************************************************************
 */
-#define     ARCMSR_MU_OUTBOUND_INTERRUPT_MASK_REG                   0x34
-#define     ARCMSR_MU_OUTBOUND_PCI_INTMASKENABLE                    0x10
-#define     ARCMSR_MU_OUTBOUND_POSTQUEUE_INTMASKENABLE              0x08
-#define     ARCMSR_MU_OUTBOUND_DOORBELL_INTMASKENABLE               0x04
-#define     ARCMSR_MU_OUTBOUND_MESSAGE1_INTMASKENABLE               0x02
-#define     ARCMSR_MU_OUTBOUND_MESSAGE0_INTMASKENABLE               0x01
-#define     ARCMSR_MU_OUTBOUND_ALL_INTMASKENABLE                    0x1F
+#define ARCMSR_MU_OUTBOUND_INTERRUPT_MASK_REG          0x34
+#define ARCMSR_MU_OUTBOUND_PCI_INTMASKENABLE           0x10
+#define ARCMSR_MU_OUTBOUND_POSTQUEUE_INTMASKENABLE     0x08
+#define ARCMSR_MU_OUTBOUND_DOORBELL_INTMASKENABLE      0x04
+#define ARCMSR_MU_OUTBOUND_MESSAGE1_INTMASKENABLE      0x02
+#define ARCMSR_MU_OUTBOUND_MESSAGE0_INTMASKENABLE      0x01
+#define ARCMSR_MU_OUTBOUND_ALL_INTMASKENABLE           0x1F

 extern void arcmsr_write_ioctldata2iop(struct AdapterControlBlock *);
 extern uint32_t arcmsr_Read_iop_rqbuffer_data(struct AdapterControlBlock *,
@@ -701,4 +706,3 @@ extern struct QBUFFER __iomem *arcmsr_ge
 extern struct device_attribute *arcmsr_host_attrs[];
 extern int arcmsr_alloc_sysfs_attr(struct AdapterControlBlock *);
 void arcmsr_free_sysfs_attr(struct AdapterControlBlock *acb);
-
diff -uprN a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
--- a/drivers/scsi/arcmsr/arcmsr_hba.c  2014-02-20 19:10:08.000000000 +0800
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c  2014-02-20 19:11:05.000000000 +0800
@@ -2,11 +2,10 @@
 *******************************************************************************
 **        O.S   : Linux
 **   FILE NAME  : arcmsr_hba.c
-**        BY    : Nick Cheng
-**   Description: SCSI RAID Device Driver for
-**                ARECA RAID Host adapter
+**        BY    : Nick Cheng, C.L. Huang
+**   Description: SCSI RAID Device Driver for Areca RAID Controller
 *******************************************************************************
-** Copyright (C) 2002 - 2005, Areca Technology Corporation All rights reserved
+** Copyright (C) 2002 - 2013, Areca Technology Corporation All rights reserved
 **
 **     Web site: www.areca.com.tw
 **       E-mail: support@areca.com.tw
@@ -70,13 +69,13 @@
 #include <scsi/scsi_transport.h>
 #include <scsi/scsicam.h>
 #include "arcmsr.h"
-MODULE_AUTHOR("Nick Cheng <support@areca.com.tw>");
-MODULE_DESCRIPTION("ARECA (ARC11xx/12xx/16xx/1880) SATA/SAS RAID Host
Bus Adapter");
+MODULE_AUTHOR("Nick Cheng, Ching Huang <support@areca.com.tw>");
+MODULE_DESCRIPTION("Areca ARC11xx/12xx/16xx/188x SAS/SATA RAID
Controller Driver");
 MODULE_LICENSE("Dual BSD/GPL");
 MODULE_VERSION(ARCMSR_DRIVER_VERSION);

-#define        ARCMSR_SLEEPTIME        10
-#define        ARCMSR_RETRYCOUNT       12
+#define ARCMSR_SLEEPTIME       10
+#define ARCMSR_RETRYCOUNT      12

 static wait_queue_head_t wait_q;
 static int arcmsr_iop_message_xfer(struct AdapterControlBlock *acb,
@@ -98,19 +97,14 @@ static u32 arcmsr_disable_outbound_ints(
 static void arcmsr_enable_outbound_ints(struct AdapterControlBlock *acb,
        u32 intmask_org);
 static void arcmsr_stop_adapter_bgrb(struct AdapterControlBlock *acb);
-static void arcmsr_hbaA_flush_cache(struct AdapterControlBlock *acb);
-static void arcmsr_hbaB_flush_cache(struct AdapterControlBlock *acb);
 static void arcmsr_request_device_map(unsigned long pacb);
-static void arcmsr_hbaA_request_device_map(struct AdapterControlBlock *acb);
-static void arcmsr_hbaB_request_device_map(struct AdapterControlBlock *acb);
-static void arcmsr_hbaC_request_device_map(struct AdapterControlBlock *acb);
 static void arcmsr_message_isr_bh_fn(struct work_struct *work);
 static bool arcmsr_get_firmware_spec(struct AdapterControlBlock *acb);
 static void arcmsr_start_adapter_bgrb(struct AdapterControlBlock *acb);
 static void arcmsr_hbaC_message_isr(struct AdapterControlBlock *pACB);
-static void arcmsr_hardware_reset(struct AdapterControlBlock *acb);
 static const char *arcmsr_info(struct Scsi_Host *);
 static irqreturn_t arcmsr_interrupt(struct AdapterControlBlock *acb);
+
 static int arcmsr_adjust_disk_queue_depth(struct scsi_device *sdev,
                                          int queue_depth, int reason)
 {
@@ -125,23 +119,21 @@ static int arcmsr_adjust_disk_queue_dept

 static struct scsi_host_template arcmsr_scsi_host_template = {
        .module                 = THIS_MODULE,
-       .name                   = "ARCMSR ARECA SATA/SAS RAID Controller"
-                               ARCMSR_DRIVER_VERSION,
+       .name                   = "Areca SAS/SATA RAID driver",
        .info                   = arcmsr_info,
        .queuecommand           = arcmsr_queue_command,
-       .eh_abort_handler               = arcmsr_abort,
+       .eh_abort_handler       = arcmsr_abort,
        .eh_bus_reset_handler   = arcmsr_bus_reset,
        .bios_param             = arcmsr_bios_param,
        .change_queue_depth     = arcmsr_adjust_disk_queue_depth,
        .can_queue              = ARCMSR_MAX_FREECCB_NUM,
-       .this_id                        = ARCMSR_SCSI_INITIATOR_ID,
-       .sg_tablesize                   = ARCMSR_DEFAULT_SG_ENTRIES,
-       .max_sectors                    = ARCMSR_MAX_XFER_SECTORS_C,
+       .this_id                = ARCMSR_SCSI_INITIATOR_ID,
        .cmd_per_lun            = ARCMSR_MAX_CMD_PERLUN,
        .use_clustering         = ENABLE_CLUSTERING,
        .shost_attrs            = arcmsr_host_attrs,
        .no_write_same          = 1,
 };
+
 static struct pci_device_id arcmsr_device_id_table[] = {
        {PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1110)},
        {PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1120)},
@@ -164,6 +156,7 @@ static struct pci_device_id arcmsr_devic
        {PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1880)},
        {0, 0}, /* Terminating entry */
 };
+
 MODULE_DEVICE_TABLE(pci, arcmsr_device_id_table);
 static struct pci_driver arcmsr_pci_driver = {
        .name                   = "arcmsr",
@@ -178,7 +171,6 @@ static struct pci_driver arcmsr_pci_driv
 ****************************************************************************
 ****************************************************************************
 */
-
 static void arcmsr_free_mu(struct AdapterControlBlock *acb)
 {
        switch (acb->adapter_type) {
@@ -193,40 +185,51 @@ static void arcmsr_free_mu(struct Adapte
 static bool arcmsr_remap_pciregion(struct AdapterControlBlock *acb)
 {
        struct pci_dev *pdev = acb->pdev;
-       switch (acb->adapter_type){
-       case ACB_ADAPTER_TYPE_A:{
-               acb->pmuA = ioremap(pci_resource_start(pdev,0),
pci_resource_len(pdev,0));
+
+       switch (acb->adapter_type) {
+       case ACB_ADAPTER_TYPE_A: {
+               acb->pmuA = ioremap(pci_resource_start(pdev, 0),
+                       pci_resource_len(pdev, 0));
                if (!acb->pmuA) {
-                       printk(KERN_NOTICE "arcmsr%d: memory mapping
region fail \n", acb->host->host_no);
+                       pr_notice("arcmsr%d: memory mapping "
+                               "region fail\n", acb->host->host_no);
                        return false;
                }
                break;
        }
-       case ACB_ADAPTER_TYPE_B:{
+       case ACB_ADAPTER_TYPE_B: {
                void __iomem *mem_base0, *mem_base1;
-               mem_base0 = ioremap(pci_resource_start(pdev, 0),
pci_resource_len(pdev, 0));
+               mem_base0 = ioremap(pci_resource_start(pdev, 0),
+                       pci_resource_len(pdev, 0));
                if (!mem_base0) {
-                       printk(KERN_NOTICE "arcmsr%d: memory mapping
region fail \n", acb->host->host_no);
+                       pr_notice("arcmsr%d: memory mapping "
+                               "region fail\n", acb->host->host_no);
                        return false;
                }
-               mem_base1 = ioremap(pci_resource_start(pdev, 2),
pci_resource_len(pdev, 2));
+               mem_base1 = ioremap(pci_resource_start(pdev, 2),
+                       pci_resource_len(pdev, 2));
                if (!mem_base1) {
                        iounmap(mem_base0);
-                       printk(KERN_NOTICE "arcmsr%d: memory mapping
region fail \n", acb->host->host_no);
+                       pr_notice("arcmsr%d: memory mapping "
+                               "region fail\n", acb->host->host_no);
                        return false;
                }
                acb->mem_base0 = mem_base0;
                acb->mem_base1 = mem_base1;
                break;
        }
-       case ACB_ADAPTER_TYPE_C:{
-               acb->pmuC = ioremap_nocache(pci_resource_start(pdev,
1), pci_resource_len(pdev, 1));
+       case ACB_ADAPTER_TYPE_C: {
+               acb->pmuC = ioremap_nocache(pci_resource_start(pdev, 1),
+                       pci_resource_len(pdev, 1));
                if (!acb->pmuC) {
-                       printk(KERN_NOTICE "arcmsr%d: memory mapping
region fail \n", acb->host->host_no);
+                       pr_notice("arcmsr%d: memory mapping "
+                               "region fail\n", acb->host->host_no);
                        return false;
                }
-               if (readl(&acb->pmuC->outbound_doorbell) &
ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE) {
-
writel(ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE_DOORBELL_CLEAR,
&acb->pmuC->outbound_doorbell_clear);/*clear interrupt*/
+               if (readl(&acb->pmuC->outbound_doorbell) &
+                       ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE) {
+
writel(ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE_DOORBELL_CLEAR,
+                               &acb->pmuC->outbound_doorbell_clear);
                        return true;
                }
                break;
@@ -238,19 +241,16 @@ static bool arcmsr_remap_pciregion(struc
 static void arcmsr_unmap_pciregion(struct AdapterControlBlock *acb)
 {
        switch (acb->adapter_type) {
-       case ACB_ADAPTER_TYPE_A:{
+       case ACB_ADAPTER_TYPE_A:
                iounmap(acb->pmuA);
-       }
-       break;
-       case ACB_ADAPTER_TYPE_B:{
+               break;
+       case ACB_ADAPTER_TYPE_B:
                iounmap(acb->mem_base0);
                iounmap(acb->mem_base1);
-       }
-
-       break;
-       case ACB_ADAPTER_TYPE_C:{
+               break;
+       case ACB_ADAPTER_TYPE_C:
                iounmap(acb->pmuC);
-       }
+               break;
        }
 }

@@ -267,7 +267,7 @@ static int arcmsr_bios_param(struct scsi
                struct block_device *bdev, sector_t capacity, int *geom)
 {
        int ret, heads, sectors, cylinders, total_capacity;
-       unsigned char *buffer;/* return copy of block device's
partition table */
+       unsigned char *buffer;

        buffer = scsi_bios_ptable(bdev);
        if (buffer) {
@@ -331,7 +331,8 @@ arcmsr_define_adapter_type(struct Adapte
        return true;
 }

-static uint8_t arcmsr_hbaA_wait_msgint_ready(struct AdapterControlBlock *acb)
+static bool
+arcmsr_hbaA_wait_msgint_ready(struct AdapterControlBlock *acb)
 {
        struct MessageUnit_A __iomem *reg = acb->pmuA;
        int i;
@@ -345,11 +346,11 @@ static uint8_t arcmsr_hbaA_wait_msgint_r
                }
                msleep(10);
        } /* max 20 seconds */
-
        return false;
 }

-static uint8_t arcmsr_hbaB_wait_msgint_ready(struct AdapterControlBlock *acb)
+static bool
+arcmsr_hbaB_wait_msgint_ready(struct AdapterControlBlock *acb)
 {
        struct MessageUnit_B *reg = acb->pmuB;
        int i;
@@ -358,104 +359,112 @@ static uint8_t arcmsr_hbaB_wait_msgint_r
                if (readl(reg->iop2drv_doorbell)
                        & ARCMSR_IOP2DRV_MESSAGE_CMD_DONE) {
                        writel(ARCMSR_MESSAGE_INT_CLEAR_PATTERN,
-                                       reg->iop2drv_doorbell);
+                               reg->iop2drv_doorbell);
                        writel(ARCMSR_DRV2IOP_END_OF_INTERRUPT,
-                                       reg->drv2iop_doorbell);
+                               reg->drv2iop_doorbell);
                        return true;
                }
                msleep(10);
        } /* max 20 seconds */
-
        return false;
 }

-static uint8_t arcmsr_hbaC_wait_msgint_ready(struct AdapterControlBlock *pACB)
+static bool
+arcmsr_hbaC_wait_msgint_ready(struct AdapterControlBlock *pACB)
 {
        struct MessageUnit_C __iomem *phbcmu = pACB->pmuC;
        int i;

        for (i = 0; i < 2000; i++) {
                if (readl(&phbcmu->outbound_doorbell)
-                               & ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE) {
+                       & ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE) {

writel(ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE_DOORBELL_CLEAR,
-                               &phbcmu->outbound_doorbell_clear);
/*clear interrupt*/
+                               &phbcmu->outbound_doorbell_clear);
                        return true;
                }
                msleep(10);
        } /* max 20 seconds */
-
        return false;
 }

-static void arcmsr_hbaA_flush_cache(struct AdapterControlBlock *acb)
+static void
+arcmsr_hbaA_flush_cache(struct AdapterControlBlock *acb)
 {
        struct MessageUnit_A __iomem *reg = acb->pmuA;
        int retry_count = 30;
+
        writel(ARCMSR_INBOUND_MESG0_FLUSH_CACHE, &reg->inbound_msgaddr0);
        do {
                if (arcmsr_hbaA_wait_msgint_ready(acb))
                        break;
                else {
                        retry_count--;
-                       printk(KERN_NOTICE "arcmsr%d: wait 'flush
adapter cache' \
-                       timeout, retry count down = %d \n",
acb->host->host_no, retry_count);
+                       pr_notice("arcmsr%d: wait 'flush adapter "
+                               "cache' timeout, retry count down = %d\n",
+                               acb->host->host_no, retry_count);
                }
        } while (retry_count != 0);
 }

-static void arcmsr_hbaB_flush_cache(struct AdapterControlBlock *acb)
+static void
+arcmsr_hbaB_flush_cache(struct AdapterControlBlock *acb)
 {
        struct MessageUnit_B *reg = acb->pmuB;
        int retry_count = 30;
+
        writel(ARCMSR_MESSAGE_FLUSH_CACHE, reg->drv2iop_doorbell);
        do {
                if (arcmsr_hbaB_wait_msgint_ready(acb))
                        break;
                else {
                        retry_count--;
-                       printk(KERN_NOTICE "arcmsr%d: wait 'flush
adapter cache' \
-                       timeout,retry count down = %d \n",
acb->host->host_no, retry_count);
+                       pr_notice("arcmsr%d: wait 'flush adapter "
+                               "cache' timeout, retry count down = %d\n",
+                               acb->host->host_no, retry_count);
                }
        } while (retry_count != 0);
 }

-static void arcmsr_hbaC_flush_cache(struct AdapterControlBlock *pACB)
+static void
+arcmsr_hbaC_flush_cache(struct AdapterControlBlock *pACB)
 {
        struct MessageUnit_C __iomem *reg = pACB->pmuC;
-       int retry_count = 30;/* enlarge wait flush adapter cache time:
10 minute */
+       int retry_count = 6;
+
        writel(ARCMSR_INBOUND_MESG0_FLUSH_CACHE, &reg->inbound_msgaddr0);
        writel(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE, &reg->inbound_doorbell);
+       readl(&reg->inbound_doorbell);
+       readl(&reg->inbound_msgaddr0);
        do {
-               if (arcmsr_hbaC_wait_msgint_ready(pACB)) {
+               if (arcmsr_hbaC_wait_msgint_ready(pACB))
                        break;
-               } else {
+               else {
                        retry_count--;
-                       printk(KERN_NOTICE "arcmsr%d: wait 'flush
adapter cache' \
-                       timeout,retry count down = %d \n",
pACB->host->host_no, retry_count);
+                       pr_notice("arcmsr%d: wait 'flush adapter "
+                               "cache' timeout, retry count down = %d\n",
+                               pACB->host->host_no, retry_count);
                }
        } while (retry_count != 0);
-       return;
 }
-static void arcmsr_flush_adapter_cache(struct AdapterControlBlock *acb)
+
+static void
+arcmsr_flush_adapter_cache(struct AdapterControlBlock *acb)
 {
        switch (acb->adapter_type) {
-
-       case ACB_ADAPTER_TYPE_A: {
+       case ACB_ADAPTER_TYPE_A:
                arcmsr_hbaA_flush_cache(acb);
-               }
                break;
-
-       case ACB_ADAPTER_TYPE_B: {
+       case ACB_ADAPTER_TYPE_B:
                arcmsr_hbaB_flush_cache(acb);
-               }
                break;
-       case ACB_ADAPTER_TYPE_C: {
+       case ACB_ADAPTER_TYPE_C:
                arcmsr_hbaC_flush_cache(acb);
-               }
+               break;
        }
 }

-static int arcmsr_alloc_ccb_pool(struct AdapterControlBlock *acb)
+static int
+arcmsr_alloc_ccb_pool(struct AdapterControlBlock *acb)
 {
        struct pci_dev *pdev = acb->pdev;
        void *dma_coherent;
@@ -468,41 +477,55 @@ static int arcmsr_alloc_ccb_pool(struct
        unsigned long max_sg_entrys;
        uint32_t  firm_config_version;

-       for (i = 0; i < ARCMSR_MAX_TARGETID; i++)
-               for (j = 0; j < ARCMSR_MAX_TARGETLUN; j++)
-                       acb->devstate[i][j] = ARECA_RAID_GONE;
-
        max_xfer_len = ARCMSR_MAX_XFER_LEN;
        max_sg_entrys = ARCMSR_DEFAULT_SG_ENTRIES;
        firm_config_version = acb->firm_cfg_version;
-       if((firm_config_version & 0xFF) >= 3){
-               max_xfer_len = (ARCMSR_CDB_SG_PAGE_LENGTH <<
((firm_config_version >> 8) & 0xFF)) * 1024;/* max 4M byte */
-               max_sg_entrys = (max_xfer_len/4096);
+       if ((firm_config_version & 0xFF) >= 3) {
+               max_xfer_len = (ARCMSR_CDB_SG_PAGE_LENGTH <<
+                       ((firm_config_version >> 8) & 0xFF)) * 1024;
+               max_sg_entrys = (max_xfer_len / 4096);
        }
-       acb->host->max_sectors = max_xfer_len/512;
+       acb->host->max_sectors = max_xfer_len / 512;
        acb->host->sg_tablesize = max_sg_entrys;
-       roundup_ccbsize = roundup(sizeof(struct CommandControlBlock) +
(max_sg_entrys - 1) * sizeof(struct SG64ENTRY), 32);
+       roundup_ccbsize = roundup(sizeof(struct CommandControlBlock) +
+               (max_sg_entrys - 1) * sizeof(struct SG64ENTRY), 32);
        acb->uncache_size = roundup_ccbsize * ARCMSR_MAX_FREECCB_NUM;
-       dma_coherent = dma_alloc_coherent(&pdev->dev,
acb->uncache_size, &dma_coherent_handle, GFP_KERNEL);
-       if(!dma_coherent){
-               printk(KERN_NOTICE "arcmsr%d: dma_alloc_coherent got
error\n", acb->host->host_no);
+       dma_coherent = dma_alloc_coherent(&pdev->dev,
+               acb->uncache_size, &dma_coherent_handle, GFP_KERNEL);
+       if (!dma_coherent) {
+               pr_notice("arcmsr%d: dma_alloc_coherent got error\n",
+                       acb->host->host_no);
                return -ENOMEM;
        }
+       memset(dma_coherent, 0, acb->uncache_size);
        acb->dma_coherent = dma_coherent;
        acb->dma_coherent_handle = dma_coherent_handle;
-       memset(dma_coherent, 0, acb->uncache_size);
-       ccb_tmp = dma_coherent;
-       acb->vir2phy_offset = (unsigned long)dma_coherent - (unsigned
long)dma_coherent_handle;
-       for(i = 0; i < ARCMSR_MAX_FREECCB_NUM; i++){
-               cdb_phyaddr = dma_coherent_handle + offsetof(struct
CommandControlBlock, arcmsr_cdb);
-               ccb_tmp->cdb_phyaddr = ((acb->adapter_type ==
ACB_ADAPTER_TYPE_C) ? cdb_phyaddr : (cdb_phyaddr >> 5));
+       ccb_tmp = (struct CommandControlBlock *)dma_coherent;
+       acb->vir2phy_offset = (unsigned long)dma_coherent -
+               (unsigned long)dma_coherent_handle;
+       for (i = 0; i < ARCMSR_MAX_FREECCB_NUM; i++) {
+               cdb_phyaddr = dma_coherent_handle +
+                       offsetof(struct CommandControlBlock, arcmsr_cdb);
+               switch (acb->adapter_type) {
+               case ACB_ADAPTER_TYPE_A:
+               case ACB_ADAPTER_TYPE_B:
+                       ccb_tmp->cdb_phyaddr = cdb_phyaddr >> 5;
+                       break;
+               case ACB_ADAPTER_TYPE_C:
+                       ccb_tmp->cdb_phyaddr = cdb_phyaddr;
+                       break;
+               }
                acb->pccb_pool[i] = ccb_tmp;
                ccb_tmp->acb = acb;
                INIT_LIST_HEAD(&ccb_tmp->list);
                list_add_tail(&ccb_tmp->list, &acb->ccb_free_list);
-               ccb_tmp = (struct CommandControlBlock *)((unsigned
long)ccb_tmp + roundup_ccbsize);
+               ccb_tmp = (struct CommandControlBlock *)
+                       ((unsigned long)ccb_tmp + roundup_ccbsize);
                dma_coherent_handle = dma_coherent_handle + roundup_ccbsize;
        }
+       for (i = 0; i < ARCMSR_MAX_TARGETID; i++)
+               for (j = 0; j < ARCMSR_MAX_TARGETLUN; j++)
+                       acb->devstate[i][j] = ARECA_RAID_GONE;
        return 0;
 }

@@ -611,6 +634,7 @@ arcmsr_resume(struct pci_dev *pdev)
        struct AdapterControlBlock *acb =
                (struct AdapterControlBlock *)host->hostdata;
        struct msix_entry entries[ARCMST_NUM_MSIX_VECTORS];
+
        pci_set_power_state(pdev, PCI_D0);
        pci_enable_wake(pdev, PCI_D0, 0);
        pci_restore_state(pdev);
@@ -694,19 +718,20 @@ static int arcmsr_probe(struct pci_dev *
        uint8_t bus, dev_fun;
        struct msix_entry entries[ARCMST_NUM_MSIX_VECTORS];
        int error, i, j;
+
        error = pci_enable_device(pdev);
        if (error)
                return -ENODEV;
-       host = scsi_host_alloc(&arcmsr_scsi_host_template,
sizeof(struct AdapterControlBlock));
+       host = scsi_host_alloc(&arcmsr_scsi_host_template,
+               sizeof(struct AdapterControlBlock));
        if (!host)
-               goto pci_disable_dev;
+               goto pci_disable_dev;
        error = pci_set_dma_mask(pdev, DMA_BIT_MASK(64));
        if (error) {
                error = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
                if (error) {
-                       printk(KERN_WARNING
-                              "scsi%d: No suitable DMA mask available\n",
-                              host->host_no);
+                       pr_warn("scsi%d: No suitable DMA mask available\n",
+                               host->host_no);
                        goto scsi_host_release;
                }
        }
@@ -718,10 +743,10 @@ static int arcmsr_probe(struct pci_dev *
        acb->pdev = pdev;
        acb->host = host;
        host->max_lun = ARCMSR_MAX_TARGETLUN;
-       host->max_id = ARCMSR_MAX_TARGETID;             /*16:8*/
-       host->max_cmd_len = 16;                         /*this is
issue of 64bit LBA ,over 2T byte*/
-       host->can_queue = ARCMSR_MAX_FREECCB_NUM;       /* max
simultaneous cmds */
-       host->cmd_per_lun = ARCMSR_MAX_CMD_PERLUN;
+       host->max_id = ARCMSR_MAX_TARGETID;
+       host->max_cmd_len = 16;
+       host->can_queue = ARCMSR_MAX_FREECCB_NUM;
+       host->cmd_per_lun = ARCMSR_MAX_CMD_PERLUN;
        host->this_id = ARCMSR_SCSI_INITIATOR_ID;
        host->unique_id = (bus << 8) | dev_fun;
        pci_set_drvdata(pdev, host);
@@ -800,10 +825,10 @@ static int arcmsr_probe(struct pci_dev *
        acb->fw_flag = FW_NORMAL;
        init_timer(&acb->eternal_timer);
        acb->eternal_timer.expires = jiffies + msecs_to_jiffies(6 * HZ);
-       acb->eternal_timer.data = (unsigned long) acb;
+       acb->eternal_timer.data = (unsigned long)acb;
        acb->eternal_timer.function = &arcmsr_request_device_map;
        add_timer(&acb->eternal_timer);
-       if(arcmsr_alloc_sysfs_attr(acb))
+       if (arcmsr_alloc_sysfs_attr(acb))
                goto out_free_sysfs;
        return 0;
 out_free_sysfs:
@@ -830,89 +855,84 @@ pci_disable_dev:
        return -ENODEV;
 }

-static uint8_t arcmsr_hbaA_abort_allcmd(struct AdapterControlBlock *acb)
+static uint8_t
+arcmsr_hbaA_abort_allcmd(struct AdapterControlBlock *acb)
 {
        struct MessageUnit_A __iomem *reg = acb->pmuA;
+
        writel(ARCMSR_INBOUND_MESG0_ABORT_CMD, &reg->inbound_msgaddr0);
        if (!arcmsr_hbaA_wait_msgint_ready(acb)) {
-               printk(KERN_NOTICE
-                       "arcmsr%d: wait 'abort all outstanding
command' timeout \n"
-                       , acb->host->host_no);
+               pr_notice("arcmsr%d: wait 'abort all outstanding "
+                       "command' timeout\n", acb->host->host_no);
                return false;
        }
        return true;
 }

-static uint8_t arcmsr_hbaB_abort_allcmd(struct AdapterControlBlock *acb)
+static uint8_t
+arcmsr_hbaB_abort_allcmd(struct AdapterControlBlock *acb)
 {
        struct MessageUnit_B *reg = acb->pmuB;

        writel(ARCMSR_MESSAGE_ABORT_CMD, reg->drv2iop_doorbell);
        if (!arcmsr_hbaB_wait_msgint_ready(acb)) {
-               printk(KERN_NOTICE
-                       "arcmsr%d: wait 'abort all outstanding
command' timeout \n"
-                       , acb->host->host_no);
+               pr_notice("arcmsr%d: wait 'abort all outstanding "
+                       "command' timeout\n", acb->host->host_no);
                return false;
        }
        return true;
 }
-static uint8_t arcmsr_hbaC_abort_allcmd(struct AdapterControlBlock *pACB)
+
+static uint8_t
+arcmsr_hbaC_abort_allcmd(struct AdapterControlBlock *pACB)
 {
        struct MessageUnit_C __iomem *reg = pACB->pmuC;
+
        writel(ARCMSR_INBOUND_MESG0_ABORT_CMD, &reg->inbound_msgaddr0);
        writel(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE, &reg->inbound_doorbell);
        if (!arcmsr_hbaC_wait_msgint_ready(pACB)) {
-               printk(KERN_NOTICE
-                       "arcmsr%d: wait 'abort all outstanding
command' timeout \n"
-                       , pACB->host->host_no);
+               pr_notice("arcmsr%d: wait 'abort all outstanding "
+                       "command' timeout\n", pACB->host->host_no);
                return false;
        }
        return true;
 }
-static uint8_t arcmsr_abort_allcmd(struct AdapterControlBlock *acb)
+
+static uint8_t
+arcmsr_abort_allcmd(struct AdapterControlBlock *acb)
 {
        uint8_t rtnval = 0;
+
        switch (acb->adapter_type) {
-       case ACB_ADAPTER_TYPE_A: {
+       case ACB_ADAPTER_TYPE_A:
                rtnval = arcmsr_hbaA_abort_allcmd(acb);
-               }
                break;

-       case ACB_ADAPTER_TYPE_B: {
+       case ACB_ADAPTER_TYPE_B:
                rtnval = arcmsr_hbaB_abort_allcmd(acb);
-               }
                break;

-       case ACB_ADAPTER_TYPE_C: {
+       case ACB_ADAPTER_TYPE_C:
                rtnval = arcmsr_hbaC_abort_allcmd(acb);
-               }
+               break;
        }
        return rtnval;
 }

-static bool arcmsr_hbaB_enable_driver_mode(struct AdapterControlBlock *pacb)
-{
-       struct MessageUnit_B *reg = pacb->pmuB;
-       writel(ARCMSR_MESSAGE_START_DRIVER_MODE, reg->drv2iop_doorbell);
-       if (!arcmsr_hbaB_wait_msgint_ready(pacb)) {
-               printk(KERN_ERR "arcmsr%d: can't set driver mode. \n",
pacb->host->host_no);
-               return false;
-       }
-       return true;
-}
-
-static void arcmsr_pci_unmap_dma(struct CommandControlBlock *ccb)
+static void
+arcmsr_pci_unmap_dma(struct CommandControlBlock *ccb)
 {
        struct scsi_cmnd *pcmd = ccb->pcmd;
-
        scsi_dma_unmap(pcmd);
 }

-static void arcmsr_ccb_complete(struct CommandControlBlock *ccb)
+static void
+arcmsr_ccb_complete(struct CommandControlBlock *ccb)
 {
        struct AdapterControlBlock *acb = ccb->acb;
        struct scsi_cmnd *pcmd = ccb->pcmd;
        unsigned long flags;
+
        atomic_dec(&acb->ccboutstandingcount);
        arcmsr_pci_unmap_dma(ccb);
        ccb->startdone = ARCMSR_CCB_DONE;
@@ -922,33 +942,39 @@ static void arcmsr_ccb_complete(struct C
        pcmd->scsi_done(pcmd);
 }

-static void arcmsr_report_sense_info(struct CommandControlBlock *ccb)
+static void
+arcmsr_report_sense_info(struct CommandControlBlock *ccb)
 {

        struct scsi_cmnd *pcmd = ccb->pcmd;
-       struct SENSE_DATA *sensebuffer = (struct SENSE_DATA
*)pcmd->sense_buffer;
+       struct SENSE_DATA *sensebuffer =
+               (struct SENSE_DATA *)pcmd->sense_buffer;
+
        pcmd->result = (DID_OK << 16) | (CHECK_CONDITION << 1);
        if (sensebuffer) {
                int sense_data_length =
                        sizeof(struct SENSE_DATA) < SCSI_SENSE_BUFFERSIZE
                        ? sizeof(struct SENSE_DATA) : SCSI_SENSE_BUFFERSIZE;
                memset(sensebuffer, 0, SCSI_SENSE_BUFFERSIZE);
-               memcpy(sensebuffer, ccb->arcmsr_cdb.SenseData,
sense_data_length);
+               memcpy(sensebuffer, ccb->arcmsr_cdb.SenseData,
+                       sense_data_length);
                sensebuffer->ErrorCode = SCSI_SENSE_CURRENT_ERRORS;
                sensebuffer->Valid = 1;
                pcmd->result |= (DRIVER_SENSE << 24);
        }
 }

-static u32 arcmsr_disable_outbound_ints(struct AdapterControlBlock *acb)
+static u32
+arcmsr_disable_outbound_ints(struct AdapterControlBlock *acb)
 {
        u32 orig_mask = 0;
+
        switch (acb->adapter_type) {
        case ACB_ADAPTER_TYPE_A : {
                struct MessageUnit_A __iomem *reg = acb->pmuA;
                orig_mask = readl(&reg->outbound_intmask);
-               writel(orig_mask|ARCMSR_MU_OUTBOUND_ALL_INTMASKENABLE, \
-                                               &reg->outbound_intmask);
+               writel(orig_mask | ARCMSR_MU_OUTBOUND_ALL_INTMASKENABLE,
+                       &reg->outbound_intmask);
                }
                break;
        case ACB_ADAPTER_TYPE_B : {
@@ -957,21 +983,25 @@ static u32 arcmsr_disable_outbound_ints(
                writel(0, reg->iop2drv_doorbell_mask);
                }
                break;
-       case ACB_ADAPTER_TYPE_C:{
+       case ACB_ADAPTER_TYPE_C: {
                struct MessageUnit_C __iomem *reg = acb->pmuC;
                /* disable all outbound interrupt */
-               orig_mask = readl(&reg->host_int_mask); /* disable
outbound message0 int */
-               writel(orig_mask|ARCMSR_HBCMU_ALL_INTMASKENABLE,
&reg->host_int_mask);
+               orig_mask = readl(&reg->host_int_mask);
+               writel(orig_mask | ARCMSR_HBCMU_ALL_INTMASKENABLE,
+                       &reg->host_int_mask);
+               readl(&reg->host_int_mask);
                }
                break;
        }
        return orig_mask;
 }

-static void arcmsr_report_ccb_state(struct AdapterControlBlock *acb,
+static void
+arcmsr_report_ccb_state(struct AdapterControlBlock *acb,
                        struct CommandControlBlock *ccb, bool error)
 {
        uint8_t id, lun;
+
        id = ccb->pcmd->device->id;
        lun = ccb->pcmd->device->lun;
        if (!error) {
@@ -979,7 +1009,7 @@ static void arcmsr_report_ccb_state(stru
                        acb->devstate[id][lun] = ARECA_RAID_GOOD;
                ccb->pcmd->result = DID_OK << 16;
                arcmsr_ccb_complete(ccb);
-       }else{
+       } else {
                switch (ccb->arcmsr_cdb.DeviceStatus) {
                case ARCMSR_DEV_SELECT_TIMEOUT: {
                        acb->devstate[id][lun] = ARECA_RAID_GONE;
@@ -989,7 +1019,6 @@ static void arcmsr_report_ccb_state(stru
                        break;

                case ARCMSR_DEV_ABORTED:
-
                case ARCMSR_DEV_INIT_FAIL: {
                        acb->devstate[id][lun] = ARECA_RAID_GONE;
                        ccb->pcmd->result = DID_BAD_TARGET << 16;
@@ -1005,89 +1034,87 @@ static void arcmsr_report_ccb_state(stru
                        break;

                default:
-                       printk(KERN_NOTICE
-                               "arcmsr%d: scsi id = %d lun = %d isr
get command error done, \
-                               but got unknown DeviceStatus = 0x%x \n"
-                               , acb->host->host_no
-                               , id
-                               , lun
+                       pr_notice("arcmsr%d: scsi id = %d lun = %d "
+                               "isr get command error done, but got unknown "
+                               "DeviceStatus = 0x%x\n"
+                               , acb->host->host_no, id, lun
                                , ccb->arcmsr_cdb.DeviceStatus);
-                               acb->devstate[id][lun] = ARECA_RAID_GONE;
-                               ccb->pcmd->result = DID_NO_CONNECT << 16;
-                               arcmsr_ccb_complete(ccb);
+                       acb->devstate[id][lun] = ARECA_RAID_GONE;
+                       ccb->pcmd->result = DID_NO_CONNECT << 16;
+                       arcmsr_ccb_complete(ccb);
                        break;
                }
        }
 }

-static void arcmsr_drain_donequeue(struct AdapterControlBlock *acb,
struct CommandControlBlock *pCCB, bool error)
+static void
+arcmsr_drain_donequeue(struct AdapterControlBlock *acb,
+       struct CommandControlBlock *pCCB, bool error)
 {
-       int id, lun;
        if ((pCCB->acb != acb) || (pCCB->startdone != ARCMSR_CCB_START)) {
-               if (pCCB->startdone == ARCMSR_CCB_ABORTED) {
-                       struct scsi_cmnd *abortcmd = pCCB->pcmd;
-                       if (abortcmd) {
-                               id = abortcmd->device->id;
-                               lun = abortcmd->device->lun;
-                               abortcmd->result |= DID_ABORT << 16;
-                               arcmsr_ccb_complete(pCCB);
-                               printk(KERN_NOTICE "arcmsr%d: pCCB
='0x%p' isr got aborted command \n",
-                               acb->host->host_no, pCCB);
-                       }
-                       return;
-               }
-               printk(KERN_NOTICE "arcmsr%d: isr get an illegal ccb command \
-                               done acb = '0x%p'"
-                               "ccb = '0x%p' ccbacb = '0x%p' startdone = 0x%x"
-                               " ccboutstandingcount = %d \n"
-                               , acb->host->host_no
-                               , acb
-                               , pCCB
-                               , pCCB->acb
-                               , pCCB->startdone
-                               , atomic_read(&acb->ccboutstandingcount));
-                 return;
+               pr_notice("arcmsr%d: isr get an illegal ccb "
+                       "command done acb = 0x%p, "
+                       "ccb = 0x%p, "
+                       "ccbacb = 0x%p, "
+                       "startdone = 0x%x, "
+                       "pscsi_cmd = 0x%p, "
+                       "ccboutstandingcount = %d\n"
+                       , acb->host->host_no
+                       , acb
+                       , pCCB
+                       , pCCB->acb
+                       , pCCB->startdone
+                       , pCCB->pcmd
+                       , atomic_read(&acb->ccboutstandingcount));
+               return;
        }
        arcmsr_report_ccb_state(acb, pCCB, error);
 }

-static void arcmsr_done4abort_postqueue(struct AdapterControlBlock *acb)
+static void
+arcmsr_done4abort_postqueue(struct AdapterControlBlock *acb)
 {
        int i = 0;
        uint32_t flag_ccb;
        struct ARCMSR_CDB *pARCMSR_CDB;
        bool error;
        struct CommandControlBlock *pCCB;
-       switch (acb->adapter_type) {

+       switch (acb->adapter_type) {
        case ACB_ADAPTER_TYPE_A: {
                struct MessageUnit_A __iomem *reg = acb->pmuA;
                uint32_t outbound_intstatus;
                outbound_intstatus = readl(&reg->outbound_intstatus) &
                                        acb->outbound_int_enable;
                /*clear and abort all outbound posted Q*/
-               writel(outbound_intstatus,
&reg->outbound_intstatus);/*clear interrupt*/
-               while(((flag_ccb = readl(&reg->outbound_queueport)) !=
0xFFFFFFFF)
-                               && (i++ < ARCMSR_MAX_OUTSTANDING_CMD)) {
-                       pARCMSR_CDB = (struct ARCMSR_CDB
*)(acb->vir2phy_offset + (flag_ccb << 5));/*frame must be 32 bytes
aligned*/
-                       pCCB = container_of(pARCMSR_CDB, struct
CommandControlBlock, arcmsr_cdb);
-                       error = (flag_ccb &
ARCMSR_CCBREPLY_FLAG_ERROR_MODE0) ? true : false;
+               writel(outbound_intstatus, &reg->outbound_intstatus);
+               while (((flag_ccb = readl(&reg->outbound_queueport))
!= 0xFFFFFFFF)
+                       && (i++ < ARCMSR_MAX_OUTSTANDING_CMD)) {
+                       pARCMSR_CDB = (struct ARCMSR_CDB *)
+                               (acb->vir2phy_offset + (flag_ccb << 5));
+                       pCCB = container_of(pARCMSR_CDB,
+                               struct CommandControlBlock, arcmsr_cdb);
+                       error = (flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR_MODE0) ?
+                               true : false;
                        arcmsr_drain_donequeue(acb, pCCB, error);
                }
                }
                break;
-
        case ACB_ADAPTER_TYPE_B: {
                struct MessageUnit_B *reg = acb->pmuB;
-               /*clear all outbound posted Q*/
-               writel(ARCMSR_DOORBELL_INT_CLEAR_PATTERN,
reg->iop2drv_doorbell); /* clear doorbell interrupt */
+               writel(ARCMSR_DOORBELL_INT_CLEAR_PATTERN,
+                       reg->iop2drv_doorbell);
                for (i = 0; i < ARCMSR_MAX_HBB_POSTQUEUE; i++) {
                        flag_ccb = reg->done_qbuffer[i];
                        if (flag_ccb != 0) {
                                reg->done_qbuffer[i] = 0;
-                               pARCMSR_CDB = (struct ARCMSR_CDB
*)(acb->vir2phy_offset+(flag_ccb << 5));/*frame must be 32 bytes
aligned*/
-                               pCCB = container_of(pARCMSR_CDB,
struct CommandControlBlock, arcmsr_cdb);
-                               error = (flag_ccb &
ARCMSR_CCBREPLY_FLAG_ERROR_MODE0) ? true : false;
+                               pARCMSR_CDB = (struct ARCMSR_CDB *)
+                                       (acb->vir2phy_offset + (flag_ccb << 5));
+                               pCCB = container_of(pARCMSR_CDB,
+                                       struct CommandControlBlock, arcmsr_cdb);
+                               error = (flag_ccb &
+                                       ARCMSR_CCBREPLY_FLAG_ERROR_MODE0) ?
+                                       true : false;
                                arcmsr_drain_donequeue(acb, pCCB, error);
                        }
                        reg->post_qbuffer[i] = 0;
@@ -1098,28 +1125,36 @@ static void arcmsr_done4abort_postqueue(
                break;
        case ACB_ADAPTER_TYPE_C: {
                struct MessageUnit_C __iomem *reg = acb->pmuC;
-               struct  ARCMSR_CDB *pARCMSR_CDB;
-               uint32_t flag_ccb, ccb_cdb_phy;
+               uint32_t ccb_cdb_phy;
                bool error;
                struct CommandControlBlock *pCCB;
-               while ((readl(&reg->host_int_status) &
ARCMSR_HBCMU_OUTBOUND_POSTQUEUE_ISR) && (i++ <
ARCMSR_MAX_OUTSTANDING_CMD)) {
+               while ((readl(&reg->host_int_status) &
+                       ARCMSR_HBCMU_OUTBOUND_POSTQUEUE_ISR)
+                       && (i++ < ARCMSR_MAX_OUTSTANDING_CMD)) {
                        /*need to do*/
                        flag_ccb = readl(&reg->outbound_queueport_low);
                        ccb_cdb_phy = (flag_ccb & 0xFFFFFFF0);
-                       pARCMSR_CDB = (struct  ARCMSR_CDB
*)(acb->vir2phy_offset+ccb_cdb_phy);/*frame must be 32 bytes aligned*/
-                       pCCB = container_of(pARCMSR_CDB, struct
CommandControlBlock, arcmsr_cdb);
-                       error = (flag_ccb &
ARCMSR_CCBREPLY_FLAG_ERROR_MODE1) ? true : false;
+                       pARCMSR_CDB = (struct  ARCMSR_CDB *)
+                               (acb->vir2phy_offset+ccb_cdb_phy);
+                       pCCB = container_of(pARCMSR_CDB,
+                               struct CommandControlBlock, arcmsr_cdb);
+                       error = (flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR_MODE1)
+                               ? true : false;
                        arcmsr_drain_donequeue(acb, pCCB, error);
                }
-       }
+               }
+               break;
        }
 }
-static void arcmsr_remove(struct pci_dev *pdev)
+
+static void
+arcmsr_remove(struct pci_dev *pdev)
 {
        struct Scsi_Host *host = pci_get_drvdata(pdev);
        struct AdapterControlBlock *acb =
-               (struct AdapterControlBlock *) host->hostdata;
+               (struct AdapterControlBlock *)host->hostdata;
        int poll_count = 0, i;
+
        arcmsr_free_sysfs_attr(acb);
        scsi_remove_host(host);
        flush_work(&acb->arcmsr_do_message_isr_bh);
@@ -1130,10 +1165,11 @@ static void arcmsr_remove(struct pci_dev
        acb->acb_flags |= ACB_F_SCSISTOPADAPTER;
        acb->acb_flags &= ~ACB_F_IOP_INITED;

-       for (poll_count = 0; poll_count < ARCMSR_MAX_OUTSTANDING_CMD;
poll_count++){
+       for (poll_count = 0; poll_count < ARCMSR_MAX_OUTSTANDING_CMD;
+               poll_count++) {
                if (!atomic_read(&acb->ccboutstandingcount))
                        break;
-               arcmsr_interrupt(acb);/* FIXME: need spinlock */
+               arcmsr_interrupt(acb);
                msleep(25);
        }

@@ -1149,6 +1185,8 @@ static void arcmsr_remove(struct pci_dev
                        }
                }
        }
+       arcmsr_free_ccb_pool(acb);
+       arcmsr_free_mu(acb);
        if (acb->acb_flags & ACB_F_MSI_ENABLED) {
                free_irq(pdev->irq, acb);
                pci_disable_msi(pdev);
@@ -1158,20 +1196,20 @@ static void arcmsr_remove(struct pci_dev
                pci_disable_msix(pdev);
        } else
                free_irq(pdev->irq, acb);
-       arcmsr_free_ccb_pool(acb);
-       arcmsr_free_mu(acb);
        arcmsr_unmap_pciregion(acb);
        pci_release_regions(pdev);
        scsi_host_put(host);
        pci_disable_device(pdev);
 }

-static void arcmsr_shutdown(struct pci_dev *pdev)
+static void
+arcmsr_shutdown(struct pci_dev *pdev)
 {
        int i;
        struct Scsi_Host *host = pci_get_drvdata(pdev);
        struct AdapterControlBlock *acb =
                (struct AdapterControlBlock *)host->hostdata;
+
        del_timer_sync(&acb->eternal_timer);
        arcmsr_disable_outbound_ints(acb);
        if (acb->acb_flags & ACB_F_MSIX_ENABLED) {
@@ -1191,6 +1229,7 @@ static void arcmsr_shutdown(struct pci_d
 static int arcmsr_module_init(void)
 {
        int error = 0;
+
        error = pci_register_driver(&arcmsr_pci_driver);
        return error;
 }
@@ -1199,25 +1238,26 @@ static void arcmsr_module_exit(void)
 {
        pci_unregister_driver(&arcmsr_pci_driver);
 }
+
 module_init(arcmsr_module_init);
 module_exit(arcmsr_module_exit);

-static void arcmsr_enable_outbound_ints(struct AdapterControlBlock *acb,
-                                               u32 intmask_org)
+static void
+arcmsr_enable_outbound_ints(struct AdapterControlBlock *acb, u32 intmask_org)
 {
        u32 mask;
-       switch (acb->adapter_type) {

+       switch (acb->adapter_type) {
        case ACB_ADAPTER_TYPE_A: {
                struct MessageUnit_A __iomem *reg = acb->pmuA;
-               mask = intmask_org &
~(ARCMSR_MU_OUTBOUND_POSTQUEUE_INTMASKENABLE |
-                            ARCMSR_MU_OUTBOUND_DOORBELL_INTMASKENABLE|
-                            ARCMSR_MU_OUTBOUND_MESSAGE0_INTMASKENABLE);
+               mask = intmask_org &
+                       ~(ARCMSR_MU_OUTBOUND_POSTQUEUE_INTMASKENABLE |
+                       ARCMSR_MU_OUTBOUND_DOORBELL_INTMASKENABLE |
+                       ARCMSR_MU_OUTBOUND_MESSAGE0_INTMASKENABLE);
                writel(mask, &reg->outbound_intmask);
                acb->outbound_int_enable = ~(intmask_org & mask) & 0x000000ff;
-               }
                break;
-
+               }
        case ACB_ADAPTER_TYPE_B: {
                struct MessageUnit_B *reg = acb->pmuB;
                mask = intmask_org | (ARCMSR_IOP2DRV_DATA_WRITE_OK |
@@ -1226,36 +1266,39 @@ static void arcmsr_enable_outbound_ints(
                        ARCMSR_IOP2DRV_MESSAGE_CMD_DONE);
                writel(mask, reg->iop2drv_doorbell_mask);
                acb->outbound_int_enable = (intmask_org | mask) & 0x0000000f;
-               }
                break;
+               }
        case ACB_ADAPTER_TYPE_C: {
                struct MessageUnit_C __iomem *reg = acb->pmuC;
-               mask = ~(ARCMSR_HBCMU_UTILITY_A_ISR_MASK |
ARCMSR_HBCMU_OUTBOUND_DOORBELL_ISR_MASK|ARCMSR_HBCMU_OUTBOUND_POSTQUEUE_ISR_MASK);
+               mask = ~(ARCMSR_HBCMU_UTILITY_A_ISR_MASK |
+                       ARCMSR_HBCMU_OUTBOUND_DOORBELL_ISR_MASK |
+                       ARCMSR_HBCMU_OUTBOUND_POSTQUEUE_ISR_MASK);
                writel(intmask_org & mask, &reg->host_int_mask);
                acb->outbound_int_enable = ~(intmask_org & mask) & 0x0000000f;
+               break;
                }
        }
 }

-static int arcmsr_build_ccb(struct AdapterControlBlock *acb,
+static int
+arcmsr_build_ccb(struct AdapterControlBlock *acb,
        struct CommandControlBlock *ccb, struct scsi_cmnd *pcmd)
 {
-       struct ARCMSR_CDB *arcmsr_cdb = (struct ARCMSR_CDB *)&ccb->arcmsr_cdb;
-       int8_t *psge = (int8_t *)&arcmsr_cdb->u;
+       struct ARCMSR_CDB *arcmsr_cdb = &ccb->arcmsr_cdb;
+       uint8_t *psge = (int8_t *)&arcmsr_cdb->u;
        __le32 address_lo, address_hi;
        int arccdbsize = 0x30;
        __le32 length = 0;
        int i;
        struct scatterlist *sg;
        int nseg;
+
        ccb->pcmd = pcmd;
        memset(arcmsr_cdb, 0, sizeof(struct ARCMSR_CDB));
        arcmsr_cdb->TargetID = pcmd->device->id;
        arcmsr_cdb->LUN = pcmd->device->lun;
        arcmsr_cdb->Function = 1;
-       arcmsr_cdb->msgContext = 0;
        memcpy(arcmsr_cdb->Cdb, pcmd->cmnd, pcmd->cmd_len);
-
        nseg = scsi_dma_map(pcmd);
        if (unlikely(nseg > acb->host->sg_tablesize || nseg < 0))
                return FAILED;
@@ -1266,24 +1309,23 @@ static int arcmsr_build_ccb(struct Adapt
                address_hi = cpu_to_le32(dma_addr_hi32(sg_dma_address(sg)));
                if (address_hi == 0) {
                        struct SG32ENTRY *pdma_sg = (struct SG32ENTRY *)psge;
-
                        pdma_sg->address = address_lo;
                        pdma_sg->length = length;
                        psge += sizeof (struct SG32ENTRY);
                        arccdbsize += sizeof (struct SG32ENTRY);
                } else {
                        struct SG64ENTRY *pdma_sg = (struct SG64ENTRY *)psge;
-
                        pdma_sg->addresshigh = address_hi;
                        pdma_sg->address = address_lo;
-                       pdma_sg->length = length|cpu_to_le32(IS_SG64_ADDR);
+                       pdma_sg->length = length | cpu_to_le32(IS_SG64_ADDR);
                        psge += sizeof (struct SG64ENTRY);
                        arccdbsize += sizeof (struct SG64ENTRY);
                }
        }
        arcmsr_cdb->sgcount = (uint8_t)nseg;
        arcmsr_cdb->DataLength = scsi_bufflen(pcmd);
-       arcmsr_cdb->msgPages = arccdbsize/0x100 + (arccdbsize % 0x100 ? 1 : 0);
+       arcmsr_cdb->msgPages = arccdbsize / 0x100 +
+               (arccdbsize % 0x100 ? 1 : 0);
        if ( arccdbsize > 256)
                arcmsr_cdb->Flags |= ARCMSR_CDB_FLAG_SGL_BSIZE;
        if (pcmd->sc_data_direction == DMA_TO_DEVICE)
@@ -1292,10 +1334,12 @@ static int arcmsr_build_ccb(struct Adapt
        return SUCCESS;
 }

-static void arcmsr_post_ccb(struct AdapterControlBlock *acb, struct
CommandControlBlock *ccb)
+static void
+arcmsr_post_ccb(struct AdapterControlBlock *acb, struct
CommandControlBlock *ccb)
 {
        uint32_t cdb_phyaddr = ccb->cdb_phyaddr;
        struct ARCMSR_CDB *arcmsr_cdb = (struct ARCMSR_CDB *)&ccb->arcmsr_cdb;
+
        atomic_inc(&acb->ccboutstandingcount);
        ccb->startdone = ARCMSR_CCB_START;
        switch (acb->adapter_type) {
@@ -1304,13 +1348,11 @@ static void arcmsr_post_ccb(struct Adapt

                if (arcmsr_cdb->Flags & ARCMSR_CDB_FLAG_SGL_BSIZE)
                        writel(cdb_phyaddr | ARCMSR_CCBPOST_FLAG_SGL_BSIZE,
-                       &reg->inbound_queueport);
-               else {
-                               writel(cdb_phyaddr, &reg->inbound_queueport);
-               }
+                               &reg->inbound_queueport);
+               else
+                       writel(cdb_phyaddr, &reg->inbound_queueport);
                }
                break;
-
        case ACB_ADAPTER_TYPE_B: {
                struct MessageUnit_B *reg = acb->pmuB;
                uint32_t ending_index, index = reg->postq_index;
@@ -1323,7 +1365,7 @@ static void arcmsr_post_ccb(struct Adapt
                else
                        reg->post_qbuffer[index] = cdb_phyaddr;
                index++;
-               index %= ARCMSR_MAX_HBB_POSTQUEUE;/*if last index
number set it to 0 */
+               index %= ARCMSR_MAX_HBB_POSTQUEUE;
                reg->postq_index = index;
                writel(ARCMSR_DRV2IOP_CDB_POSTED, reg->drv2iop_doorbell);
                }
@@ -1332,88 +1374,92 @@ static void arcmsr_post_ccb(struct Adapt
                struct MessageUnit_C __iomem *phbcmu = acb->pmuC;
                uint32_t ccb_post_stamp, arc_cdb_size;

-               arc_cdb_size = (ccb->arc_cdb_size > 0x300) ? 0x300 :
ccb->arc_cdb_size;
+               arc_cdb_size = (ccb->arc_cdb_size > 0x300)
+                       ? 0x300 : ccb->arc_cdb_size;
                ccb_post_stamp = (cdb_phyaddr | ((arc_cdb_size - 1) >> 6) | 1);
                if (acb->cdb_phyaddr_hi32) {
-                       writel(acb->cdb_phyaddr_hi32,
&phbcmu->inbound_queueport_high);
-                       writel(ccb_post_stamp, &phbcmu->inbound_queueport_low);
-               } else {
-                       writel(ccb_post_stamp, &phbcmu->inbound_queueport_low);
-               }
+                       writel(acb->cdb_phyaddr_hi32,
+                               &phbcmu->inbound_queueport_high);
+                       writel(ccb_post_stamp,
+                               &phbcmu->inbound_queueport_low);
+               } else
+                       writel(ccb_post_stamp,
+                               &phbcmu->inbound_queueport_low);
                }
+               break;
        }
 }

-static void arcmsr_hbaA_stop_bgrb(struct AdapterControlBlock *acb)
+static void
+arcmsr_hbaA_stop_bgrb(struct AdapterControlBlock *acb)
 {
        struct MessageUnit_A __iomem *reg = acb->pmuA;
+
        acb->acb_flags &= ~ACB_F_MSG_START_BGRB;
        writel(ARCMSR_INBOUND_MESG0_STOP_BGRB, &reg->inbound_msgaddr0);
-       if (!arcmsr_hbaA_wait_msgint_ready(acb)) {
-               printk(KERN_NOTICE
-                       "arcmsr%d: wait 'stop adapter background
rebulid' timeout \n"
-                       , acb->host->host_no);
-       }
+       if (!arcmsr_hbaA_wait_msgint_ready(acb))
+               pr_notice("arcmsr%d: wait 'stop adapter background rebulid' "
+                       "timeout\n", acb->host->host_no);
 }

-static void arcmsr_hbaB_stop_bgrb(struct AdapterControlBlock *acb)
+static void
+arcmsr_hbaB_stop_bgrb(struct AdapterControlBlock *acb)
 {
        struct MessageUnit_B *reg = acb->pmuB;
+
        acb->acb_flags &= ~ACB_F_MSG_START_BGRB;
        writel(ARCMSR_MESSAGE_STOP_BGRB, reg->drv2iop_doorbell);
-
-       if (!arcmsr_hbaB_wait_msgint_ready(acb)) {
-               printk(KERN_NOTICE
-                       "arcmsr%d: wait 'stop adapter background
rebulid' timeout \n"
-                       , acb->host->host_no);
-       }
+       if (!arcmsr_hbaB_wait_msgint_ready(acb))
+               pr_notice("arcmsr%d: wait 'stop adapter background rebulid' "
+                       "timeout\n", acb->host->host_no);
 }

-static void arcmsr_hbaC_stop_bgrb(struct AdapterControlBlock *pACB)
+static void
+arcmsr_hbaC_stop_bgrb(struct AdapterControlBlock *pACB)
 {
        struct MessageUnit_C __iomem *reg = pACB->pmuC;
+
        pACB->acb_flags &= ~ACB_F_MSG_START_BGRB;
        writel(ARCMSR_INBOUND_MESG0_STOP_BGRB, &reg->inbound_msgaddr0);
        writel(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE, &reg->inbound_doorbell);
-       if (!arcmsr_hbaC_wait_msgint_ready(pACB)) {
-               printk(KERN_NOTICE
-                       "arcmsr%d: wait 'stop adapter background
rebulid' timeout \n"
-                       , pACB->host->host_no);
-       }
-       return;
+       if (!arcmsr_hbaC_wait_msgint_ready(pACB))
+               pr_notice("arcmsr%d: wait 'stop adapter background rebulid' "
+                       "timeout\n", pACB->host->host_no);
 }
-static void arcmsr_stop_adapter_bgrb(struct AdapterControlBlock *acb)
+
+static void
+arcmsr_stop_adapter_bgrb(struct AdapterControlBlock *acb)
 {
        switch (acb->adapter_type) {
-       case ACB_ADAPTER_TYPE_A: {
+       case ACB_ADAPTER_TYPE_A:
                arcmsr_hbaA_stop_bgrb(acb);
-               }
                break;
-
-       case ACB_ADAPTER_TYPE_B: {
+       case ACB_ADAPTER_TYPE_B:
                arcmsr_hbaB_stop_bgrb(acb);
-               }
                break;
-       case ACB_ADAPTER_TYPE_C: {
+       case ACB_ADAPTER_TYPE_C:
                arcmsr_hbaC_stop_bgrb(acb);
-               }
+               break;
        }
 }

-static void arcmsr_free_ccb_pool(struct AdapterControlBlock *acb)
+static void
+arcmsr_free_ccb_pool(struct AdapterControlBlock *acb)
 {
-       dma_free_coherent(&acb->pdev->dev, acb->uncache_size,
acb->dma_coherent, acb->dma_coherent_handle);
+       dma_free_coherent(&acb->pdev->dev, acb->uncache_size,
+               acb->dma_coherent, acb->dma_coherent_handle);
 }

-static void arcmsr_iop_message_read(struct AdapterControlBlock *acb)
+static void
+arcmsr_iop_message_read(struct AdapterControlBlock *acb)
 {
        switch (acb->adapter_type) {
        case ACB_ADAPTER_TYPE_A: {
                struct MessageUnit_A __iomem *reg = acb->pmuA;
-               writel(ARCMSR_INBOUND_DRIVER_DATA_READ_OK,
&reg->inbound_doorbell);
+               writel(ARCMSR_INBOUND_DRIVER_DATA_READ_OK,
+                       &reg->inbound_doorbell);
                }
                break;
-
        case ACB_ADAPTER_TYPE_B: {
                struct MessageUnit_B *reg = acb->pmuB;
                writel(ARCMSR_DRV2IOP_DATA_READ_OK, reg->drv2iop_doorbell);
@@ -1421,12 +1467,15 @@ static void arcmsr_iop_message_read(stru
                break;
        case ACB_ADAPTER_TYPE_C: {
                struct MessageUnit_C __iomem *reg = acb->pmuC;
-               writel(ARCMSR_HBCMU_DRV2IOP_DATA_READ_OK,
&reg->inbound_doorbell);
+               writel(ARCMSR_HBCMU_DRV2IOP_DATA_READ_OK,
+                       &reg->inbound_doorbell);
                }
+               break;
        }
 }

-static void arcmsr_iop_message_wrote(struct AdapterControlBlock *acb)
+static void
+arcmsr_iop_message_wrote(struct AdapterControlBlock *acb)
 {
        switch (acb->adapter_type) {
        case ACB_ADAPTER_TYPE_A: {
@@ -1435,10 +1484,10 @@ static void arcmsr_iop_message_wrote(str
                ** push inbound doorbell tell iop, driver data write ok
                ** and wait reply on next hwinterrupt for next Qbuffer post
                */
-               writel(ARCMSR_INBOUND_DRIVER_DATA_WRITE_OK,
&reg->inbound_doorbell);
+               writel(ARCMSR_INBOUND_DRIVER_DATA_WRITE_OK,
+                       &reg->inbound_doorbell);
                }
                break;
-
        case ACB_ADAPTER_TYPE_B: {
                struct MessageUnit_B *reg = acb->pmuB;
                /*
@@ -1454,57 +1503,59 @@ static void arcmsr_iop_message_wrote(str
                ** push inbound doorbell tell iop, driver data write ok
                ** and wait reply on next hwinterrupt for next Qbuffer post
                */
-               writel(ARCMSR_HBCMU_DRV2IOP_DATA_WRITE_OK,
&reg->inbound_doorbell);
+               writel(ARCMSR_HBCMU_DRV2IOP_DATA_WRITE_OK,
+                       &reg->inbound_doorbell);
                }
                break;
        }
 }

-struct QBUFFER __iomem *arcmsr_get_iop_rqbuffer(struct
AdapterControlBlock *acb)
+struct QBUFFER __iomem
+*arcmsr_get_iop_rqbuffer(struct AdapterControlBlock *acb)
 {
        struct QBUFFER __iomem *qbuffer = NULL;
-       switch (acb->adapter_type) {

+       switch (acb->adapter_type) {
        case ACB_ADAPTER_TYPE_A: {
                struct MessageUnit_A __iomem *reg = acb->pmuA;
                qbuffer = (struct QBUFFER __iomem *)&reg->message_rbuffer;
                }
                break;
-
        case ACB_ADAPTER_TYPE_B: {
                struct MessageUnit_B *reg = acb->pmuB;
                qbuffer = (struct QBUFFER __iomem *)reg->message_rbuffer;
                }
                break;
        case ACB_ADAPTER_TYPE_C: {
-               struct MessageUnit_C __iomem *phbcmu = acb->pmuC;
-               qbuffer = (struct QBUFFER __iomem *)&phbcmu->message_rbuffer;
+               struct MessageUnit_C __iomem *reg = acb->pmuC;
+               qbuffer = (struct QBUFFER __iomem *)&reg->message_rbuffer;
                }
+               break;
        }
        return qbuffer;
 }

-static struct QBUFFER __iomem *arcmsr_get_iop_wqbuffer(struct
AdapterControlBlock *acb)
+static struct QBUFFER __iomem
+*arcmsr_get_iop_wqbuffer(struct AdapterControlBlock *acb)
 {
        struct QBUFFER __iomem *pqbuffer = NULL;
-       switch (acb->adapter_type) {

+       switch (acb->adapter_type) {
        case ACB_ADAPTER_TYPE_A: {
                struct MessageUnit_A __iomem *reg = acb->pmuA;
-               pqbuffer = (struct QBUFFER __iomem *) &reg->message_wbuffer;
+               pqbuffer = (struct QBUFFER __iomem *)&reg->message_wbuffer;
                }
                break;
-
        case ACB_ADAPTER_TYPE_B: {
-               struct MessageUnit_B  *reg = acb->pmuB;
+               struct MessageUnit_B *reg = acb->pmuB;
                pqbuffer = (struct QBUFFER __iomem *)reg->message_wbuffer;
                }
                break;
        case ACB_ADAPTER_TYPE_C: {
                struct MessageUnit_C __iomem *reg = acb->pmuC;
                pqbuffer = (struct QBUFFER __iomem *)&reg->message_wbuffer;
-       }
-
+               }
+               break;
        }
        return pqbuffer;
 }
@@ -1575,7 +1626,8 @@ arcmsr_Read_iop_rqbuffer_data(struct Ada
        return 1;
 }

-static void arcmsr_iop2drv_data_wrote_handle(struct AdapterControlBlock *acb)
+static void
+arcmsr_iop2drv_data_wrote_handle(struct AdapterControlBlock *acb)
 {
        unsigned long flags;
        struct QBUFFER __iomem  *prbuffer;
@@ -1687,6 +1739,7 @@ arcmsr_hbaA_doorbell_isr(struct AdapterC
 {
        uint32_t outbound_doorbell;
        struct MessageUnit_A __iomem *reg = acb->pmuA;
+
        outbound_doorbell = readl(&reg->outbound_doorbell);
        do {
                writel(outbound_doorbell, &reg->outbound_doorbell);
@@ -1704,6 +1757,7 @@ arcmsr_hbaC_doorbell_isr(struct AdapterC
 {
        uint32_t outbound_doorbell;
        struct MessageUnit_C __iomem *reg = pACB->pmuC;
+
        outbound_doorbell = readl(&reg->outbound_doorbell);
        do {
                writel(outbound_doorbell, &reg->outbound_doorbell_clear);
@@ -1728,6 +1782,7 @@ arcmsr_hbaA_postqueue_isr(struct Adapter
        struct ARCMSR_CDB *pARCMSR_CDB;
        struct CommandControlBlock *pCCB;
        bool error;
+
        while ((flag_ccb = readl(&reg->outbound_queueport)) != 0xFFFFFFFF) {
                pARCMSR_CDB = (struct ARCMSR_CDB *)
                        (acb->vir2phy_offset + (flag_ccb << 5));
@@ -1748,6 +1803,7 @@ arcmsr_hbaB_postqueue_isr(struct Adapter
        struct ARCMSR_CDB *pARCMSR_CDB;
        struct CommandControlBlock *pCCB;
        bool error;
+
        index = reg->doneq_index;
        while ((flag_ccb = reg->done_qbuffer[index]) != 0) {
                reg->done_qbuffer[index] = 0;
@@ -1802,6 +1858,7 @@ static void
 arcmsr_hbaA_message_isr(struct AdapterControlBlock *acb)
 {
        struct MessageUnit_A __iomem *reg  = acb->pmuA;
+
        /*clear interrupt and message state*/
        writel(ARCMSR_MU_OUTBOUND_MESSAGE0_INT, &reg->outbound_intstatus);
        schedule_work(&acb->arcmsr_do_message_isr_bh);
@@ -1811,6 +1868,7 @@ static void
 arcmsr_hbaB_message_isr(struct AdapterControlBlock *acb)
 {
        struct MessageUnit_B *reg  = acb->pmuB;
+
        /*clear interrupt and message state*/
        writel(ARCMSR_MESSAGE_INT_CLEAR_PATTERN, reg->iop2drv_doorbell);
        schedule_work(&acb->arcmsr_do_message_isr_bh);
@@ -1820,6 +1878,7 @@ static void
 arcmsr_hbaC_message_isr(struct AdapterControlBlock *acb)
 {
        struct MessageUnit_C __iomem *reg  = acb->pmuC;
+
        /*clear interrupt and message state*/
        writel(ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE_DOORBELL_CLEAR,
                &reg->outbound_doorbell_clear);
@@ -1831,6 +1890,7 @@ arcmsr_hbaA_handle_isr(struct AdapterCon
 {
        uint32_t outbound_intstatus;
        struct MessageUnit_A __iomem *reg = acb->pmuA;
+
        outbound_intstatus = readl(&reg->outbound_intstatus) &
                acb->outbound_int_enable;
        if (!(outbound_intstatus & ARCMSR_MU_OUTBOUND_HANDLE_INT))
@@ -1856,6 +1916,7 @@ arcmsr_hbaB_handle_isr(struct AdapterCon
 {
        uint32_t outbound_doorbell;
        struct MessageUnit_B *reg = acb->pmuB;
+
        outbound_doorbell = readl(reg->iop2drv_doorbell) &
                acb->outbound_int_enable;
        if (!outbound_doorbell)
@@ -1885,6 +1946,7 @@ arcmsr_hbaC_handle_isr(struct AdapterCon
 {
        uint32_t host_interrupt_status;
        struct MessageUnit_C __iomem *phbcmu = pACB->pmuC;
+
        host_interrupt_status = readl(&phbcmu->host_int_status) &
                (ARCMSR_HBCMU_OUTBOUND_POSTQUEUE_ISR |
                ARCMSR_HBCMU_OUTBOUND_DOORBELL_ISR);
@@ -1920,7 +1982,8 @@ arcmsr_interrupt(struct AdapterControlBl
        }
 }

-static void arcmsr_iop_parking(struct AdapterControlBlock *acb)
+static void
+arcmsr_iop_parking(struct AdapterControlBlock *acb)
 {
        uint32_t intmask_org;

@@ -2276,16 +2339,18 @@ message_out:
        return retvalue;
 }

-static struct CommandControlBlock *arcmsr_get_freeccb(struct
AdapterControlBlock *acb)
+static struct CommandControlBlock
+*arcmsr_get_freeccb(struct AdapterControlBlock *acb)
 {
        struct list_head *head = &acb->ccb_free_list;
        struct CommandControlBlock *ccb = NULL;
        unsigned long flags;
+
        spin_lock_irqsave(&acb->ccblist_lock, flags);
        if (!list_empty(head)) {
                ccb = list_entry(head->next, struct CommandControlBlock, list);
                list_del_init(&ccb->list);
-       }else{
+       } else {
                spin_unlock_irqrestore(&acb->ccblist_lock, flags);
                return NULL;
        }
@@ -2293,7 +2358,8 @@ static struct CommandControlBlock *arcms
        return ccb;
 }

-static void arcmsr_handle_virtual_command(struct AdapterControlBlock *acb,
+static void
+arcmsr_handle_virtual_command(struct AdapterControlBlock *acb,
                struct scsi_cmnd *cmd)
 {
        switch (cmd->cmnd[0]) {
@@ -2301,7 +2367,6 @@ static void arcmsr_handle_virtual_comman
                unsigned char inqdata[36];
                char *buffer;
                struct scatterlist *sg;
-
                if (cmd->device->lun) {
                        cmd->result = (DID_TIME_OUT << 16);
                        cmd->scsi_done(cmd);
@@ -2320,14 +2385,11 @@ static void arcmsr_handle_virtual_comman
                strncpy(&inqdata[16], "RAID controller ", 16);
                /* Product Identification */
                strncpy(&inqdata[32], "R001", 4); /* Product Revision */
-
                sg = scsi_sglist(cmd);
                buffer = kmap_atomic(sg_page(sg)) + sg->offset;
-
                memcpy(buffer, inqdata, sizeof(inqdata));
                sg = scsi_sglist(cmd);
                kunmap_atomic(buffer - sg->offset);
-
                cmd->scsi_done(cmd);
        }
        break;
@@ -2343,22 +2405,24 @@ static void arcmsr_handle_virtual_comman
        }
 }

-static int arcmsr_queue_command_lck(struct scsi_cmnd *cmd,
+static int
+arcmsr_queue_command_lck(struct scsi_cmnd *cmd,
        void (* done)(struct scsi_cmnd *))
 {
        struct Scsi_Host *host = cmd->device->host;
-       struct AdapterControlBlock *acb = (struct AdapterControlBlock
*) host->hostdata;
+       struct AdapterControlBlock *acb =
+               (struct AdapterControlBlock *)host->hostdata;
        struct CommandControlBlock *ccb;
        int target = cmd->device->id;
        int lun = cmd->device->lun;
        uint8_t scsicmd = cmd->cmnd[0];
+
        cmd->scsi_done = done;
        cmd->host_scribble = NULL;
        cmd->result = 0;
-       if ((scsicmd == SYNCHRONIZE_CACHE) ||(scsicmd == SEND_DIAGNOSTIC)){
-               if(acb->devstate[target][lun] == ARECA_RAID_GONE) {
-                       cmd->result = (DID_NO_CONNECT << 16);
-               }
+       if ((scsicmd == SYNCHRONIZE_CACHE) || (scsicmd == SEND_DIAGNOSTIC)) {
+               if (acb->devstate[target][lun] == ARECA_RAID_GONE)
+                       cmd->result = (DID_NO_CONNECT << 16);
                cmd->scsi_done(cmd);
                return 0;
        }
@@ -2397,6 +2461,7 @@ arcmsr_hbaA_get_config(struct AdapterCon
        char __iomem *iop_device_map =
                (char __iomem *)(&reg->message_rwbuffer[21]);
        int count;
+
        writel(ARCMSR_INBOUND_MESG0_GET_CONFIG, &reg->inbound_msgaddr0);
        if (!arcmsr_hbaA_wait_msgint_ready(acb)) {
                pr_notice("arcmsr%d: wait 'get adapter firmware "
@@ -2456,6 +2521,7 @@ arcmsr_hbaB_get_config(struct AdapterCon
        char __iomem *iop_device_map;
        /*firm_version,21,84-99*/
        int count;
+
        acb->roundup_ccbsize = roundup(sizeof(struct MessageUnit_B), 32);
        dma_coherent2 = dma_alloc_coherent(&pdev->dev, acb->roundup_ccbsize,
                &dma_coherent_handle2, GFP_KERNEL);
@@ -2543,9 +2609,10 @@ arcmsr_hbaC_get_config(struct AdapterCon
        struct MessageUnit_C __iomem *reg = pACB->pmuC;
        char *acb_firm_model = pACB->firm_model;
        char *acb_firm_version = pACB->firm_version;
-       char __iomem *iop_firm_model = (char __iomem
*)(&reg->msgcode_rwbuffer[15]);
-       char __iomem *iop_firm_version = (char __iomem
*)(&reg->msgcode_rwbuffer[17]);
+       char __iomem *iop_firm_model = (char __iomem
*)&reg->msgcode_rwbuffer[15];
+       char __iomem *iop_firm_version = (char __iomem
*)&reg->msgcode_rwbuffer[17];
        int count;
+
        /* disable all outbound interrupt */
        intmask_org = readl(&reg->host_int_mask);
        writel(intmask_org | ARCMSR_HBCMU_ALL_INTMASKENABLE,
@@ -2601,6 +2668,7 @@ static bool
 arcmsr_get_firmware_spec(struct AdapterControlBlock *acb)
 {
        bool rtn = false;
+
        switch (acb->adapter_type) {
        case ACB_ADAPTER_TYPE_A:
                rtn = arcmsr_hbaA_get_config(acb);
@@ -2621,40 +2689,49 @@ arcmsr_get_firmware_spec(struct AdapterC
        return rtn;
 }

-static int arcmsr_hbaA_polling_ccbdone(struct AdapterControlBlock *acb,
+static int
+arcmsr_hbaA_polling_ccbdone(struct AdapterControlBlock *acb,
        struct CommandControlBlock *poll_ccb)
 {
        struct MessageUnit_A __iomem *reg = acb->pmuA;
        struct CommandControlBlock *ccb;
        struct ARCMSR_CDB *arcmsr_cdb;
-       uint32_t flag_ccb, outbound_intstatus, poll_ccb_done = 0,
poll_count = 0;
+       uint32_t flag_ccb, outbound_intstatus, poll_ccb_done = 0;
+       uint32_t poll_count = 0;
        int rtn;
        bool error;
-       polling_hbaA_ccb_retry:
+
+polling_hba_ccb_retry:
        poll_count++;
-       outbound_intstatus = readl(&reg->outbound_intstatus) &
acb->outbound_int_enable;
-       writel(outbound_intstatus, &reg->outbound_intstatus);/*clear interrupt*/
+       outbound_intstatus = readl(&reg->outbound_intstatus) &
+               acb->outbound_int_enable;
+       writel(outbound_intstatus, &reg->outbound_intstatus);
        while (1) {
-               if ((flag_ccb = readl(&reg->outbound_queueport)) ==
0xFFFFFFFF) {
-                       if (poll_ccb_done){
+               flag_ccb = readl(&reg->outbound_queueport);
+               if (flag_ccb == 0xFFFFFFFF) {
+                       if (poll_ccb_done) {
                                rtn = SUCCESS;
                                break;
-                       }else {
+                       } else {
                                msleep(25);
-                               if (poll_count > 100){
+                               if (poll_count > 100) {
                                        rtn = FAILED;
                                        break;
                                }
-                               goto polling_hbaA_ccb_retry;
+                               goto polling_hba_ccb_retry;
                        }
                }
-               arcmsr_cdb = (struct ARCMSR_CDB *)(acb->vir2phy_offset
+ (flag_ccb << 5));
-               ccb = container_of(arcmsr_cdb, struct
CommandControlBlock, arcmsr_cdb);
-               poll_ccb_done = (ccb == poll_ccb) ? 1:0;
+               arcmsr_cdb = (struct ARCMSR_CDB *)(acb->vir2phy_offset +
+                       (flag_ccb << 5));
+               ccb = container_of(arcmsr_cdb, struct CommandControlBlock,
+                       arcmsr_cdb);
+               poll_ccb_done = (ccb == poll_ccb) ? 1 : 0;
                if ((ccb->acb != acb) || (ccb->startdone != ARCMSR_CCB_START)) {
-                       if ((ccb->startdone == ARCMSR_CCB_ABORTED) ||
(ccb == poll_ccb)) {
-                               printk(KERN_NOTICE "arcmsr%d: scsi id
= %d lun = %d ccb = '0x%p'"
-                                       " poll command abort successfully \n"
+                       if ((ccb->startdone == ARCMSR_CCB_ABORTED) ||
+                               (ccb == poll_ccb)) {
+                               pr_notice("arcmsr%d: scsi id = %d "
+                                       "lun = %d ccb = '0x%p' poll command "
+                                       "abort successfully\n"
                                        , acb->host->host_no
                                        , ccb->pcmd->device->id
                                        , ccb->pcmd->device->lun
@@ -2663,22 +2740,24 @@ static int arcmsr_hbaA_polling_ccbdone(s
                                arcmsr_ccb_complete(ccb);
                                continue;
                        }
-                       printk(KERN_NOTICE "arcmsr%d: polling get an
illegal ccb"
-                               " command done ccb = '0x%p'"
-                               "ccboutstandingcount = %d \n"
+                       pr_notice("arcmsr%d: polling get an illegal "
+                               "ccb command done ccb = '0x%p' "
+                               "ccboutstandingcount = %d\n"
                                , acb->host->host_no
                                , ccb
                                , atomic_read(&acb->ccboutstandingcount));
                        continue;
                }
-               error = (flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR_MODE0)
? true : false;
+               error = (flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR_MODE0) ?
+                       true : false;
                arcmsr_report_ccb_state(acb, ccb, error);
        }
        return rtn;
 }

-static int arcmsr_hbaB_polling_ccbdone(struct AdapterControlBlock *acb,
-                                       struct CommandControlBlock *poll_ccb)
+static int
+arcmsr_hbaB_polling_ccbdone(struct AdapterControlBlock *acb,
+                               struct CommandControlBlock *poll_ccb)
 {
        struct MessageUnit_B *reg = acb->pmuB;
        struct ARCMSR_CDB *arcmsr_cdb;
@@ -2686,25 +2765,25 @@ static int arcmsr_hbaB_polling_ccbdone(s
        uint32_t flag_ccb, poll_ccb_done = 0, poll_count = 0;
        int index, rtn;
        bool error;
-       polling_hbaB_ccb_retry:

+polling_hbb_ccb_retry:
        poll_count++;
        /* clear doorbell interrupt */
        writel(ARCMSR_DOORBELL_INT_CLEAR_PATTERN, reg->iop2drv_doorbell);
-       while(1){
+       while (1) {
                index = reg->doneq_index;
                flag_ccb = reg->done_qbuffer[index];
                if (flag_ccb == 0) {
-                       if (poll_ccb_done){
+                       if (poll_ccb_done) {
                                rtn = SUCCESS;
                                break;
-                       }else {
+                       } else {
                                msleep(25);
-                               if (poll_count > 100){
+                               if (poll_count > 100) {
                                        rtn = FAILED;
                                        break;
                                }
-                               goto polling_hbaB_ccb_retry;
+                               goto polling_hbb_ccb_retry;
                        }
                }
                reg->done_qbuffer[index] = 0;
@@ -2713,36 +2792,44 @@ static int arcmsr_hbaB_polling_ccbdone(s
                index %= ARCMSR_MAX_HBB_POSTQUEUE;
                reg->doneq_index = index;
                /* check if command done with no error*/
-               arcmsr_cdb = (struct ARCMSR_CDB *)(acb->vir2phy_offset
+ (flag_ccb << 5));
-               ccb = container_of(arcmsr_cdb, struct
CommandControlBlock, arcmsr_cdb);
-               poll_ccb_done = (ccb == poll_ccb) ? 1:0;
-               if ((ccb->acb != acb) || (ccb->startdone != ARCMSR_CCB_START)) {
-                       if ((ccb->startdone == ARCMSR_CCB_ABORTED) ||
(ccb == poll_ccb)) {
-                               printk(KERN_NOTICE "arcmsr%d: scsi id
= %d lun = %d ccb = '0x%p'"
-                                       " poll command abort successfully \n"
-                                       ,acb->host->host_no
-                                       ,ccb->pcmd->device->id
-                                       ,ccb->pcmd->device->lun
-                                       ,ccb);
+               arcmsr_cdb = (struct ARCMSR_CDB *)
+                       (acb->vir2phy_offset + (flag_ccb << 5));
+               ccb = container_of(arcmsr_cdb, struct CommandControlBlock,
+                       arcmsr_cdb);
+               poll_ccb_done = (ccb == poll_ccb) ? 1 : 0;
+               if ((ccb->acb != acb) ||
+                       (ccb->startdone != ARCMSR_CCB_START)) {
+                       if ((ccb->startdone == ARCMSR_CCB_ABORTED) ||
+                               (ccb == poll_ccb)) {
+                               pr_notice("arcmsr%d: "
+                                       "scsi id = %d lun = %d ccb =
'0x%p' poll "
+                                       "command abort successfully\n"
+                                       , acb->host->host_no
+                                       , ccb->pcmd->device->id
+                                       , ccb->pcmd->device->lun
+                                       , ccb);
                                ccb->pcmd->result = DID_ABORT << 16;
                                arcmsr_ccb_complete(ccb);
                                continue;
                        }
-                       printk(KERN_NOTICE "arcmsr%d: polling get an
illegal ccb"
-                               " command done ccb = '0x%p'"
-                               "ccboutstandingcount = %d \n"
+                       pr_notice("arcmsr%d: polling get an "
+                               "illegal ccb command done ccb = '0x%p' "
+                               "ccboutstandingcount = %d\n"
                                , acb->host->host_no
                                , ccb
                                , atomic_read(&acb->ccboutstandingcount));
                        continue;
                }
-               error = (flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR_MODE0)
? true : false;
+               error = (flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR_MODE0)
+                       ? true : false;
                arcmsr_report_ccb_state(acb, ccb, error);
        }
        return rtn;
 }

-static int arcmsr_hbaC_polling_ccbdone(struct AdapterControlBlock
*acb, struct CommandControlBlock *poll_ccb)
+static int
+arcmsr_hbaC_polling_ccbdone(struct AdapterControlBlock *acb,
+       struct CommandControlBlock *poll_ccb)
 {
        struct MessageUnit_C __iomem *reg = acb->pmuC;
        uint32_t flag_ccb, ccb_cdb_phy;
@@ -2751,10 +2838,12 @@ static int arcmsr_hbaC_polling_ccbdone(s
        struct CommandControlBlock *pCCB;
        uint32_t poll_ccb_done = 0, poll_count = 0;
        int rtn;
-polling_hbaC_ccb_retry:
+
+polling_hbc_ccb_retry:
        poll_count++;
        while (1) {
-               if ((readl(&reg->host_int_status) &
ARCMSR_HBCMU_OUTBOUND_POSTQUEUE_ISR) == 0) {
+               if ((readl(&reg->host_int_status) &
+                       ARCMSR_HBCMU_OUTBOUND_POSTQUEUE_ISR) == 0) {
                        if (poll_ccb_done) {
                                rtn = SUCCESS;
                                break;
@@ -2764,101 +2853,105 @@ polling_hbaC_ccb_retry:
                                        rtn = FAILED;
                                        break;
                                }
-                               goto polling_hbaC_ccb_retry;
+                               goto polling_hbc_ccb_retry;
                        }
                }
                flag_ccb = readl(&reg->outbound_queueport_low);
                ccb_cdb_phy = (flag_ccb & 0xFFFFFFF0);
-               arcmsr_cdb = (struct ARCMSR_CDB *)(acb->vir2phy_offset
+ ccb_cdb_phy);/*frame must be 32 bytes aligned*/
-               pCCB = container_of(arcmsr_cdb, struct
CommandControlBlock, arcmsr_cdb);
+               arcmsr_cdb = (struct ARCMSR_CDB *)(acb->vir2phy_offset
+                       + ccb_cdb_phy);
+               pCCB = container_of(arcmsr_cdb, struct CommandControlBlock,
+                       arcmsr_cdb);
                poll_ccb_done = (pCCB == poll_ccb) ? 1 : 0;
                /* check ifcommand done with no error*/
-               if ((pCCB->acb != acb) || (pCCB->startdone !=
ARCMSR_CCB_START)) {
+               if ((pCCB->acb != acb) ||
+                       (pCCB->startdone != ARCMSR_CCB_START)) {
                        if (pCCB->startdone == ARCMSR_CCB_ABORTED) {
-                               printk(KERN_NOTICE "arcmsr%d: scsi id
= %d lun = %d ccb = '0x%p'"
-                                       " poll command abort successfully \n"
+                               pr_notice("arcmsr%d: "
+                                       "scsi id = %d lun = %d ccb =
'0x%p' poll "
+                                       "command abort successfully\n"
                                        , acb->host->host_no
                                        , pCCB->pcmd->device->id
                                        , pCCB->pcmd->device->lun
                                        , pCCB);
-                                       pCCB->pcmd->result = DID_ABORT << 16;
-                                       arcmsr_ccb_complete(pCCB);
+                               pCCB->pcmd->result = DID_ABORT << 16;
+                               arcmsr_ccb_complete(pCCB);
                                continue;
                        }
-                       printk(KERN_NOTICE "arcmsr%d: polling get an
illegal ccb"
-                               " command done ccb = '0x%p'"
-                               "ccboutstandingcount = %d \n"
+                       pr_notice("arcmsr%d: polling get an illegal "
+                               "ccb command done ccb = '0x%p' "
+                               "ccboutstandingcount = %d\n"
                                , acb->host->host_no
                                , pCCB
                                , atomic_read(&acb->ccboutstandingcount));
                        continue;
                }
-               error = (flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR_MODE1)
? true : false;
+               error = (flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR_MODE1)
+                       ? true : false;
                arcmsr_report_ccb_state(acb, pCCB, error);
        }
        return rtn;
 }
-static int arcmsr_polling_ccbdone(struct AdapterControlBlock *acb,
-                                       struct CommandControlBlock *poll_ccb)
+
+static int
+arcmsr_polling_ccbdone(struct AdapterControlBlock *acb,
+                               struct CommandControlBlock *poll_ccb)
 {
        int rtn = 0;
-       switch (acb->adapter_type) {

-       case ACB_ADAPTER_TYPE_A: {
+       switch (acb->adapter_type) {
+       case ACB_ADAPTER_TYPE_A:
                rtn = arcmsr_hbaA_polling_ccbdone(acb, poll_ccb);
-               }
                break;
-
-       case ACB_ADAPTER_TYPE_B: {
+       case ACB_ADAPTER_TYPE_B:
                rtn = arcmsr_hbaB_polling_ccbdone(acb, poll_ccb);
-               }
                break;
-       case ACB_ADAPTER_TYPE_C: {
+       case ACB_ADAPTER_TYPE_C:
                rtn = arcmsr_hbaC_polling_ccbdone(acb, poll_ccb);
-               }
+               break;
        }
        return rtn;
 }

-static int arcmsr_iop_confirm(struct AdapterControlBlock *acb)
+static int
+arcmsr_iop_confirm(struct AdapterControlBlock *acb)
 {
-       uint32_t cdb_phyaddr, cdb_phyaddr_hi32;
+       uint32_t cdb_phyaddr_hi32, cdb_phyaddr_lo32;
        dma_addr_t dma_coherent_handle;
+
        /*
        ********************************************************************
-       ** here we need to tell iop 331 our freeccb.HighPart
+       ** Here we need to tell iop our freeccb.HighPart
        ** if freeccb.HighPart is not zero
        ********************************************************************
        */
        dma_coherent_handle = acb->dma_coherent_handle;
-       cdb_phyaddr = (uint32_t)(dma_coherent_handle);
-       cdb_phyaddr_hi32 = (uint32_t)((cdb_phyaddr >> 16) >> 16);
+       cdb_phyaddr_lo32 = (uint32_t)(dma_coherent_handle & 0xffffffff);
+       cdb_phyaddr_hi32 = (uint32_t)((dma_coherent_handle >> 16) >> 16);
        acb->cdb_phyaddr_hi32 = cdb_phyaddr_hi32;
        /*
        ***********************************************************************
-       **    if adapter type B, set window of "post command Q"
+       ** if adapter type B set window of "post command Q"
        ***********************************************************************
        */
        switch (acb->adapter_type) {
-
        case ACB_ADAPTER_TYPE_A: {
                if (cdb_phyaddr_hi32 != 0) {
                        struct MessageUnit_A __iomem *reg = acb->pmuA;
-                       writel(ARCMSR_SIGNATURE_SET_CONFIG, \
-                                               &reg->message_rwbuffer[0]);
+                       writel(ARCMSR_SIGNATURE_SET_CONFIG,
+                               &reg->message_rwbuffer[0]);
                        writel(cdb_phyaddr_hi32, &reg->message_rwbuffer[1]);
-                       writel(ARCMSR_INBOUND_MESG0_SET_CONFIG, \
-                                                       &reg->inbound_msgaddr0);
+                       writel(ARCMSR_INBOUND_MESG0_SET_CONFIG,
+                               &reg->inbound_msgaddr0);
                        if (!arcmsr_hbaA_wait_msgint_ready(acb)) {
-                               printk(KERN_NOTICE "arcmsr%d: ""set ccb high \
-                               part physical address timeout\n",
-                               acb->host->host_no);
+                               pr_notice("arcmsr%d: set ccb "
+                                       "high part physical address timeout\n",
+                                       acb->host->host_no);
                                return 1;
                        }
                }
                }
                break;
-
        case ACB_ADAPTER_TYPE_B: {
                unsigned long post_queue_phyaddr;
                uint32_t __iomem *rwbuffer;
@@ -2868,7 +2961,7 @@ static int arcmsr_iop_confirm(struct Ada
                reg->doneq_index = 0;
                writel(ARCMSR_MESSAGE_SET_POST_WINDOW, reg->drv2iop_doorbell);
                if (!arcmsr_hbaB_wait_msgint_ready(acb)) {
-                       printk(KERN_NOTICE "arcmsr%d:can not set diver
mode\n", \
+                       pr_notice("arcmsr%d:can not set diver mode\n",
                                acb->host->host_no);
                        return 1;
                }
@@ -2884,50 +2977,60 @@ static int arcmsr_iop_confirm(struct Ada
                writel(post_queue_phyaddr + 1056, rwbuffer++);
                /* ccb maxQ size must be --> [(256 + 8)*4]*/
                writel(1056, rwbuffer);
-
                writel(ARCMSR_MESSAGE_SET_CONFIG, reg->drv2iop_doorbell);
                if (!arcmsr_hbaB_wait_msgint_ready(acb)) {
-                       printk(KERN_NOTICE "arcmsr%d: 'set command Q window' \
-                       timeout \n",acb->host->host_no);
+                       pr_notice("arcmsr%d: 'set command Q window' "
+                               "timeout\n", acb->host->host_no);
+                       return 1;
+               }
+               writel(ARCMSR_MESSAGE_START_DRIVER_MODE, reg->drv2iop_doorbell);
+               if (!arcmsr_hbaB_wait_msgint_ready(acb)) {
+                       pr_err("arcmsr%d: can't set driver mode.\n",
+                               acb->host->host_no);
                        return 1;
                }
-               arcmsr_hbaB_enable_driver_mode(acb);
                }
                break;
        case ACB_ADAPTER_TYPE_C: {
+               struct MessageUnit_C __iomem *reg = acb->pmuC;
                if (cdb_phyaddr_hi32 != 0) {
-                       struct MessageUnit_C __iomem *reg = acb->pmuC;
-
-                       printk(KERN_NOTICE "arcmsr%d: cdb_phyaddr_hi32=0x%x\n",
-                                       acb->adapter_index, cdb_phyaddr_hi32);
-                       writel(ARCMSR_SIGNATURE_SET_CONFIG,
&reg->msgcode_rwbuffer[0]);
+                       pr_notice("arcmsr%d: cdb_phyaddr_hi32 = 0x%x\n",
+                               acb->adapter_index, cdb_phyaddr_hi32);
+                       writel(ARCMSR_SIGNATURE_SET_CONFIG,
+                               &reg->msgcode_rwbuffer[0]);
                        writel(cdb_phyaddr_hi32, &reg->msgcode_rwbuffer[1]);
-                       writel(ARCMSR_INBOUND_MESG0_SET_CONFIG,
&reg->inbound_msgaddr0);
-                       writel(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE,
&reg->inbound_doorbell);
+                       writel(ARCMSR_INBOUND_MESG0_SET_CONFIG,
+                               &reg->inbound_msgaddr0);
+                       writel(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE,
+                               &reg->inbound_doorbell);
                        if (!arcmsr_hbaC_wait_msgint_ready(acb)) {
-                               printk(KERN_NOTICE "arcmsr%d: 'set
command Q window' \
-                               timeout \n", acb->host->host_no);
+                               pr_notice("arcmsr%d: 'set "
+                                       "command Q window' timeout\n",
+                                       acb->host->host_no);
                                return 1;
                        }
                }
                }
+               break;
        }
        return 0;
 }

-static void arcmsr_wait_firmware_ready(struct AdapterControlBlock *acb)
+static void
+arcmsr_wait_firmware_ready(struct AdapterControlBlock *acb)
 {
        uint32_t firmware_state = 0;
+
        switch (acb->adapter_type) {

        case ACB_ADAPTER_TYPE_A: {
                struct MessageUnit_A __iomem *reg = acb->pmuA;
                do {
                        firmware_state = readl(&reg->outbound_msgaddr1);
-               } while ((firmware_state &
ARCMSR_OUTBOUND_MESG1_FIRMWARE_OK) == 0);
+               } while ((firmware_state &
+                       ARCMSR_OUTBOUND_MESG1_FIRMWARE_OK) == 0);
                }
                break;
-
        case ACB_ADAPTER_TYPE_B: {
                struct MessageUnit_B *reg = acb->pmuB;
                do {
@@ -2940,131 +3043,162 @@ static void arcmsr_wait_firmware_ready(s
                struct MessageUnit_C __iomem *reg = acb->pmuC;
                do {
                        firmware_state = readl(&reg->outbound_msgaddr1);
-               } while ((firmware_state &
ARCMSR_HBCMU_MESSAGE_FIRMWARE_OK) == 0);
+               } while ((firmware_state &
+                       ARCMSR_HBCMU_MESSAGE_FIRMWARE_OK) == 0);
                }
+               break;
        }
 }

-static void arcmsr_hbaA_request_device_map(struct AdapterControlBlock *acb)
+static void
+arcmsr_hbaA_request_device_map(struct AdapterControlBlock *acb)
 {
        struct MessageUnit_A __iomem *reg = acb->pmuA;
-       if (unlikely(atomic_read(&acb->rq_map_token) == 0) ||
((acb->acb_flags & ACB_F_BUS_RESET) != 0 ) || ((acb->acb_flags &
ACB_F_ABORT) != 0 )){
-               mod_timer(&acb->eternal_timer, jiffies +
msecs_to_jiffies(6 * HZ));
-               return;
+
+       if (unlikely(atomic_read(&acb->rq_map_token) == 0) ||
+               ((acb->acb_flags & ACB_F_BUS_RESET) != 0) ||
+               ((acb->acb_flags & ACB_F_ABORT) != 0)) {
+               mod_timer(&acb->eternal_timer,
+                       jiffies + msecs_to_jiffies(6 * HZ));
        } else {
                acb->fw_flag = FW_NORMAL;
-               if (atomic_read(&acb->ante_token_value) ==
atomic_read(&acb->rq_map_token)){
+               if (atomic_read(&acb->ante_token_value) ==
+                       atomic_read(&acb->rq_map_token)) {
                        atomic_set(&acb->rq_map_token, 16);
                }
-               atomic_set(&acb->ante_token_value,
atomic_read(&acb->rq_map_token));
+               atomic_set(&acb->ante_token_value,
+                       atomic_read(&acb->rq_map_token));
                if (atomic_dec_and_test(&acb->rq_map_token)) {
-                       mod_timer(&acb->eternal_timer, jiffies +
msecs_to_jiffies(6 * HZ));
+                       mod_timer(&acb->eternal_timer,
+                               jiffies + msecs_to_jiffies(6 * HZ));
                        return;
                }
                writel(ARCMSR_INBOUND_MESG0_GET_CONFIG, &reg->inbound_msgaddr0);
-               mod_timer(&acb->eternal_timer, jiffies +
msecs_to_jiffies(6 * HZ));
+               mod_timer(&acb->eternal_timer, jiffies +
+                       msecs_to_jiffies(6 * HZ));
        }
-       return;
 }

-static void arcmsr_hbaB_request_device_map(struct AdapterControlBlock *acb)
+static void
+arcmsr_hbaB_request_device_map(struct AdapterControlBlock *acb)
 {
        struct MessageUnit_B *reg = acb->pmuB;
-       if (unlikely(atomic_read(&acb->rq_map_token) == 0) ||
((acb->acb_flags & ACB_F_BUS_RESET) != 0 ) || ((acb->acb_flags &
ACB_F_ABORT) != 0 )){
-               mod_timer(&acb->eternal_timer, jiffies +
msecs_to_jiffies(6 * HZ));
-               return;
+
+       if (unlikely(atomic_read(&acb->rq_map_token) == 0) ||
+               ((acb->acb_flags & ACB_F_BUS_RESET) != 0) ||
+               ((acb->acb_flags & ACB_F_ABORT) != 0)) {
+               mod_timer(&acb->eternal_timer, jiffies +
+                       msecs_to_jiffies(6 * HZ));
        } else {
                acb->fw_flag = FW_NORMAL;
-               if (atomic_read(&acb->ante_token_value) ==
atomic_read(&acb->rq_map_token)) {
+               if (atomic_read(&acb->ante_token_value) ==
+                       atomic_read(&acb->rq_map_token)) {
                        atomic_set(&acb->rq_map_token, 16);
                }
-               atomic_set(&acb->ante_token_value,
atomic_read(&acb->rq_map_token));
+               atomic_set(&acb->ante_token_value,
+                       atomic_read(&acb->rq_map_token));
                if (atomic_dec_and_test(&acb->rq_map_token)) {
-                       mod_timer(&acb->eternal_timer, jiffies +
msecs_to_jiffies(6 * HZ));
+                       mod_timer(&acb->eternal_timer,
+                               jiffies + msecs_to_jiffies(6 * HZ));
                        return;
                }
                writel(ARCMSR_MESSAGE_GET_CONFIG, reg->drv2iop_doorbell);
-               mod_timer(&acb->eternal_timer, jiffies +
msecs_to_jiffies(6 * HZ));
+               mod_timer(&acb->eternal_timer, jiffies +
+                       msecs_to_jiffies(6 * HZ));
        }
-       return;
 }

-static void arcmsr_hbaC_request_device_map(struct AdapterControlBlock *acb)
+static void
+arcmsr_hbaC_request_device_map(struct AdapterControlBlock *acb)
 {
        struct MessageUnit_C __iomem *reg = acb->pmuC;
-       if (unlikely(atomic_read(&acb->rq_map_token) == 0) ||
((acb->acb_flags & ACB_F_BUS_RESET) != 0) || ((acb->acb_flags &
ACB_F_ABORT) != 0)) {
-               mod_timer(&acb->eternal_timer, jiffies +
msecs_to_jiffies(6 * HZ));
-               return;
+
+       if (unlikely(atomic_read(&acb->rq_map_token) == 0) ||
+               ((acb->acb_flags & ACB_F_BUS_RESET) != 0) ||
+               ((acb->acb_flags & ACB_F_ABORT) != 0)) {
+               mod_timer(&acb->eternal_timer, jiffies +
+                       msecs_to_jiffies(6 * HZ));
        } else {
                acb->fw_flag = FW_NORMAL;
-               if (atomic_read(&acb->ante_token_value) ==
atomic_read(&acb->rq_map_token)) {
+               if (atomic_read(&acb->ante_token_value) ==
+                       atomic_read(&acb->rq_map_token)) {
                        atomic_set(&acb->rq_map_token, 16);
                }
-               atomic_set(&acb->ante_token_value,
atomic_read(&acb->rq_map_token));
+               atomic_set(&acb->ante_token_value,
+                       atomic_read(&acb->rq_map_token));
                if (atomic_dec_and_test(&acb->rq_map_token)) {
-                       mod_timer(&acb->eternal_timer, jiffies +
msecs_to_jiffies(6 * HZ));
+                       mod_timer(&acb->eternal_timer,
+                               jiffies + msecs_to_jiffies(6 * HZ));
                        return;
                }
                writel(ARCMSR_INBOUND_MESG0_GET_CONFIG, &reg->inbound_msgaddr0);
-               writel(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE,
&reg->inbound_doorbell);
-               mod_timer(&acb->eternal_timer, jiffies +
msecs_to_jiffies(6 * HZ));
+               writel(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE,
+                       &reg->inbound_doorbell);
+               mod_timer(&acb->eternal_timer, jiffies +
+                       msecs_to_jiffies(6 * HZ));
        }
-       return;
 }

-static void arcmsr_request_device_map(unsigned long pacb)
+static void
+arcmsr_request_device_map(unsigned long pacb)
 {
        struct AdapterControlBlock *acb = (struct AdapterControlBlock *)pacb;
+
        switch (acb->adapter_type) {
-               case ACB_ADAPTER_TYPE_A: {
-                       arcmsr_hbaA_request_device_map(acb);
-               }
+       case ACB_ADAPTER_TYPE_A:
+               arcmsr_hbaA_request_device_map(acb);
                break;
-               case ACB_ADAPTER_TYPE_B: {
-                       arcmsr_hbaB_request_device_map(acb);
-               }
+       case ACB_ADAPTER_TYPE_B:
+               arcmsr_hbaB_request_device_map(acb);
+               break;
+       case ACB_ADAPTER_TYPE_C:
+               arcmsr_hbaC_request_device_map(acb);
                break;
-               case ACB_ADAPTER_TYPE_C: {
-                       arcmsr_hbaC_request_device_map(acb);
-               }
        }
 }

-static void arcmsr_hbaA_start_bgrb(struct AdapterControlBlock *acb)
+static void
+arcmsr_hbaA_start_bgrb(struct AdapterControlBlock *acb)
 {
        struct MessageUnit_A __iomem *reg = acb->pmuA;
+
        acb->acb_flags |= ACB_F_MSG_START_BGRB;
        writel(ARCMSR_INBOUND_MESG0_START_BGRB, &reg->inbound_msgaddr0);
        if (!arcmsr_hbaA_wait_msgint_ready(acb)) {
-               printk(KERN_NOTICE "arcmsr%d: wait 'start adapter background \
-                               rebulid' timeout \n", acb->host->host_no);
+               pr_notice("arcmsr%d: wait 'start adapter background "
+                       "rebulid' timeout\n", acb->host->host_no);
        }
 }

-static void arcmsr_hbaB_start_bgrb(struct AdapterControlBlock *acb)
+static void
+arcmsr_hbaB_start_bgrb(struct AdapterControlBlock *acb)
 {
        struct MessageUnit_B *reg = acb->pmuB;
+
        acb->acb_flags |= ACB_F_MSG_START_BGRB;
        writel(ARCMSR_MESSAGE_START_BGRB, reg->drv2iop_doorbell);
        if (!arcmsr_hbaB_wait_msgint_ready(acb)) {
-               printk(KERN_NOTICE "arcmsr%d: wait 'start adapter background \
-                               rebulid' timeout \n",acb->host->host_no);
+               pr_notice("arcmsr%d: wait 'start adapter background "
+                       "rebulid' timeout\n", acb->host->host_no);
        }
 }

-static void arcmsr_hbaC_start_bgrb(struct AdapterControlBlock *pACB)
+static void
+arcmsr_hbaC_start_bgrb(struct AdapterControlBlock *pACB)
 {
        struct MessageUnit_C __iomem *phbcmu = pACB->pmuC;
+
        pACB->acb_flags |= ACB_F_MSG_START_BGRB;
        writel(ARCMSR_INBOUND_MESG0_START_BGRB, &phbcmu->inbound_msgaddr0);
        writel(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE,
&phbcmu->inbound_doorbell);
        if (!arcmsr_hbaC_wait_msgint_ready(pACB)) {
-               printk(KERN_NOTICE "arcmsr%d: wait 'start adapter background \
-                               rebulid' timeout \n", pACB->host->host_no);
+               pr_notice("arcmsr%d: wait 'start adapter background "
+                       "rebulid' timeout\n", pACB->host->host_no);
        }
-       return;
 }
-static void arcmsr_start_adapter_bgrb(struct AdapterControlBlock *acb)
+
+static void
+arcmsr_start_adapter_bgrb(struct AdapterControlBlock *acb)
 {
        switch (acb->adapter_type) {
        case ACB_ADAPTER_TYPE_A:
@@ -3075,10 +3209,12 @@ static void arcmsr_start_adapter_bgrb(st
                break;
        case ACB_ADAPTER_TYPE_C:
                arcmsr_hbaC_start_bgrb(acb);
+               break;
        }
 }

-static void arcmsr_clear_doorbell_queue_buffer(struct AdapterControlBlock *acb)
+static void
+arcmsr_clear_doorbell_queue_buffer(struct AdapterControlBlock *acb)
 {
        switch (acb->adapter_type) {
        case ACB_ADAPTER_TYPE_A: {
@@ -3088,10 +3224,10 @@ static void arcmsr_clear_doorbell_queue_
                outbound_doorbell = readl(&reg->outbound_doorbell);
                /*clear doorbell interrupt */
                writel(outbound_doorbell, &reg->outbound_doorbell);
-               writel(ARCMSR_INBOUND_DRIVER_DATA_READ_OK,
&reg->inbound_doorbell);
+               writel(ARCMSR_INBOUND_DRIVER_DATA_READ_OK,
+                       &reg->inbound_doorbell);
                }
                break;
-
        case ACB_ADAPTER_TYPE_B: {
                struct MessageUnit_B *reg = acb->pmuB;
                /*clear interrupt and message state*/
@@ -3102,37 +3238,43 @@ static void arcmsr_clear_doorbell_queue_
                break;
        case ACB_ADAPTER_TYPE_C: {
                struct MessageUnit_C __iomem *reg = acb->pmuC;
-               uint32_t outbound_doorbell;
+               uint32_t outbound_doorbell, i;
                /* empty doorbell Qbuffer if door bell ringed */
                outbound_doorbell = readl(&reg->outbound_doorbell);
                writel(outbound_doorbell, &reg->outbound_doorbell_clear);
-               writel(ARCMSR_HBCMU_DRV2IOP_DATA_READ_OK,
&reg->inbound_doorbell);
+               writel(ARCMSR_HBCMU_DRV2IOP_DATA_READ_OK,
+                       &reg->inbound_doorbell);
+               for (i = 0; i < 200; i++) {
+                       msleep(20);
+                       outbound_doorbell = readl(&reg->outbound_doorbell);
+                       if (outbound_doorbell &
+                               ARCMSR_HBCMU_IOP2DRV_DATA_WRITE_OK) {
+                               writel(outbound_doorbell,
+                                       &reg->outbound_doorbell_clear);
+                               writel(ARCMSR_HBCMU_DRV2IOP_DATA_READ_OK,
+                                       &reg->inbound_doorbell);
+                       } else
+                               break;
                }
+               }
+               break;
        }
 }

-static void arcmsr_enable_eoi_mode(struct AdapterControlBlock *acb)
+static void
+arcmsr_enable_eoi_mode(struct AdapterControlBlock *acb)
 {
-       switch (acb->adapter_type) {
-       case ACB_ADAPTER_TYPE_A:
-               return;
-       case ACB_ADAPTER_TYPE_B:
-               {
-                       struct MessageUnit_B *reg = acb->pmuB;
-                       writel(ARCMSR_MESSAGE_ACTIVE_EOI_MODE,
reg->drv2iop_doorbell);
-                       if (!arcmsr_hbaB_wait_msgint_ready(acb)) {
-                               printk(KERN_NOTICE "ARCMSR IOP enables
EOI_MODE TIMEOUT");
-                               return;
-                       }
-               }
-               break;
-       case ACB_ADAPTER_TYPE_C:
-               return;
+       struct MessageUnit_B *reg = acb->pmuB;
+
+       if (acb->adapter_type == ACB_ADAPTER_TYPE_B) {
+               writel(ARCMSR_MESSAGE_ACTIVE_EOI_MODE, reg->drv2iop_doorbell);
+               if (!arcmsr_hbaB_wait_msgint_ready(acb))
+                       pr_notice("ARCMSR IOP enables EOI_MODE TIMEOUT");
        }
-       return;
 }

-static void arcmsr_hardware_reset(struct AdapterControlBlock *acb)
+static void
+arcmsr_hardware_reset(struct AdapterControlBlock *acb)
 {
        uint8_t value[64];
        int i, count = 0;
@@ -3140,7 +3282,8 @@ static void arcmsr_hardware_reset(struct
        struct MessageUnit_C __iomem *pmuC = acb->pmuC;

        /* backup pci config data */
-       printk(KERN_NOTICE "arcmsr%d: executing hw bus reset .....\n",
acb->host->host_no);
+       pr_notice("arcmsr%d: executing hw bus reset .....\n",
+               acb->host->host_no);
        for (i = 0; i < 64; i++) {
                pci_read_config_byte(acb->pdev, i, &value[i]);
        }
@@ -3156,7 +3299,8 @@ static void arcmsr_hardware_reset(struct
                        writel(0x2, &pmuC->write_sequence);
                        writel(0x7, &pmuC->write_sequence);
                        writel(0xD, &pmuC->write_sequence);
-               } while (((readl(&pmuC->host_diagnostic) &
ARCMSR_ARC1880_DiagWrite_ENABLE) == 0) && (count < 5));
+               } while (((readl(&pmuC->host_diagnostic) &
+                       ARCMSR_ARC1880_DiagWrite_ENABLE) == 0) && (count < 5));
                writel(ARCMSR_ARC1880_RESET_ADAPTER, &pmuC->host_diagnostic);
        } else {
                pci_write_config_byte(acb->pdev, 0x84, 0x20);
@@ -3167,11 +3311,13 @@ static void arcmsr_hardware_reset(struct
                pci_write_config_byte(acb->pdev, i, value[i]);
        }
        msleep(1000);
-       return;
 }
-static void arcmsr_iop_init(struct AdapterControlBlock *acb)
+
+static void
+arcmsr_iop_init(struct AdapterControlBlock *acb)
 {
        uint32_t intmask_org;
+
        /* disable all outbound interrupt */
        intmask_org = arcmsr_disable_outbound_ints(acb);
        arcmsr_wait_firmware_ready(acb);
@@ -3186,7 +3332,8 @@ static void arcmsr_iop_init(struct Adapt
        acb->acb_flags |= ACB_F_IOP_INITED;
 }

-static uint8_t arcmsr_iop_reset(struct AdapterControlBlock *acb)
+static uint8_t
+arcmsr_iop_reset(struct AdapterControlBlock *acb)
 {
        struct CommandControlBlock *ccb;
        uint32_t intmask_org;
@@ -3209,7 +3356,8 @@ static uint8_t arcmsr_iop_reset(struct A
                                ccb->ccb_flags = 0;
                                spin_lock_irqsave(&acb->ccblist_lock, flags);
                                list_add_tail(&ccb->list, &acb->ccb_free_list);
-
spin_unlock_irqrestore(&acb->ccblist_lock, flags);
+                               spin_unlock_irqrestore(&acb->ccblist_lock,
+                                       flags);
                        }
                }
                atomic_set(&acb->ccboutstandingcount, 0);
@@ -3220,162 +3368,182 @@ static uint8_t arcmsr_iop_reset(struct A
        return rtnval;
 }

-static int arcmsr_bus_reset(struct scsi_cmnd *cmd)
+static int
+arcmsr_bus_reset(struct scsi_cmnd *cmd)
 {
        struct AdapterControlBlock *acb;
-       uint32_t intmask_org, outbound_doorbell;
+       uint32_t intmask_org;
        int retry_count = 0;
        int rtn = FAILED;
+
        acb = (struct AdapterControlBlock *) cmd->device->host->hostdata;
-       printk(KERN_ERR "arcmsr: executing bus reset eh.....num_resets
= %d, num_aborts = %d \n", acb->num_resets, acb->num_aborts);
+       pr_err("arcmsr: executing bus reset eh.....num_resets = %d, "
+               "num_aborts = %d\n", acb->num_resets, acb->num_aborts);
        acb->num_resets++;
-
-       switch(acb->adapter_type){
-               case ACB_ADAPTER_TYPE_A:{
-                       if (acb->acb_flags & ACB_F_BUS_RESET){
-                               long timeout;
-                               printk(KERN_ERR "arcmsr: there is an
bus reset eh proceeding.......\n");
-                               timeout = wait_event_timeout(wait_q,
(acb->acb_flags & ACB_F_BUS_RESET) == 0, 220*HZ);
-                               if (timeout) {
-                                       return SUCCESS;
-                               }
-                       }
-                       acb->acb_flags |= ACB_F_BUS_RESET;
-                       if (!arcmsr_iop_reset(acb)) {
-                               struct MessageUnit_A __iomem *reg;
-                               reg = acb->pmuA;
-                               arcmsr_hardware_reset(acb);
-                               acb->acb_flags &= ~ACB_F_IOP_INITED;
+       switch (acb->adapter_type) {
+       case ACB_ADAPTER_TYPE_A: {
+               if (acb->acb_flags & ACB_F_BUS_RESET) {
+                       long timeout;
+                       pr_err("arcmsr: there is an bus "
+                               "reset eh proceeding.......\n");
+                       timeout = wait_event_timeout(wait_q, (acb->acb_flags &
+                               ACB_F_BUS_RESET) == 0, 220 * HZ);
+                       if (timeout)
+                               return SUCCESS;
+               }
+               acb->acb_flags |= ACB_F_BUS_RESET;
+               if (!arcmsr_iop_reset(acb)) {
+                       struct MessageUnit_A __iomem *reg;
+                       reg = acb->pmuA;
+                       arcmsr_hardware_reset(acb);
+                       acb->acb_flags &= ~ACB_F_IOP_INITED;
 sleep_again:
-                               ssleep(ARCMSR_SLEEPTIME);
-                               if ((readl(&reg->outbound_msgaddr1) &
ARCMSR_OUTBOUND_MESG1_FIRMWARE_OK) == 0) {
-                                       printk(KERN_ERR "arcmsr%d:
waiting for hw bus reset return, retry=%d\n", acb->host->host_no,
retry_count);
-                                       if (retry_count > ARCMSR_RETRYCOUNT) {
-                                               acb->fw_flag = FW_DEADLOCK;
-                                               printk(KERN_ERR
"arcmsr%d: waiting for hw bus reset return, RETRY TERMINATED!!\n",
acb->host->host_no);
-                                               return FAILED;
-                                       }
-                                       retry_count++;
-                                       goto sleep_again;
+                       ssleep(ARCMSR_SLEEPTIME);
+                       if ((readl(&reg->outbound_msgaddr1) &
+                               ARCMSR_OUTBOUND_MESG1_FIRMWARE_OK) == 0) {
+                               pr_err("arcmsr%d: waiting for "
+                                       "hw bus reset return, retry = %d\n",
+                                       acb->host->host_no, retry_count);
+                               if (retry_count > ARCMSR_RETRYCOUNT) {
+                                       acb->fw_flag = FW_DEADLOCK;
+                                       pr_err("arcmsr%d: waiting "
+                                               "for hw bus reset return, "
+                                               "RETRY TERMINATED!!\n",
+                                               acb->host->host_no);
+                                       return FAILED;
                                }
-                               acb->acb_flags |= ACB_F_IOP_INITED;
-                               /* disable all outbound interrupt */
-                               intmask_org = arcmsr_disable_outbound_ints(acb);
-                               arcmsr_get_firmware_spec(acb);
-                               arcmsr_start_adapter_bgrb(acb);
-                               /* clear Qbuffer if door bell ringed */
-                               outbound_doorbell =
readl(&reg->outbound_doorbell);
-                               writel(outbound_doorbell,
&reg->outbound_doorbell); /*clear interrupt */
-
writel(ARCMSR_INBOUND_DRIVER_DATA_READ_OK, &reg->inbound_doorbell);
-                               /* enable outbound Post Queue,outbound
doorbell Interrupt */
-                               arcmsr_enable_outbound_ints(acb, intmask_org);
-                               atomic_set(&acb->rq_map_token, 16);
-                               atomic_set(&acb->ante_token_value, 16);
-                               acb->fw_flag = FW_NORMAL;
-                               mod_timer(&acb->eternal_timer, jiffies
+ msecs_to_jiffies(6 * HZ));
-                               acb->acb_flags &= ~ACB_F_BUS_RESET;
-                               rtn = SUCCESS;
-                               printk(KERN_ERR "arcmsr: scsi  bus
reset eh returns with success\n");
-                       } else {
-                               acb->acb_flags &= ~ACB_F_BUS_RESET;
-                               atomic_set(&acb->rq_map_token, 16);
-                               atomic_set(&acb->ante_token_value, 16);
-                               acb->fw_flag = FW_NORMAL;
-                               mod_timer(&acb->eternal_timer, jiffies
+ msecs_to_jiffies(6*HZ));
-                               rtn = SUCCESS;
+                               retry_count++;
+                               goto sleep_again;
                        }
-                       break;
+                       acb->acb_flags |= ACB_F_IOP_INITED;
+                       /* disable all outbound interrupt */
+                       intmask_org = arcmsr_disable_outbound_ints(acb);
+                       arcmsr_get_firmware_spec(acb);
+                       arcmsr_start_adapter_bgrb(acb);
+                       /* clear Qbuffer if door bell ringed */
+                       arcmsr_clear_doorbell_queue_buffer(acb);
+                       arcmsr_enable_outbound_ints(acb, intmask_org);
+                       atomic_set(&acb->rq_map_token, 16);
+                       atomic_set(&acb->ante_token_value, 16);
+                       acb->fw_flag = FW_NORMAL;
+                       mod_timer(&acb->eternal_timer, jiffies +
+                               msecs_to_jiffies(6 * HZ));
+                       acb->acb_flags &= ~ACB_F_BUS_RESET;
+                       rtn = SUCCESS;
+                       pr_err("arcmsr: scsi bus reset eh "
+                               "returns with success\n");
+               } else {
+                       acb->acb_flags &= ~ACB_F_BUS_RESET;
+                       atomic_set(&acb->rq_map_token, 16);
+                       atomic_set(&acb->ante_token_value, 16);
+                       acb->fw_flag = FW_NORMAL;
+                       mod_timer(&acb->eternal_timer,
+                               jiffies + msecs_to_jiffies(6 * HZ));
+                       rtn = SUCCESS;
                }
-               case ACB_ADAPTER_TYPE_B:{
-                       acb->acb_flags |= ACB_F_BUS_RESET;
-                       if (!arcmsr_iop_reset(acb)) {
-                               acb->acb_flags &= ~ACB_F_BUS_RESET;
-                               rtn = FAILED;
-                       } else {
-                               acb->acb_flags &= ~ACB_F_BUS_RESET;
-                               atomic_set(&acb->rq_map_token, 16);
-                               atomic_set(&acb->ante_token_value, 16);
-                               acb->fw_flag = FW_NORMAL;
-                               mod_timer(&acb->eternal_timer, jiffies
+ msecs_to_jiffies(6 * HZ));
-                               rtn = SUCCESS;
-                       }
-                       break;
+               break;
+       }
+       case ACB_ADAPTER_TYPE_B: {
+               acb->acb_flags |= ACB_F_BUS_RESET;
+               if (!arcmsr_iop_reset(acb)) {
+                       acb->acb_flags &= ~ACB_F_BUS_RESET;
+                       rtn = FAILED;
+               } else {
+                       acb->acb_flags &= ~ACB_F_BUS_RESET;
+                       atomic_set(&acb->rq_map_token, 16);
+                       atomic_set(&acb->ante_token_value, 16);
+                       acb->fw_flag = FW_NORMAL;
+                       mod_timer(&acb->eternal_timer,
+                               jiffies + msecs_to_jiffies(6 * HZ));
+                       rtn = SUCCESS;
                }
-               case ACB_ADAPTER_TYPE_C:{
-                       if (acb->acb_flags & ACB_F_BUS_RESET) {
-                               long timeout;
-                               printk(KERN_ERR "arcmsr: there is an
bus reset eh proceeding.......\n");
-                               timeout = wait_event_timeout(wait_q,
(acb->acb_flags & ACB_F_BUS_RESET) == 0, 220*HZ);
-                               if (timeout) {
-                                       return SUCCESS;
-                               }
-                       }
-                       acb->acb_flags |= ACB_F_BUS_RESET;
-                       if (!arcmsr_iop_reset(acb)) {
-                               struct MessageUnit_C __iomem *reg;
-                               reg = acb->pmuC;
-                               arcmsr_hardware_reset(acb);
-                               acb->acb_flags &= ~ACB_F_IOP_INITED;
+               break;
+       }
+       case ACB_ADAPTER_TYPE_C: {
+               if (acb->acb_flags & ACB_F_BUS_RESET) {
+                       long timeout;
+                       pr_err("arcmsr: there is an bus "
+                               "reset eh proceeding.......\n");
+                       timeout = wait_event_timeout(wait_q,
+                               (acb->acb_flags & ACB_F_BUS_RESET) == 0,
+                               220 * HZ);
+                       if (timeout)
+                               return SUCCESS;
+               }
+               acb->acb_flags |= ACB_F_BUS_RESET;
+               if (!arcmsr_iop_reset(acb)) {
+                       struct MessageUnit_C __iomem *reg;
+                       reg = acb->pmuC;
+                       arcmsr_hardware_reset(acb);
+                       acb->acb_flags &= ~ACB_F_IOP_INITED;
 sleep:
-                               ssleep(ARCMSR_SLEEPTIME);
-                               if ((readl(&reg->host_diagnostic) &
0x04) != 0) {
-                                       printk(KERN_ERR "arcmsr%d:
waiting for hw bus reset return, retry=%d\n", acb->host->host_no,
retry_count);
-                                       if (retry_count > ARCMSR_RETRYCOUNT) {
-                                               acb->fw_flag = FW_DEADLOCK;
-                                               printk(KERN_ERR
"arcmsr%d: waiting for hw bus reset return, RETRY TERMINATED!!\n",
acb->host->host_no);
-                                               return FAILED;
-                                       }
-                                       retry_count++;
-                                       goto sleep;
+                       ssleep(ARCMSR_SLEEPTIME);
+                       if ((readl(&reg->host_diagnostic) & 0x04) != 0) {
+                               pr_err("arcmsr%d: waiting "
+                                       "for hw bus reset return, retry = %d\n",
+                                       acb->host->host_no, retry_count);
+                               if (retry_count > ARCMSR_RETRYCOUNT) {
+                                       acb->fw_flag = FW_DEADLOCK;
+                                       pr_err("arcmsr%d: "
+                                               "waiting for hw bus reset "
+                                               "return, RETRY TERMINATED!!\n",
+                                               acb->host->host_no);
+                                       return FAILED;
                                }
-                               acb->acb_flags |= ACB_F_IOP_INITED;
-                               /* disable all outbound interrupt */
-                               intmask_org = arcmsr_disable_outbound_ints(acb);
-                               arcmsr_get_firmware_spec(acb);
-                               arcmsr_start_adapter_bgrb(acb);
-                               /* clear Qbuffer if door bell ringed */
-                               outbound_doorbell =
readl(&reg->outbound_doorbell);
-                               writel(outbound_doorbell,
&reg->outbound_doorbell_clear); /*clear interrupt */
-
writel(ARCMSR_HBCMU_DRV2IOP_DATA_READ_OK, &reg->inbound_doorbell);
-                               /* enable outbound Post Queue,outbound
doorbell Interrupt */
-                               arcmsr_enable_outbound_ints(acb, intmask_org);
-                               atomic_set(&acb->rq_map_token, 16);
-                               atomic_set(&acb->ante_token_value, 16);
-                               acb->fw_flag = FW_NORMAL;
-                               mod_timer(&acb->eternal_timer, jiffies
+ msecs_to_jiffies(6 * HZ));
-                               acb->acb_flags &= ~ACB_F_BUS_RESET;
-                               rtn = SUCCESS;
-                               printk(KERN_ERR "arcmsr: scsi bus
reset eh returns with success\n");
-                       } else {
-                               acb->acb_flags &= ~ACB_F_BUS_RESET;
-                               atomic_set(&acb->rq_map_token, 16);
-                               atomic_set(&acb->ante_token_value, 16);
-                               acb->fw_flag = FW_NORMAL;
-                               mod_timer(&acb->eternal_timer, jiffies
+ msecs_to_jiffies(6*HZ));
-                               rtn = SUCCESS;
+                               retry_count++;
+                               goto sleep;
                        }
-                       break;
+                       acb->acb_flags |= ACB_F_IOP_INITED;
+                       /* disable all outbound interrupt */
+                       intmask_org = arcmsr_disable_outbound_ints(acb);
+                       arcmsr_get_firmware_spec(acb);
+                       arcmsr_start_adapter_bgrb(acb);
+                       arcmsr_clear_doorbell_queue_buffer(acb);
+                       arcmsr_enable_outbound_ints(acb, intmask_org);
+                       atomic_set(&acb->rq_map_token, 16);
+                       atomic_set(&acb->ante_token_value, 16);
+                       acb->fw_flag = FW_NORMAL;
+                       mod_timer(&acb->eternal_timer, jiffies +
+                               msecs_to_jiffies(6 * HZ));
+                       acb->acb_flags &= ~ACB_F_BUS_RESET;
+                       rtn = SUCCESS;
+                       pr_err("arcmsr: scsi bus reset "
+                               "eh returns with success\n");
+               } else {
+                       acb->acb_flags &= ~ACB_F_BUS_RESET;
+                       atomic_set(&acb->rq_map_token, 16);
+                       atomic_set(&acb->ante_token_value, 16);
+                       acb->fw_flag = FW_NORMAL;
+                       mod_timer(&acb->eternal_timer, jiffies +
+                               msecs_to_jiffies(6 * HZ));
+                       rtn = SUCCESS;
                }
+               break;
+       }
        }
        return rtn;
 }

-static int arcmsr_abort_one_cmd(struct AdapterControlBlock *acb,
+static int
+arcmsr_abort_one_cmd(struct AdapterControlBlock *acb,
                struct CommandControlBlock *ccb)
 {
        int rtn;
+
        rtn = arcmsr_polling_ccbdone(acb, ccb);
        return rtn;
 }

-static int arcmsr_abort(struct scsi_cmnd *cmd)
+static int
+arcmsr_abort(struct scsi_cmnd *cmd)
 {
        struct AdapterControlBlock *acb =
                (struct AdapterControlBlock *)cmd->device->host->hostdata;
        int i = 0;
        int rtn = FAILED;
-       printk(KERN_NOTICE
-               "arcmsr%d: abort device command of scsi id = %d lun = %d \n",
+       uint32_t intmask_org;
+
+       pr_notice("arcmsr%d: abort device command of scsi id = %d lun = %d\n",
                acb->host->host_no, cmd->device->id, cmd->device->lun);
        acb->acb_flags |= ACB_F_ABORT;
        acb->num_aborts++;
@@ -3385,9 +3553,12 @@ static int arcmsr_abort(struct scsi_cmnd
        ** we need to handle it as soon as possible and exit
        ************************************************
        */
-       if (!atomic_read(&acb->ccboutstandingcount))
-               return rtn;
+       if (!atomic_read(&acb->ccboutstandingcount)) {
+               acb->acb_flags &= ~ACB_F_ABORT;
+               return SUCCESS;
+       }

+       intmask_org = arcmsr_disable_outbound_ints(acb);
        for (i = 0; i < ARCMSR_MAX_FREECCB_NUM; i++) {
                struct CommandControlBlock *ccb = acb->pccb_pool[i];
                if (ccb->startdone == ARCMSR_CCB_START && ccb->pcmd == cmd) {
@@ -3396,17 +3567,20 @@ static int arcmsr_abort(struct scsi_cmnd
                        break;
                }
        }
+       arcmsr_enable_outbound_ints(acb, intmask_org);
        acb->acb_flags &= ~ACB_F_ABORT;
        return rtn;
 }

-static const char *arcmsr_info(struct Scsi_Host *host)
+static const char
+*arcmsr_info(struct Scsi_Host *host)
 {
        struct AdapterControlBlock *acb =
-               (struct AdapterControlBlock *) host->hostdata;
+               (struct AdapterControlBlock *)host->hostdata;
        static char buf[256];
        char *type;
        int raid6 = 1;
+
        switch (acb->pdev->device) {
        case PCI_DEVICE_ID_ARECA_1110:
        case PCI_DEVICE_ID_ARECA_1200:
@@ -3431,15 +3605,15 @@ static const char *arcmsr_info(struct Sc
        case PCI_DEVICE_ID_ARECA_1680:
        case PCI_DEVICE_ID_ARECA_1681:
        case PCI_DEVICE_ID_ARECA_1880:
-               type = "SAS";
+               type = "SAS/SATA";
                break;
        default:
-               type = "X-TYPE";
+               type = "unknown";
+               raid6 = 0;
                break;
        }
-       sprintf(buf, "Areca %s Host Adapter RAID Controller%s\n %s",
-                       type, raid6 ? "( RAID6 capable)" : "",
-                       ARCMSR_DRIVER_VERSION);
+       sprintf(buf, "Areca %s RAID Controller %s\narcmsr version %s\n",
+               type, raid6 ? "(RAID6 capable)" : "", ARCMSR_DRIVER_VERSION);
        return buf;
 }

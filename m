From: =?Big5?B?tsCyTbap?= <ching2048@areca.com.tw>
Subject: Re: [PATCH 1/1 v1.1] arcmsr: Support Areca new SATA Raid Adapter
 ARC1214/1224/1264/1284 (Resend renew)
Date: Thu, 29 Aug 2013 12:55:51 +0800
Message-ID: <CAKiknE_FJN7gRLMFHCfNOtjg73fLLCQ45yacHb+w1B46C5dJQA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=001a1133aa8693883304e50eeb28
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@kernel.org, Tomas Henzl <thenzl@redhat.com>, fengguang.wu@intel.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>
Cc: jbottomley@parallels.com
List-Id: linux-scsi@vger.kernel.org

--001a1133aa8693883304e50eeb28
Content-Type: text/plain; charset=ISO-8859-1

Update the patch code.

From: Ching<ching2048@areca.com.tw>

Support Areca new SATA Raid Adapter ARC1214/1224/1264/1284.
Modify maximum outstanding command number.
Notify command complete with auto request sense.
Fix bug of updating adapter firmware through ioctl(ARCHTTP) interface.
Fix coding style warning.
Fix compiling warning.
Fix ARC1880 hardware reset.
Fix coding style - indent

This patch is for arcmsr source code in kernel tree.
The following patch code also in attached file patch.

Signed-off-by:  Ching <ching2048@areca.com.tw>
---

diff -uprN a/drivers/scsi/arcmsr/arcmsr_attr.c
b/drivers/scsi/arcmsr/arcmsr_attr.c
--- a/drivers/scsi/arcmsr/arcmsr_attr.c 2013-07-01 06:13:28.000000000 +0800
+++ b/drivers/scsi/arcmsr/arcmsr_attr.c 2013-08-29 19:48:40.000000000 +0800
@@ -59,64 +59,87 @@

 struct device_attribute *arcmsr_host_attrs[];

-static ssize_t arcmsr_sysfs_iop_message_read(struct file *filp,
-     struct kobject *kobj,
-     struct bin_attribute *bin,
-     char *buf, loff_t off,
-     size_t count)
+static ssize_t
+arcmsr_sysfs_iop_message_read(struct file *filp,
+ struct kobject *kobj,
+ struct bin_attribute *bin,
+ char *buf, loff_t off,
+ size_t count)
 {
- struct device *dev = container_of(kobj,struct device,kobj);
+ struct device *dev = container_of(kobj, struct device, kobj);
  struct Scsi_Host *host = class_to_shost(dev);
- struct AdapterControlBlock *acb = (struct AdapterControlBlock *)
host->hostdata;
+ struct AdapterControlBlock *acb =
+ (struct AdapterControlBlock *)host->hostdata;
  uint8_t *pQbuffer,*ptmpQbuffer;
  int32_t allxfer_len = 0;
+ unsigned long flags;

  if (!capable(CAP_SYS_ADMIN))
  return -EACCES;

  /* do message unit read. */
  ptmpQbuffer = (uint8_t *)buf;
- while ((acb->rqbuf_firstindex != acb->rqbuf_lastindex)
- && (allxfer_len < 1031)) {
+ spin_lock_irqsave(&acb->rqbuffer_lock, flags);
+ if (acb->rqbuf_firstindex != acb->rqbuf_lastindex) {
  pQbuffer = &acb->rqbuffer[acb->rqbuf_firstindex];
- memcpy(ptmpQbuffer, pQbuffer, 1);
- acb->rqbuf_firstindex++;
- acb->rqbuf_firstindex %= ARCMSR_MAX_QBUFFER;
- ptmpQbuffer++;
- allxfer_len++;
+ if (acb->rqbuf_firstindex > acb->rqbuf_lastindex) {
+ if ((ARCMSR_MAX_QBUFFER - acb->rqbuf_firstindex) >= 1032) {
+ memcpy((void *)ptmpQbuffer, (const void *)pQbuffer, 1032);
+ acb->rqbuf_firstindex += 1032;
+ acb->rqbuf_firstindex %= ARCMSR_MAX_QBUFFER;
+ allxfer_len = 1032;
+ } else {
+ if (((ARCMSR_MAX_QBUFFER - acb->rqbuf_firstindex) +
acb->rqbuf_lastindex) > 1032) {
+ memcpy((void *)ptmpQbuffer, (const void *)pQbuffer,
ARCMSR_MAX_QBUFFER - acb->rqbuf_firstindex);
+ ptmpQbuffer += ARCMSR_MAX_QBUFFER - acb->rqbuf_firstindex;
+ memcpy((void *)ptmpQbuffer, (const void *)acb->rqbuffer, 1032 -
(ARCMSR_MAX_QBUFFER - acb->rqbuf_firstindex));
+ acb->rqbuf_firstindex = 1032 - (ARCMSR_MAX_QBUFFER - acb->rqbuf_firstindex);
+ allxfer_len = 1032;
+ } else {
+ memcpy((void *)ptmpQbuffer, (const void *)pQbuffer,
ARCMSR_MAX_QBUFFER - acb->rqbuf_firstindex);
+ ptmpQbuffer += ARCMSR_MAX_QBUFFER - acb->rqbuf_firstindex;
+ memcpy((void *)ptmpQbuffer, (const void *)acb->rqbuffer,
acb->rqbuf_lastindex);
+ allxfer_len = ARCMSR_MAX_QBUFFER - acb->rqbuf_firstindex +
acb->rqbuf_lastindex;
+ acb->rqbuf_firstindex = acb->rqbuf_lastindex;
+ }
+ }
+ } else {
+ if ((acb->rqbuf_lastindex - acb->rqbuf_firstindex) > 1032) {
+ memcpy((void *)ptmpQbuffer, (const void *)pQbuffer, 1032);
+ acb->rqbuf_firstindex += 1032;
+ allxfer_len = 1032;
+ } else {
+ memcpy((void *)ptmpQbuffer, (const void *)pQbuffer,
acb->rqbuf_lastindex - acb->rqbuf_firstindex);
+ allxfer_len = acb->rqbuf_lastindex - acb->rqbuf_firstindex;
+ acb->rqbuf_firstindex = acb->rqbuf_lastindex;
+ }
+ }
  }
  if (acb->acb_flags & ACB_F_IOPDATA_OVERFLOW) {
  struct QBUFFER __iomem *prbuffer;
- uint8_t __iomem *iop_data;
- int32_t iop_len;
-
  acb->acb_flags &= ~ACB_F_IOPDATA_OVERFLOW;
  prbuffer = arcmsr_get_iop_rqbuffer(acb);
- iop_data = prbuffer->data;
- iop_len = readl(&prbuffer->data_len);
- while (iop_len > 0) {
- acb->rqbuffer[acb->rqbuf_lastindex] = readb(iop_data);
- acb->rqbuf_lastindex++;
- acb->rqbuf_lastindex %= ARCMSR_MAX_QBUFFER;
- iop_data++;
- iop_len--;
- }
- arcmsr_iop_message_read(acb);
+ if (arcmsr_Read_iop_rqbuffer_data(acb, prbuffer) == 0)
+ acb->acb_flags |= ACB_F_IOPDATA_OVERFLOW;
  }
- return (allxfer_len);
+ spin_unlock_irqrestore(&acb->rqbuffer_lock, flags);
+ return allxfer_len;
 }

-static ssize_t arcmsr_sysfs_iop_message_write(struct file *filp,
-      struct kobject *kobj,
-      struct bin_attribute *bin,
-      char *buf, loff_t off,
-      size_t count)
+static ssize_t
+arcmsr_sysfs_iop_message_write(struct file *filp,
+      struct kobject *kobj,
+      struct bin_attribute *bin,
+      char *buf, loff_t off,
+      size_t count)
 {
- struct device *dev = container_of(kobj,struct device,kobj);
+ struct device *dev = container_of(kobj, struct device, kobj);
  struct Scsi_Host *host = class_to_shost(dev);
- struct AdapterControlBlock *acb = (struct AdapterControlBlock *)
host->hostdata;
+ struct AdapterControlBlock *acb =
+ (struct AdapterControlBlock *)host->hostdata;
  int32_t my_empty_len, user_len, wqbuf_firstindex, wqbuf_lastindex;
  uint8_t *pQbuffer, *ptmpuserbuffer;
+ unsigned long flags;

  if (!capable(CAP_SYS_ADMIN))
  return -EACCES;
@@ -125,62 +148,69 @@ static ssize_t arcmsr_sysfs_iop_message_
  /* do message unit write. */
  ptmpuserbuffer = (uint8_t *)buf;
  user_len = (int32_t)count;
+ spin_lock_irqsave(&acb->wqbuffer_lock, flags);
  wqbuf_lastindex = acb->wqbuf_lastindex;
  wqbuf_firstindex = acb->wqbuf_firstindex;
  if (wqbuf_lastindex != wqbuf_firstindex) {
- arcmsr_post_ioctldata2iop(acb);
+ arcmsr_write_ioctldata2iop(acb);
+ spin_unlock_irqrestore(&acb->wqbuffer_lock, flags);
  return 0; /*need retry*/
  } else {
  my_empty_len = (wqbuf_firstindex-wqbuf_lastindex - 1)
- &(ARCMSR_MAX_QBUFFER - 1);
+ &(ARCMSR_MAX_QBUFFER - 1);
  if (my_empty_len >= user_len) {
  while (user_len > 0) {
- pQbuffer =
- &acb->wqbuffer[acb->wqbuf_lastindex];
- memcpy(pQbuffer, ptmpuserbuffer, 1);
+ pQbuffer = &acb->wqbuffer[acb->wqbuf_lastindex];
+ memcpy((void *)pQbuffer, (const void *)ptmpuserbuffer, 1);
  acb->wqbuf_lastindex++;
  acb->wqbuf_lastindex %= ARCMSR_MAX_QBUFFER;
  ptmpuserbuffer++;
  user_len--;
  }
- if (acb->acb_flags & ACB_F_MESSAGE_WQBUFFER_CLEARED) {
- acb->acb_flags &=
- ~ACB_F_MESSAGE_WQBUFFER_CLEARED;
- arcmsr_post_ioctldata2iop(acb);
+ if (acb->acb_flags &
+ ACB_F_MESSAGE_WQBUFFER_CLEARED) {
+ acb->acb_flags &= ~ACB_F_MESSAGE_WQBUFFER_CLEARED;
+ arcmsr_write_ioctldata2iop(acb);
  }
+ spin_unlock_irqrestore(&acb->wqbuffer_lock, flags);
  return count;
  } else {
+ spin_unlock_irqrestore(&acb->wqbuffer_lock, flags);
  return 0; /*need retry*/
  }
  }
 }

-static ssize_t arcmsr_sysfs_iop_message_clear(struct file *filp,
-      struct kobject *kobj,
-      struct bin_attribute *bin,
-      char *buf, loff_t off,
-      size_t count)
+static ssize_t
+arcmsr_sysfs_iop_message_clear(struct file *filp,
+      struct kobject *kobj,
+      struct bin_attribute *bin,
+      char *buf, loff_t off,
+      size_t count)
 {
- struct device *dev = container_of(kobj,struct device,kobj);
+ struct device *dev = container_of(kobj, struct device, kobj);
  struct Scsi_Host *host = class_to_shost(dev);
- struct AdapterControlBlock *acb = (struct AdapterControlBlock *)
host->hostdata;
+ struct AdapterControlBlock *acb =
+ (struct AdapterControlBlock *)host->hostdata;
  uint8_t *pQbuffer;
+ unsigned long flags;

  if (!capable(CAP_SYS_ADMIN))
  return -EACCES;

- if (acb->acb_flags & ACB_F_IOPDATA_OVERFLOW) {
- acb->acb_flags &= ~ACB_F_IOPDATA_OVERFLOW;
- arcmsr_iop_message_read(acb);
- }
+ arcmsr_clear_iop2drv_rqueue_buffer(acb);
  acb->acb_flags |=
  (ACB_F_MESSAGE_WQBUFFER_CLEARED
  | ACB_F_MESSAGE_RQBUFFER_CLEARED
  | ACB_F_MESSAGE_WQBUFFER_READED);
+ spin_lock_irqsave(&acb->rqbuffer_lock, flags);
  acb->rqbuf_firstindex = 0;
  acb->rqbuf_lastindex = 0;
+ spin_unlock_irqrestore(&acb->rqbuffer_lock, flags);
+ spin_lock_irqsave(&acb->wqbuffer_lock, flags);
  acb->wqbuf_firstindex = 0;
  acb->wqbuf_lastindex = 0;
+ spin_unlock_irqrestore(&acb->wqbuffer_lock, flags);
  pQbuffer = acb->rqbuffer;
  memset(pQbuffer, 0, sizeof (struct QBUFFER));
  pQbuffer = acb->wqbuffer;
@@ -215,31 +245,37 @@ static struct bin_attribute arcmsr_sysfs
  .write = arcmsr_sysfs_iop_message_clear,
 };

-int arcmsr_alloc_sysfs_attr(struct AdapterControlBlock *acb)
+int
+arcmsr_alloc_sysfs_attr(struct AdapterControlBlock *acb)
 {
  struct Scsi_Host *host = acb->host;
  int error;

- error = sysfs_create_bin_file(&host->shost_dev.kobj,
&arcmsr_sysfs_message_read_attr);
+ error = sysfs_create_bin_file(&host->shost_dev.kobj,
+ &arcmsr_sysfs_message_read_attr);
  if (error) {
- printk(KERN_ERR "arcmsr: alloc sysfs mu_read failed\n");
+ pr_err("arcmsr: alloc sysfs mu_read failed\n");
  goto error_bin_file_message_read;
  }
- error = sysfs_create_bin_file(&host->shost_dev.kobj,
&arcmsr_sysfs_message_write_attr);
+ error = sysfs_create_bin_file(&host->shost_dev.kobj,
+ &arcmsr_sysfs_message_write_attr);
  if (error) {
- printk(KERN_ERR "arcmsr: alloc sysfs mu_write failed\n");
+ pr_err("arcmsr: alloc sysfs mu_write failed\n");
  goto error_bin_file_message_write;
  }
- error = sysfs_create_bin_file(&host->shost_dev.kobj,
&arcmsr_sysfs_message_clear_attr);
+ error = sysfs_create_bin_file(&host->shost_dev.kobj,
+ &arcmsr_sysfs_message_clear_attr);
  if (error) {
- printk(KERN_ERR "arcmsr: alloc sysfs mu_clear failed\n");
+ pr_err("arcmsr: alloc sysfs mu_clear failed\n");
  goto error_bin_file_message_clear;
  }
  return 0;
 error_bin_file_message_clear:
- sysfs_remove_bin_file(&host->shost_dev.kobj,
&arcmsr_sysfs_message_write_attr);
+ sysfs_remove_bin_file(&host->shost_dev.kobj,
+ &arcmsr_sysfs_message_write_attr);
 error_bin_file_message_write:
- sysfs_remove_bin_file(&host->shost_dev.kobj, &arcmsr_sysfs_message_read_attr);
+ sysfs_remove_bin_file(&host->shost_dev.kobj,
+ &arcmsr_sysfs_message_read_attr);
 error_bin_file_message_read:
  return error;
 }
@@ -248,30 +284,30 @@ void arcmsr_free_sysfs_attr(struct Adapt
 {
  struct Scsi_Host *host = acb->host;

- sysfs_remove_bin_file(&host->shost_dev.kobj,
&arcmsr_sysfs_message_clear_attr);
- sysfs_remove_bin_file(&host->shost_dev.kobj,
&arcmsr_sysfs_message_write_attr);
- sysfs_remove_bin_file(&host->shost_dev.kobj, &arcmsr_sysfs_message_read_attr);
+ sysfs_remove_bin_file(&host->shost_dev.kobj,
+ &arcmsr_sysfs_message_clear_attr);
+ sysfs_remove_bin_file(&host->shost_dev.kobj,
+ &arcmsr_sysfs_message_write_attr);
+ sysfs_remove_bin_file(&host->shost_dev.kobj,
+ &arcmsr_sysfs_message_read_attr);
 }

-
 static ssize_t
 arcmsr_attr_host_driver_version(struct device *dev,
- struct device_attribute *attr, char *buf)
+ struct device_attribute *attr, char *buf)
 {
- return snprintf(buf, PAGE_SIZE,
- "%s\n",
+ return snprintf(buf, PAGE_SIZE, "%s\n",
  ARCMSR_DRIVER_VERSION);
 }

 static ssize_t
 arcmsr_attr_host_driver_posted_cmd(struct device *dev,
-   struct device_attribute *attr, char *buf)
+ struct device_attribute *attr, char *buf)
 {
  struct Scsi_Host *host = class_to_shost(dev);
  struct AdapterControlBlock *acb =
- (struct AdapterControlBlock *) host->hostdata;
- return snprintf(buf, PAGE_SIZE,
- "%4d\n",
+ (struct AdapterControlBlock *)host->hostdata;
+ return snprintf(buf, PAGE_SIZE, "%4d\n",
  atomic_read(&acb->ccboutstandingcount));
 }

@@ -281,9 +317,8 @@ arcmsr_attr_host_driver_reset(struct dev
 {
  struct Scsi_Host *host = class_to_shost(dev);
  struct AdapterControlBlock *acb =
- (struct AdapterControlBlock *) host->hostdata;
- return snprintf(buf, PAGE_SIZE,
- "%4d\n",
+ (struct AdapterControlBlock *)host->hostdata;
+ return snprintf(buf, PAGE_SIZE, "%4d\n",
  acb->num_resets);
 }

@@ -293,21 +328,19 @@ arcmsr_attr_host_driver_abort(struct dev
 {
  struct Scsi_Host *host = class_to_shost(dev);
  struct AdapterControlBlock *acb =
- (struct AdapterControlBlock *) host->hostdata;
- return snprintf(buf, PAGE_SIZE,
- "%4d\n",
+ (struct AdapterControlBlock *)host->hostdata;
+ return snprintf(buf, PAGE_SIZE, "%4d\n",
  acb->num_aborts);
 }

 static ssize_t
-arcmsr_attr_host_fw_model(struct device *dev, struct device_attribute *attr,
-  char *buf)
+arcmsr_attr_host_fw_model(struct device *dev,
+ struct device_attribute *attr, char *buf)
 {
  struct Scsi_Host *host = class_to_shost(dev);
  struct AdapterControlBlock *acb =
- (struct AdapterControlBlock *) host->hostdata;
- return snprintf(buf, PAGE_SIZE,
- "%s\n",
+ (struct AdapterControlBlock *)host->hostdata;
+ return snprintf(buf, PAGE_SIZE, "%s\n",
  acb->firm_model);
 }

@@ -317,10 +350,8 @@ arcmsr_attr_host_fw_version(struct devic
 {
  struct Scsi_Host *host = class_to_shost(dev);
  struct AdapterControlBlock *acb =
- (struct AdapterControlBlock *) host->hostdata;
-
- return snprintf(buf, PAGE_SIZE,
- "%s\n",
+ (struct AdapterControlBlock *)host->hostdata;
+ return snprintf(buf, PAGE_SIZE, "%s\n",
  acb->firm_version);
 }

@@ -330,10 +361,9 @@ arcmsr_attr_host_fw_request_len(struct d
 {
  struct Scsi_Host *host = class_to_shost(dev);
  struct AdapterControlBlock *acb =
- (struct AdapterControlBlock *) host->hostdata;
+ (struct AdapterControlBlock *)host->hostdata;

- return snprintf(buf, PAGE_SIZE,
- "%4d\n",
+ return snprintf(buf, PAGE_SIZE, "%4d\n",
  acb->firm_request_len);
 }

@@ -343,10 +373,9 @@ arcmsr_attr_host_fw_numbers_queue(struct
 {
  struct Scsi_Host *host = class_to_shost(dev);
  struct AdapterControlBlock *acb =
- (struct AdapterControlBlock *) host->hostdata;
+ (struct AdapterControlBlock *)host->hostdata;

- return snprintf(buf, PAGE_SIZE,
- "%4d\n",
+ return snprintf(buf, PAGE_SIZE, "%4d\n",
  acb->firm_numbers_queue);
 }

@@ -356,10 +385,9 @@ arcmsr_attr_host_fw_sdram_size(struct de
 {
  struct Scsi_Host *host = class_to_shost(dev);
  struct AdapterControlBlock *acb =
- (struct AdapterControlBlock *) host->hostdata;
+ (struct AdapterControlBlock *)host->hostdata;

- return snprintf(buf, PAGE_SIZE,
- "%4d\n",
+ return snprintf(buf, PAGE_SIZE, "%4d\n",
  acb->firm_sdram_size);
 }

@@ -369,23 +397,32 @@ arcmsr_attr_host_fw_hd_channels(struct d
 {
  struct Scsi_Host *host = class_to_shost(dev);
  struct AdapterControlBlock *acb =
- (struct AdapterControlBlock *) host->hostdata;
+ (struct AdapterControlBlock *)host->hostdata;

- return snprintf(buf, PAGE_SIZE,
- "%4d\n",
+ return snprintf(buf, PAGE_SIZE, "%4d\n",
  acb->firm_hd_channels);
 }

-static DEVICE_ATTR(host_driver_version, S_IRUGO,
arcmsr_attr_host_driver_version, NULL);
-static DEVICE_ATTR(host_driver_posted_cmd, S_IRUGO,
arcmsr_attr_host_driver_posted_cmd, NULL);
-static DEVICE_ATTR(host_driver_reset, S_IRUGO,
arcmsr_attr_host_driver_reset, NULL);
-static DEVICE_ATTR(host_driver_abort, S_IRUGO,
arcmsr_attr_host_driver_abort, NULL);
-static DEVICE_ATTR(host_fw_model, S_IRUGO, arcmsr_attr_host_fw_model, NULL);
-static DEVICE_ATTR(host_fw_version, S_IRUGO,
arcmsr_attr_host_fw_version, NULL);
-static DEVICE_ATTR(host_fw_request_len, S_IRUGO,
arcmsr_attr_host_fw_request_len, NULL);
-static DEVICE_ATTR(host_fw_numbers_queue, S_IRUGO,
arcmsr_attr_host_fw_numbers_queue, NULL);
-static DEVICE_ATTR(host_fw_sdram_size, S_IRUGO,
arcmsr_attr_host_fw_sdram_size, NULL);
-static DEVICE_ATTR(host_fw_hd_channels, S_IRUGO,
arcmsr_attr_host_fw_hd_channels, NULL);
+static DEVICE_ATTR(host_driver_version, S_IRUGO,
+ arcmsr_attr_host_driver_version, NULL);
+static DEVICE_ATTR(host_driver_posted_cmd, S_IRUGO,
+ arcmsr_attr_host_driver_posted_cmd, NULL);
+static DEVICE_ATTR(host_driver_reset, S_IRUGO,
+ arcmsr_attr_host_driver_reset, NULL);
+static DEVICE_ATTR(host_driver_abort, S_IRUGO,
+ arcmsr_attr_host_driver_abort, NULL);
+static DEVICE_ATTR(host_fw_model, S_IRUGO,
+ arcmsr_attr_host_fw_model, NULL);
+static DEVICE_ATTR(host_fw_version, S_IRUGO,
+ arcmsr_attr_host_fw_version, NULL);
+static DEVICE_ATTR(host_fw_request_len, S_IRUGO,
+ arcmsr_attr_host_fw_request_len, NULL);
+static DEVICE_ATTR(host_fw_numbers_queue, S_IRUGO,
+ arcmsr_attr_host_fw_numbers_queue, NULL);
+static DEVICE_ATTR(host_fw_sdram_size, S_IRUGO,
+ arcmsr_attr_host_fw_sdram_size, NULL);
+static DEVICE_ATTR(host_fw_hd_channels, S_IRUGO,
+ arcmsr_attr_host_fw_hd_channels, NULL);

 struct device_attribute *arcmsr_host_attrs[] = {
  &dev_attr_host_driver_version,
diff -uprN a/drivers/scsi/arcmsr/arcmsr.h b/drivers/scsi/arcmsr/arcmsr.h
--- a/drivers/scsi/arcmsr/arcmsr.h 2013-07-01 06:13:28.000000000 +0800
+++ b/drivers/scsi/arcmsr/arcmsr.h 2013-08-29 19:36:18.000000000 +0800
@@ -45,42 +45,48 @@
 #include <linux/interrupt.h>
 struct device_attribute;
 /*The limit of outstanding scsi command that firmware can handle*/
-#define ARCMSR_MAX_OUTSTANDING_CMD 256
+#define ARCMSR_MAX_OUTSTANDING_CMD 256
 #ifdef CONFIG_XEN
  #define ARCMSR_MAX_FREECCB_NUM 160
 #else
  #define ARCMSR_MAX_FREECCB_NUM 320
 #endif
-#define ARCMSR_DRIVER_VERSION     "Driver Version 1.20.00.15 2010/08/05"
-#define ARCMSR_SCSI_INITIATOR_ID 255
-#define ARCMSR_MAX_XFER_SECTORS 512
-#define ARCMSR_MAX_XFER_SECTORS_B 4096
-#define ARCMSR_MAX_XFER_SECTORS_C 304
-#define ARCMSR_MAX_TARGETID 17
-#define ARCMSR_MAX_TARGETLUN 8
-#define ARCMSR_MAX_CMD_PERLUN                 ARCMSR_MAX_OUTSTANDING_CMD
-#define ARCMSR_MAX_QBUFFER 4096
-#define ARCMSR_DEFAULT_SG_ENTRIES 38
-#define ARCMSR_MAX_HBB_POSTQUEUE 264
-#define ARCMSR_MAX_XFER_LEN 0x26000 /* 152K */
-#define ARCMSR_CDB_SG_PAGE_LENGTH 256
+#define ARCMSR_DRIVER_VERSION "v1.30.00.04 2013/08/29"
+#define ARCMSR_SCSI_INITIATOR_ID 255
+#define ARCMSR_MAX_XFER_SECTORS 512
+#define ARCMSR_MAX_XFER_SECTORS_B 4096
+#define ARCMSR_MAX_XFER_SECTORS_C 304
+#define ARCMSR_MAX_TARGETID 17
+#define ARCMSR_MAX_TARGETLUN 8
+#define ARCMSR_MAX_CMD_PERLUN ARCMSR_MAX_OUTSTANDING_CMD
+#define ARCMSR_MAX_QBUFFER 4096
+#define ARCMSR_DEFAULT_SG_ENTRIES 38
+#define ARCMSR_MAX_HBB_POSTQUEUE 264
+#define ARCMSR_MAX_ARC1214_POSTQUEUE 256
+#define ARCMSR_MAX_ARC1214_DONEQUEUE 257
+#define ARCMSR_MAX_XFER_LEN 0x26000
+#define ARCMSR_CDB_SG_PAGE_LENGTH 256
+#define ARCMST_NUM_MSIX_VECTORS 4
 #ifndef PCI_DEVICE_ID_ARECA_1880
-#define PCI_DEVICE_ID_ARECA_1880 0x1880
- #endif
+ #define PCI_DEVICE_ID_ARECA_1880 0x1880
+#endif
+#ifndef PCI_DEVICE_ID_ARECA_1214
+ #define PCI_DEVICE_ID_ARECA_1214 0x1214
+#endif
 /*
 **********************************************************************************
 **
 **********************************************************************************
 */
-#define ARC_SUCCESS                                                       0
-#define ARC_FAILURE                                                       1
+#define ARC_SUCCESS 0
+#define ARC_FAILURE 1
 /*
 *******************************************************************************
 **        split 64bits dma addressing
 *******************************************************************************
 */
-#define dma_addr_hi32(addr)               (uint32_t) ((addr>>16)>>16)
-#define dma_addr_lo32(addr)               (uint32_t) (addr & 0xffffffff)
+#define dma_addr_hi32(addr) (uint32_t)((addr >> 16) >> 16)
+#define dma_addr_lo32(addr) (uint32_t)(addr & 0xffffffff)
 /*
 *******************************************************************************
 **        MESSAGE CONTROL CODE
@@ -88,12 +94,12 @@ struct device_attribute;
 */
 struct CMD_MESSAGE
 {
-      uint32_t HeaderLength;
-      uint8_t  Signature[8];
-      uint32_t Timeout;
-      uint32_t ControlCode;
-      uint32_t ReturnCode;
-      uint32_t Length;
+ uint32_t HeaderLength;
+ uint8_t Signature[8];
+ uint32_t Timeout;
+ uint32_t ControlCode;
+ uint32_t ReturnCode;
+ uint32_t Length;
 };
 /*
 *******************************************************************************
@@ -102,8 +108,8 @@ struct CMD_MESSAGE
 */
 struct CMD_MESSAGE_FIELD
 {
-    struct CMD_MESSAGE cmdmessage;
-    uint8_t messagedatabuffer[1032];
+ struct CMD_MESSAGE cmdmessage;
+ uint8_t messagedatabuffer[1032];
 };
 /* IOP message transfer */
 #define ARCMSR_MESSAGE_FAIL 0x0001
@@ -111,57 +117,57 @@ struct CMD_MESSAGE_FIELD
 #define ARECA_SATA_RAID 0x90000000
 /* FunctionCode */
 #define FUNCTION_READ_RQBUFFER 0x0801
-#define FUNCTION_WRITE_WQBUFFER 0x0802
-#define FUNCTION_CLEAR_RQBUFFER 0x0803
-#define FUNCTION_CLEAR_WQBUFFER 0x0804
+#define FUNCTION_WRITE_WQBUFFER 0x0802
+#define FUNCTION_CLEAR_RQBUFFER 0x0803
+#define FUNCTION_CLEAR_WQBUFFER 0x0804
 #define FUNCTION_CLEAR_ALLQBUFFER 0x0805
-#define FUNCTION_RETURN_CODE_3F 0x0806
+#define FUNCTION_RETURN_CODE_3F 0x0806
 #define FUNCTION_SAY_HELLO 0x0807
 #define FUNCTION_SAY_GOODBYE 0x0808
 #define FUNCTION_FLUSH_ADAPTER_CACHE 0x0809
-#define FUNCTION_GET_FIRMWARE_STATUS 0x080A
-#define FUNCTION_HARDWARE_RESET 0x080B
+#define FUNCTION_GET_FIRMWARE_STATUS 0x080A
+#define FUNCTION_HARDWARE_RESET 0x080B
 /* ARECA IO CONTROL CODE*/
-#define ARCMSR_MESSAGE_READ_RQBUFFER       \
- ARECA_SATA_RAID | FUNCTION_READ_RQBUFFER
-#define ARCMSR_MESSAGE_WRITE_WQBUFFER      \
- ARECA_SATA_RAID | FUNCTION_WRITE_WQBUFFER
-#define ARCMSR_MESSAGE_CLEAR_RQBUFFER      \
- ARECA_SATA_RAID | FUNCTION_CLEAR_RQBUFFER
-#define ARCMSR_MESSAGE_CLEAR_WQBUFFER      \
- ARECA_SATA_RAID | FUNCTION_CLEAR_WQBUFFER
-#define ARCMSR_MESSAGE_CLEAR_ALLQBUFFER    \
- ARECA_SATA_RAID | FUNCTION_CLEAR_ALLQBUFFER
-#define ARCMSR_MESSAGE_RETURN_CODE_3F      \
- ARECA_SATA_RAID | FUNCTION_RETURN_CODE_3F
-#define ARCMSR_MESSAGE_SAY_HELLO           \
- ARECA_SATA_RAID | FUNCTION_SAY_HELLO
-#define ARCMSR_MESSAGE_SAY_GOODBYE         \
- ARECA_SATA_RAID | FUNCTION_SAY_GOODBYE
-#define ARCMSR_MESSAGE_FLUSH_ADAPTER_CACHE \
- ARECA_SATA_RAID | FUNCTION_FLUSH_ADAPTER_CACHE
+#define ARCMSR_MESSAGE_READ_RQBUFFER \
+ (ARECA_SATA_RAID | FUNCTION_READ_RQBUFFER)
+#define ARCMSR_MESSAGE_WRITE_WQBUFFER \
+ (ARECA_SATA_RAID | FUNCTION_WRITE_WQBUFFER)
+#define ARCMSR_MESSAGE_CLEAR_RQBUFFER \
+ (ARECA_SATA_RAID | FUNCTION_CLEAR_RQBUFFER)
+#define ARCMSR_MESSAGE_CLEAR_WQBUFFER \
+ (ARECA_SATA_RAID | FUNCTION_CLEAR_WQBUFFER)
+#define ARCMSR_MESSAGE_CLEAR_ALLQBUFFER \
+ (ARECA_SATA_RAID | FUNCTION_CLEAR_ALLQBUFFER)
+#define ARCMSR_MESSAGE_RETURN_CODE_3F \
+ (ARECA_SATA_RAID | FUNCTION_RETURN_CODE_3F)
+#define ARCMSR_MESSAGE_SAY_HELLO \
+ (ARECA_SATA_RAID | FUNCTION_SAY_HELLO)
+#define ARCMSR_MESSAGE_SAY_GOODBYE \
+ (ARECA_SATA_RAID | FUNCTION_SAY_GOODBYE)
+#define ARCMSR_MESSAGE_FLUSH_ADAPTER_CACHE \
+ (ARECA_SATA_RAID | FUNCTION_FLUSH_ADAPTER_CACHE)
 /* ARECA IOCTL ReturnCode */
-#define ARCMSR_MESSAGE_RETURNCODE_OK 0x00000001
+#define ARCMSR_MESSAGE_RETURNCODE_OK 0x00000001
 #define ARCMSR_MESSAGE_RETURNCODE_ERROR 0x00000006
-#define ARCMSR_MESSAGE_RETURNCODE_3F 0x0000003F
+#define ARCMSR_MESSAGE_RETURNCODE_3F 0x0000003F
 #define ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON 0x00000088
 /*
 *************************************************************
 **   structure for holding DMA address data
 *************************************************************
 */
-#define IS_DMA64 (sizeof(dma_addr_t) == 8)
-#define IS_SG64_ADDR                0x01000000 /* bit24 */
+#define IS_DMA64 (sizeof(dma_addr_t) == 8)
+#define IS_SG64_ADDR 0x01000000 /* bit24 */
 struct  SG32ENTRY
 {
- __le32 length;
- __le32 address;
+ __le32 length;
+ __le32 address;
 }__attribute__ ((packed));
 struct  SG64ENTRY
 {
- __le32 length;
- __le32 address;
- __le32 addresshigh;
+ __le32 length;
+ __le32 address;
+ __le32 addresshigh;
 }__attribute__ ((packed));
 /*
 ********************************************************************
@@ -170,8 +176,8 @@ struct  SG64ENTRY
 */
 struct QBUFFER
 {
- uint32_t      data_len;
- uint8_t       data[124];
+ uint32_t data_len;
+ uint8_t data[124];
 };
 /*
 *******************************************************************************
@@ -180,50 +186,50 @@ struct QBUFFER
 */
 struct FIRMWARE_INFO
 {
- uint32_t      signature; /*0, 00-03*/
- uint32_t      request_len; /*1, 04-07*/
- uint32_t      numbers_queue; /*2, 08-11*/
- uint32_t      sdram_size;               /*3, 12-15*/
- uint32_t      ide_channels; /*4, 16-19*/
- char          vendor[40]; /*5, 20-59*/
- char          model[8]; /*15, 60-67*/
- char          firmware_ver[16];     /*17, 68-83*/
- char          device_map[16]; /*21, 84-99*/
- uint32_t cfgVersion;               /*25,100-103 Added for checking
of new firmware capability*/
- uint8_t cfgSerial[16];           /*26,104-119*/
- uint32_t cfgPicStatus;             /*30,120-123*/
+ uint32_t signature; /*0, 00-03*/
+ uint32_t request_len; /*1, 04-07*/
+ uint32_t numbers_queue; /*2, 08-11*/
+ uint32_t sdram_size; /*3, 12-15*/
+ uint32_t ide_channels; /*4, 16-19*/
+ char vendor[40]; /*5, 20-59*/
+ char model[8]; /*15, 60-67*/
+ char firmware_ver[16]; /*17, 68-83*/
+ char device_map[16]; /*21, 84-99*/
+ uint32_t cfgVersion; /*25, 100-103*/
+ uint8_t cfgSerial[16]; /*26, 104-119*/
+ uint32_t cfgPicStatus; /*30, 120-123*/
 };
 /* signature of set and get firmware config */
-#define ARCMSR_SIGNATURE_GET_CONFIG      0x87974060
-#define ARCMSR_SIGNATURE_SET_CONFIG      0x87974063
+#define ARCMSR_SIGNATURE_GET_CONFIG 0x87974060
+#define ARCMSR_SIGNATURE_SET_CONFIG 0x87974063
 /* message code of inbound message register */
-#define ARCMSR_INBOUND_MESG0_NOP      0x00000000
-#define ARCMSR_INBOUND_MESG0_GET_CONFIG      0x00000001
-#define ARCMSR_INBOUND_MESG0_SET_CONFIG               0x00000002
-#define ARCMSR_INBOUND_MESG0_ABORT_CMD                0x00000003
-#define ARCMSR_INBOUND_MESG0_STOP_BGRB                0x00000004
-#define ARCMSR_INBOUND_MESG0_FLUSH_CACHE              0x00000005
-#define ARCMSR_INBOUND_MESG0_START_BGRB               0x00000006
-#define ARCMSR_INBOUND_MESG0_CHK331PENDING            0x00000007
-#define ARCMSR_INBOUND_MESG0_SYNC_TIMER               0x00000008
+#define ARCMSR_INBOUND_MESG0_NOP 0x00000000
+#define ARCMSR_INBOUND_MESG0_GET_CONFIG 0x00000001
+#define ARCMSR_INBOUND_MESG0_SET_CONFIG 0x00000002
+#define ARCMSR_INBOUND_MESG0_ABORT_CMD 0x00000003
+#define ARCMSR_INBOUND_MESG0_STOP_BGRB 0x00000004
+#define ARCMSR_INBOUND_MESG0_FLUSH_CACHE 0x00000005
+#define ARCMSR_INBOUND_MESG0_START_BGRB 0x00000006
+#define ARCMSR_INBOUND_MESG0_CHK331PENDING 0x00000007
+#define ARCMSR_INBOUND_MESG0_SYNC_TIMER 0x00000008
 /* doorbell interrupt generator */
-#define ARCMSR_INBOUND_DRIVER_DATA_WRITE_OK           0x00000001
-#define ARCMSR_INBOUND_DRIVER_DATA_READ_OK            0x00000002
-#define ARCMSR_OUTBOUND_IOP331_DATA_WRITE_OK          0x00000001
-#define ARCMSR_OUTBOUND_IOP331_DATA_READ_OK           0x00000002
+#define ARCMSR_INBOUND_DRIVER_DATA_WRITE_OK 0x00000001
+#define ARCMSR_INBOUND_DRIVER_DATA_READ_OK 0x00000002
+#define ARCMSR_OUTBOUND_IOP331_DATA_WRITE_OK 0x00000001
+#define ARCMSR_OUTBOUND_IOP331_DATA_READ_OK 0x00000002
 /* ccb areca cdb flag */
-#define ARCMSR_CCBPOST_FLAG_SGL_BSIZE                 0x80000000
-#define ARCMSR_CCBPOST_FLAG_IAM_BIOS                  0x40000000
-#define ARCMSR_CCBREPLY_FLAG_IAM_BIOS                 0x40000000
-#define ARCMSR_CCBREPLY_FLAG_ERROR_MODE0              0x10000000
-#define ARCMSR_CCBREPLY_FLAG_ERROR_MODE1              0x00000001
+#define ARCMSR_CCBPOST_FLAG_SGL_BSIZE 0x80000000
+#define ARCMSR_CCBPOST_FLAG_IAM_BIOS 0x40000000
+#define ARCMSR_CCBREPLY_FLAG_IAM_BIOS 0x40000000
+#define ARCMSR_CCBREPLY_FLAG_ERROR_MODE0 0x10000000
+#define ARCMSR_CCBREPLY_FLAG_ERROR_MODE1 0x00000001
 /* outbound firmware ok */
-#define ARCMSR_OUTBOUND_MESG1_FIRMWARE_OK             0x80000000
+#define ARCMSR_OUTBOUND_MESG1_FIRMWARE_OK 0x80000000
 /* ARC-1680 Bus Reset*/
-#define ARCMSR_ARC1680_BUS_RESET 0x00000003
+#define ARCMSR_ARC1680_BUS_RESET 0x00000003
 /* ARC-1880 Bus Reset*/
-#define ARCMSR_ARC1880_RESET_ADAPTER 0x00000024
-#define ARCMSR_ARC1880_DiagWrite_ENABLE 0x00000080
+#define ARCMSR_ARC1880_RESET_ADAPTER 0x00000024
+#define ARCMSR_ARC1880_DiagWrite_ENABLE 0x00000080

 /*
 ************************************************************************
@@ -232,98 +238,101 @@ struct FIRMWARE_INFO
 */
 /* ARECA HBB COMMAND for its FIRMWARE */
 /* window of "instruction flags" from driver to iop */
-#define ARCMSR_DRV2IOP_DOORBELL                       0x00020400
-#define ARCMSR_DRV2IOP_DOORBELL_MASK                  0x00020404
+#define ARCMSR_DRV2IOP_DOORBELL 0x00020400
+#define ARCMSR_DRV2IOP_DOORBELL_MASK 0x00020404
 /* window of "instruction flags" from iop to driver */
-#define ARCMSR_IOP2DRV_DOORBELL                       0x00020408
-#define ARCMSR_IOP2DRV_DOORBELL_MASK                  0x0002040C
+#define ARCMSR_IOP2DRV_DOORBELL 0x00020408
+#define ARCMSR_IOP2DRV_DOORBELL_MASK 0x0002040C
 /* ARECA FLAG LANGUAGE */
 /* ioctl transfer */
-#define ARCMSR_IOP2DRV_DATA_WRITE_OK                  0x00000001
+#define ARCMSR_IOP2DRV_DATA_WRITE_OK 0x00000001
 /* ioctl transfer */
-#define ARCMSR_IOP2DRV_DATA_READ_OK                   0x00000002
-#define ARCMSR_IOP2DRV_CDB_DONE                       0x00000004
-#define ARCMSR_IOP2DRV_MESSAGE_CMD_DONE               0x00000008
-
-#define ARCMSR_DOORBELL_HANDLE_INT      0x0000000F
-#define ARCMSR_DOORBELL_INT_CLEAR_PATTERN        0xFF00FFF0
-#define ARCMSR_MESSAGE_INT_CLEAR_PATTERN      0xFF00FFF7
+#define ARCMSR_IOP2DRV_DATA_READ_OK 0x00000002
+#define ARCMSR_IOP2DRV_CDB_DONE 0x00000004
+#define ARCMSR_IOP2DRV_MESSAGE_CMD_DONE 0x00000008
+
+#define ARCMSR_DOORBELL_HANDLE_INT 0x0000000F
+#define ARCMSR_DOORBELL_INT_CLEAR_PATTERN 0xFF00FFF0
+#define ARCMSR_MESSAGE_INT_CLEAR_PATTERN 0xFF00FFF7
 /* (ARCMSR_INBOUND_MESG0_GET_CONFIG<<16)|ARCMSR_DRV2IOP_MESSAGE_CMD_POSTED) */
-#define ARCMSR_MESSAGE_GET_CONFIG      0x00010008
+#define ARCMSR_MESSAGE_GET_CONFIG 0x00010008
 /* (ARCMSR_INBOUND_MESG0_SET_CONFIG<<16)|ARCMSR_DRV2IOP_MESSAGE_CMD_POSTED) */
-#define ARCMSR_MESSAGE_SET_CONFIG      0x00020008
+#define ARCMSR_MESSAGE_SET_CONFIG 0x00020008
 /* (ARCMSR_INBOUND_MESG0_ABORT_CMD<<16)|ARCMSR_DRV2IOP_MESSAGE_CMD_POSTED) */
-#define ARCMSR_MESSAGE_ABORT_CMD      0x00030008
+#define ARCMSR_MESSAGE_ABORT_CMD 0x00030008
 /* (ARCMSR_INBOUND_MESG0_STOP_BGRB<<16)|ARCMSR_DRV2IOP_MESSAGE_CMD_POSTED) */
-#define ARCMSR_MESSAGE_STOP_BGRB      0x00040008
+#define ARCMSR_MESSAGE_STOP_BGRB 0x00040008
 /* (ARCMSR_INBOUND_MESG0_FLUSH_CACHE<<16)|ARCMSR_DRV2IOP_MESSAGE_CMD_POSTED) */
-#define ARCMSR_MESSAGE_FLUSH_CACHE                    0x00050008
+#define ARCMSR_MESSAGE_FLUSH_CACHE 0x00050008
 /* (ARCMSR_INBOUND_MESG0_START_BGRB<<16)|ARCMSR_DRV2IOP_MESSAGE_CMD_POSTED) */
-#define ARCMSR_MESSAGE_START_BGRB      0x00060008
-#define ARCMSR_MESSAGE_START_DRIVER_MODE      0x000E0008
-#define ARCMSR_MESSAGE_SET_POST_WINDOW      0x000F0008
-#define ARCMSR_MESSAGE_ACTIVE_EOI_MODE    0x00100008
+#define ARCMSR_MESSAGE_START_BGRB 0x00060008
+#define ARCMSR_MESSAGE_START_DRIVER_MODE 0x000E0008
+#define ARCMSR_MESSAGE_SET_POST_WINDOW 0x000F0008
+#define ARCMSR_MESSAGE_ACTIVE_EOI_MODE 0x00100008
 /* ARCMSR_OUTBOUND_MESG1_FIRMWARE_OK */
-#define ARCMSR_MESSAGE_FIRMWARE_OK      0x80000000
+#define ARCMSR_MESSAGE_FIRMWARE_OK 0x80000000
 /* ioctl transfer */
-#define ARCMSR_DRV2IOP_DATA_WRITE_OK                  0x00000001
+#define ARCMSR_DRV2IOP_DATA_WRITE_OK 0x00000001
 /* ioctl transfer */
-#define ARCMSR_DRV2IOP_DATA_READ_OK                   0x00000002
-#define ARCMSR_DRV2IOP_CDB_POSTED                     0x00000004
-#define ARCMSR_DRV2IOP_MESSAGE_CMD_POSTED             0x00000008
-#define ARCMSR_DRV2IOP_END_OF_INTERRUPT 0x00000010
+#define ARCMSR_DRV2IOP_DATA_READ_OK 0x00000002
+#define ARCMSR_DRV2IOP_CDB_POSTED 0x00000004
+#define ARCMSR_DRV2IOP_MESSAGE_CMD_POSTED 0x00000008
+#define ARCMSR_DRV2IOP_END_OF_INTERRUPT 0x00000010

 /* data tunnel buffer between user space program and its firmware */
 /* user space data to iop 128bytes */
-#define ARCMSR_MESSAGE_WBUFFER      0x0000fe00
+#define ARCMSR_MESSAGE_WBUFFER 0x0000fe00
 /* iop data to user space 128bytes */
-#define ARCMSR_MESSAGE_RBUFFER      0x0000ff00
+#define ARCMSR_MESSAGE_RBUFFER 0x0000ff00
 /* iop message_rwbuffer for message command */
-#define ARCMSR_MESSAGE_RWBUFFER      0x0000fa00
+#define ARCMSR_MESSAGE_RWBUFFER 0x0000fa00
 /*
 ************************************************************************
 **                SPEC. for Areca HBC adapter
 ************************************************************************
 */
-#define ARCMSR_HBC_ISR_THROTTLING_LEVEL 12
-#define ARCMSR_HBC_ISR_MAX_DONE_QUEUE 20
+#define ARCMSR_HBC_ISR_THROTTLING_LEVEL 12
+#define ARCMSR_HBC_ISR_MAX_DONE_QUEUE 20
 /* Host Interrupt Mask */
-#define ARCMSR_HBCMU_UTILITY_A_ISR_MASK 0x00000001 /* When clear, the
Utility_A interrupt routes to the host.*/
-#define ARCMSR_HBCMU_OUTBOUND_DOORBELL_ISR_MASK 0x00000004 /* When
clear, the General Outbound Doorbell interrupt routes to the host.*/
-#define ARCMSR_HBCMU_OUTBOUND_POSTQUEUE_ISR_MASK 0x00000008 /* When
clear, the Outbound Post List FIFO Not Empty interrupt routes to the
host.*/
-#define ARCMSR_HBCMU_ALL_INTMASKENABLE 0x0000000D /* disable all ISR */
+#define ARCMSR_HBCMU_UTILITY_A_ISR_MASK 0x00000001
+#define ARCMSR_HBCMU_OUTBOUND_DOORBELL_ISR_MASK 0x00000004
+#define ARCMSR_HBCMU_OUTBOUND_POSTQUEUE_ISR_MASK 0x00000008
+#define ARCMSR_HBCMU_ALL_INTMASKENABLE 0x0000000D
 /* Host Interrupt Status */
 #define ARCMSR_HBCMU_UTILITY_A_ISR 0x00000001
- /*
- ** Set when the Utility_A Interrupt bit is set in the Outbound
Doorbell Register.
- ** It clears by writing a 1 to the Utility_A bit in the Outbound
Doorbell Clear Register or through automatic clearing (if enabled).
- */
+/*
+** Set when the Utility_A Interrupt bit is set
+** in the Outbound Doorbell Register.
+** It clears by writing a 1 to the Utility_A
+** bit in the Outbound Doorbell Clear Register
+** or through automatic clearing (if enabled).
+*/
 #define ARCMSR_HBCMU_OUTBOUND_DOORBELL_ISR 0x00000004
- /*
- ** Set if Outbound Doorbell register bits 30:1 have a non-zero
- ** value. This bit clears only when Outbound Doorbell bits
- ** 30:1 are ALL clear. Only a write to the Outbound Doorbell
- ** Clear register clears bits in the Outbound Doorbell register.
- */
+/*
+** Set if Outbound Doorbell register bits 30:1 have a non-zero
+** value. This bit clears only when Outbound Doorbell bits
+** 30:1 are ALL clear. Only a write to the Outbound Doorbell
+** Clear register clears bits in the Outbound Doorbell register.
+*/
 #define ARCMSR_HBCMU_OUTBOUND_POSTQUEUE_ISR 0x00000008
- /*
- ** Set whenever the Outbound Post List Producer/Consumer
- ** Register (FIFO) is not empty. It clears when the Outbound
- ** Post List FIFO is empty.
- */
+/*
+** Set whenever the Outbound Post List Producer/Consumer
+** Register (FIFO) is not empty. It clears when the Outbound
+** Post List FIFO is empty.
+*/
 #define ARCMSR_HBCMU_SAS_ALL_INT 0x00000010
- /*
- ** This bit indicates a SAS interrupt from a source external to
- ** the PCIe core. This bit is not maskable.
- */
- /* DoorBell*/
-#define ARCMSR_HBCMU_DRV2IOP_DATA_WRITE_OK 0x00000002
-#define ARCMSR_HBCMU_DRV2IOP_DATA_READ_OK 0x00000004
+/*
+** This bit indicates a SAS interrupt from a source external to
+** the PCIe core. This bit is not maskable.
+*/
+/* DoorBell*/
+#define ARCMSR_HBCMU_DRV2IOP_DATA_WRITE_OK 0x00000002
+#define ARCMSR_HBCMU_DRV2IOP_DATA_READ_OK 0x00000004
  /*inbound message 0 ready*/
-#define ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE 0x00000008
+#define ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE 0x00000008
  /*more than 12 request completed in a time*/
-#define ARCMSR_HBCMU_DRV2IOP_POSTQUEUE_THROTTLING 0x00000010
-#define ARCMSR_HBCMU_IOP2DRV_DATA_WRITE_OK 0x00000002
+#define ARCMSR_HBCMU_DRV2IOP_POSTQUEUE_THROTTLING 0x00000010
+#define ARCMSR_HBCMU_IOP2DRV_DATA_WRITE_OK 0x00000002
  /*outbound DATA WRITE isr door bell clear*/
 #define ARCMSR_HBCMU_IOP2DRV_DATA_WRITE_DOORBELL_CLEAR 0x00000002
 #define ARCMSR_HBCMU_IOP2DRV_DATA_READ_OK 0x00000004
@@ -337,40 +346,89 @@ struct FIRMWARE_INFO
 #define ARCMSR_HBCMU_MESSAGE_FIRMWARE_OK 0x80000000
 /*
 *******************************************************************************
+**                SPEC. for Areca Type D adapter
+*******************************************************************************
+*/
+#define ARCMSR_ARC1214_CHIP_ID 0x00004
+#define ARCMSR_ARC1214_CPU_MEMORY_CONFIGURATION 0x00008
+#define ARCMSR_ARC1214_I2_HOST_INTERRUPT_MASK 0x00034
+#define ARCMSR_ARC1214_SAMPLE_RESET 0x00100
+#define ARCMSR_ARC1214_RESET_REQUEST 0x00108
+#define ARCMSR_ARC1214_MAIN_INTERRUPT_STATUS 0x00200
+#define ARCMSR_ARC1214_PCIE_F0_INTERRUPT_ENABLE 0x0020C
+#define ARCMSR_ARC1214_INBOUND_MESSAGE0 0x00400
+#define ARCMSR_ARC1214_INBOUND_MESSAGE1 0x00404
+#define ARCMSR_ARC1214_OUTBOUND_MESSAGE0 0x00420
+#define ARCMSR_ARC1214_OUTBOUND_MESSAGE1 0x00424
+#define ARCMSR_ARC1214_INBOUND_DOORBELL 0x00460
+#define ARCMSR_ARC1214_OUTBOUND_DOORBELL 0x00480
+#define ARCMSR_ARC1214_OUTBOUND_DOORBELL_ENABLE 0x00484
+#define ARCMSR_ARC1214_INBOUND_LIST_BASE_LOW 0x01000
+#define ARCMSR_ARC1214_INBOUND_LIST_BASE_HIGH 0x01004
+#define ARCMSR_ARC1214_INBOUND_LIST_WRITE_POINTER 0x01018
+#define ARCMSR_ARC1214_OUTBOUND_LIST_BASE_LOW 0x01060
+#define ARCMSR_ARC1214_OUTBOUND_LIST_BASE_HIGH 0x01064
+#define ARCMSR_ARC1214_OUTBOUND_LIST_COPY_POINTER 0x0106C
+#define ARCMSR_ARC1214_OUTBOUND_LIST_READ_POINTER 0x01070
+#define ARCMSR_ARC1214_OUTBOUND_INTERRUPT_CAUSE 0x01088
+#define ARCMSR_ARC1214_OUTBOUND_INTERRUPT_ENABLE 0x0108C
+#define ARCMSR_ARC1214_MESSAGE_WBUFFER 0x02000
+#define ARCMSR_ARC1214_MESSAGE_RBUFFER 0x02100
+#define ARCMSR_ARC1214_MESSAGE_RWBUFFER 0x02200
+/* Host Interrupt Mask */
+#define ARCMSR_ARC1214_ALL_INT_ENABLE 0x00001010
+#define ARCMSR_ARC1214_ALL_INT_DISABLE 0x00000000
+/* Host Interrupt Status */
+#define ARCMSR_ARC1214_OUTBOUND_DOORBELL_ISR 0x00001000
+#define ARCMSR_ARC1214_OUTBOUND_POSTQUEUE_ISR 0x00000010
+/* DoorBell*/
+#define ARCMSR_ARC1214_DRV2IOP_DATA_IN_READY 0x00000001
+#define ARCMSR_ARC1214_DRV2IOP_DATA_OUT_READ 0x00000002
+/*inbound message 0 ready*/
+#define ARCMSR_ARC1214_IOP2DRV_DATA_WRITE_OK 0x00000001
+/*outbound DATA WRITE isr door bell clear*/
+#define ARCMSR_ARC1214_IOP2DRV_DATA_READ_OK 0x00000002
+/*outbound message 0 ready*/
+#define ARCMSR_ARC1214_IOP2DRV_MESSAGE_CMD_DONE 0x02000000
+/*outbound message cmd isr door bell clear*/
+/*ARCMSR_HBAMU_MESSAGE_FIRMWARE_OK*/
+#define ARCMSR_ARC1214_MESSAGE_FIRMWARE_OK 0x80000000
+#define ARCMSR_ARC1214_OUTBOUND_LIST_INTERRUPT_CLEAR 0x00000001
+/*
+*******************************************************************************
 **    ARECA SCSI COMMAND DESCRIPTOR BLOCK size 0x1F8 (504)
 *******************************************************************************
 */
 struct ARCMSR_CDB
 {
- uint8_t Bus;
- uint8_t TargetID;
- uint8_t LUN;
- uint8_t Function;
- uint8_t CdbLength;
- uint8_t sgcount;
- uint8_t Flags;
-#define ARCMSR_CDB_FLAG_SGL_BSIZE          0x01
-#define ARCMSR_CDB_FLAG_BIOS               0x02
-#define ARCMSR_CDB_FLAG_WRITE              0x04
-#define ARCMSR_CDB_FLAG_SIMPLEQ            0x00
-#define ARCMSR_CDB_FLAG_HEADQ              0x08
-#define ARCMSR_CDB_FLAG_ORDEREDQ           0x10
-
- uint8_t msgPages;
- uint32_t Context;
- uint32_t DataLength;
- uint8_t Cdb[16];
- uint8_t DeviceStatus;
-#define ARCMSR_DEV_CHECK_CONDITION    0x02
-#define ARCMSR_DEV_SELECT_TIMEOUT    0xF0
-#define ARCMSR_DEV_ABORTED    0xF1
-#define ARCMSR_DEV_INIT_FAIL    0xF2
-
- uint8_t SenseData[15];
- union
- {
- struct SG32ENTRY                sg32entry[1];
- struct SG64ENTRY                sg64entry[1];
+ uint8_t Bus;
+ uint8_t TargetID;
+ uint8_t LUN;
+ uint8_t Function;
+ uint8_t CdbLength;
+ uint8_t sgcount;
+ uint8_t Flags;
+#define ARCMSR_CDB_FLAG_SGL_BSIZE 0x01
+#define ARCMSR_CDB_FLAG_BIOS 0x02
+#define ARCMSR_CDB_FLAG_WRITE 0x04
+#define ARCMSR_CDB_FLAG_SIMPLEQ 0x00
+#define ARCMSR_CDB_FLAG_HEADQ 0x08
+#define ARCMSR_CDB_FLAG_ORDEREDQ 0x10
+
+ uint8_t msgPages;
+ uint32_t msgContext;
+ uint32_t DataLength;
+ uint8_t Cdb[16];
+ uint8_t DeviceStatus;
+#define ARCMSR_DEV_CHECK_CONDITION 0x02
+#define ARCMSR_DEV_SELECT_TIMEOUT 0xF0
+#define ARCMSR_DEV_ABORTED 0xF1
+#define ARCMSR_DEV_INIT_FAIL 0xF2
+
+ uint8_t SenseData[15];
+ union {
+ struct SG32ENTRY sg32entry[1];
+ struct SG64ENTRY sg64entry[1];
  } u;
 };
 /*
@@ -380,118 +438,162 @@ struct ARCMSR_CDB
 */
 struct MessageUnit_A
 {
- uint32_t resrved0[4]; /*0000 000F*/
- uint32_t inbound_msgaddr0; /*0010 0013*/
- uint32_t inbound_msgaddr1; /*0014 0017*/
- uint32_t outbound_msgaddr0; /*0018 001B*/
- uint32_t outbound_msgaddr1; /*001C 001F*/
- uint32_t inbound_doorbell; /*0020 0023*/
- uint32_t inbound_intstatus; /*0024 0027*/
- uint32_t inbound_intmask; /*0028 002B*/
- uint32_t outbound_doorbell; /*002C 002F*/
- uint32_t outbound_intstatus; /*0030 0033*/
- uint32_t outbound_intmask; /*0034 0037*/
- uint32_t reserved1[2]; /*0038 003F*/
- uint32_t inbound_queueport; /*0040 0043*/
- uint32_t outbound_queueport;     /*0044 0047*/
- uint32_t reserved2[2]; /*0048 004F*/
- uint32_t reserved3[492]; /*0050 07FF 492*/
- uint32_t reserved4[128]; /*0800 09FF 128*/
- uint32_t message_rwbuffer[256]; /*0a00 0DFF 256*/
- uint32_t message_wbuffer[32]; /*0E00 0E7F  32*/
- uint32_t reserved5[32]; /*0E80 0EFF  32*/
- uint32_t message_rbuffer[32]; /*0F00 0F7F  32*/
- uint32_t reserved6[32]; /*0F80 0FFF  32*/
+ uint32_t resrved0[4]; /*0000 000F*/
+ uint32_t inbound_msgaddr0; /*0010 0013*/
+ uint32_t inbound_msgaddr1; /*0014 0017*/
+ uint32_t outbound_msgaddr0; /*0018 001B*/
+ uint32_t outbound_msgaddr1; /*001C 001F*/
+ uint32_t inbound_doorbell; /*0020 0023*/
+ uint32_t inbound_intstatus; /*0024 0027*/
+ uint32_t inbound_intmask; /*0028 002B*/
+ uint32_t outbound_doorbell; /*002C 002F*/
+ uint32_t outbound_intstatus; /*0030 0033*/
+ uint32_t outbound_intmask; /*0034 0037*/
+ uint32_t reserved1[2]; /*0038 003F*/
+ uint32_t inbound_queueport; /*0040 0043*/
+ uint32_t outbound_queueport; /*0044 0047*/
+ uint32_t reserved2[2]; /*0048 004F*/
+ uint32_t reserved3[492]; /*0050 07FF 492*/
+ uint32_t reserved4[128]; /*0800 09FF 128*/
+ uint32_t message_rwbuffer[256]; /*0a00 0DFF 256*/
+ uint32_t message_wbuffer[32]; /*0E00 0E7F  32*/
+ uint32_t reserved5[32]; /*0E80 0EFF  32*/
+ uint32_t message_rbuffer[32]; /*0F00 0F7F  32*/
+ uint32_t reserved6[32]; /*0F80 0FFF  32*/
 };

 struct MessageUnit_B
 {
- uint32_t post_qbuffer[ARCMSR_MAX_HBB_POSTQUEUE];
- uint32_t done_qbuffer[ARCMSR_MAX_HBB_POSTQUEUE];
- uint32_t postq_index;
- uint32_t doneq_index;
- uint32_t __iomem *drv2iop_doorbell;
- uint32_t __iomem *drv2iop_doorbell_mask;
- uint32_t __iomem *iop2drv_doorbell;
- uint32_t __iomem *iop2drv_doorbell_mask;
- uint32_t __iomem *message_rwbuffer;
- uint32_t __iomem *message_wbuffer;
- uint32_t __iomem *message_rbuffer;
+ uint32_t post_qbuffer[ARCMSR_MAX_HBB_POSTQUEUE];
+ uint32_t done_qbuffer[ARCMSR_MAX_HBB_POSTQUEUE];
+ uint32_t postq_index;
+ uint32_t doneq_index;
+ uint32_t __iomem *drv2iop_doorbell;
+ uint32_t __iomem *drv2iop_doorbell_mask;
+ uint32_t __iomem *iop2drv_doorbell;
+ uint32_t __iomem *iop2drv_doorbell_mask;
+ uint32_t __iomem *message_rwbuffer;
+ uint32_t __iomem *message_wbuffer;
+ uint32_t __iomem *message_rbuffer;
 };
 /*
 *********************************************************************
 ** LSI
 *********************************************************************
 */
-struct MessageUnit_C{
- uint32_t message_unit_status; /*0000 0003*/
- uint32_t slave_error_attribute; /*0004 0007*/
- uint32_t slave_error_address; /*0008 000B*/
- uint32_t posted_outbound_doorbell; /*000C 000F*/
- uint32_t master_error_attribute; /*0010 0013*/
- uint32_t master_error_address_low; /*0014 0017*/
- uint32_t master_error_address_high; /*0018 001B*/
- uint32_t hcb_size; /*001C 001F*/
- uint32_t inbound_doorbell; /*0020 0023*/
- uint32_t diagnostic_rw_data; /*0024 0027*/
- uint32_t diagnostic_rw_address_low; /*0028 002B*/
- uint32_t diagnostic_rw_address_high; /*002C 002F*/
- uint32_t host_int_status; /*0030 0033*/
- uint32_t host_int_mask; /*0034 0037*/
- uint32_t dcr_data; /*0038 003B*/
- uint32_t dcr_address; /*003C 003F*/
- uint32_t inbound_queueport; /*0040 0043*/
- uint32_t outbound_queueport; /*0044 0047*/
- uint32_t hcb_pci_address_low; /*0048 004B*/
- uint32_t hcb_pci_address_high; /*004C 004F*/
- uint32_t iop_int_status; /*0050 0053*/
- uint32_t iop_int_mask; /*0054 0057*/
- uint32_t iop_inbound_queue_port; /*0058 005B*/
- uint32_t iop_outbound_queue_port; /*005C 005F*/
- uint32_t inbound_free_list_index; /*0060 0063*/
- uint32_t inbound_post_list_index; /*0064 0067*/
- uint32_t outbound_free_list_index; /*0068 006B*/
- uint32_t outbound_post_list_index; /*006C 006F*/
- uint32_t inbound_doorbell_clear; /*0070 0073*/
- uint32_t i2o_message_unit_control; /*0074 0077*/
- uint32_t last_used_message_source_address_low; /*0078 007B*/
- uint32_t last_used_message_source_address_high; /*007C 007F*/
- uint32_t pull_mode_data_byte_count[4]; /*0080 008F*/
- uint32_t message_dest_address_index; /*0090 0093*/
- uint32_t done_queue_not_empty_int_counter_timer; /*0094 0097*/
- uint32_t utility_A_int_counter_timer; /*0098 009B*/
- uint32_t outbound_doorbell; /*009C 009F*/
- uint32_t outbound_doorbell_clear; /*00A0 00A3*/
- uint32_t message_source_address_index; /*00A4 00A7*/
- uint32_t message_done_queue_index; /*00A8 00AB*/
- uint32_t reserved0; /*00AC 00AF*/
- uint32_t inbound_msgaddr0; /*00B0 00B3*/
- uint32_t inbound_msgaddr1; /*00B4 00B7*/
- uint32_t outbound_msgaddr0; /*00B8 00BB*/
- uint32_t outbound_msgaddr1; /*00BC 00BF*/
- uint32_t inbound_queueport_low; /*00C0 00C3*/
- uint32_t inbound_queueport_high; /*00C4 00C7*/
- uint32_t outbound_queueport_low; /*00C8 00CB*/
- uint32_t outbound_queueport_high; /*00CC 00CF*/
- uint32_t iop_inbound_queue_port_low; /*00D0 00D3*/
- uint32_t iop_inbound_queue_port_high; /*00D4 00D7*/
- uint32_t iop_outbound_queue_port_low; /*00D8 00DB*/
- uint32_t iop_outbound_queue_port_high; /*00DC 00DF*/
- uint32_t message_dest_queue_port_low; /*00E0 00E3*/
- uint32_t message_dest_queue_port_high; /*00E4 00E7*/
- uint32_t last_used_message_dest_address_low; /*00E8 00EB*/
- uint32_t last_used_message_dest_address_high; /*00EC 00EF*/
- uint32_t message_done_queue_base_address_low; /*00F0 00F3*/
- uint32_t message_done_queue_base_address_high; /*00F4 00F7*/
- uint32_t host_diagnostic; /*00F8 00FB*/
- uint32_t write_sequence; /*00FC 00FF*/
- uint32_t reserved1[34]; /*0100 0187*/
- uint32_t reserved2[1950]; /*0188 1FFF*/
- uint32_t message_wbuffer[32]; /*2000 207F*/
- uint32_t reserved3[32]; /*2080 20FF*/
- uint32_t message_rbuffer[32]; /*2100 217F*/
- uint32_t reserved4[32]; /*2180 21FF*/
- uint32_t msgcode_rwbuffer[256]; /*2200 23FF*/
+struct MessageUnit_C {
+ uint32_t message_unit_status; /*0000 0003*/
+ uint32_t slave_error_attribute; /*0004 0007*/
+ uint32_t slave_error_address; /*0008 000B*/
+ uint32_t posted_outbound_doorbell; /*000C 000F*/
+ uint32_t master_error_attribute; /*0010 0013*/
+ uint32_t master_error_address_low; /*0014 0017*/
+ uint32_t master_error_address_high; /*0018 001B*/
+ uint32_t hcb_size; /*001C 001F*/
+ uint32_t inbound_doorbell; /*0020 0023*/
+ uint32_t diagnostic_rw_data; /*0024 0027*/
+ uint32_t diagnostic_rw_address_low; /*0028 002B*/
+ uint32_t diagnostic_rw_address_high; /*002C 002F*/
+ uint32_t host_int_status; /*0030 0033*/
+ uint32_t host_int_mask; /*0034 0037*/
+ uint32_t dcr_data; /*0038 003B*/
+ uint32_t dcr_address; /*003C 003F*/
+ uint32_t inbound_queueport; /*0040 0043*/
+ uint32_t outbound_queueport; /*0044 0047*/
+ uint32_t hcb_pci_address_low; /*0048 004B*/
+ uint32_t hcb_pci_address_high; /*004C 004F*/
+ uint32_t iop_int_status; /*0050 0053*/
+ uint32_t iop_int_mask; /*0054 0057*/
+ uint32_t iop_inbound_queue_port; /*0058 005B*/
+ uint32_t iop_outbound_queue_port; /*005C 005F*/
+ uint32_t inbound_free_list_index; /*0060 0063*/
+ uint32_t inbound_post_list_index; /*0064 0067*/
+ uint32_t outbound_free_list_index; /*0068 006B*/
+ uint32_t outbound_post_list_index; /*006C 006F*/
+ uint32_t inbound_doorbell_clear; /*0070 0073*/
+ uint32_t i2o_message_unit_control; /*0074 0077*/
+ uint32_t last_used_message_source_address_low; /*0078 007B*/
+ uint32_t last_used_message_source_address_high; /*007C 007F*/
+ uint32_t pull_mode_data_byte_count[4]; /*0080 008F*/
+ uint32_t message_dest_address_index; /*0090 0093*/
+ uint32_t done_queue_not_empty_int_counter_timer; /*0094 0097*/
+ uint32_t utility_A_int_counter_timer; /*0098 009B*/
+ uint32_t outbound_doorbell; /*009C 009F*/
+ uint32_t outbound_doorbell_clear; /*00A0 00A3*/
+ uint32_t message_source_address_index; /*00A4 00A7*/
+ uint32_t message_done_queue_index; /*00A8 00AB*/
+ uint32_t reserved0; /*00AC 00AF*/
+ uint32_t inbound_msgaddr0; /*00B0 00B3*/
+ uint32_t inbound_msgaddr1; /*00B4 00B7*/
+ uint32_t outbound_msgaddr0; /*00B8 00BB*/
+ uint32_t outbound_msgaddr1; /*00BC 00BF*/
+ uint32_t inbound_queueport_low; /*00C0 00C3*/
+ uint32_t inbound_queueport_high; /*00C4 00C7*/
+ uint32_t outbound_queueport_low; /*00C8 00CB*/
+ uint32_t outbound_queueport_high; /*00CC 00CF*/
+ uint32_t iop_inbound_queue_port_low; /*00D0 00D3*/
+ uint32_t iop_inbound_queue_port_high; /*00D4 00D7*/
+ uint32_t iop_outbound_queue_port_low; /*00D8 00DB*/
+ uint32_t iop_outbound_queue_port_high; /*00DC 00DF*/
+ uint32_t message_dest_queue_port_low; /*00E0 00E3*/
+ uint32_t message_dest_queue_port_high; /*00E4 00E7*/
+ uint32_t last_used_message_dest_address_low; /*00E8 00EB*/
+ uint32_t last_used_message_dest_address_high; /*00EC 00EF*/
+ uint32_t message_done_queue_base_address_low; /*00F0 00F3*/
+ uint32_t message_done_queue_base_address_high; /*00F4 00F7*/
+ uint32_t host_diagnostic; /*00F8 00FB*/
+ uint32_t write_sequence; /*00FC 00FF*/
+ uint32_t reserved1[34]; /*0100 0187*/
+ uint32_t reserved2[1950]; /*0188 1FFF*/
+ uint32_t message_wbuffer[32]; /*2000 207F*/
+ uint32_t reserved3[32]; /*2080 20FF*/
+ uint32_t message_rbuffer[32]; /*2100 217F*/
+ uint32_t reserved4[32]; /*2180 21FF*/
+ uint32_t msgcode_rwbuffer[256]; /*2200 23FF*/
+};
+struct InBound_SRB {
+ uint32_t addressLow;/*pointer to SRB block*/
+ uint32_t addressHigh;
+ uint32_t length;/*in DWORDs*/
+ uint32_t reserved0;
+};
+
+struct OutBound_SRB {
+ uint32_t addressLow;/*pointer to SRB block*/
+ uint32_t addressHigh;
+};
+
+struct MessageUnit_D {
+ struct InBound_SRB post_qbuffer[ARCMSR_MAX_ARC1214_POSTQUEUE];
+ struct OutBound_SRB done_qbuffer[ARCMSR_MAX_ARC1214_DONEQUEUE];
+ u16 postq_index;
+ u16 doneq_index;
+ u32 __iomem *chip_id; /*0x00004*/
+ u32 __iomem *cpu_mem_config; /*0x00008*/
+ u32 __iomem *i2o_host_interrupt_mask; /*0x00034*/
+ u32 __iomem *sample_at_reset; /*0x00100*/
+ u32 __iomem *reset_request; /*0x00108*/
+ u32 __iomem *host_int_status; /*0x00200*/
+ u32 __iomem *pcief0_int_enable; /*0x0020C*/
+ u32 __iomem *inbound_msgaddr0; /*0x00400*/
+ u32 __iomem *inbound_msgaddr1; /*0x00404*/
+ u32 __iomem *outbound_msgaddr0; /*0x00420*/
+ u32 __iomem *outbound_msgaddr1; /*0x00424*/
+ u32 __iomem *inbound_doorbell; /*0x00460*/
+ u32 __iomem *outbound_doorbell; /*0x00480*/
+ u32 __iomem *outbound_doorbell_enable; /*0x00484*/
+ u32 __iomem *inboundlist_base_low; /*0x01000*/
+ u32 __iomem *inboundlist_base_high; /*0x01004*/
+ u32 __iomem *inboundlist_write_pointer; /*0x01018*/
+ u32 __iomem *outboundlist_base_low; /*0x01060*/
+ u32 __iomem *outboundlist_base_high; /*0x01064*/
+ u32 __iomem *outboundlist_copy_pointer; /*0x0106C*/
+ u32 __iomem *outboundlist_read_pointer; /*0x01070 0x01072*/
+ u32 __iomem *outboundlist_interrupt_cause; /*0x1088*/
+ u32 __iomem *outboundlist_interrupt_enable; /*0x108C*/
+ u32 __iomem *message_wbuffer; /*0x2000*/
+ u32 __iomem *message_rbuffer; /*0x2100*/
+ u32 __iomem *msgcode_rwbuffer; /*0x2200*/
 };
 /*
 *******************************************************************************
@@ -500,100 +602,110 @@ struct MessageUnit_C{
 */
 struct AdapterControlBlock
 {
- uint32_t  adapter_type;                /* adapter A,B..... */
- #define ACB_ADAPTER_TYPE_A            0x00000001 /* hba I IOP */
- #define ACB_ADAPTER_TYPE_B            0x00000002 /* hbb M IOP */
- #define ACB_ADAPTER_TYPE_C            0x00000004 /* hbc P IOP */
- #define ACB_ADAPTER_TYPE_D            0x00000008 /* hbd A IOP */
- struct pci_dev * pdev;
- struct Scsi_Host * host;
- unsigned long vir2phy_offset;
+ uint32_t adapter_type; /* adapter A,B..... */
+ #define ACB_ADAPTER_TYPE_A 0x00000001 /* hba I IOP */
+ #define ACB_ADAPTER_TYPE_B 0x00000002 /* hbb M IOP */
+ #define ACB_ADAPTER_TYPE_C 0x00000004 /* hbc P IOP */
+ #define ACB_ADAPTER_TYPE_D 0x00000008 /* hbd A IOP */
+ u32 roundup_ccbsize;
+ struct pci_dev *pdev;
+ struct Scsi_Host *host;
+ unsigned long vir2phy_offset;
+ struct msix_entry entries[ARCMST_NUM_MSIX_VECTORS];
  /* Offset is used in making arc cdb physical to virtual calculations */
- uint32_t outbound_int_enable;
- uint32_t cdb_phyaddr_hi32;
- uint32_t reg_mu_acc_handle0;
- spinlock_t                       eh_lock;
- spinlock_t                       ccblist_lock;
+ uint32_t outbound_int_enable;
+ uint32_t cdb_phyaddr_hi32;
+ spinlock_t eh_lock;
+ spinlock_t ccblist_lock;
+ spinlock_t postq_lock;
+ spinlock_t doneq_lock;
+ spinlock_t rqbuffer_lock;
+ spinlock_t wqbuffer_lock;
  union {
  struct MessageUnit_A __iomem *pmuA;
- struct MessageUnit_B *pmuB;
+ struct MessageUnit_B __iomem *pmuB;
  struct MessageUnit_C __iomem *pmuC;
+ struct MessageUnit_D __iomem *pmuD;
  };
  /* message unit ATU inbound base address0 */
  void __iomem *mem_base0;
  void __iomem *mem_base1;
- uint32_t acb_flags;
- u16 dev_id;
- uint8_t                   adapter_index;
- #define ACB_F_SCSISTOPADAPTER         0x0001
- #define ACB_F_MSG_STOP_BGRB     0x0002
+ uint32_t acb_flags;
+ u16 dev_id;
+ uint8_t adapter_index;
+ #define ACB_F_SCSISTOPADAPTER 0x0001
+ #define ACB_F_MSG_STOP_BGRB 0x0002
  /* stop RAID background rebuild */
- #define ACB_F_MSG_START_BGRB           0x0004
+ #define ACB_F_MSG_START_BGRB 0x0004
  /* stop RAID background rebuild */
- #define ACB_F_IOPDATA_OVERFLOW         0x0008
+ #define ACB_F_IOPDATA_OVERFLOW 0x0008
  /* iop message data rqbuffer overflow */
  #define ACB_F_MESSAGE_WQBUFFER_CLEARED 0x0010
  /* message clear wqbuffer */
- #define ACB_F_MESSAGE_RQBUFFER_CLEARED  0x0020
+ #define ACB_F_MESSAGE_RQBUFFER_CLEARED 0x0020
  /* message clear rqbuffer */
- #define ACB_F_MESSAGE_WQBUFFER_READED   0x0040
- #define ACB_F_BUS_RESET               0x0080
- #define ACB_F_BUS_HANG_ON 0x0800/* need hardware reset bus */
+ #define ACB_F_MESSAGE_WQBUFFER_READED 0x0040
+ #define ACB_F_BUS_RESET 0x0080
+ #define ACB_F_BUS_HANG_ON 0x0800

- #define ACB_F_IOP_INITED               0x0100
+ #define ACB_F_IOP_INITED 0x0100
  /* iop init */
  #define ACB_F_ABORT 0x0200
- #define ACB_F_FIRMWARE_TRAP           0x0400
- struct CommandControlBlock * pccb_pool[ARCMSR_MAX_FREECCB_NUM];
+ #define ACB_F_FIRMWARE_TRAP 0x0400
+ #define ACB_F_MSI_ENABLED 0x1000
+ #define ACB_F_MSIX_ENABLED 0x2000
+ struct CommandControlBlock *pccb_pool[ARCMSR_MAX_FREECCB_NUM];
  /* used for memory free */
- struct list_head ccb_free_list;
+ struct list_head ccb_free_list;
  /* head of free ccb list */

- atomic_t ccboutstandingcount;
+ atomic_t ccboutstandingcount;
  /*The present outstanding command number that in the IOP that
  waiting for being handled by FW*/

- void * dma_coherent;
+ void *dma_coherent;
  /* dma_coherent used for memory free */
- dma_addr_t dma_coherent_handle;
+ dma_addr_t dma_coherent_handle;
  /* dma_coherent_handle used for memory free */
- dma_addr_t dma_coherent_handle_hbb_mu;
- unsigned int uncache_size;
- uint8_t rqbuffer[ARCMSR_MAX_QBUFFER];
+ dma_addr_t dma_coherent_handle2;
+ void *dma_coherent2;
+ unsigned int uncache_size;
+ uint8_t rqbuffer[ARCMSR_MAX_QBUFFER];
  /* data collection buffer for read from 80331 */
- int32_t rqbuf_firstindex;
+ uint32_t rqbuf_firstindex;
  /* first of read buffer  */
- int32_t rqbuf_lastindex;
+ uint32_t rqbuf_lastindex;
  /* last of read buffer   */
- uint8_t wqbuffer[ARCMSR_MAX_QBUFFER];
+ uint8_t wqbuffer[ARCMSR_MAX_QBUFFER];
  /* data collection buffer for write to 80331  */
- int32_t wqbuf_firstindex;
+ uint32_t wqbuf_firstindex;
  /* first of write buffer */
- int32_t wqbuf_lastindex;
+ uint32_t wqbuf_lastindex;
  /* last of write buffer  */
- uint8_t devstate[ARCMSR_MAX_TARGETID][ARCMSR_MAX_TARGETLUN];
+ uint8_t devstate[ARCMSR_MAX_TARGETID][ARCMSR_MAX_TARGETLUN];
  /* id0 ..... id15, lun0...lun7 */
-#define ARECA_RAID_GONE               0x55
-#define ARECA_RAID_GOOD               0xaa
- uint32_t num_resets;
- uint32_t num_aborts;
- uint32_t signature;
- uint32_t firm_request_len;
- uint32_t firm_numbers_queue;
- uint32_t firm_sdram_size;
- uint32_t firm_hd_channels;
- uint32_t                           firm_cfg_version;
- char firm_model[12];
- char firm_version[20];
- char device_map[20]; /*21,84-99*/
- struct work_struct arcmsr_do_message_isr_bh;
- struct timer_list eternal_timer;
- unsigned short fw_flag;
- #define FW_NORMAL 0x0000
- #define FW_BOG 0x0001
- #define FW_DEADLOCK 0x0010
- atomic_t rq_map_token;
- atomic_t ante_token_value;
+#define ARECA_RAID_GONE 0x55
+#define ARECA_RAID_GOOD 0xaa
+ uint32_t num_resets;
+ uint32_t num_aborts;
+ uint32_t signature;
+ uint32_t firm_request_len;
+ uint32_t firm_numbers_queue;
+ uint32_t firm_sdram_size;
+ uint32_t firm_hd_channels;
+ uint32_t firm_cfg_version;
+ char firm_model[12];
+ char firm_version[20];
+ char device_map[20]; /*21,84-99*/
+ struct work_struct arcmsr_do_message_isr_bh;
+ struct timer_list eternal_timer;
+ unsigned short fw_flag;
+ #define FW_NORMAL 0x0000
+ #define FW_BOG 0x0001
+ #define FW_DEADLOCK 0x0010
+ atomic_t rq_map_token;
+ atomic_t ante_token_value;
+ uint32_t maxOutstanding;
 };/* HW_DEVICE_EXTENSION */
 /*
 *******************************************************************************
@@ -601,33 +713,33 @@ struct AdapterControlBlock
 **             this CCB length must be 32 bytes boundary
 *******************************************************************************
 */
-struct CommandControlBlock{
- /*x32:sizeof struct_CCB=(32+60)byte, x64:sizeof struct_CCB=(64+60)byte*/
- struct list_head list; /*x32: 8byte, x64: 16byte*/
- struct scsi_cmnd *pcmd; /*8 bytes pointer of linux scsi command */
- struct AdapterControlBlock *acb; /*x32: 4byte, x64: 8byte*/
- uint32_t cdb_phyaddr_pattern; /*x32: 4byte, x64: 4byte*/
- uint32_t arc_cdb_size; /*x32:4byte,x64:4byte*/
- uint16_t ccb_flags; /*x32: 2byte, x64: 2byte*/
- #define CCB_FLAG_READ 0x0000
- #define CCB_FLAG_WRITE 0x0001
- #define CCB_FLAG_ERROR 0x0002
- #define CCB_FLAG_FLUSHCACHE 0x0004
- #define CCB_FLAG_MASTER_ABORTED 0x0008
- uint16_t                         startdone; /*x32:2byte,x32:2byte*/
- #define ARCMSR_CCB_DONE           0x0000
- #define ARCMSR_CCB_START 0x55AA
- #define ARCMSR_CCB_ABORTED 0xAA55
- #define ARCMSR_CCB_ILLEGAL 0xFFFF
+struct CommandControlBlock {
+/*x32:sizeof struct_CCB=(32+60)byte, x64:sizeof struct_CCB=(64+60)byte*/
+ struct list_head list;
+ struct scsi_cmnd *pcmd;
+ struct AdapterControlBlock *acb;
+ uint32_t cdb_phyaddr;
+ uint32_t arc_cdb_size;
+ uint16_t ccb_flags;
+ #define CCB_FLAG_READ 0x0000
+ #define CCB_FLAG_WRITE 0x0001
+ #define CCB_FLAG_ERROR 0x0002
+ #define CCB_FLAG_FLUSHCACHE 0x0004
+ #define CCB_FLAG_MASTER_ABORTED 0x0008
+ uint16_t startdone;
+ #define ARCMSR_CCB_DONE 0x0000
+ #define ARCMSR_CCB_START 0x55AA
+ #define ARCMSR_CCB_ABORTED 0xAA55
+ #define ARCMSR_CCB_ILLEGAL 0xFFFF
  #if BITS_PER_LONG == 64
  /*  ======================512+64 bytes========================  */
- uint32_t                         reserved[5]; /*24 byte*/
+ uint32_t reserved[5]; /*24 byte*/
  #else
- /*  ======================512+32 bytes========================  */
- uint32_t                         reserved; /*8  byte*/
+ /*======================512+32 bytes========================*/
+ uint32_t reserved; /*8  byte*/
  #endif
- /*  =======================================================   */
- struct ARCMSR_CDB arcmsr_cdb;
+ /*=======================================================*/
+ struct ARCMSR_CDB arcmsr_cdb;
 };
 /*
 *******************************************************************************
@@ -636,56 +748,58 @@ struct CommandControlBlock{
 */
 struct SENSE_DATA
 {
- uint8_t ErrorCode:7;
+ uint8_t ErrorCode:7;
 #define SCSI_SENSE_CURRENT_ERRORS 0x70
 #define SCSI_SENSE_DEFERRED_ERRORS 0x71
- uint8_t Valid:1;
- uint8_t SegmentNumber;
- uint8_t SenseKey:4;
- uint8_t Reserved:1;
- uint8_t IncorrectLength:1;
- uint8_t EndOfMedia:1;
- uint8_t FileMark:1;
- uint8_t Information[4];
- uint8_t AdditionalSenseLength;
- uint8_t CommandSpecificInformation[4];
- uint8_t AdditionalSenseCode;
- uint8_t AdditionalSenseCodeQualifier;
- uint8_t FieldReplaceableUnitCode;
- uint8_t SenseKeySpecific[3];
+ uint8_t Valid:1;
+ uint8_t SegmentNumber;
+ uint8_t SenseKey:4;
+ uint8_t Reserved:1;
+ uint8_t IncorrectLength:1;
+ uint8_t EndOfMedia:1;
+ uint8_t FileMark:1;
+ uint8_t Information[4];
+ uint8_t AdditionalSenseLength;
+ uint8_t CommandSpecificInformation[4];
+ uint8_t AdditionalSenseCode;
+ uint8_t AdditionalSenseCodeQualifier;
+ uint8_t FieldReplaceableUnitCode;
+ uint8_t SenseKeySpecific[3];
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
+#define ARCMSR_MU_OUTBOUND_INTERRUPT_STATUS_REG 0x30
+#define ARCMSR_MU_OUTBOUND_PCI_INT 0x10
+#define ARCMSR_MU_OUTBOUND_POSTQUEUE_INT 0x08
+#define ARCMSR_MU_OUTBOUND_DOORBELL_INT 0x04
+#define ARCMSR_MU_OUTBOUND_MESSAGE1_INT 0x02
+#define ARCMSR_MU_OUTBOUND_MESSAGE0_INT 0x01
+#define ARCMSR_MU_OUTBOUND_HANDLE_INT \
+ (ARCMSR_MU_OUTBOUND_MESSAGE0_INT \
+ |ARCMSR_MU_OUTBOUND_MESSAGE1_INT \
+ |ARCMSR_MU_OUTBOUND_DOORBELL_INT \
+ |ARCMSR_MU_OUTBOUND_POSTQUEUE_INT \
+ |ARCMSR_MU_OUTBOUND_PCI_INT)
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
+#define ARCMSR_MU_OUTBOUND_INTERRUPT_MASK_REG 0x34
+#define ARCMSR_MU_OUTBOUND_PCI_INTMASKENABLE 0x10
+#define ARCMSR_MU_OUTBOUND_POSTQUEUE_INTMASKENABLE 0x08
+#define ARCMSR_MU_OUTBOUND_DOORBELL_INTMASKENABLE 0x04
+#define ARCMSR_MU_OUTBOUND_MESSAGE1_INTMASKENABLE 0x02
+#define ARCMSR_MU_OUTBOUND_MESSAGE0_INTMASKENABLE 0x01
+#define ARCMSR_MU_OUTBOUND_ALL_INTMASKENABLE 0x1F

-extern void arcmsr_post_ioctldata2iop(struct AdapterControlBlock *);
-extern void arcmsr_iop_message_read(struct AdapterControlBlock *);
+extern void arcmsr_write_ioctldata2iop(struct AdapterControlBlock *);
+extern uint32_t arcmsr_Read_iop_rqbuffer_data(struct AdapterControlBlock *,
+ struct QBUFFER __iomem *);
+extern void arcmsr_clear_iop2drv_rqueue_buffer(struct AdapterControlBlock *);
 extern struct QBUFFER __iomem *arcmsr_get_iop_rqbuffer(struct
AdapterControlBlock *);
 extern struct device_attribute *arcmsr_host_attrs[];
 extern int arcmsr_alloc_sysfs_attr(struct AdapterControlBlock *);
diff -uprN a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
--- a/drivers/scsi/arcmsr/arcmsr_hba.c 2013-07-01 06:13:28.000000000 +0800
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c 2013-08-29 20:31:46.000000000 +0800
@@ -2,7 +2,7 @@
 *******************************************************************************
 **        O.S   : Linux
 **   FILE NAME  : arcmsr_hba.c
-**        BY    : Nick Cheng
+**        BY    : Nick Cheng, C.L. Huang
 **   Description: SCSI RAID Device Driver for
 **                ARECA RAID Host adapter
 *******************************************************************************
@@ -70,15 +70,15 @@
 #include <scsi/scsi_transport.h>
 #include <scsi/scsicam.h>
 #include "arcmsr.h"
-MODULE_AUTHOR("Nick Cheng <support@areca.com.tw>");
-MODULE_DESCRIPTION("ARECA (ARC11xx/12xx/16xx/1880) SATA/SAS RAID Host
Bus Adapter");
+MODULE_AUTHOR("Nick Cheng, Ching Huang <support@areca.com.tw>");
+MODULE_DESCRIPTION("Areca SAS,SATA RAID Controller Driver");
 MODULE_LICENSE("Dual BSD/GPL");
 MODULE_VERSION(ARCMSR_DRIVER_VERSION);

-#define ARCMSR_SLEEPTIME 10
-#define ARCMSR_RETRYCOUNT 12
+#define ARCMSR_SLEEPTIME 10
+#define ARCMSR_RETRYCOUNT 12

-wait_queue_head_t wait_q;
+static wait_queue_head_t wait_q;
 static int arcmsr_iop_message_xfer(struct AdapterControlBlock *acb,
  struct scsi_cmnd *cmd);
 static int arcmsr_iop_confirm(struct AdapterControlBlock *acb);
@@ -89,22 +89,27 @@ static int arcmsr_bios_param(struct scsi
 static int arcmsr_queue_command(struct Scsi_Host *h, struct scsi_cmnd *cmd);
 static int arcmsr_probe(struct pci_dev *pdev,
  const struct pci_device_id *id);
+static int arcmsr_suspend(struct pci_dev *pdev, pm_message_t state);
+static int arcmsr_resume(struct pci_dev *pdev);
 static void arcmsr_remove(struct pci_dev *pdev);
 static void arcmsr_shutdown(struct pci_dev *pdev);
 static void arcmsr_iop_init(struct AdapterControlBlock *acb);
 static void arcmsr_free_ccb_pool(struct AdapterControlBlock *acb);
 static u32 arcmsr_disable_outbound_ints(struct AdapterControlBlock *acb);
+static void arcmsr_enable_outbound_ints(struct AdapterControlBlock *acb,
+ u32 orig_mask);
 static void arcmsr_stop_adapter_bgrb(struct AdapterControlBlock *acb);
-static void arcmsr_flush_hba_cache(struct AdapterControlBlock *acb);
-static void arcmsr_flush_hbb_cache(struct AdapterControlBlock *acb);
+static void arcmsr_hbaA_flush_cache(struct AdapterControlBlock *acb);
+static void arcmsr_hbaB_flush_cache(struct AdapterControlBlock *acb);
 static void arcmsr_request_device_map(unsigned long pacb);
-static void arcmsr_request_hba_device_map(struct AdapterControlBlock *acb);
-static void arcmsr_request_hbb_device_map(struct AdapterControlBlock *acb);
-static void arcmsr_request_hbc_device_map(struct AdapterControlBlock *acb);
+static void arcmsr_hbaA_request_device_map(struct AdapterControlBlock *acb);
+static void arcmsr_hbaB_request_device_map(struct AdapterControlBlock *acb);
+static void arcmsr_hbaC_request_device_map(struct AdapterControlBlock *acb);
 static void arcmsr_message_isr_bh_fn(struct work_struct *work);
 static bool arcmsr_get_firmware_spec(struct AdapterControlBlock *acb);
 static void arcmsr_start_adapter_bgrb(struct AdapterControlBlock *acb);
-static void arcmsr_hbc_message_isr(struct AdapterControlBlock *pACB);
+static void arcmsr_hbaC_message_isr(struct AdapterControlBlock *pACB);
+static void arcmsr_hbaD_message_isr(struct AdapterControlBlock *acb);
 static void arcmsr_hardware_reset(struct AdapterControlBlock *acb);
 static const char *arcmsr_info(struct Scsi_Host *);
 static irqreturn_t arcmsr_interrupt(struct AdapterControlBlock *acb);
@@ -132,8 +137,6 @@ static struct scsi_host_template arcmsr_
  .change_queue_depth = arcmsr_adjust_disk_queue_depth,
  .can_queue = ARCMSR_MAX_FREECCB_NUM,
  .this_id = ARCMSR_SCSI_INITIATOR_ID,
- .sg_tablesize         = ARCMSR_DEFAULT_SG_ENTRIES,
- .max_sectors         = ARCMSR_MAX_XFER_SECTORS_C,
  .cmd_per_lun = ARCMSR_MAX_CMD_PERLUN,
  .use_clustering = ENABLE_CLUSTERING,
  .shost_attrs = arcmsr_host_attrs,
@@ -148,13 +151,12 @@ static struct pci_device_id arcmsr_devic
  {PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1201)},
  {PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1202)},
  {PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1210)},
+ {PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1214)},
  {PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1220)},
  {PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1230)},
  {PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1260)},
  {PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1270)},
  {PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1280)},
- {PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1380)},
- {PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1381)},
  {PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1680)},
  {PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1681)},
  {PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1880)},
@@ -163,26 +165,36 @@ static struct pci_device_id arcmsr_devic
 MODULE_DEVICE_TABLE(pci, arcmsr_device_id_table);
 static struct pci_driver arcmsr_pci_driver = {
  .name = "arcmsr",
- .id_table = arcmsr_device_id_table,
+ .id_table = arcmsr_device_id_table,
  .probe = arcmsr_probe,
  .remove = arcmsr_remove,
+ .suspend = arcmsr_suspend,
+ .resume = arcmsr_resume,
  .shutdown = arcmsr_shutdown,
 };
 /*
 ****************************************************************************
 ****************************************************************************
 */
-
-static void arcmsr_free_hbb_mu(struct AdapterControlBlock *acb)
+static void arcmsr_free_mu(struct AdapterControlBlock *acb)
 {
  switch (acb->adapter_type) {
  case ACB_ADAPTER_TYPE_A:
  case ACB_ADAPTER_TYPE_C:
  break;
- case ACB_ADAPTER_TYPE_B:{
+ case ACB_ADAPTER_TYPE_B: {
+ struct MessageUnit_B __iomem *reg = acb->pmuB;
  dma_free_coherent(&acb->pdev->dev,
  sizeof(struct MessageUnit_B),
- acb->pmuB, acb->dma_coherent_handle_hbb_mu);
+ reg, acb->dma_coherent_handle2);
+ break;
+ }
+ case ACB_ADAPTER_TYPE_D: {
+ dma_free_coherent(&acb->pdev->dev,
+ acb->roundup_ccbsize,
+ acb->dma_coherent2,
+ acb->dma_coherent_handle2);
+ break;
  }
  }
 }
@@ -190,44 +202,73 @@ static void arcmsr_free_hbb_mu(struct Ad
 static bool arcmsr_remap_pciregion(struct AdapterControlBlock *acb)
 {
  struct pci_dev *pdev = acb->pdev;
- switch (acb->adapter_type){
- case ACB_ADAPTER_TYPE_A:{
- acb->pmuA = ioremap(pci_resource_start(pdev,0), pci_resource_len(pdev,0));
+ switch (acb->adapter_type) {
+ case ACB_ADAPTER_TYPE_A: {
+ acb->pmuA = ioremap(pci_resource_start(pdev, 0),
+ pci_resource_len(pdev, 0));
  if (!acb->pmuA) {
- printk(KERN_NOTICE "arcmsr%d: memory mapping region fail \n",
acb->host->host_no);
+ pr_notice("arcmsr%d: memory mapping "
+ "region fail\n", acb->host->host_no);
  return false;
  }
  break;
  }
- case ACB_ADAPTER_TYPE_B:{
+ case ACB_ADAPTER_TYPE_B: {
  void __iomem *mem_base0, *mem_base1;
- mem_base0 = ioremap(pci_resource_start(pdev, 0), pci_resource_len(pdev, 0));
+ mem_base0 = ioremap(pci_resource_start(pdev, 0),
+ pci_resource_len(pdev, 0));
  if (!mem_base0) {
- printk(KERN_NOTICE "arcmsr%d: memory mapping region fail \n",
acb->host->host_no);
+ pr_notice("arcmsr%d: memory mapping "
+ "region fail\n", acb->host->host_no);
  return false;
  }
- mem_base1 = ioremap(pci_resource_start(pdev, 2), pci_resource_len(pdev, 2));
+ mem_base1 = ioremap(pci_resource_start(pdev, 2),
+ pci_resource_len(pdev, 2));
  if (!mem_base1) {
  iounmap(mem_base0);
- printk(KERN_NOTICE "arcmsr%d: memory mapping region fail \n",
acb->host->host_no);
+ pr_notice("arcmsr%d: memory mapping "
+ "region fail\n", acb->host->host_no);
  return false;
  }
  acb->mem_base0 = mem_base0;
  acb->mem_base1 = mem_base1;
  break;
  }
- case ACB_ADAPTER_TYPE_C:{
- acb->pmuC = ioremap_nocache(pci_resource_start(pdev, 1),
pci_resource_len(pdev, 1));
+ case ACB_ADAPTER_TYPE_C: {
+ acb->pmuC = ioremap_nocache(pci_resource_start(pdev, 1),
+ pci_resource_len(pdev, 1));
  if (!acb->pmuC) {
- printk(KERN_NOTICE "arcmsr%d: memory mapping region fail \n",
acb->host->host_no);
+ pr_notice("arcmsr%d: memory mapping "
+ "region fail\n", acb->host->host_no);
  return false;
  }
- if (readl(&acb->pmuC->outbound_doorbell) &
ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE) {
- writel(ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE_DOORBELL_CLEAR,
&acb->pmuC->outbound_doorbell_clear);/*clear interrupt*/
+ if (readl(&acb->pmuC->outbound_doorbell) &
+ ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE) {
+ writel(ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE_DOORBELL_CLEAR,
+ &acb->pmuC->outbound_doorbell_clear);
  return true;
  }
  break;
  }
+ case ACB_ADAPTER_TYPE_D: {
+ void __iomem *mem_base0;
+ unsigned long addr, range, flags;
+
+ addr = (unsigned long)pci_resource_start(pdev, 0);
+ range = pci_resource_len(pdev, 0);
+ flags = pci_resource_flags(pdev, 0);
+ if (flags & IORESOURCE_CACHEABLE)
+ mem_base0 = ioremap(addr, range);
+ else
+ mem_base0 = ioremap_nocache(addr, range);
+ if (!mem_base0) {
+ pr_notice("arcmsr%d: memory mapping region fail\n",
+ acb->host->host_no);
+ return false;
+ }
+ acb->mem_base0 = mem_base0;
+ break;
+ }
  }
  return true;
 }
@@ -235,18 +276,22 @@ static bool arcmsr_remap_pciregion(struc
 static void arcmsr_unmap_pciregion(struct AdapterControlBlock *acb)
 {
  switch (acb->adapter_type) {
- case ACB_ADAPTER_TYPE_A:{
+ case ACB_ADAPTER_TYPE_A: {
  iounmap(acb->pmuA);
+ break;
  }
- break;
- case ACB_ADAPTER_TYPE_B:{
+ case ACB_ADAPTER_TYPE_B: {
  iounmap(acb->mem_base0);
  iounmap(acb->mem_base1);
+ break;
  }
-
- break;
- case ACB_ADAPTER_TYPE_C:{
+ case ACB_ADAPTER_TYPE_C: {
  iounmap(acb->pmuC);
+ break;
+ }
+ case ACB_ADAPTER_TYPE_D: {
+ iounmap(acb->mem_base0);
+ break;
  }
  }
 }
@@ -264,12 +309,13 @@ static int arcmsr_bios_param(struct scsi
  struct block_device *bdev, sector_t capacity, int *geom)
 {
  int ret, heads, sectors, cylinders, total_capacity;
- unsigned char *buffer;/* return copy of block device's partition table */
+ unsigned char *buffer;

  buffer = scsi_bios_ptable(bdev);
  if (buffer) {
- ret = scsi_partsize(buffer, capacity, &geom[2], &geom[0], &geom[1]);
- kfree(buffer);
+ ret = scsi_partsize(buffer, capacity, &geom[2], &geom[0],
+ &geom[1]);
+ kfree((const void *)buffer);
  if (ret != -1)
  return ret;
  }
@@ -288,27 +334,53 @@ static int arcmsr_bios_param(struct scsi
  return 0;
 }

-static void arcmsr_define_adapter_type(struct AdapterControlBlock *acb)
+static bool
+arcmsr_define_adapter_type(struct AdapterControlBlock *acb)
 {
- struct pci_dev *pdev = acb->pdev;
  u16 dev_id;
+ struct pci_dev *pdev = acb->pdev;
+
  pci_read_config_word(pdev, PCI_DEVICE_ID, &dev_id);
  acb->dev_id = dev_id;
  switch (dev_id) {
  case 0x1880: {
  acb->adapter_type = ACB_ADAPTER_TYPE_C;
- }
  break;
- case 0x1201: {
+ }
+ case 0x1200:
+ case 0x1201:
+ case 0x1202: {
  acb->adapter_type = ACB_ADAPTER_TYPE_B;
- }
  break;
-
- default: acb->adapter_type = ACB_ADAPTER_TYPE_A;
  }
+ case 0x1110:
+ case 0x1120:
+ case 0x1130:
+ case 0x1160:
+ case 0x1170:
+ case 0x1210:
+ case 0x1220:
+ case 0x1230:
+ case 0x1260:
+ case 0x1280:
+ case 0x1680: {
+ acb->adapter_type = ACB_ADAPTER_TYPE_A;
+ break;
+ }
+ case 0x1214: {
+ acb->adapter_type = ACB_ADAPTER_TYPE_D;
+ break;
+ }
+ default: {
+ pr_notice("Unknown device ID = 0x%x\n", dev_id);
+ return false;
+ }
+ }
+ return true;
 }

-static uint8_t arcmsr_hba_wait_msgint_ready(struct AdapterControlBlock *acb)
+static bool
+arcmsr_hbaA_wait_msgint_ready(struct AdapterControlBlock *acb)
 {
  struct MessageUnit_A __iomem *reg = acb->pmuA;
  int i;
@@ -326,9 +398,10 @@ static uint8_t arcmsr_hba_wait_msgint_re
  return false;
 }

-static uint8_t arcmsr_hbb_wait_msgint_ready(struct AdapterControlBlock *acb)
+static bool
+arcmsr_hbaB_wait_msgint_ready(struct AdapterControlBlock *acb)
 {
- struct MessageUnit_B *reg = acb->pmuB;
+ struct MessageUnit_B __iomem *reg = acb->pmuB;
  int i;

  for (i = 0; i < 2000; i++) {
@@ -346,283 +419,558 @@ static uint8_t arcmsr_hbb_wait_msgint_re
  return false;
 }

-static uint8_t arcmsr_hbc_wait_msgint_ready(struct AdapterControlBlock *pACB)
+static bool
+arcmsr_hbaC_wait_msgint_ready(struct AdapterControlBlock *pACB)
 {
- struct MessageUnit_C *phbcmu = (struct MessageUnit_C *)pACB->pmuC;
+ struct MessageUnit_C __iomem *phbcmu = pACB->pmuC;
  int i;

  for (i = 0; i < 2000; i++) {
  if (readl(&phbcmu->outbound_doorbell)
- & ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE) {
+ & ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE) {
  writel(ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE_DOORBELL_CLEAR,
- &phbcmu->outbound_doorbell_clear); /*clear interrupt*/
+ &phbcmu->outbound_doorbell_clear);
  return true;
  }
  msleep(10);
- } /* max 20 seconds */
+ }
+ return false;
+}

+static bool
+arcmsr_hbaD_wait_msgint_ready(struct AdapterControlBlock *pACB)
+{
+ int i;
+ struct MessageUnit_D __iomem *reg = pACB->pmuD;
+ for (i = 0; i < 2000; i++) {
+ if (readl(reg->outbound_doorbell)
+ & ARCMSR_ARC1214_IOP2DRV_MESSAGE_CMD_DONE) {
+ writel(ARCMSR_ARC1214_IOP2DRV_MESSAGE_CMD_DONE,
+ reg->outbound_doorbell);
+ return true;
+ }
+ msleep(10);
+ } /* max 20 seconds */
  return false;
 }

-static void arcmsr_flush_hba_cache(struct AdapterControlBlock *acb)
+static void
+arcmsr_hbaA_flush_cache(struct AdapterControlBlock *acb)
 {
  struct MessageUnit_A __iomem *reg = acb->pmuA;
  int retry_count = 30;
  writel(ARCMSR_INBOUND_MESG0_FLUSH_CACHE, &reg->inbound_msgaddr0);
  do {
- if (arcmsr_hba_wait_msgint_ready(acb))
+ if (arcmsr_hbaA_wait_msgint_ready(acb))
  break;
  else {
  retry_count--;
- printk(KERN_NOTICE "arcmsr%d: wait 'flush adapter cache' \
- timeout, retry count down = %d \n", acb->host->host_no, retry_count);
+ pr_notice("arcmsr%d: wait 'flush adapter "
+ "cache' timeout, retry count down = %d\n",
+ acb->host->host_no, retry_count);
  }
  } while (retry_count != 0);
 }

-static void arcmsr_flush_hbb_cache(struct AdapterControlBlock *acb)
+static void
+arcmsr_hbaB_flush_cache(struct AdapterControlBlock *acb)
 {
- struct MessageUnit_B *reg = acb->pmuB;
+ struct MessageUnit_B __iomem *reg = acb->pmuB;
  int retry_count = 30;
  writel(ARCMSR_MESSAGE_FLUSH_CACHE, reg->drv2iop_doorbell);
  do {
- if (arcmsr_hbb_wait_msgint_ready(acb))
+ if (arcmsr_hbaB_wait_msgint_ready(acb))
  break;
  else {
  retry_count--;
- printk(KERN_NOTICE "arcmsr%d: wait 'flush adapter cache' \
- timeout,retry count down = %d \n", acb->host->host_no, retry_count);
+ pr_notice("arcmsr%d: wait 'flush adapter "
+ "cache' timeout, retry count down = %d\n",
+ acb->host->host_no, retry_count);
  }
  } while (retry_count != 0);
 }

-static void arcmsr_flush_hbc_cache(struct AdapterControlBlock *pACB)
+static void
+arcmsr_hbaC_flush_cache(struct AdapterControlBlock *pACB)
 {
- struct MessageUnit_C *reg = (struct MessageUnit_C *)pACB->pmuC;
- int retry_count = 30;/* enlarge wait flush adapter cache time: 10 minute */
- writel(ARCMSR_INBOUND_MESG0_FLUSH_CACHE, &reg->inbound_msgaddr0);
- writel(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE, &reg->inbound_doorbell);
+ struct MessageUnit_C __iomem *reg = pACB->pmuC;
+ int retry_count = 6;/* enlarge wait flush adapter cache time: 10 minute */
+ writel(ARCMSR_INBOUND_MESG0_FLUSH_CACHE,
+ &reg->inbound_msgaddr0);
+ writel(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE,
+ &reg->inbound_doorbell);
+ readl(&reg->inbound_doorbell);
+ readl(&reg->inbound_msgaddr0);
  do {
- if (arcmsr_hbc_wait_msgint_ready(pACB)) {
+ if (arcmsr_hbaC_wait_msgint_ready(pACB))
  break;
- } else {
+ else {
+ retry_count--;
+ pr_notice("arcmsr%d: wait 'flush adapter "
+ "cache' timeout, retry count down = %d\n",
+ pACB->host->host_no, retry_count);
+ }
+ } while (retry_count != 0);
+ return;
+}
+
+static void
+arcmsr_hbaD_flush_cache(struct AdapterControlBlock *pACB)
+{
+ int retry_count = 6;
+ struct MessageUnit_D __iomem *reg = pACB->pmuD;
+
+ writel(ARCMSR_INBOUND_MESG0_FLUSH_CACHE,
+ reg->inbound_msgaddr0);
+ do {
+ if (arcmsr_hbaD_wait_msgint_ready(pACB))
+ break;
+ else {
  retry_count--;
- printk(KERN_NOTICE "arcmsr%d: wait 'flush adapter cache' \
- timeout,retry count down = %d \n", pACB->host->host_no, retry_count);
+ pr_notice("arcmsr%d: wait 'flush adapter "
+ "cache' timeout, retry count down = %d\n",
+ pACB->host->host_no,
+ retry_count);
  }
  } while (retry_count != 0);
  return;
 }
-static void arcmsr_flush_adapter_cache(struct AdapterControlBlock *acb)
+
+static void
+arcmsr_flush_adapter_cache(struct AdapterControlBlock *acb)
 {
  switch (acb->adapter_type) {

  case ACB_ADAPTER_TYPE_A: {
- arcmsr_flush_hba_cache(acb);
- }
+ arcmsr_hbaA_flush_cache(acb);
  break;
-
- case ACB_ADAPTER_TYPE_B: {
- arcmsr_flush_hbb_cache(acb);
  }
+ case ACB_ADAPTER_TYPE_B: {
+ arcmsr_hbaB_flush_cache(acb);
  break;
+ }
  case ACB_ADAPTER_TYPE_C: {
- arcmsr_flush_hbc_cache(acb);
+ arcmsr_hbaC_flush_cache(acb);
+ break;
  }
+ case ACB_ADAPTER_TYPE_D: {
+ arcmsr_hbaD_flush_cache(acb);
+ break;
+ }
  }
 }

-static int arcmsr_alloc_ccb_pool(struct AdapterControlBlock *acb)
+static int
+arcmsr_alloc_ccb_pool(struct AdapterControlBlock *acb)
 {
  struct pci_dev *pdev = acb->pdev;
  void *dma_coherent;
  dma_addr_t dma_coherent_handle;
- struct CommandControlBlock *ccb_tmp;
+ struct CommandControlBlock *ccb_tmp = NULL;
  int i = 0, j = 0;
  dma_addr_t cdb_phyaddr;
- unsigned long roundup_ccbsize;
+ unsigned long roundup_ccbsize = 0;
  unsigned long max_xfer_len;
  unsigned long max_sg_entrys;
  uint32_t  firm_config_version;

- for (i = 0; i < ARCMSR_MAX_TARGETID; i++)
- for (j = 0; j < ARCMSR_MAX_TARGETLUN; j++)
- acb->devstate[i][j] = ARECA_RAID_GONE;
-
  max_xfer_len = ARCMSR_MAX_XFER_LEN;
  max_sg_entrys = ARCMSR_DEFAULT_SG_ENTRIES;
  firm_config_version = acb->firm_cfg_version;
- if((firm_config_version & 0xFF) >= 3){
- max_xfer_len = (ARCMSR_CDB_SG_PAGE_LENGTH << ((firm_config_version
>> 8) & 0xFF)) * 1024;/* max 4M byte */
- max_sg_entrys = (max_xfer_len/4096);
+ if ((firm_config_version & 0xFF) >= 3) {
+ max_xfer_len = (ARCMSR_CDB_SG_PAGE_LENGTH <<
+ ((firm_config_version >> 8) & 0xFF)) * 1024;
+ max_sg_entrys = (max_xfer_len / 4096);
  }
- acb->host->max_sectors = max_xfer_len/512;
+ acb->host->max_sectors = max_xfer_len / 512;
  acb->host->sg_tablesize = max_sg_entrys;
- roundup_ccbsize = roundup(sizeof(struct CommandControlBlock) +
(max_sg_entrys - 1) * sizeof(struct SG64ENTRY), 32);
+ switch (acb->adapter_type) {
+ case ACB_ADAPTER_TYPE_A:
+ roundup_ccbsize = roundup(sizeof(struct CommandControlBlock) +
+ max_sg_entrys * sizeof(struct SG64ENTRY), 32);
+ break;
+ case ACB_ADAPTER_TYPE_B:
+ case ACB_ADAPTER_TYPE_C:
+ case ACB_ADAPTER_TYPE_D:
+ roundup_ccbsize = roundup(sizeof(struct CommandControlBlock) +
+ (max_sg_entrys - 1) * sizeof(struct SG64ENTRY), 32);
+ break;
+ }
  acb->uncache_size = roundup_ccbsize * ARCMSR_MAX_FREECCB_NUM;
- dma_coherent = dma_alloc_coherent(&pdev->dev, acb->uncache_size,
&dma_coherent_handle, GFP_KERNEL);
- if(!dma_coherent){
- printk(KERN_NOTICE "arcmsr%d: dma_alloc_coherent got error\n",
acb->host->host_no);
+ dma_coherent = dma_alloc_coherent(&pdev->dev,
+ acb->uncache_size, &dma_coherent_handle, GFP_KERNEL);
+ if (!dma_coherent) {
+ pr_notice("arcmsr%d: dma_alloc_coherent got error\n",
+ acb->host->host_no);
  return -ENOMEM;
  }
+ memset(dma_coherent, 0, acb->uncache_size);
  acb->dma_coherent = dma_coherent;
  acb->dma_coherent_handle = dma_coherent_handle;
- memset(dma_coherent, 0, acb->uncache_size);
- ccb_tmp = dma_coherent;
- acb->vir2phy_offset = (unsigned long)dma_coherent - (unsigned
long)dma_coherent_handle;
- for(i = 0; i < ARCMSR_MAX_FREECCB_NUM; i++){
- cdb_phyaddr = dma_coherent_handle + offsetof(struct
CommandControlBlock, arcmsr_cdb);
- ccb_tmp->cdb_phyaddr_pattern = ((acb->adapter_type ==
ACB_ADAPTER_TYPE_C) ? cdb_phyaddr : (cdb_phyaddr >> 5));
+ ccb_tmp = (struct CommandControlBlock *)dma_coherent;
+ acb->vir2phy_offset = (unsigned long)dma_coherent -
+ (unsigned long)dma_coherent_handle;
+ for (i = 0; i < ARCMSR_MAX_FREECCB_NUM; i++) {
+ cdb_phyaddr = dma_coherent_handle +
+ offsetof(struct CommandControlBlock, arcmsr_cdb);
+ switch (acb->adapter_type) {
+ case ACB_ADAPTER_TYPE_A:
+ case ACB_ADAPTER_TYPE_B:
+ ccb_tmp->cdb_phyaddr = cdb_phyaddr >> 5;
+ break;
+ case ACB_ADAPTER_TYPE_C:
+ case ACB_ADAPTER_TYPE_D:
+ ccb_tmp->cdb_phyaddr = cdb_phyaddr;
+ break;
+ }
  acb->pccb_pool[i] = ccb_tmp;
  ccb_tmp->acb = acb;
  INIT_LIST_HEAD(&ccb_tmp->list);
  list_add_tail(&ccb_tmp->list, &acb->ccb_free_list);
- ccb_tmp = (struct CommandControlBlock *)((unsigned long)ccb_tmp +
roundup_ccbsize);
+ ccb_tmp = (struct CommandControlBlock *)
+ ((unsigned long)ccb_tmp + roundup_ccbsize);
  dma_coherent_handle = dma_coherent_handle + roundup_ccbsize;
  }
+ for (i = 0; i < ARCMSR_MAX_TARGETID; i++)
+ for (j = 0; j < ARCMSR_MAX_TARGETLUN; j++)
+ acb->devstate[i][j] = ARECA_RAID_GONE;
  return 0;
 }

-static void arcmsr_message_isr_bh_fn(struct work_struct *work)
+static void
+arcmsr_message_isr_bh_fn(struct work_struct *work)
 {
- struct AdapterControlBlock *acb = container_of(work,struct
AdapterControlBlock, arcmsr_do_message_isr_bh);
+ struct AdapterControlBlock *acb = container_of(work,
+ struct AdapterControlBlock, arcmsr_do_message_isr_bh);
  switch (acb->adapter_type) {
- case ACB_ADAPTER_TYPE_A: {
-
- struct MessageUnit_A __iomem *reg  = acb->pmuA;
- char *acb_dev_map = (char *)acb->device_map;
- uint32_t __iomem *signature = (uint32_t __iomem*) (&reg->message_rwbuffer[0]);
- char __iomem *devicemap = (char __iomem*) (&reg->message_rwbuffer[21]);
- int target, lun;
- struct scsi_device *psdev;
- char diff;
-
- atomic_inc(&acb->rq_map_token);
- if (readl(signature) == ARCMSR_SIGNATURE_GET_CONFIG) {
- for(target = 0; target < ARCMSR_MAX_TARGETID -1; target++) {
- diff = (*acb_dev_map)^readb(devicemap);
- if (diff != 0) {
- char temp;
- *acb_dev_map = readb(devicemap);
- temp =*acb_dev_map;
- for(lun = 0; lun < ARCMSR_MAX_TARGETLUN; lun++) {
- if((temp & 0x01)==1 && (diff & 0x01) == 1) {
- scsi_add_device(acb->host, 0, target, lun);
- }else if((temp & 0x01) == 0 && (diff & 0x01) == 1) {
- psdev = scsi_device_lookup(acb->host, 0, target, lun);
- if (psdev != NULL ) {
- scsi_remove_device(psdev);
- scsi_device_put(psdev);
- }
+ case ACB_ADAPTER_TYPE_A: {
+ struct MessageUnit_A __iomem *reg  = acb->pmuA;
+ char *acb_dev_map = (char *)acb->device_map;
+ uint32_t __iomem *signature = (uint32_t __iomem *)
+ (&reg->message_rwbuffer[0]);
+ char __iomem *devicemap = (char __iomem *)
+ (&reg->message_rwbuffer[21]);
+ int target, lun;
+ struct scsi_device *psdev;
+ char diff;
+
+ atomic_inc(&acb->rq_map_token);
+ if (readl(signature) == ARCMSR_SIGNATURE_GET_CONFIG) {
+ for (target = 0; target < ARCMSR_MAX_TARGETID - 1;
+ target++) {
+ diff = (*acb_dev_map) ^ readb(devicemap);
+ if (diff != 0) {
+ char temp;
+ *acb_dev_map = readb(devicemap);
+ temp = *acb_dev_map;
+ for (lun = 0; lun <
+ ARCMSR_MAX_TARGETLUN; lun++) {
+ if ((temp & 0x01) == 1 &&
+ (diff & 0x01) == 1) {
+ scsi_add_device(acb->host,
+ 0, target, lun);
+ } else if ((temp & 0x01) == 0
+ && (diff & 0x01) == 1) {
+ psdev =
+ scsi_device_lookup(acb->host,
+ 0, target, lun);
+ if (psdev != NULL) {
+ scsi_remove_device(psdev);
+ scsi_device_put(psdev);
  }
- temp >>= 1;
- diff >>= 1;
  }
+ temp >>= 1;
+ diff >>= 1;
  }
- devicemap++;
- acb_dev_map++;
  }
+ devicemap++;
+ acb_dev_map++;
  }
- break;
  }
+ break;
+ }

- case ACB_ADAPTER_TYPE_B: {
- struct MessageUnit_B *reg  = acb->pmuB;
- char *acb_dev_map = (char *)acb->device_map;
- uint32_t __iomem *signature = (uint32_t __iomem*)(&reg->message_rwbuffer[0]);
- char __iomem *devicemap = (char __iomem*)(&reg->message_rwbuffer[21]);
- int target, lun;
- struct scsi_device *psdev;
- char diff;
-
- atomic_inc(&acb->rq_map_token);
- if (readl(signature) == ARCMSR_SIGNATURE_GET_CONFIG) {
- for(target = 0; target < ARCMSR_MAX_TARGETID -1; target++) {
- diff = (*acb_dev_map)^readb(devicemap);
- if (diff != 0) {
- char temp;
- *acb_dev_map = readb(devicemap);
- temp =*acb_dev_map;
- for(lun = 0; lun < ARCMSR_MAX_TARGETLUN; lun++) {
- if((temp & 0x01)==1 && (diff & 0x01) == 1) {
- scsi_add_device(acb->host, 0, target, lun);
- }else if((temp & 0x01) == 0 && (diff & 0x01) == 1) {
- psdev = scsi_device_lookup(acb->host, 0, target, lun);
- if (psdev != NULL ) {
- scsi_remove_device(psdev);
- scsi_device_put(psdev);
- }
+ case ACB_ADAPTER_TYPE_B: {
+ struct MessageUnit_B __iomem *reg  = acb->pmuB;
+ char *acb_dev_map = (char *)acb->device_map;
+ uint32_t __iomem *signature =
+ (uint32_t __iomem *)(&reg->message_rwbuffer[0]);
+ char __iomem *devicemap =
+ (char __iomem *)(&reg->message_rwbuffer[21]);
+ int target, lun;
+ struct scsi_device *psdev;
+ char diff;
+
+ atomic_inc(&acb->rq_map_token);
+ if (readl(signature) == ARCMSR_SIGNATURE_GET_CONFIG) {
+ for (target = 0; target <
+ ARCMSR_MAX_TARGETID - 1; target++) {
+ diff = (*acb_dev_map) ^ readb(devicemap);
+ if (diff != 0) {
+ char temp;
+ *acb_dev_map = readb(devicemap);
+ temp = *acb_dev_map;
+ for (lun = 0;
+ lun < ARCMSR_MAX_TARGETLUN;
+ lun++) {
+ if ((temp & 0x01) == 1 &&
+ (diff & 0x01) == 1) {
+ scsi_add_device(acb->host,
+ 0, target, lun);
+ } else if ((temp & 0x01) == 0
+ && (diff & 0x01) == 1) {
+ psdev = scsi_device_lookup(acb->host,
+ 0, target, lun);
+ if (psdev != NULL) {
+ scsi_remove_device(psdev);
+ scsi_device_put(psdev);
  }
- temp >>= 1;
- diff >>= 1;
  }
+ temp >>= 1;
+ diff >>= 1;
  }
- devicemap++;
- acb_dev_map++;
  }
+ devicemap++;
+ acb_dev_map++;
  }
  }
- break;
- case ACB_ADAPTER_TYPE_C: {
- struct MessageUnit_C *reg  = acb->pmuC;
- char *acb_dev_map = (char *)acb->device_map;
- uint32_t __iomem *signature = (uint32_t __iomem *)(&reg->msgcode_rwbuffer[0]);
- char __iomem *devicemap = (char __iomem *)(&reg->msgcode_rwbuffer[21]);
- int target, lun;
- struct scsi_device *psdev;
- char diff;
-
- atomic_inc(&acb->rq_map_token);
- if (readl(signature) == ARCMSR_SIGNATURE_GET_CONFIG) {
- for (target = 0; target < ARCMSR_MAX_TARGETID - 1; target++) {
- diff = (*acb_dev_map)^readb(devicemap);
- if (diff != 0) {
- char temp;
- *acb_dev_map = readb(devicemap);
- temp = *acb_dev_map;
- for (lun = 0; lun < ARCMSR_MAX_TARGETLUN; lun++) {
- if ((temp & 0x01) == 1 && (diff & 0x01) == 1) {
- scsi_add_device(acb->host, 0, target, lun);
- } else if ((temp & 0x01) == 0 && (diff & 0x01) == 1) {
- psdev = scsi_device_lookup(acb->host, 0, target, lun);
- if (psdev != NULL) {
- scsi_remove_device(psdev);
- scsi_device_put(psdev);
- }
+ }
+ break;
+ case ACB_ADAPTER_TYPE_C: {
+ struct MessageUnit_C __iomem *reg  = acb->pmuC;
+ char *acb_dev_map = (char *)acb->device_map;
+ uint32_t __iomem *signature =
+ (uint32_t __iomem *)(&reg->msgcode_rwbuffer[0]);
+ char __iomem *devicemap =
+ (char __iomem *)(&reg->msgcode_rwbuffer[21]);
+ int target, lun;
+ struct scsi_device *psdev;
+ char diff;
+
+ atomic_inc(&acb->rq_map_token);
+ if (readl(signature) == ARCMSR_SIGNATURE_GET_CONFIG) {
+ for (target = 0; target <
+ ARCMSR_MAX_TARGETID - 1; target++) {
+ diff = (*acb_dev_map) ^ readb(devicemap);
+ if (diff != 0) {
+ char temp;
+ *acb_dev_map =
+ readb(devicemap);
+ temp = *acb_dev_map;
+ for (lun = 0; lun <
+ ARCMSR_MAX_TARGETLUN; lun++) {
+ if ((temp & 0x01) == 1 &&
+ (diff & 0x01) == 1) {
+ scsi_add_device(acb->host,
+ 0, target, lun);
+ } else if ((temp & 0x01) == 0
+ && (diff & 0x01) == 1) {
+ psdev = scsi_device_lookup(acb->host,
+ 0, target, lun);
+ if (psdev != NULL) {
+ scsi_remove_device(psdev);
+ scsi_device_put(psdev);
+ }
+ }
+ temp >>= 1;
+ diff >>= 1;
+ }
+ }
+ devicemap++;
+ acb_dev_map++;
+ }
+ }
+ }
+ break;
+ case ACB_ADAPTER_TYPE_D: {
+ struct MessageUnit_D __iomem *reg  = acb->pmuD;
+ char *acb_dev_map = (char *)acb->device_map;
+ uint32_t __iomem *signature =
+ (uint32_t __iomem *)(&reg->msgcode_rwbuffer[0]);
+ char __iomem *devicemap =
+ (char __iomem *)(&reg->msgcode_rwbuffer[21]);
+ int target, lun;
+ struct scsi_device *psdev;
+ char diff;
+
+ atomic_inc(&acb->rq_map_token);
+ if (readl(signature) == ARCMSR_SIGNATURE_GET_CONFIG) {
+ for (target = 0; target <
+ ARCMSR_MAX_TARGETID - 1; target++) {
+ diff = (*acb_dev_map) ^ readb(devicemap);
+ if (diff != 0) {
+ char temp;
+ *acb_dev_map =
+ readb(devicemap);
+ temp = *acb_dev_map;
+ for (lun = 0; lun <
+ ARCMSR_MAX_TARGETLUN; lun++) {
+ if ((temp & 0x01) == 1 &&
+ (diff & 0x01) == 1) {
+ scsi_add_device(acb->host,
+ 0, target, lun);
+ } else if ((temp & 0x01) == 0
+ && (diff & 0x01) == 1) {
+ psdev = scsi_device_lookup(acb->host,
+ 0, target, lun);
+ if (psdev != NULL) {
+ scsi_remove_device(psdev);
+ scsi_device_put(psdev);
  }
- temp >>= 1;
- diff >>= 1;
  }
+ temp >>= 1;
+ diff >>= 1;
  }
- devicemap++;
- acb_dev_map++;
  }
+ devicemap++;
+ acb_dev_map++;
+ }
+ }
+ break;
+ }
+ }
+}
+
+static int
+arcmsr_suspend(struct pci_dev *pdev, pm_message_t state)
+{
+ int i;
+ uint32_t intmask_org;
+ struct Scsi_Host *host = pci_get_drvdata(pdev);
+ struct AdapterControlBlock *acb =
+ (struct AdapterControlBlock *)host->hostdata;
+
+ intmask_org = arcmsr_disable_outbound_ints(acb);
+ if (acb->acb_flags & ACB_F_MSI_ENABLED) {
+ free_irq(pdev->irq, acb);
+ pci_disable_msi(pdev);
+ } else if (acb->acb_flags & ACB_F_MSIX_ENABLED) {
+ for (i = 0; i < ARCMST_NUM_MSIX_VECTORS; i++)
+ free_irq(acb->entries[i].vector, acb);
+ pci_disable_msix(pdev);
+ } else
+ free_irq(pdev->irq, acb);
+ del_timer_sync(&acb->eternal_timer);
+ flush_scheduled_work();
+ arcmsr_stop_adapter_bgrb(acb);
+ arcmsr_flush_adapter_cache(acb);
+ arcmsr_enable_outbound_ints(acb, intmask_org);
+ pci_set_drvdata(pdev, host);
+ pci_save_state(pdev);
+ pci_disable_device(pdev);
+ pci_set_power_state(pdev, pci_choose_state(pdev, state));
+ return 0;
+}
+
+static int
+arcmsr_resume(struct pci_dev *pdev)
+{
+ int error, i, j;
+ struct Scsi_Host *host = pci_get_drvdata(pdev);
+ struct AdapterControlBlock *acb =
+ (struct AdapterControlBlock *)host->hostdata;
+ struct msix_entry entries[ARCMST_NUM_MSIX_VECTORS];
+ pci_set_power_state(pdev, PCI_D0);
+ pci_enable_wake(pdev, PCI_D0, 0);
+ pci_restore_state(pdev);
+ if (pci_enable_device(pdev)) {
+ pr_warn("%s: pci_enable_device error\n", __func__);
+ return -ENODEV;
+ }
+ error = pci_set_dma_mask(pdev, DMA_BIT_MASK(64));
+ if (error) {
+ error = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
+ if (error) {
+ pr_warn("scsi%d: No suitable DMA mask available\n",
+       host->host_no);
+ goto controller_unregister;
+ }
+ }
+ pci_set_master(pdev);
+ if (pci_find_capability(pdev, PCI_CAP_ID_MSIX)) {
+ if (!pci_enable_msix(pdev, entries,
+ ARCMST_NUM_MSIX_VECTORS)) {
+ for (i = 0; i < ARCMST_NUM_MSIX_VECTORS;
+ i++) {
+ entries[i].entry = i;
+ if (request_irq(entries[i].vector,
+ arcmsr_do_interrupt, 0,
+ "arcmsr", acb)) {
+ for (j = 0 ; j < i ; j++)
+ free_irq(entries[i].vector,
+ acb);
+ goto controller_stop;
+ }
+ acb->entries[i] = entries[i];
+ }
+ acb->acb_flags |= ACB_F_MSIX_ENABLED;
+ } else {
+ pr_warn("arcmsr%d: MSI-X "
+ "failed to enable\n", acb->host->host_no);
+ if (request_irq(pdev->irq,
+ arcmsr_do_interrupt, IRQF_SHARED,
+ "arcmsr", acb)) {
+ goto controller_stop;
  }
  }
+ } else if (pci_find_capability(pdev, PCI_CAP_ID_MSI)) {
+ if (!pci_enable_msi(pdev))
+ acb->acb_flags |= ACB_F_MSI_ENABLED;
+ if (request_irq(pdev->irq, arcmsr_do_interrupt,
+ IRQF_SHARED, "arcmsr", acb))
+ goto controller_stop;
+ } else {
+ if (request_irq(pdev->irq, arcmsr_do_interrupt,
+ IRQF_SHARED, "arcmsr", acb))
+ goto controller_stop;
  }
+ arcmsr_iop_init(acb);
+ INIT_WORK(&acb->arcmsr_do_message_isr_bh,
+ arcmsr_message_isr_bh_fn);
+ atomic_set(&acb->rq_map_token, 16);
+ atomic_set(&acb->ante_token_value, 16);
+ acb->fw_flag = FW_NORMAL;
+ init_timer(&acb->eternal_timer);
+ acb->eternal_timer.expires = jiffies +
+ msecs_to_jiffies(6 * HZ);
+ acb->eternal_timer.data = (unsigned long) acb;
+ acb->eternal_timer.function =
+ &arcmsr_request_device_map;
+ add_timer(&acb->eternal_timer);
+ return 0;
+controller_stop:
+ arcmsr_stop_adapter_bgrb(acb);
+ arcmsr_flush_adapter_cache(acb);
+controller_unregister:
+ scsi_remove_host(host);
+ arcmsr_free_ccb_pool(acb);
+ arcmsr_unmap_pciregion(acb);
+ pci_release_regions(pdev);
+ scsi_host_put(host);
+ pci_disable_device(pdev);
+ return -ENODEV;
 }

 static int arcmsr_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
  struct Scsi_Host *host;
  struct AdapterControlBlock *acb;
- uint8_t bus,dev_fun;
- int error;
+ uint8_t bus, dev_fun;
+ struct msix_entry entries[ARCMST_NUM_MSIX_VECTORS];
+ int error, i, j;
  error = pci_enable_device(pdev);
- if(error){
+ if (error)
  return -ENODEV;
- }
- host = scsi_host_alloc(&arcmsr_scsi_host_template, sizeof(struct
AdapterControlBlock));
- if(!host){
+ host = scsi_host_alloc(&arcmsr_scsi_host_template,
+ sizeof(struct AdapterControlBlock));
+ if (!host)
      goto pci_disable_dev;
- }
  error = pci_set_dma_mask(pdev, DMA_BIT_MASK(64));
- if(error){
+ if (error) {
  error = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
- if(error){
- printk(KERN_WARNING
-       "scsi%d: No suitable DMA mask available\n",
-       host->host_no);
+ if (error) {
+ pr_warn("scsi%d: No suitable DMA mask available\n",
+ host->host_no);
  goto scsi_host_release;
  }
  }
@@ -634,70 +982,114 @@ static int arcmsr_probe(struct pci_dev *
  acb->pdev = pdev;
  acb->host = host;
  host->max_lun = ARCMSR_MAX_TARGETLUN;
- host->max_id = ARCMSR_MAX_TARGETID; /*16:8*/
- host->max_cmd_len = 16; /*this is issue of 64bit LBA ,over 2T byte*/
- host->can_queue = ARCMSR_MAX_FREECCB_NUM; /* max simultaneous cmds */
- host->cmd_per_lun = ARCMSR_MAX_CMD_PERLUN;
+ host->max_id = ARCMSR_MAX_TARGETID;
+ host->max_cmd_len = 16;
+ host->can_queue = ARCMSR_MAX_FREECCB_NUM;
+ host->cmd_per_lun = ARCMSR_MAX_CMD_PERLUN;
  host->this_id = ARCMSR_SCSI_INITIATOR_ID;
  host->unique_id = (bus << 8) | dev_fun;
  pci_set_drvdata(pdev, host);
  pci_set_master(pdev);
  error = pci_request_regions(pdev, "arcmsr");
- if(error){
+ if (error)
  goto scsi_host_release;
- }
  spin_lock_init(&acb->eh_lock);
  spin_lock_init(&acb->ccblist_lock);
+ spin_lock_init(&acb->postq_lock);
+ spin_lock_init(&acb->doneq_lock);
+ spin_lock_init(&acb->rqbuffer_lock);
+ spin_lock_init(&acb->wqbuffer_lock);
  acb->acb_flags |= (ACB_F_MESSAGE_WQBUFFER_CLEARED |
  ACB_F_MESSAGE_RQBUFFER_CLEARED |
  ACB_F_MESSAGE_WQBUFFER_READED);
  acb->acb_flags &= ~ACB_F_SCSISTOPADAPTER;
  INIT_LIST_HEAD(&acb->ccb_free_list);
- arcmsr_define_adapter_type(acb);
+ error = arcmsr_define_adapter_type(acb);
+ if (!error)
+ goto pci_release_regs;
  error = arcmsr_remap_pciregion(acb);
- if(!error){
+ if (!error)
  goto pci_release_regs;
- }
  error = arcmsr_get_firmware_spec(acb);
- if(!error){
+ if (!error)
  goto unmap_pci_region;
- }
  error = arcmsr_alloc_ccb_pool(acb);
- if(error){
+ if (error)
  goto free_hbb_mu;
- }
- arcmsr_iop_init(acb);
  error = scsi_add_host(host, &pdev->dev);
- if(error){
+ if (error)
  goto RAID_controller_stop;
- }
- error = request_irq(pdev->irq, arcmsr_do_interrupt, IRQF_SHARED,
"arcmsr", acb);
- if(error){
- goto scsi_host_remove;
+ if (pci_find_capability(pdev, PCI_CAP_ID_MSIX)) {
+ if (!pci_enable_msix(pdev, entries, ARCMST_NUM_MSIX_VECTORS)) {
+ for (i = 0; i < ARCMST_NUM_MSIX_VECTORS; i++) {
+ entries[i].entry = i;
+ if (request_irq(entries[i].vector,
+ arcmsr_do_interrupt, 0, "arcmsr",
+ acb)) {
+ for (j = 0 ; j < i ; j++)
+ free_irq(entries[i].vector,
+ acb);
+ goto scsi_host_remove;
+ }
+ acb->entries[i] = entries[i];
+ }
+ acb->acb_flags |= ACB_F_MSIX_ENABLED;
+ } else {
+ if (request_irq(pdev->irq, arcmsr_do_interrupt,
+ IRQF_SHARED, "arcmsr", acb)) {
+ pr_warn("arcmsr%d: request_irq = %d failed!\n",
+ acb->host->host_no, pdev->irq);
+ goto scsi_host_remove;
+ }
+ }
+ } else if (pci_find_capability(pdev, PCI_CAP_ID_MSI)) {
+ if (!pci_enable_msi(pdev))
+ acb->acb_flags |= ACB_F_MSI_ENABLED;
+ if (request_irq(pdev->irq, arcmsr_do_interrupt,
+ IRQF_SHARED, "arcmsr", acb)) {
+ pr_warn("arcmsr%d: request_irq =%d failed!\n",
+ acb->host->host_no, pdev->irq);
+ goto scsi_host_remove;
+ }
+ } else {
+ if (request_irq(pdev->irq, arcmsr_do_interrupt,
+ IRQF_SHARED, "arcmsr", acb)) {
+ pr_warn("arcmsr%d: request_irq = %d failed!\n",
+ acb->host->host_no, pdev->irq);
+ goto scsi_host_remove;
+ }
  }
  host->irq = pdev->irq;
-     scsi_scan_host(host);
- INIT_WORK(&acb->arcmsr_do_message_isr_bh, arcmsr_message_isr_bh_fn);
+ arcmsr_iop_init(acb);
+ scsi_scan_host(host);
+ INIT_WORK(&acb->arcmsr_do_message_isr_bh,
+ arcmsr_message_isr_bh_fn);
  atomic_set(&acb->rq_map_token, 16);
  atomic_set(&acb->ante_token_value, 16);
  acb->fw_flag = FW_NORMAL;
  init_timer(&acb->eternal_timer);
- acb->eternal_timer.expires = jiffies + msecs_to_jiffies(6 * HZ);
+ acb->eternal_timer.expires = jiffies +
+ msecs_to_jiffies(6 * HZ);
  acb->eternal_timer.data = (unsigned long) acb;
- acb->eternal_timer.function = &arcmsr_request_device_map;
+ acb->eternal_timer.function =
+ &arcmsr_request_device_map;
  add_timer(&acb->eternal_timer);
- if(arcmsr_alloc_sysfs_attr(acb))
+ if (arcmsr_alloc_sysfs_attr(acb))
  goto out_free_sysfs;
  return 0;
 out_free_sysfs:
 scsi_host_remove:
+ if (acb->acb_flags & ACB_F_MSI_ENABLED)
+ pci_disable_msi(pdev);
+ else if (acb->acb_flags & ACB_F_MSIX_ENABLED)
+ pci_disable_msix(pdev);
  scsi_remove_host(host);
 RAID_controller_stop:
  arcmsr_stop_adapter_bgrb(acb);
  arcmsr_flush_adapter_cache(acb);
  arcmsr_free_ccb_pool(acb);
 free_hbb_mu:
- arcmsr_free_hbb_mu(acb);
+ arcmsr_free_mu(acb);
 unmap_pci_region:
  arcmsr_unmap_pciregion(acb);
 pci_release_regs:
@@ -709,85 +1101,114 @@ pci_disable_dev:
  return -ENODEV;
 }

-static uint8_t arcmsr_abort_hba_allcmd(struct AdapterControlBlock *acb)
+static uint8_t
+arcmsr_hbaA_abort_allcmd(struct AdapterControlBlock *acb)
 {
  struct MessageUnit_A __iomem *reg = acb->pmuA;
- writel(ARCMSR_INBOUND_MESG0_ABORT_CMD, &reg->inbound_msgaddr0);
- if (!arcmsr_hba_wait_msgint_ready(acb)) {
- printk(KERN_NOTICE
- "arcmsr%d: wait 'abort all outstanding command' timeout \n"
+ writel(ARCMSR_INBOUND_MESG0_ABORT_CMD,
+ &reg->inbound_msgaddr0);
+ if (!arcmsr_hbaA_wait_msgint_ready(acb)) {
+ pr_notice("arcmsr%d: wait 'abort all outstanding "
+ "command' timeout\n"
  , acb->host->host_no);
  return false;
  }
  return true;
 }

-static uint8_t arcmsr_abort_hbb_allcmd(struct AdapterControlBlock *acb)
+static uint8_t
+arcmsr_hbaB_abort_allcmd(struct AdapterControlBlock *acb)
 {
- struct MessageUnit_B *reg = acb->pmuB;
+ struct MessageUnit_B __iomem *reg = acb->pmuB;

- writel(ARCMSR_MESSAGE_ABORT_CMD, reg->drv2iop_doorbell);
- if (!arcmsr_hbb_wait_msgint_ready(acb)) {
- printk(KERN_NOTICE
- "arcmsr%d: wait 'abort all outstanding command' timeout \n"
+ writel(ARCMSR_MESSAGE_ABORT_CMD,
+ reg->drv2iop_doorbell);
+ if (!arcmsr_hbaB_wait_msgint_ready(acb)) {
+ pr_notice("arcmsr%d: wait 'abort all outstanding "
+ "command' timeout\n"
  , acb->host->host_no);
  return false;
  }
  return true;
 }
-static uint8_t arcmsr_abort_hbc_allcmd(struct AdapterControlBlock *pACB)
+static uint8_t
+arcmsr_hbaC_abort_allcmd(struct AdapterControlBlock *pACB)
 {
- struct MessageUnit_C *reg = (struct MessageUnit_C *)pACB->pmuC;
+ struct MessageUnit_C __iomem *reg = pACB->pmuC;
  writel(ARCMSR_INBOUND_MESG0_ABORT_CMD, &reg->inbound_msgaddr0);
  writel(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE, &reg->inbound_doorbell);
- if (!arcmsr_hbc_wait_msgint_ready(pACB)) {
- printk(KERN_NOTICE
- "arcmsr%d: wait 'abort all outstanding command' timeout \n"
+ if (!arcmsr_hbaC_wait_msgint_ready(pACB)) {
+ pr_notice("arcmsr%d: wait 'abort all outstanding "
+ "command' timeout\n"
+ , pACB->host->host_no);
+ return false;
+ }
+ return true;
+}
+static uint8_t
+arcmsr_hbaD_abort_allcmd(struct AdapterControlBlock *pACB)
+{
+ struct MessageUnit_D __iomem *reg = pACB->pmuD;
+ writel(ARCMSR_INBOUND_MESG0_ABORT_CMD, reg->inbound_msgaddr0);
+ if (!arcmsr_hbaD_wait_msgint_ready(pACB)) {
+ pr_notice("arcmsr%d: wait 'abort all outstanding "
+ "command' timeout\n"
  , pACB->host->host_no);
  return false;
  }
  return true;
 }
-static uint8_t arcmsr_abort_allcmd(struct AdapterControlBlock *acb)
+static uint8_t
+arcmsr_abort_allcmd(struct AdapterControlBlock *acb)
 {
  uint8_t rtnval = 0;
  switch (acb->adapter_type) {
  case ACB_ADAPTER_TYPE_A: {
- rtnval = arcmsr_abort_hba_allcmd(acb);
- }
+ rtnval = arcmsr_hbaA_abort_allcmd(acb);
  break;
+ }

  case ACB_ADAPTER_TYPE_B: {
- rtnval = arcmsr_abort_hbb_allcmd(acb);
- }
+ rtnval = arcmsr_hbaB_abort_allcmd(acb);
  break;
+ }

  case ACB_ADAPTER_TYPE_C: {
- rtnval = arcmsr_abort_hbc_allcmd(acb);
+ rtnval = arcmsr_hbaC_abort_allcmd(acb);
+ break;
+ }
+
+ case ACB_ADAPTER_TYPE_D: {
+ rtnval = arcmsr_hbaD_abort_allcmd(acb);
+ break;
  }
  }
  return rtnval;
 }

-static bool arcmsr_hbb_enable_driver_mode(struct AdapterControlBlock *pacb)
+static bool
+arcmsr_hbb_enable_driver_mode(struct AdapterControlBlock *pacb)
 {
- struct MessageUnit_B *reg = pacb->pmuB;
- writel(ARCMSR_MESSAGE_START_DRIVER_MODE, reg->drv2iop_doorbell);
- if (!arcmsr_hbb_wait_msgint_ready(pacb)) {
- printk(KERN_ERR "arcmsr%d: can't set driver mode. \n", pacb->host->host_no);
+ struct MessageUnit_B __iomem *reg = pacb->pmuB;
+ writel(ARCMSR_MESSAGE_START_DRIVER_MODE,
+ reg->drv2iop_doorbell);
+ if (!arcmsr_hbaB_wait_msgint_ready(pacb)) {
+ pr_err("arcmsr%d: can't set driver mode.\n",
+ pacb->host->host_no);
  return false;
  }
      return true;
 }

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
@@ -801,52 +1222,68 @@ static void arcmsr_ccb_complete(struct C
  pcmd->scsi_done(pcmd);
 }

-static void arcmsr_report_sense_info(struct CommandControlBlock *ccb)
+static void
+arcmsr_report_sense_info(struct CommandControlBlock *ccb)
 {

  struct scsi_cmnd *pcmd = ccb->pcmd;
- struct SENSE_DATA *sensebuffer = (struct SENSE_DATA *)pcmd->sense_buffer;
- pcmd->result = DID_OK << 16;
+ struct SENSE_DATA *sensebuffer =
+ (struct SENSE_DATA *)pcmd->sense_buffer;
+ pcmd->result = (DID_OK << 16) | (CHECK_CONDITION << 1)
+ | (DRIVER_SENSE << 24);
  if (sensebuffer) {
  int sense_data_length =
  sizeof(struct SENSE_DATA) < SCSI_SENSE_BUFFERSIZE
  ? sizeof(struct SENSE_DATA) : SCSI_SENSE_BUFFERSIZE;
  memset(sensebuffer, 0, SCSI_SENSE_BUFFERSIZE);
- memcpy(sensebuffer, ccb->arcmsr_cdb.SenseData, sense_data_length);
+ memcpy((void *)sensebuffer, (const void *)ccb->arcmsr_cdb.SenseData,
+ sense_data_length);
  sensebuffer->ErrorCode = SCSI_SENSE_CURRENT_ERRORS;
  sensebuffer->Valid = 1;
  }
 }

-static u32 arcmsr_disable_outbound_ints(struct AdapterControlBlock *acb)
+static u32
+arcmsr_disable_outbound_ints(struct AdapterControlBlock *acb)
 {
  u32 orig_mask = 0;
  switch (acb->adapter_type) {
  case ACB_ADAPTER_TYPE_A : {
  struct MessageUnit_A __iomem *reg = acb->pmuA;
  orig_mask = readl(&reg->outbound_intmask);
- writel(orig_mask|ARCMSR_MU_OUTBOUND_ALL_INTMASKENABLE, \
- &reg->outbound_intmask);
+ writel(orig_mask |
+ ARCMSR_MU_OUTBOUND_ALL_INTMASKENABLE,
+ &reg->outbound_intmask);
  }
  break;
  case ACB_ADAPTER_TYPE_B : {
- struct MessageUnit_B *reg = acb->pmuB;
+ struct MessageUnit_B __iomem *reg = acb->pmuB;
  orig_mask = readl(reg->iop2drv_doorbell_mask);
  writel(0, reg->iop2drv_doorbell_mask);
  }
  break;
- case ACB_ADAPTER_TYPE_C:{
- struct MessageUnit_C *reg = (struct MessageUnit_C *)acb->pmuC;
+ case ACB_ADAPTER_TYPE_C: {
+ struct MessageUnit_C __iomem *reg = acb->pmuC;
  /* disable all outbound interrupt */
- orig_mask = readl(&reg->host_int_mask); /* disable outbound message0 int */
- writel(orig_mask|ARCMSR_HBCMU_ALL_INTMASKENABLE, &reg->host_int_mask);
+ orig_mask = readl(&reg->host_int_mask);
+ writel(orig_mask | ARCMSR_HBCMU_ALL_INTMASKENABLE,
+ &reg->host_int_mask);
+ readl(&reg->host_int_mask);
  }
  break;
+ case ACB_ADAPTER_TYPE_D: {
+ struct MessageUnit_D __iomem *reg = acb->pmuD;
+ /* disable all outbound interrupt */
+ writel(ARCMSR_ARC1214_ALL_INT_DISABLE,
+ reg->pcief0_int_enable);
+ break;
+ }
  }
  return orig_mask;
 }

-static void arcmsr_report_ccb_state(struct AdapterControlBlock *acb,
+static void
+arcmsr_report_ccb_state(struct AdapterControlBlock *acb,
  struct CommandControlBlock *ccb, bool error)
 {
  uint8_t id, lun;
@@ -857,7 +1294,7 @@ static void arcmsr_report_ccb_state(stru
  acb->devstate[id][lun] = ARECA_RAID_GOOD;
  ccb->pcmd->result = DID_OK << 16;
  arcmsr_ccb_complete(ccb);
- }else{
+ } else {
  switch (ccb->arcmsr_cdb.DeviceStatus) {
  case ARCMSR_DEV_SELECT_TIMEOUT: {
  acb->devstate[id][lun] = ARECA_RAID_GONE;
@@ -883,53 +1320,45 @@ static void arcmsr_report_ccb_state(stru
  break;

  default:
- printk(KERN_NOTICE
- "arcmsr%d: scsi id = %d lun = %d isr get command error done, \
- but got unknown DeviceStatus = 0x%x \n"
- , acb->host->host_no
- , id
- , lun
+ pr_notice("arcmsr%d: scsi id = %d lun = %d "
+ "isr get command error done, but got unknown "
+ "DeviceStatus = 0x%x\n"
+ , acb->host->host_no, id, lun
  , ccb->arcmsr_cdb.DeviceStatus);
- acb->devstate[id][lun] = ARECA_RAID_GONE;
- ccb->pcmd->result = DID_NO_CONNECT << 16;
- arcmsr_ccb_complete(ccb);
+ acb->devstate[id][lun] = ARECA_RAID_GONE;
+ ccb->pcmd->result = DID_NO_CONNECT << 16;
+ arcmsr_ccb_complete(ccb);
  break;
  }
  }
 }

-static void arcmsr_drain_donequeue(struct AdapterControlBlock *acb,
struct CommandControlBlock *pCCB, bool error)
+static void
+arcmsr_drain_donequeue(struct AdapterControlBlock *acb,
+ struct CommandControlBlock *pCCB, bool error)
 {
- int id, lun;
  if ((pCCB->acb != acb) || (pCCB->startdone != ARCMSR_CCB_START)) {
- if (pCCB->startdone == ARCMSR_CCB_ABORTED) {
- struct scsi_cmnd *abortcmd = pCCB->pcmd;
- if (abortcmd) {
- id = abortcmd->device->id;
- lun = abortcmd->device->lun;
- abortcmd->result |= DID_ABORT << 16;
- arcmsr_ccb_complete(pCCB);
- printk(KERN_NOTICE "arcmsr%d: pCCB ='0x%p' isr got aborted command \n",
- acb->host->host_no, pCCB);
- }
- return;
- }
- printk(KERN_NOTICE "arcmsr%d: isr get an illegal ccb command \
- done acb = '0x%p'"
- "ccb = '0x%p' ccbacb = '0x%p' startdone = 0x%x"
- " ccboutstandingcount = %d \n"
- , acb->host->host_no
- , acb
- , pCCB
- , pCCB->acb
- , pCCB->startdone
- , atomic_read(&acb->ccboutstandingcount));
-  return;
+ pr_notice("arcmsr%d: isr get an illegal ccb "
+ "command done acb = 0x%p, "
+ "ccb = 0x%p, "
+ "ccbacb = 0x%p, "
+ "startdone = 0x%x, "
+ "pscsi_cmd = 0x%p, "
+ "ccboutstandingcount = %d\n"
+ , acb->host->host_no
+ , acb
+ , pCCB
+ , pCCB->acb
+ , pCCB->startdone
+ , pCCB->pcmd
+ , atomic_read(&acb->ccboutstandingcount));
+ return;
  }
  arcmsr_report_ccb_state(acb, pCCB, error);
 }

-static void arcmsr_done4abort_postqueue(struct AdapterControlBlock *acb)
+static void
+arcmsr_done4abort_postqueue(struct AdapterControlBlock *acb)
 {
  int i = 0;
  uint32_t flag_ccb;
@@ -944,27 +1373,36 @@ static void arcmsr_done4abort_postqueue(
  outbound_intstatus = readl(&reg->outbound_intstatus) &
  acb->outbound_int_enable;
  /*clear and abort all outbound posted Q*/
- writel(outbound_intstatus, &reg->outbound_intstatus);/*clear interrupt*/
- while(((flag_ccb = readl(&reg->outbound_queueport)) != 0xFFFFFFFF)
- && (i++ < ARCMSR_MAX_OUTSTANDING_CMD)) {
- pARCMSR_CDB = (struct ARCMSR_CDB *)(acb->vir2phy_offset + (flag_ccb
<< 5));/*frame must be 32 bytes aligned*/
- pCCB = container_of(pARCMSR_CDB, struct CommandControlBlock, arcmsr_cdb);
- error = (flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR_MODE0) ? true : false;
+ writel(outbound_intstatus, &reg->outbound_intstatus);
+ while (((flag_ccb = readl(&reg->outbound_queueport))
+ != 0xFFFFFFFF)
+ && (i++ < ARCMSR_MAX_OUTSTANDING_CMD)) {
+ pARCMSR_CDB = (struct ARCMSR_CDB *)
+ (acb->vir2phy_offset + (flag_ccb << 5));
+ pCCB = container_of(pARCMSR_CDB,
+ struct CommandControlBlock, arcmsr_cdb);
+ error = (flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR_MODE0) ?
+ true : false;
  arcmsr_drain_donequeue(acb, pCCB, error);
  }
  }
  break;

  case ACB_ADAPTER_TYPE_B: {
- struct MessageUnit_B *reg = acb->pmuB;
- /*clear all outbound posted Q*/
- writel(ARCMSR_DOORBELL_INT_CLEAR_PATTERN, reg->iop2drv_doorbell); /*
clear doorbell interrupt */
+ struct MessageUnit_B __iomem *reg = acb->pmuB;
+ writel(ARCMSR_DOORBELL_INT_CLEAR_PATTERN,
+ reg->iop2drv_doorbell);
  for (i = 0; i < ARCMSR_MAX_HBB_POSTQUEUE; i++) {
- if ((flag_ccb = readl(&reg->done_qbuffer[i])) != 0) {
+ flag_ccb = readl(&reg->done_qbuffer[i]);
+ if (flag_ccb != 0) {
  writel(0, &reg->done_qbuffer[i]);
- pARCMSR_CDB = (struct ARCMSR_CDB *)(acb->vir2phy_offset+(flag_ccb <<
5));/*frame must be 32 bytes aligned*/
- pCCB = container_of(pARCMSR_CDB, struct CommandControlBlock, arcmsr_cdb);
- error = (flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR_MODE0) ? true : false;
+ pARCMSR_CDB = (struct ARCMSR_CDB *)
+ (acb->vir2phy_offset + (flag_ccb << 5));
+ pCCB = container_of(pARCMSR_CDB,
+ struct CommandControlBlock, arcmsr_cdb);
+ error = (flag_ccb &
+ ARCMSR_CCBREPLY_FLAG_ERROR_MODE0) ?
+ true : false;
  arcmsr_drain_donequeue(acb, pCCB, error);
  }
  reg->post_qbuffer[i] = 0;
@@ -974,29 +1412,87 @@ static void arcmsr_done4abort_postqueue(
  }
  break;
  case ACB_ADAPTER_TYPE_C: {
- struct MessageUnit_C *reg = acb->pmuC;
+ struct MessageUnit_C __iomem *reg = acb->pmuC;
  struct  ARCMSR_CDB *pARCMSR_CDB;
  uint32_t flag_ccb, ccb_cdb_phy;
  bool error;
  struct CommandControlBlock *pCCB;
- while ((readl(&reg->host_int_status) &
ARCMSR_HBCMU_OUTBOUND_POSTQUEUE_ISR) && (i++ <
ARCMSR_MAX_OUTSTANDING_CMD)) {
+ while ((readl(&reg->host_int_status) &
+ ARCMSR_HBCMU_OUTBOUND_POSTQUEUE_ISR)
+ && (i++ < ARCMSR_MAX_OUTSTANDING_CMD)) {
  /*need to do*/
  flag_ccb = readl(&reg->outbound_queueport_low);
  ccb_cdb_phy = (flag_ccb & 0xFFFFFFF0);
- pARCMSR_CDB = (struct  ARCMSR_CDB
*)(acb->vir2phy_offset+ccb_cdb_phy);/*frame must be 32 bytes aligned*/
- pCCB = container_of(pARCMSR_CDB, struct CommandControlBlock, arcmsr_cdb);
- error = (flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR_MODE1) ? true : false;
+ pARCMSR_CDB = (struct  ARCMSR_CDB *)
+ (acb->vir2phy_offset+ccb_cdb_phy);
+ pCCB = container_of(pARCMSR_CDB,
+ struct CommandControlBlock, arcmsr_cdb);
+ error = (flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR_MODE1)
+ ? true : false;
  arcmsr_drain_donequeue(acb, pCCB, error);
  }
+ }
+ break;
+ case ACB_ADAPTER_TYPE_D: {
+ struct MessageUnit_D __iomem *pmu = acb->pmuD;
+ uint32_t ccb_cdb_phy, outbound_write_pointer;
+ uint32_t doneq_index, index_stripped, addressLow, residual;
+ bool error;
+ struct CommandControlBlock *pCCB;
+ outbound_write_pointer = pmu->done_qbuffer[0].addressLow + 1;
+ doneq_index = pmu->doneq_index;
+ residual = atomic_read(&acb->ccboutstandingcount);
+ for (i = 0; i < residual; i++) {
+ while ((doneq_index & 0xFFF) != (outbound_write_pointer & 0xFFF)) {
+ if (doneq_index & 0x4000) {
+ index_stripped = doneq_index & 0xFFF;
+ index_stripped += 1;
+ index_stripped %=
+ ARCMSR_MAX_ARC1214_DONEQUEUE;
+ pmu->doneq_index = index_stripped ?
+ (index_stripped | 0x4000) : (index_stripped + 1);
+ } else {
+ index_stripped = doneq_index;
+ index_stripped += 1;
+ index_stripped %=
+ ARCMSR_MAX_ARC1214_DONEQUEUE;
+ pmu->doneq_index =
+ index_stripped ? index_stripped : ((index_stripped | 0x4000) + 1);
+ }
+ doneq_index = pmu->doneq_index;
+ addressLow =
+ pmu->done_qbuffer[doneq_index & 0xFFF].addressLow;
+ ccb_cdb_phy = (addressLow & 0xFFFFFFF0);
+ pARCMSR_CDB = (struct  ARCMSR_CDB *)
+ (acb->vir2phy_offset + ccb_cdb_phy);
+ pCCB = container_of(pARCMSR_CDB,
+ struct CommandControlBlock, arcmsr_cdb);
+ error =
+ (addressLow & ARCMSR_CCBREPLY_FLAG_ERROR_MODE1)
+ ? true : false;
+ arcmsr_drain_donequeue(acb, pCCB, error);
+ writel(doneq_index,
+ pmu->outboundlist_read_pointer);
+ }
+ mdelay(10);
+ outbound_write_pointer =
+ pmu->done_qbuffer[0].addressLow + 1;
+ doneq_index = pmu->doneq_index;
+ }
+ pmu->postq_index = 0;
+ pmu->doneq_index = 0x40FF;
+ break;
  }
  }
 }
-static void arcmsr_remove(struct pci_dev *pdev)
+
+static void
+arcmsr_remove(struct pci_dev *pdev)
 {
  struct Scsi_Host *host = pci_get_drvdata(pdev);
  struct AdapterControlBlock *acb =
- (struct AdapterControlBlock *) host->hostdata;
- int poll_count = 0;
+ (struct AdapterControlBlock *)host->hostdata;
+ int poll_count = 0, i;
  arcmsr_free_sysfs_attr(acb);
  scsi_remove_host(host);
  flush_work(&acb->arcmsr_do_message_isr_bh);
@@ -1007,20 +1503,20 @@ static void arcmsr_remove(struct pci_dev
  acb->acb_flags |= ACB_F_SCSISTOPADAPTER;
  acb->acb_flags &= ~ACB_F_IOP_INITED;

- for (poll_count = 0; poll_count < ARCMSR_MAX_OUTSTANDING_CMD; poll_count++){
+ for (poll_count = 0; poll_count < ARCMSR_MAX_OUTSTANDING_CMD;
+ poll_count++) {
  if (!atomic_read(&acb->ccboutstandingcount))
  break;
- arcmsr_interrupt(acb);/* FIXME: need spinlock */
+ arcmsr_interrupt(acb);
  msleep(25);
  }

  if (atomic_read(&acb->ccboutstandingcount)) {
- int i;
-
  arcmsr_abort_allcmd(acb);
  arcmsr_done4abort_postqueue(acb);
  for (i = 0; i < ARCMSR_MAX_FREECCB_NUM; i++) {
- struct CommandControlBlock *ccb = acb->pccb_pool[i];
+ struct CommandControlBlock *ccb =
+ acb->pccb_pool[i];
  if (ccb->startdone == ARCMSR_CCB_START) {
  ccb->startdone = ARCMSR_CCB_ABORTED;
  ccb->pcmd->result = DID_ABORT << 16;
@@ -1028,9 +1524,17 @@ static void arcmsr_remove(struct pci_dev
  }
  }
  }
- free_irq(pdev->irq, acb);
  arcmsr_free_ccb_pool(acb);
- arcmsr_free_hbb_mu(acb);
+ arcmsr_free_mu(acb);
+ if (acb->acb_flags & ACB_F_MSI_ENABLED) {
+ free_irq(pdev->irq, acb);
+ pci_disable_msi(pdev);
+ } else if (acb->acb_flags & ACB_F_MSIX_ENABLED) {
+ for (i = 0; i < ARCMST_NUM_MSIX_VECTORS; i++)
+ free_irq(acb->entries[i].vector, acb);
+ pci_disable_msix(pdev);
+ } else
+ free_irq(pdev->irq, acb);
  arcmsr_unmap_pciregion(acb);
  pci_release_regions(pdev);
  scsi_host_put(host);
@@ -1038,13 +1542,21 @@ static void arcmsr_remove(struct pci_dev
  pci_set_drvdata(pdev, NULL);
 }

-static void arcmsr_shutdown(struct pci_dev *pdev)
+static void
+arcmsr_shutdown(struct pci_dev *pdev)
 {
+ int i;
  struct Scsi_Host *host = pci_get_drvdata(pdev);
  struct AdapterControlBlock *acb =
  (struct AdapterControlBlock *)host->hostdata;
  del_timer_sync(&acb->eternal_timer);
  arcmsr_disable_outbound_ints(acb);
+ if (acb->acb_flags & ACB_F_MSIX_ENABLED) {
+ for (i = 0; i < ARCMST_NUM_MSIX_VECTORS; i++)
+ free_irq(acb->entries[i].vector, acb);
+ pci_disable_msix(pdev);
+ } else
+ free_irq(pdev->irq, acb);
  flush_work(&acb->arcmsr_do_message_isr_bh);
  arcmsr_stop_adapter_bgrb(acb);
  arcmsr_flush_adapter_cache(acb);
@@ -1064,7 +1576,8 @@ static void arcmsr_module_exit(void)
 module_init(arcmsr_module_init);
 module_exit(arcmsr_module_exit);

-static void arcmsr_enable_outbound_ints(struct AdapterControlBlock *acb,
+static void
+arcmsr_enable_outbound_ints(struct AdapterControlBlock *acb,
  u32 intmask_org)
 {
  u32 mask;
@@ -1072,37 +1585,51 @@ static void arcmsr_enable_outbound_ints(

  case ACB_ADAPTER_TYPE_A: {
  struct MessageUnit_A __iomem *reg = acb->pmuA;
- mask = intmask_org & ~(ARCMSR_MU_OUTBOUND_POSTQUEUE_INTMASKENABLE |
-     ARCMSR_MU_OUTBOUND_DOORBELL_INTMASKENABLE|
-     ARCMSR_MU_OUTBOUND_MESSAGE0_INTMASKENABLE);
+ mask = intmask_org &
+ ~(ARCMSR_MU_OUTBOUND_POSTQUEUE_INTMASKENABLE |
+     ARCMSR_MU_OUTBOUND_DOORBELL_INTMASKENABLE |
+     ARCMSR_MU_OUTBOUND_MESSAGE0_INTMASKENABLE);
  writel(mask, &reg->outbound_intmask);
- acb->outbound_int_enable = ~(intmask_org & mask) & 0x000000ff;
- }
+ acb->outbound_int_enable = ~(intmask_org & mask) &
+ 0x000000ff;
  break;
-
+ }
  case ACB_ADAPTER_TYPE_B: {
- struct MessageUnit_B *reg = acb->pmuB;
+ struct MessageUnit_B __iomem *reg = acb->pmuB;
  mask = intmask_org | (ARCMSR_IOP2DRV_DATA_WRITE_OK |
  ARCMSR_IOP2DRV_DATA_READ_OK |
  ARCMSR_IOP2DRV_CDB_DONE |
  ARCMSR_IOP2DRV_MESSAGE_CMD_DONE);
  writel(mask, reg->iop2drv_doorbell_mask);
- acb->outbound_int_enable = (intmask_org | mask) & 0x0000000f;
- }
+ acb->outbound_int_enable = (intmask_org | mask) &
+ 0x0000000f;
  break;
+ }
  case ACB_ADAPTER_TYPE_C: {
- struct MessageUnit_C *reg = acb->pmuC;
- mask = ~(ARCMSR_HBCMU_UTILITY_A_ISR_MASK |
ARCMSR_HBCMU_OUTBOUND_DOORBELL_ISR_MASK|ARCMSR_HBCMU_OUTBOUND_POSTQUEUE_ISR_MASK);
+ struct MessageUnit_C __iomem *reg = acb->pmuC;
+ mask = ~(ARCMSR_HBCMU_UTILITY_A_ISR_MASK |
+ ARCMSR_HBCMU_OUTBOUND_DOORBELL_ISR_MASK |
+ ARCMSR_HBCMU_OUTBOUND_POSTQUEUE_ISR_MASK);
  writel(intmask_org & mask, &reg->host_int_mask);
- acb->outbound_int_enable = ~(intmask_org & mask) & 0x0000000f;
+ acb->outbound_int_enable = ~(intmask_org & mask) &
+ 0x0000000f;
+ break;
  }
+ case ACB_ADAPTER_TYPE_D: {
+ struct MessageUnit_D __iomem *reg = acb->pmuD;
+ mask = ARCMSR_ARC1214_ALL_INT_ENABLE;
+ writel(intmask_org | mask, reg->pcief0_int_enable);
+ break;
+ }
  }
 }

-static int arcmsr_build_ccb(struct AdapterControlBlock *acb,
+static int
+arcmsr_build_ccb(struct AdapterControlBlock *acb,
  struct CommandControlBlock *ccb, struct scsi_cmnd *pcmd)
 {
- struct ARCMSR_CDB *arcmsr_cdb = (struct ARCMSR_CDB *)&ccb->arcmsr_cdb;
+ struct ARCMSR_CDB *arcmsr_cdb =
+ (struct ARCMSR_CDB *)&ccb->arcmsr_cdb;
  int8_t *psge = (int8_t *)&arcmsr_cdb->u;
  __le32 address_lo, address_hi;
  int arccdbsize = 0x30;
@@ -1115,8 +1642,7 @@ static int arcmsr_build_ccb(struct Adapt
  arcmsr_cdb->TargetID = pcmd->device->id;
  arcmsr_cdb->LUN = pcmd->device->lun;
  arcmsr_cdb->Function = 1;
- arcmsr_cdb->Context = 0;
- memcpy(arcmsr_cdb->Cdb, pcmd->cmnd, pcmd->cmd_len);
+ memcpy((void *)arcmsr_cdb->Cdb, (const void *)pcmd->cmnd, pcmd->cmd_len);

  nseg = scsi_dma_map(pcmd);
  if (unlikely(nseg > acb->host->sg_tablesize || nseg < 0))
@@ -1127,25 +1653,27 @@ static int arcmsr_build_ccb(struct Adapt
  address_lo = cpu_to_le32(dma_addr_lo32(sg_dma_address(sg)));
  address_hi = cpu_to_le32(dma_addr_hi32(sg_dma_address(sg)));
  if (address_hi == 0) {
- struct SG32ENTRY *pdma_sg = (struct SG32ENTRY *)psge;
-
+ struct SG32ENTRY *pdma_sg =
+ (struct SG32ENTRY *)psge;
  pdma_sg->address = address_lo;
  pdma_sg->length = length;
  psge += sizeof (struct SG32ENTRY);
  arccdbsize += sizeof (struct SG32ENTRY);
  } else {
- struct SG64ENTRY *pdma_sg = (struct SG64ENTRY *)psge;
-
+ struct SG64ENTRY *pdma_sg =
+ (struct SG64ENTRY *)psge;
  pdma_sg->addresshigh = address_hi;
  pdma_sg->address = address_lo;
- pdma_sg->length = length|cpu_to_le32(IS_SG64_ADDR);
+ pdma_sg->length = length |
+ cpu_to_le32(IS_SG64_ADDR);
  psge += sizeof (struct SG64ENTRY);
  arccdbsize += sizeof (struct SG64ENTRY);
  }
  }
  arcmsr_cdb->sgcount = (uint8_t)nseg;
  arcmsr_cdb->DataLength = scsi_bufflen(pcmd);
- arcmsr_cdb->msgPages = arccdbsize/0x100 + (arccdbsize % 0x100 ? 1 : 0);
+ arcmsr_cdb->msgPages = arccdbsize / 0x100 +
+ (arccdbsize % 0x100 ? 1 : 0);
  if ( arccdbsize > 256)
  arcmsr_cdb->Flags |= ARCMSR_CDB_FLAG_SGL_BSIZE;
  if (pcmd->sc_data_direction == DMA_TO_DEVICE)
@@ -1154,10 +1682,14 @@ static int arcmsr_build_ccb(struct Adapt
  return SUCCESS;
 }

-static void arcmsr_post_ccb(struct AdapterControlBlock *acb, struct
CommandControlBlock *ccb)
-{
- uint32_t cdb_phyaddr_pattern = ccb->cdb_phyaddr_pattern;
- struct ARCMSR_CDB *arcmsr_cdb = (struct ARCMSR_CDB *)&ccb->arcmsr_cdb;
+static void
+arcmsr_post_ccb(struct AdapterControlBlock *acb,
+ struct CommandControlBlock *ccb)
+{
+ uint32_t cdb_phyaddr = ccb->cdb_phyaddr;
+ struct ARCMSR_CDB *arcmsr_cdb =
+ (struct ARCMSR_CDB *)&ccb->arcmsr_cdb;
+ u32 arccdbsize = ccb->arc_cdb_size;
  atomic_inc(&acb->ccboutstandingcount);
  ccb->startdone = ARCMSR_CCB_START;
  switch (acb->adapter_type) {
@@ -1165,131 +1697,203 @@ static void arcmsr_post_ccb(struct Adapt
  struct MessageUnit_A __iomem *reg = acb->pmuA;

  if (arcmsr_cdb->Flags & ARCMSR_CDB_FLAG_SGL_BSIZE)
- writel(cdb_phyaddr_pattern | ARCMSR_CCBPOST_FLAG_SGL_BSIZE,
- &reg->inbound_queueport);
- else {
- writel(cdb_phyaddr_pattern, &reg->inbound_queueport);
- }
+ writel(cdb_phyaddr |
+ ARCMSR_CCBPOST_FLAG_SGL_BSIZE,
+ &reg->inbound_queueport);
+ else
+ writel(cdb_phyaddr, &reg->inbound_queueport);
  }
  break;

  case ACB_ADAPTER_TYPE_B: {
- struct MessageUnit_B *reg = acb->pmuB;
+ struct MessageUnit_B __iomem *reg = acb->pmuB;
  uint32_t ending_index, index = reg->postq_index;

- ending_index = ((index + 1) % ARCMSR_MAX_HBB_POSTQUEUE);
+ ending_index = ((index + 1) %
+ ARCMSR_MAX_HBB_POSTQUEUE);
  writel(0, &reg->post_qbuffer[ending_index]);
  if (arcmsr_cdb->Flags & ARCMSR_CDB_FLAG_SGL_BSIZE) {
- writel(cdb_phyaddr_pattern | ARCMSR_CCBPOST_FLAG_SGL_BSIZE,\
- &reg->post_qbuffer[index]);
- } else {
- writel(cdb_phyaddr_pattern, &reg->post_qbuffer[index]);
- }
+ writel(cdb_phyaddr |
+ ARCMSR_CCBPOST_FLAG_SGL_BSIZE,
+ &reg->post_qbuffer[index]);
+ } else
+ writel(cdb_phyaddr, &reg->post_qbuffer[index]);
  index++;
- index %= ARCMSR_MAX_HBB_POSTQUEUE;/*if last index number set it to 0 */
+ index %= ARCMSR_MAX_HBB_POSTQUEUE;
  reg->postq_index = index;
- writel(ARCMSR_DRV2IOP_CDB_POSTED, reg->drv2iop_doorbell);
+ writel(ARCMSR_DRV2IOP_CDB_POSTED,
+ reg->drv2iop_doorbell);
  }
  break;
  case ACB_ADAPTER_TYPE_C: {
- struct MessageUnit_C *phbcmu = (struct MessageUnit_C *)acb->pmuC;
+ struct MessageUnit_C __iomem *phbcmu = acb->pmuC;
  uint32_t ccb_post_stamp, arc_cdb_size;

- arc_cdb_size = (ccb->arc_cdb_size > 0x300) ? 0x300 : ccb->arc_cdb_size;
- ccb_post_stamp = (cdb_phyaddr_pattern | ((arc_cdb_size - 1) >> 6) | 1);
+ arc_cdb_size = (ccb->arc_cdb_size > 0x300)
+ ? 0x300 : ccb->arc_cdb_size;
+ ccb_post_stamp = (cdb_phyaddr |
+ ((arc_cdb_size - 1) >> 6) | 1);
  if (acb->cdb_phyaddr_hi32) {
- writel(acb->cdb_phyaddr_hi32, &phbcmu->inbound_queueport_high);
- writel(ccb_post_stamp, &phbcmu->inbound_queueport_low);
+ writel(acb->cdb_phyaddr_hi32,
+ &phbcmu->inbound_queueport_high);
+ writel(ccb_post_stamp,
+ &phbcmu->inbound_queueport_low);
+ } else
+ writel(ccb_post_stamp,
+ &phbcmu->inbound_queueport_low);
+ }
+ break;
+ case ACB_ADAPTER_TYPE_D: {
+ struct MessageUnit_D __iomem *pmu = acb->pmuD;
+ u16 index_stripped;
+ u16 postq_index;
+ unsigned long flags;
+ struct InBound_SRB *pinbound_srb;
+ spin_lock_irqsave(&acb->postq_lock, flags);
+ postq_index = pmu->postq_index;
+ pinbound_srb = (struct InBound_SRB *)&pmu->post_qbuffer[postq_index & 0xFF];
+ pinbound_srb->addressHigh = dma_addr_hi32(cdb_phyaddr);
+ pinbound_srb->addressLow = dma_addr_lo32(cdb_phyaddr);
+ pinbound_srb->length = arccdbsize >> 2;
+ arcmsr_cdb->msgContext = dma_addr_lo32(cdb_phyaddr);
+ if (postq_index & 0x4000) {
+ index_stripped = postq_index & 0xFF;
+ index_stripped += 1;
+ index_stripped %= ARCMSR_MAX_ARC1214_POSTQUEUE;
+ pmu->postq_index = index_stripped ? (index_stripped | 0x4000) :
index_stripped;
  } else {
- writel(ccb_post_stamp, &phbcmu->inbound_queueport_low);
- }
+ index_stripped = postq_index;
+ index_stripped += 1;
+ index_stripped %= ARCMSR_MAX_ARC1214_POSTQUEUE;
+ pmu->postq_index = index_stripped ? index_stripped : (index_stripped
| 0x4000);
  }
+ writel(postq_index, pmu->inboundlist_write_pointer);
+ spin_unlock_irqrestore(&acb->postq_lock, flags);
+ break;
+ }
  }
 }

-static void arcmsr_stop_hba_bgrb(struct AdapterControlBlock *acb)
+static void arcmsr_hbaA_stop_bgrb(struct AdapterControlBlock *acb)
 {
  struct MessageUnit_A __iomem *reg = acb->pmuA;
  acb->acb_flags &= ~ACB_F_MSG_START_BGRB;
  writel(ARCMSR_INBOUND_MESG0_STOP_BGRB, &reg->inbound_msgaddr0);
- if (!arcmsr_hba_wait_msgint_ready(acb)) {
- printk(KERN_NOTICE
- "arcmsr%d: wait 'stop adapter background rebulid' timeout \n"
+ if (!arcmsr_hbaA_wait_msgint_ready(acb))
+ pr_notice("arcmsr%d: wait 'stop adapter background rebulid' timeout\n"
  , acb->host->host_no);
- }
 }

-static void arcmsr_stop_hbb_bgrb(struct AdapterControlBlock *acb)
+static void
+arcmsr_hbaB_stop_bgrb(struct AdapterControlBlock *acb)
 {
- struct MessageUnit_B *reg = acb->pmuB;
+ struct MessageUnit_B __iomem *reg = acb->pmuB;
  acb->acb_flags &= ~ACB_F_MSG_START_BGRB;
  writel(ARCMSR_MESSAGE_STOP_BGRB, reg->drv2iop_doorbell);

- if (!arcmsr_hbb_wait_msgint_ready(acb)) {
- printk(KERN_NOTICE
- "arcmsr%d: wait 'stop adapter background rebulid' timeout \n"
+ if (!arcmsr_hbaB_wait_msgint_ready(acb))
+ pr_notice("arcmsr%d: wait 'stop adapter background rebulid' timeout\n"
  , acb->host->host_no);
- }
 }

-static void arcmsr_stop_hbc_bgrb(struct AdapterControlBlock *pACB)
+static void
+arcmsr_hbaC_stop_bgrb(struct AdapterControlBlock *pACB)
 {
- struct MessageUnit_C *reg = (struct MessageUnit_C *)pACB->pmuC;
+ struct MessageUnit_C __iomem *reg = pACB->pmuC;
  pACB->acb_flags &= ~ACB_F_MSG_START_BGRB;
  writel(ARCMSR_INBOUND_MESG0_STOP_BGRB, &reg->inbound_msgaddr0);
- writel(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE, &reg->inbound_doorbell);
- if (!arcmsr_hbc_wait_msgint_ready(pACB)) {
- printk(KERN_NOTICE
- "arcmsr%d: wait 'stop adapter background rebulid' timeout \n"
+ writel(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE,
+ &reg->inbound_doorbell);
+ if (!arcmsr_hbaC_wait_msgint_ready(pACB))
+ pr_notice("arcmsr%d: wait 'stop adapter background rebulid' timeout\n"
  , pACB->host->host_no);
- }
- return;
 }
-static void arcmsr_stop_adapter_bgrb(struct AdapterControlBlock *acb)
+
+static void
+arcmsr_hbaD_stop_bgrb(struct AdapterControlBlock *pACB)
+{
+ struct MessageUnit_D __iomem *reg = pACB->pmuD;
+
+ pACB->acb_flags &= ~ACB_F_MSG_START_BGRB;
+ writel(ARCMSR_INBOUND_MESG0_STOP_BGRB,
+ reg->inbound_msgaddr0);
+ if (!arcmsr_hbaD_wait_msgint_ready(pACB))
+ pr_notice("arcmsr%d: wait 'stop adapter background rebulid' timeout\n"
+ , pACB->host->host_no);
+}
+
+static void
+arcmsr_stop_adapter_bgrb(struct AdapterControlBlock *acb)
 {
  switch (acb->adapter_type) {
  case ACB_ADAPTER_TYPE_A: {
- arcmsr_stop_hba_bgrb(acb);
- }
+ arcmsr_hbaA_stop_bgrb(acb);
  break;
-
+ }
  case ACB_ADAPTER_TYPE_B: {
- arcmsr_stop_hbb_bgrb(acb);
- }
+ arcmsr_hbaB_stop_bgrb(acb);
  break;
+ }
  case ACB_ADAPTER_TYPE_C: {
- arcmsr_stop_hbc_bgrb(acb);
- }
+ arcmsr_hbaC_stop_bgrb(acb);
+ break;
+ }
+ case ACB_ADAPTER_TYPE_D: {
+ arcmsr_hbaD_stop_bgrb(acb);
+ break;
+ }
  }
 }

-static void arcmsr_free_ccb_pool(struct AdapterControlBlock *acb)
+static void
+arcmsr_free_ccb_pool(struct AdapterControlBlock *acb)
 {
- dma_free_coherent(&acb->pdev->dev, acb->uncache_size,
acb->dma_coherent, acb->dma_coherent_handle);
+ switch (acb->adapter_type) {
+ case ACB_ADAPTER_TYPE_A:
+ case ACB_ADAPTER_TYPE_C:
+ case ACB_ADAPTER_TYPE_B:
+ case ACB_ADAPTER_TYPE_D:
+ dma_free_coherent(&acb->pdev->dev, acb->uncache_size,
+ acb->dma_coherent, acb->dma_coherent_handle);
+ break;
+ }
 }

-void arcmsr_iop_message_read(struct AdapterControlBlock *acb)
+void
+arcmsr_iop_message_read(struct AdapterControlBlock *acb)
 {
  switch (acb->adapter_type) {
  case ACB_ADAPTER_TYPE_A: {
  struct MessageUnit_A __iomem *reg = acb->pmuA;
- writel(ARCMSR_INBOUND_DRIVER_DATA_READ_OK, &reg->inbound_doorbell);
+ writel(ARCMSR_INBOUND_DRIVER_DATA_READ_OK,
+ &reg->inbound_doorbell);
  }
  break;

  case ACB_ADAPTER_TYPE_B: {
- struct MessageUnit_B *reg = acb->pmuB;
- writel(ARCMSR_DRV2IOP_DATA_READ_OK, reg->drv2iop_doorbell);
+ struct MessageUnit_B __iomem *reg = acb->pmuB;
+ writel(ARCMSR_DRV2IOP_DATA_READ_OK,
+ reg->drv2iop_doorbell);
  }
  break;
  case ACB_ADAPTER_TYPE_C: {
  struct MessageUnit_C __iomem *reg = acb->pmuC;
  writel(ARCMSR_HBCMU_DRV2IOP_DATA_READ_OK, &reg->inbound_doorbell);
+ /*readl(&reg->inbound_doorbell);*/
  }
+ break;
+ case ACB_ADAPTER_TYPE_D: {
+ struct MessageUnit_D __iomem *reg = acb->pmuD;
+ writel(ARCMSR_ARC1214_DRV2IOP_DATA_OUT_READ,
+ reg->inbound_doorbell);
+ /*readl(reg->inbound_doorbell);*/
+ break;
+ }
  }
 }

-static void arcmsr_iop_message_wrote(struct AdapterControlBlock *acb)
+static void
+arcmsr_iop_message_wrote(struct AdapterControlBlock *acb)
 {
  switch (acb->adapter_type) {
  case ACB_ADAPTER_TYPE_A: {
@@ -1298,17 +1902,19 @@ static void arcmsr_iop_message_wrote(str
  ** push inbound doorbell tell iop, driver data write ok
  ** and wait reply on next hwinterrupt for next Qbuffer post
  */
- writel(ARCMSR_INBOUND_DRIVER_DATA_WRITE_OK, &reg->inbound_doorbell);
+ writel(ARCMSR_INBOUND_DRIVER_DATA_WRITE_OK,
+ &reg->inbound_doorbell);
  }
  break;

  case ACB_ADAPTER_TYPE_B: {
- struct MessageUnit_B *reg = acb->pmuB;
+ struct MessageUnit_B __iomem *reg = acb->pmuB;
  /*
  ** push inbound doorbell tell iop, driver data write ok
  ** and wait reply on next hwinterrupt for next Qbuffer post
  */
- writel(ARCMSR_DRV2IOP_DATA_WRITE_OK, reg->drv2iop_doorbell);
+ writel(ARCMSR_DRV2IOP_DATA_WRITE_OK,
+ reg->drv2iop_doorbell);
  }
  break;
  case ACB_ADAPTER_TYPE_C: {
@@ -1317,13 +1923,21 @@ static void arcmsr_iop_message_wrote(str
  ** push inbound doorbell tell iop, driver data write ok
  ** and wait reply on next hwinterrupt for next Qbuffer post
  */
- writel(ARCMSR_HBCMU_DRV2IOP_DATA_WRITE_OK, &reg->inbound_doorbell);
+ writel(ARCMSR_HBCMU_DRV2IOP_DATA_WRITE_OK,
+ &reg->inbound_doorbell);
  }
  break;
+ case ACB_ADAPTER_TYPE_D: {
+ struct MessageUnit_D __iomem *reg = acb->pmuD;
+ writel(ARCMSR_ARC1214_DRV2IOP_DATA_IN_READY,
+ reg->inbound_doorbell);
+ break;
+ }
  }
 }

-struct QBUFFER __iomem *arcmsr_get_iop_rqbuffer(struct
AdapterControlBlock *acb)
+struct QBUFFER __iomem
+*arcmsr_get_iop_rqbuffer(struct AdapterControlBlock *acb)
 {
  struct QBUFFER __iomem *qbuffer = NULL;
  switch (acb->adapter_type) {
@@ -1335,146 +1949,294 @@ struct QBUFFER __iomem *arcmsr_get_iop_r
  break;

  case ACB_ADAPTER_TYPE_B: {
- struct MessageUnit_B *reg = acb->pmuB;
+ struct MessageUnit_B __iomem *reg = acb->pmuB;
  qbuffer = (struct QBUFFER __iomem *)reg->message_rbuffer;
  }
  break;
  case ACB_ADAPTER_TYPE_C: {
- struct MessageUnit_C *phbcmu = (struct MessageUnit_C *)acb->pmuC;
- qbuffer = (struct QBUFFER __iomem *)&phbcmu->message_rbuffer;
+ struct MessageUnit_C __iomem *reg = acb->pmuC;
+ qbuffer = (struct QBUFFER __iomem *)&reg->message_rbuffer;
  }
+ break;
+ case ACB_ADAPTER_TYPE_D: {
+ struct MessageUnit_D __iomem *reg = acb->pmuD;
+ qbuffer = (struct QBUFFER __iomem *)reg->message_rbuffer;
+ break;
+ }
  }
  return qbuffer;
 }

-static struct QBUFFER __iomem *arcmsr_get_iop_wqbuffer(struct
AdapterControlBlock *acb)
+struct QBUFFER __iomem
+*arcmsr_get_iop_wqbuffer(struct AdapterControlBlock *acb)
 {
  struct QBUFFER __iomem *pqbuffer = NULL;
  switch (acb->adapter_type) {

  case ACB_ADAPTER_TYPE_A: {
  struct MessageUnit_A __iomem *reg = acb->pmuA;
- pqbuffer = (struct QBUFFER __iomem *) &reg->message_wbuffer;
+ pqbuffer = (struct QBUFFER __iomem *)&reg->message_wbuffer;
  }
  break;

  case ACB_ADAPTER_TYPE_B: {
- struct MessageUnit_B  *reg = acb->pmuB;
+ struct MessageUnit_B  __iomem *reg = acb->pmuB;
  pqbuffer = (struct QBUFFER __iomem *)reg->message_wbuffer;
  }
  break;
  case ACB_ADAPTER_TYPE_C: {
- struct MessageUnit_C *reg = (struct MessageUnit_C *)acb->pmuC;
+ struct MessageUnit_C __iomem *reg = acb->pmuC;
  pqbuffer = (struct QBUFFER __iomem *)&reg->message_wbuffer;
+ }
+ break;
+ case ACB_ADAPTER_TYPE_D: {
+ struct MessageUnit_D __iomem *reg = acb->pmuD;
+ pqbuffer = (struct QBUFFER __iomem *)reg->message_wbuffer;
+ break;
  }
-
  }
  return pqbuffer;
 }

-static void arcmsr_iop2drv_data_wrote_handle(struct AdapterControlBlock *acb)
-{
- struct QBUFFER __iomem *prbuffer;
- struct QBUFFER *pQbuffer;
+static uint32_t
+arcmsr_Read_iop_rqbuffer_in_DWORD(struct AdapterControlBlock *acb,
+ struct QBUFFER __iomem *prbuffer) {
+
+ uint8_t *pQbuffer;
+ uint8_t *buf1 = 0;
+ uint32_t __iomem *iop_data;
+ uint32_t iop_len, data_len, *buf2 = 0;
+
+ iop_data = (uint32_t *)prbuffer->data;
+ iop_len = readl(&prbuffer->data_len);
+ if (iop_len > 0) {
+ buf1 = (uint8_t *)kmalloc(128, GFP_ATOMIC);
+ buf2 = (uint32_t *)buf1;
+ if (buf1 == NULL)
+ return 0;
+ data_len = iop_len;
+ while (data_len >= 4) {
+ *buf2++ = *iop_data++;
+ data_len -= 4;
+ }
+ if (data_len)
+ *buf2 = *iop_data;
+ buf2 = (uint32_t *)buf1;
+ }
+ while (iop_len > 0) {
+ pQbuffer = &acb->rqbuffer[acb->rqbuf_lastindex];
+ *pQbuffer = *buf1;
+ acb->rqbuf_lastindex++;
+ /* if last, index number set it to 0 */
+ acb->rqbuf_lastindex %= ARCMSR_MAX_QBUFFER;
+ buf1++;
+ iop_len--;
+ }
+ if (buf2)
+ kfree((const void *)buf2);
+ /* let IOP know data has been read */
+ arcmsr_iop_message_read(acb);
+ return 1;
+}
+
+uint32_t
+arcmsr_Read_iop_rqbuffer_data(struct AdapterControlBlock *acb,
+ struct QBUFFER __iomem *prbuffer) {
+
+ uint8_t *pQbuffer;
  uint8_t __iomem *iop_data;
- int32_t my_empty_len, iop_len, rqbuf_firstindex, rqbuf_lastindex;
- rqbuf_lastindex = acb->rqbuf_lastindex;
- rqbuf_firstindex = acb->rqbuf_firstindex;
- prbuffer = arcmsr_get_iop_rqbuffer(acb);
- iop_data = (uint8_t __iomem *)prbuffer->data;
- iop_len = prbuffer->data_len;
- my_empty_len = (rqbuf_firstindex - rqbuf_lastindex - 1) &
(ARCMSR_MAX_QBUFFER - 1);
-
- if (my_empty_len >= iop_len)
- {
- while (iop_len > 0) {
- pQbuffer = (struct QBUFFER *)&acb->rqbuffer[rqbuf_lastindex];
- memcpy(pQbuffer, iop_data, 1);
- rqbuf_lastindex++;
- rqbuf_lastindex %= ARCMSR_MAX_QBUFFER;
- iop_data++;
- iop_len--;
- }
- acb->rqbuf_lastindex = rqbuf_lastindex;
- arcmsr_iop_message_read(acb);
+ uint32_t iop_len;
+
+ if (acb->adapter_type & (ACB_ADAPTER_TYPE_C | ACB_ADAPTER_TYPE_D))
+ return arcmsr_Read_iop_rqbuffer_in_DWORD(acb, prbuffer);
+
+ iop_data = (uint8_t *)prbuffer->data;
+ iop_len = readl(&prbuffer->data_len);
+ while (iop_len > 0) {
+ pQbuffer = &acb->rqbuffer[acb->rqbuf_lastindex];
+ *pQbuffer = *iop_data;
+ acb->rqbuf_lastindex++;
+ acb->rqbuf_lastindex %= ARCMSR_MAX_QBUFFER;
+ iop_data++;
+ iop_len--;
  }
+ arcmsr_iop_message_read(acb);
+ return 1;
+}
+
+void
+arcmsr_iop2drv_data_wrote_handle(struct AdapterControlBlock *acb)
+{
+ unsigned long flags;
+ struct QBUFFER __iomem  *prbuffer;
+ int32_t buf_empty_len;

- else {
+ spin_lock_irqsave(&acb->rqbuffer_lock, flags);
+ prbuffer = arcmsr_get_iop_rqbuffer(acb);
+ buf_empty_len = (acb->rqbuf_lastindex - acb->rqbuf_firstindex - 1) &
+ (ARCMSR_MAX_QBUFFER - 1);
+ if (buf_empty_len >= prbuffer->data_len) {
+ if (arcmsr_Read_iop_rqbuffer_data(acb, prbuffer) == 0)
+ acb->acb_flags |= ACB_F_IOPDATA_OVERFLOW;
+ } else
  acb->acb_flags |= ACB_F_IOPDATA_OVERFLOW;
- }
+ spin_unlock_irqrestore(&acb->rqbuffer_lock, flags);
 }

-static void arcmsr_iop2drv_data_read_handle(struct AdapterControlBlock *acb)
+static void
+arcmsr_write_ioctldata2iop_in_DWORD(struct AdapterControlBlock *acb)
 {
- acb->acb_flags |= ACB_F_MESSAGE_WQBUFFER_READED;
- if (acb->wqbuf_firstindex != acb->wqbuf_lastindex) {
- uint8_t *pQbuffer;
- struct QBUFFER __iomem *pwbuffer;
- uint8_t __iomem *iop_data;
- int32_t allxfer_len = 0;
+ uint8_t *pQbuffer;
+ struct QBUFFER __iomem *pwbuffer;
+ uint8_t *buf1 = 0;
+ uint32_t __iomem *iop_data;
+ uint32_t allxfer_len = 0, data_len, *buf2 = 0;
+
+ if (acb->acb_flags & ACB_F_MESSAGE_WQBUFFER_READED) {
+ buf1 = (uint8_t *)kmalloc(128, GFP_ATOMIC);
+ buf2 = (uint32_t *)buf1;
+ if (buf1 == NULL)
+ return;

  acb->acb_flags &= (~ACB_F_MESSAGE_WQBUFFER_READED);
  pwbuffer = arcmsr_get_iop_wqbuffer(acb);
- iop_data = (uint8_t __iomem *)pwbuffer->data;
+ iop_data = (uint32_t *)pwbuffer->data;
+ while ((acb->wqbuf_firstindex != acb->wqbuf_lastindex)
+ && (allxfer_len < 124)) {
+ pQbuffer = &acb->wqbuffer[acb->wqbuf_firstindex];
+ *buf1 = *pQbuffer;
+ acb->wqbuf_firstindex++;
+ acb->wqbuf_firstindex %= ARCMSR_MAX_QBUFFER;
+ buf1++;
+ allxfer_len++;
+ }
+ data_len = allxfer_len;
+ buf1 = (uint8_t *)buf2;
+ while (data_len >= 4) {
+ *iop_data++ = *buf2++;
+ data_len -= 4;
+ }
+ if (data_len)
+ *iop_data = *buf2;
+ writel(allxfer_len, &pwbuffer->data_len);
+ kfree((const void *)buf1);
+ arcmsr_iop_message_wrote(acb);
+ }
+}

- while ((acb->wqbuf_firstindex != acb->wqbuf_lastindex) && \
- (allxfer_len < 124)) {
+void
+arcmsr_write_ioctldata2iop(struct AdapterControlBlock *acb)
+{
+ uint8_t *pQbuffer;
+ struct QBUFFER __iomem *pwbuffer;
+ uint8_t __iomem *iop_data;
+ int32_t allxfer_len = 0;
+
+ if (acb->adapter_type & (ACB_ADAPTER_TYPE_C | ACB_ADAPTER_TYPE_D)) {
+ arcmsr_write_ioctldata2iop_in_DWORD(acb);
+ return;
+ }
+ if (acb->acb_flags & ACB_F_MESSAGE_WQBUFFER_READED) {
+ acb->acb_flags &= (~ACB_F_MESSAGE_WQBUFFER_READED);
+ pwbuffer = arcmsr_get_iop_wqbuffer(acb);
+ iop_data = (uint8_t *)pwbuffer->data;
+ while ((acb->wqbuf_firstindex != acb->wqbuf_lastindex)
+ && (allxfer_len < 124)) {
  pQbuffer = &acb->wqbuffer[acb->wqbuf_firstindex];
- memcpy(iop_data, pQbuffer, 1);
+ *iop_data = *pQbuffer;
  acb->wqbuf_firstindex++;
  acb->wqbuf_firstindex %= ARCMSR_MAX_QBUFFER;
  iop_data++;
  allxfer_len++;
  }
- pwbuffer->data_len = allxfer_len;
-
+ writel(allxfer_len, &pwbuffer->data_len);
  arcmsr_iop_message_wrote(acb);
  }
+}
+
+void
+arcmsr_iop2drv_data_read_handle(struct AdapterControlBlock *acb)
+{
+ unsigned long flags;

- if (acb->wqbuf_firstindex == acb->wqbuf_lastindex) {
+ spin_lock_irqsave(&acb->wqbuffer_lock, flags);
+ acb->acb_flags |= ACB_F_MESSAGE_WQBUFFER_READED;
+ if (acb->wqbuf_firstindex != acb->wqbuf_lastindex)
+ arcmsr_write_ioctldata2iop(acb);
+ if (acb->wqbuf_firstindex == acb->wqbuf_lastindex)
  acb->acb_flags |= ACB_F_MESSAGE_WQBUFFER_CLEARED;
- }
+ spin_unlock_irqrestore(&acb->wqbuffer_lock, flags);
 }

-static void arcmsr_hba_doorbell_isr(struct AdapterControlBlock *acb)
+static void
+arcmsr_hbaA_doorbell_isr(struct AdapterControlBlock *acb)
 {
  uint32_t outbound_doorbell;
- struct MessageUnit_A __iomem *reg = acb->pmuA;
+ struct MessageUnit_A __iomem *reg  = acb->pmuA;
  outbound_doorbell = readl(&reg->outbound_doorbell);
- writel(outbound_doorbell, &reg->outbound_doorbell);
- if (outbound_doorbell & ARCMSR_OUTBOUND_IOP331_DATA_WRITE_OK) {
- arcmsr_iop2drv_data_wrote_handle(acb);
- }
-
- if (outbound_doorbell & ARCMSR_OUTBOUND_IOP331_DATA_READ_OK) {
- arcmsr_iop2drv_data_read_handle(acb);
- }
+ do {
+ writel(outbound_doorbell, &reg->outbound_doorbell);
+ if (outbound_doorbell &
+ ARCMSR_OUTBOUND_IOP331_DATA_WRITE_OK)
+ arcmsr_iop2drv_data_wrote_handle(acb);
+ if (outbound_doorbell &
+ ARCMSR_OUTBOUND_IOP331_DATA_READ_OK)
+ arcmsr_iop2drv_data_read_handle(acb);
+ outbound_doorbell = readl(&reg->outbound_doorbell);
+ } while (outbound_doorbell &
+ (ARCMSR_OUTBOUND_IOP331_DATA_WRITE_OK
+ | ARCMSR_OUTBOUND_IOP331_DATA_READ_OK));
 }
-static void arcmsr_hbc_doorbell_isr(struct AdapterControlBlock *pACB)
+static void
+arcmsr_hbaC_doorbell_isr(struct AdapterControlBlock *pACB)
 {
  uint32_t outbound_doorbell;
- struct MessageUnit_C *reg = (struct MessageUnit_C *)pACB->pmuC;
- /*
- *******************************************************************
- **  Maybe here we need to check wrqbuffer_lock is lock or not
- **  DOORBELL: din! don!
- **  check if there are any mail need to pack from firmware
- *******************************************************************
- */
+ struct MessageUnit_C __iomem *reg = pACB->pmuC;
  outbound_doorbell = readl(&reg->outbound_doorbell);
- writel(outbound_doorbell, &reg->outbound_doorbell_clear);/*clear interrupt*/
- if (outbound_doorbell & ARCMSR_HBCMU_IOP2DRV_DATA_WRITE_OK) {
- arcmsr_iop2drv_data_wrote_handle(pACB);
- }
- if (outbound_doorbell & ARCMSR_HBCMU_IOP2DRV_DATA_READ_OK) {
- arcmsr_iop2drv_data_read_handle(pACB);
- }
- if (outbound_doorbell & ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE) {
- arcmsr_hbc_message_isr(pACB);    /* messenger of "driver to iop commands" */
- }
- return;
+ do {
+ if (outbound_doorbell &
+ ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE)
+ arcmsr_hbaC_message_isr(pACB);
+ writel(outbound_doorbell, &reg->outbound_doorbell_clear);
+ readl(&reg->outbound_doorbell_clear);
+ if (outbound_doorbell &
+ ARCMSR_HBCMU_IOP2DRV_DATA_WRITE_OK)
+ arcmsr_iop2drv_data_wrote_handle(pACB);
+ if (outbound_doorbell &
+ ARCMSR_HBCMU_IOP2DRV_DATA_READ_OK)
+ arcmsr_iop2drv_data_read_handle(pACB);
+ outbound_doorbell = readl(&reg->outbound_doorbell);
+ } while (outbound_doorbell & (ARCMSR_HBCMU_IOP2DRV_DATA_WRITE_OK
+ | ARCMSR_HBCMU_IOP2DRV_DATA_READ_OK
+ | ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE));
+}
+
+static void
+arcmsr_hbaD_doorbell_isr(struct AdapterControlBlock *pACB)
+{
+ uint32_t outbound_doorbell;
+ struct MessageUnit_D __iomem *pmu = pACB->pmuD;
+
+ outbound_doorbell = readl(pmu->outbound_doorbell);
+ do {
+ writel(outbound_doorbell, pmu->outbound_doorbell);
+ if (outbound_doorbell &
+ ARCMSR_ARC1214_IOP2DRV_MESSAGE_CMD_DONE)
+ arcmsr_hbaD_message_isr(pACB);
+ if (outbound_doorbell &
+ ARCMSR_ARC1214_IOP2DRV_DATA_WRITE_OK)
+ arcmsr_iop2drv_data_wrote_handle(pACB);
+ if (outbound_doorbell &
+ ARCMSR_ARC1214_IOP2DRV_DATA_READ_OK)
+ arcmsr_iop2drv_data_read_handle(pACB);
+ outbound_doorbell = readl(pmu->outbound_doorbell);
+ } while (outbound_doorbell & (ARCMSR_ARC1214_IOP2DRV_DATA_WRITE_OK
+ | ARCMSR_ARC1214_IOP2DRV_DATA_READ_OK
+ | ARCMSR_ARC1214_IOP2DRV_MESSAGE_CMD_DONE));
 }
-static void arcmsr_hba_postqueue_isr(struct AdapterControlBlock *acb)
+
+static void
+arcmsr_hbaA_postqueue_isr(struct AdapterControlBlock *acb)
 {
  uint32_t flag_ccb;
  struct MessageUnit_A __iomem *reg = acb->pmuA;
@@ -1482,26 +2244,34 @@ static void arcmsr_hba_postqueue_isr(str
  struct CommandControlBlock *pCCB;
  bool error;
  while ((flag_ccb = readl(&reg->outbound_queueport)) != 0xFFFFFFFF) {
- pARCMSR_CDB = (struct ARCMSR_CDB *)(acb->vir2phy_offset + (flag_ccb
<< 5));/*frame must be 32 bytes aligned*/
- pCCB = container_of(pARCMSR_CDB, struct CommandControlBlock, arcmsr_cdb);
- error = (flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR_MODE0) ? true : false;
+ pARCMSR_CDB = (struct ARCMSR_CDB *)
+ (acb->vir2phy_offset + (flag_ccb << 5));
+ pCCB = container_of(pARCMSR_CDB,
+ struct CommandControlBlock, arcmsr_cdb);
+ error = (flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR_MODE0)
+ ? true : false;
  arcmsr_drain_donequeue(acb, pCCB, error);
  }
 }
-static void arcmsr_hbb_postqueue_isr(struct AdapterControlBlock *acb)
+static void
+arcmsr_hbaB_postqueue_isr(struct AdapterControlBlock *acb)
 {
  uint32_t index;
  uint32_t flag_ccb;
- struct MessageUnit_B *reg = acb->pmuB;
+ struct MessageUnit_B __iomem *reg = acb->pmuB;
  struct ARCMSR_CDB *pARCMSR_CDB;
  struct CommandControlBlock *pCCB;
  bool error;
  index = reg->doneq_index;
  while ((flag_ccb = readl(&reg->done_qbuffer[index])) != 0) {
  writel(0, &reg->done_qbuffer[index]);
- pARCMSR_CDB = (struct ARCMSR_CDB *)(acb->vir2phy_offset+(flag_ccb <<
5));/*frame must be 32 bytes aligned*/
- pCCB = container_of(pARCMSR_CDB, struct CommandControlBlock, arcmsr_cdb);
- error = (flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR_MODE0) ? true : false;
+ pARCMSR_CDB = (struct ARCMSR_CDB *)
+ (acb->vir2phy_offset + (flag_ccb << 5));
+ pCCB = container_of(pARCMSR_CDB,
+ struct CommandControlBlock, arcmsr_cdb);
+ error = (flag_ccb &
+ ARCMSR_CCBREPLY_FLAG_ERROR_MODE0)
+ ? true : false;
  arcmsr_drain_donequeue(acb, pCCB, error);
  index++;
  index %= ARCMSR_MAX_HBB_POSTQUEUE;
@@ -1509,178 +2279,257 @@ static void arcmsr_hbb_postqueue_isr(str
  }
 }

-static void arcmsr_hbc_postqueue_isr(struct AdapterControlBlock *acb)
+static void
+arcmsr_hbaC_postqueue_isr(struct AdapterControlBlock *acb)
 {
- struct MessageUnit_C *phbcmu;
- struct ARCMSR_CDB *arcmsr_cdb;
- struct CommandControlBlock *ccb;
  uint32_t flag_ccb, ccb_cdb_phy, throttling = 0;
  int error;
+ struct MessageUnit_C __iomem *phbcmu;
+ struct ARCMSR_CDB *arcmsr_cdb;
+ struct CommandControlBlock *ccb;

- phbcmu = (struct MessageUnit_C *)acb->pmuC;
+ phbcmu = acb->pmuC;
  /* areca cdb command done */
  /* Use correct offset and size for syncing */
+ do {
+ /* check if command done with no error*/
+ flag_ccb = readl(&phbcmu->outbound_queueport_low);
+ ccb_cdb_phy = (flag_ccb & 0xFFFFFFF0);
+ arcmsr_cdb = (struct ARCMSR_CDB *)(acb->vir2phy_offset
+ + ccb_cdb_phy);
+ ccb = container_of(arcmsr_cdb, struct CommandControlBlock,
+ arcmsr_cdb);
+ error = (flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR_MODE1)
+ ? true : false;
+ /* check if command done with no error */
+ arcmsr_drain_donequeue(acb, ccb, error);
+ throttling++;
+ if (throttling == ARCMSR_HBC_ISR_THROTTLING_LEVEL) {
+ writel(ARCMSR_HBCMU_DRV2IOP_POSTQUEUE_THROTTLING,
+ &phbcmu->inbound_doorbell);
+ throttling = 0;
+ }
+ } while (readl(&phbcmu->host_int_status) &
+ ARCMSR_HBCMU_OUTBOUND_POSTQUEUE_ISR);
+}

- while (readl(&phbcmu->host_int_status) &
- ARCMSR_HBCMU_OUTBOUND_POSTQUEUE_ISR){
- /* check if command done with no error*/
- flag_ccb = readl(&phbcmu->outbound_queueport_low);
- ccb_cdb_phy = (flag_ccb & 0xFFFFFFF0);/*frame must be 32 bytes aligned*/
- arcmsr_cdb = (struct ARCMSR_CDB *)(acb->vir2phy_offset + ccb_cdb_phy);
- ccb = container_of(arcmsr_cdb, struct CommandControlBlock, arcmsr_cdb);
- error = (flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR_MODE1) ? true : false;
- /* check if command done with no error */
- arcmsr_drain_donequeue(acb, ccb, error);
- if (throttling == ARCMSR_HBC_ISR_THROTTLING_LEVEL) {
- writel(ARCMSR_HBCMU_DRV2IOP_POSTQUEUE_THROTTLING, &phbcmu->inbound_doorbell);
- break;
- }
- throttling++;
- }
+static void
+arcmsr_hbaD_postqueue_isr(struct AdapterControlBlock *acb)
+{
+ u32 outbound_write_pointer, doneq_index, index_stripped;
+ uint32_t addressLow, ccb_cdb_phy;
+ int error;
+ struct MessageUnit_D __iomem *pmu;
+ struct ARCMSR_CDB *arcmsr_cdb;
+ struct CommandControlBlock *ccb;
+ unsigned long flags;
+
+ spin_lock_irqsave(&acb->doneq_lock, flags);
+ pmu = acb->pmuD;
+ outbound_write_pointer = pmu->done_qbuffer[0].addressLow + 1;
+ doneq_index = pmu->doneq_index;
+ if ((doneq_index & 0xFFF) != (outbound_write_pointer & 0xFFF)) {
+ do {
+ if (doneq_index & 0x4000) {
+ index_stripped = doneq_index & 0xFFF;
+ index_stripped += 1;
+ index_stripped %= ARCMSR_MAX_ARC1214_DONEQUEUE;
+ pmu->doneq_index = index_stripped
+ ? (index_stripped | 0x4000) : (index_stripped + 1);
+ } else {
+ index_stripped = doneq_index;
+ index_stripped += 1;
+ index_stripped %= ARCMSR_MAX_ARC1214_DONEQUEUE;
+ pmu->doneq_index = index_stripped
+ ? index_stripped : ((index_stripped | 0x4000) + 1);
+ }
+ doneq_index = pmu->doneq_index;
+ addressLow =
+ pmu->done_qbuffer[doneq_index & 0xFFF].addressLow;
+ ccb_cdb_phy = (addressLow & 0xFFFFFFF0);
+ arcmsr_cdb = (struct ARCMSR_CDB *)(acb->vir2phy_offset
+ + ccb_cdb_phy);
+ ccb = container_of(arcmsr_cdb,
+ struct CommandControlBlock, arcmsr_cdb);
+ error = (addressLow & ARCMSR_CCBREPLY_FLAG_ERROR_MODE1)
+ ? true : false;
+ arcmsr_drain_donequeue(acb, ccb, error);
+ writel(doneq_index,
+ pmu->outboundlist_read_pointer);
+ } while ((doneq_index & 0xFFF) !=
+ (outbound_write_pointer & 0xFFF));
+ }
+ writel(ARCMSR_ARC1214_OUTBOUND_LIST_INTERRUPT_CLEAR,
+ pmu->outboundlist_interrupt_cause);
+ readl(pmu->outboundlist_interrupt_cause);
+ spin_unlock_irqrestore(&acb->doneq_lock, flags);
 }
-/*
-**********************************************************************************
-** Handle a message interrupt
-**
-** The only message interrupt we expect is in response to a query for
the current adapter config.
-** We want this in order to compare the drivemap so that we can
detect newly-attached drives.
-**********************************************************************************
-*/
-static void arcmsr_hba_message_isr(struct AdapterControlBlock *acb)
+
+static void
+arcmsr_hbaA_message_isr(struct AdapterControlBlock *acb)
 {
- struct MessageUnit_A *reg  = acb->pmuA;
+ struct MessageUnit_A __iomem *reg  = acb->pmuA;
  /*clear interrupt and message state*/
  writel(ARCMSR_MU_OUTBOUND_MESSAGE0_INT, &reg->outbound_intstatus);
  schedule_work(&acb->arcmsr_do_message_isr_bh);
 }
-static void arcmsr_hbb_message_isr(struct AdapterControlBlock *acb)
+static void
+arcmsr_hbaB_message_isr(struct AdapterControlBlock *acb)
 {
- struct MessageUnit_B *reg  = acb->pmuB;
+ struct MessageUnit_B __iomem *reg  = acb->pmuB;

  /*clear interrupt and message state*/
  writel(ARCMSR_MESSAGE_INT_CLEAR_PATTERN, reg->iop2drv_doorbell);
  schedule_work(&acb->arcmsr_do_message_isr_bh);
 }
-/*
-**********************************************************************************
-** Handle a message interrupt
-**
-** The only message interrupt we expect is in response to a query for the
-** current adapter config.
-** We want this in order to compare the drivemap so that we can
detect newly-attached drives.
-**********************************************************************************
-*/
-static void arcmsr_hbc_message_isr(struct AdapterControlBlock *acb)
+
+static void
+arcmsr_hbaC_message_isr(struct AdapterControlBlock *acb)
 {
- struct MessageUnit_C *reg  = acb->pmuC;
+ struct MessageUnit_C __iomem *reg  = acb->pmuC;
  /*clear interrupt and message state*/
- writel(ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE_DOORBELL_CLEAR,
&reg->outbound_doorbell_clear);
+ writel(ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE_DOORBELL_CLEAR,
+ &reg->outbound_doorbell_clear);
+ schedule_work(&acb->arcmsr_do_message_isr_bh);
+}
+
+static void
+arcmsr_hbaD_message_isr(struct AdapterControlBlock *acb)
+{
+ struct MessageUnit_D __iomem *reg  = acb->pmuD;
+ writel(ARCMSR_ARC1214_IOP2DRV_MESSAGE_CMD_DONE,
+ reg->outbound_doorbell);
+ readl(reg->outbound_doorbell);
  schedule_work(&acb->arcmsr_do_message_isr_bh);
 }

-static int arcmsr_handle_hba_isr(struct AdapterControlBlock *acb)
+static irqreturn_t
+arcmsr_hbaA_handle_isr(struct AdapterControlBlock *acb)
 {
  uint32_t outbound_intstatus;
  struct MessageUnit_A __iomem *reg = acb->pmuA;
- outbound_intstatus = readl(&reg->outbound_intstatus) &
- acb->outbound_int_enable;
- if (!(outbound_intstatus & ARCMSR_MU_OUTBOUND_HANDLE_INT)) {
- return 1;
- }
- writel(outbound_intstatus, &reg->outbound_intstatus);
- if (outbound_intstatus & ARCMSR_MU_OUTBOUND_DOORBELL_INT) {
- arcmsr_hba_doorbell_isr(acb);
- }
- if (outbound_intstatus & ARCMSR_MU_OUTBOUND_POSTQUEUE_INT) {
- arcmsr_hba_postqueue_isr(acb);
- }
- if(outbound_intstatus & ARCMSR_MU_OUTBOUND_MESSAGE0_INT) {
- /* messenger of "driver to iop commands" */
- arcmsr_hba_message_isr(acb);
- }
- return 0;
+ outbound_intstatus =
+ readl(&reg->outbound_intstatus) & acb->outbound_int_enable;
+ if (!(outbound_intstatus & ARCMSR_MU_OUTBOUND_HANDLE_INT))
+ return IRQ_NONE;
+ do {
+ writel(outbound_intstatus, &reg->outbound_intstatus);
+ if (outbound_intstatus & ARCMSR_MU_OUTBOUND_DOORBELL_INT)
+ arcmsr_hbaA_doorbell_isr(acb);
+ if (outbound_intstatus & ARCMSR_MU_OUTBOUND_POSTQUEUE_INT)
+ arcmsr_hbaA_postqueue_isr(acb);
+ if (outbound_intstatus & ARCMSR_MU_OUTBOUND_MESSAGE0_INT)
+ arcmsr_hbaA_message_isr(acb);
+ outbound_intstatus = readl(&reg->outbound_intstatus) &
+ acb->outbound_int_enable;
+ } while (outbound_intstatus & (ARCMSR_MU_OUTBOUND_DOORBELL_INT
+ | ARCMSR_MU_OUTBOUND_POSTQUEUE_INT
+ | ARCMSR_MU_OUTBOUND_MESSAGE0_INT));
+ return IRQ_HANDLED;
 }

-static int arcmsr_handle_hbb_isr(struct AdapterControlBlock *acb)
+static irqreturn_t
+arcmsr_hbaB_handle_isr(struct AdapterControlBlock *acb)
 {
  uint32_t outbound_doorbell;
- struct MessageUnit_B *reg = acb->pmuB;
- outbound_doorbell = readl(reg->iop2drv_doorbell) &
- acb->outbound_int_enable;
+ struct MessageUnit_B __iomem *reg = acb->pmuB;
+ outbound_doorbell = readl(reg->iop2drv_doorbell)
+ & acb->outbound_int_enable;
  if (!outbound_doorbell)
- return 1;
-
- writel(~outbound_doorbell, reg->iop2drv_doorbell);
- /*in case the last action of doorbell interrupt clearance is cached,
- this action can push HW to write down the clear bit*/
- readl(reg->iop2drv_doorbell);
- writel(ARCMSR_DRV2IOP_END_OF_INTERRUPT, reg->drv2iop_doorbell);
- if (outbound_doorbell & ARCMSR_IOP2DRV_DATA_WRITE_OK) {
- arcmsr_iop2drv_data_wrote_handle(acb);
- }
- if (outbound_doorbell & ARCMSR_IOP2DRV_DATA_READ_OK) {
- arcmsr_iop2drv_data_read_handle(acb);
- }
- if (outbound_doorbell & ARCMSR_IOP2DRV_CDB_DONE) {
- arcmsr_hbb_postqueue_isr(acb);
- }
- if(outbound_doorbell & ARCMSR_IOP2DRV_MESSAGE_CMD_DONE) {
- /* messenger of "driver to iop commands" */
- arcmsr_hbb_message_isr(acb);
- }
- return 0;
+ return IRQ_NONE;
+ do {
+ writel(~outbound_doorbell, reg->iop2drv_doorbell);
+ readl(reg->iop2drv_doorbell);
+ writel(ARCMSR_DRV2IOP_END_OF_INTERRUPT,
+ reg->drv2iop_doorbell);
+ readl(reg->drv2iop_doorbell);
+ if (outbound_doorbell & ARCMSR_IOP2DRV_DATA_WRITE_OK)
+ arcmsr_iop2drv_data_wrote_handle(acb);
+ if (outbound_doorbell & ARCMSR_IOP2DRV_DATA_READ_OK)
+ arcmsr_iop2drv_data_read_handle(acb);
+ if (outbound_doorbell & ARCMSR_IOP2DRV_CDB_DONE)
+ arcmsr_hbaB_postqueue_isr(acb);
+ if (outbound_doorbell & ARCMSR_IOP2DRV_MESSAGE_CMD_DONE)
+ arcmsr_hbaB_message_isr(acb);
+ outbound_doorbell = readl(reg->iop2drv_doorbell) &
+ acb->outbound_int_enable;
+ } while (outbound_doorbell & (ARCMSR_IOP2DRV_DATA_WRITE_OK
+ | ARCMSR_IOP2DRV_DATA_READ_OK
+ | ARCMSR_IOP2DRV_CDB_DONE
+ | ARCMSR_IOP2DRV_MESSAGE_CMD_DONE));
+ return IRQ_HANDLED;
 }

-static int arcmsr_handle_hbc_isr(struct AdapterControlBlock *pACB)
+static irqreturn_t
+arcmsr_hbaC_handle_isr(struct AdapterControlBlock *pACB)
 {
  uint32_t host_interrupt_status;
- struct MessageUnit_C *phbcmu = (struct MessageUnit_C *)pACB->pmuC;
- /*
- *********************************************
- **   check outbound intstatus
- *********************************************
- */
- host_interrupt_status = readl(&phbcmu->host_int_status);
- if (!host_interrupt_status) {
- /*it must be share irq*/
- return 1;
- }
- /* MU ioctl transfer doorbell interrupts*/
- if (host_interrupt_status & ARCMSR_HBCMU_OUTBOUND_DOORBELL_ISR) {
- arcmsr_hbc_doorbell_isr(pACB);   /* messenger of "ioctl message read write" */
- }
- /* MU post queue interrupts*/
- if (host_interrupt_status & ARCMSR_HBCMU_OUTBOUND_POSTQUEUE_ISR) {
- arcmsr_hbc_postqueue_isr(pACB);  /* messenger of "scsi commands" */
- }
- return 0;
+ struct MessageUnit_C __iomem *phbcmu = pACB->pmuC;
+ host_interrupt_status =
+ readl(&phbcmu->host_int_status);
+ do {
+ if (host_interrupt_status &
+ ARCMSR_HBCMU_OUTBOUND_DOORBELL_ISR)
+ arcmsr_hbaC_doorbell_isr(pACB);
+ /* MU post queue interrupts*/
+ if (host_interrupt_status &
+ ARCMSR_HBCMU_OUTBOUND_POSTQUEUE_ISR)
+ arcmsr_hbaC_postqueue_isr(pACB);
+ host_interrupt_status = readl(&phbcmu->host_int_status);
+ } while (host_interrupt_status &
+ (ARCMSR_HBCMU_OUTBOUND_POSTQUEUE_ISR |
+ ARCMSR_HBCMU_OUTBOUND_DOORBELL_ISR));
+ return IRQ_HANDLED;
 }
-static irqreturn_t arcmsr_interrupt(struct AdapterControlBlock *acb)
+
+static irqreturn_t
+arcmsr_hbaD_handle_isr(struct AdapterControlBlock *pACB)
+{
+ u32 host_interrupt_status;
+ struct MessageUnit_D __iomem *pmu = pACB->pmuD;
+ host_interrupt_status = readl(pmu->host_int_status);
+ do {
+ /* MU post queue interrupts*/
+ if (host_interrupt_status &
+ ARCMSR_ARC1214_OUTBOUND_POSTQUEUE_ISR)
+ arcmsr_hbaD_postqueue_isr(pACB);
+ if (host_interrupt_status &
+ ARCMSR_ARC1214_OUTBOUND_DOORBELL_ISR)
+ arcmsr_hbaD_doorbell_isr(pACB);
+ host_interrupt_status = readl(pmu->host_int_status);
+ } while (host_interrupt_status &
+ (ARCMSR_ARC1214_OUTBOUND_POSTQUEUE_ISR |
+ ARCMSR_ARC1214_OUTBOUND_DOORBELL_ISR));
+ return IRQ_HANDLED;
+}
+
+static irqreturn_t
+arcmsr_interrupt(struct AdapterControlBlock *acb)
 {
  switch (acb->adapter_type) {
  case ACB_ADAPTER_TYPE_A: {
- if (arcmsr_handle_hba_isr(acb)) {
- return IRQ_NONE;
- }
- }
+ return arcmsr_hbaA_handle_isr(acb);
  break;
-
+ }
  case ACB_ADAPTER_TYPE_B: {
- if (arcmsr_handle_hbb_isr(acb)) {
- return IRQ_NONE;
- }
- }
+ return arcmsr_hbaB_handle_isr(acb);
  break;
- case ACB_ADAPTER_TYPE_C: {
- if (arcmsr_handle_hbc_isr(acb)) {
- return IRQ_NONE;
- }
- }
  }
- return IRQ_HANDLED;
+ case ACB_ADAPTER_TYPE_C: {
+ return arcmsr_hbaC_handle_isr(acb);
+ break;
+ }
+ case ACB_ADAPTER_TYPE_D: {
+ return arcmsr_hbaD_handle_isr(acb);
+ break;
+ }
+ default:
+ return IRQ_NONE;
+ }
 }

-static void arcmsr_iop_parking(struct AdapterControlBlock *acb)
+static void
+arcmsr_iop_parking(struct AdapterControlBlock *acb)
 {
  if (acb) {
  /* stop adapter background rebuild */
@@ -1695,309 +2544,372 @@ static void arcmsr_iop_parking(struct Ad
  }
 }

-void arcmsr_post_ioctldata2iop(struct AdapterControlBlock *acb)
+void
+arcmsr_clear_iop2drv_rqueue_buffer(struct AdapterControlBlock *acb)
 {
- int32_t wqbuf_firstindex, wqbuf_lastindex;
- uint8_t *pQbuffer;
- struct QBUFFER __iomem *pwbuffer;
- uint8_t __iomem *iop_data;
- int32_t allxfer_len = 0;
- pwbuffer = arcmsr_get_iop_wqbuffer(acb);
- iop_data = (uint8_t __iomem *)pwbuffer->data;
- if (acb->acb_flags & ACB_F_MESSAGE_WQBUFFER_READED) {
- acb->acb_flags &= (~ACB_F_MESSAGE_WQBUFFER_READED);
- wqbuf_firstindex = acb->wqbuf_firstindex;
- wqbuf_lastindex = acb->wqbuf_lastindex;
- while ((wqbuf_firstindex != wqbuf_lastindex) && (allxfer_len < 124)) {
- pQbuffer = &acb->wqbuffer[wqbuf_firstindex];
- memcpy(iop_data, pQbuffer, 1);
- wqbuf_firstindex++;
- wqbuf_firstindex %= ARCMSR_MAX_QBUFFER;
- iop_data++;
- allxfer_len++;
+ uint32_t i;
+
+ if (acb->acb_flags & ACB_F_IOPDATA_OVERFLOW) {
+ for (i = 0; i < 15; i++) {
+ if (acb->acb_flags & ACB_F_IOPDATA_OVERFLOW) {
+ acb->acb_flags &= ~ACB_F_IOPDATA_OVERFLOW;
+ acb->rqbuf_firstindex = 0;
+ acb->rqbuf_lastindex = 0;
+ arcmsr_iop_message_read(acb);
+ mdelay(30);
+ } else if (acb->rqbuf_firstindex != acb->rqbuf_lastindex) {
+ acb->rqbuf_firstindex = 0;
+ acb->rqbuf_lastindex = 0;
+ mdelay(30);
+ } else
+ break;
  }
- acb->wqbuf_firstindex = wqbuf_firstindex;
- pwbuffer->data_len = allxfer_len;
- arcmsr_iop_message_wrote(acb);
  }
 }

-static int arcmsr_iop_message_xfer(struct AdapterControlBlock *acb,
+static int
+arcmsr_iop_message_xfer(struct AdapterControlBlock *acb,
  struct scsi_cmnd *cmd)
 {
- struct CMD_MESSAGE_FIELD *pcmdmessagefld;
- int retvalue = 0, transfer_len = 0;
  char *buffer;
+ unsigned short use_sg;
+ int retvalue = 0, transfer_len = 0;
+ unsigned long flags;
+ struct CMD_MESSAGE_FIELD *pcmdmessagefld;
+ uint32_t controlcode = (uint32_t)cmd->cmnd[5] << 24 |
+ (uint32_t)cmd->cmnd[6] << 16 |
+ (uint32_t)cmd->cmnd[7] << 8 |
+ (uint32_t)cmd->cmnd[8];
  struct scatterlist *sg;
- uint32_t controlcode = (uint32_t ) cmd->cmnd[5] << 24 |
- (uint32_t ) cmd->cmnd[6] << 16 |
- (uint32_t ) cmd->cmnd[7] << 8  |
- (uint32_t ) cmd->cmnd[8];
- /* 4 bytes: Areca io control code */
+
+ use_sg = scsi_sg_count(cmd);
  sg = scsi_sglist(cmd);
  buffer = kmap_atomic(sg_page(sg)) + sg->offset;
- if (scsi_sg_count(cmd) > 1) {
+ if (use_sg > 1) {
  retvalue = ARCMSR_MESSAGE_FAIL;
  goto message_out;
  }
  transfer_len += sg->length;
-
  if (transfer_len > sizeof(struct CMD_MESSAGE_FIELD)) {
  retvalue = ARCMSR_MESSAGE_FAIL;
+ pr_info("%s: ARCMSR_MESSAGE_FAIL!\n", __func__);
  goto message_out;
  }
- pcmdmessagefld = (struct CMD_MESSAGE_FIELD *) buffer;
- switch(controlcode) {
-
+ pcmdmessagefld = (struct CMD_MESSAGE_FIELD *)buffer;
+ switch (controlcode) {
  case ARCMSR_MESSAGE_READ_RQBUFFER: {
  unsigned char *ver_addr;
  uint8_t *pQbuffer, *ptmpQbuffer;
- int32_t allxfer_len = 0;
-
- ver_addr = kmalloc(1032, GFP_ATOMIC);
+ uint32_t allxfer_len = 0;
+ ver_addr = (unsigned char *)kmalloc(1032, GFP_ATOMIC);
  if (!ver_addr) {
  retvalue = ARCMSR_MESSAGE_FAIL;
+ pr_info("%s: memory not enough!\n", __func__);
  goto message_out;
  }
-
  ptmpQbuffer = ver_addr;
- while ((acb->rqbuf_firstindex != acb->rqbuf_lastindex)
- && (allxfer_len < 1031)) {
+ spin_lock_irqsave(&acb->rqbuffer_lock, flags);
+ if (acb->rqbuf_firstindex != acb->rqbuf_lastindex) {
  pQbuffer = &acb->rqbuffer[acb->rqbuf_firstindex];
- memcpy(ptmpQbuffer, pQbuffer, 1);
- acb->rqbuf_firstindex++;
- acb->rqbuf_firstindex %= ARCMSR_MAX_QBUFFER;
- ptmpQbuffer++;
- allxfer_len++;
+ if (acb->rqbuf_firstindex > acb->rqbuf_lastindex) {
+ if ((ARCMSR_MAX_QBUFFER -
+ acb->rqbuf_firstindex) >= 1032) {
+ memcpy((void *)ptmpQbuffer, (const void *)pQbuffer, 1032);
+ acb->rqbuf_firstindex += 1032;
+ acb->rqbuf_firstindex %= ARCMSR_MAX_QBUFFER;
+ allxfer_len = 1032;
+ } else {
+ if (((ARCMSR_MAX_QBUFFER -
+ acb->rqbuf_firstindex) +
+ acb->rqbuf_lastindex) > 1032) {
+ memcpy((void *)ptmpQbuffer,
+ (const void *)pQbuffer, ARCMSR_MAX_QBUFFER
+ - acb->rqbuf_firstindex);
+ ptmpQbuffer +=
+ ARCMSR_MAX_QBUFFER -
+ acb->rqbuf_firstindex;
+ memcpy((void *)ptmpQbuffer,
+ (const void *)acb->rqbuffer, 1032 -
+ (ARCMSR_MAX_QBUFFER
+ - acb->rqbuf_firstindex));
+ acb->rqbuf_firstindex =
+ 1032 - (ARCMSR_MAX_QBUFFER
+ - acb->rqbuf_firstindex);
+ allxfer_len = 1032;
+ } else {
+ memcpy((void *)ptmpQbuffer,
+ (const void *)pQbuffer, ARCMSR_MAX_QBUFFER
+ - acb->rqbuf_firstindex);
+ ptmpQbuffer +=
+ ARCMSR_MAX_QBUFFER -
+ acb->rqbuf_firstindex;
+ memcpy((void *)ptmpQbuffer,
+ (const void *)acb->rqbuffer,
+ acb->rqbuf_lastindex);
+ allxfer_len = ARCMSR_MAX_QBUFFER
+ - acb->rqbuf_firstindex +
+ acb->rqbuf_lastindex;
+ acb->rqbuf_firstindex =
+ acb->rqbuf_lastindex;
+ }
+ }
+ } else {
+ if ((acb->rqbuf_lastindex -
+ acb->rqbuf_firstindex) > 1032) {
+ memcpy((void *)ptmpQbuffer,
+ (const void *)pQbuffer, 1032);
+ acb->rqbuf_firstindex += 1032;
+ allxfer_len = 1032;
+ } else {
+ memcpy((void *)ptmpQbuffer, (const void *)pQbuffer,
+ acb->rqbuf_lastindex - acb->rqbuf_firstindex);
+ allxfer_len = acb->rqbuf_lastindex
+ - acb->rqbuf_firstindex;
+ acb->rqbuf_firstindex =
+ acb->rqbuf_lastindex;
+ }
+ }
  }
+ memcpy((void *)pcmdmessagefld->messagedatabuffer,
+ (const void *)ver_addr, allxfer_len);
  if (acb->acb_flags & ACB_F_IOPDATA_OVERFLOW) {
-
  struct QBUFFER __iomem *prbuffer;
- uint8_t __iomem *iop_data;
- int32_t iop_len;
-
  acb->acb_flags &= ~ACB_F_IOPDATA_OVERFLOW;
  prbuffer = arcmsr_get_iop_rqbuffer(acb);
- iop_data = prbuffer->data;
- iop_len = readl(&prbuffer->data_len);
- while (iop_len > 0) {
- acb->rqbuffer[acb->rqbuf_lastindex] = readb(iop_data);
- acb->rqbuf_lastindex++;
- acb->rqbuf_lastindex %= ARCMSR_MAX_QBUFFER;
- iop_data++;
- iop_len--;
- }
- arcmsr_iop_message_read(acb);
+ if (arcmsr_Read_iop_rqbuffer_data(acb, prbuffer) == 0)
+ acb->acb_flags |= ACB_F_IOPDATA_OVERFLOW;
  }
- memcpy(pcmdmessagefld->messagedatabuffer, ver_addr, allxfer_len);
+ spin_unlock_irqrestore(&acb->rqbuffer_lock, flags);
+ kfree((const void *)ver_addr);
  pcmdmessagefld->cmdmessage.Length = allxfer_len;
- if(acb->fw_flag == FW_DEADLOCK) {
- pcmdmessagefld->cmdmessage.ReturnCode = ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;
- }else{
- pcmdmessagefld->cmdmessage.ReturnCode = ARCMSR_MESSAGE_RETURNCODE_OK;
- }
- kfree(ver_addr);
+ if (acb->fw_flag == FW_DEADLOCK) {
+ pcmdmessagefld->cmdmessage.ReturnCode =
+ ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;
+ } else {
+ pcmdmessagefld->cmdmessage.ReturnCode =
+ ARCMSR_MESSAGE_RETURNCODE_OK;
  }
  break;
-
+ }
  case ARCMSR_MESSAGE_WRITE_WQBUFFER: {
  unsigned char *ver_addr;
- int32_t my_empty_len, user_len, wqbuf_firstindex, wqbuf_lastindex;
+ int32_t my_empty_len, user_len, wqbuf_firstindex,
+ wqbuf_lastindex;
  uint8_t *pQbuffer, *ptmpuserbuffer;
-
- ver_addr = kmalloc(1032, GFP_ATOMIC);
+ ver_addr = (unsigned char *)kmalloc(1032, GFP_ATOMIC);
  if (!ver_addr) {
  retvalue = ARCMSR_MESSAGE_FAIL;
  goto message_out;
  }
- if(acb->fw_flag == FW_DEADLOCK) {
- pcmdmessagefld->cmdmessage.ReturnCode =
- ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;
- }else{
- pcmdmessagefld->cmdmessage.ReturnCode =
- ARCMSR_MESSAGE_RETURNCODE_OK;
- }
  ptmpuserbuffer = ver_addr;
  user_len = pcmdmessagefld->cmdmessage.Length;
- memcpy(ptmpuserbuffer, pcmdmessagefld->messagedatabuffer, user_len);
+ memcpy((void *)ptmpuserbuffer,
+ (const void *)pcmdmessagefld->messagedatabuffer, user_len);
+ spin_lock_irqsave(&acb->wqbuffer_lock, flags);
  wqbuf_lastindex = acb->wqbuf_lastindex;
  wqbuf_firstindex = acb->wqbuf_firstindex;
  if (wqbuf_lastindex != wqbuf_firstindex) {
  struct SENSE_DATA *sensebuffer =
  (struct SENSE_DATA *)cmd->sense_buffer;
- arcmsr_post_ioctldata2iop(acb);
+ arcmsr_write_ioctldata2iop(acb);
  /* has error report sensedata */
- sensebuffer->ErrorCode = 0x70;
+ sensebuffer->ErrorCode = SCSI_SENSE_CURRENT_ERRORS;
  sensebuffer->SenseKey = ILLEGAL_REQUEST;
  sensebuffer->AdditionalSenseLength = 0x0A;
  sensebuffer->AdditionalSenseCode = 0x20;
  sensebuffer->Valid = 1;
  retvalue = ARCMSR_MESSAGE_FAIL;
  } else {
- my_empty_len = (wqbuf_firstindex-wqbuf_lastindex - 1)
- &(ARCMSR_MAX_QBUFFER - 1);
+ my_empty_len = (wqbuf_firstindex - wqbuf_lastindex - 1)
+ & (ARCMSR_MAX_QBUFFER - 1);
  if (my_empty_len >= user_len) {
  while (user_len > 0) {
- pQbuffer =
- &acb->wqbuffer[acb->wqbuf_lastindex];
- memcpy(pQbuffer, ptmpuserbuffer, 1);
- acb->wqbuf_lastindex++;
- acb->wqbuf_lastindex %= ARCMSR_MAX_QBUFFER;
- ptmpuserbuffer++;
- user_len--;
+ pQbuffer = &acb->wqbuffer[acb->wqbuf_lastindex];
+ if ((acb->wqbuf_lastindex + user_len)
+ > ARCMSR_MAX_QBUFFER) {
+ memcpy((void *)pQbuffer,
+ (const void *)ptmpuserbuffer,
+ ARCMSR_MAX_QBUFFER -
+ acb->wqbuf_lastindex);
+ ptmpuserbuffer += (ARCMSR_MAX_QBUFFER
+ - acb->wqbuf_lastindex);
+ user_len -= (ARCMSR_MAX_QBUFFER
+ - acb->wqbuf_lastindex);
+ acb->wqbuf_lastindex = 0;
+ } else {
+ memcpy((void *)pQbuffer,
+ (const void *)ptmpuserbuffer,
+ user_len);
+ acb->wqbuf_lastindex += user_len;
+ acb->wqbuf_lastindex %=
+ ARCMSR_MAX_QBUFFER;
+ user_len = 0;
+ }
  }
- if (acb->acb_flags & ACB_F_MESSAGE_WQBUFFER_CLEARED) {
+ if (acb->acb_flags &
+ ACB_F_MESSAGE_WQBUFFER_CLEARED) {
  acb->acb_flags &=
  ~ACB_F_MESSAGE_WQBUFFER_CLEARED;
- arcmsr_post_ioctldata2iop(acb);
+ arcmsr_write_ioctldata2iop(acb);
  }
  } else {
- /* has error report sensedata */
  struct SENSE_DATA *sensebuffer =
  (struct SENSE_DATA *)cmd->sense_buffer;
- sensebuffer->ErrorCode = 0x70;
+ /* has error report sensedata */
+ sensebuffer->ErrorCode =
+ SCSI_SENSE_CURRENT_ERRORS;
  sensebuffer->SenseKey = ILLEGAL_REQUEST;
  sensebuffer->AdditionalSenseLength = 0x0A;
  sensebuffer->AdditionalSenseCode = 0x20;
  sensebuffer->Valid = 1;
  retvalue = ARCMSR_MESSAGE_FAIL;
  }
- }
- kfree(ver_addr);
+ }
+ spin_unlock_irqrestore(&acb->wqbuffer_lock, flags);
+ kfree((const void *)ver_addr);
+ if (acb->fw_flag == FW_DEADLOCK) {
+ pcmdmessagefld->cmdmessage.ReturnCode =
+ ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;
+ } else {
+ pcmdmessagefld->cmdmessage.ReturnCode =
+ ARCMSR_MESSAGE_RETURNCODE_OK;
  }
  break;
-
+ }
  case ARCMSR_MESSAGE_CLEAR_RQBUFFER: {
  uint8_t *pQbuffer = acb->rqbuffer;
- if (acb->acb_flags & ACB_F_IOPDATA_OVERFLOW) {
- acb->acb_flags &= ~ACB_F_IOPDATA_OVERFLOW;
- arcmsr_iop_message_read(acb);
- }
+
+ arcmsr_clear_iop2drv_rqueue_buffer(acb);
+ spin_lock_irqsave(&acb->rqbuffer_lock, flags);
  acb->acb_flags |= ACB_F_MESSAGE_RQBUFFER_CLEARED;
  acb->rqbuf_firstindex = 0;
  acb->rqbuf_lastindex = 0;
  memset(pQbuffer, 0, ARCMSR_MAX_QBUFFER);
- if(acb->fw_flag == FW_DEADLOCK) {
+ spin_unlock_irqrestore(&acb->rqbuffer_lock, flags);
+ if (acb->fw_flag == FW_DEADLOCK) {
  pcmdmessagefld->cmdmessage.ReturnCode =
- ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;
- }else{
+ ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;
+ } else {
  pcmdmessagefld->cmdmessage.ReturnCode =
- ARCMSR_MESSAGE_RETURNCODE_OK;
- }
+ ARCMSR_MESSAGE_RETURNCODE_OK;
  }
  break;
-
+ }
  case ARCMSR_MESSAGE_CLEAR_WQBUFFER: {
  uint8_t *pQbuffer = acb->wqbuffer;
- if(acb->fw_flag == FW_DEADLOCK) {
- pcmdmessagefld->cmdmessage.ReturnCode =
- ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;
- }else{
- pcmdmessagefld->cmdmessage.ReturnCode =
- ARCMSR_MESSAGE_RETURNCODE_OK;
- }
-
- if (acb->acb_flags & ACB_F_IOPDATA_OVERFLOW) {
- acb->acb_flags &= ~ACB_F_IOPDATA_OVERFLOW;
- arcmsr_iop_message_read(acb);
- }
- acb->acb_flags |=
- (ACB_F_MESSAGE_WQBUFFER_CLEARED |
- ACB_F_MESSAGE_WQBUFFER_READED);
+ spin_lock_irqsave(&acb->wqbuffer_lock, flags);
+ acb->acb_flags |= (ACB_F_MESSAGE_WQBUFFER_CLEARED |
+ ACB_F_MESSAGE_WQBUFFER_READED);
  acb->wqbuf_firstindex = 0;
  acb->wqbuf_lastindex = 0;
  memset(pQbuffer, 0, ARCMSR_MAX_QBUFFER);
+ spin_unlock_irqrestore(&acb->wqbuffer_lock, flags);
+ if (acb->fw_flag == FW_DEADLOCK) {
+ pcmdmessagefld->cmdmessage.ReturnCode =
+ ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;
+ } else {
+ pcmdmessagefld->cmdmessage.ReturnCode =
+ ARCMSR_MESSAGE_RETURNCODE_OK;
  }
  break;
-
+ }
  case ARCMSR_MESSAGE_CLEAR_ALLQBUFFER: {
  uint8_t *pQbuffer;
-
- if (acb->acb_flags & ACB_F_IOPDATA_OVERFLOW) {
- acb->acb_flags &= ~ACB_F_IOPDATA_OVERFLOW;
- arcmsr_iop_message_read(acb);
- }
- acb->acb_flags |=
- (ACB_F_MESSAGE_WQBUFFER_CLEARED
- | ACB_F_MESSAGE_RQBUFFER_CLEARED
- | ACB_F_MESSAGE_WQBUFFER_READED);
+ arcmsr_clear_iop2drv_rqueue_buffer(acb);
+ spin_lock_irqsave(&acb->rqbuffer_lock, flags);
+ acb->acb_flags |= ACB_F_MESSAGE_RQBUFFER_CLEARED;
  acb->rqbuf_firstindex = 0;
  acb->rqbuf_lastindex = 0;
- acb->wqbuf_firstindex = 0;
- acb->wqbuf_lastindex = 0;
  pQbuffer = acb->rqbuffer;
  memset(pQbuffer, 0, sizeof(struct QBUFFER));
+ spin_unlock_irqrestore(&acb->rqbuffer_lock, flags);
+ spin_lock_irqsave(&acb->wqbuffer_lock, flags);
+ acb->acb_flags |= (ACB_F_MESSAGE_WQBUFFER_CLEARED |
+ ACB_F_MESSAGE_WQBUFFER_READED);
+ acb->wqbuf_firstindex = 0;
+ acb->wqbuf_lastindex = 0;
  pQbuffer = acb->wqbuffer;
  memset(pQbuffer, 0, sizeof(struct QBUFFER));
- if(acb->fw_flag == FW_DEADLOCK) {
+ spin_unlock_irqrestore(&acb->wqbuffer_lock, flags);
+ if (acb->fw_flag == FW_DEADLOCK) {
  pcmdmessagefld->cmdmessage.ReturnCode =
- ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;
- }else{
+ ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;
+ } else {
  pcmdmessagefld->cmdmessage.ReturnCode =
- ARCMSR_MESSAGE_RETURNCODE_OK;
- }
+ ARCMSR_MESSAGE_RETURNCODE_OK;
  }
  break;
-
+ }
  case ARCMSR_MESSAGE_RETURN_CODE_3F: {
- if(acb->fw_flag == FW_DEADLOCK) {
+ if (acb->fw_flag == FW_DEADLOCK) {
  pcmdmessagefld->cmdmessage.ReturnCode =
- ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;
- }else{
+ ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;
+ } else {
  pcmdmessagefld->cmdmessage.ReturnCode =
- ARCMSR_MESSAGE_RETURNCODE_3F;
+ ARCMSR_MESSAGE_RETURNCODE_3F;
  }
  break;
- }
+ }
  case ARCMSR_MESSAGE_SAY_HELLO: {
  int8_t *hello_string = "Hello! I am ARCMSR";
- if(acb->fw_flag == FW_DEADLOCK) {
+ if (acb->fw_flag == FW_DEADLOCK) {
  pcmdmessagefld->cmdmessage.ReturnCode =
- ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;
- }else{
+ ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;
+ } else {
  pcmdmessagefld->cmdmessage.ReturnCode =
- ARCMSR_MESSAGE_RETURNCODE_OK;
- }
- memcpy(pcmdmessagefld->messagedatabuffer, hello_string
- , (int16_t)strlen(hello_string));
+ ARCMSR_MESSAGE_RETURNCODE_OK;
  }
+ memcpy((void *)pcmdmessagefld->messagedatabuffer,
+ (const void *)hello_string, (int16_t)strlen(hello_string));
  break;
-
- case ARCMSR_MESSAGE_SAY_GOODBYE:
- if(acb->fw_flag == FW_DEADLOCK) {
+ }
+ case ARCMSR_MESSAGE_SAY_GOODBYE: {
+ if (acb->fw_flag == FW_DEADLOCK) {
+ pcmdmessagefld->cmdmessage.ReturnCode =
+ ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;
+ } else {
  pcmdmessagefld->cmdmessage.ReturnCode =
- ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;
+ ARCMSR_MESSAGE_RETURNCODE_OK;
  }
  arcmsr_iop_parking(acb);
  break;
-
- case ARCMSR_MESSAGE_FLUSH_ADAPTER_CACHE:
- if(acb->fw_flag == FW_DEADLOCK) {
+ }
+ case ARCMSR_MESSAGE_FLUSH_ADAPTER_CACHE: {
+ if (acb->fw_flag == FW_DEADLOCK) {
  pcmdmessagefld->cmdmessage.ReturnCode =
- ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;
+ ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;
+ } else {
+ pcmdmessagefld->cmdmessage.ReturnCode =
+ ARCMSR_MESSAGE_RETURNCODE_OK;
  }
  arcmsr_flush_adapter_cache(acb);
  break;
-
+ }
  default:
  retvalue = ARCMSR_MESSAGE_FAIL;
+ pr_info("%s: unknown controlcode!\n", __func__);
  }
  message_out:
- sg = scsi_sglist(cmd);
- kunmap_atomic(buffer - sg->offset);
+ if (use_sg) {
+ struct scatterlist *sg;
+ sg = scsi_sglist(cmd);
+ kunmap_atomic(buffer - sg->offset);
+ }
  return retvalue;
 }

-static struct CommandControlBlock *arcmsr_get_freeccb(struct
AdapterControlBlock *acb)
+struct CommandControlBlock
+*arcmsr_get_freeccb(struct AdapterControlBlock *acb)
 {
  struct list_head *head = &acb->ccb_free_list;
  struct CommandControlBlock *ccb = NULL;
  unsigned long flags;
  spin_lock_irqsave(&acb->ccblist_lock, flags);
  if (!list_empty(head)) {
- ccb = list_entry(head->next, struct CommandControlBlock, list);
+ ccb = list_entry(head->next,
+ struct CommandControlBlock, list);
  list_del_init(&ccb->list);
- }else{
+ } else {
  spin_unlock_irqrestore(&acb->ccblist_lock, flags);
  return 0;
  }
@@ -2005,7 +2917,8 @@ static struct CommandControlBlock *arcms
  return ccb;
 }

-static void arcmsr_handle_virtual_command(struct AdapterControlBlock *acb,
+void
+arcmsr_handle_virtual_command(struct AdapterControlBlock *acb,
  struct scsi_cmnd *cmd)
 {
  switch (cmd->cmnd[0]) {
@@ -2013,7 +2926,6 @@ static void arcmsr_handle_virtual_comman
  unsigned char inqdata[36];
  char *buffer;
  struct scatterlist *sg;
-
  if (cmd->device->lun) {
  cmd->result = (DID_TIME_OUT << 16);
  cmd->scsi_done(cmd);
@@ -2032,14 +2944,11 @@ static void arcmsr_handle_virtual_comman
  strncpy(&inqdata[16], "RAID controller ", 16);
  /* Product Identification */
  strncpy(&inqdata[32], "R001", 4); /* Product Revision */
-
  sg = scsi_sglist(cmd);
  buffer = kmap_atomic(sg_page(sg)) + sg->offset;
-
- memcpy(buffer, inqdata, sizeof(inqdata));
+ memcpy((void *)buffer, (const void *)inqdata, sizeof(inqdata));
  sg = scsi_sglist(cmd);
  kunmap_atomic(buffer - sg->offset);
-
  cmd->scsi_done(cmd);
  }
  break;
@@ -2055,11 +2964,13 @@ static void arcmsr_handle_virtual_comman
  }
 }

-static int arcmsr_queue_command_lck(struct scsi_cmnd *cmd,
+static int
+arcmsr_queue_command_lck(struct scsi_cmnd *cmd,
  void (* done)(struct scsi_cmnd *))
 {
  struct Scsi_Host *host = cmd->device->host;
- struct AdapterControlBlock *acb = (struct AdapterControlBlock *)
host->hostdata;
+ struct AdapterControlBlock *acb =
+ (struct AdapterControlBlock *)host->hostdata;
  struct CommandControlBlock *ccb;
  int target = cmd->device->id;
  int lun = cmd->device->lun;
@@ -2067,10 +2978,10 @@ static int arcmsr_queue_command_lck(stru
  cmd->scsi_done = done;
  cmd->host_scribble = NULL;
  cmd->result = 0;
- if ((scsicmd == SYNCHRONIZE_CACHE) ||(scsicmd == SEND_DIAGNOSTIC)){
- if(acb->devstate[target][lun] == ARECA_RAID_GONE) {
-     cmd->result = (DID_NO_CONNECT << 16);
- }
+ if ((scsicmd == SYNCHRONIZE_CACHE) ||
+ (scsicmd == SEND_DIAGNOSTIC)) {
+ if (acb->devstate[target][lun] == ARECA_RAID_GONE)
+ cmd->result = (DID_NO_CONNECT << 16);
  cmd->scsi_done(cmd);
  return 0;
  }
@@ -2080,13 +2991,14 @@ static int arcmsr_queue_command_lck(stru
  return 0;
  }
  if (atomic_read(&acb->ccboutstandingcount) >=
- ARCMSR_MAX_OUTSTANDING_CMD)
+ acb->maxOutstanding)
  return SCSI_MLQUEUE_HOST_BUSY;
  ccb = arcmsr_get_freeccb(acb);
  if (!ccb)
  return SCSI_MLQUEUE_HOST_BUSY;
  if (arcmsr_build_ccb( acb, ccb, cmd ) == FAILED) {
- cmd->result = (DID_ERROR << 16) | (RESERVATION_CONFLICT << 1);
+ cmd->result = (DID_ERROR << 16) |
+ (RESERVATION_CONFLICT << 1);
  cmd->scsi_done(cmd);
  return 0;
  }
@@ -2096,24 +3008,30 @@ static int arcmsr_queue_command_lck(stru

 static DEF_SCSI_QCMD(arcmsr_queue_command)

-static bool arcmsr_get_hba_config(struct AdapterControlBlock *acb)
+static bool
+arcmsr_hbaA_get_config(struct AdapterControlBlock *acb)
 {
  struct MessageUnit_A __iomem *reg = acb->pmuA;
  char *acb_firm_model = acb->firm_model;
  char *acb_firm_version = acb->firm_version;
  char *acb_device_map = acb->device_map;
- char __iomem *iop_firm_model = (char __iomem *)(&reg->message_rwbuffer[15]);
- char __iomem *iop_firm_version = (char __iomem *)(&reg->message_rwbuffer[17]);
- char __iomem *iop_device_map = (char __iomem *)(&reg->message_rwbuffer[21]);
+ char __iomem *iop_firm_model =
+ (char __iomem *)(&reg->message_rwbuffer[15]);
+ char __iomem *iop_firm_version =
+ (char __iomem *)(&reg->message_rwbuffer[17]);
+ char __iomem *iop_device_map =
+ (char __iomem *)(&reg->message_rwbuffer[21]);
  int count;
- writel(ARCMSR_INBOUND_MESG0_GET_CONFIG, &reg->inbound_msgaddr0);
- if (!arcmsr_hba_wait_msgint_ready(acb)) {
- printk(KERN_NOTICE "arcmsr%d: wait 'get adapter firmware \
- miscellaneous data' timeout \n", acb->host->host_no);
+ writel(ARCMSR_INBOUND_MESG0_GET_CONFIG,
+ &reg->inbound_msgaddr0);
+ if (!arcmsr_hbaA_wait_msgint_ready(acb)) {
+ pr_notice("arcmsr%d: wait 'get adapter firmware "
+ "miscellaneous data' timeout\n",
+ acb->host->host_no);
  return false;
  }
  count = 8;
- while (count){
+ while (count) {
  *acb_firm_model = readb(iop_firm_model);
  acb_firm_model++;
  iop_firm_model++;
@@ -2121,7 +3039,7 @@ static bool arcmsr_get_hba_config(struct
  }

  count = 16;
- while (count){
+ while (count) {
  *acb_firm_version = readb(iop_firm_version);
  acb_firm_version++;
  iop_firm_version++;
@@ -2129,27 +3047,29 @@ static bool arcmsr_get_hba_config(struct
  }

  count=16;
- while(count){
+ while (count) {
  *acb_device_map = readb(iop_device_map);
  acb_device_map++;
  iop_device_map++;
  count--;
  }
- printk(KERN_NOTICE "Areca RAID Controller%d: F/W %s & Model %s\n",
+ pr_notice("Areca RAID Controller%d: Model %s, F/W %s\n",
  acb->host->host_no,
- acb->firm_version,
- acb->firm_model);
+ acb->firm_model,
+ acb->firm_version);
  acb->signature = readl(&reg->message_rwbuffer[0]);
  acb->firm_request_len = readl(&reg->message_rwbuffer[1]);
  acb->firm_numbers_queue = readl(&reg->message_rwbuffer[2]);
  acb->firm_sdram_size = readl(&reg->message_rwbuffer[3]);
  acb->firm_hd_channels = readl(&reg->message_rwbuffer[4]);
- acb->firm_cfg_version = readl(&reg->message_rwbuffer[25]);
/*firm_cfg_version,25,100-103*/
+ acb->firm_cfg_version = readl(&reg->message_rwbuffer[25]);
  return true;
 }
-static bool arcmsr_get_hbb_config(struct AdapterControlBlock *acb)
+
+static bool
+arcmsr_hbaB_get_config(struct AdapterControlBlock *acb)
 {
- struct MessageUnit_B *reg = acb->pmuB;
+ struct MessageUnit_B __iomem *reg = acb->pmuB;
  struct pci_dev *pdev = acb->pdev;
  void *dma_coherent;
  dma_addr_t dma_coherent_handle;
@@ -2163,40 +3083,57 @@ static bool arcmsr_get_hbb_config(struct
  char __iomem *iop_device_map;
  /*firm_version,21,84-99*/
  int count;
- dma_coherent = dma_alloc_coherent(&pdev->dev, sizeof(struct
MessageUnit_B), &dma_coherent_handle, GFP_KERNEL);
- if (!dma_coherent){
- printk(KERN_NOTICE "arcmsr%d: dma_alloc_coherent got error for hbb
mu\n", acb->host->host_no);
+ dma_coherent = dma_alloc_coherent(&pdev->dev,
+ sizeof(struct MessageUnit_B), &dma_coherent_handle,
+ GFP_KERNEL);
+ if (!dma_coherent) {
+ pr_notice("arcmsr%d: dma_alloc_coherent "
+ "got error for hbb mu\n", acb->host->host_no);
  return false;
  }
- acb->dma_coherent_handle_hbb_mu = dma_coherent_handle;
- reg = (struct MessageUnit_B *)dma_coherent;
+ acb->dma_coherent_handle2 = dma_coherent_handle;
+ reg = (struct MessageUnit_B __iomem *)dma_coherent;
  acb->pmuB = reg;
- reg->drv2iop_doorbell= (uint32_t __iomem *)((unsigned
long)acb->mem_base0 + ARCMSR_DRV2IOP_DOORBELL);
- reg->drv2iop_doorbell_mask = (uint32_t __iomem *)((unsigned
long)acb->mem_base0 + ARCMSR_DRV2IOP_DOORBELL_MASK);
- reg->iop2drv_doorbell = (uint32_t __iomem *)((unsigned
long)acb->mem_base0 + ARCMSR_IOP2DRV_DOORBELL);
- reg->iop2drv_doorbell_mask = (uint32_t __iomem *)((unsigned
long)acb->mem_base0 + ARCMSR_IOP2DRV_DOORBELL_MASK);
- reg->message_wbuffer = (uint32_t __iomem *)((unsigned
long)acb->mem_base1 + ARCMSR_MESSAGE_WBUFFER);
- reg->message_rbuffer =  (uint32_t __iomem *)((unsigned
long)acb->mem_base1 + ARCMSR_MESSAGE_RBUFFER);
- reg->message_rwbuffer = (uint32_t __iomem *)((unsigned
long)acb->mem_base1 + ARCMSR_MESSAGE_RWBUFFER);
- iop_firm_model = (char __iomem *)(&reg->message_rwbuffer[15]);
/*firm_model,15,60-67*/
- iop_firm_version = (char __iomem *)(&reg->message_rwbuffer[17]);
/*firm_version,17,68-83*/
- iop_device_map = (char __iomem *)(&reg->message_rwbuffer[21]);
/*firm_version,21,84-99*/
+ reg->drv2iop_doorbell = (uint32_t __iomem *)
+ ((unsigned long)acb->mem_base0 +
+ ARCMSR_DRV2IOP_DOORBELL);
+ reg->drv2iop_doorbell_mask = (uint32_t __iomem *)
+ ((unsigned long)acb->mem_base0 +
+ ARCMSR_DRV2IOP_DOORBELL_MASK);
+ reg->iop2drv_doorbell = (uint32_t __iomem *)
+ ((unsigned long)acb->mem_base0 +
+ ARCMSR_IOP2DRV_DOORBELL);
+ reg->iop2drv_doorbell_mask = (uint32_t __iomem *)
+ ((unsigned long)acb->mem_base0 +
+ ARCMSR_IOP2DRV_DOORBELL_MASK);
+ reg->message_wbuffer = (uint32_t __iomem *)
+ ((unsigned long)acb->mem_base1 +
+ ARCMSR_MESSAGE_WBUFFER);
+ reg->message_rbuffer = (uint32_t __iomem *)
+ ((unsigned long)acb->mem_base1 +
+ ARCMSR_MESSAGE_RBUFFER);
+ reg->message_rwbuffer = (uint32_t __iomem *)
+ ((unsigned long)acb->mem_base1 +
+ ARCMSR_MESSAGE_RWBUFFER);
+ iop_firm_model = (char __iomem *)(&reg->message_rwbuffer[15]);
+ iop_firm_version = (char __iomem *)(&reg->message_rwbuffer[17]);
+ iop_device_map = (char __iomem *)(&reg->message_rwbuffer[21]);

  writel(ARCMSR_MESSAGE_GET_CONFIG, reg->drv2iop_doorbell);
- if (!arcmsr_hbb_wait_msgint_ready(acb)) {
- printk(KERN_NOTICE "arcmsr%d: wait 'get adapter firmware \
- miscellaneous data' timeout \n", acb->host->host_no);
+ if (!arcmsr_hbaB_wait_msgint_ready(acb)) {
+ pr_notice("arcmsr%d: wait 'get adapter firmware "
+ "miscellaneous data' timeout\n", acb->host->host_no);
  return false;
  }
  count = 8;
- while (count){
+ while (count) {
  *acb_firm_model = readb(iop_firm_model);
  acb_firm_model++;
  iop_firm_model++;
  count--;
  }
  count = 16;
- while (count){
+ while (count) {
  *acb_firm_version = readb(iop_firm_version);
  acb_firm_version++;
  iop_firm_version++;
@@ -2204,17 +3141,17 @@ static bool arcmsr_get_hbb_config(struct
  }

  count = 16;
- while(count){
+ while (count) {
  *acb_device_map = readb(iop_device_map);
  acb_device_map++;
  iop_device_map++;
  count--;
  }
-
- printk(KERN_NOTICE "Areca RAID Controller%d: F/W %s & Model %s\n",
+
+ pr_notice("Areca RAID Controller%d: Model %s, F/W %s\n",
  acb->host->host_no,
- acb->firm_version,
- acb->firm_model);
+ acb->firm_model,
+ acb->firm_version);

  acb->signature = readl(&reg->message_rwbuffer[1]);
  /*firm_signature,1,00-03*/
@@ -2226,41 +3163,169 @@ static bool arcmsr_get_hbb_config(struct
  /*firm_sdram_size,3,12-15*/
  acb->firm_hd_channels = readl(&reg->message_rwbuffer[5]);
  /*firm_ide_channels,4,16-19*/
- acb->firm_cfg_version = readl(&reg->message_rwbuffer[25]);
/*firm_cfg_version,25,100-103*/
+ acb->firm_cfg_version = readl(&reg->message_rwbuffer[25]);
  /*firm_ide_channels,4,16-19*/
  return true;
 }

-static bool arcmsr_get_hbc_config(struct AdapterControlBlock *pACB)
-{
- uint32_t intmask_org, Index, firmware_state = 0;
- struct MessageUnit_C *reg = pACB->pmuC;
- char *acb_firm_model = pACB->firm_model;
- char *acb_firm_version = pACB->firm_version;
- char *iop_firm_model = (char *)(&reg->msgcode_rwbuffer[15]);
/*firm_model,15,60-67*/
- char *iop_firm_version = (char *)(&reg->msgcode_rwbuffer[17]);
/*firm_version,17,68-83*/
- int count;
- /* disable all outbound interrupt */
- intmask_org = readl(&reg->host_int_mask); /* disable outbound message0 int */
- writel(intmask_org|ARCMSR_HBCMU_ALL_INTMASKENABLE, &reg->host_int_mask);
- /* wait firmware ready */
- do {
- firmware_state = readl(&reg->outbound_msgaddr1);
- } while ((firmware_state & ARCMSR_HBCMU_MESSAGE_FIRMWARE_OK) == 0);
+static bool
+arcmsr_hbaC_get_config(struct AdapterControlBlock *pACB)
+{
+ uint32_t intmask_org, Index, firmware_state = 0;
+ struct MessageUnit_C __iomem *reg = pACB->pmuC;
+ char *acb_firm_model = pACB->firm_model;
+ char *acb_firm_version = pACB->firm_version;
+ char *iop_firm_model = (char *)(&reg->msgcode_rwbuffer[15]);
+ char *iop_firm_version = (char *)(&reg->msgcode_rwbuffer[17]);
+ int count;
+ /* disable all outbound interrupt */
+ intmask_org = readl(&reg->host_int_mask);
+ writel(intmask_org | ARCMSR_HBCMU_ALL_INTMASKENABLE,
+ &reg->host_int_mask);
+ do {
+ firmware_state = readl(&reg->outbound_msgaddr1);
+ } while ((firmware_state & ARCMSR_HBCMU_MESSAGE_FIRMWARE_OK) == 0);
+ /* post "get config" instruction */
+ writel(ARCMSR_INBOUND_MESG0_GET_CONFIG, &reg->inbound_msgaddr0);
+ writel(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE,
+ &reg->inbound_doorbell);
+ /* wait message ready */
+ for (Index = 0; Index < 2000; Index++) {
+ if (readl(&reg->outbound_doorbell) &
+ ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE) {
+ writel(ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE_DOORBELL_CLEAR,
+ &reg->outbound_doorbell_clear);
+ break;
+ }
+ udelay(10);
+ } /*max 1 seconds*/
+ if (Index >= 2000) {
+ pr_notice("arcmsr%d: wait 'get adapter firmware "
+ "miscellaneous data' timeout\n", pACB->host->host_no);
+ return false;
+ }
+ count = 8;
+ while (count) {
+ *acb_firm_model = readb(iop_firm_model);
+ acb_firm_model++;
+ iop_firm_model++;
+ count--;
+ }
+ count = 16;
+ while (count) {
+ *acb_firm_version = readb(iop_firm_version);
+ acb_firm_version++;
+ iop_firm_version++;
+ count--;
+ }
+ pr_notice("Areca RAID Controller%d: Model %s, F/W %s\n",
+ pACB->host->host_no,
+ pACB->firm_model,
+ pACB->firm_version);
+ pACB->firm_request_len = readl(&reg->msgcode_rwbuffer[1]);
+ pACB->firm_numbers_queue = readl(&reg->msgcode_rwbuffer[2]);
+ pACB->firm_sdram_size = readl(&reg->msgcode_rwbuffer[3]);
+ pACB->firm_hd_channels = readl(&reg->msgcode_rwbuffer[4]);
+ pACB->firm_cfg_version = readl(&reg->msgcode_rwbuffer[25]);
+ /*all interrupt service will be enable at arcmsr_iop_init*/
+ return true;
+}
+
+static bool
+arcmsr_hbaD_get_config(struct AdapterControlBlock *acb)
+{
+ char *acb_firm_model = acb->firm_model;
+ char *acb_firm_version = acb->firm_version;
+ char *acb_device_map = acb->device_map;
+ char __iomem *iop_firm_model;
+ char __iomem *iop_firm_version;
+ char __iomem *iop_device_map;
+ u32 count;
+ struct MessageUnit_D __iomem *reg ;
+ void *dma_coherent;
+ dma_addr_t dma_coherent_handle;
+ struct pci_dev *pdev = acb->pdev;
+
+ acb->roundup_ccbsize = roundup(sizeof(struct MessageUnit_D), 32);
+ dma_coherent = dma_alloc_coherent(&pdev->dev, acb->roundup_ccbsize,
+ &dma_coherent_handle, GFP_KERNEL);
+ if (!dma_coherent) {
+ pr_notice("DMA allocation failed...\n");
+ return false;
+ }
+ memset(dma_coherent, 0, acb->roundup_ccbsize);
+ acb->dma_coherent2 = dma_coherent;
+ acb->dma_coherent_handle2 = dma_coherent_handle;
+ reg = (struct MessageUnit_D __iomem *)dma_coherent;
+ acb->pmuD = reg;
+ reg->chip_id = (u32 __iomem *)((unsigned long)
+ acb->mem_base0 + ARCMSR_ARC1214_CHIP_ID);
+ reg->cpu_mem_config = (u32 __iomem *)((unsigned long)
+ acb->mem_base0 + ARCMSR_ARC1214_CPU_MEMORY_CONFIGURATION);
+ reg->i2o_host_interrupt_mask = (u32 __iomem *)((unsigned long)
+ acb->mem_base0 + ARCMSR_ARC1214_I2_HOST_INTERRUPT_MASK);
+ reg->sample_at_reset = (u32 __iomem *)((unsigned long)
+ acb->mem_base0 + ARCMSR_ARC1214_SAMPLE_RESET);
+ reg->reset_request = (u32 __iomem *)((unsigned long)
+ acb->mem_base0 + ARCMSR_ARC1214_RESET_REQUEST);
+ reg->host_int_status = (u32 __iomem *)((unsigned long)
+ acb->mem_base0 + ARCMSR_ARC1214_MAIN_INTERRUPT_STATUS);
+ reg->pcief0_int_enable = (u32 __iomem *)((unsigned long)
+ acb->mem_base0 + ARCMSR_ARC1214_PCIE_F0_INTERRUPT_ENABLE);
+ reg->inbound_msgaddr0 = (u32 __iomem *)((unsigned long)
+ acb->mem_base0 + ARCMSR_ARC1214_INBOUND_MESSAGE0);
+ reg->inbound_msgaddr1 = (u32 __iomem *)((unsigned long)
+ acb->mem_base0 + ARCMSR_ARC1214_INBOUND_MESSAGE1);
+ reg->outbound_msgaddr0 = (u32 __iomem *)((unsigned long)
+ acb->mem_base0 + ARCMSR_ARC1214_OUTBOUND_MESSAGE0);
+ reg->outbound_msgaddr1 = (u32 __iomem *)((unsigned long)
+ acb->mem_base0 + ARCMSR_ARC1214_OUTBOUND_MESSAGE1);
+ reg->inbound_doorbell = (u32 __iomem *)((unsigned long)
+ acb->mem_base0 + ARCMSR_ARC1214_INBOUND_DOORBELL);
+ reg->outbound_doorbell = (u32 __iomem *)((unsigned long)
+ acb->mem_base0 + ARCMSR_ARC1214_OUTBOUND_DOORBELL);
+ reg->outbound_doorbell_enable = (u32 __iomem *)((unsigned long)
+ acb->mem_base0 + ARCMSR_ARC1214_OUTBOUND_DOORBELL_ENABLE);
+ reg->inboundlist_base_low = (u32 __iomem *)((unsigned long)
+ acb->mem_base0 + ARCMSR_ARC1214_INBOUND_LIST_BASE_LOW);
+ reg->inboundlist_base_high = (u32 __iomem *)((unsigned long)
+ acb->mem_base0 + ARCMSR_ARC1214_INBOUND_LIST_BASE_HIGH);
+ reg->inboundlist_write_pointer = (u32 __iomem *)((unsigned long)
+ acb->mem_base0 + ARCMSR_ARC1214_INBOUND_LIST_WRITE_POINTER);
+ reg->outboundlist_base_low = (u32 __iomem *)((unsigned long)
+ acb->mem_base0 + ARCMSR_ARC1214_OUTBOUND_LIST_BASE_LOW);
+ reg->outboundlist_base_high = (u32 __iomem *)((unsigned long)
+ acb->mem_base0 + ARCMSR_ARC1214_OUTBOUND_LIST_BASE_HIGH);
+ reg->outboundlist_copy_pointer = (u32 __iomem *)((unsigned long)
+ acb->mem_base0 + ARCMSR_ARC1214_OUTBOUND_LIST_COPY_POINTER);
+ reg->outboundlist_read_pointer = (u32 __iomem *)((unsigned long)
+ acb->mem_base0 + ARCMSR_ARC1214_OUTBOUND_LIST_READ_POINTER);
+ reg->outboundlist_interrupt_cause = (u32 __iomem *)((unsigned long)
+ acb->mem_base0 + ARCMSR_ARC1214_OUTBOUND_INTERRUPT_CAUSE);
+ reg->outboundlist_interrupt_enable = (u32 __iomem *)((unsigned long)
+ acb->mem_base0 + ARCMSR_ARC1214_OUTBOUND_INTERRUPT_ENABLE);
+ reg->message_wbuffer = (u32 __iomem *)((unsigned long)
+ acb->mem_base0 + ARCMSR_ARC1214_MESSAGE_WBUFFER);
+ reg->message_rbuffer = (u32 __iomem *)((unsigned long)
+ acb->mem_base0 + ARCMSR_ARC1214_MESSAGE_RBUFFER);
+ reg->msgcode_rwbuffer = (u32 __iomem *)((unsigned long)
+ acb->mem_base0 + ARCMSR_ARC1214_MESSAGE_RWBUFFER);
+ iop_firm_model = (char __iomem *)(&reg->msgcode_rwbuffer[15]);
+ iop_firm_version = (char __iomem *)(&reg->msgcode_rwbuffer[17]);
+ iop_device_map = (char __iomem *)(&reg->msgcode_rwbuffer[21]);
+ if (readl(acb->pmuD->outbound_doorbell) &
+ ARCMSR_ARC1214_IOP2DRV_MESSAGE_CMD_DONE) {
+ writel(ARCMSR_ARC1214_IOP2DRV_MESSAGE_CMD_DONE,
+ acb->pmuD->outbound_doorbell);/*clear interrupt*/
+ }
  /* post "get config" instruction */
- writel(ARCMSR_INBOUND_MESG0_GET_CONFIG, &reg->inbound_msgaddr0);
- writel(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE, &reg->inbound_doorbell);
+ writel(ARCMSR_INBOUND_MESG0_GET_CONFIG, reg->inbound_msgaddr0);
  /* wait message ready */
- for (Index = 0; Index < 2000; Index++) {
- if (readl(&reg->outbound_doorbell) & ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE) {
- writel(ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE_DOORBELL_CLEAR,
&reg->outbound_doorbell_clear);/*clear interrupt*/
- break;
- }
- udelay(10);
- } /*max 1 seconds*/
- if (Index >= 2000) {
- printk(KERN_NOTICE "arcmsr%d: wait 'get adapter firmware \
- miscellaneous data' timeout \n", pACB->host->host_no);
+ if (!arcmsr_hbaD_wait_msgint_ready(acb)) {
+ pr_notice("arcmsr%d: wait get adapter firmware "
+ "miscellaneous data timeout\n", acb->host->host_no);
+ dma_free_coherent(&acb->pdev->dev, acb->roundup_ccbsize,
+ acb->dma_coherent2, acb->dma_coherent_handle2);
  return false;
  }
  count = 8;
@@ -2277,62 +3342,100 @@ static bool arcmsr_get_hbc_config(struct
  iop_firm_version++;
  count--;
  }
- printk(KERN_NOTICE "Areca RAID Controller%d: F/W %s & Model %s\n",
- pACB->host->host_no,
- pACB->firm_version,
- pACB->firm_model);
- pACB->firm_request_len = readl(&reg->msgcode_rwbuffer[1]);
/*firm_request_len,1,04-07*/
- pACB->firm_numbers_queue = readl(&reg->msgcode_rwbuffer[2]);
/*firm_numbers_queue,2,08-11*/
- pACB->firm_sdram_size = readl(&reg->msgcode_rwbuffer[3]);
/*firm_sdram_size,3,12-15*/
- pACB->firm_hd_channels = readl(&reg->msgcode_rwbuffer[4]);
/*firm_ide_channels,4,16-19*/
- pACB->firm_cfg_version = readl(&reg->msgcode_rwbuffer[25]);
/*firm_cfg_version,25,100-103*/
- /*all interrupt service will be enable at arcmsr_iop_init*/
+ count = 16;
+ while (count) {
+ *acb_device_map = readb(iop_device_map);
+ acb_device_map++;
+ iop_device_map++;
+ count--;
+ }
+ acb->signature = readl(&reg->msgcode_rwbuffer[1]);
+ /*firm_signature,1,00-03*/
+ acb->firm_request_len = readl(&reg->msgcode_rwbuffer[2]);
+ /*firm_request_len,1,04-07*/
+ acb->firm_numbers_queue = readl(&reg->msgcode_rwbuffer[3]);
+ /*firm_numbers_queue,2,08-11*/
+ acb->firm_sdram_size = readl(&reg->msgcode_rwbuffer[4]);
+ /*firm_sdram_size,3,12-15*/
+ acb->firm_hd_channels = readl(&reg->msgcode_rwbuffer[5]);
+ /*firm_hd_channels,4,16-19*/
+ acb->firm_cfg_version = readl(&reg->msgcode_rwbuffer[25]);
+ pr_notice("Areca RAID Controller%d: Model %s, F/W %s\n",
+ acb->host->host_no,
+ acb->firm_model,
+ acb->firm_version);
  return true;
 }
-static bool arcmsr_get_firmware_spec(struct AdapterControlBlock *acb)
+
+static bool
+arcmsr_get_firmware_spec(struct AdapterControlBlock *acb)
 {
- if (acb->adapter_type == ACB_ADAPTER_TYPE_A)
- return arcmsr_get_hba_config(acb);
- else if (acb->adapter_type == ACB_ADAPTER_TYPE_B)
- return arcmsr_get_hbb_config(acb);
+ bool rtn = false;
+ switch (acb->adapter_type) {
+ case ACB_ADAPTER_TYPE_A:
+ rtn = arcmsr_hbaA_get_config(acb);
+ break;
+ case ACB_ADAPTER_TYPE_B:
+ rtn = arcmsr_hbaB_get_config(acb);
+ break;
+ case ACB_ADAPTER_TYPE_C:
+ rtn = arcmsr_hbaC_get_config(acb);
+ break;
+ case ACB_ADAPTER_TYPE_D:
+ rtn = arcmsr_hbaD_get_config(acb);
+ break;
+ default:
+ break;
+ }
+ if(acb->firm_numbers_queue > ARCMSR_MAX_FREECCB_NUM)
+ acb->maxOutstanding = ARCMSR_MAX_FREECCB_NUM-1;
  else
- return arcmsr_get_hbc_config(acb);
+ acb->maxOutstanding = acb->firm_numbers_queue - 1;
+ return rtn;
 }

-static int arcmsr_polling_hba_ccbdone(struct AdapterControlBlock *acb,
+static int
+arcmsr_hbaA_polling_ccbdone(struct AdapterControlBlock *acb,
  struct CommandControlBlock *poll_ccb)
 {
  struct MessageUnit_A __iomem *reg = acb->pmuA;
  struct CommandControlBlock *ccb;
  struct ARCMSR_CDB *arcmsr_cdb;
- uint32_t flag_ccb, outbound_intstatus, poll_ccb_done = 0, poll_count = 0;
+ uint32_t flag_ccb, outbound_intstatus, poll_ccb_done = 0;
+ uint32_t poll_count = 0;
  int rtn;
  bool error;
  polling_hba_ccb_retry:
  poll_count++;
- outbound_intstatus = readl(&reg->outbound_intstatus) &
acb->outbound_int_enable;
- writel(outbound_intstatus, &reg->outbound_intstatus);/*clear interrupt*/
+ outbound_intstatus = readl(&reg->outbound_intstatus) &
+ acb->outbound_int_enable;
+ writel(outbound_intstatus, &reg->outbound_intstatus);
  while (1) {
- if ((flag_ccb = readl(&reg->outbound_queueport)) == 0xFFFFFFFF) {
- if (poll_ccb_done){
+ flag_ccb = readl(&reg->outbound_queueport);
+ if (flag_ccb == 0xFFFFFFFF) {
+ if (poll_ccb_done) {
  rtn = SUCCESS;
  break;
- }else {
+ } else {
  msleep(25);
- if (poll_count > 100){
+ if (poll_count > 100) {
  rtn = FAILED;
  break;
  }
  goto polling_hba_ccb_retry;
  }
  }
- arcmsr_cdb = (struct ARCMSR_CDB *)(acb->vir2phy_offset + (flag_ccb << 5));
- ccb = container_of(arcmsr_cdb, struct CommandControlBlock, arcmsr_cdb);
+ arcmsr_cdb = (struct ARCMSR_CDB *)(acb->vir2phy_offset +
+ (flag_ccb << 5));
+ ccb = container_of(arcmsr_cdb, struct CommandControlBlock,
+ arcmsr_cdb);
  poll_ccb_done = (ccb == poll_ccb) ? 1:0;
  if ((ccb->acb != acb) || (ccb->startdone != ARCMSR_CCB_START)) {
- if ((ccb->startdone == ARCMSR_CCB_ABORTED) || (ccb == poll_ccb)) {
- printk(KERN_NOTICE "arcmsr%d: scsi id = %d lun = %d ccb = '0x%p'"
- " poll command abort successfully \n"
+ if ((ccb->startdone == ARCMSR_CCB_ABORTED) ||
+ (ccb == poll_ccb)) {
+ pr_notice("arcmsr%d: scsi id = %d "
+ "lun = %d ccb = '0x%p' poll command "
+ "abort successfully\n"
  , acb->host->host_no
  , ccb->pcmd->device->id
  , ccb->pcmd->device->lun
@@ -2341,24 +3444,26 @@ static int arcmsr_polling_hba_ccbdone(st
  arcmsr_ccb_complete(ccb);
  continue;
  }
- printk(KERN_NOTICE "arcmsr%d: polling get an illegal ccb"
- " command done ccb = '0x%p'"
- "ccboutstandingcount = %d \n"
+ pr_notice("arcmsr%d: polling get an illegal "
+ "ccb command done ccb = '0x%p' "
+ "ccboutstandingcount = %d\n"
  , acb->host->host_no
  , ccb
  , atomic_read(&acb->ccboutstandingcount));
  continue;
  }
- error = (flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR_MODE0) ? true : false;
+ error = (flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR_MODE0) ?
+ true : false;
  arcmsr_report_ccb_state(acb, ccb, error);
  }
  return rtn;
 }

-static int arcmsr_polling_hbb_ccbdone(struct AdapterControlBlock *acb,
- struct CommandControlBlock *poll_ccb)
+int
+arcmsr_hbaB_polling_ccbdone(struct AdapterControlBlock *acb,
+ struct CommandControlBlock *poll_ccb)
 {
- struct MessageUnit_B *reg = acb->pmuB;
+ struct MessageUnit_B __iomem *reg = acb->pmuB;
  struct ARCMSR_CDB *arcmsr_cdb;
  struct CommandControlBlock *ccb;
  uint32_t flag_ccb, poll_ccb_done = 0, poll_count = 0;
@@ -2368,16 +3473,18 @@ static int arcmsr_polling_hbb_ccbdone(st

  poll_count++;
  /* clear doorbell interrupt */
- writel(ARCMSR_DOORBELL_INT_CLEAR_PATTERN, reg->iop2drv_doorbell);
- while(1){
+ writel(ARCMSR_DOORBELL_INT_CLEAR_PATTERN,
+ reg->iop2drv_doorbell);
+ while (1) {
  index = reg->doneq_index;
- if ((flag_ccb = readl(&reg->done_qbuffer[index])) == 0) {
- if (poll_ccb_done){
+ flag_ccb = readl(&reg->done_qbuffer[index]);
+ if (flag_ccb == 0) {
+ if (poll_ccb_done) {
  rtn = SUCCESS;
  break;
- }else {
+ } else {
  msleep(25);
- if (poll_count > 100){
+ if (poll_count > 100) {
  rtn = FAILED;
  break;
  }
@@ -2390,38 +3497,47 @@ static int arcmsr_polling_hbb_ccbdone(st
  index %= ARCMSR_MAX_HBB_POSTQUEUE;
  reg->doneq_index = index;
  /* check if command done with no error*/
- arcmsr_cdb = (struct ARCMSR_CDB *)(acb->vir2phy_offset + (flag_ccb << 5));
- ccb = container_of(arcmsr_cdb, struct CommandControlBlock, arcmsr_cdb);
- poll_ccb_done = (ccb == poll_ccb) ? 1:0;
- if ((ccb->acb != acb) || (ccb->startdone != ARCMSR_CCB_START)) {
- if ((ccb->startdone == ARCMSR_CCB_ABORTED) || (ccb == poll_ccb)) {
- printk(KERN_NOTICE "arcmsr%d: scsi id = %d lun = %d ccb = '0x%p'"
- " poll command abort successfully \n"
- ,acb->host->host_no
- ,ccb->pcmd->device->id
- ,ccb->pcmd->device->lun
- ,ccb);
+ arcmsr_cdb = (struct ARCMSR_CDB *)
+ (acb->vir2phy_offset + (flag_ccb << 5));
+ ccb = container_of(arcmsr_cdb,
+ struct CommandControlBlock,
+ arcmsr_cdb);
+ poll_ccb_done = (ccb == poll_ccb) ? 1 : 0;
+ if ((ccb->acb != acb) ||
+ (ccb->startdone != ARCMSR_CCB_START)) {
+ if ((ccb->startdone == ARCMSR_CCB_ABORTED) ||
+ (ccb == poll_ccb)) {
+ pr_notice("arcmsr%d: "
+ "scsi id = %d lun = %d ccb = '0x%p' poll "
+ "command abort successfully\n"
+ , acb->host->host_no
+ , ccb->pcmd->device->id
+ , ccb->pcmd->device->lun
+ , ccb);
  ccb->pcmd->result = DID_ABORT << 16;
  arcmsr_ccb_complete(ccb);
  continue;
  }
- printk(KERN_NOTICE "arcmsr%d: polling get an illegal ccb"
- " command done ccb = '0x%p'"
- "ccboutstandingcount = %d \n"
+ pr_notice("arcmsr%d: polling get an "
+ "illegal ccb command done ccb = '0x%p' "
+ "ccboutstandingcount = %d\n"
  , acb->host->host_no
  , ccb
  , atomic_read(&acb->ccboutstandingcount));
  continue;
  }
- error = (flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR_MODE0) ? true : false;
+ error = (flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR_MODE0)
+ ? true : false;
  arcmsr_report_ccb_state(acb, ccb, error);
  }
  return rtn;
 }

-static int arcmsr_polling_hbc_ccbdone(struct AdapterControlBlock
*acb, struct CommandControlBlock *poll_ccb)
+static int
+arcmsr_hbaC_polling_ccbdone(struct AdapterControlBlock *acb,
+ struct CommandControlBlock *poll_ccb)
 {
- struct MessageUnit_C *reg = (struct MessageUnit_C *)acb->pmuC;
+ struct MessageUnit_C __iomem *reg = acb->pmuC;
  uint32_t flag_ccb, ccb_cdb_phy;
  struct ARCMSR_CDB *arcmsr_cdb;
  bool error;
@@ -2431,7 +3547,8 @@ static int arcmsr_polling_hbc_ccbdone(st
 polling_hbc_ccb_retry:
  poll_count++;
  while (1) {
- if ((readl(&reg->host_int_status) &
ARCMSR_HBCMU_OUTBOUND_POSTQUEUE_ISR) == 0) {
+ if ((readl(&reg->host_int_status) &
+ ARCMSR_HBCMU_OUTBOUND_POSTQUEUE_ISR) == 0) {
  if (poll_ccb_done) {
  rtn = SUCCESS;
  break;
@@ -2446,74 +3563,180 @@ polling_hbc_ccb_retry:
  }
  flag_ccb = readl(&reg->outbound_queueport_low);
  ccb_cdb_phy = (flag_ccb & 0xFFFFFFF0);
- arcmsr_cdb = (struct ARCMSR_CDB *)(acb->vir2phy_offset +
ccb_cdb_phy);/*frame must be 32 bytes aligned*/
- pCCB = container_of(arcmsr_cdb, struct CommandControlBlock, arcmsr_cdb);
+ arcmsr_cdb = (struct ARCMSR_CDB *)(acb->vir2phy_offset
+ + ccb_cdb_phy);
+ pCCB = container_of(arcmsr_cdb, struct CommandControlBlock,
+ arcmsr_cdb);
  poll_ccb_done = (pCCB == poll_ccb) ? 1 : 0;
  /* check ifcommand done with no error*/
- if ((pCCB->acb != acb) || (pCCB->startdone != ARCMSR_CCB_START)) {
+ if ((pCCB->acb != acb) ||
+ (pCCB->startdone != ARCMSR_CCB_START)) {
  if (pCCB->startdone == ARCMSR_CCB_ABORTED) {
- printk(KERN_NOTICE "arcmsr%d: scsi id = %d lun = %d ccb = '0x%p'"
- " poll command abort successfully \n"
+ pr_notice("arcmsr%d: "
+ "scsi id = %d lun = %d ccb = '0x%p' poll "
+ "command abort successfully\n"
  , acb->host->host_no
  , pCCB->pcmd->device->id
  , pCCB->pcmd->device->lun
  , pCCB);
- pCCB->pcmd->result = DID_ABORT << 16;
- arcmsr_ccb_complete(pCCB);
+ pCCB->pcmd->result = DID_ABORT << 16;
+ arcmsr_ccb_complete(pCCB);
  continue;
  }
- printk(KERN_NOTICE "arcmsr%d: polling get an illegal ccb"
- " command done ccb = '0x%p'"
- "ccboutstandingcount = %d \n"
+ pr_notice("arcmsr%d: polling get an illegal "
+ "ccb command done ccb = '0x%p' "
+ "ccboutstandingcount = %d\n"
  , acb->host->host_no
  , pCCB
  , atomic_read(&acb->ccboutstandingcount));
  continue;
  }
- error = (flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR_MODE1) ? true : false;
+ error = (flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR_MODE1)
+ ? true : false;
  arcmsr_report_ccb_state(acb, pCCB, error);
  }
  return rtn;
 }
-static int arcmsr_polling_ccbdone(struct AdapterControlBlock *acb,
- struct CommandControlBlock *poll_ccb)
+
+static int
+arcmsr_hbaD_polling_ccbdone(struct AdapterControlBlock *acb,
+ struct CommandControlBlock *poll_ccb)
 {
- int rtn = 0;
- switch (acb->adapter_type) {
+ bool error;
+ uint32_t poll_ccb_done = 0, poll_count = 0, flag_ccb, ccb_cdb_phy;
+ int rtn, doneq_index, index_stripped, outbound_write_pointer;
+ unsigned long flags;
+ struct ARCMSR_CDB *arcmsr_cdb;
+ struct CommandControlBlock *pCCB;
+ struct MessageUnit_D __iomem *pmu = acb->pmuD;

- case ACB_ADAPTER_TYPE_A: {
- rtn = arcmsr_polling_hba_ccbdone(acb, poll_ccb);
+ spin_lock_irqsave(&acb->doneq_lock, flags);
+ polling_hbaD_ccb_retry:
+ poll_count++;
+ while (1) {
+ outbound_write_pointer =
+ pmu->done_qbuffer[0].addressLow + 1;
+ doneq_index = pmu->doneq_index;
+ if ((outbound_write_pointer & 0xFFF) == (doneq_index & 0xFFF)) {
+ if (poll_ccb_done) {
+ rtn = SUCCESS;
+ break;
+ } else {
+ msleep(25);
+ if (poll_count > 100) {
+ rtn = FAILED;
+ break;
+ }
+ goto polling_hbaD_ccb_retry;
+ }
  }
- break;
-
- case ACB_ADAPTER_TYPE_B: {
- rtn = arcmsr_polling_hbb_ccbdone(acb, poll_ccb);
+ if (doneq_index & 0x4000) {
+ index_stripped = doneq_index & 0xFFF;
+ index_stripped += 1;
+ index_stripped %= ARCMSR_MAX_ARC1214_DONEQUEUE;
+ pmu->doneq_index = index_stripped ? (index_stripped | 0x4000)
+ : (index_stripped + 1);
+ } else {
+ index_stripped = doneq_index;
+ index_stripped += 1;
+ index_stripped %= ARCMSR_MAX_ARC1214_DONEQUEUE;
+ pmu->doneq_index = index_stripped ? index_stripped :
+ ((index_stripped | 0x4000) + 1);
+ }
+ doneq_index = pmu->doneq_index;
+ flag_ccb = pmu->done_qbuffer[doneq_index & 0xFFF].addressLow;
+ ccb_cdb_phy = (flag_ccb & 0xFFFFFFF0);
+ arcmsr_cdb = (struct ARCMSR_CDB *)(acb->vir2phy_offset +
+ ccb_cdb_phy);
+ pCCB = container_of(arcmsr_cdb,
+ struct CommandControlBlock, arcmsr_cdb);
+ poll_ccb_done = (pCCB == poll_ccb) ? 1 : 0;
+ if ((pCCB->acb != acb) ||
+ (pCCB->startdone != ARCMSR_CCB_START)) {
+ if (pCCB->startdone == ARCMSR_CCB_ABORTED) {
+ pr_notice("arcmsr%d: scsi id = %d "
+ "lun = %d ccb = '0x%p' poll command "
+ "abort successfully\n"
+ , acb->host->host_no
+ , pCCB->pcmd->device->id
+ , pCCB->pcmd->device->lun
+ , pCCB);
+ pCCB->pcmd->result = DID_ABORT << 16;
+ arcmsr_ccb_complete(pCCB);
+ continue;
+ }
+ pr_notice("arcmsr%d: polling an illegal "
+ "ccb command done ccb = '0x%p' "
+ "ccboutstandingcount = %d\n"
+ , acb->host->host_no
+ , pCCB
+ , atomic_read(&acb->ccboutstandingcount));
+ continue;
  }
+ error = (flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR_MODE1)
+ ? true : false;
+ arcmsr_report_ccb_state(acb, pCCB, error);
+ }
+ spin_unlock_irqrestore(&acb->doneq_lock, flags);
+ return rtn;
+}
+
+static int
+arcmsr_polling_ccbdone(struct AdapterControlBlock *acb,
+ struct CommandControlBlock *poll_ccb)
+{
+ int rtn = 0;
+ switch (acb->adapter_type) {
+ case ACB_ADAPTER_TYPE_A:{
+ rtn = arcmsr_hbaA_polling_ccbdone(acb, poll_ccb);
+ break;
+ }
+ case ACB_ADAPTER_TYPE_B:{
+ rtn = arcmsr_hbaB_polling_ccbdone(acb, poll_ccb);
  break;
+ }
  case ACB_ADAPTER_TYPE_C: {
- rtn = arcmsr_polling_hbc_ccbdone(acb, poll_ccb);
- }
+ rtn = arcmsr_hbaC_polling_ccbdone(acb, poll_ccb);
+ break;
+ }
+ case ACB_ADAPTER_TYPE_D: {
+ rtn = arcmsr_hbaD_polling_ccbdone(acb, poll_ccb);
+ break;
+ }
  }
  return rtn;
 }

-static int arcmsr_iop_confirm(struct AdapterControlBlock *acb)
+static int
+arcmsr_iop_confirm(struct AdapterControlBlock *acb)
 {
- uint32_t cdb_phyaddr, cdb_phyaddr_hi32;
+ uint32_t cdb_phyaddr, cdb_phyaddr_hi32, cdb_phyaddr_lo32;
  dma_addr_t dma_coherent_handle;
  /*
  ********************************************************************
- ** here we need to tell iop 331 our freeccb.HighPart
+ ** Here we need to tell iop our freeccb.HighPart
  ** if freeccb.HighPart is not zero
  ********************************************************************
  */
- dma_coherent_handle = acb->dma_coherent_handle;
- cdb_phyaddr = (uint32_t)(dma_coherent_handle);
+ switch (acb->adapter_type) {
+ case ACB_ADAPTER_TYPE_A:
+ case ACB_ADAPTER_TYPE_B:
+ case ACB_ADAPTER_TYPE_C:
+ dma_coherent_handle = acb->dma_coherent_handle;
+ break;
+ case ACB_ADAPTER_TYPE_D:
+ dma_coherent_handle = acb->dma_coherent_handle2;
+ break;
+ default:
+ dma_coherent_handle = acb->dma_coherent_handle;
+ break;
+ }
+ cdb_phyaddr_lo32 = (uint32_t)(dma_coherent_handle & 0xffffffff);
  cdb_phyaddr_hi32 = (uint32_t)((cdb_phyaddr >> 16) >> 16);
  acb->cdb_phyaddr_hi32 = cdb_phyaddr_hi32;
  /*
  ***********************************************************************
- **    if adapter type B, set window of "post command Q"
+ ** if adapter type B D set window of "post command Q"
  ***********************************************************************
  */
  switch (acb->adapter_type) {
@@ -2521,20 +3744,17 @@ static int arcmsr_iop_confirm(struct Ada
  case ACB_ADAPTER_TYPE_A: {
  if (cdb_phyaddr_hi32 != 0) {
  struct MessageUnit_A __iomem *reg = acb->pmuA;
- uint32_t intmask_org;
- intmask_org = arcmsr_disable_outbound_ints(acb);
- writel(ARCMSR_SIGNATURE_SET_CONFIG, \
- &reg->message_rwbuffer[0]);
+ writel(ARCMSR_SIGNATURE_SET_CONFIG,
+ &reg->message_rwbuffer[0]);
  writel(cdb_phyaddr_hi32, &reg->message_rwbuffer[1]);
- writel(ARCMSR_INBOUND_MESG0_SET_CONFIG, \
- &reg->inbound_msgaddr0);
- if (!arcmsr_hba_wait_msgint_ready(acb)) {
- printk(KERN_NOTICE "arcmsr%d: ""set ccb high \
- part physical address timeout\n",
- acb->host->host_no);
+ writel(ARCMSR_INBOUND_MESG0_SET_CONFIG,
+ &reg->inbound_msgaddr0);
+ if (!arcmsr_hbaA_wait_msgint_ready(acb)) {
+ pr_notice("arcmsr%d: set ccb "
+ "high part physical address timeout\n",
+ acb->host->host_no);
  return 1;
  }
- arcmsr_enable_outbound_ints(acb, intmask_org);
  }
  }
  break;
@@ -2543,18 +3763,17 @@ static int arcmsr_iop_confirm(struct Ada
  unsigned long post_queue_phyaddr;
  uint32_t __iomem *rwbuffer;

- struct MessageUnit_B *reg = acb->pmuB;
- uint32_t intmask_org;
- intmask_org = arcmsr_disable_outbound_ints(acb);
+ struct MessageUnit_B __iomem *reg = acb->pmuB;
  reg->postq_index = 0;
  reg->doneq_index = 0;
- writel(ARCMSR_MESSAGE_SET_POST_WINDOW, reg->drv2iop_doorbell);
- if (!arcmsr_hbb_wait_msgint_ready(acb)) {
- printk(KERN_NOTICE "arcmsr%d:can not set diver mode\n", \
+ writel(ARCMSR_MESSAGE_SET_POST_WINDOW,
+ reg->drv2iop_doorbell);
+ if (!arcmsr_hbaB_wait_msgint_ready(acb)) {
+ pr_notice("arcmsr%d:can not set diver mode\n",
  acb->host->host_no);
  return 1;
  }
- post_queue_phyaddr = acb->dma_coherent_handle_hbb_mu;
+ post_queue_phyaddr = acb->dma_coherent_handle2;
  rwbuffer = reg->message_rwbuffer;
  /* driver "set config" signature */
  writel(ARCMSR_SIGNATURE_SET_CONFIG, rwbuffer++);
@@ -2566,39 +3785,64 @@ static int arcmsr_iop_confirm(struct Ada
  writel(post_queue_phyaddr + 1056, rwbuffer++);
  /* ccb maxQ size must be --> [(256 + 8)*4]*/
  writel(1056, rwbuffer);
-
  writel(ARCMSR_MESSAGE_SET_CONFIG, reg->drv2iop_doorbell);
- if (!arcmsr_hbb_wait_msgint_ready(acb)) {
- printk(KERN_NOTICE "arcmsr%d: 'set command Q window' \
- timeout \n",acb->host->host_no);
+ if (!arcmsr_hbaB_wait_msgint_ready(acb)) {
+ pr_notice("arcmsr%d: 'set command Q window' "
+ "timeout\n", acb->host->host_no);
  return 1;
  }
  arcmsr_hbb_enable_driver_mode(acb);
- arcmsr_enable_outbound_ints(acb, intmask_org);
  }
  break;
  case ACB_ADAPTER_TYPE_C: {
+ struct MessageUnit_C __iomem *reg = acb->pmuC;
  if (cdb_phyaddr_hi32 != 0) {
- struct MessageUnit_C *reg = (struct MessageUnit_C *)acb->pmuC;
-
- printk(KERN_NOTICE "arcmsr%d: cdb_phyaddr_hi32=0x%x\n",
- acb->adapter_index, cdb_phyaddr_hi32);
- writel(ARCMSR_SIGNATURE_SET_CONFIG, &reg->msgcode_rwbuffer[0]);
- writel(cdb_phyaddr_hi32, &reg->msgcode_rwbuffer[1]);
- writel(ARCMSR_INBOUND_MESG0_SET_CONFIG, &reg->inbound_msgaddr0);
- writel(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE, &reg->inbound_doorbell);
- if (!arcmsr_hbc_wait_msgint_ready(acb)) {
- printk(KERN_NOTICE "arcmsr%d: 'set command Q window' \
- timeout \n", acb->host->host_no);
+ pr_notice("arcmsr%d: cdb_phyaddr_hi32 = 0x%x\n",
+ acb->adapter_index, cdb_phyaddr_hi32);
+ writel(ARCMSR_SIGNATURE_SET_CONFIG,
+ &reg->msgcode_rwbuffer[0]);
+ writel(cdb_phyaddr_hi32,
+ &reg->msgcode_rwbuffer[1]);
+ writel(ARCMSR_INBOUND_MESG0_SET_CONFIG,
+ &reg->inbound_msgaddr0);
+ writel(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE,
+ &reg->inbound_doorbell);
+ if (!arcmsr_hbaC_wait_msgint_ready(acb)) {
+ pr_notice("arcmsr%d: 'set "
+ "command Q window' timeout\n",
+ acb->host->host_no);
  return 1;
  }
  }
  }
+ break;
+ case ACB_ADAPTER_TYPE_D: {
+ uint32_t __iomem *rwbuffer;
+
+ struct MessageUnit_D __iomem *reg = acb->pmuD;
+ reg->postq_index = 0;
+ reg->doneq_index = 0;
+ rwbuffer = reg->msgcode_rwbuffer;
+ writel(ARCMSR_SIGNATURE_SET_CONFIG, rwbuffer++);
+ writel(cdb_phyaddr_hi32, rwbuffer++);
+ writel(cdb_phyaddr_lo32, rwbuffer++);
+ writel(cdb_phyaddr_lo32 +
+ (ARCMSR_MAX_ARC1214_POSTQUEUE * sizeof(struct InBound_SRB)),
+ rwbuffer++);
+ writel(0x100, rwbuffer);
+ writel(ARCMSR_INBOUND_MESG0_SET_CONFIG,
+ reg->inbound_msgaddr0);
+ if (!arcmsr_hbaD_wait_msgint_ready(acb))
+ pr_notice("arcmsr%d: 'set command Q "
+ "window' timeout\n", acb->host->host_no);
+ break;
+ }
  }
  return 0;
 }

-static void arcmsr_wait_firmware_ready(struct AdapterControlBlock *acb)
+static void
+arcmsr_wait_firmware_ready(struct AdapterControlBlock *acb)
 {
  uint32_t firmware_state = 0;
  switch (acb->adapter_type) {
@@ -2607,161 +3851,259 @@ static void arcmsr_wait_firmware_ready(s
  struct MessageUnit_A __iomem *reg = acb->pmuA;
  do {
  firmware_state = readl(&reg->outbound_msgaddr1);
- } while ((firmware_state & ARCMSR_OUTBOUND_MESG1_FIRMWARE_OK) == 0);
+ } while ((firmware_state &
+ ARCMSR_OUTBOUND_MESG1_FIRMWARE_OK) == 0);
  }
  break;
-
  case ACB_ADAPTER_TYPE_B: {
- struct MessageUnit_B *reg = acb->pmuB;
+ struct MessageUnit_B __iomem *reg = acb->pmuB;
  do {
  firmware_state = readl(reg->iop2drv_doorbell);
  } while ((firmware_state & ARCMSR_MESSAGE_FIRMWARE_OK) == 0);
- writel(ARCMSR_DRV2IOP_END_OF_INTERRUPT, reg->drv2iop_doorbell);
+ writel(ARCMSR_DRV2IOP_END_OF_INTERRUPT,
+ reg->drv2iop_doorbell);
  }
  break;
  case ACB_ADAPTER_TYPE_C: {
- struct MessageUnit_C *reg = (struct MessageUnit_C *)acb->pmuC;
+ struct MessageUnit_C __iomem *reg = acb->pmuC;
  do {
  firmware_state = readl(&reg->outbound_msgaddr1);
- } while ((firmware_state & ARCMSR_HBCMU_MESSAGE_FIRMWARE_OK) == 0);
+ } while ((firmware_state &
+ ARCMSR_HBCMU_MESSAGE_FIRMWARE_OK) == 0);
  }
+ break;
+ case ACB_ADAPTER_TYPE_D: {
+ struct MessageUnit_D __iomem *reg = acb->pmuD;
+ do {
+ firmware_state = readl(reg->outbound_msgaddr1);
+ } while ((firmware_state &
+ ARCMSR_ARC1214_MESSAGE_FIRMWARE_OK) == 0);
+ break;
+ }
  }
 }

-static void arcmsr_request_hba_device_map(struct AdapterControlBlock *acb)
+static void
+arcmsr_hbaA_request_device_map(struct AdapterControlBlock *acb)
 {
  struct MessageUnit_A __iomem *reg = acb->pmuA;
- if (unlikely(atomic_read(&acb->rq_map_token) == 0) ||
((acb->acb_flags & ACB_F_BUS_RESET) != 0 ) || ((acb->acb_flags &
ACB_F_ABORT) != 0 )){
- mod_timer(&acb->eternal_timer, jiffies + msecs_to_jiffies(6 * HZ));
+ if (unlikely(atomic_read(&acb->rq_map_token) == 0) ||
+ ((acb->acb_flags & ACB_F_BUS_RESET) != 0)
+ || ((acb->acb_flags & ACB_F_ABORT) != 0)) {
+ mod_timer(&acb->eternal_timer,
+ jiffies + msecs_to_jiffies(6 * HZ));
  return;
  } else {
  acb->fw_flag = FW_NORMAL;
- if (atomic_read(&acb->ante_token_value) == atomic_read(&acb->rq_map_token)){
+ if (atomic_read(&acb->ante_token_value) ==
+ atomic_read(&acb->rq_map_token)) {
  atomic_set(&acb->rq_map_token, 16);
  }
- atomic_set(&acb->ante_token_value, atomic_read(&acb->rq_map_token));
+ atomic_set(&acb->ante_token_value,
+ atomic_read(&acb->rq_map_token));
  if (atomic_dec_and_test(&acb->rq_map_token)) {
- mod_timer(&acb->eternal_timer, jiffies + msecs_to_jiffies(6 * HZ));
+ mod_timer(&acb->eternal_timer,
+ jiffies + msecs_to_jiffies(6 * HZ));
  return;
  }
- writel(ARCMSR_INBOUND_MESG0_GET_CONFIG, &reg->inbound_msgaddr0);
- mod_timer(&acb->eternal_timer, jiffies + msecs_to_jiffies(6 * HZ));
+ writel(ARCMSR_INBOUND_MESG0_GET_CONFIG,
+ &reg->inbound_msgaddr0);
+ mod_timer(&acb->eternal_timer, jiffies +
+ msecs_to_jiffies(6 * HZ));
  }
- return;
 }

-static void arcmsr_request_hbb_device_map(struct AdapterControlBlock *acb)
+static void
+arcmsr_hbaB_request_device_map(struct AdapterControlBlock *acb)
 {
  struct MessageUnit_B __iomem *reg = acb->pmuB;
- if (unlikely(atomic_read(&acb->rq_map_token) == 0) ||
((acb->acb_flags & ACB_F_BUS_RESET) != 0 ) || ((acb->acb_flags &
ACB_F_ABORT) != 0 )){
- mod_timer(&acb->eternal_timer, jiffies + msecs_to_jiffies(6 * HZ));
+ if (unlikely(atomic_read(&acb->rq_map_token) == 0) ||
+ ((acb->acb_flags & ACB_F_BUS_RESET) != 0) ||
+ ((acb->acb_flags & ACB_F_ABORT) != 0)) {
+ mod_timer(&acb->eternal_timer, jiffies +
+ msecs_to_jiffies(6 * HZ));
  return;
  } else {
  acb->fw_flag = FW_NORMAL;
- if (atomic_read(&acb->ante_token_value) == atomic_read(&acb->rq_map_token)) {
+ if (atomic_read(&acb->ante_token_value) ==
+ atomic_read(&acb->rq_map_token)) {
  atomic_set(&acb->rq_map_token, 16);
  }
- atomic_set(&acb->ante_token_value, atomic_read(&acb->rq_map_token));
+ atomic_set(&acb->ante_token_value,
+ atomic_read(&acb->rq_map_token));
  if (atomic_dec_and_test(&acb->rq_map_token)) {
- mod_timer(&acb->eternal_timer, jiffies + msecs_to_jiffies(6 * HZ));
+ mod_timer(&acb->eternal_timer,
+ jiffies + msecs_to_jiffies(6 * HZ));
  return;
  }
- writel(ARCMSR_MESSAGE_GET_CONFIG, reg->drv2iop_doorbell);
- mod_timer(&acb->eternal_timer, jiffies + msecs_to_jiffies(6 * HZ));
+ writel(ARCMSR_MESSAGE_GET_CONFIG,
+ reg->drv2iop_doorbell);
+ mod_timer(&acb->eternal_timer, jiffies +
+ msecs_to_jiffies(6 * HZ));
  }
- return;
 }

-static void arcmsr_request_hbc_device_map(struct AdapterControlBlock *acb)
+static void
+arcmsr_hbaC_request_device_map(struct AdapterControlBlock *acb)
 {
  struct MessageUnit_C __iomem *reg = acb->pmuC;
- if (unlikely(atomic_read(&acb->rq_map_token) == 0) ||
((acb->acb_flags & ACB_F_BUS_RESET) != 0) || ((acb->acb_flags &
ACB_F_ABORT) != 0)) {
- mod_timer(&acb->eternal_timer, jiffies + msecs_to_jiffies(6 * HZ));
+ if (unlikely(atomic_read(&acb->rq_map_token) == 0) ||
+ ((acb->acb_flags & ACB_F_BUS_RESET) != 0) ||
+ ((acb->acb_flags & ACB_F_ABORT) != 0)) {
+ mod_timer(&acb->eternal_timer, jiffies +
+ msecs_to_jiffies(6 * HZ));
  return;
  } else {
  acb->fw_flag = FW_NORMAL;
- if (atomic_read(&acb->ante_token_value) == atomic_read(&acb->rq_map_token)) {
+ if (atomic_read(&acb->ante_token_value) ==
+ atomic_read(&acb->rq_map_token)) {
  atomic_set(&acb->rq_map_token, 16);
  }
- atomic_set(&acb->ante_token_value, atomic_read(&acb->rq_map_token));
+ atomic_set(&acb->ante_token_value,
+ atomic_read(&acb->rq_map_token));
  if (atomic_dec_and_test(&acb->rq_map_token)) {
- mod_timer(&acb->eternal_timer, jiffies + msecs_to_jiffies(6 * HZ));
+ mod_timer(&acb->eternal_timer,
+ jiffies + msecs_to_jiffies(6 * HZ));
  return;
  }
- writel(ARCMSR_INBOUND_MESG0_GET_CONFIG, &reg->inbound_msgaddr0);
- writel(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE, &reg->inbound_doorbell);
- mod_timer(&acb->eternal_timer, jiffies + msecs_to_jiffies(6 * HZ));
+ writel(ARCMSR_INBOUND_MESG0_GET_CONFIG,
+ &reg->inbound_msgaddr0);
+ writel(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE,
+ &reg->inbound_doorbell);
+ mod_timer(&acb->eternal_timer, jiffies +
+ msecs_to_jiffies(6 * HZ));
+ }
+}
+
+static void
+arcmsr_hbaD_request_device_map(struct AdapterControlBlock *acb)
+{
+ struct MessageUnit_D __iomem *reg = acb->pmuD;
+ if (unlikely(atomic_read(&acb->rq_map_token) == 0) ||
+ ((acb->acb_flags & ACB_F_BUS_RESET) != 0) ||
+ ((acb->acb_flags & ACB_F_ABORT) != 0)) {
+ mod_timer(&acb->eternal_timer,
+ jiffies + msecs_to_jiffies(6 * HZ));
+ } else {
+ acb->fw_flag = FW_NORMAL;
+ if (atomic_read(&acb->ante_token_value) ==
+ atomic_read(&acb->rq_map_token)) {
+ atomic_set(&acb->rq_map_token, 16);
+ }
+ atomic_set(&acb->ante_token_value,
+ atomic_read(&acb->rq_map_token));
+ if (atomic_dec_and_test(&acb->rq_map_token)) {
+ mod_timer(&acb->eternal_timer, jiffies +
+ msecs_to_jiffies(6 * HZ));
+ return;
+ }
+ writel(ARCMSR_INBOUND_MESG0_GET_CONFIG,
+ reg->inbound_msgaddr0);
+ mod_timer(&acb->eternal_timer, jiffies +
+ msecs_to_jiffies(6 * HZ));
  }
- return;
 }

-static void arcmsr_request_device_map(unsigned long pacb)
+static void
+arcmsr_request_device_map(unsigned long pacb)
 {
- struct AdapterControlBlock *acb = (struct AdapterControlBlock *)pacb;
+ struct AdapterControlBlock *acb =
+ (struct AdapterControlBlock *)pacb;
  switch (acb->adapter_type) {
  case ACB_ADAPTER_TYPE_A: {
- arcmsr_request_hba_device_map(acb);
+ arcmsr_hbaA_request_device_map(acb);
+ break;
  }
- break;
  case ACB_ADAPTER_TYPE_B: {
- arcmsr_request_hbb_device_map(acb);
+ arcmsr_hbaB_request_device_map(acb);
+ break;
  }
- break;
  case ACB_ADAPTER_TYPE_C: {
- arcmsr_request_hbc_device_map(acb);
+ arcmsr_hbaC_request_device_map(acb);
+ break;
+ }
+ case ACB_ADAPTER_TYPE_D: {
+ arcmsr_hbaD_request_device_map(acb);
+ break;
  }
  }
 }

-static void arcmsr_start_hba_bgrb(struct AdapterControlBlock *acb)
+static void
+arcmsr_hbaA_start_bgrb(struct AdapterControlBlock *acb)
 {
  struct MessageUnit_A __iomem *reg = acb->pmuA;
  acb->acb_flags |= ACB_F_MSG_START_BGRB;
- writel(ARCMSR_INBOUND_MESG0_START_BGRB, &reg->inbound_msgaddr0);
- if (!arcmsr_hba_wait_msgint_ready(acb)) {
- printk(KERN_NOTICE "arcmsr%d: wait 'start adapter background \
- rebulid' timeout \n", acb->host->host_no);
+ writel(ARCMSR_INBOUND_MESG0_START_BGRB,
+ &reg->inbound_msgaddr0);
+ if (!arcmsr_hbaA_wait_msgint_ready(acb)) {
+ pr_notice("arcmsr%d: wait 'start adapter "
+ "background rebulid' timeout\n", acb->host->host_no);
  }
 }

-static void arcmsr_start_hbb_bgrb(struct AdapterControlBlock *acb)
+static void
+arcmsr_hbaB_start_bgrb(struct AdapterControlBlock *acb)
 {
- struct MessageUnit_B *reg = acb->pmuB;
+ struct MessageUnit_B __iomem *reg = acb->pmuB;
  acb->acb_flags |= ACB_F_MSG_START_BGRB;
  writel(ARCMSR_MESSAGE_START_BGRB, reg->drv2iop_doorbell);
- if (!arcmsr_hbb_wait_msgint_ready(acb)) {
- printk(KERN_NOTICE "arcmsr%d: wait 'start adapter background \
- rebulid' timeout \n",acb->host->host_no);
+ if (!arcmsr_hbaB_wait_msgint_ready(acb)) {
+ pr_notice("arcmsr%d: wait 'start adapter "
+ "backgroundrebulid' timeout\n", acb->host->host_no);
  }
 }

-static void arcmsr_start_hbc_bgrb(struct AdapterControlBlock *pACB)
+static void
+arcmsr_hbaC_start_bgrb(struct AdapterControlBlock *pACB)
 {
- struct MessageUnit_C *phbcmu = (struct MessageUnit_C *)pACB->pmuC;
+ struct MessageUnit_C __iomem *phbcmu = pACB->pmuC;
  pACB->acb_flags |= ACB_F_MSG_START_BGRB;
- writel(ARCMSR_INBOUND_MESG0_START_BGRB, &phbcmu->inbound_msgaddr0);
- writel(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE, &phbcmu->inbound_doorbell);
- if (!arcmsr_hbc_wait_msgint_ready(pACB)) {
- printk(KERN_NOTICE "arcmsr%d: wait 'start adapter background \
- rebulid' timeout \n", pACB->host->host_no);
+ writel(ARCMSR_INBOUND_MESG0_START_BGRB,
+ &phbcmu->inbound_msgaddr0);
+ writel(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE,
+ &phbcmu->inbound_doorbell);
+ if (!arcmsr_hbaC_wait_msgint_ready(pACB)) {
+ pr_notice("arcmsr%d: wait 'start adapter "
+ "background rebulid' timeout\n", pACB->host->host_no);
  }
  return;
 }
-static void arcmsr_start_adapter_bgrb(struct AdapterControlBlock *acb)
+
+static void
+arcmsr_hbaD_start_bgrb(struct AdapterControlBlock *pACB)
+{
+ struct MessageUnit_D __iomem *pmu = pACB->pmuD;
+ pACB->acb_flags |= ACB_F_MSG_START_BGRB;
+ writel(ARCMSR_INBOUND_MESG0_START_BGRB, pmu->inbound_msgaddr0);
+ if (!arcmsr_hbaD_wait_msgint_ready(pACB)) {
+ pr_notice("arcmsr%d: wait 'start adapter "
+ "background rebulid' timeout\n", pACB->host->host_no);
+ }
+ return;
+}
+
+static void
+arcmsr_start_adapter_bgrb(struct AdapterControlBlock *acb)
 {
  switch (acb->adapter_type) {
  case ACB_ADAPTER_TYPE_A:
- arcmsr_start_hba_bgrb(acb);
+ arcmsr_hbaA_start_bgrb(acb);
  break;
  case ACB_ADAPTER_TYPE_B:
- arcmsr_start_hbb_bgrb(acb);
+ arcmsr_hbaB_start_bgrb(acb);
  break;
  case ACB_ADAPTER_TYPE_C:
- arcmsr_start_hbc_bgrb(acb);
+ arcmsr_hbaC_start_bgrb(acb);
+ break;
+ case ACB_ADAPTER_TYPE_D:
+ arcmsr_hbaD_start_bgrb(acb);
+ break;
  }
 }

-static void arcmsr_clear_doorbell_queue_buffer(struct AdapterControlBlock *acb)
+static void
+arcmsr_clear_doorbell_queue_buffer(struct AdapterControlBlock *acb)
 {
  switch (acb->adapter_type) {
  case ACB_ADAPTER_TYPE_A: {
@@ -2771,65 +4113,107 @@ static void arcmsr_clear_doorbell_queue_
  outbound_doorbell = readl(&reg->outbound_doorbell);
  /*clear doorbell interrupt */
  writel(outbound_doorbell, &reg->outbound_doorbell);
- writel(ARCMSR_INBOUND_DRIVER_DATA_READ_OK, &reg->inbound_doorbell);
+ writel(ARCMSR_INBOUND_DRIVER_DATA_READ_OK,
+ &reg->inbound_doorbell);
  }
  break;

  case ACB_ADAPTER_TYPE_B: {
- struct MessageUnit_B *reg = acb->pmuB;
+ struct MessageUnit_B __iomem *reg = acb->pmuB;
  /*clear interrupt and message state*/
- writel(ARCMSR_MESSAGE_INT_CLEAR_PATTERN, reg->iop2drv_doorbell);
- writel(ARCMSR_DRV2IOP_DATA_READ_OK, reg->drv2iop_doorbell);
+ writel(ARCMSR_MESSAGE_INT_CLEAR_PATTERN,
+ reg->iop2drv_doorbell);
+ writel(ARCMSR_DRV2IOP_DATA_READ_OK,
+ reg->drv2iop_doorbell);
  /* let IOP know data has been read */
  }
  break;
  case ACB_ADAPTER_TYPE_C: {
- struct MessageUnit_C *reg = (struct MessageUnit_C *)acb->pmuC;
- uint32_t outbound_doorbell;
+ struct MessageUnit_C __iomem *reg = acb->pmuC;
+ uint32_t outbound_doorbell, i;
  /* empty doorbell Qbuffer if door bell ringed */
  outbound_doorbell = readl(&reg->outbound_doorbell);
  writel(outbound_doorbell, &reg->outbound_doorbell_clear);
- writel(ARCMSR_HBCMU_DRV2IOP_DATA_READ_OK, &reg->inbound_doorbell);
+ writel(ARCMSR_HBCMU_DRV2IOP_DATA_READ_OK,
+ &reg->inbound_doorbell);
+ for (i = 0; i < 200; i++) {
+ msleep(20);
+ outbound_doorbell = readl(&reg->outbound_doorbell);
+ if (outbound_doorbell & ARCMSR_HBCMU_IOP2DRV_DATA_WRITE_OK) {
+ writel(outbound_doorbell,
+ &reg->outbound_doorbell_clear);
+ writel(ARCMSR_HBCMU_DRV2IOP_DATA_READ_OK,
+ &reg->inbound_doorbell);
+ } else
+ break;
+ }
+ }
+ break;
+ case ACB_ADAPTER_TYPE_D: {
+ struct MessageUnit_D __iomem *reg = acb->pmuD;
+ uint32_t outbound_doorbell, i;
+ /* empty doorbell Qbuffer if door bell ringed */
+ outbound_doorbell = readl(reg->outbound_doorbell);
+ writel(outbound_doorbell, reg->outbound_doorbell);
+ writel(ARCMSR_ARC1214_DRV2IOP_DATA_OUT_READ,
+ reg->inbound_doorbell);
+ for (i = 0; i < 200; i++) {
+ msleep(20);
+ outbound_doorbell = readl(reg->outbound_doorbell);
+ if (outbound_doorbell & ARCMSR_ARC1214_IOP2DRV_DATA_WRITE_OK) {
+ writel(outbound_doorbell,
+ reg->outbound_doorbell);
+ writel(ARCMSR_ARC1214_DRV2IOP_DATA_OUT_READ,
+ reg->inbound_doorbell);
+ } else
+ break;
  }
+ break;
+ }
  }
 }

-static void arcmsr_enable_eoi_mode(struct AdapterControlBlock *acb)
+static void
+arcmsr_enable_eoi_mode(struct AdapterControlBlock *acb)
 {
  switch (acb->adapter_type) {
  case ACB_ADAPTER_TYPE_A:
+ case ACB_ADAPTER_TYPE_C:
+ case ACB_ADAPTER_TYPE_D:
  return;
- case ACB_ADAPTER_TYPE_B:
- {
- struct MessageUnit_B *reg = acb->pmuB;
- writel(ARCMSR_MESSAGE_ACTIVE_EOI_MODE, reg->drv2iop_doorbell);
- if (!arcmsr_hbb_wait_msgint_ready(acb)) {
- printk(KERN_NOTICE "ARCMSR IOP enables EOI_MODE TIMEOUT");
+ case ACB_ADAPTER_TYPE_B: {
+ struct MessageUnit_B __iomem *reg = acb->pmuB;
+ writel(ARCMSR_MESSAGE_ACTIVE_EOI_MODE,
+ reg->drv2iop_doorbell);
+ if (!arcmsr_hbaB_wait_msgint_ready(acb)) {
+ pr_notice("ARCMSR IOP "
+ "enables EOI_MODE TIMEOUT");
  return;
  }
- }
- break;
- case ACB_ADAPTER_TYPE_C:
- return;
+ }
+ break;
  }
  return;
 }

-static void arcmsr_hardware_reset(struct AdapterControlBlock *acb)
+static void
+arcmsr_hardware_reset(struct AdapterControlBlock *acb)
 {
  uint8_t value[64];
  int i, count = 0;
  struct MessageUnit_A __iomem *pmuA = acb->pmuA;
  struct MessageUnit_C __iomem *pmuC = acb->pmuC;
-
+ u32 temp = 0;
  /* backup pci config data */
- printk(KERN_NOTICE "arcmsr%d: executing hw bus reset .....\n",
acb->host->host_no);
+ pr_notice("arcmsr%d: executing hw bus reset .....\n",
+ acb->host->host_no);
  for (i = 0; i < 64; i++) {
  pci_read_config_byte(acb->pdev, i, &value[i]);
  }
  /* hardware reset signal */
  if ((acb->dev_id == 0x1680)) {
- writel(ARCMSR_ARC1680_BUS_RESET, &pmuA->reserved1[0]);
+ writel(ARCMSR_ARC1680_BUS_RESET,
+ &pmuA->reserved1[0]);
  } else if ((acb->dev_id == 0x1880)) {
  do {
  count++;
@@ -2839,8 +4223,11 @@ static void arcmsr_hardware_reset(struct
  writel(0x2, &pmuC->write_sequence);
  writel(0x7, &pmuC->write_sequence);
  writel(0xD, &pmuC->write_sequence);
- } while (((readl(&pmuC->host_diagnostic) &
ARCMSR_ARC1880_DiagWrite_ENABLE) == 0) && (count < 5));
- writel(ARCMSR_ARC1880_RESET_ADAPTER, &pmuC->host_diagnostic);
+ } while ((((temp = readl(&pmuC->host_diagnostic)) &
+ ARCMSR_ARC1880_DiagWrite_ENABLE) == 0) &&
+ (count < 5));
+ writel(ARCMSR_ARC1880_RESET_ADAPTER,
+ &pmuC->host_diagnostic);
  } else {
  pci_write_config_byte(acb->pdev, 0x84, 0x20);
  }
@@ -2852,7 +4239,9 @@ static void arcmsr_hardware_reset(struct
  msleep(1000);
  return;
 }
-static void arcmsr_iop_init(struct AdapterControlBlock *acb)
+
+static void
+arcmsr_iop_init(struct AdapterControlBlock *acb)
 {
  uint32_t intmask_org;
  /* disable all outbound interrupt */
@@ -2869,7 +4258,8 @@ static void arcmsr_iop_init(struct Adapt
  acb->acb_flags |= ACB_F_IOP_INITED;
 }

-static uint8_t arcmsr_iop_reset(struct AdapterControlBlock *acb)
+static uint8_t
+arcmsr_iop_reset(struct AdapterControlBlock *acb)
 {
  struct CommandControlBlock *ccb;
  uint32_t intmask_org;
@@ -2892,7 +4282,8 @@ static uint8_t arcmsr_iop_reset(struct A
  ccb->ccb_flags = 0;
  spin_lock_irqsave(&acb->ccblist_lock, flags);
  list_add_tail(&ccb->list, &acb->ccb_free_list);
- spin_unlock_irqrestore(&acb->ccblist_lock, flags);
+ spin_unlock_irqrestore(&acb->ccblist_lock,
+ flags);
  }
  }
  atomic_set(&acb->ccboutstandingcount, 0);
@@ -2903,147 +4294,235 @@ static uint8_t arcmsr_iop_reset(struct A
  return rtnval;
 }

-static int arcmsr_bus_reset(struct scsi_cmnd *cmd)
+static int
+arcmsr_bus_reset(struct scsi_cmnd *cmd)
 {
  struct AdapterControlBlock *acb;
  uint32_t intmask_org, outbound_doorbell;
  int retry_count = 0;
  int rtn = FAILED;
  acb = (struct AdapterControlBlock *) cmd->device->host->hostdata;
- printk(KERN_ERR "arcmsr: executing bus reset eh.....num_resets = %d,
num_aborts = %d \n", acb->num_resets, acb->num_aborts);
+ pr_err("arcmsr: executing bus reset eh.....num_resets = %d, "
+ "num_aborts = %d\n", acb->num_resets, acb->num_aborts);
  acb->num_resets++;

- switch(acb->adapter_type){
- case ACB_ADAPTER_TYPE_A:{
- if (acb->acb_flags & ACB_F_BUS_RESET){
- long timeout;
- printk(KERN_ERR "arcmsr: there is an  bus reset eh proceeding.......\n");
- timeout = wait_event_timeout(wait_q, (acb->acb_flags &
ACB_F_BUS_RESET) == 0, 220*HZ);
- if (timeout) {
- return SUCCESS;
- }
- }
- acb->acb_flags |= ACB_F_BUS_RESET;
- if (!arcmsr_iop_reset(acb)) {
- struct MessageUnit_A __iomem *reg;
- reg = acb->pmuA;
- arcmsr_hardware_reset(acb);
- acb->acb_flags &= ~ACB_F_IOP_INITED;
+ switch (acb->adapter_type) {
+ case ACB_ADAPTER_TYPE_A: {
+ if (acb->acb_flags & ACB_F_BUS_RESET) {
+ long timeout;
+ pr_err("arcmsr: there is an bus "
+ "reset eh proceeding.......\n");
+ timeout = wait_event_timeout(wait_q,
+ (acb->acb_flags & ACB_F_BUS_RESET)
+ == 0, 220 * HZ);
+ if (timeout)
+ return SUCCESS;
+ }
+ acb->acb_flags |= ACB_F_BUS_RESET;
+ if (!arcmsr_iop_reset(acb)) {
+ struct MessageUnit_A __iomem *reg;
+ reg = acb->pmuA;
+ arcmsr_hardware_reset(acb);
+ acb->acb_flags &= ~ACB_F_IOP_INITED;
 sleep_again:
- ssleep(ARCMSR_SLEEPTIME);
- if ((readl(&reg->outbound_msgaddr1) &
ARCMSR_OUTBOUND_MESG1_FIRMWARE_OK) == 0) {
- printk(KERN_ERR "arcmsr%d: waiting for hw bus reset return,
retry=%d\n", acb->host->host_no, retry_count);
- if (retry_count > ARCMSR_RETRYCOUNT) {
- acb->fw_flag = FW_DEADLOCK;
- printk(KERN_ERR "arcmsr%d: waiting for hw bus reset return, RETRY
TERMINATED!!\n", acb->host->host_no);
- return FAILED;
- }
- retry_count++;
- goto sleep_again;
+ ssleep(ARCMSR_SLEEPTIME);
+ if ((readl(&reg->outbound_msgaddr1) &
+ ARCMSR_OUTBOUND_MESG1_FIRMWARE_OK) == 0) {
+ pr_err("arcmsr%d: waiting for "
+ "hw bus reset return, retry = %d\n",
+ acb->host->host_no, retry_count);
+ if (retry_count > ARCMSR_RETRYCOUNT) {
+ acb->fw_flag = FW_DEADLOCK;
+ pr_err("arcmsr%d: waiting "
+ "for hw bus reset return, "
+ "RETRY TERMINATED!!\n",
+ acb->host->host_no);
+ return FAILED;
  }
- acb->acb_flags |= ACB_F_IOP_INITED;
- /* disable all outbound interrupt */
- intmask_org = arcmsr_disable_outbound_ints(acb);
- arcmsr_get_firmware_spec(acb);
- arcmsr_start_adapter_bgrb(acb);
- /* clear Qbuffer if door bell ringed */
- outbound_doorbell = readl(&reg->outbound_doorbell);
- writel(outbound_doorbell, &reg->outbound_doorbell); /*clear interrupt */
-   writel(ARCMSR_INBOUND_DRIVER_DATA_READ_OK, &reg->inbound_doorbell);
- /* enable outbound Post Queue,outbound doorbell Interrupt */
- arcmsr_enable_outbound_ints(acb, intmask_org);
- atomic_set(&acb->rq_map_token, 16);
- atomic_set(&acb->ante_token_value, 16);
- acb->fw_flag = FW_NORMAL;
- mod_timer(&acb->eternal_timer, jiffies + msecs_to_jiffies(6 * HZ));
- acb->acb_flags &= ~ACB_F_BUS_RESET;
- rtn = SUCCESS;
- printk(KERN_ERR "arcmsr: scsi  bus reset eh returns with success\n");
- } else {
- acb->acb_flags &= ~ACB_F_BUS_RESET;
- atomic_set(&acb->rq_map_token, 16);
- atomic_set(&acb->ante_token_value, 16);
- acb->fw_flag = FW_NORMAL;
- mod_timer(&acb->eternal_timer, jiffies + msecs_to_jiffies(6*HZ));
- rtn = SUCCESS;
+ retry_count++;
+ goto sleep_again;
  }
- break;
+ acb->acb_flags |= ACB_F_IOP_INITED;
+ /* disable all outbound interrupt */
+ intmask_org = arcmsr_disable_outbound_ints(acb);
+ arcmsr_get_firmware_spec(acb);
+ arcmsr_start_adapter_bgrb(acb);
+ /* clear Qbuffer if door bell ringed */
+ outbound_doorbell = readl(&reg->outbound_doorbell);
+ writel(outbound_doorbell, &reg->outbound_doorbell);
+ writel(ARCMSR_INBOUND_DRIVER_DATA_READ_OK,
+ &reg->inbound_doorbell);
+ arcmsr_enable_outbound_ints(acb, intmask_org);
+ atomic_set(&acb->rq_map_token, 16);
+ atomic_set(&acb->ante_token_value, 16);
+ acb->fw_flag = FW_NORMAL;
+ mod_timer(&acb->eternal_timer, jiffies +
+ msecs_to_jiffies(6 * HZ));
+ acb->acb_flags &= ~ACB_F_BUS_RESET;
+ rtn = SUCCESS;
+ pr_err("arcmsr: scsi bus reset eh "
+ "returns with success\n");
+ } else {
+ acb->acb_flags &= ~ACB_F_BUS_RESET;
+ atomic_set(&acb->rq_map_token, 16);
+ atomic_set(&acb->ante_token_value, 16);
+ acb->fw_flag = FW_NORMAL;
+ mod_timer(&acb->eternal_timer,
+ jiffies + msecs_to_jiffies(6 * HZ));
+ rtn = SUCCESS;
  }
- case ACB_ADAPTER_TYPE_B:{
- acb->acb_flags |= ACB_F_BUS_RESET;
- if (!arcmsr_iop_reset(acb)) {
- acb->acb_flags &= ~ACB_F_BUS_RESET;
- rtn = FAILED;
- } else {
- acb->acb_flags &= ~ACB_F_BUS_RESET;
- atomic_set(&acb->rq_map_token, 16);
- atomic_set(&acb->ante_token_value, 16);
- acb->fw_flag = FW_NORMAL;
- mod_timer(&acb->eternal_timer, jiffies + msecs_to_jiffies(6 * HZ));
- rtn = SUCCESS;
- }
- break;
+ break;
+ }
+ case ACB_ADAPTER_TYPE_B: {
+ acb->acb_flags |= ACB_F_BUS_RESET;
+ if (!arcmsr_iop_reset(acb)) {
+ acb->acb_flags &= ~ACB_F_BUS_RESET;
+ rtn = FAILED;
+ } else {
+ acb->acb_flags &= ~ACB_F_BUS_RESET;
+ atomic_set(&acb->rq_map_token, 16);
+ atomic_set(&acb->ante_token_value, 16);
+ acb->fw_flag = FW_NORMAL;
+ mod_timer(&acb->eternal_timer,
+ jiffies + msecs_to_jiffies(6 * HZ));
+ rtn = SUCCESS;
  }
- case ACB_ADAPTER_TYPE_C:{
- if (acb->acb_flags & ACB_F_BUS_RESET) {
- long timeout;
- printk(KERN_ERR "arcmsr: there is an bus reset eh proceeding.......\n");
- timeout = wait_event_timeout(wait_q, (acb->acb_flags &
ACB_F_BUS_RESET) == 0, 220*HZ);
- if (timeout) {
- return SUCCESS;
+ break;
+ }
+ case ACB_ADAPTER_TYPE_C: {
+ if (acb->acb_flags & ACB_F_BUS_RESET) {
+ long timeout;
+ pr_err("arcmsr: there is an bus "
+ "reset eh proceeding.......\n");
+ timeout = wait_event_timeout(wait_q,
+ (acb->acb_flags & ACB_F_BUS_RESET) == 0,
+ 220 * HZ);
+ if (timeout)
+ return SUCCESS;
+ }
+ acb->acb_flags |= ACB_F_BUS_RESET;
+ if (!arcmsr_iop_reset(acb)) {
+ struct MessageUnit_C __iomem *reg;
+ reg = acb->pmuC;
+ arcmsr_hardware_reset(acb);
+ acb->acb_flags &= ~ACB_F_IOP_INITED;
+sleep:
+ ssleep(ARCMSR_SLEEPTIME);
+ if ((readl(&reg->host_diagnostic) & 0x04) != 0) {
+ pr_err("arcmsr%d: waiting "
+ "for hw bus reset return, retry = %d\n",
+ acb->host->host_no, retry_count);
+ if (retry_count > ARCMSR_RETRYCOUNT) {
+ acb->fw_flag = FW_DEADLOCK;
+ pr_err("arcmsr%d: "
+ "waiting for hw bus reset return, "
+ "RETRY TERMINATED!!\n",
+ acb->host->host_no);
+ return FAILED;
  }
+ retry_count++;
+ goto sleep;
  }
- acb->acb_flags |= ACB_F_BUS_RESET;
- if (!arcmsr_iop_reset(acb)) {
- struct MessageUnit_C __iomem *reg;
- reg = acb->pmuC;
- arcmsr_hardware_reset(acb);
- acb->acb_flags &= ~ACB_F_IOP_INITED;
-sleep:
- ssleep(ARCMSR_SLEEPTIME);
- if ((readl(&reg->host_diagnostic) & 0x04) != 0) {
- printk(KERN_ERR "arcmsr%d: waiting for hw bus reset return,
retry=%d\n", acb->host->host_no, retry_count);
- if (retry_count > ARCMSR_RETRYCOUNT) {
- acb->fw_flag = FW_DEADLOCK;
- printk(KERN_ERR "arcmsr%d: waiting for hw bus reset return, RETRY
TERMINATED!!\n", acb->host->host_no);
- return FAILED;
- }
- retry_count++;
- goto sleep;
+ acb->acb_flags |= ACB_F_IOP_INITED;
+ /* disable all outbound interrupt */
+ intmask_org =
+ arcmsr_disable_outbound_ints(acb);
+ arcmsr_get_firmware_spec(acb);
+ arcmsr_start_adapter_bgrb(acb);
+ /* clear Qbuffer if door bell ringed */
+ outbound_doorbell =
+ readl(&reg->outbound_doorbell);
+ writel(outbound_doorbell,
+ &reg->outbound_doorbell_clear);
+ writel(ARCMSR_HBCMU_DRV2IOP_DATA_READ_OK,
+ &reg->inbound_doorbell);
+ arcmsr_enable_outbound_ints(acb,
+ intmask_org);
+ atomic_set(&acb->rq_map_token, 16);
+ atomic_set(&acb->ante_token_value, 16);
+ acb->fw_flag = FW_NORMAL;
+ mod_timer(&acb->eternal_timer, jiffies +
+ msecs_to_jiffies(6 * HZ));
+ acb->acb_flags &= ~ACB_F_BUS_RESET;
+ rtn = SUCCESS;
+ pr_err("arcmsr: scsi bus reset "
+ "eh returns with success\n");
+ } else {
+ acb->acb_flags &= ~ACB_F_BUS_RESET;
+ atomic_set(&acb->rq_map_token, 16);
+ atomic_set(&acb->ante_token_value, 16);
+ acb->fw_flag = FW_NORMAL;
+ mod_timer(&acb->eternal_timer, jiffies +
+ msecs_to_jiffies(6 * HZ));
+ rtn = SUCCESS;
+ }
+ break;
+ }
+ case ACB_ADAPTER_TYPE_D: {
+ if (acb->acb_flags & ACB_F_BUS_RESET) {
+ long timeout;
+ pr_notice("arcmsr: there is an bus reset eh proceeding.......\n");
+ timeout = wait_event_timeout(wait_q, (acb->acb_flags
+ & ACB_F_BUS_RESET) == 0, 220 * HZ);
+ if (timeout)
+ return SUCCESS;
+ }
+ acb->acb_flags |= ACB_F_BUS_RESET;
+ if (!arcmsr_iop_reset(acb)) {
+ struct MessageUnit_D __iomem *reg;
+ reg = acb->pmuD;
+ arcmsr_hardware_reset(acb);
+ acb->acb_flags &= ~ACB_F_IOP_INITED;
+ nap:
+ ssleep(ARCMSR_SLEEPTIME);
+ if ((readl(reg->sample_at_reset) & 0x80) != 0) {
+ pr_err("arcmsr%d: waiting for "
+ "hw bus reset return, retry=%d\n",
+ acb->host->host_no, retry_count);
+ if (retry_count > ARCMSR_RETRYCOUNT) {
+ acb->fw_flag = FW_DEADLOCK;
+ pr_err("arcmsr%d: "
+ "waiting for hw bus reset return, "
+ "RETRY TERMINATED!!\n",
+ acb->host->host_no);
+ return FAILED;
  }
- acb->acb_flags |= ACB_F_IOP_INITED;
- /* disable all outbound interrupt */
- intmask_org = arcmsr_disable_outbound_ints(acb);
- arcmsr_get_firmware_spec(acb);
- arcmsr_start_adapter_bgrb(acb);
- /* clear Qbuffer if door bell ringed */
- outbound_doorbell = readl(&reg->outbound_doorbell);
- writel(outbound_doorbell, &reg->outbound_doorbell_clear); /*clear interrupt */
- writel(ARCMSR_HBCMU_DRV2IOP_DATA_READ_OK, &reg->inbound_doorbell);
- /* enable outbound Post Queue,outbound doorbell Interrupt */
- arcmsr_enable_outbound_ints(acb, intmask_org);
- atomic_set(&acb->rq_map_token, 16);
- atomic_set(&acb->ante_token_value, 16);
- acb->fw_flag = FW_NORMAL;
- mod_timer(&acb->eternal_timer, jiffies + msecs_to_jiffies(6 * HZ));
- acb->acb_flags &= ~ACB_F_BUS_RESET;
- rtn = SUCCESS;
- printk(KERN_ERR "arcmsr: scsi bus reset eh returns with success\n");
- } else {
- acb->acb_flags &= ~ACB_F_BUS_RESET;
- atomic_set(&acb->rq_map_token, 16);
- atomic_set(&acb->ante_token_value, 16);
- acb->fw_flag = FW_NORMAL;
- mod_timer(&acb->eternal_timer, jiffies + msecs_to_jiffies(6*HZ));
- rtn = SUCCESS;
+ retry_count++;
+ goto nap;
  }
- break;
+ acb->acb_flags |= ACB_F_IOP_INITED;
+ /* disable all outbound interrupt */
+ intmask_org = arcmsr_disable_outbound_ints(acb);
+ arcmsr_get_firmware_spec(acb);
+ arcmsr_start_adapter_bgrb(acb);
+ arcmsr_clear_doorbell_queue_buffer(acb);
+ arcmsr_enable_outbound_ints(acb, intmask_org);
+ atomic_set(&acb->rq_map_token, 16);
+ atomic_set(&acb->ante_token_value, 16);
+ acb->fw_flag = FW_NORMAL;
+ mod_timer(&acb->eternal_timer,
+ jiffies + msecs_to_jiffies(6 * HZ));
+ acb->acb_flags &= ~ACB_F_BUS_RESET;
+ rtn = SUCCESS;
+ pr_err("arcmsr: scsi bus reset "
+ "eh returns with success\n");
+ } else {
+ acb->acb_flags &= ~ACB_F_BUS_RESET;
+ atomic_set(&acb->rq_map_token, 16);
+ atomic_set(&acb->ante_token_value, 16);
+ acb->fw_flag = FW_NORMAL;
+ mod_timer(&acb->eternal_timer,
+ jiffies + msecs_to_jiffies(6 * HZ));
+ rtn = SUCCESS;
  }
+ break;
+ }
  }
  return rtn;
 }

-static int arcmsr_abort_one_cmd(struct AdapterControlBlock *acb,
+static int
+arcmsr_abort_one_cmd(struct AdapterControlBlock *acb,
  struct CommandControlBlock *ccb)
 {
  int rtn;
@@ -3051,15 +4530,17 @@ static int arcmsr_abort_one_cmd(struct A
  return rtn;
 }

-static int arcmsr_abort(struct scsi_cmnd *cmd)
+static int
+arcmsr_abort(struct scsi_cmnd *cmd)
 {
- struct AdapterControlBlock *acb =
- (struct AdapterControlBlock *)cmd->device->host->hostdata;
+ struct AdapterControlBlock *acb = (struct AdapterControlBlock *)
+ cmd->device->host->hostdata;
  int i = 0;
  int rtn = FAILED;
- printk(KERN_NOTICE
- "arcmsr%d: abort device command of scsi id = %d lun = %d \n",
- acb->host->host_no, cmd->device->id, cmd->device->lun);
+ pr_notice("arcmsr%d: abort device command of "
+ "scsi id = %d lun = %d\n",
+ acb->host->host_no,
+ cmd->device->id, cmd->device->lun);
  acb->acb_flags |= ACB_F_ABORT;
  acb->num_aborts++;
  /*
@@ -3073,7 +4554,8 @@ static int arcmsr_abort(struct scsi_cmnd

  for (i = 0; i < ARCMSR_MAX_FREECCB_NUM; i++) {
  struct CommandControlBlock *ccb = acb->pccb_pool[i];
- if (ccb->startdone == ARCMSR_CCB_START && ccb->pcmd == cmd) {
+ if (ccb->startdone == ARCMSR_CCB_START &&
+ ccb->pcmd == cmd) {
  ccb->startdone = ARCMSR_CCB_ABORTED;
  rtn = arcmsr_abort_one_cmd(acb, ccb);
  break;
@@ -3083,10 +4565,11 @@ static int arcmsr_abort(struct scsi_cmnd
  return rtn;
 }

-static const char *arcmsr_info(struct Scsi_Host *host)
+static const char
+*arcmsr_info(struct Scsi_Host *host)
 {
  struct AdapterControlBlock *acb =
- (struct AdapterControlBlock *) host->hostdata;
+ (struct AdapterControlBlock *)host->hostdata;
  static char buf[256];
  char *type;
  int raid6 = 1;
@@ -3102,6 +4585,7 @@ static const char *arcmsr_info(struct Sc
  case PCI_DEVICE_ID_ARECA_1160:
  case PCI_DEVICE_ID_ARECA_1170:
  case PCI_DEVICE_ID_ARECA_1201:
+ case PCI_DEVICE_ID_ARECA_1214:
  case PCI_DEVICE_ID_ARECA_1220:
  case PCI_DEVICE_ID_ARECA_1230:
  case PCI_DEVICE_ID_ARECA_1260:
@@ -3109,19 +4593,19 @@ static const char *arcmsr_info(struct Sc
  case PCI_DEVICE_ID_ARECA_1280:
  type = "SATA";
  break;
- case PCI_DEVICE_ID_ARECA_1380:
- case PCI_DEVICE_ID_ARECA_1381:
  case PCI_DEVICE_ID_ARECA_1680:
  case PCI_DEVICE_ID_ARECA_1681:
  case PCI_DEVICE_ID_ARECA_1880:
  type = "SAS";
  break;
  default:
- type = "X-TYPE";
+ type = "unknown";
+ raid6 = 0;
  break;
  }
- sprintf(buf, "Areca %s Host Adapter RAID Controller%s\n %s",
- type, raid6 ? "( RAID6 capable)" : "",
- ARCMSR_DRIVER_VERSION);
+ sprintf(buf, "Areca %s Host Adapter RAID Controller%s\narcmsr version %s\n",
+ type, raid6 ? "( RAID6 capable)" : "", ARCMSR_DRIVER_VERSION);
+
  return buf;
 }
+

--001a1133aa8693883304e50eeb28
Content-Type: application/octet-stream; name=patch
Content-Disposition: attachment; filename=patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hkxi1y6q0

ZGlmZiAtdXByTiBhL2RyaXZlcnMvc2NzaS9hcmNtc3IvYXJjbXNyX2F0dHIuYyBiL2RyaXZlcnMv
c2NzaS9hcmNtc3IvYXJjbXNyX2F0dHIuYwotLS0gYS9kcml2ZXJzL3Njc2kvYXJjbXNyL2FyY21z
cl9hdHRyLmMJMjAxMy0wNy0wMSAwNjoxMzoyOC4wMDAwMDAwMDAgKzA4MDAKKysrIGIvZHJpdmVy
cy9zY3NpL2FyY21zci9hcmNtc3JfYXR0ci5jCTIwMTMtMDgtMjkgMTk6NDg6NDAuMDAwMDAwMDAw
ICswODAwCkBAIC01OSw2NCArNTksODcgQEAKIAogc3RydWN0IGRldmljZV9hdHRyaWJ1dGUgKmFy
Y21zcl9ob3N0X2F0dHJzW107CiAKLXN0YXRpYyBzc2l6ZV90IGFyY21zcl9zeXNmc19pb3BfbWVz
c2FnZV9yZWFkKHN0cnVjdCBmaWxlICpmaWxwLAotCQkJCQkgICAgIHN0cnVjdCBrb2JqZWN0ICpr
b2JqLAotCQkJCQkgICAgIHN0cnVjdCBiaW5fYXR0cmlidXRlICpiaW4sCi0JCQkJCSAgICAgY2hh
ciAqYnVmLCBsb2ZmX3Qgb2ZmLAotCQkJCQkgICAgIHNpemVfdCBjb3VudCkKK3N0YXRpYyBzc2l6
ZV90CithcmNtc3Jfc3lzZnNfaW9wX21lc3NhZ2VfcmVhZChzdHJ1Y3QgZmlsZSAqZmlscCwKKwkJ
CQlzdHJ1Y3Qga29iamVjdCAqa29iaiwKKwkJCQlzdHJ1Y3QgYmluX2F0dHJpYnV0ZSAqYmluLAor
CQkJCWNoYXIgKmJ1ZiwgbG9mZl90IG9mZiwKKwkJCQlzaXplX3QgY291bnQpCiB7Ci0Jc3RydWN0
IGRldmljZSAqZGV2ID0gY29udGFpbmVyX29mKGtvYmosc3RydWN0IGRldmljZSxrb2JqKTsKKwlz
dHJ1Y3QgZGV2aWNlICpkZXYgPSBjb250YWluZXJfb2Yoa29iaiwgc3RydWN0IGRldmljZSwga29i
aik7CiAJc3RydWN0IFNjc2lfSG9zdCAqaG9zdCA9IGNsYXNzX3RvX3Nob3N0KGRldik7Ci0Jc3Ry
dWN0IEFkYXB0ZXJDb250cm9sQmxvY2sgKmFjYiA9IChzdHJ1Y3QgQWRhcHRlckNvbnRyb2xCbG9j
ayAqKSBob3N0LT5ob3N0ZGF0YTsKKwlzdHJ1Y3QgQWRhcHRlckNvbnRyb2xCbG9jayAqYWNiID0K
KwkJKHN0cnVjdCBBZGFwdGVyQ29udHJvbEJsb2NrICopaG9zdC0+aG9zdGRhdGE7CiAJdWludDhf
dCAqcFFidWZmZXIsKnB0bXBRYnVmZmVyOwogCWludDMyX3QgYWxseGZlcl9sZW4gPSAwOworCXVu
c2lnbmVkIGxvbmcgZmxhZ3M7CiAKIAlpZiAoIWNhcGFibGUoQ0FQX1NZU19BRE1JTikpCiAJCXJl
dHVybiAtRUFDQ0VTOwogCiAJLyogZG8gbWVzc2FnZSB1bml0IHJlYWQuICovCiAJcHRtcFFidWZm
ZXIgPSAodWludDhfdCAqKWJ1ZjsKLQl3aGlsZSAoKGFjYi0+cnFidWZfZmlyc3RpbmRleCAhPSBh
Y2ItPnJxYnVmX2xhc3RpbmRleCkKLQkJJiYgKGFsbHhmZXJfbGVuIDwgMTAzMSkpIHsKKwlzcGlu
X2xvY2tfaXJxc2F2ZSgmYWNiLT5ycWJ1ZmZlcl9sb2NrLCBmbGFncyk7CisJaWYgKGFjYi0+cnFi
dWZfZmlyc3RpbmRleCAhPSBhY2ItPnJxYnVmX2xhc3RpbmRleCkgewogCQlwUWJ1ZmZlciA9ICZh
Y2ItPnJxYnVmZmVyW2FjYi0+cnFidWZfZmlyc3RpbmRleF07Ci0JCW1lbWNweShwdG1wUWJ1ZmZl
ciwgcFFidWZmZXIsIDEpOwotCQlhY2ItPnJxYnVmX2ZpcnN0aW5kZXgrKzsKLQkJYWNiLT5ycWJ1
Zl9maXJzdGluZGV4ICU9IEFSQ01TUl9NQVhfUUJVRkZFUjsKLQkJcHRtcFFidWZmZXIrKzsKLQkJ
YWxseGZlcl9sZW4rKzsKKwkJaWYgKGFjYi0+cnFidWZfZmlyc3RpbmRleCA+IGFjYi0+cnFidWZf
bGFzdGluZGV4KSB7CisJCQlpZiAoKEFSQ01TUl9NQVhfUUJVRkZFUiAtIGFjYi0+cnFidWZfZmly
c3RpbmRleCkgPj0gMTAzMikgeworCQkJCW1lbWNweSgodm9pZCAqKXB0bXBRYnVmZmVyLCAoY29u
c3Qgdm9pZCAqKXBRYnVmZmVyLCAxMDMyKTsKKwkJCQlhY2ItPnJxYnVmX2ZpcnN0aW5kZXggKz0g
MTAzMjsKKwkJCQlhY2ItPnJxYnVmX2ZpcnN0aW5kZXggJT0gQVJDTVNSX01BWF9RQlVGRkVSOwor
CQkJCWFsbHhmZXJfbGVuID0gMTAzMjsKKwkJCX0gZWxzZSB7CisJCQkJaWYgKCgoQVJDTVNSX01B
WF9RQlVGRkVSIC0gYWNiLT5ycWJ1Zl9maXJzdGluZGV4KSArIGFjYi0+cnFidWZfbGFzdGluZGV4
KSA+IDEwMzIpIHsKKwkJCQkJbWVtY3B5KCh2b2lkICopcHRtcFFidWZmZXIsIChjb25zdCB2b2lk
ICopcFFidWZmZXIsIEFSQ01TUl9NQVhfUUJVRkZFUiAtIGFjYi0+cnFidWZfZmlyc3RpbmRleCk7
CisJCQkJCXB0bXBRYnVmZmVyICs9IEFSQ01TUl9NQVhfUUJVRkZFUiAtIGFjYi0+cnFidWZfZmly
c3RpbmRleDsKKwkJCQkJbWVtY3B5KCh2b2lkICopcHRtcFFidWZmZXIsIChjb25zdCB2b2lkICop
YWNiLT5ycWJ1ZmZlciwgMTAzMiAtIChBUkNNU1JfTUFYX1FCVUZGRVIgLSBhY2ItPnJxYnVmX2Zp
cnN0aW5kZXgpKTsKKwkJCQkJYWNiLT5ycWJ1Zl9maXJzdGluZGV4ID0gMTAzMiAtIChBUkNNU1Jf
TUFYX1FCVUZGRVIgLSBhY2ItPnJxYnVmX2ZpcnN0aW5kZXgpOworCQkJCQlhbGx4ZmVyX2xlbiA9
IDEwMzI7CisJCQkJfSBlbHNlIHsKKwkJCQkJbWVtY3B5KCh2b2lkICopcHRtcFFidWZmZXIsIChj
b25zdCB2b2lkICopcFFidWZmZXIsIEFSQ01TUl9NQVhfUUJVRkZFUiAtIGFjYi0+cnFidWZfZmly
c3RpbmRleCk7CisJCQkJCXB0bXBRYnVmZmVyICs9IEFSQ01TUl9NQVhfUUJVRkZFUiAtIGFjYi0+
cnFidWZfZmlyc3RpbmRleDsKKwkJCQkJbWVtY3B5KCh2b2lkICopcHRtcFFidWZmZXIsIChjb25z
dCB2b2lkICopYWNiLT5ycWJ1ZmZlciwgYWNiLT5ycWJ1Zl9sYXN0aW5kZXgpOworCQkJCQlhbGx4
ZmVyX2xlbiA9IEFSQ01TUl9NQVhfUUJVRkZFUiAtIGFjYi0+cnFidWZfZmlyc3RpbmRleCArIGFj
Yi0+cnFidWZfbGFzdGluZGV4OworCQkJCQlhY2ItPnJxYnVmX2ZpcnN0aW5kZXggPSBhY2ItPnJx
YnVmX2xhc3RpbmRleDsKKwkJCQl9CisJCQl9CisJCX0gZWxzZSB7CisJCQlpZiAoKGFjYi0+cnFi
dWZfbGFzdGluZGV4IC0gYWNiLT5ycWJ1Zl9maXJzdGluZGV4KSA+IDEwMzIpIHsKKwkJCQltZW1j
cHkoKHZvaWQgKilwdG1wUWJ1ZmZlciwgKGNvbnN0IHZvaWQgKilwUWJ1ZmZlciwgMTAzMik7CisJ
CQkJYWNiLT5ycWJ1Zl9maXJzdGluZGV4ICs9IDEwMzI7CisJCQkJYWxseGZlcl9sZW4gPSAxMDMy
OworCQkJfSBlbHNlIHsKKwkJCQltZW1jcHkoKHZvaWQgKilwdG1wUWJ1ZmZlciwgKGNvbnN0IHZv
aWQgKilwUWJ1ZmZlciwgYWNiLT5ycWJ1Zl9sYXN0aW5kZXggLSBhY2ItPnJxYnVmX2ZpcnN0aW5k
ZXgpOworCQkJCWFsbHhmZXJfbGVuID0gYWNiLT5ycWJ1Zl9sYXN0aW5kZXggLSBhY2ItPnJxYnVm
X2ZpcnN0aW5kZXg7CisJCQkJYWNiLT5ycWJ1Zl9maXJzdGluZGV4ID0gYWNiLT5ycWJ1Zl9sYXN0
aW5kZXg7CisJCQl9CisJCX0KIAl9CiAJaWYgKGFjYi0+YWNiX2ZsYWdzICYgQUNCX0ZfSU9QREFU
QV9PVkVSRkxPVykgewogCQlzdHJ1Y3QgUUJVRkZFUiBfX2lvbWVtICpwcmJ1ZmZlcjsKLQkJdWlu
dDhfdCBfX2lvbWVtICppb3BfZGF0YTsKLQkJaW50MzJfdCBpb3BfbGVuOwotCiAJCWFjYi0+YWNi
X2ZsYWdzICY9IH5BQ0JfRl9JT1BEQVRBX09WRVJGTE9XOwogCQlwcmJ1ZmZlciA9IGFyY21zcl9n
ZXRfaW9wX3JxYnVmZmVyKGFjYik7Ci0JCWlvcF9kYXRhID0gcHJidWZmZXItPmRhdGE7Ci0JCWlv
cF9sZW4gPSByZWFkbCgmcHJidWZmZXItPmRhdGFfbGVuKTsKLQkJd2hpbGUgKGlvcF9sZW4gPiAw
KSB7Ci0JCQlhY2ItPnJxYnVmZmVyW2FjYi0+cnFidWZfbGFzdGluZGV4XSA9IHJlYWRiKGlvcF9k
YXRhKTsKLQkJCWFjYi0+cnFidWZfbGFzdGluZGV4Kys7Ci0JCQlhY2ItPnJxYnVmX2xhc3RpbmRl
eCAlPSBBUkNNU1JfTUFYX1FCVUZGRVI7Ci0JCQlpb3BfZGF0YSsrOwotCQkJaW9wX2xlbi0tOwot
CQl9Ci0JCWFyY21zcl9pb3BfbWVzc2FnZV9yZWFkKGFjYik7CisJCWlmIChhcmNtc3JfUmVhZF9p
b3BfcnFidWZmZXJfZGF0YShhY2IsIHByYnVmZmVyKSA9PSAwKQorCQkJYWNiLT5hY2JfZmxhZ3Mg
fD0gQUNCX0ZfSU9QREFUQV9PVkVSRkxPVzsKIAl9Ci0JcmV0dXJuIChhbGx4ZmVyX2xlbik7CisJ
c3Bpbl91bmxvY2tfaXJxcmVzdG9yZSgmYWNiLT5ycWJ1ZmZlcl9sb2NrLCBmbGFncyk7CisJcmV0
dXJuIGFsbHhmZXJfbGVuOwogfQogCi1zdGF0aWMgc3NpemVfdCBhcmNtc3Jfc3lzZnNfaW9wX21l
c3NhZ2Vfd3JpdGUoc3RydWN0IGZpbGUgKmZpbHAsCi0JCQkJCSAgICAgIHN0cnVjdCBrb2JqZWN0
ICprb2JqLAotCQkJCQkgICAgICBzdHJ1Y3QgYmluX2F0dHJpYnV0ZSAqYmluLAotCQkJCQkgICAg
ICBjaGFyICpidWYsIGxvZmZfdCBvZmYsCi0JCQkJCSAgICAgIHNpemVfdCBjb3VudCkKK3N0YXRp
YyBzc2l6ZV90CithcmNtc3Jfc3lzZnNfaW9wX21lc3NhZ2Vfd3JpdGUoc3RydWN0IGZpbGUgKmZp
bHAsCisJCQkJICAgICAgc3RydWN0IGtvYmplY3QgKmtvYmosCisJCQkJICAgICAgc3RydWN0IGJp
bl9hdHRyaWJ1dGUgKmJpbiwKKwkJCQkgICAgICBjaGFyICpidWYsIGxvZmZfdCBvZmYsCisJCQkJ
ICAgICAgc2l6ZV90IGNvdW50KQogewotCXN0cnVjdCBkZXZpY2UgKmRldiA9IGNvbnRhaW5lcl9v
Zihrb2JqLHN0cnVjdCBkZXZpY2Usa29iaik7CisJc3RydWN0IGRldmljZSAqZGV2ID0gY29udGFp
bmVyX29mKGtvYmosIHN0cnVjdCBkZXZpY2UsIGtvYmopOwogCXN0cnVjdCBTY3NpX0hvc3QgKmhv
c3QgPSBjbGFzc190b19zaG9zdChkZXYpOwotCXN0cnVjdCBBZGFwdGVyQ29udHJvbEJsb2NrICph
Y2IgPSAoc3RydWN0IEFkYXB0ZXJDb250cm9sQmxvY2sgKikgaG9zdC0+aG9zdGRhdGE7CisJc3Ry
dWN0IEFkYXB0ZXJDb250cm9sQmxvY2sgKmFjYiA9CisJCShzdHJ1Y3QgQWRhcHRlckNvbnRyb2xC
bG9jayAqKWhvc3QtPmhvc3RkYXRhOwogCWludDMyX3QgbXlfZW1wdHlfbGVuLCB1c2VyX2xlbiwg
d3FidWZfZmlyc3RpbmRleCwgd3FidWZfbGFzdGluZGV4OwogCXVpbnQ4X3QgKnBRYnVmZmVyLCAq
cHRtcHVzZXJidWZmZXI7CisJdW5zaWduZWQgbG9uZyBmbGFnczsKIAogCWlmICghY2FwYWJsZShD
QVBfU1lTX0FETUlOKSkKIAkJcmV0dXJuIC1FQUNDRVM7CkBAIC0xMjUsNjIgKzE0OCw2OSBAQCBz
dGF0aWMgc3NpemVfdCBhcmNtc3Jfc3lzZnNfaW9wX21lc3NhZ2VfCiAJLyogZG8gbWVzc2FnZSB1
bml0IHdyaXRlLiAqLwogCXB0bXB1c2VyYnVmZmVyID0gKHVpbnQ4X3QgKilidWY7CiAJdXNlcl9s
ZW4gPSAoaW50MzJfdCljb3VudDsKKwlzcGluX2xvY2tfaXJxc2F2ZSgmYWNiLT53cWJ1ZmZlcl9s
b2NrLCBmbGFncyk7CiAJd3FidWZfbGFzdGluZGV4ID0gYWNiLT53cWJ1Zl9sYXN0aW5kZXg7CiAJ
d3FidWZfZmlyc3RpbmRleCA9IGFjYi0+d3FidWZfZmlyc3RpbmRleDsKIAlpZiAod3FidWZfbGFz
dGluZGV4ICE9IHdxYnVmX2ZpcnN0aW5kZXgpIHsKLQkJYXJjbXNyX3Bvc3RfaW9jdGxkYXRhMmlv
cChhY2IpOworCQlhcmNtc3Jfd3JpdGVfaW9jdGxkYXRhMmlvcChhY2IpOworCQlzcGluX3VubG9j
a19pcnFyZXN0b3JlKCZhY2ItPndxYnVmZmVyX2xvY2ssIGZsYWdzKTsKIAkJcmV0dXJuIDA7CS8q
bmVlZCByZXRyeSovCiAJfSBlbHNlIHsKIAkJbXlfZW1wdHlfbGVuID0gKHdxYnVmX2ZpcnN0aW5k
ZXgtd3FidWZfbGFzdGluZGV4IC0gMSkKLQkJCQkmKEFSQ01TUl9NQVhfUUJVRkZFUiAtIDEpOwor
CQkJJihBUkNNU1JfTUFYX1FCVUZGRVIgLSAxKTsKIAkJaWYgKG15X2VtcHR5X2xlbiA+PSB1c2Vy
X2xlbikgewogCQkJd2hpbGUgKHVzZXJfbGVuID4gMCkgewotCQkJCXBRYnVmZmVyID0KLQkJCQkm
YWNiLT53cWJ1ZmZlclthY2ItPndxYnVmX2xhc3RpbmRleF07Ci0JCQkJbWVtY3B5KHBRYnVmZmVy
LCBwdG1wdXNlcmJ1ZmZlciwgMSk7CisJCQkJcFFidWZmZXIgPSAmYWNiLT53cWJ1ZmZlclthY2It
PndxYnVmX2xhc3RpbmRleF07CisJCQkJbWVtY3B5KCh2b2lkICopcFFidWZmZXIsIChjb25zdCB2
b2lkICopcHRtcHVzZXJidWZmZXIsIDEpOwogCQkJCWFjYi0+d3FidWZfbGFzdGluZGV4Kys7CiAJ
CQkJYWNiLT53cWJ1Zl9sYXN0aW5kZXggJT0gQVJDTVNSX01BWF9RQlVGRkVSOwogCQkJCXB0bXB1
c2VyYnVmZmVyKys7CiAJCQkJdXNlcl9sZW4tLTsKIAkJCX0KLQkJCWlmIChhY2ItPmFjYl9mbGFn
cyAmIEFDQl9GX01FU1NBR0VfV1FCVUZGRVJfQ0xFQVJFRCkgewotCQkJCWFjYi0+YWNiX2ZsYWdz
ICY9Ci0JCQkJCX5BQ0JfRl9NRVNTQUdFX1dRQlVGRkVSX0NMRUFSRUQ7Ci0JCQkJYXJjbXNyX3Bv
c3RfaW9jdGxkYXRhMmlvcChhY2IpOworCQkJaWYgKGFjYi0+YWNiX2ZsYWdzICYKKwkJCQlBQ0Jf
Rl9NRVNTQUdFX1dRQlVGRkVSX0NMRUFSRUQpIHsKKwkJCQlhY2ItPmFjYl9mbGFncyAmPSB+QUNC
X0ZfTUVTU0FHRV9XUUJVRkZFUl9DTEVBUkVEOworCQkJCWFyY21zcl93cml0ZV9pb2N0bGRhdGEy
aW9wKGFjYik7CiAJCQl9CisJCQlzcGluX3VubG9ja19pcnFyZXN0b3JlKCZhY2ItPndxYnVmZmVy
X2xvY2ssIGZsYWdzKTsKIAkJCXJldHVybiBjb3VudDsKIAkJfSBlbHNlIHsKKwkJCXNwaW5fdW5s
b2NrX2lycXJlc3RvcmUoJmFjYi0+d3FidWZmZXJfbG9jaywgZmxhZ3MpOwogCQkJcmV0dXJuIDA7
CS8qbmVlZCByZXRyeSovCiAJCX0KIAl9CiB9CiAKLXN0YXRpYyBzc2l6ZV90IGFyY21zcl9zeXNm
c19pb3BfbWVzc2FnZV9jbGVhcihzdHJ1Y3QgZmlsZSAqZmlscCwKLQkJCQkJICAgICAgc3RydWN0
IGtvYmplY3QgKmtvYmosCi0JCQkJCSAgICAgIHN0cnVjdCBiaW5fYXR0cmlidXRlICpiaW4sCi0J
CQkJCSAgICAgIGNoYXIgKmJ1ZiwgbG9mZl90IG9mZiwKLQkJCQkJICAgICAgc2l6ZV90IGNvdW50
KQorc3RhdGljIHNzaXplX3QKK2FyY21zcl9zeXNmc19pb3BfbWVzc2FnZV9jbGVhcihzdHJ1Y3Qg
ZmlsZSAqZmlscCwKKwkJCQkgICAgICBzdHJ1Y3Qga29iamVjdCAqa29iaiwKKwkJCQkgICAgICBz
dHJ1Y3QgYmluX2F0dHJpYnV0ZSAqYmluLAorCQkJCSAgICAgIGNoYXIgKmJ1ZiwgbG9mZl90IG9m
ZiwKKwkJCQkgICAgICBzaXplX3QgY291bnQpCiB7Ci0Jc3RydWN0IGRldmljZSAqZGV2ID0gY29u
dGFpbmVyX29mKGtvYmosc3RydWN0IGRldmljZSxrb2JqKTsKKwlzdHJ1Y3QgZGV2aWNlICpkZXYg
PSBjb250YWluZXJfb2Yoa29iaiwgc3RydWN0IGRldmljZSwga29iaik7CiAJc3RydWN0IFNjc2lf
SG9zdCAqaG9zdCA9IGNsYXNzX3RvX3Nob3N0KGRldik7Ci0Jc3RydWN0IEFkYXB0ZXJDb250cm9s
QmxvY2sgKmFjYiA9IChzdHJ1Y3QgQWRhcHRlckNvbnRyb2xCbG9jayAqKSBob3N0LT5ob3N0ZGF0
YTsKKwlzdHJ1Y3QgQWRhcHRlckNvbnRyb2xCbG9jayAqYWNiID0KKwkJKHN0cnVjdCBBZGFwdGVy
Q29udHJvbEJsb2NrICopaG9zdC0+aG9zdGRhdGE7CiAJdWludDhfdCAqcFFidWZmZXI7CisJdW5z
aWduZWQgbG9uZyBmbGFnczsKIAogCWlmICghY2FwYWJsZShDQVBfU1lTX0FETUlOKSkKIAkJcmV0
dXJuIC1FQUNDRVM7CiAKLQlpZiAoYWNiLT5hY2JfZmxhZ3MgJiBBQ0JfRl9JT1BEQVRBX09WRVJG
TE9XKSB7Ci0JCWFjYi0+YWNiX2ZsYWdzICY9IH5BQ0JfRl9JT1BEQVRBX09WRVJGTE9XOwotCQlh
cmNtc3JfaW9wX21lc3NhZ2VfcmVhZChhY2IpOwotCX0KKwlhcmNtc3JfY2xlYXJfaW9wMmRydl9y
cXVldWVfYnVmZmVyKGFjYik7CiAJYWNiLT5hY2JfZmxhZ3MgfD0KIAkJKEFDQl9GX01FU1NBR0Vf
V1FCVUZGRVJfQ0xFQVJFRAogCQl8IEFDQl9GX01FU1NBR0VfUlFCVUZGRVJfQ0xFQVJFRAogCQl8
IEFDQl9GX01FU1NBR0VfV1FCVUZGRVJfUkVBREVEKTsKKwlzcGluX2xvY2tfaXJxc2F2ZSgmYWNi
LT5ycWJ1ZmZlcl9sb2NrLCBmbGFncyk7CiAJYWNiLT5ycWJ1Zl9maXJzdGluZGV4ID0gMDsKIAlh
Y2ItPnJxYnVmX2xhc3RpbmRleCA9IDA7CisJc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSgmYWNiLT5y
cWJ1ZmZlcl9sb2NrLCBmbGFncyk7CisJc3Bpbl9sb2NrX2lycXNhdmUoJmFjYi0+d3FidWZmZXJf
bG9jaywgZmxhZ3MpOwogCWFjYi0+d3FidWZfZmlyc3RpbmRleCA9IDA7CiAJYWNiLT53cWJ1Zl9s
YXN0aW5kZXggPSAwOworCXNwaW5fdW5sb2NrX2lycXJlc3RvcmUoJmFjYi0+d3FidWZmZXJfbG9j
aywgZmxhZ3MpOwogCXBRYnVmZmVyID0gYWNiLT5ycWJ1ZmZlcjsKIAltZW1zZXQocFFidWZmZXIs
IDAsIHNpemVvZiAoc3RydWN0IFFCVUZGRVIpKTsKIAlwUWJ1ZmZlciA9IGFjYi0+d3FidWZmZXI7
CkBAIC0yMTUsMzEgKzI0NSwzNyBAQCBzdGF0aWMgc3RydWN0IGJpbl9hdHRyaWJ1dGUgYXJjbXNy
X3N5c2ZzCiAJLndyaXRlID0gYXJjbXNyX3N5c2ZzX2lvcF9tZXNzYWdlX2NsZWFyLAogfTsKIAot
aW50IGFyY21zcl9hbGxvY19zeXNmc19hdHRyKHN0cnVjdCBBZGFwdGVyQ29udHJvbEJsb2NrICph
Y2IpCitpbnQKK2FyY21zcl9hbGxvY19zeXNmc19hdHRyKHN0cnVjdCBBZGFwdGVyQ29udHJvbEJs
b2NrICphY2IpCiB7CiAJc3RydWN0IFNjc2lfSG9zdCAqaG9zdCA9IGFjYi0+aG9zdDsKIAlpbnQg
ZXJyb3I7CiAKLQllcnJvciA9IHN5c2ZzX2NyZWF0ZV9iaW5fZmlsZSgmaG9zdC0+c2hvc3RfZGV2
LmtvYmosICZhcmNtc3Jfc3lzZnNfbWVzc2FnZV9yZWFkX2F0dHIpOworCWVycm9yID0gc3lzZnNf
Y3JlYXRlX2Jpbl9maWxlKCZob3N0LT5zaG9zdF9kZXYua29iaiwKKwkJJmFyY21zcl9zeXNmc19t
ZXNzYWdlX3JlYWRfYXR0cik7CiAJaWYgKGVycm9yKSB7Ci0JCXByaW50ayhLRVJOX0VSUiAiYXJj
bXNyOiBhbGxvYyBzeXNmcyBtdV9yZWFkIGZhaWxlZFxuIik7CisJCXByX2VycigiYXJjbXNyOiBh
bGxvYyBzeXNmcyBtdV9yZWFkIGZhaWxlZFxuIik7CiAJCWdvdG8gZXJyb3JfYmluX2ZpbGVfbWVz
c2FnZV9yZWFkOwogCX0KLQllcnJvciA9IHN5c2ZzX2NyZWF0ZV9iaW5fZmlsZSgmaG9zdC0+c2hv
c3RfZGV2LmtvYmosICZhcmNtc3Jfc3lzZnNfbWVzc2FnZV93cml0ZV9hdHRyKTsKKwllcnJvciA9
IHN5c2ZzX2NyZWF0ZV9iaW5fZmlsZSgmaG9zdC0+c2hvc3RfZGV2LmtvYmosCisJCSZhcmNtc3Jf
c3lzZnNfbWVzc2FnZV93cml0ZV9hdHRyKTsKIAlpZiAoZXJyb3IpIHsKLQkJcHJpbnRrKEtFUk5f
RVJSICJhcmNtc3I6IGFsbG9jIHN5c2ZzIG11X3dyaXRlIGZhaWxlZFxuIik7CisJCXByX2Vycigi
YXJjbXNyOiBhbGxvYyBzeXNmcyBtdV93cml0ZSBmYWlsZWRcbiIpOwogCQlnb3RvIGVycm9yX2Jp
bl9maWxlX21lc3NhZ2Vfd3JpdGU7CiAJfQotCWVycm9yID0gc3lzZnNfY3JlYXRlX2Jpbl9maWxl
KCZob3N0LT5zaG9zdF9kZXYua29iaiwgJmFyY21zcl9zeXNmc19tZXNzYWdlX2NsZWFyX2F0dHIp
OworCWVycm9yID0gc3lzZnNfY3JlYXRlX2Jpbl9maWxlKCZob3N0LT5zaG9zdF9kZXYua29iaiwK
KwkJJmFyY21zcl9zeXNmc19tZXNzYWdlX2NsZWFyX2F0dHIpOwogCWlmIChlcnJvcikgewotCQlw
cmludGsoS0VSTl9FUlIgImFyY21zcjogYWxsb2Mgc3lzZnMgbXVfY2xlYXIgZmFpbGVkXG4iKTsK
KwkJcHJfZXJyKCJhcmNtc3I6IGFsbG9jIHN5c2ZzIG11X2NsZWFyIGZhaWxlZFxuIik7CiAJCWdv
dG8gZXJyb3JfYmluX2ZpbGVfbWVzc2FnZV9jbGVhcjsKIAl9CiAJcmV0dXJuIDA7CiBlcnJvcl9i
aW5fZmlsZV9tZXNzYWdlX2NsZWFyOgotCXN5c2ZzX3JlbW92ZV9iaW5fZmlsZSgmaG9zdC0+c2hv
c3RfZGV2LmtvYmosICZhcmNtc3Jfc3lzZnNfbWVzc2FnZV93cml0ZV9hdHRyKTsKKwlzeXNmc19y
ZW1vdmVfYmluX2ZpbGUoJmhvc3QtPnNob3N0X2Rldi5rb2JqLAorCQkmYXJjbXNyX3N5c2ZzX21l
c3NhZ2Vfd3JpdGVfYXR0cik7CiBlcnJvcl9iaW5fZmlsZV9tZXNzYWdlX3dyaXRlOgotCXN5c2Zz
X3JlbW92ZV9iaW5fZmlsZSgmaG9zdC0+c2hvc3RfZGV2LmtvYmosICZhcmNtc3Jfc3lzZnNfbWVz
c2FnZV9yZWFkX2F0dHIpOworCXN5c2ZzX3JlbW92ZV9iaW5fZmlsZSgmaG9zdC0+c2hvc3RfZGV2
LmtvYmosCisJCSZhcmNtc3Jfc3lzZnNfbWVzc2FnZV9yZWFkX2F0dHIpOwogZXJyb3JfYmluX2Zp
bGVfbWVzc2FnZV9yZWFkOgogCXJldHVybiBlcnJvcjsKIH0KQEAgLTI0OCwzMCArMjg0LDMwIEBA
IHZvaWQgYXJjbXNyX2ZyZWVfc3lzZnNfYXR0cihzdHJ1Y3QgQWRhcHQKIHsKIAlzdHJ1Y3QgU2Nz
aV9Ib3N0ICpob3N0ID0gYWNiLT5ob3N0OwogCi0Jc3lzZnNfcmVtb3ZlX2Jpbl9maWxlKCZob3N0
LT5zaG9zdF9kZXYua29iaiwgJmFyY21zcl9zeXNmc19tZXNzYWdlX2NsZWFyX2F0dHIpOwotCXN5
c2ZzX3JlbW92ZV9iaW5fZmlsZSgmaG9zdC0+c2hvc3RfZGV2LmtvYmosICZhcmNtc3Jfc3lzZnNf
bWVzc2FnZV93cml0ZV9hdHRyKTsKLQlzeXNmc19yZW1vdmVfYmluX2ZpbGUoJmhvc3QtPnNob3N0
X2Rldi5rb2JqLCAmYXJjbXNyX3N5c2ZzX21lc3NhZ2VfcmVhZF9hdHRyKTsKKwlzeXNmc19yZW1v
dmVfYmluX2ZpbGUoJmhvc3QtPnNob3N0X2Rldi5rb2JqLAorCQkmYXJjbXNyX3N5c2ZzX21lc3Nh
Z2VfY2xlYXJfYXR0cik7CisJc3lzZnNfcmVtb3ZlX2Jpbl9maWxlKCZob3N0LT5zaG9zdF9kZXYu
a29iaiwKKwkJJmFyY21zcl9zeXNmc19tZXNzYWdlX3dyaXRlX2F0dHIpOworCXN5c2ZzX3JlbW92
ZV9iaW5fZmlsZSgmaG9zdC0+c2hvc3RfZGV2LmtvYmosCisJCSZhcmNtc3Jfc3lzZnNfbWVzc2Fn
ZV9yZWFkX2F0dHIpOwogfQogCi0KIHN0YXRpYyBzc2l6ZV90CiBhcmNtc3JfYXR0cl9ob3N0X2Ry
aXZlcl92ZXJzaW9uKHN0cnVjdCBkZXZpY2UgKmRldiwKLQkJCQlzdHJ1Y3QgZGV2aWNlX2F0dHJp
YnV0ZSAqYXR0ciwgY2hhciAqYnVmKQorCQkJc3RydWN0IGRldmljZV9hdHRyaWJ1dGUgKmF0dHIs
IGNoYXIgKmJ1ZikKIHsKLQlyZXR1cm4gc25wcmludGYoYnVmLCBQQUdFX1NJWkUsCi0JCQkiJXNc
biIsCisJcmV0dXJuIHNucHJpbnRmKGJ1ZiwgUEFHRV9TSVpFLCAiJXNcbiIsCiAJCQlBUkNNU1Jf
RFJJVkVSX1ZFUlNJT04pOwogfQogCiBzdGF0aWMgc3NpemVfdAogYXJjbXNyX2F0dHJfaG9zdF9k
cml2ZXJfcG9zdGVkX2NtZChzdHJ1Y3QgZGV2aWNlICpkZXYsCi0JCQkJICAgc3RydWN0IGRldmlj
ZV9hdHRyaWJ1dGUgKmF0dHIsIGNoYXIgKmJ1ZikKKwkJCXN0cnVjdCBkZXZpY2VfYXR0cmlidXRl
ICphdHRyLCBjaGFyICpidWYpCiB7CiAJc3RydWN0IFNjc2lfSG9zdCAqaG9zdCA9IGNsYXNzX3Rv
X3Nob3N0KGRldik7CiAJc3RydWN0IEFkYXB0ZXJDb250cm9sQmxvY2sgKmFjYiA9Ci0JCShzdHJ1
Y3QgQWRhcHRlckNvbnRyb2xCbG9jayAqKSBob3N0LT5ob3N0ZGF0YTsKLQlyZXR1cm4gc25wcmlu
dGYoYnVmLCBQQUdFX1NJWkUsCi0JCQkiJTRkXG4iLAorCQkoc3RydWN0IEFkYXB0ZXJDb250cm9s
QmxvY2sgKilob3N0LT5ob3N0ZGF0YTsKKwlyZXR1cm4gc25wcmludGYoYnVmLCBQQUdFX1NJWkUs
ICIlNGRcbiIsCiAJCQlhdG9taWNfcmVhZCgmYWNiLT5jY2JvdXRzdGFuZGluZ2NvdW50KSk7CiB9
CiAKQEAgLTI4MSw5ICszMTcsOCBAQCBhcmNtc3JfYXR0cl9ob3N0X2RyaXZlcl9yZXNldChzdHJ1
Y3QgZGV2CiB7CiAJc3RydWN0IFNjc2lfSG9zdCAqaG9zdCA9IGNsYXNzX3RvX3Nob3N0KGRldik7
CiAJc3RydWN0IEFkYXB0ZXJDb250cm9sQmxvY2sgKmFjYiA9Ci0JCShzdHJ1Y3QgQWRhcHRlckNv
bnRyb2xCbG9jayAqKSBob3N0LT5ob3N0ZGF0YTsKLQlyZXR1cm4gc25wcmludGYoYnVmLCBQQUdF
X1NJWkUsCi0JCQkiJTRkXG4iLAorCQkoc3RydWN0IEFkYXB0ZXJDb250cm9sQmxvY2sgKilob3N0
LT5ob3N0ZGF0YTsKKwlyZXR1cm4gc25wcmludGYoYnVmLCBQQUdFX1NJWkUsICIlNGRcbiIsCiAJ
CQlhY2ItPm51bV9yZXNldHMpOwogfQogCkBAIC0yOTMsMjEgKzMyOCwxOSBAQCBhcmNtc3JfYXR0
cl9ob3N0X2RyaXZlcl9hYm9ydChzdHJ1Y3QgZGV2CiB7CiAJc3RydWN0IFNjc2lfSG9zdCAqaG9z
dCA9IGNsYXNzX3RvX3Nob3N0KGRldik7CiAJc3RydWN0IEFkYXB0ZXJDb250cm9sQmxvY2sgKmFj
YiA9Ci0JCShzdHJ1Y3QgQWRhcHRlckNvbnRyb2xCbG9jayAqKSBob3N0LT5ob3N0ZGF0YTsKLQly
ZXR1cm4gc25wcmludGYoYnVmLCBQQUdFX1NJWkUsCi0JCQkiJTRkXG4iLAorCQkoc3RydWN0IEFk
YXB0ZXJDb250cm9sQmxvY2sgKilob3N0LT5ob3N0ZGF0YTsKKwlyZXR1cm4gc25wcmludGYoYnVm
LCBQQUdFX1NJWkUsICIlNGRcbiIsCiAJCQlhY2ItPm51bV9hYm9ydHMpOwogfQogCiBzdGF0aWMg
c3NpemVfdAotYXJjbXNyX2F0dHJfaG9zdF9md19tb2RlbChzdHJ1Y3QgZGV2aWNlICpkZXYsIHN0
cnVjdCBkZXZpY2VfYXR0cmlidXRlICphdHRyLAotCQkJICBjaGFyICpidWYpCithcmNtc3JfYXR0
cl9ob3N0X2Z3X21vZGVsKHN0cnVjdCBkZXZpY2UgKmRldiwKKwkJCXN0cnVjdCBkZXZpY2VfYXR0
cmlidXRlICphdHRyLCBjaGFyICpidWYpCiB7CiAJc3RydWN0IFNjc2lfSG9zdCAqaG9zdCA9IGNs
YXNzX3RvX3Nob3N0KGRldik7CiAJc3RydWN0IEFkYXB0ZXJDb250cm9sQmxvY2sgKmFjYiA9Ci0J
CShzdHJ1Y3QgQWRhcHRlckNvbnRyb2xCbG9jayAqKSBob3N0LT5ob3N0ZGF0YTsKLQlyZXR1cm4g
c25wcmludGYoYnVmLCBQQUdFX1NJWkUsCi0JCQkiJXNcbiIsCisJCShzdHJ1Y3QgQWRhcHRlckNv
bnRyb2xCbG9jayAqKWhvc3QtPmhvc3RkYXRhOworCXJldHVybiBzbnByaW50ZihidWYsIFBBR0Vf
U0laRSwgIiVzXG4iLAogCQkJYWNiLT5maXJtX21vZGVsKTsKIH0KIApAQCAtMzE3LDEwICszNTAs
OCBAQCBhcmNtc3JfYXR0cl9ob3N0X2Z3X3ZlcnNpb24oc3RydWN0IGRldmljCiB7CiAJc3RydWN0
IFNjc2lfSG9zdCAqaG9zdCA9IGNsYXNzX3RvX3Nob3N0KGRldik7CiAJc3RydWN0IEFkYXB0ZXJD
b250cm9sQmxvY2sgKmFjYiA9Ci0JCQkoc3RydWN0IEFkYXB0ZXJDb250cm9sQmxvY2sgKikgaG9z
dC0+aG9zdGRhdGE7Ci0KLQlyZXR1cm4gc25wcmludGYoYnVmLCBQQUdFX1NJWkUsCi0JCQkiJXNc
biIsCisJCQkoc3RydWN0IEFkYXB0ZXJDb250cm9sQmxvY2sgKilob3N0LT5ob3N0ZGF0YTsKKwly
ZXR1cm4gc25wcmludGYoYnVmLCBQQUdFX1NJWkUsICIlc1xuIiwKIAkJCWFjYi0+ZmlybV92ZXJz
aW9uKTsKIH0KIApAQCAtMzMwLDEwICszNjEsOSBAQCBhcmNtc3JfYXR0cl9ob3N0X2Z3X3JlcXVl
c3RfbGVuKHN0cnVjdCBkCiB7CiAJc3RydWN0IFNjc2lfSG9zdCAqaG9zdCA9IGNsYXNzX3RvX3No
b3N0KGRldik7CiAJc3RydWN0IEFkYXB0ZXJDb250cm9sQmxvY2sgKmFjYiA9Ci0JCShzdHJ1Y3Qg
QWRhcHRlckNvbnRyb2xCbG9jayAqKSBob3N0LT5ob3N0ZGF0YTsKKwkJKHN0cnVjdCBBZGFwdGVy
Q29udHJvbEJsb2NrICopaG9zdC0+aG9zdGRhdGE7CiAKLQlyZXR1cm4gc25wcmludGYoYnVmLCBQ
QUdFX1NJWkUsCi0JCQkiJTRkXG4iLAorCXJldHVybiBzbnByaW50ZihidWYsIFBBR0VfU0laRSwg
IiU0ZFxuIiwKIAkJCWFjYi0+ZmlybV9yZXF1ZXN0X2xlbik7CiB9CiAKQEAgLTM0MywxMCArMzcz
LDkgQEAgYXJjbXNyX2F0dHJfaG9zdF9md19udW1iZXJzX3F1ZXVlKHN0cnVjdAogewogCXN0cnVj
dCBTY3NpX0hvc3QgKmhvc3QgPSBjbGFzc190b19zaG9zdChkZXYpOwogCXN0cnVjdCBBZGFwdGVy
Q29udHJvbEJsb2NrICphY2IgPQotCQkoc3RydWN0IEFkYXB0ZXJDb250cm9sQmxvY2sgKikgaG9z
dC0+aG9zdGRhdGE7CisJCShzdHJ1Y3QgQWRhcHRlckNvbnRyb2xCbG9jayAqKWhvc3QtPmhvc3Rk
YXRhOwogCi0JcmV0dXJuIHNucHJpbnRmKGJ1ZiwgUEFHRV9TSVpFLAotCQkJIiU0ZFxuIiwKKwly
ZXR1cm4gc25wcmludGYoYnVmLCBQQUdFX1NJWkUsICIlNGRcbiIsCiAJCQlhY2ItPmZpcm1fbnVt
YmVyc19xdWV1ZSk7CiB9CiAKQEAgLTM1NiwxMCArMzg1LDkgQEAgYXJjbXNyX2F0dHJfaG9zdF9m
d19zZHJhbV9zaXplKHN0cnVjdCBkZQogewogCXN0cnVjdCBTY3NpX0hvc3QgKmhvc3QgPSBjbGFz
c190b19zaG9zdChkZXYpOwogCXN0cnVjdCBBZGFwdGVyQ29udHJvbEJsb2NrICphY2IgPQotCQko
c3RydWN0IEFkYXB0ZXJDb250cm9sQmxvY2sgKikgaG9zdC0+aG9zdGRhdGE7CisJCShzdHJ1Y3Qg
QWRhcHRlckNvbnRyb2xCbG9jayAqKWhvc3QtPmhvc3RkYXRhOwogCi0JcmV0dXJuIHNucHJpbnRm
KGJ1ZiwgUEFHRV9TSVpFLAotCQkJIiU0ZFxuIiwKKwlyZXR1cm4gc25wcmludGYoYnVmLCBQQUdF
X1NJWkUsICIlNGRcbiIsCiAJCQlhY2ItPmZpcm1fc2RyYW1fc2l6ZSk7CiB9CiAKQEAgLTM2OSwy
MyArMzk3LDMyIEBAIGFyY21zcl9hdHRyX2hvc3RfZndfaGRfY2hhbm5lbHMoc3RydWN0IGQKIHsK
IAlzdHJ1Y3QgU2NzaV9Ib3N0ICpob3N0ID0gY2xhc3NfdG9fc2hvc3QoZGV2KTsKIAlzdHJ1Y3Qg
QWRhcHRlckNvbnRyb2xCbG9jayAqYWNiID0KLQkJKHN0cnVjdCBBZGFwdGVyQ29udHJvbEJsb2Nr
ICopIGhvc3QtPmhvc3RkYXRhOworCQkoc3RydWN0IEFkYXB0ZXJDb250cm9sQmxvY2sgKilob3N0
LT5ob3N0ZGF0YTsKIAotCXJldHVybiBzbnByaW50ZihidWYsIFBBR0VfU0laRSwKLQkJCSIlNGRc
biIsCisJcmV0dXJuIHNucHJpbnRmKGJ1ZiwgUEFHRV9TSVpFLCAiJTRkXG4iLAogCQkJYWNiLT5m
aXJtX2hkX2NoYW5uZWxzKTsKIH0KIAotc3RhdGljIERFVklDRV9BVFRSKGhvc3RfZHJpdmVyX3Zl
cnNpb24sIFNfSVJVR08sIGFyY21zcl9hdHRyX2hvc3RfZHJpdmVyX3ZlcnNpb24sIE5VTEwpOwot
c3RhdGljIERFVklDRV9BVFRSKGhvc3RfZHJpdmVyX3Bvc3RlZF9jbWQsIFNfSVJVR08sIGFyY21z
cl9hdHRyX2hvc3RfZHJpdmVyX3Bvc3RlZF9jbWQsIE5VTEwpOwotc3RhdGljIERFVklDRV9BVFRS
KGhvc3RfZHJpdmVyX3Jlc2V0LCBTX0lSVUdPLCBhcmNtc3JfYXR0cl9ob3N0X2RyaXZlcl9yZXNl
dCwgTlVMTCk7Ci1zdGF0aWMgREVWSUNFX0FUVFIoaG9zdF9kcml2ZXJfYWJvcnQsIFNfSVJVR08s
IGFyY21zcl9hdHRyX2hvc3RfZHJpdmVyX2Fib3J0LCBOVUxMKTsKLXN0YXRpYyBERVZJQ0VfQVRU
Uihob3N0X2Z3X21vZGVsLCBTX0lSVUdPLCBhcmNtc3JfYXR0cl9ob3N0X2Z3X21vZGVsLCBOVUxM
KTsKLXN0YXRpYyBERVZJQ0VfQVRUUihob3N0X2Z3X3ZlcnNpb24sIFNfSVJVR08sIGFyY21zcl9h
dHRyX2hvc3RfZndfdmVyc2lvbiwgTlVMTCk7Ci1zdGF0aWMgREVWSUNFX0FUVFIoaG9zdF9md19y
ZXF1ZXN0X2xlbiwgU19JUlVHTywgYXJjbXNyX2F0dHJfaG9zdF9md19yZXF1ZXN0X2xlbiwgTlVM
TCk7Ci1zdGF0aWMgREVWSUNFX0FUVFIoaG9zdF9md19udW1iZXJzX3F1ZXVlLCBTX0lSVUdPLCBh
cmNtc3JfYXR0cl9ob3N0X2Z3X251bWJlcnNfcXVldWUsIE5VTEwpOwotc3RhdGljIERFVklDRV9B
VFRSKGhvc3RfZndfc2RyYW1fc2l6ZSwgU19JUlVHTywgYXJjbXNyX2F0dHJfaG9zdF9md19zZHJh
bV9zaXplLCBOVUxMKTsKLXN0YXRpYyBERVZJQ0VfQVRUUihob3N0X2Z3X2hkX2NoYW5uZWxzLCBT
X0lSVUdPLCBhcmNtc3JfYXR0cl9ob3N0X2Z3X2hkX2NoYW5uZWxzLCBOVUxMKTsKK3N0YXRpYyBE
RVZJQ0VfQVRUUihob3N0X2RyaXZlcl92ZXJzaW9uLCBTX0lSVUdPLAorCWFyY21zcl9hdHRyX2hv
c3RfZHJpdmVyX3ZlcnNpb24sIE5VTEwpOworc3RhdGljIERFVklDRV9BVFRSKGhvc3RfZHJpdmVy
X3Bvc3RlZF9jbWQsIFNfSVJVR08sCisJYXJjbXNyX2F0dHJfaG9zdF9kcml2ZXJfcG9zdGVkX2Nt
ZCwgTlVMTCk7CitzdGF0aWMgREVWSUNFX0FUVFIoaG9zdF9kcml2ZXJfcmVzZXQsIFNfSVJVR08s
CisJYXJjbXNyX2F0dHJfaG9zdF9kcml2ZXJfcmVzZXQsIE5VTEwpOworc3RhdGljIERFVklDRV9B
VFRSKGhvc3RfZHJpdmVyX2Fib3J0LCBTX0lSVUdPLAorCWFyY21zcl9hdHRyX2hvc3RfZHJpdmVy
X2Fib3J0LCBOVUxMKTsKK3N0YXRpYyBERVZJQ0VfQVRUUihob3N0X2Z3X21vZGVsLCBTX0lSVUdP
LAorCWFyY21zcl9hdHRyX2hvc3RfZndfbW9kZWwsIE5VTEwpOworc3RhdGljIERFVklDRV9BVFRS
KGhvc3RfZndfdmVyc2lvbiwgU19JUlVHTywKKwlhcmNtc3JfYXR0cl9ob3N0X2Z3X3ZlcnNpb24s
IE5VTEwpOworc3RhdGljIERFVklDRV9BVFRSKGhvc3RfZndfcmVxdWVzdF9sZW4sIFNfSVJVR08s
CisJYXJjbXNyX2F0dHJfaG9zdF9md19yZXF1ZXN0X2xlbiwgTlVMTCk7CitzdGF0aWMgREVWSUNF
X0FUVFIoaG9zdF9md19udW1iZXJzX3F1ZXVlLCBTX0lSVUdPLAorCWFyY21zcl9hdHRyX2hvc3Rf
ZndfbnVtYmVyc19xdWV1ZSwgTlVMTCk7CitzdGF0aWMgREVWSUNFX0FUVFIoaG9zdF9md19zZHJh
bV9zaXplLCBTX0lSVUdPLAorCWFyY21zcl9hdHRyX2hvc3RfZndfc2RyYW1fc2l6ZSwgTlVMTCk7
CitzdGF0aWMgREVWSUNFX0FUVFIoaG9zdF9md19oZF9jaGFubmVscywgU19JUlVHTywKKwlhcmNt
c3JfYXR0cl9ob3N0X2Z3X2hkX2NoYW5uZWxzLCBOVUxMKTsKIAogc3RydWN0IGRldmljZV9hdHRy
aWJ1dGUgKmFyY21zcl9ob3N0X2F0dHJzW10gPSB7CiAJJmRldl9hdHRyX2hvc3RfZHJpdmVyX3Zl
cnNpb24sCmRpZmYgLXVwck4gYS9kcml2ZXJzL3Njc2kvYXJjbXNyL2FyY21zci5oIGIvZHJpdmVy
cy9zY3NpL2FyY21zci9hcmNtc3IuaAotLS0gYS9kcml2ZXJzL3Njc2kvYXJjbXNyL2FyY21zci5o
CTIwMTMtMDctMDEgMDY6MTM6MjguMDAwMDAwMDAwICswODAwCisrKyBiL2RyaXZlcnMvc2NzaS9h
cmNtc3IvYXJjbXNyLmgJMjAxMy0wOC0yOSAxOTozNjoxOC4wMDAwMDAwMDAgKzA4MDAKQEAgLTQ1
LDQyICs0NSw0OCBAQAogI2luY2x1ZGUgPGxpbnV4L2ludGVycnVwdC5oPgogc3RydWN0IGRldmlj
ZV9hdHRyaWJ1dGU7CiAvKlRoZSBsaW1pdCBvZiBvdXRzdGFuZGluZyBzY3NpIGNvbW1hbmQgdGhh
dCBmaXJtd2FyZSBjYW4gaGFuZGxlKi8KLSNkZWZpbmUgQVJDTVNSX01BWF9PVVRTVEFORElOR19D
TUQJCQkJCQkyNTYKKyNkZWZpbmUgQVJDTVNSX01BWF9PVVRTVEFORElOR19DTUQJCTI1NgogI2lm
ZGVmIENPTkZJR19YRU4KIAkjZGVmaW5lIEFSQ01TUl9NQVhfRlJFRUNDQl9OVU0JMTYwCiAjZWxz
ZQogCSNkZWZpbmUgQVJDTVNSX01BWF9GUkVFQ0NCX05VTQkzMjAKICNlbmRpZgotI2RlZmluZSBB
UkNNU1JfRFJJVkVSX1ZFUlNJT04JCSAgICAgIkRyaXZlciBWZXJzaW9uIDEuMjAuMDAuMTUgMjAx
MC8wOC8wNSIKLSNkZWZpbmUgQVJDTVNSX1NDU0lfSU5JVElBVE9SX0lECQkJCQkJMjU1Ci0jZGVm
aW5lIEFSQ01TUl9NQVhfWEZFUl9TRUNUT1JTCQkJCQkJCTUxMgotI2RlZmluZSBBUkNNU1JfTUFY
X1hGRVJfU0VDVE9SU19CCQkJCQkJNDA5NgotI2RlZmluZSBBUkNNU1JfTUFYX1hGRVJfU0VDVE9S
U19DCQkJCQkJMzA0Ci0jZGVmaW5lIEFSQ01TUl9NQVhfVEFSR0VUSUQJCQkJCQkJMTcKLSNkZWZp
bmUgQVJDTVNSX01BWF9UQVJHRVRMVU4JCQkJCQkJOAotI2RlZmluZSBBUkNNU1JfTUFYX0NNRF9Q
RVJMVU4JCSAgICAgICAgICAgICAgICAgQVJDTVNSX01BWF9PVVRTVEFORElOR19DTUQKLSNkZWZp
bmUgQVJDTVNSX01BWF9RQlVGRkVSCQkJCQkJCTQwOTYKLSNkZWZpbmUgQVJDTVNSX0RFRkFVTFRf
U0dfRU5UUklFUwkJCQkJCTM4Ci0jZGVmaW5lIEFSQ01TUl9NQVhfSEJCX1BPU1RRVUVVRQkJCQkJ
CTI2NAotI2RlZmluZSBBUkNNU1JfTUFYX1hGRVJfTEVOCQkJCQkJCTB4MjYwMDAgLyogMTUySyAq
LwotI2RlZmluZSBBUkNNU1JfQ0RCX1NHX1BBR0VfTEVOR1RICQkJCQkJMjU2IAorI2RlZmluZSBB
UkNNU1JfRFJJVkVSX1ZFUlNJT04JCSJ2MS4zMC4wMC4wNCAyMDEzLzA4LzI5IgorI2RlZmluZSBB
UkNNU1JfU0NTSV9JTklUSUFUT1JfSUQJCTI1NQorI2RlZmluZSBBUkNNU1JfTUFYX1hGRVJfU0VD
VE9SUwkJNTEyCisjZGVmaW5lIEFSQ01TUl9NQVhfWEZFUl9TRUNUT1JTX0IJCTQwOTYKKyNkZWZp
bmUgQVJDTVNSX01BWF9YRkVSX1NFQ1RPUlNfQwkJMzA0CisjZGVmaW5lIEFSQ01TUl9NQVhfVEFS
R0VUSUQJCQkxNworI2RlZmluZSBBUkNNU1JfTUFYX1RBUkdFVExVTgkJCTgKKyNkZWZpbmUgQVJD
TVNSX01BWF9DTURfUEVSTFVOCQkJQVJDTVNSX01BWF9PVVRTVEFORElOR19DTUQKKyNkZWZpbmUg
QVJDTVNSX01BWF9RQlVGRkVSCQkJNDA5NgorI2RlZmluZSBBUkNNU1JfREVGQVVMVF9TR19FTlRS
SUVTCQkzOAorI2RlZmluZSBBUkNNU1JfTUFYX0hCQl9QT1NUUVVFVUUJCTI2NAorI2RlZmluZSBB
UkNNU1JfTUFYX0FSQzEyMTRfUE9TVFFVRVVFCQkyNTYKKyNkZWZpbmUgQVJDTVNSX01BWF9BUkMx
MjE0X0RPTkVRVUVVRQkJMjU3CisjZGVmaW5lIEFSQ01TUl9NQVhfWEZFUl9MRU4JCQkweDI2MDAw
CisjZGVmaW5lIEFSQ01TUl9DREJfU0dfUEFHRV9MRU5HVEgJCTI1NgorI2RlZmluZSBBUkNNU1Rf
TlVNX01TSVhfVkVDVE9SUwkJNAogI2lmbmRlZiBQQ0lfREVWSUNFX0lEX0FSRUNBXzE4ODAKLSNk
ZWZpbmUgUENJX0RFVklDRV9JRF9BUkVDQV8xODgwIDB4MTg4MAotICNlbmRpZgorCSNkZWZpbmUg
UENJX0RFVklDRV9JRF9BUkVDQV8xODgwCTB4MTg4MAorI2VuZGlmCisjaWZuZGVmIFBDSV9ERVZJ
Q0VfSURfQVJFQ0FfMTIxNAorCSNkZWZpbmUgUENJX0RFVklDRV9JRF9BUkVDQV8xMjE0CTB4MTIx
NAorI2VuZGlmCiAvKgogKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKgogKioKICoqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioKICovCi0jZGVmaW5lIEFSQ19TVUNDRVNTICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIDAKLSNkZWZpbmUgQVJDX0ZBSUxV
UkUgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
MQorI2RlZmluZSBBUkNfU1VDQ0VTUwkJCQkwCisjZGVmaW5lIEFSQ19GQUlMVVJFCQkJCTEKIC8q
CiAqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqCiAqKiAgICAgICAgc3BsaXQgNjRiaXRzIGRtYSBhZGRy
ZXNzaW5nCiAqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqCiAqLwotI2RlZmluZSBkbWFfYWRkcl9oaTMy
KGFkZHIpICAgICAgICAgICAgICAgKHVpbnQzMl90KSAoKGFkZHI+PjE2KT4+MTYpCi0jZGVmaW5l
IGRtYV9hZGRyX2xvMzIoYWRkcikgICAgICAgICAgICAgICAodWludDMyX3QpIChhZGRyICYgMHhm
ZmZmZmZmZikKKyNkZWZpbmUgZG1hX2FkZHJfaGkzMihhZGRyKQkodWludDMyX3QpKChhZGRyID4+
IDE2KSA+PiAxNikKKyNkZWZpbmUgZG1hX2FkZHJfbG8zMihhZGRyKQkodWludDMyX3QpKGFkZHIg
JiAweGZmZmZmZmZmKQogLyoKICoqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioKICoqICAgICAgICBNRVNT
QUdFIENPTlRST0wgQ09ERQpAQCAtODgsMTIgKzk0LDEyIEBAIHN0cnVjdCBkZXZpY2VfYXR0cmli
dXRlOwogKi8KIHN0cnVjdCBDTURfTUVTU0FHRQogewotICAgICAgdWludDMyX3QgSGVhZGVyTGVu
Z3RoOwotICAgICAgdWludDhfdCAgU2lnbmF0dXJlWzhdOwotICAgICAgdWludDMyX3QgVGltZW91
dDsKLSAgICAgIHVpbnQzMl90IENvbnRyb2xDb2RlOwotICAgICAgdWludDMyX3QgUmV0dXJuQ29k
ZTsKLSAgICAgIHVpbnQzMl90IExlbmd0aDsKKwl1aW50MzJfdCBIZWFkZXJMZW5ndGg7CisJdWlu
dDhfdCBTaWduYXR1cmVbOF07CisJdWludDMyX3QgVGltZW91dDsKKwl1aW50MzJfdCBDb250cm9s
Q29kZTsKKwl1aW50MzJfdCBSZXR1cm5Db2RlOworCXVpbnQzMl90IExlbmd0aDsKIH07CiAvKgog
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKgpAQCAtMTAyLDggKzEwOCw4IEBAIHN0cnVjdCBDTURfTUVT
U0FHRQogKi8KIHN0cnVjdCBDTURfTUVTU0FHRV9GSUVMRAogewotICAgIHN0cnVjdCBDTURfTUVT
U0FHRQkJCWNtZG1lc3NhZ2U7Ci0gICAgdWludDhfdAkJCQltZXNzYWdlZGF0YWJ1ZmZlclsxMDMy
XTsKKwlzdHJ1Y3QgQ01EX01FU1NBR0UgY21kbWVzc2FnZTsKKwl1aW50OF90IG1lc3NhZ2VkYXRh
YnVmZmVyWzEwMzJdOwogfTsKIC8qIElPUCBtZXNzYWdlIHRyYW5zZmVyICovCiAjZGVmaW5lIEFS
Q01TUl9NRVNTQUdFX0ZBSUwJCQkweDAwMDEKQEAgLTExMSw1NyArMTE3LDU3IEBAIHN0cnVjdCBD
TURfTUVTU0FHRV9GSUVMRAogI2RlZmluZSBBUkVDQV9TQVRBX1JBSUQJCQkJMHg5MDAwMDAwMAog
LyogRnVuY3Rpb25Db2RlICovCiAjZGVmaW5lIEZVTkNUSU9OX1JFQURfUlFCVUZGRVIJCQkweDA4
MDEKLSNkZWZpbmUgRlVOQ1RJT05fV1JJVEVfV1FCVUZGRVIJCQkweDA4MDIKLSNkZWZpbmUgRlVO
Q1RJT05fQ0xFQVJfUlFCVUZGRVIJCQkweDA4MDMKLSNkZWZpbmUgRlVOQ1RJT05fQ0xFQVJfV1FC
VUZGRVIJCQkweDA4MDQKKyNkZWZpbmUgRlVOQ1RJT05fV1JJVEVfV1FCVUZGRVIJCTB4MDgwMgor
I2RlZmluZSBGVU5DVElPTl9DTEVBUl9SUUJVRkZFUgkJMHgwODAzCisjZGVmaW5lIEZVTkNUSU9O
X0NMRUFSX1dRQlVGRkVSCQkweDA4MDQKICNkZWZpbmUgRlVOQ1RJT05fQ0xFQVJfQUxMUUJVRkZF
UgkJMHgwODA1Ci0jZGVmaW5lIEZVTkNUSU9OX1JFVFVSTl9DT0RFXzNGCQkJMHgwODA2CisjZGVm
aW5lIEZVTkNUSU9OX1JFVFVSTl9DT0RFXzNGCQkweDA4MDYKICNkZWZpbmUgRlVOQ1RJT05fU0FZ
X0hFTExPCQkJMHgwODA3CiAjZGVmaW5lIEZVTkNUSU9OX1NBWV9HT09EQllFCQkJMHgwODA4CiAj
ZGVmaW5lIEZVTkNUSU9OX0ZMVVNIX0FEQVBURVJfQ0FDSEUJCTB4MDgwOQotI2RlZmluZSBGVU5D
VElPTl9HRVRfRklSTVdBUkVfU1RBVFVTCQkJMHgwODBBCi0jZGVmaW5lIEZVTkNUSU9OX0hBUkRX
QVJFX1JFU0VUCQkJMHgwODBCCisjZGVmaW5lIEZVTkNUSU9OX0dFVF9GSVJNV0FSRV9TVEFUVVMJ
CTB4MDgwQQorI2RlZmluZSBGVU5DVElPTl9IQVJEV0FSRV9SRVNFVAkJMHgwODBCCiAvKiBBUkVD
QSBJTyBDT05UUk9MIENPREUqLwotI2RlZmluZSBBUkNNU1JfTUVTU0FHRV9SRUFEX1JRQlVGRkVS
ICAgICAgIFwKLQlBUkVDQV9TQVRBX1JBSUQgfCBGVU5DVElPTl9SRUFEX1JRQlVGRkVSCi0jZGVm
aW5lIEFSQ01TUl9NRVNTQUdFX1dSSVRFX1dRQlVGRkVSICAgICAgXAotCUFSRUNBX1NBVEFfUkFJ
RCB8IEZVTkNUSU9OX1dSSVRFX1dRQlVGRkVSCi0jZGVmaW5lIEFSQ01TUl9NRVNTQUdFX0NMRUFS
X1JRQlVGRkVSICAgICAgXAotCUFSRUNBX1NBVEFfUkFJRCB8IEZVTkNUSU9OX0NMRUFSX1JRQlVG
RkVSCi0jZGVmaW5lIEFSQ01TUl9NRVNTQUdFX0NMRUFSX1dRQlVGRkVSICAgICAgXAotCUFSRUNB
X1NBVEFfUkFJRCB8IEZVTkNUSU9OX0NMRUFSX1dRQlVGRkVSCi0jZGVmaW5lIEFSQ01TUl9NRVNT
QUdFX0NMRUFSX0FMTFFCVUZGRVIgICAgXAotCUFSRUNBX1NBVEFfUkFJRCB8IEZVTkNUSU9OX0NM
RUFSX0FMTFFCVUZGRVIKLSNkZWZpbmUgQVJDTVNSX01FU1NBR0VfUkVUVVJOX0NPREVfM0YgICAg
ICBcCi0JQVJFQ0FfU0FUQV9SQUlEIHwgRlVOQ1RJT05fUkVUVVJOX0NPREVfM0YKLSNkZWZpbmUg
QVJDTVNSX01FU1NBR0VfU0FZX0hFTExPICAgICAgICAgICBcCi0JQVJFQ0FfU0FUQV9SQUlEIHwg
RlVOQ1RJT05fU0FZX0hFTExPCi0jZGVmaW5lIEFSQ01TUl9NRVNTQUdFX1NBWV9HT09EQllFICAg
ICAgICAgXAotCUFSRUNBX1NBVEFfUkFJRCB8IEZVTkNUSU9OX1NBWV9HT09EQllFCi0jZGVmaW5l
IEFSQ01TUl9NRVNTQUdFX0ZMVVNIX0FEQVBURVJfQ0FDSEUgXAotCUFSRUNBX1NBVEFfUkFJRCB8
IEZVTkNUSU9OX0ZMVVNIX0FEQVBURVJfQ0FDSEUKKyNkZWZpbmUgQVJDTVNSX01FU1NBR0VfUkVB
RF9SUUJVRkZFUgkJXAorCShBUkVDQV9TQVRBX1JBSUQgfCBGVU5DVElPTl9SRUFEX1JRQlVGRkVS
KQorI2RlZmluZSBBUkNNU1JfTUVTU0FHRV9XUklURV9XUUJVRkZFUglcCisJKEFSRUNBX1NBVEFf
UkFJRCB8IEZVTkNUSU9OX1dSSVRFX1dRQlVGRkVSKQorI2RlZmluZSBBUkNNU1JfTUVTU0FHRV9D
TEVBUl9SUUJVRkZFUglcCisJKEFSRUNBX1NBVEFfUkFJRCB8IEZVTkNUSU9OX0NMRUFSX1JRQlVG
RkVSKQorI2RlZmluZSBBUkNNU1JfTUVTU0FHRV9DTEVBUl9XUUJVRkZFUglcCisJKEFSRUNBX1NB
VEFfUkFJRCB8IEZVTkNUSU9OX0NMRUFSX1dRQlVGRkVSKQorI2RlZmluZSBBUkNNU1JfTUVTU0FH
RV9DTEVBUl9BTExRQlVGRkVSCVwKKwkoQVJFQ0FfU0FUQV9SQUlEIHwgRlVOQ1RJT05fQ0xFQVJf
QUxMUUJVRkZFUikKKyNkZWZpbmUgQVJDTVNSX01FU1NBR0VfUkVUVVJOX0NPREVfM0YJXAorCShB
UkVDQV9TQVRBX1JBSUQgfCBGVU5DVElPTl9SRVRVUk5fQ09ERV8zRikKKyNkZWZpbmUgQVJDTVNS
X01FU1NBR0VfU0FZX0hFTExPCQlcCisJKEFSRUNBX1NBVEFfUkFJRCB8IEZVTkNUSU9OX1NBWV9I
RUxMTykKKyNkZWZpbmUgQVJDTVNSX01FU1NBR0VfU0FZX0dPT0RCWUUJCVwKKwkoQVJFQ0FfU0FU
QV9SQUlEIHwgRlVOQ1RJT05fU0FZX0dPT0RCWUUpCisjZGVmaW5lIEFSQ01TUl9NRVNTQUdFX0ZM
VVNIX0FEQVBURVJfQ0FDSEUJXAorCShBUkVDQV9TQVRBX1JBSUQgfCBGVU5DVElPTl9GTFVTSF9B
REFQVEVSX0NBQ0hFKQogLyogQVJFQ0EgSU9DVEwgUmV0dXJuQ29kZSAqLwotI2RlZmluZSBBUkNN
U1JfTUVTU0FHRV9SRVRVUk5DT0RFX09LCQkweDAwMDAwMDAxCisjZGVmaW5lIEFSQ01TUl9NRVNT
QUdFX1JFVFVSTkNPREVfT0sJCQkweDAwMDAwMDAxCiAjZGVmaW5lIEFSQ01TUl9NRVNTQUdFX1JF
VFVSTkNPREVfRVJST1IJCTB4MDAwMDAwMDYKLSNkZWZpbmUgQVJDTVNSX01FU1NBR0VfUkVUVVJO
Q09ERV8zRgkJMHgwMDAwMDAzRgorI2RlZmluZSBBUkNNU1JfTUVTU0FHRV9SRVRVUk5DT0RFXzNG
CQkJMHgwMDAwMDAzRgogI2RlZmluZSBBUkNNU1JfTUVTU0FHRV9SRVRVUk5DT0RFX0JVU19IQU5H
X09OCTB4MDAwMDAwODgKIC8qCiAqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqCiAqKiAgIHN0cnVjdHVyZSBmb3IgaG9sZGluZyBETUEg
YWRkcmVzcyBkYXRhCiAqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqCiAqLwotI2RlZmluZSBJU19ETUE2NAkJCShzaXplb2YoZG1hX2Fk
ZHJfdCkgPT0gOCkKLSNkZWZpbmUgSVNfU0c2NF9BRERSICAgICAgICAgICAgICAgIDB4MDEwMDAw
MDAgLyogYml0MjQgKi8KKyNkZWZpbmUgSVNfRE1BNjQJCShzaXplb2YoZG1hX2FkZHJfdCkgPT0g
OCkKKyNkZWZpbmUgSVNfU0c2NF9BRERSCTB4MDEwMDAwMDAgLyogYml0MjQgKi8KIHN0cnVjdCAg
U0czMkVOVFJZCiB7Ci0JX19sZTMyCQkJCQlsZW5ndGg7Ci0JX19sZTMyCQkJCQlhZGRyZXNzOwor
CV9fbGUzMiBsZW5ndGg7CisJX19sZTMyIGFkZHJlc3M7CiB9X19hdHRyaWJ1dGVfXyAoKHBhY2tl
ZCkpOwogc3RydWN0ICBTRzY0RU5UUlkKIHsKLQlfX2xlMzIJCQkJCWxlbmd0aDsKLQlfX2xlMzIJ
CQkJCWFkZHJlc3M7Ci0JX19sZTMyCQkJCQlhZGRyZXNzaGlnaDsKKwlfX2xlMzIgbGVuZ3RoOwor
CV9fbGUzMiBhZGRyZXNzOworCV9fbGUzMiBhZGRyZXNzaGlnaDsKIH1fX2F0dHJpYnV0ZV9fICgo
cGFja2VkKSk7CiAvKgogKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioKQEAgLTE3MCw4ICsxNzYsOCBAQCBzdHJ1Y3QgIFNH
NjRFTlRSWQogKi8KIHN0cnVjdCBRQlVGRkVSCiB7Ci0JdWludDMyX3QgICAgICBkYXRhX2xlbjsK
LQl1aW50OF90ICAgICAgIGRhdGFbMTI0XTsKKwl1aW50MzJfdCBkYXRhX2xlbjsKKwl1aW50OF90
IGRhdGFbMTI0XTsKIH07CiAvKgogKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKgpAQCAtMTgwLDUwICsx
ODYsNTAgQEAgc3RydWN0IFFCVUZGRVIKICovCiBzdHJ1Y3QgRklSTVdBUkVfSU5GTwogewotCXVp
bnQzMl90ICAgICAgc2lnbmF0dXJlOwkJLyowLCAwMC0wMyovCi0JdWludDMyX3QgICAgICByZXF1
ZXN0X2xlbjsJCS8qMSwgMDQtMDcqLwotCXVpbnQzMl90ICAgICAgbnVtYmVyc19xdWV1ZTsJCS8q
MiwgMDgtMTEqLwotCXVpbnQzMl90ICAgICAgc2RyYW1fc2l6ZTsgICAgICAgICAgICAgICAvKjMs
IDEyLTE1Ki8KLQl1aW50MzJfdCAgICAgIGlkZV9jaGFubmVsczsJCS8qNCwgMTYtMTkqLwotCWNo
YXIgICAgICAgICAgdmVuZG9yWzQwXTsJCS8qNSwgMjAtNTkqLwotCWNoYXIgICAgICAgICAgbW9k
ZWxbOF07CQkJLyoxNSwgNjAtNjcqLwotCWNoYXIgICAgICAgICAgZmlybXdhcmVfdmVyWzE2XTsg
ICAgIAkvKjE3LCA2OC04MyovCi0JY2hhciAgICAgICAgICBkZXZpY2VfbWFwWzE2XTsJCS8qMjEs
IDg0LTk5Ki8KLQl1aW50MzJfdAkJY2ZnVmVyc2lvbjsgICAgICAgICAgICAgICAJLyoyNSwxMDAt
MTAzIEFkZGVkIGZvciBjaGVja2luZyBvZiBuZXcgZmlybXdhcmUgY2FwYWJpbGl0eSovCi0JdWlu
dDhfdAkJY2ZnU2VyaWFsWzE2XTsgICAgICAgICAgIAkvKjI2LDEwNC0xMTkqLwotCXVpbnQzMl90
CQljZmdQaWNTdGF0dXM7ICAgICAgICAgICAgCS8qMzAsMTIwLTEyMyovCQorCXVpbnQzMl90IHNp
Z25hdHVyZTsJLyowLCAwMC0wMyovCisJdWludDMyX3QgcmVxdWVzdF9sZW47CS8qMSwgMDQtMDcq
LworCXVpbnQzMl90IG51bWJlcnNfcXVldWU7CS8qMiwgMDgtMTEqLworCXVpbnQzMl90IHNkcmFt
X3NpemU7CS8qMywgMTItMTUqLworCXVpbnQzMl90IGlkZV9jaGFubmVsczsJLyo0LCAxNi0xOSov
CisJY2hhciB2ZW5kb3JbNDBdOwkJLyo1LCAyMC01OSovCisJY2hhciBtb2RlbFs4XTsJCS8qMTUs
IDYwLTY3Ki8KKwljaGFyIGZpcm13YXJlX3ZlclsxNl07CS8qMTcsIDY4LTgzKi8KKwljaGFyIGRl
dmljZV9tYXBbMTZdOwkvKjIxLCA4NC05OSovCisJdWludDMyX3QgY2ZnVmVyc2lvbjsJLyoyNSwg
MTAwLTEwMyovCisJdWludDhfdCBjZmdTZXJpYWxbMTZdOwkvKjI2LCAxMDQtMTE5Ki8KKwl1aW50
MzJfdCBjZmdQaWNTdGF0dXM7CS8qMzAsIDEyMC0xMjMqLwogfTsKIC8qIHNpZ25hdHVyZSBvZiBz
ZXQgYW5kIGdldCBmaXJtd2FyZSBjb25maWcgKi8KLSNkZWZpbmUgQVJDTVNSX1NJR05BVFVSRV9H
RVRfQ09ORklHCQkgICAgICAweDg3OTc0MDYwCi0jZGVmaW5lIEFSQ01TUl9TSUdOQVRVUkVfU0VU
X0NPTkZJRwkJICAgICAgMHg4Nzk3NDA2MworI2RlZmluZSBBUkNNU1JfU0lHTkFUVVJFX0dFVF9D
T05GSUcJCTB4ODc5NzQwNjAKKyNkZWZpbmUgQVJDTVNSX1NJR05BVFVSRV9TRVRfQ09ORklHCQkw
eDg3OTc0MDYzCiAvKiBtZXNzYWdlIGNvZGUgb2YgaW5ib3VuZCBtZXNzYWdlIHJlZ2lzdGVyICov
Ci0jZGVmaW5lIEFSQ01TUl9JTkJPVU5EX01FU0cwX05PUAkJICAgICAgMHgwMDAwMDAwMAotI2Rl
ZmluZSBBUkNNU1JfSU5CT1VORF9NRVNHMF9HRVRfQ09ORklHCQkgICAgICAweDAwMDAwMDAxCi0j
ZGVmaW5lIEFSQ01TUl9JTkJPVU5EX01FU0cwX1NFVF9DT05GSUcgICAgICAgICAgICAgICAweDAw
MDAwMDAyCi0jZGVmaW5lIEFSQ01TUl9JTkJPVU5EX01FU0cwX0FCT1JUX0NNRCAgICAgICAgICAg
ICAgICAweDAwMDAwMDAzCi0jZGVmaW5lIEFSQ01TUl9JTkJPVU5EX01FU0cwX1NUT1BfQkdSQiAg
ICAgICAgICAgICAgICAweDAwMDAwMDA0Ci0jZGVmaW5lIEFSQ01TUl9JTkJPVU5EX01FU0cwX0ZM
VVNIX0NBQ0hFICAgICAgICAgICAgICAweDAwMDAwMDA1Ci0jZGVmaW5lIEFSQ01TUl9JTkJPVU5E
X01FU0cwX1NUQVJUX0JHUkIgICAgICAgICAgICAgICAweDAwMDAwMDA2Ci0jZGVmaW5lIEFSQ01T
Ul9JTkJPVU5EX01FU0cwX0NISzMzMVBFTkRJTkcgICAgICAgICAgICAweDAwMDAwMDA3Ci0jZGVm
aW5lIEFSQ01TUl9JTkJPVU5EX01FU0cwX1NZTkNfVElNRVIgICAgICAgICAgICAgICAweDAwMDAw
MDA4CisjZGVmaW5lIEFSQ01TUl9JTkJPVU5EX01FU0cwX05PUAkJMHgwMDAwMDAwMAorI2RlZmlu
ZSBBUkNNU1JfSU5CT1VORF9NRVNHMF9HRVRfQ09ORklHCTB4MDAwMDAwMDEKKyNkZWZpbmUgQVJD
TVNSX0lOQk9VTkRfTUVTRzBfU0VUX0NPTkZJRwkweDAwMDAwMDAyCisjZGVmaW5lIEFSQ01TUl9J
TkJPVU5EX01FU0cwX0FCT1JUX0NNRAkweDAwMDAwMDAzCisjZGVmaW5lIEFSQ01TUl9JTkJPVU5E
X01FU0cwX1NUT1BfQkdSQgkweDAwMDAwMDA0CisjZGVmaW5lIEFSQ01TUl9JTkJPVU5EX01FU0cw
X0ZMVVNIX0NBQ0hFCTB4MDAwMDAwMDUKKyNkZWZpbmUgQVJDTVNSX0lOQk9VTkRfTUVTRzBfU1RB
UlRfQkdSQgkweDAwMDAwMDA2CisjZGVmaW5lIEFSQ01TUl9JTkJPVU5EX01FU0cwX0NISzMzMVBF
TkRJTkcJMHgwMDAwMDAwNworI2RlZmluZSBBUkNNU1JfSU5CT1VORF9NRVNHMF9TWU5DX1RJTUVS
CTB4MDAwMDAwMDgKIC8qIGRvb3JiZWxsIGludGVycnVwdCBnZW5lcmF0b3IgKi8KLSNkZWZpbmUg
QVJDTVNSX0lOQk9VTkRfRFJJVkVSX0RBVEFfV1JJVEVfT0sgICAgICAgICAgIDB4MDAwMDAwMDEK
LSNkZWZpbmUgQVJDTVNSX0lOQk9VTkRfRFJJVkVSX0RBVEFfUkVBRF9PSyAgICAgICAgICAgIDB4
MDAwMDAwMDIKLSNkZWZpbmUgQVJDTVNSX09VVEJPVU5EX0lPUDMzMV9EQVRBX1dSSVRFX09LICAg
ICAgICAgIDB4MDAwMDAwMDEKLSNkZWZpbmUgQVJDTVNSX09VVEJPVU5EX0lPUDMzMV9EQVRBX1JF
QURfT0sgICAgICAgICAgIDB4MDAwMDAwMDIKKyNkZWZpbmUgQVJDTVNSX0lOQk9VTkRfRFJJVkVS
X0RBVEFfV1JJVEVfT0sJMHgwMDAwMDAwMQorI2RlZmluZSBBUkNNU1JfSU5CT1VORF9EUklWRVJf
REFUQV9SRUFEX09LCTB4MDAwMDAwMDIKKyNkZWZpbmUgQVJDTVNSX09VVEJPVU5EX0lPUDMzMV9E
QVRBX1dSSVRFX09LCTB4MDAwMDAwMDEKKyNkZWZpbmUgQVJDTVNSX09VVEJPVU5EX0lPUDMzMV9E
QVRBX1JFQURfT0sJMHgwMDAwMDAwMgogLyogY2NiIGFyZWNhIGNkYiBmbGFnICovCi0jZGVmaW5l
IEFSQ01TUl9DQ0JQT1NUX0ZMQUdfU0dMX0JTSVpFICAgICAgICAgICAgICAgICAweDgwMDAwMDAw
Ci0jZGVmaW5lIEFSQ01TUl9DQ0JQT1NUX0ZMQUdfSUFNX0JJT1MgICAgICAgICAgICAgICAgICAw
eDQwMDAwMDAwCi0jZGVmaW5lIEFSQ01TUl9DQ0JSRVBMWV9GTEFHX0lBTV9CSU9TICAgICAgICAg
ICAgICAgICAweDQwMDAwMDAwCi0jZGVmaW5lIEFSQ01TUl9DQ0JSRVBMWV9GTEFHX0VSUk9SX01P
REUwICAgICAgICAgICAgICAweDEwMDAwMDAwCi0jZGVmaW5lIEFSQ01TUl9DQ0JSRVBMWV9GTEFH
X0VSUk9SX01PREUxICAgICAgICAgICAgICAweDAwMDAwMDAxCisjZGVmaW5lIEFSQ01TUl9DQ0JQ
T1NUX0ZMQUdfU0dMX0JTSVpFCQkweDgwMDAwMDAwCisjZGVmaW5lIEFSQ01TUl9DQ0JQT1NUX0ZM
QUdfSUFNX0JJT1MJCTB4NDAwMDAwMDAKKyNkZWZpbmUgQVJDTVNSX0NDQlJFUExZX0ZMQUdfSUFN
X0JJT1MJCTB4NDAwMDAwMDAKKyNkZWZpbmUgQVJDTVNSX0NDQlJFUExZX0ZMQUdfRVJST1JfTU9E
RTAJMHgxMDAwMDAwMAorI2RlZmluZSBBUkNNU1JfQ0NCUkVQTFlfRkxBR19FUlJPUl9NT0RFMQkw
eDAwMDAwMDAxCiAvKiBvdXRib3VuZCBmaXJtd2FyZSBvayAqLwotI2RlZmluZSBBUkNNU1JfT1VU
Qk9VTkRfTUVTRzFfRklSTVdBUkVfT0sgICAgICAgICAgICAgMHg4MDAwMDAwMAorI2RlZmluZSBB
UkNNU1JfT1VUQk9VTkRfTUVTRzFfRklSTVdBUkVfT0sJMHg4MDAwMDAwMAogLyogQVJDLTE2ODAg
QnVzIFJlc2V0Ki8KLSNkZWZpbmUgQVJDTVNSX0FSQzE2ODBfQlVTX1JFU0VUCQkJCTB4MDAwMDAw
MDMKKyNkZWZpbmUgQVJDTVNSX0FSQzE2ODBfQlVTX1JFU0VUCQkweDAwMDAwMDAzCiAvKiBBUkMt
MTg4MCBCdXMgUmVzZXQqLwotI2RlZmluZSBBUkNNU1JfQVJDMTg4MF9SRVNFVF9BREFQVEVSCQkJ
CTB4MDAwMDAwMjQKLSNkZWZpbmUgQVJDTVNSX0FSQzE4ODBfRGlhZ1dyaXRlX0VOQUJMRQkJCTB4
MDAwMDAwODAKKyNkZWZpbmUgQVJDTVNSX0FSQzE4ODBfUkVTRVRfQURBUFRFUgkJMHgwMDAwMDAy
NAorI2RlZmluZSBBUkNNU1JfQVJDMTg4MF9EaWFnV3JpdGVfRU5BQkxFCTB4MDAwMDAwODAKIAog
LyoKICoqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKgpAQCAtMjMyLDk4ICsyMzgsMTAxIEBAIHN0cnVjdCBGSVJNV0FS
RV9JTkZPCiAqLwogLyogQVJFQ0EgSEJCIENPTU1BTkQgZm9yIGl0cyBGSVJNV0FSRSAqLwogLyog
d2luZG93IG9mICJpbnN0cnVjdGlvbiBmbGFncyIgZnJvbSBkcml2ZXIgdG8gaW9wICovCi0jZGVm
aW5lIEFSQ01TUl9EUlYySU9QX0RPT1JCRUxMICAgICAgICAgICAgICAgICAgICAgICAweDAwMDIw
NDAwCi0jZGVmaW5lIEFSQ01TUl9EUlYySU9QX0RPT1JCRUxMX01BU0sgICAgICAgICAgICAgICAg
ICAweDAwMDIwNDA0CisjZGVmaW5lIEFSQ01TUl9EUlYySU9QX0RPT1JCRUxMCQkweDAwMDIwNDAw
CisjZGVmaW5lIEFSQ01TUl9EUlYySU9QX0RPT1JCRUxMX01BU0sJCTB4MDAwMjA0MDQKIC8qIHdp
bmRvdyBvZiAiaW5zdHJ1Y3Rpb24gZmxhZ3MiIGZyb20gaW9wIHRvIGRyaXZlciAqLwotI2RlZmlu
ZSBBUkNNU1JfSU9QMkRSVl9ET09SQkVMTCAgICAgICAgICAgICAgICAgICAgICAgMHgwMDAyMDQw
OAotI2RlZmluZSBBUkNNU1JfSU9QMkRSVl9ET09SQkVMTF9NQVNLICAgICAgICAgICAgICAgICAg
MHgwMDAyMDQwQworI2RlZmluZSBBUkNNU1JfSU9QMkRSVl9ET09SQkVMTAkJMHgwMDAyMDQwOAor
I2RlZmluZSBBUkNNU1JfSU9QMkRSVl9ET09SQkVMTF9NQVNLCQkweDAwMDIwNDBDCiAvKiBBUkVD
QSBGTEFHIExBTkdVQUdFICovCiAvKiBpb2N0bCB0cmFuc2ZlciAqLwotI2RlZmluZSBBUkNNU1Jf
SU9QMkRSVl9EQVRBX1dSSVRFX09LICAgICAgICAgICAgICAgICAgMHgwMDAwMDAwMQorI2RlZmlu
ZSBBUkNNU1JfSU9QMkRSVl9EQVRBX1dSSVRFX09LCQkweDAwMDAwMDAxCiAvKiBpb2N0bCB0cmFu
c2ZlciAqLwotI2RlZmluZSBBUkNNU1JfSU9QMkRSVl9EQVRBX1JFQURfT0sgICAgICAgICAgICAg
ICAgICAgMHgwMDAwMDAwMgotI2RlZmluZSBBUkNNU1JfSU9QMkRSVl9DREJfRE9ORSAgICAgICAg
ICAgICAgICAgICAgICAgMHgwMDAwMDAwNAotI2RlZmluZSBBUkNNU1JfSU9QMkRSVl9NRVNTQUdF
X0NNRF9ET05FICAgICAgICAgICAgICAgMHgwMDAwMDAwOAotCi0jZGVmaW5lIEFSQ01TUl9ET09S
QkVMTF9IQU5ETEVfSU5UCQkgICAgICAweDAwMDAwMDBGCi0jZGVmaW5lIEFSQ01TUl9ET09SQkVM
TF9JTlRfQ0xFQVJfUEFUVEVSTiAgIAkgICAgICAweEZGMDBGRkYwCi0jZGVmaW5lIEFSQ01TUl9N
RVNTQUdFX0lOVF9DTEVBUl9QQVRURVJOCSAgICAgIDB4RkYwMEZGRjcKKyNkZWZpbmUgQVJDTVNS
X0lPUDJEUlZfREFUQV9SRUFEX09LCQkweDAwMDAwMDAyCisjZGVmaW5lIEFSQ01TUl9JT1AyRFJW
X0NEQl9ET05FCQkweDAwMDAwMDA0CisjZGVmaW5lIEFSQ01TUl9JT1AyRFJWX01FU1NBR0VfQ01E
X0RPTkUJMHgwMDAwMDAwOAorCisjZGVmaW5lIEFSQ01TUl9ET09SQkVMTF9IQU5ETEVfSU5UCQkw
eDAwMDAwMDBGCisjZGVmaW5lIEFSQ01TUl9ET09SQkVMTF9JTlRfQ0xFQVJfUEFUVEVSTgkweEZG
MDBGRkYwCisjZGVmaW5lIEFSQ01TUl9NRVNTQUdFX0lOVF9DTEVBUl9QQVRURVJOCTB4RkYwMEZG
RjcKIC8qIChBUkNNU1JfSU5CT1VORF9NRVNHMF9HRVRfQ09ORklHPDwxNil8QVJDTVNSX0RSVjJJ
T1BfTUVTU0FHRV9DTURfUE9TVEVEKSAqLwotI2RlZmluZSBBUkNNU1JfTUVTU0FHRV9HRVRfQ09O
RklHCQkgICAgICAweDAwMDEwMDA4CisjZGVmaW5lIEFSQ01TUl9NRVNTQUdFX0dFVF9DT05GSUcJ
CTB4MDAwMTAwMDgKIC8qIChBUkNNU1JfSU5CT1VORF9NRVNHMF9TRVRfQ09ORklHPDwxNil8QVJD
TVNSX0RSVjJJT1BfTUVTU0FHRV9DTURfUE9TVEVEKSAqLwotI2RlZmluZSBBUkNNU1JfTUVTU0FH
RV9TRVRfQ09ORklHCQkgICAgICAweDAwMDIwMDA4CisjZGVmaW5lIEFSQ01TUl9NRVNTQUdFX1NF
VF9DT05GSUcJCTB4MDAwMjAwMDgKIC8qIChBUkNNU1JfSU5CT1VORF9NRVNHMF9BQk9SVF9DTUQ8
PDE2KXxBUkNNU1JfRFJWMklPUF9NRVNTQUdFX0NNRF9QT1NURUQpICovCi0jZGVmaW5lIEFSQ01T
Ul9NRVNTQUdFX0FCT1JUX0NNRAkJICAgICAgMHgwMDAzMDAwOAorI2RlZmluZSBBUkNNU1JfTUVT
U0FHRV9BQk9SVF9DTUQJCTB4MDAwMzAwMDgKIC8qIChBUkNNU1JfSU5CT1VORF9NRVNHMF9TVE9Q
X0JHUkI8PDE2KXxBUkNNU1JfRFJWMklPUF9NRVNTQUdFX0NNRF9QT1NURUQpICovCi0jZGVmaW5l
IEFSQ01TUl9NRVNTQUdFX1NUT1BfQkdSQgkJICAgICAgMHgwMDA0MDAwOAorI2RlZmluZSBBUkNN
U1JfTUVTU0FHRV9TVE9QX0JHUkIJCTB4MDAwNDAwMDgKIC8qIChBUkNNU1JfSU5CT1VORF9NRVNH
MF9GTFVTSF9DQUNIRTw8MTYpfEFSQ01TUl9EUlYySU9QX01FU1NBR0VfQ01EX1BPU1RFRCkgKi8K
LSNkZWZpbmUgQVJDTVNSX01FU1NBR0VfRkxVU0hfQ0FDSEUgICAgICAgICAgICAgICAgICAgIDB4
MDAwNTAwMDgKKyNkZWZpbmUgQVJDTVNSX01FU1NBR0VfRkxVU0hfQ0FDSEUJCTB4MDAwNTAwMDgK
IC8qIChBUkNNU1JfSU5CT1VORF9NRVNHMF9TVEFSVF9CR1JCPDwxNil8QVJDTVNSX0RSVjJJT1Bf
TUVTU0FHRV9DTURfUE9TVEVEKSAqLwotI2RlZmluZSBBUkNNU1JfTUVTU0FHRV9TVEFSVF9CR1JC
CQkgICAgICAweDAwMDYwMDA4Ci0jZGVmaW5lIEFSQ01TUl9NRVNTQUdFX1NUQVJUX0RSSVZFUl9N
T0RFCSAgICAgIDB4MDAwRTAwMDgKLSNkZWZpbmUgQVJDTVNSX01FU1NBR0VfU0VUX1BPU1RfV0lO
RE9XCQkgICAgICAweDAwMEYwMDA4Ci0jZGVmaW5lIEFSQ01TUl9NRVNTQUdFX0FDVElWRV9FT0lf
TU9ERQkJICAgIDB4MDAxMDAwMDgKKyNkZWZpbmUgQVJDTVNSX01FU1NBR0VfU1RBUlRfQkdSQgkJ
MHgwMDA2MDAwOAorI2RlZmluZSBBUkNNU1JfTUVTU0FHRV9TVEFSVF9EUklWRVJfTU9ERQkweDAw
MEUwMDA4CisjZGVmaW5lIEFSQ01TUl9NRVNTQUdFX1NFVF9QT1NUX1dJTkRPVwkweDAwMEYwMDA4
CisjZGVmaW5lIEFSQ01TUl9NRVNTQUdFX0FDVElWRV9FT0lfTU9ERQkweDAwMTAwMDA4CiAvKiBB
UkNNU1JfT1VUQk9VTkRfTUVTRzFfRklSTVdBUkVfT0sgKi8KLSNkZWZpbmUgQVJDTVNSX01FU1NB
R0VfRklSTVdBUkVfT0sJCSAgICAgIDB4ODAwMDAwMDAKKyNkZWZpbmUgQVJDTVNSX01FU1NBR0Vf
RklSTVdBUkVfT0sJCTB4ODAwMDAwMDAKIC8qIGlvY3RsIHRyYW5zZmVyICovCi0jZGVmaW5lIEFS
Q01TUl9EUlYySU9QX0RBVEFfV1JJVEVfT0sgICAgICAgICAgICAgICAgICAweDAwMDAwMDAxCisj
ZGVmaW5lIEFSQ01TUl9EUlYySU9QX0RBVEFfV1JJVEVfT0sJCTB4MDAwMDAwMDEKIC8qIGlvY3Rs
IHRyYW5zZmVyICovCi0jZGVmaW5lIEFSQ01TUl9EUlYySU9QX0RBVEFfUkVBRF9PSyAgICAgICAg
ICAgICAgICAgICAweDAwMDAwMDAyCi0jZGVmaW5lIEFSQ01TUl9EUlYySU9QX0NEQl9QT1NURUQg
ICAgICAgICAgICAgICAgICAgICAweDAwMDAwMDA0Ci0jZGVmaW5lIEFSQ01TUl9EUlYySU9QX01F
U1NBR0VfQ01EX1BPU1RFRCAgICAgICAgICAgICAweDAwMDAwMDA4Ci0jZGVmaW5lIEFSQ01TUl9E
UlYySU9QX0VORF9PRl9JTlRFUlJVUFQJCTB4MDAwMDAwMTAKKyNkZWZpbmUgQVJDTVNSX0RSVjJJ
T1BfREFUQV9SRUFEX09LCQkweDAwMDAwMDAyCisjZGVmaW5lIEFSQ01TUl9EUlYySU9QX0NEQl9Q
T1NURUQJCTB4MDAwMDAwMDQKKyNkZWZpbmUgQVJDTVNSX0RSVjJJT1BfTUVTU0FHRV9DTURfUE9T
VEVECTB4MDAwMDAwMDgKKyNkZWZpbmUgQVJDTVNSX0RSVjJJT1BfRU5EX09GX0lOVEVSUlVQVAkw
eDAwMDAwMDEwCiAKIC8qIGRhdGEgdHVubmVsIGJ1ZmZlciBiZXR3ZWVuIHVzZXIgc3BhY2UgcHJv
Z3JhbSBhbmQgaXRzIGZpcm13YXJlICovCiAvKiB1c2VyIHNwYWNlIGRhdGEgdG8gaW9wIDEyOGJ5
dGVzICovCi0jZGVmaW5lIEFSQ01TUl9NRVNTQUdFX1dCVUZGRVIJCQkgICAgICAweDAwMDBmZTAw
CisjZGVmaW5lIEFSQ01TUl9NRVNTQUdFX1dCVUZGRVIJCTB4MDAwMGZlMDAKIC8qIGlvcCBkYXRh
IHRvIHVzZXIgc3BhY2UgMTI4Ynl0ZXMgKi8KLSNkZWZpbmUgQVJDTVNSX01FU1NBR0VfUkJVRkZF
UgkJCSAgICAgIDB4MDAwMGZmMDAKKyNkZWZpbmUgQVJDTVNSX01FU1NBR0VfUkJVRkZFUgkJMHgw
MDAwZmYwMAogLyogaW9wIG1lc3NhZ2VfcndidWZmZXIgZm9yIG1lc3NhZ2UgY29tbWFuZCAqLwot
I2RlZmluZSBBUkNNU1JfTUVTU0FHRV9SV0JVRkZFUgkJCSAgICAgIDB4MDAwMGZhMDAKKyNkZWZp
bmUgQVJDTVNSX01FU1NBR0VfUldCVUZGRVIJCTB4MDAwMGZhMDAKIC8qIAogKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqCiAqKiAgICAgICAgICAgICAgICBTUEVDLiBmb3IgQXJlY2EgSEJDIGFkYXB0ZXIKICoqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKgogKi8KLSNkZWZpbmUgQVJDTVNSX0hCQ19JU1JfVEhST1RUTElOR19MRVZFTAkJ
MTIKLSNkZWZpbmUgQVJDTVNSX0hCQ19JU1JfTUFYX0RPTkVfUVVFVUUJCTIwCisjZGVmaW5lIEFS
Q01TUl9IQkNfSVNSX1RIUk9UVExJTkdfTEVWRUwJMTIKKyNkZWZpbmUgQVJDTVNSX0hCQ19JU1Jf
TUFYX0RPTkVfUVVFVUUJMjAKIC8qIEhvc3QgSW50ZXJydXB0IE1hc2sgKi8KLSNkZWZpbmUgQVJD
TVNSX0hCQ01VX1VUSUxJVFlfQV9JU1JfTUFTSwkJMHgwMDAwMDAwMSAvKiBXaGVuIGNsZWFyLCB0
aGUgVXRpbGl0eV9BIGludGVycnVwdCByb3V0ZXMgdG8gdGhlIGhvc3QuKi8KLSNkZWZpbmUgQVJD
TVNSX0hCQ01VX09VVEJPVU5EX0RPT1JCRUxMX0lTUl9NQVNLCTB4MDAwMDAwMDQgLyogV2hlbiBj
bGVhciwgdGhlIEdlbmVyYWwgT3V0Ym91bmQgRG9vcmJlbGwgaW50ZXJydXB0IHJvdXRlcyB0byB0
aGUgaG9zdC4qLwotI2RlZmluZSBBUkNNU1JfSEJDTVVfT1VUQk9VTkRfUE9TVFFVRVVFX0lTUl9N
QVNLCTB4MDAwMDAwMDggLyogV2hlbiBjbGVhciwgdGhlIE91dGJvdW5kIFBvc3QgTGlzdCBGSUZP
IE5vdCBFbXB0eSBpbnRlcnJ1cHQgcm91dGVzIHRvIHRoZSBob3N0LiovCi0jZGVmaW5lIEFSQ01T
Ul9IQkNNVV9BTExfSU5UTUFTS0VOQUJMRQkJMHgwMDAwMDAwRCAvKiBkaXNhYmxlIGFsbCBJU1Ig
Ki8KKyNkZWZpbmUgQVJDTVNSX0hCQ01VX1VUSUxJVFlfQV9JU1JfTUFTSwkJMHgwMDAwMDAwMQor
I2RlZmluZSBBUkNNU1JfSEJDTVVfT1VUQk9VTkRfRE9PUkJFTExfSVNSX01BU0sJMHgwMDAwMDAw
NAorI2RlZmluZSBBUkNNU1JfSEJDTVVfT1VUQk9VTkRfUE9TVFFVRVVFX0lTUl9NQVNLCTB4MDAw
MDAwMDgKKyNkZWZpbmUgQVJDTVNSX0hCQ01VX0FMTF9JTlRNQVNLRU5BQkxFCQkweDAwMDAwMDBE
CiAvKiBIb3N0IEludGVycnVwdCBTdGF0dXMgKi8KICNkZWZpbmUgQVJDTVNSX0hCQ01VX1VUSUxJ
VFlfQV9JU1IJCQkweDAwMDAwMDAxCi0JLyoKLQkqKiBTZXQgd2hlbiB0aGUgVXRpbGl0eV9BIElu
dGVycnVwdCBiaXQgaXMgc2V0IGluIHRoZSBPdXRib3VuZCBEb29yYmVsbCBSZWdpc3Rlci4KLQkq
KiBJdCBjbGVhcnMgYnkgd3JpdGluZyBhIDEgdG8gdGhlIFV0aWxpdHlfQSBiaXQgaW4gdGhlIE91
dGJvdW5kIERvb3JiZWxsIENsZWFyIFJlZ2lzdGVyIG9yIHRocm91Z2ggYXV0b21hdGljIGNsZWFy
aW5nIChpZiBlbmFibGVkKS4KLQkqLworLyoKKyoqIFNldCB3aGVuIHRoZSBVdGlsaXR5X0EgSW50
ZXJydXB0IGJpdCBpcyBzZXQKKyoqIGluIHRoZSBPdXRib3VuZCBEb29yYmVsbCBSZWdpc3Rlci4K
KyoqIEl0IGNsZWFycyBieSB3cml0aW5nIGEgMSB0byB0aGUgVXRpbGl0eV9BCisqKiBiaXQgaW4g
dGhlIE91dGJvdW5kIERvb3JiZWxsIENsZWFyIFJlZ2lzdGVyCisqKiBvciB0aHJvdWdoIGF1dG9t
YXRpYyBjbGVhcmluZyAoaWYgZW5hYmxlZCkuCisqLwogI2RlZmluZSBBUkNNU1JfSEJDTVVfT1VU
Qk9VTkRfRE9PUkJFTExfSVNSCQkweDAwMDAwMDA0Ci0JLyoKLQkqKiBTZXQgaWYgT3V0Ym91bmQg
RG9vcmJlbGwgcmVnaXN0ZXIgYml0cyAzMDoxIGhhdmUgYSBub24temVybwotCSoqIHZhbHVlLiBU
aGlzIGJpdCBjbGVhcnMgb25seSB3aGVuIE91dGJvdW5kIERvb3JiZWxsIGJpdHMKLQkqKiAzMDox
IGFyZSBBTEwgY2xlYXIuIE9ubHkgYSB3cml0ZSB0byB0aGUgT3V0Ym91bmQgRG9vcmJlbGwKLQkq
KiBDbGVhciByZWdpc3RlciBjbGVhcnMgYml0cyBpbiB0aGUgT3V0Ym91bmQgRG9vcmJlbGwgcmVn
aXN0ZXIuCi0JKi8KKy8qCisqKiBTZXQgaWYgT3V0Ym91bmQgRG9vcmJlbGwgcmVnaXN0ZXIgYml0
cyAzMDoxIGhhdmUgYSBub24temVybworKiogdmFsdWUuIFRoaXMgYml0IGNsZWFycyBvbmx5IHdo
ZW4gT3V0Ym91bmQgRG9vcmJlbGwgYml0cworKiogMzA6MSBhcmUgQUxMIGNsZWFyLiBPbmx5IGEg
d3JpdGUgdG8gdGhlIE91dGJvdW5kIERvb3JiZWxsCisqKiBDbGVhciByZWdpc3RlciBjbGVhcnMg
Yml0cyBpbiB0aGUgT3V0Ym91bmQgRG9vcmJlbGwgcmVnaXN0ZXIuCisqLwogI2RlZmluZSBBUkNN
U1JfSEJDTVVfT1VUQk9VTkRfUE9TVFFVRVVFX0lTUgkweDAwMDAwMDA4Ci0JLyoKLQkqKiBTZXQg
d2hlbmV2ZXIgdGhlIE91dGJvdW5kIFBvc3QgTGlzdCBQcm9kdWNlci9Db25zdW1lcgotCSoqIFJl
Z2lzdGVyIChGSUZPKSBpcyBub3QgZW1wdHkuIEl0IGNsZWFycyB3aGVuIHRoZSBPdXRib3VuZAot
CSoqIFBvc3QgTGlzdCBGSUZPIGlzIGVtcHR5LgotCSovCisvKgorKiogU2V0IHdoZW5ldmVyIHRo
ZSBPdXRib3VuZCBQb3N0IExpc3QgUHJvZHVjZXIvQ29uc3VtZXIKKyoqIFJlZ2lzdGVyIChGSUZP
KSBpcyBub3QgZW1wdHkuIEl0IGNsZWFycyB3aGVuIHRoZSBPdXRib3VuZAorKiogUG9zdCBMaXN0
IEZJRk8gaXMgZW1wdHkuCisqLwogI2RlZmluZSBBUkNNU1JfSEJDTVVfU0FTX0FMTF9JTlQJCQkw
eDAwMDAwMDEwCi0JLyoKLQkqKiBUaGlzIGJpdCBpbmRpY2F0ZXMgYSBTQVMgaW50ZXJydXB0IGZy
b20gYSBzb3VyY2UgZXh0ZXJuYWwgdG8KLQkqKiB0aGUgUENJZSBjb3JlLiBUaGlzIGJpdCBpcyBu
b3QgbWFza2FibGUuCi0JKi8KLQkvKiBEb29yQmVsbCovCi0jZGVmaW5lIEFSQ01TUl9IQkNNVV9E
UlYySU9QX0RBVEFfV1JJVEVfT0sJCQkweDAwMDAwMDAyCi0jZGVmaW5lIEFSQ01TUl9IQkNNVV9E
UlYySU9QX0RBVEFfUkVBRF9PSwkJCTB4MDAwMDAwMDQKKy8qCisqKiBUaGlzIGJpdCBpbmRpY2F0
ZXMgYSBTQVMgaW50ZXJydXB0IGZyb20gYSBzb3VyY2UgZXh0ZXJuYWwgdG8KKyoqIHRoZSBQQ0ll
IGNvcmUuIFRoaXMgYml0IGlzIG5vdCBtYXNrYWJsZS4KKyovCisvKiBEb29yQmVsbCovCisjZGVm
aW5lIEFSQ01TUl9IQkNNVV9EUlYySU9QX0RBVEFfV1JJVEVfT0sJCTB4MDAwMDAwMDIKKyNkZWZp
bmUgQVJDTVNSX0hCQ01VX0RSVjJJT1BfREFUQV9SRUFEX09LCQkweDAwMDAwMDA0CiAJLyppbmJv
dW5kIG1lc3NhZ2UgMCByZWFkeSovCi0jZGVmaW5lIEFSQ01TUl9IQkNNVV9EUlYySU9QX01FU1NB
R0VfQ01EX0RPTkUJCTB4MDAwMDAwMDgKKyNkZWZpbmUgQVJDTVNSX0hCQ01VX0RSVjJJT1BfTUVT
U0FHRV9DTURfRE9ORQkweDAwMDAwMDA4CiAJLyptb3JlIHRoYW4gMTIgcmVxdWVzdCBjb21wbGV0
ZWQgaW4gYSB0aW1lKi8KLSNkZWZpbmUgQVJDTVNSX0hCQ01VX0RSVjJJT1BfUE9TVFFVRVVFX1RI
Uk9UVExJTkcJCTB4MDAwMDAwMTAKLSNkZWZpbmUgQVJDTVNSX0hCQ01VX0lPUDJEUlZfREFUQV9X
UklURV9PSwkJCTB4MDAwMDAwMDIKKyNkZWZpbmUgQVJDTVNSX0hCQ01VX0RSVjJJT1BfUE9TVFFV
RVVFX1RIUk9UVExJTkcJMHgwMDAwMDAxMAorI2RlZmluZSBBUkNNU1JfSEJDTVVfSU9QMkRSVl9E
QVRBX1dSSVRFX09LCQkweDAwMDAwMDAyCiAJLypvdXRib3VuZCBEQVRBIFdSSVRFIGlzciBkb29y
IGJlbGwgY2xlYXIqLwogI2RlZmluZSBBUkNNU1JfSEJDTVVfSU9QMkRSVl9EQVRBX1dSSVRFX0RP
T1JCRUxMX0NMRUFSCTB4MDAwMDAwMDIKICNkZWZpbmUgQVJDTVNSX0hCQ01VX0lPUDJEUlZfREFU
QV9SRUFEX09LCQkJMHgwMDAwMDAwNApAQCAtMzM3LDQwICszNDYsODkgQEAgc3RydWN0IEZJUk1X
QVJFX0lORk8KICNkZWZpbmUgQVJDTVNSX0hCQ01VX01FU1NBR0VfRklSTVdBUkVfT0sJCQkweDgw
MDAwMDAwCiAvKgogKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKgorKiogICAgICAgICAgICAgICAgU1BF
Qy4gZm9yIEFyZWNhIFR5cGUgRCBhZGFwdGVyCisqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqCisqLwor
I2RlZmluZSBBUkNNU1JfQVJDMTIxNF9DSElQX0lECQkJCQkweDAwMDA0CisjZGVmaW5lIEFSQ01T
Ul9BUkMxMjE0X0NQVV9NRU1PUllfQ09ORklHVVJBVElPTgkJMHgwMDAwOAorI2RlZmluZSBBUkNN
U1JfQVJDMTIxNF9JMl9IT1NUX0lOVEVSUlVQVF9NQVNLCQkweDAwMDM0CisjZGVmaW5lIEFSQ01T
Ul9BUkMxMjE0X1NBTVBMRV9SRVNFVAkJCQkweDAwMTAwCisjZGVmaW5lIEFSQ01TUl9BUkMxMjE0
X1JFU0VUX1JFUVVFU1QJCQkJMHgwMDEwOAorI2RlZmluZSBBUkNNU1JfQVJDMTIxNF9NQUlOX0lO
VEVSUlVQVF9TVEFUVVMJCQkweDAwMjAwCisjZGVmaW5lIEFSQ01TUl9BUkMxMjE0X1BDSUVfRjBf
SU5URVJSVVBUX0VOQUJMRQkJMHgwMDIwQworI2RlZmluZSBBUkNNU1JfQVJDMTIxNF9JTkJPVU5E
X01FU1NBR0UwCQkJMHgwMDQwMAorI2RlZmluZSBBUkNNU1JfQVJDMTIxNF9JTkJPVU5EX01FU1NB
R0UxCQkJMHgwMDQwNAorI2RlZmluZSBBUkNNU1JfQVJDMTIxNF9PVVRCT1VORF9NRVNTQUdFMAkJ
CTB4MDA0MjAKKyNkZWZpbmUgQVJDTVNSX0FSQzEyMTRfT1VUQk9VTkRfTUVTU0FHRTEJCQkweDAw
NDI0CisjZGVmaW5lIEFSQ01TUl9BUkMxMjE0X0lOQk9VTkRfRE9PUkJFTEwJCQkweDAwNDYwCisj
ZGVmaW5lIEFSQ01TUl9BUkMxMjE0X09VVEJPVU5EX0RPT1JCRUxMCQkJMHgwMDQ4MAorI2RlZmlu
ZSBBUkNNU1JfQVJDMTIxNF9PVVRCT1VORF9ET09SQkVMTF9FTkFCTEUJCTB4MDA0ODQKKyNkZWZp
bmUgQVJDTVNSX0FSQzEyMTRfSU5CT1VORF9MSVNUX0JBU0VfTE9XCQkweDAxMDAwCisjZGVmaW5l
IEFSQ01TUl9BUkMxMjE0X0lOQk9VTkRfTElTVF9CQVNFX0hJR0gJCTB4MDEwMDQKKyNkZWZpbmUg
QVJDTVNSX0FSQzEyMTRfSU5CT1VORF9MSVNUX1dSSVRFX1BPSU5URVIJCTB4MDEwMTgKKyNkZWZp
bmUgQVJDTVNSX0FSQzEyMTRfT1VUQk9VTkRfTElTVF9CQVNFX0xPVwkJMHgwMTA2MAorI2RlZmlu
ZSBBUkNNU1JfQVJDMTIxNF9PVVRCT1VORF9MSVNUX0JBU0VfSElHSAkJMHgwMTA2NAorI2RlZmlu
ZSBBUkNNU1JfQVJDMTIxNF9PVVRCT1VORF9MSVNUX0NPUFlfUE9JTlRFUgkJMHgwMTA2QworI2Rl
ZmluZSBBUkNNU1JfQVJDMTIxNF9PVVRCT1VORF9MSVNUX1JFQURfUE9JTlRFUgkJMHgwMTA3MAor
I2RlZmluZSBBUkNNU1JfQVJDMTIxNF9PVVRCT1VORF9JTlRFUlJVUFRfQ0FVU0UJCTB4MDEwODgK
KyNkZWZpbmUgQVJDTVNSX0FSQzEyMTRfT1VUQk9VTkRfSU5URVJSVVBUX0VOQUJMRQkJMHgwMTA4
QworI2RlZmluZSBBUkNNU1JfQVJDMTIxNF9NRVNTQUdFX1dCVUZGRVIJCQkweDAyMDAwCisjZGVm
aW5lIEFSQ01TUl9BUkMxMjE0X01FU1NBR0VfUkJVRkZFUgkJCTB4MDIxMDAKKyNkZWZpbmUgQVJD
TVNSX0FSQzEyMTRfTUVTU0FHRV9SV0JVRkZFUgkJCTB4MDIyMDAKKy8qIEhvc3QgSW50ZXJydXB0
IE1hc2sgKi8KKyNkZWZpbmUgQVJDTVNSX0FSQzEyMTRfQUxMX0lOVF9FTkFCTEUJCQkJMHgwMDAw
MTAxMAorI2RlZmluZSBBUkNNU1JfQVJDMTIxNF9BTExfSU5UX0RJU0FCTEUJCQkweDAwMDAwMDAw
CisvKiBIb3N0IEludGVycnVwdCBTdGF0dXMgKi8KKyNkZWZpbmUgQVJDTVNSX0FSQzEyMTRfT1VU
Qk9VTkRfRE9PUkJFTExfSVNSCQkweDAwMDAxMDAwCisjZGVmaW5lIEFSQ01TUl9BUkMxMjE0X09V
VEJPVU5EX1BPU1RRVUVVRV9JU1IJCTB4MDAwMDAwMTAKKy8qIERvb3JCZWxsKi8KKyNkZWZpbmUg
QVJDTVNSX0FSQzEyMTRfRFJWMklPUF9EQVRBX0lOX1JFQURZCQkJMHgwMDAwMDAwMQorI2RlZmlu
ZSBBUkNNU1JfQVJDMTIxNF9EUlYySU9QX0RBVEFfT1VUX1JFQUQJCTB4MDAwMDAwMDIKKy8qaW5i
b3VuZCBtZXNzYWdlIDAgcmVhZHkqLworI2RlZmluZSBBUkNNU1JfQVJDMTIxNF9JT1AyRFJWX0RB
VEFfV1JJVEVfT0sJCTB4MDAwMDAwMDEKKy8qb3V0Ym91bmQgREFUQSBXUklURSBpc3IgZG9vciBi
ZWxsIGNsZWFyKi8KKyNkZWZpbmUgQVJDTVNSX0FSQzEyMTRfSU9QMkRSVl9EQVRBX1JFQURfT0sJ
CQkweDAwMDAwMDAyCisvKm91dGJvdW5kIG1lc3NhZ2UgMCByZWFkeSovCisjZGVmaW5lIEFSQ01T
Ul9BUkMxMjE0X0lPUDJEUlZfTUVTU0FHRV9DTURfRE9ORQkJMHgwMjAwMDAwMAorLypvdXRib3Vu
ZCBtZXNzYWdlIGNtZCBpc3IgZG9vciBiZWxsIGNsZWFyKi8KKy8qQVJDTVNSX0hCQU1VX01FU1NB
R0VfRklSTVdBUkVfT0sqLworI2RlZmluZSBBUkNNU1JfQVJDMTIxNF9NRVNTQUdFX0ZJUk1XQVJF
X09LCQkJMHg4MDAwMDAwMAorI2RlZmluZSBBUkNNU1JfQVJDMTIxNF9PVVRCT1VORF9MSVNUX0lO
VEVSUlVQVF9DTEVBUgkweDAwMDAwMDAxCisvKgorKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKgogKiog
ICAgQVJFQ0EgU0NTSSBDT01NQU5EIERFU0NSSVBUT1IgQkxPQ0sgc2l6ZSAweDFGOCAoNTA0KQog
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKgogKi8KIHN0cnVjdCBBUkNNU1JfQ0RCCiB7Ci0JdWludDhf
dAkJCQkJCQlCdXM7Ci0JdWludDhfdAkJCQkJCQlUYXJnZXRJRDsKLQl1aW50OF90CQkJCQkJCUxV
TjsKLQl1aW50OF90CQkJCQkJCUZ1bmN0aW9uOwotCXVpbnQ4X3QJCQkJCQkJQ2RiTGVuZ3RoOwot
CXVpbnQ4X3QJCQkJCQkJc2djb3VudDsKLQl1aW50OF90CQkJCQkJCUZsYWdzOwotI2RlZmluZSBB
UkNNU1JfQ0RCX0ZMQUdfU0dMX0JTSVpFICAgICAgICAgIDB4MDEKLSNkZWZpbmUgQVJDTVNSX0NE
Ql9GTEFHX0JJT1MgICAgICAgICAgICAgICAweDAyCi0jZGVmaW5lIEFSQ01TUl9DREJfRkxBR19X
UklURSAgICAgICAgICAgICAgMHgwNAotI2RlZmluZSBBUkNNU1JfQ0RCX0ZMQUdfU0lNUExFUSAg
ICAgICAgICAgIDB4MDAKLSNkZWZpbmUgQVJDTVNSX0NEQl9GTEFHX0hFQURRICAgICAgICAgICAg
ICAweDA4Ci0jZGVmaW5lIEFSQ01TUl9DREJfRkxBR19PUkRFUkVEUSAgICAgICAgICAgMHgxMAot
Ci0JdWludDhfdAkJCQkJCQltc2dQYWdlczsKLQl1aW50MzJfdAkJCQkJCUNvbnRleHQ7Ci0JdWlu
dDMyX3QJCQkJCQlEYXRhTGVuZ3RoOwotCXVpbnQ4X3QJCQkJCQkJQ2RiWzE2XTsKLQl1aW50OF90
CQkJCQkJCURldmljZVN0YXR1czsKLSNkZWZpbmUgQVJDTVNSX0RFVl9DSEVDS19DT05ESVRJT04J
ICAgIDB4MDIKLSNkZWZpbmUgQVJDTVNSX0RFVl9TRUxFQ1RfVElNRU9VVAkgICAgMHhGMAotI2Rl
ZmluZSBBUkNNU1JfREVWX0FCT1JURUQJCSAgICAweEYxCi0jZGVmaW5lIEFSQ01TUl9ERVZfSU5J
VF9GQUlMCQkgICAgMHhGMgotCi0JdWludDhfdAkJCQkJCQlTZW5zZURhdGFbMTVdOwotCXVuaW9u
Ci0JewotCQlzdHJ1Y3QgU0czMkVOVFJZICAgICAgICAgICAgICAgIHNnMzJlbnRyeVsxXTsKLQkJ
c3RydWN0IFNHNjRFTlRSWSAgICAgICAgICAgICAgICBzZzY0ZW50cnlbMV07CisJdWludDhfdCBC
dXM7CisJdWludDhfdCBUYXJnZXRJRDsKKwl1aW50OF90IExVTjsKKwl1aW50OF90IEZ1bmN0aW9u
OworCXVpbnQ4X3QgQ2RiTGVuZ3RoOworCXVpbnQ4X3Qgc2djb3VudDsKKwl1aW50OF90IEZsYWdz
OworI2RlZmluZSBBUkNNU1JfQ0RCX0ZMQUdfU0dMX0JTSVpFCTB4MDEKKyNkZWZpbmUgQVJDTVNS
X0NEQl9GTEFHX0JJT1MJCTB4MDIKKyNkZWZpbmUgQVJDTVNSX0NEQl9GTEFHX1dSSVRFCQkweDA0
CisjZGVmaW5lIEFSQ01TUl9DREJfRkxBR19TSU1QTEVRCTB4MDAKKyNkZWZpbmUgQVJDTVNSX0NE
Ql9GTEFHX0hFQURRCQkweDA4CisjZGVmaW5lIEFSQ01TUl9DREJfRkxBR19PUkRFUkVEUQkweDEw
CisKKwl1aW50OF90IG1zZ1BhZ2VzOworCXVpbnQzMl90IG1zZ0NvbnRleHQ7CisJdWludDMyX3Qg
RGF0YUxlbmd0aDsKKwl1aW50OF90IENkYlsxNl07CisJdWludDhfdCBEZXZpY2VTdGF0dXM7Cisj
ZGVmaW5lIEFSQ01TUl9ERVZfQ0hFQ0tfQ09ORElUSU9OCTB4MDIKKyNkZWZpbmUgQVJDTVNSX0RF
Vl9TRUxFQ1RfVElNRU9VVAkweEYwCisjZGVmaW5lIEFSQ01TUl9ERVZfQUJPUlRFRAkJMHhGMQor
I2RlZmluZSBBUkNNU1JfREVWX0lOSVRfRkFJTAkJMHhGMgorCisJdWludDhfdCBTZW5zZURhdGFb
MTVdOworCXVuaW9uIHsKKwkJc3RydWN0IFNHMzJFTlRSWSBzZzMyZW50cnlbMV07CisJCXN0cnVj
dCBTRzY0RU5UUlkgc2c2NGVudHJ5WzFdOwogCX0gdTsKIH07CiAvKgpAQCAtMzgwLDExOCArNDM4
LDE2MiBAQCBzdHJ1Y3QgQVJDTVNSX0NEQgogKi8KIHN0cnVjdCBNZXNzYWdlVW5pdF9BCiB7Ci0J
dWludDMyX3QJcmVzcnZlZDBbNF07CQkJLyowMDAwIDAwMEYqLwotCXVpbnQzMl90CWluYm91bmRf
bXNnYWRkcjA7CQkvKjAwMTAgMDAxMyovCi0JdWludDMyX3QJaW5ib3VuZF9tc2dhZGRyMTsJCS8q
MDAxNCAwMDE3Ki8KLQl1aW50MzJfdAlvdXRib3VuZF9tc2dhZGRyMDsJCS8qMDAxOCAwMDFCKi8K
LQl1aW50MzJfdAlvdXRib3VuZF9tc2dhZGRyMTsJCS8qMDAxQyAwMDFGKi8KLQl1aW50MzJfdAlp
bmJvdW5kX2Rvb3JiZWxsOwkJLyowMDIwIDAwMjMqLwotCXVpbnQzMl90CWluYm91bmRfaW50c3Rh
dHVzOwkJLyowMDI0IDAwMjcqLwotCXVpbnQzMl90CWluYm91bmRfaW50bWFzazsJCS8qMDAyOCAw
MDJCKi8KLQl1aW50MzJfdAlvdXRib3VuZF9kb29yYmVsbDsJCS8qMDAyQyAwMDJGKi8KLQl1aW50
MzJfdAlvdXRib3VuZF9pbnRzdGF0dXM7CQkvKjAwMzAgMDAzMyovCi0JdWludDMyX3QJb3V0Ym91
bmRfaW50bWFzazsJCS8qMDAzNCAwMDM3Ki8KLQl1aW50MzJfdAlyZXNlcnZlZDFbMl07CQkJLyow
MDM4IDAwM0YqLwotCXVpbnQzMl90CWluYm91bmRfcXVldWVwb3J0OwkJLyowMDQwIDAwNDMqLwot
CXVpbnQzMl90CW91dGJvdW5kX3F1ZXVlcG9ydDsgICAgIAkvKjAwNDQgMDA0NyovCi0JdWludDMy
X3QJcmVzZXJ2ZWQyWzJdOwkJCS8qMDA0OCAwMDRGKi8KLQl1aW50MzJfdAlyZXNlcnZlZDNbNDky
XTsJCQkvKjAwNTAgMDdGRiA0OTIqLwotCXVpbnQzMl90CXJlc2VydmVkNFsxMjhdOwkJCS8qMDgw
MCAwOUZGIDEyOCovCi0JdWludDMyX3QJbWVzc2FnZV9yd2J1ZmZlclsyNTZdOwkJLyowYTAwIDBE
RkYgMjU2Ki8KLQl1aW50MzJfdAltZXNzYWdlX3didWZmZXJbMzJdOwkJLyowRTAwIDBFN0YgIDMy
Ki8KLQl1aW50MzJfdAlyZXNlcnZlZDVbMzJdOwkJCS8qMEU4MCAwRUZGICAzMiovCi0JdWludDMy
X3QJbWVzc2FnZV9yYnVmZmVyWzMyXTsJCS8qMEYwMCAwRjdGICAzMiovCi0JdWludDMyX3QJcmVz
ZXJ2ZWQ2WzMyXTsJCQkvKjBGODAgMEZGRiAgMzIqLworCXVpbnQzMl90IHJlc3J2ZWQwWzRdOwkJ
LyowMDAwIDAwMEYqLworCXVpbnQzMl90IGluYm91bmRfbXNnYWRkcjA7CS8qMDAxMCAwMDEzKi8K
Kwl1aW50MzJfdCBpbmJvdW5kX21zZ2FkZHIxOwkvKjAwMTQgMDAxNyovCisJdWludDMyX3Qgb3V0
Ym91bmRfbXNnYWRkcjA7CS8qMDAxOCAwMDFCKi8KKwl1aW50MzJfdCBvdXRib3VuZF9tc2dhZGRy
MTsJLyowMDFDIDAwMUYqLworCXVpbnQzMl90IGluYm91bmRfZG9vcmJlbGw7CQkvKjAwMjAgMDAy
MyovCisJdWludDMyX3QgaW5ib3VuZF9pbnRzdGF0dXM7CQkvKjAwMjQgMDAyNyovCisJdWludDMy
X3QgaW5ib3VuZF9pbnRtYXNrOwkJLyowMDI4IDAwMkIqLworCXVpbnQzMl90IG91dGJvdW5kX2Rv
b3JiZWxsOwkvKjAwMkMgMDAyRiovCisJdWludDMyX3Qgb3V0Ym91bmRfaW50c3RhdHVzOwkvKjAw
MzAgMDAzMyovCisJdWludDMyX3Qgb3V0Ym91bmRfaW50bWFzazsJLyowMDM0IDAwMzcqLworCXVp
bnQzMl90IHJlc2VydmVkMVsyXTsJCS8qMDAzOCAwMDNGKi8KKwl1aW50MzJfdCBpbmJvdW5kX3F1
ZXVlcG9ydDsJLyowMDQwIDAwNDMqLworCXVpbnQzMl90IG91dGJvdW5kX3F1ZXVlcG9ydDsJLyow
MDQ0IDAwNDcqLworCXVpbnQzMl90IHJlc2VydmVkMlsyXTsJCS8qMDA0OCAwMDRGKi8KKwl1aW50
MzJfdCByZXNlcnZlZDNbNDkyXTsJCS8qMDA1MCAwN0ZGIDQ5MiovCisJdWludDMyX3QgcmVzZXJ2
ZWQ0WzEyOF07CQkvKjA4MDAgMDlGRiAxMjgqLworCXVpbnQzMl90IG1lc3NhZ2VfcndidWZmZXJb
MjU2XTsJLyowYTAwIDBERkYgMjU2Ki8KKwl1aW50MzJfdCBtZXNzYWdlX3didWZmZXJbMzJdOwkv
KjBFMDAgMEU3RiAgMzIqLworCXVpbnQzMl90IHJlc2VydmVkNVszMl07CQkvKjBFODAgMEVGRiAg
MzIqLworCXVpbnQzMl90IG1lc3NhZ2VfcmJ1ZmZlclszMl07CS8qMEYwMCAwRjdGICAzMiovCisJ
dWludDMyX3QgcmVzZXJ2ZWQ2WzMyXTsJCS8qMEY4MCAwRkZGICAzMiovCiB9OwogCiBzdHJ1Y3Qg
TWVzc2FnZVVuaXRfQgogewotCXVpbnQzMl90CXBvc3RfcWJ1ZmZlcltBUkNNU1JfTUFYX0hCQl9Q
T1NUUVVFVUVdOwotCXVpbnQzMl90CWRvbmVfcWJ1ZmZlcltBUkNNU1JfTUFYX0hCQl9QT1NUUVVF
VUVdOwotCXVpbnQzMl90CXBvc3RxX2luZGV4OwotCXVpbnQzMl90CWRvbmVxX2luZGV4OwotCXVp
bnQzMl90CQlfX2lvbWVtICpkcnYyaW9wX2Rvb3JiZWxsOwotCXVpbnQzMl90CQlfX2lvbWVtICpk
cnYyaW9wX2Rvb3JiZWxsX21hc2s7Ci0JdWludDMyX3QJCV9faW9tZW0gKmlvcDJkcnZfZG9vcmJl
bGw7Ci0JdWludDMyX3QJCV9faW9tZW0gKmlvcDJkcnZfZG9vcmJlbGxfbWFzazsKLQl1aW50MzJf
dAkJX19pb21lbSAqbWVzc2FnZV9yd2J1ZmZlcjsKLQl1aW50MzJfdAkJX19pb21lbSAqbWVzc2Fn
ZV93YnVmZmVyOwotCXVpbnQzMl90CQlfX2lvbWVtICptZXNzYWdlX3JidWZmZXI7CisJdWludDMy
X3QgcG9zdF9xYnVmZmVyW0FSQ01TUl9NQVhfSEJCX1BPU1RRVUVVRV07CisJdWludDMyX3QgZG9u
ZV9xYnVmZmVyW0FSQ01TUl9NQVhfSEJCX1BPU1RRVUVVRV07CisJdWludDMyX3QgcG9zdHFfaW5k
ZXg7CisJdWludDMyX3QgZG9uZXFfaW5kZXg7CisJdWludDMyX3QgX19pb21lbSAqZHJ2MmlvcF9k
b29yYmVsbDsKKwl1aW50MzJfdCBfX2lvbWVtICpkcnYyaW9wX2Rvb3JiZWxsX21hc2s7CisJdWlu
dDMyX3QgX19pb21lbSAqaW9wMmRydl9kb29yYmVsbDsKKwl1aW50MzJfdCBfX2lvbWVtICppb3Ay
ZHJ2X2Rvb3JiZWxsX21hc2s7CisJdWludDMyX3QgX19pb21lbSAqbWVzc2FnZV9yd2J1ZmZlcjsK
Kwl1aW50MzJfdCBfX2lvbWVtICptZXNzYWdlX3didWZmZXI7CisJdWludDMyX3QgX19pb21lbSAq
bWVzc2FnZV9yYnVmZmVyOwogfTsKIC8qCiAqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioKICoqIExTSQogKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqCiAqLwotc3RydWN0IE1lc3NhZ2VVbml0X0N7Ci0JdWludDMyX3QJbWVzc2FnZV91bml0X3N0
YXR1czsJCQkvKjAwMDAgMDAwMyovCi0JdWludDMyX3QJc2xhdmVfZXJyb3JfYXR0cmlidXRlOwkJ
CS8qMDAwNCAwMDA3Ki8KLQl1aW50MzJfdAlzbGF2ZV9lcnJvcl9hZGRyZXNzOwkJCS8qMDAwOCAw
MDBCKi8KLQl1aW50MzJfdAlwb3N0ZWRfb3V0Ym91bmRfZG9vcmJlbGw7CQkvKjAwMEMgMDAwRiov
Ci0JdWludDMyX3QJbWFzdGVyX2Vycm9yX2F0dHJpYnV0ZTsJCQkvKjAwMTAgMDAxMyovCi0JdWlu
dDMyX3QJbWFzdGVyX2Vycm9yX2FkZHJlc3NfbG93OwkJLyowMDE0IDAwMTcqLwotCXVpbnQzMl90
CW1hc3Rlcl9lcnJvcl9hZGRyZXNzX2hpZ2g7CQkvKjAwMTggMDAxQiovCi0JdWludDMyX3QJaGNi
X3NpemU7CQkJCS8qMDAxQyAwMDFGKi8KLQl1aW50MzJfdAlpbmJvdW5kX2Rvb3JiZWxsOwkJCS8q
MDAyMCAwMDIzKi8KLQl1aW50MzJfdAlkaWFnbm9zdGljX3J3X2RhdGE7CQkJLyowMDI0IDAwMjcq
LwotCXVpbnQzMl90CWRpYWdub3N0aWNfcndfYWRkcmVzc19sb3c7CQkvKjAwMjggMDAyQiovCi0J
dWludDMyX3QJZGlhZ25vc3RpY19yd19hZGRyZXNzX2hpZ2g7CQkvKjAwMkMgMDAyRiovCi0JdWlu
dDMyX3QJaG9zdF9pbnRfc3RhdHVzOwkJCQkvKjAwMzAgMDAzMyovCi0JdWludDMyX3QJaG9zdF9p
bnRfbWFzazsJCQkJLyowMDM0IDAwMzcqLwotCXVpbnQzMl90CWRjcl9kYXRhOwkJCQkvKjAwMzgg
MDAzQiovCi0JdWludDMyX3QJZGNyX2FkZHJlc3M7CQkJCS8qMDAzQyAwMDNGKi8KLQl1aW50MzJf
dAlpbmJvdW5kX3F1ZXVlcG9ydDsJCQkvKjAwNDAgMDA0MyovCi0JdWludDMyX3QJb3V0Ym91bmRf
cXVldWVwb3J0OwkJCS8qMDA0NCAwMDQ3Ki8KLQl1aW50MzJfdAloY2JfcGNpX2FkZHJlc3NfbG93
OwkJCS8qMDA0OCAwMDRCKi8KLQl1aW50MzJfdAloY2JfcGNpX2FkZHJlc3NfaGlnaDsJCQkvKjAw
NEMgMDA0RiovCi0JdWludDMyX3QJaW9wX2ludF9zdGF0dXM7CQkJCS8qMDA1MCAwMDUzKi8KLQl1
aW50MzJfdAlpb3BfaW50X21hc2s7CQkJCS8qMDA1NCAwMDU3Ki8KLQl1aW50MzJfdAlpb3BfaW5i
b3VuZF9xdWV1ZV9wb3J0OwkJCS8qMDA1OCAwMDVCKi8KLQl1aW50MzJfdAlpb3Bfb3V0Ym91bmRf
cXVldWVfcG9ydDsJCS8qMDA1QyAwMDVGKi8KLQl1aW50MzJfdAlpbmJvdW5kX2ZyZWVfbGlzdF9p
bmRleDsJCQkvKjAwNjAgMDA2MyovCi0JdWludDMyX3QJaW5ib3VuZF9wb3N0X2xpc3RfaW5kZXg7
CQkJLyowMDY0IDAwNjcqLwotCXVpbnQzMl90CW91dGJvdW5kX2ZyZWVfbGlzdF9pbmRleDsJCQkv
KjAwNjggMDA2QiovCi0JdWludDMyX3QJb3V0Ym91bmRfcG9zdF9saXN0X2luZGV4OwkJCS8qMDA2
QyAwMDZGKi8KLQl1aW50MzJfdAlpbmJvdW5kX2Rvb3JiZWxsX2NsZWFyOwkJCS8qMDA3MCAwMDcz
Ki8KLQl1aW50MzJfdAlpMm9fbWVzc2FnZV91bml0X2NvbnRyb2w7CQkJLyowMDc0IDAwNzcqLwot
CXVpbnQzMl90CWxhc3RfdXNlZF9tZXNzYWdlX3NvdXJjZV9hZGRyZXNzX2xvdzsJLyowMDc4IDAw
N0IqLwotCXVpbnQzMl90CWxhc3RfdXNlZF9tZXNzYWdlX3NvdXJjZV9hZGRyZXNzX2hpZ2g7CS8q
MDA3QyAwMDdGKi8KLQl1aW50MzJfdAlwdWxsX21vZGVfZGF0YV9ieXRlX2NvdW50WzRdOwkJLyow
MDgwIDAwOEYqLwotCXVpbnQzMl90CW1lc3NhZ2VfZGVzdF9hZGRyZXNzX2luZGV4OwkJLyowMDkw
IDAwOTMqLwotCXVpbnQzMl90CWRvbmVfcXVldWVfbm90X2VtcHR5X2ludF9jb3VudGVyX3RpbWVy
OwkvKjAwOTQgMDA5NyovCi0JdWludDMyX3QJdXRpbGl0eV9BX2ludF9jb3VudGVyX3RpbWVyOwkJ
LyowMDk4IDAwOUIqLwotCXVpbnQzMl90CW91dGJvdW5kX2Rvb3JiZWxsOwkJCS8qMDA5QyAwMDlG
Ki8KLQl1aW50MzJfdAlvdXRib3VuZF9kb29yYmVsbF9jbGVhcjsJCQkvKjAwQTAgMDBBMyovCi0J
dWludDMyX3QJbWVzc2FnZV9zb3VyY2VfYWRkcmVzc19pbmRleDsJCS8qMDBBNCAwMEE3Ki8KLQl1
aW50MzJfdAltZXNzYWdlX2RvbmVfcXVldWVfaW5kZXg7CQkvKjAwQTggMDBBQiovCi0JdWludDMy
X3QJcmVzZXJ2ZWQwOwkJCQkvKjAwQUMgMDBBRiovCi0JdWludDMyX3QJaW5ib3VuZF9tc2dhZGRy
MDsJCQkvKjAwQjAgMDBCMyovCi0JdWludDMyX3QJaW5ib3VuZF9tc2dhZGRyMTsJCQkvKjAwQjQg
MDBCNyovCi0JdWludDMyX3QJb3V0Ym91bmRfbXNnYWRkcjA7CQkJLyowMEI4IDAwQkIqLwotCXVp
bnQzMl90CW91dGJvdW5kX21zZ2FkZHIxOwkJCS8qMDBCQyAwMEJGKi8KLQl1aW50MzJfdAlpbmJv
dW5kX3F1ZXVlcG9ydF9sb3c7CQkJLyowMEMwIDAwQzMqLwotCXVpbnQzMl90CWluYm91bmRfcXVl
dWVwb3J0X2hpZ2g7CQkJLyowMEM0IDAwQzcqLwotCXVpbnQzMl90CW91dGJvdW5kX3F1ZXVlcG9y
dF9sb3c7CQkJLyowMEM4IDAwQ0IqLwotCXVpbnQzMl90CW91dGJvdW5kX3F1ZXVlcG9ydF9oaWdo
OwkJLyowMENDIDAwQ0YqLwotCXVpbnQzMl90CWlvcF9pbmJvdW5kX3F1ZXVlX3BvcnRfbG93OwkJ
LyowMEQwIDAwRDMqLwotCXVpbnQzMl90CWlvcF9pbmJvdW5kX3F1ZXVlX3BvcnRfaGlnaDsJCS8q
MDBENCAwMEQ3Ki8KLQl1aW50MzJfdAlpb3Bfb3V0Ym91bmRfcXVldWVfcG9ydF9sb3c7CQkvKjAw
RDggMDBEQiovCi0JdWludDMyX3QJaW9wX291dGJvdW5kX3F1ZXVlX3BvcnRfaGlnaDsJCS8qMDBE
QyAwMERGKi8KLQl1aW50MzJfdAltZXNzYWdlX2Rlc3RfcXVldWVfcG9ydF9sb3c7CQkvKjAwRTAg
MDBFMyovCi0JdWludDMyX3QJbWVzc2FnZV9kZXN0X3F1ZXVlX3BvcnRfaGlnaDsJCS8qMDBFNCAw
MEU3Ki8KLQl1aW50MzJfdAlsYXN0X3VzZWRfbWVzc2FnZV9kZXN0X2FkZHJlc3NfbG93OwkvKjAw
RTggMDBFQiovCi0JdWludDMyX3QJbGFzdF91c2VkX21lc3NhZ2VfZGVzdF9hZGRyZXNzX2hpZ2g7
CS8qMDBFQyAwMEVGKi8KLQl1aW50MzJfdAltZXNzYWdlX2RvbmVfcXVldWVfYmFzZV9hZGRyZXNz
X2xvdzsJLyowMEYwIDAwRjMqLwotCXVpbnQzMl90CW1lc3NhZ2VfZG9uZV9xdWV1ZV9iYXNlX2Fk
ZHJlc3NfaGlnaDsJLyowMEY0IDAwRjcqLwotCXVpbnQzMl90CWhvc3RfZGlhZ25vc3RpYzsJCQkJ
LyowMEY4IDAwRkIqLwotCXVpbnQzMl90CXdyaXRlX3NlcXVlbmNlOwkJCQkvKjAwRkMgMDBGRiov
Ci0JdWludDMyX3QJcmVzZXJ2ZWQxWzM0XTsJCQkJLyowMTAwIDAxODcqLwotCXVpbnQzMl90CXJl
c2VydmVkMlsxOTUwXTsJCQkJLyowMTg4IDFGRkYqLwotCXVpbnQzMl90CW1lc3NhZ2Vfd2J1ZmZl
clszMl07CQkJLyoyMDAwIDIwN0YqLwotCXVpbnQzMl90CXJlc2VydmVkM1szMl07CQkJCS8qMjA4
MCAyMEZGKi8KLQl1aW50MzJfdAltZXNzYWdlX3JidWZmZXJbMzJdOwkJCS8qMjEwMCAyMTdGKi8K
LQl1aW50MzJfdAlyZXNlcnZlZDRbMzJdOwkJCQkvKjIxODAgMjFGRiovCi0JdWludDMyX3QJbXNn
Y29kZV9yd2J1ZmZlclsyNTZdOwkJCS8qMjIwMCAyM0ZGKi8KK3N0cnVjdCBNZXNzYWdlVW5pdF9D
IHsKKwl1aW50MzJfdCBtZXNzYWdlX3VuaXRfc3RhdHVzOwkJCS8qMDAwMCAwMDAzKi8KKwl1aW50
MzJfdCBzbGF2ZV9lcnJvcl9hdHRyaWJ1dGU7CQkJLyowMDA0IDAwMDcqLworCXVpbnQzMl90IHNs
YXZlX2Vycm9yX2FkZHJlc3M7CQkJLyowMDA4IDAwMEIqLworCXVpbnQzMl90IHBvc3RlZF9vdXRi
b3VuZF9kb29yYmVsbDsJCQkvKjAwMEMgMDAwRiovCisJdWludDMyX3QgbWFzdGVyX2Vycm9yX2F0
dHJpYnV0ZTsJCQkvKjAwMTAgMDAxMyovCisJdWludDMyX3QgbWFzdGVyX2Vycm9yX2FkZHJlc3Nf
bG93OwkJCS8qMDAxNCAwMDE3Ki8KKwl1aW50MzJfdCBtYXN0ZXJfZXJyb3JfYWRkcmVzc19oaWdo
OwkJLyowMDE4IDAwMUIqLworCXVpbnQzMl90IGhjYl9zaXplOwkJCQkJLyowMDFDIDAwMUYqLwor
CXVpbnQzMl90IGluYm91bmRfZG9vcmJlbGw7CQkJCS8qMDAyMCAwMDIzKi8KKwl1aW50MzJfdCBk
aWFnbm9zdGljX3J3X2RhdGE7CQkJLyowMDI0IDAwMjcqLworCXVpbnQzMl90IGRpYWdub3N0aWNf
cndfYWRkcmVzc19sb3c7CQkvKjAwMjggMDAyQiovCisJdWludDMyX3QgZGlhZ25vc3RpY19yd19h
ZGRyZXNzX2hpZ2g7CQkvKjAwMkMgMDAyRiovCisJdWludDMyX3QgaG9zdF9pbnRfc3RhdHVzOwkJ
CQkvKjAwMzAgMDAzMyovCisJdWludDMyX3QgaG9zdF9pbnRfbWFzazsJCQkJLyowMDM0IDAwMzcq
LworCXVpbnQzMl90IGRjcl9kYXRhOwkJCQkJLyowMDM4IDAwM0IqLworCXVpbnQzMl90IGRjcl9h
ZGRyZXNzOwkJCQkvKjAwM0MgMDAzRiovCisJdWludDMyX3QgaW5ib3VuZF9xdWV1ZXBvcnQ7CQkJ
LyowMDQwIDAwNDMqLworCXVpbnQzMl90IG91dGJvdW5kX3F1ZXVlcG9ydDsJCQkvKjAwNDQgMDA0
NyovCisJdWludDMyX3QgaGNiX3BjaV9hZGRyZXNzX2xvdzsJCQkvKjAwNDggMDA0QiovCisJdWlu
dDMyX3QgaGNiX3BjaV9hZGRyZXNzX2hpZ2g7CQkJLyowMDRDIDAwNEYqLworCXVpbnQzMl90IGlv
cF9pbnRfc3RhdHVzOwkJCQkvKjAwNTAgMDA1MyovCisJdWludDMyX3QgaW9wX2ludF9tYXNrOwkJ
CQkvKjAwNTQgMDA1NyovCisJdWludDMyX3QgaW9wX2luYm91bmRfcXVldWVfcG9ydDsJCQkvKjAw
NTggMDA1QiovCisJdWludDMyX3QgaW9wX291dGJvdW5kX3F1ZXVlX3BvcnQ7CQkJLyowMDVDIDAw
NUYqLworCXVpbnQzMl90IGluYm91bmRfZnJlZV9saXN0X2luZGV4OwkJCS8qMDA2MCAwMDYzKi8K
Kwl1aW50MzJfdCBpbmJvdW5kX3Bvc3RfbGlzdF9pbmRleDsJCQkvKjAwNjQgMDA2NyovCisJdWlu
dDMyX3Qgb3V0Ym91bmRfZnJlZV9saXN0X2luZGV4OwkJCS8qMDA2OCAwMDZCKi8KKwl1aW50MzJf
dCBvdXRib3VuZF9wb3N0X2xpc3RfaW5kZXg7CQkJLyowMDZDIDAwNkYqLworCXVpbnQzMl90IGlu
Ym91bmRfZG9vcmJlbGxfY2xlYXI7CQkJLyowMDcwIDAwNzMqLworCXVpbnQzMl90IGkyb19tZXNz
YWdlX3VuaXRfY29udHJvbDsJCQkvKjAwNzQgMDA3NyovCisJdWludDMyX3QgbGFzdF91c2VkX21l
c3NhZ2Vfc291cmNlX2FkZHJlc3NfbG93OwkvKjAwNzggMDA3QiovCisJdWludDMyX3QgbGFzdF91
c2VkX21lc3NhZ2Vfc291cmNlX2FkZHJlc3NfaGlnaDsJLyowMDdDIDAwN0YqLworCXVpbnQzMl90
IHB1bGxfbW9kZV9kYXRhX2J5dGVfY291bnRbNF07CQkvKjAwODAgMDA4RiovCisJdWludDMyX3Qg
bWVzc2FnZV9kZXN0X2FkZHJlc3NfaW5kZXg7CQkvKjAwOTAgMDA5MyovCisJdWludDMyX3QgZG9u
ZV9xdWV1ZV9ub3RfZW1wdHlfaW50X2NvdW50ZXJfdGltZXI7CS8qMDA5NCAwMDk3Ki8KKwl1aW50
MzJfdCB1dGlsaXR5X0FfaW50X2NvdW50ZXJfdGltZXI7CQkvKjAwOTggMDA5QiovCisJdWludDMy
X3Qgb3V0Ym91bmRfZG9vcmJlbGw7CQkJLyowMDlDIDAwOUYqLworCXVpbnQzMl90IG91dGJvdW5k
X2Rvb3JiZWxsX2NsZWFyOwkJCS8qMDBBMCAwMEEzKi8KKwl1aW50MzJfdCBtZXNzYWdlX3NvdXJj
ZV9hZGRyZXNzX2luZGV4OwkJLyowMEE0IDAwQTcqLworCXVpbnQzMl90IG1lc3NhZ2VfZG9uZV9x
dWV1ZV9pbmRleDsJCS8qMDBBOCAwMEFCKi8KKwl1aW50MzJfdCByZXNlcnZlZDA7CQkJCS8qMDBB
QyAwMEFGKi8KKwl1aW50MzJfdCBpbmJvdW5kX21zZ2FkZHIwOwkJCS8qMDBCMCAwMEIzKi8KKwl1
aW50MzJfdCBpbmJvdW5kX21zZ2FkZHIxOwkJCS8qMDBCNCAwMEI3Ki8KKwl1aW50MzJfdCBvdXRi
b3VuZF9tc2dhZGRyMDsJCQkvKjAwQjggMDBCQiovCisJdWludDMyX3Qgb3V0Ym91bmRfbXNnYWRk
cjE7CQkJLyowMEJDIDAwQkYqLworCXVpbnQzMl90IGluYm91bmRfcXVldWVwb3J0X2xvdzsJCQkv
KjAwQzAgMDBDMyovCisJdWludDMyX3QgaW5ib3VuZF9xdWV1ZXBvcnRfaGlnaDsJCQkvKjAwQzQg
MDBDNyovCisJdWludDMyX3Qgb3V0Ym91bmRfcXVldWVwb3J0X2xvdzsJCQkvKjAwQzggMDBDQiov
CisJdWludDMyX3Qgb3V0Ym91bmRfcXVldWVwb3J0X2hpZ2g7CQkvKjAwQ0MgMDBDRiovCisJdWlu
dDMyX3QgaW9wX2luYm91bmRfcXVldWVfcG9ydF9sb3c7CQkvKjAwRDAgMDBEMyovCisJdWludDMy
X3QgaW9wX2luYm91bmRfcXVldWVfcG9ydF9oaWdoOwkJLyowMEQ0IDAwRDcqLworCXVpbnQzMl90
IGlvcF9vdXRib3VuZF9xdWV1ZV9wb3J0X2xvdzsJCS8qMDBEOCAwMERCKi8KKwl1aW50MzJfdCBp
b3Bfb3V0Ym91bmRfcXVldWVfcG9ydF9oaWdoOwkJLyowMERDIDAwREYqLworCXVpbnQzMl90IG1l
c3NhZ2VfZGVzdF9xdWV1ZV9wb3J0X2xvdzsJCS8qMDBFMCAwMEUzKi8KKwl1aW50MzJfdCBtZXNz
YWdlX2Rlc3RfcXVldWVfcG9ydF9oaWdoOwkJLyowMEU0IDAwRTcqLworCXVpbnQzMl90IGxhc3Rf
dXNlZF9tZXNzYWdlX2Rlc3RfYWRkcmVzc19sb3c7CS8qMDBFOCAwMEVCKi8KKwl1aW50MzJfdCBs
YXN0X3VzZWRfbWVzc2FnZV9kZXN0X2FkZHJlc3NfaGlnaDsJLyowMEVDIDAwRUYqLworCXVpbnQz
Ml90IG1lc3NhZ2VfZG9uZV9xdWV1ZV9iYXNlX2FkZHJlc3NfbG93OwkvKjAwRjAgMDBGMyovCisJ
dWludDMyX3QgbWVzc2FnZV9kb25lX3F1ZXVlX2Jhc2VfYWRkcmVzc19oaWdoOwkvKjAwRjQgMDBG
NyovCisJdWludDMyX3QgaG9zdF9kaWFnbm9zdGljOwkJCQkvKjAwRjggMDBGQiovCisJdWludDMy
X3Qgd3JpdGVfc2VxdWVuY2U7CQkJCS8qMDBGQyAwMEZGKi8KKwl1aW50MzJfdCByZXNlcnZlZDFb
MzRdOwkJCQkvKjAxMDAgMDE4NyovCisJdWludDMyX3QgcmVzZXJ2ZWQyWzE5NTBdOwkJCQkvKjAx
ODggMUZGRiovCisJdWludDMyX3QgbWVzc2FnZV93YnVmZmVyWzMyXTsJCQkvKjIwMDAgMjA3Riov
CisJdWludDMyX3QgcmVzZXJ2ZWQzWzMyXTsJCQkJLyoyMDgwIDIwRkYqLworCXVpbnQzMl90IG1l
c3NhZ2VfcmJ1ZmZlclszMl07CQkJLyoyMTAwIDIxN0YqLworCXVpbnQzMl90IHJlc2VydmVkNFsz
Ml07CQkJCS8qMjE4MCAyMUZGKi8KKwl1aW50MzJfdCBtc2djb2RlX3J3YnVmZmVyWzI1Nl07CQkJ
LyoyMjAwIDIzRkYqLworfTsKK3N0cnVjdCBJbkJvdW5kX1NSQiB7CisJdWludDMyX3QgYWRkcmVz
c0xvdzsvKnBvaW50ZXIgdG8gU1JCIGJsb2NrKi8KKwl1aW50MzJfdCBhZGRyZXNzSGlnaDsKKwl1
aW50MzJfdCBsZW5ndGg7LyppbiBEV09SRHMqLworCXVpbnQzMl90IHJlc2VydmVkMDsKK307CisK
K3N0cnVjdCBPdXRCb3VuZF9TUkIgeworCXVpbnQzMl90IGFkZHJlc3NMb3c7Lypwb2ludGVyIHRv
IFNSQiBibG9jayovCisJdWludDMyX3QgYWRkcmVzc0hpZ2g7Cit9OworCitzdHJ1Y3QgTWVzc2Fn
ZVVuaXRfRCB7CisJc3RydWN0IEluQm91bmRfU1JCIHBvc3RfcWJ1ZmZlcltBUkNNU1JfTUFYX0FS
QzEyMTRfUE9TVFFVRVVFXTsKKwlzdHJ1Y3QgT3V0Qm91bmRfU1JCIGRvbmVfcWJ1ZmZlcltBUkNN
U1JfTUFYX0FSQzEyMTRfRE9ORVFVRVVFXTsKKwl1MTYgcG9zdHFfaW5kZXg7CisJdTE2IGRvbmVx
X2luZGV4OworCXUzMiBfX2lvbWVtICpjaGlwX2lkOwkJCS8qMHgwMDAwNCovCisJdTMyIF9faW9t
ZW0gKmNwdV9tZW1fY29uZmlnOwkJLyoweDAwMDA4Ki8KKwl1MzIgX19pb21lbSAqaTJvX2hvc3Rf
aW50ZXJydXB0X21hc2s7CS8qMHgwMDAzNCovCisJdTMyIF9faW9tZW0gKnNhbXBsZV9hdF9yZXNl
dDsJCS8qMHgwMDEwMCovCisJdTMyIF9faW9tZW0gKnJlc2V0X3JlcXVlc3Q7CQkvKjB4MDAxMDgq
LworCXUzMiBfX2lvbWVtICpob3N0X2ludF9zdGF0dXM7CQkvKjB4MDAyMDAqLworCXUzMiBfX2lv
bWVtICpwY2llZjBfaW50X2VuYWJsZTsJCS8qMHgwMDIwQyovCisJdTMyIF9faW9tZW0gKmluYm91
bmRfbXNnYWRkcjA7CQkvKjB4MDA0MDAqLworCXUzMiBfX2lvbWVtICppbmJvdW5kX21zZ2FkZHIx
OwkJLyoweDAwNDA0Ki8KKwl1MzIgX19pb21lbSAqb3V0Ym91bmRfbXNnYWRkcjA7CQkvKjB4MDA0
MjAqLworCXUzMiBfX2lvbWVtICpvdXRib3VuZF9tc2dhZGRyMTsJCS8qMHgwMDQyNCovCisJdTMy
IF9faW9tZW0gKmluYm91bmRfZG9vcmJlbGw7CQkvKjB4MDA0NjAqLworCXUzMiBfX2lvbWVtICpv
dXRib3VuZF9kb29yYmVsbDsJCS8qMHgwMDQ4MCovCisJdTMyIF9faW9tZW0gKm91dGJvdW5kX2Rv
b3JiZWxsX2VuYWJsZTsJLyoweDAwNDg0Ki8KKwl1MzIgX19pb21lbSAqaW5ib3VuZGxpc3RfYmFz
ZV9sb3c7CS8qMHgwMTAwMCovCisJdTMyIF9faW9tZW0gKmluYm91bmRsaXN0X2Jhc2VfaGlnaDsJ
LyoweDAxMDA0Ki8KKwl1MzIgX19pb21lbSAqaW5ib3VuZGxpc3Rfd3JpdGVfcG9pbnRlcjsJLyow
eDAxMDE4Ki8KKwl1MzIgX19pb21lbSAqb3V0Ym91bmRsaXN0X2Jhc2VfbG93OwkvKjB4MDEwNjAq
LworCXUzMiBfX2lvbWVtICpvdXRib3VuZGxpc3RfYmFzZV9oaWdoOwkvKjB4MDEwNjQqLworCXUz
MiBfX2lvbWVtICpvdXRib3VuZGxpc3RfY29weV9wb2ludGVyOwkvKjB4MDEwNkMqLworCXUzMiBf
X2lvbWVtICpvdXRib3VuZGxpc3RfcmVhZF9wb2ludGVyOwkvKjB4MDEwNzAgMHgwMTA3MiovCisJ
dTMyIF9faW9tZW0gKm91dGJvdW5kbGlzdF9pbnRlcnJ1cHRfY2F1c2U7CS8qMHgxMDg4Ki8KKwl1
MzIgX19pb21lbSAqb3V0Ym91bmRsaXN0X2ludGVycnVwdF9lbmFibGU7CS8qMHgxMDhDKi8KKwl1
MzIgX19pb21lbSAqbWVzc2FnZV93YnVmZmVyOwkJLyoweDIwMDAqLworCXUzMiBfX2lvbWVtICpt
ZXNzYWdlX3JidWZmZXI7CQkvKjB4MjEwMCovCisJdTMyIF9faW9tZW0gKm1zZ2NvZGVfcndidWZm
ZXI7CQkvKjB4MjIwMCovCiB9OwogLyoKICoqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioKQEAgLTUwMCwx
MDAgKzYwMiwxMTAgQEAgc3RydWN0IE1lc3NhZ2VVbml0X0N7CiAqLwogc3RydWN0IEFkYXB0ZXJD
b250cm9sQmxvY2sKIHsKLQl1aW50MzJfdCAgYWRhcHRlcl90eXBlOyAgICAgICAgICAgICAgICAv
KiBhZGFwdGVyIEEsQi4uLi4uICovCi0JI2RlZmluZSBBQ0JfQURBUFRFUl9UWVBFX0EgICAgICAg
ICAgICAweDAwMDAwMDAxCS8qIGhiYSBJIElPUCAqLwotCSNkZWZpbmUgQUNCX0FEQVBURVJfVFlQ
RV9CICAgICAgICAgICAgMHgwMDAwMDAwMgkvKiBoYmIgTSBJT1AgKi8KLQkjZGVmaW5lIEFDQl9B
REFQVEVSX1RZUEVfQyAgICAgICAgICAgIDB4MDAwMDAwMDQJLyogaGJjIFAgSU9QICovCi0JI2Rl
ZmluZSBBQ0JfQURBUFRFUl9UWVBFX0QgICAgICAgICAgICAweDAwMDAwMDA4CS8qIGhiZCBBIElP
UCAqLwotCXN0cnVjdCBwY2lfZGV2ICoJCXBkZXY7Ci0Jc3RydWN0IFNjc2lfSG9zdCAqCQlob3N0
OwotCXVuc2lnbmVkIGxvbmcJCQl2aXIycGh5X29mZnNldDsKKwl1aW50MzJfdCBhZGFwdGVyX3R5
cGU7CS8qIGFkYXB0ZXIgQSxCLi4uLi4gKi8KKwkjZGVmaW5lIEFDQl9BREFQVEVSX1RZUEVfQQkw
eDAwMDAwMDAxCS8qIGhiYSBJIElPUCAqLworCSNkZWZpbmUgQUNCX0FEQVBURVJfVFlQRV9CCTB4
MDAwMDAwMDIJLyogaGJiIE0gSU9QICovCisJI2RlZmluZSBBQ0JfQURBUFRFUl9UWVBFX0MJMHgw
MDAwMDAwNAkvKiBoYmMgUCBJT1AgKi8KKwkjZGVmaW5lIEFDQl9BREFQVEVSX1RZUEVfRAkweDAw
MDAwMDA4CS8qIGhiZCBBIElPUCAqLworCXUzMiByb3VuZHVwX2NjYnNpemU7CisJc3RydWN0IHBj
aV9kZXYgKnBkZXY7CisJc3RydWN0IFNjc2lfSG9zdCAqaG9zdDsKKwl1bnNpZ25lZCBsb25nIHZp
cjJwaHlfb2Zmc2V0OworCXN0cnVjdCBtc2l4X2VudHJ5IGVudHJpZXNbQVJDTVNUX05VTV9NU0lY
X1ZFQ1RPUlNdOwogCS8qIE9mZnNldCBpcyB1c2VkIGluIG1ha2luZyBhcmMgY2RiIHBoeXNpY2Fs
IHRvIHZpcnR1YWwgY2FsY3VsYXRpb25zICovCi0JdWludDMyX3QJCQlvdXRib3VuZF9pbnRfZW5h
YmxlOwotCXVpbnQzMl90CQkJY2RiX3BoeWFkZHJfaGkzMjsKLQl1aW50MzJfdAkJCXJlZ19tdV9h
Y2NfaGFuZGxlMDsKLQlzcGlubG9ja190ICAgICAgICAgICAgICAgICAgICAgIAkJCWVoX2xvY2s7
Ci0Jc3BpbmxvY2tfdCAgICAgICAgICAgICAgICAgICAgICAJCQljY2JsaXN0X2xvY2s7CisJdWlu
dDMyX3Qgb3V0Ym91bmRfaW50X2VuYWJsZTsKKwl1aW50MzJfdCBjZGJfcGh5YWRkcl9oaTMyOwor
CXNwaW5sb2NrX3QgZWhfbG9jazsKKwlzcGlubG9ja190IGNjYmxpc3RfbG9jazsKKwlzcGlubG9j
a190IHBvc3RxX2xvY2s7CisJc3BpbmxvY2tfdCBkb25lcV9sb2NrOworCXNwaW5sb2NrX3QgcnFi
dWZmZXJfbG9jazsKKwlzcGlubG9ja190IHdxYnVmZmVyX2xvY2s7CiAJdW5pb24gewogCQlzdHJ1
Y3QgTWVzc2FnZVVuaXRfQSBfX2lvbWVtICpwbXVBOwotCQlzdHJ1Y3QgTWVzc2FnZVVuaXRfQiAJ
KnBtdUI7CisJCXN0cnVjdCBNZXNzYWdlVW5pdF9CIF9faW9tZW0gKnBtdUI7CiAJCXN0cnVjdCBN
ZXNzYWdlVW5pdF9DIF9faW9tZW0gKnBtdUM7CisJCXN0cnVjdCBNZXNzYWdlVW5pdF9EIF9faW9t
ZW0gKnBtdUQ7CiAJfTsKIAkvKiBtZXNzYWdlIHVuaXQgQVRVIGluYm91bmQgYmFzZSBhZGRyZXNz
MCAqLwogCXZvaWQgX19pb21lbSAqbWVtX2Jhc2UwOwogCXZvaWQgX19pb21lbSAqbWVtX2Jhc2Ux
OwotCXVpbnQzMl90CQkJYWNiX2ZsYWdzOwotCXUxNgkJCWRldl9pZDsKLQl1aW50OF90ICAgICAg
ICAgICAgICAgICAgIAkJYWRhcHRlcl9pbmRleDsKLQkjZGVmaW5lIEFDQl9GX1NDU0lTVE9QQURB
UFRFUiAgICAgICAgIAkweDAwMDEKLQkjZGVmaW5lIEFDQl9GX01TR19TVE9QX0JHUkIgICAgIAkw
eDAwMDIKKwl1aW50MzJfdCBhY2JfZmxhZ3M7CisJdTE2IGRldl9pZDsKKwl1aW50OF90IGFkYXB0
ZXJfaW5kZXg7CisJI2RlZmluZSBBQ0JfRl9TQ1NJU1RPUEFEQVBURVIJCQkweDAwMDEKKwkjZGVm
aW5lIEFDQl9GX01TR19TVE9QX0JHUkIJCQkweDAwMDIKIAkvKiBzdG9wIFJBSUQgYmFja2dyb3Vu
ZCByZWJ1aWxkICovCi0JI2RlZmluZSBBQ0JfRl9NU0dfU1RBUlRfQkdSQiAgICAgICAgICAJMHgw
MDA0CisJI2RlZmluZSBBQ0JfRl9NU0dfU1RBUlRfQkdSQgkJCTB4MDAwNAogCS8qIHN0b3AgUkFJ
RCBiYWNrZ3JvdW5kIHJlYnVpbGQgKi8KLQkjZGVmaW5lIEFDQl9GX0lPUERBVEFfT1ZFUkZMT1cg
ICAgICAgIAkweDAwMDgKKwkjZGVmaW5lIEFDQl9GX0lPUERBVEFfT1ZFUkZMT1cJCTB4MDAwOAog
CS8qIGlvcCBtZXNzYWdlIGRhdGEgcnFidWZmZXIgb3ZlcmZsb3cgKi8KIAkjZGVmaW5lIEFDQl9G
X01FU1NBR0VfV1FCVUZGRVJfQ0xFQVJFRAkweDAwMTAKIAkvKiBtZXNzYWdlIGNsZWFyIHdxYnVm
ZmVyICovCi0JI2RlZmluZSBBQ0JfRl9NRVNTQUdFX1JRQlVGRkVSX0NMRUFSRUQgIDB4MDAyMAor
CSNkZWZpbmUgQUNCX0ZfTUVTU0FHRV9SUUJVRkZFUl9DTEVBUkVECTB4MDAyMAogCS8qIG1lc3Nh
Z2UgY2xlYXIgcnFidWZmZXIgKi8KLQkjZGVmaW5lIEFDQl9GX01FU1NBR0VfV1FCVUZGRVJfUkVB
REVEICAgMHgwMDQwCi0JI2RlZmluZSBBQ0JfRl9CVVNfUkVTRVQgICAgICAgICAgICAgICAJMHgw
MDgwCi0JI2RlZmluZSBBQ0JfRl9CVVNfSEFOR19PTgkJMHgwODAwLyogbmVlZCBoYXJkd2FyZSBy
ZXNldCBidXMgKi8KKwkjZGVmaW5lIEFDQl9GX01FU1NBR0VfV1FCVUZGRVJfUkVBREVECTB4MDA0
MAorCSNkZWZpbmUgQUNCX0ZfQlVTX1JFU0VUCQkJCTB4MDA4MAorCSNkZWZpbmUgQUNCX0ZfQlVT
X0hBTkdfT04JCQkweDA4MDAKIAotCSNkZWZpbmUgQUNCX0ZfSU9QX0lOSVRFRCAgICAgICAgICAg
ICAgCTB4MDEwMAorCSNkZWZpbmUgQUNCX0ZfSU9QX0lOSVRFRAkJCQkweDAxMDAKIAkvKiBpb3Ag
aW5pdCAqLwogCSNkZWZpbmUgQUNCX0ZfQUJPUlQJCQkJMHgwMjAwCi0JI2RlZmluZSBBQ0JfRl9G
SVJNV0FSRV9UUkFQICAgICAgICAgICAJCTB4MDQwMAotCXN0cnVjdCBDb21tYW5kQ29udHJvbEJs
b2NrICoJCQlwY2NiX3Bvb2xbQVJDTVNSX01BWF9GUkVFQ0NCX05VTV07CisJI2RlZmluZSBBQ0Jf
Rl9GSVJNV0FSRV9UUkFQCQkJMHgwNDAwCisJI2RlZmluZSBBQ0JfRl9NU0lfRU5BQkxFRAkJCTB4
MTAwMAorCSNkZWZpbmUgQUNCX0ZfTVNJWF9FTkFCTEVECQkJMHgyMDAwCisJc3RydWN0IENvbW1h
bmRDb250cm9sQmxvY2sgKnBjY2JfcG9vbFtBUkNNU1JfTUFYX0ZSRUVDQ0JfTlVNXTsKIAkvKiB1
c2VkIGZvciBtZW1vcnkgZnJlZSAqLwotCXN0cnVjdCBsaXN0X2hlYWQJCWNjYl9mcmVlX2xpc3Q7
CisJc3RydWN0IGxpc3RfaGVhZCBjY2JfZnJlZV9saXN0OwogCS8qIGhlYWQgb2YgZnJlZSBjY2Ig
bGlzdCAqLwogCi0JYXRvbWljX3QJCQljY2JvdXRzdGFuZGluZ2NvdW50OworCWF0b21pY190IGNj
Ym91dHN0YW5kaW5nY291bnQ7CiAJLypUaGUgcHJlc2VudCBvdXRzdGFuZGluZyBjb21tYW5kIG51
bWJlciB0aGF0IGluIHRoZSBJT1AgdGhhdAogCQkJCQl3YWl0aW5nIGZvciBiZWluZyBoYW5kbGVk
IGJ5IEZXKi8KIAotCXZvaWQgKgkJCQlkbWFfY29oZXJlbnQ7CisJdm9pZCAqZG1hX2NvaGVyZW50
OwogCS8qIGRtYV9jb2hlcmVudCB1c2VkIGZvciBtZW1vcnkgZnJlZSAqLwotCWRtYV9hZGRyX3QJ
CQlkbWFfY29oZXJlbnRfaGFuZGxlOworCWRtYV9hZGRyX3QgZG1hX2NvaGVyZW50X2hhbmRsZTsK
IAkvKiBkbWFfY29oZXJlbnRfaGFuZGxlIHVzZWQgZm9yIG1lbW9yeSBmcmVlICovCi0JZG1hX2Fk
ZHJfdAkJCQlkbWFfY29oZXJlbnRfaGFuZGxlX2hiYl9tdTsKLQl1bnNpZ25lZCBpbnQJCQkJdW5j
YWNoZV9zaXplOwotCXVpbnQ4X3QJCQkJcnFidWZmZXJbQVJDTVNSX01BWF9RQlVGRkVSXTsKKwlk
bWFfYWRkcl90IGRtYV9jb2hlcmVudF9oYW5kbGUyOworCXZvaWQgKmRtYV9jb2hlcmVudDI7CisJ
dW5zaWduZWQgaW50IHVuY2FjaGVfc2l6ZTsKKwl1aW50OF90IHJxYnVmZmVyW0FSQ01TUl9NQVhf
UUJVRkZFUl07CiAJLyogZGF0YSBjb2xsZWN0aW9uIGJ1ZmZlciBmb3IgcmVhZCBmcm9tIDgwMzMx
ICovCi0JaW50MzJfdAkJCQlycWJ1Zl9maXJzdGluZGV4OworCXVpbnQzMl90IHJxYnVmX2ZpcnN0
aW5kZXg7CiAJLyogZmlyc3Qgb2YgcmVhZCBidWZmZXIgICovCi0JaW50MzJfdAkJCQlycWJ1Zl9s
YXN0aW5kZXg7CisJdWludDMyX3QgcnFidWZfbGFzdGluZGV4OwogCS8qIGxhc3Qgb2YgcmVhZCBi
dWZmZXIgICAqLwotCXVpbnQ4X3QJCQkJd3FidWZmZXJbQVJDTVNSX01BWF9RQlVGRkVSXTsKKwl1
aW50OF90IHdxYnVmZmVyW0FSQ01TUl9NQVhfUUJVRkZFUl07CiAJLyogZGF0YSBjb2xsZWN0aW9u
IGJ1ZmZlciBmb3Igd3JpdGUgdG8gODAzMzEgICovCi0JaW50MzJfdAkJCQl3cWJ1Zl9maXJzdGlu
ZGV4OworCXVpbnQzMl90IHdxYnVmX2ZpcnN0aW5kZXg7CiAJLyogZmlyc3Qgb2Ygd3JpdGUgYnVm
ZmVyICovCi0JaW50MzJfdAkJCQl3cWJ1Zl9sYXN0aW5kZXg7CisJdWludDMyX3Qgd3FidWZfbGFz
dGluZGV4OwogCS8qIGxhc3Qgb2Ygd3JpdGUgYnVmZmVyICAqLwotCXVpbnQ4X3QJCQkJZGV2c3Rh
dGVbQVJDTVNSX01BWF9UQVJHRVRJRF1bQVJDTVNSX01BWF9UQVJHRVRMVU5dOworCXVpbnQ4X3Qg
ZGV2c3RhdGVbQVJDTVNSX01BWF9UQVJHRVRJRF1bQVJDTVNSX01BWF9UQVJHRVRMVU5dOwogCS8q
IGlkMCAuLi4uLiBpZDE1LCBsdW4wLi4ubHVuNyAqLwotI2RlZmluZSBBUkVDQV9SQUlEX0dPTkUg
ICAgICAgICAgICAgICAweDU1Ci0jZGVmaW5lIEFSRUNBX1JBSURfR09PRCAgICAgICAgICAgICAg
IDB4YWEKLQl1aW50MzJfdAkJCW51bV9yZXNldHM7Ci0JdWludDMyX3QJCQludW1fYWJvcnRzOwot
CXVpbnQzMl90CQkJc2lnbmF0dXJlOwotCXVpbnQzMl90CQkJZmlybV9yZXF1ZXN0X2xlbjsKLQl1
aW50MzJfdAkJCWZpcm1fbnVtYmVyc19xdWV1ZTsKLQl1aW50MzJfdAkJCWZpcm1fc2RyYW1fc2l6
ZTsKLQl1aW50MzJfdAkJCWZpcm1faGRfY2hhbm5lbHM7Ci0JdWludDMyX3QgICAgICAgICAgICAg
ICAgICAgICAgICAgICAJZmlybV9jZmdfdmVyc2lvbjsJCi0JY2hhcgkJCWZpcm1fbW9kZWxbMTJd
OwotCWNoYXIJCQlmaXJtX3ZlcnNpb25bMjBdOwotCWNoYXIJCQlkZXZpY2VfbWFwWzIwXTsJCQkv
KjIxLDg0LTk5Ki8KLQlzdHJ1Y3Qgd29ya19zdHJ1Y3QgCQlhcmNtc3JfZG9fbWVzc2FnZV9pc3Jf
Ymg7Ci0Jc3RydWN0IHRpbWVyX2xpc3QJCWV0ZXJuYWxfdGltZXI7Ci0JdW5zaWduZWQgc2hvcnQJ
CWZ3X2ZsYWc7Ci0JCQkJI2RlZmluZQlGV19OT1JNQUwJMHgwMDAwCi0JCQkJI2RlZmluZQlGV19C
T0cJCTB4MDAwMQotCQkJCSNkZWZpbmUJRldfREVBRExPQ0sJMHgwMDEwCi0JYXRvbWljX3QgCQkJ
cnFfbWFwX3Rva2VuOwotCWF0b21pY190CQkJYW50ZV90b2tlbl92YWx1ZTsKKyNkZWZpbmUgQVJF
Q0FfUkFJRF9HT05FCQkweDU1CisjZGVmaW5lIEFSRUNBX1JBSURfR09PRAkweGFhCisJdWludDMy
X3QgbnVtX3Jlc2V0czsKKwl1aW50MzJfdCBudW1fYWJvcnRzOworCXVpbnQzMl90IHNpZ25hdHVy
ZTsKKwl1aW50MzJfdCBmaXJtX3JlcXVlc3RfbGVuOworCXVpbnQzMl90IGZpcm1fbnVtYmVyc19x
dWV1ZTsKKwl1aW50MzJfdCBmaXJtX3NkcmFtX3NpemU7CisJdWludDMyX3QgZmlybV9oZF9jaGFu
bmVsczsKKwl1aW50MzJfdCBmaXJtX2NmZ192ZXJzaW9uOworCWNoYXIgZmlybV9tb2RlbFsxMl07
CisJY2hhciBmaXJtX3ZlcnNpb25bMjBdOworCWNoYXIgZGV2aWNlX21hcFsyMF07CS8qMjEsODQt
OTkqLworCXN0cnVjdCB3b3JrX3N0cnVjdCBhcmNtc3JfZG9fbWVzc2FnZV9pc3JfYmg7CisJc3Ry
dWN0IHRpbWVyX2xpc3QgZXRlcm5hbF90aW1lcjsKKwl1bnNpZ25lZCBzaG9ydCBmd19mbGFnOwor
CSNkZWZpbmUgRldfTk9STUFMCTB4MDAwMAorCSNkZWZpbmUgRldfQk9HCQkweDAwMDEKKwkjZGVm
aW5lIEZXX0RFQURMT0NLCTB4MDAxMAorCWF0b21pY190IHJxX21hcF90b2tlbjsKKwlhdG9taWNf
dCBhbnRlX3Rva2VuX3ZhbHVlOworCXVpbnQzMl90IG1heE91dHN0YW5kaW5nOwogfTsvKiBIV19E
RVZJQ0VfRVhURU5TSU9OICovCiAvKgogKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKgpAQCAtNjAxLDMz
ICs3MTMsMzMgQEAgc3RydWN0IEFkYXB0ZXJDb250cm9sQmxvY2sKICoqICAgICAgICAgICAgIHRo
aXMgQ0NCIGxlbmd0aCBtdXN0IGJlIDMyIGJ5dGVzIGJvdW5kYXJ5CiAqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqCiAqLwotc3RydWN0IENvbW1hbmRDb250cm9sQmxvY2t7Ci0JLyp4MzI6c2l6ZW9mIHN0
cnVjdF9DQ0I9KDMyKzYwKWJ5dGUsIHg2NDpzaXplb2Ygc3RydWN0X0NDQj0oNjQrNjApYnl0ZSov
Ci0Jc3RydWN0IGxpc3RfaGVhZAkJbGlzdDsJCQkJLyp4MzI6IDhieXRlLCB4NjQ6IDE2Ynl0ZSov
Ci0Jc3RydWN0IHNjc2lfY21uZAkJKnBjbWQ7CQkJCS8qOCBieXRlcyBwb2ludGVyIG9mIGxpbnV4
IHNjc2kgY29tbWFuZCAqLwotCXN0cnVjdCBBZGFwdGVyQ29udHJvbEJsb2NrCSphY2I7CQkJCS8q
eDMyOiA0Ynl0ZSwgeDY0OiA4Ynl0ZSovCi0JdWludDMyX3QJCQljZGJfcGh5YWRkcl9wYXR0ZXJu
OwkJLyp4MzI6IDRieXRlLCB4NjQ6IDRieXRlKi8KLQl1aW50MzJfdAkJCWFyY19jZGJfc2l6ZTsJ
CQkvKngzMjo0Ynl0ZSx4NjQ6NGJ5dGUqLwotCXVpbnQxNl90CQkJY2NiX2ZsYWdzOwkJCS8qeDMy
OiAyYnl0ZSwgeDY0OiAyYnl0ZSovCi0JI2RlZmluZQkJCUNDQl9GTEFHX1JFQUQJCQkweDAwMDAK
LQkjZGVmaW5lCQkJQ0NCX0ZMQUdfV1JJVEUJCTB4MDAwMQotCSNkZWZpbmUJCQlDQ0JfRkxBR19F
UlJPUgkJMHgwMDAyCi0JI2RlZmluZQkJCUNDQl9GTEFHX0ZMVVNIQ0FDSEUJCTB4MDAwNAotCSNk
ZWZpbmUJCQlDQ0JfRkxBR19NQVNURVJfQUJPUlRFRAkweDAwMDgJCi0JdWludDE2X3QgICAgICAg
ICAgICAgICAgICAgICAgICAJc3RhcnRkb25lOwkJCS8qeDMyOjJieXRlLHgzMjoyYnl0ZSovCi0J
I2RlZmluZQkJCUFSQ01TUl9DQ0JfRE9ORSAgIAkgICAgICAgIAkweDAwMDAKLQkjZGVmaW5lCQkJ
QVJDTVNSX0NDQl9TVEFSVAkJMHg1NUFBCi0JI2RlZmluZQkJCUFSQ01TUl9DQ0JfQUJPUlRFRAkJ
MHhBQTU1Ci0JI2RlZmluZQkJCUFSQ01TUl9DQ0JfSUxMRUdBTAkJMHhGRkZGCitzdHJ1Y3QgQ29t
bWFuZENvbnRyb2xCbG9jayB7CisvKngzMjpzaXplb2Ygc3RydWN0X0NDQj0oMzIrNjApYnl0ZSwg
eDY0OnNpemVvZiBzdHJ1Y3RfQ0NCPSg2NCs2MClieXRlKi8KKwlzdHJ1Y3QgbGlzdF9oZWFkIGxp
c3Q7CisJc3RydWN0IHNjc2lfY21uZCAqcGNtZDsKKwlzdHJ1Y3QgQWRhcHRlckNvbnRyb2xCbG9j
ayAqYWNiOworCXVpbnQzMl90IGNkYl9waHlhZGRyOworCXVpbnQzMl90IGFyY19jZGJfc2l6ZTsK
Kwl1aW50MTZfdCBjY2JfZmxhZ3M7CisJI2RlZmluZSBDQ0JfRkxBR19SRUFECQkweDAwMDAKKwkj
ZGVmaW5lIENDQl9GTEFHX1dSSVRFCQkweDAwMDEKKwkjZGVmaW5lIENDQl9GTEFHX0VSUk9SCQkw
eDAwMDIKKwkjZGVmaW5lIENDQl9GTEFHX0ZMVVNIQ0FDSEUJMHgwMDA0CisJI2RlZmluZSBDQ0Jf
RkxBR19NQVNURVJfQUJPUlRFRAkweDAwMDgKKwl1aW50MTZfdCBzdGFydGRvbmU7CisJI2RlZmlu
ZSBBUkNNU1JfQ0NCX0RPTkUJMHgwMDAwCisJI2RlZmluZSBBUkNNU1JfQ0NCX1NUQVJUCTB4NTVB
QQorCSNkZWZpbmUgQVJDTVNSX0NDQl9BQk9SVEVECTB4QUE1NQorCSNkZWZpbmUgQVJDTVNSX0ND
Ql9JTExFR0FMCTB4RkZGRgogCSNpZiBCSVRTX1BFUl9MT05HID09IDY0CiAJLyogID09PT09PT09
PT09PT09PT09PT09PT01MTIrNjQgYnl0ZXM9PT09PT09PT09PT09PT09PT09PT09PT0gICovCi0J
CXVpbnQzMl90ICAgICAgICAgICAgICAgICAgICAgICAgCXJlc2VydmVkWzVdOwkJLyoyNCBieXRl
Ki8KKwkJdWludDMyX3QgcmVzZXJ2ZWRbNV07CS8qMjQgYnl0ZSovCiAJI2Vsc2UKLQkvKiAgPT09
PT09PT09PT09PT09PT09PT09PTUxMiszMiBieXRlcz09PT09PT09PT09PT09PT09PT09PT09PSAg
Ki8KLQkJdWludDMyX3QgICAgICAgICAgICAgICAgICAgICAgICAJcmVzZXJ2ZWQ7CQkvKjggIGJ5
dGUqLworCS8qPT09PT09PT09PT09PT09PT09PT09PTUxMiszMiBieXRlcz09PT09PT09PT09PT09
PT09PT09PT09PSovCisJCXVpbnQzMl90IHJlc2VydmVkOwkvKjggIGJ5dGUqLwogCSNlbmRpZgot
CS8qICA9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09ICAgKi8KLQlzdHJ1Y3QgQVJDTVNSX0NEQgkJYXJjbXNyX2NkYjsKKwkvKj09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0qLworCXN0cnVjdCBB
UkNNU1JfQ0RCIGFyY21zcl9jZGI7CiB9OwogLyoKICoqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioKQEAg
LTYzNiw1NiArNzQ4LDU4IEBAIHN0cnVjdCBDb21tYW5kQ29udHJvbEJsb2NrewogKi8KIHN0cnVj
dCBTRU5TRV9EQVRBCiB7Ci0JdWludDhfdAkJCQlFcnJvckNvZGU6NzsKKwl1aW50OF90IEVycm9y
Q29kZTo3OwogI2RlZmluZSBTQ1NJX1NFTlNFX0NVUlJFTlRfRVJST1JTCTB4NzAKICNkZWZpbmUg
U0NTSV9TRU5TRV9ERUZFUlJFRF9FUlJPUlMJMHg3MQotCXVpbnQ4X3QJCQkJVmFsaWQ6MTsKLQl1
aW50OF90CQkJCVNlZ21lbnROdW1iZXI7Ci0JdWludDhfdAkJCQlTZW5zZUtleTo0OwotCXVpbnQ4
X3QJCQkJUmVzZXJ2ZWQ6MTsKLQl1aW50OF90CQkJCUluY29ycmVjdExlbmd0aDoxOwotCXVpbnQ4
X3QJCQkJRW5kT2ZNZWRpYToxOwotCXVpbnQ4X3QJCQkJRmlsZU1hcms6MTsKLQl1aW50OF90CQkJ
CUluZm9ybWF0aW9uWzRdOwotCXVpbnQ4X3QJCQkJQWRkaXRpb25hbFNlbnNlTGVuZ3RoOwotCXVp
bnQ4X3QJCQkJQ29tbWFuZFNwZWNpZmljSW5mb3JtYXRpb25bNF07Ci0JdWludDhfdAkJCQlBZGRp
dGlvbmFsU2Vuc2VDb2RlOwotCXVpbnQ4X3QJCQkJQWRkaXRpb25hbFNlbnNlQ29kZVF1YWxpZmll
cjsKLQl1aW50OF90CQkJCUZpZWxkUmVwbGFjZWFibGVVbml0Q29kZTsKLQl1aW50OF90CQkJCVNl
bnNlS2V5U3BlY2lmaWNbM107CisJdWludDhfdCBWYWxpZDoxOworCXVpbnQ4X3QgU2VnbWVudE51
bWJlcjsKKwl1aW50OF90IFNlbnNlS2V5OjQ7CisJdWludDhfdCBSZXNlcnZlZDoxOworCXVpbnQ4
X3QgSW5jb3JyZWN0TGVuZ3RoOjE7CisJdWludDhfdCBFbmRPZk1lZGlhOjE7CisJdWludDhfdCBG
aWxlTWFyazoxOworCXVpbnQ4X3QgSW5mb3JtYXRpb25bNF07CisJdWludDhfdCBBZGRpdGlvbmFs
U2Vuc2VMZW5ndGg7CisJdWludDhfdCBDb21tYW5kU3BlY2lmaWNJbmZvcm1hdGlvbls0XTsKKwl1
aW50OF90IEFkZGl0aW9uYWxTZW5zZUNvZGU7CisJdWludDhfdCBBZGRpdGlvbmFsU2Vuc2VDb2Rl
UXVhbGlmaWVyOworCXVpbnQ4X3QgRmllbGRSZXBsYWNlYWJsZVVuaXRDb2RlOworCXVpbnQ4X3Qg
U2Vuc2VLZXlTcGVjaWZpY1szXTsKIH07CiAvKgogKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKgogKiog
IE91dGJvdW5kIEludGVycnVwdCBTdGF0dXMgUmVnaXN0ZXIgLSBPSVNSCiAqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqCiAqLwotI2RlZmluZSAgICAgQVJDTVNSX01VX09VVEJPVU5EX0lOVEVSUlVQVF9T
VEFUVVNfUkVHICAgICAgICAgICAgICAgICAweDMwCi0jZGVmaW5lICAgICBBUkNNU1JfTVVfT1VU
Qk9VTkRfUENJX0lOVCAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIDB4MTAKLSNkZWZpbmUg
ICAgIEFSQ01TUl9NVV9PVVRCT1VORF9QT1NUUVVFVUVfSU5UICAgICAgICAgICAgICAgICAgICAg
ICAgMHgwOAotI2RlZmluZSAgICAgQVJDTVNSX01VX09VVEJPVU5EX0RPT1JCRUxMX0lOVCAgICAg
ICAgICAgICAgICAgICAgICAgICAweDA0Ci0jZGVmaW5lICAgICBBUkNNU1JfTVVfT1VUQk9VTkRf
TUVTU0FHRTFfSU5UICAgICAgICAgICAgICAgICAgICAgICAgIDB4MDIKLSNkZWZpbmUgICAgIEFS
Q01TUl9NVV9PVVRCT1VORF9NRVNTQUdFMF9JTlQgICAgICAgICAgICAgICAgICAgICAgICAgMHgw
MQotI2RlZmluZSAgICAgQVJDTVNSX01VX09VVEJPVU5EX0hBTkRMRV9JTlQgICAgICAgICAgICAg
ICAgIFwKLSAgICAgICAgICAgICAgICAgICAgKEFSQ01TUl9NVV9PVVRCT1VORF9NRVNTQUdFMF9J
TlQgICAgICBcCi0gICAgICAgICAgICAgICAgICAgICB8QVJDTVNSX01VX09VVEJPVU5EX01FU1NB
R0UxX0lOVCAgICAgXAotICAgICAgICAgICAgICAgICAgICAgfEFSQ01TUl9NVV9PVVRCT1VORF9E
T09SQkVMTF9JTlQgICAgIFwKLSAgICAgICAgICAgICAgICAgICAgIHxBUkNNU1JfTVVfT1VUQk9V
TkRfUE9TVFFVRVVFX0lOVCAgICBcCi0gICAgICAgICAgICAgICAgICAgICB8QVJDTVNSX01VX09V
VEJPVU5EX1BDSV9JTlQpCisjZGVmaW5lIEFSQ01TUl9NVV9PVVRCT1VORF9JTlRFUlJVUFRfU1RB
VFVTX1JFRwkweDMwCisjZGVmaW5lIEFSQ01TUl9NVV9PVVRCT1VORF9QQ0lfSU5UCQkJMHgxMAor
I2RlZmluZSBBUkNNU1JfTVVfT1VUQk9VTkRfUE9TVFFVRVVFX0lOVAkJMHgwOAorI2RlZmluZSBB
UkNNU1JfTVVfT1VUQk9VTkRfRE9PUkJFTExfSU5UCQkweDA0CisjZGVmaW5lIEFSQ01TUl9NVV9P
VVRCT1VORF9NRVNTQUdFMV9JTlQJCTB4MDIKKyNkZWZpbmUgQVJDTVNSX01VX09VVEJPVU5EX01F
U1NBR0UwX0lOVAkJMHgwMQorI2RlZmluZSBBUkNNU1JfTVVfT1VUQk9VTkRfSEFORExFX0lOVAlc
CisJKEFSQ01TUl9NVV9PVVRCT1VORF9NRVNTQUdFMF9JTlQJXAorCXxBUkNNU1JfTVVfT1VUQk9V
TkRfTUVTU0FHRTFfSU5UCVwKKwl8QVJDTVNSX01VX09VVEJPVU5EX0RPT1JCRUxMX0lOVAlcCisJ
fEFSQ01TUl9NVV9PVVRCT1VORF9QT1NUUVVFVUVfSU5UCVwKKwl8QVJDTVNSX01VX09VVEJPVU5E
X1BDSV9JTlQpCiAvKgogKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKgogKiogIE91dGJvdW5kIEludGVy
cnVwdCBNYXNrIFJlZ2lzdGVyIC0gT0lNUgogKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKgogKi8KLSNk
ZWZpbmUgICAgIEFSQ01TUl9NVV9PVVRCT1VORF9JTlRFUlJVUFRfTUFTS19SRUcgICAgICAgICAg
ICAgICAgICAgMHgzNAotI2RlZmluZSAgICAgQVJDTVNSX01VX09VVEJPVU5EX1BDSV9JTlRNQVNL
RU5BQkxFICAgICAgICAgICAgICAgICAgICAweDEwCi0jZGVmaW5lICAgICBBUkNNU1JfTVVfT1VU
Qk9VTkRfUE9TVFFVRVVFX0lOVE1BU0tFTkFCTEUgICAgICAgICAgICAgIDB4MDgKLSNkZWZpbmUg
ICAgIEFSQ01TUl9NVV9PVVRCT1VORF9ET09SQkVMTF9JTlRNQVNLRU5BQkxFICAgICAgICAgICAg
ICAgMHgwNAotI2RlZmluZSAgICAgQVJDTVNSX01VX09VVEJPVU5EX01FU1NBR0UxX0lOVE1BU0tF
TkFCTEUgICAgICAgICAgICAgICAweDAyCi0jZGVmaW5lICAgICBBUkNNU1JfTVVfT1VUQk9VTkRf
TUVTU0FHRTBfSU5UTUFTS0VOQUJMRSAgICAgICAgICAgICAgIDB4MDEKLSNkZWZpbmUgICAgIEFS
Q01TUl9NVV9PVVRCT1VORF9BTExfSU5UTUFTS0VOQUJMRSAgICAgICAgICAgICAgICAgICAgMHgx
RgorI2RlZmluZSBBUkNNU1JfTVVfT1VUQk9VTkRfSU5URVJSVVBUX01BU0tfUkVHCQkweDM0Cisj
ZGVmaW5lIEFSQ01TUl9NVV9PVVRCT1VORF9QQ0lfSU5UTUFTS0VOQUJMRQkJMHgxMAorI2RlZmlu
ZSBBUkNNU1JfTVVfT1VUQk9VTkRfUE9TVFFVRVVFX0lOVE1BU0tFTkFCTEUJMHgwOAorI2RlZmlu
ZSBBUkNNU1JfTVVfT1VUQk9VTkRfRE9PUkJFTExfSU5UTUFTS0VOQUJMRQkweDA0CisjZGVmaW5l
IEFSQ01TUl9NVV9PVVRCT1VORF9NRVNTQUdFMV9JTlRNQVNLRU5BQkxFCTB4MDIKKyNkZWZpbmUg
QVJDTVNSX01VX09VVEJPVU5EX01FU1NBR0UwX0lOVE1BU0tFTkFCTEUJMHgwMQorI2RlZmluZSBB
UkNNU1JfTVVfT1VUQk9VTkRfQUxMX0lOVE1BU0tFTkFCTEUJCTB4MUYKIAotZXh0ZXJuIHZvaWQg
YXJjbXNyX3Bvc3RfaW9jdGxkYXRhMmlvcChzdHJ1Y3QgQWRhcHRlckNvbnRyb2xCbG9jayAqKTsK
LWV4dGVybiB2b2lkIGFyY21zcl9pb3BfbWVzc2FnZV9yZWFkKHN0cnVjdCBBZGFwdGVyQ29udHJv
bEJsb2NrICopOworZXh0ZXJuIHZvaWQgYXJjbXNyX3dyaXRlX2lvY3RsZGF0YTJpb3Aoc3RydWN0
IEFkYXB0ZXJDb250cm9sQmxvY2sgKik7CitleHRlcm4gdWludDMyX3QgYXJjbXNyX1JlYWRfaW9w
X3JxYnVmZmVyX2RhdGEoc3RydWN0IEFkYXB0ZXJDb250cm9sQmxvY2sgKiwKKwlzdHJ1Y3QgUUJV
RkZFUiBfX2lvbWVtICopOworZXh0ZXJuIHZvaWQgYXJjbXNyX2NsZWFyX2lvcDJkcnZfcnF1ZXVl
X2J1ZmZlcihzdHJ1Y3QgQWRhcHRlckNvbnRyb2xCbG9jayAqKTsKIGV4dGVybiBzdHJ1Y3QgUUJV
RkZFUiBfX2lvbWVtICphcmNtc3JfZ2V0X2lvcF9ycWJ1ZmZlcihzdHJ1Y3QgQWRhcHRlckNvbnRy
b2xCbG9jayAqKTsKIGV4dGVybiBzdHJ1Y3QgZGV2aWNlX2F0dHJpYnV0ZSAqYXJjbXNyX2hvc3Rf
YXR0cnNbXTsKIGV4dGVybiBpbnQgYXJjbXNyX2FsbG9jX3N5c2ZzX2F0dHIoc3RydWN0IEFkYXB0
ZXJDb250cm9sQmxvY2sgKik7CmRpZmYgLXVwck4gYS9kcml2ZXJzL3Njc2kvYXJjbXNyL2FyY21z
cl9oYmEuYyBiL2RyaXZlcnMvc2NzaS9hcmNtc3IvYXJjbXNyX2hiYS5jCi0tLSBhL2RyaXZlcnMv
c2NzaS9hcmNtc3IvYXJjbXNyX2hiYS5jCTIwMTMtMDctMDEgMDY6MTM6MjguMDAwMDAwMDAwICsw
ODAwCisrKyBiL2RyaXZlcnMvc2NzaS9hcmNtc3IvYXJjbXNyX2hiYS5jCTIwMTMtMDgtMjkgMjA6
MzE6NDYuMDAwMDAwMDAwICswODAwCkBAIC0yLDcgKzIsNyBAQAogKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKgogKiogICAgICAgIE8uUyAgIDogTGludXgKICoqICAgRklMRSBOQU1FICA6IGFyY21zcl9o
YmEuYwotKiogICAgICAgIEJZICAgIDogTmljayBDaGVuZworKiogICAgICAgIEJZICAgIDogTmlj
ayBDaGVuZywgQy5MLiBIdWFuZwogKiogICBEZXNjcmlwdGlvbjogU0NTSSBSQUlEIERldmljZSBE
cml2ZXIgZm9yCiAqKiAgICAgICAgICAgICAgICBBUkVDQSBSQUlEIEhvc3QgYWRhcHRlcgogKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKgpAQCAtNzAsMTUgKzcwLDE1IEBACiAjaW5jbHVkZSA8c2NzaS9z
Y3NpX3RyYW5zcG9ydC5oPgogI2luY2x1ZGUgPHNjc2kvc2NzaWNhbS5oPgogI2luY2x1ZGUgImFy
Y21zci5oIgotTU9EVUxFX0FVVEhPUigiTmljayBDaGVuZyA8c3VwcG9ydEBhcmVjYS5jb20udHc+
Iik7Ci1NT0RVTEVfREVTQ1JJUFRJT04oIkFSRUNBIChBUkMxMXh4LzEyeHgvMTZ4eC8xODgwKSBT
QVRBL1NBUyBSQUlEIEhvc3QgQnVzIEFkYXB0ZXIiKTsKK01PRFVMRV9BVVRIT1IoIk5pY2sgQ2hl
bmcsIENoaW5nIEh1YW5nIDxzdXBwb3J0QGFyZWNhLmNvbS50dz4iKTsKK01PRFVMRV9ERVNDUklQ
VElPTigiQXJlY2EgU0FTLFNBVEEgUkFJRCBDb250cm9sbGVyIERyaXZlciIpOwogTU9EVUxFX0xJ
Q0VOU0UoIkR1YWwgQlNEL0dQTCIpOwogTU9EVUxFX1ZFUlNJT04oQVJDTVNSX0RSSVZFUl9WRVJT
SU9OKTsKIAotI2RlZmluZQlBUkNNU1JfU0xFRVBUSU1FCTEwCi0jZGVmaW5lCUFSQ01TUl9SRVRS
WUNPVU5UCTEyCisjZGVmaW5lIEFSQ01TUl9TTEVFUFRJTUUJMTAKKyNkZWZpbmUgQVJDTVNSX1JF
VFJZQ09VTlQJMTIKIAotd2FpdF9xdWV1ZV9oZWFkX3Qgd2FpdF9xOworc3RhdGljIHdhaXRfcXVl
dWVfaGVhZF90IHdhaXRfcTsKIHN0YXRpYyBpbnQgYXJjbXNyX2lvcF9tZXNzYWdlX3hmZXIoc3Ry
dWN0IEFkYXB0ZXJDb250cm9sQmxvY2sgKmFjYiwKIAkJCQkJc3RydWN0IHNjc2lfY21uZCAqY21k
KTsKIHN0YXRpYyBpbnQgYXJjbXNyX2lvcF9jb25maXJtKHN0cnVjdCBBZGFwdGVyQ29udHJvbEJs
b2NrICphY2IpOwpAQCAtODksMjIgKzg5LDI3IEBAIHN0YXRpYyBpbnQgYXJjbXNyX2Jpb3NfcGFy
YW0oc3RydWN0IHNjc2kKIHN0YXRpYyBpbnQgYXJjbXNyX3F1ZXVlX2NvbW1hbmQoc3RydWN0IFNj
c2lfSG9zdCAqaCwgc3RydWN0IHNjc2lfY21uZCAqY21kKTsKIHN0YXRpYyBpbnQgYXJjbXNyX3By
b2JlKHN0cnVjdCBwY2lfZGV2ICpwZGV2LAogCQkJCWNvbnN0IHN0cnVjdCBwY2lfZGV2aWNlX2lk
ICppZCk7CitzdGF0aWMgaW50IGFyY21zcl9zdXNwZW5kKHN0cnVjdCBwY2lfZGV2ICpwZGV2LCBw
bV9tZXNzYWdlX3Qgc3RhdGUpOworc3RhdGljIGludCBhcmNtc3JfcmVzdW1lKHN0cnVjdCBwY2lf
ZGV2ICpwZGV2KTsKIHN0YXRpYyB2b2lkIGFyY21zcl9yZW1vdmUoc3RydWN0IHBjaV9kZXYgKnBk
ZXYpOwogc3RhdGljIHZvaWQgYXJjbXNyX3NodXRkb3duKHN0cnVjdCBwY2lfZGV2ICpwZGV2KTsK
IHN0YXRpYyB2b2lkIGFyY21zcl9pb3BfaW5pdChzdHJ1Y3QgQWRhcHRlckNvbnRyb2xCbG9jayAq
YWNiKTsKIHN0YXRpYyB2b2lkIGFyY21zcl9mcmVlX2NjYl9wb29sKHN0cnVjdCBBZGFwdGVyQ29u
dHJvbEJsb2NrICphY2IpOwogc3RhdGljIHUzMiBhcmNtc3JfZGlzYWJsZV9vdXRib3VuZF9pbnRz
KHN0cnVjdCBBZGFwdGVyQ29udHJvbEJsb2NrICphY2IpOworc3RhdGljIHZvaWQgYXJjbXNyX2Vu
YWJsZV9vdXRib3VuZF9pbnRzKHN0cnVjdCBBZGFwdGVyQ29udHJvbEJsb2NrICphY2IsCisJdTMy
IG9yaWdfbWFzayk7CiBzdGF0aWMgdm9pZCBhcmNtc3Jfc3RvcF9hZGFwdGVyX2JncmIoc3RydWN0
IEFkYXB0ZXJDb250cm9sQmxvY2sgKmFjYik7Ci1zdGF0aWMgdm9pZCBhcmNtc3JfZmx1c2hfaGJh
X2NhY2hlKHN0cnVjdCBBZGFwdGVyQ29udHJvbEJsb2NrICphY2IpOwotc3RhdGljIHZvaWQgYXJj
bXNyX2ZsdXNoX2hiYl9jYWNoZShzdHJ1Y3QgQWRhcHRlckNvbnRyb2xCbG9jayAqYWNiKTsKK3N0
YXRpYyB2b2lkIGFyY21zcl9oYmFBX2ZsdXNoX2NhY2hlKHN0cnVjdCBBZGFwdGVyQ29udHJvbEJs
b2NrICphY2IpOworc3RhdGljIHZvaWQgYXJjbXNyX2hiYUJfZmx1c2hfY2FjaGUoc3RydWN0IEFk
YXB0ZXJDb250cm9sQmxvY2sgKmFjYik7CiBzdGF0aWMgdm9pZCBhcmNtc3JfcmVxdWVzdF9kZXZp
Y2VfbWFwKHVuc2lnbmVkIGxvbmcgcGFjYik7Ci1zdGF0aWMgdm9pZCBhcmNtc3JfcmVxdWVzdF9o
YmFfZGV2aWNlX21hcChzdHJ1Y3QgQWRhcHRlckNvbnRyb2xCbG9jayAqYWNiKTsKLXN0YXRpYyB2
b2lkIGFyY21zcl9yZXF1ZXN0X2hiYl9kZXZpY2VfbWFwKHN0cnVjdCBBZGFwdGVyQ29udHJvbEJs
b2NrICphY2IpOwotc3RhdGljIHZvaWQgYXJjbXNyX3JlcXVlc3RfaGJjX2RldmljZV9tYXAoc3Ry
dWN0IEFkYXB0ZXJDb250cm9sQmxvY2sgKmFjYik7CitzdGF0aWMgdm9pZCBhcmNtc3JfaGJhQV9y
ZXF1ZXN0X2RldmljZV9tYXAoc3RydWN0IEFkYXB0ZXJDb250cm9sQmxvY2sgKmFjYik7CitzdGF0
aWMgdm9pZCBhcmNtc3JfaGJhQl9yZXF1ZXN0X2RldmljZV9tYXAoc3RydWN0IEFkYXB0ZXJDb250
cm9sQmxvY2sgKmFjYik7CitzdGF0aWMgdm9pZCBhcmNtc3JfaGJhQ19yZXF1ZXN0X2RldmljZV9t
YXAoc3RydWN0IEFkYXB0ZXJDb250cm9sQmxvY2sgKmFjYik7CiBzdGF0aWMgdm9pZCBhcmNtc3Jf
bWVzc2FnZV9pc3JfYmhfZm4oc3RydWN0IHdvcmtfc3RydWN0ICp3b3JrKTsKIHN0YXRpYyBib29s
IGFyY21zcl9nZXRfZmlybXdhcmVfc3BlYyhzdHJ1Y3QgQWRhcHRlckNvbnRyb2xCbG9jayAqYWNi
KTsKIHN0YXRpYyB2b2lkIGFyY21zcl9zdGFydF9hZGFwdGVyX2JncmIoc3RydWN0IEFkYXB0ZXJD
b250cm9sQmxvY2sgKmFjYik7Ci1zdGF0aWMgdm9pZCBhcmNtc3JfaGJjX21lc3NhZ2VfaXNyKHN0
cnVjdCBBZGFwdGVyQ29udHJvbEJsb2NrICpwQUNCKTsKK3N0YXRpYyB2b2lkIGFyY21zcl9oYmFD
X21lc3NhZ2VfaXNyKHN0cnVjdCBBZGFwdGVyQ29udHJvbEJsb2NrICpwQUNCKTsKK3N0YXRpYyB2
b2lkIGFyY21zcl9oYmFEX21lc3NhZ2VfaXNyKHN0cnVjdCBBZGFwdGVyQ29udHJvbEJsb2NrICph
Y2IpOwogc3RhdGljIHZvaWQgYXJjbXNyX2hhcmR3YXJlX3Jlc2V0KHN0cnVjdCBBZGFwdGVyQ29u
dHJvbEJsb2NrICphY2IpOwogc3RhdGljIGNvbnN0IGNoYXIgKmFyY21zcl9pbmZvKHN0cnVjdCBT
Y3NpX0hvc3QgKik7CiBzdGF0aWMgaXJxcmV0dXJuX3QgYXJjbXNyX2ludGVycnVwdChzdHJ1Y3Qg
QWRhcHRlckNvbnRyb2xCbG9jayAqYWNiKTsKQEAgLTEzMiw4ICsxMzcsNiBAQCBzdGF0aWMgc3Ry
dWN0IHNjc2lfaG9zdF90ZW1wbGF0ZSBhcmNtc3JfCiAJLmNoYW5nZV9xdWV1ZV9kZXB0aAk9IGFy
Y21zcl9hZGp1c3RfZGlza19xdWV1ZV9kZXB0aCwKIAkuY2FuX3F1ZXVlCQk9IEFSQ01TUl9NQVhf
RlJFRUNDQl9OVU0sCiAJLnRoaXNfaWQJCQk9IEFSQ01TUl9TQ1NJX0lOSVRJQVRPUl9JRCwKLQku
c2dfdGFibGVzaXplCSAgICAgICAgCT0gQVJDTVNSX0RFRkFVTFRfU0dfRU5UUklFUywgCi0JLm1h
eF9zZWN0b3JzICAgIAkgICAgCT0gQVJDTVNSX01BWF9YRkVSX1NFQ1RPUlNfQywgCiAJLmNtZF9w
ZXJfbHVuCQk9IEFSQ01TUl9NQVhfQ01EX1BFUkxVTiwKIAkudXNlX2NsdXN0ZXJpbmcJCT0gRU5B
QkxFX0NMVVNURVJJTkcsCiAJLnNob3N0X2F0dHJzCQk9IGFyY21zcl9ob3N0X2F0dHJzLApAQCAt
MTQ4LDEzICsxNTEsMTIgQEAgc3RhdGljIHN0cnVjdCBwY2lfZGV2aWNlX2lkIGFyY21zcl9kZXZp
YwogCXtQQ0lfREVWSUNFKFBDSV9WRU5ET1JfSURfQVJFQ0EsIFBDSV9ERVZJQ0VfSURfQVJFQ0Ff
MTIwMSl9LAogCXtQQ0lfREVWSUNFKFBDSV9WRU5ET1JfSURfQVJFQ0EsIFBDSV9ERVZJQ0VfSURf
QVJFQ0FfMTIwMil9LAogCXtQQ0lfREVWSUNFKFBDSV9WRU5ET1JfSURfQVJFQ0EsIFBDSV9ERVZJ
Q0VfSURfQVJFQ0FfMTIxMCl9LAorCXtQQ0lfREVWSUNFKFBDSV9WRU5ET1JfSURfQVJFQ0EsIFBD
SV9ERVZJQ0VfSURfQVJFQ0FfMTIxNCl9LAogCXtQQ0lfREVWSUNFKFBDSV9WRU5ET1JfSURfQVJF
Q0EsIFBDSV9ERVZJQ0VfSURfQVJFQ0FfMTIyMCl9LAogCXtQQ0lfREVWSUNFKFBDSV9WRU5ET1Jf
SURfQVJFQ0EsIFBDSV9ERVZJQ0VfSURfQVJFQ0FfMTIzMCl9LAogCXtQQ0lfREVWSUNFKFBDSV9W
RU5ET1JfSURfQVJFQ0EsIFBDSV9ERVZJQ0VfSURfQVJFQ0FfMTI2MCl9LAogCXtQQ0lfREVWSUNF
KFBDSV9WRU5ET1JfSURfQVJFQ0EsIFBDSV9ERVZJQ0VfSURfQVJFQ0FfMTI3MCl9LAogCXtQQ0lf
REVWSUNFKFBDSV9WRU5ET1JfSURfQVJFQ0EsIFBDSV9ERVZJQ0VfSURfQVJFQ0FfMTI4MCl9LAot
CXtQQ0lfREVWSUNFKFBDSV9WRU5ET1JfSURfQVJFQ0EsIFBDSV9ERVZJQ0VfSURfQVJFQ0FfMTM4
MCl9LAotCXtQQ0lfREVWSUNFKFBDSV9WRU5ET1JfSURfQVJFQ0EsIFBDSV9ERVZJQ0VfSURfQVJF
Q0FfMTM4MSl9LAogCXtQQ0lfREVWSUNFKFBDSV9WRU5ET1JfSURfQVJFQ0EsIFBDSV9ERVZJQ0Vf
SURfQVJFQ0FfMTY4MCl9LAogCXtQQ0lfREVWSUNFKFBDSV9WRU5ET1JfSURfQVJFQ0EsIFBDSV9E
RVZJQ0VfSURfQVJFQ0FfMTY4MSl9LAogCXtQQ0lfREVWSUNFKFBDSV9WRU5ET1JfSURfQVJFQ0Es
IFBDSV9ERVZJQ0VfSURfQVJFQ0FfMTg4MCl9LApAQCAtMTYzLDI2ICsxNjUsMzYgQEAgc3RhdGlj
IHN0cnVjdCBwY2lfZGV2aWNlX2lkIGFyY21zcl9kZXZpYwogTU9EVUxFX0RFVklDRV9UQUJMRShw
Y2ksIGFyY21zcl9kZXZpY2VfaWRfdGFibGUpOwogc3RhdGljIHN0cnVjdCBwY2lfZHJpdmVyIGFy
Y21zcl9wY2lfZHJpdmVyID0gewogCS5uYW1lCQkJPSAiYXJjbXNyIiwKLQkuaWRfdGFibGUJCQk9
IGFyY21zcl9kZXZpY2VfaWRfdGFibGUsCisJLmlkX3RhYmxlCQk9IGFyY21zcl9kZXZpY2VfaWRf
dGFibGUsCiAJLnByb2JlCQkJPSBhcmNtc3JfcHJvYmUsCiAJLnJlbW92ZQkJCT0gYXJjbXNyX3Jl
bW92ZSwKKwkuc3VzcGVuZAkJPSBhcmNtc3Jfc3VzcGVuZCwKKwkucmVzdW1lCQkJPSBhcmNtc3Jf
cmVzdW1lLAogCS5zaHV0ZG93bgkJPSBhcmNtc3Jfc2h1dGRvd24sCiB9OwogLyoKICoqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioKICoqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioKICovCi0KLXN0YXRpYyB2b2lkIGFyY21z
cl9mcmVlX2hiYl9tdShzdHJ1Y3QgQWRhcHRlckNvbnRyb2xCbG9jayAqYWNiKQorc3RhdGljIHZv
aWQgYXJjbXNyX2ZyZWVfbXUoc3RydWN0IEFkYXB0ZXJDb250cm9sQmxvY2sgKmFjYikKIHsKIAlz
d2l0Y2ggKGFjYi0+YWRhcHRlcl90eXBlKSB7CiAJY2FzZSBBQ0JfQURBUFRFUl9UWVBFX0E6CiAJ
Y2FzZSBBQ0JfQURBUFRFUl9UWVBFX0M6CiAJCWJyZWFrOwotCWNhc2UgQUNCX0FEQVBURVJfVFlQ
RV9COnsKKwljYXNlIEFDQl9BREFQVEVSX1RZUEVfQjogeworCQlzdHJ1Y3QgTWVzc2FnZVVuaXRf
QiBfX2lvbWVtICpyZWcgPSBhY2ItPnBtdUI7CiAJCWRtYV9mcmVlX2NvaGVyZW50KCZhY2ItPnBk
ZXYtPmRldiwKIAkJCXNpemVvZihzdHJ1Y3QgTWVzc2FnZVVuaXRfQiksCi0JCQlhY2ItPnBtdUIs
IGFjYi0+ZG1hX2NvaGVyZW50X2hhbmRsZV9oYmJfbXUpOworCQkJcmVnLCBhY2ItPmRtYV9jb2hl
cmVudF9oYW5kbGUyKTsKKwkJYnJlYWs7CisJfQorCWNhc2UgQUNCX0FEQVBURVJfVFlQRV9EOiB7
CisJCWRtYV9mcmVlX2NvaGVyZW50KCZhY2ItPnBkZXYtPmRldiwKKwkJCWFjYi0+cm91bmR1cF9j
Y2JzaXplLAorCQkJYWNiLT5kbWFfY29oZXJlbnQyLAorCQkJYWNiLT5kbWFfY29oZXJlbnRfaGFu
ZGxlMik7CisJCWJyZWFrOwogCX0KIAl9CiB9CkBAIC0xOTAsNDQgKzIwMiw3MyBAQCBzdGF0aWMg
dm9pZCBhcmNtc3JfZnJlZV9oYmJfbXUoc3RydWN0IEFkCiBzdGF0aWMgYm9vbCBhcmNtc3JfcmVt
YXBfcGNpcmVnaW9uKHN0cnVjdCBBZGFwdGVyQ29udHJvbEJsb2NrICphY2IpCiB7CiAJc3RydWN0
IHBjaV9kZXYgKnBkZXYgPSBhY2ItPnBkZXY7Ci0Jc3dpdGNoIChhY2ItPmFkYXB0ZXJfdHlwZSl7
Ci0JY2FzZSBBQ0JfQURBUFRFUl9UWVBFX0E6ewotCQlhY2ItPnBtdUEgPSBpb3JlbWFwKHBjaV9y
ZXNvdXJjZV9zdGFydChwZGV2LDApLCBwY2lfcmVzb3VyY2VfbGVuKHBkZXYsMCkpOworCXN3aXRj
aCAoYWNiLT5hZGFwdGVyX3R5cGUpIHsKKwljYXNlIEFDQl9BREFQVEVSX1RZUEVfQTogeworCQlh
Y2ItPnBtdUEgPSBpb3JlbWFwKHBjaV9yZXNvdXJjZV9zdGFydChwZGV2LCAwKSwKKwkJCXBjaV9y
ZXNvdXJjZV9sZW4ocGRldiwgMCkpOwogCQlpZiAoIWFjYi0+cG11QSkgewotCQkJcHJpbnRrKEtF
Uk5fTk9USUNFICJhcmNtc3IlZDogbWVtb3J5IG1hcHBpbmcgcmVnaW9uIGZhaWwgXG4iLCBhY2It
Pmhvc3QtPmhvc3Rfbm8pOworCQkJcHJfbm90aWNlKCJhcmNtc3IlZDogbWVtb3J5IG1hcHBpbmcg
IgorCQkJCSJyZWdpb24gZmFpbFxuIiwgYWNiLT5ob3N0LT5ob3N0X25vKTsKIAkJCXJldHVybiBm
YWxzZTsKIAkJfQogCQlicmVhazsKIAl9Ci0JY2FzZSBBQ0JfQURBUFRFUl9UWVBFX0I6eworCWNh
c2UgQUNCX0FEQVBURVJfVFlQRV9COiB7CiAJCXZvaWQgX19pb21lbSAqbWVtX2Jhc2UwLCAqbWVt
X2Jhc2UxOwotCQltZW1fYmFzZTAgPSBpb3JlbWFwKHBjaV9yZXNvdXJjZV9zdGFydChwZGV2LCAw
KSwgcGNpX3Jlc291cmNlX2xlbihwZGV2LCAwKSk7CisJCW1lbV9iYXNlMCA9IGlvcmVtYXAocGNp
X3Jlc291cmNlX3N0YXJ0KHBkZXYsIDApLAorCQkJcGNpX3Jlc291cmNlX2xlbihwZGV2LCAwKSk7
CiAJCWlmICghbWVtX2Jhc2UwKSB7Ci0JCQlwcmludGsoS0VSTl9OT1RJQ0UgImFyY21zciVkOiBt
ZW1vcnkgbWFwcGluZyByZWdpb24gZmFpbCBcbiIsIGFjYi0+aG9zdC0+aG9zdF9ubyk7CisJCQlw
cl9ub3RpY2UoImFyY21zciVkOiBtZW1vcnkgbWFwcGluZyAiCisJCQkJInJlZ2lvbiBmYWlsXG4i
LCBhY2ItPmhvc3QtPmhvc3Rfbm8pOwogCQkJcmV0dXJuIGZhbHNlOwogCQl9Ci0JCW1lbV9iYXNl
MSA9IGlvcmVtYXAocGNpX3Jlc291cmNlX3N0YXJ0KHBkZXYsIDIpLCBwY2lfcmVzb3VyY2VfbGVu
KHBkZXYsIDIpKTsKKwkJbWVtX2Jhc2UxID0gaW9yZW1hcChwY2lfcmVzb3VyY2Vfc3RhcnQocGRl
diwgMiksCisJCQlwY2lfcmVzb3VyY2VfbGVuKHBkZXYsIDIpKTsKIAkJaWYgKCFtZW1fYmFzZTEp
IHsKIAkJCWlvdW5tYXAobWVtX2Jhc2UwKTsKLQkJCXByaW50ayhLRVJOX05PVElDRSAiYXJjbXNy
JWQ6IG1lbW9yeSBtYXBwaW5nIHJlZ2lvbiBmYWlsIFxuIiwgYWNiLT5ob3N0LT5ob3N0X25vKTsK
KwkJCXByX25vdGljZSgiYXJjbXNyJWQ6IG1lbW9yeSBtYXBwaW5nICIKKwkJCQkicmVnaW9uIGZh
aWxcbiIsIGFjYi0+aG9zdC0+aG9zdF9ubyk7CiAJCQlyZXR1cm4gZmFsc2U7CiAJCX0KIAkJYWNi
LT5tZW1fYmFzZTAgPSBtZW1fYmFzZTA7CiAJCWFjYi0+bWVtX2Jhc2UxID0gbWVtX2Jhc2UxOwog
CQlicmVhazsKIAl9Ci0JY2FzZSBBQ0JfQURBUFRFUl9UWVBFX0M6ewotCQlhY2ItPnBtdUMgPSBp
b3JlbWFwX25vY2FjaGUocGNpX3Jlc291cmNlX3N0YXJ0KHBkZXYsIDEpLCBwY2lfcmVzb3VyY2Vf
bGVuKHBkZXYsIDEpKTsKKwljYXNlIEFDQl9BREFQVEVSX1RZUEVfQzogeworCQlhY2ItPnBtdUMg
PSBpb3JlbWFwX25vY2FjaGUocGNpX3Jlc291cmNlX3N0YXJ0KHBkZXYsIDEpLAorCQkJcGNpX3Jl
c291cmNlX2xlbihwZGV2LCAxKSk7CiAJCWlmICghYWNiLT5wbXVDKSB7Ci0JCQlwcmludGsoS0VS
Tl9OT1RJQ0UgImFyY21zciVkOiBtZW1vcnkgbWFwcGluZyByZWdpb24gZmFpbCBcbiIsIGFjYi0+
aG9zdC0+aG9zdF9ubyk7CisJCQlwcl9ub3RpY2UoImFyY21zciVkOiBtZW1vcnkgbWFwcGluZyAi
CisJCQkJInJlZ2lvbiBmYWlsXG4iLCBhY2ItPmhvc3QtPmhvc3Rfbm8pOwogCQkJcmV0dXJuIGZh
bHNlOwogCQl9Ci0JCWlmIChyZWFkbCgmYWNiLT5wbXVDLT5vdXRib3VuZF9kb29yYmVsbCkgJiBB
UkNNU1JfSEJDTVVfSU9QMkRSVl9NRVNTQUdFX0NNRF9ET05FKSB7Ci0JCQl3cml0ZWwoQVJDTVNS
X0hCQ01VX0lPUDJEUlZfTUVTU0FHRV9DTURfRE9ORV9ET09SQkVMTF9DTEVBUiwgJmFjYi0+cG11
Qy0+b3V0Ym91bmRfZG9vcmJlbGxfY2xlYXIpOy8qY2xlYXIgaW50ZXJydXB0Ki8KKwkJaWYgKHJl
YWRsKCZhY2ItPnBtdUMtPm91dGJvdW5kX2Rvb3JiZWxsKSAmCisJCQlBUkNNU1JfSEJDTVVfSU9Q
MkRSVl9NRVNTQUdFX0NNRF9ET05FKSB7CisJCQl3cml0ZWwoQVJDTVNSX0hCQ01VX0lPUDJEUlZf
TUVTU0FHRV9DTURfRE9ORV9ET09SQkVMTF9DTEVBUiwKKwkJCQkmYWNiLT5wbXVDLT5vdXRib3Vu
ZF9kb29yYmVsbF9jbGVhcik7CiAJCQlyZXR1cm4gdHJ1ZTsKIAkJfQogCQlicmVhazsKIAl9CisJ
Y2FzZSBBQ0JfQURBUFRFUl9UWVBFX0Q6IHsKKwkJdm9pZCBfX2lvbWVtICptZW1fYmFzZTA7CisJ
CXVuc2lnbmVkIGxvbmcgYWRkciwgcmFuZ2UsIGZsYWdzOworCisJCWFkZHIgPSAodW5zaWduZWQg
bG9uZylwY2lfcmVzb3VyY2Vfc3RhcnQocGRldiwgMCk7CisJCXJhbmdlID0gcGNpX3Jlc291cmNl
X2xlbihwZGV2LCAwKTsKKwkJZmxhZ3MgPSBwY2lfcmVzb3VyY2VfZmxhZ3MocGRldiwgMCk7CisJ
CWlmIChmbGFncyAmIElPUkVTT1VSQ0VfQ0FDSEVBQkxFKQorCQkJbWVtX2Jhc2UwID0gaW9yZW1h
cChhZGRyLCByYW5nZSk7CisJCWVsc2UKKwkJCW1lbV9iYXNlMCA9IGlvcmVtYXBfbm9jYWNoZShh
ZGRyLCByYW5nZSk7CisJCWlmICghbWVtX2Jhc2UwKSB7CisJCQlwcl9ub3RpY2UoImFyY21zciVk
OiBtZW1vcnkgbWFwcGluZyByZWdpb24gZmFpbFxuIiwKKwkJCQlhY2ItPmhvc3QtPmhvc3Rfbm8p
OworCQkJcmV0dXJuIGZhbHNlOworCQl9CisJCWFjYi0+bWVtX2Jhc2UwID0gbWVtX2Jhc2UwOwor
CQlicmVhazsKKwl9CiAJfQogCXJldHVybiB0cnVlOwogfQpAQCAtMjM1LDE4ICsyNzYsMjIgQEAg
c3RhdGljIGJvb2wgYXJjbXNyX3JlbWFwX3BjaXJlZ2lvbihzdHJ1Ywogc3RhdGljIHZvaWQgYXJj
bXNyX3VubWFwX3BjaXJlZ2lvbihzdHJ1Y3QgQWRhcHRlckNvbnRyb2xCbG9jayAqYWNiKQogewog
CXN3aXRjaCAoYWNiLT5hZGFwdGVyX3R5cGUpIHsKLQljYXNlIEFDQl9BREFQVEVSX1RZUEVfQTp7
CisJY2FzZSBBQ0JfQURBUFRFUl9UWVBFX0E6IHsKIAkJaW91bm1hcChhY2ItPnBtdUEpOworCQli
cmVhazsKIAl9Ci0JYnJlYWs7Ci0JY2FzZSBBQ0JfQURBUFRFUl9UWVBFX0I6eworCWNhc2UgQUNC
X0FEQVBURVJfVFlQRV9COiB7CiAJCWlvdW5tYXAoYWNiLT5tZW1fYmFzZTApOwogCQlpb3VubWFw
KGFjYi0+bWVtX2Jhc2UxKTsKKwkJYnJlYWs7CiAJfQotCi0JYnJlYWs7Ci0JY2FzZSBBQ0JfQURB
UFRFUl9UWVBFX0M6eworCWNhc2UgQUNCX0FEQVBURVJfVFlQRV9DOiB7CiAJCWlvdW5tYXAoYWNi
LT5wbXVDKTsKKwkJYnJlYWs7CisJfQorCWNhc2UgQUNCX0FEQVBURVJfVFlQRV9EOiB7CisJCWlv
dW5tYXAoYWNiLT5tZW1fYmFzZTApOworCQlicmVhazsKIAl9CiAJfQogfQpAQCAtMjY0LDEyICsz
MDksMTMgQEAgc3RhdGljIGludCBhcmNtc3JfYmlvc19wYXJhbShzdHJ1Y3Qgc2NzaQogCQlzdHJ1
Y3QgYmxvY2tfZGV2aWNlICpiZGV2LCBzZWN0b3JfdCBjYXBhY2l0eSwgaW50ICpnZW9tKQogewog
CWludCByZXQsIGhlYWRzLCBzZWN0b3JzLCBjeWxpbmRlcnMsIHRvdGFsX2NhcGFjaXR5OwotCXVu
c2lnbmVkIGNoYXIgKmJ1ZmZlcjsvKiByZXR1cm4gY29weSBvZiBibG9jayBkZXZpY2UncyBwYXJ0
aXRpb24gdGFibGUgKi8KKwl1bnNpZ25lZCBjaGFyICpidWZmZXI7CiAKIAlidWZmZXIgPSBzY3Np
X2Jpb3NfcHRhYmxlKGJkZXYpOwogCWlmIChidWZmZXIpIHsKLQkJcmV0ID0gc2NzaV9wYXJ0c2l6
ZShidWZmZXIsIGNhcGFjaXR5LCAmZ2VvbVsyXSwgJmdlb21bMF0sICZnZW9tWzFdKTsKLQkJa2Zy
ZWUoYnVmZmVyKTsKKwkJcmV0ID0gc2NzaV9wYXJ0c2l6ZShidWZmZXIsIGNhcGFjaXR5LCAmZ2Vv
bVsyXSwgJmdlb21bMF0sCisJCQkmZ2VvbVsxXSk7CisJCWtmcmVlKChjb25zdCB2b2lkICopYnVm
ZmVyKTsKIAkJaWYgKHJldCAhPSAtMSkKIAkJCXJldHVybiByZXQ7CiAJfQpAQCAtMjg4LDI3ICsz
MzQsNTMgQEAgc3RhdGljIGludCBhcmNtc3JfYmlvc19wYXJhbShzdHJ1Y3Qgc2NzaQogCXJldHVy
biAwOwogfQogCi1zdGF0aWMgdm9pZCBhcmNtc3JfZGVmaW5lX2FkYXB0ZXJfdHlwZShzdHJ1Y3Qg
QWRhcHRlckNvbnRyb2xCbG9jayAqYWNiKQorc3RhdGljIGJvb2wKK2FyY21zcl9kZWZpbmVfYWRh
cHRlcl90eXBlKHN0cnVjdCBBZGFwdGVyQ29udHJvbEJsb2NrICphY2IpCiB7Ci0Jc3RydWN0IHBj
aV9kZXYgKnBkZXYgPSBhY2ItPnBkZXY7CiAJdTE2IGRldl9pZDsKKwlzdHJ1Y3QgcGNpX2RldiAq
cGRldiA9IGFjYi0+cGRldjsKKwogCXBjaV9yZWFkX2NvbmZpZ193b3JkKHBkZXYsIFBDSV9ERVZJ
Q0VfSUQsICZkZXZfaWQpOwogCWFjYi0+ZGV2X2lkID0gZGV2X2lkOwogCXN3aXRjaCAoZGV2X2lk
KSB7CiAJY2FzZSAweDE4ODA6IHsKIAkJYWNiLT5hZGFwdGVyX3R5cGUgPSBBQ0JfQURBUFRFUl9U
WVBFX0M7Ci0JCX0KIAkJYnJlYWs7Ci0JY2FzZSAweDEyMDE6IHsKKwl9CisJY2FzZSAweDEyMDA6
CisJY2FzZSAweDEyMDE6CisJY2FzZSAweDEyMDI6IHsKIAkJYWNiLT5hZGFwdGVyX3R5cGUgPSBB
Q0JfQURBUFRFUl9UWVBFX0I7Ci0JCX0KIAkJYnJlYWs7Ci0KLQlkZWZhdWx0OiBhY2ItPmFkYXB0
ZXJfdHlwZSA9IEFDQl9BREFQVEVSX1RZUEVfQTsKIAl9CisJY2FzZSAweDExMTA6CisJY2FzZSAw
eDExMjA6CisJY2FzZSAweDExMzA6CisJY2FzZSAweDExNjA6CisJY2FzZSAweDExNzA6CisJY2Fz
ZSAweDEyMTA6CisJY2FzZSAweDEyMjA6CisJY2FzZSAweDEyMzA6CisJY2FzZSAweDEyNjA6CisJ
Y2FzZSAweDEyODA6CisJY2FzZSAweDE2ODA6IHsKKwkJYWNiLT5hZGFwdGVyX3R5cGUgPSBBQ0Jf
QURBUFRFUl9UWVBFX0E7CisJCWJyZWFrOworCX0KKwljYXNlIDB4MTIxNDogeworCQlhY2ItPmFk
YXB0ZXJfdHlwZSA9IEFDQl9BREFQVEVSX1RZUEVfRDsKKwkJYnJlYWs7CisJfQorCWRlZmF1bHQ6
IHsKKwkJcHJfbm90aWNlKCJVbmtub3duIGRldmljZSBJRCA9IDB4JXhcbiIsIGRldl9pZCk7CisJ
CXJldHVybiBmYWxzZTsKKwl9CisJfQorCXJldHVybiB0cnVlOwogfQogCi1zdGF0aWMgdWludDhf
dCBhcmNtc3JfaGJhX3dhaXRfbXNnaW50X3JlYWR5KHN0cnVjdCBBZGFwdGVyQ29udHJvbEJsb2Nr
ICphY2IpCitzdGF0aWMgYm9vbAorYXJjbXNyX2hiYUFfd2FpdF9tc2dpbnRfcmVhZHkoc3RydWN0
IEFkYXB0ZXJDb250cm9sQmxvY2sgKmFjYikKIHsKIAlzdHJ1Y3QgTWVzc2FnZVVuaXRfQSBfX2lv
bWVtICpyZWcgPSBhY2ItPnBtdUE7CiAJaW50IGk7CkBAIC0zMjYsOSArMzk4LDEwIEBAIHN0YXRp
YyB1aW50OF90IGFyY21zcl9oYmFfd2FpdF9tc2dpbnRfcmUKIAlyZXR1cm4gZmFsc2U7CiB9CiAK
LXN0YXRpYyB1aW50OF90IGFyY21zcl9oYmJfd2FpdF9tc2dpbnRfcmVhZHkoc3RydWN0IEFkYXB0
ZXJDb250cm9sQmxvY2sgKmFjYikKK3N0YXRpYyBib29sCithcmNtc3JfaGJhQl93YWl0X21zZ2lu
dF9yZWFkeShzdHJ1Y3QgQWRhcHRlckNvbnRyb2xCbG9jayAqYWNiKQogewotCXN0cnVjdCBNZXNz
YWdlVW5pdF9CICpyZWcgPSBhY2ItPnBtdUI7CisJc3RydWN0IE1lc3NhZ2VVbml0X0IgX19pb21l
bSAqcmVnID0gYWNiLT5wbXVCOwogCWludCBpOwogCiAJZm9yIChpID0gMDsgaSA8IDIwMDA7IGkr
KykgewpAQCAtMzQ2LDI4MyArNDE5LDU1OCBAQCBzdGF0aWMgdWludDhfdCBhcmNtc3JfaGJiX3dh
aXRfbXNnaW50X3JlCiAJcmV0dXJuIGZhbHNlOwogfQogCi1zdGF0aWMgdWludDhfdCBhcmNtc3Jf
aGJjX3dhaXRfbXNnaW50X3JlYWR5KHN0cnVjdCBBZGFwdGVyQ29udHJvbEJsb2NrICpwQUNCKQor
c3RhdGljIGJvb2wKK2FyY21zcl9oYmFDX3dhaXRfbXNnaW50X3JlYWR5KHN0cnVjdCBBZGFwdGVy
Q29udHJvbEJsb2NrICpwQUNCKQogewotCXN0cnVjdCBNZXNzYWdlVW5pdF9DICpwaGJjbXUgPSAo
c3RydWN0IE1lc3NhZ2VVbml0X0MgKilwQUNCLT5wbXVDOworCXN0cnVjdCBNZXNzYWdlVW5pdF9D
IF9faW9tZW0gKnBoYmNtdSA9IHBBQ0ItPnBtdUM7CiAJaW50IGk7CiAKIAlmb3IgKGkgPSAwOyBp
IDwgMjAwMDsgaSsrKSB7CiAJCWlmIChyZWFkbCgmcGhiY211LT5vdXRib3VuZF9kb29yYmVsbCkK
LQkJCQkmIEFSQ01TUl9IQkNNVV9JT1AyRFJWX01FU1NBR0VfQ01EX0RPTkUpIHsKKwkJCSYgQVJD
TVNSX0hCQ01VX0lPUDJEUlZfTUVTU0FHRV9DTURfRE9ORSkgewogCQkJd3JpdGVsKEFSQ01TUl9I
QkNNVV9JT1AyRFJWX01FU1NBR0VfQ01EX0RPTkVfRE9PUkJFTExfQ0xFQVIsCi0JCQkJJnBoYmNt
dS0+b3V0Ym91bmRfZG9vcmJlbGxfY2xlYXIpOyAvKmNsZWFyIGludGVycnVwdCovCisJCQkJJnBo
YmNtdS0+b3V0Ym91bmRfZG9vcmJlbGxfY2xlYXIpOwogCQkJcmV0dXJuIHRydWU7CiAJCX0KIAkJ
bXNsZWVwKDEwKTsKLQl9IC8qIG1heCAyMCBzZWNvbmRzICovCisJfQorCXJldHVybiBmYWxzZTsK
K30KIAorc3RhdGljIGJvb2wKK2FyY21zcl9oYmFEX3dhaXRfbXNnaW50X3JlYWR5KHN0cnVjdCBB
ZGFwdGVyQ29udHJvbEJsb2NrICpwQUNCKQoreworCWludCBpOworCXN0cnVjdCBNZXNzYWdlVW5p
dF9EIF9faW9tZW0gKnJlZyA9IHBBQ0ItPnBtdUQ7CisJZm9yIChpID0gMDsgaSA8IDIwMDA7IGkr
KykgeworCQlpZiAocmVhZGwocmVnLT5vdXRib3VuZF9kb29yYmVsbCkKKwkJCSYgQVJDTVNSX0FS
QzEyMTRfSU9QMkRSVl9NRVNTQUdFX0NNRF9ET05FKSB7CisJCQl3cml0ZWwoQVJDTVNSX0FSQzEy
MTRfSU9QMkRSVl9NRVNTQUdFX0NNRF9ET05FLAorCQkJCXJlZy0+b3V0Ym91bmRfZG9vcmJlbGwp
OworCQkJcmV0dXJuIHRydWU7CisJCX0KKwkJbXNsZWVwKDEwKTsKKwl9IC8qIG1heCAyMCBzZWNv
bmRzICovCiAJcmV0dXJuIGZhbHNlOwogfQogCi1zdGF0aWMgdm9pZCBhcmNtc3JfZmx1c2hfaGJh
X2NhY2hlKHN0cnVjdCBBZGFwdGVyQ29udHJvbEJsb2NrICphY2IpCitzdGF0aWMgdm9pZAorYXJj
bXNyX2hiYUFfZmx1c2hfY2FjaGUoc3RydWN0IEFkYXB0ZXJDb250cm9sQmxvY2sgKmFjYikKIHsK
IAlzdHJ1Y3QgTWVzc2FnZVVuaXRfQSBfX2lvbWVtICpyZWcgPSBhY2ItPnBtdUE7CiAJaW50IHJl
dHJ5X2NvdW50ID0gMzA7CiAJd3JpdGVsKEFSQ01TUl9JTkJPVU5EX01FU0cwX0ZMVVNIX0NBQ0hF
LCAmcmVnLT5pbmJvdW5kX21zZ2FkZHIwKTsKIAlkbyB7Ci0JCWlmIChhcmNtc3JfaGJhX3dhaXRf
bXNnaW50X3JlYWR5KGFjYikpCisJCWlmIChhcmNtc3JfaGJhQV93YWl0X21zZ2ludF9yZWFkeShh
Y2IpKQogCQkJYnJlYWs7CiAJCWVsc2UgewogCQkJcmV0cnlfY291bnQtLTsKLQkJCXByaW50ayhL
RVJOX05PVElDRSAiYXJjbXNyJWQ6IHdhaXQgJ2ZsdXNoIGFkYXB0ZXIgY2FjaGUnIFwKLQkJCXRp
bWVvdXQsIHJldHJ5IGNvdW50IGRvd24gPSAlZCBcbiIsIGFjYi0+aG9zdC0+aG9zdF9ubywgcmV0
cnlfY291bnQpOworCQkJcHJfbm90aWNlKCJhcmNtc3IlZDogd2FpdCAnZmx1c2ggYWRhcHRlciAi
CisJCQkJImNhY2hlJyB0aW1lb3V0LCByZXRyeSBjb3VudCBkb3duID0gJWRcbiIsCisJCQlhY2It
Pmhvc3QtPmhvc3Rfbm8sIHJldHJ5X2NvdW50KTsKIAkJfQogCX0gd2hpbGUgKHJldHJ5X2NvdW50
ICE9IDApOwogfQogCi1zdGF0aWMgdm9pZCBhcmNtc3JfZmx1c2hfaGJiX2NhY2hlKHN0cnVjdCBB
ZGFwdGVyQ29udHJvbEJsb2NrICphY2IpCitzdGF0aWMgdm9pZAorYXJjbXNyX2hiYUJfZmx1c2hf
Y2FjaGUoc3RydWN0IEFkYXB0ZXJDb250cm9sQmxvY2sgKmFjYikKIHsKLQlzdHJ1Y3QgTWVzc2Fn
ZVVuaXRfQiAqcmVnID0gYWNiLT5wbXVCOworCXN0cnVjdCBNZXNzYWdlVW5pdF9CIF9faW9tZW0g
KnJlZyA9IGFjYi0+cG11QjsKIAlpbnQgcmV0cnlfY291bnQgPSAzMDsKIAl3cml0ZWwoQVJDTVNS
X01FU1NBR0VfRkxVU0hfQ0FDSEUsIHJlZy0+ZHJ2MmlvcF9kb29yYmVsbCk7CiAJZG8gewotCQlp
ZiAoYXJjbXNyX2hiYl93YWl0X21zZ2ludF9yZWFkeShhY2IpKQorCQlpZiAoYXJjbXNyX2hiYUJf
d2FpdF9tc2dpbnRfcmVhZHkoYWNiKSkKIAkJCWJyZWFrOwogCQllbHNlIHsKIAkJCXJldHJ5X2Nv
dW50LS07Ci0JCQlwcmludGsoS0VSTl9OT1RJQ0UgImFyY21zciVkOiB3YWl0ICdmbHVzaCBhZGFw
dGVyIGNhY2hlJyBcCi0JCQl0aW1lb3V0LHJldHJ5IGNvdW50IGRvd24gPSAlZCBcbiIsIGFjYi0+
aG9zdC0+aG9zdF9ubywgcmV0cnlfY291bnQpOworCQkJcHJfbm90aWNlKCJhcmNtc3IlZDogd2Fp
dCAnZmx1c2ggYWRhcHRlciAiCisJCQkJImNhY2hlJyB0aW1lb3V0LCByZXRyeSBjb3VudCBkb3du
ID0gJWRcbiIsCisJCQlhY2ItPmhvc3QtPmhvc3Rfbm8sIHJldHJ5X2NvdW50KTsKIAkJfQogCX0g
d2hpbGUgKHJldHJ5X2NvdW50ICE9IDApOwogfQogCi1zdGF0aWMgdm9pZCBhcmNtc3JfZmx1c2hf
aGJjX2NhY2hlKHN0cnVjdCBBZGFwdGVyQ29udHJvbEJsb2NrICpwQUNCKQorc3RhdGljIHZvaWQK
K2FyY21zcl9oYmFDX2ZsdXNoX2NhY2hlKHN0cnVjdCBBZGFwdGVyQ29udHJvbEJsb2NrICpwQUNC
KQogewotCXN0cnVjdCBNZXNzYWdlVW5pdF9DICpyZWcgPSAoc3RydWN0IE1lc3NhZ2VVbml0X0Mg
KilwQUNCLT5wbXVDOwotCWludCByZXRyeV9jb3VudCA9IDMwOy8qIGVubGFyZ2Ugd2FpdCBmbHVz
aCBhZGFwdGVyIGNhY2hlIHRpbWU6IDEwIG1pbnV0ZSAqLwotCXdyaXRlbChBUkNNU1JfSU5CT1VO
RF9NRVNHMF9GTFVTSF9DQUNIRSwgJnJlZy0+aW5ib3VuZF9tc2dhZGRyMCk7Ci0Jd3JpdGVsKEFS
Q01TUl9IQkNNVV9EUlYySU9QX01FU1NBR0VfQ01EX0RPTkUsICZyZWctPmluYm91bmRfZG9vcmJl
bGwpOworCXN0cnVjdCBNZXNzYWdlVW5pdF9DIF9faW9tZW0gKnJlZyA9IHBBQ0ItPnBtdUM7CisJ
aW50IHJldHJ5X2NvdW50ID0gNjsvKiBlbmxhcmdlIHdhaXQgZmx1c2ggYWRhcHRlciBjYWNoZSB0
aW1lOiAxMCBtaW51dGUgKi8KKwl3cml0ZWwoQVJDTVNSX0lOQk9VTkRfTUVTRzBfRkxVU0hfQ0FD
SEUsCisJCSZyZWctPmluYm91bmRfbXNnYWRkcjApOworCXdyaXRlbChBUkNNU1JfSEJDTVVfRFJW
MklPUF9NRVNTQUdFX0NNRF9ET05FLAorCQkmcmVnLT5pbmJvdW5kX2Rvb3JiZWxsKTsKKwlyZWFk
bCgmcmVnLT5pbmJvdW5kX2Rvb3JiZWxsKTsKKwlyZWFkbCgmcmVnLT5pbmJvdW5kX21zZ2FkZHIw
KTsKIAlkbyB7Ci0JCWlmIChhcmNtc3JfaGJjX3dhaXRfbXNnaW50X3JlYWR5KHBBQ0IpKSB7CisJ
CWlmIChhcmNtc3JfaGJhQ193YWl0X21zZ2ludF9yZWFkeShwQUNCKSkKIAkJCWJyZWFrOwotCQl9
IGVsc2UgeworCQllbHNlIHsKKwkJCXJldHJ5X2NvdW50LS07CisJCQlwcl9ub3RpY2UoImFyY21z
ciVkOiB3YWl0ICdmbHVzaCBhZGFwdGVyICIKKwkJCQkiY2FjaGUnIHRpbWVvdXQsIHJldHJ5IGNv
dW50IGRvd24gPSAlZFxuIiwKKwkJCXBBQ0ItPmhvc3QtPmhvc3Rfbm8sIHJldHJ5X2NvdW50KTsK
KwkJfQorCX0gd2hpbGUgKHJldHJ5X2NvdW50ICE9IDApOworCXJldHVybjsKK30KKworc3RhdGlj
IHZvaWQKK2FyY21zcl9oYmFEX2ZsdXNoX2NhY2hlKHN0cnVjdCBBZGFwdGVyQ29udHJvbEJsb2Nr
ICpwQUNCKQoreworCWludCByZXRyeV9jb3VudCA9IDY7CisJc3RydWN0IE1lc3NhZ2VVbml0X0Qg
X19pb21lbSAqcmVnID0gcEFDQi0+cG11RDsKKworCXdyaXRlbChBUkNNU1JfSU5CT1VORF9NRVNH
MF9GTFVTSF9DQUNIRSwKKwkJcmVnLT5pbmJvdW5kX21zZ2FkZHIwKTsKKwlkbyB7CisJCWlmIChh
cmNtc3JfaGJhRF93YWl0X21zZ2ludF9yZWFkeShwQUNCKSkKKwkJCWJyZWFrOworCQllbHNlIHsK
IAkJCXJldHJ5X2NvdW50LS07Ci0JCQlwcmludGsoS0VSTl9OT1RJQ0UgImFyY21zciVkOiB3YWl0
ICdmbHVzaCBhZGFwdGVyIGNhY2hlJyBcCi0JCQl0aW1lb3V0LHJldHJ5IGNvdW50IGRvd24gPSAl
ZCBcbiIsIHBBQ0ItPmhvc3QtPmhvc3Rfbm8sIHJldHJ5X2NvdW50KTsKKwkJCXByX25vdGljZSgi
YXJjbXNyJWQ6IHdhaXQgJ2ZsdXNoIGFkYXB0ZXIgIgorCQkJCSJjYWNoZScgdGltZW91dCwgcmV0
cnkgY291bnQgZG93biA9ICVkXG4iLAorCQkJcEFDQi0+aG9zdC0+aG9zdF9ubywKKwkJCXJldHJ5
X2NvdW50KTsKIAkJfQogCX0gd2hpbGUgKHJldHJ5X2NvdW50ICE9IDApOwogCXJldHVybjsKIH0K
LXN0YXRpYyB2b2lkIGFyY21zcl9mbHVzaF9hZGFwdGVyX2NhY2hlKHN0cnVjdCBBZGFwdGVyQ29u
dHJvbEJsb2NrICphY2IpCisKK3N0YXRpYyB2b2lkCithcmNtc3JfZmx1c2hfYWRhcHRlcl9jYWNo
ZShzdHJ1Y3QgQWRhcHRlckNvbnRyb2xCbG9jayAqYWNiKQogewogCXN3aXRjaCAoYWNiLT5hZGFw
dGVyX3R5cGUpIHsKIAogCWNhc2UgQUNCX0FEQVBURVJfVFlQRV9BOiB7Ci0JCWFyY21zcl9mbHVz
aF9oYmFfY2FjaGUoYWNiKTsKLQkJfQorCQlhcmNtc3JfaGJhQV9mbHVzaF9jYWNoZShhY2IpOwog
CQlicmVhazsKLQotCWNhc2UgQUNCX0FEQVBURVJfVFlQRV9COiB7Ci0JCWFyY21zcl9mbHVzaF9o
YmJfY2FjaGUoYWNiKTsKIAkJfQorCWNhc2UgQUNCX0FEQVBURVJfVFlQRV9COiB7CisJCWFyY21z
cl9oYmFCX2ZsdXNoX2NhY2hlKGFjYik7CiAJCWJyZWFrOworCQl9CiAJY2FzZSBBQ0JfQURBUFRF
Ul9UWVBFX0M6IHsKLQkJYXJjbXNyX2ZsdXNoX2hiY19jYWNoZShhY2IpOworCQlhcmNtc3JfaGJh
Q19mbHVzaF9jYWNoZShhY2IpOworCQlicmVhazsKIAkJfQorCWNhc2UgQUNCX0FEQVBURVJfVFlQ
RV9EOiB7CisJCWFyY21zcl9oYmFEX2ZsdXNoX2NhY2hlKGFjYik7CisJCWJyZWFrOworCX0KIAl9
CiB9CiAKLXN0YXRpYyBpbnQgYXJjbXNyX2FsbG9jX2NjYl9wb29sKHN0cnVjdCBBZGFwdGVyQ29u
dHJvbEJsb2NrICphY2IpCitzdGF0aWMgaW50CithcmNtc3JfYWxsb2NfY2NiX3Bvb2woc3RydWN0
IEFkYXB0ZXJDb250cm9sQmxvY2sgKmFjYikKIHsKIAlzdHJ1Y3QgcGNpX2RldiAqcGRldiA9IGFj
Yi0+cGRldjsKIAl2b2lkICpkbWFfY29oZXJlbnQ7CiAJZG1hX2FkZHJfdCBkbWFfY29oZXJlbnRf
aGFuZGxlOwotCXN0cnVjdCBDb21tYW5kQ29udHJvbEJsb2NrICpjY2JfdG1wOworCXN0cnVjdCBD
b21tYW5kQ29udHJvbEJsb2NrICpjY2JfdG1wID0gTlVMTDsKIAlpbnQgaSA9IDAsIGogPSAwOwog
CWRtYV9hZGRyX3QgY2RiX3BoeWFkZHI7Ci0JdW5zaWduZWQgbG9uZyByb3VuZHVwX2NjYnNpemU7
CisJdW5zaWduZWQgbG9uZyByb3VuZHVwX2NjYnNpemUgPSAwOwogCXVuc2lnbmVkIGxvbmcgbWF4
X3hmZXJfbGVuOwogCXVuc2lnbmVkIGxvbmcgbWF4X3NnX2VudHJ5czsKIAl1aW50MzJfdCAgZmly
bV9jb25maWdfdmVyc2lvbjsKIAotCWZvciAoaSA9IDA7IGkgPCBBUkNNU1JfTUFYX1RBUkdFVElE
OyBpKyspCi0JCWZvciAoaiA9IDA7IGogPCBBUkNNU1JfTUFYX1RBUkdFVExVTjsgaisrKQotCQkJ
YWNiLT5kZXZzdGF0ZVtpXVtqXSA9IEFSRUNBX1JBSURfR09ORTsKLQogCW1heF94ZmVyX2xlbiA9
IEFSQ01TUl9NQVhfWEZFUl9MRU47CiAJbWF4X3NnX2VudHJ5cyA9IEFSQ01TUl9ERUZBVUxUX1NH
X0VOVFJJRVM7CiAJZmlybV9jb25maWdfdmVyc2lvbiA9IGFjYi0+ZmlybV9jZmdfdmVyc2lvbjsK
LQlpZigoZmlybV9jb25maWdfdmVyc2lvbiAmIDB4RkYpID49IDMpewotCQltYXhfeGZlcl9sZW4g
PSAoQVJDTVNSX0NEQl9TR19QQUdFX0xFTkdUSCA8PCAoKGZpcm1fY29uZmlnX3ZlcnNpb24gPj4g
OCkgJiAweEZGKSkgKiAxMDI0Oy8qIG1heCA0TSBieXRlICovCi0JCW1heF9zZ19lbnRyeXMgPSAo
bWF4X3hmZXJfbGVuLzQwOTYpOworCWlmICgoZmlybV9jb25maWdfdmVyc2lvbiAmIDB4RkYpID49
IDMpIHsKKwkJbWF4X3hmZXJfbGVuID0gKEFSQ01TUl9DREJfU0dfUEFHRV9MRU5HVEggPDwKKwkJ
CSgoZmlybV9jb25maWdfdmVyc2lvbiA+PiA4KSAmIDB4RkYpKSAqIDEwMjQ7CisJCW1heF9zZ19l
bnRyeXMgPSAobWF4X3hmZXJfbGVuIC8gNDA5Nik7CiAJfQotCWFjYi0+aG9zdC0+bWF4X3NlY3Rv
cnMgPSBtYXhfeGZlcl9sZW4vNTEyOworCWFjYi0+aG9zdC0+bWF4X3NlY3RvcnMgPSBtYXhfeGZl
cl9sZW4gLyA1MTI7CiAJYWNiLT5ob3N0LT5zZ190YWJsZXNpemUgPSBtYXhfc2dfZW50cnlzOwot
CXJvdW5kdXBfY2Nic2l6ZSA9IHJvdW5kdXAoc2l6ZW9mKHN0cnVjdCBDb21tYW5kQ29udHJvbEJs
b2NrKSArIChtYXhfc2dfZW50cnlzIC0gMSkgKiBzaXplb2Yoc3RydWN0IFNHNjRFTlRSWSksIDMy
KTsKKwlzd2l0Y2ggKGFjYi0+YWRhcHRlcl90eXBlKSB7CisJY2FzZSBBQ0JfQURBUFRFUl9UWVBF
X0E6CisJCXJvdW5kdXBfY2Nic2l6ZSA9IHJvdW5kdXAoc2l6ZW9mKHN0cnVjdCBDb21tYW5kQ29u
dHJvbEJsb2NrKSArCisJCQltYXhfc2dfZW50cnlzICogc2l6ZW9mKHN0cnVjdCBTRzY0RU5UUlkp
LCAzMik7CisJCWJyZWFrOworCWNhc2UgQUNCX0FEQVBURVJfVFlQRV9COgorCWNhc2UgQUNCX0FE
QVBURVJfVFlQRV9DOgorCWNhc2UgQUNCX0FEQVBURVJfVFlQRV9EOgorCQlyb3VuZHVwX2NjYnNp
emUgPSByb3VuZHVwKHNpemVvZihzdHJ1Y3QgQ29tbWFuZENvbnRyb2xCbG9jaykgKworCQkJKG1h
eF9zZ19lbnRyeXMgLSAxKSAqIHNpemVvZihzdHJ1Y3QgU0c2NEVOVFJZKSwgMzIpOworCQlicmVh
azsKKwl9CiAJYWNiLT51bmNhY2hlX3NpemUgPSByb3VuZHVwX2NjYnNpemUgKiBBUkNNU1JfTUFY
X0ZSRUVDQ0JfTlVNOwotCWRtYV9jb2hlcmVudCA9IGRtYV9hbGxvY19jb2hlcmVudCgmcGRldi0+
ZGV2LCBhY2ItPnVuY2FjaGVfc2l6ZSwgJmRtYV9jb2hlcmVudF9oYW5kbGUsIEdGUF9LRVJORUwp
OwotCWlmKCFkbWFfY29oZXJlbnQpewotCQlwcmludGsoS0VSTl9OT1RJQ0UgImFyY21zciVkOiBk
bWFfYWxsb2NfY29oZXJlbnQgZ290IGVycm9yXG4iLCBhY2ItPmhvc3QtPmhvc3Rfbm8pOworCWRt
YV9jb2hlcmVudCA9IGRtYV9hbGxvY19jb2hlcmVudCgmcGRldi0+ZGV2LAorCQlhY2ItPnVuY2Fj
aGVfc2l6ZSwgJmRtYV9jb2hlcmVudF9oYW5kbGUsIEdGUF9LRVJORUwpOworCWlmICghZG1hX2Nv
aGVyZW50KSB7CisJCXByX25vdGljZSgiYXJjbXNyJWQ6IGRtYV9hbGxvY19jb2hlcmVudCBnb3Qg
ZXJyb3JcbiIsCisJCQlhY2ItPmhvc3QtPmhvc3Rfbm8pOwogCQlyZXR1cm4gLUVOT01FTTsKIAl9
CisJbWVtc2V0KGRtYV9jb2hlcmVudCwgMCwgYWNiLT51bmNhY2hlX3NpemUpOwogCWFjYi0+ZG1h
X2NvaGVyZW50ID0gZG1hX2NvaGVyZW50OwogCWFjYi0+ZG1hX2NvaGVyZW50X2hhbmRsZSA9IGRt
YV9jb2hlcmVudF9oYW5kbGU7Ci0JbWVtc2V0KGRtYV9jb2hlcmVudCwgMCwgYWNiLT51bmNhY2hl
X3NpemUpOwotCWNjYl90bXAgPSBkbWFfY29oZXJlbnQ7Ci0JYWNiLT52aXIycGh5X29mZnNldCA9
ICh1bnNpZ25lZCBsb25nKWRtYV9jb2hlcmVudCAtICh1bnNpZ25lZCBsb25nKWRtYV9jb2hlcmVu
dF9oYW5kbGU7Ci0JZm9yKGkgPSAwOyBpIDwgQVJDTVNSX01BWF9GUkVFQ0NCX05VTTsgaSsrKXsK
LQkJY2RiX3BoeWFkZHIgPSBkbWFfY29oZXJlbnRfaGFuZGxlICsgb2Zmc2V0b2Yoc3RydWN0IENv
bW1hbmRDb250cm9sQmxvY2ssIGFyY21zcl9jZGIpOwotCQljY2JfdG1wLT5jZGJfcGh5YWRkcl9w
YXR0ZXJuID0gKChhY2ItPmFkYXB0ZXJfdHlwZSA9PSBBQ0JfQURBUFRFUl9UWVBFX0MpID8gY2Ri
X3BoeWFkZHIgOiAoY2RiX3BoeWFkZHIgPj4gNSkpOworCWNjYl90bXAgPSAoc3RydWN0IENvbW1h
bmRDb250cm9sQmxvY2sgKilkbWFfY29oZXJlbnQ7CisJYWNiLT52aXIycGh5X29mZnNldCA9ICh1
bnNpZ25lZCBsb25nKWRtYV9jb2hlcmVudCAtCisJCSh1bnNpZ25lZCBsb25nKWRtYV9jb2hlcmVu
dF9oYW5kbGU7CisJZm9yIChpID0gMDsgaSA8IEFSQ01TUl9NQVhfRlJFRUNDQl9OVU07IGkrKykg
eworCQljZGJfcGh5YWRkciA9IGRtYV9jb2hlcmVudF9oYW5kbGUgKworCQkJb2Zmc2V0b2Yoc3Ry
dWN0IENvbW1hbmRDb250cm9sQmxvY2ssIGFyY21zcl9jZGIpOworCQlzd2l0Y2ggKGFjYi0+YWRh
cHRlcl90eXBlKSB7CisJCWNhc2UgQUNCX0FEQVBURVJfVFlQRV9BOgorCQljYXNlIEFDQl9BREFQ
VEVSX1RZUEVfQjoKKwkJCWNjYl90bXAtPmNkYl9waHlhZGRyID0gY2RiX3BoeWFkZHIgPj4gNTsK
KwkJCWJyZWFrOworCQljYXNlIEFDQl9BREFQVEVSX1RZUEVfQzoKKwkJY2FzZSBBQ0JfQURBUFRF
Ul9UWVBFX0Q6CisJCQljY2JfdG1wLT5jZGJfcGh5YWRkciA9IGNkYl9waHlhZGRyOworCQkJYnJl
YWs7CisJCX0KIAkJYWNiLT5wY2NiX3Bvb2xbaV0gPSBjY2JfdG1wOwogCQljY2JfdG1wLT5hY2Ig
PSBhY2I7CiAJCUlOSVRfTElTVF9IRUFEKCZjY2JfdG1wLT5saXN0KTsKIAkJbGlzdF9hZGRfdGFp
bCgmY2NiX3RtcC0+bGlzdCwgJmFjYi0+Y2NiX2ZyZWVfbGlzdCk7Ci0JCWNjYl90bXAgPSAoc3Ry
dWN0IENvbW1hbmRDb250cm9sQmxvY2sgKikoKHVuc2lnbmVkIGxvbmcpY2NiX3RtcCArIHJvdW5k
dXBfY2Nic2l6ZSk7CisJCWNjYl90bXAgPSAoc3RydWN0IENvbW1hbmRDb250cm9sQmxvY2sgKikK
KwkJCSgodW5zaWduZWQgbG9uZyljY2JfdG1wICsgcm91bmR1cF9jY2JzaXplKTsKIAkJZG1hX2Nv
aGVyZW50X2hhbmRsZSA9IGRtYV9jb2hlcmVudF9oYW5kbGUgKyByb3VuZHVwX2NjYnNpemU7CiAJ
fQorCWZvciAoaSA9IDA7IGkgPCBBUkNNU1JfTUFYX1RBUkdFVElEOyBpKyspCisJCWZvciAoaiA9
IDA7IGogPCBBUkNNU1JfTUFYX1RBUkdFVExVTjsgaisrKQorCQkJYWNiLT5kZXZzdGF0ZVtpXVtq
XSA9IEFSRUNBX1JBSURfR09ORTsKIAlyZXR1cm4gMDsKIH0KIAotc3RhdGljIHZvaWQgYXJjbXNy
X21lc3NhZ2VfaXNyX2JoX2ZuKHN0cnVjdCB3b3JrX3N0cnVjdCAqd29yaykgCitzdGF0aWMgdm9p
ZAorYXJjbXNyX21lc3NhZ2VfaXNyX2JoX2ZuKHN0cnVjdCB3b3JrX3N0cnVjdCAqd29yaykKIHsK
LQlzdHJ1Y3QgQWRhcHRlckNvbnRyb2xCbG9jayAqYWNiID0gY29udGFpbmVyX29mKHdvcmssc3Ry
dWN0IEFkYXB0ZXJDb250cm9sQmxvY2ssIGFyY21zcl9kb19tZXNzYWdlX2lzcl9iaCk7CisJc3Ry
dWN0IEFkYXB0ZXJDb250cm9sQmxvY2sgKmFjYiA9IGNvbnRhaW5lcl9vZih3b3JrLAorCQlzdHJ1
Y3QgQWRhcHRlckNvbnRyb2xCbG9jaywgYXJjbXNyX2RvX21lc3NhZ2VfaXNyX2JoKTsKIAlzd2l0
Y2ggKGFjYi0+YWRhcHRlcl90eXBlKSB7Ci0JCWNhc2UgQUNCX0FEQVBURVJfVFlQRV9BOiB7Ci0K
LQkJCXN0cnVjdCBNZXNzYWdlVW5pdF9BIF9faW9tZW0gKnJlZyAgPSBhY2ItPnBtdUE7Ci0JCQlj
aGFyICphY2JfZGV2X21hcCA9IChjaGFyICopYWNiLT5kZXZpY2VfbWFwOwotCQkJdWludDMyX3Qg
X19pb21lbSAqc2lnbmF0dXJlID0gKHVpbnQzMl90IF9faW9tZW0qKSAoJnJlZy0+bWVzc2FnZV9y
d2J1ZmZlclswXSk7Ci0JCQljaGFyIF9faW9tZW0gKmRldmljZW1hcCA9IChjaGFyIF9faW9tZW0q
KSAoJnJlZy0+bWVzc2FnZV9yd2J1ZmZlclsyMV0pOwotCQkJaW50IHRhcmdldCwgbHVuOwotCQkJ
c3RydWN0IHNjc2lfZGV2aWNlICpwc2RldjsKLQkJCWNoYXIgZGlmZjsKLQotCQkJYXRvbWljX2lu
YygmYWNiLT5ycV9tYXBfdG9rZW4pOwotCQkJaWYgKHJlYWRsKHNpZ25hdHVyZSkgPT0gQVJDTVNS
X1NJR05BVFVSRV9HRVRfQ09ORklHKSB7Ci0JCQkJZm9yKHRhcmdldCA9IDA7IHRhcmdldCA8IEFS
Q01TUl9NQVhfVEFSR0VUSUQgLTE7IHRhcmdldCsrKSB7Ci0JCQkJCWRpZmYgPSAoKmFjYl9kZXZf
bWFwKV5yZWFkYihkZXZpY2VtYXApOwotCQkJCQlpZiAoZGlmZiAhPSAwKSB7Ci0JCQkJCQljaGFy
IHRlbXA7Ci0JCQkJCQkqYWNiX2Rldl9tYXAgPSByZWFkYihkZXZpY2VtYXApOwotCQkJCQkJdGVt
cCA9KmFjYl9kZXZfbWFwOwotCQkJCQkJZm9yKGx1biA9IDA7IGx1biA8IEFSQ01TUl9NQVhfVEFS
R0VUTFVOOyBsdW4rKykgewotCQkJCQkJCWlmKCh0ZW1wICYgMHgwMSk9PTEgJiYgKGRpZmYgJiAw
eDAxKSA9PSAxKSB7CQotCQkJCQkJCQlzY3NpX2FkZF9kZXZpY2UoYWNiLT5ob3N0LCAwLCB0YXJn
ZXQsIGx1bik7Ci0JCQkJCQkJfWVsc2UgaWYoKHRlbXAgJiAweDAxKSA9PSAwICYmIChkaWZmICYg
MHgwMSkgPT0gMSkgewotCQkJCQkJCQlwc2RldiA9IHNjc2lfZGV2aWNlX2xvb2t1cChhY2ItPmhv
c3QsIDAsIHRhcmdldCwgbHVuKTsKLQkJCQkJCQkJaWYgKHBzZGV2ICE9IE5VTEwgKSB7Ci0JCQkJ
CQkJCQlzY3NpX3JlbW92ZV9kZXZpY2UocHNkZXYpOwotCQkJCQkJCQkJc2NzaV9kZXZpY2VfcHV0
KHBzZGV2KTsKLQkJCQkJCQkJfQorCWNhc2UgQUNCX0FEQVBURVJfVFlQRV9BOiB7CisJCXN0cnVj
dCBNZXNzYWdlVW5pdF9BIF9faW9tZW0gKnJlZyAgPSBhY2ItPnBtdUE7CisJCWNoYXIgKmFjYl9k
ZXZfbWFwID0gKGNoYXIgKilhY2ItPmRldmljZV9tYXA7CisJCXVpbnQzMl90IF9faW9tZW0gKnNp
Z25hdHVyZSA9ICh1aW50MzJfdCBfX2lvbWVtICopCisJCQkoJnJlZy0+bWVzc2FnZV9yd2J1ZmZl
clswXSk7CisJCWNoYXIgX19pb21lbSAqZGV2aWNlbWFwID0gKGNoYXIgX19pb21lbSAqKQorCQkJ
KCZyZWctPm1lc3NhZ2VfcndidWZmZXJbMjFdKTsKKwkJaW50IHRhcmdldCwgbHVuOworCQlzdHJ1
Y3Qgc2NzaV9kZXZpY2UgKnBzZGV2OworCQljaGFyIGRpZmY7CisKKwkJYXRvbWljX2luYygmYWNi
LT5ycV9tYXBfdG9rZW4pOworCQlpZiAocmVhZGwoc2lnbmF0dXJlKSA9PSBBUkNNU1JfU0lHTkFU
VVJFX0dFVF9DT05GSUcpIHsKKwkJCWZvciAodGFyZ2V0ID0gMDsgdGFyZ2V0IDwgQVJDTVNSX01B
WF9UQVJHRVRJRCAtIDE7CisJCQl0YXJnZXQrKykgeworCQkJCWRpZmYgPSAoKmFjYl9kZXZfbWFw
KSBeIHJlYWRiKGRldmljZW1hcCk7CisJCQkJaWYgKGRpZmYgIT0gMCkgeworCQkJCQljaGFyIHRl
bXA7CisJCQkJCSphY2JfZGV2X21hcCA9IHJlYWRiKGRldmljZW1hcCk7CisJCQkJCXRlbXAgPSAq
YWNiX2Rldl9tYXA7CisJCQkJCWZvciAobHVuID0gMDsgbHVuIDwKKwkJCQkJQVJDTVNSX01BWF9U
QVJHRVRMVU47IGx1bisrKSB7CisJCQkJCQlpZiAoKHRlbXAgJiAweDAxKSA9PSAxICYmCisJCQkJ
CQkJKGRpZmYgJiAweDAxKSA9PSAxKSB7CisJCQkJCQkJc2NzaV9hZGRfZGV2aWNlKGFjYi0+aG9z
dCwKKwkJCQkJCQkJMCwgdGFyZ2V0LCBsdW4pOworCQkJCQkJfSBlbHNlIGlmICgodGVtcCAmIDB4
MDEpID09IDAKKwkJCQkJCQkmJiAoZGlmZiAmIDB4MDEpID09IDEpIHsKKwkJCQkJCQlwc2RldiA9
CisJCQkJCQkJCXNjc2lfZGV2aWNlX2xvb2t1cChhY2ItPmhvc3QsCisJCQkJCQkJCTAsIHRhcmdl
dCwgbHVuKTsKKwkJCQkJCQlpZiAocHNkZXYgIT0gTlVMTCkgeworCQkJCQkJCQlzY3NpX3JlbW92
ZV9kZXZpY2UocHNkZXYpOworCQkJCQkJCQlzY3NpX2RldmljZV9wdXQocHNkZXYpOwogCQkJCQkJ
CX0KLQkJCQkJCQl0ZW1wID4+PSAxOwotCQkJCQkJCWRpZmYgPj49IDE7CiAJCQkJCQl9CisJCQkJ
CQl0ZW1wID4+PSAxOworCQkJCQkJZGlmZiA+Pj0gMTsKIAkJCQkJfQotCQkJCQlkZXZpY2VtYXAr
KzsKLQkJCQkJYWNiX2Rldl9tYXArKzsKIAkJCQl9CisJCQkJZGV2aWNlbWFwKys7CisJCQkJYWNi
X2Rldl9tYXArKzsKIAkJCX0KLQkJCWJyZWFrOwogCQl9CisJCWJyZWFrOworCX0KIAotCQljYXNl
IEFDQl9BREFQVEVSX1RZUEVfQjogewotCQkJc3RydWN0IE1lc3NhZ2VVbml0X0IgKnJlZyAgPSBh
Y2ItPnBtdUI7Ci0JCQljaGFyICphY2JfZGV2X21hcCA9IChjaGFyICopYWNiLT5kZXZpY2VfbWFw
OwotCQkJdWludDMyX3QgX19pb21lbSAqc2lnbmF0dXJlID0gKHVpbnQzMl90IF9faW9tZW0qKSgm
cmVnLT5tZXNzYWdlX3J3YnVmZmVyWzBdKTsKLQkJCWNoYXIgX19pb21lbSAqZGV2aWNlbWFwID0g
KGNoYXIgX19pb21lbSopKCZyZWctPm1lc3NhZ2VfcndidWZmZXJbMjFdKTsKLQkJCWludCB0YXJn
ZXQsIGx1bjsKLQkJCXN0cnVjdCBzY3NpX2RldmljZSAqcHNkZXY7Ci0JCQljaGFyIGRpZmY7Ci0K
LQkJCWF0b21pY19pbmMoJmFjYi0+cnFfbWFwX3Rva2VuKTsKLQkJCWlmIChyZWFkbChzaWduYXR1
cmUpID09IEFSQ01TUl9TSUdOQVRVUkVfR0VUX0NPTkZJRykgewotCQkJCWZvcih0YXJnZXQgPSAw
OyB0YXJnZXQgPCBBUkNNU1JfTUFYX1RBUkdFVElEIC0xOyB0YXJnZXQrKykgewotCQkJCQlkaWZm
ID0gKCphY2JfZGV2X21hcClecmVhZGIoZGV2aWNlbWFwKTsKLQkJCQkJaWYgKGRpZmYgIT0gMCkg
ewotCQkJCQkJY2hhciB0ZW1wOwotCQkJCQkJKmFjYl9kZXZfbWFwID0gcmVhZGIoZGV2aWNlbWFw
KTsKLQkJCQkJCXRlbXAgPSphY2JfZGV2X21hcDsKLQkJCQkJCWZvcihsdW4gPSAwOyBsdW4gPCBB
UkNNU1JfTUFYX1RBUkdFVExVTjsgbHVuKyspIHsKLQkJCQkJCQlpZigodGVtcCAmIDB4MDEpPT0x
ICYmIChkaWZmICYgMHgwMSkgPT0gMSkgewkKLQkJCQkJCQkJc2NzaV9hZGRfZGV2aWNlKGFjYi0+
aG9zdCwgMCwgdGFyZ2V0LCBsdW4pOwotCQkJCQkJCX1lbHNlIGlmKCh0ZW1wICYgMHgwMSkgPT0g
MCAmJiAoZGlmZiAmIDB4MDEpID09IDEpIHsKLQkJCQkJCQkJcHNkZXYgPSBzY3NpX2RldmljZV9s
b29rdXAoYWNiLT5ob3N0LCAwLCB0YXJnZXQsIGx1bik7Ci0JCQkJCQkJCWlmIChwc2RldiAhPSBO
VUxMICkgewotCQkJCQkJCQkJc2NzaV9yZW1vdmVfZGV2aWNlKHBzZGV2KTsKLQkJCQkJCQkJCXNj
c2lfZGV2aWNlX3B1dChwc2Rldik7Ci0JCQkJCQkJCX0KKwljYXNlIEFDQl9BREFQVEVSX1RZUEVf
QjogeworCQlzdHJ1Y3QgTWVzc2FnZVVuaXRfQiBfX2lvbWVtICpyZWcgID0gYWNiLT5wbXVCOwor
CQljaGFyICphY2JfZGV2X21hcCA9IChjaGFyICopYWNiLT5kZXZpY2VfbWFwOworCQl1aW50MzJf
dCBfX2lvbWVtICpzaWduYXR1cmUgPQorCQkJKHVpbnQzMl90IF9faW9tZW0gKikoJnJlZy0+bWVz
c2FnZV9yd2J1ZmZlclswXSk7CisJCWNoYXIgX19pb21lbSAqZGV2aWNlbWFwID0KKwkJCShjaGFy
IF9faW9tZW0gKikoJnJlZy0+bWVzc2FnZV9yd2J1ZmZlclsyMV0pOworCQlpbnQgdGFyZ2V0LCBs
dW47CisJCXN0cnVjdCBzY3NpX2RldmljZSAqcHNkZXY7CisJCWNoYXIgZGlmZjsKKworCQlhdG9t
aWNfaW5jKCZhY2ItPnJxX21hcF90b2tlbik7CisJCWlmIChyZWFkbChzaWduYXR1cmUpID09IEFS
Q01TUl9TSUdOQVRVUkVfR0VUX0NPTkZJRykgeworCQkJZm9yICh0YXJnZXQgPSAwOyB0YXJnZXQg
PAorCQkJQVJDTVNSX01BWF9UQVJHRVRJRCAtIDE7IHRhcmdldCsrKSB7CisJCQkJZGlmZiA9ICgq
YWNiX2Rldl9tYXApIF4gcmVhZGIoZGV2aWNlbWFwKTsKKwkJCQlpZiAoZGlmZiAhPSAwKSB7CisJ
CQkJCWNoYXIgdGVtcDsKKwkJCQkJKmFjYl9kZXZfbWFwID0gcmVhZGIoZGV2aWNlbWFwKTsKKwkJ
CQkJdGVtcCA9ICphY2JfZGV2X21hcDsKKwkJCQkJZm9yIChsdW4gPSAwOworCQkJCQkJbHVuIDwg
QVJDTVNSX01BWF9UQVJHRVRMVU47CisJCQkJCQlsdW4rKykgeworCQkJCQkJaWYgKCh0ZW1wICYg
MHgwMSkgPT0gMSAmJgorCQkJCQkJCShkaWZmICYgMHgwMSkgPT0gMSkgeworCQkJCQkJCXNjc2lf
YWRkX2RldmljZShhY2ItPmhvc3QsCisJCQkJCQkJCTAsIHRhcmdldCwgbHVuKTsKKwkJCQkJCX0g
ZWxzZSBpZiAoKHRlbXAgJiAweDAxKSA9PSAwCisJCQkJCQkJJiYgKGRpZmYgJiAweDAxKSA9PSAx
KSB7CisJCQkJCQkJcHNkZXYgPSBzY3NpX2RldmljZV9sb29rdXAoYWNiLT5ob3N0LAorCQkJCQkJ
CQkwLCB0YXJnZXQsIGx1bik7CisJCQkJCQkJaWYgKHBzZGV2ICE9IE5VTEwpIHsKKwkJCQkJCQkJ
c2NzaV9yZW1vdmVfZGV2aWNlKHBzZGV2KTsKKwkJCQkJCQkJc2NzaV9kZXZpY2VfcHV0KHBzZGV2
KTsKIAkJCQkJCQl9Ci0JCQkJCQkJdGVtcCA+Pj0gMTsKLQkJCQkJCQlkaWZmID4+PSAxOwogCQkJ
CQkJfQorCQkJCQkJdGVtcCA+Pj0gMTsKKwkJCQkJCWRpZmYgPj49IDE7CiAJCQkJCX0KLQkJCQkJ
ZGV2aWNlbWFwKys7Ci0JCQkJCWFjYl9kZXZfbWFwKys7CiAJCQkJfQorCQkJCWRldmljZW1hcCsr
OworCQkJCWFjYl9kZXZfbWFwKys7CiAJCQl9CiAJCX0KLQkJYnJlYWs7Ci0JCWNhc2UgQUNCX0FE
QVBURVJfVFlQRV9DOiB7Ci0JCQlzdHJ1Y3QgTWVzc2FnZVVuaXRfQyAqcmVnICA9IGFjYi0+cG11
QzsKLQkJCWNoYXIgKmFjYl9kZXZfbWFwID0gKGNoYXIgKilhY2ItPmRldmljZV9tYXA7Ci0JCQl1
aW50MzJfdCBfX2lvbWVtICpzaWduYXR1cmUgPSAodWludDMyX3QgX19pb21lbSAqKSgmcmVnLT5t
c2djb2RlX3J3YnVmZmVyWzBdKTsKLQkJCWNoYXIgX19pb21lbSAqZGV2aWNlbWFwID0gKGNoYXIg
X19pb21lbSAqKSgmcmVnLT5tc2djb2RlX3J3YnVmZmVyWzIxXSk7Ci0JCQlpbnQgdGFyZ2V0LCBs
dW47Ci0JCQlzdHJ1Y3Qgc2NzaV9kZXZpY2UgKnBzZGV2OwotCQkJY2hhciBkaWZmOwotCi0JCQlh
dG9taWNfaW5jKCZhY2ItPnJxX21hcF90b2tlbik7Ci0JCQlpZiAocmVhZGwoc2lnbmF0dXJlKSA9
PSBBUkNNU1JfU0lHTkFUVVJFX0dFVF9DT05GSUcpIHsKLQkJCQlmb3IgKHRhcmdldCA9IDA7IHRh
cmdldCA8IEFSQ01TUl9NQVhfVEFSR0VUSUQgLSAxOyB0YXJnZXQrKykgewotCQkJCQlkaWZmID0g
KCphY2JfZGV2X21hcClecmVhZGIoZGV2aWNlbWFwKTsKLQkJCQkJaWYgKGRpZmYgIT0gMCkgewot
CQkJCQkJY2hhciB0ZW1wOwotCQkJCQkJKmFjYl9kZXZfbWFwID0gcmVhZGIoZGV2aWNlbWFwKTsK
LQkJCQkJCXRlbXAgPSAqYWNiX2Rldl9tYXA7Ci0JCQkJCQlmb3IgKGx1biA9IDA7IGx1biA8IEFS
Q01TUl9NQVhfVEFSR0VUTFVOOyBsdW4rKykgewotCQkJCQkJCWlmICgodGVtcCAmIDB4MDEpID09
IDEgJiYgKGRpZmYgJiAweDAxKSA9PSAxKSB7Ci0JCQkJCQkJCXNjc2lfYWRkX2RldmljZShhY2It
Pmhvc3QsIDAsIHRhcmdldCwgbHVuKTsKLQkJCQkJCQl9IGVsc2UgaWYgKCh0ZW1wICYgMHgwMSkg
PT0gMCAmJiAoZGlmZiAmIDB4MDEpID09IDEpIHsKLQkJCQkJCQkJcHNkZXYgPSBzY3NpX2Rldmlj
ZV9sb29rdXAoYWNiLT5ob3N0LCAwLCB0YXJnZXQsIGx1bik7Ci0JCQkJCQkJCWlmIChwc2RldiAh
PSBOVUxMKSB7Ci0JCQkJCQkJCQlzY3NpX3JlbW92ZV9kZXZpY2UocHNkZXYpOwotCQkJCQkJCQkJ
c2NzaV9kZXZpY2VfcHV0KHBzZGV2KTsKLQkJCQkJCQkJfQorCX0KKwlicmVhazsKKwljYXNlIEFD
Ql9BREFQVEVSX1RZUEVfQzogeworCQlzdHJ1Y3QgTWVzc2FnZVVuaXRfQyBfX2lvbWVtICpyZWcg
ID0gYWNiLT5wbXVDOworCQljaGFyICphY2JfZGV2X21hcCA9IChjaGFyICopYWNiLT5kZXZpY2Vf
bWFwOworCQl1aW50MzJfdCBfX2lvbWVtICpzaWduYXR1cmUgPQorCQkJKHVpbnQzMl90IF9faW9t
ZW0gKikoJnJlZy0+bXNnY29kZV9yd2J1ZmZlclswXSk7CisJCWNoYXIgX19pb21lbSAqZGV2aWNl
bWFwID0KKwkJCShjaGFyIF9faW9tZW0gKikoJnJlZy0+bXNnY29kZV9yd2J1ZmZlclsyMV0pOwor
CQlpbnQgdGFyZ2V0LCBsdW47CisJCXN0cnVjdCBzY3NpX2RldmljZSAqcHNkZXY7CisJCWNoYXIg
ZGlmZjsKKworCQlhdG9taWNfaW5jKCZhY2ItPnJxX21hcF90b2tlbik7CisJCWlmIChyZWFkbChz
aWduYXR1cmUpID09IEFSQ01TUl9TSUdOQVRVUkVfR0VUX0NPTkZJRykgeworCQkJZm9yICh0YXJn
ZXQgPSAwOyB0YXJnZXQgPAorCQkJCUFSQ01TUl9NQVhfVEFSR0VUSUQgLSAxOyB0YXJnZXQrKykg
eworCQkJCWRpZmYgPSAoKmFjYl9kZXZfbWFwKSBeIHJlYWRiKGRldmljZW1hcCk7CisJCQkJaWYg
KGRpZmYgIT0gMCkgeworCQkJCQljaGFyIHRlbXA7CisJCQkJCSphY2JfZGV2X21hcCA9CisJCQkJ
CQlyZWFkYihkZXZpY2VtYXApOworCQkJCQl0ZW1wID0gKmFjYl9kZXZfbWFwOworCQkJCQlmb3Ig
KGx1biA9IDA7IGx1biA8CisJCQkJCQlBUkNNU1JfTUFYX1RBUkdFVExVTjsgbHVuKyspIHsKKwkJ
CQkJCWlmICgodGVtcCAmIDB4MDEpID09IDEgJiYKKwkJCQkJCQkoZGlmZiAmIDB4MDEpID09IDEp
IHsKKwkJCQkJCQlzY3NpX2FkZF9kZXZpY2UoYWNiLT5ob3N0LAorCQkJCQkJCQkwLCB0YXJnZXQs
IGx1bik7CisJCQkJCQl9IGVsc2UgaWYgKCh0ZW1wICYgMHgwMSkgPT0gMAorCQkJCQkJCSYmIChk
aWZmICYgMHgwMSkgPT0gMSkgeworCQkJCQkJCXBzZGV2ID0gc2NzaV9kZXZpY2VfbG9va3VwKGFj
Yi0+aG9zdCwKKwkJCQkJCQkJMCwgdGFyZ2V0LCBsdW4pOworCQkJCQkJCWlmIChwc2RldiAhPSBO
VUxMKSB7CisJCQkJCQkJCXNjc2lfcmVtb3ZlX2RldmljZShwc2Rldik7CisJCQkJCQkJCXNjc2lf
ZGV2aWNlX3B1dChwc2Rldik7CisJCQkJCQkJfQorCQkJCQkJfQorCQkJCQkJdGVtcCA+Pj0gMTsK
KwkJCQkJCWRpZmYgPj49IDE7CisJCQkJCX0KKwkJCQl9CisJCQkJZGV2aWNlbWFwKys7CisJCQkJ
YWNiX2Rldl9tYXArKzsKKwkJCX0KKwkJfQorCX0KKwlicmVhazsKKwljYXNlIEFDQl9BREFQVEVS
X1RZUEVfRDogeworCQlzdHJ1Y3QgTWVzc2FnZVVuaXRfRCBfX2lvbWVtICpyZWcgID0gYWNiLT5w
bXVEOworCQljaGFyICphY2JfZGV2X21hcCA9IChjaGFyICopYWNiLT5kZXZpY2VfbWFwOworCQl1
aW50MzJfdCBfX2lvbWVtICpzaWduYXR1cmUgPQorCQkJKHVpbnQzMl90IF9faW9tZW0gKikoJnJl
Zy0+bXNnY29kZV9yd2J1ZmZlclswXSk7CisJCWNoYXIgX19pb21lbSAqZGV2aWNlbWFwID0KKwkJ
CShjaGFyIF9faW9tZW0gKikoJnJlZy0+bXNnY29kZV9yd2J1ZmZlclsyMV0pOworCQlpbnQgdGFy
Z2V0LCBsdW47CisJCXN0cnVjdCBzY3NpX2RldmljZSAqcHNkZXY7CisJCWNoYXIgZGlmZjsKKwor
CQlhdG9taWNfaW5jKCZhY2ItPnJxX21hcF90b2tlbik7CisJCWlmIChyZWFkbChzaWduYXR1cmUp
ID09IEFSQ01TUl9TSUdOQVRVUkVfR0VUX0NPTkZJRykgeworCQkJZm9yICh0YXJnZXQgPSAwOyB0
YXJnZXQgPAorCQkJCUFSQ01TUl9NQVhfVEFSR0VUSUQgLSAxOyB0YXJnZXQrKykgeworCQkJCWRp
ZmYgPSAoKmFjYl9kZXZfbWFwKSBeIHJlYWRiKGRldmljZW1hcCk7CisJCQkJaWYgKGRpZmYgIT0g
MCkgeworCQkJCQljaGFyIHRlbXA7CisJCQkJCSphY2JfZGV2X21hcCA9CisJCQkJCQlyZWFkYihk
ZXZpY2VtYXApOworCQkJCQl0ZW1wID0gKmFjYl9kZXZfbWFwOworCQkJCQlmb3IgKGx1biA9IDA7
IGx1biA8CisJCQkJCQlBUkNNU1JfTUFYX1RBUkdFVExVTjsgbHVuKyspIHsKKwkJCQkJCWlmICgo
dGVtcCAmIDB4MDEpID09IDEgJiYKKwkJCQkJCQkoZGlmZiAmIDB4MDEpID09IDEpIHsKKwkJCQkJ
CQlzY3NpX2FkZF9kZXZpY2UoYWNiLT5ob3N0LAorCQkJCQkJCQkwLCB0YXJnZXQsIGx1bik7CisJ
CQkJCQl9IGVsc2UgaWYgKCh0ZW1wICYgMHgwMSkgPT0gMAorCQkJCQkJCSYmIChkaWZmICYgMHgw
MSkgPT0gMSkgeworCQkJCQkJCXBzZGV2ID0gc2NzaV9kZXZpY2VfbG9va3VwKGFjYi0+aG9zdCwK
KwkJCQkJCQkJMCwgdGFyZ2V0LCBsdW4pOworCQkJCQkJCWlmIChwc2RldiAhPSBOVUxMKSB7CisJ
CQkJCQkJCXNjc2lfcmVtb3ZlX2RldmljZShwc2Rldik7CisJCQkJCQkJCXNjc2lfZGV2aWNlX3B1
dChwc2Rldik7CiAJCQkJCQkJfQotCQkJCQkJCXRlbXAgPj49IDE7Ci0JCQkJCQkJZGlmZiA+Pj0g
MTsKIAkJCQkJCX0KKwkJCQkJCXRlbXAgPj49IDE7CisJCQkJCQlkaWZmID4+PSAxOwogCQkJCQl9
Ci0JCQkJCWRldmljZW1hcCsrOwotCQkJCQlhY2JfZGV2X21hcCsrOwogCQkJCX0KKwkJCQlkZXZp
Y2VtYXArKzsKKwkJCQlhY2JfZGV2X21hcCsrOworCQkJfQorCQl9CisJCWJyZWFrOworCX0KKwl9
Cit9CisKK3N0YXRpYyBpbnQKK2FyY21zcl9zdXNwZW5kKHN0cnVjdCBwY2lfZGV2ICpwZGV2LCBw
bV9tZXNzYWdlX3Qgc3RhdGUpCit7CisJaW50IGk7CisJdWludDMyX3QgaW50bWFza19vcmc7CisJ
c3RydWN0IFNjc2lfSG9zdCAqaG9zdCA9IHBjaV9nZXRfZHJ2ZGF0YShwZGV2KTsKKwlzdHJ1Y3Qg
QWRhcHRlckNvbnRyb2xCbG9jayAqYWNiID0KKwkJKHN0cnVjdCBBZGFwdGVyQ29udHJvbEJsb2Nr
ICopaG9zdC0+aG9zdGRhdGE7CisKKwlpbnRtYXNrX29yZyA9IGFyY21zcl9kaXNhYmxlX291dGJv
dW5kX2ludHMoYWNiKTsKKwlpZiAoYWNiLT5hY2JfZmxhZ3MgJiBBQ0JfRl9NU0lfRU5BQkxFRCkg
eworCQlmcmVlX2lycShwZGV2LT5pcnEsIGFjYik7CisJCXBjaV9kaXNhYmxlX21zaShwZGV2KTsK
Kwl9IGVsc2UgaWYgKGFjYi0+YWNiX2ZsYWdzICYgQUNCX0ZfTVNJWF9FTkFCTEVEKSB7CisJCWZv
ciAoaSA9IDA7IGkgPCBBUkNNU1RfTlVNX01TSVhfVkVDVE9SUzsgaSsrKQorCQkJZnJlZV9pcnEo
YWNiLT5lbnRyaWVzW2ldLnZlY3RvciwgYWNiKTsKKwkJcGNpX2Rpc2FibGVfbXNpeChwZGV2KTsK
Kwl9IGVsc2UKKwkJZnJlZV9pcnEocGRldi0+aXJxLCBhY2IpOworCWRlbF90aW1lcl9zeW5jKCZh
Y2ItPmV0ZXJuYWxfdGltZXIpOworCWZsdXNoX3NjaGVkdWxlZF93b3JrKCk7CisJYXJjbXNyX3N0
b3BfYWRhcHRlcl9iZ3JiKGFjYik7CisJYXJjbXNyX2ZsdXNoX2FkYXB0ZXJfY2FjaGUoYWNiKTsK
KwlhcmNtc3JfZW5hYmxlX291dGJvdW5kX2ludHMoYWNiLCBpbnRtYXNrX29yZyk7CisJcGNpX3Nl
dF9kcnZkYXRhKHBkZXYsIGhvc3QpOworCXBjaV9zYXZlX3N0YXRlKHBkZXYpOworCXBjaV9kaXNh
YmxlX2RldmljZShwZGV2KTsKKwlwY2lfc2V0X3Bvd2VyX3N0YXRlKHBkZXYsIHBjaV9jaG9vc2Vf
c3RhdGUocGRldiwgc3RhdGUpKTsKKwlyZXR1cm4gMDsKK30KKworc3RhdGljIGludAorYXJjbXNy
X3Jlc3VtZShzdHJ1Y3QgcGNpX2RldiAqcGRldikKK3sKKwlpbnQgZXJyb3IsIGksIGo7CisJc3Ry
dWN0IFNjc2lfSG9zdCAqaG9zdCA9IHBjaV9nZXRfZHJ2ZGF0YShwZGV2KTsKKwlzdHJ1Y3QgQWRh
cHRlckNvbnRyb2xCbG9jayAqYWNiID0KKwkJKHN0cnVjdCBBZGFwdGVyQ29udHJvbEJsb2NrICop
aG9zdC0+aG9zdGRhdGE7CisJc3RydWN0IG1zaXhfZW50cnkgZW50cmllc1tBUkNNU1RfTlVNX01T
SVhfVkVDVE9SU107CisJcGNpX3NldF9wb3dlcl9zdGF0ZShwZGV2LCBQQ0lfRDApOworCXBjaV9l
bmFibGVfd2FrZShwZGV2LCBQQ0lfRDAsIDApOworCXBjaV9yZXN0b3JlX3N0YXRlKHBkZXYpOwor
CWlmIChwY2lfZW5hYmxlX2RldmljZShwZGV2KSkgeworCQlwcl93YXJuKCIlczogcGNpX2VuYWJs
ZV9kZXZpY2UgZXJyb3JcbiIsIF9fZnVuY19fKTsKKwkJcmV0dXJuIC1FTk9ERVY7CisJfQorCWVy
cm9yID0gcGNpX3NldF9kbWFfbWFzayhwZGV2LCBETUFfQklUX01BU0soNjQpKTsKKwlpZiAoZXJy
b3IpIHsKKwkJZXJyb3IgPSBwY2lfc2V0X2RtYV9tYXNrKHBkZXYsIERNQV9CSVRfTUFTSygzMikp
OworCQlpZiAoZXJyb3IpIHsKKwkJCQlwcl93YXJuKCJzY3NpJWQ6IE5vIHN1aXRhYmxlIERNQSBt
YXNrIGF2YWlsYWJsZVxuIiwKKwkJCSAgICAgICBob3N0LT5ob3N0X25vKTsKKwkJCWdvdG8gY29u
dHJvbGxlcl91bnJlZ2lzdGVyOworCQl9CisJfQorCXBjaV9zZXRfbWFzdGVyKHBkZXYpOworCWlm
IChwY2lfZmluZF9jYXBhYmlsaXR5KHBkZXYsIFBDSV9DQVBfSURfTVNJWCkpIHsKKwkJaWYgKCFw
Y2lfZW5hYmxlX21zaXgocGRldiwgZW50cmllcywKKwkJCUFSQ01TVF9OVU1fTVNJWF9WRUNUT1JT
KSkgeworCQkJZm9yIChpID0gMDsgaSA8IEFSQ01TVF9OVU1fTVNJWF9WRUNUT1JTOworCQkJCWkr
KykgeworCQkJCWVudHJpZXNbaV0uZW50cnkgPSBpOworCQkJCWlmIChyZXF1ZXN0X2lycShlbnRy
aWVzW2ldLnZlY3RvciwKKwkJCQkJYXJjbXNyX2RvX2ludGVycnVwdCwgMCwKKwkJCQkJImFyY21z
ciIsIGFjYikpIHsKKwkJCQkJZm9yIChqID0gMCA7IGogPCBpIDsgaisrKQorCQkJCQkJZnJlZV9p
cnEoZW50cmllc1tpXS52ZWN0b3IsCisJCQkJCQkJYWNiKTsKKwkJCQkJZ290byBjb250cm9sbGVy
X3N0b3A7CisJCQkJfQorCQkJCWFjYi0+ZW50cmllc1tpXSA9IGVudHJpZXNbaV07CisJCQl9CisJ
CQlhY2ItPmFjYl9mbGFncyB8PSBBQ0JfRl9NU0lYX0VOQUJMRUQ7CisJCX0gZWxzZSB7CisJCQlw
cl93YXJuKCJhcmNtc3IlZDogTVNJLVggIgorCQkJCSJmYWlsZWQgdG8gZW5hYmxlXG4iLCBhY2It
Pmhvc3QtPmhvc3Rfbm8pOworCQkJaWYgKHJlcXVlc3RfaXJxKHBkZXYtPmlycSwKKwkJCQlhcmNt
c3JfZG9faW50ZXJydXB0LCBJUlFGX1NIQVJFRCwKKwkJCQkiYXJjbXNyIiwgYWNiKSkgeworCQkJ
CWdvdG8gY29udHJvbGxlcl9zdG9wOwogCQkJfQogCQl9CisJfSBlbHNlIGlmIChwY2lfZmluZF9j
YXBhYmlsaXR5KHBkZXYsIFBDSV9DQVBfSURfTVNJKSkgeworCQlpZiAoIXBjaV9lbmFibGVfbXNp
KHBkZXYpKQorCQkJYWNiLT5hY2JfZmxhZ3MgfD0gQUNCX0ZfTVNJX0VOQUJMRUQ7CisJCWlmIChy
ZXF1ZXN0X2lycShwZGV2LT5pcnEsIGFyY21zcl9kb19pbnRlcnJ1cHQsCisJCQlJUlFGX1NIQVJF
RCwgImFyY21zciIsIGFjYikpCisJCQlnb3RvIGNvbnRyb2xsZXJfc3RvcDsKKwl9IGVsc2Ugewor
CQlpZiAocmVxdWVzdF9pcnEocGRldi0+aXJxLCBhcmNtc3JfZG9faW50ZXJydXB0LAorCQkJSVJR
Rl9TSEFSRUQsICJhcmNtc3IiLCBhY2IpKQorCQkJZ290byBjb250cm9sbGVyX3N0b3A7CiAJfQor
CWFyY21zcl9pb3BfaW5pdChhY2IpOworCUlOSVRfV09SSygmYWNiLT5hcmNtc3JfZG9fbWVzc2Fn
ZV9pc3JfYmgsCisJYXJjbXNyX21lc3NhZ2VfaXNyX2JoX2ZuKTsKKwlhdG9taWNfc2V0KCZhY2It
PnJxX21hcF90b2tlbiwgMTYpOworCWF0b21pY19zZXQoJmFjYi0+YW50ZV90b2tlbl92YWx1ZSwg
MTYpOworCWFjYi0+ZndfZmxhZyA9IEZXX05PUk1BTDsKKwlpbml0X3RpbWVyKCZhY2ItPmV0ZXJu
YWxfdGltZXIpOworCWFjYi0+ZXRlcm5hbF90aW1lci5leHBpcmVzID0gamlmZmllcyArCisJCW1z
ZWNzX3RvX2ppZmZpZXMoNiAqIEhaKTsKKwlhY2ItPmV0ZXJuYWxfdGltZXIuZGF0YSA9ICh1bnNp
Z25lZCBsb25nKSBhY2I7CisJYWNiLT5ldGVybmFsX3RpbWVyLmZ1bmN0aW9uID0KKwkJJmFyY21z
cl9yZXF1ZXN0X2RldmljZV9tYXA7CisJYWRkX3RpbWVyKCZhY2ItPmV0ZXJuYWxfdGltZXIpOwor
CXJldHVybiAwOworY29udHJvbGxlcl9zdG9wOgorCQlhcmNtc3Jfc3RvcF9hZGFwdGVyX2JncmIo
YWNiKTsKKwkJYXJjbXNyX2ZsdXNoX2FkYXB0ZXJfY2FjaGUoYWNiKTsKK2NvbnRyb2xsZXJfdW5y
ZWdpc3RlcjoKKwkJc2NzaV9yZW1vdmVfaG9zdChob3N0KTsKKwkJYXJjbXNyX2ZyZWVfY2NiX3Bv
b2woYWNiKTsKKwkJYXJjbXNyX3VubWFwX3BjaXJlZ2lvbihhY2IpOworCQlwY2lfcmVsZWFzZV9y
ZWdpb25zKHBkZXYpOworCQlzY3NpX2hvc3RfcHV0KGhvc3QpOworCQlwY2lfZGlzYWJsZV9kZXZp
Y2UocGRldik7CisJcmV0dXJuIC1FTk9ERVY7CiB9CiAKIHN0YXRpYyBpbnQgYXJjbXNyX3Byb2Jl
KHN0cnVjdCBwY2lfZGV2ICpwZGV2LCBjb25zdCBzdHJ1Y3QgcGNpX2RldmljZV9pZCAqaWQpCiB7
CiAJc3RydWN0IFNjc2lfSG9zdCAqaG9zdDsKIAlzdHJ1Y3QgQWRhcHRlckNvbnRyb2xCbG9jayAq
YWNiOwotCXVpbnQ4X3QgYnVzLGRldl9mdW47Ci0JaW50IGVycm9yOworCXVpbnQ4X3QgYnVzLCBk
ZXZfZnVuOworCXN0cnVjdCBtc2l4X2VudHJ5IGVudHJpZXNbQVJDTVNUX05VTV9NU0lYX1ZFQ1RP
UlNdOworCWludCBlcnJvciwgaSwgajsKIAllcnJvciA9IHBjaV9lbmFibGVfZGV2aWNlKHBkZXYp
OwotCWlmKGVycm9yKXsKKwlpZiAoZXJyb3IpCiAJCXJldHVybiAtRU5PREVWOwotCX0KLQlob3N0
ID0gc2NzaV9ob3N0X2FsbG9jKCZhcmNtc3Jfc2NzaV9ob3N0X3RlbXBsYXRlLCBzaXplb2Yoc3Ry
dWN0IEFkYXB0ZXJDb250cm9sQmxvY2spKTsKLQlpZighaG9zdCl7CisJaG9zdCA9IHNjc2lfaG9z
dF9hbGxvYygmYXJjbXNyX3Njc2lfaG9zdF90ZW1wbGF0ZSwKKwkJc2l6ZW9mKHN0cnVjdCBBZGFw
dGVyQ29udHJvbEJsb2NrKSk7CisJaWYgKCFob3N0KQogICAgIAkJZ290byBwY2lfZGlzYWJsZV9k
ZXY7Ci0JfQogCWVycm9yID0gcGNpX3NldF9kbWFfbWFzayhwZGV2LCBETUFfQklUX01BU0soNjQp
KTsKLQlpZihlcnJvcil7CisJaWYgKGVycm9yKSB7CiAJCWVycm9yID0gcGNpX3NldF9kbWFfbWFz
ayhwZGV2LCBETUFfQklUX01BU0soMzIpKTsKLQkJaWYoZXJyb3IpewotCQkJcHJpbnRrKEtFUk5f
V0FSTklORwotCQkJICAgICAgICJzY3NpJWQ6IE5vIHN1aXRhYmxlIERNQSBtYXNrIGF2YWlsYWJs
ZVxuIiwKLQkJCSAgICAgICBob3N0LT5ob3N0X25vKTsKKwkJaWYgKGVycm9yKSB7CisJCQlwcl93
YXJuKCJzY3NpJWQ6IE5vIHN1aXRhYmxlIERNQSBtYXNrIGF2YWlsYWJsZVxuIiwKKwkJCQlob3N0
LT5ob3N0X25vKTsKIAkJCWdvdG8gc2NzaV9ob3N0X3JlbGVhc2U7CiAJCX0KIAl9CkBAIC02MzQs
NzAgKzk4MiwxMTQgQEAgc3RhdGljIGludCBhcmNtc3JfcHJvYmUoc3RydWN0IHBjaV9kZXYgKgog
CWFjYi0+cGRldiA9IHBkZXY7CiAJYWNiLT5ob3N0ID0gaG9zdDsKIAlob3N0LT5tYXhfbHVuID0g
QVJDTVNSX01BWF9UQVJHRVRMVU47Ci0JaG9zdC0+bWF4X2lkID0gQVJDTVNSX01BWF9UQVJHRVRJ
RDsJCS8qMTY6OCovCi0JaG9zdC0+bWF4X2NtZF9sZW4gPSAxNjsJIAkJCS8qdGhpcyBpcyBpc3N1
ZSBvZiA2NGJpdCBMQkEgLG92ZXIgMlQgYnl0ZSovCi0JaG9zdC0+Y2FuX3F1ZXVlID0gQVJDTVNS
X01BWF9GUkVFQ0NCX05VTTsJLyogbWF4IHNpbXVsdGFuZW91cyBjbWRzICovCQkKLQlob3N0LT5j
bWRfcGVyX2x1biA9IEFSQ01TUl9NQVhfQ01EX1BFUkxVTjsJICAgIAorCWhvc3QtPm1heF9pZCA9
IEFSQ01TUl9NQVhfVEFSR0VUSUQ7CisJaG9zdC0+bWF4X2NtZF9sZW4gPSAxNjsKKwlob3N0LT5j
YW5fcXVldWUgPSBBUkNNU1JfTUFYX0ZSRUVDQ0JfTlVNOworCWhvc3QtPmNtZF9wZXJfbHVuID0g
QVJDTVNSX01BWF9DTURfUEVSTFVOOwogCWhvc3QtPnRoaXNfaWQgPSBBUkNNU1JfU0NTSV9JTklU
SUFUT1JfSUQ7CiAJaG9zdC0+dW5pcXVlX2lkID0gKGJ1cyA8PCA4KSB8IGRldl9mdW47CiAJcGNp
X3NldF9kcnZkYXRhKHBkZXYsIGhvc3QpOwogCXBjaV9zZXRfbWFzdGVyKHBkZXYpOwogCWVycm9y
ID0gcGNpX3JlcXVlc3RfcmVnaW9ucyhwZGV2LCAiYXJjbXNyIik7Ci0JaWYoZXJyb3IpeworCWlm
IChlcnJvcikKIAkJZ290byBzY3NpX2hvc3RfcmVsZWFzZTsKLQl9CiAJc3Bpbl9sb2NrX2luaXQo
JmFjYi0+ZWhfbG9jayk7CiAJc3Bpbl9sb2NrX2luaXQoJmFjYi0+Y2NibGlzdF9sb2NrKTsKKwlz
cGluX2xvY2tfaW5pdCgmYWNiLT5wb3N0cV9sb2NrKTsKKwlzcGluX2xvY2tfaW5pdCgmYWNiLT5k
b25lcV9sb2NrKTsKKwlzcGluX2xvY2tfaW5pdCgmYWNiLT5ycWJ1ZmZlcl9sb2NrKTsKKwlzcGlu
X2xvY2tfaW5pdCgmYWNiLT53cWJ1ZmZlcl9sb2NrKTsKIAlhY2ItPmFjYl9mbGFncyB8PSAoQUNC
X0ZfTUVTU0FHRV9XUUJVRkZFUl9DTEVBUkVEIHwKIAkJCUFDQl9GX01FU1NBR0VfUlFCVUZGRVJf
Q0xFQVJFRCB8CiAJCQlBQ0JfRl9NRVNTQUdFX1dRQlVGRkVSX1JFQURFRCk7CiAJYWNiLT5hY2Jf
ZmxhZ3MgJj0gfkFDQl9GX1NDU0lTVE9QQURBUFRFUjsKIAlJTklUX0xJU1RfSEVBRCgmYWNiLT5j
Y2JfZnJlZV9saXN0KTsKLQlhcmNtc3JfZGVmaW5lX2FkYXB0ZXJfdHlwZShhY2IpOworCWVycm9y
ID0gYXJjbXNyX2RlZmluZV9hZGFwdGVyX3R5cGUoYWNiKTsKKwlpZiAoIWVycm9yKQorCQlnb3Rv
IHBjaV9yZWxlYXNlX3JlZ3M7CiAJZXJyb3IgPSBhcmNtc3JfcmVtYXBfcGNpcmVnaW9uKGFjYik7
Ci0JaWYoIWVycm9yKXsKKwlpZiAoIWVycm9yKQogCQlnb3RvIHBjaV9yZWxlYXNlX3JlZ3M7Ci0J
fQogCWVycm9yID0gYXJjbXNyX2dldF9maXJtd2FyZV9zcGVjKGFjYik7Ci0JaWYoIWVycm9yKXsK
KwlpZiAoIWVycm9yKQogCQlnb3RvIHVubWFwX3BjaV9yZWdpb247Ci0JfQogCWVycm9yID0gYXJj
bXNyX2FsbG9jX2NjYl9wb29sKGFjYik7Ci0JaWYoZXJyb3IpeworCWlmIChlcnJvcikKIAkJZ290
byBmcmVlX2hiYl9tdTsKLQl9Ci0JYXJjbXNyX2lvcF9pbml0KGFjYik7CiAJZXJyb3IgPSBzY3Np
X2FkZF9ob3N0KGhvc3QsICZwZGV2LT5kZXYpOwotCWlmKGVycm9yKXsKKwlpZiAoZXJyb3IpCiAJ
CWdvdG8gUkFJRF9jb250cm9sbGVyX3N0b3A7Ci0JfQotCWVycm9yID0gcmVxdWVzdF9pcnEocGRl
di0+aXJxLCBhcmNtc3JfZG9faW50ZXJydXB0LCBJUlFGX1NIQVJFRCwgImFyY21zciIsIGFjYik7
Ci0JaWYoZXJyb3IpewotCQlnb3RvIHNjc2lfaG9zdF9yZW1vdmU7CisJaWYgKHBjaV9maW5kX2Nh
cGFiaWxpdHkocGRldiwgUENJX0NBUF9JRF9NU0lYKSkgeworCQlpZiAoIXBjaV9lbmFibGVfbXNp
eChwZGV2LCBlbnRyaWVzLCBBUkNNU1RfTlVNX01TSVhfVkVDVE9SUykpIHsKKwkJCWZvciAoaSA9
IDA7IGkgPCBBUkNNU1RfTlVNX01TSVhfVkVDVE9SUzsgaSsrKSB7CisJCQkJZW50cmllc1tpXS5l
bnRyeSA9IGk7CisJCQkJaWYgKHJlcXVlc3RfaXJxKGVudHJpZXNbaV0udmVjdG9yLAorCQkJCQlh
cmNtc3JfZG9faW50ZXJydXB0LCAwLCAiYXJjbXNyIiwKKwkJCQkJYWNiKSkgeworCQkJCQlmb3Ig
KGogPSAwIDsgaiA8IGkgOyBqKyspCisJCQkJCQlmcmVlX2lycShlbnRyaWVzW2ldLnZlY3RvciwK
KwkJCQkJCWFjYik7CisJCQkJCWdvdG8gc2NzaV9ob3N0X3JlbW92ZTsKKwkJCQl9CisJCQkJYWNi
LT5lbnRyaWVzW2ldID0gZW50cmllc1tpXTsKKwkJCX0KKwkJCWFjYi0+YWNiX2ZsYWdzIHw9IEFD
Ql9GX01TSVhfRU5BQkxFRDsKKwkJfSBlbHNlIHsKKwkJCWlmIChyZXF1ZXN0X2lycShwZGV2LT5p
cnEsIGFyY21zcl9kb19pbnRlcnJ1cHQsCisJCQkJSVJRRl9TSEFSRUQsICJhcmNtc3IiLCBhY2Ip
KSB7CisJCQkJcHJfd2FybigiYXJjbXNyJWQ6IHJlcXVlc3RfaXJxID0gJWQgZmFpbGVkIVxuIiwK
KwkJCQkJYWNiLT5ob3N0LT5ob3N0X25vLCBwZGV2LT5pcnEpOworCQkJCWdvdG8gc2NzaV9ob3N0
X3JlbW92ZTsKKwkJCX0KKwkJfQorCX0gZWxzZSBpZiAocGNpX2ZpbmRfY2FwYWJpbGl0eShwZGV2
LCBQQ0lfQ0FQX0lEX01TSSkpIHsKKwkJaWYgKCFwY2lfZW5hYmxlX21zaShwZGV2KSkKKwkJCWFj
Yi0+YWNiX2ZsYWdzIHw9IEFDQl9GX01TSV9FTkFCTEVEOworCQlpZiAocmVxdWVzdF9pcnEocGRl
di0+aXJxLCBhcmNtc3JfZG9faW50ZXJydXB0LAorCQkJSVJRRl9TSEFSRUQsICJhcmNtc3IiLCBh
Y2IpKSB7CisJCQlwcl93YXJuKCJhcmNtc3IlZDogcmVxdWVzdF9pcnEgPSVkIGZhaWxlZCFcbiIs
CisJCQkJYWNiLT5ob3N0LT5ob3N0X25vLCBwZGV2LT5pcnEpOworCQkJZ290byBzY3NpX2hvc3Rf
cmVtb3ZlOworCQl9CisJfSBlbHNlIHsKKwkJaWYgKHJlcXVlc3RfaXJxKHBkZXYtPmlycSwgYXJj
bXNyX2RvX2ludGVycnVwdCwKKwkJCUlSUUZfU0hBUkVELCAiYXJjbXNyIiwgYWNiKSkgeworCQkJ
cHJfd2FybigiYXJjbXNyJWQ6IHJlcXVlc3RfaXJxID0gJWQgZmFpbGVkIVxuIiwKKwkJCQlhY2It
Pmhvc3QtPmhvc3Rfbm8sIHBkZXYtPmlycSk7CisJCQlnb3RvIHNjc2lfaG9zdF9yZW1vdmU7CisJ
CX0KIAl9CiAJaG9zdC0+aXJxID0gcGRldi0+aXJxOwotICAgIAlzY3NpX3NjYW5faG9zdChob3N0
KTsKLQlJTklUX1dPUksoJmFjYi0+YXJjbXNyX2RvX21lc3NhZ2VfaXNyX2JoLCBhcmNtc3JfbWVz
c2FnZV9pc3JfYmhfZm4pOworCWFyY21zcl9pb3BfaW5pdChhY2IpOworCXNjc2lfc2Nhbl9ob3N0
KGhvc3QpOworCUlOSVRfV09SSygmYWNiLT5hcmNtc3JfZG9fbWVzc2FnZV9pc3JfYmgsCisJCWFy
Y21zcl9tZXNzYWdlX2lzcl9iaF9mbik7CiAJYXRvbWljX3NldCgmYWNiLT5ycV9tYXBfdG9rZW4s
IDE2KTsKIAlhdG9taWNfc2V0KCZhY2ItPmFudGVfdG9rZW5fdmFsdWUsIDE2KTsKIAlhY2ItPmZ3
X2ZsYWcgPSBGV19OT1JNQUw7CiAJaW5pdF90aW1lcigmYWNiLT5ldGVybmFsX3RpbWVyKTsKLQlh
Y2ItPmV0ZXJuYWxfdGltZXIuZXhwaXJlcyA9IGppZmZpZXMgKyBtc2Vjc190b19qaWZmaWVzKDYg
KiBIWik7CisJYWNiLT5ldGVybmFsX3RpbWVyLmV4cGlyZXMgPSBqaWZmaWVzICsKKwkJbXNlY3Nf
dG9famlmZmllcyg2ICogSFopOwogCWFjYi0+ZXRlcm5hbF90aW1lci5kYXRhID0gKHVuc2lnbmVk
IGxvbmcpIGFjYjsKLQlhY2ItPmV0ZXJuYWxfdGltZXIuZnVuY3Rpb24gPSAmYXJjbXNyX3JlcXVl
c3RfZGV2aWNlX21hcDsKKwlhY2ItPmV0ZXJuYWxfdGltZXIuZnVuY3Rpb24gPQorCQkmYXJjbXNy
X3JlcXVlc3RfZGV2aWNlX21hcDsKIAlhZGRfdGltZXIoJmFjYi0+ZXRlcm5hbF90aW1lcik7Ci0J
aWYoYXJjbXNyX2FsbG9jX3N5c2ZzX2F0dHIoYWNiKSkKKwlpZiAoYXJjbXNyX2FsbG9jX3N5c2Zz
X2F0dHIoYWNiKSkKIAkJZ290byBvdXRfZnJlZV9zeXNmczsKIAlyZXR1cm4gMDsKIG91dF9mcmVl
X3N5c2ZzOgogc2NzaV9ob3N0X3JlbW92ZToKKwlpZiAoYWNiLT5hY2JfZmxhZ3MgJiBBQ0JfRl9N
U0lfRU5BQkxFRCkKKwkJcGNpX2Rpc2FibGVfbXNpKHBkZXYpOworCWVsc2UgaWYgKGFjYi0+YWNi
X2ZsYWdzICYgQUNCX0ZfTVNJWF9FTkFCTEVEKQorCQlwY2lfZGlzYWJsZV9tc2l4KHBkZXYpOwog
CXNjc2lfcmVtb3ZlX2hvc3QoaG9zdCk7CiBSQUlEX2NvbnRyb2xsZXJfc3RvcDoKIAlhcmNtc3Jf
c3RvcF9hZGFwdGVyX2JncmIoYWNiKTsKIAlhcmNtc3JfZmx1c2hfYWRhcHRlcl9jYWNoZShhY2Ip
OwogCWFyY21zcl9mcmVlX2NjYl9wb29sKGFjYik7CiBmcmVlX2hiYl9tdToKLQlhcmNtc3JfZnJl
ZV9oYmJfbXUoYWNiKTsKKwlhcmNtc3JfZnJlZV9tdShhY2IpOwogdW5tYXBfcGNpX3JlZ2lvbjoK
IAlhcmNtc3JfdW5tYXBfcGNpcmVnaW9uKGFjYik7CiBwY2lfcmVsZWFzZV9yZWdzOgpAQCAtNzA5
LDg1ICsxMTAxLDExNCBAQCBwY2lfZGlzYWJsZV9kZXY6CiAJcmV0dXJuIC1FTk9ERVY7CiB9CiAK
LXN0YXRpYyB1aW50OF90IGFyY21zcl9hYm9ydF9oYmFfYWxsY21kKHN0cnVjdCBBZGFwdGVyQ29u
dHJvbEJsb2NrICphY2IpCitzdGF0aWMgdWludDhfdAorYXJjbXNyX2hiYUFfYWJvcnRfYWxsY21k
KHN0cnVjdCBBZGFwdGVyQ29udHJvbEJsb2NrICphY2IpCiB7CiAJc3RydWN0IE1lc3NhZ2VVbml0
X0EgX19pb21lbSAqcmVnID0gYWNiLT5wbXVBOwotCXdyaXRlbChBUkNNU1JfSU5CT1VORF9NRVNH
MF9BQk9SVF9DTUQsICZyZWctPmluYm91bmRfbXNnYWRkcjApOwotCWlmICghYXJjbXNyX2hiYV93
YWl0X21zZ2ludF9yZWFkeShhY2IpKSB7Ci0JCXByaW50ayhLRVJOX05PVElDRQotCQkJImFyY21z
ciVkOiB3YWl0ICdhYm9ydCBhbGwgb3V0c3RhbmRpbmcgY29tbWFuZCcgdGltZW91dCBcbiIKKwl3
cml0ZWwoQVJDTVNSX0lOQk9VTkRfTUVTRzBfQUJPUlRfQ01ELAorCQkmcmVnLT5pbmJvdW5kX21z
Z2FkZHIwKTsKKwlpZiAoIWFyY21zcl9oYmFBX3dhaXRfbXNnaW50X3JlYWR5KGFjYikpIHsKKwkJ
cHJfbm90aWNlKCJhcmNtc3IlZDogd2FpdCAnYWJvcnQgYWxsIG91dHN0YW5kaW5nICIKKwkJCSJj
b21tYW5kJyB0aW1lb3V0XG4iCiAJCQksIGFjYi0+aG9zdC0+aG9zdF9ubyk7CiAJCXJldHVybiBm
YWxzZTsKIAl9CiAJcmV0dXJuIHRydWU7CiB9CiAKLXN0YXRpYyB1aW50OF90IGFyY21zcl9hYm9y
dF9oYmJfYWxsY21kKHN0cnVjdCBBZGFwdGVyQ29udHJvbEJsb2NrICphY2IpCitzdGF0aWMgdWlu
dDhfdAorYXJjbXNyX2hiYUJfYWJvcnRfYWxsY21kKHN0cnVjdCBBZGFwdGVyQ29udHJvbEJsb2Nr
ICphY2IpCiB7Ci0Jc3RydWN0IE1lc3NhZ2VVbml0X0IgKnJlZyA9IGFjYi0+cG11QjsKKwlzdHJ1
Y3QgTWVzc2FnZVVuaXRfQiBfX2lvbWVtICpyZWcgPSBhY2ItPnBtdUI7CiAKLQl3cml0ZWwoQVJD
TVNSX01FU1NBR0VfQUJPUlRfQ01ELCByZWctPmRydjJpb3BfZG9vcmJlbGwpOwotCWlmICghYXJj
bXNyX2hiYl93YWl0X21zZ2ludF9yZWFkeShhY2IpKSB7Ci0JCXByaW50ayhLRVJOX05PVElDRQot
CQkJImFyY21zciVkOiB3YWl0ICdhYm9ydCBhbGwgb3V0c3RhbmRpbmcgY29tbWFuZCcgdGltZW91
dCBcbiIKKwl3cml0ZWwoQVJDTVNSX01FU1NBR0VfQUJPUlRfQ01ELAorCQlyZWctPmRydjJpb3Bf
ZG9vcmJlbGwpOworCWlmICghYXJjbXNyX2hiYUJfd2FpdF9tc2dpbnRfcmVhZHkoYWNiKSkgewor
CQlwcl9ub3RpY2UoImFyY21zciVkOiB3YWl0ICdhYm9ydCBhbGwgb3V0c3RhbmRpbmcgIgorCQkJ
ImNvbW1hbmQnIHRpbWVvdXRcbiIKIAkJCSwgYWNiLT5ob3N0LT5ob3N0X25vKTsKIAkJcmV0dXJu
IGZhbHNlOwogCX0KIAlyZXR1cm4gdHJ1ZTsKIH0KLXN0YXRpYyB1aW50OF90IGFyY21zcl9hYm9y
dF9oYmNfYWxsY21kKHN0cnVjdCBBZGFwdGVyQ29udHJvbEJsb2NrICpwQUNCKQorc3RhdGljIHVp
bnQ4X3QKK2FyY21zcl9oYmFDX2Fib3J0X2FsbGNtZChzdHJ1Y3QgQWRhcHRlckNvbnRyb2xCbG9j
ayAqcEFDQikKIHsKLQlzdHJ1Y3QgTWVzc2FnZVVuaXRfQyAqcmVnID0gKHN0cnVjdCBNZXNzYWdl
VW5pdF9DICopcEFDQi0+cG11QzsKKwlzdHJ1Y3QgTWVzc2FnZVVuaXRfQyBfX2lvbWVtICpyZWcg
PSBwQUNCLT5wbXVDOwogCXdyaXRlbChBUkNNU1JfSU5CT1VORF9NRVNHMF9BQk9SVF9DTUQsICZy
ZWctPmluYm91bmRfbXNnYWRkcjApOwogCXdyaXRlbChBUkNNU1JfSEJDTVVfRFJWMklPUF9NRVNT
QUdFX0NNRF9ET05FLCAmcmVnLT5pbmJvdW5kX2Rvb3JiZWxsKTsKLQlpZiAoIWFyY21zcl9oYmNf
d2FpdF9tc2dpbnRfcmVhZHkocEFDQikpIHsKLQkJcHJpbnRrKEtFUk5fTk9USUNFCi0JCQkiYXJj
bXNyJWQ6IHdhaXQgJ2Fib3J0IGFsbCBvdXRzdGFuZGluZyBjb21tYW5kJyB0aW1lb3V0IFxuIgor
CWlmICghYXJjbXNyX2hiYUNfd2FpdF9tc2dpbnRfcmVhZHkocEFDQikpIHsKKwkJcHJfbm90aWNl
KCJhcmNtc3IlZDogd2FpdCAnYWJvcnQgYWxsIG91dHN0YW5kaW5nICIKKwkJCSJjb21tYW5kJyB0
aW1lb3V0XG4iCisJCQksIHBBQ0ItPmhvc3QtPmhvc3Rfbm8pOworCQlyZXR1cm4gZmFsc2U7CisJ
fQorCXJldHVybiB0cnVlOworfQorc3RhdGljIHVpbnQ4X3QKK2FyY21zcl9oYmFEX2Fib3J0X2Fs
bGNtZChzdHJ1Y3QgQWRhcHRlckNvbnRyb2xCbG9jayAqcEFDQikKK3sKKwlzdHJ1Y3QgTWVzc2Fn
ZVVuaXRfRCBfX2lvbWVtICpyZWcgPSBwQUNCLT5wbXVEOworCXdyaXRlbChBUkNNU1JfSU5CT1VO
RF9NRVNHMF9BQk9SVF9DTUQsIHJlZy0+aW5ib3VuZF9tc2dhZGRyMCk7CisJaWYgKCFhcmNtc3Jf
aGJhRF93YWl0X21zZ2ludF9yZWFkeShwQUNCKSkgeworCQlwcl9ub3RpY2UoImFyY21zciVkOiB3
YWl0ICdhYm9ydCBhbGwgb3V0c3RhbmRpbmcgIgorCQkJImNvbW1hbmQnIHRpbWVvdXRcbiIKIAkJ
CSwgcEFDQi0+aG9zdC0+aG9zdF9ubyk7CiAJCXJldHVybiBmYWxzZTsKIAl9CiAJcmV0dXJuIHRy
dWU7CiB9Ci1zdGF0aWMgdWludDhfdCBhcmNtc3JfYWJvcnRfYWxsY21kKHN0cnVjdCBBZGFwdGVy
Q29udHJvbEJsb2NrICphY2IpCitzdGF0aWMgdWludDhfdAorYXJjbXNyX2Fib3J0X2FsbGNtZChz
dHJ1Y3QgQWRhcHRlckNvbnRyb2xCbG9jayAqYWNiKQogewogCXVpbnQ4X3QgcnRudmFsID0gMDsK
IAlzd2l0Y2ggKGFjYi0+YWRhcHRlcl90eXBlKSB7CiAJY2FzZSBBQ0JfQURBUFRFUl9UWVBFX0E6
IHsKLQkJcnRudmFsID0gYXJjbXNyX2Fib3J0X2hiYV9hbGxjbWQoYWNiKTsKLQkJfQorCQlydG52
YWwgPSBhcmNtc3JfaGJhQV9hYm9ydF9hbGxjbWQoYWNiKTsKIAkJYnJlYWs7CisJCX0KIAogCWNh
c2UgQUNCX0FEQVBURVJfVFlQRV9COiB7Ci0JCXJ0bnZhbCA9IGFyY21zcl9hYm9ydF9oYmJfYWxs
Y21kKGFjYik7Ci0JCX0KKwkJcnRudmFsID0gYXJjbXNyX2hiYUJfYWJvcnRfYWxsY21kKGFjYik7
CiAJCWJyZWFrOworCQl9CiAKIAljYXNlIEFDQl9BREFQVEVSX1RZUEVfQzogewotCQlydG52YWwg
PSBhcmNtc3JfYWJvcnRfaGJjX2FsbGNtZChhY2IpOworCQlydG52YWwgPSBhcmNtc3JfaGJhQ19h
Ym9ydF9hbGxjbWQoYWNiKTsKKwkJYnJlYWs7CisJCX0KKworCWNhc2UgQUNCX0FEQVBURVJfVFlQ
RV9EOiB7CisJCXJ0bnZhbCA9IGFyY21zcl9oYmFEX2Fib3J0X2FsbGNtZChhY2IpOworCQlicmVh
azsKIAkJfQogCX0KIAlyZXR1cm4gcnRudmFsOwogfQogCi1zdGF0aWMgYm9vbCBhcmNtc3JfaGJi
X2VuYWJsZV9kcml2ZXJfbW9kZShzdHJ1Y3QgQWRhcHRlckNvbnRyb2xCbG9jayAqcGFjYikKK3N0
YXRpYyBib29sCithcmNtc3JfaGJiX2VuYWJsZV9kcml2ZXJfbW9kZShzdHJ1Y3QgQWRhcHRlckNv
bnRyb2xCbG9jayAqcGFjYikKIHsKLQlzdHJ1Y3QgTWVzc2FnZVVuaXRfQiAqcmVnID0gcGFjYi0+
cG11QjsKLQl3cml0ZWwoQVJDTVNSX01FU1NBR0VfU1RBUlRfRFJJVkVSX01PREUsIHJlZy0+ZHJ2
MmlvcF9kb29yYmVsbCk7Ci0JaWYgKCFhcmNtc3JfaGJiX3dhaXRfbXNnaW50X3JlYWR5KHBhY2Ip
KSB7Ci0JCXByaW50ayhLRVJOX0VSUiAiYXJjbXNyJWQ6IGNhbid0IHNldCBkcml2ZXIgbW9kZS4g
XG4iLCBwYWNiLT5ob3N0LT5ob3N0X25vKTsKKwlzdHJ1Y3QgTWVzc2FnZVVuaXRfQiBfX2lvbWVt
ICpyZWcgPSBwYWNiLT5wbXVCOworCXdyaXRlbChBUkNNU1JfTUVTU0FHRV9TVEFSVF9EUklWRVJf
TU9ERSwKKwkJcmVnLT5kcnYyaW9wX2Rvb3JiZWxsKTsKKwlpZiAoIWFyY21zcl9oYmFCX3dhaXRf
bXNnaW50X3JlYWR5KHBhY2IpKSB7CisJCXByX2VycigiYXJjbXNyJWQ6IGNhbid0IHNldCBkcml2
ZXIgbW9kZS5cbiIsCisJCQlwYWNiLT5ob3N0LT5ob3N0X25vKTsKIAkJcmV0dXJuIGZhbHNlOwog
CX0KICAgICAJcmV0dXJuIHRydWU7CiB9CiAKLXN0YXRpYyB2b2lkIGFyY21zcl9wY2lfdW5tYXBf
ZG1hKHN0cnVjdCBDb21tYW5kQ29udHJvbEJsb2NrICpjY2IpCitzdGF0aWMgdm9pZAorYXJjbXNy
X3BjaV91bm1hcF9kbWEoc3RydWN0IENvbW1hbmRDb250cm9sQmxvY2sgKmNjYikKIHsKIAlzdHJ1
Y3Qgc2NzaV9jbW5kICpwY21kID0gY2NiLT5wY21kOwotCiAJc2NzaV9kbWFfdW5tYXAocGNtZCk7
CiB9CiAKLXN0YXRpYyB2b2lkIGFyY21zcl9jY2JfY29tcGxldGUoc3RydWN0IENvbW1hbmRDb250
cm9sQmxvY2sgKmNjYikKK3N0YXRpYyB2b2lkCithcmNtc3JfY2NiX2NvbXBsZXRlKHN0cnVjdCBD
b21tYW5kQ29udHJvbEJsb2NrICpjY2IpCiB7CiAJc3RydWN0IEFkYXB0ZXJDb250cm9sQmxvY2sg
KmFjYiA9IGNjYi0+YWNiOwogCXN0cnVjdCBzY3NpX2NtbmQgKnBjbWQgPSBjY2ItPnBjbWQ7CkBA
IC04MDEsNTIgKzEyMjIsNjggQEAgc3RhdGljIHZvaWQgYXJjbXNyX2NjYl9jb21wbGV0ZShzdHJ1
Y3QgQwogCXBjbWQtPnNjc2lfZG9uZShwY21kKTsKIH0KIAotc3RhdGljIHZvaWQgYXJjbXNyX3Jl
cG9ydF9zZW5zZV9pbmZvKHN0cnVjdCBDb21tYW5kQ29udHJvbEJsb2NrICpjY2IpCitzdGF0aWMg
dm9pZAorYXJjbXNyX3JlcG9ydF9zZW5zZV9pbmZvKHN0cnVjdCBDb21tYW5kQ29udHJvbEJsb2Nr
ICpjY2IpCiB7CiAKIAlzdHJ1Y3Qgc2NzaV9jbW5kICpwY21kID0gY2NiLT5wY21kOwotCXN0cnVj
dCBTRU5TRV9EQVRBICpzZW5zZWJ1ZmZlciA9IChzdHJ1Y3QgU0VOU0VfREFUQSAqKXBjbWQtPnNl
bnNlX2J1ZmZlcjsKLQlwY21kLT5yZXN1bHQgPSBESURfT0sgPDwgMTY7CisJc3RydWN0IFNFTlNF
X0RBVEEgKnNlbnNlYnVmZmVyID0KKwkJKHN0cnVjdCBTRU5TRV9EQVRBICopcGNtZC0+c2Vuc2Vf
YnVmZmVyOworCXBjbWQtPnJlc3VsdCA9IChESURfT0sgPDwgMTYpIHwgKENIRUNLX0NPTkRJVElP
TiA8PCAxKQorCQl8IChEUklWRVJfU0VOU0UgPDwgMjQpOwogCWlmIChzZW5zZWJ1ZmZlcikgewog
CQlpbnQgc2Vuc2VfZGF0YV9sZW5ndGggPQogCQkJc2l6ZW9mKHN0cnVjdCBTRU5TRV9EQVRBKSA8
IFNDU0lfU0VOU0VfQlVGRkVSU0laRQogCQkJPyBzaXplb2Yoc3RydWN0IFNFTlNFX0RBVEEpIDog
U0NTSV9TRU5TRV9CVUZGRVJTSVpFOwogCQltZW1zZXQoc2Vuc2VidWZmZXIsIDAsIFNDU0lfU0VO
U0VfQlVGRkVSU0laRSk7Ci0JCW1lbWNweShzZW5zZWJ1ZmZlciwgY2NiLT5hcmNtc3JfY2RiLlNl
bnNlRGF0YSwgc2Vuc2VfZGF0YV9sZW5ndGgpOworCQltZW1jcHkoKHZvaWQgKilzZW5zZWJ1ZmZl
ciwgKGNvbnN0IHZvaWQgKiljY2ItPmFyY21zcl9jZGIuU2Vuc2VEYXRhLAorCQkJc2Vuc2VfZGF0
YV9sZW5ndGgpOwogCQlzZW5zZWJ1ZmZlci0+RXJyb3JDb2RlID0gU0NTSV9TRU5TRV9DVVJSRU5U
X0VSUk9SUzsKIAkJc2Vuc2VidWZmZXItPlZhbGlkID0gMTsKIAl9CiB9CiAKLXN0YXRpYyB1MzIg
YXJjbXNyX2Rpc2FibGVfb3V0Ym91bmRfaW50cyhzdHJ1Y3QgQWRhcHRlckNvbnRyb2xCbG9jayAq
YWNiKQorc3RhdGljIHUzMgorYXJjbXNyX2Rpc2FibGVfb3V0Ym91bmRfaW50cyhzdHJ1Y3QgQWRh
cHRlckNvbnRyb2xCbG9jayAqYWNiKQogewogCXUzMiBvcmlnX21hc2sgPSAwOwogCXN3aXRjaCAo
YWNiLT5hZGFwdGVyX3R5cGUpIHsJCiAJY2FzZSBBQ0JfQURBUFRFUl9UWVBFX0EgOiB7CiAJCXN0
cnVjdCBNZXNzYWdlVW5pdF9BIF9faW9tZW0gKnJlZyA9IGFjYi0+cG11QTsKIAkJb3JpZ19tYXNr
ID0gcmVhZGwoJnJlZy0+b3V0Ym91bmRfaW50bWFzayk7Ci0JCXdyaXRlbChvcmlnX21hc2t8QVJD
TVNSX01VX09VVEJPVU5EX0FMTF9JTlRNQVNLRU5BQkxFLCBcCi0JCQkJCQkmcmVnLT5vdXRib3Vu
ZF9pbnRtYXNrKTsKKwkJd3JpdGVsKG9yaWdfbWFzayB8CisJCQlBUkNNU1JfTVVfT1VUQk9VTkRf
QUxMX0lOVE1BU0tFTkFCTEUsCisJCQkmcmVnLT5vdXRib3VuZF9pbnRtYXNrKTsKIAkJfQogCQli
cmVhazsKIAljYXNlIEFDQl9BREFQVEVSX1RZUEVfQiA6IHsKLQkJc3RydWN0IE1lc3NhZ2VVbml0
X0IgKnJlZyA9IGFjYi0+cG11QjsKKwkJc3RydWN0IE1lc3NhZ2VVbml0X0IgX19pb21lbSAqcmVn
ID0gYWNiLT5wbXVCOwogCQlvcmlnX21hc2sgPSByZWFkbChyZWctPmlvcDJkcnZfZG9vcmJlbGxf
bWFzayk7CiAJCXdyaXRlbCgwLCByZWctPmlvcDJkcnZfZG9vcmJlbGxfbWFzayk7CiAJCX0KIAkJ
YnJlYWs7Ci0JY2FzZSBBQ0JfQURBUFRFUl9UWVBFX0M6ewotCQlzdHJ1Y3QgTWVzc2FnZVVuaXRf
QyAqcmVnID0gKHN0cnVjdCBNZXNzYWdlVW5pdF9DICopYWNiLT5wbXVDOworCWNhc2UgQUNCX0FE
QVBURVJfVFlQRV9DOiB7CisJCXN0cnVjdCBNZXNzYWdlVW5pdF9DIF9faW9tZW0gKnJlZyA9IGFj
Yi0+cG11QzsKIAkJLyogZGlzYWJsZSBhbGwgb3V0Ym91bmQgaW50ZXJydXB0ICovCi0JCW9yaWdf
bWFzayA9IHJlYWRsKCZyZWctPmhvc3RfaW50X21hc2spOyAvKiBkaXNhYmxlIG91dGJvdW5kIG1l
c3NhZ2UwIGludCAqLwotCQl3cml0ZWwob3JpZ19tYXNrfEFSQ01TUl9IQkNNVV9BTExfSU5UTUFT
S0VOQUJMRSwgJnJlZy0+aG9zdF9pbnRfbWFzayk7CisJCW9yaWdfbWFzayA9IHJlYWRsKCZyZWct
Pmhvc3RfaW50X21hc2spOworCQl3cml0ZWwob3JpZ19tYXNrIHwgQVJDTVNSX0hCQ01VX0FMTF9J
TlRNQVNLRU5BQkxFLAorCQkJJnJlZy0+aG9zdF9pbnRfbWFzayk7CisJCXJlYWRsKCZyZWctPmhv
c3RfaW50X21hc2spOwogCQl9CiAJCWJyZWFrOworCWNhc2UgQUNCX0FEQVBURVJfVFlQRV9EOiB7
CisJCXN0cnVjdCBNZXNzYWdlVW5pdF9EIF9faW9tZW0gKnJlZyA9IGFjYi0+cG11RDsKKwkJLyog
ZGlzYWJsZSBhbGwgb3V0Ym91bmQgaW50ZXJydXB0ICovCisJCXdyaXRlbChBUkNNU1JfQVJDMTIx
NF9BTExfSU5UX0RJU0FCTEUsCisJCQlyZWctPnBjaWVmMF9pbnRfZW5hYmxlKTsKKwkJYnJlYWs7
CisJfQogCX0KIAlyZXR1cm4gb3JpZ19tYXNrOwogfQogCi1zdGF0aWMgdm9pZCBhcmNtc3JfcmVw
b3J0X2NjYl9zdGF0ZShzdHJ1Y3QgQWRhcHRlckNvbnRyb2xCbG9jayAqYWNiLCAKK3N0YXRpYyB2
b2lkCithcmNtc3JfcmVwb3J0X2NjYl9zdGF0ZShzdHJ1Y3QgQWRhcHRlckNvbnRyb2xCbG9jayAq
YWNiLAogCQkJc3RydWN0IENvbW1hbmRDb250cm9sQmxvY2sgKmNjYiwgYm9vbCBlcnJvcikKIHsK
IAl1aW50OF90IGlkLCBsdW47CkBAIC04NTcsNyArMTI5NCw3IEBAIHN0YXRpYyB2b2lkIGFyY21z
cl9yZXBvcnRfY2NiX3N0YXRlKHN0cnUKIAkJCWFjYi0+ZGV2c3RhdGVbaWRdW2x1bl0gPSBBUkVD
QV9SQUlEX0dPT0Q7CiAJCWNjYi0+cGNtZC0+cmVzdWx0ID0gRElEX09LIDw8IDE2OwogCQlhcmNt
c3JfY2NiX2NvbXBsZXRlKGNjYik7Ci0JfWVsc2V7CisJfSBlbHNlIHsKIAkJc3dpdGNoIChjY2It
PmFyY21zcl9jZGIuRGV2aWNlU3RhdHVzKSB7CiAJCWNhc2UgQVJDTVNSX0RFVl9TRUxFQ1RfVElN
RU9VVDogewogCQkJYWNiLT5kZXZzdGF0ZVtpZF1bbHVuXSA9IEFSRUNBX1JBSURfR09ORTsKQEAg
LTg4Myw1MyArMTMyMCw0NSBAQCBzdGF0aWMgdm9pZCBhcmNtc3JfcmVwb3J0X2NjYl9zdGF0ZShz
dHJ1CiAJCQlicmVhazsKIAogCQlkZWZhdWx0OgotCQkJcHJpbnRrKEtFUk5fTk9USUNFCi0JCQkJ
ImFyY21zciVkOiBzY3NpIGlkID0gJWQgbHVuID0gJWQgaXNyIGdldCBjb21tYW5kIGVycm9yIGRv
bmUsIFwKLQkJCQlidXQgZ290IHVua25vd24gRGV2aWNlU3RhdHVzID0gMHgleCBcbiIKLQkJCQks
IGFjYi0+aG9zdC0+aG9zdF9ubwotCQkJCSwgaWQKLQkJCQksIGx1bgorCQkJcHJfbm90aWNlKCJh
cmNtc3IlZDogc2NzaSBpZCA9ICVkIGx1biA9ICVkICIKKwkJCQkiaXNyIGdldCBjb21tYW5kIGVy
cm9yIGRvbmUsIGJ1dCBnb3QgdW5rbm93biAiCisJCQkJIkRldmljZVN0YXR1cyA9IDB4JXhcbiIK
KwkJCQksIGFjYi0+aG9zdC0+aG9zdF9ubywgaWQsIGx1bgogCQkJCSwgY2NiLT5hcmNtc3JfY2Ri
LkRldmljZVN0YXR1cyk7Ci0JCQkJYWNiLT5kZXZzdGF0ZVtpZF1bbHVuXSA9IEFSRUNBX1JBSURf
R09ORTsKLQkJCQljY2ItPnBjbWQtPnJlc3VsdCA9IERJRF9OT19DT05ORUNUIDw8IDE2OwotCQkJ
CWFyY21zcl9jY2JfY29tcGxldGUoY2NiKTsKKwkJCWFjYi0+ZGV2c3RhdGVbaWRdW2x1bl0gPSBB
UkVDQV9SQUlEX0dPTkU7CisJCQljY2ItPnBjbWQtPnJlc3VsdCA9IERJRF9OT19DT05ORUNUIDw8
IDE2OworCQkJYXJjbXNyX2NjYl9jb21wbGV0ZShjY2IpOwogCQkJYnJlYWs7CiAJCX0KIAl9CiB9
CiAKLXN0YXRpYyB2b2lkIGFyY21zcl9kcmFpbl9kb25lcXVldWUoc3RydWN0IEFkYXB0ZXJDb250
cm9sQmxvY2sgKmFjYiwgc3RydWN0IENvbW1hbmRDb250cm9sQmxvY2sgKnBDQ0IsIGJvb2wgZXJy
b3IpCitzdGF0aWMgdm9pZAorYXJjbXNyX2RyYWluX2RvbmVxdWV1ZShzdHJ1Y3QgQWRhcHRlckNv
bnRyb2xCbG9jayAqYWNiLAorCXN0cnVjdCBDb21tYW5kQ29udHJvbEJsb2NrICpwQ0NCLCBib29s
IGVycm9yKQogewotCWludCBpZCwgbHVuOwogCWlmICgocENDQi0+YWNiICE9IGFjYikgfHwgKHBD
Q0ItPnN0YXJ0ZG9uZSAhPSBBUkNNU1JfQ0NCX1NUQVJUKSkgewotCQlpZiAocENDQi0+c3RhcnRk
b25lID09IEFSQ01TUl9DQ0JfQUJPUlRFRCkgewotCQkJc3RydWN0IHNjc2lfY21uZCAqYWJvcnRj
bWQgPSBwQ0NCLT5wY21kOwotCQkJaWYgKGFib3J0Y21kKSB7Ci0JCQkJaWQgPSBhYm9ydGNtZC0+
ZGV2aWNlLT5pZDsKLQkJCQlsdW4gPSBhYm9ydGNtZC0+ZGV2aWNlLT5sdW47CQkJCQotCQkJCWFi
b3J0Y21kLT5yZXN1bHQgfD0gRElEX0FCT1JUIDw8IDE2OwotCQkJCWFyY21zcl9jY2JfY29tcGxl
dGUocENDQik7Ci0JCQkJcHJpbnRrKEtFUk5fTk9USUNFICJhcmNtc3IlZDogcENDQiA9JzB4JXAn
IGlzciBnb3QgYWJvcnRlZCBjb21tYW5kIFxuIiwKLQkJCQlhY2ItPmhvc3QtPmhvc3Rfbm8sIHBD
Q0IpOwotCQkJfQotCQkJcmV0dXJuOwotCQl9Ci0JCXByaW50ayhLRVJOX05PVElDRSAiYXJjbXNy
JWQ6IGlzciBnZXQgYW4gaWxsZWdhbCBjY2IgY29tbWFuZCBcCi0JCQkJZG9uZSBhY2IgPSAnMHgl
cCciCi0JCQkJImNjYiA9ICcweCVwJyBjY2JhY2IgPSAnMHglcCcgc3RhcnRkb25lID0gMHgleCIK
LQkJCQkiIGNjYm91dHN0YW5kaW5nY291bnQgPSAlZCBcbiIKLQkJCQksIGFjYi0+aG9zdC0+aG9z
dF9ubwotCQkJCSwgYWNiCi0JCQkJLCBwQ0NCCi0JCQkJLCBwQ0NCLT5hY2IKLQkJCQksIHBDQ0It
PnN0YXJ0ZG9uZQotCQkJCSwgYXRvbWljX3JlYWQoJmFjYi0+Y2Nib3V0c3RhbmRpbmdjb3VudCkp
OwotCQkgIHJldHVybjsKKwkJcHJfbm90aWNlKCJhcmNtc3IlZDogaXNyIGdldCBhbiBpbGxlZ2Fs
IGNjYiAiCisJCQkiY29tbWFuZCBkb25lIGFjYiA9IDB4JXAsICIKKwkJCSJjY2IgPSAweCVwLCAi
CisJCQkiY2NiYWNiID0gMHglcCwgIgorCQkJInN0YXJ0ZG9uZSA9IDB4JXgsICIKKwkJCSJwc2Nz
aV9jbWQgPSAweCVwLCAiCisJCQkiY2Nib3V0c3RhbmRpbmdjb3VudCA9ICVkXG4iCisJCQksIGFj
Yi0+aG9zdC0+aG9zdF9ubworCQkJLCBhY2IKKwkJCSwgcENDQgorCQkJLCBwQ0NCLT5hY2IKKwkJ
CSwgcENDQi0+c3RhcnRkb25lCisJCQksIHBDQ0ItPnBjbWQKKwkJCSwgYXRvbWljX3JlYWQoJmFj
Yi0+Y2Nib3V0c3RhbmRpbmdjb3VudCkpOworCQlyZXR1cm47CiAJfQogCWFyY21zcl9yZXBvcnRf
Y2NiX3N0YXRlKGFjYiwgcENDQiwgZXJyb3IpOwogfQogCi1zdGF0aWMgdm9pZCBhcmNtc3JfZG9u
ZTRhYm9ydF9wb3N0cXVldWUoc3RydWN0IEFkYXB0ZXJDb250cm9sQmxvY2sgKmFjYikKK3N0YXRp
YyB2b2lkCithcmNtc3JfZG9uZTRhYm9ydF9wb3N0cXVldWUoc3RydWN0IEFkYXB0ZXJDb250cm9s
QmxvY2sgKmFjYikKIHsKIAlpbnQgaSA9IDA7CiAJdWludDMyX3QgZmxhZ19jY2I7CkBAIC05NDQs
MjcgKzEzNzMsMzYgQEAgc3RhdGljIHZvaWQgYXJjbXNyX2RvbmU0YWJvcnRfcG9zdHF1ZXVlKAog
CQlvdXRib3VuZF9pbnRzdGF0dXMgPSByZWFkbCgmcmVnLT5vdXRib3VuZF9pbnRzdGF0dXMpICYK
IAkJCQkJYWNiLT5vdXRib3VuZF9pbnRfZW5hYmxlOwogCQkvKmNsZWFyIGFuZCBhYm9ydCBhbGwg
b3V0Ym91bmQgcG9zdGVkIFEqLwotCQl3cml0ZWwob3V0Ym91bmRfaW50c3RhdHVzLCAmcmVnLT5v
dXRib3VuZF9pbnRzdGF0dXMpOy8qY2xlYXIgaW50ZXJydXB0Ki8KLQkJd2hpbGUoKChmbGFnX2Nj
YiA9IHJlYWRsKCZyZWctPm91dGJvdW5kX3F1ZXVlcG9ydCkpICE9IDB4RkZGRkZGRkYpCi0JCQkJ
JiYgKGkrKyA8IEFSQ01TUl9NQVhfT1VUU1RBTkRJTkdfQ01EKSkgewotCQkJcEFSQ01TUl9DREIg
PSAoc3RydWN0IEFSQ01TUl9DREIgKikoYWNiLT52aXIycGh5X29mZnNldCArIChmbGFnX2NjYiA8
PCA1KSk7LypmcmFtZSBtdXN0IGJlIDMyIGJ5dGVzIGFsaWduZWQqLwotCQkJcENDQiA9IGNvbnRh
aW5lcl9vZihwQVJDTVNSX0NEQiwgc3RydWN0IENvbW1hbmRDb250cm9sQmxvY2ssIGFyY21zcl9j
ZGIpOwotCQkJZXJyb3IgPSAoZmxhZ19jY2IgJiBBUkNNU1JfQ0NCUkVQTFlfRkxBR19FUlJPUl9N
T0RFMCkgPyB0cnVlIDogZmFsc2U7CisJCXdyaXRlbChvdXRib3VuZF9pbnRzdGF0dXMsICZyZWct
Pm91dGJvdW5kX2ludHN0YXR1cyk7CisJCXdoaWxlICgoKGZsYWdfY2NiID0gcmVhZGwoJnJlZy0+
b3V0Ym91bmRfcXVldWVwb3J0KSkKKwkJCSE9IDB4RkZGRkZGRkYpCisJCQkmJiAoaSsrIDwgQVJD
TVNSX01BWF9PVVRTVEFORElOR19DTUQpKSB7CisJCQlwQVJDTVNSX0NEQiA9IChzdHJ1Y3QgQVJD
TVNSX0NEQiAqKQorCQkJCShhY2ItPnZpcjJwaHlfb2Zmc2V0ICsgKGZsYWdfY2NiIDw8IDUpKTsK
KwkJCXBDQ0IgPSBjb250YWluZXJfb2YocEFSQ01TUl9DREIsCisJCQlzdHJ1Y3QgQ29tbWFuZENv
bnRyb2xCbG9jaywgYXJjbXNyX2NkYik7CisJCQllcnJvciA9IChmbGFnX2NjYiAmIEFSQ01TUl9D
Q0JSRVBMWV9GTEFHX0VSUk9SX01PREUwKSA/CisJCQkJdHJ1ZSA6IGZhbHNlOwogCQkJYXJjbXNy
X2RyYWluX2RvbmVxdWV1ZShhY2IsIHBDQ0IsIGVycm9yKTsKIAkJfQogCQl9CiAJCWJyZWFrOwog
CiAJY2FzZSBBQ0JfQURBUFRFUl9UWVBFX0I6IHsKLQkJc3RydWN0IE1lc3NhZ2VVbml0X0IgKnJl
ZyA9IGFjYi0+cG11QjsKLQkJLypjbGVhciBhbGwgb3V0Ym91bmQgcG9zdGVkIFEqLwotCQl3cml0
ZWwoQVJDTVNSX0RPT1JCRUxMX0lOVF9DTEVBUl9QQVRURVJOLCByZWctPmlvcDJkcnZfZG9vcmJl
bGwpOyAvKiBjbGVhciBkb29yYmVsbCBpbnRlcnJ1cHQgKi8KKwkJc3RydWN0IE1lc3NhZ2VVbml0
X0IgX19pb21lbSAqcmVnID0gYWNiLT5wbXVCOworCQl3cml0ZWwoQVJDTVNSX0RPT1JCRUxMX0lO
VF9DTEVBUl9QQVRURVJOLAorCQkJcmVnLT5pb3AyZHJ2X2Rvb3JiZWxsKTsKIAkJZm9yIChpID0g
MDsgaSA8IEFSQ01TUl9NQVhfSEJCX1BPU1RRVUVVRTsgaSsrKSB7Ci0JCQlpZiAoKGZsYWdfY2Ni
ID0gcmVhZGwoJnJlZy0+ZG9uZV9xYnVmZmVyW2ldKSkgIT0gMCkgeworCQkJZmxhZ19jY2IgPSBy
ZWFkbCgmcmVnLT5kb25lX3FidWZmZXJbaV0pOworCQkJaWYgKGZsYWdfY2NiICE9IDApIHsKIAkJ
CQl3cml0ZWwoMCwgJnJlZy0+ZG9uZV9xYnVmZmVyW2ldKTsKLQkJCQlwQVJDTVNSX0NEQiA9IChz
dHJ1Y3QgQVJDTVNSX0NEQiAqKShhY2ItPnZpcjJwaHlfb2Zmc2V0KyhmbGFnX2NjYiA8PCA1KSk7
LypmcmFtZSBtdXN0IGJlIDMyIGJ5dGVzIGFsaWduZWQqLwotCQkJCXBDQ0IgPSBjb250YWluZXJf
b2YocEFSQ01TUl9DREIsIHN0cnVjdCBDb21tYW5kQ29udHJvbEJsb2NrLCBhcmNtc3JfY2RiKTsK
LQkJCQllcnJvciA9IChmbGFnX2NjYiAmIEFSQ01TUl9DQ0JSRVBMWV9GTEFHX0VSUk9SX01PREUw
KSA/IHRydWUgOiBmYWxzZTsKKwkJCQlwQVJDTVNSX0NEQiA9IChzdHJ1Y3QgQVJDTVNSX0NEQiAq
KQorCQkJCQkoYWNiLT52aXIycGh5X29mZnNldCArIChmbGFnX2NjYiA8PCA1KSk7CisJCQkJcEND
QiA9IGNvbnRhaW5lcl9vZihwQVJDTVNSX0NEQiwKKwkJCQkJc3RydWN0IENvbW1hbmRDb250cm9s
QmxvY2ssIGFyY21zcl9jZGIpOworCQkJCWVycm9yID0gKGZsYWdfY2NiICYKKwkJCQkJQVJDTVNS
X0NDQlJFUExZX0ZMQUdfRVJST1JfTU9ERTApID8KKwkJCQkJdHJ1ZSA6IGZhbHNlOwogCQkJCWFy
Y21zcl9kcmFpbl9kb25lcXVldWUoYWNiLCBwQ0NCLCBlcnJvcik7CiAJCQl9CiAJCQlyZWctPnBv
c3RfcWJ1ZmZlcltpXSA9IDA7CkBAIC05NzQsMjkgKzE0MTIsODcgQEAgc3RhdGljIHZvaWQgYXJj
bXNyX2RvbmU0YWJvcnRfcG9zdHF1ZXVlKAogCQl9CiAJCWJyZWFrOwogCWNhc2UgQUNCX0FEQVBU
RVJfVFlQRV9DOiB7Ci0JCXN0cnVjdCBNZXNzYWdlVW5pdF9DICpyZWcgPSBhY2ItPnBtdUM7CisJ
CXN0cnVjdCBNZXNzYWdlVW5pdF9DIF9faW9tZW0gKnJlZyA9IGFjYi0+cG11QzsKIAkJc3RydWN0
ICBBUkNNU1JfQ0RCICpwQVJDTVNSX0NEQjsKIAkJdWludDMyX3QgZmxhZ19jY2IsIGNjYl9jZGJf
cGh5OwogCQlib29sIGVycm9yOwogCQlzdHJ1Y3QgQ29tbWFuZENvbnRyb2xCbG9jayAqcENDQjsK
LQkJd2hpbGUgKChyZWFkbCgmcmVnLT5ob3N0X2ludF9zdGF0dXMpICYgQVJDTVNSX0hCQ01VX09V
VEJPVU5EX1BPU1RRVUVVRV9JU1IpICYmIChpKysgPCBBUkNNU1JfTUFYX09VVFNUQU5ESU5HX0NN
RCkpIHsKKwkJd2hpbGUgKChyZWFkbCgmcmVnLT5ob3N0X2ludF9zdGF0dXMpICYKKwkJCUFSQ01T
Ul9IQkNNVV9PVVRCT1VORF9QT1NUUVVFVUVfSVNSKQorCQkJJiYgKGkrKyA8IEFSQ01TUl9NQVhf
T1VUU1RBTkRJTkdfQ01EKSkgewogCQkJLypuZWVkIHRvIGRvKi8KIAkJCWZsYWdfY2NiID0gcmVh
ZGwoJnJlZy0+b3V0Ym91bmRfcXVldWVwb3J0X2xvdyk7CiAJCQljY2JfY2RiX3BoeSA9IChmbGFn
X2NjYiAmIDB4RkZGRkZGRjApOwotCQkJcEFSQ01TUl9DREIgPSAoc3RydWN0ICBBUkNNU1JfQ0RC
ICopKGFjYi0+dmlyMnBoeV9vZmZzZXQrY2NiX2NkYl9waHkpOy8qZnJhbWUgbXVzdCBiZSAzMiBi
eXRlcyBhbGlnbmVkKi8KLQkJCXBDQ0IgPSBjb250YWluZXJfb2YocEFSQ01TUl9DREIsIHN0cnVj
dCBDb21tYW5kQ29udHJvbEJsb2NrLCBhcmNtc3JfY2RiKTsKLQkJCWVycm9yID0gKGZsYWdfY2Ni
ICYgQVJDTVNSX0NDQlJFUExZX0ZMQUdfRVJST1JfTU9ERTEpID8gdHJ1ZSA6IGZhbHNlOworCQkJ
cEFSQ01TUl9DREIgPSAoc3RydWN0ICBBUkNNU1JfQ0RCICopCisJCQkJKGFjYi0+dmlyMnBoeV9v
ZmZzZXQrY2NiX2NkYl9waHkpOworCQkJcENDQiA9IGNvbnRhaW5lcl9vZihwQVJDTVNSX0NEQiwK
KwkJCQlzdHJ1Y3QgQ29tbWFuZENvbnRyb2xCbG9jaywgYXJjbXNyX2NkYik7CisJCQllcnJvciA9
IChmbGFnX2NjYiAmIEFSQ01TUl9DQ0JSRVBMWV9GTEFHX0VSUk9SX01PREUxKQorCQkJCT8gdHJ1
ZSA6IGZhbHNlOwogCQkJYXJjbXNyX2RyYWluX2RvbmVxdWV1ZShhY2IsIHBDQ0IsIGVycm9yKTsK
IAkJfQorCQl9CisJCWJyZWFrOworCWNhc2UgQUNCX0FEQVBURVJfVFlQRV9EOiB7CisJCXN0cnVj
dCBNZXNzYWdlVW5pdF9EIF9faW9tZW0gKnBtdSA9IGFjYi0+cG11RDsKKwkJdWludDMyX3QgY2Ni
X2NkYl9waHksIG91dGJvdW5kX3dyaXRlX3BvaW50ZXI7CisJCXVpbnQzMl90IGRvbmVxX2luZGV4
LCBpbmRleF9zdHJpcHBlZCwgYWRkcmVzc0xvdywgcmVzaWR1YWw7CisJCWJvb2wgZXJyb3I7CisJ
CXN0cnVjdCBDb21tYW5kQ29udHJvbEJsb2NrICpwQ0NCOworCQlvdXRib3VuZF93cml0ZV9wb2lu
dGVyID0gcG11LT5kb25lX3FidWZmZXJbMF0uYWRkcmVzc0xvdyArIDE7CisJCWRvbmVxX2luZGV4
ID0gcG11LT5kb25lcV9pbmRleDsKKwkJcmVzaWR1YWwgPSBhdG9taWNfcmVhZCgmYWNiLT5jY2Jv
dXRzdGFuZGluZ2NvdW50KTsKKwkJZm9yIChpID0gMDsgaSA8IHJlc2lkdWFsOyBpKyspIHsKKwkJ
CXdoaWxlICgoZG9uZXFfaW5kZXggJiAweEZGRikgIT0gKG91dGJvdW5kX3dyaXRlX3BvaW50ZXIg
JiAweEZGRikpIHsKKwkJCQlpZiAoZG9uZXFfaW5kZXggJiAweDQwMDApIHsKKwkJCQkJaW5kZXhf
c3RyaXBwZWQgPSBkb25lcV9pbmRleCAmIDB4RkZGOworCQkJCQlpbmRleF9zdHJpcHBlZCArPSAx
OworCQkJCQlpbmRleF9zdHJpcHBlZCAlPQorCQkJCQlBUkNNU1JfTUFYX0FSQzEyMTRfRE9ORVFV
RVVFOworCQkJCQlwbXUtPmRvbmVxX2luZGV4ID0gaW5kZXhfc3RyaXBwZWQgPworCQkJCQkJKGlu
ZGV4X3N0cmlwcGVkIHwgMHg0MDAwKSA6IChpbmRleF9zdHJpcHBlZCArIDEpOworCQkJCX0gZWxz
ZSB7CisJCQkJCWluZGV4X3N0cmlwcGVkID0gZG9uZXFfaW5kZXg7CisJCQkJCWluZGV4X3N0cmlw
cGVkICs9IDE7CisJCQkJCWluZGV4X3N0cmlwcGVkICU9CisJCQkJCUFSQ01TUl9NQVhfQVJDMTIx
NF9ET05FUVVFVUU7CisJCQkJCXBtdS0+ZG9uZXFfaW5kZXggPQorCQkJCQkJaW5kZXhfc3RyaXBw
ZWQgPyBpbmRleF9zdHJpcHBlZCA6ICgoaW5kZXhfc3RyaXBwZWQgfCAweDQwMDApICsgMSk7CisJ
CQkJfQorCQkJCWRvbmVxX2luZGV4ID0gcG11LT5kb25lcV9pbmRleDsKKwkJCQlhZGRyZXNzTG93
ID0KKwkJCQkJcG11LT5kb25lX3FidWZmZXJbZG9uZXFfaW5kZXggJiAweEZGRl0uYWRkcmVzc0xv
dzsKKwkJCQljY2JfY2RiX3BoeSA9IChhZGRyZXNzTG93ICYgMHhGRkZGRkZGMCk7CisJCQkJcEFS
Q01TUl9DREIgPSAoc3RydWN0ICBBUkNNU1JfQ0RCICopCisJCQkJCShhY2ItPnZpcjJwaHlfb2Zm
c2V0ICsgY2NiX2NkYl9waHkpOworCQkJCXBDQ0IgPSBjb250YWluZXJfb2YocEFSQ01TUl9DREIs
CisJCQkJCXN0cnVjdCBDb21tYW5kQ29udHJvbEJsb2NrLCBhcmNtc3JfY2RiKTsKKwkJCQllcnJv
ciA9CisJCQkJCShhZGRyZXNzTG93ICYgQVJDTVNSX0NDQlJFUExZX0ZMQUdfRVJST1JfTU9ERTEp
CisJCQkJCT8gdHJ1ZSA6IGZhbHNlOworCQkJCWFyY21zcl9kcmFpbl9kb25lcXVldWUoYWNiLCBw
Q0NCLCBlcnJvcik7CisJCQkJd3JpdGVsKGRvbmVxX2luZGV4LAorCQkJCQlwbXUtPm91dGJvdW5k
bGlzdF9yZWFkX3BvaW50ZXIpOworCQkJfQorCQkJbWRlbGF5KDEwKTsKKwkJCW91dGJvdW5kX3dy
aXRlX3BvaW50ZXIgPQorCQkJCXBtdS0+ZG9uZV9xYnVmZmVyWzBdLmFkZHJlc3NMb3cgKyAxOwor
CQkJZG9uZXFfaW5kZXggPSBwbXUtPmRvbmVxX2luZGV4OworCQl9CisJCXBtdS0+cG9zdHFfaW5k
ZXggPSAwOworCQlwbXUtPmRvbmVxX2luZGV4ID0gMHg0MEZGOworCQlicmVhazsKIAl9CiAJfQog
fQotc3RhdGljIHZvaWQgYXJjbXNyX3JlbW92ZShzdHJ1Y3QgcGNpX2RldiAqcGRldikKKworc3Rh
dGljIHZvaWQKK2FyY21zcl9yZW1vdmUoc3RydWN0IHBjaV9kZXYgKnBkZXYpCiB7CiAJc3RydWN0
IFNjc2lfSG9zdCAqaG9zdCA9IHBjaV9nZXRfZHJ2ZGF0YShwZGV2KTsKIAlzdHJ1Y3QgQWRhcHRl
ckNvbnRyb2xCbG9jayAqYWNiID0KLQkJKHN0cnVjdCBBZGFwdGVyQ29udHJvbEJsb2NrICopIGhv
c3QtPmhvc3RkYXRhOwotCWludCBwb2xsX2NvdW50ID0gMDsKKwkJKHN0cnVjdCBBZGFwdGVyQ29u
dHJvbEJsb2NrICopaG9zdC0+aG9zdGRhdGE7CisJaW50IHBvbGxfY291bnQgPSAwLCBpOwogCWFy
Y21zcl9mcmVlX3N5c2ZzX2F0dHIoYWNiKTsKIAlzY3NpX3JlbW92ZV9ob3N0KGhvc3QpOwogCWZs
dXNoX3dvcmsoJmFjYi0+YXJjbXNyX2RvX21lc3NhZ2VfaXNyX2JoKTsKQEAgLTEwMDcsMjAgKzE1
MDMsMjAgQEAgc3RhdGljIHZvaWQgYXJjbXNyX3JlbW92ZShzdHJ1Y3QgcGNpX2RldgogCWFjYi0+
YWNiX2ZsYWdzIHw9IEFDQl9GX1NDU0lTVE9QQURBUFRFUjsKIAlhY2ItPmFjYl9mbGFncyAmPSB+
QUNCX0ZfSU9QX0lOSVRFRDsKIAotCWZvciAocG9sbF9jb3VudCA9IDA7IHBvbGxfY291bnQgPCBB
UkNNU1JfTUFYX09VVFNUQU5ESU5HX0NNRDsgcG9sbF9jb3VudCsrKXsKKwlmb3IgKHBvbGxfY291
bnQgPSAwOyBwb2xsX2NvdW50IDwgQVJDTVNSX01BWF9PVVRTVEFORElOR19DTUQ7CisJcG9sbF9j
b3VudCsrKSB7CiAJCWlmICghYXRvbWljX3JlYWQoJmFjYi0+Y2Nib3V0c3RhbmRpbmdjb3VudCkp
CiAJCQlicmVhazsKLQkJYXJjbXNyX2ludGVycnVwdChhY2IpOy8qIEZJWE1FOiBuZWVkIHNwaW5s
b2NrICovCisJCWFyY21zcl9pbnRlcnJ1cHQoYWNiKTsKIAkJbXNsZWVwKDI1KTsKIAl9CiAKIAlp
ZiAoYXRvbWljX3JlYWQoJmFjYi0+Y2Nib3V0c3RhbmRpbmdjb3VudCkpIHsKLQkJaW50IGk7Ci0K
IAkJYXJjbXNyX2Fib3J0X2FsbGNtZChhY2IpOwogCQlhcmNtc3JfZG9uZTRhYm9ydF9wb3N0cXVl
dWUoYWNiKTsKIAkJZm9yIChpID0gMDsgaSA8IEFSQ01TUl9NQVhfRlJFRUNDQl9OVU07IGkrKykg
ewotCQkJc3RydWN0IENvbW1hbmRDb250cm9sQmxvY2sgKmNjYiA9IGFjYi0+cGNjYl9wb29sW2ld
OworCQkJc3RydWN0IENvbW1hbmRDb250cm9sQmxvY2sgKmNjYiA9CisJCQkJYWNiLT5wY2NiX3Bv
b2xbaV07CiAJCQlpZiAoY2NiLT5zdGFydGRvbmUgPT0gQVJDTVNSX0NDQl9TVEFSVCkgewogCQkJ
CWNjYi0+c3RhcnRkb25lID0gQVJDTVNSX0NDQl9BQk9SVEVEOwogCQkJCWNjYi0+cGNtZC0+cmVz
dWx0ID0gRElEX0FCT1JUIDw8IDE2OwpAQCAtMTAyOCw5ICsxNTI0LDE3IEBAIHN0YXRpYyB2b2lk
IGFyY21zcl9yZW1vdmUoc3RydWN0IHBjaV9kZXYKIAkJCX0KIAkJfQogCX0KLQlmcmVlX2lycShw
ZGV2LT5pcnEsIGFjYik7CiAJYXJjbXNyX2ZyZWVfY2NiX3Bvb2woYWNiKTsKLQlhcmNtc3JfZnJl
ZV9oYmJfbXUoYWNiKTsKKwlhcmNtc3JfZnJlZV9tdShhY2IpOworCWlmIChhY2ItPmFjYl9mbGFn
cyAmIEFDQl9GX01TSV9FTkFCTEVEKSB7CisJCWZyZWVfaXJxKHBkZXYtPmlycSwgYWNiKTsKKwkJ
cGNpX2Rpc2FibGVfbXNpKHBkZXYpOworCX0gZWxzZSBpZiAoYWNiLT5hY2JfZmxhZ3MgJiBBQ0Jf
Rl9NU0lYX0VOQUJMRUQpIHsKKwkJZm9yIChpID0gMDsgaSA8IEFSQ01TVF9OVU1fTVNJWF9WRUNU
T1JTOyBpKyspCisJCQlmcmVlX2lycShhY2ItPmVudHJpZXNbaV0udmVjdG9yLCBhY2IpOworCQlw
Y2lfZGlzYWJsZV9tc2l4KHBkZXYpOworCX0gZWxzZQorCQlmcmVlX2lycShwZGV2LT5pcnEsIGFj
Yik7CiAJYXJjbXNyX3VubWFwX3BjaXJlZ2lvbihhY2IpOwogCXBjaV9yZWxlYXNlX3JlZ2lvbnMo
cGRldik7CiAJc2NzaV9ob3N0X3B1dChob3N0KTsKQEAgLTEwMzgsMTMgKzE1NDIsMjEgQEAgc3Rh
dGljIHZvaWQgYXJjbXNyX3JlbW92ZShzdHJ1Y3QgcGNpX2RldgogCXBjaV9zZXRfZHJ2ZGF0YShw
ZGV2LCBOVUxMKTsKIH0KIAotc3RhdGljIHZvaWQgYXJjbXNyX3NodXRkb3duKHN0cnVjdCBwY2lf
ZGV2ICpwZGV2KQorc3RhdGljIHZvaWQKK2FyY21zcl9zaHV0ZG93bihzdHJ1Y3QgcGNpX2RldiAq
cGRldikKIHsKKwlpbnQgaTsKIAlzdHJ1Y3QgU2NzaV9Ib3N0ICpob3N0ID0gcGNpX2dldF9kcnZk
YXRhKHBkZXYpOwogCXN0cnVjdCBBZGFwdGVyQ29udHJvbEJsb2NrICphY2IgPQogCQkoc3RydWN0
IEFkYXB0ZXJDb250cm9sQmxvY2sgKilob3N0LT5ob3N0ZGF0YTsKIAlkZWxfdGltZXJfc3luYygm
YWNiLT5ldGVybmFsX3RpbWVyKTsKIAlhcmNtc3JfZGlzYWJsZV9vdXRib3VuZF9pbnRzKGFjYik7
CisJaWYgKGFjYi0+YWNiX2ZsYWdzICYgQUNCX0ZfTVNJWF9FTkFCTEVEKSB7CisJCWZvciAoaSA9
IDA7IGkgPCBBUkNNU1RfTlVNX01TSVhfVkVDVE9SUzsgaSsrKQorCQkJZnJlZV9pcnEoYWNiLT5l
bnRyaWVzW2ldLnZlY3RvciwgYWNiKTsKKwkJcGNpX2Rpc2FibGVfbXNpeChwZGV2KTsKKwl9IGVs
c2UKKwkJZnJlZV9pcnEocGRldi0+aXJxLCBhY2IpOwogCWZsdXNoX3dvcmsoJmFjYi0+YXJjbXNy
X2RvX21lc3NhZ2VfaXNyX2JoKTsKIAlhcmNtc3Jfc3RvcF9hZGFwdGVyX2JncmIoYWNiKTsKIAlh
cmNtc3JfZmx1c2hfYWRhcHRlcl9jYWNoZShhY2IpOwpAQCAtMTA2NCw3ICsxNTc2LDggQEAgc3Rh
dGljIHZvaWQgYXJjbXNyX21vZHVsZV9leGl0KHZvaWQpCiBtb2R1bGVfaW5pdChhcmNtc3JfbW9k
dWxlX2luaXQpOwogbW9kdWxlX2V4aXQoYXJjbXNyX21vZHVsZV9leGl0KTsKIAotc3RhdGljIHZv
aWQgYXJjbXNyX2VuYWJsZV9vdXRib3VuZF9pbnRzKHN0cnVjdCBBZGFwdGVyQ29udHJvbEJsb2Nr
ICphY2IsCitzdGF0aWMgdm9pZAorYXJjbXNyX2VuYWJsZV9vdXRib3VuZF9pbnRzKHN0cnVjdCBB
ZGFwdGVyQ29udHJvbEJsb2NrICphY2IsCiAJCQkJCQl1MzIgaW50bWFza19vcmcpCiB7CiAJdTMy
IG1hc2s7CkBAIC0xMDcyLDM3ICsxNTg1LDUxIEBAIHN0YXRpYyB2b2lkIGFyY21zcl9lbmFibGVf
b3V0Ym91bmRfaW50cygKIAogCWNhc2UgQUNCX0FEQVBURVJfVFlQRV9BOiB7CiAJCXN0cnVjdCBN
ZXNzYWdlVW5pdF9BIF9faW9tZW0gKnJlZyA9IGFjYi0+cG11QTsKLQkJbWFzayA9IGludG1hc2tf
b3JnICYgfihBUkNNU1JfTVVfT1VUQk9VTkRfUE9TVFFVRVVFX0lOVE1BU0tFTkFCTEUgfAotCQkJ
ICAgICBBUkNNU1JfTVVfT1VUQk9VTkRfRE9PUkJFTExfSU5UTUFTS0VOQUJMRXwKLQkJCSAgICAg
QVJDTVNSX01VX09VVEJPVU5EX01FU1NBR0UwX0lOVE1BU0tFTkFCTEUpOworCQltYXNrID0gaW50
bWFza19vcmcgJgorCQkJfihBUkNNU1JfTVVfT1VUQk9VTkRfUE9TVFFVRVVFX0lOVE1BU0tFTkFC
TEUgfAorCQkgICAgIEFSQ01TUl9NVV9PVVRCT1VORF9ET09SQkVMTF9JTlRNQVNLRU5BQkxFIHwK
KwkJICAgICBBUkNNU1JfTVVfT1VUQk9VTkRfTUVTU0FHRTBfSU5UTUFTS0VOQUJMRSk7CiAJCXdy
aXRlbChtYXNrLCAmcmVnLT5vdXRib3VuZF9pbnRtYXNrKTsKLQkJYWNiLT5vdXRib3VuZF9pbnRf
ZW5hYmxlID0gfihpbnRtYXNrX29yZyAmIG1hc2spICYgMHgwMDAwMDBmZjsKLQkJfQorCQlhY2It
Pm91dGJvdW5kX2ludF9lbmFibGUgPSB+KGludG1hc2tfb3JnICYgbWFzaykgJgorCQkJMHgwMDAw
MDBmZjsKIAkJYnJlYWs7Ci0KKwkJfQogCWNhc2UgQUNCX0FEQVBURVJfVFlQRV9COiB7Ci0JCXN0
cnVjdCBNZXNzYWdlVW5pdF9CICpyZWcgPSBhY2ItPnBtdUI7CisJCXN0cnVjdCBNZXNzYWdlVW5p
dF9CIF9faW9tZW0gKnJlZyA9IGFjYi0+cG11QjsKIAkJbWFzayA9IGludG1hc2tfb3JnIHwgKEFS
Q01TUl9JT1AyRFJWX0RBVEFfV1JJVEVfT0sgfAogCQkJQVJDTVNSX0lPUDJEUlZfREFUQV9SRUFE
X09LIHwKIAkJCUFSQ01TUl9JT1AyRFJWX0NEQl9ET05FIHwKIAkJCUFSQ01TUl9JT1AyRFJWX01F
U1NBR0VfQ01EX0RPTkUpOwogCQl3cml0ZWwobWFzaywgcmVnLT5pb3AyZHJ2X2Rvb3JiZWxsX21h
c2spOwotCQlhY2ItPm91dGJvdW5kX2ludF9lbmFibGUgPSAoaW50bWFza19vcmcgfCBtYXNrKSAm
IDB4MDAwMDAwMGY7Ci0JCX0KKwkJYWNiLT5vdXRib3VuZF9pbnRfZW5hYmxlID0gKGludG1hc2tf
b3JnIHwgbWFzaykgJgorCQkJMHgwMDAwMDAwZjsKIAkJYnJlYWs7CisJCX0KIAljYXNlIEFDQl9B
REFQVEVSX1RZUEVfQzogewotCQlzdHJ1Y3QgTWVzc2FnZVVuaXRfQyAqcmVnID0gYWNiLT5wbXVD
OwotCQltYXNrID0gfihBUkNNU1JfSEJDTVVfVVRJTElUWV9BX0lTUl9NQVNLIHwgQVJDTVNSX0hC
Q01VX09VVEJPVU5EX0RPT1JCRUxMX0lTUl9NQVNLfEFSQ01TUl9IQkNNVV9PVVRCT1VORF9QT1NU
UVVFVUVfSVNSX01BU0spOworCQlzdHJ1Y3QgTWVzc2FnZVVuaXRfQyBfX2lvbWVtICpyZWcgPSBh
Y2ItPnBtdUM7CisJCW1hc2sgPSB+KEFSQ01TUl9IQkNNVV9VVElMSVRZX0FfSVNSX01BU0sgfAor
CQkJQVJDTVNSX0hCQ01VX09VVEJPVU5EX0RPT1JCRUxMX0lTUl9NQVNLIHwKKwkJCUFSQ01TUl9I
QkNNVV9PVVRCT1VORF9QT1NUUVVFVUVfSVNSX01BU0spOwogCQl3cml0ZWwoaW50bWFza19vcmcg
JiBtYXNrLCAmcmVnLT5ob3N0X2ludF9tYXNrKTsKLQkJYWNiLT5vdXRib3VuZF9pbnRfZW5hYmxl
ID0gfihpbnRtYXNrX29yZyAmIG1hc2spICYgMHgwMDAwMDAwZjsKKwkJYWNiLT5vdXRib3VuZF9p
bnRfZW5hYmxlID0gfihpbnRtYXNrX29yZyAmIG1hc2spICYKKwkJCTB4MDAwMDAwMGY7CisJCWJy
ZWFrOwogCQl9CisJY2FzZSBBQ0JfQURBUFRFUl9UWVBFX0Q6IHsKKwkJc3RydWN0IE1lc3NhZ2VV
bml0X0QgX19pb21lbSAqcmVnID0gYWNiLT5wbXVEOworCQltYXNrID0gQVJDTVNSX0FSQzEyMTRf
QUxMX0lOVF9FTkFCTEU7CisJCXdyaXRlbChpbnRtYXNrX29yZyB8IG1hc2ssIHJlZy0+cGNpZWYw
X2ludF9lbmFibGUpOworCQlicmVhazsKKwl9CiAJfQogfQogCi1zdGF0aWMgaW50IGFyY21zcl9i
dWlsZF9jY2Ioc3RydWN0IEFkYXB0ZXJDb250cm9sQmxvY2sgKmFjYiwKK3N0YXRpYyBpbnQKK2Fy
Y21zcl9idWlsZF9jY2Ioc3RydWN0IEFkYXB0ZXJDb250cm9sQmxvY2sgKmFjYiwKIAlzdHJ1Y3Qg
Q29tbWFuZENvbnRyb2xCbG9jayAqY2NiLCBzdHJ1Y3Qgc2NzaV9jbW5kICpwY21kKQogewotCXN0
cnVjdCBBUkNNU1JfQ0RCICphcmNtc3JfY2RiID0gKHN0cnVjdCBBUkNNU1JfQ0RCICopJmNjYi0+
YXJjbXNyX2NkYjsKKwlzdHJ1Y3QgQVJDTVNSX0NEQiAqYXJjbXNyX2NkYiA9CisJCShzdHJ1Y3Qg
QVJDTVNSX0NEQiAqKSZjY2ItPmFyY21zcl9jZGI7CiAJaW50OF90ICpwc2dlID0gKGludDhfdCAq
KSZhcmNtc3JfY2RiLT51OwogCV9fbGUzMiBhZGRyZXNzX2xvLCBhZGRyZXNzX2hpOwogCWludCBh
cmNjZGJzaXplID0gMHgzMDsKQEAgLTExMTUsOCArMTY0Miw3IEBAIHN0YXRpYyBpbnQgYXJjbXNy
X2J1aWxkX2NjYihzdHJ1Y3QgQWRhcHQKIAlhcmNtc3JfY2RiLT5UYXJnZXRJRCA9IHBjbWQtPmRl
dmljZS0+aWQ7CiAJYXJjbXNyX2NkYi0+TFVOID0gcGNtZC0+ZGV2aWNlLT5sdW47CiAJYXJjbXNy
X2NkYi0+RnVuY3Rpb24gPSAxOwotCWFyY21zcl9jZGItPkNvbnRleHQgPSAwOwotCW1lbWNweShh
cmNtc3JfY2RiLT5DZGIsIHBjbWQtPmNtbmQsIHBjbWQtPmNtZF9sZW4pOworCW1lbWNweSgodm9p
ZCAqKWFyY21zcl9jZGItPkNkYiwgKGNvbnN0IHZvaWQgKilwY21kLT5jbW5kLCBwY21kLT5jbWRf
bGVuKTsKIAogCW5zZWcgPSBzY3NpX2RtYV9tYXAocGNtZCk7CiAJaWYgKHVubGlrZWx5KG5zZWcg
PiBhY2ItPmhvc3QtPnNnX3RhYmxlc2l6ZSB8fCBuc2VnIDwgMCkpCkBAIC0xMTI3LDI1ICsxNjUz
LDI3IEBAIHN0YXRpYyBpbnQgYXJjbXNyX2J1aWxkX2NjYihzdHJ1Y3QgQWRhcHQKIAkJYWRkcmVz
c19sbyA9IGNwdV90b19sZTMyKGRtYV9hZGRyX2xvMzIoc2dfZG1hX2FkZHJlc3Moc2cpKSk7CiAJ
CWFkZHJlc3NfaGkgPSBjcHVfdG9fbGUzMihkbWFfYWRkcl9oaTMyKHNnX2RtYV9hZGRyZXNzKHNn
KSkpOwogCQlpZiAoYWRkcmVzc19oaSA9PSAwKSB7Ci0JCQlzdHJ1Y3QgU0czMkVOVFJZICpwZG1h
X3NnID0gKHN0cnVjdCBTRzMyRU5UUlkgKilwc2dlOwotCisJCQlzdHJ1Y3QgU0czMkVOVFJZICpw
ZG1hX3NnID0KKwkJCQkoc3RydWN0IFNHMzJFTlRSWSAqKXBzZ2U7CiAJCQlwZG1hX3NnLT5hZGRy
ZXNzID0gYWRkcmVzc19sbzsKIAkJCXBkbWFfc2ctPmxlbmd0aCA9IGxlbmd0aDsKIAkJCXBzZ2Ug
Kz0gc2l6ZW9mIChzdHJ1Y3QgU0czMkVOVFJZKTsKIAkJCWFyY2NkYnNpemUgKz0gc2l6ZW9mIChz
dHJ1Y3QgU0czMkVOVFJZKTsKIAkJfSBlbHNlIHsKLQkJCXN0cnVjdCBTRzY0RU5UUlkgKnBkbWFf
c2cgPSAoc3RydWN0IFNHNjRFTlRSWSAqKXBzZ2U7Ci0KKwkJCXN0cnVjdCBTRzY0RU5UUlkgKnBk
bWFfc2cgPQorCQkJCShzdHJ1Y3QgU0c2NEVOVFJZICopcHNnZTsKIAkJCXBkbWFfc2ctPmFkZHJl
c3NoaWdoID0gYWRkcmVzc19oaTsKIAkJCXBkbWFfc2ctPmFkZHJlc3MgPSBhZGRyZXNzX2xvOwot
CQkJcGRtYV9zZy0+bGVuZ3RoID0gbGVuZ3RofGNwdV90b19sZTMyKElTX1NHNjRfQUREUik7CisJ
CQlwZG1hX3NnLT5sZW5ndGggPSBsZW5ndGggfAorCQkJCWNwdV90b19sZTMyKElTX1NHNjRfQURE
Uik7CiAJCQlwc2dlICs9IHNpemVvZiAoc3RydWN0IFNHNjRFTlRSWSk7CiAJCQlhcmNjZGJzaXpl
ICs9IHNpemVvZiAoc3RydWN0IFNHNjRFTlRSWSk7CiAJCX0KIAl9CiAJYXJjbXNyX2NkYi0+c2dj
b3VudCA9ICh1aW50OF90KW5zZWc7CiAJYXJjbXNyX2NkYi0+RGF0YUxlbmd0aCA9IHNjc2lfYnVm
ZmxlbihwY21kKTsKLQlhcmNtc3JfY2RiLT5tc2dQYWdlcyA9IGFyY2NkYnNpemUvMHgxMDAgKyAo
YXJjY2Ric2l6ZSAlIDB4MTAwID8gMSA6IDApOworCWFyY21zcl9jZGItPm1zZ1BhZ2VzID0gYXJj
Y2Ric2l6ZSAvIDB4MTAwICsKKwkJKGFyY2NkYnNpemUgJSAweDEwMCA/IDEgOiAwKTsKIAlpZiAo
IGFyY2NkYnNpemUgPiAyNTYpCiAJCWFyY21zcl9jZGItPkZsYWdzIHw9IEFSQ01TUl9DREJfRkxB
R19TR0xfQlNJWkU7CiAJaWYgKHBjbWQtPnNjX2RhdGFfZGlyZWN0aW9uID09IERNQV9UT19ERVZJ
Q0UpCkBAIC0xMTU0LDEwICsxNjgyLDE0IEBAIHN0YXRpYyBpbnQgYXJjbXNyX2J1aWxkX2NjYihz
dHJ1Y3QgQWRhcHQKIAlyZXR1cm4gU1VDQ0VTUzsKIH0KIAotc3RhdGljIHZvaWQgYXJjbXNyX3Bv
c3RfY2NiKHN0cnVjdCBBZGFwdGVyQ29udHJvbEJsb2NrICphY2IsIHN0cnVjdCBDb21tYW5kQ29u
dHJvbEJsb2NrICpjY2IpCi17Ci0JdWludDMyX3QgY2RiX3BoeWFkZHJfcGF0dGVybiA9IGNjYi0+
Y2RiX3BoeWFkZHJfcGF0dGVybjsKLQlzdHJ1Y3QgQVJDTVNSX0NEQiAqYXJjbXNyX2NkYiA9IChz
dHJ1Y3QgQVJDTVNSX0NEQiAqKSZjY2ItPmFyY21zcl9jZGI7CitzdGF0aWMgdm9pZAorYXJjbXNy
X3Bvc3RfY2NiKHN0cnVjdCBBZGFwdGVyQ29udHJvbEJsb2NrICphY2IsCisJc3RydWN0IENvbW1h
bmRDb250cm9sQmxvY2sgKmNjYikKK3sKKwl1aW50MzJfdCBjZGJfcGh5YWRkciA9IGNjYi0+Y2Ri
X3BoeWFkZHI7CisJc3RydWN0IEFSQ01TUl9DREIgKmFyY21zcl9jZGIgPQorCQkoc3RydWN0IEFS
Q01TUl9DREIgKikmY2NiLT5hcmNtc3JfY2RiOworCXUzMiBhcmNjZGJzaXplID0gY2NiLT5hcmNf
Y2RiX3NpemU7CiAJYXRvbWljX2luYygmYWNiLT5jY2JvdXRzdGFuZGluZ2NvdW50KTsKIAljY2It
PnN0YXJ0ZG9uZSA9IEFSQ01TUl9DQ0JfU1RBUlQ7CiAJc3dpdGNoIChhY2ItPmFkYXB0ZXJfdHlw
ZSkgewpAQCAtMTE2NSwxMzEgKzE2OTcsMjAzIEBAIHN0YXRpYyB2b2lkIGFyY21zcl9wb3N0X2Nj
YihzdHJ1Y3QgQWRhcHQKIAkJc3RydWN0IE1lc3NhZ2VVbml0X0EgX19pb21lbSAqcmVnID0gYWNi
LT5wbXVBOwogCiAJCWlmIChhcmNtc3JfY2RiLT5GbGFncyAmIEFSQ01TUl9DREJfRkxBR19TR0xf
QlNJWkUpCi0JCQl3cml0ZWwoY2RiX3BoeWFkZHJfcGF0dGVybiB8IEFSQ01TUl9DQ0JQT1NUX0ZM
QUdfU0dMX0JTSVpFLAotCQkJJnJlZy0+aW5ib3VuZF9xdWV1ZXBvcnQpOwotCQllbHNlIHsKLQkJ
CQl3cml0ZWwoY2RiX3BoeWFkZHJfcGF0dGVybiwgJnJlZy0+aW5ib3VuZF9xdWV1ZXBvcnQpOwot
CQl9CisJCQl3cml0ZWwoY2RiX3BoeWFkZHIgfAorCQkJCUFSQ01TUl9DQ0JQT1NUX0ZMQUdfU0dM
X0JTSVpFLAorCQkJCSZyZWctPmluYm91bmRfcXVldWVwb3J0KTsKKwkJZWxzZQorCQkJd3JpdGVs
KGNkYl9waHlhZGRyLCAmcmVnLT5pbmJvdW5kX3F1ZXVlcG9ydCk7CiAJCX0KIAkJYnJlYWs7CiAK
IAljYXNlIEFDQl9BREFQVEVSX1RZUEVfQjogewotCQlzdHJ1Y3QgTWVzc2FnZVVuaXRfQiAqcmVn
ID0gYWNiLT5wbXVCOworCQlzdHJ1Y3QgTWVzc2FnZVVuaXRfQiBfX2lvbWVtICpyZWcgPSBhY2It
PnBtdUI7CiAJCXVpbnQzMl90IGVuZGluZ19pbmRleCwgaW5kZXggPSByZWctPnBvc3RxX2luZGV4
OwogCi0JCWVuZGluZ19pbmRleCA9ICgoaW5kZXggKyAxKSAlIEFSQ01TUl9NQVhfSEJCX1BPU1RR
VUVVRSk7CisJCWVuZGluZ19pbmRleCA9ICgoaW5kZXggKyAxKSAlCisJCQlBUkNNU1JfTUFYX0hC
Ql9QT1NUUVVFVUUpOwogCQl3cml0ZWwoMCwgJnJlZy0+cG9zdF9xYnVmZmVyW2VuZGluZ19pbmRl
eF0pOwogCQlpZiAoYXJjbXNyX2NkYi0+RmxhZ3MgJiBBUkNNU1JfQ0RCX0ZMQUdfU0dMX0JTSVpF
KSB7Ci0JCQl3cml0ZWwoY2RiX3BoeWFkZHJfcGF0dGVybiB8IEFSQ01TUl9DQ0JQT1NUX0ZMQUdf
U0dMX0JTSVpFLFwKLQkJCQkJCSAmcmVnLT5wb3N0X3FidWZmZXJbaW5kZXhdKTsKLQkJfSBlbHNl
IHsKLQkJCXdyaXRlbChjZGJfcGh5YWRkcl9wYXR0ZXJuLCAmcmVnLT5wb3N0X3FidWZmZXJbaW5k
ZXhdKTsKLQkJfQorCQkJd3JpdGVsKGNkYl9waHlhZGRyIHwKKwkJCQlBUkNNU1JfQ0NCUE9TVF9G
TEFHX1NHTF9CU0laRSwKKwkJCQkmcmVnLT5wb3N0X3FidWZmZXJbaW5kZXhdKTsKKwkJfSBlbHNl
CisJCQl3cml0ZWwoY2RiX3BoeWFkZHIsICZyZWctPnBvc3RfcWJ1ZmZlcltpbmRleF0pOwogCQlp
bmRleCsrOwotCQlpbmRleCAlPSBBUkNNU1JfTUFYX0hCQl9QT1NUUVVFVUU7LyppZiBsYXN0IGlu
ZGV4IG51bWJlciBzZXQgaXQgdG8gMCAqLworCQlpbmRleCAlPSBBUkNNU1JfTUFYX0hCQl9QT1NU
UVVFVUU7CiAJCXJlZy0+cG9zdHFfaW5kZXggPSBpbmRleDsKLQkJd3JpdGVsKEFSQ01TUl9EUlYy
SU9QX0NEQl9QT1NURUQsIHJlZy0+ZHJ2MmlvcF9kb29yYmVsbCk7CisJCXdyaXRlbChBUkNNU1Jf
RFJWMklPUF9DREJfUE9TVEVELAorCQkJcmVnLT5kcnYyaW9wX2Rvb3JiZWxsKTsKIAkJfQogCQli
cmVhazsKIAljYXNlIEFDQl9BREFQVEVSX1RZUEVfQzogewotCQlzdHJ1Y3QgTWVzc2FnZVVuaXRf
QyAqcGhiY211ID0gKHN0cnVjdCBNZXNzYWdlVW5pdF9DICopYWNiLT5wbXVDOworCQlzdHJ1Y3Qg
TWVzc2FnZVVuaXRfQyBfX2lvbWVtICpwaGJjbXUgPSBhY2ItPnBtdUM7CiAJCXVpbnQzMl90IGNj
Yl9wb3N0X3N0YW1wLCBhcmNfY2RiX3NpemU7CiAKLQkJYXJjX2NkYl9zaXplID0gKGNjYi0+YXJj
X2NkYl9zaXplID4gMHgzMDApID8gMHgzMDAgOiBjY2ItPmFyY19jZGJfc2l6ZTsKLQkJY2NiX3Bv
c3Rfc3RhbXAgPSAoY2RiX3BoeWFkZHJfcGF0dGVybiB8ICgoYXJjX2NkYl9zaXplIC0gMSkgPj4g
NikgfCAxKTsKKwkJYXJjX2NkYl9zaXplID0gKGNjYi0+YXJjX2NkYl9zaXplID4gMHgzMDApCisJ
CQk/IDB4MzAwIDogY2NiLT5hcmNfY2RiX3NpemU7CisJCWNjYl9wb3N0X3N0YW1wID0gKGNkYl9w
aHlhZGRyIHwKKwkJCSgoYXJjX2NkYl9zaXplIC0gMSkgPj4gNikgfCAxKTsKIAkJaWYgKGFjYi0+
Y2RiX3BoeWFkZHJfaGkzMikgewotCQkJd3JpdGVsKGFjYi0+Y2RiX3BoeWFkZHJfaGkzMiwgJnBo
YmNtdS0+aW5ib3VuZF9xdWV1ZXBvcnRfaGlnaCk7Ci0JCQl3cml0ZWwoY2NiX3Bvc3Rfc3RhbXAs
ICZwaGJjbXUtPmluYm91bmRfcXVldWVwb3J0X2xvdyk7CisJCQl3cml0ZWwoYWNiLT5jZGJfcGh5
YWRkcl9oaTMyLAorCQkJCSZwaGJjbXUtPmluYm91bmRfcXVldWVwb3J0X2hpZ2gpOworCQkJd3Jp
dGVsKGNjYl9wb3N0X3N0YW1wLAorCQkJCSZwaGJjbXUtPmluYm91bmRfcXVldWVwb3J0X2xvdyk7
CisJCX0gZWxzZQorCQkJd3JpdGVsKGNjYl9wb3N0X3N0YW1wLAorCQkJCSZwaGJjbXUtPmluYm91
bmRfcXVldWVwb3J0X2xvdyk7CisJCX0KKwkJYnJlYWs7CisJY2FzZSBBQ0JfQURBUFRFUl9UWVBF
X0Q6IHsKKwkJc3RydWN0IE1lc3NhZ2VVbml0X0QgX19pb21lbSAqcG11ID0gYWNiLT5wbXVEOwor
CQl1MTYgaW5kZXhfc3RyaXBwZWQ7CisJCXUxNiBwb3N0cV9pbmRleDsKKwkJdW5zaWduZWQgbG9u
ZyBmbGFnczsKKwkJc3RydWN0IEluQm91bmRfU1JCICpwaW5ib3VuZF9zcmI7CisJCXNwaW5fbG9j
a19pcnFzYXZlKCZhY2ItPnBvc3RxX2xvY2ssIGZsYWdzKTsKKwkJcG9zdHFfaW5kZXggPSBwbXUt
PnBvc3RxX2luZGV4OworCQlwaW5ib3VuZF9zcmIgPSAoc3RydWN0IEluQm91bmRfU1JCICopJnBt
dS0+cG9zdF9xYnVmZmVyW3Bvc3RxX2luZGV4ICYgMHhGRl07CisJCXBpbmJvdW5kX3NyYi0+YWRk
cmVzc0hpZ2ggPSBkbWFfYWRkcl9oaTMyKGNkYl9waHlhZGRyKTsKKwkJcGluYm91bmRfc3JiLT5h
ZGRyZXNzTG93ID0gZG1hX2FkZHJfbG8zMihjZGJfcGh5YWRkcik7CisJCXBpbmJvdW5kX3NyYi0+
bGVuZ3RoID0gYXJjY2Ric2l6ZSA+PiAyOworCQlhcmNtc3JfY2RiLT5tc2dDb250ZXh0ID0gZG1h
X2FkZHJfbG8zMihjZGJfcGh5YWRkcik7CisJCWlmIChwb3N0cV9pbmRleCAmIDB4NDAwMCkgewor
CQkJaW5kZXhfc3RyaXBwZWQgPSBwb3N0cV9pbmRleCAmIDB4RkY7CisJCQlpbmRleF9zdHJpcHBl
ZCArPSAxOworCQkJaW5kZXhfc3RyaXBwZWQgJT0gQVJDTVNSX01BWF9BUkMxMjE0X1BPU1RRVUVV
RTsKKwkJCXBtdS0+cG9zdHFfaW5kZXggPSBpbmRleF9zdHJpcHBlZCA/IChpbmRleF9zdHJpcHBl
ZCB8IDB4NDAwMCkgOiBpbmRleF9zdHJpcHBlZDsKIAkJfSBlbHNlIHsKLQkJCXdyaXRlbChjY2Jf
cG9zdF9zdGFtcCwgJnBoYmNtdS0+aW5ib3VuZF9xdWV1ZXBvcnRfbG93KTsKLQkJfQorCQkJaW5k
ZXhfc3RyaXBwZWQgPSBwb3N0cV9pbmRleDsKKwkJCWluZGV4X3N0cmlwcGVkICs9IDE7CisJCQlp
bmRleF9zdHJpcHBlZCAlPSBBUkNNU1JfTUFYX0FSQzEyMTRfUE9TVFFVRVVFOworCQkJcG11LT5w
b3N0cV9pbmRleCA9IGluZGV4X3N0cmlwcGVkID8gaW5kZXhfc3RyaXBwZWQgOiAoaW5kZXhfc3Ry
aXBwZWQgfCAweDQwMDApOwogCQl9CisJCXdyaXRlbChwb3N0cV9pbmRleCwgcG11LT5pbmJvdW5k
bGlzdF93cml0ZV9wb2ludGVyKTsKKwkJc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSgmYWNiLT5wb3N0
cV9sb2NrLCBmbGFncyk7CisJCWJyZWFrOworCX0KIAl9CiB9CiAKLXN0YXRpYyB2b2lkIGFyY21z
cl9zdG9wX2hiYV9iZ3JiKHN0cnVjdCBBZGFwdGVyQ29udHJvbEJsb2NrICphY2IpCitzdGF0aWMg
dm9pZCBhcmNtc3JfaGJhQV9zdG9wX2JncmIoc3RydWN0IEFkYXB0ZXJDb250cm9sQmxvY2sgKmFj
YikKIHsKIAlzdHJ1Y3QgTWVzc2FnZVVuaXRfQSBfX2lvbWVtICpyZWcgPSBhY2ItPnBtdUE7CiAJ
YWNiLT5hY2JfZmxhZ3MgJj0gfkFDQl9GX01TR19TVEFSVF9CR1JCOwogCXdyaXRlbChBUkNNU1Jf
SU5CT1VORF9NRVNHMF9TVE9QX0JHUkIsICZyZWctPmluYm91bmRfbXNnYWRkcjApOwotCWlmICgh
YXJjbXNyX2hiYV93YWl0X21zZ2ludF9yZWFkeShhY2IpKSB7Ci0JCXByaW50ayhLRVJOX05PVElD
RQotCQkJImFyY21zciVkOiB3YWl0ICdzdG9wIGFkYXB0ZXIgYmFja2dyb3VuZCByZWJ1bGlkJyB0
aW1lb3V0IFxuIgorCWlmICghYXJjbXNyX2hiYUFfd2FpdF9tc2dpbnRfcmVhZHkoYWNiKSkKKwkJ
cHJfbm90aWNlKCJhcmNtc3IlZDogd2FpdCAnc3RvcCBhZGFwdGVyIGJhY2tncm91bmQgcmVidWxp
ZCcgdGltZW91dFxuIgogCQkJLCBhY2ItPmhvc3QtPmhvc3Rfbm8pOwotCX0KIH0KIAotc3RhdGlj
IHZvaWQgYXJjbXNyX3N0b3BfaGJiX2JncmIoc3RydWN0IEFkYXB0ZXJDb250cm9sQmxvY2sgKmFj
YikKK3N0YXRpYyB2b2lkCithcmNtc3JfaGJhQl9zdG9wX2JncmIoc3RydWN0IEFkYXB0ZXJDb250
cm9sQmxvY2sgKmFjYikKIHsKLQlzdHJ1Y3QgTWVzc2FnZVVuaXRfQiAqcmVnID0gYWNiLT5wbXVC
OworCXN0cnVjdCBNZXNzYWdlVW5pdF9CIF9faW9tZW0gKnJlZyA9IGFjYi0+cG11QjsKIAlhY2It
PmFjYl9mbGFncyAmPSB+QUNCX0ZfTVNHX1NUQVJUX0JHUkI7CiAJd3JpdGVsKEFSQ01TUl9NRVNT
QUdFX1NUT1BfQkdSQiwgcmVnLT5kcnYyaW9wX2Rvb3JiZWxsKTsKIAotCWlmICghYXJjbXNyX2hi
Yl93YWl0X21zZ2ludF9yZWFkeShhY2IpKSB7Ci0JCXByaW50ayhLRVJOX05PVElDRQotCQkJImFy
Y21zciVkOiB3YWl0ICdzdG9wIGFkYXB0ZXIgYmFja2dyb3VuZCByZWJ1bGlkJyB0aW1lb3V0IFxu
IgorCWlmICghYXJjbXNyX2hiYUJfd2FpdF9tc2dpbnRfcmVhZHkoYWNiKSkKKwkJcHJfbm90aWNl
KCJhcmNtc3IlZDogd2FpdCAnc3RvcCBhZGFwdGVyIGJhY2tncm91bmQgcmVidWxpZCcgdGltZW91
dFxuIgogCQkJLCBhY2ItPmhvc3QtPmhvc3Rfbm8pOwotCX0KIH0KIAotc3RhdGljIHZvaWQgYXJj
bXNyX3N0b3BfaGJjX2JncmIoc3RydWN0IEFkYXB0ZXJDb250cm9sQmxvY2sgKnBBQ0IpCitzdGF0
aWMgdm9pZAorYXJjbXNyX2hiYUNfc3RvcF9iZ3JiKHN0cnVjdCBBZGFwdGVyQ29udHJvbEJsb2Nr
ICpwQUNCKQogewotCXN0cnVjdCBNZXNzYWdlVW5pdF9DICpyZWcgPSAoc3RydWN0IE1lc3NhZ2VV
bml0X0MgKilwQUNCLT5wbXVDOworCXN0cnVjdCBNZXNzYWdlVW5pdF9DIF9faW9tZW0gKnJlZyA9
IHBBQ0ItPnBtdUM7CiAJcEFDQi0+YWNiX2ZsYWdzICY9IH5BQ0JfRl9NU0dfU1RBUlRfQkdSQjsK
IAl3cml0ZWwoQVJDTVNSX0lOQk9VTkRfTUVTRzBfU1RPUF9CR1JCLCAmcmVnLT5pbmJvdW5kX21z
Z2FkZHIwKTsKLQl3cml0ZWwoQVJDTVNSX0hCQ01VX0RSVjJJT1BfTUVTU0FHRV9DTURfRE9ORSwg
JnJlZy0+aW5ib3VuZF9kb29yYmVsbCk7Ci0JaWYgKCFhcmNtc3JfaGJjX3dhaXRfbXNnaW50X3Jl
YWR5KHBBQ0IpKSB7Ci0JCXByaW50ayhLRVJOX05PVElDRQotCQkJImFyY21zciVkOiB3YWl0ICdz
dG9wIGFkYXB0ZXIgYmFja2dyb3VuZCByZWJ1bGlkJyB0aW1lb3V0IFxuIgorCXdyaXRlbChBUkNN
U1JfSEJDTVVfRFJWMklPUF9NRVNTQUdFX0NNRF9ET05FLAorCQkmcmVnLT5pbmJvdW5kX2Rvb3Ji
ZWxsKTsKKwlpZiAoIWFyY21zcl9oYmFDX3dhaXRfbXNnaW50X3JlYWR5KHBBQ0IpKQorCQlwcl9u
b3RpY2UoImFyY21zciVkOiB3YWl0ICdzdG9wIGFkYXB0ZXIgYmFja2dyb3VuZCByZWJ1bGlkJyB0
aW1lb3V0XG4iCiAJCQksIHBBQ0ItPmhvc3QtPmhvc3Rfbm8pOwotCX0KLQlyZXR1cm47CiB9Ci1z
dGF0aWMgdm9pZCBhcmNtc3Jfc3RvcF9hZGFwdGVyX2JncmIoc3RydWN0IEFkYXB0ZXJDb250cm9s
QmxvY2sgKmFjYikKKworc3RhdGljIHZvaWQKK2FyY21zcl9oYmFEX3N0b3BfYmdyYihzdHJ1Y3Qg
QWRhcHRlckNvbnRyb2xCbG9jayAqcEFDQikKK3sKKwlzdHJ1Y3QgTWVzc2FnZVVuaXRfRCBfX2lv
bWVtICpyZWcgPSBwQUNCLT5wbXVEOworCisJcEFDQi0+YWNiX2ZsYWdzICY9IH5BQ0JfRl9NU0df
U1RBUlRfQkdSQjsKKwl3cml0ZWwoQVJDTVNSX0lOQk9VTkRfTUVTRzBfU1RPUF9CR1JCLAorCQly
ZWctPmluYm91bmRfbXNnYWRkcjApOworCWlmICghYXJjbXNyX2hiYURfd2FpdF9tc2dpbnRfcmVh
ZHkocEFDQikpCisJCXByX25vdGljZSgiYXJjbXNyJWQ6IHdhaXQgJ3N0b3AgYWRhcHRlciBiYWNr
Z3JvdW5kIHJlYnVsaWQnIHRpbWVvdXRcbiIKKwkJCSwgcEFDQi0+aG9zdC0+aG9zdF9ubyk7Cit9
CisKK3N0YXRpYyB2b2lkCithcmNtc3Jfc3RvcF9hZGFwdGVyX2JncmIoc3RydWN0IEFkYXB0ZXJD
b250cm9sQmxvY2sgKmFjYikKIHsKIAlzd2l0Y2ggKGFjYi0+YWRhcHRlcl90eXBlKSB7CiAJY2Fz
ZSBBQ0JfQURBUFRFUl9UWVBFX0E6IHsKLQkJYXJjbXNyX3N0b3BfaGJhX2JncmIoYWNiKTsKLQkJ
fQorCQlhcmNtc3JfaGJhQV9zdG9wX2JncmIoYWNiKTsKIAkJYnJlYWs7Ci0KKwl9CiAJY2FzZSBB
Q0JfQURBUFRFUl9UWVBFX0I6IHsKLQkJYXJjbXNyX3N0b3BfaGJiX2JncmIoYWNiKTsKLQkJfQor
CQlhcmNtc3JfaGJhQl9zdG9wX2JncmIoYWNiKTsKIAkJYnJlYWs7CisJfQogCWNhc2UgQUNCX0FE
QVBURVJfVFlQRV9DOiB7Ci0JCWFyY21zcl9zdG9wX2hiY19iZ3JiKGFjYik7Ci0JCX0KKwkJYXJj
bXNyX2hiYUNfc3RvcF9iZ3JiKGFjYik7CisJCWJyZWFrOworCX0KKwljYXNlIEFDQl9BREFQVEVS
X1RZUEVfRDogeworCQlhcmNtc3JfaGJhRF9zdG9wX2JncmIoYWNiKTsKKwkJYnJlYWs7CisJfQog
CX0KIH0KIAotc3RhdGljIHZvaWQgYXJjbXNyX2ZyZWVfY2NiX3Bvb2woc3RydWN0IEFkYXB0ZXJD
b250cm9sQmxvY2sgKmFjYikKK3N0YXRpYyB2b2lkCithcmNtc3JfZnJlZV9jY2JfcG9vbChzdHJ1
Y3QgQWRhcHRlckNvbnRyb2xCbG9jayAqYWNiKQogewotCWRtYV9mcmVlX2NvaGVyZW50KCZhY2It
PnBkZXYtPmRldiwgYWNiLT51bmNhY2hlX3NpemUsIGFjYi0+ZG1hX2NvaGVyZW50LCBhY2ItPmRt
YV9jb2hlcmVudF9oYW5kbGUpOworCXN3aXRjaCAoYWNiLT5hZGFwdGVyX3R5cGUpIHsKKwljYXNl
IEFDQl9BREFQVEVSX1RZUEVfQToKKwljYXNlIEFDQl9BREFQVEVSX1RZUEVfQzoKKwljYXNlIEFD
Ql9BREFQVEVSX1RZUEVfQjoKKwljYXNlIEFDQl9BREFQVEVSX1RZUEVfRDoKKwkJZG1hX2ZyZWVf
Y29oZXJlbnQoJmFjYi0+cGRldi0+ZGV2LCBhY2ItPnVuY2FjaGVfc2l6ZSwKKwkJCWFjYi0+ZG1h
X2NvaGVyZW50LCBhY2ItPmRtYV9jb2hlcmVudF9oYW5kbGUpOworCQlicmVhazsKKwl9CiB9CiAK
LXZvaWQgYXJjbXNyX2lvcF9tZXNzYWdlX3JlYWQoc3RydWN0IEFkYXB0ZXJDb250cm9sQmxvY2sg
KmFjYikKK3ZvaWQKK2FyY21zcl9pb3BfbWVzc2FnZV9yZWFkKHN0cnVjdCBBZGFwdGVyQ29udHJv
bEJsb2NrICphY2IpCiB7CiAJc3dpdGNoIChhY2ItPmFkYXB0ZXJfdHlwZSkgewogCWNhc2UgQUNC
X0FEQVBURVJfVFlQRV9BOiB7CiAJCXN0cnVjdCBNZXNzYWdlVW5pdF9BIF9faW9tZW0gKnJlZyA9
IGFjYi0+cG11QTsKLQkJd3JpdGVsKEFSQ01TUl9JTkJPVU5EX0RSSVZFUl9EQVRBX1JFQURfT0ss
ICZyZWctPmluYm91bmRfZG9vcmJlbGwpOworCQl3cml0ZWwoQVJDTVNSX0lOQk9VTkRfRFJJVkVS
X0RBVEFfUkVBRF9PSywKKwkJCSZyZWctPmluYm91bmRfZG9vcmJlbGwpOwogCQl9CiAJCWJyZWFr
OwogCiAJY2FzZSBBQ0JfQURBUFRFUl9UWVBFX0I6IHsKLQkJc3RydWN0IE1lc3NhZ2VVbml0X0Ig
KnJlZyA9IGFjYi0+cG11QjsKLQkJd3JpdGVsKEFSQ01TUl9EUlYySU9QX0RBVEFfUkVBRF9PSywg
cmVnLT5kcnYyaW9wX2Rvb3JiZWxsKTsKKwkJc3RydWN0IE1lc3NhZ2VVbml0X0IgX19pb21lbSAq
cmVnID0gYWNiLT5wbXVCOworCQl3cml0ZWwoQVJDTVNSX0RSVjJJT1BfREFUQV9SRUFEX09LLAor
CQkJcmVnLT5kcnYyaW9wX2Rvb3JiZWxsKTsKIAkJfQogCQlicmVhazsKIAljYXNlIEFDQl9BREFQ
VEVSX1RZUEVfQzogewogCQlzdHJ1Y3QgTWVzc2FnZVVuaXRfQyBfX2lvbWVtICpyZWcgPSBhY2It
PnBtdUM7CiAJCXdyaXRlbChBUkNNU1JfSEJDTVVfRFJWMklPUF9EQVRBX1JFQURfT0ssICZyZWct
PmluYm91bmRfZG9vcmJlbGwpOworCQkvKnJlYWRsKCZyZWctPmluYm91bmRfZG9vcmJlbGwpOyov
CiAJCX0KKwkJYnJlYWs7CisJY2FzZSBBQ0JfQURBUFRFUl9UWVBFX0Q6IHsKKwkJc3RydWN0IE1l
c3NhZ2VVbml0X0QgX19pb21lbSAqcmVnID0gYWNiLT5wbXVEOworCQl3cml0ZWwoQVJDTVNSX0FS
QzEyMTRfRFJWMklPUF9EQVRBX09VVF9SRUFELAorCQkJcmVnLT5pbmJvdW5kX2Rvb3JiZWxsKTsK
KwkJLypyZWFkbChyZWctPmluYm91bmRfZG9vcmJlbGwpOyovCisJCWJyZWFrOworCX0KIAl9CiB9
CiAKLXN0YXRpYyB2b2lkIGFyY21zcl9pb3BfbWVzc2FnZV93cm90ZShzdHJ1Y3QgQWRhcHRlckNv
bnRyb2xCbG9jayAqYWNiKQorc3RhdGljIHZvaWQKK2FyY21zcl9pb3BfbWVzc2FnZV93cm90ZShz
dHJ1Y3QgQWRhcHRlckNvbnRyb2xCbG9jayAqYWNiKQogewogCXN3aXRjaCAoYWNiLT5hZGFwdGVy
X3R5cGUpIHsKIAljYXNlIEFDQl9BREFQVEVSX1RZUEVfQTogewpAQCAtMTI5OCwxNyArMTkwMiwx
OSBAQCBzdGF0aWMgdm9pZCBhcmNtc3JfaW9wX21lc3NhZ2Vfd3JvdGUoc3RyCiAJCSoqIHB1c2gg
aW5ib3VuZCBkb29yYmVsbCB0ZWxsIGlvcCwgZHJpdmVyIGRhdGEgd3JpdGUgb2sKIAkJKiogYW5k
IHdhaXQgcmVwbHkgb24gbmV4dCBod2ludGVycnVwdCBmb3IgbmV4dCBRYnVmZmVyIHBvc3QKIAkJ
Ki8KLQkJd3JpdGVsKEFSQ01TUl9JTkJPVU5EX0RSSVZFUl9EQVRBX1dSSVRFX09LLCAmcmVnLT5p
bmJvdW5kX2Rvb3JiZWxsKTsKKwkJd3JpdGVsKEFSQ01TUl9JTkJPVU5EX0RSSVZFUl9EQVRBX1dS
SVRFX09LLAorCQkJJnJlZy0+aW5ib3VuZF9kb29yYmVsbCk7CiAJCX0KIAkJYnJlYWs7CiAKIAlj
YXNlIEFDQl9BREFQVEVSX1RZUEVfQjogewotCQlzdHJ1Y3QgTWVzc2FnZVVuaXRfQiAqcmVnID0g
YWNiLT5wbXVCOworCQlzdHJ1Y3QgTWVzc2FnZVVuaXRfQiBfX2lvbWVtICpyZWcgPSBhY2ItPnBt
dUI7CiAJCS8qCiAJCSoqIHB1c2ggaW5ib3VuZCBkb29yYmVsbCB0ZWxsIGlvcCwgZHJpdmVyIGRh
dGEgd3JpdGUgb2sKIAkJKiogYW5kIHdhaXQgcmVwbHkgb24gbmV4dCBod2ludGVycnVwdCBmb3Ig
bmV4dCBRYnVmZmVyIHBvc3QKIAkJKi8KLQkJd3JpdGVsKEFSQ01TUl9EUlYySU9QX0RBVEFfV1JJ
VEVfT0ssIHJlZy0+ZHJ2MmlvcF9kb29yYmVsbCk7CisJCXdyaXRlbChBUkNNU1JfRFJWMklPUF9E
QVRBX1dSSVRFX09LLAorCQkJcmVnLT5kcnYyaW9wX2Rvb3JiZWxsKTsKIAkJfQogCQlicmVhazsK
IAljYXNlIEFDQl9BREFQVEVSX1RZUEVfQzogewpAQCAtMTMxNywxMyArMTkyMywyMSBAQCBzdGF0
aWMgdm9pZCBhcmNtc3JfaW9wX21lc3NhZ2Vfd3JvdGUoc3RyCiAJCSoqIHB1c2ggaW5ib3VuZCBk
b29yYmVsbCB0ZWxsIGlvcCwgZHJpdmVyIGRhdGEgd3JpdGUgb2sKIAkJKiogYW5kIHdhaXQgcmVw
bHkgb24gbmV4dCBod2ludGVycnVwdCBmb3IgbmV4dCBRYnVmZmVyIHBvc3QKIAkJKi8KLQkJd3Jp
dGVsKEFSQ01TUl9IQkNNVV9EUlYySU9QX0RBVEFfV1JJVEVfT0ssICZyZWctPmluYm91bmRfZG9v
cmJlbGwpOworCQl3cml0ZWwoQVJDTVNSX0hCQ01VX0RSVjJJT1BfREFUQV9XUklURV9PSywKKwkJ
CSZyZWctPmluYm91bmRfZG9vcmJlbGwpOwogCQl9CiAJCWJyZWFrOworCWNhc2UgQUNCX0FEQVBU
RVJfVFlQRV9EOiB7CisJCXN0cnVjdCBNZXNzYWdlVW5pdF9EIF9faW9tZW0gKnJlZyA9IGFjYi0+
cG11RDsKKwkJd3JpdGVsKEFSQ01TUl9BUkMxMjE0X0RSVjJJT1BfREFUQV9JTl9SRUFEWSwKKwkJ
CXJlZy0+aW5ib3VuZF9kb29yYmVsbCk7CisJCWJyZWFrOworCX0KIAl9CiB9CiAKLXN0cnVjdCBR
QlVGRkVSIF9faW9tZW0gKmFyY21zcl9nZXRfaW9wX3JxYnVmZmVyKHN0cnVjdCBBZGFwdGVyQ29u
dHJvbEJsb2NrICphY2IpCitzdHJ1Y3QgUUJVRkZFUiBfX2lvbWVtCisqYXJjbXNyX2dldF9pb3Bf
cnFidWZmZXIoc3RydWN0IEFkYXB0ZXJDb250cm9sQmxvY2sgKmFjYikKIHsKIAlzdHJ1Y3QgUUJV
RkZFUiBfX2lvbWVtICpxYnVmZmVyID0gTlVMTDsKIAlzd2l0Y2ggKGFjYi0+YWRhcHRlcl90eXBl
KSB7CkBAIC0xMzM1LDE0NiArMTk0OSwyOTQgQEAgc3RydWN0IFFCVUZGRVIgX19pb21lbSAqYXJj
bXNyX2dldF9pb3BfcgogCQlicmVhazsKIAogCWNhc2UgQUNCX0FEQVBURVJfVFlQRV9COiB7Ci0J
CXN0cnVjdCBNZXNzYWdlVW5pdF9CICpyZWcgPSBhY2ItPnBtdUI7CisJCXN0cnVjdCBNZXNzYWdl
VW5pdF9CIF9faW9tZW0gKnJlZyA9IGFjYi0+cG11QjsKIAkJcWJ1ZmZlciA9IChzdHJ1Y3QgUUJV
RkZFUiBfX2lvbWVtICopcmVnLT5tZXNzYWdlX3JidWZmZXI7CiAJCX0KIAkJYnJlYWs7CiAJY2Fz
ZSBBQ0JfQURBUFRFUl9UWVBFX0M6IHsKLQkJc3RydWN0IE1lc3NhZ2VVbml0X0MgKnBoYmNtdSA9
IChzdHJ1Y3QgTWVzc2FnZVVuaXRfQyAqKWFjYi0+cG11QzsKLQkJcWJ1ZmZlciA9IChzdHJ1Y3Qg
UUJVRkZFUiBfX2lvbWVtICopJnBoYmNtdS0+bWVzc2FnZV9yYnVmZmVyOworCQlzdHJ1Y3QgTWVz
c2FnZVVuaXRfQyBfX2lvbWVtICpyZWcgPSBhY2ItPnBtdUM7CisJCXFidWZmZXIgPSAoc3RydWN0
IFFCVUZGRVIgX19pb21lbSAqKSZyZWctPm1lc3NhZ2VfcmJ1ZmZlcjsKIAkJfQorCQlicmVhazsK
KwljYXNlIEFDQl9BREFQVEVSX1RZUEVfRDogeworCQlzdHJ1Y3QgTWVzc2FnZVVuaXRfRCBfX2lv
bWVtICpyZWcgPSBhY2ItPnBtdUQ7CisJCXFidWZmZXIgPSAoc3RydWN0IFFCVUZGRVIgX19pb21l
bSAqKXJlZy0+bWVzc2FnZV9yYnVmZmVyOworCQlicmVhazsKKwl9CiAJfQogCXJldHVybiBxYnVm
ZmVyOwogfQogCi1zdGF0aWMgc3RydWN0IFFCVUZGRVIgX19pb21lbSAqYXJjbXNyX2dldF9pb3Bf
d3FidWZmZXIoc3RydWN0IEFkYXB0ZXJDb250cm9sQmxvY2sgKmFjYikKK3N0cnVjdCBRQlVGRkVS
IF9faW9tZW0KKyphcmNtc3JfZ2V0X2lvcF93cWJ1ZmZlcihzdHJ1Y3QgQWRhcHRlckNvbnRyb2xC
bG9jayAqYWNiKQogewogCXN0cnVjdCBRQlVGRkVSIF9faW9tZW0gKnBxYnVmZmVyID0gTlVMTDsK
IAlzd2l0Y2ggKGFjYi0+YWRhcHRlcl90eXBlKSB7CiAKIAljYXNlIEFDQl9BREFQVEVSX1RZUEVf
QTogewogCQlzdHJ1Y3QgTWVzc2FnZVVuaXRfQSBfX2lvbWVtICpyZWcgPSBhY2ItPnBtdUE7Ci0J
CXBxYnVmZmVyID0gKHN0cnVjdCBRQlVGRkVSIF9faW9tZW0gKikgJnJlZy0+bWVzc2FnZV93YnVm
ZmVyOworCQlwcWJ1ZmZlciA9IChzdHJ1Y3QgUUJVRkZFUiBfX2lvbWVtICopJnJlZy0+bWVzc2Fn
ZV93YnVmZmVyOwogCQl9CiAJCWJyZWFrOwogCiAJY2FzZSBBQ0JfQURBUFRFUl9UWVBFX0I6IHsK
LQkJc3RydWN0IE1lc3NhZ2VVbml0X0IgICpyZWcgPSBhY2ItPnBtdUI7CisJCXN0cnVjdCBNZXNz
YWdlVW5pdF9CICBfX2lvbWVtICpyZWcgPSBhY2ItPnBtdUI7CiAJCXBxYnVmZmVyID0gKHN0cnVj
dCBRQlVGRkVSIF9faW9tZW0gKilyZWctPm1lc3NhZ2Vfd2J1ZmZlcjsKIAkJfQogCQlicmVhazsK
IAljYXNlIEFDQl9BREFQVEVSX1RZUEVfQzogewotCQlzdHJ1Y3QgTWVzc2FnZVVuaXRfQyAqcmVn
ID0gKHN0cnVjdCBNZXNzYWdlVW5pdF9DICopYWNiLT5wbXVDOworCQlzdHJ1Y3QgTWVzc2FnZVVu
aXRfQyBfX2lvbWVtICpyZWcgPSBhY2ItPnBtdUM7CiAJCXBxYnVmZmVyID0gKHN0cnVjdCBRQlVG
RkVSIF9faW9tZW0gKikmcmVnLT5tZXNzYWdlX3didWZmZXI7CisJCX0KKwkJYnJlYWs7CisJY2Fz
ZSBBQ0JfQURBUFRFUl9UWVBFX0Q6IHsKKwkJc3RydWN0IE1lc3NhZ2VVbml0X0QgX19pb21lbSAq
cmVnID0gYWNiLT5wbXVEOworCQlwcWJ1ZmZlciA9IChzdHJ1Y3QgUUJVRkZFUiBfX2lvbWVtICop
cmVnLT5tZXNzYWdlX3didWZmZXI7CisJCWJyZWFrOwogCX0KLQogCX0KIAlyZXR1cm4gcHFidWZm
ZXI7CiB9CiAKLXN0YXRpYyB2b2lkIGFyY21zcl9pb3AyZHJ2X2RhdGFfd3JvdGVfaGFuZGxlKHN0
cnVjdCBBZGFwdGVyQ29udHJvbEJsb2NrICphY2IpCi17Ci0Jc3RydWN0IFFCVUZGRVIgX19pb21l
bSAqcHJidWZmZXI7Ci0Jc3RydWN0IFFCVUZGRVIgKnBRYnVmZmVyOworc3RhdGljIHVpbnQzMl90
CithcmNtc3JfUmVhZF9pb3BfcnFidWZmZXJfaW5fRFdPUkQoc3RydWN0IEFkYXB0ZXJDb250cm9s
QmxvY2sgKmFjYiwKKwlzdHJ1Y3QgUUJVRkZFUiBfX2lvbWVtICpwcmJ1ZmZlcikgeworCisJdWlu
dDhfdCAqcFFidWZmZXI7CisJdWludDhfdCAqYnVmMSA9IDA7CisJdWludDMyX3QgX19pb21lbSAq
aW9wX2RhdGE7CisJdWludDMyX3QgaW9wX2xlbiwgZGF0YV9sZW4sICpidWYyID0gMDsKKworCWlv
cF9kYXRhID0gKHVpbnQzMl90ICopcHJidWZmZXItPmRhdGE7CisJaW9wX2xlbiA9IHJlYWRsKCZw
cmJ1ZmZlci0+ZGF0YV9sZW4pOworCWlmIChpb3BfbGVuID4gMCkgeworCQlidWYxID0gKHVpbnQ4
X3QgKilrbWFsbG9jKDEyOCwgR0ZQX0FUT01JQyk7CisJCWJ1ZjIgPSAodWludDMyX3QgKilidWYx
OworCQlpZiAoYnVmMSA9PSBOVUxMKQorCQkJcmV0dXJuIDA7CisJCWRhdGFfbGVuID0gaW9wX2xl
bjsKKwkJd2hpbGUgKGRhdGFfbGVuID49IDQpIHsKKwkJCSpidWYyKysgPSAqaW9wX2RhdGErKzsK
KwkJCWRhdGFfbGVuIC09IDQ7CisJCX0KKwkJaWYgKGRhdGFfbGVuKQorCQkJKmJ1ZjIgPSAqaW9w
X2RhdGE7CisJCWJ1ZjIgPSAodWludDMyX3QgKilidWYxOworCX0KKwl3aGlsZSAoaW9wX2xlbiA+
IDApIHsKKwkJcFFidWZmZXIgPSAmYWNiLT5ycWJ1ZmZlclthY2ItPnJxYnVmX2xhc3RpbmRleF07
CisJCSpwUWJ1ZmZlciA9ICpidWYxOworCQlhY2ItPnJxYnVmX2xhc3RpbmRleCsrOworCQkvKiBp
ZiBsYXN0LCBpbmRleCBudW1iZXIgc2V0IGl0IHRvIDAgKi8KKwkJYWNiLT5ycWJ1Zl9sYXN0aW5k
ZXggJT0gQVJDTVNSX01BWF9RQlVGRkVSOworCQlidWYxKys7CisJCWlvcF9sZW4tLTsKKwl9CisJ
aWYgKGJ1ZjIpCisJCWtmcmVlKChjb25zdCB2b2lkICopYnVmMik7CisJLyogbGV0IElPUCBrbm93
IGRhdGEgaGFzIGJlZW4gcmVhZCAqLworCWFyY21zcl9pb3BfbWVzc2FnZV9yZWFkKGFjYik7CisJ
cmV0dXJuIDE7Cit9CisKK3VpbnQzMl90CithcmNtc3JfUmVhZF9pb3BfcnFidWZmZXJfZGF0YShz
dHJ1Y3QgQWRhcHRlckNvbnRyb2xCbG9jayAqYWNiLAorCXN0cnVjdCBRQlVGRkVSIF9faW9tZW0g
KnByYnVmZmVyKSB7CisKKwl1aW50OF90ICpwUWJ1ZmZlcjsKIAl1aW50OF90IF9faW9tZW0gKmlv
cF9kYXRhOwotCWludDMyX3QgbXlfZW1wdHlfbGVuLCBpb3BfbGVuLCBycWJ1Zl9maXJzdGluZGV4
LCBycWJ1Zl9sYXN0aW5kZXg7Ci0JcnFidWZfbGFzdGluZGV4ID0gYWNiLT5ycWJ1Zl9sYXN0aW5k
ZXg7Ci0JcnFidWZfZmlyc3RpbmRleCA9IGFjYi0+cnFidWZfZmlyc3RpbmRleDsKLQlwcmJ1ZmZl
ciA9IGFyY21zcl9nZXRfaW9wX3JxYnVmZmVyKGFjYik7Ci0JaW9wX2RhdGEgPSAodWludDhfdCBf
X2lvbWVtICopcHJidWZmZXItPmRhdGE7Ci0JaW9wX2xlbiA9IHByYnVmZmVyLT5kYXRhX2xlbjsK
LQlteV9lbXB0eV9sZW4gPSAocnFidWZfZmlyc3RpbmRleCAtIHJxYnVmX2xhc3RpbmRleCAtIDEp
ICYgKEFSQ01TUl9NQVhfUUJVRkZFUiAtIDEpOwotCi0JaWYgKG15X2VtcHR5X2xlbiA+PSBpb3Bf
bGVuKQotCXsKLQkJd2hpbGUgKGlvcF9sZW4gPiAwKSB7Ci0JCQlwUWJ1ZmZlciA9IChzdHJ1Y3Qg
UUJVRkZFUiAqKSZhY2ItPnJxYnVmZmVyW3JxYnVmX2xhc3RpbmRleF07Ci0JCQltZW1jcHkocFFi
dWZmZXIsIGlvcF9kYXRhLCAxKTsKLQkJCXJxYnVmX2xhc3RpbmRleCsrOwotCQkJcnFidWZfbGFz
dGluZGV4ICU9IEFSQ01TUl9NQVhfUUJVRkZFUjsKLQkJCWlvcF9kYXRhKys7Ci0JCQlpb3BfbGVu
LS07Ci0JCX0KLQkJYWNiLT5ycWJ1Zl9sYXN0aW5kZXggPSBycWJ1Zl9sYXN0aW5kZXg7Ci0JCWFy
Y21zcl9pb3BfbWVzc2FnZV9yZWFkKGFjYik7CisJdWludDMyX3QgaW9wX2xlbjsKKworCWlmIChh
Y2ItPmFkYXB0ZXJfdHlwZSAmIChBQ0JfQURBUFRFUl9UWVBFX0MgfCBBQ0JfQURBUFRFUl9UWVBF
X0QpKQorCQlyZXR1cm4gYXJjbXNyX1JlYWRfaW9wX3JxYnVmZmVyX2luX0RXT1JEKGFjYiwgcHJi
dWZmZXIpOworCisJaW9wX2RhdGEgPSAodWludDhfdCAqKXByYnVmZmVyLT5kYXRhOworCWlvcF9s
ZW4gPSByZWFkbCgmcHJidWZmZXItPmRhdGFfbGVuKTsKKwl3aGlsZSAoaW9wX2xlbiA+IDApIHsK
KwkJcFFidWZmZXIgPSAmYWNiLT5ycWJ1ZmZlclthY2ItPnJxYnVmX2xhc3RpbmRleF07CisJCSpw
UWJ1ZmZlciA9ICppb3BfZGF0YTsKKwkJYWNiLT5ycWJ1Zl9sYXN0aW5kZXgrKzsKKwkJYWNiLT5y
cWJ1Zl9sYXN0aW5kZXggJT0gQVJDTVNSX01BWF9RQlVGRkVSOworCQlpb3BfZGF0YSsrOworCQlp
b3BfbGVuLS07CiAJfQorCWFyY21zcl9pb3BfbWVzc2FnZV9yZWFkKGFjYik7CisJcmV0dXJuIDE7
Cit9CisKK3ZvaWQKK2FyY21zcl9pb3AyZHJ2X2RhdGFfd3JvdGVfaGFuZGxlKHN0cnVjdCBBZGFw
dGVyQ29udHJvbEJsb2NrICphY2IpCit7CisJdW5zaWduZWQgbG9uZyBmbGFnczsKKwlzdHJ1Y3Qg
UUJVRkZFUiBfX2lvbWVtICAqcHJidWZmZXI7CisJaW50MzJfdCBidWZfZW1wdHlfbGVuOwogCi0J
ZWxzZSB7CisJc3Bpbl9sb2NrX2lycXNhdmUoJmFjYi0+cnFidWZmZXJfbG9jaywgZmxhZ3MpOwor
CXByYnVmZmVyID0gYXJjbXNyX2dldF9pb3BfcnFidWZmZXIoYWNiKTsKKwlidWZfZW1wdHlfbGVu
ID0gKGFjYi0+cnFidWZfbGFzdGluZGV4IC0gYWNiLT5ycWJ1Zl9maXJzdGluZGV4IC0gMSkgJgor
CQkoQVJDTVNSX01BWF9RQlVGRkVSIC0gMSk7CisJaWYgKGJ1Zl9lbXB0eV9sZW4gPj0gcHJidWZm
ZXItPmRhdGFfbGVuKSB7CisJCWlmIChhcmNtc3JfUmVhZF9pb3BfcnFidWZmZXJfZGF0YShhY2Is
IHByYnVmZmVyKSA9PSAwKQorCQkJYWNiLT5hY2JfZmxhZ3MgfD0gQUNCX0ZfSU9QREFUQV9PVkVS
RkxPVzsKKwl9IGVsc2UKIAkJYWNiLT5hY2JfZmxhZ3MgfD0gQUNCX0ZfSU9QREFUQV9PVkVSRkxP
VzsKLQl9CisJc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSgmYWNiLT5ycWJ1ZmZlcl9sb2NrLCBmbGFn
cyk7CiB9CiAKLXN0YXRpYyB2b2lkIGFyY21zcl9pb3AyZHJ2X2RhdGFfcmVhZF9oYW5kbGUoc3Ry
dWN0IEFkYXB0ZXJDb250cm9sQmxvY2sgKmFjYikKK3N0YXRpYyB2b2lkCithcmNtc3Jfd3JpdGVf
aW9jdGxkYXRhMmlvcF9pbl9EV09SRChzdHJ1Y3QgQWRhcHRlckNvbnRyb2xCbG9jayAqYWNiKQog
ewotCWFjYi0+YWNiX2ZsYWdzIHw9IEFDQl9GX01FU1NBR0VfV1FCVUZGRVJfUkVBREVEOwotCWlm
IChhY2ItPndxYnVmX2ZpcnN0aW5kZXggIT0gYWNiLT53cWJ1Zl9sYXN0aW5kZXgpIHsKLQkJdWlu
dDhfdCAqcFFidWZmZXI7Ci0JCXN0cnVjdCBRQlVGRkVSIF9faW9tZW0gKnB3YnVmZmVyOwotCQl1
aW50OF90IF9faW9tZW0gKmlvcF9kYXRhOwotCQlpbnQzMl90IGFsbHhmZXJfbGVuID0gMDsKKwl1
aW50OF90ICpwUWJ1ZmZlcjsKKwlzdHJ1Y3QgUUJVRkZFUiBfX2lvbWVtICpwd2J1ZmZlcjsKKwl1
aW50OF90ICpidWYxID0gMDsKKwl1aW50MzJfdCBfX2lvbWVtICppb3BfZGF0YTsKKwl1aW50MzJf
dCBhbGx4ZmVyX2xlbiA9IDAsIGRhdGFfbGVuLCAqYnVmMiA9IDA7CisKKwlpZiAoYWNiLT5hY2Jf
ZmxhZ3MgJiBBQ0JfRl9NRVNTQUdFX1dRQlVGRkVSX1JFQURFRCkgeworCQlidWYxID0gKHVpbnQ4
X3QgKilrbWFsbG9jKDEyOCwgR0ZQX0FUT01JQyk7CisJCWJ1ZjIgPSAodWludDMyX3QgKilidWYx
OworCQlpZiAoYnVmMSA9PSBOVUxMKQorCQkJcmV0dXJuOwogCiAJCWFjYi0+YWNiX2ZsYWdzICY9
ICh+QUNCX0ZfTUVTU0FHRV9XUUJVRkZFUl9SRUFERUQpOwogCQlwd2J1ZmZlciA9IGFyY21zcl9n
ZXRfaW9wX3dxYnVmZmVyKGFjYik7Ci0JCWlvcF9kYXRhID0gKHVpbnQ4X3QgX19pb21lbSAqKXB3
YnVmZmVyLT5kYXRhOworCQlpb3BfZGF0YSA9ICh1aW50MzJfdCAqKXB3YnVmZmVyLT5kYXRhOwor
CQl3aGlsZSAoKGFjYi0+d3FidWZfZmlyc3RpbmRleCAhPSBhY2ItPndxYnVmX2xhc3RpbmRleCkK
KwkJCSYmIChhbGx4ZmVyX2xlbiA8IDEyNCkpIHsKKwkJCXBRYnVmZmVyID0gJmFjYi0+d3FidWZm
ZXJbYWNiLT53cWJ1Zl9maXJzdGluZGV4XTsKKwkJCSpidWYxID0gKnBRYnVmZmVyOworCQkJYWNi
LT53cWJ1Zl9maXJzdGluZGV4Kys7CisJCQlhY2ItPndxYnVmX2ZpcnN0aW5kZXggJT0gQVJDTVNS
X01BWF9RQlVGRkVSOworCQkJYnVmMSsrOworCQkJYWxseGZlcl9sZW4rKzsKKwkJfQorCQlkYXRh
X2xlbiA9IGFsbHhmZXJfbGVuOworCQlidWYxID0gKHVpbnQ4X3QgKilidWYyOworCQl3aGlsZSAo
ZGF0YV9sZW4gPj0gNCkgeworCQkJKmlvcF9kYXRhKysgPSAqYnVmMisrOworCQkJZGF0YV9sZW4g
LT0gNDsKKwkJfQorCQlpZiAoZGF0YV9sZW4pCisJCQkqaW9wX2RhdGEgPSAqYnVmMjsKKwkJd3Jp
dGVsKGFsbHhmZXJfbGVuLCAmcHdidWZmZXItPmRhdGFfbGVuKTsKKwkJa2ZyZWUoKGNvbnN0IHZv
aWQgKilidWYxKTsKKwkJYXJjbXNyX2lvcF9tZXNzYWdlX3dyb3RlKGFjYik7CisJfQorfQogCi0J
CXdoaWxlICgoYWNiLT53cWJ1Zl9maXJzdGluZGV4ICE9IGFjYi0+d3FidWZfbGFzdGluZGV4KSAm
JiBcCi0JCQkJCQkJKGFsbHhmZXJfbGVuIDwgMTI0KSkgewordm9pZAorYXJjbXNyX3dyaXRlX2lv
Y3RsZGF0YTJpb3Aoc3RydWN0IEFkYXB0ZXJDb250cm9sQmxvY2sgKmFjYikKK3sKKwl1aW50OF90
ICpwUWJ1ZmZlcjsKKwlzdHJ1Y3QgUUJVRkZFUiBfX2lvbWVtICpwd2J1ZmZlcjsKKwl1aW50OF90
IF9faW9tZW0gKmlvcF9kYXRhOworCWludDMyX3QgYWxseGZlcl9sZW4gPSAwOworCisJaWYgKGFj
Yi0+YWRhcHRlcl90eXBlICYgKEFDQl9BREFQVEVSX1RZUEVfQyB8IEFDQl9BREFQVEVSX1RZUEVf
RCkpIHsKKwkJYXJjbXNyX3dyaXRlX2lvY3RsZGF0YTJpb3BfaW5fRFdPUkQoYWNiKTsKKwkJcmV0
dXJuOworCX0KKwlpZiAoYWNiLT5hY2JfZmxhZ3MgJiBBQ0JfRl9NRVNTQUdFX1dRQlVGRkVSX1JF
QURFRCkgeworCQlhY2ItPmFjYl9mbGFncyAmPSAofkFDQl9GX01FU1NBR0VfV1FCVUZGRVJfUkVB
REVEKTsKKwkJcHdidWZmZXIgPSBhcmNtc3JfZ2V0X2lvcF93cWJ1ZmZlcihhY2IpOworCQlpb3Bf
ZGF0YSA9ICh1aW50OF90ICopcHdidWZmZXItPmRhdGE7CisJCXdoaWxlICgoYWNiLT53cWJ1Zl9m
aXJzdGluZGV4ICE9IGFjYi0+d3FidWZfbGFzdGluZGV4KQorCQkJJiYgKGFsbHhmZXJfbGVuIDwg
MTI0KSkgewogCQkJcFFidWZmZXIgPSAmYWNiLT53cWJ1ZmZlclthY2ItPndxYnVmX2ZpcnN0aW5k
ZXhdOwotCQkJbWVtY3B5KGlvcF9kYXRhLCBwUWJ1ZmZlciwgMSk7CisJCQkqaW9wX2RhdGEgPSAq
cFFidWZmZXI7CiAJCQlhY2ItPndxYnVmX2ZpcnN0aW5kZXgrKzsKIAkJCWFjYi0+d3FidWZfZmly
c3RpbmRleCAlPSBBUkNNU1JfTUFYX1FCVUZGRVI7CiAJCQlpb3BfZGF0YSsrOwogCQkJYWxseGZl
cl9sZW4rKzsKIAkJfQotCQlwd2J1ZmZlci0+ZGF0YV9sZW4gPSBhbGx4ZmVyX2xlbjsKLQorCQl3
cml0ZWwoYWxseGZlcl9sZW4sICZwd2J1ZmZlci0+ZGF0YV9sZW4pOwogCQlhcmNtc3JfaW9wX21l
c3NhZ2Vfd3JvdGUoYWNiKTsKIAl9Cit9CisKK3ZvaWQKK2FyY21zcl9pb3AyZHJ2X2RhdGFfcmVh
ZF9oYW5kbGUoc3RydWN0IEFkYXB0ZXJDb250cm9sQmxvY2sgKmFjYikKK3sKKwl1bnNpZ25lZCBs
b25nIGZsYWdzOwogCi0JaWYgKGFjYi0+d3FidWZfZmlyc3RpbmRleCA9PSBhY2ItPndxYnVmX2xh
c3RpbmRleCkgeworCXNwaW5fbG9ja19pcnFzYXZlKCZhY2ItPndxYnVmZmVyX2xvY2ssIGZsYWdz
KTsKKwlhY2ItPmFjYl9mbGFncyB8PSBBQ0JfRl9NRVNTQUdFX1dRQlVGRkVSX1JFQURFRDsKKwlp
ZiAoYWNiLT53cWJ1Zl9maXJzdGluZGV4ICE9IGFjYi0+d3FidWZfbGFzdGluZGV4KQorCQlhcmNt
c3Jfd3JpdGVfaW9jdGxkYXRhMmlvcChhY2IpOworCWlmIChhY2ItPndxYnVmX2ZpcnN0aW5kZXgg
PT0gYWNiLT53cWJ1Zl9sYXN0aW5kZXgpCiAJCWFjYi0+YWNiX2ZsYWdzIHw9IEFDQl9GX01FU1NB
R0VfV1FCVUZGRVJfQ0xFQVJFRDsKLQl9CisJc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSgmYWNiLT53
cWJ1ZmZlcl9sb2NrLCBmbGFncyk7CiB9CiAKLXN0YXRpYyB2b2lkIGFyY21zcl9oYmFfZG9vcmJl
bGxfaXNyKHN0cnVjdCBBZGFwdGVyQ29udHJvbEJsb2NrICphY2IpCitzdGF0aWMgdm9pZAorYXJj
bXNyX2hiYUFfZG9vcmJlbGxfaXNyKHN0cnVjdCBBZGFwdGVyQ29udHJvbEJsb2NrICphY2IpCiB7
CiAJdWludDMyX3Qgb3V0Ym91bmRfZG9vcmJlbGw7Ci0Jc3RydWN0IE1lc3NhZ2VVbml0X0EgX19p
b21lbSAqcmVnID0gYWNiLT5wbXVBOworCXN0cnVjdCBNZXNzYWdlVW5pdF9BIF9faW9tZW0gKnJl
ZyAgPSBhY2ItPnBtdUE7CiAJb3V0Ym91bmRfZG9vcmJlbGwgPSByZWFkbCgmcmVnLT5vdXRib3Vu
ZF9kb29yYmVsbCk7Ci0Jd3JpdGVsKG91dGJvdW5kX2Rvb3JiZWxsLCAmcmVnLT5vdXRib3VuZF9k
b29yYmVsbCk7Ci0JaWYgKG91dGJvdW5kX2Rvb3JiZWxsICYgQVJDTVNSX09VVEJPVU5EX0lPUDMz
MV9EQVRBX1dSSVRFX09LKSB7Ci0JCWFyY21zcl9pb3AyZHJ2X2RhdGFfd3JvdGVfaGFuZGxlKGFj
Yik7Ci0JfQotCi0JaWYgKG91dGJvdW5kX2Rvb3JiZWxsICYgQVJDTVNSX09VVEJPVU5EX0lPUDMz
MV9EQVRBX1JFQURfT0spIHsKLQkJYXJjbXNyX2lvcDJkcnZfZGF0YV9yZWFkX2hhbmRsZShhY2Ip
OwotCX0KKwlkbyB7CisJCXdyaXRlbChvdXRib3VuZF9kb29yYmVsbCwgJnJlZy0+b3V0Ym91bmRf
ZG9vcmJlbGwpOworCQlpZiAob3V0Ym91bmRfZG9vcmJlbGwgJgorCQkJQVJDTVNSX09VVEJPVU5E
X0lPUDMzMV9EQVRBX1dSSVRFX09LKQorCQkJYXJjbXNyX2lvcDJkcnZfZGF0YV93cm90ZV9oYW5k
bGUoYWNiKTsKKwkJaWYgKG91dGJvdW5kX2Rvb3JiZWxsICYKKwkJCUFSQ01TUl9PVVRCT1VORF9J
T1AzMzFfREFUQV9SRUFEX09LKQorCQkJYXJjbXNyX2lvcDJkcnZfZGF0YV9yZWFkX2hhbmRsZShh
Y2IpOworCQlvdXRib3VuZF9kb29yYmVsbCA9IHJlYWRsKCZyZWctPm91dGJvdW5kX2Rvb3JiZWxs
KTsKKwl9IHdoaWxlIChvdXRib3VuZF9kb29yYmVsbCAmCisJCShBUkNNU1JfT1VUQk9VTkRfSU9Q
MzMxX0RBVEFfV1JJVEVfT0sKKwkJfCBBUkNNU1JfT1VUQk9VTkRfSU9QMzMxX0RBVEFfUkVBRF9P
SykpOwogfQotc3RhdGljIHZvaWQgYXJjbXNyX2hiY19kb29yYmVsbF9pc3Ioc3RydWN0IEFkYXB0
ZXJDb250cm9sQmxvY2sgKnBBQ0IpCitzdGF0aWMgdm9pZAorYXJjbXNyX2hiYUNfZG9vcmJlbGxf
aXNyKHN0cnVjdCBBZGFwdGVyQ29udHJvbEJsb2NrICpwQUNCKQogewogCXVpbnQzMl90IG91dGJv
dW5kX2Rvb3JiZWxsOwotCXN0cnVjdCBNZXNzYWdlVW5pdF9DICpyZWcgPSAoc3RydWN0IE1lc3Nh
Z2VVbml0X0MgKilwQUNCLT5wbXVDOwotCS8qCi0JKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKgotCSoqICBNYXliZSBoZXJl
IHdlIG5lZWQgdG8gY2hlY2sgd3JxYnVmZmVyX2xvY2sgaXMgbG9jayBvciBub3QKLQkqKiAgRE9P
UkJFTEw6IGRpbiEgZG9uIQotCSoqICBjaGVjayBpZiB0aGVyZSBhcmUgYW55IG1haWwgbmVlZCB0
byBwYWNrIGZyb20gZmlybXdhcmUKLQkqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqCi0JKi8KKwlzdHJ1Y3QgTWVzc2FnZVVu
aXRfQyBfX2lvbWVtICpyZWcgPSBwQUNCLT5wbXVDOwogCW91dGJvdW5kX2Rvb3JiZWxsID0gcmVh
ZGwoJnJlZy0+b3V0Ym91bmRfZG9vcmJlbGwpOwotCXdyaXRlbChvdXRib3VuZF9kb29yYmVsbCwg
JnJlZy0+b3V0Ym91bmRfZG9vcmJlbGxfY2xlYXIpOy8qY2xlYXIgaW50ZXJydXB0Ki8KLQlpZiAo
b3V0Ym91bmRfZG9vcmJlbGwgJiBBUkNNU1JfSEJDTVVfSU9QMkRSVl9EQVRBX1dSSVRFX09LKSB7
Ci0JCWFyY21zcl9pb3AyZHJ2X2RhdGFfd3JvdGVfaGFuZGxlKHBBQ0IpOwotCX0KLQlpZiAob3V0
Ym91bmRfZG9vcmJlbGwgJiBBUkNNU1JfSEJDTVVfSU9QMkRSVl9EQVRBX1JFQURfT0spIHsKLQkJ
YXJjbXNyX2lvcDJkcnZfZGF0YV9yZWFkX2hhbmRsZShwQUNCKTsKLQl9Ci0JaWYgKG91dGJvdW5k
X2Rvb3JiZWxsICYgQVJDTVNSX0hCQ01VX0lPUDJEUlZfTUVTU0FHRV9DTURfRE9ORSkgewotCQlh
cmNtc3JfaGJjX21lc3NhZ2VfaXNyKHBBQ0IpOyAgICAvKiBtZXNzZW5nZXIgb2YgImRyaXZlciB0
byBpb3AgY29tbWFuZHMiICovCi0JfQotCXJldHVybjsKKwlkbyB7CisJCWlmIChvdXRib3VuZF9k
b29yYmVsbCAmCisJCQlBUkNNU1JfSEJDTVVfSU9QMkRSVl9NRVNTQUdFX0NNRF9ET05FKQorCQkJ
YXJjbXNyX2hiYUNfbWVzc2FnZV9pc3IocEFDQik7CisJCXdyaXRlbChvdXRib3VuZF9kb29yYmVs
bCwgJnJlZy0+b3V0Ym91bmRfZG9vcmJlbGxfY2xlYXIpOworCQlyZWFkbCgmcmVnLT5vdXRib3Vu
ZF9kb29yYmVsbF9jbGVhcik7CisJCWlmIChvdXRib3VuZF9kb29yYmVsbCAmCisJCQlBUkNNU1Jf
SEJDTVVfSU9QMkRSVl9EQVRBX1dSSVRFX09LKQorCQkJYXJjbXNyX2lvcDJkcnZfZGF0YV93cm90
ZV9oYW5kbGUocEFDQik7CisJCWlmIChvdXRib3VuZF9kb29yYmVsbCAmCisJCQlBUkNNU1JfSEJD
TVVfSU9QMkRSVl9EQVRBX1JFQURfT0spCisJCQlhcmNtc3JfaW9wMmRydl9kYXRhX3JlYWRfaGFu
ZGxlKHBBQ0IpOworCQlvdXRib3VuZF9kb29yYmVsbCA9IHJlYWRsKCZyZWctPm91dGJvdW5kX2Rv
b3JiZWxsKTsKKwl9IHdoaWxlIChvdXRib3VuZF9kb29yYmVsbCAmIChBUkNNU1JfSEJDTVVfSU9Q
MkRSVl9EQVRBX1dSSVRFX09LCisJCXwgQVJDTVNSX0hCQ01VX0lPUDJEUlZfREFUQV9SRUFEX09L
CisJCXwgQVJDTVNSX0hCQ01VX0lPUDJEUlZfTUVTU0FHRV9DTURfRE9ORSkpOworfQorCitzdGF0
aWMgdm9pZAorYXJjbXNyX2hiYURfZG9vcmJlbGxfaXNyKHN0cnVjdCBBZGFwdGVyQ29udHJvbEJs
b2NrICpwQUNCKQoreworCXVpbnQzMl90IG91dGJvdW5kX2Rvb3JiZWxsOworCXN0cnVjdCBNZXNz
YWdlVW5pdF9EIF9faW9tZW0gKnBtdSA9IHBBQ0ItPnBtdUQ7CisKKwlvdXRib3VuZF9kb29yYmVs
bCA9IHJlYWRsKHBtdS0+b3V0Ym91bmRfZG9vcmJlbGwpOworCWRvIHsKKwkJd3JpdGVsKG91dGJv
dW5kX2Rvb3JiZWxsLCBwbXUtPm91dGJvdW5kX2Rvb3JiZWxsKTsKKwkJaWYgKG91dGJvdW5kX2Rv
b3JiZWxsICYKKwkJCUFSQ01TUl9BUkMxMjE0X0lPUDJEUlZfTUVTU0FHRV9DTURfRE9ORSkKKwkJ
CWFyY21zcl9oYmFEX21lc3NhZ2VfaXNyKHBBQ0IpOworCQlpZiAob3V0Ym91bmRfZG9vcmJlbGwg
JgorCQkJQVJDTVNSX0FSQzEyMTRfSU9QMkRSVl9EQVRBX1dSSVRFX09LKQorCQkJYXJjbXNyX2lv
cDJkcnZfZGF0YV93cm90ZV9oYW5kbGUocEFDQik7CisJCWlmIChvdXRib3VuZF9kb29yYmVsbCAm
CisJCQlBUkNNU1JfQVJDMTIxNF9JT1AyRFJWX0RBVEFfUkVBRF9PSykKKwkJCWFyY21zcl9pb3Ay
ZHJ2X2RhdGFfcmVhZF9oYW5kbGUocEFDQik7CisJCW91dGJvdW5kX2Rvb3JiZWxsID0gcmVhZGwo
cG11LT5vdXRib3VuZF9kb29yYmVsbCk7CisJfSB3aGlsZSAob3V0Ym91bmRfZG9vcmJlbGwgJiAo
QVJDTVNSX0FSQzEyMTRfSU9QMkRSVl9EQVRBX1dSSVRFX09LCisJCXwgQVJDTVNSX0FSQzEyMTRf
SU9QMkRSVl9EQVRBX1JFQURfT0sKKwkJfCBBUkNNU1JfQVJDMTIxNF9JT1AyRFJWX01FU1NBR0Vf
Q01EX0RPTkUpKTsKIH0KLXN0YXRpYyB2b2lkIGFyY21zcl9oYmFfcG9zdHF1ZXVlX2lzcihzdHJ1
Y3QgQWRhcHRlckNvbnRyb2xCbG9jayAqYWNiKQorCitzdGF0aWMgdm9pZAorYXJjbXNyX2hiYUFf
cG9zdHF1ZXVlX2lzcihzdHJ1Y3QgQWRhcHRlckNvbnRyb2xCbG9jayAqYWNiKQogewogCXVpbnQz
Ml90IGZsYWdfY2NiOwogCXN0cnVjdCBNZXNzYWdlVW5pdF9BIF9faW9tZW0gKnJlZyA9IGFjYi0+
cG11QTsKQEAgLTE0ODIsMjYgKzIyNDQsMzQgQEAgc3RhdGljIHZvaWQgYXJjbXNyX2hiYV9wb3N0
cXVldWVfaXNyKHN0cgogCXN0cnVjdCBDb21tYW5kQ29udHJvbEJsb2NrICpwQ0NCOwogCWJvb2wg
ZXJyb3I7CiAJd2hpbGUgKChmbGFnX2NjYiA9IHJlYWRsKCZyZWctPm91dGJvdW5kX3F1ZXVlcG9y
dCkpICE9IDB4RkZGRkZGRkYpIHsKLQkJcEFSQ01TUl9DREIgPSAoc3RydWN0IEFSQ01TUl9DREIg
KikoYWNiLT52aXIycGh5X29mZnNldCArIChmbGFnX2NjYiA8PCA1KSk7LypmcmFtZSBtdXN0IGJl
IDMyIGJ5dGVzIGFsaWduZWQqLwotCQlwQ0NCID0gY29udGFpbmVyX29mKHBBUkNNU1JfQ0RCLCBz
dHJ1Y3QgQ29tbWFuZENvbnRyb2xCbG9jaywgYXJjbXNyX2NkYik7Ci0JCWVycm9yID0gKGZsYWdf
Y2NiICYgQVJDTVNSX0NDQlJFUExZX0ZMQUdfRVJST1JfTU9ERTApID8gdHJ1ZSA6IGZhbHNlOwor
CQlwQVJDTVNSX0NEQiA9IChzdHJ1Y3QgQVJDTVNSX0NEQiAqKQorCQkJKGFjYi0+dmlyMnBoeV9v
ZmZzZXQgKyAoZmxhZ19jY2IgPDwgNSkpOworCQlwQ0NCID0gY29udGFpbmVyX29mKHBBUkNNU1Jf
Q0RCLAorCQkJc3RydWN0IENvbW1hbmRDb250cm9sQmxvY2ssIGFyY21zcl9jZGIpOworCQllcnJv
ciA9IChmbGFnX2NjYiAmIEFSQ01TUl9DQ0JSRVBMWV9GTEFHX0VSUk9SX01PREUwKQorCQkJPyB0
cnVlIDogZmFsc2U7CiAJCWFyY21zcl9kcmFpbl9kb25lcXVldWUoYWNiLCBwQ0NCLCBlcnJvcik7
CiAJfQogfQotc3RhdGljIHZvaWQgYXJjbXNyX2hiYl9wb3N0cXVldWVfaXNyKHN0cnVjdCBBZGFw
dGVyQ29udHJvbEJsb2NrICphY2IpCitzdGF0aWMgdm9pZAorYXJjbXNyX2hiYUJfcG9zdHF1ZXVl
X2lzcihzdHJ1Y3QgQWRhcHRlckNvbnRyb2xCbG9jayAqYWNiKQogewogCXVpbnQzMl90IGluZGV4
OwogCXVpbnQzMl90IGZsYWdfY2NiOwotCXN0cnVjdCBNZXNzYWdlVW5pdF9CICpyZWcgPSBhY2It
PnBtdUI7CisJc3RydWN0IE1lc3NhZ2VVbml0X0IgX19pb21lbSAqcmVnID0gYWNiLT5wbXVCOwog
CXN0cnVjdCBBUkNNU1JfQ0RCICpwQVJDTVNSX0NEQjsKIAlzdHJ1Y3QgQ29tbWFuZENvbnRyb2xC
bG9jayAqcENDQjsKIAlib29sIGVycm9yOwogCWluZGV4ID0gcmVnLT5kb25lcV9pbmRleDsKIAl3
aGlsZSAoKGZsYWdfY2NiID0gcmVhZGwoJnJlZy0+ZG9uZV9xYnVmZmVyW2luZGV4XSkpICE9IDAp
IHsKIAkJd3JpdGVsKDAsICZyZWctPmRvbmVfcWJ1ZmZlcltpbmRleF0pOwotCQlwQVJDTVNSX0NE
QiA9IChzdHJ1Y3QgQVJDTVNSX0NEQiAqKShhY2ItPnZpcjJwaHlfb2Zmc2V0KyhmbGFnX2NjYiA8
PCA1KSk7LypmcmFtZSBtdXN0IGJlIDMyIGJ5dGVzIGFsaWduZWQqLwotCQlwQ0NCID0gY29udGFp
bmVyX29mKHBBUkNNU1JfQ0RCLCBzdHJ1Y3QgQ29tbWFuZENvbnRyb2xCbG9jaywgYXJjbXNyX2Nk
Yik7Ci0JCWVycm9yID0gKGZsYWdfY2NiICYgQVJDTVNSX0NDQlJFUExZX0ZMQUdfRVJST1JfTU9E
RTApID8gdHJ1ZSA6IGZhbHNlOworCQlwQVJDTVNSX0NEQiA9IChzdHJ1Y3QgQVJDTVNSX0NEQiAq
KQorCQkJKGFjYi0+dmlyMnBoeV9vZmZzZXQgKyAoZmxhZ19jY2IgPDwgNSkpOworCQlwQ0NCID0g
Y29udGFpbmVyX29mKHBBUkNNU1JfQ0RCLAorCQkJc3RydWN0IENvbW1hbmRDb250cm9sQmxvY2ss
IGFyY21zcl9jZGIpOworCQllcnJvciA9IChmbGFnX2NjYiAmCisJCQlBUkNNU1JfQ0NCUkVQTFlf
RkxBR19FUlJPUl9NT0RFMCkKKwkJCT8gdHJ1ZSA6IGZhbHNlOwogCQlhcmNtc3JfZHJhaW5fZG9u
ZXF1ZXVlKGFjYiwgcENDQiwgZXJyb3IpOwogCQlpbmRleCsrOwogCQlpbmRleCAlPSBBUkNNU1Jf
TUFYX0hCQl9QT1NUUVVFVUU7CkBAIC0xNTA5LDE3OCArMjI3OSwyNTcgQEAgc3RhdGljIHZvaWQg
YXJjbXNyX2hiYl9wb3N0cXVldWVfaXNyKHN0cgogCX0KIH0KIAotc3RhdGljIHZvaWQgYXJjbXNy
X2hiY19wb3N0cXVldWVfaXNyKHN0cnVjdCBBZGFwdGVyQ29udHJvbEJsb2NrICphY2IpCitzdGF0
aWMgdm9pZAorYXJjbXNyX2hiYUNfcG9zdHF1ZXVlX2lzcihzdHJ1Y3QgQWRhcHRlckNvbnRyb2xC
bG9jayAqYWNiKQogewotCXN0cnVjdCBNZXNzYWdlVW5pdF9DICpwaGJjbXU7Ci0Jc3RydWN0IEFS
Q01TUl9DREIgKmFyY21zcl9jZGI7Ci0Jc3RydWN0IENvbW1hbmRDb250cm9sQmxvY2sgKmNjYjsK
IAl1aW50MzJfdCBmbGFnX2NjYiwgY2NiX2NkYl9waHksIHRocm90dGxpbmcgPSAwOwogCWludCBl
cnJvcjsKKwlzdHJ1Y3QgTWVzc2FnZVVuaXRfQyBfX2lvbWVtICpwaGJjbXU7CisJc3RydWN0IEFS
Q01TUl9DREIgKmFyY21zcl9jZGI7CisJc3RydWN0IENvbW1hbmRDb250cm9sQmxvY2sgKmNjYjsK
IAotCXBoYmNtdSA9IChzdHJ1Y3QgTWVzc2FnZVVuaXRfQyAqKWFjYi0+cG11QzsKKwlwaGJjbXUg
PSBhY2ItPnBtdUM7CiAJLyogYXJlY2EgY2RiIGNvbW1hbmQgZG9uZSAqLwogCS8qIFVzZSBjb3Jy
ZWN0IG9mZnNldCBhbmQgc2l6ZSBmb3Igc3luY2luZyAqLworCWRvIHsKKwkJLyogY2hlY2sgaWYg
Y29tbWFuZCBkb25lIHdpdGggbm8gZXJyb3IqLworCQlmbGFnX2NjYiA9IHJlYWRsKCZwaGJjbXUt
Pm91dGJvdW5kX3F1ZXVlcG9ydF9sb3cpOworCQljY2JfY2RiX3BoeSA9IChmbGFnX2NjYiAmIDB4
RkZGRkZGRjApOworCQlhcmNtc3JfY2RiID0gKHN0cnVjdCBBUkNNU1JfQ0RCICopKGFjYi0+dmly
MnBoeV9vZmZzZXQKKwkJCSsgY2NiX2NkYl9waHkpOworCQljY2IgPSBjb250YWluZXJfb2YoYXJj
bXNyX2NkYiwgc3RydWN0IENvbW1hbmRDb250cm9sQmxvY2ssCisJCQlhcmNtc3JfY2RiKTsKKwkJ
ZXJyb3IgPSAoZmxhZ19jY2IgJiBBUkNNU1JfQ0NCUkVQTFlfRkxBR19FUlJPUl9NT0RFMSkKKwkJ
CT8gdHJ1ZSA6IGZhbHNlOworCQkvKiBjaGVjayBpZiBjb21tYW5kIGRvbmUgd2l0aCBubyBlcnJv
ciAqLworCQlhcmNtc3JfZHJhaW5fZG9uZXF1ZXVlKGFjYiwgY2NiLCBlcnJvcik7CisJCXRocm90
dGxpbmcrKzsKKwkJaWYgKHRocm90dGxpbmcgPT0gQVJDTVNSX0hCQ19JU1JfVEhST1RUTElOR19M
RVZFTCkgeworCQkJd3JpdGVsKEFSQ01TUl9IQkNNVV9EUlYySU9QX1BPU1RRVUVVRV9USFJPVFRM
SU5HLAorCQkJCSZwaGJjbXUtPmluYm91bmRfZG9vcmJlbGwpOworCQkJdGhyb3R0bGluZyA9IDA7
CisJCX0KKwl9IHdoaWxlIChyZWFkbCgmcGhiY211LT5ob3N0X2ludF9zdGF0dXMpICYKKwkJQVJD
TVNSX0hCQ01VX09VVEJPVU5EX1BPU1RRVUVVRV9JU1IpOworfQogCi0Jd2hpbGUgKHJlYWRsKCZw
aGJjbXUtPmhvc3RfaW50X3N0YXR1cykgJgotCUFSQ01TUl9IQkNNVV9PVVRCT1VORF9QT1NUUVVF
VUVfSVNSKXsKLQkvKiBjaGVjayBpZiBjb21tYW5kIGRvbmUgd2l0aCBubyBlcnJvciovCi0JZmxh
Z19jY2IgPSByZWFkbCgmcGhiY211LT5vdXRib3VuZF9xdWV1ZXBvcnRfbG93KTsKLQljY2JfY2Ri
X3BoeSA9IChmbGFnX2NjYiAmIDB4RkZGRkZGRjApOy8qZnJhbWUgbXVzdCBiZSAzMiBieXRlcyBh
bGlnbmVkKi8KLQlhcmNtc3JfY2RiID0gKHN0cnVjdCBBUkNNU1JfQ0RCICopKGFjYi0+dmlyMnBo
eV9vZmZzZXQgKyBjY2JfY2RiX3BoeSk7Ci0JY2NiID0gY29udGFpbmVyX29mKGFyY21zcl9jZGIs
IHN0cnVjdCBDb21tYW5kQ29udHJvbEJsb2NrLCBhcmNtc3JfY2RiKTsKLQllcnJvciA9IChmbGFn
X2NjYiAmIEFSQ01TUl9DQ0JSRVBMWV9GTEFHX0VSUk9SX01PREUxKSA/IHRydWUgOiBmYWxzZTsK
LQkvKiBjaGVjayBpZiBjb21tYW5kIGRvbmUgd2l0aCBubyBlcnJvciAqLwotCWFyY21zcl9kcmFp
bl9kb25lcXVldWUoYWNiLCBjY2IsIGVycm9yKTsKLQlpZiAodGhyb3R0bGluZyA9PSBBUkNNU1Jf
SEJDX0lTUl9USFJPVFRMSU5HX0xFVkVMKSB7Ci0JCXdyaXRlbChBUkNNU1JfSEJDTVVfRFJWMklP
UF9QT1NUUVVFVUVfVEhST1RUTElORywgJnBoYmNtdS0+aW5ib3VuZF9kb29yYmVsbCk7Ci0JCWJy
ZWFrOwotCX0KLQl0aHJvdHRsaW5nKys7Ci0JfQorc3RhdGljIHZvaWQKK2FyY21zcl9oYmFEX3Bv
c3RxdWV1ZV9pc3Ioc3RydWN0IEFkYXB0ZXJDb250cm9sQmxvY2sgKmFjYikKK3sKKwl1MzIgb3V0
Ym91bmRfd3JpdGVfcG9pbnRlciwgZG9uZXFfaW5kZXgsIGluZGV4X3N0cmlwcGVkOworCXVpbnQz
Ml90IGFkZHJlc3NMb3csIGNjYl9jZGJfcGh5OworCWludCBlcnJvcjsKKwlzdHJ1Y3QgTWVzc2Fn
ZVVuaXRfRCBfX2lvbWVtICpwbXU7CisJc3RydWN0IEFSQ01TUl9DREIgKmFyY21zcl9jZGI7CisJ
c3RydWN0IENvbW1hbmRDb250cm9sQmxvY2sgKmNjYjsKKwl1bnNpZ25lZCBsb25nIGZsYWdzOwor
CisJc3Bpbl9sb2NrX2lycXNhdmUoJmFjYi0+ZG9uZXFfbG9jaywgZmxhZ3MpOworCXBtdSA9IGFj
Yi0+cG11RDsKKwlvdXRib3VuZF93cml0ZV9wb2ludGVyID0gcG11LT5kb25lX3FidWZmZXJbMF0u
YWRkcmVzc0xvdyArIDE7CisJZG9uZXFfaW5kZXggPSBwbXUtPmRvbmVxX2luZGV4OworCWlmICgo
ZG9uZXFfaW5kZXggJiAweEZGRikgIT0gKG91dGJvdW5kX3dyaXRlX3BvaW50ZXIgJiAweEZGRikp
IHsKKwkJZG8geworCQkJaWYgKGRvbmVxX2luZGV4ICYgMHg0MDAwKSB7CisJCQkJaW5kZXhfc3Ry
aXBwZWQgPSBkb25lcV9pbmRleCAmIDB4RkZGOworCQkJCWluZGV4X3N0cmlwcGVkICs9IDE7CisJ
CQkJaW5kZXhfc3RyaXBwZWQgJT0gQVJDTVNSX01BWF9BUkMxMjE0X0RPTkVRVUVVRTsKKwkJCQlw
bXUtPmRvbmVxX2luZGV4ID0gaW5kZXhfc3RyaXBwZWQKKwkJCQkJPyAoaW5kZXhfc3RyaXBwZWQg
fCAweDQwMDApIDogKGluZGV4X3N0cmlwcGVkICsgMSk7CisJCQl9IGVsc2UgeworCQkJCWluZGV4
X3N0cmlwcGVkID0gZG9uZXFfaW5kZXg7CisJCQkJaW5kZXhfc3RyaXBwZWQgKz0gMTsKKwkJCQlp
bmRleF9zdHJpcHBlZCAlPSBBUkNNU1JfTUFYX0FSQzEyMTRfRE9ORVFVRVVFOworCQkJCXBtdS0+
ZG9uZXFfaW5kZXggPSBpbmRleF9zdHJpcHBlZAorCQkJCQk/IGluZGV4X3N0cmlwcGVkIDogKChp
bmRleF9zdHJpcHBlZCB8IDB4NDAwMCkgKyAxKTsKKwkJCX0KKwkJCWRvbmVxX2luZGV4ID0gcG11
LT5kb25lcV9pbmRleDsKKwkJCWFkZHJlc3NMb3cgPQorCQkJcG11LT5kb25lX3FidWZmZXJbZG9u
ZXFfaW5kZXggJiAweEZGRl0uYWRkcmVzc0xvdzsKKwkJCWNjYl9jZGJfcGh5ID0gKGFkZHJlc3NM
b3cgJiAweEZGRkZGRkYwKTsKKwkJCWFyY21zcl9jZGIgPSAoc3RydWN0IEFSQ01TUl9DREIgKiko
YWNiLT52aXIycGh5X29mZnNldAorCQkJCSsgY2NiX2NkYl9waHkpOworCQkJY2NiID0gY29udGFp
bmVyX29mKGFyY21zcl9jZGIsCisJCQkJc3RydWN0IENvbW1hbmRDb250cm9sQmxvY2ssIGFyY21z
cl9jZGIpOworCQkJZXJyb3IgPSAoYWRkcmVzc0xvdyAmIEFSQ01TUl9DQ0JSRVBMWV9GTEFHX0VS
Uk9SX01PREUxKQorCQkJCT8gdHJ1ZSA6IGZhbHNlOworCQkJYXJjbXNyX2RyYWluX2RvbmVxdWV1
ZShhY2IsIGNjYiwgZXJyb3IpOworCQkJd3JpdGVsKGRvbmVxX2luZGV4LAorCQkJCXBtdS0+b3V0
Ym91bmRsaXN0X3JlYWRfcG9pbnRlcik7CisJCX0gd2hpbGUgKChkb25lcV9pbmRleCAmIDB4RkZG
KSAhPQorCQkob3V0Ym91bmRfd3JpdGVfcG9pbnRlciAmIDB4RkZGKSk7CisJfQorCXdyaXRlbChB
UkNNU1JfQVJDMTIxNF9PVVRCT1VORF9MSVNUX0lOVEVSUlVQVF9DTEVBUiwKKwkJcG11LT5vdXRi
b3VuZGxpc3RfaW50ZXJydXB0X2NhdXNlKTsKKwlyZWFkbChwbXUtPm91dGJvdW5kbGlzdF9pbnRl
cnJ1cHRfY2F1c2UpOworCXNwaW5fdW5sb2NrX2lycXJlc3RvcmUoJmFjYi0+ZG9uZXFfbG9jaywg
ZmxhZ3MpOwogfQotLyoKLSoqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioKLSoqIEhhbmRsZSBhIG1l
c3NhZ2UgaW50ZXJydXB0Ci0qKgotKiogVGhlIG9ubHkgbWVzc2FnZSBpbnRlcnJ1cHQgd2UgZXhw
ZWN0IGlzIGluIHJlc3BvbnNlIHRvIGEgcXVlcnkgZm9yIHRoZSBjdXJyZW50IGFkYXB0ZXIgY29u
ZmlnLiAgCi0qKiBXZSB3YW50IHRoaXMgaW4gb3JkZXIgdG8gY29tcGFyZSB0aGUgZHJpdmVtYXAg
c28gdGhhdCB3ZSBjYW4gZGV0ZWN0IG5ld2x5LWF0dGFjaGVkIGRyaXZlcy4KLSoqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioKLSovCi1zdGF0aWMgdm9pZCBhcmNtc3JfaGJhX21lc3NhZ2VfaXNyKHN0
cnVjdCBBZGFwdGVyQ29udHJvbEJsb2NrICphY2IpCisKK3N0YXRpYyB2b2lkCithcmNtc3JfaGJh
QV9tZXNzYWdlX2lzcihzdHJ1Y3QgQWRhcHRlckNvbnRyb2xCbG9jayAqYWNiKQogewotCXN0cnVj
dCBNZXNzYWdlVW5pdF9BICpyZWcgID0gYWNiLT5wbXVBOworCXN0cnVjdCBNZXNzYWdlVW5pdF9B
IF9faW9tZW0gKnJlZyAgPSBhY2ItPnBtdUE7CiAJLypjbGVhciBpbnRlcnJ1cHQgYW5kIG1lc3Nh
Z2Ugc3RhdGUqLwogCXdyaXRlbChBUkNNU1JfTVVfT1VUQk9VTkRfTUVTU0FHRTBfSU5ULCAmcmVn
LT5vdXRib3VuZF9pbnRzdGF0dXMpOwogCXNjaGVkdWxlX3dvcmsoJmFjYi0+YXJjbXNyX2RvX21l
c3NhZ2VfaXNyX2JoKTsKIH0KLXN0YXRpYyB2b2lkIGFyY21zcl9oYmJfbWVzc2FnZV9pc3Ioc3Ry
dWN0IEFkYXB0ZXJDb250cm9sQmxvY2sgKmFjYikKK3N0YXRpYyB2b2lkCithcmNtc3JfaGJhQl9t
ZXNzYWdlX2lzcihzdHJ1Y3QgQWRhcHRlckNvbnRyb2xCbG9jayAqYWNiKQogewotCXN0cnVjdCBN
ZXNzYWdlVW5pdF9CICpyZWcgID0gYWNiLT5wbXVCOworCXN0cnVjdCBNZXNzYWdlVW5pdF9CIF9f
aW9tZW0gKnJlZyAgPSBhY2ItPnBtdUI7CiAKIAkvKmNsZWFyIGludGVycnVwdCBhbmQgbWVzc2Fn
ZSBzdGF0ZSovCiAJd3JpdGVsKEFSQ01TUl9NRVNTQUdFX0lOVF9DTEVBUl9QQVRURVJOLCByZWct
PmlvcDJkcnZfZG9vcmJlbGwpOwogCXNjaGVkdWxlX3dvcmsoJmFjYi0+YXJjbXNyX2RvX21lc3Nh
Z2VfaXNyX2JoKTsKIH0KLS8qCi0qKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqCi0qKiBIYW5kbGUg
YSBtZXNzYWdlIGludGVycnVwdAotKioKLSoqIFRoZSBvbmx5IG1lc3NhZ2UgaW50ZXJydXB0IHdl
IGV4cGVjdCBpcyBpbiByZXNwb25zZSB0byBhIHF1ZXJ5IGZvciB0aGUKLSoqIGN1cnJlbnQgYWRh
cHRlciBjb25maWcuCi0qKiBXZSB3YW50IHRoaXMgaW4gb3JkZXIgdG8gY29tcGFyZSB0aGUgZHJp
dmVtYXAgc28gdGhhdCB3ZSBjYW4gZGV0ZWN0IG5ld2x5LWF0dGFjaGVkIGRyaXZlcy4KLSoqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioKLSovCi1zdGF0aWMgdm9pZCBhcmNtc3JfaGJjX21lc3NhZ2Vf
aXNyKHN0cnVjdCBBZGFwdGVyQ29udHJvbEJsb2NrICphY2IpCisKK3N0YXRpYyB2b2lkCithcmNt
c3JfaGJhQ19tZXNzYWdlX2lzcihzdHJ1Y3QgQWRhcHRlckNvbnRyb2xCbG9jayAqYWNiKQogewot
CXN0cnVjdCBNZXNzYWdlVW5pdF9DICpyZWcgID0gYWNiLT5wbXVDOworCXN0cnVjdCBNZXNzYWdl
VW5pdF9DIF9faW9tZW0gKnJlZyAgPSBhY2ItPnBtdUM7CiAJLypjbGVhciBpbnRlcnJ1cHQgYW5k
IG1lc3NhZ2Ugc3RhdGUqLwotCXdyaXRlbChBUkNNU1JfSEJDTVVfSU9QMkRSVl9NRVNTQUdFX0NN
RF9ET05FX0RPT1JCRUxMX0NMRUFSLCAmcmVnLT5vdXRib3VuZF9kb29yYmVsbF9jbGVhcik7CisJ
d3JpdGVsKEFSQ01TUl9IQkNNVV9JT1AyRFJWX01FU1NBR0VfQ01EX0RPTkVfRE9PUkJFTExfQ0xF
QVIsCisJCSZyZWctPm91dGJvdW5kX2Rvb3JiZWxsX2NsZWFyKTsKKwlzY2hlZHVsZV93b3JrKCZh
Y2ItPmFyY21zcl9kb19tZXNzYWdlX2lzcl9iaCk7Cit9CisKK3N0YXRpYyB2b2lkCithcmNtc3Jf
aGJhRF9tZXNzYWdlX2lzcihzdHJ1Y3QgQWRhcHRlckNvbnRyb2xCbG9jayAqYWNiKQoreworCXN0
cnVjdCBNZXNzYWdlVW5pdF9EIF9faW9tZW0gKnJlZyAgPSBhY2ItPnBtdUQ7CisJd3JpdGVsKEFS
Q01TUl9BUkMxMjE0X0lPUDJEUlZfTUVTU0FHRV9DTURfRE9ORSwKKwkJcmVnLT5vdXRib3VuZF9k
b29yYmVsbCk7CisJcmVhZGwocmVnLT5vdXRib3VuZF9kb29yYmVsbCk7CiAJc2NoZWR1bGVfd29y
aygmYWNiLT5hcmNtc3JfZG9fbWVzc2FnZV9pc3JfYmgpOwogfQogCi1zdGF0aWMgaW50IGFyY21z
cl9oYW5kbGVfaGJhX2lzcihzdHJ1Y3QgQWRhcHRlckNvbnRyb2xCbG9jayAqYWNiKQorc3RhdGlj
IGlycXJldHVybl90CithcmNtc3JfaGJhQV9oYW5kbGVfaXNyKHN0cnVjdCBBZGFwdGVyQ29udHJv
bEJsb2NrICphY2IpCiB7CiAJdWludDMyX3Qgb3V0Ym91bmRfaW50c3RhdHVzOwogCXN0cnVjdCBN
ZXNzYWdlVW5pdF9BIF9faW9tZW0gKnJlZyA9IGFjYi0+cG11QTsKLQlvdXRib3VuZF9pbnRzdGF0
dXMgPSByZWFkbCgmcmVnLT5vdXRib3VuZF9pbnRzdGF0dXMpICYKLQkJYWNiLT5vdXRib3VuZF9p
bnRfZW5hYmxlOwotCWlmICghKG91dGJvdW5kX2ludHN0YXR1cyAmIEFSQ01TUl9NVV9PVVRCT1VO
RF9IQU5ETEVfSU5UKSkJewotCQlyZXR1cm4gMTsKLQl9Ci0Jd3JpdGVsKG91dGJvdW5kX2ludHN0
YXR1cywgJnJlZy0+b3V0Ym91bmRfaW50c3RhdHVzKTsKLQlpZiAob3V0Ym91bmRfaW50c3RhdHVz
ICYgQVJDTVNSX01VX09VVEJPVU5EX0RPT1JCRUxMX0lOVCkJewotCQlhcmNtc3JfaGJhX2Rvb3Ji
ZWxsX2lzcihhY2IpOwotCX0KLQlpZiAob3V0Ym91bmRfaW50c3RhdHVzICYgQVJDTVNSX01VX09V
VEJPVU5EX1BPU1RRVUVVRV9JTlQpIHsKLQkJYXJjbXNyX2hiYV9wb3N0cXVldWVfaXNyKGFjYik7
Ci0JfQotCWlmKG91dGJvdW5kX2ludHN0YXR1cyAmIEFSQ01TUl9NVV9PVVRCT1VORF9NRVNTQUdF
MF9JTlQpIAl7Ci0JCS8qIG1lc3NlbmdlciBvZiAiZHJpdmVyIHRvIGlvcCBjb21tYW5kcyIgKi8K
LQkJYXJjbXNyX2hiYV9tZXNzYWdlX2lzcihhY2IpOwotCX0KLQlyZXR1cm4gMDsKKwlvdXRib3Vu
ZF9pbnRzdGF0dXMgPQorCXJlYWRsKCZyZWctPm91dGJvdW5kX2ludHN0YXR1cykgJiBhY2ItPm91
dGJvdW5kX2ludF9lbmFibGU7CisJaWYgKCEob3V0Ym91bmRfaW50c3RhdHVzICYgQVJDTVNSX01V
X09VVEJPVU5EX0hBTkRMRV9JTlQpKQorCQlyZXR1cm4gSVJRX05PTkU7CisJZG8geworCQl3cml0
ZWwob3V0Ym91bmRfaW50c3RhdHVzLCAmcmVnLT5vdXRib3VuZF9pbnRzdGF0dXMpOworCQlpZiAo
b3V0Ym91bmRfaW50c3RhdHVzICYgQVJDTVNSX01VX09VVEJPVU5EX0RPT1JCRUxMX0lOVCkKKwkJ
CWFyY21zcl9oYmFBX2Rvb3JiZWxsX2lzcihhY2IpOworCQlpZiAob3V0Ym91bmRfaW50c3RhdHVz
ICYgQVJDTVNSX01VX09VVEJPVU5EX1BPU1RRVUVVRV9JTlQpCisJCQlhcmNtc3JfaGJhQV9wb3N0
cXVldWVfaXNyKGFjYik7CisJCWlmIChvdXRib3VuZF9pbnRzdGF0dXMgJiBBUkNNU1JfTVVfT1VU
Qk9VTkRfTUVTU0FHRTBfSU5UKQorCQkJYXJjbXNyX2hiYUFfbWVzc2FnZV9pc3IoYWNiKTsKKwkJ
b3V0Ym91bmRfaW50c3RhdHVzID0gcmVhZGwoJnJlZy0+b3V0Ym91bmRfaW50c3RhdHVzKSAmCisJ
CQlhY2ItPm91dGJvdW5kX2ludF9lbmFibGU7CisJfSB3aGlsZSAob3V0Ym91bmRfaW50c3RhdHVz
ICYgKEFSQ01TUl9NVV9PVVRCT1VORF9ET09SQkVMTF9JTlQKKwkJfCBBUkNNU1JfTVVfT1VUQk9V
TkRfUE9TVFFVRVVFX0lOVAorCQl8IEFSQ01TUl9NVV9PVVRCT1VORF9NRVNTQUdFMF9JTlQpKTsK
KwlyZXR1cm4gSVJRX0hBTkRMRUQ7CiB9CiAKLXN0YXRpYyBpbnQgYXJjbXNyX2hhbmRsZV9oYmJf
aXNyKHN0cnVjdCBBZGFwdGVyQ29udHJvbEJsb2NrICphY2IpCitzdGF0aWMgaXJxcmV0dXJuX3QK
K2FyY21zcl9oYmFCX2hhbmRsZV9pc3Ioc3RydWN0IEFkYXB0ZXJDb250cm9sQmxvY2sgKmFjYikK
IHsKIAl1aW50MzJfdCBvdXRib3VuZF9kb29yYmVsbDsKLQlzdHJ1Y3QgTWVzc2FnZVVuaXRfQiAq
cmVnID0gYWNiLT5wbXVCOwotCW91dGJvdW5kX2Rvb3JiZWxsID0gcmVhZGwocmVnLT5pb3AyZHJ2
X2Rvb3JiZWxsKSAmCi0JCQkJYWNiLT5vdXRib3VuZF9pbnRfZW5hYmxlOworCXN0cnVjdCBNZXNz
YWdlVW5pdF9CIF9faW9tZW0gKnJlZyA9IGFjYi0+cG11QjsKKwlvdXRib3VuZF9kb29yYmVsbCA9
IHJlYWRsKHJlZy0+aW9wMmRydl9kb29yYmVsbCkKKwkJJiBhY2ItPm91dGJvdW5kX2ludF9lbmFi
bGU7CiAJaWYgKCFvdXRib3VuZF9kb29yYmVsbCkKLQkJcmV0dXJuIDE7Ci0KLQl3cml0ZWwofm91
dGJvdW5kX2Rvb3JiZWxsLCByZWctPmlvcDJkcnZfZG9vcmJlbGwpOwotCS8qaW4gY2FzZSB0aGUg
bGFzdCBhY3Rpb24gb2YgZG9vcmJlbGwgaW50ZXJydXB0IGNsZWFyYW5jZSBpcyBjYWNoZWQsCi0J
dGhpcyBhY3Rpb24gY2FuIHB1c2ggSFcgdG8gd3JpdGUgZG93biB0aGUgY2xlYXIgYml0Ki8KLQly
ZWFkbChyZWctPmlvcDJkcnZfZG9vcmJlbGwpOwotCXdyaXRlbChBUkNNU1JfRFJWMklPUF9FTkRf
T0ZfSU5URVJSVVBULCByZWctPmRydjJpb3BfZG9vcmJlbGwpOwotCWlmIChvdXRib3VuZF9kb29y
YmVsbCAmIEFSQ01TUl9JT1AyRFJWX0RBVEFfV1JJVEVfT0spIHsKLQkJYXJjbXNyX2lvcDJkcnZf
ZGF0YV93cm90ZV9oYW5kbGUoYWNiKTsKLQl9Ci0JaWYgKG91dGJvdW5kX2Rvb3JiZWxsICYgQVJD
TVNSX0lPUDJEUlZfREFUQV9SRUFEX09LKSB7Ci0JCWFyY21zcl9pb3AyZHJ2X2RhdGFfcmVhZF9o
YW5kbGUoYWNiKTsKLQl9Ci0JaWYgKG91dGJvdW5kX2Rvb3JiZWxsICYgQVJDTVNSX0lPUDJEUlZf
Q0RCX0RPTkUpIHsKLQkJYXJjbXNyX2hiYl9wb3N0cXVldWVfaXNyKGFjYik7Ci0JfQotCWlmKG91
dGJvdW5kX2Rvb3JiZWxsICYgQVJDTVNSX0lPUDJEUlZfTUVTU0FHRV9DTURfRE9ORSkgewotCQkv
KiBtZXNzZW5nZXIgb2YgImRyaXZlciB0byBpb3AgY29tbWFuZHMiICovCi0JCWFyY21zcl9oYmJf
bWVzc2FnZV9pc3IoYWNiKTsKLQl9Ci0JcmV0dXJuIDA7CisJCXJldHVybiBJUlFfTk9ORTsKKwlk
byB7CisJCXdyaXRlbCh+b3V0Ym91bmRfZG9vcmJlbGwsIHJlZy0+aW9wMmRydl9kb29yYmVsbCk7
CisJCXJlYWRsKHJlZy0+aW9wMmRydl9kb29yYmVsbCk7CisJCXdyaXRlbChBUkNNU1JfRFJWMklP
UF9FTkRfT0ZfSU5URVJSVVBULAorCQkJcmVnLT5kcnYyaW9wX2Rvb3JiZWxsKTsKKwkJcmVhZGwo
cmVnLT5kcnYyaW9wX2Rvb3JiZWxsKTsKKwkJaWYgKG91dGJvdW5kX2Rvb3JiZWxsICYgQVJDTVNS
X0lPUDJEUlZfREFUQV9XUklURV9PSykKKwkJCWFyY21zcl9pb3AyZHJ2X2RhdGFfd3JvdGVfaGFu
ZGxlKGFjYik7CisJCWlmIChvdXRib3VuZF9kb29yYmVsbCAmIEFSQ01TUl9JT1AyRFJWX0RBVEFf
UkVBRF9PSykKKwkJCWFyY21zcl9pb3AyZHJ2X2RhdGFfcmVhZF9oYW5kbGUoYWNiKTsKKwkJaWYg
KG91dGJvdW5kX2Rvb3JiZWxsICYgQVJDTVNSX0lPUDJEUlZfQ0RCX0RPTkUpCisJCQlhcmNtc3Jf
aGJhQl9wb3N0cXVldWVfaXNyKGFjYik7CisJCWlmIChvdXRib3VuZF9kb29yYmVsbCAmIEFSQ01T
Ul9JT1AyRFJWX01FU1NBR0VfQ01EX0RPTkUpCisJCQlhcmNtc3JfaGJhQl9tZXNzYWdlX2lzcihh
Y2IpOworCQlvdXRib3VuZF9kb29yYmVsbCA9IHJlYWRsKHJlZy0+aW9wMmRydl9kb29yYmVsbCkg
JgorCQkJYWNiLT5vdXRib3VuZF9pbnRfZW5hYmxlOworCX0gd2hpbGUgKG91dGJvdW5kX2Rvb3Ji
ZWxsICYgKEFSQ01TUl9JT1AyRFJWX0RBVEFfV1JJVEVfT0sKKwkJfCBBUkNNU1JfSU9QMkRSVl9E
QVRBX1JFQURfT0sKKwkJfCBBUkNNU1JfSU9QMkRSVl9DREJfRE9ORQorCQl8IEFSQ01TUl9JT1Ay
RFJWX01FU1NBR0VfQ01EX0RPTkUpKTsKKwlyZXR1cm4gSVJRX0hBTkRMRUQ7CiB9CiAKLXN0YXRp
YyBpbnQgYXJjbXNyX2hhbmRsZV9oYmNfaXNyKHN0cnVjdCBBZGFwdGVyQ29udHJvbEJsb2NrICpw
QUNCKQorc3RhdGljIGlycXJldHVybl90CithcmNtc3JfaGJhQ19oYW5kbGVfaXNyKHN0cnVjdCBB
ZGFwdGVyQ29udHJvbEJsb2NrICpwQUNCKQogewogCXVpbnQzMl90IGhvc3RfaW50ZXJydXB0X3N0
YXR1czsKLQlzdHJ1Y3QgTWVzc2FnZVVuaXRfQyAqcGhiY211ID0gKHN0cnVjdCBNZXNzYWdlVW5p
dF9DICopcEFDQi0+cG11QzsKLQkvKgotCSoqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKgotCSoqICAgY2hlY2sgb3V0Ym91bmQgaW50c3RhdHVzCi0JKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqCi0JKi8KLQlob3N0X2ludGVycnVw
dF9zdGF0dXMgPSByZWFkbCgmcGhiY211LT5ob3N0X2ludF9zdGF0dXMpOwotCWlmICghaG9zdF9p
bnRlcnJ1cHRfc3RhdHVzKSB7Ci0JCS8qaXQgbXVzdCBiZSBzaGFyZSBpcnEqLwotCQlyZXR1cm4g
MTsKLQl9Ci0JLyogTVUgaW9jdGwgdHJhbnNmZXIgZG9vcmJlbGwgaW50ZXJydXB0cyovCi0JaWYg
KGhvc3RfaW50ZXJydXB0X3N0YXR1cyAmIEFSQ01TUl9IQkNNVV9PVVRCT1VORF9ET09SQkVMTF9J
U1IpIHsKLQkJYXJjbXNyX2hiY19kb29yYmVsbF9pc3IocEFDQik7ICAgLyogbWVzc2VuZ2VyIG9m
ICJpb2N0bCBtZXNzYWdlIHJlYWQgd3JpdGUiICovCi0JfQotCS8qIE1VIHBvc3QgcXVldWUgaW50
ZXJydXB0cyovCi0JaWYgKGhvc3RfaW50ZXJydXB0X3N0YXR1cyAmIEFSQ01TUl9IQkNNVV9PVVRC
T1VORF9QT1NUUVVFVUVfSVNSKSB7Ci0JCWFyY21zcl9oYmNfcG9zdHF1ZXVlX2lzcihwQUNCKTsg
IC8qIG1lc3NlbmdlciBvZiAic2NzaSBjb21tYW5kcyIgKi8KLQl9Ci0JcmV0dXJuIDA7CisJc3Ry
dWN0IE1lc3NhZ2VVbml0X0MgX19pb21lbSAqcGhiY211ID0gcEFDQi0+cG11QzsKKwlob3N0X2lu
dGVycnVwdF9zdGF0dXMgPQorCQlyZWFkbCgmcGhiY211LT5ob3N0X2ludF9zdGF0dXMpOworCWRv
IHsKKwkJaWYgKGhvc3RfaW50ZXJydXB0X3N0YXR1cyAmCisJCQlBUkNNU1JfSEJDTVVfT1VUQk9V
TkRfRE9PUkJFTExfSVNSKQorCQkJYXJjbXNyX2hiYUNfZG9vcmJlbGxfaXNyKHBBQ0IpOworCQkv
KiBNVSBwb3N0IHF1ZXVlIGludGVycnVwdHMqLworCQlpZiAoaG9zdF9pbnRlcnJ1cHRfc3RhdHVz
ICYKKwkJCUFSQ01TUl9IQkNNVV9PVVRCT1VORF9QT1NUUVVFVUVfSVNSKQorCQkJYXJjbXNyX2hi
YUNfcG9zdHF1ZXVlX2lzcihwQUNCKTsKKwkJaG9zdF9pbnRlcnJ1cHRfc3RhdHVzID0gcmVhZGwo
JnBoYmNtdS0+aG9zdF9pbnRfc3RhdHVzKTsKKwl9IHdoaWxlIChob3N0X2ludGVycnVwdF9zdGF0
dXMgJgorCQkoQVJDTVNSX0hCQ01VX09VVEJPVU5EX1BPU1RRVUVVRV9JU1IgfAorCQlBUkNNU1Jf
SEJDTVVfT1VUQk9VTkRfRE9PUkJFTExfSVNSKSk7CisJcmV0dXJuIElSUV9IQU5ETEVEOwogfQot
c3RhdGljIGlycXJldHVybl90IGFyY21zcl9pbnRlcnJ1cHQoc3RydWN0IEFkYXB0ZXJDb250cm9s
QmxvY2sgKmFjYikKKworc3RhdGljIGlycXJldHVybl90CithcmNtc3JfaGJhRF9oYW5kbGVfaXNy
KHN0cnVjdCBBZGFwdGVyQ29udHJvbEJsb2NrICpwQUNCKQoreworCXUzMiBob3N0X2ludGVycnVw
dF9zdGF0dXM7CisJc3RydWN0IE1lc3NhZ2VVbml0X0QgX19pb21lbSAqcG11ID0gcEFDQi0+cG11
RDsKKwlob3N0X2ludGVycnVwdF9zdGF0dXMgPSByZWFkbChwbXUtPmhvc3RfaW50X3N0YXR1cyk7
CisJZG8geworCQkvKiBNVSBwb3N0IHF1ZXVlIGludGVycnVwdHMqLworCQlpZiAoaG9zdF9pbnRl
cnJ1cHRfc3RhdHVzICYKKwkJCUFSQ01TUl9BUkMxMjE0X09VVEJPVU5EX1BPU1RRVUVVRV9JU1Ip
CisJCQlhcmNtc3JfaGJhRF9wb3N0cXVldWVfaXNyKHBBQ0IpOworCQlpZiAoaG9zdF9pbnRlcnJ1
cHRfc3RhdHVzICYKKwkJCUFSQ01TUl9BUkMxMjE0X09VVEJPVU5EX0RPT1JCRUxMX0lTUikKKwkJ
CWFyY21zcl9oYmFEX2Rvb3JiZWxsX2lzcihwQUNCKTsKKwkJaG9zdF9pbnRlcnJ1cHRfc3RhdHVz
ID0gcmVhZGwocG11LT5ob3N0X2ludF9zdGF0dXMpOworCX0gd2hpbGUgKGhvc3RfaW50ZXJydXB0
X3N0YXR1cyAmCisJCShBUkNNU1JfQVJDMTIxNF9PVVRCT1VORF9QT1NUUVVFVUVfSVNSIHwKKwkJ
QVJDTVNSX0FSQzEyMTRfT1VUQk9VTkRfRE9PUkJFTExfSVNSKSk7CisJcmV0dXJuIElSUV9IQU5E
TEVEOworfQorCitzdGF0aWMgaXJxcmV0dXJuX3QKK2FyY21zcl9pbnRlcnJ1cHQoc3RydWN0IEFk
YXB0ZXJDb250cm9sQmxvY2sgKmFjYikKIHsKIAlzd2l0Y2ggKGFjYi0+YWRhcHRlcl90eXBlKSB7
CiAJY2FzZSBBQ0JfQURBUFRFUl9UWVBFX0E6IHsKLQkJaWYgKGFyY21zcl9oYW5kbGVfaGJhX2lz
cihhY2IpKSB7Ci0JCQlyZXR1cm4gSVJRX05PTkU7Ci0JCX0KLQkJfQorCQlyZXR1cm4gYXJjbXNy
X2hiYUFfaGFuZGxlX2lzcihhY2IpOwogCQlicmVhazsKLQorCX0KIAljYXNlIEFDQl9BREFQVEVS
X1RZUEVfQjogewotCQlpZiAoYXJjbXNyX2hhbmRsZV9oYmJfaXNyKGFjYikpIHsKLQkJCXJldHVy
biBJUlFfTk9ORTsKLQkJfQotCQl9CisJCXJldHVybiBhcmNtc3JfaGJhQl9oYW5kbGVfaXNyKGFj
Yik7CiAJCWJyZWFrOwotCSBjYXNlIEFDQl9BREFQVEVSX1RZUEVfQzogewotCQlpZiAoYXJjbXNy
X2hhbmRsZV9oYmNfaXNyKGFjYikpIHsKLQkJCXJldHVybiBJUlFfTk9ORTsKLQkJfQotCQl9CiAJ
fQotCXJldHVybiBJUlFfSEFORExFRDsKKwljYXNlIEFDQl9BREFQVEVSX1RZUEVfQzogeworCQly
ZXR1cm4gYXJjbXNyX2hiYUNfaGFuZGxlX2lzcihhY2IpOworCQlicmVhazsKKwl9CisJY2FzZSBB
Q0JfQURBUFRFUl9UWVBFX0Q6IHsKKwkJcmV0dXJuIGFyY21zcl9oYmFEX2hhbmRsZV9pc3IoYWNi
KTsKKwkJYnJlYWs7CisJfQorCWRlZmF1bHQ6CisJCXJldHVybiBJUlFfTk9ORTsKKwl9CiB9CiAK
LXN0YXRpYyB2b2lkIGFyY21zcl9pb3BfcGFya2luZyhzdHJ1Y3QgQWRhcHRlckNvbnRyb2xCbG9j
ayAqYWNiKQorc3RhdGljIHZvaWQKK2FyY21zcl9pb3BfcGFya2luZyhzdHJ1Y3QgQWRhcHRlckNv
bnRyb2xCbG9jayAqYWNiKQogewogCWlmIChhY2IpIHsKIAkJLyogc3RvcCBhZGFwdGVyIGJhY2tn
cm91bmQgcmVidWlsZCAqLwpAQCAtMTY5NSwzMDkgKzI1NDQsMzcyIEBAIHN0YXRpYyB2b2lkIGFy
Y21zcl9pb3BfcGFya2luZyhzdHJ1Y3QgQWQKIAl9CiB9CiAKLXZvaWQgYXJjbXNyX3Bvc3RfaW9j
dGxkYXRhMmlvcChzdHJ1Y3QgQWRhcHRlckNvbnRyb2xCbG9jayAqYWNiKQordm9pZAorYXJjbXNy
X2NsZWFyX2lvcDJkcnZfcnF1ZXVlX2J1ZmZlcihzdHJ1Y3QgQWRhcHRlckNvbnRyb2xCbG9jayAq
YWNiKQogewotCWludDMyX3Qgd3FidWZfZmlyc3RpbmRleCwgd3FidWZfbGFzdGluZGV4OwotCXVp
bnQ4X3QgKnBRYnVmZmVyOwotCXN0cnVjdCBRQlVGRkVSIF9faW9tZW0gKnB3YnVmZmVyOwotCXVp
bnQ4X3QgX19pb21lbSAqaW9wX2RhdGE7Ci0JaW50MzJfdCBhbGx4ZmVyX2xlbiA9IDA7Ci0JcHdi
dWZmZXIgPSBhcmNtc3JfZ2V0X2lvcF93cWJ1ZmZlcihhY2IpOwotCWlvcF9kYXRhID0gKHVpbnQ4
X3QgX19pb21lbSAqKXB3YnVmZmVyLT5kYXRhOwotCWlmIChhY2ItPmFjYl9mbGFncyAmIEFDQl9G
X01FU1NBR0VfV1FCVUZGRVJfUkVBREVEKSB7Ci0JCWFjYi0+YWNiX2ZsYWdzICY9ICh+QUNCX0Zf
TUVTU0FHRV9XUUJVRkZFUl9SRUFERUQpOwotCQl3cWJ1Zl9maXJzdGluZGV4ID0gYWNiLT53cWJ1
Zl9maXJzdGluZGV4OwotCQl3cWJ1Zl9sYXN0aW5kZXggPSBhY2ItPndxYnVmX2xhc3RpbmRleDsK
LQkJd2hpbGUgKCh3cWJ1Zl9maXJzdGluZGV4ICE9IHdxYnVmX2xhc3RpbmRleCkgJiYgKGFsbHhm
ZXJfbGVuIDwgMTI0KSkgewotCQkJcFFidWZmZXIgPSAmYWNiLT53cWJ1ZmZlclt3cWJ1Zl9maXJz
dGluZGV4XTsKLQkJCW1lbWNweShpb3BfZGF0YSwgcFFidWZmZXIsIDEpOwotCQkJd3FidWZfZmly
c3RpbmRleCsrOwotCQkJd3FidWZfZmlyc3RpbmRleCAlPSBBUkNNU1JfTUFYX1FCVUZGRVI7Ci0J
CQlpb3BfZGF0YSsrOwotCQkJYWxseGZlcl9sZW4rKzsKKwl1aW50MzJfdAlpOworCisJaWYgKGFj
Yi0+YWNiX2ZsYWdzICYgQUNCX0ZfSU9QREFUQV9PVkVSRkxPVykgeworCQlmb3IgKGkgPSAwOyBp
IDwgMTU7IGkrKykgeworCQkJaWYgKGFjYi0+YWNiX2ZsYWdzICYgQUNCX0ZfSU9QREFUQV9PVkVS
RkxPVykgeworCQkJCWFjYi0+YWNiX2ZsYWdzICY9IH5BQ0JfRl9JT1BEQVRBX09WRVJGTE9XOwor
CQkJCWFjYi0+cnFidWZfZmlyc3RpbmRleCA9IDA7CisJCQkJYWNiLT5ycWJ1Zl9sYXN0aW5kZXgg
PSAwOworCQkJCWFyY21zcl9pb3BfbWVzc2FnZV9yZWFkKGFjYik7CisJCQkJbWRlbGF5KDMwKTsK
KwkJCX0gZWxzZSBpZiAoYWNiLT5ycWJ1Zl9maXJzdGluZGV4ICE9IGFjYi0+cnFidWZfbGFzdGlu
ZGV4KSB7CisJCQkJYWNiLT5ycWJ1Zl9maXJzdGluZGV4ID0gMDsKKwkJCQlhY2ItPnJxYnVmX2xh
c3RpbmRleCA9IDA7CisJCQkJbWRlbGF5KDMwKTsKKwkJCX0gZWxzZQorCQkJCWJyZWFrOwogCQl9
Ci0JCWFjYi0+d3FidWZfZmlyc3RpbmRleCA9IHdxYnVmX2ZpcnN0aW5kZXg7Ci0JCXB3YnVmZmVy
LT5kYXRhX2xlbiA9IGFsbHhmZXJfbGVuOwotCQlhcmNtc3JfaW9wX21lc3NhZ2Vfd3JvdGUoYWNi
KTsKIAl9CiB9CiAKLXN0YXRpYyBpbnQgYXJjbXNyX2lvcF9tZXNzYWdlX3hmZXIoc3RydWN0IEFk
YXB0ZXJDb250cm9sQmxvY2sgKmFjYiwKK3N0YXRpYyBpbnQKK2FyY21zcl9pb3BfbWVzc2FnZV94
ZmVyKHN0cnVjdCBBZGFwdGVyQ29udHJvbEJsb2NrICphY2IsCiAJCQkJCXN0cnVjdCBzY3NpX2Nt
bmQgKmNtZCkKIHsKLQlzdHJ1Y3QgQ01EX01FU1NBR0VfRklFTEQgKnBjbWRtZXNzYWdlZmxkOwot
CWludCByZXR2YWx1ZSA9IDAsIHRyYW5zZmVyX2xlbiA9IDA7CiAJY2hhciAqYnVmZmVyOworCXVu
c2lnbmVkIHNob3J0IHVzZV9zZzsKKwlpbnQgcmV0dmFsdWUgPSAwLCB0cmFuc2Zlcl9sZW4gPSAw
OworCXVuc2lnbmVkIGxvbmcgZmxhZ3M7CisJc3RydWN0IENNRF9NRVNTQUdFX0ZJRUxEICpwY21k
bWVzc2FnZWZsZDsKKwl1aW50MzJfdAljb250cm9sY29kZSA9ICh1aW50MzJfdCljbWQtPmNtbmRb
NV0gPDwgMjQgfAorCQkodWludDMyX3QpY21kLT5jbW5kWzZdIDw8IDE2IHwKKwkJKHVpbnQzMl90
KWNtZC0+Y21uZFs3XSA8PCA4IHwKKwkJKHVpbnQzMl90KWNtZC0+Y21uZFs4XTsKIAlzdHJ1Y3Qg
c2NhdHRlcmxpc3QgKnNnOwotCXVpbnQzMl90IGNvbnRyb2xjb2RlID0gKHVpbnQzMl90ICkgY21k
LT5jbW5kWzVdIDw8IDI0IHwKLQkJCQkJCSh1aW50MzJfdCApIGNtZC0+Y21uZFs2XSA8PCAxNiB8
Ci0JCQkJCQkodWludDMyX3QgKSBjbWQtPmNtbmRbN10gPDwgOCAgfAotCQkJCQkJKHVpbnQzMl90
ICkgY21kLT5jbW5kWzhdOwotCQkJCQkJLyogNCBieXRlczogQXJlY2EgaW8gY29udHJvbCBjb2Rl
ICovCisKKwl1c2Vfc2cgPSBzY3NpX3NnX2NvdW50KGNtZCk7CiAJc2cgPSBzY3NpX3NnbGlzdChj
bWQpOwogCWJ1ZmZlciA9IGttYXBfYXRvbWljKHNnX3BhZ2Uoc2cpKSArIHNnLT5vZmZzZXQ7Ci0J
aWYgKHNjc2lfc2dfY291bnQoY21kKSA+IDEpIHsKKwlpZiAodXNlX3NnID4gMSkgewogCQlyZXR2
YWx1ZSA9IEFSQ01TUl9NRVNTQUdFX0ZBSUw7CiAJCWdvdG8gbWVzc2FnZV9vdXQ7CiAJfQogCXRy
YW5zZmVyX2xlbiArPSBzZy0+bGVuZ3RoOwotCiAJaWYgKHRyYW5zZmVyX2xlbiA+IHNpemVvZihz
dHJ1Y3QgQ01EX01FU1NBR0VfRklFTEQpKSB7CiAJCXJldHZhbHVlID0gQVJDTVNSX01FU1NBR0Vf
RkFJTDsKKwkJcHJfaW5mbygiJXM6IEFSQ01TUl9NRVNTQUdFX0ZBSUwhXG4iLCBfX2Z1bmNfXyk7
CiAJCWdvdG8gbWVzc2FnZV9vdXQ7CiAJfQotCXBjbWRtZXNzYWdlZmxkID0gKHN0cnVjdCBDTURf
TUVTU0FHRV9GSUVMRCAqKSBidWZmZXI7Ci0Jc3dpdGNoKGNvbnRyb2xjb2RlKSB7Ci0KKwlwY21k
bWVzc2FnZWZsZCA9IChzdHJ1Y3QgQ01EX01FU1NBR0VfRklFTEQgKilidWZmZXI7CisJc3dpdGNo
IChjb250cm9sY29kZSkgewogCWNhc2UgQVJDTVNSX01FU1NBR0VfUkVBRF9SUUJVRkZFUjogewog
CQl1bnNpZ25lZCBjaGFyICp2ZXJfYWRkcjsKIAkJdWludDhfdCAqcFFidWZmZXIsICpwdG1wUWJ1
ZmZlcjsKLQkJaW50MzJfdCBhbGx4ZmVyX2xlbiA9IDA7Ci0KLQkJdmVyX2FkZHIgPSBrbWFsbG9j
KDEwMzIsIEdGUF9BVE9NSUMpOworCQl1aW50MzJfdCBhbGx4ZmVyX2xlbiA9IDA7CisJCXZlcl9h
ZGRyID0gKHVuc2lnbmVkIGNoYXIgKilrbWFsbG9jKDEwMzIsIEdGUF9BVE9NSUMpOwogCQlpZiAo
IXZlcl9hZGRyKSB7CiAJCQlyZXR2YWx1ZSA9IEFSQ01TUl9NRVNTQUdFX0ZBSUw7CisJCQlwcl9p
bmZvKCIlczogbWVtb3J5IG5vdCBlbm91Z2ghXG4iLCBfX2Z1bmNfXyk7CiAJCQlnb3RvIG1lc3Nh
Z2Vfb3V0OwogCQl9Ci0JCQkJCiAJCXB0bXBRYnVmZmVyID0gdmVyX2FkZHI7Ci0JCXdoaWxlICgo
YWNiLT5ycWJ1Zl9maXJzdGluZGV4ICE9IGFjYi0+cnFidWZfbGFzdGluZGV4KQotCQkJJiYgKGFs
bHhmZXJfbGVuIDwgMTAzMSkpIHsKKwkJc3Bpbl9sb2NrX2lycXNhdmUoJmFjYi0+cnFidWZmZXJf
bG9jaywgZmxhZ3MpOworCQlpZiAoYWNiLT5ycWJ1Zl9maXJzdGluZGV4ICE9IGFjYi0+cnFidWZf
bGFzdGluZGV4KSB7CiAJCQlwUWJ1ZmZlciA9ICZhY2ItPnJxYnVmZmVyW2FjYi0+cnFidWZfZmly
c3RpbmRleF07Ci0JCQltZW1jcHkocHRtcFFidWZmZXIsIHBRYnVmZmVyLCAxKTsKLQkJCWFjYi0+
cnFidWZfZmlyc3RpbmRleCsrOwotCQkJYWNiLT5ycWJ1Zl9maXJzdGluZGV4ICU9IEFSQ01TUl9N
QVhfUUJVRkZFUjsKLQkJCXB0bXBRYnVmZmVyKys7Ci0JCQlhbGx4ZmVyX2xlbisrOworCQkJaWYg
KGFjYi0+cnFidWZfZmlyc3RpbmRleCA+IGFjYi0+cnFidWZfbGFzdGluZGV4KSB7CisJCQkJaWYg
KChBUkNNU1JfTUFYX1FCVUZGRVIgLQorCQkJCQlhY2ItPnJxYnVmX2ZpcnN0aW5kZXgpID49IDEw
MzIpIHsKKwkJCQkJbWVtY3B5KCh2b2lkICopcHRtcFFidWZmZXIsIChjb25zdCB2b2lkICopcFFi
dWZmZXIsIDEwMzIpOworCQkJCQlhY2ItPnJxYnVmX2ZpcnN0aW5kZXggKz0gMTAzMjsKKwkJCQkJ
YWNiLT5ycWJ1Zl9maXJzdGluZGV4ICU9IEFSQ01TUl9NQVhfUUJVRkZFUjsKKwkJCQkJYWxseGZl
cl9sZW4gPSAxMDMyOworCQkJCX0gZWxzZSB7CisJCQkJCWlmICgoKEFSQ01TUl9NQVhfUUJVRkZF
UiAtCisJCQkJCQlhY2ItPnJxYnVmX2ZpcnN0aW5kZXgpICsKKwkJCQkJCWFjYi0+cnFidWZfbGFz
dGluZGV4KSA+IDEwMzIpIHsKKwkJCQkJCW1lbWNweSgodm9pZCAqKXB0bXBRYnVmZmVyLAorCQkJ
CQkJCShjb25zdCB2b2lkICopcFFidWZmZXIsIEFSQ01TUl9NQVhfUUJVRkZFUgorCQkJCQkJCS0g
YWNiLT5ycWJ1Zl9maXJzdGluZGV4KTsKKwkJCQkJCXB0bXBRYnVmZmVyICs9CisJCQkJCQkJQVJD
TVNSX01BWF9RQlVGRkVSIC0KKwkJCQkJCWFjYi0+cnFidWZfZmlyc3RpbmRleDsKKwkJCQkJCW1l
bWNweSgodm9pZCAqKXB0bXBRYnVmZmVyLAorCQkJCQkJCShjb25zdCB2b2lkICopYWNiLT5ycWJ1
ZmZlciwgMTAzMiAtCisJCQkJCQkJKEFSQ01TUl9NQVhfUUJVRkZFUgorCQkJCQkJCS0gYWNiLT5y
cWJ1Zl9maXJzdGluZGV4KSk7CisJCQkJCQlhY2ItPnJxYnVmX2ZpcnN0aW5kZXggPQorCQkJCQkJ
CTEwMzIgLSAoQVJDTVNSX01BWF9RQlVGRkVSCisJCQkJCQkJLSBhY2ItPnJxYnVmX2ZpcnN0aW5k
ZXgpOworCQkJCQkJYWxseGZlcl9sZW4gPSAxMDMyOworCQkJCQl9IGVsc2UgeworCQkJCQkJbWVt
Y3B5KCh2b2lkICopcHRtcFFidWZmZXIsCisJCQkJCQkJKGNvbnN0IHZvaWQgKilwUWJ1ZmZlciwg
QVJDTVNSX01BWF9RQlVGRkVSCisJCQkJCQkJLSBhY2ItPnJxYnVmX2ZpcnN0aW5kZXgpOworCQkJ
CQkJcHRtcFFidWZmZXIgKz0KKwkJCQkJCQlBUkNNU1JfTUFYX1FCVUZGRVIgLQorCQkJCQkJCWFj
Yi0+cnFidWZfZmlyc3RpbmRleDsKKwkJCQkJCW1lbWNweSgodm9pZCAqKXB0bXBRYnVmZmVyLAor
CQkJCQkJCShjb25zdCB2b2lkICopYWNiLT5ycWJ1ZmZlciwKKwkJCQkJCQlhY2ItPnJxYnVmX2xh
c3RpbmRleCk7CisJCQkJCQlhbGx4ZmVyX2xlbiA9IEFSQ01TUl9NQVhfUUJVRkZFUgorCQkJCQkJ
CS0gYWNiLT5ycWJ1Zl9maXJzdGluZGV4ICsKKwkJCQkJCQlhY2ItPnJxYnVmX2xhc3RpbmRleDsK
KwkJCQkJCWFjYi0+cnFidWZfZmlyc3RpbmRleCA9CisJCQkJCQkJYWNiLT5ycWJ1Zl9sYXN0aW5k
ZXg7CisJCQkJCX0KKwkJCQl9CisJCQl9IGVsc2UgeworCQkJCWlmICgoYWNiLT5ycWJ1Zl9sYXN0
aW5kZXggLQorCQkJCWFjYi0+cnFidWZfZmlyc3RpbmRleCkgPiAxMDMyKSB7CisJCQkJCW1lbWNw
eSgodm9pZCAqKXB0bXBRYnVmZmVyLAorCQkJCQkJKGNvbnN0IHZvaWQgKilwUWJ1ZmZlciwgMTAz
Mik7CisJCQkJCWFjYi0+cnFidWZfZmlyc3RpbmRleCArPSAxMDMyOworCQkJCQlhbGx4ZmVyX2xl
biA9IDEwMzI7CisJCQkJfSBlbHNlIHsKKwkJCQkJbWVtY3B5KCh2b2lkICopcHRtcFFidWZmZXIs
IChjb25zdCB2b2lkICopcFFidWZmZXIsCisJCQkJCQlhY2ItPnJxYnVmX2xhc3RpbmRleCAtIGFj
Yi0+cnFidWZfZmlyc3RpbmRleCk7CisJCQkJCWFsbHhmZXJfbGVuID0gYWNiLT5ycWJ1Zl9sYXN0
aW5kZXgKKwkJCQkJCS0gYWNiLT5ycWJ1Zl9maXJzdGluZGV4OworCQkJCQlhY2ItPnJxYnVmX2Zp
cnN0aW5kZXggPQorCQkJCQkJYWNiLT5ycWJ1Zl9sYXN0aW5kZXg7CisJCQkJfQorCQkJfQogCQl9
CisJCW1lbWNweSgodm9pZCAqKXBjbWRtZXNzYWdlZmxkLT5tZXNzYWdlZGF0YWJ1ZmZlciwKKwkJ
CShjb25zdCB2b2lkICopdmVyX2FkZHIsIGFsbHhmZXJfbGVuKTsKIAkJaWYgKGFjYi0+YWNiX2Zs
YWdzICYgQUNCX0ZfSU9QREFUQV9PVkVSRkxPVykgewotCiAJCQlzdHJ1Y3QgUUJVRkZFUiBfX2lv
bWVtICpwcmJ1ZmZlcjsKLQkJCXVpbnQ4X3QgX19pb21lbSAqaW9wX2RhdGE7Ci0JCQlpbnQzMl90
IGlvcF9sZW47Ci0KIAkJCWFjYi0+YWNiX2ZsYWdzICY9IH5BQ0JfRl9JT1BEQVRBX09WRVJGTE9X
OwogCQkJcHJidWZmZXIgPSBhcmNtc3JfZ2V0X2lvcF9ycWJ1ZmZlcihhY2IpOwotCQkJaW9wX2Rh
dGEgPSBwcmJ1ZmZlci0+ZGF0YTsKLQkJCWlvcF9sZW4gPSByZWFkbCgmcHJidWZmZXItPmRhdGFf
bGVuKTsKLQkJCXdoaWxlIChpb3BfbGVuID4gMCkgewotCQkJCWFjYi0+cnFidWZmZXJbYWNiLT5y
cWJ1Zl9sYXN0aW5kZXhdID0gcmVhZGIoaW9wX2RhdGEpOwotCQkJCWFjYi0+cnFidWZfbGFzdGlu
ZGV4Kys7Ci0JCQkJYWNiLT5ycWJ1Zl9sYXN0aW5kZXggJT0gQVJDTVNSX01BWF9RQlVGRkVSOwot
CQkJCWlvcF9kYXRhKys7Ci0JCQkJaW9wX2xlbi0tOwotCQkJfQotCQkJYXJjbXNyX2lvcF9tZXNz
YWdlX3JlYWQoYWNiKTsKKwkJCWlmIChhcmNtc3JfUmVhZF9pb3BfcnFidWZmZXJfZGF0YShhY2Is
IHByYnVmZmVyKSA9PSAwKQorCQkJCWFjYi0+YWNiX2ZsYWdzIHw9IEFDQl9GX0lPUERBVEFfT1ZF
UkZMT1c7CiAJCX0KLQkJbWVtY3B5KHBjbWRtZXNzYWdlZmxkLT5tZXNzYWdlZGF0YWJ1ZmZlciwg
dmVyX2FkZHIsIGFsbHhmZXJfbGVuKTsKKwkJc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSgmYWNiLT5y
cWJ1ZmZlcl9sb2NrLCBmbGFncyk7CisJCWtmcmVlKChjb25zdCB2b2lkICopdmVyX2FkZHIpOwog
CQlwY21kbWVzc2FnZWZsZC0+Y21kbWVzc2FnZS5MZW5ndGggPSBhbGx4ZmVyX2xlbjsKLQkJaWYo
YWNiLT5md19mbGFnID09IEZXX0RFQURMT0NLKSB7Ci0JCQlwY21kbWVzc2FnZWZsZC0+Y21kbWVz
c2FnZS5SZXR1cm5Db2RlID0gQVJDTVNSX01FU1NBR0VfUkVUVVJOQ09ERV9CVVNfSEFOR19PTjsK
LQkJfWVsc2V7Ci0JCQlwY21kbWVzc2FnZWZsZC0+Y21kbWVzc2FnZS5SZXR1cm5Db2RlID0gQVJD
TVNSX01FU1NBR0VfUkVUVVJOQ09ERV9PSzsKLQkJfQotCQlrZnJlZSh2ZXJfYWRkcik7CisJCWlm
IChhY2ItPmZ3X2ZsYWcgPT0gRldfREVBRExPQ0spIHsKKwkJCXBjbWRtZXNzYWdlZmxkLT5jbWRt
ZXNzYWdlLlJldHVybkNvZGUgPQorCQkJCUFSQ01TUl9NRVNTQUdFX1JFVFVSTkNPREVfQlVTX0hB
TkdfT047CisJCX0gZWxzZSB7CisJCQlwY21kbWVzc2FnZWZsZC0+Y21kbWVzc2FnZS5SZXR1cm5D
b2RlID0KKwkJCQlBUkNNU1JfTUVTU0FHRV9SRVRVUk5DT0RFX09LOwogCQl9CiAJCWJyZWFrOwot
CisJfQogCWNhc2UgQVJDTVNSX01FU1NBR0VfV1JJVEVfV1FCVUZGRVI6IHsKIAkJdW5zaWduZWQg
Y2hhciAqdmVyX2FkZHI7Ci0JCWludDMyX3QgbXlfZW1wdHlfbGVuLCB1c2VyX2xlbiwgd3FidWZf
Zmlyc3RpbmRleCwgd3FidWZfbGFzdGluZGV4OworCQlpbnQzMl90IG15X2VtcHR5X2xlbiwgdXNl
cl9sZW4sIHdxYnVmX2ZpcnN0aW5kZXgsCisJCXdxYnVmX2xhc3RpbmRleDsKIAkJdWludDhfdCAq
cFFidWZmZXIsICpwdG1wdXNlcmJ1ZmZlcjsKLQotCQl2ZXJfYWRkciA9IGttYWxsb2MoMTAzMiwg
R0ZQX0FUT01JQyk7CisJCXZlcl9hZGRyID0gKHVuc2lnbmVkIGNoYXIgKilrbWFsbG9jKDEwMzIs
IEdGUF9BVE9NSUMpOwogCQlpZiAoIXZlcl9hZGRyKSB7CiAJCQlyZXR2YWx1ZSA9IEFSQ01TUl9N
RVNTQUdFX0ZBSUw7CiAJCQlnb3RvIG1lc3NhZ2Vfb3V0OwogCQl9Ci0JCWlmKGFjYi0+ZndfZmxh
ZyA9PSBGV19ERUFETE9DSykgewotCQkJcGNtZG1lc3NhZ2VmbGQtPmNtZG1lc3NhZ2UuUmV0dXJu
Q29kZSA9IAotCQkJQVJDTVNSX01FU1NBR0VfUkVUVVJOQ09ERV9CVVNfSEFOR19PTjsKLQkJfWVs
c2V7Ci0JCQlwY21kbWVzc2FnZWZsZC0+Y21kbWVzc2FnZS5SZXR1cm5Db2RlID0gCi0JCQlBUkNN
U1JfTUVTU0FHRV9SRVRVUk5DT0RFX09LOwotCQl9CiAJCXB0bXB1c2VyYnVmZmVyID0gdmVyX2Fk
ZHI7CiAJCXVzZXJfbGVuID0gcGNtZG1lc3NhZ2VmbGQtPmNtZG1lc3NhZ2UuTGVuZ3RoOwotCQlt
ZW1jcHkocHRtcHVzZXJidWZmZXIsIHBjbWRtZXNzYWdlZmxkLT5tZXNzYWdlZGF0YWJ1ZmZlciwg
dXNlcl9sZW4pOworCQltZW1jcHkoKHZvaWQgKilwdG1wdXNlcmJ1ZmZlciwKKwkJCShjb25zdCB2
b2lkICopcGNtZG1lc3NhZ2VmbGQtPm1lc3NhZ2VkYXRhYnVmZmVyLCB1c2VyX2xlbik7CisJCXNw
aW5fbG9ja19pcnFzYXZlKCZhY2ItPndxYnVmZmVyX2xvY2ssIGZsYWdzKTsKIAkJd3FidWZfbGFz
dGluZGV4ID0gYWNiLT53cWJ1Zl9sYXN0aW5kZXg7CiAJCXdxYnVmX2ZpcnN0aW5kZXggPSBhY2It
PndxYnVmX2ZpcnN0aW5kZXg7CiAJCWlmICh3cWJ1Zl9sYXN0aW5kZXggIT0gd3FidWZfZmlyc3Rp
bmRleCkgewogCQkJc3RydWN0IFNFTlNFX0RBVEEgKnNlbnNlYnVmZmVyID0KIAkJCQkoc3RydWN0
IFNFTlNFX0RBVEEgKiljbWQtPnNlbnNlX2J1ZmZlcjsKLQkJCWFyY21zcl9wb3N0X2lvY3RsZGF0
YTJpb3AoYWNiKTsKKwkJCWFyY21zcl93cml0ZV9pb2N0bGRhdGEyaW9wKGFjYik7CiAJCQkvKiBo
YXMgZXJyb3IgcmVwb3J0IHNlbnNlZGF0YSAqLwotCQkJc2Vuc2VidWZmZXItPkVycm9yQ29kZSA9
IDB4NzA7CisJCQlzZW5zZWJ1ZmZlci0+RXJyb3JDb2RlID0gU0NTSV9TRU5TRV9DVVJSRU5UX0VS
Uk9SUzsKIAkJCXNlbnNlYnVmZmVyLT5TZW5zZUtleSA9IElMTEVHQUxfUkVRVUVTVDsKIAkJCXNl
bnNlYnVmZmVyLT5BZGRpdGlvbmFsU2Vuc2VMZW5ndGggPSAweDBBOwogCQkJc2Vuc2VidWZmZXIt
PkFkZGl0aW9uYWxTZW5zZUNvZGUgPSAweDIwOwogCQkJc2Vuc2VidWZmZXItPlZhbGlkID0gMTsK
IAkJCXJldHZhbHVlID0gQVJDTVNSX01FU1NBR0VfRkFJTDsKIAkJfSBlbHNlIHsKLQkJCW15X2Vt
cHR5X2xlbiA9ICh3cWJ1Zl9maXJzdGluZGV4LXdxYnVmX2xhc3RpbmRleCAtIDEpCi0JCQkJJihB
UkNNU1JfTUFYX1FCVUZGRVIgLSAxKTsKKwkJCW15X2VtcHR5X2xlbiA9ICh3cWJ1Zl9maXJzdGlu
ZGV4IC0gd3FidWZfbGFzdGluZGV4IC0gMSkKKwkJCSYgKEFSQ01TUl9NQVhfUUJVRkZFUiAtIDEp
OwogCQkJaWYgKG15X2VtcHR5X2xlbiA+PSB1c2VyX2xlbikgewogCQkJCXdoaWxlICh1c2VyX2xl
biA+IDApIHsKLQkJCQkJcFFidWZmZXIgPQotCQkJCQkmYWNiLT53cWJ1ZmZlclthY2ItPndxYnVm
X2xhc3RpbmRleF07Ci0JCQkJCW1lbWNweShwUWJ1ZmZlciwgcHRtcHVzZXJidWZmZXIsIDEpOwot
CQkJCQlhY2ItPndxYnVmX2xhc3RpbmRleCsrOwotCQkJCQlhY2ItPndxYnVmX2xhc3RpbmRleCAl
PSBBUkNNU1JfTUFYX1FCVUZGRVI7Ci0JCQkJCXB0bXB1c2VyYnVmZmVyKys7Ci0JCQkJCXVzZXJf
bGVuLS07CisJCQkJCXBRYnVmZmVyID0gJmFjYi0+d3FidWZmZXJbYWNiLT53cWJ1Zl9sYXN0aW5k
ZXhdOworCQkJCQlpZiAoKGFjYi0+d3FidWZfbGFzdGluZGV4ICsgdXNlcl9sZW4pCisJCQkJCQk+
IEFSQ01TUl9NQVhfUUJVRkZFUikgeworCQkJCQkJbWVtY3B5KCh2b2lkICopcFFidWZmZXIsCisJ
CQkJCQkJKGNvbnN0IHZvaWQgKilwdG1wdXNlcmJ1ZmZlciwKKwkJCQkJCQlBUkNNU1JfTUFYX1FC
VUZGRVIgLQorCQkJCQkJCWFjYi0+d3FidWZfbGFzdGluZGV4KTsKKwkJCQkJCXB0bXB1c2VyYnVm
ZmVyICs9IChBUkNNU1JfTUFYX1FCVUZGRVIKKwkJCQkJCQktIGFjYi0+d3FidWZfbGFzdGluZGV4
KTsKKwkJCQkJCXVzZXJfbGVuIC09IChBUkNNU1JfTUFYX1FCVUZGRVIKKwkJCQkJCQktIGFjYi0+
d3FidWZfbGFzdGluZGV4KTsKKwkJCQkJCWFjYi0+d3FidWZfbGFzdGluZGV4ID0gMDsKKwkJCQkJ
fSBlbHNlIHsKKwkJCQkJCW1lbWNweSgodm9pZCAqKXBRYnVmZmVyLAorCQkJCQkJCShjb25zdCB2
b2lkICopcHRtcHVzZXJidWZmZXIsCisJCQkJCQkJdXNlcl9sZW4pOworCQkJCQkJYWNiLT53cWJ1
Zl9sYXN0aW5kZXggKz0gdXNlcl9sZW47CisJCQkJCQlhY2ItPndxYnVmX2xhc3RpbmRleCAlPQor
CQkJCQkJCUFSQ01TUl9NQVhfUUJVRkZFUjsKKwkJCQkJCXVzZXJfbGVuID0gMDsKKwkJCQkJfQog
CQkJCX0KLQkJCQlpZiAoYWNiLT5hY2JfZmxhZ3MgJiBBQ0JfRl9NRVNTQUdFX1dRQlVGRkVSX0NM
RUFSRUQpIHsKKwkJCQlpZiAoYWNiLT5hY2JfZmxhZ3MgJgorCQkJCQlBQ0JfRl9NRVNTQUdFX1dR
QlVGRkVSX0NMRUFSRUQpIHsKIAkJCQkJYWNiLT5hY2JfZmxhZ3MgJj0KIAkJCQkJCX5BQ0JfRl9N
RVNTQUdFX1dRQlVGRkVSX0NMRUFSRUQ7Ci0JCQkJCWFyY21zcl9wb3N0X2lvY3RsZGF0YTJpb3Ao
YWNiKTsKKwkJCQkJYXJjbXNyX3dyaXRlX2lvY3RsZGF0YTJpb3AoYWNiKTsKIAkJCQl9CiAJCQl9
IGVsc2UgewotCQkJCS8qIGhhcyBlcnJvciByZXBvcnQgc2Vuc2VkYXRhICovCiAJCQkJc3RydWN0
IFNFTlNFX0RBVEEgKnNlbnNlYnVmZmVyID0KIAkJCQkJKHN0cnVjdCBTRU5TRV9EQVRBICopY21k
LT5zZW5zZV9idWZmZXI7Ci0JCQkJc2Vuc2VidWZmZXItPkVycm9yQ29kZSA9IDB4NzA7CisJCQkJ
LyogaGFzIGVycm9yIHJlcG9ydCBzZW5zZWRhdGEgKi8KKwkJCQlzZW5zZWJ1ZmZlci0+RXJyb3JD
b2RlID0KKwkJCQkJU0NTSV9TRU5TRV9DVVJSRU5UX0VSUk9SUzsKIAkJCQlzZW5zZWJ1ZmZlci0+
U2Vuc2VLZXkgPSBJTExFR0FMX1JFUVVFU1Q7CiAJCQkJc2Vuc2VidWZmZXItPkFkZGl0aW9uYWxT
ZW5zZUxlbmd0aCA9IDB4MEE7CiAJCQkJc2Vuc2VidWZmZXItPkFkZGl0aW9uYWxTZW5zZUNvZGUg
PSAweDIwOwogCQkJCXNlbnNlYnVmZmVyLT5WYWxpZCA9IDE7CiAJCQkJcmV0dmFsdWUgPSBBUkNN
U1JfTUVTU0FHRV9GQUlMOwogCQkJfQotCQkJfQotCQkJa2ZyZWUodmVyX2FkZHIpOworCQl9CisJ
CXNwaW5fdW5sb2NrX2lycXJlc3RvcmUoJmFjYi0+d3FidWZmZXJfbG9jaywgZmxhZ3MpOworCQlr
ZnJlZSgoY29uc3Qgdm9pZCAqKXZlcl9hZGRyKTsKKwkJaWYgKGFjYi0+ZndfZmxhZyA9PSBGV19E
RUFETE9DSykgeworCQkJcGNtZG1lc3NhZ2VmbGQtPmNtZG1lc3NhZ2UuUmV0dXJuQ29kZSA9CisJ
CQkJQVJDTVNSX01FU1NBR0VfUkVUVVJOQ09ERV9CVVNfSEFOR19PTjsKKwkJfSBlbHNlIHsKKwkJ
CXBjbWRtZXNzYWdlZmxkLT5jbWRtZXNzYWdlLlJldHVybkNvZGUgPQorCQkJCUFSQ01TUl9NRVNT
QUdFX1JFVFVSTkNPREVfT0s7CiAJCX0KIAkJYnJlYWs7Ci0KKwl9CiAJY2FzZSBBUkNNU1JfTUVT
U0FHRV9DTEVBUl9SUUJVRkZFUjogewogCQl1aW50OF90ICpwUWJ1ZmZlciA9IGFjYi0+cnFidWZm
ZXI7Ci0JCWlmIChhY2ItPmFjYl9mbGFncyAmIEFDQl9GX0lPUERBVEFfT1ZFUkZMT1cpIHsKLQkJ
CWFjYi0+YWNiX2ZsYWdzICY9IH5BQ0JfRl9JT1BEQVRBX09WRVJGTE9XOwotCQkJYXJjbXNyX2lv
cF9tZXNzYWdlX3JlYWQoYWNiKTsKLQkJfQorCisJCWFyY21zcl9jbGVhcl9pb3AyZHJ2X3JxdWV1
ZV9idWZmZXIoYWNiKTsKKwkJc3Bpbl9sb2NrX2lycXNhdmUoJmFjYi0+cnFidWZmZXJfbG9jaywg
ZmxhZ3MpOwogCQlhY2ItPmFjYl9mbGFncyB8PSBBQ0JfRl9NRVNTQUdFX1JRQlVGRkVSX0NMRUFS
RUQ7CiAJCWFjYi0+cnFidWZfZmlyc3RpbmRleCA9IDA7CiAJCWFjYi0+cnFidWZfbGFzdGluZGV4
ID0gMDsKIAkJbWVtc2V0KHBRYnVmZmVyLCAwLCBBUkNNU1JfTUFYX1FCVUZGRVIpOwotCQlpZihh
Y2ItPmZ3X2ZsYWcgPT0gRldfREVBRExPQ0spIHsKKwkJc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSgm
YWNiLT5ycWJ1ZmZlcl9sb2NrLCBmbGFncyk7CisJCWlmIChhY2ItPmZ3X2ZsYWcgPT0gRldfREVB
RExPQ0spIHsKIAkJCXBjbWRtZXNzYWdlZmxkLT5jbWRtZXNzYWdlLlJldHVybkNvZGUgPQotCQkJ
QVJDTVNSX01FU1NBR0VfUkVUVVJOQ09ERV9CVVNfSEFOR19PTjsKLQkJfWVsc2V7CisJCQkJQVJD
TVNSX01FU1NBR0VfUkVUVVJOQ09ERV9CVVNfSEFOR19PTjsKKwkJfSBlbHNlIHsKIAkJCXBjbWRt
ZXNzYWdlZmxkLT5jbWRtZXNzYWdlLlJldHVybkNvZGUgPQotCQkJQVJDTVNSX01FU1NBR0VfUkVU
VVJOQ09ERV9PSzsKLQkJfQorCQkJCUFSQ01TUl9NRVNTQUdFX1JFVFVSTkNPREVfT0s7CiAJCX0K
IAkJYnJlYWs7Ci0KKwl9CiAJY2FzZSBBUkNNU1JfTUVTU0FHRV9DTEVBUl9XUUJVRkZFUjogewog
CQl1aW50OF90ICpwUWJ1ZmZlciA9IGFjYi0+d3FidWZmZXI7Ci0JCWlmKGFjYi0+ZndfZmxhZyA9
PSBGV19ERUFETE9DSykgewotCQkJcGNtZG1lc3NhZ2VmbGQtPmNtZG1lc3NhZ2UuUmV0dXJuQ29k
ZSA9Ci0JCQlBUkNNU1JfTUVTU0FHRV9SRVRVUk5DT0RFX0JVU19IQU5HX09OOwotCQl9ZWxzZXsK
LQkJCXBjbWRtZXNzYWdlZmxkLT5jbWRtZXNzYWdlLlJldHVybkNvZGUgPQotCQkJQVJDTVNSX01F
U1NBR0VfUkVUVVJOQ09ERV9PSzsKLQkJfQotCi0JCWlmIChhY2ItPmFjYl9mbGFncyAmIEFDQl9G
X0lPUERBVEFfT1ZFUkZMT1cpIHsKLQkJCWFjYi0+YWNiX2ZsYWdzICY9IH5BQ0JfRl9JT1BEQVRB
X09WRVJGTE9XOwotCQkJYXJjbXNyX2lvcF9tZXNzYWdlX3JlYWQoYWNiKTsKLQkJfQotCQlhY2It
PmFjYl9mbGFncyB8PQotCQkJKEFDQl9GX01FU1NBR0VfV1FCVUZGRVJfQ0xFQVJFRCB8Ci0JCQkJ
QUNCX0ZfTUVTU0FHRV9XUUJVRkZFUl9SRUFERUQpOworCQlzcGluX2xvY2tfaXJxc2F2ZSgmYWNi
LT53cWJ1ZmZlcl9sb2NrLCBmbGFncyk7CisJCWFjYi0+YWNiX2ZsYWdzIHw9IChBQ0JfRl9NRVNT
QUdFX1dRQlVGRkVSX0NMRUFSRUQgfAorCQkJQUNCX0ZfTUVTU0FHRV9XUUJVRkZFUl9SRUFERUQp
OwogCQlhY2ItPndxYnVmX2ZpcnN0aW5kZXggPSAwOwogCQlhY2ItPndxYnVmX2xhc3RpbmRleCA9
IDA7CiAJCW1lbXNldChwUWJ1ZmZlciwgMCwgQVJDTVNSX01BWF9RQlVGRkVSKTsKKwkJc3Bpbl91
bmxvY2tfaXJxcmVzdG9yZSgmYWNiLT53cWJ1ZmZlcl9sb2NrLCBmbGFncyk7CisJCWlmIChhY2It
PmZ3X2ZsYWcgPT0gRldfREVBRExPQ0spIHsKKwkJCXBjbWRtZXNzYWdlZmxkLT5jbWRtZXNzYWdl
LlJldHVybkNvZGUgPQorCQkJCUFSQ01TUl9NRVNTQUdFX1JFVFVSTkNPREVfQlVTX0hBTkdfT047
CisJCX0gZWxzZSB7CisJCQlwY21kbWVzc2FnZWZsZC0+Y21kbWVzc2FnZS5SZXR1cm5Db2RlID0K
KwkJCQlBUkNNU1JfTUVTU0FHRV9SRVRVUk5DT0RFX09LOwogCQl9CiAJCWJyZWFrOwotCisJfQog
CWNhc2UgQVJDTVNSX01FU1NBR0VfQ0xFQVJfQUxMUUJVRkZFUjogewogCQl1aW50OF90ICpwUWJ1
ZmZlcjsKLQotCQlpZiAoYWNiLT5hY2JfZmxhZ3MgJiBBQ0JfRl9JT1BEQVRBX09WRVJGTE9XKSB7
Ci0JCQlhY2ItPmFjYl9mbGFncyAmPSB+QUNCX0ZfSU9QREFUQV9PVkVSRkxPVzsKLQkJCWFyY21z
cl9pb3BfbWVzc2FnZV9yZWFkKGFjYik7Ci0JCX0KLQkJYWNiLT5hY2JfZmxhZ3MgfD0KLQkJCShB
Q0JfRl9NRVNTQUdFX1dRQlVGRkVSX0NMRUFSRUQKLQkJCXwgQUNCX0ZfTUVTU0FHRV9SUUJVRkZF
Ul9DTEVBUkVECi0JCQl8IEFDQl9GX01FU1NBR0VfV1FCVUZGRVJfUkVBREVEKTsKKwkJYXJjbXNy
X2NsZWFyX2lvcDJkcnZfcnF1ZXVlX2J1ZmZlcihhY2IpOworCQlzcGluX2xvY2tfaXJxc2F2ZSgm
YWNiLT5ycWJ1ZmZlcl9sb2NrLCBmbGFncyk7CisJCWFjYi0+YWNiX2ZsYWdzIHw9IEFDQl9GX01F
U1NBR0VfUlFCVUZGRVJfQ0xFQVJFRDsKIAkJYWNiLT5ycWJ1Zl9maXJzdGluZGV4ID0gMDsKIAkJ
YWNiLT5ycWJ1Zl9sYXN0aW5kZXggPSAwOwotCQlhY2ItPndxYnVmX2ZpcnN0aW5kZXggPSAwOwot
CQlhY2ItPndxYnVmX2xhc3RpbmRleCA9IDA7CiAJCXBRYnVmZmVyID0gYWNiLT5ycWJ1ZmZlcjsK
IAkJbWVtc2V0KHBRYnVmZmVyLCAwLCBzaXplb2Yoc3RydWN0IFFCVUZGRVIpKTsKKwkJc3Bpbl91
bmxvY2tfaXJxcmVzdG9yZSgmYWNiLT5ycWJ1ZmZlcl9sb2NrLCBmbGFncyk7CisJCXNwaW5fbG9j
a19pcnFzYXZlKCZhY2ItPndxYnVmZmVyX2xvY2ssIGZsYWdzKTsKKwkJYWNiLT5hY2JfZmxhZ3Mg
fD0gKEFDQl9GX01FU1NBR0VfV1FCVUZGRVJfQ0xFQVJFRCB8CisJCQlBQ0JfRl9NRVNTQUdFX1dR
QlVGRkVSX1JFQURFRCk7CisJCWFjYi0+d3FidWZfZmlyc3RpbmRleCA9IDA7CisJCWFjYi0+d3Fi
dWZfbGFzdGluZGV4ID0gMDsKIAkJcFFidWZmZXIgPSBhY2ItPndxYnVmZmVyOwogCQltZW1zZXQo
cFFidWZmZXIsIDAsIHNpemVvZihzdHJ1Y3QgUUJVRkZFUikpOwotCQlpZihhY2ItPmZ3X2ZsYWcg
PT0gRldfREVBRExPQ0spIHsKKwkJc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSgmYWNiLT53cWJ1ZmZl
cl9sb2NrLCBmbGFncyk7CisJCWlmIChhY2ItPmZ3X2ZsYWcgPT0gRldfREVBRExPQ0spIHsKIAkJ
CXBjbWRtZXNzYWdlZmxkLT5jbWRtZXNzYWdlLlJldHVybkNvZGUgPQotCQkJQVJDTVNSX01FU1NB
R0VfUkVUVVJOQ09ERV9CVVNfSEFOR19PTjsKLQkJfWVsc2V7CisJCQkJQVJDTVNSX01FU1NBR0Vf
UkVUVVJOQ09ERV9CVVNfSEFOR19PTjsKKwkJfSBlbHNlIHsKIAkJCXBjbWRtZXNzYWdlZmxkLT5j
bWRtZXNzYWdlLlJldHVybkNvZGUgPQotCQkJQVJDTVNSX01FU1NBR0VfUkVUVVJOQ09ERV9PSzsK
LQkJfQorCQkJCUFSQ01TUl9NRVNTQUdFX1JFVFVSTkNPREVfT0s7CiAJCX0KIAkJYnJlYWs7Ci0K
Kwl9CiAJY2FzZSBBUkNNU1JfTUVTU0FHRV9SRVRVUk5fQ09ERV8zRjogewotCQlpZihhY2ItPmZ3
X2ZsYWcgPT0gRldfREVBRExPQ0spIHsKKwkJaWYgKGFjYi0+ZndfZmxhZyA9PSBGV19ERUFETE9D
SykgewogCQkJcGNtZG1lc3NhZ2VmbGQtPmNtZG1lc3NhZ2UuUmV0dXJuQ29kZSA9Ci0JCQlBUkNN
U1JfTUVTU0FHRV9SRVRVUk5DT0RFX0JVU19IQU5HX09OOwotCQl9ZWxzZXsKKwkJCQlBUkNNU1Jf
TUVTU0FHRV9SRVRVUk5DT0RFX0JVU19IQU5HX09OOworCQl9IGVsc2UgewogCQkJcGNtZG1lc3Nh
Z2VmbGQtPmNtZG1lc3NhZ2UuUmV0dXJuQ29kZSA9Ci0JCQlBUkNNU1JfTUVTU0FHRV9SRVRVUk5D
T0RFXzNGOworCQkJCUFSQ01TUl9NRVNTQUdFX1JFVFVSTkNPREVfM0Y7CiAJCX0KIAkJYnJlYWs7
Ci0JCX0KKwl9CiAJY2FzZSBBUkNNU1JfTUVTU0FHRV9TQVlfSEVMTE86IHsKIAkJaW50OF90ICpo
ZWxsb19zdHJpbmcgPSAiSGVsbG8hIEkgYW0gQVJDTVNSIjsKLQkJaWYoYWNiLT5md19mbGFnID09
IEZXX0RFQURMT0NLKSB7CisJCWlmIChhY2ItPmZ3X2ZsYWcgPT0gRldfREVBRExPQ0spIHsKIAkJ
CXBjbWRtZXNzYWdlZmxkLT5jbWRtZXNzYWdlLlJldHVybkNvZGUgPQotCQkJQVJDTVNSX01FU1NB
R0VfUkVUVVJOQ09ERV9CVVNfSEFOR19PTjsKLQkJfWVsc2V7CisJCQkJQVJDTVNSX01FU1NBR0Vf
UkVUVVJOQ09ERV9CVVNfSEFOR19PTjsKKwkJfSBlbHNlIHsKIAkJCXBjbWRtZXNzYWdlZmxkLT5j
bWRtZXNzYWdlLlJldHVybkNvZGUgPQotCQkJQVJDTVNSX01FU1NBR0VfUkVUVVJOQ09ERV9PSzsK
LQkJfQotCQltZW1jcHkocGNtZG1lc3NhZ2VmbGQtPm1lc3NhZ2VkYXRhYnVmZmVyLCBoZWxsb19z
dHJpbmcKLQkJCSwgKGludDE2X3Qpc3RybGVuKGhlbGxvX3N0cmluZykpOworCQkJCUFSQ01TUl9N
RVNTQUdFX1JFVFVSTkNPREVfT0s7CiAJCX0KKwkJbWVtY3B5KCh2b2lkICopcGNtZG1lc3NhZ2Vm
bGQtPm1lc3NhZ2VkYXRhYnVmZmVyLAorCQkoY29uc3Qgdm9pZCAqKWhlbGxvX3N0cmluZywgKGlu
dDE2X3Qpc3RybGVuKGhlbGxvX3N0cmluZykpOwogCQlicmVhazsKLQotCWNhc2UgQVJDTVNSX01F
U1NBR0VfU0FZX0dPT0RCWUU6Ci0JCWlmKGFjYi0+ZndfZmxhZyA9PSBGV19ERUFETE9DSykgewor
CX0KKwljYXNlIEFSQ01TUl9NRVNTQUdFX1NBWV9HT09EQllFOiB7CisJCWlmIChhY2ItPmZ3X2Zs
YWcgPT0gRldfREVBRExPQ0spIHsKKwkJCXBjbWRtZXNzYWdlZmxkLT5jbWRtZXNzYWdlLlJldHVy
bkNvZGUgPQorCQkJCUFSQ01TUl9NRVNTQUdFX1JFVFVSTkNPREVfQlVTX0hBTkdfT047CisJCX0g
ZWxzZSB7CiAJCQlwY21kbWVzc2FnZWZsZC0+Y21kbWVzc2FnZS5SZXR1cm5Db2RlID0KLQkJCUFS
Q01TUl9NRVNTQUdFX1JFVFVSTkNPREVfQlVTX0hBTkdfT047CisJCQkJQVJDTVNSX01FU1NBR0Vf
UkVUVVJOQ09ERV9PSzsKIAkJfQogCQlhcmNtc3JfaW9wX3BhcmtpbmcoYWNiKTsKIAkJYnJlYWs7
Ci0KLQljYXNlIEFSQ01TUl9NRVNTQUdFX0ZMVVNIX0FEQVBURVJfQ0FDSEU6Ci0JCWlmKGFjYi0+
ZndfZmxhZyA9PSBGV19ERUFETE9DSykgeworCX0KKwljYXNlIEFSQ01TUl9NRVNTQUdFX0ZMVVNI
X0FEQVBURVJfQ0FDSEU6IHsKKwkJaWYgKGFjYi0+ZndfZmxhZyA9PSBGV19ERUFETE9DSykgewog
CQkJcGNtZG1lc3NhZ2VmbGQtPmNtZG1lc3NhZ2UuUmV0dXJuQ29kZSA9Ci0JCQlBUkNNU1JfTUVT
U0FHRV9SRVRVUk5DT0RFX0JVU19IQU5HX09OOworCQkJCUFSQ01TUl9NRVNTQUdFX1JFVFVSTkNP
REVfQlVTX0hBTkdfT047CisJCX0gZWxzZSB7CisJCQlwY21kbWVzc2FnZWZsZC0+Y21kbWVzc2Fn
ZS5SZXR1cm5Db2RlID0KKwkJCQlBUkNNU1JfTUVTU0FHRV9SRVRVUk5DT0RFX09LOwogCQl9CiAJ
CWFyY21zcl9mbHVzaF9hZGFwdGVyX2NhY2hlKGFjYik7CiAJCWJyZWFrOwotCisJfQogCWRlZmF1
bHQ6CiAJCXJldHZhbHVlID0gQVJDTVNSX01FU1NBR0VfRkFJTDsKKwkJcHJfaW5mbygiJXM6IHVu
a25vd24gY29udHJvbGNvZGUhXG4iLCBfX2Z1bmNfXyk7CiAJfQogCW1lc3NhZ2Vfb3V0OgotCXNn
ID0gc2NzaV9zZ2xpc3QoY21kKTsKLQlrdW5tYXBfYXRvbWljKGJ1ZmZlciAtIHNnLT5vZmZzZXQp
OworCWlmICh1c2Vfc2cpIHsKKwkJc3RydWN0IHNjYXR0ZXJsaXN0ICpzZzsKKwkJc2cgPSBzY3Np
X3NnbGlzdChjbWQpOworCQlrdW5tYXBfYXRvbWljKGJ1ZmZlciAtIHNnLT5vZmZzZXQpOworCX0K
IAlyZXR1cm4gcmV0dmFsdWU7CiB9CiAKLXN0YXRpYyBzdHJ1Y3QgQ29tbWFuZENvbnRyb2xCbG9j
ayAqYXJjbXNyX2dldF9mcmVlY2NiKHN0cnVjdCBBZGFwdGVyQ29udHJvbEJsb2NrICphY2IpCitz
dHJ1Y3QgQ29tbWFuZENvbnRyb2xCbG9jaworKmFyY21zcl9nZXRfZnJlZWNjYihzdHJ1Y3QgQWRh
cHRlckNvbnRyb2xCbG9jayAqYWNiKQogewogCXN0cnVjdCBsaXN0X2hlYWQgKmhlYWQgPSAmYWNi
LT5jY2JfZnJlZV9saXN0OwogCXN0cnVjdCBDb21tYW5kQ29udHJvbEJsb2NrICpjY2IgPSBOVUxM
OwogCXVuc2lnbmVkIGxvbmcgZmxhZ3M7CiAJc3Bpbl9sb2NrX2lycXNhdmUoJmFjYi0+Y2NibGlz
dF9sb2NrLCBmbGFncyk7CiAJaWYgKCFsaXN0X2VtcHR5KGhlYWQpKSB7Ci0JCWNjYiA9IGxpc3Rf
ZW50cnkoaGVhZC0+bmV4dCwgc3RydWN0IENvbW1hbmRDb250cm9sQmxvY2ssIGxpc3QpOworCQlj
Y2IgPSBsaXN0X2VudHJ5KGhlYWQtPm5leHQsCisJCQlzdHJ1Y3QgQ29tbWFuZENvbnRyb2xCbG9j
aywgbGlzdCk7CiAJCWxpc3RfZGVsX2luaXQoJmNjYi0+bGlzdCk7Ci0JfWVsc2V7CisJfSBlbHNl
IHsKIAkJc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSgmYWNiLT5jY2JsaXN0X2xvY2ssIGZsYWdzKTsK
IAkJcmV0dXJuIDA7CiAJfQpAQCAtMjAwNSw3ICsyOTE3LDggQEAgc3RhdGljIHN0cnVjdCBDb21t
YW5kQ29udHJvbEJsb2NrICphcmNtcwogCXJldHVybiBjY2I7CiB9CiAKLXN0YXRpYyB2b2lkIGFy
Y21zcl9oYW5kbGVfdmlydHVhbF9jb21tYW5kKHN0cnVjdCBBZGFwdGVyQ29udHJvbEJsb2NrICph
Y2IsCit2b2lkCithcmNtc3JfaGFuZGxlX3ZpcnR1YWxfY29tbWFuZChzdHJ1Y3QgQWRhcHRlckNv
bnRyb2xCbG9jayAqYWNiLAogCQlzdHJ1Y3Qgc2NzaV9jbW5kICpjbWQpCiB7CiAJc3dpdGNoIChj
bWQtPmNtbmRbMF0pIHsKQEAgLTIwMTMsNyArMjkyNiw2IEBAIHN0YXRpYyB2b2lkIGFyY21zcl9o
YW5kbGVfdmlydHVhbF9jb21tYW4KIAkJdW5zaWduZWQgY2hhciBpbnFkYXRhWzM2XTsKIAkJY2hh
ciAqYnVmZmVyOwogCQlzdHJ1Y3Qgc2NhdHRlcmxpc3QgKnNnOwotCiAJCWlmIChjbWQtPmRldmlj
ZS0+bHVuKSB7CiAJCQljbWQtPnJlc3VsdCA9IChESURfVElNRV9PVVQgPDwgMTYpOwogCQkJY21k
LT5zY3NpX2RvbmUoY21kKTsKQEAgLTIwMzIsMTQgKzI5NDQsMTEgQEAgc3RhdGljIHZvaWQgYXJj
bXNyX2hhbmRsZV92aXJ0dWFsX2NvbW1hbgogCQlzdHJuY3B5KCZpbnFkYXRhWzE2XSwgIlJBSUQg
Y29udHJvbGxlciAiLCAxNik7CiAJCS8qIFByb2R1Y3QgSWRlbnRpZmljYXRpb24gKi8KIAkJc3Ry
bmNweSgmaW5xZGF0YVszMl0sICJSMDAxIiwgNCk7IC8qIFByb2R1Y3QgUmV2aXNpb24gKi8KLQog
CQlzZyA9IHNjc2lfc2dsaXN0KGNtZCk7CiAJCWJ1ZmZlciA9IGttYXBfYXRvbWljKHNnX3BhZ2Uo
c2cpKSArIHNnLT5vZmZzZXQ7Ci0KLQkJbWVtY3B5KGJ1ZmZlciwgaW5xZGF0YSwgc2l6ZW9mKGlu
cWRhdGEpKTsKKwkJbWVtY3B5KCh2b2lkICopYnVmZmVyLCAoY29uc3Qgdm9pZCAqKWlucWRhdGEs
IHNpemVvZihpbnFkYXRhKSk7CiAJCXNnID0gc2NzaV9zZ2xpc3QoY21kKTsKIAkJa3VubWFwX2F0
b21pYyhidWZmZXIgLSBzZy0+b2Zmc2V0KTsKLQogCQljbWQtPnNjc2lfZG9uZShjbWQpOwogCX0K
IAlicmVhazsKQEAgLTIwNTUsMTEgKzI5NjQsMTMgQEAgc3RhdGljIHZvaWQgYXJjbXNyX2hhbmRs
ZV92aXJ0dWFsX2NvbW1hbgogCX0KIH0KIAotc3RhdGljIGludCBhcmNtc3JfcXVldWVfY29tbWFu
ZF9sY2soc3RydWN0IHNjc2lfY21uZCAqY21kLAorc3RhdGljIGludAorYXJjbXNyX3F1ZXVlX2Nv
bW1hbmRfbGNrKHN0cnVjdCBzY3NpX2NtbmQgKmNtZCwKIAl2b2lkICgqIGRvbmUpKHN0cnVjdCBz
Y3NpX2NtbmQgKikpCiB7CiAJc3RydWN0IFNjc2lfSG9zdCAqaG9zdCA9IGNtZC0+ZGV2aWNlLT5o
b3N0OwotCXN0cnVjdCBBZGFwdGVyQ29udHJvbEJsb2NrICphY2IgPSAoc3RydWN0IEFkYXB0ZXJD
b250cm9sQmxvY2sgKikgaG9zdC0+aG9zdGRhdGE7CisJc3RydWN0IEFkYXB0ZXJDb250cm9sQmxv
Y2sgKmFjYiA9CisJCShzdHJ1Y3QgQWRhcHRlckNvbnRyb2xCbG9jayAqKWhvc3QtPmhvc3RkYXRh
OwogCXN0cnVjdCBDb21tYW5kQ29udHJvbEJsb2NrICpjY2I7CiAJaW50IHRhcmdldCA9IGNtZC0+
ZGV2aWNlLT5pZDsKIAlpbnQgbHVuID0gY21kLT5kZXZpY2UtPmx1bjsKQEAgLTIwNjcsMTAgKzI5
NzgsMTAgQEAgc3RhdGljIGludCBhcmNtc3JfcXVldWVfY29tbWFuZF9sY2soc3RydQogCWNtZC0+
c2NzaV9kb25lID0gZG9uZTsKIAljbWQtPmhvc3Rfc2NyaWJibGUgPSBOVUxMOwogCWNtZC0+cmVz
dWx0ID0gMDsKLQlpZiAoKHNjc2ljbWQgPT0gU1lOQ0hST05JWkVfQ0FDSEUpIHx8KHNjc2ljbWQg
PT0gU0VORF9ESUFHTk9TVElDKSl7Ci0JCWlmKGFjYi0+ZGV2c3RhdGVbdGFyZ2V0XVtsdW5dID09
IEFSRUNBX1JBSURfR09ORSkgewotICAgIAkJCWNtZC0+cmVzdWx0ID0gKERJRF9OT19DT05ORUNU
IDw8IDE2KTsKLQkJfQorCWlmICgoc2NzaWNtZCA9PSBTWU5DSFJPTklaRV9DQUNIRSkgfHwKKwkJ
KHNjc2ljbWQgPT0gU0VORF9ESUFHTk9TVElDKSkgeworCQlpZiAoYWNiLT5kZXZzdGF0ZVt0YXJn
ZXRdW2x1bl0gPT0gQVJFQ0FfUkFJRF9HT05FKQorCQkJY21kLT5yZXN1bHQgPSAoRElEX05PX0NP
Tk5FQ1QgPDwgMTYpOwogCQljbWQtPnNjc2lfZG9uZShjbWQpOwogCQlyZXR1cm4gMDsKIAl9CkBA
IC0yMDgwLDEzICsyOTkxLDE0IEBAIHN0YXRpYyBpbnQgYXJjbXNyX3F1ZXVlX2NvbW1hbmRfbGNr
KHN0cnUKIAkJcmV0dXJuIDA7CiAJfQogCWlmIChhdG9taWNfcmVhZCgmYWNiLT5jY2JvdXRzdGFu
ZGluZ2NvdW50KSA+PQotCQkJQVJDTVNSX01BWF9PVVRTVEFORElOR19DTUQpCisJCWFjYi0+bWF4
T3V0c3RhbmRpbmcpCiAJCXJldHVybiBTQ1NJX01MUVVFVUVfSE9TVF9CVVNZOwogCWNjYiA9IGFy
Y21zcl9nZXRfZnJlZWNjYihhY2IpOwogCWlmICghY2NiKQogCQlyZXR1cm4gU0NTSV9NTFFVRVVF
X0hPU1RfQlVTWTsKIAlpZiAoYXJjbXNyX2J1aWxkX2NjYiggYWNiLCBjY2IsIGNtZCApID09IEZB
SUxFRCkgewotCQljbWQtPnJlc3VsdCA9IChESURfRVJST1IgPDwgMTYpIHwgKFJFU0VSVkFUSU9O
X0NPTkZMSUNUIDw8IDEpOworCQljbWQtPnJlc3VsdCA9IChESURfRVJST1IgPDwgMTYpIHwKKwkJ
CShSRVNFUlZBVElPTl9DT05GTElDVCA8PCAxKTsKIAkJY21kLT5zY3NpX2RvbmUoY21kKTsKIAkJ
cmV0dXJuIDA7CiAJfQpAQCAtMjA5NiwyNCArMzAwOCwzMCBAQCBzdGF0aWMgaW50IGFyY21zcl9x
dWV1ZV9jb21tYW5kX2xjayhzdHJ1CiAKIHN0YXRpYyBERUZfU0NTSV9RQ01EKGFyY21zcl9xdWV1
ZV9jb21tYW5kKQogCi1zdGF0aWMgYm9vbCBhcmNtc3JfZ2V0X2hiYV9jb25maWcoc3RydWN0IEFk
YXB0ZXJDb250cm9sQmxvY2sgKmFjYikKK3N0YXRpYyBib29sCithcmNtc3JfaGJhQV9nZXRfY29u
ZmlnKHN0cnVjdCBBZGFwdGVyQ29udHJvbEJsb2NrICphY2IpCiB7CiAJc3RydWN0IE1lc3NhZ2VV
bml0X0EgX19pb21lbSAqcmVnID0gYWNiLT5wbXVBOwogCWNoYXIgKmFjYl9maXJtX21vZGVsID0g
YWNiLT5maXJtX21vZGVsOwogCWNoYXIgKmFjYl9maXJtX3ZlcnNpb24gPSBhY2ItPmZpcm1fdmVy
c2lvbjsKIAljaGFyICphY2JfZGV2aWNlX21hcCA9IGFjYi0+ZGV2aWNlX21hcDsKLQljaGFyIF9f
aW9tZW0gKmlvcF9maXJtX21vZGVsID0gKGNoYXIgX19pb21lbSAqKSgmcmVnLT5tZXNzYWdlX3J3
YnVmZmVyWzE1XSk7Ci0JY2hhciBfX2lvbWVtICppb3BfZmlybV92ZXJzaW9uID0gKGNoYXIgX19p
b21lbSAqKSgmcmVnLT5tZXNzYWdlX3J3YnVmZmVyWzE3XSk7Ci0JY2hhciBfX2lvbWVtICppb3Bf
ZGV2aWNlX21hcCA9IChjaGFyIF9faW9tZW0gKikoJnJlZy0+bWVzc2FnZV9yd2J1ZmZlclsyMV0p
OworCWNoYXIgX19pb21lbSAqaW9wX2Zpcm1fbW9kZWwgPQorCQkoY2hhciBfX2lvbWVtICopKCZy
ZWctPm1lc3NhZ2VfcndidWZmZXJbMTVdKTsKKwljaGFyIF9faW9tZW0gKmlvcF9maXJtX3ZlcnNp
b24gPQorCQkoY2hhciBfX2lvbWVtICopKCZyZWctPm1lc3NhZ2VfcndidWZmZXJbMTddKTsKKwlj
aGFyIF9faW9tZW0gKmlvcF9kZXZpY2VfbWFwID0KKwkJKGNoYXIgX19pb21lbSAqKSgmcmVnLT5t
ZXNzYWdlX3J3YnVmZmVyWzIxXSk7CiAJaW50IGNvdW50OwotCXdyaXRlbChBUkNNU1JfSU5CT1VO
RF9NRVNHMF9HRVRfQ09ORklHLCAmcmVnLT5pbmJvdW5kX21zZ2FkZHIwKTsKLQlpZiAoIWFyY21z
cl9oYmFfd2FpdF9tc2dpbnRfcmVhZHkoYWNiKSkgewotCQlwcmludGsoS0VSTl9OT1RJQ0UgImFy
Y21zciVkOiB3YWl0ICdnZXQgYWRhcHRlciBmaXJtd2FyZSBcCi0JCQltaXNjZWxsYW5lb3VzIGRh
dGEnIHRpbWVvdXQgXG4iLCBhY2ItPmhvc3QtPmhvc3Rfbm8pOworCXdyaXRlbChBUkNNU1JfSU5C
T1VORF9NRVNHMF9HRVRfQ09ORklHLAorCQkmcmVnLT5pbmJvdW5kX21zZ2FkZHIwKTsKKwlpZiAo
IWFyY21zcl9oYmFBX3dhaXRfbXNnaW50X3JlYWR5KGFjYikpIHsKKwkJcHJfbm90aWNlKCJhcmNt
c3IlZDogd2FpdCAnZ2V0IGFkYXB0ZXIgZmlybXdhcmUgIgorCQkJIm1pc2NlbGxhbmVvdXMgZGF0
YScgdGltZW91dFxuIiwKKwkJCWFjYi0+aG9zdC0+aG9zdF9ubyk7CiAJCXJldHVybiBmYWxzZTsK
IAl9CiAJY291bnQgPSA4OwotCXdoaWxlIChjb3VudCl7CisJd2hpbGUgKGNvdW50KSB7CiAJCSph
Y2JfZmlybV9tb2RlbCA9IHJlYWRiKGlvcF9maXJtX21vZGVsKTsKIAkJYWNiX2Zpcm1fbW9kZWwr
KzsKIAkJaW9wX2Zpcm1fbW9kZWwrKzsKQEAgLTIxMjEsNyArMzAzOSw3IEBAIHN0YXRpYyBib29s
IGFyY21zcl9nZXRfaGJhX2NvbmZpZyhzdHJ1Y3QKIAl9CiAKIAljb3VudCA9IDE2OwotCXdoaWxl
IChjb3VudCl7CisJd2hpbGUgKGNvdW50KSB7CiAJCSphY2JfZmlybV92ZXJzaW9uID0gcmVhZGIo
aW9wX2Zpcm1fdmVyc2lvbik7CiAJCWFjYl9maXJtX3ZlcnNpb24rKzsKIAkJaW9wX2Zpcm1fdmVy
c2lvbisrOwpAQCAtMjEyOSwyNyArMzA0NywyOSBAQCBzdGF0aWMgYm9vbCBhcmNtc3JfZ2V0X2hi
YV9jb25maWcoc3RydWN0CiAJfQogCiAJY291bnQ9MTY7Ci0Jd2hpbGUoY291bnQpeworCXdoaWxl
IChjb3VudCkgewogCQkqYWNiX2RldmljZV9tYXAgPSByZWFkYihpb3BfZGV2aWNlX21hcCk7CiAJ
CWFjYl9kZXZpY2VfbWFwKys7CiAJCWlvcF9kZXZpY2VfbWFwKys7CiAJCWNvdW50LS07CiAJfQot
CXByaW50ayhLRVJOX05PVElDRSAiQXJlY2EgUkFJRCBDb250cm9sbGVyJWQ6IEYvVyAlcyAmIE1v
ZGVsICVzXG4iLCAKKwlwcl9ub3RpY2UoIkFyZWNhIFJBSUQgQ29udHJvbGxlciVkOiBNb2RlbCAl
cywgRi9XICVzXG4iLAogCQlhY2ItPmhvc3QtPmhvc3Rfbm8sCi0JCWFjYi0+ZmlybV92ZXJzaW9u
LAotCQlhY2ItPmZpcm1fbW9kZWwpOworCQlhY2ItPmZpcm1fbW9kZWwsCisJCWFjYi0+ZmlybV92
ZXJzaW9uKTsKIAlhY2ItPnNpZ25hdHVyZSA9IHJlYWRsKCZyZWctPm1lc3NhZ2VfcndidWZmZXJb
MF0pOwogCWFjYi0+ZmlybV9yZXF1ZXN0X2xlbiA9IHJlYWRsKCZyZWctPm1lc3NhZ2VfcndidWZm
ZXJbMV0pOwogCWFjYi0+ZmlybV9udW1iZXJzX3F1ZXVlID0gcmVhZGwoJnJlZy0+bWVzc2FnZV9y
d2J1ZmZlclsyXSk7CiAJYWNiLT5maXJtX3NkcmFtX3NpemUgPSByZWFkbCgmcmVnLT5tZXNzYWdl
X3J3YnVmZmVyWzNdKTsKIAlhY2ItPmZpcm1faGRfY2hhbm5lbHMgPSByZWFkbCgmcmVnLT5tZXNz
YWdlX3J3YnVmZmVyWzRdKTsKLQlhY2ItPmZpcm1fY2ZnX3ZlcnNpb24gPSByZWFkbCgmcmVnLT5t
ZXNzYWdlX3J3YnVmZmVyWzI1XSk7ICAvKmZpcm1fY2ZnX3ZlcnNpb24sMjUsMTAwLTEwMyovCisJ
YWNiLT5maXJtX2NmZ192ZXJzaW9uID0gcmVhZGwoJnJlZy0+bWVzc2FnZV9yd2J1ZmZlclsyNV0p
OwogCXJldHVybiB0cnVlOwogfQotc3RhdGljIGJvb2wgYXJjbXNyX2dldF9oYmJfY29uZmlnKHN0
cnVjdCBBZGFwdGVyQ29udHJvbEJsb2NrICphY2IpCisKK3N0YXRpYyBib29sCithcmNtc3JfaGJh
Ql9nZXRfY29uZmlnKHN0cnVjdCBBZGFwdGVyQ29udHJvbEJsb2NrICphY2IpCiB7Ci0Jc3RydWN0
IE1lc3NhZ2VVbml0X0IgKnJlZyA9IGFjYi0+cG11QjsKKwlzdHJ1Y3QgTWVzc2FnZVVuaXRfQiBf
X2lvbWVtICpyZWcgPSBhY2ItPnBtdUI7CiAJc3RydWN0IHBjaV9kZXYgKnBkZXYgPSBhY2ItPnBk
ZXY7CiAJdm9pZCAqZG1hX2NvaGVyZW50OwogCWRtYV9hZGRyX3QgZG1hX2NvaGVyZW50X2hhbmRs
ZTsKQEAgLTIxNjMsNDAgKzMwODMsNTcgQEAgc3RhdGljIGJvb2wgYXJjbXNyX2dldF9oYmJfY29u
ZmlnKHN0cnVjdAogCWNoYXIgX19pb21lbSAqaW9wX2RldmljZV9tYXA7CiAJLypmaXJtX3ZlcnNp
b24sMjEsODQtOTkqLwogCWludCBjb3VudDsKLQlkbWFfY29oZXJlbnQgPSBkbWFfYWxsb2NfY29o
ZXJlbnQoJnBkZXYtPmRldiwgc2l6ZW9mKHN0cnVjdCBNZXNzYWdlVW5pdF9CKSwgJmRtYV9jb2hl
cmVudF9oYW5kbGUsIEdGUF9LRVJORUwpOwotCWlmICghZG1hX2NvaGVyZW50KXsKLQkJcHJpbnRr
KEtFUk5fTk9USUNFICJhcmNtc3IlZDogZG1hX2FsbG9jX2NvaGVyZW50IGdvdCBlcnJvciBmb3Ig
aGJiIG11XG4iLCBhY2ItPmhvc3QtPmhvc3Rfbm8pOworCWRtYV9jb2hlcmVudCA9IGRtYV9hbGxv
Y19jb2hlcmVudCgmcGRldi0+ZGV2LAorCQlzaXplb2Yoc3RydWN0IE1lc3NhZ2VVbml0X0IpLCAm
ZG1hX2NvaGVyZW50X2hhbmRsZSwKKwkJR0ZQX0tFUk5FTCk7CisJaWYgKCFkbWFfY29oZXJlbnQp
IHsKKwkJcHJfbm90aWNlKCJhcmNtc3IlZDogZG1hX2FsbG9jX2NvaGVyZW50ICIKKwkJCSJnb3Qg
ZXJyb3IgZm9yIGhiYiBtdVxuIiwgYWNiLT5ob3N0LT5ob3N0X25vKTsKIAkJcmV0dXJuIGZhbHNl
OwogCX0KLQlhY2ItPmRtYV9jb2hlcmVudF9oYW5kbGVfaGJiX211ID0gZG1hX2NvaGVyZW50X2hh
bmRsZTsKLQlyZWcgPSAoc3RydWN0IE1lc3NhZ2VVbml0X0IgKilkbWFfY29oZXJlbnQ7CisJYWNi
LT5kbWFfY29oZXJlbnRfaGFuZGxlMiA9IGRtYV9jb2hlcmVudF9oYW5kbGU7CisJcmVnID0gKHN0
cnVjdCBNZXNzYWdlVW5pdF9CIF9faW9tZW0gKilkbWFfY29oZXJlbnQ7CiAJYWNiLT5wbXVCID0g
cmVnOwotCXJlZy0+ZHJ2MmlvcF9kb29yYmVsbD0gKHVpbnQzMl90IF9faW9tZW0gKikoKHVuc2ln
bmVkIGxvbmcpYWNiLT5tZW1fYmFzZTAgKyBBUkNNU1JfRFJWMklPUF9ET09SQkVMTCk7Ci0JcmVn
LT5kcnYyaW9wX2Rvb3JiZWxsX21hc2sgPSAodWludDMyX3QgX19pb21lbSAqKSgodW5zaWduZWQg
bG9uZylhY2ItPm1lbV9iYXNlMCArIEFSQ01TUl9EUlYySU9QX0RPT1JCRUxMX01BU0spOwotCXJl
Zy0+aW9wMmRydl9kb29yYmVsbCA9ICh1aW50MzJfdCBfX2lvbWVtICopKCh1bnNpZ25lZCBsb25n
KWFjYi0+bWVtX2Jhc2UwICsgQVJDTVNSX0lPUDJEUlZfRE9PUkJFTEwpOwotCXJlZy0+aW9wMmRy
dl9kb29yYmVsbF9tYXNrID0gKHVpbnQzMl90IF9faW9tZW0gKikoKHVuc2lnbmVkIGxvbmcpYWNi
LT5tZW1fYmFzZTAgKyBBUkNNU1JfSU9QMkRSVl9ET09SQkVMTF9NQVNLKTsKLQlyZWctPm1lc3Nh
Z2Vfd2J1ZmZlciA9ICh1aW50MzJfdCBfX2lvbWVtICopKCh1bnNpZ25lZCBsb25nKWFjYi0+bWVt
X2Jhc2UxICsgQVJDTVNSX01FU1NBR0VfV0JVRkZFUik7Ci0JcmVnLT5tZXNzYWdlX3JidWZmZXIg
PSAgKHVpbnQzMl90IF9faW9tZW0gKikoKHVuc2lnbmVkIGxvbmcpYWNiLT5tZW1fYmFzZTEgKyBB
UkNNU1JfTUVTU0FHRV9SQlVGRkVSKTsKLQlyZWctPm1lc3NhZ2VfcndidWZmZXIgPSAodWludDMy
X3QgX19pb21lbSAqKSgodW5zaWduZWQgbG9uZylhY2ItPm1lbV9iYXNlMSArIEFSQ01TUl9NRVNT
QUdFX1JXQlVGRkVSKTsKLQlpb3BfZmlybV9tb2RlbCA9IChjaGFyIF9faW9tZW0gKikoJnJlZy0+
bWVzc2FnZV9yd2J1ZmZlclsxNV0pOwkvKmZpcm1fbW9kZWwsMTUsNjAtNjcqLwotCWlvcF9maXJt
X3ZlcnNpb24gPSAoY2hhciBfX2lvbWVtICopKCZyZWctPm1lc3NhZ2VfcndidWZmZXJbMTddKTsJ
LypmaXJtX3ZlcnNpb24sMTcsNjgtODMqLwotCWlvcF9kZXZpY2VfbWFwID0gKGNoYXIgX19pb21l
bSAqKSgmcmVnLT5tZXNzYWdlX3J3YnVmZmVyWzIxXSk7CS8qZmlybV92ZXJzaW9uLDIxLDg0LTk5
Ki8KKwlyZWctPmRydjJpb3BfZG9vcmJlbGwgPSAodWludDMyX3QgX19pb21lbSAqKQorCQkoKHVu
c2lnbmVkIGxvbmcpYWNiLT5tZW1fYmFzZTAgKworCQlBUkNNU1JfRFJWMklPUF9ET09SQkVMTCk7
CisJcmVnLT5kcnYyaW9wX2Rvb3JiZWxsX21hc2sgPSAodWludDMyX3QgX19pb21lbSAqKQorCQko
KHVuc2lnbmVkIGxvbmcpYWNiLT5tZW1fYmFzZTAgKworCQlBUkNNU1JfRFJWMklPUF9ET09SQkVM
TF9NQVNLKTsKKwlyZWctPmlvcDJkcnZfZG9vcmJlbGwgPSAodWludDMyX3QgX19pb21lbSAqKQor
CQkoKHVuc2lnbmVkIGxvbmcpYWNiLT5tZW1fYmFzZTAgKworCQlBUkNNU1JfSU9QMkRSVl9ET09S
QkVMTCk7CisJcmVnLT5pb3AyZHJ2X2Rvb3JiZWxsX21hc2sgPSAodWludDMyX3QgX19pb21lbSAq
KQorCQkoKHVuc2lnbmVkIGxvbmcpYWNiLT5tZW1fYmFzZTAgKworCQlBUkNNU1JfSU9QMkRSVl9E
T09SQkVMTF9NQVNLKTsKKwlyZWctPm1lc3NhZ2Vfd2J1ZmZlciA9ICh1aW50MzJfdCBfX2lvbWVt
ICopCisJCSgodW5zaWduZWQgbG9uZylhY2ItPm1lbV9iYXNlMSArCisJCUFSQ01TUl9NRVNTQUdF
X1dCVUZGRVIpOworCXJlZy0+bWVzc2FnZV9yYnVmZmVyID0gKHVpbnQzMl90IF9faW9tZW0gKikK
KwkJKCh1bnNpZ25lZCBsb25nKWFjYi0+bWVtX2Jhc2UxICsKKwkJQVJDTVNSX01FU1NBR0VfUkJV
RkZFUik7CisJcmVnLT5tZXNzYWdlX3J3YnVmZmVyID0gKHVpbnQzMl90IF9faW9tZW0gKikKKwkJ
KCh1bnNpZ25lZCBsb25nKWFjYi0+bWVtX2Jhc2UxICsKKwkJQVJDTVNSX01FU1NBR0VfUldCVUZG
RVIpOworCWlvcF9maXJtX21vZGVsID0gKGNoYXIgX19pb21lbSAqKSgmcmVnLT5tZXNzYWdlX3J3
YnVmZmVyWzE1XSk7CisJaW9wX2Zpcm1fdmVyc2lvbiA9IChjaGFyIF9faW9tZW0gKikoJnJlZy0+
bWVzc2FnZV9yd2J1ZmZlclsxN10pOworCWlvcF9kZXZpY2VfbWFwID0gKGNoYXIgX19pb21lbSAq
KSgmcmVnLT5tZXNzYWdlX3J3YnVmZmVyWzIxXSk7CiAKIAl3cml0ZWwoQVJDTVNSX01FU1NBR0Vf
R0VUX0NPTkZJRywgcmVnLT5kcnYyaW9wX2Rvb3JiZWxsKTsKLQlpZiAoIWFyY21zcl9oYmJfd2Fp
dF9tc2dpbnRfcmVhZHkoYWNiKSkgewotCQlwcmludGsoS0VSTl9OT1RJQ0UgImFyY21zciVkOiB3
YWl0ICdnZXQgYWRhcHRlciBmaXJtd2FyZSBcCi0JCQltaXNjZWxsYW5lb3VzIGRhdGEnIHRpbWVv
dXQgXG4iLCBhY2ItPmhvc3QtPmhvc3Rfbm8pOworCWlmICghYXJjbXNyX2hiYUJfd2FpdF9tc2dp
bnRfcmVhZHkoYWNiKSkgeworCQlwcl9ub3RpY2UoImFyY21zciVkOiB3YWl0ICdnZXQgYWRhcHRl
ciBmaXJtd2FyZSAiCisJCQkibWlzY2VsbGFuZW91cyBkYXRhJyB0aW1lb3V0XG4iLCBhY2ItPmhv
c3QtPmhvc3Rfbm8pOwogCQlyZXR1cm4gZmFsc2U7CiAJfQogCWNvdW50ID0gODsKLQl3aGlsZSAo
Y291bnQpeworCXdoaWxlIChjb3VudCkgewogCQkqYWNiX2Zpcm1fbW9kZWwgPSByZWFkYihpb3Bf
ZmlybV9tb2RlbCk7CiAJCWFjYl9maXJtX21vZGVsKys7CiAJCWlvcF9maXJtX21vZGVsKys7CiAJ
CWNvdW50LS07CiAJfQogCWNvdW50ID0gMTY7Ci0Jd2hpbGUgKGNvdW50KXsKKwl3aGlsZSAoY291
bnQpIHsKIAkJKmFjYl9maXJtX3ZlcnNpb24gPSByZWFkYihpb3BfZmlybV92ZXJzaW9uKTsKIAkJ
YWNiX2Zpcm1fdmVyc2lvbisrOwogCQlpb3BfZmlybV92ZXJzaW9uKys7CkBAIC0yMjA0LDE3ICsz
MTQxLDE3IEBAIHN0YXRpYyBib29sIGFyY21zcl9nZXRfaGJiX2NvbmZpZyhzdHJ1Y3QKIAl9CiAK
IAljb3VudCA9IDE2OwotCXdoaWxlKGNvdW50KXsKKwl3aGlsZSAoY291bnQpIHsKIAkJKmFjYl9k
ZXZpY2VfbWFwID0gcmVhZGIoaW9wX2RldmljZV9tYXApOwogCQlhY2JfZGV2aWNlX21hcCsrOwog
CQlpb3BfZGV2aWNlX21hcCsrOwogCQljb3VudC0tOwogCX0KLQkKLQlwcmludGsoS0VSTl9OT1RJ
Q0UgIkFyZWNhIFJBSUQgQ29udHJvbGxlciVkOiBGL1cgJXMgJiBNb2RlbCAlc1xuIiwKKworCXBy
X25vdGljZSgiQXJlY2EgUkFJRCBDb250cm9sbGVyJWQ6IE1vZGVsICVzLCBGL1cgJXNcbiIsCiAJ
CWFjYi0+aG9zdC0+aG9zdF9ubywKLQkJYWNiLT5maXJtX3ZlcnNpb24sCi0JCWFjYi0+ZmlybV9t
b2RlbCk7CisJCWFjYi0+ZmlybV9tb2RlbCwKKwkJYWNiLT5maXJtX3ZlcnNpb24pOwogCiAJYWNi
LT5zaWduYXR1cmUgPSByZWFkbCgmcmVnLT5tZXNzYWdlX3J3YnVmZmVyWzFdKTsKIAkvKmZpcm1f
c2lnbmF0dXJlLDEsMDAtMDMqLwpAQCAtMjIyNiw0MSArMzE2MywxNjkgQEAgc3RhdGljIGJvb2wg
YXJjbXNyX2dldF9oYmJfY29uZmlnKHN0cnVjdAogCS8qZmlybV9zZHJhbV9zaXplLDMsMTItMTUq
LwogCWFjYi0+ZmlybV9oZF9jaGFubmVscyA9IHJlYWRsKCZyZWctPm1lc3NhZ2VfcndidWZmZXJb
NV0pOwogCS8qZmlybV9pZGVfY2hhbm5lbHMsNCwxNi0xOSovCi0JYWNiLT5maXJtX2NmZ192ZXJz
aW9uID0gcmVhZGwoJnJlZy0+bWVzc2FnZV9yd2J1ZmZlclsyNV0pOyAgLypmaXJtX2NmZ192ZXJz
aW9uLDI1LDEwMC0xMDMqLworCWFjYi0+ZmlybV9jZmdfdmVyc2lvbiA9IHJlYWRsKCZyZWctPm1l
c3NhZ2VfcndidWZmZXJbMjVdKTsKIAkvKmZpcm1faWRlX2NoYW5uZWxzLDQsMTYtMTkqLwogCXJl
dHVybiB0cnVlOwogfQogCi1zdGF0aWMgYm9vbCBhcmNtc3JfZ2V0X2hiY19jb25maWcoc3RydWN0
IEFkYXB0ZXJDb250cm9sQmxvY2sgKnBBQ0IpCi17Ci0JdWludDMyX3QgaW50bWFza19vcmcsIElu
ZGV4LCBmaXJtd2FyZV9zdGF0ZSA9IDA7Ci0Jc3RydWN0IE1lc3NhZ2VVbml0X0MgKnJlZyA9IHBB
Q0ItPnBtdUM7Ci0JY2hhciAqYWNiX2Zpcm1fbW9kZWwgPSBwQUNCLT5maXJtX21vZGVsOwotCWNo
YXIgKmFjYl9maXJtX3ZlcnNpb24gPSBwQUNCLT5maXJtX3ZlcnNpb247Ci0JY2hhciAqaW9wX2Zp
cm1fbW9kZWwgPSAoY2hhciAqKSgmcmVnLT5tc2djb2RlX3J3YnVmZmVyWzE1XSk7ICAgIC8qZmly
bV9tb2RlbCwxNSw2MC02NyovCi0JY2hhciAqaW9wX2Zpcm1fdmVyc2lvbiA9IChjaGFyICopKCZy
ZWctPm1zZ2NvZGVfcndidWZmZXJbMTddKTsgIC8qZmlybV92ZXJzaW9uLDE3LDY4LTgzKi8KLQlp
bnQgY291bnQ7Ci0JLyogZGlzYWJsZSBhbGwgb3V0Ym91bmQgaW50ZXJydXB0ICovCi0JaW50bWFz
a19vcmcgPSByZWFkbCgmcmVnLT5ob3N0X2ludF9tYXNrKTsgLyogZGlzYWJsZSBvdXRib3VuZCBt
ZXNzYWdlMCBpbnQgKi8KLQl3cml0ZWwoaW50bWFza19vcmd8QVJDTVNSX0hCQ01VX0FMTF9JTlRN
QVNLRU5BQkxFLCAmcmVnLT5ob3N0X2ludF9tYXNrKTsKLQkvKiB3YWl0IGZpcm13YXJlIHJlYWR5
ICovCi0JZG8gewotCQlmaXJtd2FyZV9zdGF0ZSA9IHJlYWRsKCZyZWctPm91dGJvdW5kX21zZ2Fk
ZHIxKTsKLQl9IHdoaWxlICgoZmlybXdhcmVfc3RhdGUgJiBBUkNNU1JfSEJDTVVfTUVTU0FHRV9G
SVJNV0FSRV9PSykgPT0gMCk7CitzdGF0aWMgYm9vbAorYXJjbXNyX2hiYUNfZ2V0X2NvbmZpZyhz
dHJ1Y3QgQWRhcHRlckNvbnRyb2xCbG9jayAqcEFDQikKK3sKKwl1aW50MzJfdCBpbnRtYXNrX29y
ZywgSW5kZXgsIGZpcm13YXJlX3N0YXRlID0gMDsKKwlzdHJ1Y3QgTWVzc2FnZVVuaXRfQyBfX2lv
bWVtICpyZWcgPSBwQUNCLT5wbXVDOworCWNoYXIgKmFjYl9maXJtX21vZGVsID0gcEFDQi0+Zmly
bV9tb2RlbDsKKwljaGFyICphY2JfZmlybV92ZXJzaW9uID0gcEFDQi0+ZmlybV92ZXJzaW9uOwor
CWNoYXIgKmlvcF9maXJtX21vZGVsID0gKGNoYXIgKikoJnJlZy0+bXNnY29kZV9yd2J1ZmZlclsx
NV0pOworCWNoYXIgKmlvcF9maXJtX3ZlcnNpb24gPSAoY2hhciAqKSgmcmVnLT5tc2djb2RlX3J3
YnVmZmVyWzE3XSk7CisJaW50IGNvdW50OworCS8qIGRpc2FibGUgYWxsIG91dGJvdW5kIGludGVy
cnVwdCAqLworCWludG1hc2tfb3JnID0gcmVhZGwoJnJlZy0+aG9zdF9pbnRfbWFzayk7CisJd3Jp
dGVsKGludG1hc2tfb3JnIHwgQVJDTVNSX0hCQ01VX0FMTF9JTlRNQVNLRU5BQkxFLAorCQkmcmVn
LT5ob3N0X2ludF9tYXNrKTsKKwlkbyB7CisJCWZpcm13YXJlX3N0YXRlID0gcmVhZGwoJnJlZy0+
b3V0Ym91bmRfbXNnYWRkcjEpOworCX0gd2hpbGUgKChmaXJtd2FyZV9zdGF0ZSAmIEFSQ01TUl9I
QkNNVV9NRVNTQUdFX0ZJUk1XQVJFX09LKSA9PSAwKTsKKwkvKiBwb3N0ICJnZXQgY29uZmlnIiBp
bnN0cnVjdGlvbiAqLworCXdyaXRlbChBUkNNU1JfSU5CT1VORF9NRVNHMF9HRVRfQ09ORklHLCAm
cmVnLT5pbmJvdW5kX21zZ2FkZHIwKTsKKwl3cml0ZWwoQVJDTVNSX0hCQ01VX0RSVjJJT1BfTUVT
U0FHRV9DTURfRE9ORSwKKwkJJnJlZy0+aW5ib3VuZF9kb29yYmVsbCk7CisJLyogd2FpdCBtZXNz
YWdlIHJlYWR5ICovCisJZm9yIChJbmRleCA9IDA7IEluZGV4IDwgMjAwMDsgSW5kZXgrKykgewor
CQlpZiAocmVhZGwoJnJlZy0+b3V0Ym91bmRfZG9vcmJlbGwpICYKKwkJCUFSQ01TUl9IQkNNVV9J
T1AyRFJWX01FU1NBR0VfQ01EX0RPTkUpIHsKKwkJCXdyaXRlbChBUkNNU1JfSEJDTVVfSU9QMkRS
Vl9NRVNTQUdFX0NNRF9ET05FX0RPT1JCRUxMX0NMRUFSLAorCQkJCSZyZWctPm91dGJvdW5kX2Rv
b3JiZWxsX2NsZWFyKTsKKwkJCWJyZWFrOworCQl9CisJCXVkZWxheSgxMCk7CisJfSAvKm1heCAx
IHNlY29uZHMqLworCWlmIChJbmRleCA+PSAyMDAwKSB7CisJCXByX25vdGljZSgiYXJjbXNyJWQ6
IHdhaXQgJ2dldCBhZGFwdGVyIGZpcm13YXJlICIKKwkJCSJtaXNjZWxsYW5lb3VzIGRhdGEnIHRp
bWVvdXRcbiIsIHBBQ0ItPmhvc3QtPmhvc3Rfbm8pOworCQlyZXR1cm4gZmFsc2U7CisJfQorCWNv
dW50ID0gODsKKwl3aGlsZSAoY291bnQpIHsKKwkJKmFjYl9maXJtX21vZGVsID0gcmVhZGIoaW9w
X2Zpcm1fbW9kZWwpOworCQlhY2JfZmlybV9tb2RlbCsrOworCQlpb3BfZmlybV9tb2RlbCsrOwor
CQljb3VudC0tOworCX0KKwljb3VudCA9IDE2OworCXdoaWxlIChjb3VudCkgeworCQkqYWNiX2Zp
cm1fdmVyc2lvbiA9IHJlYWRiKGlvcF9maXJtX3ZlcnNpb24pOworCQlhY2JfZmlybV92ZXJzaW9u
Kys7CisJCWlvcF9maXJtX3ZlcnNpb24rKzsKKwkJY291bnQtLTsKKwl9CisJcHJfbm90aWNlKCJB
cmVjYSBSQUlEIENvbnRyb2xsZXIlZDogTW9kZWwgJXMsIEYvVyAlc1xuIiwKKwkJcEFDQi0+aG9z
dC0+aG9zdF9ubywKKwkJcEFDQi0+ZmlybV9tb2RlbCwKKwkJcEFDQi0+ZmlybV92ZXJzaW9uKTsK
KwlwQUNCLT5maXJtX3JlcXVlc3RfbGVuID0gcmVhZGwoJnJlZy0+bXNnY29kZV9yd2J1ZmZlclsx
XSk7CisJcEFDQi0+ZmlybV9udW1iZXJzX3F1ZXVlID0gcmVhZGwoJnJlZy0+bXNnY29kZV9yd2J1
ZmZlclsyXSk7CisJcEFDQi0+ZmlybV9zZHJhbV9zaXplID0gcmVhZGwoJnJlZy0+bXNnY29kZV9y
d2J1ZmZlclszXSk7CisJcEFDQi0+ZmlybV9oZF9jaGFubmVscyA9IHJlYWRsKCZyZWctPm1zZ2Nv
ZGVfcndidWZmZXJbNF0pOworCXBBQ0ItPmZpcm1fY2ZnX3ZlcnNpb24gPSByZWFkbCgmcmVnLT5t
c2djb2RlX3J3YnVmZmVyWzI1XSk7CisJLyphbGwgaW50ZXJydXB0IHNlcnZpY2Ugd2lsbCBiZSBl
bmFibGUgYXQgYXJjbXNyX2lvcF9pbml0Ki8KKwlyZXR1cm4gdHJ1ZTsKK30KKworc3RhdGljIGJv
b2wKK2FyY21zcl9oYmFEX2dldF9jb25maWcoc3RydWN0IEFkYXB0ZXJDb250cm9sQmxvY2sgKmFj
YikKK3sKKwljaGFyICphY2JfZmlybV9tb2RlbCA9IGFjYi0+ZmlybV9tb2RlbDsKKwljaGFyICph
Y2JfZmlybV92ZXJzaW9uID0gYWNiLT5maXJtX3ZlcnNpb247CisJY2hhciAqYWNiX2RldmljZV9t
YXAgPSBhY2ItPmRldmljZV9tYXA7CisJY2hhciBfX2lvbWVtICppb3BfZmlybV9tb2RlbDsKKwlj
aGFyIF9faW9tZW0gKmlvcF9maXJtX3ZlcnNpb247CisJY2hhciBfX2lvbWVtICppb3BfZGV2aWNl
X21hcDsKKwl1MzIgY291bnQ7CisJc3RydWN0IE1lc3NhZ2VVbml0X0QgX19pb21lbSAqcmVnIDsK
Kwl2b2lkICpkbWFfY29oZXJlbnQ7CisJZG1hX2FkZHJfdCBkbWFfY29oZXJlbnRfaGFuZGxlOwor
CXN0cnVjdCBwY2lfZGV2ICpwZGV2ID0gYWNiLT5wZGV2OworCisJYWNiLT5yb3VuZHVwX2NjYnNp
emUgPSByb3VuZHVwKHNpemVvZihzdHJ1Y3QgTWVzc2FnZVVuaXRfRCksIDMyKTsKKwlkbWFfY29o
ZXJlbnQgPSBkbWFfYWxsb2NfY29oZXJlbnQoJnBkZXYtPmRldiwgYWNiLT5yb3VuZHVwX2NjYnNp
emUsCisJCSZkbWFfY29oZXJlbnRfaGFuZGxlLCBHRlBfS0VSTkVMKTsKKwlpZiAoIWRtYV9jb2hl
cmVudCkgeworCQlwcl9ub3RpY2UoIkRNQSBhbGxvY2F0aW9uIGZhaWxlZC4uLlxuIik7CisJCXJl
dHVybiBmYWxzZTsKKwl9CisJbWVtc2V0KGRtYV9jb2hlcmVudCwgMCwgYWNiLT5yb3VuZHVwX2Nj
YnNpemUpOworCWFjYi0+ZG1hX2NvaGVyZW50MiA9IGRtYV9jb2hlcmVudDsKKwlhY2ItPmRtYV9j
b2hlcmVudF9oYW5kbGUyID0gZG1hX2NvaGVyZW50X2hhbmRsZTsKKwlyZWcgPSAoc3RydWN0IE1l
c3NhZ2VVbml0X0QgX19pb21lbSAqKWRtYV9jb2hlcmVudDsKKwlhY2ItPnBtdUQgPSByZWc7CisJ
cmVnLT5jaGlwX2lkID0gKHUzMiBfX2lvbWVtICopKCh1bnNpZ25lZCBsb25nKQorCWFjYi0+bWVt
X2Jhc2UwICsgQVJDTVNSX0FSQzEyMTRfQ0hJUF9JRCk7CisJcmVnLT5jcHVfbWVtX2NvbmZpZyA9
ICh1MzIgX19pb21lbSAqKSgodW5zaWduZWQgbG9uZykKKwlhY2ItPm1lbV9iYXNlMCArIEFSQ01T
Ul9BUkMxMjE0X0NQVV9NRU1PUllfQ09ORklHVVJBVElPTik7CisJcmVnLT5pMm9faG9zdF9pbnRl
cnJ1cHRfbWFzayA9ICh1MzIgX19pb21lbSAqKSgodW5zaWduZWQgbG9uZykKKwlhY2ItPm1lbV9i
YXNlMCArIEFSQ01TUl9BUkMxMjE0X0kyX0hPU1RfSU5URVJSVVBUX01BU0spOworCXJlZy0+c2Ft
cGxlX2F0X3Jlc2V0ID0gKHUzMiBfX2lvbWVtICopKCh1bnNpZ25lZCBsb25nKQorCWFjYi0+bWVt
X2Jhc2UwICsgQVJDTVNSX0FSQzEyMTRfU0FNUExFX1JFU0VUKTsKKwlyZWctPnJlc2V0X3JlcXVl
c3QgPSAodTMyIF9faW9tZW0gKikoKHVuc2lnbmVkIGxvbmcpCisJYWNiLT5tZW1fYmFzZTAgKyBB
UkNNU1JfQVJDMTIxNF9SRVNFVF9SRVFVRVNUKTsKKwlyZWctPmhvc3RfaW50X3N0YXR1cyA9ICh1
MzIgX19pb21lbSAqKSgodW5zaWduZWQgbG9uZykKKwlhY2ItPm1lbV9iYXNlMCArIEFSQ01TUl9B
UkMxMjE0X01BSU5fSU5URVJSVVBUX1NUQVRVUyk7CisJcmVnLT5wY2llZjBfaW50X2VuYWJsZSA9
ICh1MzIgX19pb21lbSAqKSgodW5zaWduZWQgbG9uZykKKwlhY2ItPm1lbV9iYXNlMCArIEFSQ01T
Ul9BUkMxMjE0X1BDSUVfRjBfSU5URVJSVVBUX0VOQUJMRSk7CisJcmVnLT5pbmJvdW5kX21zZ2Fk
ZHIwID0gKHUzMiBfX2lvbWVtICopKCh1bnNpZ25lZCBsb25nKQorCWFjYi0+bWVtX2Jhc2UwICsg
QVJDTVNSX0FSQzEyMTRfSU5CT1VORF9NRVNTQUdFMCk7CisJcmVnLT5pbmJvdW5kX21zZ2FkZHIx
ID0gKHUzMiBfX2lvbWVtICopKCh1bnNpZ25lZCBsb25nKQorCWFjYi0+bWVtX2Jhc2UwICsgQVJD
TVNSX0FSQzEyMTRfSU5CT1VORF9NRVNTQUdFMSk7CisJcmVnLT5vdXRib3VuZF9tc2dhZGRyMCA9
ICh1MzIgX19pb21lbSAqKSgodW5zaWduZWQgbG9uZykKKwlhY2ItPm1lbV9iYXNlMCArIEFSQ01T
Ul9BUkMxMjE0X09VVEJPVU5EX01FU1NBR0UwKTsKKwlyZWctPm91dGJvdW5kX21zZ2FkZHIxID0g
KHUzMiBfX2lvbWVtICopKCh1bnNpZ25lZCBsb25nKQorCWFjYi0+bWVtX2Jhc2UwICsgQVJDTVNS
X0FSQzEyMTRfT1VUQk9VTkRfTUVTU0FHRTEpOworCXJlZy0+aW5ib3VuZF9kb29yYmVsbCA9ICh1
MzIgX19pb21lbSAqKSgodW5zaWduZWQgbG9uZykKKwlhY2ItPm1lbV9iYXNlMCArIEFSQ01TUl9B
UkMxMjE0X0lOQk9VTkRfRE9PUkJFTEwpOworCXJlZy0+b3V0Ym91bmRfZG9vcmJlbGwgPSAodTMy
IF9faW9tZW0gKikoKHVuc2lnbmVkIGxvbmcpCisJYWNiLT5tZW1fYmFzZTAgKyBBUkNNU1JfQVJD
MTIxNF9PVVRCT1VORF9ET09SQkVMTCk7CisJcmVnLT5vdXRib3VuZF9kb29yYmVsbF9lbmFibGUg
PSAodTMyIF9faW9tZW0gKikoKHVuc2lnbmVkIGxvbmcpCisJYWNiLT5tZW1fYmFzZTAgKyBBUkNN
U1JfQVJDMTIxNF9PVVRCT1VORF9ET09SQkVMTF9FTkFCTEUpOworCXJlZy0+aW5ib3VuZGxpc3Rf
YmFzZV9sb3cgPSAodTMyIF9faW9tZW0gKikoKHVuc2lnbmVkIGxvbmcpCisJYWNiLT5tZW1fYmFz
ZTAgKyBBUkNNU1JfQVJDMTIxNF9JTkJPVU5EX0xJU1RfQkFTRV9MT1cpOworCXJlZy0+aW5ib3Vu
ZGxpc3RfYmFzZV9oaWdoID0gKHUzMiBfX2lvbWVtICopKCh1bnNpZ25lZCBsb25nKQorCWFjYi0+
bWVtX2Jhc2UwICsgQVJDTVNSX0FSQzEyMTRfSU5CT1VORF9MSVNUX0JBU0VfSElHSCk7CisJcmVn
LT5pbmJvdW5kbGlzdF93cml0ZV9wb2ludGVyID0gKHUzMiBfX2lvbWVtICopKCh1bnNpZ25lZCBs
b25nKQorCWFjYi0+bWVtX2Jhc2UwICsgQVJDTVNSX0FSQzEyMTRfSU5CT1VORF9MSVNUX1dSSVRF
X1BPSU5URVIpOworCXJlZy0+b3V0Ym91bmRsaXN0X2Jhc2VfbG93ID0gKHUzMiBfX2lvbWVtICop
KCh1bnNpZ25lZCBsb25nKQorCWFjYi0+bWVtX2Jhc2UwICsgQVJDTVNSX0FSQzEyMTRfT1VUQk9V
TkRfTElTVF9CQVNFX0xPVyk7CisJcmVnLT5vdXRib3VuZGxpc3RfYmFzZV9oaWdoID0gKHUzMiBf
X2lvbWVtICopKCh1bnNpZ25lZCBsb25nKQorCWFjYi0+bWVtX2Jhc2UwICsgQVJDTVNSX0FSQzEy
MTRfT1VUQk9VTkRfTElTVF9CQVNFX0hJR0gpOworCXJlZy0+b3V0Ym91bmRsaXN0X2NvcHlfcG9p
bnRlciA9ICh1MzIgX19pb21lbSAqKSgodW5zaWduZWQgbG9uZykKKwlhY2ItPm1lbV9iYXNlMCAr
IEFSQ01TUl9BUkMxMjE0X09VVEJPVU5EX0xJU1RfQ09QWV9QT0lOVEVSKTsKKwlyZWctPm91dGJv
dW5kbGlzdF9yZWFkX3BvaW50ZXIgPSAodTMyIF9faW9tZW0gKikoKHVuc2lnbmVkIGxvbmcpCisJ
YWNiLT5tZW1fYmFzZTAgKyBBUkNNU1JfQVJDMTIxNF9PVVRCT1VORF9MSVNUX1JFQURfUE9JTlRF
Uik7CisJcmVnLT5vdXRib3VuZGxpc3RfaW50ZXJydXB0X2NhdXNlID0gKHUzMiBfX2lvbWVtICop
KCh1bnNpZ25lZCBsb25nKQorCWFjYi0+bWVtX2Jhc2UwICsgQVJDTVNSX0FSQzEyMTRfT1VUQk9V
TkRfSU5URVJSVVBUX0NBVVNFKTsKKwlyZWctPm91dGJvdW5kbGlzdF9pbnRlcnJ1cHRfZW5hYmxl
ID0gKHUzMiBfX2lvbWVtICopKCh1bnNpZ25lZCBsb25nKQorCWFjYi0+bWVtX2Jhc2UwICsgQVJD
TVNSX0FSQzEyMTRfT1VUQk9VTkRfSU5URVJSVVBUX0VOQUJMRSk7CisJcmVnLT5tZXNzYWdlX3di
dWZmZXIgPSAodTMyIF9faW9tZW0gKikoKHVuc2lnbmVkIGxvbmcpCisJYWNiLT5tZW1fYmFzZTAg
KyBBUkNNU1JfQVJDMTIxNF9NRVNTQUdFX1dCVUZGRVIpOworCXJlZy0+bWVzc2FnZV9yYnVmZmVy
ID0gKHUzMiBfX2lvbWVtICopKCh1bnNpZ25lZCBsb25nKQorCWFjYi0+bWVtX2Jhc2UwICsgQVJD
TVNSX0FSQzEyMTRfTUVTU0FHRV9SQlVGRkVSKTsKKwlyZWctPm1zZ2NvZGVfcndidWZmZXIgPSAo
dTMyIF9faW9tZW0gKikoKHVuc2lnbmVkIGxvbmcpCisJYWNiLT5tZW1fYmFzZTAgKyBBUkNNU1Jf
QVJDMTIxNF9NRVNTQUdFX1JXQlVGRkVSKTsKKwlpb3BfZmlybV9tb2RlbCA9IChjaGFyIF9faW9t
ZW0gKikoJnJlZy0+bXNnY29kZV9yd2J1ZmZlclsxNV0pOworCWlvcF9maXJtX3ZlcnNpb24gPSAo
Y2hhciBfX2lvbWVtICopKCZyZWctPm1zZ2NvZGVfcndidWZmZXJbMTddKTsKKwlpb3BfZGV2aWNl
X21hcCA9IChjaGFyIF9faW9tZW0gKikoJnJlZy0+bXNnY29kZV9yd2J1ZmZlclsyMV0pOworCWlm
IChyZWFkbChhY2ItPnBtdUQtPm91dGJvdW5kX2Rvb3JiZWxsKSAmCisJCUFSQ01TUl9BUkMxMjE0
X0lPUDJEUlZfTUVTU0FHRV9DTURfRE9ORSkgeworCQl3cml0ZWwoQVJDTVNSX0FSQzEyMTRfSU9Q
MkRSVl9NRVNTQUdFX0NNRF9ET05FLAorCQkJYWNiLT5wbXVELT5vdXRib3VuZF9kb29yYmVsbCk7
LypjbGVhciBpbnRlcnJ1cHQqLworCX0KIAkvKiBwb3N0ICJnZXQgY29uZmlnIiBpbnN0cnVjdGlv
biAqLwotCXdyaXRlbChBUkNNU1JfSU5CT1VORF9NRVNHMF9HRVRfQ09ORklHLCAmcmVnLT5pbmJv
dW5kX21zZ2FkZHIwKTsKLQl3cml0ZWwoQVJDTVNSX0hCQ01VX0RSVjJJT1BfTUVTU0FHRV9DTURf
RE9ORSwgJnJlZy0+aW5ib3VuZF9kb29yYmVsbCk7CisJd3JpdGVsKEFSQ01TUl9JTkJPVU5EX01F
U0cwX0dFVF9DT05GSUcsIHJlZy0+aW5ib3VuZF9tc2dhZGRyMCk7CiAJLyogd2FpdCBtZXNzYWdl
IHJlYWR5ICovCi0JZm9yIChJbmRleCA9IDA7IEluZGV4IDwgMjAwMDsgSW5kZXgrKykgewotCQlp
ZiAocmVhZGwoJnJlZy0+b3V0Ym91bmRfZG9vcmJlbGwpICYgQVJDTVNSX0hCQ01VX0lPUDJEUlZf
TUVTU0FHRV9DTURfRE9ORSkgewotCQkJd3JpdGVsKEFSQ01TUl9IQkNNVV9JT1AyRFJWX01FU1NB
R0VfQ01EX0RPTkVfRE9PUkJFTExfQ0xFQVIsICZyZWctPm91dGJvdW5kX2Rvb3JiZWxsX2NsZWFy
KTsvKmNsZWFyIGludGVycnVwdCovCi0JCQlicmVhazsKLQkJfQotCQl1ZGVsYXkoMTApOwotCX0g
LyptYXggMSBzZWNvbmRzKi8KLQlpZiAoSW5kZXggPj0gMjAwMCkgewotCQlwcmludGsoS0VSTl9O
T1RJQ0UgImFyY21zciVkOiB3YWl0ICdnZXQgYWRhcHRlciBmaXJtd2FyZSBcCi0JCQltaXNjZWxs
YW5lb3VzIGRhdGEnIHRpbWVvdXQgXG4iLCBwQUNCLT5ob3N0LT5ob3N0X25vKTsKKwlpZiAoIWFy
Y21zcl9oYmFEX3dhaXRfbXNnaW50X3JlYWR5KGFjYikpIHsKKwkJcHJfbm90aWNlKCJhcmNtc3Il
ZDogd2FpdCBnZXQgYWRhcHRlciBmaXJtd2FyZSAiCisJCQkibWlzY2VsbGFuZW91cyBkYXRhIHRp
bWVvdXRcbiIsIGFjYi0+aG9zdC0+aG9zdF9ubyk7CisJCWRtYV9mcmVlX2NvaGVyZW50KCZhY2It
PnBkZXYtPmRldiwgYWNiLT5yb3VuZHVwX2NjYnNpemUsCisJCQlhY2ItPmRtYV9jb2hlcmVudDIs
IGFjYi0+ZG1hX2NvaGVyZW50X2hhbmRsZTIpOwogCQlyZXR1cm4gZmFsc2U7CiAJfQogCWNvdW50
ID0gODsKQEAgLTIyNzcsNjIgKzMzNDIsMTAwIEBAIHN0YXRpYyBib29sIGFyY21zcl9nZXRfaGJj
X2NvbmZpZyhzdHJ1Y3QKIAkJaW9wX2Zpcm1fdmVyc2lvbisrOwogCQljb3VudC0tOwogCX0KLQlw
cmludGsoS0VSTl9OT1RJQ0UgIkFyZWNhIFJBSUQgQ29udHJvbGxlciVkOiBGL1cgJXMgJiBNb2Rl
bCAlc1xuIiwKLQkJcEFDQi0+aG9zdC0+aG9zdF9ubywKLQkJcEFDQi0+ZmlybV92ZXJzaW9uLAot
CQlwQUNCLT5maXJtX21vZGVsKTsKLQlwQUNCLT5maXJtX3JlcXVlc3RfbGVuID0gcmVhZGwoJnJl
Zy0+bXNnY29kZV9yd2J1ZmZlclsxXSk7ICAgLypmaXJtX3JlcXVlc3RfbGVuLDEsMDQtMDcqLwot
CXBBQ0ItPmZpcm1fbnVtYmVyc19xdWV1ZSA9IHJlYWRsKCZyZWctPm1zZ2NvZGVfcndidWZmZXJb
Ml0pOyAvKmZpcm1fbnVtYmVyc19xdWV1ZSwyLDA4LTExKi8KLQlwQUNCLT5maXJtX3NkcmFtX3Np
emUgPSByZWFkbCgmcmVnLT5tc2djb2RlX3J3YnVmZmVyWzNdKTsgICAgLypmaXJtX3NkcmFtX3Np
emUsMywxMi0xNSovCi0JcEFDQi0+ZmlybV9oZF9jaGFubmVscyA9IHJlYWRsKCZyZWctPm1zZ2Nv
ZGVfcndidWZmZXJbNF0pOyAgLypmaXJtX2lkZV9jaGFubmVscyw0LDE2LTE5Ki8KLQlwQUNCLT5m
aXJtX2NmZ192ZXJzaW9uID0gcmVhZGwoJnJlZy0+bXNnY29kZV9yd2J1ZmZlclsyNV0pOyAgLypm
aXJtX2NmZ192ZXJzaW9uLDI1LDEwMC0xMDMqLwotCS8qYWxsIGludGVycnVwdCBzZXJ2aWNlIHdp
bGwgYmUgZW5hYmxlIGF0IGFyY21zcl9pb3BfaW5pdCovCisJY291bnQgPSAxNjsKKwl3aGlsZSAo
Y291bnQpIHsKKwkJKmFjYl9kZXZpY2VfbWFwID0gcmVhZGIoaW9wX2RldmljZV9tYXApOworCQlh
Y2JfZGV2aWNlX21hcCsrOworCQlpb3BfZGV2aWNlX21hcCsrOworCQljb3VudC0tOworCX0KKwlh
Y2ItPnNpZ25hdHVyZSA9IHJlYWRsKCZyZWctPm1zZ2NvZGVfcndidWZmZXJbMV0pOworCS8qZmly
bV9zaWduYXR1cmUsMSwwMC0wMyovCisJYWNiLT5maXJtX3JlcXVlc3RfbGVuID0gcmVhZGwoJnJl
Zy0+bXNnY29kZV9yd2J1ZmZlclsyXSk7CisJLypmaXJtX3JlcXVlc3RfbGVuLDEsMDQtMDcqLwor
CWFjYi0+ZmlybV9udW1iZXJzX3F1ZXVlID0gcmVhZGwoJnJlZy0+bXNnY29kZV9yd2J1ZmZlclsz
XSk7CisJLypmaXJtX251bWJlcnNfcXVldWUsMiwwOC0xMSovCisJYWNiLT5maXJtX3NkcmFtX3Np
emUgPSByZWFkbCgmcmVnLT5tc2djb2RlX3J3YnVmZmVyWzRdKTsKKwkvKmZpcm1fc2RyYW1fc2l6
ZSwzLDEyLTE1Ki8KKwlhY2ItPmZpcm1faGRfY2hhbm5lbHMgPSByZWFkbCgmcmVnLT5tc2djb2Rl
X3J3YnVmZmVyWzVdKTsKKwkvKmZpcm1faGRfY2hhbm5lbHMsNCwxNi0xOSovCisJYWNiLT5maXJt
X2NmZ192ZXJzaW9uID0gcmVhZGwoJnJlZy0+bXNnY29kZV9yd2J1ZmZlclsyNV0pOworCXByX25v
dGljZSgiQXJlY2EgUkFJRCBDb250cm9sbGVyJWQ6IE1vZGVsICVzLCBGL1cgJXNcbiIsCisJCWFj
Yi0+aG9zdC0+aG9zdF9ubywKKwkJYWNiLT5maXJtX21vZGVsLAorCQlhY2ItPmZpcm1fdmVyc2lv
bik7CiAJcmV0dXJuIHRydWU7CiB9Ci1zdGF0aWMgYm9vbCBhcmNtc3JfZ2V0X2Zpcm13YXJlX3Nw
ZWMoc3RydWN0IEFkYXB0ZXJDb250cm9sQmxvY2sgKmFjYikKKworc3RhdGljIGJvb2wKK2FyY21z
cl9nZXRfZmlybXdhcmVfc3BlYyhzdHJ1Y3QgQWRhcHRlckNvbnRyb2xCbG9jayAqYWNiKQogewot
CWlmIChhY2ItPmFkYXB0ZXJfdHlwZSA9PSBBQ0JfQURBUFRFUl9UWVBFX0EpCi0JCXJldHVybiBh
cmNtc3JfZ2V0X2hiYV9jb25maWcoYWNiKTsKLQllbHNlIGlmIChhY2ItPmFkYXB0ZXJfdHlwZSA9
PSBBQ0JfQURBUFRFUl9UWVBFX0IpCi0JCXJldHVybiBhcmNtc3JfZ2V0X2hiYl9jb25maWcoYWNi
KTsKKwlib29sIHJ0biA9IGZhbHNlOworCXN3aXRjaCAoYWNiLT5hZGFwdGVyX3R5cGUpIHsKKwlj
YXNlIEFDQl9BREFQVEVSX1RZUEVfQToKKwkJcnRuID0gYXJjbXNyX2hiYUFfZ2V0X2NvbmZpZyhh
Y2IpOworCQlicmVhazsKKwljYXNlIEFDQl9BREFQVEVSX1RZUEVfQjoKKwkJcnRuID0gYXJjbXNy
X2hiYUJfZ2V0X2NvbmZpZyhhY2IpOworCQlicmVhazsKKwljYXNlIEFDQl9BREFQVEVSX1RZUEVf
QzoKKwkJcnRuID0gYXJjbXNyX2hiYUNfZ2V0X2NvbmZpZyhhY2IpOworCQlicmVhazsKKwljYXNl
IEFDQl9BREFQVEVSX1RZUEVfRDoKKwkJcnRuID0gYXJjbXNyX2hiYURfZ2V0X2NvbmZpZyhhY2Ip
OworCQlicmVhazsKKwlkZWZhdWx0OgorCQlicmVhazsKKwl9CisJaWYoYWNiLT5maXJtX251bWJl
cnNfcXVldWUgPiBBUkNNU1JfTUFYX0ZSRUVDQ0JfTlVNKQorCQlhY2ItPm1heE91dHN0YW5kaW5n
ID0gQVJDTVNSX01BWF9GUkVFQ0NCX05VTS0xOwogCWVsc2UKLQkJcmV0dXJuIGFyY21zcl9nZXRf
aGJjX2NvbmZpZyhhY2IpOworCQlhY2ItPm1heE91dHN0YW5kaW5nID0gYWNiLT5maXJtX251bWJl
cnNfcXVldWUgLSAxOworCXJldHVybiBydG47CiB9CiAKLXN0YXRpYyBpbnQgYXJjbXNyX3BvbGxp
bmdfaGJhX2NjYmRvbmUoc3RydWN0IEFkYXB0ZXJDb250cm9sQmxvY2sgKmFjYiwKK3N0YXRpYyBp
bnQKK2FyY21zcl9oYmFBX3BvbGxpbmdfY2NiZG9uZShzdHJ1Y3QgQWRhcHRlckNvbnRyb2xCbG9j
ayAqYWNiLAogCXN0cnVjdCBDb21tYW5kQ29udHJvbEJsb2NrICpwb2xsX2NjYikKIHsKIAlzdHJ1
Y3QgTWVzc2FnZVVuaXRfQSBfX2lvbWVtICpyZWcgPSBhY2ItPnBtdUE7CiAJc3RydWN0IENvbW1h
bmRDb250cm9sQmxvY2sgKmNjYjsKIAlzdHJ1Y3QgQVJDTVNSX0NEQiAqYXJjbXNyX2NkYjsKLQl1
aW50MzJfdCBmbGFnX2NjYiwgb3V0Ym91bmRfaW50c3RhdHVzLCBwb2xsX2NjYl9kb25lID0gMCwg
cG9sbF9jb3VudCA9IDA7CisJdWludDMyX3QgZmxhZ19jY2IsIG91dGJvdW5kX2ludHN0YXR1cywg
cG9sbF9jY2JfZG9uZSA9IDA7CisJdWludDMyX3QgcG9sbF9jb3VudCA9IDA7CiAJaW50IHJ0bjsK
IAlib29sIGVycm9yOwogCXBvbGxpbmdfaGJhX2NjYl9yZXRyeToKIAlwb2xsX2NvdW50Kys7Ci0J
b3V0Ym91bmRfaW50c3RhdHVzID0gcmVhZGwoJnJlZy0+b3V0Ym91bmRfaW50c3RhdHVzKSAmIGFj
Yi0+b3V0Ym91bmRfaW50X2VuYWJsZTsKLQl3cml0ZWwob3V0Ym91bmRfaW50c3RhdHVzLCAmcmVn
LT5vdXRib3VuZF9pbnRzdGF0dXMpOy8qY2xlYXIgaW50ZXJydXB0Ki8KKwlvdXRib3VuZF9pbnRz
dGF0dXMgPSByZWFkbCgmcmVnLT5vdXRib3VuZF9pbnRzdGF0dXMpICYKKwkJYWNiLT5vdXRib3Vu
ZF9pbnRfZW5hYmxlOworCXdyaXRlbChvdXRib3VuZF9pbnRzdGF0dXMsICZyZWctPm91dGJvdW5k
X2ludHN0YXR1cyk7CiAJd2hpbGUgKDEpIHsKLQkJaWYgKChmbGFnX2NjYiA9IHJlYWRsKCZyZWct
Pm91dGJvdW5kX3F1ZXVlcG9ydCkpID09IDB4RkZGRkZGRkYpIHsKLQkJCWlmIChwb2xsX2NjYl9k
b25lKXsKKwkJZmxhZ19jY2IgPSByZWFkbCgmcmVnLT5vdXRib3VuZF9xdWV1ZXBvcnQpOworCQlp
ZiAoZmxhZ19jY2IgPT0gMHhGRkZGRkZGRikgeworCQkJaWYgKHBvbGxfY2NiX2RvbmUpIHsKIAkJ
CQlydG4gPSBTVUNDRVNTOwogCQkJCWJyZWFrOwotCQkJfWVsc2UgeworCQkJfSBlbHNlIHsKIAkJ
CQltc2xlZXAoMjUpOwotCQkJCWlmIChwb2xsX2NvdW50ID4gMTAwKXsKKwkJCQlpZiAocG9sbF9j
b3VudCA+IDEwMCkgewogCQkJCQlydG4gPSBGQUlMRUQ7CiAJCQkJCWJyZWFrOwogCQkJCX0KIAkJ
CQlnb3RvIHBvbGxpbmdfaGJhX2NjYl9yZXRyeTsKIAkJCX0KIAkJfQotCQlhcmNtc3JfY2RiID0g
KHN0cnVjdCBBUkNNU1JfQ0RCICopKGFjYi0+dmlyMnBoeV9vZmZzZXQgKyAoZmxhZ19jY2IgPDwg
NSkpOwotCQljY2IgPSBjb250YWluZXJfb2YoYXJjbXNyX2NkYiwgc3RydWN0IENvbW1hbmRDb250
cm9sQmxvY2ssIGFyY21zcl9jZGIpOworCQlhcmNtc3JfY2RiID0gKHN0cnVjdCBBUkNNU1JfQ0RC
ICopKGFjYi0+dmlyMnBoeV9vZmZzZXQgKworCQkJKGZsYWdfY2NiIDw8IDUpKTsKKwkJY2NiID0g
Y29udGFpbmVyX29mKGFyY21zcl9jZGIsIHN0cnVjdCBDb21tYW5kQ29udHJvbEJsb2NrLAorCQkJ
YXJjbXNyX2NkYik7CiAJCXBvbGxfY2NiX2RvbmUgPSAoY2NiID09IHBvbGxfY2NiKSA/IDE6MDsK
IAkJaWYgKChjY2ItPmFjYiAhPSBhY2IpIHx8IChjY2ItPnN0YXJ0ZG9uZSAhPSBBUkNNU1JfQ0NC
X1NUQVJUKSkgewotCQkJaWYgKChjY2ItPnN0YXJ0ZG9uZSA9PSBBUkNNU1JfQ0NCX0FCT1JURUQp
IHx8IChjY2IgPT0gcG9sbF9jY2IpKSB7Ci0JCQkJcHJpbnRrKEtFUk5fTk9USUNFICJhcmNtc3Il
ZDogc2NzaSBpZCA9ICVkIGx1biA9ICVkIGNjYiA9ICcweCVwJyIKLQkJCQkJIiBwb2xsIGNvbW1h
bmQgYWJvcnQgc3VjY2Vzc2Z1bGx5IFxuIgorCQkJaWYgKChjY2ItPnN0YXJ0ZG9uZSA9PSBBUkNN
U1JfQ0NCX0FCT1JURUQpIHx8CisJCQkoY2NiID09IHBvbGxfY2NiKSkgeworCQkJCXByX25vdGlj
ZSgiYXJjbXNyJWQ6IHNjc2kgaWQgPSAlZCAiCisJCQkJCSJsdW4gPSAlZCBjY2IgPSAnMHglcCcg
cG9sbCBjb21tYW5kICIKKwkJCQkJImFib3J0IHN1Y2Nlc3NmdWxseVxuIgogCQkJCQksIGFjYi0+
aG9zdC0+aG9zdF9ubwogCQkJCQksIGNjYi0+cGNtZC0+ZGV2aWNlLT5pZAogCQkJCQksIGNjYi0+
cGNtZC0+ZGV2aWNlLT5sdW4KQEAgLTIzNDEsMjQgKzM0NDQsMjYgQEAgc3RhdGljIGludCBhcmNt
c3JfcG9sbGluZ19oYmFfY2NiZG9uZShzdAogCQkJCWFyY21zcl9jY2JfY29tcGxldGUoY2NiKTsK
IAkJCQljb250aW51ZTsKIAkJCX0KLQkJCXByaW50ayhLRVJOX05PVElDRSAiYXJjbXNyJWQ6IHBv
bGxpbmcgZ2V0IGFuIGlsbGVnYWwgY2NiIgotCQkJCSIgY29tbWFuZCBkb25lIGNjYiA9ICcweCVw
JyIKLQkJCQkiY2Nib3V0c3RhbmRpbmdjb3VudCA9ICVkIFxuIgorCQkJcHJfbm90aWNlKCJhcmNt
c3IlZDogcG9sbGluZyBnZXQgYW4gaWxsZWdhbCAiCisJCQkJImNjYiBjb21tYW5kIGRvbmUgY2Ni
ID0gJzB4JXAnICIKKwkJCQkiY2Nib3V0c3RhbmRpbmdjb3VudCA9ICVkXG4iCiAJCQkJLCBhY2It
Pmhvc3QtPmhvc3Rfbm8KIAkJCQksIGNjYgogCQkJCSwgYXRvbWljX3JlYWQoJmFjYi0+Y2Nib3V0
c3RhbmRpbmdjb3VudCkpOwogCQkJY29udGludWU7CiAJCX0KLQkJZXJyb3IgPSAoZmxhZ19jY2Ig
JiBBUkNNU1JfQ0NCUkVQTFlfRkxBR19FUlJPUl9NT0RFMCkgPyB0cnVlIDogZmFsc2U7CisJCWVy
cm9yID0gKGZsYWdfY2NiICYgQVJDTVNSX0NDQlJFUExZX0ZMQUdfRVJST1JfTU9ERTApID8KKwkJ
CXRydWUgOiBmYWxzZTsKIAkJYXJjbXNyX3JlcG9ydF9jY2Jfc3RhdGUoYWNiLCBjY2IsIGVycm9y
KTsKIAl9CiAJcmV0dXJuIHJ0bjsKIH0KIAotc3RhdGljIGludCBhcmNtc3JfcG9sbGluZ19oYmJf
Y2NiZG9uZShzdHJ1Y3QgQWRhcHRlckNvbnRyb2xCbG9jayAqYWNiLAotCQkJCQlzdHJ1Y3QgQ29t
bWFuZENvbnRyb2xCbG9jayAqcG9sbF9jY2IpCitpbnQKK2FyY21zcl9oYmFCX3BvbGxpbmdfY2Ni
ZG9uZShzdHJ1Y3QgQWRhcHRlckNvbnRyb2xCbG9jayAqYWNiLAorCQkJCXN0cnVjdCBDb21tYW5k
Q29udHJvbEJsb2NrICpwb2xsX2NjYikKIHsKLQlzdHJ1Y3QgTWVzc2FnZVVuaXRfQiAqcmVnID0g
YWNiLT5wbXVCOworCXN0cnVjdCBNZXNzYWdlVW5pdF9CIF9faW9tZW0gKnJlZyA9IGFjYi0+cG11
QjsKIAlzdHJ1Y3QgQVJDTVNSX0NEQiAqYXJjbXNyX2NkYjsKIAlzdHJ1Y3QgQ29tbWFuZENvbnRy
b2xCbG9jayAqY2NiOwogCXVpbnQzMl90IGZsYWdfY2NiLCBwb2xsX2NjYl9kb25lID0gMCwgcG9s
bF9jb3VudCA9IDA7CkBAIC0yMzY4LDE2ICszNDczLDE4IEBAIHN0YXRpYyBpbnQgYXJjbXNyX3Bv
bGxpbmdfaGJiX2NjYmRvbmUoc3QKIAogCXBvbGxfY291bnQrKzsKIAkvKiBjbGVhciBkb29yYmVs
bCBpbnRlcnJ1cHQgKi8KLQl3cml0ZWwoQVJDTVNSX0RPT1JCRUxMX0lOVF9DTEVBUl9QQVRURVJO
LCByZWctPmlvcDJkcnZfZG9vcmJlbGwpOwotCXdoaWxlKDEpeworCXdyaXRlbChBUkNNU1JfRE9P
UkJFTExfSU5UX0NMRUFSX1BBVFRFUk4sCisJcmVnLT5pb3AyZHJ2X2Rvb3JiZWxsKTsKKwl3aGls
ZSAoMSkgewogCQlpbmRleCA9IHJlZy0+ZG9uZXFfaW5kZXg7Ci0JCWlmICgoZmxhZ19jY2IgPSBy
ZWFkbCgmcmVnLT5kb25lX3FidWZmZXJbaW5kZXhdKSkgPT0gMCkgewotCQkJaWYgKHBvbGxfY2Ni
X2RvbmUpeworCQlmbGFnX2NjYiA9IHJlYWRsKCZyZWctPmRvbmVfcWJ1ZmZlcltpbmRleF0pOwor
CQlpZiAoZmxhZ19jY2IgPT0gMCkgeworCQkJaWYgKHBvbGxfY2NiX2RvbmUpIHsKIAkJCQlydG4g
PSBTVUNDRVNTOwogCQkJCWJyZWFrOwotCQkJfWVsc2UgeworCQkJfSBlbHNlIHsKIAkJCQltc2xl
ZXAoMjUpOwotCQkJCWlmIChwb2xsX2NvdW50ID4gMTAwKXsKKwkJCQlpZiAocG9sbF9jb3VudCA+
IDEwMCkgewogCQkJCQlydG4gPSBGQUlMRUQ7CiAJCQkJCWJyZWFrOwogCQkJCX0KQEAgLTIzOTAs
MzggKzM0OTcsNDcgQEAgc3RhdGljIGludCBhcmNtc3JfcG9sbGluZ19oYmJfY2NiZG9uZShzdAog
CQlpbmRleCAlPSBBUkNNU1JfTUFYX0hCQl9QT1NUUVVFVUU7CiAJCXJlZy0+ZG9uZXFfaW5kZXgg
PSBpbmRleDsKIAkJLyogY2hlY2sgaWYgY29tbWFuZCBkb25lIHdpdGggbm8gZXJyb3IqLwotCQlh
cmNtc3JfY2RiID0gKHN0cnVjdCBBUkNNU1JfQ0RCICopKGFjYi0+dmlyMnBoeV9vZmZzZXQgKyAo
ZmxhZ19jY2IgPDwgNSkpOwotCQljY2IgPSBjb250YWluZXJfb2YoYXJjbXNyX2NkYiwgc3RydWN0
IENvbW1hbmRDb250cm9sQmxvY2ssIGFyY21zcl9jZGIpOwotCQlwb2xsX2NjYl9kb25lID0gKGNj
YiA9PSBwb2xsX2NjYikgPyAxOjA7Ci0JCWlmICgoY2NiLT5hY2IgIT0gYWNiKSB8fCAoY2NiLT5z
dGFydGRvbmUgIT0gQVJDTVNSX0NDQl9TVEFSVCkpIHsKLQkJCWlmICgoY2NiLT5zdGFydGRvbmUg
PT0gQVJDTVNSX0NDQl9BQk9SVEVEKSB8fCAoY2NiID09IHBvbGxfY2NiKSkgewotCQkJCXByaW50
ayhLRVJOX05PVElDRSAiYXJjbXNyJWQ6IHNjc2kgaWQgPSAlZCBsdW4gPSAlZCBjY2IgPSAnMHgl
cCciCi0JCQkJCSIgcG9sbCBjb21tYW5kIGFib3J0IHN1Y2Nlc3NmdWxseSBcbiIKLQkJCQkJLGFj
Yi0+aG9zdC0+aG9zdF9ubwotCQkJCQksY2NiLT5wY21kLT5kZXZpY2UtPmlkCi0JCQkJCSxjY2It
PnBjbWQtPmRldmljZS0+bHVuCi0JCQkJCSxjY2IpOworCQlhcmNtc3JfY2RiID0gKHN0cnVjdCBB
UkNNU1JfQ0RCICopCisJCQkoYWNiLT52aXIycGh5X29mZnNldCArIChmbGFnX2NjYiA8PCA1KSk7
CisJCWNjYiA9IGNvbnRhaW5lcl9vZihhcmNtc3JfY2RiLAorCQkJc3RydWN0IENvbW1hbmRDb250
cm9sQmxvY2ssCisJCQlhcmNtc3JfY2RiKTsKKwkJcG9sbF9jY2JfZG9uZSA9IChjY2IgPT0gcG9s
bF9jY2IpID8gMSA6IDA7CisJCWlmICgoY2NiLT5hY2IgIT0gYWNiKSB8fAorCQkJKGNjYi0+c3Rh
cnRkb25lICE9IEFSQ01TUl9DQ0JfU1RBUlQpKSB7CisJCQlpZiAoKGNjYi0+c3RhcnRkb25lID09
IEFSQ01TUl9DQ0JfQUJPUlRFRCkgfHwKKwkJCQkoY2NiID09IHBvbGxfY2NiKSkgeworCQkJCXBy
X25vdGljZSgiYXJjbXNyJWQ6ICIKKwkJCQkJInNjc2kgaWQgPSAlZCBsdW4gPSAlZCBjY2IgPSAn
MHglcCcgcG9sbCAiCisJCQkJCSJjb21tYW5kIGFib3J0IHN1Y2Nlc3NmdWxseVxuIgorCQkJCQks
IGFjYi0+aG9zdC0+aG9zdF9ubworCQkJCQksIGNjYi0+cGNtZC0+ZGV2aWNlLT5pZAorCQkJCQks
IGNjYi0+cGNtZC0+ZGV2aWNlLT5sdW4KKwkJCQkJLCBjY2IpOwogCQkJCWNjYi0+cGNtZC0+cmVz
dWx0ID0gRElEX0FCT1JUIDw8IDE2OwogCQkJCWFyY21zcl9jY2JfY29tcGxldGUoY2NiKTsKIAkJ
CQljb250aW51ZTsKIAkJCX0KLQkJCXByaW50ayhLRVJOX05PVElDRSAiYXJjbXNyJWQ6IHBvbGxp
bmcgZ2V0IGFuIGlsbGVnYWwgY2NiIgotCQkJCSIgY29tbWFuZCBkb25lIGNjYiA9ICcweCVwJyIK
LQkJCQkiY2Nib3V0c3RhbmRpbmdjb3VudCA9ICVkIFxuIgorCQkJcHJfbm90aWNlKCJhcmNtc3Il
ZDogcG9sbGluZyBnZXQgYW4gIgorCQkJCSJpbGxlZ2FsIGNjYiBjb21tYW5kIGRvbmUgY2NiID0g
JzB4JXAnICIKKwkJCQkiY2Nib3V0c3RhbmRpbmdjb3VudCA9ICVkXG4iCiAJCQkJLCBhY2ItPmhv
c3QtPmhvc3Rfbm8KIAkJCQksIGNjYgogCQkJCSwgYXRvbWljX3JlYWQoJmFjYi0+Y2Nib3V0c3Rh
bmRpbmdjb3VudCkpOwogCQkJY29udGludWU7CiAJCX0gCi0JCWVycm9yID0gKGZsYWdfY2NiICYg
QVJDTVNSX0NDQlJFUExZX0ZMQUdfRVJST1JfTU9ERTApID8gdHJ1ZSA6IGZhbHNlOworCQllcnJv
ciA9IChmbGFnX2NjYiAmIEFSQ01TUl9DQ0JSRVBMWV9GTEFHX0VSUk9SX01PREUwKQorCQkJPyB0
cnVlIDogZmFsc2U7CiAJCWFyY21zcl9yZXBvcnRfY2NiX3N0YXRlKGFjYiwgY2NiLCBlcnJvcik7
CiAJfQogCXJldHVybiBydG47CiB9CiAKLXN0YXRpYyBpbnQgYXJjbXNyX3BvbGxpbmdfaGJjX2Nj
YmRvbmUoc3RydWN0IEFkYXB0ZXJDb250cm9sQmxvY2sgKmFjYiwgc3RydWN0IENvbW1hbmRDb250
cm9sQmxvY2sgKnBvbGxfY2NiKQorc3RhdGljIGludAorYXJjbXNyX2hiYUNfcG9sbGluZ19jY2Jk
b25lKHN0cnVjdCBBZGFwdGVyQ29udHJvbEJsb2NrICphY2IsCisJc3RydWN0IENvbW1hbmRDb250
cm9sQmxvY2sgKnBvbGxfY2NiKQogewotCXN0cnVjdCBNZXNzYWdlVW5pdF9DICpyZWcgPSAoc3Ry
dWN0IE1lc3NhZ2VVbml0X0MgKilhY2ItPnBtdUM7CisJc3RydWN0IE1lc3NhZ2VVbml0X0MgX19p
b21lbSAqcmVnID0gYWNiLT5wbXVDOwogCXVpbnQzMl90IGZsYWdfY2NiLCBjY2JfY2RiX3BoeTsK
IAlzdHJ1Y3QgQVJDTVNSX0NEQiAqYXJjbXNyX2NkYjsKIAlib29sIGVycm9yOwpAQCAtMjQzMSw3
ICszNTQ3LDggQEAgc3RhdGljIGludCBhcmNtc3JfcG9sbGluZ19oYmNfY2NiZG9uZShzdAogcG9s
bGluZ19oYmNfY2NiX3JldHJ5OgogCXBvbGxfY291bnQrKzsKIAl3aGlsZSAoMSkgewotCQlpZiAo
KHJlYWRsKCZyZWctPmhvc3RfaW50X3N0YXR1cykgJiBBUkNNU1JfSEJDTVVfT1VUQk9VTkRfUE9T
VFFVRVVFX0lTUikgPT0gMCkgeworCQlpZiAoKHJlYWRsKCZyZWctPmhvc3RfaW50X3N0YXR1cykg
JgorCQkJQVJDTVNSX0hCQ01VX09VVEJPVU5EX1BPU1RRVUVVRV9JU1IpID09IDApIHsKIAkJCWlm
IChwb2xsX2NjYl9kb25lKSB7CiAJCQkJcnRuID0gU1VDQ0VTUzsKIAkJCQlicmVhazsKQEAgLTI0
NDYsNzQgKzM1NjMsMTgwIEBAIHBvbGxpbmdfaGJjX2NjYl9yZXRyeToKIAkJfQogCQlmbGFnX2Nj
YiA9IHJlYWRsKCZyZWctPm91dGJvdW5kX3F1ZXVlcG9ydF9sb3cpOwogCQljY2JfY2RiX3BoeSA9
IChmbGFnX2NjYiAmIDB4RkZGRkZGRjApOwotCQlhcmNtc3JfY2RiID0gKHN0cnVjdCBBUkNNU1Jf
Q0RCICopKGFjYi0+dmlyMnBoeV9vZmZzZXQgKyBjY2JfY2RiX3BoeSk7LypmcmFtZSBtdXN0IGJl
IDMyIGJ5dGVzIGFsaWduZWQqLwotCQlwQ0NCID0gY29udGFpbmVyX29mKGFyY21zcl9jZGIsIHN0
cnVjdCBDb21tYW5kQ29udHJvbEJsb2NrLCBhcmNtc3JfY2RiKTsKKwkJYXJjbXNyX2NkYiA9IChz
dHJ1Y3QgQVJDTVNSX0NEQiAqKShhY2ItPnZpcjJwaHlfb2Zmc2V0CisJCQkrIGNjYl9jZGJfcGh5
KTsKKwkJcENDQiA9IGNvbnRhaW5lcl9vZihhcmNtc3JfY2RiLCBzdHJ1Y3QgQ29tbWFuZENvbnRy
b2xCbG9jaywKKwkJCWFyY21zcl9jZGIpOwogCQlwb2xsX2NjYl9kb25lID0gKHBDQ0IgPT0gcG9s
bF9jY2IpID8gMSA6IDA7CiAJCS8qIGNoZWNrIGlmY29tbWFuZCBkb25lIHdpdGggbm8gZXJyb3Iq
LwotCQlpZiAoKHBDQ0ItPmFjYiAhPSBhY2IpIHx8IChwQ0NCLT5zdGFydGRvbmUgIT0gQVJDTVNS
X0NDQl9TVEFSVCkpIHsKKwkJaWYgKChwQ0NCLT5hY2IgIT0gYWNiKSB8fAorCQkJKHBDQ0ItPnN0
YXJ0ZG9uZSAhPSBBUkNNU1JfQ0NCX1NUQVJUKSkgewogCQkJaWYgKHBDQ0ItPnN0YXJ0ZG9uZSA9
PSBBUkNNU1JfQ0NCX0FCT1JURUQpIHsKLQkJCQlwcmludGsoS0VSTl9OT1RJQ0UgImFyY21zciVk
OiBzY3NpIGlkID0gJWQgbHVuID0gJWQgY2NiID0gJzB4JXAnIgotCQkJCQkiIHBvbGwgY29tbWFu
ZCBhYm9ydCBzdWNjZXNzZnVsbHkgXG4iCisJCQkJcHJfbm90aWNlKCJhcmNtc3IlZDogIgorCQkJ
CQkic2NzaSBpZCA9ICVkIGx1biA9ICVkIGNjYiA9ICcweCVwJyBwb2xsICIKKwkJCQkJImNvbW1h
bmQgYWJvcnQgc3VjY2Vzc2Z1bGx5XG4iCiAJCQkJCSwgYWNiLT5ob3N0LT5ob3N0X25vCiAJCQkJ
CSwgcENDQi0+cGNtZC0+ZGV2aWNlLT5pZAogCQkJCQksIHBDQ0ItPnBjbWQtPmRldmljZS0+bHVu
CiAJCQkJCSwgcENDQik7Ci0JCQkJCXBDQ0ItPnBjbWQtPnJlc3VsdCA9IERJRF9BQk9SVCA8PCAx
NjsKLQkJCQkJYXJjbXNyX2NjYl9jb21wbGV0ZShwQ0NCKTsKKwkJCQlwQ0NCLT5wY21kLT5yZXN1
bHQgPSBESURfQUJPUlQgPDwgMTY7CisJCQkJYXJjbXNyX2NjYl9jb21wbGV0ZShwQ0NCKTsKIAkJ
CQljb250aW51ZTsKIAkJCX0KLQkJCXByaW50ayhLRVJOX05PVElDRSAiYXJjbXNyJWQ6IHBvbGxp
bmcgZ2V0IGFuIGlsbGVnYWwgY2NiIgotCQkJCSIgY29tbWFuZCBkb25lIGNjYiA9ICcweCVwJyIK
LQkJCQkiY2Nib3V0c3RhbmRpbmdjb3VudCA9ICVkIFxuIgorCQkJcHJfbm90aWNlKCJhcmNtc3Il
ZDogcG9sbGluZyBnZXQgYW4gaWxsZWdhbCAiCisJCQkJImNjYiBjb21tYW5kIGRvbmUgY2NiID0g
JzB4JXAnICIKKwkJCQkiY2Nib3V0c3RhbmRpbmdjb3VudCA9ICVkXG4iCiAJCQkJLCBhY2ItPmhv
c3QtPmhvc3Rfbm8KIAkJCQksIHBDQ0IKIAkJCQksIGF0b21pY19yZWFkKCZhY2ItPmNjYm91dHN0
YW5kaW5nY291bnQpKTsKIAkJCWNvbnRpbnVlOwogCQl9Ci0JCWVycm9yID0gKGZsYWdfY2NiICYg
QVJDTVNSX0NDQlJFUExZX0ZMQUdfRVJST1JfTU9ERTEpID8gdHJ1ZSA6IGZhbHNlOworCQllcnJv
ciA9IChmbGFnX2NjYiAmIEFSQ01TUl9DQ0JSRVBMWV9GTEFHX0VSUk9SX01PREUxKQorCQkJPyB0
cnVlIDogZmFsc2U7CiAJCWFyY21zcl9yZXBvcnRfY2NiX3N0YXRlKGFjYiwgcENDQiwgZXJyb3Ip
OwogCX0KIAlyZXR1cm4gcnRuOwogfQotc3RhdGljIGludCBhcmNtc3JfcG9sbGluZ19jY2Jkb25l
KHN0cnVjdCBBZGFwdGVyQ29udHJvbEJsb2NrICphY2IsCi0JCQkJCXN0cnVjdCBDb21tYW5kQ29u
dHJvbEJsb2NrICpwb2xsX2NjYikKKworc3RhdGljIGludAorYXJjbXNyX2hiYURfcG9sbGluZ19j
Y2Jkb25lKHN0cnVjdCBBZGFwdGVyQ29udHJvbEJsb2NrICphY2IsCisJCQkJc3RydWN0IENvbW1h
bmRDb250cm9sQmxvY2sgKnBvbGxfY2NiKQogewotCWludCBydG4gPSAwOwotCXN3aXRjaCAoYWNi
LT5hZGFwdGVyX3R5cGUpIHsKKwlib29sIGVycm9yOworCXVpbnQzMl90IHBvbGxfY2NiX2RvbmUg
PSAwLCBwb2xsX2NvdW50ID0gMCwgZmxhZ19jY2IsIGNjYl9jZGJfcGh5OworCWludCBydG4sIGRv
bmVxX2luZGV4LCBpbmRleF9zdHJpcHBlZCwgb3V0Ym91bmRfd3JpdGVfcG9pbnRlcjsKKwl1bnNp
Z25lZCBsb25nIGZsYWdzOworCXN0cnVjdCBBUkNNU1JfQ0RCICphcmNtc3JfY2RiOworCXN0cnVj
dCBDb21tYW5kQ29udHJvbEJsb2NrICpwQ0NCOworCXN0cnVjdCBNZXNzYWdlVW5pdF9EIF9faW9t
ZW0gKnBtdSA9IGFjYi0+cG11RDsKIAotCWNhc2UgQUNCX0FEQVBURVJfVFlQRV9BOiB7Ci0JCXJ0
biA9IGFyY21zcl9wb2xsaW5nX2hiYV9jY2Jkb25lKGFjYiwgcG9sbF9jY2IpOworCXNwaW5fbG9j
a19pcnFzYXZlKCZhY2ItPmRvbmVxX2xvY2ssIGZsYWdzKTsKKwlwb2xsaW5nX2hiYURfY2NiX3Jl
dHJ5OgorCXBvbGxfY291bnQrKzsKKwl3aGlsZSAoMSkgeworCQlvdXRib3VuZF93cml0ZV9wb2lu
dGVyID0KKwkJcG11LT5kb25lX3FidWZmZXJbMF0uYWRkcmVzc0xvdyArIDE7CisJCWRvbmVxX2lu
ZGV4ID0gcG11LT5kb25lcV9pbmRleDsKKwkJaWYgKChvdXRib3VuZF93cml0ZV9wb2ludGVyICYg
MHhGRkYpID09IChkb25lcV9pbmRleCAmIDB4RkZGKSkgeworCQkJaWYgKHBvbGxfY2NiX2RvbmUp
IHsKKwkJCQlydG4gPSBTVUNDRVNTOworCQkJCWJyZWFrOworCQkJfSBlbHNlIHsKKwkJCQltc2xl
ZXAoMjUpOworCQkJCWlmIChwb2xsX2NvdW50ID4gMTAwKSB7CisJCQkJCXJ0biA9IEZBSUxFRDsK
KwkJCQkJYnJlYWs7CisJCQkJfQorCQkJCWdvdG8gcG9sbGluZ19oYmFEX2NjYl9yZXRyeTsKKwkJ
CX0KIAkJfQotCQlicmVhazsKLQotCWNhc2UgQUNCX0FEQVBURVJfVFlQRV9COiB7Ci0JCXJ0biA9
IGFyY21zcl9wb2xsaW5nX2hiYl9jY2Jkb25lKGFjYiwgcG9sbF9jY2IpOworCQlpZiAoZG9uZXFf
aW5kZXggJiAweDQwMDApIHsKKwkJCWluZGV4X3N0cmlwcGVkID0gZG9uZXFfaW5kZXggJiAweEZG
RjsKKwkJCWluZGV4X3N0cmlwcGVkICs9IDE7CisJCQlpbmRleF9zdHJpcHBlZCAlPSBBUkNNU1Jf
TUFYX0FSQzEyMTRfRE9ORVFVRVVFOworCQkJcG11LT5kb25lcV9pbmRleCA9IGluZGV4X3N0cmlw
cGVkID8gKGluZGV4X3N0cmlwcGVkIHwgMHg0MDAwKQorCQkJCTogKGluZGV4X3N0cmlwcGVkICsg
MSk7CisJCX0gZWxzZSB7CisJCQlpbmRleF9zdHJpcHBlZCA9IGRvbmVxX2luZGV4OworCQkJaW5k
ZXhfc3RyaXBwZWQgKz0gMTsKKwkJCWluZGV4X3N0cmlwcGVkICU9IEFSQ01TUl9NQVhfQVJDMTIx
NF9ET05FUVVFVUU7CisJCQlwbXUtPmRvbmVxX2luZGV4ID0gaW5kZXhfc3RyaXBwZWQgPyBpbmRl
eF9zdHJpcHBlZCA6CisJCQkJKChpbmRleF9zdHJpcHBlZCB8IDB4NDAwMCkgKyAxKTsKKwkJfQor
CQlkb25lcV9pbmRleCA9IHBtdS0+ZG9uZXFfaW5kZXg7CisJCWZsYWdfY2NiID0gcG11LT5kb25l
X3FidWZmZXJbZG9uZXFfaW5kZXggJiAweEZGRl0uYWRkcmVzc0xvdzsKKwkJY2NiX2NkYl9waHkg
PSAoZmxhZ19jY2IgJiAweEZGRkZGRkYwKTsKKwkJYXJjbXNyX2NkYiA9IChzdHJ1Y3QgQVJDTVNS
X0NEQiAqKShhY2ItPnZpcjJwaHlfb2Zmc2V0ICsKKwkJCWNjYl9jZGJfcGh5KTsKKwkJcENDQiA9
IGNvbnRhaW5lcl9vZihhcmNtc3JfY2RiLAorCQkJc3RydWN0IENvbW1hbmRDb250cm9sQmxvY2ss
IGFyY21zcl9jZGIpOworCQlwb2xsX2NjYl9kb25lID0gKHBDQ0IgPT0gcG9sbF9jY2IpID8gMSA6
IDA7CisJCWlmICgocENDQi0+YWNiICE9IGFjYikgfHwKKwkJCShwQ0NCLT5zdGFydGRvbmUgIT0g
QVJDTVNSX0NDQl9TVEFSVCkpIHsKKwkJCWlmIChwQ0NCLT5zdGFydGRvbmUgPT0gQVJDTVNSX0ND
Ql9BQk9SVEVEKSB7CisJCQkJcHJfbm90aWNlKCJhcmNtc3IlZDogc2NzaSBpZCA9ICVkICIKKwkJ
CQkJImx1biA9ICVkIGNjYiA9ICcweCVwJyBwb2xsIGNvbW1hbmQgIgorCQkJCQkiYWJvcnQgc3Vj
Y2Vzc2Z1bGx5XG4iCisJCQkJCSwgYWNiLT5ob3N0LT5ob3N0X25vCisJCQkJCSwgcENDQi0+cGNt
ZC0+ZGV2aWNlLT5pZAorCQkJCQksIHBDQ0ItPnBjbWQtPmRldmljZS0+bHVuCisJCQkJCSwgcEND
Qik7CisJCQkJcENDQi0+cGNtZC0+cmVzdWx0ID0gRElEX0FCT1JUIDw8IDE2OworCQkJCWFyY21z
cl9jY2JfY29tcGxldGUocENDQik7CisJCQkJY29udGludWU7CisJCQl9CisJCQlwcl9ub3RpY2Uo
ImFyY21zciVkOiBwb2xsaW5nIGFuIGlsbGVnYWwgIgorCQkJCSJjY2IgY29tbWFuZCBkb25lIGNj
YiA9ICcweCVwJyAiCisJCQkJImNjYm91dHN0YW5kaW5nY291bnQgPSAlZFxuIgorCQkJCSwgYWNi
LT5ob3N0LT5ob3N0X25vCisJCQkJLCBwQ0NCCisJCQkJLCBhdG9taWNfcmVhZCgmYWNiLT5jY2Jv
dXRzdGFuZGluZ2NvdW50KSk7CisJCQljb250aW51ZTsKIAkJfQorCQllcnJvciA9IChmbGFnX2Nj
YiAmIEFSQ01TUl9DQ0JSRVBMWV9GTEFHX0VSUk9SX01PREUxKQorCQkJPyB0cnVlIDogZmFsc2U7
CisJCWFyY21zcl9yZXBvcnRfY2NiX3N0YXRlKGFjYiwgcENDQiwgZXJyb3IpOworCX0KKwlzcGlu
X3VubG9ja19pcnFyZXN0b3JlKCZhY2ItPmRvbmVxX2xvY2ssIGZsYWdzKTsKKwlyZXR1cm4gcnRu
OworfQorCitzdGF0aWMgaW50CithcmNtc3JfcG9sbGluZ19jY2Jkb25lKHN0cnVjdCBBZGFwdGVy
Q29udHJvbEJsb2NrICphY2IsCisJCQkJc3RydWN0IENvbW1hbmRDb250cm9sQmxvY2sgKnBvbGxf
Y2NiKQoreworCWludCBydG4gPSAwOworCXN3aXRjaCAoYWNiLT5hZGFwdGVyX3R5cGUpIHsKKwlj
YXNlIEFDQl9BREFQVEVSX1RZUEVfQTp7CisJCXJ0biA9IGFyY21zcl9oYmFBX3BvbGxpbmdfY2Ni
ZG9uZShhY2IsIHBvbGxfY2NiKTsKKwkJYnJlYWs7CisJfQorCWNhc2UgQUNCX0FEQVBURVJfVFlQ
RV9COnsKKwkJcnRuID0gYXJjbXNyX2hiYUJfcG9sbGluZ19jY2Jkb25lKGFjYiwgcG9sbF9jY2Ip
OwogCQlicmVhazsKKwl9CiAJY2FzZSBBQ0JfQURBUFRFUl9UWVBFX0M6IHsKLQkJcnRuID0gYXJj
bXNyX3BvbGxpbmdfaGJjX2NjYmRvbmUoYWNiLCBwb2xsX2NjYik7Ci0JCX0KKwkJcnRuID0gYXJj
bXNyX2hiYUNfcG9sbGluZ19jY2Jkb25lKGFjYiwgcG9sbF9jY2IpOworCQlicmVhazsKKwl9CisJ
Y2FzZSBBQ0JfQURBUFRFUl9UWVBFX0Q6IHsKKwkJcnRuID0gYXJjbXNyX2hiYURfcG9sbGluZ19j
Y2Jkb25lKGFjYiwgcG9sbF9jY2IpOworCQlicmVhazsKKwl9CiAJfQogCXJldHVybiBydG47CiB9
CiAKLXN0YXRpYyBpbnQgYXJjbXNyX2lvcF9jb25maXJtKHN0cnVjdCBBZGFwdGVyQ29udHJvbEJs
b2NrICphY2IpCitzdGF0aWMgaW50CithcmNtc3JfaW9wX2NvbmZpcm0oc3RydWN0IEFkYXB0ZXJD
b250cm9sQmxvY2sgKmFjYikKIHsKLQl1aW50MzJfdCBjZGJfcGh5YWRkciwgY2RiX3BoeWFkZHJf
aGkzMjsKKwl1aW50MzJfdCBjZGJfcGh5YWRkciwgY2RiX3BoeWFkZHJfaGkzMiwgY2RiX3BoeWFk
ZHJfbG8zMjsKIAlkbWFfYWRkcl90IGRtYV9jb2hlcmVudF9oYW5kbGU7CiAJLyoKIAkqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKgotCSoqIGhlcmUgd2UgbmVlZCB0byB0ZWxsIGlvcCAzMzEgb3VyIGZyZWVjY2IuSGlnaFBh
cnQKKwkqKiBIZXJlIHdlIG5lZWQgdG8gdGVsbCBpb3Agb3VyIGZyZWVjY2IuSGlnaFBhcnQKIAkq
KiBpZiBmcmVlY2NiLkhpZ2hQYXJ0IGlzIG5vdCB6ZXJvCiAJKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioKIAkqLwotCWRt
YV9jb2hlcmVudF9oYW5kbGUgPSBhY2ItPmRtYV9jb2hlcmVudF9oYW5kbGU7Ci0JY2RiX3BoeWFk
ZHIgPSAodWludDMyX3QpKGRtYV9jb2hlcmVudF9oYW5kbGUpOworCXN3aXRjaCAoYWNiLT5hZGFw
dGVyX3R5cGUpIHsKKwkJY2FzZSBBQ0JfQURBUFRFUl9UWVBFX0E6CisJCWNhc2UgQUNCX0FEQVBU
RVJfVFlQRV9COgorCQljYXNlIEFDQl9BREFQVEVSX1RZUEVfQzoKKwkJCWRtYV9jb2hlcmVudF9o
YW5kbGUgPSBhY2ItPmRtYV9jb2hlcmVudF9oYW5kbGU7CisJCQlicmVhazsKKwkJY2FzZSBBQ0Jf
QURBUFRFUl9UWVBFX0Q6CisJCQlkbWFfY29oZXJlbnRfaGFuZGxlID0gYWNiLT5kbWFfY29oZXJl
bnRfaGFuZGxlMjsKKwkJCWJyZWFrOworCQlkZWZhdWx0OgorCQkJZG1hX2NvaGVyZW50X2hhbmRs
ZSA9IGFjYi0+ZG1hX2NvaGVyZW50X2hhbmRsZTsKKwkJCWJyZWFrOworCX0KKwljZGJfcGh5YWRk
cl9sbzMyID0gKHVpbnQzMl90KShkbWFfY29oZXJlbnRfaGFuZGxlICYgMHhmZmZmZmZmZik7CiAJ
Y2RiX3BoeWFkZHJfaGkzMiA9ICh1aW50MzJfdCkoKGNkYl9waHlhZGRyID4+IDE2KSA+PiAxNik7
CiAJYWNiLT5jZGJfcGh5YWRkcl9oaTMyID0gY2RiX3BoeWFkZHJfaGkzMjsKIAkvKgogCSoqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqCi0JKiogICAgaWYgYWRhcHRlciB0eXBlIEIsIHNldCB3aW5kb3cgb2YgInBvc3Qg
Y29tbWFuZCBRIgorCSoqIGlmIGFkYXB0ZXIgdHlwZSBCIEQgc2V0IHdpbmRvdyBvZiAicG9zdCBj
b21tYW5kIFEiCiAJKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioKIAkqLwogCXN3aXRjaCAoYWNiLT5hZGFwdGVyX3R5
cGUpIHsKQEAgLTI1MjEsMjAgKzM3NDQsMTcgQEAgc3RhdGljIGludCBhcmNtc3JfaW9wX2NvbmZp
cm0oc3RydWN0IEFkYQogCWNhc2UgQUNCX0FEQVBURVJfVFlQRV9BOiB7CiAJCWlmIChjZGJfcGh5
YWRkcl9oaTMyICE9IDApIHsKIAkJCXN0cnVjdCBNZXNzYWdlVW5pdF9BIF9faW9tZW0gKnJlZyA9
IGFjYi0+cG11QTsKLQkJCXVpbnQzMl90IGludG1hc2tfb3JnOwotCQkJaW50bWFza19vcmcgPSBh
cmNtc3JfZGlzYWJsZV9vdXRib3VuZF9pbnRzKGFjYik7Ci0JCQl3cml0ZWwoQVJDTVNSX1NJR05B
VFVSRV9TRVRfQ09ORklHLCBcCi0JCQkJCQkmcmVnLT5tZXNzYWdlX3J3YnVmZmVyWzBdKTsKKwkJ
CXdyaXRlbChBUkNNU1JfU0lHTkFUVVJFX1NFVF9DT05GSUcsCisJCQkJJnJlZy0+bWVzc2FnZV9y
d2J1ZmZlclswXSk7CiAJCQl3cml0ZWwoY2RiX3BoeWFkZHJfaGkzMiwgJnJlZy0+bWVzc2FnZV9y
d2J1ZmZlclsxXSk7Ci0JCQl3cml0ZWwoQVJDTVNSX0lOQk9VTkRfTUVTRzBfU0VUX0NPTkZJRywg
XAotCQkJCQkJCSZyZWctPmluYm91bmRfbXNnYWRkcjApOwotCQkJaWYgKCFhcmNtc3JfaGJhX3dh
aXRfbXNnaW50X3JlYWR5KGFjYikpIHsKLQkJCQlwcmludGsoS0VSTl9OT1RJQ0UgImFyY21zciVk
OiAiInNldCBjY2IgaGlnaCBcCi0JCQkJcGFydCBwaHlzaWNhbCBhZGRyZXNzIHRpbWVvdXRcbiIs
Ci0JCQkJYWNiLT5ob3N0LT5ob3N0X25vKTsKKwkJCXdyaXRlbChBUkNNU1JfSU5CT1VORF9NRVNH
MF9TRVRfQ09ORklHLAorCQkJCSZyZWctPmluYm91bmRfbXNnYWRkcjApOworCQkJaWYgKCFhcmNt
c3JfaGJhQV93YWl0X21zZ2ludF9yZWFkeShhY2IpKSB7CisJCQkJcHJfbm90aWNlKCJhcmNtc3Il
ZDogc2V0IGNjYiAiCisJCQkJCSJoaWdoIHBhcnQgcGh5c2ljYWwgYWRkcmVzcyB0aW1lb3V0XG4i
LAorCQkJCQlhY2ItPmhvc3QtPmhvc3Rfbm8pOwogCQkJCXJldHVybiAxOwogCQkJfQotCQkJYXJj
bXNyX2VuYWJsZV9vdXRib3VuZF9pbnRzKGFjYiwgaW50bWFza19vcmcpOwogCQl9CiAJCX0KIAkJ
YnJlYWs7CkBAIC0yNTQzLDE4ICszNzYzLDE3IEBAIHN0YXRpYyBpbnQgYXJjbXNyX2lvcF9jb25m
aXJtKHN0cnVjdCBBZGEKIAkJdW5zaWduZWQgbG9uZyBwb3N0X3F1ZXVlX3BoeWFkZHI7CiAJCXVp
bnQzMl90IF9faW9tZW0gKnJ3YnVmZmVyOwogCi0JCXN0cnVjdCBNZXNzYWdlVW5pdF9CICpyZWcg
PSBhY2ItPnBtdUI7Ci0JCXVpbnQzMl90IGludG1hc2tfb3JnOwotCQlpbnRtYXNrX29yZyA9IGFy
Y21zcl9kaXNhYmxlX291dGJvdW5kX2ludHMoYWNiKTsKKwkJc3RydWN0IE1lc3NhZ2VVbml0X0Ig
X19pb21lbSAqcmVnID0gYWNiLT5wbXVCOwogCQlyZWctPnBvc3RxX2luZGV4ID0gMDsKIAkJcmVn
LT5kb25lcV9pbmRleCA9IDA7Ci0JCXdyaXRlbChBUkNNU1JfTUVTU0FHRV9TRVRfUE9TVF9XSU5E
T1csIHJlZy0+ZHJ2MmlvcF9kb29yYmVsbCk7Ci0JCWlmICghYXJjbXNyX2hiYl93YWl0X21zZ2lu
dF9yZWFkeShhY2IpKSB7Ci0JCQlwcmludGsoS0VSTl9OT1RJQ0UgImFyY21zciVkOmNhbiBub3Qg
c2V0IGRpdmVyIG1vZGVcbiIsIFwKKwkJd3JpdGVsKEFSQ01TUl9NRVNTQUdFX1NFVF9QT1NUX1dJ
TkRPVywKKwkJCXJlZy0+ZHJ2MmlvcF9kb29yYmVsbCk7CisJCWlmICghYXJjbXNyX2hiYUJfd2Fp
dF9tc2dpbnRfcmVhZHkoYWNiKSkgeworCQkJcHJfbm90aWNlKCJhcmNtc3IlZDpjYW4gbm90IHNl
dCBkaXZlciBtb2RlXG4iLAogCQkJCWFjYi0+aG9zdC0+aG9zdF9ubyk7CiAJCQlyZXR1cm4gMTsK
IAkJfQotCQlwb3N0X3F1ZXVlX3BoeWFkZHIgPSBhY2ItPmRtYV9jb2hlcmVudF9oYW5kbGVfaGJi
X211OworCQlwb3N0X3F1ZXVlX3BoeWFkZHIgPSBhY2ItPmRtYV9jb2hlcmVudF9oYW5kbGUyOwog
CQlyd2J1ZmZlciA9IHJlZy0+bWVzc2FnZV9yd2J1ZmZlcjsKIAkJLyogZHJpdmVyICJzZXQgY29u
ZmlnIiBzaWduYXR1cmUgKi8KIAkJd3JpdGVsKEFSQ01TUl9TSUdOQVRVUkVfU0VUX0NPTkZJRywg
cndidWZmZXIrKyk7CkBAIC0yNTY2LDM5ICszNzg1LDY0IEBAIHN0YXRpYyBpbnQgYXJjbXNyX2lv
cF9jb25maXJtKHN0cnVjdCBBZGEKIAkJd3JpdGVsKHBvc3RfcXVldWVfcGh5YWRkciArIDEwNTYs
IHJ3YnVmZmVyKyspOwogCQkvKiBjY2IgbWF4USBzaXplIG11c3QgYmUgLS0+IFsoMjU2ICsgOCkq
NF0qLwogCQl3cml0ZWwoMTA1NiwgcndidWZmZXIpOwotCiAJCXdyaXRlbChBUkNNU1JfTUVTU0FH
RV9TRVRfQ09ORklHLCByZWctPmRydjJpb3BfZG9vcmJlbGwpOwotCQlpZiAoIWFyY21zcl9oYmJf
d2FpdF9tc2dpbnRfcmVhZHkoYWNiKSkgewotCQkJcHJpbnRrKEtFUk5fTk9USUNFICJhcmNtc3Il
ZDogJ3NldCBjb21tYW5kIFEgd2luZG93JyBcCi0JCQl0aW1lb3V0IFxuIixhY2ItPmhvc3QtPmhv
c3Rfbm8pOworCQlpZiAoIWFyY21zcl9oYmFCX3dhaXRfbXNnaW50X3JlYWR5KGFjYikpIHsKKwkJ
CXByX25vdGljZSgiYXJjbXNyJWQ6ICdzZXQgY29tbWFuZCBRIHdpbmRvdycgIgorCQkJCSJ0aW1l
b3V0XG4iLCBhY2ItPmhvc3QtPmhvc3Rfbm8pOwogCQkJcmV0dXJuIDE7CiAJCX0KIAkJYXJjbXNy
X2hiYl9lbmFibGVfZHJpdmVyX21vZGUoYWNiKTsKLQkJYXJjbXNyX2VuYWJsZV9vdXRib3VuZF9p
bnRzKGFjYiwgaW50bWFza19vcmcpOwogCQl9CiAJCWJyZWFrOwogCWNhc2UgQUNCX0FEQVBURVJf
VFlQRV9DOiB7CisJCXN0cnVjdCBNZXNzYWdlVW5pdF9DIF9faW9tZW0gKnJlZyA9IGFjYi0+cG11
QzsKIAkJaWYgKGNkYl9waHlhZGRyX2hpMzIgIT0gMCkgewotCQkJc3RydWN0IE1lc3NhZ2VVbml0
X0MgKnJlZyA9IChzdHJ1Y3QgTWVzc2FnZVVuaXRfQyAqKWFjYi0+cG11QzsKLQotCQkJcHJpbnRr
KEtFUk5fTk9USUNFICJhcmNtc3IlZDogY2RiX3BoeWFkZHJfaGkzMj0weCV4XG4iLAotCQkJCQlh
Y2ItPmFkYXB0ZXJfaW5kZXgsIGNkYl9waHlhZGRyX2hpMzIpOwotCQkJd3JpdGVsKEFSQ01TUl9T
SUdOQVRVUkVfU0VUX0NPTkZJRywgJnJlZy0+bXNnY29kZV9yd2J1ZmZlclswXSk7Ci0JCQl3cml0
ZWwoY2RiX3BoeWFkZHJfaGkzMiwgJnJlZy0+bXNnY29kZV9yd2J1ZmZlclsxXSk7Ci0JCQl3cml0
ZWwoQVJDTVNSX0lOQk9VTkRfTUVTRzBfU0VUX0NPTkZJRywgJnJlZy0+aW5ib3VuZF9tc2dhZGRy
MCk7Ci0JCQl3cml0ZWwoQVJDTVNSX0hCQ01VX0RSVjJJT1BfTUVTU0FHRV9DTURfRE9ORSwgJnJl
Zy0+aW5ib3VuZF9kb29yYmVsbCk7Ci0JCQlpZiAoIWFyY21zcl9oYmNfd2FpdF9tc2dpbnRfcmVh
ZHkoYWNiKSkgewotCQkJCXByaW50ayhLRVJOX05PVElDRSAiYXJjbXNyJWQ6ICdzZXQgY29tbWFu
ZCBRIHdpbmRvdycgXAotCQkJCXRpbWVvdXQgXG4iLCBhY2ItPmhvc3QtPmhvc3Rfbm8pOworCQkJ
cHJfbm90aWNlKCJhcmNtc3IlZDogY2RiX3BoeWFkZHJfaGkzMiA9IDB4JXhcbiIsCisJCQlhY2It
PmFkYXB0ZXJfaW5kZXgsIGNkYl9waHlhZGRyX2hpMzIpOworCQkJd3JpdGVsKEFSQ01TUl9TSUdO
QVRVUkVfU0VUX0NPTkZJRywKKwkJCQkmcmVnLT5tc2djb2RlX3J3YnVmZmVyWzBdKTsKKwkJCXdy
aXRlbChjZGJfcGh5YWRkcl9oaTMyLAorCQkJCSZyZWctPm1zZ2NvZGVfcndidWZmZXJbMV0pOwor
CQkJd3JpdGVsKEFSQ01TUl9JTkJPVU5EX01FU0cwX1NFVF9DT05GSUcsCisJCQkJJnJlZy0+aW5i
b3VuZF9tc2dhZGRyMCk7CisJCQl3cml0ZWwoQVJDTVNSX0hCQ01VX0RSVjJJT1BfTUVTU0FHRV9D
TURfRE9ORSwKKwkJCQkmcmVnLT5pbmJvdW5kX2Rvb3JiZWxsKTsKKwkJCWlmICghYXJjbXNyX2hi
YUNfd2FpdF9tc2dpbnRfcmVhZHkoYWNiKSkgeworCQkJCXByX25vdGljZSgiYXJjbXNyJWQ6ICdz
ZXQgIgorCQkJCQkiY29tbWFuZCBRIHdpbmRvdycgdGltZW91dFxuIiwKKwkJCQkJYWNiLT5ob3N0
LT5ob3N0X25vKTsKIAkJCQlyZXR1cm4gMTsKIAkJCX0KIAkJfQogCQl9CisJCWJyZWFrOworCWNh
c2UgQUNCX0FEQVBURVJfVFlQRV9EOiB7CisJCXVpbnQzMl90IF9faW9tZW0gKnJ3YnVmZmVyOwor
CisJCXN0cnVjdCBNZXNzYWdlVW5pdF9EIF9faW9tZW0gKnJlZyA9IGFjYi0+cG11RDsKKwkJcmVn
LT5wb3N0cV9pbmRleCA9IDA7CisJCXJlZy0+ZG9uZXFfaW5kZXggPSAwOworCQlyd2J1ZmZlciA9
IHJlZy0+bXNnY29kZV9yd2J1ZmZlcjsKKwkJd3JpdGVsKEFSQ01TUl9TSUdOQVRVUkVfU0VUX0NP
TkZJRywgcndidWZmZXIrKyk7CisJCXdyaXRlbChjZGJfcGh5YWRkcl9oaTMyLCByd2J1ZmZlcisr
KTsKKwkJd3JpdGVsKGNkYl9waHlhZGRyX2xvMzIsIHJ3YnVmZmVyKyspOworCQl3cml0ZWwoY2Ri
X3BoeWFkZHJfbG8zMiArCisJCQkoQVJDTVNSX01BWF9BUkMxMjE0X1BPU1RRVUVVRSAqIHNpemVv
ZihzdHJ1Y3QgSW5Cb3VuZF9TUkIpKSwKKwkJcndidWZmZXIrKyk7CisJCXdyaXRlbCgweDEwMCwg
cndidWZmZXIpOworCQl3cml0ZWwoQVJDTVNSX0lOQk9VTkRfTUVTRzBfU0VUX0NPTkZJRywKKwkJ
CXJlZy0+aW5ib3VuZF9tc2dhZGRyMCk7CisJCWlmICghYXJjbXNyX2hiYURfd2FpdF9tc2dpbnRf
cmVhZHkoYWNiKSkKKwkJCXByX25vdGljZSgiYXJjbXNyJWQ6ICdzZXQgY29tbWFuZCBRICIKKwkJ
CQkid2luZG93JyB0aW1lb3V0XG4iLCBhY2ItPmhvc3QtPmhvc3Rfbm8pOworCQlicmVhazsKKwl9
CiAJfQogCXJldHVybiAwOwogfQogCi1zdGF0aWMgdm9pZCBhcmNtc3Jfd2FpdF9maXJtd2FyZV9y
ZWFkeShzdHJ1Y3QgQWRhcHRlckNvbnRyb2xCbG9jayAqYWNiKQorc3RhdGljIHZvaWQKK2FyY21z
cl93YWl0X2Zpcm13YXJlX3JlYWR5KHN0cnVjdCBBZGFwdGVyQ29udHJvbEJsb2NrICphY2IpCiB7
CiAJdWludDMyX3QgZmlybXdhcmVfc3RhdGUgPSAwOwogCXN3aXRjaCAoYWNiLT5hZGFwdGVyX3R5
cGUpIHsKQEAgLTI2MDcsMTYxICszODUxLDI1OSBAQCBzdGF0aWMgdm9pZCBhcmNtc3Jfd2FpdF9m
aXJtd2FyZV9yZWFkeShzCiAJCXN0cnVjdCBNZXNzYWdlVW5pdF9BIF9faW9tZW0gKnJlZyA9IGFj
Yi0+cG11QTsKIAkJZG8gewogCQkJZmlybXdhcmVfc3RhdGUgPSByZWFkbCgmcmVnLT5vdXRib3Vu
ZF9tc2dhZGRyMSk7Ci0JCX0gd2hpbGUgKChmaXJtd2FyZV9zdGF0ZSAmIEFSQ01TUl9PVVRCT1VO
RF9NRVNHMV9GSVJNV0FSRV9PSykgPT0gMCk7CisJCX0gd2hpbGUgKChmaXJtd2FyZV9zdGF0ZSAm
CisJCQlBUkNNU1JfT1VUQk9VTkRfTUVTRzFfRklSTVdBUkVfT0spID09IDApOwogCQl9CiAJCWJy
ZWFrOwotCiAJY2FzZSBBQ0JfQURBUFRFUl9UWVBFX0I6IHsKLQkJc3RydWN0IE1lc3NhZ2VVbml0
X0IgKnJlZyA9IGFjYi0+cG11QjsKKwkJc3RydWN0IE1lc3NhZ2VVbml0X0IgX19pb21lbSAqcmVn
ID0gYWNiLT5wbXVCOwogCQlkbyB7CiAJCQlmaXJtd2FyZV9zdGF0ZSA9IHJlYWRsKHJlZy0+aW9w
MmRydl9kb29yYmVsbCk7CiAJCX0gd2hpbGUgKChmaXJtd2FyZV9zdGF0ZSAmIEFSQ01TUl9NRVNT
QUdFX0ZJUk1XQVJFX09LKSA9PSAwKTsKLQkJd3JpdGVsKEFSQ01TUl9EUlYySU9QX0VORF9PRl9J
TlRFUlJVUFQsIHJlZy0+ZHJ2MmlvcF9kb29yYmVsbCk7CisJCXdyaXRlbChBUkNNU1JfRFJWMklP
UF9FTkRfT0ZfSU5URVJSVVBULAorCQkJcmVnLT5kcnYyaW9wX2Rvb3JiZWxsKTsKIAkJfQogCQli
cmVhazsKIAljYXNlIEFDQl9BREFQVEVSX1RZUEVfQzogewotCQlzdHJ1Y3QgTWVzc2FnZVVuaXRf
QyAqcmVnID0gKHN0cnVjdCBNZXNzYWdlVW5pdF9DICopYWNiLT5wbXVDOworCQlzdHJ1Y3QgTWVz
c2FnZVVuaXRfQyBfX2lvbWVtICpyZWcgPSBhY2ItPnBtdUM7CiAJCWRvIHsKIAkJCWZpcm13YXJl
X3N0YXRlID0gcmVhZGwoJnJlZy0+b3V0Ym91bmRfbXNnYWRkcjEpOwotCQl9IHdoaWxlICgoZmly
bXdhcmVfc3RhdGUgJiBBUkNNU1JfSEJDTVVfTUVTU0FHRV9GSVJNV0FSRV9PSykgPT0gMCk7CisJ
CX0gd2hpbGUgKChmaXJtd2FyZV9zdGF0ZSAmCisJCQlBUkNNU1JfSEJDTVVfTUVTU0FHRV9GSVJN
V0FSRV9PSykgPT0gMCk7CiAJCX0KKwkJYnJlYWs7CisJY2FzZSBBQ0JfQURBUFRFUl9UWVBFX0Q6
IHsKKwkJc3RydWN0IE1lc3NhZ2VVbml0X0QgX19pb21lbSAqcmVnID0gYWNiLT5wbXVEOworCQlk
byB7CisJCQlmaXJtd2FyZV9zdGF0ZSA9IHJlYWRsKHJlZy0+b3V0Ym91bmRfbXNnYWRkcjEpOwor
CQl9IHdoaWxlICgoZmlybXdhcmVfc3RhdGUgJgorCQkJQVJDTVNSX0FSQzEyMTRfTUVTU0FHRV9G
SVJNV0FSRV9PSykgPT0gMCk7CisJCWJyZWFrOworCX0KIAl9CiB9CiAKLXN0YXRpYyB2b2lkIGFy
Y21zcl9yZXF1ZXN0X2hiYV9kZXZpY2VfbWFwKHN0cnVjdCBBZGFwdGVyQ29udHJvbEJsb2NrICph
Y2IpCitzdGF0aWMgdm9pZAorYXJjbXNyX2hiYUFfcmVxdWVzdF9kZXZpY2VfbWFwKHN0cnVjdCBB
ZGFwdGVyQ29udHJvbEJsb2NrICphY2IpCiB7CiAJc3RydWN0IE1lc3NhZ2VVbml0X0EgX19pb21l
bSAqcmVnID0gYWNiLT5wbXVBOwotCWlmICh1bmxpa2VseShhdG9taWNfcmVhZCgmYWNiLT5ycV9t
YXBfdG9rZW4pID09IDApIHx8ICgoYWNiLT5hY2JfZmxhZ3MgJiBBQ0JfRl9CVVNfUkVTRVQpICE9
IDAgKSB8fCAoKGFjYi0+YWNiX2ZsYWdzICYgQUNCX0ZfQUJPUlQpICE9IDAgKSl7Ci0JCW1vZF90
aW1lcigmYWNiLT5ldGVybmFsX3RpbWVyLCBqaWZmaWVzICsgbXNlY3NfdG9famlmZmllcyg2ICog
SFopKTsKKwlpZiAodW5saWtlbHkoYXRvbWljX3JlYWQoJmFjYi0+cnFfbWFwX3Rva2VuKSA9PSAw
KSB8fAorCQkoKGFjYi0+YWNiX2ZsYWdzICYgQUNCX0ZfQlVTX1JFU0VUKSAhPSAwKQorCQl8fCAo
KGFjYi0+YWNiX2ZsYWdzICYgQUNCX0ZfQUJPUlQpICE9IDApKSB7CisJCW1vZF90aW1lcigmYWNi
LT5ldGVybmFsX3RpbWVyLAorCQkJamlmZmllcyArIG1zZWNzX3RvX2ppZmZpZXMoNiAqIEhaKSk7
CiAJCXJldHVybjsKIAl9IGVsc2UgewogCQlhY2ItPmZ3X2ZsYWcgPSBGV19OT1JNQUw7Ci0JCWlm
IChhdG9taWNfcmVhZCgmYWNiLT5hbnRlX3Rva2VuX3ZhbHVlKSA9PSBhdG9taWNfcmVhZCgmYWNi
LT5ycV9tYXBfdG9rZW4pKXsKKwkJaWYgKGF0b21pY19yZWFkKCZhY2ItPmFudGVfdG9rZW5fdmFs
dWUpID09CisJCQlhdG9taWNfcmVhZCgmYWNiLT5ycV9tYXBfdG9rZW4pKSB7CiAJCQlhdG9taWNf
c2V0KCZhY2ItPnJxX21hcF90b2tlbiwgMTYpOwogCQl9Ci0JCWF0b21pY19zZXQoJmFjYi0+YW50
ZV90b2tlbl92YWx1ZSwgYXRvbWljX3JlYWQoJmFjYi0+cnFfbWFwX3Rva2VuKSk7CisJCWF0b21p
Y19zZXQoJmFjYi0+YW50ZV90b2tlbl92YWx1ZSwKKwkJCWF0b21pY19yZWFkKCZhY2ItPnJxX21h
cF90b2tlbikpOwogCQlpZiAoYXRvbWljX2RlY19hbmRfdGVzdCgmYWNiLT5ycV9tYXBfdG9rZW4p
KSB7Ci0JCQltb2RfdGltZXIoJmFjYi0+ZXRlcm5hbF90aW1lciwgamlmZmllcyArIG1zZWNzX3Rv
X2ppZmZpZXMoNiAqIEhaKSk7CisJCQltb2RfdGltZXIoJmFjYi0+ZXRlcm5hbF90aW1lciwKKwkJ
CQlqaWZmaWVzICsgbXNlY3NfdG9famlmZmllcyg2ICogSFopKTsKIAkJCXJldHVybjsKIAkJfQot
CQl3cml0ZWwoQVJDTVNSX0lOQk9VTkRfTUVTRzBfR0VUX0NPTkZJRywgJnJlZy0+aW5ib3VuZF9t
c2dhZGRyMCk7Ci0JCW1vZF90aW1lcigmYWNiLT5ldGVybmFsX3RpbWVyLCBqaWZmaWVzICsgbXNl
Y3NfdG9famlmZmllcyg2ICogSFopKTsKKwkJd3JpdGVsKEFSQ01TUl9JTkJPVU5EX01FU0cwX0dF
VF9DT05GSUcsCisJCQkmcmVnLT5pbmJvdW5kX21zZ2FkZHIwKTsKKwkJbW9kX3RpbWVyKCZhY2It
PmV0ZXJuYWxfdGltZXIsIGppZmZpZXMgKworCQkJbXNlY3NfdG9famlmZmllcyg2ICogSFopKTsK
IAl9Ci0JcmV0dXJuOwogfQogCi1zdGF0aWMgdm9pZCBhcmNtc3JfcmVxdWVzdF9oYmJfZGV2aWNl
X21hcChzdHJ1Y3QgQWRhcHRlckNvbnRyb2xCbG9jayAqYWNiKQorc3RhdGljIHZvaWQKK2FyY21z
cl9oYmFCX3JlcXVlc3RfZGV2aWNlX21hcChzdHJ1Y3QgQWRhcHRlckNvbnRyb2xCbG9jayAqYWNi
KQogewogCXN0cnVjdCBNZXNzYWdlVW5pdF9CIF9faW9tZW0gKnJlZyA9IGFjYi0+cG11QjsKLQlp
ZiAodW5saWtlbHkoYXRvbWljX3JlYWQoJmFjYi0+cnFfbWFwX3Rva2VuKSA9PSAwKSB8fCAoKGFj
Yi0+YWNiX2ZsYWdzICYgQUNCX0ZfQlVTX1JFU0VUKSAhPSAwICkgfHwgKChhY2ItPmFjYl9mbGFn
cyAmIEFDQl9GX0FCT1JUKSAhPSAwICkpewotCQltb2RfdGltZXIoJmFjYi0+ZXRlcm5hbF90aW1l
ciwgamlmZmllcyArIG1zZWNzX3RvX2ppZmZpZXMoNiAqIEhaKSk7CisJaWYgKHVubGlrZWx5KGF0
b21pY19yZWFkKCZhY2ItPnJxX21hcF90b2tlbikgPT0gMCkgfHwKKwkJKChhY2ItPmFjYl9mbGFn
cyAmIEFDQl9GX0JVU19SRVNFVCkgIT0gMCkgfHwKKwkJKChhY2ItPmFjYl9mbGFncyAmIEFDQl9G
X0FCT1JUKSAhPSAwKSkgeworCQltb2RfdGltZXIoJmFjYi0+ZXRlcm5hbF90aW1lciwgamlmZmll
cyArCisJCQltc2Vjc190b19qaWZmaWVzKDYgKiBIWikpOwogCQlyZXR1cm47CiAJfSBlbHNlIHsK
IAkJYWNiLT5md19mbGFnID0gRldfTk9STUFMOwotCQlpZiAoYXRvbWljX3JlYWQoJmFjYi0+YW50
ZV90b2tlbl92YWx1ZSkgPT0gYXRvbWljX3JlYWQoJmFjYi0+cnFfbWFwX3Rva2VuKSkgeworCQlp
ZiAoYXRvbWljX3JlYWQoJmFjYi0+YW50ZV90b2tlbl92YWx1ZSkgPT0KKwkJCWF0b21pY19yZWFk
KCZhY2ItPnJxX21hcF90b2tlbikpIHsKIAkJCWF0b21pY19zZXQoJmFjYi0+cnFfbWFwX3Rva2Vu
LCAxNik7CiAJCX0KLQkJYXRvbWljX3NldCgmYWNiLT5hbnRlX3Rva2VuX3ZhbHVlLCBhdG9taWNf
cmVhZCgmYWNiLT5ycV9tYXBfdG9rZW4pKTsKKwkJYXRvbWljX3NldCgmYWNiLT5hbnRlX3Rva2Vu
X3ZhbHVlLAorCQkJYXRvbWljX3JlYWQoJmFjYi0+cnFfbWFwX3Rva2VuKSk7CiAJCWlmIChhdG9t
aWNfZGVjX2FuZF90ZXN0KCZhY2ItPnJxX21hcF90b2tlbikpIHsKLQkJCW1vZF90aW1lcigmYWNi
LT5ldGVybmFsX3RpbWVyLCBqaWZmaWVzICsgbXNlY3NfdG9famlmZmllcyg2ICogSFopKTsKKwkJ
CW1vZF90aW1lcigmYWNiLT5ldGVybmFsX3RpbWVyLAorCQkJCWppZmZpZXMgKyBtc2Vjc190b19q
aWZmaWVzKDYgKiBIWikpOwogCQkJcmV0dXJuOwogCQl9Ci0JCXdyaXRlbChBUkNNU1JfTUVTU0FH
RV9HRVRfQ09ORklHLCByZWctPmRydjJpb3BfZG9vcmJlbGwpOwotCQltb2RfdGltZXIoJmFjYi0+
ZXRlcm5hbF90aW1lciwgamlmZmllcyArIG1zZWNzX3RvX2ppZmZpZXMoNiAqIEhaKSk7CisJCXdy
aXRlbChBUkNNU1JfTUVTU0FHRV9HRVRfQ09ORklHLAorCQkJcmVnLT5kcnYyaW9wX2Rvb3JiZWxs
KTsKKwkJbW9kX3RpbWVyKCZhY2ItPmV0ZXJuYWxfdGltZXIsIGppZmZpZXMgKworCQkJbXNlY3Nf
dG9famlmZmllcyg2ICogSFopKTsKIAl9Ci0JcmV0dXJuOwogfQogCi1zdGF0aWMgdm9pZCBhcmNt
c3JfcmVxdWVzdF9oYmNfZGV2aWNlX21hcChzdHJ1Y3QgQWRhcHRlckNvbnRyb2xCbG9jayAqYWNi
KQorc3RhdGljIHZvaWQKK2FyY21zcl9oYmFDX3JlcXVlc3RfZGV2aWNlX21hcChzdHJ1Y3QgQWRh
cHRlckNvbnRyb2xCbG9jayAqYWNiKQogewogCXN0cnVjdCBNZXNzYWdlVW5pdF9DIF9faW9tZW0g
KnJlZyA9IGFjYi0+cG11QzsKLQlpZiAodW5saWtlbHkoYXRvbWljX3JlYWQoJmFjYi0+cnFfbWFw
X3Rva2VuKSA9PSAwKSB8fCAoKGFjYi0+YWNiX2ZsYWdzICYgQUNCX0ZfQlVTX1JFU0VUKSAhPSAw
KSB8fCAoKGFjYi0+YWNiX2ZsYWdzICYgQUNCX0ZfQUJPUlQpICE9IDApKSB7Ci0JCW1vZF90aW1l
cigmYWNiLT5ldGVybmFsX3RpbWVyLCBqaWZmaWVzICsgbXNlY3NfdG9famlmZmllcyg2ICogSFop
KTsKKwlpZiAodW5saWtlbHkoYXRvbWljX3JlYWQoJmFjYi0+cnFfbWFwX3Rva2VuKSA9PSAwKSB8
fAorCQkoKGFjYi0+YWNiX2ZsYWdzICYgQUNCX0ZfQlVTX1JFU0VUKSAhPSAwKSB8fAorCQkoKGFj
Yi0+YWNiX2ZsYWdzICYgQUNCX0ZfQUJPUlQpICE9IDApKSB7CisJCW1vZF90aW1lcigmYWNiLT5l
dGVybmFsX3RpbWVyLCBqaWZmaWVzICsKKwkJCW1zZWNzX3RvX2ppZmZpZXMoNiAqIEhaKSk7CiAJ
CXJldHVybjsKIAl9IGVsc2UgewogCQlhY2ItPmZ3X2ZsYWcgPSBGV19OT1JNQUw7Ci0JCWlmIChh
dG9taWNfcmVhZCgmYWNiLT5hbnRlX3Rva2VuX3ZhbHVlKSA9PSBhdG9taWNfcmVhZCgmYWNiLT5y
cV9tYXBfdG9rZW4pKSB7CisJCWlmIChhdG9taWNfcmVhZCgmYWNiLT5hbnRlX3Rva2VuX3ZhbHVl
KSA9PQorCQkJYXRvbWljX3JlYWQoJmFjYi0+cnFfbWFwX3Rva2VuKSkgewogCQkJYXRvbWljX3Nl
dCgmYWNiLT5ycV9tYXBfdG9rZW4sIDE2KTsKIAkJfQotCQlhdG9taWNfc2V0KCZhY2ItPmFudGVf
dG9rZW5fdmFsdWUsIGF0b21pY19yZWFkKCZhY2ItPnJxX21hcF90b2tlbikpOworCQlhdG9taWNf
c2V0KCZhY2ItPmFudGVfdG9rZW5fdmFsdWUsCisJCQlhdG9taWNfcmVhZCgmYWNiLT5ycV9tYXBf
dG9rZW4pKTsKIAkJaWYgKGF0b21pY19kZWNfYW5kX3Rlc3QoJmFjYi0+cnFfbWFwX3Rva2VuKSkg
ewotCQkJbW9kX3RpbWVyKCZhY2ItPmV0ZXJuYWxfdGltZXIsIGppZmZpZXMgKyBtc2Vjc190b19q
aWZmaWVzKDYgKiBIWikpOworCQkJbW9kX3RpbWVyKCZhY2ItPmV0ZXJuYWxfdGltZXIsCisJCQkJ
amlmZmllcyArIG1zZWNzX3RvX2ppZmZpZXMoNiAqIEhaKSk7CiAJCQlyZXR1cm47CiAJCX0KLQkJ
d3JpdGVsKEFSQ01TUl9JTkJPVU5EX01FU0cwX0dFVF9DT05GSUcsICZyZWctPmluYm91bmRfbXNn
YWRkcjApOwotCQl3cml0ZWwoQVJDTVNSX0hCQ01VX0RSVjJJT1BfTUVTU0FHRV9DTURfRE9ORSwg
JnJlZy0+aW5ib3VuZF9kb29yYmVsbCk7Ci0JCW1vZF90aW1lcigmYWNiLT5ldGVybmFsX3RpbWVy
LCBqaWZmaWVzICsgbXNlY3NfdG9famlmZmllcyg2ICogSFopKTsKKwkJd3JpdGVsKEFSQ01TUl9J
TkJPVU5EX01FU0cwX0dFVF9DT05GSUcsCisJCQkmcmVnLT5pbmJvdW5kX21zZ2FkZHIwKTsKKwkJ
d3JpdGVsKEFSQ01TUl9IQkNNVV9EUlYySU9QX01FU1NBR0VfQ01EX0RPTkUsCisJCQkmcmVnLT5p
bmJvdW5kX2Rvb3JiZWxsKTsKKwkJbW9kX3RpbWVyKCZhY2ItPmV0ZXJuYWxfdGltZXIsIGppZmZp
ZXMgKworCQkJbXNlY3NfdG9famlmZmllcyg2ICogSFopKTsKKwl9Cit9CisKK3N0YXRpYyB2b2lk
CithcmNtc3JfaGJhRF9yZXF1ZXN0X2RldmljZV9tYXAoc3RydWN0IEFkYXB0ZXJDb250cm9sQmxv
Y2sgKmFjYikKK3sKKwlzdHJ1Y3QgTWVzc2FnZVVuaXRfRCBfX2lvbWVtICpyZWcgPSBhY2ItPnBt
dUQ7CisJaWYgKHVubGlrZWx5KGF0b21pY19yZWFkKCZhY2ItPnJxX21hcF90b2tlbikgPT0gMCkg
fHwKKwkJKChhY2ItPmFjYl9mbGFncyAmIEFDQl9GX0JVU19SRVNFVCkgIT0gMCkgfHwKKwkJKChh
Y2ItPmFjYl9mbGFncyAmIEFDQl9GX0FCT1JUKSAhPSAwKSkgeworCQltb2RfdGltZXIoJmFjYi0+
ZXRlcm5hbF90aW1lciwKKwkJCWppZmZpZXMgKyBtc2Vjc190b19qaWZmaWVzKDYgKiBIWikpOwor
CX0gZWxzZSB7CisJCWFjYi0+ZndfZmxhZyA9IEZXX05PUk1BTDsKKwkJaWYgKGF0b21pY19yZWFk
KCZhY2ItPmFudGVfdG9rZW5fdmFsdWUpID09CisJCQlhdG9taWNfcmVhZCgmYWNiLT5ycV9tYXBf
dG9rZW4pKSB7CisJCQlhdG9taWNfc2V0KCZhY2ItPnJxX21hcF90b2tlbiwgMTYpOworCQl9CisJ
CWF0b21pY19zZXQoJmFjYi0+YW50ZV90b2tlbl92YWx1ZSwKKwkJCWF0b21pY19yZWFkKCZhY2It
PnJxX21hcF90b2tlbikpOworCQlpZiAoYXRvbWljX2RlY19hbmRfdGVzdCgmYWNiLT5ycV9tYXBf
dG9rZW4pKSB7CisJCQltb2RfdGltZXIoJmFjYi0+ZXRlcm5hbF90aW1lciwgamlmZmllcyArCisJ
CQkJbXNlY3NfdG9famlmZmllcyg2ICogSFopKTsKKwkJCXJldHVybjsKKwkJfQorCQl3cml0ZWwo
QVJDTVNSX0lOQk9VTkRfTUVTRzBfR0VUX0NPTkZJRywKKwkJCXJlZy0+aW5ib3VuZF9tc2dhZGRy
MCk7CisJCW1vZF90aW1lcigmYWNiLT5ldGVybmFsX3RpbWVyLCBqaWZmaWVzICsKKwkJCW1zZWNz
X3RvX2ppZmZpZXMoNiAqIEhaKSk7CiAJfQotCXJldHVybjsKIH0KIAotc3RhdGljIHZvaWQgYXJj
bXNyX3JlcXVlc3RfZGV2aWNlX21hcCh1bnNpZ25lZCBsb25nIHBhY2IpCitzdGF0aWMgdm9pZAor
YXJjbXNyX3JlcXVlc3RfZGV2aWNlX21hcCh1bnNpZ25lZCBsb25nIHBhY2IpCiB7Ci0Jc3RydWN0
IEFkYXB0ZXJDb250cm9sQmxvY2sgKmFjYiA9IChzdHJ1Y3QgQWRhcHRlckNvbnRyb2xCbG9jayAq
KXBhY2I7CisJc3RydWN0IEFkYXB0ZXJDb250cm9sQmxvY2sgKmFjYiA9CisJCShzdHJ1Y3QgQWRh
cHRlckNvbnRyb2xCbG9jayAqKXBhY2I7CiAJc3dpdGNoIChhY2ItPmFkYXB0ZXJfdHlwZSkgewog
CQljYXNlIEFDQl9BREFQVEVSX1RZUEVfQTogewotCQkJYXJjbXNyX3JlcXVlc3RfaGJhX2Rldmlj
ZV9tYXAoYWNiKTsKKwkJCWFyY21zcl9oYmFBX3JlcXVlc3RfZGV2aWNlX21hcChhY2IpOworCQkJ
YnJlYWs7CiAJCX0KLQkJYnJlYWs7CiAJCWNhc2UgQUNCX0FEQVBURVJfVFlQRV9COiB7Ci0JCQlh
cmNtc3JfcmVxdWVzdF9oYmJfZGV2aWNlX21hcChhY2IpOworCQkJYXJjbXNyX2hiYUJfcmVxdWVz
dF9kZXZpY2VfbWFwKGFjYik7CisJCQlicmVhazsKIAkJfQotCQlicmVhazsKIAkJY2FzZSBBQ0Jf
QURBUFRFUl9UWVBFX0M6IHsKLQkJCWFyY21zcl9yZXF1ZXN0X2hiY19kZXZpY2VfbWFwKGFjYik7
CisJCQlhcmNtc3JfaGJhQ19yZXF1ZXN0X2RldmljZV9tYXAoYWNiKTsKKwkJCWJyZWFrOworCQl9
CisJCWNhc2UgQUNCX0FEQVBURVJfVFlQRV9EOiB7CisJCQlhcmNtc3JfaGJhRF9yZXF1ZXN0X2Rl
dmljZV9tYXAoYWNiKTsKKwkJCWJyZWFrOwogCQl9CiAJfQogfQogCi1zdGF0aWMgdm9pZCBhcmNt
c3Jfc3RhcnRfaGJhX2JncmIoc3RydWN0IEFkYXB0ZXJDb250cm9sQmxvY2sgKmFjYikKK3N0YXRp
YyB2b2lkCithcmNtc3JfaGJhQV9zdGFydF9iZ3JiKHN0cnVjdCBBZGFwdGVyQ29udHJvbEJsb2Nr
ICphY2IpCiB7CiAJc3RydWN0IE1lc3NhZ2VVbml0X0EgX19pb21lbSAqcmVnID0gYWNiLT5wbXVB
OwogCWFjYi0+YWNiX2ZsYWdzIHw9IEFDQl9GX01TR19TVEFSVF9CR1JCOwotCXdyaXRlbChBUkNN
U1JfSU5CT1VORF9NRVNHMF9TVEFSVF9CR1JCLCAmcmVnLT5pbmJvdW5kX21zZ2FkZHIwKTsKLQlp
ZiAoIWFyY21zcl9oYmFfd2FpdF9tc2dpbnRfcmVhZHkoYWNiKSkgewotCQlwcmludGsoS0VSTl9O
T1RJQ0UgImFyY21zciVkOiB3YWl0ICdzdGFydCBhZGFwdGVyIGJhY2tncm91bmQgXAotCQkJCXJl
YnVsaWQnIHRpbWVvdXQgXG4iLCBhY2ItPmhvc3QtPmhvc3Rfbm8pOworCXdyaXRlbChBUkNNU1Jf
SU5CT1VORF9NRVNHMF9TVEFSVF9CR1JCLAorCQkmcmVnLT5pbmJvdW5kX21zZ2FkZHIwKTsKKwlp
ZiAoIWFyY21zcl9oYmFBX3dhaXRfbXNnaW50X3JlYWR5KGFjYikpIHsKKwkJcHJfbm90aWNlKCJh
cmNtc3IlZDogd2FpdCAnc3RhcnQgYWRhcHRlciAiCisJCQkiYmFja2dyb3VuZCByZWJ1bGlkJyB0
aW1lb3V0XG4iLCBhY2ItPmhvc3QtPmhvc3Rfbm8pOwogCX0KIH0KIAotc3RhdGljIHZvaWQgYXJj
bXNyX3N0YXJ0X2hiYl9iZ3JiKHN0cnVjdCBBZGFwdGVyQ29udHJvbEJsb2NrICphY2IpCitzdGF0
aWMgdm9pZAorYXJjbXNyX2hiYUJfc3RhcnRfYmdyYihzdHJ1Y3QgQWRhcHRlckNvbnRyb2xCbG9j
ayAqYWNiKQogewotCXN0cnVjdCBNZXNzYWdlVW5pdF9CICpyZWcgPSBhY2ItPnBtdUI7CisJc3Ry
dWN0IE1lc3NhZ2VVbml0X0IgX19pb21lbSAqcmVnID0gYWNiLT5wbXVCOwogCWFjYi0+YWNiX2Zs
YWdzIHw9IEFDQl9GX01TR19TVEFSVF9CR1JCOwogCXdyaXRlbChBUkNNU1JfTUVTU0FHRV9TVEFS
VF9CR1JCLCByZWctPmRydjJpb3BfZG9vcmJlbGwpOwotCWlmICghYXJjbXNyX2hiYl93YWl0X21z
Z2ludF9yZWFkeShhY2IpKSB7Ci0JCXByaW50ayhLRVJOX05PVElDRSAiYXJjbXNyJWQ6IHdhaXQg
J3N0YXJ0IGFkYXB0ZXIgYmFja2dyb3VuZCBcCi0JCQkJcmVidWxpZCcgdGltZW91dCBcbiIsYWNi
LT5ob3N0LT5ob3N0X25vKTsKKwlpZiAoIWFyY21zcl9oYmFCX3dhaXRfbXNnaW50X3JlYWR5KGFj
YikpIHsKKwkJcHJfbm90aWNlKCJhcmNtc3IlZDogd2FpdCAnc3RhcnQgYWRhcHRlciAiCisJCQki
YmFja2dyb3VuZHJlYnVsaWQnIHRpbWVvdXRcbiIsIGFjYi0+aG9zdC0+aG9zdF9ubyk7CiAJfQog
fQogCi1zdGF0aWMgdm9pZCBhcmNtc3Jfc3RhcnRfaGJjX2JncmIoc3RydWN0IEFkYXB0ZXJDb250
cm9sQmxvY2sgKnBBQ0IpCitzdGF0aWMgdm9pZAorYXJjbXNyX2hiYUNfc3RhcnRfYmdyYihzdHJ1
Y3QgQWRhcHRlckNvbnRyb2xCbG9jayAqcEFDQikKIHsKLQlzdHJ1Y3QgTWVzc2FnZVVuaXRfQyAq
cGhiY211ID0gKHN0cnVjdCBNZXNzYWdlVW5pdF9DICopcEFDQi0+cG11QzsKKwlzdHJ1Y3QgTWVz
c2FnZVVuaXRfQyBfX2lvbWVtICpwaGJjbXUgPSBwQUNCLT5wbXVDOwogCXBBQ0ItPmFjYl9mbGFn
cyB8PSBBQ0JfRl9NU0dfU1RBUlRfQkdSQjsKLQl3cml0ZWwoQVJDTVNSX0lOQk9VTkRfTUVTRzBf
U1RBUlRfQkdSQiwgJnBoYmNtdS0+aW5ib3VuZF9tc2dhZGRyMCk7Ci0Jd3JpdGVsKEFSQ01TUl9I
QkNNVV9EUlYySU9QX01FU1NBR0VfQ01EX0RPTkUsICZwaGJjbXUtPmluYm91bmRfZG9vcmJlbGwp
OwotCWlmICghYXJjbXNyX2hiY193YWl0X21zZ2ludF9yZWFkeShwQUNCKSkgewotCQlwcmludGso
S0VSTl9OT1RJQ0UgImFyY21zciVkOiB3YWl0ICdzdGFydCBhZGFwdGVyIGJhY2tncm91bmQgXAot
CQkJCXJlYnVsaWQnIHRpbWVvdXQgXG4iLCBwQUNCLT5ob3N0LT5ob3N0X25vKTsKKwl3cml0ZWwo
QVJDTVNSX0lOQk9VTkRfTUVTRzBfU1RBUlRfQkdSQiwKKwkJJnBoYmNtdS0+aW5ib3VuZF9tc2dh
ZGRyMCk7CisJd3JpdGVsKEFSQ01TUl9IQkNNVV9EUlYySU9QX01FU1NBR0VfQ01EX0RPTkUsCisJ
CSZwaGJjbXUtPmluYm91bmRfZG9vcmJlbGwpOworCWlmICghYXJjbXNyX2hiYUNfd2FpdF9tc2dp
bnRfcmVhZHkocEFDQikpIHsKKwkJcHJfbm90aWNlKCJhcmNtc3IlZDogd2FpdCAnc3RhcnQgYWRh
cHRlciAiCisJCQkiYmFja2dyb3VuZCByZWJ1bGlkJyB0aW1lb3V0XG4iLCBwQUNCLT5ob3N0LT5o
b3N0X25vKTsKIAl9CiAJcmV0dXJuOwogfQotc3RhdGljIHZvaWQgYXJjbXNyX3N0YXJ0X2FkYXB0
ZXJfYmdyYihzdHJ1Y3QgQWRhcHRlckNvbnRyb2xCbG9jayAqYWNiKQorCitzdGF0aWMgdm9pZAor
YXJjbXNyX2hiYURfc3RhcnRfYmdyYihzdHJ1Y3QgQWRhcHRlckNvbnRyb2xCbG9jayAqcEFDQikK
K3sKKwlzdHJ1Y3QgTWVzc2FnZVVuaXRfRCBfX2lvbWVtICpwbXUgPSBwQUNCLT5wbXVEOworCXBB
Q0ItPmFjYl9mbGFncyB8PSBBQ0JfRl9NU0dfU1RBUlRfQkdSQjsKKwl3cml0ZWwoQVJDTVNSX0lO
Qk9VTkRfTUVTRzBfU1RBUlRfQkdSQiwgcG11LT5pbmJvdW5kX21zZ2FkZHIwKTsKKwlpZiAoIWFy
Y21zcl9oYmFEX3dhaXRfbXNnaW50X3JlYWR5KHBBQ0IpKSB7CisJCXByX25vdGljZSgiYXJjbXNy
JWQ6IHdhaXQgJ3N0YXJ0IGFkYXB0ZXIgIgorCQkJImJhY2tncm91bmQgcmVidWxpZCcgdGltZW91
dFxuIiwgcEFDQi0+aG9zdC0+aG9zdF9ubyk7CisJfQorCXJldHVybjsKK30KKworc3RhdGljIHZv
aWQKK2FyY21zcl9zdGFydF9hZGFwdGVyX2JncmIoc3RydWN0IEFkYXB0ZXJDb250cm9sQmxvY2sg
KmFjYikKIHsKIAlzd2l0Y2ggKGFjYi0+YWRhcHRlcl90eXBlKSB7CiAJY2FzZSBBQ0JfQURBUFRF
Ul9UWVBFX0E6Ci0JCWFyY21zcl9zdGFydF9oYmFfYmdyYihhY2IpOworCQlhcmNtc3JfaGJhQV9z
dGFydF9iZ3JiKGFjYik7CiAJCWJyZWFrOwogCWNhc2UgQUNCX0FEQVBURVJfVFlQRV9COgotCQlh
cmNtc3Jfc3RhcnRfaGJiX2JncmIoYWNiKTsKKwkJYXJjbXNyX2hiYUJfc3RhcnRfYmdyYihhY2Ip
OwogCQlicmVhazsKIAljYXNlIEFDQl9BREFQVEVSX1RZUEVfQzoKLQkJYXJjbXNyX3N0YXJ0X2hi
Y19iZ3JiKGFjYik7CisJCWFyY21zcl9oYmFDX3N0YXJ0X2JncmIoYWNiKTsKKwkJYnJlYWs7CisJ
Y2FzZSBBQ0JfQURBUFRFUl9UWVBFX0Q6CisJCWFyY21zcl9oYmFEX3N0YXJ0X2JncmIoYWNiKTsK
KwkJYnJlYWs7CiAJfQogfQogCi1zdGF0aWMgdm9pZCBhcmNtc3JfY2xlYXJfZG9vcmJlbGxfcXVl
dWVfYnVmZmVyKHN0cnVjdCBBZGFwdGVyQ29udHJvbEJsb2NrICphY2IpCitzdGF0aWMgdm9pZAor
YXJjbXNyX2NsZWFyX2Rvb3JiZWxsX3F1ZXVlX2J1ZmZlcihzdHJ1Y3QgQWRhcHRlckNvbnRyb2xC
bG9jayAqYWNiKQogewogCXN3aXRjaCAoYWNiLT5hZGFwdGVyX3R5cGUpIHsKIAljYXNlIEFDQl9B
REFQVEVSX1RZUEVfQTogewpAQCAtMjc3MSw2NSArNDExMywxMDcgQEAgc3RhdGljIHZvaWQgYXJj
bXNyX2NsZWFyX2Rvb3JiZWxsX3F1ZXVlXwogCQlvdXRib3VuZF9kb29yYmVsbCA9IHJlYWRsKCZy
ZWctPm91dGJvdW5kX2Rvb3JiZWxsKTsKIAkJLypjbGVhciBkb29yYmVsbCBpbnRlcnJ1cHQgKi8K
IAkJd3JpdGVsKG91dGJvdW5kX2Rvb3JiZWxsLCAmcmVnLT5vdXRib3VuZF9kb29yYmVsbCk7Ci0J
CXdyaXRlbChBUkNNU1JfSU5CT1VORF9EUklWRVJfREFUQV9SRUFEX09LLCAmcmVnLT5pbmJvdW5k
X2Rvb3JiZWxsKTsKKwkJd3JpdGVsKEFSQ01TUl9JTkJPVU5EX0RSSVZFUl9EQVRBX1JFQURfT0ss
CisJCQkmcmVnLT5pbmJvdW5kX2Rvb3JiZWxsKTsKIAkJfQogCQlicmVhazsKIAogCWNhc2UgQUNC
X0FEQVBURVJfVFlQRV9COiB7Ci0JCXN0cnVjdCBNZXNzYWdlVW5pdF9CICpyZWcgPSBhY2ItPnBt
dUI7CisJCXN0cnVjdCBNZXNzYWdlVW5pdF9CIF9faW9tZW0gKnJlZyA9IGFjYi0+cG11QjsKIAkJ
LypjbGVhciBpbnRlcnJ1cHQgYW5kIG1lc3NhZ2Ugc3RhdGUqLwotCQl3cml0ZWwoQVJDTVNSX01F
U1NBR0VfSU5UX0NMRUFSX1BBVFRFUk4sIHJlZy0+aW9wMmRydl9kb29yYmVsbCk7Ci0JCXdyaXRl
bChBUkNNU1JfRFJWMklPUF9EQVRBX1JFQURfT0ssIHJlZy0+ZHJ2MmlvcF9kb29yYmVsbCk7CisJ
CXdyaXRlbChBUkNNU1JfTUVTU0FHRV9JTlRfQ0xFQVJfUEFUVEVSTiwKKwkJCXJlZy0+aW9wMmRy
dl9kb29yYmVsbCk7CisJCXdyaXRlbChBUkNNU1JfRFJWMklPUF9EQVRBX1JFQURfT0ssCisJCQly
ZWctPmRydjJpb3BfZG9vcmJlbGwpOwogCQkvKiBsZXQgSU9QIGtub3cgZGF0YSBoYXMgYmVlbiBy
ZWFkICovCiAJCX0KIAkJYnJlYWs7CiAJY2FzZSBBQ0JfQURBUFRFUl9UWVBFX0M6IHsKLQkJc3Ry
dWN0IE1lc3NhZ2VVbml0X0MgKnJlZyA9IChzdHJ1Y3QgTWVzc2FnZVVuaXRfQyAqKWFjYi0+cG11
QzsKLQkJdWludDMyX3Qgb3V0Ym91bmRfZG9vcmJlbGw7CisJCXN0cnVjdCBNZXNzYWdlVW5pdF9D
IF9faW9tZW0gKnJlZyA9IGFjYi0+cG11QzsKKwkJdWludDMyX3Qgb3V0Ym91bmRfZG9vcmJlbGws
IGk7CiAJCS8qIGVtcHR5IGRvb3JiZWxsIFFidWZmZXIgaWYgZG9vciBiZWxsIHJpbmdlZCAqLwog
CQlvdXRib3VuZF9kb29yYmVsbCA9IHJlYWRsKCZyZWctPm91dGJvdW5kX2Rvb3JiZWxsKTsKIAkJ
d3JpdGVsKG91dGJvdW5kX2Rvb3JiZWxsLCAmcmVnLT5vdXRib3VuZF9kb29yYmVsbF9jbGVhcik7
Ci0JCXdyaXRlbChBUkNNU1JfSEJDTVVfRFJWMklPUF9EQVRBX1JFQURfT0ssICZyZWctPmluYm91
bmRfZG9vcmJlbGwpOworCQl3cml0ZWwoQVJDTVNSX0hCQ01VX0RSVjJJT1BfREFUQV9SRUFEX09L
LAorCQkJJnJlZy0+aW5ib3VuZF9kb29yYmVsbCk7CisJCWZvciAoaSA9IDA7IGkgPCAyMDA7IGkr
KykgeworCQkJbXNsZWVwKDIwKTsKKwkJCW91dGJvdW5kX2Rvb3JiZWxsID0gcmVhZGwoJnJlZy0+
b3V0Ym91bmRfZG9vcmJlbGwpOworCQkJaWYgKG91dGJvdW5kX2Rvb3JiZWxsICYgQVJDTVNSX0hC
Q01VX0lPUDJEUlZfREFUQV9XUklURV9PSykgeworCQkJCXdyaXRlbChvdXRib3VuZF9kb29yYmVs
bCwKKwkJCQkJJnJlZy0+b3V0Ym91bmRfZG9vcmJlbGxfY2xlYXIpOworCQkJCXdyaXRlbChBUkNN
U1JfSEJDTVVfRFJWMklPUF9EQVRBX1JFQURfT0ssCisJCQkJCSZyZWctPmluYm91bmRfZG9vcmJl
bGwpOworCQkJfSBlbHNlCisJCQkJYnJlYWs7CisJCX0KKwkJfQorCQlicmVhazsKKwljYXNlIEFD
Ql9BREFQVEVSX1RZUEVfRDogeworCQlzdHJ1Y3QgTWVzc2FnZVVuaXRfRCBfX2lvbWVtICpyZWcg
PSBhY2ItPnBtdUQ7CisJCXVpbnQzMl90IG91dGJvdW5kX2Rvb3JiZWxsLCBpOworCQkvKiBlbXB0
eSBkb29yYmVsbCBRYnVmZmVyIGlmIGRvb3IgYmVsbCByaW5nZWQgKi8KKwkJb3V0Ym91bmRfZG9v
cmJlbGwgPSByZWFkbChyZWctPm91dGJvdW5kX2Rvb3JiZWxsKTsKKwkJd3JpdGVsKG91dGJvdW5k
X2Rvb3JiZWxsLCByZWctPm91dGJvdW5kX2Rvb3JiZWxsKTsKKwkJd3JpdGVsKEFSQ01TUl9BUkMx
MjE0X0RSVjJJT1BfREFUQV9PVVRfUkVBRCwKKwkJCXJlZy0+aW5ib3VuZF9kb29yYmVsbCk7CisJ
CWZvciAoaSA9IDA7IGkgPCAyMDA7IGkrKykgeworCQkJbXNsZWVwKDIwKTsKKwkJCW91dGJvdW5k
X2Rvb3JiZWxsID0gcmVhZGwocmVnLT5vdXRib3VuZF9kb29yYmVsbCk7CisJCQlpZiAob3V0Ym91
bmRfZG9vcmJlbGwgJiBBUkNNU1JfQVJDMTIxNF9JT1AyRFJWX0RBVEFfV1JJVEVfT0spIHsKKwkJ
CQl3cml0ZWwob3V0Ym91bmRfZG9vcmJlbGwsCisJCQkJCXJlZy0+b3V0Ym91bmRfZG9vcmJlbGwp
OworCQkJCXdyaXRlbChBUkNNU1JfQVJDMTIxNF9EUlYySU9QX0RBVEFfT1VUX1JFQUQsCisJCQkJ
CXJlZy0+aW5ib3VuZF9kb29yYmVsbCk7CisJCQl9IGVsc2UKKwkJCQlicmVhazsKIAkJfQorCQli
cmVhazsKKwl9CiAJfQogfQogCi1zdGF0aWMgdm9pZCBhcmNtc3JfZW5hYmxlX2VvaV9tb2RlKHN0
cnVjdCBBZGFwdGVyQ29udHJvbEJsb2NrICphY2IpCitzdGF0aWMgdm9pZAorYXJjbXNyX2VuYWJs
ZV9lb2lfbW9kZShzdHJ1Y3QgQWRhcHRlckNvbnRyb2xCbG9jayAqYWNiKQogewogCXN3aXRjaCAo
YWNiLT5hZGFwdGVyX3R5cGUpIHsKIAljYXNlIEFDQl9BREFQVEVSX1RZUEVfQToKKwljYXNlIEFD
Ql9BREFQVEVSX1RZUEVfQzoKKwljYXNlIEFDQl9BREFQVEVSX1RZUEVfRDoKIAkJcmV0dXJuOwot
CWNhc2UgQUNCX0FEQVBURVJfVFlQRV9COgotCQl7Ci0JCQlzdHJ1Y3QgTWVzc2FnZVVuaXRfQiAq
cmVnID0gYWNiLT5wbXVCOwotCQkJd3JpdGVsKEFSQ01TUl9NRVNTQUdFX0FDVElWRV9FT0lfTU9E
RSwgcmVnLT5kcnYyaW9wX2Rvb3JiZWxsKTsKLQkJCWlmICghYXJjbXNyX2hiYl93YWl0X21zZ2lu
dF9yZWFkeShhY2IpKSB7Ci0JCQkJcHJpbnRrKEtFUk5fTk9USUNFICJBUkNNU1IgSU9QIGVuYWJs
ZXMgRU9JX01PREUgVElNRU9VVCIpOworCWNhc2UgQUNCX0FEQVBURVJfVFlQRV9COiB7CisJCXN0
cnVjdCBNZXNzYWdlVW5pdF9CIF9faW9tZW0gKnJlZyA9IGFjYi0+cG11QjsKKwkJCXdyaXRlbChB
UkNNU1JfTUVTU0FHRV9BQ1RJVkVfRU9JX01PREUsCisJCQkJcmVnLT5kcnYyaW9wX2Rvb3JiZWxs
KTsKKwkJCWlmICghYXJjbXNyX2hiYUJfd2FpdF9tc2dpbnRfcmVhZHkoYWNiKSkgeworCQkJCXBy
X25vdGljZSgiQVJDTVNSIElPUCAiCisJCQkJCSJlbmFibGVzIEVPSV9NT0RFIFRJTUVPVVQiKTsK
IAkJCQlyZXR1cm47CiAJCQl9Ci0JCX0KLQkJYnJlYWs7Ci0JY2FzZSBBQ0JfQURBUFRFUl9UWVBF
X0M6Ci0JCXJldHVybjsKKwl9CisJYnJlYWs7CiAJfQogCXJldHVybjsKIH0KIAotc3RhdGljIHZv
aWQgYXJjbXNyX2hhcmR3YXJlX3Jlc2V0KHN0cnVjdCBBZGFwdGVyQ29udHJvbEJsb2NrICphY2Ip
CitzdGF0aWMgdm9pZAorYXJjbXNyX2hhcmR3YXJlX3Jlc2V0KHN0cnVjdCBBZGFwdGVyQ29udHJv
bEJsb2NrICphY2IpCiB7CiAJdWludDhfdCB2YWx1ZVs2NF07CiAJaW50IGksIGNvdW50ID0gMDsK
IAlzdHJ1Y3QgTWVzc2FnZVVuaXRfQSBfX2lvbWVtICpwbXVBID0gYWNiLT5wbXVBOwogCXN0cnVj
dCBNZXNzYWdlVW5pdF9DIF9faW9tZW0gKnBtdUMgPSBhY2ItPnBtdUM7Ci0KKwl1MzIgdGVtcCA9
IDA7CiAJLyogYmFja3VwIHBjaSBjb25maWcgZGF0YSAqLwotCXByaW50ayhLRVJOX05PVElDRSAi
YXJjbXNyJWQ6IGV4ZWN1dGluZyBodyBidXMgcmVzZXQgLi4uLi5cbiIsIGFjYi0+aG9zdC0+aG9z
dF9ubyk7CisJcHJfbm90aWNlKCJhcmNtc3IlZDogZXhlY3V0aW5nIGh3IGJ1cyByZXNldCAuLi4u
LlxuIiwKKwlhY2ItPmhvc3QtPmhvc3Rfbm8pOwogCWZvciAoaSA9IDA7IGkgPCA2NDsgaSsrKSB7
CiAJCXBjaV9yZWFkX2NvbmZpZ19ieXRlKGFjYi0+cGRldiwgaSwgJnZhbHVlW2ldKTsKIAl9CiAJ
LyogaGFyZHdhcmUgcmVzZXQgc2lnbmFsICovCiAJaWYgKChhY2ItPmRldl9pZCA9PSAweDE2ODAp
KSB7Ci0JCXdyaXRlbChBUkNNU1JfQVJDMTY4MF9CVVNfUkVTRVQsICZwbXVBLT5yZXNlcnZlZDFb
MF0pOworCQl3cml0ZWwoQVJDTVNSX0FSQzE2ODBfQlVTX1JFU0VULAorCQkJJnBtdUEtPnJlc2Vy
dmVkMVswXSk7CiAJfSBlbHNlIGlmICgoYWNiLT5kZXZfaWQgPT0gMHgxODgwKSkgewogCQlkbyB7
CiAJCQljb3VudCsrOwpAQCAtMjgzOSw4ICs0MjIzLDExIEBAIHN0YXRpYyB2b2lkIGFyY21zcl9o
YXJkd2FyZV9yZXNldChzdHJ1Y3QKIAkJCXdyaXRlbCgweDIsICZwbXVDLT53cml0ZV9zZXF1ZW5j
ZSk7CiAJCQl3cml0ZWwoMHg3LCAmcG11Qy0+d3JpdGVfc2VxdWVuY2UpOwogCQkJd3JpdGVsKDB4
RCwgJnBtdUMtPndyaXRlX3NlcXVlbmNlKTsKLQkJfSB3aGlsZSAoKChyZWFkbCgmcG11Qy0+aG9z
dF9kaWFnbm9zdGljKSAmIEFSQ01TUl9BUkMxODgwX0RpYWdXcml0ZV9FTkFCTEUpID09IDApICYm
IChjb3VudCA8IDUpKTsKLQkJd3JpdGVsKEFSQ01TUl9BUkMxODgwX1JFU0VUX0FEQVBURVIsICZw
bXVDLT5ob3N0X2RpYWdub3N0aWMpOworCQl9IHdoaWxlICgoKCh0ZW1wID0gcmVhZGwoJnBtdUMt
Pmhvc3RfZGlhZ25vc3RpYykpICYKKwkJCUFSQ01TUl9BUkMxODgwX0RpYWdXcml0ZV9FTkFCTEUp
ID09IDApICYmCisJCQkoY291bnQgPCA1KSk7CisJCXdyaXRlbChBUkNNU1JfQVJDMTg4MF9SRVNF
VF9BREFQVEVSLAorCQkJJnBtdUMtPmhvc3RfZGlhZ25vc3RpYyk7CiAJfSBlbHNlIHsKIAkJcGNp
X3dyaXRlX2NvbmZpZ19ieXRlKGFjYi0+cGRldiwgMHg4NCwgMHgyMCk7CiAJfQpAQCAtMjg1Miw3
ICs0MjM5LDkgQEAgc3RhdGljIHZvaWQgYXJjbXNyX2hhcmR3YXJlX3Jlc2V0KHN0cnVjdAogCW1z
bGVlcCgxMDAwKTsKIAlyZXR1cm47CiB9Ci1zdGF0aWMgdm9pZCBhcmNtc3JfaW9wX2luaXQoc3Ry
dWN0IEFkYXB0ZXJDb250cm9sQmxvY2sgKmFjYikKKworc3RhdGljIHZvaWQKK2FyY21zcl9pb3Bf
aW5pdChzdHJ1Y3QgQWRhcHRlckNvbnRyb2xCbG9jayAqYWNiKQogewogCXVpbnQzMl90IGludG1h
c2tfb3JnOwogCS8qIGRpc2FibGUgYWxsIG91dGJvdW5kIGludGVycnVwdCAqLwpAQCAtMjg2OSw3
ICs0MjU4LDggQEAgc3RhdGljIHZvaWQgYXJjbXNyX2lvcF9pbml0KHN0cnVjdCBBZGFwdAogCWFj
Yi0+YWNiX2ZsYWdzIHw9IEFDQl9GX0lPUF9JTklURUQ7CiB9CiAKLXN0YXRpYyB1aW50OF90IGFy
Y21zcl9pb3BfcmVzZXQoc3RydWN0IEFkYXB0ZXJDb250cm9sQmxvY2sgKmFjYikKK3N0YXRpYyB1
aW50OF90CithcmNtc3JfaW9wX3Jlc2V0KHN0cnVjdCBBZGFwdGVyQ29udHJvbEJsb2NrICphY2Ip
CiB7CiAJc3RydWN0IENvbW1hbmRDb250cm9sQmxvY2sgKmNjYjsKIAl1aW50MzJfdCBpbnRtYXNr
X29yZzsKQEAgLTI4OTIsNyArNDI4Miw4IEBAIHN0YXRpYyB1aW50OF90IGFyY21zcl9pb3BfcmVz
ZXQoc3RydWN0IEEKIAkJCQljY2ItPmNjYl9mbGFncyA9IDA7CiAJCQkJc3Bpbl9sb2NrX2lycXNh
dmUoJmFjYi0+Y2NibGlzdF9sb2NrLCBmbGFncyk7CiAJCQkJbGlzdF9hZGRfdGFpbCgmY2NiLT5s
aXN0LCAmYWNiLT5jY2JfZnJlZV9saXN0KTsKLQkJCQlzcGluX3VubG9ja19pcnFyZXN0b3JlKCZh
Y2ItPmNjYmxpc3RfbG9jaywgZmxhZ3MpOworCQkJCXNwaW5fdW5sb2NrX2lycXJlc3RvcmUoJmFj
Yi0+Y2NibGlzdF9sb2NrLAorCQkJCQlmbGFncyk7CiAJCQl9CiAJCX0KIAkJYXRvbWljX3NldCgm
YWNiLT5jY2JvdXRzdGFuZGluZ2NvdW50LCAwKTsKQEAgLTI5MDMsMTQ3ICs0Mjk0LDIzNSBAQCBz
dGF0aWMgdWludDhfdCBhcmNtc3JfaW9wX3Jlc2V0KHN0cnVjdCBBCiAJcmV0dXJuIHJ0bnZhbDsK
IH0KIAotc3RhdGljIGludCBhcmNtc3JfYnVzX3Jlc2V0KHN0cnVjdCBzY3NpX2NtbmQgKmNtZCkK
K3N0YXRpYyBpbnQKK2FyY21zcl9idXNfcmVzZXQoc3RydWN0IHNjc2lfY21uZCAqY21kKQogewog
CXN0cnVjdCBBZGFwdGVyQ29udHJvbEJsb2NrICphY2I7CiAJdWludDMyX3QgaW50bWFza19vcmcs
IG91dGJvdW5kX2Rvb3JiZWxsOwogCWludCByZXRyeV9jb3VudCA9IDA7CiAJaW50IHJ0biA9IEZB
SUxFRDsKIAlhY2IgPSAoc3RydWN0IEFkYXB0ZXJDb250cm9sQmxvY2sgKikgY21kLT5kZXZpY2Ut
Pmhvc3QtPmhvc3RkYXRhOwotCXByaW50ayhLRVJOX0VSUiAiYXJjbXNyOiBleGVjdXRpbmcgYnVz
IHJlc2V0IGVoLi4uLi5udW1fcmVzZXRzID0gJWQsIG51bV9hYm9ydHMgPSAlZCBcbiIsIGFjYi0+
bnVtX3Jlc2V0cywgYWNiLT5udW1fYWJvcnRzKTsKKwlwcl9lcnIoImFyY21zcjogZXhlY3V0aW5n
IGJ1cyByZXNldCBlaC4uLi4ubnVtX3Jlc2V0cyA9ICVkLCAiCisJCSJudW1fYWJvcnRzID0gJWRc
biIsIGFjYi0+bnVtX3Jlc2V0cywgYWNiLT5udW1fYWJvcnRzKTsKIAlhY2ItPm51bV9yZXNldHMr
KzsKIAotCXN3aXRjaChhY2ItPmFkYXB0ZXJfdHlwZSl7Ci0JCWNhc2UgQUNCX0FEQVBURVJfVFlQ
RV9BOnsKLQkJCWlmIChhY2ItPmFjYl9mbGFncyAmIEFDQl9GX0JVU19SRVNFVCl7Ci0JCQkJbG9u
ZyB0aW1lb3V0OwotCQkJCXByaW50ayhLRVJOX0VSUiAiYXJjbXNyOiB0aGVyZSBpcyBhbiAgYnVz
IHJlc2V0IGVoIHByb2NlZWRpbmcuLi4uLi4uXG4iKTsKLQkJCQl0aW1lb3V0ID0gd2FpdF9ldmVu
dF90aW1lb3V0KHdhaXRfcSwgKGFjYi0+YWNiX2ZsYWdzICYgQUNCX0ZfQlVTX1JFU0VUKSA9PSAw
LCAyMjAqSFopOwotCQkJCWlmICh0aW1lb3V0KSB7Ci0JCQkJCXJldHVybiBTVUNDRVNTOwotCQkJ
CX0KLQkJCX0KLQkJCWFjYi0+YWNiX2ZsYWdzIHw9IEFDQl9GX0JVU19SRVNFVDsKLQkJCWlmICgh
YXJjbXNyX2lvcF9yZXNldChhY2IpKSB7Ci0JCQkJc3RydWN0IE1lc3NhZ2VVbml0X0EgX19pb21l
bSAqcmVnOwotCQkJCXJlZyA9IGFjYi0+cG11QTsKLQkJCQlhcmNtc3JfaGFyZHdhcmVfcmVzZXQo
YWNiKTsKLQkJCQlhY2ItPmFjYl9mbGFncyAmPSB+QUNCX0ZfSU9QX0lOSVRFRDsKKwlzd2l0Y2gg
KGFjYi0+YWRhcHRlcl90eXBlKSB7CisJY2FzZSBBQ0JfQURBUFRFUl9UWVBFX0E6IHsKKwkJaWYg
KGFjYi0+YWNiX2ZsYWdzICYgQUNCX0ZfQlVTX1JFU0VUKSB7CisJCQlsb25nIHRpbWVvdXQ7CisJ
CQlwcl9lcnIoImFyY21zcjogdGhlcmUgaXMgYW4gYnVzICIKKwkJCQkicmVzZXQgZWggcHJvY2Vl
ZGluZy4uLi4uLi5cbiIpOworCQkJdGltZW91dCA9IHdhaXRfZXZlbnRfdGltZW91dCh3YWl0X3Es
CisJCQkJKGFjYi0+YWNiX2ZsYWdzICYgQUNCX0ZfQlVTX1JFU0VUKQorCQkJCT09IDAsIDIyMCAq
IEhaKTsKKwkJCWlmICh0aW1lb3V0KQorCQkJCXJldHVybiBTVUNDRVNTOworCQl9CisJCWFjYi0+
YWNiX2ZsYWdzIHw9IEFDQl9GX0JVU19SRVNFVDsKKwkJaWYgKCFhcmNtc3JfaW9wX3Jlc2V0KGFj
YikpIHsKKwkJCXN0cnVjdCBNZXNzYWdlVW5pdF9BIF9faW9tZW0gKnJlZzsKKwkJCXJlZyA9IGFj
Yi0+cG11QTsKKwkJCWFyY21zcl9oYXJkd2FyZV9yZXNldChhY2IpOworCQkJYWNiLT5hY2JfZmxh
Z3MgJj0gfkFDQl9GX0lPUF9JTklURUQ7CiBzbGVlcF9hZ2FpbjoKLQkJCQlzc2xlZXAoQVJDTVNS
X1NMRUVQVElNRSk7Ci0JCQkJaWYgKChyZWFkbCgmcmVnLT5vdXRib3VuZF9tc2dhZGRyMSkgJiBB
UkNNU1JfT1VUQk9VTkRfTUVTRzFfRklSTVdBUkVfT0spID09IDApIHsKLQkJCQkJcHJpbnRrKEtF
Uk5fRVJSICJhcmNtc3IlZDogd2FpdGluZyBmb3IgaHcgYnVzIHJlc2V0IHJldHVybiwgcmV0cnk9
JWRcbiIsIGFjYi0+aG9zdC0+aG9zdF9ubywgcmV0cnlfY291bnQpOwotCQkJCQlpZiAocmV0cnlf
Y291bnQgPiBBUkNNU1JfUkVUUllDT1VOVCkgewotCQkJCQkJYWNiLT5md19mbGFnID0gRldfREVB
RExPQ0s7Ci0JCQkJCQlwcmludGsoS0VSTl9FUlIgImFyY21zciVkOiB3YWl0aW5nIGZvciBodyBi
dXMgcmVzZXQgcmV0dXJuLCBSRVRSWSBURVJNSU5BVEVEISFcbiIsIGFjYi0+aG9zdC0+aG9zdF9u
byk7Ci0JCQkJCQlyZXR1cm4gRkFJTEVEOwotCQkJCQl9Ci0JCQkJCXJldHJ5X2NvdW50Kys7Ci0J
CQkJCWdvdG8gc2xlZXBfYWdhaW47CisJCQlzc2xlZXAoQVJDTVNSX1NMRUVQVElNRSk7CisJCQlp
ZiAoKHJlYWRsKCZyZWctPm91dGJvdW5kX21zZ2FkZHIxKSAmCisJCQkJQVJDTVNSX09VVEJPVU5E
X01FU0cxX0ZJUk1XQVJFX09LKSA9PSAwKSB7CisJCQkJcHJfZXJyKCJhcmNtc3IlZDogd2FpdGlu
ZyBmb3IgIgorCQkJCQkiaHcgYnVzIHJlc2V0IHJldHVybiwgcmV0cnkgPSAlZFxuIiwKKwkJCQkJ
YWNiLT5ob3N0LT5ob3N0X25vLCByZXRyeV9jb3VudCk7CisJCQkJaWYgKHJldHJ5X2NvdW50ID4g
QVJDTVNSX1JFVFJZQ09VTlQpIHsKKwkJCQkJYWNiLT5md19mbGFnID0gRldfREVBRExPQ0s7CisJ
CQkJCXByX2VycigiYXJjbXNyJWQ6IHdhaXRpbmcgIgorCQkJCQkJImZvciBodyBidXMgcmVzZXQg
cmV0dXJuLCAiCisJCQkJCQkiUkVUUlkgVEVSTUlOQVRFRCEhXG4iLAorCQkJCQkJYWNiLT5ob3N0
LT5ob3N0X25vKTsKKwkJCQkJcmV0dXJuIEZBSUxFRDsKIAkJCQl9Ci0JCQkJYWNiLT5hY2JfZmxh
Z3MgfD0gQUNCX0ZfSU9QX0lOSVRFRDsKLQkJCQkvKiBkaXNhYmxlIGFsbCBvdXRib3VuZCBpbnRl
cnJ1cHQgKi8KLQkJCQlpbnRtYXNrX29yZyA9IGFyY21zcl9kaXNhYmxlX291dGJvdW5kX2ludHMo
YWNiKTsKLQkJCQlhcmNtc3JfZ2V0X2Zpcm13YXJlX3NwZWMoYWNiKTsKLQkJCQlhcmNtc3Jfc3Rh
cnRfYWRhcHRlcl9iZ3JiKGFjYik7Ci0JCQkJLyogY2xlYXIgUWJ1ZmZlciBpZiBkb29yIGJlbGwg
cmluZ2VkICovCi0JCQkJb3V0Ym91bmRfZG9vcmJlbGwgPSByZWFkbCgmcmVnLT5vdXRib3VuZF9k
b29yYmVsbCk7Ci0JCQkJd3JpdGVsKG91dGJvdW5kX2Rvb3JiZWxsLCAmcmVnLT5vdXRib3VuZF9k
b29yYmVsbCk7IC8qY2xlYXIgaW50ZXJydXB0ICovCi0gICAJCQkJd3JpdGVsKEFSQ01TUl9JTkJP
VU5EX0RSSVZFUl9EQVRBX1JFQURfT0ssICZyZWctPmluYm91bmRfZG9vcmJlbGwpOwotCQkJCS8q
IGVuYWJsZSBvdXRib3VuZCBQb3N0IFF1ZXVlLG91dGJvdW5kIGRvb3JiZWxsIEludGVycnVwdCAq
LwotCQkJCWFyY21zcl9lbmFibGVfb3V0Ym91bmRfaW50cyhhY2IsIGludG1hc2tfb3JnKTsKLQkJ
CQlhdG9taWNfc2V0KCZhY2ItPnJxX21hcF90b2tlbiwgMTYpOwotCQkJCWF0b21pY19zZXQoJmFj
Yi0+YW50ZV90b2tlbl92YWx1ZSwgMTYpOwotCQkJCWFjYi0+ZndfZmxhZyA9IEZXX05PUk1BTDsK
LQkJCQltb2RfdGltZXIoJmFjYi0+ZXRlcm5hbF90aW1lciwgamlmZmllcyArIG1zZWNzX3RvX2pp
ZmZpZXMoNiAqIEhaKSk7Ci0JCQkJYWNiLT5hY2JfZmxhZ3MgJj0gfkFDQl9GX0JVU19SRVNFVDsK
LQkJCQlydG4gPSBTVUNDRVNTOwotCQkJCXByaW50ayhLRVJOX0VSUiAiYXJjbXNyOiBzY3NpICBi
dXMgcmVzZXQgZWggcmV0dXJucyB3aXRoIHN1Y2Nlc3NcbiIpOwotCQkJfSBlbHNlIHsKLQkJCQlh
Y2ItPmFjYl9mbGFncyAmPSB+QUNCX0ZfQlVTX1JFU0VUOwotCQkJCWF0b21pY19zZXQoJmFjYi0+
cnFfbWFwX3Rva2VuLCAxNik7Ci0JCQkJYXRvbWljX3NldCgmYWNiLT5hbnRlX3Rva2VuX3ZhbHVl
LCAxNik7Ci0JCQkJYWNiLT5md19mbGFnID0gRldfTk9STUFMOwotCQkJCW1vZF90aW1lcigmYWNi
LT5ldGVybmFsX3RpbWVyLCBqaWZmaWVzICsgbXNlY3NfdG9famlmZmllcyg2KkhaKSk7Ci0JCQkJ
cnRuID0gU1VDQ0VTUzsKKwkJCQlyZXRyeV9jb3VudCsrOworCQkJCWdvdG8gc2xlZXBfYWdhaW47
CiAJCQl9Ci0JCQlicmVhazsKKwkJCWFjYi0+YWNiX2ZsYWdzIHw9IEFDQl9GX0lPUF9JTklURUQ7
CisJCQkvKiBkaXNhYmxlIGFsbCBvdXRib3VuZCBpbnRlcnJ1cHQgKi8KKwkJCWludG1hc2tfb3Jn
ID0gYXJjbXNyX2Rpc2FibGVfb3V0Ym91bmRfaW50cyhhY2IpOworCQkJYXJjbXNyX2dldF9maXJt
d2FyZV9zcGVjKGFjYik7CisJCQlhcmNtc3Jfc3RhcnRfYWRhcHRlcl9iZ3JiKGFjYik7CisJCQkv
KiBjbGVhciBRYnVmZmVyIGlmIGRvb3IgYmVsbCByaW5nZWQgKi8KKwkJCW91dGJvdW5kX2Rvb3Ji
ZWxsID0gcmVhZGwoJnJlZy0+b3V0Ym91bmRfZG9vcmJlbGwpOworCQkJd3JpdGVsKG91dGJvdW5k
X2Rvb3JiZWxsLCAmcmVnLT5vdXRib3VuZF9kb29yYmVsbCk7CisJCQl3cml0ZWwoQVJDTVNSX0lO
Qk9VTkRfRFJJVkVSX0RBVEFfUkVBRF9PSywKKwkJCQkmcmVnLT5pbmJvdW5kX2Rvb3JiZWxsKTsK
KwkJCWFyY21zcl9lbmFibGVfb3V0Ym91bmRfaW50cyhhY2IsIGludG1hc2tfb3JnKTsKKwkJCWF0
b21pY19zZXQoJmFjYi0+cnFfbWFwX3Rva2VuLCAxNik7CisJCQlhdG9taWNfc2V0KCZhY2ItPmFu
dGVfdG9rZW5fdmFsdWUsIDE2KTsKKwkJCWFjYi0+ZndfZmxhZyA9IEZXX05PUk1BTDsKKwkJCW1v
ZF90aW1lcigmYWNiLT5ldGVybmFsX3RpbWVyLCBqaWZmaWVzICsKKwkJCQltc2Vjc190b19qaWZm
aWVzKDYgKiBIWikpOworCQkJYWNiLT5hY2JfZmxhZ3MgJj0gfkFDQl9GX0JVU19SRVNFVDsKKwkJ
CXJ0biA9IFNVQ0NFU1M7CisJCQlwcl9lcnIoImFyY21zcjogc2NzaSBidXMgcmVzZXQgZWggIgor
CQkJCSJyZXR1cm5zIHdpdGggc3VjY2Vzc1xuIik7CisJCX0gZWxzZSB7CisJCQlhY2ItPmFjYl9m
bGFncyAmPSB+QUNCX0ZfQlVTX1JFU0VUOworCQkJYXRvbWljX3NldCgmYWNiLT5ycV9tYXBfdG9r
ZW4sIDE2KTsKKwkJCWF0b21pY19zZXQoJmFjYi0+YW50ZV90b2tlbl92YWx1ZSwgMTYpOworCQkJ
YWNiLT5md19mbGFnID0gRldfTk9STUFMOworCQkJbW9kX3RpbWVyKCZhY2ItPmV0ZXJuYWxfdGlt
ZXIsCisJCQkJamlmZmllcyArIG1zZWNzX3RvX2ppZmZpZXMoNiAqIEhaKSk7CisJCQlydG4gPSBT
VUNDRVNTOwogCQl9Ci0JCWNhc2UgQUNCX0FEQVBURVJfVFlQRV9COnsKLQkJCWFjYi0+YWNiX2Zs
YWdzIHw9IEFDQl9GX0JVU19SRVNFVDsKLQkJCWlmICghYXJjbXNyX2lvcF9yZXNldChhY2IpKSB7
Ci0JCQkJYWNiLT5hY2JfZmxhZ3MgJj0gfkFDQl9GX0JVU19SRVNFVDsKLQkJCQlydG4gPSBGQUlM
RUQ7Ci0JCQl9IGVsc2UgewotCQkJCWFjYi0+YWNiX2ZsYWdzICY9IH5BQ0JfRl9CVVNfUkVTRVQ7
Ci0JCQkJYXRvbWljX3NldCgmYWNiLT5ycV9tYXBfdG9rZW4sIDE2KTsKLQkJCQlhdG9taWNfc2V0
KCZhY2ItPmFudGVfdG9rZW5fdmFsdWUsIDE2KTsKLQkJCQlhY2ItPmZ3X2ZsYWcgPSBGV19OT1JN
QUw7Ci0JCQkJbW9kX3RpbWVyKCZhY2ItPmV0ZXJuYWxfdGltZXIsIGppZmZpZXMgKyBtc2Vjc190
b19qaWZmaWVzKDYgKiBIWikpOwotCQkJCXJ0biA9IFNVQ0NFU1M7Ci0JCQl9Ci0JCQlicmVhazsK
KwkJYnJlYWs7CisJfQorCWNhc2UgQUNCX0FEQVBURVJfVFlQRV9COiB7CisJCWFjYi0+YWNiX2Zs
YWdzIHw9IEFDQl9GX0JVU19SRVNFVDsKKwkJaWYgKCFhcmNtc3JfaW9wX3Jlc2V0KGFjYikpIHsK
KwkJCWFjYi0+YWNiX2ZsYWdzICY9IH5BQ0JfRl9CVVNfUkVTRVQ7CisJCQlydG4gPSBGQUlMRUQ7
CisJCX0gZWxzZSB7CisJCQlhY2ItPmFjYl9mbGFncyAmPSB+QUNCX0ZfQlVTX1JFU0VUOworCQkJ
YXRvbWljX3NldCgmYWNiLT5ycV9tYXBfdG9rZW4sIDE2KTsKKwkJCWF0b21pY19zZXQoJmFjYi0+
YW50ZV90b2tlbl92YWx1ZSwgMTYpOworCQkJYWNiLT5md19mbGFnID0gRldfTk9STUFMOworCQkJ
bW9kX3RpbWVyKCZhY2ItPmV0ZXJuYWxfdGltZXIsCisJCQkJamlmZmllcyArIG1zZWNzX3RvX2pp
ZmZpZXMoNiAqIEhaKSk7CisJCQlydG4gPSBTVUNDRVNTOwogCQl9Ci0JCWNhc2UgQUNCX0FEQVBU
RVJfVFlQRV9DOnsKLQkJCWlmIChhY2ItPmFjYl9mbGFncyAmIEFDQl9GX0JVU19SRVNFVCkgewot
CQkJCWxvbmcgdGltZW91dDsKLQkJCQlwcmludGsoS0VSTl9FUlIgImFyY21zcjogdGhlcmUgaXMg
YW4gYnVzIHJlc2V0IGVoIHByb2NlZWRpbmcuLi4uLi4uXG4iKTsKLQkJCQl0aW1lb3V0ID0gd2Fp
dF9ldmVudF90aW1lb3V0KHdhaXRfcSwgKGFjYi0+YWNiX2ZsYWdzICYgQUNCX0ZfQlVTX1JFU0VU
KSA9PSAwLCAyMjAqSFopOwotCQkJCWlmICh0aW1lb3V0KSB7Ci0JCQkJCXJldHVybiBTVUNDRVNT
OworCQlicmVhazsKKwl9CisJY2FzZSBBQ0JfQURBUFRFUl9UWVBFX0M6IHsKKwkJaWYgKGFjYi0+
YWNiX2ZsYWdzICYgQUNCX0ZfQlVTX1JFU0VUKSB7CisJCQlsb25nIHRpbWVvdXQ7CisJCQlwcl9l
cnIoImFyY21zcjogdGhlcmUgaXMgYW4gYnVzICIKKwkJCQkicmVzZXQgZWggcHJvY2VlZGluZy4u
Li4uLi5cbiIpOworCQkJdGltZW91dCA9IHdhaXRfZXZlbnRfdGltZW91dCh3YWl0X3EsCisJCQkJ
KGFjYi0+YWNiX2ZsYWdzICYgQUNCX0ZfQlVTX1JFU0VUKSA9PSAwLAorCQkJCTIyMCAqIEhaKTsK
KwkJCWlmICh0aW1lb3V0KQorCQkJCXJldHVybiBTVUNDRVNTOworCQl9CisJCWFjYi0+YWNiX2Zs
YWdzIHw9IEFDQl9GX0JVU19SRVNFVDsKKwkJaWYgKCFhcmNtc3JfaW9wX3Jlc2V0KGFjYikpIHsK
KwkJCXN0cnVjdCBNZXNzYWdlVW5pdF9DIF9faW9tZW0gKnJlZzsKKwkJCXJlZyA9IGFjYi0+cG11
QzsKKwkJCWFyY21zcl9oYXJkd2FyZV9yZXNldChhY2IpOworCQkJYWNiLT5hY2JfZmxhZ3MgJj0g
fkFDQl9GX0lPUF9JTklURUQ7CitzbGVlcDoKKwkJCXNzbGVlcChBUkNNU1JfU0xFRVBUSU1FKTsK
KwkJCWlmICgocmVhZGwoJnJlZy0+aG9zdF9kaWFnbm9zdGljKSAmIDB4MDQpICE9IDApIHsKKwkJ
CQlwcl9lcnIoImFyY21zciVkOiB3YWl0aW5nICIKKwkJCQkJImZvciBodyBidXMgcmVzZXQgcmV0
dXJuLCByZXRyeSA9ICVkXG4iLAorCQkJCQlhY2ItPmhvc3QtPmhvc3Rfbm8sIHJldHJ5X2NvdW50
KTsKKwkJCQlpZiAocmV0cnlfY291bnQgPiBBUkNNU1JfUkVUUllDT1VOVCkgeworCQkJCQlhY2It
PmZ3X2ZsYWcgPSBGV19ERUFETE9DSzsKKwkJCQkJcHJfZXJyKCJhcmNtc3IlZDogIgorCQkJCQkJ
IndhaXRpbmcgZm9yIGh3IGJ1cyByZXNldCByZXR1cm4sICIKKwkJCQkJCSJSRVRSWSBURVJNSU5B
VEVEISFcbiIsCisJCQkJCQlhY2ItPmhvc3QtPmhvc3Rfbm8pOworCQkJCQlyZXR1cm4gRkFJTEVE
OwogCQkJCX0KKwkJCQlyZXRyeV9jb3VudCsrOworCQkJCWdvdG8gc2xlZXA7CiAJCQl9Ci0JCQlh
Y2ItPmFjYl9mbGFncyB8PSBBQ0JfRl9CVVNfUkVTRVQ7Ci0JCQlpZiAoIWFyY21zcl9pb3BfcmVz
ZXQoYWNiKSkgewotCQkJCXN0cnVjdCBNZXNzYWdlVW5pdF9DIF9faW9tZW0gKnJlZzsKLQkJCQly
ZWcgPSBhY2ItPnBtdUM7Ci0JCQkJYXJjbXNyX2hhcmR3YXJlX3Jlc2V0KGFjYik7Ci0JCQkJYWNi
LT5hY2JfZmxhZ3MgJj0gfkFDQl9GX0lPUF9JTklURUQ7Ci1zbGVlcDoKLQkJCQlzc2xlZXAoQVJD
TVNSX1NMRUVQVElNRSk7Ci0JCQkJaWYgKChyZWFkbCgmcmVnLT5ob3N0X2RpYWdub3N0aWMpICYg
MHgwNCkgIT0gMCkgewotCQkJCQlwcmludGsoS0VSTl9FUlIgImFyY21zciVkOiB3YWl0aW5nIGZv
ciBodyBidXMgcmVzZXQgcmV0dXJuLCByZXRyeT0lZFxuIiwgYWNiLT5ob3N0LT5ob3N0X25vLCBy
ZXRyeV9jb3VudCk7Ci0JCQkJCWlmIChyZXRyeV9jb3VudCA+IEFSQ01TUl9SRVRSWUNPVU5UKSB7
Ci0JCQkJCQlhY2ItPmZ3X2ZsYWcgPSBGV19ERUFETE9DSzsKLQkJCQkJCXByaW50ayhLRVJOX0VS
UiAiYXJjbXNyJWQ6IHdhaXRpbmcgZm9yIGh3IGJ1cyByZXNldCByZXR1cm4sIFJFVFJZIFRFUk1J
TkFURUQhIVxuIiwgYWNiLT5ob3N0LT5ob3N0X25vKTsKLQkJCQkJCXJldHVybiBGQUlMRUQ7Ci0J
CQkJCX0KLQkJCQkJcmV0cnlfY291bnQrKzsKLQkJCQkJZ290byBzbGVlcDsKKwkJCWFjYi0+YWNi
X2ZsYWdzIHw9IEFDQl9GX0lPUF9JTklURUQ7CisJCQkvKiBkaXNhYmxlIGFsbCBvdXRib3VuZCBp
bnRlcnJ1cHQgKi8KKwkJCWludG1hc2tfb3JnID0KKwkJCWFyY21zcl9kaXNhYmxlX291dGJvdW5k
X2ludHMoYWNiKTsKKwkJCWFyY21zcl9nZXRfZmlybXdhcmVfc3BlYyhhY2IpOworCQkJYXJjbXNy
X3N0YXJ0X2FkYXB0ZXJfYmdyYihhY2IpOworCQkJLyogY2xlYXIgUWJ1ZmZlciBpZiBkb29yIGJl
bGwgcmluZ2VkICovCisJCQlvdXRib3VuZF9kb29yYmVsbCA9CisJCQlyZWFkbCgmcmVnLT5vdXRi
b3VuZF9kb29yYmVsbCk7CisJCQl3cml0ZWwob3V0Ym91bmRfZG9vcmJlbGwsCisJCQkJJnJlZy0+
b3V0Ym91bmRfZG9vcmJlbGxfY2xlYXIpOworCQkJd3JpdGVsKEFSQ01TUl9IQkNNVV9EUlYySU9Q
X0RBVEFfUkVBRF9PSywKKwkJCQkmcmVnLT5pbmJvdW5kX2Rvb3JiZWxsKTsKKwkJCWFyY21zcl9l
bmFibGVfb3V0Ym91bmRfaW50cyhhY2IsCisJCQkJaW50bWFza19vcmcpOworCQkJYXRvbWljX3Nl
dCgmYWNiLT5ycV9tYXBfdG9rZW4sIDE2KTsKKwkJCWF0b21pY19zZXQoJmFjYi0+YW50ZV90b2tl
bl92YWx1ZSwgMTYpOworCQkJYWNiLT5md19mbGFnID0gRldfTk9STUFMOworCQkJbW9kX3RpbWVy
KCZhY2ItPmV0ZXJuYWxfdGltZXIsIGppZmZpZXMgKworCQkJCW1zZWNzX3RvX2ppZmZpZXMoNiAq
IEhaKSk7CisJCQlhY2ItPmFjYl9mbGFncyAmPSB+QUNCX0ZfQlVTX1JFU0VUOworCQkJcnRuID0g
U1VDQ0VTUzsKKwkJCXByX2VycigiYXJjbXNyOiBzY3NpIGJ1cyByZXNldCAiCisJCQkJImVoIHJl
dHVybnMgd2l0aCBzdWNjZXNzXG4iKTsKKwkJfSBlbHNlIHsKKwkJCWFjYi0+YWNiX2ZsYWdzICY9
IH5BQ0JfRl9CVVNfUkVTRVQ7CisJCQlhdG9taWNfc2V0KCZhY2ItPnJxX21hcF90b2tlbiwgMTYp
OworCQkJYXRvbWljX3NldCgmYWNiLT5hbnRlX3Rva2VuX3ZhbHVlLCAxNik7CisJCQlhY2ItPmZ3
X2ZsYWcgPSBGV19OT1JNQUw7CisJCQltb2RfdGltZXIoJmFjYi0+ZXRlcm5hbF90aW1lciwgamlm
ZmllcyArCisJCQkJbXNlY3NfdG9famlmZmllcyg2ICogSFopKTsKKwkJCXJ0biA9IFNVQ0NFU1M7
CisJCX0KKwkJYnJlYWs7CisJfQorCWNhc2UgQUNCX0FEQVBURVJfVFlQRV9EOiB7CisJCWlmIChh
Y2ItPmFjYl9mbGFncyAmIEFDQl9GX0JVU19SRVNFVCkgeworCQkJbG9uZyB0aW1lb3V0OworCQkJ
cHJfbm90aWNlKCJhcmNtc3I6IHRoZXJlIGlzIGFuIGJ1cyByZXNldCBlaCBwcm9jZWVkaW5nLi4u
Li4uLlxuIik7CisJCQl0aW1lb3V0ID0gd2FpdF9ldmVudF90aW1lb3V0KHdhaXRfcSwgKGFjYi0+
YWNiX2ZsYWdzCisJCQkJJiBBQ0JfRl9CVVNfUkVTRVQpID09IDAsIDIyMCAqIEhaKTsKKwkJCWlm
ICh0aW1lb3V0KQorCQkJCXJldHVybiBTVUNDRVNTOworCQl9CisJCWFjYi0+YWNiX2ZsYWdzIHw9
IEFDQl9GX0JVU19SRVNFVDsKKwkJaWYgKCFhcmNtc3JfaW9wX3Jlc2V0KGFjYikpIHsKKwkJCXN0
cnVjdCBNZXNzYWdlVW5pdF9EIF9faW9tZW0gKnJlZzsKKwkJCXJlZyA9IGFjYi0+cG11RDsKKwkJ
CWFyY21zcl9oYXJkd2FyZV9yZXNldChhY2IpOworCQkJYWNiLT5hY2JfZmxhZ3MgJj0gfkFDQl9G
X0lPUF9JTklURUQ7CisJCW5hcDoKKwkJCXNzbGVlcChBUkNNU1JfU0xFRVBUSU1FKTsKKwkJCWlm
ICgocmVhZGwocmVnLT5zYW1wbGVfYXRfcmVzZXQpICYgMHg4MCkgIT0gMCkgeworCQkJCXByX2Vy
cigiYXJjbXNyJWQ6IHdhaXRpbmcgZm9yICIKKwkJCQkJImh3IGJ1cyByZXNldCByZXR1cm4sIHJl
dHJ5PSVkXG4iLAorCQkJCQlhY2ItPmhvc3QtPmhvc3Rfbm8sIHJldHJ5X2NvdW50KTsKKwkJCQlp
ZiAocmV0cnlfY291bnQgPiBBUkNNU1JfUkVUUllDT1VOVCkgeworCQkJCQlhY2ItPmZ3X2ZsYWcg
PSBGV19ERUFETE9DSzsKKwkJCQkJcHJfZXJyKCJhcmNtc3IlZDogIgorCQkJCQkJIndhaXRpbmcg
Zm9yIGh3IGJ1cyByZXNldCByZXR1cm4sICIKKwkJCQkJCSJSRVRSWSBURVJNSU5BVEVEISFcbiIs
CisJCQkJCQlhY2ItPmhvc3QtPmhvc3Rfbm8pOworCQkJCQlyZXR1cm4gRkFJTEVEOwogCQkJCX0K
LQkJCQlhY2ItPmFjYl9mbGFncyB8PSBBQ0JfRl9JT1BfSU5JVEVEOwotCQkJCS8qIGRpc2FibGUg
YWxsIG91dGJvdW5kIGludGVycnVwdCAqLwotCQkJCWludG1hc2tfb3JnID0gYXJjbXNyX2Rpc2Fi
bGVfb3V0Ym91bmRfaW50cyhhY2IpOwotCQkJCWFyY21zcl9nZXRfZmlybXdhcmVfc3BlYyhhY2Ip
OwotCQkJCWFyY21zcl9zdGFydF9hZGFwdGVyX2JncmIoYWNiKTsKLQkJCQkvKiBjbGVhciBRYnVm
ZmVyIGlmIGRvb3IgYmVsbCByaW5nZWQgKi8KLQkJCQlvdXRib3VuZF9kb29yYmVsbCA9IHJlYWRs
KCZyZWctPm91dGJvdW5kX2Rvb3JiZWxsKTsKLQkJCQl3cml0ZWwob3V0Ym91bmRfZG9vcmJlbGws
ICZyZWctPm91dGJvdW5kX2Rvb3JiZWxsX2NsZWFyKTsgLypjbGVhciBpbnRlcnJ1cHQgKi8KLQkJ
CQl3cml0ZWwoQVJDTVNSX0hCQ01VX0RSVjJJT1BfREFUQV9SRUFEX09LLCAmcmVnLT5pbmJvdW5k
X2Rvb3JiZWxsKTsKLQkJCQkvKiBlbmFibGUgb3V0Ym91bmQgUG9zdCBRdWV1ZSxvdXRib3VuZCBk
b29yYmVsbCBJbnRlcnJ1cHQgKi8KLQkJCQlhcmNtc3JfZW5hYmxlX291dGJvdW5kX2ludHMoYWNi
LCBpbnRtYXNrX29yZyk7Ci0JCQkJYXRvbWljX3NldCgmYWNiLT5ycV9tYXBfdG9rZW4sIDE2KTsK
LQkJCQlhdG9taWNfc2V0KCZhY2ItPmFudGVfdG9rZW5fdmFsdWUsIDE2KTsKLQkJCQlhY2ItPmZ3
X2ZsYWcgPSBGV19OT1JNQUw7Ci0JCQkJbW9kX3RpbWVyKCZhY2ItPmV0ZXJuYWxfdGltZXIsIGpp
ZmZpZXMgKyBtc2Vjc190b19qaWZmaWVzKDYgKiBIWikpOwotCQkJCWFjYi0+YWNiX2ZsYWdzICY9
IH5BQ0JfRl9CVVNfUkVTRVQ7Ci0JCQkJcnRuID0gU1VDQ0VTUzsKLQkJCQlwcmludGsoS0VSTl9F
UlIgImFyY21zcjogc2NzaSBidXMgcmVzZXQgZWggcmV0dXJucyB3aXRoIHN1Y2Nlc3NcbiIpOwot
CQkJfSBlbHNlIHsKLQkJCQlhY2ItPmFjYl9mbGFncyAmPSB+QUNCX0ZfQlVTX1JFU0VUOwotCQkJ
CWF0b21pY19zZXQoJmFjYi0+cnFfbWFwX3Rva2VuLCAxNik7Ci0JCQkJYXRvbWljX3NldCgmYWNi
LT5hbnRlX3Rva2VuX3ZhbHVlLCAxNik7Ci0JCQkJYWNiLT5md19mbGFnID0gRldfTk9STUFMOwot
CQkJCW1vZF90aW1lcigmYWNiLT5ldGVybmFsX3RpbWVyLCBqaWZmaWVzICsgbXNlY3NfdG9famlm
Zmllcyg2KkhaKSk7Ci0JCQkJcnRuID0gU1VDQ0VTUzsKKwkJCQlyZXRyeV9jb3VudCsrOworCQkJ
CWdvdG8gbmFwOwogCQkJfQotCQkJYnJlYWs7CisJCQlhY2ItPmFjYl9mbGFncyB8PSBBQ0JfRl9J
T1BfSU5JVEVEOworCQkJLyogZGlzYWJsZSBhbGwgb3V0Ym91bmQgaW50ZXJydXB0ICovCisJCQlp
bnRtYXNrX29yZyA9IGFyY21zcl9kaXNhYmxlX291dGJvdW5kX2ludHMoYWNiKTsKKwkJCWFyY21z
cl9nZXRfZmlybXdhcmVfc3BlYyhhY2IpOworCQkJYXJjbXNyX3N0YXJ0X2FkYXB0ZXJfYmdyYihh
Y2IpOworCQkJYXJjbXNyX2NsZWFyX2Rvb3JiZWxsX3F1ZXVlX2J1ZmZlcihhY2IpOworCQkJYXJj
bXNyX2VuYWJsZV9vdXRib3VuZF9pbnRzKGFjYiwgaW50bWFza19vcmcpOworCQkJYXRvbWljX3Nl
dCgmYWNiLT5ycV9tYXBfdG9rZW4sIDE2KTsKKwkJCWF0b21pY19zZXQoJmFjYi0+YW50ZV90b2tl
bl92YWx1ZSwgMTYpOworCQkJYWNiLT5md19mbGFnID0gRldfTk9STUFMOworCQkJbW9kX3RpbWVy
KCZhY2ItPmV0ZXJuYWxfdGltZXIsCisJCQkJamlmZmllcyArIG1zZWNzX3RvX2ppZmZpZXMoNiAq
IEhaKSk7CisJCQlhY2ItPmFjYl9mbGFncyAmPSB+QUNCX0ZfQlVTX1JFU0VUOworCQkJcnRuID0g
U1VDQ0VTUzsKKwkJCXByX2VycigiYXJjbXNyOiBzY3NpIGJ1cyByZXNldCAiCisJCQkJImVoIHJl
dHVybnMgd2l0aCBzdWNjZXNzXG4iKTsKKwkJfSBlbHNlIHsKKwkJCWFjYi0+YWNiX2ZsYWdzICY9
IH5BQ0JfRl9CVVNfUkVTRVQ7CisJCQlhdG9taWNfc2V0KCZhY2ItPnJxX21hcF90b2tlbiwgMTYp
OworCQkJYXRvbWljX3NldCgmYWNiLT5hbnRlX3Rva2VuX3ZhbHVlLCAxNik7CisJCQlhY2ItPmZ3
X2ZsYWcgPSBGV19OT1JNQUw7CisJCQltb2RfdGltZXIoJmFjYi0+ZXRlcm5hbF90aW1lciwKKwkJ
CQlqaWZmaWVzICsgbXNlY3NfdG9famlmZmllcyg2ICogSFopKTsKKwkJCXJ0biA9IFNVQ0NFU1M7
CiAJCX0KKwkJYnJlYWs7CisJfQogCX0KIAlyZXR1cm4gcnRuOwogfQogCi1zdGF0aWMgaW50IGFy
Y21zcl9hYm9ydF9vbmVfY21kKHN0cnVjdCBBZGFwdGVyQ29udHJvbEJsb2NrICphY2IsCitzdGF0
aWMgaW50CithcmNtc3JfYWJvcnRfb25lX2NtZChzdHJ1Y3QgQWRhcHRlckNvbnRyb2xCbG9jayAq
YWNiLAogCQlzdHJ1Y3QgQ29tbWFuZENvbnRyb2xCbG9jayAqY2NiKQogewogCWludCBydG47CkBA
IC0zMDUxLDE1ICs0NTMwLDE3IEBAIHN0YXRpYyBpbnQgYXJjbXNyX2Fib3J0X29uZV9jbWQoc3Ry
dWN0IEEKIAlyZXR1cm4gcnRuOwogfQogCi1zdGF0aWMgaW50IGFyY21zcl9hYm9ydChzdHJ1Y3Qg
c2NzaV9jbW5kICpjbWQpCitzdGF0aWMgaW50CithcmNtc3JfYWJvcnQoc3RydWN0IHNjc2lfY21u
ZCAqY21kKQogewotCXN0cnVjdCBBZGFwdGVyQ29udHJvbEJsb2NrICphY2IgPQotCQkoc3RydWN0
IEFkYXB0ZXJDb250cm9sQmxvY2sgKiljbWQtPmRldmljZS0+aG9zdC0+aG9zdGRhdGE7CisJc3Ry
dWN0IEFkYXB0ZXJDb250cm9sQmxvY2sgKmFjYiA9IChzdHJ1Y3QgQWRhcHRlckNvbnRyb2xCbG9j
ayAqKQorCQljbWQtPmRldmljZS0+aG9zdC0+aG9zdGRhdGE7CiAJaW50IGkgPSAwOwogCWludCBy
dG4gPSBGQUlMRUQ7Ci0JcHJpbnRrKEtFUk5fTk9USUNFCi0JCSJhcmNtc3IlZDogYWJvcnQgZGV2
aWNlIGNvbW1hbmQgb2Ygc2NzaSBpZCA9ICVkIGx1biA9ICVkIFxuIiwKLQkJYWNiLT5ob3N0LT5o
b3N0X25vLCBjbWQtPmRldmljZS0+aWQsIGNtZC0+ZGV2aWNlLT5sdW4pOworCXByX25vdGljZSgi
YXJjbXNyJWQ6IGFib3J0IGRldmljZSBjb21tYW5kIG9mICIKKwkJInNjc2kgaWQgPSAlZCBsdW4g
PSAlZFxuIiwKKwkJYWNiLT5ob3N0LT5ob3N0X25vLAorCQljbWQtPmRldmljZS0+aWQsIGNtZC0+
ZGV2aWNlLT5sdW4pOwogCWFjYi0+YWNiX2ZsYWdzIHw9IEFDQl9GX0FCT1JUOwogCWFjYi0+bnVt
X2Fib3J0cysrOwogCS8qCkBAIC0zMDczLDcgKzQ1NTQsOCBAQCBzdGF0aWMgaW50IGFyY21zcl9h
Ym9ydChzdHJ1Y3Qgc2NzaV9jbW5kCiAKIAlmb3IgKGkgPSAwOyBpIDwgQVJDTVNSX01BWF9GUkVF
Q0NCX05VTTsgaSsrKSB7CiAJCXN0cnVjdCBDb21tYW5kQ29udHJvbEJsb2NrICpjY2IgPSBhY2It
PnBjY2JfcG9vbFtpXTsKLQkJaWYgKGNjYi0+c3RhcnRkb25lID09IEFSQ01TUl9DQ0JfU1RBUlQg
JiYgY2NiLT5wY21kID09IGNtZCkgeworCQlpZiAoY2NiLT5zdGFydGRvbmUgPT0gQVJDTVNSX0ND
Ql9TVEFSVCAmJgorCQkJY2NiLT5wY21kID09IGNtZCkgewogCQkJY2NiLT5zdGFydGRvbmUgPSBB
UkNNU1JfQ0NCX0FCT1JURUQ7CiAJCQlydG4gPSBhcmNtc3JfYWJvcnRfb25lX2NtZChhY2IsIGNj
Yik7CiAJCQlicmVhazsKQEAgLTMwODMsMTAgKzQ1NjUsMTEgQEAgc3RhdGljIGludCBhcmNtc3Jf
YWJvcnQoc3RydWN0IHNjc2lfY21uZAogCXJldHVybiBydG47CiB9CiAKLXN0YXRpYyBjb25zdCBj
aGFyICphcmNtc3JfaW5mbyhzdHJ1Y3QgU2NzaV9Ib3N0ICpob3N0KQorc3RhdGljIGNvbnN0IGNo
YXIKKyphcmNtc3JfaW5mbyhzdHJ1Y3QgU2NzaV9Ib3N0ICpob3N0KQogewogCXN0cnVjdCBBZGFw
dGVyQ29udHJvbEJsb2NrICphY2IgPQotCQkoc3RydWN0IEFkYXB0ZXJDb250cm9sQmxvY2sgKikg
aG9zdC0+aG9zdGRhdGE7CisJKHN0cnVjdCBBZGFwdGVyQ29udHJvbEJsb2NrICopaG9zdC0+aG9z
dGRhdGE7CiAJc3RhdGljIGNoYXIgYnVmWzI1Nl07CiAJY2hhciAqdHlwZTsKIAlpbnQgcmFpZDYg
PSAxOwpAQCAtMzEwMiw2ICs0NTg1LDcgQEAgc3RhdGljIGNvbnN0IGNoYXIgKmFyY21zcl9pbmZv
KHN0cnVjdCBTYwogCWNhc2UgUENJX0RFVklDRV9JRF9BUkVDQV8xMTYwOgogCWNhc2UgUENJX0RF
VklDRV9JRF9BUkVDQV8xMTcwOgogCWNhc2UgUENJX0RFVklDRV9JRF9BUkVDQV8xMjAxOgorCWNh
c2UgUENJX0RFVklDRV9JRF9BUkVDQV8xMjE0OgogCWNhc2UgUENJX0RFVklDRV9JRF9BUkVDQV8x
MjIwOgogCWNhc2UgUENJX0RFVklDRV9JRF9BUkVDQV8xMjMwOgogCWNhc2UgUENJX0RFVklDRV9J
RF9BUkVDQV8xMjYwOgpAQCAtMzEwOSwxOSArNDU5MywxOSBAQCBzdGF0aWMgY29uc3QgY2hhciAq
YXJjbXNyX2luZm8oc3RydWN0IFNjCiAJY2FzZSBQQ0lfREVWSUNFX0lEX0FSRUNBXzEyODA6CiAJ
CXR5cGUgPSAiU0FUQSI7CiAJCWJyZWFrOwotCWNhc2UgUENJX0RFVklDRV9JRF9BUkVDQV8xMzgw
OgotCWNhc2UgUENJX0RFVklDRV9JRF9BUkVDQV8xMzgxOgogCWNhc2UgUENJX0RFVklDRV9JRF9B
UkVDQV8xNjgwOgogCWNhc2UgUENJX0RFVklDRV9JRF9BUkVDQV8xNjgxOgogCWNhc2UgUENJX0RF
VklDRV9JRF9BUkVDQV8xODgwOgogCQl0eXBlID0gIlNBUyI7CiAJCWJyZWFrOwogCWRlZmF1bHQ6
Ci0JCXR5cGUgPSAiWC1UWVBFIjsKKwkJdHlwZSA9ICJ1bmtub3duIjsKKwkJcmFpZDYgPQkwOwog
CQlicmVhazsKIAl9Ci0Jc3ByaW50ZihidWYsICJBcmVjYSAlcyBIb3N0IEFkYXB0ZXIgUkFJRCBD
b250cm9sbGVyJXNcbiAlcyIsCi0JCQl0eXBlLCByYWlkNiA/ICIoIFJBSUQ2IGNhcGFibGUpIiA6
ICIiLAotCQkJQVJDTVNSX0RSSVZFUl9WRVJTSU9OKTsKKwlzcHJpbnRmKGJ1ZiwgIkFyZWNhICVz
IEhvc3QgQWRhcHRlciBSQUlEIENvbnRyb2xsZXIlc1xuYXJjbXNyIHZlcnNpb24gJXNcbiIsCisJ
CXR5cGUsIHJhaWQ2ID8gIiggUkFJRDYgY2FwYWJsZSkiIDogIiIsIEFSQ01TUl9EUklWRVJfVkVS
U0lPTik7CisJCQogCXJldHVybiBidWY7CiB9CisK
--001a1133aa8693883304e50eeb28--

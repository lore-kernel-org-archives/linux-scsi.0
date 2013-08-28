From: =?big5?B?tsCyTbap?= <ching2048@areca.com.tw>
Subject: Re:  [PATCH 1/1] arcmsr: Support Areca new SATA Raid Adapter ARC1214/1224/1264/1284 (Resend renew)
Date: Wed, 28 Aug 2013 19:36:28 +0800
Message-ID: <39FBE6085369426B994B65101ECDE152@chingDT>
Reply-To: =?big5?B?tsCyTbap?= <ching2048@areca.com.tw>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_002C_01CEA425.E40A7980"
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@kernel.org, thenzl@redhat.com, fengguang.wu@intel.com, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Cc: JBottomley@parallels.com, billion <billion.wu@areca.com.tw>
List-Id: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.

------=_NextPart_000_002C_01CEA425.E40A7980
Content-Type: text/plain;
	format=flowed;
	charset="big5";
	reply-type=original
Content-Transfer-Encoding: 7bit

Resend the patch code.

> From: Ching<ching2048@areca.com.tw>
>
> Support Areca new SATA Raid Adapter ARC1214/1224/1264/1284.
> Modify maximum outstanding command number.
> Notify command complete with auto request sense.
> Fix bug of updating adapter firmware through ioctl(ARCHTTP) interface.
> Fix coding style warning.
> Fix compiling warning.
>
> This patch is for arcmsr source code in kernel tree.
> The following patch code also in attached file patch.
>
> Signed-off-by:  Ching <ching2048@areca.com.tw>
> ---
>

diff -uprN a/drivers/scsi/arcmsr/arcmsr_attr.c 
b/drivers/scsi/arcmsr/arcmsr_attr.c
--- a/drivers/scsi/arcmsr/arcmsr_attr.c 2013-07-01 06:13:28.000000000 +0800
+++ b/drivers/scsi/arcmsr/arcmsr_attr.c 2013-08-28 03:19:46.000000000 +0800
@@ -59,64 +59,87 @@

 struct device_attribute *arcmsr_host_attrs[];

-static ssize_t arcmsr_sysfs_iop_message_read(struct file *filp,
-          struct kobject *kobj,
-          struct bin_attribute *bin,
-          char *buf, loff_t off,
-          size_t count)
+static ssize_t
+arcmsr_sysfs_iop_message_read(struct file *filp,
+    struct kobject *kobj,
+    struct bin_attribute *bin,
+    char *buf, loff_t off,
+    size_t count)
 {
- struct device *dev = container_of(kobj,struct device,kobj);
+ struct device *dev = container_of(kobj, struct device, kobj);
  struct Scsi_Host *host = class_to_shost(dev);
- struct AdapterControlBlock *acb = (struct AdapterControlBlock *) 
host->hostdata;
+ struct AdapterControlBlock *acb =
+  (struct AdapterControlBlock *)host->hostdata;
  uint8_t *pQbuffer,*ptmpQbuffer;
  int32_t allxfer_len = 0;
+ unsigned long flags;

  if (!capable(CAP_SYS_ADMIN))
   return -EACCES;

  /* do message unit read. */
  ptmpQbuffer = (uint8_t *)buf;
- while ((acb->rqbuf_firstindex != acb->rqbuf_lastindex)
-  && (allxfer_len < 1031)) {
+ spin_lock_irqsave(&acb->rqbuffer_lock, flags);
+ if (acb->rqbuf_firstindex != acb->rqbuf_lastindex) {
   pQbuffer = &acb->rqbuffer[acb->rqbuf_firstindex];
-  memcpy(ptmpQbuffer, pQbuffer, 1);
-  acb->rqbuf_firstindex++;
-  acb->rqbuf_firstindex %= ARCMSR_MAX_QBUFFER;
-  ptmpQbuffer++;
-  allxfer_len++;
+  if (acb->rqbuf_firstindex > acb->rqbuf_lastindex) {
+   if ((ARCMSR_MAX_QBUFFER - acb->rqbuf_firstindex) >= 1032) {
+    memcpy((void *)ptmpQbuffer, (const void *)pQbuffer, 1032);
+    acb->rqbuf_firstindex += 1032;
+    acb->rqbuf_firstindex %= ARCMSR_MAX_QBUFFER;
+    allxfer_len = 1032;
+   } else {
+    if (((ARCMSR_MAX_QBUFFER - acb->rqbuf_firstindex) + 
acb->rqbuf_lastindex) > 1032) {
+     memcpy((void *)ptmpQbuffer, (const void *)pQbuffer, 
ARCMSR_MAX_QBUFFER - acb->rqbuf_firstindex);
+     ptmpQbuffer += ARCMSR_MAX_QBUFFER - acb->rqbuf_firstindex;
+     memcpy((void *)ptmpQbuffer, (const void *)acb->rqbuffer, 1032 - 
(ARCMSR_MAX_QBUFFER - acb->rqbuf_firstindex));
+     acb->rqbuf_firstindex = 1032 - (ARCMSR_MAX_QBUFFER - 
acb->rqbuf_firstindex);
+     allxfer_len = 1032;
+    } else {
+     memcpy((void *)ptmpQbuffer, (const void *)pQbuffer, 
ARCMSR_MAX_QBUFFER - acb->rqbuf_firstindex);
+     ptmpQbuffer += ARCMSR_MAX_QBUFFER - acb->rqbuf_firstindex;
+     memcpy((void *)ptmpQbuffer, (const void *)acb->rqbuffer, 
acb->rqbuf_lastindex);
+     allxfer_len = ARCMSR_MAX_QBUFFER - acb->rqbuf_firstindex + 
acb->rqbuf_lastindex;
+     acb->rqbuf_firstindex = acb->rqbuf_lastindex;
+    }
+   }
+  } else {
+   if ((acb->rqbuf_lastindex - acb->rqbuf_firstindex) > 1032) {
+    memcpy((void *)ptmpQbuffer, (const void *)pQbuffer, 1032);
+    acb->rqbuf_firstindex += 1032;
+    allxfer_len = 1032;
+   } else {
+    memcpy((void *)ptmpQbuffer, (const void *)pQbuffer, 
acb->rqbuf_lastindex - acb->rqbuf_firstindex);
+    allxfer_len = acb->rqbuf_lastindex - acb->rqbuf_firstindex;
+    acb->rqbuf_firstindex = acb->rqbuf_lastindex;
+   }
+  }
  }
  if (acb->acb_flags & ACB_F_IOPDATA_OVERFLOW) {
   struct QBUFFER __iomem *prbuffer;
-  uint8_t __iomem *iop_data;
-  int32_t iop_len;
-
   acb->acb_flags &= ~ACB_F_IOPDATA_OVERFLOW;
   prbuffer = arcmsr_get_iop_rqbuffer(acb);
-  iop_data = prbuffer->data;
-  iop_len = readl(&prbuffer->data_len);
-  while (iop_len > 0) {
-   acb->rqbuffer[acb->rqbuf_lastindex] = readb(iop_data);
-   acb->rqbuf_lastindex++;
-   acb->rqbuf_lastindex %= ARCMSR_MAX_QBUFFER;
-   iop_data++;
-   iop_len--;
-  }
-  arcmsr_iop_message_read(acb);
+  if (arcmsr_Read_iop_rqbuffer_data(acb, prbuffer) == 0)
+   acb->acb_flags |= ACB_F_IOPDATA_OVERFLOW;
  }
+ spin_unlock_irqrestore(&acb->rqbuffer_lock, flags);
  return (allxfer_len);
 }

-static ssize_t arcmsr_sysfs_iop_message_write(struct file *filp,
-           struct kobject *kobj,
-           struct bin_attribute *bin,
-           char *buf, loff_t off,
-           size_t count)
+static ssize_t
+arcmsr_sysfs_iop_message_write(struct file *filp,
+          struct kobject *kobj,
+          struct bin_attribute *bin,
+          char *buf, loff_t off,
+          size_t count)
 {
- struct device *dev = container_of(kobj,struct device,kobj);
+ struct device *dev = container_of(kobj, struct device, kobj);
  struct Scsi_Host *host = class_to_shost(dev);
- struct AdapterControlBlock *acb = (struct AdapterControlBlock *) 
host->hostdata;
+ struct AdapterControlBlock *acb =
+  (struct AdapterControlBlock *)host->hostdata;
  int32_t my_empty_len, user_len, wqbuf_firstindex, wqbuf_lastindex;
  uint8_t *pQbuffer, *ptmpuserbuffer;
+ unsigned long flags;

  if (!capable(CAP_SYS_ADMIN))
   return -EACCES;
@@ -125,10 +148,12 @@ static ssize_t arcmsr_sysfs_iop_message_
  /* do message unit write. */
  ptmpuserbuffer = (uint8_t *)buf;
  user_len = (int32_t)count;
+ spin_lock_irqsave(&acb->wqbuffer_lock, flags);
  wqbuf_lastindex = acb->wqbuf_lastindex;
  wqbuf_firstindex = acb->wqbuf_firstindex;
  if (wqbuf_lastindex != wqbuf_firstindex) {
-  arcmsr_post_ioctldata2iop(acb);
+  arcmsr_write_ioctldata2iop(acb);
+  spin_unlock_irqrestore(&acb->wqbuffer_lock, flags);
   return 0; /*need retry*/
  } else {
   my_empty_len = (wqbuf_firstindex-wqbuf_lastindex - 1)
@@ -137,50 +162,58 @@ static ssize_t arcmsr_sysfs_iop_message_
    while (user_len > 0) {
     pQbuffer =
     &acb->wqbuffer[acb->wqbuf_lastindex];
-    memcpy(pQbuffer, ptmpuserbuffer, 1);
+    memcpy((void *)pQbuffer, (const void *)ptmpuserbuffer, 1);
     acb->wqbuf_lastindex++;
-    acb->wqbuf_lastindex %= ARCMSR_MAX_QBUFFER;
+    acb->wqbuf_lastindex %=
+     ARCMSR_MAX_QBUFFER;
     ptmpuserbuffer++;
     user_len--;
    }
-   if (acb->acb_flags & ACB_F_MESSAGE_WQBUFFER_CLEARED) {
+   if (acb->acb_flags &
+    ACB_F_MESSAGE_WQBUFFER_CLEARED) {
     acb->acb_flags &=
      ~ACB_F_MESSAGE_WQBUFFER_CLEARED;
-    arcmsr_post_ioctldata2iop(acb);
+    arcmsr_write_ioctldata2iop(acb);
    }
+   spin_unlock_irqrestore(&acb->wqbuffer_lock, flags);
    return count;
   } else {
+   spin_unlock_irqrestore(&acb->wqbuffer_lock, flags);
    return 0; /*need retry*/
   }
  }
 }

-static ssize_t arcmsr_sysfs_iop_message_clear(struct file *filp,
-           struct kobject *kobj,
-           struct bin_attribute *bin,
-           char *buf, loff_t off,
-           size_t count)
+static ssize_t
+arcmsr_sysfs_iop_message_clear(struct file *filp,
+          struct kobject *kobj,
+          struct bin_attribute *bin,
+          char *buf, loff_t off,
+          size_t count)
 {
- struct device *dev = container_of(kobj,struct device,kobj);
+ struct device *dev = container_of(kobj, struct device, kobj);
  struct Scsi_Host *host = class_to_shost(dev);
- struct AdapterControlBlock *acb = (struct AdapterControlBlock *) 
host->hostdata;
+ struct AdapterControlBlock *acb =
+  (struct AdapterControlBlock *)host->hostdata;
  uint8_t *pQbuffer;
+ unsigned long flags;

  if (!capable(CAP_SYS_ADMIN))
   return -EACCES;

- if (acb->acb_flags & ACB_F_IOPDATA_OVERFLOW) {
-  acb->acb_flags &= ~ACB_F_IOPDATA_OVERFLOW;
-  arcmsr_iop_message_read(acb);
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
@@ -215,31 +248,37 @@ static struct bin_attribute arcmsr_sysfs
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
+  &arcmsr_sysfs_message_read_attr);
  if (error) {
-  printk(KERN_ERR "arcmsr: alloc sysfs mu_read failed\n");
+  pr_err("arcmsr: alloc sysfs mu_read failed\n");
   goto error_bin_file_message_read;
  }
- error = sysfs_create_bin_file(&host->shost_dev.kobj, 
&arcmsr_sysfs_message_write_attr);
+ error = sysfs_create_bin_file(&host->shost_dev.kobj,
+  &arcmsr_sysfs_message_write_attr);
  if (error) {
-  printk(KERN_ERR "arcmsr: alloc sysfs mu_write failed\n");
+  pr_err("arcmsr: alloc sysfs mu_write failed\n");
   goto error_bin_file_message_write;
  }
- error = sysfs_create_bin_file(&host->shost_dev.kobj, 
&arcmsr_sysfs_message_clear_attr);
+ error = sysfs_create_bin_file(&host->shost_dev.kobj,
+  &arcmsr_sysfs_message_clear_attr);
  if (error) {
-  printk(KERN_ERR "arcmsr: alloc sysfs mu_clear failed\n");
+  pr_err("arcmsr: alloc sysfs mu_clear failed\n");
   goto error_bin_file_message_clear;
  }
  return 0;
 error_bin_file_message_clear:
- sysfs_remove_bin_file(&host->shost_dev.kobj, 
&arcmsr_sysfs_message_write_attr);
+ sysfs_remove_bin_file(&host->shost_dev.kobj,
+  &arcmsr_sysfs_message_write_attr);
 error_bin_file_message_write:
- sysfs_remove_bin_file(&host->shost_dev.kobj, 
&arcmsr_sysfs_message_read_attr);
+ sysfs_remove_bin_file(&host->shost_dev.kobj,
+  &arcmsr_sysfs_message_read_attr);
 error_bin_file_message_read:
  return error;
 }
@@ -248,15 +287,17 @@ void arcmsr_free_sysfs_attr(struct Adapt
 {
  struct Scsi_Host *host = acb->host;

- sysfs_remove_bin_file(&host->shost_dev.kobj, 
&arcmsr_sysfs_message_clear_attr);
- sysfs_remove_bin_file(&host->shost_dev.kobj, 
&arcmsr_sysfs_message_write_attr);
- sysfs_remove_bin_file(&host->shost_dev.kobj, 
&arcmsr_sysfs_message_read_attr);
+ sysfs_remove_bin_file(&host->shost_dev.kobj,
+  &arcmsr_sysfs_message_clear_attr);
+ sysfs_remove_bin_file(&host->shost_dev.kobj,
+  &arcmsr_sysfs_message_write_attr);
+ sysfs_remove_bin_file(&host->shost_dev.kobj,
+  &arcmsr_sysfs_message_read_attr);
 }

-
 static ssize_t
 arcmsr_attr_host_driver_version(struct device *dev,
-    struct device_attribute *attr, char *buf)
+   struct device_attribute *attr, char *buf)
 {
  return snprintf(buf, PAGE_SIZE,
    "%s\n",
@@ -265,11 +306,11 @@ arcmsr_attr_host_driver_version(struct d

 static ssize_t
 arcmsr_attr_host_driver_posted_cmd(struct device *dev,
-       struct device_attribute *attr, char *buf)
+   struct device_attribute *attr, char *buf)
 {
  struct Scsi_Host *host = class_to_shost(dev);
  struct AdapterControlBlock *acb =
-  (struct AdapterControlBlock *) host->hostdata;
+  (struct AdapterControlBlock *)host->hostdata;
  return snprintf(buf, PAGE_SIZE,
    "%4d\n",
    atomic_read(&acb->ccboutstandingcount));
@@ -281,7 +322,7 @@ arcmsr_attr_host_driver_reset(struct dev
 {
  struct Scsi_Host *host = class_to_shost(dev);
  struct AdapterControlBlock *acb =
-  (struct AdapterControlBlock *) host->hostdata;
+  (struct AdapterControlBlock *)host->hostdata;
  return snprintf(buf, PAGE_SIZE,
    "%4d\n",
    acb->num_resets);
@@ -293,19 +334,19 @@ arcmsr_attr_host_driver_abort(struct dev
 {
  struct Scsi_Host *host = class_to_shost(dev);
  struct AdapterControlBlock *acb =
-  (struct AdapterControlBlock *) host->hostdata;
+  (struct AdapterControlBlock *)host->hostdata;
  return snprintf(buf, PAGE_SIZE,
    "%4d\n",
    acb->num_aborts);
 }

 static ssize_t
-arcmsr_attr_host_fw_model(struct device *dev, struct device_attribute 
*attr,
-     char *buf)
+arcmsr_attr_host_fw_model(struct device *dev,
+   struct device_attribute *attr, char *buf)
 {
  struct Scsi_Host *host = class_to_shost(dev);
  struct AdapterControlBlock *acb =
-  (struct AdapterControlBlock *) host->hostdata;
+  (struct AdapterControlBlock *)host->hostdata;
  return snprintf(buf, PAGE_SIZE,
    "%s\n",
    acb->firm_model);
@@ -317,8 +358,7 @@ arcmsr_attr_host_fw_version(struct devic
 {
  struct Scsi_Host *host = class_to_shost(dev);
  struct AdapterControlBlock *acb =
-   (struct AdapterControlBlock *) host->hostdata;
-
+   (struct AdapterControlBlock *)host->hostdata;
  return snprintf(buf, PAGE_SIZE,
    "%s\n",
    acb->firm_version);
@@ -330,7 +370,7 @@ arcmsr_attr_host_fw_request_len(struct d
 {
  struct Scsi_Host *host = class_to_shost(dev);
  struct AdapterControlBlock *acb =
-  (struct AdapterControlBlock *) host->hostdata;
+  (struct AdapterControlBlock *)host->hostdata;

  return snprintf(buf, PAGE_SIZE,
    "%4d\n",
@@ -343,7 +383,7 @@ arcmsr_attr_host_fw_numbers_queue(struct
 {
  struct Scsi_Host *host = class_to_shost(dev);
  struct AdapterControlBlock *acb =
-  (struct AdapterControlBlock *) host->hostdata;
+  (struct AdapterControlBlock *)host->hostdata;

  return snprintf(buf, PAGE_SIZE,
    "%4d\n",
@@ -356,7 +396,7 @@ arcmsr_attr_host_fw_sdram_size(struct de
 {
  struct Scsi_Host *host = class_to_shost(dev);
  struct AdapterControlBlock *acb =
-  (struct AdapterControlBlock *) host->hostdata;
+  (struct AdapterControlBlock *)host->hostdata;

  return snprintf(buf, PAGE_SIZE,
    "%4d\n",
@@ -369,23 +409,33 @@ arcmsr_attr_host_fw_hd_channels(struct d
 {
  struct Scsi_Host *host = class_to_shost(dev);
  struct AdapterControlBlock *acb =
-  (struct AdapterControlBlock *) host->hostdata;
+  (struct AdapterControlBlock *)host->hostdata;

  return snprintf(buf, PAGE_SIZE,
    "%4d\n",
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
-static DEVICE_ATTR(host_fw_model, S_IRUGO, arcmsr_attr_host_fw_model, 
NULL);
-static DEVICE_ATTR(host_fw_version, S_IRUGO, arcmsr_attr_host_fw_version, 
NULL);
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
+++ b/drivers/scsi/arcmsr/arcmsr.h 2013-08-28 22:43:30.000000000 +0800
@@ -45,42 +45,48 @@
 #include <linux/interrupt.h>
 struct device_attribute;
 /*The limit of outstanding scsi command that firmware can handle*/
-#define ARCMSR_MAX_OUTSTANDING_CMD      256
+#define ARCMSR_MAX_OUTSTANDING_CMD  256
 #ifdef CONFIG_XEN
  #define ARCMSR_MAX_FREECCB_NUM 160
 #else
  #define ARCMSR_MAX_FREECCB_NUM 320
 #endif
-#define ARCMSR_DRIVER_VERSION       "Driver Version 1.20.00.15 2010/08/05"
-#define ARCMSR_SCSI_INITIATOR_ID      255
-#define ARCMSR_MAX_XFER_SECTORS       512
-#define ARCMSR_MAX_XFER_SECTORS_B      4096
-#define ARCMSR_MAX_XFER_SECTORS_C      304
-#define ARCMSR_MAX_TARGETID       17
-#define ARCMSR_MAX_TARGETLUN       8
-#define ARCMSR_MAX_CMD_PERLUN                   ARCMSR_MAX_OUTSTANDING_CMD
-#define ARCMSR_MAX_QBUFFER       4096
-#define ARCMSR_DEFAULT_SG_ENTRIES      38
-#define ARCMSR_MAX_HBB_POSTQUEUE      264
-#define ARCMSR_MAX_XFER_LEN       0x26000 /* 152K */
-#define ARCMSR_CDB_SG_PAGE_LENGTH      256
+#define ARCMSR_DRIVER_VERSION  "v1.30.00.03 2013/08/28"
+#define ARCMSR_SCSI_INITIATOR_ID  255
+#define ARCMSR_MAX_XFER_SECTORS  512
+#define ARCMSR_MAX_XFER_SECTORS_B  4096
+#define ARCMSR_MAX_XFER_SECTORS_C  304
+#define ARCMSR_MAX_TARGETID   17
+#define ARCMSR_MAX_TARGETLUN   8
+#define ARCMSR_MAX_CMD_PERLUN   ARCMSR_MAX_OUTSTANDING_CMD
+#define ARCMSR_MAX_QBUFFER   4096
+#define ARCMSR_DEFAULT_SG_ENTRIES  38
+#define ARCMSR_MAX_HBB_POSTQUEUE  264
+#define ARCMSR_MAX_ARC1214_POSTQUEUE  256
+#define ARCMSR_MAX_ARC1214_DONEQUEUE  257
+#define ARCMSR_MAX_XFER_LEN   0x26000
+#define ARCMSR_CDB_SG_PAGE_LENGTH  256
+#define ARCMST_NUM_MSIX_VECTORS  4
 #ifndef PCI_DEVICE_ID_ARECA_1880
-#define PCI_DEVICE_ID_ARECA_1880 0x1880
- #endif
+ #define PCI_DEVICE_ID_ARECA_1880 0x1880
+#endif
+#ifndef PCI_DEVICE_ID_ARECA_1214
+ #define PCI_DEVICE_ID_ARECA_1214 0x1214
+#endif
 /*
 ********************************************************************************** ** ********************************************************************************** */-#define ARC_SUCCESS                                                       0-#define ARC_FAILURE                                                       1+#define ARC_SUCCESS    0+#define ARC_FAILURE    1 /* ******************************************************************************* **        split 64bits dma addressing ******************************************************************************* */-#define dma_addr_hi32(addr)               (uint32_t) ((addr>>16)>>16)-#define dma_addr_lo32(addr)               (uint32_t) (addr & 0xffffffff)+#define dma_addr_hi32(addr) (uint32_t)((addr >> 16) >> 16)+#define dma_addr_lo
 32(addr) (uint32_t)(addr & 0xffffffff) /* ******************************************************************************* **        MESSAGE CONTROL CODE@@ -88,12 +94,12 @@ struct device_attribute; */ struct CMD_MESSAGE {-      uint32_t HeaderLength;-      uint8_t  Signature[8];-      uint32_t Timeout;-      uint32_t ControlCode;-      uint32_t ReturnCode;-      uint32_t Length;+ uint32_t HeaderLength;+ uint8_t Signature[8];+ uint32_t Timeout;+ uint32_t ControlCode;+ uint32_t ReturnCode;+ uint32_t Length; }; /* *******************************************************************************@@ -102,8 +108,8 @@ struct CMD_MESSAGE */ struct CMD_MESSAGE_FIELD {-    struct CMD_MESSAGE   cmdmessage;-    uint8_t    messagedatabuffer[1032];+ struct CMD_MESSAGE cmdmessage;+ uint8_t messagedatabuffe
 r[1032]; }; /* IOP message transfer */ #define ARCMSR_MESSAGE_FAIL   0x0001@@ -111,57 +117,57 @@ struct CMD_MESSAGE_FIELD #define ARECA_SATA_RAID    0x90000000 /* FunctionCode */ #define FUNCTION_READ_RQBUFFER   0x0801-#define FUNCTION_WRITE_WQBUFFER   0x0802-#define FUNCTION_CLEAR_RQBUFFER   0x0803-#define FUNCTION_CLEAR_WQBUFFER   0x0804+#define FUNCTION_WRITE_WQBUFFER  0x0802+#define FUNCTION_CLEAR_RQBUFFER  0x0803+#define FUNCTION_CLEAR_WQBUFFER  0x0804 #define FUNCTION_CLEAR_ALLQBUFFER  0x0805-#define FUNCTION_RETURN_CODE_3F   0x0806+#define FUNCTION_RETURN_CODE_3F  0x0806 #define FUNCTION_SAY_HELLO   0x0807 #define FUNCTION_SAY_GOODBYE   0x0808 #define FUNCTION_FLUSH_ADAPTER_CACHE  0x0809-#define FUNCTION_GET_FIRMWARE_STATUS   0x080A-#define FUNCTION_HARDWARE_RESET   0x080B+#define
  FUNCTION_GET_FIRMWARE_STATUS  0x080A+#define FUNCTION_HARDWARE_RESET  0x080B /* ARECA IO CONTROL CODE*/-#define ARCMSR_MESSAGE_READ_RQBUFFER       \- ARECA_SATA_RAID | FUNCTION_READ_RQBUFFER-#define ARCMSR_MESSAGE_WRITE_WQBUFFER      \- ARECA_SATA_RAID | FUNCTION_WRITE_WQBUFFER-#define ARCMSR_MESSAGE_CLEAR_RQBUFFER      \- ARECA_SATA_RAID | FUNCTION_CLEAR_RQBUFFER-#define ARCMSR_MESSAGE_CLEAR_WQBUFFER      \- ARECA_SATA_RAID | FUNCTION_CLEAR_WQBUFFER-#define ARCMSR_MESSAGE_CLEAR_ALLQBUFFER    \- ARECA_SATA_RAID | FUNCTION_CLEAR_ALLQBUFFER-#define ARCMSR_MESSAGE_RETURN_CODE_3F      \- ARECA_SATA_RAID | FUNCTION_RETURN_CODE_3F-#define ARCMSR_MESSAGE_SAY_HELLO           \- ARECA_SATA_RAID | FUNCTION_SAY_HELLO-#define ARCMSR_MESSAGE_SAY_GOODBYE         \- ARECA_SATA_RAID | FUNCTION_SAY_GOOD
 BYE-#define ARCMSR_MESSAGE_FLUSH_ADAPTER_CACHE \- ARECA_SATA_RAID | FUNCTION_FLUSH_ADAPTER_CACHE+#define ARCMSR_MESSAGE_READ_RQBUFFER  \+ (ARECA_SATA_RAID | FUNCTION_READ_RQBUFFER)+#define ARCMSR_MESSAGE_WRITE_WQBUFFER \+ (ARECA_SATA_RAID | FUNCTION_WRITE_WQBUFFER)+#define ARCMSR_MESSAGE_CLEAR_RQBUFFER \+ (ARECA_SATA_RAID | FUNCTION_CLEAR_RQBUFFER)+#define ARCMSR_MESSAGE_CLEAR_WQBUFFER \+ (ARECA_SATA_RAID | FUNCTION_CLEAR_WQBUFFER)+#define ARCMSR_MESSAGE_CLEAR_ALLQBUFFER \+ (ARECA_SATA_RAID | FUNCTION_CLEAR_ALLQBUFFER)+#define ARCMSR_MESSAGE_RETURN_CODE_3F \+ (ARECA_SATA_RAID | FUNCTION_RETURN_CODE_3F)+#define ARCMSR_MESSAGE_SAY_HELLO  \+ (ARECA_SATA_RAID | FUNCTION_SAY_HELLO)+#define ARCMSR_MESSAGE_SAY_GOODBYE  \+ (ARECA_SATA_RAID | FUNCTION_SAY_GOODBYE)+#define ARCMSR_MESSAGE_FLUSH_ADA
 PTER_CACHE \+ (ARECA_SATA_RAID | FUNCTION_FLUSH_ADAPTER_CACHE) /* ARECA IOCTL ReturnCode */-#define ARCMSR_MESSAGE_RETURNCODE_OK  0x00000001+#define ARCMSR_MESSAGE_RETURNCODE_OK   0x00000001 #define ARCMSR_MESSAGE_RETURNCODE_ERROR  0x00000006-#define ARCMSR_MESSAGE_RETURNCODE_3F  0x0000003F+#define ARCMSR_MESSAGE_RETURNCODE_3F   0x0000003F #define ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON 0x00000088 /* ************************************************************* **   structure for holding DMA address data ************************************************************* */-#define IS_DMA64   (sizeof(dma_addr_t) == 8)-#define IS_SG64_ADDR                0x01000000 /* bit24 */+#define IS_DMA64  (sizeof(dma_addr_t) == 8)+#define IS_SG64_ADDR 0x01000000 /* bit24 */ struct  SG32ENTRY {- __le32     l
 ength;- __le32     address;+ __le32 length;+ __le32 address; }__attribute__ ((packed)); struct  SG64ENTRY {- __le32     length;- __le32     address;- __le32     addresshigh;+ __le32 length;+ __le32 address;+ __le32 addresshigh; }__attribute__ ((packed)); /* ********************************************************************@@ -170,8 +176,8 @@ struct  SG64ENTRY */ struct QBUFFER {- uint32_t      data_len;- uint8_t       data[124];+ uint32_t data_len;+ uint8_t data[124]; }; /* *******************************************************************************@@ -180,50 +186,50 @@ struct QBUFFER */ struct FIRMWARE_INFO {- uint32_t      signature;  /*0, 00-03*/- uint32_t      request_len;  /*1, 04-07*/- uint32_t      numbers_queue;  /*2, 08-11*/- uint32_t      sdram_size;               /*3, 12-
 15*/- uint32_t      ide_channels;  /*4, 16-19*/- char          vendor[40];  /*5, 20-59*/- char          model[8];   /*15, 60-67*/- char          firmware_ver[16];      /*17, 68-83*/- char          device_map[16];  /*21, 84-99*/- uint32_t  cfgVersion;                /*25,100-103 Added for checking ofnew firmware capability*/- uint8_t  cfgSerial[16];            /*26,104-119*/- uint32_t  cfgPicStatus;             /*30,120-123*/+ uint32_t signature; /*0, 00-03*/+ uint32_t request_len; /*1, 04-07*/+ uint32_t numbers_queue; /*2, 08-11*/+ uint32_t sdram_size; /*3, 12-15*/+ uint32_t ide_channels; /*4, 16-19*/+ char vendor[40];  /*5, 20-59*/+ char model[8];  /*15, 60-67*/+ char firmware_ver[16]; /*17, 68-83*/+ char device_map[16]; /*21, 84-99*/+ uint32_t cfgVersion; /*25, 100-103*/+ uint8_t cfgSe
 rial[16]; /*26, 104-119*/+ uint32_t cfgPicStatus; /*30, 120-123*/ }; /* signature of set and get firmware config */-#define ARCMSR_SIGNATURE_GET_CONFIG        0x87974060-#define ARCMSR_SIGNATURE_SET_CONFIG        0x87974063+#define ARCMSR_SIGNATURE_GET_CONFIG  0x87974060+#define ARCMSR_SIGNATURE_SET_CONFIG  0x87974063 /* message code of inbound message register */-#define ARCMSR_INBOUND_MESG0_NOP        0x00000000-#define ARCMSR_INBOUND_MESG0_GET_CONFIG        0x00000001-#define ARCMSR_INBOUND_MESG0_SET_CONFIG               0x00000002-#define ARCMSR_INBOUND_MESG0_ABORT_CMD                0x00000003-#define ARCMSR_INBOUND_MESG0_STOP_BGRB                0x00000004-#define ARCMSR_INBOUND_MESG0_FLUSH_CACHE              0x00000005-#define ARCMSR_INBOUND_MESG0_START_BGRB               0x000000
 06-#define ARCMSR_INBOUND_MESG0_CHK331PENDING            0x00000007-#define ARCMSR_INBOUND_MESG0_SYNC_TIMER               0x00000008+#define ARCMSR_INBOUND_MESG0_NOP  0x00000000+#define ARCMSR_INBOUND_MESG0_GET_CONFIG 0x00000001+#define ARCMSR_INBOUND_MESG0_SET_CONFIG 0x00000002+#define ARCMSR_INBOUND_MESG0_ABORT_CMD 0x00000003+#define ARCMSR_INBOUND_MESG0_STOP_BGRB 0x00000004+#define ARCMSR_INBOUND_MESG0_FLUSH_CACHE 0x00000005+#define ARCMSR_INBOUND_MESG0_START_BGRB 0x00000006+#define ARCMSR_INBOUND_MESG0_CHK331PENDING 0x00000007+#define ARCMSR_INBOUND_MESG0_SYNC_TIMER 0x00000008 /* doorbell interrupt generator */-#define ARCMSR_INBOUND_DRIVER_DATA_WRITE_OK           0x00000001-#define ARCMSR_INBOUND_DRIVER_DATA_READ_OK            0x00000002-#define ARCMSR_OUTBOUND_IOP331_DATA_WRITE_OK 
          0x00000001-#define ARCMSR_OUTBOUND_IOP331_DATA_READ_OK           0x00000002+#define ARCMSR_INBOUND_DRIVER_DATA_WRITE_OK 0x00000001+#define ARCMSR_INBOUND_DRIVER_DATA_READ_OK 0x00000002+#define ARCMSR_OUTBOUND_IOP331_DATA_WRITE_OK 0x00000001+#define ARCMSR_OUTBOUND_IOP331_DATA_READ_OK 0x00000002 /* ccb areca cdb flag */-#define ARCMSR_CCBPOST_FLAG_SGL_BSIZE                 0x80000000-#define ARCMSR_CCBPOST_FLAG_IAM_BIOS                  0x40000000-#define ARCMSR_CCBREPLY_FLAG_IAM_BIOS                 0x40000000-#define ARCMSR_CCBREPLY_FLAG_ERROR_MODE0              0x10000000-#define ARCMSR_CCBREPLY_FLAG_ERROR_MODE1              0x00000001+#define ARCMSR_CCBPOST_FLAG_SGL_BSIZE  0x80000000+#define ARCMSR_CCBPOST_FLAG_IAM_BIOS  0x40000000+#define ARCMSR_CCBREPLY_FLAG_IAM_BIOS  0x400
 00000+#define ARCMSR_CCBREPLY_FLAG_ERROR_MODE0 0x10000000+#define ARCMSR_CCBREPLY_FLAG_ERROR_MODE1 0x00000001 /* outbound firmware ok */-#define ARCMSR_OUTBOUND_MESG1_FIRMWARE_OK             0x80000000+#define ARCMSR_OUTBOUND_MESG1_FIRMWARE_OK 0x80000000 /* ARC-1680 Bus Reset*/-#define ARCMSR_ARC1680_BUS_RESET    0x00000003+#define ARCMSR_ARC1680_BUS_RESET  0x00000003 /* ARC-1880 Bus Reset*/-#define ARCMSR_ARC1880_RESET_ADAPTER    0x00000024-#define ARCMSR_ARC1880_DiagWrite_ENABLE   0x00000080+#define ARCMSR_ARC1880_RESET_ADAPTER  0x00000024+#define ARCMSR_ARC1880_DiagWrite_ENABLE 0x00000080 /* ************************************************************************@@ -232,98 +238,101 @@ struct FIRMWARE_INFO */ /* ARECA HBB COMMAND for its FIRMWARE */ /* window of "instruction flags" fro
 m driver to iop */-#define ARCMSR_DRV2IOP_DOORBELL                       0x00020400-#define ARCMSR_DRV2IOP_DOORBELL_MASK                  0x00020404+#define ARCMSR_DRV2IOP_DOORBELL  0x00020400+#define ARCMSR_DRV2IOP_DOORBELL_MASK  0x00020404 /* window of "instruction flags" from iop to driver */-#define ARCMSR_IOP2DRV_DOORBELL                       0x00020408-#define ARCMSR_IOP2DRV_DOORBELL_MASK                  0x0002040C+#define ARCMSR_IOP2DRV_DOORBELL  0x00020408+#define ARCMSR_IOP2DRV_DOORBELL_MASK  0x0002040C /* ARECA FLAG LANGUAGE */ /* ioctl transfer */-#define ARCMSR_IOP2DRV_DATA_WRITE_OK                  0x00000001+#define ARCMSR_IOP2DRV_DATA_WRITE_OK  0x00000001 /* ioctl transfer */-#define ARCMSR_IOP2DRV_DATA_READ_OK                   0x00000002-#define ARCMSR_IOP2DRV_CDB_DONE
                        0x00000004-#define ARCMSR_IOP2DRV_MESSAGE_CMD_DONE               0x00000008--#define ARCMSR_DOORBELL_HANDLE_INT        0x0000000F-#define ARCMSR_DOORBELL_INT_CLEAR_PATTERN          0xFF00FFF0-#define ARCMSR_MESSAGE_INT_CLEAR_PATTERN       0xFF00FFF7+#define ARCMSR_IOP2DRV_DATA_READ_OK  0x00000002+#define ARCMSR_IOP2DRV_CDB_DONE  0x00000004+#define ARCMSR_IOP2DRV_MESSAGE_CMD_DONE 0x00000008++#define ARCMSR_DOORBELL_HANDLE_INT  0x0000000F+#define ARCMSR_DOORBELL_INT_CLEAR_PATTERN 0xFF00FFF0+#define ARCMSR_MESSAGE_INT_CLEAR_PATTERN 0xFF00FFF7 /* (ARCMSR_INBOUND_MESG0_GET_CONFIG<<16)|ARCMSR_DRV2IOP_MESSAGE_CMD_POSTED)*/-#define ARCMSR_MESSAGE_GET_CONFIG        0x00010008+#define ARCMSR_MESSAGE_GET_CONFIG  0x00010008 /* (ARCMSR_INBOUND_MESG0_SET_CONFIG<<16)|ARCMSR_DRV2I
 OP_MESSAGE_CMD_POSTED)*/-#define ARCMSR_MESSAGE_SET_CONFIG        0x00020008+#define ARCMSR_MESSAGE_SET_CONFIG  0x00020008 /* (ARCMSR_INBOUND_MESG0_ABORT_CMD<<16)|ARCMSR_DRV2IOP_MESSAGE_CMD_POSTED)*/-#define ARCMSR_MESSAGE_ABORT_CMD        0x00030008+#define ARCMSR_MESSAGE_ABORT_CMD  0x00030008 /* (ARCMSR_INBOUND_MESG0_STOP_BGRB<<16)|ARCMSR_DRV2IOP_MESSAGE_CMD_POSTED)*/-#define ARCMSR_MESSAGE_STOP_BGRB        0x00040008+#define ARCMSR_MESSAGE_STOP_BGRB  0x00040008 /*(ARCMSR_INBOUND_MESG0_FLUSH_CACHE<<16)|ARCMSR_DRV2IOP_MESSAGE_CMD_POSTED) */-#define ARCMSR_MESSAGE_FLUSH_CACHE                    0x00050008+#define ARCMSR_MESSAGE_FLUSH_CACHE  0x00050008 /* (ARCMSR_INBOUND_MESG0_START_BGRB<<16)|ARCMSR_DRV2IOP_MESSAGE_CMD_POSTED)*/-#define ARCMSR_MESSAGE_START_BGRB        0x00060008-#define 
 ARCMSR_MESSAGE_START_DRIVER_MODE       0x000E0008-#define ARCMSR_MESSAGE_SET_POST_WINDOW        0x000F0008-#define ARCMSR_MESSAGE_ACTIVE_EOI_MODE      0x00100008+#define ARCMSR_MESSAGE_START_BGRB  0x00060008+#define ARCMSR_MESSAGE_START_DRIVER_MODE 0x000E0008+#define ARCMSR_MESSAGE_SET_POST_WINDOW 0x000F0008+#define ARCMSR_MESSAGE_ACTIVE_EOI_MODE 0x00100008 /* ARCMSR_OUTBOUND_MESG1_FIRMWARE_OK */-#define ARCMSR_MESSAGE_FIRMWARE_OK        0x80000000+#define ARCMSR_MESSAGE_FIRMWARE_OK  0x80000000 /* ioctl transfer */-#define ARCMSR_DRV2IOP_DATA_WRITE_OK                  0x00000001+#define ARCMSR_DRV2IOP_DATA_WRITE_OK  0x00000001 /* ioctl transfer */-#define ARCMSR_DRV2IOP_DATA_READ_OK                   0x00000002-#define ARCMSR_DRV2IOP_CDB_POSTED                     0x00000004-#define ARCM
 SR_DRV2IOP_MESSAGE_CMD_POSTED             0x00000008-#define ARCMSR_DRV2IOP_END_OF_INTERRUPT  0x00000010+#define ARCMSR_DRV2IOP_DATA_READ_OK  0x00000002+#define ARCMSR_DRV2IOP_CDB_POSTED  0x00000004+#define ARCMSR_DRV2IOP_MESSAGE_CMD_POSTED 0x00000008+#define ARCMSR_DRV2IOP_END_OF_INTERRUPT 0x00000010 /* data tunnel buffer between user space program and its firmware */ /* user space data to iop 128bytes */-#define ARCMSR_MESSAGE_WBUFFER         0x0000fe00+#define ARCMSR_MESSAGE_WBUFFER  0x0000fe00 /* iop data to user space 128bytes */-#define ARCMSR_MESSAGE_RBUFFER         0x0000ff00+#define ARCMSR_MESSAGE_RBUFFER  0x0000ff00 /* iop message_rwbuffer for message command */-#define ARCMSR_MESSAGE_RWBUFFER         0x0000fa00+#define ARCMSR_MESSAGE_RWBUFFER  0x0000fa00 /* *******************
 ***************************************************** **                SPEC. for Areca HBC adapter ************************************************************************ */-#define ARCMSR_HBC_ISR_THROTTLING_LEVEL  12-#define ARCMSR_HBC_ISR_MAX_DONE_QUEUE  20+#define ARCMSR_HBC_ISR_THROTTLING_LEVEL 12+#define ARCMSR_HBC_ISR_MAX_DONE_QUEUE 20 /* Host Interrupt Mask */-#define ARCMSR_HBCMU_UTILITY_A_ISR_MASK  0x00000001 /* When clear, theUtility_A interrupt routes to the host.*/-#define ARCMSR_HBCMU_OUTBOUND_DOORBELL_ISR_MASK 0x00000004 /* When clear,the General Outbound Doorbell interrupt routes to the host.*/-#define ARCMSR_HBCMU_OUTBOUND_POSTQUEUE_ISR_MASK 0x00000008 /* When clear,the Outbound Post List FIFO Not Empty interrupt routes to the host.*/-#define ARCMSR_HBCMU_ALL_INTMASKENA
 BLE  0x0000000D /* disable all ISR */+#define ARCMSR_HBCMU_UTILITY_A_ISR_MASK  0x00000001+#define ARCMSR_HBCMU_OUTBOUND_DOORBELL_ISR_MASK 0x00000004+#define ARCMSR_HBCMU_OUTBOUND_POSTQUEUE_ISR_MASK 0x00000008+#define ARCMSR_HBCMU_ALL_INTMASKENABLE  0x0000000D /* Host Interrupt Status */ #define ARCMSR_HBCMU_UTILITY_A_ISR   0x00000001- /*- ** Set when the Utility_A Interrupt bit is set in the Outbound DoorbellRegister.- ** It clears by writing a 1 to the Utility_A bit in the Outbound DoorbellClear Register or through automatic clearing (if enabled).- */+/*+** Set when the Utility_A Interrupt bit is set+** in the Outbound Doorbell Register.+** It clears by writing a 1 to the Utility_A+** bit in the Outbound Doorbell Clear Register+** or through automatic clearing (if enabled).+*/ #define A
 RCMSR_HBCMU_OUTBOUND_DOORBELL_ISR  0x00000004- /*- ** Set if Outbound Doorbell register bits 30:1 have a non-zero- ** value. This bit clears only when Outbound Doorbell bits- ** 30:1 are ALL clear. Only a write to the Outbound Doorbell- ** Clear register clears bits in the Outbound Doorbell register.- */+/*+** Set if Outbound Doorbell register bits 30:1 have a non-zero+** value. This bit clears only when Outbound Doorbell bits+** 30:1 are ALL clear. Only a write to the Outbound Doorbell+** Clear register clears bits in the Outbound Doorbell register.+*/ #define ARCMSR_HBCMU_OUTBOUND_POSTQUEUE_ISR 0x00000008- /*- ** Set whenever the Outbound Post List Producer/Consumer- ** Register (FIFO) is not empty. It clears when the Outbound- ** Post List FIFO is empty.- */+/*+** Set whenever the Out
 bound Post List Producer/Consumer+** Register (FIFO) is not empty. It clears when the Outbound+** Post List FIFO is empty.+*/ #define ARCMSR_HBCMU_SAS_ALL_INT   0x00000010- /*- ** This bit indicates a SAS interrupt from a source external to- ** the PCIe core. This bit is not maskable.- */- /* DoorBell*/-#define ARCMSR_HBCMU_DRV2IOP_DATA_WRITE_OK   0x00000002-#define ARCMSR_HBCMU_DRV2IOP_DATA_READ_OK   0x00000004+/*+** This bit indicates a SAS interrupt from a source external to+** the PCIe core. This bit is not maskable.+*/+/* DoorBell*/+#define ARCMSR_HBCMU_DRV2IOP_DATA_WRITE_OK  0x00000002+#define ARCMSR_HBCMU_DRV2IOP_DATA_READ_OK  0x00000004  /*inbound message 0 ready*/-#define ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE  0x00000008+#define ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE 0x00000008  
 /*more than 12 request completed in a time*/-#define ARCMSR_HBCMU_DRV2IOP_POSTQUEUE_THROTTLING  0x00000010-#define ARCMSR_HBCMU_IOP2DRV_DATA_WRITE_OK   0x00000002+#define ARCMSR_HBCMU_DRV2IOP_POSTQUEUE_THROTTLING 0x00000010+#define ARCMSR_HBCMU_IOP2DRV_DATA_WRITE_OK  0x00000002  /*outbound DATA WRITE isr door bell clear*/ #define ARCMSR_HBCMU_IOP2DRV_DATA_WRITE_DOORBELL_CLEAR 0x00000002 #define ARCMSR_HBCMU_IOP2DRV_DATA_READ_OK   0x00000004@@ -337,40 +346,89 @@ struct FIRMWARE_INFO #define ARCMSR_HBCMU_MESSAGE_FIRMWARE_OK   0x80000000 /* *******************************************************************************+**                SPEC. for Areca Type D adapter+*******************************************************************************+*/+#define ARCMSR_ARC1214_CHIP_ID     0x00004
 +#define ARCMSR_ARC1214_CPU_MEMORY_CONFIGURATION  0x00008+#define ARCMSR_ARC1214_I2_HOST_INTERRUPT_MASK  0x00034+#define ARCMSR_ARC1214_SAMPLE_RESET    0x00100+#define ARCMSR_ARC1214_RESET_REQUEST    0x00108+#define ARCMSR_ARC1214_MAIN_INTERRUPT_STATUS   0x00200+#define ARCMSR_ARC1214_PCIE_F0_INTERRUPT_ENABLE  0x0020C+#define ARCMSR_ARC1214_INBOUND_MESSAGE0   0x00400+#define ARCMSR_ARC1214_INBOUND_MESSAGE1   0x00404+#define ARCMSR_ARC1214_OUTBOUND_MESSAGE0   0x00420+#define ARCMSR_ARC1214_OUTBOUND_MESSAGE1   0x00424+#define ARCMSR_ARC1214_INBOUND_DOORBELL   0x00460+#define ARCMSR_ARC1214_OUTBOUND_DOORBELL   0x00480+#define ARCMSR_ARC1214_OUTBOUND_DOORBELL_ENABLE  0x00484+#define ARCMSR_ARC1214_INBOUND_LIST_BASE_LOW  0x01000+#define ARCMSR_ARC1214_INBOUND_LIST_BASE_HIGH  0x01004+#define A
 RCMSR_ARC1214_INBOUND_LIST_WRITE_POINTER  0x01018+#define ARCMSR_ARC1214_OUTBOUND_LIST_BASE_LOW  0x01060+#define ARCMSR_ARC1214_OUTBOUND_LIST_BASE_HIGH  0x01064+#define ARCMSR_ARC1214_OUTBOUND_LIST_COPY_POINTER  0x0106C+#define ARCMSR_ARC1214_OUTBOUND_LIST_READ_POINTER  0x01070+#define ARCMSR_ARC1214_OUTBOUND_INTERRUPT_CAUSE  0x01088+#define ARCMSR_ARC1214_OUTBOUND_INTERRUPT_ENABLE  0x0108C+#define ARCMSR_ARC1214_MESSAGE_WBUFFER   0x02000+#define ARCMSR_ARC1214_MESSAGE_RBUFFER   0x02100+#define ARCMSR_ARC1214_MESSAGE_RWBUFFER   0x02200+/* Host Interrupt Mask */+#define ARCMSR_ARC1214_ALL_INT_ENABLE    0x00001010+#define ARCMSR_ARC1214_ALL_INT_DISABLE   0x00000000+/* Host Interrupt Status */+#define ARCMSR_ARC1214_OUTBOUND_DOORBELL_ISR  0x00001000+#define ARCMSR_ARC1214_OUTBOUND_POSTQUEUE
 _ISR  0x00000010+/* DoorBell*/+#define ARCMSR_ARC1214_DRV2IOP_DATA_IN_READY   0x00000001+#define ARCMSR_ARC1214_DRV2IOP_DATA_OUT_READ  0x00000002+/*inbound message 0 ready*/+#define ARCMSR_ARC1214_IOP2DRV_DATA_WRITE_OK  0x00000001+/*outbound DATA WRITE isr door bell clear*/+#define ARCMSR_ARC1214_IOP2DRV_DATA_READ_OK   0x00000002+/*outbound message 0 ready*/+#define ARCMSR_ARC1214_IOP2DRV_MESSAGE_CMD_DONE  0x02000000+/*outbound message cmd isr door bell clear*/+/*ARCMSR_HBAMU_MESSAGE_FIRMWARE_OK*/+#define ARCMSR_ARC1214_MESSAGE_FIRMWARE_OK   0x80000000+#define ARCMSR_ARC1214_OUTBOUND_LIST_INTERRUPT_CLEAR 0x00000001+/*+******************************************************************************* **    ARECA SCSI COMMAND DESCRIPTOR BLOCK size 0x1F8 (504) *********************************
 ********************************************** */ struct ARCMSR_CDB {- uint8_t       Bus;- uint8_t       TargetID;- uint8_t       LUN;- uint8_t       Function;- uint8_t       CdbLength;- uint8_t       sgcount;- uint8_t       Flags;-#define ARCMSR_CDB_FLAG_SGL_BSIZE          0x01-#define ARCMSR_CDB_FLAG_BIOS               0x02-#define ARCMSR_CDB_FLAG_WRITE              0x04-#define ARCMSR_CDB_FLAG_SIMPLEQ            0x00-#define ARCMSR_CDB_FLAG_HEADQ              0x08-#define ARCMSR_CDB_FLAG_ORDEREDQ           0x10-- uint8_t       msgPages;- uint32_t      Context;- uint32_t      DataLength;- uint8_t       Cdb[16];- uint8_t       DeviceStatus;-#define ARCMSR_DEV_CHECK_CONDITION     0x02-#define ARCMSR_DEV_SELECT_TIMEOUT     0xF0-#define ARCMSR_DEV_ABORTED      0xF1-#define ARCMSR_DEV_INIT_
 FAIL      0xF2-- uint8_t       SenseData[15];- union- {-  struct SG32ENTRY                sg32entry[1];-  struct SG64ENTRY                sg64entry[1];+ uint8_t Bus;+ uint8_t TargetID;+ uint8_t LUN;+ uint8_t Function;+ uint8_t CdbLength;+ uint8_t sgcount;+ uint8_t Flags;+#define ARCMSR_CDB_FLAG_SGL_BSIZE 0x01+#define ARCMSR_CDB_FLAG_BIOS  0x02+#define ARCMSR_CDB_FLAG_WRITE  0x04+#define ARCMSR_CDB_FLAG_SIMPLEQ 0x00+#define ARCMSR_CDB_FLAG_HEADQ  0x08+#define ARCMSR_CDB_FLAG_ORDEREDQ 0x10++ uint8_t msgPages;+ uint32_t msgContext;+ uint32_t DataLength;+ uint8_t Cdb[16];+ uint8_t DeviceStatus;+#define ARCMSR_DEV_CHECK_CONDITION 0x02+#define ARCMSR_DEV_SELECT_TIMEOUT 0xF0+#define ARCMSR_DEV_ABORTED  0xF1+#define ARCMSR_DEV_INIT_FAIL  0xF2++ uint8_t SenseData[15];+ union {+  struct SG32ENTRY 
 sg32entry[1];+  struct SG64ENTRY sg64entry[1];  } u; }; /*@@ -380,118 +438,162 @@ struct ARCMSR_CDB */ struct MessageUnit_A {- uint32_t resrved0[4];   /*0000 000F*/- uint32_t inbound_msgaddr0;  /*0010 0013*/- uint32_t inbound_msgaddr1;  /*0014 0017*/- uint32_t outbound_msgaddr0;  /*0018 001B*/- uint32_t outbound_msgaddr1;  /*001C 001F*/- uint32_t inbound_doorbell;  /*0020 0023*/- uint32_t inbound_intstatus;  /*0024 0027*/- uint32_t inbound_intmask;  /*0028 002B*/- uint32_t outbound_doorbell;  /*002C 002F*/- uint32_t outbound_intstatus;  /*0030 0033*/- uint32_t outbound_intmask;  /*0034 0037*/- uint32_t reserved1[2];   /*0038 003F*/- uint32_t inbound_queueport;  /*0040 0043*/- uint32_t outbound_queueport;      /*0044 0047*/- uint32_t reserved2[2];   /*0048 004F*/- uint32_t reserved3[492];
    /*0050 07FF 492*/- uint32_t reserved4[128];   /*0800 09FF 128*/- uint32_t message_rwbuffer[256];  /*0a00 0DFF 256*/- uint32_t message_wbuffer[32];  /*0E00 0E7F  32*/- uint32_t reserved5[32];   /*0E80 0EFF  32*/- uint32_t message_rbuffer[32];  /*0F00 0F7F  32*/- uint32_t reserved6[32];   /*0F80 0FFF  32*/+ uint32_t resrved0[4];  /*0000 000F*/+ uint32_t inbound_msgaddr0; /*0010 0013*/+ uint32_t inbound_msgaddr1; /*0014 0017*/+ uint32_t outbound_msgaddr0; /*0018 001B*/+ uint32_t outbound_msgaddr1; /*001C 001F*/+ uint32_t inbound_doorbell;  /*0020 0023*/+ uint32_t inbound_intstatus;  /*0024 0027*/+ uint32_t inbound_intmask;  /*0028 002B*/+ uint32_t outbound_doorbell; /*002C 002F*/+ uint32_t outbound_intstatus; /*0030 0033*/+ uint32_t outbound_intmask; /*0034 0037*/+ uint32_t reserved1[2];
   /*0038 003F*/+ uint32_t inbound_queueport; /*0040 0043*/+ uint32_t outbound_queueport; /*0044 0047*/+ uint32_t reserved2[2];  /*0048 004F*/+ uint32_t reserved3[492];  /*0050 07FF 492*/+ uint32_t reserved4[128];  /*0800 09FF 128*/+ uint32_t message_rwbuffer[256]; /*0a00 0DFF 256*/+ uint32_t message_wbuffer[32]; /*0E00 0E7F  32*/+ uint32_t reserved5[32];  /*0E80 0EFF  32*/+ uint32_t message_rbuffer[32]; /*0F00 0F7F  32*/+ uint32_t reserved6[32];  /*0F80 0FFF  32*/ }; struct MessageUnit_B {- uint32_t post_qbuffer[ARCMSR_MAX_HBB_POSTQUEUE];- uint32_t done_qbuffer[ARCMSR_MAX_HBB_POSTQUEUE];- uint32_t postq_index;- uint32_t doneq_index;- uint32_t  __iomem *drv2iop_doorbell;- uint32_t  __iomem *drv2iop_doorbell_mask;- uint32_t  __iomem *iop2drv_doorbell;- uint32_t  __iomem *iop2drv_doorbell_m
 ask;- uint32_t  __iomem *message_rwbuffer;- uint32_t  __iomem *message_wbuffer;- uint32_t  __iomem *message_rbuffer;+ uint32_t post_qbuffer[ARCMSR_MAX_HBB_POSTQUEUE];+ uint32_t done_qbuffer[ARCMSR_MAX_HBB_POSTQUEUE];+ uint32_t postq_index;+ uint32_t doneq_index;+ uint32_t __iomem *drv2iop_doorbell;+ uint32_t __iomem *drv2iop_doorbell_mask;+ uint32_t __iomem *iop2drv_doorbell;+ uint32_t __iomem *iop2drv_doorbell_mask;+ uint32_t __iomem *message_rwbuffer;+ uint32_t __iomem *message_wbuffer;+ uint32_t __iomem *message_rbuffer; }; /* ********************************************************************* ** LSI ********************************************************************* */-struct MessageUnit_C{- uint32_t message_unit_status;   /*0000 0003*/- uint32_t slave_error_attribute;   /*0004 0
 007*/- uint32_t slave_error_address;   /*0008 000B*/- uint32_t posted_outbound_doorbell;  /*000C 000F*/- uint32_t master_error_attribute;   /*0010 0013*/- uint32_t master_error_address_low;  /*0014 0017*/- uint32_t master_error_address_high;  /*0018 001B*/- uint32_t hcb_size;    /*001C 001F*/- uint32_t inbound_doorbell;   /*0020 0023*/- uint32_t diagnostic_rw_data;   /*0024 0027*/- uint32_t diagnostic_rw_address_low;  /*0028 002B*/- uint32_t diagnostic_rw_address_high;  /*002C 002F*/- uint32_t host_int_status;    /*0030 0033*/- uint32_t host_int_mask;    /*0034 0037*/- uint32_t dcr_data;    /*0038 003B*/- uint32_t dcr_address;    /*003C 003F*/- uint32_t inbound_queueport;   /*0040 0043*/- uint32_t outbound_queueport;   /*0044 0047*/- uint32_t hcb_pci_address_low;   /*0048 004B*/- uint32_
 t hcb_pci_address_high;   /*004C 004F*/- uint32_t iop_int_status;    /*0050 0053*/- uint32_t iop_int_mask;    /*0054 0057*/- uint32_t iop_inbound_queue_port;   /*0058 005B*/- uint32_t iop_outbound_queue_port;  /*005C 005F*/- uint32_t inbound_free_list_index;   /*0060 0063*/- uint32_t inbound_post_list_index;   /*0064 0067*/- uint32_t outbound_free_list_index;   /*0068 006B*/- uint32_t outbound_post_list_index;   /*006C 006F*/- uint32_t inbound_doorbell_clear;   /*0070 0073*/- uint32_t i2o_message_unit_control;   /*0074 0077*/- uint32_t last_used_message_source_address_low; /*0078 007B*/- uint32_t last_used_message_source_address_high; /*007C 007F*/- uint32_t pull_mode_data_byte_count[4];  /*0080 008F*/- uint32_t message_dest_address_index;  /*0090 0093*/- uint32_t done_queue_not_empty_in
 t_counter_timer; /*0094 0097*/- uint32_t utility_A_int_counter_timer;  /*0098 009B*/- uint32_t outbound_doorbell;   /*009C 009F*/- uint32_t outbound_doorbell_clear;   /*00A0 00A3*/- uint32_t message_source_address_index;  /*00A4 00A7*/- uint32_t message_done_queue_index;  /*00A8 00AB*/- uint32_t reserved0;    /*00AC 00AF*/- uint32_t inbound_msgaddr0;   /*00B0 00B3*/- uint32_t inbound_msgaddr1;   /*00B4 00B7*/- uint32_t outbound_msgaddr0;   /*00B8 00BB*/- uint32_t outbound_msgaddr1;   /*00BC 00BF*/- uint32_t inbound_queueport_low;   /*00C0 00C3*/- uint32_t inbound_queueport_high;   /*00C4 00C7*/- uint32_t outbound_queueport_low;   /*00C8 00CB*/- uint32_t outbound_queueport_high;  /*00CC 00CF*/- uint32_t iop_inbound_queue_port_low;  /*00D0 00D3*/- uint32_t iop_inbound_queue_port_high;  /*0
 0D4 00D7*/- uint32_t iop_outbound_queue_port_low;  /*00D8 00DB*/- uint32_t iop_outbound_queue_port_high;  /*00DC 00DF*/- uint32_t message_dest_queue_port_low;  /*00E0 00E3*/- uint32_t message_dest_queue_port_high;  /*00E4 00E7*/- uint32_t last_used_message_dest_address_low; /*00E8 00EB*/- uint32_t last_used_message_dest_address_high; /*00EC 00EF*/- uint32_t message_done_queue_base_address_low; /*00F0 00F3*/- uint32_t message_done_queue_base_address_high; /*00F4 00F7*/- uint32_t host_diagnostic;    /*00F8 00FB*/- uint32_t write_sequence;    /*00FC 00FF*/- uint32_t reserved1[34];    /*0100 0187*/- uint32_t reserved2[1950];    /*0188 1FFF*/- uint32_t message_wbuffer[32];   /*2000 207F*/- uint32_t reserved3[32];    /*2080 20FF*/- uint32_t message_rbuffer[32];   /*2100 217F*/- uint32_t reserv
 ed4[32];    /*2180 21FF*/- uint32_t msgcode_rwbuffer[256];   /*2200 23FF*/+struct MessageUnit_C {+ uint32_t message_unit_status;   /*0000 0003*/+ uint32_t slave_error_attribute;   /*0004 0007*/+ uint32_t slave_error_address;   /*0008 000B*/+ uint32_t posted_outbound_doorbell;   /*000C 000F*/+ uint32_t master_error_attribute;   /*0010 0013*/+ uint32_t master_error_address_low;   /*0014 0017*/+ uint32_t master_error_address_high;  /*0018 001B*/+ uint32_t hcb_size;     /*001C 001F*/+ uint32_t inbound_doorbell;    /*0020 0023*/+ uint32_t diagnostic_rw_data;   /*0024 0027*/+ uint32_t diagnostic_rw_address_low;  /*0028 002B*/+ uint32_t diagnostic_rw_address_high;  /*002C 002F*/+ uint32_t host_int_status;    /*0030 0033*/+ uint32_t host_int_mask;    /*0034 0037*/+ uint32_t dcr_data;     /*0038 
 003B*/+ uint32_t dcr_address;    /*003C 003F*/+ uint32_t inbound_queueport;   /*0040 0043*/+ uint32_t outbound_queueport;   /*0044 0047*/+ uint32_t hcb_pci_address_low;   /*0048 004B*/+ uint32_t hcb_pci_address_high;   /*004C 004F*/+ uint32_t iop_int_status;    /*0050 0053*/+ uint32_t iop_int_mask;    /*0054 0057*/+ uint32_t iop_inbound_queue_port;   /*0058 005B*/+ uint32_t iop_outbound_queue_port;   /*005C 005F*/+ uint32_t inbound_free_list_index;   /*0060 0063*/+ uint32_t inbound_post_list_index;   /*0064 0067*/+ uint32_t outbound_free_list_index;   /*0068 006B*/+ uint32_t outbound_post_list_index;   /*006C 006F*/+ uint32_t inbound_doorbell_clear;   /*0070 0073*/+ uint32_t i2o_message_unit_control;   /*0074 0077*/+ uint32_t last_used_message_source_address_low; /*0078 007B*/+ uint32_t 
 last_used_message_source_address_high; /*007C 007F*/+ uint32_t pull_mode_data_byte_count[4];  /*0080 008F*/+ uint32_t message_dest_address_index;  /*0090 0093*/+ uint32_t done_queue_not_empty_int_counter_timer; /*0094 0097*/+ uint32_t utility_A_int_counter_timer;  /*0098 009B*/+ uint32_t outbound_doorbell;   /*009C 009F*/+ uint32_t outbound_doorbell_clear;   /*00A0 00A3*/+ uint32_t message_source_address_index;  /*00A4 00A7*/+ uint32_t message_done_queue_index;  /*00A8 00AB*/+ uint32_t reserved0;    /*00AC 00AF*/+ uint32_t inbound_msgaddr0;   /*00B0 00B3*/+ uint32_t inbound_msgaddr1;   /*00B4 00B7*/+ uint32_t outbound_msgaddr0;   /*00B8 00BB*/+ uint32_t outbound_msgaddr1;   /*00BC 00BF*/+ uint32_t inbound_queueport_low;   /*00C0 00C3*/+ uint32_t inbound_queueport_high;   /*00C4 00C7*/+ u
 int32_t outbound_queueport_low;   /*00C8 00CB*/+ uint32_t outbound_queueport_high;  /*00CC 00CF*/+ uint32_t iop_inbound_queue_port_low;  /*00D0 00D3*/+ uint32_t iop_inbound_queue_port_high;  /*00D4 00D7*/+ uint32_t iop_outbound_queue_port_low;  /*00D8 00DB*/+ uint32_t iop_outbound_queue_port_high;  /*00DC 00DF*/+ uint32_t message_dest_queue_port_low;  /*00E0 00E3*/+ uint32_t message_dest_queue_port_high;  /*00E4 00E7*/+ uint32_t last_used_message_dest_address_low; /*00E8 00EB*/+ uint32_t last_used_message_dest_address_high; /*00EC 00EF*/+ uint32_t message_done_queue_base_address_low; /*00F0 00F3*/+ uint32_t message_done_queue_base_address_high; /*00F4 00F7*/+ uint32_t host_diagnostic;    /*00F8 00FB*/+ uint32_t write_sequence;    /*00FC 00FF*/+ uint32_t reserved1[34];    /*0100 0187*/+ u
 int32_t reserved2[1950];    /*0188 1FFF*/+ uint32_t message_wbuffer[32];   /*2000 207F*/+ uint32_t reserved3[32];    /*2080 20FF*/+ uint32_t message_rbuffer[32];   /*2100 217F*/+ uint32_t reserved4[32];    /*2180 21FF*/+ uint32_t msgcode_rwbuffer[256];   /*2200 23FF*/+};+struct InBound_SRB {+ uint32_t addressLow;/*pointer to SRB block*/+ uint32_t addressHigh;+ uint32_t length;/*in DWORDs*/+ uint32_t reserved0;+};++struct OutBound_SRB {+ uint32_t addressLow;/*pointer to SRB block*/+ uint32_t addressHigh;+};++struct MessageUnit_D {+ struct InBound_SRB post_qbuffer[ARCMSR_MAX_ARC1214_POSTQUEUE];+ struct OutBound_SRB done_qbuffer[ARCMSR_MAX_ARC1214_DONEQUEUE];+ u16 postq_index;+ u16 doneq_index;+ u32 __iomem *chip_id;   /*0x00004*/+ u32 __iomem *cpu_mem_config;  /*0x00008*/+ u32 __iomem *i2o
 _host_interrupt_mask; /*0x00034*/+ u32 __iomem *sample_at_reset;  /*0x00100*/+ u32 __iomem *reset_request;  /*0x00108*/+ u32 __iomem *host_int_status;  /*0x00200*/+ u32 __iomem *pcief0_int_enable;  /*0x0020C*/+ u32 __iomem *inbound_msgaddr0;  /*0x00400*/+ u32 __iomem *inbound_msgaddr1;  /*0x00404*/+ u32 __iomem *outbound_msgaddr0;  /*0x00420*/+ u32 __iomem *outbound_msgaddr1;  /*0x00424*/+ u32 __iomem *inbound_doorbell;  /*0x00460*/+ u32 __iomem *outbound_doorbell;  /*0x00480*/+ u32 __iomem *outbound_doorbell_enable; /*0x00484*/+ u32 __iomem *inboundlist_base_low; /*0x01000*/+ u32 __iomem *inboundlist_base_high; /*0x01004*/+ u32 __iomem *inboundlist_write_pointer; /*0x01018*/+ u32 __iomem *outboundlist_base_low; /*0x01060*/+ u32 __iomem *outboundlist_base_high; /*0x01064*/+ u32 __iomem *
 outboundlist_copy_pointer; /*0x0106C*/+ u32 __iomem *outboundlist_read_pointer; /*0x01070 0x01072*/+ u32 __iomem *outboundlist_interrupt_cause; /*0x1088*/+ u32 __iomem *outboundlist_interrupt_enable; /*0x108C*/+ u32 __iomem *message_wbuffer;  /*0x2000*/+ u32 __iomem *message_rbuffer;  /*0x2100*/+ u32 __iomem *msgcode_rwbuffer;  /*0x2200*/ }; /* *******************************************************************************@@ -500,100 +602,110 @@ struct MessageUnit_C{ */ struct AdapterControlBlock {- uint32_t  adapter_type;                /* adapter A,B..... */- #define ACB_ADAPTER_TYPE_A            0x00000001 /* hba I IOP */- #define ACB_ADAPTER_TYPE_B            0x00000002 /* hbb M IOP */- #define ACB_ADAPTER_TYPE_C            0x00000004 /* hbc P IOP */- #define ACB_ADAPTER_TYPE_D      
       0x00000008 /* hbd A IOP */- struct pci_dev *  pdev;- struct Scsi_Host *  host;- unsigned long   vir2phy_offset;+ uint32_t adapter_type; /* adapter A,B..... */+ #define ACB_ADAPTER_TYPE_A 0x00000001 /* hba I IOP */+ #define ACB_ADAPTER_TYPE_B 0x00000002 /* hbb M IOP */+ #define ACB_ADAPTER_TYPE_C 0x00000004 /* hbc P IOP */+ #define ACB_ADAPTER_TYPE_D 0x00000008 /* hbd A IOP */+ u32 roundup_ccbsize;+ struct pci_dev *pdev;+ struct Scsi_Host *host;+ unsigned long vir2phy_offset;+ struct msix_entry entries[ARCMST_NUM_MSIX_VECTORS];  /* Offset is used in making arc cdb physical to virtual calculations */- uint32_t   outbound_int_enable;- uint32_t   cdb_phyaddr_hi32;- uint32_t   reg_mu_acc_handle0;- spinlock_t                         eh_lock;- spinlock_t                         ccblist_lo
 ck;+ uint32_t outbound_int_enable;+ uint32_t cdb_phyaddr_hi32;+ spinlock_t eh_lock;+ spinlock_t ccblist_lock;+ spinlock_t postq_lock;+ spinlock_t doneq_lock;+ spinlock_t rqbuffer_lock;+ spinlock_t wqbuffer_lock;  union {   struct MessageUnit_A __iomem *pmuA;-  struct MessageUnit_B  *pmuB;+  struct MessageUnit_B __iomem *pmuB;   struct MessageUnit_C __iomem *pmuC;+  struct MessageUnit_D __iomem *pmuD;  };  /* message unit ATU inbound base address0 */  void __iomem *mem_base0;  void __iomem *mem_base1;- uint32_t   acb_flags;- u16   dev_id;- uint8_t                     adapter_index;- #define ACB_F_SCSISTOPADAPTER          0x0001- #define ACB_F_MSG_STOP_BGRB      0x0002+ uint32_t acb_flags;+ u16 dev_id;+ uint8_t adapter_index;+ #define ACB_F_SCSISTOPADAPTER   0x0001+ #define ACB_F_MSG_STOP_
 BGRB   0x0002  /* stop RAID background rebuild */- #define ACB_F_MSG_START_BGRB           0x0004+ #define ACB_F_MSG_START_BGRB   0x0004  /* stop RAID background rebuild */- #define ACB_F_IOPDATA_OVERFLOW         0x0008+ #define ACB_F_IOPDATA_OVERFLOW  0x0008  /* iop message data rqbuffer overflow */  #define ACB_F_MESSAGE_WQBUFFER_CLEARED 0x0010  /* message clear wqbuffer */- #define ACB_F_MESSAGE_RQBUFFER_CLEARED  0x0020+ #define ACB_F_MESSAGE_RQBUFFER_CLEARED 0x0020  /* message clear rqbuffer */- #define ACB_F_MESSAGE_WQBUFFER_READED   0x0040- #define ACB_F_BUS_RESET                0x0080- #define ACB_F_BUS_HANG_ON  0x0800/* need hardware reset bus */+ #define ACB_F_MESSAGE_WQBUFFER_READED 0x0040+ #define ACB_F_BUS_RESET    0x0080+ #define ACB_F_BUS_HANG_ON   0x0800- #define ACB_F_IOP_
 INITED               0x0100+ #define ACB_F_IOP_INITED    0x0100  /* iop init */  #define ACB_F_ABORT    0x0200- #define ACB_F_FIRMWARE_TRAP             0x0400- struct CommandControlBlock *   pccb_pool[ARCMSR_MAX_FREECCB_NUM];+ #define ACB_F_FIRMWARE_TRAP   0x0400+ #define ACB_F_MSI_ENABLED   0x1000+ #define ACB_F_MSIX_ENABLED   0x2000+ struct CommandControlBlock *pccb_pool[ARCMSR_MAX_FREECCB_NUM];  /* used for memory free */- struct list_head  ccb_free_list;+ struct list_head ccb_free_list;  /* head of free ccb list */- atomic_t   ccboutstandingcount;+ atomic_t ccboutstandingcount;  /*The present outstanding command number that in the IOP that      waiting for being handled by FW*/- void *    dma_coherent;+ void *dma_coherent;  /* dma_coherent used for memory free */- dma_addr_t   dma_co
 herent_handle;+ dma_addr_t dma_coherent_handle;  /* dma_coherent_handle used for memory free */- dma_addr_t    dma_coherent_handle_hbb_mu;- unsigned int    uncache_size;- uint8_t    rqbuffer[ARCMSR_MAX_QBUFFER];+ dma_addr_t dma_coherent_handle2;+ void *dma_coherent2;+ unsigned int uncache_size;+ uint8_t rqbuffer[ARCMSR_MAX_QBUFFER];  /* data collection buffer for read from 80331 */- int32_t    rqbuf_firstindex;+ uint32_t rqbuf_firstindex;  /* first of read buffer  */- int32_t    rqbuf_lastindex;+ uint32_t rqbuf_lastindex;  /* last of read buffer   */- uint8_t    wqbuffer[ARCMSR_MAX_QBUFFER];+ uint8_t wqbuffer[ARCMSR_MAX_QBUFFER];  /* data collection buffer for write to 80331  */- int32_t    wqbuf_firstindex;+ uint32_t wqbuf_firstindex;  /* first of write buffer */- int32_t    wqbuf_lasti
 ndex;+ uint32_t wqbuf_lastindex;  /* last of write buffer  */- uint8_t    devstate[ARCMSR_MAX_TARGETID][ARCMSR_MAX_TARGETLUN];+ uint8_t devstate[ARCMSR_MAX_TARGETID][ARCMSR_MAX_TARGETLUN];  /* id0 ..... id15, lun0...lun7 */-#define ARECA_RAID_GONE               0x55-#define ARECA_RAID_GOOD               0xaa- uint32_t   num_resets;- uint32_t   num_aborts;- uint32_t   signature;- uint32_t   firm_request_len;- uint32_t   firm_numbers_queue;- uint32_t   firm_sdram_size;- uint32_t   firm_hd_channels;- uint32_t                            firm_cfg_version;- char   firm_model[12];- char   firm_version[20];- char   device_map[20];   /*21,84-99*/- struct work_struct   arcmsr_do_message_isr_bh;- struct timer_list  eternal_timer;- unsigned short  fw_flag;-    #define FW_NORMAL 0x0000-    #define FW
 _BOG  0x0001-    #define FW_DEADLOCK 0x0010- atomic_t    rq_map_token;- atomic_t   ante_token_value;+#define ARECA_RAID_GONE  0x55+#define ARECA_RAID_GOOD 0xaa+ uint32_t num_resets;+ uint32_t num_aborts;+ uint32_t signature;+ uint32_t firm_request_len;+ uint32_t firm_numbers_queue;+ uint32_t firm_sdram_size;+ uint32_t firm_hd_channels;+ uint32_t firm_cfg_version;+ char firm_model[12];+ char firm_version[20];+ char device_map[20]; /*21,84-99*/+ struct work_struct arcmsr_do_message_isr_bh;+ struct timer_list eternal_timer;+ unsigned short fw_flag;+ #define FW_NORMAL 0x0000+ #define FW_BOG  0x0001+ #define FW_DEADLOCK 0x0010+ atomic_t rq_map_token;+ atomic_t ante_token_value;+ uint32_t maxOutstanding; };/* HW_DEVICE_EXTENSION */ /* ***********************************************************
 ********************@@ -601,33 +713,33 @@ struct AdapterControlBlock **             this CCB length must be 32 bytes boundary ******************************************************************************* */-struct CommandControlBlock{- /*x32:sizeof struct_CCB=(32+60)byte, x64:sizeof struct_CCB=(64+60)byte*/- struct list_head  list;    /*x32: 8byte, x64: 16byte*/- struct scsi_cmnd  *pcmd;    /*8 bytes pointer of linux scsi command */- struct AdapterControlBlock *acb;    /*x32: 4byte, x64: 8byte*/- uint32_t   cdb_phyaddr_pattern;  /*x32: 4byte, x64: 4byte*/- uint32_t   arc_cdb_size;   /*x32:4byte,x64:4byte*/- uint16_t   ccb_flags;   /*x32: 2byte, x64: 2byte*/- #define   CCB_FLAG_READ   0x0000- #define   CCB_FLAG_WRITE  0x0001- #define   CCB_FLAG_ERROR  0x0002- #define   CCB_FLAG_FLUSHCAC
 HE  0x0004- #define   CCB_FLAG_MASTER_ABORTED 0x0008- uint16_t                         startdone;   /*x32:2byte,x32:2byte*/- #define   ARCMSR_CCB_DONE             0x0000- #define   ARCMSR_CCB_START  0x55AA- #define   ARCMSR_CCB_ABORTED  0xAA55- #define   ARCMSR_CCB_ILLEGAL  0xFFFF+struct CommandControlBlock {+/*x32:sizeof struct_CCB=(32+60)byte, x64:sizeof struct_CCB=(64+60)byte*/+ struct list_head list;+ struct scsi_cmnd *pcmd;+ struct AdapterControlBlock *acb;+ uint32_t cdb_phyaddr;+ uint32_t arc_cdb_size;+ uint16_t ccb_flags;+ #define CCB_FLAG_READ  0x0000+ #define CCB_FLAG_WRITE  0x0001+ #define CCB_FLAG_ERROR  0x0002+ #define CCB_FLAG_FLUSHCACHE 0x0004+ #define CCB_FLAG_MASTER_ABORTED 0x0008+ uint16_t startdone;+ #define ARCMSR_CCB_DONE 0x0000+ #define ARCMSR_CCB_START 0x55AA+ #defi
 ne ARCMSR_CCB_ABORTED 0xAA55+ #define ARCMSR_CCB_ILLEGAL 0xFFFF  #if BITS_PER_LONG == 64  /*  ======================512+64 bytes========================  */-  uint32_t                         reserved[5];  /*24 byte*/+  uint32_t reserved[5]; /*24 byte*/  #else- /*  ======================512+32 bytes========================  */-  uint32_t                         reserved;  /*8  byte*/+ /*======================512+32 bytes========================*/+  uint32_t reserved; /*8  byte*/  #endif- /*  =======================================================   */- struct ARCMSR_CDB  arcmsr_cdb;+ /*=======================================================*/+ struct ARCMSR_CDB arcmsr_cdb; }; /* *******************************************************************************@@ -636,56 +748,58 @@ struct Co
 mmandControlBlock{ */ struct SENSE_DATA {- uint8_t    ErrorCode:7;+ uint8_t ErrorCode:7; #define SCSI_SENSE_CURRENT_ERRORS 0x70 #define SCSI_SENSE_DEFERRED_ERRORS 0x71- uint8_t    Valid:1;- uint8_t    SegmentNumber;- uint8_t    SenseKey:4;- uint8_t    Reserved:1;- uint8_t    IncorrectLength:1;- uint8_t    EndOfMedia:1;- uint8_t    FileMark:1;- uint8_t    Information[4];- uint8_t    AdditionalSenseLength;- uint8_t    CommandSpecificInformation[4];- uint8_t    AdditionalSenseCode;- uint8_t    AdditionalSenseCodeQualifier;- uint8_t    FieldReplaceableUnitCode;- uint8_t    SenseKeySpecific[3];+ uint8_t Valid:1;+ uint8_t SegmentNumber;+ uint8_t SenseKey:4;+ uint8_t Reserved:1;+ uint8_t IncorrectLength:1;+ uint8_t EndOfMedia:1;+ uint8_t FileMark:1;+ uint8_t Information[4];+ uint8_t AdditionalS
 enseLength;+ uint8_t CommandSpecificInformation[4];+ uint8_t AdditionalSenseCode;+ uint8_t AdditionalSenseCodeQualifier;+ uint8_t FieldReplaceableUnitCode;+ uint8_t SenseKeySpecific[3]; }; /* ******************************************************************************* **  Outbound Interrupt Status Register - OISR ******************************************************************************* */-#define     ARCMSR_MU_OUTBOUND_INTERRUPT_STATUS_REG                 0x30-#define     ARCMSR_MU_OUTBOUND_PCI_INT                              0x10-#define     ARCMSR_MU_OUTBOUND_POSTQUEUE_INT                        0x08-#define     ARCMSR_MU_OUTBOUND_DOORBELL_INT                         0x04-#define     ARCMSR_MU_OUTBOUND_MESSAGE1_INT                         0x02-#define     ARCMSR_MU_OUTBOUND_M
 ESSAGE0_INT                         0x01-#define     ARCMSR_MU_OUTBOUND_HANDLE_INT                 \-                    (ARCMSR_MU_OUTBOUND_MESSAGE0_INT      \-                     |ARCMSR_MU_OUTBOUND_MESSAGE1_INT     \-                     |ARCMSR_MU_OUTBOUND_DOORBELL_INT     \-                     |ARCMSR_MU_OUTBOUND_POSTQUEUE_INT    \-                     |ARCMSR_MU_OUTBOUND_PCI_INT)+#define ARCMSR_MU_OUTBOUND_INTERRUPT_STATUS_REG 0x30+#define ARCMSR_MU_OUTBOUND_PCI_INT   0x10+#define ARCMSR_MU_OUTBOUND_POSTQUEUE_INT  0x08+#define ARCMSR_MU_OUTBOUND_DOORBELL_INT  0x04+#define ARCMSR_MU_OUTBOUND_MESSAGE1_INT  0x02+#define ARCMSR_MU_OUTBOUND_MESSAGE0_INT  0x01+#define ARCMSR_MU_OUTBOUND_HANDLE_INT \+ (ARCMSR_MU_OUTBOUND_MESSAGE0_INT \+ |ARCMSR_MU_OUTBOUND_MESSAGE1_INT \+ |ARCMSR_MU_OUT
 BOUND_DOORBELL_INT \+ |ARCMSR_MU_OUTBOUND_POSTQUEUE_INT \+ |ARCMSR_MU_OUTBOUND_PCI_INT) /* ******************************************************************************* **  Outbound Interrupt Mask Register - OIMR ******************************************************************************* */-#define     ARCMSR_MU_OUTBOUND_INTERRUPT_MASK_REG                   0x34-#define     ARCMSR_MU_OUTBOUND_PCI_INTMASKENABLE                    0x10-#define     ARCMSR_MU_OUTBOUND_POSTQUEUE_INTMASKENABLE              0x08-#define     ARCMSR_MU_OUTBOUND_DOORBELL_INTMASKENABLE               0x04-#define     ARCMSR_MU_OUTBOUND_MESSAGE1_INTMASKENABLE               0x02-#define     ARCMSR_MU_OUTBOUND_MESSAGE0_INTMASKENABLE               0x01-#define     ARCMSR_MU_OUTBOUND_ALL_INTMASKENABLE              
       0x1F+#define ARCMSR_MU_OUTBOUND_INTERRUPT_MASK_REG  0x34+#define ARCMSR_MU_OUTBOUND_PCI_INTMASKENABLE  0x10+#define ARCMSR_MU_OUTBOUND_POSTQUEUE_INTMASKENABLE 0x08+#define ARCMSR_MU_OUTBOUND_DOORBELL_INTMASKENABLE 0x04+#define ARCMSR_MU_OUTBOUND_MESSAGE1_INTMASKENABLE 0x02+#define ARCMSR_MU_OUTBOUND_MESSAGE0_INTMASKENABLE 0x01+#define ARCMSR_MU_OUTBOUND_ALL_INTMASKENABLE  0x1F-extern void arcmsr_post_ioctldata2iop(struct AdapterControlBlock *);-extern void arcmsr_iop_message_read(struct AdapterControlBlock *);+extern void arcmsr_write_ioctldata2iop(struct AdapterControlBlock *);+extern uint32_t arcmsr_Read_iop_rqbuffer_data(struct AdapterControlBlock *,+ struct QBUFFER __iomem *);+extern void arcmsr_clear_iop2drv_rqueue_buffer(struct AdapterControlBlock*); extern struct QBUFFER __i
 omem *arcmsr_get_iop_rqbuffer(structAdapterControlBlock *); extern struct device_attribute *arcmsr_host_attrs[]; extern int arcmsr_alloc_sysfs_attr(struct AdapterControlBlock *);diff -uprN a/drivers/scsi/arcmsr/arcmsr_hba.cb/drivers/scsi/arcmsr/arcmsr_hba.c--- a/drivers/scsi/arcmsr/arcmsr_hba.c 2013-07-01 06:13:28.000000000 +0800+++ b/drivers/scsi/arcmsr/arcmsr_hba.c 2013-08-29 01:35:44.000000000 +0800@@ -2,7 +2,7 @@ ******************************************************************************* **        O.S   : Linux **   FILE NAME  : arcmsr_hba.c-**        BY    : Nick Cheng+**        BY    : Nick Cheng, C.L. Huang **   Description: SCSI RAID Device Driver for **                ARECA RAID Host adapter *******************************************************************************@@ -7
 0,15 +70,15 @@ #include <scsi/scsi_transport.h> #include <scsi/scsicam.h> #include "arcmsr.h"-MODULE_AUTHOR("Nick Cheng <support@areca.com.tw>");-MODULE_DESCRIPTION("ARECA (ARC11xx/12xx/16xx/1880) SATA/SAS RAID Host BusAdapter");+MODULE_AUTHOR("Nick Cheng, Ching Huang <support@areca.com.tw>");+MODULE_DESCRIPTION("Areca SAS,SATA RAID Controller Driver"); MODULE_LICENSE("Dual BSD/GPL"); MODULE_VERSION(ARCMSR_DRIVER_VERSION);-#define ARCMSR_SLEEPTIME 10-#define ARCMSR_RETRYCOUNT 12+#define ARCMSR_SLEEPTIME 10+#define ARCMSR_RETRYCOUNT 12-wait_queue_head_t wait_q;+static wait_queue_head_t wait_q; static int arcmsr_iop_message_xfer(struct AdapterControlBlock *acb,      struct scsi_cmnd *cmd); static int arcmsr_iop_confirm(struct AdapterControlBlock *acb);@@ -89,22 +89,27 @@ static int arcmsr_
 bios_param(struct scsi static int arcmsr_queue_command(struct Scsi_Host *h, struct scsi_cmnd*cmd); static int arcmsr_probe(struct pci_dev *pdev,     const struct pci_device_id *id);+static int arcmsr_suspend(struct pci_dev *pdev, pm_message_t state);+static int arcmsr_resume(struct pci_dev *pdev); static void arcmsr_remove(struct pci_dev *pdev); static void arcmsr_shutdown(struct pci_dev *pdev); static void arcmsr_iop_init(struct AdapterControlBlock *acb); static void arcmsr_free_ccb_pool(struct AdapterControlBlock *acb); static u32 arcmsr_disable_outbound_ints(struct AdapterControlBlock *acb);+static void arcmsr_enable_outbound_ints(struct AdapterControlBlock *acb,+ u32 orig_mask); static void arcmsr_stop_adapter_bgrb(struct AdapterControlBlock *acb);-static void arcmsr_flush_hba_cache(
 struct AdapterControlBlock *acb);-static void arcmsr_flush_hbb_cache(struct AdapterControlBlock *acb);+static void arcmsr_hbaA_flush_cache(struct AdapterControlBlock *acb);+static void arcmsr_hbaB_flush_cache(struct AdapterControlBlock *acb); static void arcmsr_request_device_map(unsigned long pacb);-static void arcmsr_request_hba_device_map(struct AdapterControlBlock *acb);-static void arcmsr_request_hbb_device_map(struct AdapterControlBlock *acb);-static void arcmsr_request_hbc_device_map(struct AdapterControlBlock *acb);+static void arcmsr_hbaA_request_device_map(struct AdapterControlBlock*acb);+static void arcmsr_hbaB_request_device_map(struct AdapterControlBlock*acb);+static void arcmsr_hbaC_request_device_map(struct AdapterControlBlock*acb); static void arcmsr_message_isr_bh_fn(str
 uct work_struct *work); static bool arcmsr_get_firmware_spec(struct AdapterControlBlock *acb); static void arcmsr_start_adapter_bgrb(struct AdapterControlBlock *acb);-static void arcmsr_hbc_message_isr(struct AdapterControlBlock *pACB);+static void arcmsr_hbaC_message_isr(struct AdapterControlBlock *pACB);+static void arcmsr_hbaD_message_isr(struct AdapterControlBlock *acb); static void arcmsr_hardware_reset(struct AdapterControlBlock *acb); static const char *arcmsr_info(struct Scsi_Host *); static irqreturn_t arcmsr_interrupt(struct AdapterControlBlock *acb);@@ -132,8 +137,6 @@ static struct scsi_host_template arcmsr_  .change_queue_depth = arcmsr_adjust_disk_queue_depth,  .can_queue  = ARCMSR_MAX_FREECCB_NUM,  .this_id   = ARCMSR_SCSI_INITIATOR_ID,- .sg_tablesize          = ARCMSR_DEF
 AULT_SG_ENTRIES,- .max_sectors          = ARCMSR_MAX_XFER_SECTORS_C,  .cmd_per_lun  = ARCMSR_MAX_CMD_PERLUN,  .use_clustering  = ENABLE_CLUSTERING,  .shost_attrs  = arcmsr_host_attrs,@@ -148,13 +151,12 @@ static struct pci_device_id arcmsr_devic  {PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1201)},  {PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1202)},  {PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1210)},+ {PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1214)},  {PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1220)},  {PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1230)},  {PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1260)},  {PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1270)},  {PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_12
 80)},- {PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1380)},- {PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1381)},  {PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1680)},  {PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1681)},  {PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1880)},@@ -166,23 +168,33 @@ static struct pci_driver arcmsr_pci_driv  .id_table   = arcmsr_device_id_table,  .probe   = arcmsr_probe,  .remove   = arcmsr_remove,+  .suspend  = arcmsr_suspend,+  .resume  = arcmsr_resume,  .shutdown  = arcmsr_shutdown, }; /* **************************************************************************** **************************************************************************** */--static void arcmsr_free_hbb_mu(struct AdapterControlBlock *acb)+static voi
 d arcmsr_free_mu(struct AdapterControlBlock *acb) {  switch (acb->adapter_type) {  case ACB_ADAPTER_TYPE_A:  case ACB_ADAPTER_TYPE_C:   break;- case ACB_ADAPTER_TYPE_B:{+ case ACB_ADAPTER_TYPE_B: {+  struct MessageUnit_B __iomem *reg = acb->pmuB;   dma_free_coherent(&acb->pdev->dev,    sizeof(struct MessageUnit_B),-   acb->pmuB, acb->dma_coherent_handle_hbb_mu);+   reg, acb->dma_coherent_handle2);+  break;+ }+ case ACB_ADAPTER_TYPE_D: {+  dma_free_coherent(&acb->pdev->dev,+   acb->roundup_ccbsize,+   acb->dma_coherent2,+   acb->dma_coherent_handle2);+  break;  }  } }@@ -190,44 +202,73 @@ static void arcmsr_free_hbb_mu(struct Ad static bool arcmsr_remap_pciregion(struct AdapterControlBlock *acb) {  struct pci_dev *pdev = acb->pdev;- switch (acb->adapter_type){- case ACB_ADAPTER_TYPE_A:{- 
  acb->pmuA = ioremap(pci_resource_start(pdev,0),pci_resource_len(pdev,0));+ switch (acb->adapter_type) {+ case ACB_ADAPTER_TYPE_A: {+  acb->pmuA = ioremap(pci_resource_start(pdev, 0),+   pci_resource_len(pdev, 0));   if (!acb->pmuA) {-   printk(KERN_NOTICE "arcmsr%d: memory mapping region fail \n",acb->host->host_no);+   pr_notice("arcmsr%d: memory mapping "+    "region fail\n", acb->host->host_no);    return false;   }   break;  }- case ACB_ADAPTER_TYPE_B:{+ case ACB_ADAPTER_TYPE_B: {   void __iomem *mem_base0, *mem_base1;-  mem_base0 = ioremap(pci_resource_start(pdev, 0), pci_resource_len(pdev,0));+  mem_base0 = ioremap(pci_resource_start(pdev, 0),+   pci_resource_len(pdev, 0));   if (!mem_base0) {-   printk(KERN_NOTICE "arcmsr%d: memory mapping region fail \n",acb->host->host_no);+   
 pr_notice("arcmsr%d: memory mapping "+    "region fail\n", acb->host->host_no);    return false;   }-  mem_base1 = ioremap(pci_resource_start(pdev, 2), pci_resource_len(pdev,2));+  mem_base1 = ioremap(pci_resource_start(pdev, 2),+   pci_resource_len(pdev, 2));   if (!mem_base1) {    iounmap(mem_base0);-   printk(KERN_NOTICE "arcmsr%d: memory mapping region fail \n",acb->host->host_no);+   pr_notice("arcmsr%d: memory mapping "+    "region fail\n", acb->host->host_no);    return false;   }   acb->mem_base0 = mem_base0;   acb->mem_base1 = mem_base1;   break;  }- case ACB_ADAPTER_TYPE_C:{-  acb->pmuC = ioremap_nocache(pci_resource_start(pdev, 1),pci_resource_len(pdev, 1));+ case ACB_ADAPTER_TYPE_C: {+  acb->pmuC = ioremap_nocache(pci_resource_start(pdev, 1),+   pci_resource_len(pdev, 1));   
 if (!acb->pmuC) {-   printk(KERN_NOTICE "arcmsr%d: memory mapping region fail \n",acb->host->host_no);+   pr_notice("arcmsr%d: memory mapping "+    "region fail\n", acb->host->host_no);    return false;   }-  if (readl(&acb->pmuC->outbound_doorbell) &ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE) {-   writel(ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE_DOORBELL_CLEAR,&acb->pmuC->outbound_doorbell_clear);/*clear interrupt*/+  if (readl(&acb->pmuC->outbound_doorbell) &+   ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE) {+   writel(ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE_DOORBELL_CLEAR,+    &acb->pmuC->outbound_doorbell_clear);    return true;   }   break;  }+ case ACB_ADAPTER_TYPE_D: {+  void __iomem *mem_base0;+  unsigned long addr, range, flags;++  addr = (unsigned long)pci_resource_start(pdev, 0);+  range = pci_
 resource_len(pdev, 0);+  flags = pci_resource_flags(pdev, 0);+  if (flags & IORESOURCE_CACHEABLE)+   mem_base0 = ioremap(addr, range);+  else+   mem_base0 = ioremap_nocache(addr, range);+  if (!mem_base0) {+   pr_notice("arcmsr%d: memory mapping region fail\n",+   acb->host->host_no);+   return false;+  }+  acb->mem_base0 = mem_base0;+  break;+ }  }  return true; }@@ -235,18 +276,22 @@ static bool arcmsr_remap_pciregion(struc static void arcmsr_unmap_pciregion(struct AdapterControlBlock *acb) {  switch (acb->adapter_type) {- case ACB_ADAPTER_TYPE_A:{+ case ACB_ADAPTER_TYPE_A: {   iounmap(acb->pmuA);+  break;  }- break;- case ACB_ADAPTER_TYPE_B:{+ case ACB_ADAPTER_TYPE_B: {   iounmap(acb->mem_base0);   iounmap(acb->mem_base1);+  break;  }-- break;- case ACB_ADAPTER_TYPE_C:{+ case ACB_ADAP
 TER_TYPE_C: {   iounmap(acb->pmuC);+  break;+ }+ case ACB_ADAPTER_TYPE_D: {+  iounmap(acb->mem_base0);+  break;  }  } }@@ -264,12 +309,13 @@ static int arcmsr_bios_param(struct scsi   struct block_device *bdev, sector_t capacity, int *geom) {  int ret, heads, sectors, cylinders, total_capacity;- unsigned char *buffer;/* return copy of block device's partition table */+ unsigned char *buffer;  buffer = scsi_bios_ptable(bdev);  if (buffer) {-  ret = scsi_partsize(buffer, capacity, &geom[2], &geom[0], &geom[1]);-  kfree(buffer);+  ret = scsi_partsize(buffer, capacity, &geom[2], &geom[0],+   &geom[1]);+  kfree((const void *)buffer);   if (ret != -1)    return ret;  }@@ -288,27 +334,53 @@ static int arcmsr_bios_param(struct scsi  return 0; }-static void arcmsr_define_adapter_type(struct Adapt
 erControlBlock *acb)+static bool+arcmsr_define_adapter_type(struct AdapterControlBlock *acb) {- struct pci_dev *pdev = acb->pdev;  u16 dev_id;+ struct pci_dev *pdev = acb->pdev;+  pci_read_config_word(pdev, PCI_DEVICE_ID, &dev_id);  acb->dev_id = dev_id;  switch (dev_id) {  case 0x1880: {   acb->adapter_type = ACB_ADAPTER_TYPE_C;-  }   break;- case 0x1201: {+ }+ case 0x1200:+ case 0x1201:+ case 0x1202: {   acb->adapter_type = ACB_ADAPTER_TYPE_B;-  }   break;-- default: acb->adapter_type = ACB_ADAPTER_TYPE_A;  }+ case 0x1110:+ case 0x1120:+ case 0x1130:+ case 0x1160:+ case 0x1170:+ case 0x1210:+ case 0x1220:+ case 0x1230:+ case 0x1260:+ case 0x1280:+ case 0x1680: {+  acb->adapter_type = ACB_ADAPTER_TYPE_A;+  break;+ }+ case 0x1214: {+  acb->adapter_type = ACB_ADAPTER_TYPE_D;+  break;+ }+ 
 default: {+  pr_notice("Unknown device ID = 0x%x\n", dev_id);+  return false;+ }+ }+ return true; }-static uint8_t arcmsr_hba_wait_msgint_ready(struct AdapterControlBlock*acb)+static bool+arcmsr_hbaA_wait_msgint_ready(struct AdapterControlBlock *acb) {  struct MessageUnit_A __iomem *reg = acb->pmuA;  int i;@@ -326,9 +398,10 @@ static uint8_t arcmsr_hba_wait_msgint_re  return false; }-static uint8_t arcmsr_hbb_wait_msgint_ready(struct AdapterControlBlock*acb)+static bool+arcmsr_hbaB_wait_msgint_ready(struct AdapterControlBlock *acb) {- struct MessageUnit_B *reg = acb->pmuB;+ struct MessageUnit_B __iomem *reg = acb->pmuB;  int i;  for (i = 0; i < 2000; i++) {@@ -346,282 +419,557 @@ static uint8_t arcmsr_hbb_wait_msgint_re  return false; }-static uint8_t arcmsr_hbc_wait_msgint_ready(struct 
 AdapterControlBlock*pACB)+static bool+arcmsr_hbaC_wait_msgint_ready(struct AdapterControlBlock *pACB) {- struct MessageUnit_C *phbcmu = (struct MessageUnit_C *)pACB->pmuC;+ struct MessageUnit_C __iomem *phbcmu = pACB->pmuC;  int i;  for (i = 0; i < 2000; i++) {   if (readl(&phbcmu->outbound_doorbell)-    & ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE) {+   & ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE) {    writel(ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE_DOORBELL_CLEAR,-    &phbcmu->outbound_doorbell_clear); /*clear interrupt*/+   &phbcmu->outbound_doorbell_clear);    return true;   }   msleep(10);- } /* max 20 seconds */+ }+ return false;+}+static bool+arcmsr_hbaD_wait_msgint_ready(struct AdapterControlBlock *pACB)+{+ int i;+ struct MessageUnit_D __iomem *reg = pACB->pmuD;+ for (i = 0; i < 2000; i++) {
 +  if (readl(reg->outbound_doorbell)+   & ARCMSR_ARC1214_IOP2DRV_MESSAGE_CMD_DONE) {+   writel(ARCMSR_ARC1214_IOP2DRV_MESSAGE_CMD_DONE,+    reg->outbound_doorbell);+   return true;+  }+  msleep(10);+ } /* max 20 seconds */  return false; }-static void arcmsr_flush_hba_cache(struct AdapterControlBlock *acb)+static void+arcmsr_hbaA_flush_cache(struct AdapterControlBlock *acb) {  struct MessageUnit_A __iomem *reg = acb->pmuA;  int retry_count = 30;  writel(ARCMSR_INBOUND_MESG0_FLUSH_CACHE, &reg->inbound_msgaddr0);  do {-  if (arcmsr_hba_wait_msgint_ready(acb))+  if (arcmsr_hbaA_wait_msgint_ready(acb))    break;   else {    retry_count--;-   printk(KERN_NOTICE "arcmsr%d: wait 'flush adapter cache' \-   timeout, retry count down = %d \n", acb->host->host_no, retry_count);+   pr_notice("arcmsr
 %d: wait 'flush adapter "+   "cache' timeout, retry count down = %d\n",+   acb->host->host_no, retry_count);   }  } while (retry_count != 0); }-static void arcmsr_flush_hbb_cache(struct AdapterControlBlock *acb)+static void+arcmsr_hbaB_flush_cache(struct AdapterControlBlock *acb) {- struct MessageUnit_B *reg = acb->pmuB;+ struct MessageUnit_B __iomem *reg = acb->pmuB;  int retry_count = 30;  writel(ARCMSR_MESSAGE_FLUSH_CACHE, reg->drv2iop_doorbell);  do {-  if (arcmsr_hbb_wait_msgint_ready(acb))+  if (arcmsr_hbaB_wait_msgint_ready(acb))    break;   else {    retry_count--;-   printk(KERN_NOTICE "arcmsr%d: wait 'flush adapter cache' \-   timeout,retry count down = %d \n", acb->host->host_no, retry_count);+   pr_notice("arcmsr%d: wait 'flush adapter "+   "cache' timeout, retry count down =
  %d\n",+   acb->host->host_no, retry_count);   }  } while (retry_count != 0); }-static void arcmsr_flush_hbc_cache(struct AdapterControlBlock *pACB)+static void+arcmsr_hbaC_flush_cache(struct AdapterControlBlock *pACB) {- struct MessageUnit_C *reg = (struct MessageUnit_C *)pACB->pmuC;- int retry_count = 30;/* enlarge wait flush adapter cache time: 10 minute*/- writel(ARCMSR_INBOUND_MESG0_FLUSH_CACHE, &reg->inbound_msgaddr0);- writel(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE, &reg->inbound_doorbell);+ struct MessageUnit_C __iomem *reg = pACB->pmuC;+ int retry_count = 6;/* enlarge wait flush adapter cache time: 10 minute */+ writel(ARCMSR_INBOUND_MESG0_FLUSH_CACHE,+  &reg->inbound_msgaddr0);+ writel(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE,+  &reg->inbound_doorbell);+ readl(&reg->inbound_doorbell
 );+ readl(&reg->inbound_msgaddr0);  do {-  if (arcmsr_hbc_wait_msgint_ready(pACB)) {+  if (arcmsr_hbaC_wait_msgint_ready(pACB))    break;-  } else {+  else {+   retry_count--;+   pr_notice("arcmsr%d: wait 'flush adapter "+   "cache' timeout, retry count down = %d\n",+   pACB->host->host_no, retry_count);+  }+ } while (retry_count != 0);+ return;+}++static void+arcmsr_hbaD_flush_cache(struct AdapterControlBlock *pACB)+{+ int retry_count = 6;+ struct MessageUnit_D __iomem *reg = pACB->pmuD;++ writel(ARCMSR_INBOUND_MESG0_FLUSH_CACHE,+  reg->inbound_msgaddr0);+ do {+  if (arcmsr_hbaD_wait_msgint_ready(pACB))+   break;+  else {    retry_count--;-   printk(KERN_NOTICE "arcmsr%d: wait 'flush adapter cache' \-   timeout,retry count down = %d \n", pACB->host->host_no, retry_count);+   pr_notice("
 arcmsr%d: wait 'flush adapter "+   "cache' timeout, retry count down = %d\n",+   pACB->host->host_no,+   retry_count);   }  } while (retry_count != 0);  return; }-static void arcmsr_flush_adapter_cache(struct AdapterControlBlock *acb)++static void+arcmsr_flush_adapter_cache(struct AdapterControlBlock *acb) {  switch (acb->adapter_type) {  case ACB_ADAPTER_TYPE_A: {-  arcmsr_flush_hba_cache(acb);-  }+  arcmsr_hbaA_flush_cache(acb);   break;-- case ACB_ADAPTER_TYPE_B: {-  arcmsr_flush_hbb_cache(acb);   }+ case ACB_ADAPTER_TYPE_B: {+  arcmsr_hbaB_flush_cache(acb);   break;+  }  case ACB_ADAPTER_TYPE_C: {-  arcmsr_flush_hbc_cache(acb);+  arcmsr_hbaC_flush_cache(acb);+  break;   }+ case ACB_ADAPTER_TYPE_D: {+  arcmsr_hbaD_flush_cache(acb);+  break;+ }  } }-static int arcmsr_alloc_ccb_pool(str
 uct AdapterControlBlock *acb)+static int+arcmsr_alloc_ccb_pool(struct AdapterControlBlock *acb) {  struct pci_dev *pdev = acb->pdev;  void *dma_coherent;  dma_addr_t dma_coherent_handle;- struct CommandControlBlock *ccb_tmp;+ struct CommandControlBlock *ccb_tmp = NULL;  int i = 0, j = 0;  dma_addr_t cdb_phyaddr;- unsigned long roundup_ccbsize;+ unsigned long roundup_ccbsize = 0;  unsigned long max_xfer_len;  unsigned long max_sg_entrys;  uint32_t  firm_config_version;- for (i = 0; i < ARCMSR_MAX_TARGETID; i++)-  for (j = 0; j < ARCMSR_MAX_TARGETLUN; j++)-   acb->devstate[i][j] = ARECA_RAID_GONE;-  max_xfer_len = ARCMSR_MAX_XFER_LEN;  max_sg_entrys = ARCMSR_DEFAULT_SG_ENTRIES;  firm_config_version = acb->firm_cfg_version;- if((firm_config_version & 0xFF) >= 3){-  max_xfer_len = (ARCMSR_CD
 B_SG_PAGE_LENGTH << ((firm_config_version >> 8)& 0xFF)) * 1024;/* max 4M byte */-  max_sg_entrys = (max_xfer_len/4096);+ if ((firm_config_version & 0xFF) >= 3) {+  max_xfer_len = (ARCMSR_CDB_SG_PAGE_LENGTH <<+   ((firm_config_version >> 8) & 0xFF)) * 1024;+  max_sg_entrys = (max_xfer_len / 4096);  }- acb->host->max_sectors = max_xfer_len/512;+ acb->host->max_sectors = max_xfer_len / 512;  acb->host->sg_tablesize = max_sg_entrys;- roundup_ccbsize = roundup(sizeof(struct CommandControlBlock) +(max_sg_entrys - 1) * sizeof(struct SG64ENTRY), 32);+ switch (acb->adapter_type) {+ case ACB_ADAPTER_TYPE_A:+  roundup_ccbsize = roundup(sizeof(struct CommandControlBlock) ++  max_sg_entrys * sizeof(struct SG64ENTRY), 32);+  break;+ case ACB_ADAPTER_TYPE_B:+ case ACB_ADAPTER_TYPE_C:+ case ACB_ADAPTER_
 TYPE_D:+  roundup_ccbsize = roundup(sizeof(struct CommandControlBlock) ++  (max_sg_entrys - 1) * sizeof(struct SG64ENTRY), 32);+  break;+ }  acb->uncache_size = roundup_ccbsize * ARCMSR_MAX_FREECCB_NUM;- dma_coherent = dma_alloc_coherent(&pdev->dev, acb->uncache_size,&dma_coherent_handle, GFP_KERNEL);- if(!dma_coherent){-  printk(KERN_NOTICE "arcmsr%d: dma_alloc_coherent got error\n",acb->host->host_no);+ dma_coherent = dma_alloc_coherent(&pdev->dev,+  acb->uncache_size, &dma_coherent_handle, GFP_KERNEL);+ if (!dma_coherent) {+  pr_notice("arcmsr%d: dma_alloc_coherent got error\n",+  acb->host->host_no);   return -ENOMEM;  }+ memset(dma_coherent, 0, acb->uncache_size);  acb->dma_coherent = dma_coherent;  acb->dma_coherent_handle = dma_coherent_handle;- memset(dma_coherent, 0, acb->uncach
 e_size);- ccb_tmp = dma_coherent;- acb->vir2phy_offset = (unsigned long)dma_coherent - (unsignedlong)dma_coherent_handle;- for(i = 0; i < ARCMSR_MAX_FREECCB_NUM; i++){-  cdb_phyaddr = dma_coherent_handle + offsetof(struct CommandControlBlock,arcmsr_cdb);-  ccb_tmp->cdb_phyaddr_pattern = ((acb->adapter_type == ACB_ADAPTER_TYPE_C)? cdb_phyaddr : (cdb_phyaddr >> 5));+ ccb_tmp = (struct CommandControlBlock *)dma_coherent;+ acb->vir2phy_offset = (unsigned long)dma_coherent -+  (unsigned long)dma_coherent_handle;+ for (i = 0; i < ARCMSR_MAX_FREECCB_NUM; i++) {+  cdb_phyaddr = dma_coherent_handle ++   offsetof(struct CommandControlBlock, arcmsr_cdb);+  switch (acb->adapter_type) {+  case ACB_ADAPTER_TYPE_A:+  case ACB_ADAPTER_TYPE_B:+   ccb_tmp->cdb_phyaddr = cdb_phyaddr >> 5;+   break;+  case 
 ACB_ADAPTER_TYPE_C:+  case ACB_ADAPTER_TYPE_D:+   ccb_tmp->cdb_phyaddr = cdb_phyaddr;+   break;+  }   acb->pccb_pool[i] = ccb_tmp;   ccb_tmp->acb = acb;   INIT_LIST_HEAD(&ccb_tmp->list);   list_add_tail(&ccb_tmp->list, &acb->ccb_free_list);-  ccb_tmp = (struct CommandControlBlock *)((unsigned long)ccb_tmp +roundup_ccbsize);+  ccb_tmp = (struct CommandControlBlock *)+  ((unsigned long)ccb_tmp + roundup_ccbsize);   dma_coherent_handle = dma_coherent_handle + roundup_ccbsize;  }+ for (i = 0; i < ARCMSR_MAX_TARGETID; i++)+  for (j = 0; j < ARCMSR_MAX_TARGETLUN; j++)+   acb->devstate[i][j] = ARECA_RAID_GONE;  return 0; }-static void arcmsr_message_isr_bh_fn(struct work_struct *work)+static void+arcmsr_message_isr_bh_fn(struct work_struct *work) {- struct AdapterControlBlock *acb = container_o
 f(work,structAdapterControlBlock, arcmsr_do_message_isr_bh);+ struct AdapterControlBlock *acb = container_of(work,+  struct AdapterControlBlock, arcmsr_do_message_isr_bh);  switch (acb->adapter_type) {-  case ACB_ADAPTER_TYPE_A: {--   struct MessageUnit_A __iomem *reg  = acb->pmuA;-   char *acb_dev_map = (char *)acb->device_map;-   uint32_t __iomem *signature = (uint32_t __iomem*)(&reg->message_rwbuffer[0]);-   char __iomem *devicemap = (char __iomem*) (&reg->message_rwbuffer[21]);-   int target, lun;-   struct scsi_device *psdev;-   char diff;--   atomic_inc(&acb->rq_map_token);-   if (readl(signature) == ARCMSR_SIGNATURE_GET_CONFIG) {-    for(target = 0; target < ARCMSR_MAX_TARGETID -1; target++) {-     diff = (*acb_dev_map)^readb(devicemap);-     if (diff != 0) {-      char temp;-    
   *acb_dev_map = readb(devicemap);-      temp =*acb_dev_map;-      for(lun = 0; lun < ARCMSR_MAX_TARGETLUN; lun++) {-       if((temp & 0x01)==1 && (diff & 0x01) == 1) {-        scsi_add_device(acb->host, 0, target, lun);-       }else if((temp & 0x01) == 0 && (diff & 0x01) == 1) {-        psdev = scsi_device_lookup(acb->host, 0, target, lun);-        if (psdev != NULL ) {-         scsi_remove_device(psdev);-         scsi_device_put(psdev);-        }+ case ACB_ADAPTER_TYPE_A: {+  struct MessageUnit_A __iomem *reg  = acb->pmuA;+  char *acb_dev_map = (char *)acb->device_map;+  uint32_t __iomem *signature = (uint32_t __iomem *)+   (&reg->message_rwbuffer[0]);+  char __iomem *devicemap = (char __iomem *)+   (&reg->message_rwbuffer[21]);+  int target, lun;+  struct scsi_device *psdev;+  char di
 ff;++  atomic_inc(&acb->rq_map_token);+  if (readl(signature) == ARCMSR_SIGNATURE_GET_CONFIG) {+   for (target = 0; target < ARCMSR_MAX_TARGETID - 1;+   target++) {+    diff = (*acb_dev_map) ^ readb(devicemap);+    if (diff != 0) {+     char temp;+     *acb_dev_map = readb(devicemap);+     temp = *acb_dev_map;+     for (lun = 0; lun <+     ARCMSR_MAX_TARGETLUN; lun++) {+      if ((temp & 0x01) == 1 &&+      (diff & 0x01) == 1) {+       scsi_add_device(acb->host,+       0, target, lun);+      } else if ((temp & 0x01) == 0+      && (diff & 0x01) == 1) {+       psdev =+       scsi_device_lookup(acb->host,+       0, target, lun);+       if (psdev != NULL) {+        scsi_remove_device(psdev);+        scsi_device_put(psdev);        }-       temp >>= 1;-       diff >>= 1;       }+      temp >>=
  1;+      diff >>= 1;      }-     devicemap++;-     acb_dev_map++;     }+    devicemap++;+    acb_dev_map++;    }-   break;   }+  break;+ }-  case ACB_ADAPTER_TYPE_B: {-   struct MessageUnit_B *reg  = acb->pmuB;-   char *acb_dev_map = (char *)acb->device_map;-   uint32_t __iomem *signature = (uint32_t__iomem*)(&reg->message_rwbuffer[0]);-   char __iomem *devicemap = (char __iomem*)(&reg->message_rwbuffer[21]);-   int target, lun;-   struct scsi_device *psdev;-   char diff;--   atomic_inc(&acb->rq_map_token);-   if (readl(signature) == ARCMSR_SIGNATURE_GET_CONFIG) {-    for(target = 0; target < ARCMSR_MAX_TARGETID -1; target++) {-     diff = (*acb_dev_map)^readb(devicemap);-     if (diff != 0) {-      char temp;-      *acb_dev_map = readb(devicemap);-      temp =*acb_dev_map;-      for(lu
 n = 0; lun < ARCMSR_MAX_TARGETLUN; lun++) {-       if((temp & 0x01)==1 && (diff & 0x01) == 1) {-        scsi_add_device(acb->host, 0, target, lun);-       }else if((temp & 0x01) == 0 && (diff & 0x01) == 1) {-        psdev = scsi_device_lookup(acb->host, 0, target, lun);-        if (psdev != NULL ) {-         scsi_remove_device(psdev);-         scsi_device_put(psdev);-        }+ case ACB_ADAPTER_TYPE_B: {+  struct MessageUnit_B __iomem *reg  = acb->pmuB;+  char *acb_dev_map = (char *)acb->device_map;+  uint32_t __iomem *signature =+   (uint32_t __iomem *)(&reg->message_rwbuffer[0]);+  char __iomem *devicemap =+   (char __iomem *)(&reg->message_rwbuffer[21]);+  int target, lun;+  struct scsi_device *psdev;+  char diff;++  atomic_inc(&acb->rq_map_token);+  if (readl(signature) == ARCMSR_SIG
 NATURE_GET_CONFIG) {+   for (target = 0; target <+   ARCMSR_MAX_TARGETID - 1; target++) {+    diff = (*acb_dev_map) ^ readb(devicemap);+    if (diff != 0) {+     char temp;+     *acb_dev_map = readb(devicemap);+     temp = *acb_dev_map;+     for (lun = 0;+     lun < ARCMSR_MAX_TARGETLUN;+     lun++) {+      if ((temp & 0x01) == 1 &&+      (diff & 0x01) == 1) {+       scsi_add_device(acb->host,+       0, target, lun);+      } else if ((temp & 0x01) == 0+      && (diff & 0x01) == 1) {+       psdev = scsi_device_lookup(acb->host,+       0, target, lun);+       if (psdev != NULL) {+        scsi_remove_device(psdev);+        scsi_device_put(psdev);        }-       temp >>= 1;-       diff >>= 1;       }+      temp >>= 1;+      diff >>= 1;      }-     devicemap++;-     acb_dev_map++;     }+    
 devicemap++;+    acb_dev_map++;    }   }-  break;-  case ACB_ADAPTER_TYPE_C: {-   struct MessageUnit_C *reg  = acb->pmuC;-   char *acb_dev_map = (char *)acb->device_map;-   uint32_t __iomem *signature = (uint32_t __iomem*)(&reg->msgcode_rwbuffer[0]);-   char __iomem *devicemap = (char __iomem *)(&reg->msgcode_rwbuffer[21]);-   int target, lun;-   struct scsi_device *psdev;-   char diff;--   atomic_inc(&acb->rq_map_token);-   if (readl(signature) == ARCMSR_SIGNATURE_GET_CONFIG) {-    for (target = 0; target < ARCMSR_MAX_TARGETID - 1; target++) {-     diff = (*acb_dev_map)^readb(devicemap);-     if (diff != 0) {-      char temp;-      *acb_dev_map = readb(devicemap);-      temp = *acb_dev_map;-      for (lun = 0; lun < ARCMSR_MAX_TARGETLUN; lun++) {-       if ((temp & 0x01) == 1 && (diff &
  0x01) == 1) {-        scsi_add_device(acb->host, 0, target, lun);-       } else if ((temp & 0x01) == 0 && (diff & 0x01) == 1) {-        psdev = scsi_device_lookup(acb->host, 0, target, lun);-        if (psdev != NULL) {-         scsi_remove_device(psdev);-         scsi_device_put(psdev);-        }+ }+ break;+ case ACB_ADAPTER_TYPE_C: {+  struct MessageUnit_C __iomem *reg  = acb->pmuC;+  char *acb_dev_map = (char *)acb->device_map;+  uint32_t __iomem *signature =+   (uint32_t __iomem *)(&reg->msgcode_rwbuffer[0]);+  char __iomem *devicemap =+   (char __iomem *)(&reg->msgcode_rwbuffer[21]);+  int target, lun;+  struct scsi_device *psdev;+  char diff;++  atomic_inc(&acb->rq_map_token);+  if (readl(signature) == ARCMSR_SIGNATURE_GET_CONFIG) {+   for (target = 0; target <+    ARCMSR_MAX_TARG
 ETID - 1; target++) {+    diff = (*acb_dev_map) ^ readb(devicemap);+    if (diff != 0) {+     char temp;+     *acb_dev_map =+      readb(devicemap);+     temp = *acb_dev_map;+     for (lun = 0; lun <+     ARCMSR_MAX_TARGETLUN; lun++) {+      if ((temp & 0x01) == 1 &&+      (diff & 0x01) == 1) {+       scsi_add_device(acb->host,+       0, target, lun);+      } else if ((temp & 0x01) == 0+      && (diff & 0x01) == 1) {+       psdev = scsi_device_lookup(acb->host,+       0, target, lun);+       if (psdev != NULL) {+        scsi_remove_device(psdev);+        scsi_device_put(psdev);+       }+      }+      temp >>= 1;+      diff >>= 1;+     }+    }+    devicemap++;+    acb_dev_map++;+   }+  }+ }+ break;+ case ACB_ADAPTER_TYPE_D: {+  struct MessageUnit_D __iomem *reg  = acb->pmuD;+  char *acb_d
 ev_map = (char *)acb->device_map;+  uint32_t __iomem *signature =+   (uint32_t __iomem *)(&reg->msgcode_rwbuffer[0]);+  char __iomem *devicemap =+   (char __iomem *)(&reg->msgcode_rwbuffer[21]);+  int target, lun;+  struct scsi_device *psdev;+  char diff;++  atomic_inc(&acb->rq_map_token);+  if (readl(signature) == ARCMSR_SIGNATURE_GET_CONFIG) {+   for (target = 0; target <+    ARCMSR_MAX_TARGETID - 1; target++) {+    diff = (*acb_dev_map) ^ readb(devicemap);+    if (diff != 0) {+     char temp;+     *acb_dev_map =+      readb(devicemap);+     temp = *acb_dev_map;+     for (lun = 0; lun <+     ARCMSR_MAX_TARGETLUN; lun++) {+      if ((temp & 0x01) == 1 &&+      (diff & 0x01) == 1) {+       scsi_add_device(acb->host,+       0, target, lun);+      } else if ((temp & 0x01) == 0+      && (di
 ff & 0x01) == 1) {+       psdev = scsi_device_lookup(acb->host,+       0, target, lun);+       if (psdev != NULL) {+        scsi_remove_device(psdev);+        scsi_device_put(psdev);        }-       temp >>= 1;-       diff >>= 1;       }+      temp >>= 1;+      diff >>= 1;      }-     devicemap++;-     acb_dev_map++;     }+    devicemap++;+    acb_dev_map++;    }   }+  break;+ }+ }+}++static int+arcmsr_suspend(struct pci_dev *pdev, pm_message_t state)+{+ int i;+ uint32_t intmask_org;+ struct Scsi_Host *host = pci_get_drvdata(pdev);+ struct AdapterControlBlock *acb =+  (struct AdapterControlBlock *)host->hostdata;++ intmask_org = arcmsr_disable_outbound_ints(acb);+ if (acb->acb_flags & ACB_F_MSI_ENABLED) {+  free_irq(pdev->irq, acb);+  pci_disable_msi(pdev);+ } else if (acb->acb_flags & A
 CB_F_MSIX_ENABLED) {+  for (i = 0; i < ARCMST_NUM_MSIX_VECTORS; i++)+   free_irq(acb->entries[i].vector, acb);+  pci_disable_msix(pdev);+ } else+  free_irq(pdev->irq, acb);+ del_timer_sync(&acb->eternal_timer);+ flush_scheduled_work();+ arcmsr_stop_adapter_bgrb(acb);+ arcmsr_flush_adapter_cache(acb);+ arcmsr_enable_outbound_ints(acb, intmask_org);+ pci_set_drvdata(pdev, host);+ pci_save_state(pdev);+ pci_disable_device(pdev);+ pci_set_power_state(pdev, pci_choose_state(pdev, state));+ return 0;+}++static int+arcmsr_resume(struct pci_dev *pdev)+{+ int error, i, j;+ struct Scsi_Host *host = pci_get_drvdata(pdev);+ struct AdapterControlBlock *acb =+  (struct AdapterControlBlock *)host->hostdata;+ struct msix_entry entries[ARCMST_NUM_MSIX_VECTORS];+ pci_set_power_state(pdev, PCI_D0);+ pci_en
 able_wake(pdev, PCI_D0, 0);+ pci_restore_state(pdev);+ if (pci_enable_device(pdev)) {+  pr_warn("%s: pci_enable_device error\n", __func__);+  return -ENODEV;+ }+ error = pci_set_dma_mask(pdev, DMA_BIT_MASK(64));+ if (error) {+  error = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));+  if (error) {+    pr_warn("scsi%d: No suitable DMA mask available\n",+          host->host_no);+   goto controller_unregister;+  }  }+ pci_set_master(pdev);+ if (pci_find_capability(pdev, PCI_CAP_ID_MSIX)) {+  if (!pci_enable_msix(pdev, entries,+   ARCMST_NUM_MSIX_VECTORS)) {+   for (i = 0; i < ARCMST_NUM_MSIX_VECTORS;+   i++) {+    entries[i].entry = i;+    if (request_irq(entries[i].vector,+    arcmsr_do_interrupt, 0,+    "arcmsr", acb)) {+     for (j = 0 ; j < i ; j++)+      free_irq(entries[i].vector,+      ac
 b);+     goto controller_stop;+    }+    acb->entries[i] = entries[i];+   }+   acb->acb_flags |= ACB_F_MSIX_ENABLED;+  } else {+   pr_warn("arcmsr%d: MSI-X "+   "failed to enable\n", acb->host->host_no);+   if (request_irq(pdev->irq,+   arcmsr_do_interrupt, IRQF_SHARED,+   "arcmsr", acb)) {+    goto controller_stop;+   }+  }+ } else if (pci_find_capability(pdev, PCI_CAP_ID_MSI)) {+  if (!pci_enable_msi(pdev))+   acb->acb_flags |= ACB_F_MSI_ENABLED;+  if (request_irq(pdev->irq, arcmsr_do_interrupt,+   IRQF_SHARED, "arcmsr", acb))+   goto controller_stop;+ } else {+  if (request_irq(pdev->irq, arcmsr_do_interrupt,+   IRQF_SHARED, "arcmsr", acb))+   goto controller_stop;+ }+ arcmsr_iop_init(acb);+ INIT_WORK(&acb->arcmsr_do_message_isr_bh,+ arcmsr_message_isr_bh_fn);+ atomic_set(&acb->rq_map
 _token, 16);+ atomic_set(&acb->ante_token_value, 16);+ acb->fw_flag = FW_NORMAL;+ init_timer(&acb->eternal_timer);+ acb->eternal_timer.expires = jiffies ++  msecs_to_jiffies(6 * HZ);+ acb->eternal_timer.data = (unsigned long) acb;+ acb->eternal_timer.function =+  &arcmsr_request_device_map;+ add_timer(&acb->eternal_timer);+ return 0;+controller_stop:+  arcmsr_stop_adapter_bgrb(acb);+  arcmsr_flush_adapter_cache(acb);+controller_unregister:+  scsi_remove_host(host);+  arcmsr_free_ccb_pool(acb);+  arcmsr_unmap_pciregion(acb);+  pci_release_regions(pdev);+  scsi_host_put(host);+  pci_disable_device(pdev);+ return -ENODEV; } static int arcmsr_probe(struct pci_dev *pdev, const struct pci_device_id*id) {  struct Scsi_Host *host;  struct AdapterControlBlock *acb;- uint8_t bus,dev_fun;- int erro
 r;+ uint8_t bus, dev_fun;+ struct msix_entry entries[ARCMST_NUM_MSIX_VECTORS];+ int error, i, j;  error = pci_enable_device(pdev);- if(error){+ if (error)   return -ENODEV;- }- host = scsi_host_alloc(&arcmsr_scsi_host_template, sizeof(structAdapterControlBlock));- if(!host){+ host = scsi_host_alloc(&arcmsr_scsi_host_template,+  sizeof(struct AdapterControlBlock));+ if (!host)       goto pci_disable_dev;- }  error = pci_set_dma_mask(pdev, DMA_BIT_MASK(64));- if(error){+ if (error) {   error = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));-  if(error){-   printk(KERN_WARNING-          "scsi%d: No suitable DMA mask available\n",+  if (error) {+   pr_warn("scsi%d: No suitable DMA mask available\n",           host->host_no);    goto scsi_host_release;   }@@ -634,70 +982,114 @@ static int arcmsr_pr
 obe(struct pci_dev *  acb->pdev = pdev;  acb->host = host;  host->max_lun = ARCMSR_MAX_TARGETLUN;- host->max_id = ARCMSR_MAX_TARGETID;  /*16:8*/- host->max_cmd_len = 16;     /*this is issue of 64bit LBA ,over 2T byte*/- host->can_queue = ARCMSR_MAX_FREECCB_NUM; /* max simultaneous cmds */- host->cmd_per_lun = ARCMSR_MAX_CMD_PERLUN;+ host->max_id = ARCMSR_MAX_TARGETID;+ host->max_cmd_len = 16;+ host->can_queue = ARCMSR_MAX_FREECCB_NUM;+ host->cmd_per_lun = ARCMSR_MAX_CMD_PERLUN;  host->this_id = ARCMSR_SCSI_INITIATOR_ID;  host->unique_id = (bus << 8) | dev_fun;  pci_set_drvdata(pdev, host);  pci_set_master(pdev);  error = pci_request_regions(pdev, "arcmsr");- if(error){+ if (error)   goto scsi_host_release;- }  spin_lock_init(&acb->eh_lock);  spin_lock_init(&acb->ccblist_lock);+ spin_lock
 _init(&acb->postq_lock);+ spin_lock_init(&acb->doneq_lock);+ spin_lock_init(&acb->rqbuffer_lock);+ spin_lock_init(&acb->wqbuffer_lock);  acb->acb_flags |= (ACB_F_MESSAGE_WQBUFFER_CLEARED |    ACB_F_MESSAGE_RQBUFFER_CLEARED |    ACB_F_MESSAGE_WQBUFFER_READED);  acb->acb_flags &= ~ACB_F_SCSISTOPADAPTER;  INIT_LIST_HEAD(&acb->ccb_free_list);- arcmsr_define_adapter_type(acb);+ error = arcmsr_define_adapter_type(acb);+ if (!error)+  goto pci_release_regs;  error = arcmsr_remap_pciregion(acb);- if(!error){+ if (!error)   goto pci_release_regs;- }  error = arcmsr_get_firmware_spec(acb);- if(!error){+ if (!error)   goto unmap_pci_region;- }  error = arcmsr_alloc_ccb_pool(acb);- if(error){+ if (error)   goto free_hbb_mu;- }- arcmsr_iop_init(acb);  error = scsi_add_host(host, &pdev->dev);- if(erro
 r){+ if (error)   goto RAID_controller_stop;- }- error = request_irq(pdev->irq, arcmsr_do_interrupt, IRQF_SHARED, "arcmsr",acb);- if(error){-  goto scsi_host_remove;+ if (pci_find_capability(pdev, PCI_CAP_ID_MSIX)) {+  if (!pci_enable_msix(pdev, entries, ARCMST_NUM_MSIX_VECTORS)) {+   for (i = 0; i < ARCMST_NUM_MSIX_VECTORS; i++) {+    entries[i].entry = i;+    if (request_irq(entries[i].vector,+     arcmsr_do_interrupt, 0, "arcmsr",+     acb)) {+     for (j = 0 ; j < i ; j++)+      free_irq(entries[i].vector,+      acb);+     goto scsi_host_remove;+    }+    acb->entries[i] = entries[i];+   }+   acb->acb_flags |= ACB_F_MSIX_ENABLED;+  } else {+   if (request_irq(pdev->irq, arcmsr_do_interrupt,+    IRQF_SHARED, "arcmsr", acb)) {+    pr_warn("arcmsr%d: request_irq = %d failed!\n",+     ac
 b->host->host_no, pdev->irq);+    goto scsi_host_remove;+   }+  }+ } else if (pci_find_capability(pdev, PCI_CAP_ID_MSI)) {+  if (!pci_enable_msi(pdev))+   acb->acb_flags |= ACB_F_MSI_ENABLED;+  if (request_irq(pdev->irq, arcmsr_do_interrupt,+   IRQF_SHARED, "arcmsr", acb)) {+   pr_warn("arcmsr%d: request_irq =%d failed!\n",+    acb->host->host_no, pdev->irq);+   goto scsi_host_remove;+  }+ } else {+  if (request_irq(pdev->irq, arcmsr_do_interrupt,+   IRQF_SHARED, "arcmsr", acb)) {+   pr_warn("arcmsr%d: request_irq = %d failed!\n",+    acb->host->host_no, pdev->irq);+   goto scsi_host_remove;+  }  }  host->irq = pdev->irq;-     scsi_scan_host(host);- INIT_WORK(&acb->arcmsr_do_message_isr_bh, arcmsr_message_isr_bh_fn);+ arcmsr_iop_init(acb);+ scsi_scan_host(host);+ INIT_WORK(&acb->arcmsr_d
 o_message_isr_bh,+  arcmsr_message_isr_bh_fn);  atomic_set(&acb->rq_map_token, 16);  atomic_set(&acb->ante_token_value, 16);  acb->fw_flag = FW_NORMAL;  init_timer(&acb->eternal_timer);- acb->eternal_timer.expires = jiffies + msecs_to_jiffies(6 * HZ);+ acb->eternal_timer.expires = jiffies ++  msecs_to_jiffies(6 * HZ);  acb->eternal_timer.data = (unsigned long) acb;- acb->eternal_timer.function = &arcmsr_request_device_map;+ acb->eternal_timer.function =+  &arcmsr_request_device_map;  add_timer(&acb->eternal_timer);- if(arcmsr_alloc_sysfs_attr(acb))+ if (arcmsr_alloc_sysfs_attr(acb))   goto out_free_sysfs;  return 0; out_free_sysfs: scsi_host_remove:+ if (acb->acb_flags & ACB_F_MSI_ENABLED)+  pci_disable_msi(pdev);+ else if (acb->acb_flags & ACB_F_MSIX_ENABLED)+  pci_disable_msix(pdev);  
 scsi_remove_host(host); RAID_controller_stop:  arcmsr_stop_adapter_bgrb(acb);  arcmsr_flush_adapter_cache(acb);  arcmsr_free_ccb_pool(acb); free_hbb_mu:- arcmsr_free_hbb_mu(acb);+ arcmsr_free_mu(acb); unmap_pci_region:  arcmsr_unmap_pciregion(acb); pci_release_regs:@@ -709,85 +1101,114 @@ pci_disable_dev:  return -ENODEV; }-static uint8_t arcmsr_abort_hba_allcmd(struct AdapterControlBlock *acb)+static uint8_t+arcmsr_hbaA_abort_allcmd(struct AdapterControlBlock *acb) {  struct MessageUnit_A __iomem *reg = acb->pmuA;- writel(ARCMSR_INBOUND_MESG0_ABORT_CMD, &reg->inbound_msgaddr0);- if (!arcmsr_hba_wait_msgint_ready(acb)) {-  printk(KERN_NOTICE-   "arcmsr%d: wait 'abort all outstanding command' timeout \n"-   , acb->host->host_no);+ writel(ARCMSR_INBOUND_MESG0_ABORT_CMD,+  &reg->inbound_msg
 addr0);+ if (!arcmsr_hbaA_wait_msgint_ready(acb)) {+  pr_notice("arcmsr%d: wait 'abort all outstanding "+  "command' timeout\n"+  , acb->host->host_no);   return false;  }  return true; }-static uint8_t arcmsr_abort_hbb_allcmd(struct AdapterControlBlock *acb)+static uint8_t+arcmsr_hbaB_abort_allcmd(struct AdapterControlBlock *acb) {- struct MessageUnit_B *reg = acb->pmuB;+ struct MessageUnit_B __iomem *reg = acb->pmuB;- writel(ARCMSR_MESSAGE_ABORT_CMD, reg->drv2iop_doorbell);- if (!arcmsr_hbb_wait_msgint_ready(acb)) {-  printk(KERN_NOTICE-   "arcmsr%d: wait 'abort all outstanding command' timeout \n"-   , acb->host->host_no);+ writel(ARCMSR_MESSAGE_ABORT_CMD,+  reg->drv2iop_doorbell);+ if (!arcmsr_hbaB_wait_msgint_ready(acb)) {+  pr_notice("arcmsr%d: wait 'abort all outstanding "+  "comm
 and' timeout\n"+  , acb->host->host_no);   return false;  }  return true; }-static uint8_t arcmsr_abort_hbc_allcmd(struct AdapterControlBlock *pACB)+static uint8_t+arcmsr_hbaC_abort_allcmd(struct AdapterControlBlock *pACB) {- struct MessageUnit_C *reg = (struct MessageUnit_C *)pACB->pmuC;+ struct MessageUnit_C __iomem *reg = pACB->pmuC;  writel(ARCMSR_INBOUND_MESG0_ABORT_CMD, &reg->inbound_msgaddr0);  writel(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE, &reg->inbound_doorbell);- if (!arcmsr_hbc_wait_msgint_ready(pACB)) {-  printk(KERN_NOTICE-   "arcmsr%d: wait 'abort all outstanding command' timeout \n"-   , pACB->host->host_no);+ if (!arcmsr_hbaC_wait_msgint_ready(pACB)) {+  pr_notice("arcmsr%d: wait 'abort all outstanding "+  "command' timeout\n"+  , pACB->host->host_no);+  return false;+ }+ 
 return true;+}+static uint8_t+arcmsr_hbaD_abort_allcmd(struct AdapterControlBlock *pACB)+{+ struct MessageUnit_D __iomem *reg = pACB->pmuD;+ writel(ARCMSR_INBOUND_MESG0_ABORT_CMD, reg->inbound_msgaddr0);+ if (!arcmsr_hbaD_wait_msgint_ready(pACB)) {+  pr_notice("arcmsr%d: wait 'abort all outstanding "+  "command' timeout\n"+  , pACB->host->host_no);   return false;  }  return true; }-static uint8_t arcmsr_abort_allcmd(struct AdapterControlBlock *acb)+static uint8_t+arcmsr_abort_allcmd(struct AdapterControlBlock *acb) {  uint8_t rtnval = 0;  switch (acb->adapter_type) {  case ACB_ADAPTER_TYPE_A: {-  rtnval = arcmsr_abort_hba_allcmd(acb);-  }+  rtnval = arcmsr_hbaA_abort_allcmd(acb);   break;+  }  case ACB_ADAPTER_TYPE_B: {-  rtnval = arcmsr_abort_hbb_allcmd(acb);-  }+  rtnval = arcmsr_hbaB
 _abort_allcmd(acb);   break;+  }  case ACB_ADAPTER_TYPE_C: {-  rtnval = arcmsr_abort_hbc_allcmd(acb);+  rtnval = arcmsr_hbaC_abort_allcmd(acb);+  break;+  }++ case ACB_ADAPTER_TYPE_D: {+  rtnval = arcmsr_hbaD_abort_allcmd(acb);+  break;   }  }  return rtnval; }-static bool arcmsr_hbb_enable_driver_mode(struct AdapterControlBlock *pacb)+static bool+arcmsr_hbb_enable_driver_mode(struct AdapterControlBlock *pacb) {- struct MessageUnit_B *reg = pacb->pmuB;- writel(ARCMSR_MESSAGE_START_DRIVER_MODE, reg->drv2iop_doorbell);- if (!arcmsr_hbb_wait_msgint_ready(pacb)) {-  printk(KERN_ERR "arcmsr%d: can't set driver mode. \n",pacb->host->host_no);+ struct MessageUnit_B __iomem *reg = pacb->pmuB;+ writel(ARCMSR_MESSAGE_START_DRIVER_MODE,+  reg->drv2iop_doorbell);+ if (!arcmsr_hbaB_wait_msgint_ready(
 pacb)) {+  pr_err("arcmsr%d: can't set driver mode.\n",+   pacb->host->host_no);   return false;  }      return true; }-static void arcmsr_pci_unmap_dma(struct CommandControlBlock *ccb)+static void+arcmsr_pci_unmap_dma(struct CommandControlBlock *ccb) {  struct scsi_cmnd *pcmd = ccb->pcmd;-  scsi_dma_unmap(pcmd); }-static void arcmsr_ccb_complete(struct CommandControlBlock *ccb)+static void+arcmsr_ccb_complete(struct CommandControlBlock *ccb) {  struct AdapterControlBlock *acb = ccb->acb;  struct scsi_cmnd *pcmd = ccb->pcmd;@@ -801,52 +1222,68 @@ static void arcmsr_ccb_complete(struct C  pcmd->scsi_done(pcmd); }-static void arcmsr_report_sense_info(struct CommandControlBlock *ccb)+static void+arcmsr_report_sense_info(struct CommandControlBlock *ccb) {  struct scsi_cmnd *pcmd = ccb->pcmd;
 - struct SENSE_DATA *sensebuffer = (struct SENSE_DATA *)pcmd->sense_buffer;- pcmd->result = DID_OK << 16;+ struct SENSE_DATA *sensebuffer =+  (struct SENSE_DATA *)pcmd->sense_buffer;+ pcmd->result = (DID_OK << 16) | (CHECK_CONDITION << 1)+  | (DRIVER_SENSE << 24);  if (sensebuffer) {   int sense_data_length =    sizeof(struct SENSE_DATA) < SCSI_SENSE_BUFFERSIZE    ? sizeof(struct SENSE_DATA) : SCSI_SENSE_BUFFERSIZE;   memset(sensebuffer, 0, SCSI_SENSE_BUFFERSIZE);-  memcpy(sensebuffer, ccb->arcmsr_cdb.SenseData, sense_data_length);+  memcpy((void *)sensebuffer, (const void *)ccb->arcmsr_cdb.SenseData,+   sense_data_length);   sensebuffer->ErrorCode = SCSI_SENSE_CURRENT_ERRORS;   sensebuffer->Valid = 1;  } }-static u32 arcmsr_disable_outbound_ints(struct AdapterControlBlock *acb)+static u
 32+arcmsr_disable_outbound_ints(struct AdapterControlBlock *acb) {  u32 orig_mask = 0;  switch (acb->adapter_type) {  case ACB_ADAPTER_TYPE_A : {   struct MessageUnit_A __iomem *reg = acb->pmuA;   orig_mask = readl(&reg->outbound_intmask);-  writel(orig_mask|ARCMSR_MU_OUTBOUND_ALL_INTMASKENABLE, \-      &reg->outbound_intmask);+  writel(orig_mask |+   ARCMSR_MU_OUTBOUND_ALL_INTMASKENABLE,+   &reg->outbound_intmask);   }   break;  case ACB_ADAPTER_TYPE_B : {-  struct MessageUnit_B *reg = acb->pmuB;+  struct MessageUnit_B __iomem *reg = acb->pmuB;   orig_mask = readl(reg->iop2drv_doorbell_mask);   writel(0, reg->iop2drv_doorbell_mask);   }   break;- case ACB_ADAPTER_TYPE_C:{-  struct MessageUnit_C *reg = (struct MessageUnit_C *)acb->pmuC;+ case ACB_ADAPTER_TYPE_C: {+  struct MessageUnit_C 
 __iomem *reg = acb->pmuC;   /* disable all outbound interrupt */-  orig_mask = readl(&reg->host_int_mask); /* disable outbound message0 int*/-  writel(orig_mask|ARCMSR_HBCMU_ALL_INTMASKENABLE, &reg->host_int_mask);+  orig_mask = readl(&reg->host_int_mask);+  writel(orig_mask | ARCMSR_HBCMU_ALL_INTMASKENABLE,+   &reg->host_int_mask);+  readl(&reg->host_int_mask);   }   break;+ case ACB_ADAPTER_TYPE_D: {+  struct MessageUnit_D __iomem *reg = acb->pmuD;+  /* disable all outbound interrupt */+  writel(ARCMSR_ARC1214_ALL_INT_DISABLE,+  reg->pcief0_int_enable);+  break;+ }  }  return orig_mask; }-static void arcmsr_report_ccb_state(struct AdapterControlBlock *acb,+static void+arcmsr_report_ccb_state(struct AdapterControlBlock *acb,    struct CommandControlBlock *ccb, bool error) {  uint8_t id,
  lun;@@ -857,7 +1294,7 @@ static void arcmsr_report_ccb_state(stru    acb->devstate[id][lun] = ARECA_RAID_GOOD;   ccb->pcmd->result = DID_OK << 16;   arcmsr_ccb_complete(ccb);- }else{+ } else {   switch (ccb->arcmsr_cdb.DeviceStatus) {   case ARCMSR_DEV_SELECT_TIMEOUT: {    acb->devstate[id][lun] = ARECA_RAID_GONE;@@ -883,53 +1320,47 @@ static void arcmsr_report_ccb_state(stru    break;   default:-   printk(KERN_NOTICE-    "arcmsr%d: scsi id = %d lun = %d isr get command error done, \-    but got unknown DeviceStatus = 0x%x \n"-    , acb->host->host_no-    , id-    , lun-    , ccb->arcmsr_cdb.DeviceStatus);-    acb->devstate[id][lun] = ARECA_RAID_GONE;-    ccb->pcmd->result = DID_NO_CONNECT << 16;-    arcmsr_ccb_complete(ccb);+   pr_notice("arcmsr%d: scsi id = %d lun = %d "+   "isr get c
 ommand error done, but got unknown "+   "DeviceStatus = 0x%x\n"+   , acb->host->host_no+   , id+   , lun+   , ccb->arcmsr_cdb.DeviceStatus);+   acb->devstate[id][lun] = ARECA_RAID_GONE;+   ccb->pcmd->result = DID_NO_CONNECT << 16;+   arcmsr_ccb_complete(ccb);    break;   }  } }-static void arcmsr_drain_donequeue(struct AdapterControlBlock *acb, structCommandControlBlock *pCCB, bool error)+static void+arcmsr_drain_donequeue(struct AdapterControlBlock *acb,+ struct CommandControlBlock *pCCB, bool error) {- int id, lun;  if ((pCCB->acb != acb) || (pCCB->startdone != ARCMSR_CCB_START)) {-  if (pCCB->startdone == ARCMSR_CCB_ABORTED) {-   struct scsi_cmnd *abortcmd = pCCB->pcmd;-   if (abortcmd) {-    id = abortcmd->device->id;-    lun = abortcmd->device->lun;-    abortcmd->result |= DID_ABORT
  << 16;-    arcmsr_ccb_complete(pCCB);-    printk(KERN_NOTICE "arcmsr%d: pCCB ='0x%p' isr got aborted command \n",-    acb->host->host_no, pCCB);-   }-   return;-  }-  printk(KERN_NOTICE "arcmsr%d: isr get an illegal ccb command \-    done acb = '0x%p'"-    "ccb = '0x%p' ccbacb = '0x%p' startdone = 0x%x"-    " ccboutstandingcount = %d \n"-    , acb->host->host_no-    , acb-    , pCCB-    , pCCB->acb-    , pCCB->startdone-    , atomic_read(&acb->ccboutstandingcount));-    return;+  pr_notice("arcmsr%d: isr get an illegal ccb "+  "command done acb = 0x%p, "+  "ccb = 0x%p, "+  "ccbacb = 0x%p, "+  "startdone = 0x%x, "+  "pscsi_cmd = 0x%p, "+  "ccboutstandingcount = %d\n"+  , acb->host->host_no+  , acb+  , pCCB+  , pCCB->acb+  , pCCB->startdone+  , pCCB->pcmd+  , atomic_read(&acb->ccboutstand
 ingcount));+  return;  }  arcmsr_report_ccb_state(acb, pCCB, error); }-static void arcmsr_done4abort_postqueue(struct AdapterControlBlock *acb)+static void+arcmsr_done4abort_postqueue(struct AdapterControlBlock *acb) {  int i = 0;  uint32_t flag_ccb;@@ -944,27 +1375,36 @@ static void arcmsr_done4abort_postqueue(   outbound_intstatus = readl(&reg->outbound_intstatus) &      acb->outbound_int_enable;   /*clear and abort all outbound posted Q*/-  writel(outbound_intstatus, &reg->outbound_intstatus);/*clear interrupt*/-  while(((flag_ccb = readl(&reg->outbound_queueport)) != 0xFFFFFFFF)-    && (i++ < ARCMSR_MAX_OUTSTANDING_CMD)) {-   pARCMSR_CDB = (struct ARCMSR_CDB *)(acb->vir2phy_offset + (flag_ccb <<5));/*frame must be 32 bytes aligned*/-   pCCB = container_of(pARCMSR_CDB, struct CommandC
 ontrolBlock,arcmsr_cdb);-   error = (flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR_MODE0) ? true : false;+  writel(outbound_intstatus, &reg->outbound_intstatus);+  while (((flag_ccb = readl(&reg->outbound_queueport))+   != 0xFFFFFFFF)+   && (i++ < ARCMSR_MAX_OUTSTANDING_CMD)) {+   pARCMSR_CDB = (struct ARCMSR_CDB *)+    (acb->vir2phy_offset + (flag_ccb << 5));+   pCCB = container_of(pARCMSR_CDB,+   struct CommandControlBlock, arcmsr_cdb);+   error = (flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR_MODE0) ?+    true : false;    arcmsr_drain_donequeue(acb, pCCB, error);   }   }   break;  case ACB_ADAPTER_TYPE_B: {-  struct MessageUnit_B *reg = acb->pmuB;-  /*clear all outbound posted Q*/-  writel(ARCMSR_DOORBELL_INT_CLEAR_PATTERN, reg->iop2drv_doorbell); /*clear doorbell interrupt */+  struct MessageUnit_B 
 __iomem *reg = acb->pmuB;+  writel(ARCMSR_DOORBELL_INT_CLEAR_PATTERN,+   reg->iop2drv_doorbell);   for (i = 0; i < ARCMSR_MAX_HBB_POSTQUEUE; i++) {-   if ((flag_ccb = readl(&reg->done_qbuffer[i])) != 0) {+   flag_ccb = readl(&reg->done_qbuffer[i]);+   if (flag_ccb != 0) {     writel(0, &reg->done_qbuffer[i]);-    pARCMSR_CDB = (struct ARCMSR_CDB *)(acb->vir2phy_offset+(flag_ccb <<5));/*frame must be 32 bytes aligned*/-    pCCB = container_of(pARCMSR_CDB, struct CommandControlBlock,arcmsr_cdb);-    error = (flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR_MODE0) ? true : false;+    pARCMSR_CDB = (struct ARCMSR_CDB *)+    (acb->vir2phy_offset + (flag_ccb << 5));+    pCCB = container_of(pARCMSR_CDB,+    struct CommandControlBlock, arcmsr_cdb);+    error = (flag_ccb &+    ARCMSR_CCBREPLY_FLAG_ERROR_MOD
 E0) ?+    true : false;     arcmsr_drain_donequeue(acb, pCCB, error);    }    reg->post_qbuffer[i] = 0;@@ -974,29 +1414,87 @@ static void arcmsr_done4abort_postqueue(   }   break;  case ACB_ADAPTER_TYPE_C: {-  struct MessageUnit_C *reg = acb->pmuC;+  struct MessageUnit_C __iomem *reg = acb->pmuC;   struct  ARCMSR_CDB *pARCMSR_CDB;   uint32_t flag_ccb, ccb_cdb_phy;   bool error;   struct CommandControlBlock *pCCB;-  while ((readl(&reg->host_int_status) &ARCMSR_HBCMU_OUTBOUND_POSTQUEUE_ISR) && (i++ < ARCMSR_MAX_OUTSTANDING_CMD)){+  while ((readl(&reg->host_int_status) &+   ARCMSR_HBCMU_OUTBOUND_POSTQUEUE_ISR)+   && (i++ < ARCMSR_MAX_OUTSTANDING_CMD)) {    /*need to do*/    flag_ccb = readl(&reg->outbound_queueport_low);    ccb_cdb_phy = (flag_ccb & 0xFFFFFFF0);-   pARCMSR_CDB = (struct  AR
 CMSR_CDB*)(acb->vir2phy_offset+ccb_cdb_phy);/*frame must be 32 bytes aligned*/-   pCCB = container_of(pARCMSR_CDB, struct CommandControlBlock,arcmsr_cdb);-   error = (flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR_MODE1) ? true : false;+   pARCMSR_CDB = (struct  ARCMSR_CDB *)+    (acb->vir2phy_offset+ccb_cdb_phy);+   pCCB = container_of(pARCMSR_CDB,+    struct CommandControlBlock, arcmsr_cdb);+   error = (flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR_MODE1)+    ? true : false;    arcmsr_drain_donequeue(acb, pCCB, error);   }+  }+  break;+ case ACB_ADAPTER_TYPE_D: {+  struct MessageUnit_D __iomem *pmu = acb->pmuD;+  uint32_t ccb_cdb_phy, outbound_write_pointer;+  uint32_t doneq_index, index_stripped, addressLow, residual;+  bool error;+  struct CommandControlBlock *pCCB;+  outbound_write_pointer = pmu->do
 ne_qbuffer[0].addressLow + 1;+  doneq_index = pmu->doneq_index;+  residual = atomic_read(&acb->ccboutstandingcount);+  for (i = 0; i < residual; i++) {+   while ((doneq_index & 0xFFF) != (outbound_write_pointer & 0xFFF)) {+    if (doneq_index & 0x4000) {+     index_stripped = doneq_index & 0xFFF;+     index_stripped += 1;+     index_stripped %=+     ARCMSR_MAX_ARC1214_DONEQUEUE;+     pmu->doneq_index = index_stripped ?+     (index_stripped | 0x4000) : (index_stripped + 1);+    } else {+     index_stripped = doneq_index;+     index_stripped += 1;+     index_stripped %=+     ARCMSR_MAX_ARC1214_DONEQUEUE;+     pmu->doneq_index =+     index_stripped ? index_stripped : ((index_stripped | 0x4000) + 1);+    }+    doneq_index = pmu->doneq_index;+    addressLow =+    pmu->done_qbuffer[doneq_index
  & 0xFFF].addressLow;+    ccb_cdb_phy = (addressLow & 0xFFFFFFF0);+    pARCMSR_CDB = (struct  ARCMSR_CDB *)+    (acb->vir2phy_offset + ccb_cdb_phy);+    pCCB = container_of(pARCMSR_CDB,+    struct CommandControlBlock, arcmsr_cdb);+    error =+    (addressLow & ARCMSR_CCBREPLY_FLAG_ERROR_MODE1)+    ? true : false;+    arcmsr_drain_donequeue(acb, pCCB, error);+    writel(doneq_index,+     pmu->outboundlist_read_pointer);+   }+   mdelay(10);+   outbound_write_pointer =+    pmu->done_qbuffer[0].addressLow + 1;+   doneq_index = pmu->doneq_index;+  }+  pmu->postq_index = 0;+  pmu->doneq_index = 0x40FF;+  break;  }  } }-static void arcmsr_remove(struct pci_dev *pdev)++static void+arcmsr_remove(struct pci_dev *pdev) {  struct Scsi_Host *host = pci_get_drvdata(pdev);  struct AdapterControlBlock *
 acb =-  (struct AdapterControlBlock *) host->hostdata;- int poll_count = 0;+  (struct AdapterControlBlock *)host->hostdata;+ int poll_count = 0, i;  arcmsr_free_sysfs_attr(acb);  scsi_remove_host(host);  flush_work(&acb->arcmsr_do_message_isr_bh);@@ -1007,20 +1505,20 @@ static void arcmsr_remove(struct pci_dev  acb->acb_flags |= ACB_F_SCSISTOPADAPTER;  acb->acb_flags &= ~ACB_F_IOP_INITED;- for (poll_count = 0; poll_count < ARCMSR_MAX_OUTSTANDING_CMD;poll_count++){+ for (poll_count = 0; poll_count < ARCMSR_MAX_OUTSTANDING_CMD;+ poll_count++) {   if (!atomic_read(&acb->ccboutstandingcount))    break;-  arcmsr_interrupt(acb);/* FIXME: need spinlock */+  arcmsr_interrupt(acb);   msleep(25);  }  if (atomic_read(&acb->ccboutstandingcount)) {-  int i;-   arcmsr_abort_allcmd(acb);   arcmsr_done4
 abort_postqueue(acb);   for (i = 0; i < ARCMSR_MAX_FREECCB_NUM; i++) {-   struct CommandControlBlock *ccb = acb->pccb_pool[i];+   struct CommandControlBlock *ccb =+    acb->pccb_pool[i];    if (ccb->startdone == ARCMSR_CCB_START) {     ccb->startdone = ARCMSR_CCB_ABORTED;     ccb->pcmd->result = DID_ABORT << 16;@@ -1028,9 +1526,17 @@ static void arcmsr_remove(struct pci_dev    }   }  }- free_irq(pdev->irq, acb);  arcmsr_free_ccb_pool(acb);- arcmsr_free_hbb_mu(acb);+ arcmsr_free_mu(acb);+ if (acb->acb_flags & ACB_F_MSI_ENABLED) {+  free_irq(pdev->irq, acb);+  pci_disable_msi(pdev);+ } else if (acb->acb_flags & ACB_F_MSIX_ENABLED) {+  for (i = 0; i < ARCMST_NUM_MSIX_VECTORS; i++)+   free_irq(acb->entries[i].vector, acb);+  pci_disable_msix(pdev);+ } else+  free_irq(pdev->irq, acb);  arcmsr
 _unmap_pciregion(acb);  pci_release_regions(pdev);  scsi_host_put(host);@@ -1038,13 +1544,21 @@ static void arcmsr_remove(struct pci_dev  pci_set_drvdata(pdev, NULL); }-static void arcmsr_shutdown(struct pci_dev *pdev)+static void+arcmsr_shutdown(struct pci_dev *pdev) {+ int i;  struct Scsi_Host *host = pci_get_drvdata(pdev);  struct AdapterControlBlock *acb =   (struct AdapterControlBlock *)host->hostdata;  del_timer_sync(&acb->eternal_timer);  arcmsr_disable_outbound_ints(acb);+ if (acb->acb_flags & ACB_F_MSIX_ENABLED) {+  for (i = 0; i < ARCMST_NUM_MSIX_VECTORS; i++)+   free_irq(acb->entries[i].vector, acb);+  pci_disable_msix(pdev);+ } else+  free_irq(pdev->irq, acb);  flush_work(&acb->arcmsr_do_message_isr_bh);  arcmsr_stop_adapter_bgrb(acb);  arcmsr_flush_adapter_cache(acb);@@ -106
 4,7 +1578,8 @@ static void arcmsr_module_exit(void) module_init(arcmsr_module_init); module_exit(arcmsr_module_exit);-static void arcmsr_enable_outbound_ints(struct AdapterControlBlock *acb,+static void+arcmsr_enable_outbound_ints(struct AdapterControlBlock *acb,       u32 intmask_org) {  u32 mask;@@ -1072,37 +1587,51 @@ static void arcmsr_enable_outbound_ints(  case ACB_ADAPTER_TYPE_A: {   struct MessageUnit_A __iomem *reg = acb->pmuA;-  mask = intmask_org & ~(ARCMSR_MU_OUTBOUND_POSTQUEUE_INTMASKENABLE |-        ARCMSR_MU_OUTBOUND_DOORBELL_INTMASKENABLE|-        ARCMSR_MU_OUTBOUND_MESSAGE0_INTMASKENABLE);+  mask = intmask_org &+  ~(ARCMSR_MU_OUTBOUND_POSTQUEUE_INTMASKENABLE |+       ARCMSR_MU_OUTBOUND_DOORBELL_INTMASKENABLE |+       ARCMSR_MU_OUTBOUND_MESSAGE0_INTMASKENABLE);   writel(m
 ask, &reg->outbound_intmask);-  acb->outbound_int_enable = ~(intmask_org & mask) & 0x000000ff;-  }+  acb->outbound_int_enable = ~(intmask_org & mask) &+   0x000000ff;   break;-+  }  case ACB_ADAPTER_TYPE_B: {-  struct MessageUnit_B *reg = acb->pmuB;+  struct MessageUnit_B __iomem *reg = acb->pmuB;   mask = intmask_org | (ARCMSR_IOP2DRV_DATA_WRITE_OK |    ARCMSR_IOP2DRV_DATA_READ_OK |    ARCMSR_IOP2DRV_CDB_DONE |    ARCMSR_IOP2DRV_MESSAGE_CMD_DONE);   writel(mask, reg->iop2drv_doorbell_mask);-  acb->outbound_int_enable = (intmask_org | mask) & 0x0000000f;-  }+  acb->outbound_int_enable = (intmask_org | mask) &+   0x0000000f;   break;+  }  case ACB_ADAPTER_TYPE_C: {-  struct MessageUnit_C *reg = acb->pmuC;-  mask = ~(ARCMSR_HBCMU_UTILITY_A_ISR_MASK |ARCMSR_HBCMU_OUTBOUND_DOORBELL_ISR_MASK|
 ARCMSR_HBCMU_OUTBOUND_POSTQUEUE_ISR_MASK);+  struct MessageUnit_C __iomem *reg = acb->pmuC;+  mask = ~(ARCMSR_HBCMU_UTILITY_A_ISR_MASK |+   ARCMSR_HBCMU_OUTBOUND_DOORBELL_ISR_MASK |+   ARCMSR_HBCMU_OUTBOUND_POSTQUEUE_ISR_MASK);   writel(intmask_org & mask, &reg->host_int_mask);-  acb->outbound_int_enable = ~(intmask_org & mask) & 0x0000000f;+  acb->outbound_int_enable = ~(intmask_org & mask) &+   0x0000000f;+  break;   }+ case ACB_ADAPTER_TYPE_D: {+  struct MessageUnit_D __iomem *reg = acb->pmuD;+  mask = ARCMSR_ARC1214_ALL_INT_ENABLE;+  writel(intmask_org | mask, reg->pcief0_int_enable);+  break;+ }  } }-static int arcmsr_build_ccb(struct AdapterControlBlock *acb,+static int+arcmsr_build_ccb(struct AdapterControlBlock *acb,  struct CommandControlBlock *ccb, struct scsi_cmnd *pcmd) {- st
 ruct ARCMSR_CDB *arcmsr_cdb = (struct ARCMSR_CDB *)&ccb->arcmsr_cdb;+ struct ARCMSR_CDB *arcmsr_cdb =+  (struct ARCMSR_CDB *)&ccb->arcmsr_cdb;  int8_t *psge = (int8_t *)&arcmsr_cdb->u;  __le32 address_lo, address_hi;  int arccdbsize = 0x30;@@ -1115,8 +1644,7 @@ static int arcmsr_build_ccb(struct Adapt  arcmsr_cdb->TargetID = pcmd->device->id;  arcmsr_cdb->LUN = pcmd->device->lun;  arcmsr_cdb->Function = 1;- arcmsr_cdb->Context = 0;- memcpy(arcmsr_cdb->Cdb, pcmd->cmnd, pcmd->cmd_len);+ memcpy((void *)arcmsr_cdb->Cdb, (const void *)pcmd->cmnd, pcmd->cmd_len);  nseg = scsi_dma_map(pcmd);  if (unlikely(nseg > acb->host->sg_tablesize || nseg < 0))@@ -1127,25 +1655,27 @@ static int arcmsr_build_ccb(struct Adapt   address_lo = cpu_to_le32(dma_addr_lo32(sg_dma_address(sg)));   address_hi = cpu_t
 o_le32(dma_addr_hi32(sg_dma_address(sg)));   if (address_hi == 0) {-   struct SG32ENTRY *pdma_sg = (struct SG32ENTRY *)psge;-+   struct SG32ENTRY *pdma_sg =+    (struct SG32ENTRY *)psge;    pdma_sg->address = address_lo;    pdma_sg->length = length;    psge += sizeof (struct SG32ENTRY);    arccdbsize += sizeof (struct SG32ENTRY);   } else {-   struct SG64ENTRY *pdma_sg = (struct SG64ENTRY *)psge;-+   struct SG64ENTRY *pdma_sg =+   (struct SG64ENTRY *)psge;    pdma_sg->addresshigh = address_hi;    pdma_sg->address = address_lo;-   pdma_sg->length = length|cpu_to_le32(IS_SG64_ADDR);+   pdma_sg->length = length |+    cpu_to_le32(IS_SG64_ADDR);    psge += sizeof (struct SG64ENTRY);    arccdbsize += sizeof (struct SG64ENTRY);   }  }  arcmsr_cdb->sgcount = (uint8_t)nseg;  arcmsr_cdb->DataLengt
 h = scsi_bufflen(pcmd);- arcmsr_cdb->msgPages = arccdbsize/0x100 + (arccdbsize % 0x100 ? 1 : 0);+ arcmsr_cdb->msgPages = arccdbsize / 0x100 ++  (arccdbsize % 0x100 ? 1 : 0);  if ( arccdbsize > 256)   arcmsr_cdb->Flags |= ARCMSR_CDB_FLAG_SGL_BSIZE;  if (pcmd->sc_data_direction == DMA_TO_DEVICE)@@ -1154,10 +1684,14 @@ static int arcmsr_build_ccb(struct Adapt  return SUCCESS; }-static void arcmsr_post_ccb(struct AdapterControlBlock *acb, structCommandControlBlock *ccb)-{- uint32_t cdb_phyaddr_pattern = ccb->cdb_phyaddr_pattern;- struct ARCMSR_CDB *arcmsr_cdb = (struct ARCMSR_CDB *)&ccb->arcmsr_cdb;+static void+arcmsr_post_ccb(struct AdapterControlBlock *acb,+ struct CommandControlBlock *ccb)+{+ uint32_t cdb_phyaddr = ccb->cdb_phyaddr;+ struct ARCMSR_CDB *arcmsr_cdb =+  (struct ARCMSR_CDB *)
 &ccb->arcmsr_cdb;+ u32 arccdbsize = ccb->arc_cdb_size;  atomic_inc(&acb->ccboutstandingcount);  ccb->startdone = ARCMSR_CCB_START;  switch (acb->adapter_type) {@@ -1165,131 +1699,203 @@ static void arcmsr_post_ccb(struct Adapt   struct MessageUnit_A __iomem *reg = acb->pmuA;   if (arcmsr_cdb->Flags & ARCMSR_CDB_FLAG_SGL_BSIZE)-   writel(cdb_phyaddr_pattern | ARCMSR_CCBPOST_FLAG_SGL_BSIZE,+   writel(cdb_phyaddr |+   ARCMSR_CCBPOST_FLAG_SGL_BSIZE,    &reg->inbound_queueport);-  else {-    writel(cdb_phyaddr_pattern, &reg->inbound_queueport);-  }+  else+   writel(cdb_phyaddr, &reg->inbound_queueport);   }   break;  case ACB_ADAPTER_TYPE_B: {-  struct MessageUnit_B *reg = acb->pmuB;+  struct MessageUnit_B __iomem *reg = acb->pmuB;   uint32_t ending_index, index = reg->postq_index;-  ending_i
 ndex = ((index + 1) % ARCMSR_MAX_HBB_POSTQUEUE);+  ending_index = ((index + 1) %+   ARCMSR_MAX_HBB_POSTQUEUE);   writel(0, &reg->post_qbuffer[ending_index]);   if (arcmsr_cdb->Flags & ARCMSR_CDB_FLAG_SGL_BSIZE) {-   writel(cdb_phyaddr_pattern | ARCMSR_CCBPOST_FLAG_SGL_BSIZE,\-       &reg->post_qbuffer[index]);-  } else {-   writel(cdb_phyaddr_pattern, &reg->post_qbuffer[index]);-  }+   writel(cdb_phyaddr |+   ARCMSR_CCBPOST_FLAG_SGL_BSIZE,+    &reg->post_qbuffer[index]);+  } else+   writel(cdb_phyaddr, &reg->post_qbuffer[index]);   index++;-  index %= ARCMSR_MAX_HBB_POSTQUEUE;/*if last index number set it to 0 */+  index %= ARCMSR_MAX_HBB_POSTQUEUE;   reg->postq_index = index;-  writel(ARCMSR_DRV2IOP_CDB_POSTED, reg->drv2iop_doorbell);+  writel(ARCMSR_DRV2IOP_CDB_POSTED,+   reg->drv2iop_
 doorbell);   }   break;  case ACB_ADAPTER_TYPE_C: {-  struct MessageUnit_C *phbcmu = (struct MessageUnit_C *)acb->pmuC;+  struct MessageUnit_C __iomem *phbcmu = acb->pmuC;   uint32_t ccb_post_stamp, arc_cdb_size;-  arc_cdb_size = (ccb->arc_cdb_size > 0x300) ? 0x300 : ccb->arc_cdb_size;-  ccb_post_stamp = (cdb_phyaddr_pattern | ((arc_cdb_size - 1) >> 6) | 1);+  arc_cdb_size = (ccb->arc_cdb_size > 0x300)+   ? 0x300 : ccb->arc_cdb_size;+  ccb_post_stamp = (cdb_phyaddr |+   ((arc_cdb_size - 1) >> 6) | 1);   if (acb->cdb_phyaddr_hi32) {-   writel(acb->cdb_phyaddr_hi32, &phbcmu->inbound_queueport_high);-   writel(ccb_post_stamp, &phbcmu->inbound_queueport_low);+   writel(acb->cdb_phyaddr_hi32,+   &phbcmu->inbound_queueport_high);+   writel(ccb_post_stamp,+   &phbcmu->inbound_queueport_low);+  
 } else+   writel(ccb_post_stamp,+   &phbcmu->inbound_queueport_low);+  }+  break;+ case ACB_ADAPTER_TYPE_D: {+  struct MessageUnit_D __iomem *pmu = acb->pmuD;+  u16 index_stripped;+  u16 postq_index;+  unsigned long flags;+  struct InBound_SRB *pinbound_srb;+  spin_lock_irqsave(&acb->postq_lock, flags);+  postq_index = pmu->postq_index;+  pinbound_srb = (struct InBound_SRB *)&pmu->post_qbuffer[postq_index &0xFF];+  pinbound_srb->addressHigh = dma_addr_hi32(cdb_phyaddr);+  pinbound_srb->addressLow = dma_addr_lo32(cdb_phyaddr);+  pinbound_srb->length = arccdbsize >> 2;+  arcmsr_cdb->msgContext = dma_addr_lo32(cdb_phyaddr);+  if (postq_index & 0x4000) {+   index_stripped = postq_index & 0xFF;+   index_stripped += 1;+   index_stripped %= ARCMSR_MAX_ARC1214_POSTQUEUE;+   pmu->postq_index = in
 dex_stripped ? (index_stripped | 0x4000) :index_stripped;   } else {-   writel(ccb_post_stamp, &phbcmu->inbound_queueport_low);-  }+   index_stripped = postq_index;+   index_stripped += 1;+   index_stripped %= ARCMSR_MAX_ARC1214_POSTQUEUE;+   pmu->postq_index = index_stripped ? index_stripped : (index_stripped |0x4000);   }+  writel(postq_index, pmu->inboundlist_write_pointer);+  spin_unlock_irqrestore(&acb->postq_lock, flags);+  break;+ }  } }-static void arcmsr_stop_hba_bgrb(struct AdapterControlBlock *acb)+static void arcmsr_hbaA_stop_bgrb(struct AdapterControlBlock *acb) {  struct MessageUnit_A __iomem *reg = acb->pmuA;  acb->acb_flags &= ~ACB_F_MSG_START_BGRB;  writel(ARCMSR_INBOUND_MESG0_STOP_BGRB, &reg->inbound_msgaddr0);- if (!arcmsr_hba_wait_msgint_ready(acb)) {-  printk(KERN_NO
 TICE-   "arcmsr%d: wait 'stop adapter background rebulid' timeout \n"-   , acb->host->host_no);- }+ if (!arcmsr_hbaA_wait_msgint_ready(acb))+  pr_notice("arcmsr%d: wait 'stop adapter background rebulid' timeout\n"+  , acb->host->host_no); }-static void arcmsr_stop_hbb_bgrb(struct AdapterControlBlock *acb)+static void+arcmsr_hbaB_stop_bgrb(struct AdapterControlBlock *acb) {- struct MessageUnit_B *reg = acb->pmuB;+ struct MessageUnit_B __iomem *reg = acb->pmuB;  acb->acb_flags &= ~ACB_F_MSG_START_BGRB;  writel(ARCMSR_MESSAGE_STOP_BGRB, reg->drv2iop_doorbell);- if (!arcmsr_hbb_wait_msgint_ready(acb)) {-  printk(KERN_NOTICE-   "arcmsr%d: wait 'stop adapter background rebulid' timeout \n"-   , acb->host->host_no);- }+ if (!arcmsr_hbaB_wait_msgint_ready(acb))+  pr_notice("arcmsr%d: wait 'stop 
 adapter background rebulid' timeout\n"+  , acb->host->host_no); }-static void arcmsr_stop_hbc_bgrb(struct AdapterControlBlock *pACB)+static void+arcmsr_hbaC_stop_bgrb(struct AdapterControlBlock *pACB) {- struct MessageUnit_C *reg = (struct MessageUnit_C *)pACB->pmuC;+ struct MessageUnit_C __iomem *reg = pACB->pmuC;  pACB->acb_flags &= ~ACB_F_MSG_START_BGRB;  writel(ARCMSR_INBOUND_MESG0_STOP_BGRB, &reg->inbound_msgaddr0);- writel(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE, &reg->inbound_doorbell);- if (!arcmsr_hbc_wait_msgint_ready(pACB)) {-  printk(KERN_NOTICE-   "arcmsr%d: wait 'stop adapter background rebulid' timeout \n"-   , pACB->host->host_no);- }- return;+ writel(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE,+  &reg->inbound_doorbell);+ if (!arcmsr_hbaC_wait_msgint_ready(pACB))+  pr_notice("ar
 cmsr%d: wait 'stop adapter background rebulid' timeout\n"+  , pACB->host->host_no);+}++static void+arcmsr_hbaD_stop_bgrb(struct AdapterControlBlock *pACB)+{+ struct MessageUnit_D __iomem *reg = pACB->pmuD;++ pACB->acb_flags &= ~ACB_F_MSG_START_BGRB;+ writel(ARCMSR_INBOUND_MESG0_STOP_BGRB,+  reg->inbound_msgaddr0);+ if (!arcmsr_hbaD_wait_msgint_ready(pACB))+  pr_notice("arcmsr%d: wait 'stop adapter background rebulid' timeout\n"+  , pACB->host->host_no); }-static void arcmsr_stop_adapter_bgrb(struct AdapterControlBlock *acb)++static void+arcmsr_stop_adapter_bgrb(struct AdapterControlBlock *acb) {  switch (acb->adapter_type) {  case ACB_ADAPTER_TYPE_A: {-  arcmsr_stop_hba_bgrb(acb);-  }+  arcmsr_hbaA_stop_bgrb(acb);   break;-+ }  case ACB_ADAPTER_TYPE_B: {-  arcmsr_stop_hbb_bgrb(acb);-  }+
   arcmsr_hbaB_stop_bgrb(acb);   break;+ }  case ACB_ADAPTER_TYPE_C: {-  arcmsr_stop_hbc_bgrb(acb);-  }+  arcmsr_hbaC_stop_bgrb(acb);+  break;+ }+ case ACB_ADAPTER_TYPE_D: {+  arcmsr_hbaD_stop_bgrb(acb);+  break;+ }  } }-static void arcmsr_free_ccb_pool(struct AdapterControlBlock *acb)+static void+arcmsr_free_ccb_pool(struct AdapterControlBlock *acb) {- dma_free_coherent(&acb->pdev->dev, acb->uncache_size, acb->dma_coherent,acb->dma_coherent_handle);+ switch (acb->adapter_type) {+ case ACB_ADAPTER_TYPE_A:+ case ACB_ADAPTER_TYPE_C:+ case ACB_ADAPTER_TYPE_B:+ case ACB_ADAPTER_TYPE_D:+  dma_free_coherent(&acb->pdev->dev, acb->uncache_size,+   acb->dma_coherent, acb->dma_coherent_handle);+  break;+ } }-void arcmsr_iop_message_read(struct AdapterControlBlock *acb)+void+arcmsr_iop_message_read(
 struct AdapterControlBlock *acb) {  switch (acb->adapter_type) {  case ACB_ADAPTER_TYPE_A: {   struct MessageUnit_A __iomem *reg = acb->pmuA;-  writel(ARCMSR_INBOUND_DRIVER_DATA_READ_OK, &reg->inbound_doorbell);+  writel(ARCMSR_INBOUND_DRIVER_DATA_READ_OK,+  &reg->inbound_doorbell);   }   break;  case ACB_ADAPTER_TYPE_B: {-  struct MessageUnit_B *reg = acb->pmuB;-  writel(ARCMSR_DRV2IOP_DATA_READ_OK, reg->drv2iop_doorbell);+  struct MessageUnit_B __iomem *reg = acb->pmuB;+  writel(ARCMSR_DRV2IOP_DATA_READ_OK,+  reg->drv2iop_doorbell);   }   break;  case ACB_ADAPTER_TYPE_C: {   struct MessageUnit_C __iomem *reg = acb->pmuC;   writel(ARCMSR_HBCMU_DRV2IOP_DATA_READ_OK, &reg->inbound_doorbell);+  /*readl(&reg->inbound_doorbell);*/   }+  break;+ case ACB_ADAPTER_TYPE_D: {+  struct MessageUnit
 _D __iomem *reg = acb->pmuD;+  writel(ARCMSR_ARC1214_DRV2IOP_DATA_OUT_READ,+  reg->inbound_doorbell);+  /*readl(reg->inbound_doorbell);*/+  break;+ }  } }-static void arcmsr_iop_message_wrote(struct AdapterControlBlock *acb)+static void+arcmsr_iop_message_wrote(struct AdapterControlBlock *acb) {  switch (acb->adapter_type) {  case ACB_ADAPTER_TYPE_A: {@@ -1298,17 +1904,19 @@ static void arcmsr_iop_message_wrote(str   ** push inbound doorbell tell iop, driver data write ok   ** and wait reply on next hwinterrupt for next Qbuffer post   */-  writel(ARCMSR_INBOUND_DRIVER_DATA_WRITE_OK, &reg->inbound_doorbell);+  writel(ARCMSR_INBOUND_DRIVER_DATA_WRITE_OK,+  &reg->inbound_doorbell);   }   break;  case ACB_ADAPTER_TYPE_B: {-  struct MessageUnit_B *reg = acb->pmuB;+  struct MessageUnit_B __iom
 em *reg = acb->pmuB;   /*   ** push inbound doorbell tell iop, driver data write ok   ** and wait reply on next hwinterrupt for next Qbuffer post   */-  writel(ARCMSR_DRV2IOP_DATA_WRITE_OK, reg->drv2iop_doorbell);+  writel(ARCMSR_DRV2IOP_DATA_WRITE_OK,+  reg->drv2iop_doorbell);   }   break;  case ACB_ADAPTER_TYPE_C: {@@ -1317,13 +1925,21 @@ static void arcmsr_iop_message_wrote(str   ** push inbound doorbell tell iop, driver data write ok   ** and wait reply on next hwinterrupt for next Qbuffer post   */-  writel(ARCMSR_HBCMU_DRV2IOP_DATA_WRITE_OK, &reg->inbound_doorbell);+  writel(ARCMSR_HBCMU_DRV2IOP_DATA_WRITE_OK,+  &reg->inbound_doorbell);   }   break;+ case ACB_ADAPTER_TYPE_D: {+  struct MessageUnit_D __iomem *reg = acb->pmuD;+  writel(ARCMSR_ARC1214_DRV2IOP_DATA_IN_READY,+  reg->inb
 ound_doorbell);+  break;+ }  } }-struct QBUFFER __iomem *arcmsr_get_iop_rqbuffer(struct AdapterControlBlock*acb)+struct QBUFFER __iomem+*arcmsr_get_iop_rqbuffer(struct AdapterControlBlock *acb) {  struct QBUFFER __iomem *qbuffer = NULL;  switch (acb->adapter_type) {@@ -1335,146 +1951,294 @@ struct QBUFFER __iomem *arcmsr_get_iop_r   break;  case ACB_ADAPTER_TYPE_B: {-  struct MessageUnit_B *reg = acb->pmuB;+  struct MessageUnit_B __iomem *reg = acb->pmuB;   qbuffer = (struct QBUFFER __iomem *)reg->message_rbuffer;   }   break;  case ACB_ADAPTER_TYPE_C: {-  struct MessageUnit_C *phbcmu = (struct MessageUnit_C *)acb->pmuC;-  qbuffer = (struct QBUFFER __iomem *)&phbcmu->message_rbuffer;+  struct MessageUnit_C __iomem *reg = acb->pmuC;+  qbuffer = (struct QBUFFER __iomem *)&reg->message_rbuf
 fer;   }+  break;+ case ACB_ADAPTER_TYPE_D: {+  struct MessageUnit_D __iomem *reg = acb->pmuD;+  qbuffer = (struct QBUFFER __iomem *)reg->message_rbuffer;+  break;+ }  }  return qbuffer; }-static struct QBUFFER __iomem *arcmsr_get_iop_wqbuffer(structAdapterControlBlock *acb)+struct QBUFFER __iomem+*arcmsr_get_iop_wqbuffer(struct AdapterControlBlock *acb) {  struct QBUFFER __iomem *pqbuffer = NULL;  switch (acb->adapter_type) {  case ACB_ADAPTER_TYPE_A: {   struct MessageUnit_A __iomem *reg = acb->pmuA;-  pqbuffer = (struct QBUFFER __iomem *) &reg->message_wbuffer;+  pqbuffer = (struct QBUFFER __iomem *)&reg->message_wbuffer;   }   break;  case ACB_ADAPTER_TYPE_B: {-  struct MessageUnit_B  *reg = acb->pmuB;+  struct MessageUnit_B  __iomem *reg = acb->pmuB;   pqbuffer = (struct QBUFFER __i
 omem *)reg->message_wbuffer;   }   break;  case ACB_ADAPTER_TYPE_C: {-  struct MessageUnit_C *reg = (struct MessageUnit_C *)acb->pmuC;+  struct MessageUnit_C __iomem *reg = acb->pmuC;   pqbuffer = (struct QBUFFER __iomem *)&reg->message_wbuffer;+  }+  break;+ case ACB_ADAPTER_TYPE_D: {+  struct MessageUnit_D __iomem *reg = acb->pmuD;+  pqbuffer = (struct QBUFFER __iomem *)reg->message_wbuffer;+  break;  }-  }  return pqbuffer; }-static void arcmsr_iop2drv_data_wrote_handle(struct AdapterControlBlock*acb)-{- struct QBUFFER __iomem *prbuffer;- struct QBUFFER *pQbuffer;+static uint32_t+arcmsr_Read_iop_rqbuffer_in_DWORD(struct AdapterControlBlock *acb,+ struct QBUFFER __iomem *prbuffer) {++ uint8_t *pQbuffer;+ uint8_t *buf1 = 0;+ uint32_t __iomem *iop_data;+ uint32_t iop_len, data_len, *buf2
  = 0;++ iop_data = (uint32_t *)prbuffer->data;+ iop_len = readl(&prbuffer->data_len);+ if (iop_len > 0) {+  buf1 = (uint8_t *)kmalloc(128, GFP_ATOMIC);+  buf2 = (uint32_t *)buf1;+  if (buf1 == NULL)+   return 0;+  data_len = iop_len;+  while (data_len >= 4) {+   *buf2++ = *iop_data++;+   data_len -= 4;+  }+  if (data_len)+   *buf2 = *iop_data;+  buf2 = (uint32_t *)buf1;+ }+ while (iop_len > 0) {+  pQbuffer = &acb->rqbuffer[acb->rqbuf_lastindex];+  *pQbuffer = *buf1;+  acb->rqbuf_lastindex++;+  /* if last, index number set it to 0 */+  acb->rqbuf_lastindex %= ARCMSR_MAX_QBUFFER;+  buf1++;+  iop_len--;+ }+ if (buf2)+  kfree((const void *)buf2);+ /* let IOP know data has been read */+ arcmsr_iop_message_read(acb);+ return 1;+}++uint32_t+arcmsr_Read_iop_rqbuffer_data(struct AdapterControlBlo
 ck *acb,+ struct QBUFFER __iomem *prbuffer) {++ uint8_t *pQbuffer;  uint8_t __iomem *iop_data;- int32_t my_empty_len, iop_len, rqbuf_firstindex, rqbuf_lastindex;- rqbuf_lastindex = acb->rqbuf_lastindex;- rqbuf_firstindex = acb->rqbuf_firstindex;- prbuffer = arcmsr_get_iop_rqbuffer(acb);- iop_data = (uint8_t __iomem *)prbuffer->data;- iop_len = prbuffer->data_len;- my_empty_len = (rqbuf_firstindex - rqbuf_lastindex - 1) &(ARCMSR_MAX_QBUFFER - 1);-- if (my_empty_len >= iop_len)- {-  while (iop_len > 0) {-   pQbuffer = (struct QBUFFER *)&acb->rqbuffer[rqbuf_lastindex];-   memcpy(pQbuffer, iop_data, 1);-   rqbuf_lastindex++;-   rqbuf_lastindex %= ARCMSR_MAX_QBUFFER;-   iop_data++;-   iop_len--;-  }-  acb->rqbuf_lastindex = rqbuf_lastindex;-  arcmsr_iop_message_read(acb);+ uint32_t iop_len;++
  if (acb->adapter_type & (ACB_ADAPTER_TYPE_C | ACB_ADAPTER_TYPE_D))+  return arcmsr_Read_iop_rqbuffer_in_DWORD(acb, prbuffer);++ iop_data = (uint8_t *)prbuffer->data;+ iop_len = readl(&prbuffer->data_len);+ while (iop_len > 0) {+  pQbuffer = &acb->rqbuffer[acb->rqbuf_lastindex];+  *pQbuffer = *iop_data;+  acb->rqbuf_lastindex++;+  acb->rqbuf_lastindex %= ARCMSR_MAX_QBUFFER;+  iop_data++;+  iop_len--;  }+ arcmsr_iop_message_read(acb);+ return 1;+}- else {+void+arcmsr_iop2drv_data_wrote_handle(struct AdapterControlBlock *acb)+{+ unsigned long flags;+ struct QBUFFER __iomem  *prbuffer;+ int32_t buf_empty_len;++ spin_lock_irqsave(&acb->rqbuffer_lock, flags);+ prbuffer = arcmsr_get_iop_rqbuffer(acb);+ buf_empty_len = (acb->rqbuf_lastindex - acb->rqbuf_firstindex - 1) &+  (ARCMSR_MAX_QBUFFER -
  1);+ if (buf_empty_len >= prbuffer->data_len) {+  if (arcmsr_Read_iop_rqbuffer_data(acb, prbuffer) == 0)+   acb->acb_flags |= ACB_F_IOPDATA_OVERFLOW;+ } else   acb->acb_flags |= ACB_F_IOPDATA_OVERFLOW;- }+ spin_unlock_irqrestore(&acb->rqbuffer_lock, flags); }-static void arcmsr_iop2drv_data_read_handle(struct AdapterControlBlock*acb)+static void+arcmsr_write_ioctldata2iop_in_DWORD(struct AdapterControlBlock *acb) {- acb->acb_flags |= ACB_F_MESSAGE_WQBUFFER_READED;- if (acb->wqbuf_firstindex != acb->wqbuf_lastindex) {-  uint8_t *pQbuffer;-  struct QBUFFER __iomem *pwbuffer;-  uint8_t __iomem *iop_data;-  int32_t allxfer_len = 0;+ uint8_t *pQbuffer;+ struct QBUFFER __iomem *pwbuffer;+ uint8_t *buf1 = 0;+ uint32_t __iomem *iop_data;+ uint32_t allxfer_len = 0, data_len, *buf2 = 0;++ if (acb
 ->acb_flags & ACB_F_MESSAGE_WQBUFFER_READED) {+  buf1 = (uint8_t *)kmalloc(128, GFP_ATOMIC);+  buf2 = (uint32_t *)buf1;+  if (buf1 == NULL)+   return;   acb->acb_flags &= (~ACB_F_MESSAGE_WQBUFFER_READED);   pwbuffer = arcmsr_get_iop_wqbuffer(acb);-  iop_data = (uint8_t __iomem *)pwbuffer->data;+  iop_data = (uint32_t *)pwbuffer->data;+  while ((acb->wqbuf_firstindex != acb->wqbuf_lastindex)+   && (allxfer_len < 124)) {+   pQbuffer = &acb->wqbuffer[acb->wqbuf_firstindex];+   *buf1 = *pQbuffer;+   acb->wqbuf_firstindex++;+   acb->wqbuf_firstindex %= ARCMSR_MAX_QBUFFER;+   buf1++;+   allxfer_len++;+  }+  data_len = allxfer_len;+  buf1 = (uint8_t *)buf2;+  while (data_len >= 4) {+   *iop_data++ = *buf2++;+   data_len -= 4;+  }+  if (data_len)+   *iop_data = *buf2;+  writel(allxfer_len, &pwbu
 ffer->data_len);+  kfree((const void *)buf1);+  arcmsr_iop_message_wrote(acb);+ }+}++void+arcmsr_write_ioctldata2iop(struct AdapterControlBlock *acb)+{+ uint8_t *pQbuffer;+ struct QBUFFER __iomem *pwbuffer;+ uint8_t __iomem *iop_data;+ int32_t allxfer_len = 0;-  while ((acb->wqbuf_firstindex != acb->wqbuf_lastindex) && \-       (allxfer_len < 124)) {+ if (acb->adapter_type & (ACB_ADAPTER_TYPE_C | ACB_ADAPTER_TYPE_D)) {+  arcmsr_write_ioctldata2iop_in_DWORD(acb);+  return;+ }+ if (acb->acb_flags & ACB_F_MESSAGE_WQBUFFER_READED) {+  acb->acb_flags &= (~ACB_F_MESSAGE_WQBUFFER_READED);+  pwbuffer = arcmsr_get_iop_wqbuffer(acb);+  iop_data = (uint8_t *)pwbuffer->data;+  while ((acb->wqbuf_firstindex != acb->wqbuf_lastindex)+   && (allxfer_len < 124)) {    pQbuffer = &acb->wqbuffer[acb->wqbuf_
 firstindex];-   memcpy(iop_data, pQbuffer, 1);+   *iop_data = *pQbuffer;    acb->wqbuf_firstindex++;    acb->wqbuf_firstindex %= ARCMSR_MAX_QBUFFER;    iop_data++;    allxfer_len++;   }-  pwbuffer->data_len = allxfer_len;-+  writel(allxfer_len, &pwbuffer->data_len);   arcmsr_iop_message_wrote(acb);  }+}++void+arcmsr_iop2drv_data_read_handle(struct AdapterControlBlock *acb)+{+ unsigned long flags;- if (acb->wqbuf_firstindex == acb->wqbuf_lastindex) {+ spin_lock_irqsave(&acb->wqbuffer_lock, flags);+ acb->acb_flags |= ACB_F_MESSAGE_WQBUFFER_READED;+ if (acb->wqbuf_firstindex != acb->wqbuf_lastindex)+  arcmsr_write_ioctldata2iop(acb);+ if (acb->wqbuf_firstindex == acb->wqbuf_lastindex)   acb->acb_flags |= ACB_F_MESSAGE_WQBUFFER_CLEARED;- }+ spin_unlock_irqrestore(&acb->wqbuffer_lock, flags);
  }-static void arcmsr_hba_doorbell_isr(struct AdapterControlBlock *acb)+static void+arcmsr_hbaA_doorbell_isr(struct AdapterControlBlock *acb) {  uint32_t outbound_doorbell;- struct MessageUnit_A __iomem *reg = acb->pmuA;+ struct MessageUnit_A __iomem *reg  = acb->pmuA;  outbound_doorbell = readl(&reg->outbound_doorbell);- writel(outbound_doorbell, &reg->outbound_doorbell);- if (outbound_doorbell & ARCMSR_OUTBOUND_IOP331_DATA_WRITE_OK) {-  arcmsr_iop2drv_data_wrote_handle(acb);- }-- if (outbound_doorbell & ARCMSR_OUTBOUND_IOP331_DATA_READ_OK) {-  arcmsr_iop2drv_data_read_handle(acb);- }+ do {+  writel(outbound_doorbell, &reg->outbound_doorbell);+  if (outbound_doorbell &+   ARCMSR_OUTBOUND_IOP331_DATA_WRITE_OK)+   arcmsr_iop2drv_data_wrote_handle(acb);+  if (outbound_doorbell &+   ARCMSR_
 OUTBOUND_IOP331_DATA_READ_OK)+   arcmsr_iop2drv_data_read_handle(acb);+  outbound_doorbell = readl(&reg->outbound_doorbell);+ } while (outbound_doorbell &+ (ARCMSR_OUTBOUND_IOP331_DATA_WRITE_OK+ | ARCMSR_OUTBOUND_IOP331_DATA_READ_OK)); }-static void arcmsr_hbc_doorbell_isr(struct AdapterControlBlock *pACB)+static void+arcmsr_hbaC_doorbell_isr(struct AdapterControlBlock *pACB) {  uint32_t outbound_doorbell;- struct MessageUnit_C *reg = (struct MessageUnit_C *)pACB->pmuC;- /*- *******************************************************************- **  Maybe here we need to check wrqbuffer_lock is lock or not- **  DOORBELL: din! don!- **  check if there are any mail need to pack from firmware- *******************************************************************- */+ struct MessageUnit_C __iomem
  *reg = pACB->pmuC;  outbound_doorbell = readl(&reg->outbound_doorbell);- writel(outbound_doorbell, &reg->outbound_doorbell_clear);/*clearinterrupt*/- if (outbound_doorbell & ARCMSR_HBCMU_IOP2DRV_DATA_WRITE_OK) {-  arcmsr_iop2drv_data_wrote_handle(pACB);- }- if (outbound_doorbell & ARCMSR_HBCMU_IOP2DRV_DATA_READ_OK) {-  arcmsr_iop2drv_data_read_handle(pACB);- }- if (outbound_doorbell & ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE) {-  arcmsr_hbc_message_isr(pACB);    /* messenger of "driver to iop commands"*/- }- return;+ do {+  if (outbound_doorbell &+   ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE)+   arcmsr_hbaC_message_isr(pACB);+  writel(outbound_doorbell, &reg->outbound_doorbell_clear);+  readl(&reg->outbound_doorbell_clear);+  if (outbound_doorbell &+   ARCMSR_HBCMU_IOP2DRV_DATA_WRITE_OK)+   ar
 cmsr_iop2drv_data_wrote_handle(pACB);+  if (outbound_doorbell &+   ARCMSR_HBCMU_IOP2DRV_DATA_READ_OK)+   arcmsr_iop2drv_data_read_handle(pACB);+  outbound_doorbell = readl(&reg->outbound_doorbell);+ } while (outbound_doorbell & (ARCMSR_HBCMU_IOP2DRV_DATA_WRITE_OK+ | ARCMSR_HBCMU_IOP2DRV_DATA_READ_OK+ | ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE)); }-static void arcmsr_hba_postqueue_isr(struct AdapterControlBlock *acb)++static void+arcmsr_hbaD_doorbell_isr(struct AdapterControlBlock *pACB)+{+ uint32_t outbound_doorbell;+ struct MessageUnit_D __iomem *pmu = pACB->pmuD;++ outbound_doorbell = readl(pmu->outbound_doorbell);+ do {+  writel(outbound_doorbell, pmu->outbound_doorbell);+  if (outbound_doorbell &+   ARCMSR_ARC1214_IOP2DRV_MESSAGE_CMD_DONE)+   arcmsr_hbaD_message_isr(pACB);+  if (outboun
 d_doorbell &+   ARCMSR_ARC1214_IOP2DRV_DATA_WRITE_OK)+   arcmsr_iop2drv_data_wrote_handle(pACB);+  if (outbound_doorbell &+   ARCMSR_ARC1214_IOP2DRV_DATA_READ_OK)+   arcmsr_iop2drv_data_read_handle(pACB);+  outbound_doorbell = readl(pmu->outbound_doorbell);+ } while (outbound_doorbell & (ARCMSR_ARC1214_IOP2DRV_DATA_WRITE_OK+ | ARCMSR_ARC1214_IOP2DRV_DATA_READ_OK+ | ARCMSR_ARC1214_IOP2DRV_MESSAGE_CMD_DONE));+}++static void+arcmsr_hbaA_postqueue_isr(struct AdapterControlBlock *acb) {  uint32_t flag_ccb;  struct MessageUnit_A __iomem *reg = acb->pmuA;@@ -1482,26 +2246,34 @@ static void arcmsr_hba_postqueue_isr(str  struct CommandControlBlock *pCCB;  bool error;  while ((flag_ccb = readl(&reg->outbound_queueport)) != 0xFFFFFFFF) {-  pARCMSR_CDB = (struct ARCMSR_CDB *)(acb->vir2phy_offset + (
 flag_ccb <<5));/*frame must be 32 bytes aligned*/-  pCCB = container_of(pARCMSR_CDB, struct CommandControlBlock, arcmsr_cdb);-  error = (flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR_MODE0) ? true : false;+  pARCMSR_CDB = (struct ARCMSR_CDB *)+   (acb->vir2phy_offset + (flag_ccb << 5));+  pCCB = container_of(pARCMSR_CDB,+   struct CommandControlBlock, arcmsr_cdb);+  error = (flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR_MODE0)+   ? true : false;   arcmsr_drain_donequeue(acb, pCCB, error);  } }-static void arcmsr_hbb_postqueue_isr(struct AdapterControlBlock *acb)+static void+arcmsr_hbaB_postqueue_isr(struct AdapterControlBlock *acb) {  uint32_t index;  uint32_t flag_ccb;- struct MessageUnit_B *reg = acb->pmuB;+ struct MessageUnit_B __iomem *reg = acb->pmuB;  struct ARCMSR_CDB *pARCMSR_CDB;  struct Comman
 dControlBlock *pCCB;  bool error;  index = reg->doneq_index;  while ((flag_ccb = readl(&reg->done_qbuffer[index])) != 0) {   writel(0, &reg->done_qbuffer[index]);-  pARCMSR_CDB = (struct ARCMSR_CDB *)(acb->vir2phy_offset+(flag_ccb <<5));/*frame must be 32 bytes aligned*/-  pCCB = container_of(pARCMSR_CDB, struct CommandControlBlock, arcmsr_cdb);-  error = (flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR_MODE0) ? true : false;+  pARCMSR_CDB = (struct ARCMSR_CDB *)+  (acb->vir2phy_offset + (flag_ccb << 5));+  pCCB = container_of(pARCMSR_CDB,+  struct CommandControlBlock, arcmsr_cdb);+  error = (flag_ccb &+  ARCMSR_CCBREPLY_FLAG_ERROR_MODE0)+  ? true : false;   arcmsr_drain_donequeue(acb, pCCB, error);   index++;   index %= ARCMSR_MAX_HBB_POSTQUEUE;@@ -1509,178 +2281,257 @@ static void arcmsr_hbb_pos
 tqueue_isr(str  } }-static void arcmsr_hbc_postqueue_isr(struct AdapterControlBlock *acb)+static void+arcmsr_hbaC_postqueue_isr(struct AdapterControlBlock *acb) {- struct MessageUnit_C *phbcmu;- struct ARCMSR_CDB *arcmsr_cdb;- struct CommandControlBlock *ccb;  uint32_t flag_ccb, ccb_cdb_phy, throttling = 0;  int error;+ struct MessageUnit_C __iomem *phbcmu;+ struct ARCMSR_CDB *arcmsr_cdb;+ struct CommandControlBlock *ccb;- phbcmu = (struct MessageUnit_C *)acb->pmuC;+ phbcmu = acb->pmuC;  /* areca cdb command done */  /* Use correct offset and size for syncing */+ do {+  /* check if command done with no error*/+  flag_ccb = readl(&phbcmu->outbound_queueport_low);+  ccb_cdb_phy = (flag_ccb & 0xFFFFFFF0);+  arcmsr_cdb = (struct ARCMSR_CDB *)(acb->vir2phy_offset+   + ccb_cdb_phy);+  ccb = co
 ntainer_of(arcmsr_cdb, struct CommandControlBlock,+   arcmsr_cdb);+  error = (flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR_MODE1)+   ? true : false;+  /* check if command done with no error */+  arcmsr_drain_donequeue(acb, ccb, error);+  throttling++;+  if (throttling == ARCMSR_HBC_ISR_THROTTLING_LEVEL) {+   writel(ARCMSR_HBCMU_DRV2IOP_POSTQUEUE_THROTTLING,+    &phbcmu->inbound_doorbell);+   throttling = 0;+  }+ } while (readl(&phbcmu->host_int_status) &+ ARCMSR_HBCMU_OUTBOUND_POSTQUEUE_ISR);+}- while (readl(&phbcmu->host_int_status) &- ARCMSR_HBCMU_OUTBOUND_POSTQUEUE_ISR){- /* check if command done with no error*/- flag_ccb = readl(&phbcmu->outbound_queueport_low);- ccb_cdb_phy = (flag_ccb & 0xFFFFFFF0);/*frame must be 32 bytes aligned*/- arcmsr_cdb = (struct ARCMSR_CDB *)(acb->vir2phy_offset 
 + ccb_cdb_phy);- ccb = container_of(arcmsr_cdb, struct CommandControlBlock, arcmsr_cdb);- error = (flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR_MODE1) ? true : false;- /* check if command done with no error */- arcmsr_drain_donequeue(acb, ccb, error);- if (throttling == ARCMSR_HBC_ISR_THROTTLING_LEVEL) {-  writel(ARCMSR_HBCMU_DRV2IOP_POSTQUEUE_THROTTLING,&phbcmu->inbound_doorbell);-  break;- }- throttling++;- }+static void+arcmsr_hbaD_postqueue_isr(struct AdapterControlBlock *acb)+{+ u32 outbound_write_pointer, doneq_index, index_stripped;+ uint32_t addressLow, ccb_cdb_phy;+ int error;+ struct MessageUnit_D __iomem *pmu;+ struct ARCMSR_CDB *arcmsr_cdb;+ struct CommandControlBlock *ccb;+ unsigned long flags;++ spin_lock_irqsave(&acb->doneq_lock, flags);+ pmu = acb->pmuD;+ outbound_write_pointer 
 = pmu->done_qbuffer[0].addressLow + 1;+ doneq_index = pmu->doneq_index;+ if ((doneq_index & 0xFFF) != (outbound_write_pointer & 0xFFF)) {+  do {+   if (doneq_index & 0x4000) {+    index_stripped = doneq_index & 0xFFF;+    index_stripped += 1;+    index_stripped %= ARCMSR_MAX_ARC1214_DONEQUEUE;+    pmu->doneq_index = index_stripped+    ? (index_stripped | 0x4000) : (index_stripped + 1);+   } else {+    index_stripped = doneq_index;+    index_stripped += 1;+    index_stripped %= ARCMSR_MAX_ARC1214_DONEQUEUE;+    pmu->doneq_index = index_stripped+    ? index_stripped : ((index_stripped | 0x4000) + 1);+   }+   doneq_index = pmu->doneq_index;+   addressLow =+   pmu->done_qbuffer[doneq_index & 0xFFF].addressLow;+   ccb_cdb_phy = (addressLow & 0xFFFFFFF0);+   arcmsr_cdb = (struct ARCMSR_CDB *)(
 acb->vir2phy_offset+    + ccb_cdb_phy);+   ccb = container_of(arcmsr_cdb,+    struct CommandControlBlock, arcmsr_cdb);+   error = (addressLow & ARCMSR_CCBREPLY_FLAG_ERROR_MODE1)+    ? true : false;+   arcmsr_drain_donequeue(acb, ccb, error);+   writel(doneq_index,+    pmu->outboundlist_read_pointer);+  } while ((doneq_index & 0xFFF) !=+  (outbound_write_pointer & 0xFFF));+ }+ writel(ARCMSR_ARC1214_OUTBOUND_LIST_INTERRUPT_CLEAR,+  pmu->outboundlist_interrupt_cause);+ readl(pmu->outboundlist_interrupt_cause);+ spin_unlock_irqrestore(&acb->doneq_lock, flags); }-/*-**********************************************************************************-** Handle a message interrupt-**-** The only message interrupt we expect is in response to a query for thecurrent adapter config.-** We want this i
 n order to compare the drivemap so that we can detectnewly-attached drives.-**********************************************************************************-*/-static void arcmsr_hba_message_isr(struct AdapterControlBlock *acb)++static void+arcmsr_hbaA_message_isr(struct AdapterControlBlock *acb) {- struct MessageUnit_A *reg  = acb->pmuA;+ struct MessageUnit_A __iomem *reg  = acb->pmuA;  /*clear interrupt and message state*/  writel(ARCMSR_MU_OUTBOUND_MESSAGE0_INT, &reg->outbound_intstatus);  schedule_work(&acb->arcmsr_do_message_isr_bh); }-static void arcmsr_hbb_message_isr(struct AdapterControlBlock *acb)+static void+arcmsr_hbaB_message_isr(struct AdapterControlBlock *acb) {- struct MessageUnit_B *reg  = acb->pmuB;+ struct MessageUnit_B __iomem *reg  = acb->pmuB;  /*clear interrupt a
 nd message state*/  writel(ARCMSR_MESSAGE_INT_CLEAR_PATTERN, reg->iop2drv_doorbell);  schedule_work(&acb->arcmsr_do_message_isr_bh); }-/*-**********************************************************************************-** Handle a message interrupt-**-** The only message interrupt we expect is in response to a query for the-** current adapter config.-** We want this in order to compare the drivemap so that we can detectnewly-attached drives.-**********************************************************************************-*/-static void arcmsr_hbc_message_isr(struct AdapterControlBlock *acb)++static void+arcmsr_hbaC_message_isr(struct AdapterControlBlock *acb) {- struct MessageUnit_C *reg  = acb->pmuC;+ struct MessageUnit_C __iomem *reg  = acb->pmuC;  /*clear interrupt and message sta
 te*/- writel(ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE_DOORBELL_CLEAR,&reg->outbound_doorbell_clear);+ writel(ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE_DOORBELL_CLEAR,+ &reg->outbound_doorbell_clear);  schedule_work(&acb->arcmsr_do_message_isr_bh); }-static int arcmsr_handle_hba_isr(struct AdapterControlBlock *acb)+static void+arcmsr_hbaD_message_isr(struct AdapterControlBlock *acb)+{+ struct MessageUnit_D __iomem *reg  = acb->pmuD;+ writel(ARCMSR_ARC1214_IOP2DRV_MESSAGE_CMD_DONE,+  reg->outbound_doorbell);+ readl(reg->outbound_doorbell);+ schedule_work(&acb->arcmsr_do_message_isr_bh);+}++static irqreturn_t+arcmsr_hbaA_handle_isr(struct AdapterControlBlock *acb) {  uint32_t outbound_intstatus;  struct MessageUnit_A __iomem *reg = acb->pmuA;- outbound_intstatus = readl(&reg->outbound_intstatus) &
 -  acb->outbound_int_enable;- if (!(outbound_intstatus & ARCMSR_MU_OUTBOUND_HANDLE_INT)) {-  return 1;- }- writel(outbound_intstatus, &reg->outbound_intstatus);- if (outbound_intstatus & ARCMSR_MU_OUTBOUND_DOORBELL_INT) {-  arcmsr_hba_doorbell_isr(acb);- }- if (outbound_intstatus & ARCMSR_MU_OUTBOUND_POSTQUEUE_INT) {-  arcmsr_hba_postqueue_isr(acb);- }- if(outbound_intstatus & ARCMSR_MU_OUTBOUND_MESSAGE0_INT)  {-  /* messenger of "driver to iop commands" */-  arcmsr_hba_message_isr(acb);- }- return 0;+ outbound_intstatus =+ readl(&reg->outbound_intstatus) & acb->outbound_int_enable;+ if (!(outbound_intstatus & ARCMSR_MU_OUTBOUND_HANDLE_INT))+  return IRQ_NONE;+ do {+  writel(outbound_intstatus, &reg->outbound_intstatus);+  if (outbound_intstatus & ARCMSR_MU_OUTBOUND_DOORBELL_INT)+   arcm
 sr_hbaA_doorbell_isr(acb);+  if (outbound_intstatus & ARCMSR_MU_OUTBOUND_POSTQUEUE_INT)+   arcmsr_hbaA_postqueue_isr(acb);+  if (outbound_intstatus & ARCMSR_MU_OUTBOUND_MESSAGE0_INT)+   arcmsr_hbaA_message_isr(acb);+  outbound_intstatus = readl(&reg->outbound_intstatus) &+   acb->outbound_int_enable;+ } while (outbound_intstatus & (ARCMSR_MU_OUTBOUND_DOORBELL_INT+ | ARCMSR_MU_OUTBOUND_POSTQUEUE_INT+ | ARCMSR_MU_OUTBOUND_MESSAGE0_INT));+ return IRQ_HANDLED; }-static int arcmsr_handle_hbb_isr(struct AdapterControlBlock *acb)+static irqreturn_t+arcmsr_hbaB_handle_isr(struct AdapterControlBlock *acb) {  uint32_t outbound_doorbell;- struct MessageUnit_B *reg = acb->pmuB;- outbound_doorbell = readl(reg->iop2drv_doorbell) &-    acb->outbound_int_enable;+ struct MessageUnit_B __iomem *reg = acb-
 >pmuB;+ outbound_doorbell = readl(reg->iop2drv_doorbell)+  & acb->outbound_int_enable;  if (!outbound_doorbell)-  return 1;-- writel(~outbound_doorbell, reg->iop2drv_doorbell);- /*in case the last action of doorbell interrupt clearance is cached,- this action can push HW to write down the clear bit*/- readl(reg->iop2drv_doorbell);- writel(ARCMSR_DRV2IOP_END_OF_INTERRUPT, reg->drv2iop_doorbell);- if (outbound_doorbell & ARCMSR_IOP2DRV_DATA_WRITE_OK) {-  arcmsr_iop2drv_data_wrote_handle(acb);- }- if (outbound_doorbell & ARCMSR_IOP2DRV_DATA_READ_OK) {-  arcmsr_iop2drv_data_read_handle(acb);- }- if (outbound_doorbell & ARCMSR_IOP2DRV_CDB_DONE) {-  arcmsr_hbb_postqueue_isr(acb);- }- if(outbound_doorbell & ARCMSR_IOP2DRV_MESSAGE_CMD_DONE) {-  /* messenger of "driver to iop commands" */-  arcms
 r_hbb_message_isr(acb);- }- return 0;+  return IRQ_NONE;+ do {+  writel(~outbound_doorbell, reg->iop2drv_doorbell);+  readl(reg->iop2drv_doorbell);+  writel(ARCMSR_DRV2IOP_END_OF_INTERRUPT,+   reg->drv2iop_doorbell);+  readl(reg->drv2iop_doorbell);+  if (outbound_doorbell & ARCMSR_IOP2DRV_DATA_WRITE_OK)+   arcmsr_iop2drv_data_wrote_handle(acb);+  if (outbound_doorbell & ARCMSR_IOP2DRV_DATA_READ_OK)+   arcmsr_iop2drv_data_read_handle(acb);+  if (outbound_doorbell & ARCMSR_IOP2DRV_CDB_DONE)+   arcmsr_hbaB_postqueue_isr(acb);+  if (outbound_doorbell & ARCMSR_IOP2DRV_MESSAGE_CMD_DONE)+   arcmsr_hbaB_message_isr(acb);+  outbound_doorbell = readl(reg->iop2drv_doorbell) &+   acb->outbound_int_enable;+ } while (outbound_doorbell & (ARCMSR_IOP2DRV_DATA_WRITE_OK+ | ARCMSR_IOP2DRV_DATA_READ_OK+ | A
 RCMSR_IOP2DRV_CDB_DONE+ | ARCMSR_IOP2DRV_MESSAGE_CMD_DONE));+ return IRQ_HANDLED; }-static int arcmsr_handle_hbc_isr(struct AdapterControlBlock *pACB)+static irqreturn_t+arcmsr_hbaC_handle_isr(struct AdapterControlBlock *pACB) {  uint32_t host_interrupt_status;- struct MessageUnit_C *phbcmu = (struct MessageUnit_C *)pACB->pmuC;- /*- *********************************************- **   check outbound intstatus- *********************************************- */- host_interrupt_status = readl(&phbcmu->host_int_status);- if (!host_interrupt_status) {-  /*it must be share irq*/-  return 1;- }- /* MU ioctl transfer doorbell interrupts*/- if (host_interrupt_status & ARCMSR_HBCMU_OUTBOUND_DOORBELL_ISR) {-  arcmsr_hbc_doorbell_isr(pACB);   /* messenger of "ioctl message readwrite" */- }- /* MU pos
 t queue interrupts*/- if (host_interrupt_status & ARCMSR_HBCMU_OUTBOUND_POSTQUEUE_ISR) {-  arcmsr_hbc_postqueue_isr(pACB);  /* messenger of "scsi commands" */- }- return 0;+ struct MessageUnit_C __iomem *phbcmu = pACB->pmuC;+ host_interrupt_status =+  readl(&phbcmu->host_int_status);+ do {+  if (host_interrupt_status &+   ARCMSR_HBCMU_OUTBOUND_DOORBELL_ISR)+   arcmsr_hbaC_doorbell_isr(pACB);+  /* MU post queue interrupts*/+  if (host_interrupt_status &+   ARCMSR_HBCMU_OUTBOUND_POSTQUEUE_ISR)+   arcmsr_hbaC_postqueue_isr(pACB);+  host_interrupt_status = readl(&phbcmu->host_int_status);+ } while (host_interrupt_status &+ (ARCMSR_HBCMU_OUTBOUND_POSTQUEUE_ISR |+ ARCMSR_HBCMU_OUTBOUND_DOORBELL_ISR));+ return IRQ_HANDLED;+}++static irqreturn_t+arcmsr_hbaD_handle_isr(struct AdapterControlBlock 
 *pACB)+{+ u32 host_interrupt_status;+ struct MessageUnit_D __iomem *pmu = pACB->pmuD;+ host_interrupt_status = readl(pmu->host_int_status);+ do {+  /* MU post queue interrupts*/+  if (host_interrupt_status &+   ARCMSR_ARC1214_OUTBOUND_POSTQUEUE_ISR)+   arcmsr_hbaD_postqueue_isr(pACB);+  if (host_interrupt_status &+   ARCMSR_ARC1214_OUTBOUND_DOORBELL_ISR)+   arcmsr_hbaD_doorbell_isr(pACB);+  host_interrupt_status = readl(pmu->host_int_status);+ } while (host_interrupt_status &+ (ARCMSR_ARC1214_OUTBOUND_POSTQUEUE_ISR |+ ARCMSR_ARC1214_OUTBOUND_DOORBELL_ISR));+ return IRQ_HANDLED; }-static irqreturn_t arcmsr_interrupt(struct AdapterControlBlock *acb)++static irqreturn_t+arcmsr_interrupt(struct AdapterControlBlock *acb) {  switch (acb->adapter_type) {  case ACB_ADAPTER_TYPE_A: {-  if (arcmsr
 _handle_hba_isr(acb)) {-   return IRQ_NONE;-  }-  }+  return arcmsr_hbaA_handle_isr(acb);   break;-+ }  case ACB_ADAPTER_TYPE_B: {-  if (arcmsr_handle_hbb_isr(acb)) {-   return IRQ_NONE;-  }-  }+  return arcmsr_hbaB_handle_isr(acb);   break;-  case ACB_ADAPTER_TYPE_C: {-  if (arcmsr_handle_hbc_isr(acb)) {-   return IRQ_NONE;-  }-  }  }- return IRQ_HANDLED;+ case ACB_ADAPTER_TYPE_C: {+  return arcmsr_hbaC_handle_isr(acb);+  break;+ }+ case ACB_ADAPTER_TYPE_D: {+  return arcmsr_hbaD_handle_isr(acb);+  break;+ }+ default:+  return IRQ_NONE;+ } }-static void arcmsr_iop_parking(struct AdapterControlBlock *acb)+static void+arcmsr_iop_parking(struct AdapterControlBlock *acb) {  if (acb) {   /* stop adapter background rebuild */@@ -1695,309 +2546,372 @@ static void arcmsr_iop_parking(struct Ad  
 } }-void arcmsr_post_ioctldata2iop(struct AdapterControlBlock *acb)+void+arcmsr_clear_iop2drv_rqueue_buffer(struct AdapterControlBlock *acb) {- int32_t wqbuf_firstindex, wqbuf_lastindex;- uint8_t *pQbuffer;- struct QBUFFER __iomem *pwbuffer;- uint8_t __iomem *iop_data;- int32_t allxfer_len = 0;- pwbuffer = arcmsr_get_iop_wqbuffer(acb);- iop_data = (uint8_t __iomem *)pwbuffer->data;- if (acb->acb_flags & ACB_F_MESSAGE_WQBUFFER_READED) {-  acb->acb_flags &= (~ACB_F_MESSAGE_WQBUFFER_READED);-  wqbuf_firstindex = acb->wqbuf_firstindex;-  wqbuf_lastindex = acb->wqbuf_lastindex;-  while ((wqbuf_firstindex != wqbuf_lastindex) && (allxfer_len < 124)) {-   pQbuffer = &acb->wqbuffer[wqbuf_firstindex];-   memcpy(iop_data, pQbuffer, 1);-   wqbuf_firstindex++;-   wqbuf_firstindex %= ARCMSR_MAX_QBUFFE
 R;-   iop_data++;-   allxfer_len++;+ uint32_t i;++ if (acb->acb_flags & ACB_F_IOPDATA_OVERFLOW) {+  for (i = 0; i < 15; i++) {+   if (acb->acb_flags & ACB_F_IOPDATA_OVERFLOW) {+    acb->acb_flags &= ~ACB_F_IOPDATA_OVERFLOW;+    acb->rqbuf_firstindex = 0;+    acb->rqbuf_lastindex = 0;+    arcmsr_iop_message_read(acb);+    mdelay(30);+   } else if (acb->rqbuf_firstindex != acb->rqbuf_lastindex) {+    acb->rqbuf_firstindex = 0;+    acb->rqbuf_lastindex = 0;+    mdelay(30);+   } else+    break;   }-  acb->wqbuf_firstindex = wqbuf_firstindex;-  pwbuffer->data_len = allxfer_len;-  arcmsr_iop_message_wrote(acb);  } }-static int arcmsr_iop_message_xfer(struct AdapterControlBlock *acb,+static int+arcmsr_iop_message_xfer(struct AdapterControlBlock *acb,      struct scsi_cmnd *cmd) {- struct CMD_ME
 SSAGE_FIELD *pcmdmessagefld;- int retvalue = 0, transfer_len = 0;  char *buffer;+ unsigned short use_sg;+ int retvalue = 0, transfer_len = 0;+ unsigned long flags;+ struct CMD_MESSAGE_FIELD *pcmdmessagefld;+ uint32_t controlcode = (uint32_t)cmd->cmnd[5] << 24 |+  (uint32_t)cmd->cmnd[6] << 16 |+  (uint32_t)cmd->cmnd[7] << 8 |+  (uint32_t)cmd->cmnd[8];  struct scatterlist *sg;- uint32_t controlcode = (uint32_t ) cmd->cmnd[5] << 24 |-      (uint32_t ) cmd->cmnd[6] << 16 |-      (uint32_t ) cmd->cmnd[7] << 8  |-      (uint32_t ) cmd->cmnd[8];-      /* 4 bytes: Areca io control code */++ use_sg = scsi_sg_count(cmd);  sg = scsi_sglist(cmd);  buffer = kmap_atomic(sg_page(sg)) + sg->offset;- if (scsi_sg_count(cmd) > 1) {+ if (use_sg > 1) {   retvalue = ARCMSR_MESSAGE_FAIL;   goto message_out;  }
   transfer_len += sg->length;-  if (transfer_len > sizeof(struct CMD_MESSAGE_FIELD)) {   retvalue = ARCMSR_MESSAGE_FAIL;+  pr_info("%s: ARCMSR_MESSAGE_FAIL!\n", __func__);   goto message_out;  }- pcmdmessagefld = (struct CMD_MESSAGE_FIELD *) buffer;- switch(controlcode) {-+ pcmdmessagefld = (struct CMD_MESSAGE_FIELD *)buffer;+ switch (controlcode) {  case ARCMSR_MESSAGE_READ_RQBUFFER: {   unsigned char *ver_addr;   uint8_t *pQbuffer, *ptmpQbuffer;-  int32_t allxfer_len = 0;--  ver_addr = kmalloc(1032, GFP_ATOMIC);+  uint32_t allxfer_len = 0;+  ver_addr = (unsigned char *)kmalloc(1032, GFP_ATOMIC);   if (!ver_addr) {    retvalue = ARCMSR_MESSAGE_FAIL;+   pr_info("%s: memory not enough!\n", __func__);    goto message_out;   }-   ptmpQbuffer = ver_addr;-  while ((acb->rqbuf_firstindex != ac
 b->rqbuf_lastindex)-   && (allxfer_len < 1031)) {+  spin_lock_irqsave(&acb->rqbuffer_lock, flags);+  if (acb->rqbuf_firstindex != acb->rqbuf_lastindex) {    pQbuffer = &acb->rqbuffer[acb->rqbuf_firstindex];-   memcpy(ptmpQbuffer, pQbuffer, 1);-   acb->rqbuf_firstindex++;-   acb->rqbuf_firstindex %= ARCMSR_MAX_QBUFFER;-   ptmpQbuffer++;-   allxfer_len++;+   if (acb->rqbuf_firstindex > acb->rqbuf_lastindex) {+    if ((ARCMSR_MAX_QBUFFER -+     acb->rqbuf_firstindex) >= 1032) {+     memcpy((void *)ptmpQbuffer, (const void *)pQbuffer, 1032);+     acb->rqbuf_firstindex += 1032;+     acb->rqbuf_firstindex %= ARCMSR_MAX_QBUFFER;+     allxfer_len = 1032;+    } else {+     if (((ARCMSR_MAX_QBUFFER -+      acb->rqbuf_firstindex) ++      acb->rqbuf_lastindex) > 1032) {+      memcpy((void *)ptmpQbuf
 fer,+      (const void *)pQbuffer, ARCMSR_MAX_QBUFFER+      - acb->rqbuf_firstindex);+      ptmpQbuffer +=+      ARCMSR_MAX_QBUFFER -+      acb->rqbuf_firstindex;+      memcpy((void *)ptmpQbuffer,+      (const void *)acb->rqbuffer, 1032 -+      (ARCMSR_MAX_QBUFFER+      - acb->rqbuf_firstindex));+      acb->rqbuf_firstindex =+      1032 - (ARCMSR_MAX_QBUFFER+      - acb->rqbuf_firstindex);+      allxfer_len = 1032;+     } else {+      memcpy((void *)ptmpQbuffer,+      (const void *)pQbuffer, ARCMSR_MAX_QBUFFER+      - acb->rqbuf_firstindex);+      ptmpQbuffer +=+      ARCMSR_MAX_QBUFFER -+      acb->rqbuf_firstindex;+      memcpy((void *)ptmpQbuffer,+      (const void *)acb->rqbuffer,+      acb->rqbuf_lastindex);+      allxfer_len = ARCMSR_MAX_QBUFFER+      - acb->rqbuf_firstindex ++    
   acb->rqbuf_lastindex;+      acb->rqbuf_firstindex =+      acb->rqbuf_lastindex;+     }+    }+   } else {+    if ((acb->rqbuf_lastindex -+    acb->rqbuf_firstindex) > 1032) {+     memcpy((void *)ptmpQbuffer,+     (const void *)pQbuffer, 1032);+     acb->rqbuf_firstindex += 1032;+     allxfer_len = 1032;+    } else {+     memcpy((void *)ptmpQbuffer, (const void *)pQbuffer,+     acb->rqbuf_lastindex - acb->rqbuf_firstindex);+     allxfer_len = acb->rqbuf_lastindex+     - acb->rqbuf_firstindex;+     acb->rqbuf_firstindex =+     acb->rqbuf_lastindex;+    }+   }   }+  memcpy((void *)pcmdmessagefld->messagedatabuffer,+   (const void *)ver_addr, allxfer_len);   if (acb->acb_flags & ACB_F_IOPDATA_OVERFLOW) {-    struct QBUFFER __iomem *prbuffer;-   uint8_t __iomem *iop_data;-   int32_t iop_len;
 -    acb->acb_flags &= ~ACB_F_IOPDATA_OVERFLOW;    prbuffer = arcmsr_get_iop_rqbuffer(acb);-   iop_data = prbuffer->data;-   iop_len = readl(&prbuffer->data_len);-   while (iop_len > 0) {-    acb->rqbuffer[acb->rqbuf_lastindex] = readb(iop_data);-    acb->rqbuf_lastindex++;-    acb->rqbuf_lastindex %= ARCMSR_MAX_QBUFFER;-    iop_data++;-    iop_len--;-   }-   arcmsr_iop_message_read(acb);+   if (arcmsr_Read_iop_rqbuffer_data(acb, prbuffer) == 0)+    acb->acb_flags |= ACB_F_IOPDATA_OVERFLOW;   }-  memcpy(pcmdmessagefld->messagedatabuffer, ver_addr, allxfer_len);+  spin_unlock_irqrestore(&acb->rqbuffer_lock, flags);+  kfree((const void *)ver_addr);   pcmdmessagefld->cmdmessage.Length = allxfer_len;-  if(acb->fw_flag == FW_DEADLOCK) {-   pcmdmessagefld->cmdmessage.ReturnCode =ARCMSR_MESSAGE
 _RETURNCODE_BUS_HANG_ON;-  }else{-   pcmdmessagefld->cmdmessage.ReturnCode = ARCMSR_MESSAGE_RETURNCODE_OK;-  }-  kfree(ver_addr);+  if (acb->fw_flag == FW_DEADLOCK) {+   pcmdmessagefld->cmdmessage.ReturnCode =+   ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;+  } else {+   pcmdmessagefld->cmdmessage.ReturnCode =+   ARCMSR_MESSAGE_RETURNCODE_OK;   }   break;-+ }  case ARCMSR_MESSAGE_WRITE_WQBUFFER: {   unsigned char *ver_addr;-  int32_t my_empty_len, user_len, wqbuf_firstindex, wqbuf_lastindex;+  int32_t my_empty_len, user_len, wqbuf_firstindex,+  wqbuf_lastindex;   uint8_t *pQbuffer, *ptmpuserbuffer;--  ver_addr = kmalloc(1032, GFP_ATOMIC);+  ver_addr = (unsigned char *)kmalloc(1032, GFP_ATOMIC);   if (!ver_addr) {    retvalue = ARCMSR_MESSAGE_FAIL;    goto message_out;   }-  if(acb->fw_flag == 
 FW_DEADLOCK) {-   pcmdmessagefld->cmdmessage.ReturnCode =-   ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;-  }else{-   pcmdmessagefld->cmdmessage.ReturnCode =-   ARCMSR_MESSAGE_RETURNCODE_OK;-  }   ptmpuserbuffer = ver_addr;   user_len = pcmdmessagefld->cmdmessage.Length;-  memcpy(ptmpuserbuffer, pcmdmessagefld->messagedatabuffer, user_len);+  memcpy((void *)ptmpuserbuffer,+  (const void *)pcmdmessagefld->messagedatabuffer, user_len);+  spin_lock_irqsave(&acb->wqbuffer_lock, flags);   wqbuf_lastindex = acb->wqbuf_lastindex;   wqbuf_firstindex = acb->wqbuf_firstindex;   if (wqbuf_lastindex != wqbuf_firstindex) {    struct SENSE_DATA *sensebuffer =-    (struct SENSE_DATA *)cmd->sense_buffer;-   arcmsr_post_ioctldata2iop(acb);+   (struct SENSE_DATA *)cmd->sense_buffer;+   arcmsr_write_ioctldata2io
 p(acb);    /* has error report sensedata */-   sensebuffer->ErrorCode = 0x70;+   sensebuffer->ErrorCode = SCSI_SENSE_CURRENT_ERRORS;    sensebuffer->SenseKey = ILLEGAL_REQUEST;    sensebuffer->AdditionalSenseLength = 0x0A;    sensebuffer->AdditionalSenseCode = 0x20;    sensebuffer->Valid = 1;    retvalue = ARCMSR_MESSAGE_FAIL;   } else {-   my_empty_len = (wqbuf_firstindex-wqbuf_lastindex - 1)-    &(ARCMSR_MAX_QBUFFER - 1);+   my_empty_len = (wqbuf_firstindex - wqbuf_lastindex - 1)+   & (ARCMSR_MAX_QBUFFER - 1);    if (my_empty_len >= user_len) {     while (user_len > 0) {-     pQbuffer =-     &acb->wqbuffer[acb->wqbuf_lastindex];-     memcpy(pQbuffer, ptmpuserbuffer, 1);-     acb->wqbuf_lastindex++;-     acb->wqbuf_lastindex %= ARCMSR_MAX_QBUFFER;-     ptmpuserbuffer++;-     user_len--;
 +     pQbuffer = &acb->wqbuffer[acb->wqbuf_lastindex];+     if ((acb->wqbuf_lastindex + user_len)+      > ARCMSR_MAX_QBUFFER) {+      memcpy((void *)pQbuffer,+      (const void *)ptmpuserbuffer,+      ARCMSR_MAX_QBUFFER -+      acb->wqbuf_lastindex);+      ptmpuserbuffer += (ARCMSR_MAX_QBUFFER+      - acb->wqbuf_lastindex);+      user_len -= (ARCMSR_MAX_QBUFFER+      - acb->wqbuf_lastindex);+      acb->wqbuf_lastindex = 0;+     } else {+      memcpy((void *)pQbuffer,+      (const void *)ptmpuserbuffer,+      user_len);+      acb->wqbuf_lastindex += user_len;+      acb->wqbuf_lastindex %=+      ARCMSR_MAX_QBUFFER;+      user_len = 0;+     }     }-    if (acb->acb_flags & ACB_F_MESSAGE_WQBUFFER_CLEARED) {+    if (acb->acb_flags &+    ACB_F_MESSAGE_WQBUFFER_CLEARED) {      acb->acb_flags &=
 -      ~ACB_F_MESSAGE_WQBUFFER_CLEARED;-     arcmsr_post_ioctldata2iop(acb);+     ~ACB_F_MESSAGE_WQBUFFER_CLEARED;+     arcmsr_write_ioctldata2iop(acb);     }    } else {-    /* has error report sensedata */     struct SENSE_DATA *sensebuffer =-     (struct SENSE_DATA *)cmd->sense_buffer;-    sensebuffer->ErrorCode = 0x70;+    (struct SENSE_DATA *)cmd->sense_buffer;+    /* has error report sensedata */+    sensebuffer->ErrorCode =+    SCSI_SENSE_CURRENT_ERRORS;     sensebuffer->SenseKey = ILLEGAL_REQUEST;     sensebuffer->AdditionalSenseLength = 0x0A;     sensebuffer->AdditionalSenseCode = 0x20;     sensebuffer->Valid = 1;     retvalue = ARCMSR_MESSAGE_FAIL;    }-   }-   kfree(ver_addr);+  }+  spin_unlock_irqrestore(&acb->wqbuffer_lock, flags);+  kfree((const void *)ver_addr);+  if (acb-
 >fw_flag == FW_DEADLOCK) {+   pcmdmessagefld->cmdmessage.ReturnCode =+   ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;+  } else {+   pcmdmessagefld->cmdmessage.ReturnCode =+   ARCMSR_MESSAGE_RETURNCODE_OK;   }   break;-+ }  case ARCMSR_MESSAGE_CLEAR_RQBUFFER: {   uint8_t *pQbuffer = acb->rqbuffer;-  if (acb->acb_flags & ACB_F_IOPDATA_OVERFLOW) {-   acb->acb_flags &= ~ACB_F_IOPDATA_OVERFLOW;-   arcmsr_iop_message_read(acb);-  }++  arcmsr_clear_iop2drv_rqueue_buffer(acb);+  spin_lock_irqsave(&acb->rqbuffer_lock, flags);   acb->acb_flags |= ACB_F_MESSAGE_RQBUFFER_CLEARED;   acb->rqbuf_firstindex = 0;   acb->rqbuf_lastindex = 0;   memset(pQbuffer, 0, ARCMSR_MAX_QBUFFER);-  if(acb->fw_flag == FW_DEADLOCK) {+  spin_unlock_irqrestore(&acb->rqbuffer_lock, flags);+  if (acb->fw_flag == FW_DEADLOCK) {   
  pcmdmessagefld->cmdmessage.ReturnCode =    ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;-  }else{+  } else {    pcmdmessagefld->cmdmessage.ReturnCode =    ARCMSR_MESSAGE_RETURNCODE_OK;   }-  }   break;-+ }  case ARCMSR_MESSAGE_CLEAR_WQBUFFER: {   uint8_t *pQbuffer = acb->wqbuffer;-  if(acb->fw_flag == FW_DEADLOCK) {+  spin_lock_irqsave(&acb->wqbuffer_lock, flags);+  acb->acb_flags |= (ACB_F_MESSAGE_WQBUFFER_CLEARED |+  ACB_F_MESSAGE_WQBUFFER_READED);+  acb->wqbuf_firstindex = 0;+  acb->wqbuf_lastindex = 0;+  memset(pQbuffer, 0, ARCMSR_MAX_QBUFFER);+  spin_unlock_irqrestore(&acb->wqbuffer_lock, flags);+  if (acb->fw_flag == FW_DEADLOCK) {    pcmdmessagefld->cmdmessage.ReturnCode =    ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;-  }else{+  } else {    pcmdmessagefld->cmdmessage.ReturnCode =    ARCMSR_
 MESSAGE_RETURNCODE_OK;   }--  if (acb->acb_flags & ACB_F_IOPDATA_OVERFLOW) {-   acb->acb_flags &= ~ACB_F_IOPDATA_OVERFLOW;-   arcmsr_iop_message_read(acb);-  }-  acb->acb_flags |=-   (ACB_F_MESSAGE_WQBUFFER_CLEARED |-    ACB_F_MESSAGE_WQBUFFER_READED);-  acb->wqbuf_firstindex = 0;-  acb->wqbuf_lastindex = 0;-  memset(pQbuffer, 0, ARCMSR_MAX_QBUFFER);-  }   break;-+ }  case ARCMSR_MESSAGE_CLEAR_ALLQBUFFER: {   uint8_t *pQbuffer;--  if (acb->acb_flags & ACB_F_IOPDATA_OVERFLOW) {-   acb->acb_flags &= ~ACB_F_IOPDATA_OVERFLOW;-   arcmsr_iop_message_read(acb);-  }-  acb->acb_flags |=-   (ACB_F_MESSAGE_WQBUFFER_CLEARED-   | ACB_F_MESSAGE_RQBUFFER_CLEARED-   | ACB_F_MESSAGE_WQBUFFER_READED);+  arcmsr_clear_iop2drv_rqueue_buffer(acb);+  spin_lock_irqsave(&acb->rqbuffer_lock, flags);+  acb->acb_fl
 ags |= ACB_F_MESSAGE_RQBUFFER_CLEARED;   acb->rqbuf_firstindex = 0;   acb->rqbuf_lastindex = 0;-  acb->wqbuf_firstindex = 0;-  acb->wqbuf_lastindex = 0;   pQbuffer = acb->rqbuffer;   memset(pQbuffer, 0, sizeof(struct QBUFFER));+  spin_unlock_irqrestore(&acb->rqbuffer_lock, flags);+  spin_lock_irqsave(&acb->wqbuffer_lock, flags);+  acb->acb_flags |= (ACB_F_MESSAGE_WQBUFFER_CLEARED |+  ACB_F_MESSAGE_WQBUFFER_READED);+  acb->wqbuf_firstindex = 0;+  acb->wqbuf_lastindex = 0;   pQbuffer = acb->wqbuffer;   memset(pQbuffer, 0, sizeof(struct QBUFFER));-  if(acb->fw_flag == FW_DEADLOCK) {+  spin_unlock_irqrestore(&acb->wqbuffer_lock, flags);+  if (acb->fw_flag == FW_DEADLOCK) {    pcmdmessagefld->cmdmessage.ReturnCode =    ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;-  }else{+  } else {    pcmdmessagef
 ld->cmdmessage.ReturnCode =    ARCMSR_MESSAGE_RETURNCODE_OK;   }-  }   break;-+ }  case ARCMSR_MESSAGE_RETURN_CODE_3F: {-  if(acb->fw_flag == FW_DEADLOCK) {+  if (acb->fw_flag == FW_DEADLOCK) {    pcmdmessagefld->cmdmessage.ReturnCode =    ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;-  }else{+  } else {    pcmdmessagefld->cmdmessage.ReturnCode =    ARCMSR_MESSAGE_RETURNCODE_3F;   }   break;-  }+ }  case ARCMSR_MESSAGE_SAY_HELLO: {   int8_t *hello_string = "Hello! I am ARCMSR";-  if(acb->fw_flag == FW_DEADLOCK) {+  if (acb->fw_flag == FW_DEADLOCK) {    pcmdmessagefld->cmdmessage.ReturnCode =    ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;-  }else{+  } else {    pcmdmessagefld->cmdmessage.ReturnCode =    ARCMSR_MESSAGE_RETURNCODE_OK;   }-  memcpy(pcmdmessagefld->messagedatabuffer, hello_string-   , (i
 nt16_t)strlen(hello_string));-  }+  memcpy((void *)pcmdmessagefld->messagedatabuffer,+  (const void *)hello_string, (int16_t)strlen(hello_string));   break;-- case ARCMSR_MESSAGE_SAY_GOODBYE:-  if(acb->fw_flag == FW_DEADLOCK) {+ }+ case ARCMSR_MESSAGE_SAY_GOODBYE: {+  if (acb->fw_flag == FW_DEADLOCK) {    pcmdmessagefld->cmdmessage.ReturnCode =    ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;+  } else {+   pcmdmessagefld->cmdmessage.ReturnCode =+   ARCMSR_MESSAGE_RETURNCODE_OK;   }   arcmsr_iop_parking(acb);   break;-- case ARCMSR_MESSAGE_FLUSH_ADAPTER_CACHE:-  if(acb->fw_flag == FW_DEADLOCK) {+ }+ case ARCMSR_MESSAGE_FLUSH_ADAPTER_CACHE: {+  if (acb->fw_flag == FW_DEADLOCK) {    pcmdmessagefld->cmdmessage.ReturnCode =    ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;+  } else {+   pcmdmessagefld->cmdm
 essage.ReturnCode =+   ARCMSR_MESSAGE_RETURNCODE_OK;   }   arcmsr_flush_adapter_cache(acb);   break;-+ }  default:   retvalue = ARCMSR_MESSAGE_FAIL;+  pr_info("%s: unknown controlcode!\n", __func__);  }  message_out:- sg = scsi_sglist(cmd);- kunmap_atomic(buffer - sg->offset);+ if (use_sg) {+  struct scatterlist *sg;+  sg = scsi_sglist(cmd);+  kunmap_atomic(buffer - sg->offset);+ }  return retvalue; }-static struct CommandControlBlock *arcmsr_get_freeccb(structAdapterControlBlock *acb)+struct CommandControlBlock+*arcmsr_get_freeccb(struct AdapterControlBlock *acb) {  struct list_head *head = &acb->ccb_free_list;  struct CommandControlBlock *ccb = NULL;  unsigned long flags;  spin_lock_irqsave(&acb->ccblist_lock, flags);  if (!list_empty(head)) {-  ccb = list_entry(head->next, struct Comm
 andControlBlock, list);+  ccb = list_entry(head->next,+   struct CommandControlBlock, list);   list_del_init(&ccb->list);- }else{+ } else {   spin_unlock_irqrestore(&acb->ccblist_lock, flags);   return 0;  }@@ -2005,7 +2919,8 @@ static struct CommandControlBlock *arcms  return ccb; }-static void arcmsr_handle_virtual_command(struct AdapterControlBlock *acb,+void+arcmsr_handle_virtual_command(struct AdapterControlBlock *acb,   struct scsi_cmnd *cmd) {  switch (cmd->cmnd[0]) {@@ -2013,7 +2928,6 @@ static void arcmsr_handle_virtual_comman   unsigned char inqdata[36];   char *buffer;   struct scatterlist *sg;-   if (cmd->device->lun) {    cmd->result = (DID_TIME_OUT << 16);    cmd->scsi_done(cmd);@@ -2032,14 +2946,11 @@ static void arcmsr_handle_virtual_comman   strncpy(&inqdata[16], "RAID c
 ontroller ", 16);   /* Product Identification */   strncpy(&inqdata[32], "R001", 4); /* Product Revision */-   sg = scsi_sglist(cmd);   buffer = kmap_atomic(sg_page(sg)) + sg->offset;--  memcpy(buffer, inqdata, sizeof(inqdata));+  memcpy((void *)buffer, (const void *)inqdata, sizeof(inqdata));   sg = scsi_sglist(cmd);   kunmap_atomic(buffer - sg->offset);-   cmd->scsi_done(cmd);  }  break;@@ -2055,11 +2966,13 @@ static void arcmsr_handle_virtual_comman  } }-static int arcmsr_queue_command_lck(struct scsi_cmnd *cmd,+static int+arcmsr_queue_command_lck(struct scsi_cmnd *cmd,  void (* done)(struct scsi_cmnd *)) {  struct Scsi_Host *host = cmd->device->host;- struct AdapterControlBlock *acb = (struct AdapterControlBlock *)host->hostdata;+ struct AdapterControlBlock *acb =+ (struct AdapterCon
 trolBlock *)host->hostdata;  struct CommandControlBlock *ccb;  int target = cmd->device->id;  int lun = cmd->device->lun;@@ -2067,10 +2980,10 @@ static int arcmsr_queue_command_lck(stru  cmd->scsi_done = done;  cmd->host_scribble = NULL;  cmd->result = 0;- if ((scsicmd == SYNCHRONIZE_CACHE) ||(scsicmd == SEND_DIAGNOSTIC)){-  if(acb->devstate[target][lun] == ARECA_RAID_GONE) {-       cmd->result = (DID_NO_CONNECT << 16);-  }+ if ((scsicmd == SYNCHRONIZE_CACHE) ||+  (scsicmd == SEND_DIAGNOSTIC)) {+  if (acb->devstate[target][lun] == ARECA_RAID_GONE)+   cmd->result = (DID_NO_CONNECT << 16);   cmd->scsi_done(cmd);   return 0;  }@@ -2080,13 +2993,14 @@ static int arcmsr_queue_command_lck(stru   return 0;  }  if (atomic_read(&acb->ccboutstandingcount) >=-   ARCMSR_MAX_OUTSTANDING_CMD)+ acb->ma
 xOutstanding)   return SCSI_MLQUEUE_HOST_BUSY;  ccb = arcmsr_get_freeccb(acb);  if (!ccb)   return SCSI_MLQUEUE_HOST_BUSY;  if (arcmsr_build_ccb( acb, ccb, cmd ) == FAILED) {-  cmd->result = (DID_ERROR << 16) | (RESERVATION_CONFLICT << 1);+  cmd->result = (DID_ERROR << 16) |+   (RESERVATION_CONFLICT << 1);   cmd->scsi_done(cmd);   return 0;  }@@ -2096,24 +3010,30 @@ static int arcmsr_queue_command_lck(stru static DEF_SCSI_QCMD(arcmsr_queue_command)-static bool arcmsr_get_hba_config(struct AdapterControlBlock *acb)+static bool+arcmsr_hbaA_get_config(struct AdapterControlBlock *acb) {  struct MessageUnit_A __iomem *reg = acb->pmuA;  char *acb_firm_model = acb->firm_model;  char *acb_firm_version = acb->firm_version;  char *acb_device_map = acb->device_map;- char __iomem *iop_firm_model = (
 char __iomem*)(&reg->message_rwbuffer[15]);- char __iomem *iop_firm_version = (char __iomem*)(&reg->message_rwbuffer[17]);- char __iomem *iop_device_map = (char __iomem*)(&reg->message_rwbuffer[21]);+ char __iomem *iop_firm_model =+  (char __iomem *)(&reg->message_rwbuffer[15]);+ char __iomem *iop_firm_version =+  (char __iomem *)(&reg->message_rwbuffer[17]);+ char __iomem *iop_device_map =+  (char __iomem *)(&reg->message_rwbuffer[21]);  int count;- writel(ARCMSR_INBOUND_MESG0_GET_CONFIG, &reg->inbound_msgaddr0);- if (!arcmsr_hba_wait_msgint_ready(acb)) {-  printk(KERN_NOTICE "arcmsr%d: wait 'get adapter firmware \-   miscellaneous data' timeout \n", acb->host->host_no);+ writel(ARCMSR_INBOUND_MESG0_GET_CONFIG,+  &reg->inbound_msgaddr0);+ if (!arcmsr_hbaA_wait_msgint_ready(acb)) {+  pr_
 notice("arcmsr%d: wait 'get adapter firmware "+  "miscellaneous data' timeout\n",+  acb->host->host_no);   return false;  }  count = 8;- while (count){+ while (count) {   *acb_firm_model = readb(iop_firm_model);   acb_firm_model++;   iop_firm_model++;@@ -2121,7 +3041,7 @@ static bool arcmsr_get_hba_config(struct  }  count = 16;- while (count){+ while (count) {   *acb_firm_version = readb(iop_firm_version);   acb_firm_version++;   iop_firm_version++;@@ -2129,27 +3049,29 @@ static bool arcmsr_get_hba_config(struct  }  count=16;- while(count){+ while (count) {   *acb_device_map = readb(iop_device_map);   acb_device_map++;   iop_device_map++;   count--;  }- printk(KERN_NOTICE "Areca RAID Controller%d: F/W %s & Model %s\n",+ pr_notice("Areca RAID Controller%d: Model %s, F/W %s\n",   acb->host
 ->host_no,-  acb->firm_version,-  acb->firm_model);+  acb->firm_model,+  acb->firm_version);  acb->signature = readl(&reg->message_rwbuffer[0]);  acb->firm_request_len = readl(&reg->message_rwbuffer[1]);  acb->firm_numbers_queue = readl(&reg->message_rwbuffer[2]);  acb->firm_sdram_size = readl(&reg->message_rwbuffer[3]);  acb->firm_hd_channels = readl(&reg->message_rwbuffer[4]);- acb->firm_cfg_version = readl(&reg->message_rwbuffer[25]);/*firm_cfg_version,25,100-103*/+ acb->firm_cfg_version = readl(&reg->message_rwbuffer[25]);  return true; }-static bool arcmsr_get_hbb_config(struct AdapterControlBlock *acb)++static bool+arcmsr_hbaB_get_config(struct AdapterControlBlock *acb) {- struct MessageUnit_B *reg = acb->pmuB;+ struct MessageUnit_B __iomem *reg = acb->pmuB;  struct pci_dev *pdev =
  acb->pdev;  void *dma_coherent;  dma_addr_t dma_coherent_handle;@@ -2163,40 +3085,57 @@ static bool arcmsr_get_hbb_config(struct  char __iomem *iop_device_map;  /*firm_version,21,84-99*/  int count;- dma_coherent = dma_alloc_coherent(&pdev->dev, sizeof(structMessageUnit_B), &dma_coherent_handle, GFP_KERNEL);- if (!dma_coherent){-  printk(KERN_NOTICE "arcmsr%d: dma_alloc_coherent got error for hbb mu\n",acb->host->host_no);+ dma_coherent = dma_alloc_coherent(&pdev->dev,+  sizeof(struct MessageUnit_B), &dma_coherent_handle,+  GFP_KERNEL);+ if (!dma_coherent) {+  pr_notice("arcmsr%d: dma_alloc_coherent "+  "got error for hbb mu\n", acb->host->host_no);   return false;  }- acb->dma_coherent_handle_hbb_mu = dma_coherent_handle;- reg = (struct MessageUnit_B *)dma_coherent;+ acb->dma_coherent_
 handle2 = dma_coherent_handle;+ reg = (struct MessageUnit_B __iomem *)dma_coherent;  acb->pmuB = reg;- reg->drv2iop_doorbell= (uint32_t __iomem *)((unsigned long)acb->mem_base0+ ARCMSR_DRV2IOP_DOORBELL);- reg->drv2iop_doorbell_mask = (uint32_t __iomem *)((unsignedlong)acb->mem_base0 + ARCMSR_DRV2IOP_DOORBELL_MASK);- reg->iop2drv_doorbell = (uint32_t __iomem *)((unsigned long)acb->mem_base0+ ARCMSR_IOP2DRV_DOORBELL);- reg->iop2drv_doorbell_mask = (uint32_t __iomem *)((unsignedlong)acb->mem_base0 + ARCMSR_IOP2DRV_DOORBELL_MASK);- reg->message_wbuffer = (uint32_t __iomem *)((unsigned long)acb->mem_base1+ ARCMSR_MESSAGE_WBUFFER);- reg->message_rbuffer =  (uint32_t __iomem *)((unsigned long)acb->mem_base1+ ARCMSR_MESSAGE_RBUFFER);- reg->message_rwbuffer = (uint32_t __iomem *)((unsigned long)a
 cb->mem_base1+ ARCMSR_MESSAGE_RWBUFFER);- iop_firm_model = (char __iomem *)(&reg->message_rwbuffer[15]);/*firm_model,15,60-67*/- iop_firm_version = (char __iomem *)(&reg->message_rwbuffer[17]);/*firm_version,17,68-83*/- iop_device_map = (char __iomem *)(&reg->message_rwbuffer[21]);/*firm_version,21,84-99*/+ reg->drv2iop_doorbell = (uint32_t __iomem *)+  ((unsigned long)acb->mem_base0 ++  ARCMSR_DRV2IOP_DOORBELL);+ reg->drv2iop_doorbell_mask = (uint32_t __iomem *)+  ((unsigned long)acb->mem_base0 ++  ARCMSR_DRV2IOP_DOORBELL_MASK);+ reg->iop2drv_doorbell = (uint32_t __iomem *)+  ((unsigned long)acb->mem_base0 ++  ARCMSR_IOP2DRV_DOORBELL);+ reg->iop2drv_doorbell_mask = (uint32_t __iomem *)+  ((unsigned long)acb->mem_base0 ++  ARCMSR_IOP2DRV_DOORBELL_MASK);+ reg->message_wbuffer = (uint32_t 
 __iomem *)+  ((unsigned long)acb->mem_base1 ++  ARCMSR_MESSAGE_WBUFFER);+ reg->message_rbuffer = (uint32_t __iomem *)+  ((unsigned long)acb->mem_base1 ++  ARCMSR_MESSAGE_RBUFFER);+ reg->message_rwbuffer = (uint32_t __iomem *)+  ((unsigned long)acb->mem_base1 ++  ARCMSR_MESSAGE_RWBUFFER);+ iop_firm_model = (char __iomem *)(&reg->message_rwbuffer[15]);+ iop_firm_version = (char __iomem *)(&reg->message_rwbuffer[17]);+ iop_device_map = (char __iomem *)(&reg->message_rwbuffer[21]);  writel(ARCMSR_MESSAGE_GET_CONFIG, reg->drv2iop_doorbell);- if (!arcmsr_hbb_wait_msgint_ready(acb)) {-  printk(KERN_NOTICE "arcmsr%d: wait 'get adapter firmware \-   miscellaneous data' timeout \n", acb->host->host_no);+ if (!arcmsr_hbaB_wait_msgint_ready(acb)) {+  pr_notice("arcmsr%d: wait 'get adapter firmware "
 +  "miscellaneous data' timeout\n", acb->host->host_no);   return false;  }  count = 8;- while (count){+ while (count) {   *acb_firm_model = readb(iop_firm_model);   acb_firm_model++;   iop_firm_model++;   count--;  }  count = 16;- while (count){+ while (count) {   *acb_firm_version = readb(iop_firm_version);   acb_firm_version++;   iop_firm_version++;@@ -2204,17 +3143,17 @@ static bool arcmsr_get_hbb_config(struct  }  count = 16;- while(count){+ while (count) {   *acb_device_map = readb(iop_device_map);   acb_device_map++;   iop_device_map++;   count--;  }-- printk(KERN_NOTICE "Areca RAID Controller%d: F/W %s & Model %s\n",++ pr_notice("Areca RAID Controller%d: Model %s, F/W %s\n",   acb->host->host_no,-  acb->firm_version,-  acb->firm_model);+  acb->firm_model,+  acb->firm_version);  a
 cb->signature = readl(&reg->message_rwbuffer[1]);  /*firm_signature,1,00-03*/@@ -2226,41 +3165,169 @@ static bool arcmsr_get_hbb_config(struct  /*firm_sdram_size,3,12-15*/  acb->firm_hd_channels = readl(&reg->message_rwbuffer[5]);  /*firm_ide_channels,4,16-19*/- acb->firm_cfg_version = readl(&reg->message_rwbuffer[25]);/*firm_cfg_version,25,100-103*/+ acb->firm_cfg_version = readl(&reg->message_rwbuffer[25]);  /*firm_ide_channels,4,16-19*/  return true; }-static bool arcmsr_get_hbc_config(struct AdapterControlBlock *pACB)-{- uint32_t intmask_org, Index, firmware_state = 0;- struct MessageUnit_C *reg = pACB->pmuC;- char *acb_firm_model = pACB->firm_model;- char *acb_firm_version = pACB->firm_version;- char *iop_firm_model = (char *)(&reg->msgcode_rwbuffer[15]);/*firm_model,15,60-67*/- cha
 r *iop_firm_version = (char *)(&reg->msgcode_rwbuffer[17]);/*firm_version,17,68-83*/- int count;- /* disable all outbound interrupt */- intmask_org = readl(&reg->host_int_mask); /* disable outbound message0 int*/- writel(intmask_org|ARCMSR_HBCMU_ALL_INTMASKENABLE, &reg->host_int_mask);- /* wait firmware ready */- do {-  firmware_state = readl(&reg->outbound_msgaddr1);- } while ((firmware_state & ARCMSR_HBCMU_MESSAGE_FIRMWARE_OK) == 0);+static bool+arcmsr_hbaC_get_config(struct AdapterControlBlock *pACB)+{+ uint32_t intmask_org, Index, firmware_state = 0;+ struct MessageUnit_C __iomem *reg = pACB->pmuC;+ char *acb_firm_model = pACB->firm_model;+ char *acb_firm_version = pACB->firm_version;+ char *iop_firm_model = (char *)(&reg->msgcode_rwbuffer[15]);+ char *iop_firm_version = (char *)(&re
 g->msgcode_rwbuffer[17]);+ int count;+ /* disable all outbound interrupt */+ intmask_org = readl(&reg->host_int_mask);+ writel(intmask_org | ARCMSR_HBCMU_ALL_INTMASKENABLE,+  &reg->host_int_mask);+ do {+  firmware_state = readl(&reg->outbound_msgaddr1);+ } while ((firmware_state & ARCMSR_HBCMU_MESSAGE_FIRMWARE_OK) == 0);+ /* post "get config" instruction */+ writel(ARCMSR_INBOUND_MESG0_GET_CONFIG, &reg->inbound_msgaddr0);+ writel(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE,+  &reg->inbound_doorbell);+ /* wait message ready */+ for (Index = 0; Index < 2000; Index++) {+  if (readl(&reg->outbound_doorbell) &+  ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE) {+   writel(ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE_DOORBELL_CLEAR,+    &reg->outbound_doorbell_clear);+   break;+  }+  udelay(10);+ } /*max 1 seconds*/
 + if (Index >= 2000) {+  pr_notice("arcmsr%d: wait 'get adapter firmware "+  "miscellaneous data' timeout\n", pACB->host->host_no);+  return false;+ }+ count = 8;+ while (count) {+  *acb_firm_model = readb(iop_firm_model);+  acb_firm_model++;+  iop_firm_model++;+  count--;+ }+ count = 16;+ while (count) {+  *acb_firm_version = readb(iop_firm_version);+  acb_firm_version++;+  iop_firm_version++;+  count--;+ }+ pr_notice("Areca RAID Controller%d: Model %s, F/W %s\n",+  pACB->host->host_no,+  pACB->firm_model,+  pACB->firm_version);+ pACB->firm_request_len = readl(&reg->msgcode_rwbuffer[1]);+ pACB->firm_numbers_queue = readl(&reg->msgcode_rwbuffer[2]);+ pACB->firm_sdram_size = readl(&reg->msgcode_rwbuffer[3]);+ pACB->firm_hd_channels = readl(&reg->msgcode_rwbuffer[4]);+ pACB->firm_cfg_versi
 on = readl(&reg->msgcode_rwbuffer[25]);+ /*all interrupt service will be enable at arcmsr_iop_init*/+ return true;+}++static bool+arcmsr_hbaD_get_config(struct AdapterControlBlock *acb)+{+ char *acb_firm_model = acb->firm_model;+ char *acb_firm_version = acb->firm_version;+ char *acb_device_map = acb->device_map;+ char __iomem *iop_firm_model;+ char __iomem *iop_firm_version;+ char __iomem *iop_device_map;+ u32 count;+ struct MessageUnit_D __iomem *reg ;+ void *dma_coherent;+ dma_addr_t dma_coherent_handle;+ struct pci_dev *pdev = acb->pdev;++ acb->roundup_ccbsize = roundup(sizeof(struct MessageUnit_D), 32);+ dma_coherent = dma_alloc_coherent(&pdev->dev, acb->roundup_ccbsize,+ &dma_coherent_handle, GFP_KERNEL);+ if (!dma_coherent) {+  pr_notice("DMA allocation failed...\n");+  return fal
 se;+ }+ memset(dma_coherent, 0, acb->roundup_ccbsize);+ acb->dma_coherent2 = dma_coherent;+ acb->dma_coherent_handle2 = dma_coherent_handle;+ reg = (struct MessageUnit_D __iomem *)dma_coherent;+ acb->pmuD = reg;+ reg->chip_id = (u32 __iomem *)((unsigned long)+ acb->mem_base0 + ARCMSR_ARC1214_CHIP_ID);+ reg->cpu_mem_config = (u32 __iomem *)((unsigned long)+ acb->mem_base0 + ARCMSR_ARC1214_CPU_MEMORY_CONFIGURATION);+ reg->i2o_host_interrupt_mask = (u32 __iomem *)((unsigned long)+ acb->mem_base0 + ARCMSR_ARC1214_I2_HOST_INTERRUPT_MASK);+ reg->sample_at_reset = (u32 __iomem *)((unsigned long)+ acb->mem_base0 + ARCMSR_ARC1214_SAMPLE_RESET);+ reg->reset_request = (u32 __iomem *)((unsigned long)+ acb->mem_base0 + ARCMSR_ARC1214_RESET_REQUEST);+ reg->host_int_status = (u32 __iomem *)((unsigned l
 ong)+ acb->mem_base0 + ARCMSR_ARC1214_MAIN_INTERRUPT_STATUS);+ reg->pcief0_int_enable = (u32 __iomem *)((unsigned long)+ acb->mem_base0 + ARCMSR_ARC1214_PCIE_F0_INTERRUPT_ENABLE);+ reg->inbound_msgaddr0 = (u32 __iomem *)((unsigned long)+ acb->mem_base0 + ARCMSR_ARC1214_INBOUND_MESSAGE0);+ reg->inbound_msgaddr1 = (u32 __iomem *)((unsigned long)+ acb->mem_base0 + ARCMSR_ARC1214_INBOUND_MESSAGE1);+ reg->outbound_msgaddr0 = (u32 __iomem *)((unsigned long)+ acb->mem_base0 + ARCMSR_ARC1214_OUTBOUND_MESSAGE0);+ reg->outbound_msgaddr1 = (u32 __iomem *)((unsigned long)+ acb->mem_base0 + ARCMSR_ARC1214_OUTBOUND_MESSAGE1);+ reg->inbound_doorbell = (u32 __iomem *)((unsigned long)+ acb->mem_base0 + ARCMSR_ARC1214_INBOUND_DOORBELL);+ reg->outbound_doorbell = (u32 __iomem *)((unsigned long)+ acb->mem_b
 ase0 + ARCMSR_ARC1214_OUTBOUND_DOORBELL);+ reg->outbound_doorbell_enable = (u32 __iomem *)((unsigned long)+ acb->mem_base0 + ARCMSR_ARC1214_OUTBOUND_DOORBELL_ENABLE);+ reg->inboundlist_base_low = (u32 __iomem *)((unsigned long)+ acb->mem_base0 + ARCMSR_ARC1214_INBOUND_LIST_BASE_LOW);+ reg->inboundlist_base_high = (u32 __iomem *)((unsigned long)+ acb->mem_base0 + ARCMSR_ARC1214_INBOUND_LIST_BASE_HIGH);+ reg->inboundlist_write_pointer = (u32 __iomem *)((unsigned long)+ acb->mem_base0 + ARCMSR_ARC1214_INBOUND_LIST_WRITE_POINTER);+ reg->outboundlist_base_low = (u32 __iomem *)((unsigned long)+ acb->mem_base0 + ARCMSR_ARC1214_OUTBOUND_LIST_BASE_LOW);+ reg->outboundlist_base_high = (u32 __iomem *)((unsigned long)+ acb->mem_base0 + ARCMSR_ARC1214_OUTBOUND_LIST_BASE_HIGH);+ reg->outboundlist_copy
 _pointer = (u32 __iomem *)((unsigned long)+ acb->mem_base0 + ARCMSR_ARC1214_OUTBOUND_LIST_COPY_POINTER);+ reg->outboundlist_read_pointer = (u32 __iomem *)((unsigned long)+ acb->mem_base0 + ARCMSR_ARC1214_OUTBOUND_LIST_READ_POINTER);+ reg->outboundlist_interrupt_cause = (u32 __iomem *)((unsigned long)+ acb->mem_base0 + ARCMSR_ARC1214_OUTBOUND_INTERRUPT_CAUSE);+ reg->outboundlist_interrupt_enable = (u32 __iomem *)((unsigned long)+ acb->mem_base0 + ARCMSR_ARC1214_OUTBOUND_INTERRUPT_ENABLE);+ reg->message_wbuffer = (u32 __iomem *)((unsigned long)+ acb->mem_base0 + ARCMSR_ARC1214_MESSAGE_WBUFFER);+ reg->message_rbuffer = (u32 __iomem *)((unsigned long)+ acb->mem_base0 + ARCMSR_ARC1214_MESSAGE_RBUFFER);+ reg->msgcode_rwbuffer = (u32 __iomem *)((unsigned long)+ acb->mem_base0 + ARCMSR_ARC1214_M
 ESSAGE_RWBUFFER);+ iop_firm_model = (char __iomem *)(&reg->msgcode_rwbuffer[15]);+ iop_firm_version = (char __iomem *)(&reg->msgcode_rwbuffer[17]);+ iop_device_map = (char __iomem *)(&reg->msgcode_rwbuffer[21]);+ if (readl(acb->pmuD->outbound_doorbell) &+ ARCMSR_ARC1214_IOP2DRV_MESSAGE_CMD_DONE) {+  writel(ARCMSR_ARC1214_IOP2DRV_MESSAGE_CMD_DONE,+   acb->pmuD->outbound_doorbell);/*clear interrupt*/+ }  /* post "get config" instruction */- writel(ARCMSR_INBOUND_MESG0_GET_CONFIG, &reg->inbound_msgaddr0);- writel(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE, &reg->inbound_doorbell);+ writel(ARCMSR_INBOUND_MESG0_GET_CONFIG, reg->inbound_msgaddr0);  /* wait message ready */- for (Index = 0; Index < 2000; Index++) {-  if (readl(&reg->outbound_doorbell) &ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE) {-   wri
 tel(ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE_DOORBELL_CLEAR,&reg->outbound_doorbell_clear);/*clear interrupt*/-   break;-  }-  udelay(10);- } /*max 1 seconds*/- if (Index >= 2000) {-  printk(KERN_NOTICE "arcmsr%d: wait 'get adapter firmware \-   miscellaneous data' timeout \n", pACB->host->host_no);+ if (!arcmsr_hbaD_wait_msgint_ready(acb)) {+  pr_notice("arcmsr%d: wait get adapter firmware "+  "miscellaneous data timeout\n", acb->host->host_no);+  dma_free_coherent(&acb->pdev->dev, acb->roundup_ccbsize,+   acb->dma_coherent2, acb->dma_coherent_handle2);   return false;  }  count = 8;@@ -2277,88 +3344,128 @@ static bool arcmsr_get_hbc_config(struct   iop_firm_version++;   count--;  }- printk(KERN_NOTICE "Areca RAID Controller%d: F/W %s & Model %s\n",-  pACB->host->host_no,-  pACB->firm_vers
 ion,-  pACB->firm_model);- pACB->firm_request_len = readl(&reg->msgcode_rwbuffer[1]);/*firm_request_len,1,04-07*/- pACB->firm_numbers_queue = readl(&reg->msgcode_rwbuffer[2]);/*firm_numbers_queue,2,08-11*/- pACB->firm_sdram_size = readl(&reg->msgcode_rwbuffer[3]);/*firm_sdram_size,3,12-15*/- pACB->firm_hd_channels = readl(&reg->msgcode_rwbuffer[4]);/*firm_ide_channels,4,16-19*/- pACB->firm_cfg_version = readl(&reg->msgcode_rwbuffer[25]);/*firm_cfg_version,25,100-103*/- /*all interrupt service will be enable at arcmsr_iop_init*/+ count = 16;+ while (count) {+  *acb_device_map = readb(iop_device_map);+  acb_device_map++;+  iop_device_map++;+  count--;+ }+ acb->signature = readl(&reg->msgcode_rwbuffer[1]);+ /*firm_signature,1,00-03*/+ acb->firm_request_len = readl(&reg->msgcode_rwbuffer[2])
 ;+ /*firm_request_len,1,04-07*/+ acb->firm_numbers_queue = readl(&reg->msgcode_rwbuffer[3]);+ /*firm_numbers_queue,2,08-11*/+ acb->firm_sdram_size = readl(&reg->msgcode_rwbuffer[4]);+ /*firm_sdram_size,3,12-15*/+ acb->firm_hd_channels = readl(&reg->msgcode_rwbuffer[5]);+ /*firm_hd_channels,4,16-19*/+ acb->firm_cfg_version = readl(&reg->msgcode_rwbuffer[25]);+ pr_notice("Areca RAID Controller%d: Model %s, F/W %s\n",+  acb->host->host_no,+  acb->firm_model,+  acb->firm_version);  return true; }-static bool arcmsr_get_firmware_spec(struct AdapterControlBlock *acb)++static bool+arcmsr_get_firmware_spec(struct AdapterControlBlock *acb) {- if (acb->adapter_type == ACB_ADAPTER_TYPE_A)-  return arcmsr_get_hba_config(acb);- else if (acb->adapter_type == ACB_ADAPTER_TYPE_B)-  return arcmsr_get_hbb
 _config(acb);+ bool rtn = false;+ switch (acb->adapter_type) {+ case ACB_ADAPTER_TYPE_A:+  rtn = arcmsr_hbaA_get_config(acb);+  break;+ case ACB_ADAPTER_TYPE_B:+  rtn = arcmsr_hbaB_get_config(acb);+  break;+ case ACB_ADAPTER_TYPE_C:+  rtn = arcmsr_hbaC_get_config(acb);+  break;+ case ACB_ADAPTER_TYPE_D:+  rtn = arcmsr_hbaD_get_config(acb);+  break;+ default:+  break;+ }+ if(acb->firm_numbers_queue > ARCMSR_MAX_FREECCB_NUM)+  acb->maxOutstanding = ARCMSR_MAX_FREECCB_NUM-1;  else-  return arcmsr_get_hbc_config(acb);+  acb->maxOutstanding = acb->firm_numbers_queue - 1;+ return rtn; }-static int arcmsr_polling_hba_ccbdone(struct AdapterControlBlock *acb,+static int+arcmsr_hbaA_polling_ccbdone(struct AdapterControlBlock *acb,  struct CommandControlBlock *poll_ccb) {  struct MessageUnit_A __io
 mem *reg = acb->pmuA;  struct CommandControlBlock *ccb;  struct ARCMSR_CDB *arcmsr_cdb;- uint32_t flag_ccb, outbound_intstatus, poll_ccb_done = 0, poll_count = 0;+ uint32_t flag_ccb, outbound_intstatus, poll_ccb_done = 0;+ uint32_t poll_count = 0;  int rtn;  bool error;  polling_hba_ccb_retry:  poll_count++;- outbound_intstatus = readl(&reg->outbound_intstatus) &acb->outbound_int_enable;- writel(outbound_intstatus, &reg->outbound_intstatus);/*clear interrupt*/+ outbound_intstatus = readl(&reg->outbound_intstatus) &+  acb->outbound_int_enable;+ writel(outbound_intstatus, &reg->outbound_intstatus);  while (1) {-  if ((flag_ccb = readl(&reg->outbound_queueport)) == 0xFFFFFFFF) {-   if (poll_ccb_done){+  flag_ccb = readl(&reg->outbound_queueport);+  if (flag_ccb == 0xFFFFFFFF) {+   if (poll_
 ccb_done) {     rtn = SUCCESS;     break;-   }else {+   } else {     msleep(25);-    if (poll_count > 100){+    if (poll_count > 100) {      rtn = FAILED;      break;     }     goto polling_hba_ccb_retry;    }   }-  arcmsr_cdb = (struct ARCMSR_CDB *)(acb->vir2phy_offset + (flag_ccb <<5));-  ccb = container_of(arcmsr_cdb, struct CommandControlBlock, arcmsr_cdb);+  arcmsr_cdb = (struct ARCMSR_CDB *)(acb->vir2phy_offset ++   (flag_ccb << 5));+  ccb = container_of(arcmsr_cdb, struct CommandControlBlock,+   arcmsr_cdb);   poll_ccb_done = (ccb == poll_ccb) ? 1:0;   if ((ccb->acb != acb) || (ccb->startdone != ARCMSR_CCB_START)) {-   if ((ccb->startdone == ARCMSR_CCB_ABORTED) || (ccb == poll_ccb)) {-    printk(KERN_NOTICE "arcmsr%d: scsi id = %d lun = %d ccb = '0x%p'"-     " poll command abort s
 uccessfully \n"-     , acb->host->host_no-     , ccb->pcmd->device->id-     , ccb->pcmd->device->lun-     , ccb);+   if ((ccb->startdone == ARCMSR_CCB_ABORTED) ||+   (ccb == poll_ccb)) {+    pr_notice("arcmsr%d: scsi id = %d "+    "lun = %d ccb = '0x%p' poll command "+    "abort successfully\n"+    , acb->host->host_no+    , ccb->pcmd->device->id+    , ccb->pcmd->device->lun+    , ccb);     ccb->pcmd->result = DID_ABORT << 16;     arcmsr_ccb_complete(ccb);     continue;    }-   printk(KERN_NOTICE "arcmsr%d: polling get an illegal ccb"-    " command done ccb = '0x%p'"-    "ccboutstandingcount = %d \n"-    , acb->host->host_no-    , ccb-    , atomic_read(&acb->ccboutstandingcount));+   pr_notice("arcmsr%d: polling get an illegal "+   "ccb command done ccb = '0x%p' "+   "ccboutstandingcount
  = %d\n"+   , acb->host->host_no+   , ccb+   , atomic_read(&acb->ccboutstandingcount));    continue;   }-  error = (flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR_MODE0) ? true : false;+  error = (flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR_MODE0) ?+   true : false;   arcmsr_report_ccb_state(acb, ccb, error);  }  return rtn; }-static int arcmsr_polling_hbb_ccbdone(struct AdapterControlBlock *acb,-     struct CommandControlBlock *poll_ccb)+int+arcmsr_hbaB_polling_ccbdone(struct AdapterControlBlock *acb,+    struct CommandControlBlock *poll_ccb) {- struct MessageUnit_B *reg = acb->pmuB;+ struct MessageUnit_B __iomem *reg = acb->pmuB;  struct ARCMSR_CDB *arcmsr_cdb;  struct CommandControlBlock *ccb;  uint32_t flag_ccb, poll_ccb_done = 0, poll_count = 0;@@ -2368,16 +3475,18 @@ static int arcmsr_polling_hbb
 _ccbdone(st  poll_count++;  /* clear doorbell interrupt */- writel(ARCMSR_DOORBELL_INT_CLEAR_PATTERN, reg->iop2drv_doorbell);- while(1){+ writel(ARCMSR_DOORBELL_INT_CLEAR_PATTERN,+ reg->iop2drv_doorbell);+ while (1) {   index = reg->doneq_index;-  if ((flag_ccb = readl(&reg->done_qbuffer[index])) == 0) {-   if (poll_ccb_done){+  flag_ccb = readl(&reg->done_qbuffer[index]);+  if (flag_ccb == 0) {+   if (poll_ccb_done) {     rtn = SUCCESS;     break;-   }else {+   } else {     msleep(25);-    if (poll_count > 100){+    if (poll_count > 100) {      rtn = FAILED;      break;     }@@ -2390,38 +3499,47 @@ static int arcmsr_polling_hbb_ccbdone(st   index %= ARCMSR_MAX_HBB_POSTQUEUE;   reg->doneq_index = index;   /* check if command done with no error*/-  arcmsr_cdb = (struct ARCMSR_CDB *)(acb->
 vir2phy_offset + (flag_ccb <<5));-  ccb = container_of(arcmsr_cdb, struct CommandControlBlock, arcmsr_cdb);-  poll_ccb_done = (ccb == poll_ccb) ? 1:0;-  if ((ccb->acb != acb) || (ccb->startdone != ARCMSR_CCB_START)) {-   if ((ccb->startdone == ARCMSR_CCB_ABORTED) || (ccb == poll_ccb)) {-    printk(KERN_NOTICE "arcmsr%d: scsi id = %d lun = %d ccb = '0x%p'"-     " poll command abort successfully \n"-     ,acb->host->host_no-     ,ccb->pcmd->device->id-     ,ccb->pcmd->device->lun-     ,ccb);+  arcmsr_cdb = (struct ARCMSR_CDB *)+  (acb->vir2phy_offset + (flag_ccb << 5));+  ccb = container_of(arcmsr_cdb,+   struct CommandControlBlock,+   arcmsr_cdb);+  poll_ccb_done = (ccb == poll_ccb) ? 1 : 0;+  if ((ccb->acb != acb) ||+  (ccb->startdone != ARCMSR_CCB_START)) {+   if ((ccb->startdone == ARC
 MSR_CCB_ABORTED) ||+    (ccb == poll_ccb)) {+    pr_notice("arcmsr%d: "+    "scsi id = %d lun = %d ccb = '0x%p' poll "+    "command abort successfully\n"+    , acb->host->host_no+    , ccb->pcmd->device->id+    , ccb->pcmd->device->lun+    , ccb);     ccb->pcmd->result = DID_ABORT << 16;     arcmsr_ccb_complete(ccb);     continue;    }-   printk(KERN_NOTICE "arcmsr%d: polling get an illegal ccb"-    " command done ccb = '0x%p'"-    "ccboutstandingcount = %d \n"+   pr_notice("arcmsr%d: polling get an "+    "illegal ccb command done ccb = '0x%p' "+    "ccboutstandingcount = %d\n"     , acb->host->host_no     , ccb     , atomic_read(&acb->ccboutstandingcount));    continue;   }-  error = (flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR_MODE0) ? true : false;+  error = (flag_ccb & ARCMSR_CCBREPLY_FLAG
 _ERROR_MODE0)+  ? true : false;   arcmsr_report_ccb_state(acb, ccb, error);  }  return rtn; }-static int arcmsr_polling_hbc_ccbdone(struct AdapterControlBlock *acb,struct CommandControlBlock *poll_ccb)+static int+arcmsr_hbaC_polling_ccbdone(struct AdapterControlBlock *acb,+ struct CommandControlBlock *poll_ccb) {- struct MessageUnit_C *reg = (struct MessageUnit_C *)acb->pmuC;+ struct MessageUnit_C __iomem *reg = acb->pmuC;  uint32_t flag_ccb, ccb_cdb_phy;  struct ARCMSR_CDB *arcmsr_cdb;  bool error;@@ -2431,7 +3549,8 @@ static int arcmsr_polling_hbc_ccbdone(st polling_hbc_ccb_retry:  poll_count++;  while (1) {-  if ((readl(&reg->host_int_status) & ARCMSR_HBCMU_OUTBOUND_POSTQUEUE_ISR)== 0) {+  if ((readl(&reg->host_int_status) &+   ARCMSR_HBCMU_OUTBOUND_POSTQUEUE_ISR) == 0) {    if (poll_
 ccb_done) {     rtn = SUCCESS;     break;@@ -2446,74 +3565,180 @@ polling_hbc_ccb_retry:   }   flag_ccb = readl(&reg->outbound_queueport_low);   ccb_cdb_phy = (flag_ccb & 0xFFFFFFF0);-  arcmsr_cdb = (struct ARCMSR_CDB *)(acb->vir2phy_offset +ccb_cdb_phy);/*frame must be 32 bytes aligned*/-  pCCB = container_of(arcmsr_cdb, struct CommandControlBlock, arcmsr_cdb);+  arcmsr_cdb = (struct ARCMSR_CDB *)(acb->vir2phy_offset+   + ccb_cdb_phy);+  pCCB = container_of(arcmsr_cdb, struct CommandControlBlock,+   arcmsr_cdb);   poll_ccb_done = (pCCB == poll_ccb) ? 1 : 0;   /* check ifcommand done with no error*/-  if ((pCCB->acb != acb) || (pCCB->startdone != ARCMSR_CCB_START)) {+  if ((pCCB->acb != acb) ||+   (pCCB->startdone != ARCMSR_CCB_START)) {    if (pCCB->startdone == ARCMSR_CCB_ABORTED) {-  
   printk(KERN_NOTICE "arcmsr%d: scsi id = %d lun = %d ccb = '0x%p'"-     " poll command abort successfully \n"-     , acb->host->host_no-     , pCCB->pcmd->device->id-     , pCCB->pcmd->device->lun-     , pCCB);-     pCCB->pcmd->result = DID_ABORT << 16;-     arcmsr_ccb_complete(pCCB);+    pr_notice("arcmsr%d: "+    "scsi id = %d lun = %d ccb = '0x%p' poll "+    "command abort successfully\n"+    , acb->host->host_no+    , pCCB->pcmd->device->id+    , pCCB->pcmd->device->lun+    , pCCB);+    pCCB->pcmd->result = DID_ABORT << 16;+    arcmsr_ccb_complete(pCCB);     continue;    }-   printk(KERN_NOTICE "arcmsr%d: polling get an illegal ccb"-    " command done ccb = '0x%p'"-    "ccboutstandingcount = %d \n"+   pr_notice("arcmsr%d: polling get an illegal "+   "ccb command done ccb = '0x%p' "+
    "ccboutstandingcount = %d\n"+   , acb->host->host_no+   , pCCB+   , atomic_read(&acb->ccboutstandingcount));+   continue;+  }+  error = (flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR_MODE1)+   ? true : false;+  arcmsr_report_ccb_state(acb, pCCB, error);+ }+ return rtn;+}++static int+arcmsr_hbaD_polling_ccbdone(struct AdapterControlBlock *acb,+    struct CommandControlBlock *poll_ccb)+{+ bool error;+ uint32_t poll_ccb_done = 0, poll_count = 0, flag_ccb, ccb_cdb_phy;+ int rtn, doneq_index, index_stripped, outbound_write_pointer;+ unsigned long flags;+ struct ARCMSR_CDB *arcmsr_cdb;+ struct CommandControlBlock *pCCB;+ struct MessageUnit_D __iomem *pmu = acb->pmuD;++ spin_lock_irqsave(&acb->doneq_lock, flags);+ polling_hbaD_ccb_retry:+ poll_count++;+ while (1) {+  outbound_write_pointer =+  pmu->
 done_qbuffer[0].addressLow + 1;+  doneq_index = pmu->doneq_index;+  if ((outbound_write_pointer & 0xFFF) == (doneq_index & 0xFFF)) {+   if (poll_ccb_done) {+    rtn = SUCCESS;+    break;+   } else {+    msleep(25);+    if (poll_count > 100) {+     rtn = FAILED;+     break;+    }+    goto polling_hbaD_ccb_retry;+   }+  }+  if (doneq_index & 0x4000) {+   index_stripped = doneq_index & 0xFFF;+   index_stripped += 1;+   index_stripped %= ARCMSR_MAX_ARC1214_DONEQUEUE;+   pmu->doneq_index = index_stripped ? (index_stripped | 0x4000)+    : (index_stripped + 1);+  } else {+   index_stripped = doneq_index;+   index_stripped += 1;+   index_stripped %= ARCMSR_MAX_ARC1214_DONEQUEUE;+   pmu->doneq_index = index_stripped ? index_stripped :+    ((index_stripped | 0x4000) + 1);+  }+  doneq_index = pmu->
 doneq_index;+  flag_ccb = pmu->done_qbuffer[doneq_index & 0xFFF].addressLow;+  ccb_cdb_phy = (flag_ccb & 0xFFFFFFF0);+  arcmsr_cdb = (struct ARCMSR_CDB *)(acb->vir2phy_offset ++   ccb_cdb_phy);+  pCCB = container_of(arcmsr_cdb,+   struct CommandControlBlock, arcmsr_cdb);+  poll_ccb_done = (pCCB == poll_ccb) ? 1 : 0;+  if ((pCCB->acb != acb) ||+  (pCCB->startdone != ARCMSR_CCB_START)) {+   if (pCCB->startdone == ARCMSR_CCB_ABORTED) {+    pr_notice("arcmsr%d: scsi id = %d "+    "lun = %d ccb = '0x%p' poll command "+    "abort successfully\n"     , acb->host->host_no-    , pCCB-    , atomic_read(&acb->ccboutstandingcount));+    , pCCB->pcmd->device->id+    , pCCB->pcmd->device->lun+    , pCCB);+    pCCB->pcmd->result = DID_ABORT << 16;+    arcmsr_ccb_complete(pCCB);+    continue;+   }+   pr
 _notice("arcmsr%d: polling an illegal "+   "ccb command done ccb = '0x%p' "+   "ccboutstandingcount = %d\n"+   , acb->host->host_no+   , pCCB+   , atomic_read(&acb->ccboutstandingcount));    continue;   }-  error = (flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR_MODE1) ? true : false;+  error = (flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR_MODE1)+  ? true : false;   arcmsr_report_ccb_state(acb, pCCB, error);  }+ spin_unlock_irqrestore(&acb->doneq_lock, flags);  return rtn; }-static int arcmsr_polling_ccbdone(struct AdapterControlBlock *acb,-     struct CommandControlBlock *poll_ccb)++static int+arcmsr_polling_ccbdone(struct AdapterControlBlock *acb,+    struct CommandControlBlock *poll_ccb) {  int rtn = 0;  switch (acb->adapter_type) {-- case ACB_ADAPTER_TYPE_A: {-  rtn = arcmsr_polling_hba_ccbdone(acb,
  poll_ccb);-  }+ case ACB_ADAPTER_TYPE_A:{+  rtn = arcmsr_hbaA_polling_ccbdone(acb, poll_ccb);   break;-- case ACB_ADAPTER_TYPE_B: {-  rtn = arcmsr_polling_hbb_ccbdone(acb, poll_ccb);-  }+ }+ case ACB_ADAPTER_TYPE_B:{+  rtn = arcmsr_hbaB_polling_ccbdone(acb, poll_ccb);   break;+ }  case ACB_ADAPTER_TYPE_C: {-  rtn = arcmsr_polling_hbc_ccbdone(acb, poll_ccb);-  }+  rtn = arcmsr_hbaC_polling_ccbdone(acb, poll_ccb);+  break;+ }+ case ACB_ADAPTER_TYPE_D: {+  rtn = arcmsr_hbaD_polling_ccbdone(acb, poll_ccb);+  break;+ }  }  return rtn; }-static int arcmsr_iop_confirm(struct AdapterControlBlock *acb)+static int+arcmsr_iop_confirm(struct AdapterControlBlock *acb) {- uint32_t cdb_phyaddr, cdb_phyaddr_hi32;+ uint32_t cdb_phyaddr, cdb_phyaddr_hi32, cdb_phyaddr_lo32;  dma_addr_t dma_coherent_handle
 ;  /*  ********************************************************************- ** here we need to tell iop 331 our freeccb.HighPart+ ** Here we need to tell iop our freeccb.HighPart  ** if freeccb.HighPart is not zero  ********************************************************************  */- dma_coherent_handle = acb->dma_coherent_handle;- cdb_phyaddr = (uint32_t)(dma_coherent_handle);+ switch (acb->adapter_type) {+  case ACB_ADAPTER_TYPE_A:+  case ACB_ADAPTER_TYPE_B:+  case ACB_ADAPTER_TYPE_C:+   dma_coherent_handle = acb->dma_coherent_handle;+   break;+  case ACB_ADAPTER_TYPE_D:+   dma_coherent_handle = acb->dma_coherent_handle2;+   break;+  default:+   dma_coherent_handle = acb->dma_coherent_handle;+   break;+ }+ cdb_phyaddr_lo32 = (uint32_t)(dma_coherent_handle & 0xffffffff);  cdb_phya
 ddr_hi32 = (uint32_t)((cdb_phyaddr >> 16) >> 16);  acb->cdb_phyaddr_hi32 = cdb_phyaddr_hi32;  /*  ***********************************************************************- **    if adapter type B, set window of "post command Q"+ ** if adapter type B D set window of "post command Q"  ***********************************************************************  */  switch (acb->adapter_type) {@@ -2521,20 +3746,17 @@ static int arcmsr_iop_confirm(struct Ada  case ACB_ADAPTER_TYPE_A: {   if (cdb_phyaddr_hi32 != 0) {    struct MessageUnit_A __iomem *reg = acb->pmuA;-   uint32_t intmask_org;-   intmask_org = arcmsr_disable_outbound_ints(acb);-   writel(ARCMSR_SIGNATURE_SET_CONFIG, \-      &reg->message_rwbuffer[0]);+   writel(ARCMSR_SIGNATURE_SET_CONFIG,+   &reg->message_rwbuffer[0]);    writel(cdb_
 phyaddr_hi32, &reg->message_rwbuffer[1]);-   writel(ARCMSR_INBOUND_MESG0_SET_CONFIG, \-       &reg->inbound_msgaddr0);-   if (!arcmsr_hba_wait_msgint_ready(acb)) {-    printk(KERN_NOTICE "arcmsr%d: ""set ccb high \-    part physical address timeout\n",+   writel(ARCMSR_INBOUND_MESG0_SET_CONFIG,+   &reg->inbound_msgaddr0);+   if (!arcmsr_hbaA_wait_msgint_ready(acb)) {+    pr_notice("arcmsr%d: set ccb "+    "high part physical address timeout\n",     acb->host->host_no);     return 1;    }-   arcmsr_enable_outbound_ints(acb, intmask_org);   }   }   break;@@ -2543,18 +3765,17 @@ static int arcmsr_iop_confirm(struct Ada   unsigned long post_queue_phyaddr;   uint32_t __iomem *rwbuffer;-  struct MessageUnit_B *reg = acb->pmuB;-  uint32_t intmask_org;-  intmask_org = arcmsr_disable_outbound_int
 s(acb);+  struct MessageUnit_B __iomem *reg = acb->pmuB;   reg->postq_index = 0;   reg->doneq_index = 0;-  writel(ARCMSR_MESSAGE_SET_POST_WINDOW, reg->drv2iop_doorbell);-  if (!arcmsr_hbb_wait_msgint_ready(acb)) {-   printk(KERN_NOTICE "arcmsr%d:can not set diver mode\n", \-    acb->host->host_no);+  writel(ARCMSR_MESSAGE_SET_POST_WINDOW,+  reg->drv2iop_doorbell);+  if (!arcmsr_hbaB_wait_msgint_ready(acb)) {+   pr_notice("arcmsr%d:can not set diver mode\n",+   acb->host->host_no);    return 1;   }-  post_queue_phyaddr = acb->dma_coherent_handle_hbb_mu;+  post_queue_phyaddr = acb->dma_coherent_handle2;   rwbuffer = reg->message_rwbuffer;   /* driver "set config" signature */   writel(ARCMSR_SIGNATURE_SET_CONFIG, rwbuffer++);@@ -2566,39 +3787,64 @@ static int arcmsr_iop_confirm(struct Ada 
   writel(post_queue_phyaddr + 1056, rwbuffer++);   /* ccb maxQ size must be --> [(256 + 8)*4]*/   writel(1056, rwbuffer);-   writel(ARCMSR_MESSAGE_SET_CONFIG, reg->drv2iop_doorbell);-  if (!arcmsr_hbb_wait_msgint_ready(acb)) {-   printk(KERN_NOTICE "arcmsr%d: 'set command Q window' \-   timeout \n",acb->host->host_no);+  if (!arcmsr_hbaB_wait_msgint_ready(acb)) {+   pr_notice("arcmsr%d: 'set command Q window' "+   "timeout\n", acb->host->host_no);    return 1;   }   arcmsr_hbb_enable_driver_mode(acb);-  arcmsr_enable_outbound_ints(acb, intmask_org);   }   break;  case ACB_ADAPTER_TYPE_C: {+  struct MessageUnit_C __iomem *reg = acb->pmuC;   if (cdb_phyaddr_hi32 != 0) {-   struct MessageUnit_C *reg = (struct MessageUnit_C *)acb->pmuC;--   printk(KERN_NOTICE "arcmsr%d: cdb_phyaddr_hi32=0x%x
 \n",-     acb->adapter_index, cdb_phyaddr_hi32);-   writel(ARCMSR_SIGNATURE_SET_CONFIG, &reg->msgcode_rwbuffer[0]);-   writel(cdb_phyaddr_hi32, &reg->msgcode_rwbuffer[1]);-   writel(ARCMSR_INBOUND_MESG0_SET_CONFIG, &reg->inbound_msgaddr0);-   writel(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE, &reg->inbound_doorbell);-   if (!arcmsr_hbc_wait_msgint_ready(acb)) {-    printk(KERN_NOTICE "arcmsr%d: 'set command Q window' \-    timeout \n", acb->host->host_no);+   pr_notice("arcmsr%d: cdb_phyaddr_hi32 = 0x%x\n",+   acb->adapter_index, cdb_phyaddr_hi32);+   writel(ARCMSR_SIGNATURE_SET_CONFIG,+    &reg->msgcode_rwbuffer[0]);+   writel(cdb_phyaddr_hi32,+    &reg->msgcode_rwbuffer[1]);+   writel(ARCMSR_INBOUND_MESG0_SET_CONFIG,+    &reg->inbound_msgaddr0);+   writel(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DO
 NE,+    &reg->inbound_doorbell);+   if (!arcmsr_hbaC_wait_msgint_ready(acb)) {+    pr_notice("arcmsr%d: 'set "+    "command Q window' timeout\n",+    acb->host->host_no);     return 1;    }   }   }+  break;+ case ACB_ADAPTER_TYPE_D: {+  uint32_t __iomem *rwbuffer;++  struct MessageUnit_D __iomem *reg = acb->pmuD;+  reg->postq_index = 0;+  reg->doneq_index = 0;+  rwbuffer = reg->msgcode_rwbuffer;+  writel(ARCMSR_SIGNATURE_SET_CONFIG, rwbuffer++);+  writel(cdb_phyaddr_hi32, rwbuffer++);+  writel(cdb_phyaddr_lo32, rwbuffer++);+  writel(cdb_phyaddr_lo32 ++  (ARCMSR_MAX_ARC1214_POSTQUEUE * sizeof(struct InBound_SRB)),+  rwbuffer++);+  writel(0x100, rwbuffer);+  writel(ARCMSR_INBOUND_MESG0_SET_CONFIG,+   reg->inbound_msgaddr0);+  if (!arcmsr_hbaD_wait_msgint_ready(acb))+   pr_notice("arcmsr%d:
  'set command Q "+   "window' timeout\n", acb->host->host_no);+  break;+ }  }  return 0; }-static void arcmsr_wait_firmware_ready(struct AdapterControlBlock *acb)+static void+arcmsr_wait_firmware_ready(struct AdapterControlBlock *acb) {  uint32_t firmware_state = 0;  switch (acb->adapter_type) {@@ -2607,161 +3853,259 @@ static void arcmsr_wait_firmware_ready(s   struct MessageUnit_A __iomem *reg = acb->pmuA;   do {    firmware_state = readl(&reg->outbound_msgaddr1);-  } while ((firmware_state & ARCMSR_OUTBOUND_MESG1_FIRMWARE_OK) == 0);+  } while ((firmware_state &+  ARCMSR_OUTBOUND_MESG1_FIRMWARE_OK) == 0);   }   break;-  case ACB_ADAPTER_TYPE_B: {-  struct MessageUnit_B *reg = acb->pmuB;+  struct MessageUnit_B __iomem *reg = acb->pmuB;   do {    firmware_state = readl(reg->iop2drv_doorb
 ell);   } while ((firmware_state & ARCMSR_MESSAGE_FIRMWARE_OK) == 0);-  writel(ARCMSR_DRV2IOP_END_OF_INTERRUPT, reg->drv2iop_doorbell);+  writel(ARCMSR_DRV2IOP_END_OF_INTERRUPT,+  reg->drv2iop_doorbell);   }   break;  case ACB_ADAPTER_TYPE_C: {-  struct MessageUnit_C *reg = (struct MessageUnit_C *)acb->pmuC;+  struct MessageUnit_C __iomem *reg = acb->pmuC;   do {    firmware_state = readl(&reg->outbound_msgaddr1);-  } while ((firmware_state & ARCMSR_HBCMU_MESSAGE_FIRMWARE_OK) == 0);+  } while ((firmware_state &+  ARCMSR_HBCMU_MESSAGE_FIRMWARE_OK) == 0);   }+  break;+ case ACB_ADAPTER_TYPE_D: {+  struct MessageUnit_D __iomem *reg = acb->pmuD;+  do {+   firmware_state = readl(reg->outbound_msgaddr1);+  } while ((firmware_state &+  ARCMSR_ARC1214_MESSAGE_FIRMWARE_OK) == 0);+  break;+ }  } }
 -static void arcmsr_request_hba_device_map(struct AdapterControlBlock *acb)+static void+arcmsr_hbaA_request_device_map(struct AdapterControlBlock *acb) {  struct MessageUnit_A __iomem *reg = acb->pmuA;- if (unlikely(atomic_read(&acb->rq_map_token) == 0) || ((acb->acb_flags &ACB_F_BUS_RESET) != 0 ) || ((acb->acb_flags & ACB_F_ABORT) != 0 )){-  mod_timer(&acb->eternal_timer, jiffies + msecs_to_jiffies(6 * HZ));+ if (unlikely(atomic_read(&acb->rq_map_token) == 0) ||+  ((acb->acb_flags & ACB_F_BUS_RESET) != 0)+  || ((acb->acb_flags & ACB_F_ABORT) != 0)) {+  mod_timer(&acb->eternal_timer,+   jiffies + msecs_to_jiffies(6 * HZ));   return;  } else {   acb->fw_flag = FW_NORMAL;-  if (atomic_read(&acb->ante_token_value) ==atomic_read(&acb->rq_map_token)){+  if (atomic_read(&acb->ante_token_value)
  ==+   atomic_read(&acb->rq_map_token)) {    atomic_set(&acb->rq_map_token, 16);   }-  atomic_set(&acb->ante_token_value, atomic_read(&acb->rq_map_token));+  atomic_set(&acb->ante_token_value,+   atomic_read(&acb->rq_map_token));   if (atomic_dec_and_test(&acb->rq_map_token)) {-   mod_timer(&acb->eternal_timer, jiffies + msecs_to_jiffies(6 * HZ));+   mod_timer(&acb->eternal_timer,+    jiffies + msecs_to_jiffies(6 * HZ));    return;   }-  writel(ARCMSR_INBOUND_MESG0_GET_CONFIG, &reg->inbound_msgaddr0);-  mod_timer(&acb->eternal_timer, jiffies + msecs_to_jiffies(6 * HZ));+  writel(ARCMSR_INBOUND_MESG0_GET_CONFIG,+   &reg->inbound_msgaddr0);+  mod_timer(&acb->eternal_timer, jiffies ++   msecs_to_jiffies(6 * HZ));  }- return; }-static void arcmsr_request_hbb_device_map(struct AdapterControlB
 lock *acb)+static void+arcmsr_hbaB_request_device_map(struct AdapterControlBlock *acb) {  struct MessageUnit_B __iomem *reg = acb->pmuB;- if (unlikely(atomic_read(&acb->rq_map_token) == 0) || ((acb->acb_flags &ACB_F_BUS_RESET) != 0 ) || ((acb->acb_flags & ACB_F_ABORT) != 0 )){-  mod_timer(&acb->eternal_timer, jiffies + msecs_to_jiffies(6 * HZ));+ if (unlikely(atomic_read(&acb->rq_map_token) == 0) ||+  ((acb->acb_flags & ACB_F_BUS_RESET) != 0) ||+  ((acb->acb_flags & ACB_F_ABORT) != 0)) {+  mod_timer(&acb->eternal_timer, jiffies ++   msecs_to_jiffies(6 * HZ));   return;  } else {   acb->fw_flag = FW_NORMAL;-  if (atomic_read(&acb->ante_token_value) ==atomic_read(&acb->rq_map_token)) {+  if (atomic_read(&acb->ante_token_value) ==+   atomic_read(&acb->rq_map_token)) {    atomic_set(&acb->rq
 _map_token, 16);   }-  atomic_set(&acb->ante_token_value, atomic_read(&acb->rq_map_token));+  atomic_set(&acb->ante_token_value,+   atomic_read(&acb->rq_map_token));   if (atomic_dec_and_test(&acb->rq_map_token)) {-   mod_timer(&acb->eternal_timer, jiffies + msecs_to_jiffies(6 * HZ));+   mod_timer(&acb->eternal_timer,+    jiffies + msecs_to_jiffies(6 * HZ));    return;   }-  writel(ARCMSR_MESSAGE_GET_CONFIG, reg->drv2iop_doorbell);-  mod_timer(&acb->eternal_timer, jiffies + msecs_to_jiffies(6 * HZ));+  writel(ARCMSR_MESSAGE_GET_CONFIG,+   reg->drv2iop_doorbell);+  mod_timer(&acb->eternal_timer, jiffies ++   msecs_to_jiffies(6 * HZ));  }- return; }-static void arcmsr_request_hbc_device_map(struct AdapterControlBlock *acb)+static void+arcmsr_hbaC_request_device_map(struct AdapterControlBlo
 ck *acb) {  struct MessageUnit_C __iomem *reg = acb->pmuC;- if (unlikely(atomic_read(&acb->rq_map_token) == 0) || ((acb->acb_flags &ACB_F_BUS_RESET) != 0) || ((acb->acb_flags & ACB_F_ABORT) != 0)) {-  mod_timer(&acb->eternal_timer, jiffies + msecs_to_jiffies(6 * HZ));+ if (unlikely(atomic_read(&acb->rq_map_token) == 0) ||+  ((acb->acb_flags & ACB_F_BUS_RESET) != 0) ||+  ((acb->acb_flags & ACB_F_ABORT) != 0)) {+  mod_timer(&acb->eternal_timer, jiffies ++   msecs_to_jiffies(6 * HZ));   return;  } else {   acb->fw_flag = FW_NORMAL;-  if (atomic_read(&acb->ante_token_value) ==atomic_read(&acb->rq_map_token)) {+  if (atomic_read(&acb->ante_token_value) ==+   atomic_read(&acb->rq_map_token)) {    atomic_set(&acb->rq_map_token, 16);   }-  atomic_set(&acb->ante_token_value, atomic_read(&acb->rq_
 map_token));+  atomic_set(&acb->ante_token_value,+   atomic_read(&acb->rq_map_token));   if (atomic_dec_and_test(&acb->rq_map_token)) {-   mod_timer(&acb->eternal_timer, jiffies + msecs_to_jiffies(6 * HZ));+   mod_timer(&acb->eternal_timer,+    jiffies + msecs_to_jiffies(6 * HZ));    return;   }-  writel(ARCMSR_INBOUND_MESG0_GET_CONFIG, &reg->inbound_msgaddr0);-  writel(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE, &reg->inbound_doorbell);-  mod_timer(&acb->eternal_timer, jiffies + msecs_to_jiffies(6 * HZ));+  writel(ARCMSR_INBOUND_MESG0_GET_CONFIG,+   &reg->inbound_msgaddr0);+  writel(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE,+   &reg->inbound_doorbell);+  mod_timer(&acb->eternal_timer, jiffies ++   msecs_to_jiffies(6 * HZ));+ }+}++static void+arcmsr_hbaD_request_device_map(struct AdapterControlBl
 ock *acb)+{+ struct MessageUnit_D __iomem *reg = acb->pmuD;+ if (unlikely(atomic_read(&acb->rq_map_token) == 0) ||+  ((acb->acb_flags & ACB_F_BUS_RESET) != 0) ||+  ((acb->acb_flags & ACB_F_ABORT) != 0)) {+  mod_timer(&acb->eternal_timer,+   jiffies + msecs_to_jiffies(6 * HZ));+ } else {+  acb->fw_flag = FW_NORMAL;+  if (atomic_read(&acb->ante_token_value) ==+   atomic_read(&acb->rq_map_token)) {+   atomic_set(&acb->rq_map_token, 16);+  }+  atomic_set(&acb->ante_token_value,+   atomic_read(&acb->rq_map_token));+  if (atomic_dec_and_test(&acb->rq_map_token)) {+   mod_timer(&acb->eternal_timer, jiffies ++    msecs_to_jiffies(6 * HZ));+   return;+  }+  writel(ARCMSR_INBOUND_MESG0_GET_CONFIG,+   reg->inbound_msgaddr0);+  mod_timer(&acb->eternal_timer, jiffies ++   msecs_to_jiffies(6 * HZ));  
 }- return; }-static void arcmsr_request_device_map(unsigned long pacb)+static void+arcmsr_request_device_map(unsigned long pacb) {- struct AdapterControlBlock *acb = (struct AdapterControlBlock *)pacb;+ struct AdapterControlBlock *acb =+  (struct AdapterControlBlock *)pacb;  switch (acb->adapter_type) {   case ACB_ADAPTER_TYPE_A: {-   arcmsr_request_hba_device_map(acb);+   arcmsr_hbaA_request_device_map(acb);+   break;   }-  break;   case ACB_ADAPTER_TYPE_B: {-   arcmsr_request_hbb_device_map(acb);+   arcmsr_hbaB_request_device_map(acb);+   break;   }-  break;   case ACB_ADAPTER_TYPE_C: {-   arcmsr_request_hbc_device_map(acb);+   arcmsr_hbaC_request_device_map(acb);+   break;+  }+  case ACB_ADAPTER_TYPE_D: {+   arcmsr_hbaD_request_device_map(acb);+   break;   }  } }-static void arcmsr_st
 art_hba_bgrb(struct AdapterControlBlock *acb)+static void+arcmsr_hbaA_start_bgrb(struct AdapterControlBlock *acb) {  struct MessageUnit_A __iomem *reg = acb->pmuA;  acb->acb_flags |= ACB_F_MSG_START_BGRB;- writel(ARCMSR_INBOUND_MESG0_START_BGRB, &reg->inbound_msgaddr0);- if (!arcmsr_hba_wait_msgint_ready(acb)) {-  printk(KERN_NOTICE "arcmsr%d: wait 'start adapter background \-    rebulid' timeout \n", acb->host->host_no);+ writel(ARCMSR_INBOUND_MESG0_START_BGRB,+  &reg->inbound_msgaddr0);+ if (!arcmsr_hbaA_wait_msgint_ready(acb)) {+  pr_notice("arcmsr%d: wait 'start adapter "+  "background rebulid' timeout\n", acb->host->host_no);  } }-static void arcmsr_start_hbb_bgrb(struct AdapterControlBlock *acb)+static void+arcmsr_hbaB_start_bgrb(struct AdapterControlBlock *acb) {- struct MessageUn
 it_B *reg = acb->pmuB;+ struct MessageUnit_B __iomem *reg = acb->pmuB;  acb->acb_flags |= ACB_F_MSG_START_BGRB;  writel(ARCMSR_MESSAGE_START_BGRB, reg->drv2iop_doorbell);- if (!arcmsr_hbb_wait_msgint_ready(acb)) {-  printk(KERN_NOTICE "arcmsr%d: wait 'start adapter background \-    rebulid' timeout \n",acb->host->host_no);+ if (!arcmsr_hbaB_wait_msgint_ready(acb)) {+  pr_notice("arcmsr%d: wait 'start adapter "+  "backgroundrebulid' timeout\n", acb->host->host_no);  } }-static void arcmsr_start_hbc_bgrb(struct AdapterControlBlock *pACB)+static void+arcmsr_hbaC_start_bgrb(struct AdapterControlBlock *pACB) {- struct MessageUnit_C *phbcmu = (struct MessageUnit_C *)pACB->pmuC;+ struct MessageUnit_C __iomem *phbcmu = pACB->pmuC;  pACB->acb_flags |= ACB_F_MSG_START_BGRB;- writel(ARCMSR_INBOUND_
 MESG0_START_BGRB, &phbcmu->inbound_msgaddr0);- writel(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE, &phbcmu->inbound_doorbell);- if (!arcmsr_hbc_wait_msgint_ready(pACB)) {-  printk(KERN_NOTICE "arcmsr%d: wait 'start adapter background \-    rebulid' timeout \n", pACB->host->host_no);+ writel(ARCMSR_INBOUND_MESG0_START_BGRB,+  &phbcmu->inbound_msgaddr0);+ writel(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE,+  &phbcmu->inbound_doorbell);+ if (!arcmsr_hbaC_wait_msgint_ready(pACB)) {+  pr_notice("arcmsr%d: wait 'start adapter "+  "background rebulid' timeout\n", pACB->host->host_no);  }  return; }-static void arcmsr_start_adapter_bgrb(struct AdapterControlBlock *acb)++static void+arcmsr_hbaD_start_bgrb(struct AdapterControlBlock *pACB)+{+ struct MessageUnit_D __iomem *pmu = pACB->pmuD;+ pACB->acb_flags |=
  ACB_F_MSG_START_BGRB;+ writel(ARCMSR_INBOUND_MESG0_START_BGRB, pmu->inbound_msgaddr0);+ if (!arcmsr_hbaD_wait_msgint_ready(pACB)) {+  pr_notice("arcmsr%d: wait 'start adapter "+  "background rebulid' timeout\n", pACB->host->host_no);+ }+ return;+}++static void+arcmsr_start_adapter_bgrb(struct AdapterControlBlock *acb) {  switch (acb->adapter_type) {  case ACB_ADAPTER_TYPE_A:-  arcmsr_start_hba_bgrb(acb);+  arcmsr_hbaA_start_bgrb(acb);   break;  case ACB_ADAPTER_TYPE_B:-  arcmsr_start_hbb_bgrb(acb);+  arcmsr_hbaB_start_bgrb(acb);   break;  case ACB_ADAPTER_TYPE_C:-  arcmsr_start_hbc_bgrb(acb);+  arcmsr_hbaC_start_bgrb(acb);+  break;+ case ACB_ADAPTER_TYPE_D:+  arcmsr_hbaD_start_bgrb(acb);+  break;  } }-static void arcmsr_clear_doorbell_queue_buffer(struct AdapterControlBlock*acb)+static 
 void+arcmsr_clear_doorbell_queue_buffer(struct AdapterControlBlock *acb) {  switch (acb->adapter_type) {  case ACB_ADAPTER_TYPE_A: {@@ -2771,65 +4115,107 @@ static void arcmsr_clear_doorbell_queue_   outbound_doorbell = readl(&reg->outbound_doorbell);   /*clear doorbell interrupt */   writel(outbound_doorbell, &reg->outbound_doorbell);-  writel(ARCMSR_INBOUND_DRIVER_DATA_READ_OK, &reg->inbound_doorbell);+  writel(ARCMSR_INBOUND_DRIVER_DATA_READ_OK,+   &reg->inbound_doorbell);   }   break;  case ACB_ADAPTER_TYPE_B: {-  struct MessageUnit_B *reg = acb->pmuB;+  struct MessageUnit_B __iomem *reg = acb->pmuB;   /*clear interrupt and message state*/-  writel(ARCMSR_MESSAGE_INT_CLEAR_PATTERN, reg->iop2drv_doorbell);-  writel(ARCMSR_DRV2IOP_DATA_READ_OK, reg->drv2iop_doorbell);+  writel(ARCMSR_M
 ESSAGE_INT_CLEAR_PATTERN,+  reg->iop2drv_doorbell);+  writel(ARCMSR_DRV2IOP_DATA_READ_OK,+   reg->drv2iop_doorbell);   /* let IOP know data has been read */   }   break;  case ACB_ADAPTER_TYPE_C: {-  struct MessageUnit_C *reg = (struct MessageUnit_C *)acb->pmuC;-  uint32_t outbound_doorbell;+  struct MessageUnit_C __iomem *reg = acb->pmuC;+  uint32_t outbound_doorbell, i;   /* empty doorbell Qbuffer if door bell ringed */   outbound_doorbell = readl(&reg->outbound_doorbell);   writel(outbound_doorbell, &reg->outbound_doorbell_clear);-  writel(ARCMSR_HBCMU_DRV2IOP_DATA_READ_OK, &reg->inbound_doorbell);+  writel(ARCMSR_HBCMU_DRV2IOP_DATA_READ_OK,+   &reg->inbound_doorbell);+  for (i = 0; i < 200; i++) {+   msleep(20);+   outbound_doorbell = readl(&reg->outbound_doorbell);+   if (outbound_d
 oorbell & ARCMSR_HBCMU_IOP2DRV_DATA_WRITE_OK) {+    writel(outbound_doorbell,+    &reg->outbound_doorbell_clear);+    writel(ARCMSR_HBCMU_DRV2IOP_DATA_READ_OK,+    &reg->inbound_doorbell);+   } else+    break;+  }+  }+  break;+ case ACB_ADAPTER_TYPE_D: {+  struct MessageUnit_D __iomem *reg = acb->pmuD;+  uint32_t outbound_doorbell, i;+  /* empty doorbell Qbuffer if door bell ringed */+  outbound_doorbell = readl(reg->outbound_doorbell);+  writel(outbound_doorbell, reg->outbound_doorbell);+  writel(ARCMSR_ARC1214_DRV2IOP_DATA_OUT_READ,+   reg->inbound_doorbell);+  for (i = 0; i < 200; i++) {+   msleep(20);+   outbound_doorbell = readl(reg->outbound_doorbell);+   if (outbound_doorbell & ARCMSR_ARC1214_IOP2DRV_DATA_WRITE_OK) {+    writel(outbound_doorbell,+    reg->outbound_doorbell);+    w
 ritel(ARCMSR_ARC1214_DRV2IOP_DATA_OUT_READ,+    reg->inbound_doorbell);+   } else+    break;   }+  break;+ }  } }-static void arcmsr_enable_eoi_mode(struct AdapterControlBlock *acb)+static void+arcmsr_enable_eoi_mode(struct AdapterControlBlock *acb) {  switch (acb->adapter_type) {  case ACB_ADAPTER_TYPE_A:+ case ACB_ADAPTER_TYPE_C:+ case ACB_ADAPTER_TYPE_D:   return;- case ACB_ADAPTER_TYPE_B:-  {-   struct MessageUnit_B *reg = acb->pmuB;-   writel(ARCMSR_MESSAGE_ACTIVE_EOI_MODE, reg->drv2iop_doorbell);-   if (!arcmsr_hbb_wait_msgint_ready(acb)) {-    printk(KERN_NOTICE "ARCMSR IOP enables EOI_MODE TIMEOUT");+ case ACB_ADAPTER_TYPE_B: {+  struct MessageUnit_B __iomem *reg = acb->pmuB;+   writel(ARCMSR_MESSAGE_ACTIVE_EOI_MODE,+    reg->drv2iop_doorbell);+   if (!arcmsr_hbaB_wait_msgint_rea
 dy(acb)) {+    pr_notice("ARCMSR IOP "+    "enables EOI_MODE TIMEOUT");     return;    }-  }-  break;- case ACB_ADAPTER_TYPE_C:-  return;+ }+ break;  }  return; }-static void arcmsr_hardware_reset(struct AdapterControlBlock *acb)+static void+arcmsr_hardware_reset(struct AdapterControlBlock *acb) {  uint8_t value[64];  int i, count = 0;  struct MessageUnit_A __iomem *pmuA = acb->pmuA;  struct MessageUnit_C __iomem *pmuC = acb->pmuC;-+ u32 temp = 0;  /* backup pci config data */- printk(KERN_NOTICE "arcmsr%d: executing hw bus reset .....\n",acb->host->host_no);+ pr_notice("arcmsr%d: executing hw bus reset .....\n",+ acb->host->host_no);  for (i = 0; i < 64; i++) {   pci_read_config_byte(acb->pdev, i, &value[i]);  }  /* hardware reset signal */  if ((acb->dev_id == 0x1680)) {-  writel(ARCMS
 R_ARC1680_BUS_RESET, &pmuA->reserved1[0]);+  writel(ARCMSR_ARC1680_BUS_RESET,+   &pmuA->reserved1[0]);  } else if ((acb->dev_id == 0x1880)) {   do {    count++;@@ -2839,8 +4225,11 @@ static void arcmsr_hardware_reset(struct    writel(0x2, &pmuC->write_sequence);    writel(0x7, &pmuC->write_sequence);    writel(0xD, &pmuC->write_sequence);-  } while (((readl(&pmuC->host_diagnostic) &ARCMSR_ARC1880_DiagWrite_ENABLE) == 0) && (count < 5));-  writel(ARCMSR_ARC1880_RESET_ADAPTER, &pmuC->host_diagnostic);+  } while ((((temp = readl(&pmuC->host_diagnostic)) |+  ARCMSR_ARC1880_DiagWrite_ENABLE) == 0) &&+  (count < 5));+  writel(ARCMSR_ARC1880_RESET_ADAPTER,+   &pmuC->host_diagnostic);  } else {   pci_write_config_byte(acb->pdev, 0x84, 0x20);  }@@ -2852,7 +4241,9 @@ static void arcmsr_hardware_re
 set(struct  msleep(1000);  return; }-static void arcmsr_iop_init(struct AdapterControlBlock *acb)++static void+arcmsr_iop_init(struct AdapterControlBlock *acb) {  uint32_t intmask_org;  /* disable all outbound interrupt */@@ -2869,7 +4260,8 @@ static void arcmsr_iop_init(struct Adapt  acb->acb_flags |= ACB_F_IOP_INITED; }-static uint8_t arcmsr_iop_reset(struct AdapterControlBlock *acb)+static uint8_t+arcmsr_iop_reset(struct AdapterControlBlock *acb) {  struct CommandControlBlock *ccb;  uint32_t intmask_org;@@ -2892,7 +4284,8 @@ static uint8_t arcmsr_iop_reset(struct A     ccb->ccb_flags = 0;     spin_lock_irqsave(&acb->ccblist_lock, flags);     list_add_tail(&ccb->list, &acb->ccb_free_list);-    spin_unlock_irqrestore(&acb->ccblist_lock, flags);+    spin_unlock_irqrestore(&acb->ccblist_l
 ock,+     flags);    }   }   atomic_set(&acb->ccboutstandingcount, 0);@@ -2903,147 +4296,235 @@ static uint8_t arcmsr_iop_reset(struct A  return rtnval; }-static int arcmsr_bus_reset(struct scsi_cmnd *cmd)+static int+arcmsr_bus_reset(struct scsi_cmnd *cmd) {  struct AdapterControlBlock *acb;  uint32_t intmask_org, outbound_doorbell;  int retry_count = 0;  int rtn = FAILED;  acb = (struct AdapterControlBlock *) cmd->device->host->hostdata;- printk(KERN_ERR "arcmsr: executing bus reset eh.....num_resets = %d,num_aborts = %d \n", acb->num_resets, acb->num_aborts);+ pr_err("arcmsr: executing bus reset eh.....num_resets = %d, "+ "num_aborts = %d\n", acb->num_resets, acb->num_aborts);  acb->num_resets++;- switch(acb->adapter_type){-  case ACB_ADAPTER_TYPE_A:{-   if (acb->acb_flags & ACB_F_BUS_
 RESET){-    long timeout;-    printk(KERN_ERR "arcmsr: there is an  bus reset ehproceeding.......\n");-    timeout = wait_event_timeout(wait_q, (acb->acb_flags & ACB_F_BUS_RESET)== 0, 220*HZ);-    if (timeout) {-     return SUCCESS;-    }-   }-   acb->acb_flags |= ACB_F_BUS_RESET;-   if (!arcmsr_iop_reset(acb)) {-    struct MessageUnit_A __iomem *reg;-    reg = acb->pmuA;-    arcmsr_hardware_reset(acb);-    acb->acb_flags &= ~ACB_F_IOP_INITED;+ switch (acb->adapter_type) {+ case ACB_ADAPTER_TYPE_A: {+  if (acb->acb_flags & ACB_F_BUS_RESET) {+   long timeout;+   pr_err("arcmsr: there is an bus "+   "reset eh proceeding.......\n");+   timeout = wait_event_timeout(wait_q,+   (acb->acb_flags & ACB_F_BUS_RESET)+   == 0, 220 * HZ);+   if (timeout)+    return SUCCESS;+  }+  acb->acb_flags |= AC
 B_F_BUS_RESET;+  if (!arcmsr_iop_reset(acb)) {+   struct MessageUnit_A __iomem *reg;+   reg = acb->pmuA;+   arcmsr_hardware_reset(acb);+   acb->acb_flags &= ~ACB_F_IOP_INITED; sleep_again:-    ssleep(ARCMSR_SLEEPTIME);-    if ((readl(&reg->outbound_msgaddr1) &ARCMSR_OUTBOUND_MESG1_FIRMWARE_OK) == 0) {-     printk(KERN_ERR "arcmsr%d: waiting for hw bus reset return,retry=%d\n", acb->host->host_no, retry_count);-     if (retry_count > ARCMSR_RETRYCOUNT) {-      acb->fw_flag = FW_DEADLOCK;-      printk(KERN_ERR "arcmsr%d: waiting for hw bus reset return, RETRYTERMINATED!!\n", acb->host->host_no);-      return FAILED;-     }-     retry_count++;-     goto sleep_again;+   ssleep(ARCMSR_SLEEPTIME);+   if ((readl(&reg->outbound_msgaddr1) &+   ARCMSR_OUTBOUND_MESG1_FIRMWARE_OK) == 0) {+    pr_err
 ("arcmsr%d: waiting for "+    "hw bus reset return, retry = %d\n",+    acb->host->host_no, retry_count);+    if (retry_count > ARCMSR_RETRYCOUNT) {+     acb->fw_flag = FW_DEADLOCK;+     pr_err("arcmsr%d: waiting "+     "for hw bus reset return, "+     "RETRY TERMINATED!!\n",+     acb->host->host_no);+     return FAILED;     }-    acb->acb_flags |= ACB_F_IOP_INITED;-    /* disable all outbound interrupt */-    intmask_org = arcmsr_disable_outbound_ints(acb);-    arcmsr_get_firmware_spec(acb);-    arcmsr_start_adapter_bgrb(acb);-    /* clear Qbuffer if door bell ringed */-    outbound_doorbell = readl(&reg->outbound_doorbell);-    writel(outbound_doorbell, &reg->outbound_doorbell); /*clear interrupt*/-       writel(ARCMSR_INBOUND_DRIVER_DATA_READ_OK, &reg->inbound_doorbell);-    /* enable 
 outbound Post Queue,outbound doorbell Interrupt */-    arcmsr_enable_outbound_ints(acb, intmask_org);-    atomic_set(&acb->rq_map_token, 16);-    atomic_set(&acb->ante_token_value, 16);-    acb->fw_flag = FW_NORMAL;-    mod_timer(&acb->eternal_timer, jiffies + msecs_to_jiffies(6 * HZ));-    acb->acb_flags &= ~ACB_F_BUS_RESET;-    rtn = SUCCESS;-    printk(KERN_ERR "arcmsr: scsi  bus reset eh returns with success\n");-   } else {-    acb->acb_flags &= ~ACB_F_BUS_RESET;-    atomic_set(&acb->rq_map_token, 16);-    atomic_set(&acb->ante_token_value, 16);-    acb->fw_flag = FW_NORMAL;-    mod_timer(&acb->eternal_timer, jiffies + msecs_to_jiffies(6*HZ));-    rtn = SUCCESS;+    retry_count++;+    goto sleep_again;    }-   break;+   acb->acb_flags |= ACB_F_IOP_INITED;+   /* disable all outbound 
 interrupt */+   intmask_org = arcmsr_disable_outbound_ints(acb);+   arcmsr_get_firmware_spec(acb);+   arcmsr_start_adapter_bgrb(acb);+   /* clear Qbuffer if door bell ringed */+   outbound_doorbell = readl(&reg->outbound_doorbell);+   writel(outbound_doorbell, &reg->outbound_doorbell);+   writel(ARCMSR_INBOUND_DRIVER_DATA_READ_OK,+    &reg->inbound_doorbell);+   arcmsr_enable_outbound_ints(acb, intmask_org);+   atomic_set(&acb->rq_map_token, 16);+   atomic_set(&acb->ante_token_value, 16);+   acb->fw_flag = FW_NORMAL;+   mod_timer(&acb->eternal_timer, jiffies ++    msecs_to_jiffies(6 * HZ));+   acb->acb_flags &= ~ACB_F_BUS_RESET;+   rtn = SUCCESS;+   pr_err("arcmsr: scsi bus reset eh "+   "returns with success\n");+  } else {+   acb->acb_flags &= ~ACB_F_BUS_RESET;+   atomic_set(&acb->rq_m
 ap_token, 16);+   atomic_set(&acb->ante_token_value, 16);+   acb->fw_flag = FW_NORMAL;+   mod_timer(&acb->eternal_timer,+   jiffies + msecs_to_jiffies(6 * HZ));+   rtn = SUCCESS;   }-  case ACB_ADAPTER_TYPE_B:{-   acb->acb_flags |= ACB_F_BUS_RESET;-   if (!arcmsr_iop_reset(acb)) {-    acb->acb_flags &= ~ACB_F_BUS_RESET;-    rtn = FAILED;-   } else {-    acb->acb_flags &= ~ACB_F_BUS_RESET;-    atomic_set(&acb->rq_map_token, 16);-    atomic_set(&acb->ante_token_value, 16);-    acb->fw_flag = FW_NORMAL;-    mod_timer(&acb->eternal_timer, jiffies + msecs_to_jiffies(6 * HZ));-    rtn = SUCCESS;-   }-   break;+  break;+ }+ case ACB_ADAPTER_TYPE_B: {+  acb->acb_flags |= ACB_F_BUS_RESET;+  if (!arcmsr_iop_reset(acb)) {+   acb->acb_flags &= ~ACB_F_BUS_RESET;+   rtn = FAILED;+  } else {+   acb->ac
 b_flags &= ~ACB_F_BUS_RESET;+   atomic_set(&acb->rq_map_token, 16);+   atomic_set(&acb->ante_token_value, 16);+   acb->fw_flag = FW_NORMAL;+   mod_timer(&acb->eternal_timer,+    jiffies + msecs_to_jiffies(6 * HZ));+   rtn = SUCCESS;   }-  case ACB_ADAPTER_TYPE_C:{-   if (acb->acb_flags & ACB_F_BUS_RESET) {-    long timeout;-    printk(KERN_ERR "arcmsr: there is an bus reset ehproceeding.......\n");-    timeout = wait_event_timeout(wait_q, (acb->acb_flags & ACB_F_BUS_RESET)== 0, 220*HZ);-    if (timeout) {-     return SUCCESS;+  break;+ }+ case ACB_ADAPTER_TYPE_C: {+  if (acb->acb_flags & ACB_F_BUS_RESET) {+   long timeout;+   pr_err("arcmsr: there is an bus "+   "reset eh proceeding.......\n");+   timeout = wait_event_timeout(wait_q,+   (acb->acb_flags & ACB_F_BUS_RESET) == 0,+   220 * H
 Z);+   if (timeout)+    return SUCCESS;+  }+  acb->acb_flags |= ACB_F_BUS_RESET;+  if (!arcmsr_iop_reset(acb)) {+   struct MessageUnit_C __iomem *reg;+   reg = acb->pmuC;+   arcmsr_hardware_reset(acb);+   acb->acb_flags &= ~ACB_F_IOP_INITED;+sleep:+   ssleep(ARCMSR_SLEEPTIME);+   if ((readl(&reg->host_diagnostic) & 0x04) != 0) {+    pr_err("arcmsr%d: waiting "+    "for hw bus reset return, retry = %d\n",+    acb->host->host_no, retry_count);+    if (retry_count > ARCMSR_RETRYCOUNT) {+     acb->fw_flag = FW_DEADLOCK;+     pr_err("arcmsr%d: "+     "waiting for hw bus reset return, "+     "RETRY TERMINATED!!\n",+     acb->host->host_no);+     return FAILED;     }+    retry_count++;+    goto sleep;    }-   acb->acb_flags |= ACB_F_BUS_RESET;-   if (!arcmsr_iop_reset(acb)) {-    struct Message
 Unit_C __iomem *reg;-    reg = acb->pmuC;-    arcmsr_hardware_reset(acb);-    acb->acb_flags &= ~ACB_F_IOP_INITED;-sleep:-    ssleep(ARCMSR_SLEEPTIME);-    if ((readl(&reg->host_diagnostic) & 0x04) != 0) {-     printk(KERN_ERR "arcmsr%d: waiting for hw bus reset return,retry=%d\n", acb->host->host_no, retry_count);-     if (retry_count > ARCMSR_RETRYCOUNT) {-      acb->fw_flag = FW_DEADLOCK;-      printk(KERN_ERR "arcmsr%d: waiting for hw bus reset return, RETRYTERMINATED!!\n", acb->host->host_no);-      return FAILED;-     }-     retry_count++;-     goto sleep;+   acb->acb_flags |= ACB_F_IOP_INITED;+   /* disable all outbound interrupt */+   intmask_org =+   arcmsr_disable_outbound_ints(acb);+   arcmsr_get_firmware_spec(acb);+   arcmsr_start_adapter_bgrb(acb);+   /* clear Qbuffer if doo
 r bell ringed */+   outbound_doorbell =+   readl(&reg->outbound_doorbell);+   writel(outbound_doorbell,+    &reg->outbound_doorbell_clear);+   writel(ARCMSR_HBCMU_DRV2IOP_DATA_READ_OK,+    &reg->inbound_doorbell);+   arcmsr_enable_outbound_ints(acb,+    intmask_org);+   atomic_set(&acb->rq_map_token, 16);+   atomic_set(&acb->ante_token_value, 16);+   acb->fw_flag = FW_NORMAL;+   mod_timer(&acb->eternal_timer, jiffies ++    msecs_to_jiffies(6 * HZ));+   acb->acb_flags &= ~ACB_F_BUS_RESET;+   rtn = SUCCESS;+   pr_err("arcmsr: scsi bus reset "+   "eh returns with success\n");+  } else {+   acb->acb_flags &= ~ACB_F_BUS_RESET;+   atomic_set(&acb->rq_map_token, 16);+   atomic_set(&acb->ante_token_value, 16);+   acb->fw_flag = FW_NORMAL;+   mod_timer(&acb->eternal_timer, jiffies ++   msecs_to_j
 iffies(6 * HZ));+   rtn = SUCCESS;+  }+  break;+ }+ case ACB_ADAPTER_TYPE_D: {+  if (acb->acb_flags & ACB_F_BUS_RESET) {+   long timeout;+   pr_notice("arcmsr: there is an bus reset eh proceeding.......\n");+   timeout = wait_event_timeout(wait_q, (acb->acb_flags+    & ACB_F_BUS_RESET) == 0, 220 * HZ);+   if (timeout)+    return SUCCESS;+  }+  acb->acb_flags |= ACB_F_BUS_RESET;+  if (!arcmsr_iop_reset(acb)) {+   struct MessageUnit_D __iomem *reg;+   reg = acb->pmuD;+   arcmsr_hardware_reset(acb);+   acb->acb_flags &= ~ACB_F_IOP_INITED;+   nap:+   ssleep(ARCMSR_SLEEPTIME);+   if ((readl(reg->sample_at_reset) & 0x80) != 0) {+    pr_err("arcmsr%d: waiting for "+    "hw bus reset return, retry=%d\n",+    acb->host->host_no, retry_count);+    if (retry_count > ARCMSR_RETRYCOUNT) {+     acb->f
 w_flag = FW_DEADLOCK;+     pr_err("arcmsr%d: "+     "waiting for hw bus reset return, "+     "RETRY TERMINATED!!\n",+     acb->host->host_no);+     return FAILED;     }-    acb->acb_flags |= ACB_F_IOP_INITED;-    /* disable all outbound interrupt */-    intmask_org = arcmsr_disable_outbound_ints(acb);-    arcmsr_get_firmware_spec(acb);-    arcmsr_start_adapter_bgrb(acb);-    /* clear Qbuffer if door bell ringed */-    outbound_doorbell = readl(&reg->outbound_doorbell);-    writel(outbound_doorbell, &reg->outbound_doorbell_clear); /*clearinterrupt */-    writel(ARCMSR_HBCMU_DRV2IOP_DATA_READ_OK, &reg->inbound_doorbell);-    /* enable outbound Post Queue,outbound doorbell Interrupt */-    arcmsr_enable_outbound_ints(acb, intmask_org);-    atomic_set(&acb->rq_map_token, 16);-    atomic_set(
 &acb->ante_token_value, 16);-    acb->fw_flag = FW_NORMAL;-    mod_timer(&acb->eternal_timer, jiffies + msecs_to_jiffies(6 * HZ));-    acb->acb_flags &= ~ACB_F_BUS_RESET;-    rtn = SUCCESS;-    printk(KERN_ERR "arcmsr: scsi bus reset eh returns with success\n");-   } else {-    acb->acb_flags &= ~ACB_F_BUS_RESET;-    atomic_set(&acb->rq_map_token, 16);-    atomic_set(&acb->ante_token_value, 16);-    acb->fw_flag = FW_NORMAL;-    mod_timer(&acb->eternal_timer, jiffies + msecs_to_jiffies(6*HZ));-    rtn = SUCCESS;+    retry_count++;+    goto nap;    }-   break;+   acb->acb_flags |= ACB_F_IOP_INITED;+   /* disable all outbound interrupt */+   intmask_org = arcmsr_disable_outbound_ints(acb);+   arcmsr_get_firmware_spec(acb);+   arcmsr_start_adapter_bgrb(acb);+   arcmsr_clear_doorbell_queue_b
 uffer(acb);+   arcmsr_enable_outbound_ints(acb, intmask_org);+   atomic_set(&acb->rq_map_token, 16);+   atomic_set(&acb->ante_token_value, 16);+   acb->fw_flag = FW_NORMAL;+   mod_timer(&acb->eternal_timer,+    jiffies + msecs_to_jiffies(6 * HZ));+   acb->acb_flags &= ~ACB_F_BUS_RESET;+   rtn = SUCCESS;+   pr_err("arcmsr: scsi bus reset "+   "eh returns with success\n");+  } else {+   acb->acb_flags &= ~ACB_F_BUS_RESET;+   atomic_set(&acb->rq_map_token, 16);+   atomic_set(&acb->ante_token_value, 16);+   acb->fw_flag = FW_NORMAL;+   mod_timer(&acb->eternal_timer,+    jiffies + msecs_to_jiffies(6 * HZ));+   rtn = SUCCESS;   }+  break;+ }  }  return rtn; }-static int arcmsr_abort_one_cmd(struct AdapterControlBlock *acb,+static int+arcmsr_abort_one_cmd(struct AdapterControlBlock *acb,   stru
 ct CommandControlBlock *ccb) {  int rtn;@@ -3051,15 +4532,17 @@ static int arcmsr_abort_one_cmd(struct A  return rtn; }-static int arcmsr_abort(struct scsi_cmnd *cmd)+static int+arcmsr_abort(struct scsi_cmnd *cmd) {- struct AdapterControlBlock *acb =-  (struct AdapterControlBlock *)cmd->device->host->hostdata;+ struct AdapterControlBlock *acb = (struct AdapterControlBlock *)+  cmd->device->host->hostdata;  int i = 0;  int rtn = FAILED;- printk(KERN_NOTICE-  "arcmsr%d: abort device command of scsi id = %d lun = %d \n",-  acb->host->host_no, cmd->device->id, cmd->device->lun);+ pr_notice("arcmsr%d: abort device command of "+  "scsi id = %d lun = %d\n",+  acb->host->host_no,+  cmd->device->id, cmd->device->lun);  acb->acb_flags |= ACB_F_ABORT;  acb->num_aborts++;  /*@@ -3073,7 +4556,8 @@ st
 atic int arcmsr_abort(struct scsi_cmnd  for (i = 0; i < ARCMSR_MAX_FREECCB_NUM; i++) {   struct CommandControlBlock *ccb = acb->pccb_pool[i];-  if (ccb->startdone == ARCMSR_CCB_START && ccb->pcmd == cmd) {+  if (ccb->startdone == ARCMSR_CCB_START &&+   ccb->pcmd == cmd) {    ccb->startdone = ARCMSR_CCB_ABORTED;    rtn = arcmsr_abort_one_cmd(acb, ccb);    break;@@ -3083,10 +4567,11 @@ static int arcmsr_abort(struct scsi_cmnd  return rtn; }-static const char *arcmsr_info(struct Scsi_Host *host)+static const char+*arcmsr_info(struct Scsi_Host *host) {  struct AdapterControlBlock *acb =-  (struct AdapterControlBlock *) host->hostdata;+ (struct AdapterControlBlock *)host->hostdata;  static char buf[256];  char *type;  int raid6 = 1;@@ -3102,6 +4587,7 @@ static const char *arcmsr_info(struct S
 c  case PCI_DEVICE_ID_ARECA_1160:  case PCI_DEVICE_ID_ARECA_1170:  case PCI_DEVICE_ID_ARECA_1201:+ case PCI_DEVICE_ID_ARECA_1214:  case PCI_DEVICE_ID_ARECA_1220:  case PCI_DEVICE_ID_ARECA_1230:  case PCI_DEVICE_ID_ARECA_1260:@@ -3109,19 +4595,19 @@ static const char *arcmsr_info(struct Sc  case PCI_DEVICE_ID_ARECA_1280:   type = "SATA";   break;- case PCI_DEVICE_ID_ARECA_1380:- case PCI_DEVICE_ID_ARECA_1381:  case PCI_DEVICE_ID_ARECA_1680:  case PCI_DEVICE_ID_ARECA_1681:  case PCI_DEVICE_ID_ARECA_1880:   type = "SAS";   break;  default:-  type = "X-TYPE";+  type = "unknown";+  raid6 = 0;   break;  }- sprintf(buf, "Areca %s Host Adapter RAID Controller%s\n %s",-   type, raid6 ? "( RAID6 capable)" : "",-   ARCMSR_DRIVER_VERSION);+ sprintf(buf, "Areca %s Host Adapter RAID Controller%s\narcm
 sr version%s\n",+  type, raid6 ? "( RAID6 capable)" : "", ARCMSR_DRIVER_VERSION);+  return buf; }+
------=_NextPart_000_002C_01CEA425.E40A7980
Content-Type: application/octet-stream;
	name="patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="patch"

diff -uprN a/drivers/scsi/arcmsr/arcmsr_attr.c =
b/drivers/scsi/arcmsr/arcmsr_attr.c=0A=
--- a/drivers/scsi/arcmsr/arcmsr_attr.c	2013-07-01 06:13:28.000000000 =
+0800=0A=
+++ b/drivers/scsi/arcmsr/arcmsr_attr.c	2013-08-28 03:19:46.000000000 =
+0800=0A=
@@ -59,64 +59,87 @@=0A=
 =0A=
 struct device_attribute *arcmsr_host_attrs[];=0A=
 =0A=
-static ssize_t arcmsr_sysfs_iop_message_read(struct file *filp,=0A=
-					     struct kobject *kobj,=0A=
-					     struct bin_attribute *bin,=0A=
-					     char *buf, loff_t off,=0A=
-					     size_t count)=0A=
+static ssize_t=0A=
+arcmsr_sysfs_iop_message_read(struct file *filp,=0A=
+				struct kobject *kobj,=0A=
+				struct bin_attribute *bin,=0A=
+				char *buf, loff_t off,=0A=
+				size_t count)=0A=
 {=0A=
-	struct device *dev =3D container_of(kobj,struct device,kobj);=0A=
+	struct device *dev =3D container_of(kobj, struct device, kobj);=0A=
 	struct Scsi_Host *host =3D class_to_shost(dev);=0A=
-	struct AdapterControlBlock *acb =3D (struct AdapterControlBlock *) =
host->hostdata;=0A=
+	struct AdapterControlBlock *acb =3D=0A=
+		(struct AdapterControlBlock *)host->hostdata;=0A=
 	uint8_t *pQbuffer,*ptmpQbuffer;=0A=
 	int32_t allxfer_len =3D 0;=0A=
+	unsigned long flags;=0A=
 =0A=
 	if (!capable(CAP_SYS_ADMIN))=0A=
 		return -EACCES;=0A=
 =0A=
 	/* do message unit read. */=0A=
 	ptmpQbuffer =3D (uint8_t *)buf;=0A=
-	while ((acb->rqbuf_firstindex !=3D acb->rqbuf_lastindex)=0A=
-		&& (allxfer_len < 1031)) {=0A=
+	spin_lock_irqsave(&acb->rqbuffer_lock, flags);=0A=
+	if (acb->rqbuf_firstindex !=3D acb->rqbuf_lastindex) {=0A=
 		pQbuffer =3D &acb->rqbuffer[acb->rqbuf_firstindex];=0A=
-		memcpy(ptmpQbuffer, pQbuffer, 1);=0A=
-		acb->rqbuf_firstindex++;=0A=
-		acb->rqbuf_firstindex %=3D ARCMSR_MAX_QBUFFER;=0A=
-		ptmpQbuffer++;=0A=
-		allxfer_len++;=0A=
+		if (acb->rqbuf_firstindex > acb->rqbuf_lastindex) {=0A=
+			if ((ARCMSR_MAX_QBUFFER - acb->rqbuf_firstindex) >=3D 1032) {=0A=
+				memcpy((void *)ptmpQbuffer, (const void *)pQbuffer, 1032);=0A=
+				acb->rqbuf_firstindex +=3D 1032;=0A=
+				acb->rqbuf_firstindex %=3D ARCMSR_MAX_QBUFFER;=0A=
+				allxfer_len =3D 1032;=0A=
+			} else {=0A=
+				if (((ARCMSR_MAX_QBUFFER - acb->rqbuf_firstindex) + =
acb->rqbuf_lastindex) > 1032) {=0A=
+					memcpy((void *)ptmpQbuffer, (const void *)pQbuffer, =
ARCMSR_MAX_QBUFFER - acb->rqbuf_firstindex);=0A=
+					ptmpQbuffer +=3D ARCMSR_MAX_QBUFFER - acb->rqbuf_firstindex;=0A=
+					memcpy((void *)ptmpQbuffer, (const void *)acb->rqbuffer, 1032 - =
(ARCMSR_MAX_QBUFFER - acb->rqbuf_firstindex));=0A=
+					acb->rqbuf_firstindex =3D 1032 - (ARCMSR_MAX_QBUFFER - =
acb->rqbuf_firstindex);=0A=
+					allxfer_len =3D 1032;=0A=
+				} else {=0A=
+					memcpy((void *)ptmpQbuffer, (const void *)pQbuffer, =
ARCMSR_MAX_QBUFFER - acb->rqbuf_firstindex);=0A=
+					ptmpQbuffer +=3D ARCMSR_MAX_QBUFFER - acb->rqbuf_firstindex;=0A=
+					memcpy((void *)ptmpQbuffer, (const void *)acb->rqbuffer, =
acb->rqbuf_lastindex);=0A=
+					allxfer_len =3D ARCMSR_MAX_QBUFFER - acb->rqbuf_firstindex + =
acb->rqbuf_lastindex;=0A=
+					acb->rqbuf_firstindex =3D acb->rqbuf_lastindex;=0A=
+				}=0A=
+			}=0A=
+		} else {=0A=
+			if ((acb->rqbuf_lastindex - acb->rqbuf_firstindex) > 1032) {=0A=
+				memcpy((void *)ptmpQbuffer, (const void *)pQbuffer, 1032);=0A=
+				acb->rqbuf_firstindex +=3D 1032;=0A=
+				allxfer_len =3D 1032;=0A=
+			} else {=0A=
+				memcpy((void *)ptmpQbuffer, (const void *)pQbuffer, =
acb->rqbuf_lastindex - acb->rqbuf_firstindex);=0A=
+				allxfer_len =3D acb->rqbuf_lastindex - acb->rqbuf_firstindex;=0A=
+				acb->rqbuf_firstindex =3D acb->rqbuf_lastindex;=0A=
+			}=0A=
+		}=0A=
 	}=0A=
 	if (acb->acb_flags & ACB_F_IOPDATA_OVERFLOW) {=0A=
 		struct QBUFFER __iomem *prbuffer;=0A=
-		uint8_t __iomem *iop_data;=0A=
-		int32_t iop_len;=0A=
-=0A=
 		acb->acb_flags &=3D ~ACB_F_IOPDATA_OVERFLOW;=0A=
 		prbuffer =3D arcmsr_get_iop_rqbuffer(acb);=0A=
-		iop_data =3D prbuffer->data;=0A=
-		iop_len =3D readl(&prbuffer->data_len);=0A=
-		while (iop_len > 0) {=0A=
-			acb->rqbuffer[acb->rqbuf_lastindex] =3D readb(iop_data);=0A=
-			acb->rqbuf_lastindex++;=0A=
-			acb->rqbuf_lastindex %=3D ARCMSR_MAX_QBUFFER;=0A=
-			iop_data++;=0A=
-			iop_len--;=0A=
-		}=0A=
-		arcmsr_iop_message_read(acb);=0A=
+		if (arcmsr_Read_iop_rqbuffer_data(acb, prbuffer) =3D=3D 0)=0A=
+			acb->acb_flags |=3D ACB_F_IOPDATA_OVERFLOW;=0A=
 	}=0A=
+	spin_unlock_irqrestore(&acb->rqbuffer_lock, flags);=0A=
 	return (allxfer_len);=0A=
 }=0A=
 =0A=
-static ssize_t arcmsr_sysfs_iop_message_write(struct file *filp,=0A=
-					      struct kobject *kobj,=0A=
-					      struct bin_attribute *bin,=0A=
-					      char *buf, loff_t off,=0A=
-					      size_t count)=0A=
+static ssize_t=0A=
+arcmsr_sysfs_iop_message_write(struct file *filp,=0A=
+				      struct kobject *kobj,=0A=
+				      struct bin_attribute *bin,=0A=
+				      char *buf, loff_t off,=0A=
+				      size_t count)=0A=
 {=0A=
-	struct device *dev =3D container_of(kobj,struct device,kobj);=0A=
+	struct device *dev =3D container_of(kobj, struct device, kobj);=0A=
 	struct Scsi_Host *host =3D class_to_shost(dev);=0A=
-	struct AdapterControlBlock *acb =3D (struct AdapterControlBlock *) =
host->hostdata;=0A=
+	struct AdapterControlBlock *acb =3D=0A=
+		(struct AdapterControlBlock *)host->hostdata;=0A=
 	int32_t my_empty_len, user_len, wqbuf_firstindex, wqbuf_lastindex;=0A=
 	uint8_t *pQbuffer, *ptmpuserbuffer;=0A=
+	unsigned long flags;=0A=
 =0A=
 	if (!capable(CAP_SYS_ADMIN))=0A=
 		return -EACCES;=0A=
@@ -125,10 +148,12 @@ static ssize_t arcmsr_sysfs_iop_message_=0A=
 	/* do message unit write. */=0A=
 	ptmpuserbuffer =3D (uint8_t *)buf;=0A=
 	user_len =3D (int32_t)count;=0A=
+	spin_lock_irqsave(&acb->wqbuffer_lock, flags);=0A=
 	wqbuf_lastindex =3D acb->wqbuf_lastindex;=0A=
 	wqbuf_firstindex =3D acb->wqbuf_firstindex;=0A=
 	if (wqbuf_lastindex !=3D wqbuf_firstindex) {=0A=
-		arcmsr_post_ioctldata2iop(acb);=0A=
+		arcmsr_write_ioctldata2iop(acb);=0A=
+		spin_unlock_irqrestore(&acb->wqbuffer_lock, flags);=0A=
 		return 0;	/*need retry*/=0A=
 	} else {=0A=
 		my_empty_len =3D (wqbuf_firstindex-wqbuf_lastindex - 1)=0A=
@@ -137,50 +162,58 @@ static ssize_t arcmsr_sysfs_iop_message_=0A=
 			while (user_len > 0) {=0A=
 				pQbuffer =3D=0A=
 				&acb->wqbuffer[acb->wqbuf_lastindex];=0A=
-				memcpy(pQbuffer, ptmpuserbuffer, 1);=0A=
+				memcpy((void *)pQbuffer, (const void *)ptmpuserbuffer, 1);=0A=
 				acb->wqbuf_lastindex++;=0A=
-				acb->wqbuf_lastindex %=3D ARCMSR_MAX_QBUFFER;=0A=
+				acb->wqbuf_lastindex %=3D=0A=
+					ARCMSR_MAX_QBUFFER;=0A=
 				ptmpuserbuffer++;=0A=
 				user_len--;=0A=
 			}=0A=
-			if (acb->acb_flags & ACB_F_MESSAGE_WQBUFFER_CLEARED) {=0A=
+			if (acb->acb_flags &=0A=
+				ACB_F_MESSAGE_WQBUFFER_CLEARED) {=0A=
 				acb->acb_flags &=3D=0A=
 					~ACB_F_MESSAGE_WQBUFFER_CLEARED;=0A=
-				arcmsr_post_ioctldata2iop(acb);=0A=
+				arcmsr_write_ioctldata2iop(acb);=0A=
 			}=0A=
+			spin_unlock_irqrestore(&acb->wqbuffer_lock, flags);=0A=
 			return count;=0A=
 		} else {=0A=
+			spin_unlock_irqrestore(&acb->wqbuffer_lock, flags);=0A=
 			return 0;	/*need retry*/=0A=
 		}=0A=
 	}=0A=
 }=0A=
 =0A=
-static ssize_t arcmsr_sysfs_iop_message_clear(struct file *filp,=0A=
-					      struct kobject *kobj,=0A=
-					      struct bin_attribute *bin,=0A=
-					      char *buf, loff_t off,=0A=
-					      size_t count)=0A=
+static ssize_t=0A=
+arcmsr_sysfs_iop_message_clear(struct file *filp,=0A=
+				      struct kobject *kobj,=0A=
+				      struct bin_attribute *bin,=0A=
+				      char *buf, loff_t off,=0A=
+				      size_t count)=0A=
 {=0A=
-	struct device *dev =3D container_of(kobj,struct device,kobj);=0A=
+	struct device *dev =3D container_of(kobj, struct device, kobj);=0A=
 	struct Scsi_Host *host =3D class_to_shost(dev);=0A=
-	struct AdapterControlBlock *acb =3D (struct AdapterControlBlock *) =
host->hostdata;=0A=
+	struct AdapterControlBlock *acb =3D=0A=
+		(struct AdapterControlBlock *)host->hostdata;=0A=
 	uint8_t *pQbuffer;=0A=
+	unsigned long flags;=0A=
 =0A=
 	if (!capable(CAP_SYS_ADMIN))=0A=
 		return -EACCES;=0A=
 =0A=
-	if (acb->acb_flags & ACB_F_IOPDATA_OVERFLOW) {=0A=
-		acb->acb_flags &=3D ~ACB_F_IOPDATA_OVERFLOW;=0A=
-		arcmsr_iop_message_read(acb);=0A=
-	}=0A=
+	arcmsr_clear_iop2drv_rqueue_buffer(acb);=0A=
 	acb->acb_flags |=3D=0A=
 		(ACB_F_MESSAGE_WQBUFFER_CLEARED=0A=
 		| ACB_F_MESSAGE_RQBUFFER_CLEARED=0A=
 		| ACB_F_MESSAGE_WQBUFFER_READED);=0A=
+	spin_lock_irqsave(&acb->rqbuffer_lock, flags);=0A=
 	acb->rqbuf_firstindex =3D 0;=0A=
 	acb->rqbuf_lastindex =3D 0;=0A=
+	spin_unlock_irqrestore(&acb->rqbuffer_lock, flags);=0A=
+	spin_lock_irqsave(&acb->wqbuffer_lock, flags);=0A=
 	acb->wqbuf_firstindex =3D 0;=0A=
 	acb->wqbuf_lastindex =3D 0;=0A=
+	spin_unlock_irqrestore(&acb->wqbuffer_lock, flags);=0A=
 	pQbuffer =3D acb->rqbuffer;=0A=
 	memset(pQbuffer, 0, sizeof (struct QBUFFER));=0A=
 	pQbuffer =3D acb->wqbuffer;=0A=
@@ -215,31 +248,37 @@ static struct bin_attribute arcmsr_sysfs=0A=
 	.write =3D arcmsr_sysfs_iop_message_clear,=0A=
 };=0A=
 =0A=
-int arcmsr_alloc_sysfs_attr(struct AdapterControlBlock *acb)=0A=
+int=0A=
+arcmsr_alloc_sysfs_attr(struct AdapterControlBlock *acb)=0A=
 {=0A=
 	struct Scsi_Host *host =3D acb->host;=0A=
 	int error;=0A=
 =0A=
-	error =3D sysfs_create_bin_file(&host->shost_dev.kobj, =
&arcmsr_sysfs_message_read_attr);=0A=
+	error =3D sysfs_create_bin_file(&host->shost_dev.kobj,=0A=
+		&arcmsr_sysfs_message_read_attr);=0A=
 	if (error) {=0A=
-		printk(KERN_ERR "arcmsr: alloc sysfs mu_read failed\n");=0A=
+		pr_err("arcmsr: alloc sysfs mu_read failed\n");=0A=
 		goto error_bin_file_message_read;=0A=
 	}=0A=
-	error =3D sysfs_create_bin_file(&host->shost_dev.kobj, =
&arcmsr_sysfs_message_write_attr);=0A=
+	error =3D sysfs_create_bin_file(&host->shost_dev.kobj,=0A=
+		&arcmsr_sysfs_message_write_attr);=0A=
 	if (error) {=0A=
-		printk(KERN_ERR "arcmsr: alloc sysfs mu_write failed\n");=0A=
+		pr_err("arcmsr: alloc sysfs mu_write failed\n");=0A=
 		goto error_bin_file_message_write;=0A=
 	}=0A=
-	error =3D sysfs_create_bin_file(&host->shost_dev.kobj, =
&arcmsr_sysfs_message_clear_attr);=0A=
+	error =3D sysfs_create_bin_file(&host->shost_dev.kobj,=0A=
+		&arcmsr_sysfs_message_clear_attr);=0A=
 	if (error) {=0A=
-		printk(KERN_ERR "arcmsr: alloc sysfs mu_clear failed\n");=0A=
+		pr_err("arcmsr: alloc sysfs mu_clear failed\n");=0A=
 		goto error_bin_file_message_clear;=0A=
 	}=0A=
 	return 0;=0A=
 error_bin_file_message_clear:=0A=
-	sysfs_remove_bin_file(&host->shost_dev.kobj, =
&arcmsr_sysfs_message_write_attr);=0A=
+	sysfs_remove_bin_file(&host->shost_dev.kobj,=0A=
+		&arcmsr_sysfs_message_write_attr);=0A=
 error_bin_file_message_write:=0A=
-	sysfs_remove_bin_file(&host->shost_dev.kobj, =
&arcmsr_sysfs_message_read_attr);=0A=
+	sysfs_remove_bin_file(&host->shost_dev.kobj,=0A=
+		&arcmsr_sysfs_message_read_attr);=0A=
 error_bin_file_message_read:=0A=
 	return error;=0A=
 }=0A=
@@ -248,15 +287,17 @@ void arcmsr_free_sysfs_attr(struct Adapt=0A=
 {=0A=
 	struct Scsi_Host *host =3D acb->host;=0A=
 =0A=
-	sysfs_remove_bin_file(&host->shost_dev.kobj, =
&arcmsr_sysfs_message_clear_attr);=0A=
-	sysfs_remove_bin_file(&host->shost_dev.kobj, =
&arcmsr_sysfs_message_write_attr);=0A=
-	sysfs_remove_bin_file(&host->shost_dev.kobj, =
&arcmsr_sysfs_message_read_attr);=0A=
+	sysfs_remove_bin_file(&host->shost_dev.kobj,=0A=
+		&arcmsr_sysfs_message_clear_attr);=0A=
+	sysfs_remove_bin_file(&host->shost_dev.kobj,=0A=
+		&arcmsr_sysfs_message_write_attr);=0A=
+	sysfs_remove_bin_file(&host->shost_dev.kobj,=0A=
+		&arcmsr_sysfs_message_read_attr);=0A=
 }=0A=
 =0A=
-=0A=
 static ssize_t=0A=
 arcmsr_attr_host_driver_version(struct device *dev,=0A=
-				struct device_attribute *attr, char *buf)=0A=
+			struct device_attribute *attr, char *buf)=0A=
 {=0A=
 	return snprintf(buf, PAGE_SIZE,=0A=
 			"%s\n",=0A=
@@ -265,11 +306,11 @@ arcmsr_attr_host_driver_version(struct d=0A=
 =0A=
 static ssize_t=0A=
 arcmsr_attr_host_driver_posted_cmd(struct device *dev,=0A=
-				   struct device_attribute *attr, char *buf)=0A=
+			struct device_attribute *attr, char *buf)=0A=
 {=0A=
 	struct Scsi_Host *host =3D class_to_shost(dev);=0A=
 	struct AdapterControlBlock *acb =3D=0A=
-		(struct AdapterControlBlock *) host->hostdata;=0A=
+		(struct AdapterControlBlock *)host->hostdata;=0A=
 	return snprintf(buf, PAGE_SIZE,=0A=
 			"%4d\n",=0A=
 			atomic_read(&acb->ccboutstandingcount));=0A=
@@ -281,7 +322,7 @@ arcmsr_attr_host_driver_reset(struct dev=0A=
 {=0A=
 	struct Scsi_Host *host =3D class_to_shost(dev);=0A=
 	struct AdapterControlBlock *acb =3D=0A=
-		(struct AdapterControlBlock *) host->hostdata;=0A=
+		(struct AdapterControlBlock *)host->hostdata;=0A=
 	return snprintf(buf, PAGE_SIZE,=0A=
 			"%4d\n",=0A=
 			acb->num_resets);=0A=
@@ -293,19 +334,19 @@ arcmsr_attr_host_driver_abort(struct dev=0A=
 {=0A=
 	struct Scsi_Host *host =3D class_to_shost(dev);=0A=
 	struct AdapterControlBlock *acb =3D=0A=
-		(struct AdapterControlBlock *) host->hostdata;=0A=
+		(struct AdapterControlBlock *)host->hostdata;=0A=
 	return snprintf(buf, PAGE_SIZE,=0A=
 			"%4d\n",=0A=
 			acb->num_aborts);=0A=
 }=0A=
 =0A=
 static ssize_t=0A=
-arcmsr_attr_host_fw_model(struct device *dev, struct device_attribute =
*attr,=0A=
-			  char *buf)=0A=
+arcmsr_attr_host_fw_model(struct device *dev,=0A=
+			struct device_attribute *attr, char *buf)=0A=
 {=0A=
 	struct Scsi_Host *host =3D class_to_shost(dev);=0A=
 	struct AdapterControlBlock *acb =3D=0A=
-		(struct AdapterControlBlock *) host->hostdata;=0A=
+		(struct AdapterControlBlock *)host->hostdata;=0A=
 	return snprintf(buf, PAGE_SIZE,=0A=
 			"%s\n",=0A=
 			acb->firm_model);=0A=
@@ -317,8 +358,7 @@ arcmsr_attr_host_fw_version(struct devic=0A=
 {=0A=
 	struct Scsi_Host *host =3D class_to_shost(dev);=0A=
 	struct AdapterControlBlock *acb =3D=0A=
-			(struct AdapterControlBlock *) host->hostdata;=0A=
-=0A=
+			(struct AdapterControlBlock *)host->hostdata;=0A=
 	return snprintf(buf, PAGE_SIZE,=0A=
 			"%s\n",=0A=
 			acb->firm_version);=0A=
@@ -330,7 +370,7 @@ arcmsr_attr_host_fw_request_len(struct d=0A=
 {=0A=
 	struct Scsi_Host *host =3D class_to_shost(dev);=0A=
 	struct AdapterControlBlock *acb =3D=0A=
-		(struct AdapterControlBlock *) host->hostdata;=0A=
+		(struct AdapterControlBlock *)host->hostdata;=0A=
 =0A=
 	return snprintf(buf, PAGE_SIZE,=0A=
 			"%4d\n",=0A=
@@ -343,7 +383,7 @@ arcmsr_attr_host_fw_numbers_queue(struct=0A=
 {=0A=
 	struct Scsi_Host *host =3D class_to_shost(dev);=0A=
 	struct AdapterControlBlock *acb =3D=0A=
-		(struct AdapterControlBlock *) host->hostdata;=0A=
+		(struct AdapterControlBlock *)host->hostdata;=0A=
 =0A=
 	return snprintf(buf, PAGE_SIZE,=0A=
 			"%4d\n",=0A=
@@ -356,7 +396,7 @@ arcmsr_attr_host_fw_sdram_size(struct de=0A=
 {=0A=
 	struct Scsi_Host *host =3D class_to_shost(dev);=0A=
 	struct AdapterControlBlock *acb =3D=0A=
-		(struct AdapterControlBlock *) host->hostdata;=0A=
+		(struct AdapterControlBlock *)host->hostdata;=0A=
 =0A=
 	return snprintf(buf, PAGE_SIZE,=0A=
 			"%4d\n",=0A=
@@ -369,23 +409,33 @@ arcmsr_attr_host_fw_hd_channels(struct d=0A=
 {=0A=
 	struct Scsi_Host *host =3D class_to_shost(dev);=0A=
 	struct AdapterControlBlock *acb =3D=0A=
-		(struct AdapterControlBlock *) host->hostdata;=0A=
+		(struct AdapterControlBlock *)host->hostdata;=0A=
 =0A=
 	return snprintf(buf, PAGE_SIZE,=0A=
 			"%4d\n",=0A=
 			acb->firm_hd_channels);=0A=
 }=0A=
 =0A=
-static DEVICE_ATTR(host_driver_version, S_IRUGO, =
arcmsr_attr_host_driver_version, NULL);=0A=
-static DEVICE_ATTR(host_driver_posted_cmd, S_IRUGO, =
arcmsr_attr_host_driver_posted_cmd, NULL);=0A=
-static DEVICE_ATTR(host_driver_reset, S_IRUGO, =
arcmsr_attr_host_driver_reset, NULL);=0A=
-static DEVICE_ATTR(host_driver_abort, S_IRUGO, =
arcmsr_attr_host_driver_abort, NULL);=0A=
-static DEVICE_ATTR(host_fw_model, S_IRUGO, arcmsr_attr_host_fw_model, =
NULL);=0A=
-static DEVICE_ATTR(host_fw_version, S_IRUGO, =
arcmsr_attr_host_fw_version, NULL);=0A=
-static DEVICE_ATTR(host_fw_request_len, S_IRUGO, =
arcmsr_attr_host_fw_request_len, NULL);=0A=
-static DEVICE_ATTR(host_fw_numbers_queue, S_IRUGO, =
arcmsr_attr_host_fw_numbers_queue, NULL);=0A=
-static DEVICE_ATTR(host_fw_sdram_size, S_IRUGO, =
arcmsr_attr_host_fw_sdram_size, NULL);=0A=
-static DEVICE_ATTR(host_fw_hd_channels, S_IRUGO, =
arcmsr_attr_host_fw_hd_channels, NULL);=0A=
+static DEVICE_ATTR(host_driver_version, S_IRUGO,=0A=
+	arcmsr_attr_host_driver_version, NULL);=0A=
+static DEVICE_ATTR(host_driver_posted_cmd, S_IRUGO,=0A=
+	arcmsr_attr_host_driver_posted_cmd, NULL);=0A=
+static DEVICE_ATTR(host_driver_reset, S_IRUGO,=0A=
+	arcmsr_attr_host_driver_reset, NULL);=0A=
+static DEVICE_ATTR(host_driver_abort, S_IRUGO,=0A=
+	arcmsr_attr_host_driver_abort, NULL);=0A=
+static DEVICE_ATTR(host_fw_model, S_IRUGO,=0A=
+	arcmsr_attr_host_fw_model, NULL);=0A=
+static DEVICE_ATTR(host_fw_version, S_IRUGO,=0A=
+	arcmsr_attr_host_fw_version, NULL);=0A=
+static DEVICE_ATTR(host_fw_request_len, S_IRUGO,=0A=
+	arcmsr_attr_host_fw_request_len, NULL);=0A=
+static DEVICE_ATTR(host_fw_numbers_queue, S_IRUGO,=0A=
+	arcmsr_attr_host_fw_numbers_queue, NULL);=0A=
+static DEVICE_ATTR(host_fw_sdram_size, S_IRUGO,=0A=
+	arcmsr_attr_host_fw_sdram_size, NULL);=0A=
+static DEVICE_ATTR(host_fw_hd_channels, S_IRUGO,=0A=
+	arcmsr_attr_host_fw_hd_channels, NULL);=0A=
 =0A=
 struct device_attribute *arcmsr_host_attrs[] =3D {=0A=
 	&dev_attr_host_driver_version,=0A=
diff -uprN a/drivers/scsi/arcmsr/arcmsr.h b/drivers/scsi/arcmsr/arcmsr.h=0A=
--- a/drivers/scsi/arcmsr/arcmsr.h	2013-07-01 06:13:28.000000000 +0800=0A=
+++ b/drivers/scsi/arcmsr/arcmsr.h	2013-08-28 22:43:30.000000000 +0800=0A=
@@ -45,42 +45,48 @@=0A=
 #include <linux/interrupt.h>=0A=
 struct device_attribute;=0A=
 /*The limit of outstanding scsi command that firmware can handle*/=0A=
-#define ARCMSR_MAX_OUTSTANDING_CMD						256=0A=
+#define ARCMSR_MAX_OUTSTANDING_CMD		256=0A=
 #ifdef CONFIG_XEN=0A=
 	#define ARCMSR_MAX_FREECCB_NUM	160=0A=
 #else=0A=
 	#define ARCMSR_MAX_FREECCB_NUM	320=0A=
 #endif=0A=
-#define ARCMSR_DRIVER_VERSION		     "Driver Version 1.20.00.15 =
2010/08/05"=0A=
-#define ARCMSR_SCSI_INITIATOR_ID						255=0A=
-#define ARCMSR_MAX_XFER_SECTORS							512=0A=
-#define ARCMSR_MAX_XFER_SECTORS_B						4096=0A=
-#define ARCMSR_MAX_XFER_SECTORS_C						304=0A=
-#define ARCMSR_MAX_TARGETID							17=0A=
-#define ARCMSR_MAX_TARGETLUN							8=0A=
-#define ARCMSR_MAX_CMD_PERLUN		                 =
ARCMSR_MAX_OUTSTANDING_CMD=0A=
-#define ARCMSR_MAX_QBUFFER							4096=0A=
-#define ARCMSR_DEFAULT_SG_ENTRIES						38=0A=
-#define ARCMSR_MAX_HBB_POSTQUEUE						264=0A=
-#define ARCMSR_MAX_XFER_LEN							0x26000 /* 152K */=0A=
-#define ARCMSR_CDB_SG_PAGE_LENGTH						256 =0A=
+#define ARCMSR_DRIVER_VERSION		"v1.30.00.03 2013/08/28"=0A=
+#define ARCMSR_SCSI_INITIATOR_ID		255=0A=
+#define ARCMSR_MAX_XFER_SECTORS		512=0A=
+#define ARCMSR_MAX_XFER_SECTORS_B		4096=0A=
+#define ARCMSR_MAX_XFER_SECTORS_C		304=0A=
+#define ARCMSR_MAX_TARGETID			17=0A=
+#define ARCMSR_MAX_TARGETLUN			8=0A=
+#define ARCMSR_MAX_CMD_PERLUN			ARCMSR_MAX_OUTSTANDING_CMD=0A=
+#define ARCMSR_MAX_QBUFFER			4096=0A=
+#define ARCMSR_DEFAULT_SG_ENTRIES		38=0A=
+#define ARCMSR_MAX_HBB_POSTQUEUE		264=0A=
+#define ARCMSR_MAX_ARC1214_POSTQUEUE		256=0A=
+#define ARCMSR_MAX_ARC1214_DONEQUEUE		257=0A=
+#define ARCMSR_MAX_XFER_LEN			0x26000=0A=
+#define ARCMSR_CDB_SG_PAGE_LENGTH		256=0A=
+#define ARCMST_NUM_MSIX_VECTORS		4=0A=
 #ifndef PCI_DEVICE_ID_ARECA_1880=0A=
-#define PCI_DEVICE_ID_ARECA_1880 0x1880=0A=
- #endif=0A=
+	#define PCI_DEVICE_ID_ARECA_1880	0x1880=0A=
+#endif=0A=
+#ifndef PCI_DEVICE_ID_ARECA_1214=0A=
+	#define PCI_DEVICE_ID_ARECA_1214	0x1214=0A=
+#endif=0A=
 /*=0A=
 =
*************************************************************************=
*********=0A=
 **=0A=
 =
*************************************************************************=
*********=0A=
 */=0A=
-#define ARC_SUCCESS                                                     =
  0=0A=
-#define ARC_FAILURE                                                     =
  1=0A=
+#define ARC_SUCCESS				0=0A=
+#define ARC_FAILURE				1=0A=
 /*=0A=
 =
*************************************************************************=
******=0A=
 **        split 64bits dma addressing=0A=
 =
*************************************************************************=
******=0A=
 */=0A=
-#define dma_addr_hi32(addr)               (uint32_t) ((addr>>16)>>16)=0A=
-#define dma_addr_lo32(addr)               (uint32_t) (addr & 0xffffffff)=0A=
+#define dma_addr_hi32(addr)	(uint32_t)((addr >> 16) >> 16)=0A=
+#define dma_addr_lo32(addr)	(uint32_t)(addr & 0xffffffff)=0A=
 /*=0A=
 =
*************************************************************************=
******=0A=
 **        MESSAGE CONTROL CODE=0A=
@@ -88,12 +94,12 @@ struct device_attribute;=0A=
 */=0A=
 struct CMD_MESSAGE=0A=
 {=0A=
-      uint32_t HeaderLength;=0A=
-      uint8_t  Signature[8];=0A=
-      uint32_t Timeout;=0A=
-      uint32_t ControlCode;=0A=
-      uint32_t ReturnCode;=0A=
-      uint32_t Length;=0A=
+	uint32_t HeaderLength;=0A=
+	uint8_t Signature[8];=0A=
+	uint32_t Timeout;=0A=
+	uint32_t ControlCode;=0A=
+	uint32_t ReturnCode;=0A=
+	uint32_t Length;=0A=
 };=0A=
 /*=0A=
 =
*************************************************************************=
******=0A=
@@ -102,8 +108,8 @@ struct CMD_MESSAGE=0A=
 */=0A=
 struct CMD_MESSAGE_FIELD=0A=
 {=0A=
-    struct CMD_MESSAGE			cmdmessage;=0A=
-    uint8_t				messagedatabuffer[1032];=0A=
+	struct CMD_MESSAGE cmdmessage;=0A=
+	uint8_t messagedatabuffer[1032];=0A=
 };=0A=
 /* IOP message transfer */=0A=
 #define ARCMSR_MESSAGE_FAIL			0x0001=0A=
@@ -111,57 +117,57 @@ struct CMD_MESSAGE_FIELD=0A=
 #define ARECA_SATA_RAID				0x90000000=0A=
 /* FunctionCode */=0A=
 #define FUNCTION_READ_RQBUFFER			0x0801=0A=
-#define FUNCTION_WRITE_WQBUFFER			0x0802=0A=
-#define FUNCTION_CLEAR_RQBUFFER			0x0803=0A=
-#define FUNCTION_CLEAR_WQBUFFER			0x0804=0A=
+#define FUNCTION_WRITE_WQBUFFER		0x0802=0A=
+#define FUNCTION_CLEAR_RQBUFFER		0x0803=0A=
+#define FUNCTION_CLEAR_WQBUFFER		0x0804=0A=
 #define FUNCTION_CLEAR_ALLQBUFFER		0x0805=0A=
-#define FUNCTION_RETURN_CODE_3F			0x0806=0A=
+#define FUNCTION_RETURN_CODE_3F		0x0806=0A=
 #define FUNCTION_SAY_HELLO			0x0807=0A=
 #define FUNCTION_SAY_GOODBYE			0x0808=0A=
 #define FUNCTION_FLUSH_ADAPTER_CACHE		0x0809=0A=
-#define FUNCTION_GET_FIRMWARE_STATUS			0x080A=0A=
-#define FUNCTION_HARDWARE_RESET			0x080B=0A=
+#define FUNCTION_GET_FIRMWARE_STATUS		0x080A=0A=
+#define FUNCTION_HARDWARE_RESET		0x080B=0A=
 /* ARECA IO CONTROL CODE*/=0A=
-#define ARCMSR_MESSAGE_READ_RQBUFFER       \=0A=
-	ARECA_SATA_RAID | FUNCTION_READ_RQBUFFER=0A=
-#define ARCMSR_MESSAGE_WRITE_WQBUFFER      \=0A=
-	ARECA_SATA_RAID | FUNCTION_WRITE_WQBUFFER=0A=
-#define ARCMSR_MESSAGE_CLEAR_RQBUFFER      \=0A=
-	ARECA_SATA_RAID | FUNCTION_CLEAR_RQBUFFER=0A=
-#define ARCMSR_MESSAGE_CLEAR_WQBUFFER      \=0A=
-	ARECA_SATA_RAID | FUNCTION_CLEAR_WQBUFFER=0A=
-#define ARCMSR_MESSAGE_CLEAR_ALLQBUFFER    \=0A=
-	ARECA_SATA_RAID | FUNCTION_CLEAR_ALLQBUFFER=0A=
-#define ARCMSR_MESSAGE_RETURN_CODE_3F      \=0A=
-	ARECA_SATA_RAID | FUNCTION_RETURN_CODE_3F=0A=
-#define ARCMSR_MESSAGE_SAY_HELLO           \=0A=
-	ARECA_SATA_RAID | FUNCTION_SAY_HELLO=0A=
-#define ARCMSR_MESSAGE_SAY_GOODBYE         \=0A=
-	ARECA_SATA_RAID | FUNCTION_SAY_GOODBYE=0A=
-#define ARCMSR_MESSAGE_FLUSH_ADAPTER_CACHE \=0A=
-	ARECA_SATA_RAID | FUNCTION_FLUSH_ADAPTER_CACHE=0A=
+#define ARCMSR_MESSAGE_READ_RQBUFFER		\=0A=
+	(ARECA_SATA_RAID | FUNCTION_READ_RQBUFFER)=0A=
+#define ARCMSR_MESSAGE_WRITE_WQBUFFER	\=0A=
+	(ARECA_SATA_RAID | FUNCTION_WRITE_WQBUFFER)=0A=
+#define ARCMSR_MESSAGE_CLEAR_RQBUFFER	\=0A=
+	(ARECA_SATA_RAID | FUNCTION_CLEAR_RQBUFFER)=0A=
+#define ARCMSR_MESSAGE_CLEAR_WQBUFFER	\=0A=
+	(ARECA_SATA_RAID | FUNCTION_CLEAR_WQBUFFER)=0A=
+#define ARCMSR_MESSAGE_CLEAR_ALLQBUFFER	\=0A=
+	(ARECA_SATA_RAID | FUNCTION_CLEAR_ALLQBUFFER)=0A=
+#define ARCMSR_MESSAGE_RETURN_CODE_3F	\=0A=
+	(ARECA_SATA_RAID | FUNCTION_RETURN_CODE_3F)=0A=
+#define ARCMSR_MESSAGE_SAY_HELLO		\=0A=
+	(ARECA_SATA_RAID | FUNCTION_SAY_HELLO)=0A=
+#define ARCMSR_MESSAGE_SAY_GOODBYE		\=0A=
+	(ARECA_SATA_RAID | FUNCTION_SAY_GOODBYE)=0A=
+#define ARCMSR_MESSAGE_FLUSH_ADAPTER_CACHE	\=0A=
+	(ARECA_SATA_RAID | FUNCTION_FLUSH_ADAPTER_CACHE)=0A=
 /* ARECA IOCTL ReturnCode */=0A=
-#define ARCMSR_MESSAGE_RETURNCODE_OK		0x00000001=0A=
+#define ARCMSR_MESSAGE_RETURNCODE_OK			0x00000001=0A=
 #define ARCMSR_MESSAGE_RETURNCODE_ERROR		0x00000006=0A=
-#define ARCMSR_MESSAGE_RETURNCODE_3F		0x0000003F=0A=
+#define ARCMSR_MESSAGE_RETURNCODE_3F			0x0000003F=0A=
 #define ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON	0x00000088=0A=
 /*=0A=
 *************************************************************=0A=
 **   structure for holding DMA address data=0A=
 *************************************************************=0A=
 */=0A=
-#define IS_DMA64			(sizeof(dma_addr_t) =3D=3D 8)=0A=
-#define IS_SG64_ADDR                0x01000000 /* bit24 */=0A=
+#define IS_DMA64		(sizeof(dma_addr_t) =3D=3D 8)=0A=
+#define IS_SG64_ADDR	0x01000000 /* bit24 */=0A=
 struct  SG32ENTRY=0A=
 {=0A=
-	__le32					length;=0A=
-	__le32					address;=0A=
+	__le32 length;=0A=
+	__le32 address;=0A=
 }__attribute__ ((packed));=0A=
 struct  SG64ENTRY=0A=
 {=0A=
-	__le32					length;=0A=
-	__le32					address;=0A=
-	__le32					addresshigh;=0A=
+	__le32 length;=0A=
+	__le32 address;=0A=
+	__le32 addresshigh;=0A=
 }__attribute__ ((packed));=0A=
 /*=0A=
 ********************************************************************=0A=
@@ -170,8 +176,8 @@ struct  SG64ENTRY=0A=
 */=0A=
 struct QBUFFER=0A=
 {=0A=
-	uint32_t      data_len;=0A=
-	uint8_t       data[124];=0A=
+	uint32_t data_len;=0A=
+	uint8_t data[124];=0A=
 };=0A=
 /*=0A=
 =
*************************************************************************=
******=0A=
@@ -180,50 +186,50 @@ struct QBUFFER=0A=
 */=0A=
 struct FIRMWARE_INFO=0A=
 {=0A=
-	uint32_t      signature;		/*0, 00-03*/=0A=
-	uint32_t      request_len;		/*1, 04-07*/=0A=
-	uint32_t      numbers_queue;		/*2, 08-11*/=0A=
-	uint32_t      sdram_size;               /*3, 12-15*/=0A=
-	uint32_t      ide_channels;		/*4, 16-19*/=0A=
-	char          vendor[40];		/*5, 20-59*/=0A=
-	char          model[8];			/*15, 60-67*/=0A=
-	char          firmware_ver[16];     	/*17, 68-83*/=0A=
-	char          device_map[16];		/*21, 84-99*/=0A=
-	uint32_t		cfgVersion;               	/*25,100-103 Added for checking =
of new firmware capability*/=0A=
-	uint8_t		cfgSerial[16];           	/*26,104-119*/=0A=
-	uint32_t		cfgPicStatus;            	/*30,120-123*/	=0A=
+	uint32_t signature;	/*0, 00-03*/=0A=
+	uint32_t request_len;	/*1, 04-07*/=0A=
+	uint32_t numbers_queue;	/*2, 08-11*/=0A=
+	uint32_t sdram_size;	/*3, 12-15*/=0A=
+	uint32_t ide_channels;	/*4, 16-19*/=0A=
+	char vendor[40];		/*5, 20-59*/=0A=
+	char model[8];		/*15, 60-67*/=0A=
+	char firmware_ver[16];	/*17, 68-83*/=0A=
+	char device_map[16];	/*21, 84-99*/=0A=
+	uint32_t cfgVersion;	/*25, 100-103*/=0A=
+	uint8_t cfgSerial[16];	/*26, 104-119*/=0A=
+	uint32_t cfgPicStatus;	/*30, 120-123*/=0A=
 };=0A=
 /* signature of set and get firmware config */=0A=
-#define ARCMSR_SIGNATURE_GET_CONFIG		      0x87974060=0A=
-#define ARCMSR_SIGNATURE_SET_CONFIG		      0x87974063=0A=
+#define ARCMSR_SIGNATURE_GET_CONFIG		0x87974060=0A=
+#define ARCMSR_SIGNATURE_SET_CONFIG		0x87974063=0A=
 /* message code of inbound message register */=0A=
-#define ARCMSR_INBOUND_MESG0_NOP		      0x00000000=0A=
-#define ARCMSR_INBOUND_MESG0_GET_CONFIG		      0x00000001=0A=
-#define ARCMSR_INBOUND_MESG0_SET_CONFIG               0x00000002=0A=
-#define ARCMSR_INBOUND_MESG0_ABORT_CMD                0x00000003=0A=
-#define ARCMSR_INBOUND_MESG0_STOP_BGRB                0x00000004=0A=
-#define ARCMSR_INBOUND_MESG0_FLUSH_CACHE              0x00000005=0A=
-#define ARCMSR_INBOUND_MESG0_START_BGRB               0x00000006=0A=
-#define ARCMSR_INBOUND_MESG0_CHK331PENDING            0x00000007=0A=
-#define ARCMSR_INBOUND_MESG0_SYNC_TIMER               0x00000008=0A=
+#define ARCMSR_INBOUND_MESG0_NOP		0x00000000=0A=
+#define ARCMSR_INBOUND_MESG0_GET_CONFIG	0x00000001=0A=
+#define ARCMSR_INBOUND_MESG0_SET_CONFIG	0x00000002=0A=
+#define ARCMSR_INBOUND_MESG0_ABORT_CMD	0x00000003=0A=
+#define ARCMSR_INBOUND_MESG0_STOP_BGRB	0x00000004=0A=
+#define ARCMSR_INBOUND_MESG0_FLUSH_CACHE	0x00000005=0A=
+#define ARCMSR_INBOUND_MESG0_START_BGRB	0x00000006=0A=
+#define ARCMSR_INBOUND_MESG0_CHK331PENDING	0x00000007=0A=
+#define ARCMSR_INBOUND_MESG0_SYNC_TIMER	0x00000008=0A=
 /* doorbell interrupt generator */=0A=
-#define ARCMSR_INBOUND_DRIVER_DATA_WRITE_OK           0x00000001=0A=
-#define ARCMSR_INBOUND_DRIVER_DATA_READ_OK            0x00000002=0A=
-#define ARCMSR_OUTBOUND_IOP331_DATA_WRITE_OK          0x00000001=0A=
-#define ARCMSR_OUTBOUND_IOP331_DATA_READ_OK           0x00000002=0A=
+#define ARCMSR_INBOUND_DRIVER_DATA_WRITE_OK	0x00000001=0A=
+#define ARCMSR_INBOUND_DRIVER_DATA_READ_OK	0x00000002=0A=
+#define ARCMSR_OUTBOUND_IOP331_DATA_WRITE_OK	0x00000001=0A=
+#define ARCMSR_OUTBOUND_IOP331_DATA_READ_OK	0x00000002=0A=
 /* ccb areca cdb flag */=0A=
-#define ARCMSR_CCBPOST_FLAG_SGL_BSIZE                 0x80000000=0A=
-#define ARCMSR_CCBPOST_FLAG_IAM_BIOS                  0x40000000=0A=
-#define ARCMSR_CCBREPLY_FLAG_IAM_BIOS                 0x40000000=0A=
-#define ARCMSR_CCBREPLY_FLAG_ERROR_MODE0              0x10000000=0A=
-#define ARCMSR_CCBREPLY_FLAG_ERROR_MODE1              0x00000001=0A=
+#define ARCMSR_CCBPOST_FLAG_SGL_BSIZE		0x80000000=0A=
+#define ARCMSR_CCBPOST_FLAG_IAM_BIOS		0x40000000=0A=
+#define ARCMSR_CCBREPLY_FLAG_IAM_BIOS		0x40000000=0A=
+#define ARCMSR_CCBREPLY_FLAG_ERROR_MODE0	0x10000000=0A=
+#define ARCMSR_CCBREPLY_FLAG_ERROR_MODE1	0x00000001=0A=
 /* outbound firmware ok */=0A=
-#define ARCMSR_OUTBOUND_MESG1_FIRMWARE_OK             0x80000000=0A=
+#define ARCMSR_OUTBOUND_MESG1_FIRMWARE_OK	0x80000000=0A=
 /* ARC-1680 Bus Reset*/=0A=
-#define ARCMSR_ARC1680_BUS_RESET				0x00000003=0A=
+#define ARCMSR_ARC1680_BUS_RESET		0x00000003=0A=
 /* ARC-1880 Bus Reset*/=0A=
-#define ARCMSR_ARC1880_RESET_ADAPTER				0x00000024=0A=
-#define ARCMSR_ARC1880_DiagWrite_ENABLE			0x00000080=0A=
+#define ARCMSR_ARC1880_RESET_ADAPTER		0x00000024=0A=
+#define ARCMSR_ARC1880_DiagWrite_ENABLE	0x00000080=0A=
 =0A=
 /*=0A=
 ************************************************************************=0A=
@@ -232,98 +238,101 @@ struct FIRMWARE_INFO=0A=
 */=0A=
 /* ARECA HBB COMMAND for its FIRMWARE */=0A=
 /* window of "instruction flags" from driver to iop */=0A=
-#define ARCMSR_DRV2IOP_DOORBELL                       0x00020400=0A=
-#define ARCMSR_DRV2IOP_DOORBELL_MASK                  0x00020404=0A=
+#define ARCMSR_DRV2IOP_DOORBELL		0x00020400=0A=
+#define ARCMSR_DRV2IOP_DOORBELL_MASK		0x00020404=0A=
 /* window of "instruction flags" from iop to driver */=0A=
-#define ARCMSR_IOP2DRV_DOORBELL                       0x00020408=0A=
-#define ARCMSR_IOP2DRV_DOORBELL_MASK                  0x0002040C=0A=
+#define ARCMSR_IOP2DRV_DOORBELL		0x00020408=0A=
+#define ARCMSR_IOP2DRV_DOORBELL_MASK		0x0002040C=0A=
 /* ARECA FLAG LANGUAGE */=0A=
 /* ioctl transfer */=0A=
-#define ARCMSR_IOP2DRV_DATA_WRITE_OK                  0x00000001=0A=
+#define ARCMSR_IOP2DRV_DATA_WRITE_OK		0x00000001=0A=
 /* ioctl transfer */=0A=
-#define ARCMSR_IOP2DRV_DATA_READ_OK                   0x00000002=0A=
-#define ARCMSR_IOP2DRV_CDB_DONE                       0x00000004=0A=
-#define ARCMSR_IOP2DRV_MESSAGE_CMD_DONE               0x00000008=0A=
-=0A=
-#define ARCMSR_DOORBELL_HANDLE_INT		      0x0000000F=0A=
-#define ARCMSR_DOORBELL_INT_CLEAR_PATTERN   	      0xFF00FFF0=0A=
-#define ARCMSR_MESSAGE_INT_CLEAR_PATTERN	      0xFF00FFF7=0A=
+#define ARCMSR_IOP2DRV_DATA_READ_OK		0x00000002=0A=
+#define ARCMSR_IOP2DRV_CDB_DONE		0x00000004=0A=
+#define ARCMSR_IOP2DRV_MESSAGE_CMD_DONE	0x00000008=0A=
+=0A=
+#define ARCMSR_DOORBELL_HANDLE_INT		0x0000000F=0A=
+#define ARCMSR_DOORBELL_INT_CLEAR_PATTERN	0xFF00FFF0=0A=
+#define ARCMSR_MESSAGE_INT_CLEAR_PATTERN	0xFF00FFF7=0A=
 /* =
(ARCMSR_INBOUND_MESG0_GET_CONFIG<<16)|ARCMSR_DRV2IOP_MESSAGE_CMD_POSTED) =
*/=0A=
-#define ARCMSR_MESSAGE_GET_CONFIG		      0x00010008=0A=
+#define ARCMSR_MESSAGE_GET_CONFIG		0x00010008=0A=
 /* =
(ARCMSR_INBOUND_MESG0_SET_CONFIG<<16)|ARCMSR_DRV2IOP_MESSAGE_CMD_POSTED) =
*/=0A=
-#define ARCMSR_MESSAGE_SET_CONFIG		      0x00020008=0A=
+#define ARCMSR_MESSAGE_SET_CONFIG		0x00020008=0A=
 /* =
(ARCMSR_INBOUND_MESG0_ABORT_CMD<<16)|ARCMSR_DRV2IOP_MESSAGE_CMD_POSTED) =
*/=0A=
-#define ARCMSR_MESSAGE_ABORT_CMD		      0x00030008=0A=
+#define ARCMSR_MESSAGE_ABORT_CMD		0x00030008=0A=
 /* =
(ARCMSR_INBOUND_MESG0_STOP_BGRB<<16)|ARCMSR_DRV2IOP_MESSAGE_CMD_POSTED) =
*/=0A=
-#define ARCMSR_MESSAGE_STOP_BGRB		      0x00040008=0A=
+#define ARCMSR_MESSAGE_STOP_BGRB		0x00040008=0A=
 /* =
(ARCMSR_INBOUND_MESG0_FLUSH_CACHE<<16)|ARCMSR_DRV2IOP_MESSAGE_CMD_POSTED)=
 */=0A=
-#define ARCMSR_MESSAGE_FLUSH_CACHE                    0x00050008=0A=
+#define ARCMSR_MESSAGE_FLUSH_CACHE		0x00050008=0A=
 /* =
(ARCMSR_INBOUND_MESG0_START_BGRB<<16)|ARCMSR_DRV2IOP_MESSAGE_CMD_POSTED) =
*/=0A=
-#define ARCMSR_MESSAGE_START_BGRB		      0x00060008=0A=
-#define ARCMSR_MESSAGE_START_DRIVER_MODE	      0x000E0008=0A=
-#define ARCMSR_MESSAGE_SET_POST_WINDOW		      0x000F0008=0A=
-#define ARCMSR_MESSAGE_ACTIVE_EOI_MODE		    0x00100008=0A=
+#define ARCMSR_MESSAGE_START_BGRB		0x00060008=0A=
+#define ARCMSR_MESSAGE_START_DRIVER_MODE	0x000E0008=0A=
+#define ARCMSR_MESSAGE_SET_POST_WINDOW	0x000F0008=0A=
+#define ARCMSR_MESSAGE_ACTIVE_EOI_MODE	0x00100008=0A=
 /* ARCMSR_OUTBOUND_MESG1_FIRMWARE_OK */=0A=
-#define ARCMSR_MESSAGE_FIRMWARE_OK		      0x80000000=0A=
+#define ARCMSR_MESSAGE_FIRMWARE_OK		0x80000000=0A=
 /* ioctl transfer */=0A=
-#define ARCMSR_DRV2IOP_DATA_WRITE_OK                  0x00000001=0A=
+#define ARCMSR_DRV2IOP_DATA_WRITE_OK		0x00000001=0A=
 /* ioctl transfer */=0A=
-#define ARCMSR_DRV2IOP_DATA_READ_OK                   0x00000002=0A=
-#define ARCMSR_DRV2IOP_CDB_POSTED                     0x00000004=0A=
-#define ARCMSR_DRV2IOP_MESSAGE_CMD_POSTED             0x00000008=0A=
-#define ARCMSR_DRV2IOP_END_OF_INTERRUPT		0x00000010=0A=
+#define ARCMSR_DRV2IOP_DATA_READ_OK		0x00000002=0A=
+#define ARCMSR_DRV2IOP_CDB_POSTED		0x00000004=0A=
+#define ARCMSR_DRV2IOP_MESSAGE_CMD_POSTED	0x00000008=0A=
+#define ARCMSR_DRV2IOP_END_OF_INTERRUPT	0x00000010=0A=
 =0A=
 /* data tunnel buffer between user space program and its firmware */=0A=
 /* user space data to iop 128bytes */=0A=
-#define ARCMSR_MESSAGE_WBUFFER			      0x0000fe00=0A=
+#define ARCMSR_MESSAGE_WBUFFER		0x0000fe00=0A=
 /* iop data to user space 128bytes */=0A=
-#define ARCMSR_MESSAGE_RBUFFER			      0x0000ff00=0A=
+#define ARCMSR_MESSAGE_RBUFFER		0x0000ff00=0A=
 /* iop message_rwbuffer for message command */=0A=
-#define ARCMSR_MESSAGE_RWBUFFER			      0x0000fa00=0A=
+#define ARCMSR_MESSAGE_RWBUFFER		0x0000fa00=0A=
 /* =0A=
 ************************************************************************=0A=
 **                SPEC. for Areca HBC adapter=0A=
 ************************************************************************=0A=
 */=0A=
-#define ARCMSR_HBC_ISR_THROTTLING_LEVEL		12=0A=
-#define ARCMSR_HBC_ISR_MAX_DONE_QUEUE		20=0A=
+#define ARCMSR_HBC_ISR_THROTTLING_LEVEL	12=0A=
+#define ARCMSR_HBC_ISR_MAX_DONE_QUEUE	20=0A=
 /* Host Interrupt Mask */=0A=
-#define ARCMSR_HBCMU_UTILITY_A_ISR_MASK		0x00000001 /* When clear, the =
Utility_A interrupt routes to the host.*/=0A=
-#define ARCMSR_HBCMU_OUTBOUND_DOORBELL_ISR_MASK	0x00000004 /* When =
clear, the General Outbound Doorbell interrupt routes to the host.*/=0A=
-#define ARCMSR_HBCMU_OUTBOUND_POSTQUEUE_ISR_MASK	0x00000008 /* When =
clear, the Outbound Post List FIFO Not Empty interrupt routes to the =
host.*/=0A=
-#define ARCMSR_HBCMU_ALL_INTMASKENABLE		0x0000000D /* disable all ISR */=0A=
+#define ARCMSR_HBCMU_UTILITY_A_ISR_MASK		0x00000001=0A=
+#define ARCMSR_HBCMU_OUTBOUND_DOORBELL_ISR_MASK	0x00000004=0A=
+#define ARCMSR_HBCMU_OUTBOUND_POSTQUEUE_ISR_MASK	0x00000008=0A=
+#define ARCMSR_HBCMU_ALL_INTMASKENABLE		0x0000000D=0A=
 /* Host Interrupt Status */=0A=
 #define ARCMSR_HBCMU_UTILITY_A_ISR			0x00000001=0A=
-	/*=0A=
-	** Set when the Utility_A Interrupt bit is set in the Outbound =
Doorbell Register.=0A=
-	** It clears by writing a 1 to the Utility_A bit in the Outbound =
Doorbell Clear Register or through automatic clearing (if enabled).=0A=
-	*/=0A=
+/*=0A=
+** Set when the Utility_A Interrupt bit is set=0A=
+** in the Outbound Doorbell Register.=0A=
+** It clears by writing a 1 to the Utility_A=0A=
+** bit in the Outbound Doorbell Clear Register=0A=
+** or through automatic clearing (if enabled).=0A=
+*/=0A=
 #define ARCMSR_HBCMU_OUTBOUND_DOORBELL_ISR		0x00000004=0A=
-	/*=0A=
-	** Set if Outbound Doorbell register bits 30:1 have a non-zero=0A=
-	** value. This bit clears only when Outbound Doorbell bits=0A=
-	** 30:1 are ALL clear. Only a write to the Outbound Doorbell=0A=
-	** Clear register clears bits in the Outbound Doorbell register.=0A=
-	*/=0A=
+/*=0A=
+** Set if Outbound Doorbell register bits 30:1 have a non-zero=0A=
+** value. This bit clears only when Outbound Doorbell bits=0A=
+** 30:1 are ALL clear. Only a write to the Outbound Doorbell=0A=
+** Clear register clears bits in the Outbound Doorbell register.=0A=
+*/=0A=
 #define ARCMSR_HBCMU_OUTBOUND_POSTQUEUE_ISR	0x00000008=0A=
-	/*=0A=
-	** Set whenever the Outbound Post List Producer/Consumer=0A=
-	** Register (FIFO) is not empty. It clears when the Outbound=0A=
-	** Post List FIFO is empty.=0A=
-	*/=0A=
+/*=0A=
+** Set whenever the Outbound Post List Producer/Consumer=0A=
+** Register (FIFO) is not empty. It clears when the Outbound=0A=
+** Post List FIFO is empty.=0A=
+*/=0A=
 #define ARCMSR_HBCMU_SAS_ALL_INT			0x00000010=0A=
-	/*=0A=
-	** This bit indicates a SAS interrupt from a source external to=0A=
-	** the PCIe core. This bit is not maskable.=0A=
-	*/=0A=
-	/* DoorBell*/=0A=
-#define ARCMSR_HBCMU_DRV2IOP_DATA_WRITE_OK			0x00000002=0A=
-#define ARCMSR_HBCMU_DRV2IOP_DATA_READ_OK			0x00000004=0A=
+/*=0A=
+** This bit indicates a SAS interrupt from a source external to=0A=
+** the PCIe core. This bit is not maskable.=0A=
+*/=0A=
+/* DoorBell*/=0A=
+#define ARCMSR_HBCMU_DRV2IOP_DATA_WRITE_OK		0x00000002=0A=
+#define ARCMSR_HBCMU_DRV2IOP_DATA_READ_OK		0x00000004=0A=
 	/*inbound message 0 ready*/=0A=
-#define ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE		0x00000008=0A=
+#define ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE	0x00000008=0A=
 	/*more than 12 request completed in a time*/=0A=
-#define ARCMSR_HBCMU_DRV2IOP_POSTQUEUE_THROTTLING		0x00000010=0A=
-#define ARCMSR_HBCMU_IOP2DRV_DATA_WRITE_OK			0x00000002=0A=
+#define ARCMSR_HBCMU_DRV2IOP_POSTQUEUE_THROTTLING	0x00000010=0A=
+#define ARCMSR_HBCMU_IOP2DRV_DATA_WRITE_OK		0x00000002=0A=
 	/*outbound DATA WRITE isr door bell clear*/=0A=
 #define ARCMSR_HBCMU_IOP2DRV_DATA_WRITE_DOORBELL_CLEAR	0x00000002=0A=
 #define ARCMSR_HBCMU_IOP2DRV_DATA_READ_OK			0x00000004=0A=
@@ -337,40 +346,89 @@ struct FIRMWARE_INFO=0A=
 #define ARCMSR_HBCMU_MESSAGE_FIRMWARE_OK			0x80000000=0A=
 /*=0A=
 =
*************************************************************************=
******=0A=
+**                SPEC. for Areca Type D adapter=0A=
+************************************************************************=
*******=0A=
+*/=0A=
+#define ARCMSR_ARC1214_CHIP_ID					0x00004=0A=
+#define ARCMSR_ARC1214_CPU_MEMORY_CONFIGURATION		0x00008=0A=
+#define ARCMSR_ARC1214_I2_HOST_INTERRUPT_MASK		0x00034=0A=
+#define ARCMSR_ARC1214_SAMPLE_RESET				0x00100=0A=
+#define ARCMSR_ARC1214_RESET_REQUEST				0x00108=0A=
+#define ARCMSR_ARC1214_MAIN_INTERRUPT_STATUS			0x00200=0A=
+#define ARCMSR_ARC1214_PCIE_F0_INTERRUPT_ENABLE		0x0020C=0A=
+#define ARCMSR_ARC1214_INBOUND_MESSAGE0			0x00400=0A=
+#define ARCMSR_ARC1214_INBOUND_MESSAGE1			0x00404=0A=
+#define ARCMSR_ARC1214_OUTBOUND_MESSAGE0			0x00420=0A=
+#define ARCMSR_ARC1214_OUTBOUND_MESSAGE1			0x00424=0A=
+#define ARCMSR_ARC1214_INBOUND_DOORBELL			0x00460=0A=
+#define ARCMSR_ARC1214_OUTBOUND_DOORBELL			0x00480=0A=
+#define ARCMSR_ARC1214_OUTBOUND_DOORBELL_ENABLE		0x00484=0A=
+#define ARCMSR_ARC1214_INBOUND_LIST_BASE_LOW		0x01000=0A=
+#define ARCMSR_ARC1214_INBOUND_LIST_BASE_HIGH		0x01004=0A=
+#define ARCMSR_ARC1214_INBOUND_LIST_WRITE_POINTER		0x01018=0A=
+#define ARCMSR_ARC1214_OUTBOUND_LIST_BASE_LOW		0x01060=0A=
+#define ARCMSR_ARC1214_OUTBOUND_LIST_BASE_HIGH		0x01064=0A=
+#define ARCMSR_ARC1214_OUTBOUND_LIST_COPY_POINTER		0x0106C=0A=
+#define ARCMSR_ARC1214_OUTBOUND_LIST_READ_POINTER		0x01070=0A=
+#define ARCMSR_ARC1214_OUTBOUND_INTERRUPT_CAUSE		0x01088=0A=
+#define ARCMSR_ARC1214_OUTBOUND_INTERRUPT_ENABLE		0x0108C=0A=
+#define ARCMSR_ARC1214_MESSAGE_WBUFFER			0x02000=0A=
+#define ARCMSR_ARC1214_MESSAGE_RBUFFER			0x02100=0A=
+#define ARCMSR_ARC1214_MESSAGE_RWBUFFER			0x02200=0A=
+/* Host Interrupt Mask */=0A=
+#define ARCMSR_ARC1214_ALL_INT_ENABLE				0x00001010=0A=
+#define ARCMSR_ARC1214_ALL_INT_DISABLE			0x00000000=0A=
+/* Host Interrupt Status */=0A=
+#define ARCMSR_ARC1214_OUTBOUND_DOORBELL_ISR		0x00001000=0A=
+#define ARCMSR_ARC1214_OUTBOUND_POSTQUEUE_ISR		0x00000010=0A=
+/* DoorBell*/=0A=
+#define ARCMSR_ARC1214_DRV2IOP_DATA_IN_READY			0x00000001=0A=
+#define ARCMSR_ARC1214_DRV2IOP_DATA_OUT_READ		0x00000002=0A=
+/*inbound message 0 ready*/=0A=
+#define ARCMSR_ARC1214_IOP2DRV_DATA_WRITE_OK		0x00000001=0A=
+/*outbound DATA WRITE isr door bell clear*/=0A=
+#define ARCMSR_ARC1214_IOP2DRV_DATA_READ_OK			0x00000002=0A=
+/*outbound message 0 ready*/=0A=
+#define ARCMSR_ARC1214_IOP2DRV_MESSAGE_CMD_DONE		0x02000000=0A=
+/*outbound message cmd isr door bell clear*/=0A=
+/*ARCMSR_HBAMU_MESSAGE_FIRMWARE_OK*/=0A=
+#define ARCMSR_ARC1214_MESSAGE_FIRMWARE_OK			0x80000000=0A=
+#define ARCMSR_ARC1214_OUTBOUND_LIST_INTERRUPT_CLEAR	0x00000001=0A=
+/*=0A=
+************************************************************************=
*******=0A=
 **    ARECA SCSI COMMAND DESCRIPTOR BLOCK size 0x1F8 (504)=0A=
 =
*************************************************************************=
******=0A=
 */=0A=
 struct ARCMSR_CDB=0A=
 {=0A=
-	uint8_t							Bus;=0A=
-	uint8_t							TargetID;=0A=
-	uint8_t							LUN;=0A=
-	uint8_t							Function;=0A=
-	uint8_t							CdbLength;=0A=
-	uint8_t							sgcount;=0A=
-	uint8_t							Flags;=0A=
-#define ARCMSR_CDB_FLAG_SGL_BSIZE          0x01=0A=
-#define ARCMSR_CDB_FLAG_BIOS               0x02=0A=
-#define ARCMSR_CDB_FLAG_WRITE              0x04=0A=
-#define ARCMSR_CDB_FLAG_SIMPLEQ            0x00=0A=
-#define ARCMSR_CDB_FLAG_HEADQ              0x08=0A=
-#define ARCMSR_CDB_FLAG_ORDEREDQ           0x10=0A=
-=0A=
-	uint8_t							msgPages;=0A=
-	uint32_t						Context;=0A=
-	uint32_t						DataLength;=0A=
-	uint8_t							Cdb[16];=0A=
-	uint8_t							DeviceStatus;=0A=
-#define ARCMSR_DEV_CHECK_CONDITION	    0x02=0A=
-#define ARCMSR_DEV_SELECT_TIMEOUT	    0xF0=0A=
-#define ARCMSR_DEV_ABORTED		    0xF1=0A=
-#define ARCMSR_DEV_INIT_FAIL		    0xF2=0A=
-=0A=
-	uint8_t							SenseData[15];=0A=
-	union=0A=
-	{=0A=
-		struct SG32ENTRY                sg32entry[1];=0A=
-		struct SG64ENTRY                sg64entry[1];=0A=
+	uint8_t Bus;=0A=
+	uint8_t TargetID;=0A=
+	uint8_t LUN;=0A=
+	uint8_t Function;=0A=
+	uint8_t CdbLength;=0A=
+	uint8_t sgcount;=0A=
+	uint8_t Flags;=0A=
+#define ARCMSR_CDB_FLAG_SGL_BSIZE	0x01=0A=
+#define ARCMSR_CDB_FLAG_BIOS		0x02=0A=
+#define ARCMSR_CDB_FLAG_WRITE		0x04=0A=
+#define ARCMSR_CDB_FLAG_SIMPLEQ	0x00=0A=
+#define ARCMSR_CDB_FLAG_HEADQ		0x08=0A=
+#define ARCMSR_CDB_FLAG_ORDEREDQ	0x10=0A=
+=0A=
+	uint8_t msgPages;=0A=
+	uint32_t msgContext;=0A=
+	uint32_t DataLength;=0A=
+	uint8_t Cdb[16];=0A=
+	uint8_t DeviceStatus;=0A=
+#define ARCMSR_DEV_CHECK_CONDITION	0x02=0A=
+#define ARCMSR_DEV_SELECT_TIMEOUT	0xF0=0A=
+#define ARCMSR_DEV_ABORTED		0xF1=0A=
+#define ARCMSR_DEV_INIT_FAIL		0xF2=0A=
+=0A=
+	uint8_t SenseData[15];=0A=
+	union {=0A=
+		struct SG32ENTRY sg32entry[1];=0A=
+		struct SG64ENTRY sg64entry[1];=0A=
 	} u;=0A=
 };=0A=
 /*=0A=
@@ -380,118 +438,162 @@ struct ARCMSR_CDB=0A=
 */=0A=
 struct MessageUnit_A=0A=
 {=0A=
-	uint32_t	resrved0[4];			/*0000 000F*/=0A=
-	uint32_t	inbound_msgaddr0;		/*0010 0013*/=0A=
-	uint32_t	inbound_msgaddr1;		/*0014 0017*/=0A=
-	uint32_t	outbound_msgaddr0;		/*0018 001B*/=0A=
-	uint32_t	outbound_msgaddr1;		/*001C 001F*/=0A=
-	uint32_t	inbound_doorbell;		/*0020 0023*/=0A=
-	uint32_t	inbound_intstatus;		/*0024 0027*/=0A=
-	uint32_t	inbound_intmask;		/*0028 002B*/=0A=
-	uint32_t	outbound_doorbell;		/*002C 002F*/=0A=
-	uint32_t	outbound_intstatus;		/*0030 0033*/=0A=
-	uint32_t	outbound_intmask;		/*0034 0037*/=0A=
-	uint32_t	reserved1[2];			/*0038 003F*/=0A=
-	uint32_t	inbound_queueport;		/*0040 0043*/=0A=
-	uint32_t	outbound_queueport;     	/*0044 0047*/=0A=
-	uint32_t	reserved2[2];			/*0048 004F*/=0A=
-	uint32_t	reserved3[492];			/*0050 07FF 492*/=0A=
-	uint32_t	reserved4[128];			/*0800 09FF 128*/=0A=
-	uint32_t	message_rwbuffer[256];		/*0a00 0DFF 256*/=0A=
-	uint32_t	message_wbuffer[32];		/*0E00 0E7F  32*/=0A=
-	uint32_t	reserved5[32];			/*0E80 0EFF  32*/=0A=
-	uint32_t	message_rbuffer[32];		/*0F00 0F7F  32*/=0A=
-	uint32_t	reserved6[32];			/*0F80 0FFF  32*/=0A=
+	uint32_t resrved0[4];		/*0000 000F*/=0A=
+	uint32_t inbound_msgaddr0;	/*0010 0013*/=0A=
+	uint32_t inbound_msgaddr1;	/*0014 0017*/=0A=
+	uint32_t outbound_msgaddr0;	/*0018 001B*/=0A=
+	uint32_t outbound_msgaddr1;	/*001C 001F*/=0A=
+	uint32_t inbound_doorbell;		/*0020 0023*/=0A=
+	uint32_t inbound_intstatus;		/*0024 0027*/=0A=
+	uint32_t inbound_intmask;		/*0028 002B*/=0A=
+	uint32_t outbound_doorbell;	/*002C 002F*/=0A=
+	uint32_t outbound_intstatus;	/*0030 0033*/=0A=
+	uint32_t outbound_intmask;	/*0034 0037*/=0A=
+	uint32_t reserved1[2];		/*0038 003F*/=0A=
+	uint32_t inbound_queueport;	/*0040 0043*/=0A=
+	uint32_t outbound_queueport;	/*0044 0047*/=0A=
+	uint32_t reserved2[2];		/*0048 004F*/=0A=
+	uint32_t reserved3[492];		/*0050 07FF 492*/=0A=
+	uint32_t reserved4[128];		/*0800 09FF 128*/=0A=
+	uint32_t message_rwbuffer[256];	/*0a00 0DFF 256*/=0A=
+	uint32_t message_wbuffer[32];	/*0E00 0E7F  32*/=0A=
+	uint32_t reserved5[32];		/*0E80 0EFF  32*/=0A=
+	uint32_t message_rbuffer[32];	/*0F00 0F7F  32*/=0A=
+	uint32_t reserved6[32];		/*0F80 0FFF  32*/=0A=
 };=0A=
 =0A=
 struct MessageUnit_B=0A=
 {=0A=
-	uint32_t	post_qbuffer[ARCMSR_MAX_HBB_POSTQUEUE];=0A=
-	uint32_t	done_qbuffer[ARCMSR_MAX_HBB_POSTQUEUE];=0A=
-	uint32_t	postq_index;=0A=
-	uint32_t	doneq_index;=0A=
-	uint32_t		__iomem *drv2iop_doorbell;=0A=
-	uint32_t		__iomem *drv2iop_doorbell_mask;=0A=
-	uint32_t		__iomem *iop2drv_doorbell;=0A=
-	uint32_t		__iomem *iop2drv_doorbell_mask;=0A=
-	uint32_t		__iomem *message_rwbuffer;=0A=
-	uint32_t		__iomem *message_wbuffer;=0A=
-	uint32_t		__iomem *message_rbuffer;=0A=
+	uint32_t post_qbuffer[ARCMSR_MAX_HBB_POSTQUEUE];=0A=
+	uint32_t done_qbuffer[ARCMSR_MAX_HBB_POSTQUEUE];=0A=
+	uint32_t postq_index;=0A=
+	uint32_t doneq_index;=0A=
+	uint32_t __iomem *drv2iop_doorbell;=0A=
+	uint32_t __iomem *drv2iop_doorbell_mask;=0A=
+	uint32_t __iomem *iop2drv_doorbell;=0A=
+	uint32_t __iomem *iop2drv_doorbell_mask;=0A=
+	uint32_t __iomem *message_rwbuffer;=0A=
+	uint32_t __iomem *message_wbuffer;=0A=
+	uint32_t __iomem *message_rbuffer;=0A=
 };=0A=
 /*=0A=
 *********************************************************************=0A=
 ** LSI=0A=
 *********************************************************************=0A=
 */=0A=
-struct MessageUnit_C{=0A=
-	uint32_t	message_unit_status;			/*0000 0003*/=0A=
-	uint32_t	slave_error_attribute;			/*0004 0007*/=0A=
-	uint32_t	slave_error_address;			/*0008 000B*/=0A=
-	uint32_t	posted_outbound_doorbell;		/*000C 000F*/=0A=
-	uint32_t	master_error_attribute;			/*0010 0013*/=0A=
-	uint32_t	master_error_address_low;		/*0014 0017*/=0A=
-	uint32_t	master_error_address_high;		/*0018 001B*/=0A=
-	uint32_t	hcb_size;				/*001C 001F*/=0A=
-	uint32_t	inbound_doorbell;			/*0020 0023*/=0A=
-	uint32_t	diagnostic_rw_data;			/*0024 0027*/=0A=
-	uint32_t	diagnostic_rw_address_low;		/*0028 002B*/=0A=
-	uint32_t	diagnostic_rw_address_high;		/*002C 002F*/=0A=
-	uint32_t	host_int_status;				/*0030 0033*/=0A=
-	uint32_t	host_int_mask;				/*0034 0037*/=0A=
-	uint32_t	dcr_data;				/*0038 003B*/=0A=
-	uint32_t	dcr_address;				/*003C 003F*/=0A=
-	uint32_t	inbound_queueport;			/*0040 0043*/=0A=
-	uint32_t	outbound_queueport;			/*0044 0047*/=0A=
-	uint32_t	hcb_pci_address_low;			/*0048 004B*/=0A=
-	uint32_t	hcb_pci_address_high;			/*004C 004F*/=0A=
-	uint32_t	iop_int_status;				/*0050 0053*/=0A=
-	uint32_t	iop_int_mask;				/*0054 0057*/=0A=
-	uint32_t	iop_inbound_queue_port;			/*0058 005B*/=0A=
-	uint32_t	iop_outbound_queue_port;		/*005C 005F*/=0A=
-	uint32_t	inbound_free_list_index;			/*0060 0063*/=0A=
-	uint32_t	inbound_post_list_index;			/*0064 0067*/=0A=
-	uint32_t	outbound_free_list_index;			/*0068 006B*/=0A=
-	uint32_t	outbound_post_list_index;			/*006C 006F*/=0A=
-	uint32_t	inbound_doorbell_clear;			/*0070 0073*/=0A=
-	uint32_t	i2o_message_unit_control;			/*0074 0077*/=0A=
-	uint32_t	last_used_message_source_address_low;	/*0078 007B*/=0A=
-	uint32_t	last_used_message_source_address_high;	/*007C 007F*/=0A=
-	uint32_t	pull_mode_data_byte_count[4];		/*0080 008F*/=0A=
-	uint32_t	message_dest_address_index;		/*0090 0093*/=0A=
-	uint32_t	done_queue_not_empty_int_counter_timer;	/*0094 0097*/=0A=
-	uint32_t	utility_A_int_counter_timer;		/*0098 009B*/=0A=
-	uint32_t	outbound_doorbell;			/*009C 009F*/=0A=
-	uint32_t	outbound_doorbell_clear;			/*00A0 00A3*/=0A=
-	uint32_t	message_source_address_index;		/*00A4 00A7*/=0A=
-	uint32_t	message_done_queue_index;		/*00A8 00AB*/=0A=
-	uint32_t	reserved0;				/*00AC 00AF*/=0A=
-	uint32_t	inbound_msgaddr0;			/*00B0 00B3*/=0A=
-	uint32_t	inbound_msgaddr1;			/*00B4 00B7*/=0A=
-	uint32_t	outbound_msgaddr0;			/*00B8 00BB*/=0A=
-	uint32_t	outbound_msgaddr1;			/*00BC 00BF*/=0A=
-	uint32_t	inbound_queueport_low;			/*00C0 00C3*/=0A=
-	uint32_t	inbound_queueport_high;			/*00C4 00C7*/=0A=
-	uint32_t	outbound_queueport_low;			/*00C8 00CB*/=0A=
-	uint32_t	outbound_queueport_high;		/*00CC 00CF*/=0A=
-	uint32_t	iop_inbound_queue_port_low;		/*00D0 00D3*/=0A=
-	uint32_t	iop_inbound_queue_port_high;		/*00D4 00D7*/=0A=
-	uint32_t	iop_outbound_queue_port_low;		/*00D8 00DB*/=0A=
-	uint32_t	iop_outbound_queue_port_high;		/*00DC 00DF*/=0A=
-	uint32_t	message_dest_queue_port_low;		/*00E0 00E3*/=0A=
-	uint32_t	message_dest_queue_port_high;		/*00E4 00E7*/=0A=
-	uint32_t	last_used_message_dest_address_low;	/*00E8 00EB*/=0A=
-	uint32_t	last_used_message_dest_address_high;	/*00EC 00EF*/=0A=
-	uint32_t	message_done_queue_base_address_low;	/*00F0 00F3*/=0A=
-	uint32_t	message_done_queue_base_address_high;	/*00F4 00F7*/=0A=
-	uint32_t	host_diagnostic;				/*00F8 00FB*/=0A=
-	uint32_t	write_sequence;				/*00FC 00FF*/=0A=
-	uint32_t	reserved1[34];				/*0100 0187*/=0A=
-	uint32_t	reserved2[1950];				/*0188 1FFF*/=0A=
-	uint32_t	message_wbuffer[32];			/*2000 207F*/=0A=
-	uint32_t	reserved3[32];				/*2080 20FF*/=0A=
-	uint32_t	message_rbuffer[32];			/*2100 217F*/=0A=
-	uint32_t	reserved4[32];				/*2180 21FF*/=0A=
-	uint32_t	msgcode_rwbuffer[256];			/*2200 23FF*/=0A=
+struct MessageUnit_C {=0A=
+	uint32_t message_unit_status;			/*0000 0003*/=0A=
+	uint32_t slave_error_attribute;			/*0004 0007*/=0A=
+	uint32_t slave_error_address;			/*0008 000B*/=0A=
+	uint32_t posted_outbound_doorbell;			/*000C 000F*/=0A=
+	uint32_t master_error_attribute;			/*0010 0013*/=0A=
+	uint32_t master_error_address_low;			/*0014 0017*/=0A=
+	uint32_t master_error_address_high;		/*0018 001B*/=0A=
+	uint32_t hcb_size;					/*001C 001F*/=0A=
+	uint32_t inbound_doorbell;				/*0020 0023*/=0A=
+	uint32_t diagnostic_rw_data;			/*0024 0027*/=0A=
+	uint32_t diagnostic_rw_address_low;		/*0028 002B*/=0A=
+	uint32_t diagnostic_rw_address_high;		/*002C 002F*/=0A=
+	uint32_t host_int_status;				/*0030 0033*/=0A=
+	uint32_t host_int_mask;				/*0034 0037*/=0A=
+	uint32_t dcr_data;					/*0038 003B*/=0A=
+	uint32_t dcr_address;				/*003C 003F*/=0A=
+	uint32_t inbound_queueport;			/*0040 0043*/=0A=
+	uint32_t outbound_queueport;			/*0044 0047*/=0A=
+	uint32_t hcb_pci_address_low;			/*0048 004B*/=0A=
+	uint32_t hcb_pci_address_high;			/*004C 004F*/=0A=
+	uint32_t iop_int_status;				/*0050 0053*/=0A=
+	uint32_t iop_int_mask;				/*0054 0057*/=0A=
+	uint32_t iop_inbound_queue_port;			/*0058 005B*/=0A=
+	uint32_t iop_outbound_queue_port;			/*005C 005F*/=0A=
+	uint32_t inbound_free_list_index;			/*0060 0063*/=0A=
+	uint32_t inbound_post_list_index;			/*0064 0067*/=0A=
+	uint32_t outbound_free_list_index;			/*0068 006B*/=0A=
+	uint32_t outbound_post_list_index;			/*006C 006F*/=0A=
+	uint32_t inbound_doorbell_clear;			/*0070 0073*/=0A=
+	uint32_t i2o_message_unit_control;			/*0074 0077*/=0A=
+	uint32_t last_used_message_source_address_low;	/*0078 007B*/=0A=
+	uint32_t last_used_message_source_address_high;	/*007C 007F*/=0A=
+	uint32_t pull_mode_data_byte_count[4];		/*0080 008F*/=0A=
+	uint32_t message_dest_address_index;		/*0090 0093*/=0A=
+	uint32_t done_queue_not_empty_int_counter_timer;	/*0094 0097*/=0A=
+	uint32_t utility_A_int_counter_timer;		/*0098 009B*/=0A=
+	uint32_t outbound_doorbell;			/*009C 009F*/=0A=
+	uint32_t outbound_doorbell_clear;			/*00A0 00A3*/=0A=
+	uint32_t message_source_address_index;		/*00A4 00A7*/=0A=
+	uint32_t message_done_queue_index;		/*00A8 00AB*/=0A=
+	uint32_t reserved0;				/*00AC 00AF*/=0A=
+	uint32_t inbound_msgaddr0;			/*00B0 00B3*/=0A=
+	uint32_t inbound_msgaddr1;			/*00B4 00B7*/=0A=
+	uint32_t outbound_msgaddr0;			/*00B8 00BB*/=0A=
+	uint32_t outbound_msgaddr1;			/*00BC 00BF*/=0A=
+	uint32_t inbound_queueport_low;			/*00C0 00C3*/=0A=
+	uint32_t inbound_queueport_high;			/*00C4 00C7*/=0A=
+	uint32_t outbound_queueport_low;			/*00C8 00CB*/=0A=
+	uint32_t outbound_queueport_high;		/*00CC 00CF*/=0A=
+	uint32_t iop_inbound_queue_port_low;		/*00D0 00D3*/=0A=
+	uint32_t iop_inbound_queue_port_high;		/*00D4 00D7*/=0A=
+	uint32_t iop_outbound_queue_port_low;		/*00D8 00DB*/=0A=
+	uint32_t iop_outbound_queue_port_high;		/*00DC 00DF*/=0A=
+	uint32_t message_dest_queue_port_low;		/*00E0 00E3*/=0A=
+	uint32_t message_dest_queue_port_high;		/*00E4 00E7*/=0A=
+	uint32_t last_used_message_dest_address_low;	/*00E8 00EB*/=0A=
+	uint32_t last_used_message_dest_address_high;	/*00EC 00EF*/=0A=
+	uint32_t message_done_queue_base_address_low;	/*00F0 00F3*/=0A=
+	uint32_t message_done_queue_base_address_high;	/*00F4 00F7*/=0A=
+	uint32_t host_diagnostic;				/*00F8 00FB*/=0A=
+	uint32_t write_sequence;				/*00FC 00FF*/=0A=
+	uint32_t reserved1[34];				/*0100 0187*/=0A=
+	uint32_t reserved2[1950];				/*0188 1FFF*/=0A=
+	uint32_t message_wbuffer[32];			/*2000 207F*/=0A=
+	uint32_t reserved3[32];				/*2080 20FF*/=0A=
+	uint32_t message_rbuffer[32];			/*2100 217F*/=0A=
+	uint32_t reserved4[32];				/*2180 21FF*/=0A=
+	uint32_t msgcode_rwbuffer[256];			/*2200 23FF*/=0A=
+};=0A=
+struct InBound_SRB {=0A=
+	uint32_t addressLow;/*pointer to SRB block*/=0A=
+	uint32_t addressHigh;=0A=
+	uint32_t length;/*in DWORDs*/=0A=
+	uint32_t reserved0;=0A=
+};=0A=
+=0A=
+struct OutBound_SRB {=0A=
+	uint32_t addressLow;/*pointer to SRB block*/=0A=
+	uint32_t addressHigh;=0A=
+};=0A=
+=0A=
+struct MessageUnit_D {=0A=
+	struct InBound_SRB post_qbuffer[ARCMSR_MAX_ARC1214_POSTQUEUE];=0A=
+	struct OutBound_SRB done_qbuffer[ARCMSR_MAX_ARC1214_DONEQUEUE];=0A=
+	u16 postq_index;=0A=
+	u16 doneq_index;=0A=
+	u32 __iomem *chip_id;			/*0x00004*/=0A=
+	u32 __iomem *cpu_mem_config;		/*0x00008*/=0A=
+	u32 __iomem *i2o_host_interrupt_mask;	/*0x00034*/=0A=
+	u32 __iomem *sample_at_reset;		/*0x00100*/=0A=
+	u32 __iomem *reset_request;		/*0x00108*/=0A=
+	u32 __iomem *host_int_status;		/*0x00200*/=0A=
+	u32 __iomem *pcief0_int_enable;		/*0x0020C*/=0A=
+	u32 __iomem *inbound_msgaddr0;		/*0x00400*/=0A=
+	u32 __iomem *inbound_msgaddr1;		/*0x00404*/=0A=
+	u32 __iomem *outbound_msgaddr0;		/*0x00420*/=0A=
+	u32 __iomem *outbound_msgaddr1;		/*0x00424*/=0A=
+	u32 __iomem *inbound_doorbell;		/*0x00460*/=0A=
+	u32 __iomem *outbound_doorbell;		/*0x00480*/=0A=
+	u32 __iomem *outbound_doorbell_enable;	/*0x00484*/=0A=
+	u32 __iomem *inboundlist_base_low;	/*0x01000*/=0A=
+	u32 __iomem *inboundlist_base_high;	/*0x01004*/=0A=
+	u32 __iomem *inboundlist_write_pointer;	/*0x01018*/=0A=
+	u32 __iomem *outboundlist_base_low;	/*0x01060*/=0A=
+	u32 __iomem *outboundlist_base_high;	/*0x01064*/=0A=
+	u32 __iomem *outboundlist_copy_pointer;	/*0x0106C*/=0A=
+	u32 __iomem *outboundlist_read_pointer;	/*0x01070 0x01072*/=0A=
+	u32 __iomem *outboundlist_interrupt_cause;	/*0x1088*/=0A=
+	u32 __iomem *outboundlist_interrupt_enable;	/*0x108C*/=0A=
+	u32 __iomem *message_wbuffer;		/*0x2000*/=0A=
+	u32 __iomem *message_rbuffer;		/*0x2100*/=0A=
+	u32 __iomem *msgcode_rwbuffer;		/*0x2200*/=0A=
 };=0A=
 /*=0A=
 =
*************************************************************************=
******=0A=
@@ -500,100 +602,110 @@ struct MessageUnit_C{=0A=
 */=0A=
 struct AdapterControlBlock=0A=
 {=0A=
-	uint32_t  adapter_type;                /* adapter A,B..... */=0A=
-	#define ACB_ADAPTER_TYPE_A            0x00000001	/* hba I IOP */=0A=
-	#define ACB_ADAPTER_TYPE_B            0x00000002	/* hbb M IOP */=0A=
-	#define ACB_ADAPTER_TYPE_C            0x00000004	/* hbc P IOP */=0A=
-	#define ACB_ADAPTER_TYPE_D            0x00000008	/* hbd A IOP */=0A=
-	struct pci_dev *		pdev;=0A=
-	struct Scsi_Host *		host;=0A=
-	unsigned long			vir2phy_offset;=0A=
+	uint32_t adapter_type;	/* adapter A,B..... */=0A=
+	#define ACB_ADAPTER_TYPE_A	0x00000001	/* hba I IOP */=0A=
+	#define ACB_ADAPTER_TYPE_B	0x00000002	/* hbb M IOP */=0A=
+	#define ACB_ADAPTER_TYPE_C	0x00000004	/* hbc P IOP */=0A=
+	#define ACB_ADAPTER_TYPE_D	0x00000008	/* hbd A IOP */=0A=
+	u32 roundup_ccbsize;=0A=
+	struct pci_dev *pdev;=0A=
+	struct Scsi_Host *host;=0A=
+	unsigned long vir2phy_offset;=0A=
+	struct msix_entry entries[ARCMST_NUM_MSIX_VECTORS];=0A=
 	/* Offset is used in making arc cdb physical to virtual calculations */=0A=
-	uint32_t			outbound_int_enable;=0A=
-	uint32_t			cdb_phyaddr_hi32;=0A=
-	uint32_t			reg_mu_acc_handle0;=0A=
-	spinlock_t                      			eh_lock;=0A=
-	spinlock_t                      			ccblist_lock;=0A=
+	uint32_t outbound_int_enable;=0A=
+	uint32_t cdb_phyaddr_hi32;=0A=
+	spinlock_t eh_lock;=0A=
+	spinlock_t ccblist_lock;=0A=
+	spinlock_t postq_lock;=0A=
+	spinlock_t doneq_lock;=0A=
+	spinlock_t rqbuffer_lock;=0A=
+	spinlock_t wqbuffer_lock;=0A=
 	union {=0A=
 		struct MessageUnit_A __iomem *pmuA;=0A=
-		struct MessageUnit_B 	*pmuB;=0A=
+		struct MessageUnit_B __iomem *pmuB;=0A=
 		struct MessageUnit_C __iomem *pmuC;=0A=
+		struct MessageUnit_D __iomem *pmuD;=0A=
 	};=0A=
 	/* message unit ATU inbound base address0 */=0A=
 	void __iomem *mem_base0;=0A=
 	void __iomem *mem_base1;=0A=
-	uint32_t			acb_flags;=0A=
-	u16			dev_id;=0A=
-	uint8_t                   		adapter_index;=0A=
-	#define ACB_F_SCSISTOPADAPTER         	0x0001=0A=
-	#define ACB_F_MSG_STOP_BGRB     	0x0002=0A=
+	uint32_t acb_flags;=0A=
+	u16 dev_id;=0A=
+	uint8_t adapter_index;=0A=
+	#define ACB_F_SCSISTOPADAPTER			0x0001=0A=
+	#define ACB_F_MSG_STOP_BGRB			0x0002=0A=
 	/* stop RAID background rebuild */=0A=
-	#define ACB_F_MSG_START_BGRB          	0x0004=0A=
+	#define ACB_F_MSG_START_BGRB			0x0004=0A=
 	/* stop RAID background rebuild */=0A=
-	#define ACB_F_IOPDATA_OVERFLOW        	0x0008=0A=
+	#define ACB_F_IOPDATA_OVERFLOW		0x0008=0A=
 	/* iop message data rqbuffer overflow */=0A=
 	#define ACB_F_MESSAGE_WQBUFFER_CLEARED	0x0010=0A=
 	/* message clear wqbuffer */=0A=
-	#define ACB_F_MESSAGE_RQBUFFER_CLEARED  0x0020=0A=
+	#define ACB_F_MESSAGE_RQBUFFER_CLEARED	0x0020=0A=
 	/* message clear rqbuffer */=0A=
-	#define ACB_F_MESSAGE_WQBUFFER_READED   0x0040=0A=
-	#define ACB_F_BUS_RESET               	0x0080=0A=
-	#define ACB_F_BUS_HANG_ON		0x0800/* need hardware reset bus */=0A=
+	#define ACB_F_MESSAGE_WQBUFFER_READED	0x0040=0A=
+	#define ACB_F_BUS_RESET				0x0080=0A=
+	#define ACB_F_BUS_HANG_ON			0x0800=0A=
 =0A=
-	#define ACB_F_IOP_INITED              	0x0100=0A=
+	#define ACB_F_IOP_INITED				0x0100=0A=
 	/* iop init */=0A=
 	#define ACB_F_ABORT				0x0200=0A=
-	#define ACB_F_FIRMWARE_TRAP           		0x0400=0A=
-	struct CommandControlBlock *			pccb_pool[ARCMSR_MAX_FREECCB_NUM];=0A=
+	#define ACB_F_FIRMWARE_TRAP			0x0400=0A=
+	#define ACB_F_MSI_ENABLED			0x1000=0A=
+	#define ACB_F_MSIX_ENABLED			0x2000=0A=
+	struct CommandControlBlock *pccb_pool[ARCMSR_MAX_FREECCB_NUM];=0A=
 	/* used for memory free */=0A=
-	struct list_head		ccb_free_list;=0A=
+	struct list_head ccb_free_list;=0A=
 	/* head of free ccb list */=0A=
 =0A=
-	atomic_t			ccboutstandingcount;=0A=
+	atomic_t ccboutstandingcount;=0A=
 	/*The present outstanding command number that in the IOP that=0A=
 					waiting for being handled by FW*/=0A=
 =0A=
-	void *				dma_coherent;=0A=
+	void *dma_coherent;=0A=
 	/* dma_coherent used for memory free */=0A=
-	dma_addr_t			dma_coherent_handle;=0A=
+	dma_addr_t dma_coherent_handle;=0A=
 	/* dma_coherent_handle used for memory free */=0A=
-	dma_addr_t				dma_coherent_handle_hbb_mu;=0A=
-	unsigned int				uncache_size;=0A=
-	uint8_t				rqbuffer[ARCMSR_MAX_QBUFFER];=0A=
+	dma_addr_t dma_coherent_handle2;=0A=
+	void *dma_coherent2;=0A=
+	unsigned int uncache_size;=0A=
+	uint8_t rqbuffer[ARCMSR_MAX_QBUFFER];=0A=
 	/* data collection buffer for read from 80331 */=0A=
-	int32_t				rqbuf_firstindex;=0A=
+	uint32_t rqbuf_firstindex;=0A=
 	/* first of read buffer  */=0A=
-	int32_t				rqbuf_lastindex;=0A=
+	uint32_t rqbuf_lastindex;=0A=
 	/* last of read buffer   */=0A=
-	uint8_t				wqbuffer[ARCMSR_MAX_QBUFFER];=0A=
+	uint8_t wqbuffer[ARCMSR_MAX_QBUFFER];=0A=
 	/* data collection buffer for write to 80331  */=0A=
-	int32_t				wqbuf_firstindex;=0A=
+	uint32_t wqbuf_firstindex;=0A=
 	/* first of write buffer */=0A=
-	int32_t				wqbuf_lastindex;=0A=
+	uint32_t wqbuf_lastindex;=0A=
 	/* last of write buffer  */=0A=
-	uint8_t				devstate[ARCMSR_MAX_TARGETID][ARCMSR_MAX_TARGETLUN];=0A=
+	uint8_t devstate[ARCMSR_MAX_TARGETID][ARCMSR_MAX_TARGETLUN];=0A=
 	/* id0 ..... id15, lun0...lun7 */=0A=
-#define ARECA_RAID_GONE               0x55=0A=
-#define ARECA_RAID_GOOD               0xaa=0A=
-	uint32_t			num_resets;=0A=
-	uint32_t			num_aborts;=0A=
-	uint32_t			signature;=0A=
-	uint32_t			firm_request_len;=0A=
-	uint32_t			firm_numbers_queue;=0A=
-	uint32_t			firm_sdram_size;=0A=
-	uint32_t			firm_hd_channels;=0A=
-	uint32_t                           	firm_cfg_version;	=0A=
-	char			firm_model[12];=0A=
-	char			firm_version[20];=0A=
-	char			device_map[20];			/*21,84-99*/=0A=
-	struct work_struct 		arcmsr_do_message_isr_bh;=0A=
-	struct timer_list		eternal_timer;=0A=
-	unsigned short		fw_flag;=0A=
-				#define	FW_NORMAL	0x0000=0A=
-				#define	FW_BOG		0x0001=0A=
-				#define	FW_DEADLOCK	0x0010=0A=
-	atomic_t 			rq_map_token;=0A=
-	atomic_t			ante_token_value;=0A=
+#define ARECA_RAID_GONE		0x55=0A=
+#define ARECA_RAID_GOOD	0xaa=0A=
+	uint32_t num_resets;=0A=
+	uint32_t num_aborts;=0A=
+	uint32_t signature;=0A=
+	uint32_t firm_request_len;=0A=
+	uint32_t firm_numbers_queue;=0A=
+	uint32_t firm_sdram_size;=0A=
+	uint32_t firm_hd_channels;=0A=
+	uint32_t firm_cfg_version;=0A=
+	char firm_model[12];=0A=
+	char firm_version[20];=0A=
+	char device_map[20];	/*21,84-99*/=0A=
+	struct work_struct arcmsr_do_message_isr_bh;=0A=
+	struct timer_list eternal_timer;=0A=
+	unsigned short fw_flag;=0A=
+	#define FW_NORMAL	0x0000=0A=
+	#define FW_BOG		0x0001=0A=
+	#define FW_DEADLOCK	0x0010=0A=
+	atomic_t rq_map_token;=0A=
+	atomic_t ante_token_value;=0A=
+	uint32_t maxOutstanding;=0A=
 };/* HW_DEVICE_EXTENSION */=0A=
 /*=0A=
 =
*************************************************************************=
******=0A=
@@ -601,33 +713,33 @@ struct AdapterControlBlock=0A=
 **             this CCB length must be 32 bytes boundary=0A=
 =
*************************************************************************=
******=0A=
 */=0A=
-struct CommandControlBlock{=0A=
-	/*x32:sizeof struct_CCB=3D(32+60)byte, x64:sizeof =
struct_CCB=3D(64+60)byte*/=0A=
-	struct list_head		list;				/*x32: 8byte, x64: 16byte*/=0A=
-	struct scsi_cmnd		*pcmd;				/*8 bytes pointer of linux scsi command */=0A=
-	struct AdapterControlBlock	*acb;				/*x32: 4byte, x64: 8byte*/=0A=
-	uint32_t			cdb_phyaddr_pattern;		/*x32: 4byte, x64: 4byte*/=0A=
-	uint32_t			arc_cdb_size;			/*x32:4byte,x64:4byte*/=0A=
-	uint16_t			ccb_flags;			/*x32: 2byte, x64: 2byte*/=0A=
-	#define			CCB_FLAG_READ			0x0000=0A=
-	#define			CCB_FLAG_WRITE		0x0001=0A=
-	#define			CCB_FLAG_ERROR		0x0002=0A=
-	#define			CCB_FLAG_FLUSHCACHE		0x0004=0A=
-	#define			CCB_FLAG_MASTER_ABORTED	0x0008	=0A=
-	uint16_t                        	startdone;			/*x32:2byte,x32:2byte*/=0A=
-	#define			ARCMSR_CCB_DONE   	        	0x0000=0A=
-	#define			ARCMSR_CCB_START		0x55AA=0A=
-	#define			ARCMSR_CCB_ABORTED		0xAA55=0A=
-	#define			ARCMSR_CCB_ILLEGAL		0xFFFF=0A=
+struct CommandControlBlock {=0A=
+/*x32:sizeof struct_CCB=3D(32+60)byte, x64:sizeof =
struct_CCB=3D(64+60)byte*/=0A=
+	struct list_head list;=0A=
+	struct scsi_cmnd *pcmd;=0A=
+	struct AdapterControlBlock *acb;=0A=
+	uint32_t cdb_phyaddr;=0A=
+	uint32_t arc_cdb_size;=0A=
+	uint16_t ccb_flags;=0A=
+	#define CCB_FLAG_READ		0x0000=0A=
+	#define CCB_FLAG_WRITE		0x0001=0A=
+	#define CCB_FLAG_ERROR		0x0002=0A=
+	#define CCB_FLAG_FLUSHCACHE	0x0004=0A=
+	#define CCB_FLAG_MASTER_ABORTED	0x0008=0A=
+	uint16_t startdone;=0A=
+	#define ARCMSR_CCB_DONE	0x0000=0A=
+	#define ARCMSR_CCB_START	0x55AA=0A=
+	#define ARCMSR_CCB_ABORTED	0xAA55=0A=
+	#define ARCMSR_CCB_ILLEGAL	0xFFFF=0A=
 	#if BITS_PER_LONG =3D=3D 64=0A=
 	/*  =
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D512+64 =
bytes=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D  */=0A=
-		uint32_t                        	reserved[5];		/*24 byte*/=0A=
+		uint32_t reserved[5];	/*24 byte*/=0A=
 	#else=0A=
-	/*  =
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D512+32 =
bytes=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D  */=0A=
-		uint32_t                        	reserved;		/*8  byte*/=0A=
+	=
/*=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D512+3=
2 =
bytes=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D*/=0A=
+		uint32_t reserved;	/*8  byte*/=0A=
 	#endif=0A=
-	/*  =
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D   */=0A=
-	struct ARCMSR_CDB		arcmsr_cdb;=0A=
+	=
/*=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D*/=0A=
+	struct ARCMSR_CDB arcmsr_cdb;=0A=
 };=0A=
 /*=0A=
 =
*************************************************************************=
******=0A=
@@ -636,56 +748,58 @@ struct CommandControlBlock{=0A=
 */=0A=
 struct SENSE_DATA=0A=
 {=0A=
-	uint8_t				ErrorCode:7;=0A=
+	uint8_t ErrorCode:7;=0A=
 #define SCSI_SENSE_CURRENT_ERRORS	0x70=0A=
 #define SCSI_SENSE_DEFERRED_ERRORS	0x71=0A=
-	uint8_t				Valid:1;=0A=
-	uint8_t				SegmentNumber;=0A=
-	uint8_t				SenseKey:4;=0A=
-	uint8_t				Reserved:1;=0A=
-	uint8_t				IncorrectLength:1;=0A=
-	uint8_t				EndOfMedia:1;=0A=
-	uint8_t				FileMark:1;=0A=
-	uint8_t				Information[4];=0A=
-	uint8_t				AdditionalSenseLength;=0A=
-	uint8_t				CommandSpecificInformation[4];=0A=
-	uint8_t				AdditionalSenseCode;=0A=
-	uint8_t				AdditionalSenseCodeQualifier;=0A=
-	uint8_t				FieldReplaceableUnitCode;=0A=
-	uint8_t				SenseKeySpecific[3];=0A=
+	uint8_t Valid:1;=0A=
+	uint8_t SegmentNumber;=0A=
+	uint8_t SenseKey:4;=0A=
+	uint8_t Reserved:1;=0A=
+	uint8_t IncorrectLength:1;=0A=
+	uint8_t EndOfMedia:1;=0A=
+	uint8_t FileMark:1;=0A=
+	uint8_t Information[4];=0A=
+	uint8_t AdditionalSenseLength;=0A=
+	uint8_t CommandSpecificInformation[4];=0A=
+	uint8_t AdditionalSenseCode;=0A=
+	uint8_t AdditionalSenseCodeQualifier;=0A=
+	uint8_t FieldReplaceableUnitCode;=0A=
+	uint8_t SenseKeySpecific[3];=0A=
 };=0A=
 /*=0A=
 =
*************************************************************************=
******=0A=
 **  Outbound Interrupt Status Register - OISR=0A=
 =
*************************************************************************=
******=0A=
 */=0A=
-#define     ARCMSR_MU_OUTBOUND_INTERRUPT_STATUS_REG                 0x30=0A=
-#define     ARCMSR_MU_OUTBOUND_PCI_INT                              0x10=0A=
-#define     ARCMSR_MU_OUTBOUND_POSTQUEUE_INT                        0x08=0A=
-#define     ARCMSR_MU_OUTBOUND_DOORBELL_INT                         0x04=0A=
-#define     ARCMSR_MU_OUTBOUND_MESSAGE1_INT                         0x02=0A=
-#define     ARCMSR_MU_OUTBOUND_MESSAGE0_INT                         0x01=0A=
-#define     ARCMSR_MU_OUTBOUND_HANDLE_INT                 \=0A=
-                    (ARCMSR_MU_OUTBOUND_MESSAGE0_INT      \=0A=
-                     |ARCMSR_MU_OUTBOUND_MESSAGE1_INT     \=0A=
-                     |ARCMSR_MU_OUTBOUND_DOORBELL_INT     \=0A=
-                     |ARCMSR_MU_OUTBOUND_POSTQUEUE_INT    \=0A=
-                     |ARCMSR_MU_OUTBOUND_PCI_INT)=0A=
+#define ARCMSR_MU_OUTBOUND_INTERRUPT_STATUS_REG	0x30=0A=
+#define ARCMSR_MU_OUTBOUND_PCI_INT			0x10=0A=
+#define ARCMSR_MU_OUTBOUND_POSTQUEUE_INT		0x08=0A=
+#define ARCMSR_MU_OUTBOUND_DOORBELL_INT		0x04=0A=
+#define ARCMSR_MU_OUTBOUND_MESSAGE1_INT		0x02=0A=
+#define ARCMSR_MU_OUTBOUND_MESSAGE0_INT		0x01=0A=
+#define ARCMSR_MU_OUTBOUND_HANDLE_INT	\=0A=
+	(ARCMSR_MU_OUTBOUND_MESSAGE0_INT	\=0A=
+	|ARCMSR_MU_OUTBOUND_MESSAGE1_INT	\=0A=
+	|ARCMSR_MU_OUTBOUND_DOORBELL_INT	\=0A=
+	|ARCMSR_MU_OUTBOUND_POSTQUEUE_INT	\=0A=
+	|ARCMSR_MU_OUTBOUND_PCI_INT)=0A=
 /*=0A=
 =
*************************************************************************=
******=0A=
 **  Outbound Interrupt Mask Register - OIMR=0A=
 =
*************************************************************************=
******=0A=
 */=0A=
-#define     ARCMSR_MU_OUTBOUND_INTERRUPT_MASK_REG                   0x34=0A=
-#define     ARCMSR_MU_OUTBOUND_PCI_INTMASKENABLE                    0x10=0A=
-#define     ARCMSR_MU_OUTBOUND_POSTQUEUE_INTMASKENABLE              0x08=0A=
-#define     ARCMSR_MU_OUTBOUND_DOORBELL_INTMASKENABLE               0x04=0A=
-#define     ARCMSR_MU_OUTBOUND_MESSAGE1_INTMASKENABLE               0x02=0A=
-#define     ARCMSR_MU_OUTBOUND_MESSAGE0_INTMASKENABLE               0x01=0A=
-#define     ARCMSR_MU_OUTBOUND_ALL_INTMASKENABLE                    0x1F=0A=
+#define ARCMSR_MU_OUTBOUND_INTERRUPT_MASK_REG		0x34=0A=
+#define ARCMSR_MU_OUTBOUND_PCI_INTMASKENABLE		0x10=0A=
+#define ARCMSR_MU_OUTBOUND_POSTQUEUE_INTMASKENABLE	0x08=0A=
+#define ARCMSR_MU_OUTBOUND_DOORBELL_INTMASKENABLE	0x04=0A=
+#define ARCMSR_MU_OUTBOUND_MESSAGE1_INTMASKENABLE	0x02=0A=
+#define ARCMSR_MU_OUTBOUND_MESSAGE0_INTMASKENABLE	0x01=0A=
+#define ARCMSR_MU_OUTBOUND_ALL_INTMASKENABLE		0x1F=0A=
 =0A=
-extern void arcmsr_post_ioctldata2iop(struct AdapterControlBlock *);=0A=
-extern void arcmsr_iop_message_read(struct AdapterControlBlock *);=0A=
+extern void arcmsr_write_ioctldata2iop(struct AdapterControlBlock *);=0A=
+extern uint32_t arcmsr_Read_iop_rqbuffer_data(struct =
AdapterControlBlock *,=0A=
+	struct QBUFFER __iomem *);=0A=
+extern void arcmsr_clear_iop2drv_rqueue_buffer(struct =
AdapterControlBlock *);=0A=
 extern struct QBUFFER __iomem *arcmsr_get_iop_rqbuffer(struct =
AdapterControlBlock *);=0A=
 extern struct device_attribute *arcmsr_host_attrs[];=0A=
 extern int arcmsr_alloc_sysfs_attr(struct AdapterControlBlock *);=0A=
diff -uprN a/drivers/scsi/arcmsr/arcmsr_hba.c =
b/drivers/scsi/arcmsr/arcmsr_hba.c=0A=
--- a/drivers/scsi/arcmsr/arcmsr_hba.c	2013-07-01 06:13:28.000000000 =
+0800=0A=
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c	2013-08-29 01:35:44.000000000 =
+0800=0A=
@@ -2,7 +2,7 @@=0A=
 =
*************************************************************************=
******=0A=
 **        O.S   : Linux=0A=
 **   FILE NAME  : arcmsr_hba.c=0A=
-**        BY    : Nick Cheng=0A=
+**        BY    : Nick Cheng, C.L. Huang=0A=
 **   Description: SCSI RAID Device Driver for=0A=
 **                ARECA RAID Host adapter=0A=
 =
*************************************************************************=
******=0A=
@@ -70,15 +70,15 @@=0A=
 #include <scsi/scsi_transport.h>=0A=
 #include <scsi/scsicam.h>=0A=
 #include "arcmsr.h"=0A=
-MODULE_AUTHOR("Nick Cheng <support@areca.com.tw>");=0A=
-MODULE_DESCRIPTION("ARECA (ARC11xx/12xx/16xx/1880) SATA/SAS RAID Host =
Bus Adapter");=0A=
+MODULE_AUTHOR("Nick Cheng, Ching Huang <support@areca.com.tw>");=0A=
+MODULE_DESCRIPTION("Areca SAS,SATA RAID Controller Driver");=0A=
 MODULE_LICENSE("Dual BSD/GPL");=0A=
 MODULE_VERSION(ARCMSR_DRIVER_VERSION);=0A=
 =0A=
-#define	ARCMSR_SLEEPTIME	10=0A=
-#define	ARCMSR_RETRYCOUNT	12=0A=
+#define ARCMSR_SLEEPTIME	10=0A=
+#define ARCMSR_RETRYCOUNT	12=0A=
 =0A=
-wait_queue_head_t wait_q;=0A=
+static wait_queue_head_t wait_q;=0A=
 static int arcmsr_iop_message_xfer(struct AdapterControlBlock *acb,=0A=
 					struct scsi_cmnd *cmd);=0A=
 static int arcmsr_iop_confirm(struct AdapterControlBlock *acb);=0A=
@@ -89,22 +89,27 @@ static int arcmsr_bios_param(struct scsi=0A=
 static int arcmsr_queue_command(struct Scsi_Host *h, struct scsi_cmnd =
*cmd);=0A=
 static int arcmsr_probe(struct pci_dev *pdev,=0A=
 				const struct pci_device_id *id);=0A=
+static int arcmsr_suspend(struct pci_dev *pdev, pm_message_t state);=0A=
+static int arcmsr_resume(struct pci_dev *pdev);=0A=
 static void arcmsr_remove(struct pci_dev *pdev);=0A=
 static void arcmsr_shutdown(struct pci_dev *pdev);=0A=
 static void arcmsr_iop_init(struct AdapterControlBlock *acb);=0A=
 static void arcmsr_free_ccb_pool(struct AdapterControlBlock *acb);=0A=
 static u32 arcmsr_disable_outbound_ints(struct AdapterControlBlock =
*acb);=0A=
+static void arcmsr_enable_outbound_ints(struct AdapterControlBlock *acb,=0A=
+	u32 orig_mask);=0A=
 static void arcmsr_stop_adapter_bgrb(struct AdapterControlBlock *acb);=0A=
-static void arcmsr_flush_hba_cache(struct AdapterControlBlock *acb);=0A=
-static void arcmsr_flush_hbb_cache(struct AdapterControlBlock *acb);=0A=
+static void arcmsr_hbaA_flush_cache(struct AdapterControlBlock *acb);=0A=
+static void arcmsr_hbaB_flush_cache(struct AdapterControlBlock *acb);=0A=
 static void arcmsr_request_device_map(unsigned long pacb);=0A=
-static void arcmsr_request_hba_device_map(struct AdapterControlBlock =
*acb);=0A=
-static void arcmsr_request_hbb_device_map(struct AdapterControlBlock =
*acb);=0A=
-static void arcmsr_request_hbc_device_map(struct AdapterControlBlock =
*acb);=0A=
+static void arcmsr_hbaA_request_device_map(struct AdapterControlBlock =
*acb);=0A=
+static void arcmsr_hbaB_request_device_map(struct AdapterControlBlock =
*acb);=0A=
+static void arcmsr_hbaC_request_device_map(struct AdapterControlBlock =
*acb);=0A=
 static void arcmsr_message_isr_bh_fn(struct work_struct *work);=0A=
 static bool arcmsr_get_firmware_spec(struct AdapterControlBlock *acb);=0A=
 static void arcmsr_start_adapter_bgrb(struct AdapterControlBlock *acb);=0A=
-static void arcmsr_hbc_message_isr(struct AdapterControlBlock *pACB);=0A=
+static void arcmsr_hbaC_message_isr(struct AdapterControlBlock *pACB);=0A=
+static void arcmsr_hbaD_message_isr(struct AdapterControlBlock *acb);=0A=
 static void arcmsr_hardware_reset(struct AdapterControlBlock *acb);=0A=
 static const char *arcmsr_info(struct Scsi_Host *);=0A=
 static irqreturn_t arcmsr_interrupt(struct AdapterControlBlock *acb);=0A=
@@ -132,8 +137,6 @@ static struct scsi_host_template arcmsr_=0A=
 	.change_queue_depth	=3D arcmsr_adjust_disk_queue_depth,=0A=
 	.can_queue		=3D ARCMSR_MAX_FREECCB_NUM,=0A=
 	.this_id			=3D ARCMSR_SCSI_INITIATOR_ID,=0A=
-	.sg_tablesize	        	=3D ARCMSR_DEFAULT_SG_ENTRIES, =0A=
-	.max_sectors    	    	=3D ARCMSR_MAX_XFER_SECTORS_C, =0A=
 	.cmd_per_lun		=3D ARCMSR_MAX_CMD_PERLUN,=0A=
 	.use_clustering		=3D ENABLE_CLUSTERING,=0A=
 	.shost_attrs		=3D arcmsr_host_attrs,=0A=
@@ -148,13 +151,12 @@ static struct pci_device_id arcmsr_devic=0A=
 	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1201)},=0A=
 	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1202)},=0A=
 	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1210)},=0A=
+	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1214)},=0A=
 	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1220)},=0A=
 	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1230)},=0A=
 	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1260)},=0A=
 	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1270)},=0A=
 	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1280)},=0A=
-	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1380)},=0A=
-	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1381)},=0A=
 	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1680)},=0A=
 	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1681)},=0A=
 	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1880)},=0A=
@@ -166,23 +168,33 @@ static struct pci_driver arcmsr_pci_driv=0A=
 	.id_table			=3D arcmsr_device_id_table,=0A=
 	.probe			=3D arcmsr_probe,=0A=
 	.remove			=3D arcmsr_remove,=0A=
+		.suspend		=3D arcmsr_suspend,=0A=
+		.resume		=3D arcmsr_resume,=0A=
 	.shutdown		=3D arcmsr_shutdown,=0A=
 };=0A=
 /*=0A=
 =
*************************************************************************=
***=0A=
 =
*************************************************************************=
***=0A=
 */=0A=
-=0A=
-static void arcmsr_free_hbb_mu(struct AdapterControlBlock *acb)=0A=
+static void arcmsr_free_mu(struct AdapterControlBlock *acb)=0A=
 {=0A=
 	switch (acb->adapter_type) {=0A=
 	case ACB_ADAPTER_TYPE_A:=0A=
 	case ACB_ADAPTER_TYPE_C:=0A=
 		break;=0A=
-	case ACB_ADAPTER_TYPE_B:{=0A=
+	case ACB_ADAPTER_TYPE_B: {=0A=
+		struct MessageUnit_B __iomem *reg =3D acb->pmuB;=0A=
 		dma_free_coherent(&acb->pdev->dev,=0A=
 			sizeof(struct MessageUnit_B),=0A=
-			acb->pmuB, acb->dma_coherent_handle_hbb_mu);=0A=
+			reg, acb->dma_coherent_handle2);=0A=
+		break;=0A=
+	}=0A=
+	case ACB_ADAPTER_TYPE_D: {=0A=
+		dma_free_coherent(&acb->pdev->dev,=0A=
+			acb->roundup_ccbsize,=0A=
+			acb->dma_coherent2,=0A=
+			acb->dma_coherent_handle2);=0A=
+		break;=0A=
 	}=0A=
 	}=0A=
 }=0A=
@@ -190,44 +202,73 @@ static void arcmsr_free_hbb_mu(struct Ad=0A=
 static bool arcmsr_remap_pciregion(struct AdapterControlBlock *acb)=0A=
 {=0A=
 	struct pci_dev *pdev =3D acb->pdev;=0A=
-	switch (acb->adapter_type){=0A=
-	case ACB_ADAPTER_TYPE_A:{=0A=
-		acb->pmuA =3D ioremap(pci_resource_start(pdev,0), =
pci_resource_len(pdev,0));=0A=
+	switch (acb->adapter_type) {=0A=
+	case ACB_ADAPTER_TYPE_A: {=0A=
+		acb->pmuA =3D ioremap(pci_resource_start(pdev, 0),=0A=
+			pci_resource_len(pdev, 0));=0A=
 		if (!acb->pmuA) {=0A=
-			printk(KERN_NOTICE "arcmsr%d: memory mapping region fail \n", =
acb->host->host_no);=0A=
+			pr_notice("arcmsr%d: memory mapping "=0A=
+				"region fail\n", acb->host->host_no);=0A=
 			return false;=0A=
 		}=0A=
 		break;=0A=
 	}=0A=
-	case ACB_ADAPTER_TYPE_B:{=0A=
+	case ACB_ADAPTER_TYPE_B: {=0A=
 		void __iomem *mem_base0, *mem_base1;=0A=
-		mem_base0 =3D ioremap(pci_resource_start(pdev, 0), =
pci_resource_len(pdev, 0));=0A=
+		mem_base0 =3D ioremap(pci_resource_start(pdev, 0),=0A=
+			pci_resource_len(pdev, 0));=0A=
 		if (!mem_base0) {=0A=
-			printk(KERN_NOTICE "arcmsr%d: memory mapping region fail \n", =
acb->host->host_no);=0A=
+			pr_notice("arcmsr%d: memory mapping "=0A=
+				"region fail\n", acb->host->host_no);=0A=
 			return false;=0A=
 		}=0A=
-		mem_base1 =3D ioremap(pci_resource_start(pdev, 2), =
pci_resource_len(pdev, 2));=0A=
+		mem_base1 =3D ioremap(pci_resource_start(pdev, 2),=0A=
+			pci_resource_len(pdev, 2));=0A=
 		if (!mem_base1) {=0A=
 			iounmap(mem_base0);=0A=
-			printk(KERN_NOTICE "arcmsr%d: memory mapping region fail \n", =
acb->host->host_no);=0A=
+			pr_notice("arcmsr%d: memory mapping "=0A=
+				"region fail\n", acb->host->host_no);=0A=
 			return false;=0A=
 		}=0A=
 		acb->mem_base0 =3D mem_base0;=0A=
 		acb->mem_base1 =3D mem_base1;=0A=
 		break;=0A=
 	}=0A=
-	case ACB_ADAPTER_TYPE_C:{=0A=
-		acb->pmuC =3D ioremap_nocache(pci_resource_start(pdev, 1), =
pci_resource_len(pdev, 1));=0A=
+	case ACB_ADAPTER_TYPE_C: {=0A=
+		acb->pmuC =3D ioremap_nocache(pci_resource_start(pdev, 1),=0A=
+			pci_resource_len(pdev, 1));=0A=
 		if (!acb->pmuC) {=0A=
-			printk(KERN_NOTICE "arcmsr%d: memory mapping region fail \n", =
acb->host->host_no);=0A=
+			pr_notice("arcmsr%d: memory mapping "=0A=
+				"region fail\n", acb->host->host_no);=0A=
 			return false;=0A=
 		}=0A=
-		if (readl(&acb->pmuC->outbound_doorbell) & =
ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE) {=0A=
-			writel(ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE_DOORBELL_CLEAR, =
&acb->pmuC->outbound_doorbell_clear);/*clear interrupt*/=0A=
+		if (readl(&acb->pmuC->outbound_doorbell) &=0A=
+			ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE) {=0A=
+			writel(ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE_DOORBELL_CLEAR,=0A=
+				&acb->pmuC->outbound_doorbell_clear);=0A=
 			return true;=0A=
 		}=0A=
 		break;=0A=
 	}=0A=
+	case ACB_ADAPTER_TYPE_D: {=0A=
+		void __iomem *mem_base0;=0A=
+		unsigned long addr, range, flags;=0A=
+=0A=
+		addr =3D (unsigned long)pci_resource_start(pdev, 0);=0A=
+		range =3D pci_resource_len(pdev, 0);=0A=
+		flags =3D pci_resource_flags(pdev, 0);=0A=
+		if (flags & IORESOURCE_CACHEABLE)=0A=
+			mem_base0 =3D ioremap(addr, range);=0A=
+		else=0A=
+			mem_base0 =3D ioremap_nocache(addr, range);=0A=
+		if (!mem_base0) {=0A=
+			pr_notice("arcmsr%d: memory mapping region fail\n",=0A=
+			acb->host->host_no);=0A=
+			return false;=0A=
+		}=0A=
+		acb->mem_base0 =3D mem_base0;=0A=
+		break;=0A=
+	}=0A=
 	}=0A=
 	return true;=0A=
 }=0A=
@@ -235,18 +276,22 @@ static bool arcmsr_remap_pciregion(struc=0A=
 static void arcmsr_unmap_pciregion(struct AdapterControlBlock *acb)=0A=
 {=0A=
 	switch (acb->adapter_type) {=0A=
-	case ACB_ADAPTER_TYPE_A:{=0A=
+	case ACB_ADAPTER_TYPE_A: {=0A=
 		iounmap(acb->pmuA);=0A=
+		break;=0A=
 	}=0A=
-	break;=0A=
-	case ACB_ADAPTER_TYPE_B:{=0A=
+	case ACB_ADAPTER_TYPE_B: {=0A=
 		iounmap(acb->mem_base0);=0A=
 		iounmap(acb->mem_base1);=0A=
+		break;=0A=
 	}=0A=
-=0A=
-	break;=0A=
-	case ACB_ADAPTER_TYPE_C:{=0A=
+	case ACB_ADAPTER_TYPE_C: {=0A=
 		iounmap(acb->pmuC);=0A=
+		break;=0A=
+	}=0A=
+	case ACB_ADAPTER_TYPE_D: {=0A=
+		iounmap(acb->mem_base0);=0A=
+		break;=0A=
 	}=0A=
 	}=0A=
 }=0A=
@@ -264,12 +309,13 @@ static int arcmsr_bios_param(struct scsi=0A=
 		struct block_device *bdev, sector_t capacity, int *geom)=0A=
 {=0A=
 	int ret, heads, sectors, cylinders, total_capacity;=0A=
-	unsigned char *buffer;/* return copy of block device's partition table =
*/=0A=
+	unsigned char *buffer;=0A=
 =0A=
 	buffer =3D scsi_bios_ptable(bdev);=0A=
 	if (buffer) {=0A=
-		ret =3D scsi_partsize(buffer, capacity, &geom[2], &geom[0], &geom[1]);=0A=
-		kfree(buffer);=0A=
+		ret =3D scsi_partsize(buffer, capacity, &geom[2], &geom[0],=0A=
+			&geom[1]);=0A=
+		kfree((const void *)buffer);=0A=
 		if (ret !=3D -1)=0A=
 			return ret;=0A=
 	}=0A=
@@ -288,27 +334,53 @@ static int arcmsr_bios_param(struct scsi=0A=
 	return 0;=0A=
 }=0A=
 =0A=
-static void arcmsr_define_adapter_type(struct AdapterControlBlock *acb)=0A=
+static bool=0A=
+arcmsr_define_adapter_type(struct AdapterControlBlock *acb)=0A=
 {=0A=
-	struct pci_dev *pdev =3D acb->pdev;=0A=
 	u16 dev_id;=0A=
+	struct pci_dev *pdev =3D acb->pdev;=0A=
+=0A=
 	pci_read_config_word(pdev, PCI_DEVICE_ID, &dev_id);=0A=
 	acb->dev_id =3D dev_id;=0A=
 	switch (dev_id) {=0A=
 	case 0x1880: {=0A=
 		acb->adapter_type =3D ACB_ADAPTER_TYPE_C;=0A=
-		}=0A=
 		break;=0A=
-	case 0x1201: {=0A=
+	}=0A=
+	case 0x1200:=0A=
+	case 0x1201:=0A=
+	case 0x1202: {=0A=
 		acb->adapter_type =3D ACB_ADAPTER_TYPE_B;=0A=
-		}=0A=
 		break;=0A=
-=0A=
-	default: acb->adapter_type =3D ACB_ADAPTER_TYPE_A;=0A=
 	}=0A=
+	case 0x1110:=0A=
+	case 0x1120:=0A=
+	case 0x1130:=0A=
+	case 0x1160:=0A=
+	case 0x1170:=0A=
+	case 0x1210:=0A=
+	case 0x1220:=0A=
+	case 0x1230:=0A=
+	case 0x1260:=0A=
+	case 0x1280:=0A=
+	case 0x1680: {=0A=
+		acb->adapter_type =3D ACB_ADAPTER_TYPE_A;=0A=
+		break;=0A=
+	}=0A=
+	case 0x1214: {=0A=
+		acb->adapter_type =3D ACB_ADAPTER_TYPE_D;=0A=
+		break;=0A=
+	}=0A=
+	default: {=0A=
+		pr_notice("Unknown device ID =3D 0x%x\n", dev_id);=0A=
+		return false;=0A=
+	}=0A=
+	}=0A=
+	return true;=0A=
 }=0A=
 =0A=
-static uint8_t arcmsr_hba_wait_msgint_ready(struct AdapterControlBlock =
*acb)=0A=
+static bool=0A=
+arcmsr_hbaA_wait_msgint_ready(struct AdapterControlBlock *acb)=0A=
 {=0A=
 	struct MessageUnit_A __iomem *reg =3D acb->pmuA;=0A=
 	int i;=0A=
@@ -326,9 +398,10 @@ static uint8_t arcmsr_hba_wait_msgint_re=0A=
 	return false;=0A=
 }=0A=
 =0A=
-static uint8_t arcmsr_hbb_wait_msgint_ready(struct AdapterControlBlock =
*acb)=0A=
+static bool=0A=
+arcmsr_hbaB_wait_msgint_ready(struct AdapterControlBlock *acb)=0A=
 {=0A=
-	struct MessageUnit_B *reg =3D acb->pmuB;=0A=
+	struct MessageUnit_B __iomem *reg =3D acb->pmuB;=0A=
 	int i;=0A=
 =0A=
 	for (i =3D 0; i < 2000; i++) {=0A=
@@ -346,282 +419,557 @@ static uint8_t arcmsr_hbb_wait_msgint_re=0A=
 	return false;=0A=
 }=0A=
 =0A=
-static uint8_t arcmsr_hbc_wait_msgint_ready(struct AdapterControlBlock =
*pACB)=0A=
+static bool=0A=
+arcmsr_hbaC_wait_msgint_ready(struct AdapterControlBlock *pACB)=0A=
 {=0A=
-	struct MessageUnit_C *phbcmu =3D (struct MessageUnit_C *)pACB->pmuC;=0A=
+	struct MessageUnit_C __iomem *phbcmu =3D pACB->pmuC;=0A=
 	int i;=0A=
 =0A=
 	for (i =3D 0; i < 2000; i++) {=0A=
 		if (readl(&phbcmu->outbound_doorbell)=0A=
-				& ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE) {=0A=
+			& ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE) {=0A=
 			writel(ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE_DOORBELL_CLEAR,=0A=
-				&phbcmu->outbound_doorbell_clear); /*clear interrupt*/=0A=
+			&phbcmu->outbound_doorbell_clear);=0A=
 			return true;=0A=
 		}=0A=
 		msleep(10);=0A=
-	} /* max 20 seconds */=0A=
+	}=0A=
+	return false;=0A=
+}=0A=
 =0A=
+static bool=0A=
+arcmsr_hbaD_wait_msgint_ready(struct AdapterControlBlock *pACB)=0A=
+{=0A=
+	int i;=0A=
+	struct MessageUnit_D __iomem *reg =3D pACB->pmuD;=0A=
+	for (i =3D 0; i < 2000; i++) {=0A=
+		if (readl(reg->outbound_doorbell)=0A=
+			& ARCMSR_ARC1214_IOP2DRV_MESSAGE_CMD_DONE) {=0A=
+			writel(ARCMSR_ARC1214_IOP2DRV_MESSAGE_CMD_DONE,=0A=
+				reg->outbound_doorbell);=0A=
+			return true;=0A=
+		}=0A=
+		msleep(10);=0A=
+	} /* max 20 seconds */=0A=
 	return false;=0A=
 }=0A=
 =0A=
-static void arcmsr_flush_hba_cache(struct AdapterControlBlock *acb)=0A=
+static void=0A=
+arcmsr_hbaA_flush_cache(struct AdapterControlBlock *acb)=0A=
 {=0A=
 	struct MessageUnit_A __iomem *reg =3D acb->pmuA;=0A=
 	int retry_count =3D 30;=0A=
 	writel(ARCMSR_INBOUND_MESG0_FLUSH_CACHE, &reg->inbound_msgaddr0);=0A=
 	do {=0A=
-		if (arcmsr_hba_wait_msgint_ready(acb))=0A=
+		if (arcmsr_hbaA_wait_msgint_ready(acb))=0A=
 			break;=0A=
 		else {=0A=
 			retry_count--;=0A=
-			printk(KERN_NOTICE "arcmsr%d: wait 'flush adapter cache' \=0A=
-			timeout, retry count down =3D %d \n", acb->host->host_no, =
retry_count);=0A=
+			pr_notice("arcmsr%d: wait 'flush adapter "=0A=
+			"cache' timeout, retry count down =3D %d\n",=0A=
+			acb->host->host_no, retry_count);=0A=
 		}=0A=
 	} while (retry_count !=3D 0);=0A=
 }=0A=
 =0A=
-static void arcmsr_flush_hbb_cache(struct AdapterControlBlock *acb)=0A=
+static void=0A=
+arcmsr_hbaB_flush_cache(struct AdapterControlBlock *acb)=0A=
 {=0A=
-	struct MessageUnit_B *reg =3D acb->pmuB;=0A=
+	struct MessageUnit_B __iomem *reg =3D acb->pmuB;=0A=
 	int retry_count =3D 30;=0A=
 	writel(ARCMSR_MESSAGE_FLUSH_CACHE, reg->drv2iop_doorbell);=0A=
 	do {=0A=
-		if (arcmsr_hbb_wait_msgint_ready(acb))=0A=
+		if (arcmsr_hbaB_wait_msgint_ready(acb))=0A=
 			break;=0A=
 		else {=0A=
 			retry_count--;=0A=
-			printk(KERN_NOTICE "arcmsr%d: wait 'flush adapter cache' \=0A=
-			timeout,retry count down =3D %d \n", acb->host->host_no, =
retry_count);=0A=
+			pr_notice("arcmsr%d: wait 'flush adapter "=0A=
+			"cache' timeout, retry count down =3D %d\n",=0A=
+			acb->host->host_no, retry_count);=0A=
 		}=0A=
 	} while (retry_count !=3D 0);=0A=
 }=0A=
 =0A=
-static void arcmsr_flush_hbc_cache(struct AdapterControlBlock *pACB)=0A=
+static void=0A=
+arcmsr_hbaC_flush_cache(struct AdapterControlBlock *pACB)=0A=
 {=0A=
-	struct MessageUnit_C *reg =3D (struct MessageUnit_C *)pACB->pmuC;=0A=
-	int retry_count =3D 30;/* enlarge wait flush adapter cache time: 10 =
minute */=0A=
-	writel(ARCMSR_INBOUND_MESG0_FLUSH_CACHE, &reg->inbound_msgaddr0);=0A=
-	writel(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE, &reg->inbound_doorbell);=0A=
+	struct MessageUnit_C __iomem *reg =3D pACB->pmuC;=0A=
+	int retry_count =3D 6;/* enlarge wait flush adapter cache time: 10 =
minute */=0A=
+	writel(ARCMSR_INBOUND_MESG0_FLUSH_CACHE,=0A=
+		&reg->inbound_msgaddr0);=0A=
+	writel(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE,=0A=
+		&reg->inbound_doorbell);=0A=
+	readl(&reg->inbound_doorbell);=0A=
+	readl(&reg->inbound_msgaddr0);=0A=
 	do {=0A=
-		if (arcmsr_hbc_wait_msgint_ready(pACB)) {=0A=
+		if (arcmsr_hbaC_wait_msgint_ready(pACB))=0A=
 			break;=0A=
-		} else {=0A=
+		else {=0A=
+			retry_count--;=0A=
+			pr_notice("arcmsr%d: wait 'flush adapter "=0A=
+			"cache' timeout, retry count down =3D %d\n",=0A=
+			pACB->host->host_no, retry_count);=0A=
+		}=0A=
+	} while (retry_count !=3D 0);=0A=
+	return;=0A=
+}=0A=
+=0A=
+static void=0A=
+arcmsr_hbaD_flush_cache(struct AdapterControlBlock *pACB)=0A=
+{=0A=
+	int retry_count =3D 6;=0A=
+	struct MessageUnit_D __iomem *reg =3D pACB->pmuD;=0A=
+=0A=
+	writel(ARCMSR_INBOUND_MESG0_FLUSH_CACHE,=0A=
+		reg->inbound_msgaddr0);=0A=
+	do {=0A=
+		if (arcmsr_hbaD_wait_msgint_ready(pACB))=0A=
+			break;=0A=
+		else {=0A=
 			retry_count--;=0A=
-			printk(KERN_NOTICE "arcmsr%d: wait 'flush adapter cache' \=0A=
-			timeout,retry count down =3D %d \n", pACB->host->host_no, =
retry_count);=0A=
+			pr_notice("arcmsr%d: wait 'flush adapter "=0A=
+			"cache' timeout, retry count down =3D %d\n",=0A=
+			pACB->host->host_no,=0A=
+			retry_count);=0A=
 		}=0A=
 	} while (retry_count !=3D 0);=0A=
 	return;=0A=
 }=0A=
-static void arcmsr_flush_adapter_cache(struct AdapterControlBlock *acb)=0A=
+=0A=
+static void=0A=
+arcmsr_flush_adapter_cache(struct AdapterControlBlock *acb)=0A=
 {=0A=
 	switch (acb->adapter_type) {=0A=
 =0A=
 	case ACB_ADAPTER_TYPE_A: {=0A=
-		arcmsr_flush_hba_cache(acb);=0A=
-		}=0A=
+		arcmsr_hbaA_flush_cache(acb);=0A=
 		break;=0A=
-=0A=
-	case ACB_ADAPTER_TYPE_B: {=0A=
-		arcmsr_flush_hbb_cache(acb);=0A=
 		}=0A=
+	case ACB_ADAPTER_TYPE_B: {=0A=
+		arcmsr_hbaB_flush_cache(acb);=0A=
 		break;=0A=
+		}=0A=
 	case ACB_ADAPTER_TYPE_C: {=0A=
-		arcmsr_flush_hbc_cache(acb);=0A=
+		arcmsr_hbaC_flush_cache(acb);=0A=
+		break;=0A=
 		}=0A=
+	case ACB_ADAPTER_TYPE_D: {=0A=
+		arcmsr_hbaD_flush_cache(acb);=0A=
+		break;=0A=
+	}=0A=
 	}=0A=
 }=0A=
 =0A=
-static int arcmsr_alloc_ccb_pool(struct AdapterControlBlock *acb)=0A=
+static int=0A=
+arcmsr_alloc_ccb_pool(struct AdapterControlBlock *acb)=0A=
 {=0A=
 	struct pci_dev *pdev =3D acb->pdev;=0A=
 	void *dma_coherent;=0A=
 	dma_addr_t dma_coherent_handle;=0A=
-	struct CommandControlBlock *ccb_tmp;=0A=
+	struct CommandControlBlock *ccb_tmp =3D NULL;=0A=
 	int i =3D 0, j =3D 0;=0A=
 	dma_addr_t cdb_phyaddr;=0A=
-	unsigned long roundup_ccbsize;=0A=
+	unsigned long roundup_ccbsize =3D 0;=0A=
 	unsigned long max_xfer_len;=0A=
 	unsigned long max_sg_entrys;=0A=
 	uint32_t  firm_config_version;=0A=
 =0A=
-	for (i =3D 0; i < ARCMSR_MAX_TARGETID; i++)=0A=
-		for (j =3D 0; j < ARCMSR_MAX_TARGETLUN; j++)=0A=
-			acb->devstate[i][j] =3D ARECA_RAID_GONE;=0A=
-=0A=
 	max_xfer_len =3D ARCMSR_MAX_XFER_LEN;=0A=
 	max_sg_entrys =3D ARCMSR_DEFAULT_SG_ENTRIES;=0A=
 	firm_config_version =3D acb->firm_cfg_version;=0A=
-	if((firm_config_version & 0xFF) >=3D 3){=0A=
-		max_xfer_len =3D (ARCMSR_CDB_SG_PAGE_LENGTH << ((firm_config_version =
>> 8) & 0xFF)) * 1024;/* max 4M byte */=0A=
-		max_sg_entrys =3D (max_xfer_len/4096);=0A=
+	if ((firm_config_version & 0xFF) >=3D 3) {=0A=
+		max_xfer_len =3D (ARCMSR_CDB_SG_PAGE_LENGTH <<=0A=
+			((firm_config_version >> 8) & 0xFF)) * 1024;=0A=
+		max_sg_entrys =3D (max_xfer_len / 4096);=0A=
 	}=0A=
-	acb->host->max_sectors =3D max_xfer_len/512;=0A=
+	acb->host->max_sectors =3D max_xfer_len / 512;=0A=
 	acb->host->sg_tablesize =3D max_sg_entrys;=0A=
-	roundup_ccbsize =3D roundup(sizeof(struct CommandControlBlock) + =
(max_sg_entrys - 1) * sizeof(struct SG64ENTRY), 32);=0A=
+	switch (acb->adapter_type) {=0A=
+	case ACB_ADAPTER_TYPE_A:=0A=
+		roundup_ccbsize =3D roundup(sizeof(struct CommandControlBlock) +=0A=
+		max_sg_entrys * sizeof(struct SG64ENTRY), 32);=0A=
+		break;=0A=
+	case ACB_ADAPTER_TYPE_B:=0A=
+	case ACB_ADAPTER_TYPE_C:=0A=
+	case ACB_ADAPTER_TYPE_D:=0A=
+		roundup_ccbsize =3D roundup(sizeof(struct CommandControlBlock) +=0A=
+		(max_sg_entrys - 1) * sizeof(struct SG64ENTRY), 32);=0A=
+		break;=0A=
+	}=0A=
 	acb->uncache_size =3D roundup_ccbsize * ARCMSR_MAX_FREECCB_NUM;=0A=
-	dma_coherent =3D dma_alloc_coherent(&pdev->dev, acb->uncache_size, =
&dma_coherent_handle, GFP_KERNEL);=0A=
-	if(!dma_coherent){=0A=
-		printk(KERN_NOTICE "arcmsr%d: dma_alloc_coherent got error\n", =
acb->host->host_no);=0A=
+	dma_coherent =3D dma_alloc_coherent(&pdev->dev,=0A=
+		acb->uncache_size, &dma_coherent_handle, GFP_KERNEL);=0A=
+	if (!dma_coherent) {=0A=
+		pr_notice("arcmsr%d: dma_alloc_coherent got error\n",=0A=
+		acb->host->host_no);=0A=
 		return -ENOMEM;=0A=
 	}=0A=
+	memset(dma_coherent, 0, acb->uncache_size);=0A=
 	acb->dma_coherent =3D dma_coherent;=0A=
 	acb->dma_coherent_handle =3D dma_coherent_handle;=0A=
-	memset(dma_coherent, 0, acb->uncache_size);=0A=
-	ccb_tmp =3D dma_coherent;=0A=
-	acb->vir2phy_offset =3D (unsigned long)dma_coherent - (unsigned =
long)dma_coherent_handle;=0A=
-	for(i =3D 0; i < ARCMSR_MAX_FREECCB_NUM; i++){=0A=
-		cdb_phyaddr =3D dma_coherent_handle + offsetof(struct =
CommandControlBlock, arcmsr_cdb);=0A=
-		ccb_tmp->cdb_phyaddr_pattern =3D ((acb->adapter_type =3D=3D =
ACB_ADAPTER_TYPE_C) ? cdb_phyaddr : (cdb_phyaddr >> 5));=0A=
+	ccb_tmp =3D (struct CommandControlBlock *)dma_coherent;=0A=
+	acb->vir2phy_offset =3D (unsigned long)dma_coherent -=0A=
+		(unsigned long)dma_coherent_handle;=0A=
+	for (i =3D 0; i < ARCMSR_MAX_FREECCB_NUM; i++) {=0A=
+		cdb_phyaddr =3D dma_coherent_handle +=0A=
+			offsetof(struct CommandControlBlock, arcmsr_cdb);=0A=
+		switch (acb->adapter_type) {=0A=
+		case ACB_ADAPTER_TYPE_A:=0A=
+		case ACB_ADAPTER_TYPE_B:=0A=
+			ccb_tmp->cdb_phyaddr =3D cdb_phyaddr >> 5;=0A=
+			break;=0A=
+		case ACB_ADAPTER_TYPE_C:=0A=
+		case ACB_ADAPTER_TYPE_D:=0A=
+			ccb_tmp->cdb_phyaddr =3D cdb_phyaddr;=0A=
+			break;=0A=
+		}=0A=
 		acb->pccb_pool[i] =3D ccb_tmp;=0A=
 		ccb_tmp->acb =3D acb;=0A=
 		INIT_LIST_HEAD(&ccb_tmp->list);=0A=
 		list_add_tail(&ccb_tmp->list, &acb->ccb_free_list);=0A=
-		ccb_tmp =3D (struct CommandControlBlock *)((unsigned long)ccb_tmp + =
roundup_ccbsize);=0A=
+		ccb_tmp =3D (struct CommandControlBlock *)=0A=
+		((unsigned long)ccb_tmp + roundup_ccbsize);=0A=
 		dma_coherent_handle =3D dma_coherent_handle + roundup_ccbsize;=0A=
 	}=0A=
+	for (i =3D 0; i < ARCMSR_MAX_TARGETID; i++)=0A=
+		for (j =3D 0; j < ARCMSR_MAX_TARGETLUN; j++)=0A=
+			acb->devstate[i][j] =3D ARECA_RAID_GONE;=0A=
 	return 0;=0A=
 }=0A=
 =0A=
-static void arcmsr_message_isr_bh_fn(struct work_struct *work) =0A=
+static void=0A=
+arcmsr_message_isr_bh_fn(struct work_struct *work)=0A=
 {=0A=
-	struct AdapterControlBlock *acb =3D container_of(work,struct =
AdapterControlBlock, arcmsr_do_message_isr_bh);=0A=
+	struct AdapterControlBlock *acb =3D container_of(work,=0A=
+		struct AdapterControlBlock, arcmsr_do_message_isr_bh);=0A=
 	switch (acb->adapter_type) {=0A=
-		case ACB_ADAPTER_TYPE_A: {=0A=
-=0A=
-			struct MessageUnit_A __iomem *reg  =3D acb->pmuA;=0A=
-			char *acb_dev_map =3D (char *)acb->device_map;=0A=
-			uint32_t __iomem *signature =3D (uint32_t __iomem*) =
(&reg->message_rwbuffer[0]);=0A=
-			char __iomem *devicemap =3D (char __iomem*) =
(&reg->message_rwbuffer[21]);=0A=
-			int target, lun;=0A=
-			struct scsi_device *psdev;=0A=
-			char diff;=0A=
-=0A=
-			atomic_inc(&acb->rq_map_token);=0A=
-			if (readl(signature) =3D=3D ARCMSR_SIGNATURE_GET_CONFIG) {=0A=
-				for(target =3D 0; target < ARCMSR_MAX_TARGETID -1; target++) {=0A=
-					diff =3D (*acb_dev_map)^readb(devicemap);=0A=
-					if (diff !=3D 0) {=0A=
-						char temp;=0A=
-						*acb_dev_map =3D readb(devicemap);=0A=
-						temp =3D*acb_dev_map;=0A=
-						for(lun =3D 0; lun < ARCMSR_MAX_TARGETLUN; lun++) {=0A=
-							if((temp & 0x01)=3D=3D1 && (diff & 0x01) =3D=3D 1) {	=0A=
-								scsi_add_device(acb->host, 0, target, lun);=0A=
-							}else if((temp & 0x01) =3D=3D 0 && (diff & 0x01) =3D=3D 1) {=0A=
-								psdev =3D scsi_device_lookup(acb->host, 0, target, lun);=0A=
-								if (psdev !=3D NULL ) {=0A=
-									scsi_remove_device(psdev);=0A=
-									scsi_device_put(psdev);=0A=
-								}=0A=
+	case ACB_ADAPTER_TYPE_A: {=0A=
+		struct MessageUnit_A __iomem *reg  =3D acb->pmuA;=0A=
+		char *acb_dev_map =3D (char *)acb->device_map;=0A=
+		uint32_t __iomem *signature =3D (uint32_t __iomem *)=0A=
+			(&reg->message_rwbuffer[0]);=0A=
+		char __iomem *devicemap =3D (char __iomem *)=0A=
+			(&reg->message_rwbuffer[21]);=0A=
+		int target, lun;=0A=
+		struct scsi_device *psdev;=0A=
+		char diff;=0A=
+=0A=
+		atomic_inc(&acb->rq_map_token);=0A=
+		if (readl(signature) =3D=3D ARCMSR_SIGNATURE_GET_CONFIG) {=0A=
+			for (target =3D 0; target < ARCMSR_MAX_TARGETID - 1;=0A=
+			target++) {=0A=
+				diff =3D (*acb_dev_map) ^ readb(devicemap);=0A=
+				if (diff !=3D 0) {=0A=
+					char temp;=0A=
+					*acb_dev_map =3D readb(devicemap);=0A=
+					temp =3D *acb_dev_map;=0A=
+					for (lun =3D 0; lun <=0A=
+					ARCMSR_MAX_TARGETLUN; lun++) {=0A=
+						if ((temp & 0x01) =3D=3D 1 &&=0A=
+						(diff & 0x01) =3D=3D 1) {=0A=
+							scsi_add_device(acb->host,=0A=
+							0, target, lun);=0A=
+						} else if ((temp & 0x01) =3D=3D 0=0A=
+						&& (diff & 0x01) =3D=3D 1) {=0A=
+							psdev =3D=0A=
+							scsi_device_lookup(acb->host,=0A=
+							0, target, lun);=0A=
+							if (psdev !=3D NULL) {=0A=
+								scsi_remove_device(psdev);=0A=
+								scsi_device_put(psdev);=0A=
 							}=0A=
-							temp >>=3D 1;=0A=
-							diff >>=3D 1;=0A=
 						}=0A=
+						temp >>=3D 1;=0A=
+						diff >>=3D 1;=0A=
 					}=0A=
-					devicemap++;=0A=
-					acb_dev_map++;=0A=
 				}=0A=
+				devicemap++;=0A=
+				acb_dev_map++;=0A=
 			}=0A=
-			break;=0A=
 		}=0A=
+		break;=0A=
+	}=0A=
 =0A=
-		case ACB_ADAPTER_TYPE_B: {=0A=
-			struct MessageUnit_B *reg  =3D acb->pmuB;=0A=
-			char *acb_dev_map =3D (char *)acb->device_map;=0A=
-			uint32_t __iomem *signature =3D (uint32_t =
__iomem*)(&reg->message_rwbuffer[0]);=0A=
-			char __iomem *devicemap =3D (char =
__iomem*)(&reg->message_rwbuffer[21]);=0A=
-			int target, lun;=0A=
-			struct scsi_device *psdev;=0A=
-			char diff;=0A=
-=0A=
-			atomic_inc(&acb->rq_map_token);=0A=
-			if (readl(signature) =3D=3D ARCMSR_SIGNATURE_GET_CONFIG) {=0A=
-				for(target =3D 0; target < ARCMSR_MAX_TARGETID -1; target++) {=0A=
-					diff =3D (*acb_dev_map)^readb(devicemap);=0A=
-					if (diff !=3D 0) {=0A=
-						char temp;=0A=
-						*acb_dev_map =3D readb(devicemap);=0A=
-						temp =3D*acb_dev_map;=0A=
-						for(lun =3D 0; lun < ARCMSR_MAX_TARGETLUN; lun++) {=0A=
-							if((temp & 0x01)=3D=3D1 && (diff & 0x01) =3D=3D 1) {	=0A=
-								scsi_add_device(acb->host, 0, target, lun);=0A=
-							}else if((temp & 0x01) =3D=3D 0 && (diff & 0x01) =3D=3D 1) {=0A=
-								psdev =3D scsi_device_lookup(acb->host, 0, target, lun);=0A=
-								if (psdev !=3D NULL ) {=0A=
-									scsi_remove_device(psdev);=0A=
-									scsi_device_put(psdev);=0A=
-								}=0A=
+	case ACB_ADAPTER_TYPE_B: {=0A=
+		struct MessageUnit_B __iomem *reg  =3D acb->pmuB;=0A=
+		char *acb_dev_map =3D (char *)acb->device_map;=0A=
+		uint32_t __iomem *signature =3D=0A=
+			(uint32_t __iomem *)(&reg->message_rwbuffer[0]);=0A=
+		char __iomem *devicemap =3D=0A=
+			(char __iomem *)(&reg->message_rwbuffer[21]);=0A=
+		int target, lun;=0A=
+		struct scsi_device *psdev;=0A=
+		char diff;=0A=
+=0A=
+		atomic_inc(&acb->rq_map_token);=0A=
+		if (readl(signature) =3D=3D ARCMSR_SIGNATURE_GET_CONFIG) {=0A=
+			for (target =3D 0; target <=0A=
+			ARCMSR_MAX_TARGETID - 1; target++) {=0A=
+				diff =3D (*acb_dev_map) ^ readb(devicemap);=0A=
+				if (diff !=3D 0) {=0A=
+					char temp;=0A=
+					*acb_dev_map =3D readb(devicemap);=0A=
+					temp =3D *acb_dev_map;=0A=
+					for (lun =3D 0;=0A=
+					lun < ARCMSR_MAX_TARGETLUN;=0A=
+					lun++) {=0A=
+						if ((temp & 0x01) =3D=3D 1 &&=0A=
+						(diff & 0x01) =3D=3D 1) {=0A=
+							scsi_add_device(acb->host,=0A=
+							0, target, lun);=0A=
+						} else if ((temp & 0x01) =3D=3D 0=0A=
+						&& (diff & 0x01) =3D=3D 1) {=0A=
+							psdev =3D scsi_device_lookup(acb->host,=0A=
+							0, target, lun);=0A=
+							if (psdev !=3D NULL) {=0A=
+								scsi_remove_device(psdev);=0A=
+								scsi_device_put(psdev);=0A=
 							}=0A=
-							temp >>=3D 1;=0A=
-							diff >>=3D 1;=0A=
 						}=0A=
+						temp >>=3D 1;=0A=
+						diff >>=3D 1;=0A=
 					}=0A=
-					devicemap++;=0A=
-					acb_dev_map++;=0A=
 				}=0A=
+				devicemap++;=0A=
+				acb_dev_map++;=0A=
 			}=0A=
 		}=0A=
-		break;=0A=
-		case ACB_ADAPTER_TYPE_C: {=0A=
-			struct MessageUnit_C *reg  =3D acb->pmuC;=0A=
-			char *acb_dev_map =3D (char *)acb->device_map;=0A=
-			uint32_t __iomem *signature =3D (uint32_t __iomem =
*)(&reg->msgcode_rwbuffer[0]);=0A=
-			char __iomem *devicemap =3D (char __iomem =
*)(&reg->msgcode_rwbuffer[21]);=0A=
-			int target, lun;=0A=
-			struct scsi_device *psdev;=0A=
-			char diff;=0A=
-=0A=
-			atomic_inc(&acb->rq_map_token);=0A=
-			if (readl(signature) =3D=3D ARCMSR_SIGNATURE_GET_CONFIG) {=0A=
-				for (target =3D 0; target < ARCMSR_MAX_TARGETID - 1; target++) {=0A=
-					diff =3D (*acb_dev_map)^readb(devicemap);=0A=
-					if (diff !=3D 0) {=0A=
-						char temp;=0A=
-						*acb_dev_map =3D readb(devicemap);=0A=
-						temp =3D *acb_dev_map;=0A=
-						for (lun =3D 0; lun < ARCMSR_MAX_TARGETLUN; lun++) {=0A=
-							if ((temp & 0x01) =3D=3D 1 && (diff & 0x01) =3D=3D 1) {=0A=
-								scsi_add_device(acb->host, 0, target, lun);=0A=
-							} else if ((temp & 0x01) =3D=3D 0 && (diff & 0x01) =3D=3D 1) {=0A=
-								psdev =3D scsi_device_lookup(acb->host, 0, target, lun);=0A=
-								if (psdev !=3D NULL) {=0A=
-									scsi_remove_device(psdev);=0A=
-									scsi_device_put(psdev);=0A=
-								}=0A=
+	}=0A=
+	break;=0A=
+	case ACB_ADAPTER_TYPE_C: {=0A=
+		struct MessageUnit_C __iomem *reg  =3D acb->pmuC;=0A=
+		char *acb_dev_map =3D (char *)acb->device_map;=0A=
+		uint32_t __iomem *signature =3D=0A=
+			(uint32_t __iomem *)(&reg->msgcode_rwbuffer[0]);=0A=
+		char __iomem *devicemap =3D=0A=
+			(char __iomem *)(&reg->msgcode_rwbuffer[21]);=0A=
+		int target, lun;=0A=
+		struct scsi_device *psdev;=0A=
+		char diff;=0A=
+=0A=
+		atomic_inc(&acb->rq_map_token);=0A=
+		if (readl(signature) =3D=3D ARCMSR_SIGNATURE_GET_CONFIG) {=0A=
+			for (target =3D 0; target <=0A=
+				ARCMSR_MAX_TARGETID - 1; target++) {=0A=
+				diff =3D (*acb_dev_map) ^ readb(devicemap);=0A=
+				if (diff !=3D 0) {=0A=
+					char temp;=0A=
+					*acb_dev_map =3D=0A=
+						readb(devicemap);=0A=
+					temp =3D *acb_dev_map;=0A=
+					for (lun =3D 0; lun <=0A=
+					ARCMSR_MAX_TARGETLUN; lun++) {=0A=
+						if ((temp & 0x01) =3D=3D 1 &&=0A=
+						(diff & 0x01) =3D=3D 1) {=0A=
+							scsi_add_device(acb->host,=0A=
+							0, target, lun);=0A=
+						} else if ((temp & 0x01) =3D=3D 0=0A=
+						&& (diff & 0x01) =3D=3D 1) {=0A=
+							psdev =3D scsi_device_lookup(acb->host,=0A=
+							0, target, lun);=0A=
+							if (psdev !=3D NULL) {=0A=
+								scsi_remove_device(psdev);=0A=
+								scsi_device_put(psdev);=0A=
+							}=0A=
+						}=0A=
+						temp >>=3D 1;=0A=
+						diff >>=3D 1;=0A=
+					}=0A=
+				}=0A=
+				devicemap++;=0A=
+				acb_dev_map++;=0A=
+			}=0A=
+		}=0A=
+	}=0A=
+	break;=0A=
+	case ACB_ADAPTER_TYPE_D: {=0A=
+		struct MessageUnit_D __iomem *reg  =3D acb->pmuD;=0A=
+		char *acb_dev_map =3D (char *)acb->device_map;=0A=
+		uint32_t __iomem *signature =3D=0A=
+			(uint32_t __iomem *)(&reg->msgcode_rwbuffer[0]);=0A=
+		char __iomem *devicemap =3D=0A=
+			(char __iomem *)(&reg->msgcode_rwbuffer[21]);=0A=
+		int target, lun;=0A=
+		struct scsi_device *psdev;=0A=
+		char diff;=0A=
+=0A=
+		atomic_inc(&acb->rq_map_token);=0A=
+		if (readl(signature) =3D=3D ARCMSR_SIGNATURE_GET_CONFIG) {=0A=
+			for (target =3D 0; target <=0A=
+				ARCMSR_MAX_TARGETID - 1; target++) {=0A=
+				diff =3D (*acb_dev_map) ^ readb(devicemap);=0A=
+				if (diff !=3D 0) {=0A=
+					char temp;=0A=
+					*acb_dev_map =3D=0A=
+						readb(devicemap);=0A=
+					temp =3D *acb_dev_map;=0A=
+					for (lun =3D 0; lun <=0A=
+					ARCMSR_MAX_TARGETLUN; lun++) {=0A=
+						if ((temp & 0x01) =3D=3D 1 &&=0A=
+						(diff & 0x01) =3D=3D 1) {=0A=
+							scsi_add_device(acb->host,=0A=
+							0, target, lun);=0A=
+						} else if ((temp & 0x01) =3D=3D 0=0A=
+						&& (diff & 0x01) =3D=3D 1) {=0A=
+							psdev =3D scsi_device_lookup(acb->host,=0A=
+							0, target, lun);=0A=
+							if (psdev !=3D NULL) {=0A=
+								scsi_remove_device(psdev);=0A=
+								scsi_device_put(psdev);=0A=
 							}=0A=
-							temp >>=3D 1;=0A=
-							diff >>=3D 1;=0A=
 						}=0A=
+						temp >>=3D 1;=0A=
+						diff >>=3D 1;=0A=
 					}=0A=
-					devicemap++;=0A=
-					acb_dev_map++;=0A=
 				}=0A=
+				devicemap++;=0A=
+				acb_dev_map++;=0A=
 			}=0A=
 		}=0A=
+		break;=0A=
+	}=0A=
+	}=0A=
+}=0A=
+=0A=
+static int=0A=
+arcmsr_suspend(struct pci_dev *pdev, pm_message_t state)=0A=
+{=0A=
+	int i;=0A=
+	uint32_t intmask_org;=0A=
+	struct Scsi_Host *host =3D pci_get_drvdata(pdev);=0A=
+	struct AdapterControlBlock *acb =3D=0A=
+		(struct AdapterControlBlock *)host->hostdata;=0A=
+=0A=
+	intmask_org =3D arcmsr_disable_outbound_ints(acb);=0A=
+	if (acb->acb_flags & ACB_F_MSI_ENABLED) {=0A=
+		free_irq(pdev->irq, acb);=0A=
+		pci_disable_msi(pdev);=0A=
+	} else if (acb->acb_flags & ACB_F_MSIX_ENABLED) {=0A=
+		for (i =3D 0; i < ARCMST_NUM_MSIX_VECTORS; i++)=0A=
+			free_irq(acb->entries[i].vector, acb);=0A=
+		pci_disable_msix(pdev);=0A=
+	} else=0A=
+		free_irq(pdev->irq, acb);=0A=
+	del_timer_sync(&acb->eternal_timer);=0A=
+	flush_scheduled_work();=0A=
+	arcmsr_stop_adapter_bgrb(acb);=0A=
+	arcmsr_flush_adapter_cache(acb);=0A=
+	arcmsr_enable_outbound_ints(acb, intmask_org);=0A=
+	pci_set_drvdata(pdev, host);=0A=
+	pci_save_state(pdev);=0A=
+	pci_disable_device(pdev);=0A=
+	pci_set_power_state(pdev, pci_choose_state(pdev, state));=0A=
+	return 0;=0A=
+}=0A=
+=0A=
+static int=0A=
+arcmsr_resume(struct pci_dev *pdev)=0A=
+{=0A=
+	int error, i, j;=0A=
+	struct Scsi_Host *host =3D pci_get_drvdata(pdev);=0A=
+	struct AdapterControlBlock *acb =3D=0A=
+		(struct AdapterControlBlock *)host->hostdata;=0A=
+	struct msix_entry entries[ARCMST_NUM_MSIX_VECTORS];=0A=
+	pci_set_power_state(pdev, PCI_D0);=0A=
+	pci_enable_wake(pdev, PCI_D0, 0);=0A=
+	pci_restore_state(pdev);=0A=
+	if (pci_enable_device(pdev)) {=0A=
+		pr_warn("%s: pci_enable_device error\n", __func__);=0A=
+		return -ENODEV;=0A=
+	}=0A=
+	error =3D pci_set_dma_mask(pdev, DMA_BIT_MASK(64));=0A=
+	if (error) {=0A=
+		error =3D pci_set_dma_mask(pdev, DMA_BIT_MASK(32));=0A=
+		if (error) {=0A=
+				pr_warn("scsi%d: No suitable DMA mask available\n",=0A=
+			       host->host_no);=0A=
+			goto controller_unregister;=0A=
+		}=0A=
 	}=0A=
+	pci_set_master(pdev);=0A=
+	if (pci_find_capability(pdev, PCI_CAP_ID_MSIX)) {=0A=
+		if (!pci_enable_msix(pdev, entries,=0A=
+			ARCMST_NUM_MSIX_VECTORS)) {=0A=
+			for (i =3D 0; i < ARCMST_NUM_MSIX_VECTORS;=0A=
+			i++) {=0A=
+				entries[i].entry =3D i;=0A=
+				if (request_irq(entries[i].vector,=0A=
+				arcmsr_do_interrupt, 0,=0A=
+				"arcmsr", acb)) {=0A=
+					for (j =3D 0 ; j < i ; j++)=0A=
+						free_irq(entries[i].vector,=0A=
+						acb);=0A=
+					goto controller_stop;=0A=
+				}=0A=
+				acb->entries[i] =3D entries[i];=0A=
+			}=0A=
+			acb->acb_flags |=3D ACB_F_MSIX_ENABLED;=0A=
+		} else {=0A=
+			pr_warn("arcmsr%d: MSI-X "=0A=
+			"failed to enable\n", acb->host->host_no);=0A=
+			if (request_irq(pdev->irq,=0A=
+			arcmsr_do_interrupt, IRQF_SHARED,=0A=
+			"arcmsr", acb)) {=0A=
+				goto controller_stop;=0A=
+			}=0A=
+		}=0A=
+	} else if (pci_find_capability(pdev, PCI_CAP_ID_MSI)) {=0A=
+		if (!pci_enable_msi(pdev))=0A=
+			acb->acb_flags |=3D ACB_F_MSI_ENABLED;=0A=
+		if (request_irq(pdev->irq, arcmsr_do_interrupt,=0A=
+			IRQF_SHARED, "arcmsr", acb))=0A=
+			goto controller_stop;=0A=
+	} else {=0A=
+		if (request_irq(pdev->irq, arcmsr_do_interrupt,=0A=
+			IRQF_SHARED, "arcmsr", acb))=0A=
+			goto controller_stop;=0A=
+	}=0A=
+	arcmsr_iop_init(acb);=0A=
+	INIT_WORK(&acb->arcmsr_do_message_isr_bh,=0A=
+	arcmsr_message_isr_bh_fn);=0A=
+	atomic_set(&acb->rq_map_token, 16);=0A=
+	atomic_set(&acb->ante_token_value, 16);=0A=
+	acb->fw_flag =3D FW_NORMAL;=0A=
+	init_timer(&acb->eternal_timer);=0A=
+	acb->eternal_timer.expires =3D jiffies +=0A=
+		msecs_to_jiffies(6 * HZ);=0A=
+	acb->eternal_timer.data =3D (unsigned long) acb;=0A=
+	acb->eternal_timer.function =3D=0A=
+		&arcmsr_request_device_map;=0A=
+	add_timer(&acb->eternal_timer);=0A=
+	return 0;=0A=
+controller_stop:=0A=
+		arcmsr_stop_adapter_bgrb(acb);=0A=
+		arcmsr_flush_adapter_cache(acb);=0A=
+controller_unregister:=0A=
+		scsi_remove_host(host);=0A=
+		arcmsr_free_ccb_pool(acb);=0A=
+		arcmsr_unmap_pciregion(acb);=0A=
+		pci_release_regions(pdev);=0A=
+		scsi_host_put(host);=0A=
+		pci_disable_device(pdev);=0A=
+	return -ENODEV;=0A=
 }=0A=
 =0A=
 static int arcmsr_probe(struct pci_dev *pdev, const struct =
pci_device_id *id)=0A=
 {=0A=
 	struct Scsi_Host *host;=0A=
 	struct AdapterControlBlock *acb;=0A=
-	uint8_t bus,dev_fun;=0A=
-	int error;=0A=
+	uint8_t bus, dev_fun;=0A=
+	struct msix_entry entries[ARCMST_NUM_MSIX_VECTORS];=0A=
+	int error, i, j;=0A=
 	error =3D pci_enable_device(pdev);=0A=
-	if(error){=0A=
+	if (error)=0A=
 		return -ENODEV;=0A=
-	}=0A=
-	host =3D scsi_host_alloc(&arcmsr_scsi_host_template, sizeof(struct =
AdapterControlBlock));=0A=
-	if(!host){=0A=
+	host =3D scsi_host_alloc(&arcmsr_scsi_host_template,=0A=
+		sizeof(struct AdapterControlBlock));=0A=
+	if (!host)=0A=
     		goto pci_disable_dev;=0A=
-	}=0A=
 	error =3D pci_set_dma_mask(pdev, DMA_BIT_MASK(64));=0A=
-	if(error){=0A=
+	if (error) {=0A=
 		error =3D pci_set_dma_mask(pdev, DMA_BIT_MASK(32));=0A=
-		if(error){=0A=
-			printk(KERN_WARNING=0A=
-			       "scsi%d: No suitable DMA mask available\n",=0A=
+		if (error) {=0A=
+			pr_warn("scsi%d: No suitable DMA mask available\n",=0A=
 			       host->host_no);=0A=
 			goto scsi_host_release;=0A=
 		}=0A=
@@ -634,70 +982,114 @@ static int arcmsr_probe(struct pci_dev *=0A=
 	acb->pdev =3D pdev;=0A=
 	acb->host =3D host;=0A=
 	host->max_lun =3D ARCMSR_MAX_TARGETLUN;=0A=
-	host->max_id =3D ARCMSR_MAX_TARGETID;		/*16:8*/=0A=
-	host->max_cmd_len =3D 16;	 			/*this is issue of 64bit LBA ,over 2T =
byte*/=0A=
-	host->can_queue =3D ARCMSR_MAX_FREECCB_NUM;	/* max simultaneous cmds =
*/		=0A=
-	host->cmd_per_lun =3D ARCMSR_MAX_CMD_PERLUN;	    =0A=
+	host->max_id =3D ARCMSR_MAX_TARGETID;=0A=
+	host->max_cmd_len =3D 16;=0A=
+	host->can_queue =3D ARCMSR_MAX_FREECCB_NUM;=0A=
+	host->cmd_per_lun =3D ARCMSR_MAX_CMD_PERLUN;=0A=
 	host->this_id =3D ARCMSR_SCSI_INITIATOR_ID;=0A=
 	host->unique_id =3D (bus << 8) | dev_fun;=0A=
 	pci_set_drvdata(pdev, host);=0A=
 	pci_set_master(pdev);=0A=
 	error =3D pci_request_regions(pdev, "arcmsr");=0A=
-	if(error){=0A=
+	if (error)=0A=
 		goto scsi_host_release;=0A=
-	}=0A=
 	spin_lock_init(&acb->eh_lock);=0A=
 	spin_lock_init(&acb->ccblist_lock);=0A=
+	spin_lock_init(&acb->postq_lock);=0A=
+	spin_lock_init(&acb->doneq_lock);=0A=
+	spin_lock_init(&acb->rqbuffer_lock);=0A=
+	spin_lock_init(&acb->wqbuffer_lock);=0A=
 	acb->acb_flags |=3D (ACB_F_MESSAGE_WQBUFFER_CLEARED |=0A=
 			ACB_F_MESSAGE_RQBUFFER_CLEARED |=0A=
 			ACB_F_MESSAGE_WQBUFFER_READED);=0A=
 	acb->acb_flags &=3D ~ACB_F_SCSISTOPADAPTER;=0A=
 	INIT_LIST_HEAD(&acb->ccb_free_list);=0A=
-	arcmsr_define_adapter_type(acb);=0A=
+	error =3D arcmsr_define_adapter_type(acb);=0A=
+	if (!error)=0A=
+		goto pci_release_regs;=0A=
 	error =3D arcmsr_remap_pciregion(acb);=0A=
-	if(!error){=0A=
+	if (!error)=0A=
 		goto pci_release_regs;=0A=
-	}=0A=
 	error =3D arcmsr_get_firmware_spec(acb);=0A=
-	if(!error){=0A=
+	if (!error)=0A=
 		goto unmap_pci_region;=0A=
-	}=0A=
 	error =3D arcmsr_alloc_ccb_pool(acb);=0A=
-	if(error){=0A=
+	if (error)=0A=
 		goto free_hbb_mu;=0A=
-	}=0A=
-	arcmsr_iop_init(acb);=0A=
 	error =3D scsi_add_host(host, &pdev->dev);=0A=
-	if(error){=0A=
+	if (error)=0A=
 		goto RAID_controller_stop;=0A=
-	}=0A=
-	error =3D request_irq(pdev->irq, arcmsr_do_interrupt, IRQF_SHARED, =
"arcmsr", acb);=0A=
-	if(error){=0A=
-		goto scsi_host_remove;=0A=
+	if (pci_find_capability(pdev, PCI_CAP_ID_MSIX)) {=0A=
+		if (!pci_enable_msix(pdev, entries, ARCMST_NUM_MSIX_VECTORS)) {=0A=
+			for (i =3D 0; i < ARCMST_NUM_MSIX_VECTORS; i++) {=0A=
+				entries[i].entry =3D i;=0A=
+				if (request_irq(entries[i].vector,=0A=
+					arcmsr_do_interrupt, 0, "arcmsr",=0A=
+					acb)) {=0A=
+					for (j =3D 0 ; j < i ; j++)=0A=
+						free_irq(entries[i].vector,=0A=
+						acb);=0A=
+					goto scsi_host_remove;=0A=
+				}=0A=
+				acb->entries[i] =3D entries[i];=0A=
+			}=0A=
+			acb->acb_flags |=3D ACB_F_MSIX_ENABLED;=0A=
+		} else {=0A=
+			if (request_irq(pdev->irq, arcmsr_do_interrupt,=0A=
+				IRQF_SHARED, "arcmsr", acb)) {=0A=
+				pr_warn("arcmsr%d: request_irq =3D %d failed!\n",=0A=
+					acb->host->host_no, pdev->irq);=0A=
+				goto scsi_host_remove;=0A=
+			}=0A=
+		}=0A=
+	} else if (pci_find_capability(pdev, PCI_CAP_ID_MSI)) {=0A=
+		if (!pci_enable_msi(pdev))=0A=
+			acb->acb_flags |=3D ACB_F_MSI_ENABLED;=0A=
+		if (request_irq(pdev->irq, arcmsr_do_interrupt,=0A=
+			IRQF_SHARED, "arcmsr", acb)) {=0A=
+			pr_warn("arcmsr%d: request_irq =3D%d failed!\n",=0A=
+				acb->host->host_no, pdev->irq);=0A=
+			goto scsi_host_remove;=0A=
+		}=0A=
+	} else {=0A=
+		if (request_irq(pdev->irq, arcmsr_do_interrupt,=0A=
+			IRQF_SHARED, "arcmsr", acb)) {=0A=
+			pr_warn("arcmsr%d: request_irq =3D %d failed!\n",=0A=
+				acb->host->host_no, pdev->irq);=0A=
+			goto scsi_host_remove;=0A=
+		}=0A=
 	}=0A=
 	host->irq =3D pdev->irq;=0A=
-    	scsi_scan_host(host);=0A=
-	INIT_WORK(&acb->arcmsr_do_message_isr_bh, arcmsr_message_isr_bh_fn);=0A=
+	arcmsr_iop_init(acb);=0A=
+	scsi_scan_host(host);=0A=
+	INIT_WORK(&acb->arcmsr_do_message_isr_bh,=0A=
+		arcmsr_message_isr_bh_fn);=0A=
 	atomic_set(&acb->rq_map_token, 16);=0A=
 	atomic_set(&acb->ante_token_value, 16);=0A=
 	acb->fw_flag =3D FW_NORMAL;=0A=
 	init_timer(&acb->eternal_timer);=0A=
-	acb->eternal_timer.expires =3D jiffies + msecs_to_jiffies(6 * HZ);=0A=
+	acb->eternal_timer.expires =3D jiffies +=0A=
+		msecs_to_jiffies(6 * HZ);=0A=
 	acb->eternal_timer.data =3D (unsigned long) acb;=0A=
-	acb->eternal_timer.function =3D &arcmsr_request_device_map;=0A=
+	acb->eternal_timer.function =3D=0A=
+		&arcmsr_request_device_map;=0A=
 	add_timer(&acb->eternal_timer);=0A=
-	if(arcmsr_alloc_sysfs_attr(acb))=0A=
+	if (arcmsr_alloc_sysfs_attr(acb))=0A=
 		goto out_free_sysfs;=0A=
 	return 0;=0A=
 out_free_sysfs:=0A=
 scsi_host_remove:=0A=
+	if (acb->acb_flags & ACB_F_MSI_ENABLED)=0A=
+		pci_disable_msi(pdev);=0A=
+	else if (acb->acb_flags & ACB_F_MSIX_ENABLED)=0A=
+		pci_disable_msix(pdev);=0A=
 	scsi_remove_host(host);=0A=
 RAID_controller_stop:=0A=
 	arcmsr_stop_adapter_bgrb(acb);=0A=
 	arcmsr_flush_adapter_cache(acb);=0A=
 	arcmsr_free_ccb_pool(acb);=0A=
 free_hbb_mu:=0A=
-	arcmsr_free_hbb_mu(acb);=0A=
+	arcmsr_free_mu(acb);=0A=
 unmap_pci_region:=0A=
 	arcmsr_unmap_pciregion(acb);=0A=
 pci_release_regs:=0A=
@@ -709,85 +1101,114 @@ pci_disable_dev:=0A=
 	return -ENODEV;=0A=
 }=0A=
 =0A=
-static uint8_t arcmsr_abort_hba_allcmd(struct AdapterControlBlock *acb)=0A=
+static uint8_t=0A=
+arcmsr_hbaA_abort_allcmd(struct AdapterControlBlock *acb)=0A=
 {=0A=
 	struct MessageUnit_A __iomem *reg =3D acb->pmuA;=0A=
-	writel(ARCMSR_INBOUND_MESG0_ABORT_CMD, &reg->inbound_msgaddr0);=0A=
-	if (!arcmsr_hba_wait_msgint_ready(acb)) {=0A=
-		printk(KERN_NOTICE=0A=
-			"arcmsr%d: wait 'abort all outstanding command' timeout \n"=0A=
-			, acb->host->host_no);=0A=
+	writel(ARCMSR_INBOUND_MESG0_ABORT_CMD,=0A=
+		&reg->inbound_msgaddr0);=0A=
+	if (!arcmsr_hbaA_wait_msgint_ready(acb)) {=0A=
+		pr_notice("arcmsr%d: wait 'abort all outstanding "=0A=
+		"command' timeout\n"=0A=
+		, acb->host->host_no);=0A=
 		return false;=0A=
 	}=0A=
 	return true;=0A=
 }=0A=
 =0A=
-static uint8_t arcmsr_abort_hbb_allcmd(struct AdapterControlBlock *acb)=0A=
+static uint8_t=0A=
+arcmsr_hbaB_abort_allcmd(struct AdapterControlBlock *acb)=0A=
 {=0A=
-	struct MessageUnit_B *reg =3D acb->pmuB;=0A=
+	struct MessageUnit_B __iomem *reg =3D acb->pmuB;=0A=
 =0A=
-	writel(ARCMSR_MESSAGE_ABORT_CMD, reg->drv2iop_doorbell);=0A=
-	if (!arcmsr_hbb_wait_msgint_ready(acb)) {=0A=
-		printk(KERN_NOTICE=0A=
-			"arcmsr%d: wait 'abort all outstanding command' timeout \n"=0A=
-			, acb->host->host_no);=0A=
+	writel(ARCMSR_MESSAGE_ABORT_CMD,=0A=
+		reg->drv2iop_doorbell);=0A=
+	if (!arcmsr_hbaB_wait_msgint_ready(acb)) {=0A=
+		pr_notice("arcmsr%d: wait 'abort all outstanding "=0A=
+		"command' timeout\n"=0A=
+		, acb->host->host_no);=0A=
 		return false;=0A=
 	}=0A=
 	return true;=0A=
 }=0A=
-static uint8_t arcmsr_abort_hbc_allcmd(struct AdapterControlBlock *pACB)=0A=
+static uint8_t=0A=
+arcmsr_hbaC_abort_allcmd(struct AdapterControlBlock *pACB)=0A=
 {=0A=
-	struct MessageUnit_C *reg =3D (struct MessageUnit_C *)pACB->pmuC;=0A=
+	struct MessageUnit_C __iomem *reg =3D pACB->pmuC;=0A=
 	writel(ARCMSR_INBOUND_MESG0_ABORT_CMD, &reg->inbound_msgaddr0);=0A=
 	writel(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE, &reg->inbound_doorbell);=0A=
-	if (!arcmsr_hbc_wait_msgint_ready(pACB)) {=0A=
-		printk(KERN_NOTICE=0A=
-			"arcmsr%d: wait 'abort all outstanding command' timeout \n"=0A=
-			, pACB->host->host_no);=0A=
+	if (!arcmsr_hbaC_wait_msgint_ready(pACB)) {=0A=
+		pr_notice("arcmsr%d: wait 'abort all outstanding "=0A=
+		"command' timeout\n"=0A=
+		, pACB->host->host_no);=0A=
+		return false;=0A=
+	}=0A=
+	return true;=0A=
+}=0A=
+static uint8_t=0A=
+arcmsr_hbaD_abort_allcmd(struct AdapterControlBlock *pACB)=0A=
+{=0A=
+	struct MessageUnit_D __iomem *reg =3D pACB->pmuD;=0A=
+	writel(ARCMSR_INBOUND_MESG0_ABORT_CMD, reg->inbound_msgaddr0);=0A=
+	if (!arcmsr_hbaD_wait_msgint_ready(pACB)) {=0A=
+		pr_notice("arcmsr%d: wait 'abort all outstanding "=0A=
+		"command' timeout\n"=0A=
+		, pACB->host->host_no);=0A=
 		return false;=0A=
 	}=0A=
 	return true;=0A=
 }=0A=
-static uint8_t arcmsr_abort_allcmd(struct AdapterControlBlock *acb)=0A=
+static uint8_t=0A=
+arcmsr_abort_allcmd(struct AdapterControlBlock *acb)=0A=
 {=0A=
 	uint8_t rtnval =3D 0;=0A=
 	switch (acb->adapter_type) {=0A=
 	case ACB_ADAPTER_TYPE_A: {=0A=
-		rtnval =3D arcmsr_abort_hba_allcmd(acb);=0A=
-		}=0A=
+		rtnval =3D arcmsr_hbaA_abort_allcmd(acb);=0A=
 		break;=0A=
+		}=0A=
 =0A=
 	case ACB_ADAPTER_TYPE_B: {=0A=
-		rtnval =3D arcmsr_abort_hbb_allcmd(acb);=0A=
-		}=0A=
+		rtnval =3D arcmsr_hbaB_abort_allcmd(acb);=0A=
 		break;=0A=
+		}=0A=
 =0A=
 	case ACB_ADAPTER_TYPE_C: {=0A=
-		rtnval =3D arcmsr_abort_hbc_allcmd(acb);=0A=
+		rtnval =3D arcmsr_hbaC_abort_allcmd(acb);=0A=
+		break;=0A=
+		}=0A=
+=0A=
+	case ACB_ADAPTER_TYPE_D: {=0A=
+		rtnval =3D arcmsr_hbaD_abort_allcmd(acb);=0A=
+		break;=0A=
 		}=0A=
 	}=0A=
 	return rtnval;=0A=
 }=0A=
 =0A=
-static bool arcmsr_hbb_enable_driver_mode(struct AdapterControlBlock =
*pacb)=0A=
+static bool=0A=
+arcmsr_hbb_enable_driver_mode(struct AdapterControlBlock *pacb)=0A=
 {=0A=
-	struct MessageUnit_B *reg =3D pacb->pmuB;=0A=
-	writel(ARCMSR_MESSAGE_START_DRIVER_MODE, reg->drv2iop_doorbell);=0A=
-	if (!arcmsr_hbb_wait_msgint_ready(pacb)) {=0A=
-		printk(KERN_ERR "arcmsr%d: can't set driver mode. \n", =
pacb->host->host_no);=0A=
+	struct MessageUnit_B __iomem *reg =3D pacb->pmuB;=0A=
+	writel(ARCMSR_MESSAGE_START_DRIVER_MODE,=0A=
+		reg->drv2iop_doorbell);=0A=
+	if (!arcmsr_hbaB_wait_msgint_ready(pacb)) {=0A=
+		pr_err("arcmsr%d: can't set driver mode.\n",=0A=
+			pacb->host->host_no);=0A=
 		return false;=0A=
 	}=0A=
     	return true;=0A=
 }=0A=
 =0A=
-static void arcmsr_pci_unmap_dma(struct CommandControlBlock *ccb)=0A=
+static void=0A=
+arcmsr_pci_unmap_dma(struct CommandControlBlock *ccb)=0A=
 {=0A=
 	struct scsi_cmnd *pcmd =3D ccb->pcmd;=0A=
-=0A=
 	scsi_dma_unmap(pcmd);=0A=
 }=0A=
 =0A=
-static void arcmsr_ccb_complete(struct CommandControlBlock *ccb)=0A=
+static void=0A=
+arcmsr_ccb_complete(struct CommandControlBlock *ccb)=0A=
 {=0A=
 	struct AdapterControlBlock *acb =3D ccb->acb;=0A=
 	struct scsi_cmnd *pcmd =3D ccb->pcmd;=0A=
@@ -801,52 +1222,68 @@ static void arcmsr_ccb_complete(struct C=0A=
 	pcmd->scsi_done(pcmd);=0A=
 }=0A=
 =0A=
-static void arcmsr_report_sense_info(struct CommandControlBlock *ccb)=0A=
+static void=0A=
+arcmsr_report_sense_info(struct CommandControlBlock *ccb)=0A=
 {=0A=
 =0A=
 	struct scsi_cmnd *pcmd =3D ccb->pcmd;=0A=
-	struct SENSE_DATA *sensebuffer =3D (struct SENSE_DATA =
*)pcmd->sense_buffer;=0A=
-	pcmd->result =3D DID_OK << 16;=0A=
+	struct SENSE_DATA *sensebuffer =3D=0A=
+		(struct SENSE_DATA *)pcmd->sense_buffer;=0A=
+	pcmd->result =3D (DID_OK << 16) | (CHECK_CONDITION << 1)=0A=
+		| (DRIVER_SENSE << 24);=0A=
 	if (sensebuffer) {=0A=
 		int sense_data_length =3D=0A=
 			sizeof(struct SENSE_DATA) < SCSI_SENSE_BUFFERSIZE=0A=
 			? sizeof(struct SENSE_DATA) : SCSI_SENSE_BUFFERSIZE;=0A=
 		memset(sensebuffer, 0, SCSI_SENSE_BUFFERSIZE);=0A=
-		memcpy(sensebuffer, ccb->arcmsr_cdb.SenseData, sense_data_length);=0A=
+		memcpy((void *)sensebuffer, (const void *)ccb->arcmsr_cdb.SenseData,=0A=
+			sense_data_length);=0A=
 		sensebuffer->ErrorCode =3D SCSI_SENSE_CURRENT_ERRORS;=0A=
 		sensebuffer->Valid =3D 1;=0A=
 	}=0A=
 }=0A=
 =0A=
-static u32 arcmsr_disable_outbound_ints(struct AdapterControlBlock *acb)=0A=
+static u32=0A=
+arcmsr_disable_outbound_ints(struct AdapterControlBlock *acb)=0A=
 {=0A=
 	u32 orig_mask =3D 0;=0A=
 	switch (acb->adapter_type) {	=0A=
 	case ACB_ADAPTER_TYPE_A : {=0A=
 		struct MessageUnit_A __iomem *reg =3D acb->pmuA;=0A=
 		orig_mask =3D readl(&reg->outbound_intmask);=0A=
-		writel(orig_mask|ARCMSR_MU_OUTBOUND_ALL_INTMASKENABLE, \=0A=
-						&reg->outbound_intmask);=0A=
+		writel(orig_mask |=0A=
+			ARCMSR_MU_OUTBOUND_ALL_INTMASKENABLE,=0A=
+			&reg->outbound_intmask);=0A=
 		}=0A=
 		break;=0A=
 	case ACB_ADAPTER_TYPE_B : {=0A=
-		struct MessageUnit_B *reg =3D acb->pmuB;=0A=
+		struct MessageUnit_B __iomem *reg =3D acb->pmuB;=0A=
 		orig_mask =3D readl(reg->iop2drv_doorbell_mask);=0A=
 		writel(0, reg->iop2drv_doorbell_mask);=0A=
 		}=0A=
 		break;=0A=
-	case ACB_ADAPTER_TYPE_C:{=0A=
-		struct MessageUnit_C *reg =3D (struct MessageUnit_C *)acb->pmuC;=0A=
+	case ACB_ADAPTER_TYPE_C: {=0A=
+		struct MessageUnit_C __iomem *reg =3D acb->pmuC;=0A=
 		/* disable all outbound interrupt */=0A=
-		orig_mask =3D readl(&reg->host_int_mask); /* disable outbound =
message0 int */=0A=
-		writel(orig_mask|ARCMSR_HBCMU_ALL_INTMASKENABLE, &reg->host_int_mask);=0A=
+		orig_mask =3D readl(&reg->host_int_mask);=0A=
+		writel(orig_mask | ARCMSR_HBCMU_ALL_INTMASKENABLE,=0A=
+			&reg->host_int_mask);=0A=
+		readl(&reg->host_int_mask);=0A=
 		}=0A=
 		break;=0A=
+	case ACB_ADAPTER_TYPE_D: {=0A=
+		struct MessageUnit_D __iomem *reg =3D acb->pmuD;=0A=
+		/* disable all outbound interrupt */=0A=
+		writel(ARCMSR_ARC1214_ALL_INT_DISABLE,=0A=
+		reg->pcief0_int_enable);=0A=
+		break;=0A=
+	}=0A=
 	}=0A=
 	return orig_mask;=0A=
 }=0A=
 =0A=
-static void arcmsr_report_ccb_state(struct AdapterControlBlock *acb, =0A=
+static void=0A=
+arcmsr_report_ccb_state(struct AdapterControlBlock *acb,=0A=
 			struct CommandControlBlock *ccb, bool error)=0A=
 {=0A=
 	uint8_t id, lun;=0A=
@@ -857,7 +1294,7 @@ static void arcmsr_report_ccb_state(stru=0A=
 			acb->devstate[id][lun] =3D ARECA_RAID_GOOD;=0A=
 		ccb->pcmd->result =3D DID_OK << 16;=0A=
 		arcmsr_ccb_complete(ccb);=0A=
-	}else{=0A=
+	} else {=0A=
 		switch (ccb->arcmsr_cdb.DeviceStatus) {=0A=
 		case ARCMSR_DEV_SELECT_TIMEOUT: {=0A=
 			acb->devstate[id][lun] =3D ARECA_RAID_GONE;=0A=
@@ -883,53 +1320,47 @@ static void arcmsr_report_ccb_state(stru=0A=
 			break;=0A=
 =0A=
 		default:=0A=
-			printk(KERN_NOTICE=0A=
-				"arcmsr%d: scsi id =3D %d lun =3D %d isr get command error done, \=0A=
-				but got unknown DeviceStatus =3D 0x%x \n"=0A=
-				, acb->host->host_no=0A=
-				, id=0A=
-				, lun=0A=
-				, ccb->arcmsr_cdb.DeviceStatus);=0A=
-				acb->devstate[id][lun] =3D ARECA_RAID_GONE;=0A=
-				ccb->pcmd->result =3D DID_NO_CONNECT << 16;=0A=
-				arcmsr_ccb_complete(ccb);=0A=
+			pr_notice("arcmsr%d: scsi id =3D %d lun =3D %d "=0A=
+			"isr get command error done, but got unknown "=0A=
+			"DeviceStatus =3D 0x%x\n"=0A=
+			, acb->host->host_no=0A=
+			, id=0A=
+			, lun=0A=
+			, ccb->arcmsr_cdb.DeviceStatus);=0A=
+			acb->devstate[id][lun] =3D ARECA_RAID_GONE;=0A=
+			ccb->pcmd->result =3D DID_NO_CONNECT << 16;=0A=
+			arcmsr_ccb_complete(ccb);=0A=
 			break;=0A=
 		}=0A=
 	}=0A=
 }=0A=
 =0A=
-static void arcmsr_drain_donequeue(struct AdapterControlBlock *acb, =
struct CommandControlBlock *pCCB, bool error)=0A=
+static void=0A=
+arcmsr_drain_donequeue(struct AdapterControlBlock *acb,=0A=
+	struct CommandControlBlock *pCCB, bool error)=0A=
 {=0A=
-	int id, lun;=0A=
 	if ((pCCB->acb !=3D acb) || (pCCB->startdone !=3D ARCMSR_CCB_START)) {=0A=
-		if (pCCB->startdone =3D=3D ARCMSR_CCB_ABORTED) {=0A=
-			struct scsi_cmnd *abortcmd =3D pCCB->pcmd;=0A=
-			if (abortcmd) {=0A=
-				id =3D abortcmd->device->id;=0A=
-				lun =3D abortcmd->device->lun;				=0A=
-				abortcmd->result |=3D DID_ABORT << 16;=0A=
-				arcmsr_ccb_complete(pCCB);=0A=
-				printk(KERN_NOTICE "arcmsr%d: pCCB =3D'0x%p' isr got aborted =
command \n",=0A=
-				acb->host->host_no, pCCB);=0A=
-			}=0A=
-			return;=0A=
-		}=0A=
-		printk(KERN_NOTICE "arcmsr%d: isr get an illegal ccb command \=0A=
-				done acb =3D '0x%p'"=0A=
-				"ccb =3D '0x%p' ccbacb =3D '0x%p' startdone =3D 0x%x"=0A=
-				" ccboutstandingcount =3D %d \n"=0A=
-				, acb->host->host_no=0A=
-				, acb=0A=
-				, pCCB=0A=
-				, pCCB->acb=0A=
-				, pCCB->startdone=0A=
-				, atomic_read(&acb->ccboutstandingcount));=0A=
-		  return;=0A=
+		pr_notice("arcmsr%d: isr get an illegal ccb "=0A=
+		"command done acb =3D 0x%p, "=0A=
+		"ccb =3D 0x%p, "=0A=
+		"ccbacb =3D 0x%p, "=0A=
+		"startdone =3D 0x%x, "=0A=
+		"pscsi_cmd =3D 0x%p, "=0A=
+		"ccboutstandingcount =3D %d\n"=0A=
+		, acb->host->host_no=0A=
+		, acb=0A=
+		, pCCB=0A=
+		, pCCB->acb=0A=
+		, pCCB->startdone=0A=
+		, pCCB->pcmd=0A=
+		, atomic_read(&acb->ccboutstandingcount));=0A=
+		return;=0A=
 	}=0A=
 	arcmsr_report_ccb_state(acb, pCCB, error);=0A=
 }=0A=
 =0A=
-static void arcmsr_done4abort_postqueue(struct AdapterControlBlock *acb)=0A=
+static void=0A=
+arcmsr_done4abort_postqueue(struct AdapterControlBlock *acb)=0A=
 {=0A=
 	int i =3D 0;=0A=
 	uint32_t flag_ccb;=0A=
@@ -944,27 +1375,36 @@ static void arcmsr_done4abort_postqueue(=0A=
 		outbound_intstatus =3D readl(&reg->outbound_intstatus) &=0A=
 					acb->outbound_int_enable;=0A=
 		/*clear and abort all outbound posted Q*/=0A=
-		writel(outbound_intstatus, &reg->outbound_intstatus);/*clear =
interrupt*/=0A=
-		while(((flag_ccb =3D readl(&reg->outbound_queueport)) !=3D 0xFFFFFFFF)=0A=
-				&& (i++ < ARCMSR_MAX_OUTSTANDING_CMD)) {=0A=
-			pARCMSR_CDB =3D (struct ARCMSR_CDB *)(acb->vir2phy_offset + =
(flag_ccb << 5));/*frame must be 32 bytes aligned*/=0A=
-			pCCB =3D container_of(pARCMSR_CDB, struct CommandControlBlock, =
arcmsr_cdb);=0A=
-			error =3D (flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR_MODE0) ? true : =
false;=0A=
+		writel(outbound_intstatus, &reg->outbound_intstatus);=0A=
+		while (((flag_ccb =3D readl(&reg->outbound_queueport))=0A=
+			!=3D 0xFFFFFFFF)=0A=
+			&& (i++ < ARCMSR_MAX_OUTSTANDING_CMD)) {=0A=
+			pARCMSR_CDB =3D (struct ARCMSR_CDB *)=0A=
+				(acb->vir2phy_offset + (flag_ccb << 5));=0A=
+			pCCB =3D container_of(pARCMSR_CDB,=0A=
+			struct CommandControlBlock, arcmsr_cdb);=0A=
+			error =3D (flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR_MODE0) ?=0A=
+				true : false;=0A=
 			arcmsr_drain_donequeue(acb, pCCB, error);=0A=
 		}=0A=
 		}=0A=
 		break;=0A=
 =0A=
 	case ACB_ADAPTER_TYPE_B: {=0A=
-		struct MessageUnit_B *reg =3D acb->pmuB;=0A=
-		/*clear all outbound posted Q*/=0A=
-		writel(ARCMSR_DOORBELL_INT_CLEAR_PATTERN, reg->iop2drv_doorbell); /* =
clear doorbell interrupt */=0A=
+		struct MessageUnit_B __iomem *reg =3D acb->pmuB;=0A=
+		writel(ARCMSR_DOORBELL_INT_CLEAR_PATTERN,=0A=
+			reg->iop2drv_doorbell);=0A=
 		for (i =3D 0; i < ARCMSR_MAX_HBB_POSTQUEUE; i++) {=0A=
-			if ((flag_ccb =3D readl(&reg->done_qbuffer[i])) !=3D 0) {=0A=
+			flag_ccb =3D readl(&reg->done_qbuffer[i]);=0A=
+			if (flag_ccb !=3D 0) {=0A=
 				writel(0, &reg->done_qbuffer[i]);=0A=
-				pARCMSR_CDB =3D (struct ARCMSR_CDB *)(acb->vir2phy_offset+(flag_ccb =
<< 5));/*frame must be 32 bytes aligned*/=0A=
-				pCCB =3D container_of(pARCMSR_CDB, struct CommandControlBlock, =
arcmsr_cdb);=0A=
-				error =3D (flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR_MODE0) ? true : =
false;=0A=
+				pARCMSR_CDB =3D (struct ARCMSR_CDB *)=0A=
+				(acb->vir2phy_offset + (flag_ccb << 5));=0A=
+				pCCB =3D container_of(pARCMSR_CDB,=0A=
+				struct CommandControlBlock, arcmsr_cdb);=0A=
+				error =3D (flag_ccb &=0A=
+				ARCMSR_CCBREPLY_FLAG_ERROR_MODE0) ?=0A=
+				true : false;=0A=
 				arcmsr_drain_donequeue(acb, pCCB, error);=0A=
 			}=0A=
 			reg->post_qbuffer[i] =3D 0;=0A=
@@ -974,29 +1414,87 @@ static void arcmsr_done4abort_postqueue(=0A=
 		}=0A=
 		break;=0A=
 	case ACB_ADAPTER_TYPE_C: {=0A=
-		struct MessageUnit_C *reg =3D acb->pmuC;=0A=
+		struct MessageUnit_C __iomem *reg =3D acb->pmuC;=0A=
 		struct  ARCMSR_CDB *pARCMSR_CDB;=0A=
 		uint32_t flag_ccb, ccb_cdb_phy;=0A=
 		bool error;=0A=
 		struct CommandControlBlock *pCCB;=0A=
-		while ((readl(&reg->host_int_status) & =
ARCMSR_HBCMU_OUTBOUND_POSTQUEUE_ISR) && (i++ < =
ARCMSR_MAX_OUTSTANDING_CMD)) {=0A=
+		while ((readl(&reg->host_int_status) &=0A=
+			ARCMSR_HBCMU_OUTBOUND_POSTQUEUE_ISR)=0A=
+			&& (i++ < ARCMSR_MAX_OUTSTANDING_CMD)) {=0A=
 			/*need to do*/=0A=
 			flag_ccb =3D readl(&reg->outbound_queueport_low);=0A=
 			ccb_cdb_phy =3D (flag_ccb & 0xFFFFFFF0);=0A=
-			pARCMSR_CDB =3D (struct  ARCMSR_CDB =
*)(acb->vir2phy_offset+ccb_cdb_phy);/*frame must be 32 bytes aligned*/=0A=
-			pCCB =3D container_of(pARCMSR_CDB, struct CommandControlBlock, =
arcmsr_cdb);=0A=
-			error =3D (flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR_MODE1) ? true : =
false;=0A=
+			pARCMSR_CDB =3D (struct  ARCMSR_CDB *)=0A=
+				(acb->vir2phy_offset+ccb_cdb_phy);=0A=
+			pCCB =3D container_of(pARCMSR_CDB,=0A=
+				struct CommandControlBlock, arcmsr_cdb);=0A=
+			error =3D (flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR_MODE1)=0A=
+				? true : false;=0A=
 			arcmsr_drain_donequeue(acb, pCCB, error);=0A=
 		}=0A=
+		}=0A=
+		break;=0A=
+	case ACB_ADAPTER_TYPE_D: {=0A=
+		struct MessageUnit_D __iomem *pmu =3D acb->pmuD;=0A=
+		uint32_t ccb_cdb_phy, outbound_write_pointer;=0A=
+		uint32_t doneq_index, index_stripped, addressLow, residual;=0A=
+		bool error;=0A=
+		struct CommandControlBlock *pCCB;=0A=
+		outbound_write_pointer =3D pmu->done_qbuffer[0].addressLow + 1;=0A=
+		doneq_index =3D pmu->doneq_index;=0A=
+		residual =3D atomic_read(&acb->ccboutstandingcount);=0A=
+		for (i =3D 0; i < residual; i++) {=0A=
+			while ((doneq_index & 0xFFF) !=3D (outbound_write_pointer & 0xFFF)) {=0A=
+				if (doneq_index & 0x4000) {=0A=
+					index_stripped =3D doneq_index & 0xFFF;=0A=
+					index_stripped +=3D 1;=0A=
+					index_stripped %=3D=0A=
+					ARCMSR_MAX_ARC1214_DONEQUEUE;=0A=
+					pmu->doneq_index =3D index_stripped ?=0A=
+					(index_stripped | 0x4000) : (index_stripped + 1);=0A=
+				} else {=0A=
+					index_stripped =3D doneq_index;=0A=
+					index_stripped +=3D 1;=0A=
+					index_stripped %=3D=0A=
+					ARCMSR_MAX_ARC1214_DONEQUEUE;=0A=
+					pmu->doneq_index =3D=0A=
+					index_stripped ? index_stripped : ((index_stripped | 0x4000) + 1);=0A=
+				}=0A=
+				doneq_index =3D pmu->doneq_index;=0A=
+				addressLow =3D=0A=
+				pmu->done_qbuffer[doneq_index & 0xFFF].addressLow;=0A=
+				ccb_cdb_phy =3D (addressLow & 0xFFFFFFF0);=0A=
+				pARCMSR_CDB =3D (struct  ARCMSR_CDB *)=0A=
+				(acb->vir2phy_offset + ccb_cdb_phy);=0A=
+				pCCB =3D container_of(pARCMSR_CDB,=0A=
+				struct CommandControlBlock, arcmsr_cdb);=0A=
+				error =3D=0A=
+				(addressLow & ARCMSR_CCBREPLY_FLAG_ERROR_MODE1)=0A=
+				? true : false;=0A=
+				arcmsr_drain_donequeue(acb, pCCB, error);=0A=
+				writel(doneq_index,=0A=
+					pmu->outboundlist_read_pointer);=0A=
+			}=0A=
+			mdelay(10);=0A=
+			outbound_write_pointer =3D=0A=
+				pmu->done_qbuffer[0].addressLow + 1;=0A=
+			doneq_index =3D pmu->doneq_index;=0A=
+		}=0A=
+		pmu->postq_index =3D 0;=0A=
+		pmu->doneq_index =3D 0x40FF;=0A=
+		break;=0A=
 	}=0A=
 	}=0A=
 }=0A=
-static void arcmsr_remove(struct pci_dev *pdev)=0A=
+=0A=
+static void=0A=
+arcmsr_remove(struct pci_dev *pdev)=0A=
 {=0A=
 	struct Scsi_Host *host =3D pci_get_drvdata(pdev);=0A=
 	struct AdapterControlBlock *acb =3D=0A=
-		(struct AdapterControlBlock *) host->hostdata;=0A=
-	int poll_count =3D 0;=0A=
+		(struct AdapterControlBlock *)host->hostdata;=0A=
+	int poll_count =3D 0, i;=0A=
 	arcmsr_free_sysfs_attr(acb);=0A=
 	scsi_remove_host(host);=0A=
 	flush_work(&acb->arcmsr_do_message_isr_bh);=0A=
@@ -1007,20 +1505,20 @@ static void arcmsr_remove(struct pci_dev=0A=
 	acb->acb_flags |=3D ACB_F_SCSISTOPADAPTER;=0A=
 	acb->acb_flags &=3D ~ACB_F_IOP_INITED;=0A=
 =0A=
-	for (poll_count =3D 0; poll_count < ARCMSR_MAX_OUTSTANDING_CMD; =
poll_count++){=0A=
+	for (poll_count =3D 0; poll_count < ARCMSR_MAX_OUTSTANDING_CMD;=0A=
+	poll_count++) {=0A=
 		if (!atomic_read(&acb->ccboutstandingcount))=0A=
 			break;=0A=
-		arcmsr_interrupt(acb);/* FIXME: need spinlock */=0A=
+		arcmsr_interrupt(acb);=0A=
 		msleep(25);=0A=
 	}=0A=
 =0A=
 	if (atomic_read(&acb->ccboutstandingcount)) {=0A=
-		int i;=0A=
-=0A=
 		arcmsr_abort_allcmd(acb);=0A=
 		arcmsr_done4abort_postqueue(acb);=0A=
 		for (i =3D 0; i < ARCMSR_MAX_FREECCB_NUM; i++) {=0A=
-			struct CommandControlBlock *ccb =3D acb->pccb_pool[i];=0A=
+			struct CommandControlBlock *ccb =3D=0A=
+				acb->pccb_pool[i];=0A=
 			if (ccb->startdone =3D=3D ARCMSR_CCB_START) {=0A=
 				ccb->startdone =3D ARCMSR_CCB_ABORTED;=0A=
 				ccb->pcmd->result =3D DID_ABORT << 16;=0A=
@@ -1028,9 +1526,17 @@ static void arcmsr_remove(struct pci_dev=0A=
 			}=0A=
 		}=0A=
 	}=0A=
-	free_irq(pdev->irq, acb);=0A=
 	arcmsr_free_ccb_pool(acb);=0A=
-	arcmsr_free_hbb_mu(acb);=0A=
+	arcmsr_free_mu(acb);=0A=
+	if (acb->acb_flags & ACB_F_MSI_ENABLED) {=0A=
+		free_irq(pdev->irq, acb);=0A=
+		pci_disable_msi(pdev);=0A=
+	} else if (acb->acb_flags & ACB_F_MSIX_ENABLED) {=0A=
+		for (i =3D 0; i < ARCMST_NUM_MSIX_VECTORS; i++)=0A=
+			free_irq(acb->entries[i].vector, acb);=0A=
+		pci_disable_msix(pdev);=0A=
+	} else=0A=
+		free_irq(pdev->irq, acb);=0A=
 	arcmsr_unmap_pciregion(acb);=0A=
 	pci_release_regions(pdev);=0A=
 	scsi_host_put(host);=0A=
@@ -1038,13 +1544,21 @@ static void arcmsr_remove(struct pci_dev=0A=
 	pci_set_drvdata(pdev, NULL);=0A=
 }=0A=
 =0A=
-static void arcmsr_shutdown(struct pci_dev *pdev)=0A=
+static void=0A=
+arcmsr_shutdown(struct pci_dev *pdev)=0A=
 {=0A=
+	int i;=0A=
 	struct Scsi_Host *host =3D pci_get_drvdata(pdev);=0A=
 	struct AdapterControlBlock *acb =3D=0A=
 		(struct AdapterControlBlock *)host->hostdata;=0A=
 	del_timer_sync(&acb->eternal_timer);=0A=
 	arcmsr_disable_outbound_ints(acb);=0A=
+	if (acb->acb_flags & ACB_F_MSIX_ENABLED) {=0A=
+		for (i =3D 0; i < ARCMST_NUM_MSIX_VECTORS; i++)=0A=
+			free_irq(acb->entries[i].vector, acb);=0A=
+		pci_disable_msix(pdev);=0A=
+	} else=0A=
+		free_irq(pdev->irq, acb);=0A=
 	flush_work(&acb->arcmsr_do_message_isr_bh);=0A=
 	arcmsr_stop_adapter_bgrb(acb);=0A=
 	arcmsr_flush_adapter_cache(acb);=0A=
@@ -1064,7 +1578,8 @@ static void arcmsr_module_exit(void)=0A=
 module_init(arcmsr_module_init);=0A=
 module_exit(arcmsr_module_exit);=0A=
 =0A=
-static void arcmsr_enable_outbound_ints(struct AdapterControlBlock *acb,=0A=
+static void=0A=
+arcmsr_enable_outbound_ints(struct AdapterControlBlock *acb,=0A=
 						u32 intmask_org)=0A=
 {=0A=
 	u32 mask;=0A=
@@ -1072,37 +1587,51 @@ static void arcmsr_enable_outbound_ints(=0A=
 =0A=
 	case ACB_ADAPTER_TYPE_A: {=0A=
 		struct MessageUnit_A __iomem *reg =3D acb->pmuA;=0A=
-		mask =3D intmask_org & ~(ARCMSR_MU_OUTBOUND_POSTQUEUE_INTMASKENABLE |=0A=
-			     ARCMSR_MU_OUTBOUND_DOORBELL_INTMASKENABLE|=0A=
-			     ARCMSR_MU_OUTBOUND_MESSAGE0_INTMASKENABLE);=0A=
+		mask =3D intmask_org &=0A=
+		~(ARCMSR_MU_OUTBOUND_POSTQUEUE_INTMASKENABLE |=0A=
+		     ARCMSR_MU_OUTBOUND_DOORBELL_INTMASKENABLE |=0A=
+		     ARCMSR_MU_OUTBOUND_MESSAGE0_INTMASKENABLE);=0A=
 		writel(mask, &reg->outbound_intmask);=0A=
-		acb->outbound_int_enable =3D ~(intmask_org & mask) & 0x000000ff;=0A=
-		}=0A=
+		acb->outbound_int_enable =3D ~(intmask_org & mask) &=0A=
+			0x000000ff;=0A=
 		break;=0A=
-=0A=
+		}=0A=
 	case ACB_ADAPTER_TYPE_B: {=0A=
-		struct MessageUnit_B *reg =3D acb->pmuB;=0A=
+		struct MessageUnit_B __iomem *reg =3D acb->pmuB;=0A=
 		mask =3D intmask_org | (ARCMSR_IOP2DRV_DATA_WRITE_OK |=0A=
 			ARCMSR_IOP2DRV_DATA_READ_OK |=0A=
 			ARCMSR_IOP2DRV_CDB_DONE |=0A=
 			ARCMSR_IOP2DRV_MESSAGE_CMD_DONE);=0A=
 		writel(mask, reg->iop2drv_doorbell_mask);=0A=
-		acb->outbound_int_enable =3D (intmask_org | mask) & 0x0000000f;=0A=
-		}=0A=
+		acb->outbound_int_enable =3D (intmask_org | mask) &=0A=
+			0x0000000f;=0A=
 		break;=0A=
+		}=0A=
 	case ACB_ADAPTER_TYPE_C: {=0A=
-		struct MessageUnit_C *reg =3D acb->pmuC;=0A=
-		mask =3D ~(ARCMSR_HBCMU_UTILITY_A_ISR_MASK | =
ARCMSR_HBCMU_OUTBOUND_DOORBELL_ISR_MASK|ARCMSR_HBCMU_OUTBOUND_POSTQUEUE_I=
SR_MASK);=0A=
+		struct MessageUnit_C __iomem *reg =3D acb->pmuC;=0A=
+		mask =3D ~(ARCMSR_HBCMU_UTILITY_A_ISR_MASK |=0A=
+			ARCMSR_HBCMU_OUTBOUND_DOORBELL_ISR_MASK |=0A=
+			ARCMSR_HBCMU_OUTBOUND_POSTQUEUE_ISR_MASK);=0A=
 		writel(intmask_org & mask, &reg->host_int_mask);=0A=
-		acb->outbound_int_enable =3D ~(intmask_org & mask) & 0x0000000f;=0A=
+		acb->outbound_int_enable =3D ~(intmask_org & mask) &=0A=
+			0x0000000f;=0A=
+		break;=0A=
 		}=0A=
+	case ACB_ADAPTER_TYPE_D: {=0A=
+		struct MessageUnit_D __iomem *reg =3D acb->pmuD;=0A=
+		mask =3D ARCMSR_ARC1214_ALL_INT_ENABLE;=0A=
+		writel(intmask_org | mask, reg->pcief0_int_enable);=0A=
+		break;=0A=
+	}=0A=
 	}=0A=
 }=0A=
 =0A=
-static int arcmsr_build_ccb(struct AdapterControlBlock *acb,=0A=
+static int=0A=
+arcmsr_build_ccb(struct AdapterControlBlock *acb,=0A=
 	struct CommandControlBlock *ccb, struct scsi_cmnd *pcmd)=0A=
 {=0A=
-	struct ARCMSR_CDB *arcmsr_cdb =3D (struct ARCMSR_CDB =
*)&ccb->arcmsr_cdb;=0A=
+	struct ARCMSR_CDB *arcmsr_cdb =3D=0A=
+		(struct ARCMSR_CDB *)&ccb->arcmsr_cdb;=0A=
 	int8_t *psge =3D (int8_t *)&arcmsr_cdb->u;=0A=
 	__le32 address_lo, address_hi;=0A=
 	int arccdbsize =3D 0x30;=0A=
@@ -1115,8 +1644,7 @@ static int arcmsr_build_ccb(struct Adapt=0A=
 	arcmsr_cdb->TargetID =3D pcmd->device->id;=0A=
 	arcmsr_cdb->LUN =3D pcmd->device->lun;=0A=
 	arcmsr_cdb->Function =3D 1;=0A=
-	arcmsr_cdb->Context =3D 0;=0A=
-	memcpy(arcmsr_cdb->Cdb, pcmd->cmnd, pcmd->cmd_len);=0A=
+	memcpy((void *)arcmsr_cdb->Cdb, (const void *)pcmd->cmnd, =
pcmd->cmd_len);=0A=
 =0A=
 	nseg =3D scsi_dma_map(pcmd);=0A=
 	if (unlikely(nseg > acb->host->sg_tablesize || nseg < 0))=0A=
@@ -1127,25 +1655,27 @@ static int arcmsr_build_ccb(struct Adapt=0A=
 		address_lo =3D cpu_to_le32(dma_addr_lo32(sg_dma_address(sg)));=0A=
 		address_hi =3D cpu_to_le32(dma_addr_hi32(sg_dma_address(sg)));=0A=
 		if (address_hi =3D=3D 0) {=0A=
-			struct SG32ENTRY *pdma_sg =3D (struct SG32ENTRY *)psge;=0A=
-=0A=
+			struct SG32ENTRY *pdma_sg =3D=0A=
+				(struct SG32ENTRY *)psge;=0A=
 			pdma_sg->address =3D address_lo;=0A=
 			pdma_sg->length =3D length;=0A=
 			psge +=3D sizeof (struct SG32ENTRY);=0A=
 			arccdbsize +=3D sizeof (struct SG32ENTRY);=0A=
 		} else {=0A=
-			struct SG64ENTRY *pdma_sg =3D (struct SG64ENTRY *)psge;=0A=
-=0A=
+			struct SG64ENTRY *pdma_sg =3D=0A=
+			(struct SG64ENTRY *)psge;=0A=
 			pdma_sg->addresshigh =3D address_hi;=0A=
 			pdma_sg->address =3D address_lo;=0A=
-			pdma_sg->length =3D length|cpu_to_le32(IS_SG64_ADDR);=0A=
+			pdma_sg->length =3D length |=0A=
+				cpu_to_le32(IS_SG64_ADDR);=0A=
 			psge +=3D sizeof (struct SG64ENTRY);=0A=
 			arccdbsize +=3D sizeof (struct SG64ENTRY);=0A=
 		}=0A=
 	}=0A=
 	arcmsr_cdb->sgcount =3D (uint8_t)nseg;=0A=
 	arcmsr_cdb->DataLength =3D scsi_bufflen(pcmd);=0A=
-	arcmsr_cdb->msgPages =3D arccdbsize/0x100 + (arccdbsize % 0x100 ? 1 : =
0);=0A=
+	arcmsr_cdb->msgPages =3D arccdbsize / 0x100 +=0A=
+		(arccdbsize % 0x100 ? 1 : 0);=0A=
 	if ( arccdbsize > 256)=0A=
 		arcmsr_cdb->Flags |=3D ARCMSR_CDB_FLAG_SGL_BSIZE;=0A=
 	if (pcmd->sc_data_direction =3D=3D DMA_TO_DEVICE)=0A=
@@ -1154,10 +1684,14 @@ static int arcmsr_build_ccb(struct Adapt=0A=
 	return SUCCESS;=0A=
 }=0A=
 =0A=
-static void arcmsr_post_ccb(struct AdapterControlBlock *acb, struct =
CommandControlBlock *ccb)=0A=
-{=0A=
-	uint32_t cdb_phyaddr_pattern =3D ccb->cdb_phyaddr_pattern;=0A=
-	struct ARCMSR_CDB *arcmsr_cdb =3D (struct ARCMSR_CDB =
*)&ccb->arcmsr_cdb;=0A=
+static void=0A=
+arcmsr_post_ccb(struct AdapterControlBlock *acb,=0A=
+	struct CommandControlBlock *ccb)=0A=
+{=0A=
+	uint32_t cdb_phyaddr =3D ccb->cdb_phyaddr;=0A=
+	struct ARCMSR_CDB *arcmsr_cdb =3D=0A=
+		(struct ARCMSR_CDB *)&ccb->arcmsr_cdb;=0A=
+	u32 arccdbsize =3D ccb->arc_cdb_size;=0A=
 	atomic_inc(&acb->ccboutstandingcount);=0A=
 	ccb->startdone =3D ARCMSR_CCB_START;=0A=
 	switch (acb->adapter_type) {=0A=
@@ -1165,131 +1699,203 @@ static void arcmsr_post_ccb(struct Adapt=0A=
 		struct MessageUnit_A __iomem *reg =3D acb->pmuA;=0A=
 =0A=
 		if (arcmsr_cdb->Flags & ARCMSR_CDB_FLAG_SGL_BSIZE)=0A=
-			writel(cdb_phyaddr_pattern | ARCMSR_CCBPOST_FLAG_SGL_BSIZE,=0A=
+			writel(cdb_phyaddr |=0A=
+			ARCMSR_CCBPOST_FLAG_SGL_BSIZE,=0A=
 			&reg->inbound_queueport);=0A=
-		else {=0A=
-				writel(cdb_phyaddr_pattern, &reg->inbound_queueport);=0A=
-		}=0A=
+		else=0A=
+			writel(cdb_phyaddr, &reg->inbound_queueport);=0A=
 		}=0A=
 		break;=0A=
 =0A=
 	case ACB_ADAPTER_TYPE_B: {=0A=
-		struct MessageUnit_B *reg =3D acb->pmuB;=0A=
+		struct MessageUnit_B __iomem *reg =3D acb->pmuB;=0A=
 		uint32_t ending_index, index =3D reg->postq_index;=0A=
 =0A=
-		ending_index =3D ((index + 1) % ARCMSR_MAX_HBB_POSTQUEUE);=0A=
+		ending_index =3D ((index + 1) %=0A=
+			ARCMSR_MAX_HBB_POSTQUEUE);=0A=
 		writel(0, &reg->post_qbuffer[ending_index]);=0A=
 		if (arcmsr_cdb->Flags & ARCMSR_CDB_FLAG_SGL_BSIZE) {=0A=
-			writel(cdb_phyaddr_pattern | ARCMSR_CCBPOST_FLAG_SGL_BSIZE,\=0A=
-						 &reg->post_qbuffer[index]);=0A=
-		} else {=0A=
-			writel(cdb_phyaddr_pattern, &reg->post_qbuffer[index]);=0A=
-		}=0A=
+			writel(cdb_phyaddr |=0A=
+			ARCMSR_CCBPOST_FLAG_SGL_BSIZE,=0A=
+			 &reg->post_qbuffer[index]);=0A=
+		} else=0A=
+			writel(cdb_phyaddr, &reg->post_qbuffer[index]);=0A=
 		index++;=0A=
-		index %=3D ARCMSR_MAX_HBB_POSTQUEUE;/*if last index number set it to =
0 */=0A=
+		index %=3D ARCMSR_MAX_HBB_POSTQUEUE;=0A=
 		reg->postq_index =3D index;=0A=
-		writel(ARCMSR_DRV2IOP_CDB_POSTED, reg->drv2iop_doorbell);=0A=
+		writel(ARCMSR_DRV2IOP_CDB_POSTED,=0A=
+			reg->drv2iop_doorbell);=0A=
 		}=0A=
 		break;=0A=
 	case ACB_ADAPTER_TYPE_C: {=0A=
-		struct MessageUnit_C *phbcmu =3D (struct MessageUnit_C *)acb->pmuC;=0A=
+		struct MessageUnit_C __iomem *phbcmu =3D acb->pmuC;=0A=
 		uint32_t ccb_post_stamp, arc_cdb_size;=0A=
 =0A=
-		arc_cdb_size =3D (ccb->arc_cdb_size > 0x300) ? 0x300 : =
ccb->arc_cdb_size;=0A=
-		ccb_post_stamp =3D (cdb_phyaddr_pattern | ((arc_cdb_size - 1) >> 6) | =
1);=0A=
+		arc_cdb_size =3D (ccb->arc_cdb_size > 0x300)=0A=
+			? 0x300 : ccb->arc_cdb_size;=0A=
+		ccb_post_stamp =3D (cdb_phyaddr |=0A=
+			((arc_cdb_size - 1) >> 6) | 1);=0A=
 		if (acb->cdb_phyaddr_hi32) {=0A=
-			writel(acb->cdb_phyaddr_hi32, &phbcmu->inbound_queueport_high);=0A=
-			writel(ccb_post_stamp, &phbcmu->inbound_queueport_low);=0A=
+			writel(acb->cdb_phyaddr_hi32,=0A=
+			&phbcmu->inbound_queueport_high);=0A=
+			writel(ccb_post_stamp,=0A=
+			&phbcmu->inbound_queueport_low);=0A=
+		} else=0A=
+			writel(ccb_post_stamp,=0A=
+			&phbcmu->inbound_queueport_low);=0A=
+		}=0A=
+		break;=0A=
+	case ACB_ADAPTER_TYPE_D: {=0A=
+		struct MessageUnit_D __iomem *pmu =3D acb->pmuD;=0A=
+		u16 index_stripped;=0A=
+		u16 postq_index;=0A=
+		unsigned long flags;=0A=
+		struct InBound_SRB *pinbound_srb;=0A=
+		spin_lock_irqsave(&acb->postq_lock, flags);=0A=
+		postq_index =3D pmu->postq_index;=0A=
+		pinbound_srb =3D (struct InBound_SRB *)&pmu->post_qbuffer[postq_index =
& 0xFF];=0A=
+		pinbound_srb->addressHigh =3D dma_addr_hi32(cdb_phyaddr);=0A=
+		pinbound_srb->addressLow =3D dma_addr_lo32(cdb_phyaddr);=0A=
+		pinbound_srb->length =3D arccdbsize >> 2;=0A=
+		arcmsr_cdb->msgContext =3D dma_addr_lo32(cdb_phyaddr);=0A=
+		if (postq_index & 0x4000) {=0A=
+			index_stripped =3D postq_index & 0xFF;=0A=
+			index_stripped +=3D 1;=0A=
+			index_stripped %=3D ARCMSR_MAX_ARC1214_POSTQUEUE;=0A=
+			pmu->postq_index =3D index_stripped ? (index_stripped | 0x4000) : =
index_stripped;=0A=
 		} else {=0A=
-			writel(ccb_post_stamp, &phbcmu->inbound_queueport_low);=0A=
-		}=0A=
+			index_stripped =3D postq_index;=0A=
+			index_stripped +=3D 1;=0A=
+			index_stripped %=3D ARCMSR_MAX_ARC1214_POSTQUEUE;=0A=
+			pmu->postq_index =3D index_stripped ? index_stripped : =
(index_stripped | 0x4000);=0A=
 		}=0A=
+		writel(postq_index, pmu->inboundlist_write_pointer);=0A=
+		spin_unlock_irqrestore(&acb->postq_lock, flags);=0A=
+		break;=0A=
+	}=0A=
 	}=0A=
 }=0A=
 =0A=
-static void arcmsr_stop_hba_bgrb(struct AdapterControlBlock *acb)=0A=
+static void arcmsr_hbaA_stop_bgrb(struct AdapterControlBlock *acb)=0A=
 {=0A=
 	struct MessageUnit_A __iomem *reg =3D acb->pmuA;=0A=
 	acb->acb_flags &=3D ~ACB_F_MSG_START_BGRB;=0A=
 	writel(ARCMSR_INBOUND_MESG0_STOP_BGRB, &reg->inbound_msgaddr0);=0A=
-	if (!arcmsr_hba_wait_msgint_ready(acb)) {=0A=
-		printk(KERN_NOTICE=0A=
-			"arcmsr%d: wait 'stop adapter background rebulid' timeout \n"=0A=
-			, acb->host->host_no);=0A=
-	}=0A=
+	if (!arcmsr_hbaA_wait_msgint_ready(acb))=0A=
+		pr_notice("arcmsr%d: wait 'stop adapter background rebulid' timeout\n"=0A=
+		, acb->host->host_no);=0A=
 }=0A=
 =0A=
-static void arcmsr_stop_hbb_bgrb(struct AdapterControlBlock *acb)=0A=
+static void=0A=
+arcmsr_hbaB_stop_bgrb(struct AdapterControlBlock *acb)=0A=
 {=0A=
-	struct MessageUnit_B *reg =3D acb->pmuB;=0A=
+	struct MessageUnit_B __iomem *reg =3D acb->pmuB;=0A=
 	acb->acb_flags &=3D ~ACB_F_MSG_START_BGRB;=0A=
 	writel(ARCMSR_MESSAGE_STOP_BGRB, reg->drv2iop_doorbell);=0A=
 =0A=
-	if (!arcmsr_hbb_wait_msgint_ready(acb)) {=0A=
-		printk(KERN_NOTICE=0A=
-			"arcmsr%d: wait 'stop adapter background rebulid' timeout \n"=0A=
-			, acb->host->host_no);=0A=
-	}=0A=
+	if (!arcmsr_hbaB_wait_msgint_ready(acb))=0A=
+		pr_notice("arcmsr%d: wait 'stop adapter background rebulid' timeout\n"=0A=
+		, acb->host->host_no);=0A=
 }=0A=
 =0A=
-static void arcmsr_stop_hbc_bgrb(struct AdapterControlBlock *pACB)=0A=
+static void=0A=
+arcmsr_hbaC_stop_bgrb(struct AdapterControlBlock *pACB)=0A=
 {=0A=
-	struct MessageUnit_C *reg =3D (struct MessageUnit_C *)pACB->pmuC;=0A=
+	struct MessageUnit_C __iomem *reg =3D pACB->pmuC;=0A=
 	pACB->acb_flags &=3D ~ACB_F_MSG_START_BGRB;=0A=
 	writel(ARCMSR_INBOUND_MESG0_STOP_BGRB, &reg->inbound_msgaddr0);=0A=
-	writel(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE, &reg->inbound_doorbell);=0A=
-	if (!arcmsr_hbc_wait_msgint_ready(pACB)) {=0A=
-		printk(KERN_NOTICE=0A=
-			"arcmsr%d: wait 'stop adapter background rebulid' timeout \n"=0A=
-			, pACB->host->host_no);=0A=
-	}=0A=
-	return;=0A=
+	writel(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE,=0A=
+		&reg->inbound_doorbell);=0A=
+	if (!arcmsr_hbaC_wait_msgint_ready(pACB))=0A=
+		pr_notice("arcmsr%d: wait 'stop adapter background rebulid' timeout\n"=0A=
+		, pACB->host->host_no);=0A=
+}=0A=
+=0A=
+static void=0A=
+arcmsr_hbaD_stop_bgrb(struct AdapterControlBlock *pACB)=0A=
+{=0A=
+	struct MessageUnit_D __iomem *reg =3D pACB->pmuD;=0A=
+=0A=
+	pACB->acb_flags &=3D ~ACB_F_MSG_START_BGRB;=0A=
+	writel(ARCMSR_INBOUND_MESG0_STOP_BGRB,=0A=
+		reg->inbound_msgaddr0);=0A=
+	if (!arcmsr_hbaD_wait_msgint_ready(pACB))=0A=
+		pr_notice("arcmsr%d: wait 'stop adapter background rebulid' timeout\n"=0A=
+		, pACB->host->host_no);=0A=
 }=0A=
-static void arcmsr_stop_adapter_bgrb(struct AdapterControlBlock *acb)=0A=
+=0A=
+static void=0A=
+arcmsr_stop_adapter_bgrb(struct AdapterControlBlock *acb)=0A=
 {=0A=
 	switch (acb->adapter_type) {=0A=
 	case ACB_ADAPTER_TYPE_A: {=0A=
-		arcmsr_stop_hba_bgrb(acb);=0A=
-		}=0A=
+		arcmsr_hbaA_stop_bgrb(acb);=0A=
 		break;=0A=
-=0A=
+	}=0A=
 	case ACB_ADAPTER_TYPE_B: {=0A=
-		arcmsr_stop_hbb_bgrb(acb);=0A=
-		}=0A=
+		arcmsr_hbaB_stop_bgrb(acb);=0A=
 		break;=0A=
+	}=0A=
 	case ACB_ADAPTER_TYPE_C: {=0A=
-		arcmsr_stop_hbc_bgrb(acb);=0A=
-		}=0A=
+		arcmsr_hbaC_stop_bgrb(acb);=0A=
+		break;=0A=
+	}=0A=
+	case ACB_ADAPTER_TYPE_D: {=0A=
+		arcmsr_hbaD_stop_bgrb(acb);=0A=
+		break;=0A=
+	}=0A=
 	}=0A=
 }=0A=
 =0A=
-static void arcmsr_free_ccb_pool(struct AdapterControlBlock *acb)=0A=
+static void=0A=
+arcmsr_free_ccb_pool(struct AdapterControlBlock *acb)=0A=
 {=0A=
-	dma_free_coherent(&acb->pdev->dev, acb->uncache_size, =
acb->dma_coherent, acb->dma_coherent_handle);=0A=
+	switch (acb->adapter_type) {=0A=
+	case ACB_ADAPTER_TYPE_A:=0A=
+	case ACB_ADAPTER_TYPE_C:=0A=
+	case ACB_ADAPTER_TYPE_B:=0A=
+	case ACB_ADAPTER_TYPE_D:=0A=
+		dma_free_coherent(&acb->pdev->dev, acb->uncache_size,=0A=
+			acb->dma_coherent, acb->dma_coherent_handle);=0A=
+		break;=0A=
+	}=0A=
 }=0A=
 =0A=
-void arcmsr_iop_message_read(struct AdapterControlBlock *acb)=0A=
+void=0A=
+arcmsr_iop_message_read(struct AdapterControlBlock *acb)=0A=
 {=0A=
 	switch (acb->adapter_type) {=0A=
 	case ACB_ADAPTER_TYPE_A: {=0A=
 		struct MessageUnit_A __iomem *reg =3D acb->pmuA;=0A=
-		writel(ARCMSR_INBOUND_DRIVER_DATA_READ_OK, &reg->inbound_doorbell);=0A=
+		writel(ARCMSR_INBOUND_DRIVER_DATA_READ_OK,=0A=
+		&reg->inbound_doorbell);=0A=
 		}=0A=
 		break;=0A=
 =0A=
 	case ACB_ADAPTER_TYPE_B: {=0A=
-		struct MessageUnit_B *reg =3D acb->pmuB;=0A=
-		writel(ARCMSR_DRV2IOP_DATA_READ_OK, reg->drv2iop_doorbell);=0A=
+		struct MessageUnit_B __iomem *reg =3D acb->pmuB;=0A=
+		writel(ARCMSR_DRV2IOP_DATA_READ_OK,=0A=
+		reg->drv2iop_doorbell);=0A=
 		}=0A=
 		break;=0A=
 	case ACB_ADAPTER_TYPE_C: {=0A=
 		struct MessageUnit_C __iomem *reg =3D acb->pmuC;=0A=
 		writel(ARCMSR_HBCMU_DRV2IOP_DATA_READ_OK, &reg->inbound_doorbell);=0A=
+		/*readl(&reg->inbound_doorbell);*/=0A=
 		}=0A=
+		break;=0A=
+	case ACB_ADAPTER_TYPE_D: {=0A=
+		struct MessageUnit_D __iomem *reg =3D acb->pmuD;=0A=
+		writel(ARCMSR_ARC1214_DRV2IOP_DATA_OUT_READ,=0A=
+		reg->inbound_doorbell);=0A=
+		/*readl(reg->inbound_doorbell);*/=0A=
+		break;=0A=
+	}=0A=
 	}=0A=
 }=0A=
 =0A=
-static void arcmsr_iop_message_wrote(struct AdapterControlBlock *acb)=0A=
+static void=0A=
+arcmsr_iop_message_wrote(struct AdapterControlBlock *acb)=0A=
 {=0A=
 	switch (acb->adapter_type) {=0A=
 	case ACB_ADAPTER_TYPE_A: {=0A=
@@ -1298,17 +1904,19 @@ static void arcmsr_iop_message_wrote(str=0A=
 		** push inbound doorbell tell iop, driver data write ok=0A=
 		** and wait reply on next hwinterrupt for next Qbuffer post=0A=
 		*/=0A=
-		writel(ARCMSR_INBOUND_DRIVER_DATA_WRITE_OK, &reg->inbound_doorbell);=0A=
+		writel(ARCMSR_INBOUND_DRIVER_DATA_WRITE_OK,=0A=
+		&reg->inbound_doorbell);=0A=
 		}=0A=
 		break;=0A=
 =0A=
 	case ACB_ADAPTER_TYPE_B: {=0A=
-		struct MessageUnit_B *reg =3D acb->pmuB;=0A=
+		struct MessageUnit_B __iomem *reg =3D acb->pmuB;=0A=
 		/*=0A=
 		** push inbound doorbell tell iop, driver data write ok=0A=
 		** and wait reply on next hwinterrupt for next Qbuffer post=0A=
 		*/=0A=
-		writel(ARCMSR_DRV2IOP_DATA_WRITE_OK, reg->drv2iop_doorbell);=0A=
+		writel(ARCMSR_DRV2IOP_DATA_WRITE_OK,=0A=
+		reg->drv2iop_doorbell);=0A=
 		}=0A=
 		break;=0A=
 	case ACB_ADAPTER_TYPE_C: {=0A=
@@ -1317,13 +1925,21 @@ static void arcmsr_iop_message_wrote(str=0A=
 		** push inbound doorbell tell iop, driver data write ok=0A=
 		** and wait reply on next hwinterrupt for next Qbuffer post=0A=
 		*/=0A=
-		writel(ARCMSR_HBCMU_DRV2IOP_DATA_WRITE_OK, &reg->inbound_doorbell);=0A=
+		writel(ARCMSR_HBCMU_DRV2IOP_DATA_WRITE_OK,=0A=
+		&reg->inbound_doorbell);=0A=
 		}=0A=
 		break;=0A=
+	case ACB_ADAPTER_TYPE_D: {=0A=
+		struct MessageUnit_D __iomem *reg =3D acb->pmuD;=0A=
+		writel(ARCMSR_ARC1214_DRV2IOP_DATA_IN_READY,=0A=
+		reg->inbound_doorbell);=0A=
+		break;=0A=
+	}=0A=
 	}=0A=
 }=0A=
 =0A=
-struct QBUFFER __iomem *arcmsr_get_iop_rqbuffer(struct =
AdapterControlBlock *acb)=0A=
+struct QBUFFER __iomem=0A=
+*arcmsr_get_iop_rqbuffer(struct AdapterControlBlock *acb)=0A=
 {=0A=
 	struct QBUFFER __iomem *qbuffer =3D NULL;=0A=
 	switch (acb->adapter_type) {=0A=
@@ -1335,146 +1951,294 @@ struct QBUFFER __iomem *arcmsr_get_iop_r=0A=
 		break;=0A=
 =0A=
 	case ACB_ADAPTER_TYPE_B: {=0A=
-		struct MessageUnit_B *reg =3D acb->pmuB;=0A=
+		struct MessageUnit_B __iomem *reg =3D acb->pmuB;=0A=
 		qbuffer =3D (struct QBUFFER __iomem *)reg->message_rbuffer;=0A=
 		}=0A=
 		break;=0A=
 	case ACB_ADAPTER_TYPE_C: {=0A=
-		struct MessageUnit_C *phbcmu =3D (struct MessageUnit_C *)acb->pmuC;=0A=
-		qbuffer =3D (struct QBUFFER __iomem *)&phbcmu->message_rbuffer;=0A=
+		struct MessageUnit_C __iomem *reg =3D acb->pmuC;=0A=
+		qbuffer =3D (struct QBUFFER __iomem *)&reg->message_rbuffer;=0A=
 		}=0A=
+		break;=0A=
+	case ACB_ADAPTER_TYPE_D: {=0A=
+		struct MessageUnit_D __iomem *reg =3D acb->pmuD;=0A=
+		qbuffer =3D (struct QBUFFER __iomem *)reg->message_rbuffer;=0A=
+		break;=0A=
+	}=0A=
 	}=0A=
 	return qbuffer;=0A=
 }=0A=
 =0A=
-static struct QBUFFER __iomem *arcmsr_get_iop_wqbuffer(struct =
AdapterControlBlock *acb)=0A=
+struct QBUFFER __iomem=0A=
+*arcmsr_get_iop_wqbuffer(struct AdapterControlBlock *acb)=0A=
 {=0A=
 	struct QBUFFER __iomem *pqbuffer =3D NULL;=0A=
 	switch (acb->adapter_type) {=0A=
 =0A=
 	case ACB_ADAPTER_TYPE_A: {=0A=
 		struct MessageUnit_A __iomem *reg =3D acb->pmuA;=0A=
-		pqbuffer =3D (struct QBUFFER __iomem *) &reg->message_wbuffer;=0A=
+		pqbuffer =3D (struct QBUFFER __iomem *)&reg->message_wbuffer;=0A=
 		}=0A=
 		break;=0A=
 =0A=
 	case ACB_ADAPTER_TYPE_B: {=0A=
-		struct MessageUnit_B  *reg =3D acb->pmuB;=0A=
+		struct MessageUnit_B  __iomem *reg =3D acb->pmuB;=0A=
 		pqbuffer =3D (struct QBUFFER __iomem *)reg->message_wbuffer;=0A=
 		}=0A=
 		break;=0A=
 	case ACB_ADAPTER_TYPE_C: {=0A=
-		struct MessageUnit_C *reg =3D (struct MessageUnit_C *)acb->pmuC;=0A=
+		struct MessageUnit_C __iomem *reg =3D acb->pmuC;=0A=
 		pqbuffer =3D (struct QBUFFER __iomem *)&reg->message_wbuffer;=0A=
+		}=0A=
+		break;=0A=
+	case ACB_ADAPTER_TYPE_D: {=0A=
+		struct MessageUnit_D __iomem *reg =3D acb->pmuD;=0A=
+		pqbuffer =3D (struct QBUFFER __iomem *)reg->message_wbuffer;=0A=
+		break;=0A=
 	}=0A=
-=0A=
 	}=0A=
 	return pqbuffer;=0A=
 }=0A=
 =0A=
-static void arcmsr_iop2drv_data_wrote_handle(struct AdapterControlBlock =
*acb)=0A=
-{=0A=
-	struct QBUFFER __iomem *prbuffer;=0A=
-	struct QBUFFER *pQbuffer;=0A=
+static uint32_t=0A=
+arcmsr_Read_iop_rqbuffer_in_DWORD(struct AdapterControlBlock *acb,=0A=
+	struct QBUFFER __iomem *prbuffer) {=0A=
+=0A=
+	uint8_t *pQbuffer;=0A=
+	uint8_t *buf1 =3D 0;=0A=
+	uint32_t __iomem *iop_data;=0A=
+	uint32_t iop_len, data_len, *buf2 =3D 0;=0A=
+=0A=
+	iop_data =3D (uint32_t *)prbuffer->data;=0A=
+	iop_len =3D readl(&prbuffer->data_len);=0A=
+	if (iop_len > 0) {=0A=
+		buf1 =3D (uint8_t *)kmalloc(128, GFP_ATOMIC);=0A=
+		buf2 =3D (uint32_t *)buf1;=0A=
+		if (buf1 =3D=3D NULL)=0A=
+			return 0;=0A=
+		data_len =3D iop_len;=0A=
+		while (data_len >=3D 4) {=0A=
+			*buf2++ =3D *iop_data++;=0A=
+			data_len -=3D 4;=0A=
+		}=0A=
+		if (data_len)=0A=
+			*buf2 =3D *iop_data;=0A=
+		buf2 =3D (uint32_t *)buf1;=0A=
+	}=0A=
+	while (iop_len > 0) {=0A=
+		pQbuffer =3D &acb->rqbuffer[acb->rqbuf_lastindex];=0A=
+		*pQbuffer =3D *buf1;=0A=
+		acb->rqbuf_lastindex++;=0A=
+		/* if last, index number set it to 0 */=0A=
+		acb->rqbuf_lastindex %=3D ARCMSR_MAX_QBUFFER;=0A=
+		buf1++;=0A=
+		iop_len--;=0A=
+	}=0A=
+	if (buf2)=0A=
+		kfree((const void *)buf2);=0A=
+	/* let IOP know data has been read */=0A=
+	arcmsr_iop_message_read(acb);=0A=
+	return 1;=0A=
+}=0A=
+=0A=
+uint32_t=0A=
+arcmsr_Read_iop_rqbuffer_data(struct AdapterControlBlock *acb,=0A=
+	struct QBUFFER __iomem *prbuffer) {=0A=
+=0A=
+	uint8_t *pQbuffer;=0A=
 	uint8_t __iomem *iop_data;=0A=
-	int32_t my_empty_len, iop_len, rqbuf_firstindex, rqbuf_lastindex;=0A=
-	rqbuf_lastindex =3D acb->rqbuf_lastindex;=0A=
-	rqbuf_firstindex =3D acb->rqbuf_firstindex;=0A=
-	prbuffer =3D arcmsr_get_iop_rqbuffer(acb);=0A=
-	iop_data =3D (uint8_t __iomem *)prbuffer->data;=0A=
-	iop_len =3D prbuffer->data_len;=0A=
-	my_empty_len =3D (rqbuf_firstindex - rqbuf_lastindex - 1) & =
(ARCMSR_MAX_QBUFFER - 1);=0A=
-=0A=
-	if (my_empty_len >=3D iop_len)=0A=
-	{=0A=
-		while (iop_len > 0) {=0A=
-			pQbuffer =3D (struct QBUFFER *)&acb->rqbuffer[rqbuf_lastindex];=0A=
-			memcpy(pQbuffer, iop_data, 1);=0A=
-			rqbuf_lastindex++;=0A=
-			rqbuf_lastindex %=3D ARCMSR_MAX_QBUFFER;=0A=
-			iop_data++;=0A=
-			iop_len--;=0A=
-		}=0A=
-		acb->rqbuf_lastindex =3D rqbuf_lastindex;=0A=
-		arcmsr_iop_message_read(acb);=0A=
+	uint32_t iop_len;=0A=
+=0A=
+	if (acb->adapter_type & (ACB_ADAPTER_TYPE_C | ACB_ADAPTER_TYPE_D))=0A=
+		return arcmsr_Read_iop_rqbuffer_in_DWORD(acb, prbuffer);=0A=
+=0A=
+	iop_data =3D (uint8_t *)prbuffer->data;=0A=
+	iop_len =3D readl(&prbuffer->data_len);=0A=
+	while (iop_len > 0) {=0A=
+		pQbuffer =3D &acb->rqbuffer[acb->rqbuf_lastindex];=0A=
+		*pQbuffer =3D *iop_data;=0A=
+		acb->rqbuf_lastindex++;=0A=
+		acb->rqbuf_lastindex %=3D ARCMSR_MAX_QBUFFER;=0A=
+		iop_data++;=0A=
+		iop_len--;=0A=
 	}=0A=
+	arcmsr_iop_message_read(acb);=0A=
+	return 1;=0A=
+}=0A=
 =0A=
-	else {=0A=
+void=0A=
+arcmsr_iop2drv_data_wrote_handle(struct AdapterControlBlock *acb)=0A=
+{=0A=
+	unsigned long flags;=0A=
+	struct QBUFFER __iomem  *prbuffer;=0A=
+	int32_t buf_empty_len;=0A=
+=0A=
+	spin_lock_irqsave(&acb->rqbuffer_lock, flags);=0A=
+	prbuffer =3D arcmsr_get_iop_rqbuffer(acb);=0A=
+	buf_empty_len =3D (acb->rqbuf_lastindex - acb->rqbuf_firstindex - 1) &=0A=
+		(ARCMSR_MAX_QBUFFER - 1);=0A=
+	if (buf_empty_len >=3D prbuffer->data_len) {=0A=
+		if (arcmsr_Read_iop_rqbuffer_data(acb, prbuffer) =3D=3D 0)=0A=
+			acb->acb_flags |=3D ACB_F_IOPDATA_OVERFLOW;=0A=
+	} else=0A=
 		acb->acb_flags |=3D ACB_F_IOPDATA_OVERFLOW;=0A=
-	}=0A=
+	spin_unlock_irqrestore(&acb->rqbuffer_lock, flags);=0A=
 }=0A=
 =0A=
-static void arcmsr_iop2drv_data_read_handle(struct AdapterControlBlock =
*acb)=0A=
+static void=0A=
+arcmsr_write_ioctldata2iop_in_DWORD(struct AdapterControlBlock *acb)=0A=
 {=0A=
-	acb->acb_flags |=3D ACB_F_MESSAGE_WQBUFFER_READED;=0A=
-	if (acb->wqbuf_firstindex !=3D acb->wqbuf_lastindex) {=0A=
-		uint8_t *pQbuffer;=0A=
-		struct QBUFFER __iomem *pwbuffer;=0A=
-		uint8_t __iomem *iop_data;=0A=
-		int32_t allxfer_len =3D 0;=0A=
+	uint8_t *pQbuffer;=0A=
+	struct QBUFFER __iomem *pwbuffer;=0A=
+	uint8_t *buf1 =3D 0;=0A=
+	uint32_t __iomem *iop_data;=0A=
+	uint32_t allxfer_len =3D 0, data_len, *buf2 =3D 0;=0A=
+=0A=
+	if (acb->acb_flags & ACB_F_MESSAGE_WQBUFFER_READED) {=0A=
+		buf1 =3D (uint8_t *)kmalloc(128, GFP_ATOMIC);=0A=
+		buf2 =3D (uint32_t *)buf1;=0A=
+		if (buf1 =3D=3D NULL)=0A=
+			return;=0A=
 =0A=
 		acb->acb_flags &=3D (~ACB_F_MESSAGE_WQBUFFER_READED);=0A=
 		pwbuffer =3D arcmsr_get_iop_wqbuffer(acb);=0A=
-		iop_data =3D (uint8_t __iomem *)pwbuffer->data;=0A=
+		iop_data =3D (uint32_t *)pwbuffer->data;=0A=
+		while ((acb->wqbuf_firstindex !=3D acb->wqbuf_lastindex)=0A=
+			&& (allxfer_len < 124)) {=0A=
+			pQbuffer =3D &acb->wqbuffer[acb->wqbuf_firstindex];=0A=
+			*buf1 =3D *pQbuffer;=0A=
+			acb->wqbuf_firstindex++;=0A=
+			acb->wqbuf_firstindex %=3D ARCMSR_MAX_QBUFFER;=0A=
+			buf1++;=0A=
+			allxfer_len++;=0A=
+		}=0A=
+		data_len =3D allxfer_len;=0A=
+		buf1 =3D (uint8_t *)buf2;=0A=
+		while (data_len >=3D 4) {=0A=
+			*iop_data++ =3D *buf2++;=0A=
+			data_len -=3D 4;=0A=
+		}=0A=
+		if (data_len)=0A=
+			*iop_data =3D *buf2;=0A=
+		writel(allxfer_len, &pwbuffer->data_len);=0A=
+		kfree((const void *)buf1);=0A=
+		arcmsr_iop_message_wrote(acb);=0A=
+	}=0A=
+}=0A=
+=0A=
+void=0A=
+arcmsr_write_ioctldata2iop(struct AdapterControlBlock *acb)=0A=
+{=0A=
+	uint8_t *pQbuffer;=0A=
+	struct QBUFFER __iomem *pwbuffer;=0A=
+	uint8_t __iomem *iop_data;=0A=
+	int32_t allxfer_len =3D 0;=0A=
 =0A=
-		while ((acb->wqbuf_firstindex !=3D acb->wqbuf_lastindex) && \=0A=
-							(allxfer_len < 124)) {=0A=
+	if (acb->adapter_type & (ACB_ADAPTER_TYPE_C | ACB_ADAPTER_TYPE_D)) {=0A=
+		arcmsr_write_ioctldata2iop_in_DWORD(acb);=0A=
+		return;=0A=
+	}=0A=
+	if (acb->acb_flags & ACB_F_MESSAGE_WQBUFFER_READED) {=0A=
+		acb->acb_flags &=3D (~ACB_F_MESSAGE_WQBUFFER_READED);=0A=
+		pwbuffer =3D arcmsr_get_iop_wqbuffer(acb);=0A=
+		iop_data =3D (uint8_t *)pwbuffer->data;=0A=
+		while ((acb->wqbuf_firstindex !=3D acb->wqbuf_lastindex)=0A=
+			&& (allxfer_len < 124)) {=0A=
 			pQbuffer =3D &acb->wqbuffer[acb->wqbuf_firstindex];=0A=
-			memcpy(iop_data, pQbuffer, 1);=0A=
+			*iop_data =3D *pQbuffer;=0A=
 			acb->wqbuf_firstindex++;=0A=
 			acb->wqbuf_firstindex %=3D ARCMSR_MAX_QBUFFER;=0A=
 			iop_data++;=0A=
 			allxfer_len++;=0A=
 		}=0A=
-		pwbuffer->data_len =3D allxfer_len;=0A=
-=0A=
+		writel(allxfer_len, &pwbuffer->data_len);=0A=
 		arcmsr_iop_message_wrote(acb);=0A=
 	}=0A=
+}=0A=
+=0A=
+void=0A=
+arcmsr_iop2drv_data_read_handle(struct AdapterControlBlock *acb)=0A=
+{=0A=
+	unsigned long flags;=0A=
 =0A=
-	if (acb->wqbuf_firstindex =3D=3D acb->wqbuf_lastindex) {=0A=
+	spin_lock_irqsave(&acb->wqbuffer_lock, flags);=0A=
+	acb->acb_flags |=3D ACB_F_MESSAGE_WQBUFFER_READED;=0A=
+	if (acb->wqbuf_firstindex !=3D acb->wqbuf_lastindex)=0A=
+		arcmsr_write_ioctldata2iop(acb);=0A=
+	if (acb->wqbuf_firstindex =3D=3D acb->wqbuf_lastindex)=0A=
 		acb->acb_flags |=3D ACB_F_MESSAGE_WQBUFFER_CLEARED;=0A=
-	}=0A=
+	spin_unlock_irqrestore(&acb->wqbuffer_lock, flags);=0A=
 }=0A=
 =0A=
-static void arcmsr_hba_doorbell_isr(struct AdapterControlBlock *acb)=0A=
+static void=0A=
+arcmsr_hbaA_doorbell_isr(struct AdapterControlBlock *acb)=0A=
 {=0A=
 	uint32_t outbound_doorbell;=0A=
-	struct MessageUnit_A __iomem *reg =3D acb->pmuA;=0A=
+	struct MessageUnit_A __iomem *reg  =3D acb->pmuA;=0A=
 	outbound_doorbell =3D readl(&reg->outbound_doorbell);=0A=
-	writel(outbound_doorbell, &reg->outbound_doorbell);=0A=
-	if (outbound_doorbell & ARCMSR_OUTBOUND_IOP331_DATA_WRITE_OK) {=0A=
-		arcmsr_iop2drv_data_wrote_handle(acb);=0A=
-	}=0A=
-=0A=
-	if (outbound_doorbell & ARCMSR_OUTBOUND_IOP331_DATA_READ_OK) {=0A=
-		arcmsr_iop2drv_data_read_handle(acb);=0A=
-	}=0A=
+	do {=0A=
+		writel(outbound_doorbell, &reg->outbound_doorbell);=0A=
+		if (outbound_doorbell &=0A=
+			ARCMSR_OUTBOUND_IOP331_DATA_WRITE_OK)=0A=
+			arcmsr_iop2drv_data_wrote_handle(acb);=0A=
+		if (outbound_doorbell &=0A=
+			ARCMSR_OUTBOUND_IOP331_DATA_READ_OK)=0A=
+			arcmsr_iop2drv_data_read_handle(acb);=0A=
+		outbound_doorbell =3D readl(&reg->outbound_doorbell);=0A=
+	} while (outbound_doorbell &=0A=
+	(ARCMSR_OUTBOUND_IOP331_DATA_WRITE_OK=0A=
+	| ARCMSR_OUTBOUND_IOP331_DATA_READ_OK));=0A=
 }=0A=
-static void arcmsr_hbc_doorbell_isr(struct AdapterControlBlock *pACB)=0A=
+static void=0A=
+arcmsr_hbaC_doorbell_isr(struct AdapterControlBlock *pACB)=0A=
 {=0A=
 	uint32_t outbound_doorbell;=0A=
-	struct MessageUnit_C *reg =3D (struct MessageUnit_C *)pACB->pmuC;=0A=
-	/*=0A=
-	*******************************************************************=0A=
-	**  Maybe here we need to check wrqbuffer_lock is lock or not=0A=
-	**  DOORBELL: din! don!=0A=
-	**  check if there are any mail need to pack from firmware=0A=
-	*******************************************************************=0A=
-	*/=0A=
+	struct MessageUnit_C __iomem *reg =3D pACB->pmuC;=0A=
 	outbound_doorbell =3D readl(&reg->outbound_doorbell);=0A=
-	writel(outbound_doorbell, &reg->outbound_doorbell_clear);/*clear =
interrupt*/=0A=
-	if (outbound_doorbell & ARCMSR_HBCMU_IOP2DRV_DATA_WRITE_OK) {=0A=
-		arcmsr_iop2drv_data_wrote_handle(pACB);=0A=
-	}=0A=
-	if (outbound_doorbell & ARCMSR_HBCMU_IOP2DRV_DATA_READ_OK) {=0A=
-		arcmsr_iop2drv_data_read_handle(pACB);=0A=
-	}=0A=
-	if (outbound_doorbell & ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE) {=0A=
-		arcmsr_hbc_message_isr(pACB);    /* messenger of "driver to iop =
commands" */=0A=
-	}=0A=
-	return;=0A=
+	do {=0A=
+		if (outbound_doorbell &=0A=
+			ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE)=0A=
+			arcmsr_hbaC_message_isr(pACB);=0A=
+		writel(outbound_doorbell, &reg->outbound_doorbell_clear);=0A=
+		readl(&reg->outbound_doorbell_clear);=0A=
+		if (outbound_doorbell &=0A=
+			ARCMSR_HBCMU_IOP2DRV_DATA_WRITE_OK)=0A=
+			arcmsr_iop2drv_data_wrote_handle(pACB);=0A=
+		if (outbound_doorbell &=0A=
+			ARCMSR_HBCMU_IOP2DRV_DATA_READ_OK)=0A=
+			arcmsr_iop2drv_data_read_handle(pACB);=0A=
+		outbound_doorbell =3D readl(&reg->outbound_doorbell);=0A=
+	} while (outbound_doorbell & (ARCMSR_HBCMU_IOP2DRV_DATA_WRITE_OK=0A=
+	| ARCMSR_HBCMU_IOP2DRV_DATA_READ_OK=0A=
+	| ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE));=0A=
 }=0A=
-static void arcmsr_hba_postqueue_isr(struct AdapterControlBlock *acb)=0A=
+=0A=
+static void=0A=
+arcmsr_hbaD_doorbell_isr(struct AdapterControlBlock *pACB)=0A=
+{=0A=
+	uint32_t outbound_doorbell;=0A=
+	struct MessageUnit_D __iomem *pmu =3D pACB->pmuD;=0A=
+=0A=
+	outbound_doorbell =3D readl(pmu->outbound_doorbell);=0A=
+	do {=0A=
+		writel(outbound_doorbell, pmu->outbound_doorbell);=0A=
+		if (outbound_doorbell &=0A=
+			ARCMSR_ARC1214_IOP2DRV_MESSAGE_CMD_DONE)=0A=
+			arcmsr_hbaD_message_isr(pACB);=0A=
+		if (outbound_doorbell &=0A=
+			ARCMSR_ARC1214_IOP2DRV_DATA_WRITE_OK)=0A=
+			arcmsr_iop2drv_data_wrote_handle(pACB);=0A=
+		if (outbound_doorbell &=0A=
+			ARCMSR_ARC1214_IOP2DRV_DATA_READ_OK)=0A=
+			arcmsr_iop2drv_data_read_handle(pACB);=0A=
+		outbound_doorbell =3D readl(pmu->outbound_doorbell);=0A=
+	} while (outbound_doorbell & (ARCMSR_ARC1214_IOP2DRV_DATA_WRITE_OK=0A=
+	| ARCMSR_ARC1214_IOP2DRV_DATA_READ_OK=0A=
+	| ARCMSR_ARC1214_IOP2DRV_MESSAGE_CMD_DONE));=0A=
+}=0A=
+=0A=
+static void=0A=
+arcmsr_hbaA_postqueue_isr(struct AdapterControlBlock *acb)=0A=
 {=0A=
 	uint32_t flag_ccb;=0A=
 	struct MessageUnit_A __iomem *reg =3D acb->pmuA;=0A=
@@ -1482,26 +2246,34 @@ static void arcmsr_hba_postqueue_isr(str=0A=
 	struct CommandControlBlock *pCCB;=0A=
 	bool error;=0A=
 	while ((flag_ccb =3D readl(&reg->outbound_queueport)) !=3D 0xFFFFFFFF) =
{=0A=
-		pARCMSR_CDB =3D (struct ARCMSR_CDB *)(acb->vir2phy_offset + (flag_ccb =
<< 5));/*frame must be 32 bytes aligned*/=0A=
-		pCCB =3D container_of(pARCMSR_CDB, struct CommandControlBlock, =
arcmsr_cdb);=0A=
-		error =3D (flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR_MODE0) ? true : =
false;=0A=
+		pARCMSR_CDB =3D (struct ARCMSR_CDB *)=0A=
+			(acb->vir2phy_offset + (flag_ccb << 5));=0A=
+		pCCB =3D container_of(pARCMSR_CDB,=0A=
+			struct CommandControlBlock, arcmsr_cdb);=0A=
+		error =3D (flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR_MODE0)=0A=
+			? true : false;=0A=
 		arcmsr_drain_donequeue(acb, pCCB, error);=0A=
 	}=0A=
 }=0A=
-static void arcmsr_hbb_postqueue_isr(struct AdapterControlBlock *acb)=0A=
+static void=0A=
+arcmsr_hbaB_postqueue_isr(struct AdapterControlBlock *acb)=0A=
 {=0A=
 	uint32_t index;=0A=
 	uint32_t flag_ccb;=0A=
-	struct MessageUnit_B *reg =3D acb->pmuB;=0A=
+	struct MessageUnit_B __iomem *reg =3D acb->pmuB;=0A=
 	struct ARCMSR_CDB *pARCMSR_CDB;=0A=
 	struct CommandControlBlock *pCCB;=0A=
 	bool error;=0A=
 	index =3D reg->doneq_index;=0A=
 	while ((flag_ccb =3D readl(&reg->done_qbuffer[index])) !=3D 0) {=0A=
 		writel(0, &reg->done_qbuffer[index]);=0A=
-		pARCMSR_CDB =3D (struct ARCMSR_CDB *)(acb->vir2phy_offset+(flag_ccb =
<< 5));/*frame must be 32 bytes aligned*/=0A=
-		pCCB =3D container_of(pARCMSR_CDB, struct CommandControlBlock, =
arcmsr_cdb);=0A=
-		error =3D (flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR_MODE0) ? true : =
false;=0A=
+		pARCMSR_CDB =3D (struct ARCMSR_CDB *)=0A=
+		(acb->vir2phy_offset + (flag_ccb << 5));=0A=
+		pCCB =3D container_of(pARCMSR_CDB,=0A=
+		struct CommandControlBlock, arcmsr_cdb);=0A=
+		error =3D (flag_ccb &=0A=
+		ARCMSR_CCBREPLY_FLAG_ERROR_MODE0)=0A=
+		? true : false;=0A=
 		arcmsr_drain_donequeue(acb, pCCB, error);=0A=
 		index++;=0A=
 		index %=3D ARCMSR_MAX_HBB_POSTQUEUE;=0A=
@@ -1509,178 +2281,257 @@ static void arcmsr_hbb_postqueue_isr(str=0A=
 	}=0A=
 }=0A=
 =0A=
-static void arcmsr_hbc_postqueue_isr(struct AdapterControlBlock *acb)=0A=
+static void=0A=
+arcmsr_hbaC_postqueue_isr(struct AdapterControlBlock *acb)=0A=
 {=0A=
-	struct MessageUnit_C *phbcmu;=0A=
-	struct ARCMSR_CDB *arcmsr_cdb;=0A=
-	struct CommandControlBlock *ccb;=0A=
 	uint32_t flag_ccb, ccb_cdb_phy, throttling =3D 0;=0A=
 	int error;=0A=
+	struct MessageUnit_C __iomem *phbcmu;=0A=
+	struct ARCMSR_CDB *arcmsr_cdb;=0A=
+	struct CommandControlBlock *ccb;=0A=
 =0A=
-	phbcmu =3D (struct MessageUnit_C *)acb->pmuC;=0A=
+	phbcmu =3D acb->pmuC;=0A=
 	/* areca cdb command done */=0A=
 	/* Use correct offset and size for syncing */=0A=
+	do {=0A=
+		/* check if command done with no error*/=0A=
+		flag_ccb =3D readl(&phbcmu->outbound_queueport_low);=0A=
+		ccb_cdb_phy =3D (flag_ccb & 0xFFFFFFF0);=0A=
+		arcmsr_cdb =3D (struct ARCMSR_CDB *)(acb->vir2phy_offset=0A=
+			+ ccb_cdb_phy);=0A=
+		ccb =3D container_of(arcmsr_cdb, struct CommandControlBlock,=0A=
+			arcmsr_cdb);=0A=
+		error =3D (flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR_MODE1)=0A=
+			? true : false;=0A=
+		/* check if command done with no error */=0A=
+		arcmsr_drain_donequeue(acb, ccb, error);=0A=
+		throttling++;=0A=
+		if (throttling =3D=3D ARCMSR_HBC_ISR_THROTTLING_LEVEL) {=0A=
+			writel(ARCMSR_HBCMU_DRV2IOP_POSTQUEUE_THROTTLING,=0A=
+				&phbcmu->inbound_doorbell);=0A=
+			throttling =3D 0;=0A=
+		}=0A=
+	} while (readl(&phbcmu->host_int_status) &=0A=
+	ARCMSR_HBCMU_OUTBOUND_POSTQUEUE_ISR);=0A=
+}=0A=
 =0A=
-	while (readl(&phbcmu->host_int_status) &=0A=
-	ARCMSR_HBCMU_OUTBOUND_POSTQUEUE_ISR){=0A=
-	/* check if command done with no error*/=0A=
-	flag_ccb =3D readl(&phbcmu->outbound_queueport_low);=0A=
-	ccb_cdb_phy =3D (flag_ccb & 0xFFFFFFF0);/*frame must be 32 bytes =
aligned*/=0A=
-	arcmsr_cdb =3D (struct ARCMSR_CDB *)(acb->vir2phy_offset + =
ccb_cdb_phy);=0A=
-	ccb =3D container_of(arcmsr_cdb, struct CommandControlBlock, =
arcmsr_cdb);=0A=
-	error =3D (flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR_MODE1) ? true : false;=0A=
-	/* check if command done with no error */=0A=
-	arcmsr_drain_donequeue(acb, ccb, error);=0A=
-	if (throttling =3D=3D ARCMSR_HBC_ISR_THROTTLING_LEVEL) {=0A=
-		writel(ARCMSR_HBCMU_DRV2IOP_POSTQUEUE_THROTTLING, =
&phbcmu->inbound_doorbell);=0A=
-		break;=0A=
-	}=0A=
-	throttling++;=0A=
-	}=0A=
+static void=0A=
+arcmsr_hbaD_postqueue_isr(struct AdapterControlBlock *acb)=0A=
+{=0A=
+	u32 outbound_write_pointer, doneq_index, index_stripped;=0A=
+	uint32_t addressLow, ccb_cdb_phy;=0A=
+	int error;=0A=
+	struct MessageUnit_D __iomem *pmu;=0A=
+	struct ARCMSR_CDB *arcmsr_cdb;=0A=
+	struct CommandControlBlock *ccb;=0A=
+	unsigned long flags;=0A=
+=0A=
+	spin_lock_irqsave(&acb->doneq_lock, flags);=0A=
+	pmu =3D acb->pmuD;=0A=
+	outbound_write_pointer =3D pmu->done_qbuffer[0].addressLow + 1;=0A=
+	doneq_index =3D pmu->doneq_index;=0A=
+	if ((doneq_index & 0xFFF) !=3D (outbound_write_pointer & 0xFFF)) {=0A=
+		do {=0A=
+			if (doneq_index & 0x4000) {=0A=
+				index_stripped =3D doneq_index & 0xFFF;=0A=
+				index_stripped +=3D 1;=0A=
+				index_stripped %=3D ARCMSR_MAX_ARC1214_DONEQUEUE;=0A=
+				pmu->doneq_index =3D index_stripped=0A=
+				? (index_stripped | 0x4000) : (index_stripped + 1);=0A=
+			} else {=0A=
+				index_stripped =3D doneq_index;=0A=
+				index_stripped +=3D 1;=0A=
+				index_stripped %=3D ARCMSR_MAX_ARC1214_DONEQUEUE;=0A=
+				pmu->doneq_index =3D index_stripped=0A=
+				? index_stripped : ((index_stripped | 0x4000) + 1);=0A=
+			}=0A=
+			doneq_index =3D pmu->doneq_index;=0A=
+			addressLow =3D=0A=
+			pmu->done_qbuffer[doneq_index & 0xFFF].addressLow;=0A=
+			ccb_cdb_phy =3D (addressLow & 0xFFFFFFF0);=0A=
+			arcmsr_cdb =3D (struct ARCMSR_CDB *)(acb->vir2phy_offset=0A=
+				+ ccb_cdb_phy);=0A=
+			ccb =3D container_of(arcmsr_cdb,=0A=
+				struct CommandControlBlock, arcmsr_cdb);=0A=
+			error =3D (addressLow & ARCMSR_CCBREPLY_FLAG_ERROR_MODE1)=0A=
+				? true : false;=0A=
+			arcmsr_drain_donequeue(acb, ccb, error);=0A=
+			writel(doneq_index,=0A=
+				pmu->outboundlist_read_pointer);=0A=
+		} while ((doneq_index & 0xFFF) !=3D=0A=
+		(outbound_write_pointer & 0xFFF));=0A=
+	}=0A=
+	writel(ARCMSR_ARC1214_OUTBOUND_LIST_INTERRUPT_CLEAR,=0A=
+		pmu->outboundlist_interrupt_cause);=0A=
+	readl(pmu->outboundlist_interrupt_cause);=0A=
+	spin_unlock_irqrestore(&acb->doneq_lock, flags);=0A=
 }=0A=
-/*=0A=
-************************************************************************=
**********=0A=
-** Handle a message interrupt=0A=
-**=0A=
-** The only message interrupt we expect is in response to a query for =
the current adapter config.  =0A=
-** We want this in order to compare the drivemap so that we can detect =
newly-attached drives.=0A=
-************************************************************************=
**********=0A=
-*/=0A=
-static void arcmsr_hba_message_isr(struct AdapterControlBlock *acb)=0A=
+=0A=
+static void=0A=
+arcmsr_hbaA_message_isr(struct AdapterControlBlock *acb)=0A=
 {=0A=
-	struct MessageUnit_A *reg  =3D acb->pmuA;=0A=
+	struct MessageUnit_A __iomem *reg  =3D acb->pmuA;=0A=
 	/*clear interrupt and message state*/=0A=
 	writel(ARCMSR_MU_OUTBOUND_MESSAGE0_INT, &reg->outbound_intstatus);=0A=
 	schedule_work(&acb->arcmsr_do_message_isr_bh);=0A=
 }=0A=
-static void arcmsr_hbb_message_isr(struct AdapterControlBlock *acb)=0A=
+static void=0A=
+arcmsr_hbaB_message_isr(struct AdapterControlBlock *acb)=0A=
 {=0A=
-	struct MessageUnit_B *reg  =3D acb->pmuB;=0A=
+	struct MessageUnit_B __iomem *reg  =3D acb->pmuB;=0A=
 =0A=
 	/*clear interrupt and message state*/=0A=
 	writel(ARCMSR_MESSAGE_INT_CLEAR_PATTERN, reg->iop2drv_doorbell);=0A=
 	schedule_work(&acb->arcmsr_do_message_isr_bh);=0A=
 }=0A=
-/*=0A=
-************************************************************************=
**********=0A=
-** Handle a message interrupt=0A=
-**=0A=
-** The only message interrupt we expect is in response to a query for =
the=0A=
-** current adapter config.=0A=
-** We want this in order to compare the drivemap so that we can detect =
newly-attached drives.=0A=
-************************************************************************=
**********=0A=
-*/=0A=
-static void arcmsr_hbc_message_isr(struct AdapterControlBlock *acb)=0A=
+=0A=
+static void=0A=
+arcmsr_hbaC_message_isr(struct AdapterControlBlock *acb)=0A=
 {=0A=
-	struct MessageUnit_C *reg  =3D acb->pmuC;=0A=
+	struct MessageUnit_C __iomem *reg  =3D acb->pmuC;=0A=
 	/*clear interrupt and message state*/=0A=
-	writel(ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE_DOORBELL_CLEAR, =
&reg->outbound_doorbell_clear);=0A=
+	writel(ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE_DOORBELL_CLEAR,=0A=
+	&reg->outbound_doorbell_clear);=0A=
 	schedule_work(&acb->arcmsr_do_message_isr_bh);=0A=
 }=0A=
 =0A=
-static int arcmsr_handle_hba_isr(struct AdapterControlBlock *acb)=0A=
+static void=0A=
+arcmsr_hbaD_message_isr(struct AdapterControlBlock *acb)=0A=
+{=0A=
+	struct MessageUnit_D __iomem *reg  =3D acb->pmuD;=0A=
+	writel(ARCMSR_ARC1214_IOP2DRV_MESSAGE_CMD_DONE,=0A=
+		reg->outbound_doorbell);=0A=
+	readl(reg->outbound_doorbell);=0A=
+	schedule_work(&acb->arcmsr_do_message_isr_bh);=0A=
+}=0A=
+=0A=
+static irqreturn_t=0A=
+arcmsr_hbaA_handle_isr(struct AdapterControlBlock *acb)=0A=
 {=0A=
 	uint32_t outbound_intstatus;=0A=
 	struct MessageUnit_A __iomem *reg =3D acb->pmuA;=0A=
-	outbound_intstatus =3D readl(&reg->outbound_intstatus) &=0A=
-		acb->outbound_int_enable;=0A=
-	if (!(outbound_intstatus & ARCMSR_MU_OUTBOUND_HANDLE_INT))	{=0A=
-		return 1;=0A=
-	}=0A=
-	writel(outbound_intstatus, &reg->outbound_intstatus);=0A=
-	if (outbound_intstatus & ARCMSR_MU_OUTBOUND_DOORBELL_INT)	{=0A=
-		arcmsr_hba_doorbell_isr(acb);=0A=
-	}=0A=
-	if (outbound_intstatus & ARCMSR_MU_OUTBOUND_POSTQUEUE_INT) {=0A=
-		arcmsr_hba_postqueue_isr(acb);=0A=
-	}=0A=
-	if(outbound_intstatus & ARCMSR_MU_OUTBOUND_MESSAGE0_INT) 	{=0A=
-		/* messenger of "driver to iop commands" */=0A=
-		arcmsr_hba_message_isr(acb);=0A=
-	}=0A=
-	return 0;=0A=
+	outbound_intstatus =3D=0A=
+	readl(&reg->outbound_intstatus) & acb->outbound_int_enable;=0A=
+	if (!(outbound_intstatus & ARCMSR_MU_OUTBOUND_HANDLE_INT))=0A=
+		return IRQ_NONE;=0A=
+	do {=0A=
+		writel(outbound_intstatus, &reg->outbound_intstatus);=0A=
+		if (outbound_intstatus & ARCMSR_MU_OUTBOUND_DOORBELL_INT)=0A=
+			arcmsr_hbaA_doorbell_isr(acb);=0A=
+		if (outbound_intstatus & ARCMSR_MU_OUTBOUND_POSTQUEUE_INT)=0A=
+			arcmsr_hbaA_postqueue_isr(acb);=0A=
+		if (outbound_intstatus & ARCMSR_MU_OUTBOUND_MESSAGE0_INT)=0A=
+			arcmsr_hbaA_message_isr(acb);=0A=
+		outbound_intstatus =3D readl(&reg->outbound_intstatus) &=0A=
+			acb->outbound_int_enable;=0A=
+	} while (outbound_intstatus & (ARCMSR_MU_OUTBOUND_DOORBELL_INT=0A=
+	| ARCMSR_MU_OUTBOUND_POSTQUEUE_INT=0A=
+	| ARCMSR_MU_OUTBOUND_MESSAGE0_INT));=0A=
+	return IRQ_HANDLED;=0A=
 }=0A=
 =0A=
-static int arcmsr_handle_hbb_isr(struct AdapterControlBlock *acb)=0A=
+static irqreturn_t=0A=
+arcmsr_hbaB_handle_isr(struct AdapterControlBlock *acb)=0A=
 {=0A=
 	uint32_t outbound_doorbell;=0A=
-	struct MessageUnit_B *reg =3D acb->pmuB;=0A=
-	outbound_doorbell =3D readl(reg->iop2drv_doorbell) &=0A=
-				acb->outbound_int_enable;=0A=
+	struct MessageUnit_B __iomem *reg =3D acb->pmuB;=0A=
+	outbound_doorbell =3D readl(reg->iop2drv_doorbell)=0A=
+		& acb->outbound_int_enable;=0A=
 	if (!outbound_doorbell)=0A=
-		return 1;=0A=
-=0A=
-	writel(~outbound_doorbell, reg->iop2drv_doorbell);=0A=
-	/*in case the last action of doorbell interrupt clearance is cached,=0A=
-	this action can push HW to write down the clear bit*/=0A=
-	readl(reg->iop2drv_doorbell);=0A=
-	writel(ARCMSR_DRV2IOP_END_OF_INTERRUPT, reg->drv2iop_doorbell);=0A=
-	if (outbound_doorbell & ARCMSR_IOP2DRV_DATA_WRITE_OK) {=0A=
-		arcmsr_iop2drv_data_wrote_handle(acb);=0A=
-	}=0A=
-	if (outbound_doorbell & ARCMSR_IOP2DRV_DATA_READ_OK) {=0A=
-		arcmsr_iop2drv_data_read_handle(acb);=0A=
-	}=0A=
-	if (outbound_doorbell & ARCMSR_IOP2DRV_CDB_DONE) {=0A=
-		arcmsr_hbb_postqueue_isr(acb);=0A=
-	}=0A=
-	if(outbound_doorbell & ARCMSR_IOP2DRV_MESSAGE_CMD_DONE) {=0A=
-		/* messenger of "driver to iop commands" */=0A=
-		arcmsr_hbb_message_isr(acb);=0A=
-	}=0A=
-	return 0;=0A=
+		return IRQ_NONE;=0A=
+	do {=0A=
+		writel(~outbound_doorbell, reg->iop2drv_doorbell);=0A=
+		readl(reg->iop2drv_doorbell);=0A=
+		writel(ARCMSR_DRV2IOP_END_OF_INTERRUPT,=0A=
+			reg->drv2iop_doorbell);=0A=
+		readl(reg->drv2iop_doorbell);=0A=
+		if (outbound_doorbell & ARCMSR_IOP2DRV_DATA_WRITE_OK)=0A=
+			arcmsr_iop2drv_data_wrote_handle(acb);=0A=
+		if (outbound_doorbell & ARCMSR_IOP2DRV_DATA_READ_OK)=0A=
+			arcmsr_iop2drv_data_read_handle(acb);=0A=
+		if (outbound_doorbell & ARCMSR_IOP2DRV_CDB_DONE)=0A=
+			arcmsr_hbaB_postqueue_isr(acb);=0A=
+		if (outbound_doorbell & ARCMSR_IOP2DRV_MESSAGE_CMD_DONE)=0A=
+			arcmsr_hbaB_message_isr(acb);=0A=
+		outbound_doorbell =3D readl(reg->iop2drv_doorbell) &=0A=
+			acb->outbound_int_enable;=0A=
+	} while (outbound_doorbell & (ARCMSR_IOP2DRV_DATA_WRITE_OK=0A=
+	| ARCMSR_IOP2DRV_DATA_READ_OK=0A=
+	| ARCMSR_IOP2DRV_CDB_DONE=0A=
+	| ARCMSR_IOP2DRV_MESSAGE_CMD_DONE));=0A=
+	return IRQ_HANDLED;=0A=
 }=0A=
 =0A=
-static int arcmsr_handle_hbc_isr(struct AdapterControlBlock *pACB)=0A=
+static irqreturn_t=0A=
+arcmsr_hbaC_handle_isr(struct AdapterControlBlock *pACB)=0A=
 {=0A=
 	uint32_t host_interrupt_status;=0A=
-	struct MessageUnit_C *phbcmu =3D (struct MessageUnit_C *)pACB->pmuC;=0A=
-	/*=0A=
-	*********************************************=0A=
-	**   check outbound intstatus=0A=
-	*********************************************=0A=
-	*/=0A=
-	host_interrupt_status =3D readl(&phbcmu->host_int_status);=0A=
-	if (!host_interrupt_status) {=0A=
-		/*it must be share irq*/=0A=
-		return 1;=0A=
-	}=0A=
-	/* MU ioctl transfer doorbell interrupts*/=0A=
-	if (host_interrupt_status & ARCMSR_HBCMU_OUTBOUND_DOORBELL_ISR) {=0A=
-		arcmsr_hbc_doorbell_isr(pACB);   /* messenger of "ioctl message read =
write" */=0A=
-	}=0A=
-	/* MU post queue interrupts*/=0A=
-	if (host_interrupt_status & ARCMSR_HBCMU_OUTBOUND_POSTQUEUE_ISR) {=0A=
-		arcmsr_hbc_postqueue_isr(pACB);  /* messenger of "scsi commands" */=0A=
-	}=0A=
-	return 0;=0A=
+	struct MessageUnit_C __iomem *phbcmu =3D pACB->pmuC;=0A=
+	host_interrupt_status =3D=0A=
+		readl(&phbcmu->host_int_status);=0A=
+	do {=0A=
+		if (host_interrupt_status &=0A=
+			ARCMSR_HBCMU_OUTBOUND_DOORBELL_ISR)=0A=
+			arcmsr_hbaC_doorbell_isr(pACB);=0A=
+		/* MU post queue interrupts*/=0A=
+		if (host_interrupt_status &=0A=
+			ARCMSR_HBCMU_OUTBOUND_POSTQUEUE_ISR)=0A=
+			arcmsr_hbaC_postqueue_isr(pACB);=0A=
+		host_interrupt_status =3D readl(&phbcmu->host_int_status);=0A=
+	} while (host_interrupt_status &=0A=
+	(ARCMSR_HBCMU_OUTBOUND_POSTQUEUE_ISR |=0A=
+	ARCMSR_HBCMU_OUTBOUND_DOORBELL_ISR));=0A=
+	return IRQ_HANDLED;=0A=
+}=0A=
+=0A=
+static irqreturn_t=0A=
+arcmsr_hbaD_handle_isr(struct AdapterControlBlock *pACB)=0A=
+{=0A=
+	u32 host_interrupt_status;=0A=
+	struct MessageUnit_D __iomem *pmu =3D pACB->pmuD;=0A=
+	host_interrupt_status =3D readl(pmu->host_int_status);=0A=
+	do {=0A=
+		/* MU post queue interrupts*/=0A=
+		if (host_interrupt_status &=0A=
+			ARCMSR_ARC1214_OUTBOUND_POSTQUEUE_ISR)=0A=
+			arcmsr_hbaD_postqueue_isr(pACB);=0A=
+		if (host_interrupt_status &=0A=
+			ARCMSR_ARC1214_OUTBOUND_DOORBELL_ISR)=0A=
+			arcmsr_hbaD_doorbell_isr(pACB);=0A=
+		host_interrupt_status =3D readl(pmu->host_int_status);=0A=
+	} while (host_interrupt_status &=0A=
+	(ARCMSR_ARC1214_OUTBOUND_POSTQUEUE_ISR |=0A=
+	ARCMSR_ARC1214_OUTBOUND_DOORBELL_ISR));=0A=
+	return IRQ_HANDLED;=0A=
 }=0A=
-static irqreturn_t arcmsr_interrupt(struct AdapterControlBlock *acb)=0A=
+=0A=
+static irqreturn_t=0A=
+arcmsr_interrupt(struct AdapterControlBlock *acb)=0A=
 {=0A=
 	switch (acb->adapter_type) {=0A=
 	case ACB_ADAPTER_TYPE_A: {=0A=
-		if (arcmsr_handle_hba_isr(acb)) {=0A=
-			return IRQ_NONE;=0A=
-		}=0A=
-		}=0A=
+		return arcmsr_hbaA_handle_isr(acb);=0A=
 		break;=0A=
-=0A=
+	}=0A=
 	case ACB_ADAPTER_TYPE_B: {=0A=
-		if (arcmsr_handle_hbb_isr(acb)) {=0A=
-			return IRQ_NONE;=0A=
-		}=0A=
-		}=0A=
+		return arcmsr_hbaB_handle_isr(acb);=0A=
 		break;=0A=
-	 case ACB_ADAPTER_TYPE_C: {=0A=
-		if (arcmsr_handle_hbc_isr(acb)) {=0A=
-			return IRQ_NONE;=0A=
-		}=0A=
-		}=0A=
 	}=0A=
-	return IRQ_HANDLED;=0A=
+	case ACB_ADAPTER_TYPE_C: {=0A=
+		return arcmsr_hbaC_handle_isr(acb);=0A=
+		break;=0A=
+	}=0A=
+	case ACB_ADAPTER_TYPE_D: {=0A=
+		return arcmsr_hbaD_handle_isr(acb);=0A=
+		break;=0A=
+	}=0A=
+	default:=0A=
+		return IRQ_NONE;=0A=
+	}=0A=
 }=0A=
 =0A=
-static void arcmsr_iop_parking(struct AdapterControlBlock *acb)=0A=
+static void=0A=
+arcmsr_iop_parking(struct AdapterControlBlock *acb)=0A=
 {=0A=
 	if (acb) {=0A=
 		/* stop adapter background rebuild */=0A=
@@ -1695,309 +2546,372 @@ static void arcmsr_iop_parking(struct Ad=0A=
 	}=0A=
 }=0A=
 =0A=
-void arcmsr_post_ioctldata2iop(struct AdapterControlBlock *acb)=0A=
+void=0A=
+arcmsr_clear_iop2drv_rqueue_buffer(struct AdapterControlBlock *acb)=0A=
 {=0A=
-	int32_t wqbuf_firstindex, wqbuf_lastindex;=0A=
-	uint8_t *pQbuffer;=0A=
-	struct QBUFFER __iomem *pwbuffer;=0A=
-	uint8_t __iomem *iop_data;=0A=
-	int32_t allxfer_len =3D 0;=0A=
-	pwbuffer =3D arcmsr_get_iop_wqbuffer(acb);=0A=
-	iop_data =3D (uint8_t __iomem *)pwbuffer->data;=0A=
-	if (acb->acb_flags & ACB_F_MESSAGE_WQBUFFER_READED) {=0A=
-		acb->acb_flags &=3D (~ACB_F_MESSAGE_WQBUFFER_READED);=0A=
-		wqbuf_firstindex =3D acb->wqbuf_firstindex;=0A=
-		wqbuf_lastindex =3D acb->wqbuf_lastindex;=0A=
-		while ((wqbuf_firstindex !=3D wqbuf_lastindex) && (allxfer_len < =
124)) {=0A=
-			pQbuffer =3D &acb->wqbuffer[wqbuf_firstindex];=0A=
-			memcpy(iop_data, pQbuffer, 1);=0A=
-			wqbuf_firstindex++;=0A=
-			wqbuf_firstindex %=3D ARCMSR_MAX_QBUFFER;=0A=
-			iop_data++;=0A=
-			allxfer_len++;=0A=
+	uint32_t	i;=0A=
+=0A=
+	if (acb->acb_flags & ACB_F_IOPDATA_OVERFLOW) {=0A=
+		for (i =3D 0; i < 15; i++) {=0A=
+			if (acb->acb_flags & ACB_F_IOPDATA_OVERFLOW) {=0A=
+				acb->acb_flags &=3D ~ACB_F_IOPDATA_OVERFLOW;=0A=
+				acb->rqbuf_firstindex =3D 0;=0A=
+				acb->rqbuf_lastindex =3D 0;=0A=
+				arcmsr_iop_message_read(acb);=0A=
+				mdelay(30);=0A=
+			} else if (acb->rqbuf_firstindex !=3D acb->rqbuf_lastindex) {=0A=
+				acb->rqbuf_firstindex =3D 0;=0A=
+				acb->rqbuf_lastindex =3D 0;=0A=
+				mdelay(30);=0A=
+			} else=0A=
+				break;=0A=
 		}=0A=
-		acb->wqbuf_firstindex =3D wqbuf_firstindex;=0A=
-		pwbuffer->data_len =3D allxfer_len;=0A=
-		arcmsr_iop_message_wrote(acb);=0A=
 	}=0A=
 }=0A=
 =0A=
-static int arcmsr_iop_message_xfer(struct AdapterControlBlock *acb,=0A=
+static int=0A=
+arcmsr_iop_message_xfer(struct AdapterControlBlock *acb,=0A=
 					struct scsi_cmnd *cmd)=0A=
 {=0A=
-	struct CMD_MESSAGE_FIELD *pcmdmessagefld;=0A=
-	int retvalue =3D 0, transfer_len =3D 0;=0A=
 	char *buffer;=0A=
+	unsigned short use_sg;=0A=
+	int retvalue =3D 0, transfer_len =3D 0;=0A=
+	unsigned long flags;=0A=
+	struct CMD_MESSAGE_FIELD *pcmdmessagefld;=0A=
+	uint32_t	controlcode =3D (uint32_t)cmd->cmnd[5] << 24 |=0A=
+		(uint32_t)cmd->cmnd[6] << 16 |=0A=
+		(uint32_t)cmd->cmnd[7] << 8 |=0A=
+		(uint32_t)cmd->cmnd[8];=0A=
 	struct scatterlist *sg;=0A=
-	uint32_t controlcode =3D (uint32_t ) cmd->cmnd[5] << 24 |=0A=
-						(uint32_t ) cmd->cmnd[6] << 16 |=0A=
-						(uint32_t ) cmd->cmnd[7] << 8  |=0A=
-						(uint32_t ) cmd->cmnd[8];=0A=
-						/* 4 bytes: Areca io control code */=0A=
+=0A=
+	use_sg =3D scsi_sg_count(cmd);=0A=
 	sg =3D scsi_sglist(cmd);=0A=
 	buffer =3D kmap_atomic(sg_page(sg)) + sg->offset;=0A=
-	if (scsi_sg_count(cmd) > 1) {=0A=
+	if (use_sg > 1) {=0A=
 		retvalue =3D ARCMSR_MESSAGE_FAIL;=0A=
 		goto message_out;=0A=
 	}=0A=
 	transfer_len +=3D sg->length;=0A=
-=0A=
 	if (transfer_len > sizeof(struct CMD_MESSAGE_FIELD)) {=0A=
 		retvalue =3D ARCMSR_MESSAGE_FAIL;=0A=
+		pr_info("%s: ARCMSR_MESSAGE_FAIL!\n", __func__);=0A=
 		goto message_out;=0A=
 	}=0A=
-	pcmdmessagefld =3D (struct CMD_MESSAGE_FIELD *) buffer;=0A=
-	switch(controlcode) {=0A=
-=0A=
+	pcmdmessagefld =3D (struct CMD_MESSAGE_FIELD *)buffer;=0A=
+	switch (controlcode) {=0A=
 	case ARCMSR_MESSAGE_READ_RQBUFFER: {=0A=
 		unsigned char *ver_addr;=0A=
 		uint8_t *pQbuffer, *ptmpQbuffer;=0A=
-		int32_t allxfer_len =3D 0;=0A=
-=0A=
-		ver_addr =3D kmalloc(1032, GFP_ATOMIC);=0A=
+		uint32_t allxfer_len =3D 0;=0A=
+		ver_addr =3D (unsigned char *)kmalloc(1032, GFP_ATOMIC);=0A=
 		if (!ver_addr) {=0A=
 			retvalue =3D ARCMSR_MESSAGE_FAIL;=0A=
+			pr_info("%s: memory not enough!\n", __func__);=0A=
 			goto message_out;=0A=
 		}=0A=
-				=0A=
 		ptmpQbuffer =3D ver_addr;=0A=
-		while ((acb->rqbuf_firstindex !=3D acb->rqbuf_lastindex)=0A=
-			&& (allxfer_len < 1031)) {=0A=
+		spin_lock_irqsave(&acb->rqbuffer_lock, flags);=0A=
+		if (acb->rqbuf_firstindex !=3D acb->rqbuf_lastindex) {=0A=
 			pQbuffer =3D &acb->rqbuffer[acb->rqbuf_firstindex];=0A=
-			memcpy(ptmpQbuffer, pQbuffer, 1);=0A=
-			acb->rqbuf_firstindex++;=0A=
-			acb->rqbuf_firstindex %=3D ARCMSR_MAX_QBUFFER;=0A=
-			ptmpQbuffer++;=0A=
-			allxfer_len++;=0A=
+			if (acb->rqbuf_firstindex > acb->rqbuf_lastindex) {=0A=
+				if ((ARCMSR_MAX_QBUFFER -=0A=
+					acb->rqbuf_firstindex) >=3D 1032) {=0A=
+					memcpy((void *)ptmpQbuffer, (const void *)pQbuffer, 1032);=0A=
+					acb->rqbuf_firstindex +=3D 1032;=0A=
+					acb->rqbuf_firstindex %=3D ARCMSR_MAX_QBUFFER;=0A=
+					allxfer_len =3D 1032;=0A=
+				} else {=0A=
+					if (((ARCMSR_MAX_QBUFFER -=0A=
+						acb->rqbuf_firstindex) +=0A=
+						acb->rqbuf_lastindex) > 1032) {=0A=
+						memcpy((void *)ptmpQbuffer,=0A=
+						(const void *)pQbuffer, ARCMSR_MAX_QBUFFER=0A=
+						- acb->rqbuf_firstindex);=0A=
+						ptmpQbuffer +=3D=0A=
+						ARCMSR_MAX_QBUFFER -=0A=
+						acb->rqbuf_firstindex;=0A=
+						memcpy((void *)ptmpQbuffer,=0A=
+						(const void *)acb->rqbuffer, 1032 -=0A=
+						(ARCMSR_MAX_QBUFFER=0A=
+						- acb->rqbuf_firstindex));=0A=
+						acb->rqbuf_firstindex =3D=0A=
+						1032 - (ARCMSR_MAX_QBUFFER=0A=
+						- acb->rqbuf_firstindex);=0A=
+						allxfer_len =3D 1032;=0A=
+					} else {=0A=
+						memcpy((void *)ptmpQbuffer,=0A=
+						(const void *)pQbuffer, ARCMSR_MAX_QBUFFER=0A=
+						- acb->rqbuf_firstindex);=0A=
+						ptmpQbuffer +=3D=0A=
+						ARCMSR_MAX_QBUFFER -=0A=
+						acb->rqbuf_firstindex;=0A=
+						memcpy((void *)ptmpQbuffer,=0A=
+						(const void *)acb->rqbuffer,=0A=
+						acb->rqbuf_lastindex);=0A=
+						allxfer_len =3D ARCMSR_MAX_QBUFFER=0A=
+						- acb->rqbuf_firstindex +=0A=
+						acb->rqbuf_lastindex;=0A=
+						acb->rqbuf_firstindex =3D=0A=
+						acb->rqbuf_lastindex;=0A=
+					}=0A=
+				}=0A=
+			} else {=0A=
+				if ((acb->rqbuf_lastindex -=0A=
+				acb->rqbuf_firstindex) > 1032) {=0A=
+					memcpy((void *)ptmpQbuffer,=0A=
+					(const void *)pQbuffer, 1032);=0A=
+					acb->rqbuf_firstindex +=3D 1032;=0A=
+					allxfer_len =3D 1032;=0A=
+				} else {=0A=
+					memcpy((void *)ptmpQbuffer, (const void *)pQbuffer,=0A=
+					acb->rqbuf_lastindex - acb->rqbuf_firstindex);=0A=
+					allxfer_len =3D acb->rqbuf_lastindex=0A=
+					- acb->rqbuf_firstindex;=0A=
+					acb->rqbuf_firstindex =3D=0A=
+					acb->rqbuf_lastindex;=0A=
+				}=0A=
+			}=0A=
 		}=0A=
+		memcpy((void *)pcmdmessagefld->messagedatabuffer,=0A=
+			(const void *)ver_addr, allxfer_len);=0A=
 		if (acb->acb_flags & ACB_F_IOPDATA_OVERFLOW) {=0A=
-=0A=
 			struct QBUFFER __iomem *prbuffer;=0A=
-			uint8_t __iomem *iop_data;=0A=
-			int32_t iop_len;=0A=
-=0A=
 			acb->acb_flags &=3D ~ACB_F_IOPDATA_OVERFLOW;=0A=
 			prbuffer =3D arcmsr_get_iop_rqbuffer(acb);=0A=
-			iop_data =3D prbuffer->data;=0A=
-			iop_len =3D readl(&prbuffer->data_len);=0A=
-			while (iop_len > 0) {=0A=
-				acb->rqbuffer[acb->rqbuf_lastindex] =3D readb(iop_data);=0A=
-				acb->rqbuf_lastindex++;=0A=
-				acb->rqbuf_lastindex %=3D ARCMSR_MAX_QBUFFER;=0A=
-				iop_data++;=0A=
-				iop_len--;=0A=
-			}=0A=
-			arcmsr_iop_message_read(acb);=0A=
+			if (arcmsr_Read_iop_rqbuffer_data(acb, prbuffer) =3D=3D 0)=0A=
+				acb->acb_flags |=3D ACB_F_IOPDATA_OVERFLOW;=0A=
 		}=0A=
-		memcpy(pcmdmessagefld->messagedatabuffer, ver_addr, allxfer_len);=0A=
+		spin_unlock_irqrestore(&acb->rqbuffer_lock, flags);=0A=
+		kfree((const void *)ver_addr);=0A=
 		pcmdmessagefld->cmdmessage.Length =3D allxfer_len;=0A=
-		if(acb->fw_flag =3D=3D FW_DEADLOCK) {=0A=
-			pcmdmessagefld->cmdmessage.ReturnCode =3D =
ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;=0A=
-		}else{=0A=
-			pcmdmessagefld->cmdmessage.ReturnCode =3D =
ARCMSR_MESSAGE_RETURNCODE_OK;=0A=
-		}=0A=
-		kfree(ver_addr);=0A=
+		if (acb->fw_flag =3D=3D FW_DEADLOCK) {=0A=
+			pcmdmessagefld->cmdmessage.ReturnCode =3D=0A=
+			ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;=0A=
+		} else {=0A=
+			pcmdmessagefld->cmdmessage.ReturnCode =3D=0A=
+			ARCMSR_MESSAGE_RETURNCODE_OK;=0A=
 		}=0A=
 		break;=0A=
-=0A=
+	}=0A=
 	case ARCMSR_MESSAGE_WRITE_WQBUFFER: {=0A=
 		unsigned char *ver_addr;=0A=
-		int32_t my_empty_len, user_len, wqbuf_firstindex, wqbuf_lastindex;=0A=
+		int32_t my_empty_len, user_len, wqbuf_firstindex,=0A=
+		wqbuf_lastindex;=0A=
 		uint8_t *pQbuffer, *ptmpuserbuffer;=0A=
-=0A=
-		ver_addr =3D kmalloc(1032, GFP_ATOMIC);=0A=
+		ver_addr =3D (unsigned char *)kmalloc(1032, GFP_ATOMIC);=0A=
 		if (!ver_addr) {=0A=
 			retvalue =3D ARCMSR_MESSAGE_FAIL;=0A=
 			goto message_out;=0A=
 		}=0A=
-		if(acb->fw_flag =3D=3D FW_DEADLOCK) {=0A=
-			pcmdmessagefld->cmdmessage.ReturnCode =3D =0A=
-			ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;=0A=
-		}else{=0A=
-			pcmdmessagefld->cmdmessage.ReturnCode =3D =0A=
-			ARCMSR_MESSAGE_RETURNCODE_OK;=0A=
-		}=0A=
 		ptmpuserbuffer =3D ver_addr;=0A=
 		user_len =3D pcmdmessagefld->cmdmessage.Length;=0A=
-		memcpy(ptmpuserbuffer, pcmdmessagefld->messagedatabuffer, user_len);=0A=
+		memcpy((void *)ptmpuserbuffer,=0A=
+		(const void *)pcmdmessagefld->messagedatabuffer, user_len);=0A=
+		spin_lock_irqsave(&acb->wqbuffer_lock, flags);=0A=
 		wqbuf_lastindex =3D acb->wqbuf_lastindex;=0A=
 		wqbuf_firstindex =3D acb->wqbuf_firstindex;=0A=
 		if (wqbuf_lastindex !=3D wqbuf_firstindex) {=0A=
 			struct SENSE_DATA *sensebuffer =3D=0A=
-				(struct SENSE_DATA *)cmd->sense_buffer;=0A=
-			arcmsr_post_ioctldata2iop(acb);=0A=
+			(struct SENSE_DATA *)cmd->sense_buffer;=0A=
+			arcmsr_write_ioctldata2iop(acb);=0A=
 			/* has error report sensedata */=0A=
-			sensebuffer->ErrorCode =3D 0x70;=0A=
+			sensebuffer->ErrorCode =3D SCSI_SENSE_CURRENT_ERRORS;=0A=
 			sensebuffer->SenseKey =3D ILLEGAL_REQUEST;=0A=
 			sensebuffer->AdditionalSenseLength =3D 0x0A;=0A=
 			sensebuffer->AdditionalSenseCode =3D 0x20;=0A=
 			sensebuffer->Valid =3D 1;=0A=
 			retvalue =3D ARCMSR_MESSAGE_FAIL;=0A=
 		} else {=0A=
-			my_empty_len =3D (wqbuf_firstindex-wqbuf_lastindex - 1)=0A=
-				&(ARCMSR_MAX_QBUFFER - 1);=0A=
+			my_empty_len =3D (wqbuf_firstindex - wqbuf_lastindex - 1)=0A=
+			& (ARCMSR_MAX_QBUFFER - 1);=0A=
 			if (my_empty_len >=3D user_len) {=0A=
 				while (user_len > 0) {=0A=
-					pQbuffer =3D=0A=
-					&acb->wqbuffer[acb->wqbuf_lastindex];=0A=
-					memcpy(pQbuffer, ptmpuserbuffer, 1);=0A=
-					acb->wqbuf_lastindex++;=0A=
-					acb->wqbuf_lastindex %=3D ARCMSR_MAX_QBUFFER;=0A=
-					ptmpuserbuffer++;=0A=
-					user_len--;=0A=
+					pQbuffer =3D &acb->wqbuffer[acb->wqbuf_lastindex];=0A=
+					if ((acb->wqbuf_lastindex + user_len)=0A=
+						> ARCMSR_MAX_QBUFFER) {=0A=
+						memcpy((void *)pQbuffer,=0A=
+						(const void *)ptmpuserbuffer,=0A=
+						ARCMSR_MAX_QBUFFER -=0A=
+						acb->wqbuf_lastindex);=0A=
+						ptmpuserbuffer +=3D (ARCMSR_MAX_QBUFFER=0A=
+						- acb->wqbuf_lastindex);=0A=
+						user_len -=3D (ARCMSR_MAX_QBUFFER=0A=
+						- acb->wqbuf_lastindex);=0A=
+						acb->wqbuf_lastindex =3D 0;=0A=
+					} else {=0A=
+						memcpy((void *)pQbuffer,=0A=
+						(const void *)ptmpuserbuffer,=0A=
+						user_len);=0A=
+						acb->wqbuf_lastindex +=3D user_len;=0A=
+						acb->wqbuf_lastindex %=3D=0A=
+						ARCMSR_MAX_QBUFFER;=0A=
+						user_len =3D 0;=0A=
+					}=0A=
 				}=0A=
-				if (acb->acb_flags & ACB_F_MESSAGE_WQBUFFER_CLEARED) {=0A=
+				if (acb->acb_flags &=0A=
+				ACB_F_MESSAGE_WQBUFFER_CLEARED) {=0A=
 					acb->acb_flags &=3D=0A=
-						~ACB_F_MESSAGE_WQBUFFER_CLEARED;=0A=
-					arcmsr_post_ioctldata2iop(acb);=0A=
+					~ACB_F_MESSAGE_WQBUFFER_CLEARED;=0A=
+					arcmsr_write_ioctldata2iop(acb);=0A=
 				}=0A=
 			} else {=0A=
-				/* has error report sensedata */=0A=
 				struct SENSE_DATA *sensebuffer =3D=0A=
-					(struct SENSE_DATA *)cmd->sense_buffer;=0A=
-				sensebuffer->ErrorCode =3D 0x70;=0A=
+				(struct SENSE_DATA *)cmd->sense_buffer;=0A=
+				/* has error report sensedata */=0A=
+				sensebuffer->ErrorCode =3D=0A=
+				SCSI_SENSE_CURRENT_ERRORS;=0A=
 				sensebuffer->SenseKey =3D ILLEGAL_REQUEST;=0A=
 				sensebuffer->AdditionalSenseLength =3D 0x0A;=0A=
 				sensebuffer->AdditionalSenseCode =3D 0x20;=0A=
 				sensebuffer->Valid =3D 1;=0A=
 				retvalue =3D ARCMSR_MESSAGE_FAIL;=0A=
 			}=0A=
-			}=0A=
-			kfree(ver_addr);=0A=
+		}=0A=
+		spin_unlock_irqrestore(&acb->wqbuffer_lock, flags);=0A=
+		kfree((const void *)ver_addr);=0A=
+		if (acb->fw_flag =3D=3D FW_DEADLOCK) {=0A=
+			pcmdmessagefld->cmdmessage.ReturnCode =3D=0A=
+			ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;=0A=
+		} else {=0A=
+			pcmdmessagefld->cmdmessage.ReturnCode =3D=0A=
+			ARCMSR_MESSAGE_RETURNCODE_OK;=0A=
 		}=0A=
 		break;=0A=
-=0A=
+	}=0A=
 	case ARCMSR_MESSAGE_CLEAR_RQBUFFER: {=0A=
 		uint8_t *pQbuffer =3D acb->rqbuffer;=0A=
-		if (acb->acb_flags & ACB_F_IOPDATA_OVERFLOW) {=0A=
-			acb->acb_flags &=3D ~ACB_F_IOPDATA_OVERFLOW;=0A=
-			arcmsr_iop_message_read(acb);=0A=
-		}=0A=
+=0A=
+		arcmsr_clear_iop2drv_rqueue_buffer(acb);=0A=
+		spin_lock_irqsave(&acb->rqbuffer_lock, flags);=0A=
 		acb->acb_flags |=3D ACB_F_MESSAGE_RQBUFFER_CLEARED;=0A=
 		acb->rqbuf_firstindex =3D 0;=0A=
 		acb->rqbuf_lastindex =3D 0;=0A=
 		memset(pQbuffer, 0, ARCMSR_MAX_QBUFFER);=0A=
-		if(acb->fw_flag =3D=3D FW_DEADLOCK) {=0A=
+		spin_unlock_irqrestore(&acb->rqbuffer_lock, flags);=0A=
+		if (acb->fw_flag =3D=3D FW_DEADLOCK) {=0A=
 			pcmdmessagefld->cmdmessage.ReturnCode =3D=0A=
 			ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;=0A=
-		}else{=0A=
+		} else {=0A=
 			pcmdmessagefld->cmdmessage.ReturnCode =3D=0A=
 			ARCMSR_MESSAGE_RETURNCODE_OK;=0A=
 		}=0A=
-		}=0A=
 		break;=0A=
-=0A=
+	}=0A=
 	case ARCMSR_MESSAGE_CLEAR_WQBUFFER: {=0A=
 		uint8_t *pQbuffer =3D acb->wqbuffer;=0A=
-		if(acb->fw_flag =3D=3D FW_DEADLOCK) {=0A=
+		spin_lock_irqsave(&acb->wqbuffer_lock, flags);=0A=
+		acb->acb_flags |=3D (ACB_F_MESSAGE_WQBUFFER_CLEARED |=0A=
+		ACB_F_MESSAGE_WQBUFFER_READED);=0A=
+		acb->wqbuf_firstindex =3D 0;=0A=
+		acb->wqbuf_lastindex =3D 0;=0A=
+		memset(pQbuffer, 0, ARCMSR_MAX_QBUFFER);=0A=
+		spin_unlock_irqrestore(&acb->wqbuffer_lock, flags);=0A=
+		if (acb->fw_flag =3D=3D FW_DEADLOCK) {=0A=
 			pcmdmessagefld->cmdmessage.ReturnCode =3D=0A=
 			ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;=0A=
-		}else{=0A=
+		} else {=0A=
 			pcmdmessagefld->cmdmessage.ReturnCode =3D=0A=
 			ARCMSR_MESSAGE_RETURNCODE_OK;=0A=
 		}=0A=
-=0A=
-		if (acb->acb_flags & ACB_F_IOPDATA_OVERFLOW) {=0A=
-			acb->acb_flags &=3D ~ACB_F_IOPDATA_OVERFLOW;=0A=
-			arcmsr_iop_message_read(acb);=0A=
-		}=0A=
-		acb->acb_flags |=3D=0A=
-			(ACB_F_MESSAGE_WQBUFFER_CLEARED |=0A=
-				ACB_F_MESSAGE_WQBUFFER_READED);=0A=
-		acb->wqbuf_firstindex =3D 0;=0A=
-		acb->wqbuf_lastindex =3D 0;=0A=
-		memset(pQbuffer, 0, ARCMSR_MAX_QBUFFER);=0A=
-		}=0A=
 		break;=0A=
-=0A=
+	}=0A=
 	case ARCMSR_MESSAGE_CLEAR_ALLQBUFFER: {=0A=
 		uint8_t *pQbuffer;=0A=
-=0A=
-		if (acb->acb_flags & ACB_F_IOPDATA_OVERFLOW) {=0A=
-			acb->acb_flags &=3D ~ACB_F_IOPDATA_OVERFLOW;=0A=
-			arcmsr_iop_message_read(acb);=0A=
-		}=0A=
-		acb->acb_flags |=3D=0A=
-			(ACB_F_MESSAGE_WQBUFFER_CLEARED=0A=
-			| ACB_F_MESSAGE_RQBUFFER_CLEARED=0A=
-			| ACB_F_MESSAGE_WQBUFFER_READED);=0A=
+		arcmsr_clear_iop2drv_rqueue_buffer(acb);=0A=
+		spin_lock_irqsave(&acb->rqbuffer_lock, flags);=0A=
+		acb->acb_flags |=3D ACB_F_MESSAGE_RQBUFFER_CLEARED;=0A=
 		acb->rqbuf_firstindex =3D 0;=0A=
 		acb->rqbuf_lastindex =3D 0;=0A=
-		acb->wqbuf_firstindex =3D 0;=0A=
-		acb->wqbuf_lastindex =3D 0;=0A=
 		pQbuffer =3D acb->rqbuffer;=0A=
 		memset(pQbuffer, 0, sizeof(struct QBUFFER));=0A=
+		spin_unlock_irqrestore(&acb->rqbuffer_lock, flags);=0A=
+		spin_lock_irqsave(&acb->wqbuffer_lock, flags);=0A=
+		acb->acb_flags |=3D (ACB_F_MESSAGE_WQBUFFER_CLEARED |=0A=
+		ACB_F_MESSAGE_WQBUFFER_READED);=0A=
+		acb->wqbuf_firstindex =3D 0;=0A=
+		acb->wqbuf_lastindex =3D 0;=0A=
 		pQbuffer =3D acb->wqbuffer;=0A=
 		memset(pQbuffer, 0, sizeof(struct QBUFFER));=0A=
-		if(acb->fw_flag =3D=3D FW_DEADLOCK) {=0A=
+		spin_unlock_irqrestore(&acb->wqbuffer_lock, flags);=0A=
+		if (acb->fw_flag =3D=3D FW_DEADLOCK) {=0A=
 			pcmdmessagefld->cmdmessage.ReturnCode =3D=0A=
 			ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;=0A=
-		}else{=0A=
+		} else {=0A=
 			pcmdmessagefld->cmdmessage.ReturnCode =3D=0A=
 			ARCMSR_MESSAGE_RETURNCODE_OK;=0A=
 		}=0A=
-		}=0A=
 		break;=0A=
-=0A=
+	}=0A=
 	case ARCMSR_MESSAGE_RETURN_CODE_3F: {=0A=
-		if(acb->fw_flag =3D=3D FW_DEADLOCK) {=0A=
+		if (acb->fw_flag =3D=3D FW_DEADLOCK) {=0A=
 			pcmdmessagefld->cmdmessage.ReturnCode =3D=0A=
 			ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;=0A=
-		}else{=0A=
+		} else {=0A=
 			pcmdmessagefld->cmdmessage.ReturnCode =3D=0A=
 			ARCMSR_MESSAGE_RETURNCODE_3F;=0A=
 		}=0A=
 		break;=0A=
-		}=0A=
+	}=0A=
 	case ARCMSR_MESSAGE_SAY_HELLO: {=0A=
 		int8_t *hello_string =3D "Hello! I am ARCMSR";=0A=
-		if(acb->fw_flag =3D=3D FW_DEADLOCK) {=0A=
+		if (acb->fw_flag =3D=3D FW_DEADLOCK) {=0A=
 			pcmdmessagefld->cmdmessage.ReturnCode =3D=0A=
 			ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;=0A=
-		}else{=0A=
+		} else {=0A=
 			pcmdmessagefld->cmdmessage.ReturnCode =3D=0A=
 			ARCMSR_MESSAGE_RETURNCODE_OK;=0A=
 		}=0A=
-		memcpy(pcmdmessagefld->messagedatabuffer, hello_string=0A=
-			, (int16_t)strlen(hello_string));=0A=
-		}=0A=
+		memcpy((void *)pcmdmessagefld->messagedatabuffer,=0A=
+		(const void *)hello_string, (int16_t)strlen(hello_string));=0A=
 		break;=0A=
-=0A=
-	case ARCMSR_MESSAGE_SAY_GOODBYE:=0A=
-		if(acb->fw_flag =3D=3D FW_DEADLOCK) {=0A=
+	}=0A=
+	case ARCMSR_MESSAGE_SAY_GOODBYE: {=0A=
+		if (acb->fw_flag =3D=3D FW_DEADLOCK) {=0A=
 			pcmdmessagefld->cmdmessage.ReturnCode =3D=0A=
 			ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;=0A=
+		} else {=0A=
+			pcmdmessagefld->cmdmessage.ReturnCode =3D=0A=
+			ARCMSR_MESSAGE_RETURNCODE_OK;=0A=
 		}=0A=
 		arcmsr_iop_parking(acb);=0A=
 		break;=0A=
-=0A=
-	case ARCMSR_MESSAGE_FLUSH_ADAPTER_CACHE:=0A=
-		if(acb->fw_flag =3D=3D FW_DEADLOCK) {=0A=
+	}=0A=
+	case ARCMSR_MESSAGE_FLUSH_ADAPTER_CACHE: {=0A=
+		if (acb->fw_flag =3D=3D FW_DEADLOCK) {=0A=
 			pcmdmessagefld->cmdmessage.ReturnCode =3D=0A=
 			ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;=0A=
+		} else {=0A=
+			pcmdmessagefld->cmdmessage.ReturnCode =3D=0A=
+			ARCMSR_MESSAGE_RETURNCODE_OK;=0A=
 		}=0A=
 		arcmsr_flush_adapter_cache(acb);=0A=
 		break;=0A=
-=0A=
+	}=0A=
 	default:=0A=
 		retvalue =3D ARCMSR_MESSAGE_FAIL;=0A=
+		pr_info("%s: unknown controlcode!\n", __func__);=0A=
 	}=0A=
 	message_out:=0A=
-	sg =3D scsi_sglist(cmd);=0A=
-	kunmap_atomic(buffer - sg->offset);=0A=
+	if (use_sg) {=0A=
+		struct scatterlist *sg;=0A=
+		sg =3D scsi_sglist(cmd);=0A=
+		kunmap_atomic(buffer - sg->offset);=0A=
+	}=0A=
 	return retvalue;=0A=
 }=0A=
 =0A=
-static struct CommandControlBlock *arcmsr_get_freeccb(struct =
AdapterControlBlock *acb)=0A=
+struct CommandControlBlock=0A=
+*arcmsr_get_freeccb(struct AdapterControlBlock *acb)=0A=
 {=0A=
 	struct list_head *head =3D &acb->ccb_free_list;=0A=
 	struct CommandControlBlock *ccb =3D NULL;=0A=
 	unsigned long flags;=0A=
 	spin_lock_irqsave(&acb->ccblist_lock, flags);=0A=
 	if (!list_empty(head)) {=0A=
-		ccb =3D list_entry(head->next, struct CommandControlBlock, list);=0A=
+		ccb =3D list_entry(head->next,=0A=
+			struct CommandControlBlock, list);=0A=
 		list_del_init(&ccb->list);=0A=
-	}else{=0A=
+	} else {=0A=
 		spin_unlock_irqrestore(&acb->ccblist_lock, flags);=0A=
 		return 0;=0A=
 	}=0A=
@@ -2005,7 +2919,8 @@ static struct CommandControlBlock *arcms=0A=
 	return ccb;=0A=
 }=0A=
 =0A=
-static void arcmsr_handle_virtual_command(struct AdapterControlBlock =
*acb,=0A=
+void=0A=
+arcmsr_handle_virtual_command(struct AdapterControlBlock *acb,=0A=
 		struct scsi_cmnd *cmd)=0A=
 {=0A=
 	switch (cmd->cmnd[0]) {=0A=
@@ -2013,7 +2928,6 @@ static void arcmsr_handle_virtual_comman=0A=
 		unsigned char inqdata[36];=0A=
 		char *buffer;=0A=
 		struct scatterlist *sg;=0A=
-=0A=
 		if (cmd->device->lun) {=0A=
 			cmd->result =3D (DID_TIME_OUT << 16);=0A=
 			cmd->scsi_done(cmd);=0A=
@@ -2032,14 +2946,11 @@ static void arcmsr_handle_virtual_comman=0A=
 		strncpy(&inqdata[16], "RAID controller ", 16);=0A=
 		/* Product Identification */=0A=
 		strncpy(&inqdata[32], "R001", 4); /* Product Revision */=0A=
-=0A=
 		sg =3D scsi_sglist(cmd);=0A=
 		buffer =3D kmap_atomic(sg_page(sg)) + sg->offset;=0A=
-=0A=
-		memcpy(buffer, inqdata, sizeof(inqdata));=0A=
+		memcpy((void *)buffer, (const void *)inqdata, sizeof(inqdata));=0A=
 		sg =3D scsi_sglist(cmd);=0A=
 		kunmap_atomic(buffer - sg->offset);=0A=
-=0A=
 		cmd->scsi_done(cmd);=0A=
 	}=0A=
 	break;=0A=
@@ -2055,11 +2966,13 @@ static void arcmsr_handle_virtual_comman=0A=
 	}=0A=
 }=0A=
 =0A=
-static int arcmsr_queue_command_lck(struct scsi_cmnd *cmd,=0A=
+static int=0A=
+arcmsr_queue_command_lck(struct scsi_cmnd *cmd,=0A=
 	void (* done)(struct scsi_cmnd *))=0A=
 {=0A=
 	struct Scsi_Host *host =3D cmd->device->host;=0A=
-	struct AdapterControlBlock *acb =3D (struct AdapterControlBlock *) =
host->hostdata;=0A=
+	struct AdapterControlBlock *acb =3D=0A=
+	(struct AdapterControlBlock *)host->hostdata;=0A=
 	struct CommandControlBlock *ccb;=0A=
 	int target =3D cmd->device->id;=0A=
 	int lun =3D cmd->device->lun;=0A=
@@ -2067,10 +2980,10 @@ static int arcmsr_queue_command_lck(stru=0A=
 	cmd->scsi_done =3D done;=0A=
 	cmd->host_scribble =3D NULL;=0A=
 	cmd->result =3D 0;=0A=
-	if ((scsicmd =3D=3D SYNCHRONIZE_CACHE) ||(scsicmd =3D=3D =
SEND_DIAGNOSTIC)){=0A=
-		if(acb->devstate[target][lun] =3D=3D ARECA_RAID_GONE) {=0A=
-    			cmd->result =3D (DID_NO_CONNECT << 16);=0A=
-		}=0A=
+	if ((scsicmd =3D=3D SYNCHRONIZE_CACHE) ||=0A=
+		(scsicmd =3D=3D SEND_DIAGNOSTIC)) {=0A=
+		if (acb->devstate[target][lun] =3D=3D ARECA_RAID_GONE)=0A=
+			cmd->result =3D (DID_NO_CONNECT << 16);=0A=
 		cmd->scsi_done(cmd);=0A=
 		return 0;=0A=
 	}=0A=
@@ -2080,13 +2993,14 @@ static int arcmsr_queue_command_lck(stru=0A=
 		return 0;=0A=
 	}=0A=
 	if (atomic_read(&acb->ccboutstandingcount) >=3D=0A=
-			ARCMSR_MAX_OUTSTANDING_CMD)=0A=
+	acb->maxOutstanding)=0A=
 		return SCSI_MLQUEUE_HOST_BUSY;=0A=
 	ccb =3D arcmsr_get_freeccb(acb);=0A=
 	if (!ccb)=0A=
 		return SCSI_MLQUEUE_HOST_BUSY;=0A=
 	if (arcmsr_build_ccb( acb, ccb, cmd ) =3D=3D FAILED) {=0A=
-		cmd->result =3D (DID_ERROR << 16) | (RESERVATION_CONFLICT << 1);=0A=
+		cmd->result =3D (DID_ERROR << 16) |=0A=
+			(RESERVATION_CONFLICT << 1);=0A=
 		cmd->scsi_done(cmd);=0A=
 		return 0;=0A=
 	}=0A=
@@ -2096,24 +3010,30 @@ static int arcmsr_queue_command_lck(stru=0A=
 =0A=
 static DEF_SCSI_QCMD(arcmsr_queue_command)=0A=
 =0A=
-static bool arcmsr_get_hba_config(struct AdapterControlBlock *acb)=0A=
+static bool=0A=
+arcmsr_hbaA_get_config(struct AdapterControlBlock *acb)=0A=
 {=0A=
 	struct MessageUnit_A __iomem *reg =3D acb->pmuA;=0A=
 	char *acb_firm_model =3D acb->firm_model;=0A=
 	char *acb_firm_version =3D acb->firm_version;=0A=
 	char *acb_device_map =3D acb->device_map;=0A=
-	char __iomem *iop_firm_model =3D (char __iomem =
*)(&reg->message_rwbuffer[15]);=0A=
-	char __iomem *iop_firm_version =3D (char __iomem =
*)(&reg->message_rwbuffer[17]);=0A=
-	char __iomem *iop_device_map =3D (char __iomem =
*)(&reg->message_rwbuffer[21]);=0A=
+	char __iomem *iop_firm_model =3D=0A=
+		(char __iomem *)(&reg->message_rwbuffer[15]);=0A=
+	char __iomem *iop_firm_version =3D=0A=
+		(char __iomem *)(&reg->message_rwbuffer[17]);=0A=
+	char __iomem *iop_device_map =3D=0A=
+		(char __iomem *)(&reg->message_rwbuffer[21]);=0A=
 	int count;=0A=
-	writel(ARCMSR_INBOUND_MESG0_GET_CONFIG, &reg->inbound_msgaddr0);=0A=
-	if (!arcmsr_hba_wait_msgint_ready(acb)) {=0A=
-		printk(KERN_NOTICE "arcmsr%d: wait 'get adapter firmware \=0A=
-			miscellaneous data' timeout \n", acb->host->host_no);=0A=
+	writel(ARCMSR_INBOUND_MESG0_GET_CONFIG,=0A=
+		&reg->inbound_msgaddr0);=0A=
+	if (!arcmsr_hbaA_wait_msgint_ready(acb)) {=0A=
+		pr_notice("arcmsr%d: wait 'get adapter firmware "=0A=
+		"miscellaneous data' timeout\n",=0A=
+		acb->host->host_no);=0A=
 		return false;=0A=
 	}=0A=
 	count =3D 8;=0A=
-	while (count){=0A=
+	while (count) {=0A=
 		*acb_firm_model =3D readb(iop_firm_model);=0A=
 		acb_firm_model++;=0A=
 		iop_firm_model++;=0A=
@@ -2121,7 +3041,7 @@ static bool arcmsr_get_hba_config(struct=0A=
 	}=0A=
 =0A=
 	count =3D 16;=0A=
-	while (count){=0A=
+	while (count) {=0A=
 		*acb_firm_version =3D readb(iop_firm_version);=0A=
 		acb_firm_version++;=0A=
 		iop_firm_version++;=0A=
@@ -2129,27 +3049,29 @@ static bool arcmsr_get_hba_config(struct=0A=
 	}=0A=
 =0A=
 	count=3D16;=0A=
-	while(count){=0A=
+	while (count) {=0A=
 		*acb_device_map =3D readb(iop_device_map);=0A=
 		acb_device_map++;=0A=
 		iop_device_map++;=0A=
 		count--;=0A=
 	}=0A=
-	printk(KERN_NOTICE "Areca RAID Controller%d: F/W %s & Model %s\n", =0A=
+	pr_notice("Areca RAID Controller%d: Model %s, F/W %s\n",=0A=
 		acb->host->host_no,=0A=
-		acb->firm_version,=0A=
-		acb->firm_model);=0A=
+		acb->firm_model,=0A=
+		acb->firm_version);=0A=
 	acb->signature =3D readl(&reg->message_rwbuffer[0]);=0A=
 	acb->firm_request_len =3D readl(&reg->message_rwbuffer[1]);=0A=
 	acb->firm_numbers_queue =3D readl(&reg->message_rwbuffer[2]);=0A=
 	acb->firm_sdram_size =3D readl(&reg->message_rwbuffer[3]);=0A=
 	acb->firm_hd_channels =3D readl(&reg->message_rwbuffer[4]);=0A=
-	acb->firm_cfg_version =3D readl(&reg->message_rwbuffer[25]);  =
/*firm_cfg_version,25,100-103*/=0A=
+	acb->firm_cfg_version =3D readl(&reg->message_rwbuffer[25]);=0A=
 	return true;=0A=
 }=0A=
-static bool arcmsr_get_hbb_config(struct AdapterControlBlock *acb)=0A=
+=0A=
+static bool=0A=
+arcmsr_hbaB_get_config(struct AdapterControlBlock *acb)=0A=
 {=0A=
-	struct MessageUnit_B *reg =3D acb->pmuB;=0A=
+	struct MessageUnit_B __iomem *reg =3D acb->pmuB;=0A=
 	struct pci_dev *pdev =3D acb->pdev;=0A=
 	void *dma_coherent;=0A=
 	dma_addr_t dma_coherent_handle;=0A=
@@ -2163,40 +3085,57 @@ static bool arcmsr_get_hbb_config(struct=0A=
 	char __iomem *iop_device_map;=0A=
 	/*firm_version,21,84-99*/=0A=
 	int count;=0A=
-	dma_coherent =3D dma_alloc_coherent(&pdev->dev, sizeof(struct =
MessageUnit_B), &dma_coherent_handle, GFP_KERNEL);=0A=
-	if (!dma_coherent){=0A=
-		printk(KERN_NOTICE "arcmsr%d: dma_alloc_coherent got error for hbb =
mu\n", acb->host->host_no);=0A=
+	dma_coherent =3D dma_alloc_coherent(&pdev->dev,=0A=
+		sizeof(struct MessageUnit_B), &dma_coherent_handle,=0A=
+		GFP_KERNEL);=0A=
+	if (!dma_coherent) {=0A=
+		pr_notice("arcmsr%d: dma_alloc_coherent "=0A=
+		"got error for hbb mu\n", acb->host->host_no);=0A=
 		return false;=0A=
 	}=0A=
-	acb->dma_coherent_handle_hbb_mu =3D dma_coherent_handle;=0A=
-	reg =3D (struct MessageUnit_B *)dma_coherent;=0A=
+	acb->dma_coherent_handle2 =3D dma_coherent_handle;=0A=
+	reg =3D (struct MessageUnit_B __iomem *)dma_coherent;=0A=
 	acb->pmuB =3D reg;=0A=
-	reg->drv2iop_doorbell=3D (uint32_t __iomem *)((unsigned =
long)acb->mem_base0 + ARCMSR_DRV2IOP_DOORBELL);=0A=
-	reg->drv2iop_doorbell_mask =3D (uint32_t __iomem *)((unsigned =
long)acb->mem_base0 + ARCMSR_DRV2IOP_DOORBELL_MASK);=0A=
-	reg->iop2drv_doorbell =3D (uint32_t __iomem *)((unsigned =
long)acb->mem_base0 + ARCMSR_IOP2DRV_DOORBELL);=0A=
-	reg->iop2drv_doorbell_mask =3D (uint32_t __iomem *)((unsigned =
long)acb->mem_base0 + ARCMSR_IOP2DRV_DOORBELL_MASK);=0A=
-	reg->message_wbuffer =3D (uint32_t __iomem *)((unsigned =
long)acb->mem_base1 + ARCMSR_MESSAGE_WBUFFER);=0A=
-	reg->message_rbuffer =3D  (uint32_t __iomem *)((unsigned =
long)acb->mem_base1 + ARCMSR_MESSAGE_RBUFFER);=0A=
-	reg->message_rwbuffer =3D (uint32_t __iomem *)((unsigned =
long)acb->mem_base1 + ARCMSR_MESSAGE_RWBUFFER);=0A=
-	iop_firm_model =3D (char __iomem *)(&reg->message_rwbuffer[15]);	=
/*firm_model,15,60-67*/=0A=
-	iop_firm_version =3D (char __iomem *)(&reg->message_rwbuffer[17]);	=
/*firm_version,17,68-83*/=0A=
-	iop_device_map =3D (char __iomem *)(&reg->message_rwbuffer[21]);	=
/*firm_version,21,84-99*/=0A=
+	reg->drv2iop_doorbell =3D (uint32_t __iomem *)=0A=
+		((unsigned long)acb->mem_base0 +=0A=
+		ARCMSR_DRV2IOP_DOORBELL);=0A=
+	reg->drv2iop_doorbell_mask =3D (uint32_t __iomem *)=0A=
+		((unsigned long)acb->mem_base0 +=0A=
+		ARCMSR_DRV2IOP_DOORBELL_MASK);=0A=
+	reg->iop2drv_doorbell =3D (uint32_t __iomem *)=0A=
+		((unsigned long)acb->mem_base0 +=0A=
+		ARCMSR_IOP2DRV_DOORBELL);=0A=
+	reg->iop2drv_doorbell_mask =3D (uint32_t __iomem *)=0A=
+		((unsigned long)acb->mem_base0 +=0A=
+		ARCMSR_IOP2DRV_DOORBELL_MASK);=0A=
+	reg->message_wbuffer =3D (uint32_t __iomem *)=0A=
+		((unsigned long)acb->mem_base1 +=0A=
+		ARCMSR_MESSAGE_WBUFFER);=0A=
+	reg->message_rbuffer =3D (uint32_t __iomem *)=0A=
+		((unsigned long)acb->mem_base1 +=0A=
+		ARCMSR_MESSAGE_RBUFFER);=0A=
+	reg->message_rwbuffer =3D (uint32_t __iomem *)=0A=
+		((unsigned long)acb->mem_base1 +=0A=
+		ARCMSR_MESSAGE_RWBUFFER);=0A=
+	iop_firm_model =3D (char __iomem *)(&reg->message_rwbuffer[15]);=0A=
+	iop_firm_version =3D (char __iomem *)(&reg->message_rwbuffer[17]);=0A=
+	iop_device_map =3D (char __iomem *)(&reg->message_rwbuffer[21]);=0A=
 =0A=
 	writel(ARCMSR_MESSAGE_GET_CONFIG, reg->drv2iop_doorbell);=0A=
-	if (!arcmsr_hbb_wait_msgint_ready(acb)) {=0A=
-		printk(KERN_NOTICE "arcmsr%d: wait 'get adapter firmware \=0A=
-			miscellaneous data' timeout \n", acb->host->host_no);=0A=
+	if (!arcmsr_hbaB_wait_msgint_ready(acb)) {=0A=
+		pr_notice("arcmsr%d: wait 'get adapter firmware "=0A=
+		"miscellaneous data' timeout\n", acb->host->host_no);=0A=
 		return false;=0A=
 	}=0A=
 	count =3D 8;=0A=
-	while (count){=0A=
+	while (count) {=0A=
 		*acb_firm_model =3D readb(iop_firm_model);=0A=
 		acb_firm_model++;=0A=
 		iop_firm_model++;=0A=
 		count--;=0A=
 	}=0A=
 	count =3D 16;=0A=
-	while (count){=0A=
+	while (count) {=0A=
 		*acb_firm_version =3D readb(iop_firm_version);=0A=
 		acb_firm_version++;=0A=
 		iop_firm_version++;=0A=
@@ -2204,17 +3143,17 @@ static bool arcmsr_get_hbb_config(struct=0A=
 	}=0A=
 =0A=
 	count =3D 16;=0A=
-	while(count){=0A=
+	while (count) {=0A=
 		*acb_device_map =3D readb(iop_device_map);=0A=
 		acb_device_map++;=0A=
 		iop_device_map++;=0A=
 		count--;=0A=
 	}=0A=
-	=0A=
-	printk(KERN_NOTICE "Areca RAID Controller%d: F/W %s & Model %s\n",=0A=
+=0A=
+	pr_notice("Areca RAID Controller%d: Model %s, F/W %s\n",=0A=
 		acb->host->host_no,=0A=
-		acb->firm_version,=0A=
-		acb->firm_model);=0A=
+		acb->firm_model,=0A=
+		acb->firm_version);=0A=
 =0A=
 	acb->signature =3D readl(&reg->message_rwbuffer[1]);=0A=
 	/*firm_signature,1,00-03*/=0A=
@@ -2226,41 +3165,169 @@ static bool arcmsr_get_hbb_config(struct=0A=
 	/*firm_sdram_size,3,12-15*/=0A=
 	acb->firm_hd_channels =3D readl(&reg->message_rwbuffer[5]);=0A=
 	/*firm_ide_channels,4,16-19*/=0A=
-	acb->firm_cfg_version =3D readl(&reg->message_rwbuffer[25]);  =
/*firm_cfg_version,25,100-103*/=0A=
+	acb->firm_cfg_version =3D readl(&reg->message_rwbuffer[25]);=0A=
 	/*firm_ide_channels,4,16-19*/=0A=
 	return true;=0A=
 }=0A=
 =0A=
-static bool arcmsr_get_hbc_config(struct AdapterControlBlock *pACB)=0A=
-{=0A=
-	uint32_t intmask_org, Index, firmware_state =3D 0;=0A=
-	struct MessageUnit_C *reg =3D pACB->pmuC;=0A=
-	char *acb_firm_model =3D pACB->firm_model;=0A=
-	char *acb_firm_version =3D pACB->firm_version;=0A=
-	char *iop_firm_model =3D (char *)(&reg->msgcode_rwbuffer[15]);    =
/*firm_model,15,60-67*/=0A=
-	char *iop_firm_version =3D (char *)(&reg->msgcode_rwbuffer[17]);  =
/*firm_version,17,68-83*/=0A=
-	int count;=0A=
-	/* disable all outbound interrupt */=0A=
-	intmask_org =3D readl(&reg->host_int_mask); /* disable outbound =
message0 int */=0A=
-	writel(intmask_org|ARCMSR_HBCMU_ALL_INTMASKENABLE, =
&reg->host_int_mask);=0A=
-	/* wait firmware ready */=0A=
-	do {=0A=
-		firmware_state =3D readl(&reg->outbound_msgaddr1);=0A=
-	} while ((firmware_state & ARCMSR_HBCMU_MESSAGE_FIRMWARE_OK) =3D=3D 0);=0A=
+static bool=0A=
+arcmsr_hbaC_get_config(struct AdapterControlBlock *pACB)=0A=
+{=0A=
+	uint32_t intmask_org, Index, firmware_state =3D 0;=0A=
+	struct MessageUnit_C __iomem *reg =3D pACB->pmuC;=0A=
+	char *acb_firm_model =3D pACB->firm_model;=0A=
+	char *acb_firm_version =3D pACB->firm_version;=0A=
+	char *iop_firm_model =3D (char *)(&reg->msgcode_rwbuffer[15]);=0A=
+	char *iop_firm_version =3D (char *)(&reg->msgcode_rwbuffer[17]);=0A=
+	int count;=0A=
+	/* disable all outbound interrupt */=0A=
+	intmask_org =3D readl(&reg->host_int_mask);=0A=
+	writel(intmask_org | ARCMSR_HBCMU_ALL_INTMASKENABLE,=0A=
+		&reg->host_int_mask);=0A=
+	do {=0A=
+		firmware_state =3D readl(&reg->outbound_msgaddr1);=0A=
+	} while ((firmware_state & ARCMSR_HBCMU_MESSAGE_FIRMWARE_OK) =3D=3D 0);=0A=
+	/* post "get config" instruction */=0A=
+	writel(ARCMSR_INBOUND_MESG0_GET_CONFIG, &reg->inbound_msgaddr0);=0A=
+	writel(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE,=0A=
+		&reg->inbound_doorbell);=0A=
+	/* wait message ready */=0A=
+	for (Index =3D 0; Index < 2000; Index++) {=0A=
+		if (readl(&reg->outbound_doorbell) &=0A=
+		ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE) {=0A=
+			writel(ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE_DOORBELL_CLEAR,=0A=
+				&reg->outbound_doorbell_clear);=0A=
+			break;=0A=
+		}=0A=
+		udelay(10);=0A=
+	} /*max 1 seconds*/=0A=
+	if (Index >=3D 2000) {=0A=
+		pr_notice("arcmsr%d: wait 'get adapter firmware "=0A=
+		"miscellaneous data' timeout\n", pACB->host->host_no);=0A=
+		return false;=0A=
+	}=0A=
+	count =3D 8;=0A=
+	while (count) {=0A=
+		*acb_firm_model =3D readb(iop_firm_model);=0A=
+		acb_firm_model++;=0A=
+		iop_firm_model++;=0A=
+		count--;=0A=
+	}=0A=
+	count =3D 16;=0A=
+	while (count) {=0A=
+		*acb_firm_version =3D readb(iop_firm_version);=0A=
+		acb_firm_version++;=0A=
+		iop_firm_version++;=0A=
+		count--;=0A=
+	}=0A=
+	pr_notice("Areca RAID Controller%d: Model %s, F/W %s\n",=0A=
+		pACB->host->host_no,=0A=
+		pACB->firm_model,=0A=
+		pACB->firm_version);=0A=
+	pACB->firm_request_len =3D readl(&reg->msgcode_rwbuffer[1]);=0A=
+	pACB->firm_numbers_queue =3D readl(&reg->msgcode_rwbuffer[2]);=0A=
+	pACB->firm_sdram_size =3D readl(&reg->msgcode_rwbuffer[3]);=0A=
+	pACB->firm_hd_channels =3D readl(&reg->msgcode_rwbuffer[4]);=0A=
+	pACB->firm_cfg_version =3D readl(&reg->msgcode_rwbuffer[25]);=0A=
+	/*all interrupt service will be enable at arcmsr_iop_init*/=0A=
+	return true;=0A=
+}=0A=
+=0A=
+static bool=0A=
+arcmsr_hbaD_get_config(struct AdapterControlBlock *acb)=0A=
+{=0A=
+	char *acb_firm_model =3D acb->firm_model;=0A=
+	char *acb_firm_version =3D acb->firm_version;=0A=
+	char *acb_device_map =3D acb->device_map;=0A=
+	char __iomem *iop_firm_model;=0A=
+	char __iomem *iop_firm_version;=0A=
+	char __iomem *iop_device_map;=0A=
+	u32 count;=0A=
+	struct MessageUnit_D __iomem *reg ;=0A=
+	void *dma_coherent;=0A=
+	dma_addr_t dma_coherent_handle;=0A=
+	struct pci_dev *pdev =3D acb->pdev;=0A=
+=0A=
+	acb->roundup_ccbsize =3D roundup(sizeof(struct MessageUnit_D), 32);=0A=
+	dma_coherent =3D dma_alloc_coherent(&pdev->dev, acb->roundup_ccbsize,=0A=
+	&dma_coherent_handle, GFP_KERNEL);=0A=
+	if (!dma_coherent) {=0A=
+		pr_notice("DMA allocation failed...\n");=0A=
+		return false;=0A=
+	}=0A=
+	memset(dma_coherent, 0, acb->roundup_ccbsize);=0A=
+	acb->dma_coherent2 =3D dma_coherent;=0A=
+	acb->dma_coherent_handle2 =3D dma_coherent_handle;=0A=
+	reg =3D (struct MessageUnit_D __iomem *)dma_coherent;=0A=
+	acb->pmuD =3D reg;=0A=
+	reg->chip_id =3D (u32 __iomem *)((unsigned long)=0A=
+	acb->mem_base0 + ARCMSR_ARC1214_CHIP_ID);=0A=
+	reg->cpu_mem_config =3D (u32 __iomem *)((unsigned long)=0A=
+	acb->mem_base0 + ARCMSR_ARC1214_CPU_MEMORY_CONFIGURATION);=0A=
+	reg->i2o_host_interrupt_mask =3D (u32 __iomem *)((unsigned long)=0A=
+	acb->mem_base0 + ARCMSR_ARC1214_I2_HOST_INTERRUPT_MASK);=0A=
+	reg->sample_at_reset =3D (u32 __iomem *)((unsigned long)=0A=
+	acb->mem_base0 + ARCMSR_ARC1214_SAMPLE_RESET);=0A=
+	reg->reset_request =3D (u32 __iomem *)((unsigned long)=0A=
+	acb->mem_base0 + ARCMSR_ARC1214_RESET_REQUEST);=0A=
+	reg->host_int_status =3D (u32 __iomem *)((unsigned long)=0A=
+	acb->mem_base0 + ARCMSR_ARC1214_MAIN_INTERRUPT_STATUS);=0A=
+	reg->pcief0_int_enable =3D (u32 __iomem *)((unsigned long)=0A=
+	acb->mem_base0 + ARCMSR_ARC1214_PCIE_F0_INTERRUPT_ENABLE);=0A=
+	reg->inbound_msgaddr0 =3D (u32 __iomem *)((unsigned long)=0A=
+	acb->mem_base0 + ARCMSR_ARC1214_INBOUND_MESSAGE0);=0A=
+	reg->inbound_msgaddr1 =3D (u32 __iomem *)((unsigned long)=0A=
+	acb->mem_base0 + ARCMSR_ARC1214_INBOUND_MESSAGE1);=0A=
+	reg->outbound_msgaddr0 =3D (u32 __iomem *)((unsigned long)=0A=
+	acb->mem_base0 + ARCMSR_ARC1214_OUTBOUND_MESSAGE0);=0A=
+	reg->outbound_msgaddr1 =3D (u32 __iomem *)((unsigned long)=0A=
+	acb->mem_base0 + ARCMSR_ARC1214_OUTBOUND_MESSAGE1);=0A=
+	reg->inbound_doorbell =3D (u32 __iomem *)((unsigned long)=0A=
+	acb->mem_base0 + ARCMSR_ARC1214_INBOUND_DOORBELL);=0A=
+	reg->outbound_doorbell =3D (u32 __iomem *)((unsigned long)=0A=
+	acb->mem_base0 + ARCMSR_ARC1214_OUTBOUND_DOORBELL);=0A=
+	reg->outbound_doorbell_enable =3D (u32 __iomem *)((unsigned long)=0A=
+	acb->mem_base0 + ARCMSR_ARC1214_OUTBOUND_DOORBELL_ENABLE);=0A=
+	reg->inboundlist_base_low =3D (u32 __iomem *)((unsigned long)=0A=
+	acb->mem_base0 + ARCMSR_ARC1214_INBOUND_LIST_BASE_LOW);=0A=
+	reg->inboundlist_base_high =3D (u32 __iomem *)((unsigned long)=0A=
+	acb->mem_base0 + ARCMSR_ARC1214_INBOUND_LIST_BASE_HIGH);=0A=
+	reg->inboundlist_write_pointer =3D (u32 __iomem *)((unsigned long)=0A=
+	acb->mem_base0 + ARCMSR_ARC1214_INBOUND_LIST_WRITE_POINTER);=0A=
+	reg->outboundlist_base_low =3D (u32 __iomem *)((unsigned long)=0A=
+	acb->mem_base0 + ARCMSR_ARC1214_OUTBOUND_LIST_BASE_LOW);=0A=
+	reg->outboundlist_base_high =3D (u32 __iomem *)((unsigned long)=0A=
+	acb->mem_base0 + ARCMSR_ARC1214_OUTBOUND_LIST_BASE_HIGH);=0A=
+	reg->outboundlist_copy_pointer =3D (u32 __iomem *)((unsigned long)=0A=
+	acb->mem_base0 + ARCMSR_ARC1214_OUTBOUND_LIST_COPY_POINTER);=0A=
+	reg->outboundlist_read_pointer =3D (u32 __iomem *)((unsigned long)=0A=
+	acb->mem_base0 + ARCMSR_ARC1214_OUTBOUND_LIST_READ_POINTER);=0A=
+	reg->outboundlist_interrupt_cause =3D (u32 __iomem *)((unsigned long)=0A=
+	acb->mem_base0 + ARCMSR_ARC1214_OUTBOUND_INTERRUPT_CAUSE);=0A=
+	reg->outboundlist_interrupt_enable =3D (u32 __iomem *)((unsigned long)=0A=
+	acb->mem_base0 + ARCMSR_ARC1214_OUTBOUND_INTERRUPT_ENABLE);=0A=
+	reg->message_wbuffer =3D (u32 __iomem *)((unsigned long)=0A=
+	acb->mem_base0 + ARCMSR_ARC1214_MESSAGE_WBUFFER);=0A=
+	reg->message_rbuffer =3D (u32 __iomem *)((unsigned long)=0A=
+	acb->mem_base0 + ARCMSR_ARC1214_MESSAGE_RBUFFER);=0A=
+	reg->msgcode_rwbuffer =3D (u32 __iomem *)((unsigned long)=0A=
+	acb->mem_base0 + ARCMSR_ARC1214_MESSAGE_RWBUFFER);=0A=
+	iop_firm_model =3D (char __iomem *)(&reg->msgcode_rwbuffer[15]);=0A=
+	iop_firm_version =3D (char __iomem *)(&reg->msgcode_rwbuffer[17]);=0A=
+	iop_device_map =3D (char __iomem *)(&reg->msgcode_rwbuffer[21]);=0A=
+	if (readl(acb->pmuD->outbound_doorbell) &=0A=
+	ARCMSR_ARC1214_IOP2DRV_MESSAGE_CMD_DONE) {=0A=
+		writel(ARCMSR_ARC1214_IOP2DRV_MESSAGE_CMD_DONE,=0A=
+			acb->pmuD->outbound_doorbell);/*clear interrupt*/=0A=
+	}=0A=
 	/* post "get config" instruction */=0A=
-	writel(ARCMSR_INBOUND_MESG0_GET_CONFIG, &reg->inbound_msgaddr0);=0A=
-	writel(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE, &reg->inbound_doorbell);=0A=
+	writel(ARCMSR_INBOUND_MESG0_GET_CONFIG, reg->inbound_msgaddr0);=0A=
 	/* wait message ready */=0A=
-	for (Index =3D 0; Index < 2000; Index++) {=0A=
-		if (readl(&reg->outbound_doorbell) & =
ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE) {=0A=
-			writel(ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE_DOORBELL_CLEAR, =
&reg->outbound_doorbell_clear);/*clear interrupt*/=0A=
-			break;=0A=
-		}=0A=
-		udelay(10);=0A=
-	} /*max 1 seconds*/=0A=
-	if (Index >=3D 2000) {=0A=
-		printk(KERN_NOTICE "arcmsr%d: wait 'get adapter firmware \=0A=
-			miscellaneous data' timeout \n", pACB->host->host_no);=0A=
+	if (!arcmsr_hbaD_wait_msgint_ready(acb)) {=0A=
+		pr_notice("arcmsr%d: wait get adapter firmware "=0A=
+		"miscellaneous data timeout\n", acb->host->host_no);=0A=
+		dma_free_coherent(&acb->pdev->dev, acb->roundup_ccbsize,=0A=
+			acb->dma_coherent2, acb->dma_coherent_handle2);=0A=
 		return false;=0A=
 	}=0A=
 	count =3D 8;=0A=
@@ -2277,88 +3344,128 @@ static bool arcmsr_get_hbc_config(struct=0A=
 		iop_firm_version++;=0A=
 		count--;=0A=
 	}=0A=
-	printk(KERN_NOTICE "Areca RAID Controller%d: F/W %s & Model %s\n",=0A=
-		pACB->host->host_no,=0A=
-		pACB->firm_version,=0A=
-		pACB->firm_model);=0A=
-	pACB->firm_request_len =3D readl(&reg->msgcode_rwbuffer[1]);   =
/*firm_request_len,1,04-07*/=0A=
-	pACB->firm_numbers_queue =3D readl(&reg->msgcode_rwbuffer[2]); =
/*firm_numbers_queue,2,08-11*/=0A=
-	pACB->firm_sdram_size =3D readl(&reg->msgcode_rwbuffer[3]);    =
/*firm_sdram_size,3,12-15*/=0A=
-	pACB->firm_hd_channels =3D readl(&reg->msgcode_rwbuffer[4]);  =
/*firm_ide_channels,4,16-19*/=0A=
-	pACB->firm_cfg_version =3D readl(&reg->msgcode_rwbuffer[25]);  =
/*firm_cfg_version,25,100-103*/=0A=
-	/*all interrupt service will be enable at arcmsr_iop_init*/=0A=
+	count =3D 16;=0A=
+	while (count) {=0A=
+		*acb_device_map =3D readb(iop_device_map);=0A=
+		acb_device_map++;=0A=
+		iop_device_map++;=0A=
+		count--;=0A=
+	}=0A=
+	acb->signature =3D readl(&reg->msgcode_rwbuffer[1]);=0A=
+	/*firm_signature,1,00-03*/=0A=
+	acb->firm_request_len =3D readl(&reg->msgcode_rwbuffer[2]);=0A=
+	/*firm_request_len,1,04-07*/=0A=
+	acb->firm_numbers_queue =3D readl(&reg->msgcode_rwbuffer[3]);=0A=
+	/*firm_numbers_queue,2,08-11*/=0A=
+	acb->firm_sdram_size =3D readl(&reg->msgcode_rwbuffer[4]);=0A=
+	/*firm_sdram_size,3,12-15*/=0A=
+	acb->firm_hd_channels =3D readl(&reg->msgcode_rwbuffer[5]);=0A=
+	/*firm_hd_channels,4,16-19*/=0A=
+	acb->firm_cfg_version =3D readl(&reg->msgcode_rwbuffer[25]);=0A=
+	pr_notice("Areca RAID Controller%d: Model %s, F/W %s\n",=0A=
+		acb->host->host_no,=0A=
+		acb->firm_model,=0A=
+		acb->firm_version);=0A=
 	return true;=0A=
 }=0A=
-static bool arcmsr_get_firmware_spec(struct AdapterControlBlock *acb)=0A=
+=0A=
+static bool=0A=
+arcmsr_get_firmware_spec(struct AdapterControlBlock *acb)=0A=
 {=0A=
-	if (acb->adapter_type =3D=3D ACB_ADAPTER_TYPE_A)=0A=
-		return arcmsr_get_hba_config(acb);=0A=
-	else if (acb->adapter_type =3D=3D ACB_ADAPTER_TYPE_B)=0A=
-		return arcmsr_get_hbb_config(acb);=0A=
+	bool rtn =3D false;=0A=
+	switch (acb->adapter_type) {=0A=
+	case ACB_ADAPTER_TYPE_A:=0A=
+		rtn =3D arcmsr_hbaA_get_config(acb);=0A=
+		break;=0A=
+	case ACB_ADAPTER_TYPE_B:=0A=
+		rtn =3D arcmsr_hbaB_get_config(acb);=0A=
+		break;=0A=
+	case ACB_ADAPTER_TYPE_C:=0A=
+		rtn =3D arcmsr_hbaC_get_config(acb);=0A=
+		break;=0A=
+	case ACB_ADAPTER_TYPE_D:=0A=
+		rtn =3D arcmsr_hbaD_get_config(acb);=0A=
+		break;=0A=
+	default:=0A=
+		break;=0A=
+	}=0A=
+	if(acb->firm_numbers_queue > ARCMSR_MAX_FREECCB_NUM)=0A=
+		acb->maxOutstanding =3D ARCMSR_MAX_FREECCB_NUM-1;=0A=
 	else=0A=
-		return arcmsr_get_hbc_config(acb);=0A=
+		acb->maxOutstanding =3D acb->firm_numbers_queue - 1;=0A=
+	return rtn;=0A=
 }=0A=
 =0A=
-static int arcmsr_polling_hba_ccbdone(struct AdapterControlBlock *acb,=0A=
+static int=0A=
+arcmsr_hbaA_polling_ccbdone(struct AdapterControlBlock *acb,=0A=
 	struct CommandControlBlock *poll_ccb)=0A=
 {=0A=
 	struct MessageUnit_A __iomem *reg =3D acb->pmuA;=0A=
 	struct CommandControlBlock *ccb;=0A=
 	struct ARCMSR_CDB *arcmsr_cdb;=0A=
-	uint32_t flag_ccb, outbound_intstatus, poll_ccb_done =3D 0, poll_count =
=3D 0;=0A=
+	uint32_t flag_ccb, outbound_intstatus, poll_ccb_done =3D 0;=0A=
+	uint32_t poll_count =3D 0;=0A=
 	int rtn;=0A=
 	bool error;=0A=
 	polling_hba_ccb_retry:=0A=
 	poll_count++;=0A=
-	outbound_intstatus =3D readl(&reg->outbound_intstatus) & =
acb->outbound_int_enable;=0A=
-	writel(outbound_intstatus, &reg->outbound_intstatus);/*clear =
interrupt*/=0A=
+	outbound_intstatus =3D readl(&reg->outbound_intstatus) &=0A=
+		acb->outbound_int_enable;=0A=
+	writel(outbound_intstatus, &reg->outbound_intstatus);=0A=
 	while (1) {=0A=
-		if ((flag_ccb =3D readl(&reg->outbound_queueport)) =3D=3D 0xFFFFFFFF) =
{=0A=
-			if (poll_ccb_done){=0A=
+		flag_ccb =3D readl(&reg->outbound_queueport);=0A=
+		if (flag_ccb =3D=3D 0xFFFFFFFF) {=0A=
+			if (poll_ccb_done) {=0A=
 				rtn =3D SUCCESS;=0A=
 				break;=0A=
-			}else {=0A=
+			} else {=0A=
 				msleep(25);=0A=
-				if (poll_count > 100){=0A=
+				if (poll_count > 100) {=0A=
 					rtn =3D FAILED;=0A=
 					break;=0A=
 				}=0A=
 				goto polling_hba_ccb_retry;=0A=
 			}=0A=
 		}=0A=
-		arcmsr_cdb =3D (struct ARCMSR_CDB *)(acb->vir2phy_offset + (flag_ccb =
<< 5));=0A=
-		ccb =3D container_of(arcmsr_cdb, struct CommandControlBlock, =
arcmsr_cdb);=0A=
+		arcmsr_cdb =3D (struct ARCMSR_CDB *)(acb->vir2phy_offset +=0A=
+			(flag_ccb << 5));=0A=
+		ccb =3D container_of(arcmsr_cdb, struct CommandControlBlock,=0A=
+			arcmsr_cdb);=0A=
 		poll_ccb_done =3D (ccb =3D=3D poll_ccb) ? 1:0;=0A=
 		if ((ccb->acb !=3D acb) || (ccb->startdone !=3D ARCMSR_CCB_START)) {=0A=
-			if ((ccb->startdone =3D=3D ARCMSR_CCB_ABORTED) || (ccb =3D=3D =
poll_ccb)) {=0A=
-				printk(KERN_NOTICE "arcmsr%d: scsi id =3D %d lun =3D %d ccb =3D =
'0x%p'"=0A=
-					" poll command abort successfully \n"=0A=
-					, acb->host->host_no=0A=
-					, ccb->pcmd->device->id=0A=
-					, ccb->pcmd->device->lun=0A=
-					, ccb);=0A=
+			if ((ccb->startdone =3D=3D ARCMSR_CCB_ABORTED) ||=0A=
+			(ccb =3D=3D poll_ccb)) {=0A=
+				pr_notice("arcmsr%d: scsi id =3D %d "=0A=
+				"lun =3D %d ccb =3D '0x%p' poll command "=0A=
+				"abort successfully\n"=0A=
+				, acb->host->host_no=0A=
+				, ccb->pcmd->device->id=0A=
+				, ccb->pcmd->device->lun=0A=
+				, ccb);=0A=
 				ccb->pcmd->result =3D DID_ABORT << 16;=0A=
 				arcmsr_ccb_complete(ccb);=0A=
 				continue;=0A=
 			}=0A=
-			printk(KERN_NOTICE "arcmsr%d: polling get an illegal ccb"=0A=
-				" command done ccb =3D '0x%p'"=0A=
-				"ccboutstandingcount =3D %d \n"=0A=
-				, acb->host->host_no=0A=
-				, ccb=0A=
-				, atomic_read(&acb->ccboutstandingcount));=0A=
+			pr_notice("arcmsr%d: polling get an illegal "=0A=
+			"ccb command done ccb =3D '0x%p' "=0A=
+			"ccboutstandingcount =3D %d\n"=0A=
+			, acb->host->host_no=0A=
+			, ccb=0A=
+			, atomic_read(&acb->ccboutstandingcount));=0A=
 			continue;=0A=
 		}=0A=
-		error =3D (flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR_MODE0) ? true : =
false;=0A=
+		error =3D (flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR_MODE0) ?=0A=
+			true : false;=0A=
 		arcmsr_report_ccb_state(acb, ccb, error);=0A=
 	}=0A=
 	return rtn;=0A=
 }=0A=
 =0A=
-static int arcmsr_polling_hbb_ccbdone(struct AdapterControlBlock *acb,=0A=
-					struct CommandControlBlock *poll_ccb)=0A=
+int=0A=
+arcmsr_hbaB_polling_ccbdone(struct AdapterControlBlock *acb,=0A=
+				struct CommandControlBlock *poll_ccb)=0A=
 {=0A=
-	struct MessageUnit_B *reg =3D acb->pmuB;=0A=
+	struct MessageUnit_B __iomem *reg =3D acb->pmuB;=0A=
 	struct ARCMSR_CDB *arcmsr_cdb;=0A=
 	struct CommandControlBlock *ccb;=0A=
 	uint32_t flag_ccb, poll_ccb_done =3D 0, poll_count =3D 0;=0A=
@@ -2368,16 +3475,18 @@ static int arcmsr_polling_hbb_ccbdone(st=0A=
 =0A=
 	poll_count++;=0A=
 	/* clear doorbell interrupt */=0A=
-	writel(ARCMSR_DOORBELL_INT_CLEAR_PATTERN, reg->iop2drv_doorbell);=0A=
-	while(1){=0A=
+	writel(ARCMSR_DOORBELL_INT_CLEAR_PATTERN,=0A=
+	reg->iop2drv_doorbell);=0A=
+	while (1) {=0A=
 		index =3D reg->doneq_index;=0A=
-		if ((flag_ccb =3D readl(&reg->done_qbuffer[index])) =3D=3D 0) {=0A=
-			if (poll_ccb_done){=0A=
+		flag_ccb =3D readl(&reg->done_qbuffer[index]);=0A=
+		if (flag_ccb =3D=3D 0) {=0A=
+			if (poll_ccb_done) {=0A=
 				rtn =3D SUCCESS;=0A=
 				break;=0A=
-			}else {=0A=
+			} else {=0A=
 				msleep(25);=0A=
-				if (poll_count > 100){=0A=
+				if (poll_count > 100) {=0A=
 					rtn =3D FAILED;=0A=
 					break;=0A=
 				}=0A=
@@ -2390,38 +3499,47 @@ static int arcmsr_polling_hbb_ccbdone(st=0A=
 		index %=3D ARCMSR_MAX_HBB_POSTQUEUE;=0A=
 		reg->doneq_index =3D index;=0A=
 		/* check if command done with no error*/=0A=
-		arcmsr_cdb =3D (struct ARCMSR_CDB *)(acb->vir2phy_offset + (flag_ccb =
<< 5));=0A=
-		ccb =3D container_of(arcmsr_cdb, struct CommandControlBlock, =
arcmsr_cdb);=0A=
-		poll_ccb_done =3D (ccb =3D=3D poll_ccb) ? 1:0;=0A=
-		if ((ccb->acb !=3D acb) || (ccb->startdone !=3D ARCMSR_CCB_START)) {=0A=
-			if ((ccb->startdone =3D=3D ARCMSR_CCB_ABORTED) || (ccb =3D=3D =
poll_ccb)) {=0A=
-				printk(KERN_NOTICE "arcmsr%d: scsi id =3D %d lun =3D %d ccb =3D =
'0x%p'"=0A=
-					" poll command abort successfully \n"=0A=
-					,acb->host->host_no=0A=
-					,ccb->pcmd->device->id=0A=
-					,ccb->pcmd->device->lun=0A=
-					,ccb);=0A=
+		arcmsr_cdb =3D (struct ARCMSR_CDB *)=0A=
+		(acb->vir2phy_offset + (flag_ccb << 5));=0A=
+		ccb =3D container_of(arcmsr_cdb,=0A=
+			struct CommandControlBlock,=0A=
+			arcmsr_cdb);=0A=
+		poll_ccb_done =3D (ccb =3D=3D poll_ccb) ? 1 : 0;=0A=
+		if ((ccb->acb !=3D acb) ||=0A=
+		(ccb->startdone !=3D ARCMSR_CCB_START)) {=0A=
+			if ((ccb->startdone =3D=3D ARCMSR_CCB_ABORTED) ||=0A=
+				(ccb =3D=3D poll_ccb)) {=0A=
+				pr_notice("arcmsr%d: "=0A=
+				"scsi id =3D %d lun =3D %d ccb =3D '0x%p' poll "=0A=
+				"command abort successfully\n"=0A=
+				, acb->host->host_no=0A=
+				, ccb->pcmd->device->id=0A=
+				, ccb->pcmd->device->lun=0A=
+				, ccb);=0A=
 				ccb->pcmd->result =3D DID_ABORT << 16;=0A=
 				arcmsr_ccb_complete(ccb);=0A=
 				continue;=0A=
 			}=0A=
-			printk(KERN_NOTICE "arcmsr%d: polling get an illegal ccb"=0A=
-				" command done ccb =3D '0x%p'"=0A=
-				"ccboutstandingcount =3D %d \n"=0A=
+			pr_notice("arcmsr%d: polling get an "=0A=
+				"illegal ccb command done ccb =3D '0x%p' "=0A=
+				"ccboutstandingcount =3D %d\n"=0A=
 				, acb->host->host_no=0A=
 				, ccb=0A=
 				, atomic_read(&acb->ccboutstandingcount));=0A=
 			continue;=0A=
 		} =0A=
-		error =3D (flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR_MODE0) ? true : =
false;=0A=
+		error =3D (flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR_MODE0)=0A=
+		? true : false;=0A=
 		arcmsr_report_ccb_state(acb, ccb, error);=0A=
 	}=0A=
 	return rtn;=0A=
 }=0A=
 =0A=
-static int arcmsr_polling_hbc_ccbdone(struct AdapterControlBlock *acb, =
struct CommandControlBlock *poll_ccb)=0A=
+static int=0A=
+arcmsr_hbaC_polling_ccbdone(struct AdapterControlBlock *acb,=0A=
+	struct CommandControlBlock *poll_ccb)=0A=
 {=0A=
-	struct MessageUnit_C *reg =3D (struct MessageUnit_C *)acb->pmuC;=0A=
+	struct MessageUnit_C __iomem *reg =3D acb->pmuC;=0A=
 	uint32_t flag_ccb, ccb_cdb_phy;=0A=
 	struct ARCMSR_CDB *arcmsr_cdb;=0A=
 	bool error;=0A=
@@ -2431,7 +3549,8 @@ static int arcmsr_polling_hbc_ccbdone(st=0A=
 polling_hbc_ccb_retry:=0A=
 	poll_count++;=0A=
 	while (1) {=0A=
-		if ((readl(&reg->host_int_status) & =
ARCMSR_HBCMU_OUTBOUND_POSTQUEUE_ISR) =3D=3D 0) {=0A=
+		if ((readl(&reg->host_int_status) &=0A=
+			ARCMSR_HBCMU_OUTBOUND_POSTQUEUE_ISR) =3D=3D 0) {=0A=
 			if (poll_ccb_done) {=0A=
 				rtn =3D SUCCESS;=0A=
 				break;=0A=
@@ -2446,74 +3565,180 @@ polling_hbc_ccb_retry:=0A=
 		}=0A=
 		flag_ccb =3D readl(&reg->outbound_queueport_low);=0A=
 		ccb_cdb_phy =3D (flag_ccb & 0xFFFFFFF0);=0A=
-		arcmsr_cdb =3D (struct ARCMSR_CDB *)(acb->vir2phy_offset + =
ccb_cdb_phy);/*frame must be 32 bytes aligned*/=0A=
-		pCCB =3D container_of(arcmsr_cdb, struct CommandControlBlock, =
arcmsr_cdb);=0A=
+		arcmsr_cdb =3D (struct ARCMSR_CDB *)(acb->vir2phy_offset=0A=
+			+ ccb_cdb_phy);=0A=
+		pCCB =3D container_of(arcmsr_cdb, struct CommandControlBlock,=0A=
+			arcmsr_cdb);=0A=
 		poll_ccb_done =3D (pCCB =3D=3D poll_ccb) ? 1 : 0;=0A=
 		/* check ifcommand done with no error*/=0A=
-		if ((pCCB->acb !=3D acb) || (pCCB->startdone !=3D ARCMSR_CCB_START)) {=0A=
+		if ((pCCB->acb !=3D acb) ||=0A=
+			(pCCB->startdone !=3D ARCMSR_CCB_START)) {=0A=
 			if (pCCB->startdone =3D=3D ARCMSR_CCB_ABORTED) {=0A=
-				printk(KERN_NOTICE "arcmsr%d: scsi id =3D %d lun =3D %d ccb =3D =
'0x%p'"=0A=
-					" poll command abort successfully \n"=0A=
-					, acb->host->host_no=0A=
-					, pCCB->pcmd->device->id=0A=
-					, pCCB->pcmd->device->lun=0A=
-					, pCCB);=0A=
-					pCCB->pcmd->result =3D DID_ABORT << 16;=0A=
-					arcmsr_ccb_complete(pCCB);=0A=
+				pr_notice("arcmsr%d: "=0A=
+				"scsi id =3D %d lun =3D %d ccb =3D '0x%p' poll "=0A=
+				"command abort successfully\n"=0A=
+				, acb->host->host_no=0A=
+				, pCCB->pcmd->device->id=0A=
+				, pCCB->pcmd->device->lun=0A=
+				, pCCB);=0A=
+				pCCB->pcmd->result =3D DID_ABORT << 16;=0A=
+				arcmsr_ccb_complete(pCCB);=0A=
 				continue;=0A=
 			}=0A=
-			printk(KERN_NOTICE "arcmsr%d: polling get an illegal ccb"=0A=
-				" command done ccb =3D '0x%p'"=0A=
-				"ccboutstandingcount =3D %d \n"=0A=
+			pr_notice("arcmsr%d: polling get an illegal "=0A=
+			"ccb command done ccb =3D '0x%p' "=0A=
+			"ccboutstandingcount =3D %d\n"=0A=
+			, acb->host->host_no=0A=
+			, pCCB=0A=
+			, atomic_read(&acb->ccboutstandingcount));=0A=
+			continue;=0A=
+		}=0A=
+		error =3D (flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR_MODE1)=0A=
+			? true : false;=0A=
+		arcmsr_report_ccb_state(acb, pCCB, error);=0A=
+	}=0A=
+	return rtn;=0A=
+}=0A=
+=0A=
+static int=0A=
+arcmsr_hbaD_polling_ccbdone(struct AdapterControlBlock *acb,=0A=
+				struct CommandControlBlock *poll_ccb)=0A=
+{=0A=
+	bool error;=0A=
+	uint32_t poll_ccb_done =3D 0, poll_count =3D 0, flag_ccb, ccb_cdb_phy;=0A=
+	int rtn, doneq_index, index_stripped, outbound_write_pointer;=0A=
+	unsigned long flags;=0A=
+	struct ARCMSR_CDB *arcmsr_cdb;=0A=
+	struct CommandControlBlock *pCCB;=0A=
+	struct MessageUnit_D __iomem *pmu =3D acb->pmuD;=0A=
+=0A=
+	spin_lock_irqsave(&acb->doneq_lock, flags);=0A=
+	polling_hbaD_ccb_retry:=0A=
+	poll_count++;=0A=
+	while (1) {=0A=
+		outbound_write_pointer =3D=0A=
+		pmu->done_qbuffer[0].addressLow + 1;=0A=
+		doneq_index =3D pmu->doneq_index;=0A=
+		if ((outbound_write_pointer & 0xFFF) =3D=3D (doneq_index & 0xFFF)) {=0A=
+			if (poll_ccb_done) {=0A=
+				rtn =3D SUCCESS;=0A=
+				break;=0A=
+			} else {=0A=
+				msleep(25);=0A=
+				if (poll_count > 100) {=0A=
+					rtn =3D FAILED;=0A=
+					break;=0A=
+				}=0A=
+				goto polling_hbaD_ccb_retry;=0A=
+			}=0A=
+		}=0A=
+		if (doneq_index & 0x4000) {=0A=
+			index_stripped =3D doneq_index & 0xFFF;=0A=
+			index_stripped +=3D 1;=0A=
+			index_stripped %=3D ARCMSR_MAX_ARC1214_DONEQUEUE;=0A=
+			pmu->doneq_index =3D index_stripped ? (index_stripped | 0x4000)=0A=
+				: (index_stripped + 1);=0A=
+		} else {=0A=
+			index_stripped =3D doneq_index;=0A=
+			index_stripped +=3D 1;=0A=
+			index_stripped %=3D ARCMSR_MAX_ARC1214_DONEQUEUE;=0A=
+			pmu->doneq_index =3D index_stripped ? index_stripped :=0A=
+				((index_stripped | 0x4000) + 1);=0A=
+		}=0A=
+		doneq_index =3D pmu->doneq_index;=0A=
+		flag_ccb =3D pmu->done_qbuffer[doneq_index & 0xFFF].addressLow;=0A=
+		ccb_cdb_phy =3D (flag_ccb & 0xFFFFFFF0);=0A=
+		arcmsr_cdb =3D (struct ARCMSR_CDB *)(acb->vir2phy_offset +=0A=
+			ccb_cdb_phy);=0A=
+		pCCB =3D container_of(arcmsr_cdb,=0A=
+			struct CommandControlBlock, arcmsr_cdb);=0A=
+		poll_ccb_done =3D (pCCB =3D=3D poll_ccb) ? 1 : 0;=0A=
+		if ((pCCB->acb !=3D acb) ||=0A=
+		(pCCB->startdone !=3D ARCMSR_CCB_START)) {=0A=
+			if (pCCB->startdone =3D=3D ARCMSR_CCB_ABORTED) {=0A=
+				pr_notice("arcmsr%d: scsi id =3D %d "=0A=
+				"lun =3D %d ccb =3D '0x%p' poll command "=0A=
+				"abort successfully\n"=0A=
 				, acb->host->host_no=0A=
-				, pCCB=0A=
-				, atomic_read(&acb->ccboutstandingcount));=0A=
+				, pCCB->pcmd->device->id=0A=
+				, pCCB->pcmd->device->lun=0A=
+				, pCCB);=0A=
+				pCCB->pcmd->result =3D DID_ABORT << 16;=0A=
+				arcmsr_ccb_complete(pCCB);=0A=
+				continue;=0A=
+			}=0A=
+			pr_notice("arcmsr%d: polling an illegal "=0A=
+			"ccb command done ccb =3D '0x%p' "=0A=
+			"ccboutstandingcount =3D %d\n"=0A=
+			, acb->host->host_no=0A=
+			, pCCB=0A=
+			, atomic_read(&acb->ccboutstandingcount));=0A=
 			continue;=0A=
 		}=0A=
-		error =3D (flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR_MODE1) ? true : =
false;=0A=
+		error =3D (flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR_MODE1)=0A=
+		? true : false;=0A=
 		arcmsr_report_ccb_state(acb, pCCB, error);=0A=
 	}=0A=
+	spin_unlock_irqrestore(&acb->doneq_lock, flags);=0A=
 	return rtn;=0A=
 }=0A=
-static int arcmsr_polling_ccbdone(struct AdapterControlBlock *acb,=0A=
-					struct CommandControlBlock *poll_ccb)=0A=
+=0A=
+static int=0A=
+arcmsr_polling_ccbdone(struct AdapterControlBlock *acb,=0A=
+				struct CommandControlBlock *poll_ccb)=0A=
 {=0A=
 	int rtn =3D 0;=0A=
 	switch (acb->adapter_type) {=0A=
-=0A=
-	case ACB_ADAPTER_TYPE_A: {=0A=
-		rtn =3D arcmsr_polling_hba_ccbdone(acb, poll_ccb);=0A=
-		}=0A=
+	case ACB_ADAPTER_TYPE_A:{=0A=
+		rtn =3D arcmsr_hbaA_polling_ccbdone(acb, poll_ccb);=0A=
 		break;=0A=
-=0A=
-	case ACB_ADAPTER_TYPE_B: {=0A=
-		rtn =3D arcmsr_polling_hbb_ccbdone(acb, poll_ccb);=0A=
-		}=0A=
+	}=0A=
+	case ACB_ADAPTER_TYPE_B:{=0A=
+		rtn =3D arcmsr_hbaB_polling_ccbdone(acb, poll_ccb);=0A=
 		break;=0A=
+	}=0A=
 	case ACB_ADAPTER_TYPE_C: {=0A=
-		rtn =3D arcmsr_polling_hbc_ccbdone(acb, poll_ccb);=0A=
-		}=0A=
+		rtn =3D arcmsr_hbaC_polling_ccbdone(acb, poll_ccb);=0A=
+		break;=0A=
+	}=0A=
+	case ACB_ADAPTER_TYPE_D: {=0A=
+		rtn =3D arcmsr_hbaD_polling_ccbdone(acb, poll_ccb);=0A=
+		break;=0A=
+	}=0A=
 	}=0A=
 	return rtn;=0A=
 }=0A=
 =0A=
-static int arcmsr_iop_confirm(struct AdapterControlBlock *acb)=0A=
+static int=0A=
+arcmsr_iop_confirm(struct AdapterControlBlock *acb)=0A=
 {=0A=
-	uint32_t cdb_phyaddr, cdb_phyaddr_hi32;=0A=
+	uint32_t cdb_phyaddr, cdb_phyaddr_hi32, cdb_phyaddr_lo32;=0A=
 	dma_addr_t dma_coherent_handle;=0A=
 	/*=0A=
 	********************************************************************=0A=
-	** here we need to tell iop 331 our freeccb.HighPart=0A=
+	** Here we need to tell iop our freeccb.HighPart=0A=
 	** if freeccb.HighPart is not zero=0A=
 	********************************************************************=0A=
 	*/=0A=
-	dma_coherent_handle =3D acb->dma_coherent_handle;=0A=
-	cdb_phyaddr =3D (uint32_t)(dma_coherent_handle);=0A=
+	switch (acb->adapter_type) {=0A=
+		case ACB_ADAPTER_TYPE_A:=0A=
+		case ACB_ADAPTER_TYPE_B:=0A=
+		case ACB_ADAPTER_TYPE_C:=0A=
+			dma_coherent_handle =3D acb->dma_coherent_handle;=0A=
+			break;=0A=
+		case ACB_ADAPTER_TYPE_D:=0A=
+			dma_coherent_handle =3D acb->dma_coherent_handle2;=0A=
+			break;=0A=
+		default:=0A=
+			dma_coherent_handle =3D acb->dma_coherent_handle;=0A=
+			break;=0A=
+	}=0A=
+	cdb_phyaddr_lo32 =3D (uint32_t)(dma_coherent_handle & 0xffffffff);=0A=
 	cdb_phyaddr_hi32 =3D (uint32_t)((cdb_phyaddr >> 16) >> 16);=0A=
 	acb->cdb_phyaddr_hi32 =3D cdb_phyaddr_hi32;=0A=
 	/*=0A=
 	***********************************************************************=0A=
-	**    if adapter type B, set window of "post command Q"=0A=
+	** if adapter type B D set window of "post command Q"=0A=
 	***********************************************************************=0A=
 	*/=0A=
 	switch (acb->adapter_type) {=0A=
@@ -2521,20 +3746,17 @@ static int arcmsr_iop_confirm(struct Ada=0A=
 	case ACB_ADAPTER_TYPE_A: {=0A=
 		if (cdb_phyaddr_hi32 !=3D 0) {=0A=
 			struct MessageUnit_A __iomem *reg =3D acb->pmuA;=0A=
-			uint32_t intmask_org;=0A=
-			intmask_org =3D arcmsr_disable_outbound_ints(acb);=0A=
-			writel(ARCMSR_SIGNATURE_SET_CONFIG, \=0A=
-						&reg->message_rwbuffer[0]);=0A=
+			writel(ARCMSR_SIGNATURE_SET_CONFIG,=0A=
+			&reg->message_rwbuffer[0]);=0A=
 			writel(cdb_phyaddr_hi32, &reg->message_rwbuffer[1]);=0A=
-			writel(ARCMSR_INBOUND_MESG0_SET_CONFIG, \=0A=
-							&reg->inbound_msgaddr0);=0A=
-			if (!arcmsr_hba_wait_msgint_ready(acb)) {=0A=
-				printk(KERN_NOTICE "arcmsr%d: ""set ccb high \=0A=
-				part physical address timeout\n",=0A=
+			writel(ARCMSR_INBOUND_MESG0_SET_CONFIG,=0A=
+			&reg->inbound_msgaddr0);=0A=
+			if (!arcmsr_hbaA_wait_msgint_ready(acb)) {=0A=
+				pr_notice("arcmsr%d: set ccb "=0A=
+				"high part physical address timeout\n",=0A=
 				acb->host->host_no);=0A=
 				return 1;=0A=
 			}=0A=
-			arcmsr_enable_outbound_ints(acb, intmask_org);=0A=
 		}=0A=
 		}=0A=
 		break;=0A=
@@ -2543,18 +3765,17 @@ static int arcmsr_iop_confirm(struct Ada=0A=
 		unsigned long post_queue_phyaddr;=0A=
 		uint32_t __iomem *rwbuffer;=0A=
 =0A=
-		struct MessageUnit_B *reg =3D acb->pmuB;=0A=
-		uint32_t intmask_org;=0A=
-		intmask_org =3D arcmsr_disable_outbound_ints(acb);=0A=
+		struct MessageUnit_B __iomem *reg =3D acb->pmuB;=0A=
 		reg->postq_index =3D 0;=0A=
 		reg->doneq_index =3D 0;=0A=
-		writel(ARCMSR_MESSAGE_SET_POST_WINDOW, reg->drv2iop_doorbell);=0A=
-		if (!arcmsr_hbb_wait_msgint_ready(acb)) {=0A=
-			printk(KERN_NOTICE "arcmsr%d:can not set diver mode\n", \=0A=
-				acb->host->host_no);=0A=
+		writel(ARCMSR_MESSAGE_SET_POST_WINDOW,=0A=
+		reg->drv2iop_doorbell);=0A=
+		if (!arcmsr_hbaB_wait_msgint_ready(acb)) {=0A=
+			pr_notice("arcmsr%d:can not set diver mode\n",=0A=
+			acb->host->host_no);=0A=
 			return 1;=0A=
 		}=0A=
-		post_queue_phyaddr =3D acb->dma_coherent_handle_hbb_mu;=0A=
+		post_queue_phyaddr =3D acb->dma_coherent_handle2;=0A=
 		rwbuffer =3D reg->message_rwbuffer;=0A=
 		/* driver "set config" signature */=0A=
 		writel(ARCMSR_SIGNATURE_SET_CONFIG, rwbuffer++);=0A=
@@ -2566,39 +3787,64 @@ static int arcmsr_iop_confirm(struct Ada=0A=
 		writel(post_queue_phyaddr + 1056, rwbuffer++);=0A=
 		/* ccb maxQ size must be --> [(256 + 8)*4]*/=0A=
 		writel(1056, rwbuffer);=0A=
-=0A=
 		writel(ARCMSR_MESSAGE_SET_CONFIG, reg->drv2iop_doorbell);=0A=
-		if (!arcmsr_hbb_wait_msgint_ready(acb)) {=0A=
-			printk(KERN_NOTICE "arcmsr%d: 'set command Q window' \=0A=
-			timeout \n",acb->host->host_no);=0A=
+		if (!arcmsr_hbaB_wait_msgint_ready(acb)) {=0A=
+			pr_notice("arcmsr%d: 'set command Q window' "=0A=
+			"timeout\n", acb->host->host_no);=0A=
 			return 1;=0A=
 		}=0A=
 		arcmsr_hbb_enable_driver_mode(acb);=0A=
-		arcmsr_enable_outbound_ints(acb, intmask_org);=0A=
 		}=0A=
 		break;=0A=
 	case ACB_ADAPTER_TYPE_C: {=0A=
+		struct MessageUnit_C __iomem *reg =3D acb->pmuC;=0A=
 		if (cdb_phyaddr_hi32 !=3D 0) {=0A=
-			struct MessageUnit_C *reg =3D (struct MessageUnit_C *)acb->pmuC;=0A=
-=0A=
-			printk(KERN_NOTICE "arcmsr%d: cdb_phyaddr_hi32=3D0x%x\n",=0A=
-					acb->adapter_index, cdb_phyaddr_hi32);=0A=
-			writel(ARCMSR_SIGNATURE_SET_CONFIG, &reg->msgcode_rwbuffer[0]);=0A=
-			writel(cdb_phyaddr_hi32, &reg->msgcode_rwbuffer[1]);=0A=
-			writel(ARCMSR_INBOUND_MESG0_SET_CONFIG, &reg->inbound_msgaddr0);=0A=
-			writel(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE, =
&reg->inbound_doorbell);=0A=
-			if (!arcmsr_hbc_wait_msgint_ready(acb)) {=0A=
-				printk(KERN_NOTICE "arcmsr%d: 'set command Q window' \=0A=
-				timeout \n", acb->host->host_no);=0A=
+			pr_notice("arcmsr%d: cdb_phyaddr_hi32 =3D 0x%x\n",=0A=
+			acb->adapter_index, cdb_phyaddr_hi32);=0A=
+			writel(ARCMSR_SIGNATURE_SET_CONFIG,=0A=
+				&reg->msgcode_rwbuffer[0]);=0A=
+			writel(cdb_phyaddr_hi32,=0A=
+				&reg->msgcode_rwbuffer[1]);=0A=
+			writel(ARCMSR_INBOUND_MESG0_SET_CONFIG,=0A=
+				&reg->inbound_msgaddr0);=0A=
+			writel(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE,=0A=
+				&reg->inbound_doorbell);=0A=
+			if (!arcmsr_hbaC_wait_msgint_ready(acb)) {=0A=
+				pr_notice("arcmsr%d: 'set "=0A=
+				"command Q window' timeout\n",=0A=
+				acb->host->host_no);=0A=
 				return 1;=0A=
 			}=0A=
 		}=0A=
 		}=0A=
+		break;=0A=
+	case ACB_ADAPTER_TYPE_D: {=0A=
+		uint32_t __iomem *rwbuffer;=0A=
+=0A=
+		struct MessageUnit_D __iomem *reg =3D acb->pmuD;=0A=
+		reg->postq_index =3D 0;=0A=
+		reg->doneq_index =3D 0;=0A=
+		rwbuffer =3D reg->msgcode_rwbuffer;=0A=
+		writel(ARCMSR_SIGNATURE_SET_CONFIG, rwbuffer++);=0A=
+		writel(cdb_phyaddr_hi32, rwbuffer++);=0A=
+		writel(cdb_phyaddr_lo32, rwbuffer++);=0A=
+		writel(cdb_phyaddr_lo32 +=0A=
+		(ARCMSR_MAX_ARC1214_POSTQUEUE * sizeof(struct InBound_SRB)),=0A=
+		rwbuffer++);=0A=
+		writel(0x100, rwbuffer);=0A=
+		writel(ARCMSR_INBOUND_MESG0_SET_CONFIG,=0A=
+			reg->inbound_msgaddr0);=0A=
+		if (!arcmsr_hbaD_wait_msgint_ready(acb))=0A=
+			pr_notice("arcmsr%d: 'set command Q "=0A=
+			"window' timeout\n", acb->host->host_no);=0A=
+		break;=0A=
+	}=0A=
 	}=0A=
 	return 0;=0A=
 }=0A=
 =0A=
-static void arcmsr_wait_firmware_ready(struct AdapterControlBlock *acb)=0A=
+static void=0A=
+arcmsr_wait_firmware_ready(struct AdapterControlBlock *acb)=0A=
 {=0A=
 	uint32_t firmware_state =3D 0;=0A=
 	switch (acb->adapter_type) {=0A=
@@ -2607,161 +3853,259 @@ static void arcmsr_wait_firmware_ready(s=0A=
 		struct MessageUnit_A __iomem *reg =3D acb->pmuA;=0A=
 		do {=0A=
 			firmware_state =3D readl(&reg->outbound_msgaddr1);=0A=
-		} while ((firmware_state & ARCMSR_OUTBOUND_MESG1_FIRMWARE_OK) =3D=3D =
0);=0A=
+		} while ((firmware_state &=0A=
+		ARCMSR_OUTBOUND_MESG1_FIRMWARE_OK) =3D=3D 0);=0A=
 		}=0A=
 		break;=0A=
-=0A=
 	case ACB_ADAPTER_TYPE_B: {=0A=
-		struct MessageUnit_B *reg =3D acb->pmuB;=0A=
+		struct MessageUnit_B __iomem *reg =3D acb->pmuB;=0A=
 		do {=0A=
 			firmware_state =3D readl(reg->iop2drv_doorbell);=0A=
 		} while ((firmware_state & ARCMSR_MESSAGE_FIRMWARE_OK) =3D=3D 0);=0A=
-		writel(ARCMSR_DRV2IOP_END_OF_INTERRUPT, reg->drv2iop_doorbell);=0A=
+		writel(ARCMSR_DRV2IOP_END_OF_INTERRUPT,=0A=
+		reg->drv2iop_doorbell);=0A=
 		}=0A=
 		break;=0A=
 	case ACB_ADAPTER_TYPE_C: {=0A=
-		struct MessageUnit_C *reg =3D (struct MessageUnit_C *)acb->pmuC;=0A=
+		struct MessageUnit_C __iomem *reg =3D acb->pmuC;=0A=
 		do {=0A=
 			firmware_state =3D readl(&reg->outbound_msgaddr1);=0A=
-		} while ((firmware_state & ARCMSR_HBCMU_MESSAGE_FIRMWARE_OK) =3D=3D =
0);=0A=
+		} while ((firmware_state &=0A=
+		ARCMSR_HBCMU_MESSAGE_FIRMWARE_OK) =3D=3D 0);=0A=
 		}=0A=
+		break;=0A=
+	case ACB_ADAPTER_TYPE_D: {=0A=
+		struct MessageUnit_D __iomem *reg =3D acb->pmuD;=0A=
+		do {=0A=
+			firmware_state =3D readl(reg->outbound_msgaddr1);=0A=
+		} while ((firmware_state &=0A=
+		ARCMSR_ARC1214_MESSAGE_FIRMWARE_OK) =3D=3D 0);=0A=
+		break;=0A=
+	}=0A=
 	}=0A=
 }=0A=
 =0A=
-static void arcmsr_request_hba_device_map(struct AdapterControlBlock =
*acb)=0A=
+static void=0A=
+arcmsr_hbaA_request_device_map(struct AdapterControlBlock *acb)=0A=
 {=0A=
 	struct MessageUnit_A __iomem *reg =3D acb->pmuA;=0A=
-	if (unlikely(atomic_read(&acb->rq_map_token) =3D=3D 0) || =
((acb->acb_flags & ACB_F_BUS_RESET) !=3D 0 ) || ((acb->acb_flags & =
ACB_F_ABORT) !=3D 0 )){=0A=
-		mod_timer(&acb->eternal_timer, jiffies + msecs_to_jiffies(6 * HZ));=0A=
+	if (unlikely(atomic_read(&acb->rq_map_token) =3D=3D 0) ||=0A=
+		((acb->acb_flags & ACB_F_BUS_RESET) !=3D 0)=0A=
+		|| ((acb->acb_flags & ACB_F_ABORT) !=3D 0)) {=0A=
+		mod_timer(&acb->eternal_timer,=0A=
+			jiffies + msecs_to_jiffies(6 * HZ));=0A=
 		return;=0A=
 	} else {=0A=
 		acb->fw_flag =3D FW_NORMAL;=0A=
-		if (atomic_read(&acb->ante_token_value) =3D=3D =
atomic_read(&acb->rq_map_token)){=0A=
+		if (atomic_read(&acb->ante_token_value) =3D=3D=0A=
+			atomic_read(&acb->rq_map_token)) {=0A=
 			atomic_set(&acb->rq_map_token, 16);=0A=
 		}=0A=
-		atomic_set(&acb->ante_token_value, atomic_read(&acb->rq_map_token));=0A=
+		atomic_set(&acb->ante_token_value,=0A=
+			atomic_read(&acb->rq_map_token));=0A=
 		if (atomic_dec_and_test(&acb->rq_map_token)) {=0A=
-			mod_timer(&acb->eternal_timer, jiffies + msecs_to_jiffies(6 * HZ));=0A=
+			mod_timer(&acb->eternal_timer,=0A=
+				jiffies + msecs_to_jiffies(6 * HZ));=0A=
 			return;=0A=
 		}=0A=
-		writel(ARCMSR_INBOUND_MESG0_GET_CONFIG, &reg->inbound_msgaddr0);=0A=
-		mod_timer(&acb->eternal_timer, jiffies + msecs_to_jiffies(6 * HZ));=0A=
+		writel(ARCMSR_INBOUND_MESG0_GET_CONFIG,=0A=
+			&reg->inbound_msgaddr0);=0A=
+		mod_timer(&acb->eternal_timer, jiffies +=0A=
+			msecs_to_jiffies(6 * HZ));=0A=
 	}=0A=
-	return;=0A=
 }=0A=
 =0A=
-static void arcmsr_request_hbb_device_map(struct AdapterControlBlock =
*acb)=0A=
+static void=0A=
+arcmsr_hbaB_request_device_map(struct AdapterControlBlock *acb)=0A=
 {=0A=
 	struct MessageUnit_B __iomem *reg =3D acb->pmuB;=0A=
-	if (unlikely(atomic_read(&acb->rq_map_token) =3D=3D 0) || =
((acb->acb_flags & ACB_F_BUS_RESET) !=3D 0 ) || ((acb->acb_flags & =
ACB_F_ABORT) !=3D 0 )){=0A=
-		mod_timer(&acb->eternal_timer, jiffies + msecs_to_jiffies(6 * HZ));=0A=
+	if (unlikely(atomic_read(&acb->rq_map_token) =3D=3D 0) ||=0A=
+		((acb->acb_flags & ACB_F_BUS_RESET) !=3D 0) ||=0A=
+		((acb->acb_flags & ACB_F_ABORT) !=3D 0)) {=0A=
+		mod_timer(&acb->eternal_timer, jiffies +=0A=
+			msecs_to_jiffies(6 * HZ));=0A=
 		return;=0A=
 	} else {=0A=
 		acb->fw_flag =3D FW_NORMAL;=0A=
-		if (atomic_read(&acb->ante_token_value) =3D=3D =
atomic_read(&acb->rq_map_token)) {=0A=
+		if (atomic_read(&acb->ante_token_value) =3D=3D=0A=
+			atomic_read(&acb->rq_map_token)) {=0A=
 			atomic_set(&acb->rq_map_token, 16);=0A=
 		}=0A=
-		atomic_set(&acb->ante_token_value, atomic_read(&acb->rq_map_token));=0A=
+		atomic_set(&acb->ante_token_value,=0A=
+			atomic_read(&acb->rq_map_token));=0A=
 		if (atomic_dec_and_test(&acb->rq_map_token)) {=0A=
-			mod_timer(&acb->eternal_timer, jiffies + msecs_to_jiffies(6 * HZ));=0A=
+			mod_timer(&acb->eternal_timer,=0A=
+				jiffies + msecs_to_jiffies(6 * HZ));=0A=
 			return;=0A=
 		}=0A=
-		writel(ARCMSR_MESSAGE_GET_CONFIG, reg->drv2iop_doorbell);=0A=
-		mod_timer(&acb->eternal_timer, jiffies + msecs_to_jiffies(6 * HZ));=0A=
+		writel(ARCMSR_MESSAGE_GET_CONFIG,=0A=
+			reg->drv2iop_doorbell);=0A=
+		mod_timer(&acb->eternal_timer, jiffies +=0A=
+			msecs_to_jiffies(6 * HZ));=0A=
 	}=0A=
-	return;=0A=
 }=0A=
 =0A=
-static void arcmsr_request_hbc_device_map(struct AdapterControlBlock =
*acb)=0A=
+static void=0A=
+arcmsr_hbaC_request_device_map(struct AdapterControlBlock *acb)=0A=
 {=0A=
 	struct MessageUnit_C __iomem *reg =3D acb->pmuC;=0A=
-	if (unlikely(atomic_read(&acb->rq_map_token) =3D=3D 0) || =
((acb->acb_flags & ACB_F_BUS_RESET) !=3D 0) || ((acb->acb_flags & =
ACB_F_ABORT) !=3D 0)) {=0A=
-		mod_timer(&acb->eternal_timer, jiffies + msecs_to_jiffies(6 * HZ));=0A=
+	if (unlikely(atomic_read(&acb->rq_map_token) =3D=3D 0) ||=0A=
+		((acb->acb_flags & ACB_F_BUS_RESET) !=3D 0) ||=0A=
+		((acb->acb_flags & ACB_F_ABORT) !=3D 0)) {=0A=
+		mod_timer(&acb->eternal_timer, jiffies +=0A=
+			msecs_to_jiffies(6 * HZ));=0A=
 		return;=0A=
 	} else {=0A=
 		acb->fw_flag =3D FW_NORMAL;=0A=
-		if (atomic_read(&acb->ante_token_value) =3D=3D =
atomic_read(&acb->rq_map_token)) {=0A=
+		if (atomic_read(&acb->ante_token_value) =3D=3D=0A=
+			atomic_read(&acb->rq_map_token)) {=0A=
 			atomic_set(&acb->rq_map_token, 16);=0A=
 		}=0A=
-		atomic_set(&acb->ante_token_value, atomic_read(&acb->rq_map_token));=0A=
+		atomic_set(&acb->ante_token_value,=0A=
+			atomic_read(&acb->rq_map_token));=0A=
 		if (atomic_dec_and_test(&acb->rq_map_token)) {=0A=
-			mod_timer(&acb->eternal_timer, jiffies + msecs_to_jiffies(6 * HZ));=0A=
+			mod_timer(&acb->eternal_timer,=0A=
+				jiffies + msecs_to_jiffies(6 * HZ));=0A=
 			return;=0A=
 		}=0A=
-		writel(ARCMSR_INBOUND_MESG0_GET_CONFIG, &reg->inbound_msgaddr0);=0A=
-		writel(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE, &reg->inbound_doorbell);=0A=
-		mod_timer(&acb->eternal_timer, jiffies + msecs_to_jiffies(6 * HZ));=0A=
+		writel(ARCMSR_INBOUND_MESG0_GET_CONFIG,=0A=
+			&reg->inbound_msgaddr0);=0A=
+		writel(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE,=0A=
+			&reg->inbound_doorbell);=0A=
+		mod_timer(&acb->eternal_timer, jiffies +=0A=
+			msecs_to_jiffies(6 * HZ));=0A=
+	}=0A=
+}=0A=
+=0A=
+static void=0A=
+arcmsr_hbaD_request_device_map(struct AdapterControlBlock *acb)=0A=
+{=0A=
+	struct MessageUnit_D __iomem *reg =3D acb->pmuD;=0A=
+	if (unlikely(atomic_read(&acb->rq_map_token) =3D=3D 0) ||=0A=
+		((acb->acb_flags & ACB_F_BUS_RESET) !=3D 0) ||=0A=
+		((acb->acb_flags & ACB_F_ABORT) !=3D 0)) {=0A=
+		mod_timer(&acb->eternal_timer,=0A=
+			jiffies + msecs_to_jiffies(6 * HZ));=0A=
+	} else {=0A=
+		acb->fw_flag =3D FW_NORMAL;=0A=
+		if (atomic_read(&acb->ante_token_value) =3D=3D=0A=
+			atomic_read(&acb->rq_map_token)) {=0A=
+			atomic_set(&acb->rq_map_token, 16);=0A=
+		}=0A=
+		atomic_set(&acb->ante_token_value,=0A=
+			atomic_read(&acb->rq_map_token));=0A=
+		if (atomic_dec_and_test(&acb->rq_map_token)) {=0A=
+			mod_timer(&acb->eternal_timer, jiffies +=0A=
+				msecs_to_jiffies(6 * HZ));=0A=
+			return;=0A=
+		}=0A=
+		writel(ARCMSR_INBOUND_MESG0_GET_CONFIG,=0A=
+			reg->inbound_msgaddr0);=0A=
+		mod_timer(&acb->eternal_timer, jiffies +=0A=
+			msecs_to_jiffies(6 * HZ));=0A=
 	}=0A=
-	return;=0A=
 }=0A=
 =0A=
-static void arcmsr_request_device_map(unsigned long pacb)=0A=
+static void=0A=
+arcmsr_request_device_map(unsigned long pacb)=0A=
 {=0A=
-	struct AdapterControlBlock *acb =3D (struct AdapterControlBlock *)pacb;=0A=
+	struct AdapterControlBlock *acb =3D=0A=
+		(struct AdapterControlBlock *)pacb;=0A=
 	switch (acb->adapter_type) {=0A=
 		case ACB_ADAPTER_TYPE_A: {=0A=
-			arcmsr_request_hba_device_map(acb);=0A=
+			arcmsr_hbaA_request_device_map(acb);=0A=
+			break;=0A=
 		}=0A=
-		break;=0A=
 		case ACB_ADAPTER_TYPE_B: {=0A=
-			arcmsr_request_hbb_device_map(acb);=0A=
+			arcmsr_hbaB_request_device_map(acb);=0A=
+			break;=0A=
 		}=0A=
-		break;=0A=
 		case ACB_ADAPTER_TYPE_C: {=0A=
-			arcmsr_request_hbc_device_map(acb);=0A=
+			arcmsr_hbaC_request_device_map(acb);=0A=
+			break;=0A=
+		}=0A=
+		case ACB_ADAPTER_TYPE_D: {=0A=
+			arcmsr_hbaD_request_device_map(acb);=0A=
+			break;=0A=
 		}=0A=
 	}=0A=
 }=0A=
 =0A=
-static void arcmsr_start_hba_bgrb(struct AdapterControlBlock *acb)=0A=
+static void=0A=
+arcmsr_hbaA_start_bgrb(struct AdapterControlBlock *acb)=0A=
 {=0A=
 	struct MessageUnit_A __iomem *reg =3D acb->pmuA;=0A=
 	acb->acb_flags |=3D ACB_F_MSG_START_BGRB;=0A=
-	writel(ARCMSR_INBOUND_MESG0_START_BGRB, &reg->inbound_msgaddr0);=0A=
-	if (!arcmsr_hba_wait_msgint_ready(acb)) {=0A=
-		printk(KERN_NOTICE "arcmsr%d: wait 'start adapter background \=0A=
-				rebulid' timeout \n", acb->host->host_no);=0A=
+	writel(ARCMSR_INBOUND_MESG0_START_BGRB,=0A=
+		&reg->inbound_msgaddr0);=0A=
+	if (!arcmsr_hbaA_wait_msgint_ready(acb)) {=0A=
+		pr_notice("arcmsr%d: wait 'start adapter "=0A=
+		"background rebulid' timeout\n", acb->host->host_no);=0A=
 	}=0A=
 }=0A=
 =0A=
-static void arcmsr_start_hbb_bgrb(struct AdapterControlBlock *acb)=0A=
+static void=0A=
+arcmsr_hbaB_start_bgrb(struct AdapterControlBlock *acb)=0A=
 {=0A=
-	struct MessageUnit_B *reg =3D acb->pmuB;=0A=
+	struct MessageUnit_B __iomem *reg =3D acb->pmuB;=0A=
 	acb->acb_flags |=3D ACB_F_MSG_START_BGRB;=0A=
 	writel(ARCMSR_MESSAGE_START_BGRB, reg->drv2iop_doorbell);=0A=
-	if (!arcmsr_hbb_wait_msgint_ready(acb)) {=0A=
-		printk(KERN_NOTICE "arcmsr%d: wait 'start adapter background \=0A=
-				rebulid' timeout \n",acb->host->host_no);=0A=
+	if (!arcmsr_hbaB_wait_msgint_ready(acb)) {=0A=
+		pr_notice("arcmsr%d: wait 'start adapter "=0A=
+		"backgroundrebulid' timeout\n", acb->host->host_no);=0A=
 	}=0A=
 }=0A=
 =0A=
-static void arcmsr_start_hbc_bgrb(struct AdapterControlBlock *pACB)=0A=
+static void=0A=
+arcmsr_hbaC_start_bgrb(struct AdapterControlBlock *pACB)=0A=
 {=0A=
-	struct MessageUnit_C *phbcmu =3D (struct MessageUnit_C *)pACB->pmuC;=0A=
+	struct MessageUnit_C __iomem *phbcmu =3D pACB->pmuC;=0A=
 	pACB->acb_flags |=3D ACB_F_MSG_START_BGRB;=0A=
-	writel(ARCMSR_INBOUND_MESG0_START_BGRB, &phbcmu->inbound_msgaddr0);=0A=
-	writel(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE, =
&phbcmu->inbound_doorbell);=0A=
-	if (!arcmsr_hbc_wait_msgint_ready(pACB)) {=0A=
-		printk(KERN_NOTICE "arcmsr%d: wait 'start adapter background \=0A=
-				rebulid' timeout \n", pACB->host->host_no);=0A=
+	writel(ARCMSR_INBOUND_MESG0_START_BGRB,=0A=
+		&phbcmu->inbound_msgaddr0);=0A=
+	writel(ARCMSR_HBCMU_DRV2IOP_MESSAGE_CMD_DONE,=0A=
+		&phbcmu->inbound_doorbell);=0A=
+	if (!arcmsr_hbaC_wait_msgint_ready(pACB)) {=0A=
+		pr_notice("arcmsr%d: wait 'start adapter "=0A=
+		"background rebulid' timeout\n", pACB->host->host_no);=0A=
 	}=0A=
 	return;=0A=
 }=0A=
-static void arcmsr_start_adapter_bgrb(struct AdapterControlBlock *acb)=0A=
+=0A=
+static void=0A=
+arcmsr_hbaD_start_bgrb(struct AdapterControlBlock *pACB)=0A=
+{=0A=
+	struct MessageUnit_D __iomem *pmu =3D pACB->pmuD;=0A=
+	pACB->acb_flags |=3D ACB_F_MSG_START_BGRB;=0A=
+	writel(ARCMSR_INBOUND_MESG0_START_BGRB, pmu->inbound_msgaddr0);=0A=
+	if (!arcmsr_hbaD_wait_msgint_ready(pACB)) {=0A=
+		pr_notice("arcmsr%d: wait 'start adapter "=0A=
+		"background rebulid' timeout\n", pACB->host->host_no);=0A=
+	}=0A=
+	return;=0A=
+}=0A=
+=0A=
+static void=0A=
+arcmsr_start_adapter_bgrb(struct AdapterControlBlock *acb)=0A=
 {=0A=
 	switch (acb->adapter_type) {=0A=
 	case ACB_ADAPTER_TYPE_A:=0A=
-		arcmsr_start_hba_bgrb(acb);=0A=
+		arcmsr_hbaA_start_bgrb(acb);=0A=
 		break;=0A=
 	case ACB_ADAPTER_TYPE_B:=0A=
-		arcmsr_start_hbb_bgrb(acb);=0A=
+		arcmsr_hbaB_start_bgrb(acb);=0A=
 		break;=0A=
 	case ACB_ADAPTER_TYPE_C:=0A=
-		arcmsr_start_hbc_bgrb(acb);=0A=
+		arcmsr_hbaC_start_bgrb(acb);=0A=
+		break;=0A=
+	case ACB_ADAPTER_TYPE_D:=0A=
+		arcmsr_hbaD_start_bgrb(acb);=0A=
+		break;=0A=
 	}=0A=
 }=0A=
 =0A=
-static void arcmsr_clear_doorbell_queue_buffer(struct =
AdapterControlBlock *acb)=0A=
+static void=0A=
+arcmsr_clear_doorbell_queue_buffer(struct AdapterControlBlock *acb)=0A=
 {=0A=
 	switch (acb->adapter_type) {=0A=
 	case ACB_ADAPTER_TYPE_A: {=0A=
@@ -2771,65 +4115,107 @@ static void arcmsr_clear_doorbell_queue_=0A=
 		outbound_doorbell =3D readl(&reg->outbound_doorbell);=0A=
 		/*clear doorbell interrupt */=0A=
 		writel(outbound_doorbell, &reg->outbound_doorbell);=0A=
-		writel(ARCMSR_INBOUND_DRIVER_DATA_READ_OK, &reg->inbound_doorbell);=0A=
+		writel(ARCMSR_INBOUND_DRIVER_DATA_READ_OK,=0A=
+			&reg->inbound_doorbell);=0A=
 		}=0A=
 		break;=0A=
 =0A=
 	case ACB_ADAPTER_TYPE_B: {=0A=
-		struct MessageUnit_B *reg =3D acb->pmuB;=0A=
+		struct MessageUnit_B __iomem *reg =3D acb->pmuB;=0A=
 		/*clear interrupt and message state*/=0A=
-		writel(ARCMSR_MESSAGE_INT_CLEAR_PATTERN, reg->iop2drv_doorbell);=0A=
-		writel(ARCMSR_DRV2IOP_DATA_READ_OK, reg->drv2iop_doorbell);=0A=
+		writel(ARCMSR_MESSAGE_INT_CLEAR_PATTERN,=0A=
+		reg->iop2drv_doorbell);=0A=
+		writel(ARCMSR_DRV2IOP_DATA_READ_OK,=0A=
+			reg->drv2iop_doorbell);=0A=
 		/* let IOP know data has been read */=0A=
 		}=0A=
 		break;=0A=
 	case ACB_ADAPTER_TYPE_C: {=0A=
-		struct MessageUnit_C *reg =3D (struct MessageUnit_C *)acb->pmuC;=0A=
-		uint32_t outbound_doorbell;=0A=
+		struct MessageUnit_C __iomem *reg =3D acb->pmuC;=0A=
+		uint32_t outbound_doorbell, i;=0A=
 		/* empty doorbell Qbuffer if door bell ringed */=0A=
 		outbound_doorbell =3D readl(&reg->outbound_doorbell);=0A=
 		writel(outbound_doorbell, &reg->outbound_doorbell_clear);=0A=
-		writel(ARCMSR_HBCMU_DRV2IOP_DATA_READ_OK, &reg->inbound_doorbell);=0A=
+		writel(ARCMSR_HBCMU_DRV2IOP_DATA_READ_OK,=0A=
+			&reg->inbound_doorbell);=0A=
+		for (i =3D 0; i < 200; i++) {=0A=
+			msleep(20);=0A=
+			outbound_doorbell =3D readl(&reg->outbound_doorbell);=0A=
+			if (outbound_doorbell & ARCMSR_HBCMU_IOP2DRV_DATA_WRITE_OK) {=0A=
+				writel(outbound_doorbell,=0A=
+				&reg->outbound_doorbell_clear);=0A=
+				writel(ARCMSR_HBCMU_DRV2IOP_DATA_READ_OK,=0A=
+				&reg->inbound_doorbell);=0A=
+			} else=0A=
+				break;=0A=
+		}=0A=
+		}=0A=
+		break;=0A=
+	case ACB_ADAPTER_TYPE_D: {=0A=
+		struct MessageUnit_D __iomem *reg =3D acb->pmuD;=0A=
+		uint32_t outbound_doorbell, i;=0A=
+		/* empty doorbell Qbuffer if door bell ringed */=0A=
+		outbound_doorbell =3D readl(reg->outbound_doorbell);=0A=
+		writel(outbound_doorbell, reg->outbound_doorbell);=0A=
+		writel(ARCMSR_ARC1214_DRV2IOP_DATA_OUT_READ,=0A=
+			reg->inbound_doorbell);=0A=
+		for (i =3D 0; i < 200; i++) {=0A=
+			msleep(20);=0A=
+			outbound_doorbell =3D readl(reg->outbound_doorbell);=0A=
+			if (outbound_doorbell & ARCMSR_ARC1214_IOP2DRV_DATA_WRITE_OK) {=0A=
+				writel(outbound_doorbell,=0A=
+				reg->outbound_doorbell);=0A=
+				writel(ARCMSR_ARC1214_DRV2IOP_DATA_OUT_READ,=0A=
+				reg->inbound_doorbell);=0A=
+			} else=0A=
+				break;=0A=
 		}=0A=
+		break;=0A=
+	}=0A=
 	}=0A=
 }=0A=
 =0A=
-static void arcmsr_enable_eoi_mode(struct AdapterControlBlock *acb)=0A=
+static void=0A=
+arcmsr_enable_eoi_mode(struct AdapterControlBlock *acb)=0A=
 {=0A=
 	switch (acb->adapter_type) {=0A=
 	case ACB_ADAPTER_TYPE_A:=0A=
+	case ACB_ADAPTER_TYPE_C:=0A=
+	case ACB_ADAPTER_TYPE_D:=0A=
 		return;=0A=
-	case ACB_ADAPTER_TYPE_B:=0A=
-		{=0A=
-			struct MessageUnit_B *reg =3D acb->pmuB;=0A=
-			writel(ARCMSR_MESSAGE_ACTIVE_EOI_MODE, reg->drv2iop_doorbell);=0A=
-			if (!arcmsr_hbb_wait_msgint_ready(acb)) {=0A=
-				printk(KERN_NOTICE "ARCMSR IOP enables EOI_MODE TIMEOUT");=0A=
+	case ACB_ADAPTER_TYPE_B: {=0A=
+		struct MessageUnit_B __iomem *reg =3D acb->pmuB;=0A=
+			writel(ARCMSR_MESSAGE_ACTIVE_EOI_MODE,=0A=
+				reg->drv2iop_doorbell);=0A=
+			if (!arcmsr_hbaB_wait_msgint_ready(acb)) {=0A=
+				pr_notice("ARCMSR IOP "=0A=
+				"enables EOI_MODE TIMEOUT");=0A=
 				return;=0A=
 			}=0A=
-		}=0A=
-		break;=0A=
-	case ACB_ADAPTER_TYPE_C:=0A=
-		return;=0A=
+	}=0A=
+	break;=0A=
 	}=0A=
 	return;=0A=
 }=0A=
 =0A=
-static void arcmsr_hardware_reset(struct AdapterControlBlock *acb)=0A=
+static void=0A=
+arcmsr_hardware_reset(struct AdapterControlBlock *acb)=0A=
 {=0A=
 	uint8_t value[64];=0A=
 	int i, count =3D 0;=0A=
 	struct MessageUnit_A __iomem *pmuA =3D acb->pmuA;=0A=
 	struct MessageUnit_C __iomem *pmuC =3D acb->pmuC;=0A=
-=0A=
+	u32 temp =3D 0;=0A=
 	/* backup pci config data */=0A=
-	printk(KERN_NOTICE "arcmsr%d: executing hw bus reset .....\n", =
acb->host->host_no);=0A=
+	pr_notice("arcmsr%d: executing hw bus reset .....\n",=0A=
+	acb->host->host_no);=0A=
 	for (i =3D 0; i < 64; i++) {=0A=
 		pci_read_config_byte(acb->pdev, i, &value[i]);=0A=
 	}=0A=
 	/* hardware reset signal */=0A=
 	if ((acb->dev_id =3D=3D 0x1680)) {=0A=
-		writel(ARCMSR_ARC1680_BUS_RESET, &pmuA->reserved1[0]);=0A=
+		writel(ARCMSR_ARC1680_BUS_RESET,=0A=
+			&pmuA->reserved1[0]);=0A=
 	} else if ((acb->dev_id =3D=3D 0x1880)) {=0A=
 		do {=0A=
 			count++;=0A=
@@ -2839,8 +4225,11 @@ static void arcmsr_hardware_reset(struct=0A=
 			writel(0x2, &pmuC->write_sequence);=0A=
 			writel(0x7, &pmuC->write_sequence);=0A=
 			writel(0xD, &pmuC->write_sequence);=0A=
-		} while (((readl(&pmuC->host_diagnostic) & =
ARCMSR_ARC1880_DiagWrite_ENABLE) =3D=3D 0) && (count < 5));=0A=
-		writel(ARCMSR_ARC1880_RESET_ADAPTER, &pmuC->host_diagnostic);=0A=
+		} while ((((temp =3D readl(&pmuC->host_diagnostic)) |=0A=
+		ARCMSR_ARC1880_DiagWrite_ENABLE) =3D=3D 0) &&=0A=
+		(count < 5));=0A=
+		writel(ARCMSR_ARC1880_RESET_ADAPTER,=0A=
+			&pmuC->host_diagnostic);=0A=
 	} else {=0A=
 		pci_write_config_byte(acb->pdev, 0x84, 0x20);=0A=
 	}=0A=
@@ -2852,7 +4241,9 @@ static void arcmsr_hardware_reset(struct=0A=
 	msleep(1000);=0A=
 	return;=0A=
 }=0A=
-static void arcmsr_iop_init(struct AdapterControlBlock *acb)=0A=
+=0A=
+static void=0A=
+arcmsr_iop_init(struct AdapterControlBlock *acb)=0A=
 {=0A=
 	uint32_t intmask_org;=0A=
 	/* disable all outbound interrupt */=0A=
@@ -2869,7 +4260,8 @@ static void arcmsr_iop_init(struct Adapt=0A=
 	acb->acb_flags |=3D ACB_F_IOP_INITED;=0A=
 }=0A=
 =0A=
-static uint8_t arcmsr_iop_reset(struct AdapterControlBlock *acb)=0A=
+static uint8_t=0A=
+arcmsr_iop_reset(struct AdapterControlBlock *acb)=0A=
 {=0A=
 	struct CommandControlBlock *ccb;=0A=
 	uint32_t intmask_org;=0A=
@@ -2892,7 +4284,8 @@ static uint8_t arcmsr_iop_reset(struct A=0A=
 				ccb->ccb_flags =3D 0;=0A=
 				spin_lock_irqsave(&acb->ccblist_lock, flags);=0A=
 				list_add_tail(&ccb->list, &acb->ccb_free_list);=0A=
-				spin_unlock_irqrestore(&acb->ccblist_lock, flags);=0A=
+				spin_unlock_irqrestore(&acb->ccblist_lock,=0A=
+					flags);=0A=
 			}=0A=
 		}=0A=
 		atomic_set(&acb->ccboutstandingcount, 0);=0A=
@@ -2903,147 +4296,235 @@ static uint8_t arcmsr_iop_reset(struct A=0A=
 	return rtnval;=0A=
 }=0A=
 =0A=
-static int arcmsr_bus_reset(struct scsi_cmnd *cmd)=0A=
+static int=0A=
+arcmsr_bus_reset(struct scsi_cmnd *cmd)=0A=
 {=0A=
 	struct AdapterControlBlock *acb;=0A=
 	uint32_t intmask_org, outbound_doorbell;=0A=
 	int retry_count =3D 0;=0A=
 	int rtn =3D FAILED;=0A=
 	acb =3D (struct AdapterControlBlock *) cmd->device->host->hostdata;=0A=
-	printk(KERN_ERR "arcmsr: executing bus reset eh.....num_resets =3D %d, =
num_aborts =3D %d \n", acb->num_resets, acb->num_aborts);=0A=
+	pr_err("arcmsr: executing bus reset eh.....num_resets =3D %d, "=0A=
+	"num_aborts =3D %d\n", acb->num_resets, acb->num_aborts);=0A=
 	acb->num_resets++;=0A=
 =0A=
-	switch(acb->adapter_type){=0A=
-		case ACB_ADAPTER_TYPE_A:{=0A=
-			if (acb->acb_flags & ACB_F_BUS_RESET){=0A=
-				long timeout;=0A=
-				printk(KERN_ERR "arcmsr: there is an  bus reset eh =
proceeding.......\n");=0A=
-				timeout =3D wait_event_timeout(wait_q, (acb->acb_flags & =
ACB_F_BUS_RESET) =3D=3D 0, 220*HZ);=0A=
-				if (timeout) {=0A=
-					return SUCCESS;=0A=
-				}=0A=
-			}=0A=
-			acb->acb_flags |=3D ACB_F_BUS_RESET;=0A=
-			if (!arcmsr_iop_reset(acb)) {=0A=
-				struct MessageUnit_A __iomem *reg;=0A=
-				reg =3D acb->pmuA;=0A=
-				arcmsr_hardware_reset(acb);=0A=
-				acb->acb_flags &=3D ~ACB_F_IOP_INITED;=0A=
+	switch (acb->adapter_type) {=0A=
+	case ACB_ADAPTER_TYPE_A: {=0A=
+		if (acb->acb_flags & ACB_F_BUS_RESET) {=0A=
+			long timeout;=0A=
+			pr_err("arcmsr: there is an bus "=0A=
+			"reset eh proceeding.......\n");=0A=
+			timeout =3D wait_event_timeout(wait_q,=0A=
+			(acb->acb_flags & ACB_F_BUS_RESET)=0A=
+			=3D=3D 0, 220 * HZ);=0A=
+			if (timeout)=0A=
+				return SUCCESS;=0A=
+		}=0A=
+		acb->acb_flags |=3D ACB_F_BUS_RESET;=0A=
+		if (!arcmsr_iop_reset(acb)) {=0A=
+			struct MessageUnit_A __iomem *reg;=0A=
+			reg =3D acb->pmuA;=0A=
+			arcmsr_hardware_reset(acb);=0A=
+			acb->acb_flags &=3D ~ACB_F_IOP_INITED;=0A=
 sleep_again:=0A=
-				ssleep(ARCMSR_SLEEPTIME);=0A=
-				if ((readl(&reg->outbound_msgaddr1) & =
ARCMSR_OUTBOUND_MESG1_FIRMWARE_OK) =3D=3D 0) {=0A=
-					printk(KERN_ERR "arcmsr%d: waiting for hw bus reset return, =
retry=3D%d\n", acb->host->host_no, retry_count);=0A=
-					if (retry_count > ARCMSR_RETRYCOUNT) {=0A=
-						acb->fw_flag =3D FW_DEADLOCK;=0A=
-						printk(KERN_ERR "arcmsr%d: waiting for hw bus reset return, RETRY =
TERMINATED!!\n", acb->host->host_no);=0A=
-						return FAILED;=0A=
-					}=0A=
-					retry_count++;=0A=
-					goto sleep_again;=0A=
+			ssleep(ARCMSR_SLEEPTIME);=0A=
+			if ((readl(&reg->outbound_msgaddr1) &=0A=
+			ARCMSR_OUTBOUND_MESG1_FIRMWARE_OK) =3D=3D 0) {=0A=
+				pr_err("arcmsr%d: waiting for "=0A=
+				"hw bus reset return, retry =3D %d\n",=0A=
+				acb->host->host_no, retry_count);=0A=
+				if (retry_count > ARCMSR_RETRYCOUNT) {=0A=
+					acb->fw_flag =3D FW_DEADLOCK;=0A=
+					pr_err("arcmsr%d: waiting "=0A=
+					"for hw bus reset return, "=0A=
+					"RETRY TERMINATED!!\n",=0A=
+					acb->host->host_no);=0A=
+					return FAILED;=0A=
 				}=0A=
-				acb->acb_flags |=3D ACB_F_IOP_INITED;=0A=
-				/* disable all outbound interrupt */=0A=
-				intmask_org =3D arcmsr_disable_outbound_ints(acb);=0A=
-				arcmsr_get_firmware_spec(acb);=0A=
-				arcmsr_start_adapter_bgrb(acb);=0A=
-				/* clear Qbuffer if door bell ringed */=0A=
-				outbound_doorbell =3D readl(&reg->outbound_doorbell);=0A=
-				writel(outbound_doorbell, &reg->outbound_doorbell); /*clear =
interrupt */=0A=
-   				writel(ARCMSR_INBOUND_DRIVER_DATA_READ_OK, =
&reg->inbound_doorbell);=0A=
-				/* enable outbound Post Queue,outbound doorbell Interrupt */=0A=
-				arcmsr_enable_outbound_ints(acb, intmask_org);=0A=
-				atomic_set(&acb->rq_map_token, 16);=0A=
-				atomic_set(&acb->ante_token_value, 16);=0A=
-				acb->fw_flag =3D FW_NORMAL;=0A=
-				mod_timer(&acb->eternal_timer, jiffies + msecs_to_jiffies(6 * HZ));=0A=
-				acb->acb_flags &=3D ~ACB_F_BUS_RESET;=0A=
-				rtn =3D SUCCESS;=0A=
-				printk(KERN_ERR "arcmsr: scsi  bus reset eh returns with =
success\n");=0A=
-			} else {=0A=
-				acb->acb_flags &=3D ~ACB_F_BUS_RESET;=0A=
-				atomic_set(&acb->rq_map_token, 16);=0A=
-				atomic_set(&acb->ante_token_value, 16);=0A=
-				acb->fw_flag =3D FW_NORMAL;=0A=
-				mod_timer(&acb->eternal_timer, jiffies + msecs_to_jiffies(6*HZ));=0A=
-				rtn =3D SUCCESS;=0A=
+				retry_count++;=0A=
+				goto sleep_again;=0A=
 			}=0A=
-			break;=0A=
+			acb->acb_flags |=3D ACB_F_IOP_INITED;=0A=
+			/* disable all outbound interrupt */=0A=
+			intmask_org =3D arcmsr_disable_outbound_ints(acb);=0A=
+			arcmsr_get_firmware_spec(acb);=0A=
+			arcmsr_start_adapter_bgrb(acb);=0A=
+			/* clear Qbuffer if door bell ringed */=0A=
+			outbound_doorbell =3D readl(&reg->outbound_doorbell);=0A=
+			writel(outbound_doorbell, &reg->outbound_doorbell);=0A=
+			writel(ARCMSR_INBOUND_DRIVER_DATA_READ_OK,=0A=
+				&reg->inbound_doorbell);=0A=
+			arcmsr_enable_outbound_ints(acb, intmask_org);=0A=
+			atomic_set(&acb->rq_map_token, 16);=0A=
+			atomic_set(&acb->ante_token_value, 16);=0A=
+			acb->fw_flag =3D FW_NORMAL;=0A=
+			mod_timer(&acb->eternal_timer, jiffies +=0A=
+				msecs_to_jiffies(6 * HZ));=0A=
+			acb->acb_flags &=3D ~ACB_F_BUS_RESET;=0A=
+			rtn =3D SUCCESS;=0A=
+			pr_err("arcmsr: scsi bus reset eh "=0A=
+			"returns with success\n");=0A=
+		} else {=0A=
+			acb->acb_flags &=3D ~ACB_F_BUS_RESET;=0A=
+			atomic_set(&acb->rq_map_token, 16);=0A=
+			atomic_set(&acb->ante_token_value, 16);=0A=
+			acb->fw_flag =3D FW_NORMAL;=0A=
+			mod_timer(&acb->eternal_timer,=0A=
+			jiffies + msecs_to_jiffies(6 * HZ));=0A=
+			rtn =3D SUCCESS;=0A=
 		}=0A=
-		case ACB_ADAPTER_TYPE_B:{=0A=
-			acb->acb_flags |=3D ACB_F_BUS_RESET;=0A=
-			if (!arcmsr_iop_reset(acb)) {=0A=
-				acb->acb_flags &=3D ~ACB_F_BUS_RESET;=0A=
-				rtn =3D FAILED;=0A=
-			} else {=0A=
-				acb->acb_flags &=3D ~ACB_F_BUS_RESET;=0A=
-				atomic_set(&acb->rq_map_token, 16);=0A=
-				atomic_set(&acb->ante_token_value, 16);=0A=
-				acb->fw_flag =3D FW_NORMAL;=0A=
-				mod_timer(&acb->eternal_timer, jiffies + msecs_to_jiffies(6 * HZ));=0A=
-				rtn =3D SUCCESS;=0A=
-			}=0A=
-			break;=0A=
+		break;=0A=
+	}=0A=
+	case ACB_ADAPTER_TYPE_B: {=0A=
+		acb->acb_flags |=3D ACB_F_BUS_RESET;=0A=
+		if (!arcmsr_iop_reset(acb)) {=0A=
+			acb->acb_flags &=3D ~ACB_F_BUS_RESET;=0A=
+			rtn =3D FAILED;=0A=
+		} else {=0A=
+			acb->acb_flags &=3D ~ACB_F_BUS_RESET;=0A=
+			atomic_set(&acb->rq_map_token, 16);=0A=
+			atomic_set(&acb->ante_token_value, 16);=0A=
+			acb->fw_flag =3D FW_NORMAL;=0A=
+			mod_timer(&acb->eternal_timer,=0A=
+				jiffies + msecs_to_jiffies(6 * HZ));=0A=
+			rtn =3D SUCCESS;=0A=
 		}=0A=
-		case ACB_ADAPTER_TYPE_C:{=0A=
-			if (acb->acb_flags & ACB_F_BUS_RESET) {=0A=
-				long timeout;=0A=
-				printk(KERN_ERR "arcmsr: there is an bus reset eh =
proceeding.......\n");=0A=
-				timeout =3D wait_event_timeout(wait_q, (acb->acb_flags & =
ACB_F_BUS_RESET) =3D=3D 0, 220*HZ);=0A=
-				if (timeout) {=0A=
-					return SUCCESS;=0A=
+		break;=0A=
+	}=0A=
+	case ACB_ADAPTER_TYPE_C: {=0A=
+		if (acb->acb_flags & ACB_F_BUS_RESET) {=0A=
+			long timeout;=0A=
+			pr_err("arcmsr: there is an bus "=0A=
+			"reset eh proceeding.......\n");=0A=
+			timeout =3D wait_event_timeout(wait_q,=0A=
+			(acb->acb_flags & ACB_F_BUS_RESET) =3D=3D 0,=0A=
+			220 * HZ);=0A=
+			if (timeout)=0A=
+				return SUCCESS;=0A=
+		}=0A=
+		acb->acb_flags |=3D ACB_F_BUS_RESET;=0A=
+		if (!arcmsr_iop_reset(acb)) {=0A=
+			struct MessageUnit_C __iomem *reg;=0A=
+			reg =3D acb->pmuC;=0A=
+			arcmsr_hardware_reset(acb);=0A=
+			acb->acb_flags &=3D ~ACB_F_IOP_INITED;=0A=
+sleep:=0A=
+			ssleep(ARCMSR_SLEEPTIME);=0A=
+			if ((readl(&reg->host_diagnostic) & 0x04) !=3D 0) {=0A=
+				pr_err("arcmsr%d: waiting "=0A=
+				"for hw bus reset return, retry =3D %d\n",=0A=
+				acb->host->host_no, retry_count);=0A=
+				if (retry_count > ARCMSR_RETRYCOUNT) {=0A=
+					acb->fw_flag =3D FW_DEADLOCK;=0A=
+					pr_err("arcmsr%d: "=0A=
+					"waiting for hw bus reset return, "=0A=
+					"RETRY TERMINATED!!\n",=0A=
+					acb->host->host_no);=0A=
+					return FAILED;=0A=
 				}=0A=
+				retry_count++;=0A=
+				goto sleep;=0A=
 			}=0A=
-			acb->acb_flags |=3D ACB_F_BUS_RESET;=0A=
-			if (!arcmsr_iop_reset(acb)) {=0A=
-				struct MessageUnit_C __iomem *reg;=0A=
-				reg =3D acb->pmuC;=0A=
-				arcmsr_hardware_reset(acb);=0A=
-				acb->acb_flags &=3D ~ACB_F_IOP_INITED;=0A=
-sleep:=0A=
-				ssleep(ARCMSR_SLEEPTIME);=0A=
-				if ((readl(&reg->host_diagnostic) & 0x04) !=3D 0) {=0A=
-					printk(KERN_ERR "arcmsr%d: waiting for hw bus reset return, =
retry=3D%d\n", acb->host->host_no, retry_count);=0A=
-					if (retry_count > ARCMSR_RETRYCOUNT) {=0A=
-						acb->fw_flag =3D FW_DEADLOCK;=0A=
-						printk(KERN_ERR "arcmsr%d: waiting for hw bus reset return, RETRY =
TERMINATED!!\n", acb->host->host_no);=0A=
-						return FAILED;=0A=
-					}=0A=
-					retry_count++;=0A=
-					goto sleep;=0A=
+			acb->acb_flags |=3D ACB_F_IOP_INITED;=0A=
+			/* disable all outbound interrupt */=0A=
+			intmask_org =3D=0A=
+			arcmsr_disable_outbound_ints(acb);=0A=
+			arcmsr_get_firmware_spec(acb);=0A=
+			arcmsr_start_adapter_bgrb(acb);=0A=
+			/* clear Qbuffer if door bell ringed */=0A=
+			outbound_doorbell =3D=0A=
+			readl(&reg->outbound_doorbell);=0A=
+			writel(outbound_doorbell,=0A=
+				&reg->outbound_doorbell_clear);=0A=
+			writel(ARCMSR_HBCMU_DRV2IOP_DATA_READ_OK,=0A=
+				&reg->inbound_doorbell);=0A=
+			arcmsr_enable_outbound_ints(acb,=0A=
+				intmask_org);=0A=
+			atomic_set(&acb->rq_map_token, 16);=0A=
+			atomic_set(&acb->ante_token_value, 16);=0A=
+			acb->fw_flag =3D FW_NORMAL;=0A=
+			mod_timer(&acb->eternal_timer, jiffies +=0A=
+				msecs_to_jiffies(6 * HZ));=0A=
+			acb->acb_flags &=3D ~ACB_F_BUS_RESET;=0A=
+			rtn =3D SUCCESS;=0A=
+			pr_err("arcmsr: scsi bus reset "=0A=
+			"eh returns with success\n");=0A=
+		} else {=0A=
+			acb->acb_flags &=3D ~ACB_F_BUS_RESET;=0A=
+			atomic_set(&acb->rq_map_token, 16);=0A=
+			atomic_set(&acb->ante_token_value, 16);=0A=
+			acb->fw_flag =3D FW_NORMAL;=0A=
+			mod_timer(&acb->eternal_timer, jiffies +=0A=
+			msecs_to_jiffies(6 * HZ));=0A=
+			rtn =3D SUCCESS;=0A=
+		}=0A=
+		break;=0A=
+	}=0A=
+	case ACB_ADAPTER_TYPE_D: {=0A=
+		if (acb->acb_flags & ACB_F_BUS_RESET) {=0A=
+			long timeout;=0A=
+			pr_notice("arcmsr: there is an bus reset eh proceeding.......\n");=0A=
+			timeout =3D wait_event_timeout(wait_q, (acb->acb_flags=0A=
+				& ACB_F_BUS_RESET) =3D=3D 0, 220 * HZ);=0A=
+			if (timeout)=0A=
+				return SUCCESS;=0A=
+		}=0A=
+		acb->acb_flags |=3D ACB_F_BUS_RESET;=0A=
+		if (!arcmsr_iop_reset(acb)) {=0A=
+			struct MessageUnit_D __iomem *reg;=0A=
+			reg =3D acb->pmuD;=0A=
+			arcmsr_hardware_reset(acb);=0A=
+			acb->acb_flags &=3D ~ACB_F_IOP_INITED;=0A=
+			nap:=0A=
+			ssleep(ARCMSR_SLEEPTIME);=0A=
+			if ((readl(reg->sample_at_reset) & 0x80) !=3D 0) {=0A=
+				pr_err("arcmsr%d: waiting for "=0A=
+				"hw bus reset return, retry=3D%d\n",=0A=
+				acb->host->host_no, retry_count);=0A=
+				if (retry_count > ARCMSR_RETRYCOUNT) {=0A=
+					acb->fw_flag =3D FW_DEADLOCK;=0A=
+					pr_err("arcmsr%d: "=0A=
+					"waiting for hw bus reset return, "=0A=
+					"RETRY TERMINATED!!\n",=0A=
+					acb->host->host_no);=0A=
+					return FAILED;=0A=
 				}=0A=
-				acb->acb_flags |=3D ACB_F_IOP_INITED;=0A=
-				/* disable all outbound interrupt */=0A=
-				intmask_org =3D arcmsr_disable_outbound_ints(acb);=0A=
-				arcmsr_get_firmware_spec(acb);=0A=
-				arcmsr_start_adapter_bgrb(acb);=0A=
-				/* clear Qbuffer if door bell ringed */=0A=
-				outbound_doorbell =3D readl(&reg->outbound_doorbell);=0A=
-				writel(outbound_doorbell, &reg->outbound_doorbell_clear); /*clear =
interrupt */=0A=
-				writel(ARCMSR_HBCMU_DRV2IOP_DATA_READ_OK, &reg->inbound_doorbell);=0A=
-				/* enable outbound Post Queue,outbound doorbell Interrupt */=0A=
-				arcmsr_enable_outbound_ints(acb, intmask_org);=0A=
-				atomic_set(&acb->rq_map_token, 16);=0A=
-				atomic_set(&acb->ante_token_value, 16);=0A=
-				acb->fw_flag =3D FW_NORMAL;=0A=
-				mod_timer(&acb->eternal_timer, jiffies + msecs_to_jiffies(6 * HZ));=0A=
-				acb->acb_flags &=3D ~ACB_F_BUS_RESET;=0A=
-				rtn =3D SUCCESS;=0A=
-				printk(KERN_ERR "arcmsr: scsi bus reset eh returns with success\n");=0A=
-			} else {=0A=
-				acb->acb_flags &=3D ~ACB_F_BUS_RESET;=0A=
-				atomic_set(&acb->rq_map_token, 16);=0A=
-				atomic_set(&acb->ante_token_value, 16);=0A=
-				acb->fw_flag =3D FW_NORMAL;=0A=
-				mod_timer(&acb->eternal_timer, jiffies + msecs_to_jiffies(6*HZ));=0A=
-				rtn =3D SUCCESS;=0A=
+				retry_count++;=0A=
+				goto nap;=0A=
 			}=0A=
-			break;=0A=
+			acb->acb_flags |=3D ACB_F_IOP_INITED;=0A=
+			/* disable all outbound interrupt */=0A=
+			intmask_org =3D arcmsr_disable_outbound_ints(acb);=0A=
+			arcmsr_get_firmware_spec(acb);=0A=
+			arcmsr_start_adapter_bgrb(acb);=0A=
+			arcmsr_clear_doorbell_queue_buffer(acb);=0A=
+			arcmsr_enable_outbound_ints(acb, intmask_org);=0A=
+			atomic_set(&acb->rq_map_token, 16);=0A=
+			atomic_set(&acb->ante_token_value, 16);=0A=
+			acb->fw_flag =3D FW_NORMAL;=0A=
+			mod_timer(&acb->eternal_timer,=0A=
+				jiffies + msecs_to_jiffies(6 * HZ));=0A=
+			acb->acb_flags &=3D ~ACB_F_BUS_RESET;=0A=
+			rtn =3D SUCCESS;=0A=
+			pr_err("arcmsr: scsi bus reset "=0A=
+			"eh returns with success\n");=0A=
+		} else {=0A=
+			acb->acb_flags &=3D ~ACB_F_BUS_RESET;=0A=
+			atomic_set(&acb->rq_map_token, 16);=0A=
+			atomic_set(&acb->ante_token_value, 16);=0A=
+			acb->fw_flag =3D FW_NORMAL;=0A=
+			mod_timer(&acb->eternal_timer,=0A=
+				jiffies + msecs_to_jiffies(6 * HZ));=0A=
+			rtn =3D SUCCESS;=0A=
 		}=0A=
+		break;=0A=
+	}=0A=
 	}=0A=
 	return rtn;=0A=
 }=0A=
 =0A=
-static int arcmsr_abort_one_cmd(struct AdapterControlBlock *acb,=0A=
+static int=0A=
+arcmsr_abort_one_cmd(struct AdapterControlBlock *acb,=0A=
 		struct CommandControlBlock *ccb)=0A=
 {=0A=
 	int rtn;=0A=
@@ -3051,15 +4532,17 @@ static int arcmsr_abort_one_cmd(struct A=0A=
 	return rtn;=0A=
 }=0A=
 =0A=
-static int arcmsr_abort(struct scsi_cmnd *cmd)=0A=
+static int=0A=
+arcmsr_abort(struct scsi_cmnd *cmd)=0A=
 {=0A=
-	struct AdapterControlBlock *acb =3D=0A=
-		(struct AdapterControlBlock *)cmd->device->host->hostdata;=0A=
+	struct AdapterControlBlock *acb =3D (struct AdapterControlBlock *)=0A=
+		cmd->device->host->hostdata;=0A=
 	int i =3D 0;=0A=
 	int rtn =3D FAILED;=0A=
-	printk(KERN_NOTICE=0A=
-		"arcmsr%d: abort device command of scsi id =3D %d lun =3D %d \n",=0A=
-		acb->host->host_no, cmd->device->id, cmd->device->lun);=0A=
+	pr_notice("arcmsr%d: abort device command of "=0A=
+		"scsi id =3D %d lun =3D %d\n",=0A=
+		acb->host->host_no,=0A=
+		cmd->device->id, cmd->device->lun);=0A=
 	acb->acb_flags |=3D ACB_F_ABORT;=0A=
 	acb->num_aborts++;=0A=
 	/*=0A=
@@ -3073,7 +4556,8 @@ static int arcmsr_abort(struct scsi_cmnd=0A=
 =0A=
 	for (i =3D 0; i < ARCMSR_MAX_FREECCB_NUM; i++) {=0A=
 		struct CommandControlBlock *ccb =3D acb->pccb_pool[i];=0A=
-		if (ccb->startdone =3D=3D ARCMSR_CCB_START && ccb->pcmd =3D=3D cmd) {=0A=
+		if (ccb->startdone =3D=3D ARCMSR_CCB_START &&=0A=
+			ccb->pcmd =3D=3D cmd) {=0A=
 			ccb->startdone =3D ARCMSR_CCB_ABORTED;=0A=
 			rtn =3D arcmsr_abort_one_cmd(acb, ccb);=0A=
 			break;=0A=
@@ -3083,10 +4567,11 @@ static int arcmsr_abort(struct scsi_cmnd=0A=
 	return rtn;=0A=
 }=0A=
 =0A=
-static const char *arcmsr_info(struct Scsi_Host *host)=0A=
+static const char=0A=
+*arcmsr_info(struct Scsi_Host *host)=0A=
 {=0A=
 	struct AdapterControlBlock *acb =3D=0A=
-		(struct AdapterControlBlock *) host->hostdata;=0A=
+	(struct AdapterControlBlock *)host->hostdata;=0A=
 	static char buf[256];=0A=
 	char *type;=0A=
 	int raid6 =3D 1;=0A=
@@ -3102,6 +4587,7 @@ static const char *arcmsr_info(struct Sc=0A=
 	case PCI_DEVICE_ID_ARECA_1160:=0A=
 	case PCI_DEVICE_ID_ARECA_1170:=0A=
 	case PCI_DEVICE_ID_ARECA_1201:=0A=
+	case PCI_DEVICE_ID_ARECA_1214:=0A=
 	case PCI_DEVICE_ID_ARECA_1220:=0A=
 	case PCI_DEVICE_ID_ARECA_1230:=0A=
 	case PCI_DEVICE_ID_ARECA_1260:=0A=
@@ -3109,19 +4595,19 @@ static const char *arcmsr_info(struct Sc=0A=
 	case PCI_DEVICE_ID_ARECA_1280:=0A=
 		type =3D "SATA";=0A=
 		break;=0A=
-	case PCI_DEVICE_ID_ARECA_1380:=0A=
-	case PCI_DEVICE_ID_ARECA_1381:=0A=
 	case PCI_DEVICE_ID_ARECA_1680:=0A=
 	case PCI_DEVICE_ID_ARECA_1681:=0A=
 	case PCI_DEVICE_ID_ARECA_1880:=0A=
 		type =3D "SAS";=0A=
 		break;=0A=
 	default:=0A=
-		type =3D "X-TYPE";=0A=
+		type =3D "unknown";=0A=
+		raid6 =3D	0;=0A=
 		break;=0A=
 	}=0A=
-	sprintf(buf, "Areca %s Host Adapter RAID Controller%s\n %s",=0A=
-			type, raid6 ? "( RAID6 capable)" : "",=0A=
-			ARCMSR_DRIVER_VERSION);=0A=
+	sprintf(buf, "Areca %s Host Adapter RAID Controller%s\narcmsr version =
%s\n",=0A=
+		type, raid6 ? "( RAID6 capable)" : "", ARCMSR_DRIVER_VERSION);=0A=
+		=0A=
 	return buf;=0A=
 }=0A=
+=0A=

------=_NextPart_000_002C_01CEA425.E40A7980--

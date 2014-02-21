From: =?UTF-8?B?6buD5riF6ZqG?= <ching2048@areca.com.tw>
Subject: [PATCH v1.3 8/11] arcmsr: Modify ioctl relate functions to fix update
 firmware error
Date: Fri, 21 Feb 2014 12:25:09 +0800
Message-ID: <CAKiknE_oQPDS+vVjKxH5++GauJHd4q9BJ=u0q3PM0yxaQhB3BQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jbottomley@parallels.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>
Cc: fengguang.wu@intel.com, Tomas Henzl <thenzl@redhat.com>
List-Id: linux-scsi@vger.kernel.org

From: Ching <ching2048@areca.com.tw>

Modify ioctl relate functions to fix update firmware error.

Singed-off-by: Ching <ching2048@areca.com.tw>
---

diff -uprN a/drivers/scsi/arcmsr/arcmsr_attr.c
b/drivers/scsi/arcmsr/arcmsr_attr.c
--- a/drivers/scsi/arcmsr/arcmsr_attr.c 2014-01-10 20:28:48.000000000 +0800
+++ b/drivers/scsi/arcmsr/arcmsr_attr.c 2014-01-15 23:41:36.000000000 +0800
@@ -59,64 +59,104 @@

 struct device_attribute *arcmsr_host_attrs[];

-static ssize_t arcmsr_sysfs_iop_message_read(struct file *filp,
-                                            struct kobject *kobj,
-                                            struct bin_attribute *bin,
-                                            char *buf, loff_t off,
-                                            size_t count)
+static ssize_t
+arcmsr_sysfs_iop_message_read(struct file *filp,
+                               struct kobject *kobj,
+                               struct bin_attribute *bin,
+                               char *buf, loff_t off,
+                               size_t count)
 {
-       struct device *dev = container_of(kobj,struct device,kobj);
+       struct device *dev = container_of(kobj, struct device, kobj);
        struct Scsi_Host *host = class_to_shost(dev);
-       struct AdapterControlBlock *acb = (struct AdapterControlBlock
*) host->hostdata;
+       struct AdapterControlBlock *acb =
+               (struct AdapterControlBlock *)host->hostdata;
        uint8_t *pQbuffer,*ptmpQbuffer;
        int32_t allxfer_len = 0;
+       unsigned long flags;

        if (!capable(CAP_SYS_ADMIN))
                return -EACCES;

        /* do message unit read. */
        ptmpQbuffer = (uint8_t *)buf;
-       while ((acb->rqbuf_firstindex != acb->rqbuf_lastindex)
-               && (allxfer_len < 1031)) {
+       spin_lock_irqsave(&acb->rqbuffer_lock, flags);
+       if (acb->rqbuf_firstindex != acb->rqbuf_lastindex) {
                pQbuffer = &acb->rqbuffer[acb->rqbuf_firstindex];
-               memcpy(ptmpQbuffer, pQbuffer, 1);
-               acb->rqbuf_firstindex++;
-               acb->rqbuf_firstindex %= ARCMSR_MAX_QBUFFER;
-               ptmpQbuffer++;
-               allxfer_len++;
+               if (acb->rqbuf_firstindex > acb->rqbuf_lastindex) {
+                       if ((ARCMSR_MAX_QBUFFER -
acb->rqbuf_firstindex) >= 1032) {
+                               memcpy(ptmpQbuffer, pQbuffer, 1032);
+                               acb->rqbuf_firstindex += 1032;
+                               acb->rqbuf_firstindex %= ARCMSR_MAX_QBUFFER;
+                               allxfer_len = 1032;
+                       } else {
+                               if (((ARCMSR_MAX_QBUFFER -
acb->rqbuf_firstindex)
+                                       + acb->rqbuf_lastindex) > 1032) {
+                                       memcpy(ptmpQbuffer, pQbuffer,
+                                               ARCMSR_MAX_QBUFFER
+                                               - acb->rqbuf_firstindex);
+                                       ptmpQbuffer += ARCMSR_MAX_QBUFFER
+                                               - acb->rqbuf_firstindex;
+                                       memcpy(ptmpQbuffer, acb->rqbuffer, 1032
+                                               - (ARCMSR_MAX_QBUFFER -
+                                               acb->rqbuf_firstindex));
+                                       acb->rqbuf_firstindex = 1032 -
+                                               (ARCMSR_MAX_QBUFFER -
+                                               acb->rqbuf_firstindex);
+                                       allxfer_len = 1032;
+                               } else {
+                                       memcpy(ptmpQbuffer, pQbuffer,
+                                               ARCMSR_MAX_QBUFFER -
+                                               acb->rqbuf_firstindex);
+                                       ptmpQbuffer += ARCMSR_MAX_QBUFFER -
+                                               acb->rqbuf_firstindex;
+                                       memcpy(ptmpQbuffer, acb->rqbuffer,
+                                               acb->rqbuf_lastindex);
+                                       allxfer_len = ARCMSR_MAX_QBUFFER -
+                                               acb->rqbuf_firstindex +
+                                               acb->rqbuf_lastindex;
+                                       acb->rqbuf_firstindex =
+                                               acb->rqbuf_lastindex;
+                               }
+                       }
+               } else {
+                       if ((acb->rqbuf_lastindex -
acb->rqbuf_firstindex) > 1032) {
+                               memcpy(ptmpQbuffer, pQbuffer, 1032);
+                               acb->rqbuf_firstindex += 1032;
+                               allxfer_len = 1032;
+                       } else {
+                               memcpy(ptmpQbuffer, pQbuffer,
acb->rqbuf_lastindex
+                                       - acb->rqbuf_firstindex);
+                               allxfer_len = acb->rqbuf_lastindex -
+                                       acb->rqbuf_firstindex;
+                               acb->rqbuf_firstindex = acb->rqbuf_lastindex;
+                       }
+               }
        }
        if (acb->acb_flags & ACB_F_IOPDATA_OVERFLOW) {
                struct QBUFFER __iomem *prbuffer;
-               uint8_t __iomem *iop_data;
-               int32_t iop_len;
-
                acb->acb_flags &= ~ACB_F_IOPDATA_OVERFLOW;
                prbuffer = arcmsr_get_iop_rqbuffer(acb);
-               iop_data = prbuffer->data;
-               iop_len = readl(&prbuffer->data_len);
-               while (iop_len > 0) {
-                       acb->rqbuffer[acb->rqbuf_lastindex] = readb(iop_data);
-                       acb->rqbuf_lastindex++;
-                       acb->rqbuf_lastindex %= ARCMSR_MAX_QBUFFER;
-                       iop_data++;
-                       iop_len--;
-               }
-               arcmsr_iop_message_read(acb);
+               if (arcmsr_Read_iop_rqbuffer_data(acb, prbuffer) == 0)
+                       acb->acb_flags |= ACB_F_IOPDATA_OVERFLOW;
        }
-       return (allxfer_len);
+       spin_unlock_irqrestore(&acb->rqbuffer_lock, flags);
+       return allxfer_len;
 }

-static ssize_t arcmsr_sysfs_iop_message_write(struct file *filp,
-                                             struct kobject *kobj,
-                                             struct bin_attribute *bin,
-                                             char *buf, loff_t off,
-                                             size_t count)
+static ssize_t
+arcmsr_sysfs_iop_message_write(struct file *filp,
+                                     struct kobject *kobj,
+                                     struct bin_attribute *bin,
+                                     char *buf, loff_t off,
+                                     size_t count)
 {
-       struct device *dev = container_of(kobj,struct device,kobj);
+       struct device *dev = container_of(kobj, struct device, kobj);
        struct Scsi_Host *host = class_to_shost(dev);
-       struct AdapterControlBlock *acb = (struct AdapterControlBlock
*) host->hostdata;
+       struct AdapterControlBlock *acb =
+               (struct AdapterControlBlock *)host->hostdata;
        int32_t my_empty_len, user_len, wqbuf_firstindex, wqbuf_lastindex;
        uint8_t *pQbuffer, *ptmpuserbuffer;
+       unsigned long flags;

        if (!capable(CAP_SYS_ADMIN))
                return -EACCES;
@@ -125,18 +165,19 @@ static ssize_t arcmsr_sysfs_iop_message_
        /* do message unit write. */
        ptmpuserbuffer = (uint8_t *)buf;
        user_len = (int32_t)count;
+       spin_lock_irqsave(&acb->wqbuffer_lock, flags);
        wqbuf_lastindex = acb->wqbuf_lastindex;
        wqbuf_firstindex = acb->wqbuf_firstindex;
        if (wqbuf_lastindex != wqbuf_firstindex) {
-               arcmsr_post_ioctldata2iop(acb);
+               arcmsr_write_ioctldata2iop(acb);
+               spin_unlock_irqrestore(&acb->wqbuffer_lock, flags);
                return 0;       /*need retry*/
        } else {
                my_empty_len = (wqbuf_firstindex-wqbuf_lastindex - 1)
-                               &(ARCMSR_MAX_QBUFFER - 1);
+                       &(ARCMSR_MAX_QBUFFER - 1);
                if (my_empty_len >= user_len) {
                        while (user_len > 0) {
-                               pQbuffer =
-                               &acb->wqbuffer[acb->wqbuf_lastindex];
+                               pQbuffer = &acb->wqbuffer[acb->wqbuf_lastindex];
                                memcpy(pQbuffer, ptmpuserbuffer, 1);
                                acb->wqbuf_lastindex++;
                                acb->wqbuf_lastindex %= ARCMSR_MAX_QBUFFER;
@@ -146,41 +187,47 @@ static ssize_t arcmsr_sysfs_iop_message_
                        if (acb->acb_flags & ACB_F_MESSAGE_WQBUFFER_CLEARED) {
                                acb->acb_flags &=
                                        ~ACB_F_MESSAGE_WQBUFFER_CLEARED;
-                               arcmsr_post_ioctldata2iop(acb);
+                               arcmsr_write_ioctldata2iop(acb);
                        }
+                       spin_unlock_irqrestore(&acb->wqbuffer_lock, flags);
                        return count;
                } else {
+                       spin_unlock_irqrestore(&acb->wqbuffer_lock, flags);
                        return 0;       /*need retry*/
                }
        }
 }

-static ssize_t arcmsr_sysfs_iop_message_clear(struct file *filp,
-                                             struct kobject *kobj,
-                                             struct bin_attribute *bin,
-                                             char *buf, loff_t off,
-                                             size_t count)
+static ssize_t
+arcmsr_sysfs_iop_message_clear(struct file *filp,
+                                     struct kobject *kobj,
+                                     struct bin_attribute *bin,
+                                     char *buf, loff_t off,
+                                     size_t count)
 {
-       struct device *dev = container_of(kobj,struct device,kobj);
+       struct device *dev = container_of(kobj, struct device, kobj);
        struct Scsi_Host *host = class_to_shost(dev);
-       struct AdapterControlBlock *acb = (struct AdapterControlBlock
*) host->hostdata;
+       struct AdapterControlBlock *acb =
+               (struct AdapterControlBlock *)host->hostdata;
        uint8_t *pQbuffer;
+       unsigned long flags;

        if (!capable(CAP_SYS_ADMIN))
                return -EACCES;

-       if (acb->acb_flags & ACB_F_IOPDATA_OVERFLOW) {
-               acb->acb_flags &= ~ACB_F_IOPDATA_OVERFLOW;
-               arcmsr_iop_message_read(acb);
-       }
+       arcmsr_clear_iop2drv_rqueue_buffer(acb);
        acb->acb_flags |=
                (ACB_F_MESSAGE_WQBUFFER_CLEARED
                | ACB_F_MESSAGE_RQBUFFER_CLEARED
                | ACB_F_MESSAGE_WQBUFFER_READED);
+       spin_lock_irqsave(&acb->rqbuffer_lock, flags);
        acb->rqbuf_firstindex = 0;
        acb->rqbuf_lastindex = 0;
+       spin_unlock_irqrestore(&acb->rqbuffer_lock, flags);
+       spin_lock_irqsave(&acb->wqbuffer_lock, flags);
        acb->wqbuf_firstindex = 0;
        acb->wqbuf_lastindex = 0;
+       spin_unlock_irqrestore(&acb->wqbuffer_lock, flags);
        pQbuffer = acb->rqbuffer;
        memset(pQbuffer, 0, sizeof (struct QBUFFER));
        pQbuffer = acb->wqbuffer;
diff -uprN a/drivers/scsi/arcmsr/arcmsr.h b/drivers/scsi/arcmsr/arcmsr.h
--- a/drivers/scsi/arcmsr/arcmsr.h      2014-01-14 23:28:28.000000000 +0800
+++ b/drivers/scsi/arcmsr/arcmsr.h      2014-02-18 01:30:16.000000000 +0800
@@ -514,18 +514,20 @@ struct AdapterControlBlock
        uint32_t                        outbound_int_enable;
        uint32_t                        cdb_phyaddr_hi32;
        uint32_t                        reg_mu_acc_handle0;
-       spinlock_t                                              eh_lock;
-       spinlock_t                                              ccblist_lock;
+       spinlock_t                      eh_lock;
+       spinlock_t                      ccblist_lock;
+       spinlock_t                      rqbuffer_lock;
+       spinlock_t                      wqbuffer_lock;
        union {
                struct MessageUnit_A __iomem *pmuA;
-               struct MessageUnit_B    *pmuB;
+               struct MessageUnit_B    *pmuB;
                struct MessageUnit_C __iomem *pmuC;
        };
        /* message unit ATU inbound base address0 */
-       void __iomem *mem_base0;
-       void __iomem *mem_base1;
-       uint32_t                        acb_flags;
-       u16                     dev_id;
+       void __iomem    *mem_base0;
+       void __iomem    *mem_base1;
+       uint32_t        acb_flags;
+       u16             dev_id;
        uint8_t                                 adapter_index;
        #define ACB_F_SCSISTOPADAPTER           0x0001
        #define ACB_F_MSG_STOP_BGRB             0x0002
@@ -689,8 +691,10 @@ struct SENSE_DATA
 #define     ARCMSR_MU_OUTBOUND_MESSAGE0_INTMASKENABLE               0x01
 #define     ARCMSR_MU_OUTBOUND_ALL_INTMASKENABLE                    0x1F

-extern void arcmsr_post_ioctldata2iop(struct AdapterControlBlock *);
-extern void arcmsr_iop_message_read(struct AdapterControlBlock *);
+extern void arcmsr_write_ioctldata2iop(struct AdapterControlBlock *);
+extern uint32_t arcmsr_Read_iop_rqbuffer_data(struct AdapterControlBlock *,
+       struct QBUFFER __iomem *);
+extern void arcmsr_clear_iop2drv_rqueue_buffer(struct AdapterControlBlock *);
 extern struct QBUFFER __iomem *arcmsr_get_iop_rqbuffer(struct
AdapterControlBlock *);
 extern struct device_attribute *arcmsr_host_attrs[];
 extern int arcmsr_alloc_sysfs_attr(struct AdapterControlBlock *);
diff -uprN a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
--- a/drivers/scsi/arcmsr/arcmsr_hba.c  2014-02-21 02:04:10.000000000 +0800
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c  2014-02-21 02:04:50.000000000 +0800
@@ -294,24 +294,44 @@ static int arcmsr_bios_param(struct scsi
        return 0;
 }

-static void arcmsr_define_adapter_type(struct AdapterControlBlock *acb)
+static bool
+arcmsr_define_adapter_type(struct AdapterControlBlock *acb)
 {
        struct pci_dev *pdev = acb->pdev;
        u16 dev_id;
+
        pci_read_config_word(pdev, PCI_DEVICE_ID, &dev_id);
        acb->dev_id = dev_id;
        switch (dev_id) {
-       case 0x1880: {
+       case 0x1880:
                acb->adapter_type = ACB_ADAPTER_TYPE_C;
-               }
                break;
-       case 0x1201: {
+       case 0x1200:
+       case 0x1201:
+       case 0x1202:
                acb->adapter_type = ACB_ADAPTER_TYPE_B;
-               }
                break;
-
-       default: acb->adapter_type = ACB_ADAPTER_TYPE_A;
+       case 0x1110:
+       case 0x1120:
+       case 0x1130:
+       case 0x1160:
+       case 0x1170:
+       case 0x1210:
+       case 0x1220:
+       case 0x1230:
+       case 0x1260:
+       case 0x1270:
+       case 0x1280:
+       case 0x1380:
+       case 0x1381:
+       case 0x1680:
+               acb->adapter_type = ACB_ADAPTER_TYPE_A;
+               break;
+       default:
+               pr_notice("Unknown device ID = 0x%x\n", dev_id);
+               return false;
        }
+       return true;
 }

 static uint8_t arcmsr_hbaA_wait_msgint_ready(struct AdapterControlBlock *acb)
@@ -714,12 +734,16 @@ static int arcmsr_probe(struct pci_dev *
                goto scsi_host_release;
        spin_lock_init(&acb->eh_lock);
        spin_lock_init(&acb->ccblist_lock);
+       spin_lock_init(&acb->rqbuffer_lock);
+       spin_lock_init(&acb->wqbuffer_lock);
        acb->acb_flags |= (ACB_F_MESSAGE_WQBUFFER_CLEARED |
                        ACB_F_MESSAGE_RQBUFFER_CLEARED |
                        ACB_F_MESSAGE_WQBUFFER_READED);
        acb->acb_flags &= ~ACB_F_SCSISTOPADAPTER;
        INIT_LIST_HEAD(&acb->ccb_free_list);
-       arcmsr_define_adapter_type(acb);
+       error = arcmsr_define_adapter_type(acb);
+       if (!error)
+               goto pci_release_regs;
        error = arcmsr_remap_pciregion(acb);
        if (!error)
                goto pci_release_regs;
@@ -1488,68 +1512,177 @@ static struct QBUFFER __iomem *arcmsr_ge
        return pqbuffer;
 }

-static void arcmsr_iop2drv_data_wrote_handle(struct AdapterControlBlock *acb)
-{
-       struct QBUFFER __iomem *prbuffer;
-       struct QBUFFER *pQbuffer;
-       uint8_t __iomem *iop_data;
-       int32_t my_empty_len, iop_len, rqbuf_firstindex, rqbuf_lastindex;
-       rqbuf_lastindex = acb->rqbuf_lastindex;
-       rqbuf_firstindex = acb->rqbuf_firstindex;
-       prbuffer = arcmsr_get_iop_rqbuffer(acb);
-       iop_data = (uint8_t __iomem *)prbuffer->data;
-       iop_len = prbuffer->data_len;
-       my_empty_len = (rqbuf_firstindex - rqbuf_lastindex - 1) &
(ARCMSR_MAX_QBUFFER - 1);
+static uint32_t
+arcmsr_Read_iop_rqbuffer_in_DWORD(struct AdapterControlBlock *acb,
+       struct QBUFFER __iomem *prbuffer) {

-       if (my_empty_len >= iop_len)
-       {
-               while (iop_len > 0) {
-                       pQbuffer = (struct QBUFFER
*)&acb->rqbuffer[rqbuf_lastindex];
-                       memcpy(pQbuffer, iop_data, 1);
-                       rqbuf_lastindex++;
-                       rqbuf_lastindex %= ARCMSR_MAX_QBUFFER;
+       uint8_t *pQbuffer;
+       uint8_t *buf1 = NULL;
+       uint32_t __iomem *iop_data;
+       uint32_t iop_len, data_len, *buf2 = NULL;
+
+       iop_data = (uint32_t __iomem *)prbuffer->data;
+       iop_len = readl(&prbuffer->data_len);
+       if (iop_len > 0) {
+               buf1 = kmalloc(128, GFP_ATOMIC);
+               buf2 = (uint32_t *)buf1;
+               if (buf1 == NULL)
+                       return 0;
+               data_len = iop_len;
+               while (data_len >= 4) {
+                       *buf2++ = readl(iop_data);
                        iop_data++;
-                       iop_len--;
+                       data_len -= 4;
                }
-               acb->rqbuf_lastindex = rqbuf_lastindex;
-               arcmsr_iop_message_read(acb);
+               if (data_len)
+                       *buf2 = readl(iop_data);
+               buf2 = (uint32_t *)buf1;
+       }
+       while (iop_len > 0) {
+               pQbuffer = &acb->rqbuffer[acb->rqbuf_lastindex];
+               *pQbuffer = *buf1;
+               acb->rqbuf_lastindex++;
+               /* if last, index number set it to 0 */
+               acb->rqbuf_lastindex %= ARCMSR_MAX_QBUFFER;
+               buf1++;
+               iop_len--;
+       }
+       if (buf2)
+               kfree(buf2);
+       /* let IOP know data has been read */
+       arcmsr_iop_message_read(acb);
+       return 1;
+}
+
+uint32_t
+arcmsr_Read_iop_rqbuffer_data(struct AdapterControlBlock *acb,
+       struct QBUFFER __iomem *prbuffer) {
+
+       uint8_t *pQbuffer;
+       uint8_t __iomem *iop_data;
+       uint32_t iop_len;
+
+       if (acb->adapter_type & ACB_ADAPTER_TYPE_C)
+               return arcmsr_Read_iop_rqbuffer_in_DWORD(acb, prbuffer);
+       iop_data = (uint8_t __iomem *)prbuffer->data;
+       iop_len = readl(&prbuffer->data_len);
+       while (iop_len > 0) {
+               pQbuffer = &acb->rqbuffer[acb->rqbuf_lastindex];
+               *pQbuffer = readb(iop_data);
+               acb->rqbuf_lastindex++;
+               acb->rqbuf_lastindex %= ARCMSR_MAX_QBUFFER;
+               iop_data++;
+               iop_len--;
        }
+       arcmsr_iop_message_read(acb);
+       return 1;
+}

-       else {
+static void arcmsr_iop2drv_data_wrote_handle(struct AdapterControlBlock *acb)
+{
+       unsigned long flags;
+       struct QBUFFER __iomem  *prbuffer;
+       int32_t buf_empty_len;
+
+       spin_lock_irqsave(&acb->rqbuffer_lock, flags);
+       prbuffer = arcmsr_get_iop_rqbuffer(acb);
+       buf_empty_len = (acb->rqbuf_lastindex - acb->rqbuf_firstindex - 1) &
+               (ARCMSR_MAX_QBUFFER - 1);
+       if (buf_empty_len >= readl(&prbuffer->data_len)) {
+               if (arcmsr_Read_iop_rqbuffer_data(acb, prbuffer) == 0)
+                       acb->acb_flags |= ACB_F_IOPDATA_OVERFLOW;
+       } else
                acb->acb_flags |= ACB_F_IOPDATA_OVERFLOW;
+       spin_unlock_irqrestore(&acb->rqbuffer_lock, flags);
+}
+
+static void
+arcmsr_write_ioctldata2iop_in_DWORD(struct AdapterControlBlock *acb)
+{
+       uint8_t *pQbuffer;
+       struct QBUFFER __iomem *pwbuffer;
+       uint8_t *buf1 = NULL;
+       uint32_t __iomem *iop_data;
+       uint32_t allxfer_len = 0, data_len, *buf2 = NULL, data;
+
+       if (acb->acb_flags & ACB_F_MESSAGE_WQBUFFER_READED) {
+               buf1 = kmalloc(128, GFP_ATOMIC);
+               buf2 = (uint32_t *)buf1;
+               if (buf1 == NULL)
+                       return;
+
+               acb->acb_flags &= (~ACB_F_MESSAGE_WQBUFFER_READED);
+               pwbuffer = arcmsr_get_iop_wqbuffer(acb);
+               iop_data = (uint32_t __iomem *)pwbuffer->data;
+               while ((acb->wqbuf_firstindex != acb->wqbuf_lastindex)
+                       && (allxfer_len < 124)) {
+                       pQbuffer = &acb->wqbuffer[acb->wqbuf_firstindex];
+                       *buf1 = *pQbuffer;
+                       acb->wqbuf_firstindex++;
+                       acb->wqbuf_firstindex %= ARCMSR_MAX_QBUFFER;
+                       buf1++;
+                       allxfer_len++;
+               }
+               data_len = allxfer_len;
+               buf1 = (uint8_t *)buf2;
+               while (data_len >= 4) {
+                       data = *buf2++;
+                       writel(data, iop_data);
+                       iop_data++;
+                       data_len -= 4;
+               }
+               if (data_len) {
+                       data = *buf2;
+                       writel(data, iop_data);
+               }
+               writel(allxfer_len, &pwbuffer->data_len);
+               kfree(buf1);
+               arcmsr_iop_message_wrote(acb);
        }
 }

-static void arcmsr_iop2drv_data_read_handle(struct AdapterControlBlock *acb)
+void
+arcmsr_write_ioctldata2iop(struct AdapterControlBlock *acb)
 {
-       acb->acb_flags |= ACB_F_MESSAGE_WQBUFFER_READED;
-       if (acb->wqbuf_firstindex != acb->wqbuf_lastindex) {
-               uint8_t *pQbuffer;
-               struct QBUFFER __iomem *pwbuffer;
-               uint8_t __iomem *iop_data;
-               int32_t allxfer_len = 0;
+       uint8_t *pQbuffer;
+       struct QBUFFER __iomem *pwbuffer;
+       uint8_t __iomem *iop_data;
+       int32_t allxfer_len = 0;

+       if (acb->adapter_type & ACB_ADAPTER_TYPE_C) {
+               arcmsr_write_ioctldata2iop_in_DWORD(acb);
+               return;
+       }
+       if (acb->acb_flags & ACB_F_MESSAGE_WQBUFFER_READED) {
                acb->acb_flags &= (~ACB_F_MESSAGE_WQBUFFER_READED);
                pwbuffer = arcmsr_get_iop_wqbuffer(acb);
                iop_data = (uint8_t __iomem *)pwbuffer->data;
-
-               while ((acb->wqbuf_firstindex != acb->wqbuf_lastindex) && \
-                                                       (allxfer_len < 124)) {
+               while ((acb->wqbuf_firstindex != acb->wqbuf_lastindex)
+                       && (allxfer_len < 124)) {
                        pQbuffer = &acb->wqbuffer[acb->wqbuf_firstindex];
-                       memcpy(iop_data, pQbuffer, 1);
+                       writeb(*pQbuffer, iop_data);
                        acb->wqbuf_firstindex++;
                        acb->wqbuf_firstindex %= ARCMSR_MAX_QBUFFER;
                        iop_data++;
                        allxfer_len++;
                }
-               pwbuffer->data_len = allxfer_len;
-
+               writel(allxfer_len, &pwbuffer->data_len);
                arcmsr_iop_message_wrote(acb);
        }
+}

-       if (acb->wqbuf_firstindex == acb->wqbuf_lastindex) {
+static void
+arcmsr_iop2drv_data_read_handle(struct AdapterControlBlock *acb)
+{
+       unsigned long flags;
+
+       spin_lock_irqsave(&acb->wqbuffer_lock, flags);
+       acb->acb_flags |= ACB_F_MESSAGE_WQBUFFER_READED;
+       if (acb->wqbuf_firstindex != acb->wqbuf_lastindex)
+               arcmsr_write_ioctldata2iop(acb);
+       if (acb->wqbuf_firstindex == acb->wqbuf_lastindex)
                acb->acb_flags |= ACB_F_MESSAGE_WQBUFFER_CLEARED;
-       }
+       spin_unlock_irqrestore(&acb->wqbuffer_lock, flags);
 }

 static void
@@ -1792,309 +1925,357 @@ arcmsr_interrupt(struct AdapterControlBl

 static void arcmsr_iop_parking(struct AdapterControlBlock *acb)
 {
-       if (acb) {
-               /* stop adapter background rebuild */
-               if (acb->acb_flags & ACB_F_MSG_START_BGRB) {
-                       uint32_t intmask_org;
-                       acb->acb_flags &= ~ACB_F_MSG_START_BGRB;
-                       intmask_org = arcmsr_disable_outbound_ints(acb);
-                       arcmsr_stop_adapter_bgrb(acb);
-                       arcmsr_flush_adapter_cache(acb);
-                       arcmsr_enable_outbound_ints(acb, intmask_org);
-               }
+       uint32_t intmask_org;
+
+       /* stop adapter background rebuild */
+       if (acb->acb_flags & ACB_F_MSG_START_BGRB) {
+               acb->acb_flags &= ~ACB_F_MSG_START_BGRB;
+               intmask_org = arcmsr_disable_outbound_ints(acb);
+               arcmsr_stop_adapter_bgrb(acb);
+               arcmsr_flush_adapter_cache(acb);
+               arcmsr_enable_outbound_ints(acb, intmask_org);
        }
 }

-void arcmsr_post_ioctldata2iop(struct AdapterControlBlock *acb)
+void
+arcmsr_clear_iop2drv_rqueue_buffer(struct AdapterControlBlock *acb)
 {
-       int32_t wqbuf_firstindex, wqbuf_lastindex;
-       uint8_t *pQbuffer;
-       struct QBUFFER __iomem *pwbuffer;
-       uint8_t __iomem *iop_data;
-       int32_t allxfer_len = 0;
-       pwbuffer = arcmsr_get_iop_wqbuffer(acb);
-       iop_data = (uint8_t __iomem *)pwbuffer->data;
-       if (acb->acb_flags & ACB_F_MESSAGE_WQBUFFER_READED) {
-               acb->acb_flags &= (~ACB_F_MESSAGE_WQBUFFER_READED);
-               wqbuf_firstindex = acb->wqbuf_firstindex;
-               wqbuf_lastindex = acb->wqbuf_lastindex;
-               while ((wqbuf_firstindex != wqbuf_lastindex) &&
(allxfer_len < 124)) {
-                       pQbuffer = &acb->wqbuffer[wqbuf_firstindex];
-                       memcpy(iop_data, pQbuffer, 1);
-                       wqbuf_firstindex++;
-                       wqbuf_firstindex %= ARCMSR_MAX_QBUFFER;
-                       iop_data++;
-                       allxfer_len++;
+       uint32_t        i;
+
+       if (acb->acb_flags & ACB_F_IOPDATA_OVERFLOW) {
+               for (i = 0; i < 15; i++) {
+                       if (acb->acb_flags & ACB_F_IOPDATA_OVERFLOW) {
+                               acb->acb_flags &= ~ACB_F_IOPDATA_OVERFLOW;
+                               acb->rqbuf_firstindex = 0;
+                               acb->rqbuf_lastindex = 0;
+                               arcmsr_iop_message_read(acb);
+                               mdelay(30);
+                       } else if (acb->rqbuf_firstindex !=
acb->rqbuf_lastindex) {
+                               acb->rqbuf_firstindex = 0;
+                               acb->rqbuf_lastindex = 0;
+                               mdelay(30);
+                       } else
+                               break;
                }
-               acb->wqbuf_firstindex = wqbuf_firstindex;
-               pwbuffer->data_len = allxfer_len;
-               arcmsr_iop_message_wrote(acb);
        }
 }

-static int arcmsr_iop_message_xfer(struct AdapterControlBlock *acb,
-                                       struct scsi_cmnd *cmd)
+static int
+arcmsr_iop_message_xfer(struct AdapterControlBlock *acb, struct scsi_cmnd *cmd)
 {
-       struct CMD_MESSAGE_FIELD *pcmdmessagefld;
-       int retvalue = 0, transfer_len = 0;
        char *buffer;
+       unsigned short use_sg;
+       int retvalue = 0, transfer_len = 0;
+       unsigned long flags;
+       struct CMD_MESSAGE_FIELD *pcmdmessagefld;
+       uint32_t controlcode = (uint32_t)cmd->cmnd[5] << 24 |
+               (uint32_t)cmd->cmnd[6] << 16 |
+               (uint32_t)cmd->cmnd[7] << 8 |
+               (uint32_t)cmd->cmnd[8];
        struct scatterlist *sg;
-       uint32_t controlcode = (uint32_t ) cmd->cmnd[5] << 24 |
-                                               (uint32_t ) cmd->cmnd[6] << 16 |
-                                               (uint32_t ) cmd->cmnd[7] << 8  |
-                                               (uint32_t ) cmd->cmnd[8];
-                                               /* 4 bytes: Areca io
control code */
+
+       use_sg = scsi_sg_count(cmd);
        sg = scsi_sglist(cmd);
        buffer = kmap_atomic(sg_page(sg)) + sg->offset;
-       if (scsi_sg_count(cmd) > 1) {
+       if (use_sg > 1) {
                retvalue = ARCMSR_MESSAGE_FAIL;
                goto message_out;
        }
        transfer_len += sg->length;
-
        if (transfer_len > sizeof(struct CMD_MESSAGE_FIELD)) {
                retvalue = ARCMSR_MESSAGE_FAIL;
+               pr_info("%s: ARCMSR_MESSAGE_FAIL!\n", __func__);
                goto message_out;
        }
-       pcmdmessagefld = (struct CMD_MESSAGE_FIELD *) buffer;
-       switch(controlcode) {
-
+       pcmdmessagefld = (struct CMD_MESSAGE_FIELD *)buffer;
+       switch (controlcode) {
        case ARCMSR_MESSAGE_READ_RQBUFFER: {
                unsigned char *ver_addr;
                uint8_t *pQbuffer, *ptmpQbuffer;
-               int32_t allxfer_len = 0;
-
+               uint32_t allxfer_len = 0;
                ver_addr = kmalloc(1032, GFP_ATOMIC);
                if (!ver_addr) {
                        retvalue = ARCMSR_MESSAGE_FAIL;
+                       pr_info("%s: memory not enough!\n", __func__);
                        goto message_out;
                }
-
                ptmpQbuffer = ver_addr;
-               while ((acb->rqbuf_firstindex != acb->rqbuf_lastindex)
-                       && (allxfer_len < 1031)) {
+               spin_lock_irqsave(&acb->rqbuffer_lock, flags);
+               if (acb->rqbuf_firstindex != acb->rqbuf_lastindex) {
                        pQbuffer = &acb->rqbuffer[acb->rqbuf_firstindex];
-                       memcpy(ptmpQbuffer, pQbuffer, 1);
-                       acb->rqbuf_firstindex++;
-                       acb->rqbuf_firstindex %= ARCMSR_MAX_QBUFFER;
-                       ptmpQbuffer++;
-                       allxfer_len++;
+                       if (acb->rqbuf_firstindex > acb->rqbuf_lastindex) {
+                               if ((ARCMSR_MAX_QBUFFER -
+                                       acb->rqbuf_firstindex) >= 1032) {
+                                       memcpy(ptmpQbuffer, pQbuffer, 1032);
+                                       acb->rqbuf_firstindex += 1032;
+                                       acb->rqbuf_firstindex %=
ARCMSR_MAX_QBUFFER;
+                                       allxfer_len = 1032;
+                               } else {
+                                       if (((ARCMSR_MAX_QBUFFER -
+                                               acb->rqbuf_firstindex) +
+                                               acb->rqbuf_lastindex) > 1032) {
+                                               memcpy(ptmpQbuffer,
+                                                       pQbuffer,
ARCMSR_MAX_QBUFFER
+                                                       -
acb->rqbuf_firstindex);
+                                               ptmpQbuffer +=
+                                                       ARCMSR_MAX_QBUFFER -
+                                                       acb->rqbuf_firstindex;
+                                               memcpy(ptmpQbuffer,
+                                                       acb->rqbuffer, 1032 -
+                                                       (ARCMSR_MAX_QBUFFER
+                                                       -
acb->rqbuf_firstindex));
+                                               acb->rqbuf_firstindex =
+                                                       1032 -
(ARCMSR_MAX_QBUFFER
+                                                       -
acb->rqbuf_firstindex);
+                                               allxfer_len = 1032;
+                                       } else {
+                                               memcpy(ptmpQbuffer,
+                                                       pQbuffer,
ARCMSR_MAX_QBUFFER
+                                                       -
acb->rqbuf_firstindex);
+                                               ptmpQbuffer +=
+                                                       ARCMSR_MAX_QBUFFER -
+                                                       acb->rqbuf_firstindex;
+                                               memcpy(ptmpQbuffer,
+                                                       acb->rqbuffer,
+                                                       acb->rqbuf_lastindex);
+                                               allxfer_len = ARCMSR_MAX_QBUFFER
+                                                       -
acb->rqbuf_firstindex +
+                                                       acb->rqbuf_lastindex;
+                                               acb->rqbuf_firstindex =
+                                                       acb->rqbuf_lastindex;
+                                       }
+                               }
+                       } else {
+                               if ((acb->rqbuf_lastindex -
+                                       acb->rqbuf_firstindex) > 1032) {
+                                       memcpy(ptmpQbuffer, pQbuffer, 1032);
+                                       acb->rqbuf_firstindex += 1032;
+                                       allxfer_len = 1032;
+                               } else {
+                                       memcpy(ptmpQbuffer, pQbuffer,
+                                               acb->rqbuf_lastindex -
+                                               acb->rqbuf_firstindex);
+                                       allxfer_len = acb->rqbuf_lastindex
+                                               - acb->rqbuf_firstindex;
+                                       acb->rqbuf_firstindex =
+                                               acb->rqbuf_lastindex;
+                               }
+                       }
                }
+               memcpy(pcmdmessagefld->messagedatabuffer, ver_addr,
+                       allxfer_len);
                if (acb->acb_flags & ACB_F_IOPDATA_OVERFLOW) {
-
                        struct QBUFFER __iomem *prbuffer;
-                       uint8_t __iomem *iop_data;
-                       int32_t iop_len;
-
                        acb->acb_flags &= ~ACB_F_IOPDATA_OVERFLOW;
                        prbuffer = arcmsr_get_iop_rqbuffer(acb);
-                       iop_data = prbuffer->data;
-                       iop_len = readl(&prbuffer->data_len);
-                       while (iop_len > 0) {
-                               acb->rqbuffer[acb->rqbuf_lastindex] =
readb(iop_data);
-                               acb->rqbuf_lastindex++;
-                               acb->rqbuf_lastindex %= ARCMSR_MAX_QBUFFER;
-                               iop_data++;
-                               iop_len--;
-                       }
-                       arcmsr_iop_message_read(acb);
-               }
-               memcpy(pcmdmessagefld->messagedatabuffer, ver_addr,
allxfer_len);
-               pcmdmessagefld->cmdmessage.Length = allxfer_len;
-               if(acb->fw_flag == FW_DEADLOCK) {
-                       pcmdmessagefld->cmdmessage.ReturnCode =
ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;
-               }else{
-                       pcmdmessagefld->cmdmessage.ReturnCode =
ARCMSR_MESSAGE_RETURNCODE_OK;
+                       if (arcmsr_Read_iop_rqbuffer_data(acb, prbuffer) == 0)
+                               acb->acb_flags |= ACB_F_IOPDATA_OVERFLOW;
                }
+               spin_unlock_irqrestore(&acb->rqbuffer_lock, flags);
                kfree(ver_addr);
-               }
+               pcmdmessagefld->cmdmessage.Length = allxfer_len;
+               if (acb->fw_flag == FW_DEADLOCK)
+                       pcmdmessagefld->cmdmessage.ReturnCode =
+                               ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;
+               else
+                       pcmdmessagefld->cmdmessage.ReturnCode =
+                               ARCMSR_MESSAGE_RETURNCODE_OK;
                break;
-
+       }
        case ARCMSR_MESSAGE_WRITE_WQBUFFER: {
                unsigned char *ver_addr;
                int32_t my_empty_len, user_len, wqbuf_firstindex,
wqbuf_lastindex;
                uint8_t *pQbuffer, *ptmpuserbuffer;
-
                ver_addr = kmalloc(1032, GFP_ATOMIC);
                if (!ver_addr) {
                        retvalue = ARCMSR_MESSAGE_FAIL;
                        goto message_out;
                }
-               if(acb->fw_flag == FW_DEADLOCK) {
-                       pcmdmessagefld->cmdmessage.ReturnCode =
-                       ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;
-               }else{
-                       pcmdmessagefld->cmdmessage.ReturnCode =
-                       ARCMSR_MESSAGE_RETURNCODE_OK;
-               }
                ptmpuserbuffer = ver_addr;
                user_len = pcmdmessagefld->cmdmessage.Length;
-               memcpy(ptmpuserbuffer,
pcmdmessagefld->messagedatabuffer, user_len);
+               memcpy(ptmpuserbuffer,
+                       pcmdmessagefld->messagedatabuffer, user_len);
+               spin_lock_irqsave(&acb->wqbuffer_lock, flags);
                wqbuf_lastindex = acb->wqbuf_lastindex;
                wqbuf_firstindex = acb->wqbuf_firstindex;
                if (wqbuf_lastindex != wqbuf_firstindex) {
                        struct SENSE_DATA *sensebuffer =
                                (struct SENSE_DATA *)cmd->sense_buffer;
-                       arcmsr_post_ioctldata2iop(acb);
+                       arcmsr_write_ioctldata2iop(acb);
                        /* has error report sensedata */
-                       sensebuffer->ErrorCode = 0x70;
+                       sensebuffer->ErrorCode = SCSI_SENSE_CURRENT_ERRORS;
                        sensebuffer->SenseKey = ILLEGAL_REQUEST;
                        sensebuffer->AdditionalSenseLength = 0x0A;
                        sensebuffer->AdditionalSenseCode = 0x20;
                        sensebuffer->Valid = 1;
                        retvalue = ARCMSR_MESSAGE_FAIL;
                } else {
-                       my_empty_len = (wqbuf_firstindex-wqbuf_lastindex - 1)
-                               &(ARCMSR_MAX_QBUFFER - 1);
+                       my_empty_len = (wqbuf_firstindex - wqbuf_lastindex - 1)
+                               & (ARCMSR_MAX_QBUFFER - 1);
                        if (my_empty_len >= user_len) {
                                while (user_len > 0) {
-                                       pQbuffer =
-                                       &acb->wqbuffer[acb->wqbuf_lastindex];
-                                       memcpy(pQbuffer, ptmpuserbuffer, 1);
-                                       acb->wqbuf_lastindex++;
-                                       acb->wqbuf_lastindex %=
ARCMSR_MAX_QBUFFER;
-                                       ptmpuserbuffer++;
-                                       user_len--;
+                                       pQbuffer =
&acb->wqbuffer[acb->wqbuf_lastindex];
+                                       if ((acb->wqbuf_lastindex + user_len)
+                                               > ARCMSR_MAX_QBUFFER) {
+                                               memcpy(pQbuffer, ptmpuserbuffer,
+                                                       ARCMSR_MAX_QBUFFER -
+                                                       acb->wqbuf_lastindex);
+                                               ptmpuserbuffer +=
+                                                       (ARCMSR_MAX_QBUFFER
+                                                       - acb->wqbuf_lastindex);
+                                               user_len -= (ARCMSR_MAX_QBUFFER
+                                                       - acb->wqbuf_lastindex);
+                                               acb->wqbuf_lastindex = 0;
+                                       } else {
+                                               memcpy(pQbuffer, ptmpuserbuffer,
+                                                       user_len);
+                                               acb->wqbuf_lastindex
+= user_len;
+                                               acb->wqbuf_lastindex %=
+                                                       ARCMSR_MAX_QBUFFER;
+                                               user_len = 0;
+                                       }
                                }
-                               if (acb->acb_flags &
ACB_F_MESSAGE_WQBUFFER_CLEARED) {
+                               if (acb->acb_flags &
+                                       ACB_F_MESSAGE_WQBUFFER_CLEARED) {
                                        acb->acb_flags &=
                                                ~ACB_F_MESSAGE_WQBUFFER_CLEARED;
-                                       arcmsr_post_ioctldata2iop(acb);
+                                       arcmsr_write_ioctldata2iop(acb);
                                }
                        } else {
-                               /* has error report sensedata */
                                struct SENSE_DATA *sensebuffer =
                                        (struct SENSE_DATA *)cmd->sense_buffer;
-                               sensebuffer->ErrorCode = 0x70;
+                               /* has error report sensedata */
+                               sensebuffer->ErrorCode =
+                                       SCSI_SENSE_CURRENT_ERRORS;
                                sensebuffer->SenseKey = ILLEGAL_REQUEST;
                                sensebuffer->AdditionalSenseLength = 0x0A;
                                sensebuffer->AdditionalSenseCode = 0x20;
                                sensebuffer->Valid = 1;
                                retvalue = ARCMSR_MESSAGE_FAIL;
                        }
-                       }
-                       kfree(ver_addr);
                }
+               spin_unlock_irqrestore(&acb->wqbuffer_lock, flags);
+               kfree(ver_addr);
+               if (acb->fw_flag == FW_DEADLOCK)
+                       pcmdmessagefld->cmdmessage.ReturnCode =
+                               ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;
+               else
+                       pcmdmessagefld->cmdmessage.ReturnCode =
+                               ARCMSR_MESSAGE_RETURNCODE_OK;
                break;
-
+       }
        case ARCMSR_MESSAGE_CLEAR_RQBUFFER: {
                uint8_t *pQbuffer = acb->rqbuffer;
-               if (acb->acb_flags & ACB_F_IOPDATA_OVERFLOW) {
-                       acb->acb_flags &= ~ACB_F_IOPDATA_OVERFLOW;
-                       arcmsr_iop_message_read(acb);
-               }
+
+               arcmsr_clear_iop2drv_rqueue_buffer(acb);
+               spin_lock_irqsave(&acb->rqbuffer_lock, flags);
                acb->acb_flags |= ACB_F_MESSAGE_RQBUFFER_CLEARED;
                acb->rqbuf_firstindex = 0;
                acb->rqbuf_lastindex = 0;
                memset(pQbuffer, 0, ARCMSR_MAX_QBUFFER);
-               if(acb->fw_flag == FW_DEADLOCK) {
+               spin_unlock_irqrestore(&acb->rqbuffer_lock, flags);
+               if (acb->fw_flag == FW_DEADLOCK)
                        pcmdmessagefld->cmdmessage.ReturnCode =
-                       ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;
-               }else{
+                               ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;
+               else
                        pcmdmessagefld->cmdmessage.ReturnCode =
-                       ARCMSR_MESSAGE_RETURNCODE_OK;
-               }
-               }
+                               ARCMSR_MESSAGE_RETURNCODE_OK;
                break;
-
+       }
        case ARCMSR_MESSAGE_CLEAR_WQBUFFER: {
                uint8_t *pQbuffer = acb->wqbuffer;
-               if(acb->fw_flag == FW_DEADLOCK) {
-                       pcmdmessagefld->cmdmessage.ReturnCode =
-                       ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;
-               }else{
-                       pcmdmessagefld->cmdmessage.ReturnCode =
-                       ARCMSR_MESSAGE_RETURNCODE_OK;
-               }
-
-               if (acb->acb_flags & ACB_F_IOPDATA_OVERFLOW) {
-                       acb->acb_flags &= ~ACB_F_IOPDATA_OVERFLOW;
-                       arcmsr_iop_message_read(acb);
-               }
-               acb->acb_flags |=
-                       (ACB_F_MESSAGE_WQBUFFER_CLEARED |
-                               ACB_F_MESSAGE_WQBUFFER_READED);
+               spin_lock_irqsave(&acb->wqbuffer_lock, flags);
+               acb->acb_flags |= (ACB_F_MESSAGE_WQBUFFER_CLEARED |
+                       ACB_F_MESSAGE_WQBUFFER_READED);
                acb->wqbuf_firstindex = 0;
                acb->wqbuf_lastindex = 0;
                memset(pQbuffer, 0, ARCMSR_MAX_QBUFFER);
-               }
+               spin_unlock_irqrestore(&acb->wqbuffer_lock, flags);
+               if (acb->fw_flag == FW_DEADLOCK)
+                       pcmdmessagefld->cmdmessage.ReturnCode =
+                               ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;
+               else
+                       pcmdmessagefld->cmdmessage.ReturnCode =
+                               ARCMSR_MESSAGE_RETURNCODE_OK;
                break;
-
+       }
        case ARCMSR_MESSAGE_CLEAR_ALLQBUFFER: {
                uint8_t *pQbuffer;
-
-               if (acb->acb_flags & ACB_F_IOPDATA_OVERFLOW) {
-                       acb->acb_flags &= ~ACB_F_IOPDATA_OVERFLOW;
-                       arcmsr_iop_message_read(acb);
-               }
-               acb->acb_flags |=
-                       (ACB_F_MESSAGE_WQBUFFER_CLEARED
-                       | ACB_F_MESSAGE_RQBUFFER_CLEARED
-                       | ACB_F_MESSAGE_WQBUFFER_READED);
+               arcmsr_clear_iop2drv_rqueue_buffer(acb);
+               spin_lock_irqsave(&acb->rqbuffer_lock, flags);
+               acb->acb_flags |= ACB_F_MESSAGE_RQBUFFER_CLEARED;
                acb->rqbuf_firstindex = 0;
                acb->rqbuf_lastindex = 0;
-               acb->wqbuf_firstindex = 0;
-               acb->wqbuf_lastindex = 0;
                pQbuffer = acb->rqbuffer;
                memset(pQbuffer, 0, sizeof(struct QBUFFER));
+               spin_unlock_irqrestore(&acb->rqbuffer_lock, flags);
+               spin_lock_irqsave(&acb->wqbuffer_lock, flags);
+               acb->acb_flags |= (ACB_F_MESSAGE_WQBUFFER_CLEARED |
+                       ACB_F_MESSAGE_WQBUFFER_READED);
+               acb->wqbuf_firstindex = 0;
+               acb->wqbuf_lastindex = 0;
                pQbuffer = acb->wqbuffer;
                memset(pQbuffer, 0, sizeof(struct QBUFFER));
-               if(acb->fw_flag == FW_DEADLOCK) {
+               spin_unlock_irqrestore(&acb->wqbuffer_lock, flags);
+               if (acb->fw_flag == FW_DEADLOCK)
                        pcmdmessagefld->cmdmessage.ReturnCode =
-                       ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;
-               }else{
+                               ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;
+               else
                        pcmdmessagefld->cmdmessage.ReturnCode =
-                       ARCMSR_MESSAGE_RETURNCODE_OK;
-               }
-               }
+                               ARCMSR_MESSAGE_RETURNCODE_OK;
                break;
-
+       }
        case ARCMSR_MESSAGE_RETURN_CODE_3F: {
-               if(acb->fw_flag == FW_DEADLOCK) {
+               if (acb->fw_flag == FW_DEADLOCK)
                        pcmdmessagefld->cmdmessage.ReturnCode =
-                       ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;
-               }else{
+                               ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;
+               else
                        pcmdmessagefld->cmdmessage.ReturnCode =
-                       ARCMSR_MESSAGE_RETURNCODE_3F;
-               }
+                               ARCMSR_MESSAGE_RETURNCODE_3F;
                break;
-               }
+       }
        case ARCMSR_MESSAGE_SAY_HELLO: {
                int8_t *hello_string = "Hello! I am ARCMSR";
-               if(acb->fw_flag == FW_DEADLOCK) {
+               if (acb->fw_flag == FW_DEADLOCK)
                        pcmdmessagefld->cmdmessage.ReturnCode =
-                       ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;
-               }else{
+                               ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;
+               else
                        pcmdmessagefld->cmdmessage.ReturnCode =
-                       ARCMSR_MESSAGE_RETURNCODE_OK;
-               }
-               memcpy(pcmdmessagefld->messagedatabuffer, hello_string
-                       , (int16_t)strlen(hello_string));
-               }
+                               ARCMSR_MESSAGE_RETURNCODE_OK;
+               memcpy(pcmdmessagefld->messagedatabuffer,
+                       hello_string, (int16_t)strlen(hello_string));
                break;
-
-       case ARCMSR_MESSAGE_SAY_GOODBYE:
-               if(acb->fw_flag == FW_DEADLOCK) {
+       }
+       case ARCMSR_MESSAGE_SAY_GOODBYE: {
+               if (acb->fw_flag == FW_DEADLOCK)
                        pcmdmessagefld->cmdmessage.ReturnCode =
-                       ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;
-               }
+                               ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;
+               else
+                       pcmdmessagefld->cmdmessage.ReturnCode =
+                               ARCMSR_MESSAGE_RETURNCODE_OK;
                arcmsr_iop_parking(acb);
                break;
-
-       case ARCMSR_MESSAGE_FLUSH_ADAPTER_CACHE:
-               if(acb->fw_flag == FW_DEADLOCK) {
+       }
+       case ARCMSR_MESSAGE_FLUSH_ADAPTER_CACHE: {
+               if (acb->fw_flag == FW_DEADLOCK)
                        pcmdmessagefld->cmdmessage.ReturnCode =
-                       ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;
-               }
+                               ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;
+               else
+                       pcmdmessagefld->cmdmessage.ReturnCode =
+                               ARCMSR_MESSAGE_RETURNCODE_OK;
                arcmsr_flush_adapter_cache(acb);
                break;
-
+       }
        default:
                retvalue = ARCMSR_MESSAGE_FAIL;
+               pr_info("%s: unknown controlcode!\n", __func__);
+       }
+message_out:
+       if (use_sg) {
+               struct scatterlist *sg;
+               sg = scsi_sglist(cmd);
+               kunmap_atomic(buffer - sg->offset);
        }
-       message_out:
-       sg = scsi_sglist(cmd);
-       kunmap_atomic(buffer - sg->offset);
        return retvalue;
 }

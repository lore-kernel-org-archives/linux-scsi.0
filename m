From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] scsi: upstream arcmsr-1.20.00.15
Date: Sat, 15 Sep 2007 11:41:53 -0500
Message-ID: <1189874513.3339.9.camel@localhost.localdomain>
References: <000301c7f5e8$313604b0$5900a8c0@Nick>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:37994 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750893AbXIOQl5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 15 Sep 2007 12:41:57 -0400
In-Reply-To: <000301c7f5e8$313604b0$5900a8c0@Nick>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nick.cheng@areca.com.tw
Cc: 'Andrew Morton' <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org, randy.dunlap@oracle.com

On Thu, 2007-09-13 at 17:26 +0800, nickcheng wrote:
> Subject: [PATCH] scsi: upstream arcmsr-1.20.00.15
> From: Nick Cheng <nick.cheng@areca.com.tw>
> Description:
> ** support ARC1200/1201/1202 SATA RAID adapter, which is named
> ACB_ADAPTER_TYPE_B
> ** modify the arcmsr_pci_slot_reset function
> ** modify the arcmsr_pci_ers_disconnect_forepart function
> ** modify the arcmsr_pci_ers_need_reset_forepart function 
> Signed-off-by: Nick Cheng <nick.cheng@areca.com.tw>

OK, I fixed this up and applied it ... there was quite a fantastic
amount of white space damage to the patch; could you run the next one
through

scripts/checkpatch.pl

please?

However, even with this applied I get:

  CC [M]  drivers/scsi/arcmsr/arcmsr_hba.o
drivers/scsi/arcmsr/arcmsr_attr.c:186: warning: initialization from
incompatible pointer type
drivers/scsi/arcmsr/arcmsr_attr.c:196: warning: initialization from
incompatible pointer type
drivers/scsi/arcmsr/arcmsr_attr.c:206: warning: initialization from
incompatible pointer type
drivers/scsi/arcmsr/arcmsr_hba.c: In function 'arcmsr_alloc_ccb_pool':
drivers/scsi/arcmsr/arcmsr_hba.c:329: warning: assignment from
incompatible pointer type
drivers/scsi/arcmsr/arcmsr_hba.c: At top level:
drivers/scsi/arcmsr/arcmsr_hba.c:101: warning:
'arcmsr_pci_error_detected' declared 'static' but never defined
drivers/scsi/arcmsr/arcmsr_hba.c:102: warning: 'arcmsr_pci_slot_reset'
declared 'static' but never defined

The majority being incorrect casting or the fact that binary attributes
now take an additional argument.  I fixed all of this up with the patch
below.

Thanks,

James

diff --git a/drivers/scsi/arcmsr/arcmsr_attr.c b/drivers/scsi/arcmsr/arcmsr_attr.c
index 0f0a1ae..d04d1aa 100644
--- a/drivers/scsi/arcmsr/arcmsr_attr.c
+++ b/drivers/scsi/arcmsr/arcmsr_attr.c
@@ -59,7 +59,10 @@
 
 struct class_device_attribute *arcmsr_host_attrs[];
 
-static ssize_t arcmsr_sysfs_iop_message_read(struct kobject *kobj, char *buf, loff_t off, size_t count)
+static ssize_t arcmsr_sysfs_iop_message_read(struct kobject *kobj,
+					     struct bin_attribute *bin,
+					     char *buf, loff_t off,
+					     size_t count)
 {
 	struct class_device *cdev = container_of(kobj,struct class_device,kobj);
 	struct Scsi_Host *host = class_to_shost(cdev);
@@ -102,7 +105,10 @@ static ssize_t arcmsr_sysfs_iop_message_read(struct kobject *kobj, char *buf, lo
 	return (allxfer_len);
 }
 
-static ssize_t arcmsr_sysfs_iop_message_write(struct kobject *kobj, char *buf, loff_t off, size_t count)
+static ssize_t arcmsr_sysfs_iop_message_write(struct kobject *kobj,
+					      struct bin_attribute *bin,
+					      char *buf, loff_t off,
+					      size_t count)
 {
 	struct class_device *cdev = container_of(kobj,struct class_device,kobj);
 	struct Scsi_Host *host = class_to_shost(cdev);
@@ -147,7 +153,10 @@ static ssize_t arcmsr_sysfs_iop_message_write(struct kobject *kobj, char *buf, l
 	}
 }
 
-static ssize_t arcmsr_sysfs_iop_message_clear(struct kobject *kobj, char *buf, loff_t off, size_t count)
+static ssize_t arcmsr_sysfs_iop_message_clear(struct kobject *kobj,
+					      struct bin_attribute *bin,
+					      char *buf, loff_t off,
+					      size_t count)
 {
 	struct class_device *cdev = container_of(kobj,struct class_device,kobj);
 	struct Scsi_Host *host = class_to_shost(cdev);
diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index d70398a..50e1310 100644
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -97,9 +97,6 @@ static void arcmsr_flush_hba_cache(struct AdapterControlBlock *acb);
 static void arcmsr_flush_hbb_cache(struct AdapterControlBlock *acb);
 static const char *arcmsr_info(struct Scsi_Host *);
 static irqreturn_t arcmsr_interrupt(struct AdapterControlBlock *acb);
-static pci_ers_result_t arcmsr_pci_error_detected(struct pci_dev *pdev,
-						pci_channel_state_t state);
-static pci_ers_result_t arcmsr_pci_slot_reset(struct pci_dev *pdev);
 static int arcmsr_adjust_disk_queue_depth(struct scsi_device *sdev,
 								int queue_depth)
 {
@@ -326,7 +323,7 @@ static int arcmsr_alloc_ccb_pool(struct AdapterControlBlock *acb)
 
 		reg = (struct MessageUnit_B *)(dma_coherent +
 		ARCMSR_MAX_FREECCB_NUM * sizeof(struct CommandControlBlock));
-		acb->pmu = (struct MessageUnit_B *)reg;
+		acb->pmu = (struct MessageUnit *)reg;
 		mem_base0 = ioremap(pci_resource_start(pdev, 0),
 					pci_resource_len(pdev, 0));
 		mem_base1 = ioremap(pci_resource_start(pdev, 2),



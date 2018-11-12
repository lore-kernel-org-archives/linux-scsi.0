From: John Garry <john.garry@huawei.com>
Subject: [PATCH v2] scsi: libsas: Remove pcidev reference
Date: Tue, 13 Nov 2018 02:18:07 +0800
Message-ID: <1542046687-221037-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linuxarm@huawei.com, joe@perches.com, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

Not all host drivers are PCI drivers - like hisi_sas, which supports a
platform driver - so remove reference to "pcidev".

In addition, we change the printk() call to pr_warn() which is
an appropriate level for this message.

Signed-off-by: John Garry <john.garry@huawei.com>
---
Change in v1->v2:
- change to pr_warn()

diff --git a/drivers/scsi/libsas/sas_discover.c b/drivers/scsi/libsas/sas_discover.c
index 6b12c67..dd27e9f 100644
--- a/drivers/scsi/libsas/sas_discover.c
+++ b/drivers/scsi/libsas/sas_discover.c
@@ -186,10 +186,10 @@ int sas_notify_lldd_dev_found(struct domain_device *dev)
 
 	res = i->dft->lldd_dev_found(dev);
 	if (res) {
-		printk("sas: driver on pcidev %s cannot handle "
-		       "device %llx, error:%d\n",
-		       dev_name(sas_ha->dev),
-		       SAS_ADDR(dev->sas_addr), res);
+		pr_warn("sas: driver on host %s cannot handle "
+			"device %llx, error:%d\n",
+			dev_name(sas_ha->dev),
+			SAS_ADDR(dev->sas_addr), res);
 	}
 	set_bit(SAS_DEV_FOUND, &dev->state);
 	kref_get(&dev->kref);
-- 
1.9.1

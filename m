From: John Garry <john.garry@huawei.com>
Subject: [PATCH] scsi: libsas: Remove pcidev reference
Date: Tue, 13 Nov 2018 01:28:09 +0800
Message-ID: <1542043689-214071-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linuxarm@huawei.com, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

Not all host drivers are PCI drivers - like hisi_sas, which supports a
platform driver - so remove reference to "pcidev".

The debug level is also downgraded to KERN_ERR for the same message.

Signed-off-by: John Garry <john.garry@huawei.com>

diff --git a/drivers/scsi/libsas/sas_discover.c b/drivers/scsi/libsas/sas_discover.c
index 6b12c67..3428ea9 100644
--- a/drivers/scsi/libsas/sas_discover.c
+++ b/drivers/scsi/libsas/sas_discover.c
@@ -186,7 +186,7 @@ int sas_notify_lldd_dev_found(struct domain_device *dev)
 
 	res = i->dft->lldd_dev_found(dev);
 	if (res) {
-		printk("sas: driver on pcidev %s cannot handle "
+		pr_err("sas: driver on host %s cannot handle "
 		       "device %llx, error:%d\n",
 		       dev_name(sas_ha->dev),
 		       SAS_ADDR(dev->sas_addr), res);
-- 
1.9.1

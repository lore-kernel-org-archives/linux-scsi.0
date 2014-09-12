From: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Subject: [PATCH v2 18/18][SCSI] mpt3sas, mpt2sas: fix scsi_add_host error handling problems in _scsih_probe
Date: Fri, 12 Sep 2014 15:35:33 +0530
Message-ID: <1410516333-3678-19-git-send-email-Sreekanth.Reddy@avagotech.com>
References: <1410516333-3678-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1410516333-3678-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@kernel.org, hch@infradead.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, JBottomley@Parallels.com, Sathya.Prakash@avagotech.com, Nagalakshmi.Nandigama@avagotech.com, linux-kernel@vger.kernel.org, Elliott@hp.com, Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>, Robert Elliott <elliott@hp.com>
List-Id: linux-scsi@vger.kernel.org

In _scsih_probe, propagate the return value from scsi_add_host.
In mpt3sas, avoid calling list_del twice if that returns an
error, which causes list_del corruption warnings if an error
is returned.

Tested with blk-mq and scsi-mq patches to properly cleanup
from and propagate blk_mq_init_rq_map errors.

Signed-off-by: Robert Elliott <elliott@hp.com>
Acked-by: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
---
 drivers/scsi/mpt2sas/mpt2sas_scsih.c | 8 ++++++--
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 9 ++++++---
 2 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index 231ec34..992a224 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -8147,6 +8147,7 @@ _scsih_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	struct MPT2SAS_ADAPTER *ioc;
 	struct Scsi_Host *shost;
+	int rv;
 
 	shost = scsi_host_alloc(&scsih_driver_template,
 	    sizeof(struct MPT2SAS_ADAPTER));
@@ -8242,6 +8243,7 @@ _scsih_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (!ioc->firmware_event_thread) {
 		printk(MPT2SAS_ERR_FMT "failure at %s:%d/%s()!\n",
 		    ioc->name, __FILE__, __LINE__, __func__);
+		rv = -ENODEV;
 		goto out_thread_fail;
 	}
 
@@ -8249,6 +8251,7 @@ _scsih_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if ((mpt2sas_base_attach(ioc))) {
 		printk(MPT2SAS_ERR_FMT "failure at %s:%d/%s()!\n",
 		    ioc->name, __FILE__, __LINE__, __func__);
+		rv = -ENODEV;
 		goto out_attach_fail;
 	}
 
@@ -8266,7 +8269,8 @@ _scsih_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	} else
 		ioc->hide_drives = 0;
 
-	if ((scsi_add_host(shost, &pdev->dev))) {
+	rv = scsi_add_host(shost, &pdev->dev);
+	if (rv) {
 		printk(MPT2SAS_ERR_FMT "failure at %s:%d/%s()!\n",
 		    ioc->name, __FILE__, __LINE__, __func__);
 		goto out_add_shost_fail;
@@ -8283,7 +8287,7 @@ _scsih_probe(struct pci_dev *pdev, const struct pci_device_id *id)
  out_thread_fail:
 	list_del(&ioc->list);
 	scsi_host_put(shost);
-	return -ENODEV;
+	return rv;
 }
 
 #ifdef CONFIG_PM
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 95a1049..857276b 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -7781,6 +7781,7 @@ _scsih_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	struct MPT3SAS_ADAPTER *ioc;
 	struct Scsi_Host *shost;
+	int rv;
 
 	shost = scsi_host_alloc(&scsih_driver_template,
 	    sizeof(struct MPT3SAS_ADAPTER));
@@ -7873,6 +7874,7 @@ _scsih_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (!ioc->firmware_event_thread) {
 		pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
 		    ioc->name, __FILE__, __LINE__, __func__);
+		rv = -ENODEV;
 		goto out_thread_fail;
 	}
 
@@ -7880,12 +7882,13 @@ _scsih_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if ((mpt3sas_base_attach(ioc))) {
 		pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
 		    ioc->name, __FILE__, __LINE__, __func__);
+		rv = -ENODEV;
 		goto out_attach_fail;
 	}
-	if ((scsi_add_host(shost, &pdev->dev))) {
+	rv = scsi_add_host(shost, &pdev->dev);
+	if (rv) {
 		pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
 		    ioc->name, __FILE__, __LINE__, __func__);
-		list_del(&ioc->list);
 		goto out_add_shost_fail;
 	}
 
@@ -7898,7 +7901,7 @@ out_add_shost_fail:
  out_thread_fail:
 	list_del(&ioc->list);
 	scsi_host_put(shost);
-	return -ENODEV;
+	return rv;
 }
 
 #ifdef CONFIG_PM
-- 
2.0.2

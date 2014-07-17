From: Robert Elliott <elliott@hp.com>
Subject: [PATCH 3/3] mpt3sas,
	mpt2sas: fix scsi_add_host error handling problems in _scsih_probe
Date: Thu, 17 Jul 2014 14:39:30 -0500
Message-ID: <20140717193926.1924.21344.stgit@beardog.cce.hp.com>
References: <20140717193707.1924.87867.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140717193707.1924.87867.stgit@beardog.cce.hp.com>
Sender: linux-kernel-owner@vger.kernel.org
To: axboe@kernel.dk, abhijit.mahajan@avagotech.com, kmo@datarainc.com, nagalakshmi.nandigama@avagotech.com, asamymuthupa@micron.com, snitzer@redhat.com, JBottomley@parallels.com, relliott@beardog.cce.hp.com, sreekanth.reddy@avagotech.com, praveen.krishnamoorthy@avagotech.com, agordeev@redhat.com, scameron@beardog.cce.hp.com, tom.leiming@gmail.com, elliott@hp.com, sbradshaw@micron.com, hch@lst.de, m@bjorling.me
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

In _scsih_probe, propagate the return value from scsi_add_host.
In mpt3sas, avoid calling list_del twice if that returns an
error, which causes list_del corruption warnings if an error
is returned.

Tested with blk-mq and scsi-mq patches to properly cleanup
from and propagate blk_mq_init_rq_map errors.

Signed-off-by: Robert Elliott <elliott@hp.com>
---
 drivers/scsi/mpt2sas/mpt2sas_scsih.c |    8 ++++++--
 drivers/scsi/mpt3sas/mpt3sas_scsih.c |    9 ++++++---
 2 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index 4f8a45f..7110e75 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -8123,6 +8123,7 @@ _scsih_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	struct MPT2SAS_ADAPTER *ioc;
 	struct Scsi_Host *shost;
+	int rv;
 
 	shost = scsi_host_alloc(&scsih_driver_template,
 	    sizeof(struct MPT2SAS_ADAPTER));
@@ -8218,6 +8219,7 @@ _scsih_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (!ioc->firmware_event_thread) {
 		printk(MPT2SAS_ERR_FMT "failure at %s:%d/%s()!\n",
 		    ioc->name, __FILE__, __LINE__, __func__);
+		rv = -ENODEV;
 		goto out_thread_fail;
 	}
 
@@ -8225,6 +8227,7 @@ _scsih_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if ((mpt2sas_base_attach(ioc))) {
 		printk(MPT2SAS_ERR_FMT "failure at %s:%d/%s()!\n",
 		    ioc->name, __FILE__, __LINE__, __func__);
+		rv = -ENODEV;
 		goto out_attach_fail;
 	}
 
@@ -8242,7 +8245,8 @@ _scsih_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	} else
 		ioc->hide_drives = 0;
 
-	if ((scsi_add_host(shost, &pdev->dev))) {
+	rv = scsi_add_host(shost, &pdev->dev);
+	if (rv) {
 		printk(MPT2SAS_ERR_FMT "failure at %s:%d/%s()!\n",
 		    ioc->name, __FILE__, __LINE__, __func__);
 		goto out_add_shost_fail;
@@ -8259,7 +8263,7 @@ _scsih_probe(struct pci_dev *pdev, const struct pci_device_id *id)
  out_thread_fail:
 	list_del(&ioc->list);
 	scsi_host_put(shost);
-	return -ENODEV;
+	return rv;
 }
 
 #ifdef CONFIG_PM
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index d2e95ff..07454f0 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -7727,6 +7727,7 @@ _scsih_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	struct MPT3SAS_ADAPTER *ioc;
 	struct Scsi_Host *shost;
+	int rv;
 
 	shost = scsi_host_alloc(&scsih_driver_template,
 	    sizeof(struct MPT3SAS_ADAPTER));
@@ -7819,6 +7820,7 @@ _scsih_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (!ioc->firmware_event_thread) {
 		pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
 		    ioc->name, __FILE__, __LINE__, __func__);
+		rv = -ENODEV;
 		goto out_thread_fail;
 	}
 
@@ -7826,13 +7828,14 @@ _scsih_probe(struct pci_dev *pdev, const struct pci_device_id *id)
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
 
@@ -7846,7 +7849,7 @@ _scsih_probe(struct pci_dev *pdev, const struct pci_device_id *id)
  out_thread_fail:
 	list_del(&ioc->list);
 	scsi_host_put(shost);
-	return -ENODEV;
+	return rv;
 }
 
 #ifdef CONFIG_PM

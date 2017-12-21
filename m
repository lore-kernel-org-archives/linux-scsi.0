From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: [PATCH 24/29] scsi: aacraid: Use hotplug handling function in place of scsi_scan_host
Date: Thu, 21 Dec 2017 09:34:15 -0800
Message-ID: <20171221173420.8213-25-RaghavaAditya.Renukunta@microsemi.com>
References: <20171221173420.8213-1-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-co1nam03on0062.outbound.protection.outlook.com ([104.47.40.62]:7592
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754695AbdLURfD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 21 Dec 2017 12:35:03 -0500
In-Reply-To: <20171221173420.8213-1-RaghavaAditya.Renukunta@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: Scott.Benesh@microsemi.com, aacraid@microsemi.com, tom.white@microsemi.com, "Guilherme G . Piccoli" <gpiccoli@linux.vnet.ibm.com>

Driver uses scsi_scan_host to add new devices in the driver init path,
which adds all the fw exposed devices. The drivers resorts to queue
command checks to block out commands to _hidden_ devices.

Use the hotplug handler code to add new devices during driver init and
other areas, this is only for safw. For ARC scsi_scan_host will still
apply.

Signed-off-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
---
 drivers/scsi/aacraid/aachba.c  |  4 ----
 drivers/scsi/aacraid/aacraid.h |  1 +
 drivers/scsi/aacraid/commsup.c | 18 +++++++++++++++---
 drivers/scsi/aacraid/linit.c   |  5 +++--
 4 files changed, 19 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
index 74f1dd2..eef7322 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -2161,10 +2161,6 @@ int aac_get_adapter_info(struct aac_dev* dev)
 		dev->maximum_num_channels = le32_to_cpu(bus_info->BusCount);
 	}
 
-	if (!dev->sync_mode && dev->sa_firmware &&
-		dev->supplement_adapter_info.virt_device_bus != 0xffff)
-		rcode = aac_setup_safw_adapter(dev, AAC_INIT);
-
 	if (!dev->in_reset) {
 		char buffer[16];
 		tmp = le32_to_cpu(dev->adapter_info.kernelrev);
diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
index c70c998..ba84d99 100644
--- a/drivers/scsi/aacraid/aacraid.h
+++ b/drivers/scsi/aacraid/aacraid.h
@@ -2719,6 +2719,7 @@ static inline int aac_supports_2T(struct aac_dev *dev)
 	return (dev->adapter_info.options & AAC_OPT_NEW_COMM_64);
 }
 
+int aac_scan_host(struct aac_dev *dev, int rescan);
 char * get_container_type(unsigned type);
 extern int numacb;
 extern char aac_driver_version[];
diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
index 698c049..46ee7ba 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -1968,6 +1968,19 @@ static int aac_update_safw_host_devices(struct aac_dev *dev, int rescan)
 	return rcode;
 }
 
+int aac_scan_host(struct aac_dev *dev, int rescan)
+{
+	int rcode = 0;
+
+	mutex_lock(&dev->scan_mutex);
+	if (dev->sa_firmware)
+		rcode = aac_update_safw_host_devices(dev, rescan);
+	else
+		scsi_scan_host(dev->scsi_host_ptr);
+	mutex_unlock(&dev->scan_mutex);
+	return rcode;
+}
+
 /**
  *	aac_handle_sa_aif	Handle a message from the firmware
  *	@dev: Which adapter this fib is from
@@ -2001,9 +2014,8 @@ static void aac_handle_sa_aif(struct aac_dev *dev, struct fib *fibptr)
 	case SA_AIF_LDEV_CHANGE:
 	case SA_AIF_BPCFG_CHANGE:
 
-		mutex_lock(&dev->scan_mutex);
-		aac_update_safw_host_devices(dev, AAC_RESCAN);
-		mutex_unlock(&dev->scan_mutex);
+		aac_scan_host(dev, AAC_RESCAN);
+
 		break;
 
 	case SA_AIF_BPSTAT_CHANGE:
diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 2c862cd..7ea7b2c 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -1787,7 +1787,8 @@ static int aac_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	error = scsi_add_host(shost, &pdev->dev);
 	if (error)
 		goto out_deinit;
-	scsi_scan_host(shost);
+
+	aac_scan_host(aac, AAC_INIT);
 
 	pci_enable_pcie_error_reporting(pdev);
 	pci_save_state(pdev);
@@ -2071,7 +2072,7 @@ static void aac_pci_resume(struct pci_dev *pdev)
 		if (sdev->sdev_state == SDEV_OFFLINE)
 			sdev->sdev_state = SDEV_RUNNING;
 	scsi_unblock_requests(aac->scsi_host_ptr);
-	scsi_scan_host(aac->scsi_host_ptr);
+	aac_scan_host(aac, AAC_RESCAN);
 	pci_save_state(pdev);
 
 	dev_err(&pdev->dev, "aacraid: PCI error - resume\n");
-- 
2.9.4

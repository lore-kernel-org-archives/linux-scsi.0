From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: [PATCH 28/29] scsi: aacraid: Remove unused rescan variable
Date: Thu, 21 Dec 2017 09:34:19 -0800
Message-ID: <20171221173420.8213-29-RaghavaAditya.Renukunta@microsemi.com>
References: <20171221173420.8213-1-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam01on0059.outbound.protection.outlook.com ([104.47.32.59]:30848
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754687AbdLURfC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 21 Dec 2017 12:35:02 -0500
In-Reply-To: <20171221173420.8213-1-RaghavaAditya.Renukunta@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: Scott.Benesh@microsemi.com, aacraid@microsemi.com, tom.white@microsemi.com, "Guilherme G . Piccoli" <gpiccoli@linux.vnet.ibm.com>

Remove unused rescan variable.

Signed-off-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
---
 drivers/scsi/aacraid/aachba.c  | 19 +++++++++----------
 drivers/scsi/aacraid/aacraid.h |  6 +++---
 drivers/scsi/aacraid/commsup.c | 14 +++++++-------
 drivers/scsi/aacraid/linit.c   |  4 ++--
 4 files changed, 21 insertions(+), 22 deletions(-)

diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
index eef7322..aabbefd 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -1822,12 +1822,11 @@ static inline void aac_free_safw_ciss_luns(struct aac_dev *dev)
 /**
  *	aac_get_safw_ciss_luns()	Process topology change
  *	@dev:		aac_dev structure
- *	@rescan		Indicates rescan
  *
  *	Execute a CISS REPORT PHYS LUNS and process the results into
  *	the current hba_map.
  */
-static int aac_get_safw_ciss_luns(struct aac_dev *dev, int rescan)
+static int aac_get_safw_ciss_luns(struct aac_dev *dev)
 {
 	int rcode = -ENOMEM;
 	int datasize;
@@ -1940,7 +1939,7 @@ static inline void aac_free_safw_all_identify_resp(struct aac_dev *dev,
 	}
 }
 
-static int aac_get_safw_attr_all_targets(struct aac_dev *dev, int rescan)
+static int aac_get_safw_attr_all_targets(struct aac_dev *dev)
 {
 	int i;
 	int rcode = 0;
@@ -1983,7 +1982,7 @@ static int aac_get_safw_attr_all_targets(struct aac_dev *dev, int rescan)
  *
  *	Update our hba map with the information gathered from the FW
  */
-static void aac_set_safw_attr_all_targets(struct aac_dev *dev, int rescan)
+static void aac_set_safw_attr_all_targets(struct aac_dev *dev)
 {
 	/* ok and extended reporting */
 	u32 lun_count, nexus;
@@ -2029,7 +2028,7 @@ static void aac_set_safw_attr_all_targets(struct aac_dev *dev, int rescan)
 	}
 }
 
-static int aac_setup_safw_targets(struct aac_dev *dev, int rescan)
+static int aac_setup_safw_targets(struct aac_dev *dev)
 {
 	int rcode = 0;
 
@@ -2037,15 +2036,15 @@ static int aac_setup_safw_targets(struct aac_dev *dev, int rescan)
 	if (unlikely(rcode < 0))
 		goto out;
 
-	rcode = aac_get_safw_ciss_luns(dev, rescan);
+	rcode = aac_get_safw_ciss_luns(dev);
 	if (unlikely(rcode < 0))
 		goto out;
 
-	rcode = aac_get_safw_attr_all_targets(dev, rescan);
+	rcode = aac_get_safw_attr_all_targets(dev);
 	if (unlikely(rcode < 0))
 		goto free_ciss_luns;
 
-	aac_set_safw_attr_all_targets(dev, rescan);
+	aac_set_safw_attr_all_targets(dev);
 
 	aac_free_safw_all_identify_resp(dev, -1);
 free_ciss_luns:
@@ -2054,9 +2053,9 @@ static int aac_setup_safw_targets(struct aac_dev *dev, int rescan)
 	return rcode;
 }
 
-int aac_setup_safw_adapter(struct aac_dev *dev, int rescan)
+int aac_setup_safw_adapter(struct aac_dev *dev)
 {
-	return aac_setup_safw_targets(dev, rescan);
+	return aac_setup_safw_targets(dev);
 }
 
 int aac_get_adapter_info(struct aac_dev* dev)
diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
index 9b678f7..9804d3c 100644
--- a/drivers/scsi/aacraid/aacraid.h
+++ b/drivers/scsi/aacraid/aacraid.h
@@ -2644,7 +2644,7 @@ static inline int aac_adapter_check_health(struct aac_dev *dev)
 }
 
 
-int aac_scan_host(struct aac_dev *dev, int rescan);
+int aac_scan_host(struct aac_dev *dev);
 
 static inline void aac_schedule_safw_scan_worker(struct aac_dev *dev)
 {
@@ -2659,7 +2659,7 @@ static inline void aac_safw_rescan_worker(struct work_struct *work)
 	wait_event(dev->scsi_host_ptr->host_wait,
 		!scsi_host_in_recovery(dev->scsi_host_ptr));
 
-	aac_scan_host(dev, AAC_RESCAN);
+	aac_scan_host(dev);
 }
 
 static inline void aac_cancel_safw_rescan_worker(struct aac_dev *dev)
@@ -2677,7 +2677,7 @@ static inline void aac_cancel_safw_rescan_worker(struct aac_dev *dev)
 void aac_safw_rescan_worker(struct work_struct *work);
 int aac_acquire_irq(struct aac_dev *dev);
 void aac_free_irq(struct aac_dev *dev);
-int aac_setup_safw_adapter(struct aac_dev *dev, int rescan);
+int aac_setup_safw_adapter(struct aac_dev *dev);
 const char *aac_driverinfo(struct Scsi_Host *);
 void aac_fib_vector_assign(struct aac_dev *dev);
 struct fib *aac_fib_alloc(struct aac_dev *dev);
diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
index 6f5dfc9..019558f 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -1948,7 +1948,7 @@ static int aac_is_safw_device_exposed(struct aac_dev *dev, int bus, int target)
 	return is_exposed;
 }
 
-static int aac_update_safw_host_devices(struct aac_dev *dev, int rescan)
+static int aac_update_safw_host_devices(struct aac_dev *dev)
 {
 	int i;
 	int bus;
@@ -1956,7 +1956,7 @@ static int aac_update_safw_host_devices(struct aac_dev *dev, int rescan)
 	int is_exposed = 0;
 	int rcode = 0;
 
-	rcode = aac_setup_safw_adapter(dev, rescan);
+	rcode = aac_setup_safw_adapter(dev);
 	if (unlikely(rcode < 0)) {
 		goto out;
 	}
@@ -1978,24 +1978,24 @@ static int aac_update_safw_host_devices(struct aac_dev *dev, int rescan)
 	return rcode;
 }
 
-static int aac_scan_safw_host(struct aac_dev *dev, int rescan)
+static int aac_scan_safw_host(struct aac_dev *dev)
 {
 	int rcode = 0;
 
-	rcode = aac_update_safw_host_devices(dev, rescan);
+	rcode = aac_update_safw_host_devices(dev);
 	if (rcode)
 		aac_schedule_safw_scan_worker(dev);
 
 	return rcode;
 }
 
-int aac_scan_host(struct aac_dev *dev, int rescan)
+int aac_scan_host(struct aac_dev *dev)
 {
 	int rcode = 0;
 
 	mutex_lock(&dev->scan_mutex);
 	if (dev->sa_firmware)
-		rcode = aac_scan_safw_host(dev, rescan);
+		rcode = aac_scan_safw_host(dev);
 	else
 		scsi_scan_host(dev->scsi_host_ptr);
 	mutex_unlock(&dev->scan_mutex);
@@ -2036,7 +2036,7 @@ static void aac_handle_sa_aif(struct aac_dev *dev, struct fib *fibptr)
 	case SA_AIF_LDEV_CHANGE:
 	case SA_AIF_BPCFG_CHANGE:
 
-		aac_scan_host(dev, AAC_RESCAN);
+		aac_scan_host(dev);
 
 		break;
 
diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index d39dc5e..8aa818b 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -1790,7 +1790,7 @@ static int aac_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (error)
 		goto out_deinit;
 
-	aac_scan_host(aac, AAC_INIT);
+	aac_scan_host(aac);
 
 	pci_enable_pcie_error_reporting(pdev);
 	pci_save_state(pdev);
@@ -2077,7 +2077,7 @@ static void aac_pci_resume(struct pci_dev *pdev)
 		if (sdev->sdev_state == SDEV_OFFLINE)
 			sdev->sdev_state = SDEV_RUNNING;
 	scsi_unblock_requests(aac->scsi_host_ptr);
-	aac_scan_host(aac, AAC_RESCAN);
+	aac_scan_host(aac);
 	pci_save_state(pdev);
 
 	dev_err(&pdev->dev, "aacraid: PCI error - resume\n");
-- 
2.9.4

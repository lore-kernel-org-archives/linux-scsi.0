From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: [PATCH v2 25/30] scsi: aacraid: Reschedule host scan in case of failure
Date: Tue, 26 Dec 2017 20:34:46 -0800
Message-ID: <20171227043451.27813-26-RaghavaAditya.Renukunta@microsemi.com>
References: <20171227043451.27813-1-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam02on0068.outbound.protection.outlook.com ([104.47.36.68]:54432
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751857AbdL0EfZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 26 Dec 2017 23:35:25 -0500
In-Reply-To: <20171227043451.27813-1-RaghavaAditya.Renukunta@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: Scott.Benesh@microsemi.com, tom.white@microsemi.com, aacraid@microsemi.com, "Guilherme G . Piccoli" <gpiccoli@linux.vnet.ibm.com>, Bart Van Assche <Bart.VanAssche@wdc.com>

If the driver fails to retrieve information from the fw (could happen when
the fw is not fully in its senses), the driver does nothing and change is
not processed correctly by the driver

Schedule host rescan in case of failure. This is only for SAFW, since
the information retrieval failure will happen on SAFW devices.

Signed-off-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>

---
Changes in V2:
Rename rescan worker to match kernel coding conventions

 drivers/scsi/aacraid/aacraid.h | 27 ++++++++++++++++++++++++++-
 drivers/scsi/aacraid/commsup.c | 14 +++++++++++++-
 drivers/scsi/aacraid/linit.c   |  5 +++++
 3 files changed, 44 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
index ba84d99..54078bf 100644
--- a/drivers/scsi/aacraid/aacraid.h
+++ b/drivers/scsi/aacraid/aacraid.h
@@ -1341,6 +1341,8 @@ struct fib {
 #define AAC_EXPOSE_DISK		0
 #define AAC_HIDE_DISK			3
 
+#define AAC_SAFW_RESCAN_DELAY  10
+
 struct aac_hba_map_info {
 	__le32	rmw_nexus;		/* nexus for native HBA devices */
 	u8		devtype;	/* device type */
@@ -1611,6 +1613,7 @@ struct aac_dev
 	int			maximum_num_channels;
 	struct fsa_dev_info	*fsa_dev;
 	struct task_struct	*thread;
+	struct delayed_work	safw_rescan_work;
 	int			cardtype;
 	/*
 	 *This lock will protect the two 32-bit
@@ -2639,12 +2642,35 @@ static inline int aac_adapter_check_health(struct aac_dev *dev)
 	return (dev)->a_ops.adapter_check_health(dev);
 }
 
+
+int aac_scan_host(struct aac_dev *dev, int rescan);
+
+static inline void aac_schedule_safw_scan_worker(struct aac_dev *dev)
+{
+	schedule_delayed_work(&dev->safw_rescan_work, AAC_SAFW_RESCAN_DELAY);
+}
+
+static inline void aac_safw_rescan_worker(struct work_struct *work)
+{
+	struct aac_dev *dev = container_of(to_delayed_work(work),
+		struct aac_dev, safw_rescan_work);
+
+	aac_scan_host(dev, AAC_RESCAN);
+}
+
+static inline void aac_cancel_safw_rescan_worker(struct aac_dev *dev)
+{
+	if (dev->sa_firmware)
+		cancel_delayed_work_sync(&dev->safw_rescan_work);
+}
+
 /* SCp.phase values */
 #define AAC_OWNER_MIDLEVEL	0x101
 #define AAC_OWNER_LOWLEVEL	0x102
 #define AAC_OWNER_ERROR_HANDLER	0x103
 #define AAC_OWNER_FIRMWARE	0x106
 
+void aac_safw_rescan_worker(struct work_struct *work);
 int aac_acquire_irq(struct aac_dev *dev);
 void aac_free_irq(struct aac_dev *dev);
 int aac_setup_safw_adapter(struct aac_dev *dev, int rescan);
@@ -2719,7 +2745,6 @@ static inline int aac_supports_2T(struct aac_dev *dev)
 	return (dev->adapter_info.options & AAC_OPT_NEW_COMM_64);
 }
 
-int aac_scan_host(struct aac_dev *dev, int rescan);
 char * get_container_type(unsigned type);
 extern int numacb;
 extern char aac_driver_version[];
diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
index 4e2687c..d562053 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -1964,16 +1964,28 @@ static int aac_update_safw_host_devices(struct aac_dev *dev, int rescan)
 	return rcode;
 }
 
+static int aac_scan_safw_host(struct aac_dev *dev, int rescan)
+{
+	int rcode = 0;
+
+	rcode = aac_update_safw_host_devices(dev, rescan);
+	if (rcode)
+		aac_schedule_safw_scan_worker(dev);
+
+	return rcode;
+}
+
 int aac_scan_host(struct aac_dev *dev, int rescan)
 {
 	int rcode = 0;
 
 	mutex_lock(&dev->scan_mutex);
 	if (dev->sa_firmware)
-		rcode = aac_update_safw_host_devices(dev, rescan);
+		rcode = aac_scan_safw_host(dev, rescan);
 	else
 		scsi_scan_host(dev->scsi_host_ptr);
 	mutex_unlock(&dev->scan_mutex);
+
 	return rcode;
 }
 
diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 7ea7b2c..bf9d2b7 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -1684,6 +1684,8 @@ static int aac_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	mutex_init(&aac->ioctl_mutex);
 	mutex_init(&aac->scan_mutex);
+
+	INIT_DELAYED_WORK(&aac->safw_rescan_work, aac_safw_rescan_worker);
 	/*
 	 *	Map in the registers from the adapter.
 	 */
@@ -1873,6 +1875,7 @@ static int aac_suspend(struct pci_dev *pdev, pm_message_t state)
 	struct aac_dev *aac = (struct aac_dev *)shost->hostdata;
 
 	scsi_block_requests(shost);
+	aac_cancel_safw_rescan_worker(aac);
 	aac_send_shutdown(aac);
 
 	aac_release_resources(aac);
@@ -1931,6 +1934,7 @@ static void aac_remove_one(struct pci_dev *pdev)
 	struct Scsi_Host *shost = pci_get_drvdata(pdev);
 	struct aac_dev *aac = (struct aac_dev *)shost->hostdata;
 
+	aac_cancel_safw_rescan_worker(aac);
 	scsi_remove_host(shost);
 
 	__aac_shutdown(aac);
@@ -1988,6 +1992,7 @@ static pci_ers_result_t aac_pci_error_detected(struct pci_dev *pdev,
 		aac->handle_pci_error = 1;
 
 		scsi_block_requests(aac->scsi_host_ptr);
+		aac_cancel_safw_rescan_worker(aac);
 		aac_flush_ios(aac);
 		aac_release_resources(aac);
 
-- 
2.9.4

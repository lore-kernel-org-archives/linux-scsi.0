From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: [PATCH 19/29] scsi: aacraid: Process hba and container hot plug events in single function
Date: Thu, 21 Dec 2017 09:34:10 -0800
Message-ID: <20171221173420.8213-20-RaghavaAditya.Renukunta@microsemi.com>
References: <20171221173420.8213-1-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam02on0070.outbound.protection.outlook.com ([104.47.36.70]:57584
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754375AbdLURet (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 21 Dec 2017 12:34:49 -0500
In-Reply-To: <20171221173420.8213-1-RaghavaAditya.Renukunta@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: Scott.Benesh@microsemi.com, aacraid@microsemi.com, tom.white@microsemi.com, "Guilherme G . Piccoli" <gpiccoli@linux.vnet.ibm.com>

The hotplug handler code is duplicated for hba handling and container
handling.

Merged function to handle hba and container hot plug events into the
resolve luns functions. Added a bunch of helper functions to check the
validity of a given target and to check if bus, target is container
device.

Signed-off-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
---
 drivers/scsi/aacraid/aachba.c  |  9 ++++---
 drivers/scsi/aacraid/aacraid.h |  3 ++-
 drivers/scsi/aacraid/commsup.c | 59 ++++++++++++++++--------------------------
 3 files changed, 30 insertions(+), 41 deletions(-)

diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
index 7f6036c..74f1dd2 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -1993,6 +1993,8 @@ static void aac_set_safw_attr_all_targets(struct aac_dev *dev, int rescan)
 
 	lun_count = aac_get_safw_phys_lun_count(dev);
 
+	dev->scan_counter++;
+
 	for (i = 0; i < lun_count; ++i) {
 
 		bus = aac_get_safw_phys_bus(dev, i);
@@ -2018,13 +2020,12 @@ static void aac_set_safw_attr_all_targets(struct aac_dev *dev, int rescan)
 		} else
 			devtype = AAC_DEVTYPE_ARC_RAW;
 
+		dev->hba_map[bus][target].scan_counter = dev->scan_counter;
+
 		aac_set_safw_target_qd(dev, bus, target);
 
 update_devtype:
-		if (rescan == AAC_INIT)
-			dev->hba_map[bus][target].devtype = devtype;
-		else
-			dev->hba_map[bus][target].new_devtype = devtype;
+		dev->hba_map[bus][target].devtype = devtype;
 	}
 }
 
diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
index b1a6045..17c6cdd 100644
--- a/drivers/scsi/aacraid/aacraid.h
+++ b/drivers/scsi/aacraid/aacraid.h
@@ -1340,11 +1340,11 @@ struct fib {
 struct aac_hba_map_info {
 	__le32	rmw_nexus;		/* nexus for native HBA devices */
 	u8		devtype;	/* device type */
-	u8		new_devtype;
 	u8		reset_state;	/* 0 - no reset, 1..x - */
 					/* after xth TM LUN reset */
 	u16		qd_limit;
 	u8		expose;		/*checks if to expose or not*/
+	u32		scan_counter;
 	struct aac_ciss_identify_pd  *safw_identify_resp;
 };
 
@@ -1669,6 +1669,7 @@ struct aac_dev
 	u32			vector_cap;	/* MSI-X vector capab.*/
 	int			msi_enabled;	/* MSI/MSI-X enabled */
 	atomic_t		msix_counter;
+	u32			scan_counter;
 	struct msix_entry	msixentry[AAC_MAX_MSIX];
 	struct aac_msix_ctx	aac_msix[AAC_MAX_MSIX]; /* context */
 	struct aac_hba_map_info	hba_map[AAC_MAX_BUSES][AAC_MAX_TARGETS];
diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
index 9625eb0..ed79159 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -1869,13 +1869,29 @@ int aac_check_health(struct aac_dev * aac)
 	return BlinkLED;
 }
 
+static inline int is_safw_raid_volume(struct aac_dev *aac, int bus, int target)
+{
+	return bus == CONTAINER_CHANNEL && target < aac->maximum_num_containers;
+}
+
+static inline int aac_is_safw_scan_count_equal(struct aac_dev *dev,
+	int bus, int target)
+{
+	return dev->hba_map[bus][target].scan_counter == dev->scan_counter;
+}
+
+static int aac_is_safw_target_valid(struct aac_dev *dev, int bus, int target)
+{
+	if (is_safw_raid_volume(dev, bus, target))
+		return dev->fsa_dev[target].valid;
+	else
+		return aac_is_safw_scan_count_equal(dev, bus, target);
+}
 
 static void aac_resolve_luns(struct aac_dev *dev)
 {
 	int bus, target, channel;
 	struct scsi_device *sdev;
-	u8 devtype;
-	u8 new_devtype;
 
 	for (bus = 0; bus < AAC_MAX_BUSES; bus++) {
 		for (target = 0; target < AAC_MAX_TARGETS; target++) {
@@ -1885,24 +1901,19 @@ static void aac_resolve_luns(struct aac_dev *dev)
 			else
 				channel = aac_phys_to_logical(bus);
 
-			devtype = dev->hba_map[bus][target].devtype;
-			new_devtype = dev->hba_map[bus][target].new_devtype;
-
 			sdev = scsi_device_lookup(dev->scsi_host_ptr, channel,
 					target, 0);
 
-			if (!sdev && new_devtype)
+			if (!sdev && aac_is_safw_target_valid(dev, bus, target))
 				scsi_add_device(dev->scsi_host_ptr, channel,
 						target, 0);
-			else if (sdev && new_devtype != devtype)
+			else if (sdev && aac_is_safw_target_valid(dev,
+								bus, target))
 				scsi_remove_device(sdev);
-			else if (sdev && new_devtype == devtype)
-				scsi_rescan_device(&sdev->sdev_gendev);
 
 			if (sdev)
 				scsi_device_put(sdev);
 
-			dev->hba_map[bus][target].devtype = new_devtype;
 		}
 	}
 }
@@ -1917,9 +1928,8 @@ static void aac_resolve_luns(struct aac_dev *dev)
  */
 static void aac_handle_sa_aif(struct aac_dev *dev, struct fib *fibptr)
 {
-	int i, bus, target, container, rcode = 0;
+	int i;
 	u32 events = 0;
-	struct scsi_device *sdev;
 
 	if (fibptr->hbacmd_size & SA_AIF_HOTPLUG)
 		events = SA_AIF_HOTPLUG;
@@ -1941,32 +1951,9 @@ static void aac_handle_sa_aif(struct aac_dev *dev, struct fib *fibptr)
 	case SA_AIF_LDEV_CHANGE:
 	case SA_AIF_BPCFG_CHANGE:
 
-		for (bus = 0; bus < AAC_MAX_BUSES; bus++)
-			for (target = 0; target < AAC_MAX_TARGETS; target++)
-				dev->hba_map[bus][target].new_devtype = 0;
-
-		rcode = aac_setup_safw_adapter(dev, AAC_RESCAN);
+		aac_setup_safw_adapter(dev, AAC_RESCAN);
 
 		aac_resolve_luns(dev);
-
-		for (container = 0; container <
-			dev->maximum_num_containers; ++container) {
-			sdev = scsi_device_lookup(dev->scsi_host_ptr,
-					CONTAINER_CHANNEL,
-					container, 0);
-			if (dev->fsa_dev[container].valid && !sdev) {
-				scsi_add_device(dev->scsi_host_ptr,
-					CONTAINER_CHANNEL,
-					container, 0);
-			} else if (!dev->fsa_dev[container].valid &&
-				sdev) {
-				scsi_remove_device(sdev);
-				scsi_device_put(sdev);
-			} else if (sdev) {
-				scsi_rescan_device(&sdev->sdev_gendev);
-				scsi_device_put(sdev);
-			}
-		}
 		break;
 
 	case SA_AIF_BPSTAT_CHANGE:
-- 
2.9.4

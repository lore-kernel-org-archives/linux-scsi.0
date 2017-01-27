From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: [PATCH V3 14/24] aacraid: Added support for hotplug
Date: Fri, 27 Jan 2017 11:28:43 -0800
Message-ID: <20170127192853.10082-15-RaghavaAditya.Renukunta@microsemi.com>
References: <20170127192853.10082-1-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam03on0041.outbound.protection.outlook.com ([104.47.42.41]:17504
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750718AbdA1DnW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 27 Jan 2017 22:43:22 -0500
In-Reply-To: <20170127192853.10082-1-RaghavaAditya.Renukunta@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: David.Carroll@microsemi.com, Gana.Sridaran@microsemi.com, Scott.Benesh@microsemi.com

Added support for drive hotplug add and removal

Signed-off-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Signed-off-by: Dave Carroll <David.Carroll@microsemi.com>

---
Changes in  V2:
None

Changes in  V2:
None

 drivers/scsi/aacraid/aachba.c  |  13 ++--
 drivers/scsi/aacraid/aacraid.h |  17 +++++-
 drivers/scsi/aacraid/commsup.c | 136 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 159 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
index c34686f..cc003d1 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -1601,7 +1601,7 @@ int aac_issue_bmic_identify(struct aac_dev *dev, u32 bus, u32 target)
  *	Update our hba map with the information gathered from the FW
  */
 void aac_update_hba_map(struct aac_dev *dev,
-		struct aac_ciss_phys_luns_resp *phys_luns)
+		struct aac_ciss_phys_luns_resp *phys_luns, int rescan)
 {
 	/* ok and extended reporting */
 	u32 lun_count, nexus;
@@ -1646,7 +1646,10 @@ void aac_update_hba_map(struct aac_dev *dev,
 			dev->hba_map[bus][target].qd_limit = 32;
 
 update_devtype:
-		dev->hba_map[bus][target].devtype = devtype;
+		if (rescan == AAC_INIT)
+			dev->hba_map[bus][target].devtype = devtype;
+		else
+			dev->hba_map[bus][target].new_devtype = devtype;
 	}
 }
 
@@ -1658,7 +1661,7 @@ void aac_update_hba_map(struct aac_dev *dev,
  *	Execute a CISS REPORT PHYS LUNS and process the results into
  *	the current hba_map.
  */
-int aac_report_phys_luns(struct aac_dev *dev, struct fib *fibptr)
+int aac_report_phys_luns(struct aac_dev *dev, struct fib *fibptr, int rescan)
 {
 	int fibsize, datasize;
 	struct aac_ciss_phys_luns_resp *phys_luns;
@@ -1718,7 +1721,7 @@ int aac_report_phys_luns(struct aac_dev *dev, struct fib *fibptr)
 	/* analyse data */
 	if (rcode >= 0 && phys_luns->resp_flag == 2) {
 		/* ok and extended reporting */
-		aac_update_hba_map(dev, phys_luns);
+		aac_update_hba_map(dev, phys_luns, rescan);
 	}
 
 	pci_free_consistent(dev->pdev, datasize, (void *) phys_luns, addr);
@@ -1831,7 +1834,7 @@ int aac_get_adapter_info(struct aac_dev* dev)
 	if (!dev->sync_mode && dev->sa_firmware &&
 			dev->supplement_adapter_info.VirtDeviceBus != 0xffff) {
 		/* Thor SA Firmware -> CISS_REPORT_PHYSICAL_LUNS */
-		rcode = aac_report_phys_luns(dev, fibptr);
+		rcode = aac_report_phys_luns(dev, fibptr, AAC_INIT);
 	}
 
 	if (!dev->in_reset) {
diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
index e541394..d7d1585 100644
--- a/drivers/scsi/aacraid/aacraid.h
+++ b/drivers/scsi/aacraid/aacraid.h
@@ -74,7 +74,7 @@ enum {
 #define AAC_NUM_IO_FIB		(1024 - AAC_NUM_MGT_FIB)
 #define AAC_NUM_FIB		(AAC_NUM_IO_FIB + AAC_NUM_MGT_FIB)
 
-#define AAC_MAX_LUN		(256)
+#define AAC_MAX_LUN		256
 
 #define AAC_MAX_HOSTPHYSMEMPAGES (0xfffff)
 #define AAC_MAX_32BIT_SGBCOUNT	((unsigned short)256)
@@ -87,6 +87,14 @@ enum {
 #define AAC_MAX_TARGETS		256
 #define AAC_MAX_NATIVE_SIZE		2048
 
+/* Thor AIF events */
+#define SA_AIF_HOTPLUG			(1<<1)
+#define SA_AIF_HARDWARE		(1<<2)
+#define SA_AIF_PDEV_CHANGE		(1<<4)
+#define SA_AIF_LDEV_CHANGE		(1<<5)
+#define SA_AIF_BPSTAT_CHANGE		(1<<30)
+#define SA_AIF_BPCFG_CHANGE		(1<<31)
+
 #define CISS_REPORT_PHYSICAL_LUNS	0xc3
 #define WRITE_HOST_WELLNESS		0xa5
 #define CISS_IDENTIFY_PHYSICAL_DEVICE	0x15
@@ -198,6 +206,7 @@ struct aac_ciss_identify_pd {
 #define CONTAINER_TO_CHANNEL(cont)	(CONTAINER_CHANNEL)
 #define CONTAINER_TO_ID(cont)		(cont)
 #define CONTAINER_TO_LUN(cont)		(0)
+#define ENCLOSURE_CHANNEL		(3)
 
 #define PMC_DEVICE_S6	0x28b
 #define PMC_DEVICE_S7	0x28c
@@ -1102,6 +1111,9 @@ struct fib {
 	u32			hbacmd_size;	/* cmd size for native */
 };
 
+#define AAC_INIT			0
+#define AAC_RESCAN			1
+
 #define AAC_DEVTYPE_RAID_MEMBER	1
 #define AAC_DEVTYPE_ARC_RAW		2
 #define AAC_DEVTYPE_NATIVE_RAW		3
@@ -1111,6 +1123,7 @@ struct fib {
 struct aac_hba_map_info {
 	__le32	rmw_nexus;		/* nexus for native HBA devices */
 	u8		devtype;	/* device type */
+	u8		new_devtype;
 	u8		reset_state;	/* 0 - no reset, 1..x - */
 					/* after xth TM LUN reset */
 	u16		qd_limit;
@@ -2321,7 +2334,7 @@ static inline unsigned int cap_to_cyls(sector_t capacity, unsigned divisor)
 
 int aac_acquire_irq(struct aac_dev *dev);
 void aac_free_irq(struct aac_dev *dev);
-int aac_report_phys_luns(struct aac_dev *dev, struct fib *fibptr);
+int aac_report_phys_luns(struct aac_dev *dev, struct fib *fibptr, int rescan);
 int aac_issue_bmic_identify(struct aac_dev *dev, u32 bus, u32 target);
 const char *aac_driverinfo(struct Scsi_Host *);
 void aac_fib_vector_assign(struct aac_dev *dev);
diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
index 0c009f1..9e51508 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -1730,6 +1730,136 @@ int aac_check_health(struct aac_dev * aac)
 	return BlinkLED;
 }
 
+static void aac_resolve_luns(struct aac_dev *dev)
+{
+	int bus, target, channel;
+	struct scsi_device *sdev;
+	u8 devtype;
+	u8 new_devtype;
+
+	for (bus = 0; bus < AAC_MAX_BUSES; bus++) {
+		for (target = 0; target < AAC_MAX_TARGETS; target++) {
+
+			if (aac_phys_to_logical(bus) == ENCLOSURE_CHANNEL)
+				continue;
+
+			if (bus == CONTAINER_CHANNEL)
+				channel = CONTAINER_CHANNEL;
+			else
+				channel = aac_phys_to_logical(bus);
+
+			devtype = dev->hba_map[bus][target].devtype;
+			new_devtype = dev->hba_map[bus][target].new_devtype;
+
+			sdev = scsi_device_lookup(dev->scsi_host_ptr, channel,
+					target, 0);
+
+			if (!sdev && devtype)
+				scsi_add_device(dev->scsi_host_ptr, channel,
+						target, 0);
+			else if (sdev && new_devtype != devtype)
+				scsi_remove_device(sdev);
+			else if (sdev && new_devtype == devtype)
+				scsi_rescan_device(&sdev->sdev_gendev);
+
+			if (sdev)
+				scsi_device_put(sdev);
+
+			dev->hba_map[bus][target].devtype = new_devtype;
+		}
+	}
+}
+
+/**
+ *	aac_handle_sa_aif	Handle a message from the firmware
+ *	@dev: Which adapter this fib is from
+ *	@fibptr: Pointer to fibptr from adapter
+ *
+ *	This routine handles a driver notify fib from the adapter and
+ *	dispatches it to the appropriate routine for handling.
+ */
+static void aac_handle_sa_aif(struct aac_dev *dev, struct fib *fibptr)
+{
+	int i, bus, target, container, rcode = 0;
+	u32 events = 0;
+	struct fib *fib;
+	struct scsi_device *sdev;
+
+	if (fibptr->hbacmd_size & SA_AIF_HOTPLUG)
+		events = SA_AIF_HOTPLUG;
+	else if (fibptr->hbacmd_size & SA_AIF_HARDWARE)
+		events = SA_AIF_HARDWARE;
+	else if (fibptr->hbacmd_size & SA_AIF_PDEV_CHANGE)
+		events = SA_AIF_PDEV_CHANGE;
+	else if (fibptr->hbacmd_size & SA_AIF_LDEV_CHANGE)
+		events = SA_AIF_LDEV_CHANGE;
+	else if (fibptr->hbacmd_size & SA_AIF_BPSTAT_CHANGE)
+		events = SA_AIF_BPSTAT_CHANGE;
+	else if (fibptr->hbacmd_size & SA_AIF_BPCFG_CHANGE)
+		events = SA_AIF_BPCFG_CHANGE;
+
+	switch (events) {
+	case SA_AIF_HOTPLUG:
+	case SA_AIF_HARDWARE:
+	case SA_AIF_PDEV_CHANGE:
+	case SA_AIF_LDEV_CHANGE:
+	case SA_AIF_BPCFG_CHANGE:
+
+		fib = aac_fib_alloc(dev);
+		if (!fib) {
+			pr_err("aac_handle_sa_aif: out of memory\n");
+			return;
+		}
+		for (bus = 0; bus < AAC_MAX_BUSES; bus++)
+			for (target = 0; target < AAC_MAX_TARGETS; target++)
+				dev->hba_map[bus][target].new_devtype = 0;
+
+		rcode = aac_report_phys_luns(dev, fib, AAC_RESCAN);
+
+		if (rcode != -ERESTARTSYS)
+			aac_fib_free(fib);
+
+		aac_resolve_luns(dev);
+
+		if (events == SA_AIF_LDEV_CHANGE ||
+		    events == SA_AIF_BPCFG_CHANGE) {
+			aac_get_containers(dev);
+			for (container = 0; container <
+			dev->maximum_num_containers; ++container) {
+				sdev = scsi_device_lookup(dev->scsi_host_ptr,
+						CONTAINER_CHANNEL,
+						container, 0);
+				if (dev->fsa_dev[container].valid && !sdev) {
+					scsi_add_device(dev->scsi_host_ptr,
+						CONTAINER_CHANNEL,
+						container, 0);
+				} else if (!dev->fsa_dev[container].valid &&
+					sdev) {
+					scsi_remove_device(sdev);
+					scsi_device_put(sdev);
+				} else if (sdev) {
+					scsi_rescan_device(&sdev->sdev_gendev);
+					scsi_device_put(sdev);
+				}
+			}
+		}
+		break;
+
+	case SA_AIF_BPSTAT_CHANGE:
+		/* currently do nothing */
+		break;
+	}
+
+	for (i = 1; i <= 10; ++i) {
+		events = src_readl(dev, MUnit.IDR);
+		if (events & (1<<23)) {
+			pr_warn(" AIF not cleared by firmware - %d/%d)\n",
+				i, 10);
+			ssleep(1);
+		}
+	}
+}
+
 static void aac_process_events(struct aac_dev *dev)
 {
 	struct hw_fib *hw_fib, *hw_newfib;
@@ -1759,6 +1889,12 @@ static void aac_process_events(struct aac_dev *dev)
 
 		fib = list_entry(entry, struct fib, fiblink);
 		hw_fib = fib->hw_fib_va;
+		if (dev->sa_firmware) {
+			/* Thor AIF */
+			aac_handle_sa_aif(dev, fib);
+			aac_fib_adapter_complete(fib, (u16)sizeof(u32));
+			continue;
+		}
 		/*
 		 *	We will process the FIB here or pass it to a
 		 *	worker thread that is TBD. We Really can't
-- 
2.7.4


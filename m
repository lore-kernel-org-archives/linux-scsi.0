From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: [PATCH V2 04/24] aacraid: Added sa firmware support
Date: Wed, 25 Jan 2017 10:00:51 -0800
Message-ID: <20170125180111.25401-5-RaghavaAditya.Renukunta@microsemi.com>
References: <20170125180111.25401-1-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam02on0079.outbound.protection.outlook.com ([104.47.36.79]:20944
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751870AbdAZAiD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 25 Jan 2017 19:38:03 -0500
In-Reply-To: <20170125180111.25401-1-RaghavaAditya.Renukunta@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: David.Carroll@microsemi.com, Gana.Sridaran@microsemi.com, RaghavaAditya.Renukunta@microsemi.com, Scott.Benesh@microsemi.com

sa_firmware adds the capability to differentiate the new SmartIOC family
of adapters from the series 8 and below.

Signed-off-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Signed-off-by: Dave Carroll <David.Carroll@microsemi.com>

---
 Changes in  V2:
  None

 drivers/scsi/aacraid/aacraid.h  |  4 ++
 drivers/scsi/aacraid/comminit.c | 98 +++++++++++++++++------------------------
 drivers/scsi/aacraid/linit.c    |  2 +-
 3 files changed, 45 insertions(+), 59 deletions(-)

diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
index 32888a4..057ff78 100644
--- a/drivers/scsi/aacraid/aacraid.h
+++ b/drivers/scsi/aacraid/aacraid.h
@@ -1130,6 +1130,7 @@ struct aac_bus_info_response {
 #define AAC_OPT_SUPPLEMENT_ADAPTER_INFO	cpu_to_le32(1<<16)
 #define AAC_OPT_NEW_COMM		cpu_to_le32(1<<17)
 #define AAC_OPT_NEW_COMM_64		cpu_to_le32(1<<18)
+#define AAC_OPT_EXTENDED		cpu_to_le32(1<<23)
 #define AAC_OPT_NEW_COMM_TYPE1		cpu_to_le32(1<<28)
 #define AAC_OPT_NEW_COMM_TYPE2		cpu_to_le32(1<<29)
 #define AAC_OPT_NEW_COMM_TYPE3		cpu_to_le32(1<<30)
@@ -1141,6 +1142,8 @@ struct aac_bus_info_response {
 #define AAC_COMM_MESSAGE_TYPE2		4
 #define AAC_COMM_MESSAGE_TYPE3		5
 
+#define AAC_EXTOPT_SA_FIRMWARE		cpu_to_le32(1<<1)
+
 /* MSIX context */
 struct aac_msix_ctx {
 	int		vector_no;
@@ -1272,6 +1275,7 @@ struct aac_dev
 	u8			printf_enabled;
 	u8			in_reset;
 	u8			msi;
+	u8			sa_firmware;
 	int			management_fib_count;
 	spinlock_t		manage_lock;
 	spinlock_t		sync_lock;
diff --git a/drivers/scsi/aacraid/comminit.c b/drivers/scsi/aacraid/comminit.c
index a59e23b..407ccf0 100644
--- a/drivers/scsi/aacraid/comminit.c
+++ b/drivers/scsi/aacraid/comminit.c
@@ -75,14 +75,22 @@ static int aac_alloc_comm(struct aac_dev *dev, void **commaddr, unsigned long co
 
 	if ((dev->comm_interface == AAC_COMM_MESSAGE_TYPE1) ||
 		(dev->comm_interface == AAC_COMM_MESSAGE_TYPE2) ||
-		(dev->comm_interface == AAC_COMM_MESSAGE_TYPE3))
+		(dev->comm_interface == AAC_COMM_MESSAGE_TYPE3 &&
+		!dev->sa_firmware)) {
 		host_rrq_size =
 			(dev->scsi_host_ptr->can_queue + AAC_NUM_MGT_FIB)
 				* sizeof(u32);
-	else
+		aac_init_size = sizeof(union aac_init);
+	} else if (dev->comm_interface == AAC_COMM_MESSAGE_TYPE3 &&
+		dev->sa_firmware) {
+		host_rrq_size = (dev->scsi_host_ptr->can_queue
+			+ AAC_NUM_MGT_FIB) * sizeof(u32)  * AAC_MAX_MSIX;
+		aac_init_size = sizeof(union aac_init) +
+			(AAC_MAX_HRRQ - 1) * sizeof(struct _rrq);
+	} else {
 		host_rrq_size = 0;
-
-	aac_init_size = sizeof(union aac_init);
+		aac_init_size = sizeof(union aac_init);
+	}
 	size = fibsize + aac_init_size + commsize + commalign +
 			printfbufsiz + host_rrq_size;
 
@@ -465,9 +473,13 @@ void aac_define_int_mode(struct aac_dev *dev)
 		if (dev->max_msix > msi_count)
 			dev->max_msix = msi_count;
 	}
-	dev->vector_cap =
-		(dev->scsi_host_ptr->can_queue + AAC_NUM_MGT_FIB) /
-		msi_count;
+	if (dev->comm_interface == AAC_COMM_MESSAGE_TYPE3 && dev->sa_firmware)
+		dev->vector_cap = (dev->scsi_host_ptr->can_queue +
+				AAC_NUM_MGT_FIB);
+	else
+		dev->vector_cap = (dev->scsi_host_ptr->can_queue +
+				AAC_NUM_MGT_FIB) / msi_count;
+
 }
 struct aac_dev *aac_init_adapter(struct aac_dev *dev)
 {
@@ -526,6 +538,12 @@ struct aac_dev *aac_init_adapter(struct aac_dev *dev)
 				dev->sync_mode = 1;
 			}
 		}
+		if ((status[1] & le32_to_cpu(AAC_OPT_EXTENDED)) &&
+			(status[4] & le32_to_cpu(AAC_EXTOPT_SA_FIRMWARE)))
+			dev->sa_firmware = 1;
+		else
+			dev->sa_firmware = 0;
+
 		if ((dev->comm_interface == AAC_COMM_MESSAGE) &&
 		    (status[2] > dev->base_size)) {
 			aac_adapter_ioremap(dev, 0);
@@ -562,61 +580,25 @@ struct aac_dev *aac_init_adapter(struct aac_dev *dev)
 		dev->sg_tablesize = status[2] & 0xFFFF;
 		if (dev->pdev->device == PMC_DEVICE_S7 ||
 		    dev->pdev->device == PMC_DEVICE_S8 ||
-		    dev->pdev->device == PMC_DEVICE_S9)
-			host->can_queue = ((status[3] >> 16) ? (status[3] >> 16) :
-				(status[3] & 0xFFFF)) - AAC_NUM_MGT_FIB;
-		else
-			host->can_queue = (status[3] & 0xFFFF) - AAC_NUM_MGT_FIB;
+		    dev->pdev->device == PMC_DEVICE_S9) {
+			if (host->can_queue > (status[3] >> 16) -
+					AAC_NUM_MGT_FIB)
+				host->can_queue = (status[3] >> 16) -
+					AAC_NUM_MGT_FIB;
+		} else if (host->can_queue > (status[3] & 0xFFFF) -
+				AAC_NUM_MGT_FIB)
+			host->can_queue = (status[3] & 0xFFFF) -
+				AAC_NUM_MGT_FIB;
+
 		dev->max_num_aif = status[4] & 0xFFFF;
-		/*
-		 *	NOTE:
-		 *	All these overrides are based on a fixed internal
-		 *	knowledge and understanding of existing adapters,
-		 *	acbsize should be set with caution.
-		 */
-		if (acbsize == 512) {
-			host->max_sectors = AAC_MAX_32BIT_SGBCOUNT;
-			dev->max_fib_size = 512;
-			dev->sg_tablesize = host->sg_tablesize
-			  = (512 - sizeof(struct aac_fibhdr)
-			    - sizeof(struct aac_write) + sizeof(struct sgentry))
-			     / sizeof(struct sgentry);
-			host->can_queue = AAC_NUM_IO_FIB;
-		} else if (acbsize == 2048) {
-			host->max_sectors = 512;
-			dev->max_fib_size = 2048;
-			host->sg_tablesize = 65;
-			dev->sg_tablesize = 81;
-			host->can_queue = 512 - AAC_NUM_MGT_FIB;
-		} else if (acbsize == 4096) {
-			host->max_sectors = 1024;
-			dev->max_fib_size = 4096;
-			host->sg_tablesize = 129;
-			dev->sg_tablesize = 166;
-			host->can_queue = 256 - AAC_NUM_MGT_FIB;
-		} else if (acbsize == 8192) {
-			host->max_sectors = 2048;
-			dev->max_fib_size = 8192;
-			host->sg_tablesize = 257;
-			dev->sg_tablesize = 337;
-			host->can_queue = 128 - AAC_NUM_MGT_FIB;
-		} else if (acbsize > 0) {
-			printk("Illegal acbsize=%d ignored\n", acbsize);
-		}
 	}
-	{
-
-		if (numacb > 0) {
-			if (numacb < host->can_queue)
-				host->can_queue = numacb;
-			else
-				printk("numacb=%d ignored\n", numacb);
-		}
+	if (numacb > 0) {
+		if (numacb < host->can_queue)
+			host->can_queue = numacb;
+		else
+			pr_warn("numacb=%d ignored\n", numacb);
 	}
 
-	if (host->can_queue > AAC_NUM_IO_FIB)
-		host->can_queue = AAC_NUM_IO_FIB;
-
 	if (dev->pdev->device == PMC_DEVICE_S6 ||
 	    dev->pdev->device == PMC_DEVICE_S7 ||
 	    dev->pdev->device == PMC_DEVICE_S8 ||
diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 625c17f..e2d063d 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -1285,7 +1285,7 @@ static int aac_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	else
 		shost->this_id = shost->max_id;
 
-	if (aac_drivers[index].quirks & AAC_QUIRK_SRC)
+	if (!aac->sa_firmware && aac_drivers[index].quirks & AAC_QUIRK_SRC)
 		aac_intr_normal(aac, 0, 2, 0, NULL);
 
 	/*
-- 
2.7.4


From: Konstantin Khorenko <khorenko@virtuozzo.com>
Subject: [PATCH v2 1/2] Revert "scsi: aacraid: Remove reference to Series-9"
Date: Wed, 10 Jul 2019 12:31:12 +0300
Message-ID: <20190710093113.27936-2-khorenko@virtuozzo.com>
References: <2a6f5cc2-40cb-647c-003d-aae594d05062@virtuozzo.com>
 <20190710093113.27936-1-khorenko@virtuozzo.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190710093113.27936-1-khorenko@virtuozzo.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Prasad B Munirathnam <prasad.munirathnam@microsemi.com>, Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>, Finn Thain <fthain@telegraphics.com.au>, "Andrey Jr . Melnikov" <temnota.am@gmail.com>
Cc: Konstantin Khorenko <khorenko@virtuozzo.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Adaptec OEM Raid Solutions <aacraid@microsemi.com>
List-Id: linux-scsi@vger.kernel.org

This reverts commit 395e5df79a9588abf1099ea746f11872c9086252.

The patch being reverted not only drops Series-9 cards
checks but also changes logic for Series-6 controllers which
lead to controller hungs/resets under high io load.

So revert the original patch, references to Series 9 are to
be removed by next patch.

https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1777586
https://bugzilla.redhat.com/show_bug.cgi?id=1724077
https://jira.sw.ru/browse/PSBM-95736

Signed-off-by: Konstantin Khorenko <khorenko@virtuozzo.com>
---
 drivers/scsi/aacraid/aacraid.h  | 12 +-----------
 drivers/scsi/aacraid/comminit.c | 18 ++++++++++++++----
 drivers/scsi/aacraid/commsup.c  |  5 ++++-
 drivers/scsi/aacraid/linit.c    | 10 +++++++---
 4 files changed, 26 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
index 3fa03230f6ba..aef47d0e718c 100644
--- a/drivers/scsi/aacraid/aacraid.h
+++ b/drivers/scsi/aacraid/aacraid.h
@@ -416,6 +416,7 @@ struct aac_ciss_identify_pd {
 #define PMC_DEVICE_S6	0x28b
 #define PMC_DEVICE_S7	0x28c
 #define PMC_DEVICE_S8	0x28d
+#define PMC_DEVICE_S9	0x28f
 
 #define aac_phys_to_logical(x)  ((x)+1)
 #define aac_logical_to_phys(x)  ((x)?(x)-1:0)
@@ -2729,17 +2730,6 @@ int _aac_rx_init(struct aac_dev *dev);
 int aac_rx_select_comm(struct aac_dev *dev, int comm);
 int aac_rx_deliver_producer(struct fib * fib);
 
-static inline int aac_is_src(struct aac_dev *dev)
-{
-	u16 device = dev->pdev->device;
-
-	if (device == PMC_DEVICE_S6 ||
-		device == PMC_DEVICE_S7 ||
-		device == PMC_DEVICE_S8)
-		return 1;
-	return 0;
-}
-
 static inline int aac_supports_2T(struct aac_dev *dev)
 {
 	return (dev->adapter_info.options & AAC_OPT_NEW_COMM_64);
diff --git a/drivers/scsi/aacraid/comminit.c b/drivers/scsi/aacraid/comminit.c
index d4fcfa1e54e0..edaa2d53e704 100644
--- a/drivers/scsi/aacraid/comminit.c
+++ b/drivers/scsi/aacraid/comminit.c
@@ -41,8 +41,11 @@ static inline int aac_is_msix_mode(struct aac_dev *dev)
 {
 	u32 status = 0;
 
-	if (aac_is_src(dev))
+	if (dev->pdev->device == PMC_DEVICE_S6 ||
+		dev->pdev->device == PMC_DEVICE_S7 ||
+		dev->pdev->device == PMC_DEVICE_S8) {
 		status = src_readl(dev, MUnit.OMR);
+	}
 	return (status & AAC_INT_MODE_MSIX);
 }
 
@@ -349,7 +352,9 @@ int aac_send_shutdown(struct aac_dev * dev)
 	/* FIB should be freed only after getting the response from the F/W */
 	if (status != -ERESTARTSYS)
 		aac_fib_free(fibctx);
-	if (aac_is_src(dev) &&
+	if ((dev->pdev->device == PMC_DEVICE_S7 ||
+	     dev->pdev->device == PMC_DEVICE_S8 ||
+	     dev->pdev->device == PMC_DEVICE_S9) &&
 	     dev->msi_enabled)
 		aac_set_intx_mode(dev);
 	return status;
@@ -605,7 +610,9 @@ struct aac_dev *aac_init_adapter(struct aac_dev *dev)
 		dev->max_fib_size = status[1] & 0xFFE0;
 		host->sg_tablesize = status[2] >> 16;
 		dev->sg_tablesize = status[2] & 0xFFFF;
-		if (aac_is_src(dev)) {
+		if (dev->pdev->device == PMC_DEVICE_S7 ||
+		    dev->pdev->device == PMC_DEVICE_S8 ||
+		    dev->pdev->device == PMC_DEVICE_S9) {
 			if (host->can_queue > (status[3] >> 16) -
 					AAC_NUM_MGT_FIB)
 				host->can_queue = (status[3] >> 16) -
@@ -624,7 +631,10 @@ struct aac_dev *aac_init_adapter(struct aac_dev *dev)
 			pr_warn("numacb=%d ignored\n", numacb);
 	}
 
-	if (aac_is_src(dev))
+	if (dev->pdev->device == PMC_DEVICE_S6 ||
+	    dev->pdev->device == PMC_DEVICE_S7 ||
+	    dev->pdev->device == PMC_DEVICE_S8 ||
+	    dev->pdev->device == PMC_DEVICE_S9)
 		aac_define_int_mode(dev);
 	/*
 	 *	Ok now init the communication subsystem
diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
index 2142a649e865..b047b1e2215a 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -2574,7 +2574,10 @@ void aac_free_irq(struct aac_dev *dev)
 {
 	int i;
 
-	if (aac_is_src(dev)) {
+	if (dev->pdev->device == PMC_DEVICE_S6 ||
+	    dev->pdev->device == PMC_DEVICE_S7 ||
+	    dev->pdev->device == PMC_DEVICE_S8 ||
+	    dev->pdev->device == PMC_DEVICE_S9) {
 		if (dev->max_msix > 1) {
 			for (i = 0; i < dev->max_msix; i++)
 				free_irq(pci_irq_vector(dev->pdev, i),
diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 644f7f5c61a2..f669a4405217 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -1559,8 +1559,10 @@ static void __aac_shutdown(struct aac_dev * aac)
 	aac_send_shutdown(aac);
 
 	aac_adapter_disable_int(aac);
-
-	if (aac_is_src(aac)) {
+	if (aac->pdev->device == PMC_DEVICE_S6 ||
+	    aac->pdev->device == PMC_DEVICE_S7 ||
+	    aac->pdev->device == PMC_DEVICE_S8 ||
+	    aac->pdev->device == PMC_DEVICE_S9) {
 		if (aac->max_msix > 1) {
 			for (i = 0; i < aac->max_msix; i++) {
 				free_irq(pci_irq_vector(aac->pdev, i),
@@ -1835,7 +1837,9 @@ static int aac_acquire_resources(struct aac_dev *dev)
 	aac_adapter_enable_int(dev);
 
 
-	if (aac_is_src(dev))
+	if ((dev->pdev->device == PMC_DEVICE_S7 ||
+	     dev->pdev->device == PMC_DEVICE_S8 ||
+	     dev->pdev->device == PMC_DEVICE_S9))
 		aac_define_int_mode(dev);
 
 	if (dev->msi_enabled)
-- 
2.15.1

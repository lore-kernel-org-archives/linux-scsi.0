From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: [PATCH V2 18/19] aacraid: Remove reference to Series-9
Date: Wed, 10 May 2017 09:39:52 -0700
Message-ID: <1494434393-17261-19-git-send-email-RaghavaAditya.Renukunta@microsemi.com>
References: <1494434393-17261-1-git-send-email-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam03on0041.outbound.protection.outlook.com ([104.47.42.41]:21332
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751901AbdEJGY3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 10 May 2017 02:24:29 -0400
In-Reply-To: <1494434393-17261-1-git-send-email-RaghavaAditya.Renukunta@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: David.Carroll@microsemi.com, Gana.Sridaran@microsemi.com, Scott.Benesh@microsemi.com, Prasad.Munirathnam@microsemi.com

Remove reference to Series-9 HBA and created arc ctrl check function.

Signed-off-by: Prasad B Munirathnam <prasad.munirathnam@microsemi.com>
Signed-off-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Reviewed-by: David Carroll <david.carroll@microsemi.com>

---
Changes in V2:
None

 drivers/scsi/aacraid/aacraid.h  | 13 ++++++++++++-
 drivers/scsi/aacraid/comminit.c | 18 ++++--------------
 drivers/scsi/aacraid/commsup.c  |  5 +----
 drivers/scsi/aacraid/linit.c    |  9 ++-------
 4 files changed, 19 insertions(+), 26 deletions(-)

diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
index 829f3d8..58ccd2a 100644
--- a/drivers/scsi/aacraid/aacraid.h
+++ b/drivers/scsi/aacraid/aacraid.h
@@ -424,7 +424,6 @@ struct aac_ciss_identify_pd {
 #define PMC_DEVICE_S6	0x28b
 #define PMC_DEVICE_S7	0x28c
 #define PMC_DEVICE_S8	0x28d
-#define PMC_DEVICE_S9	0x28f
 
 #define aac_phys_to_logical(x)  ((x)+1)
 #define aac_logical_to_phys(x)  ((x)?(x)-1:0)
@@ -2684,6 +2683,18 @@ int aac_probe_container(struct aac_dev *dev, int cid);
 int _aac_rx_init(struct aac_dev *dev);
 int aac_rx_select_comm(struct aac_dev *dev, int comm);
 int aac_rx_deliver_producer(struct fib * fib);
+
+static inline int aac_is_src(struct aac_dev *dev)
+{
+	u16 device = dev->pdev->device;
+
+	if (device == PMC_DEVICE_S6 ||
+		device == PMC_DEVICE_S7 ||
+		device == PMC_DEVICE_S8)
+		return 1;
+	return 0;
+}
+
 char * get_container_type(unsigned type);
 extern int numacb;
 extern char aac_driver_version[];
diff --git a/drivers/scsi/aacraid/comminit.c b/drivers/scsi/aacraid/comminit.c
index 1151505..9ee025b 100644
--- a/drivers/scsi/aacraid/comminit.c
+++ b/drivers/scsi/aacraid/comminit.c
@@ -53,11 +53,8 @@ static inline int aac_is_msix_mode(struct aac_dev *dev)
 {
 	u32 status = 0;
 
-	if (dev->pdev->device == PMC_DEVICE_S6 ||
-		dev->pdev->device == PMC_DEVICE_S7 ||
-		dev->pdev->device == PMC_DEVICE_S8) {
+	if (aac_is_src(dev))
 		status = src_readl(dev, MUnit.OMR);
-	}
 	return (status & AAC_INT_MODE_MSIX);
 }
 
@@ -325,9 +322,7 @@ int aac_send_shutdown(struct aac_dev * dev)
 	/* FIB should be freed only after getting the response from the F/W */
 	if (status != -ERESTARTSYS)
 		aac_fib_free(fibctx);
-	if ((dev->pdev->device == PMC_DEVICE_S7 ||
-	     dev->pdev->device == PMC_DEVICE_S8 ||
-	     dev->pdev->device == PMC_DEVICE_S9) &&
+	if (aac_is_src(dev) &&
 	     dev->msi_enabled)
 		aac_set_intx_mode(dev);
 	return status;
@@ -583,9 +578,7 @@ struct aac_dev *aac_init_adapter(struct aac_dev *dev)
 		dev->max_fib_size = status[1] & 0xFFE0;
 		host->sg_tablesize = status[2] >> 16;
 		dev->sg_tablesize = status[2] & 0xFFFF;
-		if (dev->pdev->device == PMC_DEVICE_S7 ||
-		    dev->pdev->device == PMC_DEVICE_S8 ||
-		    dev->pdev->device == PMC_DEVICE_S9) {
+		if (aac_is_src(dev)) {
 			if (host->can_queue > (status[3] >> 16) -
 					AAC_NUM_MGT_FIB)
 				host->can_queue = (status[3] >> 16) -
@@ -604,10 +597,7 @@ struct aac_dev *aac_init_adapter(struct aac_dev *dev)
 			pr_warn("numacb=%d ignored\n", numacb);
 	}
 
-	if (dev->pdev->device == PMC_DEVICE_S6 ||
-	    dev->pdev->device == PMC_DEVICE_S7 ||
-	    dev->pdev->device == PMC_DEVICE_S8 ||
-	    dev->pdev->device == PMC_DEVICE_S9)
+	if (aac_is_src(dev))
 		aac_define_int_mode(dev);
 	/*
 	 *	Ok now init the communication subsystem
diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
index 7bb0253..1a262c5 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -2592,10 +2592,7 @@ void aac_free_irq(struct aac_dev *dev)
 	int cpu;
 
 	cpu = cpumask_first(cpu_online_mask);
-	if (dev->pdev->device == PMC_DEVICE_S6 ||
-	    dev->pdev->device == PMC_DEVICE_S7 ||
-	    dev->pdev->device == PMC_DEVICE_S8 ||
-	    dev->pdev->device == PMC_DEVICE_S9) {
+	if (aac_is_src(dev)) {
 		if (dev->max_msix > 1) {
 			for (i = 0; i < dev->max_msix; i++)
 				free_irq(pci_irq_vector(dev->pdev, i),
diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index d933d2f..0f277df 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -1416,10 +1416,7 @@ static void __aac_shutdown(struct aac_dev * aac)
 		kthread_stop(aac->thread);
 	}
 	aac_adapter_disable_int(aac);
-	if (aac->pdev->device == PMC_DEVICE_S6 ||
-	    aac->pdev->device == PMC_DEVICE_S7 ||
-	    aac->pdev->device == PMC_DEVICE_S8 ||
-	    aac->pdev->device == PMC_DEVICE_S9) {
+	if (aac_is_src(aac)) {
 		if (aac->max_msix > 1) {
 			for (i = 0; i < aac->max_msix; i++) {
 				free_irq(pci_irq_vector(aac->pdev, i),
@@ -1684,9 +1681,7 @@ static int aac_acquire_resources(struct aac_dev *dev)
 	aac_adapter_enable_int(dev);
 
 
-	if ((dev->pdev->device == PMC_DEVICE_S7 ||
-	     dev->pdev->device == PMC_DEVICE_S8 ||
-	     dev->pdev->device == PMC_DEVICE_S9))
+	if (aac_is_src(dev))
 		aac_define_int_mode(dev);
 
 	if (dev->msi_enabled)
-- 
2.7.4

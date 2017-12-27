From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: [PATCH v2 12/30] scsi: aacraid: Add target setup helper function
Date: Tue, 26 Dec 2017 20:34:33 -0800
Message-ID: <20171227043451.27813-13-RaghavaAditya.Renukunta@microsemi.com>
References: <20171227043451.27813-1-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam01on0058.outbound.protection.outlook.com ([104.47.32.58]:39984
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751815AbdL0EfN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 26 Dec 2017 23:35:13 -0500
In-Reply-To: <20171227043451.27813-1-RaghavaAditya.Renukunta@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: Scott.Benesh@microsemi.com, tom.white@microsemi.com, aacraid@microsemi.com, "Guilherme G . Piccoli" <gpiccoli@linux.vnet.ibm.com>, Bart Van Assche <Bart.VanAssche@wdc.com>

Add helper function to setup targets devices and create the base for the
upcoming patches

Signed-off-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>

---
Changes in V2:
None

 drivers/scsi/aacraid/aachba.c  | 18 +++++++++++++-----
 drivers/scsi/aacraid/aacraid.h |  2 +-
 drivers/scsi/aacraid/commsup.c |  2 +-
 3 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
index 801aff0..5a95883 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -1860,7 +1860,7 @@ static void aac_set_safw_attr_all_targets(struct aac_dev *dev,
  *	Execute a CISS REPORT PHYS LUNS and process the results into
  *	the current hba_map.
  */
-int aac_get_safw_ciss_luns(struct aac_dev *dev, int rescan)
+static int aac_get_safw_ciss_luns(struct aac_dev *dev, int rescan)
 {
 	int rcode = -ENOMEM;
 	int datasize;
@@ -1898,6 +1898,16 @@ int aac_get_safw_ciss_luns(struct aac_dev *dev, int rescan)
 	return rcode;
 }
 
+static int aac_setup_safw_targets(struct aac_dev *dev, int rescan)
+{
+	return aac_get_safw_ciss_luns(dev, rescan);
+}
+
+int aac_setup_safw_adapter(struct aac_dev *dev, int rescan)
+{
+	return aac_setup_safw_targets(dev, rescan);
+}
+
 int aac_get_adapter_info(struct aac_dev* dev)
 {
 	struct fib* fibptr;
@@ -2001,10 +2011,8 @@ int aac_get_adapter_info(struct aac_dev* dev)
 	}
 
 	if (!dev->sync_mode && dev->sa_firmware &&
-		dev->supplement_adapter_info.virt_device_bus != 0xffff) {
-		/* Thor SA Firmware -> CISS_REPORT_PHYSICAL_LUNS */
-		rcode = aac_get_safw_ciss_luns(dev, AAC_INIT);
-	}
+		dev->supplement_adapter_info.virt_device_bus != 0xffff)
+		rcode = aac_setup_safw_adapter(dev, AAC_INIT);
 
 	if (!dev->in_reset) {
 		char buffer[16];
diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
index d81d0aa..5690767 100644
--- a/drivers/scsi/aacraid/aacraid.h
+++ b/drivers/scsi/aacraid/aacraid.h
@@ -2639,7 +2639,7 @@ static inline int aac_adapter_check_health(struct aac_dev *dev)
 
 int aac_acquire_irq(struct aac_dev *dev);
 void aac_free_irq(struct aac_dev *dev);
-int aac_get_safw_ciss_luns(struct aac_dev *dev, int rescan);
+int aac_setup_safw_adapter(struct aac_dev *dev, int rescan);
 const char *aac_driverinfo(struct Scsi_Host *);
 void aac_fib_vector_assign(struct aac_dev *dev);
 struct fib *aac_fib_alloc(struct aac_dev *dev);
diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
index 82ddc74..f3077b3 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -1945,7 +1945,7 @@ static void aac_handle_sa_aif(struct aac_dev *dev, struct fib *fibptr)
 			for (target = 0; target < AAC_MAX_TARGETS; target++)
 				dev->hba_map[bus][target].new_devtype = 0;
 
-		rcode = aac_get_safw_ciss_luns(dev, AAC_RESCAN);
+		rcode = aac_setup_safw_adapter(dev, AAC_RESCAN);
 
 		aac_resolve_luns(dev);
 
-- 
2.9.4

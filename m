From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: [PATCH 11/29] scsi: aacraid: Refactor and rename to make mirror existing changes
Date: Thu, 21 Dec 2017 09:34:02 -0800
Message-ID: <20171221173420.8213-12-RaghavaAditya.Renukunta@microsemi.com>
References: <20171221173420.8213-1-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam03on0050.outbound.protection.outlook.com ([104.47.42.50]:27296
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753970AbdLURel (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 21 Dec 2017 12:34:41 -0500
In-Reply-To: <20171221173420.8213-1-RaghavaAditya.Renukunta@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: Scott.Benesh@microsemi.com, aacraid@microsemi.com, tom.white@microsemi.com, "Guilherme G . Piccoli" <gpiccoli@linux.vnet.ibm.com>

Rename variables and functions to make bmic identify, report phy luns
to make them consistent across code internal existing code bases

Signed-off-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
---
 drivers/scsi/aacraid/aachba.c  | 36 +++++++++++++++++++-----------------
 drivers/scsi/aacraid/aacraid.h |  2 +-
 drivers/scsi/aacraid/commsup.c |  2 +-
 3 files changed, 21 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
index 8fb0da7..d6b626d 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -1756,17 +1756,18 @@ static int aac_send_safw_bmic_cmd(struct aac_dev *dev,
 	return rcode;
 }
 
-static int aac_issue_bmic_identify(struct aac_dev *dev, u32 bus, u32 target)
+static int aac_issue_safw_bmic_identify(struct aac_dev *dev,
+	u32 bus, u32 target)
 {
 	int rcode = -ENOMEM;
-	u16 datasize;
+	int datasize;
 	struct aac_srb_unit srbu;
 	struct aac_srb *srbcmd;
-	struct aac_ciss_identify_pd *identify_resp;
+	struct aac_ciss_identify_pd *identify_reply;
 
 	datasize = sizeof(struct aac_ciss_identify_pd);
-	identify_resp = kmalloc(datasize, GFP_KERNEL);
-	if (!identify_resp)
+	identify_reply = kmalloc(datasize, GFP_KERNEL);
+	if (!identify_reply)
 		goto out;
 
 	memset(&srbu, 0, sizeof(struct aac_srb_unit));
@@ -1777,30 +1778,31 @@ static int aac_issue_bmic_identify(struct aac_dev *dev, u32 bus, u32 target)
 	srbcmd->cdb[2]	= (u8)((AAC_MAX_LUN + target) & 0x00FF);
 	srbcmd->cdb[6]	= CISS_IDENTIFY_PHYSICAL_DEVICE;
 
-	rcode = aac_send_safw_bmic_cmd(dev, &srbu, identify_resp, datasize);
+	rcode = aac_send_safw_bmic_cmd(dev, &srbu, identify_reply, datasize);
 	if (unlikely(rcode < 0))
 		goto out;
 
-	if (identify_resp->current_queue_depth_limit <= 0 ||
-		identify_resp->current_queue_depth_limit > 32)
+	if (identify_reply->current_queue_depth_limit <= 0 ||
+		identify_reply->current_queue_depth_limit > 32)
 		dev->hba_map[bus][target].qd_limit = 32;
 	else
 		dev->hba_map[bus][target].qd_limit =
-			identify_resp->current_queue_depth_limit;
+			identify_reply->current_queue_depth_limit;
 
-	kfree(identify_resp);
+	kfree(identify_reply);
 out:
 	return rcode;
 }
 
 /**
- *	aac_update hba_map()-	update current hba map with data from FW
+ *	aac_set_safw_attr_all_targets-	update current hba map with data from FW
  *	@dev:	aac_dev structure
  *	@phys_luns: FW information from report phys luns
+ *	@rescan: Indicates scan type
  *
  *	Update our hba map with the information gathered from the FW
  */
-void aac_update_hba_map(struct aac_dev *dev,
+static void aac_set_safw_attr_all_targets(struct aac_dev *dev,
 		struct aac_ciss_phys_luns_resp *phys_luns, int rescan)
 {
 	/* ok and extended reporting */
@@ -1842,7 +1844,7 @@ void aac_update_hba_map(struct aac_dev *dev,
 		if (devtype != AAC_DEVTYPE_NATIVE_RAW)
 			goto update_devtype;
 
-		if (aac_issue_bmic_identify(dev, bus, target) < 0)
+		if (aac_issue_safw_bmic_identify(dev, bus, target) < 0)
 			dev->hba_map[bus][target].qd_limit = 32;
 
 update_devtype:
@@ -1854,14 +1856,14 @@ void aac_update_hba_map(struct aac_dev *dev,
 }
 
 /**
- *	aac_report_phys_luns()	Process topology change
+ *	aac_get_safw_ciss_luns()	Process topology change
  *	@dev:		aac_dev structure
  *	@rescan		Indicates rescan
  *
  *	Execute a CISS REPORT PHYS LUNS and process the results into
  *	the current hba_map.
  */
-int aac_report_phys_luns(struct aac_dev *dev, int rescan)
+int aac_get_safw_ciss_luns(struct aac_dev *dev, int rescan)
 {
 	int rcode = -ENOMEM;
 	int datasize;
@@ -1891,7 +1893,7 @@ int aac_report_phys_luns(struct aac_dev *dev, int rescan)
 	/* analyse data */
 	if (rcode >= 0 && phys_luns->resp_flag == 2) {
 		/* ok and extended reporting */
-		aac_update_hba_map(dev, phys_luns, rescan);
+		aac_set_safw_attr_all_targets(dev, phys_luns, rescan);
 	}
 
 	kfree(phys_luns);
@@ -2004,7 +2006,7 @@ int aac_get_adapter_info(struct aac_dev* dev)
 	if (!dev->sync_mode && dev->sa_firmware &&
 		dev->supplement_adapter_info.virt_device_bus != 0xffff) {
 		/* Thor SA Firmware -> CISS_REPORT_PHYSICAL_LUNS */
-		rcode = aac_report_phys_luns(dev, AAC_INIT);
+		rcode = aac_get_safw_ciss_luns(dev, AAC_INIT);
 	}
 
 	if (!dev->in_reset) {
diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
index 3a20168..d81d0aa 100644
--- a/drivers/scsi/aacraid/aacraid.h
+++ b/drivers/scsi/aacraid/aacraid.h
@@ -2639,7 +2639,7 @@ static inline int aac_adapter_check_health(struct aac_dev *dev)
 
 int aac_acquire_irq(struct aac_dev *dev);
 void aac_free_irq(struct aac_dev *dev);
-int aac_report_phys_luns(struct aac_dev *dev, int rescan);
+int aac_get_safw_ciss_luns(struct aac_dev *dev, int rescan);
 const char *aac_driverinfo(struct Scsi_Host *);
 void aac_fib_vector_assign(struct aac_dev *dev);
 struct fib *aac_fib_alloc(struct aac_dev *dev);
diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
index f70f112..82ddc74 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -1945,7 +1945,7 @@ static void aac_handle_sa_aif(struct aac_dev *dev, struct fib *fibptr)
 			for (target = 0; target < AAC_MAX_TARGETS; target++)
 				dev->hba_map[bus][target].new_devtype = 0;
 
-		rcode = aac_report_phys_luns(dev, AAC_RESCAN);
+		rcode = aac_get_safw_ciss_luns(dev, AAC_RESCAN);
 
 		aac_resolve_luns(dev);
 
-- 
2.9.4

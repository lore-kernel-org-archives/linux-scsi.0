From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: [PATCH v2 13/30] scsi: aacraid: Untangle targets setup from report phy luns
Date: Tue, 26 Dec 2017 20:34:34 -0800
Message-ID: <20171227043451.27813-14-RaghavaAditya.Renukunta@microsemi.com>
References: <20171227043451.27813-1-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-cys01nam02on0089.outbound.protection.outlook.com ([104.47.37.89]:47232
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751798AbdL0EfM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 26 Dec 2017 23:35:12 -0500
In-Reply-To: <20171227043451.27813-1-RaghavaAditya.Renukunta@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: Scott.Benesh@microsemi.com, tom.white@microsemi.com, aacraid@microsemi.com, "Guilherme G . Piccoli" <gpiccoli@linux.vnet.ibm.com>, Bart Van Assche <Bart.VanAssche@wdc.com>

Remove function call to process targets from the report phy luns function
and make it a function in its own right. This will help understand the
flow of the code.

Signed-off-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>

---
Changes in V2:
None

 drivers/scsi/aacraid/aachba.c  | 44 +++++++++++++++++++++++++++++++-----------
 drivers/scsi/aacraid/aacraid.h |  1 +
 2 files changed, 34 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
index 5a95883..629a04d 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -1799,14 +1799,16 @@ static int aac_issue_safw_bmic_identify(struct aac_dev *dev,
  *
  *	Update our hba map with the information gathered from the FW
  */
-static void aac_set_safw_attr_all_targets(struct aac_dev *dev,
-		struct aac_ciss_phys_luns_resp *phys_luns, int rescan)
+static void aac_set_safw_attr_all_targets(struct aac_dev *dev, int rescan)
 {
 	/* ok and extended reporting */
 	u32 lun_count, nexus;
 	u32 i, bus, target;
 	u8 expose_flag, attribs;
 	u8 devtype;
+	struct aac_ciss_phys_luns_resp *phys_luns;
+
+	phys_luns = dev->safw_phys_luns;
 
 	lun_count = ((phys_luns->list_length[0] << 24)
 			+ (phys_luns->list_length[1] << 16)
@@ -1852,6 +1854,12 @@ static void aac_set_safw_attr_all_targets(struct aac_dev *dev,
 	}
 }
 
+static inline void aac_free_safw_ciss_luns(struct aac_dev *dev)
+{
+	kfree(dev->safw_phys_luns);
+	dev->safw_phys_luns = NULL;
+}
+
 /**
  *	aac_get_safw_ciss_luns()	Process topology change
  *	@dev:		aac_dev structure
@@ -1872,7 +1880,7 @@ static int aac_get_safw_ciss_luns(struct aac_dev *dev, int rescan)
 		(AAC_MAX_TARGETS - 1) * sizeof(struct _ciss_lun);
 	phys_luns = kmalloc(datasize, GFP_KERNEL);
 	if (phys_luns == NULL)
-		goto err_out;
+		goto out;
 
 	memset(&srbu, 0, sizeof(struct aac_srb_unit));
 
@@ -1885,22 +1893,36 @@ static int aac_get_safw_ciss_luns(struct aac_dev *dev, int rescan)
 
 	rcode = aac_send_safw_bmic_cmd(dev, &srbu, phys_luns, datasize);
 	if (unlikely(rcode < 0))
-		goto err_out;
+		goto mem_free_all;
 
-	/* analyse data */
-	if (rcode >= 0 && phys_luns->resp_flag == 2) {
-		/* ok and extended reporting */
-		aac_set_safw_attr_all_targets(dev, phys_luns, rescan);
+	if (phys_luns->resp_flag != 2) {
+		rcode = -ENOMSG;
+		goto mem_free_all;
 	}
 
-	kfree(phys_luns);
-err_out:
+	dev->safw_phys_luns = phys_luns;
+
+out:
 	return rcode;
+mem_free_all:
+	kfree(phys_luns);
+	goto out;
+
 }
 
 static int aac_setup_safw_targets(struct aac_dev *dev, int rescan)
 {
-	return aac_get_safw_ciss_luns(dev, rescan);
+	int rcode = 0;
+
+	rcode = aac_get_safw_ciss_luns(dev, rescan);
+	if (unlikely(rcode < 0))
+		goto out;
+
+	aac_set_safw_attr_all_targets(dev, rescan);
+
+	aac_free_safw_ciss_luns(dev);
+out:
+	return rcode;
 }
 
 int aac_setup_safw_adapter(struct aac_dev *dev, int rescan)
diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
index 5690767..19af4d9 100644
--- a/drivers/scsi/aacraid/aacraid.h
+++ b/drivers/scsi/aacraid/aacraid.h
@@ -1671,6 +1671,7 @@ struct aac_dev
 	struct msix_entry	msixentry[AAC_MAX_MSIX];
 	struct aac_msix_ctx	aac_msix[AAC_MAX_MSIX]; /* context */
 	struct aac_hba_map_info	hba_map[AAC_MAX_BUSES][AAC_MAX_TARGETS];
+	struct aac_ciss_phys_luns_resp *safw_phys_luns;
 	u8			adapter_shutdown;
 	u32			handle_pci_error;
 };
-- 
2.9.4

From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: [PATCH v2 16/30] scsi: aacraid: Save bmic phy information for each phy
Date: Tue, 26 Dec 2017 20:34:37 -0800
Message-ID: <20171227043451.27813-17-RaghavaAditya.Renukunta@microsemi.com>
References: <20171227043451.27813-1-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam01on0059.outbound.protection.outlook.com ([104.47.32.59]:54080
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751495AbdL0EfP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 26 Dec 2017 23:35:15 -0500
In-Reply-To: <20171227043451.27813-1-RaghavaAditya.Renukunta@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: Scott.Benesh@microsemi.com, tom.white@microsemi.com, aacraid@microsemi.com, "Guilherme G . Piccoli" <gpiccoli@linux.vnet.ibm.com>, Bart Van Assche <Bart.VanAssche@wdc.com>

Save the bmic information for each phy, so that it can processed in
target setup function.

Signed-off-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>

---
Changes in V2:
Removed unused phy_luns variable

 drivers/scsi/aacraid/aachba.c  | 84 +++++++++++++++++++++++++++++++++++++++---
 drivers/scsi/aacraid/aacraid.h |  1 +
 2 files changed, 79 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
index fa0132b..baa3de5 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -1756,7 +1756,7 @@ static int aac_send_safw_bmic_cmd(struct aac_dev *dev,
 }
 
 static int aac_issue_safw_bmic_identify(struct aac_dev *dev,
-	u32 bus, u32 target)
+	struct aac_ciss_identify_pd **identify_resp, u32 bus, u32 target)
 {
 	int rcode = -ENOMEM;
 	int datasize;
@@ -1779,7 +1779,7 @@ static int aac_issue_safw_bmic_identify(struct aac_dev *dev,
 
 	rcode = aac_send_safw_bmic_cmd(dev, &srbu, identify_reply, datasize);
 	if (unlikely(rcode < 0))
-		goto out;
+		goto mem_free_all;
 
 	if (identify_reply->current_queue_depth_limit <= 0 ||
 		identify_reply->current_queue_depth_limit > 32)
@@ -1788,9 +1788,13 @@ static int aac_issue_safw_bmic_identify(struct aac_dev *dev,
 		dev->hba_map[bus][target].qd_limit =
 			identify_reply->current_queue_depth_limit;
 
-	kfree(identify_reply);
+	*identify_resp = identify_reply;
+
 out:
 	return rcode;
+mem_free_all:
+	kfree(identify_reply);
+	goto out;
 }
 
 static inline void aac_free_safw_ciss_luns(struct aac_dev *dev)
@@ -1883,6 +1887,71 @@ static inline u32 aac_get_safw_phys_device_type(struct aac_dev *dev, int lun)
 	return dev->safw_phys_luns->lun[lun].node_ident[8];
 }
 
+static inline void aac_free_safw_identify_resp(struct aac_dev *dev,
+						int bus, int target)
+{
+	kfree(dev->hba_map[bus][target].safw_identify_resp);
+	dev->hba_map[bus][target].safw_identify_resp = NULL;
+}
+
+static inline void aac_free_safw_all_identify_resp(struct aac_dev *dev,
+	int lun_count)
+{
+	int luns;
+	int i;
+	u32 bus;
+	u32 target;
+
+	luns = aac_get_safw_phys_lun_count(dev);
+
+	if (luns < lun_count)
+		lun_count = luns;
+	else if (lun_count < 0)
+		lun_count = luns;
+
+	for (i = 0; i < lun_count; i++) {
+		bus = aac_get_safw_phys_bus(dev, i);
+		target = aac_get_safw_phys_target(dev, i);
+
+		aac_free_safw_identify_resp(dev, bus, target);
+	}
+}
+
+static int aac_get_safw_attr_all_targets(struct aac_dev *dev, int rescan)
+{
+	int i;
+	int rcode = 0;
+	u32 lun_count;
+	u32 bus;
+	u32 target;
+	struct aac_ciss_identify_pd *identify_resp = NULL;
+
+	lun_count = aac_get_safw_phys_lun_count(dev);
+
+	for (i = 0; i < lun_count; ++i) {
+
+		bus = aac_get_safw_phys_bus(dev, i);
+		target = aac_get_safw_phys_target(dev, i);
+
+		rcode = aac_issue_safw_bmic_identify(dev,
+						&identify_resp, bus, target);
+
+		if (unlikely(rcode < 0)) {
+			dev->hba_map[bus][target].qd_limit = 32;
+			goto free_identify_resp;
+		}
+
+		dev->hba_map[bus][target].safw_identify_resp = identify_resp;
+	}
+
+out:
+	return rcode;
+
+free_identify_resp:
+	aac_free_safw_all_identify_resp(dev, i);
+	goto out;
+}
+
 /**
  *	aac_set_safw_attr_all_targets-	update current hba map with data from FW
  *	@dev:	aac_dev structure
@@ -1929,9 +1998,6 @@ static void aac_set_safw_attr_all_targets(struct aac_dev *dev, int rescan)
 		if (devtype != AAC_DEVTYPE_NATIVE_RAW)
 			goto update_devtype;
 
-		if (aac_issue_safw_bmic_identify(dev, bus, target) < 0)
-			dev->hba_map[bus][target].qd_limit = 32;
-
 update_devtype:
 		if (rescan == AAC_INIT)
 			dev->hba_map[bus][target].devtype = devtype;
@@ -1948,8 +2014,14 @@ static int aac_setup_safw_targets(struct aac_dev *dev, int rescan)
 	if (unlikely(rcode < 0))
 		goto out;
 
+	rcode = aac_get_safw_attr_all_targets(dev, rescan);
+	if (unlikely(rcode < 0))
+		goto free_ciss_luns;
+
 	aac_set_safw_attr_all_targets(dev, rescan);
 
+	aac_free_safw_all_identify_resp(dev, -1);
+free_ciss_luns:
 	aac_free_safw_ciss_luns(dev);
 out:
 	return rcode;
diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
index 19af4d9..b1a6045 100644
--- a/drivers/scsi/aacraid/aacraid.h
+++ b/drivers/scsi/aacraid/aacraid.h
@@ -1345,6 +1345,7 @@ struct aac_hba_map_info {
 					/* after xth TM LUN reset */
 	u16		qd_limit;
 	u8		expose;		/*checks if to expose or not*/
+	struct aac_ciss_identify_pd  *safw_identify_resp;
 };
 
 /*
-- 
2.9.4

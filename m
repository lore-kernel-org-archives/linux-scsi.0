From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: [PATCH v2 17/30] scsi: aacraid: Add helper function to set queue depth
Date: Tue, 26 Dec 2017 20:34:38 -0800
Message-ID: <20171227043451.27813-18-RaghavaAditya.Renukunta@microsemi.com>
References: <20171227043451.27813-1-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-dm3nam03on0046.outbound.protection.outlook.com ([104.47.41.46]:7296
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751642AbdL0EfQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 26 Dec 2017 23:35:16 -0500
In-Reply-To: <20171227043451.27813-1-RaghavaAditya.Renukunta@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: Scott.Benesh@microsemi.com, tom.white@microsemi.com, aacraid@microsemi.com, "Guilherme G . Piccoli" <gpiccoli@linux.vnet.ibm.com>, Bart Van Assche <Bart.VanAssche@wdc.com>

Add helper function to set queue depth from information retrieved from
the bmic phy structure.

Signed-off-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>

---
Changes in V2:
None

 drivers/scsi/aacraid/aachba.c | 37 ++++++++++++++++++++++++-------------
 1 file changed, 24 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
index baa3de5..67ca5af 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -1755,6 +1755,28 @@ static int aac_send_safw_bmic_cmd(struct aac_dev *dev,
 	return rcode;
 }
 
+static void aac_set_safw_target_qd(struct aac_dev *dev, int bus, int target)
+{
+
+	struct aac_ciss_identify_pd *identify_resp;
+
+	if (dev->hba_map[bus][target].devtype != AAC_DEVTYPE_NATIVE_RAW)
+		return;
+
+	identify_resp = dev->hba_map[bus][target].safw_identify_resp;
+	if (identify_resp == NULL) {
+		dev->hba_map[bus][target].qd_limit = 32;
+		return;
+	}
+
+	if (identify_resp->current_queue_depth_limit <= 0 ||
+		identify_resp->current_queue_depth_limit > 255)
+		dev->hba_map[bus][target].qd_limit = 32;
+	else
+		dev->hba_map[bus][target].qd_limit =
+			identify_resp->current_queue_depth_limit;
+}
+
 static int aac_issue_safw_bmic_identify(struct aac_dev *dev,
 	struct aac_ciss_identify_pd **identify_resp, u32 bus, u32 target)
 {
@@ -1781,13 +1803,6 @@ static int aac_issue_safw_bmic_identify(struct aac_dev *dev,
 	if (unlikely(rcode < 0))
 		goto mem_free_all;
 
-	if (identify_reply->current_queue_depth_limit <= 0 ||
-		identify_reply->current_queue_depth_limit > 32)
-		dev->hba_map[bus][target].qd_limit = 32;
-	else
-		dev->hba_map[bus][target].qd_limit =
-			identify_reply->current_queue_depth_limit;
-
 	*identify_resp = identify_reply;
 
 out:
@@ -1936,17 +1951,14 @@ static int aac_get_safw_attr_all_targets(struct aac_dev *dev, int rescan)
 		rcode = aac_issue_safw_bmic_identify(dev,
 						&identify_resp, bus, target);
 
-		if (unlikely(rcode < 0)) {
-			dev->hba_map[bus][target].qd_limit = 32;
+		if (unlikely(rcode < 0))
 			goto free_identify_resp;
-		}
 
 		dev->hba_map[bus][target].safw_identify_resp = identify_resp;
 	}
 
 out:
 	return rcode;
-
 free_identify_resp:
 	aac_free_safw_all_identify_resp(dev, i);
 	goto out;
@@ -1995,8 +2007,7 @@ static void aac_set_safw_attr_all_targets(struct aac_dev *dev, int rescan)
 		} else
 			devtype = AAC_DEVTYPE_ARC_RAW;
 
-		if (devtype != AAC_DEVTYPE_NATIVE_RAW)
-			goto update_devtype;
+		aac_set_safw_target_qd(dev, bus, target);
 
 update_devtype:
 		if (rescan == AAC_INIT)
-- 
2.9.4

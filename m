From: Don Brace <don.brace@microsemi.com>
Subject: [PATCH 03/17] smartpqi: simplify spanning
Date: Fri, 26 Aug 2016 11:44:24 -0500
Message-ID: <147222986403.31214.11170219064850871397.stgit@brunhilda>
References: <147222977996.31214.8588187948847476082.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam02on0083.outbound.protection.outlook.com ([104.47.36.83]:26448
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754435AbcHZRAD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 26 Aug 2016 13:00:03 -0400
In-Reply-To: <147222977996.31214.8588187948847476082.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, Viswas.G@microsemi.com, Mahesh.Rajashekhara@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Kevin.Barnett@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, elliott@hpe.com
Cc: linux-scsi@vger.kernel.org

From: Kevin Barnett <kevin.barnett@microsemi.com>

Removed the workaround for the transition to spanning.

Reviewed-by: Scott Teel <scott.teel@microsemi.com>
Reviewed-by: Scott Benesh <scott.benesh@microsemi.com>
Signed-off-by: Kevin Barnett <kevin.barnett@microsemi.com>
Signed-off-by: Don Brace <don.brace@microsemi.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c |   38 +++++++++++++++++----------------
 1 file changed, 20 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 6eab38e..9922e31 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -3663,6 +3663,18 @@ static int pqi_validate_device_capability(struct pqi_ctrl_info *ctrl_info)
 		return -EINVAL;
 	}
 
+	if (!ctrl_info->inbound_spanning_supported) {
+		dev_err(&ctrl_info->pci_dev->dev,
+			"the controller does not support inbound spanning\n");
+		return -EINVAL;
+	}
+
+	if (ctrl_info->outbound_spanning_supported) {
+		dev_err(&ctrl_info->pci_dev->dev,
+			"the controller supports outbound spanning but this driver does not\n");
+		return -EINVAL;
+	}
+
 	return 0;
 }
 
@@ -4138,24 +4150,14 @@ static void pqi_calculate_queue_resources(struct pqi_ctrl_info *ctrl_info)
 
 	ctrl_info->num_queue_groups = num_queue_groups;
 
-	if (ctrl_info->max_inbound_iu_length_per_firmware == 256 &&
-		ctrl_info->outbound_spanning_supported) {
-		/*
-		 * TEMPHACK
-		 * This is older f/w that doesn't actually support spanning.
-		 */
-		ctrl_info->max_inbound_iu_length =
-			PQI_OPERATIONAL_IQ_ELEMENT_LENGTH;
-	} else {
-		/*
-		 * Make sure that the max. inbound IU length is an even multiple
-		 * of our inbound element length.
-		 */
-		ctrl_info->max_inbound_iu_length =
-			(ctrl_info->max_inbound_iu_length_per_firmware /
-			PQI_OPERATIONAL_IQ_ELEMENT_LENGTH) *
-			PQI_OPERATIONAL_IQ_ELEMENT_LENGTH;
-	}
+	/*
+	 * Make sure that the max. inbound IU length is an even multiple
+	 * of our inbound element length.
+	 */
+	ctrl_info->max_inbound_iu_length =
+		(ctrl_info->max_inbound_iu_length_per_firmware /
+		PQI_OPERATIONAL_IQ_ELEMENT_LENGTH) *
+		PQI_OPERATIONAL_IQ_ELEMENT_LENGTH;
 
 	num_elements_per_iq =
 		(ctrl_info->max_inbound_iu_length /


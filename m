From: Don Brace <don.brace@microsemi.com>
Subject: [PATCH V2 03/15] smartpqi: simplify spanning
Date: Wed, 31 Aug 2016 14:54:23 -0500
Message-ID: <147267326299.22907.17733382615248734291.stgit@brunhilda>
References: <147267306072.22907.15779110113022168473.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-dm3nam03on0083.outbound.protection.outlook.com ([104.47.41.83]:13532
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752879AbcHaTyc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 31 Aug 2016 15:54:32 -0400
In-Reply-To: <147267306072.22907.15779110113022168473.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, john.hall@microsemi.com, Kevin.Barnett@microsemi.com, Mahesh.Rajashekhara@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Viswas.G@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, elliott@hpe.com
Cc: linux-scsi@vger.kernel.org

From: Kevin Barnett <kevin.barnett@microsemi.com>

Removed the workaround for the transition to spanning.

Reviewed-by: Scott Teel <scott.teel@microsemi.com>
Reviewed-by: Scott Benesh <scott.benesh@microsemi.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
Reviewed-by: Tomas Henzl <thenzl@redhat.com>
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


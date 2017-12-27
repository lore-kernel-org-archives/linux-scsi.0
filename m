From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: [PATCH v2 21/30] scsi: aacraid: Refactor resolve luns code and scsi functions
Date: Tue, 26 Dec 2017 20:34:42 -0800
Message-ID: <20171227043451.27813-22-RaghavaAditya.Renukunta@microsemi.com>
References: <20171227043451.27813-1-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn3nam01on0062.outbound.protection.outlook.com ([104.47.33.62]:5888
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751641AbdL0EfT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 26 Dec 2017 23:35:19 -0500
In-Reply-To: <20171227043451.27813-1-RaghavaAditya.Renukunta@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: Scott.Benesh@microsemi.com, tom.white@microsemi.com, aacraid@microsemi.com, "Guilherme G . Piccoli" <gpiccoli@linux.vnet.ibm.com>, Bart Van Assche <Bart.VanAssche@wdc.com>

Resolve luns checks the if a sdev is already present in the os to figure
out if it needs to be removed. Internally the driver exposes HBA on bus
2 even though its bus 1 in the fw. Its mildly confusing.

Refactor out the sdev lookup into its function to check if sdev has been
added to the kernel or not. Add helper functions to add, remove and put
devices based on their fw bus and target number.

Signed-off-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>

---
Changes in V2:
Removed unnecessary check and assignment for bus number

 drivers/scsi/aacraid/commsup.c | 71 ++++++++++++++++++++++++++++++++----------
 1 file changed, 54 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
index 8966371..5b7a4f5 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -1874,6 +1874,39 @@ static inline int is_safw_raid_volume(struct aac_dev *aac, int bus, int target)
 	return bus == CONTAINER_CHANNEL && target < aac->maximum_num_containers;
 }
 
+static struct scsi_device *aac_lookup_safw_scsi_device(struct aac_dev *dev,
+								int bus,
+								int target)
+{
+	if (bus != CONTAINER_CHANNEL)
+		bus = aac_phys_to_logical(bus);
+
+	return scsi_device_lookup(dev->scsi_host_ptr, bus, target, 0);
+}
+
+static int aac_add_safw_device(struct aac_dev *dev, int bus, int target)
+{
+	if (bus != CONTAINER_CHANNEL)
+		bus = aac_phys_to_logical(bus);
+
+	return scsi_add_device(dev->scsi_host_ptr, bus, target, 0);
+}
+
+static void aac_put_safw_scsi_device(struct scsi_device *sdev)
+{
+	if (sdev)
+		scsi_device_put(sdev);
+}
+
+static void aac_remove_safw_device(struct aac_dev *dev, int bus, int target)
+{
+	struct scsi_device *sdev;
+
+	sdev = aac_lookup_safw_scsi_device(dev, bus, target);
+	scsi_remove_device(sdev);
+	aac_put_safw_scsi_device(sdev);
+}
+
 static inline int aac_is_safw_scan_count_equal(struct aac_dev *dev,
 	int bus, int target)
 {
@@ -1888,33 +1921,37 @@ static int aac_is_safw_target_valid(struct aac_dev *dev, int bus, int target)
 		return aac_is_safw_scan_count_equal(dev, bus, target);
 }
 
+static int aac_is_safw_device_exposed(struct aac_dev *dev, int bus, int target)
+{
+	int is_exposed = 0;
+	struct scsi_device *sdev;
+
+	sdev = aac_lookup_safw_scsi_device(dev, bus, target);
+	if (sdev)
+		is_exposed = 1;
+	aac_put_safw_scsi_device(sdev);
+
+	return is_exposed;
+}
+
 static void aac_resolve_luns(struct aac_dev *dev)
 {
 	int i;
-	int bus, target, channel;
-	struct scsi_device *sdev;
+	int bus, target;
+	int is_exposed = 0;
 
 	for (i = 0; i < AAC_BUS_TARGET_LOOP; i++) {
 
 		bus = get_bus_number(i);
 		target = get_target_number(i);
 
-		if (bus == CONTAINER_CHANNEL)
-			channel = CONTAINER_CHANNEL;
-		else
-			channel = aac_phys_to_logical(bus);
-
-		sdev = scsi_device_lookup(dev->scsi_host_ptr, channel,
-				target, 0);
-
-		if (!sdev && aac_is_safw_target_valid(dev, bus, target))
-			scsi_add_device(dev->scsi_host_ptr, channel,
-					target, 0);
-		else if (sdev && aac_is_safw_target_valid(dev, bus, target))
-			scsi_remove_device(sdev);
+		is_exposed = aac_is_safw_device_exposed(dev, bus, target);
 
-		if (sdev)
-			scsi_device_put(sdev);
+		if (aac_is_safw_target_valid(dev, bus, target) && !is_exposed)
+			aac_add_safw_device(dev, bus, target);
+		else if (!aac_is_safw_target_valid(dev, bus, target) &&
+								is_exposed)
+			aac_remove_safw_device(dev, bus, target);
 	}
 }
 
-- 
2.9.4

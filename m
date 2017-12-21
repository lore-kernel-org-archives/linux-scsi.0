From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: [PATCH 20/29] scsi: aacraid: Added macros to help loop through known buses and targets
Date: Thu, 21 Dec 2017 09:34:11 -0800
Message-ID: <20171221173420.8213-21-RaghavaAditya.Renukunta@microsemi.com>
References: <20171221173420.8213-1-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-cys01nam02on0069.outbound.protection.outlook.com ([104.47.37.69]:53597
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754566AbdLURev (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 21 Dec 2017 12:34:51 -0500
In-Reply-To: <20171221173420.8213-1-RaghavaAditya.Renukunta@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: Scott.Benesh@microsemi.com, aacraid@microsemi.com, tom.white@microsemi.com, "Guilherme G . Piccoli" <gpiccoli@linux.vnet.ibm.com>

Added macros to loop through the MAX SUPPORTED Buses and Targets. This
will make the code a bit easier to read.

Signed-off-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
---
 drivers/scsi/aacraid/aacraid.h |  4 ++++
 drivers/scsi/aacraid/commsup.c | 34 +++++++++++++++++-----------------
 2 files changed, 21 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
index 17c6cdd..a8fe1e1 100644
--- a/drivers/scsi/aacraid/aacraid.h
+++ b/drivers/scsi/aacraid/aacraid.h
@@ -117,9 +117,13 @@ enum {
 /* Thor: 5 phys. buses: #0: empty, 1-4: 256 targets each */
 #define AAC_MAX_BUSES			5
 #define AAC_MAX_TARGETS		256
+#define AAC_BUS_TARGET_LOOP		(AAC_MAX_BUSES * AAC_MAX_TARGETS)
 #define AAC_MAX_NATIVE_SIZE		2048
 #define FW_ERROR_BUFFER_SIZE		512
 
+#define get_bus_number(x)	(x/AAC_MAX_TARGETS)
+#define get_target_number(x)	(x%AAC_MAX_TARGETS)
+
 /* Thor AIF events */
 #define SA_AIF_HOTPLUG			(1<<1)
 #define SA_AIF_HARDWARE		(1<<2)
diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
index ed79159..8966371 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -1890,31 +1890,31 @@ static int aac_is_safw_target_valid(struct aac_dev *dev, int bus, int target)
 
 static void aac_resolve_luns(struct aac_dev *dev)
 {
+	int i;
 	int bus, target, channel;
 	struct scsi_device *sdev;
 
-	for (bus = 0; bus < AAC_MAX_BUSES; bus++) {
-		for (target = 0; target < AAC_MAX_TARGETS; target++) {
+	for (i = 0; i < AAC_BUS_TARGET_LOOP; i++) {
 
-			if (bus == CONTAINER_CHANNEL)
-				channel = CONTAINER_CHANNEL;
-			else
-				channel = aac_phys_to_logical(bus);
+		bus = get_bus_number(i);
+		target = get_target_number(i);
 
-			sdev = scsi_device_lookup(dev->scsi_host_ptr, channel,
-					target, 0);
+		if (bus == CONTAINER_CHANNEL)
+			channel = CONTAINER_CHANNEL;
+		else
+			channel = aac_phys_to_logical(bus);
 
-			if (!sdev && aac_is_safw_target_valid(dev, bus, target))
-				scsi_add_device(dev->scsi_host_ptr, channel,
-						target, 0);
-			else if (sdev && aac_is_safw_target_valid(dev,
-								bus, target))
-				scsi_remove_device(sdev);
+		sdev = scsi_device_lookup(dev->scsi_host_ptr, channel,
+				target, 0);
 
-			if (sdev)
-				scsi_device_put(sdev);
+		if (!sdev && aac_is_safw_target_valid(dev, bus, target))
+			scsi_add_device(dev->scsi_host_ptr, channel,
+					target, 0);
+		else if (sdev && aac_is_safw_target_valid(dev, bus, target))
+			scsi_remove_device(sdev);
 
-		}
+		if (sdev)
+			scsi_device_put(sdev);
 	}
 }
 
-- 
2.9.4

From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: [PATCH] aacraid: Fixed expander hotplug for SMART family
Date: Wed, 22 Feb 2017 07:23:13 -0800
Message-ID: <20170222152313.11518-1-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-co1nam03on0088.outbound.protection.outlook.com ([104.47.40.88]:41376
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754503AbdBVWBn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 22 Feb 2017 17:01:43 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: David.Carroll@microsemi.com, Gana.Sridaran@microsemi.com, Scott.Benesh@microsemi.com

Current driver Hotplug processing code skips over Enclosure channel,
therefore any addition/removal of expander enclosure is not processed.
Additionally  device addition code relies on older device type, which
prevents the hotplug of adapter expanders.

Fixed by removing code that skips over Enclosure channels and using the
latest device type for addition or removal or enclosure expanders.

Fixes: 6223a39fe6fbbeef (scsi: aacraid: Added support for hotplug)
Signed-off-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
---
 drivers/scsi/aacraid/commsup.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
index a2ea70d..1994c74 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -1908,9 +1908,6 @@ static void aac_resolve_luns(struct aac_dev *dev)
 	for (bus = 0; bus < AAC_MAX_BUSES; bus++) {
 		for (target = 0; target < AAC_MAX_TARGETS; target++) {
 
-			if (aac_phys_to_logical(bus) == ENCLOSURE_CHANNEL)
-				continue;
-
 			if (bus == CONTAINER_CHANNEL)
 				channel = CONTAINER_CHANNEL;
 			else
@@ -1922,7 +1919,7 @@ static void aac_resolve_luns(struct aac_dev *dev)
 			sdev = scsi_device_lookup(dev->scsi_host_ptr, channel,
 					target, 0);
 
-			if (!sdev && devtype)
+			if (!sdev && new_devtype)
 				scsi_add_device(dev->scsi_host_ptr, channel,
 						target, 0);
 			else if (sdev && new_devtype != devtype)
-- 
2.7.4

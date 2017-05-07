From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: [PATCH 03/19] aacraid: Added 32 and 64 queue depth for arc natives
Date: Sun, 7 May 2017 04:26:48 -0700
Message-ID: <20170507112704.21940-4-RaghavaAditya.Renukunta@microsemi.com>
References: <20170507112704.21940-1-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2nam02on0069.outbound.protection.outlook.com ([104.47.38.69]:19672
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754625AbdEGVkS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 7 May 2017 17:40:18 -0400
In-Reply-To: <20170507112704.21940-1-RaghavaAditya.Renukunta@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: David.Carroll@microsemi.com, Gana.Sridaran@microsemi.com, Scott.Benesh@microsemi.com, Prasad.Munirathnam@microsemi.com, RaghavaAditya.Renukunta@microsemi.com

The qd for ARC Native disks is calculated by dividing the max IO 1024
by the number of disks or 256 which ever is lower. This causes poor
disk IO performance.

The fix is set the qd based on the type of disk (SAS - 64 and SATA -
32).

Signed-off-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
---
 drivers/scsi/aacraid/aacraid.h |  1 +
 drivers/scsi/aacraid/linit.c   | 11 +++++++++++
 2 files changed, 12 insertions(+)

diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
index d036a80..3ede6de 100644
--- a/drivers/scsi/aacraid/aacraid.h
+++ b/drivers/scsi/aacraid/aacraid.h
@@ -415,6 +415,7 @@ struct aac_ciss_identify_pd {
  * These macros convert from physical channels to virtual channels
  */
 #define CONTAINER_CHANNEL		(0)
+#define NATIVE_CHANNEL			(1)
 #define CONTAINER_TO_CHANNEL(cont)	(CONTAINER_CHANNEL)
 #define CONTAINER_TO_ID(cont)		(cont)
 #define CONTAINER_TO_LUN(cont)		(0)
diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 5a201da..5e1a2d6 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -466,6 +466,17 @@ static int aac_slave_configure(struct scsi_device *sdev)
 			++num_lsu;
 
 		depth = (host->can_queue - num_one) / num_lsu;
+
+		if (sdev_channel(sdev) != NATIVE_CHANNEL)
+			goto common_config;
+
+		/*
+		 * Check if SATA drive
+		 */
+		if (strncmp(sdev->vendor, "ATA", 3) == 0)
+			depth = 32;
+		else
+			depth = 64;
 	}
 
 common_config:
-- 
2.7.4

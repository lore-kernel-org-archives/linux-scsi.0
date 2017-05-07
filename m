From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: [PATCH 04/19] aacraid: Set correct Queue Depth for HBA1000 RAW disks
Date: Sun, 7 May 2017 06:34:09 -0700
Message-ID: <1494164064-17715-5-git-send-email-RaghavaAditya.Renukunta@microsemi.com>
References: <1494164064-17715-1-git-send-email-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam03on0040.outbound.protection.outlook.com ([104.47.42.40]:33492
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752166AbdEGVpP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 7 May 2017 17:45:15 -0400
In-Reply-To: <1494164064-17715-1-git-send-email-RaghavaAditya.Renukunta@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: David.Carroll@microsemi.com, Gana.Sridaran@microsemi.com, Scott.Benesh@microsemi.com, Prasad.Munirathnam@microsemi.com

The default queue depth for non NATIVE RAW disks is calculated from the
number of fibs and number of disks or a max of 256. This causes poor disk
IO performance.

The fix is to set default qd based on the type of disks
(SATA -32 and SAS -64)

Signed-off-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
---
 drivers/scsi/aacraid/linit.c | 28 ++++++++++++++++++++--------
 1 file changed, 20 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 5e1a2d6..9ef98e4 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -405,17 +405,23 @@ static int aac_slave_configure(struct scsi_device *sdev)
 	int chn, tid;
 	unsigned int depth = 0;
 	unsigned int set_timeout = 0;
+	bool set_qd_dev_type = false;
+	u8 devtype = 0;
 
 	chn = aac_logical_to_phys(sdev_channel(sdev));
 	tid = sdev_id(sdev);
-	if (chn < AAC_MAX_BUSES && tid < AAC_MAX_TARGETS &&
-		aac->hba_map[chn][tid].devtype == AAC_DEVTYPE_NATIVE_RAW) {
-		depth = aac->hba_map[chn][tid].qd_limit;
+	if (chn < AAC_MAX_BUSES && tid < AAC_MAX_TARGETS && aac->sa_firmware) {
+		devtype = aac->hba_map[chn][tid].devtype;
+
+		if (devtype == AAC_DEVTYPE_NATIVE_RAW)
+			depth = aac->hba_map[chn][tid].qd_limit;
+		else if (devtype == AAC_DEVTYPE_ARC_RAW)
+			set_qd_dev_type = true;
+
 		set_timeout = 1;
 		goto common_config;
 	}
 
-
 	if (aac->jbod && (sdev->type == TYPE_DISK))
 		sdev->removable = 1;
 
@@ -470,16 +476,22 @@ static int aac_slave_configure(struct scsi_device *sdev)
 		if (sdev_channel(sdev) != NATIVE_CHANNEL)
 			goto common_config;
 
-		/*
-		 * Check if SATA drive
-		 */
+		set_qd_dev_type = true;
+
+	}
+
+common_config:
+
+	/*
+	 * Check if SATA drive
+	 */
+	if (set_qd_dev_type) {
 		if (strncmp(sdev->vendor, "ATA", 3) == 0)
 			depth = 32;
 		else
 			depth = 64;
 	}
 
-common_config:
 	/*
 	 * Firmware has an individual device recovery time typically
 	 * of 35 seconds, give us a margin.
-- 
2.7.4

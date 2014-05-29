From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 2 24/24] hpsa: fix handling of hpsa_volume_offline return value
Date: Thu, 29 May 2014 10:54:25 -0500
Message-ID: <20140529155425.8180.76688.stgit@beardog.cce.hp.com>
References: <20140529154739.8180.50710.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g9t1613g.houston.hp.com ([15.240.0.71]:37917 "EHLO
	g9t1613g.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965177AbaE2Pzw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 29 May 2014 11:55:52 -0400
Received: from g4t3425.houston.hp.com (g4t3425.houston.hp.com [15.201.208.53])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by g9t1613g.houston.hp.com (Postfix) with ESMTPS id 0580561A56
	for <linux-scsi@vger.kernel.org>; Thu, 29 May 2014 15:55:52 +0000 (UTC)
In-Reply-To: <20140529154739.8180.50710.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@parallels.com
Cc: webb.scales@hp.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, justin.lindley@hp.com, stephenmcameron@gmail.com, joseph.t.handzik@hp.com, thenzl@redhat.com, michael.miller@canonical.com, scott.teel@hp.com, hch@lst.de, dan.carpenter@oracle.com

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

Make return value an int instead of an unsigned char so that
we do not lose negative error return values.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Reviewed-by: Webb Scales <webb.scales@hp.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/scsi/hpsa.c     |   12 ++++++++----
 drivers/scsi/hpsa_cmd.h |    2 +-
 2 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index af51e7d..31184b3 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -2543,11 +2543,11 @@ exit_failed:
 /* Determine offline status of a volume.
  * Return either:
  *  0 (not offline)
- * -1 (offline for unknown reasons)
+ *  0xff (offline for unknown reasons)
  *  # (integer code indicating one of several NOT READY states
  *     describing why a volume is to be kept offline)
  */
-static unsigned char hpsa_volume_offline(struct ctlr_info *h,
+static int hpsa_volume_offline(struct ctlr_info *h,
 					unsigned char scsi3addr[])
 {
 	struct CommandList *c;
@@ -2646,11 +2646,15 @@ static int hpsa_update_device_info(struct ctlr_info *h,
 
 	if (this_device->devtype == TYPE_DISK &&
 		is_logical_dev_addr_mode(scsi3addr)) {
+		int volume_offline;
+
 		hpsa_get_raid_level(h, scsi3addr, &this_device->raid_level);
 		if (h->fw_support & MISC_FW_RAID_OFFLOAD_BASIC)
 			hpsa_get_ioaccel_status(h, scsi3addr, this_device);
-		this_device->volume_offline =
-			hpsa_volume_offline(h, scsi3addr);
+		volume_offline = hpsa_volume_offline(h, scsi3addr);
+		if (volume_offline < 0 || volume_offline > 0xff)
+			volume_offline = HPSA_VPD_LV_STATUS_UNSUPPORTED;
+		this_device->volume_offline = volume_offline & 0xff;
 	} else {
 		this_device->raid_level = RAID_UNKNOWN;
 		this_device->offload_config = 0;
diff --git a/drivers/scsi/hpsa_cmd.h b/drivers/scsi/hpsa_cmd.h
index 649b463..b5125dc 100644
--- a/drivers/scsi/hpsa_cmd.h
+++ b/drivers/scsi/hpsa_cmd.h
@@ -151,7 +151,7 @@
 #define HPSA_VPD_HEADER_SZ              4
 
 /* Logical volume states */
-#define HPSA_VPD_LV_STATUS_UNSUPPORTED			-1
+#define HPSA_VPD_LV_STATUS_UNSUPPORTED			0xff
 #define HPSA_LV_OK                                      0x0
 #define HPSA_LV_UNDERGOING_ERASE			0x0F
 #define HPSA_LV_UNDERGOING_RPI				0x12


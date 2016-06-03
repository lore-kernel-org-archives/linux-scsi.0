From: Charles Chiou <ch1102chiou@gmail.com>
Subject: [v2 PATCH 1/3] scsi:stex.c Support to Pegasus series.
Date: Fri,  3 Jun 2016 20:03:58 +0800
Message-ID: <1464955438-16568-1-git-send-email-ch1102chiou@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Charles <charles.chiou@tw.promise.com>
List-Id: linux-scsi@vger.kernel.org

From: Charles <charles.chiou@tw.promise.com>

Pegasus is a high performace hardware RAID solution designed to unleash
the raw power of Thunderbolt technology.

1. Add code to distinct SuperTrack and Pegasus series by sub device ID.
   It should support backward compatibility.

2. Change the driver version.

Signed-off-by: Charles Chiou <charles.chiou@tw.promise.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/stex.c | 32 ++++++++++++++++++++++++++------
 1 file changed, 26 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index 2de28d7..495d632 100644
--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -1,7 +1,7 @@
 /*
  * SuperTrak EX Series Storage Controller driver for Linux
  *
- *	Copyright (C) 2005-2009 Promise Technology Inc.
+ *	Copyright (C) 2005-2015 Promise Technology Inc.
  *
  *	This program is free software; you can redistribute it and/or
  *	modify it under the terms of the GNU General Public License
@@ -38,11 +38,11 @@
 #include <scsi/scsi_eh.h>
 
 #define DRV_NAME "stex"
-#define ST_DRIVER_VERSION "4.6.0000.4"
-#define ST_VER_MAJOR		4
-#define ST_VER_MINOR		6
-#define ST_OEM			0
-#define ST_BUILD_VER		4
+#define ST_DRIVER_VERSION	"5.00.0000.01"
+#define ST_VER_MAJOR		5
+#define ST_VER_MINOR		00
+#define ST_OEM				0000
+#define ST_BUILD_VER		01
 
 enum {
 	/* MU register offset */
@@ -328,6 +328,7 @@ struct st_hba {
 	u16 rq_count;
 	u16 rq_size;
 	u16 sts_count;
+	u8  supports_pm;
 };
 
 struct st_card_info {
@@ -1560,6 +1561,25 @@ static int stex_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	hba->cardtype = (unsigned int) id->driver_data;
 	ci = &stex_card_info[hba->cardtype];
+	switch (id->subdevice) {
+	case 0x4221:
+	case 0x4222:
+	case 0x4223:
+	case 0x4224:
+	case 0x4225:
+	case 0x4226:
+	case 0x4227:
+	case 0x4261:
+	case 0x4262:
+	case 0x4263:
+	case 0x4264:
+	case 0x4265:
+		break;
+	default:
+		if (hba->cardtype == st_yel)
+			hba->supports_pm = 1;
+	}
+
 	sts_offset = scratch_offset = (ci->rq_count+1) * ci->rq_size;
 	if (hba->cardtype == st_yel)
 		sts_offset += (ci->sts_count+1) * sizeof(u32);
-- 
1.9.1

From: Charles Chiou <ch1102chiou@gmail.com>
Subject: [V3 PATCH 1/4] scsi:stex.c Support to Pegasus series.
Date: Wed, 10 Dec 2014 09:27:32 +0800
Message-ID: <5487A184.6000307@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f174.google.com ([209.85.192.174]:62253 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753225AbaLJB1h (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Dec 2014 20:27:37 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linus.chen@tw.promise.com, victor.p@promise.com, grace.chang@tw.promise.com, ed.lin@promise.com

 From 8be76ec282e4e344e88c63d5c1e72c0a8394e703 Mon Sep 17 00:00:00 2001
From: Charles Chiou <charles.chiou@tw.promise.com>
Date: Wed, 5 Nov 2014 14:18:43 +0800
Subject: [PATCH 1/4] scsi:stex.c Support to Pegasus series.

Pegasus is a high performace hardware RAID solution designed to unleash
the raw power of Thunderbolt technology.

1. Add code to distinct SuperTrack and Pegasus series by sub device ID.
    It should support backward compatibility.

2. Change the driver version.

Signed-off-by: charles.chiou@tw.promise.com
---
  drivers/scsi/stex.c | 32 ++++++++++++++++++++++++++------
  1 file changed, 26 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index 1aa4bef..08e7bc8 100644
--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -1,7 +1,7 @@
  /*
   * SuperTrak EX Series Storage Controller driver for Linux
   *
- *	Copyright (C) 2005-2009 Promise Technology Inc.
+ *	Copyright (C) 2005-2014 Promise Technology Inc.
   *
   *	This program is free software; you can redistribute it and/or
   *	modify it under the terms of the GNU General Public License
@@ -37,11 +37,11 @@
  #include <scsi/scsi_eh.h>

  #define DRV_NAME "stex"
-#define ST_DRIVER_VERSION "4.6.0000.4"
-#define ST_VER_MAJOR		4
-#define ST_VER_MINOR		6
-#define ST_OEM			0
-#define ST_BUILD_VER		4
+#define ST_DRIVER_VERSION "5.00.0000.01"
+#define ST_VER_MAJOR		5
+#define ST_VER_MINOR		00
+#define ST_OEM			0000
+#define ST_BUILD_VER		01

  enum {
  	/* MU register offset */
@@ -327,6 +327,7 @@ struct st_hba {
  	u16 rq_count;
  	u16 rq_size;
  	u16 sts_count;
+	u8  supports_pm;
  };

  struct st_card_info {
@@ -1590,6 +1591,25 @@ static int stex_probe(struct pci_dev *pdev, const 
struct pci_device_id *id)

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


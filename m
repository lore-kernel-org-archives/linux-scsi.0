From: Charles Chiou <ch1102chiou@gmail.com>
Subject: [V2 PATCH 1/4] scsi:stex.c Support to Pegasus series.
Date: Wed, 12 Nov 2014 11:26:30 +0800
Message-ID: <5462D366.5030106@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@parallels.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


 From 5fdb4203c09d6896e7b71a8f839e46e84234eeb9 Mon Sep 17 00:00:00 2001
From: Charles Chiou <charles.chiou@tw.promise.com>
Date: Wed, 5 Nov 2014 14:18:43 +0800
Subject: [PATCH 1/4] scsi:stex.c Support to Pegasus series.

Pegasus is a high performace hardware RAID solution designed to unleash
the raw power of Thunderbolt technology.

I add code to distinct SuperTrack and Pegasus series by subID.
It's needed for backward compatibility.

Change the driver version.
---
  drivers/scsi/stex.c | 24 +++++++++++++++++++-----
  1 file changed, 19 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index 1aa4bef..f52f1de 100644
--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
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
+	u8  yellowstone;
  };

  struct st_card_info {
@@ -1546,6 +1547,7 @@ static int stex_probe(struct pci_dev *pdev, const 
struct pci_device_id *id)
  	struct Scsi_Host *host;
  	const struct st_card_info *ci = NULL;
  	u32 sts_offset, cp_offset, scratch_offset;
+	u32 subID;
  	int err;

  	err = pci_enable_device(pdev);
@@ -1590,6 +1592,18 @@ static int stex_probe(struct pci_dev *pdev, const 
struct pci_device_id *id)

  	hba->cardtype = (unsigned int) id->driver_data;
  	ci = &stex_card_info[hba->cardtype];
+	subID = id->subdevice;
+	if ((subID == 0x4221 || subID == 0x4222 ||
+	    subID == 0x4223 || subID == 0x4224 ||
+	    subID == 0x4225 || subID == 0x4226 ||
+	    subID == 0x4227 || subID == 0x4261 ||
+	    subID == 0x4262 || subID == 0x4263 ||
+	    subID == 0x4264 || subID == 0x4265) &&
+	    (hba->cardtype == st_yel)) {
+		hba->yellowstone = 1;
+	} else if (hba->cardtype == st_yel) {
+		hba->yellowstone = 0;
+	}
  	sts_offset = scratch_offset = (ci->rq_count+1) * ci->rq_size;
  	if (hba->cardtype == st_yel)
  		sts_offset += (ci->sts_count+1) * sizeof(u32);
-- 
1.9.1

From: Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH] scsi: atp870u: Replace mdelay() with msleep()
Date: Fri, 27 Jul 2018 17:13:17 +0800
Message-ID: <20180727091317.6976-1-baijiaju1990@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Jia-Ju Bai <baijiaju1990@gmail.com>
List-Id: linux-scsi@vger.kernel.org

tscam(), atp870_init(), atp880_init() and atp885_init() are never 
called in atomic context.
They call mdelay() to busily wait, which is not necessary.
mdelay() can be replaced with msleep().

This is found by a static analysis tool named DCNS written by myself.

Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
---
 drivers/scsi/atp870u.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/atp870u.c b/drivers/scsi/atp870u.c
index b46997cf77e2..8996d2329e11 100644
--- a/drivers/scsi/atp870u.c
+++ b/drivers/scsi/atp870u.c
@@ -1055,7 +1055,7 @@ static void tscam(struct Scsi_Host *host, bool wide_chip, u8 scam_on)
 	udelay(2);		/* 2 deskew delay(45ns*2=90ns) */
 	val &= 0x007f;		/* no bsy  */
 	atp_writew_io(dev, 0, 0x1c, val);
-	mdelay(128);
+	msleep(128);
 	val &= 0x00fb;		/* after 1ms no msg */
 	atp_writew_io(dev, 0, 0x1c, val);
 	while ((atp_readb_io(dev, 0, 0x1c) & 0x04) != 0)
@@ -1286,9 +1286,9 @@ static void atp870_init(struct Scsi_Host *shpnt)
 	k = (atp_readb_base(atpdev, 0x3a) & 0xf3) | 0x10;
 	atp_writeb_base(atpdev, 0x3a, k);
 	atp_writeb_base(atpdev, 0x3a, k & 0xdf);
-	mdelay(32);
+	msleep(32);
 	atp_writeb_base(atpdev, 0x3a, k);
-	mdelay(32);
+	msleep(32);
 	atp_set_host_id(atpdev, 0, host_id);
 
 	tscam(shpnt, wide_chip, scam_on);
@@ -1370,9 +1370,9 @@ static void atp880_init(struct Scsi_Host *shpnt)
 	k = atp_readb_base(atpdev, 0x38) & 0x80;
 	atp_writeb_base(atpdev, 0x38, k);
 	atp_writeb_base(atpdev, 0x3b, 0x20);
-	mdelay(32);
+	msleep(32);
 	atp_writeb_base(atpdev, 0x3b, 0);
-	mdelay(32);
+	msleep(32);
 	atp_readb_io(atpdev, 0, 0x1b);
 	atp_readb_io(atpdev, 0, 0x17);
 
@@ -1454,10 +1454,10 @@ static void atp885_init(struct Scsi_Host *shpnt)
 	atp_writeb_base(atpdev, 0x28, k);
 	atp_writeb_pci(atpdev, 0, 1, 0x80);
 	atp_writeb_pci(atpdev, 1, 1, 0x80);
-	mdelay(100);
+	msleep(100);
 	atp_writeb_pci(atpdev, 0, 1, 0);
 	atp_writeb_pci(atpdev, 1, 1, 0);
-	mdelay(1000);
+	msleep(1000);
 	atp_readb_io(atpdev, 0, 0x1b);
 	atp_readb_io(atpdev, 0, 0x17);
 	atp_readb_io(atpdev, 1, 0x1b);
@@ -1473,7 +1473,7 @@ static void atp885_init(struct Scsi_Host *shpnt)
 		k = (k & 0x07) | 0x40;
 	atp_set_host_id(atpdev, 1, k);
 
-	mdelay(600); /* this delay used to be called tscam_885() */
+	msleep(600); /* this delay used to be called tscam_885() */
 	dev_info(&pdev->dev, "Scanning Channel A SCSI Device ...\n");
 	atp_is(atpdev, 0, true, atp_readb_io(atpdev, 0, 0x1b) >> 7);
 	atp_writeb_io(atpdev, 0, 0x16, 0x80);
-- 
2.17.0

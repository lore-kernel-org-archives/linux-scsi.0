From: Ondrej Zary <linux@rainbow-software.org>
Subject: [PATCH 26/52] atp870u: Add wide_chip parameter to is870() and is885()
Date: Tue, 17 Nov 2015 19:24:02 +0100
Message-ID: <1447784668-23713-27-git-send-email-linux@rainbow-software.org>
References: <1447784668-23713-1-git-send-email-linux@rainbow-software.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.gsystem.sk ([62.176.172.50]:56484 "EHLO gsystem.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752301AbbKQSgK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Nov 2015 13:36:10 -0500
In-Reply-To: <1447784668-23713-1-git-send-email-linux@rainbow-software.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

Don't check chip_ver in is870() but add wide_chip parameter for that.
Then add the non-wide support to is885().

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/scsi/atp870u.c |   46 +++++++++++++++++++++++++---------------------
 1 file changed, 25 insertions(+), 21 deletions(-)

diff --git a/drivers/scsi/atp870u.c b/drivers/scsi/atp870u.c
index d10026a..0548d07 100644
--- a/drivers/scsi/atp870u.c
+++ b/drivers/scsi/atp870u.c
@@ -41,7 +41,7 @@
 
 static struct scsi_host_template atp870u_template;
 static void send_s870(struct atp_unit *dev,unsigned char c);
-static void is885(struct atp_unit *dev, unsigned char c, unsigned char lvdmode);
+static void is885(struct atp_unit *dev, unsigned char c, bool wide_chip, unsigned char lvdmode);
 static void tscam_885(void);
 
 static inline void atp_writeb_base(struct atp_unit *atp, u8 reg, u8 val)
@@ -1162,7 +1162,7 @@ static void tscam(struct Scsi_Host *host)
 	}
 }
 
-static void is870(struct atp_unit *dev, unsigned char c)
+static void is870(struct atp_unit *dev, unsigned char c, bool wide_chip)
 {
 	unsigned char i, j, k, rmb, n;
 	unsigned short int m;
@@ -1177,9 +1177,8 @@ static void is870(struct atp_unit *dev, unsigned char c)
 	atp_writeb_io(dev, c, 0x3a, atp_readb_io(dev, c, 0x3a) | 0x10);
 
 	for (i = 0; i < 16; i++) {
-		if ((dev->chip_ver != 4) && (i > 7)) {
+		if (!wide_chip && (i > 7))
 			break;
-		}
 		m = 1;
 		m = m << i;
 		if ((m & dev->active_id[c]) != 0) {
@@ -1189,11 +1188,7 @@ static void is870(struct atp_unit *dev, unsigned char c)
 			printk(KERN_INFO "         ID: %2d  Host Adapter\n", dev->host_id[c]);
 			continue;
 		}
-		if (dev->chip_ver == 4) {
-			atp_writeb_io(dev, c, 0x1b, 0x01);
-		} else {
-			atp_writeb_io(dev, c, 0x1b, 0x00);
-		}
+		atp_writeb_io(dev, c, 0x1b, wide_chip ? 0x01 : 0x00);
 		atp_writeb_io(dev, c, 1, 0x08);
 		atp_writeb_io(dev, c, 2, 0x7f);
 		atp_writeb_io(dev, c, 3, satn[0]);
@@ -1262,7 +1257,7 @@ sel_ok:
 		while (atp_readb_io(dev, c, 0x17) != 0x8e)
 			cpu_relax();
 
-		if (dev->chip_ver == 4)
+		if (wide_chip)
 			atp_writeb_io(dev, c, 0x1b, 0x00);
 
 		atp_writeb_io(dev, c, 0x18, 0x08);
@@ -1298,9 +1293,8 @@ inq_ok:
 		dev->id[c][i].devtype = mbuf[0];
 		rmb = mbuf[1];
 		n = mbuf[7];
-		if (dev->chip_ver != 4) {
+		if (!wide_chip)
 			goto not_wide;
-		}
 		if ((mbuf[7] & 0x60) == 0) {
 			goto not_wide;
 		}
@@ -1807,7 +1801,7 @@ flash_ok_880:
 		outb(0x20, base_io + 0x51);
 
 		tscam(shpnt);
-		is885(p, 0, atp_readb_base(p, 0x3f) & 0x40);
+		is885(p, 0, true, atp_readb_base(p, 0x3f) & 0x40);
 		outb(0xb0, base_io + 0x38);
 		shpnt->max_id = 16;
 		shpnt->this_id = host_id;
@@ -1953,10 +1947,10 @@ flash_ok_885:
 
 		tscam_885();
 		printk(KERN_INFO "   Scanning Channel A SCSI Device ...\n");
-		is885(p, 0, atp_readb_io(p, 0, 0x1b) >> 7);
+		is885(p, 0, true, atp_readb_io(p, 0, 0x1b) >> 7);
 		atp_writeb_io(p, 0, 0x16, 0x80);
 		printk(KERN_INFO "   Scanning Channel B SCSI Device ...\n");
-		is885(p, 1, atp_readb_io(p, 1, 0x1b) >> 7);
+		is885(p, 1, true, atp_readb_io(p, 1, 0x1b) >> 7);
 		atp_writeb_io(p, 1, 0x16, 0x80);
 		k = inb(base_io + 0x28) & 0xcf;
 		k |= 0xc0;
@@ -2038,7 +2032,7 @@ flash_ok_885:
 		outb(0x20, base_io + 0x11);
 
 		tscam(shpnt);
-		is870(p, 0);
+		is870(p, 0, p->chip_ver == 4);
 		outb((inb(base_io + 0x3a) & 0xef), base_io + 0x3a);
 		outb((inb(base_io + 0x3b) | 0x20), base_io + 0x3b);
 		if (atpdev->chip_ver == 4)
@@ -2258,7 +2252,7 @@ static void tscam_885(void)
 
 
 
-static void is885(struct atp_unit *dev, unsigned char c, unsigned char lvdmode)
+static void is885(struct atp_unit *dev, unsigned char c, bool wide_chip, unsigned char lvdmode)
 {
 	unsigned char i, j, k, rmb, n;
 	unsigned short int m;
@@ -2273,6 +2267,8 @@ static void is885(struct atp_unit *dev, unsigned char c, unsigned char lvdmode)
 	static unsigned char u3[9] = { 0x80, 1, 6, 4, 0x09, 00, 0x0e, 0x01, 0x02 };
 
 	for (i = 0; i < 16; i++) {
+		if (!wide_chip && (i > 7))
+			break;
 		m = 1;
 		m = m << i;
 		if ((m & dev->active_id[c]) != 0) {
@@ -2282,7 +2278,7 @@ static void is885(struct atp_unit *dev, unsigned char c, unsigned char lvdmode)
 			printk(KERN_INFO "         ID: %2d  Host Adapter\n", dev->host_id[c]);
 			continue;
 		}
-		atp_writeb_io(dev, c, 0x1b, 0x01);
+		atp_writeb_io(dev, c, 0x1b, wide_chip ? 0x01 : 0x00);
 		atp_writeb_io(dev, c, 1, 0x08);
 		atp_writeb_io(dev, c, 2, 0x7f);
 		atp_writeb_io(dev, c, 3, satn[0]);
@@ -2351,7 +2347,9 @@ sel_ok:
 		while (atp_readb_io(dev, c, 0x17) != 0x8e)
 			cpu_relax();
 
-		atp_writeb_io(dev, c, 0x1b, 0x00);
+		if (wide_chip)
+			atp_writeb_io(dev, c, 0x1b, 0x00);
+
 		atp_writeb_io(dev, c, 0x18, 0x08);
 		j = 0;
 rd_inq_data:
@@ -2385,11 +2383,17 @@ inq_ok:
 		dev->id[c][i].devtype = mbuf[0];
 		rmb = mbuf[1];
 		n = mbuf[7];
+		if (!wide_chip)
+			goto not_wide;
 		if ((mbuf[7] & 0x60) == 0) {
 			goto not_wide;
 		}
-		if ((i < 8) && ((dev->global_map[c] & 0x20) == 0)) {
-			goto not_wide;
+		if (dev->dev_id == ATP885_DEVID || dev->dev_id == ATP880_DEVID1 || dev->dev_id == ATP880_DEVID2) {
+			if ((i < 8) && ((dev->global_map[c] & 0x20) == 0))
+				goto not_wide;
+		} else { /* result of is870() merge - is this a bug? */
+			if ((dev->global_map[c] & 0x20) == 0)
+				goto not_wide;
 		}
 		if (lvdmode == 0) {
 			goto chg_wide;
-- 
Ondrej Zary


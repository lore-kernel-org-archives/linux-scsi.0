From: Ondrej Zary <linux@rainbow-software.org>
Subject: [PATCH 30/52] atp870u: Rename is885() to atp_is()
Date: Tue, 17 Nov 2015 19:24:06 +0100
Message-ID: <1447784668-23713-31-git-send-email-linux@rainbow-software.org>
References: <1447784668-23713-1-git-send-email-linux@rainbow-software.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.gsystem.sk ([62.176.172.50]:56481 "EHLO gsystem.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752301AbbKQSgG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Nov 2015 13:36:06 -0500
In-Reply-To: <1447784668-23713-1-git-send-email-linux@rainbow-software.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

Now that all the is* functions except is885() are gone, rename is885() to
atp_is() to avoid confusion. Don't know what "is" means, though...

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/scsi/atp870u.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/atp870u.c b/drivers/scsi/atp870u.c
index 918875b..0b7d3bd 100644
--- a/drivers/scsi/atp870u.c
+++ b/drivers/scsi/atp870u.c
@@ -41,7 +41,7 @@
 
 static struct scsi_host_template atp870u_template;
 static void send_s870(struct atp_unit *dev,unsigned char c);
-static void is885(struct atp_unit *dev, unsigned char c, bool wide_chip, unsigned char lvdmode);
+static void atp_is(struct atp_unit *dev, unsigned char c, bool wide_chip, unsigned char lvdmode);
 static void tscam_885(void);
 
 static inline void atp_writeb_base(struct atp_unit *atp, u8 reg, u8 val)
@@ -1373,7 +1373,7 @@ flash_ok_880:
 		outb(0x20, base_io + 0x51);
 
 		tscam(shpnt);
-		is885(p, 0, true, atp_readb_base(p, 0x3f) & 0x40);
+		atp_is(p, 0, true, atp_readb_base(p, 0x3f) & 0x40);
 		outb(0xb0, base_io + 0x38);
 		shpnt->max_id = 16;
 		shpnt->this_id = host_id;
@@ -1519,10 +1519,10 @@ flash_ok_885:
 
 		tscam_885();
 		printk(KERN_INFO "   Scanning Channel A SCSI Device ...\n");
-		is885(p, 0, true, atp_readb_io(p, 0, 0x1b) >> 7);
+		atp_is(p, 0, true, atp_readb_io(p, 0, 0x1b) >> 7);
 		atp_writeb_io(p, 0, 0x16, 0x80);
 		printk(KERN_INFO "   Scanning Channel B SCSI Device ...\n");
-		is885(p, 1, true, atp_readb_io(p, 1, 0x1b) >> 7);
+		atp_is(p, 1, true, atp_readb_io(p, 1, 0x1b) >> 7);
 		atp_writeb_io(p, 1, 0x16, 0x80);
 		k = inb(base_io + 0x28) & 0xcf;
 		k |= 0xc0;
@@ -1605,7 +1605,7 @@ flash_ok_885:
 
 		tscam(shpnt);
 		atp_writeb_io(p, 0, 0x3a, atp_readb_io(p, 0, 0x3a) | 0x10);
-		is885(p, 0, p->chip_ver == 4, 0);
+		atp_is(p, 0, p->chip_ver == 4, 0);
 		atp_writeb_io(p, 0, 0x3a, atp_readb_io(p, 0, 0x3a) & 0xef);
 		outb((inb(base_io + 0x3a) & 0xef), base_io + 0x3a);
 		outb((inb(base_io + 0x3b) | 0x20), base_io + 0x3b);
@@ -1826,7 +1826,7 @@ static void tscam_885(void)
 
 
 
-static void is885(struct atp_unit *dev, unsigned char c, bool wide_chip, unsigned char lvdmode)
+static void atp_is(struct atp_unit *dev, unsigned char c, bool wide_chip, unsigned char lvdmode)
 {
 	unsigned char i, j, k, rmb, n;
 	unsigned short int m;
-- 
Ondrej Zary


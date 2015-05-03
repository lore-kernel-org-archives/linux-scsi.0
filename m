From: Ondrej Zary <linux@rainbow-software.org>
Subject: [PATCH 30/34] atp870u: Rename is885() to atp_is()
Date: Sun,  3 May 2015 19:31:46 +0200
Message-ID: <1430674310-11576-31-git-send-email-linux@rainbow-software.org>
References: <1430674310-11576-1-git-send-email-linux@rainbow-software.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.gsystem.sk ([62.176.172.50]:36061 "EHLO gsystem.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751330AbbECRwJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 3 May 2015 13:52:09 -0400
Received: from stip-static-68.213-81-217.telecom.sk ([213.81.217.68] helo=gsql.ggedos.sk)
	by gsystem.sk with esmtpsa (TLS1.1:DHE_RSA_AES_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <linux@rainbow-software.org>)
	id 1YoxkO-0000Ql-Rr
	for linux-scsi@vger.kernel.org; Sun, 03 May 2015 19:32:08 +0200
In-Reply-To: <1430674310-11576-1-git-send-email-linux@rainbow-software.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Now that all the is* functions except is885() are gone, rename is885() to
atp_is() to avoid confusion. Don't know what "is" means, though...

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/scsi/atp870u.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/atp870u.c b/drivers/scsi/atp870u.c
index c145721..b5baf41 100644
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
@@ -1827,7 +1827,7 @@ static void tscam_885(void)
 
 
 
-static void is885(struct atp_unit *dev, unsigned char c, bool wide_chip, unsigned char lvdmode)
+static void atp_is(struct atp_unit *dev, unsigned char c, bool wide_chip, unsigned char lvdmode)
 {
 	unsigned char i, j, k, rmb, n;
 	unsigned short int m;
-- 
Ondrej Zary


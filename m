From: Ondrej Zary <linux@rainbow-software.org>
Subject: [PATCH 24/52] atp870u: Move chip-specific lines out of is880() and is885()
Date: Tue, 17 Nov 2015 19:24:00 +0100
Message-ID: <1447784668-23713-25-git-send-email-linux@rainbow-software.org>
References: <1447784668-23713-1-git-send-email-linux@rainbow-software.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.gsystem.sk ([62.176.172.50]:56584 "EHLO gsystem.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754544AbbKQSiH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Nov 2015 13:38:07 -0500
In-Reply-To: <1447784668-23713-1-git-send-email-linux@rainbow-software.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

Move few chip-specifis lines out of is880() and is885() so they become
almost identical.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/scsi/atp870u.c |   24 ++++++++++--------------
 1 file changed, 10 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/atp870u.c b/drivers/scsi/atp870u.c
index ec61902..1c4b1f9 100644
--- a/drivers/scsi/atp870u.c
+++ b/drivers/scsi/atp870u.c
@@ -41,7 +41,7 @@
 
 static struct scsi_host_template atp870u_template;
 static void send_s870(struct atp_unit *dev,unsigned char c);
-static void is885(struct atp_unit *dev, unsigned char c);
+static void is885(struct atp_unit *dev, unsigned char c, unsigned char lvdmode);
 static void tscam_885(void);
 
 static inline void atp_writeb_base(struct atp_unit *atp, u8 reg, u8 val)
@@ -1596,9 +1596,9 @@ set_syn_ok:
 	atp_writeb_io(dev, c, 0x3a, atp_readb_io(dev, c, 0x3a) & 0xef);
 }
 
-static void is880(struct atp_unit *dev, unsigned char c)
+static void is880(struct atp_unit *dev, unsigned char c, unsigned char lvdmode)
 {
-	unsigned char i, j, k, rmb, n, lvdmode;
+	unsigned char i, j, k, rmb, n;
 	unsigned short int m;
 	static unsigned char mbuf[512];
 	static unsigned char satn[9] = { 0, 0, 0, 0, 0, 0, 0, 6, 6 };
@@ -1610,8 +1610,6 @@ static void is880(struct atp_unit *dev, unsigned char c)
 	static unsigned char wide[6] = { 0x80, 1, 2, 3, 1, 0 };
 	static unsigned char u3[9] = { 0x80, 1, 6, 4, 0x09, 00, 0x0e, 0x01, 0x02 };
 
-	lvdmode = atp_readb_base(dev, 0x3f) & 0x40;
-
 	for (i = 0; i < 16; i++) {
 		m = 1;
 		m = m << i;
@@ -2379,7 +2377,7 @@ flash_ok_880:
 		outb(0x20, base_io + 0x51);
 
 		tscam(shpnt);
-		is880(p, 0);
+		is880(p, 0, atp_readb_base(p, 0x3f) & 0x40);
 		outb(0xb0, base_io + 0x38);
 		shpnt->max_id = 16;
 		shpnt->this_id = host_id;
@@ -2525,10 +2523,11 @@ flash_ok_885:
 
 		tscam_885();
 		printk(KERN_INFO "   Scanning Channel A SCSI Device ...\n");
-		is885(p, 0);
+		is885(p, 0, atp_readb_io(p, 0, 0x1b) >> 7);
+		atp_writeb_io(p, 0, 0x16, 0x80);
 		printk(KERN_INFO "   Scanning Channel B SCSI Device ...\n");
-		is885(p, 1);
-
+		is885(p, 1, atp_readb_io(p, 1, 0x1b) >> 7);
+		atp_writeb_io(p, 1, 0x16, 0x80);
 		k = inb(base_io + 0x28) & 0xcf;
 		k |= 0xc0;
 		outb(k, base_io + 0x28);
@@ -2829,9 +2828,9 @@ static void tscam_885(void)
 
 
 
-static void is885(struct atp_unit *dev, unsigned char c)
+static void is885(struct atp_unit *dev, unsigned char c, unsigned char lvdmode)
 {
-	unsigned char i, j, k, rmb, n, lvdmode;
+	unsigned char i, j, k, rmb, n;
 	unsigned short int m;
 	static unsigned char mbuf[512];
 	static unsigned char satn[9] = { 0, 0, 0, 0, 0, 0, 0, 6, 6 };
@@ -2843,8 +2842,6 @@ static void is885(struct atp_unit *dev, unsigned char c)
 	static unsigned char wide[6] = { 0x80, 1, 2, 3, 1, 0 };
 	static unsigned char u3[9] = { 0x80, 1, 6, 4, 0x09, 00, 0x0e, 0x01, 0x02 };
 
-	lvdmode = atp_readb_io(dev, c, 0x1b) >> 7;
-
 	for (i = 0; i < 16; i++) {
 		m = 1;
 		m = m << i;
@@ -3408,7 +3405,6 @@ set_syn_ok:
 		printk("dev->id[%2d][%2d].devsp = %2x\n",c,i,dev->id[c][i].devsp);
 #endif
 	}
-	atp_writeb_io(dev, c, 0x16, 0x80);
 }
 
 module_init(atp870u_init);
-- 
Ondrej Zary


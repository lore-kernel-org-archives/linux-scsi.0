From: Ondrej Zary <linux@rainbow-software.org>
Subject: [PATCH 21/52] atp870u: Convert is885() to use wrappers
Date: Tue, 17 Nov 2015 19:23:57 +0100
Message-ID: <1447784668-23713-22-git-send-email-linux@rainbow-software.org>
References: <1447784668-23713-1-git-send-email-linux@rainbow-software.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.gsystem.sk ([62.176.172.50]:56490 "EHLO gsystem.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752301AbbKQSgP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Nov 2015 13:36:15 -0500
In-Reply-To: <1447784668-23713-1-git-send-email-linux@rainbow-software.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/scsi/atp870u.c |  358 ++++++++++++++++++++++++------------------------
 1 file changed, 179 insertions(+), 179 deletions(-)

diff --git a/drivers/scsi/atp870u.c b/drivers/scsi/atp870u.c
index 1b9276f..ad7af54 100644
--- a/drivers/scsi/atp870u.c
+++ b/drivers/scsi/atp870u.c
@@ -41,7 +41,7 @@
 
 static struct scsi_host_template atp870u_template;
 static void send_s870(struct atp_unit *dev,unsigned char c);
-static void is885(struct atp_unit *dev, unsigned int wkport,unsigned char c);
+static void is885(struct atp_unit *dev, unsigned char c);
 static void tscam_885(void);
 
 static inline void atp_writeb_base(struct atp_unit *atp, u8 reg, u8 val)
@@ -2521,9 +2521,9 @@ flash_ok_885:
 
 		tscam_885();
 		printk(KERN_INFO "   Scanning Channel A SCSI Device ...\n");
-		is885(p, base_io + 0x80, 0);
+		is885(p, 0);
 		printk(KERN_INFO "   Scanning Channel B SCSI Device ...\n");
-		is885(p, base_io + 0xc0, 1);
+		is885(p, 1);
 
 		k = inb(base_io + 0x28) & 0xcf;
 		k |= 0xc0;
@@ -2825,7 +2825,7 @@ static void tscam_885(void)
 
 
 
-static void is885(struct atp_unit *dev, unsigned int wkport,unsigned char c)
+static void is885(struct atp_unit *dev, unsigned char c)
 {
 	unsigned char i, j, k, rmb, n, lvdmode;
 	unsigned short int m;
@@ -2839,7 +2839,7 @@ static void is885(struct atp_unit *dev, unsigned int wkport,unsigned char c)
 	static unsigned char wide[6] =	{0x80, 1, 2, 3, 1, 0};
 	static unsigned char u3[9] = { 0x80,1,6,4,0x09,00,0x0e,0x01,0x02 };
 
-	lvdmode=inb(wkport + 0x1b) >> 7;
+	lvdmode=atp_readb_io(dev, c, 0x1b) >> 7;
 
 	for (i = 0; i < 16; i++) {
 		m = 1;
@@ -2851,93 +2851,93 @@ static void is885(struct atp_unit *dev, unsigned int wkport,unsigned char c)
 			printk(KERN_INFO "         ID: %2d  Host Adapter\n", dev->host_id[c]);
 			continue;
 		}
-		outb(0x01, wkport + 0x1b);
-		outb(0x08, wkport + 0x01);
-		outb(0x7f, wkport + 0x02);
-		outb(satn[0], wkport + 0x03);
-		outb(satn[1], wkport + 0x04);
-		outb(satn[2], wkport + 0x05);
-		outb(satn[3], wkport + 0x06);
-		outb(satn[4], wkport + 0x07);
-		outb(satn[5], wkport + 0x08);
-		outb(0, wkport + 0x0f);
-		outb(dev->id[c][i].devsp, wkport + 0x11);
+		atp_writeb_io(dev, c, 0x1b, 0x01);
+		atp_writeb_io(dev, c, 1, 0x08);
+		atp_writeb_io(dev, c, 2, 0x7f);
+		atp_writeb_io(dev, c, 3, satn[0]);
+		atp_writeb_io(dev, c, 4, satn[1]);
+		atp_writeb_io(dev, c, 5, satn[2]);
+		atp_writeb_io(dev, c, 6, satn[3]);
+		atp_writeb_io(dev, c, 7, satn[4]);
+		atp_writeb_io(dev, c, 8, satn[5]);
+		atp_writeb_io(dev, c, 0x0f, 0);
+		atp_writeb_io(dev, c, 0x11, dev->id[c][i].devsp);
 		
-		outb(0, wkport + 0x12);
-		outb(satn[6], wkport + 0x13);
-		outb(satn[7], wkport + 0x14);
+		atp_writeb_io(dev, c, 0x12, 0);
+		atp_writeb_io(dev, c, 0x13, satn[6]);
+		atp_writeb_io(dev, c, 0x14, satn[7]);
 		j = i;
 		if ((j & 0x08) != 0) {
 			j = (j & 0x07) | 0x40;
 		}
-		outb(j, wkport + 0x15);
-		outb(satn[8], wkport + 0x18);
+		atp_writeb_io(dev, c, 0x15, j);
+		atp_writeb_io(dev, c, 0x18, satn[8]);
 
-		while ((inb(wkport + 0x1f) & 0x80) == 0x00)
+		while ((atp_readb_io(dev, c, 0x1f) & 0x80) == 0x00)
 			cpu_relax();
-		if ((inb(wkport + 0x17) != 0x11) && (inb(wkport + 0x17) != 0x8e)) {
+		if ((atp_readb_io(dev, c, 0x17) != 0x11) && (atp_readb_io(dev, c, 0x17) != 0x8e)) {
 			continue;
 		}
-		while (inb(wkport + 0x17) != 0x8e)
+		while (atp_readb_io(dev, c, 0x17) != 0x8e)
 			cpu_relax();
 		dev->active_id[c] |= m;
 
-		outb(0x30, wkport + 0x10);
-		outb(0x00, wkport + 0x14);
+		atp_writeb_io(dev, c, 0x10, 0x30);
+		atp_writeb_io(dev, c, 0x14, 0x00);
 
 phase_cmd:
-		outb(0x08, wkport + 0x18);
-		while ((inb(wkport + 0x1f) & 0x80) == 0x00)
+		atp_writeb_io(dev, c, 0x18, 0x08);
+		while ((atp_readb_io(dev, c, 0x1f) & 0x80) == 0x00)
 			cpu_relax();
-		j = inb(wkport + 0x17);
+		j = atp_readb_io(dev, c, 0x17);
 		if (j != 0x16) {
-			outb(0x41, wkport + 0x10);
+			atp_writeb_io(dev, c, 0x10, 0x41);
 			goto phase_cmd;
 		}
 sel_ok:
-		outb(inqd[0], wkport + 0x03);
-		outb(inqd[1], wkport + 0x04);
-		outb(inqd[2], wkport + 0x05);
-		outb(inqd[3], wkport + 0x06);
-		outb(inqd[4], wkport + 0x07);
-		outb(inqd[5], wkport + 0x08);
-		outb(0, wkport + 0x0f);
-		outb(dev->id[c][i].devsp, wkport + 0x11);
-		outb(0, wkport + 0x12);
-		outb(inqd[6], wkport + 0x13);
-		outb(inqd[7], wkport + 0x14);
-		outb(inqd[8], wkport + 0x18);
-		while ((inb(wkport + 0x1f) & 0x80) == 0x00)
+		atp_writeb_io(dev, c, 3, inqd[0]);
+		atp_writeb_io(dev, c, 4, inqd[1]);
+		atp_writeb_io(dev, c, 5, inqd[2]);
+		atp_writeb_io(dev, c, 6, inqd[3]);
+		atp_writeb_io(dev, c, 7, inqd[4]);
+		atp_writeb_io(dev, c, 8, inqd[5]);
+		atp_writeb_io(dev, c, 0x0f, 0);
+		atp_writeb_io(dev, c, 0x11, dev->id[c][i].devsp);
+		atp_writeb_io(dev, c, 0x12, 0);
+		atp_writeb_io(dev, c, 0x13, inqd[6]);
+		atp_writeb_io(dev, c, 0x14, inqd[7]);
+		atp_writeb_io(dev, c, 0x18, inqd[8]);
+		while ((atp_readb_io(dev, c, 0x1f) & 0x80) == 0x00)
 			cpu_relax();
-		if ((inb(wkport + 0x17) != 0x11) && (inb(wkport + 0x17) != 0x8e)) {
+		if ((atp_readb_io(dev, c, 0x17) != 0x11) && (atp_readb_io(dev, c, 0x17) != 0x8e)) {
 			continue;
 		}
-		while (inb(wkport + 0x17) != 0x8e)
+		while (atp_readb_io(dev, c, 0x17) != 0x8e)
 			cpu_relax();
-		outb(0x00, wkport + 0x1b);
-		outb(0x08, wkport + 0x18);
+		atp_writeb_io(dev, c, 0x1b, 0x00);
+		atp_writeb_io(dev, c, 0x18, 0x08);
 		j = 0;
 rd_inq_data:
-		k = inb(wkport + 0x1f);
+		k = atp_readb_io(dev, c, 0x1f);
 		if ((k & 0x01) != 0) {
-			mbuf[j++] = inb(wkport + 0x19);
+			mbuf[j++] = atp_readb_io(dev, c, 0x19);
 			goto rd_inq_data;
 		}
 		if ((k & 0x80) == 0) {
 			goto rd_inq_data;
 		}
-		j = inb(wkport + 0x17);
+		j = atp_readb_io(dev, c, 0x17);
 		if (j == 0x16) {
 			goto inq_ok;
 		}
-		outb(0x46, wkport + 0x10);
-		outb(0, wkport + 0x12);
-		outb(0, wkport + 0x13);
-		outb(0, wkport + 0x14);
-		outb(0x08, wkport + 0x18);
-		while ((inb(wkport + 0x1f) & 0x80) == 0x00)
+		atp_writeb_io(dev, c, 0x10, 0x46);
+		atp_writeb_io(dev, c, 0x12, 0);
+		atp_writeb_io(dev, c, 0x13, 0);
+		atp_writeb_io(dev, c, 0x14, 0);
+		atp_writeb_io(dev, c, 0x18, 0x08);
+		while ((atp_readb_io(dev, c, 0x1f) & 0x80) == 0x00)
 			cpu_relax();
-		if (inb(wkport + 0x17) != 0x16) {
+		if (atp_readb_io(dev, c, 0x17) != 0x16) {
 			goto sel_ok;
 		}
 inq_ok:
@@ -2959,40 +2959,40 @@ inq_ok:
 		   goto chg_wide;
 		}
 
-		outb(0x01, wkport + 0x1b);
-		outb(satn[0], wkport + 0x03);
-		outb(satn[1], wkport + 0x04);
-		outb(satn[2], wkport + 0x05);
-		outb(satn[3], wkport + 0x06);
-		outb(satn[4], wkport + 0x07);
-		outb(satn[5], wkport + 0x08);
-		outb(0, wkport + 0x0f);
-		outb(dev->id[c][i].devsp, wkport + 0x11);
-		outb(0, wkport + 0x12);
-		outb(satn[6], wkport + 0x13);
-		outb(satn[7], wkport + 0x14);
-		outb(satn[8], wkport + 0x18);
-
-		while ((inb(wkport + 0x1f) & 0x80) == 0x00)
+		atp_writeb_io(dev, c, 0x1b, 0x01);
+		atp_writeb_io(dev, c, 3, satn[0]);
+		atp_writeb_io(dev, c, 4, satn[1]);
+		atp_writeb_io(dev, c, 5, satn[2]);
+		atp_writeb_io(dev, c, 6, satn[3]);
+		atp_writeb_io(dev, c, 7, satn[4]);
+		atp_writeb_io(dev, c, 8, satn[5]);
+		atp_writeb_io(dev, c, 0x0f, 0);
+		atp_writeb_io(dev, c, 0x11, dev->id[c][i].devsp);
+		atp_writeb_io(dev, c, 0x12, 0);
+		atp_writeb_io(dev, c, 0x13, satn[6]);
+		atp_writeb_io(dev, c, 0x14, satn[7]);
+		atp_writeb_io(dev, c, 0x18, satn[8]);
+
+		while ((atp_readb_io(dev, c, 0x1f) & 0x80) == 0x00)
 			cpu_relax();
-		if ((inb(wkport + 0x17) != 0x11) && (inb(wkport + 0x17) != 0x8e)) {
+		if ((atp_readb_io(dev, c, 0x17) != 0x11) && (atp_readb_io(dev, c, 0x17) != 0x8e)) {
 			continue;
 		}
-		while (inb(wkport + 0x17) != 0x8e)
+		while (atp_readb_io(dev, c, 0x17) != 0x8e)
 			cpu_relax();
 try_u3:
 		j = 0;
-		outb(0x09, wkport + 0x14);
-		outb(0x20, wkport + 0x18);
+		atp_writeb_io(dev, c, 0x14, 0x09);
+		atp_writeb_io(dev, c, 0x18, 0x20);
 
-		while ((inb(wkport + 0x1f) & 0x80) == 0) {
-			if ((inb(wkport + 0x1f) & 0x01) != 0)
-				outb(u3[j++], wkport + 0x19);
+		while ((atp_readb_io(dev, c, 0x1f) & 0x80) == 0) {
+			if ((atp_readb_io(dev, c, 0x1f) & 0x01) != 0)
+				atp_writeb_io(dev, c, 0x19, u3[j++]);
 			cpu_relax();
 		}
-		while ((inb(wkport + 0x17) & 0x80) == 0x00)
+		while ((atp_readb_io(dev, c, 0x17) & 0x80) == 0x00)
 			cpu_relax();
-		j = inb(wkport + 0x17) & 0x0f;
+		j = atp_readb_io(dev, c, 0x17) & 0x0f;
 		if (j == 0x0f) {
 			goto u3p_in;
 		}
@@ -3004,13 +3004,13 @@ try_u3:
 		}
 		continue;
 u3p_out:
-		outb(0x20, wkport + 0x18);
-		while ((inb(wkport + 0x1f) & 0x80) == 0) {
-			if ((inb(wkport + 0x1f) & 0x01) != 0)
-				outb(0, wkport + 0x19);
+		atp_writeb_io(dev, c, 0x18, 0x20);
+		while ((atp_readb_io(dev, c, 0x1f) & 0x80) == 0) {
+			if ((atp_readb_io(dev, c, 0x1f) & 0x01) != 0)
+				atp_writeb_io(dev, c, 0x19, 0);
 			cpu_relax();
 		}
-		j = inb(wkport + 0x17) & 0x0f;
+		j = atp_readb_io(dev, c, 0x17) & 0x0f;
 		if (j == 0x0f) {
 			goto u3p_in;
 		}
@@ -3022,19 +3022,19 @@ u3p_out:
 		}
 		continue;
 u3p_in:
-		outb(0x09, wkport + 0x14);
-		outb(0x20, wkport + 0x18);
+		atp_writeb_io(dev, c, 0x14, 0x09);
+		atp_writeb_io(dev, c, 0x18, 0x20);
 		k = 0;
 u3p_in1:
-		j = inb(wkport + 0x1f);
+		j = atp_readb_io(dev, c, 0x1f);
 		if ((j & 0x01) != 0) {
-			mbuf[k++] = inb(wkport + 0x19);
+			mbuf[k++] = atp_readb_io(dev, c, 0x19);
 			goto u3p_in1;
 		}
 		if ((j & 0x80) == 0x00) {
 			goto u3p_in1;
 		}
-		j = inb(wkport + 0x17) & 0x0f;
+		j = atp_readb_io(dev, c, 0x17) & 0x0f;
 		if (j == 0x0f) {
 			goto u3p_in;
 		}
@@ -3046,11 +3046,11 @@ u3p_in1:
 		}
 		continue;
 u3p_cmd:
-		outb(0x30, wkport + 0x10);
-		outb(0x00, wkport + 0x14);
-		outb(0x08, wkport + 0x18);
-		while ((inb(wkport + 0x1f) & 0x80) == 0x00);
-		j = inb(wkport + 0x17);
+		atp_writeb_io(dev, c, 0x10, 0x30);
+		atp_writeb_io(dev, c, 0x14, 0x00);
+		atp_writeb_io(dev, c, 0x18, 0x08);
+		while ((atp_readb_io(dev, c, 0x1f) & 0x80) == 0x00);
+		j = atp_readb_io(dev, c, 0x17);
 		if (j != 0x16) {
 			if (j == 0x4e) {
 				goto u3p_out;
@@ -3077,40 +3077,40 @@ u3p_cmd:
 			continue;
 		}
 chg_wide:
-		outb(0x01, wkport + 0x1b);
-		outb(satn[0], wkport + 0x03);
-		outb(satn[1], wkport + 0x04);
-		outb(satn[2], wkport + 0x05);
-		outb(satn[3], wkport + 0x06);
-		outb(satn[4], wkport + 0x07);
-		outb(satn[5], wkport + 0x08);
-		outb(0, wkport + 0x0f);
-		outb(dev->id[c][i].devsp, wkport + 0x11);
-		outb(0, wkport + 0x12);
-		outb(satn[6], wkport + 0x13);
-		outb(satn[7], wkport + 0x14);
-		outb(satn[8], wkport + 0x18);
-
-		while ((inb(wkport + 0x1f) & 0x80) == 0x00)
+		atp_writeb_io(dev, c, 0x1b, 0x01);
+		atp_writeb_io(dev, c, 3, satn[0]);
+		atp_writeb_io(dev, c, 4, satn[1]);
+		atp_writeb_io(dev, c, 5, satn[2]);
+		atp_writeb_io(dev, c, 6, satn[3]);
+		atp_writeb_io(dev, c, 7, satn[4]);
+		atp_writeb_io(dev, c, 8, satn[5]);
+		atp_writeb_io(dev, c, 0x0f, 0);
+		atp_writeb_io(dev, c, 0x11, dev->id[c][i].devsp);
+		atp_writeb_io(dev, c, 0x12, 0);
+		atp_writeb_io(dev, c, 0x13, satn[6]);
+		atp_writeb_io(dev, c, 0x14, satn[7]);
+		atp_writeb_io(dev, c, 0x18, satn[8]);
+
+		while ((atp_readb_io(dev, c, 0x1f) & 0x80) == 0x00)
 			cpu_relax();
-		if ((inb(wkport + 0x17) != 0x11) && (inb(wkport + 0x17) != 0x8e)) {
+		if ((atp_readb_io(dev, c, 0x17) != 0x11) && (atp_readb_io(dev, c, 0x17) != 0x8e)) {
 			continue;
 		}
-		while (inb(wkport + 0x17) != 0x8e)
+		while (atp_readb_io(dev, c, 0x17) != 0x8e)
 			cpu_relax();
 try_wide:
 		j = 0;
-		outb(0x05, wkport + 0x14);
-		outb(0x20, wkport + 0x18);
+		atp_writeb_io(dev, c, 0x14, 0x05);
+		atp_writeb_io(dev, c, 0x18, 0x20);
 
-		while ((inb(wkport + 0x1f) & 0x80) == 0) {
-			if ((inb(wkport + 0x1f) & 0x01) != 0)
-				outb(wide[j++], wkport + 0x19);
+		while ((atp_readb_io(dev, c, 0x1f) & 0x80) == 0) {
+			if ((atp_readb_io(dev, c, 0x1f) & 0x01) != 0)
+				atp_writeb_io(dev, c, 0x19, wide[j++]);
 			cpu_relax();
 		}
-		while ((inb(wkport + 0x17) & 0x80) == 0x00)
+		while ((atp_readb_io(dev, c, 0x17) & 0x80) == 0x00)
 			cpu_relax();
-		j = inb(wkport + 0x17) & 0x0f;
+		j = atp_readb_io(dev, c, 0x17) & 0x0f;
 		if (j == 0x0f) {
 			goto widep_in;
 		}
@@ -3122,13 +3122,13 @@ try_wide:
 		}
 		continue;
 widep_out:
-		outb(0x20, wkport + 0x18);
-		while ((inb(wkport + 0x1f) & 0x80) == 0) {
-			if ((inb(wkport + 0x1f) & 0x01) != 0)
-				outb(0, wkport + 0x19);
+		atp_writeb_io(dev, c, 0x18, 0x20);
+		while ((atp_readb_io(dev, c, 0x1f) & 0x80) == 0) {
+			if ((atp_readb_io(dev, c, 0x1f) & 0x01) != 0)
+				atp_writeb_io(dev, c, 0x19, 0);
 			cpu_relax();
 		}
-		j = inb(wkport + 0x17) & 0x0f;
+		j = atp_readb_io(dev, c, 0x17) & 0x0f;
 		if (j == 0x0f) {
 			goto widep_in;
 		}
@@ -3140,19 +3140,19 @@ widep_out:
 		}
 		continue;
 widep_in:
-		outb(0xff, wkport + 0x14);
-		outb(0x20, wkport + 0x18);
+		atp_writeb_io(dev, c, 0x14, 0xff);
+		atp_writeb_io(dev, c, 0x18, 0x20);
 		k = 0;
 widep_in1:
-		j = inb(wkport + 0x1f);
+		j = atp_readb_io(dev, c, 0x1f);
 		if ((j & 0x01) != 0) {
-			mbuf[k++] = inb(wkport + 0x19);
+			mbuf[k++] = atp_readb_io(dev, c, 0x19);
 			goto widep_in1;
 		}
 		if ((j & 0x80) == 0x00) {
 			goto widep_in1;
 		}
-		j = inb(wkport + 0x17) & 0x0f;
+		j = atp_readb_io(dev, c, 0x17) & 0x0f;
 		if (j == 0x0f) {
 			goto widep_in;
 		}
@@ -3164,12 +3164,12 @@ widep_in1:
 		}
 		continue;
 widep_cmd:
-		outb(0x30, wkport + 0x10);
-		outb(0x00, wkport + 0x14);
-		outb(0x08, wkport + 0x18);
-		while ((inb(wkport + 0x1f) & 0x80) == 0x00)
+		atp_writeb_io(dev, c, 0x10, 0x30);
+		atp_writeb_io(dev, c, 0x14, 0x00);
+		atp_writeb_io(dev, c, 0x18, 0x08);
+		while ((atp_readb_io(dev, c, 0x1f) & 0x80) == 0x00)
 			cpu_relax();
-		j = inb(wkport + 0x17);
+		j = atp_readb_io(dev, c, 0x17);
 		if (j != 0x16) {
 			if (j == 0x4e) {
 				goto widep_out;
@@ -3215,52 +3215,52 @@ set_sync:
 		if ((m & dev->wide_id[c]) != 0) {
 			j |= 0x01;
 		}
-		outb(j, wkport + 0x1b);
-		outb(satn[0], wkport + 0x03);
-		outb(satn[1], wkport + 0x04);
-		outb(satn[2], wkport + 0x05);
-		outb(satn[3], wkport + 0x06);
-		outb(satn[4], wkport + 0x07);
-		outb(satn[5], wkport + 0x08);
-		outb(0, wkport + 0x0f);
-		outb(dev->id[c][i].devsp, wkport + 0x11);
-		outb(0, wkport + 0x12);
-		outb(satn[6], wkport + 0x13);
-		outb(satn[7], wkport + 0x14);
-		outb(satn[8], wkport + 0x18);
-
-		while ((inb(wkport + 0x1f) & 0x80) == 0x00)
+		atp_writeb_io(dev, c, 0x1b, j);
+		atp_writeb_io(dev, c, 3, satn[0]);
+		atp_writeb_io(dev, c, 4, satn[1]);
+		atp_writeb_io(dev, c, 5, satn[2]);
+		atp_writeb_io(dev, c, 6, satn[3]);
+		atp_writeb_io(dev, c, 7, satn[4]);
+		atp_writeb_io(dev, c, 8, satn[5]);
+		atp_writeb_io(dev, c, 0x0f, 0);
+		atp_writeb_io(dev, c, 0x11, dev->id[c][i].devsp);
+		atp_writeb_io(dev, c, 0x12, 0);
+		atp_writeb_io(dev, c, 0x13, satn[6]);
+		atp_writeb_io(dev, c, 0x14, satn[7]);
+		atp_writeb_io(dev, c, 0x18, satn[8]);
+
+		while ((atp_readb_io(dev, c, 0x1f) & 0x80) == 0x00)
 			cpu_relax();
-		if ((inb(wkport + 0x17) != 0x11) && (inb(wkport + 0x17) != 0x8e)) {
+		if ((atp_readb_io(dev, c, 0x17) != 0x11) && (atp_readb_io(dev, c, 0x17) != 0x8e)) {
 			continue;
 		}
-		while (inb(wkport + 0x17) != 0x8e)
+		while (atp_readb_io(dev, c, 0x17) != 0x8e)
 			cpu_relax();
 try_sync:
 		j = 0;
-		outb(0x06, wkport + 0x14);
-		outb(0x20, wkport + 0x18);
+		atp_writeb_io(dev, c, 0x14, 0x06);
+		atp_writeb_io(dev, c, 0x18, 0x20);
 
-		while ((inb(wkport + 0x1f) & 0x80) == 0) {
-			if ((inb(wkport + 0x1f) & 0x01) != 0) {
+		while ((atp_readb_io(dev, c, 0x1f) & 0x80) == 0) {
+			if ((atp_readb_io(dev, c, 0x1f) & 0x01) != 0) {
 				if ((m & dev->wide_id[c]) != 0) {
 					if ((m & dev->ultra_map[c]) != 0) {
-						outb(synuw[j++], wkport + 0x19);
+						atp_writeb_io(dev, c, 0x19, synuw[j++]);
 					} else {
-						outb(synw[j++], wkport + 0x19);
+						atp_writeb_io(dev, c, 0x19, synw[j++]);
 					}
 				} else {
 					if ((m & dev->ultra_map[c]) != 0) {
-						outb(synu[j++], wkport + 0x19);
+						atp_writeb_io(dev, c, 0x19, synu[j++]);
 					} else {
-						outb(synn[j++], wkport + 0x19);
+						atp_writeb_io(dev, c, 0x19, synn[j++]);
 					}
 				}
 			}
 		}
-		while ((inb(wkport + 0x17) & 0x80) == 0x00)
+		while ((atp_readb_io(dev, c, 0x17) & 0x80) == 0x00)
 			cpu_relax();
-		j = inb(wkport + 0x17) & 0x0f;
+		j = atp_readb_io(dev, c, 0x17) & 0x0f;
 		if (j == 0x0f) {
 			goto phase_ins;
 		}
@@ -3272,13 +3272,13 @@ try_sync:
 		}
 		continue;
 phase_outs:
-		outb(0x20, wkport + 0x18);
-		while ((inb(wkport + 0x1f) & 0x80) == 0x00) {
-			if ((inb(wkport + 0x1f) & 0x01) != 0x00)
-				outb(0x00, wkport + 0x19);
+		atp_writeb_io(dev, c, 0x18, 0x20);
+		while ((atp_readb_io(dev, c, 0x1f) & 0x80) == 0x00) {
+			if ((atp_readb_io(dev, c, 0x1f) & 0x01) != 0x00)
+				atp_writeb_io(dev, c, 0x19, 0x00);
 			cpu_relax();
 		}
-		j = inb(wkport + 0x17);
+		j = atp_readb_io(dev, c, 0x17);
 		if (j == 0x85) {
 			goto tar_dcons;
 		}
@@ -3294,20 +3294,20 @@ phase_outs:
 		}
 		continue;
 phase_ins:
-		outb(0x06, wkport + 0x14);
-		outb(0x20, wkport + 0x18);
+		atp_writeb_io(dev, c, 0x14, 0x06);
+		atp_writeb_io(dev, c, 0x18, 0x20);
 		k = 0;
 phase_ins1:
-		j = inb(wkport + 0x1f);
+		j = atp_readb_io(dev, c, 0x1f);
 		if ((j & 0x01) != 0x00) {
-			mbuf[k++] = inb(wkport + 0x19);
+			mbuf[k++] = atp_readb_io(dev, c, 0x19);
 			goto phase_ins1;
 		}
 		if ((j & 0x80) == 0x00) {
 			goto phase_ins1;
 		}
-		while ((inb(wkport + 0x17) & 0x80) == 0x00);
-		j = inb(wkport + 0x17);
+		while ((atp_readb_io(dev, c, 0x17) & 0x80) == 0x00);
+		j = atp_readb_io(dev, c, 0x17);
 		if (j == 0x85) {
 			goto tar_dcons;
 		}
@@ -3323,13 +3323,13 @@ phase_ins1:
 		}
 		continue;
 phase_cmds:
-		outb(0x30, wkport + 0x10);
+		atp_writeb_io(dev, c, 0x10, 0x30);
 tar_dcons:
-		outb(0x00, wkport + 0x14);
-		outb(0x08, wkport + 0x18);
-		while ((inb(wkport + 0x1f) & 0x80) == 0x00)
+		atp_writeb_io(dev, c, 0x14, 0x00);
+		atp_writeb_io(dev, c, 0x18, 0x08);
+		while ((atp_readb_io(dev, c, 0x1f) & 0x80) == 0x00)
 			cpu_relax();
-		j = inb(wkport + 0x17);
+		j = atp_readb_io(dev, c, 0x17);
 		if (j != 0x16) {
 			continue;
 		}
@@ -3376,7 +3376,7 @@ tar_dcons:
 		printk("dev->id[%2d][%2d].devsp = %2x\n",c,i,dev->id[c][i].devsp);
 #endif
 	}
-	outb(0x80, wkport + 0x16);
+	atp_writeb_io(dev, c, 0x16, 0x80);
 }
 
 module_init(atp870u_init);
-- 
Ondrej Zary


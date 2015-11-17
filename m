From: Ondrej Zary <linux@rainbow-software.org>
Subject: [PATCH 20/52] atp870u: Convert is880() to use wrappers
Date: Tue, 17 Nov 2015 19:23:56 +0100
Message-ID: <1447784668-23713-21-git-send-email-linux@rainbow-software.org>
References: <1447784668-23713-1-git-send-email-linux@rainbow-software.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.gsystem.sk ([62.176.172.50]:56493 "EHLO gsystem.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752301AbbKQSgS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Nov 2015 13:36:18 -0500
In-Reply-To: <1447784668-23713-1-git-send-email-linux@rainbow-software.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

Subtract 0x40 to use _io access wrappers.
Now it's obvious that is870() and is880() are very similar.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/scsi/atp870u.c |  352 ++++++++++++++++++++++++------------------------
 1 file changed, 176 insertions(+), 176 deletions(-)

diff --git a/drivers/scsi/atp870u.c b/drivers/scsi/atp870u.c
index 305eda8..1b9276f 100644
--- a/drivers/scsi/atp870u.c
+++ b/drivers/scsi/atp870u.c
@@ -1594,7 +1594,7 @@ set_syn_ok:
 	atp_writeb_io(dev, 0, 0x3a, atp_readb_io(dev, 0, 0x3a) & 0xef);
 }
 
-static void is880(struct atp_unit *dev, unsigned int wkport)
+static void is880(struct atp_unit *dev)
 {
 	unsigned char i, j, k, rmb, n, lvdmode;
 	unsigned short int m;
@@ -1608,7 +1608,7 @@ static void is880(struct atp_unit *dev, unsigned int wkport)
 	static unsigned char wide[6] = { 0x80, 1, 2, 3, 1, 0 };
 	static unsigned char u3[9] = { 0x80, 1, 6, 4, 0x09, 00, 0x0e, 0x01, 0x02 };
 
-	lvdmode = inb(wkport + 0x3f) & 0x40;
+	lvdmode = atp_readb_base(dev, 0x3f) & 0x40;
 
 	for (i = 0; i < 16; i++) {
 		m = 1;
@@ -1620,100 +1620,100 @@ static void is880(struct atp_unit *dev, unsigned int wkport)
 			printk(KERN_INFO "         ID: %2d  Host Adapter\n", dev->host_id[0]);
 			continue;
 		}
-		outb(0x01, wkport + 0x5b);
-		outb(0x08, wkport + 0x41);
-		outb(0x7f, wkport + 0x42);
-		outb(satn[0], wkport + 0x43);
-		outb(satn[1], wkport + 0x44);
-		outb(satn[2], wkport + 0x45);
-		outb(satn[3], wkport + 0x46);
-		outb(satn[4], wkport + 0x47);
-		outb(satn[5], wkport + 0x48);
-		outb(0, wkport + 0x4f);
-		outb(dev->id[0][i].devsp, wkport + 0x51);
-		outb(0, wkport + 0x52);
-		outb(satn[6], wkport + 0x53);
-		outb(satn[7], wkport + 0x54);
+		atp_writeb_io(dev, 0, 0x1b, 0x01);
+		atp_writeb_io(dev, 0, 1, 0x08);
+		atp_writeb_io(dev, 0, 2, 0x7f);
+		atp_writeb_io(dev, 0, 3, satn[0]);
+		atp_writeb_io(dev, 0, 4, satn[1]);
+		atp_writeb_io(dev, 0, 5, satn[2]);
+		atp_writeb_io(dev, 0, 6, satn[3]);
+		atp_writeb_io(dev, 0, 7, satn[4]);
+		atp_writeb_io(dev, 0, 8, satn[5]);
+		atp_writeb_io(dev, 0, 0x0f, 0);
+		atp_writeb_io(dev, 0, 0x11, dev->id[0][i].devsp);
+		atp_writeb_io(dev, 0, 0x12, 0);
+		atp_writeb_io(dev, 0, 0x13, satn[6]);
+		atp_writeb_io(dev, 0, 0x14, satn[7]);
 		j = i;
 		if ((j & 0x08) != 0) {
 			j = (j & 0x07) | 0x40;
 		}
-		outb(j, wkport + 0x55);
-		outb(satn[8], wkport + 0x58);
+		atp_writeb_io(dev, 0, 0x15, j);
+		atp_writeb_io(dev, 0, 0x18, satn[8]);
 
-		while ((inb(wkport + 0x5f) & 0x80) == 0x00)
+		while ((atp_readb_io(dev, 0, 0x1f) & 0x80) == 0x00)
 			cpu_relax();
 
-		if (inb(wkport + 0x57) != 0x11 && inb(wkport + 0x57) != 0x8e)
+		if (atp_readb_io(dev, 0, 0x17) != 0x11 && atp_readb_io(dev, 0, 0x17) != 0x8e)
 			continue;
 
-		while (inb(wkport + 0x57) != 0x8e)
+		while (atp_readb_io(dev, 0, 0x17) != 0x8e)
 			cpu_relax();
 			
 		dev->active_id[0] |= m;
 
-		outb(0x30, wkport + 0x50);
-		outb(0x00, wkport + 0x54);
+		atp_writeb_io(dev, 0, 0x10, 0x30);
+		atp_writeb_io(dev, 0, 0x14, 0x00);
 
 phase_cmd:
-		outb(0x08, wkport + 0x58);
+		atp_writeb_io(dev, 0, 0x18, 0x08);
 		
-		while ((inb(wkport + 0x5f) & 0x80) == 0x00)
+		while ((atp_readb_io(dev, 0, 0x1f) & 0x80) == 0x00)
 			cpu_relax();
 
-		j = inb(wkport + 0x57);
+		j = atp_readb_io(dev, 0, 0x17);
 		if (j != 0x16) {
-			outb(0x41, wkport + 0x50);
+			atp_writeb_io(dev, 0, 0x10, 0x41);
 			goto phase_cmd;
 		}
 sel_ok:
-		outb(inqd[0], wkport + 0x43);
-		outb(inqd[1], wkport + 0x44);
-		outb(inqd[2], wkport + 0x45);
-		outb(inqd[3], wkport + 0x46);
-		outb(inqd[4], wkport + 0x47);
-		outb(inqd[5], wkport + 0x48);
-		outb(0, wkport + 0x4f);
-		outb(dev->id[0][i].devsp, wkport + 0x51);
-		outb(0, wkport + 0x52);
-		outb(inqd[6], wkport + 0x53);
-		outb(inqd[7], wkport + 0x54);
-		outb(inqd[8], wkport + 0x58);
+		atp_writeb_io(dev, 0, 3, inqd[0]);
+		atp_writeb_io(dev, 0, 4, inqd[1]);
+		atp_writeb_io(dev, 0, 5, inqd[2]);
+		atp_writeb_io(dev, 0, 6, inqd[3]);
+		atp_writeb_io(dev, 0, 7, inqd[4]);
+		atp_writeb_io(dev, 0, 8, inqd[5]);
+		atp_writeb_io(dev, 0, 0x0f, 0);
+		atp_writeb_io(dev, 0, 0x11, dev->id[0][i].devsp);
+		atp_writeb_io(dev, 0, 0x12, 0);
+		atp_writeb_io(dev, 0, 0x13, inqd[6]);
+		atp_writeb_io(dev, 0, 0x14, inqd[7]);
+		atp_writeb_io(dev, 0, 0x18, inqd[8]);
 		
-		while ((inb(wkport + 0x5f) & 0x80) == 0x00)
+		while ((atp_readb_io(dev, 0, 0x1f) & 0x80) == 0x00)
 			cpu_relax();
 			
-		if (inb(wkport + 0x57) != 0x11 && inb(wkport + 0x57) != 0x8e)
+		if (atp_readb_io(dev, 0, 0x17) != 0x11 && atp_readb_io(dev, 0, 0x17) != 0x8e)
 			continue;
 
-		while (inb(wkport + 0x57) != 0x8e)
+		while (atp_readb_io(dev, 0, 0x17) != 0x8e)
 			cpu_relax();
 			
-		outb(0x00, wkport + 0x5b);
-		outb(0x08, wkport + 0x58);
+		atp_writeb_io(dev, 0, 0x1b, 0x00);
+		atp_writeb_io(dev, 0, 0x18, 0x08);
 		j = 0;
 rd_inq_data:
-		k = inb(wkport + 0x5f);
+		k = atp_readb_io(dev, 0, 0x1f);
 		if ((k & 0x01) != 0) {
-			mbuf[j++] = inb(wkport + 0x59);
+			mbuf[j++] = atp_readb_io(dev, 0, 0x19);
 			goto rd_inq_data;
 		}
 		if ((k & 0x80) == 0) {
 			goto rd_inq_data;
 		}
-		j = inb(wkport + 0x57);
+		j = atp_readb_io(dev, 0, 0x17);
 		if (j == 0x16) {
 			goto inq_ok;
 		}
-		outb(0x46, wkport + 0x50);
-		outb(0, wkport + 0x52);
-		outb(0, wkport + 0x53);
-		outb(0, wkport + 0x54);
-		outb(0x08, wkport + 0x58);
-		while ((inb(wkport + 0x5f) & 0x80) == 0x00)
+		atp_writeb_io(dev, 0, 0x10, 0x46);
+		atp_writeb_io(dev, 0, 0x12, 0);
+		atp_writeb_io(dev, 0, 0x13, 0);
+		atp_writeb_io(dev, 0, 0x14, 0);
+		atp_writeb_io(dev, 0, 0x18, 0x08);
+		while ((atp_readb_io(dev, 0, 0x1f) & 0x80) == 0x00)
 			cpu_relax();
 			
-		if (inb(wkport + 0x57) != 0x16)
+		if (atp_readb_io(dev, 0, 0x17) != 0x16)
 			goto sel_ok;
 
 inq_ok:
@@ -1736,43 +1736,43 @@ inq_ok:
 			goto chg_wide;
 		}
 
-		outb(0x01, wkport + 0x5b);
-		outb(satn[0], wkport + 0x43);
-		outb(satn[1], wkport + 0x44);
-		outb(satn[2], wkport + 0x45);
-		outb(satn[3], wkport + 0x46);
-		outb(satn[4], wkport + 0x47);
-		outb(satn[5], wkport + 0x48);
-		outb(0, wkport + 0x4f);
-		outb(dev->id[0][i].devsp, wkport + 0x51);
-		outb(0, wkport + 0x52);
-		outb(satn[6], wkport + 0x53);
-		outb(satn[7], wkport + 0x54);
-		outb(satn[8], wkport + 0x58);
-
-		while ((inb(wkport + 0x5f) & 0x80) == 0x00)
+		atp_writeb_io(dev, 0, 0x1b, 0x01);
+		atp_writeb_io(dev, 0, 3, satn[0]);
+		atp_writeb_io(dev, 0, 4, satn[1]);
+		atp_writeb_io(dev, 0, 5, satn[2]);
+		atp_writeb_io(dev, 0, 6, satn[3]);
+		atp_writeb_io(dev, 0, 7, satn[4]);
+		atp_writeb_io(dev, 0, 8, satn[5]);
+		atp_writeb_io(dev, 0, 0x0f, 0);
+		atp_writeb_io(dev, 0, 0x11, dev->id[0][i].devsp);
+		atp_writeb_io(dev, 0, 0x12, 0);
+		atp_writeb_io(dev, 0, 0x13, satn[6]);
+		atp_writeb_io(dev, 0, 0x14, satn[7]);
+		atp_writeb_io(dev, 0, 0x18, satn[8]);
+
+		while ((atp_readb_io(dev, 0, 0x1f) & 0x80) == 0x00)
 			cpu_relax();
 
-		if (inb(wkport + 0x57) != 0x11 && inb(wkport + 0x57) != 0x8e)
+		if (atp_readb_io(dev, 0, 0x17) != 0x11 && atp_readb_io(dev, 0, 0x17) != 0x8e)
 			continue;
 
-		while (inb(wkport + 0x57) != 0x8e)
+		while (atp_readb_io(dev, 0, 0x17) != 0x8e)
 			cpu_relax();
 
 try_u3:
 		j = 0;
-		outb(0x09, wkport + 0x54);
-		outb(0x20, wkport + 0x58);
+		atp_writeb_io(dev, 0, 0x14, 0x09);
+		atp_writeb_io(dev, 0, 0x18, 0x20);
 
-		while ((inb(wkport + 0x5f) & 0x80) == 0) {
-			if ((inb(wkport + 0x5f) & 0x01) != 0)
-				outb(u3[j++], wkport + 0x59);
+		while ((atp_readb_io(dev, 0, 0x1f) & 0x80) == 0) {
+			if ((atp_readb_io(dev, 0, 0x1f) & 0x01) != 0)
+				atp_writeb_io(dev, 0, 0x19, u3[j++]);
 		}
 
-		while ((inb(wkport + 0x57) & 0x80) == 0x00)
+		while ((atp_readb_io(dev, 0, 0x17) & 0x80) == 0x00)
 			cpu_relax();
 			
-		j = inb(wkport + 0x57) & 0x0f;
+		j = atp_readb_io(dev, 0, 0x17) & 0x0f;
 		if (j == 0x0f) {
 			goto u3p_in;
 		}
@@ -1784,12 +1784,12 @@ try_u3:
 		}
 		continue;
 u3p_out:
-		outb(0x20, wkport + 0x58);
-		while ((inb(wkport + 0x5f) & 0x80) == 0) {
-			if ((inb(wkport + 0x5f) & 0x01) != 0)
-				outb(0, wkport + 0x59);
+		atp_writeb_io(dev, 0, 0x18, 0x20);
+		while ((atp_readb_io(dev, 0, 0x1f) & 0x80) == 0) {
+			if ((atp_readb_io(dev, 0, 0x1f) & 0x01) != 0)
+				atp_writeb_io(dev, 0, 0x19, 0);
 		}
-		j = inb(wkport + 0x57) & 0x0f;
+		j = atp_readb_io(dev, 0, 0x17) & 0x0f;
 		if (j == 0x0f) {
 			goto u3p_in;
 		}
@@ -1801,19 +1801,19 @@ u3p_out:
 		}
 		continue;
 u3p_in:
-		outb(0x09, wkport + 0x54);
-		outb(0x20, wkport + 0x58);
+		atp_writeb_io(dev, 0, 0x14, 0x09);
+		atp_writeb_io(dev, 0, 0x18, 0x20);
 		k = 0;
 u3p_in1:
-		j = inb(wkport + 0x5f);
+		j = atp_readb_io(dev, 0, 0x1f);
 		if ((j & 0x01) != 0) {
-			mbuf[k++] = inb(wkport + 0x59);
+			mbuf[k++] = atp_readb_io(dev, 0, 0x19);
 			goto u3p_in1;
 		}
 		if ((j & 0x80) == 0x00) {
 			goto u3p_in1;
 		}
-		j = inb(wkport + 0x57) & 0x0f;
+		j = atp_readb_io(dev, 0, 0x17) & 0x0f;
 		if (j == 0x0f) {
 			goto u3p_in;
 		}
@@ -1825,14 +1825,14 @@ u3p_in1:
 		}
 		continue;
 u3p_cmd:
-		outb(0x30, wkport + 0x50);
-		outb(0x00, wkport + 0x54);
-		outb(0x08, wkport + 0x58);
+		atp_writeb_io(dev, 0, 0x10, 0x30);
+		atp_writeb_io(dev, 0, 0x14, 0x00);
+		atp_writeb_io(dev, 0, 0x18, 0x08);
 		
-		while ((inb(wkport + 0x5f) & 0x80) == 0x00)
+		while ((atp_readb_io(dev, 0, 0x1f) & 0x80) == 0x00)
 			cpu_relax();
 			
-		j = inb(wkport + 0x57);
+		j = atp_readb_io(dev, 0, 0x17);
 		if (j != 0x16) {
 			if (j == 0x4e) {
 				goto u3p_out;
@@ -1856,42 +1856,42 @@ u3p_cmd:
 			continue;
 		}
 chg_wide:
-		outb(0x01, wkport + 0x5b);
-		outb(satn[0], wkport + 0x43);
-		outb(satn[1], wkport + 0x44);
-		outb(satn[2], wkport + 0x45);
-		outb(satn[3], wkport + 0x46);
-		outb(satn[4], wkport + 0x47);
-		outb(satn[5], wkport + 0x48);
-		outb(0, wkport + 0x4f);
-		outb(dev->id[0][i].devsp, wkport + 0x51);
-		outb(0, wkport + 0x52);
-		outb(satn[6], wkport + 0x53);
-		outb(satn[7], wkport + 0x54);
-		outb(satn[8], wkport + 0x58);
-
-		while ((inb(wkport + 0x5f) & 0x80) == 0x00)
+		atp_writeb_io(dev, 0, 0x1b, 0x01);
+		atp_writeb_io(dev, 0, 3, satn[0]);
+		atp_writeb_io(dev, 0, 4, satn[1]);
+		atp_writeb_io(dev, 0, 5, satn[2]);
+		atp_writeb_io(dev, 0, 6, satn[3]);
+		atp_writeb_io(dev, 0, 7, satn[4]);
+		atp_writeb_io(dev, 0, 8, satn[5]);
+		atp_writeb_io(dev, 0, 0x0f, 0);
+		atp_writeb_io(dev, 0, 0x11, dev->id[0][i].devsp);
+		atp_writeb_io(dev, 0, 0x12, 0);
+		atp_writeb_io(dev, 0, 0x13, satn[6]);
+		atp_writeb_io(dev, 0, 0x14, satn[7]);
+		atp_writeb_io(dev, 0, 0x18, satn[8]);
+
+		while ((atp_readb_io(dev, 0, 0x1f) & 0x80) == 0x00)
 			cpu_relax();
 			
-		if (inb(wkport + 0x57) != 0x11 && inb(wkport + 0x57) != 0x8e)
+		if (atp_readb_io(dev, 0, 0x17) != 0x11 && atp_readb_io(dev, 0, 0x17) != 0x8e)
 			continue;
 
-		while (inb(wkport + 0x57) != 0x8e)
+		while (atp_readb_io(dev, 0, 0x17) != 0x8e)
 			cpu_relax();
 			
 try_wide:
 		j = 0;
-		outb(0x05, wkport + 0x54);
-		outb(0x20, wkport + 0x58);
+		atp_writeb_io(dev, 0, 0x14, 0x05);
+		atp_writeb_io(dev, 0, 0x18, 0x20);
 
-		while ((inb(wkport + 0x5f) & 0x80) == 0) {
-			if ((inb(wkport + 0x5f) & 0x01) != 0)
-				outb(wide[j++], wkport + 0x59);
+		while ((atp_readb_io(dev, 0, 0x1f) & 0x80) == 0) {
+			if ((atp_readb_io(dev, 0, 0x1f) & 0x01) != 0)
+				atp_writeb_io(dev, 0, 0x19, wide[j++]);
 		}
-		while ((inb(wkport + 0x57) & 0x80) == 0x00)
+		while ((atp_readb_io(dev, 0, 0x17) & 0x80) == 0x00)
 			cpu_relax();
 			
-		j = inb(wkport + 0x57) & 0x0f;
+		j = atp_readb_io(dev, 0, 0x17) & 0x0f;
 		if (j == 0x0f) {
 			goto widep_in;
 		}
@@ -1903,12 +1903,12 @@ try_wide:
 		}
 		continue;
 widep_out:
-		outb(0x20, wkport + 0x58);
-		while ((inb(wkport + 0x5f) & 0x80) == 0) {
-			if ((inb(wkport + 0x5f) & 0x01) != 0)
-				outb(0, wkport + 0x59);
+		atp_writeb_io(dev, 0, 0x18, 0x20);
+		while ((atp_readb_io(dev, 0, 0x1f) & 0x80) == 0) {
+			if ((atp_readb_io(dev, 0, 0x1f) & 0x01) != 0)
+				atp_writeb_io(dev, 0, 0x19, 0);
 		}
-		j = inb(wkport + 0x57) & 0x0f;
+		j = atp_readb_io(dev, 0, 0x17) & 0x0f;
 		if (j == 0x0f) {
 			goto widep_in;
 		}
@@ -1920,19 +1920,19 @@ widep_out:
 		}
 		continue;
 widep_in:
-		outb(0xff, wkport + 0x54);
-		outb(0x20, wkport + 0x58);
+		atp_writeb_io(dev, 0, 0x14, 0xff);
+		atp_writeb_io(dev, 0, 0x18, 0x20);
 		k = 0;
 widep_in1:
-		j = inb(wkport + 0x5f);
+		j = atp_readb_io(dev, 0, 0x1f);
 		if ((j & 0x01) != 0) {
-			mbuf[k++] = inb(wkport + 0x59);
+			mbuf[k++] = atp_readb_io(dev, 0, 0x19);
 			goto widep_in1;
 		}
 		if ((j & 0x80) == 0x00) {
 			goto widep_in1;
 		}
-		j = inb(wkport + 0x57) & 0x0f;
+		j = atp_readb_io(dev, 0, 0x17) & 0x0f;
 		if (j == 0x0f) {
 			goto widep_in;
 		}
@@ -1944,14 +1944,14 @@ widep_in1:
 		}
 		continue;
 widep_cmd:
-		outb(0x30, wkport + 0x50);
-		outb(0x00, wkport + 0x54);
-		outb(0x08, wkport + 0x58);
+		atp_writeb_io(dev, 0, 0x10, 0x30);
+		atp_writeb_io(dev, 0, 0x14, 0x00);
+		atp_writeb_io(dev, 0, 0x18, 0x08);
 
-		while ((inb(wkport + 0x5f) & 0x80) == 0x00)
+		while ((atp_readb_io(dev, 0, 0x1f) & 0x80) == 0x00)
 			cpu_relax();
 
-		j = inb(wkport + 0x57);
+		j = atp_readb_io(dev, 0, 0x17);
 		if (j != 0x16) {
 			if (j == 0x4e) {
 				goto widep_out;
@@ -1996,56 +1996,56 @@ set_sync:
 		if ((m & dev->wide_id[0]) != 0) {
 			j |= 0x01;
 		}
-		outb(j, wkport + 0x5b);
-		outb(satn[0], wkport + 0x43);
-		outb(satn[1], wkport + 0x44);
-		outb(satn[2], wkport + 0x45);
-		outb(satn[3], wkport + 0x46);
-		outb(satn[4], wkport + 0x47);
-		outb(satn[5], wkport + 0x48);
-		outb(0, wkport + 0x4f);
-		outb(dev->id[0][i].devsp, wkport + 0x51);
-		outb(0, wkport + 0x52);
-		outb(satn[6], wkport + 0x53);
-		outb(satn[7], wkport + 0x54);
-		outb(satn[8], wkport + 0x58);
-
-		while ((inb(wkport + 0x5f) & 0x80) == 0x00)
+		atp_writeb_io(dev, 0, 0x1b, j);
+		atp_writeb_io(dev, 0, 3, satn[0]);
+		atp_writeb_io(dev, 0, 4, satn[1]);
+		atp_writeb_io(dev, 0, 5, satn[2]);
+		atp_writeb_io(dev, 0, 6, satn[3]);
+		atp_writeb_io(dev, 0, 7, satn[4]);
+		atp_writeb_io(dev, 0, 8, satn[5]);
+		atp_writeb_io(dev, 0, 0x0f, 0);
+		atp_writeb_io(dev, 0, 0x11, dev->id[0][i].devsp);
+		atp_writeb_io(dev, 0, 0x12, 0);
+		atp_writeb_io(dev, 0, 0x13, satn[6]);
+		atp_writeb_io(dev, 0, 0x14, satn[7]);
+		atp_writeb_io(dev, 0, 0x18, satn[8]);
+
+		while ((atp_readb_io(dev, 0, 0x1f) & 0x80) == 0x00)
 			cpu_relax();
 
-		if ((inb(wkport + 0x57) != 0x11) && (inb(wkport + 0x57) != 0x8e)) {
+		if (atp_readb_io(dev, 0, 0x17) != 0x11 && atp_readb_io(dev, 0, 0x17) != 0x8e) {
 			continue;
 		}
-		while (inb(wkport + 0x57) != 0x8e)
+		while (atp_readb_io(dev, 0, 0x17) != 0x8e)
 			cpu_relax();
 
 try_sync:
 		j = 0;
-		outb(0x06, wkport + 0x54);
-		outb(0x20, wkport + 0x58);
+		atp_writeb_io(dev, 0, 0x14, 0x06);
+		atp_writeb_io(dev, 0, 0x18, 0x20);
 
-		while ((inb(wkport + 0x5f) & 0x80) == 0) {
-			if ((inb(wkport + 0x5f) & 0x01) != 0) {
+		while ((atp_readb_io(dev, 0, 0x1f) & 0x80) == 0) {
+			if ((atp_readb_io(dev, 0, 0x1f) & 0x01) != 0) {
 				if ((m & dev->wide_id[0]) != 0) {
 					if ((m & dev->ultra_map[0]) != 0) {
-						outb(synuw[j++], wkport + 0x59);
+						atp_writeb_io(dev, 0, 0x19, synuw[j++]);
 					} else {
-						outb(synw[j++], wkport + 0x59);
+						atp_writeb_io(dev, 0, 0x19, synw[j++]);
 					}
 				} else {
 					if ((m & dev->ultra_map[0]) != 0) {
-						outb(synu[j++], wkport + 0x59);
+						atp_writeb_io(dev, 0, 0x19, synu[j++]);
 					} else {
-						outb(synn[j++], wkport + 0x59);
+						atp_writeb_io(dev, 0, 0x19, synn[j++]);
 					}
 				}
 			}
 		}
 
-		while ((inb(wkport + 0x57) & 0x80) == 0x00)
+		while ((atp_readb_io(dev, 0, 0x17) & 0x80) == 0x00)
 			cpu_relax();
 
-		j = inb(wkport + 0x57) & 0x0f;
+		j = atp_readb_io(dev, 0, 0x17) & 0x0f;
 		if (j == 0x0f) {
 			goto phase_ins;
 		}
@@ -2057,12 +2057,12 @@ try_sync:
 		}
 		continue;
 phase_outs:
-		outb(0x20, wkport + 0x58);
-		while ((inb(wkport + 0x5f) & 0x80) == 0x00) {
-			if ((inb(wkport + 0x5f) & 0x01) != 0x00)
-				outb(0x00, wkport + 0x59);
+		atp_writeb_io(dev, 0, 0x18, 0x20);
+		while ((atp_readb_io(dev, 0, 0x1f) & 0x80) == 0x00) {
+			if ((atp_readb_io(dev, 0, 0x1f) & 0x01) != 0x00)
+				atp_writeb_io(dev, 0, 0x19, 0x00);
 		}
-		j = inb(wkport + 0x57);
+		j = atp_readb_io(dev, 0, 0x17);
 		if (j == 0x85) {
 			goto tar_dcons;
 		}
@@ -2078,23 +2078,23 @@ phase_outs:
 		}
 		continue;
 phase_ins:
-		outb(0x06, wkport + 0x54);
-		outb(0x20, wkport + 0x58);
+		atp_writeb_io(dev, 0, 0x14, 0x06);
+		atp_writeb_io(dev, 0, 0x18, 0x20);
 		k = 0;
 phase_ins1:
-		j = inb(wkport + 0x5f);
+		j = atp_readb_io(dev, 0, 0x1f);
 		if ((j & 0x01) != 0x00) {
-			mbuf[k++] = inb(wkport + 0x59);
+			mbuf[k++] = atp_readb_io(dev, 0, 0x19);
 			goto phase_ins1;
 		}
 		if ((j & 0x80) == 0x00) {
 			goto phase_ins1;
 		}
 
-		while ((inb(wkport + 0x57) & 0x80) == 0x00)
+		while ((atp_readb_io(dev, 0, 0x17) & 0x80) == 0x00)
 			cpu_relax();
 
-		j = inb(wkport + 0x57);
+		j = atp_readb_io(dev, 0, 0x17);
 		if (j == 0x85) {
 			goto tar_dcons;
 		}
@@ -2110,15 +2110,15 @@ phase_ins1:
 		}
 		continue;
 phase_cmds:
-		outb(0x30, wkport + 0x50);
+		atp_writeb_io(dev, 0, 0x10, 0x30);
 tar_dcons:
-		outb(0x00, wkport + 0x54);
-		outb(0x08, wkport + 0x58);
+		atp_writeb_io(dev, 0, 0x14, 0x00);
+		atp_writeb_io(dev, 0, 0x18, 0x08);
 
-		while ((inb(wkport + 0x5f) & 0x80) == 0x00)
+		while ((atp_readb_io(dev, 0, 0x1f) & 0x80) == 0x00)
 			cpu_relax();
 
-		j = inb(wkport + 0x57);
+		j = atp_readb_io(dev, 0, 0x17);
 		if (j != 0x16) {
 			continue;
 		}
@@ -2375,7 +2375,7 @@ flash_ok_880:
 		outb(0x20, base_io + 0x51);
 
 		tscam(shpnt);
-		is880(p, base_io);
+		is880(p);
 		outb(0xb0, base_io + 0x38);
 		shpnt->max_id = 16;
 		shpnt->this_id = host_id;
-- 
Ondrej Zary


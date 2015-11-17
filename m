From: Ondrej Zary <linux@rainbow-software.org>
Subject: [PATCH 19/52] atp870u: Convert is870() to use wrappers
Date: Tue, 17 Nov 2015 19:23:55 +0100
Message-ID: <1447784668-23713-20-git-send-email-linux@rainbow-software.org>
References: <1447784668-23713-1-git-send-email-linux@rainbow-software.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.gsystem.sk ([62.176.172.50]:56496 "EHLO gsystem.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752301AbbKQSgV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Nov 2015 13:36:21 -0500
In-Reply-To: <1447784668-23713-1-git-send-email-linux@rainbow-software.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/scsi/atp870u.c |  276 ++++++++++++++++++++++++------------------------
 1 file changed, 138 insertions(+), 138 deletions(-)

diff --git a/drivers/scsi/atp870u.c b/drivers/scsi/atp870u.c
index 07b50ac..305eda8 100644
--- a/drivers/scsi/atp870u.c
+++ b/drivers/scsi/atp870u.c
@@ -1162,7 +1162,7 @@ static void tscam(struct Scsi_Host *host)
 	}
 }
 
-static void is870(struct atp_unit *dev, unsigned int wkport)
+static void is870(struct atp_unit *dev)
 {
 	unsigned char i, j, k, rmb, n;
 	unsigned short int m;
@@ -1174,7 +1174,7 @@ static void is870(struct atp_unit *dev, unsigned int wkport)
 	static unsigned char synw[6] = { 0x80, 1, 3, 1, 0x0c, 0x07 };
 	static unsigned char wide[6] = { 0x80, 1, 2, 3, 1, 0 };
 	
-	outb((unsigned char) (inb(wkport + 0x3a) | 0x10), wkport + 0x3a);
+	atp_writeb_io(dev, 0, 0x3a, atp_readb_io(dev, 0, 0x3a) | 0x10);
 
 	for (i = 0; i < 16; i++) {
 		if ((dev->chip_ver != 4) && (i > 7)) {
@@ -1190,104 +1190,104 @@ static void is870(struct atp_unit *dev, unsigned int wkport)
 			continue;
 		}
 		if (dev->chip_ver == 4) {
-			outb(0x01, wkport + 0x1b);
+			atp_writeb_io(dev, 0, 0x1b, 0x01);
 		} else {
-			outb(0x00, wkport + 0x1b);
-		}
-		outb(0x08, wkport + 1);
-		outb(0x7f, wkport + 2);
-		outb(satn[0], wkport + 3);
-		outb(satn[1], wkport + 4);
-		outb(satn[2], wkport + 5);
-		outb(satn[3], wkport + 6);
-		outb(satn[4], wkport + 7);
-		outb(satn[5], wkport + 8);
-		outb(0, wkport + 0x0f);
-		outb(dev->id[0][i].devsp, wkport + 0x11);
-		outb(0, wkport + 0x12);
-		outb(satn[6], wkport + 0x13);
-		outb(satn[7], wkport + 0x14);
+			atp_writeb_io(dev, 0, 0x1b, 0x00);
+		}
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
-		outb(j, wkport + 0x15);
-		outb(satn[8], wkport + 0x18);
+		atp_writeb_io(dev, 0, 0x15, j);
+		atp_writeb_io(dev, 0, 0x18, satn[8]);
 
-		while ((inb(wkport + 0x1f) & 0x80) == 0x00)
+		while ((atp_readb_io(dev, 0, 0x1f) & 0x80) == 0x00)
 			cpu_relax();
 
-		if (inb(wkport + 0x17) != 0x11 && inb(wkport + 0x17) != 0x8e)
+		if (atp_readb_io(dev, 0, 0x17) != 0x11 && atp_readb_io(dev, 0, 0x17) != 0x8e)
 			continue;
 
-		while (inb(wkport + 0x17) != 0x8e)
+		while (atp_readb_io(dev, 0, 0x17) != 0x8e)
 			cpu_relax();
 
 		dev->active_id[0] |= m;
 
-		outb(0x30, wkport + 0x10);
-		outb(0x00, wkport + 0x04);
+		atp_writeb_io(dev, 0, 0x10, 0x30);
+		atp_writeb_io(dev, 0, 0x04, 0x00);
 
 phase_cmd:
-		outb(0x08, wkport + 0x18);
-		while ((inb(wkport + 0x1f) & 0x80) == 0x00)
+		atp_writeb_io(dev, 0, 0x18, 0x08);
+		while ((atp_readb_io(dev, 0, 0x1f) & 0x80) == 0x00)
 			cpu_relax();
-		j = inb(wkport + 0x17);
+		j = atp_readb_io(dev, 0, 0x17);
 		if (j != 0x16) {
-			outb(0x41, wkport + 0x10);
+			atp_writeb_io(dev, 0, 0x10, 0x41);
 			goto phase_cmd;
 		}
 sel_ok:
-		outb(inqd[0], wkport + 3);
-		outb(inqd[1], wkport + 4);
-		outb(inqd[2], wkport + 5);
-		outb(inqd[3], wkport + 6);
-		outb(inqd[4], wkport + 7);
-		outb(inqd[5], wkport + 8);
-		outb(0, wkport + 0x0f);
-		outb(dev->id[0][i].devsp, wkport + 0x11);
-		outb(0, wkport + 0x12);
-		outb(inqd[6], wkport + 0x13);
-		outb(inqd[7], wkport + 0x14);
-		outb(inqd[8], wkport + 0x18);
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
 
-		while ((inb(wkport + 0x1f) & 0x80) == 0x00)
+		while ((atp_readb_io(dev, 0, 0x1f) & 0x80) == 0x00)
 			cpu_relax();
 			
-		if (inb(wkport + 0x17) != 0x11 && inb(wkport + 0x17) != 0x8e)
+		if (atp_readb_io(dev, 0, 0x17) != 0x11 && atp_readb_io(dev, 0, 0x17) != 0x8e)
 			continue;
 
-		while (inb(wkport + 0x17) != 0x8e)
+		while (atp_readb_io(dev, 0, 0x17) != 0x8e)
 			cpu_relax();
 			
 		if (dev->chip_ver == 4)
-			outb(0x00, wkport + 0x1b);
+			atp_writeb_io(dev, 0, 0x1b, 0x00);
 
-		outb(0x08, wkport + 0x18);
+		atp_writeb_io(dev, 0, 0x18, 0x08);
 		j = 0;
 rd_inq_data:
-		k = inb(wkport + 0x1f);
+		k = atp_readb_io(dev, 0, 0x1f);
 		if ((k & 0x01) != 0) {
-			mbuf[j++] = inb(wkport + 0x19);
+			mbuf[j++] = atp_readb_io(dev, 0, 0x19);
 			goto rd_inq_data;
 		}
 		if ((k & 0x80) == 0) {
 			goto rd_inq_data;
 		}
-		j = inb(wkport + 0x17);
+		j = atp_readb_io(dev, 0, 0x17);
 		if (j == 0x16) {
 			goto inq_ok;
 		}
-		outb(0x46, wkport + 0x10);
-		outb(0, wkport + 0x12);
-		outb(0, wkport + 0x13);
-		outb(0, wkport + 0x14);
-		outb(0x08, wkport + 0x18);
+		atp_writeb_io(dev, 0, 0x10, 0x46);
+		atp_writeb_io(dev, 0, 0x12, 0);
+		atp_writeb_io(dev, 0, 0x13, 0);
+		atp_writeb_io(dev, 0, 0x14, 0);
+		atp_writeb_io(dev, 0, 0x18, 0x08);
 
-		while ((inb(wkport + 0x1f) & 0x80) == 0x00)
+		while ((atp_readb_io(dev, 0, 0x1f) & 0x80) == 0x00)
 			cpu_relax();
 			
-		if (inb(wkport + 0x17) != 0x16) {
+		if (atp_readb_io(dev, 0, 0x17) != 0x16) {
 			goto sel_ok;
 		}
 inq_ok:
@@ -1305,43 +1305,43 @@ inq_ok:
 		if ((dev->global_map[0] & 0x20) == 0) {
 			goto not_wide;
 		}
-		outb(0x01, wkport + 0x1b);
-		outb(satn[0], wkport + 3);
-		outb(satn[1], wkport + 4);
-		outb(satn[2], wkport + 5);
-		outb(satn[3], wkport + 6);
-		outb(satn[4], wkport + 7);
-		outb(satn[5], wkport + 8);
-		outb(0, wkport + 0x0f);
-		outb(dev->id[0][i].devsp, wkport + 0x11);
-		outb(0, wkport + 0x12);
-		outb(satn[6], wkport + 0x13);
-		outb(satn[7], wkport + 0x14);
-		outb(satn[8], wkport + 0x18);
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
 
-		while ((inb(wkport + 0x1f) & 0x80) == 0x00)
+		while ((atp_readb_io(dev, 0, 0x1f) & 0x80) == 0x00)
 			cpu_relax();
 			
-		if (inb(wkport + 0x17) != 0x11 && inb(wkport + 0x17) != 0x8e)
+		if (atp_readb_io(dev, 0, 0x17) != 0x11 && atp_readb_io(dev, 0, 0x17) != 0x8e)
 			continue;
 
-		while (inb(wkport + 0x17) != 0x8e)
+		while (atp_readb_io(dev, 0, 0x17) != 0x8e)
 			cpu_relax();
 			
 try_wide:
 		j = 0;
-		outb(0x05, wkport + 0x14);
-		outb(0x20, wkport + 0x18);
+		atp_writeb_io(dev, 0, 0x14, 0x05);
+		atp_writeb_io(dev, 0, 0x18, 0x20);
 
-		while ((inb(wkport + 0x1f) & 0x80) == 0) {
-			if ((inb(wkport + 0x1f) & 0x01) != 0)
-				outb(wide[j++], wkport + 0x19);
+		while ((atp_readb_io(dev, 0, 0x1f) & 0x80) == 0) {
+			if ((atp_readb_io(dev, 0, 0x1f) & 0x01) != 0)
+				atp_writeb_io(dev, 0, 0x19, wide[j++]);
 		}
 		
-		while ((inb(wkport + 0x17) & 0x80) == 0x00)
+		while ((atp_readb_io(dev, 0, 0x17) & 0x80) == 0x00)
 			cpu_relax();
 			
-		j = inb(wkport + 0x17) & 0x0f;
+		j = atp_readb_io(dev, 0, 0x17) & 0x0f;
 		if (j == 0x0f) {
 			goto widep_in;
 		}
@@ -1353,12 +1353,12 @@ try_wide:
 		}
 		continue;
 widep_out:
-		outb(0x20, wkport + 0x18);
-		while ((inb(wkport + 0x1f) & 0x80) == 0) {
-			if ((inb(wkport + 0x1f) & 0x01) != 0)
-				outb(0, wkport + 0x19);
+		atp_writeb_io(dev, 0, 0x18, 0x20);
+		while ((atp_readb_io(dev, 0, 0x1f) & 0x80) == 0) {
+			if ((atp_readb_io(dev, 0, 0x1f) & 0x01) != 0)
+				atp_writeb_io(dev, 0, 0x19, 0);
 		}
-		j = inb(wkport + 0x17) & 0x0f;
+		j = atp_readb_io(dev, 0, 0x17) & 0x0f;
 		if (j == 0x0f) {
 			goto widep_in;
 		}
@@ -1370,19 +1370,19 @@ widep_out:
 		}
 		continue;
 widep_in:
-		outb(0xff, wkport + 0x14);
-		outb(0x20, wkport + 0x18);
+		atp_writeb_io(dev, 0, 0x14, 0xff);
+		atp_writeb_io(dev, 0, 0x18, 0x20);
 		k = 0;
 widep_in1:
-		j = inb(wkport + 0x1f);
+		j = atp_readb_io(dev, 0, 0x1f);
 		if ((j & 0x01) != 0) {
-			mbuf[k++] = inb(wkport + 0x19);
+			mbuf[k++] = atp_readb_io(dev, 0, 0x19);
 			goto widep_in1;
 		}
 		if ((j & 0x80) == 0x00) {
 			goto widep_in1;
 		}
-		j = inb(wkport + 0x17) & 0x0f;
+		j = atp_readb_io(dev, 0, 0x17) & 0x0f;
 		if (j == 0x0f) {
 			goto widep_in;
 		}
@@ -1394,14 +1394,14 @@ widep_in1:
 		}
 		continue;
 widep_cmd:
-		outb(0x30, wkport + 0x10);
-		outb(0x00, wkport + 0x14);
-		outb(0x08, wkport + 0x18);
-		
-		while ((inb(wkport + 0x1f) & 0x80) == 0x00)
+		atp_writeb_io(dev, 0, 0x10, 0x30);
+		atp_writeb_io(dev, 0, 0x14, 0x00);
+		atp_writeb_io(dev, 0, 0x18, 0x08);
+
+		while ((atp_readb_io(dev, 0, 0x1f) & 0x80) == 0x00)
 			cpu_relax();
 
-		j = inb(wkport + 0x17);
+		j = atp_readb_io(dev, 0, 0x17);
 		if (j != 0x16) {
 			if (j == 0x4e) {
 				goto widep_out;
@@ -1433,52 +1433,52 @@ set_sync:
 		if ((m & dev->wide_id[0]) != 0) {
 			j |= 0x01;
 		}
-		outb(j, wkport + 0x1b);
-		outb(satn[0], wkport + 3);
-		outb(satn[1], wkport + 4);
-		outb(satn[2], wkport + 5);
-		outb(satn[3], wkport + 6);
-		outb(satn[4], wkport + 7);
-		outb(satn[5], wkport + 8);
-		outb(0, wkport + 0x0f);
-		outb(dev->id[0][i].devsp, wkport + 0x11);
-		outb(0, wkport + 0x12);
-		outb(satn[6], wkport + 0x13);
-		outb(satn[7], wkport + 0x14);
-		outb(satn[8], wkport + 0x18);
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
 
-		while ((inb(wkport + 0x1f) & 0x80) == 0x00)
+		while ((atp_readb_io(dev, 0, 0x1f) & 0x80) == 0x00)
 			cpu_relax();
 			
-		if (inb(wkport + 0x17) != 0x11 && inb(wkport + 0x17) != 0x8e)
+		if (atp_readb_io(dev, 0, 0x17) != 0x11 && atp_readb_io(dev, 0, 0x17) != 0x8e)
 			continue;
 
-		while (inb(wkport + 0x17) != 0x8e)
+		while (atp_readb_io(dev, 0, 0x17) != 0x8e)
 			cpu_relax();
 			
 try_sync:
 		j = 0;
-		outb(0x06, wkport + 0x14);
-		outb(0x20, wkport + 0x18);
+		atp_writeb_io(dev, 0, 0x14, 0x06);
+		atp_writeb_io(dev, 0, 0x18, 0x20);
 
-		while ((inb(wkport + 0x1f) & 0x80) == 0) {
-			if ((inb(wkport + 0x1f) & 0x01) != 0) {
+		while ((atp_readb_io(dev, 0, 0x1f) & 0x80) == 0) {
+			if ((atp_readb_io(dev, 0, 0x1f) & 0x01) != 0) {
 				if ((m & dev->wide_id[0]) != 0) {
-					outb(synw[j++], wkport + 0x19);
+					atp_writeb_io(dev, 0, 0x19, synw[j++]);
 				} else {
 					if ((m & dev->ultra_map[0]) != 0) {
-						outb(synu[j++], wkport + 0x19);
+						atp_writeb_io(dev, 0, 0x19, synu[j++]);
 					} else {
-						outb(synn[j++], wkport + 0x19);
+						atp_writeb_io(dev, 0, 0x19, synn[j++]);
 					}
 				}
 			}
 		}
 		
-		while ((inb(wkport + 0x17) & 0x80) == 0x00)
+		while ((atp_readb_io(dev, 0, 0x17) & 0x80) == 0x00)
 			cpu_relax();
 			
-		j = inb(wkport + 0x17) & 0x0f;
+		j = atp_readb_io(dev, 0, 0x17) & 0x0f;
 		if (j == 0x0f) {
 			goto phase_ins;
 		}
@@ -1490,12 +1490,12 @@ try_sync:
 		}
 		continue;
 phase_outs:
-		outb(0x20, wkport + 0x18);
-		while ((inb(wkport + 0x1f) & 0x80) == 0x00) {
-			if ((inb(wkport + 0x1f) & 0x01) != 0x00)
-				outb(0x00, wkport + 0x19);
+		atp_writeb_io(dev, 0, 0x18, 0x20);
+		while ((atp_readb_io(dev, 0, 0x1f) & 0x80) == 0x00) {
+			if ((atp_readb_io(dev, 0, 0x1f) & 0x01) != 0x00)
+				atp_writeb_io(dev, 0, 0x19, 0x00);
 		}
-		j = inb(wkport + 0x17);
+		j = atp_readb_io(dev, 0, 0x17);
 		if (j == 0x85) {
 			goto tar_dcons;
 		}
@@ -1511,23 +1511,23 @@ phase_outs:
 		}
 		continue;
 phase_ins:
-		outb(0xff, wkport + 0x14);
-		outb(0x20, wkport + 0x18);
+		atp_writeb_io(dev, 0, 0x14, 0xff);
+		atp_writeb_io(dev, 0, 0x18, 0x20);
 		k = 0;
 phase_ins1:
-		j = inb(wkport + 0x1f);
+		j = atp_readb_io(dev, 0, 0x1f);
 		if ((j & 0x01) != 0x00) {
-			mbuf[k++] = inb(wkport + 0x19);
+			mbuf[k++] = atp_readb_io(dev, 0, 0x19);
 			goto phase_ins1;
 		}
 		if ((j & 0x80) == 0x00) {
 			goto phase_ins1;
 		}
 
-		while ((inb(wkport + 0x17) & 0x80) == 0x00)
+		while ((atp_readb_io(dev, 0, 0x17) & 0x80) == 0x00)
 			cpu_relax();
 			
-		j = inb(wkport + 0x17);
+		j = atp_readb_io(dev, 0, 0x17);
 		if (j == 0x85) {
 			goto tar_dcons;
 		}
@@ -1543,15 +1543,15 @@ phase_ins1:
 		}
 		continue;
 phase_cmds:
-		outb(0x30, wkport + 0x10);
+		atp_writeb_io(dev, 0, 0x10, 0x30);
 tar_dcons:
-		outb(0x00, wkport + 0x14);
-		outb(0x08, wkport + 0x18);
+		atp_writeb_io(dev, 0, 0x14, 0x00);
+		atp_writeb_io(dev, 0, 0x18, 0x08);
 		
-		while ((inb(wkport + 0x1f) & 0x80) == 0x00)
+		while ((atp_readb_io(dev, 0, 0x1f) & 0x80) == 0x00)
 			cpu_relax();
 			
-		j = inb(wkport + 0x17);
+		j = atp_readb_io(dev, 0, 0x17);
 		if (j != 0x16) {
 			continue;
 		}
@@ -1591,7 +1591,7 @@ tar_dcons:
 set_syn_ok:
 		dev->id[0][i].devsp = (dev->id[0][i].devsp & 0x0f) | j;
 	}
-	outb((unsigned char) (inb(wkport + 0x3a) & 0xef), wkport + 0x3a);
+	atp_writeb_io(dev, 0, 0x3a, atp_readb_io(dev, 0, 0x3a) & 0xef);
 }
 
 static void is880(struct atp_unit *dev, unsigned int wkport)
@@ -2605,7 +2605,7 @@ flash_ok_885:
 		outb(0x20, base_io + 0x11);
 
 		tscam(shpnt);
-		is870(p, base_io);
+		is870(p);
 		outb((inb(base_io + 0x3a) & 0xef), base_io + 0x3a);
 		outb((inb(base_io + 0x3b) | 0x20), base_io + 0x3b);
 		if (atpdev->chip_ver == 4)
-- 
Ondrej Zary


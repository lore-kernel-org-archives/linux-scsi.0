From: Ondrej Zary <linux@rainbow-software.org>
Subject: [PATCH 06/52] atp870u: Untangle tmport #4
Date: Tue, 17 Nov 2015 19:23:42 +0100
Message-ID: <1447784668-23713-7-git-send-email-linux@rainbow-software.org>
References: <1447784668-23713-1-git-send-email-linux@rainbow-software.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.gsystem.sk ([62.176.172.50]:56420 "EHLO gsystem.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754500AbbKQSYr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Nov 2015 13:24:47 -0500
In-Reply-To: <1447784668-23713-1-git-send-email-linux@rainbow-software.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

Untangle the tmport crap so it becomes obvious what ports are accessed.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/scsi/atp870u.c |  370 ++++++++++++++++++------------------------------
 1 file changed, 138 insertions(+), 232 deletions(-)

diff --git a/drivers/scsi/atp870u.c b/drivers/scsi/atp870u.c
index a23f387..3e3a68b 100644
--- a/drivers/scsi/atp870u.c
+++ b/drivers/scsi/atp870u.c
@@ -1207,7 +1207,6 @@ G2Q_QUIN:		/* k=binID#,       */
 
 static void is870(struct atp_unit *dev, unsigned int wkport)
 {
-	unsigned int tmport;
 	unsigned char i, j, k, rmb, n;
 	unsigned short int m;
 	static unsigned char mbuf[512];
@@ -1218,8 +1217,7 @@ static void is870(struct atp_unit *dev, unsigned int wkport)
 	static unsigned char synw[6] = { 0x80, 1, 3, 1, 0x0c, 0x07 };
 	static unsigned char wide[6] = { 0x80, 1, 2, 3, 1, 0 };
 	
-	tmport = wkport + 0x3a;
-	outb((unsigned char) (inb(tmport) | 0x10), tmport);
+	outb((unsigned char) (inb(wkport + 0x3a) | 0x10), wkport + 0x3a);
 
 	for (i = 0; i < 16; i++) {
 		if ((dev->chip_ver != 4) && (i > 7)) {
@@ -1234,135 +1232,105 @@ static void is870(struct atp_unit *dev, unsigned int wkport)
 			printk(KERN_INFO "         ID: %2d  Host Adapter\n", dev->host_id[0]);
 			continue;
 		}
-		tmport = wkport + 0x1b;
 		if (dev->chip_ver == 4) {
-			outb(0x01, tmport);
+			outb(0x01, wkport + 0x1b);
 		} else {
-			outb(0x00, tmport);
-		}
-		tmport = wkport + 1;
-		outb(0x08, tmport++);
-		outb(0x7f, tmport++);
-		outb(satn[0], tmport++);
-		outb(satn[1], tmport++);
-		outb(satn[2], tmport++);
-		outb(satn[3], tmport++);
-		outb(satn[4], tmport++);
-		outb(satn[5], tmport++);
-		tmport += 0x06;
-		outb(0, tmport);
-		tmport += 0x02;
-		outb(dev->id[0][i].devsp, tmport++);
-		outb(0, tmport++);
-		outb(satn[6], tmport++);
-		outb(satn[7], tmport++);
+			outb(0x00, wkport + 0x1b);
+		}
+		outb(0x08, wkport + 1);
+		outb(0x7f, wkport + 2);
+		outb(satn[0], wkport + 3);
+		outb(satn[1], wkport + 4);
+		outb(satn[2], wkport + 5);
+		outb(satn[3], wkport + 6);
+		outb(satn[4], wkport + 7);
+		outb(satn[5], wkport + 8);
+		outb(0, wkport + 0x0f);
+		outb(dev->id[0][i].devsp, wkport + 0x11);
+		outb(0, wkport + 0x12);
+		outb(satn[6], wkport + 0x13);
+		outb(satn[7], wkport + 0x14);
 		j = i;
 		if ((j & 0x08) != 0) {
 			j = (j & 0x07) | 0x40;
 		}
-		outb(j, tmport);
-		tmport += 0x03;
-		outb(satn[8], tmport);
-		tmport += 0x07;
+		outb(j, wkport + 0x15);
+		outb(satn[8], wkport + 0x18);
 
-		while ((inb(tmport) & 0x80) == 0x00)
+		while ((inb(wkport + 0x1f) & 0x80) == 0x00)
 			cpu_relax();
 
-		tmport -= 0x08;
-		if (inb(tmport) != 0x11 && inb(tmport) != 0x8e)
+		if (inb(wkport + 0x17) != 0x11 && inb(wkport + 0x17) != 0x8e)
 			continue;
 
-		while (inb(tmport) != 0x8e)
+		while (inb(wkport + 0x17) != 0x8e)
 			cpu_relax();
 
 		dev->active_id[0] |= m;
 
-		tmport = wkport + 0x10;
-		outb(0x30, tmport);
-		tmport = wkport + 0x04;
-		outb(0x00, tmport);
+		outb(0x30, wkport + 0x10);
+		outb(0x00, wkport + 0x04);
 
 phase_cmd:
-		tmport = wkport + 0x18;
-		outb(0x08, tmport);
-		tmport += 0x07;
-		while ((inb(tmport) & 0x80) == 0x00)
+		outb(0x08, wkport + 0x18);
+		while ((inb(wkport + 0x1f) & 0x80) == 0x00)
 			cpu_relax();
-		tmport -= 0x08;
-		j = inb(tmport);
+		j = inb(wkport + 0x17);
 		if (j != 0x16) {
-			tmport = wkport + 0x10;
-			outb(0x41, tmport);
+			outb(0x41, wkport + 0x10);
 			goto phase_cmd;
 		}
 sel_ok:
-		tmport = wkport + 3;
-		outb(inqd[0], tmport++);
-		outb(inqd[1], tmport++);
-		outb(inqd[2], tmport++);
-		outb(inqd[3], tmport++);
-		outb(inqd[4], tmport++);
-		outb(inqd[5], tmport);
-		tmport += 0x07;
-		outb(0, tmport);
-		tmport += 0x02;
-		outb(dev->id[0][i].devsp, tmport++);
-		outb(0, tmport++);
-		outb(inqd[6], tmport++);
-		outb(inqd[7], tmport++);
-		tmport += 0x03;
-		outb(inqd[8], tmport);
-		tmport += 0x07;
-
-		while ((inb(tmport) & 0x80) == 0x00)
+		outb(inqd[0], wkport + 3);
+		outb(inqd[1], wkport + 4);
+		outb(inqd[2], wkport + 5);
+		outb(inqd[3], wkport + 6);
+		outb(inqd[4], wkport + 7);
+		outb(inqd[5], wkport + 8);
+		outb(0, wkport + 0x0f);
+		outb(dev->id[0][i].devsp, wkport + 0x11);
+		outb(0, wkport + 0x12);
+		outb(inqd[6], wkport + 0x13);
+		outb(inqd[7], wkport + 0x14);
+		outb(inqd[8], wkport + 0x18);
+
+		while ((inb(wkport + 0x1f) & 0x80) == 0x00)
 			cpu_relax();
 			
-		tmport -= 0x08;
-		if (inb(tmport) != 0x11 && inb(tmport) != 0x8e)
+		if (inb(wkport + 0x17) != 0x11 && inb(wkport + 0x17) != 0x8e)
 			continue;
 
-		while (inb(tmport) != 0x8e)
+		while (inb(wkport + 0x17) != 0x8e)
 			cpu_relax();
 			
-		tmport = wkport + 0x1b;
 		if (dev->chip_ver == 4)
-			outb(0x00, tmport);
+			outb(0x00, wkport + 0x1b);
 
-		tmport = wkport + 0x18;
-		outb(0x08, tmport);
-		tmport += 0x07;
+		outb(0x08, wkport + 0x18);
 		j = 0;
 rd_inq_data:
-		k = inb(tmport);
+		k = inb(wkport + 0x1f);
 		if ((k & 0x01) != 0) {
-			tmport -= 0x06;
-			mbuf[j++] = inb(tmport);
-			tmport += 0x06;
+			mbuf[j++] = inb(wkport + 0x19);
 			goto rd_inq_data;
 		}
 		if ((k & 0x80) == 0) {
 			goto rd_inq_data;
 		}
-		tmport -= 0x08;
-		j = inb(tmport);
+		j = inb(wkport + 0x17);
 		if (j == 0x16) {
 			goto inq_ok;
 		}
-		tmport = wkport + 0x10;
-		outb(0x46, tmport);
-		tmport += 0x02;
-		outb(0, tmport++);
-		outb(0, tmport++);
-		outb(0, tmport++);
-		tmport += 0x03;
-		outb(0x08, tmport);
-		tmport += 0x07;
+		outb(0x46, wkport + 0x10);
+		outb(0, wkport + 0x12);
+		outb(0, wkport + 0x13);
+		outb(0, wkport + 0x14);
+		outb(0x08, wkport + 0x18);
 
-		while ((inb(tmport) & 0x80) == 0x00)
+		while ((inb(wkport + 0x1f) & 0x80) == 0x00)
 			cpu_relax();
 			
-		tmport -= 0x08;
-		if (inb(tmport) != 0x16) {
+		if (inb(wkport + 0x17) != 0x16) {
 			goto sel_ok;
 		}
 inq_ok:
@@ -1380,57 +1348,43 @@ inq_ok:
 		if ((dev->global_map[0] & 0x20) == 0) {
 			goto not_wide;
 		}
-		tmport = wkport + 0x1b;
-		outb(0x01, tmport);
-		tmport = wkport + 3;
-		outb(satn[0], tmport++);
-		outb(satn[1], tmport++);
-		outb(satn[2], tmport++);
-		outb(satn[3], tmport++);
-		outb(satn[4], tmport++);
-		outb(satn[5], tmport++);
-		tmport += 0x06;
-		outb(0, tmport);
-		tmport += 0x02;
-		outb(dev->id[0][i].devsp, tmport++);
-		outb(0, tmport++);
-		outb(satn[6], tmport++);
-		outb(satn[7], tmport++);
-		tmport += 0x03;
-		outb(satn[8], tmport);
-		tmport += 0x07;
-
-		while ((inb(tmport) & 0x80) == 0x00)
+		outb(0x01, wkport + 0x1b);
+		outb(satn[0], wkport + 3);
+		outb(satn[1], wkport + 4);
+		outb(satn[2], wkport + 5);
+		outb(satn[3], wkport + 6);
+		outb(satn[4], wkport + 7);
+		outb(satn[5], wkport + 8);
+		outb(0, wkport + 0x0f);
+		outb(dev->id[0][i].devsp, wkport + 0x11);
+		outb(0, wkport + 0x12);
+		outb(satn[6], wkport + 0x13);
+		outb(satn[7], wkport + 0x14);
+		outb(satn[8], wkport + 0x18);
+
+		while ((inb(wkport + 0x1f) & 0x80) == 0x00)
 			cpu_relax();
 			
-		tmport -= 0x08;
-		if (inb(tmport) != 0x11 && inb(tmport) != 0x8e)
+		if (inb(wkport + 0x17) != 0x11 && inb(wkport + 0x17) != 0x8e)
 			continue;
 
-		while (inb(tmport) != 0x8e)
+		while (inb(wkport + 0x17) != 0x8e)
 			cpu_relax();
 			
 try_wide:
 		j = 0;
-		tmport = wkport + 0x14;
-		outb(0x05, tmport);
-		tmport += 0x04;
-		outb(0x20, tmport);
-		tmport += 0x07;
+		outb(0x05, wkport + 0x14);
+		outb(0x20, wkport + 0x18);
 
-		while ((inb(tmport) & 0x80) == 0) {
-			if ((inb(tmport) & 0x01) != 0) {
-				tmport -= 0x06;
-				outb(wide[j++], tmport);
-				tmport += 0x06;
-			}
+		while ((inb(wkport + 0x1f) & 0x80) == 0) {
+			if ((inb(wkport + 0x1f) & 0x01) != 0)
+				outb(wide[j++], wkport + 0x19);
 		}
-		tmport -= 0x08;
 		
-		while ((inb(tmport) & 0x80) == 0x00)
+		while ((inb(wkport + 0x17) & 0x80) == 0x00)
 			cpu_relax();
 			
-		j = inb(tmport) & 0x0f;
+		j = inb(wkport + 0x17) & 0x0f;
 		if (j == 0x0f) {
 			goto widep_in;
 		}
@@ -1442,18 +1396,12 @@ try_wide:
 		}
 		continue;
 widep_out:
-		tmport = wkport + 0x18;
-		outb(0x20, tmport);
-		tmport += 0x07;
-		while ((inb(tmport) & 0x80) == 0) {
-			if ((inb(tmport) & 0x01) != 0) {
-				tmport -= 0x06;
-				outb(0, tmport);
-				tmport += 0x06;
-			}
+		outb(0x20, wkport + 0x18);
+		while ((inb(wkport + 0x1f) & 0x80) == 0) {
+			if ((inb(wkport + 0x1f) & 0x01) != 0)
+				outb(0, wkport + 0x19);
 		}
-		tmport -= 0x08;
-		j = inb(tmport) & 0x0f;
+		j = inb(wkport + 0x17) & 0x0f;
 		if (j == 0x0f) {
 			goto widep_in;
 		}
@@ -1465,25 +1413,19 @@ widep_out:
 		}
 		continue;
 widep_in:
-		tmport = wkport + 0x14;
-		outb(0xff, tmport);
-		tmport += 0x04;
-		outb(0x20, tmport);
-		tmport += 0x07;
+		outb(0xff, wkport + 0x14);
+		outb(0x20, wkport + 0x18);
 		k = 0;
 widep_in1:
-		j = inb(tmport);
+		j = inb(wkport + 0x1f);
 		if ((j & 0x01) != 0) {
-			tmport -= 0x06;
-			mbuf[k++] = inb(tmport);
-			tmport += 0x06;
+			mbuf[k++] = inb(wkport + 0x19);
 			goto widep_in1;
 		}
 		if ((j & 0x80) == 0x00) {
 			goto widep_in1;
 		}
-		tmport -= 0x08;
-		j = inb(tmport) & 0x0f;
+		j = inb(wkport + 0x17) & 0x0f;
 		if (j == 0x0f) {
 			goto widep_in;
 		}
@@ -1495,19 +1437,14 @@ widep_in1:
 		}
 		continue;
 widep_cmd:
-		tmport = wkport + 0x10;
-		outb(0x30, tmport);
-		tmport = wkport + 0x14;
-		outb(0x00, tmport);
-		tmport += 0x04;
-		outb(0x08, tmport);
-		tmport += 0x07;
+		outb(0x30, wkport + 0x10);
+		outb(0x00, wkport + 0x14);
+		outb(0x08, wkport + 0x18);
 		
-		while ((inb(tmport) & 0x80) == 0x00)
+		while ((inb(wkport + 0x1f) & 0x80) == 0x00)
 			cpu_relax();
 
-		tmport -= 0x08;
-		j = inb(tmport);
+		j = inb(wkport + 0x17);
 		if (j != 0x16) {
 			if (j == 0x4e) {
 				goto widep_out;
@@ -1535,69 +1472,56 @@ not_wide:
 		}
 		continue;
 set_sync:
-		tmport = wkport + 0x1b;
 		j = 0;
 		if ((m & dev->wide_id[0]) != 0) {
 			j |= 0x01;
 		}
-		outb(j, tmport);
-		tmport = wkport + 3;
-		outb(satn[0], tmport++);
-		outb(satn[1], tmport++);
-		outb(satn[2], tmport++);
-		outb(satn[3], tmport++);
-		outb(satn[4], tmport++);
-		outb(satn[5], tmport++);
-		tmport += 0x06;
-		outb(0, tmport);
-		tmport += 0x02;
-		outb(dev->id[0][i].devsp, tmport++);
-		outb(0, tmport++);
-		outb(satn[6], tmport++);
-		outb(satn[7], tmport++);
-		tmport += 0x03;
-		outb(satn[8], tmport);
-		tmport += 0x07;
-
-		while ((inb(tmport) & 0x80) == 0x00)
+		outb(j, wkport + 0x1b);
+		outb(satn[0], wkport + 3);
+		outb(satn[1], wkport + 4);
+		outb(satn[2], wkport + 5);
+		outb(satn[3], wkport + 6);
+		outb(satn[4], wkport + 7);
+		outb(satn[5], wkport + 8);
+		outb(0, wkport + 0x0f);
+		outb(dev->id[0][i].devsp, wkport + 0x11);
+		outb(0, wkport + 0x12);
+		outb(satn[6], wkport + 0x13);
+		outb(satn[7], wkport + 0x14);
+		outb(satn[8], wkport + 0x18);
+
+		while ((inb(wkport + 0x1f) & 0x80) == 0x00)
 			cpu_relax();
 			
-		tmport -= 0x08;
-		if (inb(tmport) != 0x11 && inb(tmport) != 0x8e)
+		if (inb(wkport + 0x17) != 0x11 && inb(wkport + 0x17) != 0x8e)
 			continue;
 
-		while (inb(tmport) != 0x8e)
+		while (inb(wkport + 0x17) != 0x8e)
 			cpu_relax();
 			
 try_sync:
 		j = 0;
-		tmport = wkport + 0x14;
-		outb(0x06, tmport);
-		tmport += 0x04;
-		outb(0x20, tmport);
-		tmport += 0x07;
+		outb(0x06, wkport + 0x14);
+		outb(0x20, wkport + 0x18);
 
-		while ((inb(tmport) & 0x80) == 0) {
-			if ((inb(tmport) & 0x01) != 0) {
-				tmport -= 0x06;
+		while ((inb(wkport + 0x1f) & 0x80) == 0) {
+			if ((inb(wkport + 0x1f) & 0x01) != 0) {
 				if ((m & dev->wide_id[0]) != 0) {
-					outb(synw[j++], tmport);
+					outb(synw[j++], wkport + 0x19);
 				} else {
 					if ((m & dev->ultra_map[0]) != 0) {
-						outb(synu[j++], tmport);
+						outb(synu[j++], wkport + 0x19);
 					} else {
-						outb(synn[j++], tmport);
+						outb(synn[j++], wkport + 0x19);
 					}
 				}
-				tmport += 0x06;
 			}
 		}
-		tmport -= 0x08;
 		
-		while ((inb(tmport) & 0x80) == 0x00)
+		while ((inb(wkport + 0x17) & 0x80) == 0x00)
 			cpu_relax();
 			
-		j = inb(tmport) & 0x0f;
+		j = inb(wkport + 0x17) & 0x0f;
 		if (j == 0x0f) {
 			goto phase_ins;
 		}
@@ -1609,18 +1533,12 @@ try_sync:
 		}
 		continue;
 phase_outs:
-		tmport = wkport + 0x18;
-		outb(0x20, tmport);
-		tmport += 0x07;
-		while ((inb(tmport) & 0x80) == 0x00) {
-			if ((inb(tmport) & 0x01) != 0x00) {
-				tmport -= 0x06;
-				outb(0x00, tmport);
-				tmport += 0x06;
-			}
+		outb(0x20, wkport + 0x18);
+		while ((inb(wkport + 0x1f) & 0x80) == 0x00) {
+			if ((inb(wkport + 0x1f) & 0x01) != 0x00)
+				outb(0x00, wkport + 0x19);
 		}
-		tmport -= 0x08;
-		j = inb(tmport);
+		j = inb(wkport + 0x17);
 		if (j == 0x85) {
 			goto tar_dcons;
 		}
@@ -1636,29 +1554,23 @@ phase_outs:
 		}
 		continue;
 phase_ins:
-		tmport = wkport + 0x14;
-		outb(0xff, tmport);
-		tmport += 0x04;
-		outb(0x20, tmport);
-		tmport += 0x07;
+		outb(0xff, wkport + 0x14);
+		outb(0x20, wkport + 0x18);
 		k = 0;
 phase_ins1:
-		j = inb(tmport);
+		j = inb(wkport + 0x1f);
 		if ((j & 0x01) != 0x00) {
-			tmport -= 0x06;
-			mbuf[k++] = inb(tmport);
-			tmport += 0x06;
+			mbuf[k++] = inb(wkport + 0x19);
 			goto phase_ins1;
 		}
 		if ((j & 0x80) == 0x00) {
 			goto phase_ins1;
 		}
-		tmport -= 0x08;
 
-		while ((inb(tmport) & 0x80) == 0x00)
+		while ((inb(wkport + 0x17) & 0x80) == 0x00)
 			cpu_relax();
 			
-		j = inb(tmport);
+		j = inb(wkport + 0x17);
 		if (j == 0x85) {
 			goto tar_dcons;
 		}
@@ -1674,20 +1586,15 @@ phase_ins1:
 		}
 		continue;
 phase_cmds:
-		tmport = wkport + 0x10;
-		outb(0x30, tmport);
+		outb(0x30, wkport + 0x10);
 tar_dcons:
-		tmport = wkport + 0x14;
-		outb(0x00, tmport);
-		tmport += 0x04;
-		outb(0x08, tmport);
-		tmport += 0x07;
+		outb(0x00, wkport + 0x14);
+		outb(0x08, wkport + 0x18);
 		
-		while ((inb(tmport) & 0x80) == 0x00)
+		while ((inb(wkport + 0x1f) & 0x80) == 0x00)
 			cpu_relax();
 			
-		tmport -= 0x08;
-		j = inb(tmport);
+		j = inb(wkport + 0x17);
 		if (j != 0x16) {
 			continue;
 		}
@@ -1727,8 +1634,7 @@ tar_dcons:
 set_syn_ok:
 		dev->id[0][i].devsp = (dev->id[0][i].devsp & 0x0f) | j;
 	}
-	tmport = wkport + 0x3a;
-	outb((unsigned char) (inb(tmport) & 0xef), tmport);
+	outb((unsigned char) (inb(wkport + 0x3a) & 0xef), wkport + 0x3a);
 }
 
 static void is880(struct atp_unit *dev, unsigned int wkport)
-- 
Ondrej Zary


From: Ondrej Zary <linux@rainbow-software.org>
Subject: [PATCH 10/52] atp870u: Untangle tmport #8
Date: Tue, 17 Nov 2015 19:23:46 +0100
Message-ID: <1447784668-23713-11-git-send-email-linux@rainbow-software.org>
References: <1447784668-23713-1-git-send-email-linux@rainbow-software.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.gsystem.sk ([62.176.172.50]:56511 "EHLO gsystem.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751787AbbKQSgg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Nov 2015 13:36:36 -0500
In-Reply-To: <1447784668-23713-1-git-send-email-linux@rainbow-software.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

Untangle the tmport crap so it becomes obvious what ports are accessed.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/scsi/atp870u.c |  478 ++++++++++++++++++------------------------------
 1 file changed, 177 insertions(+), 301 deletions(-)

diff --git a/drivers/scsi/atp870u.c b/drivers/scsi/atp870u.c
index f5a11f4..993442d 100644
--- a/drivers/scsi/atp870u.c
+++ b/drivers/scsi/atp870u.c
@@ -2870,7 +2870,6 @@ static void tscam_885(void)
 
 static void is885(struct atp_unit *dev, unsigned int wkport,unsigned char c)
 {
-	unsigned int tmport;
 	unsigned char i, j, k, rmb, n, lvdmode;
 	unsigned short int m;
 	static unsigned char mbuf[512];
@@ -2895,123 +2894,93 @@ static void is885(struct atp_unit *dev, unsigned int wkport,unsigned char c)
 			printk(KERN_INFO "         ID: %2d  Host Adapter\n", dev->host_id[c]);
 			continue;
 		}
-		tmport = wkport + 0x1b;
-		outb(0x01, tmport);
-		tmport = wkport + 0x01;
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
-		outb(dev->id[c][i].devsp, tmport++);
+		outb(0x01, wkport + 0x1b);
+		outb(0x08, wkport + 0x01);
+		outb(0x7f, wkport + 0x02);
+		outb(satn[0], wkport + 0x03);
+		outb(satn[1], wkport + 0x04);
+		outb(satn[2], wkport + 0x05);
+		outb(satn[3], wkport + 0x06);
+		outb(satn[4], wkport + 0x07);
+		outb(satn[5], wkport + 0x08);
+		outb(0, wkport + 0x0f);
+		outb(dev->id[c][i].devsp, wkport + 0x11);
 		
-		outb(0, tmport++);
-		outb(satn[6], tmport++);
-		outb(satn[7], tmport++);
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
-		if ((inb(tmport) != 0x11) && (inb(tmport) != 0x8e)) {
+		if ((inb(wkport + 0x17) != 0x11) && (inb(wkport + 0x17) != 0x8e)) {
 			continue;
 		}
-		while (inb(tmport) != 0x8e)
+		while (inb(wkport + 0x17) != 0x8e)
 			cpu_relax();
 		dev->active_id[c] |= m;
 
-		tmport = wkport + 0x10;
-		outb(0x30, tmport);
-		tmport = wkport + 0x14;
-		outb(0x00, tmport);
+		outb(0x30, wkport + 0x10);
+		outb(0x00, wkport + 0x14);
 
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
-		tmport = wkport + 0x03;
-		outb(inqd[0], tmport++);
-		outb(inqd[1], tmport++);
-		outb(inqd[2], tmport++);
-		outb(inqd[3], tmport++);
-		outb(inqd[4], tmport++);
-		outb(inqd[5], tmport);
-		tmport += 0x07;
-		outb(0, tmport);
-		tmport += 0x02;
-		outb(dev->id[c][i].devsp, tmport++);
-		outb(0, tmport++);
-		outb(inqd[6], tmport++);
-		outb(inqd[7], tmport++);
-		tmport += 0x03;
-		outb(inqd[8], tmport);
-		tmport += 0x07;
-		while ((inb(tmport) & 0x80) == 0x00)
+		outb(inqd[0], wkport + 0x03);
+		outb(inqd[1], wkport + 0x04);
+		outb(inqd[2], wkport + 0x05);
+		outb(inqd[3], wkport + 0x06);
+		outb(inqd[4], wkport + 0x07);
+		outb(inqd[5], wkport + 0x08);
+		outb(0, wkport + 0x0f);
+		outb(dev->id[c][i].devsp, wkport + 0x11);
+		outb(0, wkport + 0x12);
+		outb(inqd[6], wkport + 0x13);
+		outb(inqd[7], wkport + 0x14);
+		outb(inqd[8], wkport + 0x18);
+		while ((inb(wkport + 0x1f) & 0x80) == 0x00)
 			cpu_relax();
-		tmport -= 0x08;
-		if ((inb(tmport) != 0x11) && (inb(tmport) != 0x8e)) {
+		if ((inb(wkport + 0x17) != 0x11) && (inb(wkport + 0x17) != 0x8e)) {
 			continue;
 		}
-		while (inb(tmport) != 0x8e)
+		while (inb(wkport + 0x17) != 0x8e)
 			cpu_relax();
-		tmport = wkport + 0x1b;
-		outb(0x00, tmport);
-		tmport = wkport + 0x18;
-		outb(0x08, tmport);
-		tmport += 0x07;
+		outb(0x00, wkport + 0x1b);
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
-		while ((inb(tmport) & 0x80) == 0x00)
+		outb(0x46, wkport + 0x10);
+		outb(0, wkport + 0x12);
+		outb(0, wkport + 0x13);
+		outb(0, wkport + 0x14);
+		outb(0x08, wkport + 0x18);
+		while ((inb(wkport + 0x1f) & 0x80) == 0x00)
 			cpu_relax();
-		tmport -= 0x08;
-		if (inb(tmport) != 0x16) {
+		if (inb(wkport + 0x17) != 0x16) {
 			goto sel_ok;
 		}
 inq_ok:
@@ -3033,54 +3002,40 @@ inq_ok:
 		   goto chg_wide;
 		}
 
-		tmport = wkport + 0x1b;
-		outb(0x01, tmport);
-		tmport = wkport + 0x03;
-		outb(satn[0], tmport++);
-		outb(satn[1], tmport++);
-		outb(satn[2], tmport++);
-		outb(satn[3], tmport++);
-		outb(satn[4], tmport++);
-		outb(satn[5], tmport++);
-		tmport += 0x06;
-		outb(0, tmport);
-		tmport += 0x02;
-		outb(dev->id[c][i].devsp, tmport++);
-		outb(0, tmport++);
-		outb(satn[6], tmport++);
-		outb(satn[7], tmport++);
-		tmport += 0x03;
-		outb(satn[8], tmport);
-		tmport += 0x07;
-
-		while ((inb(tmport) & 0x80) == 0x00)
+		outb(0x01, wkport + 0x1b);
+		outb(satn[0], wkport + 0x03);
+		outb(satn[1], wkport + 0x04);
+		outb(satn[2], wkport + 0x05);
+		outb(satn[3], wkport + 0x06);
+		outb(satn[4], wkport + 0x07);
+		outb(satn[5], wkport + 0x08);
+		outb(0, wkport + 0x0f);
+		outb(dev->id[c][i].devsp, wkport + 0x11);
+		outb(0, wkport + 0x12);
+		outb(satn[6], wkport + 0x13);
+		outb(satn[7], wkport + 0x14);
+		outb(satn[8], wkport + 0x18);
+
+		while ((inb(wkport + 0x1f) & 0x80) == 0x00)
 			cpu_relax();
-		tmport -= 0x08;
-		if ((inb(tmport) != 0x11) && (inb(tmport) != 0x8e)) {
+		if ((inb(wkport + 0x17) != 0x11) && (inb(wkport + 0x17) != 0x8e)) {
 			continue;
 		}
-		while (inb(tmport) != 0x8e)
+		while (inb(wkport + 0x17) != 0x8e)
 			cpu_relax();
 try_u3:
 		j = 0;
-		tmport = wkport + 0x14;
-		outb(0x09, tmport);
-		tmport += 0x04;
-		outb(0x20, tmport);
-		tmport += 0x07;
-
-		while ((inb(tmport) & 0x80) == 0) {
-			if ((inb(tmport) & 0x01) != 0) {
-				tmport -= 0x06;
-				outb(u3[j++], tmport);
-				tmport += 0x06;
-			}
+		outb(0x09, wkport + 0x14);
+		outb(0x20, wkport + 0x18);
+
+		while ((inb(wkport + 0x1f) & 0x80) == 0) {
+			if ((inb(wkport + 0x1f) & 0x01) != 0)
+				outb(u3[j++], wkport + 0x19);
 			cpu_relax();
 		}
-		tmport -= 0x08;
-		while ((inb(tmport) & 0x80) == 0x00)
+		while ((inb(wkport + 0x17) & 0x80) == 0x00)
 			cpu_relax();
-		j = inb(tmport) & 0x0f;
+		j = inb(wkport + 0x17) & 0x0f;
 		if (j == 0x0f) {
 			goto u3p_in;
 		}
@@ -3092,19 +3047,13 @@ try_u3:
 		}
 		continue;
 u3p_out:
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
 			cpu_relax();
 		}
-		tmport -= 0x08;
-		j = inb(tmport) & 0x0f;
+		j = inb(wkport + 0x17) & 0x0f;
 		if (j == 0x0f) {
 			goto u3p_in;
 		}
@@ -3116,25 +3065,19 @@ u3p_out:
 		}
 		continue;
 u3p_in:
-		tmport = wkport + 0x14;
-		outb(0x09, tmport);
-		tmport += 0x04;
-		outb(0x20, tmport);
-		tmport += 0x07;
+		outb(0x09, wkport + 0x14);
+		outb(0x20, wkport + 0x18);
 		k = 0;
 u3p_in1:
-		j = inb(tmport);
+		j = inb(wkport + 0x1f);
 		if ((j & 0x01) != 0) {
-			tmport -= 0x06;
-			mbuf[k++] = inb(tmport);
-			tmport += 0x06;
+			mbuf[k++] = inb(wkport + 0x19);
 			goto u3p_in1;
 		}
 		if ((j & 0x80) == 0x00) {
 			goto u3p_in1;
 		}
-		tmport -= 0x08;
-		j = inb(tmport) & 0x0f;
+		j = inb(wkport + 0x17) & 0x0f;
 		if (j == 0x0f) {
 			goto u3p_in;
 		}
@@ -3146,16 +3089,11 @@ u3p_in1:
 		}
 		continue;
 u3p_cmd:
-		tmport = wkport + 0x10;
-		outb(0x30, tmport);
-		tmport = wkport + 0x14;
-		outb(0x00, tmport);
-		tmport += 0x04;
-		outb(0x08, tmport);
-		tmport += 0x07;
-		while ((inb(tmport) & 0x80) == 0x00);
-		tmport -= 0x08;
-		j = inb(tmport);
+		outb(0x30, wkport + 0x10);
+		outb(0x00, wkport + 0x14);
+		outb(0x08, wkport + 0x18);
+		while ((inb(wkport + 0x1f) & 0x80) == 0x00);
+		j = inb(wkport + 0x17);
 		if (j != 0x16) {
 			if (j == 0x4e) {
 				goto u3p_out;
@@ -3182,54 +3120,40 @@ u3p_cmd:
 			continue;
 		}
 chg_wide:
-		tmport = wkport + 0x1b;
-		outb(0x01, tmport);
-		tmport = wkport + 0x03;
-		outb(satn[0], tmport++);
-		outb(satn[1], tmport++);
-		outb(satn[2], tmport++);
-		outb(satn[3], tmport++);
-		outb(satn[4], tmport++);
-		outb(satn[5], tmport++);
-		tmport += 0x06;
-		outb(0, tmport);
-		tmport += 0x02;
-		outb(dev->id[c][i].devsp, tmport++);
-		outb(0, tmport++);
-		outb(satn[6], tmport++);
-		outb(satn[7], tmport++);
-		tmport += 0x03;
-		outb(satn[8], tmport);
-		tmport += 0x07;
-
-		while ((inb(tmport) & 0x80) == 0x00)
+		outb(0x01, wkport + 0x1b);
+		outb(satn[0], wkport + 0x03);
+		outb(satn[1], wkport + 0x04);
+		outb(satn[2], wkport + 0x05);
+		outb(satn[3], wkport + 0x06);
+		outb(satn[4], wkport + 0x07);
+		outb(satn[5], wkport + 0x08);
+		outb(0, wkport + 0x0f);
+		outb(dev->id[c][i].devsp, wkport + 0x11);
+		outb(0, wkport + 0x12);
+		outb(satn[6], wkport + 0x13);
+		outb(satn[7], wkport + 0x14);
+		outb(satn[8], wkport + 0x18);
+
+		while ((inb(wkport + 0x1f) & 0x80) == 0x00)
 			cpu_relax();
-		tmport -= 0x08;
-		if ((inb(tmport) != 0x11) && (inb(tmport) != 0x8e)) {
+		if ((inb(wkport + 0x17) != 0x11) && (inb(wkport + 0x17) != 0x8e)) {
 			continue;
 		}
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
-
-		while ((inb(tmport) & 0x80) == 0) {
-			if ((inb(tmport) & 0x01) != 0) {
-				tmport -= 0x06;
-				outb(wide[j++], tmport);
-				tmport += 0x06;
-			}
+		outb(0x05, wkport + 0x14);
+		outb(0x20, wkport + 0x18);
+
+		while ((inb(wkport + 0x1f) & 0x80) == 0) {
+			if ((inb(wkport + 0x1f) & 0x01) != 0)
+				outb(wide[j++], wkport + 0x19);
 			cpu_relax();
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
@@ -3241,19 +3165,13 @@ try_wide:
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
 			cpu_relax();
 		}
-		tmport -= 0x08;
-		j = inb(tmport) & 0x0f;
+		j = inb(wkport + 0x17) & 0x0f;
 		if (j == 0x0f) {
 			goto widep_in;
 		}
@@ -3265,25 +3183,19 @@ widep_out:
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
@@ -3295,17 +3207,12 @@ widep_in1:
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
-		while ((inb(tmport) & 0x80) == 0x00)
+		outb(0x30, wkport + 0x10);
+		outb(0x00, wkport + 0x14);
+		outb(0x08, wkport + 0x18);
+		while ((inb(wkport + 0x1f) & 0x80) == 0x00)
 			cpu_relax();
-		tmport -= 0x08;
-		j = inb(tmport);
+		j = inb(wkport + 0x17);
 		if (j != 0x16) {
 			if (j == 0x4e) {
 				goto widep_out;
@@ -3347,69 +3254,56 @@ set_sync:
 		      synuw[4]=0x0a;
 		   }
 		}
-		tmport = wkport + 0x1b;
 		j = 0;
 		if ((m & dev->wide_id[c]) != 0) {
 			j |= 0x01;
 		}
-		outb(j, tmport);
-		tmport = wkport + 0x03;
-		outb(satn[0], tmport++);
-		outb(satn[1], tmport++);
-		outb(satn[2], tmport++);
-		outb(satn[3], tmport++);
-		outb(satn[4], tmport++);
-		outb(satn[5], tmport++);
-		tmport += 0x06;
-		outb(0, tmport);
-		tmport += 0x02;
-		outb(dev->id[c][i].devsp, tmport++);
-		outb(0, tmport++);
-		outb(satn[6], tmport++);
-		outb(satn[7], tmport++);
-		tmport += 0x03;
-		outb(satn[8], tmport);
-		tmport += 0x07;
-
-		while ((inb(tmport) & 0x80) == 0x00)
+		outb(j, wkport + 0x1b);
+		outb(satn[0], wkport + 0x03);
+		outb(satn[1], wkport + 0x04);
+		outb(satn[2], wkport + 0x05);
+		outb(satn[3], wkport + 0x06);
+		outb(satn[4], wkport + 0x07);
+		outb(satn[5], wkport + 0x08);
+		outb(0, wkport + 0x0f);
+		outb(dev->id[c][i].devsp, wkport + 0x11);
+		outb(0, wkport + 0x12);
+		outb(satn[6], wkport + 0x13);
+		outb(satn[7], wkport + 0x14);
+		outb(satn[8], wkport + 0x18);
+
+		while ((inb(wkport + 0x1f) & 0x80) == 0x00)
 			cpu_relax();
-		tmport -= 0x08;
-		if ((inb(tmport) != 0x11) && (inb(tmport) != 0x8e)) {
+		if ((inb(wkport + 0x17) != 0x11) && (inb(wkport + 0x17) != 0x8e)) {
 			continue;
 		}
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
-
-		while ((inb(tmport) & 0x80) == 0) {
-			if ((inb(tmport) & 0x01) != 0) {
-				tmport -= 0x06;
+		outb(0x06, wkport + 0x14);
+		outb(0x20, wkport + 0x18);
+
+		while ((inb(wkport + 0x1f) & 0x80) == 0) {
+			if ((inb(wkport + 0x1f) & 0x01) != 0) {
 				if ((m & dev->wide_id[c]) != 0) {
 					if ((m & dev->ultra_map[c]) != 0) {
-						outb(synuw[j++], tmport);
+						outb(synuw[j++], wkport + 0x19);
 					} else {
-						outb(synw[j++], tmport);
+						outb(synw[j++], wkport + 0x19);
 					}
 				} else {
 					if ((m & dev->ultra_map[c]) != 0) {
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
@@ -3421,19 +3315,13 @@ try_sync:
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
 			cpu_relax();
 		}
-		tmport -= 0x08;
-		j = inb(tmport);
+		j = inb(wkport + 0x17);
 		if (j == 0x85) {
 			goto tar_dcons;
 		}
@@ -3449,26 +3337,20 @@ phase_outs:
 		}
 		continue;
 phase_ins:
-		tmport = wkport + 0x14;
-		outb(0x06, tmport);
-		tmport += 0x04;
-		outb(0x20, tmport);
-		tmport += 0x07;
+		outb(0x06, wkport + 0x14);
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
-		while ((inb(tmport) & 0x80) == 0x00);
-		j = inb(tmport);
+		while ((inb(wkport + 0x17) & 0x80) == 0x00);
+		j = inb(wkport + 0x17);
 		if (j == 0x85) {
 			goto tar_dcons;
 		}
@@ -3484,18 +3366,13 @@ phase_ins1:
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
-		while ((inb(tmport) & 0x80) == 0x00)
+		outb(0x00, wkport + 0x14);
+		outb(0x08, wkport + 0x18);
+		while ((inb(wkport + 0x1f) & 0x80) == 0x00)
 			cpu_relax();
-		tmport -= 0x08;
-		j = inb(tmport);
+		j = inb(wkport + 0x17);
 		if (j != 0x16) {
 			continue;
 		}
@@ -3542,8 +3419,7 @@ tar_dcons:
 		printk("dev->id[%2d][%2d].devsp = %2x\n",c,i,dev->id[c][i].devsp);
 #endif
 	}
-	tmport = wkport + 0x16;
-	outb(0x80, tmport);
+	outb(0x80, wkport + 0x16);
 }
 
 module_init(atp870u_init);
-- 
Ondrej Zary


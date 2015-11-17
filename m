From: Ondrej Zary <linux@rainbow-software.org>
Subject: [PATCH 23/52] atp870u: Add channel parameter to is870() and is880()
Date: Tue, 17 Nov 2015 19:23:59 +0100
Message-ID: <1447784668-23713-24-git-send-email-linux@rainbow-software.org>
References: <1447784668-23713-1-git-send-email-linux@rainbow-software.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.gsystem.sk ([62.176.172.50]:56581 "EHLO gsystem.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754551AbbKQSiF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Nov 2015 13:38:05 -0500
In-Reply-To: <1447784668-23713-1-git-send-email-linux@rainbow-software.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

Add channel parameter to is870() and is880() functions to simplify comparing
them with is885().

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/scsi/atp870u.c |  684 ++++++++++++++++++++++++------------------------
 1 file changed, 342 insertions(+), 342 deletions(-)

diff --git a/drivers/scsi/atp870u.c b/drivers/scsi/atp870u.c
index 595c5c5..ec61902 100644
--- a/drivers/scsi/atp870u.c
+++ b/drivers/scsi/atp870u.c
@@ -1162,7 +1162,7 @@ static void tscam(struct Scsi_Host *host)
 	}
 }
 
-static void is870(struct atp_unit *dev)
+static void is870(struct atp_unit *dev, unsigned char c)
 {
 	unsigned char i, j, k, rmb, n;
 	unsigned short int m;
@@ -1174,7 +1174,7 @@ static void is870(struct atp_unit *dev)
 	static unsigned char synw[6] = { 0x80, 1, 3, 1, 0x0c, 0x07 };
 	static unsigned char wide[6] = { 0x80, 1, 2, 3, 1, 0 };
 
-	atp_writeb_io(dev, 0, 0x3a, atp_readb_io(dev, 0, 0x3a) | 0x10);
+	atp_writeb_io(dev, c, 0x3a, atp_readb_io(dev, c, 0x3a) | 0x10);
 
 	for (i = 0; i < 16; i++) {
 		if ((dev->chip_ver != 4) && (i > 7)) {
@@ -1182,120 +1182,120 @@ static void is870(struct atp_unit *dev)
 		}
 		m = 1;
 		m = m << i;
-		if ((m & dev->active_id[0]) != 0) {
+		if ((m & dev->active_id[c]) != 0) {
 			continue;
 		}
-		if (i == dev->host_id[0]) {
-			printk(KERN_INFO "         ID: %2d  Host Adapter\n", dev->host_id[0]);
+		if (i == dev->host_id[c]) {
+			printk(KERN_INFO "         ID: %2d  Host Adapter\n", dev->host_id[c]);
 			continue;
 		}
 		if (dev->chip_ver == 4) {
-			atp_writeb_io(dev, 0, 0x1b, 0x01);
+			atp_writeb_io(dev, c, 0x1b, 0x01);
 		} else {
-			atp_writeb_io(dev, 0, 0x1b, 0x00);
+			atp_writeb_io(dev, c, 0x1b, 0x00);
 		}
-		atp_writeb_io(dev, 0, 1, 0x08);
-		atp_writeb_io(dev, 0, 2, 0x7f);
-		atp_writeb_io(dev, 0, 3, satn[0]);
-		atp_writeb_io(dev, 0, 4, satn[1]);
-		atp_writeb_io(dev, 0, 5, satn[2]);
-		atp_writeb_io(dev, 0, 6, satn[3]);
-		atp_writeb_io(dev, 0, 7, satn[4]);
-		atp_writeb_io(dev, 0, 8, satn[5]);
-		atp_writeb_io(dev, 0, 0x0f, 0);
-		atp_writeb_io(dev, 0, 0x11, dev->id[0][i].devsp);
-		atp_writeb_io(dev, 0, 0x12, 0);
-		atp_writeb_io(dev, 0, 0x13, satn[6]);
-		atp_writeb_io(dev, 0, 0x14, satn[7]);
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
+		atp_writeb_io(dev, c, 0x12, 0);
+		atp_writeb_io(dev, c, 0x13, satn[6]);
+		atp_writeb_io(dev, c, 0x14, satn[7]);
 		j = i;
 		if ((j & 0x08) != 0) {
 			j = (j & 0x07) | 0x40;
 		}
-		atp_writeb_io(dev, 0, 0x15, j);
-		atp_writeb_io(dev, 0, 0x18, satn[8]);
+		atp_writeb_io(dev, c, 0x15, j);
+		atp_writeb_io(dev, c, 0x18, satn[8]);
 
-		while ((atp_readb_io(dev, 0, 0x1f) & 0x80) == 0x00)
+		while ((atp_readb_io(dev, c, 0x1f) & 0x80) == 0x00)
 			cpu_relax();
 
-		if (atp_readb_io(dev, 0, 0x17) != 0x11 && atp_readb_io(dev, 0, 0x17) != 0x8e)
+		if (atp_readb_io(dev, c, 0x17) != 0x11 && atp_readb_io(dev, c, 0x17) != 0x8e)
 			continue;
 
-		while (atp_readb_io(dev, 0, 0x17) != 0x8e)
+		while (atp_readb_io(dev, c, 0x17) != 0x8e)
 			cpu_relax();
 
-		dev->active_id[0] |= m;
+		dev->active_id[c] |= m;
 
-		atp_writeb_io(dev, 0, 0x10, 0x30);
-		atp_writeb_io(dev, 0, 0x04, 0x00);
+		atp_writeb_io(dev, c, 0x10, 0x30);
+		atp_writeb_io(dev, c, 0x04, 0x00);
 
 phase_cmd:
-		atp_writeb_io(dev, 0, 0x18, 0x08);
+		atp_writeb_io(dev, c, 0x18, 0x08);
 
-		while ((atp_readb_io(dev, 0, 0x1f) & 0x80) == 0x00)
+		while ((atp_readb_io(dev, c, 0x1f) & 0x80) == 0x00)
 			cpu_relax();
 
-		j = atp_readb_io(dev, 0, 0x17);
+		j = atp_readb_io(dev, c, 0x17);
 		if (j != 0x16) {
-			atp_writeb_io(dev, 0, 0x10, 0x41);
+			atp_writeb_io(dev, c, 0x10, 0x41);
 			goto phase_cmd;
 		}
 sel_ok:
-		atp_writeb_io(dev, 0, 3, inqd[0]);
-		atp_writeb_io(dev, 0, 4, inqd[1]);
-		atp_writeb_io(dev, 0, 5, inqd[2]);
-		atp_writeb_io(dev, 0, 6, inqd[3]);
-		atp_writeb_io(dev, 0, 7, inqd[4]);
-		atp_writeb_io(dev, 0, 8, inqd[5]);
-		atp_writeb_io(dev, 0, 0x0f, 0);
-		atp_writeb_io(dev, 0, 0x11, dev->id[0][i].devsp);
-		atp_writeb_io(dev, 0, 0x12, 0);
-		atp_writeb_io(dev, 0, 0x13, inqd[6]);
-		atp_writeb_io(dev, 0, 0x14, inqd[7]);
-		atp_writeb_io(dev, 0, 0x18, inqd[8]);
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
 
-		while ((atp_readb_io(dev, 0, 0x1f) & 0x80) == 0x00)
+		while ((atp_readb_io(dev, c, 0x1f) & 0x80) == 0x00)
 			cpu_relax();
 
-		if (atp_readb_io(dev, 0, 0x17) != 0x11 && atp_readb_io(dev, 0, 0x17) != 0x8e)
+		if (atp_readb_io(dev, c, 0x17) != 0x11 && atp_readb_io(dev, c, 0x17) != 0x8e)
 			continue;
 
-		while (atp_readb_io(dev, 0, 0x17) != 0x8e)
+		while (atp_readb_io(dev, c, 0x17) != 0x8e)
 			cpu_relax();
 
 		if (dev->chip_ver == 4)
-			atp_writeb_io(dev, 0, 0x1b, 0x00);
+			atp_writeb_io(dev, c, 0x1b, 0x00);
 
-		atp_writeb_io(dev, 0, 0x18, 0x08);
+		atp_writeb_io(dev, c, 0x18, 0x08);
 		j = 0;
 rd_inq_data:
-		k = atp_readb_io(dev, 0, 0x1f);
+		k = atp_readb_io(dev, c, 0x1f);
 		if ((k & 0x01) != 0) {
-			mbuf[j++] = atp_readb_io(dev, 0, 0x19);
+			mbuf[j++] = atp_readb_io(dev, c, 0x19);
 			goto rd_inq_data;
 		}
 		if ((k & 0x80) == 0) {
 			goto rd_inq_data;
 		}
-		j = atp_readb_io(dev, 0, 0x17);
+		j = atp_readb_io(dev, c, 0x17);
 		if (j == 0x16) {
 			goto inq_ok;
 		}
-		atp_writeb_io(dev, 0, 0x10, 0x46);
-		atp_writeb_io(dev, 0, 0x12, 0);
-		atp_writeb_io(dev, 0, 0x13, 0);
-		atp_writeb_io(dev, 0, 0x14, 0);
-		atp_writeb_io(dev, 0, 0x18, 0x08);
+		atp_writeb_io(dev, c, 0x10, 0x46);
+		atp_writeb_io(dev, c, 0x12, 0);
+		atp_writeb_io(dev, c, 0x13, 0);
+		atp_writeb_io(dev, c, 0x14, 0);
+		atp_writeb_io(dev, c, 0x18, 0x08);
 
-		while ((atp_readb_io(dev, 0, 0x1f) & 0x80) == 0x00)
+		while ((atp_readb_io(dev, c, 0x1f) & 0x80) == 0x00)
 			cpu_relax();
 
-		if (atp_readb_io(dev, 0, 0x17) != 0x16)
+		if (atp_readb_io(dev, c, 0x17) != 0x16)
 			goto sel_ok;
 
 inq_ok:
 		mbuf[36] = 0;
 		printk(KERN_INFO "         ID: %2d  %s\n", i, &mbuf[8]);
-		dev->id[0][i].devtype = mbuf[0];
+		dev->id[c][i].devtype = mbuf[0];
 		rmb = mbuf[1];
 		n = mbuf[7];
 		if (dev->chip_ver != 4) {
@@ -1304,46 +1304,46 @@ inq_ok:
 		if ((mbuf[7] & 0x60) == 0) {
 			goto not_wide;
 		}
-		if ((dev->global_map[0] & 0x20) == 0) {
+		if ((dev->global_map[c] & 0x20) == 0) {
 			goto not_wide;
 		}
-		atp_writeb_io(dev, 0, 0x1b, 0x01);
-		atp_writeb_io(dev, 0, 3, satn[0]);
-		atp_writeb_io(dev, 0, 4, satn[1]);
-		atp_writeb_io(dev, 0, 5, satn[2]);
-		atp_writeb_io(dev, 0, 6, satn[3]);
-		atp_writeb_io(dev, 0, 7, satn[4]);
-		atp_writeb_io(dev, 0, 8, satn[5]);
-		atp_writeb_io(dev, 0, 0x0f, 0);
-		atp_writeb_io(dev, 0, 0x11, dev->id[0][i].devsp);
-		atp_writeb_io(dev, 0, 0x12, 0);
-		atp_writeb_io(dev, 0, 0x13, satn[6]);
-		atp_writeb_io(dev, 0, 0x14, satn[7]);
-		atp_writeb_io(dev, 0, 0x18, satn[8]);
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
 
-		while ((atp_readb_io(dev, 0, 0x1f) & 0x80) == 0x00)
+		while ((atp_readb_io(dev, c, 0x1f) & 0x80) == 0x00)
 			cpu_relax();
 
-		if (atp_readb_io(dev, 0, 0x17) != 0x11 && atp_readb_io(dev, 0, 0x17) != 0x8e)
+		if (atp_readb_io(dev, c, 0x17) != 0x11 && atp_readb_io(dev, c, 0x17) != 0x8e)
 			continue;
 
-		while (atp_readb_io(dev, 0, 0x17) != 0x8e)
+		while (atp_readb_io(dev, c, 0x17) != 0x8e)
 			cpu_relax();
 
 try_wide:
 		j = 0;
-		atp_writeb_io(dev, 0, 0x14, 0x05);
-		atp_writeb_io(dev, 0, 0x18, 0x20);
+		atp_writeb_io(dev, c, 0x14, 0x05);
+		atp_writeb_io(dev, c, 0x18, 0x20);
 
-		while ((atp_readb_io(dev, 0, 0x1f) & 0x80) == 0) {
-			if ((atp_readb_io(dev, 0, 0x1f) & 0x01) != 0)
-				atp_writeb_io(dev, 0, 0x19, wide[j++]);
+		while ((atp_readb_io(dev, c, 0x1f) & 0x80) == 0) {
+			if ((atp_readb_io(dev, c, 0x1f) & 0x01) != 0)
+				atp_writeb_io(dev, c, 0x19, wide[j++]);
 		}
 
-		while ((atp_readb_io(dev, 0, 0x17) & 0x80) == 0x00)
+		while ((atp_readb_io(dev, c, 0x17) & 0x80) == 0x00)
 			cpu_relax();
 
-		j = atp_readb_io(dev, 0, 0x17) & 0x0f;
+		j = atp_readb_io(dev, c, 0x17) & 0x0f;
 		if (j == 0x0f) {
 			goto widep_in;
 		}
@@ -1355,12 +1355,12 @@ try_wide:
 		}
 		continue;
 widep_out:
-		atp_writeb_io(dev, 0, 0x18, 0x20);
-		while ((atp_readb_io(dev, 0, 0x1f) & 0x80) == 0) {
-			if ((atp_readb_io(dev, 0, 0x1f) & 0x01) != 0)
-				atp_writeb_io(dev, 0, 0x19, 0);
+		atp_writeb_io(dev, c, 0x18, 0x20);
+		while ((atp_readb_io(dev, c, 0x1f) & 0x80) == 0) {
+			if ((atp_readb_io(dev, c, 0x1f) & 0x01) != 0)
+				atp_writeb_io(dev, c, 0x19, 0);
 		}
-		j = atp_readb_io(dev, 0, 0x17) & 0x0f;
+		j = atp_readb_io(dev, c, 0x17) & 0x0f;
 		if (j == 0x0f) {
 			goto widep_in;
 		}
@@ -1372,19 +1372,19 @@ widep_out:
 		}
 		continue;
 widep_in:
-		atp_writeb_io(dev, 0, 0x14, 0xff);
-		atp_writeb_io(dev, 0, 0x18, 0x20);
+		atp_writeb_io(dev, c, 0x14, 0xff);
+		atp_writeb_io(dev, c, 0x18, 0x20);
 		k = 0;
 widep_in1:
-		j = atp_readb_io(dev, 0, 0x1f);
+		j = atp_readb_io(dev, c, 0x1f);
 		if ((j & 0x01) != 0) {
-			mbuf[k++] = atp_readb_io(dev, 0, 0x19);
+			mbuf[k++] = atp_readb_io(dev, c, 0x19);
 			goto widep_in1;
 		}
 		if ((j & 0x80) == 0x00) {
 			goto widep_in1;
 		}
-		j = atp_readb_io(dev, 0, 0x17) & 0x0f;
+		j = atp_readb_io(dev, c, 0x17) & 0x0f;
 		if (j == 0x0f) {
 			goto widep_in;
 		}
@@ -1396,14 +1396,14 @@ widep_in1:
 		}
 		continue;
 widep_cmd:
-		atp_writeb_io(dev, 0, 0x10, 0x30);
-		atp_writeb_io(dev, 0, 0x14, 0x00);
-		atp_writeb_io(dev, 0, 0x18, 0x08);
+		atp_writeb_io(dev, c, 0x10, 0x30);
+		atp_writeb_io(dev, c, 0x14, 0x00);
+		atp_writeb_io(dev, c, 0x18, 0x08);
 
-		while ((atp_readb_io(dev, 0, 0x1f) & 0x80) == 0x00)
+		while ((atp_readb_io(dev, c, 0x1f) & 0x80) == 0x00)
 			cpu_relax();
 
-		j = atp_readb_io(dev, 0, 0x17);
+		j = atp_readb_io(dev, c, 0x17);
 		if (j != 0x16) {
 			if (j == 0x4e) {
 				goto widep_out;
@@ -1424,63 +1424,63 @@ widep_cmd:
 		}
 		m = 1;
 		m = m << i;
-		dev->wide_id[0] |= m;
+		dev->wide_id[c] |= m;
 not_wide:
-		if ((dev->id[0][i].devtype == 0x00) || (dev->id[0][i].devtype == 0x07) || ((dev->id[0][i].devtype == 0x05) && ((n & 0x10) != 0))) {
+		if ((dev->id[c][i].devtype == 0x00) || (dev->id[c][i].devtype == 0x07) || ((dev->id[c][i].devtype == 0x05) && ((n & 0x10) != 0))) {
 			goto set_sync;
 		}
 		continue;
 set_sync:
 		j = 0;
-		if ((m & dev->wide_id[0]) != 0) {
+		if ((m & dev->wide_id[c]) != 0) {
 			j |= 0x01;
 		}
-		atp_writeb_io(dev, 0, 0x1b, j);
-		atp_writeb_io(dev, 0, 3, satn[0]);
-		atp_writeb_io(dev, 0, 4, satn[1]);
-		atp_writeb_io(dev, 0, 5, satn[2]);
-		atp_writeb_io(dev, 0, 6, satn[3]);
-		atp_writeb_io(dev, 0, 7, satn[4]);
-		atp_writeb_io(dev, 0, 8, satn[5]);
-		atp_writeb_io(dev, 0, 0x0f, 0);
-		atp_writeb_io(dev, 0, 0x11, dev->id[0][i].devsp);
-		atp_writeb_io(dev, 0, 0x12, 0);
-		atp_writeb_io(dev, 0, 0x13, satn[6]);
-		atp_writeb_io(dev, 0, 0x14, satn[7]);
-		atp_writeb_io(dev, 0, 0x18, satn[8]);
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
 
-		while ((atp_readb_io(dev, 0, 0x1f) & 0x80) == 0x00)
+		while ((atp_readb_io(dev, c, 0x1f) & 0x80) == 0x00)
 			cpu_relax();
 
-		if (atp_readb_io(dev, 0, 0x17) != 0x11 && atp_readb_io(dev, 0, 0x17) != 0x8e)
+		if (atp_readb_io(dev, c, 0x17) != 0x11 && atp_readb_io(dev, c, 0x17) != 0x8e)
 			continue;
 
-		while (atp_readb_io(dev, 0, 0x17) != 0x8e)
+		while (atp_readb_io(dev, c, 0x17) != 0x8e)
 			cpu_relax();
 
 try_sync:
 		j = 0;
-		atp_writeb_io(dev, 0, 0x14, 0x06);
-		atp_writeb_io(dev, 0, 0x18, 0x20);
+		atp_writeb_io(dev, c, 0x14, 0x06);
+		atp_writeb_io(dev, c, 0x18, 0x20);
 
-		while ((atp_readb_io(dev, 0, 0x1f) & 0x80) == 0) {
-			if ((atp_readb_io(dev, 0, 0x1f) & 0x01) != 0) {
-				if ((m & dev->wide_id[0]) != 0) {
-					atp_writeb_io(dev, 0, 0x19, synw[j++]);
+		while ((atp_readb_io(dev, c, 0x1f) & 0x80) == 0) {
+			if ((atp_readb_io(dev, c, 0x1f) & 0x01) != 0) {
+				if ((m & dev->wide_id[c]) != 0) {
+					atp_writeb_io(dev, c, 0x19, synw[j++]);
 				} else {
-					if ((m & dev->ultra_map[0]) != 0) {
-						atp_writeb_io(dev, 0, 0x19, synu[j++]);
+					if ((m & dev->ultra_map[c]) != 0) {
+						atp_writeb_io(dev, c, 0x19, synu[j++]);
 					} else {
-						atp_writeb_io(dev, 0, 0x19, synn[j++]);
+						atp_writeb_io(dev, c, 0x19, synn[j++]);
 					}
 				}
 			}
 		}
 
-		while ((atp_readb_io(dev, 0, 0x17) & 0x80) == 0x00)
+		while ((atp_readb_io(dev, c, 0x17) & 0x80) == 0x00)
 			cpu_relax();
 
-		j = atp_readb_io(dev, 0, 0x17) & 0x0f;
+		j = atp_readb_io(dev, c, 0x17) & 0x0f;
 		if (j == 0x0f) {
 			goto phase_ins;
 		}
@@ -1492,12 +1492,12 @@ try_sync:
 		}
 		continue;
 phase_outs:
-		atp_writeb_io(dev, 0, 0x18, 0x20);
-		while ((atp_readb_io(dev, 0, 0x1f) & 0x80) == 0x00) {
-			if ((atp_readb_io(dev, 0, 0x1f) & 0x01) != 0x00)
-				atp_writeb_io(dev, 0, 0x19, 0x00);
+		atp_writeb_io(dev, c, 0x18, 0x20);
+		while ((atp_readb_io(dev, c, 0x1f) & 0x80) == 0x00) {
+			if ((atp_readb_io(dev, c, 0x1f) & 0x01) != 0x00)
+				atp_writeb_io(dev, c, 0x19, 0x00);
 		}
-		j = atp_readb_io(dev, 0, 0x17);
+		j = atp_readb_io(dev, c, 0x17);
 		if (j == 0x85) {
 			goto tar_dcons;
 		}
@@ -1513,23 +1513,23 @@ phase_outs:
 		}
 		continue;
 phase_ins:
-		atp_writeb_io(dev, 0, 0x14, 0xff);
-		atp_writeb_io(dev, 0, 0x18, 0x20);
+		atp_writeb_io(dev, c, 0x14, 0xff);
+		atp_writeb_io(dev, c, 0x18, 0x20);
 		k = 0;
 phase_ins1:
-		j = atp_readb_io(dev, 0, 0x1f);
+		j = atp_readb_io(dev, c, 0x1f);
 		if ((j & 0x01) != 0x00) {
-			mbuf[k++] = atp_readb_io(dev, 0, 0x19);
+			mbuf[k++] = atp_readb_io(dev, c, 0x19);
 			goto phase_ins1;
 		}
 		if ((j & 0x80) == 0x00) {
 			goto phase_ins1;
 		}
 
-		while ((atp_readb_io(dev, 0, 0x17) & 0x80) == 0x00)
+		while ((atp_readb_io(dev, c, 0x17) & 0x80) == 0x00)
 			cpu_relax();
 
-		j = atp_readb_io(dev, 0, 0x17);
+		j = atp_readb_io(dev, c, 0x17);
 		if (j == 0x85) {
 			goto tar_dcons;
 		}
@@ -1545,15 +1545,15 @@ phase_ins1:
 		}
 		continue;
 phase_cmds:
-		atp_writeb_io(dev, 0, 0x10, 0x30);
+		atp_writeb_io(dev, c, 0x10, 0x30);
 tar_dcons:
-		atp_writeb_io(dev, 0, 0x14, 0x00);
-		atp_writeb_io(dev, 0, 0x18, 0x08);
+		atp_writeb_io(dev, c, 0x14, 0x00);
+		atp_writeb_io(dev, c, 0x18, 0x08);
 
-		while ((atp_readb_io(dev, 0, 0x1f) & 0x80) == 0x00)
+		while ((atp_readb_io(dev, c, 0x1f) & 0x80) == 0x00)
 			cpu_relax();
 
-		j = atp_readb_io(dev, 0, 0x17);
+		j = atp_readb_io(dev, c, 0x17);
 		if (j != 0x16) {
 			continue;
 		}
@@ -1572,7 +1572,7 @@ tar_dcons:
 		if (mbuf[4] > 0x0c) {
 			mbuf[4] = 0x0c;
 		}
-		dev->id[0][i].devsp = mbuf[4];
+		dev->id[c][i].devsp = mbuf[4];
 		if ((mbuf[3] < 0x0d) && (rmb == 0)) {
 			j = 0xa0;
 			goto set_syn_ok;
@@ -1591,12 +1591,12 @@ tar_dcons:
 		}
 		j = 0x60;
 set_syn_ok:
-		dev->id[0][i].devsp = (dev->id[0][i].devsp & 0x0f) | j;
+		dev->id[c][i].devsp = (dev->id[c][i].devsp & 0x0f) | j;
 	}
-	atp_writeb_io(dev, 0, 0x3a, atp_readb_io(dev, 0, 0x3a) & 0xef);
+	atp_writeb_io(dev, c, 0x3a, atp_readb_io(dev, c, 0x3a) & 0xef);
 }
 
-static void is880(struct atp_unit *dev)
+static void is880(struct atp_unit *dev, unsigned char c)
 {
 	unsigned char i, j, k, rmb, n, lvdmode;
 	unsigned short int m;
@@ -1615,167 +1615,167 @@ static void is880(struct atp_unit *dev)
 	for (i = 0; i < 16; i++) {
 		m = 1;
 		m = m << i;
-		if ((m & dev->active_id[0]) != 0) {
+		if ((m & dev->active_id[c]) != 0) {
 			continue;
 		}
-		if (i == dev->host_id[0]) {
-			printk(KERN_INFO "         ID: %2d  Host Adapter\n", dev->host_id[0]);
+		if (i == dev->host_id[c]) {
+			printk(KERN_INFO "         ID: %2d  Host Adapter\n", dev->host_id[c]);
 			continue;
 		}
-		atp_writeb_io(dev, 0, 0x1b, 0x01);
-		atp_writeb_io(dev, 0, 1, 0x08);
-		atp_writeb_io(dev, 0, 2, 0x7f);
-		atp_writeb_io(dev, 0, 3, satn[0]);
-		atp_writeb_io(dev, 0, 4, satn[1]);
-		atp_writeb_io(dev, 0, 5, satn[2]);
-		atp_writeb_io(dev, 0, 6, satn[3]);
-		atp_writeb_io(dev, 0, 7, satn[4]);
-		atp_writeb_io(dev, 0, 8, satn[5]);
-		atp_writeb_io(dev, 0, 0x0f, 0);
-		atp_writeb_io(dev, 0, 0x11, dev->id[0][i].devsp);
-		atp_writeb_io(dev, 0, 0x12, 0);
-		atp_writeb_io(dev, 0, 0x13, satn[6]);
-		atp_writeb_io(dev, 0, 0x14, satn[7]);
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
+		atp_writeb_io(dev, c, 0x12, 0);
+		atp_writeb_io(dev, c, 0x13, satn[6]);
+		atp_writeb_io(dev, c, 0x14, satn[7]);
 		j = i;
 		if ((j & 0x08) != 0) {
 			j = (j & 0x07) | 0x40;
 		}
-		atp_writeb_io(dev, 0, 0x15, j);
-		atp_writeb_io(dev, 0, 0x18, satn[8]);
+		atp_writeb_io(dev, c, 0x15, j);
+		atp_writeb_io(dev, c, 0x18, satn[8]);
 
-		while ((atp_readb_io(dev, 0, 0x1f) & 0x80) == 0x00)
+		while ((atp_readb_io(dev, c, 0x1f) & 0x80) == 0x00)
 			cpu_relax();
 
-		if (atp_readb_io(dev, 0, 0x17) != 0x11 && atp_readb_io(dev, 0, 0x17) != 0x8e)
+		if (atp_readb_io(dev, c, 0x17) != 0x11 && atp_readb_io(dev, c, 0x17) != 0x8e)
 			continue;
 
-		while (atp_readb_io(dev, 0, 0x17) != 0x8e)
+		while (atp_readb_io(dev, c, 0x17) != 0x8e)
 			cpu_relax();
 
-		dev->active_id[0] |= m;
+		dev->active_id[c] |= m;
 
-		atp_writeb_io(dev, 0, 0x10, 0x30);
-		atp_writeb_io(dev, 0, 0x14, 0x00);
+		atp_writeb_io(dev, c, 0x10, 0x30);
+		atp_writeb_io(dev, c, 0x14, 0x00);
 
 phase_cmd:
-		atp_writeb_io(dev, 0, 0x18, 0x08);
+		atp_writeb_io(dev, c, 0x18, 0x08);
 
-		while ((atp_readb_io(dev, 0, 0x1f) & 0x80) == 0x00)
+		while ((atp_readb_io(dev, c, 0x1f) & 0x80) == 0x00)
 			cpu_relax();
 
-		j = atp_readb_io(dev, 0, 0x17);
+		j = atp_readb_io(dev, c, 0x17);
 		if (j != 0x16) {
-			atp_writeb_io(dev, 0, 0x10, 0x41);
+			atp_writeb_io(dev, c, 0x10, 0x41);
 			goto phase_cmd;
 		}
 sel_ok:
-		atp_writeb_io(dev, 0, 3, inqd[0]);
-		atp_writeb_io(dev, 0, 4, inqd[1]);
-		atp_writeb_io(dev, 0, 5, inqd[2]);
-		atp_writeb_io(dev, 0, 6, inqd[3]);
-		atp_writeb_io(dev, 0, 7, inqd[4]);
-		atp_writeb_io(dev, 0, 8, inqd[5]);
-		atp_writeb_io(dev, 0, 0x0f, 0);
-		atp_writeb_io(dev, 0, 0x11, dev->id[0][i].devsp);
-		atp_writeb_io(dev, 0, 0x12, 0);
-		atp_writeb_io(dev, 0, 0x13, inqd[6]);
-		atp_writeb_io(dev, 0, 0x14, inqd[7]);
-		atp_writeb_io(dev, 0, 0x18, inqd[8]);
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
 
-		while ((atp_readb_io(dev, 0, 0x1f) & 0x80) == 0x00)
+		while ((atp_readb_io(dev, c, 0x1f) & 0x80) == 0x00)
 			cpu_relax();
 
-		if (atp_readb_io(dev, 0, 0x17) != 0x11 && atp_readb_io(dev, 0, 0x17) != 0x8e)
+		if (atp_readb_io(dev, c, 0x17) != 0x11 && atp_readb_io(dev, c, 0x17) != 0x8e)
 			continue;
 
-		while (atp_readb_io(dev, 0, 0x17) != 0x8e)
+		while (atp_readb_io(dev, c, 0x17) != 0x8e)
 			cpu_relax();
 
-		atp_writeb_io(dev, 0, 0x1b, 0x00);
-		atp_writeb_io(dev, 0, 0x18, 0x08);
+		atp_writeb_io(dev, c, 0x1b, 0x00);
+		atp_writeb_io(dev, c, 0x18, 0x08);
 		j = 0;
 rd_inq_data:
-		k = atp_readb_io(dev, 0, 0x1f);
+		k = atp_readb_io(dev, c, 0x1f);
 		if ((k & 0x01) != 0) {
-			mbuf[j++] = atp_readb_io(dev, 0, 0x19);
+			mbuf[j++] = atp_readb_io(dev, c, 0x19);
 			goto rd_inq_data;
 		}
 		if ((k & 0x80) == 0) {
 			goto rd_inq_data;
 		}
-		j = atp_readb_io(dev, 0, 0x17);
+		j = atp_readb_io(dev, c, 0x17);
 		if (j == 0x16) {
 			goto inq_ok;
 		}
-		atp_writeb_io(dev, 0, 0x10, 0x46);
-		atp_writeb_io(dev, 0, 0x12, 0);
-		atp_writeb_io(dev, 0, 0x13, 0);
-		atp_writeb_io(dev, 0, 0x14, 0);
-		atp_writeb_io(dev, 0, 0x18, 0x08);
+		atp_writeb_io(dev, c, 0x10, 0x46);
+		atp_writeb_io(dev, c, 0x12, 0);
+		atp_writeb_io(dev, c, 0x13, 0);
+		atp_writeb_io(dev, c, 0x14, 0);
+		atp_writeb_io(dev, c, 0x18, 0x08);
 
-		while ((atp_readb_io(dev, 0, 0x1f) & 0x80) == 0x00)
+		while ((atp_readb_io(dev, c, 0x1f) & 0x80) == 0x00)
 			cpu_relax();
 
-		if (atp_readb_io(dev, 0, 0x17) != 0x16)
+		if (atp_readb_io(dev, c, 0x17) != 0x16)
 			goto sel_ok;
 
 inq_ok:
 		mbuf[36] = 0;
 		printk(KERN_INFO "         ID: %2d  %s\n", i, &mbuf[8]);
-		dev->id[0][i].devtype = mbuf[0];
+		dev->id[c][i].devtype = mbuf[0];
 		rmb = mbuf[1];
 		n = mbuf[7];
 		if ((mbuf[7] & 0x60) == 0) {
 			goto not_wide;
 		}
-		if ((i < 8) && ((dev->global_map[0] & 0x20) == 0)) {
+		if ((i < 8) && ((dev->global_map[c] & 0x20) == 0)) {
 			goto not_wide;
 		}
 		if (lvdmode == 0) {
 			goto chg_wide;
 		}
-		if (dev->sp[0][i] != 0x04)	// force u2
+		if (dev->sp[c][i] != 0x04)	// force u2
 		{
 			goto chg_wide;
 		}
 
-		atp_writeb_io(dev, 0, 0x1b, 0x01);
-		atp_writeb_io(dev, 0, 3, satn[0]);
-		atp_writeb_io(dev, 0, 4, satn[1]);
-		atp_writeb_io(dev, 0, 5, satn[2]);
-		atp_writeb_io(dev, 0, 6, satn[3]);
-		atp_writeb_io(dev, 0, 7, satn[4]);
-		atp_writeb_io(dev, 0, 8, satn[5]);
-		atp_writeb_io(dev, 0, 0x0f, 0);
-		atp_writeb_io(dev, 0, 0x11, dev->id[0][i].devsp);
-		atp_writeb_io(dev, 0, 0x12, 0);
-		atp_writeb_io(dev, 0, 0x13, satn[6]);
-		atp_writeb_io(dev, 0, 0x14, satn[7]);
-		atp_writeb_io(dev, 0, 0x18, satn[8]);
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
 
-		while ((atp_readb_io(dev, 0, 0x1f) & 0x80) == 0x00)
+		while ((atp_readb_io(dev, c, 0x1f) & 0x80) == 0x00)
 			cpu_relax();
 
-		if (atp_readb_io(dev, 0, 0x17) != 0x11 && atp_readb_io(dev, 0, 0x17) != 0x8e)
+		if (atp_readb_io(dev, c, 0x17) != 0x11 && atp_readb_io(dev, c, 0x17) != 0x8e)
 			continue;
 
-		while (atp_readb_io(dev, 0, 0x17) != 0x8e)
+		while (atp_readb_io(dev, c, 0x17) != 0x8e)
 			cpu_relax();
 
 try_u3:
 		j = 0;
-		atp_writeb_io(dev, 0, 0x14, 0x09);
-		atp_writeb_io(dev, 0, 0x18, 0x20);
+		atp_writeb_io(dev, c, 0x14, 0x09);
+		atp_writeb_io(dev, c, 0x18, 0x20);
 
-		while ((atp_readb_io(dev, 0, 0x1f) & 0x80) == 0) {
-			if ((atp_readb_io(dev, 0, 0x1f) & 0x01) != 0)
-				atp_writeb_io(dev, 0, 0x19, u3[j++]);
+		while ((atp_readb_io(dev, c, 0x1f) & 0x80) == 0) {
+			if ((atp_readb_io(dev, c, 0x1f) & 0x01) != 0)
+				atp_writeb_io(dev, c, 0x19, u3[j++]);
 		}
 
-		while ((atp_readb_io(dev, 0, 0x17) & 0x80) == 0x00)
+		while ((atp_readb_io(dev, c, 0x17) & 0x80) == 0x00)
 			cpu_relax();
 
-		j = atp_readb_io(dev, 0, 0x17) & 0x0f;
+		j = atp_readb_io(dev, c, 0x17) & 0x0f;
 		if (j == 0x0f) {
 			goto u3p_in;
 		}
@@ -1787,12 +1787,12 @@ try_u3:
 		}
 		continue;
 u3p_out:
-		atp_writeb_io(dev, 0, 0x18, 0x20);
-		while ((atp_readb_io(dev, 0, 0x1f) & 0x80) == 0) {
-			if ((atp_readb_io(dev, 0, 0x1f) & 0x01) != 0)
-				atp_writeb_io(dev, 0, 0x19, 0);
+		atp_writeb_io(dev, c, 0x18, 0x20);
+		while ((atp_readb_io(dev, c, 0x1f) & 0x80) == 0) {
+			if ((atp_readb_io(dev, c, 0x1f) & 0x01) != 0)
+				atp_writeb_io(dev, c, 0x19, 0);
 		}
-		j = atp_readb_io(dev, 0, 0x17) & 0x0f;
+		j = atp_readb_io(dev, c, 0x17) & 0x0f;
 		if (j == 0x0f) {
 			goto u3p_in;
 		}
@@ -1804,19 +1804,19 @@ u3p_out:
 		}
 		continue;
 u3p_in:
-		atp_writeb_io(dev, 0, 0x14, 0x09);
-		atp_writeb_io(dev, 0, 0x18, 0x20);
+		atp_writeb_io(dev, c, 0x14, 0x09);
+		atp_writeb_io(dev, c, 0x18, 0x20);
 		k = 0;
 u3p_in1:
-		j = atp_readb_io(dev, 0, 0x1f);
+		j = atp_readb_io(dev, c, 0x1f);
 		if ((j & 0x01) != 0) {
-			mbuf[k++] = atp_readb_io(dev, 0, 0x19);
+			mbuf[k++] = atp_readb_io(dev, c, 0x19);
 			goto u3p_in1;
 		}
 		if ((j & 0x80) == 0x00) {
 			goto u3p_in1;
 		}
-		j = atp_readb_io(dev, 0, 0x17) & 0x0f;
+		j = atp_readb_io(dev, c, 0x17) & 0x0f;
 		if (j == 0x0f) {
 			goto u3p_in;
 		}
@@ -1828,14 +1828,14 @@ u3p_in1:
 		}
 		continue;
 u3p_cmd:
-		atp_writeb_io(dev, 0, 0x10, 0x30);
-		atp_writeb_io(dev, 0, 0x14, 0x00);
-		atp_writeb_io(dev, 0, 0x18, 0x08);
+		atp_writeb_io(dev, c, 0x10, 0x30);
+		atp_writeb_io(dev, c, 0x14, 0x00);
+		atp_writeb_io(dev, c, 0x18, 0x08);
 
-		while ((atp_readb_io(dev, 0, 0x1f) & 0x80) == 0x00)
+		while ((atp_readb_io(dev, c, 0x1f) & 0x80) == 0x00)
 			cpu_relax();
 
-		j = atp_readb_io(dev, 0, 0x17);
+		j = atp_readb_io(dev, c, 0x17);
 		if (j != 0x16) {
 			if (j == 0x4e) {
 				goto u3p_out;
@@ -1854,48 +1854,48 @@ u3p_cmd:
 		if (mbuf[3] == 0x09) {
 			m = 1;
 			m = m << i;
-			dev->wide_id[0] |= m;
-			dev->id[0][i].devsp = 0xce;
+			dev->wide_id[c] |= m;
+			dev->id[c][i].devsp = 0xce;
 			continue;
 		}
 chg_wide:
-		atp_writeb_io(dev, 0, 0x1b, 0x01);
-		atp_writeb_io(dev, 0, 3, satn[0]);
-		atp_writeb_io(dev, 0, 4, satn[1]);
-		atp_writeb_io(dev, 0, 5, satn[2]);
-		atp_writeb_io(dev, 0, 6, satn[3]);
-		atp_writeb_io(dev, 0, 7, satn[4]);
-		atp_writeb_io(dev, 0, 8, satn[5]);
-		atp_writeb_io(dev, 0, 0x0f, 0);
-		atp_writeb_io(dev, 0, 0x11, dev->id[0][i].devsp);
-		atp_writeb_io(dev, 0, 0x12, 0);
-		atp_writeb_io(dev, 0, 0x13, satn[6]);
-		atp_writeb_io(dev, 0, 0x14, satn[7]);
-		atp_writeb_io(dev, 0, 0x18, satn[8]);
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
 
-		while ((atp_readb_io(dev, 0, 0x1f) & 0x80) == 0x00)
+		while ((atp_readb_io(dev, c, 0x1f) & 0x80) == 0x00)
 			cpu_relax();
 
-		if (atp_readb_io(dev, 0, 0x17) != 0x11 && atp_readb_io(dev, 0, 0x17) != 0x8e)
+		if (atp_readb_io(dev, c, 0x17) != 0x11 && atp_readb_io(dev, c, 0x17) != 0x8e)
 			continue;
 
-		while (atp_readb_io(dev, 0, 0x17) != 0x8e)
+		while (atp_readb_io(dev, c, 0x17) != 0x8e)
 			cpu_relax();
 
 try_wide:
 		j = 0;
-		atp_writeb_io(dev, 0, 0x14, 0x05);
-		atp_writeb_io(dev, 0, 0x18, 0x20);
+		atp_writeb_io(dev, c, 0x14, 0x05);
+		atp_writeb_io(dev, c, 0x18, 0x20);
 
-		while ((atp_readb_io(dev, 0, 0x1f) & 0x80) == 0) {
-			if ((atp_readb_io(dev, 0, 0x1f) & 0x01) != 0)
-				atp_writeb_io(dev, 0, 0x19, wide[j++]);
+		while ((atp_readb_io(dev, c, 0x1f) & 0x80) == 0) {
+			if ((atp_readb_io(dev, c, 0x1f) & 0x01) != 0)
+				atp_writeb_io(dev, c, 0x19, wide[j++]);
 		}
 
-		while ((atp_readb_io(dev, 0, 0x17) & 0x80) == 0x00)
+		while ((atp_readb_io(dev, c, 0x17) & 0x80) == 0x00)
 			cpu_relax();
 
-		j = atp_readb_io(dev, 0, 0x17) & 0x0f;
+		j = atp_readb_io(dev, c, 0x17) & 0x0f;
 		if (j == 0x0f) {
 			goto widep_in;
 		}
@@ -1907,12 +1907,12 @@ try_wide:
 		}
 		continue;
 widep_out:
-		atp_writeb_io(dev, 0, 0x18, 0x20);
-		while ((atp_readb_io(dev, 0, 0x1f) & 0x80) == 0) {
-			if ((atp_readb_io(dev, 0, 0x1f) & 0x01) != 0)
-				atp_writeb_io(dev, 0, 0x19, 0);
+		atp_writeb_io(dev, c, 0x18, 0x20);
+		while ((atp_readb_io(dev, c, 0x1f) & 0x80) == 0) {
+			if ((atp_readb_io(dev, c, 0x1f) & 0x01) != 0)
+				atp_writeb_io(dev, c, 0x19, 0);
 		}
-		j = atp_readb_io(dev, 0, 0x17) & 0x0f;
+		j = atp_readb_io(dev, c, 0x17) & 0x0f;
 		if (j == 0x0f) {
 			goto widep_in;
 		}
@@ -1924,19 +1924,19 @@ widep_out:
 		}
 		continue;
 widep_in:
-		atp_writeb_io(dev, 0, 0x14, 0xff);
-		atp_writeb_io(dev, 0, 0x18, 0x20);
+		atp_writeb_io(dev, c, 0x14, 0xff);
+		atp_writeb_io(dev, c, 0x18, 0x20);
 		k = 0;
 widep_in1:
-		j = atp_readb_io(dev, 0, 0x1f);
+		j = atp_readb_io(dev, c, 0x1f);
 		if ((j & 0x01) != 0) {
-			mbuf[k++] = atp_readb_io(dev, 0, 0x19);
+			mbuf[k++] = atp_readb_io(dev, c, 0x19);
 			goto widep_in1;
 		}
 		if ((j & 0x80) == 0x00) {
 			goto widep_in1;
 		}
-		j = atp_readb_io(dev, 0, 0x17) & 0x0f;
+		j = atp_readb_io(dev, c, 0x17) & 0x0f;
 		if (j == 0x0f) {
 			goto widep_in;
 		}
@@ -1948,14 +1948,14 @@ widep_in1:
 		}
 		continue;
 widep_cmd:
-		atp_writeb_io(dev, 0, 0x10, 0x30);
-		atp_writeb_io(dev, 0, 0x14, 0x00);
-		atp_writeb_io(dev, 0, 0x18, 0x08);
+		atp_writeb_io(dev, c, 0x10, 0x30);
+		atp_writeb_io(dev, c, 0x14, 0x00);
+		atp_writeb_io(dev, c, 0x18, 0x08);
 
-		while ((atp_readb_io(dev, 0, 0x1f) & 0x80) == 0x00)
+		while ((atp_readb_io(dev, c, 0x1f) & 0x80) == 0x00)
 			cpu_relax();
 
-		j = atp_readb_io(dev, 0, 0x17);
+		j = atp_readb_io(dev, c, 0x17);
 		if (j != 0x16) {
 			if (j == 0x4e) {
 				goto widep_out;
@@ -1976,80 +1976,80 @@ widep_cmd:
 		}
 		m = 1;
 		m = m << i;
-		dev->wide_id[0] |= m;
+		dev->wide_id[c] |= m;
 not_wide:
-		if ((dev->id[0][i].devtype == 0x00) || (dev->id[0][i].devtype == 0x07) || ((dev->id[0][i].devtype == 0x05) && ((n & 0x10) != 0))) {
+		if ((dev->id[c][i].devtype == 0x00) || (dev->id[c][i].devtype == 0x07) || ((dev->id[c][i].devtype == 0x05) && ((n & 0x10) != 0))) {
 			m = 1;
 			m = m << i;
-			if ((dev->async[0] & m) != 0) {
+			if ((dev->async[c] & m) != 0) {
 				goto set_sync;
 			}
 		}
 		continue;
 set_sync:
-		if (dev->sp[0][i] == 0x02) {
+		if (dev->sp[c][i] == 0x02) {
 			synu[4] = 0x0c;
 			synuw[4] = 0x0c;
 		} else {
-			if (dev->sp[0][i] >= 0x03) {
+			if (dev->sp[c][i] >= 0x03) {
 				synu[4] = 0x0a;
 				synuw[4] = 0x0a;
 			}
 		}
 		j = 0;
-		if ((m & dev->wide_id[0]) != 0) {
+		if ((m & dev->wide_id[c]) != 0) {
 			j |= 0x01;
 		}
-		atp_writeb_io(dev, 0, 0x1b, j);
-		atp_writeb_io(dev, 0, 3, satn[0]);
-		atp_writeb_io(dev, 0, 4, satn[1]);
-		atp_writeb_io(dev, 0, 5, satn[2]);
-		atp_writeb_io(dev, 0, 6, satn[3]);
-		atp_writeb_io(dev, 0, 7, satn[4]);
-		atp_writeb_io(dev, 0, 8, satn[5]);
-		atp_writeb_io(dev, 0, 0x0f, 0);
-		atp_writeb_io(dev, 0, 0x11, dev->id[0][i].devsp);
-		atp_writeb_io(dev, 0, 0x12, 0);
-		atp_writeb_io(dev, 0, 0x13, satn[6]);
-		atp_writeb_io(dev, 0, 0x14, satn[7]);
-		atp_writeb_io(dev, 0, 0x18, satn[8]);
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
 
-		while ((atp_readb_io(dev, 0, 0x1f) & 0x80) == 0x00)
+		while ((atp_readb_io(dev, c, 0x1f) & 0x80) == 0x00)
 			cpu_relax();
 
-		if (atp_readb_io(dev, 0, 0x17) != 0x11 && atp_readb_io(dev, 0, 0x17) != 0x8e)
+		if (atp_readb_io(dev, c, 0x17) != 0x11 && atp_readb_io(dev, c, 0x17) != 0x8e)
 			continue;
 
-		while (atp_readb_io(dev, 0, 0x17) != 0x8e)
+		while (atp_readb_io(dev, c, 0x17) != 0x8e)
 			cpu_relax();
 
 try_sync:
 		j = 0;
-		atp_writeb_io(dev, 0, 0x14, 0x06);
-		atp_writeb_io(dev, 0, 0x18, 0x20);
-
-		while ((atp_readb_io(dev, 0, 0x1f) & 0x80) == 0) {
-			if ((atp_readb_io(dev, 0, 0x1f) & 0x01) != 0) {
-				if ((m & dev->wide_id[0]) != 0) {
-					if ((m & dev->ultra_map[0]) != 0) {
-						atp_writeb_io(dev, 0, 0x19, synuw[j++]);
+		atp_writeb_io(dev, c, 0x14, 0x06);
+		atp_writeb_io(dev, c, 0x18, 0x20);
+
+		while ((atp_readb_io(dev, c, 0x1f) & 0x80) == 0) {
+			if ((atp_readb_io(dev, c, 0x1f) & 0x01) != 0) {
+				if ((m & dev->wide_id[c]) != 0) {
+					if ((m & dev->ultra_map[c]) != 0) {
+						atp_writeb_io(dev, c, 0x19, synuw[j++]);
 					} else {
-						atp_writeb_io(dev, 0, 0x19, synw[j++]);
+						atp_writeb_io(dev, c, 0x19, synw[j++]);
 					}
 				} else {
-					if ((m & dev->ultra_map[0]) != 0) {
-						atp_writeb_io(dev, 0, 0x19, synu[j++]);
+					if ((m & dev->ultra_map[c]) != 0) {
+						atp_writeb_io(dev, c, 0x19, synu[j++]);
 					} else {
-						atp_writeb_io(dev, 0, 0x19, synn[j++]);
+						atp_writeb_io(dev, c, 0x19, synn[j++]);
 					}
 				}
 			}
 		}
 
-		while ((atp_readb_io(dev, 0, 0x17) & 0x80) == 0x00)
+		while ((atp_readb_io(dev, c, 0x17) & 0x80) == 0x00)
 			cpu_relax();
 
-		j = atp_readb_io(dev, 0, 0x17) & 0x0f;
+		j = atp_readb_io(dev, c, 0x17) & 0x0f;
 		if (j == 0x0f) {
 			goto phase_ins;
 		}
@@ -2061,12 +2061,12 @@ try_sync:
 		}
 		continue;
 phase_outs:
-		atp_writeb_io(dev, 0, 0x18, 0x20);
-		while ((atp_readb_io(dev, 0, 0x1f) & 0x80) == 0x00) {
-			if ((atp_readb_io(dev, 0, 0x1f) & 0x01) != 0x00)
-				atp_writeb_io(dev, 0, 0x19, 0x00);
+		atp_writeb_io(dev, c, 0x18, 0x20);
+		while ((atp_readb_io(dev, c, 0x1f) & 0x80) == 0x00) {
+			if ((atp_readb_io(dev, c, 0x1f) & 0x01) != 0x00)
+				atp_writeb_io(dev, c, 0x19, 0x00);
 		}
-		j = atp_readb_io(dev, 0, 0x17);
+		j = atp_readb_io(dev, c, 0x17);
 		if (j == 0x85) {
 			goto tar_dcons;
 		}
@@ -2082,23 +2082,23 @@ phase_outs:
 		}
 		continue;
 phase_ins:
-		atp_writeb_io(dev, 0, 0x14, 0x06);
-		atp_writeb_io(dev, 0, 0x18, 0x20);
+		atp_writeb_io(dev, c, 0x14, 0x06);
+		atp_writeb_io(dev, c, 0x18, 0x20);
 		k = 0;
 phase_ins1:
-		j = atp_readb_io(dev, 0, 0x1f);
+		j = atp_readb_io(dev, c, 0x1f);
 		if ((j & 0x01) != 0x00) {
-			mbuf[k++] = atp_readb_io(dev, 0, 0x19);
+			mbuf[k++] = atp_readb_io(dev, c, 0x19);
 			goto phase_ins1;
 		}
 		if ((j & 0x80) == 0x00) {
 			goto phase_ins1;
 		}
 
-		while ((atp_readb_io(dev, 0, 0x17) & 0x80) == 0x00)
+		while ((atp_readb_io(dev, c, 0x17) & 0x80) == 0x00)
 			cpu_relax();
 
-		j = atp_readb_io(dev, 0, 0x17);
+		j = atp_readb_io(dev, c, 0x17);
 		if (j == 0x85) {
 			goto tar_dcons;
 		}
@@ -2114,15 +2114,15 @@ phase_ins1:
 		}
 		continue;
 phase_cmds:
-		atp_writeb_io(dev, 0, 0x10, 0x30);
+		atp_writeb_io(dev, c, 0x10, 0x30);
 tar_dcons:
-		atp_writeb_io(dev, 0, 0x14, 0x00);
-		atp_writeb_io(dev, 0, 0x18, 0x08);
+		atp_writeb_io(dev, c, 0x14, 0x00);
+		atp_writeb_io(dev, c, 0x18, 0x08);
 
-		while ((atp_readb_io(dev, 0, 0x1f) & 0x80) == 0x00)
+		while ((atp_readb_io(dev, c, 0x1f) & 0x80) == 0x00)
 			cpu_relax();
 
-		j = atp_readb_io(dev, 0, 0x17);
+		j = atp_readb_io(dev, c, 0x17);
 		if (j != 0x16) {
 			continue;
 		}
@@ -2141,7 +2141,7 @@ tar_dcons:
 		if (mbuf[4] > 0x0e) {
 			mbuf[4] = 0x0e;
 		}
-		dev->id[0][i].devsp = mbuf[4];
+		dev->id[c][i].devsp = mbuf[4];
 		if (mbuf[3] < 0x0c) {
 			j = 0xb0;
 			goto set_syn_ok;
@@ -2164,7 +2164,7 @@ tar_dcons:
 		}
 		j = 0x60;
 set_syn_ok:
-		dev->id[0][i].devsp = (dev->id[0][i].devsp & 0x0f) | j;
+		dev->id[c][i].devsp = (dev->id[c][i].devsp & 0x0f) | j;
 	}
 }
 
@@ -2379,7 +2379,7 @@ flash_ok_880:
 		outb(0x20, base_io + 0x51);
 
 		tscam(shpnt);
-		is880(p);
+		is880(p, 0);
 		outb(0xb0, base_io + 0x38);
 		shpnt->max_id = 16;
 		shpnt->this_id = host_id;
@@ -2609,7 +2609,7 @@ flash_ok_885:
 		outb(0x20, base_io + 0x11);
 
 		tscam(shpnt);
-		is870(p);
+		is870(p, 0);
 		outb((inb(base_io + 0x3a) & 0xef), base_io + 0x3a);
 		outb((inb(base_io + 0x3b) | 0x20), base_io + 0x3b);
 		if (atpdev->chip_ver == 4)
-- 
Ondrej Zary


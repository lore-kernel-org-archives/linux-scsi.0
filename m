From: Ondrej Zary <linux@rainbow-software.org>
Subject: [PATCH 22/34] atp870u: Unify code format in is870(), is880() and is885()
Date: Sun,  3 May 2015 19:31:38 +0200
Message-ID: <1430674310-11576-23-git-send-email-linux@rainbow-software.org>
References: <1430674310-11576-1-git-send-email-linux@rainbow-software.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.gsystem.sk ([62.176.172.50]:36064 "EHLO gsystem.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751360AbbECRwO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 3 May 2015 13:52:14 -0400
Received: from stip-static-68.213-81-217.telecom.sk ([213.81.217.68] helo=gsql.ggedos.sk)
	by gsystem.sk with esmtpsa (TLS1.1:DHE_RSA_AES_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <linux@rainbow-software.org>)
	id 1YoxkN-0000Ql-DL
	for linux-scsi@vger.kernel.org; Sun, 03 May 2015 19:32:07 +0200
In-Reply-To: <1430674310-11576-1-git-send-email-linux@rainbow-software.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Unify code formatting in is870(), is880() and is885() functions to simplify
comparing them.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/scsi/atp870u.c |  170 ++++++++++++++++++++++++++++--------------------
 1 file changed, 101 insertions(+), 69 deletions(-)

diff --git a/drivers/scsi/atp870u.c b/drivers/scsi/atp870u.c
index 28023ae..595862b 100644
--- a/drivers/scsi/atp870u.c
+++ b/drivers/scsi/atp870u.c
@@ -1173,7 +1173,7 @@ static void is870(struct atp_unit *dev)
 	static unsigned char synu[6] = { 0x80, 1, 3, 1, 0x0c, 0x0e };
 	static unsigned char synw[6] = { 0x80, 1, 3, 1, 0x0c, 0x07 };
 	static unsigned char wide[6] = { 0x80, 1, 2, 3, 1, 0 };
-	
+
 	atp_writeb_io(dev, 0, 0x3a, atp_readb_io(dev, 0, 0x3a) | 0x10);
 
 	for (i = 0; i < 16; i++) {
@@ -1230,8 +1230,10 @@ static void is870(struct atp_unit *dev)
 
 phase_cmd:
 		atp_writeb_io(dev, 0, 0x18, 0x08);
+
 		while ((atp_readb_io(dev, 0, 0x1f) & 0x80) == 0x00)
 			cpu_relax();
+
 		j = atp_readb_io(dev, 0, 0x17);
 		if (j != 0x16) {
 			atp_writeb_io(dev, 0, 0x10, 0x41);
@@ -1253,13 +1255,13 @@ sel_ok:
 
 		while ((atp_readb_io(dev, 0, 0x1f) & 0x80) == 0x00)
 			cpu_relax();
-			
+
 		if (atp_readb_io(dev, 0, 0x17) != 0x11 && atp_readb_io(dev, 0, 0x17) != 0x8e)
 			continue;
 
 		while (atp_readb_io(dev, 0, 0x17) != 0x8e)
 			cpu_relax();
-			
+
 		if (dev->chip_ver == 4)
 			atp_writeb_io(dev, 0, 0x1b, 0x00);
 
@@ -1286,10 +1288,10 @@ rd_inq_data:
 
 		while ((atp_readb_io(dev, 0, 0x1f) & 0x80) == 0x00)
 			cpu_relax();
-			
-		if (atp_readb_io(dev, 0, 0x17) != 0x16) {
+
+		if (atp_readb_io(dev, 0, 0x17) != 0x16)
 			goto sel_ok;
-		}
+
 inq_ok:
 		mbuf[36] = 0;
 		printk(KERN_INFO "         ID: %2d  %s\n", i, &mbuf[8]);
@@ -1321,13 +1323,13 @@ inq_ok:
 
 		while ((atp_readb_io(dev, 0, 0x1f) & 0x80) == 0x00)
 			cpu_relax();
-			
+
 		if (atp_readb_io(dev, 0, 0x17) != 0x11 && atp_readb_io(dev, 0, 0x17) != 0x8e)
 			continue;
 
 		while (atp_readb_io(dev, 0, 0x17) != 0x8e)
 			cpu_relax();
-			
+
 try_wide:
 		j = 0;
 		atp_writeb_io(dev, 0, 0x14, 0x05);
@@ -1337,10 +1339,10 @@ try_wide:
 			if ((atp_readb_io(dev, 0, 0x1f) & 0x01) != 0)
 				atp_writeb_io(dev, 0, 0x19, wide[j++]);
 		}
-		
+
 		while ((atp_readb_io(dev, 0, 0x17) & 0x80) == 0x00)
 			cpu_relax();
-			
+
 		j = atp_readb_io(dev, 0, 0x17) & 0x0f;
 		if (j == 0x0f) {
 			goto widep_in;
@@ -1449,13 +1451,13 @@ set_sync:
 
 		while ((atp_readb_io(dev, 0, 0x1f) & 0x80) == 0x00)
 			cpu_relax();
-			
+
 		if (atp_readb_io(dev, 0, 0x17) != 0x11 && atp_readb_io(dev, 0, 0x17) != 0x8e)
 			continue;
 
 		while (atp_readb_io(dev, 0, 0x17) != 0x8e)
 			cpu_relax();
-			
+
 try_sync:
 		j = 0;
 		atp_writeb_io(dev, 0, 0x14, 0x06);
@@ -1474,10 +1476,10 @@ try_sync:
 				}
 			}
 		}
-		
+
 		while ((atp_readb_io(dev, 0, 0x17) & 0x80) == 0x00)
 			cpu_relax();
-			
+
 		j = atp_readb_io(dev, 0, 0x17) & 0x0f;
 		if (j == 0x0f) {
 			goto phase_ins;
@@ -1526,7 +1528,7 @@ phase_ins1:
 
 		while ((atp_readb_io(dev, 0, 0x17) & 0x80) == 0x00)
 			cpu_relax();
-			
+
 		j = atp_readb_io(dev, 0, 0x17);
 		if (j == 0x85) {
 			goto tar_dcons;
@@ -1547,10 +1549,10 @@ phase_cmds:
 tar_dcons:
 		atp_writeb_io(dev, 0, 0x14, 0x00);
 		atp_writeb_io(dev, 0, 0x18, 0x08);
-		
+
 		while ((atp_readb_io(dev, 0, 0x1f) & 0x80) == 0x00)
 			cpu_relax();
-			
+
 		j = atp_readb_io(dev, 0, 0x17);
 		if (j != 0x16) {
 			continue;
@@ -1649,7 +1651,7 @@ static void is880(struct atp_unit *dev)
 
 		while (atp_readb_io(dev, 0, 0x17) != 0x8e)
 			cpu_relax();
-			
+
 		dev->active_id[0] |= m;
 
 		atp_writeb_io(dev, 0, 0x10, 0x30);
@@ -1657,7 +1659,7 @@ static void is880(struct atp_unit *dev)
 
 phase_cmd:
 		atp_writeb_io(dev, 0, 0x18, 0x08);
-		
+
 		while ((atp_readb_io(dev, 0, 0x1f) & 0x80) == 0x00)
 			cpu_relax();
 
@@ -1679,16 +1681,16 @@ sel_ok:
 		atp_writeb_io(dev, 0, 0x13, inqd[6]);
 		atp_writeb_io(dev, 0, 0x14, inqd[7]);
 		atp_writeb_io(dev, 0, 0x18, inqd[8]);
-		
+
 		while ((atp_readb_io(dev, 0, 0x1f) & 0x80) == 0x00)
 			cpu_relax();
-			
+
 		if (atp_readb_io(dev, 0, 0x17) != 0x11 && atp_readb_io(dev, 0, 0x17) != 0x8e)
 			continue;
 
 		while (atp_readb_io(dev, 0, 0x17) != 0x8e)
 			cpu_relax();
-			
+
 		atp_writeb_io(dev, 0, 0x1b, 0x00);
 		atp_writeb_io(dev, 0, 0x18, 0x08);
 		j = 0;
@@ -1710,9 +1712,10 @@ rd_inq_data:
 		atp_writeb_io(dev, 0, 0x13, 0);
 		atp_writeb_io(dev, 0, 0x14, 0);
 		atp_writeb_io(dev, 0, 0x18, 0x08);
+
 		while ((atp_readb_io(dev, 0, 0x1f) & 0x80) == 0x00)
 			cpu_relax();
-			
+
 		if (atp_readb_io(dev, 0, 0x17) != 0x16)
 			goto sel_ok;
 
@@ -1771,7 +1774,7 @@ try_u3:
 
 		while ((atp_readb_io(dev, 0, 0x17) & 0x80) == 0x00)
 			cpu_relax();
-			
+
 		j = atp_readb_io(dev, 0, 0x17) & 0x0f;
 		if (j == 0x0f) {
 			goto u3p_in;
@@ -1828,10 +1831,10 @@ u3p_cmd:
 		atp_writeb_io(dev, 0, 0x10, 0x30);
 		atp_writeb_io(dev, 0, 0x14, 0x00);
 		atp_writeb_io(dev, 0, 0x18, 0x08);
-		
+
 		while ((atp_readb_io(dev, 0, 0x1f) & 0x80) == 0x00)
 			cpu_relax();
-			
+
 		j = atp_readb_io(dev, 0, 0x17);
 		if (j != 0x16) {
 			if (j == 0x4e) {
@@ -1872,13 +1875,13 @@ chg_wide:
 
 		while ((atp_readb_io(dev, 0, 0x1f) & 0x80) == 0x00)
 			cpu_relax();
-			
+
 		if (atp_readb_io(dev, 0, 0x17) != 0x11 && atp_readb_io(dev, 0, 0x17) != 0x8e)
 			continue;
 
 		while (atp_readb_io(dev, 0, 0x17) != 0x8e)
 			cpu_relax();
-			
+
 try_wide:
 		j = 0;
 		atp_writeb_io(dev, 0, 0x14, 0x05);
@@ -1888,9 +1891,10 @@ try_wide:
 			if ((atp_readb_io(dev, 0, 0x1f) & 0x01) != 0)
 				atp_writeb_io(dev, 0, 0x19, wide[j++]);
 		}
+
 		while ((atp_readb_io(dev, 0, 0x17) & 0x80) == 0x00)
 			cpu_relax();
-			
+
 		j = atp_readb_io(dev, 0, 0x17) & 0x0f;
 		if (j == 0x0f) {
 			goto widep_in;
@@ -2013,9 +2017,9 @@ set_sync:
 		while ((atp_readb_io(dev, 0, 0x1f) & 0x80) == 0x00)
 			cpu_relax();
 
-		if (atp_readb_io(dev, 0, 0x17) != 0x11 && atp_readb_io(dev, 0, 0x17) != 0x8e) {
+		if (atp_readb_io(dev, 0, 0x17) != 0x11 && atp_readb_io(dev, 0, 0x17) != 0x8e)
 			continue;
-		}
+
 		while (atp_readb_io(dev, 0, 0x17) != 0x8e)
 			cpu_relax();
 
@@ -2831,16 +2835,16 @@ static void is885(struct atp_unit *dev, unsigned char c)
 	unsigned char i, j, k, rmb, n, lvdmode;
 	unsigned short int m;
 	static unsigned char mbuf[512];
-	static unsigned char satn[9] =	{0, 0, 0, 0, 0, 0, 0, 6, 6};
-	static unsigned char inqd[9] =	{0x12, 0, 0, 0, 0x24, 0, 0, 0x24, 6};
-	static unsigned char synn[6] =	{0x80, 1, 3, 1, 0x19, 0x0e};
-	unsigned char synu[6] =  {0x80, 1, 3, 1, 0x0a, 0x0e};
-	static unsigned char synw[6] =	{0x80, 1, 3, 1, 0x19, 0x0e};
-	unsigned char synuw[6] =  {0x80, 1, 3, 1, 0x0a, 0x0e};
-	static unsigned char wide[6] =	{0x80, 1, 2, 3, 1, 0};
-	static unsigned char u3[9] = { 0x80,1,6,4,0x09,00,0x0e,0x01,0x02 };
+	static unsigned char satn[9] = { 0, 0, 0, 0, 0, 0, 0, 6, 6 };
+	static unsigned char inqd[9] = { 0x12, 0, 0, 0, 0x24, 0, 0, 0x24, 6 };
+	static unsigned char synn[6] = { 0x80, 1, 3, 1, 0x19, 0x0e };
+	unsigned char synu[6] = { 0x80, 1, 3, 1, 0x0a, 0x0e };
+	static unsigned char synw[6] = { 0x80, 1, 3, 1, 0x19, 0x0e };
+	unsigned char synuw[6] = { 0x80, 1, 3, 1, 0x0a, 0x0e };
+	static unsigned char wide[6] = { 0x80, 1, 2, 3, 1, 0 };
+	static unsigned char u3[9] = { 0x80, 1, 6, 4, 0x09, 00, 0x0e, 0x01, 0x02 };
 
-	lvdmode=atp_readb_io(dev, c, 0x1b) >> 7;
+	lvdmode = atp_readb_io(dev, c, 0x1b) >> 7;
 
 	for (i = 0; i < 16; i++) {
 		m = 1;
@@ -2863,7 +2867,6 @@ static void is885(struct atp_unit *dev, unsigned char c)
 		atp_writeb_io(dev, c, 8, satn[5]);
 		atp_writeb_io(dev, c, 0x0f, 0);
 		atp_writeb_io(dev, c, 0x11, dev->id[c][i].devsp);
-		
 		atp_writeb_io(dev, c, 0x12, 0);
 		atp_writeb_io(dev, c, 0x13, satn[6]);
 		atp_writeb_io(dev, c, 0x14, satn[7]);
@@ -2876,11 +2879,13 @@ static void is885(struct atp_unit *dev, unsigned char c)
 
 		while ((atp_readb_io(dev, c, 0x1f) & 0x80) == 0x00)
 			cpu_relax();
-		if ((atp_readb_io(dev, c, 0x17) != 0x11) && (atp_readb_io(dev, c, 0x17) != 0x8e)) {
+
+		if (atp_readb_io(dev, c, 0x17) != 0x11 && atp_readb_io(dev, c, 0x17) != 0x8e)
 			continue;
-		}
+
 		while (atp_readb_io(dev, c, 0x17) != 0x8e)
 			cpu_relax();
+
 		dev->active_id[c] |= m;
 
 		atp_writeb_io(dev, c, 0x10, 0x30);
@@ -2888,8 +2893,10 @@ static void is885(struct atp_unit *dev, unsigned char c)
 
 phase_cmd:
 		atp_writeb_io(dev, c, 0x18, 0x08);
+
 		while ((atp_readb_io(dev, c, 0x1f) & 0x80) == 0x00)
 			cpu_relax();
+
 		j = atp_readb_io(dev, c, 0x17);
 		if (j != 0x16) {
 			atp_writeb_io(dev, c, 0x10, 0x41);
@@ -2908,13 +2915,16 @@ sel_ok:
 		atp_writeb_io(dev, c, 0x13, inqd[6]);
 		atp_writeb_io(dev, c, 0x14, inqd[7]);
 		atp_writeb_io(dev, c, 0x18, inqd[8]);
+
 		while ((atp_readb_io(dev, c, 0x1f) & 0x80) == 0x00)
 			cpu_relax();
-		if ((atp_readb_io(dev, c, 0x17) != 0x11) && (atp_readb_io(dev, c, 0x17) != 0x8e)) {
+
+		if (atp_readb_io(dev, c, 0x17) != 0x11 && atp_readb_io(dev, c, 0x17) != 0x8e)
 			continue;
-		}
+
 		while (atp_readb_io(dev, c, 0x17) != 0x8e)
 			cpu_relax();
+
 		atp_writeb_io(dev, c, 0x1b, 0x00);
 		atp_writeb_io(dev, c, 0x18, 0x08);
 		j = 0;
@@ -2936,14 +2946,16 @@ rd_inq_data:
 		atp_writeb_io(dev, c, 0x13, 0);
 		atp_writeb_io(dev, c, 0x14, 0);
 		atp_writeb_io(dev, c, 0x18, 0x08);
+
 		while ((atp_readb_io(dev, c, 0x1f) & 0x80) == 0x00)
 			cpu_relax();
-		if (atp_readb_io(dev, c, 0x17) != 0x16) {
+
+		if (atp_readb_io(dev, c, 0x17) != 0x16)
 			goto sel_ok;
-		}
+
 inq_ok:
 		mbuf[36] = 0;
-		printk( KERN_INFO"         ID: %2d  %s\n", i, &mbuf[8]);
+		printk(KERN_INFO "         ID: %2d  %s\n", i, &mbuf[8]);
 		dev->id[c][i].devtype = mbuf[0];
 		rmb = mbuf[1];
 		n = mbuf[7];
@@ -2954,10 +2966,11 @@ inq_ok:
 			goto not_wide;
 		}
 		if (lvdmode == 0) {
-		   goto chg_wide;
+			goto chg_wide;
 		}
-		if (dev->sp[c][i] != 0x04) {	// force u2
-		   goto chg_wide;
+		if (dev->sp[c][i] != 0x04)	// force u2
+		{
+			goto chg_wide;
 		}
 
 		atp_writeb_io(dev, c, 0x1b, 0x01);
@@ -2976,11 +2989,13 @@ inq_ok:
 
 		while ((atp_readb_io(dev, c, 0x1f) & 0x80) == 0x00)
 			cpu_relax();
-		if ((atp_readb_io(dev, c, 0x17) != 0x11) && (atp_readb_io(dev, c, 0x17) != 0x8e)) {
+
+		if (atp_readb_io(dev, c, 0x17) != 0x11 && atp_readb_io(dev, c, 0x17) != 0x8e)
 			continue;
-		}
+
 		while (atp_readb_io(dev, c, 0x17) != 0x8e)
 			cpu_relax();
+
 try_u3:
 		j = 0;
 		atp_writeb_io(dev, c, 0x14, 0x09);
@@ -2991,8 +3006,10 @@ try_u3:
 				atp_writeb_io(dev, c, 0x19, u3[j++]);
 			cpu_relax();
 		}
+
 		while ((atp_readb_io(dev, c, 0x17) & 0x80) == 0x00)
 			cpu_relax();
+
 		j = atp_readb_io(dev, c, 0x17) & 0x0f;
 		if (j == 0x0f) {
 			goto u3p_in;
@@ -3050,7 +3067,9 @@ u3p_cmd:
 		atp_writeb_io(dev, c, 0x10, 0x30);
 		atp_writeb_io(dev, c, 0x14, 0x00);
 		atp_writeb_io(dev, c, 0x18, 0x08);
+
 		while ((atp_readb_io(dev, c, 0x1f) & 0x80) == 0x00);
+
 		j = atp_readb_io(dev, c, 0x17);
 		if (j != 0x16) {
 			if (j == 0x4e) {
@@ -3094,11 +3113,13 @@ chg_wide:
 
 		while ((atp_readb_io(dev, c, 0x1f) & 0x80) == 0x00)
 			cpu_relax();
-		if ((atp_readb_io(dev, c, 0x17) != 0x11) && (atp_readb_io(dev, c, 0x17) != 0x8e)) {
+
+		if (atp_readb_io(dev, c, 0x17) != 0x11 && atp_readb_io(dev, c, 0x17) != 0x8e)
 			continue;
-		}
+
 		while (atp_readb_io(dev, c, 0x17) != 0x8e)
 			cpu_relax();
+
 try_wide:
 		j = 0;
 		atp_writeb_io(dev, c, 0x14, 0x05);
@@ -3109,8 +3130,10 @@ try_wide:
 				atp_writeb_io(dev, c, 0x19, wide[j++]);
 			cpu_relax();
 		}
+
 		while ((atp_readb_io(dev, c, 0x17) & 0x80) == 0x00)
 			cpu_relax();
+
 		j = atp_readb_io(dev, c, 0x17) & 0x0f;
 		if (j == 0x0f) {
 			goto widep_in;
@@ -3168,8 +3191,10 @@ widep_cmd:
 		atp_writeb_io(dev, c, 0x10, 0x30);
 		atp_writeb_io(dev, c, 0x14, 0x00);
 		atp_writeb_io(dev, c, 0x18, 0x08);
+
 		while ((atp_readb_io(dev, c, 0x1f) & 0x80) == 0x00)
 			cpu_relax();
+
 		j = atp_readb_io(dev, c, 0x17);
 		if (j != 0x16) {
 			if (j == 0x4e) {
@@ -3193,24 +3218,23 @@ widep_cmd:
 		m = m << i;
 		dev->wide_id[c] |= m;
 not_wide:
-		if ((dev->id[c][i].devtype == 0x00) || (dev->id[c][i].devtype == 0x07) ||
-		    ((dev->id[c][i].devtype == 0x05) && ((n & 0x10) != 0))) {
+		if ((dev->id[c][i].devtype == 0x00) || (dev->id[c][i].devtype == 0x07) || ((dev->id[c][i].devtype == 0x05) && ((n & 0x10) != 0))) {
 			m = 1;
 			m = m << i;
 			if ((dev->async[c] & m) != 0) {
-			   goto set_sync;
+				goto set_sync;
 			}
 		}
 		continue;
 set_sync:
 		if (dev->sp[c][i] == 0x02) {
-		   synu[4]=0x0c;
-		   synuw[4]=0x0c;
+			synu[4] = 0x0c;
+			synuw[4] = 0x0c;
 		} else {
-		   if (dev->sp[c][i] >= 0x03) {
-		      synu[4]=0x0a;
-		      synuw[4]=0x0a;
-		   }
+			if (dev->sp[c][i] >= 0x03) {
+				synu[4] = 0x0a;
+				synuw[4] = 0x0a;
+			}
 		}
 		j = 0;
 		if ((m & dev->wide_id[c]) != 0) {
@@ -3232,11 +3256,13 @@ set_sync:
 
 		while ((atp_readb_io(dev, c, 0x1f) & 0x80) == 0x00)
 			cpu_relax();
-		if ((atp_readb_io(dev, c, 0x17) != 0x11) && (atp_readb_io(dev, c, 0x17) != 0x8e)) {
+
+		if (atp_readb_io(dev, c, 0x17) != 0x11 && atp_readb_io(dev, c, 0x17) != 0x8e)
 			continue;
-		}
+
 		while (atp_readb_io(dev, c, 0x17) != 0x8e)
 			cpu_relax();
+
 try_sync:
 		j = 0;
 		atp_writeb_io(dev, c, 0x14, 0x06);
@@ -3259,8 +3285,10 @@ try_sync:
 				}
 			}
 		}
+
 		while ((atp_readb_io(dev, c, 0x17) & 0x80) == 0x00)
 			cpu_relax();
+
 		j = atp_readb_io(dev, c, 0x17) & 0x0f;
 		if (j == 0x0f) {
 			goto phase_ins;
@@ -3307,7 +3335,9 @@ phase_ins1:
 		if ((j & 0x80) == 0x00) {
 			goto phase_ins1;
 		}
+
 		while ((atp_readb_io(dev, c, 0x17) & 0x80) == 0x00);
+
 		j = atp_readb_io(dev, c, 0x17);
 		if (j == 0x85) {
 			goto tar_dcons;
@@ -3328,8 +3358,10 @@ phase_cmds:
 tar_dcons:
 		atp_writeb_io(dev, c, 0x14, 0x00);
 		atp_writeb_io(dev, c, 0x18, 0x08);
+
 		while ((atp_readb_io(dev, c, 0x1f) & 0x80) == 0x00)
 			cpu_relax();
+
 		j = atp_readb_io(dev, c, 0x17);
 		if (j != 0x16) {
 			continue;
@@ -3350,7 +3382,7 @@ tar_dcons:
 			mbuf[4] = 0x0e;
 		}
 		dev->id[c][i].devsp = mbuf[4];
-		if (mbuf[3] < 0x0c){
+		if (mbuf[3] < 0x0c) {
 			j = 0xb0;
 			goto set_syn_ok;
 		}
@@ -3371,9 +3403,9 @@ tar_dcons:
 			goto set_syn_ok;
 		}
 		j = 0x60;
-	      set_syn_ok:
+set_syn_ok:
 		dev->id[c][i].devsp = (dev->id[c][i].devsp & 0x0f) | j;
-#ifdef ED_DBGP		
+#ifdef ED_DBGP
 		printk("dev->id[%2d][%2d].devsp = %2x\n",c,i,dev->id[c][i].devsp);
 #endif
 	}
-- 
Ondrej Zary


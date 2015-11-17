From: Ondrej Zary <linux@rainbow-software.org>
Subject: [PATCH 27/52] atp870u: Add remaining 870 support to is885()
Date: Tue, 17 Nov 2015 19:24:03 +0100
Message-ID: <1447784668-23713-28-git-send-email-linux@rainbow-software.org>
References: <1447784668-23713-1-git-send-email-linux@rainbow-software.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.gsystem.sk ([62.176.172.50]:56587 "EHLO gsystem.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754544AbbKQSiK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Nov 2015 13:38:10 -0500
In-Reply-To: <1447784668-23713-1-git-send-email-linux@rainbow-software.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

Add remaining 870 support to is885():
 - different synw, no synuw
 - synu[4] = 0x0c
 - atp_writeb_io(dev, c, 0x04, 0x00); instead of
   atp_writeb_io(dev, c, 0x14, 0x00); (isn't that a bug?)
 - atp_writeb_io(dev, c, 0x14, 0xff); instead of
   atp_writeb_io(dev, c, 0x14, 0x06);
 - different mbuf[3] and mbuf[4] checks

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/scsi/atp870u.c |   45 +++++++++++++++++++++++++++++++--------------
 1 file changed, 31 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/atp870u.c b/drivers/scsi/atp870u.c
index 0548d07..d76d386 100644
--- a/drivers/scsi/atp870u.c
+++ b/drivers/scsi/atp870u.c
@@ -2262,6 +2262,7 @@ static void is885(struct atp_unit *dev, unsigned char c, bool wide_chip, unsigne
 	static unsigned char synn[6] = { 0x80, 1, 3, 1, 0x19, 0x0e };
 	unsigned char synu[6] = { 0x80, 1, 3, 1, 0x0a, 0x0e };
 	static unsigned char synw[6] = { 0x80, 1, 3, 1, 0x19, 0x0e };
+	static unsigned char synw_870[6] = { 0x80, 1, 3, 1, 0x0c, 0x07 };
 	unsigned char synuw[6] = { 0x80, 1, 3, 1, 0x0a, 0x0e };
 	static unsigned char wide[6] = { 0x80, 1, 2, 3, 1, 0 };
 	static unsigned char u3[9] = { 0x80, 1, 6, 4, 0x09, 00, 0x0e, 0x01, 0x02 };
@@ -2311,7 +2312,10 @@ static void is885(struct atp_unit *dev, unsigned char c, bool wide_chip, unsigne
 		dev->active_id[c] |= m;
 
 		atp_writeb_io(dev, c, 0x10, 0x30);
-		atp_writeb_io(dev, c, 0x14, 0x00);
+		if (dev->dev_id == ATP885_DEVID || dev->dev_id == ATP880_DEVID1 || dev->dev_id == ATP880_DEVID2)
+			atp_writeb_io(dev, c, 0x14, 0x00);
+		else /* result of is870() merge - is this a bug? */
+			atp_writeb_io(dev, c, 0x04, 0x00);
 
 phase_cmd:
 		atp_writeb_io(dev, c, 0x18, 0x08);
@@ -2657,7 +2661,7 @@ not_wide:
 		}
 		continue;
 set_sync:
-		if (dev->sp[c][i] == 0x02) {
+		if ((dev->dev_id != ATP885_DEVID && dev->dev_id != ATP880_DEVID1 && dev->dev_id != ATP880_DEVID2) || (dev->sp[c][i] == 0x02)) {
 			synu[4] = 0x0c;
 			synuw[4] = 0x0c;
 		} else {
@@ -2701,11 +2705,14 @@ try_sync:
 		while ((atp_readb_io(dev, c, 0x1f) & 0x80) == 0) {
 			if ((atp_readb_io(dev, c, 0x1f) & 0x01) != 0) {
 				if ((m & dev->wide_id[c]) != 0) {
-					if ((m & dev->ultra_map[c]) != 0) {
-						atp_writeb_io(dev, c, 0x19, synuw[j++]);
-					} else {
-						atp_writeb_io(dev, c, 0x19, synw[j++]);
-					}
+					if (dev->dev_id == ATP885_DEVID || dev->dev_id == ATP880_DEVID1 || dev->dev_id == ATP880_DEVID2) {
+						if ((m & dev->ultra_map[c]) != 0) {
+							atp_writeb_io(dev, c, 0x19, synuw[j++]);
+						} else {
+							atp_writeb_io(dev, c, 0x19, synw[j++]);
+						}
+					} else
+						atp_writeb_io(dev, c, 0x19, synw_870[j++]);
 				} else {
 					if ((m & dev->ultra_map[c]) != 0) {
 						atp_writeb_io(dev, c, 0x19, synu[j++]);
@@ -2753,7 +2760,10 @@ phase_outs:
 		}
 		continue;
 phase_ins:
-		atp_writeb_io(dev, c, 0x14, 0x06);
+		if (dev->dev_id == ATP885_DEVID || dev->dev_id == ATP880_DEVID1 || dev->dev_id == ATP880_DEVID2)
+			atp_writeb_io(dev, c, 0x14, 0x06);
+		else
+			atp_writeb_io(dev, c, 0x14, 0xff);
 		atp_writeb_io(dev, c, 0x18, 0x20);
 		k = 0;
 phase_ins1:
@@ -2808,14 +2818,21 @@ tar_dcons:
 		if (mbuf[3] > 0x64) {
 			continue;
 		}
-		if (mbuf[4] > 0x0e) {
-			mbuf[4] = 0x0e;
+		if (dev->dev_id == ATP885_DEVID || dev->dev_id == ATP880_DEVID1 || dev->dev_id == ATP880_DEVID2) {
+			if (mbuf[4] > 0x0e) {
+				mbuf[4] = 0x0e;
+			}
+		} else {
+			if (mbuf[4] > 0x0c) {
+				mbuf[4] = 0x0c;
+			}
 		}
 		dev->id[c][i].devsp = mbuf[4];
-		if (mbuf[3] < 0x0c) {
-			j = 0xb0;
-			goto set_syn_ok;
-		}
+		if (dev->dev_id == ATP885_DEVID || dev->dev_id == ATP880_DEVID1 || dev->dev_id == ATP880_DEVID2)
+			if (mbuf[3] < 0x0c) {
+				j = 0xb0;
+				goto set_syn_ok;
+			}
 		if ((mbuf[3] < 0x0d) && (rmb == 0)) {
 			j = 0xa0;
 			goto set_syn_ok;
-- 
Ondrej Zary


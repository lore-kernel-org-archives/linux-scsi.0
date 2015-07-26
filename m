From: Ondrej Zary <linux@rainbow-software.org>
Subject: [PATCH 28/52] atp870u: Move 870-specific code out of is870()
Date: Sun, 26 Jul 2015 22:24:35 +0200
Message-ID: <1437942299-26674-29-git-send-email-linux@rainbow-software.org>
References: <1437942299-26674-1-git-send-email-linux@rainbow-software.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.gsystem.sk ([62.176.172.50]:56672 "EHLO gsystem.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755460AbbGZU5G (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 26 Jul 2015 16:57:06 -0400
Received: from stip-static-68.213-81-217.telecom.sk ([213.81.217.68] helo=gsql.ggedos.sk)
	by gsystem.sk with esmtpsa (TLS1.1:DHE_RSA_AES_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <linux@rainbow-software.org>)
	id 1ZJSTy-0003IN-Ei
	for linux-scsi@vger.kernel.org; Sun, 26 Jul 2015 22:25:14 +0200
In-Reply-To: <1437942299-26674-1-git-send-email-linux@rainbow-software.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Move few remaining 870-specific code lines out of is870()

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/scsi/atp870u.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/atp870u.c b/drivers/scsi/atp870u.c
index d76d386..6427f87 100644
--- a/drivers/scsi/atp870u.c
+++ b/drivers/scsi/atp870u.c
@@ -1174,8 +1174,6 @@ static void is870(struct atp_unit *dev, unsigned char c, bool wide_chip)
 	static unsigned char synw[6] = { 0x80, 1, 3, 1, 0x0c, 0x07 };
 	static unsigned char wide[6] = { 0x80, 1, 2, 3, 1, 0 };
 
-	atp_writeb_io(dev, c, 0x3a, atp_readb_io(dev, c, 0x3a) | 0x10);
-
 	for (i = 0; i < 16; i++) {
 		if (!wide_chip && (i > 7))
 			break;
@@ -1587,7 +1585,6 @@ tar_dcons:
 set_syn_ok:
 		dev->id[c][i].devsp = (dev->id[c][i].devsp & 0x0f) | j;
 	}
-	atp_writeb_io(dev, c, 0x3a, atp_readb_io(dev, c, 0x3a) & 0xef);
 }
 
 static void atp870u_free_tables(struct Scsi_Host *host)
@@ -2032,7 +2029,9 @@ flash_ok_885:
 		outb(0x20, base_io + 0x11);
 
 		tscam(shpnt);
+		atp_writeb_io(p, 0, 0x3a, atp_readb_io(p, 0, 0x3a) | 0x10);
 		is870(p, 0, p->chip_ver == 4);
+		atp_writeb_io(p, 0, 0x3a, atp_readb_io(p, 0, 0x3a) & 0xef);
 		outb((inb(base_io + 0x3a) & 0xef), base_io + 0x3a);
 		outb((inb(base_io + 0x3b) | 0x20), base_io + 0x3b);
 		if (atpdev->chip_ver == 4)
-- 
Ondrej Zary


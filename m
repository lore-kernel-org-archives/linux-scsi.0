From: Ondrej Zary <linux@rainbow-software.org>
Subject: [PATCH 36/52] atp870u: Remove empty tscam_885()
Date: Tue, 17 Nov 2015 19:24:12 +0100
Message-ID: <1447784668-23713-37-git-send-email-linux@rainbow-software.org>
References: <1447784668-23713-1-git-send-email-linux@rainbow-software.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.gsystem.sk ([62.176.172.50]:56535 "EHLO gsystem.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932269AbbKQSg6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Nov 2015 13:36:58 -0500
In-Reply-To: <1447784668-23713-1-git-send-email-linux@rainbow-software.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

tscam_885() is empty (except a delay) so remove it.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/scsi/atp870u.c |   15 +--------------
 1 file changed, 1 insertion(+), 14 deletions(-)

diff --git a/drivers/scsi/atp870u.c b/drivers/scsi/atp870u.c
index b662e39..2570919 100644
--- a/drivers/scsi/atp870u.c
+++ b/drivers/scsi/atp870u.c
@@ -42,7 +42,6 @@
 static struct scsi_host_template atp870u_template;
 static void send_s870(struct atp_unit *dev,unsigned char c);
 static void atp_is(struct atp_unit *dev, unsigned char c, bool wide_chip, unsigned char lvdmode);
-static void tscam_885(void);
 
 static inline void atp_writeb_base(struct atp_unit *atp, u8 reg, u8 val)
 {
@@ -1518,7 +1517,7 @@ flash_ok_885:
 		   k = (k & 0x07) | 0x40;
 		atp_set_host_id(p, 1, k);
 
-		tscam_885();
+		mdelay(600); /* this delay used to be called tscam_885() */
 		printk(KERN_INFO "   Scanning Channel A SCSI Device ...\n");
 		atp_is(p, 0, true, atp_readb_io(p, 0, 0x1b) >> 7);
 		atp_writeb_io(p, 0, 0x16, 0x80);
@@ -1802,18 +1801,6 @@ static void __exit atp870u_exit(void)
 	pci_unregister_driver(&atp870u_driver);
 }
 
-static void tscam_885(void)
-{
-	unsigned char i;
-
-	for (i = 0; i < 0x2; i++) {
-		mdelay(300);
-	}
-	return;
-}
-
-
-
 static void atp_is(struct atp_unit *dev, unsigned char c, bool wide_chip, unsigned char lvdmode)
 {
 	unsigned char i, j, k, rmb, n;
-- 
Ondrej Zary


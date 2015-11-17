From: Ondrej Zary <linux@rainbow-software.org>
Subject: [PATCH 34/52] atp870u: Introduce atp_set_host_id
Date: Tue, 17 Nov 2015 19:24:10 +0100
Message-ID: <1447784668-23713-35-git-send-email-linux@rainbow-software.org>
References: <1447784668-23713-1-git-send-email-linux@rainbow-software.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.gsystem.sk ([62.176.172.50]:56546 "EHLO gsystem.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932534AbbKQShZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Nov 2015 13:37:25 -0500
In-Reply-To: <1447784668-23713-1-git-send-email-linux@rainbow-software.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

The code for setting host adapter ID is the same for all chips.
Move it to a common function.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/scsi/atp870u.c |   57 +++++++++++++++---------------------------------
 1 file changed, 18 insertions(+), 39 deletions(-)

diff --git a/drivers/scsi/atp870u.c b/drivers/scsi/atp870u.c
index 04b29d3..9621403 100644
--- a/drivers/scsi/atp870u.c
+++ b/drivers/scsi/atp870u.c
@@ -1229,6 +1229,18 @@ static int atp870u_init_tables(struct Scsi_Host *host)
 	return 0;
 }
 
+static void atp_set_host_id(struct atp_unit *atp, u8 c, u8 host_id)
+{
+	atp_writeb_io(atp, c, 0, host_id | 0x08);
+	atp_writeb_io(atp, c, 0x18, 0);
+	while ((atp_readb_io(atp, c, 0x1f) & 0x80) == 0)
+		mdelay(1);
+	atp_readb_io(atp, c, 0x17);
+	atp_writeb_io(atp, c, 1, 8);
+	atp_writeb_io(atp, c, 2, 0x7f);
+	atp_writeb_io(atp, c, 0x11, 0x20);
+}
+
 /* return non-zero on detection */
 static int atp870u_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
@@ -1379,14 +1391,8 @@ flash_ok_880:
 		mdelay(32);
 		atp_readb_io(p, 0, 0x1b);
 		atp_readb_io(p, 0, 0x17);
-		atp_writeb_io(p, 0, 0, host_id | 0x08);
-		atp_writeb_io(p, 0, 0x18, 0);
-		while ((atp_readb_io(p, 0, 0x1f) & 0x80) == 0)
-			mdelay(1);
-		atp_readb_io(p, 0, 0x17);
-		atp_writeb_io(p, 0, 1, 8);
-		atp_writeb_io(p, 0, 2, 0x7f);
-		atp_writeb_io(p, 0, 0x11, 0x20);
+
+		atp_set_host_id(p, 0, host_id);
 
 		tscam(shpnt);
 		atp_is(p, 0, true, atp_readb_base(p, 0x3f) & 0x40);
@@ -1503,35 +1509,16 @@ flash_ok_885:
 		atp_readb_io(p, 0, 0x17);
 		atp_readb_io(p, 1, 0x1b);
 		atp_readb_io(p, 1, 0x17);
+
 		k=p->host_id[0];
 		if (k > 7)
 		   k = (k & 0x07) | 0x40;
-		k |= 0x08;
-		atp_writeb_io(p, 0, 0, k);
-		atp_writeb_io(p, 0, 0x18, 0);
-
-		while ((atp_readb_io(p, 0, 0x1f) & 0x80) == 0)
-			cpu_relax();
-	
-		atp_readb_io(p, 0, 0x17);
-		atp_writeb_io(p, 0, 1, 8);
-		atp_writeb_io(p, 0, 2, 0x7f);
-		atp_writeb_io(p, 0, 0x11, 0x20);
+		atp_set_host_id(p, 0, k);
 
 		k=p->host_id[1];
 		if (k > 7)
 		   k = (k & 0x07) | 0x40;
-		k |= 0x08;
-		atp_writeb_io(p, 1, 0, k);
-		atp_writeb_io(p, 1, 0x18, 0);
-
-		while ((atp_readb_io(p, 1, 0x1f) & 0x80) == 0)
-			cpu_relax();
-
-		atp_readb_io(p, 1, 0x17);
-		atp_writeb_io(p, 1, 1, 8);
-		atp_writeb_io(p, 1, 2, 0x7f);
-		atp_writeb_io(p, 1, 0x11, 0x20);
+		atp_set_host_id(p, 1, k);
 
 		tscam_885();
 		printk(KERN_INFO "   Scanning Channel A SCSI Device ...\n");
@@ -1608,15 +1595,7 @@ flash_ok_885:
 		mdelay(32);
 		atp_writeb_base(p, 0x3a, k);
 		mdelay(32);
-		atp_writeb_io(p, 0, 0, host_id | 0x08);
-		atp_writeb_io(p, 0, 0x18, 0);
-		while ((atp_readb_io(p, 0, 0x1f) & 0x80) == 0)
-			mdelay(1);
-
-		atp_readb_io(p, 0, 0x17);
-		atp_writeb_io(p, 0, 1, 8);
-		atp_writeb_io(p, 0, 2, 0x7f);
-		atp_writeb_io(p, 0, 0x11, 0x20);
+		atp_set_host_id(p, 0, host_id);
 
 		tscam(shpnt);
 		atp_writeb_base(p, 0x3a, atp_readb_base(p, 0x3a) | 0x10);
-- 
Ondrej Zary


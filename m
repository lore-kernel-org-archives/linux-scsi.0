From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Subject: [PATCH 82] drivers/scsi/zorro7xx.c: kmalloc + memset conversion to kzalloc
Date: Wed, 1 Aug 2007 00:21:33 +0200
Message-ID: <200708010021.34147.m.kozlowski@tuxland.pl>
References: <200707311845.48807.m.kozlowski@tuxland.pl>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:1830 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754156AbXGaWVf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 31 Jul 2007 18:21:35 -0400
In-Reply-To: <200707311845.48807.m.kozlowski@tuxland.pl>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 drivers/scsi/zorro7xx.c | 4579 -> 4501 (-78 bytes)

 drivers/scsi/zorro7xx.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- linux-2.6.23-rc1-mm1-a/drivers/scsi/zorro7xx.c	2007-07-26 13:07:42.000000000 +0200
+++ linux-2.6.23-rc1-mm1-b/drivers/scsi/zorro7xx.c	2007-07-31 14:25:58.000000000 +0200
@@ -69,7 +69,7 @@ static struct zorro_device_id zorro7xx_z
 static int __devinit zorro7xx_init_one(struct zorro_dev *z,
 				       const struct zorro_device_id *ent)
 {
-	struct Scsi_Host * host = NULL;
+	struct Scsi_Host *host;
 	struct NCR_700_Host_Parameters *hostdata;
 	struct zorro_driver_data *zdd;
 	unsigned long board, ioaddr;
@@ -89,14 +89,12 @@ static int __devinit zorro7xx_init_one(s
 		return -EBUSY;
 	}

-	hostdata = kmalloc(sizeof(struct NCR_700_Host_Parameters), GFP_KERNEL);
-	if (hostdata == NULL) {
+	hostdata = kzalloc(sizeof(struct NCR_700_Host_Parameters), GFP_KERNEL);
+	if (!hostdata) {
 		printk(KERN_ERR "zorro7xx: Failed to allocate host data\n");
 		goto out_release;
 	}

-	memset(hostdata, 0, sizeof(struct NCR_700_Host_Parameters));
-
 	/* Fill in the required pieces of hostdata */
 	if (ioaddr > 0x01000000)
 		hostdata->base = ioremap(ioaddr, zorro_resource_len(z));

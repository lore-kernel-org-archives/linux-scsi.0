From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [PATCH] zalon: fix oops on attach failure
Date: Wed, 24 Jun 2009 19:55:22 +0000
Message-ID: <1245873322.4022.385.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-parisc-owner@vger.kernel.org>
Sender: linux-parisc-owner@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Parisc List <linux-parisc@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

I recently discovered on my zalon that if the attachment fails because
of a bus misconfiguration (I scrapped my HVD array, so the card is now
unterminated) then the system oopses.  The reason is that if
ncr_attach() returns NULL (signalling failure) that NULL is passed by
the goto failed straight into ncr_detach() which oopses.

The fix is just to return -ENODEV in this case.

James

---

diff --git a/drivers/scsi/zalon.c b/drivers/scsi/zalon.c
index 97f3158..27e84e4 100644
--- a/drivers/scsi/zalon.c
+++ b/drivers/scsi/zalon.c
@@ -134,7 +134,7 @@ zalon_probe(struct parisc_device *dev)
 
 	host = ncr_attach(&zalon7xx_template, unit, &device);
 	if (!host)
-		goto fail;
+		return -ENODEV;
 
 	if (request_irq(dev->irq, ncr53c8xx_intr, IRQF_SHARED, "zalon", host)) {
 	  dev_printk(KERN_ERR, &dev->dev, "irq problem with %d, detaching\n ",



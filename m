From: Tejun Heo <htejun@gmail.com>
Subject: [PATCH] libata: fix probe_ent alloc/free bugs
Date: Sun, 18 Feb 2007 02:24:37 +0900
Message-ID: <45D73A55.90008@gmail.com>
References: <45D710E8.3090104@gmail.com> <1171725374.3379.15.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.246]:37047 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992853AbXBQRYt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 17 Feb 2007 12:24:49 -0500
Received: by an-out-0708.google.com with SMTP id b33so19544ana
        for <linux-scsi@vger.kernel.org>; Sat, 17 Feb 2007 09:24:48 -0800 (PST)
In-Reply-To: <1171725374.3379.15.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Jeff Garzik <jeff@garzik.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

ata_probe_ent_alloc() had a temporary hack such that devm_kzalloc()
was used for allocation if devres had been previously initialized on
the device; otherwise, plain kzalloc() was used.  This was to make the
code useable from both the old and devres-aware libata drivers during
transition.  This hack made ata_sas_port_alloc() unable to determine
how the probe_ent is allocated, causing double free in some cases.

Remove the now-unneeded hack and make ata_sas_port_alloc() use
devm_kfree().

Signed-off-by: Tejun Heo <htejun@gmail.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>
---
James, thanks for the diagnosis and please ack if this fixes the
problem.

Jeff, after James' ack, can you please verify this works with a libata
driver?  Just loading and unloading a libata LLD should be enough.
I'm visiting my hometown for lunar new year's day, so I can't do it
till Tuesday.

Thanks.

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 2cf8251..c34e0b4 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -5891,11 +5891,7 @@ ata_probe_ent_alloc(struct device *dev, const struct ata_port_info *port)
 {
 	struct ata_probe_ent *probe_ent;
 
-	/* XXX - the following if can go away once all LLDs are managed */
-	if (!list_empty(&dev->devres_head))
-		probe_ent = devm_kzalloc(dev, sizeof(*probe_ent), GFP_KERNEL);
-	else
-		probe_ent = kzalloc(sizeof(*probe_ent), GFP_KERNEL);
+	probe_ent = devm_kzalloc(dev, sizeof(*probe_ent), GFP_KERNEL);
 	if (!probe_ent) {
 		printk(KERN_ERR DRV_NAME "(%s): out of memory\n",
 		       kobject_name(&(dev->kobj)));
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 0009818..e5e19e3 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -3234,7 +3234,7 @@ struct ata_port *ata_sas_port_alloc(struct ata_host *host,
 
 	ata_port_init(ap, host, ent, 0);
 	ap->lock = shost->host_lock;
-	kfree(ent);
+	devm_kfree(host->dev, ent);
 	return ap;
 }
 EXPORT_SYMBOL_GPL(ata_sas_port_alloc);

From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] hpsa: expose enclosures
Date: Fri,  2 Dec 2016 11:36:33 +0100
Message-ID: <1480674993-118324-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45540 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932755AbcLBKgg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 2 Dec 2016 05:36:36 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Don Brace <don.brace@microsemi.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

Some servers have a built-in enclosure which will show up on the
same bus as the internal physical devices. As the driver doesn't
differentiate here they'll be hidden from the OS.
This patch add a module parameter 'hpsa_expose_enclosure' which
will expose these enclosures.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/hpsa.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 3783ef6..b9e05b3 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -90,6 +90,10 @@
 module_param(hpsa_simple_mode, int, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(hpsa_simple_mode,
 	"Use 'simple mode' rather than 'performant mode'");
+static int hpsa_expose_enclosure;
+module_param(hpsa_expose_enclosure, int, S_IRUGO|S_IWUSR);
+MODULE_PARM_DESC(hpsa_expose_enclosure,
+	     "Expose enclosure devices to the OS");
 
 /* define the PCI info for the cards we can control */
 static const struct pci_device_id hpsa_pci_device_id[] = {
@@ -4417,7 +4421,11 @@ static void hpsa_update_scsi_devices(struct ctlr_info *h)
 		 * Expose all devices except for physical devices that
 		 * are masked.
 		 */
-		if (MASKED_DEVICE(lunaddrbytes) && this_device->physical_device)
+		if (hpsa_expose_enclosure &&
+		    this_device->devtype == TYPE_ENCLOSURE)
+			this_device->expose_device = 1;
+		else if (MASKED_DEVICE(lunaddrbytes) &&
+			 this_device->physical_device)
 			this_device->expose_device = 0;
 		else
 			this_device->expose_device = 1;
-- 
1.8.5.6


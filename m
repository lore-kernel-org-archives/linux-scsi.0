From: Mark Lord <liml@rtr.ca>
Subject: Re: [PATCH] RESEND: SCSI, libata: add support for ATA_16 commands
 to libata ATAPI devices
Date: Wed, 31 Jan 2007 20:01:01 -0500
Message-ID: <45C13BCD.8080003@rtr.ca>
References: <200701021935.07840.liml@rtr.ca> <200701311346.26644.liml@rtr.ca> <45C1356B.6000907@gmail.com> <45C1377F.6070001@rtr.ca> <45C138E8.1040706@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rtr.ca ([64.26.128.89]:4392 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161154AbXBABBD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 31 Jan 2007 20:01:03 -0500
In-Reply-To: <45C138E8.1040706@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: Linux IDE <linux-ide@vger.kernel.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, Jeff Garzik <jeff@garzik.org>, linux-scsi@vger.kernel.org

Tejun Heo wrote:
> Anyways, this has never been guaranteed because
> the limit is host wide.

But until very very recently, "host wide" meant just a single device
for libata.  I was just assuming we did all of the fiddling to ensure
a minimal value there for some real reason.

But, yes, now we have PATA (2 drives per host), and PMP (many more
drives per host), so just maxing out the limit seems sensible.
 
> So, I'm for setting it to 16.  Jeff, what do you think?

This patch sets libata to always accept CDB lengths up to 16 bytes.
With this change, ATA_16 passthrough commands can now be passed into
libata for ATAPI devices.  There is a separate related patch already
pending to actually implement ATA_16 for ATAPI inside libata.

Signed-off-by:  Mark Lord <mlord@pobox.com>
---
--- old/drivers/ata/libata-core.c	2007-01-31 19:55:53.000000000 -0500
+++ linux/drivers/ata/libata-core.c	2007-01-31 19:57:15.000000000 -0500
@@ -1577,20 +1577,6 @@
 		snprintf(desc, desc_sz, "NCQ (depth %d/%d)", hdepth, ddepth);
 }
 
-static void ata_set_port_max_cmd_len(struct ata_port *ap)
-{
-	int i;
-
-	if (ap->scsi_host) {
-		unsigned int len = 0;
-
-		for (i = 0; i < ATA_MAX_DEVICES; i++)
-			len = max(len, ap->device[i].cdb_len);
-
-		ap->scsi_host->max_cmd_len = len;
-	}
-}
-
 /**
  *	ata_dev_configure - Configure the specified ATA/ATAPI device
  *	@dev: Target device to configure
@@ -1771,8 +1757,6 @@
 		}
 	}
 
-	ata_set_port_max_cmd_len(ap);
-
 	/* limit bridge transfers to udma5, 200 sectors */
 	if (ata_dev_knobble(dev)) {
 		if (ata_msg_drv(ap) && print_info)
@@ -5689,7 +5673,7 @@
 	shost->max_id = 16;
 	shost->max_lun = 1;
 	shost->max_channel = 1;
-	shost->max_cmd_len = 12;
+	shost->max_cmd_len = 16;
 }
 
 /**

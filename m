From: Andi Kleen <ak@suse.de>
Subject: [PATCH] Fix crash in aic79xx probing in scsi-misc when no hardware is present
Date: Wed, 31 Aug 2005 10:45:54 +0200
Message-ID: <200508311045.54846.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:19128 "EHLO mx2.suse.de")
	by vger.kernel.org with ESMTP id S932489AbVHaIqA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 31 Aug 2005 04:46:00 -0400
Received: from Relay2.suse.de (mail2.suse.de [195.135.221.8])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx2.suse.de (Postfix) with ESMTP id A32981D975
	for <linux-scsi@vger.kernel.org>; Wed, 31 Aug 2005 10:45:59 +0200 (CEST)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


aic79xx in scsi-misc would oops when no hardware was present.
Reason was a duplicated call to free the spi transport object -
it was done both in ahd_linux_exit and in the cleanup part
of ahd_linux_init.

Just remove the superfluous call.

Signed-off-by: Andi Kleen <ak@suse.de>

Index: linux-2.6.13/drivers/scsi/aic7xxx/aic79xx_osm.c
===================================================================
--- linux-2.6.13.orig/drivers/scsi/aic7xxx/aic79xx_osm.c
+++ linux-2.6.13/drivers/scsi/aic7xxx/aic79xx_osm.c
@@ -2771,7 +2771,6 @@ ahd_linux_init(void)
 				      sizeof(struct ahd_linux_device));
 	if (ahd_linux_detect(&aic79xx_driver_template) > 0)
 		return 0;
-	spi_release_transport(ahd_linux_transport_template);
 	ahd_linux_exit();
 	return -ENODEV;
 }

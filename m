From: Joe Perches <joe@perches.com>
Subject: [PATCH] drivers/scsi/aic7xxx/aic7xxx_osm_pci.c - remove pointer
	comparison to 0
Date: Sun, 10 Feb 2008 21:47:32 -0800
Message-ID: <1202708852.13411.3.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2072 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751113AbYBKFsA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Feb 2008 00:48:00 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c b/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c
index dd6e21d..65e194f 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c
@@ -301,7 +301,7 @@ ahc_linux_pci_reserve_io_region(struct ahc_softc *ahc, u_long *base)
 	*base = pci_resource_start(ahc->dev_softc, 0);
 	if (*base == 0)
 		return (ENOMEM);
-	if (request_region(*base, 256, "aic7xxx") == 0)
+	if (!request_region(*base, 256, "aic7xxx"))
 		return (ENOMEM);
 	return (0);
 }
@@ -318,7 +318,7 @@ ahc_linux_pci_reserve_mem_region(struct ahc_softc *ahc,
 	start = pci_resource_start(ahc->dev_softc, 1);
 	if (start != 0) {
 		*bus_addr = start;
-		if (request_mem_region(start, 0x1000, "aic7xxx") == 0)
+		if (!request_mem_region(start, 0x1000, "aic7xxx"))
 			error = ENOMEM;
 		if (error == 0) {
 			*maddr = ioremap_nocache(start, 256);



From: Fabian Frederick <fabf@skynet.be>
Subject: [PATCH 1/1] drivers/scsi/aic7xxx/aic79xx_osm.c: replace kmalloc/memset by kzalloc
Date: Tue, 27 May 2014 20:01:54 +0200
Message-ID: <1401213714-7701-1-git-send-email-fabf@skynet.be>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailrelay001.isp.belgacom.be ([195.238.6.51]:50764 "EHLO
	mailrelay001.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750885AbaE0SCS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 May 2014 14:02:18 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Hannes Reinecke <hare@suse.de>, "James E.J. Bottomley" <JBottomley@parallels.com>

Cc: Hannes Reinecke <hare@suse.de>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/scsi/aic7xxx/aic79xx_osm.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.c b/drivers/scsi/aic7xxx/aic79xx_osm.c
index 69d5c43..76b5fec 100644
--- a/drivers/scsi/aic7xxx/aic79xx_osm.c
+++ b/drivers/scsi/aic7xxx/aic79xx_osm.c
@@ -1325,10 +1325,9 @@ int
 ahd_platform_alloc(struct ahd_softc *ahd, void *platform_arg)
 {
 	ahd->platform_data =
-	    kmalloc(sizeof(struct ahd_platform_data), GFP_ATOMIC);
+	    kzalloc(sizeof(struct ahd_platform_data), GFP_ATOMIC);
 	if (ahd->platform_data == NULL)
 		return (ENOMEM);
-	memset(ahd->platform_data, 0, sizeof(struct ahd_platform_data));
 	ahd->platform_data->irq = AHD_LINUX_NOIRQ;
 	ahd_lockinit(ahd);
 	ahd->seltime = (aic79xx_seltime & 0x3) << 4;
-- 
1.8.4.5


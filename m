From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3/4] smartpqi: remove the smp_handler stub
Date: Fri, 25 Aug 2017 17:37:40 +0200
Message-ID: <20170825153741.5091-4-hch@lst.de>
References: <20170825153741.5091-1-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:36725 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933386AbdHYPhy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Aug 2017 11:37:54 -0400
In-Reply-To: <20170825153741.5091-1-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chaitra Basappa <chaitra.basappa@broadcom.com>, linux-scsi@vger.kernel.org
Cc: Bart Van Assche <bart.vanassche@wdc.com>

The SAS transport class will do the right thing and not register the BSG
node if now smp_handler method is present.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/smartpqi/smartpqi_sas_transport.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_sas_transport.c b/drivers/scsi/smartpqi/smartpqi_sas_transport.c
index 0d89d3728b43..b209a35e482e 100644
--- a/drivers/scsi/smartpqi/smartpqi_sas_transport.c
+++ b/drivers/scsi/smartpqi/smartpqi_sas_transport.c
@@ -329,14 +329,6 @@ static int pqi_sas_phy_speed(struct sas_phy *phy,
 	return -EINVAL;
 }
 
-/* SMP = Serial Management Protocol */
-
-static int pqi_sas_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
-	struct request *req)
-{
-	return -EINVAL;
-}
-
 struct sas_function_template pqi_sas_transport_functions = {
 	.get_linkerrors = pqi_sas_get_linkerrors,
 	.get_enclosure_identifier = pqi_sas_get_enclosure_identifier,
@@ -346,5 +338,4 @@ struct sas_function_template pqi_sas_transport_functions = {
 	.phy_setup = pqi_sas_phy_setup,
 	.phy_release = pqi_sas_phy_release,
 	.set_phy_speed = pqi_sas_phy_speed,
-	.smp_handler = pqi_sas_smp_handler,
 };
-- 
2.11.0

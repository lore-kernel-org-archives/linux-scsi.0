From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/4] hpsa: remove the smp_handler stub
Date: Fri, 25 Aug 2017 17:37:39 +0200
Message-ID: <20170825153741.5091-3-hch@lst.de>
References: <20170825153741.5091-1-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:57853 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933386AbdHYPhv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Aug 2017 11:37:51 -0400
In-Reply-To: <20170825153741.5091-1-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chaitra Basappa <chaitra.basappa@broadcom.com>, linux-scsi@vger.kernel.org
Cc: Bart Van Assche <bart.vanassche@wdc.com>

The SAS transport class will do the right thing and not register the BSG
node if now smp_handler method is present.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/hpsa.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 4f7cdb28bd38..a8778bd725c5 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -9443,14 +9443,6 @@ hpsa_sas_phy_speed(struct sas_phy *phy, struct sas_phy_linkrates *rates)
 	return -EINVAL;
 }
 
-/* SMP = Serial Management Protocol */
-static int
-hpsa_sas_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
-struct request *req)
-{
-	return -EINVAL;
-}
-
 static struct sas_function_template hpsa_sas_transport_functions = {
 	.get_linkerrors = hpsa_sas_get_linkerrors,
 	.get_enclosure_identifier = hpsa_sas_get_enclosure_identifier,
@@ -9460,7 +9452,6 @@ static struct sas_function_template hpsa_sas_transport_functions = {
 	.phy_setup = hpsa_sas_phy_setup,
 	.phy_release = hpsa_sas_phy_release,
 	.set_phy_speed = hpsa_sas_phy_speed,
-	.smp_handler = hpsa_sas_smp_handler,
 };
 
 /*
-- 
2.11.0

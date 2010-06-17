From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 01/17] mpt2sas: Fix to use sas device list instead of enclosure list for _transpor_get_enclosure_identifier.
Date: Thu, 17 Jun 2010 13:25:13 +0530
Message-ID: <20100617075513.GB28921@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:55588 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755713Ab0FQIat (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Jun 2010 04:30:49 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Eric.Moore@lsi.com, James.Bottomley@HansenPartnership.com, Sathya.Prakash@lsi.com

Enclosure_identifier not being returned by mpt2sas
The driver exports callback function to the sas transport layer
for obtaining the enclosure logical id.  This function is called
_transport_get_enclosure_identifier.  The driver was searching
the wrong list for the enclosure_identifier.  The driver should be
searching the sas device list instead of enclosure list.  The
sas address that is passed to the driver is for the end device, not
enclosure.

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.h b/drivers/scsi/mpt2sas/mpt2sas_base.h
diff --git a/drivers/scsi/mpt2sas/mpt2sas_transport.c b/drivers/scsi/mpt2sas/mpt2sas_transport.c
index 2727c3b..778e149 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_transport.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_transport.c
@@ -1007,18 +1007,18 @@ static int
 _transport_get_enclosure_identifier(struct sas_rphy *rphy, u64 *identifier)
 {
 	struct MPT2SAS_ADAPTER *ioc = rphy_to_ioc(rphy);
-	struct _sas_node *sas_expander;
+	struct _sas_device *sas_device;
 	unsigned long flags;
 
-	spin_lock_irqsave(&ioc->sas_node_lock, flags);
-	sas_expander = mpt2sas_scsih_expander_find_by_sas_address(ioc,
+	spin_lock_irqsave(&ioc->sas_device_lock, flags);
+	sas_device = mpt2sas_scsih_sas_device_find_by_sas_address(ioc,
 	    rphy->identify.sas_address);
-	spin_unlock_irqrestore(&ioc->sas_node_lock, flags);
+	spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
 
-	if (!sas_expander)
+	if (!sas_device)
 		return -ENXIO;
 
-	*identifier = sas_expander->enclosure_logical_id;
+	*identifier = sas_device->enclosure_logical_id;
 	return 0;
 }
 

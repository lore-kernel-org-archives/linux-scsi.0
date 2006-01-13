From: "Moore, Eric" <Eric.Moore@lsil.com>
Subject: [PATCH] scsi_transport_sas.c - mapping the rphy channel equal to the port identifier
Date: Fri, 13 Jan 2006 16:25:17 -0700
Message-ID: <F331B95B72AFFB4B87467BE1C8E9CF5F1AA7E8@NAMAIL2.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:12982 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1423101AbWAMXZb convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Jan 2006 18:25:31 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, hch@lst.de, James.Bottomley@steeleye.com

Remapping the channel number to the port identifier.

We will be mapping the RAID volumes in mptsas to a reserved channel that
is one larger than the anticapated number of ports on the direct
attached host
adapter.

Signed-off-by: Eric Moore <Eric.Moore@lsil.com>

--- scsi-misc-2.6-old/drivers/scsi/scsi_transport_sas.c	2006-01-13
11:44:08.000000000 -0700
+++ scsi-misc-2.6/drivers/scsi/scsi_transport_sas.c	2006-01-13
12:25:21.000000000 -0700
@@ -638,7 +638,7 @@
 	mutex_unlock(&sas_host->lock);
 
 	if (rphy->scsi_target_id != -1) {
-		scsi_scan_target(&rphy->dev, parent->number,
+		scsi_scan_target(&rphy->dev, parent->port_identifier,
 				rphy->scsi_target_id, ~0, 0);
 	}
 
@@ -735,9 +745,9 @@
 		if (rphy->scsi_target_id == -1)
 			continue;
 
-		if ((channel == SCAN_WILD_CARD || channel ==
parent->number) &&
+		if ((channel == SCAN_WILD_CARD || channel ==
parent->port_identifier) &&
 		    (id == SCAN_WILD_CARD || id ==
rphy->scsi_target_id)) {
-			scsi_scan_target(&rphy->dev, parent->number,
+			scsi_scan_target(&rphy->dev,
parent->port_identifier,
 					 rphy->scsi_target_id, lun, 1);
 		}
 	}

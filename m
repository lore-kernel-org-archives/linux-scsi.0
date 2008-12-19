From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 07/11] zfcp: Simplify mask lookups for incoming RSCNs
Date: Fri, 19 Dec 2008 16:56:58 +0100
Message-ID: <20081219155754.721970000@de.ibm.com>
References: <20081219155651.010878000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate5.de.ibm.com ([195.212.29.154]:51571 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185AbYLSP55 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Dec 2008 10:57:57 -0500
Content-Disposition: inline; filename=rscn-range.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Christof Schmitt <christof.schmitt@de.ibm.com>, Felix Beck <felix@linux.vnet.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

Use an array for looking up the mask corresponding to the 2-bit
information instead of the switch/case.

Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
Acked-by: Felix Beck <felix@linux.vnet.ibm.com>
---
 drivers/s390/scsi/zfcp_def.h |   14 --------------
 drivers/s390/scsi/zfcp_fc.c  |   31 +++++++++++++++----------------
 2 files changed, 15 insertions(+), 30 deletions(-)

--- a/drivers/s390/scsi/zfcp_def.h	2008-12-19 14:38:34.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_def.h	2008-12-19 14:38:37.000000000 +0100
@@ -158,20 +158,6 @@ struct fcp_rscn_element {
         u32 nport_did:24;
 } __attribute__((packed));
 
-#define ZFCP_PORT_ADDRESS   0x0
-#define ZFCP_AREA_ADDRESS   0x1
-#define ZFCP_DOMAIN_ADDRESS 0x2
-#define ZFCP_FABRIC_ADDRESS 0x3
-
-#define ZFCP_PORTS_RANGE_PORT   0xFFFFFF
-#define ZFCP_PORTS_RANGE_AREA   0xFFFF00
-#define ZFCP_PORTS_RANGE_DOMAIN 0xFF0000
-#define ZFCP_PORTS_RANGE_FABRIC 0x000000
-
-#define ZFCP_NO_PORTS_PER_AREA    0x100
-#define ZFCP_NO_PORTS_PER_DOMAIN  0x10000
-#define ZFCP_NO_PORTS_PER_FABRIC  0x1000000
-
 /* see fc-ph */
 struct fcp_logo {
         u32 command;
--- a/drivers/s390/scsi/zfcp_fc.c	2008-12-19 14:38:13.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_fc.c	2008-12-19 14:38:37.000000000 +0100
@@ -8,6 +8,20 @@
 
 #include "zfcp_ext.h"
 
+enum rscn_address_format {
+	RSCN_PORT_ADDRESS	= 0x0,
+	RSCN_AREA_ADDRESS	= 0x1,
+	RSCN_DOMAIN_ADDRESS	= 0x2,
+	RSCN_FABRIC_ADDRESS	= 0x3,
+};
+
+static u32 rscn_range_mask[] = {
+	[RSCN_PORT_ADDRESS]		= 0xFFFFFF,
+	[RSCN_AREA_ADDRESS]		= 0xFFFF00,
+	[RSCN_DOMAIN_ADDRESS]		= 0xFF0000,
+	[RSCN_FABRIC_ADDRESS]		= 0x000000,
+};
+
 struct ct_iu_gpn_ft_req {
 	struct ct_hdr header;
 	u8 flags;
@@ -157,22 +171,7 @@ static void zfcp_fc_incoming_rscn(struct
 	for (i = 1; i < no_entries; i++) {
 		/* skip head and start with 1st element */
 		fcp_rscn_element++;
-		switch (fcp_rscn_element->addr_format) {
-		case ZFCP_PORT_ADDRESS:
-			range_mask = ZFCP_PORTS_RANGE_PORT;
-			break;
-		case ZFCP_AREA_ADDRESS:
-			range_mask = ZFCP_PORTS_RANGE_AREA;
-			break;
-		case ZFCP_DOMAIN_ADDRESS:
-			range_mask = ZFCP_PORTS_RANGE_DOMAIN;
-			break;
-		case ZFCP_FABRIC_ADDRESS:
-			range_mask = ZFCP_PORTS_RANGE_FABRIC;
-			break;
-		default:
-			continue;
-		}
+		range_mask = rscn_range_mask[fcp_rscn_element->addr_format];
 		_zfcp_fc_incoming_rscn(fsf_req, range_mask, fcp_rscn_element);
 	}
 	schedule_work(&fsf_req->adapter->scan_work);

-- 

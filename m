From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 09/18] [PATCH] zfcp: remove undefined subtype for status read response
Date: Mon, 02 Mar 2009 13:09:02 +0100
Message-ID: <20090302121003.199903000@de.ibm.com>
References: <20090302120853.279447000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate1.de.ibm.com ([195.212.17.161]:51358 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758699AbZCBMKG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Mar 2009 07:10:06 -0500
Content-Disposition: inline; filename=708-zfcp-subtype.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Swen Schillig <swen@vnet.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Swen Schillig <swen@vnet.ibm.com>

The status read response FSF_STATUS_READ_SUB_ERROR_PORT is not
defined in the specs and therefore not valid. 
All occurrences are removed from the code.

Signed-off-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_dbf.c |    2 +-
 drivers/s390/scsi/zfcp_fsf.c |    9 +--------
 drivers/s390/scsi/zfcp_fsf.h |    4 ----
 3 files changed, 2 insertions(+), 13 deletions(-)

diff -urpN linux-2.6/drivers/s390/scsi/zfcp_dbf.c linux-2.6-patched/drivers/s390/scsi/zfcp_dbf.c
--- linux-2.6/drivers/s390/scsi/zfcp_dbf.c	2009-03-01 16:41:01.000000000 +0100
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_dbf.c	2009-03-01 16:41:32.000000000 +0100
@@ -615,7 +615,7 @@ static const char *zfcp_rec_dbf_ids[] = 
 	[119]	= "unknown protocol status",
 	[120]	= "unknown fsf command",
 	[121]	= "no recommendation for status qualifier",
-	[122]	= "status read physical port closed in error",
+	[122]	= "",
 	[123]	= "fc service class not supported",
 	[124]	= "",
 	[125]	= "need newer zfcp",
diff -urpN linux-2.6/drivers/s390/scsi/zfcp_fsf.c linux-2.6-patched/drivers/s390/scsi/zfcp_fsf.c
--- linux-2.6/drivers/s390/scsi/zfcp_fsf.c	2009-03-01 16:41:32.000000000 +0100
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_fsf.c	2009-03-01 16:41:32.000000000 +0100
@@ -162,14 +162,7 @@ static void zfcp_fsf_status_read_port_cl
 	list_for_each_entry(port, &adapter->port_list_head, list)
 		if (port->d_id == d_id) {
 			read_unlock_irqrestore(&zfcp_data.config_lock, flags);
-			switch (sr_buf->status_subtype) {
-			case FSF_STATUS_READ_SUB_CLOSE_PHYS_PORT:
-				zfcp_erp_port_reopen(port, 0, 101, req);
-				break;
-			case FSF_STATUS_READ_SUB_ERROR_PORT:
-				zfcp_erp_port_shutdown(port, 0, 122, req);
-				break;
-			}
+			zfcp_erp_port_reopen(port, 0, 101, req);
 			return;
 		}
 	read_unlock_irqrestore(&zfcp_data.config_lock, flags);
diff -urpN linux-2.6/drivers/s390/scsi/zfcp_fsf.h linux-2.6-patched/drivers/s390/scsi/zfcp_fsf.h
--- linux-2.6/drivers/s390/scsi/zfcp_fsf.h	2009-03-01 16:41:01.000000000 +0100
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_fsf.h	2009-03-01 16:41:32.000000000 +0100
@@ -127,10 +127,6 @@
 #define FSF_STATUS_READ_CFDC_UPDATED		0x0000000A
 #define FSF_STATUS_READ_FEATURE_UPDATE_ALERT	0x0000000C
 
-/* status subtypes in status read buffer */
-#define FSF_STATUS_READ_SUB_CLOSE_PHYS_PORT	0x00000001
-#define FSF_STATUS_READ_SUB_ERROR_PORT		0x00000002
-
 /* status subtypes for link down */
 #define FSF_STATUS_READ_SUB_NO_PHYSICAL_LINK	0x00000000
 #define FSF_STATUS_READ_SUB_FDISC_FAILED	0x00000001


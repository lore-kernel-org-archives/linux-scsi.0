From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 2/6] zfcp: Fix opening of wka ports
Date: Wed, 26 Nov 2008 18:07:36 +0100
Message-ID: <20081126171018.911338000@de.ibm.com>
References: <20081126170734.940419000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate1.de.ibm.com ([195.212.17.161]:46472 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752552AbYKZRKV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Nov 2008 12:10:21 -0500
Content-Disposition: inline; filename=fix.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Christof Schmitt <christof.schmitt@de.ibm.com>, Swen Schillig <swen@vnet.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

Running two wka_port_get calls in parallel could issue two open_port
requests, overwriting the port handle. Don't issue an open_port
for the state PORT_OPENING, and only read the data from GOOD
responses.

Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
Acked-by: Swen Schillig <swen@vnet.ibm.com>
---
 drivers/s390/scsi/zfcp_fc.c  |    3 ++-
 drivers/s390/scsi/zfcp_fsf.c |    1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/s390/scsi/zfcp_fc.c	2008-11-26 16:42:12.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_fc.c	2008-11-26 16:42:23.000000000 +0100
@@ -50,7 +50,8 @@ static int zfcp_wka_port_get(struct zfcp
 	if (mutex_lock_interruptible(&wka_port->mutex))
 		return -ERESTARTSYS;
 
-	if (wka_port->status != ZFCP_WKA_PORT_ONLINE) {
+	if (wka_port->status == ZFCP_WKA_PORT_OFFLINE ||
+	    wka_port->status == ZFCP_WKA_PORT_CLOSING) {
 		wka_port->status = ZFCP_WKA_PORT_OPENING;
 		if (zfcp_fsf_open_wka_port(wka_port))
 			wka_port->status = ZFCP_WKA_PORT_OFFLINE;
--- a/drivers/s390/scsi/zfcp_fsf.c	2008-11-26 16:17:53.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_fsf.c	2008-11-26 16:42:23.000000000 +0100
@@ -1584,6 +1584,7 @@ static void zfcp_fsf_open_wka_port_handl
 		wka_port->status = ZFCP_WKA_PORT_OFFLINE;
 		break;
 	case FSF_PORT_ALREADY_OPEN:
+		break;
 	case FSF_GOOD:
 		wka_port->handle = header->port_handle;
 		wka_port->status = ZFCP_WKA_PORT_ONLINE;

-- 

From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 12/13] zfcp: Fix wka port processing
Date: Mon, 13 Jul 2009 15:06:13 +0200
Message-ID: <20090713131044.264267000@de.ibm.com>
References: <20090713130601.304914000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate3.de.ibm.com ([195.212.29.152]:36212 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755848AbZGMNK4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Jul 2009 09:10:56 -0400
Content-Disposition: inline; filename=719-zfcp-racy-wka.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Swen Schillig <swen@vnet.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Swen Schillig <swen@vnet.ibm.com>

Under certain conditions it is possible that a WKA port ist not opened
within the expected timeframe of half a second. In this situation
the WKA port remains in the state OPENING preventing any succeding
request to open the port. This led to unrecoverable remote ports.
Fixing this by always setting an appropriate WKA port status before
leaving the function and removing the timeout value here since it's 
not needed here because the general timeout processing would deal
with it if required.

Signed-off-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_fc.c  |    8 +++-----
 drivers/s390/scsi/zfcp_fsf.c |    4 ++--
 2 files changed, 5 insertions(+), 7 deletions(-)

--- a/drivers/s390/scsi/zfcp_fc.c	2009-07-13 13:17:43.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_fc.c	2009-07-13 13:18:20.000000000 +0200
@@ -79,11 +79,9 @@ static int zfcp_wka_port_get(struct zfcp
 
 	mutex_unlock(&wka_port->mutex);
 
-	wait_event_timeout(
-		wka_port->completion_wq,
-		wka_port->status == ZFCP_WKA_PORT_ONLINE ||
-		wka_port->status == ZFCP_WKA_PORT_OFFLINE,
-		HZ >> 1);
+	wait_event(wka_port->completion_wq,
+		   wka_port->status == ZFCP_WKA_PORT_ONLINE ||
+		   wka_port->status == ZFCP_WKA_PORT_OFFLINE);
 
 	if (wka_port->status == ZFCP_WKA_PORT_ONLINE) {
 		atomic_inc(&wka_port->refcount);
--- a/drivers/s390/scsi/zfcp_fsf.c	2009-07-13 13:18:10.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_fsf.c	2009-07-13 13:18:20.000000000 +0200
@@ -1627,10 +1627,10 @@ static void zfcp_fsf_open_wka_port_handl
 	case FSF_ACCESS_DENIED:
 		wka_port->status = ZFCP_WKA_PORT_OFFLINE;
 		break;
-	case FSF_PORT_ALREADY_OPEN:
-		break;
 	case FSF_GOOD:
 		wka_port->handle = header->port_handle;
+		/* fall through */
+	case FSF_PORT_ALREADY_OPEN:
 		wka_port->status = ZFCP_WKA_PORT_ONLINE;
 	}
 out:


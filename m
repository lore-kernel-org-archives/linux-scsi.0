From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 13/15] zfcp: Fix port reference counting
Date: Fri, 17 Apr 2009 15:08:13 +0200
Message-ID: <20090417131123.529354000@de.ibm.com>
References: <20090417130800.923944000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate6.de.ibm.com ([195.212.29.155]:52960 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760934AbZDQNMP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Apr 2009 09:12:15 -0400
Content-Disposition: inline; filename=713-zfcp-port-refcounting.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Martin Petermann <martin.petermann@de.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Martin Petermann <martin.petermann@de.ibm.com>

If this problem appears zfcp ports cannot be de-queued since it is 
checked for a zero refcount. The port reference counting is wrong for
existing zfcp ports when e.g. an adapter gets on-line again. During 
port scanning the reference counting for existing ports should not be
changed.

Signed-off-by: Martin Petermann <martin.petermann@de.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_fc.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/s390/scsi/zfcp_fc.c	2009-04-17 15:03:46.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_fc.c	2009-04-17 15:03:54.000000000 +0200
@@ -539,6 +539,9 @@ static void zfcp_validate_port(struct zf
 {
 	struct zfcp_adapter *adapter = port->adapter;
 
+	if (!(atomic_read(&port->status) & ZFCP_STATUS_COMMON_NOESC))
+		return;
+
 	atomic_clear_mask(ZFCP_STATUS_COMMON_NOESC, &port->status);
 
 	if ((port->supported_classes != 0) ||
@@ -599,10 +602,8 @@ static int zfcp_scan_eval_gpn_ft(struct 
 		if (acc->wwpn == fc_host_port_name(adapter->scsi_host))
 			continue;
 		port = zfcp_get_port_by_wwpn(adapter, acc->wwpn);
-		if (port) {
-			zfcp_port_get(port);
+		if (port)
 			continue;
-		}
 
 		port = zfcp_port_enqueue(adapter, acc->wwpn,
 					 ZFCP_STATUS_COMMON_NOESC, d_id);


From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 01/13] zfcp: Fix invalid command order
Date: Mon, 13 Jul 2009 15:06:02 +0200
Message-ID: <20090713131042.748540000@de.ibm.com>
References: <20090713130601.304914000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate1.de.ibm.com ([195.212.17.161]:50284 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755816AbZGMNKo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Jul 2009 09:10:44 -0400
Content-Disposition: inline; filename=702-zfcp-invalid-order.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Swen Schillig <swen@vnet.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Swen Schillig <swen@vnet.ibm.com>

We should not modify the port status after triggering an ERP action
for the port. It is not guaranteed which status is finally active
when the ERP action is performed. This can lead to situations which
are unwanted and hard to debug in case of a failure.

Signed-off-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_fsf.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -urpN linux-2.6/drivers/s390/scsi/zfcp_fsf.c linux-2.6-patched/drivers/s390/scsi/zfcp_fsf.c
--- linux-2.6/drivers/s390/scsi/zfcp_fsf.c	2009-07-12 21:08:41.000000000 +0200
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_fsf.c	2009-07-12 21:08:56.000000000 +0200
@@ -1731,15 +1731,16 @@ static void zfcp_fsf_close_physical_port
 		zfcp_fsf_access_denied_port(req, port);
 		break;
 	case FSF_PORT_BOXED:
-		zfcp_erp_port_boxed(port, "fscpph2", req);
-		req->status |= ZFCP_STATUS_FSFREQ_ERROR |
-			       ZFCP_STATUS_FSFREQ_RETRY;
 		/* can't use generic zfcp_erp_modify_port_status because
 		 * ZFCP_STATUS_COMMON_OPEN must not be reset for the port */
 		atomic_clear_mask(ZFCP_STATUS_PORT_PHYS_OPEN, &port->status);
 		list_for_each_entry(unit, &port->unit_list_head, list)
 			atomic_clear_mask(ZFCP_STATUS_COMMON_OPEN,
 					  &unit->status);
+		zfcp_erp_port_boxed(port, "fscpph2", req);
+		req->status |= ZFCP_STATUS_FSFREQ_ERROR |
+			       ZFCP_STATUS_FSFREQ_RETRY;
+
 		break;
 	case FSF_ADAPTER_STATUS_AVAILABLE:
 		switch (header->fsf_status_qual.word[0]) {


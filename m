From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 14/18] [PATCH] zfcp: incorrect reaction on incoming RSCN
Date: Mon, 02 Mar 2009 13:09:07 +0100
Message-ID: <20090302121003.909240000@de.ibm.com>
References: <20090302120853.279447000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate6.de.ibm.com ([195.212.29.155]:54194 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753419AbZCBMLE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Mar 2009 07:11:04 -0500
Content-Disposition: inline; filename=715-zfcp-incoming-rscn.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Swen Schillig <swen@vnet.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Swen Schillig <swen@vnet.ibm.com>

After an error condition resolved a remote storage port was never
re-opened. The incoming RSCN was not processed accordingly due
to a misinterpreted status flag / return value combination.

Signed-off-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_fc.c  |   18 +++++++-----------
 drivers/s390/scsi/zfcp_fsf.c |    4 ----
 2 files changed, 7 insertions(+), 15 deletions(-)

diff -urpN linux-2.6/drivers/s390/scsi/zfcp_fc.c linux-2.6-patched/drivers/s390/scsi/zfcp_fc.c
--- linux-2.6/drivers/s390/scsi/zfcp_fc.c	2009-03-01 16:41:34.000000000 +0100
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_fc.c	2009-03-01 16:41:35.000000000 +0100
@@ -145,16 +145,10 @@ static void _zfcp_fc_incoming_rscn(struc
 	struct zfcp_port *port;
 
 	read_lock_irqsave(&zfcp_data.config_lock, flags);
-	list_for_each_entry(port, &fsf_req->adapter->port_list_head, list) {
-		if (!(atomic_read(&port->status) & ZFCP_STATUS_PORT_PHYS_OPEN))
-			/* Try to connect to unused ports anyway. */
-			zfcp_erp_port_reopen(port,
-					     ZFCP_STATUS_COMMON_ERP_FAILED,
-					     "fcirsc1", fsf_req);
-		else if ((port->d_id & range) == (elem->nport_did & range))
-			/* Check connection status for connected ports */
+	list_for_each_entry(port, &fsf_req->adapter->port_list_head, list)
+		if ((port->d_id & range) == (elem->nport_did & range))
 			zfcp_test_link(port);
-	}
+
 	read_unlock_irqrestore(&zfcp_data.config_lock, flags);
 }
 
@@ -381,8 +375,10 @@ static void zfcp_fc_adisc_handler(unsign
 	if (!port->wwnn)
 		port->wwnn = ls_adisc->wwnn;
 
-	if (port->wwpn != ls_adisc->wwpn)
-		zfcp_erp_port_reopen(port, 0, "fcadh_2", NULL);
+	if ((port->wwpn != ls_adisc->wwpn) ||
+	    !(atomic_read(&port->status) & ZFCP_STATUS_COMMON_OPEN))
+		zfcp_erp_port_reopen(port, ZFCP_STATUS_COMMON_ERP_FAILED,
+				     "fcadh_2", NULL);
 
  out:
 	zfcp_port_put(port);
diff -urpN linux-2.6/drivers/s390/scsi/zfcp_fsf.c linux-2.6-patched/drivers/s390/scsi/zfcp_fsf.c
--- linux-2.6/drivers/s390/scsi/zfcp_fsf.c	2009-03-01 16:41:35.000000000 +0100
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_fsf.c	2009-03-01 16:41:35.000000000 +0100
@@ -1162,10 +1162,6 @@ int zfcp_fsf_send_els(struct zfcp_send_e
 	struct fsf_qtcb_bottom_support *bottom;
 	int ret = -EIO;
 
-	if (unlikely(!(atomic_read(&els->port->status) &
-		       ZFCP_STATUS_COMMON_UNBLOCKED)))
-		return -EBUSY;
-
 	spin_lock_bh(&adapter->req_q_lock);
 	if (zfcp_fsf_req_sbal_get(adapter))
 		goto out;


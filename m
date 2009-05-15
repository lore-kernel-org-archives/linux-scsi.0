From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 7/9] zfcp: Changed D_ID left port disabled
Date: Fri, 15 May 2009 13:18:20 +0200
Message-ID: <20090515112222.172819000@de.ibm.com>
References: <20090515111813.314177000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate5.de.ibm.com ([195.212.29.154]:62638 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754871AbZEOLWW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 15 May 2009 07:22:22 -0400
Content-Disposition: inline; filename=706-zfcp-changed-D_ID.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Swen Schillig <swen@vnet.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Swen Schillig <swen@vnet.ibm.com>

If the destination ID (D_ID) of a remote storage port changed, e.g.
re-plugged cable on the switch in a different switch port, the port
was never (re-)attached within Linux. This patch fixes the broken
mapping between the WWPN and the D_ID.

Signed-off-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_erp.c |    7 ++++++-
 drivers/s390/scsi/zfcp_fc.c  |    7 ++++++-
 2 files changed, 12 insertions(+), 2 deletions(-)

--- a/drivers/s390/scsi/zfcp_erp.c	2009-05-15 12:56:17.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_erp.c	2009-05-15 12:56:21.000000000 +0200
@@ -895,8 +895,13 @@ static int zfcp_erp_port_strategy_open_c
 				act->step = ZFCP_ERP_STEP_PORT_CLOSING;
 				return ZFCP_ERP_CONTINUES;
 			}
-		/* fall through otherwise */
 		}
+		if (port->d_id && !(p_status & ZFCP_STATUS_COMMON_NOESC)) {
+			port->d_id = 0;
+			_zfcp_erp_port_reopen(port, 0, "erpsoc1", NULL);
+			return ZFCP_ERP_EXIT;
+		}
+		/* fall through otherwise */
 	}
 	return ZFCP_ERP_FAILED;
 }
--- a/drivers/s390/scsi/zfcp_fc.c	2009-05-15 12:56:02.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_fc.c	2009-05-15 12:56:21.000000000 +0200
@@ -160,9 +160,14 @@ static void _zfcp_fc_incoming_rscn(struc
 	struct zfcp_port *port;
 
 	read_lock_irqsave(&zfcp_data.config_lock, flags);
-	list_for_each_entry(port, &fsf_req->adapter->port_list_head, list)
+	list_for_each_entry(port, &fsf_req->adapter->port_list_head, list) {
 		if ((port->d_id & range) == (elem->nport_did & range))
 			zfcp_test_link(port);
+		if (!port->d_id)
+			zfcp_erp_port_reopen(port,
+					     ZFCP_STATUS_COMMON_ERP_FAILED,
+					     "fcrscn1", NULL);
+	}
 
 	read_unlock_irqrestore(&zfcp_data.config_lock, flags);
 }


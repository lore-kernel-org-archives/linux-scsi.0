From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [updated patch (fix comment)][patch 2/5] zfcp: Handle WWPN
	mismatch in PLOGI payload
Date: Wed, 14 Oct 2009 11:00:43 +0200
Message-ID: <20091014090043.GB3874@schmichrtp.de.ibm.com>
References: <20091013084406.630890000@de.ibm.com> <20091013084944.777367000@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate5.uk.ibm.com ([195.212.29.138]:48589 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755955AbZJNJCf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Oct 2009 05:02:35 -0400
Content-Disposition: inline
In-Reply-To: <20091013084944.777367000@de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com

From: Christof Schmitt <christof.schmitt@de.ibm.com>

For ports, zfcp gets the DID from the FC nameserver and tries to open
the port. If the open succeeds, zfcp compares the WWPN from the
nameserver with the WWPN in the PLOGI payload. In case of a mismatch,
zfcp assumes that the DID of the port just changed and we opened the
wrong port. This means that zfcp has to forget the DID, lookup the DID
again and retry.

This error case had a problem that zfcp forgets the DID, but never
looks up a new one, stalling the ERP in this case. Fix this by
triggering the DID lookup and properly exit from the ERP. The DID
lookup will trigger a new ERP action.

Also ensure when trying to open the port again with the new DID, first
close the open port, even in the NOESC case.

Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_erp.c |   22 ++++++++++------------
 drivers/s390/scsi/zfcp_ext.h |    1 +
 drivers/s390/scsi/zfcp_fc.c  |   11 +++++++++++
 3 files changed, 22 insertions(+), 12 deletions(-)

diff -urpN linux-2.6/drivers/s390/scsi/zfcp_erp.c linux-2.6-patched/drivers/s390/scsi/zfcp_erp.c
--- linux-2.6/drivers/s390/scsi/zfcp_erp.c	2009-10-14 10:41:56.000000000 +0200
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_erp.c	2009-10-14 10:42:20.000000000 +0200
@@ -858,10 +858,7 @@ static int zfcp_erp_port_strategy_open_c
 		if (fc_host_port_type(adapter->scsi_host) == FC_PORTTYPE_PTP)
 			return zfcp_erp_open_ptp_port(act);
 		if (!port->d_id) {
-			zfcp_port_get(port);
-			if (!queue_work(adapter->work_queue,
-					&port->gid_pn_work))
-				zfcp_port_put(port);
+			zfcp_fc_trigger_did_lookup(port);
 			return ZFCP_ERP_EXIT;
 		}
 		return zfcp_erp_port_strategy_open_port(act);
@@ -869,12 +866,11 @@ static int zfcp_erp_port_strategy_open_c
 	case ZFCP_ERP_STEP_PORT_OPENING:
 		/* D_ID might have changed during open */
 		if (p_status & ZFCP_STATUS_COMMON_OPEN) {
-			if (port->d_id)
-				return ZFCP_ERP_SUCCEEDED;
-			else {
-				act->step = ZFCP_ERP_STEP_PORT_CLOSING;
-				return ZFCP_ERP_CONTINUES;
+			if (!port->d_id) {
+				zfcp_fc_trigger_did_lookup(port);
+				return ZFCP_ERP_EXIT;
 			}
+			return ZFCP_ERP_SUCCEEDED;
 		}
 		if (port->d_id && !(p_status & ZFCP_STATUS_COMMON_NOESC)) {
 			port->d_id = 0;
@@ -889,19 +885,21 @@ static int zfcp_erp_port_strategy_open_c
 static int zfcp_erp_port_strategy(struct zfcp_erp_action *erp_action)
 {
 	struct zfcp_port *port = erp_action->port;
+	int p_status = atomic_read(&port->status);
 
-	if (atomic_read(&port->status) & ZFCP_STATUS_COMMON_NOESC)
+	if ((p_status & ZFCP_STATUS_COMMON_NOESC) &&
+	    !(p_status & ZFCP_STATUS_COMMON_OPEN))
 		goto close_init_done;
 
 	switch (erp_action->step) {
 	case ZFCP_ERP_STEP_UNINITIALIZED:
 		zfcp_erp_port_strategy_clearstati(port);
-		if (atomic_read(&port->status) & ZFCP_STATUS_COMMON_OPEN)
+		if (p_status & ZFCP_STATUS_COMMON_OPEN)
 			return zfcp_erp_port_strategy_close(erp_action);
 		break;
 
 	case ZFCP_ERP_STEP_PORT_CLOSING:
-		if (atomic_read(&port->status) & ZFCP_STATUS_COMMON_OPEN)
+		if (p_status & ZFCP_STATUS_COMMON_OPEN)
 			return ZFCP_ERP_FAILED;
 		break;
 	}
diff -urpN linux-2.6/drivers/s390/scsi/zfcp_ext.h linux-2.6-patched/drivers/s390/scsi/zfcp_ext.h
--- linux-2.6/drivers/s390/scsi/zfcp_ext.h	2009-10-14 10:41:56.000000000 +0200
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_ext.h	2009-10-14 10:42:20.000000000 +0200
@@ -96,6 +96,7 @@ extern int zfcp_fc_scan_ports(struct zfc
 extern void _zfcp_fc_scan_ports_later(struct work_struct *);
 extern void zfcp_fc_incoming_els(struct zfcp_fsf_req *);
 extern void zfcp_fc_port_did_lookup(struct work_struct *);
+extern void zfcp_fc_trigger_did_lookup(struct zfcp_port *);
 extern void zfcp_fc_plogi_evaluate(struct zfcp_port *, struct fsf_plogi *);
 extern void zfcp_fc_test_link(struct zfcp_port *);
 extern void zfcp_fc_link_test_work(struct work_struct *);
diff -urpN linux-2.6/drivers/s390/scsi/zfcp_fc.c linux-2.6-patched/drivers/s390/scsi/zfcp_fc.c
--- linux-2.6/drivers/s390/scsi/zfcp_fc.c	2009-10-14 10:41:56.000000000 +0200
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_fc.c	2009-10-14 10:42:20.000000000 +0200
@@ -361,6 +361,17 @@ out:
 }
 
 /**
+ * zfcp_fc_trigger_did_lookup - trigger the d_id lookup using a GID_PN request
+ * @port: The zfcp_port to lookup the d_id for.
+ */
+void zfcp_fc_trigger_did_lookup(struct zfcp_port *port)
+{
+	zfcp_port_get(port);
+	if (!queue_work(port->adapter->work_queue, &port->gid_pn_work))
+		zfcp_port_put(port);
+}
+
+/**
  * zfcp_fc_plogi_evaluate - evaluate PLOGI playload
  * @port: zfcp_port structure
  * @plogi: plogi payload

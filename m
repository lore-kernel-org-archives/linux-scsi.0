From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 17/18] [PATCH] zfcp: fix queue, scheduled work processing.
Date: Mon, 02 Mar 2009 13:09:10 +0100
Message-ID: <20090302121004.310028000@de.ibm.com>
References: <20090302120853.279447000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate5.de.ibm.com ([195.212.29.154]:63529 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754141AbZCBMKt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Mar 2009 07:10:49 -0500
Content-Disposition: inline; filename=718-zfcp-fix-queue.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Swen Schillig <swen@vnet.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Swen Schillig <swen@vnet.ibm.com>

Ensure the refcounting is correct even if we were not able to
schedule a work. In addition we have to make sure no scheduled
work is pending while we're dequeing the adapter from the
systems environment.

Signed-off-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_aux.c |    1 +
 drivers/s390/scsi/zfcp_erp.c |   10 +++++++---
 2 files changed, 8 insertions(+), 3 deletions(-)

diff -urpN linux-2.6/drivers/s390/scsi/zfcp_aux.c linux-2.6-patched/drivers/s390/scsi/zfcp_aux.c
--- linux-2.6/drivers/s390/scsi/zfcp_aux.c	2009-03-01 16:41:36.000000000 +0100
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_aux.c	2009-03-01 16:41:36.000000000 +0100
@@ -554,6 +554,7 @@ void zfcp_adapter_dequeue(struct zfcp_ad
 
 	cancel_work_sync(&adapter->scan_work);
 	cancel_work_sync(&adapter->stat_work);
+	cancel_delayed_work_sync(&adapter->nsp.work);
 	zfcp_adapter_scsi_unregister(adapter);
 	sysfs_remove_group(&adapter->ccw_device->dev.kobj,
 			   &zfcp_sysfs_adapter_attrs);
diff -urpN linux-2.6/drivers/s390/scsi/zfcp_erp.c linux-2.6-patched/drivers/s390/scsi/zfcp_erp.c
--- linux-2.6/drivers/s390/scsi/zfcp_erp.c	2009-03-01 16:41:36.000000000 +0100
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_erp.c	2009-03-01 16:41:36.000000000 +0100
@@ -857,7 +857,7 @@ void zfcp_erp_port_strategy_open_lookup(
 	port->erp_action.step = ZFCP_ERP_STEP_NAMESERVER_LOOKUP;
 	if (retval)
 		zfcp_erp_notify(&port->erp_action, ZFCP_ERP_FAILED);
-
+	zfcp_port_put(port);
 }
 
 static int zfcp_erp_port_strategy_open_common(struct zfcp_erp_action *act)
@@ -873,7 +873,10 @@ static int zfcp_erp_port_strategy_open_c
 		if (fc_host_port_type(adapter->scsi_host) == FC_PORTTYPE_PTP)
 			return zfcp_erp_open_ptp_port(act);
 		if (!port->d_id) {
-			queue_work(zfcp_data.work_queue, &port->gid_pn_work);
+			zfcp_port_get(port);
+			if (!queue_work(zfcp_data.work_queue,
+					&port->gid_pn_work))
+				zfcp_port_put(port);
 			return ZFCP_ERP_CONTINUES;
 		}
 	case ZFCP_ERP_STEP_NAMESERVER_LOOKUP:
@@ -1211,7 +1214,8 @@ static void zfcp_erp_schedule_work(struc
 	atomic_set_mask(ZFCP_STATUS_UNIT_SCSI_WORK_PENDING, &unit->status);
 	INIT_WORK(&p->work, zfcp_erp_scsi_scan);
 	p->unit = unit;
-	queue_work(zfcp_data.work_queue, &p->work);
+	if (!queue_work(zfcp_data.work_queue, &p->work))
+		zfcp_unit_put(unit);
 }
 
 static void zfcp_erp_action_cleanup(struct zfcp_erp_action *act, int result)


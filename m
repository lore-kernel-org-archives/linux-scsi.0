From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 09/13] zfcp: deadlock via shared work queue tasks
Date: Wed, 01 Oct 2008 12:42:22 +0200
Message-ID: <20081001104803.099733000@de.ibm.com>
References: <20081001104213.585200000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate8.de.ibm.com ([195.212.29.157]:36001 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752476AbYJAKsg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Oct 2008 06:48:36 -0400
Content-Disposition: inline; filename=zfcp_workqueue_race.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Swen Schillig <swen@vnet.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Swen Schillig <swen@vnet.ibm.com>

Each adapter reopen trigger automatically a scan_port task which
is waiting for the ERP to be finished before further processing.
Since the initial device setup enqueues adapter, port and LUN which
are individual ERP actions, this process would start after 
everything is done. Unfortunately the port_reopen requires another
scheduled work to be finished which is queued after the automatic
scan_port -> deadlock !

This fix creates an own work queue for ERP based nameserver requests.

Signed-off-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---
 drivers/s390/scsi/zfcp_aux.c |    2 ++
 drivers/s390/scsi/zfcp_def.h |    1 +
 drivers/s390/scsi/zfcp_erp.c |    4 ++--
 drivers/s390/scsi/zfcp_fsf.c |    2 +-
 4 files changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/s390/scsi/zfcp_aux.c	2008-10-01 11:09:06.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_aux.c	2008-10-01 11:09:57.000000000 +0200
@@ -168,6 +168,8 @@ static int __init zfcp_module_init(void)
 	if (!zfcp_data.gid_pn_cache)
 		goto out_gid_cache;
 
+	zfcp_data.work_queue = create_singlethread_workqueue("zfcp_wq");
+
 	INIT_LIST_HEAD(&zfcp_data.adapter_list_head);
 	sema_init(&zfcp_data.config_sema, 1);
 	rwlock_init(&zfcp_data.config_lock);
--- a/drivers/s390/scsi/zfcp_def.h	2008-10-01 11:09:06.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_def.h	2008-10-01 11:09:57.000000000 +0200
@@ -602,6 +602,7 @@ struct zfcp_data {
 	struct kmem_cache	*fsf_req_qtcb_cache;
 	struct kmem_cache	*sr_buffer_cache;
 	struct kmem_cache	*gid_pn_cache;
+	struct workqueue_struct	*work_queue;
 };
 
 /* struct used by memory pools for fsf_requests */
--- a/drivers/s390/scsi/zfcp_erp.c	2008-10-01 11:09:06.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_erp.c	2008-10-01 11:09:57.000000000 +0200
@@ -869,7 +869,7 @@ static int zfcp_erp_port_strategy_open_c
 		if (fc_host_port_type(adapter->scsi_host) == FC_PORTTYPE_PTP)
 			return zfcp_erp_open_ptp_port(act);
 		if (!(p_status & ZFCP_STATUS_PORT_DID_DID)) {
-			schedule_work(&port->gid_pn_work);
+			queue_work(zfcp_data.work_queue, &port->gid_pn_work);
 			return ZFCP_ERP_CONTINUES;
 		}
 	case ZFCP_ERP_STEP_NAMESERVER_LOOKUP:
@@ -1209,7 +1209,7 @@ static void zfcp_erp_schedule_work(struc
 	atomic_set_mask(ZFCP_STATUS_UNIT_SCSI_WORK_PENDING, &unit->status);
 	INIT_WORK(&p->work, zfcp_erp_scsi_scan);
 	p->unit = unit;
-	schedule_work(&p->work);
+	queue_work(zfcp_data.work_queue, &p->work);
 }
 
 static void zfcp_erp_rport_register(struct zfcp_port *port)
--- a/drivers/s390/scsi/zfcp_fsf.c	2008-10-01 11:09:31.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_fsf.c	2008-10-01 11:09:57.000000000 +0200
@@ -329,7 +329,7 @@ static void zfcp_fsf_status_read_handler
 	zfcp_fsf_req_free(req);
 
 	atomic_inc(&adapter->stat_miss);
-	schedule_work(&adapter->stat_work);
+	queue_work(zfcp_data.work_queue, &adapter->stat_work);
 }
 
 static void zfcp_fsf_fsfstatus_qual_eval(struct zfcp_fsf_req *req)

-- 

From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 01/11] zfcp: Remove function zfcp_reqlist_find_safe
Date: Wed, 17 Feb 2010 11:18:49 +0100
Message-ID: <20100217102018.026978000@de.ibm.com>
References: <20100217101848.662299000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate5.de.ibm.com ([195.212.17.165]:46617 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751791Ab0BQKUW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Feb 2010 05:20:22 -0500
Content-Disposition: inline; filename=700-zfcp-remove-fn.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

Always use the FSF request id as a reference to the FSF request. With
this change the function zfcp_reqlist_find_safe is no longer needed
and can be removed.

Reviewed-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_dbf.c |    2 +-
 drivers/s390/scsi/zfcp_def.h |   17 +----------------
 drivers/s390/scsi/zfcp_erp.c |   17 +++++++++--------
 drivers/s390/scsi/zfcp_fsf.c |   34 ++++++++++++++++++----------------
 4 files changed, 29 insertions(+), 41 deletions(-)

diff -urpN linux-2.6/drivers/s390/scsi/zfcp_dbf.c linux-2.6-patched/drivers/s390/scsi/zfcp_dbf.c
--- linux-2.6/drivers/s390/scsi/zfcp_dbf.c	2010-02-16 09:43:05.000000000 +0100
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_dbf.c	2010-02-16 09:43:28.000000000 +0100
@@ -668,7 +668,7 @@ void zfcp_dbf_rec_action(char *id2, stru
 	r->u.action.action = (unsigned long)erp_action;
 	r->u.action.status = erp_action->status;
 	r->u.action.step = erp_action->step;
-	r->u.action.fsf_req = (unsigned long)erp_action->fsf_req;
+	r->u.action.fsf_req = erp_action->fsf_req_id;
 	debug_event(dbf->rec, 5, r, sizeof(*r));
 	spin_unlock_irqrestore(&dbf->rec_lock, flags);
 }
diff -urpN linux-2.6/drivers/s390/scsi/zfcp_def.h linux-2.6-patched/drivers/s390/scsi/zfcp_def.h
--- linux-2.6/drivers/s390/scsi/zfcp_def.h	2010-02-16 09:43:05.000000000 +0100
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_def.h	2010-02-16 09:43:28.000000000 +0100
@@ -143,8 +143,7 @@ struct zfcp_erp_action {
 	struct zfcp_unit *unit;
 	u32		status;	      /* recovery status */
 	u32 step;	              /* active step of this erp action */
-	struct zfcp_fsf_req *fsf_req; /* fsf request currently pending
-					 for this action */
+	unsigned long		fsf_req_id;
 	struct timer_list timer;
 };
 
@@ -379,18 +378,4 @@ zfcp_reqlist_find(struct zfcp_adapter *a
 	return NULL;
 }
 
-static inline struct zfcp_fsf_req *
-zfcp_reqlist_find_safe(struct zfcp_adapter *adapter, struct zfcp_fsf_req *req)
-{
-	struct zfcp_fsf_req *request;
-	unsigned int idx;
-
-	for (idx = 0; idx < REQUEST_LIST_SIZE; idx++) {
-		list_for_each_entry(request, &adapter->req_list[idx], list)
-			if (request == req)
-				return request;
-	}
-	return NULL;
-}
-
 #endif /* ZFCP_DEF_H */
diff -urpN linux-2.6/drivers/s390/scsi/zfcp_erp.c linux-2.6-patched/drivers/s390/scsi/zfcp_erp.c
--- linux-2.6/drivers/s390/scsi/zfcp_erp.c	2010-02-16 09:43:05.000000000 +0100
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_erp.c	2010-02-16 09:43:28.000000000 +0100
@@ -478,25 +478,26 @@ static void zfcp_erp_action_to_running(s
 static void zfcp_erp_strategy_check_fsfreq(struct zfcp_erp_action *act)
 {
 	struct zfcp_adapter *adapter = act->adapter;
+	struct zfcp_fsf_req *req;
 
-	if (!act->fsf_req)
+	if (!act->fsf_req_id)
 		return;
 
 	spin_lock(&adapter->req_list_lock);
-	if (zfcp_reqlist_find_safe(adapter, act->fsf_req) &&
-	    act->fsf_req->erp_action == act) {
+	req = zfcp_reqlist_find(adapter, act->fsf_req_id);
+	if (req && req->erp_action == act) {
 		if (act->status & (ZFCP_STATUS_ERP_DISMISSED |
 				   ZFCP_STATUS_ERP_TIMEDOUT)) {
-			act->fsf_req->status |= ZFCP_STATUS_FSFREQ_DISMISSED;
+			req->status |= ZFCP_STATUS_FSFREQ_DISMISSED;
 			zfcp_dbf_rec_action("erscf_1", act);
-			act->fsf_req->erp_action = NULL;
+			req->erp_action = NULL;
 		}
 		if (act->status & ZFCP_STATUS_ERP_TIMEDOUT)
 			zfcp_dbf_rec_action("erscf_2", act);
-		if (act->fsf_req->status & ZFCP_STATUS_FSFREQ_DISMISSED)
-			act->fsf_req = NULL;
+		if (req->status & ZFCP_STATUS_FSFREQ_DISMISSED)
+			act->fsf_req_id = 0;
 	} else
-		act->fsf_req = NULL;
+		act->fsf_req_id = 0;
 	spin_unlock(&adapter->req_list_lock);
 }
 
diff -urpN linux-2.6/drivers/s390/scsi/zfcp_fsf.c linux-2.6-patched/drivers/s390/scsi/zfcp_fsf.c
--- linux-2.6/drivers/s390/scsi/zfcp_fsf.c	2010-02-16 09:43:05.000000000 +0100
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_fsf.c	2010-02-16 09:43:28.000000000 +0100
@@ -773,10 +773,11 @@ static int zfcp_fsf_req_send(struct zfcp
 	unsigned long	     flags;
 	int		     idx;
 	int		     with_qtcb = (req->qtcb != NULL);
+	int req_id = req->req_id;
 
 	/* put allocated FSF request into hash table */
 	spin_lock_irqsave(&adapter->req_list_lock, flags);
-	idx = zfcp_reqlist_hash(req->req_id);
+	idx = zfcp_reqlist_hash(req_id);
 	list_add_tail(&req->list, &adapter->req_list[idx]);
 	spin_unlock_irqrestore(&adapter->req_list_lock, flags);
 
@@ -786,7 +787,8 @@ static int zfcp_fsf_req_send(struct zfcp
 		del_timer(&req->timer);
 		spin_lock_irqsave(&adapter->req_list_lock, flags);
 		/* lookup request again, list might have changed */
-		if (zfcp_reqlist_find_safe(adapter, req))
+		req = zfcp_reqlist_find(adapter, req_id);
+		if (req)
 			zfcp_reqlist_remove(adapter, req);
 		spin_unlock_irqrestore(&adapter->req_list_lock, flags);
 		zfcp_erp_adapter_reopen(adapter, 0, "fsrs__1", req);
@@ -1262,13 +1264,13 @@ int zfcp_fsf_exchange_config_data(struct
 			FSF_FEATURE_UPDATE_ALERT;
 	req->erp_action = erp_action;
 	req->handler = zfcp_fsf_exchange_config_data_handler;
-	erp_action->fsf_req = req;
+	erp_action->fsf_req_id = req->req_id;
 
 	zfcp_fsf_start_erp_timer(req);
 	retval = zfcp_fsf_req_send(req);
 	if (retval) {
 		zfcp_fsf_req_free(req);
-		erp_action->fsf_req = NULL;
+		erp_action->fsf_req_id = 0;
 	}
 out:
 	spin_unlock_bh(&qdio->req_q_lock);
@@ -1355,13 +1357,13 @@ int zfcp_fsf_exchange_port_data(struct z
 
 	req->handler = zfcp_fsf_exchange_port_data_handler;
 	req->erp_action = erp_action;
-	erp_action->fsf_req = req;
+	erp_action->fsf_req_id = req->req_id;
 
 	zfcp_fsf_start_erp_timer(req);
 	retval = zfcp_fsf_req_send(req);
 	if (retval) {
 		zfcp_fsf_req_free(req);
-		erp_action->fsf_req = NULL;
+		erp_action->fsf_req_id = 0;
 	}
 out:
 	spin_unlock_bh(&qdio->req_q_lock);
@@ -1521,14 +1523,14 @@ int zfcp_fsf_open_port(struct zfcp_erp_a
 	hton24(req->qtcb->bottom.support.d_id, port->d_id);
 	req->data = port;
 	req->erp_action = erp_action;
-	erp_action->fsf_req = req;
+	erp_action->fsf_req_id = req->req_id;
 	get_device(&port->sysfs_device);
 
 	zfcp_fsf_start_erp_timer(req);
 	retval = zfcp_fsf_req_send(req);
 	if (retval) {
 		zfcp_fsf_req_free(req);
-		erp_action->fsf_req = NULL;
+		erp_action->fsf_req_id = 0;
 		put_device(&port->sysfs_device);
 	}
 out:
@@ -1591,13 +1593,13 @@ int zfcp_fsf_close_port(struct zfcp_erp_
 	req->data = erp_action->port;
 	req->erp_action = erp_action;
 	req->qtcb->header.port_handle = erp_action->port->handle;
-	erp_action->fsf_req = req;
+	erp_action->fsf_req_id = req->req_id;
 
 	zfcp_fsf_start_erp_timer(req);
 	retval = zfcp_fsf_req_send(req);
 	if (retval) {
 		zfcp_fsf_req_free(req);
-		erp_action->fsf_req = NULL;
+		erp_action->fsf_req_id = 0;
 	}
 out:
 	spin_unlock_bh(&qdio->req_q_lock);
@@ -1817,13 +1819,13 @@ int zfcp_fsf_close_physical_port(struct 
 	req->qtcb->header.port_handle = erp_action->port->handle;
 	req->erp_action = erp_action;
 	req->handler = zfcp_fsf_close_physical_port_handler;
-	erp_action->fsf_req = req;
+	erp_action->fsf_req_id = req->req_id;
 
 	zfcp_fsf_start_erp_timer(req);
 	retval = zfcp_fsf_req_send(req);
 	if (retval) {
 		zfcp_fsf_req_free(req);
-		erp_action->fsf_req = NULL;
+		erp_action->fsf_req_id = 0;
 	}
 out:
 	spin_unlock_bh(&qdio->req_q_lock);
@@ -1991,7 +1993,7 @@ int zfcp_fsf_open_unit(struct zfcp_erp_a
 	req->handler = zfcp_fsf_open_unit_handler;
 	req->data = erp_action->unit;
 	req->erp_action = erp_action;
-	erp_action->fsf_req = req;
+	erp_action->fsf_req_id = req->req_id;
 
 	if (!(adapter->connection_features & FSF_FEATURE_NPIV_MODE))
 		req->qtcb->bottom.support.option = FSF_OPEN_LUN_SUPPRESS_BOXING;
@@ -2000,7 +2002,7 @@ int zfcp_fsf_open_unit(struct zfcp_erp_a
 	retval = zfcp_fsf_req_send(req);
 	if (retval) {
 		zfcp_fsf_req_free(req);
-		erp_action->fsf_req = NULL;
+		erp_action->fsf_req_id = 0;
 	}
 out:
 	spin_unlock_bh(&qdio->req_q_lock);
@@ -2077,13 +2079,13 @@ int zfcp_fsf_close_unit(struct zfcp_erp_
 	req->handler = zfcp_fsf_close_unit_handler;
 	req->data = erp_action->unit;
 	req->erp_action = erp_action;
-	erp_action->fsf_req = req;
+	erp_action->fsf_req_id = req->req_id;
 
 	zfcp_fsf_start_erp_timer(req);
 	retval = zfcp_fsf_req_send(req);
 	if (retval) {
 		zfcp_fsf_req_free(req);
-		erp_action->fsf_req = NULL;
+		erp_action->fsf_req_id = 0;
 	}
 out:
 	spin_unlock_bh(&qdio->req_q_lock);


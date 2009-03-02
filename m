From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 18/18] [PATCH] zfcp: Ensure all work is cancelled on adapter dequeue
Date: Mon, 02 Mar 2009 13:09:11 +0100
Message-ID: <20090302121004.450268000@de.ibm.com>
References: <20090302120853.279447000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate3.de.ibm.com ([195.212.29.152]:34923 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758757AbZCBMKI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Mar 2009 07:10:08 -0500
Content-Disposition: inline; filename=719-zfcp-work-cancel.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Swen Schillig <swen@vnet.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Swen Schillig <swen@vnet.ibm.com>

A scheduled work might still be pending, running while the adapter is
in progress to get dequeued from the system. This can lead to an 
invalid pointer dereference (Oops).  Once the adpater is set online
again, ensure the nameserver environment is initialized to the
appropriate values again.

Signed-off-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_aux.c |    1 -
 drivers/s390/scsi/zfcp_ccw.c |    3 ++-
 drivers/s390/scsi/zfcp_fc.c  |    8 ++++++--
 3 files changed, 8 insertions(+), 4 deletions(-)

diff -urpN linux-2.6/drivers/s390/scsi/zfcp_aux.c linux-2.6-patched/drivers/s390/scsi/zfcp_aux.c
--- linux-2.6/drivers/s390/scsi/zfcp_aux.c	2009-03-01 16:41:37.000000000 +0100
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_aux.c	2009-03-01 16:41:37.000000000 +0100
@@ -524,7 +524,6 @@ int zfcp_adapter_enqueue(struct ccw_devi
 		goto sysfs_failed;
 
 	atomic_clear_mask(ZFCP_STATUS_COMMON_REMOVE, &adapter->status);
-	zfcp_fc_nameserver_init(adapter);
 
 	if (!zfcp_adapter_scsi_register(adapter))
 		return 0;
diff -urpN linux-2.6/drivers/s390/scsi/zfcp_ccw.c linux-2.6-patched/drivers/s390/scsi/zfcp_ccw.c
--- linux-2.6/drivers/s390/scsi/zfcp_ccw.c	2009-03-01 16:41:34.000000000 +0100
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_ccw.c	2009-03-01 16:41:37.000000000 +0100
@@ -3,7 +3,7 @@
  *
  * Registration and callback for the s390 common I/O layer.
  *
- * Copyright IBM Corporation 2002, 2008
+ * Copyright IBM Corporation 2002, 2009
  */
 
 #define KMSG_COMPONENT "zfcp"
@@ -108,6 +108,7 @@ static int zfcp_ccw_set_online(struct cc
 	/* initialize request counter */
 	BUG_ON(!zfcp_reqlist_isempty(adapter));
 	adapter->req_no = 0;
+	zfcp_fc_nameserver_init(adapter);
 
 	zfcp_erp_modify_adapter_status(adapter, "ccsonl1", NULL,
 				       ZFCP_STATUS_COMMON_RUNNING, ZFCP_SET);
diff -urpN linux-2.6/drivers/s390/scsi/zfcp_fc.c linux-2.6-patched/drivers/s390/scsi/zfcp_fc.c
--- linux-2.6/drivers/s390/scsi/zfcp_fc.c	2009-03-01 16:41:36.000000000 +0100
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_fc.c	2009-03-01 16:41:37.000000000 +0100
@@ -98,8 +98,12 @@ static void zfcp_wka_port_offline(struct
 	struct zfcp_wka_port *wka_port =
 			container_of(dw, struct zfcp_wka_port, work);
 
-	wait_event(wka_port->completion_wq,
-			atomic_read(&wka_port->refcount) == 0);
+	/* Don't wait forvever. If the wka_port is too busy take it offline
+	   through a new call later */
+	if (!wait_event_timeout(wka_port->completion_wq,
+				atomic_read(&wka_port->refcount) == 0,
+				HZ >> 1))
+		return;
 
 	mutex_lock(&wka_port->mutex);
 	if ((atomic_read(&wka_port->refcount) != 0) ||


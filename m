From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 6/9] zfcp: Increase ref counter for port open requests
Date: Fri, 15 May 2009 13:18:19 +0200
Message-ID: <20090515112222.042636000@de.ibm.com>
References: <20090515111813.314177000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate1.de.ibm.com ([195.212.17.161]:44443 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753165AbZEOLWW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 15 May 2009 07:22:22 -0400
Content-Disposition: inline; filename=705-zfcp-refcount-portopen.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Martin Petermann <martin.petermann@de.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Martin Petermann <martin.petermann@de.ibm.com>

In rare cases, open port request might timeout, erp calls
zfcp_port_put, port gets dequeued. Now, the late returning (or
dismissed) fsf-port-open calls the fsf_port_open_handler that tries to
reference the port data structure leading to a kernel oops.

Signed-off-by: Martin Petermann <martin.petermann@de.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_fsf.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/drivers/s390/scsi/zfcp_fsf.c	2009-05-15 12:56:17.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_fsf.c	2009-05-15 12:56:19.000000000 +0200
@@ -1402,7 +1402,7 @@ static void zfcp_fsf_open_port_handler(s
 	struct fsf_plogi *plogi;
 
 	if (req->status & ZFCP_STATUS_FSFREQ_ERROR)
-		return;
+		goto out;
 
 	switch (header->fsf_status) {
 	case FSF_PORT_ALREADY_OPEN:
@@ -1464,6 +1464,9 @@ static void zfcp_fsf_open_port_handler(s
 		req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 	}
+
+out:
+	zfcp_port_put(port);
 }
 
 /**
@@ -1476,6 +1479,7 @@ int zfcp_fsf_open_port(struct zfcp_erp_a
 	struct qdio_buffer_element *sbale;
 	struct zfcp_adapter *adapter = erp_action->adapter;
 	struct zfcp_fsf_req *req;
+	struct zfcp_port *port = erp_action->port;
 	int retval = -EIO;
 
 	spin_lock_bh(&adapter->req_q_lock);
@@ -1496,16 +1500,18 @@ int zfcp_fsf_open_port(struct zfcp_erp_a
         sbale[1].flags |= SBAL_FLAGS_LAST_ENTRY;
 
 	req->handler = zfcp_fsf_open_port_handler;
-	req->qtcb->bottom.support.d_id = erp_action->port->d_id;
-	req->data = erp_action->port;
+	req->qtcb->bottom.support.d_id = port->d_id;
+	req->data = port;
 	req->erp_action = erp_action;
 	erp_action->fsf_req = req;
+	zfcp_port_get(port);
 
 	zfcp_fsf_start_erp_timer(req);
 	retval = zfcp_fsf_req_send(req);
 	if (retval) {
 		zfcp_fsf_req_free(req);
 		erp_action->fsf_req = NULL;
+		zfcp_port_put(port);
 	}
 out:
 	spin_unlock_bh(&adapter->req_q_lock);


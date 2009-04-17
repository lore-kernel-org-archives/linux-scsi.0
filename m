From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 03/15] zfcp: Dont call zfcp_fsf_req_free on NULL pointer
Date: Fri, 17 Apr 2009 15:08:03 +0200
Message-ID: <20090417131122.219876000@de.ibm.com>
References: <20090417130800.923944000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate3.de.ibm.com ([195.212.29.152]:43978 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751558AbZDQNLY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Apr 2009 09:11:24 -0400
Content-Disposition: inline; filename=702-zfcp-fsf-req-free.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

Fix problem that zfcp_fsf_exchange_config_data_sync and
zfcp_fsf_exchange_config_data_sync could try to call zfcp_fsf_req_free
with a NULL pointer.

Reviewed-by: Martin Petermann <martin@linux.vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_fsf.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

--- a/drivers/s390/scsi/zfcp_fsf.c	2009-04-17 15:03:25.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_fsf.c	2009-04-17 15:03:33.000000000 +0200
@@ -1254,13 +1254,13 @@ int zfcp_fsf_exchange_config_data_sync(s
 
 	spin_lock_bh(&adapter->req_q_lock);
 	if (zfcp_fsf_req_sbal_get(adapter))
-		goto out;
+		goto out_unlock;
 
 	req = zfcp_fsf_req_create(adapter, FSF_QTCB_EXCHANGE_CONFIG_DATA,
 				  0, NULL);
 	if (IS_ERR(req)) {
 		retval = PTR_ERR(req);
-		goto out;
+		goto out_unlock;
 	}
 
 	sbale = zfcp_qdio_sbale_req(req);
@@ -1279,14 +1279,16 @@ int zfcp_fsf_exchange_config_data_sync(s
 
 	zfcp_fsf_start_timer(req, ZFCP_FSF_REQUEST_TIMEOUT);
 	retval = zfcp_fsf_req_send(req);
-out:
 	spin_unlock_bh(&adapter->req_q_lock);
 	if (!retval)
 		wait_event(req->completion_wq,
 			   req->status & ZFCP_STATUS_FSFREQ_COMPLETED);
 
 	zfcp_fsf_req_free(req);
+	return retval;
 
+out_unlock:
+	spin_unlock_bh(&adapter->req_q_lock);
 	return retval;
 }
 
@@ -1353,13 +1355,13 @@ int zfcp_fsf_exchange_port_data_sync(str
 
 	spin_lock_bh(&adapter->req_q_lock);
 	if (zfcp_fsf_req_sbal_get(adapter))
-		goto out;
+		goto out_unlock;
 
 	req = zfcp_fsf_req_create(adapter, FSF_QTCB_EXCHANGE_PORT_DATA, 0,
 				  NULL);
 	if (IS_ERR(req)) {
 		retval = PTR_ERR(req);
-		goto out;
+		goto out_unlock;
 	}
 
 	if (data)
@@ -1372,14 +1374,18 @@ int zfcp_fsf_exchange_port_data_sync(str
 	req->handler = zfcp_fsf_exchange_port_data_handler;
 	zfcp_fsf_start_timer(req, ZFCP_FSF_REQUEST_TIMEOUT);
 	retval = zfcp_fsf_req_send(req);
-out:
 	spin_unlock_bh(&adapter->req_q_lock);
+
 	if (!retval)
 		wait_event(req->completion_wq,
 			   req->status & ZFCP_STATUS_FSFREQ_COMPLETED);
 	zfcp_fsf_req_free(req);
 
 	return retval;
+
+out_unlock:
+	spin_unlock_bh(&adapter->req_q_lock);
+	return retval;
 }
 
 static void zfcp_fsf_open_port_handler(struct zfcp_fsf_req *req)


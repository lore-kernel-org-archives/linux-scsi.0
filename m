From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 06/18] [PATCH] zfcp: Wait for free SBALs when possible
Date: Mon, 02 Mar 2009 13:08:59 +0100
Message-ID: <20090302121002.809633000@de.ibm.com>
References: <20090302120853.279447000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate7.de.ibm.com ([195.212.29.156]:49634 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758709AbZCBMKG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Mar 2009 07:10:06 -0500
Content-Disposition: inline; filename=705-zfcp-wait-sbal.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Swen Schillig <swen@vnet.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

For calls from zfcp erp, scsi_eh and sysfs switch the calls issuing 
FSF requests to zfcp_fsf_req_sbal_get to wait for free SBALs.

Acked-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_fsf.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/drivers/s390/scsi/zfcp_fsf.c	2009-03-02 12:42:25.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_fsf.c	2009-03-02 12:42:26.000000000 +0100
@@ -929,8 +929,8 @@ struct zfcp_fsf_req *zfcp_fsf_abort_fcp_
 	struct qdio_buffer_element *sbale;
 	struct zfcp_fsf_req *req = NULL;
 
-	spin_lock(&adapter->req_q_lock);
-	if (!zfcp_fsf_sbal_available(adapter))
+	spin_lock_bh(&adapter->req_q_lock);
+	if (zfcp_fsf_req_sbal_get(adapter))
 		goto out;
 	req = zfcp_fsf_req_create(adapter, FSF_QTCB_ABORT_FCP_CMND,
 				  req_flags, adapter->pool.fsf_req_abort);
@@ -961,7 +961,7 @@ out_error_free:
 	zfcp_fsf_req_free(req);
 	req = NULL;
 out:
-	spin_unlock(&adapter->req_q_lock);
+	spin_unlock_bh(&adapter->req_q_lock);
 	return req;
 }
 
@@ -1225,7 +1225,7 @@ int zfcp_fsf_exchange_config_data(struct
 	int retval = -EIO;
 
 	spin_lock_bh(&adapter->req_q_lock);
-	if (!zfcp_fsf_sbal_available(adapter))
+	if (zfcp_fsf_req_sbal_get(adapter))
 		goto out;
 	req = zfcp_fsf_req_create(adapter,
 				  FSF_QTCB_EXCHANGE_CONFIG_DATA,
@@ -1321,7 +1321,7 @@ int zfcp_fsf_exchange_port_data(struct z
 		return -EOPNOTSUPP;
 
 	spin_lock_bh(&adapter->req_q_lock);
-	if (!zfcp_fsf_sbal_available(adapter))
+	if (zfcp_fsf_req_sbal_get(adapter))
 		goto out;
 	req = zfcp_fsf_req_create(adapter, FSF_QTCB_EXCHANGE_PORT_DATA,
 				  ZFCP_REQ_AUTO_CLEANUP,
@@ -1367,7 +1367,7 @@ int zfcp_fsf_exchange_port_data_sync(str
 		return -EOPNOTSUPP;
 
 	spin_lock_bh(&adapter->req_q_lock);
-	if (!zfcp_fsf_sbal_available(adapter))
+	if (zfcp_fsf_req_sbal_get(adapter))
 		goto out;
 
 	req = zfcp_fsf_req_create(adapter, FSF_QTCB_EXCHANGE_PORT_DATA, 0,
@@ -2453,8 +2453,8 @@ struct zfcp_fsf_req *zfcp_fsf_send_fcp_c
 		       ZFCP_STATUS_COMMON_UNBLOCKED)))
 		return NULL;
 
-	spin_lock(&adapter->req_q_lock);
-	if (!zfcp_fsf_sbal_available(adapter))
+	spin_lock_bh(&adapter->req_q_lock);
+	if (zfcp_fsf_req_sbal_get(adapter))
 		goto out;
 	req = zfcp_fsf_req_create(adapter, FSF_QTCB_FCP_CMND, req_flags,
 				  adapter->pool.fsf_req_scsi);
@@ -2488,7 +2488,7 @@ struct zfcp_fsf_req *zfcp_fsf_send_fcp_c
 	zfcp_fsf_req_free(req);
 	req = NULL;
 out:
-	spin_unlock(&adapter->req_q_lock);
+	spin_unlock_bh(&adapter->req_q_lock);
 	return req;
 }
 


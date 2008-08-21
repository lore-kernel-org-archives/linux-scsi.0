From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 6/6] zfcp: Remove duplicated unlikely() macros.
Date: Thu, 21 Aug 2008 13:43:37 +0200
Message-ID: <20080821114559.686444000@de.ibm.com>
References: <20080821114331.148204000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate4.de.ibm.com ([195.212.29.153]:62068 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758027AbYHULqH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Aug 2008 07:46:07 -0400
Content-Disposition: inline; filename=706-zfcp-unlikely.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, Hirofumi Nakagawa <hnakagawa@miraclelinux.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Hirofumi Nakagawa <hnakagawa@miraclelinux.com>

Some drivers have duplicated unlikely() macros. IS_ERR() already
has unlikely() in itself. This patch cleans up such pointless
codes although there is no real effect on the kernel's behaviour.

Signed-off-by: Hirofumi Nakagawa <hnakagawa@miraclelinux.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_fsf.c |   32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

--- a/drivers/s390/scsi/zfcp_fsf.c	2008-08-20 19:31:11.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_fsf.c	2008-08-20 19:31:15.000000000 +0200
@@ -877,7 +877,7 @@ int zfcp_fsf_status_read(struct zfcp_ada
 	req = zfcp_fsf_req_create(adapter, FSF_QTCB_UNSOLICITED_STATUS,
 				  ZFCP_REQ_NO_QTCB,
 				  adapter->pool.fsf_req_status_read);
-	if (unlikely(IS_ERR(req))) {
+	if (IS_ERR(req)) {
 		retval = PTR_ERR(req);
 		goto out;
 	}
@@ -988,7 +988,7 @@ struct zfcp_fsf_req *zfcp_fsf_abort_fcp_
 		goto out;
 	req = zfcp_fsf_req_create(adapter, FSF_QTCB_ABORT_FCP_CMND,
 				  req_flags, adapter->pool.fsf_req_abort);
-	if (unlikely(IS_ERR(req)))
+	if (IS_ERR(req))
 		goto out;
 
 	if (unlikely(!(atomic_read(&unit->status) &
@@ -1112,7 +1112,7 @@ int zfcp_fsf_send_ct(struct zfcp_send_ct
 
 	req = zfcp_fsf_req_create(adapter, FSF_QTCB_SEND_GENERIC,
 				  ZFCP_REQ_AUTO_CLEANUP, pool);
-	if (unlikely(IS_ERR(req))) {
+	if (IS_ERR(req)) {
 		ret = PTR_ERR(req);
 		goto out;
 	}
@@ -1223,7 +1223,7 @@ int zfcp_fsf_send_els(struct zfcp_send_e
 		goto out;
 	req = zfcp_fsf_req_create(adapter, FSF_QTCB_SEND_ELS,
 				  ZFCP_REQ_AUTO_CLEANUP, NULL);
-	if (unlikely(IS_ERR(req))) {
+	if (IS_ERR(req)) {
 		ret = PTR_ERR(req);
 		goto out;
 	}
@@ -1270,7 +1270,7 @@ int zfcp_fsf_exchange_config_data(struct
 				  FSF_QTCB_EXCHANGE_CONFIG_DATA,
 				  ZFCP_REQ_AUTO_CLEANUP,
 				  adapter->pool.fsf_req_erp);
-	if (unlikely(IS_ERR(req))) {
+	if (IS_ERR(req)) {
 		retval = PTR_ERR(req);
 		goto out;
 	}
@@ -1312,7 +1312,7 @@ int zfcp_fsf_exchange_config_data_sync(s
 
 	req = zfcp_fsf_req_create(adapter, FSF_QTCB_EXCHANGE_CONFIG_DATA,
 				  0, NULL);
-	if (unlikely(IS_ERR(req))) {
+	if (IS_ERR(req)) {
 		retval = PTR_ERR(req);
 		goto out;
 	}
@@ -1365,7 +1365,7 @@ int zfcp_fsf_exchange_port_data(struct z
 	req = zfcp_fsf_req_create(adapter, FSF_QTCB_EXCHANGE_PORT_DATA,
 				  ZFCP_REQ_AUTO_CLEANUP,
 				  adapter->pool.fsf_req_erp);
-	if (unlikely(IS_ERR(req))) {
+	if (IS_ERR(req)) {
 		retval = PTR_ERR(req);
 		goto out;
 	}
@@ -1411,7 +1411,7 @@ int zfcp_fsf_exchange_port_data_sync(str
 
 	req = zfcp_fsf_req_create(adapter, FSF_QTCB_EXCHANGE_PORT_DATA, 0,
 				  NULL);
-	if (unlikely(IS_ERR(req))) {
+	if (IS_ERR(req)) {
 		retval = PTR_ERR(req);
 		goto out;
 	}
@@ -1539,7 +1539,7 @@ int zfcp_fsf_open_port(struct zfcp_erp_a
 				  FSF_QTCB_OPEN_PORT_WITH_DID,
 				  ZFCP_REQ_AUTO_CLEANUP,
 				  adapter->pool.fsf_req_erp);
-	if (unlikely(IS_ERR(req))) {
+	if (IS_ERR(req)) {
 		retval = PTR_ERR(req);
 		goto out;
 	}
@@ -1610,7 +1610,7 @@ int zfcp_fsf_close_port(struct zfcp_erp_
 	req = zfcp_fsf_req_create(adapter, FSF_QTCB_CLOSE_PORT,
 				  ZFCP_REQ_AUTO_CLEANUP,
 				  adapter->pool.fsf_req_erp);
-	if (unlikely(IS_ERR(req))) {
+	if (IS_ERR(req)) {
 		retval = PTR_ERR(req);
 		goto out;
 	}
@@ -1707,7 +1707,7 @@ int zfcp_fsf_close_physical_port(struct 
 	req = zfcp_fsf_req_create(adapter, FSF_QTCB_CLOSE_PHYSICAL_PORT,
 				  ZFCP_REQ_AUTO_CLEANUP,
 				  adapter->pool.fsf_req_erp);
-	if (unlikely(IS_ERR(req))) {
+	if (IS_ERR(req)) {
 		retval = PTR_ERR(req);
 		goto out;
 	}
@@ -1882,7 +1882,7 @@ int zfcp_fsf_open_unit(struct zfcp_erp_a
 	req = zfcp_fsf_req_create(adapter, FSF_QTCB_OPEN_LUN,
 				  ZFCP_REQ_AUTO_CLEANUP,
 				  adapter->pool.fsf_req_erp);
-	if (unlikely(IS_ERR(req))) {
+	if (IS_ERR(req)) {
 		retval = PTR_ERR(req);
 		goto out;
 	}
@@ -1971,7 +1971,7 @@ int zfcp_fsf_close_unit(struct zfcp_erp_
 	req = zfcp_fsf_req_create(adapter, FSF_QTCB_CLOSE_LUN,
 				  ZFCP_REQ_AUTO_CLEANUP,
 				  adapter->pool.fsf_req_erp);
-	if (unlikely(IS_ERR(req))) {
+	if (IS_ERR(req)) {
 		retval = PTR_ERR(req);
 		goto out;
 	}
@@ -2228,7 +2228,7 @@ int zfcp_fsf_send_fcp_command_task(struc
 		goto out;
 	req = zfcp_fsf_req_create(adapter, FSF_QTCB_FCP_CMND, req_flags,
 				  adapter->pool.fsf_req_scsi);
-	if (unlikely(IS_ERR(req))) {
+	if (IS_ERR(req)) {
 		retval = PTR_ERR(req);
 		goto out;
 	}
@@ -2351,7 +2351,7 @@ struct zfcp_fsf_req *zfcp_fsf_send_fcp_c
 		goto out;
 	req = zfcp_fsf_req_create(adapter, FSF_QTCB_FCP_CMND, req_flags,
 				  adapter->pool.fsf_req_scsi);
-	if (unlikely(IS_ERR(req)))
+	if (IS_ERR(req))
 		goto out;
 
 	req->status |= ZFCP_STATUS_FSFREQ_TASK_MANAGEMENT;
@@ -2422,7 +2422,7 @@ struct zfcp_fsf_req *zfcp_fsf_control_fi
 		goto out;
 
 	req = zfcp_fsf_req_create(adapter, fsf_cfdc->command, 0, NULL);
-	if (unlikely(IS_ERR(req))) {
+	if (IS_ERR(req)) {
 		retval = -EPERM;
 		goto out;
 	}

-- 

From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 11/27] zfcp: Remove the useless ZFCP_REQ_AUTO_CLEANUP flag
Date: Tue, 18 Aug 2009 15:43:16 +0200
Message-ID: <20090818135030.199935000@de.ibm.com>
References: <20090818134305.841868000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate8.de.ibm.com ([195.212.29.157]:49793 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755009AbZHRNuk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Aug 2009 09:50:40 -0400
Content-Disposition: inline; filename=712-zfcp-useless-flag.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Swen Schillig <swen@vnet.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Swen Schillig <swen@vnet.ibm.com>

The flag ZFCP_REQ_AUTO_CLEANUP was useless as the
ZFCP_STATUS_FSFREQ_CLEANUP flag is there for exactly the same purpose.

Signed-off-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_fsf.c |   80 ++++++++++++++++++++++++-------------------
 1 file changed, 45 insertions(+), 35 deletions(-)

diff -urpN linux-2.6/drivers/s390/scsi/zfcp_fsf.c linux-2.6-patched/drivers/s390/scsi/zfcp_fsf.c
--- linux-2.6/drivers/s390/scsi/zfcp_fsf.c	2009-08-12 10:05:32.000000000 +0200
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_fsf.c	2009-08-12 10:05:32.000000000 +0200
@@ -13,8 +13,6 @@
 #include "zfcp_ext.h"
 #include "zfcp_dbf.h"
 
-#define ZFCP_REQ_AUTO_CLEANUP	0x00000002
-
 static void zfcp_fsf_request_timeout_handler(unsigned long data)
 {
 	struct zfcp_adapter *adapter = (struct zfcp_adapter *) data;
@@ -703,8 +701,7 @@ static struct fsf_qtcb *zfcp_qtcb_alloc(
 }
 
 static struct zfcp_fsf_req *zfcp_fsf_req_create(struct zfcp_adapter *adapter,
-						u32 fsf_cmd, int req_flags,
-						mempool_t *pool)
+						u32 fsf_cmd, mempool_t *pool)
 {
 	struct qdio_buffer_element *sbale;
 	struct zfcp_qdio_queue *req_q = &adapter->req_q;
@@ -761,9 +758,6 @@ static struct zfcp_fsf_req *zfcp_fsf_req
 		return ERR_PTR(-EIO);
 	}
 
-	if (likely(req_flags & ZFCP_REQ_AUTO_CLEANUP))
-		req->status |= ZFCP_STATUS_FSFREQ_CLEANUP;
-
 	return req;
 }
 
@@ -818,7 +812,7 @@ int zfcp_fsf_status_read(struct zfcp_ada
 	if (zfcp_fsf_req_sbal_get(adapter))
 		goto out;
 
-	req = zfcp_fsf_req_create(adapter, FSF_QTCB_UNSOLICITED_STATUS, 0,
+	req = zfcp_fsf_req_create(adapter, FSF_QTCB_UNSOLICITED_STATUS,
 				  adapter->pool.status_read_req);
 	if (IS_ERR(req)) {
 		retval = PTR_ERR(req);
@@ -925,7 +919,7 @@ struct zfcp_fsf_req *zfcp_fsf_abort_fcp_
 	if (zfcp_fsf_req_sbal_get(adapter))
 		goto out;
 	req = zfcp_fsf_req_create(adapter, FSF_QTCB_ABORT_FCP_CMND,
-				  0, adapter->pool.scsi_abort);
+				  adapter->pool.scsi_abort);
 	if (IS_ERR(req)) {
 		req = NULL;
 		goto out;
@@ -1081,13 +1075,14 @@ int zfcp_fsf_send_ct(struct zfcp_send_ct
 	if (zfcp_fsf_req_sbal_get(adapter))
 		goto out;
 
-	req = zfcp_fsf_req_create(adapter, FSF_QTCB_SEND_GENERIC,
-				  ZFCP_REQ_AUTO_CLEANUP, pool);
+	req = zfcp_fsf_req_create(adapter, FSF_QTCB_SEND_GENERIC, pool);
+
 	if (IS_ERR(req)) {
 		ret = PTR_ERR(req);
 		goto out;
 	}
 
+	req->status |= ZFCP_STATUS_FSFREQ_CLEANUP;
 	ret = zfcp_fsf_setup_ct_els_sbals(req, ct->req, ct->resp,
 					  FSF_MAX_SBALS_PER_REQ);
 	if (ret)
@@ -1189,13 +1184,15 @@ int zfcp_fsf_send_els(struct zfcp_send_e
 	spin_lock_bh(&adapter->req_q_lock);
 	if (zfcp_fsf_req_sbal_get(adapter))
 		goto out;
-	req = zfcp_fsf_req_create(adapter, FSF_QTCB_SEND_ELS,
-				  ZFCP_REQ_AUTO_CLEANUP, NULL);
+
+	req = zfcp_fsf_req_create(adapter, FSF_QTCB_SEND_ELS, NULL);
+
 	if (IS_ERR(req)) {
 		ret = PTR_ERR(req);
 		goto out;
 	}
 
+	req->status |= ZFCP_STATUS_FSFREQ_CLEANUP;
 	ret = zfcp_fsf_setup_ct_els_sbals(req, els->req, els->resp, 2);
 
 	if (ret)
@@ -1234,15 +1231,16 @@ int zfcp_fsf_exchange_config_data(struct
 	spin_lock_bh(&adapter->req_q_lock);
 	if (zfcp_fsf_req_sbal_get(adapter))
 		goto out;
-	req = zfcp_fsf_req_create(adapter,
-				  FSF_QTCB_EXCHANGE_CONFIG_DATA,
-				  ZFCP_REQ_AUTO_CLEANUP,
+
+	req = zfcp_fsf_req_create(adapter, FSF_QTCB_EXCHANGE_CONFIG_DATA,
 				  adapter->pool.erp_req);
+
 	if (IS_ERR(req)) {
 		retval = PTR_ERR(req);
 		goto out;
 	}
 
+	req->status |= ZFCP_STATUS_FSFREQ_CLEANUP;
 	sbale = zfcp_qdio_sbale_req(req);
 	sbale[0].flags |= SBAL_FLAGS0_TYPE_READ;
 	sbale[1].flags |= SBAL_FLAGS_LAST_ENTRY;
@@ -1278,8 +1276,8 @@ int zfcp_fsf_exchange_config_data_sync(s
 	if (zfcp_fsf_req_sbal_get(adapter))
 		goto out_unlock;
 
-	req = zfcp_fsf_req_create(adapter, FSF_QTCB_EXCHANGE_CONFIG_DATA,
-				  0, NULL);
+	req = zfcp_fsf_req_create(adapter, FSF_QTCB_EXCHANGE_CONFIG_DATA, NULL);
+
 	if (IS_ERR(req)) {
 		retval = PTR_ERR(req);
 		goto out_unlock;
@@ -1331,14 +1329,16 @@ int zfcp_fsf_exchange_port_data(struct z
 	spin_lock_bh(&adapter->req_q_lock);
 	if (zfcp_fsf_req_sbal_get(adapter))
 		goto out;
+
 	req = zfcp_fsf_req_create(adapter, FSF_QTCB_EXCHANGE_PORT_DATA,
-				  ZFCP_REQ_AUTO_CLEANUP,
 				  adapter->pool.erp_req);
+
 	if (IS_ERR(req)) {
 		retval = PTR_ERR(req);
 		goto out;
 	}
 
+	req->status |= ZFCP_STATUS_FSFREQ_CLEANUP;
 	sbale = zfcp_qdio_sbale_req(req);
 	sbale[0].flags |= SBAL_FLAGS0_TYPE_READ;
 	sbale[1].flags |= SBAL_FLAGS_LAST_ENTRY;
@@ -1378,8 +1378,8 @@ int zfcp_fsf_exchange_port_data_sync(str
 	if (zfcp_fsf_req_sbal_get(adapter))
 		goto out_unlock;
 
-	req = zfcp_fsf_req_create(adapter, FSF_QTCB_EXCHANGE_PORT_DATA, 0,
-				  NULL);
+	req = zfcp_fsf_req_create(adapter, FSF_QTCB_EXCHANGE_PORT_DATA, NULL);
+
 	if (IS_ERR(req)) {
 		retval = PTR_ERR(req);
 		goto out_unlock;
@@ -1500,15 +1500,15 @@ int zfcp_fsf_open_port(struct zfcp_erp_a
 	if (zfcp_fsf_req_sbal_get(adapter))
 		goto out;
 
-	req = zfcp_fsf_req_create(adapter,
-				  FSF_QTCB_OPEN_PORT_WITH_DID,
-				  ZFCP_REQ_AUTO_CLEANUP,
+	req = zfcp_fsf_req_create(adapter, FSF_QTCB_OPEN_PORT_WITH_DID,
 				  adapter->pool.erp_req);
+
 	if (IS_ERR(req)) {
 		retval = PTR_ERR(req);
 		goto out;
 	}
 
+	req->status |= ZFCP_STATUS_FSFREQ_CLEANUP;
 	sbale = zfcp_qdio_sbale_req(req);
         sbale[0].flags |= SBAL_FLAGS0_TYPE_READ;
         sbale[1].flags |= SBAL_FLAGS_LAST_ENTRY;
@@ -1571,13 +1571,14 @@ int zfcp_fsf_close_port(struct zfcp_erp_
 		goto out;
 
 	req = zfcp_fsf_req_create(adapter, FSF_QTCB_CLOSE_PORT,
-				  ZFCP_REQ_AUTO_CLEANUP,
 				  adapter->pool.erp_req);
+
 	if (IS_ERR(req)) {
 		retval = PTR_ERR(req);
 		goto out;
 	}
 
+	req->status |= ZFCP_STATUS_FSFREQ_CLEANUP;
 	sbale = zfcp_qdio_sbale_req(req);
 	sbale[0].flags |= SBAL_FLAGS0_TYPE_READ;
 	sbale[1].flags |= SBAL_FLAGS_LAST_ENTRY;
@@ -1646,15 +1647,15 @@ int zfcp_fsf_open_wka_port(struct zfcp_w
 	if (zfcp_fsf_req_sbal_get(adapter))
 		goto out;
 
-	req = zfcp_fsf_req_create(adapter,
-				  FSF_QTCB_OPEN_PORT_WITH_DID,
-				  ZFCP_REQ_AUTO_CLEANUP,
+	req = zfcp_fsf_req_create(adapter, FSF_QTCB_OPEN_PORT_WITH_DID,
 				  adapter->pool.erp_req);
+
 	if (unlikely(IS_ERR(req))) {
 		retval = PTR_ERR(req);
 		goto out;
 	}
 
+	req->status |= ZFCP_STATUS_FSFREQ_CLEANUP;
 	sbale = zfcp_qdio_sbale_req(req);
 	sbale[0].flags |= SBAL_FLAGS0_TYPE_READ;
 	sbale[1].flags |= SBAL_FLAGS_LAST_ENTRY;
@@ -1702,13 +1703,14 @@ int zfcp_fsf_close_wka_port(struct zfcp_
 		goto out;
 
 	req = zfcp_fsf_req_create(adapter, FSF_QTCB_CLOSE_PORT,
-				  ZFCP_REQ_AUTO_CLEANUP,
 				  adapter->pool.erp_req);
+
 	if (unlikely(IS_ERR(req))) {
 		retval = PTR_ERR(req);
 		goto out;
 	}
 
+	req->status |= ZFCP_STATUS_FSFREQ_CLEANUP;
 	sbale = zfcp_qdio_sbale_req(req);
 	sbale[0].flags |= SBAL_FLAGS0_TYPE_READ;
 	sbale[1].flags |= SBAL_FLAGS_LAST_ENTRY;
@@ -1793,13 +1795,14 @@ int zfcp_fsf_close_physical_port(struct 
 		goto out;
 
 	req = zfcp_fsf_req_create(adapter, FSF_QTCB_CLOSE_PHYSICAL_PORT,
-				  ZFCP_REQ_AUTO_CLEANUP,
 				  adapter->pool.erp_req);
+
 	if (IS_ERR(req)) {
 		retval = PTR_ERR(req);
 		goto out;
 	}
 
+	req->status |= ZFCP_STATUS_FSFREQ_CLEANUP;
 	sbale = zfcp_qdio_sbale_req(req);
 	sbale[0].flags |= SBAL_FLAGS0_TYPE_READ;
 	sbale[1].flags |= SBAL_FLAGS_LAST_ENTRY;
@@ -1965,13 +1968,14 @@ int zfcp_fsf_open_unit(struct zfcp_erp_a
 		goto out;
 
 	req = zfcp_fsf_req_create(adapter, FSF_QTCB_OPEN_LUN,
-				  ZFCP_REQ_AUTO_CLEANUP,
 				  adapter->pool.erp_req);
+
 	if (IS_ERR(req)) {
 		retval = PTR_ERR(req);
 		goto out;
 	}
 
+	req->status |= ZFCP_STATUS_FSFREQ_CLEANUP;
 	sbale = zfcp_qdio_sbale_req(req);
         sbale[0].flags |= SBAL_FLAGS0_TYPE_READ;
         sbale[1].flags |= SBAL_FLAGS_LAST_ENTRY;
@@ -2049,14 +2053,16 @@ int zfcp_fsf_close_unit(struct zfcp_erp_
 	spin_lock_bh(&adapter->req_q_lock);
 	if (zfcp_fsf_req_sbal_get(adapter))
 		goto out;
+
 	req = zfcp_fsf_req_create(adapter, FSF_QTCB_CLOSE_LUN,
-				  ZFCP_REQ_AUTO_CLEANUP,
 				  adapter->pool.erp_req);
+
 	if (IS_ERR(req)) {
 		retval = PTR_ERR(req);
 		goto out;
 	}
 
+	req->status |= ZFCP_STATUS_FSFREQ_CLEANUP;
 	sbale = zfcp_qdio_sbale_req(req);
 	sbale[0].flags |= SBAL_FLAGS0_TYPE_READ;
 	sbale[1].flags |= SBAL_FLAGS_LAST_ENTRY;
@@ -2353,14 +2359,16 @@ int zfcp_fsf_send_fcp_command_task(struc
 		atomic_inc(&adapter->qdio_outb_full);
 		goto out;
 	}
+
 	req = zfcp_fsf_req_create(adapter, FSF_QTCB_FCP_CMND,
-				  ZFCP_REQ_AUTO_CLEANUP,
 				  adapter->pool.scsi_req);
+
 	if (IS_ERR(req)) {
 		retval = PTR_ERR(req);
 		goto out;
 	}
 
+	req->status |= ZFCP_STATUS_FSFREQ_CLEANUP;
 	zfcp_unit_get(unit);
 	req->unit = unit;
 	req->data = scsi_cmnd;
@@ -2465,8 +2473,10 @@ struct zfcp_fsf_req *zfcp_fsf_send_fcp_c
 	spin_lock_bh(&adapter->req_q_lock);
 	if (zfcp_fsf_req_sbal_get(adapter))
 		goto out;
-	req = zfcp_fsf_req_create(adapter, FSF_QTCB_FCP_CMND, 0,
+
+	req = zfcp_fsf_req_create(adapter, FSF_QTCB_FCP_CMND,
 				  adapter->pool.scsi_req);
+
 	if (IS_ERR(req)) {
 		req = NULL;
 		goto out;
@@ -2537,7 +2547,7 @@ struct zfcp_fsf_req *zfcp_fsf_control_fi
 	if (zfcp_fsf_req_sbal_get(adapter))
 		goto out;
 
-	req = zfcp_fsf_req_create(adapter, fsf_cfdc->command, 0, NULL);
+	req = zfcp_fsf_req_create(adapter, fsf_cfdc->command, NULL);
 	if (IS_ERR(req)) {
 		retval = -EPERM;
 		goto out;


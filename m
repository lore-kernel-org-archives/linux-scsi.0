From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 2/5] zfcp: Move sbale handling to zfcp_qdio files
Date: Fri, 30 Apr 2010 18:09:34 +0200
Message-ID: <20100430161020.154297000@de.ibm.com>
References: <20100430160932.658896000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate7.de.ibm.com ([195.212.17.167]:47338 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757981Ab0D3TV6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Apr 2010 15:21:58 -0400
Content-Disposition: inline; filename=702-zfcp-sbale-handling.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

Move the code accessing the qdio sbales and zfcp_qdio_req struct to
the zfcp_qdio files and provide helper functions for accessing the
qdio related parts.

Reviewed-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_def.h  |   17 ---
 drivers/s390/scsi/zfcp_ext.h  |    5 -
 drivers/s390/scsi/zfcp_fsf.c  |  180 +++++++++++++++---------------------------
 drivers/s390/scsi/zfcp_fsf.h  |    9 +-
 drivers/s390/scsi/zfcp_qdio.c |   25 ++---
 drivers/s390/scsi/zfcp_qdio.h |  102 +++++++++++++++++++++++
 drivers/s390/scsi/zfcp_scsi.c |    4 
 7 files changed, 191 insertions(+), 151 deletions(-)

--- a/drivers/s390/scsi/zfcp_def.h	2010-04-30 16:00:39.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_def.h	2010-04-30 16:00:44.000000000 +0200
@@ -44,23 +44,6 @@ struct zfcp_reqlist;
 /********************* SCSI SPECIFIC DEFINES *********************************/
 #define ZFCP_SCSI_ER_TIMEOUT                    (10*HZ)
 
-/********************* CIO/QDIO SPECIFIC DEFINES *****************************/
-
-/* DMQ bug workaround: don't use last SBALE */
-#define ZFCP_MAX_SBALES_PER_SBAL	(QDIO_MAX_ELEMENTS_PER_BUFFER - 1)
-
-/* index of last SBALE (with respect to DMQ bug workaround) */
-#define ZFCP_LAST_SBALE_PER_SBAL	(ZFCP_MAX_SBALES_PER_SBAL - 1)
-
-/* max. number of (data buffer) SBALEs in largest SBAL chain */
-#define ZFCP_MAX_SBALES_PER_REQ		\
-	(FSF_MAX_SBALS_PER_REQ * ZFCP_MAX_SBALES_PER_SBAL - 2)
-        /* request ID + QTCB in SBALE 0 + 1 of first SBAL in chain */
-
-#define ZFCP_MAX_SECTORS (ZFCP_MAX_SBALES_PER_REQ * 8)
-        /* max. number of (data buffer) SBALEs in largest SBAL chain
-           multiplied with number of sectors per 4k block */
-
 /********************* FSF SPECIFIC DEFINES *********************************/
 
 /* ATTENTION: value must not be used by hardware */
--- a/drivers/s390/scsi/zfcp_ext.h	2010-04-30 16:00:37.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_ext.h	2010-04-30 16:00:44.000000000 +0200
@@ -3,7 +3,7 @@
  *
  * External function declarations.
  *
- * Copyright IBM Corporation 2002, 2009
+ * Copyright IBM Corporation 2002, 2010
  */
 
 #ifndef ZFCP_EXT_H
@@ -144,8 +144,7 @@ extern void zfcp_fsf_reqid_check(struct 
 extern int zfcp_qdio_setup(struct zfcp_adapter *);
 extern void zfcp_qdio_destroy(struct zfcp_qdio *);
 extern int zfcp_qdio_send(struct zfcp_qdio *, struct zfcp_qdio_req *);
-extern int zfcp_qdio_sbals_from_sg(struct zfcp_qdio *,
-				   struct zfcp_qdio_req *, unsigned long,
+extern int zfcp_qdio_sbals_from_sg(struct zfcp_qdio *, struct zfcp_qdio_req *,
 				   struct scatterlist *, int);
 extern int zfcp_qdio_open(struct zfcp_qdio *);
 extern void zfcp_qdio_close(struct zfcp_qdio *);
--- a/drivers/s390/scsi/zfcp_fsf.c	2010-04-30 16:00:37.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_fsf.c	2010-04-30 16:00:44.000000000 +0200
@@ -705,10 +705,9 @@ static struct fsf_qtcb *zfcp_qtcb_alloc(
 }
 
 static struct zfcp_fsf_req *zfcp_fsf_req_create(struct zfcp_qdio *qdio,
-						u32 fsf_cmd, mempool_t *pool)
+						u32 fsf_cmd, u32 sbtype,
+						mempool_t *pool)
 {
-	struct qdio_buffer_element *sbale;
-	struct zfcp_qdio_queue *req_q = &qdio->req_q;
 	struct zfcp_adapter *adapter = qdio->adapter;
 	struct zfcp_fsf_req *req = zfcp_fsf_alloc(pool);
 
@@ -725,14 +724,6 @@ static struct zfcp_fsf_req *zfcp_fsf_req
 	req->adapter = adapter;
 	req->fsf_command = fsf_cmd;
 	req->req_id = adapter->req_no;
-	req->qdio_req.sbal_number = 1;
-	req->qdio_req.sbal_first = req_q->first;
-	req->qdio_req.sbal_last = req_q->first;
-	req->qdio_req.sbale_curr = 1;
-
-	sbale = zfcp_qdio_sbale_req(qdio, &req->qdio_req);
-	sbale[0].addr = (void *) req->req_id;
-	sbale[0].flags |= SBAL_FLAGS0_COMMAND;
 
 	if (likely(fsf_cmd != FSF_QTCB_UNSOLICITED_STATUS)) {
 		if (likely(pool))
@@ -753,10 +744,11 @@ static struct zfcp_fsf_req *zfcp_fsf_req
 		req->qtcb->prefix.qtcb_version = FSF_QTCB_CURRENT_VERSION;
 		req->qtcb->header.req_handle = req->req_id;
 		req->qtcb->header.fsf_command = req->fsf_command;
-		sbale[1].addr = (void *) req->qtcb;
-		sbale[1].length = sizeof(struct fsf_qtcb);
 	}
 
+	zfcp_qdio_req_init(adapter->qdio, &req->qdio_req, req->req_id, sbtype,
+			   req->qtcb, sizeof(struct fsf_qtcb));
+
 	if (!(atomic_read(&adapter->status) & ZFCP_STATUS_ADAPTER_QDIOUP)) {
 		zfcp_fsf_req_free(req);
 		return ERR_PTR(-EIO);
@@ -803,24 +795,19 @@ int zfcp_fsf_status_read(struct zfcp_qdi
 	struct zfcp_adapter *adapter = qdio->adapter;
 	struct zfcp_fsf_req *req;
 	struct fsf_status_read_buffer *sr_buf;
-	struct qdio_buffer_element *sbale;
 	int retval = -EIO;
 
 	spin_lock_bh(&qdio->req_q_lock);
 	if (zfcp_fsf_req_sbal_get(qdio))
 		goto out;
 
-	req = zfcp_fsf_req_create(qdio, FSF_QTCB_UNSOLICITED_STATUS,
+	req = zfcp_fsf_req_create(qdio, FSF_QTCB_UNSOLICITED_STATUS, 0,
 				  adapter->pool.status_read_req);
 	if (IS_ERR(req)) {
 		retval = PTR_ERR(req);
 		goto out;
 	}
 
-	sbale = zfcp_qdio_sbale_req(qdio, &req->qdio_req);
-	sbale[2].flags |= SBAL_FLAGS_LAST_ENTRY;
-	req->qdio_req.sbale_curr = 2;
-
 	sr_buf = mempool_alloc(adapter->pool.status_read_data, GFP_ATOMIC);
 	if (!sr_buf) {
 		retval = -ENOMEM;
@@ -828,9 +815,9 @@ int zfcp_fsf_status_read(struct zfcp_qdi
 	}
 	memset(sr_buf, 0, sizeof(*sr_buf));
 	req->data = sr_buf;
-	sbale = zfcp_qdio_sbale_curr(qdio, &req->qdio_req);
-	sbale->addr = (void *) sr_buf;
-	sbale->length = sizeof(*sr_buf);
+
+	zfcp_qdio_fill_next(qdio, &req->qdio_req, sr_buf, sizeof(*sr_buf));
+	zfcp_qdio_set_sbale_last(qdio, &req->qdio_req);
 
 	retval = zfcp_fsf_req_send(req);
 	if (retval)
@@ -907,7 +894,6 @@ static void zfcp_fsf_abort_fcp_command_h
 struct zfcp_fsf_req *zfcp_fsf_abort_fcp_command(unsigned long old_req_id,
 						struct zfcp_unit *unit)
 {
-	struct qdio_buffer_element *sbale;
 	struct zfcp_fsf_req *req = NULL;
 	struct zfcp_qdio *qdio = unit->port->adapter->qdio;
 
@@ -915,6 +901,7 @@ struct zfcp_fsf_req *zfcp_fsf_abort_fcp_
 	if (zfcp_fsf_req_sbal_get(qdio))
 		goto out;
 	req = zfcp_fsf_req_create(qdio, FSF_QTCB_ABORT_FCP_CMND,
+				  SBAL_FLAGS0_TYPE_READ,
 				  qdio->adapter->pool.scsi_abort);
 	if (IS_ERR(req)) {
 		req = NULL;
@@ -925,9 +912,7 @@ struct zfcp_fsf_req *zfcp_fsf_abort_fcp_
 		       ZFCP_STATUS_COMMON_UNBLOCKED)))
 		goto out_error_free;
 
-	sbale = zfcp_qdio_sbale_req(qdio, &req->qdio_req);
-	sbale[0].flags |= SBAL_FLAGS0_TYPE_READ;
-	sbale[1].flags |= SBAL_FLAGS_LAST_ENTRY;
+	zfcp_qdio_set_sbale_last(qdio, &req->qdio_req);
 
 	req->data = unit;
 	req->handler = zfcp_fsf_abort_fcp_command_handler;
@@ -996,21 +981,14 @@ skip_fsfstatus:
 		ct->handler(ct->handler_data);
 }
 
-static void zfcp_fsf_setup_ct_els_unchained(struct qdio_buffer_element *sbale,
+static void zfcp_fsf_setup_ct_els_unchained(struct zfcp_qdio *qdio,
+					    struct zfcp_qdio_req *q_req,
 					    struct scatterlist *sg_req,
 					    struct scatterlist *sg_resp)
 {
-	sbale[0].flags |= SBAL_FLAGS0_TYPE_WRITE_READ;
-	sbale[2].addr   = sg_virt(sg_req);
-	sbale[2].length = sg_req->length;
-	sbale[3].addr   = sg_virt(sg_resp);
-	sbale[3].length = sg_resp->length;
-	sbale[3].flags |= SBAL_FLAGS_LAST_ENTRY;
-}
-
-static int zfcp_fsf_one_sbal(struct scatterlist *sg)
-{
-	return sg_is_last(sg) && sg->length <= PAGE_SIZE;
+	zfcp_qdio_fill_next(qdio, q_req, sg_virt(sg_req), sg_req->length);
+	zfcp_qdio_fill_next(qdio, q_req, sg_virt(sg_resp), sg_resp->length);
+	zfcp_qdio_set_sbale_last(qdio, q_req);
 }
 
 static int zfcp_fsf_setup_ct_els_sbals(struct zfcp_fsf_req *req,
@@ -1019,35 +997,34 @@ static int zfcp_fsf_setup_ct_els_sbals(s
 				       int max_sbals)
 {
 	struct zfcp_adapter *adapter = req->adapter;
-	struct qdio_buffer_element *sbale = zfcp_qdio_sbale_req(adapter->qdio,
-							       &req->qdio_req);
 	u32 feat = adapter->adapter_features;
 	int bytes;
 
 	if (!(feat & FSF_FEATURE_ELS_CT_CHAINED_SBALS)) {
-		if (!zfcp_fsf_one_sbal(sg_req) || !zfcp_fsf_one_sbal(sg_resp))
+		if (!zfcp_qdio_sg_one_sbale(sg_req) ||
+		    !zfcp_qdio_sg_one_sbale(sg_resp))
 			return -EOPNOTSUPP;
 
-		zfcp_fsf_setup_ct_els_unchained(sbale, sg_req, sg_resp);
+		zfcp_fsf_setup_ct_els_unchained(adapter->qdio, &req->qdio_req,
+						sg_req, sg_resp);
 		return 0;
 	}
 
 	/* use single, unchained SBAL if it can hold the request */
-	if (zfcp_fsf_one_sbal(sg_req) && zfcp_fsf_one_sbal(sg_resp)) {
-		zfcp_fsf_setup_ct_els_unchained(sbale, sg_req, sg_resp);
+	if (zfcp_qdio_sg_one_sbale(sg_req) || zfcp_qdio_sg_one_sbale(sg_resp)) {
+		zfcp_fsf_setup_ct_els_unchained(adapter->qdio, &req->qdio_req,
+						sg_req, sg_resp);
 		return 0;
 	}
 
 	bytes = zfcp_qdio_sbals_from_sg(adapter->qdio, &req->qdio_req,
-					SBAL_FLAGS0_TYPE_WRITE_READ,
 					sg_req, max_sbals);
 	if (bytes <= 0)
 		return -EIO;
 	req->qtcb->bottom.support.req_buf_length = bytes;
-	req->qdio_req.sbale_curr = ZFCP_LAST_SBALE_PER_SBAL;
+	zfcp_qdio_skip_to_last_sbale(&req->qdio_req);
 
 	bytes = zfcp_qdio_sbals_from_sg(adapter->qdio, &req->qdio_req,
-					SBAL_FLAGS0_TYPE_WRITE_READ,
 					sg_resp, max_sbals);
 	req->qtcb->bottom.support.resp_buf_length = bytes;
 	if (bytes <= 0)
@@ -1094,7 +1071,8 @@ int zfcp_fsf_send_ct(struct zfcp_fc_wka_
 	if (zfcp_fsf_req_sbal_get(qdio))
 		goto out;
 
-	req = zfcp_fsf_req_create(qdio, FSF_QTCB_SEND_GENERIC, pool);
+	req = zfcp_fsf_req_create(qdio, FSF_QTCB_SEND_GENERIC,
+				  SBAL_FLAGS0_TYPE_WRITE_READ, pool);
 
 	if (IS_ERR(req)) {
 		ret = PTR_ERR(req);
@@ -1103,7 +1081,7 @@ int zfcp_fsf_send_ct(struct zfcp_fc_wka_
 
 	req->status |= ZFCP_STATUS_FSFREQ_CLEANUP;
 	ret = zfcp_fsf_setup_ct_els(req, ct->req, ct->resp,
-				    FSF_MAX_SBALS_PER_REQ, timeout);
+				    ZFCP_FSF_MAX_SBALS_PER_REQ, timeout);
 	if (ret)
 		goto failed_send;
 
@@ -1190,7 +1168,8 @@ int zfcp_fsf_send_els(struct zfcp_adapte
 	if (zfcp_fsf_req_sbal_get(qdio))
 		goto out;
 
-	req = zfcp_fsf_req_create(qdio, FSF_QTCB_SEND_ELS, NULL);
+	req = zfcp_fsf_req_create(qdio, FSF_QTCB_SEND_ELS,
+				  SBAL_FLAGS0_TYPE_WRITE_READ, NULL);
 
 	if (IS_ERR(req)) {
 		ret = PTR_ERR(req);
@@ -1224,7 +1203,6 @@ out:
 
 int zfcp_fsf_exchange_config_data(struct zfcp_erp_action *erp_action)
 {
-	struct qdio_buffer_element *sbale;
 	struct zfcp_fsf_req *req;
 	struct zfcp_qdio *qdio = erp_action->adapter->qdio;
 	int retval = -EIO;
@@ -1234,6 +1212,7 @@ int zfcp_fsf_exchange_config_data(struct
 		goto out;
 
 	req = zfcp_fsf_req_create(qdio, FSF_QTCB_EXCHANGE_CONFIG_DATA,
+				  SBAL_FLAGS0_TYPE_READ,
 				  qdio->adapter->pool.erp_req);
 
 	if (IS_ERR(req)) {
@@ -1242,9 +1221,7 @@ int zfcp_fsf_exchange_config_data(struct
 	}
 
 	req->status |= ZFCP_STATUS_FSFREQ_CLEANUP;
-	sbale = zfcp_qdio_sbale_req(qdio, &req->qdio_req);
-	sbale[0].flags |= SBAL_FLAGS0_TYPE_READ;
-	sbale[1].flags |= SBAL_FLAGS_LAST_ENTRY;
+	zfcp_qdio_set_sbale_last(qdio, &req->qdio_req);
 
 	req->qtcb->bottom.config.feature_selection =
 			FSF_FEATURE_CFDC |
@@ -1269,7 +1246,6 @@ out:
 int zfcp_fsf_exchange_config_data_sync(struct zfcp_qdio *qdio,
 				       struct fsf_qtcb_bottom_config *data)
 {
-	struct qdio_buffer_element *sbale;
 	struct zfcp_fsf_req *req = NULL;
 	int retval = -EIO;
 
@@ -1277,16 +1253,15 @@ int zfcp_fsf_exchange_config_data_sync(s
 	if (zfcp_fsf_req_sbal_get(qdio))
 		goto out_unlock;
 
-	req = zfcp_fsf_req_create(qdio, FSF_QTCB_EXCHANGE_CONFIG_DATA, NULL);
+	req = zfcp_fsf_req_create(qdio, FSF_QTCB_EXCHANGE_CONFIG_DATA,
+				  SBAL_FLAGS0_TYPE_READ, NULL);
 
 	if (IS_ERR(req)) {
 		retval = PTR_ERR(req);
 		goto out_unlock;
 	}
 
-	sbale = zfcp_qdio_sbale_req(qdio, &req->qdio_req);
-	sbale[0].flags |= SBAL_FLAGS0_TYPE_READ;
-	sbale[1].flags |= SBAL_FLAGS_LAST_ENTRY;
+	zfcp_qdio_set_sbale_last(qdio, &req->qdio_req);
 	req->handler = zfcp_fsf_exchange_config_data_handler;
 
 	req->qtcb->bottom.config.feature_selection =
@@ -1320,7 +1295,6 @@ out_unlock:
 int zfcp_fsf_exchange_port_data(struct zfcp_erp_action *erp_action)
 {
 	struct zfcp_qdio *qdio = erp_action->adapter->qdio;
-	struct qdio_buffer_element *sbale;
 	struct zfcp_fsf_req *req;
 	int retval = -EIO;
 
@@ -1332,6 +1306,7 @@ int zfcp_fsf_exchange_port_data(struct z
 		goto out;
 
 	req = zfcp_fsf_req_create(qdio, FSF_QTCB_EXCHANGE_PORT_DATA,
+				  SBAL_FLAGS0_TYPE_READ,
 				  qdio->adapter->pool.erp_req);
 
 	if (IS_ERR(req)) {
@@ -1340,9 +1315,7 @@ int zfcp_fsf_exchange_port_data(struct z
 	}
 
 	req->status |= ZFCP_STATUS_FSFREQ_CLEANUP;
-	sbale = zfcp_qdio_sbale_req(qdio, &req->qdio_req);
-	sbale[0].flags |= SBAL_FLAGS0_TYPE_READ;
-	sbale[1].flags |= SBAL_FLAGS_LAST_ENTRY;
+	zfcp_qdio_set_sbale_last(qdio, &req->qdio_req);
 
 	req->handler = zfcp_fsf_exchange_port_data_handler;
 	req->erp_action = erp_action;
@@ -1368,7 +1341,6 @@ out:
 int zfcp_fsf_exchange_port_data_sync(struct zfcp_qdio *qdio,
 				     struct fsf_qtcb_bottom_port *data)
 {
-	struct qdio_buffer_element *sbale;
 	struct zfcp_fsf_req *req = NULL;
 	int retval = -EIO;
 
@@ -1379,7 +1351,8 @@ int zfcp_fsf_exchange_port_data_sync(str
 	if (zfcp_fsf_req_sbal_get(qdio))
 		goto out_unlock;
 
-	req = zfcp_fsf_req_create(qdio, FSF_QTCB_EXCHANGE_PORT_DATA, NULL);
+	req = zfcp_fsf_req_create(qdio, FSF_QTCB_EXCHANGE_PORT_DATA,
+				  SBAL_FLAGS0_TYPE_READ, NULL);
 
 	if (IS_ERR(req)) {
 		retval = PTR_ERR(req);
@@ -1389,9 +1362,7 @@ int zfcp_fsf_exchange_port_data_sync(str
 	if (data)
 		req->data = data;
 
-	sbale = zfcp_qdio_sbale_req(qdio, &req->qdio_req);
-	sbale[0].flags |= SBAL_FLAGS0_TYPE_READ;
-	sbale[1].flags |= SBAL_FLAGS_LAST_ENTRY;
+	zfcp_qdio_set_sbale_last(qdio, &req->qdio_req);
 
 	req->handler = zfcp_fsf_exchange_port_data_handler;
 	zfcp_fsf_start_timer(req, ZFCP_FSF_REQUEST_TIMEOUT);
@@ -1485,7 +1456,6 @@ out:
  */
 int zfcp_fsf_open_port(struct zfcp_erp_action *erp_action)
 {
-	struct qdio_buffer_element *sbale;
 	struct zfcp_qdio *qdio = erp_action->adapter->qdio;
 	struct zfcp_port *port = erp_action->port;
 	struct zfcp_fsf_req *req;
@@ -1496,6 +1466,7 @@ int zfcp_fsf_open_port(struct zfcp_erp_a
 		goto out;
 
 	req = zfcp_fsf_req_create(qdio, FSF_QTCB_OPEN_PORT_WITH_DID,
+				  SBAL_FLAGS0_TYPE_READ,
 				  qdio->adapter->pool.erp_req);
 
 	if (IS_ERR(req)) {
@@ -1504,9 +1475,7 @@ int zfcp_fsf_open_port(struct zfcp_erp_a
 	}
 
 	req->status |= ZFCP_STATUS_FSFREQ_CLEANUP;
-	sbale = zfcp_qdio_sbale_req(qdio, &req->qdio_req);
-        sbale[0].flags |= SBAL_FLAGS0_TYPE_READ;
-        sbale[1].flags |= SBAL_FLAGS_LAST_ENTRY;
+	zfcp_qdio_set_sbale_last(qdio, &req->qdio_req);
 
 	req->handler = zfcp_fsf_open_port_handler;
 	hton24(req->qtcb->bottom.support.d_id, port->d_id);
@@ -1556,7 +1525,6 @@ static void zfcp_fsf_close_port_handler(
  */
 int zfcp_fsf_close_port(struct zfcp_erp_action *erp_action)
 {
-	struct qdio_buffer_element *sbale;
 	struct zfcp_qdio *qdio = erp_action->adapter->qdio;
 	struct zfcp_fsf_req *req;
 	int retval = -EIO;
@@ -1566,6 +1534,7 @@ int zfcp_fsf_close_port(struct zfcp_erp_
 		goto out;
 
 	req = zfcp_fsf_req_create(qdio, FSF_QTCB_CLOSE_PORT,
+				  SBAL_FLAGS0_TYPE_READ,
 				  qdio->adapter->pool.erp_req);
 
 	if (IS_ERR(req)) {
@@ -1574,9 +1543,7 @@ int zfcp_fsf_close_port(struct zfcp_erp_
 	}
 
 	req->status |= ZFCP_STATUS_FSFREQ_CLEANUP;
-	sbale = zfcp_qdio_sbale_req(qdio, &req->qdio_req);
-	sbale[0].flags |= SBAL_FLAGS0_TYPE_READ;
-	sbale[1].flags |= SBAL_FLAGS_LAST_ENTRY;
+	zfcp_qdio_set_sbale_last(qdio, &req->qdio_req);
 
 	req->handler = zfcp_fsf_close_port_handler;
 	req->data = erp_action->port;
@@ -1633,7 +1600,6 @@ out:
  */
 int zfcp_fsf_open_wka_port(struct zfcp_fc_wka_port *wka_port)
 {
-	struct qdio_buffer_element *sbale;
 	struct zfcp_qdio *qdio = wka_port->adapter->qdio;
 	struct zfcp_fsf_req *req;
 	int retval = -EIO;
@@ -1643,6 +1609,7 @@ int zfcp_fsf_open_wka_port(struct zfcp_f
 		goto out;
 
 	req = zfcp_fsf_req_create(qdio, FSF_QTCB_OPEN_PORT_WITH_DID,
+				  SBAL_FLAGS0_TYPE_READ,
 				  qdio->adapter->pool.erp_req);
 
 	if (unlikely(IS_ERR(req))) {
@@ -1651,9 +1618,7 @@ int zfcp_fsf_open_wka_port(struct zfcp_f
 	}
 
 	req->status |= ZFCP_STATUS_FSFREQ_CLEANUP;
-	sbale = zfcp_qdio_sbale_req(qdio, &req->qdio_req);
-	sbale[0].flags |= SBAL_FLAGS0_TYPE_READ;
-	sbale[1].flags |= SBAL_FLAGS_LAST_ENTRY;
+	zfcp_qdio_set_sbale_last(qdio, &req->qdio_req);
 
 	req->handler = zfcp_fsf_open_wka_port_handler;
 	hton24(req->qtcb->bottom.support.d_id, wka_port->d_id);
@@ -1688,7 +1653,6 @@ static void zfcp_fsf_close_wka_port_hand
  */
 int zfcp_fsf_close_wka_port(struct zfcp_fc_wka_port *wka_port)
 {
-	struct qdio_buffer_element *sbale;
 	struct zfcp_qdio *qdio = wka_port->adapter->qdio;
 	struct zfcp_fsf_req *req;
 	int retval = -EIO;
@@ -1698,6 +1662,7 @@ int zfcp_fsf_close_wka_port(struct zfcp_
 		goto out;
 
 	req = zfcp_fsf_req_create(qdio, FSF_QTCB_CLOSE_PORT,
+				  SBAL_FLAGS0_TYPE_READ,
 				  qdio->adapter->pool.erp_req);
 
 	if (unlikely(IS_ERR(req))) {
@@ -1706,9 +1671,7 @@ int zfcp_fsf_close_wka_port(struct zfcp_
 	}
 
 	req->status |= ZFCP_STATUS_FSFREQ_CLEANUP;
-	sbale = zfcp_qdio_sbale_req(qdio, &req->qdio_req);
-	sbale[0].flags |= SBAL_FLAGS0_TYPE_READ;
-	sbale[1].flags |= SBAL_FLAGS_LAST_ENTRY;
+	zfcp_qdio_set_sbale_last(qdio, &req->qdio_req);
 
 	req->handler = zfcp_fsf_close_wka_port_handler;
 	req->data = wka_port;
@@ -1782,7 +1745,6 @@ static void zfcp_fsf_close_physical_port
  */
 int zfcp_fsf_close_physical_port(struct zfcp_erp_action *erp_action)
 {
-	struct qdio_buffer_element *sbale;
 	struct zfcp_qdio *qdio = erp_action->adapter->qdio;
 	struct zfcp_fsf_req *req;
 	int retval = -EIO;
@@ -1792,6 +1754,7 @@ int zfcp_fsf_close_physical_port(struct 
 		goto out;
 
 	req = zfcp_fsf_req_create(qdio, FSF_QTCB_CLOSE_PHYSICAL_PORT,
+				  SBAL_FLAGS0_TYPE_READ,
 				  qdio->adapter->pool.erp_req);
 
 	if (IS_ERR(req)) {
@@ -1800,9 +1763,7 @@ int zfcp_fsf_close_physical_port(struct 
 	}
 
 	req->status |= ZFCP_STATUS_FSFREQ_CLEANUP;
-	sbale = zfcp_qdio_sbale_req(qdio, &req->qdio_req);
-	sbale[0].flags |= SBAL_FLAGS0_TYPE_READ;
-	sbale[1].flags |= SBAL_FLAGS_LAST_ENTRY;
+	zfcp_qdio_set_sbale_last(qdio, &req->qdio_req);
 
 	req->data = erp_action->port;
 	req->qtcb->header.port_handle = erp_action->port->handle;
@@ -1954,7 +1915,6 @@ static void zfcp_fsf_open_unit_handler(s
  */
 int zfcp_fsf_open_unit(struct zfcp_erp_action *erp_action)
 {
-	struct qdio_buffer_element *sbale;
 	struct zfcp_adapter *adapter = erp_action->adapter;
 	struct zfcp_qdio *qdio = adapter->qdio;
 	struct zfcp_fsf_req *req;
@@ -1965,6 +1925,7 @@ int zfcp_fsf_open_unit(struct zfcp_erp_a
 		goto out;
 
 	req = zfcp_fsf_req_create(qdio, FSF_QTCB_OPEN_LUN,
+				  SBAL_FLAGS0_TYPE_READ,
 				  adapter->pool.erp_req);
 
 	if (IS_ERR(req)) {
@@ -1973,9 +1934,7 @@ int zfcp_fsf_open_unit(struct zfcp_erp_a
 	}
 
 	req->status |= ZFCP_STATUS_FSFREQ_CLEANUP;
-	sbale = zfcp_qdio_sbale_req(qdio, &req->qdio_req);
-        sbale[0].flags |= SBAL_FLAGS0_TYPE_READ;
-        sbale[1].flags |= SBAL_FLAGS_LAST_ENTRY;
+	zfcp_qdio_set_sbale_last(qdio, &req->qdio_req);
 
 	req->qtcb->header.port_handle = erp_action->port->handle;
 	req->qtcb->bottom.support.fcp_lun = erp_action->unit->fcp_lun;
@@ -2041,7 +2000,6 @@ static void zfcp_fsf_close_unit_handler(
  */
 int zfcp_fsf_close_unit(struct zfcp_erp_action *erp_action)
 {
-	struct qdio_buffer_element *sbale;
 	struct zfcp_qdio *qdio = erp_action->adapter->qdio;
 	struct zfcp_fsf_req *req;
 	int retval = -EIO;
@@ -2051,6 +2009,7 @@ int zfcp_fsf_close_unit(struct zfcp_erp_
 		goto out;
 
 	req = zfcp_fsf_req_create(qdio, FSF_QTCB_CLOSE_LUN,
+				  SBAL_FLAGS0_TYPE_READ,
 				  qdio->adapter->pool.erp_req);
 
 	if (IS_ERR(req)) {
@@ -2059,9 +2018,7 @@ int zfcp_fsf_close_unit(struct zfcp_erp_
 	}
 
 	req->status |= ZFCP_STATUS_FSFREQ_CLEANUP;
-	sbale = zfcp_qdio_sbale_req(qdio, &req->qdio_req);
-	sbale[0].flags |= SBAL_FLAGS0_TYPE_READ;
-	sbale[1].flags |= SBAL_FLAGS_LAST_ENTRY;
+	zfcp_qdio_set_sbale_last(qdio, &req->qdio_req);
 
 	req->qtcb->header.port_handle = erp_action->port->handle;
 	req->qtcb->header.lun_handle = erp_action->unit->handle;
@@ -2289,8 +2246,11 @@ int zfcp_fsf_send_fcp_command_task(struc
 		goto out;
 	}
 
+	if (scsi_cmnd->sc_data_direction == DMA_TO_DEVICE)
+		sbtype = SBAL_FLAGS0_TYPE_WRITE;
+
 	req = zfcp_fsf_req_create(qdio, FSF_QTCB_FCP_CMND,
-				  adapter->pool.scsi_req);
+				  sbtype, adapter->pool.scsi_req);
 
 	if (IS_ERR(req)) {
 		retval = PTR_ERR(req);
@@ -2298,7 +2258,6 @@ int zfcp_fsf_send_fcp_command_task(struc
 	}
 
 	req->status |= ZFCP_STATUS_FSFREQ_CLEANUP;
-	get_device(&unit->dev);
 	req->unit = unit;
 	req->data = scsi_cmnd;
 	req->handler = zfcp_fsf_send_fcp_command_handler;
@@ -2323,20 +2282,21 @@ int zfcp_fsf_send_fcp_command_task(struc
 		break;
 	case DMA_TO_DEVICE:
 		req->qtcb->bottom.io.data_direction = FSF_DATADIR_WRITE;
-		sbtype = SBAL_FLAGS0_TYPE_WRITE;
 		break;
 	case DMA_BIDIRECTIONAL:
 		goto failed_scsi_cmnd;
 	}
 
+	get_device(&unit->dev);
+
 	fcp_cmnd = (struct fcp_cmnd *) &req->qtcb->bottom.io.fcp_cmnd;
 	zfcp_fc_scsi_to_fcp(fcp_cmnd, scsi_cmnd);
 
-	real_bytes = zfcp_qdio_sbals_from_sg(qdio, &req->qdio_req, sbtype,
+	real_bytes = zfcp_qdio_sbals_from_sg(qdio, &req->qdio_req,
 					     scsi_sglist(scsi_cmnd),
-					     FSF_MAX_SBALS_PER_REQ);
+					     ZFCP_FSF_MAX_SBALS_PER_REQ);
 	if (unlikely(real_bytes < 0)) {
-		if (req->qdio_req.sbal_number >= FSF_MAX_SBALS_PER_REQ) {
+		if (req->qdio_req.sbal_number >= ZFCP_FSF_MAX_SBALS_PER_REQ) {
 			dev_err(&adapter->ccw_device->dev,
 				"Oversize data package, unit 0x%016Lx "
 				"on port 0x%016Lx closed\n",
@@ -2371,7 +2331,6 @@ out:
  */
 struct zfcp_fsf_req *zfcp_fsf_send_fcp_ctm(struct zfcp_unit *unit, u8 tm_flags)
 {
-	struct qdio_buffer_element *sbale;
 	struct zfcp_fsf_req *req = NULL;
 	struct fcp_cmnd *fcp_cmnd;
 	struct zfcp_qdio *qdio = unit->port->adapter->qdio;
@@ -2385,6 +2344,7 @@ struct zfcp_fsf_req *zfcp_fsf_send_fcp_c
 		goto out;
 
 	req = zfcp_fsf_req_create(qdio, FSF_QTCB_FCP_CMND,
+				  SBAL_FLAGS0_TYPE_WRITE,
 				  qdio->adapter->pool.scsi_req);
 
 	if (IS_ERR(req)) {
@@ -2401,9 +2361,7 @@ struct zfcp_fsf_req *zfcp_fsf_send_fcp_c
 	req->qtcb->bottom.io.service_class = FSF_CLASS_3;
 	req->qtcb->bottom.io.fcp_cmnd_length = FCP_CMND_LEN;
 
-	sbale = zfcp_qdio_sbale_req(qdio, &req->qdio_req);
-	sbale[0].flags |= SBAL_FLAGS0_TYPE_WRITE;
-	sbale[1].flags |= SBAL_FLAGS_LAST_ENTRY;
+	zfcp_qdio_set_sbale_last(qdio, &req->qdio_req);
 
 	fcp_cmnd = (struct fcp_cmnd *) &req->qtcb->bottom.io.fcp_cmnd;
 	zfcp_fc_fcp_tm(fcp_cmnd, unit->device, tm_flags);
@@ -2432,7 +2390,6 @@ static void zfcp_fsf_control_file_handle
 struct zfcp_fsf_req *zfcp_fsf_control_file(struct zfcp_adapter *adapter,
 					   struct zfcp_fsf_cfdc *fsf_cfdc)
 {
-	struct qdio_buffer_element *sbale;
 	struct zfcp_qdio *qdio = adapter->qdio;
 	struct zfcp_fsf_req *req = NULL;
 	struct fsf_qtcb_bottom_support *bottom;
@@ -2456,7 +2413,7 @@ struct zfcp_fsf_req *zfcp_fsf_control_fi
 	if (zfcp_fsf_req_sbal_get(qdio))
 		goto out;
 
-	req = zfcp_fsf_req_create(qdio, fsf_cfdc->command, NULL);
+	req = zfcp_fsf_req_create(qdio, fsf_cfdc->command, direction, NULL);
 	if (IS_ERR(req)) {
 		retval = -EPERM;
 		goto out;
@@ -2464,16 +2421,13 @@ struct zfcp_fsf_req *zfcp_fsf_control_fi
 
 	req->handler = zfcp_fsf_control_file_handler;
 
-	sbale = zfcp_qdio_sbale_req(qdio, &req->qdio_req);
-	sbale[0].flags |= direction;
-
 	bottom = &req->qtcb->bottom.support;
 	bottom->operation_subtype = FSF_CFDC_OPERATION_SUBTYPE;
 	bottom->option = fsf_cfdc->option;
 
 	bytes = zfcp_qdio_sbals_from_sg(qdio, &req->qdio_req,
-					direction, fsf_cfdc->sg,
-					FSF_MAX_SBALS_PER_REQ);
+					fsf_cfdc->sg,
+					ZFCP_FSF_MAX_SBALS_PER_REQ);
 	if (bytes != ZFCP_CFDC_MAX_SIZE) {
 		zfcp_fsf_req_free(req);
 		goto out;
--- a/drivers/s390/scsi/zfcp_fsf.h	2010-04-30 16:00:37.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_fsf.h	2010-04-30 16:00:44.000000000 +0200
@@ -3,7 +3,7 @@
  *
  * Interface to the FSF support functions.
  *
- * Copyright IBM Corporation 2002, 2009
+ * Copyright IBM Corporation 2002, 2010
  */
 
 #ifndef FSF_H
@@ -152,7 +152,12 @@
 #define FSF_CLASS_3				0x00000003
 
 /* SBAL chaining */
-#define FSF_MAX_SBALS_PER_REQ			36
+#define ZFCP_FSF_MAX_SBALS_PER_REQ		36
+
+/* max. number of (data buffer) SBALEs in largest SBAL chain
+ * request ID + QTCB in SBALE 0 + 1 of first SBAL in chain   */
+#define ZFCP_FSF_MAX_SBALES_PER_REQ	\
+	(ZFCP_FSF_MAX_SBALS_PER_REQ * ZFCP_QDIO_MAX_SBALES_PER_SBAL - 2)
 
 /* logging space behind QTCB */
 #define FSF_QTCB_LOG_SIZE			1024
--- a/drivers/s390/scsi/zfcp_qdio.c	2010-04-30 16:00:39.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_qdio.c	2010-04-30 16:00:44.000000000 +0200
@@ -3,7 +3,7 @@
  *
  * Setup and helper functions to access QDIO.
  *
- * Copyright IBM Corporation 2002, 2009
+ * Copyright IBM Corporation 2002, 2010
  */
 
 #define KMSG_COMPONENT "zfcp"
@@ -151,8 +151,7 @@ static void zfcp_qdio_sbal_limit(struct 
 }
 
 static struct qdio_buffer_element *
-zfcp_qdio_sbal_chain(struct zfcp_qdio *qdio, struct zfcp_qdio_req *q_req,
-		     unsigned long sbtype)
+zfcp_qdio_sbal_chain(struct zfcp_qdio *qdio, struct zfcp_qdio_req *q_req)
 {
 	struct qdio_buffer_element *sbale;
 
@@ -180,17 +179,16 @@ zfcp_qdio_sbal_chain(struct zfcp_qdio *q
 
 	/* set storage-block type for new SBAL */
 	sbale = zfcp_qdio_sbale_curr(qdio, q_req);
-	sbale->flags |= sbtype;
+	sbale->flags |= q_req->sbtype;
 
 	return sbale;
 }
 
 static struct qdio_buffer_element *
-zfcp_qdio_sbale_next(struct zfcp_qdio *qdio, struct zfcp_qdio_req *q_req,
-		     unsigned int sbtype)
+zfcp_qdio_sbale_next(struct zfcp_qdio *qdio, struct zfcp_qdio_req *q_req)
 {
-	if (q_req->sbale_curr == ZFCP_LAST_SBALE_PER_SBAL)
-		return zfcp_qdio_sbal_chain(qdio, q_req, sbtype);
+	if (q_req->sbale_curr == ZFCP_QDIO_LAST_SBALE_PER_SBAL)
+		return zfcp_qdio_sbal_chain(qdio, q_req);
 	q_req->sbale_curr++;
 	return zfcp_qdio_sbale_curr(qdio, q_req);
 }
@@ -208,15 +206,14 @@ static void zfcp_qdio_undo_sbals(struct 
 
 /**
  * zfcp_qdio_sbals_from_sg - fill SBALs from scatter-gather list
- * @fsf_req: request to be processed
- * @sbtype: SBALE flags
+ * @qdio: pointer to struct zfcp_qdio
+ * @q_req: pointer to struct zfcp_qdio_req
  * @sg: scatter-gather list
  * @max_sbals: upper bound for number of SBALs to be used
  * Returns: number of bytes, or error (negativ)
  */
 int zfcp_qdio_sbals_from_sg(struct zfcp_qdio *qdio, struct zfcp_qdio_req *q_req,
-			    unsigned long sbtype, struct scatterlist *sg,
-			    int max_sbals)
+			    struct scatterlist *sg, int max_sbals)
 {
 	struct qdio_buffer_element *sbale;
 	int bytes = 0;
@@ -226,10 +223,10 @@ int zfcp_qdio_sbals_from_sg(struct zfcp_
 
 	/* set storage-block type for this request */
 	sbale = zfcp_qdio_sbale_req(qdio, q_req);
-	sbale->flags |= sbtype;
+	sbale->flags |= q_req->sbtype;
 
 	for (; sg; sg = sg_next(sg)) {
-		sbale = zfcp_qdio_sbale_next(qdio, q_req, sbtype);
+		sbale = zfcp_qdio_sbale_next(qdio, q_req);
 		if (!sbale) {
 			atomic_inc(&qdio->req_q_full);
 			zfcp_qdio_undo_sbals(qdio, q_req);
--- a/drivers/s390/scsi/zfcp_qdio.h	2010-04-30 16:00:39.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_qdio.h	2010-04-30 16:00:44.000000000 +0200
@@ -13,6 +13,12 @@
 
 #define ZFCP_QDIO_SBALE_LEN	PAGE_SIZE
 
+/* DMQ bug workaround: don't use last SBALE */
+#define ZFCP_QDIO_MAX_SBALES_PER_SBAL	(QDIO_MAX_ELEMENTS_PER_BUFFER - 1)
+
+/* index of last SBALE (with respect to DMQ bug workaround) */
+#define ZFCP_QDIO_LAST_SBALE_PER_SBAL	(ZFCP_QDIO_MAX_SBALES_PER_SBAL - 1)
+
 /**
  * struct zfcp_qdio_queue - qdio queue buffer, zfcp index and free count
  * @sbal: qdio buffers
@@ -51,6 +57,7 @@ struct zfcp_qdio {
 
 /**
  * struct zfcp_qdio_req - qdio queue related values for a request
+ * @sbtype: sbal type flags for sbale 0
  * @sbal_number: number of free sbals
  * @sbal_first: first sbal for this request
  * @sbal_last: last sbal for this request
@@ -61,6 +68,7 @@ struct zfcp_qdio {
  * @qdio_inb_usage: usage of inbound queue
  */
 struct zfcp_qdio_req {
+	u32	sbtype;
 	u8	sbal_number;
 	u8	sbal_first;
 	u8	sbal_last;
@@ -108,4 +116,98 @@ zfcp_qdio_sbale_curr(struct zfcp_qdio *q
 			       q_req->sbale_curr);
 }
 
+/**
+ * zfcp_qdio_req_init - initialize qdio request
+ * @qdio: request queue where to start putting the request
+ * @q_req: the qdio request to start
+ * @req_id: The request id
+ * @sbtype: type flags to set for all sbals
+ * @data: First data block
+ * @len: Length of first data block
+ *
+ * This is the start of putting the request into the queue, the last
+ * step is passing the request to zfcp_qdio_send. The request queue
+ * lock must be held during the whole process from init to send.
+ */
+static inline
+void zfcp_qdio_req_init(struct zfcp_qdio *qdio, struct zfcp_qdio_req *q_req,
+			unsigned long req_id, u32 sbtype, void *data, u32 len)
+{
+	struct qdio_buffer_element *sbale;
+
+	q_req->sbal_first = q_req->sbal_last = qdio->req_q.first;
+	q_req->sbal_number = 1;
+	q_req->sbtype = sbtype;
+
+	sbale = zfcp_qdio_sbale_req(qdio, q_req);
+	sbale->addr = (void *) req_id;
+	sbale->flags |= SBAL_FLAGS0_COMMAND;
+	sbale->flags |= sbtype;
+
+	q_req->sbale_curr = 1;
+	sbale++;
+	sbale->addr = data;
+	if (likely(data))
+		sbale->length = len;
+}
+
+/**
+ * zfcp_qdio_fill_next - Fill next sbale, only for single sbal requests
+ * @qdio: pointer to struct zfcp_qdio
+ * @q_req: pointer to struct zfcp_queue_req
+ *
+ * This is only required for single sbal requests, calling it when
+ * wrapping around to the next sbal is a bug.
+ */
+static inline
+void zfcp_qdio_fill_next(struct zfcp_qdio *qdio, struct zfcp_qdio_req *q_req,
+			 void *data, u32 len)
+{
+	struct qdio_buffer_element *sbale;
+
+	BUG_ON(q_req->sbale_curr == ZFCP_QDIO_LAST_SBALE_PER_SBAL);
+	q_req->sbale_curr++;
+	sbale = zfcp_qdio_sbale_curr(qdio, q_req);
+	sbale->addr = data;
+	sbale->length = len;
+}
+
+/**
+ * zfcp_qdio_set_sbale_last - set last entry flag in current sbale
+ * @qdio: pointer to struct zfcp_qdio
+ * @q_req: pointer to struct zfcp_queue_req
+ */
+static inline
+void zfcp_qdio_set_sbale_last(struct zfcp_qdio *qdio,
+			      struct zfcp_qdio_req *q_req)
+{
+	struct qdio_buffer_element *sbale;
+
+	sbale = zfcp_qdio_sbale_curr(qdio, q_req);
+	sbale->flags |= SBAL_FLAGS_LAST_ENTRY;
+}
+
+/**
+ * zfcp_qdio_sg_one_sbal - check if one sbale is enough for sg data
+ * @sg: The scatterlist where to check the data size
+ *
+ * Returns: 1 when one sbale is enough for the data in the scatterlist,
+ *	    0 if not.
+ */
+static inline
+int zfcp_qdio_sg_one_sbale(struct scatterlist *sg)
+{
+	return sg_is_last(sg) && sg->length <= ZFCP_QDIO_SBALE_LEN;
+}
+
+/**
+ * zfcp_qdio_skip_to_last_sbale - skip to last sbale in sbal
+ * @q_req: The current zfcp_qdio_req
+ */
+static inline
+void zfcp_qdio_skip_to_last_sbale(struct zfcp_qdio_req *q_req)
+{
+	q_req->sbale_curr = ZFCP_QDIO_LAST_SBALE_PER_SBAL;
+}
+
 #endif /* ZFCP_QDIO_H */
--- a/drivers/s390/scsi/zfcp_scsi.c	2010-04-30 16:00:39.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_scsi.c	2010-04-30 16:00:44.000000000 +0200
@@ -677,11 +677,11 @@ struct zfcp_data zfcp_data = {
 		.eh_host_reset_handler	 = zfcp_scsi_eh_host_reset_handler,
 		.can_queue		 = 4096,
 		.this_id		 = -1,
-		.sg_tablesize		 = ZFCP_MAX_SBALES_PER_REQ,
+		.sg_tablesize		 = ZFCP_FSF_MAX_SBALES_PER_REQ,
 		.cmd_per_lun		 = 1,
 		.use_clustering		 = 1,
 		.sdev_attrs		 = zfcp_sysfs_sdev_attrs,
-		.max_sectors		 = (ZFCP_MAX_SBALES_PER_REQ * 8),
+		.max_sectors		 = (ZFCP_FSF_MAX_SBALES_PER_REQ * 8),
 		.dma_boundary		 = ZFCP_QDIO_SBALE_LEN - 1,
 		.shost_attrs		 = zfcp_sysfs_shost_attrs,
 	},


From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 04/10] zfcp: Cleanup function parameters for sbal value.
Date: Fri, 16 Jul 2010 15:37:37 +0200
Message-ID: <20100716134300.292446000@de.ibm.com>
References: <20100716133733.621672000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate1.de.ibm.com ([195.212.17.161]:48013 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965492Ab0GPNnC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Jul 2010 09:43:02 -0400
Content-Disposition: inline; filename=707-zfcp-sbal-cleanup.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Swen Schillig <swen@vnet.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Swen Schillig <swen@vnet.ibm.com>

A lot of functions require the amount of SBALs as one of their
parameter which is most times invariable.  Therefore remove this
parameter and set the SBAL value explicitly if a non standard value is
required.  In addition the warning message "oversized data" is
replaced with a BUG_ON() statement assuring the limits defined and
requested by zfcp.

Signed-off-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_ext.h  |    2 +-
 drivers/s390/scsi/zfcp_fsf.c  |   40 ++++++++++++++--------------------------
 drivers/s390/scsi/zfcp_fsf.h  |    8 --------
 drivers/s390/scsi/zfcp_qdio.c |   15 ++-------------
 drivers/s390/scsi/zfcp_qdio.h |   28 ++++++++++++++++++++++++++++
 drivers/s390/scsi/zfcp_scsi.c |    4 ++--
 6 files changed, 47 insertions(+), 50 deletions(-)

--- a/drivers/s390/scsi/zfcp_ext.h
+++ b/drivers/s390/scsi/zfcp_ext.h
@@ -146,7 +146,7 @@ extern void zfcp_qdio_destroy(struct zfc
 extern int zfcp_qdio_sbal_get(struct zfcp_qdio *);
 extern int zfcp_qdio_send(struct zfcp_qdio *, struct zfcp_qdio_req *);
 extern int zfcp_qdio_sbals_from_sg(struct zfcp_qdio *, struct zfcp_qdio_req *,
-				   struct scatterlist *, int);
+				   struct scatterlist *);
 extern int zfcp_qdio_open(struct zfcp_qdio *);
 extern void zfcp_qdio_close(struct zfcp_qdio *);
 
--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -959,8 +959,7 @@ static void zfcp_fsf_setup_ct_els_unchai
 
 static int zfcp_fsf_setup_ct_els_sbals(struct zfcp_fsf_req *req,
 				       struct scatterlist *sg_req,
-				       struct scatterlist *sg_resp,
-				       int max_sbals)
+				       struct scatterlist *sg_resp)
 {
 	struct zfcp_adapter *adapter = req->adapter;
 	u32 feat = adapter->adapter_features;
@@ -983,15 +982,14 @@ static int zfcp_fsf_setup_ct_els_sbals(s
 		return 0;
 	}
 
-	bytes = zfcp_qdio_sbals_from_sg(adapter->qdio, &req->qdio_req,
-					sg_req, max_sbals);
+	bytes = zfcp_qdio_sbals_from_sg(adapter->qdio, &req->qdio_req, sg_req);
 	if (bytes <= 0)
 		return -EIO;
 	req->qtcb->bottom.support.req_buf_length = bytes;
 	zfcp_qdio_skip_to_last_sbale(&req->qdio_req);
 
 	bytes = zfcp_qdio_sbals_from_sg(adapter->qdio, &req->qdio_req,
-					sg_resp, max_sbals);
+					sg_resp);
 	req->qtcb->bottom.support.resp_buf_length = bytes;
 	if (bytes <= 0)
 		return -EIO;
@@ -1002,11 +1000,11 @@ static int zfcp_fsf_setup_ct_els_sbals(s
 static int zfcp_fsf_setup_ct_els(struct zfcp_fsf_req *req,
 				 struct scatterlist *sg_req,
 				 struct scatterlist *sg_resp,
-				 int max_sbals, unsigned int timeout)
+				 unsigned int timeout)
 {
 	int ret;
 
-	ret = zfcp_fsf_setup_ct_els_sbals(req, sg_req, sg_resp, max_sbals);
+	ret = zfcp_fsf_setup_ct_els_sbals(req, sg_req, sg_resp);
 	if (ret)
 		return ret;
 
@@ -1046,8 +1044,7 @@ int zfcp_fsf_send_ct(struct zfcp_fc_wka_
 	}
 
 	req->status |= ZFCP_STATUS_FSFREQ_CLEANUP;
-	ret = zfcp_fsf_setup_ct_els(req, ct->req, ct->resp,
-				    ZFCP_FSF_MAX_SBALS_PER_REQ, timeout);
+	ret = zfcp_fsf_setup_ct_els(req, ct->req, ct->resp, timeout);
 	if (ret)
 		goto failed_send;
 
@@ -1143,7 +1140,10 @@ int zfcp_fsf_send_els(struct zfcp_adapte
 	}
 
 	req->status |= ZFCP_STATUS_FSFREQ_CLEANUP;
-	ret = zfcp_fsf_setup_ct_els(req, els->req, els->resp, 2, timeout);
+
+	zfcp_qdio_sbal_limit(qdio, &req->qdio_req, 2);
+
+	ret = zfcp_fsf_setup_ct_els(req, els->req, els->resp, timeout);
 
 	if (ret)
 		goto failed_send;
@@ -2259,20 +2259,9 @@ int zfcp_fsf_send_fcp_command_task(struc
 	zfcp_fc_scsi_to_fcp(fcp_cmnd, scsi_cmnd);
 
 	real_bytes = zfcp_qdio_sbals_from_sg(qdio, &req->qdio_req,
-					     scsi_sglist(scsi_cmnd),
-					     ZFCP_FSF_MAX_SBALS_PER_REQ);
-	if (unlikely(real_bytes < 0)) {
-		if (req->qdio_req.sbal_number >= ZFCP_FSF_MAX_SBALS_PER_REQ) {
-			dev_err(&adapter->ccw_device->dev,
-				"Oversize data package, unit 0x%016Lx "
-				"on port 0x%016Lx closed\n",
-				(unsigned long long)unit->fcp_lun,
-				(unsigned long long)unit->port->wwpn);
-			zfcp_erp_unit_shutdown(unit, 0, "fssfct1", req);
-			retval = -EINVAL;
-		}
+					     scsi_sglist(scsi_cmnd));
+	if (unlikely(real_bytes < 0))
 		goto failed_scsi_cmnd;
-	}
 
 	retval = zfcp_fsf_req_send(req);
 	if (unlikely(retval))
@@ -2391,9 +2380,8 @@ struct zfcp_fsf_req *zfcp_fsf_control_fi
 	bottom->operation_subtype = FSF_CFDC_OPERATION_SUBTYPE;
 	bottom->option = fsf_cfdc->option;
 
-	bytes = zfcp_qdio_sbals_from_sg(qdio, &req->qdio_req,
-					fsf_cfdc->sg,
-					ZFCP_FSF_MAX_SBALS_PER_REQ);
+	bytes = zfcp_qdio_sbals_from_sg(qdio, &req->qdio_req, fsf_cfdc->sg);
+
 	if (bytes != ZFCP_CFDC_MAX_SIZE) {
 		zfcp_fsf_req_free(req);
 		goto out;
--- a/drivers/s390/scsi/zfcp_fsf.h
+++ b/drivers/s390/scsi/zfcp_fsf.h
@@ -151,14 +151,6 @@
 /* fc service class */
 #define FSF_CLASS_3				0x00000003
 
-/* SBAL chaining */
-#define ZFCP_FSF_MAX_SBALS_PER_REQ		36
-
-/* max. number of (data buffer) SBALEs in largest SBAL chain
- * request ID + QTCB in SBALE 0 + 1 of first SBAL in chain   */
-#define ZFCP_FSF_MAX_SBALES_PER_REQ	\
-	(ZFCP_FSF_MAX_SBALS_PER_REQ * ZFCP_QDIO_MAX_SBALES_PER_SBAL - 2)
-
 /* logging space behind QTCB */
 #define FSF_QTCB_LOG_SIZE			1024
 
--- a/drivers/s390/scsi/zfcp_qdio.c
+++ b/drivers/s390/scsi/zfcp_qdio.c
@@ -141,15 +141,6 @@ static void zfcp_qdio_int_resp(struct cc
 	zfcp_qdio_resp_put_back(qdio, count);
 }
 
-static void zfcp_qdio_sbal_limit(struct zfcp_qdio *qdio,
-				 struct zfcp_qdio_req *q_req, int max_sbals)
-{
-	int count = atomic_read(&qdio->req_q.count);
-	count = min(count, max_sbals);
-	q_req->sbal_limit = (q_req->sbal_first + count - 1)
-					% QDIO_MAX_BUFFERS_PER_Q;
-}
-
 static struct qdio_buffer_element *
 zfcp_qdio_sbal_chain(struct zfcp_qdio *qdio, struct zfcp_qdio_req *q_req)
 {
@@ -173,6 +164,7 @@ zfcp_qdio_sbal_chain(struct zfcp_qdio *q
 
 	/* keep this requests number of SBALs up-to-date */
 	q_req->sbal_number++;
+	BUG_ON(q_req->sbal_number > ZFCP_QDIO_MAX_SBALS_PER_REQ);
 
 	/* start at first SBALE of new SBAL */
 	q_req->sbale_curr = 0;
@@ -213,14 +205,11 @@ static void zfcp_qdio_undo_sbals(struct 
  * Returns: number of bytes, or error (negativ)
  */
 int zfcp_qdio_sbals_from_sg(struct zfcp_qdio *qdio, struct zfcp_qdio_req *q_req,
-			    struct scatterlist *sg, int max_sbals)
+			    struct scatterlist *sg)
 {
 	struct qdio_buffer_element *sbale;
 	int bytes = 0;
 
-	/* figure out last allowed SBAL */
-	zfcp_qdio_sbal_limit(qdio, q_req, max_sbals);
-
 	/* set storage-block type for this request */
 	sbale = zfcp_qdio_sbale_req(qdio, q_req);
 	sbale->flags |= q_req->sbtype;
--- a/drivers/s390/scsi/zfcp_qdio.h
+++ b/drivers/s390/scsi/zfcp_qdio.h
@@ -19,6 +19,14 @@
 /* index of last SBALE (with respect to DMQ bug workaround) */
 #define ZFCP_QDIO_LAST_SBALE_PER_SBAL	(ZFCP_QDIO_MAX_SBALES_PER_SBAL - 1)
 
+/* Max SBALS for chaining */
+#define ZFCP_QDIO_MAX_SBALS_PER_REQ	36
+
+/* max. number of (data buffer) SBALEs in largest SBAL chain
+ * request ID + QTCB in SBALE 0 + 1 of first SBAL in chain   */
+#define ZFCP_QDIO_MAX_SBALES_PER_REQ     \
+	(ZFCP_QDIO_MAX_SBALS_PER_REQ * ZFCP_QDIO_MAX_SBALES_PER_SBAL - 2)
+
 /**
  * struct zfcp_qdio_queue - qdio queue buffer, zfcp index and free count
  * @sbal: qdio buffers
@@ -134,10 +142,14 @@ void zfcp_qdio_req_init(struct zfcp_qdio
 			unsigned long req_id, u32 sbtype, void *data, u32 len)
 {
 	struct qdio_buffer_element *sbale;
+	int count = min(atomic_read(&qdio->req_q.count),
+			ZFCP_QDIO_MAX_SBALS_PER_REQ);
 
 	q_req->sbal_first = q_req->sbal_last = qdio->req_q.first;
 	q_req->sbal_number = 1;
 	q_req->sbtype = sbtype;
+	q_req->sbal_limit = (q_req->sbal_first + count - 1)
+					% QDIO_MAX_BUFFERS_PER_Q;
 
 	sbale = zfcp_qdio_sbale_req(qdio, q_req);
 	sbale->addr = (void *) req_id;
@@ -210,4 +222,20 @@ void zfcp_qdio_skip_to_last_sbale(struct
 	q_req->sbale_curr = ZFCP_QDIO_LAST_SBALE_PER_SBAL;
 }
 
+/**
+ * zfcp_qdio_sbal_limit - set the sbal limit for a request in q_req
+ * @qdio: pointer to struct zfcp_qdio
+ * @q_req: The current zfcp_qdio_req
+ * @max_sbals: maximum number of SBALs allowed
+ */
+static inline
+void zfcp_qdio_sbal_limit(struct zfcp_qdio *qdio,
+			  struct zfcp_qdio_req *q_req, int max_sbals)
+{
+	int count = min(atomic_read(&qdio->req_q.count), max_sbals);
+
+	q_req->sbal_limit = (q_req->sbal_first + count - 1) %
+				QDIO_MAX_BUFFERS_PER_Q;
+}
+
 #endif /* ZFCP_QDIO_H */
--- a/drivers/s390/scsi/zfcp_scsi.c
+++ b/drivers/s390/scsi/zfcp_scsi.c
@@ -701,11 +701,11 @@ struct zfcp_data zfcp_data = {
 		.eh_host_reset_handler	 = zfcp_scsi_eh_host_reset_handler,
 		.can_queue		 = 4096,
 		.this_id		 = -1,
-		.sg_tablesize		 = ZFCP_FSF_MAX_SBALES_PER_REQ,
+		.sg_tablesize		 = ZFCP_QDIO_MAX_SBALES_PER_REQ,
 		.cmd_per_lun		 = 1,
 		.use_clustering		 = 1,
 		.sdev_attrs		 = zfcp_sysfs_sdev_attrs,
-		.max_sectors		 = (ZFCP_FSF_MAX_SBALES_PER_REQ * 8),
+		.max_sectors		 = (ZFCP_QDIO_MAX_SBALES_PER_REQ * 8),
 		.dma_boundary		 = ZFCP_QDIO_SBALE_LEN - 1,
 		.shost_attrs		 = zfcp_sysfs_shost_attrs,
 	},


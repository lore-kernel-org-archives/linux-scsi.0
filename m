From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 3/3] zfcp: Set hardware timeout as requested by BSG request.
Date: Thu, 14 Jan 2010 17:19:02 +0100
Message-ID: <20100114163346.228849000@de.ibm.com>
References: <20100114161859.790342000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate5.de.ibm.com ([195.212.17.165]:60954 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756858Ab0ANQds (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Jan 2010 11:33:48 -0500
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate5.de.ibm.com (8.13.1/8.13.1) with ESMTP id o0EGXkqm003143
	for <linux-scsi@vger.kernel.org>; Thu, 14 Jan 2010 16:33:46 GMT
Received: from d12av02.megacenter.de.ibm.com (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12nrmr1607.megacenter.de.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o0EGXkZi1413250
	for <linux-scsi@vger.kernel.org>; Thu, 14 Jan 2010 17:33:46 +0100
Received: from d12av02.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av02.megacenter.de.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id o0EGXkf2022428
	for <linux-scsi@vger.kernel.org>; Thu, 14 Jan 2010 17:33:46 +0100
Content-Disposition: inline; filename=zfcp_set_timeout.patch
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, Swen Schillig <swen@vnet.ibm.com>

From: Swen Schillig <swen@vnet.ibm.com>

The hardware used with zfcp provides a timer for CT and ELS requests
instead of an abort capability for these commands. To correctly handle
the FC BSG timeouts, pass the timeout from the BSG requests to the
hardware.

Signed-off-by: Swen Schillig <swen@vnet.ibm.com>
---
 drivers/s390/scsi/zfcp_ext.h |    4 ++--
 drivers/s390/scsi/zfcp_fc.c  |   13 ++++++++-----
 drivers/s390/scsi/zfcp_fc.h  |    2 ++
 drivers/s390/scsi/zfcp_fsf.c |   19 ++++++++++---------
 4 files changed, 22 insertions(+), 16 deletions(-)

--- a/drivers/s390/scsi/zfcp_ext.h	2010-01-14 16:44:46.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_ext.h	2010-01-14 16:44:49.000000000 +0100
@@ -130,9 +130,9 @@ extern void zfcp_fsf_req_dismiss_all(str
 extern int zfcp_fsf_status_read(struct zfcp_qdio *);
 extern int zfcp_status_read_refill(struct zfcp_adapter *adapter);
 extern int zfcp_fsf_send_ct(struct zfcp_fc_wka_port *, struct zfcp_fsf_ct_els *,
-			    mempool_t *);
+			    mempool_t *, unsigned int);
 extern int zfcp_fsf_send_els(struct zfcp_adapter *, u32,
-			     struct zfcp_fsf_ct_els *);
+			     struct zfcp_fsf_ct_els *, unsigned int);
 extern int zfcp_fsf_send_fcp_command_task(struct zfcp_unit *,
 					  struct scsi_cmnd *);
 extern void zfcp_fsf_req_free(struct zfcp_fsf_req *);
--- a/drivers/s390/scsi/zfcp_fc.c	2010-01-14 16:44:46.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_fc.c	2010-01-14 16:44:49.000000000 +0100
@@ -258,7 +258,8 @@ static int zfcp_fc_ns_gid_pn_request(str
 	gid_pn->gid_pn_req.gid_pn.fn_wwpn = port->wwpn;
 
 	ret = zfcp_fsf_send_ct(&adapter->gs->ds, &gid_pn->ct,
-			       adapter->pool.gid_pn_req);
+			       adapter->pool.gid_pn_req,
+			       ZFCP_FC_CTELS_TMO);
 	if (!ret) {
 		wait_for_completion(&completion);
 		zfcp_fc_ns_gid_pn_eval(gid_pn);
@@ -421,7 +422,8 @@ static int zfcp_fc_adisc(struct zfcp_por
 	hton24(adisc->adisc_req.adisc_port_id,
 	       fc_host_port_id(adapter->scsi_host));
 
-	ret = zfcp_fsf_send_els(adapter, port->d_id, &adisc->els);
+	ret = zfcp_fsf_send_els(adapter, port->d_id, &adisc->els,
+				ZFCP_FC_CTELS_TMO);
 	if (ret)
 		kmem_cache_free(zfcp_data.adisc_cache, adisc);
 
@@ -532,7 +534,8 @@ static int zfcp_fc_send_gpn_ft(struct zf
 	ct->req = &gpn_ft->sg_req;
 	ct->resp = gpn_ft->sg_resp;
 
-	ret = zfcp_fsf_send_ct(&adapter->gs->ds, ct, NULL);
+	ret = zfcp_fsf_send_ct(&adapter->gs->ds, ct, NULL,
+			       ZFCP_FC_CTELS_TMO);
 	if (!ret)
 		wait_for_completion(&completion);
 	return ret;
@@ -734,7 +737,7 @@ static int zfcp_fc_exec_els_job(struct f
 		d_id = ntoh24(job->request->rqst_data.h_els.port_id);
 
 	els->handler = zfcp_fc_ct_els_job_handler;
-	return zfcp_fsf_send_els(adapter, d_id, els);
+	return zfcp_fsf_send_els(adapter, d_id, els, job->req->timeout / HZ);
 }
 
 static int zfcp_fc_exec_ct_job(struct fc_bsg_job *job,
@@ -753,7 +756,7 @@ static int zfcp_fc_exec_ct_job(struct fc
 		return ret;
 
 	ct->handler = zfcp_fc_ct_job_handler;
-	ret = zfcp_fsf_send_ct(wka_port, ct, NULL);
+	ret = zfcp_fsf_send_ct(wka_port, ct, NULL, job->req->timeout / HZ);
 	if (ret)
 		zfcp_fc_wka_port_put(wka_port);
 
--- a/drivers/s390/scsi/zfcp_fc.h	2010-01-14 16:44:41.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_fc.h	2010-01-14 16:44:49.000000000 +0100
@@ -27,6 +27,8 @@
 #define ZFCP_FC_GPN_FT_MAX_ENT	  (ZFCP_FC_GPN_FT_NUM_BUFS * \
 					(ZFCP_FC_GPN_FT_ENT_PAGE + 1))
 
+#define ZFCP_FC_CTELS_TMO	(2 * FC_DEF_R_A_TOV / 1000)
+
 /**
  * struct zfcp_fc_gid_pn_req - container for ct header plus gid_pn request
  * @ct_hdr: FC GS common transport header
--- a/drivers/s390/scsi/zfcp_fsf.c	2010-01-14 16:44:41.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_fsf.c	2010-01-14 16:44:49.000000000 +0100
@@ -1068,20 +1068,20 @@ static int zfcp_fsf_setup_ct_els_sbals(s
 static int zfcp_fsf_setup_ct_els(struct zfcp_fsf_req *req,
 				 struct scatterlist *sg_req,
 				 struct scatterlist *sg_resp,
-				 int max_sbals)
+				 int max_sbals, unsigned int timeout)
 {
 	int ret;
-	unsigned int fcp_chan_timeout;
 
 	ret = zfcp_fsf_setup_ct_els_sbals(req, sg_req, sg_resp, max_sbals);
 	if (ret)
 		return ret;
 
 	/* common settings for ct/gs and els requests */
-	fcp_chan_timeout = 2 * FC_DEF_R_A_TOV / 1000;
+	if (timeout > 255)
+		timeout = 255; /* max value accepted by hardware */
 	req->qtcb->bottom.support.service_class = FSF_CLASS_3;
-	req->qtcb->bottom.support.timeout = fcp_chan_timeout;
-	zfcp_fsf_start_timer(req, (fcp_chan_timeout + 10) * HZ);
+	req->qtcb->bottom.support.timeout = timeout;
+	zfcp_fsf_start_timer(req, (timeout + 10) * HZ);
 
 	return 0;
 }
@@ -1092,7 +1092,8 @@ static int zfcp_fsf_setup_ct_els(struct 
  * @pool: if non-null this mempool is used to allocate struct zfcp_fsf_req
  */
 int zfcp_fsf_send_ct(struct zfcp_fc_wka_port *wka_port,
-		     struct zfcp_fsf_ct_els *ct, mempool_t *pool)
+		     struct zfcp_fsf_ct_els *ct, mempool_t *pool,
+		     unsigned int timeout)
 {
 	struct zfcp_qdio *qdio = wka_port->adapter->qdio;
 	struct zfcp_fsf_req *req;
@@ -1111,7 +1112,7 @@ int zfcp_fsf_send_ct(struct zfcp_fc_wka_
 
 	req->status |= ZFCP_STATUS_FSFREQ_CLEANUP;
 	ret = zfcp_fsf_setup_ct_els(req, ct->req, ct->resp,
-				    FSF_MAX_SBALS_PER_REQ);
+				    FSF_MAX_SBALS_PER_REQ, timeout);
 	if (ret)
 		goto failed_send;
 
@@ -1188,7 +1189,7 @@ skip_fsfstatus:
  * @els: pointer to struct zfcp_send_els with data for the command
  */
 int zfcp_fsf_send_els(struct zfcp_adapter *adapter, u32 d_id,
-		      struct zfcp_fsf_ct_els *els)
+		      struct zfcp_fsf_ct_els *els, unsigned int timeout)
 {
 	struct zfcp_fsf_req *req;
 	struct zfcp_qdio *qdio = adapter->qdio;
@@ -1206,7 +1207,7 @@ int zfcp_fsf_send_els(struct zfcp_adapte
 	}
 
 	req->status |= ZFCP_STATUS_FSFREQ_CLEANUP;
-	ret = zfcp_fsf_setup_ct_els(req, els->req, els->resp, 2);
+	ret = zfcp_fsf_setup_ct_els(req, els->req, els->resp, 2, timeout);
 
 	if (ret)
 		goto failed_send;


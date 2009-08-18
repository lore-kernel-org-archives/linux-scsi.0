From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 21/27] zfcp: Simplify and update ct/gs and els timeout handling
Date: Tue, 18 Aug 2009 15:43:26 +0200
Message-ID: <20090818135031.563825000@de.ibm.com>
References: <20090818134305.841868000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate2.de.ibm.com ([195.212.17.162]:47061 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758942AbZHRNub (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Aug 2009 09:50:31 -0400
Content-Disposition: inline; filename=725-zfcp-timeout-handling.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

The recommendation for a timeout of 2 * R_A_TOV is the same for ct/gs
and els requests, so set it in the common function used for
initializing both request types. Besides, the timer inside zfcp should
only run longer than the timeout set for the channel, so 10 seconds
more should be enough (instead of 60 seconds).

Reviewed-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_def.h |    5 -----
 drivers/s390/scsi/zfcp_fc.c  |    3 ---
 drivers/s390/scsi/zfcp_fsf.c |   15 ++++++---------
 3 files changed, 6 insertions(+), 17 deletions(-)

diff -urpN linux-2.6/drivers/s390/scsi/zfcp_def.h linux-2.6-patched/drivers/s390/scsi/zfcp_def.h
--- linux-2.6/drivers/s390/scsi/zfcp_def.h	2009-08-17 09:53:16.000000000 +0200
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_def.h	2009-08-17 09:53:16.000000000 +0200
@@ -73,9 +73,6 @@
 
 /*************** FIBRE CHANNEL PROTOCOL SPECIFIC DEFINES ********************/
 
-/* timeout for name-server lookup (in seconds) */
-#define ZFCP_NS_GID_PN_TIMEOUT		10
-
 /* task attribute values in FCP-2 FCP_CMND IU */
 #define SIMPLE_Q	0
 #define HEAD_OF_Q	1
@@ -319,7 +316,6 @@ struct ct_iu_gpn_ft_req {
  * @resp: scatter-gather list for response
  * @handler: handler function (called for response to the request)
  * @handler_data: data passed to handler function
- * @timeout: FSF timeout for this request
  * @completion: completion for synchronization purposes
  * @status: used to pass error status to calling function
  */
@@ -329,7 +325,6 @@ struct zfcp_send_ct {
 	struct scatterlist *resp;
 	void (*handler)(unsigned long);
 	unsigned long handler_data;
-	int timeout;
 	struct completion *completion;
 	int status;
 };
diff -urpN linux-2.6/drivers/s390/scsi/zfcp_fc.c linux-2.6-patched/drivers/s390/scsi/zfcp_fc.c
--- linux-2.6/drivers/s390/scsi/zfcp_fc.c	2009-08-17 09:53:14.000000000 +0200
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_fc.c	2009-08-17 09:53:16.000000000 +0200
@@ -283,7 +283,6 @@ static int zfcp_fc_ns_gid_pn_request(str
 	gid_pn->ct.wka_port = &adapter->gs->ds;
 	gid_pn->ct.handler = zfcp_fc_ns_handler;
 	gid_pn->ct.handler_data = (unsigned long) &compl_rec;
-	gid_pn->ct.timeout = ZFCP_NS_GID_PN_TIMEOUT;
 	gid_pn->ct.req = &gid_pn->req;
 	gid_pn->ct.resp = &gid_pn->resp;
 	sg_init_one(&gid_pn->req, &gid_pn->ct_iu_req,
@@ -556,7 +555,6 @@ static int zfcp_fc_send_gpn_ft(struct zf
 	ct->wka_port = &adapter->gs->ds;
 	ct->handler = zfcp_fc_ns_handler;
 	ct->handler_data = (unsigned long)&compl_rec;
-	ct->timeout = 10;
 	ct->req = &gpn_ft->sg_req;
 	ct->resp = gpn_ft->sg_resp;
 
@@ -845,7 +843,6 @@ int zfcp_fc_execute_ct_fc_job(struct fc_
 
 	ct_fc_job->ct.req = job->request_payload.sg_list;
 	ct_fc_job->ct.resp = job->reply_payload.sg_list;
-	ct_fc_job->ct.timeout = ZFCP_FSF_REQUEST_TIMEOUT;
 	ct_fc_job->ct.handler = zfcp_fc_generic_ct_handler;
 	ct_fc_job->ct.handler_data = (unsigned long) ct_fc_job;
 	ct_fc_job->ct.completion = NULL;
diff -urpN linux-2.6/drivers/s390/scsi/zfcp_fsf.c linux-2.6-patched/drivers/s390/scsi/zfcp_fsf.c
--- linux-2.6/drivers/s390/scsi/zfcp_fsf.c	2009-08-17 09:53:14.000000000 +0200
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_fsf.c	2009-08-17 09:53:16.000000000 +0200
@@ -1060,7 +1060,12 @@ static int zfcp_fsf_setup_ct_els_sbals(s
 					sg_resp, max_sbals);
 	if (bytes <= 0)
 		return -EIO;
+
+	/* common settings for ct/gs and els requests */
 	req->qtcb->bottom.support.resp_buf_length = bytes;
+	req->qtcb->bottom.support.service_class = FSF_CLASS_3;
+	req->qtcb->bottom.support.timeout = 2 * R_A_TOV;
+	zfcp_fsf_start_timer(req, 2 * R_A_TOV + 10);
 
 	return 0;
 }
@@ -1096,12 +1101,9 @@ int zfcp_fsf_send_ct(struct zfcp_send_ct
 
 	req->handler = zfcp_fsf_send_ct_handler;
 	req->qtcb->header.port_handle = wka_port->handle;
-	req->qtcb->bottom.support.service_class = FSF_CLASS_3;
-	req->qtcb->bottom.support.timeout = ct->timeout;
 	req->data = ct;
 
 	zfcp_dbf_san_ct_request(req);
-	zfcp_fsf_start_timer(req, ZFCP_FSF_REQUEST_TIMEOUT);
 
 	ret = zfcp_fsf_req_send(req);
 	if (ret)
@@ -1176,7 +1178,6 @@ int zfcp_fsf_send_els(struct zfcp_send_e
 {
 	struct zfcp_fsf_req *req;
 	struct zfcp_qdio *qdio = els->adapter->qdio;
-	struct fsf_qtcb_bottom_support *bottom;
 	int ret = -EIO;
 
 	spin_lock_bh(&qdio->req_q_lock);
@@ -1196,16 +1197,12 @@ int zfcp_fsf_send_els(struct zfcp_send_e
 	if (ret)
 		goto failed_send;
 
-	bottom = &req->qtcb->bottom.support;
+	req->qtcb->bottom.support.d_id = els->d_id;
 	req->handler = zfcp_fsf_send_els_handler;
-	bottom->d_id = els->d_id;
-	bottom->service_class = FSF_CLASS_3;
-	bottom->timeout = 2 * R_A_TOV;
 	req->data = els;
 
 	zfcp_dbf_san_els_request(req);
 
-	zfcp_fsf_start_timer(req, ZFCP_FSF_REQUEST_TIMEOUT);
 	ret = zfcp_fsf_req_send(req);
 	if (ret)
 		goto failed_send;


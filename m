From: michaelc@cs.wisc.edu
Subject: [PATCH RFC/RFT 09/10] zfcp: convert zfcp to blk bsg lib
Date: Sun, 24 Jul 2011 03:59:23 -0500
Message-ID: <1311497964-26842-10-git-send-email-michaelc@cs.wisc.edu>
References: <1311497964-26842-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28801 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752217Ab1GXI4t (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 24 Jul 2011 04:56:49 -0400
In-Reply-To: <1311497964-26842-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Mike Christie <michaelc@cs.wisc.edu>

This patch converts zfcp to the blk bsg lib. The differences
visible to the driver are:
- fc_bsg_job is now named bsg_job.
- no rport pointer. Can access it through the device pointer.
- the request and reply pointers on the scsi_bsg_job struct
  are now void pointers, so you cannot do bsg_job->request->some_field.

Patch is only compile tested and made over scsi-misc.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
Cc: Christof Schmitt <christof.schmitt@de.ibm.com>
---
 drivers/s390/scsi/zfcp_ext.h |    4 ++--
 drivers/s390/scsi/zfcp_fc.c  |   33 +++++++++++++++++----------------
 2 files changed, 19 insertions(+), 18 deletions(-)

diff --git a/drivers/s390/scsi/zfcp_ext.h b/drivers/s390/scsi/zfcp_ext.h
index 03627cfd..bfe6ea7 100644
--- a/drivers/s390/scsi/zfcp_ext.h
+++ b/drivers/s390/scsi/zfcp_ext.h
@@ -94,8 +94,8 @@ extern void zfcp_fc_link_test_work(struct work_struct *);
 extern void zfcp_fc_wka_ports_force_offline(struct zfcp_fc_wka_ports *);
 extern int zfcp_fc_gs_setup(struct zfcp_adapter *);
 extern void zfcp_fc_gs_destroy(struct zfcp_adapter *);
-extern int zfcp_fc_exec_bsg_job(struct fc_bsg_job *);
-extern int zfcp_fc_timeout_bsg_job(struct fc_bsg_job *);
+extern int zfcp_fc_exec_bsg_job(struct bsg_job *);
+extern int zfcp_fc_timeout_bsg_job(struct bsg_job *);
 extern void zfcp_fc_sym_name_update(struct work_struct *);
 
 /* zfcp_fsf.c */
diff --git a/drivers/s390/scsi/zfcp_fc.c b/drivers/s390/scsi/zfcp_fc.c
index 297e6b7..164b0d9 100644
--- a/drivers/s390/scsi/zfcp_fc.c
+++ b/drivers/s390/scsi/zfcp_fc.c
@@ -818,26 +818,27 @@ out_free:
 
 static void zfcp_fc_ct_els_job_handler(void *data)
 {
-	struct fc_bsg_job *job = data;
+	struct bsg_job *job = data;
 	struct zfcp_fsf_ct_els *zfcp_ct_els = job->dd_data;
 	struct fc_bsg_reply *jr = job->reply;
 
 	jr->reply_payload_rcv_len = job->reply_payload.payload_len;
 	jr->reply_data.ctels_reply.status = FC_CTELS_STATUS_OK;
 	jr->result = zfcp_ct_els->status ? -EIO : 0;
-	job->job_done(job);
+	bsg_job_done(job, jr->result, jr->reply_payload_rcv_len);
 }
 
-static struct zfcp_fc_wka_port *zfcp_fc_job_wka_port(struct fc_bsg_job *job)
+static struct zfcp_fc_wka_port *zfcp_fc_job_wka_port(struct bsg_job *job)
 {
+	struct fc_bsg_request *jq = job->request;
 	u32 preamble_word1;
 	u8 gs_type;
 	struct zfcp_adapter *adapter;
 
-	preamble_word1 = job->request->rqst_data.r_ct.preamble_word1;
+	preamble_word1 = jq->rqst_data.r_ct.preamble_word1;
 	gs_type = (preamble_word1 & 0xff000000) >> 24;
 
-	adapter = (struct zfcp_adapter *) job->shost->hostdata[0];
+	adapter = shost_priv(fc_bsg_to_shost(job));
 
 	switch (gs_type) {
 	case FC_FST_ALIAS:
@@ -857,7 +858,7 @@ static struct zfcp_fc_wka_port *zfcp_fc_job_wka_port(struct fc_bsg_job *job)
 
 static void zfcp_fc_ct_job_handler(void *data)
 {
-	struct fc_bsg_job *job = data;
+	struct bsg_job *job = data;
 	struct zfcp_fc_wka_port *wka_port;
 
 	wka_port = zfcp_fc_job_wka_port(job);
@@ -866,11 +867,12 @@ static void zfcp_fc_ct_job_handler(void *data)
 	zfcp_fc_ct_els_job_handler(data);
 }
 
-static int zfcp_fc_exec_els_job(struct fc_bsg_job *job,
+static int zfcp_fc_exec_els_job(struct bsg_job *job,
 				struct zfcp_adapter *adapter)
 {
 	struct zfcp_fsf_ct_els *els = job->dd_data;
-	struct fc_rport *rport = job->rport;
+	struct fc_rport *rport = fc_bsg_to_rport(job);
+	struct fc_bsg_request *jq = job->request;
 	struct zfcp_port *port;
 	u32 d_id;
 
@@ -882,13 +884,13 @@ static int zfcp_fc_exec_els_job(struct fc_bsg_job *job,
 		d_id = port->d_id;
 		put_device(&port->dev);
 	} else
-		d_id = ntoh24(job->request->rqst_data.h_els.port_id);
+		d_id = ntoh24(jq->rqst_data.h_els.port_id);
 
 	els->handler = zfcp_fc_ct_els_job_handler;
 	return zfcp_fsf_send_els(adapter, d_id, els, job->req->timeout / HZ);
 }
 
-static int zfcp_fc_exec_ct_job(struct fc_bsg_job *job,
+static int zfcp_fc_exec_ct_job(struct bsg_job *job,
 			       struct zfcp_adapter *adapter)
 {
 	int ret;
@@ -911,14 +913,13 @@ static int zfcp_fc_exec_ct_job(struct fc_bsg_job *job,
 	return ret;
 }
 
-int zfcp_fc_exec_bsg_job(struct fc_bsg_job *job)
+int zfcp_fc_exec_bsg_job(struct bsg_job *job)
 {
-	struct Scsi_Host *shost;
 	struct zfcp_adapter *adapter;
 	struct zfcp_fsf_ct_els *ct_els = job->dd_data;
+	struct fc_bsg_request *jq = job->request;
 
-	shost = job->rport ? rport_to_shost(job->rport) : job->shost;
-	adapter = (struct zfcp_adapter *)shost->hostdata[0];
+	adapter = shost_priv(fc_bsg_to_shost(job));
 
 	if (!(atomic_read(&adapter->status) & ZFCP_STATUS_COMMON_OPEN))
 		return -EINVAL;
@@ -927,7 +928,7 @@ int zfcp_fc_exec_bsg_job(struct fc_bsg_job *job)
 	ct_els->resp = job->reply_payload.sg_list;
 	ct_els->handler_data = job;
 
-	switch (job->request->msgcode) {
+	switch (jq->msgcode) {
 	case FC_BSG_RPT_ELS:
 	case FC_BSG_HST_ELS_NOLOGIN:
 		return zfcp_fc_exec_els_job(job, adapter);
@@ -939,7 +940,7 @@ int zfcp_fc_exec_bsg_job(struct fc_bsg_job *job)
 	}
 }
 
-int zfcp_fc_timeout_bsg_job(struct fc_bsg_job *job)
+int zfcp_fc_timeout_bsg_job(struct bsg_job *job)
 {
 	/* hardware tracks timeout, reset bsg timeout to not interfere */
 	return -EAGAIN;
-- 
1.7.2.3


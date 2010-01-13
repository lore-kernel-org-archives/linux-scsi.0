From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 1/3] zfcp: Issue zfcp_fc_wka_port_put after FC CT BSG request
Date: Wed, 13 Jan 2010 17:52:36 +0100
Message-ID: <20100113165513.360614000@de.ibm.com>
References: <20100113165235.299592000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate2.de.ibm.com ([195.212.17.162]:41644 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754931Ab0AMQzP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Jan 2010 11:55:15 -0500
Content-Disposition: inline; filename=702-zfcp-wka-port-put.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

The patch "zfcp: Simplify handling of ct and els requests"
accidentally removed the call to zfcp_fc_wka_port_put for FC CT BSG
requests, thus not issuing a "close" request for the WKA ports.
Introduce a CT specific handler to first call zfcp_fc_wka_port_put and
then continue with the generic handler when returning from FC CT BSG
requests.

Reviewed-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_fc.c |   65 +++++++++++++++++++++++++++++---------------
 1 file changed, 43 insertions(+), 22 deletions(-)

diff -urpN linux-2.6/drivers/s390/scsi/zfcp_fc.c linux-2.6-patched/drivers/s390/scsi/zfcp_fc.c
--- linux-2.6/drivers/s390/scsi/zfcp_fc.c	2010-01-12 11:18:38.000000000 +0100
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_fc.c	2010-01-12 11:18:59.000000000 +0100
@@ -677,6 +677,44 @@ static void zfcp_fc_ct_els_job_handler(v
 	job->job_done(job);
 }
 
+static struct zfcp_fc_wka_port *zfcp_fc_job_wka_port(struct fc_bsg_job *job)
+{
+	u32 preamble_word1;
+	u8 gs_type;
+	struct zfcp_adapter *adapter;
+
+	preamble_word1 = job->request->rqst_data.r_ct.preamble_word1;
+	gs_type = (preamble_word1 & 0xff000000) >> 24;
+
+	adapter = (struct zfcp_adapter *) job->shost->hostdata[0];
+
+	switch (gs_type) {
+	case FC_FST_ALIAS:
+		return &adapter->gs->as;
+	case FC_FST_MGMT:
+		return &adapter->gs->ms;
+	case FC_FST_TIME:
+		return &adapter->gs->ts;
+		break;
+	case FC_FST_DIR:
+		return &adapter->gs->ds;
+		break;
+	default:
+		return NULL;
+	}
+}
+
+static void zfcp_fc_ct_job_handler(void *data)
+{
+	struct fc_bsg_job *job = data;
+	struct zfcp_fc_wka_port *wka_port;
+
+	wka_port = zfcp_fc_job_wka_port(job);
+	zfcp_fc_wka_port_put(wka_port);
+
+	zfcp_fc_ct_els_job_handler(data);
+}
+
 static int zfcp_fc_exec_els_job(struct fc_bsg_job *job,
 				struct zfcp_adapter *adapter)
 {
@@ -695,6 +733,7 @@ static int zfcp_fc_exec_els_job(struct f
 	} else
 		d_id = ntoh24(job->request->rqst_data.h_els.port_id);
 
+	els->handler = zfcp_fc_ct_els_job_handler;
 	return zfcp_fsf_send_els(adapter, d_id, els);
 }
 
@@ -702,35 +741,18 @@ static int zfcp_fc_exec_ct_job(struct fc
 			       struct zfcp_adapter *adapter)
 {
 	int ret;
-	u8 gs_type;
 	struct zfcp_fsf_ct_els *ct = job->dd_data;
 	struct zfcp_fc_wka_port *wka_port;
-	u32 preamble_word1;
 
-	preamble_word1 = job->request->rqst_data.r_ct.preamble_word1;
-	gs_type = (preamble_word1 & 0xff000000) >> 24;
-
-	switch (gs_type) {
-	case FC_FST_ALIAS:
-		wka_port = &adapter->gs->as;
-		break;
-	case FC_FST_MGMT:
-		wka_port = &adapter->gs->ms;
-		break;
-	case FC_FST_TIME:
-		wka_port = &adapter->gs->ts;
-		break;
-	case FC_FST_DIR:
-		wka_port = &adapter->gs->ds;
-		break;
-	default:
-		return -EINVAL; /* no such service */
-	}
+	wka_port = zfcp_fc_job_wka_port(job);
+	if (!wka_port)
+		return -EINVAL;
 
 	ret = zfcp_fc_wka_port_get(wka_port);
 	if (ret)
 		return ret;
 
+	ct->handler = zfcp_fc_ct_job_handler;
 	ret = zfcp_fsf_send_ct(wka_port, ct, NULL);
 	if (ret)
 		zfcp_fc_wka_port_put(wka_port);
@@ -752,7 +774,6 @@ int zfcp_fc_exec_bsg_job(struct fc_bsg_j
 
 	ct_els->req = job->request_payload.sg_list;
 	ct_els->resp = job->reply_payload.sg_list;
-	ct_els->handler = zfcp_fc_ct_els_job_handler;
 	ct_els->handler_data = job;
 
 	switch (job->request->msgcode) {


From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 1/5] zfcp: correctly initialize unchained requests
Date: Thu, 24 Sep 2009 10:23:21 +0200
Message-ID: <20090924082602.789132000@de.ibm.com>
References: <20090924082320.374328000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate4.de.ibm.com ([195.212.17.164]:57635 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752193AbZIXI0A (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Sep 2009 04:26:00 -0400
Content-Disposition: inline; filename=700-zfcp-init-requests.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

The common initialization of ct/gs and els requests missed the
initialization of unchained requests. Fix this by moving the common
parts to a place that is called for all ct/gs and els requests.

Reviewed-by: Felix Beck <felix.beck@de.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_fsf.c |   22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff -urpN linux-2.6/drivers/s390/scsi/zfcp_fsf.c linux-2.6-patched/drivers/s390/scsi/zfcp_fsf.c
--- linux-2.6/drivers/s390/scsi/zfcp_fsf.c	2009-09-23 10:12:54.000000000 +0200
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_fsf.c	2009-09-23 10:13:17.000000000 +0200
@@ -1058,11 +1058,25 @@ static int zfcp_fsf_setup_ct_els_sbals(s
 	bytes = zfcp_qdio_sbals_from_sg(adapter->qdio, &req->queue_req,
 					SBAL_FLAGS0_TYPE_WRITE_READ,
 					sg_resp, max_sbals);
+	req->qtcb->bottom.support.resp_buf_length = bytes;
 	if (bytes <= 0)
 		return -EIO;
 
+	return 0;
+}
+
+static int zfcp_fsf_setup_ct_els(struct zfcp_fsf_req *req,
+				 struct scatterlist *sg_req,
+				 struct scatterlist *sg_resp,
+				 int max_sbals)
+{
+	int ret;
+
+	ret = zfcp_fsf_setup_ct_els_sbals(req, sg_req, sg_resp, max_sbals);
+	if (ret)
+		return ret;
+
 	/* common settings for ct/gs and els requests */
-	req->qtcb->bottom.support.resp_buf_length = bytes;
 	req->qtcb->bottom.support.service_class = FSF_CLASS_3;
 	req->qtcb->bottom.support.timeout = 2 * R_A_TOV;
 	zfcp_fsf_start_timer(req, 2 * R_A_TOV + 10);
@@ -1094,8 +1108,8 @@ int zfcp_fsf_send_ct(struct zfcp_send_ct
 	}
 
 	req->status |= ZFCP_STATUS_FSFREQ_CLEANUP;
-	ret = zfcp_fsf_setup_ct_els_sbals(req, ct->req, ct->resp,
-					  FSF_MAX_SBALS_PER_REQ);
+	ret = zfcp_fsf_setup_ct_els(req, ct->req, ct->resp,
+				    FSF_MAX_SBALS_PER_REQ);
 	if (ret)
 		goto failed_send;
 
@@ -1192,7 +1206,7 @@ int zfcp_fsf_send_els(struct zfcp_send_e
 	}
 
 	req->status |= ZFCP_STATUS_FSFREQ_CLEANUP;
-	ret = zfcp_fsf_setup_ct_els_sbals(req, els->req, els->resp, 2);
+	ret = zfcp_fsf_setup_ct_els(req, els->req, els->resp, 2);
 
 	if (ret)
 		goto failed_send;


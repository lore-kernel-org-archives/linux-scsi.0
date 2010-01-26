From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 1/1] zfcp: Report FC BSG errors in correct field
Date: Tue, 26 Jan 2010 17:49:19 +0100
Message-ID: <20100126165246.183730000@de.ibm.com>
References: <20100126164918.824991000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate4.de.ibm.com ([195.212.17.164]:48476 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752477Ab0AZQws (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Jan 2010 11:52:48 -0500
Content-Disposition: inline; filename=711-zfcp-status-variable.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Swen Schillig <swen@vnet.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Swen Schillig <swen@vnet.ibm.com>

The status FC_CTELS_STATUS_REJECT for all FC BSG errors is not
appropriate. Instead, report -EIO in the result field if there was a
problem in zfcp with the FC BSG request. If the request is good from
our point of view, report result 0, status FC_CTELS_STATUS_OK and let
userspace read the Accept or Reject from the payload (as documented in
scsi_bsg_fc.h).

Signed-off-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_fc.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff -urpN linux-2.6/drivers/s390/scsi/zfcp_fc.c linux-2.6-patched/drivers/s390/scsi/zfcp_fc.c
--- linux-2.6/drivers/s390/scsi/zfcp_fc.c	2010-01-26 09:36:54.000000000 +0100
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_fc.c	2010-01-26 09:36:54.000000000 +0100
@@ -671,12 +671,11 @@ static void zfcp_fc_ct_els_job_handler(v
 {
 	struct fc_bsg_job *job = data;
 	struct zfcp_fsf_ct_els *zfcp_ct_els = job->dd_data;
-	int status = zfcp_ct_els->status;
-	int reply_status;
+	struct fc_bsg_reply *jr = job->reply;
 
-	reply_status = status ? FC_CTELS_STATUS_REJECT : FC_CTELS_STATUS_OK;
-	job->reply->reply_data.ctels_reply.status = reply_status;
-	job->reply->reply_payload_rcv_len = job->reply_payload.payload_len;
+	jr->reply_payload_rcv_len = job->reply_payload.payload_len;
+	jr->reply_data.ctels_reply.status = FC_CTELS_STATUS_OK;
+	jr->result = zfcp_ct_els->status ? -EIO : 0;
 	job->job_done(job);
 }
 


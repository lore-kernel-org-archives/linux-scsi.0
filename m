From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 9/9] zfcp: Update FC pass-through support
Date: Fri, 15 May 2009 13:18:22 +0200
Message-ID: <20090515112222.484664000@de.ibm.com>
References: <20090515111813.314177000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate1.de.ibm.com ([195.212.17.161]:44448 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755838AbZEOLWW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 15 May 2009 07:22:22 -0400
Content-Disposition: inline; filename=fc-up.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

Don't access the block layer request, get the payload length instead
from the FC job. Simplify access to the zfcp_port, only the d_id is
required, if the port is no longer accessed later. This is possible
when the els_handler does not access the port pointer from the ELS
request.

Reviewed-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---
 drivers/s390/scsi/zfcp_fc.c  |    9 +++------
 drivers/s390/scsi/zfcp_fsf.c |    3 ++-
 2 files changed, 5 insertions(+), 7 deletions(-)

--- a/drivers/s390/scsi/zfcp_fc.c	2009-05-15 12:56:21.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_fc.c	2009-05-15 12:56:24.000000000 +0200
@@ -704,7 +704,7 @@ static void zfcp_fc_generic_els_handler(
 	}
 
 	reply->reply_data.ctels_reply.status = FC_CTELS_STATUS_OK;
-	reply->reply_payload_rcv_len = blk_rq_bytes(job->req->next_rq);
+	reply->reply_payload_rcv_len = job->reply_payload.payload_len;
 
 out:
 	job->state_flags = FC_RQST_STATE_DONE;
@@ -736,15 +736,12 @@ int zfcp_fc_execute_els_fc_job(struct fc
 		read_lock_irq(&zfcp_data.config_lock);
 		port = rport->dd_data;
 		if (port)
-			zfcp_port_get(port);
+			els_fc_job->els.d_id = port->d_id;
 		read_unlock_irq(&zfcp_data.config_lock);
 		if (!port) {
 			kfree(els_fc_job);
 			return -EINVAL;
 		}
-		els_fc_job->els.port = port;
-		els_fc_job->els.d_id = port->d_id;
-		zfcp_port_put(port);
 	} else {
 		port_did = job->request->rqst_data.h_els.port_id;
 		els_fc_job->els.d_id = (port_did[0] << 16) +
@@ -772,8 +769,8 @@ static void zfcp_fc_generic_ct_handler(u
 
 	job->reply->reply_data.ctels_reply.status = ct_fc_job->ct.status ?
 				FC_CTELS_STATUS_REJECT : FC_CTELS_STATUS_OK;
+	job->reply->reply_payload_rcv_len = job->reply_payload.payload_len;
 	job->state_flags = FC_RQST_STATE_DONE;
-	job->reply->reply_payload_rcv_len = blk_rq_bytes(job->req->next_rq);
 	job->job_done(job);
 
 	zfcp_wka_port_put(ct_fc_job->ct.wka_port);
--- a/drivers/s390/scsi/zfcp_fsf.c	2009-05-15 12:56:22.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_fsf.c	2009-05-15 12:56:24.000000000 +0200
@@ -1146,7 +1146,8 @@ static void zfcp_fsf_send_els_handler(st
 	case FSF_RESPONSE_SIZE_TOO_LARGE:
 		break;
 	case FSF_ACCESS_DENIED:
-		zfcp_fsf_access_denied_port(req, port);
+		if (port)
+			zfcp_fsf_access_denied_port(req, port);
 		break;
 	case FSF_SBAL_MISMATCH:
 		/* should never occure, avoided in zfcp_fsf_send_els */


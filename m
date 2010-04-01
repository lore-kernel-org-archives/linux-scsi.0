From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 2/2] zfcp: Fix tracing of requests with error status
Date: Thu, 01 Apr 2010 13:04:08 +0200
Message-ID: <20100401110549.982943000@de.ibm.com>
References: <20100401110406.973537000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate3.de.ibm.com ([195.212.17.163]:38746 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754849Ab0DALFv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Apr 2010 07:05:51 -0400
Content-Disposition: inline; filename=703-zfcp-request-tracing.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

When a FSF request is returned with an error it should be reported
through blktrace for the ziomon tools, but the latency information
should not be read. Fix this by also calling zfcp_fsf_req_trace for
the error case, but skip reading the latencies inside the function.

Reviewed-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_fsf.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/s390/scsi/zfcp_fsf.c	2010-04-01 12:23:11.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_fsf.c	2010-04-01 12:23:12.000000000 +0200
@@ -2104,7 +2104,8 @@ static void zfcp_fsf_req_trace(struct zf
 	blktrc.inb_usage = req->qdio_req.qdio_inb_usage;
 	blktrc.outb_usage = req->qdio_req.qdio_outb_usage;
 
-	if (req->adapter->adapter_features & FSF_FEATURE_MEASUREMENT_DATA) {
+	if (req->adapter->adapter_features & FSF_FEATURE_MEASUREMENT_DATA &&
+	    !(req->status & ZFCP_STATUS_FSFREQ_ERROR)) {
 		blktrc.flags |= ZFCP_BLK_LAT_VALID;
 		blktrc.channel_lat = lat_in->channel_lat * ticks;
 		blktrc.fabric_lat = lat_in->fabric_lat * ticks;
@@ -2156,9 +2157,8 @@ static void zfcp_fsf_send_fcp_command_ta
 	fcp_rsp = (struct fcp_resp_with_ext *) &req->qtcb->bottom.io.fcp_rsp;
 	zfcp_fc_eval_fcp_rsp(fcp_rsp, scpnt);
 
-	zfcp_fsf_req_trace(req, scpnt);
-
 skip_fsfstatus:
+	zfcp_fsf_req_trace(req, scpnt);
 	zfcp_dbf_scsi_result(req->adapter->dbf, scpnt, req);
 
 	scpnt->host_scribble = NULL;


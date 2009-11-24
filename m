From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 07/22] zfcp: Merge trace code for fsf requests in one function
Date: Tue, 24 Nov 2009 16:54:03 +0100
Message-ID: <20091124160136.967130000@de.ibm.com>
References: <20091124155356.135092000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate1.de.ibm.com ([195.212.17.161]:44305 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758172AbZKXQBc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Nov 2009 11:01:32 -0500
Content-Disposition: inline; filename=705-zfcp-merge-trace.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

The latencies traced per fsf request are traced for sysfs output and
for blktrace, each in one function. Simplify the tracing code by
merging both tracing functions into one.

Reviewed-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_fsf.c |   95 ++++++++++++++++++-------------------------
 1 file changed, 40 insertions(+), 55 deletions(-)

diff -urpN linux-2.6/drivers/s390/scsi/zfcp_fsf.c linux-2.6-patched/drivers/s390/scsi/zfcp_fsf.c
--- linux-2.6/drivers/s390/scsi/zfcp_fsf.c	2009-11-23 09:59:38.000000000 +0100
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_fsf.c	2009-11-23 09:59:39.000000000 +0100
@@ -2109,64 +2109,52 @@ static void zfcp_fsf_update_lat(struct f
 	lat_rec->max = max(lat_rec->max, lat);
 }
 
-static void zfcp_fsf_req_latency(struct zfcp_fsf_req *req)
+static void zfcp_fsf_req_trace(struct zfcp_fsf_req *req, struct scsi_cmnd *scsi)
 {
-	struct fsf_qual_latency_info *lat_inf;
-	struct latency_cont *lat;
+	struct fsf_qual_latency_info *lat_in;
+	struct latency_cont *lat = NULL;
 	struct zfcp_unit *unit = req->unit;
+	struct zfcp_blk_drv_data blktrc;
+	int ticks = req->adapter->timer_ticks;
 
-	lat_inf = &req->qtcb->prefix.prot_status_qual.latency_info;
+	lat_in = &req->qtcb->prefix.prot_status_qual.latency_info;
 
-	switch (req->qtcb->bottom.io.data_direction) {
-	case FSF_DATADIR_READ:
-		lat = &unit->latencies.read;
-		break;
-	case FSF_DATADIR_WRITE:
-		lat = &unit->latencies.write;
-		break;
-	case FSF_DATADIR_CMND:
-		lat = &unit->latencies.cmd;
-		break;
-	default:
-		return;
-	}
-
-	spin_lock(&unit->latencies.lock);
-	zfcp_fsf_update_lat(&lat->channel, lat_inf->channel_lat);
-	zfcp_fsf_update_lat(&lat->fabric, lat_inf->fabric_lat);
-	lat->counter++;
-	spin_unlock(&unit->latencies.lock);
-}
+	blktrc.flags = 0;
+	blktrc.magic = ZFCP_BLK_DRV_DATA_MAGIC;
+	if (req->status & ZFCP_STATUS_FSFREQ_ERROR)
+		blktrc.flags |= ZFCP_BLK_REQ_ERROR;
+	blktrc.inb_usage = req->queue_req.qdio_inb_usage;
+	blktrc.outb_usage = req->queue_req.qdio_outb_usage;
+
+	if (req->adapter->adapter_features & FSF_FEATURE_MEASUREMENT_DATA) {
+		blktrc.flags |= ZFCP_BLK_LAT_VALID;
+		blktrc.channel_lat = lat_in->channel_lat * ticks;
+		blktrc.fabric_lat = lat_in->fabric_lat * ticks;
+
+		switch (req->qtcb->bottom.io.data_direction) {
+		case FSF_DATADIR_READ:
+			lat = &unit->latencies.read;
+			break;
+		case FSF_DATADIR_WRITE:
+			lat = &unit->latencies.write;
+			break;
+		case FSF_DATADIR_CMND:
+			lat = &unit->latencies.cmd;
+			break;
+		}
 
-#ifdef CONFIG_BLK_DEV_IO_TRACE
-static void zfcp_fsf_trace_latency(struct zfcp_fsf_req *fsf_req)
-{
-	struct fsf_qual_latency_info *lat_inf;
-	struct scsi_cmnd *scsi_cmnd = (struct scsi_cmnd *)fsf_req->data;
-	struct request *req = scsi_cmnd->request;
-	struct zfcp_blk_drv_data trace;
-	int ticks = fsf_req->adapter->timer_ticks;
-
-	trace.flags = 0;
-	trace.magic = ZFCP_BLK_DRV_DATA_MAGIC;
-	if (fsf_req->adapter->adapter_features & FSF_FEATURE_MEASUREMENT_DATA) {
-		trace.flags |= ZFCP_BLK_LAT_VALID;
-		lat_inf = &fsf_req->qtcb->prefix.prot_status_qual.latency_info;
-		trace.channel_lat = lat_inf->channel_lat * ticks;
-		trace.fabric_lat = lat_inf->fabric_lat * ticks;
-	}
-	if (fsf_req->status & ZFCP_STATUS_FSFREQ_ERROR)
-		trace.flags |= ZFCP_BLK_REQ_ERROR;
-	trace.inb_usage = fsf_req->queue_req.qdio_inb_usage;
-	trace.outb_usage = fsf_req->queue_req.qdio_outb_usage;
+		if (lat) {
+			spin_lock(&unit->latencies.lock);
+			zfcp_fsf_update_lat(&lat->channel, lat_in->channel_lat);
+			zfcp_fsf_update_lat(&lat->fabric, lat_in->fabric_lat);
+			lat->counter++;
+			spin_unlock(&unit->latencies.lock);
+		}
+	}
 
-	blk_add_driver_data(req->q, req, &trace, sizeof(trace));
-}
-#else
-static inline void zfcp_fsf_trace_latency(struct zfcp_fsf_req *fsf_req)
-{
+	blk_add_driver_data(scsi->request->q, scsi->request, &blktrc,
+			    sizeof(blktrc));
 }
-#endif
 
 static void zfcp_fsf_send_fcp_command_task_handler(struct zfcp_fsf_req *req)
 {
@@ -2199,10 +2187,7 @@ static void zfcp_fsf_send_fcp_command_ta
 
 	scpnt->result |= fcp_rsp_iu->scsi_status;
 
-	if (req->adapter->adapter_features & FSF_FEATURE_MEASUREMENT_DATA)
-		zfcp_fsf_req_latency(req);
-
-	zfcp_fsf_trace_latency(req);
+	zfcp_fsf_req_trace(req, scpnt);
 
 	if (unlikely(fcp_rsp_iu->validity.bits.fcp_rsp_len_valid)) {
 		if (fcp_rsp_info[3] == RSP_CODE_GOOD)


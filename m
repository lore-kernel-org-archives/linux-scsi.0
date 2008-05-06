From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 1/2] zfcp: Track fabric and channel latencies provided by FCP adapter
Date: Tue, 06 May 2008 11:00:05 +0200
Message-ID: <20080506090457.765558000@de.ibm.com>
References: <20080506090004.922666000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate4.de.ibm.com ([195.212.29.153]:50756 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764483AbYEFJFJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 May 2008 05:05:09 -0400
Content-Disposition: inline; filename=latencies-1.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, Swen Schillig <swen@vnet.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

Add the infrastructure to retrieve the fabric and channel latencies
from FSF commands for each SCSI command that has been processed. For
each unit, the sum, min, max and number of requests is tracked.

Signed-off-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---
 drivers/s390/scsi/zfcp_aux.c |    8 +++++++
 drivers/s390/scsi/zfcp_def.h |   20 +++++++++++++++++++
 drivers/s390/scsi/zfcp_fsf.c |   44 +++++++++++++++++++++++++++++++++++++++++++
 drivers/s390/scsi/zfcp_fsf.h |   11 +++++++++-
 4 files changed, 82 insertions(+), 1 deletion(-)

--- a/drivers/s390/scsi/zfcp_fsf.c	2008-05-06 10:37:21.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_fsf.c	2008-05-06 10:38:28.000000000 +0200
@@ -2005,6 +2005,7 @@ zfcp_fsf_exchange_config_evaluate(struct
 		fc_host_supported_classes(shost) =
 				FC_COS_CLASS2 | FC_COS_CLASS3;
 		adapter->hydra_version = bottom->adapter_type;
+		adapter->timer_ticks = bottom->timer_interval;
 		if (fc_host_permanent_port_name(shost) == -1)
 			fc_host_permanent_port_name(shost) =
 				fc_host_port_name(shost);
@@ -3649,6 +3650,46 @@ zfcp_fsf_send_fcp_command_task_managemen
 	return fsf_req;
 }
 
+static void zfcp_fsf_update_lat(struct fsf_latency_record *lat_rec, u32 lat)
+{
+	lat_rec->sum += lat;
+	if (lat_rec->min > lat)
+		lat_rec->min = lat;
+	if (lat_rec->max < lat)
+		lat_rec->max = lat;
+}
+
+static void zfcp_fsf_req_latency(struct zfcp_fsf_req *fsf_req)
+{
+	struct fsf_qual_latency_info *lat_inf;
+	struct latency_cont *lat;
+	struct zfcp_unit *unit;
+	unsigned long flags;
+
+	lat_inf = &fsf_req->qtcb->prefix.prot_status_qual.latency_info;
+	unit = fsf_req->unit;
+
+	switch (fsf_req->qtcb->bottom.io.data_direction) {
+	case FSF_DATADIR_READ:
+		lat = &unit->latencies.read;
+		break;
+	case FSF_DATADIR_WRITE:
+		lat = &unit->latencies.write;
+		break;
+	case FSF_DATADIR_CMND:
+		lat = &unit->latencies.cmd;
+		break;
+	default:
+		return;
+	}
+
+	spin_lock_irqsave(&unit->latencies.lock, flags);
+	zfcp_fsf_update_lat(&lat->channel, lat_inf->channel_lat);
+	zfcp_fsf_update_lat(&lat->fabric, lat_inf->fabric_lat);
+	lat->counter++;
+	spin_unlock_irqrestore(&unit->latencies.lock, flags);
+}
+
 /*
  * function:    zfcp_fsf_send_fcp_command_handler
  *
@@ -3922,6 +3963,9 @@ zfcp_fsf_send_fcp_command_task_handler(s
 			      fcp_rsp_iu->fcp_sns_len);
 	}
 
+	if (fsf_req->adapter->adapter_features & FSF_FEATURE_MEASUREMENT_DATA)
+		zfcp_fsf_req_latency(fsf_req);
+
 	/* check FCP_RSP_INFO */
 	if (unlikely(fcp_rsp_iu->validity.bits.fcp_rsp_len_valid)) {
 		ZFCP_LOG_DEBUG("rsp_len is valid\n");
--- a/drivers/s390/scsi/zfcp_aux.c	2008-05-06 10:37:21.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_aux.c	2008-05-06 10:37:23.000000000 +0200
@@ -847,6 +847,14 @@ zfcp_unit_enqueue(struct zfcp_port *port
 	/* mark unit unusable as long as sysfs registration is not complete */
 	atomic_set_mask(ZFCP_STATUS_COMMON_REMOVE, &unit->status);
 
+	spin_lock_init(&unit->latencies.lock);
+	unit->latencies.write.channel.min = 0xFFFFFFFF;
+	unit->latencies.write.fabric.min = 0xFFFFFFFF;
+	unit->latencies.read.channel.min = 0xFFFFFFFF;
+	unit->latencies.read.fabric.min = 0xFFFFFFFF;
+	unit->latencies.cmd.channel.min = 0xFFFFFFFF;
+	unit->latencies.cmd.fabric.min = 0xFFFFFFFF;
+
 	if (device_register(&unit->sysfs_device)) {
 		kfree(unit);
 		return NULL;
--- a/drivers/s390/scsi/zfcp_def.h	2008-05-06 10:37:21.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_def.h	2008-05-06 10:37:23.000000000 +0200
@@ -708,6 +708,24 @@ struct zfcp_erp_action {
 	struct timer_list timer;
 };
 
+struct fsf_latency_record {
+	u32 min;
+	u32 max;
+	u64 sum;
+};
+
+struct latency_cont {
+	struct fsf_latency_record channel;
+	struct fsf_latency_record fabric;
+	u64 counter;
+};
+
+struct zfcp_latencies {
+	struct latency_cont read;
+	struct latency_cont write;
+	struct latency_cont cmd;
+	spinlock_t lock;
+};
 
 struct zfcp_adapter {
 	struct list_head	list;              /* list of adapters */
@@ -723,6 +741,7 @@ struct zfcp_adapter {
 	u32			adapter_features;  /* FCP channel features */
 	u32			connection_features; /* host connection features */
         u32			hardware_version;  /* of FCP channel */
+	u16			timer_ticks;       /* time int for a tick */
 	struct Scsi_Host	*scsi_host;	   /* Pointer to mid-layer */
 	struct list_head	port_list_head;	   /* remote port list */
 	struct list_head        port_remove_lh;    /* head of ports to be
@@ -822,6 +841,7 @@ struct zfcp_unit {
         struct scsi_device     *device;        /* scsi device struct pointer */
 	struct zfcp_erp_action erp_action;     /* pending error recovery */
         atomic_t               erp_counter;
+	struct zfcp_latencies	latencies;
 };
 
 /* FSF request */
--- a/drivers/s390/scsi/zfcp_fsf.h	2008-05-06 10:37:21.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_fsf.h	2008-05-06 10:37:23.000000000 +0200
@@ -323,11 +323,18 @@ struct fsf_link_down_info {
 	u8 vendor_specific_code;
 } __attribute__ ((packed));
 
+struct fsf_qual_latency_info {
+	u32 channel_lat;
+	u32 fabric_lat;
+	u8 res1[8];
+} __attribute__ ((packed));
+
 union fsf_prot_status_qual {
 	u64 doubleword[FSF_PROT_STATUS_QUAL_SIZE / sizeof(u64)];
 	struct fsf_qual_version_error   version_error;
 	struct fsf_qual_sequence_error  sequence_error;
 	struct fsf_link_down_info link_down_info;
+	struct fsf_qual_latency_info latency_info;
 } __attribute__ ((packed));
 
 struct fsf_qtcb_prefix {
@@ -437,7 +444,9 @@ struct fsf_qtcb_bottom_config {
 	u32 fc_link_speed;
 	u32 adapter_type;
 	u32 peer_d_id;
-	u8 res2[12];
+	u8 res1[2];
+	u16 timer_interval;
+	u8 res2[8];
 	u32 s_id;
 	struct fsf_nport_serv_param nport_serv_param;
 	u8 reserved_nport_serv_param[16];

-- 

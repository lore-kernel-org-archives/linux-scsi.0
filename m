From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 16/22] zfcp: Remove ZFCP_DID_MASK
Date: Tue, 24 Nov 2009 16:54:12 +0100
Message-ID: <20091124160138.339012000@de.ibm.com>
References: <20091124155356.135092000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate4.de.ibm.com ([195.212.17.164]:39607 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933407AbZKXQCS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Nov 2009 11:02:18 -0500
Content-Disposition: inline; filename=715-zfcp-rm-mask.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

Instead of assigning 4 bytes with the highest byte masked out, use a 3
byte array with the ntoh24 and h24ton helper functions, thus
eliminating the need for the ZFCP_DID_MASK.

Reviewed-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_dbf.c |    4 ++--
 drivers/s390/scsi/zfcp_def.h |    4 ----
 drivers/s390/scsi/zfcp_fsf.c |   12 ++++++------
 drivers/s390/scsi/zfcp_fsf.h |   15 +++++++++------
 4 files changed, 17 insertions(+), 18 deletions(-)

diff -urpN linux-2.6/drivers/s390/scsi/zfcp_dbf.c linux-2.6-patched/drivers/s390/scsi/zfcp_dbf.c
--- linux-2.6/drivers/s390/scsi/zfcp_dbf.c	2009-11-23 09:59:44.000000000 +0100
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_dbf.c	2009-11-23 09:59:44.000000000 +0100
@@ -178,7 +178,7 @@ void _zfcp_dbf_hba_fsf_response(const ch
 
 	case FSF_QTCB_SEND_ELS:
 		send_els = (struct zfcp_send_els *)fsf_req->data;
-		response->u.els.d_id = qtcb->bottom.support.d_id;
+		response->u.els.d_id = ntoh24(qtcb->bottom.support.d_id);
 		response->u.els.ls_code = send_els->ls_code >> 24;
 		break;
 
@@ -812,7 +812,7 @@ void zfcp_dbf_san_incoming_els(struct zf
 	int length = (int)buf->length -
 		     (int)((void *)&buf->payload - (void *)buf);
 
-	zfcp_dbf_san_els("iels", 1, fsf_req, buf->d_id,
+	zfcp_dbf_san_els("iels", 1, fsf_req, ntoh24(buf->d_id),
 			       fc_host_port_id(adapter->scsi_host),
 			       buf->payload.data[0], (void *)buf->payload.data,
 			       length);
diff -urpN linux-2.6/drivers/s390/scsi/zfcp_def.h linux-2.6-patched/drivers/s390/scsi/zfcp_def.h
--- linux-2.6/drivers/s390/scsi/zfcp_def.h	2009-11-23 09:59:44.000000000 +0100
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_def.h	2009-11-23 09:59:44.000000000 +0100
@@ -71,10 +71,6 @@
 /* timeout value for "default timer" for fsf requests */
 #define ZFCP_FSF_REQUEST_TIMEOUT (60*HZ)
 
-/*************** FIBRE CHANNEL PROTOCOL SPECIFIC DEFINES ********************/
-
-#define ZFCP_DID_MASK           0x00FFFFFF
-
 /*************** ADAPTER/PORT/UNIT AND FSF_REQ STATUS FLAGS ******************/
 
 /*
diff -urpN linux-2.6/drivers/s390/scsi/zfcp_fsf.c linux-2.6-patched/drivers/s390/scsi/zfcp_fsf.c
--- linux-2.6/drivers/s390/scsi/zfcp_fsf.c	2009-11-23 09:59:44.000000000 +0100
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_fsf.c	2009-11-23 09:59:44.000000000 +0100
@@ -128,7 +128,7 @@ static void zfcp_fsf_status_read_port_cl
 	struct fsf_status_read_buffer *sr_buf = req->data;
 	struct zfcp_adapter *adapter = req->adapter;
 	struct zfcp_port *port;
-	int d_id = sr_buf->d_id & ZFCP_DID_MASK;
+	int d_id = ntoh24(sr_buf->d_id);
 
 	read_lock_irqsave(&adapter->port_list_lock, flags);
 	list_for_each_entry(port, &adapter->port_list, list)
@@ -494,7 +494,7 @@ static int zfcp_fsf_exchange_config_eval
 
 	fc_host_port_name(shost) = nsp->fl_wwpn;
 	fc_host_node_name(shost) = nsp->fl_wwnn;
-	fc_host_port_id(shost) = bottom->s_id & ZFCP_DID_MASK;
+	fc_host_port_id(shost) = ntoh24(bottom->s_id);
 	fc_host_speed(shost) = bottom->fc_link_speed;
 	fc_host_supported_classes(shost) = FC_COS_CLASS2 | FC_COS_CLASS3;
 
@@ -506,7 +506,7 @@ static int zfcp_fsf_exchange_config_eval
 
 	switch (bottom->fc_topology) {
 	case FSF_TOPO_P2P:
-		adapter->peer_d_id = bottom->peer_d_id & ZFCP_DID_MASK;
+		adapter->peer_d_id = ntoh24(bottom->peer_d_id);
 		adapter->peer_wwpn = plogi->fl_wwpn;
 		adapter->peer_wwnn = plogi->fl_wwnn;
 		fc_host_port_type(shost) = FC_PORTTYPE_PTP;
@@ -1216,7 +1216,7 @@ int zfcp_fsf_send_els(struct zfcp_send_e
 	if (ret)
 		goto failed_send;
 
-	req->qtcb->bottom.support.d_id = els->d_id;
+	hton24(req->qtcb->bottom.support.d_id, els->d_id);
 	req->handler = zfcp_fsf_send_els_handler;
 	req->data = els;
 
@@ -1522,7 +1522,7 @@ int zfcp_fsf_open_port(struct zfcp_erp_a
         sbale[1].flags |= SBAL_FLAGS_LAST_ENTRY;
 
 	req->handler = zfcp_fsf_open_port_handler;
-	req->qtcb->bottom.support.d_id = port->d_id;
+	hton24(req->qtcb->bottom.support.d_id, port->d_id);
 	req->data = port;
 	req->erp_action = erp_action;
 	erp_action->fsf_req = req;
@@ -1669,7 +1669,7 @@ int zfcp_fsf_open_wka_port(struct zfcp_f
 	sbale[1].flags |= SBAL_FLAGS_LAST_ENTRY;
 
 	req->handler = zfcp_fsf_open_wka_port_handler;
-	req->qtcb->bottom.support.d_id = wka_port->d_id;
+	hton24(req->qtcb->bottom.support.d_id, wka_port->d_id);
 	req->data = wka_port;
 
 	zfcp_fsf_start_timer(req, ZFCP_FSF_REQUEST_TIMEOUT);
diff -urpN linux-2.6/drivers/s390/scsi/zfcp_fsf.h linux-2.6-patched/drivers/s390/scsi/zfcp_fsf.h
--- linux-2.6/drivers/s390/scsi/zfcp_fsf.h	2009-11-23 09:59:43.000000000 +0100
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_fsf.h	2009-11-23 09:59:44.000000000 +0100
@@ -11,6 +11,7 @@
 
 #include <linux/pfn.h>
 #include <linux/scatterlist.h>
+#include <scsi/libfc.h>
 
 #define FSF_QTCB_CURRENT_VERSION		0x00000001
 
@@ -228,7 +229,8 @@ struct fsf_status_read_buffer {
 	u32 length;
 	u32 res1;
 	struct fsf_queue_designator queue_designator;
-	u32 d_id;
+	u8 res2;
+	u8 d_id[3];
 	u32 class;
 	u64 fcp_lun;
 	u8  res3[24];
@@ -327,8 +329,8 @@ struct fsf_qtcb_bottom_io {
 
 struct fsf_qtcb_bottom_support {
 	u32 operation_subtype;
-	u8  res1[12];
-	u32 d_id;
+	u8  res1[13];
+	u8 d_id[3];
 	u32 option;
 	u64 fcp_lun;
 	u64 res2;
@@ -357,11 +359,12 @@ struct fsf_qtcb_bottom_config {
 	u32 fc_topology;
 	u32 fc_link_speed;
 	u32 adapter_type;
-	u32 peer_d_id;
+	u8 res0;
+	u8 peer_d_id[3];
 	u8 res1[2];
 	u16 timer_interval;
-	u8 res2[8];
-	u32 s_id;
+	u8 res2[9];
+	u8 s_id[3];
 	u8 nport_serv_param[128];
 	u8 res3[8];
 	u32 adapter_ports;


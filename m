From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 13/22] zfcp: Use common code definitions for FC ELS structs
Date: Tue, 24 Nov 2009 16:54:09 +0100
Message-ID: <20091124160137.890372000@de.ibm.com>
References: <20091124155356.135092000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate6.de.ibm.com ([195.212.17.166]:59647 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933211AbZKXQBd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Nov 2009 11:01:33 -0500
Content-Disposition: inline; filename=712-zfcp-els-defs.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

Use common code definitions for FC plogi, logo, rscn and adisc structs
instead of inventing private ones. Move the private struct for issuing
ELS ADISC inside zfcp to zfcp_fc header file.

Reviewed-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_def.h |   45 ---------------
 drivers/s390/scsi/zfcp_ext.h |    4 +
 drivers/s390/scsi/zfcp_fc.c  |  129 +++++++++++++++++++++----------------------
 drivers/s390/scsi/zfcp_fc.h  |   17 +++++
 drivers/s390/scsi/zfcp_fsf.c |   45 ++++++---------
 drivers/s390/scsi/zfcp_fsf.h |   20 ------
 6 files changed, 107 insertions(+), 153 deletions(-)

--- a/drivers/s390/scsi/zfcp_def.h	2009-11-24 15:42:54.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_def.h	2009-11-24 15:43:23.000000000 +0100
@@ -75,51 +75,6 @@
 
 #define ZFCP_DID_MASK           0x00FFFFFF
 
-/* see fc-fs */
-#define LS_RSCN  0x61
-#define LS_LOGO  0x05
-#define LS_PLOGI 0x03
-
-struct fcp_rscn_head {
-        u8  command;
-        u8  page_length; /* always 0x04 */
-        u16 payload_len;
-} __attribute__((packed));
-
-struct fcp_rscn_element {
-        u8  reserved:2;
-        u8  event_qual:4;
-        u8  addr_format:2;
-        u32 nport_did:24;
-} __attribute__((packed));
-
-/* see fc-ph */
-struct fcp_logo {
-        u32 command;
-        u32 nport_did;
-	u64 nport_wwpn;
-} __attribute__((packed));
-
-/*
- * FC-FS stuff
- */
-#define R_A_TOV				10 /* seconds */
-
-#define ZFCP_LS_RLS			0x0f
-#define ZFCP_LS_ADISC			0x52
-#define ZFCP_LS_RPS			0x56
-#define ZFCP_LS_RSCN			0x61
-#define ZFCP_LS_RNID			0x78
-
-struct zfcp_ls_adisc {
-	u8		code;
-	u8		field[3];
-	u32		hard_nport_id;
-	u64		wwpn;
-	u64		wwnn;
-	u32		nport_id;
-} __attribute__ ((packed));
-
 /*
  * FC-GS-2 stuff
  */
--- a/drivers/s390/scsi/zfcp_ext.h	2009-11-24 15:42:54.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_ext.h	2009-11-24 15:43:23.000000000 +0100
@@ -9,6 +9,8 @@
 #ifndef ZFCP_EXT_H
 #define ZFCP_EXT_H
 
+#include <linux/types.h>
+#include <scsi/fc/fc_els.h>
 #include "zfcp_def.h"
 
 /* zfcp_aux.c */
@@ -98,7 +100,7 @@ extern void zfcp_fc_scan_ports(struct wo
 extern void zfcp_fc_incoming_els(struct zfcp_fsf_req *);
 extern void zfcp_fc_port_did_lookup(struct work_struct *);
 extern void zfcp_fc_trigger_did_lookup(struct zfcp_port *);
-extern void zfcp_fc_plogi_evaluate(struct zfcp_port *, struct fsf_plogi *);
+extern void zfcp_fc_plogi_evaluate(struct zfcp_port *, struct fc_els_flogi *);
 extern void zfcp_fc_test_link(struct zfcp_port *);
 extern void zfcp_fc_link_test_work(struct work_struct *);
 extern void zfcp_fc_wka_ports_force_offline(struct zfcp_wka_ports *);
--- a/drivers/s390/scsi/zfcp_fc.c	2009-11-24 15:41:55.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_fc.c	2009-11-24 15:43:23.000000000 +0100
@@ -9,20 +9,17 @@
 #define KMSG_COMPONENT "zfcp"
 #define pr_fmt(fmt) KMSG_COMPONENT ": " fmt
 
+#include <linux/types.h>
+#include <scsi/fc/fc_els.h>
+#include <scsi/libfc.h>
 #include "zfcp_ext.h"
+#include "zfcp_fc.h"
 
-enum rscn_address_format {
-	RSCN_PORT_ADDRESS	= 0x0,
-	RSCN_AREA_ADDRESS	= 0x1,
-	RSCN_DOMAIN_ADDRESS	= 0x2,
-	RSCN_FABRIC_ADDRESS	= 0x3,
-};
-
-static u32 rscn_range_mask[] = {
-	[RSCN_PORT_ADDRESS]		= 0xFFFFFF,
-	[RSCN_AREA_ADDRESS]		= 0xFFFF00,
-	[RSCN_DOMAIN_ADDRESS]		= 0xFF0000,
-	[RSCN_FABRIC_ADDRESS]		= 0x000000,
+static u32 zfcp_fc_rscn_range_mask[] = {
+	[ELS_ADDR_FMT_PORT]		= 0xFFFFFF,
+	[ELS_ADDR_FMT_AREA]		= 0xFFFF00,
+	[ELS_ADDR_FMT_DOM]		= 0xFF0000,
+	[ELS_ADDR_FMT_FAB]		= 0x000000,
 };
 
 struct gpn_ft_resp_acc {
@@ -144,7 +141,7 @@ void zfcp_fc_wka_ports_force_offline(str
 }
 
 static void _zfcp_fc_incoming_rscn(struct zfcp_fsf_req *fsf_req, u32 range,
-				   struct fcp_rscn_element *elem)
+				   struct fc_els_rscn_page *page)
 {
 	unsigned long flags;
 	struct zfcp_adapter *adapter = fsf_req->adapter;
@@ -152,7 +149,7 @@ static void _zfcp_fc_incoming_rscn(struc
 
 	read_lock_irqsave(&adapter->port_list_lock, flags);
 	list_for_each_entry(port, &adapter->port_list, list) {
-		if ((port->d_id & range) == (elem->nport_did & range))
+		if ((port->d_id & range) == (ntoh24(page->rscn_fid) & range))
 			zfcp_fc_test_link(port);
 		if (!port->d_id)
 			zfcp_erp_port_reopen(port,
@@ -165,24 +162,24 @@ static void _zfcp_fc_incoming_rscn(struc
 static void zfcp_fc_incoming_rscn(struct zfcp_fsf_req *fsf_req)
 {
 	struct fsf_status_read_buffer *status_buffer = (void *)fsf_req->data;
-	struct fcp_rscn_head *fcp_rscn_head;
-	struct fcp_rscn_element *fcp_rscn_element;
+	struct fc_els_rscn *head;
+	struct fc_els_rscn_page *page;
 	u16 i;
 	u16 no_entries;
-	u32 range_mask;
+	unsigned int afmt;
 
-	fcp_rscn_head = (struct fcp_rscn_head *) status_buffer->payload.data;
-	fcp_rscn_element = (struct fcp_rscn_element *) fcp_rscn_head;
+	head = (struct fc_els_rscn *) status_buffer->payload.data;
+	page = (struct fc_els_rscn_page *) head;
 
 	/* see FC-FS */
-	no_entries = fcp_rscn_head->payload_len /
-			sizeof(struct fcp_rscn_element);
+	no_entries = head->rscn_plen / sizeof(struct fc_els_rscn_page);
 
 	for (i = 1; i < no_entries; i++) {
 		/* skip head and start with 1st element */
-		fcp_rscn_element++;
-		range_mask = rscn_range_mask[fcp_rscn_element->addr_format];
-		_zfcp_fc_incoming_rscn(fsf_req, range_mask, fcp_rscn_element);
+		page++;
+		afmt = page->rscn_page_flags & ELS_RSCN_ADDR_FMT_MASK;
+		_zfcp_fc_incoming_rscn(fsf_req, zfcp_fc_rscn_range_mask[afmt],
+				       page);
 	}
 	queue_work(fsf_req->adapter->work_queue, &fsf_req->adapter->scan_work);
 }
@@ -204,22 +201,22 @@ static void zfcp_fc_incoming_wwpn(struct
 
 static void zfcp_fc_incoming_plogi(struct zfcp_fsf_req *req)
 {
-	struct fsf_status_read_buffer *status_buffer =
-		(struct fsf_status_read_buffer *)req->data;
-	struct fsf_plogi *els_plogi =
-		(struct fsf_plogi *) status_buffer->payload.data;
+	struct fsf_status_read_buffer *status_buffer;
+	struct fc_els_flogi *plogi;
 
-	zfcp_fc_incoming_wwpn(req, els_plogi->serv_param.wwpn);
+	status_buffer = (struct fsf_status_read_buffer *) req->data;
+	plogi = (struct fc_els_flogi *) status_buffer->payload.data;
+	zfcp_fc_incoming_wwpn(req, plogi->fl_wwpn);
 }
 
 static void zfcp_fc_incoming_logo(struct zfcp_fsf_req *req)
 {
 	struct fsf_status_read_buffer *status_buffer =
 		(struct fsf_status_read_buffer *)req->data;
-	struct fcp_logo *els_logo =
-		(struct fcp_logo *) status_buffer->payload.data;
+	struct fc_els_logo *logo =
+		(struct fc_els_logo *) status_buffer->payload.data;
 
-	zfcp_fc_incoming_wwpn(req, els_logo->nport_wwpn);
+	zfcp_fc_incoming_wwpn(req, logo->fl_n_port_wwn);
 }
 
 /**
@@ -233,11 +230,11 @@ void zfcp_fc_incoming_els(struct zfcp_fs
 	unsigned int els_type = status_buffer->payload.data[0];
 
 	zfcp_dbf_san_incoming_els(fsf_req);
-	if (els_type == LS_PLOGI)
+	if (els_type == ELS_PLOGI)
 		zfcp_fc_incoming_plogi(fsf_req);
-	else if (els_type == LS_LOGO)
+	else if (els_type == ELS_LOGO)
 		zfcp_fc_incoming_logo(fsf_req);
-	else if (els_type == LS_RSCN)
+	else if (els_type == ELS_RSCN)
 		zfcp_fc_incoming_rscn(fsf_req);
 }
 
@@ -379,33 +376,36 @@ void zfcp_fc_trigger_did_lookup(struct z
  *
  * Evaluate PLOGI playload and copy important fields into zfcp_port structure
  */
-void zfcp_fc_plogi_evaluate(struct zfcp_port *port, struct fsf_plogi *plogi)
+void zfcp_fc_plogi_evaluate(struct zfcp_port *port, struct fc_els_flogi *plogi)
 {
-	port->maxframe_size = plogi->serv_param.common_serv_param[7] |
-		((plogi->serv_param.common_serv_param[6] & 0x0F) << 8);
-	if (plogi->serv_param.class1_serv_param[0] & 0x80)
+	if (plogi->fl_wwpn != port->wwpn) {
+		port->d_id = 0;
+		dev_warn(&port->adapter->ccw_device->dev,
+			 "A port opened with WWPN 0x%016Lx returned data that "
+			 "identifies it as WWPN 0x%016Lx\n",
+			 (unsigned long long) port->wwpn,
+			 (unsigned long long) plogi->fl_wwpn);
+		return;
+	}
+
+	port->wwnn = plogi->fl_wwnn;
+	port->maxframe_size = plogi->fl_csp.sp_bb_data;
+
+	if (plogi->fl_cssp[0].cp_class & FC_CPC_VALID)
 		port->supported_classes |= FC_COS_CLASS1;
-	if (plogi->serv_param.class2_serv_param[0] & 0x80)
+	if (plogi->fl_cssp[1].cp_class & FC_CPC_VALID)
 		port->supported_classes |= FC_COS_CLASS2;
-	if (plogi->serv_param.class3_serv_param[0] & 0x80)
+	if (plogi->fl_cssp[2].cp_class & FC_CPC_VALID)
 		port->supported_classes |= FC_COS_CLASS3;
-	if (plogi->serv_param.class4_serv_param[0] & 0x80)
+	if (plogi->fl_cssp[3].cp_class & FC_CPC_VALID)
 		port->supported_classes |= FC_COS_CLASS4;
 }
 
-struct zfcp_els_adisc {
-	struct zfcp_send_els els;
-	struct scatterlist req;
-	struct scatterlist resp;
-	struct zfcp_ls_adisc ls_adisc;
-	struct zfcp_ls_adisc ls_adisc_acc;
-};
-
 static void zfcp_fc_adisc_handler(unsigned long data)
 {
-	struct zfcp_els_adisc *adisc = (struct zfcp_els_adisc *) data;
+	struct zfcp_fc_els_adisc *adisc = (struct zfcp_fc_els_adisc *) data;
 	struct zfcp_port *port = adisc->els.port;
-	struct zfcp_ls_adisc *ls_adisc = &adisc->ls_adisc_acc;
+	struct fc_els_adisc *adisc_resp = &adisc->adisc_resp;
 
 	if (adisc->els.status) {
 		/* request rejected or timed out */
@@ -415,9 +415,9 @@ static void zfcp_fc_adisc_handler(unsign
 	}
 
 	if (!port->wwnn)
-		port->wwnn = ls_adisc->wwnn;
+		port->wwnn = adisc_resp->adisc_wwnn;
 
-	if ((port->wwpn != ls_adisc->wwpn) ||
+	if ((port->wwpn != adisc_resp->adisc_wwpn) ||
 	    !(atomic_read(&port->status) & ZFCP_STATUS_COMMON_OPEN)) {
 		zfcp_erp_port_reopen(port, ZFCP_STATUS_COMMON_ERP_FAILED,
 				     "fcadh_2", NULL);
@@ -434,32 +434,33 @@ static void zfcp_fc_adisc_handler(unsign
 
 static int zfcp_fc_adisc(struct zfcp_port *port)
 {
-	struct zfcp_els_adisc *adisc;
+	struct zfcp_fc_els_adisc *adisc;
 	struct zfcp_adapter *adapter = port->adapter;
 
-	adisc = kzalloc(sizeof(struct zfcp_els_adisc), GFP_ATOMIC);
+	adisc = kzalloc(sizeof(struct zfcp_fc_els_adisc), GFP_ATOMIC);
 	if (!adisc)
 		return -ENOMEM;
 
 	adisc->els.req = &adisc->req;
 	adisc->els.resp = &adisc->resp;
-	sg_init_one(adisc->els.req, &adisc->ls_adisc,
-		    sizeof(struct zfcp_ls_adisc));
-	sg_init_one(adisc->els.resp, &adisc->ls_adisc_acc,
-		    sizeof(struct zfcp_ls_adisc));
+	sg_init_one(adisc->els.req, &adisc->adisc_req,
+		    sizeof(struct fc_els_adisc));
+	sg_init_one(adisc->els.resp, &adisc->adisc_resp,
+		    sizeof(struct fc_els_adisc));
 
 	adisc->els.adapter = adapter;
 	adisc->els.port = port;
 	adisc->els.d_id = port->d_id;
 	adisc->els.handler = zfcp_fc_adisc_handler;
 	adisc->els.handler_data = (unsigned long) adisc;
-	adisc->els.ls_code = adisc->ls_adisc.code = ZFCP_LS_ADISC;
+	adisc->els.ls_code = adisc->adisc_req.adisc_cmd = ELS_ADISC;
 
 	/* acc. to FC-FS, hard_nport_id in ADISC should not be set for ports
 	   without FC-AL-2 capability, so we don't set it */
-	adisc->ls_adisc.wwpn = fc_host_port_name(adapter->scsi_host);
-	adisc->ls_adisc.wwnn = fc_host_node_name(adapter->scsi_host);
-	adisc->ls_adisc.nport_id = fc_host_port_id(adapter->scsi_host);
+	adisc->adisc_req.adisc_wwpn = fc_host_port_name(adapter->scsi_host);
+	adisc->adisc_req.adisc_wwnn = fc_host_node_name(adapter->scsi_host);
+	hton24(adisc->adisc_req.adisc_port_id,
+	       fc_host_port_id(adapter->scsi_host));
 
 	return zfcp_fsf_send_els(&adisc->els);
 }
--- a/drivers/s390/scsi/zfcp_fc.h	2009-11-24 15:42:54.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_fc.h	2009-11-24 15:43:23.000000000 +0100
@@ -10,11 +10,28 @@
 #ifndef ZFCP_FC_H
 #define ZFCP_FC_H
 
+#include <scsi/fc/fc_els.h>
 #include <scsi/fc/fc_fcp.h>
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_tcq.h>
 
 /**
+ * struct zfcp_fc_els_adisc - everything required in zfcp for issuing ELS ADISC
+ * @els: data required for issuing els fsf command
+ * @req: scatterlist entry for ELS ADISC request
+ * @resp: scatterlist entry for ELS ADISC response
+ * @adisc_req: ELS ADISC request data
+ * @adisc_resp: ELS ADISC response data
+ */
+struct zfcp_fc_els_adisc {
+	struct zfcp_send_els els;
+	struct scatterlist req;
+	struct scatterlist resp;
+	struct fc_els_adisc adisc_req;
+	struct fc_els_adisc adisc_resp;
+};
+
+/**
  * zfcp_fc_scsi_to_fcp - setup FCP command with data from scsi_cmnd
  * @fcp: fcp_cmnd to setup
  * @scsi: scsi_cmnd where to get LUN, task attributes/flags and CDB
--- a/drivers/s390/scsi/zfcp_fsf.c	2009-11-24 15:42:54.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_fsf.c	2009-11-24 15:43:23.000000000 +0100
@@ -10,6 +10,7 @@
 #define pr_fmt(fmt) KMSG_COMPONENT ": " fmt
 
 #include <linux/blktrace_api.h>
+#include <scsi/fc/fc_els.h>
 #include "zfcp_ext.h"
 #include "zfcp_fc.h"
 #include "zfcp_dbf.h"
@@ -477,17 +478,22 @@ void zfcp_fsf_req_dismiss_all(struct zfc
 
 static int zfcp_fsf_exchange_config_evaluate(struct zfcp_fsf_req *req)
 {
-	struct fsf_qtcb_bottom_config *bottom;
+	struct fsf_qtcb_bottom_config *bottom = &req->qtcb->bottom.config;
 	struct zfcp_adapter *adapter = req->adapter;
 	struct Scsi_Host *shost = adapter->scsi_host;
+	struct fc_els_flogi *nsp, *plogi;
 
-	bottom = &req->qtcb->bottom.config;
+	/* adjust pointers for missing command code */
+	nsp = (struct fc_els_flogi *) ((u8 *)&bottom->nport_serv_param
+					- sizeof(u32));
+	plogi = (struct fc_els_flogi *) ((u8 *)&bottom->plogi_payload
+					- sizeof(u32));
 
 	if (req->data)
 		memcpy(req->data, bottom, sizeof(*bottom));
 
-	fc_host_node_name(shost) = bottom->nport_serv_param.wwnn;
-	fc_host_port_name(shost) = bottom->nport_serv_param.wwpn;
+	fc_host_port_name(shost) = nsp->fl_wwpn;
+	fc_host_node_name(shost) = nsp->fl_wwnn;
 	fc_host_port_id(shost) = bottom->s_id & ZFCP_DID_MASK;
 	fc_host_speed(shost) = bottom->fc_link_speed;
 	fc_host_supported_classes(shost) = FC_COS_CLASS2 | FC_COS_CLASS3;
@@ -501,8 +507,8 @@ static int zfcp_fsf_exchange_config_eval
 	switch (bottom->fc_topology) {
 	case FSF_TOPO_P2P:
 		adapter->peer_d_id = bottom->peer_d_id & ZFCP_DID_MASK;
-		adapter->peer_wwpn = bottom->plogi_payload.wwpn;
-		adapter->peer_wwnn = bottom->plogi_payload.wwnn;
+		adapter->peer_wwpn = plogi->fl_wwpn;
+		adapter->peer_wwnn = plogi->fl_wwnn;
 		fc_host_port_type(shost) = FC_PORTTYPE_PTP;
 		break;
 	case FSF_TOPO_FABRIC:
@@ -1068,15 +1074,17 @@ static int zfcp_fsf_setup_ct_els(struct 
 				 int max_sbals)
 {
 	int ret;
+	unsigned int fcp_chan_timeout;
 
 	ret = zfcp_fsf_setup_ct_els_sbals(req, sg_req, sg_resp, max_sbals);
 	if (ret)
 		return ret;
 
 	/* common settings for ct/gs and els requests */
+	fcp_chan_timeout = 2 * FC_DEF_R_A_TOV / 1000;
 	req->qtcb->bottom.support.service_class = FSF_CLASS_3;
-	req->qtcb->bottom.support.timeout = 2 * R_A_TOV;
-	zfcp_fsf_start_timer(req, (2 * R_A_TOV + 10) * HZ);
+	req->qtcb->bottom.support.timeout = fcp_chan_timeout;
+	zfcp_fsf_start_timer(req, (fcp_chan_timeout + 10) * HZ);
 
 	return 0;
 }
@@ -1151,7 +1159,7 @@ static void zfcp_fsf_send_els_handler(st
 	case FSF_ADAPTER_STATUS_AVAILABLE:
 		switch (header->fsf_status_qual.word[0]){
 		case FSF_SQ_INVOKE_LINK_TEST_PROCEDURE:
-			if (port && (send_els->ls_code != ZFCP_LS_ADISC))
+			if (port && (send_els->ls_code != ELS_ADISC))
 				zfcp_fc_test_link(port);
 			/*fall through */
 		case FSF_SQ_ULP_DEPENDENT_ERP_REQUIRED:
@@ -1419,7 +1427,7 @@ static void zfcp_fsf_open_port_handler(s
 {
 	struct zfcp_port *port = req->data;
 	struct fsf_qtcb_header *header = &req->qtcb->header;
-	struct fsf_plogi *plogi;
+	struct fc_els_flogi *plogi;
 
 	if (req->status & ZFCP_STATUS_FSFREQ_ERROR)
 		goto out;
@@ -1469,23 +1477,10 @@ static void zfcp_fsf_open_port_handler(s
 		 * another GID_PN straight after a port has been opened.
 		 * Alternately, an ADISC/PDISC ELS should suffice, as well.
 		 */
-		plogi = (struct fsf_plogi *) req->qtcb->bottom.support.els;
+		plogi = (struct fc_els_flogi *) req->qtcb->bottom.support.els;
 		if (req->qtcb->bottom.support.els1_length >=
-		    FSF_PLOGI_MIN_LEN) {
-			if (plogi->serv_param.wwpn != port->wwpn) {
-				port->d_id = 0;
-				dev_warn(&port->adapter->ccw_device->dev,
-					 "A port opened with WWPN 0x%016Lx "
-					 "returned data that identifies it as "
-					 "WWPN 0x%016Lx\n",
-					 (unsigned long long) port->wwpn,
-					 (unsigned long long)
-					  plogi->serv_param.wwpn);
-			} else {
-				port->wwnn = plogi->serv_param.wwnn;
+		    FSF_PLOGI_MIN_LEN)
 				zfcp_fc_plogi_evaluate(port, plogi);
-			}
-		}
 		break;
 	case FSF_UNKNOWN_OP_SUBTYPE:
 		req->status |= ZFCP_STATUS_FSFREQ_ERROR;
--- a/drivers/s390/scsi/zfcp_fsf.h	2009-11-24 15:36:29.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_fsf.h	2009-11-24 15:43:23.000000000 +0100
@@ -309,22 +309,7 @@ struct fsf_qtcb_header {
 	u8  res4[16];
 } __attribute__ ((packed));
 
-struct fsf_nport_serv_param {
-	u8  common_serv_param[16];
-	u64 wwpn;
-	u64 wwnn;
-	u8  class1_serv_param[16];
-	u8  class2_serv_param[16];
-	u8  class3_serv_param[16];
-	u8  class4_serv_param[16];
-	u8  vendor_version_level[16];
-} __attribute__ ((packed));
-
 #define FSF_PLOGI_MIN_LEN	112
-struct fsf_plogi {
-	u32    code;
-	struct fsf_nport_serv_param serv_param;
-} __attribute__ ((packed));
 
 #define FSF_FCP_CMND_SIZE	288
 #define FSF_FCP_RSP_SIZE	128
@@ -377,13 +362,12 @@ struct fsf_qtcb_bottom_config {
 	u16 timer_interval;
 	u8 res2[8];
 	u32 s_id;
-	struct fsf_nport_serv_param nport_serv_param;
-	u8 reserved_nport_serv_param[16];
+	u8 nport_serv_param[128];
 	u8 res3[8];
 	u32 adapter_ports;
 	u32 hardware_version;
 	u8 serial_number[32];
-	struct fsf_nport_serv_param plogi_payload;
+	u8 plogi_payload[112];
 	struct fsf_statistics_info stat_info;
 	u8 res4[112];
 } __attribute__ ((packed));


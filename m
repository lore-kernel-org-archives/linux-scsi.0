From: Andreas Herrmann <aherrman@de.ibm.com>
Subject: [PATCH] zfcp: add additional fc_host attributes
Date: Mon, 19 Sep 2005 16:56:17 +0200
Message-ID: <20050919145617.GA8744@lion28.boeblingen.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate1.de.ibm.com ([195.212.29.150]:10193 "EHLO
	mtagate1.de.ibm.com") by vger.kernel.org with ESMTP id S932440AbVISO7I
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Sep 2005 10:59:08 -0400
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate1.de.ibm.com (8.12.10/8.12.10) with ESMTP id j8JEx6OI132440
	for <linux-scsi@vger.kernel.org>; Mon, 19 Sep 2005 14:59:06 GMT
Received: from d12av02.megacenter.de.ibm.com (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12nrmr1607.megacenter.de.ibm.com (8.12.10/NCO/VERS6.7) with ESMTP id j8JEx6lo085066
	for <linux-scsi@vger.kernel.org>; Mon, 19 Sep 2005 16:59:06 +0200
Received: from d12av02.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av02.megacenter.de.ibm.com (8.12.11/8.13.3) with ESMTP id j8JEx6fV008515
	for <linux-scsi@vger.kernel.org>; Mon, 19 Sep 2005 16:59:06 +0200
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@steeleye.com>
Cc: Linux SCSI <linux-scsi@vger.kernel.org>

Hi,

this patch adds some fc host attributes and removes its equivalents
from the zfcp_adapter structure and zfcp specific sysfs subtree.

Furthermore it removes superfluous calls to fc_remort_port_delete when
an adapter is set offline because rports will be removed by
fc_remove_host anyway.

The patch is based on 2.6.14-rc1 plus 6 patches as of 2005-09-13.


Regards,

Andreas


zfcp: add additional fc_host attributes

Signed-off-by: Andreas Herrmann <aherrman@de.ibm.com>

 zfcp_ccw.c           |   10 -------
 zfcp_dbf.c           |   32 +++++++++++--------------
 zfcp_def.h           |   16 +++---------
 zfcp_erp.c           |   16 ++++++------
 zfcp_fsf.c           |   65 +++++++++++++++++++++++++++------------------------
 zfcp_scsi.c          |   21 +++++++---------
 zfcp_sysfs_adapter.c |   10 -------
 7 files changed, 72 insertions(+), 98 deletions(-)

diff -Nup linux-2.6.14-rc1.orig/drivers/s390/scsi/zfcp_ccw.c linux-2.6.14-rc1/drivers/s390/scsi/zfcp_ccw.c
--- linux-2.6.14-rc1.orig/drivers/s390/scsi/zfcp_ccw.c	2005-08-29 01:41:01.000000000 +0200
+++ linux-2.6.14-rc1/drivers/s390/scsi/zfcp_ccw.c	2005-09-16 17:39:13.000000000 +0200
@@ -202,19 +202,9 @@ static int
 zfcp_ccw_set_offline(struct ccw_device *ccw_device)
 {
 	struct zfcp_adapter *adapter;
-	struct zfcp_port *port;
-	struct fc_rport *rport;
 
 	down(&zfcp_data.config_sema);
 	adapter = dev_get_drvdata(&ccw_device->dev);
-	/* might be racy, but we cannot take config_lock due to the fact that
-	   fc_remote_port_delete might sleep */
-	list_for_each_entry(port, &adapter->port_list_head, list)
-		if (port->rport) {
-			rport = port->rport;
-			port->rport = NULL;
-			fc_remote_port_delete(rport);
-		}
 	zfcp_erp_adapter_shutdown(adapter, 0);
 	zfcp_erp_wait(adapter);
 	zfcp_adapter_scsi_unregister(adapter);
diff -Nup linux-2.6.14-rc1.orig/drivers/s390/scsi/zfcp_dbf.c linux-2.6.14-rc1/drivers/s390/scsi/zfcp_dbf.c
--- linux-2.6.14-rc1.orig/drivers/s390/scsi/zfcp_dbf.c	2005-09-16 15:24:53.000000000 +0200
+++ linux-2.6.14-rc1/drivers/s390/scsi/zfcp_dbf.c	2005-09-16 16:56:55.000000000 +0200
@@ -486,8 +486,7 @@ struct debug_view zfcp_hba_dbf_view = {
 
 inline void
 _zfcp_san_dbf_event_common_ct(const char *tag, struct zfcp_fsf_req *fsf_req,
-			      fc_id_t s_id, fc_id_t d_id,
-			      void *buffer, int buflen)
+			      u32 s_id, u32 d_id, void *buffer, int buflen)
 {
 	struct zfcp_send_ct *send_ct = (struct zfcp_send_ct *)fsf_req->data;
 	struct zfcp_port *port = send_ct->port;
@@ -532,9 +531,9 @@ inline void zfcp_san_dbf_event_ct_reques
 	struct zfcp_port *port = ct->port;
 	struct zfcp_adapter *adapter = port->adapter;
 
-	_zfcp_san_dbf_event_common_ct("octc",
-				      fsf_req, adapter->s_id, port->d_id,
-				      zfcp_sg_to_address(ct->req),
+	_zfcp_san_dbf_event_common_ct("octc", fsf_req,
+				      fc_host_port_id(adapter->scsi_host),
+				      port->d_id, zfcp_sg_to_address(ct->req),
 				      ct->req->length);
 }
 
@@ -544,17 +543,16 @@ inline void zfcp_san_dbf_event_ct_respon
 	struct zfcp_port *port = ct->port;
 	struct zfcp_adapter *adapter = port->adapter;
 
-	_zfcp_san_dbf_event_common_ct("rctc",
-				      fsf_req, port->d_id, adapter->s_id,
+	_zfcp_san_dbf_event_common_ct("rctc", fsf_req, port->d_id,
+				      fc_host_port_id(adapter->scsi_host),
 				      zfcp_sg_to_address(ct->resp),
 				      ct->resp->length);
 }
 
 static inline void
 _zfcp_san_dbf_event_common_els(const char *tag, int level,
-			       struct zfcp_fsf_req *fsf_req,
-			       fc_id_t s_id, fc_id_t d_id, u8 ls_code,
-			       void *buffer, int buflen)
+			       struct zfcp_fsf_req *fsf_req, u32 s_id,
+			       u32 d_id, u8 ls_code, void *buffer, int buflen)
 {
 	struct zfcp_adapter *adapter = fsf_req->adapter;
 	struct zfcp_san_dbf_record *rec = &adapter->san_dbf_buf;
@@ -597,8 +595,9 @@ inline void zfcp_san_dbf_event_els_reque
 {
 	struct zfcp_send_els *els = (struct zfcp_send_els *)fsf_req->data;
 
-	_zfcp_san_dbf_event_common_els("oels", 2,
-				       fsf_req, els->adapter->s_id, els->d_id,
+	_zfcp_san_dbf_event_common_els("oels", 2, fsf_req,
+				       fc_host_port_id(els->adapter->scsi_host),
+				       els->d_id,
 				       *(u8 *) zfcp_sg_to_address(els->req),
 				       zfcp_sg_to_address(els->req),
 				       els->req->length);
@@ -608,8 +607,8 @@ inline void zfcp_san_dbf_event_els_respo
 {
 	struct zfcp_send_els *els = (struct zfcp_send_els *)fsf_req->data;
 
-	_zfcp_san_dbf_event_common_els("rels", 2,
-				       fsf_req, els->d_id, els->adapter->s_id,
+	_zfcp_san_dbf_event_common_els("rels", 2, fsf_req, els->d_id,
+				       fc_host_port_id(els->adapter->scsi_host),
 				       *(u8 *) zfcp_sg_to_address(els->req),
 				       zfcp_sg_to_address(els->resp),
 				       els->resp->length);
@@ -623,9 +622,8 @@ inline void zfcp_san_dbf_event_incoming_
 	int length = (int)status_buffer->length -
 	    (int)((void *)&status_buffer->payload - (void *)status_buffer);
 
-	_zfcp_san_dbf_event_common_els("iels", 1,
-				       fsf_req, status_buffer->d_id,
-				       adapter->s_id,
+	_zfcp_san_dbf_event_common_els("iels", 1, fsf_req, status_buffer->d_id,
+				       fc_host_port_id(adapter->scsi_host),
 				       *(u8 *) status_buffer->payload,
 				       (void *)status_buffer->payload, length);
 }
diff -Nup linux-2.6.14-rc1.orig/drivers/s390/scsi/zfcp_def.h linux-2.6.14-rc1/drivers/s390/scsi/zfcp_def.h
--- linux-2.6.14-rc1.orig/drivers/s390/scsi/zfcp_def.h	2005-09-16 15:24:53.000000000 +0200
+++ linux-2.6.14-rc1/drivers/s390/scsi/zfcp_def.h	2005-09-16 16:43:53.000000000 +0200
@@ -165,7 +165,6 @@ typedef u32 scsi_lun_t;
 /*************** FIBRE CHANNEL PROTOCOL SPECIFIC DEFINES ********************/
 
 typedef unsigned long long wwn_t;
-typedef unsigned int       fc_id_t;
 typedef unsigned long long fcp_lun_t;
 /* data length field may be at variable position in FCP-2 FCP_CMND IU */
 typedef unsigned int       fcp_dl_t;
@@ -806,7 +805,7 @@ struct ct_iu_gid_pn_req {
 /* FS_ACC IU and data unit for GID_PN nameserver request */
 struct ct_iu_gid_pn_resp {
 	struct ct_hdr header;
-	fc_id_t d_id;
+	u32 d_id;
 } __attribute__ ((packed));
 
 typedef void (*zfcp_send_ct_handler_t)(unsigned long);
@@ -872,7 +871,7 @@ typedef void (*zfcp_send_els_handler_t)(
 struct zfcp_send_els {
 	struct zfcp_adapter *adapter;
 	struct zfcp_port *port;
-	fc_id_t d_id;
+	u32 d_id;
 	struct scatterlist *req;
 	struct scatterlist *resp;
 	unsigned int req_count;
@@ -915,24 +914,19 @@ struct zfcp_adapter {
 	atomic_t                refcount;          /* reference count */
 	wait_queue_head_t	remove_wq;         /* can be used to wait for
 						      refcount drop to zero */
-	wwn_t			wwnn;	           /* WWNN */
-	wwn_t			wwpn;	           /* WWPN */
-	fc_id_t			s_id;	           /* N_Port ID */
 	wwn_t			peer_wwnn;	   /* P2P peer WWNN */
 	wwn_t			peer_wwpn;	   /* P2P peer WWPN */
-	fc_id_t			peer_d_id;	   /* P2P peer D_ID */
+	u32			peer_d_id;	   /* P2P peer D_ID */
 	wwn_t			physical_wwpn;     /* WWPN of physical port */
-	fc_id_t			physical_s_id;     /* local FC port ID */
+	u32			physical_s_id;     /* local FC port ID */
 	struct ccw_device       *ccw_device;	   /* S/390 ccw device */
 	u8			fc_service_class;
 	u32			fc_topology;	   /* FC topology */
-	u32			fc_link_speed;	   /* FC interface speed */
 	u32			hydra_version;	   /* Hydra version */
 	u32			fsf_lic_version;
 	u32			adapter_features;  /* FCP channel features */
 	u32			connection_features; /* host connection features */
         u32			hardware_version;  /* of FCP channel */
-        u8			serial_number[32]; /* of hardware */
 	struct Scsi_Host	*scsi_host;	   /* Pointer to mid-layer */
 	unsigned short          scsi_host_no;      /* Assigned host number */
 	unsigned char		name[9];
@@ -1006,7 +1000,7 @@ struct zfcp_port {
 	atomic_t	       status;	       /* status of this remote port */
 	wwn_t		       wwnn;	       /* WWNN if known */
 	wwn_t		       wwpn;	       /* WWPN */
-	fc_id_t		       d_id;	       /* D_ID */
+	u32		       d_id;	       /* D_ID */
 	u32		       handle;	       /* handle assigned by FSF */
 	struct zfcp_erp_action erp_action;     /* pending error recovery */
         atomic_t               erp_counter;
diff -Nup linux-2.6.14-rc1.orig/drivers/s390/scsi/zfcp_erp.c linux-2.6.14-rc1/drivers/s390/scsi/zfcp_erp.c
--- linux-2.6.14-rc1.orig/drivers/s390/scsi/zfcp_erp.c	2005-09-16 15:24:53.000000000 +0200
+++ linux-2.6.14-rc1/drivers/s390/scsi/zfcp_erp.c	2005-09-16 16:55:53.000000000 +0200
@@ -346,13 +346,13 @@ zfcp_erp_adisc(struct zfcp_port *port)
 
 	/* acc. to FC-FS, hard_nport_id in ADISC should not be set for ports
 	   without FC-AL-2 capability, so we don't set it */
-	adisc->wwpn = adapter->wwpn;
-	adisc->wwnn = adapter->wwnn;
-	adisc->nport_id = adapter->s_id;
+	adisc->wwpn = fc_host_port_name(adapter->scsi_host);
+	adisc->wwnn = fc_host_node_name(adapter->scsi_host);
+	adisc->nport_id = fc_host_port_id(adapter->scsi_host);
 	ZFCP_LOG_INFO("ADISC request from s_id 0x%08x to d_id 0x%08x "
 		      "(wwpn=0x%016Lx, wwnn=0x%016Lx, "
 		      "hard_nport_id=0x%08x, nport_id=0x%08x)\n",
-		      adapter->s_id, send_els->d_id, (wwn_t) adisc->wwpn,
+		      adisc->nport_id, send_els->d_id, (wwn_t) adisc->wwpn,
 		      (wwn_t) adisc->wwnn, adisc->hard_nport_id,
 		      adisc->nport_id);
 
@@ -405,7 +405,7 @@ zfcp_erp_adisc_handler(unsigned long dat
 	struct zfcp_send_els *send_els;
 	struct zfcp_port *port;
 	struct zfcp_adapter *adapter;
-	fc_id_t d_id;
+	u32 d_id;
 	struct zfcp_ls_adisc_acc *adisc;
 
 	send_els = (struct zfcp_send_els *) data;
@@ -436,9 +436,9 @@ zfcp_erp_adisc_handler(unsigned long dat
 	ZFCP_LOG_INFO("ADISC response from d_id 0x%08x to s_id "
 		      "0x%08x (wwpn=0x%016Lx, wwnn=0x%016Lx, "
 		      "hard_nport_id=0x%08x, nport_id=0x%08x)\n",
-		      d_id, adapter->s_id, (wwn_t) adisc->wwpn,
-		      (wwn_t) adisc->wwnn, adisc->hard_nport_id,
-		      adisc->nport_id);
+		      d_id, fc_host_port_id(adapter->scsi_host),
+		      (wwn_t) adisc->wwpn, (wwn_t) adisc->wwnn,
+		      adisc->hard_nport_id, adisc->nport_id);
 
 	/* set wwnn for port */
 	if (port->wwnn == 0)
diff -Nup linux-2.6.14-rc1.orig/drivers/s390/scsi/zfcp_fsf.c linux-2.6.14-rc1/drivers/s390/scsi/zfcp_fsf.c
--- linux-2.6.14-rc1.orig/drivers/s390/scsi/zfcp_fsf.c	2005-09-16 15:24:53.000000000 +0200
+++ linux-2.6.14-rc1/drivers/s390/scsi/zfcp_fsf.c	2005-09-16 17:51:37.000000000 +0200
@@ -1617,7 +1617,7 @@ zfcp_fsf_send_els(struct zfcp_send_els *
 {
 	volatile struct qdio_buffer_element *sbale;
 	struct zfcp_fsf_req *fsf_req;
-	fc_id_t d_id;
+	u32 d_id;
 	struct zfcp_adapter *adapter;
 	unsigned long lock_flags;
         int bytes;
@@ -1740,7 +1740,7 @@ static int zfcp_fsf_send_els_handler(str
 {
 	struct zfcp_adapter *adapter;
 	struct zfcp_port *port;
-	fc_id_t d_id;
+	u32 d_id;
 	struct fsf_qtcb_header *header;
 	struct fsf_qtcb_bottom_support *bottom;
 	struct zfcp_send_els *send_els;
@@ -1978,6 +1978,7 @@ zfcp_fsf_exchange_config_evaluate(struct
 {
 	struct fsf_qtcb_bottom_config *bottom;
 	struct zfcp_adapter *adapter = fsf_req->adapter;
+	struct Scsi_Host *shost = adapter->scsi_host;
 
 	bottom = &fsf_req->qtcb->bottom.config;
 	ZFCP_LOG_DEBUG("low/high QTCB version 0x%x/0x%x of FSF\n",
@@ -1990,22 +1991,23 @@ zfcp_fsf_exchange_config_evaluate(struct
 	adapter->peer_d_id = 0;
 
 	if (xchg_ok) {
-		adapter->wwnn = bottom->nport_serv_param.wwnn;
-		adapter->wwpn = bottom->nport_serv_param.wwpn;
-		adapter->s_id = bottom->s_id & ZFCP_DID_MASK;
+		fc_host_node_name(shost) = bottom->nport_serv_param.wwnn;
+		fc_host_port_name(shost) = bottom->nport_serv_param.wwpn;
+		fc_host_port_id(shost) = bottom->s_id & ZFCP_DID_MASK;
+		fc_host_speed(shost) = bottom->fc_link_speed;
+		fc_host_supported_classes(shost) = FC_COS_CLASS2 | FC_COS_CLASS3;
 		adapter->fc_topology = bottom->fc_topology;
-		adapter->fc_link_speed = bottom->fc_link_speed;
 		adapter->hydra_version = bottom->adapter_type;
 		if (adapter->physical_wwpn == 0)
-			adapter->physical_wwpn = adapter->wwpn;
+			adapter->physical_wwpn = fc_host_port_name(shost);
 		if (adapter->physical_s_id == 0)
-			adapter->physical_s_id = adapter->s_id;
+			adapter->physical_s_id = fc_host_port_id(shost);
 	} else {
-		adapter->wwnn = 0;
-		adapter->wwpn = 0;
-		adapter->s_id = 0;
+		fc_host_node_name(shost) = 0;
+		fc_host_port_name(shost) = 0;
+		fc_host_port_id(shost) = 0;
+		fc_host_speed(shost) = FC_PORTSPEED_UNKNOWN;
 		adapter->fc_topology = 0;
-		adapter->fc_link_speed = 0;
 		adapter->hydra_version = 0;
 	}
 
@@ -2017,24 +2019,26 @@ zfcp_fsf_exchange_config_evaluate(struct
 
 	if (adapter->adapter_features & FSF_FEATURE_HBAAPI_MANAGEMENT) {
 		adapter->hardware_version = bottom->hardware_version;
-		memcpy(adapter->serial_number, bottom->serial_number, 17);
-		EBCASC(adapter->serial_number, sizeof(adapter->serial_number));
+		memcpy(fc_host_serial_number(shost), bottom->serial_number,
+		       min(FC_SERIAL_NUMBER_SIZE, 17));
+		EBCASC(fc_host_serial_number(shost),
+		       min(FC_SERIAL_NUMBER_SIZE, 17));
 	}
 
 	ZFCP_LOG_NORMAL("The adapter %s reported the following characteristics:\n"
-		      "WWNN 0x%016Lx, "
-		      "WWPN 0x%016Lx, "
-		      "S_ID 0x%08x,\n"
-		      "adapter version 0x%x, "
-		      "LIC version 0x%x, "
-		      "FC link speed %d Gb/s\n",
-		      zfcp_get_busid_by_adapter(adapter),
-		      adapter->wwnn,
-		      adapter->wwpn,
-		      (unsigned int) adapter->s_id,
-		      adapter->hydra_version,
-		      adapter->fsf_lic_version,
-		      adapter->fc_link_speed);
+			"WWNN 0x%016Lx, "
+			"WWPN 0x%016Lx, "
+			"S_ID 0x%08x,\n"
+			"adapter version 0x%x, "
+			"LIC version 0x%x, "
+			"FC link speed %d Gb/s\n",
+			zfcp_get_busid_by_adapter(adapter),
+			(wwn_t) fc_host_node_name(shost),
+			(wwn_t) fc_host_port_name(shost),
+			fc_host_port_id(shost),
+			adapter->hydra_version,
+			adapter->fsf_lic_version,
+			fc_host_speed(shost));
 	if (ZFCP_QTCB_VERSION < bottom->low_qtcb_version) {
 		ZFCP_LOG_NORMAL("error: the adapter %s "
 				"only supports newer control block "
@@ -2055,7 +2059,6 @@ zfcp_fsf_exchange_config_evaluate(struct
 		zfcp_erp_adapter_shutdown(adapter, 0);
 		return -EIO;
 	}
-	zfcp_set_fc_host_attrs(adapter);
 	return 0;
 }
 
@@ -2259,6 +2262,7 @@ static void
 zfcp_fsf_exchange_port_data_handler(struct zfcp_fsf_req *fsf_req)
 {
 	struct zfcp_adapter *adapter = fsf_req->adapter;
+	struct Scsi_Host *shost = adapter->scsi_host;
 	struct fsf_qtcb *qtcb = fsf_req->qtcb;
 	struct fsf_qtcb_bottom_port *bottom, *data;
 
@@ -2277,9 +2281,10 @@ zfcp_fsf_exchange_port_data_handler(stru
 			adapter->physical_wwpn = bottom->wwpn;
 			adapter->physical_s_id = bottom->fc_port_id;
 		} else {
-			adapter->physical_wwpn = adapter->wwpn;
-			adapter->physical_s_id = adapter->s_id;
+			adapter->physical_wwpn = fc_host_port_name(shost);
+			adapter->physical_s_id = fc_host_port_id(shost);
 		}
+		fc_host_maxframe_size(shost) = bottom->maximum_frame_size;
 		break;
 
 	case FSF_EXCHANGE_CONFIG_DATA_INCOMPLETE:
diff -Nup linux-2.6.14-rc1.orig/drivers/s390/scsi/zfcp_scsi.c linux-2.6.14-rc1/drivers/s390/scsi/zfcp_scsi.c
--- linux-2.6.14-rc1.orig/drivers/s390/scsi/zfcp_scsi.c	2005-09-16 15:24:49.000000000 +0200
+++ linux-2.6.14-rc1/drivers/s390/scsi/zfcp_scsi.c	2005-09-16 17:48:43.000000000 +0200
@@ -698,10 +698,16 @@ void
 zfcp_adapter_scsi_unregister(struct zfcp_adapter *adapter)
 {
 	struct Scsi_Host *shost;
+	struct zfcp_port *port;
 
 	shost = adapter->scsi_host;
 	if (!shost)
 		return;
+	read_lock_irq(&zfcp_data.config_lock);
+	list_for_each_entry(port, &adapter->port_list_head, list)
+		if (port->rport)
+			port->rport = NULL;
+	read_unlock_irq(&zfcp_data.config_lock);
 	fc_remove_host(shost);
 	scsi_remove_host(shost);
 	scsi_host_put(shost);
@@ -776,18 +782,6 @@ zfcp_get_node_name(struct scsi_target *s
 	read_unlock_irqrestore(&zfcp_data.config_lock, flags);
 }
 
-void
-zfcp_set_fc_host_attrs(struct zfcp_adapter *adapter)
-{
-	struct Scsi_Host *shost = adapter->scsi_host;
-
-	fc_host_node_name(shost) = adapter->wwnn;
-	fc_host_port_name(shost) = adapter->wwpn;
-	strncpy(fc_host_serial_number(shost), adapter->serial_number,
-                min(FC_SERIAL_NUMBER_SIZE, 32));
-	fc_host_supported_classes(shost) = FC_COS_CLASS2 | FC_COS_CLASS3;
-}
-
 struct fc_function_template zfcp_transport_functions = {
 	.get_starget_port_id = zfcp_get_port_id,
 	.get_starget_port_name = zfcp_get_port_name,
@@ -799,7 +793,10 @@ struct fc_function_template zfcp_transpo
 	.show_host_node_name = 1,
 	.show_host_port_name = 1,
 	.show_host_supported_classes = 1,
+	.show_host_maxframe_size = 1,
 	.show_host_serial_number = 1,
+	.show_host_speed = 1,
+	.show_host_port_id = 1,
 };
 
 /**
diff -Nup linux-2.6.14-rc1.orig/drivers/s390/scsi/zfcp_sysfs_adapter.c linux-2.6.14-rc1/drivers/s390/scsi/zfcp_sysfs_adapter.c
--- linux-2.6.14-rc1.orig/drivers/s390/scsi/zfcp_sysfs_adapter.c	2005-09-16 15:24:53.000000000 +0200
+++ linux-2.6.14-rc1/drivers/s390/scsi/zfcp_sysfs_adapter.c	2005-09-16 16:51:30.000000000 +0200
@@ -62,9 +62,6 @@ static ssize_t zfcp_sysfs_adapter_##_nam
 static DEVICE_ATTR(_name, S_IRUGO, zfcp_sysfs_adapter_##_name##_show, NULL);
 
 ZFCP_DEFINE_ADAPTER_ATTR(status, "0x%08x\n", atomic_read(&adapter->status));
-ZFCP_DEFINE_ADAPTER_ATTR(wwnn, "0x%016llx\n", adapter->wwnn);
-ZFCP_DEFINE_ADAPTER_ATTR(wwpn, "0x%016llx\n", adapter->wwpn);
-ZFCP_DEFINE_ADAPTER_ATTR(s_id, "0x%06x\n", adapter->s_id);
 ZFCP_DEFINE_ADAPTER_ATTR(peer_wwnn, "0x%016llx\n", adapter->peer_wwnn);
 ZFCP_DEFINE_ADAPTER_ATTR(peer_wwpn, "0x%016llx\n", adapter->peer_wwpn);
 ZFCP_DEFINE_ADAPTER_ATTR(peer_d_id, "0x%06x\n", adapter->peer_d_id);
@@ -72,13 +69,11 @@ ZFCP_DEFINE_ADAPTER_ATTR(physical_wwpn, 
 ZFCP_DEFINE_ADAPTER_ATTR(physical_s_id, "0x%06x\n", adapter->physical_s_id);
 ZFCP_DEFINE_ADAPTER_ATTR(card_version, "0x%04x\n", adapter->hydra_version);
 ZFCP_DEFINE_ADAPTER_ATTR(lic_version, "0x%08x\n", adapter->fsf_lic_version);
-ZFCP_DEFINE_ADAPTER_ATTR(fc_link_speed, "%d Gb/s\n", adapter->fc_link_speed);
 ZFCP_DEFINE_ADAPTER_ATTR(fc_service_class, "%d\n", adapter->fc_service_class);
 ZFCP_DEFINE_ADAPTER_ATTR(fc_topology, "%s\n",
 			 fc_topologies[adapter->fc_topology]);
 ZFCP_DEFINE_ADAPTER_ATTR(hardware_version, "0x%08x\n",
 			 adapter->hardware_version);
-ZFCP_DEFINE_ADAPTER_ATTR(serial_number, "%17s\n", adapter->serial_number);
 ZFCP_DEFINE_ADAPTER_ATTR(scsi_host_no, "0x%x\n", adapter->scsi_host_no);
 ZFCP_DEFINE_ADAPTER_ATTR(in_recovery, "%d\n", atomic_test_mask
 			 (ZFCP_STATUS_COMMON_ERP_INUSE, &adapter->status));
@@ -257,9 +252,6 @@ static struct attribute *zfcp_adapter_at
 	&dev_attr_in_recovery.attr,
 	&dev_attr_port_remove.attr,
 	&dev_attr_port_add.attr,
-	&dev_attr_wwnn.attr,
-	&dev_attr_wwpn.attr,
-	&dev_attr_s_id.attr,
 	&dev_attr_peer_wwnn.attr,
 	&dev_attr_peer_wwpn.attr,
 	&dev_attr_peer_d_id.attr,
@@ -267,13 +259,11 @@ static struct attribute *zfcp_adapter_at
 	&dev_attr_physical_s_id.attr,
 	&dev_attr_card_version.attr,
 	&dev_attr_lic_version.attr,
-	&dev_attr_fc_link_speed.attr,
 	&dev_attr_fc_service_class.attr,
 	&dev_attr_fc_topology.attr,
 	&dev_attr_scsi_host_no.attr,
 	&dev_attr_status.attr,
 	&dev_attr_hardware_version.attr,
-	&dev_attr_serial_number.attr,
 	NULL
 };
 

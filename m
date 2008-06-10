From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 1/8] zfcp: Move FC code to new file
Date: Tue, 10 Jun 2008 18:20:54 +0200
Message-ID: <20080610162512.955235000@de.ibm.com>
References: <20080610162053.144590000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate4.de.ibm.com ([195.212.29.153]:47120 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752870AbYFJQZV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Jun 2008 12:25:21 -0400
Content-Disposition: inline; filename=fc.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, Christof Schmitt <christof.schmitt@de.ibm.com>, Swen Schillig <swen@vnet.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

Move all Fibre Channel related code to new file and cleanup the code
while doing so.

Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
Signed-off-by: Swen Schillig <swen@vnet.ibm.com>
---
 drivers/s390/scsi/Makefile   |    2 
 drivers/s390/scsi/zfcp_aux.c |  518 -------------------------------------------
 drivers/s390/scsi/zfcp_dbf.c |    4 
 drivers/s390/scsi/zfcp_def.h |    8 
 drivers/s390/scsi/zfcp_erp.c |  188 ---------------
 drivers/s390/scsi/zfcp_ext.h |   12 
 drivers/s390/scsi/zfcp_fc.c  |  305 +++++++++++++++++++++++++
 drivers/s390/scsi/zfcp_fsf.c |    8 
 8 files changed, 319 insertions(+), 726 deletions(-)

--- a/drivers/s390/scsi/Makefile	2008-06-09 13:27:18.000000000 +0200
+++ b/drivers/s390/scsi/Makefile	2008-06-09 13:27:23.000000000 +0200
@@ -4,6 +4,6 @@
 
 zfcp-objs := zfcp_aux.o zfcp_ccw.o zfcp_scsi.o zfcp_erp.o zfcp_qdio.o \
 	     zfcp_fsf.o zfcp_dbf.o zfcp_sysfs_adapter.o zfcp_sysfs_port.o \
-	     zfcp_sysfs_unit.o zfcp_sysfs_driver.o
+	     zfcp_sysfs_unit.o zfcp_sysfs_driver.o zfcp_fc.o
 
 obj-$(CONFIG_ZFCP) += zfcp.o
--- a/drivers/s390/scsi/zfcp_aux.c	2008-06-09 13:27:23.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_aux.c	2008-06-09 13:27:23.000000000 +0200
@@ -43,9 +43,6 @@ static char *device;
 /* written against the module interface */
 static int __init  zfcp_module_init(void);
 
-/* FCP related */
-static void zfcp_ns_gid_pn_handler(unsigned long);
-
 /* miscellaneous */
 static int zfcp_sg_list_alloc(struct zfcp_sg_list *, size_t);
 static void zfcp_sg_list_free(struct zfcp_sg_list *);
@@ -1349,518 +1346,3 @@ zfcp_nameserver_enqueue(struct zfcp_adap
 }
 
 #undef ZFCP_LOG_AREA
-
-/****************************************************************/
-/******* Fibre Channel Standard related Functions  **************/
-/****************************************************************/
-
-#define ZFCP_LOG_AREA                   ZFCP_LOG_AREA_FC
-
-static void zfcp_fsf_incoming_els_rscn(struct zfcp_fsf_req *fsf_req)
-{
-	struct fsf_status_read_buffer *status_buffer = (void*)fsf_req->data;
-	struct zfcp_adapter *adapter = fsf_req->adapter;
-	struct fcp_rscn_head *fcp_rscn_head;
-	struct fcp_rscn_element *fcp_rscn_element;
-	struct zfcp_port *port;
-	u16 i;
-	u16 no_entries;
-	u32 range_mask;
-	unsigned long flags;
-
-	fcp_rscn_head = (struct fcp_rscn_head *) status_buffer->payload;
-	fcp_rscn_element = (struct fcp_rscn_element *) status_buffer->payload;
-
-	/* see FC-FS */
-	no_entries = (fcp_rscn_head->payload_len / 4);
-
-	for (i = 1; i < no_entries; i++) {
-		/* skip head and start with 1st element */
-		fcp_rscn_element++;
-		switch (fcp_rscn_element->addr_format) {
-		case ZFCP_PORT_ADDRESS:
-			range_mask = ZFCP_PORTS_RANGE_PORT;
-			break;
-		case ZFCP_AREA_ADDRESS:
-			range_mask = ZFCP_PORTS_RANGE_AREA;
-			break;
-		case ZFCP_DOMAIN_ADDRESS:
-			range_mask = ZFCP_PORTS_RANGE_DOMAIN;
-			break;
-		case ZFCP_FABRIC_ADDRESS:
-			range_mask = ZFCP_PORTS_RANGE_FABRIC;
-			break;
-		default:
-			ZFCP_LOG_INFO("incoming RSCN with unknown "
-				      "address format\n");
-			continue;
-		}
-		read_lock_irqsave(&zfcp_data.config_lock, flags);
-		list_for_each_entry(port, &adapter->port_list_head, list) {
-			if (atomic_test_mask
-			    (ZFCP_STATUS_PORT_WKA, &port->status))
-				continue;
-			/* Do we know this port? If not skip it. */
-			if (!atomic_test_mask
-			    (ZFCP_STATUS_PORT_DID_DID, &port->status)) {
-				ZFCP_LOG_INFO("incoming RSCN, trying to open "
-					      "port 0x%016Lx\n", port->wwpn);
-				zfcp_erp_port_reopen(port,
-						     ZFCP_STATUS_COMMON_ERP_FAILED,
-						     82, fsf_req);
-				continue;
-			}
-
-			/*
-			 * FIXME: race: d_id might being invalidated
-			 * (...DID_DID reset)
-			 */
-			if ((port->d_id & range_mask)
-			    == (fcp_rscn_element->nport_did & range_mask)) {
-				ZFCP_LOG_TRACE("reopen did 0x%08x\n",
-					       fcp_rscn_element->nport_did);
-				/*
-				 * Unfortunately, an RSCN does not specify the
-				 * type of change a target underwent. We assume
-				 * that it makes sense to reopen the link.
-				 * FIXME: Shall we try to find out more about
-				 * the target and link state before closing it?
-				 * How to accomplish this? (nameserver?)
-				 * Where would such code be put in?
-				 * (inside or outside erp)
-				 */
-				ZFCP_LOG_INFO("incoming RSCN, trying to open "
-					      "port 0x%016Lx\n", port->wwpn);
-				zfcp_test_link(port);
-			}
-		}
-		read_unlock_irqrestore(&zfcp_data.config_lock, flags);
-	}
-}
-
-static void zfcp_fsf_incoming_els_plogi(struct zfcp_fsf_req *fsf_req)
-{
-	struct fsf_status_read_buffer *status_buffer = (void*)fsf_req->data;
-	struct zfcp_adapter *adapter = fsf_req->adapter;
-	struct fsf_plogi *els_plogi;
-	struct zfcp_port *port;
-	unsigned long flags;
-
-	els_plogi = (struct fsf_plogi *) status_buffer->payload;
-	read_lock_irqsave(&zfcp_data.config_lock, flags);
-	list_for_each_entry(port, &adapter->port_list_head, list) {
-		if (port->wwpn == (*(wwn_t *) &els_plogi->serv_param.wwpn))
-			break;
-	}
-	read_unlock_irqrestore(&zfcp_data.config_lock, flags);
-
-	if (!port || (port->wwpn != (*(wwn_t *) &els_plogi->serv_param.wwpn))) {
-		ZFCP_LOG_DEBUG("ignored incoming PLOGI for nonexisting port "
-			       "with d_id 0x%06x on adapter %s\n",
-			       status_buffer->d_id,
-			       zfcp_get_busid_by_adapter(adapter));
-	} else {
-		zfcp_erp_port_forced_reopen(port, 0, 83, fsf_req);
-	}
-}
-
-static void zfcp_fsf_incoming_els_logo(struct zfcp_fsf_req *fsf_req)
-{
-	struct fsf_status_read_buffer *status_buffer = (void*)fsf_req->data;
-	struct zfcp_adapter *adapter = fsf_req->adapter;
-	struct fcp_logo *els_logo = (struct fcp_logo *) status_buffer->payload;
-	struct zfcp_port *port;
-	unsigned long flags;
-
-	read_lock_irqsave(&zfcp_data.config_lock, flags);
-	list_for_each_entry(port, &adapter->port_list_head, list) {
-		if (port->wwpn == els_logo->nport_wwpn)
-			break;
-	}
-	read_unlock_irqrestore(&zfcp_data.config_lock, flags);
-
-	if (!port || (port->wwpn != els_logo->nport_wwpn)) {
-		ZFCP_LOG_DEBUG("ignored incoming LOGO for nonexisting port "
-			       "with d_id 0x%06x on adapter %s\n",
-			       status_buffer->d_id,
-			       zfcp_get_busid_by_adapter(adapter));
-	} else {
-		zfcp_erp_port_forced_reopen(port, 0, 84, fsf_req);
-	}
-}
-
-static void
-zfcp_fsf_incoming_els_unknown(struct zfcp_adapter *adapter,
-			      struct fsf_status_read_buffer *status_buffer)
-{
-	ZFCP_LOG_NORMAL("warning: unknown incoming ELS 0x%08x "
-			"for adapter %s\n", *(u32 *) (status_buffer->payload),
-			zfcp_get_busid_by_adapter(adapter));
-
-}
-
-void
-zfcp_fsf_incoming_els(struct zfcp_fsf_req *fsf_req)
-{
-	struct fsf_status_read_buffer *status_buffer;
-	u32 els_type;
-	struct zfcp_adapter *adapter;
-
-	status_buffer = (struct fsf_status_read_buffer *) fsf_req->data;
-	els_type = *(u32 *) (status_buffer->payload);
-	adapter = fsf_req->adapter;
-
-	zfcp_san_dbf_event_incoming_els(fsf_req);
-	if (els_type == LS_PLOGI)
-		zfcp_fsf_incoming_els_plogi(fsf_req);
-	else if (els_type == LS_LOGO)
-		zfcp_fsf_incoming_els_logo(fsf_req);
-	else if ((els_type & 0xffff0000) == LS_RSCN)
-		/* we are only concerned with the command, not the length */
-		zfcp_fsf_incoming_els_rscn(fsf_req);
-	else
-		zfcp_fsf_incoming_els_unknown(adapter, status_buffer);
-}
-
-
-/**
- * zfcp_gid_pn_buffers_alloc - allocate buffers for GID_PN nameserver request
- * @gid_pn: pointer to return pointer to struct zfcp_gid_pn_data
- * @pool: pointer to mempool_t if non-null memory pool is used for allocation
- */
-static int
-zfcp_gid_pn_buffers_alloc(struct zfcp_gid_pn_data **gid_pn, mempool_t *pool)
-{
-	struct zfcp_gid_pn_data *data;
-
-	if (pool)
-		data = mempool_alloc(pool, GFP_ATOMIC);
-	else
-		data = kmem_cache_alloc(zfcp_data.gid_pn_cache, GFP_ATOMIC);
-
-        if (NULL == data)
-                return -ENOMEM;
-
-	memset(data, 0, sizeof(*data));
-	data->ct.pool = pool;
-	sg_init_table(&data->req , 1);
-	sg_init_table(&data->resp , 1);
-        data->ct.req = &data->req;
-        data->ct.resp = &data->resp;
-	data->ct.req_count = data->ct.resp_count = 1;
-	zfcp_address_to_sg(&data->ct_iu_req, &data->req, sizeof(struct ct_iu_gid_pn_req));
-        zfcp_address_to_sg(&data->ct_iu_resp, &data->resp, sizeof(struct ct_iu_gid_pn_resp));
-
-	*gid_pn = data;
-	return 0;
-}
-
-/**
- * zfcp_gid_pn_buffers_free - free buffers for GID_PN nameserver request
- * @gid_pn: pointer to struct zfcp_gid_pn_data which has to be freed
- */
-static void zfcp_gid_pn_buffers_free(struct zfcp_gid_pn_data *gid_pn)
-{
-	if (gid_pn->ct.pool)
-		mempool_free(gid_pn, gid_pn->ct.pool);
-	else
-		kmem_cache_free(zfcp_data.gid_pn_cache, gid_pn);
-}
-
-/**
- * zfcp_ns_gid_pn_request - initiate GID_PN nameserver request
- * @erp_action: pointer to zfcp_erp_action where GID_PN request is needed
- */
-int
-zfcp_ns_gid_pn_request(struct zfcp_erp_action *erp_action)
-{
-	int ret;
-        struct ct_iu_gid_pn_req *ct_iu_req;
-        struct zfcp_gid_pn_data *gid_pn;
-        struct zfcp_adapter *adapter = erp_action->adapter;
-
-	ret = zfcp_gid_pn_buffers_alloc(&gid_pn, adapter->pool.data_gid_pn);
-	if (ret < 0) {
-		ZFCP_LOG_INFO("error: buffer allocation for gid_pn nameserver "
-			      "request failed for adapter %s\n",
-			      zfcp_get_busid_by_adapter(adapter));
-		goto out;
-	}
-
-	/* setup nameserver request */
-        ct_iu_req = zfcp_sg_to_address(gid_pn->ct.req);
-        ct_iu_req->header.revision = ZFCP_CT_REVISION;
-        ct_iu_req->header.gs_type = ZFCP_CT_DIRECTORY_SERVICE;
-        ct_iu_req->header.gs_subtype = ZFCP_CT_NAME_SERVER;
-        ct_iu_req->header.options = ZFCP_CT_SYNCHRONOUS;
-        ct_iu_req->header.cmd_rsp_code = ZFCP_CT_GID_PN;
-        ct_iu_req->header.max_res_size = ZFCP_CT_MAX_SIZE;
-	ct_iu_req->wwpn = erp_action->port->wwpn;
-
-        /* setup parameters for send generic command */
-        gid_pn->ct.port = adapter->nameserver_port;
-	gid_pn->ct.handler = zfcp_ns_gid_pn_handler;
-	gid_pn->ct.handler_data = (unsigned long) gid_pn;
-        gid_pn->ct.timeout = ZFCP_NS_GID_PN_TIMEOUT;
-	gid_pn->port = erp_action->port;
-
-	ret = zfcp_fsf_send_ct(&gid_pn->ct, adapter->pool.fsf_req_erp,
-			       erp_action);
-	if (ret) {
-		ZFCP_LOG_INFO("error: initiation of gid_pn nameserver request "
-                              "failed for adapter %s\n",
-			      zfcp_get_busid_by_adapter(adapter));
-
-                zfcp_gid_pn_buffers_free(gid_pn);
-	}
-
- out:
-	return ret;
-}
-
-/**
- * zfcp_ns_gid_pn_handler - handler for GID_PN nameserver request
- * @data: unsigned long, contains pointer to struct zfcp_gid_pn_data
- */
-static void zfcp_ns_gid_pn_handler(unsigned long data)
-{
-	struct zfcp_port *port;
-        struct zfcp_send_ct *ct;
-	struct ct_iu_gid_pn_req *ct_iu_req;
-	struct ct_iu_gid_pn_resp *ct_iu_resp;
-        struct zfcp_gid_pn_data *gid_pn;
-
-
-	gid_pn = (struct zfcp_gid_pn_data *) data;
-	port = gid_pn->port;
-        ct = &gid_pn->ct;
-	ct_iu_req = zfcp_sg_to_address(ct->req);
-	ct_iu_resp = zfcp_sg_to_address(ct->resp);
-
-	if (ct->status != 0)
-		goto failed;
-
-	if (zfcp_check_ct_response(&ct_iu_resp->header)) {
-		/* FIXME: do we need some specific erp entry points */
-		atomic_set_mask(ZFCP_STATUS_PORT_INVALID_WWPN, &port->status);
-		goto failed;
-	}
-	/* paranoia */
-	if (ct_iu_req->wwpn != port->wwpn) {
-		ZFCP_LOG_NORMAL("bug: wwpn 0x%016Lx returned by nameserver "
-				"lookup does not match expected wwpn 0x%016Lx "
-				"for adapter %s\n", ct_iu_req->wwpn, port->wwpn,
-				zfcp_get_busid_by_port(port));
-		goto mismatch;
-	}
-
-	/* looks like a valid d_id */
-        port->d_id = ct_iu_resp->d_id & ZFCP_DID_MASK;
-	atomic_set_mask(ZFCP_STATUS_PORT_DID_DID, &port->status);
-	ZFCP_LOG_DEBUG("adapter %s:  wwpn=0x%016Lx ---> d_id=0x%06x\n",
-		       zfcp_get_busid_by_port(port), port->wwpn, port->d_id);
-	goto out;
-
- mismatch:
-	ZFCP_LOG_DEBUG("CT IUs do not match:\n");
-	ZFCP_HEX_DUMP(ZFCP_LOG_LEVEL_DEBUG, (char *) ct_iu_req,
-		      sizeof(struct ct_iu_gid_pn_req));
-	ZFCP_HEX_DUMP(ZFCP_LOG_LEVEL_DEBUG, (char *) ct_iu_resp,
-		      sizeof(struct ct_iu_gid_pn_resp));
-
- failed:
-	ZFCP_LOG_NORMAL("warning: failed gid_pn nameserver request for wwpn "
-			"0x%016Lx for adapter %s\n",
-			port->wwpn, zfcp_get_busid_by_port(port));
- out:
-        zfcp_gid_pn_buffers_free(gid_pn);
-	return;
-}
-
-/* reject CT_IU reason codes acc. to FC-GS-4 */
-static const struct zfcp_rc_entry zfcp_ct_rc[] = {
-	{0x01, "invalid command code"},
-	{0x02, "invalid version level"},
-	{0x03, "logical error"},
-	{0x04, "invalid CT_IU size"},
-	{0x05, "logical busy"},
-	{0x07, "protocol error"},
-	{0x09, "unable to perform command request"},
-	{0x0b, "command not supported"},
-	{0x0d, "server not available"},
-	{0x0e, "session could not be established"},
-	{0xff, "vendor specific error"},
-	{0, NULL},
-};
-
-/* LS_RJT reason codes acc. to FC-FS */
-static const struct zfcp_rc_entry zfcp_ls_rjt_rc[] = {
-	{0x01, "invalid LS_Command code"},
-	{0x03, "logical error"},
-	{0x05, "logical busy"},
-	{0x07, "protocol error"},
-	{0x09, "unable to perform command request"},
-	{0x0b, "command not supported"},
-	{0x0e, "command already in progress"},
-	{0xff, "vendor specific error"},
-	{0, NULL},
-};
-
-/* reject reason codes according to FC-PH/FC-FS */
-static const struct zfcp_rc_entry zfcp_p_rjt_rc[] = {
-	{0x01, "invalid D_ID"},
-	{0x02, "invalid S_ID"},
-	{0x03, "Nx_Port not available, temporary"},
-	{0x04, "Nx_Port not available, permament"},
-	{0x05, "class not supported"},
-	{0x06, "delimiter usage error"},
-	{0x07, "TYPE not supported"},
-	{0x08, "invalid Link_Control"},
-	{0x09, "invalid R_CTL field"},
-	{0x0a, "invalid F_CTL field"},
-	{0x0b, "invalid OX_ID"},
-	{0x0c, "invalid RX_ID"},
-	{0x0d, "invalid SEQ_ID"},
-	{0x0e, "invalid DF_CTL"},
-	{0x0f, "invalid SEQ_CNT"},
-	{0x10, "invalid parameter field"},
-	{0x11, "exchange error"},
-	{0x12, "protocol error"},
-	{0x13, "incorrect length"},
-	{0x14, "unsupported ACK"},
-	{0x15, "class of service not supported by entity at FFFFFE"},
-	{0x16, "login required"},
-	{0x17, "excessive sequences attempted"},
-	{0x18, "unable to establish exchange"},
-	{0x1a, "fabric path not available"},
-	{0x1b, "invalid VC_ID (class 4)"},
-	{0x1c, "invalid CS_CTL field"},
-	{0x1d, "insufficient resources for VC (class 4)"},
-	{0x1f, "invalid class of service"},
-	{0x20, "preemption request rejected"},
-	{0x21, "preemption not enabled"},
-	{0x22, "multicast error"},
-	{0x23, "multicast error terminate"},
-	{0x24, "process login required"},
-	{0xff, "vendor specific reject"},
-	{0, NULL},
-};
-
-/**
- * zfcp_rc_description - return description for given reaon code
- * @code: reason code
- * @rc_table: table of reason codes and descriptions
- */
-static const char *
-zfcp_rc_description(u8 code, const struct zfcp_rc_entry *rc_table)
-{
-	const char *descr = "unknown reason code";
-
-	do {
-		if (code == rc_table->code) {
-			descr = rc_table->description;
-			break;
-		}
-		rc_table++;
-	} while (rc_table->code && rc_table->description);
-
-	return descr;
-}
-
-/**
- * zfcp_check_ct_response - evaluate reason code for CT_IU
- * @rjt: response payload to an CT_IU request
- * Return: 0 for accept CT_IU, 1 for reject CT_IU or invlid response code
- */
-int
-zfcp_check_ct_response(struct ct_hdr *rjt)
-{
-	if (rjt->cmd_rsp_code == ZFCP_CT_ACCEPT)
-		return 0;
-
-	if (rjt->cmd_rsp_code != ZFCP_CT_REJECT) {
-		ZFCP_LOG_NORMAL("error: invalid Generic Service command/"
-				"response code (0x%04hx)\n",
-				rjt->cmd_rsp_code);
-		return 1;
-	}
-
-	ZFCP_LOG_INFO("Generic Service command rejected\n");
-	ZFCP_LOG_INFO("%s (0x%02x, 0x%02x, 0x%02x)\n",
-		      zfcp_rc_description(rjt->reason_code, zfcp_ct_rc),
-		      (u32) rjt->reason_code, (u32) rjt->reason_code_expl,
-		      (u32) rjt->vendor_unique);
-
-	return 1;
-}
-
-/**
- * zfcp_print_els_rjt - print reject parameter and description for ELS reject
- * @rjt_par: reject parameter acc. to FC-PH/FC-FS
- * @rc_table: table of reason codes and descriptions
- */
-static void
-zfcp_print_els_rjt(struct zfcp_ls_rjt_par *rjt_par,
-		   const struct zfcp_rc_entry *rc_table)
-{
-	ZFCP_LOG_INFO("%s (%02x %02x %02x %02x)\n",
-		      zfcp_rc_description(rjt_par->reason_code, rc_table),
-		      (u32) rjt_par->action, (u32) rjt_par->reason_code,
-		      (u32) rjt_par->reason_expl, (u32) rjt_par->vendor_unique);
-}
-
-/**
- * zfcp_fsf_handle_els_rjt - evaluate status qualifier/reason code on ELS reject
- * @sq: status qualifier word
- * @rjt_par: reject parameter as described in FC-PH and FC-FS
- * Return: -EROMTEIO for LS_RJT, -EREMCHG for invalid D_ID, -EIO else
- */
-int
-zfcp_handle_els_rjt(u32 sq, struct zfcp_ls_rjt_par *rjt_par)
-{
-	int ret = -EIO;
-
-	if (sq == FSF_IOSTAT_NPORT_RJT) {
-		ZFCP_LOG_INFO("ELS rejected (P_RJT)\n");
-		zfcp_print_els_rjt(rjt_par, zfcp_p_rjt_rc);
-		/* invalid d_id */
-		if (rjt_par->reason_code == 0x01)
-			ret = -EREMCHG;
-	} else if (sq == FSF_IOSTAT_FABRIC_RJT) {
-		ZFCP_LOG_INFO("ELS rejected (F_RJT)\n");
-		zfcp_print_els_rjt(rjt_par, zfcp_p_rjt_rc);
-		/* invalid d_id */
-		if (rjt_par->reason_code == 0x01)
-			ret = -EREMCHG;
-	} else if (sq == FSF_IOSTAT_LS_RJT) {
-		ZFCP_LOG_INFO("ELS rejected (LS_RJT)\n");
-		zfcp_print_els_rjt(rjt_par, zfcp_ls_rjt_rc);
-		ret = -EREMOTEIO;
-	} else
-		ZFCP_LOG_INFO("unexpected SQ: 0x%02x\n", sq);
-
-	return ret;
-}
-
-/**
- * zfcp_plogi_evaluate - evaluate PLOGI playload and copy important fields
- * into zfcp_port structure
- * @port: zfcp_port structure
- * @plogi: plogi payload
- */
-void
-zfcp_plogi_evaluate(struct zfcp_port *port, struct fsf_plogi *plogi)
-{
-	port->maxframe_size = plogi->serv_param.common_serv_param[7] |
-		((plogi->serv_param.common_serv_param[6] & 0x0F) << 8);
-	if (plogi->serv_param.class1_serv_param[0] & 0x80)
-		port->supported_classes |= FC_COS_CLASS1;
-	if (plogi->serv_param.class2_serv_param[0] & 0x80)
-		port->supported_classes |= FC_COS_CLASS2;
-	if (plogi->serv_param.class3_serv_param[0] & 0x80)
-		port->supported_classes |= FC_COS_CLASS3;
-	if (plogi->serv_param.class4_serv_param[0] & 0x80)
-		port->supported_classes |= FC_COS_CLASS4;
-}
-
-#undef ZFCP_LOG_AREA
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ b/drivers/s390/scsi/zfcp_fc.c	2008-06-09 13:37:16.000000000 +0200
@@ -0,0 +1,305 @@
+/*
+ * zfcp device driver
+ *
+ * Fibre Channel related functions for the zfcp device driver.
+ *
+ * Copyright IBM Corporation 2008
+ */
+
+#include "zfcp_ext.h"
+
+static void _zfcp_fc_incoming_rscn(struct zfcp_fsf_req *fsf_req, u32 range,
+				   struct fcp_rscn_element *elem)
+{
+	unsigned long flags;
+	struct zfcp_port *port;
+
+	read_lock_irqsave(&zfcp_data.config_lock, flags);
+	list_for_each_entry(port, &fsf_req->adapter->port_list_head, list) {
+		if (atomic_test_mask(ZFCP_STATUS_PORT_WKA, &port->status))
+			continue;
+		/* FIXME: ZFCP_STATUS_PORT_DID_DID check is racy */
+		if (!atomic_test_mask(ZFCP_STATUS_PORT_DID_DID, &port->status))
+			/* Try to connect to unused ports anyway. */
+			zfcp_erp_port_reopen(port,
+					     ZFCP_STATUS_COMMON_ERP_FAILED,
+					     82, fsf_req);
+		else if ((port->d_id & range) == (elem->nport_did & range))
+			/* Check connection status for connected ports */
+			zfcp_test_link(port);
+	}
+	read_unlock_irqrestore(&zfcp_data.config_lock, flags);
+}
+
+static void zfcp_fc_incoming_rscn(struct zfcp_fsf_req *fsf_req)
+{
+	struct fsf_status_read_buffer *status_buffer = (void *)fsf_req->data;
+	struct fcp_rscn_head *fcp_rscn_head;
+	struct fcp_rscn_element *fcp_rscn_element;
+	u16 i;
+	u16 no_entries;
+	u32 range_mask;
+
+	fcp_rscn_head = (struct fcp_rscn_head *) status_buffer->payload;
+	fcp_rscn_element = (struct fcp_rscn_element *) status_buffer->payload;
+
+	/* see FC-FS */
+	no_entries = fcp_rscn_head->payload_len /
+			sizeof(struct fcp_rscn_element);
+
+	for (i = 1; i < no_entries; i++) {
+		/* skip head and start with 1st element */
+		fcp_rscn_element++;
+		switch (fcp_rscn_element->addr_format) {
+		case ZFCP_PORT_ADDRESS:
+			range_mask = ZFCP_PORTS_RANGE_PORT;
+			break;
+		case ZFCP_AREA_ADDRESS:
+			range_mask = ZFCP_PORTS_RANGE_AREA;
+			break;
+		case ZFCP_DOMAIN_ADDRESS:
+			range_mask = ZFCP_PORTS_RANGE_DOMAIN;
+			break;
+		case ZFCP_FABRIC_ADDRESS:
+			range_mask = ZFCP_PORTS_RANGE_FABRIC;
+			break;
+		default:
+			continue;
+		}
+		_zfcp_fc_incoming_rscn(fsf_req, range_mask, fcp_rscn_element);
+	}
+}
+
+static void zfcp_fc_incoming_wwpn(struct zfcp_fsf_req *req, wwn_t wwpn)
+{
+	struct zfcp_adapter *adapter = req->adapter;
+	struct zfcp_port *port;
+	unsigned long flags;
+
+	read_lock_irqsave(&zfcp_data.config_lock, flags);
+	list_for_each_entry(port, &adapter->port_list_head, list)
+		if (port->wwpn == wwpn)
+			break;
+	read_unlock_irqrestore(&zfcp_data.config_lock, flags);
+
+	if (port && (port->wwpn == wwpn))
+		zfcp_erp_port_forced_reopen(port, 0, 83, req);
+}
+
+static void zfcp_fc_incoming_plogi(struct zfcp_fsf_req *req)
+{
+	struct fsf_status_read_buffer *status_buffer =
+		(struct fsf_status_read_buffer *)req->data;
+	struct fsf_plogi *els_plogi =
+		(struct fsf_plogi *) status_buffer->payload;
+
+	zfcp_fc_incoming_wwpn(req, els_plogi->serv_param.wwpn);
+}
+
+static void zfcp_fc_incoming_logo(struct zfcp_fsf_req *req)
+{
+	struct fsf_status_read_buffer *status_buffer =
+		(struct fsf_status_read_buffer *)req->data;
+	struct fcp_logo *els_logo = (struct fcp_logo *) status_buffer->payload;
+
+	zfcp_fc_incoming_wwpn(req, els_logo->nport_wwpn);
+}
+
+/**
+ * zfcp_fc_incoming_els - handle incoming ELS
+ * @fsf_req - request which contains incoming ELS
+ */
+void zfcp_fc_incoming_els(struct zfcp_fsf_req *fsf_req)
+{
+	struct fsf_status_read_buffer *status_buffer =
+		(struct fsf_status_read_buffer *) fsf_req->data;
+	unsigned int els_type = status_buffer->payload[0];
+
+	zfcp_san_dbf_event_incoming_els(fsf_req);
+	if (els_type == LS_PLOGI)
+		zfcp_fc_incoming_plogi(fsf_req);
+	else if (els_type == LS_LOGO)
+		zfcp_fc_incoming_logo(fsf_req);
+	else if (els_type == LS_RSCN)
+		zfcp_fc_incoming_rscn(fsf_req);
+}
+
+static void zfcp_ns_gid_pn_handler(unsigned long data)
+{
+	struct zfcp_gid_pn_data *gid_pn = (struct zfcp_gid_pn_data *) data;
+	struct zfcp_send_ct *ct = &gid_pn->ct;
+	struct ct_iu_gid_pn_req *ct_iu_req = sg_virt(ct->req);
+	struct ct_iu_gid_pn_resp *ct_iu_resp = sg_virt(ct->resp);
+	struct zfcp_port *port = gid_pn->port;
+
+	if (ct->status)
+		goto out;
+	if (ct_iu_resp->header.cmd_rsp_code != ZFCP_CT_ACCEPT) {
+		atomic_set_mask(ZFCP_STATUS_PORT_INVALID_WWPN, &port->status);
+		goto out;
+	}
+	/* paranoia */
+	if (ct_iu_req->wwpn != port->wwpn)
+		goto out;
+	/* looks like a valid d_id */
+	port->d_id = ct_iu_resp->d_id & ZFCP_DID_MASK;
+	atomic_set_mask(ZFCP_STATUS_PORT_DID_DID, &port->status);
+out:
+	mempool_free(gid_pn, port->adapter->pool.data_gid_pn);
+}
+
+/**
+ * zfcp_fc_ns_gid_pn_request - initiate GID_PN nameserver request
+ * @erp_action: pointer to zfcp_erp_action where GID_PN request is needed
+ * return: -ENOMEM on error, 0 otherwise
+ */
+int zfcp_fc_ns_gid_pn_request(struct zfcp_erp_action *erp_action)
+{
+	int ret;
+	struct zfcp_gid_pn_data *gid_pn;
+	struct zfcp_adapter *adapter = erp_action->adapter;
+
+	gid_pn = mempool_alloc(adapter->pool.data_gid_pn, GFP_ATOMIC);
+	if (!gid_pn)
+		return -ENOMEM;
+
+	memset(gid_pn, 0, sizeof(*gid_pn));
+
+	/* setup parameters for send generic command */
+	gid_pn->port = erp_action->port;
+	gid_pn->ct.port = adapter->nameserver_port;
+	gid_pn->ct.handler = zfcp_ns_gid_pn_handler;
+	gid_pn->ct.handler_data = (unsigned long) gid_pn;
+	gid_pn->ct.timeout = ZFCP_NS_GID_PN_TIMEOUT;
+	gid_pn->ct.req = &gid_pn->req;
+	gid_pn->ct.resp = &gid_pn->resp;
+	gid_pn->ct.req_count = 1;
+	gid_pn->ct.resp_count = 1;
+	sg_init_one(&gid_pn->req, &gid_pn->ct_iu_req,
+		    sizeof(struct ct_iu_gid_pn_req));
+	sg_init_one(&gid_pn->resp, &gid_pn->ct_iu_resp,
+		    sizeof(struct ct_iu_gid_pn_resp));
+
+	/* setup nameserver request */
+	gid_pn->ct_iu_req.header.revision = ZFCP_CT_REVISION;
+	gid_pn->ct_iu_req.header.gs_type = ZFCP_CT_DIRECTORY_SERVICE;
+	gid_pn->ct_iu_req.header.gs_subtype = ZFCP_CT_NAME_SERVER;
+	gid_pn->ct_iu_req.header.options = ZFCP_CT_SYNCHRONOUS;
+	gid_pn->ct_iu_req.header.cmd_rsp_code = ZFCP_CT_GID_PN;
+	gid_pn->ct_iu_req.header.max_res_size = ZFCP_CT_MAX_SIZE;
+	gid_pn->ct_iu_req.wwpn = erp_action->port->wwpn;
+
+	ret = zfcp_fsf_send_ct(&gid_pn->ct, adapter->pool.fsf_req_erp,
+			       erp_action);
+	if (ret)
+		mempool_free(gid_pn, adapter->pool.data_gid_pn);
+	return ret;
+}
+
+/**
+ * zfcp_fc_plogi_evaluate - evaluate PLOGI playload
+ * @port: zfcp_port structure
+ * @plogi: plogi payload
+ *
+ * Evaluate PLOGI playload and copy important fields into zfcp_port structure
+ */
+void zfcp_fc_plogi_evaluate(struct zfcp_port *port, struct fsf_plogi *plogi)
+{
+	port->maxframe_size = plogi->serv_param.common_serv_param[7] |
+		((plogi->serv_param.common_serv_param[6] & 0x0F) << 8);
+	if (plogi->serv_param.class1_serv_param[0] & 0x80)
+		port->supported_classes |= FC_COS_CLASS1;
+	if (plogi->serv_param.class2_serv_param[0] & 0x80)
+		port->supported_classes |= FC_COS_CLASS2;
+	if (plogi->serv_param.class3_serv_param[0] & 0x80)
+		port->supported_classes |= FC_COS_CLASS3;
+	if (plogi->serv_param.class4_serv_param[0] & 0x80)
+		port->supported_classes |= FC_COS_CLASS4;
+}
+
+struct zfcp_els_adisc {
+	struct zfcp_send_els els;
+	struct scatterlist req;
+	struct scatterlist resp;
+	struct zfcp_ls_adisc ls_adisc;
+	struct zfcp_ls_adisc_acc ls_adisc_acc;
+};
+
+static void zfcp_fc_adisc_handler(unsigned long data)
+{
+	struct zfcp_els_adisc *adisc = (struct zfcp_els_adisc *) data;
+	struct zfcp_port *port = adisc->els.port;
+	struct zfcp_ls_adisc_acc *ls_adisc = &adisc->ls_adisc_acc;
+
+	if (!adisc->els.status) {
+		/* request rejected or timed out */
+		zfcp_erp_port_forced_reopen(port, 0, 63, NULL);
+		goto out;
+	}
+
+	if (!port->wwnn)
+		port->wwnn = ls_adisc->wwnn;
+
+	if (port->wwpn != ls_adisc->wwpn)
+		zfcp_erp_port_reopen(port, 0, 64, NULL);
+
+ out:
+	zfcp_port_put(port);
+	kfree(adisc);
+}
+
+static int zfcp_fc_adisc(struct zfcp_port *port)
+{
+	struct zfcp_els_adisc *adisc;
+	struct zfcp_adapter *adapter = port->adapter;
+
+	adisc = kzalloc(sizeof(struct zfcp_els_adisc), GFP_ATOMIC);
+	if (!adisc)
+		return -ENOMEM;
+
+	adisc->els.req = &adisc->req;
+	adisc->els.resp = &adisc->resp;
+	sg_init_one(adisc->els.req, &adisc->ls_adisc,
+		    sizeof(struct zfcp_ls_adisc));
+	sg_init_one(adisc->els.resp, &adisc->ls_adisc_acc,
+		    sizeof(struct zfcp_ls_adisc_acc));
+
+	adisc->els.req_count = 1;
+	adisc->els.resp_count = 1;
+	adisc->els.adapter = adapter;
+	adisc->els.port = port;
+	adisc->els.d_id = port->d_id;
+	adisc->els.handler = zfcp_fc_adisc_handler;
+	adisc->els.handler_data = (unsigned long) adisc;
+	adisc->els.ls_code = adisc->ls_adisc.code = ZFCP_LS_ADISC;
+
+	/* acc. to FC-FS, hard_nport_id in ADISC should not be set for ports
+	   without FC-AL-2 capability, so we don't set it */
+	adisc->ls_adisc.wwpn = fc_host_port_name(adapter->scsi_host);
+	adisc->ls_adisc.wwnn = fc_host_node_name(adapter->scsi_host);
+	adisc->ls_adisc.nport_id = fc_host_port_id(adapter->scsi_host);
+
+	return zfcp_fsf_send_els(&adisc->els);
+}
+
+/**
+ * zfcp_test_link - lightweight link test procedure
+ * @port: port to be tested
+ *
+ * Test status of a link to a remote port using the ELS command ADISC.
+ * If there is a problem with the remote port, error recovery steps
+ * will be triggered.
+ */
+void zfcp_test_link(struct zfcp_port *port)
+{
+	int retval;
+
+	zfcp_port_get(port);
+	retval = zfcp_fc_adisc(port);
+	if (retval == 0 || retval == -EBUSY)
+		return;
+
+	/* send of ADISC was not possible */
+	zfcp_port_put(port);
+	zfcp_erp_port_forced_reopen(port, 0, 65, NULL);
+}
--- a/drivers/s390/scsi/zfcp_erp.c	2008-06-09 13:27:23.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_erp.c	2008-06-09 13:27:23.000000000 +0200
@@ -23,9 +23,6 @@
 
 #include "zfcp_ext.h"
 
-static int zfcp_erp_adisc(struct zfcp_port *);
-static void zfcp_erp_adisc_handler(unsigned long);
-
 static int zfcp_erp_adapter_reopen_internal(struct zfcp_adapter *, int, u8,
 					    void *);
 static int zfcp_erp_port_forced_reopen_internal(struct zfcp_port *, int, u8,
@@ -292,189 +289,6 @@ int zfcp_erp_unit_shutdown(struct zfcp_u
 	return retval;
 }
 
-
-/**
- * zfcp_erp_adisc - send ADISC ELS command
- * @port: port structure
- */
-static int
-zfcp_erp_adisc(struct zfcp_port *port)
-{
-	struct zfcp_adapter *adapter = port->adapter;
-	struct zfcp_send_els *send_els;
-	struct zfcp_ls_adisc *adisc;
-	void *address = NULL;
-	int retval = 0;
-
-	send_els = kzalloc(sizeof(struct zfcp_send_els), GFP_ATOMIC);
-	if (send_els == NULL)
-		goto nomem;
-
-	send_els->req = kmalloc(sizeof(struct scatterlist), GFP_ATOMIC);
-	if (send_els->req == NULL)
-		goto nomem;
-	sg_init_table(send_els->req, 1);
-
-	send_els->resp = kmalloc(sizeof(struct scatterlist), GFP_ATOMIC);
-	if (send_els->resp == NULL)
-		goto nomem;
-	sg_init_table(send_els->resp, 1);
-
-	address = (void *) get_zeroed_page(GFP_ATOMIC);
-	if (address == NULL)
-		goto nomem;
-
-	zfcp_address_to_sg(address, send_els->req, sizeof(struct zfcp_ls_adisc));
-	address += PAGE_SIZE >> 1;
-	zfcp_address_to_sg(address, send_els->resp, sizeof(struct zfcp_ls_adisc_acc));
-	send_els->req_count = send_els->resp_count = 1;
-
-	send_els->adapter = adapter;
-	send_els->port = port;
-	send_els->d_id = port->d_id;
-	send_els->handler = zfcp_erp_adisc_handler;
-	send_els->handler_data = (unsigned long) send_els;
-
-	adisc = zfcp_sg_to_address(send_els->req);
-	send_els->ls_code = adisc->code = ZFCP_LS_ADISC;
-
-	/* acc. to FC-FS, hard_nport_id in ADISC should not be set for ports
-	   without FC-AL-2 capability, so we don't set it */
-	adisc->wwpn = fc_host_port_name(adapter->scsi_host);
-	adisc->wwnn = fc_host_node_name(adapter->scsi_host);
-	adisc->nport_id = fc_host_port_id(adapter->scsi_host);
-	ZFCP_LOG_INFO("ADISC request from s_id 0x%06x to d_id 0x%06x "
-		      "(wwpn=0x%016Lx, wwnn=0x%016Lx, "
-		      "hard_nport_id=0x%06x, nport_id=0x%06x)\n",
-		      adisc->nport_id, send_els->d_id, (wwn_t) adisc->wwpn,
-		      (wwn_t) adisc->wwnn, adisc->hard_nport_id,
-		      adisc->nport_id);
-
-	retval = zfcp_fsf_send_els(send_els);
-	if (retval != 0) {
-		ZFCP_LOG_NORMAL("error: initiation of Send ELS failed for port "
-				"0x%06x on adapter %s\n", send_els->d_id,
-				zfcp_get_busid_by_adapter(adapter));
-		goto freemem;
-	}
-
-	goto out;
-
- nomem:
-	retval = -ENOMEM;
- freemem:
-	if (address != NULL)
-		__free_pages(sg_page(send_els->req), 0);
-	if (send_els != NULL) {
-		kfree(send_els->req);
-		kfree(send_els->resp);
-		kfree(send_els);
-	}
- out:
-	return retval;
-}
-
-
-/**
- * zfcp_erp_adisc_handler - handler for ADISC ELS command
- * @data: pointer to struct zfcp_send_els
- *
- * If ADISC failed (LS_RJT or timed out) forced reopen of the port is triggered.
- */
-static void
-zfcp_erp_adisc_handler(unsigned long data)
-{
-	struct zfcp_send_els *send_els;
-	struct zfcp_port *port;
-	struct zfcp_adapter *adapter;
-	u32 d_id;
-	struct zfcp_ls_adisc_acc *adisc;
-
-	send_els = (struct zfcp_send_els *) data;
-	adapter = send_els->adapter;
-	port = send_els->port;
-	d_id = send_els->d_id;
-
-	/* request rejected or timed out */
-	if (send_els->status != 0) {
-		ZFCP_LOG_NORMAL("ELS request rejected/timed out, "
-				"force physical port reopen "
-				"(adapter %s, port d_id=0x%06x)\n",
-				zfcp_get_busid_by_adapter(adapter), d_id);
-		if (zfcp_erp_port_forced_reopen(port, 0, 63, NULL))
-			ZFCP_LOG_NORMAL("failed reopen of port "
-					"(adapter %s, wwpn=0x%016Lx)\n",
-					zfcp_get_busid_by_port(port),
-					port->wwpn);
-		goto out;
-	}
-
-	adisc = zfcp_sg_to_address(send_els->resp);
-
-	ZFCP_LOG_INFO("ADISC response from d_id 0x%06x to s_id "
-		      "0x%06x (wwpn=0x%016Lx, wwnn=0x%016Lx, "
-		      "hard_nport_id=0x%06x, nport_id=0x%06x)\n",
-		      d_id, fc_host_port_id(adapter->scsi_host),
-		      (wwn_t) adisc->wwpn, (wwn_t) adisc->wwnn,
-		      adisc->hard_nport_id, adisc->nport_id);
-
-	/* set wwnn for port */
-	if (port->wwnn == 0)
-		port->wwnn = adisc->wwnn;
-
-	if (port->wwpn != adisc->wwpn) {
-		ZFCP_LOG_NORMAL("d_id assignment changed, reopening "
-				"port (adapter %s, wwpn=0x%016Lx, "
-				"adisc_resp_wwpn=0x%016Lx)\n",
-				zfcp_get_busid_by_port(port),
-				port->wwpn, (wwn_t) adisc->wwpn);
-		if (zfcp_erp_port_reopen(port, 0, 64, NULL))
-			ZFCP_LOG_NORMAL("failed reopen of port "
-					"(adapter %s, wwpn=0x%016Lx)\n",
-					zfcp_get_busid_by_port(port),
-					port->wwpn);
-	}
-
- out:
-	zfcp_port_put(port);
-	__free_pages(sg_page(send_els->req), 0);
-	kfree(send_els->req);
-	kfree(send_els->resp);
-	kfree(send_els);
-}
-
-
-/**
- * zfcp_test_link - lightweight link test procedure
- * @port: port to be tested
- *
- * Test status of a link to a remote port using the ELS command ADISC.
- */
-int
-zfcp_test_link(struct zfcp_port *port)
-{
-	int retval;
-
-	zfcp_port_get(port);
-	retval = zfcp_erp_adisc(port);
-	if (retval != 0 && retval != -EBUSY) {
-		zfcp_port_put(port);
-		ZFCP_LOG_NORMAL("reopen needed for port 0x%016Lx "
-				"on adapter %s\n ", port->wwpn,
-				zfcp_get_busid_by_port(port));
-		retval = zfcp_erp_port_forced_reopen(port, 0, 65, NULL);
-		if (retval != 0) {
-			ZFCP_LOG_NORMAL("reopen of remote port 0x%016Lx "
-					"on adapter %s failed\n", port->wwpn,
-					zfcp_get_busid_by_port(port));
-			retval = -EPERM;
-		}
-	}
-
-	return retval;
-}
-
-
 /*
  * function:
  *
@@ -2564,7 +2378,7 @@ zfcp_erp_port_strategy_open_common_looku
 {
 	int retval;
 
-	retval = zfcp_ns_gid_pn_request(erp_action);
+	retval = zfcp_fc_ns_gid_pn_request(erp_action);
 	if (retval == -ENOMEM) {
 		retval = ZFCP_ERP_NOMEM;
 		goto out;
--- a/drivers/s390/scsi/zfcp_ext.h	2008-06-09 13:27:23.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_ext.h	2008-06-09 13:27:23.000000000 +0200
@@ -103,7 +103,6 @@ extern int  zfcp_fsf_send_fcp_command_ta
 					   struct zfcp_unit *,
 					   struct scsi_cmnd *, int, int);
 extern int  zfcp_fsf_req_complete(struct zfcp_fsf_req *);
-extern void zfcp_fsf_incoming_els(struct zfcp_fsf_req *);
 extern void zfcp_fsf_req_free(struct zfcp_fsf_req *);
 extern struct zfcp_fsf_req *zfcp_fsf_send_fcp_command_task_management(
 	struct zfcp_adapter *, struct zfcp_unit *, u8, int);
@@ -111,11 +110,12 @@ extern struct zfcp_fsf_req *zfcp_fsf_abo
 	unsigned long, struct zfcp_adapter *, struct zfcp_unit *, int);
 
 /******************************* FC/FCP **************************************/
+extern void zfcp_fc_incoming_els(struct zfcp_fsf_req *);
+extern int  zfcp_fc_ns_gid_pn_request(struct zfcp_erp_action *);
+extern void zfcp_fc_plogi_evaluate(struct zfcp_port *, struct fsf_plogi *);
+extern void  zfcp_test_link(struct zfcp_port *);
+
 extern int  zfcp_nameserver_enqueue(struct zfcp_adapter *);
-extern int  zfcp_ns_gid_pn_request(struct zfcp_erp_action *);
-extern int  zfcp_check_ct_response(struct ct_hdr *);
-extern int  zfcp_handle_els_rjt(u32, struct zfcp_ls_rjt_par *);
-extern void zfcp_plogi_evaluate(struct zfcp_port *, struct fsf_plogi *);
 
 /******************************* SCSI ****************************************/
 extern int  zfcp_adapter_scsi_register(struct zfcp_adapter *);
@@ -158,8 +158,6 @@ extern int  zfcp_erp_thread_kill(struct 
 extern int  zfcp_erp_wait(struct zfcp_adapter *);
 extern void zfcp_erp_async_handler(struct zfcp_erp_action *, unsigned long);
 
-extern int  zfcp_test_link(struct zfcp_port *);
-
 extern void zfcp_erp_port_boxed(struct zfcp_port *, u8 id, void *ref);
 extern void zfcp_erp_unit_boxed(struct zfcp_unit *, u8 id, void *ref);
 extern void zfcp_erp_port_access_denied(struct zfcp_port *, u8 id, void *ref);
--- a/drivers/s390/scsi/zfcp_fsf.c	2008-06-09 13:27:23.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_fsf.c	2008-06-09 13:27:23.000000000 +0200
@@ -848,7 +848,7 @@ zfcp_fsf_status_read_handler(struct zfcp
 		break;
 
 	case FSF_STATUS_READ_INCOMING_ELS:
-		zfcp_fsf_incoming_els(fsf_req);
+		zfcp_fc_incoming_els(fsf_req);
 		break;
 
 	case FSF_STATUS_READ_SENSE_DATA_AVAIL:
@@ -1742,10 +1742,6 @@ static int zfcp_fsf_send_els_handler(str
 			break;
 		case FSF_SQ_ULP_DEPENDENT_ERP_REQUIRED:
 			fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
-			retval =
-			  zfcp_handle_els_rjt(header->fsf_status_qual.word[1],
-					      (struct zfcp_ls_rjt_par *)
-					      &header->fsf_status_qual.word[2]);
 			break;
 		case FSF_SQ_RETRY_IF_POSSIBLE:
 			fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
@@ -2534,7 +2530,7 @@ zfcp_fsf_open_port_handler(struct zfcp_f
 						&port->status);
 				} else {
 					port->wwnn = plogi->serv_param.wwnn;
-					zfcp_plogi_evaluate(port, plogi);
+					zfcp_fc_plogi_evaluate(port, plogi);
 				}
 			}
 		}
--- a/drivers/s390/scsi/zfcp_def.h	2008-06-09 13:27:23.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_def.h	2008-06-09 13:27:23.000000000 +0200
@@ -223,9 +223,9 @@ struct fcp_rsp_iu {
 #define RSP_CODE_TASKMAN_FAILED	 5
 
 /* see fc-fs */
-#define LS_RSCN  0x61040000
-#define LS_LOGO  0x05000000
-#define LS_PLOGI 0x03000000
+#define LS_RSCN  0x61
+#define LS_LOGO  0x05
+#define LS_PLOGI 0x03
 
 struct fcp_rscn_head {
         u8  command;
@@ -622,7 +622,6 @@ typedef void (*zfcp_send_ct_handler_t)(u
  * @resp_count: number of elements in response scatter-gather list
  * @handler: handler function (called for response to the request)
  * @handler_data: data passed to handler function
- * @pool: pointer to memory pool for ct request structure
  * @timeout: FSF timeout for this request
  * @completion: completion for synchronization purposes
  * @status: used to pass error status to calling function
@@ -635,7 +634,6 @@ struct zfcp_send_ct {
 	unsigned int resp_count;
 	zfcp_send_ct_handler_t handler;
 	unsigned long handler_data;
-	mempool_t *pool;
 	int timeout;
 	struct completion *completion;
 	int status;
--- a/drivers/s390/scsi/zfcp_dbf.c	2008-06-09 13:27:23.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_dbf.c	2008-06-09 13:27:23.000000000 +0200
@@ -546,8 +546,8 @@ static const char *zfcp_rec_dbf_ids[] = 
 	[80]	= "exclusive read-only unit access unsupported",
 	[81]	= "shared read-write unit access unsupported",
 	[82]	= "incoming rscn",
-	[83]	= "incoming plogi",
-	[84]	= "incoming logo",
+	[83]	= "incoming wwpn",
+	[84]	= "",
 	[85]	= "online",
 	[86]	= "offline",
 	[87]	= "ccw device gone",

-- 

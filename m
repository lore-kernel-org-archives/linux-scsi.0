From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 02/13] zfcp: Update message with input from review
Date: Wed, 01 Oct 2008 12:42:15 +0200
Message-ID: <20081001104757.790643000@de.ibm.com>
References: <20081001104213.585200000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate4.de.ibm.com ([195.212.29.153]:54433 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752467AbYJAKsG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Oct 2008 06:48:06 -0400
Content-Disposition: inline; filename=msg-update-from-review.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Christof Schmitt <christof.schmitt@de.ibm.com>, Swen Schillig <swen@vnet.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

Update the kernel messages in zfcp with input from the message review
and remove some messages that have been identified as redundant.

Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
Signed-off-by: Swen Schillig <swen@vnet.ibm.com>
--- a/drivers/s390/scsi/zfcp_aux.c	2008-09-19 08:40:51.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_aux.c	2008-09-19 09:51:59.000000000 +0200
@@ -100,8 +100,7 @@ static int __init zfcp_device_setup(char
 
  err_out:
 	kfree(str);
-	pr_err("zfcp: Parse error for device parameter string %s, "
-	       "device not attached.\n", devstr);
+	pr_err("zfcp: %s is not a valid SCSI device\n", devstr);
 	return 0;
 }
 
@@ -193,13 +192,14 @@ static int __init zfcp_module_init(void)
 
 	retval = misc_register(&zfcp_cfdc_misc);
 	if (retval) {
-		pr_err("zfcp: registration of misc device zfcp_cfdc failed\n");
+		pr_err("zfcp: Registering the misc device zfcp_cfdc failed\n");
 		goto out_misc;
 	}
 
 	retval = zfcp_ccw_register();
 	if (retval) {
-		pr_err("zfcp: Registration with common I/O layer failed.\n");
+		pr_err("zfcp: The zfcp device driver could not register with "
+		       "the common I/O layer\n");
 		goto out_ccw_register;
 	}
 
--- a/drivers/s390/scsi/zfcp_ccw.c	2008-09-19 08:40:51.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_ccw.c	2008-09-19 09:51:59.000000000 +0200
@@ -25,7 +25,8 @@ static int zfcp_ccw_probe(struct ccw_dev
 	down(&zfcp_data.config_sema);
 	if (zfcp_adapter_enqueue(ccw_device)) {
 		dev_err(&ccw_device->dev,
-			"Setup of data structures failed.\n");
+			"Setting up data structures for the "
+			"FCP adapter failed\n");
 		retval = -EINVAL;
 	}
 	up(&zfcp_data.config_sema);
@@ -156,15 +157,18 @@ static int zfcp_ccw_notify(struct ccw_de
 
 	switch (event) {
 	case CIO_GONE:
-		dev_warn(&adapter->ccw_device->dev, "device gone\n");
+		dev_warn(&adapter->ccw_device->dev,
+			 "The FCP device has been detached\n");
 		zfcp_erp_adapter_shutdown(adapter, 0, 87, NULL);
 		break;
 	case CIO_NO_PATH:
-		dev_warn(&adapter->ccw_device->dev, "no path\n");
+		dev_warn(&adapter->ccw_device->dev,
+			 "The CHPID for the FCP device is offline\n");
 		zfcp_erp_adapter_shutdown(adapter, 0, 88, NULL);
 		break;
 	case CIO_OPER:
-		dev_info(&adapter->ccw_device->dev, "operational again\n");
+		dev_info(&adapter->ccw_device->dev,
+			 "The FCP device is operational again\n");
 		zfcp_erp_modify_adapter_status(adapter, 11, NULL,
 					       ZFCP_STATUS_COMMON_RUNNING,
 					       ZFCP_SET);
--- a/drivers/s390/scsi/zfcp_erp.c	2008-09-19 08:40:51.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_erp.c	2008-09-19 09:52:21.000000000 +0200
@@ -901,11 +901,6 @@ static int zfcp_erp_open_ptp_port(struct
 	struct zfcp_port *port = act->port;
 
 	if (port->wwpn != adapter->peer_wwpn) {
-		dev_err(&adapter->ccw_device->dev,
-			"Failed to open port 0x%016Lx, "
-			"Peer WWPN 0x%016Lx does not "
-			"match.\n", port->wwpn,
-			adapter->peer_wwpn);
 		zfcp_erp_port_failed(port, 25, NULL);
 		return ZFCP_ERP_FAILED;
 	}
@@ -929,7 +924,8 @@ static int zfcp_erp_port_strategy_open_c
 			return zfcp_erp_open_ptp_port(act);
 		if (!ns_port) {
 			dev_err(&adapter->ccw_device->dev,
-				"Nameserver port unavailable.\n");
+				"Attaching the name server port to the "
+				"FCP device failed\n");
 			return ZFCP_ERP_FAILED;
 		}
 		if (!(atomic_read(&ns_port->status) &
@@ -1065,8 +1061,13 @@ static int zfcp_erp_strategy_check_unit(
 		break;
 	case ZFCP_ERP_FAILED :
 		atomic_inc(&unit->erp_counter);
-		if (atomic_read(&unit->erp_counter) > ZFCP_MAX_ERPS)
+		if (atomic_read(&unit->erp_counter) > ZFCP_MAX_ERPS) {
+			dev_err(&unit->port->adapter->ccw_device->dev,
+				"ERP failed for unit 0x%016Lx on "
+				"port 0x%016Lx\n",
+				unit->fcp_lun, unit->port->wwpn);
 			zfcp_erp_unit_failed(unit, 21, NULL);
+		}
 		break;
 	}
 
@@ -1091,8 +1092,12 @@ static int zfcp_erp_strategy_check_port(
 			result = ZFCP_ERP_EXIT;
 		}
 		atomic_inc(&port->erp_counter);
-		if (atomic_read(&port->erp_counter) > ZFCP_MAX_ERPS)
+		if (atomic_read(&port->erp_counter) > ZFCP_MAX_ERPS) {
+			dev_err(&port->adapter->ccw_device->dev,
+				"ERP failed for remote port 0x%016Lx\n",
+				port->wwpn);
 			zfcp_erp_port_failed(port, 22, NULL);
+		}
 		break;
 	}
 
@@ -1114,8 +1119,12 @@ static int zfcp_erp_strategy_check_adapt
 
 	case ZFCP_ERP_FAILED :
 		atomic_inc(&adapter->erp_counter);
-		if (atomic_read(&adapter->erp_counter) > ZFCP_MAX_ERPS)
+		if (atomic_read(&adapter->erp_counter) > ZFCP_MAX_ERPS) {
+			dev_err(&adapter->ccw_device->dev,
+				"ERP cannot recover an error "
+				"on the FCP device\n");
 			zfcp_erp_adapter_failed(adapter, 23, NULL);
+		}
 		break;
 	}
 
@@ -1263,8 +1272,7 @@ static void zfcp_erp_schedule_work(struc
 	p = kzalloc(sizeof(*p), GFP_KERNEL);
 	if (!p) {
 		dev_err(&unit->port->adapter->ccw_device->dev,
-			"Out of resources. Could not register unit "
-			"0x%016Lx on port 0x%016Lx with SCSI stack.\n",
+			"Registering unit 0x%016Lx on port 0x%016Lx failed\n",
 			unit->fcp_lun, unit->port->wwpn);
 		return;
 	}
@@ -1286,8 +1294,8 @@ static void zfcp_erp_rport_register(stru
 	port->rport = fc_remote_port_add(port->adapter->scsi_host, 0, &ids);
 	if (!port->rport) {
 		dev_err(&port->adapter->ccw_device->dev,
-			"Failed registration of rport "
-			"0x%016Lx.\n", port->wwpn);
+			"Registering port 0x%016Lx failed\n",
+			port->wwpn);
 		return;
 	}
 
@@ -1484,7 +1492,7 @@ int zfcp_erp_thread_setup(struct zfcp_ad
 	retval = kernel_thread(zfcp_erp_thread, adapter, SIGCHLD);
 	if (retval < 0) {
 		dev_err(&adapter->ccw_device->dev,
-			"Creation of ERP thread failed.\n");
+			"Creating an ERP thread for the FCP device failed.\n");
 		return retval;
 	}
 	wait_event(adapter->erp_thread_wqh,
@@ -1526,7 +1534,6 @@ void zfcp_erp_adapter_failed(struct zfcp
 {
 	zfcp_erp_modify_adapter_status(adapter, id, ref,
 				       ZFCP_STATUS_COMMON_ERP_FAILED, ZFCP_SET);
-	dev_err(&adapter->ccw_device->dev, "Adapter ERP failed.\n");
 }
 
 /**
@@ -1539,15 +1546,6 @@ void zfcp_erp_port_failed(struct zfcp_po
 {
 	zfcp_erp_modify_port_status(port, id, ref,
 				    ZFCP_STATUS_COMMON_ERP_FAILED, ZFCP_SET);
-
-	if (atomic_read(&port->status) & ZFCP_STATUS_PORT_WKA)
-		dev_err(&port->adapter->ccw_device->dev,
-			"Port ERP failed for WKA port d_id=0x%06x.\n",
-			port->d_id);
-	else
-		dev_err(&port->adapter->ccw_device->dev,
-			"Port ERP failed for port wwpn=0x%016Lx.\n",
-			port->wwpn);
 }
 
 /**
@@ -1560,10 +1558,6 @@ void zfcp_erp_unit_failed(struct zfcp_un
 {
 	zfcp_erp_modify_unit_status(unit, id, ref,
 				    ZFCP_STATUS_COMMON_ERP_FAILED, ZFCP_SET);
-
-	dev_err(&unit->port->adapter->ccw_device->dev,
-		"Unit ERP failed for unit 0x%016Lx on port 0x%016Lx.\n",
-		unit->fcp_lun, unit->port->wwpn);
 }
 
 /**
--- a/drivers/s390/scsi/zfcp_fsf.c	2008-09-19 09:05:16.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_fsf.c	2008-09-19 09:51:59.000000000 +0200
@@ -50,19 +50,16 @@ static u32 fsf_qtcb_type[] = {
 	[FSF_QTCB_UPLOAD_CONTROL_FILE] =  FSF_SUPPORT_COMMAND
 };
 
-static const char *zfcp_act_subtable_type[] = {
-	"unknown", "OS", "WWPN", "DID", "LUN"
-};
-
 static void zfcp_act_eval_err(struct zfcp_adapter *adapter, u32 table)
 {
 	u16 subtable = table >> 16;
 	u16 rule = table & 0xffff;
+	const char *act_type[] = { "unknown", "OS", "WWPN", "DID", "LUN" };
 
-	if (subtable && subtable < ARRAY_SIZE(zfcp_act_subtable_type))
+	if (subtable && subtable < ARRAY_SIZE(act_type))
 		dev_warn(&adapter->ccw_device->dev,
-			 "Access denied in subtable %s, rule %d.\n",
-			 zfcp_act_subtable_type[subtable], rule);
+			 "Access denied according to ACT rule type %s, "
+			 "rule %d\n", act_type[subtable], rule);
 }
 
 static void zfcp_fsf_access_denied_port(struct zfcp_fsf_req *req,
@@ -70,7 +67,7 @@ static void zfcp_fsf_access_denied_port(
 {
 	struct fsf_qtcb_header *header = &req->qtcb->header;
 	dev_warn(&req->adapter->ccw_device->dev,
-		 "Access denied, cannot send command to port 0x%016Lx.\n",
+		 "Access denied to port 0x%016Lx\n",
 		 port->wwpn);
 	zfcp_act_eval_err(req->adapter, header->fsf_status_qual.halfword[0]);
 	zfcp_act_eval_err(req->adapter, header->fsf_status_qual.halfword[1]);
@@ -83,7 +80,7 @@ static void zfcp_fsf_access_denied_unit(
 {
 	struct fsf_qtcb_header *header = &req->qtcb->header;
 	dev_warn(&req->adapter->ccw_device->dev,
-		 "Access denied for unit 0x%016Lx on port 0x%016Lx.\n",
+		 "Access denied to unit 0x%016Lx on port 0x%016Lx\n",
 		 unit->fcp_lun, unit->port->wwpn);
 	zfcp_act_eval_err(req->adapter, header->fsf_status_qual.halfword[0]);
 	zfcp_act_eval_err(req->adapter, header->fsf_status_qual.halfword[1]);
@@ -93,9 +90,8 @@ static void zfcp_fsf_access_denied_unit(
 
 static void zfcp_fsf_class_not_supp(struct zfcp_fsf_req *req)
 {
-	dev_err(&req->adapter->ccw_device->dev,
-		"Required FC class not supported by adapter, "
-		"shutting down adapter.\n");
+	dev_err(&req->adapter->ccw_device->dev, "FCP device not "
+		"operational because of an unsupported FC class\n");
 	zfcp_erp_adapter_shutdown(req->adapter, 0, 123, req);
 	req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 }
@@ -171,42 +167,6 @@ static void zfcp_fsf_status_read_port_cl
 	read_unlock_irqrestore(&zfcp_data.config_lock, flags);
 }
 
-static void zfcp_fsf_bit_error_threshold(struct zfcp_fsf_req *req)
-{
-	struct zfcp_adapter *adapter = req->adapter;
-	struct fsf_status_read_buffer *sr_buf = req->data;
-	struct fsf_bit_error_payload *err = &sr_buf->payload.bit_error;
-
-	dev_warn(&adapter->ccw_device->dev,
-		 "Warning: bit error threshold data "
-		 "received for the adapter: "
-		 "link failures = %i, loss of sync errors = %i, "
-		 "loss of signal errors = %i, "
-		 "primitive sequence errors = %i, "
-		 "invalid transmission word errors = %i, "
-		 "CRC errors = %i).\n",
-		 err->link_failure_error_count,
-		 err->loss_of_sync_error_count,
-		 err->loss_of_signal_error_count,
-		 err->primitive_sequence_error_count,
-		 err->invalid_transmission_word_error_count,
-		 err->crc_error_count);
-	dev_warn(&adapter->ccw_device->dev,
-		 "Additional bit error threshold data of the adapter: "
-		 "primitive sequence event time-outs = %i, "
-		 "elastic buffer overrun errors = %i, "
-		 "advertised receive buffer-to-buffer credit = %i, "
-		 "current receice buffer-to-buffer credit = %i, "
-		 "advertised transmit buffer-to-buffer credit = %i, "
-		 "current transmit buffer-to-buffer credit = %i).\n",
-		 err->primitive_sequence_event_timeout_count,
-		 err->elastic_buffer_overrun_error_count,
-		 err->advertised_receive_b2b_credit,
-		 err->current_receive_b2b_credit,
-		 err->advertised_transmit_b2b_credit,
-		 err->current_transmit_b2b_credit);
-}
-
 static void zfcp_fsf_link_down_info_eval(struct zfcp_fsf_req *req, u8 id,
 					 struct fsf_link_down_info *link_down)
 {
@@ -223,62 +183,66 @@ static void zfcp_fsf_link_down_info_eval
 	switch (link_down->error_code) {
 	case FSF_PSQ_LINK_NO_LIGHT:
 		dev_warn(&req->adapter->ccw_device->dev,
-			 "The local link is down: no light detected.\n");
+			 "There is no light signal from the local "
+			 "fibre channel cable\n");
 		break;
 	case FSF_PSQ_LINK_WRAP_PLUG:
 		dev_warn(&req->adapter->ccw_device->dev,
-			 "The local link is down: wrap plug detected.\n");
+			 "There is a wrap plug instead of a fibre "
+			 "channel cable\n");
 		break;
 	case FSF_PSQ_LINK_NO_FCP:
 		dev_warn(&req->adapter->ccw_device->dev,
-			 "The local link is down: "
-			 "adjacent node on link does not support FCP.\n");
+			 "The adjacent fibre channel node does not "
+			 "support FCP\n");
 		break;
 	case FSF_PSQ_LINK_FIRMWARE_UPDATE:
 		dev_warn(&req->adapter->ccw_device->dev,
-			 "The local link is down: "
-			 "firmware update in progress.\n");
+			 "The FCP device is suspended because of a "
+			 "firmware update\n");
 		break;
 	case FSF_PSQ_LINK_INVALID_WWPN:
 		dev_warn(&req->adapter->ccw_device->dev,
-			 "The local link is down: "
-			 "duplicate or invalid WWPN detected.\n");
+			 "The FCP device detected a WWPN that is "
+			 "duplicate or not valid\n");
 		break;
 	case FSF_PSQ_LINK_NO_NPIV_SUPPORT:
 		dev_warn(&req->adapter->ccw_device->dev,
-			 "The local link is down: "
-			 "no support for NPIV by Fabric.\n");
+			 "The fibre channel fabric does not support NPIV\n");
 		break;
 	case FSF_PSQ_LINK_NO_FCP_RESOURCES:
 		dev_warn(&req->adapter->ccw_device->dev,
-			 "The local link is down: "
-			 "out of resource in FCP daughtercard.\n");
+			 "The FCP adapter cannot support more NPIV ports\n");
 		break;
 	case FSF_PSQ_LINK_NO_FABRIC_RESOURCES:
 		dev_warn(&req->adapter->ccw_device->dev,
-			 "The local link is down: "
-			 "out of resource in Fabric.\n");
+			 "The adjacent switch cannot support "
+			 "more NPIV ports\n");
 		break;
 	case FSF_PSQ_LINK_FABRIC_LOGIN_UNABLE:
 		dev_warn(&req->adapter->ccw_device->dev,
-			 "The local link is down: "
-			 "unable to login to Fabric.\n");
+			 "The FCP adapter could not log in to the "
+			 "fibre channel fabric\n");
 		break;
 	case FSF_PSQ_LINK_WWPN_ASSIGNMENT_CORRUPTED:
 		dev_warn(&req->adapter->ccw_device->dev,
-			 "WWPN assignment file corrupted on adapter.\n");
+			 "The WWPN assignment file on the FCP adapter "
+			 "has been damaged\n");
 		break;
 	case FSF_PSQ_LINK_MODE_TABLE_CURRUPTED:
 		dev_warn(&req->adapter->ccw_device->dev,
-			 "Mode table corrupted on adapter.\n");
+			 "The mode table on the FCP adapter "
+			 "has been damaged\n");
 		break;
 	case FSF_PSQ_LINK_NO_WWPN_ASSIGNMENT:
 		dev_warn(&req->adapter->ccw_device->dev,
-			 "No WWPN for assignment table on adapter.\n");
+			 "All NPIV ports on the FCP adapter have "
+			 "been assigned\n");
 		break;
 	default:
 		dev_warn(&req->adapter->ccw_device->dev,
-			 "The local link to adapter is down.\n");
+			 "The link between the FCP adapter and "
+			 "the FC fabric is down\n");
 	}
 out:
 	zfcp_erp_adapter_failed(adapter, id, req);
@@ -286,27 +250,18 @@ out:
 
 static void zfcp_fsf_status_read_link_down(struct zfcp_fsf_req *req)
 {
-	struct zfcp_adapter *adapter = req->adapter;
 	struct fsf_status_read_buffer *sr_buf = req->data;
 	struct fsf_link_down_info *ldi =
 		(struct fsf_link_down_info *) &sr_buf->payload;
 
 	switch (sr_buf->status_subtype) {
 	case FSF_STATUS_READ_SUB_NO_PHYSICAL_LINK:
-		dev_warn(&adapter->ccw_device->dev,
-			 "Physical link is down.\n");
 		zfcp_fsf_link_down_info_eval(req, 38, ldi);
 		break;
 	case FSF_STATUS_READ_SUB_FDISC_FAILED:
-		dev_warn(&adapter->ccw_device->dev,
-			 "Local link is down "
-			 "due to failed FDISC login.\n");
 		zfcp_fsf_link_down_info_eval(req, 39, ldi);
 		break;
 	case FSF_STATUS_READ_SUB_FIRMWARE_UPDATE:
-		dev_warn(&adapter->ccw_device->dev,
-			 "Local link is down "
-			 "due to firmware update on adapter.\n");
 		zfcp_fsf_link_down_info_eval(req, 40, NULL);
 	};
 }
@@ -335,14 +290,16 @@ static void zfcp_fsf_status_read_handler
 	case FSF_STATUS_READ_SENSE_DATA_AVAIL:
 		break;
 	case FSF_STATUS_READ_BIT_ERROR_THRESHOLD:
-		zfcp_fsf_bit_error_threshold(req);
+		dev_warn(&adapter->ccw_device->dev,
+			 "The error threshold for checksum statistics "
+			 "has been exceeded\n");
 		break;
 	case FSF_STATUS_READ_LINK_DOWN:
 		zfcp_fsf_status_read_link_down(req);
 		break;
 	case FSF_STATUS_READ_LINK_UP:
 		dev_info(&adapter->ccw_device->dev,
-			 "Local link was replugged.\n");
+			 "The local link has been restored\n");
 		/* All ports should be marked as ready to run again */
 		zfcp_erp_modify_adapter_status(adapter, 30, NULL,
 					       ZFCP_STATUS_COMMON_RUNNING,
@@ -386,8 +343,8 @@ static void zfcp_fsf_fsfstatus_qual_eval
 		break;
 	case FSF_SQ_NO_RECOM:
 		dev_err(&req->adapter->ccw_device->dev,
-			"No recommendation could be given for a "
-			"problem on the adapter.\n");
+			"The FCP adapter reported a problem "
+			"that cannot be recovered\n");
 		zfcp_erp_adapter_shutdown(req->adapter, 0, 121, req);
 		break;
 	}
@@ -403,8 +360,7 @@ static void zfcp_fsf_fsfstatus_eval(stru
 	switch (req->qtcb->header.fsf_status) {
 	case FSF_UNKNOWN_COMMAND:
 		dev_err(&req->adapter->ccw_device->dev,
-			"Command issued by the device driver (0x%x) is "
-			"not known by the adapter.\n",
+			"The FCP adapter does not recognize the command 0x%x\n",
 			req->qtcb->header.fsf_command);
 		zfcp_erp_adapter_shutdown(req->adapter, 0, 120, req);
 		req->status |= ZFCP_STATUS_FSFREQ_ERROR;
@@ -435,11 +391,9 @@ static void zfcp_fsf_protstatus_eval(str
 		return;
 	case FSF_PROT_QTCB_VERSION_ERROR:
 		dev_err(&adapter->ccw_device->dev,
-			"The QTCB version requested by zfcp (0x%x) is not "
-			"supported by the FCP adapter (lowest supported "
-			"0x%x, highest supported 0x%x).\n",
-			FSF_QTCB_CURRENT_VERSION, psq->word[0],
-			psq->word[1]);
+			"QTCB version 0x%x not supported by FCP adapter "
+			"(0x%x to 0x%x)\n", FSF_QTCB_CURRENT_VERSION,
+			psq->word[0], psq->word[1]);
 		zfcp_erp_adapter_shutdown(adapter, 0, 117, req);
 		break;
 	case FSF_PROT_ERROR_STATE:
@@ -449,8 +403,7 @@ static void zfcp_fsf_protstatus_eval(str
 		break;
 	case FSF_PROT_UNSUPP_QTCB_TYPE:
 		dev_err(&adapter->ccw_device->dev,
-			"Packet header type used by the device driver is "
-			"incompatible with that used on the adapter.\n");
+			"The QTCB type is not supported by the FCP adapter\n");
 		zfcp_erp_adapter_shutdown(adapter, 0, 118, req);
 		break;
 	case FSF_PROT_HOST_CONNECTION_INITIALIZING:
@@ -459,7 +412,7 @@ static void zfcp_fsf_protstatus_eval(str
 		break;
 	case FSF_PROT_DUPLICATE_REQUEST_ID:
 		dev_err(&adapter->ccw_device->dev,
-			"The request identifier 0x%Lx is ambiguous.\n",
+			"0x%Lx is an ambiguous request identifier\n",
 			(unsigned long long)qtcb->bottom.support.req_handle);
 		zfcp_erp_adapter_shutdown(adapter, 0, 78, req);
 		break;
@@ -479,9 +432,7 @@ static void zfcp_fsf_protstatus_eval(str
 		break;
 	default:
 		dev_err(&adapter->ccw_device->dev,
-			"Transfer protocol status information"
-			"provided by the adapter (0x%x) "
-			"is not compatible with the device driver.\n",
+			"0x%x is not a valid transfer protocol status\n",
 			qtcb->prefix.prot_status);
 		zfcp_erp_adapter_shutdown(adapter, 0, 119, req);
 	}
@@ -559,33 +510,17 @@ static int zfcp_fsf_exchange_config_eval
 		adapter->peer_wwpn = bottom->plogi_payload.wwpn;
 		adapter->peer_wwnn = bottom->plogi_payload.wwnn;
 		fc_host_port_type(shost) = FC_PORTTYPE_PTP;
-		if (req->erp_action)
-			dev_info(&adapter->ccw_device->dev,
-				 "Point-to-Point fibrechannel "
-				 "configuration detected.\n");
 		break;
 	case FSF_TOPO_FABRIC:
 		fc_host_port_type(shost) = FC_PORTTYPE_NPORT;
-		if (req->erp_action)
-			dev_info(&adapter->ccw_device->dev,
-				 "Switched fabric fibrechannel "
-				 "network detected.\n");
 		break;
 	case FSF_TOPO_AL:
 		fc_host_port_type(shost) = FC_PORTTYPE_NLPORT;
-		dev_err(&adapter->ccw_device->dev,
-			"Unsupported arbitrated loop fibrechannel "
-			"topology detected, shutting down "
-			"adapter.\n");
-		zfcp_erp_adapter_shutdown(adapter, 0, 127, req);
-		return -EIO;
 	default:
-		fc_host_port_type(shost) = FC_PORTTYPE_UNKNOWN;
 		dev_err(&adapter->ccw_device->dev,
-			"The fibrechannel topology reported by the"
-			" adapter is not known by the zfcp driver,"
-			" shutting down adapter.\n");
-		zfcp_erp_adapter_shutdown(adapter, 0, 128, req);
+			"Unknown or unsupported arbitrated loop "
+			"fibre channel topology detected\n");
+		zfcp_erp_adapter_shutdown(adapter, 0, 127, req);
 		return -EIO;
 	}
 
@@ -616,11 +551,9 @@ static void zfcp_fsf_exchange_config_dat
 
 		if (bottom->max_qtcb_size < sizeof(struct fsf_qtcb)) {
 			dev_err(&adapter->ccw_device->dev,
-				"Maximum QTCB size (%d bytes) allowed by "
-				"the adapter is lower than the minimum "
-				"required by the driver (%ld bytes).\n",
-				bottom->max_qtcb_size,
-				sizeof(struct fsf_qtcb));
+				"FCP adapter maximum QTCB size (%d bytes) "
+				"is too small\n",
+				bottom->max_qtcb_size);
 			zfcp_erp_adapter_shutdown(adapter, 0, 129, req);
 			return;
 		}
@@ -656,15 +589,15 @@ static void zfcp_fsf_exchange_config_dat
 
 	if (FSF_QTCB_CURRENT_VERSION < bottom->low_qtcb_version) {
 		dev_err(&adapter->ccw_device->dev,
-			"The adapter only supports newer control block "
-			"versions, try updated device driver.\n");
+			"The FCP adapter only supports newer "
+			"control block versions\n");
 		zfcp_erp_adapter_shutdown(adapter, 0, 125, req);
 		return;
 	}
 	if (FSF_QTCB_CURRENT_VERSION > bottom->high_qtcb_version) {
 		dev_err(&adapter->ccw_device->dev,
-			"The adapter only supports older control block "
-			"versions, consider a microcode upgrade.\n");
+			"The FCP adapter only supports older "
+			"control block versions\n");
 		zfcp_erp_adapter_shutdown(adapter, 0, 126, req);
 	}
 }
@@ -1463,9 +1396,8 @@ static void zfcp_fsf_open_port_handler(s
 		break;
 	case FSF_MAXIMUM_NUMBER_OF_PORTS_EXCEEDED:
 		dev_warn(&req->adapter->ccw_device->dev,
-			 "The adapter is out of resources. The remote port "
-			 "0x%016Lx could not be opened, disabling it.\n",
-			 port->wwpn);
+			 "Not enough FCP adapter resources to open "
+			 "remote port 0x%016Lx\n", port->wwpn);
 		zfcp_erp_port_failed(port, 31, req);
 		req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
@@ -1477,8 +1409,8 @@ static void zfcp_fsf_open_port_handler(s
 			break;
 		case FSF_SQ_NO_RETRY_POSSIBLE:
 			dev_warn(&req->adapter->ccw_device->dev,
-				 "The remote port 0x%016Lx could not be "
-				 "opened. Disabling it.\n", port->wwpn);
+				 "Remote port 0x%016Lx could not be opened\n",
+				 port->wwpn);
 			zfcp_erp_port_failed(port, 32, req);
 			req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 			break;
@@ -1784,14 +1716,12 @@ static void zfcp_fsf_open_unit_handler(s
 	case FSF_LUN_SHARING_VIOLATION:
 		if (header->fsf_status_qual.word[0])
 			dev_warn(&adapter->ccw_device->dev,
-				 "FCP-LUN 0x%Lx at the remote port "
-				 "with WWPN 0x%Lx "
-				 "connected to the adapter "
-				 "is already in use in LPAR%d, CSS%d.\n",
+				 "LUN 0x%Lx on port 0x%Lx is already in "
+				 "use by CSS%d, MIF Image ID %x\n",
 				 unit->fcp_lun,
 				 unit->port->wwpn,
-				 queue_designator->hla,
-				 queue_designator->cssid);
+				 queue_designator->cssid,
+				 queue_designator->hla);
 		else
 			zfcp_act_eval_err(adapter,
 					  header->fsf_status_qual.word[2]);
@@ -1802,8 +1732,8 @@ static void zfcp_fsf_open_unit_handler(s
 		break;
 	case FSF_MAXIMUM_NUMBER_OF_LUNS_EXCEEDED:
 		dev_warn(&adapter->ccw_device->dev,
-			 "The adapter ran out of resources. There is no "
-			 "handle available for unit 0x%016Lx on port 0x%016Lx.",
+			 "No handle is available for LUN "
+			 "0x%016Lx on port 0x%016Lx\n",
 			 unit->fcp_lun, unit->port->wwpn);
 		zfcp_erp_unit_failed(unit, 34, req);
 		/* fall through */
@@ -1841,25 +1771,25 @@ static void zfcp_fsf_open_unit_handler(s
                 		atomic_set_mask(ZFCP_STATUS_UNIT_READONLY,
 						&unit->status);
 				dev_info(&adapter->ccw_device->dev,
-					 "Read-only access for unit 0x%016Lx "
-					 "on port 0x%016Lx.\n",
+					 "SCSI device at LUN 0x%016Lx on port "
+					 "0x%016Lx opened read-only\n",
 					 unit->fcp_lun, unit->port->wwpn);
         		}
 
         		if (exclusive && !readwrite) {
 				dev_err(&adapter->ccw_device->dev,
-					"Exclusive access of read-only unit "
-					"0x%016Lx on port 0x%016Lx not "
-					"supported, disabling unit.\n",
+					"Exclusive read-only access not "
+					"supported (unit 0x%016Lx, "
+					"port 0x%016Lx)\n",
 					unit->fcp_lun, unit->port->wwpn);
 				zfcp_erp_unit_failed(unit, 35, req);
 				req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 				zfcp_erp_unit_shutdown(unit, 0, 80, req);
         		} else if (!exclusive && readwrite) {
 				dev_err(&adapter->ccw_device->dev,
-					"Shared access of read-write unit "
-					"0x%016Lx on port 0x%016Lx not "
-					"supported, disabling unit.\n",
+					"Shared read-write access not "
+					"supported (unit 0x%016Lx, port "
+					"0x%016Lx\n)",
 					unit->fcp_lun, unit->port->wwpn);
 				zfcp_erp_unit_failed(unit, 36, req);
 				req->status |= ZFCP_STATUS_FSFREQ_ERROR;
@@ -2166,9 +2096,8 @@ static void zfcp_fsf_send_fcp_command_ha
 		break;
 	case FSF_DIRECTION_INDICATOR_NOT_VALID:
 		dev_err(&req->adapter->ccw_device->dev,
-			"Invalid data direction (%d) given for unit "
-			"0x%016Lx on port 0x%016Lx, shutting down "
-			"adapter.\n",
+			"Incorrect direction %d, unit 0x%016Lx on port "
+			"0x%016Lx closed\n",
 			req->qtcb->bottom.io.data_direction,
 			unit->fcp_lun, unit->port->wwpn);
 		zfcp_erp_adapter_shutdown(unit->port->adapter, 0, 133, req);
@@ -2176,9 +2105,8 @@ static void zfcp_fsf_send_fcp_command_ha
 		break;
 	case FSF_CMND_LENGTH_NOT_VALID:
 		dev_err(&req->adapter->ccw_device->dev,
-			"An invalid control-data-block length field (%d) "
-			"was found in a command for unit 0x%016Lx on port "
-			"0x%016Lx. Shutting down adapter.\n",
+			"Incorrect CDB length %d, unit 0x%016Lx on "
+			"port 0x%016Lx closed\n",
 			req->qtcb->bottom.io.fcp_cmnd_length,
 			unit->fcp_lun, unit->port->wwpn);
 		zfcp_erp_adapter_shutdown(unit->port->adapter, 0, 134, req);
@@ -2306,10 +2234,9 @@ int zfcp_fsf_send_fcp_command_task(struc
 			retval = -EIO;
 		else {
 			dev_err(&adapter->ccw_device->dev,
-				"SCSI request too large. "
-				"Shutting down unit 0x%016Lx on port "
-				"0x%016Lx.\n", unit->fcp_lun,
-				unit->port->wwpn);
+				"Oversize data package, unit 0x%016Lx "
+				"on port 0x%016Lx closed\n",
+				unit->fcp_lun, unit->port->wwpn);
 			zfcp_erp_unit_shutdown(unit, 0, 131, req);
 			retval = -EINVAL;
 		}
--- a/drivers/s390/scsi/zfcp_dbf.c	2008-09-19 08:40:51.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_dbf.c	2008-09-19 09:51:58.000000000 +0200
@@ -570,7 +570,7 @@ static const char *zfcp_rec_dbf_ids[] = 
 	[125]	= "need newer zfcp",
 	[126]	= "need newer microcode",
 	[127]	= "arbitrated loop not supported",
-	[128]	= "unknown topology",
+	[128]	= "",
 	[129]	= "qtcb size mismatch",
 	[130]	= "unknown fsf status ecd",
 	[131]	= "fcp request too big",
--- a/drivers/s390/scsi/zfcp_qdio.c	2008-09-19 09:05:16.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_qdio.c	2008-09-19 09:52:21.000000000 +0200
@@ -57,7 +57,7 @@ void zfcp_qdio_free(struct zfcp_adapter 
 
 static void zfcp_qdio_handler_error(struct zfcp_adapter *adapter, u8 id)
 {
-	dev_warn(&adapter->ccw_device->dev, "QDIO problem occurred.\n");
+	dev_warn(&adapter->ccw_device->dev, "A QDIO problem occurred\n");
 
 	zfcp_erp_adapter_reopen(adapter,
 				ZFCP_STATUS_ADAPTER_LINK_UNPLUGGED |
@@ -174,8 +174,8 @@ static void zfcp_qdio_int_resp(struct cc
 
 		if (unlikely(!(sbale->flags & SBAL_FLAGS_LAST_ENTRY)))
 			dev_warn(&adapter->ccw_device->dev,
-				 "Protocol violation by adapter. "
-				 "Continuing operations.\n");
+				 "A QDIO protocol error occurred, "
+				 "operations continue\n");
 	}
 
 	/*
@@ -457,17 +457,11 @@ int zfcp_qdio_open(struct zfcp_adapter *
 	if (atomic_test_mask(ZFCP_STATUS_ADAPTER_QDIOUP, &adapter->status))
 		return -EIO;
 
-	if (qdio_establish(&adapter->qdio_init_data)) {
-		dev_err(&adapter->ccw_device->dev,
-			 "Establish of QDIO queues failed.\n");
-		return -EIO;
-	}
+	if (qdio_establish(&adapter->qdio_init_data))
+		goto failed_establish;
 
-	if (qdio_activate(adapter->ccw_device)) {
-		dev_err(&adapter->ccw_device->dev,
-			 "Activate of QDIO queues failed.\n");
+	if (qdio_activate(adapter->ccw_device))
 		goto failed_qdio;
-	}
 
 	for (cc = 0; cc < QDIO_MAX_BUFFERS_PER_Q; cc++) {
 		sbale = &(adapter->resp_q.sbal[cc]->element[0]);
@@ -477,11 +471,8 @@ int zfcp_qdio_open(struct zfcp_adapter *
 	}
 
 	if (do_QDIO(adapter->ccw_device, QDIO_FLAG_SYNC_INPUT, 0, 0,
-		     QDIO_MAX_BUFFERS_PER_Q)) {
-		dev_err(&adapter->ccw_device->dev,
-			 "Init of QDIO response queue failed.\n");
+		     QDIO_MAX_BUFFERS_PER_Q))
 		goto failed_qdio;
-	}
 
 	/* set index of first avalable SBALS / number of available SBALS */
 	adapter->req_q.first = 0;
@@ -492,5 +483,8 @@ int zfcp_qdio_open(struct zfcp_adapter *
 
 failed_qdio:
 	qdio_shutdown(adapter->ccw_device, QDIO_FLAG_CLEANUP_USING_CLEAR);
+failed_establish:
+	dev_err(&adapter->ccw_device->dev,
+		"Setting up the QDIO connection to the FCP adapter failed\n");
 	return -EIO;
 }
--- a/drivers/s390/scsi/zfcp_scsi.c	2008-09-19 08:40:51.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_scsi.c	2008-09-19 09:51:59.000000000 +0200
@@ -294,7 +294,8 @@ int zfcp_adapter_scsi_register(struct zf
 					     sizeof (struct zfcp_adapter *));
 	if (!adapter->scsi_host) {
 		dev_err(&adapter->ccw_device->dev,
-			"registration with SCSI stack failed.");
+			"Registering the FCP device with the "
+			"SCSI stack failed\n");
 		return -EIO;
 	}
 

-- 

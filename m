From: Andreas Herrmann <aherrman@de.ibm.com>
Subject: [PATCH] zfcp: remove flags_dump feature
Date: Fri, 10 Jun 2005 10:16:33 +0200
Message-ID: <20050610081633.GA8289@lion28.boeblingen.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate1.de.ibm.com ([195.212.29.150]:13027 "EHLO
	mtagate1.de.ibm.com") by vger.kernel.org with ESMTP id S262512AbVFJIQi
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Jun 2005 04:16:38 -0400
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate1.de.ibm.com (8.12.10/8.12.10) with ESMTP id j5A8GTFu172924
	for <linux-scsi@vger.kernel.org>; Fri, 10 Jun 2005 08:16:30 GMT
Received: from d12av02.megacenter.de.ibm.com (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12nrmr1607.megacenter.de.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j5A8GSH4119262
	for <linux-scsi@vger.kernel.org>; Fri, 10 Jun 2005 10:16:28 +0200
Received: from d12av02.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av02.megacenter.de.ibm.com (8.12.11/8.13.3) with ESMTP id j5A8GRnt027720
	for <linux-scsi@vger.kernel.org>; Fri, 10 Jun 2005 10:16:28 +0200
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@steeleye.com>
Cc: Linux SCSI <linux-scsi@vger.kernel.org>

Hi,

This patch (based on 2.6.12-rc6) removes the rarely used "flags_dump"
mechanism of zfcp.

Equivalent debug information will be provided with a reworking of
zfcp's s390dbf-facilities which is in preparation.

Regards,

Andreas

 
zfcp: get rid of "flags_dump" feature

Signed-off-by: Andreas Herrmann <aherrman@de.ibm.com>

 zfcp_aux.c  |    9 ---
 zfcp_def.h  |   14 ----
 zfcp_fsf.c  |  173 ------------------------------------------------------------
 zfcp_qdio.c |   40 -------------
 4 files changed, 1 insertion(+), 235 deletions(-)

diff -u linux-2.6.x/drivers/s390/scsi/zfcp_aux.c linux-2.6.x/drivers/s390/scsi-new/zfcp_aux.c
--- linux-2.6.x/drivers/s390/scsi/zfcp_aux.c	2005-06-10 09:59:47.000000000 +0200
+++ linux-2.6.x/drivers/s390/scsi-new/zfcp_aux.c	2005-06-10 10:01:24.000000000 +0200
@@ -97,11 +97,6 @@
 		 "FC ERP QDIO CIO Config FSF SCSI Other, "
 		 "levels: 0=none 1=normal 2=devel 3=trace");
 
-#ifdef ZFCP_PRINT_FLAGS
-u32 flags_dump = 0;
-module_param(flags_dump, uint, 0);
-#endif
-
 /****************************************************************/
 /************** Functions without logging ***********************/
 /****************************************************************/
@@ -1483,19 +1478,15 @@
 		fcp_rscn_element++;
 		switch (fcp_rscn_element->addr_format) {
 		case ZFCP_PORT_ADDRESS:
-			ZFCP_LOG_FLAGS(1, "ZFCP_PORT_ADDRESS\n");
 			range_mask = ZFCP_PORTS_RANGE_PORT;
 			break;
 		case ZFCP_AREA_ADDRESS:
-			ZFCP_LOG_FLAGS(1, "ZFCP_AREA_ADDRESS\n");
 			range_mask = ZFCP_PORTS_RANGE_AREA;
 			break;
 		case ZFCP_DOMAIN_ADDRESS:
-			ZFCP_LOG_FLAGS(1, "ZFCP_DOMAIN_ADDRESS\n");
 			range_mask = ZFCP_PORTS_RANGE_DOMAIN;
 			break;
 		case ZFCP_FABRIC_ADDRESS:
-			ZFCP_LOG_FLAGS(1, "ZFCP_FABRIC_ADDRESS\n");
 			range_mask = ZFCP_PORTS_RANGE_FABRIC;
 			break;
 		default:
diff -u linux-2.6.x/drivers/s390/scsi/zfcp_def.h linux-2.6.x/drivers/s390/scsi-new/zfcp_def.h
--- linux-2.6.x/drivers/s390/scsi/zfcp_def.h	2005-06-10 09:59:47.000000000 +0200
+++ linux-2.6.x/drivers/s390/scsi-new/zfcp_def.h	2005-06-10 10:01:24.000000000 +0200
@@ -62,9 +62,6 @@
 #include <linux/syscalls.h>
 #include <linux/ioctl.h>
 
-/************************ DEBUG FLAGS *****************************************/
-
-#define	ZFCP_PRINT_FLAGS
 
 /********************* GENERAL DEFINES *********************************/
 
@@ -472,17 +469,6 @@
 	ZFCP_LOG(ZFCP_LOG_LEVEL_TRACE, fmt , ##args)
 #endif
 
-#ifndef ZFCP_PRINT_FLAGS
-# define ZFCP_LOG_FLAGS(level, fmt, args...)
-#else
-extern u32 flags_dump;
-# define ZFCP_LOG_FLAGS(level, fmt, args...) \
-do { \
-	if (level <= flags_dump) \
-		_ZFCP_LOG(fmt, ##args); \
-} while (0)
-#endif
-
 /*************** ADAPTER/PORT/UNIT AND FSF_REQ STATUS FLAGS ******************/
 
 /* 
diff -u linux-2.6.x/drivers/s390/scsi/zfcp_fsf.c linux-2.6.x/drivers/s390/scsi-new/zfcp_fsf.c
--- linux-2.6.x/drivers/s390/scsi/zfcp_fsf.c	2005-06-10 09:59:47.000000000 +0200
+++ linux-2.6.x/drivers/s390/scsi-new/zfcp_fsf.c	2005-06-10 10:01:24.000000000 +0200
@@ -346,15 +346,10 @@
 	switch (fsf_req->qtcb->prefix.prot_status) {
 
 	case FSF_PROT_GOOD:
-		ZFCP_LOG_TRACE("FSF_PROT_GOOD\n");
-		break;
-
 	case FSF_PROT_FSF_STATUS_PRESENTED:
-		ZFCP_LOG_TRACE("FSF_PROT_FSF_STATUS_PRESENTED\n");
 		break;
 
 	case FSF_PROT_QTCB_VERSION_ERROR:
-		ZFCP_LOG_FLAGS(0, "FSF_PROT_QTCB_VERSION_ERROR\n");
 		ZFCP_LOG_NORMAL("error: The adapter %s contains "
 				"microcode of version 0x%x, the device driver "
 				"only supports 0x%x. Aborting.\n",
@@ -371,7 +366,6 @@
 		break;
 
 	case FSF_PROT_SEQ_NUMB_ERROR:
-		ZFCP_LOG_FLAGS(0, "FSF_PROT_SEQ_NUMB_ERROR\n");
 		ZFCP_LOG_NORMAL("bug: Sequence number mismatch between "
 				"driver (0x%x) and adapter %s (0x%x). "
 				"Restarting all operations on this adapter.\n",
@@ -390,7 +384,6 @@
 		break;
 
 	case FSF_PROT_UNSUPP_QTCB_TYPE:
-		ZFCP_LOG_FLAGS(0, "FSF_PROT_UNSUP_QTCB_TYPE\n");
 		ZFCP_LOG_NORMAL("error: Packet header type used by the "
 				"device driver is incompatible with "
 				"that used on adapter %s. "
@@ -405,7 +398,6 @@
 		break;
 
 	case FSF_PROT_HOST_CONNECTION_INITIALIZING:
-		ZFCP_LOG_FLAGS(1, "FSF_PROT_HOST_CONNECTION_INITIALIZING\n");
 		zfcp_cmd_dbf_event_fsf("hconinit", fsf_req,
 				       &fsf_req->qtcb->prefix.prot_status_qual,
 				       sizeof (union fsf_prot_status_qual));
@@ -416,7 +408,6 @@
 		break;
 
 	case FSF_PROT_DUPLICATE_REQUEST_ID:
-		ZFCP_LOG_FLAGS(0, "FSF_PROT_DUPLICATE_REQUEST_IDS\n");
 		if (fsf_req->qtcb) {
 			ZFCP_LOG_NORMAL("bug: The request identifier 0x%Lx "
 					"to the adapter %s is ambiguous. "
@@ -445,7 +436,6 @@
 		break;
 
 	case FSF_PROT_LINK_DOWN:
-		ZFCP_LOG_FLAGS(1, "FSF_PROT_LINK_DOWN\n");
 		/*
 		 * 'test and set' is not atomic here -
 		 * it's ok as long as calls to our response queue handler
@@ -502,13 +492,11 @@
 					ZFCP_STATUS_COMMON_ERP_FAILED,
 					&adapter->status);
 			zfcp_erp_adapter_reopen(adapter, 0);
-			debug_text_event(adapter->erp_dbf, 1, "prot_link_down");
 		}
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 
 	case FSF_PROT_REEST_QUEUE:
-		ZFCP_LOG_FLAGS(1, "FSF_PROT_REEST_QUEUE\n");
 		debug_text_event(adapter->erp_dbf, 1, "prot_reest_queue");
 		ZFCP_LOG_INFO("The local link to adapter with "
 			      "%s was re-plugged. "
@@ -528,7 +516,6 @@
 		break;
 
 	case FSF_PROT_ERROR_STATE:
-		ZFCP_LOG_FLAGS(0, "FSF_PROT_ERROR_STATE\n");
 		ZFCP_LOG_NORMAL("error: The adapter %s "
 				"has entered the error state. "
 				"Restarting all operations on this "
@@ -589,7 +576,6 @@
 	/* evaluate FSF Status */
 	switch (fsf_req->qtcb->header.fsf_status) {
 	case FSF_UNKNOWN_COMMAND:
-		ZFCP_LOG_FLAGS(0, "FSF_UNKNOWN_COMMAND\n");
 		ZFCP_LOG_NORMAL("bug: Command issued by the device driver is "
 				"not known by the adapter %s "
 				"Stopping all operations on this adapter. "
@@ -606,14 +592,12 @@
 		break;
 
 	case FSF_FCP_RSP_AVAILABLE:
-		ZFCP_LOG_FLAGS(2, "FSF_FCP_RSP_AVAILABLE\n");
 		ZFCP_LOG_DEBUG("FCP Sense data will be presented to the "
 			       "SCSI stack.\n");
 		debug_text_event(fsf_req->adapter->erp_dbf, 3, "fsf_s_rsp");
 		break;
 
 	case FSF_ADAPTER_STATUS_AVAILABLE:
-		ZFCP_LOG_FLAGS(2, "FSF_ADAPTER_STATUS_AVAILABLE\n");
 		debug_text_event(fsf_req->adapter->erp_dbf, 2, "fsf_s_astatus");
 		zfcp_fsf_fsfstatus_qual_eval(fsf_req);
 		break;
@@ -647,11 +631,9 @@
 
 	switch (fsf_req->qtcb->header.fsf_status_qual.word[0]) {
 	case FSF_SQ_FCP_RSP_AVAILABLE:
-		ZFCP_LOG_FLAGS(2, "FSF_SQ_FCP_RSP_AVAILABLE\n");
 		debug_text_event(fsf_req->adapter->erp_dbf, 4, "fsf_sq_rsp");
 		break;
 	case FSF_SQ_RETRY_IF_POSSIBLE:
-		ZFCP_LOG_FLAGS(2, "FSF_SQ_RETRY_IF_POSSIBLE\n");
 		/* The SCSI-stack may now issue retries or escalate */
 		debug_text_event(fsf_req->adapter->erp_dbf, 2, "fsf_sq_retry");
 		zfcp_cmd_dbf_event_fsf("sqretry", fsf_req,
@@ -660,7 +642,6 @@
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 	case FSF_SQ_COMMAND_ABORTED:
-		ZFCP_LOG_FLAGS(2, "FSF_SQ_COMMAND_ABORTED\n");
 		/* Carry the aborted state on to upper layer */
 		debug_text_event(fsf_req->adapter->erp_dbf, 2, "fsf_sq_abort");
 		zfcp_cmd_dbf_event_fsf("sqabort", fsf_req,
@@ -670,7 +651,6 @@
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 	case FSF_SQ_NO_RECOM:
-		ZFCP_LOG_FLAGS(0, "FSF_SQ_NO_RECOM\n");
 		debug_text_exception(fsf_req->adapter->erp_dbf, 0,
 				     "fsf_sq_no_rec");
 		ZFCP_LOG_NORMAL("bug: No recommendation could be given for a"
@@ -684,7 +664,6 @@
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 	case FSF_SQ_ULP_PROGRAMMING_ERROR:
-		ZFCP_LOG_FLAGS(0, "FSF_SQ_ULP_PROGRAMMING_ERROR\n");
 		ZFCP_LOG_NORMAL("error: not enough SBALs for data transfer "
 				"(adapter %s)\n",
 				zfcp_get_busid_by_adapter(fsf_req->adapter));
@@ -740,72 +719,58 @@
 	switch (fsf_req->fsf_command) {
 
 	case FSF_QTCB_FCP_CMND:
-		ZFCP_LOG_FLAGS(3, "FSF_QTCB_FCP_CMND\n");
 		zfcp_fsf_send_fcp_command_handler(fsf_req);
 		break;
 
 	case FSF_QTCB_ABORT_FCP_CMND:
-		ZFCP_LOG_FLAGS(2, "FSF_QTCB_ABORT_FCP_CMND\n");
 		zfcp_fsf_abort_fcp_command_handler(fsf_req);
 		break;
 
 	case FSF_QTCB_SEND_GENERIC:
-		ZFCP_LOG_FLAGS(2, "FSF_QTCB_SEND_GENERIC\n");
 		zfcp_fsf_send_ct_handler(fsf_req);
 		break;
 
 	case FSF_QTCB_OPEN_PORT_WITH_DID:
-		ZFCP_LOG_FLAGS(2, "FSF_QTCB_OPEN_PORT_WITH_DID\n");
 		zfcp_fsf_open_port_handler(fsf_req);
 		break;
 
 	case FSF_QTCB_OPEN_LUN:
-		ZFCP_LOG_FLAGS(2, "FSF_QTCB_OPEN_LUN\n");
 		zfcp_fsf_open_unit_handler(fsf_req);
 		break;
 
 	case FSF_QTCB_CLOSE_LUN:
-		ZFCP_LOG_FLAGS(2, "FSF_QTCB_CLOSE_LUN\n");
 		zfcp_fsf_close_unit_handler(fsf_req);
 		break;
 
 	case FSF_QTCB_CLOSE_PORT:
-		ZFCP_LOG_FLAGS(2, "FSF_QTCB_CLOSE_PORT\n");
 		zfcp_fsf_close_port_handler(fsf_req);
 		break;
 
 	case FSF_QTCB_CLOSE_PHYSICAL_PORT:
-		ZFCP_LOG_FLAGS(2, "FSF_QTCB_CLOSE_PHYSICAL_PORT\n");
 		zfcp_fsf_close_physical_port_handler(fsf_req);
 		break;
 
 	case FSF_QTCB_EXCHANGE_CONFIG_DATA:
-		ZFCP_LOG_FLAGS(2, "FSF_QTCB_EXCHANGE_CONFIG_DATA\n");
 		zfcp_fsf_exchange_config_data_handler(fsf_req);
 		break;
 
 	case FSF_QTCB_EXCHANGE_PORT_DATA:
-		ZFCP_LOG_FLAGS(2, "FSF_QTCB_EXCHANGE_PORT_DATA\n");
 		zfcp_fsf_exchange_port_data_handler(fsf_req);
 		break;
 
 	case FSF_QTCB_SEND_ELS:
-		ZFCP_LOG_FLAGS(2, "FSF_QTCB_SEND_ELS\n");
 		zfcp_fsf_send_els_handler(fsf_req);
 		break;
 
 	case FSF_QTCB_DOWNLOAD_CONTROL_FILE:
-		ZFCP_LOG_FLAGS(2, "FSF_QTCB_DOWNLOAD_CONTROL_FILE\n");
 		zfcp_fsf_control_file_handler(fsf_req);
 		break;
 
 	case FSF_QTCB_UPLOAD_CONTROL_FILE:
-		ZFCP_LOG_FLAGS(2, "FSF_QTCB_UPLOAD_CONTROL_FILE\n");
 		zfcp_fsf_control_file_handler(fsf_req);
 		break;
 
 	default:
-		ZFCP_LOG_FLAGS(2, "FSF_QTCB_UNKNOWN\n");
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		ZFCP_LOG_NORMAL("bug: Command issued by the device driver is "
 				"not supported by the adapter %s\n",
@@ -929,13 +894,11 @@
 	switch (status_buffer->status_subtype) {
 
 	case FSF_STATUS_READ_SUB_CLOSE_PHYS_PORT:
-		ZFCP_LOG_FLAGS(2, "FSF_STATUS_READ_SUB_CLOSE_PHYS_PORT\n");
 		debug_text_event(adapter->erp_dbf, 3, "unsol_pc_phys:");
 		zfcp_erp_port_reopen(port, 0);
 		break;
 
 	case FSF_STATUS_READ_SUB_ERROR_PORT:
-		ZFCP_LOG_FLAGS(1, "FSF_STATUS_READ_SUB_ERROR_PORT\n");
 		debug_text_event(adapter->erp_dbf, 1, "unsol_pc_err:");
 		zfcp_erp_port_shutdown(port, 0);
 		break;
@@ -980,7 +943,6 @@
 	switch (status_buffer->status_type) {
 
 	case FSF_STATUS_READ_PORT_CLOSED:
-		ZFCP_LOG_FLAGS(1, "FSF_STATUS_READ_PORT_CLOSED\n");
 		debug_text_event(adapter->erp_dbf, 3, "unsol_pclosed:");
 		debug_event(adapter->erp_dbf, 3,
 			    &status_buffer->d_id, sizeof (u32));
@@ -988,13 +950,11 @@
 		break;
 
 	case FSF_STATUS_READ_INCOMING_ELS:
-		ZFCP_LOG_FLAGS(1, "FSF_STATUS_READ_INCOMING_ELS\n");
 		debug_text_event(adapter->erp_dbf, 3, "unsol_els:");
 		zfcp_fsf_incoming_els(fsf_req);
 		break;
 
 	case FSF_STATUS_READ_SENSE_DATA_AVAIL:
-		ZFCP_LOG_FLAGS(1, "FSF_STATUS_READ_SENSE_DATA_AVAIL\n");
 		debug_text_event(adapter->erp_dbf, 3, "unsol_sense:");
 		ZFCP_LOG_INFO("unsolicited sense data received (adapter %s)\n",
 			      zfcp_get_busid_by_adapter(adapter));
@@ -1003,7 +963,6 @@
 		break;
 
 	case FSF_STATUS_READ_BIT_ERROR_THRESHOLD:
-		ZFCP_LOG_FLAGS(1, "FSF_STATUS_READ_BIT_ERROR_THRESHOLD\n");
 		debug_text_event(adapter->erp_dbf, 3, "unsol_bit_err:");
 		ZFCP_LOG_NORMAL("Bit error threshold data received:\n");
 		ZFCP_HEX_DUMP(ZFCP_LOG_LEVEL_NORMAL,
@@ -1012,7 +971,6 @@
 		break;
 
 	case FSF_STATUS_READ_LINK_DOWN:
-		ZFCP_LOG_FLAGS(1, "FSF_STATUS_READ_LINK_DOWN\n");
 		debug_text_event(adapter->erp_dbf, 0, "unsol_link_down:");
 		ZFCP_LOG_INFO("Local link to adapter %s is down\n",
 			      zfcp_get_busid_by_adapter(adapter));
@@ -1022,7 +980,6 @@
 		break;
 
 	case FSF_STATUS_READ_LINK_UP:
-		ZFCP_LOG_FLAGS(1, "FSF_STATUS_READ_LINK_UP\n");
 		debug_text_event(adapter->erp_dbf, 2, "unsol_link_up:");
 		ZFCP_LOG_INFO("Local link to adapter %s was replugged. "
 			      "Restarting operations on this adapter\n",
@@ -1037,7 +994,6 @@
 		break;
 
 	case FSF_STATUS_READ_CFDC_UPDATED:
-		ZFCP_LOG_FLAGS(1, "FSF_STATUS_READ_CFDC_UPDATED\n");
 		debug_text_event(adapter->erp_dbf, 2, "unsol_cfdc_update:");
 		ZFCP_LOG_INFO("CFDC has been updated on the adapter %s\n",
 			      zfcp_get_busid_by_adapter(adapter));
@@ -1045,7 +1001,6 @@
 		break;
 
 	case FSF_STATUS_READ_CFDC_HARDENED:
-		ZFCP_LOG_FLAGS(1, "FSF_STATUS_READ_CFDC_HARDENED\n");
 		debug_text_event(adapter->erp_dbf, 2, "unsol_cfdc_harden:");
 		switch (status_buffer->status_subtype) {
 		case FSF_STATUS_READ_SUB_CFDC_HARDENED_ON_SE:
@@ -1214,7 +1169,6 @@
 
 	case FSF_PORT_HANDLE_NOT_VALID:
 		if (status_qual >> 4 != status_qual % 0xf) {
-			ZFCP_LOG_FLAGS(2, "FSF_PORT_HANDLE_NOT_VALID\n");
 			debug_text_event(new_fsf_req->adapter->erp_dbf, 3,
 					 "fsf_s_phand_nv0");
 			/*
@@ -1223,7 +1177,6 @@
 			 * fine.
 			 */
 		} else {
-			ZFCP_LOG_FLAGS(1, "FSF_PORT_HANDLE_NOT_VALID\n");
 			ZFCP_LOG_INFO("Temporary port identifier 0x%x for "
 				      "port 0x%016Lx on adapter %s invalid. "
 				      "This may happen occasionally.\n",
@@ -1246,7 +1199,6 @@
 	case FSF_LUN_HANDLE_NOT_VALID:
 		if (status_qual >> 4 != status_qual % 0xf) {
 			/* 2 */
-			ZFCP_LOG_FLAGS(0, "FSF_LUN_HANDLE_NOT_VALID\n");
 			debug_text_event(new_fsf_req->adapter->erp_dbf, 3,
 					 "fsf_s_lhand_nv0");
 			/*
@@ -1255,7 +1207,6 @@
 			 * This is fine.
 			 */
 		} else {
-			ZFCP_LOG_FLAGS(1, "FSF_LUN_HANDLE_NOT_VALID\n");
 			ZFCP_LOG_INFO
 			    ("Warning: Temporary LUN identifier 0x%x of LUN "
 			     "0x%016Lx on port 0x%016Lx on adapter %s is "
@@ -1279,7 +1230,6 @@
 		break;
 
 	case FSF_FCP_COMMAND_DOES_NOT_EXIST:
-		ZFCP_LOG_FLAGS(2, "FSF_FCP_COMMAND_DOES_NOT_EXIST\n");
 		retval = 0;
 		debug_text_event(new_fsf_req->adapter->erp_dbf, 3,
 				 "fsf_s_no_exist");
@@ -1287,8 +1237,6 @@
 		break;
 
 	case FSF_PORT_BOXED:
-		/* 2 */
-		ZFCP_LOG_FLAGS(0, "FSF_PORT_BOXED\n");
 		ZFCP_LOG_INFO("Remote port 0x%016Lx on adapter %s needs to "
 			      "be reopened\n", unit->port->wwpn,
 			      zfcp_get_busid_by_unit(unit));
@@ -1300,7 +1248,6 @@
 		break;
 
 	case FSF_LUN_BOXED:
-                ZFCP_LOG_FLAGS(0, "FSF_LUN_BOXED\n");
                 ZFCP_LOG_INFO(
                         "unit 0x%016Lx on port 0x%016Lx on adapter %s needs "
                         "to be reopened\n",
@@ -1316,12 +1263,8 @@
                 break;
 
 	case FSF_ADAPTER_STATUS_AVAILABLE:
-		/* 2 */
-		ZFCP_LOG_FLAGS(0, "FSF_ADAPTER_STATUS_AVAILABLE\n");
 		switch (new_fsf_req->qtcb->header.fsf_status_qual.word[0]) {
 		case FSF_SQ_INVOKE_LINK_TEST_PROCEDURE:
-			ZFCP_LOG_FLAGS(2,
-				       "FSF_SQ_INVOKE_LINK_TEST_PROCEDURE\n");
 			debug_text_event(new_fsf_req->adapter->erp_dbf, 1,
 					 "fsf_sq_ltest");
 			/* reopening link to port */
@@ -1329,8 +1272,6 @@
 			new_fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 			break;
 		case FSF_SQ_ULP_DEPENDENT_ERP_REQUIRED:
-			ZFCP_LOG_FLAGS(2,
-				       "FSF_SQ_ULP_DEPENDENT_ERP_REQUIRED\n");
 			/* SCSI stack will escalate */
 			debug_text_event(new_fsf_req->adapter->erp_dbf, 1,
 					 "fsf_sq_ulp");
@@ -1350,8 +1291,6 @@
 		break;
 
 	case FSF_GOOD:
-		/* 3 */
-		ZFCP_LOG_FLAGS(0, "FSF_GOOD\n");
 		retval = 0;
 		new_fsf_req->status |= ZFCP_STATUS_FSFREQ_ABORTSUCCEEDED;
 		break;
@@ -1553,12 +1492,10 @@
 	switch (header->fsf_status) {
 
         case FSF_GOOD:
-                ZFCP_LOG_FLAGS(2,"FSF_GOOD\n");
                 retval = 0;
 		break;
 
         case FSF_SERVICE_CLASS_NOT_SUPPORTED:
-		ZFCP_LOG_FLAGS(2, "FSF_SERVICE_CLASS_NOT_SUPPORTED\n");
 		if (adapter->fc_service_class <= 3) {
 			ZFCP_LOG_INFO("error: adapter %s does not support fc "
 				      "class %d.\n",
@@ -1578,17 +1515,14 @@
 		break;
 
         case FSF_ADAPTER_STATUS_AVAILABLE:
-                ZFCP_LOG_FLAGS(2, "FSF_ADAPTER_STATUS_AVAILABLE\n");
                 switch (header->fsf_status_qual.word[0]){
                 case FSF_SQ_INVOKE_LINK_TEST_PROCEDURE:
-			ZFCP_LOG_FLAGS(2,"FSF_SQ_INVOKE_LINK_TEST_PROCEDURE\n");
 			/* reopening link to port */
 			debug_text_event(adapter->erp_dbf, 1, "fsf_sq_ltest");
 			zfcp_test_link(port);
 			fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 			break;
                 case FSF_SQ_ULP_DEPENDENT_ERP_REQUIRED:
-			ZFCP_LOG_FLAGS(2,"FSF_SQ_ULP_DEPENDENT_ERP_REQUIRED\n");
 			/* ERP strategy will escalate */
 			debug_text_event(adapter->erp_dbf, 1, "fsf_sq_ulp");
 			fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
@@ -1602,7 +1536,6 @@
                 break;
 
 	case FSF_ACCESS_DENIED:
-		ZFCP_LOG_FLAGS(2, "FSF_ACCESS_DENIED\n");
 		ZFCP_LOG_NORMAL("access denied, cannot send generic service "
 				"command (adapter %s, port d_id=0x%08x)\n",
 				zfcp_get_busid_by_port(port), port->d_id);
@@ -1625,7 +1558,6 @@
 		break;
 
         case FSF_GENERIC_COMMAND_REJECTED:
-		ZFCP_LOG_FLAGS(2, "FSF_GENERIC_COMMAND_REJECTED\n");
 		ZFCP_LOG_INFO("generic service command rejected "
 			      "(adapter %s, port d_id=0x%08x)\n",
 			      zfcp_get_busid_by_port(port), port->d_id);
@@ -1638,7 +1570,6 @@
 		break;
 
         case FSF_PORT_HANDLE_NOT_VALID:
-		ZFCP_LOG_FLAGS(2, "FSF_PORT_HANDLE_NOT_VALID\n");
 		ZFCP_LOG_DEBUG("Temporary port identifier 0x%x for port "
 			       "0x%016Lx on adapter %s invalid. This may "
 			       "happen occasionally.\n", port->handle,
@@ -1653,7 +1584,6 @@
 		break;
 
         case FSF_PORT_BOXED:
-		ZFCP_LOG_FLAGS(2, "FSF_PORT_BOXED\n");
 		ZFCP_LOG_INFO("port needs to be reopened "
 			      "(adapter %s, port d_id=0x%08x)\n",
 			      zfcp_get_busid_by_port(port), port->d_id);
@@ -1666,7 +1596,6 @@
 	/* following states should never occure, all cases avoided
 	   in zfcp_fsf_send_ct - but who knows ... */
 	case FSF_PAYLOAD_SIZE_MISMATCH:
-		ZFCP_LOG_FLAGS(2, "FSF_PAYLOAD_SIZE_MISMATCH\n");
 		ZFCP_LOG_INFO("payload size mismatch (adapter: %s, "
 			      "req_buf_length=%d, resp_buf_length=%d)\n",
 			      zfcp_get_busid_by_adapter(adapter),
@@ -1674,7 +1603,6 @@
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 	case FSF_REQUEST_SIZE_TOO_LARGE:
-		ZFCP_LOG_FLAGS(2, "FSF_REQUEST_SIZE_TOO_LARGE\n");
 		ZFCP_LOG_INFO("request size too large (adapter: %s, "
 			      "req_buf_length=%d)\n",
 			      zfcp_get_busid_by_adapter(adapter),
@@ -1682,7 +1610,6 @@
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 	case FSF_RESPONSE_SIZE_TOO_LARGE:
-		ZFCP_LOG_FLAGS(2, "FSF_RESPONSE_SIZE_TOO_LARGE\n");
 		ZFCP_LOG_INFO("response size too large (adapter: %s, "
 			      "resp_buf_length=%d)\n",
 			      zfcp_get_busid_by_adapter(adapter),
@@ -1690,7 +1617,6 @@
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 	case FSF_SBAL_MISMATCH:
-		ZFCP_LOG_FLAGS(2, "FSF_SBAL_MISMATCH\n");
 		ZFCP_LOG_INFO("SBAL mismatch (adapter: %s, req_buf_length=%d, "
 			      "resp_buf_length=%d)\n",
 			      zfcp_get_busid_by_adapter(adapter),
@@ -1866,12 +1792,10 @@
 	switch (header->fsf_status) {
 
 	case FSF_GOOD:
-		ZFCP_LOG_FLAGS(2, "FSF_GOOD\n");
 		retval = 0;
 		break;
 
 	case FSF_SERVICE_CLASS_NOT_SUPPORTED:
-		ZFCP_LOG_FLAGS(2, "FSF_SERVICE_CLASS_NOT_SUPPORTED\n");
 		if (adapter->fc_service_class <= 3) {
 			ZFCP_LOG_INFO("error: adapter %s does "
 				      "not support fibrechannel class %d.\n",
@@ -1891,10 +1815,8 @@
 		break;
 
 	case FSF_ADAPTER_STATUS_AVAILABLE:
-		ZFCP_LOG_FLAGS(2, "FSF_ADAPTER_STATUS_AVAILABLE\n");
 		switch (header->fsf_status_qual.word[0]){
 		case FSF_SQ_INVOKE_LINK_TEST_PROCEDURE:
-			ZFCP_LOG_FLAGS(2,"FSF_SQ_INVOKE_LINK_TEST_PROCEDURE\n");
 			debug_text_event(adapter->erp_dbf, 1, "fsf_sq_ltest");
 			if (send_els->ls_code != ZFCP_LS_ADISC) {
 				read_lock(&zfcp_data.config_lock);
@@ -1906,7 +1828,6 @@
 			fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 			break;
 		case FSF_SQ_ULP_DEPENDENT_ERP_REQUIRED:
-			ZFCP_LOG_FLAGS(2,"FSF_SQ_ULP_DEPENDENT_ERP_REQUIRED\n");
 			debug_text_event(adapter->erp_dbf, 1, "fsf_sq_ulp");
 			fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 			retval =
@@ -1915,7 +1836,6 @@
 					      &header->fsf_status_qual.word[2]);
 			break;
 		case FSF_SQ_RETRY_IF_POSSIBLE:
-			ZFCP_LOG_FLAGS(2, "FSF_SQ_RETRY_IF_POSSIBLE\n");
 			debug_text_event(adapter->erp_dbf, 1, "fsf_sq_retry");
 			fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 			break;
@@ -1928,7 +1848,6 @@
 		break;
 
 	case FSF_ELS_COMMAND_REJECTED:
-		ZFCP_LOG_FLAGS(2, "FSF_ELS_COMMAND_REJECTED\n");
 		ZFCP_LOG_INFO("ELS has been rejected because command filter "
 			      "prohibited sending "
 			      "(adapter: %s, port d_id: 0x%08x)\n",
@@ -1937,7 +1856,6 @@
 		break;
 
 	case FSF_PAYLOAD_SIZE_MISMATCH:
-		ZFCP_LOG_FLAGS(2, "FSF_PAYLOAD_SIZE_MISMATCH\n");
 		ZFCP_LOG_INFO(
 			"ELS request size and ELS response size must be either "
 			"both 0, or both greater than 0 "
@@ -1948,7 +1866,6 @@
 		break;
 
 	case FSF_REQUEST_SIZE_TOO_LARGE:
-		ZFCP_LOG_FLAGS(2, "FSF_REQUEST_SIZE_TOO_LARGE\n");
 		ZFCP_LOG_INFO(
 			"Length of the ELS request buffer, "
 			"specified in QTCB bottom, "
@@ -1960,7 +1877,6 @@
 		break;
 
 	case FSF_RESPONSE_SIZE_TOO_LARGE:
-		ZFCP_LOG_FLAGS(2, "FSF_RESPONSE_SIZE_TOO_LARGE\n");
 		ZFCP_LOG_INFO(
 			"Length of the ELS response buffer, "
 			"specified in QTCB bottom, "
@@ -1973,7 +1889,6 @@
 
 	case FSF_SBAL_MISMATCH:
 		/* should never occure, avoided in zfcp_fsf_send_els */
-		ZFCP_LOG_FLAGS(2, "FSF_SBAL_MISMATCH\n");
 		ZFCP_LOG_INFO("SBAL mismatch (adapter: %s, req_buf_length=%d, "
 			      "resp_buf_length=%d)\n",
 			      zfcp_get_busid_by_adapter(adapter),
@@ -1982,7 +1897,6 @@
 		break;
 
 	case FSF_ACCESS_DENIED:
-		ZFCP_LOG_FLAGS(2, "FSF_ACCESS_DENIED\n");
 		ZFCP_LOG_NORMAL("access denied, cannot send ELS command "
 				"(adapter %s, port d_id=0x%08x)\n",
 				zfcp_get_busid_by_adapter(adapter), d_id);
@@ -2195,14 +2109,11 @@
 	switch (fsf_req->qtcb->header.fsf_status) {
 
 	case FSF_GOOD:
-		ZFCP_LOG_FLAGS(2, "FSF_GOOD\n");
-
 		if (zfcp_fsf_exchange_config_evaluate(fsf_req, 1))
 			return -EIO;
 
 		switch (adapter->fc_topology) {
 		case FSF_TOPO_P2P:
-			ZFCP_LOG_FLAGS(1, "FSF_TOPO_P2P\n");
 			ZFCP_LOG_NORMAL("Point-to-Point fibrechannel "
 					"configuration detected at adapter %s\n"
 					"Peer WWNN 0x%016llx, "
@@ -2216,7 +2127,6 @@
 					 "top-p-to-p");
 			break;
 		case FSF_TOPO_AL:
-			ZFCP_LOG_FLAGS(1, "FSF_TOPO_AL\n");
 			ZFCP_LOG_NORMAL("error: Arbitrated loop fibrechannel "
 					"topology detected at adapter %s "
 					"unsupported, shutting down adapter\n",
@@ -2226,7 +2136,6 @@
 			zfcp_erp_adapter_shutdown(adapter, 0);
 			return -EIO;
 		case FSF_TOPO_FABRIC:
-			ZFCP_LOG_FLAGS(1, "FSF_TOPO_FABRIC\n");
 			ZFCP_LOG_INFO("Switched fabric fibrechannel "
 				      "network detected at adapter %s.\n",
 				      zfcp_get_busid_by_adapter(adapter));
@@ -2379,7 +2288,6 @@
 
 	switch (fsf_req->qtcb->header.fsf_status) {
         case FSF_GOOD:
-                ZFCP_LOG_FLAGS(2,"FSF_GOOD\n");
                 bottom = &fsf_req->qtcb->bottom.port;
                 memcpy(data, bottom, sizeof(*data));
                 break;
@@ -2481,7 +2389,6 @@
 	switch (header->fsf_status) {
 
 	case FSF_PORT_ALREADY_OPEN:
-		ZFCP_LOG_FLAGS(0, "FSF_PORT_ALREADY_OPEN\n");
 		ZFCP_LOG_NORMAL("bug: remote port 0x%016Lx on adapter %s "
 				"is already open.\n",
 				port->wwpn, zfcp_get_busid_by_port(port));
@@ -2494,7 +2401,6 @@
 		break;
 
 	case FSF_ACCESS_DENIED:
-		ZFCP_LOG_FLAGS(2, "FSF_ACCESS_DENIED\n");
 		ZFCP_LOG_NORMAL("Access denied, cannot open port 0x%016Lx "
 				"on adapter %s\n",
 				port->wwpn, zfcp_get_busid_by_port(port));
@@ -2517,7 +2423,6 @@
 		break;
 
 	case FSF_MAXIMUM_NUMBER_OF_PORTS_EXCEEDED:
-		ZFCP_LOG_FLAGS(1, "FSF_MAXIMUM_NUMBER_OF_PORTS_EXCEEDED\n");
 		ZFCP_LOG_INFO("error: The FSF adapter is out of resources. "
 			      "The remote port 0x%016Lx on adapter %s "
 			      "could not be opened. Disabling it.\n",
@@ -2529,11 +2434,8 @@
 		break;
 
 	case FSF_ADAPTER_STATUS_AVAILABLE:
-		ZFCP_LOG_FLAGS(2, "FSF_ADAPTER_STATUS_AVAILABLE\n");
 		switch (header->fsf_status_qual.word[0]) {
 		case FSF_SQ_INVOKE_LINK_TEST_PROCEDURE:
-			ZFCP_LOG_FLAGS(2,
-				       "FSF_SQ_INVOKE_LINK_TEST_PROCEDURE\n");
 			debug_text_event(fsf_req->adapter->erp_dbf, 1,
 					 "fsf_sq_ltest");
 			/* ERP strategy will escalate */
@@ -2546,7 +2448,6 @@
 			fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 			break;
 		case FSF_SQ_NO_RETRY_POSSIBLE:
-			ZFCP_LOG_FLAGS(0, "FSF_SQ_NO_RETRY_POSSIBLE\n");
 			ZFCP_LOG_NORMAL("The remote port 0x%016Lx on "
 					"adapter %s could not be opened. "
 					"Disabling it.\n",
@@ -2572,7 +2473,6 @@
 		break;
 
 	case FSF_GOOD:
-		ZFCP_LOG_FLAGS(3, "FSF_GOOD\n");
 		/* save port handle assigned by FSF */
 		port->handle = header->port_handle;
 		ZFCP_LOG_INFO("The remote port 0x%016Lx via adapter %s "
@@ -2630,7 +2530,6 @@
 
 	case FSF_UNKNOWN_OP_SUBTYPE:
 		/* should never occure, subtype not set in zfcp_fsf_open_port */
-		ZFCP_LOG_FLAGS(2, "FSF_UNKNOWN_OP_SUBTYPE\n");
 		ZFCP_LOG_INFO("unknown operation subtype (adapter: %s, "
 			      "op_subtype=0x%x)\n",
 			      zfcp_get_busid_by_port(port),
@@ -2739,7 +2638,6 @@
 	switch (fsf_req->qtcb->header.fsf_status) {
 
 	case FSF_PORT_HANDLE_NOT_VALID:
-		ZFCP_LOG_FLAGS(1, "FSF_PORT_HANDLE_NOT_VALID\n");
 		ZFCP_LOG_INFO("Temporary port identifier 0x%x for port "
 			      "0x%016Lx on adapter %s invalid. This may happen "
 			      "occasionally.\n", port->handle,
@@ -2755,7 +2653,6 @@
 		break;
 
 	case FSF_ADAPTER_STATUS_AVAILABLE:
-		ZFCP_LOG_FLAGS(2, "FSF_ADAPTER_STATUS_AVAILABLE\n");
 		/* Note: FSF has actually closed the port in this case.
 		 * The status code is just daft. Fingers crossed for a change
 		 */
@@ -2763,7 +2660,6 @@
 		break;
 
 	case FSF_GOOD:
-		ZFCP_LOG_FLAGS(3, "FSF_GOOD\n");
 		ZFCP_LOG_TRACE("remote port 0x016%Lx on adapter %s closed, "
 			       "port handle 0x%x\n", port->wwpn,
 			       zfcp_get_busid_by_port(port), port->handle);
@@ -2884,7 +2780,6 @@
 	switch (header->fsf_status) {
 
 	case FSF_PORT_HANDLE_NOT_VALID:
-		ZFCP_LOG_FLAGS(1, "FSF_PORT_HANDLE_NOT_VALID\n");
 		ZFCP_LOG_INFO("Temporary port identifier 0x%x invalid"
 			      "(adapter %s, port 0x%016Lx). "
 			      "This may happen occasionally.\n",
@@ -2902,7 +2797,6 @@
 		break;
 
 	case FSF_ACCESS_DENIED:
-		ZFCP_LOG_FLAGS(2, "FSF_ACCESS_DENIED\n");
 		ZFCP_LOG_NORMAL("Access denied, cannot close "
 				"physical port 0x%016Lx on adapter %s\n",
 				port->wwpn, zfcp_get_busid_by_port(port));
@@ -2925,7 +2819,6 @@
 		break;
 
 	case FSF_PORT_BOXED:
-		ZFCP_LOG_FLAGS(2, "FSF_PORT_BOXED\n");
 		ZFCP_LOG_DEBUG("The remote port 0x%016Lx on adapter "
 			       "%s needs to be reopened but it was attempted "
 			       "to close it physically.\n",
@@ -2938,19 +2831,14 @@
 		break;
 
 	case FSF_ADAPTER_STATUS_AVAILABLE:
-		ZFCP_LOG_FLAGS(2, "FSF_ADAPTER_STATUS_AVAILABLE\n");
 		switch (header->fsf_status_qual.word[0]) {
 		case FSF_SQ_INVOKE_LINK_TEST_PROCEDURE:
-			ZFCP_LOG_FLAGS(2,
-				       "FSF_SQ_INVOKE_LINK_TEST_PROCEDURE\n");
 			debug_text_event(fsf_req->adapter->erp_dbf, 1,
 					 "fsf_sq_ltest");
 			/* This will now be escalated by ERP */
 			fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 			break;
 		case FSF_SQ_ULP_DEPENDENT_ERP_REQUIRED:
-			ZFCP_LOG_FLAGS(2,
-				       "FSF_SQ_ULP_DEPENDENT_ERP_REQUIRED\n");
 			/* ERP strategy will escalate */
 			debug_text_event(fsf_req->adapter->erp_dbf, 1,
 					 "fsf_sq_ulp");
@@ -2970,7 +2858,6 @@
 		break;
 
 	case FSF_GOOD:
-		ZFCP_LOG_FLAGS(3, "FSF_GOOD\n");
 		ZFCP_LOG_DEBUG("Remote port 0x%016Lx via adapter %s "
 			       "physically closed, port handle 0x%x\n",
 			       port->wwpn,
@@ -3116,7 +3003,6 @@
 	switch (header->fsf_status) {
 
 	case FSF_PORT_HANDLE_NOT_VALID:
-		ZFCP_LOG_FLAGS(1, "FSF_PORT_HANDLE_NOT_VALID\n");
 		ZFCP_LOG_INFO("Temporary port identifier 0x%x "
 			      "for port 0x%016Lx on adapter %s invalid "
 			      "This may happen occasionally\n",
@@ -3132,7 +3018,6 @@
 		break;
 
 	case FSF_LUN_ALREADY_OPEN:
-		ZFCP_LOG_FLAGS(0, "FSF_LUN_ALREADY_OPEN\n");
 		ZFCP_LOG_NORMAL("bug: Attempted to open unit 0x%016Lx on "
 				"remote port 0x%016Lx on adapter %s twice.\n",
 				unit->fcp_lun,
@@ -3143,7 +3028,6 @@
 		break;
 
 	case FSF_ACCESS_DENIED:
-		ZFCP_LOG_FLAGS(2, "FSF_ACCESS_DENIED\n");
 		ZFCP_LOG_NORMAL("Access denied, cannot open unit 0x%016Lx on "
 				"remote port 0x%016Lx on adapter %s\n",
 				unit->fcp_lun, unit->port->wwpn,
@@ -3169,7 +3053,6 @@
 		break;
 
 	case FSF_PORT_BOXED:
-		ZFCP_LOG_FLAGS(2, "FSF_PORT_BOXED\n");
 		ZFCP_LOG_DEBUG("The remote port 0x%016Lx on adapter %s "
 			       "needs to be reopened\n",
 			       unit->port->wwpn, zfcp_get_busid_by_unit(unit));
@@ -3180,7 +3063,6 @@
 		break;
 
 	case FSF_LUN_SHARING_VIOLATION:
-		ZFCP_LOG_FLAGS(2, "FSF_LUN_SHARING_VIOLATION\n");
 		if (header->fsf_status_qual.word[0] != 0) {
 			ZFCP_LOG_NORMAL("FCP-LUN 0x%Lx at the remote port "
 					"with WWPN 0x%Lx "
@@ -3224,7 +3106,6 @@
 		break;
 
 	case FSF_MAXIMUM_NUMBER_OF_LUNS_EXCEEDED:
-		ZFCP_LOG_FLAGS(1, "FSF_MAXIMUM_NUMBER_OF_LUNS_EXCEEDED\n");
 		ZFCP_LOG_INFO("error: The adapter ran out of resources. "
 			      "There is no handle (temporary port identifier) "
 			      "available for unit 0x%016Lx on port 0x%016Lx "
@@ -3239,11 +3120,8 @@
 		break;
 
 	case FSF_ADAPTER_STATUS_AVAILABLE:
-		ZFCP_LOG_FLAGS(2, "FSF_ADAPTER_STATUS_AVAILABLE\n");
 		switch (header->fsf_status_qual.word[0]) {
 		case FSF_SQ_INVOKE_LINK_TEST_PROCEDURE:
-			ZFCP_LOG_FLAGS(2,
-				       "FSF_SQ_INVOKE_LINK_TEST_PROCEDURE\n");
 			/* Re-establish link to port */
 			debug_text_event(adapter->erp_dbf, 1,
 					 "fsf_sq_ltest");
@@ -3251,8 +3129,6 @@
 			fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 			break;
 		case FSF_SQ_ULP_DEPENDENT_ERP_REQUIRED:
-			ZFCP_LOG_FLAGS(2,
-				       "FSF_SQ_ULP_DEPENDENT_ERP_REQUIRED\n");
 			/* ERP strategy will escalate */
 			debug_text_event(adapter->erp_dbf, 1,
 					 "fsf_sq_ulp");
@@ -3271,7 +3147,6 @@
 		break;
 
 	case FSF_INVALID_COMMAND_OPTION:
-		ZFCP_LOG_FLAGS(2, "FSF_INVALID_COMMAND_OPTION\n");
 		ZFCP_LOG_NORMAL(
 			"Invalid option 0x%x has been specified "
 			"in QTCB bottom sent to the adapter %s\n",
@@ -3282,7 +3157,6 @@
 		break;
 
 	case FSF_GOOD:
-		ZFCP_LOG_FLAGS(3, "FSF_GOOD\n");
 		/* save LUN handle assigned by FSF */
 		unit->handle = header->lun_handle;
 		ZFCP_LOG_TRACE("unit 0x%016Lx on remote port 0x%016Lx on "
@@ -3437,7 +3311,6 @@
 	switch (fsf_req->qtcb->header.fsf_status) {
 
 	case FSF_PORT_HANDLE_NOT_VALID:
-		ZFCP_LOG_FLAGS(1, "FSF_PORT_HANDLE_NOT_VALID\n");
 		ZFCP_LOG_INFO("Temporary port identifier 0x%x for port "
 			      "0x%016Lx on adapter %s invalid. This may "
 			      "happen in rare circumstances\n",
@@ -3458,7 +3331,6 @@
 		break;
 
 	case FSF_LUN_HANDLE_NOT_VALID:
-		ZFCP_LOG_FLAGS(1, "FSF_LUN_HANDLE_NOT_VALID\n");
 		ZFCP_LOG_INFO("Temporary LUN identifier 0x%x of unit "
 			      "0x%016Lx on port 0x%016Lx on adapter %s is "
 			      "invalid. This may happen occasionally.\n",
@@ -3480,7 +3352,6 @@
 		break;
 
 	case FSF_PORT_BOXED:
-		ZFCP_LOG_FLAGS(2, "FSF_PORT_BOXED\n");
 		ZFCP_LOG_DEBUG("The remote port 0x%016Lx on adapter %s "
 			       "needs to be reopened\n",
 			       unit->port->wwpn,
@@ -3492,11 +3363,8 @@
 		break;
 
 	case FSF_ADAPTER_STATUS_AVAILABLE:
-		ZFCP_LOG_FLAGS(2, "FSF_ADAPTER_STATUS_AVAILABLE\n");
 		switch (fsf_req->qtcb->header.fsf_status_qual.word[0]) {
 		case FSF_SQ_INVOKE_LINK_TEST_PROCEDURE:
-			ZFCP_LOG_FLAGS(2,
-				       "FSF_SQ_INVOKE_LINK_TEST_PROCEDURE\n");
 			/* re-establish link to port */
 			debug_text_event(fsf_req->adapter->erp_dbf, 1,
 					 "fsf_sq_ltest");
@@ -3504,8 +3372,6 @@
 			fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 			break;
 		case FSF_SQ_ULP_DEPENDENT_ERP_REQUIRED:
-			ZFCP_LOG_FLAGS(2,
-				       "FSF_SQ_ULP_DEPENDENT_ERP_REQUIRED\n");
 			/* ERP strategy will escalate */
 			debug_text_event(fsf_req->adapter->erp_dbf, 1,
 					 "fsf_sq_ulp");
@@ -3526,7 +3392,6 @@
 		break;
 
 	case FSF_GOOD:
-		ZFCP_LOG_FLAGS(3, "FSF_GOOD\n");
 		ZFCP_LOG_TRACE("unit 0x%016Lx on port 0x%016Lx on adapter %s "
 			       "closed, port handle 0x%x\n",
 			       unit->fcp_lun,
@@ -3622,7 +3487,6 @@
 	 */
 	switch (scsi_cmnd->sc_data_direction) {
 	case DMA_NONE:
-		ZFCP_LOG_FLAGS(3, "DMA_NONE\n");
 		fsf_req->qtcb->bottom.io.data_direction = FSF_DATADIR_CMND;
 		/*
 		 * FIXME(qdio):
@@ -3632,19 +3496,16 @@
 		sbtype = SBAL_FLAGS0_TYPE_READ;
 		break;
 	case DMA_FROM_DEVICE:
-		ZFCP_LOG_FLAGS(3, "DMA_FROM_DEVICE\n");
 		fsf_req->qtcb->bottom.io.data_direction = FSF_DATADIR_READ;
 		sbtype = SBAL_FLAGS0_TYPE_READ;
 		fcp_cmnd_iu->rddata = 1;
 		break;
 	case DMA_TO_DEVICE:
-		ZFCP_LOG_FLAGS(3, "DMA_TO_DEVICE\n");
 		fsf_req->qtcb->bottom.io.data_direction = FSF_DATADIR_WRITE;
 		sbtype = SBAL_FLAGS0_TYPE_WRITE;
 		fcp_cmnd_iu->wddata = 1;
 		break;
 	case DMA_BIDIRECTIONAL:
-		ZFCP_LOG_FLAGS(0, "DMA_BIDIRECTIONAL not supported\n");
 	default:
 		/*
 		 * dummy, catch this condition earlier
@@ -3877,7 +3738,6 @@
 	switch (header->fsf_status) {
 
 	case FSF_PORT_HANDLE_NOT_VALID:
-		ZFCP_LOG_FLAGS(1, "FSF_PORT_HANDLE_NOT_VALID\n");
 		ZFCP_LOG_INFO("Temporary port identifier 0x%x for port "
 			      "0x%016Lx on adapter %s invalid\n",
 			      unit->port->handle,
@@ -3892,7 +3752,6 @@
 		break;
 
 	case FSF_LUN_HANDLE_NOT_VALID:
-		ZFCP_LOG_FLAGS(1, "FSF_LUN_HANDLE_NOT_VALID\n");
 		ZFCP_LOG_INFO("Temporary LUN identifier 0x%x for unit "
 			      "0x%016Lx on port 0x%016Lx on adapter %s is "
 			      "invalid. This may happen occasionally.\n",
@@ -3911,7 +3770,6 @@
 		break;
 
 	case FSF_HANDLE_MISMATCH:
-		ZFCP_LOG_FLAGS(0, "FSF_HANDLE_MISMATCH\n");
 		ZFCP_LOG_NORMAL("bug: The port handle 0x%x has changed "
 				"unexpectedly. (adapter %s, port 0x%016Lx, "
 				"unit 0x%016Lx)\n",
@@ -3934,7 +3792,6 @@
 		break;
 
 	case FSF_SERVICE_CLASS_NOT_SUPPORTED:
-		ZFCP_LOG_FLAGS(0, "FSF_SERVICE_CLASS_NOT_SUPPORTED\n");
 		if (fsf_req->adapter->fc_service_class <= 3) {
 			ZFCP_LOG_NORMAL("error: The adapter %s does "
 					"not support fibrechannel class %d.\n",
@@ -3959,7 +3816,6 @@
 		break;
 
 	case FSF_FCPLUN_NOT_VALID:
-		ZFCP_LOG_FLAGS(0, "FSF_FCPLUN_NOT_VALID\n");
 		ZFCP_LOG_NORMAL("bug: unit 0x%016Lx on port 0x%016Lx on "
 				"adapter %s does not have correct unit "
 				"handle 0x%x\n",
@@ -3982,7 +3838,6 @@
 		break;
 
 	case FSF_ACCESS_DENIED:
-		ZFCP_LOG_FLAGS(2, "FSF_ACCESS_DENIED\n");
 		ZFCP_LOG_NORMAL("Access denied, cannot send FCP command to "
 				"unit 0x%016Lx on port 0x%016Lx on "
 				"adapter %s\n",	unit->fcp_lun, unit->port->wwpn,
@@ -4006,7 +3861,6 @@
 		break;
 
 	case FSF_DIRECTION_INDICATOR_NOT_VALID:
-		ZFCP_LOG_FLAGS(0, "FSF_DIRECTION_INDICATOR_NOT_VALID\n");
 		ZFCP_LOG_INFO("bug: Invalid data direction given for unit "
 			      "0x%016Lx on port 0x%016Lx on adapter %s "
 			      "(debug info %d)\n",
@@ -4026,7 +3880,6 @@
 		break;
 
 	case FSF_CMND_LENGTH_NOT_VALID:
-		ZFCP_LOG_FLAGS(0, "FSF_CMND_LENGTH_NOT_VALID\n");
 		ZFCP_LOG_NORMAL
 		    ("bug: An invalid control-data-block length field "
 		     "was found in a command for unit 0x%016Lx on port "
@@ -4046,7 +3899,6 @@
 		break;
 
 	case FSF_PORT_BOXED:
-		ZFCP_LOG_FLAGS(2, "FSF_PORT_BOXED\n");
 		ZFCP_LOG_DEBUG("The remote port 0x%016Lx on adapter %s "
 			       "needs to be reopened\n",
 			       unit->port->wwpn, zfcp_get_busid_by_unit(unit));
@@ -4060,7 +3912,6 @@
 		break;
 
 	case FSF_LUN_BOXED:
-		ZFCP_LOG_FLAGS(0, "FSF_LUN_BOXED\n");
 		ZFCP_LOG_NORMAL("unit needs to be reopened (adapter %s, "
 				"wwpn=0x%016Lx, fcp_lun=0x%016Lx)\n",
 				zfcp_get_busid_by_unit(unit),
@@ -4075,11 +3926,8 @@
 		break;
 
 	case FSF_ADAPTER_STATUS_AVAILABLE:
-		ZFCP_LOG_FLAGS(2, "FSF_ADAPTER_STATUS_AVAILABLE\n");
 		switch (header->fsf_status_qual.word[0]) {
 		case FSF_SQ_INVOKE_LINK_TEST_PROCEDURE:
-			ZFCP_LOG_FLAGS(2,
-				       "FSF_SQ_INVOKE_LINK_TEST_PROCEDURE\n");
 			/* re-establish link to port */
 			debug_text_event(fsf_req->adapter->erp_dbf, 1,
 					 "fsf_sq_ltest");
@@ -4092,8 +3940,6 @@
 			fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 			break;
 		case FSF_SQ_ULP_DEPENDENT_ERP_REQUIRED:
-			ZFCP_LOG_FLAGS(3,
-				       "FSF_SQ_ULP_DEPENDENT_ERP_REQUIRED\n");
 			/* FIXME(hw) need proper specs for proper action */
 			/* let scsi stack deal with retries and escalation */
 			debug_text_event(fsf_req->adapter->erp_dbf, 1,
@@ -4120,11 +3966,9 @@
 		break;
 
 	case FSF_GOOD:
-		ZFCP_LOG_FLAGS(3, "FSF_GOOD\n");
 		break;
 
 	case FSF_FCP_RSP_AVAILABLE:
-		ZFCP_LOG_FLAGS(2, "FSF_FCP_RSP_AVAILABLE\n");
 		break;
 
 	default:
@@ -4217,14 +4061,12 @@
 		ZFCP_LOG_DEBUG("rsp_len is valid\n");
 		switch (fcp_rsp_info[3]) {
 		case RSP_CODE_GOOD:
-			ZFCP_LOG_FLAGS(3, "RSP_CODE_GOOD\n");
 			/* ok, continue */
 			ZFCP_LOG_TRACE("no failure or Task Management "
 				       "Function complete\n");
 			set_host_byte(&scpnt->result, DID_OK);
 			break;
 		case RSP_CODE_LENGTH_MISMATCH:
-			ZFCP_LOG_FLAGS(0, "RSP_CODE_LENGTH_MISMATCH\n");
 			/* hardware bug */
 			ZFCP_LOG_NORMAL("bug: FCP response code indictates "
 					"that the fibrechannel protocol data "
@@ -4242,7 +4084,6 @@
 			set_host_byte(&scpnt->result, DID_ERROR);
 			goto skip_fsfstatus;
 		case RSP_CODE_FIELD_INVALID:
-			ZFCP_LOG_FLAGS(0, "RSP_CODE_FIELD_INVALID\n");
 			/* driver or hardware bug */
 			ZFCP_LOG_NORMAL("bug: FCP response code indictates "
 					"that the fibrechannel protocol data "
@@ -4261,7 +4102,6 @@
 			zfcp_cmd_dbf_event_fsf("codeinv", fsf_req, NULL, 0);
 			goto skip_fsfstatus;
 		case RSP_CODE_RO_MISMATCH:
-			ZFCP_LOG_FLAGS(0, "RSP_CODE_RO_MISMATCH\n");
 			/* hardware bug */
 			ZFCP_LOG_NORMAL("bug: The FCP response code indicates "
 					"that conflicting  values for the "
@@ -4407,13 +4247,11 @@
 	/* check FCP_RSP_INFO */
 	switch (fcp_rsp_info[3]) {
 	case RSP_CODE_GOOD:
-		ZFCP_LOG_FLAGS(3, "RSP_CODE_GOOD\n");
 		/* ok, continue */
 		ZFCP_LOG_DEBUG("no failure or Task Management "
 			       "Function complete\n");
 		break;
 	case RSP_CODE_TASKMAN_UNSUPP:
-		ZFCP_LOG_FLAGS(0, "RSP_CODE_TASKMAN_UNSUPP\n");
 		ZFCP_LOG_NORMAL("bug: A reuested task management function "
 				"is not supported on the target device "
 				"unit 0x%016Lx, port 0x%016Lx, adapter %s\n ",
@@ -4423,7 +4261,6 @@
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_TMFUNCNOTSUPP;
 		break;
 	case RSP_CODE_TASKMAN_FAILED:
-		ZFCP_LOG_FLAGS(0, "RSP_CODE_TASKMAN_FAILED\n");
 		ZFCP_LOG_NORMAL("bug: A reuested task management function "
 				"failed to complete successfully. "
 				"unit 0x%016Lx, port 0x%016Lx, adapter %s.\n",
@@ -4610,7 +4447,6 @@
 	switch (header->fsf_status) {
 
 	case FSF_GOOD:
-		ZFCP_LOG_FLAGS(2, "FSF_GOOD\n");
 		ZFCP_LOG_NORMAL(
 			"The FSF request has been successfully completed "
 			"on the adapter %s\n",
@@ -4618,7 +4454,6 @@
 		break;
 
 	case FSF_OPERATION_PARTIALLY_SUCCESSFUL:
-		ZFCP_LOG_FLAGS(2, "FSF_OPERATION_PARTIALLY_SUCCESSFUL\n");
 		if (bottom->operation_subtype == FSF_CFDC_OPERATION_SUBTYPE) {
 			switch (header->fsf_status_qual.word[0]) {
 
@@ -4655,7 +4490,6 @@
 		break;
 
 	case FSF_AUTHORIZATION_FAILURE:
-		ZFCP_LOG_FLAGS(2, "FSF_AUTHORIZATION_FAILURE\n");
 		ZFCP_LOG_NORMAL(
 			"Adapter %s does not accept privileged commands\n",
 			zfcp_get_busid_by_adapter(adapter));
@@ -4664,7 +4498,6 @@
 		break;
 
 	case FSF_CFDC_ERROR_DETECTED:
-		ZFCP_LOG_FLAGS(2, "FSF_CFDC_ERROR_DETECTED\n");
 		ZFCP_LOG_NORMAL(
 			"Error at position %d in the CFDC, "
 			"CFDC is discarded by the adapter %s\n",
@@ -4675,7 +4508,6 @@
 		break;
 
 	case FSF_CONTROL_FILE_UPDATE_ERROR:
-		ZFCP_LOG_FLAGS(2, "FSF_CONTROL_FILE_UPDATE_ERROR\n");
 		ZFCP_LOG_NORMAL(
 			"Adapter %s cannot harden the control file, "
 			"file is discarded\n",
@@ -4685,7 +4517,6 @@
 		break;
 
 	case FSF_CONTROL_FILE_TOO_LARGE:
-		ZFCP_LOG_FLAGS(2, "FSF_CONTROL_FILE_TOO_LARGE\n");
 		ZFCP_LOG_NORMAL(
 			"Control file is too large, file is discarded "
 			"by the adapter %s\n",
@@ -4695,7 +4526,6 @@
 		break;
 
 	case FSF_ACCESS_CONFLICT_DETECTED:
-		ZFCP_LOG_FLAGS(2, "FSF_ACCESS_CONFLICT_DETECTED\n");
 		if (bottom->operation_subtype == FSF_CFDC_OPERATION_SUBTYPE)
 			ZFCP_LOG_NORMAL(
 				"CFDC has been discarded by the adapter %s, "
@@ -4708,7 +4538,6 @@
 		break;
 
 	case FSF_CONFLICTS_OVERRULED:
-		ZFCP_LOG_FLAGS(2, "FSF_CONFLICTS_OVERRULED\n");
 		if (bottom->operation_subtype == FSF_CFDC_OPERATION_SUBTYPE)
 			ZFCP_LOG_NORMAL(
 				"CFDC has been activated on the adapter %s, "
@@ -4721,7 +4550,6 @@
 		break;
 
 	case FSF_UNKNOWN_OP_SUBTYPE:
-		ZFCP_LOG_FLAGS(2, "FSF_UNKNOWN_OP_SUBTYPE\n");
 		ZFCP_LOG_NORMAL("unknown operation subtype (adapter: %s, "
 				"op_subtype=0x%x)\n",
 				zfcp_get_busid_by_adapter(adapter),
@@ -4731,7 +4559,6 @@
 		break;
 
 	case FSF_INVALID_COMMAND_OPTION:
-		ZFCP_LOG_FLAGS(2, "FSF_INVALID_COMMAND_OPTION\n");
 		ZFCP_LOG_NORMAL(
 			"Invalid option 0x%x has been specified "
 			"in QTCB bottom sent to the adapter %s\n",
diff -u linux-2.6.x/drivers/s390/scsi/zfcp_qdio.c linux-2.6.x/drivers/s390/scsi-new/zfcp_qdio.c
--- linux-2.6.x/drivers/s390/scsi/zfcp_qdio.c	2005-03-02 08:37:48.000000000 +0100
+++ linux-2.6.x/drivers/s390/scsi-new/zfcp_qdio.c	2005-06-10 10:01:24.000000000 +0200
@@ -229,52 +229,14 @@
 			ZFCP_LOG_TRACE("status is"
 				       " QDIO_STATUS_OUTBOUND_INT \n");
 		}
-	}			// if (ZFCP_LOG_CHECK(ZFCP_LOG_LEVEL_TRACE))
+	}
 	if (unlikely(status & QDIO_STATUS_LOOK_FOR_ERROR)) {
 		retval = -EIO;
 
-		ZFCP_LOG_FLAGS(1, "QDIO_STATUS_LOOK_FOR_ERROR \n");
-
 		ZFCP_LOG_INFO("QDIO problem occurred (status=0x%x, "
 			      "qdio_error=0x%x, siga_error=0x%x)\n",
 			      status, qdio_error, siga_error);
 
-		if (status & QDIO_STATUS_ACTIVATE_CHECK_CONDITION) {
-			ZFCP_LOG_FLAGS(2,
-				       "QDIO_STATUS_ACTIVATE_CHECK_CONDITION\n");
-		}
-		if (status & QDIO_STATUS_MORE_THAN_ONE_QDIO_ERROR) {
-			ZFCP_LOG_FLAGS(2,
-				       "QDIO_STATUS_MORE_THAN_ONE_QDIO_ERROR\n");
-		}
-		if (status & QDIO_STATUS_MORE_THAN_ONE_SIGA_ERROR) {
-			ZFCP_LOG_FLAGS(2,
-				       "QDIO_STATUS_MORE_THAN_ONE_SIGA_ERROR\n");
-		}
-
-		if (siga_error & QDIO_SIGA_ERROR_ACCESS_EXCEPTION) {
-			ZFCP_LOG_FLAGS(2, "QDIO_SIGA_ERROR_ACCESS_EXCEPTION\n");
-		}
-
-		if (siga_error & QDIO_SIGA_ERROR_B_BIT_SET) {
-			ZFCP_LOG_FLAGS(2, "QDIO_SIGA_ERROR_B_BIT_SET\n");
-		}
-
-		switch (qdio_error) {
-		case 0:
-			ZFCP_LOG_FLAGS(3, "QDIO_OK");
-			break;
-		case SLSB_P_INPUT_ERROR:
-			ZFCP_LOG_FLAGS(1, "SLSB_P_INPUT_ERROR\n");
-			break;
-		case SLSB_P_OUTPUT_ERROR:
-			ZFCP_LOG_FLAGS(1, "SLSB_P_OUTPUT_ERROR\n");
-			break;
-		default:
-			ZFCP_LOG_NORMAL("bug: unknown QDIO error 0x%x\n",
-					qdio_error);
-			break;
-		}
 		/* Restarting IO on the failed adapter from scratch */
 		debug_text_event(adapter->erp_dbf, 1, "qdio_err");
                /*


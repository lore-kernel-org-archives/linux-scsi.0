From: Swen Schillig <swen@vnet.ibm.com>
Subject: [PATCH 0/5] zfcp: print S_ID and D_ID with 3 bytes
Date: Tue, 8 May 2007 11:14:41 +0200
Message-ID: <200705081114.41970.swen@vnet.ibm.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate3.de.ibm.com ([195.212.29.152]:43108 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965744AbXEHJMN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 May 2007 05:12:13 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org

From: Christof Schmitt <christof.schmitt@de.ibm.com>

S_ID and D_ID are defined in the FCP spec as 3 byte fields.
Change the output in zfcp print statements accordingly to print
them with only 3 bytes.

Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
Signed-off-by: Swen Schillig <swen@vnet.ibm.com>
---

 drivers/s390/scsi/zfcp_aux.c |    6 +++---
 drivers/s390/scsi/zfcp_erp.c |   20 ++++++++++----------
 drivers/s390/scsi/zfcp_fsf.c |   30 +++++++++++++++---------------
 3 files changed, 28 insertions(+), 28 deletions(-)

--- linux-2.6.orig/drivers/s390/scsi/zfcp_aux.c	2007-04-26 14:53:13.000000000 +0200
+++ linux-2.6/drivers/s390/scsi/zfcp_aux.c	2007-05-07 13:29:48.000000000 +0200
@@ -1497,7 +1497,7 @@

 	if (!port || (port->wwpn != (*(wwn_t *) &els_plogi->serv_param.wwpn))) {
 		ZFCP_LOG_DEBUG("ignored incoming PLOGI for nonexisting port "
-			       "with d_id 0x%08x on adapter %s\n",
+			       "with d_id 0x%06x on adapter %s\n",
 			       status_buffer->d_id,
 			       zfcp_get_busid_by_adapter(adapter));
 	} else {
@@ -1522,7 +1522,7 @@

 	if (!port || (port->wwpn != els_logo->nport_wwpn)) {
 		ZFCP_LOG_DEBUG("ignored incoming LOGO for nonexisting port "
-			       "with d_id 0x%08x on adapter %s\n",
+			       "with d_id 0x%06x on adapter %s\n",
 			       status_buffer->d_id,
 			       zfcp_get_busid_by_adapter(adapter));
 	} else {
@@ -1704,7 +1704,7 @@
 	/* looks like a valid d_id */
         port->d_id = ct_iu_resp->d_id & ZFCP_DID_MASK;
 	atomic_set_mask(ZFCP_STATUS_PORT_DID_DID, &port->status);
-	ZFCP_LOG_DEBUG("adapter %s:  wwpn=0x%016Lx ---> d_id=0x%08x\n",
+	ZFCP_LOG_DEBUG("adapter %s:  wwpn=0x%016Lx ---> d_id=0x%06x\n",
 		       zfcp_get_busid_by_port(port), port->wwpn, port->d_id);
 	goto out;

--- linux-2.6.orig/drivers/s390/scsi/zfcp_erp.c	2007-05-07 12:37:01.000000000 +0200
+++ linux-2.6/drivers/s390/scsi/zfcp_erp.c	2007-05-07 13:29:48.000000000 +0200
@@ -342,9 +342,9 @@
 	adisc->wwpn = fc_host_port_name(adapter->scsi_host);
 	adisc->wwnn = fc_host_node_name(adapter->scsi_host);
 	adisc->nport_id = fc_host_port_id(adapter->scsi_host);
-	ZFCP_LOG_INFO("ADISC request from s_id 0x%08x to d_id 0x%08x "
+	ZFCP_LOG_INFO("ADISC request from s_id 0x%06x to d_id 0x%06x "
 		      "(wwpn=0x%016Lx, wwnn=0x%016Lx, "
-		      "hard_nport_id=0x%08x, nport_id=0x%08x)\n",
+		      "hard_nport_id=0x%06x, nport_id=0x%06x)\n",
 		      adisc->nport_id, send_els->d_id, (wwn_t) adisc->wwpn,
 		      (wwn_t) adisc->wwnn, adisc->hard_nport_id,
 		      adisc->nport_id);
@@ -352,7 +352,7 @@
 	retval = zfcp_fsf_send_els(send_els);
 	if (retval != 0) {
 		ZFCP_LOG_NORMAL("error: initiation of Send ELS failed for port "
-				"0x%08x on adapter %s\n", send_els->d_id,
+				"0x%06x on adapter %s\n", send_els->d_id,
 				zfcp_get_busid_by_adapter(adapter));
 		goto freemem;
 	}
@@ -398,7 +398,7 @@
 	if (send_els->status != 0) {
 		ZFCP_LOG_NORMAL("ELS request rejected/timed out, "
 				"force physical port reopen "
-				"(adapter %s, port d_id=0x%08x)\n",
+				"(adapter %s, port d_id=0x%06x)\n",
 				zfcp_get_busid_by_adapter(adapter), d_id);
 		debug_text_event(adapter->erp_dbf, 3, "forcreop");
 		if (zfcp_erp_port_forced_reopen(port, 0))
@@ -411,9 +411,9 @@

 	adisc = zfcp_sg_to_address(send_els->resp);

-	ZFCP_LOG_INFO("ADISC response from d_id 0x%08x to s_id "
-		      "0x%08x (wwpn=0x%016Lx, wwnn=0x%016Lx, "
-		      "hard_nport_id=0x%08x, nport_id=0x%08x)\n",
+	ZFCP_LOG_INFO("ADISC response from d_id 0x%06x to s_id "
+		      "0x%06x (wwpn=0x%016Lx, wwnn=0x%016Lx, "
+		      "hard_nport_id=0x%06x, nport_id=0x%06x)\n",
 		      d_id, fc_host_port_id(adapter->scsi_host),
 		      (wwn_t) adisc->wwpn, (wwn_t) adisc->wwnn,
 		      adisc->hard_nport_id, adisc->nport_id);
@@ -1377,7 +1377,7 @@

 	if (atomic_test_mask(ZFCP_STATUS_PORT_WKA, &port->status))
 		ZFCP_LOG_NORMAL("port erp failed (adapter %s, "
-				"port d_id=0x%08x)\n",
+				"port d_id=0x%06x)\n",
 				zfcp_get_busid_by_port(port), port->d_id);
 	else
 		ZFCP_LOG_NORMAL("port erp failed (adapter %s, wwpn=0x%016Lx)\n",
@@ -2401,7 +2401,7 @@
 				retval = ZFCP_ERP_FAILED;
 			}
 		} else {
-			ZFCP_LOG_DEBUG("port 0x%016Lx has d_id=0x%08x -> "
+			ZFCP_LOG_DEBUG("port 0x%016Lx has d_id=0x%06x -> "
 				       "trying open\n", port->wwpn, port->d_id);
 			retval = zfcp_erp_port_strategy_open_port(erp_action);
 		}
@@ -2441,7 +2441,7 @@
 	case ZFCP_ERP_STEP_UNINITIALIZED:
 	case ZFCP_ERP_STEP_PHYS_PORT_CLOSING:
 	case ZFCP_ERP_STEP_PORT_CLOSING:
-		ZFCP_LOG_DEBUG("port 0x%016Lx has d_id=0x%08x -> trying open\n",
+		ZFCP_LOG_DEBUG("port 0x%016Lx has d_id=0x%06x -> trying open\n",
 			       port->wwpn, port->d_id);
 		retval = zfcp_erp_port_strategy_open_port(erp_action);
 		break;
--- linux-2.6.orig/drivers/s390/scsi/zfcp_fsf.c	2007-05-07 12:37:01.000000000 +0200
+++ linux-2.6/drivers/s390/scsi/zfcp_fsf.c	2007-05-07 13:29:48.000000000 +0200
@@ -828,7 +828,7 @@

 	if (!port || (port->d_id != (status_buffer->d_id & ZFCP_DID_MASK))) {
 		ZFCP_LOG_NORMAL("bug: Reopen port indication received for"
-				"nonexisting port with d_id 0x%08x on "
+				"nonexisting port with d_id 0x%06x on "
 				"adapter %s. Ignored.\n",
 				status_buffer->d_id & ZFCP_DID_MASK,
 				zfcp_get_busid_by_adapter(adapter));
@@ -853,7 +853,7 @@
 				&status_buffer->status_subtype, sizeof (u32));
 		ZFCP_LOG_NORMAL("bug: Undefined status subtype received "
 				"for a reopen indication on port with "
-				"d_id 0x%08x on the adapter %s. "
+				"d_id 0x%06x on the adapter %s. "
 				"Ignored. (debug info 0x%x)\n",
 				status_buffer->d_id,
 				zfcp_get_busid_by_adapter(adapter),
@@ -1156,7 +1156,7 @@
 	}

 	ZFCP_LOG_DEBUG("Abort FCP Command request initiated "
-		       "(adapter%s, port d_id=0x%08x, "
+		       "(adapter%s, port d_id=0x%06x, "
 		       "unit x%016Lx, old_req_id=0x%lx)\n",
 		       zfcp_get_busid_by_adapter(adapter),
 		       unit->port->d_id,
@@ -1554,7 +1554,7 @@

 	case FSF_ACCESS_DENIED:
 		ZFCP_LOG_NORMAL("access denied, cannot send generic service "
-				"command (adapter %s, port d_id=0x%08x)\n",
+				"command (adapter %s, port d_id=0x%06x)\n",
 				zfcp_get_busid_by_port(port), port->d_id);
 		for (counter = 0; counter < 2; counter++) {
 			subtable = header->fsf_status_qual.halfword[counter * 2];
@@ -1576,7 +1576,7 @@

         case FSF_GENERIC_COMMAND_REJECTED:
 		ZFCP_LOG_INFO("generic service command rejected "
-			      "(adapter %s, port d_id=0x%08x)\n",
+			      "(adapter %s, port d_id=0x%06x)\n",
 			      zfcp_get_busid_by_port(port), port->d_id);
 		ZFCP_LOG_INFO("status qualifier:\n");
 		ZFCP_HEX_DUMP(ZFCP_LOG_LEVEL_INFO,
@@ -1602,7 +1602,7 @@

         case FSF_PORT_BOXED:
 		ZFCP_LOG_INFO("port needs to be reopened "
-			      "(adapter %s, port d_id=0x%08x)\n",
+			      "(adapter %s, port d_id=0x%06x)\n",
 			      zfcp_get_busid_by_port(port), port->d_id);
 		debug_text_event(adapter->erp_dbf, 2, "fsf_s_pboxed");
 		zfcp_erp_port_boxed(port);
@@ -1683,7 +1683,7 @@
 				  NULL, &lock_flags, &fsf_req);
 	if (ret < 0) {
                 ZFCP_LOG_INFO("error: creation of ELS request failed "
-			      "(adapter %s, port d_id: 0x%08x)\n",
+			      "(adapter %s, port d_id: 0x%06x)\n",
                               zfcp_get_busid_by_adapter(adapter), d_id);
                 goto failed_req;
 	}
@@ -1708,7 +1708,7 @@
                                                 ZFCP_MAX_SBALS_PER_ELS_REQ);
                 if (bytes <= 0) {
                         ZFCP_LOG_INFO("error: creation of ELS request failed "
-				      "(adapter %s, port d_id: 0x%08x)\n",
+				      "(adapter %s, port d_id: 0x%06x)\n",
 				      zfcp_get_busid_by_adapter(adapter), d_id);
                         if (bytes == 0) {
                                 ret = -ENOMEM;
@@ -1725,7 +1725,7 @@
                                                 ZFCP_MAX_SBALS_PER_ELS_REQ);
                 if (bytes <= 0) {
                         ZFCP_LOG_INFO("error: creation of ELS request failed "
-				      "(adapter %s, port d_id: 0x%08x)\n",
+				      "(adapter %s, port d_id: 0x%06x)\n",
 				      zfcp_get_busid_by_adapter(adapter), d_id);
                         if (bytes == 0) {
                                 ret = -ENOMEM;
@@ -1739,7 +1739,7 @@
                 /* reject request */
 		ZFCP_LOG_INFO("error: microcode does not support chained SBALs"
                               ", ELS request too big (adapter %s, "
-			      "port d_id: 0x%08x)\n",
+			      "port d_id: 0x%06x)\n",
 			      zfcp_get_busid_by_adapter(adapter), d_id);
                 ret = -EOPNOTSUPP;
                 goto failed_send;
@@ -1760,13 +1760,13 @@
 	ret = zfcp_fsf_req_send(fsf_req);
 	if (ret) {
 		ZFCP_LOG_DEBUG("error: initiation of ELS request failed "
-			       "(adapter %s, port d_id: 0x%08x)\n",
+			       "(adapter %s, port d_id: 0x%06x)\n",
 			       zfcp_get_busid_by_adapter(adapter), d_id);
 		goto failed_send;
 	}

 	ZFCP_LOG_DEBUG("ELS request initiated (adapter %s, port d_id: "
-		       "0x%08x)\n", zfcp_get_busid_by_adapter(adapter), d_id);
+		       "0x%06x)\n", zfcp_get_busid_by_adapter(adapter), d_id);
 	goto out;

  failed_send:
@@ -1859,7 +1859,7 @@
 	case FSF_ELS_COMMAND_REJECTED:
 		ZFCP_LOG_INFO("ELS has been rejected because command filter "
 			      "prohibited sending "
-			      "(adapter: %s, port d_id: 0x%08x)\n",
+			      "(adapter: %s, port d_id: 0x%06x)\n",
 			      zfcp_get_busid_by_adapter(adapter), d_id);

 		break;
@@ -1907,7 +1907,7 @@

 	case FSF_ACCESS_DENIED:
 		ZFCP_LOG_NORMAL("access denied, cannot send ELS command "
-				"(adapter %s, port d_id=0x%08x)\n",
+				"(adapter %s, port d_id=0x%06x)\n",
 				zfcp_get_busid_by_adapter(adapter), d_id);
 		for (counter = 0; counter < 2; counter++) {
 			subtable = header->fsf_status_qual.halfword[counter * 2];
@@ -2070,7 +2070,7 @@
 	ZFCP_LOG_NORMAL("The adapter %s reported the following characteristics:\n"
 			"WWNN 0x%016Lx, "
 			"WWPN 0x%016Lx, "
-			"S_ID 0x%08x,\n"
+			"S_ID 0x%06x,\n"
 			"adapter version 0x%x, "
 			"LIC version 0x%x, "
 			"FC link speed %d Gb/s\n",


-------------------------------------------------------

From: Andreas Herrmann <aherrman@de.ibm.com>
Subject: [PATCH] [5/8] zfcp: fix: problem in send_els_handler when D_ID assignment changes
Date: Mon, 13 Jun 2005 13:18:56 +0200
Message-ID: <20050613111856.GE8998@lion28.boeblingen.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate1.de.ibm.com ([195.212.29.150]:23997 "EHLO
	mtagate1.de.ibm.com") by vger.kernel.org with ESMTP id S261514AbVFMLS4
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Jun 2005 07:18:56 -0400
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate1.de.ibm.com (8.12.10/8.12.10) with ESMTP id j5DBItFu097364
	for <linux-scsi@vger.kernel.org>; Mon, 13 Jun 2005 11:18:55 GMT
Received: from d12av02.megacenter.de.ibm.com (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12nrmr1607.megacenter.de.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j5DBIt2H146348
	for <linux-scsi@vger.kernel.org>; Mon, 13 Jun 2005 13:18:55 +0200
Received: from d12av02.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av02.megacenter.de.ibm.com (8.12.11/8.13.3) with ESMTP id j5DBIslb028092
	for <linux-scsi@vger.kernel.org>; Mon, 13 Jun 2005 13:18:55 +0200
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@steeleye.com>
Cc: Linux SCSI <linux-scsi@vger.kernel.org>, Maxim Shchetynin <maxim@de.ibm.com>

This is patch 5 of 8 in a series of zfcp bug fixes.  Patches are based
on 2.6.12-rc6 plus "remove flags_dump feature"-patch from June, 10th.

This one fixes a bug in zfcp_send_els_handler.
If D_ID assignments for ports are changing between initiation of one
ELS request and its completion the wrong port might be accessed in the
completion for that ELS request. Thus a pointer to the port has to be
passed for ELS requests to identify the port structure if required.


Regards,

Andreas


From: Maxim Shchetynin <maxim@de.ibm.com>
 
zfcp: fix: problem in send_els_handler when D_ID assignment changes

Signed-off-by: Andreas Herrmann <aherrman@de.ibm.com>

diff -u linux-2.6.12-rc6/drivers/s390/scsi-orig/zfcp_def.h linux-2.6.12-rc6/drivers/s390/scsi/zfcp_def.h
--- linux-2.6.12-rc6/drivers/s390/scsi-orig/zfcp_def.h	2005-06-11 22:44:24.915843352 +0200
+++ linux-2.6.12-rc6/drivers/s390/scsi/zfcp_def.h	2005-06-11 22:40:32.509174536 +0200
@@ -751,6 +751,7 @@
 /**
  * struct zfcp_send_els - used to pass parameters to function zfcp_fsf_send_els
  * @adapter: adapter where request is sent from
+ * @port: port where ELS is destinated (port reference count has to be increased)
  * @d_id: destiniation id of port where request is sent to
  * @req: scatter-gather list for request
  * @resp: scatter-gather list for response
@@ -765,6 +766,7 @@
  */
 struct zfcp_send_els {
 	struct zfcp_adapter *adapter;
+	struct zfcp_port *port;
 	fc_id_t d_id;
 	struct scatterlist *req;
 	struct scatterlist *resp;
diff -u linux-2.6.12-rc6/drivers/s390/scsi-orig/zfcp_erp.c linux-2.6.12-rc6/drivers/s390/scsi/zfcp_erp.c
--- linux-2.6.12-rc6/drivers/s390/scsi-orig/zfcp_erp.c	2005-06-11 22:44:24.923842136 +0200
+++ linux-2.6.12-rc6/drivers/s390/scsi/zfcp_erp.c	2005-06-11 22:40:32.516173472 +0200
@@ -35,7 +35,7 @@
 
 #include "zfcp_ext.h"
 
-static int zfcp_erp_adisc(struct zfcp_adapter *, fc_id_t);
+static int zfcp_erp_adisc(struct zfcp_port *);
 static void zfcp_erp_adisc_handler(unsigned long);
 
 static int zfcp_erp_adapter_reopen_internal(struct zfcp_adapter *, int);
@@ -295,12 +295,12 @@
 
 /**
  * zfcp_erp_adisc - send ADISC ELS command
- * @adapter: adapter structure
- * @d_id: d_id of port where ADISC is sent to
+ * @port: port structure
  */
 int
-zfcp_erp_adisc(struct zfcp_adapter *adapter, fc_id_t d_id)
+zfcp_erp_adisc(struct zfcp_port *port)
 {
+	struct zfcp_adapter *adapter = port->adapter;
 	struct zfcp_send_els *send_els;
 	struct zfcp_ls_adisc *adisc;
 	void *address = NULL;
@@ -332,7 +332,8 @@
 	send_els->req_count = send_els->resp_count = 1;
 
 	send_els->adapter = adapter;
-	send_els->d_id = d_id;
+	send_els->port = port;
+	send_els->d_id = port->d_id;
 	send_els->handler = zfcp_erp_adisc_handler;
 	send_els->handler_data = (unsigned long) send_els;
 
@@ -350,7 +351,7 @@
 	ZFCP_LOG_INFO("ADISC request from s_id 0x%08x to d_id 0x%08x "
 		      "(wwpn=0x%016Lx, wwnn=0x%016Lx, "
 		      "hard_nport_id=0x%08x, nport_id=0x%08x)\n",
-		      adapter->s_id, d_id, (wwn_t) adisc->wwpn,
+		      adapter->s_id, send_els->d_id, (wwn_t) adisc->wwpn,
 		      (wwn_t) adisc->wwnn, adisc->hard_nport_id,
 		      adisc->nport_id);
 
@@ -367,7 +368,7 @@
 	retval = zfcp_fsf_send_els(send_els);
 	if (retval != 0) {
 		ZFCP_LOG_NORMAL("error: initiation of Send ELS failed for port "
-				"0x%08x on adapter %s\n", d_id,
+				"0x%08x on adapter %s\n", send_els->d_id,
 				zfcp_get_busid_by_adapter(adapter));
 		del_timer(send_els->timer);
 		goto freemem;
@@ -411,14 +412,9 @@
 	del_timer(send_els->timer);
 
 	adapter = send_els->adapter;
+	port = send_els->port;
 	d_id = send_els->d_id;
 
-	read_lock(&zfcp_data.config_lock);
-	port = zfcp_get_port_by_did(send_els->adapter, send_els->d_id);
-	read_unlock(&zfcp_data.config_lock);
-
-	BUG_ON(port == NULL);
-
 	/* request rejected or timed out */
 	if (send_els->status != 0) {
 		ZFCP_LOG_NORMAL("ELS request rejected/timed out, "
@@ -482,7 +478,7 @@
 	int retval;
 
 	zfcp_port_get(port);
-	retval = zfcp_erp_adisc(port->adapter, port->d_id);
+	retval = zfcp_erp_adisc(port);
 	if (retval != 0) {
 		zfcp_port_put(port);
 		ZFCP_LOG_NORMAL("reopen needed for port 0x%016Lx "
diff -u linux-2.6.12-rc6/drivers/s390/scsi-orig/zfcp_fsf.c linux-2.6.12-rc6/drivers/s390/scsi/zfcp_fsf.c
--- linux-2.6.12-rc6/drivers/s390/scsi-orig/zfcp_fsf.c	2005-06-11 22:44:24.943839096 +0200
+++ linux-2.6.12-rc6/drivers/s390/scsi/zfcp_fsf.c	2005-06-11 22:40:32.537170280 +0200
@@ -1771,8 +1771,8 @@
 static int zfcp_fsf_send_els_handler(struct zfcp_fsf_req *fsf_req)
 {
 	struct zfcp_adapter *adapter;
-	fc_id_t d_id;
 	struct zfcp_port *port;
+	fc_id_t d_id;
 	struct fsf_qtcb_header *header;
 	struct fsf_qtcb_bottom_support *bottom;
 	struct zfcp_send_els *send_els;
@@ -1781,6 +1781,7 @@
 
 	send_els = fsf_req->data.send_els;
 	adapter = send_els->adapter;
+	port = send_els->port;
 	d_id = send_els->d_id;
 	header = &fsf_req->qtcb->header;
 	bottom = &fsf_req->qtcb->bottom.support;
@@ -1817,13 +1818,8 @@
 		switch (header->fsf_status_qual.word[0]){
 		case FSF_SQ_INVOKE_LINK_TEST_PROCEDURE:
 			debug_text_event(adapter->erp_dbf, 1, "fsf_sq_ltest");
-			if (send_els->ls_code != ZFCP_LS_ADISC) {
-				read_lock(&zfcp_data.config_lock);
-				port = zfcp_get_port_by_did(adapter, d_id);
-				if (port)
-					zfcp_test_link(port);
-				read_unlock(&zfcp_data.config_lock);
-			}
+			if (port && (send_els->ls_code != ZFCP_LS_ADISC))
+				zfcp_test_link(port);
 			fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 			break;
 		case FSF_SQ_ULP_DEPENDENT_ERP_REQUIRED:
@@ -1913,11 +1909,8 @@
 			}
 		}
 		debug_text_event(adapter->erp_dbf, 1, "fsf_s_access");
-		read_lock(&zfcp_data.config_lock);
-		port = zfcp_get_port_by_did(adapter, d_id);
 		if (port != NULL)
 			zfcp_erp_port_access_denied(port);
-		read_unlock(&zfcp_data.config_lock);
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 


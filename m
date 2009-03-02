From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 10/18] [PATCH] zfcp: prevent adapter close on initial adapter open
Date: Mon, 02 Mar 2009 13:09:03 +0100
Message-ID: <20090302121003.382436000@de.ibm.com>
References: <20090302120853.279447000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate7.de.ibm.com ([195.212.29.156]:49655 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758713AbZCBMKH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Mar 2009 07:10:07 -0500
Content-Disposition: inline; filename=709-zfcp-adapter-close.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Swen Schillig <swen@vnet.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Swen Schillig <swen@vnet.ibm.com>

An adapter close was always performed whether it was required,
(e.g. in an error scenario) or not (e.g. initial open).
This patch is changing the process in only doing an 
adapter close when it is required.

Signed-off-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_erp.c |   69 +++++++++++++++++++++----------------------
 1 file changed, 34 insertions(+), 35 deletions(-)

diff -urpN linux-2.6/drivers/s390/scsi/zfcp_erp.c linux-2.6-patched/drivers/s390/scsi/zfcp_erp.c
--- linux-2.6/drivers/s390/scsi/zfcp_erp.c	2009-03-01 16:41:30.000000000 +0100
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_erp.c	2009-03-01 16:41:33.000000000 +0100
@@ -705,32 +705,10 @@ static int zfcp_erp_adapter_strategy_ope
 	return ZFCP_ERP_SUCCEEDED;
 }
 
-static int zfcp_erp_adapter_strategy_generic(struct zfcp_erp_action *act,
-					     int close)
+static void zfcp_erp_adapter_strategy_close(struct zfcp_erp_action *act)
 {
-	int retval = ZFCP_ERP_SUCCEEDED;
 	struct zfcp_adapter *adapter = act->adapter;
 
-	if (close)
-		goto close_only;
-
-	retval = zfcp_erp_adapter_strategy_open_qdio(act);
-	if (retval != ZFCP_ERP_SUCCEEDED)
-		goto failed_qdio;
-
-	retval = zfcp_erp_adapter_strategy_open_fsf(act);
-	if (retval != ZFCP_ERP_SUCCEEDED)
-		goto failed_openfcp;
-
-	atomic_set_mask(ZFCP_STATUS_COMMON_OPEN, &act->adapter->status);
-
-	return ZFCP_ERP_SUCCEEDED;
-
- close_only:
-	atomic_clear_mask(ZFCP_STATUS_COMMON_OPEN,
-			  &act->adapter->status);
-
- failed_openfcp:
 	/* close queues to ensure that buffers are not accessed by adapter */
 	zfcp_qdio_close(adapter);
 	zfcp_fsf_req_dismiss_all(adapter);
@@ -738,27 +716,48 @@ static int zfcp_erp_adapter_strategy_gen
 	/* all ports and units are closed */
 	zfcp_erp_modify_adapter_status(adapter, 24, NULL,
 				       ZFCP_STATUS_COMMON_OPEN, ZFCP_CLEAR);
- failed_qdio:
+
 	atomic_clear_mask(ZFCP_STATUS_ADAPTER_XCONFIG_OK |
-			  ZFCP_STATUS_ADAPTER_LINK_UNPLUGGED,
-			  &act->adapter->status);
-	return retval;
+			  ZFCP_STATUS_ADAPTER_LINK_UNPLUGGED, &adapter->status);
 }
 
-static int zfcp_erp_adapter_strategy(struct zfcp_erp_action *act)
+static int zfcp_erp_adapter_strategy_open(struct zfcp_erp_action *act)
 {
-	int retval;
+	struct zfcp_adapter *adapter = act->adapter;
 
-	zfcp_erp_adapter_strategy_generic(act, 1); /* close */
-	if (act->status & ZFCP_STATUS_ERP_CLOSE_ONLY)
-		return ZFCP_ERP_EXIT;
+	if (zfcp_erp_adapter_strategy_open_qdio(act)) {
+		atomic_clear_mask(ZFCP_STATUS_ADAPTER_XCONFIG_OK |
+				  ZFCP_STATUS_ADAPTER_LINK_UNPLUGGED,
+				  &adapter->status);
+		return ZFCP_ERP_FAILED;
+	}
 
-	retval = zfcp_erp_adapter_strategy_generic(act, 0); /* open */
+	if (zfcp_erp_adapter_strategy_open_fsf(act)) {
+		zfcp_erp_adapter_strategy_close(act);
+		return ZFCP_ERP_FAILED;
+	}
 
-	if (retval == ZFCP_ERP_FAILED)
+	atomic_set_mask(ZFCP_STATUS_COMMON_OPEN, &adapter->status);
+
+	return ZFCP_ERP_SUCCEEDED;
+}
+
+static int zfcp_erp_adapter_strategy(struct zfcp_erp_action *act)
+{
+	struct zfcp_adapter *adapter = act->adapter;
+
+	if (atomic_read(&adapter->status) & ZFCP_STATUS_COMMON_OPEN) {
+		zfcp_erp_adapter_strategy_close(act);
+		if (act->status & ZFCP_STATUS_ERP_CLOSE_ONLY)
+			return ZFCP_ERP_EXIT;
+	}
+
+	if (zfcp_erp_adapter_strategy_open(act)) {
 		ssleep(8);
+		return ZFCP_ERP_FAILED;
+	}
 
-	return retval;
+	return ZFCP_ERP_SUCCEEDED;
 }
 
 static int zfcp_erp_port_forced_strategy_close(struct zfcp_erp_action *act)


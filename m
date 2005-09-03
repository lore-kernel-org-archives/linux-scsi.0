From: Andreas Herrmann <aherrman@de.ibm.com>
Subject: [PATCH 2/7] zfcp: fix race conditions when accessing erp_action lists
Date: Sat, 3 Sep 2005 14:31:20 +0200
Message-ID: <20050903123120.GA7909@lion28.boeblingen.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate2.de.ibm.com ([195.212.29.151]:63180 "EHLO
	mtagate2.de.ibm.com") by vger.kernel.org with ESMTP
	id S1751068AbVICMdf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 3 Sep 2005 08:33:35 -0400
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate2.de.ibm.com (8.12.10/8.12.10) with ESMTP id j83CXYd7195532
	for <linux-scsi@vger.kernel.org>; Sat, 3 Sep 2005 12:33:34 GMT
Received: from d12av02.megacenter.de.ibm.com (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12nrmr1607.megacenter.de.ibm.com (8.12.10/NCO/VERS6.7) with ESMTP id j83CXYih122002
	for <linux-scsi@vger.kernel.org>; Sat, 3 Sep 2005 14:33:34 +0200
Received: from d12av02.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av02.megacenter.de.ibm.com (8.12.11/8.13.3) with ESMTP id j83CXYQu014588
	for <linux-scsi@vger.kernel.org>; Sat, 3 Sep 2005 14:33:34 +0200
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@steeleye.com>
Cc: Linux SCSI <linux-scsi@vger.kernel.org>

zfcp: fix race conditions when accessing erp_action lists

o always use locking when changing erp_action lists,
o avoid escalation to ERP_ACTION_REOPEN_PORT_FORCED if erp_action is
  still in use for ERP_ACTION_REOPEN_PORT

Signed-off-by: Andreas Herrmann <aherrman@de.ibm.com>

diff -Nup linux-2.6.13/drivers/s390/scsi-orig/zfcp_erp.c linux-2.6.13/drivers/s390/scsi/zfcp_erp.c
--- linux-2.6.13/drivers/s390/scsi-orig/zfcp_erp.c	2005-09-03 12:17:16.000000000 +0200
+++ linux-2.6.13/drivers/s390/scsi/zfcp_erp.c	2005-09-03 12:19:22.000000000 +0200
@@ -886,7 +886,7 @@ static int
 zfcp_erp_strategy_check_fsfreq(struct zfcp_erp_action *erp_action)
 {
 	int retval = 0;
-	struct zfcp_fsf_req *fsf_req;
+	struct zfcp_fsf_req *fsf_req = NULL;
 	struct zfcp_adapter *adapter = erp_action->adapter;
 
 	if (erp_action->fsf_req) {
@@ -896,7 +896,7 @@ zfcp_erp_strategy_check_fsfreq(struct zf
 		list_for_each_entry(fsf_req, &adapter->fsf_req_list_head, list)
 		    if (fsf_req == erp_action->fsf_req)
 			break;
-		if (fsf_req == erp_action->fsf_req) {
+		if (fsf_req && (fsf_req->erp_action == erp_action)) {
 			/* fsf_req still exists */
 			debug_text_event(adapter->erp_dbf, 3, "a_ca_req");
 			debug_event(adapter->erp_dbf, 3, &fsf_req,
@@ -2291,7 +2291,9 @@ zfcp_erp_adapter_strategy_open_fsf_xconf
 		atomic_clear_mask(ZFCP_STATUS_ADAPTER_HOST_CON_INIT,
 				  &adapter->status);
 		ZFCP_LOG_DEBUG("Doing exchange config data\n");
+		write_lock(&adapter->erp_lock);
 		zfcp_erp_action_to_running(erp_action);
+		write_unlock(&adapter->erp_lock);
 		zfcp_erp_timeout_init(erp_action);
 		if (zfcp_fsf_exchange_config_data(erp_action)) {
 			retval = ZFCP_ERP_FAILED;
@@ -3194,11 +3196,19 @@ zfcp_erp_action_enqueue(int action,
 		/* fall through !!! */
 
 	case ZFCP_ERP_ACTION_REOPEN_PORT_FORCED:
-		if (atomic_test_mask
-		    (ZFCP_STATUS_COMMON_ERP_INUSE, &port->status)
-		    && port->erp_action.action ==
-		    ZFCP_ERP_ACTION_REOPEN_PORT_FORCED) {
-			debug_text_event(adapter->erp_dbf, 4, "pf_actenq_drp");
+		if (atomic_test_mask(ZFCP_STATUS_COMMON_ERP_INUSE,
+				     &port->status)) {
+			if (port->erp_action.action !=
+			    ZFCP_ERP_ACTION_REOPEN_PORT_FORCED) {
+				ZFCP_LOG_INFO("dropped erp action %i (port "
+					      "0x%016Lx, action in use: %i)\n",
+					      action, port->wwpn,
+					      port->erp_action.action);
+				debug_text_event(adapter->erp_dbf, 4,
+						 "pf_actenq_drp");
+			} else 
+				debug_text_event(adapter->erp_dbf, 4,
+						 "pf_actenq_drpcp");
 			debug_event(adapter->erp_dbf, 4, &port->wwpn,
 				    sizeof (wwn_t));
 			goto out;

From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 08/13] zfcp: Fix erp escalation procedure
Date: Mon, 13 Jul 2009 15:06:09 +0200
Message-ID: <20090713131043.723827000@de.ibm.com>
References: <20090713130601.304914000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate4.de.ibm.com ([195.212.29.153]:42843 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755854AbZGMNK4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Jul 2009 09:10:56 -0400
Content-Disposition: inline; filename=714-zfcp-erp-escalation.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

If an action fails, retry it until the erp count exceeds the
threshold. If there is something fundamentally wrong, the FSF layer
will trigger a more appropriate action depending on the FSF status
codes.

The followup for successful actions is a different followup than
retrying failed actions, so split the code two functions to make this
clear.

Reviewed-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_erp.c |   50 ++++++++++++++++++++-----------------------
 1 file changed, 24 insertions(+), 26 deletions(-)

diff -urpN linux-2.6/drivers/s390/scsi/zfcp_erp.c linux-2.6-patched/drivers/s390/scsi/zfcp_erp.c
--- linux-2.6/drivers/s390/scsi/zfcp_erp.c	2009-07-12 21:09:01.000000000 +0200
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_erp.c	2009-07-12 21:09:01.000000000 +0200
@@ -553,40 +553,35 @@ static void _zfcp_erp_unit_reopen_all(st
 		_zfcp_erp_unit_reopen(unit, clear, id, ref);
 }
 
-static void zfcp_erp_strategy_followup_actions(struct zfcp_erp_action *act)
+static void zfcp_erp_strategy_followup_failed(struct zfcp_erp_action *act)
 {
-	struct zfcp_adapter *adapter = act->adapter;
-	struct zfcp_port *port = act->port;
-	struct zfcp_unit *unit = act->unit;
-	u32 status = act->status;
-
-	/* initiate follow-up actions depending on success of finished action */
 	switch (act->action) {
-
 	case ZFCP_ERP_ACTION_REOPEN_ADAPTER:
-		if (status == ZFCP_ERP_SUCCEEDED)
-			_zfcp_erp_port_reopen_all(adapter, 0, "ersfa_1", NULL);
-		else
-			_zfcp_erp_adapter_reopen(adapter, 0, "ersfa_2", NULL);
+		_zfcp_erp_adapter_reopen(act->adapter, 0, "ersff_1", NULL);
 		break;
-
 	case ZFCP_ERP_ACTION_REOPEN_PORT_FORCED:
-		if (status == ZFCP_ERP_SUCCEEDED)
-			_zfcp_erp_port_reopen(port, 0, "ersfa_3", NULL);
-		else
-			_zfcp_erp_adapter_reopen(adapter, 0, "ersfa_4", NULL);
+		_zfcp_erp_port_forced_reopen(act->port, 0, "ersff_2", NULL);
 		break;
-
 	case ZFCP_ERP_ACTION_REOPEN_PORT:
-		if (status == ZFCP_ERP_SUCCEEDED)
-			_zfcp_erp_unit_reopen_all(port, 0, "ersfa_5", NULL);
-		else
-			_zfcp_erp_port_forced_reopen(port, 0, "ersfa_6", NULL);
+		_zfcp_erp_port_reopen(act->port, 0, "ersff_3", NULL);
 		break;
-
 	case ZFCP_ERP_ACTION_REOPEN_UNIT:
-		if (status != ZFCP_ERP_SUCCEEDED)
-			_zfcp_erp_port_reopen(unit->port, 0, "ersfa_7", NULL);
+		_zfcp_erp_unit_reopen(act->unit, 0, "ersff_4", NULL);
+		break;
+	}
+}
+
+static void zfcp_erp_strategy_followup_success(struct zfcp_erp_action *act)
+{
+	switch (act->action) {
+	case ZFCP_ERP_ACTION_REOPEN_ADAPTER:
+		_zfcp_erp_port_reopen_all(act->adapter, 0, "ersfs_1", NULL);
+		break;
+	case ZFCP_ERP_ACTION_REOPEN_PORT_FORCED:
+		_zfcp_erp_port_reopen(act->port, 0, "ersfs_2", NULL);
+		break;
+	case ZFCP_ERP_ACTION_REOPEN_PORT:
+		_zfcp_erp_unit_reopen_all(act->port, 0, "ersfs_3", NULL);
 		break;
 	}
 }
@@ -1289,7 +1284,10 @@ static int zfcp_erp_strategy(struct zfcp
 	retval = zfcp_erp_strategy_statechange(erp_action, retval);
 	if (retval == ZFCP_ERP_EXIT)
 		goto unlock;
-	zfcp_erp_strategy_followup_actions(erp_action);
+	if (retval == ZFCP_ERP_SUCCEEDED)
+		zfcp_erp_strategy_followup_success(erp_action);
+	if (retval == ZFCP_ERP_FAILED)
+		zfcp_erp_strategy_followup_failed(erp_action);
 
  unlock:
 	write_unlock(&adapter->erp_lock);


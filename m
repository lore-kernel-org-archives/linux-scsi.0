From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 1/3] ibmvfc: Fix rport add/delete race resulting in oops
Date: Thu, 05 Aug 2010 16:38:31 -0500
Message-ID: <201008052138.o75LcUN3012792@d03av02.boulder.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e39.co.us.ibm.com ([32.97.110.160]:60218 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932865Ab0HEVim (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Aug 2010 17:38:42 -0400
Received: from d03relay03.boulder.ibm.com (d03relay03.boulder.ibm.com [9.17.195.228])
	by e39.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id o75LSkk0001324
	for <linux-scsi@vger.kernel.org>; Thu, 5 Aug 2010 15:28:46 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay03.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o75LcYdQ144886
	for <linux-scsi@vger.kernel.org>; Thu, 5 Aug 2010 15:38:34 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id o75LcWLM012905
	for <linux-scsi@vger.kernel.org>; Thu, 5 Aug 2010 15:38:33 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com


Commit 43c8da907ccc656935d1085701f4db83385d8a59 introduced a race
condition which can occur when adding/deleting rports. There are
two possible threads now that can be deleting rports in the ibmvfc
driver, which can result in list_del being called twice, resulting
in an oops. This patch adds a new state to the ibmvfc_target struct
to indicate the target has been removed from the list and is in
the process of being deleted.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ibmvscsi/ibmvfc.c |    8 ++++++++
 drivers/scsi/ibmvscsi/ibmvfc.h |    1 +
 2 files changed, 9 insertions(+)

diff -puN drivers/scsi/ibmvscsi/ibmvfc.h~ibmvfc_fix_del_race drivers/scsi/ibmvscsi/ibmvfc.h
--- linux-2.6/drivers/scsi/ibmvscsi/ibmvfc.h~ibmvfc_fix_del_race	2010-07-14 13:13:50.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ibmvscsi/ibmvfc.h	2010-07-14 13:14:11.000000000 -0500
@@ -597,6 +597,7 @@ enum ibmvfc_target_action {
 	IBMVFC_TGT_ACTION_INIT,
 	IBMVFC_TGT_ACTION_INIT_WAIT,
 	IBMVFC_TGT_ACTION_DEL_RPORT,
+	IBMVFC_TGT_ACTION_DELETED_RPORT,
 };
 
 struct ibmvfc_target {
diff -puN drivers/scsi/ibmvscsi/ibmvfc.c~ibmvfc_fix_del_race drivers/scsi/ibmvscsi/ibmvfc.c
--- linux-2.6/drivers/scsi/ibmvscsi/ibmvfc.c~ibmvfc_fix_del_race	2010-07-14 13:14:21.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ibmvscsi/ibmvfc.c	2010-07-14 13:22:49.000000000 -0500
@@ -433,6 +433,9 @@ static void ibmvfc_set_tgt_action(struct
 {
 	switch (tgt->action) {
 	case IBMVFC_TGT_ACTION_DEL_RPORT:
+		if (action == IBMVFC_TGT_ACTION_DELETED_RPORT)
+			tgt->action = action;
+	case IBMVFC_TGT_ACTION_DELETED_RPORT:
 		break;
 	default:
 		if (action == IBMVFC_TGT_ACTION_DEL_RPORT)
@@ -4193,11 +4196,15 @@ static void ibmvfc_tgt_add_rport(struct
 	if (rport && tgt->action == IBMVFC_TGT_ACTION_DEL_RPORT) {
 		tgt_dbg(tgt, "Deleting rport\n");
 		list_del(&tgt->queue);
+		ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_DELETED_RPORT);
 		spin_unlock_irqrestore(vhost->host->host_lock, flags);
 		fc_remote_port_delete(rport);
 		del_timer_sync(&tgt->timer);
 		kref_put(&tgt->kref, ibmvfc_release_tgt);
 		return;
+	} else if (rport && tgt->action == IBMVFC_TGT_ACTION_DELETED_RPORT) {
+		spin_unlock_irqrestore(vhost->host->host_lock, flags);
+		return;
 	}
 
 	if (rport) {
@@ -4297,6 +4304,7 @@ static void ibmvfc_do_work(struct ibmvfc
 				rport = tgt->rport;
 				tgt->rport = NULL;
 				list_del(&tgt->queue);
+				ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_DELETED_RPORT);
 				spin_unlock_irqrestore(vhost->host->host_lock, flags);
 				if (rport)
 					fc_remote_port_delete(rport);
_

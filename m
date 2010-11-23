From: "Eddie Wai" <eddie.wai@broadcom.com>
Subject: [PATCH v3 09/13] BNX2I: Modified the bnx2i stop path to
 compensate for in progress ops
Date: Tue, 23 Nov 2010 15:29:28 -0800
Message-ID: <1290554972-16928-10-git-send-email-eddie.wai@broadcom.com>
References: <Eddie Wai <eddie.wai@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1133 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754187Ab0KWX1g (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Nov 2010 18:27:36 -0500
In-Reply-To: <Eddie Wai <eddie.wai@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <JBottomley@novell.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, open-iscsi <open-iscsi@googlegroups.com>, linux-scsi <linux-scsi@vger.kernel.org>, Michael Chan <mchan@broadcom.com>, Anil Veerabhadrappa <anilgv@broadcom.com>, Ben Li <benli@broadcom.com>, Eddie Wai <eddie.wai@broadcom.com>

The stop path has been augmented to wait a max of 10s for all in
progress offload and destroy activities to complete before proceeding
to terminate all active connections (via iscsid or forcefully).

Note that any new offload and destroy requests are now blocked and
return to the caller immediately.

Signed-off-by: Eddie Wai <eddie.wai@broadcom.com>
Acked-by: Anil Veerabhadrappa <anilgv@broadcom.com>
Reviewed-by: Benjamin Li <benli@broadcom.com>
Reviewed-by: Michael Chan <mchan@broadcom.com>
---
 drivers/scsi/bnx2i/bnx2i_init.c  |   21 +++++++++++++++++----
 drivers/scsi/bnx2i/bnx2i_iscsi.c |    7 ++++++-
 2 files changed, 23 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/bnx2i/bnx2i_init.c b/drivers/scsi/bnx2i/bnx2i_init.c
index 769311f..338caac 100644
--- a/drivers/scsi/bnx2i/bnx2i_init.c
+++ b/drivers/scsi/bnx2i/bnx2i_init.c
@@ -209,13 +209,24 @@ void bnx2i_stop(void *handle)
 {
 	struct bnx2i_hba *hba = handle;
 	int conns_active;
+	int wait_delay = 1 * HZ;
 
 	/* check if cleanup happened in GOING_DOWN context */
-	if (!test_and_clear_bit(ADAPTER_STATE_GOING_DOWN,
-				&hba->adapter_state))
+	if (!test_and_set_bit(ADAPTER_STATE_GOING_DOWN,
+			      &hba->adapter_state)) {
 		iscsi_host_for_each_session(hba->shost,
 					    bnx2i_drop_session);
-
+		wait_delay = hba->hba_shutdown_tmo;
+	}
+	/* Wait for inflight offload connection tasks to complete before
+	 * proceeding. Forcefully terminate all connection recovery in
+	 * progress at the earliest, either in bind(), send_pdu(LOGIN),
+	 * or conn_start()
+	 */
+	wait_event_interruptible_timeout(hba->eh_wait,
+					 (list_empty(&hba->ep_ofld_list) &&
+					 list_empty(&hba->ep_destroy_list)),
+					 10 * HZ);
 	/* Wait for all endpoints to be torn down, Chip will be reset once
 	 *  control returns to network driver. So it is required to cleanup and
 	 * release all connection resources before returning from this routine.
@@ -224,7 +235,7 @@ void bnx2i_stop(void *handle)
 		conns_active = hba->ofld_conns_active;
 		wait_event_interruptible_timeout(hba->eh_wait,
 				(hba->ofld_conns_active != conns_active),
-				hba->hba_shutdown_tmo);
+				wait_delay);
 		if (hba->ofld_conns_active == conns_active)
 			break;
 	}
@@ -233,9 +244,11 @@ void bnx2i_stop(void *handle)
 	/* This flag should be cleared last so that ep_disconnect() gracefully
 	 * cleans up connection context
 	 */
+	clear_bit(ADAPTER_STATE_GOING_DOWN, &hba->adapter_state);
 	clear_bit(ADAPTER_STATE_UP, &hba->adapter_state);
 }
 
+
 /**
  * bnx2i_init_one - initialize an adapter instance and allocate memory resources
  * @hba:	bnx2i adapter instance
diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
index 43b7dad..ac60c4c 100644
--- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
+++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
@@ -1383,6 +1383,12 @@ static int bnx2i_conn_bind(struct iscsi_cls_session *cls_session,
 	ep = iscsi_lookup_endpoint(transport_fd);
 	if (!ep)
 		return -EINVAL;
+	/*
+	 * Forcefully terminate all in progress connection recovery at the
+	 * earliest, either in bind(), send_pdu(LOGIN), or conn_start()
+	 */
+	if (bnx2i_adapter_ready(hba))
+		return -EIO;
 
 	bnx2i_ep = ep->dd_data;
 	if ((bnx2i_ep->state == EP_STATE_TCP_FIN_RCVD) ||
@@ -1404,7 +1410,6 @@ static int bnx2i_conn_bind(struct iscsi_cls_session *cls_session,
 				  hba->netdev->name);
 		return -EEXIST;
 	}
-
 	bnx2i_ep->conn = bnx2i_conn;
 	bnx2i_conn->ep = bnx2i_ep;
 	bnx2i_conn->iscsi_conn_cid = bnx2i_ep->ep_iscsi_cid;
-- 
1.7.0.5



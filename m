From: "Eddie Wai" <eddie.wai@broadcom.com>
Subject: [PATCH 04/16] BNX2I: Updated the handling of NETEVENTs to
 alleviate recovery
Date: Wed, 10 Nov 2010 15:04:45 -0800
Message-ID: <1289430297-30221-5-git-send-email-eddie.wai@broadcom.com>
References: <Eddie Wai <eddie.wai@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1904 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757396Ab0KJXDI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Nov 2010 18:03:08 -0500
In-Reply-To: <Eddie Wai <eddie.wai@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <JBottomley@novell.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, open-iscsi <open-iscsi@googlegroups.com>, linux-scsi <linux-scsi@vger.kernel.org>, Michael Chan <mchan@broadcom.com>, Anil Veerabhadrappa <anilgv@broadcom.com>, Ben Li <benli@broadcom.com>, Eddie Wai <eddie.wai@broadcom.com>

The NETDEV_GOING_DOWN handling will no longer request to put all
active sessions into recovery mode until the NETDEV_DOWN event.
This will eliminate the unnecessary recovery request to iscsid in the
NETDEV_GOING_DOWN->NETDEV_UNREGISTER path which will remove the host
anyway.

Signed-off-by: Eddie Wai <eddie.wai@broadcom.com>
Reviewed-by: Michael Chan <mchan@broadcom.com>
---
 drivers/scsi/bnx2i/bnx2i.h     |    3 ++
 drivers/scsi/bnx2i/bnx2i_hwi.c |   53 +++++++++++++++++++++++++++++++++++++--
 2 files changed, 53 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/bnx2i/bnx2i.h b/drivers/scsi/bnx2i/bnx2i.h
index a44b1b3..1aeb9f0 100644
--- a/drivers/scsi/bnx2i/bnx2i.h
+++ b/drivers/scsi/bnx2i/bnx2i.h
@@ -227,6 +227,7 @@ struct bnx2i_cmd {
  * @gen_pdu:               login/nopout/logout pdu resources
  * @violation_notified:    bit mask used to track iscsi error/warning messages
  *                         already printed out
+ * @prev_sess_state:       tracks the previous connection state
  *
  * iSCSI connection structure
  */
@@ -250,6 +251,8 @@ struct bnx2i_conn {
 	 */
 	struct generic_pdu_resc gen_pdu;
 	u64 violation_notified;
+
+	int prev_sess_state;
 };
 
 
diff --git a/drivers/scsi/bnx2i/bnx2i_hwi.c b/drivers/scsi/bnx2i/bnx2i_hwi.c
index c9a3c0f..7eeb673 100644
--- a/drivers/scsi/bnx2i/bnx2i_hwi.c
+++ b/drivers/scsi/bnx2i/bnx2i_hwi.c
@@ -2244,6 +2244,11 @@ static void bnx2i_indicate_kcqe(void *context, struct kcqe *kcqe[],
 static void bnx2i_indicate_netevent(void *context, unsigned long event)
 {
 	struct bnx2i_hba *hba = context;
+	struct bnx2i_conn *bnx2i_conn;
+	struct iscsi_conn *conn;
+	struct iscsi_session *session;
+	int conns_active, i;
+	unsigned long flags;
 
 	switch (event) {
 	case NETDEV_UP:
@@ -2251,13 +2256,55 @@ static void bnx2i_indicate_netevent(void *context, unsigned long event)
 			bnx2i_send_fw_iscsi_init_msg(hba);
 		break;
 	case NETDEV_DOWN:
+		for (i = 0; i < hba->max_active_conns; i++) {
+			bnx2i_conn = bnx2i_get_conn_from_id(hba, i);
+			if (bnx2i_conn) {
+				conn = bnx2i_conn->cls_conn->dd_data;
+				session = conn->session;
+				spin_lock_irqsave(&session->lock, flags);
+				if (session->state == ISCSI_STATE_FAILED)
+					session->state =
+						bnx2i_conn->prev_sess_state;
+				spin_unlock_irqrestore(&session->lock, flags);
+			}
+		}
+		iscsi_host_for_each_session(hba->shost,
+					    bnx2i_drop_session);
+		while (hba->ofld_conns_active) {
+			conns_active = hba->ofld_conns_active;
+
+			wait_event_interruptible_timeout(hba->eh_wait,
+				(hba->ofld_conns_active != conns_active),
+				hba->hba_shutdown_tmo);
+			if (hba->ofld_conns_active == conns_active)
+				break;
+		}
+		/* This flag should be cleared last so that ep_disconnect()
+		 * gracefully cleans up connection context
+		 */
 		clear_bit(ADAPTER_STATE_GOING_DOWN, &hba->adapter_state);
 		clear_bit(ADAPTER_STATE_UP, &hba->adapter_state);
+		if (hba->ofld_conns_active)
+			printk(KERN_ERR "bnx2i (%s): NETDEV_DOWN with %d "
+				"active conns\n", hba->netdev->name,
+				hba->ofld_conns_active);
 		break;
 	case NETDEV_GOING_DOWN:
-		set_bit(ADAPTER_STATE_GOING_DOWN, &hba->adapter_state);
-		iscsi_host_for_each_session(hba->shost,
-					    bnx2i_drop_session);
+		/* Suspend all data transmissions */
+		for (i = 0; i < hba->max_active_conns; i++) {
+			bnx2i_conn = bnx2i_get_conn_from_id(hba, i);
+			if (bnx2i_conn) {
+				conn = bnx2i_conn->cls_conn->dd_data;
+				session = conn->session;
+				spin_lock_irqsave(&session->lock, flags);
+				bnx2i_conn->prev_sess_state = session->state;
+				if (conn->stop_stage == 0)
+					session->state = ISCSI_STATE_FAILED;
+				spin_unlock_irqrestore(&session->lock, flags);
+				iscsi_suspend_queue(conn);
+				set_bit(ISCSI_SUSPEND_BIT, &conn->suspend_rx);
+			}
+		}
 		break;
 	case NETDEV_CHANGE:
 		bnx2i_get_link_state(hba);
-- 
1.7.0.5



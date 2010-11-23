From: "Eddie Wai" <eddie.wai@broadcom.com>
Subject: [PATCH v3 05/13] BNX2I: Fixed the remote TCP RST handling for
 the 570X (1g)
Date: Tue, 23 Nov 2010 15:29:24 -0800
Message-ID: <1290554972-16928-6-git-send-email-eddie.wai@broadcom.com>
References: <Eddie Wai <eddie.wai@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1074 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753824Ab0KWX1g (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Nov 2010 18:27:36 -0500
In-Reply-To: <Eddie Wai <eddie.wai@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <JBottomley@novell.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, open-iscsi <open-iscsi@googlegroups.com>, linux-scsi <linux-scsi@vger.kernel.org>, Michael Chan <mchan@broadcom.com>, Anil Veerabhadrappa <anilgv@broadcom.com>, Ben Li <benli@broadcom.com>, Eddie Wai <eddie.wai@broadcom.com>

Modified the handling of the remote TCP RST code so the chip can now
flush the tx pipe accordingly upon a remote TCP RST reception.

Signed-off-by: Eddie Wai <eddie.wai@broadcom.com>
---
 drivers/scsi/bnx2i/bnx2i_hwi.c   |    8 ++++++--
 drivers/scsi/bnx2i/bnx2i_iscsi.c |    8 +++-----
 2 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/bnx2i/bnx2i_hwi.c b/drivers/scsi/bnx2i/bnx2i_hwi.c
index c9a3c0f..0d40dae 100644
--- a/drivers/scsi/bnx2i/bnx2i_hwi.c
+++ b/drivers/scsi/bnx2i/bnx2i_hwi.c
@@ -2350,10 +2350,14 @@ static void bnx2i_cm_remote_close(struct cnic_sock *cm_sk)
 static void bnx2i_cm_remote_abort(struct cnic_sock *cm_sk)
 {
 	struct bnx2i_endpoint *ep = (struct bnx2i_endpoint *) cm_sk->context;
+	u32 old_state = ep->state;
 
 	ep->state = EP_STATE_TCP_RST_RCVD;
-	if (ep->conn)
-		bnx2i_recovery_que_add_conn(ep->hba, ep->conn);
+	if (old_state == EP_STATE_DISCONN_START)
+		wake_up_interruptible(&ep->ofld_wait);
+	else
+		if (ep->conn)
+			bnx2i_recovery_que_add_conn(ep->hba, ep->conn);
 }
 
 
diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
index b766812..4882b00 100644
--- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
+++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
@@ -1907,6 +1907,7 @@ static int bnx2i_ep_tcp_conn_active(struct bnx2i_endpoint *bnx2i_ep)
 
 	switch (bnx2i_ep->state) {
 	case EP_STATE_CONNECT_START:
+	case EP_STATE_CONNECT_FAILED:
 	case EP_STATE_CLEANUP_FAILED:
 	case EP_STATE_OFLD_FAILED:
 	case EP_STATE_DISCONN_TIMEDOUT:
@@ -1922,13 +1923,10 @@ static int bnx2i_ep_tcp_conn_active(struct bnx2i_endpoint *bnx2i_ep)
 		ret = 1;
 		break;
 	case EP_STATE_TCP_RST_RCVD:
-		ret = 0;
-		break;
-	case EP_STATE_CONNECT_FAILED:
 		if (cnic_dev_10g)
-			ret = 1;
-		else
 			ret = 0;
+		else
+			ret = 1;
 		break;
 	default:
 		ret = 0;
-- 
1.7.0.5



From: "Eddie Wai" <eddie.wai@broadcom.com>
Subject: [PATCH 07/16] BNX2I: Fixed the remote TCP RST handling for the
 570X (1g)
Date: Wed, 10 Nov 2010 15:04:48 -0800
Message-ID: <1289430297-30221-8-git-send-email-eddie.wai@broadcom.com>
References: <Eddie Wai <eddie.wai@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1888 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757357Ab0KJXDI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Nov 2010 18:03:08 -0500
In-Reply-To: <Eddie Wai <eddie.wai@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <JBottomley@novell.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, open-iscsi <open-iscsi@googlegroups.com>, linux-scsi <linux-scsi@vger.kernel.org>, Michael Chan <mchan@broadcom.com>, Anil Veerabhadrappa <anilgv@broadcom.com>, Ben Li <benli@broadcom.com>, Eddie Wai <eddie.wai@broadcom.com>

Modified the handling of the remote TCP RST code so the chip can now
flush the tx pipe accordingly upon a remote TCP RST reception.

Signed-off-by: Eddie Wai <eddie.wai@broadcom.com>
---
 drivers/scsi/bnx2i/bnx2i_hwi.c   |   11 ++++++++---
 drivers/scsi/bnx2i/bnx2i_iscsi.c |    8 +++-----
 2 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/bnx2i/bnx2i_hwi.c b/drivers/scsi/bnx2i/bnx2i_hwi.c
index 7eeb673..4609ef5 100644
--- a/drivers/scsi/bnx2i/bnx2i_hwi.c
+++ b/drivers/scsi/bnx2i/bnx2i_hwi.c
@@ -2380,12 +2380,17 @@ static void bnx2i_cm_abort_cmpl(struct cnic_sock *cm_sk)
 static void bnx2i_cm_remote_close(struct cnic_sock *cm_sk)
 {
 	struct bnx2i_endpoint *ep = (struct bnx2i_endpoint *) cm_sk->context;
+	u32 old_state = ep->state;
 
-	ep->state = EP_STATE_TCP_FIN_RCVD;
-	if (ep->conn)
-		bnx2i_recovery_que_add_conn(ep->hba, ep->conn);
+	ep->state = EP_STATE_TCP_RST_RCVD;
+	if (old_state == EP_STATE_DISCONN_START)
+		wake_up_interruptible(&ep->ofld_wait);
+	else
+		if (ep->conn)
+			bnx2i_recovery_que_add_conn(ep->hba, ep->conn);
 }
 
+
 /**
  * bnx2i_cm_remote_abort - process TCP RST and start conn cleanup
  * @hba:		adapter structure pointer
diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
index 3b65c64..6a87a83 100644
--- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
+++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
@@ -1911,6 +1911,7 @@ static int bnx2i_ep_tcp_conn_active(struct bnx2i_endpoint *bnx2i_ep)
 
 	switch (bnx2i_ep->state) {
 	case EP_STATE_CONNECT_START:
+	case EP_STATE_CONNECT_FAILED:
 	case EP_STATE_CLEANUP_FAILED:
 	case EP_STATE_OFLD_FAILED:
 	case EP_STATE_DISCONN_TIMEDOUT:
@@ -1926,13 +1927,10 @@ static int bnx2i_ep_tcp_conn_active(struct bnx2i_endpoint *bnx2i_ep)
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



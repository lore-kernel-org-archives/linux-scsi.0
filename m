From: "Dupuis, Chad" <chad.dupuis@cavium.com>
Subject: [PATCH 12/15] qedf: Move some prints to a debug level so they do not print when no debugging is enabled.
Date: Tue, 23 May 2017 06:19:28 -0700
Message-ID: <20170523131931.1777-13-chad.dupuis@cavium.com>
References: <20170523131931.1777-1-chad.dupuis@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-cys01nam02on0082.outbound.protection.outlook.com ([104.47.37.82]:27776
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S937123AbdEWNT7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 23 May 2017 09:19:59 -0400
In-Reply-To: <20170523131931.1777-1-chad.dupuis@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com, QLogic-Storage-Upstream@cavium.com

Signed-off-by: Chad Dupuis <chad.dupuis@cavium.com>
---
 drivers/scsi/qedf/qedf_main.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index 7d1a953..340cf74 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -442,7 +442,8 @@ static void qedf_link_update(void *dev, struct qed_link_output *link)
 		qedf_update_link_speed(qedf, link);
 
 		if (atomic_read(&qedf->dcbx) == QEDF_DCBX_DONE) {
-			QEDF_ERR(&(qedf->dbg_ctx), "DCBx done.\n");
+			QEDF_INFO(&(qedf->dbg_ctx), QEDF_LOG_DISC,
+			     "DCBx done.\n");
 			if (atomic_read(&qedf->link_down_tmo_valid) > 0)
 				queue_delayed_work(qedf->link_update_wq,
 				    &qedf->link_recovery, 0);
@@ -2156,16 +2157,16 @@ static void qedf_recv_frame(struct qedf_ctx *qedf,
 	}
 
 	if (ntoh24(&dest_mac[3]) != ntoh24(fh->fh_d_id)) {
-		QEDF_ERR(&(qedf->dbg_ctx), "FC frame d_id mismatch with MAC "
-		    "%pM.\n", dest_mac);
+		QEDF_INFO(&(qedf->dbg_ctx), QEDF_LOG_LL2,
+		    "FC frame d_id mismatch with MAC %pM.\n", dest_mac);
 		return;
 	}
 
 	if (qedf->ctlr.state) {
 		if (!ether_addr_equal(mac, qedf->ctlr.dest_addr)) {
-			QEDF_ERR(&(qedf->dbg_ctx), "Wrong source address: "
-			    "mac:%pM dest_addr:%pM.\n", mac,
-			    qedf->ctlr.dest_addr);
+			QEDF_INFO(&(qedf->dbg_ctx), QEDF_LOG_LL2,
+			    "Wrong source address: mac:%pM dest_addr:%pM.\n",
+			    mac, qedf->ctlr.dest_addr);
 			kfree_skb(skb);
 			return;
 		}
@@ -2179,9 +2180,9 @@ static void qedf_recv_frame(struct qedf_ctx *qedf,
 	 * empty then this is not addressed to our port so simply drop it.
 	 */
 	if (lport->port_id != ntoh24(fh->fh_d_id) && !vn_port) {
-		QEDF_ERR(&(qedf->dbg_ctx), "Dropping frame due to "
-		    "destination mismatch: lport->port_id=%x "
-		    "fh->d_id=%x.\n",
+		QEDF_INFO(&(qedf->dbg_ctx), QEDF_LOG_LL2,
+		    "Dropping frame due to destination mismatch: "
+		    "lport->port_id=%x fh->d_id=%x.\n",
 		    lport->port_id, ntoh24(fh->fh_d_id));
 		kfree_skb(skb);
 		return;
-- 
1.8.5.6

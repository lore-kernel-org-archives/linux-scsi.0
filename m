From: "Dupuis, Chad" <chad.dupuis@cavium.com>
Subject: [PATCH 04/15] qedf: Look at all descriptors when processing a clear virtual link.
Date: Tue, 23 May 2017 06:19:20 -0700
Message-ID: <20170523131931.1777-5-chad.dupuis@cavium.com>
References: <20170523131931.1777-1-chad.dupuis@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam03on0056.outbound.protection.outlook.com ([104.47.42.56]:31264
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S937109AbdEWNTs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 23 May 2017 09:19:48 -0400
In-Reply-To: <20170523131931.1777-1-chad.dupuis@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com, QLogic-Storage-Upstream@cavium.com

If there are multiple descriptors for a particular type in a clear virtual
link we receive, we will not process it correctly but rather take the last
value. This can cause us not to not flap the virtual link as the value from
the descriptors that we compare against the our stored FCF or fc_lport values
may not match.

Change is to do a comparison when processing the each descriptor instead of at
the end and then set a bool if we need to do the reset.

Signed-off-by: Chad Dupuis <chad.dupuis@cavium.com>
---
 drivers/scsi/qedf/qedf_fip.c | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/qedf/qedf_fip.c b/drivers/scsi/qedf/qedf_fip.c
index 2dfb817..64b04f2 100644
--- a/drivers/scsi/qedf/qedf_fip.c
+++ b/drivers/scsi/qedf/qedf_fip.c
@@ -156,10 +156,9 @@ void qedf_fip_recv(struct qedf_ctx *qedf, struct sk_buff *skb)
 	struct fip_wwn_desc *wp;
 	struct fip_vn_desc *vp;
 	size_t rlen, dlen;
-	uint32_t cvl_port_id;
-	__u8 cvl_mac[ETH_ALEN];
 	u16 op;
 	u8 sub;
+	bool do_reset = false;
 
 	eth_hdr = (struct ethhdr *)skb_mac_header(skb);
 	fiph = (struct fip_header *) ((void *)skb->data + 2 * ETH_ALEN + 2);
@@ -190,8 +189,6 @@ void qedf_fip_recv(struct qedf_ctx *qedf, struct sk_buff *skb)
 			return;
 		}
 
-		cvl_port_id = 0;
-		memset(cvl_mac, 0, ETH_ALEN);
 		/*
 		 * We need to loop through the CVL descriptors to determine
 		 * if we want to reset the fcoe link
@@ -205,7 +202,9 @@ void qedf_fip_recv(struct qedf_ctx *qedf, struct sk_buff *skb)
 				mp = (struct fip_mac_desc *)desc;
 				QEDF_INFO(&(qedf->dbg_ctx), QEDF_LOG_LL2,
 				    "fd_mac=%pM\n", mp->fd_mac);
-				ether_addr_copy(cvl_mac, mp->fd_mac);
+				if (ether_addr_equal(mp->fd_mac,
+				    qedf->ctlr.sel_fcf->fcf_mac))
+					do_reset = true;
 				break;
 			case FIP_DT_NAME:
 				wp = (struct fip_wwn_desc *)desc;
@@ -217,7 +216,9 @@ void qedf_fip_recv(struct qedf_ctx *qedf, struct sk_buff *skb)
 				vp = (struct fip_vn_desc *)desc;
 				QEDF_INFO(&(qedf->dbg_ctx), QEDF_LOG_LL2,
 				    "fd_fc_id=%x.\n", ntoh24(vp->fd_fc_id));
-				cvl_port_id = ntoh24(vp->fd_fc_id);
+				if (ntoh24(vp->fd_fc_id) ==
+				    qedf->lport->port_id)
+					do_reset = true;
 				break;
 			default:
 				/* Ignore anything else */
@@ -228,11 +229,8 @@ void qedf_fip_recv(struct qedf_ctx *qedf, struct sk_buff *skb)
 		}
 
 		QEDF_INFO(&(qedf->dbg_ctx), QEDF_LOG_LL2,
-		    "cvl_port_id=%06x cvl_mac=%pM.\n", cvl_port_id,
-		    cvl_mac);
-		if (cvl_port_id == qedf->lport->port_id &&
-		    ether_addr_equal(cvl_mac,
-		    qedf->ctlr.sel_fcf->fcf_mac)) {
+		    "do_reset=%d.\n", do_reset);
+		if (do_reset) {
 			fcoe_ctlr_link_down(&qedf->ctlr);
 			qedf_wait_for_upload(qedf);
 			fcoe_ctlr_link_up(&qedf->ctlr);
-- 
1.8.5.6

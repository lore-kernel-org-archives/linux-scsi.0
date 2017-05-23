From: "Dupuis, Chad" <chad.dupuis@cavium.com>
Subject: [PATCH 10/15] qedf: Add non-offload receive filters.
Date: Tue, 23 May 2017 06:19:26 -0700
Message-ID: <20170523131931.1777-11-chad.dupuis@cavium.com>
References: <20170523131931.1777-1-chad.dupuis@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam02on0067.outbound.protection.outlook.com ([104.47.36.67]:51129
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S933691AbdEWNT4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 23 May 2017 09:19:56 -0400
In-Reply-To: <20170523131931.1777-1-chad.dupuis@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com, QLogic-Storage-Upstream@cavium.com

Drop invalid or unexpected FCoE frames that come into the non-offload path
since the FCoE firmware would not do the filtering for us.

Signed-off-by: Chad Dupuis <chad.dupuis@cavium.com>
---
 drivers/scsi/qedf/qedf_main.c | 46 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index 7dae915..7d1a953 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -2088,6 +2088,8 @@ static void qedf_recv_frame(struct qedf_ctx *qedf,
 	u8 *dest_mac = NULL;
 	struct fcoe_hdr *hp;
 	struct qedf_rport *fcport;
+	struct fc_lport *vn_port;
+	u32 f_ctl;
 
 	lport = qedf->lport;
 	if (lport == NULL || lport->state == LPORT_ST_DISABLED) {
@@ -2124,6 +2126,10 @@ static void qedf_recv_frame(struct qedf_ctx *qedf,
 
 	fh = fc_frame_header_get(fp);
 
+	/*
+	 * Invalid frame filters.
+	 */
+
 	if (fh->fh_r_ctl == FC_RCTL_DD_SOL_DATA &&
 	    fh->fh_type == FC_TYPE_FCP) {
 		/* Drop FCP data. We dont this in L2 path */
@@ -2149,6 +2155,46 @@ static void qedf_recv_frame(struct qedf_ctx *qedf,
 		return;
 	}
 
+	if (ntoh24(&dest_mac[3]) != ntoh24(fh->fh_d_id)) {
+		QEDF_ERR(&(qedf->dbg_ctx), "FC frame d_id mismatch with MAC "
+		    "%pM.\n", dest_mac);
+		return;
+	}
+
+	if (qedf->ctlr.state) {
+		if (!ether_addr_equal(mac, qedf->ctlr.dest_addr)) {
+			QEDF_ERR(&(qedf->dbg_ctx), "Wrong source address: "
+			    "mac:%pM dest_addr:%pM.\n", mac,
+			    qedf->ctlr.dest_addr);
+			kfree_skb(skb);
+			return;
+		}
+	}
+
+	vn_port = fc_vport_id_lookup(lport, ntoh24(fh->fh_d_id));
+
+	/*
+	 * If the destination ID from the frame header does not match what we
+	 * have on record for lport and the search for a NPIV port came up
+	 * empty then this is not addressed to our port so simply drop it.
+	 */
+	if (lport->port_id != ntoh24(fh->fh_d_id) && !vn_port) {
+		QEDF_ERR(&(qedf->dbg_ctx), "Dropping frame due to "
+		    "destination mismatch: lport->port_id=%x "
+		    "fh->d_id=%x.\n",
+		    lport->port_id, ntoh24(fh->fh_d_id));
+		kfree_skb(skb);
+		return;
+	}
+
+	f_ctl = ntoh24(fh->fh_f_ctl);
+	if ((fh->fh_type == FC_TYPE_BLS) && (f_ctl & FC_FC_SEQ_CTX) &&
+	    (f_ctl & FC_FC_EX_CTX)) {
+		/* Drop incoming ABTS response that has both SEQ/EX CTX set */
+		kfree_skb(skb);
+		return;
+	}
+
 	/*
 	 * If a connection is uploading, drop incoming FCoE frames as there
 	 * is a small window where we could try to return a frame while libfc
-- 
1.8.5.6

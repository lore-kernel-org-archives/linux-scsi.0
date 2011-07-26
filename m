From: "Bhanu Prakash Gollapudi" <bprakash@broadcom.com>
Subject: [PATCH RESEND 02/11] bnx2fc: Enable REC & CONF support for the
 session
Date: Tue, 26 Jul 2011 14:51:40 -0700
Message-ID: <1311717109-14077-3-git-send-email-bprakash@broadcom.com>
References: <1311717109-14077-1-git-send-email-bprakash@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2655 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753888Ab1GZVwH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Jul 2011 17:52:07 -0400
In-Reply-To: <1311717109-14077-1-git-send-email-bprakash@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com, linux-scsi@vger.kernel.org
Cc: michaelc@cs.wisc.edu, mchan@broadcom.com, devel@open-fcoe.org, Bhanu Prakash Gollapudi <bprakash@broadcom.com>

Based on PRLI response, identify if the target is FCP-2 (seq level error
recovery) capable, and appropriately set the corresponding CONF, REC flags when
offloading the session.

Signed-off-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
---
 drivers/scsi/bnx2fc/bnx2fc.h     |    2 ++
 drivers/scsi/bnx2fc/bnx2fc_hwi.c |   12 ++++++++++++
 drivers/scsi/bnx2fc/bnx2fc_io.c  |    3 ++-
 drivers/scsi/bnx2fc/bnx2fc_tgt.c |    8 ++++++++
 4 files changed, 24 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc.h b/drivers/scsi/bnx2fc/bnx2fc.h
index 6012317..d38dcc7 100644
--- a/drivers/scsi/bnx2fc/bnx2fc.h
+++ b/drivers/scsi/bnx2fc/bnx2fc.h
@@ -244,9 +244,11 @@ struct bnx2fc_rport {
 	struct fc_rport_priv *rdata;
 	void __iomem *ctx_base;
 #define DPM_TRIGER_TYPE		0x40
+	u32 io_timeout;
 	u32 fcoe_conn_id;
 	u32 context_id;
 	u32 sid;
+	int dev_type;
 
 	unsigned long flags;
 #define BNX2FC_FLAG_SESSION_READY	0x1
diff --git a/drivers/scsi/bnx2fc/bnx2fc_hwi.c b/drivers/scsi/bnx2fc/bnx2fc_hwi.c
index ee1674b..fa263b5 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_hwi.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_hwi.c
@@ -279,6 +279,18 @@ int bnx2fc_send_session_ofld_req(struct fcoe_port *port,
 	ofld_req3.flags |= (((rdata->sp_features & FC_SP_FT_SEQC) ? 1 : 0) <<
 			     FCOE_KWQE_CONN_OFFLOAD3_B_CONT_INCR_SEQ_CNT_SHIFT);
 
+	/*
+	 * Info from PRLI response, this info is used for sequence level error
+	 * recovery support
+	 */
+	if (tgt->dev_type == TYPE_TAPE) {
+		ofld_req3.flags |= 1 <<
+				    FCOE_KWQE_CONN_OFFLOAD3_B_CONF_REQ_SHIFT;
+		ofld_req3.flags |= (((rdata->flags & FC_RP_FLAGS_REC_SUPPORTED)
+				    ? 1 : 0) <<
+				    FCOE_KWQE_CONN_OFFLOAD3_B_REC_VALID_SHIFT);
+	}
+
 	/* vlan flag */
 	ofld_req3.flags |= (interface->vlan_enabled <<
 			    FCOE_KWQE_CONN_OFFLOAD3_B_VLAN_FLAG_SHIFT);
diff --git a/drivers/scsi/bnx2fc/bnx2fc_io.c b/drivers/scsi/bnx2fc/bnx2fc_io.c
index e711ea3..72940b8 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_io.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_io.c
@@ -1862,7 +1862,8 @@ static int bnx2fc_post_io_req(struct bnx2fc_rport *tgt,
 	}
 
 	/* Time IO req */
-	bnx2fc_cmd_timer_set(io_req, BNX2FC_IO_TIMEOUT);
+	if (tgt->io_timeout)
+		bnx2fc_cmd_timer_set(io_req, BNX2FC_IO_TIMEOUT);
 	/* Obtain free SQ entry */
 	bnx2fc_add_2_sq(tgt, xid);
 
diff --git a/drivers/scsi/bnx2fc/bnx2fc_tgt.c b/drivers/scsi/bnx2fc/bnx2fc_tgt.c
index 263c267..7eff269 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_tgt.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_tgt.c
@@ -353,6 +353,14 @@ static int bnx2fc_init_tgt(struct bnx2fc_rport *tgt,
 	tgt->rq_cons_idx = 0;
 	atomic_set(&tgt->num_active_ios, 0);
 
+	if (rdata->flags & FC_RP_FLAGS_RETRY) {
+		tgt->dev_type = TYPE_TAPE;
+		tgt->io_timeout = 0; /* use default ULP timeout */
+	} else {
+		tgt->dev_type = TYPE_DISK;
+		tgt->io_timeout = BNX2FC_IO_TIMEOUT;
+	}
+
 	/* initialize sq doorbell */
 	sq_db->header.header = B577XX_DOORBELL_HDR_DB_TYPE;
 	sq_db->header.header |= B577XX_FCOE_CONNECTION_TYPE <<
-- 
1.7.0.6



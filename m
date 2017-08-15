From: Chad Dupuis <chad.dupuis@cavium.com>
Subject: [PATCH 2/6] qedf: Use granted MAC from the FCF for the FCoE source address if it is available.
Date: Tue, 15 Aug 2017 10:08:17 -0700
Message-ID: <20170815170821.20806-3-chad.dupuis@cavium.com>
References: <20170815170821.20806-1-chad.dupuis@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2nam02on0080.outbound.protection.outlook.com ([104.47.38.80]:26992
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751702AbdHORIs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 15 Aug 2017 13:08:48 -0400
In-Reply-To: <20170815170821.20806-1-chad.dupuis@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com, QLogic-Storage-Upstream@cavium.com

Currently in the driver we've been using the fc_fcoe_set_mac() function to
set the source MAC for FCoE traffic.  This works well in most cases as it
uses the spec. default FCF-MAC.  However, if the administrator changes the
FCF-MAC switch, then any FCoE traffic we send will be dropped by the
switch.

Instead we should check the granted MAC from the FLOGI payload and use that
address if it is present.  Otherwise, fall back to using the the default
FCF-MAC and the fabric ID of the port as the FCoE MAC address.

Once this address is known we need to set it when doing non-offload
traffic, offload traffic and setting the data_src_address libfcoe uses for
FIP keep alive messages.

Signed-off-by: Chad Dupuis <chad.dupuis@cavium.com>
---
 drivers/scsi/qedf/qedf.h      |  1 -
 drivers/scsi/qedf/qedf_fip.c  | 17 -------------
 drivers/scsi/qedf/qedf_main.c | 59 +++++++++++++++++++++++++++++++++++++------
 3 files changed, 51 insertions(+), 26 deletions(-)

diff --git a/drivers/scsi/qedf/qedf.h b/drivers/scsi/qedf/qedf.h
index 351f06dfc5a0..e05ec331557b 100644
--- a/drivers/scsi/qedf/qedf.h
+++ b/drivers/scsi/qedf/qedf.h
@@ -443,7 +443,6 @@ extern void qedf_cmd_mgr_free(struct qedf_cmd_mgr *cmgr);
 extern int qedf_queuecommand(struct Scsi_Host *host,
 	struct scsi_cmnd *sc_cmd);
 extern void qedf_fip_send(struct fcoe_ctlr *fip, struct sk_buff *skb);
-extern void qedf_update_src_mac(struct fc_lport *lport, u8 *addr);
 extern u8 *qedf_get_src_mac(struct fc_lport *lport);
 extern void qedf_fip_recv(struct qedf_ctx *qedf, struct sk_buff *skb);
 extern void qedf_fcoe_send_vlan_req(struct qedf_ctx *qedf);
diff --git a/drivers/scsi/qedf/qedf_fip.c b/drivers/scsi/qedf/qedf_fip.c
index aefd24ca9604..28ce0f7ffc7b 100644
--- a/drivers/scsi/qedf/qedf_fip.c
+++ b/drivers/scsi/qedf/qedf_fip.c
@@ -242,26 +242,9 @@ void qedf_fip_recv(struct qedf_ctx *qedf, struct sk_buff *skb)
 	}
 }
 
-void qedf_update_src_mac(struct fc_lport *lport, u8 *addr)
-{
-	struct qedf_ctx *qedf = lport_priv(lport);
-
-	QEDF_INFO(&(qedf->dbg_ctx), QEDF_LOG_DISC,
-	    "Setting data_src_addr=%pM.\n", addr);
-	ether_addr_copy(qedf->data_src_addr, addr);
-}
-
 u8 *qedf_get_src_mac(struct fc_lport *lport)
 {
-	u8 mac[ETH_ALEN];
-	u8 port_id[3];
 	struct qedf_ctx *qedf = lport_priv(lport);
 
-	/* We need to use the lport port_id to create the data_src_addr */
-	if (is_zero_ether_addr(qedf->data_src_addr)) {
-		hton24(port_id, lport->port_id);
-		fc_fcoe_set_mac(mac, port_id);
-		qedf->ctlr.update_mac(lport, mac);
-	}
 	return qedf->data_src_addr;
 }
diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index 9744b6aa2a03..1df80aa03da1 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -18,6 +18,7 @@
 #include <linux/kthread.h>
 #include <scsi/libfc.h>
 #include <scsi/scsi_host.h>
+#include <scsi/fc_frame.h>
 #include <linux/if_ether.h>
 #include <linux/if_vlan.h>
 #include <linux/cpu.h>
@@ -187,6 +188,50 @@ static void qedf_handle_link_update(struct work_struct *work)
 	}
 }
 
+#define	QEDF_FCOE_MAC_METHOD_GRANGED_MAC		1
+#define QEDF_FCOE_MAC_METHOD_FCF_MAP			2
+#define QEDF_FCOE_MAC_METHOD_FCOE_SET_MAC		3
+static void qedf_set_data_src_addr(struct qedf_ctx *qedf, struct fc_frame *fp)
+{
+	u8 *granted_mac;
+	struct fc_frame_header *fh = fc_frame_header_get(fp);
+	u8 fc_map[3];
+	int method = 0;
+
+	/* Get granted MAC address from FIP FLOGI payload */
+	granted_mac = fr_cb(fp)->granted_mac;
+
+	/*
+	 * We set the source MAC for FCoE traffic based on the Granted MAC
+	 * address from the switch.
+	 *
+	 * If granted_mac is non-zero, we used that.
+	 * If the granted_mac is zeroed out, created the FCoE MAC based on
+	 * the sel_fcf->fc_map and the d_id fo the FLOGI frame.
+	 * If sel_fcf->fc_map is 0 then we use the default FCF-MAC plus the
+	 * d_id of the FLOGI frame.
+	 */
+	if (!is_zero_ether_addr(granted_mac)) {
+		ether_addr_copy(qedf->data_src_addr, granted_mac);
+		method = QEDF_FCOE_MAC_METHOD_GRANGED_MAC;
+	} else if (qedf->ctlr.sel_fcf->fc_map != 0) {
+		hton24(fc_map, qedf->ctlr.sel_fcf->fc_map);
+		qedf->data_src_addr[0] = fc_map[0];
+		qedf->data_src_addr[1] = fc_map[1];
+		qedf->data_src_addr[2] = fc_map[2];
+		qedf->data_src_addr[3] = fh->fh_d_id[0];
+		qedf->data_src_addr[4] = fh->fh_d_id[1];
+		qedf->data_src_addr[5] = fh->fh_d_id[2];
+		method = QEDF_FCOE_MAC_METHOD_FCF_MAP;
+	} else {
+		fc_fcoe_set_mac(qedf->data_src_addr, fh->fh_d_id);
+		method = QEDF_FCOE_MAC_METHOD_FCOE_SET_MAC;
+	}
+
+	QEDF_INFO(&(qedf->dbg_ctx), QEDF_LOG_DISC,
+	    "QEDF data_src_mac=%pM method=%d.\n", qedf->data_src_addr, method);
+}
+
 static void qedf_flogi_resp(struct fc_seq *seq, struct fc_frame *fp,
 	void *arg)
 {
@@ -212,6 +257,10 @@ static void qedf_flogi_resp(struct fc_seq *seq, struct fc_frame *fp,
 	/* Log stats for FLOGI reject */
 	if (fc_frame_payload_op(fp) == ELS_LS_RJT)
 		qedf->flogi_failed++;
+	else if (fc_frame_payload_op(fp) == ELS_LS_ACC) {
+		/* Set the source MAC we will use for FCoE traffic */
+		qedf_set_data_src_addr(qedf, fp);
+	}
 
 	/* Complete flogi_compl so we can proceed to sending ADISCs */
 	complete(&qedf->flogi_compl);
@@ -927,7 +976,7 @@ static int qedf_xmit(struct fc_lport *lport, struct fc_frame *fp)
 		ether_addr_copy(eh->h_dest, qedf->ctlr.dest_addr);
 
 	/* Set the source MAC address */
-	fc_fcoe_set_mac(eh->h_source, fh->fh_s_id);
+	ether_addr_copy(eh->h_source, qedf->data_src_addr);
 
 	hp = (struct fcoe_hdr *)(eh + 1);
 	memset(hp, 0, sizeof(*hp));
@@ -1025,7 +1074,6 @@ static int qedf_offload_connection(struct qedf_ctx *qedf,
 {
 	struct qed_fcoe_params_offload conn_info;
 	u32 port_id;
-	u8 lport_src_id[3];
 	int rval;
 	uint16_t total_sqe = (fcport->sq_mem_size / sizeof(struct fcoe_wqe));
 
@@ -1054,11 +1102,7 @@ static int qedf_offload_connection(struct qedf_ctx *qedf,
 	    (dma_addr_t)(*(u64 *)(fcport->sq_pbl + 8));
 
 	/* Need to use our FCoE MAC for the offload session */
-	port_id = fc_host_port_id(qedf->lport->host);
-	lport_src_id[2] = (port_id & 0x000000FF);
-	lport_src_id[1] = (port_id & 0x0000FF00) >> 8;
-	lport_src_id[0] = (port_id & 0x00FF0000) >> 16;
-	fc_fcoe_set_mac(conn_info.src_mac, lport_src_id);
+	ether_addr_copy(conn_info.src_mac, qedf->data_src_addr);
 
 	ether_addr_copy(conn_info.dst_mac, qedf->ctlr.dest_addr);
 
@@ -1347,7 +1391,6 @@ static void qedf_fcoe_ctlr_setup(struct qedf_ctx *qedf)
 	fcoe_ctlr_init(&qedf->ctlr, FIP_ST_AUTO);
 
 	qedf->ctlr.send = qedf_fip_send;
-	qedf->ctlr.update_mac = qedf_update_src_mac;
 	qedf->ctlr.get_src_addr = qedf_get_src_mac;
 	ether_addr_copy(qedf->ctlr.ctl_src_addr, qedf->mac);
 }
-- 
2.12.3

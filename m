From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 5/6] ibmvfc: Add ADISC support
Date: Mon, 14 Jul 2008 14:36:35 -0500
Message-ID: <200807141936.m6EJalQT023322@d01av02.pok.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:49424 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755558AbYGNTgx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Jul 2008 15:36:53 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e1.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m6EJaqJ0006706
	for <linux-scsi@vger.kernel.org>; Mon, 14 Jul 2008 15:36:52 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m6EJaqUL222982
	for <linux-scsi@vger.kernel.org>; Mon, 14 Jul 2008 15:36:52 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m6EJanDE023445
	for <linux-scsi@vger.kernel.org>; Mon, 14 Jul 2008 15:36:51 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com


Add an ADISC to the target discovery job in order to sanity check whether or
not we need to re-login to the target.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ibmvscsi/ibmvfc.c |  135 +++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/ibmvscsi/ibmvfc.h |   36 ++++++++++
 2 files changed, 171 insertions(+)

diff -puN drivers/scsi/ibmvscsi/ibmvfc.c~ibmvfc_pdisc drivers/scsi/ibmvscsi/ibmvfc.c
--- linux-2.6/drivers/scsi/ibmvscsi/ibmvfc.c~ibmvfc_pdisc	2008-07-14 10:13:30.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ibmvscsi/ibmvfc.c	2008-07-14 11:23:04.000000000 -0500
@@ -2914,6 +2914,139 @@ static void ibmvfc_tgt_implicit_logout(s
 }
 
 /**
+ * ibmvfc_adisc_needs_plogi - Does device need PLOGI?
+ * @mad:	ibmvfc passthru mad struct
+ * @tgt:	ibmvfc target struct
+ *
+ * Returns:
+ *	1 if PLOGI needed / 0 if PLOGI not needed
+ **/
+static int ibmvfc_adisc_needs_plogi(struct ibmvfc_passthru_mad *mad,
+				    struct ibmvfc_target *tgt)
+{
+	if (memcmp(&mad->fc_iu.response[2], &tgt->ids.port_name,
+		   sizeof(tgt->ids.port_name)))
+		return 1;
+	if (memcmp(&mad->fc_iu.response[4], &tgt->ids.node_name,
+		   sizeof(tgt->ids.node_name)))
+		return 1;
+	if (mad->fc_iu.response[6] != tgt->scsi_id)
+		return 1;
+	return 0;
+}
+
+/**
+ * ibmvfc_tgt_adisc_done - Completion handler for ADISC
+ * @evt:	ibmvfc event struct
+ *
+ **/
+static void ibmvfc_tgt_adisc_done(struct ibmvfc_event *evt)
+{
+	struct ibmvfc_target *tgt = evt->tgt;
+	struct ibmvfc_host *vhost = evt->vhost;
+	struct ibmvfc_passthru_mad *mad = &evt->xfer_iu->passthru;
+	u32 status = mad->common.status;
+	u8 fc_reason, fc_explain;
+
+	vhost->discovery_threads--;
+	ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_NONE);
+
+	switch (status) {
+	case IBMVFC_MAD_SUCCESS:
+		tgt_dbg(tgt, "ADISC succeeded\n");
+		if (ibmvfc_adisc_needs_plogi(mad, tgt))
+			tgt->need_login = 1;
+		break;
+	case IBMVFC_MAD_DRIVER_FAILED:
+		break;
+	case IBMVFC_MAD_FAILED:
+	default:
+		tgt->need_login = 1;
+		fc_reason = (mad->fc_iu.response[1] & 0x00ff0000) >> 16;
+		fc_explain = (mad->fc_iu.response[1] & 0x0000ff00) >> 8;
+		tgt_info(tgt, "ADISC failed: %s (%x:%x) %s (%x) %s (%x) rc=0x%02X\n",
+			 ibmvfc_get_cmd_error(mad->iu.status, mad->iu.error),
+			 mad->iu.status, mad->iu.error,
+			 ibmvfc_get_fc_type(fc_reason), fc_reason,
+			 ibmvfc_get_ls_explain(fc_explain), fc_explain, status);
+		break;
+	};
+
+	kref_put(&tgt->kref, ibmvfc_release_tgt);
+	ibmvfc_free_event(evt);
+	wake_up(&vhost->work_wait_q);
+}
+
+/**
+ * ibmvfc_init_passthru - Initialize an event struct for FC passthru
+ * @evt:		ibmvfc event struct
+ *
+ **/
+static void ibmvfc_init_passthru(struct ibmvfc_event *evt)
+{
+	struct ibmvfc_passthru_mad *mad = &evt->iu.passthru;
+
+	memset(mad, 0, sizeof(*mad));
+	mad->common.version = 1;
+	mad->common.opcode = IBMVFC_PASSTHRU;
+	mad->common.length = sizeof(*mad) - sizeof(mad->fc_iu) - sizeof(mad->iu);
+	mad->cmd_ioba.va = (u64)evt->crq.ioba +
+		offsetof(struct ibmvfc_passthru_mad, iu);
+	mad->cmd_ioba.len = sizeof(mad->iu);
+	mad->iu.cmd_len = sizeof(mad->fc_iu.payload);
+	mad->iu.rsp_len = sizeof(mad->fc_iu.response);
+	mad->iu.cmd.va = (u64)evt->crq.ioba +
+		offsetof(struct ibmvfc_passthru_mad, fc_iu) +
+		offsetof(struct ibmvfc_passthru_fc_iu, payload);
+	mad->iu.cmd.len = sizeof(mad->fc_iu.payload);
+	mad->iu.rsp.va = (u64)evt->crq.ioba +
+		offsetof(struct ibmvfc_passthru_mad, fc_iu) +
+		offsetof(struct ibmvfc_passthru_fc_iu, response);
+	mad->iu.rsp.len = sizeof(mad->fc_iu.response);
+}
+
+/**
+ * ibmvfc_tgt_adisc - Initiate an ADISC for specified target
+ * @tgt:		ibmvfc target struct
+ *
+ **/
+static void ibmvfc_tgt_adisc(struct ibmvfc_target *tgt)
+{
+	struct ibmvfc_passthru_mad *mad;
+	struct ibmvfc_host *vhost = tgt->vhost;
+	struct ibmvfc_event *evt;
+
+	if (vhost->discovery_threads >= disc_threads)
+		return;
+
+	kref_get(&tgt->kref);
+	evt = ibmvfc_get_event(vhost);
+	vhost->discovery_threads++;
+	ibmvfc_init_event(evt, ibmvfc_tgt_adisc_done, IBMVFC_MAD_FORMAT);
+	evt->tgt = tgt;
+
+	ibmvfc_init_passthru(evt);
+	mad = &evt->iu.passthru;
+	mad->iu.flags = IBMVFC_FC_ELS;
+	mad->iu.scsi_id = tgt->scsi_id;
+
+	mad->fc_iu.payload[0] = IBMVFC_ADISC;
+	memcpy(&mad->fc_iu.payload[2], &vhost->login_buf->resp.port_name,
+	       sizeof(vhost->login_buf->resp.port_name));
+	memcpy(&mad->fc_iu.payload[4], &vhost->login_buf->resp.node_name,
+	       sizeof(vhost->login_buf->resp.node_name));
+	mad->fc_iu.payload[6] = vhost->login_buf->resp.scsi_id & 0x00ffffff;
+
+	ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_INIT_WAIT);
+	if (ibmvfc_send_event(evt, vhost, default_timeout)) {
+		vhost->discovery_threads--;
+		ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_NONE);
+		kref_put(&tgt->kref, ibmvfc_release_tgt);
+	} else
+		tgt_dbg(tgt, "Sent ADISC\n");
+}
+
+/**
  * ibmvfc_tgt_query_target_done - Completion handler for Query Target MAD
  * @evt:	ibmvfc event struct
  *
@@ -2933,6 +3066,8 @@ static void ibmvfc_tgt_query_target_done
 		tgt->new_scsi_id = rsp->scsi_id;
 		if (rsp->scsi_id != tgt->scsi_id)
 			ibmvfc_init_tgt(tgt, ibmvfc_tgt_implicit_logout);
+		else
+			ibmvfc_init_tgt(tgt, ibmvfc_tgt_adisc);
 		break;
 	case IBMVFC_MAD_DRIVER_FAILED:
 		break;
diff -puN drivers/scsi/ibmvscsi/ibmvfc.h~ibmvfc_pdisc drivers/scsi/ibmvscsi/ibmvfc.h
--- linux-2.6/drivers/scsi/ibmvscsi/ibmvfc.h~ibmvfc_pdisc	2008-07-14 10:13:30.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ibmvscsi/ibmvfc.h	2008-07-14 11:19:21.000000000 -0500
@@ -119,6 +119,7 @@ enum ibmvfc_mad_types {
 	IBMVFC_PROCESS_LOGIN	= 0x0008,
 	IBMVFC_QUERY_TARGET	= 0x0010,
 	IBMVFC_IMPLICIT_LOGOUT	= 0x0040,
+	IBMVFC_PASSTHRU		= 0x0200,
 	IBMVFC_TMF_MAD		= 0x0100,
 };
 
@@ -439,6 +440,37 @@ struct ibmvfc_cmd {
 	struct ibmvfc_fcp_rsp rsp;
 }__attribute__((packed, aligned (8)));
 
+struct ibmvfc_passthru_fc_iu {
+	u32 payload[7];
+#define IBMVFC_ADISC	0x52000000
+	u32 response[7];
+};
+
+struct ibmvfc_passthru_iu {
+	u64 task_tag;
+	u32 cmd_len;
+	u32 rsp_len;
+	u16 status;
+	u16 error;
+	u32 flags;
+#define IBMVFC_FC_ELS		0x01
+	u32 cancel_key;
+	u32 reserved;
+	struct srp_direct_buf cmd;
+	struct srp_direct_buf rsp;
+	u64 correlation;
+	u64 scsi_id;
+	u64 tag;
+	u64 reserved2[2];
+}__attribute__((packed, aligned (8)));
+
+struct ibmvfc_passthru_mad {
+	struct ibmvfc_mad_common common;
+	struct srp_direct_buf cmd_ioba;
+	struct ibmvfc_passthru_iu iu;
+	struct ibmvfc_passthru_fc_iu fc_iu;
+}__attribute__((packed, aligned (8)));
+
 struct ibmvfc_trace_start_entry {
 	u32 xfer_len;
 }__attribute__((packed));
@@ -531,6 +563,7 @@ union ibmvfc_iu {
 	struct ibmvfc_implicit_logout implicit_logout;
 	struct ibmvfc_tmf tmf;
 	struct ibmvfc_cmd cmd;
+	struct ibmvfc_passthru_mad passthru;
 }__attribute__((packed, aligned (8)));
 
 enum ibmvfc_target_action {
@@ -656,6 +689,9 @@ struct ibmvfc_host {
 #define tgt_dbg(t, fmt, ...)			\
 	DBG_CMD(dev_info((t)->vhost->dev, "%lX: " fmt, (t)->scsi_id, ##__VA_ARGS__))
 
+#define tgt_info(t, fmt, ...)		\
+	dev_info((t)->vhost->dev, "%lX: " fmt, (t)->scsi_id, ##__VA_ARGS__)
+
 #define tgt_err(t, fmt, ...)		\
 	dev_err((t)->vhost->dev, "%lX: " fmt, (t)->scsi_id, ##__VA_ARGS__)
 
_

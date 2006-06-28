From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH 3/9] iscsi: convert iser to new set/get param fns
Date: Wed, 28 Jun 2006 12:00:25 -0500
Message-ID: <1151514025.11553.49.camel@madmax>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:28851 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S1751479AbWF1RCn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Jun 2006 13:02:43 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, ogerlitz@voltaire.com

Convert iser to libiscsi get/set param functions.
Fix bugs in it returning old error return values and
have it expose exp_statsn.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index 4c3f2de..d277fdf 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -438,159 +438,50 @@ iscsi_iser_session_create(struct iscsi_t
 }
 
 static int
-iscsi_iser_conn_set_param(struct iscsi_cls_conn *cls_conn,
-			  enum iscsi_param param, uint32_t value)
+iscsi_iser_set_param(struct iscsi_cls_conn *cls_conn,
+		     enum iscsi_param param, char *buf, int buflen)
 {
-	struct iscsi_conn *conn = cls_conn->dd_data;
-	struct iscsi_session *session = conn->session;
-
-	spin_lock_bh(&session->lock);
-	if (conn->c_stage != ISCSI_CONN_INITIAL_STAGE &&
-	    conn->stop_stage != STOP_CONN_RECOVER) {
-		printk(KERN_ERR "iscsi_iser: can not change parameter [%d]\n",
-		       param);
-		spin_unlock_bh(&session->lock);
-		return 0;
-	}
-	spin_unlock_bh(&session->lock);
+	int value;
 
 	switch (param) {
 	case ISCSI_PARAM_MAX_RECV_DLENGTH:
 		/* TBD */
 		break;
-	case ISCSI_PARAM_MAX_XMIT_DLENGTH:
-		conn->max_xmit_dlength =  value;
-		break;
 	case ISCSI_PARAM_HDRDGST_EN:
+		sscanf(buf, "%d", &value);
 		if (value) {
 			printk(KERN_ERR "DataDigest wasn't negotiated to None");
 			return -EPROTO;
 		}
 		break;
 	case ISCSI_PARAM_DATADGST_EN:
+		sscanf(buf, "%d", &value);
 		if (value) {
 			printk(KERN_ERR "DataDigest wasn't negotiated to None");
 			return -EPROTO;
 		}
 		break;
-	case ISCSI_PARAM_INITIAL_R2T_EN:
-		session->initial_r2t_en = value;
-		break;
-	case ISCSI_PARAM_IMM_DATA_EN:
-		session->imm_data_en = value;
-		break;
-	case ISCSI_PARAM_FIRST_BURST:
-		session->first_burst = value;
-		break;
-	case ISCSI_PARAM_MAX_BURST:
-		session->max_burst = value;
-		break;
-	case ISCSI_PARAM_PDU_INORDER_EN:
-		session->pdu_inorder_en = value;
-		break;
-	case ISCSI_PARAM_DATASEQ_INORDER_EN:
-		session->dataseq_inorder_en = value;
-		break;
-	case ISCSI_PARAM_ERL:
-		session->erl = value;
-		break;
 	case ISCSI_PARAM_IFMARKER_EN:
+		sscanf(buf, "%d", &value);
 		if (value) {
 			printk(KERN_ERR "IFMarker wasn't negotiated to No");
 			return -EPROTO;
 		}
 		break;
 	case ISCSI_PARAM_OFMARKER_EN:
+		sscanf(buf, "%d", &value);
 		if (value) {
 			printk(KERN_ERR "OFMarker wasn't negotiated to No");
 			return -EPROTO;
 		}
 		break;
 	default:
-		break;
-	}
-
-	return 0;
-}
-
-static int
-iscsi_iser_session_get_param(struct iscsi_cls_session *cls_session,
-			     enum iscsi_param param, uint32_t *value)
-{
-	struct Scsi_Host *shost = iscsi_session_to_shost(cls_session);
-	struct iscsi_session *session = iscsi_hostdata(shost->hostdata);
-
-	switch (param) {
-	case ISCSI_PARAM_INITIAL_R2T_EN:
-		*value = session->initial_r2t_en;
-		break;
-	case ISCSI_PARAM_MAX_R2T:
-		*value = session->max_r2t;
-		break;
-	case ISCSI_PARAM_IMM_DATA_EN:
-		*value = session->imm_data_en;
-		break;
-	case ISCSI_PARAM_FIRST_BURST:
-		*value = session->first_burst;
-		break;
-	case ISCSI_PARAM_MAX_BURST:
-		*value = session->max_burst;
-		break;
-	case ISCSI_PARAM_PDU_INORDER_EN:
-		*value = session->pdu_inorder_en;
-		break;
-	case ISCSI_PARAM_DATASEQ_INORDER_EN:
-		*value = session->dataseq_inorder_en;
-		break;
-	case ISCSI_PARAM_ERL:
-		*value = session->erl;
-		break;
-	case ISCSI_PARAM_IFMARKER_EN:
-		*value = 0;
-		break;
-	case ISCSI_PARAM_OFMARKER_EN:
-		*value = 0;
-		break;
-	default:
-		return ISCSI_ERR_PARAM_NOT_FOUND;
-	}
-
-	return 0;
-}
-
-static int
-iscsi_iser_conn_get_param(struct iscsi_cls_conn *cls_conn,
-			  enum iscsi_param param, uint32_t *value)
-{
-	struct iscsi_conn *conn = cls_conn->dd_data;
-
-	switch(param) {
-	case ISCSI_PARAM_MAX_RECV_DLENGTH:
-		*value = conn->max_recv_dlength;
-		break;
-	case ISCSI_PARAM_MAX_XMIT_DLENGTH:
-		*value = conn->max_xmit_dlength;
-		break;
-	case ISCSI_PARAM_HDRDGST_EN:
-		*value = 0;
-		break;
-	case ISCSI_PARAM_DATADGST_EN:
-		*value = 0;
-		break;
-	/*case ISCSI_PARAM_TARGET_RECV_DLENGTH:
-		*value = conn->target_recv_dlength;
-		break;
-	case ISCSI_PARAM_INITIATOR_RECV_DLENGTH:
-		*value = conn->initiator_recv_dlength;
-		break;*/
-	default:
-		return ISCSI_ERR_PARAM_NOT_FOUND;
+		return iscsi_set_param(cls_conn, param, buf, buflen);
 	}
 
 	return 0;
 }
 
-
 static void
 iscsi_iser_conn_get_stats(struct iscsi_cls_conn *cls_conn, struct iscsi_stats *stats)
 {
@@ -702,7 +593,12 @@ static struct iscsi_transport iscsi_iser
 				  ISCSI_FIRST_BURST |
 				  ISCSI_MAX_BURST |
 				  ISCSI_PDU_INORDER_EN |
-				  ISCSI_DATASEQ_INORDER_EN,
+				  ISCSI_DATASEQ_INORDER_EN |
+				  ISCSI_EXP_STATSN |
+				  ISCSI_PERSISTENT_PORT |
+				  ISCSI_PERSISTENT_ADDRESS |
+				  ISCSI_TARGET_NAME |
+				  ISCSI_TPGT,
 	.host_template          = &iscsi_iser_sht,
 	.conndata_size		= sizeof(struct iscsi_conn),
 	.max_lun                = ISCSI_ISER_MAX_LUN,
@@ -714,9 +610,9 @@ static struct iscsi_transport iscsi_iser
 	.create_conn            = iscsi_iser_conn_create,
 	.bind_conn              = iscsi_iser_conn_bind,
 	.destroy_conn           = iscsi_iser_conn_destroy,
-	.set_param              = iscsi_iser_conn_set_param,
-	.get_conn_param		= iscsi_iser_conn_get_param,
-	.get_session_param	= iscsi_iser_session_get_param,
+	.set_param              = iscsi_iser_set_param,
+	.get_conn_param		= iscsi_conn_get_param,
+	.get_session_param	= iscsi_session_get_param,
 	.start_conn             = iscsi_iser_conn_start,
 	.stop_conn              = iscsi_conn_stop,
 	/* these are called as part of conn recovery */



From: giridhar.malavali@qlogic.com
Subject: [PATCH 04/17] qla2xxx: Use GFF_ID to check FCP-SCSI FC4 type before logging into Nx_Ports
Date: Fri, 23 Jul 2010 15:28:25 +0500
Message-ID: <1279880918-62876-5-git-send-email-giridhar.malavali@qlogic.com>
References: <1279880918-62876-1-git-send-email-giridhar.malavali@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:47936 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1754698Ab0GWJ7I (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Jul 2010 05:59:08 -0400
In-Reply-To: <1279880918-62876-1-git-send-email-giridhar.malavali@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, madhu.iyengar@qlogic.com, linux-scsi@vger.kernel.org, Chad Dupuis <chad.dupuis@qlogic.com>

From: Chad Dupuis <chad.dupuis@qlogic.com>

The default method that qla2xxx uses is the GID_PT nameserver command to
get a list of Nx_Ports. This patch adds a GFF_ID call for each port
returned by GID_PT to get the FC4 type. If the FC4 type is not FCP SCSI
then the qla2xxx driver will not record that port in it's port database.
For switches that do not support the GFF_ID command, the behavior will be
for qla2xxx to store that port anyways.

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_def.h  |   20 +++++++++++
 drivers/scsi/qla2xxx/qla_gbl.h  |    1 +
 drivers/scsi/qla2xxx/qla_gs.c   |   72 +++++++++++++++++++++++++++++++++++++++
 drivers/scsi/qla2xxx/qla_init.c |   11 +++++-
 4 files changed, 103 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 7f9f86b..02c7480 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -1652,8 +1652,14 @@ typedef struct {
 	uint8_t port_name[WWN_SIZE];
 	uint8_t fabric_port_name[WWN_SIZE];
 	uint16_t fp_speed;
+	uint8_t fc4_type;
 } sw_info_t;
 
+/* FCP-4 types */
+#define FC4_TYPE_FCP_SCSI	0x08
+#define FC4_TYPE_OTHER		0x0
+#define FC4_TYPE_UNKNOWN	0xff
+
 /*
  * Fibre channel port type.
  */
@@ -1697,6 +1703,7 @@ typedef struct fc_port {
 	u32 supported_classes;
 
 	uint16_t vp_idx;
+	uint8_t fc4_type;
 } fc_port_t;
 
 /*
@@ -1779,6 +1786,9 @@ typedef struct fc_port {
 #define	GPSC_REQ_SIZE	(16 + 8)
 #define	GPSC_RSP_SIZE	(16 + 2 + 2)
 
+#define GFF_ID_CMD	0x011F
+#define GFF_ID_REQ_SIZE	(16 + 4)
+#define GFF_ID_RSP_SIZE (16 + 128)
 
 /*
  * HBA attribute types.
@@ -1980,6 +1990,11 @@ struct ct_sns_req {
 		struct {
 			uint8_t port_name[8];
 		} gpsc;
+
+		struct {
+			uint8_t reserved;
+			uint8_t port_name[3];
+		} gff_id;
 	} req;
 };
 
@@ -2052,6 +2067,11 @@ struct ct_sns_rsp {
 			uint16_t speeds;
 			uint16_t speed;
 		} gpsc;
+
+#define GFF_FCP_SCSI_OFFSET	7
+		struct {
+			uint8_t fc4_features[128];
+		} gff_id;
 	} rsp;
 };
 
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index fd29991..55f4599 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -441,6 +441,7 @@ extern int qla2x00_ga_nxt(scsi_qla_host_t *, fc_port_t *);
 extern int qla2x00_gid_pt(scsi_qla_host_t *, sw_info_t *);
 extern int qla2x00_gpn_id(scsi_qla_host_t *, sw_info_t *);
 extern int qla2x00_gnn_id(scsi_qla_host_t *, sw_info_t *);
+extern void qla2x00_gff_id(scsi_qla_host_t *, sw_info_t *);
 extern int qla2x00_rft_id(scsi_qla_host_t *);
 extern int qla2x00_rff_id(scsi_qla_host_t *);
 extern int qla2x00_rnn_id(scsi_qla_host_t *);
diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index 872c55f..2fabae8 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -1913,3 +1913,75 @@ qla2x00_gpsc(scsi_qla_host_t *vha, sw_info_t *list)
 
 	return (rval);
 }
+
+/**
+ * qla2x00_gff_id() - SNS Get FC-4 Features (GFF_ID) query.
+ *
+ * @ha: HA context
+ * @list: switch info entries to populate
+ *
+ */
+void
+qla2x00_gff_id(scsi_qla_host_t *vha, sw_info_t *list)
+{
+	int		rval;
+	uint16_t	i;
+
+	ms_iocb_entry_t	*ms_pkt;
+	struct ct_sns_req	*ct_req;
+	struct ct_sns_rsp	*ct_rsp;
+	struct qla_hw_data *ha = vha->hw;
+	uint8_t fcp_scsi_features = 0;
+
+	for (i = 0; i < MAX_FIBRE_DEVICES; i++) {
+		/* Set default FC4 Type as UNKNOWN so the default is to
+		 * Process this port */
+		list[i].fc4_type = FC4_TYPE_UNKNOWN;
+
+		/* Do not attempt GFF_ID if we are not FWI_2 capable */
+		if (!IS_FWI2_CAPABLE(ha))
+			continue;
+
+		/* Prepare common MS IOCB */
+		ms_pkt = ha->isp_ops->prep_ms_iocb(vha, GFF_ID_REQ_SIZE,
+		    GFF_ID_RSP_SIZE);
+
+		/* Prepare CT request */
+		ct_req = qla2x00_prep_ct_req(&ha->ct_sns->p.req, GFF_ID_CMD,
+		    GFF_ID_RSP_SIZE);
+		ct_rsp = &ha->ct_sns->p.rsp;
+
+		/* Prepare CT arguments -- port_id */
+		ct_req->req.port_id.port_id[0] = list[i].d_id.b.domain;
+		ct_req->req.port_id.port_id[1] = list[i].d_id.b.area;
+		ct_req->req.port_id.port_id[2] = list[i].d_id.b.al_pa;
+
+		/* Execute MS IOCB */
+		rval = qla2x00_issue_iocb(vha, ha->ms_iocb, ha->ms_iocb_dma,
+		   sizeof(ms_iocb_entry_t));
+
+		if (rval != QLA_SUCCESS) {
+			DEBUG2_3(printk(KERN_INFO
+			    "scsi(%ld): GFF_ID issue IOCB failed "
+			    "(%d).\n", vha->host_no, rval));
+		} else if (qla2x00_chk_ms_status(vha, ms_pkt, ct_rsp,
+			       "GPN_ID") != QLA_SUCCESS) {
+			DEBUG2_3(printk(KERN_INFO
+			    "scsi(%ld): GFF_ID IOCB status had a "
+			    "failure status code\n", vha->host_no));
+		} else {
+			fcp_scsi_features =
+			   ct_rsp->rsp.gff_id.fc4_features[GFF_FCP_SCSI_OFFSET];
+			fcp_scsi_features &= 0x0f;
+
+			if (fcp_scsi_features)
+				list[i].fc4_type = FC4_TYPE_FCP_SCSI;
+			else
+				list[i].fc4_type = FC4_TYPE_OTHER;
+		}
+
+		/* Last device exit. */
+		if (list[i].d_id.b.rsvd_1 != 0)
+			break;
+	}
+}
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index cea491b..685c350 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -3078,7 +3078,6 @@ qla2x00_configure_fabric(scsi_qla_host_t *vha)
 	return (rval);
 }
 
-
 /*
  * qla2x00_find_all_fabric_devs
  *
@@ -3131,6 +3130,10 @@ qla2x00_find_all_fabric_devs(scsi_qla_host_t *vha,
 		    qla2x00_gfpn_id(vha, swl) == QLA_SUCCESS) {
 			qla2x00_gpsc(vha, swl);
 		}
+
+		/* If other queries succeeded probe for FC-4 type */
+		if (swl)
+			qla2x00_gff_id(vha, swl);
 	}
 	swl_idx = 0;
 
@@ -3172,6 +3175,7 @@ qla2x00_find_all_fabric_devs(scsi_qla_host_t *vha,
 				memcpy(new_fcport->fabric_port_name,
 				    swl[swl_idx].fabric_port_name, WWN_SIZE);
 				new_fcport->fp_speed = swl[swl_idx].fp_speed;
+				new_fcport->fc4_type = swl[swl_idx].fc4_type;
 
 				if (swl[swl_idx].d_id.b.rsvd_1 != 0) {
 					last_dev = 1;
@@ -3233,6 +3237,11 @@ qla2x00_find_all_fabric_devs(scsi_qla_host_t *vha,
 		if ((new_fcport->d_id.b.domain & 0xf0) == 0xf0)
 			continue;
 
+		/* Bypass ports whose FCP-4 type is not FCP_SCSI */
+		if (new_fcport->fc4_type != FC4_TYPE_FCP_SCSI &&
+		    new_fcport->fc4_type != FC4_TYPE_UNKNOWN)
+			continue;
+
 		/* Locate matching device in database. */
 		found = 0;
 		list_for_each_entry(fcport, &vha->vp_fcports, list) {
-- 
1.6.0.2


From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 2/8] qla2xxx: Add support for symbolic nodename FC transport attribute.
Date: Mon,  2 Oct 2006 12:00:44 -0700
Message-ID: <11598156502784-git-send-email-andrew.vasquez@qlogic.com>
References: <20061002185947.GF16536@andrew-vasquezs-computer.local>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:53852 "EHLO avexch1.qlogic.com")
	by vger.kernel.org with ESMTP id S964964AbWJBTA4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Oct 2006 15:00:56 -0400
In-Reply-To: <20061002185947.GF16536@andrew-vasquezs-computer.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@steeleye.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

Refactored original code from qla_gs.c:qla2x00_rsnn_nn().

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_attr.c |   10 ++++++++++
 drivers/scsi/qla2xxx/qla_gbl.h  |    1 +
 drivers/scsi/qla2xxx/qla_gs.c   |   26 +++++++++++---------------
 3 files changed, 22 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 144b0f8..4638469 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -849,6 +849,14 @@ qla2x00_get_fc_host_stats(struct Scsi_Ho
 	return pfc_host_stat;
 }
 
+static void
+qla2x00_get_host_symbolic_name(struct Scsi_Host *shost)
+{
+	scsi_qla_host_t *ha = to_qla_host(shost);
+
+	qla2x00_get_sym_node_name(ha, fc_host_symbolic_name(shost));
+}
+
 struct fc_function_template qla2xxx_transport_functions = {
 
 	.show_host_node_name = 1,
@@ -861,6 +869,8 @@ struct fc_function_template qla2xxx_tran
 	.show_host_speed = 1,
 	.get_host_port_type = qla2x00_get_host_port_type,
 	.show_host_port_type = 1,
+	.get_host_symbolic_name = qla2x00_get_host_symbolic_name,
+	.show_host_symbolic_name = 1,
 
 	.dd_fcrport_size = sizeof(struct fc_port *),
 	.show_rport_supported_classes = 1,
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index c48e1d8..bef7011 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -287,6 +287,7 @@ extern void *qla24xx_prep_ms_fdmi_iocb(s
 extern int qla2x00_fdmi_register(scsi_qla_host_t *);
 extern int qla2x00_gfpn_id(scsi_qla_host_t *, sw_info_t *);
 extern int qla2x00_gpsc(scsi_qla_host_t *, sw_info_t *);
+extern void qla2x00_get_sym_node_name(scsi_qla_host_t *, uint8_t *);
 
 /*
  * Global Function Prototypes in qla_attr.c source file.
diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index 029953c..225cf72 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -612,6 +612,14 @@ qla2x00_rnn_id(scsi_qla_host_t *ha)
 	return (rval);
 }
 
+void
+qla2x00_get_sym_node_name(scsi_qla_host_t *ha, uint8_t *snn)
+{
+	sprintf(snn, "%s FW:v%d.%02d.%02d DVR:v%s",ha->model_number,
+	    ha->fw_major_version, ha->fw_minor_version,
+	    ha->fw_subminor_version, qla2x00_version_str);
+}
+
 /**
  * qla2x00_rsnn_nn() - SNS Register Symbolic Node Name (RSNN_NN) of the HBA.
  * @ha: HA context
@@ -622,9 +630,6 @@ int
 qla2x00_rsnn_nn(scsi_qla_host_t *ha)
 {
 	int		rval;
-	uint8_t		*snn;
-	uint8_t		version[20];
-
 	ms_iocb_entry_t	*ms_pkt;
 	struct ct_sns_req	*ct_req;
 	struct ct_sns_rsp	*ct_rsp;
@@ -649,20 +654,11 @@ qla2x00_rsnn_nn(scsi_qla_host_t *ha)
 	memcpy(ct_req->req.rsnn_nn.node_name, ha->node_name, WWN_SIZE);
 
 	/* Prepare the Symbolic Node Name */
-	/* Board type */
-	snn = ct_req->req.rsnn_nn.sym_node_name;
-	strcpy(snn, ha->model_number);
-	/* Firmware version */
-	strcat(snn, " FW:v");
-	sprintf(version, "%d.%02d.%02d", ha->fw_major_version,
-	    ha->fw_minor_version, ha->fw_subminor_version);
-	strcat(snn, version);
-	/* Driver version */
-	strcat(snn, " DVR:v");
-	strcat(snn, qla2x00_version_str);
+	qla2x00_get_sym_node_name(ha, ct_req->req.rsnn_nn.sym_node_name);
 
 	/* Calculate SNN length */
-	ct_req->req.rsnn_nn.name_len = (uint8_t)strlen(snn);
+	ct_req->req.rsnn_nn.name_len =
+	    (uint8_t)strlen(ct_req->req.rsnn_nn.sym_node_name);
 
 	/* Update MS IOCB request */
 	ms_pkt->req_bytecount =
-- 
1.4.2.3.gf59615


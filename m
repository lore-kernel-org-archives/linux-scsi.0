From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [RFC 2/2] qla2xxx: Add name and management server queries to fill
 in new fc_rport attributes.
Date: Thu, 28 Oct 2010 12:17:03 -0400
Message-ID: <alpine.LFD.2.00.1010281216021.2885@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="US-ASCII"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexcashub1.qlogic.com ([198.70.193.61]:17644 "EHLO
	avexcashub1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753683Ab0J1QRG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Oct 2010 12:17:06 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This patch adds in the name server and mangement server queries to the qla2xxx
driver to get the needed information from the fabric to fill in the new
fc_rport attributes exported for HBAAPI v2 user space libraries:

Get Port Type (GPT)
Get FC-4 Types (GFT_ID)
Get Symbolic Port Name (GSPN)
Get Fabric Name (GFN)

If the name server or management server query succeeds then the fc_rport
attribute is assigned before fc_remote_port_rolechng() is called.  Otherwise,
the default fc_rport attribute is left alone.
---
  drivers/scsi/qla2xxx/qla_def.h  |   67 +++++++++++
  drivers/scsi/qla2xxx/qla_gbl.h  |    4 +
  drivers/scsi/qla2xxx/qla_gs.c   |  241 +++++++++++++++++++++++++++++++++++++++
  drivers/scsi/qla2xxx/qla_init.c |   38 ++++++-
  4 files changed, 349 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 6168628..79f1d4a 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -1658,6 +1658,7 @@ typedef struct {
  	uint8_t fabric_port_name[WWN_SIZE];
  	uint16_t fp_speed;
  	uint8_t fc4_type;
+	uint32_t supported_speeds;
  } sw_info_t;

  /* FCP-4 types */
@@ -1707,6 +1708,15 @@ typedef struct fc_port {

  	uint16_t vp_idx;
  	uint8_t fc4_type;
+
+	/* Additional HBAAPI information */
+	u8  supported_fc4s[FC_FC4_LIST_SIZE];
+	u32 supported_speeds;
+	enum fc_port_type rport_type; /* Stores HBAAPI port_type */
+	u32 speed;
+	u8  active_fc4s[FC_FC4_LIST_SIZE];
+	char symbolic_name[FC_SYMBOLIC_NAME_SIZE];
+	uint8_t fabric_name[8];
  } fc_port_t;

  /*
@@ -1793,6 +1803,30 @@ typedef struct fc_port {
  #define GFF_ID_REQ_SIZE	(16 + 4)
  #define GFF_ID_RSP_SIZE (16 + 128)

+#define GSPN_SYM_NAME_SIZE	255
+#define GSPN_ID_CMD		0x0118
+#define GSPN_ID_REQ_SIZE	(16 + 4)
+#define GSPN_ID_RSP_SIZE	(16 + 1 + GSPN_SYM_NAME_SIZE)
+
+#define GFN_CMD		0x0114
+#define GFN_REQ_SIZE	(16 + 8)
+#define GFN_RSP_SIZE	(16 + 8)
+
+/* Possible port types reported by GPT_ID */
+#define GPT_PT_UNIDENTIFIED	0x00
+#define GPT_PT_N_PORT		0x01
+#define GPT_PT_NL_PORT		0x02
+#define GPT_PT_F_NL_PORT	0x03
+#define GPT_PT_NX_PORT		0x7F
+#define GPT_PT_F_PORT		0x81
+#define GPT_PT_FL_PORT		0x82
+#define GPT_PT_E_PORT		0x84
+#define GPT_PT_B_PORT		0x85
+
+#define GPT_ID_CMD	0x011A
+#define GPT_ID_REQ_SIZE	(16 + 1 + 3)
+#define GPT_ID_RSP_SIZE	(16 + 1 + 3)
+
  /*
   * HBA attribute types.
   */
@@ -1998,6 +2032,25 @@ struct ct_sns_req {
  			uint8_t reserved;
  			uint8_t port_name[3];
  		} gff_id;
+
+		struct {
+			uint8_t reserved;
+			uint8_t port_name[3];
+		} gspn_id;
+
+		struct {
+			uint8_t element_name[8];
+		} gfn;
+
+		struct {
+			uint8_t reserved;
+			uint8_t port_name[3];
+		} gft_id;
+
+		struct {
+			uint8_t reserved;
+			uint8_t port_name[3];
+		} gpt_id;
  	} req;
  };

@@ -2075,6 +2128,20 @@ struct ct_sns_rsp {
  		struct {
  			uint8_t fc4_features[128];
  		} gff_id;
+
+		struct {
+			uint8_t length;
+			uint8_t symbolic_name[GSPN_SYM_NAME_SIZE];
+		} gspn_id;
+
+		struct {
+			uint8_t fabric_name[8];
+		} gfn;
+
+		struct {
+			uint8_t port_type;
+			uint8_t reserved[3];
+		} gpt_id;
  	} rsp;
  };

diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 1370f05..01cf0a4 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -457,6 +457,10 @@ extern int qla2x00_fdmi_register(scsi_qla_host_t *);
  extern int qla2x00_gfpn_id(scsi_qla_host_t *, sw_info_t *);
  extern int qla2x00_gpsc(scsi_qla_host_t *, sw_info_t *);
  extern void qla2x00_get_sym_node_name(scsi_qla_host_t *, uint8_t *);
+extern int qla2x00_gspn_id(scsi_qla_host_t *, fc_port_t *);
+extern int qla2x00_gfn(scsi_qla_host_t *, fc_port_t *);
+extern int qla2x00_gft_id(scsi_qla_host_t *, fc_port_t *);
+extern int qla2x00_gpt_id(scsi_qla_host_t *, fc_port_t *);

  /*
   * Global Function Prototypes in qla_attr.c source file.
diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index 4c08392..14f54ee 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -1891,6 +1891,10 @@ qla2x00_gpsc(scsi_qla_host_t *vha, sw_info_t *list)
  				break;
  			}

+			/* Save the supported speeds bit mask */
+			list[i].supported_speeds =
+				be16_to_cpu(ct_rsp->rsp.gpsc.speeds);
+
  			DEBUG2_3(printk("scsi(%ld): GPSC ext entry - "
  			    "fpn %02x%02x%02x%02x%02x%02x%02x%02x speeds=%04x "
  			    "speed=%04x.\n", vha->host_no,
@@ -1985,3 +1989,240 @@ qla2x00_gff_id(scsi_qla_host_t *vha, sw_info_t *list)
  			break;
  	}
  }
+
+
+/* SNS Get Symbolic Port Name (GSPN_ID) query */
+int
+qla2x00_gspn_id(scsi_qla_host_t *vha, fc_port_t *fcport)
+{
+	int             rval;
+	ms_iocb_entry_t *ms_pkt;
+	struct ct_sns_req       *ct_req;
+	struct ct_sns_rsp       *ct_rsp;
+	struct qla_hw_data *ha = vha->hw;
+
+	/* Prepare common MS IOCB */
+	ms_pkt = ha->isp_ops->prep_ms_iocb(vha, GSPN_ID_REQ_SIZE,
+	    GSPN_ID_RSP_SIZE);
+
+	/* Prepare CT request */
+	ct_req = qla2x00_prep_ct_req(&ha->ct_sns->p.req, GSPN_ID_CMD,
+	    GSPN_ID_RSP_SIZE);
+	ct_rsp = &ha->ct_sns->p.rsp;
+
+	/* Prepare CT arguments -- port_id */
+	ct_req->req.port_id.port_id[0] = fcport->d_id.b.domain;
+	ct_req->req.port_id.port_id[1] = fcport->d_id.b.area;
+	ct_req->req.port_id.port_id[2] = fcport->d_id.b.al_pa;
+
+	/* Execute MS IOCB */
+	rval = qla2x00_issue_iocb(vha, ha->ms_iocb, ha->ms_iocb_dma,
+	    sizeof(ms_iocb_entry_t));
+
+	if (rval != QLA_SUCCESS) {
+		DEBUG2_3(printk(KERN_INFO
+		    "scsi(%ld): GSPN_ID issue IOCB failed "
+		    "(%d).\n", vha->host_no, rval));
+	} else if (qla2x00_chk_ms_status(vha, ms_pkt, ct_rsp,
+		       "GSPN_ID") != QLA_SUCCESS) {
+		DEBUG2_3(printk(KERN_INFO
+		    "scsi(%ld): GSPN_ID IOCB status had a "
+		    "failure status code\n", vha->host_no));
+		rval = QLA_FUNCTION_FAILED;
+	} else {
+		/* Copy the symbolic port name data */
+		if (ct_rsp->rsp.gspn_id.length <= GSPN_SYM_NAME_SIZE) {
+			memcpy(fcport->symbolic_name,
+			    ct_rsp->rsp.gspn_id.symbolic_name,
+			    ct_rsp->rsp.gspn_id.length);
+		}
+	}
+
+	return rval;
+}
+
+/* Management Server Get Interconnect Element Fabric Name (GFN) query */
+int
+qla2x00_gfn(scsi_qla_host_t *vha, fc_port_t *fcport)
+{
+	int		rval;
+	struct qla_hw_data *ha = vha->hw;
+	ms_iocb_entry_t	*ms_pkt;
+	struct ct_sns_req	*ct_req;
+	struct ct_sns_rsp	*ct_rsp;
+
+	if (!IS_FWI2_CAPABLE(ha))
+		return QLA_FUNCTION_FAILED;
+
+	/* Login into the management server on the switch.  This can be called
+	 * even ifwe are logged into the management server as the function
+	 * simply returns QLA_SUCCESS if we are already logged in */
+	rval = qla2x00_mgmt_svr_login(vha);
+	if (rval)
+		return rval;
+
+	/* Prepare common MS IOCB */
+	ms_pkt = qla24xx_prep_ms_fm_iocb(vha, GFN_REQ_SIZE, GFN_RSP_SIZE);
+
+	/* Prepare CT request */
+	ct_req = qla24xx_prep_ct_fm_req(&ha->ct_sns->p.req, GFN_CMD,
+	    GFN_RSP_SIZE);
+	ct_rsp = &ha->ct_sns->p.rsp;
+
+	/* Prepare CT arguments */
+	memcpy(ct_req->req.gfn.element_name, fcport->fabric_port_name,
+	     WWN_SIZE);
+
+	/* Execute MS IOCB */
+	rval = qla2x00_issue_iocb(vha, ha->ms_iocb, ha->ms_iocb_dma,
+	    sizeof(ms_iocb_entry_t));
+
+	/* Check the return status of the IOCB and the management server
+	 * command. If both are good then parse the response data */
+	if (rval != QLA_SUCCESS) {
+		DEBUG2_3(printk("scsi(%ld): GFN issue IOCB "
+		    "failed (%d).\n", vha->host_no, rval));
+	} else if (qla2x00_chk_ms_status(vha, ms_pkt, ct_rsp,
+	    "GFN") != QLA_SUCCESS) {
+		/* FM command unsupported? */
+		if (rval == QLA_INVALID_COMMAND &&
+		    (ct_rsp->header.reason_code ==
+		    CT_REASON_INVALID_COMMAND_CODE ||
+		    ct_rsp->header.reason_code ==
+		    CT_REASON_COMMAND_UNSUPPORTED)) {
+			DEBUG2(printk("scsi(%ld): GFN command "
+			    "unsupportedy...\n",
+			    vha->host_no));
+		}
+		rval = QLA_FUNCTION_FAILED;
+	} else {
+		memcpy(fcport->fabric_name, ct_rsp->rsp.gfn.fabric_name,
+		    WWN_SIZE);
+	}
+
+	return rval;
+}
+
+/* SNS Get FC-4 Types (GFT_ID) query */
+int
+qla2x00_gft_id(scsi_qla_host_t *vha, fc_port_t *fcport)
+{
+	int rval;
+	int i = 0;
+	ms_iocb_entry_t *ms_pkt;
+	struct ct_sns_req *ct_req;
+	struct ct_sns_rsp *ct_rsp;
+	struct qla_hw_data *ha = vha->hw;
+
+	/* Prepare common MS IOCB */
+	ms_pkt = ha->isp_ops->prep_ms_iocb(vha, GFT_ID_REQ_SIZE,
+	    GFT_ID_RSP_SIZE);
+
+	/* Prepare CT request */
+	ct_req = qla2x00_prep_ct_req(&ha->ct_sns->p.req, GFT_ID_CMD,
+	    GFT_ID_RSP_SIZE);
+	ct_rsp = &ha->ct_sns->p.rsp;
+
+	/* Prepare CT arguments -- port_id */
+	ct_req->req.port_id.port_id[0] = fcport->d_id.b.domain;
+	ct_req->req.port_id.port_id[1] = fcport->d_id.b.area;
+	ct_req->req.port_id.port_id[2] = fcport->d_id.b.al_pa;
+
+	/* Execute MS IOCB */
+	rval = qla2x00_issue_iocb(vha, ha->ms_iocb, ha->ms_iocb_dma,
+	    sizeof(ms_iocb_entry_t));
+
+	if (rval != QLA_SUCCESS) {
+		DEBUG2_3(printk(KERN_INFO
+		    "scsi(%ld): GFT_ID issue IOCB failed "
+		    "(%d).\n", vha->host_no, rval));
+	} else if (qla2x00_chk_ms_status(vha, ms_pkt,
+	    ct_rsp, "GFT_ID") != QLA_SUCCESS) {
+		DEBUG2_3(printk(KERN_INFO
+		    "scsi(%ld): GFT_ID IOCB status had a "
+		    "failure status code\n", vha->host_no));
+		rval = QLA_FUNCTION_FAILED;
+	} else {
+		DEBUG2_3(
+			for (i = 0; i < 32; i++) {
+				printk(KERN_INFO "scsi(%ld): GFT_ID "
+				    "fc4_types[%d]=%d\n", vha->host_no, i,
+				    ct_rsp->rsp.gft_id.fc4_types[i]);
+			}
+		);
+
+		memcpy(fcport->supported_fc4s, ct_rsp->rsp.gft_id.fc4_types,
+		    sizeof(fcport->supported_fc4s));
+	}
+
+	return rval;
+}
+
+/* SNS Get Port Type (GPT_ID) query */
+int
+qla2x00_gpt_id(scsi_qla_host_t *vha, fc_port_t *fcport)
+{
+	int rval;
+	ms_iocb_entry_t *ms_pkt;
+	struct ct_sns_req *ct_req;
+	struct ct_sns_rsp *ct_rsp;
+	struct qla_hw_data *ha = vha->hw;
+
+	/* Prepare common MS IOCB */
+	ms_pkt = ha->isp_ops->prep_ms_iocb(vha, GPT_ID_REQ_SIZE,
+	    GPT_ID_RSP_SIZE);
+
+	/* Prepare CT request */
+	ct_req = qla2x00_prep_ct_req(&ha->ct_sns->p.req, GFT_ID_CMD,
+	    GFT_ID_RSP_SIZE);
+	ct_rsp = &ha->ct_sns->p.rsp;
+
+	/* Prepare CT arguments -- port_id */
+	ct_req->req.port_id.port_id[0] = fcport->d_id.b.domain;
+	ct_req->req.port_id.port_id[1] = fcport->d_id.b.area;
+	ct_req->req.port_id.port_id[2] = fcport->d_id.b.al_pa;
+
+	/* Execute MS IOCB */
+	rval = qla2x00_issue_iocb(vha, ha->ms_iocb, ha->ms_iocb_dma,
+	    sizeof(ms_iocb_entry_t));
+
+	if (rval != QLA_SUCCESS) {
+		DEBUG2_3(printk(KERN_INFO
+		    "scsi(%ld): GPT_ID issue IOCB failed "
+		    "(%d).\n", vha->host_no, rval));
+	} else if (qla2x00_chk_ms_status(vha, ms_pkt, ct_rsp,
+	    "GPT_ID") != QLA_SUCCESS) {
+		DEBUG2_3(printk(KERN_INFO
+		    "scsi(%ld): GPT_ID IOCB status had a "
+		    "failure status code\n", vha->host_no));
+		rval = QLA_FUNCTION_FAILED;
+	} else {
+		DEBUG2_3(printk(KERN_INFO
+		    "scsi(%ld): GPT_ID "
+		    "port_type=x%02x\n", vha->host_no,
+		    ct_rsp->rsp.gpt_id.port_type));
+
+		switch (ct_rsp->rsp.gpt_id.port_type) {
+		case GPT_PT_N_PORT:
+		case GPT_PT_NX_PORT:
+			fcport->rport_type = FC_PORTTYPE_NPORT;
+			break;
+		case GPT_PT_NL_PORT:
+			fcport->rport_type = FC_PORTTYPE_NLPORT;
+			break;
+		case GPT_PT_F_NL_PORT:
+		case GPT_PT_F_PORT:
+		case GPT_PT_FL_PORT:
+		case GPT_PT_E_PORT:
+		case GPT_PT_B_PORT:
+			fcport->rport_type = FC_PORTTYPE_OTHER;
+			break;
+		case GPT_PT_UNIDENTIFIED:
+		default:
+			fcport->rport_type = FC_PORTTYPE_UNKNOWN;
+			break;
+		}
+	}
+
+	return rval;
+}
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index e9b800e..6094ce6 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -2535,6 +2535,13 @@ qla2x00_alloc_fcport(scsi_qla_host_t *vha, gfp_t flags)
  	fcport->loop_id = FC_NO_LOOP_ID;
  	atomic_set(&fcport->state, FCS_UNCONFIGURED);
  	fcport->supported_classes = FC_COS_UNSPECIFIED;
+	memset(fcport->supported_fc4s, 0, sizeof(fcport->supported_fc4s));
+	fcport->supported_speeds = FC_PORTSPEED_UNKNOWN;
+	fcport->rport_type = FC_PORTTYPE_UNKNOWN;
+	fcport->speed = FC_PORTSPEED_UNKNOWN;
+	memset(fcport->active_fc4s, 0, sizeof(fcport->active_fc4s));
+	memset(fcport->symbolic_name, 0, sizeof(fcport->symbolic_name));
+	memset(fcport->fabric_name, 0, sizeof(fcport->fabric_name));

  	return fcport;
  }
@@ -2872,6 +2879,33 @@ qla2x00_iidma_fcport(scsi_qla_host_t *vha, fc_port_t *fcport)
  }

  static void
+qla2x00_update_rport_attrs(scsi_qla_host_t *vha, fc_port_t *fcport,
+	struct fc_rport *rport)
+{
+	rport->supported_classes = fcport->supported_classes;
+	rport->maxframe_size = vha->hw->init_cb->frame_payload_size;
+	rport->supported_speeds = fcport->supported_speeds;
+	rport->speed = fcport->speed;
+
+	qla2x00_gft_id(vha, fcport);
+	memcpy(rport->supported_fc4s, fcport->supported_fc4s,
+	    sizeof(rport->supported_fc4s));
+	/* For now just use the information from gft_id for active_fc4s */
+	memcpy(rport->active_fc4s, fcport->supported_fc4s,
+	    sizeof(rport->active_fc4s));
+
+	qla2x00_gpt_id(vha, fcport);
+	rport->port_type = fcport->rport_type;
+
+	qla2x00_gspn_id(vha, fcport);
+	memcpy(rport->symbolic_name, fcport->symbolic_name,
+	    sizeof(rport->symbolic_name));
+
+	qla2x00_gfn(vha, fcport);
+	memcpy(&rport->fabric_name, fcport->fabric_name, 8);
+}
+
+static void
  qla2x00_reg_remote_port(scsi_qla_host_t *vha, fc_port_t *fcport)
  {
  	struct fc_rport_identifiers rport_ids;
@@ -2895,7 +2929,7 @@ qla2x00_reg_remote_port(scsi_qla_host_t *vha, fc_port_t *fcport)
  	*((fc_port_t **)rport->dd_data) = fcport;
  	spin_unlock_irq(fcport->vha->host->host_lock);

-	rport->supported_classes = fcport->supported_classes;
+	qla2x00_update_rport_attrs(vha, fcport, rport);

  	rport_ids.roles = FC_RPORT_ROLE_UNKNOWN;
  	if (fcport->port_type == FCT_INITIATOR)
@@ -3224,6 +3258,8 @@ qla2x00_find_all_fabric_devs(scsi_qla_host_t *vha,
  				    swl[swl_idx].fabric_port_name, WWN_SIZE);
  				new_fcport->fp_speed = swl[swl_idx].fp_speed;
  				new_fcport->fc4_type = swl[swl_idx].fc4_type;
+				new_fcport->supported_speeds =
+				    swl[swl_idx].supported_speeds;

  				if (swl[swl_idx].d_id.b.rsvd_1 != 0) {
  					last_dev = 1;
-- 
1.6.4.2

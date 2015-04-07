From: James Smart <james.smart@emulex.com>
Subject: [PATCH v3 11/20] lpfc: Fix FDMI Fabric support in driver for
 Brocade
Date: Tue, 7 Apr 2015 15:07:19 -0400
Message-ID: <55242ae7.yT3RMvmx/SoLpiEC%james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.emulex.com ([138.239.224.99]:33630 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753502AbbDGTIV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Apr 2015 15:08:21 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Fix FDMI Fabric support in driver for Brocade

Signed-off-by: Dick Kennedy <dick.kennedy@emulex.com>
Signed-off-by: James Smart <james.smart@emulex.com>
---
 drivers/scsi/lpfc/lpfc.h         |   3 +
 drivers/scsi/lpfc/lpfc_attr.c    |  16 +-
 drivers/scsi/lpfc/lpfc_ct.c      | 715 +++++++++++++++++++++++++++++----------
 drivers/scsi/lpfc/lpfc_els.c     |   2 +-
 drivers/scsi/lpfc/lpfc_hbadisc.c |   6 +-
 drivers/scsi/lpfc/lpfc_hw.h      | 206 ++++++-----
 6 files changed, 650 insertions(+), 298 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index 434e903..922e59d 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -413,6 +413,9 @@ struct lpfc_vport {
 	uint32_t cfg_fcp_class;
 	uint32_t cfg_use_adisc;
 	uint32_t cfg_fdmi_on;
+#define LPFC_FDMI_SUPPORT	1	/* bit 0 - FDMI supported? */
+#define LPFC_FDMI_REG_DELAY	2	/* bit 1 - 60 sec registration delay */
+#define LPFC_FDMI_ALL_ATTRIB	4	/* bit 2 - register ALL attributes? */
 	uint32_t cfg_discovery_threads;
 	uint32_t cfg_log_verbose;
 	uint32_t cfg_max_luns;
diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index 374aa03..faf0e8c 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -4573,12 +4573,18 @@ LPFC_ATTR_R(multi_ring_type, FC_TYPE_IP, 1,
 
 /*
 # lpfc_fdmi_on: controls FDMI support.
-#       0 = no FDMI support
-#       1 = support FDMI without attribute of hostname
-#       2 = support FDMI with attribute of hostname
-# Value range [0,2]. Default value is 0.
+#               Set                NOT Set
+#       bit 0 = FDMI support       no FDMI support
+#           LPFC_FDMI_SUPPORT just turns basic support on/off
+#       bit 1 = Register delay     no register delay  (60 seconds)
+#           LPFC_FDMI_REG_DELAY	60 sec registration delay after FDMI login
+#       bit 2 = All attributes     Use a attribute subset
+#           LPFC_FDMI_ALL_ATTRIB applies to both port and HBA attributes
+#           Port attrutes subset: 1 thru 6 OR all: 1 thru 0xd 0x101 0x102 0x103
+#           HBA attributes subset: 1 thru 0xb OR all: 1 thru 0xc
+# Value range [0,7]. Default value is 0.
 */
-LPFC_VPORT_ATTR_RW(fdmi_on, 0, 0, 2, "Enable FDMI support");
+LPFC_VPORT_ATTR_RW(fdmi_on, 0, 0, 7, "Enable FDMI support");
 
 /*
 # Specifies the maximum number of ELS cmds we can have outstanding (for
diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
index 5fb431a..593c027 100644
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -555,7 +555,7 @@ lpfc_ns_rsp(struct lpfc_vport *vport, struct lpfc_dmabuf *mp, uint32_t Size)
 					}
 				}
 			}
-			if (CTentry & (be32_to_cpu(SLI_CT_LAST_ENTRY)))
+			if (CTentry & (cpu_to_be32(SLI_CT_LAST_ENTRY)))
 				goto nsout1;
 			Cnt -= sizeof (uint32_t);
 		}
@@ -641,7 +641,7 @@ lpfc_cmpl_ct_cmd_gid_ft(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		/* Good status, continue checking */
 		CTrsp = (struct lpfc_sli_ct_request *) outp->virt;
 		if (CTrsp->CommandResponse.bits.CmdRsp ==
-		    be16_to_cpu(SLI_CT_RESPONSE_FS_ACC)) {
+		    cpu_to_be16(SLI_CT_RESPONSE_FS_ACC)) {
 			lpfc_printf_vlog(vport, KERN_INFO, LOG_DISCOVERY,
 					 "0208 NameServer Rsp Data: x%x\n",
 					 vport->fc_flag);
@@ -1096,6 +1096,26 @@ lpfc_vport_symbolic_node_name(struct lpfc_vport *vport, char *symbol,
 	return n;
 }
 
+static uint32_t
+lpfc_find_map_node(struct lpfc_vport *vport)
+{
+	struct lpfc_nodelist *ndlp, *next_ndlp;
+	struct Scsi_Host  *shost;
+	uint32_t cnt = 0;
+
+	shost = lpfc_shost_from_vport(vport);
+	spin_lock_irq(shost->host_lock);
+	list_for_each_entry_safe(ndlp, next_ndlp, &vport->fc_nodes, nlp_listp) {
+		if (ndlp->nlp_type & NLP_FABRIC)
+			continue;
+		if ((ndlp->nlp_state == NLP_STE_MAPPED_NODE) ||
+		    (ndlp->nlp_state == NLP_STE_UNMAPPED_NODE))
+			cnt++;
+	}
+	spin_unlock_irq(shost->host_lock);
+	return cnt;
+}
+
 /*
  * lpfc_ns_cmd
  * Description:
@@ -1194,7 +1214,7 @@ lpfc_ns_cmd(struct lpfc_vport *vport, int cmdcode,
 	switch (cmdcode) {
 	case SLI_CTNS_GID_FT:
 		CtReq->CommandResponse.bits.CmdRsp =
-		    be16_to_cpu(SLI_CTNS_GID_FT);
+		    cpu_to_be16(SLI_CTNS_GID_FT);
 		CtReq->un.gid.Fc4Type = SLI_CTPT_FCP;
 		if (vport->port_state < LPFC_NS_QRY)
 			vport->port_state = LPFC_NS_QRY;
@@ -1205,7 +1225,7 @@ lpfc_ns_cmd(struct lpfc_vport *vport, int cmdcode,
 
 	case SLI_CTNS_GFF_ID:
 		CtReq->CommandResponse.bits.CmdRsp =
-			be16_to_cpu(SLI_CTNS_GFF_ID);
+			cpu_to_be16(SLI_CTNS_GFF_ID);
 		CtReq->un.gff.PortId = cpu_to_be32(context);
 		cmpl = lpfc_cmpl_ct_cmd_gff_id;
 		break;
@@ -1213,7 +1233,7 @@ lpfc_ns_cmd(struct lpfc_vport *vport, int cmdcode,
 	case SLI_CTNS_RFT_ID:
 		vport->ct_flags &= ~FC_CT_RFT_ID;
 		CtReq->CommandResponse.bits.CmdRsp =
-		    be16_to_cpu(SLI_CTNS_RFT_ID);
+		    cpu_to_be16(SLI_CTNS_RFT_ID);
 		CtReq->un.rft.PortId = cpu_to_be32(vport->fc_myDID);
 		CtReq->un.rft.fcpReg = 1;
 		cmpl = lpfc_cmpl_ct_cmd_rft_id;
@@ -1222,7 +1242,7 @@ lpfc_ns_cmd(struct lpfc_vport *vport, int cmdcode,
 	case SLI_CTNS_RNN_ID:
 		vport->ct_flags &= ~FC_CT_RNN_ID;
 		CtReq->CommandResponse.bits.CmdRsp =
-		    be16_to_cpu(SLI_CTNS_RNN_ID);
+		    cpu_to_be16(SLI_CTNS_RNN_ID);
 		CtReq->un.rnn.PortId = cpu_to_be32(vport->fc_myDID);
 		memcpy(CtReq->un.rnn.wwnn,  &vport->fc_nodename,
 		       sizeof (struct lpfc_name));
@@ -1232,7 +1252,7 @@ lpfc_ns_cmd(struct lpfc_vport *vport, int cmdcode,
 	case SLI_CTNS_RSPN_ID:
 		vport->ct_flags &= ~FC_CT_RSPN_ID;
 		CtReq->CommandResponse.bits.CmdRsp =
-		    be16_to_cpu(SLI_CTNS_RSPN_ID);
+		    cpu_to_be16(SLI_CTNS_RSPN_ID);
 		CtReq->un.rspn.PortId = cpu_to_be32(vport->fc_myDID);
 		size = sizeof(CtReq->un.rspn.symbname);
 		CtReq->un.rspn.len =
@@ -1243,7 +1263,7 @@ lpfc_ns_cmd(struct lpfc_vport *vport, int cmdcode,
 	case SLI_CTNS_RSNN_NN:
 		vport->ct_flags &= ~FC_CT_RSNN_NN;
 		CtReq->CommandResponse.bits.CmdRsp =
-		    be16_to_cpu(SLI_CTNS_RSNN_NN);
+		    cpu_to_be16(SLI_CTNS_RSNN_NN);
 		memcpy(CtReq->un.rsnn.wwnn, &vport->fc_nodename,
 		       sizeof (struct lpfc_name));
 		size = sizeof(CtReq->un.rsnn.symbname);
@@ -1255,14 +1275,14 @@ lpfc_ns_cmd(struct lpfc_vport *vport, int cmdcode,
 	case SLI_CTNS_DA_ID:
 		/* Implement DA_ID Nameserver request */
 		CtReq->CommandResponse.bits.CmdRsp =
-			be16_to_cpu(SLI_CTNS_DA_ID);
+			cpu_to_be16(SLI_CTNS_DA_ID);
 		CtReq->un.da_id.port_id = cpu_to_be32(vport->fc_myDID);
 		cmpl = lpfc_cmpl_ct_cmd_da_id;
 		break;
 	case SLI_CTNS_RFF_ID:
 		vport->ct_flags &= ~FC_CT_RFF_ID;
 		CtReq->CommandResponse.bits.CmdRsp =
-		    be16_to_cpu(SLI_CTNS_RFF_ID);
+		    cpu_to_be16(SLI_CTNS_RFF_ID);
 		CtReq->un.rff.PortId = cpu_to_be32(vport->fc_myDID);
 		CtReq->un.rff.fbits = FC4_FEATURE_INIT;
 		CtReq->un.rff.type_code = FC_TYPE_FCP;
@@ -1316,7 +1336,6 @@ lpfc_cmpl_ct_cmd_fdmi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	uint32_t latt;
 
 	latt = lpfc_els_chk_latt(vport);
-
 	lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_CT,
 		"FDMI cmpl:       status:x%x/x%x latt:%d",
 		irsp->ulpStatus, irsp->un.ulpWord[4], latt);
@@ -1327,29 +1346,49 @@ lpfc_cmpl_ct_cmd_fdmi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 				 "ulpStatus: x%x, rid x%x\n",
 				 be16_to_cpu(fdmi_cmd), latt, irsp->ulpStatus,
 				 irsp->un.ulpWord[4]);
-		lpfc_ct_free_iocb(phba, cmdiocb);
-		return;
+		goto fail_out;
 	}
 
 	ndlp = lpfc_findnode_did(vport, FDMI_DID);
 	if (!ndlp || !NLP_CHK_NODE_ACT(ndlp))
 		goto fail_out;
 
-	if (fdmi_rsp == be16_to_cpu(SLI_CT_RESPONSE_FS_RJT)) {
+	if (fdmi_rsp == cpu_to_be16(SLI_CT_RESPONSE_FS_RJT)) {
 		/* FDMI rsp failed */
 		lpfc_printf_vlog(vport, KERN_INFO, LOG_DISCOVERY,
 				 "0220 FDMI rsp failed Data: x%x\n",
 				 be16_to_cpu(fdmi_cmd));
 	}
 
+fail_out:
+	lpfc_ct_free_iocb(phba, cmdiocb);
+}
+
+static void
+lpfc_cmpl_ct_disc_fdmi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
+		       struct lpfc_iocbq *rspiocb)
+{
+	struct lpfc_vport *vport = cmdiocb->vport;
+	struct lpfc_dmabuf *inp = cmdiocb->context1;
+	struct lpfc_sli_ct_request *CTcmd = inp->virt;
+	uint16_t fdmi_cmd = CTcmd->CommandResponse.bits.CmdRsp;
+	struct lpfc_nodelist *ndlp;
+
+	lpfc_cmpl_ct_cmd_fdmi(phba, cmdiocb, rspiocb);
+
+	ndlp = lpfc_findnode_did(vport, FDMI_DID);
+	if (!ndlp || !NLP_CHK_NODE_ACT(ndlp))
+		return;
+
+	/*
+	 * Need to cycle thru FDMI registration for discovery
+	 * DHBA -> DPRT -> RHBA -> RPA
+	 */
 	switch (be16_to_cpu(fdmi_cmd)) {
 	case SLI_MGMT_RHBA:
 		lpfc_fdmi_cmd(vport, ndlp, SLI_MGMT_RPA);
 		break;
 
-	case SLI_MGMT_RPA:
-		break;
-
 	case SLI_MGMT_DHBA:
 		lpfc_fdmi_cmd(vport, ndlp, SLI_MGMT_DPRT);
 		break;
@@ -1358,12 +1397,9 @@ lpfc_cmpl_ct_cmd_fdmi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		lpfc_fdmi_cmd(vport, ndlp, SLI_MGMT_RHBA);
 		break;
 	}
-
-fail_out:
-	lpfc_ct_free_iocb(phba, cmdiocb);
-	return;
 }
 
+
 int
 lpfc_fdmi_cmd(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp, int cmdcode)
 {
@@ -1372,18 +1408,28 @@ lpfc_fdmi_cmd(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp, int cmdcode)
 	struct lpfc_sli_ct_request *CtReq;
 	struct ulp_bde64 *bpl;
 	uint32_t size;
-	REG_HBA *rh;
-	PORT_ENTRY *pe;
-	REG_PORT_ATTRIBUTE *pab;
-	ATTRIBUTE_BLOCK *ab;
-	ATTRIBUTE_ENTRY *ae;
+	uint32_t rsp_size;
+	struct lpfc_fdmi_reg_hba *rh;
+	struct lpfc_fdmi_port_entry *pe;
+	struct lpfc_fdmi_reg_portattr *pab = NULL;
+	struct lpfc_fdmi_attr_block *ab = NULL;
+	struct lpfc_fdmi_attr_entry *ae;
+	struct lpfc_fdmi_attr_def *ad;
 	void (*cmpl) (struct lpfc_hba *, struct lpfc_iocbq *,
 		      struct lpfc_iocbq *);
 
+	if (ndlp == NULL) {
+		ndlp = lpfc_findnode_did(vport, FDMI_DID);
+		if (!ndlp || !NLP_CHK_NODE_ACT(ndlp))
+			return 0;
+		cmpl = lpfc_cmpl_ct_cmd_fdmi; /* cmd interface */
+	} else {
+		cmpl = lpfc_cmpl_ct_disc_fdmi; /* called from discovery */
+	}
 
 	/* fill in BDEs for command */
 	/* Allocate buffer for command payload */
-	mp = kmalloc(sizeof (struct lpfc_dmabuf), GFP_KERNEL);
+	mp = kmalloc(sizeof(struct lpfc_dmabuf), GFP_KERNEL);
 	if (!mp)
 		goto fdmi_cmd_exit;
 
@@ -1392,7 +1438,7 @@ lpfc_fdmi_cmd(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp, int cmdcode)
 		goto fdmi_cmd_free_mp;
 
 	/* Allocate buffer for Buffer ptr list */
-	bmp = kmalloc(sizeof (struct lpfc_dmabuf), GFP_KERNEL);
+	bmp = kmalloc(sizeof(struct lpfc_dmabuf), GFP_KERNEL);
 	if (!bmp)
 		goto fdmi_cmd_free_mpvirt;
 
@@ -1407,205 +1453,330 @@ lpfc_fdmi_cmd(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp, int cmdcode)
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_DISCOVERY,
 			 "0218 FDMI Request Data: x%x x%x x%x\n",
 			 vport->fc_flag, vport->port_state, cmdcode);
-	CtReq = (struct lpfc_sli_ct_request *) mp->virt;
+	CtReq = (struct lpfc_sli_ct_request *)mp->virt;
 
+	/* First populate the CT_IU preamble */
 	memset(CtReq, 0, sizeof(struct lpfc_sli_ct_request));
 	CtReq->RevisionId.bits.Revision = SLI_CT_REVISION;
 	CtReq->RevisionId.bits.InId = 0;
 
 	CtReq->FsType = SLI_CT_MANAGEMENT_SERVICE;
 	CtReq->FsSubType = SLI_CT_FDMI_Subtypes;
+
+	CtReq->CommandResponse.bits.CmdRsp = cpu_to_be16(cmdcode);
+	rsp_size = LPFC_BPL_SIZE;
 	size = 0;
 
+	/* Next fill in the specific FDMI cmd information */
 	switch (cmdcode) {
+	case SLI_MGMT_RHAT:
 	case SLI_MGMT_RHBA:
 		{
 			lpfc_vpd_t *vp = &phba->vpd;
 			uint32_t i, j, incr;
-			int len;
+			int len = 0;
 
-			CtReq->CommandResponse.bits.CmdRsp =
-			    be16_to_cpu(SLI_MGMT_RHBA);
-			CtReq->CommandResponse.bits.Size = 0;
-			rh = (REG_HBA *) & CtReq->un.PortID;
+			rh = (struct lpfc_fdmi_reg_hba *)&CtReq->un.PortID;
+			/* HBA Identifier */
 			memcpy(&rh->hi.PortName, &vport->fc_sparam.portName,
-			       sizeof (struct lpfc_name));
-			/* One entry (port) per adapter */
-			rh->rpl.EntryCnt = be32_to_cpu(1);
-			memcpy(&rh->rpl.pe, &vport->fc_sparam.portName,
-			       sizeof (struct lpfc_name));
-
-			/* point to the HBA attribute block */
-			size = 2 * sizeof (struct lpfc_name) + FOURBYTES;
-			ab = (ATTRIBUTE_BLOCK *) ((uint8_t *) rh + size);
+			       sizeof(struct lpfc_name));
+
+			if (cmdcode == SLI_MGMT_RHBA) {
+				/* Registered Port List */
+				/* One entry (port) per adapter */
+				rh->rpl.EntryCnt = cpu_to_be32(1);
+				memcpy(&rh->rpl.pe, &vport->fc_sparam.portName,
+				       sizeof(struct lpfc_name));
+
+				/* point to the HBA attribute block */
+				size = 2 * sizeof(struct lpfc_name) +
+					FOURBYTES;
+			} else {
+				size = sizeof(struct lpfc_name);
+			}
+			ab = (struct lpfc_fdmi_attr_block *)
+				((uint8_t *)rh + size);
 			ab->EntryCnt = 0;
+			size += FOURBYTES;
 
-			/* Point to the beginning of the first HBA attribute
-			   entry */
+			/*
+			 * Point to beginning of first HBA attribute entry
+			 */
 			/* #1 HBA attribute entry */
-			size += FOURBYTES;
-			ae = (ATTRIBUTE_ENTRY *) ((uint8_t *) rh + size);
-			ae->ad.bits.AttrType = be16_to_cpu(NODE_NAME);
-			ae->ad.bits.AttrLen =  be16_to_cpu(FOURBYTES
-						+ sizeof (struct lpfc_name));
+			ad = (struct lpfc_fdmi_attr_def *)
+				((uint8_t *)rh + size);
+			ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
+			memset(ae, 0, sizeof(struct lpfc_name));
+			ad->AttrType = cpu_to_be16(RHBA_NODENAME);
+			ad->AttrLen =  cpu_to_be16(FOURBYTES
+						+ sizeof(struct lpfc_name));
 			memcpy(&ae->un.NodeName, &vport->fc_sparam.nodeName,
-			       sizeof (struct lpfc_name));
+			       sizeof(struct lpfc_name));
 			ab->EntryCnt++;
-			size += FOURBYTES + sizeof (struct lpfc_name);
+			size += FOURBYTES + sizeof(struct lpfc_name);
+			if ((size + LPFC_FDMI_MAX_AE_SIZE) >
+					(LPFC_BPL_SIZE - LPFC_CT_PREAMBLE))
+				goto hba_out;
 
 			/* #2 HBA attribute entry */
-			ae = (ATTRIBUTE_ENTRY *) ((uint8_t *) rh + size);
-			ae->ad.bits.AttrType = be16_to_cpu(MANUFACTURER);
-			strncpy(ae->un.Manufacturer, "Emulex Corporation", 64);
-			len = strlen(ae->un.Manufacturer);
+			ad = (struct lpfc_fdmi_attr_def *)
+				((uint8_t *)rh + size);
+			ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
+			memset(ae, 0, sizeof(ae->un.Manufacturer));
+			ad->AttrType = cpu_to_be16(RHBA_MANUFACTURER);
+			strncpy(ae->un.Manufacturer, "Emulex Corporation",
+				sizeof(ae->un.Manufacturer));
+			len = strnlen(ae->un.Manufacturer,
+					  sizeof(ae->un.Manufacturer));
 			len += (len & 3) ? (4 - (len & 3)) : 4;
-			ae->ad.bits.AttrLen = be16_to_cpu(FOURBYTES + len);
+			ad->AttrLen = cpu_to_be16(FOURBYTES + len);
 			ab->EntryCnt++;
 			size += FOURBYTES + len;
+			if ((size + LPFC_FDMI_MAX_AE_SIZE) >
+					(LPFC_BPL_SIZE - LPFC_CT_PREAMBLE))
+				goto hba_out;
 
 			/* #3 HBA attribute entry */
-			ae = (ATTRIBUTE_ENTRY *) ((uint8_t *) rh + size);
-			ae->ad.bits.AttrType = be16_to_cpu(SERIAL_NUMBER);
-			strncpy(ae->un.SerialNumber, phba->SerialNumber, 64);
-			len = strlen(ae->un.SerialNumber);
+			ad = (struct lpfc_fdmi_attr_def *)
+				((uint8_t *)rh + size);
+			ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
+			memset(ae, 0, sizeof(ae->un.SerialNumber));
+			ad->AttrType = cpu_to_be16(RHBA_SERIAL_NUMBER);
+			strncpy(ae->un.SerialNumber, phba->SerialNumber,
+				sizeof(ae->un.SerialNumber));
+			len = strnlen(ae->un.SerialNumber,
+					  sizeof(ae->un.SerialNumber));
 			len += (len & 3) ? (4 - (len & 3)) : 4;
-			ae->ad.bits.AttrLen = be16_to_cpu(FOURBYTES + len);
+			ad->AttrLen = cpu_to_be16(FOURBYTES + len);
 			ab->EntryCnt++;
 			size += FOURBYTES + len;
+			if ((size + LPFC_FDMI_MAX_AE_SIZE) >
+					(LPFC_BPL_SIZE - LPFC_CT_PREAMBLE))
+				goto hba_out;
 
 			/* #4 HBA attribute entry */
-			ae = (ATTRIBUTE_ENTRY *) ((uint8_t *) rh + size);
-			ae->ad.bits.AttrType = be16_to_cpu(MODEL);
-			strncpy(ae->un.Model, phba->ModelName, 256);
-			len = strlen(ae->un.Model);
+			ad = (struct lpfc_fdmi_attr_def *)
+				((uint8_t *)rh + size);
+			ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
+			memset(ae, 0, sizeof(ae->un.Model));
+			ad->AttrType = cpu_to_be16(RHBA_MODEL);
+			strncpy(ae->un.Model, phba->ModelName,
+				sizeof(ae->un.Model));
+			len = strnlen(ae->un.Model, sizeof(ae->un.Model));
 			len += (len & 3) ? (4 - (len & 3)) : 4;
-			ae->ad.bits.AttrLen = be16_to_cpu(FOURBYTES + len);
+			ad->AttrLen = cpu_to_be16(FOURBYTES + len);
 			ab->EntryCnt++;
 			size += FOURBYTES + len;
+			if ((size + LPFC_FDMI_MAX_AE_SIZE) >
+					(LPFC_BPL_SIZE - LPFC_CT_PREAMBLE))
+				goto hba_out;
 
 			/* #5 HBA attribute entry */
-			ae = (ATTRIBUTE_ENTRY *) ((uint8_t *) rh + size);
-			ae->ad.bits.AttrType = be16_to_cpu(MODEL_DESCRIPTION);
-			strncpy(ae->un.ModelDescription, phba->ModelDesc, 256);
-			len = strlen(ae->un.ModelDescription);
+			ad = (struct lpfc_fdmi_attr_def *)
+				((uint8_t *)rh + size);
+			ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
+			memset(ae, 0, sizeof(ae->un.ModelDescription));
+			ad->AttrType = cpu_to_be16(RHBA_MODEL_DESCRIPTION);
+			strncpy(ae->un.ModelDescription, phba->ModelDesc,
+				sizeof(ae->un.ModelDescription));
+			len = strnlen(ae->un.ModelDescription,
+					  sizeof(ae->un.ModelDescription));
 			len += (len & 3) ? (4 - (len & 3)) : 4;
-			ae->ad.bits.AttrLen = be16_to_cpu(FOURBYTES + len);
+			ad->AttrLen = cpu_to_be16(FOURBYTES + len);
 			ab->EntryCnt++;
 			size += FOURBYTES + len;
+			if ((size + 8) > (LPFC_BPL_SIZE - LPFC_CT_PREAMBLE))
+				goto hba_out;
 
 			/* #6 HBA attribute entry */
-			ae = (ATTRIBUTE_ENTRY *) ((uint8_t *) rh + size);
-			ae->ad.bits.AttrType = be16_to_cpu(HARDWARE_VERSION);
-			ae->ad.bits.AttrLen = be16_to_cpu(FOURBYTES + 8);
+			ad = (struct lpfc_fdmi_attr_def *)
+				((uint8_t *)rh + size);
+			ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
+			memset(ae, 0, 8);
+			ad->AttrType = cpu_to_be16(RHBA_HARDWARE_VERSION);
+			ad->AttrLen = cpu_to_be16(FOURBYTES + 8);
 			/* Convert JEDEC ID to ascii for hardware version */
 			incr = vp->rev.biuRev;
 			for (i = 0; i < 8; i++) {
 				j = (incr & 0xf);
 				if (j <= 9)
 					ae->un.HardwareVersion[7 - i] =
-					    (char)((uint8_t) 0x30 +
-						   (uint8_t) j);
+					    (char)((uint8_t)0x30 +
+						   (uint8_t)j);
 				else
 					ae->un.HardwareVersion[7 - i] =
-					    (char)((uint8_t) 0x61 +
-						   (uint8_t) (j - 10));
+					    (char)((uint8_t)0x61 +
+						   (uint8_t)(j - 10));
 				incr = (incr >> 4);
 			}
 			ab->EntryCnt++;
 			size += FOURBYTES + 8;
+			if ((size + LPFC_FDMI_MAX_AE_SIZE) >
+					(LPFC_BPL_SIZE - LPFC_CT_PREAMBLE))
+				goto hba_out;
 
 			/* #7 HBA attribute entry */
-			ae = (ATTRIBUTE_ENTRY *) ((uint8_t *) rh + size);
-			ae->ad.bits.AttrType = be16_to_cpu(DRIVER_VERSION);
-			strncpy(ae->un.DriverVersion,
-				lpfc_release_version, 256);
-			len = strlen(ae->un.DriverVersion);
+			ad = (struct lpfc_fdmi_attr_def *)
+				((uint8_t *)rh + size);
+			ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
+			memset(ae, 0, sizeof(ae->un.DriverVersion));
+			ad->AttrType = cpu_to_be16(RHBA_DRIVER_VERSION);
+			strncpy(ae->un.DriverVersion, lpfc_release_version,
+				sizeof(ae->un.DriverVersion));
+			len = strnlen(ae->un.DriverVersion,
+					sizeof(ae->un.DriverVersion));
 			len += (len & 3) ? (4 - (len & 3)) : 4;
-			ae->ad.bits.AttrLen = be16_to_cpu(FOURBYTES + len);
+			ad->AttrLen = cpu_to_be16(FOURBYTES + len);
 			ab->EntryCnt++;
 			size += FOURBYTES + len;
+			if ((size + LPFC_FDMI_MAX_AE_SIZE) >
+					(LPFC_BPL_SIZE - LPFC_CT_PREAMBLE))
+				goto hba_out;
 
 			/* #8 HBA attribute entry */
-			ae = (ATTRIBUTE_ENTRY *) ((uint8_t *) rh + size);
-			ae->ad.bits.AttrType = be16_to_cpu(OPTION_ROM_VERSION);
-			strncpy(ae->un.OptionROMVersion,
-				phba->OptionROMVersion, 256);
-			len = strlen(ae->un.OptionROMVersion);
+			ad = (struct lpfc_fdmi_attr_def *)
+				((uint8_t *)rh + size);
+			ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
+			memset(ae, 0, sizeof(ae->un.OptionROMVersion));
+			ad->AttrType = cpu_to_be16(RHBA_OPTION_ROM_VERSION);
+			strncpy(ae->un.OptionROMVersion, phba->OptionROMVersion,
+				sizeof(ae->un.OptionROMVersion));
+			len = strnlen(ae->un.OptionROMVersion,
+				      sizeof(ae->un.OptionROMVersion));
 			len += (len & 3) ? (4 - (len & 3)) : 4;
-			ae->ad.bits.AttrLen = be16_to_cpu(FOURBYTES + len);
+			ad->AttrLen = cpu_to_be16(FOURBYTES + len);
 			ab->EntryCnt++;
 			size += FOURBYTES + len;
+			if ((size + LPFC_FDMI_MAX_AE_SIZE) >
+					(LPFC_BPL_SIZE - LPFC_CT_PREAMBLE))
+				goto hba_out;
 
 			/* #9 HBA attribute entry */
-			ae = (ATTRIBUTE_ENTRY *) ((uint8_t *) rh + size);
-			ae->ad.bits.AttrType = be16_to_cpu(FIRMWARE_VERSION);
+			ad = (struct lpfc_fdmi_attr_def *)
+				((uint8_t *)rh + size);
+			ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
+			memset(ae, 0, sizeof(ae->un.FirmwareVersion));
+			ad->AttrType = cpu_to_be16(RHBA_FIRMWARE_VERSION);
 			lpfc_decode_firmware_rev(phba, ae->un.FirmwareVersion,
 				1);
-			len = strlen(ae->un.FirmwareVersion);
+			len = strnlen(ae->un.FirmwareVersion,
+					sizeof(ae->un.FirmwareVersion));
 			len += (len & 3) ? (4 - (len & 3)) : 4;
-			ae->ad.bits.AttrLen = be16_to_cpu(FOURBYTES + len);
+			ad->AttrLen = cpu_to_be16(FOURBYTES + len);
 			ab->EntryCnt++;
 			size += FOURBYTES + len;
+			if ((size + LPFC_FDMI_MAX_AE_SIZE) >
+					(LPFC_BPL_SIZE - LPFC_CT_PREAMBLE))
+				goto hba_out;
 
 			/* #10 HBA attribute entry */
-			ae = (ATTRIBUTE_ENTRY *) ((uint8_t *) rh + size);
-			ae->ad.bits.AttrType = be16_to_cpu(OS_NAME_VERSION);
-			sprintf(ae->un.OsNameVersion, "%s %s %s",
-				init_utsname()->sysname,
-				init_utsname()->release,
-				init_utsname()->version);
-			len = strlen(ae->un.OsNameVersion);
+			ad = (struct lpfc_fdmi_attr_def *)
+				((uint8_t *)rh + size);
+			ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
+			memset(ae, 0, sizeof(ae->un.OsNameVersion));
+			ad->AttrType = cpu_to_be16(RHBA_OS_NAME_VERSION);
+			snprintf(ae->un.OsNameVersion,
+				 sizeof(ae->un.OsNameVersion),
+				 "%s %s %s",
+				 init_utsname()->sysname,
+				 init_utsname()->release,
+				 init_utsname()->version);
+			len = strnlen(ae->un.OsNameVersion,
+				      sizeof(ae->un.OsNameVersion));
 			len += (len & 3) ? (4 - (len & 3)) : 4;
-			ae->ad.bits.AttrLen = be16_to_cpu(FOURBYTES + len);
+			ad->AttrLen = cpu_to_be16(FOURBYTES + len);
 			ab->EntryCnt++;
 			size += FOURBYTES + len;
+			if ((size + 4) > (LPFC_BPL_SIZE - LPFC_CT_PREAMBLE))
+				goto hba_out;
 
 			/* #11 HBA attribute entry */
-			ae = (ATTRIBUTE_ENTRY *) ((uint8_t *) rh + size);
-			ae->ad.bits.AttrType = be16_to_cpu(MAX_CT_PAYLOAD_LEN);
-			ae->ad.bits.AttrLen = be16_to_cpu(FOURBYTES + 4);
-			ae->un.MaxCTPayloadLen = (65 * 4096);
+			ad = (struct lpfc_fdmi_attr_def *)
+				((uint8_t *)rh + size);
+			ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
+			ad->AttrType =
+				cpu_to_be16(RHBA_MAX_CT_PAYLOAD_LEN);
+			ad->AttrLen = cpu_to_be16(FOURBYTES + 4);
+			ae->un.MaxCTPayloadLen = cpu_to_be32(LPFC_MAX_CT_SIZE);
 			ab->EntryCnt++;
 			size += FOURBYTES + 4;
+			if ((size + LPFC_FDMI_MAX_AE_SIZE) >
+					(LPFC_BPL_SIZE - LPFC_CT_PREAMBLE))
+				goto hba_out;
 
-			ab->EntryCnt = be32_to_cpu(ab->EntryCnt);
+			/*
+			 * Currently switches don't seem to support the
+			 * following extended HBA attributes.
+			 */
+			if (!(vport->cfg_fdmi_on & LPFC_FDMI_ALL_ATTRIB))
+				goto hba_out;
+
+			/* #12 HBA attribute entry */
+			ad = (struct lpfc_fdmi_attr_def *)
+				((uint8_t *)rh + size);
+			ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
+			memset(ae, 0, sizeof(ae->un.NodeSymName));
+			ad->AttrType = cpu_to_be16(RHBA_SYM_NODENAME);
+			len = lpfc_vport_symbolic_node_name(vport,
+				ae->un.NodeSymName, sizeof(ae->un.NodeSymName));
+			len += (len & 3) ? (4 - (len & 3)) : 4;
+			ad->AttrLen = cpu_to_be16(FOURBYTES + len);
+			ab->EntryCnt++;
+			size += FOURBYTES + len;
+hba_out:
+			ab->EntryCnt = cpu_to_be32(ab->EntryCnt);
 			/* Total size */
 			size = GID_REQUEST_SZ - 4 + size;
 		}
 		break;
 
+	case SLI_MGMT_RPRT:
 	case SLI_MGMT_RPA:
 		{
 			lpfc_vpd_t *vp;
 			struct serv_parm *hsp;
-			int len;
+			int len = 0;
 
 			vp = &phba->vpd;
 
-			CtReq->CommandResponse.bits.CmdRsp =
-			    be16_to_cpu(SLI_MGMT_RPA);
-			CtReq->CommandResponse.bits.Size = 0;
-			pab = (REG_PORT_ATTRIBUTE *) & CtReq->un.PortID;
-			size = sizeof (struct lpfc_name) + FOURBYTES;
-			memcpy((uint8_t *) & pab->PortName,
-			       (uint8_t *) & vport->fc_sparam.portName,
-			       sizeof (struct lpfc_name));
+			if (cmdcode == SLI_MGMT_RPRT) {
+				rh = (struct lpfc_fdmi_reg_hba *)
+					&CtReq->un.PortID;
+				/* HBA Identifier */
+				memcpy(&rh->hi.PortName,
+				       &vport->fc_sparam.portName,
+				       sizeof(struct lpfc_name));
+				pab = (struct lpfc_fdmi_reg_portattr *)
+					&rh->rpl.EntryCnt;
+			} else
+				pab = (struct lpfc_fdmi_reg_portattr *)
+					&CtReq->un.PortID;
+			size = sizeof(struct lpfc_name) + FOURBYTES;
+			memcpy((uint8_t *)&pab->PortName,
+			       (uint8_t *)&vport->fc_sparam.portName,
+			       sizeof(struct lpfc_name));
 			pab->ab.EntryCnt = 0;
 
 			/* #1 Port attribute entry */
-			ae = (ATTRIBUTE_ENTRY *) ((uint8_t *) pab + size);
-			ae->ad.bits.AttrType = be16_to_cpu(SUPPORTED_FC4_TYPES);
-			ae->ad.bits.AttrLen = be16_to_cpu(FOURBYTES + 32);
-			ae->un.SupportFC4Types[2] = 1;
-			ae->un.SupportFC4Types[7] = 1;
+			ad = (struct lpfc_fdmi_attr_def *)
+				((uint8_t *)pab + size);
+			ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
+			memset(ae, 0, sizeof(ae->un.FC4Types));
+			ad->AttrType =
+				cpu_to_be16(RPRT_SUPPORTED_FC4_TYPES);
+			ad->AttrLen = cpu_to_be16(FOURBYTES + 32);
+			ae->un.FC4Types[0] = 0x40; /* Type 1 - ELS */
+			ae->un.FC4Types[1] = 0x80; /* Type 8 - FCP */
+			ae->un.FC4Types[4] = 0x80; /* Type 32 - CT */
 			pab->ab.EntryCnt++;
 			size += FOURBYTES + 32;
 
 			/* #2 Port attribute entry */
-			ae = (ATTRIBUTE_ENTRY *) ((uint8_t *) pab + size);
-			ae->ad.bits.AttrType = be16_to_cpu(SUPPORTED_SPEED);
-			ae->ad.bits.AttrLen = be16_to_cpu(FOURBYTES + 4);
-
+			ad = (struct lpfc_fdmi_attr_def *)
+				((uint8_t *)pab + size);
+			ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
+			ad->AttrType = cpu_to_be16(RPRT_SUPPORTED_SPEED);
+			ad->AttrLen = cpu_to_be16(FOURBYTES + 4);
 			ae->un.SupportSpeed = 0;
 			if (phba->lmt & LMT_16Gb)
 				ae->un.SupportSpeed |= HBA_PORTSPEED_16GBIT;
@@ -1619,15 +1790,19 @@ lpfc_fdmi_cmd(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp, int cmdcode)
 				ae->un.SupportSpeed |= HBA_PORTSPEED_2GBIT;
 			if (phba->lmt & LMT_1Gb)
 				ae->un.SupportSpeed |= HBA_PORTSPEED_1GBIT;
+			ae->un.SupportSpeed =
+				cpu_to_be32(ae->un.SupportSpeed);
 
 			pab->ab.EntryCnt++;
 			size += FOURBYTES + 4;
 
 			/* #3 Port attribute entry */
-			ae = (ATTRIBUTE_ENTRY *) ((uint8_t *) pab + size);
-			ae->ad.bits.AttrType = be16_to_cpu(PORT_SPEED);
-			ae->ad.bits.AttrLen = be16_to_cpu(FOURBYTES + 4);
-			switch(phba->fc_linkspeed) {
+			ad = (struct lpfc_fdmi_attr_def *)
+				((uint8_t *)pab + size);
+			ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
+			ad->AttrType = cpu_to_be16(RPRT_PORT_SPEED);
+			ad->AttrLen = cpu_to_be16(FOURBYTES + 4);
+			switch (phba->fc_linkspeed) {
 			case LPFC_LINK_SPEED_1GHZ:
 				ae->un.PortSpeed = HBA_PORTSPEED_1GBIT;
 				break;
@@ -1650,93 +1825,273 @@ lpfc_fdmi_cmd(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp, int cmdcode)
 				ae->un.PortSpeed = HBA_PORTSPEED_UNKNOWN;
 				break;
 			}
+			ae->un.PortSpeed = cpu_to_be32(ae->un.PortSpeed);
 			pab->ab.EntryCnt++;
 			size += FOURBYTES + 4;
 
 			/* #4 Port attribute entry */
-			ae = (ATTRIBUTE_ENTRY *) ((uint8_t *) pab + size);
-			ae->ad.bits.AttrType = be16_to_cpu(MAX_FRAME_SIZE);
-			ae->ad.bits.AttrLen = be16_to_cpu(FOURBYTES + 4);
-			hsp = (struct serv_parm *) & vport->fc_sparam;
+			ad = (struct lpfc_fdmi_attr_def *)
+				((uint8_t *)pab + size);
+			ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
+			ad->AttrType = cpu_to_be16(RPRT_MAX_FRAME_SIZE);
+			ad->AttrLen = cpu_to_be16(FOURBYTES + 4);
+			hsp = (struct serv_parm *)&vport->fc_sparam;
 			ae->un.MaxFrameSize =
-			    (((uint32_t) hsp->cmn.
-			      bbRcvSizeMsb) << 8) | (uint32_t) hsp->cmn.
+			    (((uint32_t)hsp->cmn.
+			      bbRcvSizeMsb) << 8) | (uint32_t)hsp->cmn.
 			    bbRcvSizeLsb;
+			ae->un.MaxFrameSize =
+				cpu_to_be32(ae->un.MaxFrameSize);
 			pab->ab.EntryCnt++;
 			size += FOURBYTES + 4;
+			if ((size + LPFC_FDMI_MAX_AE_SIZE) >
+					(LPFC_BPL_SIZE - LPFC_CT_PREAMBLE))
+				goto port_out;
 
 			/* #5 Port attribute entry */
-			ae = (ATTRIBUTE_ENTRY *) ((uint8_t *) pab + size);
-			ae->ad.bits.AttrType = be16_to_cpu(OS_DEVICE_NAME);
-			strcpy((char *)ae->un.OsDeviceName, LPFC_DRIVER_NAME);
-			len = strlen((char *)ae->un.OsDeviceName);
+			ad = (struct lpfc_fdmi_attr_def *)
+				((uint8_t *)pab + size);
+			ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
+			memset(ae, 0, sizeof(ae->un.OsDeviceName));
+			ad->AttrType = cpu_to_be16(RPRT_OS_DEVICE_NAME);
+			strncpy((char *)ae->un.OsDeviceName, LPFC_DRIVER_NAME,
+				sizeof(ae->un.OsDeviceName));
+			len = strnlen((char *)ae->un.OsDeviceName,
+					  sizeof(ae->un.OsDeviceName));
 			len += (len & 3) ? (4 - (len & 3)) : 4;
-			ae->ad.bits.AttrLen = be16_to_cpu(FOURBYTES + len);
+			ad->AttrLen = cpu_to_be16(FOURBYTES + len);
 			pab->ab.EntryCnt++;
 			size += FOURBYTES + len;
+			if ((size + LPFC_FDMI_MAX_AE_SIZE) >
+					(LPFC_BPL_SIZE - LPFC_CT_PREAMBLE))
+				goto port_out;
+
+			/* #6 Port attribute entry */
+			ad = (struct lpfc_fdmi_attr_def *)
+				((uint8_t *)pab + size);
+			ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
+			memset(ae, 0, sizeof(ae->un.HostName));
+			snprintf(ae->un.HostName, sizeof(ae->un.HostName), "%s",
+				 init_utsname()->nodename);
+			ad->AttrType = cpu_to_be16(RPRT_HOST_NAME);
+			len = strnlen(ae->un.HostName,
+					sizeof(ae->un.HostName));
+			len += (len & 3) ? (4 - (len & 3)) : 4;
+			ad->AttrLen =
+				cpu_to_be16(FOURBYTES + len);
+			pab->ab.EntryCnt++;
+			size += FOURBYTES + len;
+			if ((size + sizeof(struct lpfc_name)) >
+					(LPFC_BPL_SIZE - LPFC_CT_PREAMBLE))
+				goto port_out;
 
-			if (vport->cfg_fdmi_on == 2) {
-				/* #6 Port attribute entry */
-				ae = (ATTRIBUTE_ENTRY *) ((uint8_t *) pab +
-							  size);
-				ae->ad.bits.AttrType = be16_to_cpu(HOST_NAME);
-				sprintf(ae->un.HostName, "%s",
-					init_utsname()->nodename);
-				len = strlen(ae->un.HostName);
-				len += (len & 3) ? (4 - (len & 3)) : 4;
-				ae->ad.bits.AttrLen =
-				    be16_to_cpu(FOURBYTES + len);
-				pab->ab.EntryCnt++;
-				size += FOURBYTES + len;
-			}
-
-			pab->ab.EntryCnt = be32_to_cpu(pab->ab.EntryCnt);
+			/*
+			 * Currently switches don't seem to support the
+			 * following extended Port attributes.
+			 */
+			if (!(vport->cfg_fdmi_on & LPFC_FDMI_ALL_ATTRIB))
+				goto port_out;
+
+			/* #7 Port attribute entry */
+			ad = (struct lpfc_fdmi_attr_def *)
+				((uint8_t *)pab + size);
+			ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
+			memset(ae, 0,  sizeof(struct lpfc_name));
+			ad->AttrType = cpu_to_be16(RPRT_NODENAME);
+			ad->AttrLen =  cpu_to_be16(FOURBYTES
+						+ sizeof(struct lpfc_name));
+			memcpy(&ae->un.NodeName, &vport->fc_sparam.nodeName,
+			       sizeof(struct lpfc_name));
+			pab->ab.EntryCnt++;
+			size += FOURBYTES + sizeof(struct lpfc_name);
+			if ((size + sizeof(struct lpfc_name)) >
+					(LPFC_BPL_SIZE - LPFC_CT_PREAMBLE))
+				goto port_out;
+
+			/* #8 Port attribute entry */
+			ad = (struct lpfc_fdmi_attr_def *)
+				((uint8_t *)pab + size);
+			ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
+			memset(ae, 0,  sizeof(struct lpfc_name));
+			ad->AttrType = cpu_to_be16(RPRT_PORTNAME);
+			ad->AttrLen =  cpu_to_be16(FOURBYTES
+						+ sizeof(struct lpfc_name));
+			memcpy(&ae->un.PortName, &vport->fc_sparam.portName,
+			       sizeof(struct lpfc_name));
+			pab->ab.EntryCnt++;
+			size += FOURBYTES + sizeof(struct lpfc_name);
+			if ((size + LPFC_FDMI_MAX_AE_SIZE) >
+					(LPFC_BPL_SIZE - LPFC_CT_PREAMBLE))
+				goto port_out;
+
+			/* #9 Port attribute entry */
+			ad = (struct lpfc_fdmi_attr_def *)
+				((uint8_t *)pab + size);
+			ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
+			memset(ae, 0, sizeof(ae->un.NodeSymName));
+			ad->AttrType = cpu_to_be16(RPRT_SYM_PORTNAME);
+			len = lpfc_vport_symbolic_port_name(vport,
+				ae->un.NodeSymName, sizeof(ae->un.NodeSymName));
+			len += (len & 3) ? (4 - (len & 3)) : 4;
+			ad->AttrLen = cpu_to_be16(FOURBYTES + len);
+			pab->ab.EntryCnt++;
+			size += FOURBYTES + len;
+			if ((size + 4) > (LPFC_BPL_SIZE - LPFC_CT_PREAMBLE))
+				goto port_out;
+
+			/* #10 Port attribute entry */
+			ad = (struct lpfc_fdmi_attr_def *)
+				((uint8_t *)pab + size);
+			ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
+			ad->AttrType = cpu_to_be16(RPRT_PORT_TYPE);
+			ae->un.PortState = 0;
+			ad->AttrLen = cpu_to_be16(FOURBYTES + 4);
+			pab->ab.EntryCnt++;
+			size += FOURBYTES + 4;
+			if ((size + 4) > (LPFC_BPL_SIZE - LPFC_CT_PREAMBLE))
+				goto port_out;
+
+			/* #11 Port attribute entry */
+			ad = (struct lpfc_fdmi_attr_def *)
+				((uint8_t *)pab + size);
+			ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
+			ad->AttrType = cpu_to_be16(RPRT_SUPPORTED_CLASS);
+			ae->un.SupportClass =
+				cpu_to_be32(FC_COS_CLASS2 | FC_COS_CLASS3);
+			ad->AttrLen = cpu_to_be16(FOURBYTES + 4);
+			pab->ab.EntryCnt++;
+			size += FOURBYTES + 4;
+			if ((size + sizeof(struct lpfc_name)) >
+					(LPFC_BPL_SIZE - LPFC_CT_PREAMBLE))
+				goto port_out;
+
+			/* #12 Port attribute entry */
+			ad = (struct lpfc_fdmi_attr_def *)
+				((uint8_t *)pab + size);
+			ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
+			memset(ae, 0, sizeof(struct lpfc_name));
+			ad->AttrType = cpu_to_be16(RPRT_FABRICNAME);
+			ad->AttrLen =  cpu_to_be16(FOURBYTES
+						+ sizeof(struct lpfc_name));
+			memcpy(&ae->un.FabricName, &vport->fabric_nodename,
+			       sizeof(struct lpfc_name));
+			pab->ab.EntryCnt++;
+			size += FOURBYTES + sizeof(struct lpfc_name);
+			if ((size + LPFC_FDMI_MAX_AE_SIZE) >
+					(LPFC_BPL_SIZE - LPFC_CT_PREAMBLE))
+				goto port_out;
+
+			/* #13 Port attribute entry */
+			ad = (struct lpfc_fdmi_attr_def *)
+				((uint8_t *)pab + size);
+			ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
+			memset(ae, 0, sizeof(ae->un.FC4Types));
+			ad->AttrType =
+				cpu_to_be16(RPRT_ACTIVE_FC4_TYPES);
+			ad->AttrLen = cpu_to_be16(FOURBYTES + 32);
+			ae->un.FC4Types[0] = 0x40; /* Type 1 - ELS */
+			ae->un.FC4Types[1] = 0x80; /* Type 8 - FCP */
+			ae->un.FC4Types[4] = 0x80; /* Type 32 - CT */
+			pab->ab.EntryCnt++;
+			size += FOURBYTES + 32;
+			if ((size + 4) > (LPFC_BPL_SIZE - LPFC_CT_PREAMBLE))
+				goto port_out;
+
+			/* #257 Port attribute entry */
+			ad = (struct lpfc_fdmi_attr_def *)
+				((uint8_t *)pab + size);
+			ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
+			ad->AttrType = cpu_to_be16(RPRT_PORT_STATE);
+			ae->un.PortState = 0;
+			ad->AttrLen = cpu_to_be16(FOURBYTES + 4);
+			pab->ab.EntryCnt++;
+			size += FOURBYTES + 4;
+			if ((size + 4) > (LPFC_BPL_SIZE - LPFC_CT_PREAMBLE))
+				goto port_out;
+
+			/* #258 Port attribute entry */
+			ad = (struct lpfc_fdmi_attr_def *)
+				((uint8_t *)pab + size);
+			ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
+			ad->AttrType = cpu_to_be16(RPRT_DISC_PORT);
+			ae->un.PortState = lpfc_find_map_node(vport);
+			ae->un.PortState = cpu_to_be32(ae->un.PortState);
+			ad->AttrLen = cpu_to_be16(FOURBYTES + 4);
+			pab->ab.EntryCnt++;
+			size += FOURBYTES + 4;
+			if ((size + 4) > (LPFC_BPL_SIZE - LPFC_CT_PREAMBLE))
+				goto port_out;
+
+			/* #259 Port attribute entry */
+			ad = (struct lpfc_fdmi_attr_def *)
+				((uint8_t *)pab + size);
+			ae = (struct lpfc_fdmi_attr_entry *)&ad->AttrValue;
+			ad->AttrType = cpu_to_be16(RPRT_PORT_ID);
+			ae->un.PortId =  cpu_to_be32(vport->fc_myDID);
+			ad->AttrLen = cpu_to_be16(FOURBYTES + 4);
+			pab->ab.EntryCnt++;
+			size += FOURBYTES + 4;
+port_out:
+			pab->ab.EntryCnt = cpu_to_be32(pab->ab.EntryCnt);
 			/* Total size */
 			size = GID_REQUEST_SZ - 4 + size;
 		}
 		break;
 
+	case SLI_MGMT_GHAT:
+	case SLI_MGMT_GRPL:
+		rsp_size = FC_MAX_NS_RSP;
 	case SLI_MGMT_DHBA:
-		CtReq->CommandResponse.bits.CmdRsp = be16_to_cpu(SLI_MGMT_DHBA);
-		CtReq->CommandResponse.bits.Size = 0;
-		pe = (PORT_ENTRY *) & CtReq->un.PortID;
-		memcpy((uint8_t *) & pe->PortName,
-		       (uint8_t *) & vport->fc_sparam.portName,
-		       sizeof (struct lpfc_name));
-		size = GID_REQUEST_SZ - 4 + sizeof (struct lpfc_name);
+	case SLI_MGMT_DHAT:
+		pe = (struct lpfc_fdmi_port_entry *)&CtReq->un.PortID;
+		memcpy((uint8_t *)&pe->PortName,
+		       (uint8_t *)&vport->fc_sparam.portName,
+		       sizeof(struct lpfc_name));
+		size = GID_REQUEST_SZ - 4 + sizeof(struct lpfc_name);
 		break;
 
+	case SLI_MGMT_GPAT:
+	case SLI_MGMT_GPAS:
+		rsp_size = FC_MAX_NS_RSP;
 	case SLI_MGMT_DPRT:
-		CtReq->CommandResponse.bits.CmdRsp = be16_to_cpu(SLI_MGMT_DPRT);
-		CtReq->CommandResponse.bits.Size = 0;
-		pe = (PORT_ENTRY *) & CtReq->un.PortID;
-		memcpy((uint8_t *) & pe->PortName,
-		       (uint8_t *) & vport->fc_sparam.portName,
-		       sizeof (struct lpfc_name));
-		size = GID_REQUEST_SZ - 4 + sizeof (struct lpfc_name);
+	case SLI_MGMT_DPA:
+		pe = (struct lpfc_fdmi_port_entry *)&CtReq->un.PortID;
+		memcpy((uint8_t *)&pe->PortName,
+		       (uint8_t *)&vport->fc_sparam.portName,
+		       sizeof(struct lpfc_name));
+		size = GID_REQUEST_SZ - 4 + sizeof(struct lpfc_name);
+		break;
+	case SLI_MGMT_GRHL:
+		size = GID_REQUEST_SZ - 4;
 		break;
+	default:
+		lpfc_printf_vlog(vport, KERN_WARNING, LOG_DISCOVERY,
+				 "0298 FDMI cmdcode x%x not supported\n",
+				 cmdcode);
+		goto fdmi_cmd_free_bmpvirt;
 	}
+	CtReq->CommandResponse.bits.Size = cpu_to_be16(rsp_size);
 
-	bpl = (struct ulp_bde64 *) bmp->virt;
-	bpl->addrHigh = le32_to_cpu(putPaddrHigh(mp->phys) );
-	bpl->addrLow = le32_to_cpu(putPaddrLow(mp->phys) );
+	bpl = (struct ulp_bde64 *)bmp->virt;
+	bpl->addrHigh = le32_to_cpu(putPaddrHigh(mp->phys));
+	bpl->addrLow = le32_to_cpu(putPaddrLow(mp->phys));
 	bpl->tus.f.bdeFlags = 0;
 	bpl->tus.f.bdeSize = size;
-	bpl->tus.w = le32_to_cpu(bpl->tus.w);
-
-	cmpl = lpfc_cmpl_ct_cmd_fdmi;
 
-	/* The lpfc_ct_cmd/lpfc_get_req shall increment ndlp reference count
+	/*
+	 * The lpfc_ct_cmd/lpfc_get_req shall increment ndlp reference count
 	 * to hold ndlp reference for the corresponding callback function.
 	 */
-	if (!lpfc_ct_cmd(vport, mp, bmp, ndlp, cmpl, FC_MAX_NS_RSP, 0))
+	if (!lpfc_ct_cmd(vport, mp, bmp, ndlp, cmpl, rsp_size, 0))
 		return 0;
 
-	/* Decrement ndlp reference count to release ndlp reference held
+	/*
+	 * Decrement ndlp reference count to release ndlp reference held
 	 * for the failed command's callback function.
 	 */
 	lpfc_nlp_put(ndlp);
 
+fdmi_cmd_free_bmpvirt:
 	lpfc_mbuf_free(phba, bmp->virt, bmp->phys);
 fdmi_cmd_free_bmp:
 	kfree(bmp);
diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 6350563..9f3c74e 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -7172,7 +7172,7 @@ lpfc_do_scr_ns_plogi(struct lpfc_hba *phba, struct lpfc_vport *vport)
 		return;
 	}
 
-	if (vport->cfg_fdmi_on) {
+	if (vport->cfg_fdmi_on & LPFC_FDMI_SUPPORT) {
 		/* If this is the first time, allocate an ndlp and initialize
 		 * it. Otherwise, make sure the node is enabled and then do the
 		 * login.
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index b1ad1a0..9d06d45 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -5489,11 +5489,11 @@ lpfc_mbx_cmpl_fdmi_reg_login(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 	 * fdmi-on=2 (supporting RPA/hostnmae)
 	 */
 
-	if (vport->cfg_fdmi_on == 1)
-		lpfc_fdmi_cmd(vport, ndlp, SLI_MGMT_DHBA);
-	else
+	if (vport->cfg_fdmi_on & LPFC_FDMI_REG_DELAY)
 		mod_timer(&vport->fc_fdmitmo,
 			  jiffies + msecs_to_jiffies(1000 * 60));
+	else
+		lpfc_fdmi_cmd(vport, ndlp, SLI_MGMT_DHBA);
 
 	/* decrement the node reference count held for this callback
 	 * function.
diff --git a/drivers/scsi/lpfc/lpfc_hw.h b/drivers/scsi/lpfc/lpfc_hw.h
index 2362592..a74bbf0 100644
--- a/drivers/scsi/lpfc/lpfc_hw.h
+++ b/drivers/scsi/lpfc/lpfc_hw.h
@@ -107,6 +107,7 @@ struct lpfc_sli_ct_request {
 	uint8_t ReasonCode;
 	uint8_t Explanation;
 	uint8_t VendorUnique;
+#define LPFC_CT_PREAMBLE	20	/* Size of CTReq + 4 up to here */
 
 	union {
 		uint32_t PortID;
@@ -170,6 +171,8 @@ struct lpfc_sli_ct_request {
 	} un;
 };
 
+#define LPFC_MAX_CT_SIZE	(60 * 4096)
+
 #define  SLI_CT_REVISION        1
 #define  GID_REQUEST_SZ   (offsetof(struct lpfc_sli_ct_request, un) + \
 			   sizeof(struct gid))
@@ -1007,78 +1010,45 @@ typedef struct _ELS_PKT {	/* Structure is in Big Endian format */
 	} un;
 } ELS_PKT;
 
-/*
- * FDMI
- * HBA MAnagement Operations Command Codes
- */
-#define  SLI_MGMT_GRHL     0x100	/* Get registered HBA list */
-#define  SLI_MGMT_GHAT     0x101	/* Get HBA attributes */
-#define  SLI_MGMT_GRPL     0x102	/* Get registered Port list */
-#define  SLI_MGMT_GPAT     0x110	/* Get Port attributes */
-#define  SLI_MGMT_RHBA     0x200	/* Register HBA */
-#define  SLI_MGMT_RHAT     0x201	/* Register HBA attributes */
-#define  SLI_MGMT_RPRT     0x210	/* Register Port */
-#define  SLI_MGMT_RPA      0x211	/* Register Port attributes */
-#define  SLI_MGMT_DHBA     0x300	/* De-register HBA */
-#define  SLI_MGMT_DPRT     0x310	/* De-register Port */
+/******** FDMI ********/
 
-/*
- * Management Service Subtypes
- */
-#define  SLI_CT_FDMI_Subtypes     0x10
+/* lpfc_sli_ct_request defines the CT_IU preamble for FDMI commands */
+#define  SLI_CT_FDMI_Subtypes     0x10	/* Management Service Subtype */
 
 /*
- * HBA Management Service Reject Code
+ * Registered Port List Format
  */
-#define  REJECT_CODE             0x9	/* Unable to perform command request */
+struct lpfc_fdmi_reg_port_list {
+	uint32_t EntryCnt;
+	uint32_t pe;		/* Variable-length array */
+};
 
-/*
- * HBA Management Service Reject Reason Code
- * Please refer to the Reason Codes above
- */
 
-/*
- * HBA Attribute Types
- */
-#define  NODE_NAME               0x1
-#define  MANUFACTURER            0x2
-#define  SERIAL_NUMBER           0x3
-#define  MODEL                   0x4
-#define  MODEL_DESCRIPTION       0x5
-#define  HARDWARE_VERSION        0x6
-#define  DRIVER_VERSION          0x7
-#define  OPTION_ROM_VERSION      0x8
-#define  FIRMWARE_VERSION        0x9
-#define  OS_NAME_VERSION	 0xa
-#define  MAX_CT_PAYLOAD_LEN	 0xb
+/* Definitions for HBA / Port attribute entries */
 
-/*
- * Port Attrubute Types
- */
-#define  SUPPORTED_FC4_TYPES     0x1
-#define  SUPPORTED_SPEED         0x2
-#define  PORT_SPEED              0x3
-#define  MAX_FRAME_SIZE          0x4
-#define  OS_DEVICE_NAME          0x5
-#define  HOST_NAME               0x6
-
-union AttributesDef {
+struct lpfc_fdmi_attr_def { /* Defined in TLV format */
 	/* Structure is in Big Endian format */
-	struct {
-		uint32_t AttrType:16;
-		uint32_t AttrLen:16;
-	} bits;
-	uint32_t word;
+	uint32_t AttrType:16;
+	uint32_t AttrLen:16;
+	uint32_t AttrValue;  /* Marks start of Value (ATTRIBUTE_ENTRY) */
 };
 
 
-/*
- * HBA Attribute Entry (8 - 260 bytes)
- */
-typedef struct {
-	union AttributesDef ad;
+/* Attribute Entry */
+struct lpfc_fdmi_attr_entry {
 	union {
 		uint32_t VendorSpecific;
+		uint32_t SupportClass;
+		uint32_t SupportSpeed;
+		uint32_t PortSpeed;
+		uint32_t MaxFrameSize;
+		uint32_t MaxCTPayloadLen;
+		uint32_t PortState;
+		uint32_t PortId;
+		struct lpfc_name NodeName;
+		struct lpfc_name PortName;
+		struct lpfc_name FabricName;
+		uint8_t FC4Types[32];
 		uint8_t Manufacturer[64];
 		uint8_t SerialNumber[64];
 		uint8_t Model[256];
@@ -1087,97 +1057,115 @@ typedef struct {
 		uint8_t DriverVersion[256];
 		uint8_t OptionROMVersion[256];
 		uint8_t FirmwareVersion[256];
-		struct lpfc_name NodeName;
-		uint8_t SupportFC4Types[32];
-		uint32_t SupportSpeed;
-		uint32_t PortSpeed;
-		uint32_t MaxFrameSize;
+		uint8_t OsHostName[256];
+		uint8_t NodeSymName[256];
 		uint8_t OsDeviceName[256];
 		uint8_t OsNameVersion[256];
-		uint32_t MaxCTPayloadLen;
 		uint8_t HostName[256];
 	} un;
-} ATTRIBUTE_ENTRY;
+};
+
+#define LPFC_FDMI_MAX_AE_SIZE	sizeof(struct lpfc_fdmi_attr_entry)
 
 /*
  * HBA Attribute Block
  */
-typedef struct {
-	uint32_t EntryCnt;	/* Number of HBA attribute entries */
-	ATTRIBUTE_ENTRY Entry;	/* Variable-length array */
-} ATTRIBUTE_BLOCK;
+struct lpfc_fdmi_attr_block {
+	uint32_t EntryCnt;		/* Number of HBA attribute entries */
+	struct lpfc_fdmi_attr_entry Entry;	/* Variable-length array */
+};
 
 /*
  * Port Entry
  */
-typedef struct {
+struct lpfc_fdmi_port_entry {
 	struct lpfc_name PortName;
-} PORT_ENTRY;
+};
 
 /*
  * HBA Identifier
  */
-typedef struct {
+struct lpfc_fdmi_hba_ident {
 	struct lpfc_name PortName;
-} HBA_IDENTIFIER;
-
-/*
- * Registered Port List Format
- */
-typedef struct {
-	uint32_t EntryCnt;
-	PORT_ENTRY pe;		/* Variable-length array */
-} REG_PORT_LIST;
+};
 
 /*
  * Register HBA(RHBA)
  */
-typedef struct {
-	HBA_IDENTIFIER hi;
-	REG_PORT_LIST rpl;	/* variable-length array */
-/* ATTRIBUTE_BLOCK   ab; */
-} REG_HBA;
+struct lpfc_fdmi_reg_hba {
+	struct lpfc_fdmi_hba_ident hi;
+	struct lpfc_fdmi_reg_port_list rpl;	/* variable-length array */
+/* struct lpfc_fdmi_attr_block   ab; */
+};
 
 /*
  * Register HBA Attributes (RHAT)
  */
-typedef struct {
+struct lpfc_fdmi_reg_hbaattr {
 	struct lpfc_name HBA_PortName;
-	ATTRIBUTE_BLOCK ab;
-} REG_HBA_ATTRIBUTE;
+	struct lpfc_fdmi_attr_block ab;
+};
 
 /*
  * Register Port Attributes (RPA)
  */
-typedef struct {
+struct lpfc_fdmi_reg_portattr {
 	struct lpfc_name PortName;
-	ATTRIBUTE_BLOCK ab;
-} REG_PORT_ATTRIBUTE;
+	struct lpfc_fdmi_attr_block ab;
+};
 
 /*
- * Get Registered HBA List (GRHL) Accept Payload Format
+ * HBA MAnagement Operations Command Codes
  */
-typedef struct {
-	uint32_t HBA__Entry_Cnt; /* Number of Registered HBA Identifiers */
-	struct lpfc_name HBA_PortName;	/* Variable-length array */
-} GRHL_ACC_PAYLOAD;
+#define  SLI_MGMT_GRHL     0x100	/* Get registered HBA list */
+#define  SLI_MGMT_GHAT     0x101	/* Get HBA attributes */
+#define  SLI_MGMT_GRPL     0x102	/* Get registered Port list */
+#define  SLI_MGMT_GPAT     0x110	/* Get Port attributes */
+#define  SLI_MGMT_GPAS     0x120	/* Get Port Statistics */
+#define  SLI_MGMT_RHBA     0x200	/* Register HBA */
+#define  SLI_MGMT_RHAT     0x201	/* Register HBA attributes */
+#define  SLI_MGMT_RPRT     0x210	/* Register Port */
+#define  SLI_MGMT_RPA      0x211	/* Register Port attributes */
+#define  SLI_MGMT_DHBA     0x300	/* De-register HBA */
+#define  SLI_MGMT_DHAT     0x301	/* De-register HBA attributes */
+#define  SLI_MGMT_DPRT     0x310	/* De-register Port */
+#define  SLI_MGMT_DPA      0x311	/* De-register Port attributes */
 
 /*
- * Get Registered Port List (GRPL) Accept Payload Format
+ * HBA Attribute Types
  */
-typedef struct {
-	uint32_t RPL_Entry_Cnt;	/* Number of Registered Port Entries */
-	PORT_ENTRY Reg_Port_Entry[1];	/* Variable-length array */
-} GRPL_ACC_PAYLOAD;
+#define  RHBA_NODENAME           0x1 /* 8 byte WWNN */
+#define  RHBA_MANUFACTURER       0x2 /* 4 to 64 byte ASCII string */
+#define  RHBA_SERIAL_NUMBER      0x3 /* 4 to 64 byte ASCII string */
+#define  RHBA_MODEL              0x4 /* 4 to 256 byte ASCII string */
+#define  RHBA_MODEL_DESCRIPTION  0x5 /* 4 to 256 byte ASCII string */
+#define  RHBA_HARDWARE_VERSION   0x6 /* 4 to 256 byte ASCII string */
+#define  RHBA_DRIVER_VERSION     0x7 /* 4 to 256 byte ASCII string */
+#define  RHBA_OPTION_ROM_VERSION 0x8 /* 4 to 256 byte ASCII string */
+#define  RHBA_FIRMWARE_VERSION   0x9 /* 4 to 256 byte ASCII string */
+#define  RHBA_OS_NAME_VERSION	 0xa /* 4 to 256 byte ASCII string */
+#define  RHBA_MAX_CT_PAYLOAD_LEN 0xb /* 32-bit unsigned int */
+#define  RHBA_SYM_NODENAME       0xc /* 4 to 256 byte ASCII string */
 
 /*
- * Get Port Attributes (GPAT) Accept Payload Format
+ * Port Attrubute Types
  */
-
-typedef struct {
-	ATTRIBUTE_BLOCK pab;
-} GPAT_ACC_PAYLOAD;
-
+#define  RPRT_SUPPORTED_FC4_TYPES     0x1 /* 32 byte binary array */
+#define  RPRT_SUPPORTED_SPEED         0x2 /* 32-bit unsigned int */
+#define  RPRT_PORT_SPEED              0x3 /* 32-bit unsigned int */
+#define  RPRT_MAX_FRAME_SIZE          0x4 /* 32-bit unsigned int */
+#define  RPRT_OS_DEVICE_NAME          0x5 /* 4 to 256 byte ASCII string */
+#define  RPRT_HOST_NAME               0x6 /* 4 to 256 byte ASCII string */
+#define  RPRT_NODENAME                0x7 /* 8 byte WWNN */
+#define  RPRT_PORTNAME                0x8 /* 8 byte WWNN */
+#define  RPRT_SYM_PORTNAME            0x9 /* 4 to 256 byte ASCII string */
+#define  RPRT_PORT_TYPE               0xa /* 32-bit unsigned int */
+#define  RPRT_SUPPORTED_CLASS         0xb /* 32-bit unsigned int */
+#define  RPRT_FABRICNAME              0xc /* 8 byte Fabric WWNN */
+#define  RPRT_ACTIVE_FC4_TYPES        0xd /* 32 byte binary array */
+#define  RPRT_PORT_STATE              0x101 /* 32-bit unsigned int */
+#define  RPRT_DISC_PORT               0x102 /* 32-bit unsigned int */
+#define  RPRT_PORT_ID                 0x103 /* 32-bit unsigned int */
 
 /*
  *  Begin HBA configuration parameters.
-- 
1.7.11.7


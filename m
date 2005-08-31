From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 3/3] lpfc: use wwn_to_u64() transport helper
Date: Wed, 31 Aug 2005 15:23:12 -0700
Message-ID: <20050831222312.GK11577@plap.qlogic.org>
References: <20050827020750.27275.19733.sendpatchset@plap.qlogic.com> <20050827020950.27275.51550.sendpatchset@plap.qlogic.com> <20050827104053.GA21026@infradead.org> <20050831221835.GI11577@plap.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:7139 "EHLO avexch01.qlogic.com")
	by vger.kernel.org with ESMTP id S964864AbVHaWXM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 31 Aug 2005 18:23:12 -0400
Content-Disposition: inline
In-Reply-To: <20050831221835.GI11577@plap.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Christoph Hellwig <hch@infradead.org>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, "Smart, James" <James.Smart@emulex.com>

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---

diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -965,21 +965,21 @@ static void
 lpfc_get_host_fabric_name (struct Scsi_Host *shost)
 {
 	struct lpfc_hba *phba = (struct lpfc_hba*)shost->hostdata[0];
-	u64 nodename;
+	u64 node_name;
 
 	spin_lock_irq(shost->host_lock);
 
 	if ((phba->fc_flag & FC_FABRIC) ||
 	    ((phba->fc_topology == TOPOLOGY_LOOP) &&
 	     (phba->fc_flag & FC_PUBLIC_LOOP)))
-		memcpy(&nodename, &phba->fc_fabparam.nodeName, sizeof(u64));
+		node_name = wwn_to_u64(phba->fc_fabparam.nodeName.wwn);
 	else
 		/* fabric is local port if there is no F/FL_Port */
-		memcpy(&nodename, &phba->fc_nodename, sizeof(u64));
+		node_name = wwn_to_u64(phba->fc_nodename.wwn);
 
 	spin_unlock_irq(shost->host_lock);
 
-	fc_host_fabric_name(shost) = be64_to_cpu(nodename);
+	fc_host_fabric_name(shost) = node_name;
 }
 
 
@@ -1101,21 +1101,20 @@ lpfc_get_starget_node_name(struct scsi_t
 {
 	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
 	struct lpfc_hba *phba = (struct lpfc_hba *) shost->hostdata[0];
-	uint64_t node_name = 0;
+	u64 node_name = 0;
 	struct lpfc_nodelist *ndlp = NULL;
 
 	spin_lock_irq(shost->host_lock);
 	/* Search the mapped list for this target ID */
 	list_for_each_entry(ndlp, &phba->fc_nlpmap_list, nlp_listp) {
 		if (starget->id == ndlp->nlp_sid) {
-			memcpy(&node_name, &ndlp->nlp_nodename,
-						sizeof(struct lpfc_name));
+			node_name = wwn_to_u64(ndlp->nlp_nodename.wwn);
 			break;
 		}
 	}
 	spin_unlock_irq(shost->host_lock);
 
-	fc_starget_node_name(starget) = be64_to_cpu(node_name);
+	fc_starget_node_name(starget) = node_name;
 }
 
 static void
@@ -1123,21 +1122,20 @@ lpfc_get_starget_port_name(struct scsi_t
 {
 	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
 	struct lpfc_hba *phba = (struct lpfc_hba *) shost->hostdata[0];
-	uint64_t port_name = 0;
+	u64 port_name = 0;
 	struct lpfc_nodelist *ndlp = NULL;
 
 	spin_lock_irq(shost->host_lock);
 	/* Search the mapped list for this target ID */
 	list_for_each_entry(ndlp, &phba->fc_nlpmap_list, nlp_listp) {
 		if (starget->id == ndlp->nlp_sid) {
-			memcpy(&port_name, &ndlp->nlp_portname,
-						sizeof(struct lpfc_name));
+			port_name = wwn_to_u64(ndlp->nlp_portname.wwn);
 			break;
 		}
 	}
 	spin_unlock_irq(shost->host_lock);
 
-	fc_starget_port_name(starget) = be64_to_cpu(port_name);
+	fc_starget_port_name(starget) = port_name;
 }
 
 static void
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -1016,13 +1016,10 @@ lpfc_register_remote_port(struct lpfc_hb
 	struct fc_rport *rport;
 	struct lpfc_rport_data *rdata;
 	struct fc_rport_identifiers rport_ids;
-	uint64_t wwn;
 
 	/* Remote port has reappeared. Re-register w/ FC transport */
-	memcpy(&wwn, &ndlp->nlp_nodename, sizeof(uint64_t));
-	rport_ids.node_name = be64_to_cpu(wwn);
-	memcpy(&wwn, &ndlp->nlp_portname, sizeof(uint64_t));
-	rport_ids.port_name = be64_to_cpu(wwn);
+	rport_ids.node_name = wwn_to_u64(ndlp->nlp_nodename.wwn);
+	rport_ids.port_name = wwn_to_u64(ndlp->nlp_portname.wwn);
 	rport_ids.port_id = ndlp->nlp_DID;
 	rport_ids.roles = FC_RPORT_ROLE_UNKNOWN;
 	if (ndlp->nlp_type & NLP_FCP_TARGET)
diff --git a/drivers/scsi/lpfc/lpfc_hw.h b/drivers/scsi/lpfc/lpfc_hw.h
--- a/drivers/scsi/lpfc/lpfc_hw.h
+++ b/drivers/scsi/lpfc/lpfc_hw.h
@@ -262,12 +262,14 @@ struct lpfc_sli_ct_request {
 #define FF_FRAME_SIZE     2048
 
 struct lpfc_name {
+	union {
+		struct {
 #ifdef __BIG_ENDIAN_BITFIELD
-	uint8_t nameType:4;	/* FC Word 0, bit 28:31 */
-	uint8_t IEEEextMsn:4;	/* FC Word 0, bit 24:27, bit 8:11 of IEEE ext */
+			uint8_t nameType:4;	/* FC Word 0, bit 28:31 */
+			uint8_t IEEEextMsn:4;	/* FC Word 0, bit 24:27, bit 8:11 of IEEE ext */
 #else	/*  __LITTLE_ENDIAN_BITFIELD */
-	uint8_t IEEEextMsn:4;	/* FC Word 0, bit 24:27, bit 8:11 of IEEE ext */
-	uint8_t nameType:4;	/* FC Word 0, bit 28:31 */
+			uint8_t IEEEextMsn:4;	/* FC Word 0, bit 24:27, bit 8:11 of IEEE ext */
+			uint8_t nameType:4;	/* FC Word 0, bit 28:31 */
 #endif
 
 #define NAME_IEEE           0x1	/* IEEE name - nameType */
@@ -276,8 +278,11 @@ struct lpfc_name {
 #define NAME_IP_TYPE        0x4	/* IP address */
 #define NAME_CCITT_TYPE     0xC
 #define NAME_CCITT_GR_TYPE  0xE
-	uint8_t IEEEextLsb;	/* FC Word 0, bit 16:23, IEEE extended Lsb */
-	uint8_t IEEE[6];	/* FC IEEE address */
+			uint8_t IEEEextLsb;	/* FC Word 0, bit 16:23, IEEE extended Lsb */
+			uint8_t IEEE[6];	/* FC IEEE address */
+		};
+		uint8_t wwn[8];
+	};
 };
 
 struct csp {
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -1332,7 +1332,6 @@ lpfc_pci_probe_one(struct pci_dev *pdev,
 	unsigned long bar0map_len, bar2map_len;
 	int error = -ENODEV, retval;
 	int i;
-	u64 wwname;
 
 	if (pci_enable_device(pdev))
 		goto out;
@@ -1525,10 +1524,8 @@ lpfc_pci_probe_one(struct pci_dev *pdev,
 	 * Must done after lpfc_sli_hba_setup()
 	 */
 
-	memcpy(&wwname, &phba->fc_nodename, sizeof(u64));
-	fc_host_node_name(host) = be64_to_cpu(wwname);
-	memcpy(&wwname, &phba->fc_portname, sizeof(u64));
-	fc_host_port_name(host) = be64_to_cpu(wwname);
+	fc_host_node_name(host) = wwn_to_u64(phba->fc_nodename.wwn);
+	fc_host_port_name(host) = wwn_to_u64(phba->fc_portname.wwn);
 	fc_host_supported_classes(host) = FC_COS_CLASS3;
 
 	memset(fc_host_supported_fc4s(host), 0,

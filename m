From: Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [lpfc 16/19] Add Fabric assigned WWN support.
Date: Tue,  4 Apr 2017 10:17:09 -0700
Message-ID: <1491326232-11255-17-git-send-email-rkennedy@broadcom.com>
References: <1491326232-11255-1-git-send-email-rkennedy@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from lpdvrndsmtp01.broadcom.com ([192.19.229.170]:38160 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755251AbdDDRZt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Apr 2017 13:25:49 -0400
Received: from pallmd1.broadcom.com (pallmd1.ash.broadcom.net [10.85.232.165])
        by rnd-relay.smtp.broadcom.com (Postfix) with ESMTP id 6801F30C0A9
        for <linux-scsi@vger.kernel.org>; Tue,  4 Apr 2017 10:17:35 -0700 (PDT)
In-Reply-To: <1491326232-11255-1-git-send-email-rkennedy@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Dick Kennedy <dick.kennedy@broadcom.com>Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

From: Dick Kennedy <rkennedy@lvnvda1400.lvn.broadcom.net>

Firmware sends first FLOGI to fabric with vendor version changes.
On link up driver gets updated service parameter with FAWWN assigned port name.
Driver sends 2nd FLOGI with updated fawwpn and modifies the vport->fc_portname i
n driver.
Soft wwpn will not be allowed when fawwpn is enabled.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc.h         |  2 ++
 drivers/scsi/lpfc/lpfc_attr.c    |  8 ++++++++
 drivers/scsi/lpfc/lpfc_els.c     |  8 +++++---
 drivers/scsi/lpfc/lpfc_hbadisc.c | 22 +++++++++++++++++-----
 drivers/scsi/lpfc/lpfc_hw.h      |  3 +++
 drivers/scsi/lpfc/lpfc_hw4.h     |  1 +
 drivers/scsi/lpfc/lpfc_init.c    | 31 ++++++++++++++++++++++++++++---
 7 files changed, 64 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index 0fc1450..6d7840b 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -474,6 +474,8 @@ struct lpfc_vport {
 	unsigned long rcv_buffer_time_stamp;
 	uint32_t vport_flag;
 #define STATIC_VPORT	1
+#define FAWWPN_SET	2
+#define FAWWPN_PARAM_CHG	4
 
 	uint16_t fdmi_num_disc;
 	uint32_t fdmi_hba_mask;
diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index 0e28c2e..69a0039 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -2292,6 +2292,8 @@ lpfc_soft_wwn_enable_store(struct device *dev, struct device_attribute *attr,
 	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;
 	struct lpfc_hba   *phba = vport->phba;
 	unsigned int cnt = count;
+	uint8_t vvvl = vport->fc_sparam.cmn.valid_vendor_ver_level;
+	uint32_t *fawwpn_key = (uint32_t *)&vport->fc_sparam.un.vendorVersion[0];
 
 	/*
 	 * We're doing a simple sanity check for soft_wwpn setting.
@@ -2305,6 +2307,12 @@ lpfc_soft_wwn_enable_store(struct device *dev, struct device_attribute *attr,
 	 * here. The intent is to protect against the random user or
 	 * application that is just writing attributes.
 	 */
+	if (vvvl == 1 && (cpu_to_be32(*fawwpn_key)) == FAPWWN_KEY_VENDOR) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				 "0051 "LPFC_DRIVER_NAME" soft wwpn can not"
+				 " be enabled: fawwpn is enabled\n");
+		return -EPERM;
+	}
 
 	/* count may include a LF at end of string */
 	if (buf[cnt-1] == '\n')
diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index ffdcac0..35fc260 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -603,9 +603,11 @@ lpfc_check_clean_addr_bit(struct lpfc_vport *vport,
 		memcmp(&vport->fabric_portname, &sp->portName,
 			sizeof(struct lpfc_name)) ||
 		memcmp(&vport->fabric_nodename, &sp->nodeName,
-			sizeof(struct lpfc_name)))
+			sizeof(struct lpfc_name)) ||
+		(vport->vport_flag & FAWWPN_PARAM_CHG)) {
 		fabric_param_changed = 1;
-
+		vport->vport_flag &= ~FAWWPN_PARAM_CHG;
+	}
 	/*
 	 * Word 1 Bit 31 in common service parameter is overloaded.
 	 * Word 1 Bit 31 in FLOGI request is multiple NPort request
@@ -8755,7 +8757,7 @@ lpfc_issue_els_fdisc(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	pcmd += sizeof(uint32_t); /* Node Name */
 	pcmd += sizeof(uint32_t); /* Node Name */
 	memcpy(pcmd, &vport->fc_nodename, 8);
-
+	memset(sp->un.vendorVersion, 0, sizeof(sp->un.vendorVersion));
 	lpfc_set_disctmo(vport);
 
 	phba->fc_stat.elsXmitFDISC++;
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index d313dde..e824ec1 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -3002,6 +3002,7 @@ lpfc_mbx_cmpl_read_sparam(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 	MAILBOX_t *mb = &pmb->u.mb;
 	struct lpfc_dmabuf *mp = (struct lpfc_dmabuf *) pmb->context1;
 	struct lpfc_vport  *vport = pmb->vport;
+	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
 	struct serv_parm *sp = &vport->fc_sparam;
 	uint32_t ed_tov;
 
@@ -3031,6 +3032,7 @@ lpfc_mbx_cmpl_read_sparam(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 	}
 
 	lpfc_update_vport_wwn(vport);
+	fc_host_port_name(shost) = wwn_to_u64(vport->fc_portname.u.wwn);
 	if (vport->port_type == LPFC_PHYSICAL_PORT) {
 		memcpy(&phba->wwnn, &vport->fc_nodename, sizeof(phba->wwnn));
 		memcpy(&phba->wwpn, &vport->fc_portname, sizeof(phba->wwnn));
@@ -3309,6 +3311,7 @@ lpfc_mbx_cmpl_read_topology(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 	struct lpfc_sli_ring *pring;
 	MAILBOX_t *mb = &pmb->u.mb;
 	struct lpfc_dmabuf *mp = (struct lpfc_dmabuf *) (pmb->context1);
+	uint8_t attn_type;
 
 	/* Unblock ELS traffic */
 	pring = lpfc_phba_elsring(phba);
@@ -3325,6 +3328,7 @@ lpfc_mbx_cmpl_read_topology(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 	}
 
 	la = (struct lpfc_mbx_read_top *) &pmb->u.mb.un.varReadTop;
+	attn_type = bf_get(lpfc_mbx_read_top_att_type, la);
 
 	memcpy(&phba->alpa_map[0], mp->virt, 128);
 
@@ -3337,7 +3341,7 @@ lpfc_mbx_cmpl_read_topology(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 
 	if (phba->fc_eventTag <= la->eventTag) {
 		phba->fc_stat.LinkMultiEvent++;
-		if (bf_get(lpfc_mbx_read_top_att_type, la) == LPFC_ATT_LINK_UP)
+		if (attn_type == LPFC_ATT_LINK_UP)
 			if (phba->fc_eventTag != 0)
 				lpfc_linkdown(phba);
 	}
@@ -3353,7 +3357,7 @@ lpfc_mbx_cmpl_read_topology(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 	}
 
 	phba->link_events++;
-	if ((bf_get(lpfc_mbx_read_top_att_type, la) == LPFC_ATT_LINK_UP) &&
+	if ((attn_type == LPFC_ATT_LINK_UP) &&
 	    !(phba->sli.sli_flag & LPFC_MENLO_MAINT)) {
 		phba->fc_stat.LinkUp++;
 		if (phba->link_flag & LS_LOOPBACK_MODE) {
@@ -3379,8 +3383,8 @@ lpfc_mbx_cmpl_read_topology(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 					phba->wait_4_mlo_maint_flg);
 		}
 		lpfc_mbx_process_link_up(phba, la);
-	} else if (bf_get(lpfc_mbx_read_top_att_type, la) ==
-		   LPFC_ATT_LINK_DOWN) {
+	} else if ((attn_type == LPFC_ATT_LINK_DOWN) ||
+		   (attn_type == LPFC_ATT_UNEXP_WWPN)) {
 		phba->fc_stat.LinkDown++;
 		if (phba->link_flag & LS_LOOPBACK_MODE)
 			lpfc_printf_log(phba, KERN_ERR, LOG_LINK_EVENT,
@@ -3389,6 +3393,14 @@ lpfc_mbx_cmpl_read_topology(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 				"Data: x%x x%x x%x\n",
 				la->eventTag, phba->fc_eventTag,
 				phba->pport->port_state, vport->fc_flag);
+		else if (attn_type == LPFC_ATT_UNEXP_WWPN)
+			lpfc_printf_log(phba, KERN_ERR, LOG_LINK_EVENT,
+				"1313 Link Down UNEXP WWPN Event x%x received "
+				"Data: x%x x%x x%x x%x x%x\n",
+				la->eventTag, phba->fc_eventTag,
+				phba->pport->port_state, vport->fc_flag,
+				bf_get(lpfc_mbx_read_top_mm, la),
+				bf_get(lpfc_mbx_read_top_fa, la));
 		else
 			lpfc_printf_log(phba, KERN_ERR, LOG_LINK_EVENT,
 				"1305 Link Down Event x%x received "
@@ -3400,7 +3412,7 @@ lpfc_mbx_cmpl_read_topology(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 		lpfc_mbx_issue_link_down(phba);
 	}
 	if ((phba->sli.sli_flag & LPFC_MENLO_MAINT) &&
-	    ((bf_get(lpfc_mbx_read_top_att_type, la) == LPFC_ATT_LINK_UP))) {
+	    (attn_type == LPFC_ATT_LINK_UP)) {
 		if (phba->link_state != LPFC_LINK_DOWN) {
 			phba->fc_stat.LinkDown++;
 			lpfc_printf_log(phba, KERN_ERR, LOG_LINK_EVENT,
diff --git a/drivers/scsi/lpfc/lpfc_hw.h b/drivers/scsi/lpfc/lpfc_hw.h
index 15ca214..26a5647 100644
--- a/drivers/scsi/lpfc/lpfc_hw.h
+++ b/drivers/scsi/lpfc/lpfc_hw.h
@@ -509,6 +509,8 @@ struct class_parms {
 	uint8_t word3Reserved2;	/* Fc Word 3, bit  0: 7 */
 };
 
+#define FAPWWN_KEY_VENDOR	0x42524344 /*valid vendor version fawwpn key*/
+
 struct serv_parm {	/* Structure is in Big Endian format */
 	struct csp cmn;
 	struct lpfc_name portName;
@@ -2885,6 +2887,7 @@ struct lpfc_mbx_read_top {
 #define LPFC_ATT_RESERVED    0x00	/* Reserved - attType */
 #define LPFC_ATT_LINK_UP     0x01	/* Link is up */
 #define LPFC_ATT_LINK_DOWN   0x02	/* Link is down */
+#define LPFC_ATT_UNEXP_WWPN  0x06	/* Link is down Unexpected WWWPN */
 	uint32_t word3;
 #define lpfc_mbx_read_top_alpa_granted_SHIFT	24
 #define lpfc_mbx_read_top_alpa_granted_MASK	0x000000FF
diff --git a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
index 1527770..90499f9 100644
--- a/drivers/scsi/lpfc/lpfc_hw4.h
+++ b/drivers/scsi/lpfc/lpfc_hw4.h
@@ -3853,6 +3853,7 @@ struct lpfc_acqe_fc_la {
 #define LPFC_FC_LA_TYPE_NO_HARD_ALPA	0x3
 #define LPFC_FC_LA_TYPE_MDS_LINK_DOWN	0x4
 #define LPFC_FC_LA_TYPE_MDS_LOOPBACK	0x5
+#define LPFC_FC_LA_TYPE_UNEXP_WWPN	0x6
 #define lpfc_acqe_fc_la_port_type_SHIFT		6
 #define lpfc_acqe_fc_la_port_type_MASK		0x00000003
 #define lpfc_acqe_fc_la_port_type_WORD		word0
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 6abfc69..32a23bb 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -335,6 +335,8 @@ lpfc_dump_wakeup_param_cmpl(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmboxq)
 void
 lpfc_update_vport_wwn(struct lpfc_vport *vport)
 {
+	uint8_t vvvl = vport->fc_sparam.cmn.valid_vendor_ver_level;
+	uint32_t *fawwpn_key = (uint32_t *)&vport->fc_sparam.un.vendorVersion[0];
 	/* If the soft name exists then update it using the service params */
 	if (vport->phba->cfg_soft_wwnn)
 		u64_to_wwn(vport->phba->cfg_soft_wwnn,
@@ -354,9 +356,26 @@ lpfc_update_vport_wwn(struct lpfc_vport *vport)
 		memcpy(&vport->fc_sparam.nodeName, &vport->fc_nodename,
 			sizeof(struct lpfc_name));
 
-	if (vport->fc_portname.u.wwn[0] == 0 || vport->phba->cfg_soft_wwpn)
+	/*
+	 * If the port name has changed, then set the Param changes flag
+	 * to unreg the login
+	 */
+	if ((vport->fc_portname.u.wwn[0] != 0) &&
+		memcmp(&vport->fc_portname, &vport->fc_sparam.portName,
+			sizeof(struct lpfc_name)))
+		vport->vport_flag |= FAWWPN_PARAM_CHG;
+
+	if ((vport->fc_portname.u.wwn[0] == 0) ||
+	    (vport->phba->cfg_soft_wwpn) ||
+	    (vvvl == 1 && (cpu_to_be32(*fawwpn_key)) == FAPWWN_KEY_VENDOR) ||
+	    (vport->vport_flag & FAWWPN_SET)) {
 		memcpy(&vport->fc_portname, &vport->fc_sparam.portName,
 			sizeof(struct lpfc_name));
+		vport->vport_flag &= ~FAWWPN_SET;
+		if (vvvl == 1 && (cpu_to_be32(*fawwpn_key)) ==
+		    FAPWWN_KEY_VENDOR)
+			vport->vport_flag |= FAWWPN_SET;
+	}
 	else
 		memcpy(&vport->fc_sparam.portName, &vport->fc_portname,
 			sizeof(struct lpfc_name));
@@ -4525,9 +4544,15 @@ lpfc_sli4_async_fc_evt(struct lpfc_hba *phba, struct lpfc_acqe_fc_la *acqe_fc)
 		/* Parse and translate link attention fields */
 		la = (struct lpfc_mbx_read_top *)&pmb->u.mb.un.varReadTop;
 		la->eventTag = acqe_fc->event_tag;
-		bf_set(lpfc_mbx_read_top_att_type, la,
-		       LPFC_FC_LA_TYPE_LINK_DOWN);
 
+		if (phba->sli4_hba.link_state.status ==
+		    LPFC_FC_LA_TYPE_UNEXP_WWPN) {
+			bf_set(lpfc_mbx_read_top_att_type, la,
+			       LPFC_FC_LA_TYPE_UNEXP_WWPN);
+		} else {
+			bf_set(lpfc_mbx_read_top_att_type, la,
+			       LPFC_FC_LA_TYPE_LINK_DOWN);
+		}
 		/* Invoke the mailbox command callback function */
 		lpfc_mbx_cmpl_read_topology(phba, pmb);
 
-- 
2.1.0

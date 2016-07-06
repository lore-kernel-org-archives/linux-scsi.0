From: james.smart@broadcom.com (James Smart)
Subject: [PATCH 15/21] lpfc: Remove global lpfc_delay_discovery attribute
 in leiu of per-hba lpfc_delay_discovery
Date: Wed, 06 Jul 2016 12:36:08 -0700
Message-ID: <577d5da8.yaONlww2cpqz4lnm%james.smart@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:38632 "EHLO
	mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755718AbcGFTgQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jul 2016 15:36:16 -0400
Received: by mail-wm0-f51.google.com with SMTP id r201so5687986wme.1
        for <linux-scsi@vger.kernel.org>; Wed, 06 Jul 2016 12:36:14 -0700 (PDT)
Received: from flash ([192.19.245.250])
        by smtp.gmail.com with ESMTPSA id a4sm4585288wjq.40.2016.07.06.12.36.11
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 06 Jul 2016 12:36:12 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Remove global lpfc_delay_discovery attribute in leiu of per-hba
lpfc_delay_discovery

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc.h      | 1 +
 drivers/scsi/lpfc/lpfc_attr.c | 8 +++-----
 drivers/scsi/lpfc/lpfc_crtn.h | 1 -
 drivers/scsi/lpfc/lpfc_els.c  | 3 ++-
 4 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index 40e069c..82d7b11 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -754,6 +754,7 @@ struct lpfc_hba {
 	uint32_t cfg_iocb_cnt;
 	uint32_t cfg_suppress_link_up;
 	uint32_t cfg_rrq_xri_bitmap_sz;
+	uint32_t cfg_delay_discovery;
 #define LPFC_INITIALIZE_LINK              0	/* do normal init_link mbox */
 #define LPFC_DELAY_INIT_LINK              1	/* layered driver hold off */
 #define LPFC_DELAY_INIT_LINK_INDEFINITELY 2	/* wait, manual intervention */
diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index 25d91a8..f5abcea 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -4815,11 +4815,8 @@ MODULE_PARM_DESC(lpfc_prot_guard, "host protection guard type");
  * accept and FCID/Fabric name/Fabric portname is changed.
  * Default value is 0.
  */
-int lpfc_delay_discovery;
-module_param(lpfc_delay_discovery, int, S_IRUGO);
-MODULE_PARM_DESC(lpfc_delay_discovery,
-	"Delay NPort discovery when Clean Address bit is cleared. "
-	"Allowed values: 0,1.");
+LPFC_ATTR(delay_discovery, 0, 0, 1,
+	"Delay NPort discovery when Clean Address bit is cleared.");
 
 /*
  * lpfc_sg_seg_cnt - Initial Maximum DMA Segment Count
@@ -5938,6 +5935,7 @@ lpfc_get_cfgparam(struct lpfc_hba *phba)
 	lpfc_request_firmware_upgrade_init(phba, lpfc_req_fw_upgrade);
 	lpfc_suppress_link_up_init(phba, lpfc_suppress_link_up);
 	lpfc_iocb_cnt_init(phba, lpfc_iocb_cnt);
+	lpfc_delay_discovery_init(phba, lpfc_delay_discovery);
 	phba->cfg_enable_dss = 1;
 	lpfc_enable_mds_diags_init(phba, lpfc_enable_mds_diags);
 	return;
diff --git a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
index b8a2ddc..9f075db 100644
--- a/drivers/scsi/lpfc/lpfc_crtn.h
+++ b/drivers/scsi/lpfc/lpfc_crtn.h
@@ -360,7 +360,6 @@ extern struct scsi_host_template lpfc_vport_template;
 extern struct fc_function_template lpfc_transport_functions;
 extern struct fc_function_template lpfc_vport_transport_functions;
 extern int lpfc_sli_mode;
-extern int lpfc_delay_discovery;
 
 int  lpfc_vport_symbolic_node_name(struct lpfc_vport *, char *, size_t);
 int  lpfc_vport_symbolic_port_name(struct lpfc_vport *, char *,	size_t);
diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 5afbf4d..c0af32f 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -594,6 +594,7 @@ static uint8_t
 lpfc_check_clean_addr_bit(struct lpfc_vport *vport,
 		struct serv_parm *sp)
 {
+	struct lpfc_hba *phba = vport->phba;
 	uint8_t fabric_param_changed = 0;
 	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
 
@@ -615,7 +616,7 @@ lpfc_check_clean_addr_bit(struct lpfc_vport *vport,
 	 * - lpfc_delay_discovery module parameter is set.
 	 */
 	if (fabric_param_changed && !sp->cmn.clean_address_bit &&
-	    (vport->fc_prevDID || lpfc_delay_discovery)) {
+	    (vport->fc_prevDID || phba->cfg_delay_discovery)) {
 		spin_lock_irq(shost->host_lock);
 		vport->fc_flag |= FC_DISC_DELAYED;
 		spin_unlock_irq(shost->host_lock);
-- 
2.5.0


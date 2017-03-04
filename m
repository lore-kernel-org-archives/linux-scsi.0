From: jsmart2021@gmail.com
Subject: [PATCH 17/20] lpfc: correct rdp diag portnames
Date: Sat,  4 Mar 2017 09:30:37 -0800
Message-ID: <1488648640-5170-18-git-send-email-jsmart2021@gmail.com>
References: <1488648640-5170-1-git-send-email-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f195.google.com ([209.85.220.195]:36600 "EHLO
        mail-qk0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752215AbdCDRbL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 4 Mar 2017 12:31:11 -0500
Received: by mail-qk0-f195.google.com with SMTP id n141so10941224qke.3
        for <linux-scsi@vger.kernel.org>; Sat, 04 Mar 2017 09:31:10 -0800 (PST)
In-Reply-To: <1488648640-5170-1-git-send-email-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org
Cc: James Smart <jsmart2021@gmail.com>, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

From: James Smart <jsmart2021@gmail.com>

NVME merge reverted diag port names to the physical port.
They should be the vport.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_els.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index d260a13..d9c61d0 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -5177,15 +5177,15 @@ lpfc_rdp_res_speed(struct fc_rdp_port_speed_desc *desc, struct lpfc_hba *phba)
 
 static uint32_t
 lpfc_rdp_res_diag_port_names(struct fc_rdp_port_name_desc *desc,
-		struct lpfc_hba *phba)
+		struct lpfc_vport *vport)
 {
 
 	desc->tag = cpu_to_be32(RDP_PORT_NAMES_DESC_TAG);
 
-	memcpy(desc->port_names.wwnn, phba->wwnn,
+	memcpy(desc->port_names.wwnn, &vport->fc_nodename,
 			sizeof(desc->port_names.wwnn));
 
-	memcpy(desc->port_names.wwpn, phba->wwpn,
+	memcpy(desc->port_names.wwpn, &vport->fc_portname,
 			sizeof(desc->port_names.wwpn));
 
 	desc->length = cpu_to_be32(sizeof(desc->port_names));
@@ -5279,7 +5279,7 @@ lpfc_els_rdp_cmpl(struct lpfc_hba *phba, struct lpfc_rdp_context *rdp_context,
 	len += lpfc_rdp_res_link_error((struct fc_rdp_link_error_status_desc *)
 				       (len + pcmd), &rdp_context->link_stat);
 	len += lpfc_rdp_res_diag_port_names((struct fc_rdp_port_name_desc *)
-					     (len + pcmd), phba);
+					     (len + pcmd), vport);
 	len += lpfc_rdp_res_attach_port_names((struct fc_rdp_port_name_desc *)
 					(len + pcmd), vport, ndlp);
 	len += lpfc_rdp_res_fec_desc((struct fc_fec_rdp_desc *)(len + pcmd),
-- 
2.5.0

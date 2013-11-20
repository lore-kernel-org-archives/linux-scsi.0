From: <vmohan@brocade.com>
Subject: [PATCH 7/8] bfa: Fix crash when symb name set for offline vport
Date: Tue, 19 Nov 2013 23:05:45 -0800
Message-ID: <1384931146-3702-8-git-send-email-vmohan@brocade.com>
References: <1384931146-3702-1-git-send-email-vmohan@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-000f0801.pphosted.com ([67.231.152.113]:52325 "EHLO
	mx0b-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751982Ab3KTHgF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Nov 2013 02:36:05 -0500
In-Reply-To: <1384931146-3702-1-git-send-email-vmohan@brocade.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: agurumur@brocade.com, james.bottomley@hansenpartnership.com

From: Vijaya Mohan Guvva <vmohan@brocade.com>

This patch fixes a crash when tried setting symbolic name for an offline
vport through sysfs. Crash is due to uninitialized pointer lport->ns,
which gets initialized only on linkup (port online).

Signed-off-by: Vijaya Mohan Guvva <vmohan@brocade.com>
---
 drivers/scsi/bfa/bfa_fcs.h       |  1 +
 drivers/scsi/bfa/bfa_fcs_lport.c | 14 +++++++++++---
 drivers/scsi/bfa/bfad_attr.c     |  7 ++-----
 3 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_fcs.h b/drivers/scsi/bfa/bfa_fcs.h
index 94d5d01..42bcb97 100644
--- a/drivers/scsi/bfa/bfa_fcs.h
+++ b/drivers/scsi/bfa/bfa_fcs.h
@@ -296,6 +296,7 @@ wwn_t bfa_fcs_lport_get_rport(struct bfa_fcs_lport_s *port, wwn_t wwn,
 struct bfa_fcs_lport_s *bfa_fcs_lookup_port(struct bfa_fcs_s *fcs,
 					    u16 vf_id, wwn_t lpwwn);
 
+void bfa_fcs_lport_set_symname(struct bfa_fcs_lport_s *port, char *symname);
 void bfa_fcs_lport_get_info(struct bfa_fcs_lport_s *port,
 			    struct bfa_lport_info_s *port_info);
 void bfa_fcs_lport_get_attr(struct bfa_fcs_lport_s *port,
diff --git a/drivers/scsi/bfa/bfa_fcs_lport.c b/drivers/scsi/bfa/bfa_fcs_lport.c
index 06bae2b..ff75ef8 100644
--- a/drivers/scsi/bfa/bfa_fcs_lport.c
+++ b/drivers/scsi/bfa/bfa_fcs_lport.c
@@ -1110,6 +1110,17 @@ bfa_fcs_lport_init(struct bfa_fcs_lport_s *lport,
 	bfa_sm_send_event(lport, BFA_FCS_PORT_SM_CREATE);
 }
 
+void
+bfa_fcs_lport_set_symname(struct bfa_fcs_lport_s *port,
+				char *symname)
+{
+	strcpy(port->port_cfg.sym_name.symname, symname);
+
+	if (bfa_sm_cmp_state(port, bfa_fcs_lport_sm_online))
+		bfa_fcs_lport_ns_util_send_rspn_id(
+			BFA_FCS_GET_NS_FROM_PORT(port), NULL);
+}
+
 /*
  *  fcs_lport_api
  */
@@ -5153,9 +5164,6 @@ bfa_fcs_lport_ns_util_send_rspn_id(void *cbarg, struct bfa_fcxp_s *fcxp_alloced)
 	u8 *psymbl = &symbl[0];
 	int len;
 
-	if (!bfa_sm_cmp_state(port, bfa_fcs_lport_sm_online))
-		return;
-
 	/* Avoid sending RSPN in the following states. */
 	if (bfa_sm_cmp_state(ns, bfa_fcs_lport_ns_sm_offline) ||
 	    bfa_sm_cmp_state(ns, bfa_fcs_lport_ns_sm_plogi_sending) ||
diff --git a/drivers/scsi/bfa/bfad_attr.c b/drivers/scsi/bfa/bfad_attr.c
index e9a681d..40be670 100644
--- a/drivers/scsi/bfa/bfad_attr.c
+++ b/drivers/scsi/bfa/bfad_attr.c
@@ -593,11 +593,8 @@ bfad_im_vport_set_symbolic_name(struct fc_vport *fc_vport)
 		return;
 
 	spin_lock_irqsave(&bfad->bfad_lock, flags);
-	if (strlen(sym_name) > 0) {
-		strcpy(fcs_vport->lport.port_cfg.sym_name.symname, sym_name);
-		bfa_fcs_lport_ns_util_send_rspn_id(
-			BFA_FCS_GET_NS_FROM_PORT((&fcs_vport->lport)), NULL);
-	}
+	if (strlen(sym_name) > 0)
+		bfa_fcs_lport_set_symname(&fcs_vport->lport, sym_name);
 	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
 }
 
-- 
1.8.2.1


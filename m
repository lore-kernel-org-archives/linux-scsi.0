From: <kgudipat@brocade.com>
Subject: [PATCH 01/10] bfa: Support vport symbolic name change from sysfs.
Date: Wed, 22 Aug 2012 19:50:20 -0700
Message-ID: <1345690220-20426-1-git-send-email-kgudipat@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-000f0801.pphosted.com ([67.231.152.113]:59001 "EHLO
	mx0b-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754698Ab2HWCuu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Aug 2012 22:50:50 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@Parallels.com, linux-scsi@vger.kernel.org
Cc: adapter_linux_open_src_team@brocade.com, Krishna Gudipati <kgudipat@brocade.com>

From: Krishna Gudipati <kgudipat@brocade.com>

Change details:
	- Implemented the FC function template set_vport_symbolic_name entry
	  point to modify the vport symbolic name from sysfs.
	- Implemented support to send RSPN_ID to switch to register the
	  modified vport symbolic name.

Signed-off-by: Krishna Gudipati <kgudipat@brocade.com>
---
 drivers/scsi/bfa/bfa_fcs.h       |    2 +
 drivers/scsi/bfa/bfa_fcs_lport.c |   63 ++++++++++++++++++++++++++++++++++++++
 drivers/scsi/bfa/bfad_attr.c     |   32 +++++++++++++++++++
 3 files changed, 97 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_fcs.h b/drivers/scsi/bfa/bfa_fcs.h
index 51c9e13..050a7e9 100644
--- a/drivers/scsi/bfa/bfa_fcs.h
+++ b/drivers/scsi/bfa/bfa_fcs.h
@@ -338,6 +338,8 @@ void            bfa_fcs_lport_ns_init(struct bfa_fcs_lport_s *vport);
 void            bfa_fcs_lport_ns_offline(struct bfa_fcs_lport_s *vport);
 void            bfa_fcs_lport_ns_online(struct bfa_fcs_lport_s *vport);
 void            bfa_fcs_lport_ns_query(struct bfa_fcs_lport_s *port);
+void		bfa_fcs_lport_ns_util_send_rspn_id(void *cbarg,
+				struct bfa_fcxp_s *fcxp_alloced);
 void            bfa_fcs_lport_scn_init(struct bfa_fcs_lport_s *vport);
 void            bfa_fcs_lport_scn_offline(struct bfa_fcs_lport_s *vport);
 void            bfa_fcs_lport_scn_online(struct bfa_fcs_lport_s *vport);
diff --git a/drivers/scsi/bfa/bfa_fcs_lport.c b/drivers/scsi/bfa/bfa_fcs_lport.c
index bcc4966..f8e8017 100644
--- a/drivers/scsi/bfa/bfa_fcs_lport.c
+++ b/drivers/scsi/bfa/bfa_fcs_lport.c
@@ -4355,6 +4355,69 @@ bfa_fcs_lport_ns_boot_target_disc(bfa_fcs_lport_t *port)
 	}
 }
 
+void
+bfa_fcs_lport_ns_util_send_rspn_id(void *cbarg, struct bfa_fcxp_s *fcxp_alloced)
+{
+	struct bfa_fcs_lport_ns_s *ns = cbarg;
+	struct bfa_fcs_lport_s *port = ns->port;
+	struct fchs_s fchs;
+	struct bfa_fcxp_s *fcxp;
+	u8 symbl[256];
+	u8 *psymbl = &symbl[0];
+	int len;
+
+	if (!bfa_sm_cmp_state(port, bfa_fcs_lport_sm_online))
+		return;
+
+	/* Avoid sending RSPN in the following states. */
+	if (bfa_sm_cmp_state(ns, bfa_fcs_lport_ns_sm_offline) ||
+	    bfa_sm_cmp_state(ns, bfa_fcs_lport_ns_sm_plogi_sending) ||
+	    bfa_sm_cmp_state(ns, bfa_fcs_lport_ns_sm_plogi) ||
+	    bfa_sm_cmp_state(ns, bfa_fcs_lport_ns_sm_plogi_retry) ||
+	    bfa_sm_cmp_state(ns, bfa_fcs_lport_ns_sm_rspn_id_retry))
+		return;
+
+	memset(symbl, 0, sizeof(symbl));
+	bfa_trc(port->fcs, port->port_cfg.pwwn);
+
+	fcxp = fcxp_alloced ? fcxp_alloced : bfa_fcs_fcxp_alloc(port->fcs);
+	if (!fcxp) {
+		port->stats.ns_rspnid_alloc_wait++;
+		bfa_fcs_fcxp_alloc_wait(port->fcs->bfa, &ns->fcxp_wqe,
+				bfa_fcs_lport_ns_util_send_rspn_id, ns);
+		return;
+	}
+
+	ns->fcxp = fcxp;
+
+	if (port->vport) {
+		/*
+		 * For Vports, we append the vport's port symbolic name
+		 * to that of the base port.
+		 */
+		strncpy((char *)psymbl, (char *)&(bfa_fcs_lport_get_psym_name
+			(bfa_fcs_get_base_port(port->fcs))),
+			strlen((char *)&bfa_fcs_lport_get_psym_name(
+			bfa_fcs_get_base_port(port->fcs))));
+
+		/* Ensure we have a null terminating string. */
+		((char *)psymbl)[strlen((char *)&bfa_fcs_lport_get_psym_name(
+		 bfa_fcs_get_base_port(port->fcs)))] = 0;
+
+		strncat((char *)psymbl,
+			(char *)&(bfa_fcs_lport_get_psym_name(port)),
+			strlen((char *)&bfa_fcs_lport_get_psym_name(port)));
+	}
+
+	len = fc_rspnid_build(&fchs, bfa_fcxp_get_reqbuf(fcxp),
+			      bfa_fcs_lport_get_fcid(port), 0, psymbl);
+
+	bfa_fcxp_send(fcxp, NULL, port->fabric->vf_id, port->lp_tag, BFA_FALSE,
+		      FC_CLASS_3, len, &fchs, NULL, NULL, FC_MAX_PDUSZ, 0);
+
+	port->stats.ns_rspnid_sent++;
+}
+
 /*
  * FCS SCN
  */
diff --git a/drivers/scsi/bfa/bfad_attr.c b/drivers/scsi/bfa/bfad_attr.c
index b839274..1d18a80 100644
--- a/drivers/scsi/bfa/bfad_attr.c
+++ b/drivers/scsi/bfa/bfad_attr.c
@@ -587,6 +587,37 @@ bfad_im_vport_disable(struct fc_vport *fc_vport, bool disable)
 	return 0;
 }
 
+void
+bfad_im_vport_set_symbolic_name(struct fc_vport *fc_vport)
+{
+	struct bfad_vport_s *vport = (struct bfad_vport_s *)fc_vport->dd_data;
+	struct bfad_im_port_s *im_port =
+			(struct bfad_im_port_s *)vport->drv_port.im_port;
+	struct bfad_s *bfad = im_port->bfad;
+	struct Scsi_Host *vshost = vport->drv_port.im_port->shost;
+	char *sym_name = fc_vport->symbolic_name;
+	struct bfa_fcs_vport_s *fcs_vport;
+	wwn_t	pwwn;
+	unsigned long flags;
+
+	u64_to_wwn(fc_host_port_name(vshost), (u8 *)&pwwn);
+
+	spin_lock_irqsave(&bfad->bfad_lock, flags);
+	fcs_vport = bfa_fcs_vport_lookup(&bfad->bfa_fcs, 0, pwwn);
+	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+
+	if (fcs_vport == NULL)
+		return;
+
+	spin_lock_irqsave(&bfad->bfad_lock, flags);
+	if (strlen(sym_name) > 0) {
+		strcpy(fcs_vport->lport.port_cfg.sym_name.symname, sym_name);
+		bfa_fcs_lport_ns_util_send_rspn_id(
+			BFA_FCS_GET_NS_FROM_PORT((&fcs_vport->lport)), NULL);
+	}
+	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+}
+
 struct fc_function_template bfad_im_fc_function_template = {
 
 	/* Target dynamic attributes */
@@ -640,6 +671,7 @@ struct fc_function_template bfad_im_fc_function_template = {
 	.vport_create = bfad_im_vport_create,
 	.vport_delete = bfad_im_vport_delete,
 	.vport_disable = bfad_im_vport_disable,
+	.set_vport_symbolic_name = bfad_im_vport_set_symbolic_name,
 	.bsg_request = bfad_im_bsg_request,
 	.bsg_timeout = bfad_im_bsg_timeout,
 };
-- 
1.7.3.rc1


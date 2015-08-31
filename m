From: james.smart@avagotech.com (James Smart)
Subject: [PATCH 13/14] lpfc: Fix default RA_TOV and ED_TOV in the FC/FCoE
 driver for all topologies
Date: Mon, 31 Aug 2015 16:48:21 -0400
Message-ID: <55e4bd95.zMd4O6V0Gs9gSANh%james.smart@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f172.google.com ([209.85.220.172]:33181 "EHLO
	mail-qk0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753277AbbHaUsh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Aug 2015 16:48:37 -0400
Received: by qkdv1 with SMTP id v1so16763292qkd.0
        for <linux-scsi@vger.kernel.org>; Mon, 31 Aug 2015 13:48:36 -0700 (PDT)
Received: from myfc17 (c-75-67-235-135.hsd1.nh.comcast.net. [75.67.235.135])
        by smtp.gmail.com with ESMTPSA id 64sm9449716qhe.9.2015.08.31.13.48.35
        for <linux-scsi@vger.kernel.org>
        (version=TLSv1 cipher=RC4-SHA bits=128/128);
        Mon, 31 Aug 2015 13:48:35 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Fix default RA_TOV and ED_TOV in the FC/FCoE driver for all topologies

Initial link up defaults were not properly being tracked relative to
initial FLOGI or pt2pt PLOGI. Add code to initialize them.

Signed-off-by: Dick Kennedy <dick.kennedy@avagotech.com>
Signed-off-by: James Smart <james.smart@avagotech.com>
---
 drivers/scsi/lpfc/lpfc_hbadisc.c | 15 ++++++++++++++-
 drivers/scsi/lpfc/lpfc_hw.h      |  2 +-
 2 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 614d8e9..bfc2442 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -2974,7 +2974,8 @@ lpfc_mbx_cmpl_read_sparam(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 	MAILBOX_t *mb = &pmb->u.mb;
 	struct lpfc_dmabuf *mp = (struct lpfc_dmabuf *) pmb->context1;
 	struct lpfc_vport  *vport = pmb->vport;
-
+	struct serv_parm *sp = &vport->fc_sparam;
+	uint32_t ed_tov;
 
 	/* Check for error */
 	if (mb->mbxStatus) {
@@ -2989,6 +2990,18 @@ lpfc_mbx_cmpl_read_sparam(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 
 	memcpy((uint8_t *) &vport->fc_sparam, (uint8_t *) mp->virt,
 	       sizeof (struct serv_parm));
+
+	ed_tov = be32_to_cpu(sp->cmn.e_d_tov);
+	if (sp->cmn.edtovResolution)	/* E_D_TOV ticks are in nanoseconds */
+		ed_tov = (ed_tov + 999999) / 1000000;
+
+	phba->fc_edtov = ed_tov;
+	phba->fc_ratov = (2 * ed_tov) / 1000;
+	if (phba->fc_ratov < FF_DEF_RATOV) {
+		/* RA_TOV should be atleast 10sec for initial flogi */
+		phba->fc_ratov = FF_DEF_RATOV;
+	}
+
 	lpfc_update_vport_wwn(vport);
 	if (vport->port_type == LPFC_PHYSICAL_PORT) {
 		memcpy(&phba->wwnn, &vport->fc_nodename, sizeof(phba->wwnn));
diff --git a/drivers/scsi/lpfc/lpfc_hw.h b/drivers/scsi/lpfc/lpfc_hw.h
index f73b6e1..2cce88e 100644
--- a/drivers/scsi/lpfc/lpfc_hw.h
+++ b/drivers/scsi/lpfc/lpfc_hw.h
@@ -33,7 +33,7 @@
 
 #define FF_DEF_EDTOV          2000	/* Default E_D_TOV (2000ms) */
 #define FF_DEF_ALTOV            15	/* Default AL_TIME (15ms) */
-#define FF_DEF_RATOV             2	/* Default RA_TOV (2s) */
+#define FF_DEF_RATOV            10	/* Default RA_TOV (10s) */
 #define FF_DEF_ARBTOV         1900	/* Default ARB_TOV (1900ms) */
 
 #define LPFC_BUF_RING0        64	/* Number of buffers to post to RING
-- 
1.7.11.7


From: <kgudipat@brocade.com>
Subject: [PATCH 5/6] bfa: io tag handling and minor bug fix.
Date: Mon, 13 Dec 2010 16:23:27 -0800
Message-ID: <1292286207-15427-1-git-send-email-kgudipat@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-000f0801.pphosted.com ([67.231.144.122]:59140 "EHLO
	mx0a-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750848Ab0LNAXx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Dec 2010 19:23:53 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: huangj@brocade.com, vravindr@brocade.com, rvadivel@brocade.com, amathur@brocade.com, adapter_linux_open_src_team@brocade.com, kgudipat@brocade.com

From: Krishna Gudipati <kgudipat@brocade.com>

Fix iotag handling:
	1) Update and check io tag for retry case.
	2) Clearing upper 3 bits in io tag when an IO completes.
	   The 3 upper bits in io tags are used for counting FCP exchange retry.
	   Un-cleared bits will cause firmware to access invalid memory when the
	   same io tag is used for an IO to a target that doesn't support FCP
	   exchange retry.
	3) Only check the effective bits when validating an iotag.

Other minor fixes:
	1) Added trace to get FC header type with assert of unhandled packet received.
	   Ignore the type FC_TYPE_FC_FSS (FC_XS).
	2) Fixed the adapter info display check - to check for fcmode flag even.

Signed-off-by: Krishna Gudipati <kgudipat@brocade.com>
---
 drivers/scsi/bfa/bfa_fcpim.c     |    8 +++++---
 drivers/scsi/bfa/bfa_fcpim.h     |   22 ++++++++++++----------
 drivers/scsi/bfa/bfa_fcs_lport.c |    8 ++++++--
 drivers/scsi/bfa/bfad_im.c       |    2 +-
 4 files changed, 24 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_fcpim.c b/drivers/scsi/bfa/bfa_fcpim.c
index 314c931..5e697f2 100644
--- a/drivers/scsi/bfa/bfa_fcpim.c
+++ b/drivers/scsi/bfa/bfa_fcpim.c
@@ -1540,8 +1540,8 @@ bfa_ioim_sm_active(struct bfa_ioim_s *ioim, enum bfa_ioim_event event)
 		break;
 
 	case BFA_IOIM_SM_SQRETRY:
-		if (bfa_ioim_get_iotag(ioim) != BFA_TRUE) {
-			/* max retry completed free IO */
+		if (bfa_ioim_maxretry_reached(ioim)) {
+			/* max retry reached, free IO */
 			bfa_sm_set_state(ioim, bfa_ioim_sm_hcb_free);
 			bfa_ioim_move_to_comp_q(ioim);
 			bfa_cb_queue(ioim->bfa, &ioim->hcb_qe,
@@ -1569,6 +1569,7 @@ bfa_ioim_sm_cmnd_retry(struct bfa_ioim_s *ioim, enum bfa_ioim_event event)
 	switch (event) {
 	case BFA_IOIM_SM_FREE:
 		/* abts and rrq done. Now retry the IO with new tag */
+		bfa_ioim_update_iotag(ioim);
 		if (!bfa_ioim_send_ioreq(ioim)) {
 			bfa_sm_set_state(ioim, bfa_ioim_sm_qfull);
 			break;
@@ -2526,7 +2527,7 @@ bfa_ioim_good_comp_isr(struct bfa_s *bfa, struct bfi_msg_s *m)
 	iotag = be16_to_cpu(rsp->io_tag);
 
 	ioim = BFA_IOIM_FROM_TAG(fcpim, iotag);
-	bfa_assert(ioim->iotag == iotag);
+	bfa_assert(BFA_IOIM_TAG_2_ID(ioim->iotag) == iotag);
 
 	bfa_trc_fp(ioim->bfa, ioim->iotag);
 	bfa_ioim_cb_profile_comp(fcpim, ioim);
@@ -2629,6 +2630,7 @@ bfa_ioim_free(struct bfa_ioim_s *ioim)
 	bfa_stats(ioim->itnim, io_comps);
 	fcpim->ios_active--;
 
+	ioim->iotag &= BFA_IOIM_IOTAG_MASK;
 	list_del(&ioim->qe);
 	list_add_tail(&ioim->qe, &fcpim->ioim_free_q);
 }
diff --git a/drivers/scsi/bfa/bfa_fcpim.h b/drivers/scsi/bfa/bfa_fcpim.h
index f933458..1e38dad 100644
--- a/drivers/scsi/bfa/bfa_fcpim.h
+++ b/drivers/scsi/bfa/bfa_fcpim.h
@@ -41,7 +41,7 @@
 	(__itnim->ioprofile.iocomps[__index]++)
 
 #define BFA_IOIM_RETRY_TAG_OFFSET 11
-#define BFA_IOIM_RETRY_TAG_MASK 0x07ff /* 2K IOs */
+#define BFA_IOIM_IOTAG_MASK 0x07ff /* 2K IOs */
 #define BFA_IOIM_RETRY_MAX 7
 
 /* Buckets are are 512 bytes to 2MB */
@@ -189,8 +189,9 @@ struct bfa_itnim_s {
 
 #define bfa_itnim_is_online(_itnim) ((_itnim)->is_online)
 #define BFA_FCPIM_MOD(_hal) (&(_hal)->modules.fcpim_mod)
+#define BFA_IOIM_TAG_2_ID(_iotag)	((_iotag) & BFA_IOIM_IOTAG_MASK)
 #define BFA_IOIM_FROM_TAG(_fcpim, _iotag)	\
-	(&fcpim->ioim_arr[(_iotag & BFA_IOIM_RETRY_TAG_MASK)])
+	(&fcpim->ioim_arr[(_iotag & BFA_IOIM_IOTAG_MASK)])
 #define BFA_TSKIM_FROM_TAG(_fcpim, _tmtag)	\
 	(&fcpim->tskim_arr[_tmtag & (fcpim->num_tskim_reqs - 1)])
 
@@ -198,20 +199,21 @@ struct bfa_itnim_s {
 	(_bfa->modules.fcpim_mod.io_profile_start_time)
 #define bfa_fcpim_get_io_profile(_bfa)	\
 	(_bfa->modules.fcpim_mod.io_profile)
+#define bfa_ioim_update_iotag(__ioim) do {				\
+	uint16_t k = (__ioim)->iotag >> BFA_IOIM_RETRY_TAG_OFFSET;	\
+	k++; (__ioim)->iotag &= BFA_IOIM_IOTAG_MASK;			\
+	(__ioim)->iotag |= k << BFA_IOIM_RETRY_TAG_OFFSET;		\
+} while (0)
 
 static inline bfa_boolean_t
-bfa_ioim_get_iotag(struct bfa_ioim_s *ioim)
+bfa_ioim_maxretry_reached(struct bfa_ioim_s *ioim)
 {
-	u16 k = ioim->iotag;
-
-	k >>= BFA_IOIM_RETRY_TAG_OFFSET; k++;
-
-	if (k > BFA_IOIM_RETRY_MAX)
+	uint16_t k = ioim->iotag >> BFA_IOIM_RETRY_TAG_OFFSET;
+	if (k < BFA_IOIM_RETRY_MAX)
 		return BFA_FALSE;
-	ioim->iotag &= BFA_IOIM_RETRY_TAG_MASK;
-	ioim->iotag |= k<<BFA_IOIM_RETRY_TAG_OFFSET;
 	return BFA_TRUE;
 }
+
 /*
  * function prototypes
  */
diff --git a/drivers/scsi/bfa/bfa_fcs_lport.c b/drivers/scsi/bfa/bfa_fcs_lport.c
index a153646..74d7be9 100644
--- a/drivers/scsi/bfa/bfa_fcs_lport.c
+++ b/drivers/scsi/bfa/bfa_fcs_lport.c
@@ -604,6 +604,7 @@ bfa_fcs_lport_uf_recv(struct bfa_fcs_lport_s *lport,
 	struct fc_els_cmd_s *els_cmd = (struct fc_els_cmd_s *) (fchs + 1);
 
 	bfa_stats(lport, uf_recvs);
+	bfa_trc(lport->fcs, fchs->type);
 
 	if (!bfa_fcs_lport_is_online(lport)) {
 		bfa_stats(lport, uf_recv_drops);
@@ -663,8 +664,11 @@ bfa_fcs_lport_uf_recv(struct bfa_fcs_lport_s *lport,
 	 * Only handles ELS frames for now.
 	 */
 	if (fchs->type != FC_TYPE_ELS) {
-		bfa_trc(lport->fcs, fchs->type);
-		bfa_assert(0);
+		bfa_trc(lport->fcs, fchs->s_id);
+		bfa_trc(lport->fcs, fchs->d_id);
+		/* ignore type FC_TYPE_FC_FSS */
+		if(fchs->type != FC_TYPE_FC_FSS)
+			bfa_sm_fault(lport->fcs, fchs->type);
 		return;
 	}
 
diff --git a/drivers/scsi/bfa/bfad_im.c b/drivers/scsi/bfa/bfad_im.c
index 95761ca..e15b6b6 100644
--- a/drivers/scsi/bfa/bfad_im.c
+++ b/drivers/scsi/bfa/bfad_im.c
@@ -182,7 +182,7 @@ bfad_im_info(struct Scsi_Host *shost)
 	bfa_get_adapter_model(bfa, model);
 
 	memset(bfa_buf, 0, sizeof(bfa_buf));
-	if (ioc->ctdev)
+	if (ioc->ctdev && !ioc->fcmode)
 		snprintf(bfa_buf, sizeof(bfa_buf),
 		"Brocade FCOE Adapter, " "model: %s hwpath: %s driver: %s",
 		 model, bfad->pci_name, BFAD_DRIVER_VERSION);
-- 
1.7.3.rc1


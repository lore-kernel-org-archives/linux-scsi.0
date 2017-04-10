From: NeilBrown <neilb@suse.com>
Subject: [PATCH] scsi: lpfc: don't check for failure of mempool_alloc()
Date: Mon, 10 Apr 2017 12:04:10 +1000
Message-ID: <87poglxbl1.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42141 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751004AbdDJCFZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 9 Apr 2017 22:05:25 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@broadcom.com>, Dick Kennedy <dick.kennedy@broadcom.com>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


mempool_alloc() cannot fail if the gfp flags allow sleeping,
specifically if __GFP_DIRECT_RECLAIM is included.
GFP_KERNEL includes this flag and allows sleeping, so
none of this error checking provides any value.

Signed-off-by: NeilBrown <neilb@suse.com>
=2D--
 drivers/scsi/lpfc/lpfc_attr.c      |   9 --
 drivers/scsi/lpfc/lpfc_bsg.c       |  32 -----
 drivers/scsi/lpfc/lpfc_els.c       | 118 ++++------------
 drivers/scsi/lpfc/lpfc_hbadisc.c   | 270 +++++++++++++++------------------=
----
 drivers/scsi/lpfc/lpfc_init.c      |  89 ------------
 drivers/scsi/lpfc/lpfc_mbox.c      |  34 +++--
 drivers/scsi/lpfc/lpfc_nportdisc.c |  38 +-----
 drivers/scsi/lpfc/lpfc_nvme.c      |   6 -
 drivers/scsi/lpfc/lpfc_sli.c       | 131 ------------------
 drivers/scsi/lpfc/lpfc_vport.c     |   5 -
 10 files changed, 153 insertions(+), 579 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index 22819afbaef5..33f45d3d7487 100644
=2D-- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -856,9 +856,6 @@ lpfc_issue_lip(struct Scsi_Host *shost)
=20
 	pmboxq =3D mempool_alloc(phba->mbox_mem_pool,GFP_KERNEL);
=20
=2D	if (!pmboxq)
=2D		return -ENOMEM;
=2D
 	memset((void *)pmboxq, 0, sizeof (LPFC_MBOXQ_t));
 	pmboxq->u.mb.mbxCommand =3D MBX_DOWN_LINK;
 	pmboxq->u.mb.mbxOwner =3D OWN_HOST;
@@ -1411,8 +1408,6 @@ lpfc_get_hba_info(struct lpfc_hba *phba,
 		return 0;
=20
 	pmboxq =3D mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
=2D	if (!pmboxq)
=2D		return 0;
 	memset(pmboxq, 0, sizeof (LPFC_MBOXQ_t));
=20
 	pmb =3D &pmboxq->u.mb;
@@ -5670,8 +5665,6 @@ lpfc_get_stats(struct Scsi_Host *shost)
 		return NULL;
=20
 	pmboxq =3D mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
=2D	if (!pmboxq)
=2D		return NULL;
 	memset(pmboxq, 0, sizeof (LPFC_MBOXQ_t));
=20
 	pmb =3D &pmboxq->u.mb;
@@ -5786,8 +5779,6 @@ lpfc_reset_stats(struct Scsi_Host *shost)
 		return;
=20
 	pmboxq =3D mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
=2D	if (!pmboxq)
=2D		return;
 	memset(pmboxq, 0, sizeof(LPFC_MBOXQ_t));
=20
 	pmb =3D &pmboxq->u.mb;
diff --git a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
index 18157d2840a3..7b3fcfabede1 100644
=2D-- a/drivers/scsi/lpfc/lpfc_bsg.c
+++ b/drivers/scsi/lpfc/lpfc_bsg.c
@@ -1828,10 +1828,6 @@ lpfc_sli3_bsg_diag_loopback_mode(struct lpfc_hba *ph=
ba, struct bsg_job *job)
 	timeout =3D loopback_mode->timeout * 100;
=20
 	pmboxq =3D mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
=2D	if (!pmboxq) {
=2D		rc =3D -ENOMEM;
=2D		goto loopback_mode_exit;
=2D	}
 	memset((void *)pmboxq, 0, sizeof(LPFC_MBOXQ_t));
 	pmboxq->u.mb.mbxCommand =3D MBX_DOWN_LINK;
 	pmboxq->u.mb.mbxOwner =3D OWN_HOST;
@@ -1921,8 +1917,6 @@ lpfc_sli4_bsg_set_link_diag_state(struct lpfc_hba *ph=
ba, uint32_t diag)
 	int mbxstatus =3D MBX_SUCCESS, rc;
=20
 	pmboxq =3D mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
=2D	if (!pmboxq)
=2D		return -ENOMEM;
=20
 	req_len =3D (sizeof(struct lpfc_mbx_set_link_diag_state) -
 		   sizeof(struct lpfc_sli4_cfg_mhdr));
@@ -1982,8 +1976,6 @@ lpfc_sli4_bsg_set_internal_loopback(struct lpfc_hba *=
phba)
 	int mbxstatus =3D MBX_SUCCESS, rc =3D 0;
=20
 	pmboxq =3D mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
=2D	if (!pmboxq)
=2D		return -ENOMEM;
 	req_len =3D (sizeof(struct lpfc_mbx_set_link_diag_loopback) -
 		   sizeof(struct lpfc_sli4_cfg_mhdr));
 	alloc_len =3D lpfc_sli4_config(phba, pmboxq, LPFC_MBOX_SUBSYSTEM_FCOE,
@@ -2384,10 +2376,6 @@ lpfc_sli4_bsg_link_diag_test(struct bsg_job *job)
 		goto job_error;
=20
 	pmboxq =3D mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
=2D	if (!pmboxq) {
=2D		rc =3D -ENOMEM;
=2D		goto link_diag_test_exit;
=2D	}
=20
 	req_len =3D (sizeof(struct lpfc_mbx_set_link_diag_state) -
 		   sizeof(struct lpfc_sli4_cfg_mhdr));
@@ -2477,8 +2465,6 @@ static int lpfcdiag_loop_self_reg(struct lpfc_hba *ph=
ba, uint16_t *rpi)
 	int status;
=20
 	mbox =3D mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
=2D	if (!mbox)
=2D		return -ENOMEM;
=20
 	if (phba->sli_rev < LPFC_SLI_REV4)
 		status =3D lpfc_reg_rpi(phba, 0, phba->pport->fc_myDID,
@@ -2537,8 +2523,6 @@ static int lpfcdiag_loop_self_unreg(struct lpfc_hba *=
phba, uint16_t rpi)
=20
 	/* Allocate mboxq structure */
 	mbox =3D mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
=2D	if (mbox =3D=3D NULL)
=2D		return -ENOMEM;
=20
 	if (phba->sli_rev < LPFC_SLI_REV4)
 		lpfc_unreg_login(phba, 0, rpi, mbox);
@@ -3917,10 +3901,6 @@ lpfc_bsg_sli_cfg_read_cmd_ext(struct lpfc_hba *phba,=
 struct bsg_job *job,
=20
 	/* mailbox command structure for base driver */
 	pmboxq =3D mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
=2D	if (!pmboxq) {
=2D		rc =3D -ENOMEM;
=2D		goto job_error;
=2D	}
 	memset(pmboxq, 0, sizeof(LPFC_MBOXQ_t));
=20
 	/* for the first external buffer */
@@ -4117,10 +4097,6 @@ lpfc_bsg_sli_cfg_write_cmd_ext(struct lpfc_hba *phba=
, struct bsg_job *job,
=20
 		/* mailbox command structure for base driver */
 		pmboxq =3D mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
=2D		if (!pmboxq) {
=2D			rc =3D -ENOMEM;
=2D			goto job_error;
=2D		}
 		memset(pmboxq, 0, sizeof(LPFC_MBOXQ_t));
 		pmb =3D &pmboxq->u.mb;
 		mbx =3D (uint8_t *)dmabuf->virt;
@@ -4462,10 +4438,6 @@ lpfc_bsg_write_ebuf_set(struct lpfc_hba *phba, struc=
t bsg_job *job,
 				phba->mbox_ext_buf_ctx.numBuf);
 		/* mailbox command structure for base driver */
 		pmboxq =3D mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
=2D		if (!pmboxq) {
=2D			rc =3D -ENOMEM;
=2D			goto job_error;
=2D		}
 		memset(pmboxq, 0, sizeof(LPFC_MBOXQ_t));
 		pbuf =3D (uint8_t *)phba->mbox_ext_buf_ctx.mbx_dmabuf->virt;
 		pmb =3D &pmboxq->u.mb;
@@ -4734,10 +4706,6 @@ lpfc_bsg_issue_mbox(struct lpfc_hba *phba, struct bs=
g_job *job,
 	}
=20
 	pmboxq =3D mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
=2D	if (!pmboxq) {
=2D		rc =3D -ENOMEM;
=2D		goto job_done;
=2D	}
 	memset(pmboxq, 0, sizeof(LPFC_MBOXQ_t));
=20
 	pmb =3D &pmboxq->u.mb;
diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index a5ca37e45fb6..2c8b05487974 100644
=2D-- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -380,11 +380,6 @@ lpfc_issue_fabric_reglogin(struct lpfc_vport *vport)
 	}
=20
 	mbox =3D mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
=2D	if (!mbox) {
=2D		err =3D 2;
=2D		goto fail;
=2D	}
=2D
 	vport->port_state =3D LPFC_FABRIC_CFG_LINK;
 	lpfc_config_link(phba, mbox);
 	mbox->mbox_cmpl =3D lpfc_sli_def_mbox_cmpl;
@@ -397,10 +392,6 @@ lpfc_issue_fabric_reglogin(struct lpfc_vport *vport)
 	}
=20
 	mbox =3D mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
=2D	if (!mbox) {
=2D		err =3D 4;
=2D		goto fail;
=2D	}
 	rc =3D lpfc_reg_rpi(phba, vport->vpi, Fabric_DID, (uint8_t *)sp, mbox,
 			  ndlp->nlp_rpi);
 	if (rc) {
@@ -473,11 +464,6 @@ lpfc_issue_reg_vfi(struct lpfc_vport *vport)
 	}
=20
 	mboxq =3D mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
=2D	if (!mboxq) {
=2D		rc =3D -ENOMEM;
=2D		goto fail;
=2D	}
=2D
 	/* Supply CSP's only if we are fabric connect or pt-to-pt connect */
 	if ((vport->fc_flag & FC_FABRIC) || (vport->fc_flag & FC_PT2PT)) {
 		dmabuf =3D kzalloc(sizeof(struct lpfc_dmabuf), GFP_KERNEL);
@@ -545,12 +531,6 @@ lpfc_issue_unreg_vfi(struct lpfc_vport *vport)
 	int rc;
=20
 	mboxq =3D mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
=2D	if (!mboxq) {
=2D		lpfc_printf_log(phba, KERN_ERR, LOG_DISCOVERY|LOG_MBOX,
=2D				"2556 UNREG_VFI mbox allocation failed"
=2D				"HBA state x%x\n", phba->pport->port_state);
=2D		return -ENOMEM;
=2D	}
=20
 	lpfc_unreg_vfi(mboxq, vport);
 	mboxq->vport =3D vport;
@@ -896,8 +876,6 @@ lpfc_cmpl_els_flogi_nport(struct lpfc_vport *vport, str=
uct lpfc_nodelist *ndlp,
 			 * new one
 			 */
 			ndlp =3D mempool_alloc(phba->nlp_mem_pool, GFP_KERNEL);
=2D			if (!ndlp)
=2D				goto fail;
 			lpfc_nlp_init(vport, ndlp, PT2PT_RemoteID);
 		} else if (!NLP_CHK_NODE_ACT(ndlp)) {
 			ndlp =3D lpfc_enable_node(vport, ndlp,
@@ -926,8 +904,6 @@ lpfc_cmpl_els_flogi_nport(struct lpfc_vport *vport, str=
uct lpfc_nodelist *ndlp,
 	phba->sli3_options &=3D ~LPFC_SLI3_NPIV_ENABLED;
=20
 	mbox =3D mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
=2D	if (!mbox)
=2D		goto fail;
=20
 	lpfc_config_link(phba, mbox);
=20
@@ -1375,8 +1351,6 @@ lpfc_initial_flogi(struct lpfc_vport *vport)
 	if (!ndlp) {
 		/* Cannot find existing Fabric ndlp, so allocate a new one */
 		ndlp =3D mempool_alloc(phba->nlp_mem_pool, GFP_KERNEL);
=2D		if (!ndlp)
=2D			return 0;
 		lpfc_nlp_init(vport, ndlp, Fabric_DID);
 		/* Set the node type */
 		ndlp->nlp_type |=3D NLP_FABRIC;
@@ -1426,8 +1400,6 @@ lpfc_initial_fdisc(struct lpfc_vport *vport)
 	if (!ndlp) {
 		/* Cannot find existing Fabric ndlp, so allocate a new one */
 		ndlp =3D mempool_alloc(phba->nlp_mem_pool, GFP_KERNEL);
=2D		if (!ndlp)
=2D			return 0;
 		lpfc_nlp_init(vport, ndlp, Fabric_DID);
 		/* Put ndlp onto node list */
 		lpfc_enqueue_node(vport, ndlp);
@@ -1546,9 +1518,8 @@ lpfc_plogi_confirm_nport(struct lpfc_hba *phba, uint3=
2_t *prsp,
 	if (phba->sli_rev =3D=3D LPFC_SLI_REV4) {
 		active_rrqs_xri_bitmap =3D mempool_alloc(phba->active_rrq_pool,
 						       GFP_KERNEL);
=2D		if (active_rrqs_xri_bitmap)
=2D			memset(active_rrqs_xri_bitmap, 0,
=2D			       phba->cfg_rrq_xri_bitmap_sz);
+		memset(active_rrqs_xri_bitmap, 0,
+		       phba->cfg_rrq_xri_bitmap_sz);
 	}
=20
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
@@ -2645,15 +2616,14 @@ lpfc_cmpl_els_logo(struct lpfc_hba *phba, struct lp=
fc_iocbq *cmdiocb,
 		}
=20
 		mbox =3D mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
=2D		if (mbox) {
=2D			lpfc_config_link(phba, mbox);
=2D			mbox->mbox_cmpl =3D lpfc_sli_def_mbox_cmpl;
=2D			mbox->vport =3D vport;
=2D			if (lpfc_sli_issue_mbox(phba, mbox, MBX_NOWAIT) =3D=3D
=2D				MBX_NOT_FINISHED) {
=2D				mempool_free(mbox, phba->mbox_mem_pool);
=2D				skip_recovery =3D 1;
=2D			}
+
+		lpfc_config_link(phba, mbox);
+		mbox->mbox_cmpl =3D lpfc_sli_def_mbox_cmpl;
+		mbox->vport =3D vport;
+		if (lpfc_sli_issue_mbox(phba, mbox, MBX_NOWAIT) =3D=3D
+		    MBX_NOT_FINISHED) {
+			mempool_free(mbox, phba->mbox_mem_pool);
+			skip_recovery =3D 1;
 		}
 	}
=20
@@ -2846,8 +2816,6 @@ lpfc_issue_els_scr(struct lpfc_vport *vport, uint32_t=
 nportid, uint8_t retry)
 	ndlp =3D lpfc_findnode_did(vport, nportid);
 	if (!ndlp) {
 		ndlp =3D mempool_alloc(phba->nlp_mem_pool, GFP_KERNEL);
=2D		if (!ndlp)
=2D			return 1;
 		lpfc_nlp_init(vport, ndlp, nportid);
 		lpfc_enqueue_node(vport, ndlp);
 	} else if (!NLP_CHK_NODE_ACT(ndlp)) {
@@ -2939,8 +2907,6 @@ lpfc_issue_els_farpr(struct lpfc_vport *vport, uint32=
_t nportid, uint8_t retry)
 	ndlp =3D lpfc_findnode_did(vport, nportid);
 	if (!ndlp) {
 		ndlp =3D mempool_alloc(phba->nlp_mem_pool, GFP_KERNEL);
=2D		if (!ndlp)
=2D			return 1;
 		lpfc_nlp_init(vport, ndlp, nportid);
 		lpfc_enqueue_node(vport, ndlp);
 	} else if (!NLP_CHK_NODE_ACT(ndlp)) {
@@ -5361,11 +5327,6 @@ lpfc_get_rdp_info(struct lpfc_hba *phba, struct lpfc=
_rdp_context *rdp_context)
 	int rc;
=20
 	mbox =3D mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
=2D	if (!mbox) {
=2D		lpfc_printf_log(phba, KERN_WARNING, LOG_MBOX | LOG_ELS,
=2D				"7105 failed to allocate mailbox memory");
=2D		return 1;
=2D	}
=20
 	if (lpfc_sli4_dump_page_a0(phba, mbox))
 		goto prep_mbox_fail;
@@ -5596,8 +5557,6 @@ lpfc_sli4_set_beacon(struct lpfc_vport *vport,
 	int rc;
=20
 	mbox =3D mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
=2D	if (!mbox)
=2D		return 1;
=20
 	len =3D sizeof(struct lpfc_mbx_set_beacon_config) -
 		sizeof(struct lpfc_sli4_cfg_mhdr);
@@ -6183,10 +6142,6 @@ lpfc_els_handle_rscn(struct lpfc_vport *vport)
 			ndlp->nlp_prev_state =3D NLP_STE_UNUSED_NODE;
 		} else {
 			ndlp =3D mempool_alloc(phba->nlp_mem_pool, GFP_KERNEL);
=2D			if (!ndlp) {
=2D				lpfc_els_flush_rscn(vport);
=2D				return 0;
=2D			}
 			lpfc_nlp_init(vport, ndlp, NameServer_DID);
 			ndlp->nlp_prev_state =3D ndlp->nlp_state;
 			lpfc_nlp_set_state(vport, ndlp, NLP_STE_PLOGI_ISSUE);
@@ -6278,8 +6233,6 @@ lpfc_els_rcv_flogi(struct lpfc_vport *vport, struct l=
pfc_iocbq *cmdiocb,
 		if (phba->sli_rev < LPFC_SLI_REV4) {
 			mbox =3D mempool_alloc(phba->mbox_mem_pool,
 					     GFP_KERNEL);
=2D			if (!mbox)
=2D				return 1;
 			lpfc_linkdown(phba);
 			lpfc_init_link(phba, mbox,
 				       phba->cfg_topology,
@@ -7747,8 +7700,6 @@ lpfc_els_unsol_buffer(struct lpfc_hba *phba, struct l=
pfc_sli_ring *pring,
 	if (!ndlp) {
 		/* Cannot find existing Fabric ndlp, so allocate a new one */
 		ndlp =3D mempool_alloc(phba->nlp_mem_pool, GFP_KERNEL);
=2D		if (!ndlp)
=2D			goto dropit;
=20
 		lpfc_nlp_init(vport, ndlp, did);
 		lpfc_nlp_set_state(vport, ndlp, NLP_STE_NPR_NODE);
@@ -8203,12 +8154,8 @@ lpfc_start_fdmi(struct lpfc_vport *vport)
 	ndlp =3D lpfc_findnode_did(vport, FDMI_DID);
 	if (!ndlp) {
 		ndlp =3D mempool_alloc(phba->nlp_mem_pool, GFP_KERNEL);
=2D		if (ndlp) {
=2D			lpfc_nlp_init(vport, ndlp, FDMI_DID);
=2D			ndlp->nlp_type |=3D NLP_FABRIC;
=2D		} else {
=2D			return;
=2D		}
+		lpfc_nlp_init(vport, ndlp, FDMI_DID);
+		ndlp->nlp_type |=3D NLP_FABRIC;
 	}
 	if (!NLP_CHK_NODE_ACT(ndlp))
 		ndlp =3D lpfc_enable_node(vport, ndlp, NLP_STE_NPR_NODE);
@@ -8258,16 +8205,6 @@ lpfc_do_scr_ns_plogi(struct lpfc_hba *phba, struct l=
pfc_vport *vport)
 	ndlp =3D lpfc_findnode_did(vport, NameServer_DID);
 	if (!ndlp) {
 		ndlp =3D mempool_alloc(phba->nlp_mem_pool, GFP_KERNEL);
=2D		if (!ndlp) {
=2D			if (phba->fc_topology =3D=3D LPFC_TOPOLOGY_LOOP) {
=2D				lpfc_disc_start(vport);
=2D				return;
=2D			}
=2D			lpfc_vport_set_state(vport, FC_VPORT_FAILED);
=2D			lpfc_printf_vlog(vport, KERN_ERR, LOG_ELS,
=2D					 "0251 NameServer login: no memory\n");
=2D			return;
=2D		}
 		lpfc_nlp_init(vport, ndlp, NameServer_DID);
 	} else if (!NLP_CHK_NODE_ACT(ndlp)) {
 		ndlp =3D lpfc_enable_node(vport, ndlp, NLP_STE_UNUSED_NODE);
@@ -8431,26 +8368,21 @@ lpfc_register_new_vport(struct lpfc_hba *phba, stru=
ct lpfc_vport *vport,
 	LPFC_MBOXQ_t *mbox;
=20
 	mbox =3D mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
=2D	if (mbox) {
=2D		lpfc_reg_vpi(vport, mbox);
=2D		mbox->vport =3D vport;
=2D		mbox->context2 =3D lpfc_nlp_get(ndlp);
=2D		mbox->mbox_cmpl =3D lpfc_cmpl_reg_new_vport;
=2D		if (lpfc_sli_issue_mbox(phba, mbox, MBX_NOWAIT)
=2D		    =3D=3D MBX_NOT_FINISHED) {
=2D			/* mailbox command not success, decrement ndlp
=2D			 * reference count for this command
=2D			 */
=2D			lpfc_nlp_put(ndlp);
=2D			mempool_free(mbox, phba->mbox_mem_pool);
=20
=2D			lpfc_printf_vlog(vport, KERN_ERR, LOG_MBOX,
=2D				"0253 Register VPI: Can't send mbox\n");
=2D			goto mbox_err_exit;
=2D		}
=2D	} else {
+	lpfc_reg_vpi(vport, mbox);
+	mbox->vport =3D vport;
+	mbox->context2 =3D lpfc_nlp_get(ndlp);
+	mbox->mbox_cmpl =3D lpfc_cmpl_reg_new_vport;
+	if (lpfc_sli_issue_mbox(phba, mbox, MBX_NOWAIT)
+	    =3D=3D MBX_NOT_FINISHED) {
+		/* mailbox command not success, decrement ndlp
+		 * reference count for this command
+		 */
+		lpfc_nlp_put(ndlp);
+		mempool_free(mbox, phba->mbox_mem_pool);
+
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_MBOX,
=2D				 "0254 Register VPI: no memory\n");
+				 "0253 Register VPI: Can't send mbox\n");
 		goto mbox_err_exit;
 	}
 	return;
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbad=
isc.c
index 180b072beef6..f494f192c19f 100644
=2D-- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -924,27 +924,23 @@ lpfc_linkdown(struct lpfc_hba *phba)
 	lpfc_destroy_vport_work_array(phba, vports);
 	/* Clean up any firmware default rpi's */
 	mb =3D mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
=2D	if (mb) {
=2D		lpfc_unreg_did(phba, 0xffff, LPFC_UNREG_ALL_DFLT_RPIS, mb);
=2D		mb->vport =3D vport;
=2D		mb->mbox_cmpl =3D lpfc_sli_def_mbox_cmpl;
=2D		if (lpfc_sli_issue_mbox(phba, mb, MBX_NOWAIT)
=2D		    =3D=3D MBX_NOT_FINISHED) {
=2D			mempool_free(mb, phba->mbox_mem_pool);
=2D		}
+	lpfc_unreg_did(phba, 0xffff, LPFC_UNREG_ALL_DFLT_RPIS, mb);
+	mb->vport =3D vport;
+	mb->mbox_cmpl =3D lpfc_sli_def_mbox_cmpl;
+	if (lpfc_sli_issue_mbox(phba, mb, MBX_NOWAIT)
+	    =3D=3D MBX_NOT_FINISHED) {
+		mempool_free(mb, phba->mbox_mem_pool);
 	}
=20
 	/* Setup myDID for link up if we are in pt2pt mode */
 	if (phba->pport->fc_flag & FC_PT2PT) {
 		mb =3D mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
=2D		if (mb) {
=2D			lpfc_config_link(phba, mb);
=2D			mb->mbox_cmpl =3D lpfc_sli_def_mbox_cmpl;
=2D			mb->vport =3D vport;
=2D			if (lpfc_sli_issue_mbox(phba, mb, MBX_NOWAIT)
=2D			    =3D=3D MBX_NOT_FINISHED) {
=2D				mempool_free(mb, phba->mbox_mem_pool);
=2D			}
+		lpfc_config_link(phba, mb);
+		mb->mbox_cmpl =3D lpfc_sli_def_mbox_cmpl;
+		mb->vport =3D vport;
+		if (lpfc_sli_issue_mbox(phba, mb, MBX_NOWAIT)
+		    =3D=3D MBX_NOT_FINISHED) {
+			mempool_free(mb, phba->mbox_mem_pool);
 		}
 		spin_lock_irq(shost->host_lock);
 		phba->pport->fc_flag &=3D ~(FC_PT2PT | FC_PT2PT_PLOGI);
@@ -1473,12 +1469,6 @@ lpfc_register_fcf(struct lpfc_hba *phba)
 	spin_unlock_irq(&phba->hbalock);
=20
 	fcf_mbxq =3D mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
=2D	if (!fcf_mbxq) {
=2D		spin_lock_irq(&phba->hbalock);
=2D		phba->hba_flag &=3D ~(FCF_TS_INPROG | FCF_RR_INPROG);
=2D		spin_unlock_irq(&phba->hbalock);
=2D		return;
=2D	}
=20
 	lpfc_reg_fcfi(phba, fcf_mbxq);
 	fcf_mbxq->vport =3D phba->pport;
@@ -2745,12 +2735,6 @@ lpfc_issue_init_vfi(struct lpfc_vport *vport)
 	struct lpfc_hba *phba =3D vport->phba;
=20
 	mboxq =3D mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
=2D	if (!mboxq) {
=2D		lpfc_printf_vlog(vport, KERN_ERR,
=2D			LOG_MBOX, "2892 Failed to allocate "
=2D			"init_vfi mailbox\n");
=2D		return;
=2D	}
 	lpfc_init_vfi(mboxq, vport);
 	mboxq->mbox_cmpl =3D lpfc_init_vfi_cmpl;
 	rc =3D lpfc_sli_issue_mbox(phba, mboxq, MBX_NOWAIT);
@@ -2839,12 +2823,6 @@ lpfc_issue_init_vpi(struct lpfc_vport *vport)
 	}
=20
 	mboxq =3D mempool_alloc(vport->phba->mbox_mem_pool, GFP_KERNEL);
=2D	if (!mboxq) {
=2D		lpfc_printf_vlog(vport, KERN_ERR,
=2D			LOG_MBOX, "2607 Failed to allocate "
=2D			"init_vpi mailbox\n");
=2D		return;
=2D	}
 	lpfc_init_vpi(vport->phba, mboxq, vport->vpi);
 	mboxq->vport =3D vport;
 	mboxq->mbox_cmpl =3D lpfc_init_vpi_cmpl;
@@ -3167,8 +3145,6 @@ lpfc_mbx_process_link_up(struct lpfc_hba *phba, struc=
t lpfc_mbx_read_top *la)
=20
 	lpfc_linkup(phba);
 	sparam_mbox =3D mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
=2D	if (!sparam_mbox)
=2D		goto out;
=20
 	rc =3D lpfc_read_sparam(phba, sparam_mbox, 0);
 	if (rc) {
@@ -3188,8 +3164,6 @@ lpfc_mbx_process_link_up(struct lpfc_hba *phba, struc=
t lpfc_mbx_read_top *la)
=20
 	if (!(phba->hba_flag & HBA_FCOE_MODE)) {
 		cfglink_mbox =3D mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
=2D		if (!cfglink_mbox)
=2D			goto out;
 		vport->port_state =3D LPFC_LOCAL_CFG_LINK;
 		lpfc_config_link(phba, cfglink_mbox);
 		cfglink_mbox->vport =3D vport;
@@ -3552,8 +3526,6 @@ lpfc_mbx_unreg_vpi(struct lpfc_vport *vport)
 	int rc;
=20
 	mbox =3D mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
=2D	if (!mbox)
=2D		return 1;
=20
 	lpfc_unreg_vpi(phba, vport->vpi, mbox);
 	mbox->vport =3D vport;
@@ -3646,12 +3618,6 @@ lpfc_create_static_vport(struct lpfc_hba *phba)
 	uint32_t byte_count =3D 0;
=20
 	pmb =3D mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
=2D	if (!pmb) {
=2D		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
=2D				"0542 lpfc_create_static_vport failed to"
=2D				" allocate mailbox memory\n");
=2D		return;
=2D	}
 	memset(pmb, 0, sizeof(LPFC_MBOXQ_t));
 	mb =3D &pmb->u.mb;
=20
@@ -4692,42 +4658,42 @@ lpfc_unreg_rpi(struct lpfc_vport *vport, struct lpf=
c_nodelist *ndlp)
 					 ndlp->nlp_rpi, ndlp->nlp_flag,
 					 ndlp->nlp_DID);
 		mbox =3D mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
=2D		if (mbox) {
=2D			/* SLI4 ports require the physical rpi value. */
=2D			rpi =3D ndlp->nlp_rpi;
=2D			if (phba->sli_rev =3D=3D LPFC_SLI_REV4)
=2D				rpi =3D phba->sli4_hba.rpi_ids[ndlp->nlp_rpi];
=20
=2D			lpfc_unreg_login(phba, vport->vpi, rpi, mbox);
=2D			mbox->vport =3D vport;
=2D			if (ndlp->nlp_flag & NLP_ISSUE_LOGO) {
=2D				mbox->context1 =3D ndlp;
=2D				mbox->mbox_cmpl =3D lpfc_nlp_logo_unreg;
=2D			} else {
=2D				if (phba->sli_rev =3D=3D LPFC_SLI_REV4 &&
=2D				    (!(vport->load_flag & FC_UNLOADING)) &&
=2D				    (bf_get(lpfc_sli_intf_if_type,
=2D				     &phba->sli4_hba.sli_intf) =3D=3D
=2D				      LPFC_SLI_INTF_IF_TYPE_2) &&
=2D				    (kref_read(&ndlp->kref) > 0)) {
=2D					mbox->context1 =3D lpfc_nlp_get(ndlp);
=2D					mbox->mbox_cmpl =3D
=2D						lpfc_sli4_unreg_rpi_cmpl_clr;
=2D					/*
=2D					 * accept PLOGIs after unreg_rpi_cmpl
=2D					 */
=2D					acc_plogi =3D 0;
=2D				} else
=2D					mbox->mbox_cmpl =3D
=2D						lpfc_sli_def_mbox_cmpl;
=2D			}
+		/* SLI4 ports require the physical rpi value. */
+		rpi =3D ndlp->nlp_rpi;
+		if (phba->sli_rev =3D=3D LPFC_SLI_REV4)
+			rpi =3D phba->sli4_hba.rpi_ids[ndlp->nlp_rpi];
=20
=2D			rc =3D lpfc_sli_issue_mbox(phba, mbox, MBX_NOWAIT);
=2D			if (rc =3D=3D MBX_NOT_FINISHED) {
=2D				mempool_free(mbox, phba->mbox_mem_pool);
=2D				acc_plogi =3D 1;
=2D			}
+		lpfc_unreg_login(phba, vport->vpi, rpi, mbox);
+		mbox->vport =3D vport;
+		if (ndlp->nlp_flag & NLP_ISSUE_LOGO) {
+			mbox->context1 =3D ndlp;
+			mbox->mbox_cmpl =3D lpfc_nlp_logo_unreg;
+		} else {
+			if (phba->sli_rev =3D=3D LPFC_SLI_REV4 &&
+			    (!(vport->load_flag & FC_UNLOADING)) &&
+			    (bf_get(lpfc_sli_intf_if_type,
+				    &phba->sli4_hba.sli_intf) =3D=3D
+			     LPFC_SLI_INTF_IF_TYPE_2) &&
+			    (kref_read(&ndlp->kref) > 0)) {
+				mbox->context1 =3D lpfc_nlp_get(ndlp);
+				mbox->mbox_cmpl =3D
+					lpfc_sli4_unreg_rpi_cmpl_clr;
+				/*
+				 * accept PLOGIs after unreg_rpi_cmpl
+				 */
+				acc_plogi =3D 0;
+			} else
+				mbox->mbox_cmpl =3D
+					lpfc_sli_def_mbox_cmpl;
 		}
+
+		rc =3D lpfc_sli_issue_mbox(phba, mbox, MBX_NOWAIT);
+		if (rc =3D=3D MBX_NOT_FINISHED) {
+			mempool_free(mbox, phba->mbox_mem_pool);
+			acc_plogi =3D 1;
+		}
+
 		lpfc_no_rpi(phba, ndlp);
=20
 		if (phba->sli_rev !=3D LPFC_SLI_REV4)
@@ -4792,21 +4758,19 @@ lpfc_unreg_all_rpis(struct lpfc_vport *vport)
 	}
=20
 	mbox =3D mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
=2D	if (mbox) {
=2D		lpfc_unreg_login(phba, vport->vpi, LPFC_UNREG_ALL_RPIS_VPORT,
=2D				 mbox);
=2D		mbox->vport =3D vport;
=2D		mbox->mbox_cmpl =3D lpfc_sli_def_mbox_cmpl;
=2D		mbox->context1 =3D NULL;
=2D		rc =3D lpfc_sli_issue_mbox_wait(phba, mbox, LPFC_MBOX_TMO);
=2D		if (rc !=3D MBX_TIMEOUT)
=2D			mempool_free(mbox, phba->mbox_mem_pool);
+	lpfc_unreg_login(phba, vport->vpi, LPFC_UNREG_ALL_RPIS_VPORT,
+			 mbox);
+	mbox->vport =3D vport;
+	mbox->mbox_cmpl =3D lpfc_sli_def_mbox_cmpl;
+	mbox->context1 =3D NULL;
+	rc =3D lpfc_sli_issue_mbox_wait(phba, mbox, LPFC_MBOX_TMO);
+	if (rc !=3D MBX_TIMEOUT)
+		mempool_free(mbox, phba->mbox_mem_pool);
=20
=2D		if ((rc =3D=3D MBX_TIMEOUT) || (rc =3D=3D MBX_NOT_FINISHED))
=2D			lpfc_printf_vlog(vport, KERN_ERR, LOG_MBOX | LOG_VPORT,
=2D				"1836 Could not issue "
=2D				"unreg_login(all_rpis) status %d\n", rc);
=2D	}
+	if ((rc =3D=3D MBX_TIMEOUT) || (rc =3D=3D MBX_NOT_FINISHED))
+		lpfc_printf_vlog(vport, KERN_ERR, LOG_MBOX | LOG_VPORT,
+				 "1836 Could not issue "
+				 "unreg_login(all_rpis) status %d\n", rc);
 }
=20
 void
@@ -4817,22 +4781,20 @@ lpfc_unreg_default_rpis(struct lpfc_vport *vport)
 	int rc;
=20
 	mbox =3D mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
=2D	if (mbox) {
=2D		lpfc_unreg_did(phba, vport->vpi, LPFC_UNREG_ALL_DFLT_RPIS,
=2D			       mbox);
=2D		mbox->vport =3D vport;
=2D		mbox->mbox_cmpl =3D lpfc_sli_def_mbox_cmpl;
=2D		mbox->context1 =3D NULL;
=2D		rc =3D lpfc_sli_issue_mbox_wait(phba, mbox, LPFC_MBOX_TMO);
=2D		if (rc !=3D MBX_TIMEOUT)
=2D			mempool_free(mbox, phba->mbox_mem_pool);
+	lpfc_unreg_did(phba, vport->vpi, LPFC_UNREG_ALL_DFLT_RPIS,
+		       mbox);
+	mbox->vport =3D vport;
+	mbox->mbox_cmpl =3D lpfc_sli_def_mbox_cmpl;
+	mbox->context1 =3D NULL;
+	rc =3D lpfc_sli_issue_mbox_wait(phba, mbox, LPFC_MBOX_TMO);
+	if (rc !=3D MBX_TIMEOUT)
+		mempool_free(mbox, phba->mbox_mem_pool);
=20
=2D		if ((rc =3D=3D MBX_TIMEOUT) || (rc =3D=3D MBX_NOT_FINISHED))
=2D			lpfc_printf_vlog(vport, KERN_ERR, LOG_MBOX | LOG_VPORT,
=2D					 "1815 Could not issue "
=2D					 "unreg_did (default rpis) status %d\n",
=2D					 rc);
=2D	}
+	if ((rc =3D=3D MBX_TIMEOUT) || (rc =3D=3D MBX_NOT_FINISHED))
+		lpfc_printf_vlog(vport, KERN_ERR, LOG_MBOX | LOG_VPORT,
+				 "1815 Could not issue "
+				 "unreg_did (default rpis) status %d\n",
+				 rc);
 }
=20
 /*
@@ -4956,23 +4918,22 @@ lpfc_nlp_remove(struct lpfc_vport *vport, struct lp=
fc_nodelist *ndlp)
 				 ndlp->nlp_rpi, ndlp->nlp_DID, ndlp->nlp_flag,
 				 kref_read(&ndlp->kref),
 				 ndlp->nlp_usg_map, ndlp);
=2D		if ((mbox =3D mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL))
=2D			!=3D NULL) {
=2D			rc =3D lpfc_reg_rpi(phba, vport->vpi, ndlp->nlp_DID,
=2D			    (uint8_t *) &vport->fc_sparam, mbox, ndlp->nlp_rpi);
=2D			if (rc) {
+		mbox =3D mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
+
+		rc =3D lpfc_reg_rpi(phba, vport->vpi, ndlp->nlp_DID,
+				  (uint8_t *) &vport->fc_sparam, mbox, ndlp->nlp_rpi);
+		if (rc) {
+			mempool_free(mbox, phba->mbox_mem_pool);
+		}
+		else {
+			mbox->mbox_flag |=3D LPFC_MBX_IMED_UNREG;
+			mbox->mbox_cmpl =3D lpfc_mbx_cmpl_dflt_rpi;
+			mbox->vport =3D vport;
+			mbox->context2 =3D ndlp;
+			rc =3Dlpfc_sli_issue_mbox(phba, mbox, MBX_NOWAIT);
+			if (rc =3D=3D MBX_NOT_FINISHED) {
 				mempool_free(mbox, phba->mbox_mem_pool);
 			}
=2D			else {
=2D				mbox->mbox_flag |=3D LPFC_MBX_IMED_UNREG;
=2D				mbox->mbox_cmpl =3D lpfc_mbx_cmpl_dflt_rpi;
=2D				mbox->vport =3D vport;
=2D				mbox->context2 =3D ndlp;
=2D				rc =3Dlpfc_sli_issue_mbox(phba, mbox, MBX_NOWAIT);
=2D				if (rc =3D=3D MBX_NOT_FINISHED) {
=2D					mempool_free(mbox, phba->mbox_mem_pool);
=2D				}
=2D			}
 		}
 	}
 	lpfc_cleanup_node(vport, ndlp);
@@ -5109,8 +5070,6 @@ lpfc_setup_disc_node(struct lpfc_vport *vport, uint32=
_t did)
 			return NULL;
 		ndlp =3D (struct lpfc_nodelist *)
 		     mempool_alloc(vport->phba->nlp_mem_pool, GFP_KERNEL);
=2D		if (!ndlp)
=2D			return NULL;
 		lpfc_nlp_init(vport, ndlp, did);
 		lpfc_nlp_set_state(vport, ndlp, NLP_STE_NPR_NODE);
 		if (vport->phba->nvmet_support)
@@ -5227,23 +5186,22 @@ lpfc_issue_clear_la(struct lpfc_hba *phba, struct l=
pfc_vport *vport)
 	 */
 	if ((phba->link_state >=3D LPFC_CLEAR_LA) ||
 	    (vport->port_type !=3D LPFC_PHYSICAL_PORT) ||
=2D		(phba->sli_rev =3D=3D LPFC_SLI_REV4))
+	    (phba->sli_rev =3D=3D LPFC_SLI_REV4))
 		return;
=20
=2D			/* Link up discovery */
=2D	if ((mbox =3D mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL)) !=3D NULL=
) {
=2D		phba->link_state =3D LPFC_CLEAR_LA;
=2D		lpfc_clear_la(phba, mbox);
=2D		mbox->mbox_cmpl =3D lpfc_mbx_cmpl_clear_la;
=2D		mbox->vport =3D vport;
=2D		rc =3D lpfc_sli_issue_mbox(phba, mbox, MBX_NOWAIT);
=2D		if (rc =3D=3D MBX_NOT_FINISHED) {
=2D			mempool_free(mbox, phba->mbox_mem_pool);
=2D			lpfc_disc_flush_list(vport);
=2D			extra_ring->flag &=3D ~LPFC_STOP_IOCB_EVENT;
=2D			fcp_ring->flag &=3D ~LPFC_STOP_IOCB_EVENT;
=2D			phba->link_state =3D LPFC_HBA_ERROR;
=2D		}
+	/* Link up discovery */
+	mbox =3D mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
+	phba->link_state =3D LPFC_CLEAR_LA;
+	lpfc_clear_la(phba, mbox);
+	mbox->mbox_cmpl =3D lpfc_mbx_cmpl_clear_la;
+	mbox->vport =3D vport;
+	rc =3D lpfc_sli_issue_mbox(phba, mbox, MBX_NOWAIT);
+	if (rc =3D=3D MBX_NOT_FINISHED) {
+		mempool_free(mbox, phba->mbox_mem_pool);
+		lpfc_disc_flush_list(vport);
+		extra_ring->flag &=3D ~LPFC_STOP_IOCB_EVENT;
+		fcp_ring->flag &=3D ~LPFC_STOP_IOCB_EVENT;
+		phba->link_state =3D LPFC_HBA_ERROR;
 	}
 }
=20
@@ -5254,14 +5212,12 @@ lpfc_issue_reg_vpi(struct lpfc_hba *phba, struct lp=
fc_vport *vport)
 	LPFC_MBOXQ_t *regvpimbox;
=20
 	regvpimbox =3D mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
=2D	if (regvpimbox) {
=2D		lpfc_reg_vpi(vport, regvpimbox);
=2D		regvpimbox->mbox_cmpl =3D lpfc_mbx_cmpl_reg_vpi;
=2D		regvpimbox->vport =3D vport;
=2D		if (lpfc_sli_issue_mbox(phba, regvpimbox, MBX_NOWAIT)
=2D					=3D=3D MBX_NOT_FINISHED) {
=2D			mempool_free(regvpimbox, phba->mbox_mem_pool);
=2D		}
+	lpfc_reg_vpi(vport, regvpimbox);
+	regvpimbox->mbox_cmpl =3D lpfc_mbx_cmpl_reg_vpi;
+	regvpimbox->vport =3D vport;
+	if (lpfc_sli_issue_mbox(phba, regvpimbox, MBX_NOWAIT)
+	    =3D=3D MBX_NOT_FINISHED) {
+		mempool_free(regvpimbox, phba->mbox_mem_pool);
 	}
 }
=20
@@ -5602,13 +5558,6 @@ lpfc_disc_timeout_handler(struct lpfc_vport *vport)
=20
 		/* Setup and issue mailbox INITIALIZE LINK command */
 		initlinkmbox =3D mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
=2D		if (!initlinkmbox) {
=2D			lpfc_printf_vlog(vport, KERN_ERR, LOG_DISCOVERY,
=2D					 "0206 Device Discovery "
=2D					 "completion error\n");
=2D			phba->link_state =3D LPFC_HBA_ERROR;
=2D			break;
=2D		}
=20
 		lpfc_linkdown(phba);
 		lpfc_init_link(phba, initlinkmbox, phba->cfg_topology,
@@ -5907,9 +5856,8 @@ lpfc_nlp_init(struct lpfc_vport *vport, struct lpfc_n=
odelist *ndlp,
 		ndlp->active_rrqs_xri_bitmap =3D
 				mempool_alloc(vport->phba->active_rrq_pool,
 					      GFP_KERNEL);
=2D		if (ndlp->active_rrqs_xri_bitmap)
=2D			memset(ndlp->active_rrqs_xri_bitmap, 0,
=2D			       ndlp->phba->cfg_rrq_xri_bitmap_sz);
+		memset(ndlp->active_rrqs_xri_bitmap, 0,
+		       ndlp->phba->cfg_rrq_xri_bitmap_sz);
 	}
=20
=20
@@ -6276,12 +6224,6 @@ lpfc_sli4_unregister_fcf(struct lpfc_hba *phba)
 	int rc;
=20
 	mbox =3D mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
=2D	if (!mbox) {
=2D		lpfc_printf_log(phba, KERN_ERR, LOG_DISCOVERY|LOG_MBOX,
=2D				"2551 UNREG_FCFI mbox allocation failed"
=2D				"HBA state x%x\n", phba->pport->port_state);
=2D		return -ENOMEM;
=2D	}
 	lpfc_unreg_fcfi(mbox, phba->fcf.fcfi);
 	mbox->vport =3D phba->pport;
 	mbox->mbox_cmpl =3D lpfc_unregister_fcfi_cmpl;
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 6cc561b04211..eb4e10ba76f7 100644
=2D-- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -121,11 +121,6 @@ lpfc_config_port_prep(struct lpfc_hba *phba)
 	static int init_key =3D 1;
=20
 	pmb =3D mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
=2D	if (!pmb) {
=2D		phba->link_state =3D LPFC_HBA_ERROR;
=2D		return -ENOMEM;
=2D	}
=2D
 	mb =3D &pmb->u.mb;
 	phba->link_state =3D LPFC_INIT_MBX_CMDS;
=20
@@ -398,10 +393,6 @@ lpfc_config_port_post(struct lpfc_hba *phba)
 	spin_unlock_irq(&phba->hbalock);
=20
 	pmb =3D mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
=2D	if (!pmb) {
=2D		phba->link_state =3D LPFC_HBA_ERROR;
=2D		return -ENOMEM;
=2D	}
 	mb =3D &pmb->u.mb;
=20
 	/* Get login parameters for NID.  */
@@ -599,10 +590,6 @@ lpfc_config_port_post(struct lpfc_hba *phba)
 	}
 	/* MBOX buffer will be freed in mbox compl */
 	pmb =3D mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
=2D	if (!pmb) {
=2D		phba->link_state =3D LPFC_HBA_ERROR;
=2D		return -ENOMEM;
=2D	}
=20
 	lpfc_config_async(phba, pmb, LPFC_ELS_RING);
 	pmb->mbox_cmpl =3D lpfc_config_async_cmpl;
@@ -621,10 +608,6 @@ lpfc_config_port_post(struct lpfc_hba *phba)
=20
 	/* Get Option rom version */
 	pmb =3D mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
=2D	if (!pmb) {
=2D		phba->link_state =3D LPFC_HBA_ERROR;
=2D		return -ENOMEM;
=2D	}
=20
 	lpfc_dump_wakeup_param(phba, pmb);
 	pmb->mbox_cmpl =3D lpfc_dump_wakeup_param_cmpl;
@@ -685,10 +668,6 @@ lpfc_hba_init_link_fc_topology(struct lpfc_hba *phba, =
uint32_t fc_topology,
 	int rc;
=20
 	pmb =3D mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
=2D	if (!pmb) {
=2D		phba->link_state =3D LPFC_HBA_ERROR;
=2D		return -ENOMEM;
=2D	}
 	mb =3D &pmb->u.mb;
 	pmb->vport =3D vport;
=20
@@ -764,10 +743,6 @@ lpfc_hba_down_link(struct lpfc_hba *phba, uint32_t fla=
g)
 	int rc;
=20
 	pmb =3D mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
=2D	if (!pmb) {
=2D		phba->link_state =3D LPFC_HBA_ERROR;
=2D		return -ENOMEM;
=2D	}
=20
 	lpfc_printf_log(phba,
 		KERN_ERR, LOG_INIT,
@@ -1276,13 +1251,6 @@ lpfc_hb_timeout_handler(struct lpfc_hba *phba)
 				(list_empty(&psli->mboxq))) {
 				pmboxq =3D mempool_alloc(phba->mbox_mem_pool,
 							GFP_KERNEL);
=2D				if (!pmboxq) {
=2D					mod_timer(&phba->hb_tmofunc,
=2D						 jiffies +
=2D						 msecs_to_jiffies(1000 *
=2D						 LPFC_HB_MBOX_INTERVAL));
=2D					return;
=2D				}
=20
 				lpfc_heart_beat(phba, pmboxq);
 				pmboxq->mbox_cmpl =3D lpfc_hb_mbox_cmpl;
@@ -1880,11 +1848,6 @@ lpfc_handle_latt(struct lpfc_hba *phba)
 	int rc =3D 0;
=20
 	pmb =3D (LPFC_MBOXQ_t *)mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
=2D	if (!pmb) {
=2D		rc =3D 1;
=2D		goto lpfc_handle_latt_err_exit;
=2D	}
=2D
 	mp =3D kmalloc(sizeof(struct lpfc_dmabuf), GFP_KERNEL);
 	if (!mp) {
 		rc =3D 2;
@@ -3566,8 +3529,6 @@ lpfc_get_wwpn(struct lpfc_hba *phba)
=20
 	mboxq =3D (LPFC_MBOXQ_t *) mempool_alloc(phba->mbox_mem_pool,
 						GFP_KERNEL);
=2D	if (!mboxq)
=2D		return (uint64_t)-1;
=20
 	/* First get WWN of HBA instance */
 	lpfc_read_nv(phba, mboxq);
@@ -4308,11 +4269,6 @@ lpfc_sli4_async_link_evt(struct lpfc_hba *phba,
 		return;
 	phba->fcoe_eventtag =3D acqe_link->event_tag;
 	pmb =3D (LPFC_MBOXQ_t *)mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
=2D	if (!pmb) {
=2D		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
=2D				"0395 The mboxq allocation failed\n");
=2D		return;
=2D	}
 	mp =3D kmalloc(sizeof(struct lpfc_dmabuf), GFP_KERNEL);
 	if (!mp) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
@@ -4467,11 +4423,6 @@ lpfc_sli4_async_fc_evt(struct lpfc_hba *phba, struct=
 lpfc_acqe_fc_la *acqe_fc)
 			phba->sli4_hba.link_state.logical_speed,
 			phba->sli4_hba.link_state.fault);
 	pmb =3D (LPFC_MBOXQ_t *)mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
=2D	if (!pmb) {
=2D		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
=2D				"2897 The mboxq allocation failed\n");
=2D		return;
=2D	}
 	mp =3D kmalloc(sizeof(struct lpfc_dmabuf), GFP_KERNEL);
 	if (!mp) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
@@ -4717,8 +4668,6 @@ lpfc_sli4_perform_vport_cvl(struct lpfc_vport *vport)
 	if (!ndlp) {
 		/* Cannot find existing Fabric ndlp, so allocate a new one */
 		ndlp =3D mempool_alloc(phba->nlp_mem_pool, GFP_KERNEL);
=2D		if (!ndlp)
=2D			return 0;
 		lpfc_nlp_init(vport, ndlp, Fabric_DID);
 		/* Set the node type */
 		ndlp->nlp_type |=3D NLP_FABRIC;
@@ -5856,10 +5805,6 @@ lpfc_sli4_driver_resource_setup(struct lpfc_hba *phb=
a)
=20
 	mboxq =3D (LPFC_MBOXQ_t *) mempool_alloc(phba->mbox_mem_pool,
 						       GFP_KERNEL);
=2D	if (!mboxq) {
=2D		rc =3D -ENOMEM;
=2D		goto out_free_bsmbx;
=2D	}
=20
 	/* Check for NVMET being configured */
 	phba->nvmet_support =3D 0;
@@ -7403,12 +7348,6 @@ lpfc_sli4_read_config(struct lpfc_hba *phba)
 	int length, i, rc =3D 0, rc2;
=20
 	pmb =3D (LPFC_MBOXQ_t *) mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
=2D	if (!pmb) {
=2D		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
=2D				"2011 Unable to allocate memory for issuing "
=2D				"SLI_CONFIG_SPECIAL mailbox command\n");
=2D		return -ENOMEM;
=2D	}
=20
 	lpfc_read_config(phba, pmb);
=20
@@ -7650,14 +7589,6 @@ lpfc_setup_endian_order(struct lpfc_hba *phba)
 	case LPFC_SLI_INTF_IF_TYPE_0:
 		mboxq =3D (LPFC_MBOXQ_t *) mempool_alloc(phba->mbox_mem_pool,
 						       GFP_KERNEL);
=2D		if (!mboxq) {
=2D			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
=2D					"0492 Unable to allocate memory for "
=2D					"issuing SLI_CONFIG_SPECIAL mailbox "
=2D					"command\n");
=2D			return -ENOMEM;
=2D		}
=2D
 		/*
 		 * The SLI4_CONFIG_SPECIAL mailbox command requires the first
 		 * two words to contain special data values and no other data.
@@ -8429,12 +8360,6 @@ lpfc_sli4_queue_setup(struct lpfc_hba *phba)
=20
 	/* Check for dual-ULP support */
 	mboxq =3D (LPFC_MBOXQ_t *)mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
=2D	if (!mboxq) {
=2D		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
=2D				"3249 Unable to allocate memory for "
=2D				"QUERY_FW_CFG mailbox command\n");
=2D		return -ENOMEM;
=2D	}
 	length =3D (sizeof(struct lpfc_mbx_query_fw_config) -
 		  sizeof(struct lpfc_sli4_cfg_mhdr));
 	lpfc_sli4_config(phba, mboxq, LPFC_MBOX_SUBSYSTEM_COMMON,
@@ -9066,13 +8991,6 @@ lpfc_pci_function_reset(struct lpfc_hba *phba)
 	case LPFC_SLI_INTF_IF_TYPE_0:
 		mboxq =3D (LPFC_MBOXQ_t *) mempool_alloc(phba->mbox_mem_pool,
 						       GFP_KERNEL);
=2D		if (!mboxq) {
=2D			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
=2D					"0494 Unable to allocate memory for "
=2D					"issuing SLI_FUNCTION_RESET mailbox "
=2D					"command\n");
=2D			return -ENOMEM;
=2D		}
=20
 		/* Setup PCI function reset mailbox-ioctl command */
 		lpfc_sli4_config(phba, mboxq, LPFC_MBOX_SUBSYSTEM_COMMON,
@@ -9408,13 +9326,6 @@ lpfc_sli_enable_msix(struct lpfc_hba *phba)
 	 */
 	pmb =3D (LPFC_MBOXQ_t *) mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
=20
=2D	if (!pmb) {
=2D		rc =3D -ENOMEM;
=2D		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
=2D				"0474 Unable to allocate memory for issuing "
=2D				"MBOX_CONFIG_MSI command\n");
=2D		goto mem_fail_out;
=2D	}
 	rc =3D lpfc_config_msi(phba, pmb);
 	if (rc)
 		goto mbx_fail_out;
diff --git a/drivers/scsi/lpfc/lpfc_mbox.c b/drivers/scsi/lpfc/lpfc_mbox.c
index a928f5187fa4..a497f1f8e224 100644
=2D-- a/drivers/scsi/lpfc/lpfc_mbox.c
+++ b/drivers/scsi/lpfc/lpfc_mbox.c
@@ -836,24 +836,22 @@ lpfc_sli4_unreg_all_rpis(struct lpfc_vport *vport)
 	int rc;
=20
 	mbox =3D mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
=2D	if (mbox) {
=2D		/*
=2D		 * For SLI4 functions, the rpi field is overloaded for
=2D		 * the vport context unreg all.  This routine passes
=2D		 * 0 for the rpi field in lpfc_unreg_login for compatibility
=2D		 * with SLI3 and then overrides the rpi field with the
=2D		 * expected value for SLI4.
=2D		 */
=2D		lpfc_unreg_login(phba, vport->vpi, phba->vpi_ids[vport->vpi],
=2D				 mbox);
=2D		mbox->u.mb.un.varUnregLogin.rsvd1 =3D 0x4000;
=2D		mbox->vport =3D vport;
=2D		mbox->mbox_cmpl =3D lpfc_sli_def_mbox_cmpl;
=2D		mbox->context1 =3D NULL;
=2D		rc =3D lpfc_sli_issue_mbox(phba, mbox, MBX_NOWAIT);
=2D		if (rc =3D=3D MBX_NOT_FINISHED)
=2D			mempool_free(mbox, phba->mbox_mem_pool);
=2D	}
+	/*
+	 * For SLI4 functions, the rpi field is overloaded for
+	 * the vport context unreg all.  This routine passes
+	 * 0 for the rpi field in lpfc_unreg_login for compatibility
+	 * with SLI3 and then overrides the rpi field with the
+	 * expected value for SLI4.
+	 */
+	lpfc_unreg_login(phba, vport->vpi, phba->vpi_ids[vport->vpi],
+			 mbox);
+	mbox->u.mb.un.varUnregLogin.rsvd1 =3D 0x4000;
+	mbox->vport =3D vport;
+	mbox->mbox_cmpl =3D lpfc_sli_def_mbox_cmpl;
+	mbox->context1 =3D NULL;
+	rc =3D lpfc_sli_issue_mbox(phba, mbox, MBX_NOWAIT);
+	if (rc =3D=3D MBX_NOT_FINISHED)
+		mempool_free(mbox, phba->mbox_mem_pool);
 }
=20
 /**
diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_np=
ortdisc.c
index 061626bdf701..5e9232248559 100644
=2D-- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -411,8 +411,6 @@ lpfc_rcv_plogi(struct lpfc_vport *vport, struct lpfc_no=
delist *ndlp,
 			lpfc_issue_reg_vfi(vport);
 		else {
 			mbox =3D mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
=2D			if (mbox =3D=3D NULL)
=2D				goto out;
 			lpfc_config_link(phba, mbox);
 			mbox->mbox_cmpl =3D lpfc_sli_def_mbox_cmpl;
 			mbox->vport =3D vport;
@@ -436,8 +434,6 @@ lpfc_rcv_plogi(struct lpfc_vport *vport, struct lpfc_no=
delist *ndlp,
 	}
=20
 	mbox =3D mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
=2D	if (!mbox)
=2D		goto out;
=20
 	/* Registering an existing RPI behaves differently for SLI3 vs SLI4 */
 	if (phba->sli_rev =3D=3D LPFC_SLI_REV4)
@@ -826,17 +822,12 @@ lpfc_release_rpi(struct lpfc_hba *phba,
 	int rc;
=20
 	pmb =3D (LPFC_MBOXQ_t *) mempool_alloc(phba->mbox_mem_pool,
=2D			GFP_KERNEL);
=2D	if (!pmb)
=2D		lpfc_printf_vlog(vport, KERN_ERR, LOG_MBOX,
=2D			"2796 mailbox memory allocation failed \n");
=2D	else {
=2D		lpfc_unreg_login(phba, vport->vpi, rpi, pmb);
=2D		pmb->mbox_cmpl =3D lpfc_sli_def_mbox_cmpl;
=2D		rc =3D lpfc_sli_issue_mbox(phba, pmb, MBX_NOWAIT);
=2D		if (rc =3D=3D MBX_NOT_FINISHED)
=2D			mempool_free(pmb, phba->mbox_mem_pool);
=2D	}
+					     GFP_KERNEL);
+	lpfc_unreg_login(phba, vport->vpi, rpi, pmb);
+	pmb->mbox_cmpl =3D lpfc_sli_def_mbox_cmpl;
+	rc =3D lpfc_sli_issue_mbox(phba, pmb, MBX_NOWAIT);
+	if (rc =3D=3D MBX_NOT_FINISHED)
+		mempool_free(pmb, phba->mbox_mem_pool);
 }
=20
 static uint32_t
@@ -1155,15 +1146,6 @@ lpfc_cmpl_plogi_plogi_issue(struct lpfc_vport *vport,
 			lpfc_issue_reg_vfi(vport);
 		} else {
 			mbox =3D mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
=2D			if (!mbox) {
=2D				lpfc_printf_vlog(vport, KERN_ERR, LOG_ELS,
=2D						 "0133 PLOGI: no memory "
=2D						 "for config_link "
=2D						 "Data: x%x x%x x%x x%x\n",
=2D						 ndlp->nlp_DID, ndlp->nlp_state,
=2D						 ndlp->nlp_flag, ndlp->nlp_rpi);
=2D				goto out;
=2D			}
=20
 			lpfc_config_link(phba, mbox);
=20
@@ -1180,14 +1162,6 @@ lpfc_cmpl_plogi_plogi_issue(struct lpfc_vport *vport,
 	lpfc_unreg_rpi(vport, ndlp);
=20
 	mbox =3D mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
=2D	if (!mbox) {
=2D		lpfc_printf_vlog(vport, KERN_ERR, LOG_ELS,
=2D				 "0018 PLOGI: no memory for reg_login "
=2D				 "Data: x%x x%x x%x x%x\n",
=2D				 ndlp->nlp_DID, ndlp->nlp_state,
=2D				 ndlp->nlp_flag, ndlp->nlp_rpi);
=2D		goto out;
=2D	}
=20
 	if (lpfc_reg_rpi(phba, vport->vpi, irsp->un.elsreq64.remoteID,
 			 (uint8_t *) sp, mbox, ndlp->nlp_rpi) =3D=3D 0) {
diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index 0024de1c6c1f..948fe0079d7d 100644
=2D-- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -1660,12 +1660,6 @@ lpfc_sli4_post_nvme_sgl_block(struct lpfc_hba *phba,
 		return -ENOMEM;
 	}
 	mbox =3D mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
=2D	if (!mbox) {
=2D		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
=2D				"6119 Failed to allocate mbox cmd memory\n");
=2D		return -ENOMEM;
=2D	}
=2D
 	/* Allocate DMA memory and set up the non-embedded mailbox command */
 	alloclen =3D lpfc_sli4_config(phba, mbox, LPFC_MBOX_SUBSYSTEM_FCOE,
 				LPFC_MBOX_OPCODE_FCOE_POST_SGL_PAGES, reqlen,
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 1c9fa45df7eb..b4dfaa1b28a1 100644
=2D-- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -876,13 +876,6 @@ lpfc_set_rrq_active(struct lpfc_hba *phba, struct lpfc=
_nodelist *ndlp,
=20
 	spin_unlock_irqrestore(&phba->hbalock, iflags);
 	rrq =3D mempool_alloc(phba->rrq_pool, GFP_KERNEL);
=2D	if (!rrq) {
=2D		lpfc_printf_log(phba, KERN_INFO, LOG_SLI,
=2D				"3155 Unable to allocate RRQ xri:0x%x rxid:0x%x"
=2D				" DID:0x%x Send:%d\n",
=2D				xritag, rxid, ndlp->nlp_DID, send_rrq);
=2D		return -EINVAL;
=2D	}
 	if (phba->cfg_enable_rrq =3D=3D 1)
 		rrq->send_rrq =3D send_rrq;
 	else
@@ -1344,8 +1337,6 @@ lpfc_sli_ring_map(struct lpfc_hba *phba)
 	int i, rc, ret =3D 0;
=20
 	pmb =3D (LPFC_MBOXQ_t *) mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
=2D	if (!pmb)
=2D		return -ENOMEM;
 	pmbox =3D &pmb->u.mb;
 	phba->link_state =3D LPFC_INIT_MBX_CMDS;
 	for (i =3D 0; i < psli->num_rings; i++) {
@@ -4112,8 +4103,6 @@ lpfc_sli_brdkill(struct lpfc_hba *phba)
 			phba->pport->port_state, psli->sli_flag);
=20
 	pmb =3D (LPFC_MBOXQ_t *) mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
=2D	if (!pmb)
=2D		return 1;
=20
 	/* Disable the error attention */
 	spin_lock_irq(&phba->hbalock);
@@ -4602,9 +4591,6 @@ lpfc_sli_hbq_setup(struct lpfc_hba *phba)
 				 */
 	pmb =3D (LPFC_MBOXQ_t *) mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
=20
=2D	if (!pmb)
=2D		return -ENOMEM;
=2D
 	pmbox =3D &pmb->u.mb;
=20
 	/* Initialize the struct lpfc_sli_hbq structure for each hbq */
@@ -4689,10 +4675,6 @@ lpfc_sli_config_port(struct lpfc_hba *phba, int sli_=
mode)
 	uint32_t resetcount =3D 0, rc =3D 0, done =3D 0;
=20
 	pmb =3D (LPFC_MBOXQ_t *) mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
=2D	if (!pmb) {
=2D		phba->link_state =3D LPFC_HBA_ERROR;
=2D		return -ENOMEM;
=2D	}
=20
 	phba->sli_rev =3D sli_mode;
 	while (resetcount < 2 && !done) {
@@ -4981,9 +4963,6 @@ lpfc_sli4_read_fcoe_params(struct lpfc_hba *phba)
 	phba->fc_map[2] =3D LPFC_FCOE_FCF_MAP2;
=20
 	mboxq =3D (LPFC_MBOXQ_t *)mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
=2D	if (!mboxq)
=2D		return -ENOMEM;
=2D
 	mqe =3D &mboxq->u.mqe;
 	if (lpfc_sli4_dump_cfg_rg23(phba, mboxq)) {
 		rc =3D -ENOMEM;
@@ -5145,8 +5124,6 @@ lpfc_sli4_retrieve_pport_name(struct lpfc_hba *phba)
 	phba->sli4_hba.pport_name_sta =3D LPFC_SLI4_PPNAME_NON;
=20
 	mboxq =3D (LPFC_MBOXQ_t *)mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
=2D	if (!mboxq)
=2D		return -ENOMEM;
 	/* obtain link type and link number via READ_CONFIG */
 	phba->sli4_hba.lnk_info.lnk_dv =3D LPFC_LNK_DAT_INVAL;
 	lpfc_sli4_read_config(phba);
@@ -5332,8 +5309,6 @@ lpfc_sli4_get_avail_extnt_rsrc(struct lpfc_hba *phba,=
 uint16_t type,
 	LPFC_MBOXQ_t *mbox;
=20
 	mbox =3D (LPFC_MBOXQ_t *) mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
=2D	if (!mbox)
=2D		return -ENOMEM;
=20
 	/* Find out how many extents are available for this resource type */
 	length =3D (sizeof(struct lpfc_mbx_get_rsrc_extent_info) -
@@ -5571,8 +5546,6 @@ lpfc_sli4_alloc_extent(struct lpfc_hba *phba, uint16_=
t type)
 			"count:%d, size %d\n", type, rsrc_cnt, rsrc_size);
=20
 	mbox =3D (LPFC_MBOXQ_t *) mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
=2D	if (!mbox)
=2D		return -ENOMEM;
=20
 	rc =3D lpfc_sli4_cfg_post_extnts(phba, rsrc_cnt, type, &emb, mbox);
 	if (unlikely(rc)) {
@@ -5779,8 +5752,6 @@ lpfc_sli4_dealloc_extent(struct lpfc_hba *phba, uint1=
6_t type)
 	struct lpfc_rsrc_blks *rsrc_blk, *rsrc_blk_next;
=20
 	mbox =3D (LPFC_MBOXQ_t *) mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
=2D	if (!mbox)
=2D		return -ENOMEM;
=20
 	/*
 	 * This function sends an embedded mailbox because it only sends the
@@ -6272,8 +6243,6 @@ lpfc_sli4_get_allocated_extnts(struct lpfc_hba *phba,=
 uint16_t type,
 	}
=20
 	mbox =3D (LPFC_MBOXQ_t *) mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
=2D	if (!mbox)
=2D		return -ENOMEM;
 	memset(mbox, 0, sizeof(LPFC_MBOXQ_t));
=20
 	alloc_len =3D lpfc_sli4_config(phba, mbox, LPFC_MBOX_SUBSYSTEM_COMMON,
@@ -6550,8 +6519,6 @@ lpfc_sli4_hba_setup(struct lpfc_hba *phba)
 	 * port.
 	 */
 	mboxq =3D (LPFC_MBOXQ_t *) mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
=2D	if (!mboxq)
=2D		return -ENOMEM;
=20
 	/* Issue READ_REV to collect vpd and FW information. */
 	vpd_size =3D SLI4_PAGE_SIZE;
@@ -13904,8 +13871,6 @@ lpfc_modify_hba_eq_delay(struct lpfc_hba *phba, uin=
t32_t startq)
 		return 0;
=20
 	mbox =3D mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
=2D	if (!mbox)
=2D		return -ENOMEM;
 	length =3D (sizeof(struct lpfc_mbx_modify_eq_delay) -
 		  sizeof(struct lpfc_sli4_cfg_mhdr));
 	lpfc_sli4_config(phba, mbox, LPFC_MBOX_SUBSYSTEM_COMMON,
@@ -13991,8 +13956,6 @@ lpfc_eq_create(struct lpfc_hba *phba, struct lpfc_q=
ueue *eq, uint32_t imax)
 		hw_page_size =3D SLI4_PAGE_SIZE;
=20
 	mbox =3D mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
=2D	if (!mbox)
=2D		return -ENOMEM;
 	length =3D (sizeof(struct lpfc_mbx_eq_create) -
 		  sizeof(struct lpfc_sli4_cfg_mhdr));
 	lpfc_sli4_config(phba, mbox, LPFC_MBOX_SUBSYSTEM_COMMON,
@@ -14110,8 +14073,6 @@ lpfc_cq_create(struct lpfc_hba *phba, struct lpfc_q=
ueue *cq,
 		hw_page_size =3D SLI4_PAGE_SIZE;
=20
 	mbox =3D mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
=2D	if (!mbox)
=2D		return -ENOMEM;
 	length =3D (sizeof(struct lpfc_mbx_cq_create) -
 		  sizeof(struct lpfc_sli4_cfg_mhdr));
 	lpfc_sli4_config(phba, mbox, LPFC_MBOX_SUBSYSTEM_COMMON,
@@ -14244,8 +14205,6 @@ lpfc_cq_create_set(struct lpfc_hba *phba, struct lp=
fc_queue **cqp,
 		hw_page_size =3D SLI4_PAGE_SIZE;
=20
 	mbox =3D mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
=2D	if (!mbox)
=2D		return -ENOMEM;
=20
 	length =3D sizeof(struct lpfc_mbx_cq_create_set);
 	length +=3D ((numcq * cqp[0]->page_count) *
@@ -14527,8 +14486,6 @@ lpfc_mq_create(struct lpfc_hba *phba, struct lpfc_q=
ueue *mq,
 		hw_page_size =3D SLI4_PAGE_SIZE;
=20
 	mbox =3D mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
=2D	if (!mbox)
=2D		return -ENOMEM;
 	length =3D (sizeof(struct lpfc_mbx_mq_create_ext) -
 		  sizeof(struct lpfc_sli4_cfg_mhdr));
 	lpfc_sli4_config(phba, mbox, LPFC_MBOX_SUBSYSTEM_COMMON,
@@ -14685,8 +14642,6 @@ lpfc_wq_create(struct lpfc_hba *phba, struct lpfc_q=
ueue *wq,
 		hw_page_size =3D SLI4_PAGE_SIZE;
=20
 	mbox =3D mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
=2D	if (!mbox)
=2D		return -ENOMEM;
 	length =3D (sizeof(struct lpfc_mbx_wq_create) -
 		  sizeof(struct lpfc_sli4_cfg_mhdr));
 	lpfc_sli4_config(phba, mbox, LPFC_MBOX_SUBSYSTEM_FCOE,
@@ -14928,8 +14883,6 @@ lpfc_rq_create(struct lpfc_hba *phba, struct lpfc_q=
ueue *hrq,
 	if (hrq->entry_count !=3D drq->entry_count)
 		return -EINVAL;
 	mbox =3D mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
=2D	if (!mbox)
=2D		return -ENOMEM;
 	length =3D (sizeof(struct lpfc_mbx_rq_create) -
 		  sizeof(struct lpfc_sli4_cfg_mhdr));
 	lpfc_sli4_config(phba, mbox, LPFC_MBOX_SUBSYSTEM_FCOE,
@@ -15203,8 +15156,6 @@ lpfc_mrq_create(struct lpfc_hba *phba, struct lpfc_=
queue **hrqp,
 		hw_page_size =3D SLI4_PAGE_SIZE;
=20
 	mbox =3D mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
=2D	if (!mbox)
=2D		return -ENOMEM;
=20
 	length =3D sizeof(struct lpfc_mbx_rq_create_v2);
 	length +=3D ((2 * numrq * hrqp[0]->page_count) *
@@ -15372,8 +15323,6 @@ lpfc_eq_destroy(struct lpfc_hba *phba, struct lpfc_=
queue *eq)
 	if (!eq)
 		return -ENODEV;
 	mbox =3D mempool_alloc(eq->phba->mbox_mem_pool, GFP_KERNEL);
=2D	if (!mbox)
=2D		return -ENOMEM;
 	length =3D (sizeof(struct lpfc_mbx_eq_destroy) -
 		  sizeof(struct lpfc_sli4_cfg_mhdr));
 	lpfc_sli4_config(phba, mbox, LPFC_MBOX_SUBSYSTEM_COMMON,
@@ -15428,8 +15377,6 @@ lpfc_cq_destroy(struct lpfc_hba *phba, struct lpfc_=
queue *cq)
 	if (!cq)
 		return -ENODEV;
 	mbox =3D mempool_alloc(cq->phba->mbox_mem_pool, GFP_KERNEL);
=2D	if (!mbox)
=2D		return -ENOMEM;
 	length =3D (sizeof(struct lpfc_mbx_cq_destroy) -
 		  sizeof(struct lpfc_sli4_cfg_mhdr));
 	lpfc_sli4_config(phba, mbox, LPFC_MBOX_SUBSYSTEM_COMMON,
@@ -15482,8 +15429,6 @@ lpfc_mq_destroy(struct lpfc_hba *phba, struct lpfc_=
queue *mq)
 	if (!mq)
 		return -ENODEV;
 	mbox =3D mempool_alloc(mq->phba->mbox_mem_pool, GFP_KERNEL);
=2D	if (!mbox)
=2D		return -ENOMEM;
 	length =3D (sizeof(struct lpfc_mbx_mq_destroy) -
 		  sizeof(struct lpfc_sli4_cfg_mhdr));
 	lpfc_sli4_config(phba, mbox, LPFC_MBOX_SUBSYSTEM_COMMON,
@@ -15536,8 +15481,6 @@ lpfc_wq_destroy(struct lpfc_hba *phba, struct lpfc_=
queue *wq)
 	if (!wq)
 		return -ENODEV;
 	mbox =3D mempool_alloc(wq->phba->mbox_mem_pool, GFP_KERNEL);
=2D	if (!mbox)
=2D		return -ENOMEM;
 	length =3D (sizeof(struct lpfc_mbx_wq_destroy) -
 		  sizeof(struct lpfc_sli4_cfg_mhdr));
 	lpfc_sli4_config(phba, mbox, LPFC_MBOX_SUBSYSTEM_FCOE,
@@ -15590,8 +15533,6 @@ lpfc_rq_destroy(struct lpfc_hba *phba, struct lpfc_=
queue *hrq,
 	if (!hrq || !drq)
 		return -ENODEV;
 	mbox =3D mempool_alloc(hrq->phba->mbox_mem_pool, GFP_KERNEL);
=2D	if (!mbox)
=2D		return -ENOMEM;
 	length =3D (sizeof(struct lpfc_mbx_rq_destroy) -
 		  sizeof(struct lpfc_sli4_cfg_mhdr));
 	lpfc_sli4_config(phba, mbox, LPFC_MBOX_SUBSYSTEM_FCOE,
@@ -15678,8 +15619,6 @@ lpfc_sli4_post_sgl(struct lpfc_hba *phba,
 	}
=20
 	mbox =3D mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
=2D	if (!mbox)
=2D		return -ENOMEM;
=20
 	lpfc_sli4_config(phba, mbox, LPFC_MBOX_SUBSYSTEM_FCOE,
 			LPFC_MBOX_OPCODE_FCOE_POST_SGL_PAGES,
@@ -15851,8 +15790,6 @@ lpfc_sli4_post_sgl_list(struct lpfc_hba *phba,
 	}
=20
 	mbox =3D mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
=2D	if (!mbox)
=2D		return -ENOMEM;
=20
 	/* Allocate DMA memory and set up the non-embedded mailbox command */
 	alloclen =3D lpfc_sli4_config(phba, mbox, LPFC_MBOX_SUBSYSTEM_FCOE,
@@ -15956,11 +15893,6 @@ lpfc_sli4_post_scsi_sgl_block(struct lpfc_hba *phb=
a,
 		return -ENOMEM;
 	}
 	mbox =3D mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
=2D	if (!mbox) {
=2D		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
=2D				"0283 Failed to allocate mbox cmd memory\n");
=2D		return -ENOMEM;
=2D	}
=20
 	/* Allocate DMA memory and set up the non-embedded mailbox command */
 	alloclen =3D lpfc_sli4_config(phba, mbox, LPFC_MBOX_SUBSYSTEM_FCOE,
@@ -16535,12 +16467,6 @@ lpfc_sli4_seq_abort_rsp(struct lpfc_vport *vport,
 	ndlp =3D lpfc_findnode_did(vport, sid);
 	if (!ndlp) {
 		ndlp =3D mempool_alloc(phba->nlp_mem_pool, GFP_KERNEL);
=2D		if (!ndlp) {
=2D			lpfc_printf_vlog(vport, KERN_WARNING, LOG_ELS,
=2D					 "1268 Failed to allocate ndlp for "
=2D					 "oxid:x%x SID:x%x\n", oxid, sid);
=2D			return;
=2D		}
 		lpfc_nlp_init(vport, ndlp, sid);
 		/* Put ndlp onto pport node list */
 		lpfc_enqueue_node(vport, ndlp);
@@ -17084,12 +17010,6 @@ lpfc_sli4_post_rpi_hdr(struct lpfc_hba *phba, stru=
ct lpfc_rpi_hdr *rpi_page)
=20
 	/* The port is notified of the header region via a mailbox command. */
 	mboxq =3D (LPFC_MBOXQ_t *) mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
=2D	if (!mboxq) {
=2D		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
=2D				"2001 Unable to allocate memory for issuing "
=2D				"SLI_CONFIG_SPECIAL mailbox command\n");
=2D		return -ENOMEM;
=2D	}
=20
 	/* Post all rpi memory regions to the port. */
 	hdr_tmpl =3D &mboxq->u.mqe.un.hdr_tmpl;
@@ -17272,8 +17192,6 @@ lpfc_sli4_resume_rpi(struct lpfc_nodelist *ndlp,
=20
 	/* The port is notified of the header region via a mailbox command. */
 	mboxq =3D mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
=2D	if (!mboxq)
=2D		return -ENOMEM;
=20
 	/* Post all rpi memory regions to the port. */
 	lpfc_resume_rpi(mboxq, ndlp);
@@ -17315,8 +17233,6 @@ lpfc_sli4_init_vpi(struct lpfc_vport *vport)
 	uint32_t mbox_tmo;
 	struct lpfc_hba *phba =3D vport->phba;
 	mboxq =3D mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
=2D	if (!mboxq)
=2D		return -ENOMEM;
 	lpfc_init_vpi(phba, mboxq, vport->vpi);
 	mbox_tmo =3D lpfc_mbox_tmo_val(phba, mboxq);
 	rc =3D lpfc_sli_issue_mbox_wait(phba, mboxq, mbox_tmo);
@@ -17386,11 +17302,6 @@ lpfc_sli4_add_fcf_record(struct lpfc_hba *phba, st=
ruct fcf_record *fcf_record)
 	uint32_t fcfindex;
=20
 	mboxq =3D mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
=2D	if (!mboxq) {
=2D		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
=2D			"2009 Failed to allocate mbox for ADD_FCF cmd\n");
=2D		return -ENOMEM;
=2D	}
=20
 	req_len =3D sizeof(struct fcf_record) + sizeof(union lpfc_sli4_cfg_shdr) +
 		  sizeof(uint32_t);
@@ -17505,13 +17416,6 @@ lpfc_sli4_fcf_scan_read_fcf_rec(struct lpfc_hba *p=
hba, uint16_t fcf_index)
 	phba->fcoe_eventtag_at_fcf_scan =3D phba->fcoe_eventtag;
 	phba->fcoe_cvl_eventtag_attn =3D phba->fcoe_cvl_eventtag;
 	mboxq =3D mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
=2D	if (!mboxq) {
=2D		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
=2D				"2000 Failed to allocate mbox for "
=2D				"READ_FCF cmd\n");
=2D		error =3D -ENOMEM;
=2D		goto fail_fcf_scan;
=2D	}
 	/* Construct the read FCF record mailbox command */
 	rc =3D lpfc_sli4_mbx_read_fcf_rec(phba, mboxq, fcf_index);
 	if (rc) {
@@ -17565,13 +17469,6 @@ lpfc_sli4_fcf_rr_read_fcf_rec(struct lpfc_hba *phb=
a, uint16_t fcf_index)
 	LPFC_MBOXQ_t *mboxq;
=20
 	mboxq =3D mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
=2D	if (!mboxq) {
=2D		lpfc_printf_log(phba, KERN_ERR, LOG_FIP | LOG_INIT,
=2D				"2763 Failed to allocate mbox for "
=2D				"READ_FCF cmd\n");
=2D		error =3D -ENOMEM;
=2D		goto fail_fcf_read;
=2D	}
 	/* Construct the read FCF record mailbox command */
 	rc =3D lpfc_sli4_mbx_read_fcf_rec(phba, mboxq, fcf_index);
 	if (rc) {
@@ -17611,13 +17508,6 @@ lpfc_sli4_read_fcf_rec(struct lpfc_hba *phba, uint=
16_t fcf_index)
 	LPFC_MBOXQ_t *mboxq;
=20
 	mboxq =3D mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
=2D	if (!mboxq) {
=2D		lpfc_printf_log(phba, KERN_ERR, LOG_FIP | LOG_INIT,
=2D				"2758 Failed to allocate mbox for "
=2D				"READ_FCF cmd\n");
=2D				error =3D -ENOMEM;
=2D				goto fail_fcf_read;
=2D	}
 	/* Construct the read FCF record mailbox command */
 	rc =3D lpfc_sli4_mbx_read_fcf_rec(phba, mboxq, fcf_index);
 	if (rc) {
@@ -17955,13 +17845,6 @@ lpfc_sli4_redisc_fcf_table(struct lpfc_hba *phba)
 	lpfc_cancel_all_vport_retry_delay_timer(phba);
=20
 	mbox =3D mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
=2D	if (!mbox) {
=2D		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
=2D				"2745 Failed to allocate mbox for "
=2D				"requesting FCF rediscover.\n");
=2D		return -ENOMEM;
=2D	}
=2D
 	length =3D (sizeof(struct lpfc_mbx_redisc_fcf_tbl) -
 		  sizeof(struct lpfc_sli4_cfg_mhdr));
 	lpfc_sli4_config(phba, mbox, LPFC_MBOX_SUBSYSTEM_FCOE,
@@ -18030,11 +17913,6 @@ lpfc_sli_get_config_region23(struct lpfc_hba *phba=
, char *rgn23_data)
 		return 0;
=20
 	pmb =3D mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
=2D	if (!pmb) {
=2D		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
=2D				"2600 failed to allocate mailbox memory\n");
=2D		return 0;
=2D	}
 	mb =3D &pmb->u.mb;
=20
 	do {
@@ -18089,12 +17967,6 @@ lpfc_sli4_get_config_region23(struct lpfc_hba *phb=
a, char *rgn23_data)
 		return 0;
=20
 	mboxq =3D mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
=2D	if (!mboxq) {
=2D		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
=2D				"3105 failed to allocate mailbox memory\n");
=2D		return 0;
=2D	}
=2D
 	if (lpfc_sli4_dump_cfg_rg23(phba, mboxq))
 		goto out;
 	mqe =3D &mboxq->u.mqe;
@@ -18250,9 +18122,6 @@ lpfc_wr_object(struct lpfc_hba *phba, struct list_h=
ead *dmabuf_list,
 	uint32_t written =3D 0;
=20
 	mbox =3D mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
=2D	if (!mbox)
=2D		return -ENOMEM;
=2D
 	lpfc_sli4_config(phba, mbox, LPFC_MBOX_SUBSYSTEM_COMMON,
 			LPFC_MBOX_OPCODE_WRITE_OBJECT,
 			sizeof(struct lpfc_mbx_wr_object) -
diff --git a/drivers/scsi/lpfc/lpfc_vport.c b/drivers/scsi/lpfc/lpfc_vport.c
index 9a0339dbc024..c7a2246ba6f4 100644
=2D-- a/drivers/scsi/lpfc/lpfc_vport.c
+++ b/drivers/scsi/lpfc/lpfc_vport.c
@@ -123,9 +123,6 @@ lpfc_vport_sparm(struct lpfc_hba *phba, struct lpfc_vpo=
rt *vport)
 	int  rc;
=20
 	pmb =3D mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
=2D	if (!pmb) {
=2D		return -ENOMEM;
=2D	}
 	mb =3D &pmb->u.mb;
=20
 	rc =3D lpfc_read_sparam(phba, pmb, vport->vpi);
@@ -739,8 +736,6 @@ lpfc_vport_delete(struct fc_vport *fc_vport)
 		if (!ndlp) {
 			/* Cannot find existing Fabric ndlp, allocate one */
 			ndlp =3D mempool_alloc(phba->nlp_mem_pool, GFP_KERNEL);
=2D			if (!ndlp)
=2D				goto skip_logo;
 			lpfc_nlp_init(vport, ndlp, Fabric_DID);
 			/* Indicate free memory when release */
 			NLP_SET_FREE_REQ(ndlp);
=2D-=20
2.12.2


--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAljq6BoACgkQOeye3VZi
gbn/2g/+Iby/IHNJOAzW+2fAmmN8HRpN8txCVl7iRmN3MQkLAs1QIeGlaS8GG0tZ
yvx5+hFgsxP55wyDFWW7HFp/1dp8aPJaTZE6d4yqF717il0gW6S7lE2Ya/OwCnGX
k4DgWZAS8Ah4xIs84D1OT+eyiAM+iIlM07gawNzH1o8ONe2rzmnbc2LFjusVWDrN
NsDdnFTDxFCqm05YHwu9CskgbcKK4EsGrWs1qxTO2MDQfgivphseGwHIAqAXaMv4
H3D7CndAsAd3LEux5kivoL22wVsDps5M6IehEq58aHlfeck+VLRDnTm2/65JYPws
I/NCWgE4UeZzbloIUX5Ma1dawGJXt1XCZY1ervAFEQPJaFIhNRL5EiEdSDya/8HP
O7YmqKCIMmpEZvGsrDqMTPXaaYCJaXAS9pQ8hCkVe89lySQ/Z/3w52bT9PwI2PUi
99pNOMSxqG+nzBSGiGTsGO1RYD7wFt+k3Kfiiz2L7WwqBgrG1qsx7ncvctyUXSrM
5AlYrDcMQbUO8I4NJKXvstf5h6jS4MBWeDjjhzbsYswVt7rvIHHUuC3hOC+2zzWM
RYq36n5BAWNZoIIHjwnfbCktMYC9HgXl0MAmxBCK7deQ2hZ8FYC36OILWqSZW/XC
TSoHMMHGZIFSp+8qiZiyZGEuZ7V16DE7+SJqhGTWPbsups6LCQE=
=rfZp
-----END PGP SIGNATURE-----
--=-=-=--

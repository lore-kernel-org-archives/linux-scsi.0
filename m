From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 09/12] be2iscsi: Couple MCC tag and WRB alloc and free
Date: Mon, 1 Feb 2016 13:14:10 +0100
Message-ID: <20160201121410.GI27969@c203.arch.suse.de>
References: <1454321571-16167-1-git-send-email-jitendra.bhivare@avagotech.com>
 <1454321571-16167-10-git-send-email-jitendra.bhivare@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37607 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753716AbcBAMOP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 1 Feb 2016 07:14:15 -0500
Content-Disposition: inline
In-Reply-To: <1454321571-16167-10-git-send-email-jitendra.bhivare@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jitendra Bhivare <jitendra.bhivare@avagotech.com>
Cc: linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu

On Mon, Feb 01, 2016 at 03:42:48PM +0530, Jitendra Bhivare wrote:
> WARN_ON(atomic_read(&mccq->used) >=3D mccq->len) seen when FW gets in=
to UE.
>=20
> MCCQ overflow is happening because driver discards any new request an=
d
> frees up the tag. The tag allocation controls the number of MCC WRB p=
osted.
> It is being replenished but WRBs are not hence the WARN_ON.
>=20
> Allocation and freeing of WRB and tags for MCC is now done in one pla=
ce.
> This helps to achieve proper accounting of WRB indices and MCC tags.
>=20
> Signed-off-by: Jitendra Bhivare <jitendra.bhivare@avagotech.com>
> ---
>  drivers/scsi/be2iscsi/be.h      |   2 +-
>  drivers/scsi/be2iscsi/be_cmds.c | 103 +++++++++++++++++++++---------
>  drivers/scsi/be2iscsi/be_cmds.h |   6 +-
>  drivers/scsi/be2iscsi/be_main.c |   3 +-
>  drivers/scsi/be2iscsi/be_mgmt.c | 134 +++++++++++++++---------------=
----------
>  5 files changed, 130 insertions(+), 118 deletions(-)
>=20
> diff --git a/drivers/scsi/be2iscsi/be.h b/drivers/scsi/be2iscsi/be.h
> index da1d87a..ee5ace8 100644
> --- a/drivers/scsi/be2iscsi/be.h
> +++ b/drivers/scsi/be2iscsi/be.h
> @@ -42,7 +42,7 @@ struct be_queue_info {
>  	u16 id;
>  	u16 tail, head;
>  	bool created;
> -	atomic_t used;		/* Number of valid elements in the queue */
> +	u16 used;		/* Number of valid elements in the queue */
>  };
> =20
>  static inline u32 MODULO(u16 val, u16 limit)
> diff --git a/drivers/scsi/be2iscsi/be_cmds.c b/drivers/scsi/be2iscsi/=
be_cmds.c
> index 728aa133..a55eaee 100644
> --- a/drivers/scsi/be2iscsi/be_cmds.c
> +++ b/drivers/scsi/be2iscsi/be_cmds.c
> @@ -126,8 +126,62 @@ unsigned int alloc_mcc_tag(struct beiscsi_hba *p=
hba)
>  	return tag;
>  }
> =20
> -void free_mcc_tag(struct be_ctrl_info *ctrl, unsigned int tag)
> +struct be_mcc_wrb *alloc_mcc_wrb(struct beiscsi_hba *phba,
> +				 unsigned int *ref_tag)
>  {
> +	struct be_queue_info *mccq =3D &phba->ctrl.mcc_obj.q;
> +	struct be_mcc_wrb *wrb =3D NULL;
> +	unsigned int tag;
> +
> +	spin_lock_bh(&phba->ctrl.mcc_lock);
> +	if (mccq->used =3D=3D mccq->len) {
> +		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT |
> +			    BEISCSI_LOG_CONFIG | BEISCSI_LOG_MBOX,
> +			    "BC_%d : MCC queue full: WRB used %u tag avail %u\n",
> +			    mccq->used, phba->ctrl.mcc_tag_available);
> +		goto alloc_failed;
> +	}
> +
> +	if (!phba->ctrl.mcc_tag_available)
> +		goto alloc_failed;
> +
> +	tag =3D phba->ctrl.mcc_tag[phba->ctrl.mcc_alloc_index];
> +	if (!tag) {
> +		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT |
> +			    BEISCSI_LOG_CONFIG | BEISCSI_LOG_MBOX,
> +			    "BC_%d : MCC tag 0 allocated: tag avail %u alloc index %u\n",
> +			    phba->ctrl.mcc_tag_available,
> +			    phba->ctrl.mcc_alloc_index);
> +		goto alloc_failed;
> +	}
> +
> +	/* return this tag for further reference */
> +	*ref_tag =3D tag;
> +	phba->ctrl.mcc_tag[phba->ctrl.mcc_alloc_index] =3D 0;
> +	phba->ctrl.mcc_tag_status[tag] =3D 0;
> +	phba->ctrl.ptag_state[tag].tag_state =3D 0;
> +	phba->ctrl.mcc_tag_available--;
> +	if (phba->ctrl.mcc_alloc_index =3D=3D (MAX_MCC_CMD - 1))
> +		phba->ctrl.mcc_alloc_index =3D 0;
> +	else
> +		phba->ctrl.mcc_alloc_index++;
> +
> +	wrb =3D queue_head_node(mccq);
> +	memset(wrb, 0, sizeof(*wrb));
> +	wrb->tag0 =3D tag;
> +	wrb->tag0 |=3D (mccq->head << MCC_Q_WRB_IDX_SHIFT) & MCC_Q_WRB_IDX_=
MASK;
> +	queue_head_inc(mccq);
> +	mccq->used++;
> +
> +alloc_failed:
> +	spin_unlock_bh(&phba->ctrl.mcc_lock);
> +	return wrb;
> +}
> +
> +void free_mcc_wrb(struct be_ctrl_info *ctrl, unsigned int tag)
> +{
> +	struct be_queue_info *mccq =3D &ctrl->mcc_obj.q;
> +
>  	spin_lock_bh(&ctrl->mcc_lock);
>  	tag =3D tag & MCC_Q_CMD_TAG_MASK;
>  	ctrl->mcc_tag[ctrl->mcc_free_index] =3D tag;
> @@ -136,6 +190,7 @@ void free_mcc_tag(struct be_ctrl_info *ctrl, unsi=
gned int tag)
>  	else
>  		ctrl->mcc_free_index++;
>  	ctrl->mcc_tag_available++;
> +	mccq->used--;
>  	spin_unlock_bh(&ctrl->mcc_lock);
>  }
> =20
> @@ -173,10 +228,8 @@ int beiscsi_mccq_compl_wait(struct beiscsi_hba *=
phba,
>  	struct be_cmd_resp_hdr *mbx_resp_hdr;
>  	struct be_queue_info *mccq =3D &phba->ctrl.mcc_obj.q;
> =20
> -	if (beiscsi_error(phba)) {
> -		free_mcc_tag(&phba->ctrl, tag);
> +	if (beiscsi_error(phba))
>  		return -EPERM;
> -	}
> =20
>  	/* wait for the mccq completion */
>  	rc =3D wait_event_interruptible_timeout(
> @@ -259,7 +312,7 @@ int beiscsi_mccq_compl_wait(struct beiscsi_hba *p=
hba,
>  		}
>  	}
> =20
> -	free_mcc_tag(&phba->ctrl, tag);
> +	free_mcc_wrb(&phba->ctrl, tag);
>  	return rc;
>  }
> =20
> @@ -479,7 +532,7 @@ int beiscsi_process_mcc_compl(struct be_ctrl_info=
 *ctrl,
>  		if (tag_mem->size)
>  			pci_free_consistent(ctrl->pdev, tag_mem->size,
>  					tag_mem->va, tag_mem->dma);
> -		free_mcc_tag(ctrl, tag);
> +		free_mcc_wrb(ctrl, tag);
>  		return 0;
>  	}
> =20
> @@ -519,15 +572,24 @@ int be_mcc_compl_poll(struct beiscsi_hba *phba,=
 unsigned int tag)
>  	struct be_ctrl_info *ctrl =3D &phba->ctrl;
>  	int i;
> =20
> +	if (!test_bit(MCC_TAG_STATE_RUNNING,
> +		      &ctrl->ptag_state[tag].tag_state)) {
> +		beiscsi_log(phba, KERN_ERR,
> +			    BEISCSI_LOG_CONFIG | BEISCSI_LOG_MBOX,
> +			    "BC_%d: tag %u state not running\n", tag);
> +		return 0;
> +	}
>  	for (i =3D 0; i < mcc_timeout; i++) {
>  		if (beiscsi_error(phba))
>  			return -EIO;
> =20
>  		beiscsi_process_mcc_cq(phba);
> -
> +		/* after polling, wrb and tag need to be released */
>  		if (!test_bit(MCC_TAG_STATE_RUNNING,
> -			      &ctrl->ptag_state[tag].tag_state))
> +			      &ctrl->ptag_state[tag].tag_state)) {
> +			free_mcc_wrb(ctrl, tag);
>  			break;
> +		}
>  		udelay(100);
>  	}
> =20
> @@ -717,21 +779,6 @@ struct be_mcc_wrb *wrb_from_mbox(struct be_dma_m=
em *mbox_mem)
>  	return &((struct be_mcc_mailbox *)(mbox_mem->va))->wrb;
>  }
> =20
> -struct be_mcc_wrb *wrb_from_mccq(struct beiscsi_hba *phba)
> -{
> -	struct be_queue_info *mccq =3D &phba->ctrl.mcc_obj.q;
> -	struct be_mcc_wrb *wrb;
> -
> -	WARN_ON(atomic_read(&mccq->used) >=3D mccq->len);
> -	wrb =3D queue_head_node(mccq);
> -	memset(wrb, 0, sizeof(*wrb));
> -	wrb->tag0 =3D (mccq->head << MCC_Q_WRB_IDX_SHIFT) & MCC_Q_WRB_IDX_M=
ASK;
> -	queue_head_inc(mccq);
> -	atomic_inc(&mccq->used);
> -	return wrb;
> -}
> -
> -
>  int beiscsi_cmd_eq_create(struct be_ctrl_info *ctrl,
>  			  struct be_queue_info *eq, int eq_delay)
>  {
> @@ -1328,22 +1375,20 @@ int beiscsi_cmd_reset_function(struct beiscsi=
_hba  *phba)
>  int be_cmd_set_vlan(struct beiscsi_hba *phba,
>  		     uint16_t vlan_tag)
>  {
> -	unsigned int tag =3D 0;
> +	unsigned int tag;
>  	struct be_mcc_wrb *wrb;
>  	struct be_cmd_set_vlan_req *req;
>  	struct be_ctrl_info *ctrl =3D &phba->ctrl;
> =20
>  	if (mutex_lock_interruptible(&ctrl->mbox_lock))
>  		return 0;
> -	tag =3D alloc_mcc_tag(phba);
> -	if (!tag) {
> +	wrb =3D alloc_mcc_wrb(phba, &tag);
> +	if (!wrb) {
>  		mutex_unlock(&ctrl->mbox_lock);
> -		return tag;
> +		return 0;
>  	}
> =20
> -	wrb =3D wrb_from_mccq(phba);
>  	req =3D embedded_payload(wrb);
> -	wrb->tag0 |=3D tag;
>  	be_wrb_hdr_prepare(wrb, sizeof(*wrb), true, 0);
>  	be_cmd_hdr_prepare(&req->hdr, CMD_SUBSYSTEM_ISCSI,
>  			   OPCODE_COMMON_ISCSI_NTWK_SET_VLAN,
> diff --git a/drivers/scsi/be2iscsi/be_cmds.h b/drivers/scsi/be2iscsi/=
be_cmds.h
> index b14ac01..deeb951 100644
> --- a/drivers/scsi/be2iscsi/be_cmds.h
> +++ b/drivers/scsi/be2iscsi/be_cmds.h
> @@ -728,7 +728,7 @@ int mgmt_check_supported_fw(struct be_ctrl_info *=
ctrl,
>  				      struct beiscsi_hba *phba);
>  unsigned int be_cmd_get_initname(struct beiscsi_hba *phba);
> =20
> -void free_mcc_tag(struct be_ctrl_info *ctrl, unsigned int tag);
> +void free_mcc_wrb(struct be_ctrl_info *ctrl, unsigned int tag);
> =20
>  int be_cmd_modify_eq_delay(struct beiscsi_hba *phba, struct be_set_e=
qd *,
>  			    int num);
> @@ -740,10 +740,10 @@ int be_cmd_fw_initialize(struct be_ctrl_info *c=
trl);
>  int be_cmd_fw_uninit(struct be_ctrl_info *ctrl);
> =20
>  struct be_mcc_wrb *wrb_from_mbox(struct be_dma_mem *mbox_mem);
> -struct be_mcc_wrb *wrb_from_mccq(struct beiscsi_hba *phba);
>  int be_mcc_compl_poll(struct beiscsi_hba *phba, unsigned int tag);
>  void be_mcc_notify(struct beiscsi_hba *phba, unsigned int tag);
> -unsigned int alloc_mcc_tag(struct beiscsi_hba *phba);
> +struct be_mcc_wrb *alloc_mcc_wrb(struct beiscsi_hba *phba,
> +				 unsigned int *ref_tag);
>  void beiscsi_process_async_event(struct beiscsi_hba *phba,
>  				struct be_mcc_compl *compl);
>  int beiscsi_process_mcc_compl(struct be_ctrl_info *ctrl,
> diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/=
be_main.c
> index dfc2ee9..3f08a11 100644
> --- a/drivers/scsi/be2iscsi/be_main.c
> +++ b/drivers/scsi/be2iscsi/be_main.c
> @@ -2047,7 +2047,6 @@ void beiscsi_process_mcc_cq(struct beiscsi_hba =
*phba)
>  			beiscsi_process_async_event(phba, mcc_compl);
>  		} else if (mcc_compl->flags & CQE_FLAGS_COMPLETED_MASK) {
>  			beiscsi_process_mcc_compl(&phba->ctrl, mcc_compl);
> -			atomic_dec(&phba->ctrl.mcc_obj.q.used);
>  		}
> =20
>  		mcc_compl->flags =3D 0;
> @@ -5245,7 +5244,7 @@ static int beiscsi_bsg_request(struct bsg_job *=
job)
>  		extd_status =3D (phba->ctrl.mcc_tag_status[tag] &
>  			       CQE_STATUS_ADDL_MASK) >> CQE_STATUS_ADDL_SHIFT;
>  		status =3D phba->ctrl.mcc_tag_status[tag] & CQE_STATUS_MASK;
> -		free_mcc_tag(&phba->ctrl, tag);
> +		free_mcc_wrb(&phba->ctrl, tag);
>  		resp =3D (struct be_cmd_resp_hdr *)nonemb_cmd.va;
>  		sg_copy_from_buffer(job->reply_payload.sg_list,
>  				    job->reply_payload.sg_cnt,
> diff --git a/drivers/scsi/be2iscsi/be_mgmt.c b/drivers/scsi/be2iscsi/=
be_mgmt.c
> index ccac1d7..83926e2 100644
> --- a/drivers/scsi/be2iscsi/be_mgmt.c
> +++ b/drivers/scsi/be2iscsi/be_mgmt.c
> @@ -161,20 +161,17 @@ int be_cmd_modify_eq_delay(struct beiscsi_hba *=
phba,
>  	struct be_ctrl_info *ctrl =3D &phba->ctrl;
>  	struct be_mcc_wrb *wrb;
>  	struct be_cmd_req_modify_eq_delay *req;
> -	unsigned int tag =3D 0;
> +	unsigned int tag;
>  	int i;
> =20
>  	mutex_lock(&ctrl->mbox_lock);
> -	tag =3D alloc_mcc_tag(phba);
> -	if (!tag) {
> +	wrb =3D alloc_mcc_wrb(phba, &tag);
> +	if (!wrb) {
>  		mutex_unlock(&ctrl->mbox_lock);
> -		return tag;
> +		return 0;
>  	}
> =20
> -	wrb =3D wrb_from_mccq(phba);
>  	req =3D embedded_payload(wrb);
> -
> -	wrb->tag0 |=3D tag;
>  	be_wrb_hdr_prepare(wrb, sizeof(*req), true, 0);
>  	be_cmd_hdr_prepare(&req->hdr, CMD_SUBSYSTEM_COMMON,
>  		OPCODE_COMMON_MODIFY_EQ_DELAY, sizeof(*req));
> @@ -209,22 +206,20 @@ unsigned int mgmt_reopen_session(struct beiscsi=
_hba *phba,
>  	struct be_ctrl_info *ctrl =3D &phba->ctrl;
>  	struct be_mcc_wrb *wrb;
>  	struct be_cmd_reopen_session_req *req;
> -	unsigned int tag =3D 0;
> +	unsigned int tag;
> =20
>  	beiscsi_log(phba, KERN_INFO,
>  		    BEISCSI_LOG_CONFIG | BEISCSI_LOG_MBOX,
>  		    "BG_%d : In bescsi_get_boot_target\n");
> =20
>  	mutex_lock(&ctrl->mbox_lock);
> -	tag =3D alloc_mcc_tag(phba);
> -	if (!tag) {
> +	wrb =3D alloc_mcc_wrb(phba, &tag);
> +	if (!wrb) {
>  		mutex_unlock(&ctrl->mbox_lock);
> -		return tag;
> +		return 0;
>  	}
> =20
> -	wrb =3D wrb_from_mccq(phba);
>  	req =3D embedded_payload(wrb);
> -	wrb->tag0 |=3D tag;
>  	be_wrb_hdr_prepare(wrb, sizeof(*req), true, 0);
>  	be_cmd_hdr_prepare(&req->hdr, CMD_SUBSYSTEM_ISCSI_INI,
>  			   OPCODE_ISCSI_INI_DRIVER_REOPEN_ALL_SESSIONS,
> @@ -244,22 +239,20 @@ unsigned int mgmt_get_boot_target(struct beiscs=
i_hba *phba)
>  	struct be_ctrl_info *ctrl =3D &phba->ctrl;
>  	struct be_mcc_wrb *wrb;
>  	struct be_cmd_get_boot_target_req *req;
> -	unsigned int tag =3D 0;
> +	unsigned int tag;
> =20
>  	beiscsi_log(phba, KERN_INFO,
>  		    BEISCSI_LOG_CONFIG | BEISCSI_LOG_MBOX,
>  		    "BG_%d : In bescsi_get_boot_target\n");
> =20
>  	mutex_lock(&ctrl->mbox_lock);
> -	tag =3D alloc_mcc_tag(phba);
> -	if (!tag) {
> +	wrb =3D alloc_mcc_wrb(phba, &tag);
> +	if (!wrb) {
>  		mutex_unlock(&ctrl->mbox_lock);
> -		return tag;
> +		return 0;
>  	}
> =20
> -	wrb =3D wrb_from_mccq(phba);
>  	req =3D embedded_payload(wrb);
> -	wrb->tag0 |=3D tag;
>  	be_wrb_hdr_prepare(wrb, sizeof(*req), true, 0);
>  	be_cmd_hdr_prepare(&req->hdr, CMD_SUBSYSTEM_ISCSI_INI,
>  			   OPCODE_ISCSI_INI_BOOT_GET_BOOT_TARGET,
> @@ -276,7 +269,7 @@ unsigned int mgmt_get_session_info(struct beiscsi=
_hba *phba,
>  {
>  	struct be_ctrl_info *ctrl =3D &phba->ctrl;
>  	struct be_mcc_wrb *wrb;
> -	unsigned int tag =3D 0;
> +	unsigned int tag;
>  	struct  be_cmd_get_session_req *req;
>  	struct be_cmd_get_session_resp *resp;
>  	struct be_sge *sge;
> @@ -286,21 +279,16 @@ unsigned int mgmt_get_session_info(struct beisc=
si_hba *phba,
>  		    "BG_%d : In beiscsi_get_session_info\n");
> =20
>  	mutex_lock(&ctrl->mbox_lock);
> -	tag =3D alloc_mcc_tag(phba);
> -	if (!tag) {
> +	wrb =3D alloc_mcc_wrb(phba, &tag);
> +	if (!wrb) {
>  		mutex_unlock(&ctrl->mbox_lock);
> -		return tag;
> +		return 0;
>  	}
> =20
>  	nonemb_cmd->size =3D sizeof(*resp);
>  	req =3D nonemb_cmd->va;
>  	memset(req, 0, sizeof(*req));
> -	wrb =3D wrb_from_mccq(phba);
>  	sge =3D nonembedded_sgl(wrb);
> -	wrb->tag0 |=3D tag;
> -
> -
> -	wrb->tag0 |=3D tag;
>  	be_wrb_hdr_prepare(wrb, sizeof(*req), false, 1);
>  	be_cmd_hdr_prepare(&req->hdr, CMD_SUBSYSTEM_ISCSI_INI,
>  			   OPCODE_ISCSI_INI_SESSION_GET_A_SESSION,
> @@ -624,20 +612,18 @@ unsigned int mgmt_vendor_specific_fw_cmd(struct=
 be_ctrl_info *ctrl,
>  		return -ENOSYS;
>  	}
> =20
> -	tag =3D alloc_mcc_tag(phba);
> -	if (!tag) {
> +	wrb =3D alloc_mcc_wrb(phba, &tag);
> +	if (!wrb) {
>  		mutex_unlock(&ctrl->mbox_lock);
> -		return tag;
> +		return 0;
>  	}
> =20
> -	wrb =3D wrb_from_mccq(phba);
>  	mcc_sge =3D nonembedded_sgl(wrb);
>  	be_wrb_hdr_prepare(wrb, nonemb_cmd->size, false,
>  			   job->request_payload.sg_cnt);
>  	mcc_sge->pa_hi =3D cpu_to_le32(upper_32_bits(nonemb_cmd->dma));
>  	mcc_sge->pa_lo =3D cpu_to_le32(nonemb_cmd->dma & 0xFFFFFFFF);
>  	mcc_sge->len =3D cpu_to_le32(nonemb_cmd->size);
> -	wrb->tag0 |=3D tag;
> =20
>  	be_mcc_notify(phba, tag);
> =20
> @@ -657,22 +643,22 @@ unsigned int mgmt_vendor_specific_fw_cmd(struct=
 be_ctrl_info *ctrl,
>  int mgmt_epfw_cleanup(struct beiscsi_hba *phba, unsigned short ulp_n=
um)
>  {
>  	struct be_ctrl_info *ctrl =3D &phba->ctrl;
> -	struct be_mcc_wrb *wrb =3D wrb_from_mccq(phba);
> -	struct iscsi_cleanup_req *req =3D embedded_payload(wrb);
> +	struct be_mcc_wrb *wrb;
> +	struct iscsi_cleanup_req *req;
>  	unsigned int tag;
>  	int status;
> =20
>  	mutex_lock(&ctrl->mbox_lock);
> -	tag =3D alloc_mcc_tag(phba);
> -	if (!tag) {
> +	wrb =3D alloc_mcc_wrb(phba, &tag);
> +	if (!wrb) {
>  		mutex_unlock(&ctrl->mbox_lock);
>  		return -EBUSY;
>  	}
> =20
> +	req =3D embedded_payload(wrb);
>  	be_wrb_hdr_prepare(wrb, sizeof(*req), true, 0);
>  	be_cmd_hdr_prepare(&req->hdr, CMD_SUBSYSTEM_ISCSI,
>  			   OPCODE_COMMON_ISCSI_CLEANUP, sizeof(*req));
> -	wrb->tag0 |=3D tag;
> =20
>  	req->chute =3D (1 << ulp_num);
>  	req->hdr_ring_id =3D cpu_to_le16(HWI_GET_DEF_HDRQ_ID(phba, ulp_num)=
);
> @@ -697,20 +683,18 @@ unsigned int  mgmt_invalidate_icds(struct beisc=
si_hba *phba,
>  	struct be_mcc_wrb *wrb;
>  	struct be_sge *sge;
>  	struct invalidate_commands_params_in *req;
> -	unsigned int i, tag =3D 0;
> +	unsigned int i, tag;
> =20
>  	mutex_lock(&ctrl->mbox_lock);
> -	tag =3D alloc_mcc_tag(phba);
> -	if (!tag) {
> +	wrb =3D alloc_mcc_wrb(phba, &tag);
> +	if (!wrb) {
>  		mutex_unlock(&ctrl->mbox_lock);
> -		return tag;
> +		return 0;
>  	}
> =20
>  	req =3D nonemb_cmd->va;
>  	memset(req, 0, sizeof(*req));
> -	wrb =3D wrb_from_mccq(phba);
>  	sge =3D nonembedded_sgl(wrb);
> -	wrb->tag0 |=3D tag;
> =20
>  	be_wrb_hdr_prepare(wrb, sizeof(*req), false, 1);
>  	be_cmd_hdr_prepare(&req->hdr, CMD_SUBSYSTEM_ISCSI,
> @@ -745,15 +729,13 @@ unsigned int mgmt_invalidate_connection(struct =
beiscsi_hba *phba,
>  	unsigned int tag =3D 0;
> =20
>  	mutex_lock(&ctrl->mbox_lock);
> -	tag =3D alloc_mcc_tag(phba);
> -	if (!tag) {
> +	wrb =3D alloc_mcc_wrb(phba, &tag);
> +	if (!wrb) {
>  		mutex_unlock(&ctrl->mbox_lock);
> -		return tag;
> +		return 0;
>  	}
> -	wrb =3D wrb_from_mccq(phba);
> -	wrb->tag0 |=3D tag;
> -	req =3D embedded_payload(wrb);
> =20
> +	req =3D embedded_payload(wrb);
>  	be_wrb_hdr_prepare(wrb, sizeof(*req), true, 0);
>  	be_cmd_hdr_prepare(&req->hdr, CMD_SUBSYSTEM_ISCSI_INI,
>  			   OPCODE_ISCSI_INI_DRIVER_INVALIDATE_CONNECTION,
> @@ -776,18 +758,16 @@ unsigned int mgmt_upload_connection(struct beis=
csi_hba *phba,
>  	struct be_ctrl_info *ctrl =3D &phba->ctrl;
>  	struct be_mcc_wrb *wrb;
>  	struct tcp_upload_params_in *req;
> -	unsigned int tag =3D 0;
> +	unsigned int tag;
> =20
>  	mutex_lock(&ctrl->mbox_lock);
> -	tag =3D alloc_mcc_tag(phba);
> -	if (!tag) {
> +	wrb =3D alloc_mcc_wrb(phba, &tag);
> +	if (!wrb) {
>  		mutex_unlock(&ctrl->mbox_lock);
> -		return tag;
> +		return 0;
>  	}
> -	wrb =3D wrb_from_mccq(phba);
> -	req =3D embedded_payload(wrb);
> -	wrb->tag0 |=3D tag;
> =20
> +	req =3D embedded_payload(wrb);
>  	be_wrb_hdr_prepare(wrb, sizeof(*req), true, 0);
>  	be_cmd_hdr_prepare(&req->hdr, CMD_COMMON_TCP_UPLOAD,
>  			   OPCODE_COMMON_TCP_UPLOAD, sizeof(*req));
> @@ -848,17 +828,15 @@ int mgmt_open_connection(struct beiscsi_hba *ph=
ba,
>  	ISCSI_GET_PDU_TEMPLATE_ADDRESS(phba, ptemplate_address);
>  	if (mutex_lock_interruptible(&ctrl->mbox_lock))
>  		return 0;
> -	tag =3D alloc_mcc_tag(phba);
> -	if (!tag) {
> +	wrb =3D alloc_mcc_wrb(phba, &tag);
> +	if (!wrb) {
>  		mutex_unlock(&ctrl->mbox_lock);
> -		return tag;
> +		return 0;
>  	}
> -	wrb =3D wrb_from_mccq(phba);
> -	sge =3D nonembedded_sgl(wrb);
> =20
> +	sge =3D nonembedded_sgl(wrb);
>  	req =3D nonemb_cmd->va;
>  	memset(req, 0, sizeof(*req));
> -	wrb->tag0 |=3D tag;
> =20
>  	be_wrb_hdr_prepare(wrb, nonemb_cmd->size, false, 1);
>  	be_cmd_hdr_prepare(&req->hdr, CMD_SUBSYSTEM_ISCSI,
> @@ -925,16 +903,13 @@ unsigned int mgmt_get_all_if_id(struct beiscsi_=
hba *phba)
> =20
>  	if (mutex_lock_interruptible(&ctrl->mbox_lock))
>  		return -EINTR;
> -	tag =3D alloc_mcc_tag(phba);
> -	if (!tag) {
> +	wrb =3D alloc_mcc_wrb(phba, &tag);
> +	if (!wrb) {
>  		mutex_unlock(&ctrl->mbox_lock);
>  		return -ENOMEM;
>  	}
> =20
> -	wrb =3D wrb_from_mccq(phba);
>  	req =3D embedded_payload(wrb);
> -	wrb->tag0 |=3D tag;
> -
>  	be_wrb_hdr_prepare(wrb, sizeof(*req), true, 0);
>  	be_cmd_hdr_prepare(&req->hdr, CMD_SUBSYSTEM_ISCSI,
>  			   OPCODE_COMMON_ISCSI_NTWK_GET_ALL_IF_ID,
> @@ -974,17 +949,14 @@ static int mgmt_exec_nonemb_cmd(struct beiscsi_=
hba *phba,
>  	int rc =3D 0;
> =20
>  	mutex_lock(&ctrl->mbox_lock);
> -	tag =3D alloc_mcc_tag(phba);
> -	if (!tag) {
> +	wrb =3D alloc_mcc_wrb(phba, &tag);
> +	if (!wrb) {
>  		mutex_unlock(&ctrl->mbox_lock);
>  		rc =3D -ENOMEM;
>  		goto free_cmd;
>  	}
> =20
> -	wrb =3D wrb_from_mccq(phba);
> -	wrb->tag0 |=3D tag;
>  	sge =3D nonembedded_sgl(wrb);
> -
>  	be_wrb_hdr_prepare(wrb, nonemb_cmd->size, false, 1);
>  	sge->pa_hi =3D cpu_to_le32(upper_32_bits(nonemb_cmd->dma));
>  	sge->pa_lo =3D cpu_to_le32(lower_32_bits(nonemb_cmd->dma));
> @@ -1368,22 +1340,20 @@ int mgmt_get_nic_conf(struct beiscsi_hba *phb=
a,
> =20
>  unsigned int be_cmd_get_initname(struct beiscsi_hba *phba)
>  {
> -	unsigned int tag =3D 0;
> +	unsigned int tag;
>  	struct be_mcc_wrb *wrb;
>  	struct be_cmd_hba_name *req;
>  	struct be_ctrl_info *ctrl =3D &phba->ctrl;
> =20
>  	if (mutex_lock_interruptible(&ctrl->mbox_lock))
>  		return 0;
> -	tag =3D alloc_mcc_tag(phba);
> -	if (!tag) {
> +	wrb =3D alloc_mcc_wrb(phba, &tag);
> +	if (!wrb) {
>  		mutex_unlock(&ctrl->mbox_lock);
> -		return tag;
> +		return 0;
>  	}
> =20
> -	wrb =3D wrb_from_mccq(phba);
>  	req =3D embedded_payload(wrb);
> -	wrb->tag0 |=3D tag;
>  	be_wrb_hdr_prepare(wrb, sizeof(*req), true, 0);
>  	be_cmd_hdr_prepare(&req->hdr, CMD_SUBSYSTEM_ISCSI_INI,
>  			OPCODE_ISCSI_INI_CFG_GET_HBA_NAME,
> @@ -1847,8 +1817,8 @@ int beiscsi_logout_fw_sess(struct beiscsi_hba *=
phba,
>  		    "BG_%d : In bescsi_logout_fwboot_sess\n");
> =20
>  	mutex_lock(&ctrl->mbox_lock);
> -	tag =3D alloc_mcc_tag(phba);
> -	if (!tag) {
> +	wrb =3D alloc_mcc_wrb(phba, &tag);
> +	if (!wrb) {
>  		mutex_unlock(&ctrl->mbox_lock);
>  		beiscsi_log(phba, KERN_INFO,
>  			    BEISCSI_LOG_CONFIG | BEISCSI_LOG_MBOX,
> @@ -1856,9 +1826,7 @@ int beiscsi_logout_fw_sess(struct beiscsi_hba *=
phba,
>  		return -EINVAL;
>  	}
> =20
> -	wrb =3D wrb_from_mccq(phba);
>  	req =3D embedded_payload(wrb);
> -	wrb->tag0 |=3D tag;
>  	be_wrb_hdr_prepare(wrb, sizeof(*req), true, 0);
>  	be_cmd_hdr_prepare(&req->hdr, CMD_SUBSYSTEM_ISCSI_INI,
>  			   OPCODE_ISCSI_INI_SESSION_LOGOUT_TARGET,
> --=20
> 2.5.0
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
--=20
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=FCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 03/12] be2iscsi: Remove redundant MCC processing code
Date: Mon, 1 Feb 2016 12:17:20 +0100
Message-ID: <20160201111720.GC27969@c203.arch.suse.de>
References: <1454321571-16167-1-git-send-email-jitendra.bhivare@avagotech.com>
 <1454321571-16167-4-git-send-email-jitendra.bhivare@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49303 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753643AbcBALRX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 1 Feb 2016 06:17:23 -0500
Content-Disposition: inline
In-Reply-To: <1454321571-16167-4-git-send-email-jitendra.bhivare@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jitendra Bhivare <jitendra.bhivare@avagotech.com>
Cc: linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu

On Mon, Feb 01, 2016 at 03:42:42PM +0530, Jitendra Bhivare wrote:
> be_mcc_compl_process_isr is removed.
> MCC CQ processing is done only in beiscsi_process_mcc_cq and MCC CQE
> processing is done only in beiscsi_process_mcc_compl.
>=20
> Signed-off-by: Jitendra Bhivare <jitendra.bhivare@avagotech.com>
> ---
>  drivers/scsi/be2iscsi/be_cmds.c | 164 ++++++++++++++----------------=
----------
>  drivers/scsi/be2iscsi/be_cmds.h |   7 +-
>  drivers/scsi/be2iscsi/be_main.c |   8 +-
>  drivers/scsi/be2iscsi/be_main.h |   1 +
>  drivers/scsi/be2iscsi/be_mgmt.c |   3 +-
>  5 files changed, 68 insertions(+), 115 deletions(-)
>=20
> diff --git a/drivers/scsi/be2iscsi/be_cmds.c b/drivers/scsi/be2iscsi/=
be_cmds.c
> index c5e7739..fa010ac 100644
> --- a/drivers/scsi/be2iscsi/be_cmds.c
> +++ b/drivers/scsi/be2iscsi/be_cmds.c
> @@ -328,76 +328,6 @@ static int be_mcc_compl_process(struct be_ctrl_i=
nfo *ctrl,
>  	return 0;
>  }
> =20
> -int be_mcc_compl_process_isr(struct be_ctrl_info *ctrl,
> -				    struct be_mcc_compl *compl)
> -{
> -	struct beiscsi_hba *phba =3D pci_get_drvdata(ctrl->pdev);
> -	u16 compl_status, extd_status;
> -	struct be_dma_mem *tag_mem;
> -	unsigned int tag, wrb_idx;
> -
> -	be_dws_le_to_cpu(compl, 4);
> -	tag =3D (compl->tag0 & MCC_Q_CMD_TAG_MASK);
> -	wrb_idx =3D (compl->tag0 & CQE_STATUS_WRB_MASK) >> CQE_STATUS_WRB_S=
HIFT;
> -
> -	if (!test_bit(MCC_TAG_STATE_RUNNING,
> -		      &ctrl->ptag_state[tag].tag_state)) {
> -		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_MBOX |
> -			    BEISCSI_LOG_INIT | BEISCSI_LOG_CONFIG,
> -			    "BC_%d : MBX cmd completed but not posted\n");
> -		return 0;
> -	}
> -
> -	if (test_bit(MCC_TAG_STATE_TIMEOUT,
> -		     &ctrl->ptag_state[tag].tag_state)) {
> -		beiscsi_log(phba, KERN_WARNING,
> -			    BEISCSI_LOG_MBOX | BEISCSI_LOG_INIT |
> -			    BEISCSI_LOG_CONFIG,
> -			    "BC_%d : MBX Completion for timeout Command from FW\n");
> -		/**
> -		 * Check for the size before freeing resource.
> -		 * Only for non-embedded cmd, PCI resource is allocated.
> -		 **/
> -		tag_mem =3D &ctrl->ptag_state[tag].tag_mem_state;
> -		if (tag_mem->size)
> -			pci_free_consistent(ctrl->pdev, tag_mem->size,
> -					tag_mem->va, tag_mem->dma);
> -		free_mcc_tag(ctrl, tag);
> -		return 0;
> -	}
> -
> -	compl_status =3D (compl->status >> CQE_STATUS_COMPL_SHIFT) &
> -		       CQE_STATUS_COMPL_MASK;
> -	extd_status =3D (compl->status >> CQE_STATUS_EXTD_SHIFT) &
> -		      CQE_STATUS_EXTD_MASK;
> -	/* The ctrl.mcc_tag_status[tag] is filled with
> -	 * [31] =3D valid, [30:24] =3D Rsvd, [23:16] =3D wrb, [15:8] =3D ex=
td_status,
> -	 * [7:0] =3D compl_status
> -	 */
> -	ctrl->mcc_tag_status[tag] =3D CQE_VALID_MASK;
> -	ctrl->mcc_tag_status[tag] |=3D (wrb_idx << CQE_STATUS_WRB_SHIFT);
> -	ctrl->mcc_tag_status[tag] |=3D (extd_status << CQE_STATUS_ADDL_SHIF=
T) &
> -				     CQE_STATUS_ADDL_MASK;
> -	ctrl->mcc_tag_status[tag] |=3D (compl_status & CQE_STATUS_MASK);
> -
> -	/* write ordering implied in wake_up_interruptible */
> -	clear_bit(MCC_TAG_STATE_RUNNING, &ctrl->ptag_state[tag].tag_state);
> -	wake_up_interruptible(&ctrl->mcc_wait[tag]);
> -	return 0;
> -}
> -
> -static struct be_mcc_compl *be_mcc_compl_get(struct beiscsi_hba *phb=
a)
> -{
> -	struct be_queue_info *mcc_cq =3D &phba->ctrl.mcc_obj.cq;
> -	struct be_mcc_compl *compl =3D queue_tail_node(mcc_cq);
> -
> -	if (be_mcc_compl_is_new(compl)) {
> -		queue_tail_inc(mcc_cq);
> -		return compl;
> -	}
> -	return NULL;
> -}
> -
>  /**
>   * beiscsi_fail_session(): Closing session with appropriate error
>   * @cls_session: ptr to session
> @@ -528,27 +458,65 @@ void beiscsi_process_async_event(struct beiscsi=
_hba *phba,
>  		    evt_code, compl->status, compl->flags);
>  }
> =20
> -int beiscsi_process_mcc(struct beiscsi_hba *phba)
> +int beiscsi_process_mcc_compl(struct be_ctrl_info *ctrl,
> +			      struct be_mcc_compl *compl)
>  {
> -	struct be_mcc_compl *compl;
> -	int num =3D 0, status =3D 0;
> -	struct be_ctrl_info *ctrl =3D &phba->ctrl;
> +	struct beiscsi_hba *phba =3D pci_get_drvdata(ctrl->pdev);
> +	u16 compl_status, extd_status;
> +	struct be_dma_mem *tag_mem;
> +	unsigned int tag, wrb_idx;
> =20
> -	while ((compl =3D be_mcc_compl_get(phba))) {
> -		if (compl->flags & CQE_FLAGS_ASYNC_MASK) {
> -			beiscsi_process_async_event(phba, compl);
> -		} else if (compl->flags & CQE_FLAGS_COMPLETED_MASK) {
> -			status =3D be_mcc_compl_process(ctrl, compl);
> -			atomic_dec(&phba->ctrl.mcc_obj.q.used);
> -		}
> -		be_mcc_compl_use(compl);
> -		num++;
> +	/**
> +	 * Just swap the status to host endian; mcc tag is opaquely copied
> +	 * from mcc_wrb
> +	 */
> +	be_dws_le_to_cpu(compl, 4);
> +	tag =3D (compl->tag0 & MCC_Q_CMD_TAG_MASK);
> +	wrb_idx =3D (compl->tag0 & CQE_STATUS_WRB_MASK) >> CQE_STATUS_WRB_S=
HIFT;
> +
> +	if (!test_bit(MCC_TAG_STATE_RUNNING,
> +		      &ctrl->ptag_state[tag].tag_state)) {
> +		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_MBOX |
> +			    BEISCSI_LOG_INIT | BEISCSI_LOG_CONFIG,
> +			    "BC_%d : MBX cmd completed but not posted\n");
> +		return 0;
>  	}
> =20
> -	if (num)
> -		hwi_ring_cq_db(phba, phba->ctrl.mcc_obj.cq.id, num, 1);
> +	if (test_bit(MCC_TAG_STATE_TIMEOUT, &ctrl->ptag_state[tag].tag_stat=
e)) {
> +		beiscsi_log(phba, KERN_WARNING,
> +			    BEISCSI_LOG_MBOX | BEISCSI_LOG_INIT |
> +			    BEISCSI_LOG_CONFIG,
> +			    "BC_%d : MBX Completion for timeout Command from FW\n");
> +		/**
> +		 * Check for the size before freeing resource.
> +		 * Only for non-embedded cmd, PCI resource is allocated.
> +		 **/
> +		tag_mem =3D &ctrl->ptag_state[tag].tag_mem_state;
> +		if (tag_mem->size)
> +			pci_free_consistent(ctrl->pdev, tag_mem->size,
> +					tag_mem->va, tag_mem->dma);
> +		free_mcc_tag(ctrl, tag);
> +		return 0;
> +	}
> =20
> -	return status;
> +	compl_status =3D (compl->status >> CQE_STATUS_COMPL_SHIFT) &
> +		       CQE_STATUS_COMPL_MASK;
> +	extd_status =3D (compl->status >> CQE_STATUS_EXTD_SHIFT) &
> +		      CQE_STATUS_EXTD_MASK;
> +	/* The ctrl.mcc_tag_status[tag] is filled with
> +	 * [31] =3D valid, [30:24] =3D Rsvd, [23:16] =3D wrb, [15:8] =3D ex=
td_status,
> +	 * [7:0] =3D compl_status
> +	 */
> +	ctrl->mcc_tag_status[tag] =3D CQE_VALID_MASK;
> +	ctrl->mcc_tag_status[tag] |=3D (wrb_idx << CQE_STATUS_WRB_SHIFT);
> +	ctrl->mcc_tag_status[tag] |=3D (extd_status << CQE_STATUS_ADDL_SHIF=
T) &
> +				     CQE_STATUS_ADDL_MASK;
> +	ctrl->mcc_tag_status[tag] |=3D (compl_status & CQE_STATUS_MASK);
> +
> +	/* write ordering forced in wake_up_interruptible */
> +	clear_bit(MCC_TAG_STATE_RUNNING, &ctrl->ptag_state[tag].tag_state);
> +	wake_up_interruptible(&ctrl->mcc_wait[tag]);
> +	return 0;
>  }
> =20
>  /*
> @@ -562,16 +530,15 @@ int beiscsi_process_mcc(struct beiscsi_hba *phb=
a)
>   * Failure: Non-Zero
>   *
>   **/
> -static int be_mcc_wait_compl(struct beiscsi_hba *phba)
> +int be_mcc_compl_poll(struct beiscsi_hba *phba, unsigned int tag)
>  {
> -	int i, status;
> +	int i;
> +
>  	for (i =3D 0; i < mcc_timeout; i++) {
>  		if (beiscsi_error(phba))
>  			return -EIO;
> =20
> -		status =3D beiscsi_process_mcc(phba);
> -		if (status)
> -			return status;
> +		beiscsi_process_mcc_cq(phba);
> =20
>  		if (atomic_read(&phba->ctrl.mcc_obj.q.used) =3D=3D 0)
>  			break;
> @@ -589,21 +556,6 @@ static int be_mcc_wait_compl(struct beiscsi_hba =
*phba)
>  }
> =20
>  /*
> - * be_mcc_notify_wait()- Notify and wait for Compl
> - * @phba: driver private structure
> - *
> - * Notify MCC requests and wait for completion
> - *
> - * return
> - * Success: 0
> - * Failure: Non-Zero
> - **/
> -int be_mcc_notify_wait(struct beiscsi_hba *phba, unsigned int tag)
> -{
> -	be_mcc_notify(phba, tag);
> -	return be_mcc_wait_compl(phba);
> -}
> -
>  /*
>   * be_mbox_db_ready_wait()- Check ready status
>   * @ctrl: Function specific MBX data structure
> diff --git a/drivers/scsi/be2iscsi/be_cmds.h b/drivers/scsi/be2iscsi/=
be_cmds.h
> index adafd9c..f50b32ac 100644
> --- a/drivers/scsi/be2iscsi/be_cmds.h
> +++ b/drivers/scsi/be2iscsi/be_cmds.h
> @@ -741,13 +741,14 @@ int be_cmd_fw_uninit(struct be_ctrl_info *ctrl)=
;
> =20
>  struct be_mcc_wrb *wrb_from_mbox(struct be_dma_mem *mbox_mem);
>  struct be_mcc_wrb *wrb_from_mccq(struct beiscsi_hba *phba);
> -int be_mcc_notify_wait(struct beiscsi_hba *phba, unsigned int tag);
> +int be_mcc_compl_poll(struct beiscsi_hba *phba, unsigned int tag);
>  void be_mcc_notify(struct beiscsi_hba *phba, unsigned int tag);
>  unsigned int alloc_mcc_tag(struct beiscsi_hba *phba);
>  void beiscsi_process_async_event(struct beiscsi_hba *phba,
>  				struct be_mcc_compl *compl);
> -int be_mcc_compl_process_isr(struct be_ctrl_info *ctrl,
> -				    struct be_mcc_compl *compl);
> +int beiscsi_process_mcc_compl(struct be_ctrl_info *ctrl,
> +			      struct be_mcc_compl *compl);
> +
> =20
>  int be_mbox_notify(struct be_ctrl_info *ctrl);
> =20
> diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/=
be_main.c
> index aaf39d4..8b9d01a 100644
> --- a/drivers/scsi/be2iscsi/be_main.c
> +++ b/drivers/scsi/be2iscsi/be_main.c
> @@ -2028,7 +2028,7 @@ static void hwi_process_default_pdu_ring(struct=
 beiscsi_conn *beiscsi_conn,
>  			       phwi_ctrlr, cri_index));
>  }
> =20
> -static void  beiscsi_process_mcc_isr(struct beiscsi_hba *phba)
> +void beiscsi_process_mcc_cq(struct beiscsi_hba *phba)
>  {
>  	struct be_queue_info *mcc_cq;
>  	struct  be_mcc_compl *mcc_compl;
> @@ -2038,7 +2038,6 @@ static void  beiscsi_process_mcc_isr(struct bei=
scsi_hba *phba)
>  	mcc_compl =3D queue_tail_node(mcc_cq);
>  	mcc_compl->flags =3D le32_to_cpu(mcc_compl->flags);
>  	while (mcc_compl->flags & CQE_FLAGS_VALID_MASK) {
> -
>  		if (num_processed >=3D 32) {
>  			hwi_ring_cq_db(phba, mcc_cq->id,
>  					num_processed, 0);
> @@ -2047,7 +2046,7 @@ static void  beiscsi_process_mcc_isr(struct bei=
scsi_hba *phba)
>  		if (mcc_compl->flags & CQE_FLAGS_ASYNC_MASK) {
>  			beiscsi_process_async_event(phba, mcc_compl);
>  		} else if (mcc_compl->flags & CQE_FLAGS_COMPLETED_MASK) {
> -			be_mcc_compl_process_isr(&phba->ctrl, mcc_compl);
> +			beiscsi_process_mcc_compl(&phba->ctrl, mcc_compl);
>  			atomic_dec(&phba->ctrl.mcc_obj.q.used);
>  		}
> =20
> @@ -2060,7 +2059,6 @@ static void  beiscsi_process_mcc_isr(struct bei=
scsi_hba *phba)
> =20
>  	if (num_processed > 0)
>  		hwi_ring_cq_db(phba, mcc_cq->id, num_processed, 1);
> -
>  }
> =20
>  /**
> @@ -2269,7 +2267,7 @@ void beiscsi_process_all_cqs(struct work_struct=
 *work)
>  		spin_lock_irqsave(&phba->isr_lock, flags);
>  		pbe_eq->todo_mcc_cq =3D false;
>  		spin_unlock_irqrestore(&phba->isr_lock, flags);
> -		beiscsi_process_mcc_isr(phba);
> +		beiscsi_process_mcc_cq(phba);
>  	}
> =20
>  	if (pbe_eq->todo_cq) {
> diff --git a/drivers/scsi/be2iscsi/be_main.h b/drivers/scsi/be2iscsi/=
be_main.h
> index 16a6fd0..5ded3fa 100644
> --- a/drivers/scsi/be2iscsi/be_main.h
> +++ b/drivers/scsi/be2iscsi/be_main.h
> @@ -853,6 +853,7 @@ void hwi_ring_cq_db(struct beiscsi_hba *phba,
>  		     unsigned char rearm);
> =20
>  unsigned int beiscsi_process_cq(struct be_eq_obj *pbe_eq, int budget=
);
> +void beiscsi_process_mcc_cq(struct beiscsi_hba *phba);
> =20
>  static inline bool beiscsi_error(struct beiscsi_hba *phba)
>  {
> diff --git a/drivers/scsi/be2iscsi/be_mgmt.c b/drivers/scsi/be2iscsi/=
be_mgmt.c
> index da040e7..a88e636 100644
> --- a/drivers/scsi/be2iscsi/be_mgmt.c
> +++ b/drivers/scsi/be2iscsi/be_mgmt.c
> @@ -678,7 +678,8 @@ int mgmt_epfw_cleanup(struct beiscsi_hba *phba, u=
nsigned short ulp_num)
>  	req->hdr_ring_id =3D cpu_to_le16(HWI_GET_DEF_HDRQ_ID(phba, ulp_num)=
);
>  	req->data_ring_id =3D cpu_to_le16(HWI_GET_DEF_BUFQ_ID(phba, ulp_num=
));
> =20
> -	status =3D be_mcc_notify_wait(phba, tag);
> +	be_mcc_notify(phba, tag);
> +	status =3D be_mcc_compl_poll(phba, tag);
>  	if (status)
>  		beiscsi_log(phba, KERN_WARNING, BEISCSI_LOG_INIT,
>  			    "BG_%d : mgmt_epfw_cleanup , FAILED\n");
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

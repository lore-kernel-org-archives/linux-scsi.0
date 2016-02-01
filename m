From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 06/12] be2iscsi: Fix be_mcc_compl_poll to use tag_state
Date: Mon, 1 Feb 2016 12:29:23 +0100
Message-ID: <20160201112923.GF27969@c203.arch.suse.de>
References: <1454321571-16167-1-git-send-email-jitendra.bhivare@avagotech.com>
 <1454321571-16167-7-git-send-email-jitendra.bhivare@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52933 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753758AbcBAL30 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 1 Feb 2016 06:29:26 -0500
Content-Disposition: inline
In-Reply-To: <1454321571-16167-7-git-send-email-jitendra.bhivare@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jitendra Bhivare <jitendra.bhivare@avagotech.com>
Cc: linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu

On Mon, Feb 01, 2016 at 03:42:45PM +0530, Jitendra Bhivare wrote:
> be_mcc_compl_poll waits till 'used' count of MCC WRBQ is zero. This i=
s to
> determine the completion of an MCC sent.
>=20
> Change function to poll for the tag of MCC sent, instead, and wait ti=
ll
> its tag_state is cleared.
>=20
> Signed-off-by: Jitendra Bhivare <jitendra.bhivare@avagotech.com>
> ---
>  drivers/scsi/be2iscsi/be_cmds.c | 92 +++++++++++++++++++++----------=
----------
>  1 file changed, 47 insertions(+), 45 deletions(-)
>=20
> diff --git a/drivers/scsi/be2iscsi/be_cmds.c b/drivers/scsi/be2iscsi/=
be_cmds.c
> index 12b60dd..60db2de 100644
> --- a/drivers/scsi/be2iscsi/be_cmds.c
> +++ b/drivers/scsi/be2iscsi/be_cmds.c
> @@ -104,19 +104,6 @@ int be_chk_reset_complete(struct beiscsi_hba *ph=
ba)
>  	return 0;
>  }
> =20
> -void be_mcc_notify(struct beiscsi_hba *phba, unsigned int tag)
> -{
> -	struct be_queue_info *mccq =3D &phba->ctrl.mcc_obj.q;
> -	u32 val =3D 0;
> -
> -	set_bit(MCC_TAG_STATE_RUNNING, &phba->ctrl.ptag_state[tag].tag_stat=
e);
> -	val |=3D mccq->id & DB_MCCQ_RING_ID_MASK;
> -	val |=3D 1 << DB_MCCQ_NUM_POSTED_SHIFT;
> -	/* ring doorbell after all of request and state is written */
> -	wmb();
> -	iowrite32(val, phba->db_va + DB_MCCQ_OFFSET);
> -}
> -
>  unsigned int alloc_mcc_tag(struct beiscsi_hba *phba)
>  {
>  	unsigned int tag =3D 0;
> @@ -139,6 +126,28 @@ unsigned int alloc_mcc_tag(struct beiscsi_hba *p=
hba)
>  	return tag;
>  }
> =20
> +void free_mcc_tag(struct be_ctrl_info *ctrl, unsigned int tag)
> +{
> +	spin_lock_bh(&ctrl->mcc_lock);
> +	tag =3D tag & MCC_Q_CMD_TAG_MASK;
> +	ctrl->mcc_tag[ctrl->mcc_free_index] =3D tag;
> +	if (ctrl->mcc_free_index =3D=3D (MAX_MCC_CMD - 1))
> +		ctrl->mcc_free_index =3D 0;
> +	else
> +		ctrl->mcc_free_index++;
> +	ctrl->mcc_tag_available++;
> +	spin_unlock_bh(&ctrl->mcc_lock);
> +}
> +
> +/**
> + * beiscsi_fail_session(): Closing session with appropriate error
> + * @cls_session: ptr to session
> + **/
> +void beiscsi_fail_session(struct iscsi_cls_session *cls_session)
> +{
> +	iscsi_session_failure(cls_session->dd_data, ISCSI_ERR_CONN_FAILED);
> +}
> +
>  /*
>   * beiscsi_mccq_compl_wait()- Process completion in MCC CQ
>   * @phba: Driver private structure
> @@ -254,19 +263,6 @@ int beiscsi_mccq_compl_wait(struct beiscsi_hba *=
phba,
>  	return rc;
>  }
> =20
> -void free_mcc_tag(struct be_ctrl_info *ctrl, unsigned int tag)
> -{
> -	spin_lock(&ctrl->mcc_lock);
> -	tag =3D tag & MCC_Q_CMD_TAG_MASK;
> -	ctrl->mcc_tag[ctrl->mcc_free_index] =3D tag;
> -	if (ctrl->mcc_free_index =3D=3D (MAX_MCC_CMD - 1))
> -		ctrl->mcc_free_index =3D 0;
> -	else
> -		ctrl->mcc_free_index++;
> -	ctrl->mcc_tag_available++;
> -	spin_unlock(&ctrl->mcc_lock);
> -}
> -
>  static inline bool be_mcc_compl_is_new(struct be_mcc_compl *compl)
>  {
>  	if (compl->flags !=3D 0) {
> @@ -328,15 +324,6 @@ static int beiscsi_process_mbox_compl(struct be_=
ctrl_info *ctrl,
>  	return 0;
>  }
> =20
> -/**
> - * beiscsi_fail_session(): Closing session with appropriate error
> - * @cls_session: ptr to session
> - **/
> -void beiscsi_fail_session(struct iscsi_cls_session *cls_session)
> -{
> -	iscsi_session_failure(cls_session->dd_data, ISCSI_ERR_CONN_FAILED);
> -}
> -
>  static void beiscsi_process_async_link(struct beiscsi_hba *phba,
>  				       struct be_mcc_compl *compl)
>  {
> @@ -532,6 +519,7 @@ int beiscsi_process_mcc_compl(struct be_ctrl_info=
 *ctrl,
>   **/
>  int be_mcc_compl_poll(struct beiscsi_hba *phba, unsigned int tag)
>  {
> +	struct be_ctrl_info *ctrl =3D &phba->ctrl;
>  	int i;
> =20
>  	for (i =3D 0; i < mcc_timeout; i++) {
> @@ -540,19 +528,33 @@ int be_mcc_compl_poll(struct beiscsi_hba *phba,=
 unsigned int tag)
> =20
>  		beiscsi_process_mcc_cq(phba);
> =20
> -		if (atomic_read(&phba->ctrl.mcc_obj.q.used) =3D=3D 0)
> +		if (!test_bit(MCC_TAG_STATE_RUNNING,
> +			      &ctrl->ptag_state[tag].tag_state))
>  			break;
>  		udelay(100);
>  	}
> -	if (i =3D=3D mcc_timeout) {
> -		beiscsi_log(phba, KERN_ERR,
> -			    BEISCSI_LOG_CONFIG | BEISCSI_LOG_MBOX,
> -			    "BC_%d : FW Timed Out\n");
> -		phba->fw_timeout =3D true;
> -		beiscsi_ue_detect(phba);
> -		return -EBUSY;
> -	}
> -	return 0;
> +
> +	if (i < mcc_timeout)
> +		return 0;
> +
> +	beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_CONFIG | BEISCSI_LOG_MBOX,
> +		    "BC_%d : FW Timed Out\n");
> +	phba->fw_timeout =3D true;
> +	beiscsi_ue_detect(phba);
> +	return -EBUSY;
> +}
> +
> +void be_mcc_notify(struct beiscsi_hba *phba, unsigned int tag)
> +{
> +	struct be_queue_info *mccq =3D &phba->ctrl.mcc_obj.q;
> +	u32 val =3D 0;
> +
> +	set_bit(MCC_TAG_STATE_RUNNING, &phba->ctrl.ptag_state[tag].tag_stat=
e);
> +	val |=3D mccq->id & DB_MCCQ_RING_ID_MASK;
> +	val |=3D 1 << DB_MCCQ_NUM_POSTED_SHIFT;
> +	/* make request available for DMA */
> +	wmb();
> +	iowrite32(val, phba->db_va + DB_MCCQ_OFFSET);
>  }
> =20
>  /*
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

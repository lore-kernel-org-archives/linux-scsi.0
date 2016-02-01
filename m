From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 02/12] be2iscsi: Use macros for MCC WRB and CQE fields
Date: Mon, 1 Feb 2016 12:13:18 +0100
Message-ID: <20160201111318.GB27969@c203.arch.suse.de>
References: <1454321571-16167-1-git-send-email-jitendra.bhivare@avagotech.com>
 <1454321571-16167-3-git-send-email-jitendra.bhivare@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48684 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753672AbcBALNV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 1 Feb 2016 06:13:21 -0500
Content-Disposition: inline
In-Reply-To: <1454321571-16167-3-git-send-email-jitendra.bhivare@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jitendra Bhivare <jitendra.bhivare@avagotech.com>
Cc: linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu

On Mon, Feb 01, 2016 at 03:42:41PM +0530, Jitendra Bhivare wrote:
> Rename mcc_numtag to mcc_tag_status.
> MCC CQE status is processed using macros already defined in be_cmds.h=
=2E
>=20
> Add MCC_Q_WRB_ and MCC_Q_CMD_TAG_MASK macros to map to already define=
d
> CQE_STATUS_ macros to be consistent when posting MCC.
>=20
> Signed-off-by: Jitendra Bhivare <jitendra.bhivare@avagotech.com>
> ---
>  drivers/scsi/be2iscsi/be.h      |  8 +++++++-
>  drivers/scsi/be2iscsi/be_cmds.c | 40 +++++++++++++++++++++----------=
---------
>  drivers/scsi/be2iscsi/be_cmds.h | 13 +++++++------
>  drivers/scsi/be2iscsi/be_main.c | 11 ++++++-----
>  4 files changed, 41 insertions(+), 31 deletions(-)
>=20
> diff --git a/drivers/scsi/be2iscsi/be.h b/drivers/scsi/be2iscsi/be.h
> index 1524fe4..da1d87a 100644
> --- a/drivers/scsi/be2iscsi/be.h
> +++ b/drivers/scsi/be2iscsi/be.h
> @@ -135,7 +135,7 @@ struct be_ctrl_info {
> =20
>  	wait_queue_head_t mcc_wait[MAX_MCC_CMD + 1];
>  	unsigned int mcc_tag[MAX_MCC_CMD];
> -	unsigned int mcc_numtag[MAX_MCC_CMD + 1];
> +	unsigned int mcc_tag_status[MAX_MCC_CMD + 1];
>  	unsigned short mcc_alloc_index;
>  	unsigned short mcc_free_index;
>  	unsigned int mcc_tag_available;
> @@ -145,6 +145,12 @@ struct be_ctrl_info {
> =20
>  #include "be_cmds.h"
> =20
> +/* WRB index mask for MCC_Q_LEN queue entries */
> +#define MCC_Q_WRB_IDX_MASK	CQE_STATUS_WRB_MASK
> +#define MCC_Q_WRB_IDX_SHIFT	CQE_STATUS_WRB_SHIFT
> +/* TAG is from 1...MAX_MCC_CMD, MASK includes MAX_MCC_CMD */
> +#define MCC_Q_CMD_TAG_MASK	((MAX_MCC_CMD << 1) - 1)
> +
>  #define PAGE_SHIFT_4K 12
>  #define PAGE_SIZE_4K (1 << PAGE_SHIFT_4K)
>  #define mcc_timeout		120000 /* 12s timeout */
> diff --git a/drivers/scsi/be2iscsi/be_cmds.c b/drivers/scsi/be2iscsi/=
be_cmds.c
> index e8e9d22..c5e7739 100644
> --- a/drivers/scsi/be2iscsi/be_cmds.c
> +++ b/drivers/scsi/be2iscsi/be_cmds.c
> @@ -125,7 +125,7 @@ unsigned int alloc_mcc_tag(struct beiscsi_hba *ph=
ba)
>  	if (phba->ctrl.mcc_tag_available) {
>  		tag =3D phba->ctrl.mcc_tag[phba->ctrl.mcc_alloc_index];
>  		phba->ctrl.mcc_tag[phba->ctrl.mcc_alloc_index] =3D 0;
> -		phba->ctrl.mcc_numtag[tag] =3D 0;
> +		phba->ctrl.mcc_tag_status[tag] =3D 0;
>  		phba->ctrl.ptag_state[tag].tag_state =3D 0;
>  	}
>  	if (tag) {
> @@ -157,7 +157,7 @@ int beiscsi_mccq_compl(struct beiscsi_hba *phba,
>  		struct be_dma_mem *mbx_cmd_mem)
>  {
>  	int rc =3D 0;
> -	uint32_t mcc_tag_response;
> +	uint32_t mcc_tag_status;
>  	uint16_t status =3D 0, addl_status =3D 0, wrb_num =3D 0;
>  	struct be_mcc_wrb *temp_wrb;
>  	struct be_cmd_req_hdr *mbx_hdr;
> @@ -172,7 +172,7 @@ int beiscsi_mccq_compl(struct beiscsi_hba *phba,
>  	/* wait for the mccq completion */
>  	rc =3D wait_event_interruptible_timeout(
>  				phba->ctrl.mcc_wait[tag],
> -				phba->ctrl.mcc_numtag[tag],
> +				phba->ctrl.mcc_tag_status[tag],
>  				msecs_to_jiffies(
>  				BEISCSI_HOST_MBX_TIMEOUT));
>  	/**
> @@ -209,15 +209,15 @@ int beiscsi_mccq_compl(struct beiscsi_hba *phba=
,
>  	}
> =20
>  	rc =3D 0;
> -	mcc_tag_response =3D phba->ctrl.mcc_numtag[tag];
> -	status =3D (mcc_tag_response & CQE_STATUS_MASK);
> -	addl_status =3D ((mcc_tag_response & CQE_STATUS_ADDL_MASK) >>
> +	mcc_tag_status =3D phba->ctrl.mcc_tag_status[tag];
> +	status =3D (mcc_tag_status & CQE_STATUS_MASK);
> +	addl_status =3D ((mcc_tag_status & CQE_STATUS_ADDL_MASK) >>
>  			CQE_STATUS_ADDL_SHIFT);
> =20
>  	if (mbx_cmd_mem) {
>  		mbx_hdr =3D (struct be_cmd_req_hdr *)mbx_cmd_mem->va;
>  	} else {
> -		wrb_num =3D (mcc_tag_response & CQE_STATUS_WRB_MASK) >>
> +		wrb_num =3D (mcc_tag_status & CQE_STATUS_WRB_MASK) >>
>  			   CQE_STATUS_WRB_SHIFT;
>  		temp_wrb =3D (struct be_mcc_wrb *)queue_get_wrb(mccq, wrb_num);
>  		mbx_hdr =3D embedded_payload(temp_wrb);
> @@ -257,7 +257,7 @@ int beiscsi_mccq_compl(struct beiscsi_hba *phba,
>  void free_mcc_tag(struct be_ctrl_info *ctrl, unsigned int tag)
>  {
>  	spin_lock(&ctrl->mcc_lock);
> -	tag =3D tag & 0x000000FF;
> +	tag =3D tag & MCC_Q_CMD_TAG_MASK;
>  	ctrl->mcc_tag[ctrl->mcc_free_index] =3D tag;
>  	if (ctrl->mcc_free_index =3D=3D (MAX_MCC_CMD - 1))
>  		ctrl->mcc_free_index =3D 0;
> @@ -334,10 +334,11 @@ int be_mcc_compl_process_isr(struct be_ctrl_inf=
o *ctrl,
>  	struct beiscsi_hba *phba =3D pci_get_drvdata(ctrl->pdev);
>  	u16 compl_status, extd_status;
>  	struct be_dma_mem *tag_mem;
> -	unsigned short tag;
> +	unsigned int tag, wrb_idx;
> =20
>  	be_dws_le_to_cpu(compl, 4);
> -	tag =3D (compl->tag0 & 0x000000FF);
> +	tag =3D (compl->tag0 & MCC_Q_CMD_TAG_MASK);
> +	wrb_idx =3D (compl->tag0 & CQE_STATUS_WRB_MASK) >> CQE_STATUS_WRB_S=
HIFT;
> =20
>  	if (!test_bit(MCC_TAG_STATE_RUNNING,
>  		      &ctrl->ptag_state[tag].tag_state)) {
> @@ -366,17 +367,18 @@ int be_mcc_compl_process_isr(struct be_ctrl_inf=
o *ctrl,
>  	}
> =20
>  	compl_status =3D (compl->status >> CQE_STATUS_COMPL_SHIFT) &
> -					CQE_STATUS_COMPL_MASK;
> -	/* The ctrl.mcc_numtag[tag] is filled with
> +		       CQE_STATUS_COMPL_MASK;
> +	extd_status =3D (compl->status >> CQE_STATUS_EXTD_SHIFT) &
> +		      CQE_STATUS_EXTD_MASK;
> +	/* The ctrl.mcc_tag_status[tag] is filled with
>  	 * [31] =3D valid, [30:24] =3D Rsvd, [23:16] =3D wrb, [15:8] =3D ex=
td_status,
>  	 * [7:0] =3D compl_status
>  	 */
> -	extd_status =3D (compl->status >> CQE_STATUS_EXTD_SHIFT) &
> -					CQE_STATUS_EXTD_MASK;
> -	ctrl->mcc_numtag[tag]  =3D 0x80000000;
> -	ctrl->mcc_numtag[tag] |=3D (compl->tag0 & 0x00FF0000);
> -	ctrl->mcc_numtag[tag] |=3D (extd_status & 0x000000FF) << 8;
> -	ctrl->mcc_numtag[tag] |=3D (compl_status & 0x000000FF);
> +	ctrl->mcc_tag_status[tag] =3D CQE_VALID_MASK;
> +	ctrl->mcc_tag_status[tag] |=3D (wrb_idx << CQE_STATUS_WRB_SHIFT);
> +	ctrl->mcc_tag_status[tag] |=3D (extd_status << CQE_STATUS_ADDL_SHIF=
T) &
> +				     CQE_STATUS_ADDL_MASK;
> +	ctrl->mcc_tag_status[tag] |=3D (compl_status & CQE_STATUS_MASK);
> =20
>  	/* write ordering implied in wake_up_interruptible */
>  	clear_bit(MCC_TAG_STATE_RUNNING, &ctrl->ptag_state[tag].tag_state);
> @@ -844,7 +846,7 @@ struct be_mcc_wrb *wrb_from_mccq(struct beiscsi_h=
ba *phba)
>  	WARN_ON(atomic_read(&mccq->used) >=3D mccq->len);
>  	wrb =3D queue_head_node(mccq);
>  	memset(wrb, 0, sizeof(*wrb));
> -	wrb->tag0 =3D (mccq->head & 0x000000FF) << 16;
> +	wrb->tag0 =3D (mccq->head << MCC_Q_WRB_IDX_SHIFT) & MCC_Q_WRB_IDX_M=
ASK;
>  	queue_head_inc(mccq);
>  	atomic_inc(&mccq->used);
>  	return wrb;
> diff --git a/drivers/scsi/be2iscsi/be_cmds.h b/drivers/scsi/be2iscsi/=
be_cmds.h
> index 7caf585..adafd9c 100644
> --- a/drivers/scsi/be2iscsi/be_cmds.h
> +++ b/drivers/scsi/be2iscsi/be_cmds.h
> @@ -58,15 +58,16 @@ struct be_mcc_wrb {
>  #define MCC_STATUS_ILLEGAL_FIELD 0x3
>  #define MCC_STATUS_INSUFFICIENT_BUFFER 0x4
> =20
> -#define CQE_STATUS_COMPL_MASK 0xFFFF
> -#define CQE_STATUS_COMPL_SHIFT 0	/* bits 0 - 15 */
> -#define CQE_STATUS_EXTD_MASK 0xFFFF
> -#define CQE_STATUS_EXTD_SHIFT 16		/* bits 0 - 15 */
> +#define CQE_STATUS_COMPL_MASK	0xFFFF
> +#define CQE_STATUS_COMPL_SHIFT	0		/* bits 0 - 15 */
> +#define CQE_STATUS_EXTD_MASK	0xFFFF
> +#define CQE_STATUS_EXTD_SHIFT	16		/* bits 31 - 16 */
>  #define CQE_STATUS_ADDL_MASK	0xFF00
> -#define CQE_STATUS_MASK	0xFF
> -#define CQE_STATUS_ADDL_SHIFT	0x08
> +#define CQE_STATUS_ADDL_SHIFT	8
> +#define CQE_STATUS_MASK		0xFF
>  #define CQE_STATUS_WRB_MASK	0xFF0000
>  #define CQE_STATUS_WRB_SHIFT	16
> +
>  #define BEISCSI_HOST_MBX_TIMEOUT (110 * 1000)
>  #define BEISCSI_FW_MBX_TIMEOUT	100
> =20
> diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/=
be_main.c
> index 314fd2c..aaf39d4 100644
> --- a/drivers/scsi/be2iscsi/be_main.c
> +++ b/drivers/scsi/be2iscsi/be_main.c
> @@ -5241,11 +5241,12 @@ static int beiscsi_bsg_request(struct bsg_job=
 *job)
> =20
>  		rc =3D wait_event_interruptible_timeout(
>  					phba->ctrl.mcc_wait[tag],
> -					phba->ctrl.mcc_numtag[tag],
> +					phba->ctrl.mcc_tag_status[tag],
>  					msecs_to_jiffies(
>  					BEISCSI_HOST_MBX_TIMEOUT));
> -		extd_status =3D (phba->ctrl.mcc_numtag[tag] & 0x0000FF00) >> 8;
> -		status =3D phba->ctrl.mcc_numtag[tag] & 0x000000FF;
> +		extd_status =3D (phba->ctrl.mcc_tag_status[tag] &
> +			       CQE_STATUS_ADDL_MASK) >> CQE_STATUS_ADDL_SHIFT;
> +		status =3D phba->ctrl.mcc_tag_status[tag] & CQE_STATUS_MASK;
>  		free_mcc_tag(&phba->ctrl, tag);
>  		resp =3D (struct be_cmd_resp_hdr *)nonemb_cmd.va;
>  		sg_copy_from_buffer(job->reply_payload.sg_list,
> @@ -5580,7 +5581,7 @@ static void beiscsi_eeh_resume(struct pci_dev *=
pdev)
>  	for (i =3D 0; i < MAX_MCC_CMD; i++) {
>  		init_waitqueue_head(&phba->ctrl.mcc_wait[i + 1]);
>  		phba->ctrl.mcc_tag[i] =3D i + 1;
> -		phba->ctrl.mcc_numtag[i + 1] =3D 0;
> +		phba->ctrl.mcc_tag_status[i + 1] =3D 0;
>  		phba->ctrl.mcc_tag_available++;
>  	}
> =20
> @@ -5739,7 +5740,7 @@ static int beiscsi_dev_probe(struct pci_dev *pc=
idev,
>  	for (i =3D 0; i < MAX_MCC_CMD; i++) {
>  		init_waitqueue_head(&phba->ctrl.mcc_wait[i + 1]);
>  		phba->ctrl.mcc_tag[i] =3D i + 1;
> -		phba->ctrl.mcc_numtag[i + 1] =3D 0;
> +		phba->ctrl.mcc_tag_status[i + 1] =3D 0;
>  		phba->ctrl.mcc_tag_available++;
>  		memset(&phba->ctrl.ptag_state[i].tag_mem_state, 0,
>  		       sizeof(struct be_dma_mem));
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

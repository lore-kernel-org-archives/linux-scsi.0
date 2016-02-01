From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 07/12] be2iscsi: Cleanup processing of BMBX completion
Date: Mon, 1 Feb 2016 12:41:07 +0100
Message-ID: <20160201114107.GG27969@c203.arch.suse.de>
References: <1454321571-16167-1-git-send-email-jitendra.bhivare@avagotech.com>
 <1454321571-16167-8-git-send-email-jitendra.bhivare@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54286 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753641AbcBALlK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 1 Feb 2016 06:41:10 -0500
Content-Disposition: inline
In-Reply-To: <1454321571-16167-8-git-send-email-jitendra.bhivare@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jitendra Bhivare <jitendra.bhivare@avagotech.com>
Cc: linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu

On Mon, Feb 01, 2016 at 03:42:46PM +0530, Jitendra Bhivare wrote:
> Remove confusingly named be_mcc_compl_is_new and be_mcc_compl_use fun=
ctions
> in processing of BMBX. Rearrange beiscsi_process_mbox_compl function.
>=20
> Signed-off-by: Jitendra Bhivare <jitendra.bhivare@avagotech.com>
> ---
>  drivers/scsi/be2iscsi/be_cmds.c | 75 ++++++++++++++++++++-----------=
----------
>  1 file changed, 36 insertions(+), 39 deletions(-)
>=20
> diff --git a/drivers/scsi/be2iscsi/be_cmds.c b/drivers/scsi/be2iscsi/=
be_cmds.c
> index 60db2de..728aa133 100644
> --- a/drivers/scsi/be2iscsi/be_cmds.c
> +++ b/drivers/scsi/be2iscsi/be_cmds.c
> @@ -263,21 +263,6 @@ int beiscsi_mccq_compl_wait(struct beiscsi_hba *=
phba,
>  	return rc;
>  }
> =20
> -static inline bool be_mcc_compl_is_new(struct be_mcc_compl *compl)
> -{
> -	if (compl->flags !=3D 0) {
> -		compl->flags =3D le32_to_cpu(compl->flags);
> -		WARN_ON((compl->flags & CQE_FLAGS_VALID_MASK) =3D=3D 0);
> -		return true;
> -	} else
> -		return false;
> -}
> -
> -static inline void be_mcc_compl_use(struct be_mcc_compl *compl)
> -{
> -	compl->flags =3D 0;
> -}
> -
>  /*
>   * beiscsi_process_mbox_compl()- Check the MBX completion status
>   * @ctrl: Function specific MBX data structure
> @@ -298,30 +283,46 @@ static int beiscsi_process_mbox_compl(struct be=
_ctrl_info *ctrl,
>  	struct be_cmd_req_hdr *hdr =3D embedded_payload(wrb);
>  	struct be_cmd_resp_hdr *resp_hdr;
> =20
> -	be_dws_le_to_cpu(compl, 4);
> +	/**
> +	 * To check if valid bit is set, check the entire word as we don't =
know
> +	 * the endianness of the data (old entry is host endian while a new
> +	 * entry is little endian)
> +	 */
> +	if (!compl->flags) {
> +		beiscsi_log(phba, KERN_ERR,
> +				BEISCSI_LOG_CONFIG | BEISCSI_LOG_MBOX,
> +				"BC_%d : BMBX busy, no completion\n");
> +		return -EBUSY;
> +	}
> +	compl->flags =3D le32_to_cpu(compl->flags);
> +	WARN_ON((compl->flags & CQE_FLAGS_VALID_MASK) =3D=3D 0);
> =20
> +	/**
> +	 * Just swap the status to host endian;
> +	 * mcc tag is opaquely copied from mcc_wrb.
> +	 */
> +	be_dws_le_to_cpu(compl, 4);
>  	compl_status =3D (compl->status >> CQE_STATUS_COMPL_SHIFT) &
> -					CQE_STATUS_COMPL_MASK;
> -	if (compl_status !=3D MCC_STATUS_SUCCESS) {
> -		extd_status =3D (compl->status >> CQE_STATUS_EXTD_SHIFT) &
> -						CQE_STATUS_EXTD_MASK;
> +		CQE_STATUS_COMPL_MASK;
> +	extd_status =3D (compl->status >> CQE_STATUS_EXTD_SHIFT) &
> +		CQE_STATUS_EXTD_MASK;
> +	/* Need to reset the entire word that houses the valid bit */
> +	compl->flags =3D 0;
> =20
> -		beiscsi_log(phba, KERN_ERR,
> -			    BEISCSI_LOG_CONFIG | BEISCSI_LOG_MBOX,
> -			    "BC_%d : error in cmd completion: "
> -			    "Subsystem : %d Opcode : %d "
> -			    "status(compl/extd)=3D%d/%d\n",
> -			    hdr->subsystem, hdr->opcode,
> -			    compl_status, extd_status);
> -
> -		if (compl_status =3D=3D MCC_STATUS_INSUFFICIENT_BUFFER) {
> -			resp_hdr =3D (struct be_cmd_resp_hdr *) hdr;
> -			if (resp_hdr->response_length)
> -				return 0;
> -		}
> -		return -EINVAL;
> +	if (compl_status =3D=3D MCC_STATUS_SUCCESS)
> +		return 0;
> +
> +	beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_CONFIG | BEISCSI_LOG_MBOX,
> +		    "BC_%d : error in cmd completion: Subsystem : %d Opcode : %d s=
tatus(compl/extd)=3D%d/%d\n",
> +		    hdr->subsystem, hdr->opcode, compl_status, extd_status);
> +
> +	if (compl_status =3D=3D MCC_STATUS_INSUFFICIENT_BUFFER) {
> +		/* if status is insufficient buffer, check the length */
> +		resp_hdr =3D (struct be_cmd_resp_hdr *) hdr;
> +		if (resp_hdr->response_length)
> +			return 0;
>  	}
> -	return 0;
> +	return -EINVAL;
>  }
> =20
>  static void beiscsi_process_async_link(struct beiscsi_hba *phba,
> @@ -453,10 +454,6 @@ int beiscsi_process_mcc_compl(struct be_ctrl_inf=
o *ctrl,
>  	struct be_dma_mem *tag_mem;
>  	unsigned int tag, wrb_idx;
> =20
> -	/**
> -	 * Just swap the status to host endian; mcc tag is opaquely copied
> -	 * from mcc_wrb
> -	 */
>  	be_dws_le_to_cpu(compl, 4);
>  	tag =3D (compl->tag0 & MCC_Q_CMD_TAG_MASK);
>  	wrb_idx =3D (compl->tag0 & CQE_STATUS_WRB_MASK) >> CQE_STATUS_WRB_S=
HIFT;
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

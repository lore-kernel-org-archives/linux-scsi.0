From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 05/12] be2iscsi: Remove be_mbox_notify_wait function
Date: Mon, 1 Feb 2016 12:27:38 +0100
Message-ID: <20160201112738.GE27969@c203.arch.suse.de>
References: <1454321571-16167-1-git-send-email-jitendra.bhivare@avagotech.com>
 <1454321571-16167-6-git-send-email-jitendra.bhivare@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51575 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753489AbcBAL1k (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 1 Feb 2016 06:27:40 -0500
Content-Disposition: inline
In-Reply-To: <1454321571-16167-6-git-send-email-jitendra.bhivare@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jitendra Bhivare <jitendra.bhivare@avagotech.com>
Cc: linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu

On Mon, Feb 01, 2016 at 03:42:44PM +0530, Jitendra Bhivare wrote:
> be_mbox_notify_wait does exactly same thing as be_mbox_notify.
>=20
> Signed-off-by: Jitendra Bhivare <jitendra.bhivare@avagotech.com>
> ---
>  drivers/scsi/be2iscsi/be_cmds.c | 79 +++----------------------------=
----------
>  1 file changed, 4 insertions(+), 75 deletions(-)
>=20
> diff --git a/drivers/scsi/be2iscsi/be_cmds.c b/drivers/scsi/be2iscsi/=
be_cmds.c
> index 8dd8521..12b60dd 100644
> --- a/drivers/scsi/be2iscsi/be_cmds.c
> +++ b/drivers/scsi/be2iscsi/be_cmds.c
> @@ -625,8 +625,6 @@ int be_mbox_notify(struct be_ctrl_info *ctrl)
>  	void __iomem *db =3D ctrl->db + MPU_MAILBOX_DB_OFFSET;
>  	struct be_dma_mem *mbox_mem =3D &ctrl->mbox_mem;
>  	struct be_mcc_mailbox *mbox =3D mbox_mem->va;
> -	struct be_mcc_compl *compl =3D &mbox->compl;
> -	struct beiscsi_hba *phba =3D pci_get_drvdata(ctrl->pdev);
> =20
>  	status =3D be_mbox_db_ready_poll(ctrl);
>  	if (status)
> @@ -654,77 +652,8 @@ int be_mbox_notify(struct be_ctrl_info *ctrl)
>  	/* RDY is set; small delay before CQE read. */
>  	udelay(1);
> =20
> -	if (be_mcc_compl_is_new(compl)) {
> -		status =3D beiscsi_process_mbox_compl(ctrl, compl);
> -		be_mcc_compl_use(compl);
> -		if (status) {
> -			beiscsi_log(phba, KERN_ERR,
> -				    BEISCSI_LOG_CONFIG | BEISCSI_LOG_MBOX,
> -				    "BC_%d : After be_mcc_compl_process\n");
> -
> -			return status;
> -		}
> -	} else {
> -		beiscsi_log(phba, KERN_ERR,
> -			    BEISCSI_LOG_CONFIG | BEISCSI_LOG_MBOX,
> -			    "BC_%d : Invalid Mailbox Completion\n");
> -
> -		return -EBUSY;
> -	}
> -	return 0;
> -}
> -
> -/*
> - * Insert the mailbox address into the doorbell in two steps
> - * Polls on the mbox doorbell till a command completion (or a timeou=
t) occurs
> - */
> -static int be_mbox_notify_wait(struct beiscsi_hba *phba)
> -{
> -	int status;
> -	u32 val =3D 0;
> -	void __iomem *db =3D phba->ctrl.db + MPU_MAILBOX_DB_OFFSET;
> -	struct be_dma_mem *mbox_mem =3D &phba->ctrl.mbox_mem;
> -	struct be_mcc_mailbox *mbox =3D mbox_mem->va;
> -	struct be_mcc_compl *compl =3D &mbox->compl;
> -	struct be_ctrl_info *ctrl =3D &phba->ctrl;
> -
> -	status =3D be_mbox_db_ready_poll(ctrl);
> -	if (status)
> -		return status;
> -
> -	val |=3D MPU_MAILBOX_DB_HI_MASK;
> -	/* at bits 2 - 31 place mbox dma addr msb bits 34 - 63 */
> -	val |=3D (upper_32_bits(mbox_mem->dma) >> 2) << 2;
> -	iowrite32(val, db);
> -
> -	/* wait for ready to be set */
> -	status =3D be_mbox_db_ready_poll(ctrl);
> -	if (status !=3D 0)
> -		return status;
> -
> -	val =3D 0;
> -	/* at bits 2 - 31 place mbox dma addr lsb bits 4 - 33 */
> -	val |=3D (u32)(mbox_mem->dma >> 4) << 2;
> -	iowrite32(val, db);
> -
> -	status =3D be_mbox_db_ready_poll(ctrl);
> -	if (status !=3D 0)
> -		return status;
> -
> -	/* A cq entry has been made now */
> -	if (be_mcc_compl_is_new(compl)) {
> -		status =3D be_mcc_compl_process(ctrl, &mbox->compl);
> -		be_mcc_compl_use(compl);
> -		if (status)
> -			return status;
> -	} else {
> -		beiscsi_log(phba, KERN_ERR,
> -			    BEISCSI_LOG_CONFIG | BEISCSI_LOG_MBOX,
> -			    "BC_%d : invalid mailbox completion\n");
> -
> -		return -EBUSY;
> -	}
> -	return 0;
> +	status =3D beiscsi_process_mbox_compl(ctrl, &mbox->compl);
> +	return status;
>  }
> =20
>  void be_wrb_hdr_prepare(struct be_mcc_wrb *wrb, int payload_len,
> @@ -1039,7 +968,7 @@ int beiscsi_cmd_mccq_create(struct beiscsi_hba *=
phba,
> =20
>  	be_cmd_page_addrs_prepare(req->pages, ARRAY_SIZE(req->pages), q_mem=
);
> =20
> -	status =3D be_mbox_notify_wait(phba);
> +	status =3D be_mbox_notify(ctrl);
>  	if (!status) {
>  		struct be_cmd_resp_mcc_create *resp =3D embedded_payload(wrb);
>  		mccq->id =3D le16_to_cpu(resp->id);
> @@ -1381,7 +1310,7 @@ int beiscsi_cmd_reset_function(struct beiscsi_h=
ba  *phba)
>  	be_wrb_hdr_prepare(wrb, sizeof(*req), true, 0);
>  	be_cmd_hdr_prepare(&req->hdr, CMD_SUBSYSTEM_COMMON,
>  			   OPCODE_COMMON_FUNCTION_RESET, sizeof(*req));
> -	status =3D be_mbox_notify_wait(phba);
> +	status =3D be_mbox_notify(ctrl);
> =20
>  	mutex_unlock(&ctrl->mbox_lock);
>  	return status;
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

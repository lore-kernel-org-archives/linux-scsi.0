From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 2/4] bfa:Fix for crash when bfa_itnim is NULL
Date: Thu, 26 Nov 2015 09:35:46 +0100
Message-ID: <1448526946.2877.85.camel@suse.de>
References: <1448523815-24562-1-git-send-email-anil.gurumurthy@qlogic.com>
	 <1448523815-24562-3-git-send-email-anil.gurumurthy@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44692 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752632AbbKZIft (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Nov 2015 03:35:49 -0500
In-Reply-To: <1448523815-24562-3-git-send-email-anil.gurumurthy@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: anil.gurumurthy@qlogic.com, martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, sudarsana.kalluru@qlogic.com

On Thu, 2015-11-26 at 02:43 -0500, anil.gurumurthy@qlogic.com wrote:
> From: Anil Gurumurthy <anil.gurumurthy@qlogic.com>


Can you please explain a bit more why it is crashing in the commit mess=
age,
i.e. copy the comment you added to the source here as well.

And as I spot the words fix and crash in the subject, you might conside=
r adding
a Cc: stable@vger.kernel.org

Thanks,
	Johannes

>=20
> Signed-off-by: Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>
> Signed-off-by: Anil Gurumurthy <anil.gurumurthy@qlogic.com>
> ---
> =C2=A0drivers/scsi/bfa/bfad_im.c |=C2=A0=C2=A0=C2=A026 ++++++++++++++=
++++++++++++
> =C2=A01 files changed, 26 insertions(+), 0 deletions(-)
>=20
> diff --git a/drivers/scsi/bfa/bfad_im.c b/drivers/scsi/bfa/bfad_im.c
> index efcb247..2c0cf8a 100644
> --- a/drivers/scsi/bfa/bfad_im.c
> +++ b/drivers/scsi/bfa/bfad_im.c
> @@ -272,6 +272,19 @@ bfad_im_target_reset_send(struct bfad_s *bfad, s=
truct
> scsi_cmnd *cmnd,
> =C2=A0	cmnd->host_scribble =3D NULL;
> =C2=A0	cmnd->SCp.Status =3D 0;
> =C2=A0	bfa_itnim =3D bfa_fcs_itnim_get_halitn(&itnim->fcs_itnim);
> +	/*
> +	=C2=A0* bfa_itnim can be NULL if the port gets disconnected and the=
 bfa
> +	=C2=A0* and fcs layers have cleaned up their nexus with the targets=
 and
> +	=C2=A0* the same has not been cleaned up by the shim
> +	=C2=A0*/
> +	if (bfa_itnim =3D=3D NULL) {
> +		bfa_tskim_free(tskim);
> +		BFA_LOG(KERN_ERR, bfad, bfa_log_level,
> +			"target reset, bfa_itnim is NULL\n");
> +		rc =3D BFA_STATUS_FAILED;
> +		goto out;
> +	}
> +
> =C2=A0	memset(&scsilun, 0, sizeof(scsilun));
> =C2=A0	bfa_tskim_start(tskim, bfa_itnim, scsilun,
> =C2=A0			=C2=A0=C2=A0=C2=A0=C2=A0FCP_TM_TARGET_RESET, BFAD_TARGET_RES=
ET_TMO);
> @@ -327,6 +340,19 @@ bfad_im_reset_lun_handler(struct scsi_cmnd *cmnd=
)
> =C2=A0	cmnd->SCp.ptr =3D (char *)&wq;
> =C2=A0	cmnd->SCp.Status =3D 0;
> =C2=A0	bfa_itnim =3D bfa_fcs_itnim_get_halitn(&itnim->fcs_itnim);
> +	/*
> +	=C2=A0* bfa_itnim can be NULL if the port gets disconnected and the=
 bfa
> +	=C2=A0* and fcs layers have cleaned up their nexus with the targets=
 and
> +	=C2=A0* the same has not been cleaned up by the shim
> +	=C2=A0*/
> +	if (bfa_itnim =3D=3D NULL) {
> +		bfa_tskim_free(tskim);
> +		BFA_LOG(KERN_ERR, bfad, bfa_log_level,
> +			"lun reset, bfa_itnim is NULL\n");
> +		spin_unlock_irqrestore(&bfad->bfad_lock, flags);
> +		rc =3D FAILED;
> +		goto out;
> +	}
> =C2=A0	int_to_scsilun(cmnd->device->lun, &scsilun);
> =C2=A0	bfa_tskim_start(tskim, bfa_itnim, scsilun,
> =C2=A0			=C2=A0=C2=A0=C2=A0=C2=A0FCP_TM_LUN_RESET, BFAD_LUN_RESET_TMO=
);

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

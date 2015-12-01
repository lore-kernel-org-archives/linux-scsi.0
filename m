From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH v2 2/4] bfa:Fix for crash when bfa_itnim is NULL
Date: Tue, 01 Dec 2015 08:45:39 +0100
Message-ID: <1448955939.3103.0.camel@suse.de>
References: <1448528040-24954-1-git-send-email-anil.gurumurthy@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1448528040-24954-1-git-send-email-anil.gurumurthy@qlogic.com>
Sender: stable-owner@vger.kernel.org
To: anil.gurumurthy@qlogic.com, martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, 2015-11-26 at 03:54 -0500, anil.gurumurthy@qlogic.com wrote:
> From: Anil Gurumurthy <anil.gurumurthy@qlogic.com>
>=20
> Fix a very corner case when the port gets disconnected and the BFA an=
d FCS
> layers clean up references to the IT nexus.
> During this window if a task management command is issued by the SCSI=
-ML and
> ends up
> referencing a NULL itnim, it could lead to a crash.
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

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

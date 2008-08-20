From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [PATCH] lpfc: fix compiler warning in lpfc_bus_reset_handler
Date: Wed, 20 Aug 2008 11:59:00 -0400
Message-ID: <48AC3F44.4010005@emulex.com>
References: <1213498358.10002.10.camel@localhost.localdomain> <1219242909-9068-1-git-send-email-bhalevy@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:56427 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754379AbYHTP7M (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Aug 2008 11:59:12 -0400
In-Reply-To: <1219242909-9068-1-git-send-email-bhalevy@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Benny Halevy <bhalevy@panasas.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Acked-by: James Smart <james.smart@emulex.com>

-- james s

Benny Halevy wrote:
> gcc 4.3.0 prints this warning:
>=20
> drivers/scsi/lpfc/lpfc_scsi.c: In function =E2=80=98lpfc_bus_reset_ha=
ndler=E2=80=99:
> drivers/scsi/lpfc/lpfc_scsi.c:1245:\
>  warning: =E2=80=98status=E2=80=99 may be used uninitialized in this =
function
>=20
> It seems like the warning is bogus.  However, this patch makes
> sure status is always initialized before used.
>=20
> Signed-off-by: Benny Halevy <bhalevy@panasas.com>
> ---
>  drivers/scsi/lpfc/lpfc_scsi.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_s=
csi.c
> index 1bcebbd..9eda9b2 100644
> --- a/drivers/scsi/lpfc/lpfc_scsi.c
> +++ b/drivers/scsi/lpfc/lpfc_scsi.c
> @@ -1278,8 +1278,9 @@ lpfc_bus_reset_handler(struct scsi_cmnd *cmnd)
>                                                      ndlp->rport->dd_=
data);
>                         if (status !=3D TIMEOUT_ERROR)
>                                 lpfc_release_scsi_buf(phba, lpfc_cmd)=
;
> -               }
> -               if (!lpfc_cmd || status !=3D SUCCESS) {
> +               } else
> +                       status =3D FAILED;
> +               if (status !=3D SUCCESS) {
>                         lpfc_printf_vlog(vport, KERN_ERR, LOG_FCP,
>                                          "0700 Bus Reset on target %d=
 failed\n",
>                                          i);
> --
> 1.6.0
>=20
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

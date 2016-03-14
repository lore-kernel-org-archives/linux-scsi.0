From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 2/3] lpfc: fix misleading indentation
Date: Mon, 14 Mar 2016 16:19:58 +0100
Message-ID: <56E6D69E.1050008@suse.de>
References: <1457965789-3373916-1-git-send-email-arnd@arndb.de>
 <1457965789-3373916-3-git-send-email-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1457965789-3373916-3-git-send-email-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>, martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com, James Smart <james.smart@avagotech.com>, Dick Kennedy <dick.kennedy@avagotech.com>, "James E.J. Bottomley" <JBottomley@odin.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Hannes Reinecke <hare@suse.com>, Sebastian Herbszt <herbszt@gmx.de>
List-Id: linux-scsi@vger.kernel.org

On 03/14/2016 03:29 PM, Arnd Bergmann wrote:
> gcc-6 complains about the indentation of the lpfc_destroy_vport_work_=
array()
> call in lpfc_online(), which clearly doesn't look right:
>=20
> drivers/scsi/lpfc/lpfc_init.c: In function 'lpfc_online':
> drivers/scsi/lpfc/lpfc_init.c:2880:3: warning: statement is indented =
as if it were guarded by... [-Wmisleading-indentation]
>    lpfc_destroy_vport_work_array(phba, vports);
>    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> drivers/scsi/lpfc/lpfc_init.c:2863:2: note: ...this 'if' clause, but =
it is not
>   if (vports !=3D NULL)
>   ^~
>=20
> Looking at the patch that introduced this code, it's clear that the
> behavior is correct and the indentation is wrong.
>=20
> This fixes the indentation and adds curly braces around the previous
> if() block for clarity, as that is most likely what caused the code
> to be misindented in the first place.
>=20
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Fixes: 549e55cd2a1b ("[SCSI] lpfc 8.2.2 : Fix locking around HBA's po=
rt_list")
> ---
>  drivers/scsi/lpfc/lpfc_init.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_i=
nit.c
> index a544366a367e..f57d02c3b6cf 100644
> --- a/drivers/scsi/lpfc/lpfc_init.c
> +++ b/drivers/scsi/lpfc/lpfc_init.c
> @@ -2860,7 +2860,7 @@ lpfc_online(struct lpfc_hba *phba)
>  	}
> =20
>  	vports =3D lpfc_create_vport_work_array(phba);
> -	if (vports !=3D NULL)
> +	if (vports !=3D NULL) {
>  		for (i =3D 0; i <=3D phba->max_vports && vports[i] !=3D NULL; i++)=
 {
>  			struct Scsi_Host *shost;
>  			shost =3D lpfc_shost_from_vport(vports[i]);
> @@ -2877,7 +2877,8 @@ lpfc_online(struct lpfc_hba *phba)
>  			}
>  			spin_unlock_irq(shost->host_lock);
>  		}
> -		lpfc_destroy_vport_work_array(phba, vports);
> +	}
> +	lpfc_destroy_vport_work_array(phba, vports);
> =20
>  	lpfc_unblock_mgmt_io(phba);
>  	return 0;
>=20
Nope.

vports is only valid from within the indentation block, so it should
be moved into it.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)

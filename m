From: =?iso-8859-1?Q?=22Kai_M=E4kisara_=28Kolumbus=29=22?=
	<kai.makisara@kolumbus.fi>
Subject: Re: [PATCH] st: fix corruption of the st_modedef structures in st_set_options()
Date: Wed, 12 Feb 2014 22:45:51 +0200
Message-ID: <B02C8F8C-A15E-4CB7-B57C-B76A20647BAE@kolumbus.fi>
References: <52FA94A7.1010408@redhat.com>
Mime-Version: 1.0 (Mac OS X Mail 7.1 \(1827\))
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vs18.mail.saunalahti.fi ([62.142.117.199]:44972 "EHLO
	vs18.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753658AbaBLUp6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Feb 2014 15:45:58 -0500
In-Reply-To: <52FA94A7.1010408@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Maurizio Lombardi <mlombard@redhat.com>
Cc: linux-scsi@vger.kernel.org, ast@domdv.de, alan@lxorguk.ukuu.org.uk


On 11.2.2014, at 23.22, Maurizio Lombardi <mlombard@redhat.com> wrote:

> When copying the st_modedef structures the devs pointers must be pres=
erved
> in the same way as with the cdevs pointers.
>=20
> This fixes bug 70271: https://bugzilla.kernel.org/show_bug.cgi?id=3D7=
0271
>=20
> [  135.037052] BUG: unable to handle kernel NULL pointer dereference =
at 0000000000000098
> [  135.045048] IP: [<ffffffff812af6a1>] kernfs_find_ns+0x21/0x150
> [  135.050999] PGD 220623067 PUD 222171067 PMD 0
=2E..
> [  135.357859] Code: ff eb e3 0f 1f 80 00 00 00 00 55 48 89 e5 48 83 =
ec 30 48 89 5d d8 4c 89 65 e0 4c 89 6d e8 4c 89 75 f0 4c 89 7d f8 66 66=
 66 66 90 <44> 0f b7 bf 98 00 00 00 8b 05 71 6d 87 00 48 89 fb 49 89 f4=
 49
> [  135.378282] RIP  [<ffffffff812af6a1>] kernfs_find_ns+0x21/0x150
> [  135.384355]  RSP <ffff8802206e5c98>
> [  135.387881] CR2: 0000000000000098
> [  135.391298] ---[ end trace 1968409221ddb3c8 ]---
>=20
> Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>

Acked-by: Kai M=E4kisara <kai.makisara@kolumbus.fi>

> ---
> drivers/scsi/st.c | 11 +++++++++--
> 1 file changed, 9 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
> index a1d6986..afc834e 100644
> --- a/drivers/scsi/st.c
> +++ b/drivers/scsi/st.c
> @@ -2198,12 +2198,19 @@ static int st_set_options(struct scsi_tape *S=
Tp, long options)
> 	struct st_modedef *STm;
> 	char *name =3D tape_name(STp);
> 	struct cdev *cd0, *cd1;
> +	struct device *d0, *d1;
>=20
> 	STm =3D &(STp->modes[STp->current_mode]);
> 	if (!STm->defined) {
> -		cd0 =3D STm->cdevs[0]; cd1 =3D STm->cdevs[1];
> +		cd0 =3D STm->cdevs[0];
> +		cd1 =3D STm->cdevs[1];
> +		d0  =3D STm->devs[0];
> +		d1  =3D STm->devs[1];
> 		memcpy(STm, &(STp->modes[0]), sizeof(struct st_modedef));
> -		STm->cdevs[0] =3D cd0; STm->cdevs[1] =3D cd1;
> +		STm->cdevs[0] =3D cd0;
> +		STm->cdevs[1] =3D cd1;
> +		STm->devs[0]  =3D d0;
> +		STm->devs[1]  =3D d1;
> 		modes_defined =3D 1;
>                 DEBC(printk(ST_DEB_MSG
>                             "%s: Initialized mode %d definition from =
mode 0\n",
> --=20
> Maurizio Lombardi

Thanks,
Kai

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

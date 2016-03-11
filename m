From: Hannes Reinecke <hare@suse.de>
Subject: Re: [patch] scsi_dh_alua: uninitialized variable in alua_check_vpd()
Date: Fri, 11 Mar 2016 11:50:30 +0100
Message-ID: <56E2A2F6.30308@suse.de>
References: <20160311101756.GA9384@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <20160311101756.GA9384@mwanda>
Sender: kernel-janitors-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>, "James E.J. Bottomley" <JBottomley@odin.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Bart Van Assche <bart.vanassche@sandisk.com>, Johannes Thumshirn <jthumshirn@suse.de>, Ewan Milne <emilne@redhat.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 03/11/2016 11:17 AM, Dan Carpenter wrote:
> The pg_updated variable is support to be set to zero at the start but
> it is uninitialized.
>=20
> Fixes: cb0a168cb6b8 ('scsi_dh_alua: update 'access_state' field')
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>=20
> diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scs=
i/device_handler/scsi_dh_alua.c
> index 5bcdf8d..e4f6174 100644
> --- a/drivers/scsi/device_handler/scsi_dh_alua.c
> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
> @@ -332,7 +332,7 @@ static int alua_check_vpd(struct scsi_device *sde=
v, struct alua_dh_data *h,
>  {
>  	int rel_port =3D -1, group_id;
>  	struct alua_port_group *pg, *old_pg =3D NULL;
> -	bool pg_updated;
> +	bool pg_updated =3D 0;
>  	unsigned long flags;
> =20
>  	group_id =3D scsi_vpd_tpg_id(sdev, &rel_port);
>=20
I'd prefer 'pg_updated =3D false'.
Not that we trip over a static code analyser here :-)

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe kernel-janito=
rs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

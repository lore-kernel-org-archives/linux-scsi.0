From: Johannes Thumshirn <jthumshirn@suse.com>
Subject: Re: [PATCH 18/18] scsi_dh_alua: use scsi_vpd_tpg_id()
Date: Tue, 24 Nov 2015 13:18:29 +0100
Message-ID: <1448367509.2877.27.camel@suse.com>
References: <1447081703-110552-1-git-send-email-hare@suse.de>
	 <1447081703-110552-19-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46968 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752561AbbKXMSa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Nov 2015 07:18:30 -0500
In-Reply-To: <1447081703-110552-19-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Jamed Bottomley <jbottomley@odin.com>, linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>

On Mon, 2015-11-09 at 16:08 +0100, Hannes Reinecke wrote:
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
> =C2=A0drivers/scsi/device_handler/scsi_dh_alua.c | 39 +++++----------=
-----
> ----------
> =C2=A01 file changed, 6 insertions(+), 33 deletions(-)
>=20
> diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c
> b/drivers/scsi/device_handler/scsi_dh_alua.c
> index abf05b4..20fe981 100644
> --- a/drivers/scsi/device_handler/scsi_dh_alua.c
> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
> @@ -320,38 +320,10 @@ static int alua_check_tpgs(struct scsi_device
> *sdev)
> =C2=A0 */
> =C2=A0static int alua_check_vpd(struct scsi_device *sdev, struct
> alua_dh_data *h)
> =C2=A0{
> -	unsigned char *d;
> -	unsigned char __rcu *vpd_pg83;
> +	int rel_port =3D -1, group_id;
> =C2=A0
> -	rcu_read_lock();
> -	if (!rcu_dereference(sdev->vpd_pg83)){
> -		rcu_read_unlock();
> -		return SCSI_DH_DEV_UNSUPP;
> -	}
> -
> -	/*
> -	=C2=A0* Look for the correct descriptor.
> -	=C2=A0*/
> -	vpd_pg83 =3D rcu_dereference(sdev->vpd_pg83);
> -	d =3D vpd_pg83 + 4;
> -	while (d < vpd_pg83 + sdev->vpd_pg83_len) {
> -		switch (d[1] & 0xf) {
> -		case 0x4:
> -			/* Relative target port */
> -			h->rel_port =3D get_unaligned_be16(&d[6]);
> -			break;
> -		case 0x5:
> -			/* Target port group */
> -			h->group_id =3D get_unaligned_be16(&d[6]);
> -			break;
> -		default:
> -			break;
> -		}
> -		d +=3D d[3] + 4;
> -	}
> -	rcu_read_unlock();
> -
> -	if (h->group_id =3D=3D -1) {
> +	group_id =3D scsi_vpd_tpg_id(sdev, &rel_port);
> +	if (group_id < 0) {
> =C2=A0		/*
> =C2=A0		=C2=A0* Internal error; TPGS supported but required
> =C2=A0		=C2=A0* VPD identification descriptors not present.
> @@ -360,10 +332,11 @@ static int alua_check_vpd(struct scsi_device
> *sdev, struct alua_dh_data *h)
> =C2=A0		sdev_printk(KERN_INFO, sdev,
> =C2=A0			=C2=A0=C2=A0=C2=A0=C2=A0"%s: No target port descriptors
> found\n",
> =C2=A0			=C2=A0=C2=A0=C2=A0=C2=A0ALUA_DH_NAME);
> -		h->state =3D TPGS_STATE_OPTIMIZED;
> -		h->tpgs =3D TPGS_MODE_NONE;
> =C2=A0		return SCSI_DH_DEV_UNSUPP;
> =C2=A0	}
> +	h->rel_port =3D rel_port;
> +	h->group_id =3D group_id;
> +
> =C2=A0	sdev_printk(KERN_INFO, sdev,
> =C2=A0		=C2=A0=C2=A0=C2=A0=C2=A0"%s: port group %02x rel port %02x\n"=
,
> =C2=A0		=C2=A0=C2=A0=C2=A0=C2=A0ALUA_DH_NAME, h->group_id, h->rel_por=
t);

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 4/5] Setting scsi host template to indicate that fnic
 does not support multiqueue
Date: Tue, 15 Mar 2016 10:46:33 +0100
Message-ID: <20160315094633.GM14621@c203.arch.suse.de>
References: <1457979262-26571-1-git-send-email-satishkh@cisco.com>
 <1457979262-26571-4-git-send-email-satishkh@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41255 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754879AbcCOJqg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Mar 2016 05:46:36 -0400
Content-Disposition: inline
In-Reply-To: <1457979262-26571-4-git-send-email-satishkh@cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Satish Kharat <satishkh@cisco.com>
Cc: linux-scsi@vger.kernel.org

On Mon, Mar 14, 2016 at 11:14:21AM -0700, Satish Kharat wrote:
> Fnic does not support mutiqueue. Setting the scsi_host_template in
> fnic_host_template to indicate that.
>=20
> Changing fnic_version from 1.6.0.21 to 1.6.0.22
>=20
> Signed-off-by: Satish Kharat <satishkh@cisco.com>
> ---
>  drivers/scsi/fnic/fnic.h      | 2 +-
>  drivers/scsi/fnic/fnic_main.c | 1 +
>  2 files changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/fnic/fnic.h b/drivers/scsi/fnic/fnic.h
> index 9ddc920..35264c7 100644
> --- a/drivers/scsi/fnic/fnic.h
> +++ b/drivers/scsi/fnic/fnic.h
> @@ -39,7 +39,7 @@
> =20
>  #define DRV_NAME		"fnic"
>  #define DRV_DESCRIPTION		"Cisco FCoE HBA Driver"
> -#define DRV_VERSION		"1.6.0.21"
> +#define DRV_VERSION		"1.6.0.22"
>  #define PFX			DRV_NAME ": "
>  #define DFX                     DRV_NAME "%d: "
> =20
> diff --git a/drivers/scsi/fnic/fnic_main.c b/drivers/scsi/fnic/fnic_m=
ain.c
> index 58ce902..fa8a121 100644
> --- a/drivers/scsi/fnic/fnic_main.c
> +++ b/drivers/scsi/fnic/fnic_main.c
> @@ -119,6 +119,7 @@ static struct scsi_host_template fnic_host_templa=
te =3D {
>  	.max_sectors =3D 0xffff,
>  	.shost_attrs =3D fnic_attrs,
>  	.track_queue_depth =3D 1,
> +	.disable_blk_mq =3D 1,
>  };
> =20
>  static void
> --=20
> 2.4.3
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Can you please remove the check for shost_use_blk_mq() in fnic_scsi.c a=
s well,
as it's a NOP?

Thanks,
	Johannes

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

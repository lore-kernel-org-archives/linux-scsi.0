From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] scsi: don't try to load a device handler during async
 probing
Date: Mon, 12 Oct 2015 14:21:11 +0200
Message-ID: <561BA5B7.8050703@suse.de>
References: <1444292732-8571-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36022 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751173AbbJLMVN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Oct 2015 08:21:13 -0400
In-Reply-To: <1444292732-8571-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

On 10/08/2015 10:25 AM, Christoph Hellwig wrote:
> Request_module gets really unhappy when called from async probing, so
> revert to not auto load device handler modules during the SCSI bus
> scan.  While autoloading would be really useful we never did this
> until 4.3-rc and it turns out that functionality doesn't actually
> work.
>=20
> Fixes: 566079 ("dm-mpath, scsi_dh: request scsi_dh modules in scsi_dh=
, not dm-mpath")
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reported-by: Paul Mackerras <paulus@ozlabs.org>
> Tested-by: Paul Mackerras <paulus@ozlabs.org>
> ---
>  drivers/scsi/scsi_dh.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/scsi_dh.c b/drivers/scsi/scsi_dh.c
> index 0a2168e..d771bec 100644
> --- a/drivers/scsi/scsi_dh.c
> +++ b/drivers/scsi/scsi_dh.c
> @@ -226,7 +226,7 @@ int scsi_dh_add_device(struct scsi_device *sdev)
> =20
>  	drv =3D scsi_dh_find_driver(sdev);
>  	if (drv)
> -		devinfo =3D scsi_dh_lookup(drv);
> +		devinfo =3D __scsi_dh_lookup(drv);
>  	if (devinfo)
>  		err =3D scsi_dh_handler_attach(sdev, devinfo);
>  	return err;
>=20
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] SCSI-OSD: Delete an unnecessary check before the
 function call "put_disk"
Date: Wed, 24 Jun 2015 16:32:23 +0200
Message-ID: <20150624143223.GA24848@c203.arch.suse.de>
References: <alpine.DEB.2.10.1402251014170.2080@hadrien>
 <530CD2C4.4050903@users.sourceforge.net>
 <alpine.DEB.2.10.1402251840450.7035@hadrien>
 <530CF8FF.8080600@users.sourceforge.net>
 <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6>
 <530DD06F.4090703@users.sourceforge.net>
 <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>
 <5317A59D.4@users.sourceforge.net>
 <546E238A.5050606@users.sourceforge.net>
 <558ABBC2.8080304@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42506 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752765AbbFXOca (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Jun 2015 10:32:30 -0400
Content-Disposition: inline
In-Reply-To: <558ABBC2.8080304@users.sourceforge.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: Benny Halevy <bhalevy@primarydata.com>, Boaz Harrosh <openosd@gmail.com>, "James E. J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>

On Wed, Jun 24, 2015 at 04:16:34PM +0200, SF Markus Elfring wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Wed, 24 Jun 2015 16:06:21 +0200
>=20
> The put_disk() function tests whether its argument is NULL and then
> returns immediately. Thus the test around the call is not needed.
>=20
> This issue was detected by using the Coccinelle software.
>=20
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> ---
>  drivers/scsi/osd/osd_uld.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
>=20
> diff --git a/drivers/scsi/osd/osd_uld.c b/drivers/scsi/osd/osd_uld.c
> index 243eab3..e2075522 100644
> --- a/drivers/scsi/osd/osd_uld.c
> +++ b/drivers/scsi/osd/osd_uld.c
> @@ -407,9 +407,7 @@ static void __remove(struct device *dev)
> =20
>  	OSD_INFO("osd_remove %s\n",
>  		 oud->disk ? oud->disk->disk_name : NULL);
> -
> -	if (oud->disk)
> -		put_disk(oud->disk);
> +	put_disk(oud->disk);
>  	ida_remove(&osd_minor_ida, oud->minor);
> =20
>  	kfree(oud);
> --=20
> 2.4.4
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

--=20
Johannes Thumshirn                                       Storage
jthumshirn@suse.de                             +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

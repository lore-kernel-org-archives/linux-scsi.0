From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1/1] scsi: usb: fix bug which some usb isn't used
Date: Tue, 12 Apr 2016 14:45:03 +0200
Message-ID: <570CEDCF.8010505@suse.de>
References: <1460464554-14116-1-git-send-email-kong.kongxinwei@hisilicon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49238 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932649AbcDLMpH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Apr 2016 08:45:07 -0400
In-Reply-To: <1460464554-14116-1-git-send-email-kong.kongxinwei@hisilicon.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Xinwei Kong <kong.kongxinwei@hisilicon.com>, linuxraid@lsi.com, James.Bottomley@HansenPartnership.com, hch@lst.de, snitzer@redhat.com
Cc: martin.petersen@oracle.com, JBottomley@Odin.com, linux-scsi@vger.kernel.org

On 04/12/2016 02:35 PM, Xinwei Kong wrote:
> some usb disk such as Manufacturer Lenovo will have some problem in
> init process.
>=20
> when it run "scsi_dh_find_driver" function, because this parameter of
> "sdev->inquiry[5]" is 115, it will return "alua" in "scsi_dh_find_dri=
ver"
> function and will have some error log (alua: Attach failed (-22)). so=
me
> usb init will fail and isn't used.
>=20
> Signed-off-by: Xinwei Kong <kong.kongxinwei@hisilicon.com>
> ---
>  drivers/scsi/scsi_dh.c | 3 ---
>  1 file changed, 3 deletions(-)
>=20
> diff --git a/drivers/scsi/scsi_dh.c b/drivers/scsi/scsi_dh.c
> index 54d446c..36b3f354e 100644
> --- a/drivers/scsi/scsi_dh.c
> +++ b/drivers/scsi/scsi_dh.c
> @@ -77,9 +77,6 @@ scsi_dh_find_driver(struct scsi_device *sdev)
>  {
>  	const struct scsi_dh_blist *b;
> =20
> -	if (scsi_device_tpgs(sdev))
> -		return "alua";
> -
>  	for (b =3D scsi_dh_blist; b->vendor; b++) {
>  		if (!strncmp(sdev->vendor, b->vendor, strlen(b->vendor)) &&
>  		    !strncmp(sdev->model, b->model, strlen(b->model))) {
>=20
Nack.
That will completely disable ALUA support for everybody.

And should've been fixed with commit
221255aee67ec1c752001080aafec0c4e9390d95
("scsi: ignore errors from scsi_dh_add_device()").

Please validate.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] esas2r: Fix array overrun
Date: Tue, 16 Feb 2016 08:02:51 +0100
Message-ID: <20160216070251.GG18134@c203.arch.suse.de>
References: <20160215190123.11294.22634.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39023 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753552AbcBPHCy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Feb 2016 02:02:54 -0500
Content-Disposition: inline
In-Reply-To: <20160215190123.11294.22634.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan <gnomes@lxorguk.ukuu.org.uk>
Cc: thenzl@redhat.com, linux-scsi@vger.kernel.org

On Mon, Feb 15, 2016 at 07:01:29PM +0000, Alan wrote:
> Check the array size *before* dereferencing it with a user provided o=
ffset
>=20
> Signed-off-by: Alan Cox <alan@linux.intel.com>
> ---
>  drivers/scsi/esas2r/esas2r_ioctl.c |    5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/scsi/esas2r/esas2r_ioctl.c b/drivers/scsi/esas2r=
/esas2r_ioctl.c
> index baf9130..3e84834 100644
> --- a/drivers/scsi/esas2r/esas2r_ioctl.c
> +++ b/drivers/scsi/esas2r/esas2r_ioctl.c
> @@ -1360,14 +1360,15 @@ int esas2r_ioctl_handler(void *hostdata, int =
cmd, void __user *arg)
>  	if (ioctl->header.channel =3D=3D 0xFF) {
>  		a =3D (struct esas2r_adapter *)hostdata;
>  	} else {
> -		a =3D esas2r_adapters[ioctl->header.channel];
> -		if (ioctl->header.channel >=3D MAX_ADAPTERS || (a =3D=3D NULL)) {
> +		if (ioctl->header.channel >=3D MAX_ADAPTERS ||
> +			esas2r_adapters[ioctl->header.channel] =3D=3D NULL) {
>  			ioctl->header.return_code =3D IOCTL_BAD_CHANNEL;
>  			esas2r_log(ESAS2R_LOG_WARN, "bad channel value");
>  			kfree(ioctl);
> =20
>  			return -ENOTSUPP;
>  		}
> +		a =3D esas2r_adapters[ioctl->header.channel];
>  	}
> =20
>  	switch (cmd) {
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

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

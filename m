From: Don Brace <don.brace@microsemi.com>
Subject: RE: [PATCHv2] hpsa: expose enclosures
Date: Tue, 7 Mar 2017 15:05:41 +0000
Message-ID: <4993A297653ECB4581FA5C3C31323D194F331B4F@avsrvexchmbx1.microsemi.net>
References: <1487847303-82580-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam01on0089.outbound.protection.outlook.com ([104.47.32.89]:17328
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932767AbdCGPGO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 7 Mar 2017 10:06:14 -0500
In-Reply-To: <1487847303-82580-1-git-send-email-hare@suse.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.com>

> -----Original Message-----
> From: Hannes Reinecke [mailto:hare@suse.de]
> Sent: Thursday, February 23, 2017 4:55 AM
> To: Martin K. Petersen <martin.petersen@oracle.com>
> Cc: Christoph Hellwig <hch@lst.de>; James Bottomley
> <james.bottomley@hansenpartnership.com>; linux-scsi@vger.kernel.org;
> Hannes Reinecke <hare@suse.de>; Don Brace
> <don.brace@microsemi.com>; Hannes Reinecke <hare@suse.com>
> Subject: [PATCHv2] hpsa: expose enclosures
>=20
> EXTERNAL EMAIL
>=20
>=20
> Some servers have a built-in enclosure which will show up on the
> same bus as the internal physical devices. This patch fixes the
> driver to expose them.
>=20
> Cc: Don Brace <don.brace@microsemi.com>
> Signed-off-by: Hannes Reinecke <hare@suse.com>

Masking various SES targets is a conscious choice, not a design oversight.
So, I have to decline this patch.,

Thanks,
Don Brace
ESC - Smart Storage
Microsemi Corporation

> ---
>  drivers/scsi/hpsa.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> index 524a0c7..a77ed5a 100644
> --- a/drivers/scsi/hpsa.c
> +++ b/drivers/scsi/hpsa.c
> @@ -4407,7 +4407,10 @@ static void hpsa_update_scsi_devices(struct
> ctlr_info *h)
>                  * Expose all devices except for physical devices that
>                  * are masked.
>                  */
> -               if (MASKED_DEVICE(lunaddrbytes) && this_device-
> >physical_device)
> +               if (this_device->devtype =3D=3D TYPE_ENCLOSURE)
> +                       this_device->expose_device =3D 1;
> +               else if (MASKED_DEVICE(lunaddrbytes) &&
> +                        this_device->physical_device)
>                         this_device->expose_device =3D 0;
>                 else
>                         this_device->expose_device =3D 1;
> --
> 1.8.5.6

From: Hannes Reinecke <hare@suse.de>
Subject: Re: READ_CAPACITY_16 vs. READ_CAPACITY_10
Date: Thu, 12 Sep 2013 07:56:02 +0200
Message-ID: <52315772.8040402@suse.de>
References: <1378821408.13541.26.camel@linux-fkkt.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45169 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753315Ab3ILF4D (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 Sep 2013 01:56:03 -0400
In-Reply-To: <1378821408.13541.26.camel@linux-fkkt.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Oliver Neukum <oneukum@suse.de>
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-scsi@vger.kernel.org

On 09/10/2013 03:56 PM, Oliver Neukum wrote:
> Hi Hannes,
>=20
> you objected to this patch saying there's a possibilty that
> HS devices may also need this feature, which would require
> a quirk. Does this mean that the patch is acceptable only
> with an additional predefined quirk, or do you insist that all
> devices be handled with quirks?
>=20
> 	Regards
> 		Oliver
>=20
> +++ b/drivers/usb/storage/scsiglue.c
> @@ -211,8 +211,11 @@ static int slave_configure(struct
> scsi_device0*sdev)
>  		/*
>  		 * Many devices do not respond properly to READ_CAPACITY_16.
>  		 * Tell the SCSI layer to try READ_CAPACITY_10 first.
> +		 * However some USB 3.0 drive enclosures return capacity
> +		 * modulo 2TB
>  		 */
> -		sdev->try_rc_10_first =3D 1;
> +		if (us->pusb_dev->speed < USB_SPEED_SUPER)
> +			sdev->try_rc_10_first =3D 1;
> =20
>  		/* assume SPC3 or latter devices support sense size > 18 */
>  		if (sdev->scsi_level > SCSI_SPC_2)
>=20
Predefined quirks is okay.
My main objection here is that the original issue most likely is a
buggy firmware, so there is a _very_ good chance that it'll be
resolved in firmware in the near future.
At the same time, other firmwares might continue to not support
READ_CAPACITY_16 while enabling HS.
So both issues really should be kept separate, which'll warrant a
new flag.
Which of course could be set to on per default on HS devices.
As long as we can switch is off again ...

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: J. Hawn, J. Guild, F. Imend=C3=B6rffer, HRB 16746 (AG N=C3=BCrnberg=
)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Hannes Reinecke <hare@suse.de>
Subject: Re: Potential out-of-bounds access in drivers/scsi/sd.c
Date: Thu, 05 Sep 2013 15:38:00 +0200
Message-ID: <52288938.30102@suse.de>
References: <Pine.LNX.4.44L0.1309041134190.1186-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43458 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750721Ab3IENiC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 5 Sep 2013 09:38:02 -0400
In-Reply-To: <Pine.LNX.4.44L0.1309041134190.1186-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Dmitry Vyukov <dvyukov@google.com>, linux-scsi@vger.kernel.org, richard@r-senior.demon.co.uk, ltuikov@yahoo.com, jbottomley@parallels.com, Andrey Konovalov <andreyknvl@google.com>, Kostya Serebryany <kcc@google.com>

On 09/04/2013 05:42 PM, Alan Stern wrote:
> On Wed, 4 Sep 2013, Paolo Bonzini wrote:
>=20
>>> --- usb-3.11.orig/drivers/scsi/sd.c
>>> +++ usb-3.11/drivers/scsi/sd.c
>>> @@ -2419,7 +2419,7 @@ sd_read_cache_type(struct scsi_disk *sdk
>>>  			}
>>>  		}
>>> =20
>>> -		if (modepage =3D=3D 0x3F) {
>>> +		if (modepage =3D=3D 0x3F || offset + 2 >=3D len) {
>>>  			sd_printk(KERN_ERR, sdkp, "No Caching mode page "
>>>  				  "present\n");
>>>  			goto defaults;
>>
>> If you do this, the buggy "if" becomes dead code (the loop above doe=
sn't
>> have any "break", so you know that offset >=3D len and the new condi=
tion
>> is always true).
>>
>> So the patch does indeed prevent the bug, but the code can be simpli=
fied.
>=20
> That's right.  I didn't realize it at first, but the only way to get=20
> here is if the next page offset lies beyond the end of the data in th=
e=20
> buffer.  Therefore the patch can be simplified as follows.
>=20
Oh, pretty please. I already had customers complaining about the
'got wrong page' message. Which again demonstrated nicely the
uncertainty relation between correctness and usability :-)

> Alan Stern
>=20
>=20
>=20
> Index: usb-3.11/drivers/scsi/sd.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- usb-3.11.orig/drivers/scsi/sd.c
> +++ usb-3.11/drivers/scsi/sd.c
> @@ -2419,14 +2419,9 @@ sd_read_cache_type(struct scsi_disk *sdk
>  			}
>  		}
> =20
> -		if (modepage =3D=3D 0x3F) {
> -			sd_printk(KERN_ERR, sdkp, "No Caching mode page "
> -				  "present\n");
> -			goto defaults;
> -		} else if ((buffer[offset] & 0x3f) !=3D modepage) {
> -			sd_printk(KERN_ERR, sdkp, "Got wrong page\n");
> -			goto defaults;
> -		}
> +		sd_printk(KERN_ERR, sdkp, "No Caching mode page found\n");
> +		goto defaults;
> +
>  	Page_found:
>  		if (modepage =3D=3D 8) {
>  			sdkp->WCE =3D ((buffer[offset + 2] & 0x04) !=3D 0);
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20
Acked-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

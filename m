From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] st: Do not rewind for SG_IO
Date: Thu, 06 Feb 2014 14:10:01 +0100
Message-ID: <52F389A9.808@suse.de>
References: <1391157974-17512-1-git-send-email-hare@suse.de> <52EBD2BB.8020705@tributary.com> <52ECFF7B.7000401@suse.de> <60EE5D9C-A799-4C8D-8962-DB9D7C1C8414@kolumbus.fi> <52EE2F2D.1010300@suse.de> <52EFACA4.6060001@tributary.com> <52EFB06C.8010101@suse.de> <52EFB0E7.3000504@tributary.com> <CAPXgP13dn+VGpu0OLHatUvP4TRDp2YEgCXYB837ReADZTWg_NA@mail.gmail.com> <52F010F9.5090305@tributary.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:41732 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756322AbaBFNKD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 Feb 2014 08:10:03 -0500
In-Reply-To: <52F010F9.5090305@tributary.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeremy Linton <jlinton@tributary.com>, Kay Sievers <kay@vrfy.org>
Cc: =?UTF-8?B?IkthaSBNw6RraXNhcmEgKEtvbHVtYnVzKSI=?= <kai.makisara@kolumbus.fi>, James Bottomley <jbottomley@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Doug Gilbert <dgilbert@interlog.com>

On 02/03/2014 10:58 PM, Jeremy Linton wrote:
> On 2/3/2014 2:51 PM, Kay Sievers wrote:
>> This is not simple and not going to happen. Sibling devices in /sys =
cannot
>> have a relationship in udev, there are only parent/child dependencie=
s.
>=20
> 	Ok.. so if we can't ignore all the "spare" device nodes in a given /=
sys entry
> for a given device. Why open the device to scan it?
>=20
> 	I've often wondered why the serial number isn't part of the data in =
/sys
> along with the manufacture/model. The last tape drive I saw that fail=
ed to
> respond to inquiry page 0x80 was over a decade ago (probably manufact=
ured in
> the early 90s). So enabling it just for tape is pretty safe.
>=20
>=20
> 	Matching Manufacturer/model/serial is going to be better than anythi=
ng your
> going to get out of 0x83 anyway. That data is guaranteed to be there,=
 but its
> also guaranteed to be unreliable (every device, and every port has a =
slightly
> different set of descriptors they choose to support).
>=20
> 	Plus, your not going to have issues accidentally rewinding a device,=
 or
> resetting a tape density, or accidentally turning compression off if =
you don't
> open the device.
>=20
And indeed, I have been wondering about this, too.
And (again) it is something which has been on my To-Do list for a
long time.

Moving EVPD page 0x83 (and maybe 0x80, too) into sysfs will save
quite a lot of headache we have currently; udev won't have to
call 'sg_inq', information will be present even though the
device itself might be temporarily unavailable yadda yadda.

So I've decided to bite the bullet and sent out a patch,
check for 'Add EVPD page 0x83 entries to sysfs'.

Reviews are welcome.

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

From: =?windows-1252?Q?=22Kai_M=E4kisara_=28Kolumbus=29=22?=
	<kai.makisara@kolumbus.fi>
Subject: Re: [PATCH] st: Do not rewind for SG_IO
Date: Sat, 1 Feb 2014 17:23:06 +0200
Message-ID: <60EE5D9C-A799-4C8D-8962-DB9D7C1C8414@kolumbus.fi>
References: <1391157974-17512-1-git-send-email-hare@suse.de> <52EBD2BB.8020705@tributary.com> <52ECFF7B.7000401@suse.de>
Mime-Version: 1.0 (Mac OS X Mail 7.1 \(1827\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vs16.mail.saunalahti.fi ([62.142.117.197]:47945 "EHLO
	vs16.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753329AbaBAPdM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 1 Feb 2014 10:33:12 -0500
In-Reply-To: <52ECFF7B.7000401@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Jeremy Linton <jlinton@tributary.com>, James Bottomley <jbottomley@parallels.com>, Kay Sievers <kay@vrfy.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>


On 1.2.2014, at 16.06, Hannes Reinecke <hare@suse.de> wrote:

> On 01/31/2014 05:43 PM, Jeremy Linton wrote:
>> -----BEGIN PGP SIGNED MESSAGE-----
>> Hash: SHA1
>>=20
>> On 1/31/2014 2:46 AM, Hannes Reinecke wrote:
>>=20
>>> This patch make the tape always non-rewinding when SG_IO is used, t=
hus
>>> allowing udev to get a proper device id for tapes.
>>=20
>> 	Maybe instead of silently changing the behavior, if you just _HAVE_=
 to open
>> the st device, add an ioctl or st/mt_op that disables the rewind on =
close.
>> That way applications have to explicitly disable the rewind on close=
=2E
>>=20
> Okay, that sounds like a better alternative.
> Point is for udev we simply _have_ to use the given device node.
> And when this happens to be set to rewind on close we're doomed.
>=20
I don=92t quite understand why it has to use the auto-rewind device ins=
tead of the
non-rewind device. From the minor number it can see what the non-rewind=
 device
is. If the problem is that it is not guaranteed that the non-rewind dev=
ice exits, you
should rather change the order the devices are created.

If you absolutely have to do this, then do it. But new ioctls are depre=
cated and
also it is a bad habit to change the kernel to make things easier for a=
 single
program.

> I'll be drafting up a patch.
>=20
If you do, don=92t forget to update the documentation.

Thanks,
Kai

P.S. I don=92t like the auto-rewind devices at all. But the Unix system=
s have those
and so we also must to have those ;-)

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

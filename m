From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] st: Do not rewind for SG_IO
Date: Mon, 03 Feb 2014 16:06:20 +0100
Message-ID: <52EFB06C.8010101@suse.de>
References: <1391157974-17512-1-git-send-email-hare@suse.de> <52EBD2BB.8020705@tributary.com> <52ECFF7B.7000401@suse.de> <60EE5D9C-A799-4C8D-8962-DB9D7C1C8414@kolumbus.fi> <52EE2F2D.1010300@suse.de> <52EFACA4.6060001@tributary.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34655 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750967AbaBCPGV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 3 Feb 2014 10:06:21 -0500
In-Reply-To: <52EFACA4.6060001@tributary.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeremy Linton <jlinton@tributary.com>, =?windows-1252?Q?=22Kai_M=E4?= =?windows-1252?Q?kisara_=28Kolumbus=29=22?= <kai.makisara@kolumbus.fi>
Cc: James Bottomley <jbottomley@parallels.com>, Kay Sievers <kay@vrfy.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Doug Gilbert <dgilbert@interlog.com>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 02/03/2014 03:50 PM, Jeremy Linton wrote:
> On 2/2/2014 5:42 AM, Hannes Reinecke wrote:
>> This is due to the strictly sequential design udev has.
>> Essentially udev spawns a worker for every device which gets
>> created (=3D udev receives a uevent for).
>  The part I fail to see in this explanation is why the
> nst/st/st*a/st*m/etc handles are being treated as separate
> devices. They aren't. They are all the same physical tape
> device, so why are the nst devices being handled separately=20
> from the st ones?
>=20
That's due to udev.
Udev is getting events for each device it should create a device
node for.
So for 'st' it'll get a series of events for 'stX', and another
series of
events for 'nstX'.
Udev will treat each of these events separately, with distinct worker
programs handling them. Each of those workers run fully asynchronous
and cannot access information from other workers.
Udev cannot and should not make assumptions about any correlations
between events; if you need this then you have to explicitly gate
events via the 'collect' mechanism.
But even then you can only access information from the currently
running
process/event; you cannot modify information from prior events.

So when trying to generate unique IDs for tape devices you either
have to

a) modify the program generating the Unique ID to redirect the call
   to a different device node
or

b) to modify the driver to not rewind the tape

We tried approach a) when using the scsi_id program. But as this
program
is rather old and doesn't have a maintainer I'm working on using
'sg_inq' as a replacement. And these kind of hacks really do not
belong in a generic program.
(It would involve create a temporary device node, call SG_IO on
that, and remove the temporary device node again).
So now we're shooting for b).

Unless you have a better idea ...

Cheers,

Hannes
- --=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJS77BsAAoJEGz4yi9OyKjPQz8P/1cY+k9KtEezXC2ovuzJmy9T
BjQaoxcTgHbaXykFyEoJeiNQ09XrjAl7IlVOOF9jX3XqC4kYQiBZCThUnC8O3D69
vaZrA6+VR9AoTXbfNzBUdHzEKWTlz5X2ThLzrLPogXS6v5hiw0iBcLq5mvlJxlkc
DBHJrV+ujlKOM/JibNwUNldeYAFnrrzCCH50arJ/Eqa6BcLZ2uXTksACqIVybUoI
nW1yfVzJdsxI5YwPp0N5bnuAPIg3N7zBTcFCVYqTHUiAmrS4HYkHRrC501yuopCA
PS9Gv1KznctEIGudoP5S0Lwn+g/aVSuzOTpo3uUWAa1BNyyvRMRUSzSIUfm2WdAj
+o1mswhhX6NZMM9rFrM35dbiky2Nv/pvc2zcD4pvizsLiHkoQER7GQ9FCaBNXP7d
eK0OF2jJeEPV6LSC97wxH27Vybv/c89wp0HGDaJc+kd8+WZFIvkLbvY7K3BSA2ut
YvuebI59veIYNZEJVEdAGYQ3IEUG8uukbdpqf3Kdr17PQEms/gTW+xYWPo1+hBR7
V58ojgghBxPdVwGRyiSgKgjY/vHLFunm9H83LDrHKdQsKs8JGiTCflPhJEMwwsDo
mhlmd5Ihw20Cyh46sd3Uu1onH0L5Rg0hfDqT913ShUFYi5Y+XvtHEezYn73OxYDr
JoUo9HYfT843MabEympC
=3Dc45s
-----END PGP SIGNATURE-----
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

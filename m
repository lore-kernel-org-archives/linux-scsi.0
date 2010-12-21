From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: [regression] 2.6.37-rc5: scsi_eh_11 CPU loop
Date: Tue, 21 Dec 2010 11:31:15 +0100
Message-ID: <201012211131.27698.Martin@lichtvoll.de>
References: <201012201105.08993.Martin@lichtvoll.de> <4D0F8E98.9070500@kernel.org> (sfid-20101220_204334_509249_EB5633FD)
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart5527919.zP8bk1yNEJ";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4D0F8E98.9070500@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

--nextPart5527919.zP8bk1yNEJ
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Am Monday 20 December 2010 schrieb Tejun Heo:
> Hello,
>=20
> On 12/20/2010 11:05 AM, Martin Steigerwald wrote:
> > Hi!
> >=20
> > top - 10:49:07 up 3 days, 14:24,  8 users,  load average: 2.31, 2.62,
> > 2.28 Tasks: 198 total,   2 running, 194 sleeping,   0 stopped,   2
> > zombie Cpu(s):  6.8%us, 93.2%sy,  0.0%ni,  0.0%id,  0.0%wa,  0.0%hi,
> >  0.0%si, 0.0%st
> > Mem:   2073660k total,  1941152k used,   132508k free,   153876k
> > buffers Swap:  4000180k total,   243452k used,  3756728k free, =20
> > 676612k cached
> >=20
> >   PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
> >   735 root      20   0     0    0    0 R 85.2  0.0 137:28.94
> >   scsi_eh_11
> >=20
> > I don't see anything in dmesg. Everything appears to work as normal,
> > except for the slowness. Which got a bit better upon renicing
> > scsi_eh_11 to 19 (not knowing whether its really safe, but it works
> > for now).
>=20
> > Interrupts appear to be within usual range as well:

> Can you please apply the following patch, trigger the problem and
> attach the kernel log?
>=20
> diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
> index 5e59050..c748b5a 100644
[...]
>=20
> +	if (!(ap->pflags & ATA_PFLAG_LOADING) && xxx < 16) {
> +		ata_port_printk(ap, KERN_WARNING, "XXX ata_eh_set_pending()\n");
> +		dump_stack();
> +		xxx++;
> +	}
> +

I will do so with my next kernel compile - likely rc7 if it comes out=20
before Christmas.

As I do not know what exactly triggers it, it can take a while till I=20
experience it again. I hope to be able to trigger it by inserting and=20
removing the PCMCIA eSATA adapter lots of times. As the bug happened, I=20
forgot to vgchange -an the LVM on the external drive. That might be or=20
might not be related to triggering the issue. I will try this as well.

Reported-as: https://bugzilla.kernel.org/show_bug.cgi?id=3D25392

Might make sense to switch this bugzilla report to mail. Or use the=20
bugzilla. Or just use the bugzilla for tracking and continue using mail.=20
I'll do whatever suits you best (but prefer mail).

Thanks,
=2D-=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

--nextPart5527919.zP8bk1yNEJ
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAk0QgfQACgkQmRvqrKWZhMf0KwCguzxXbUWSqnJGj1ZoguQPbrWQ
ozwAniZoLZeU8cICE+2DbYmxTTEtDl3F
=UTKL
-----END PGP SIGNATURE-----

--nextPart5527919.zP8bk1yNEJ--

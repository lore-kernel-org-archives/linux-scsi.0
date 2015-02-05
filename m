From: NeilBrown <neilb@suse.de>
Subject: Re: raid1 narrow_write_error with 4K disks, sd "bad block number
 requested" messages
Date: Thu, 5 Feb 2015 15:59:53 +1100
Message-ID: <20150205155953.64e9b1e4@notabene.brown>
References: <54C9006A.2030807@stratus.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/3W4Yq7E79ajNF4EzYonf+CP"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <54C9006A.2030807@stratus.com>
Sender: linux-raid-owner@vger.kernel.org
To: Nate Dailey <nate.dailey@stratus.com>
Cc: linux-raid@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

--Sig_/3W4Yq7E79ajNF4EzYonf+CP
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 28 Jan 2015 10:29:46 -0500 Nate Dailey <nate.dailey@stratus.com>
wrote:

> I'm writing about something that appears to be an issue with raid1's=20
> narrow_write_error, particular to non-512-byte-sector disks. Here's what=
=20
> I'm doing:
>=20
> - 2 disk raid1, 4K disks, each connected to a different SAS HBA
> - mount a filesystem on the raid1, run a test that writes to it
> - remove one of the SAS HBAs (echo 1 >=20
> /sys/bus/pci/devices/0000\:45\:00.0/remove)
>=20
> At this point, writes fail and narrow_write_error breaks them up and=20
> retries, one sector at a time. But these are 512-byte sectors, and sd=20
> doesn't like it:
>=20
> [ 2645.310517] sd 3:0:1:0: [sde] Bad block number requested
> [ 2645.310610] sd 3:0:1:0: [sde] Bad block number requested
> [ 2645.310690] sd 3:0:1:0: [sde] Bad block number requested
> ...
>=20
> There appears to be no real harm done, but there can be a huge number of=
=20
> these messages in the log.
>=20
> I can avoid this by disabling bad block tracking, but it looks like=20
> maybe the superblock's bblog_shift is intended to address this exact=20
> issue. However, I don't see a way to change it. Presumably this is=20
> something mdadm should be setting up? I don't see bblog_shift ever set=20
> to anything other than 0.
>=20
> This is on a RHEL 7.1 kernel, version 3.10.0-221.el7. I took a look at=20
> upstream sd and md changes and nothing jumps out at me that would have=20
> affected this (but I have not tested to see if the bad block messages do=
=20
> or do not happen on an upstream kernel).
>=20
> I'd appreciate any advice re: how to handle this. Thanks!

Thanks for the report.

narrow_write_error() should use bdev_logical_block_size() and round up to
that.
Possibly mdadm should get the same information and set bblog_shift
accordingly when creating a bad block log.

I've made a note to fix that, but I'm happy to review  patches too :-)

thanks,
NeilBrown


--Sig_/3W4Yq7E79ajNF4EzYonf+CP
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVNL4yTnsnt1WYoG5AQKCIw//bLdpni6R2CHBVrZKkAFZ4leVE8Z3odih
ZOsu+zyHWRwc/N92IHvm7HAkAI+u+nmdfV5W2L5WDad4CUXrHa15EzqX2axkyVTR
EhhiBHcZkNMDKZQ47Y/l7X4EIWT1WKoiTdEEGwbe/CxHk2XohZ07owv6xGQixuBa
zogWREYqfSlO9unS8NgMjKZc6wRak0nc0bstaIj2qB4RDvYhp/yhdXQIu8r9Y6Po
VZ9p+DBdNOZ8S1eejnxF5swOCEK4qlGXRzSKr7UEAK382j5N/eM3nZd1+tXP/3iB
sHpVPERaPp/3Rr76++3rY8X/UclioOb5yShTrUVZHKIa5YfyvnXH+bvecm3wZOGU
w+7jwhsELfubFQiqvgAMam+3Mgz58u2RKvAQdnknVmYJLf1J53l0+LYrtzraGdKx
JjUguDsimTe/KBS94u8aCnYYmhUt1t6YUXjrMSYsyW2QXywYHFd6zesm5PmsEx8n
zCK3npGhhS1Z6hYMfkDomwr+vKecMm1ne8deTf2TxVxrALwZIBGOC9uHN86Mg9W+
2Xk3tlvaX+Y+Kwy41sQUntuvZXHL+a/4KmzIvjHanRBANYtamOS0gDvDz7DAS7dr
8Ug/Dqr82xtMvBDvmGKUk+MdhmPgvoOc3KCnr25aJjkD/v0S4V+j3S9+ac6YVvKr
FVLUo/dNL4I=
=QfPf
-----END PGP SIGNATURE-----

--Sig_/3W4Yq7E79ajNF4EzYonf+CP--

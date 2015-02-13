From: NeilBrown <neilb@suse.de>
Subject: Re: raid1 narrow_write_error with 4K disks, sd "bad block number
 requested" messages
Date: Fri, 13 Feb 2015 17:01:32 +1100
Message-ID: <20150213170132.0c61c508@notabene.brown>
References: <54C9006A.2030807@stratus.com>
	<20150205155953.64e9b1e4@notabene.brown>
	<54DCD8DD.7080103@stratus.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/1TNMfviArU99CctkHjEZ/GD"; protocol="application/pgp-signature"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53670 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751655AbbBMGBl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Feb 2015 01:01:41 -0500
In-Reply-To: <54DCD8DD.7080103@stratus.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Nate Dailey <nate.dailey@stratus.com>
Cc: linux-raid@vger.kernel.org, linux-scsi@vger.kernel.org

--Sig_/1TNMfviArU99CctkHjEZ/GD
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 12 Feb 2015 11:46:21 -0500 Nate Dailey <nate.dailey@stratus.com>
wrote:

> On 02/04/2015 11:59 PM, NeilBrown wrote:
> > On Wed, 28 Jan 2015 10:29:46 -0500 Nate Dailey <nate.dailey@stratus.com>
> > wrote:
> >
> >> I'm writing about something that appears to be an issue with raid1's
> >> narrow_write_error, particular to non-512-byte-sector disks. Here's wh=
at
> >> I'm doing:
> >>
> >> - 2 disk raid1, 4K disks, each connected to a different SAS HBA
> >> - mount a filesystem on the raid1, run a test that writes to it
> >> - remove one of the SAS HBAs (echo 1 >
> >> /sys/bus/pci/devices/0000\:45\:00.0/remove)
> >>
> >> At this point, writes fail and narrow_write_error breaks them up and
> >> retries, one sector at a time. But these are 512-byte sectors, and sd
> >> doesn't like it:
> >>
> >> [ 2645.310517] sd 3:0:1:0: [sde] Bad block number requested
> >> [ 2645.310610] sd 3:0:1:0: [sde] Bad block number requested
> >> [ 2645.310690] sd 3:0:1:0: [sde] Bad block number requested
> >> ...
> >>
> >> There appears to be no real harm done, but there can be a huge number =
of
> >> these messages in the log.
> >>
> >> I can avoid this by disabling bad block tracking, but it looks like
> >> maybe the superblock's bblog_shift is intended to address this exact
> >> issue. However, I don't see a way to change it. Presumably this is
> >> something mdadm should be setting up? I don't see bblog_shift ever set
> >> to anything other than 0.
> >>
> >> This is on a RHEL 7.1 kernel, version 3.10.0-221.el7. I took a look at
> >> upstream sd and md changes and nothing jumps out at me that would have
> >> affected this (but I have not tested to see if the bad block messages =
do
> >> or do not happen on an upstream kernel).
> >>
> >> I'd appreciate any advice re: how to handle this. Thanks!
> >
> > Thanks for the report.
> >
> > narrow_write_error() should use bdev_logical_block_size() and round up =
to
> > that.
> > Possibly mdadm should get the same information and set bblog_shift
> > accordingly when creating a bad block log.
> >
> > I've made a note to fix that, but I'm happy to review  patches too :-)
> >
> > thanks,
> > NeilBrown
> >
>=20
> I will post a narrow_write_error patch shortly.
>=20
> I did some experimentation with setting the bblog_shift in mdadm, but it=
=20
> didn't work out the way I expected. It turns out that the value is only=20
> loaded from the superblock if:
>=20
> 1453        if ((le32_to_cpu(sb->feature_map) & MD_FEATURE_BAD_BLOCKS) &&
> 1454            rdev->badblocks.count =3D=3D 0) {
> ...
> 1473                rdev->badblocks.shift =3D sb->bblog_shift;
>=20
> And this feature bit is only set if any bad blocks have actually been=20
> recorded.
>=20
> It also appears to me that the shift is used when loading the bad blocks=
=20
> from the superblock, but not when storing the bad block list in the=20
> superblock.
>=20
> Seems like these are bugs, but I'm not certain how the code is supposed=20
> to work (and am getting in a bit over my head with this).

Yes, that's probably a bug.
The

	} else if (sb->bblog_offset !=3D 0)
		rdev->badblocks.shift =3D 0;

should be

	} else if (sb->bblog_offset !=3D 0)
		rdev->badblocks.shift =3D sb->bblog_shift;

>=20
> In any case, it doesn't appear to me that there's any harm in having the=
=20
> bblog_shift not match the disk's block size (right?).

Having the bblog_shift larger than the disk's block size certainly should n=
ot
be a problem.  Having it small only causes the problem that you have already
discovered.

NeilBrown


>=20
> Nate Dailey
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/1TNMfviArU99CctkHjEZ/GD
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVN2TPDnsnt1WYoG5AQKw9g//WPdyu1xSwhRh1m94dnT+W45C0YU01Tzm
BK2u+fhidr+h5bIFQRRWgZTSVdOiBrP8RMXrKHRVjH9u8UaQHhBbszibP7yMuSpm
bLgWEEEsKpMLaq9R3mWOmCSNQNAUi1YZfIib2BCXjJ2Sy9iyORpfxSLXNDdYqBo7
AZgSyKzh4t0SyKjTtE6YS00SK12Ak60lbnzI4iOZ1fC3kH64Tca8x5YcfSJr3d09
3+NlXTiCI+ZVU90A81VBrIVy3n+Bh6RJrySqW6RPutFnRRoUtY3tvG7GxGx4NEp/
ua3FUjWhOV6G91DU8ZMLj0FxJVNj84UcwIqdbqJmh+pvl/uy/suXcG1mOrKXxQRP
BzSGj0H+wIhVbBgZ922mWB4pHpqgQtBuolsmH6fc+BN9D8ai3TilSPTQKsoEdaBu
KsbtXeMVIb6kPmAVQXa5Uqtjt9P+uynQ2aEPQSLoI1aBGrPHm7GLZFyZXy57h+ar
9kl9lbcjd+ZjLaDVb9rQIYqDX/KebS2W4jisozZ9o9/1HBVrZwAXLzToabsDSBpP
9enM4i28l4sJqt/mQ4Tc3wWvgHLN5YTJ87gcaIPn42i/og4sQhrv3qGpO70VtVkZ
NBaK36PKxCEJ+XLm193BYx4WI7DTWtKQMxQ/Ce+PFxV9hqKbz8Qc1xlvH9CrbY6B
r11jnvidINI=
=La0f
-----END PGP SIGNATURE-----

--Sig_/1TNMfviArU99CctkHjEZ/GD--

From: Felipe Balbi <balbi@ti.com>
Subject: Re: [PATCH v18 3/4] ata: Add APM X-Gene SoC AHCI SATA host
 controller driver
Date: Mon, 28 Apr 2014 18:58:16 -0500
Message-ID: <20140428235816.GC18010@saruman.home>
References: <1394841201-29495-1-git-send-email-lho@apm.com>
 <1394841201-29495-3-git-send-email-lho@apm.com>
 <1394841201-29495-4-git-send-email-lho@apm.com>
 <201403151019.49316.arnd@arndb.de>
 <CAPw-ZTksg3z8GY55jb7-yP1wfq2BF6apB9KBgbokpshKbiiAaw@mail.gmail.com>
 <CAPw-ZTmGA5rtVmHx5jZedkey2iJD7L+3-905W=4G4rAJ=BeWgA@mail.gmail.com>
Reply-To: <balbi@ti.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pZs/OQEoSSbxGlYw"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:45687 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757251AbaD1X6z (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Apr 2014 19:58:55 -0400
Content-Disposition: inline
In-Reply-To: <CAPw-ZTmGA5rtVmHx5jZedkey2iJD7L+3-905W=4G4rAJ=BeWgA@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Loc Ho <lho@apm.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Kishon Vijay Abraham I <kishon@ti.com>, balbi@ti.com, Olof Johansson <olof@lixom.net>, Tejun Heo <tj@kernel.org>, Linux SCSI List <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Don Dutile <ddutile@redhat.com>, Jon Masters <jcm@redhat.com>, "patches@apm.com" <patches@apm.com>, Tuan Phan <tphan@apm.com>, Suman Tripathi <stripathi@apm.com>

--pZs/OQEoSSbxGlYw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 28, 2014 at 04:12:02PM -0700, Loc Ho wrote:
> Hi Kishon/Felipe,
>=20
> > >> This patch adds support for the APM X-Gene SoC AHCI SATA host contro=
ller
> > >> driver. It requires the corresponding APM X-Gene SoC PHY driver. This
> > >> initial version only supports Gen3 speed.
> > >
> > > This version seems workable, thanks for the quick follow-up.
> > >
> > > The comment about Gen3 speed above reminds me that you took some
> > > shortcuts to get here and you removed support for some features
> > > as well as some bug workarounds in the process. I'm guessing some
> > > of them won't be necessary because they are only for prototype
> > > hardware or for early boot loader versions that don't yet set up
> > > the hardware right, but others actually need to come back.
> > >
> > > That is usually a good approach, but I'd also like to make sure we can
> > > deal with them nicely when you have to add them back later, and don't
> > > have to add ugly extensions to the DT binding to support the old dtb
> > > files.
> > >
> > > Can you list (also in the changelog) the parts of the driver that you
> > > have taken out for now and that you expect to add back at later
> > > stage? I think that would be helpful for perspective.
> > >
> >
> > Here is an list of patches that we will be preparing for once the
> > basic driver is completed. Do you want me to re-generate the patch
> > change log with this info?
> >
> > 1. Support for Gen1/Gen2/Gen3
> > Solution: The simplest solution is to have the PHY framework support
> > setting the desire speed. I had argued with the TI folks but they are
> > reluctant to add this function to the framework. They argued that this
> > is still not generic enough. I will start the discussion again later
> > on. The other possibility (but not sure if this is doable) is to have
> > the PHY init function to be smarter and do the necessary operation
> > assuming the underlying PHY is capable in detecting the link up speed.
> > I will need to check the spec of this.
>=20
>=20
> In order for the X-Gene SATA PHY to support SATA Gen1 and Gen2 speed,
> we need an method to instruct the underlying PHY driver to switch to
> an specified setting after link up. For this errata, Suman Tripathi
> had submitted the patch [1]. It is not possible to hide this within
> the PHY driver. Each instance of the PHY driver controls two ports. By
> calling the exit function and then init function, it will affect the
> other ports - which is not the correct behavior. At this point, we
> don't see any solution besides introduce an PHY framework function
> set_rate. Can you let us know if this solution is acceptable?
>=20
> [1] https://lkml.org/lkml/2014/4/18/491

that 'lane' argument isn't acceptable. If one PHY talks to two Links,
your PHY driver should register two providers, then the lane argument
can be ignored.

Rate can be reused for different things depending on the underlying Bus;
in case of USB, it could be for switching among
Superspeed10/Superspeed5Highspeed; or 1Gbit/100Mbit switch on Networking
interfaces; or Gen1/2/3 selection for PCI controllers and so on. The
only thing I can't find a way to abstract is that 'lane' argument which
isn't even specific to SATA, it's particular to how you guys wrote your
driver. Should you have one PHY per SATA link, you wouldn't have added
that 'lane' argument at all.

cheers

--=20
balbi

--pZs/OQEoSSbxGlYw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTXusYAAoJEIaOsuA1yqREZBoP/jmLJISjL0BuMykMfvJHVHhl
kyufGnZs7Q861jG5yzrqpxcZeyX51gZBMp/0/x5mNsvduugPvD2CI+gSRDMwGnV1
2XGt/bK+PfM40wkiCA06JmrwHE3hOraJr8ZBpzwzUtbzVQyVy3BYhqzOR6K5z9L5
K3dz93UIfXi7qUDeAsGBbbkUMbzT7nJh3V+0PrblV1ZFXMhS/VbaGV/7215ejV5t
kXCThHtPiWR0hFv5Eikw9NA2QiA7x31wi3hNfK2kgmQkNLcGaVIMhz8KiCEWin2x
tc5QCfInCg1gpWSV9rfekyV/UQFYWZl91i1CXQi2Wt9Ilu0ttH12nkZODvO+ve9D
wpfACDz3wY3YJE8ZFMjBe34H3+07lHrJJnNbp2+NG9uE06vmFVvWaml4r6iLJoBj
DJtWpMFnLgs3oiIr3B7P+FZThe42bUrIj6TjMeKrPFlJlDv6n5CrPINit5jH5ESg
9D8cuUBMqe9afVIXhQWVM1dxIOYw5Q3f+Elsxka1eQxffUKRObPuT+vpuzamXsyk
YR5bT2r34pjUN/cMQgqrlb3iMtRypEwThVnhNS5Bltes4Uph3x6BjWweXrawJOgb
biWRQGsftq4DwHxrwt3/WYyiAWHvMwPelfHRZdeYKL16BD0NuWsVD1nByWL9R6RH
wR/xUyegG9NK+eZGqxnP
=EvXF
-----END PGP SIGNATURE-----

--pZs/OQEoSSbxGlYw--

From: Arjan van de Ven <arjanv@redhat.com>
Subject: Re: [PATCH] 2.6.0 aic7xxx and aic79xx stale pci_device list entry
Date: Sun, 4 Jan 2004 11:04:48 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040104100448.GA2416@devserv.devel.redhat.com>
References: <1073076654.2048.19.camel@opiate> <1073120514.4429.0.camel@laptop.fenrus.com> <1282412704.1073168696@aslan.scsiguy.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tKW2IUtsqtDRztdT"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:52958 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S265151AbUADKFA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 4 Jan 2004 05:05:00 -0500
Content-Disposition: inline
In-Reply-To: <1282412704.1073168696@aslan.scsiguy.com>
List-Id: linux-scsi@vger.kernel.org
To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Cc: Eric Kerin <eric@bootseg.com>, linux-scsi@vger.kernel.org


--tKW2IUtsqtDRztdT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Jan 03, 2004 at 03:24:56PM -0700, Justin T. Gibbs wrote:
> > well in 2.6 modules are supposed to remain loaded even though no device
> > is found (since one can be hotplugged later) so that part of the driver
> > needs changing; other than that yes the driver needs to deregister
> > itself....
>=20
> Is this policy change documented somewhere?

Documentation/pci.txt has it (albeit not extremely explicit):

0. Structure of PCI drivers
~~~~~~~~~~~~~~~~~~~~~~~~~~
There exist two kinds of PCI drivers: new-style ones (which leave most of
probing for devices to the PCI layer and support online insertion and
removal of devices [thus supporting PCI, hot-pluggable PCI and CardBus in a
single driver]) <snip>

1. New-style drivers
~~~~~~~~~~~~~~~~~~~
The new-style drivers just call pci_register_driver during their
initialization with a pointer to a structure describing the driver (struct
pci_driver) which contains:
<snip>
        probe           Pointer to a probing function which gets called (du=
ring
                        execution of pci_register_driver for already existi=
ng
                        devices or later if a new device gets inserted) for=
 all
                        PCI devices which match the ID table and are not ha=
ndled
                        by the other drivers yet. This function gets passed=
 a
                        pointer to the pci_dev structure representing the d=
evice
                        and also which entry in the ID table did the device
                        match. It returns zero when the driver has accepted=
 the
                        device or an error code (negative number) otherwise.
                        This function always gets called from process conte=
xt,
                        so it can sleep.
<snip the rest>
-----------------

There are 2 reasons to work this way, and I would very much prefer the
adaptec drivers to behave like this:
1) PCI Hotplugging
2) Adding PCI ID's at runtime

While you may not care about 1), a lot of IHV/distros care about 2); eg if
Adaptec puts out a card that can be driven by aic79xx but with just a new P=
CI ID,
hardware vendors can just add the ID at runtime and have it work in the
(factory) installer etc but only *if the driver is loaded* ....

Greetings,
    Arjan van de Ven



--tKW2IUtsqtDRztdT
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE/9+U/xULwo51rQBIRAnVkAKCc0tv+/WD0ixpYcePbVeKbcjXwsgCgpOua
qqCLDPf1YZ4LnJ3aKGxW2aw=
=63Qu
-----END PGP SIGNATURE-----

--tKW2IUtsqtDRztdT--

From: Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: megaraid_sas: "FW in FAULT state!!", how to get more debug
 output? [BKO63661]
Date: Thu, 28 May 2015 07:24:43 -0500
Message-ID: <20150528122443.GI10210@google.com>
References: <robbat2-20140712T111727-002806026Z@orbis-terrarum.net>
 <CAErSpo5+=33byGqCjFCSfTpfKFtSAHRqYLzGF7yf5d18gEmWsQ@mail.gmail.com>
 <robbat2-20140712T215640-831385120Z@orbis-terrarum.net>
 <20150429172832.GB7888@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-pci-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150429172832.GB7888@google.com>
Sender: linux-pci-owner@vger.kernel.org
To: "Robin H. Johnson" <robbat2@gentoo.org>
Cc: Adam Radford <aradford@gmail.com>, Neela Syam Kolli <megaraidlinux@lsi.com>, " linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, arkadiusz.bubala@open-e.com, Matthew Garrett <matthew.garrett@nebula.com>, Kashyap Desai <kashyap.desai@avagotech.com>, Sumit Saxena <sumit.saxena@avagotech.com>, Uday Lingala <uday.lingala@avagotech.com>, megaraidlinux.pdl@avagotech.com, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, Jean Delvare <jdelvare@suse.de>, Myron Stowe <myron.stowe@redhat.com>
List-Id: linux-scsi@vger.kernel.org

[+cc Jean, Myron]

Hello megaraid maintainers,

Have you been able to take a look at this at all?  People have been
reporting this issue since 2012 on upstream, Debian, and Ubuntu, and
now we're getting reports on SLES.

My theory is that the Linux driver relies on some MegaRAID initializati=
on
done by the option ROM, and the bug happens when the BIOS doesn't execu=
te
the option ROM.

If that's correct, you should be able to reproduce it on any system by
booting Linux (v3.3 or later) without running the MegaRAID SAS 2208 opt=
ion
ROM (either by enabling a BIOS "fast boot" switch, or modifying the BIO=
S to
skip it).  If the Linux driver doesn't rely on the option ROM, you migh=
t
even be able to reproduce it by physically removing the option ROM from=
 the
MegaRAID.

Bjorn

On Wed, Apr 29, 2015 at 12:28:32PM -0500, Bjorn Helgaas wrote:
> [+cc linux-pci, linux-kernel, Kashyap, Sumit, Uday, megaraidlinux.pdl=
]
>=20
> On Sun, Jul 13, 2014 at 01:35:51AM +0000, Robin H. Johnson wrote:
> > On Sat, Jul 12, 2014 at 11:29:20AM -0600, Bjorn Helgaas wrote:
> > > Thanks for the report, Robin.
> > >=20
> > > https://bugzilla.kernel.org/show_bug.cgi?id=3D63661 bisected the =
problem
> > > to 3c076351c402 ("PCI: Rework ASPM disable code"), which appeared=
 in
> > > v3.3.  For starters, can you verify that, e.g., by building
> > > 69166fbf02c7 (the parent of 3c076351c402) to make sure that it wo=
rks,
> > > and building 3c076351c402 itself to make sure it fails?
> > >=20
> > > Assuming that's the case, please attach the complete dmesg and "l=
spci
> > > -vvxxx" output for both kernels to the bugzilla.  ASPM is a featu=
re
> > > that is configured on both ends of a PCIe link, so I want to see =
the
> > > lspci info for the whole system, not just the SAS adapters.
> > >=20
> > > It's not practical to revert 3c076351c402 now, so I'd also like t=
o see
> > > the same information for the newest possible kernel (if this is
> > > possible; I'm not clear on whether you can boot your system or no=
t) so
> > > we can figure out what needs to be changed.
> > TL;DR: FastBoot is leaving the MegaRaidSAS in a weird state, and it=
 fails to
> > start; Commit 3c076351c402 did make it worse, but I think we're rig=
ht that the
> > bug lies in the SAS code.
> >=20
> > Ok, I have done more testing on it (40+ boots), and I think we can =
show the
> > problem is somewhere in how the BIOS/EFI/ROM brings up the card in =
=46astBoot
> > more, or how it leaves the card.
>=20
> I attached your dmesg and lspci logs to
> https://bugzilla.kernel.org/show_bug.cgi?id=3D63661, thank you! =A0Yo=
u did
> a huge amount of excellent testing and analysis, and I'm sorry that w=
e
> haven't made progress using the results.
>=20
> I still think this is a megaraid_sas driver bug, but I don't have
> enough evidence to really point fingers.
>=20
> Based on your testing, before 3c076351c402 ("PCI: Rework ASPM disable
> code"), megaraid_sas worked reliably. =A0After 3c076351c402,
> megaraid_sas does not work reliably when BIOS Fast Boot is enabled.
>=20
> Fast Boot probably means we don't run the option ROM on the device.
> Your dmesg logs show that in the working case, BIOS has enabled the
> device. =A0In the failing case it has not. =A0They also show that whe=
n
> Fast Boot is enabled, there's a little less MTRR write-protect space,
> which I'm guessing is space that wasn't needed for shadowing option
> ROMs.
>=20
> I suspect megaraid_sas depends on something done by the option ROM,
> and that prior to 3c076351c402, Linux did something to ASPM that was
> enough to make megaraid_sas work.
>=20
> I attached a couple debug patches to
> https://bugzilla.kernel.org/show_bug.cgi?id=3D63661 that log all the
> ASPM configuration the PCI core does.  One applies to 69166fbf02c7
> (the pre-3c076351c402 commit), and the other applies to v4.1-rc1.
> Could you boot both of those with "pci=3Dearlydump" and attach the dm=
esg
> logs to the bugzilla?  If you boot with the BIOS CMOS reset settings
> (Fast Boot enabled and ASPM set to "BIOS"), I expect the 69166fbf02c7=
-
> based kernel to work, and the v4.1-rc1-based one to fail.
>=20
> > Full boot of the system was difficult on the 3.2 kernels, they didn=
't make it
> > to userspace for other stuff being too new. For testing, I compiled
> > CONFIG_MEGARAID_SAS=3Dy on 3.2, and =3Dm on 3.16-rc4; that way when=
 the initramfs &
> > userspace failed, the megaraid load was captured over IPMI serial.
> >=20
> > I've done a lot of the analysis below while capturing.
> >=20
> > I was going to be booting many times, so I flipped the 'Fast Boot'
> > option back to Disabled, so I could more easily get to the BIOS set=
tings
> > to change options while testing. When I did so, an accidental boot =
on a
> > kernel that previously failed suddenly worked, leading me to raise =
an
> > eyebrow, and this expanded my test matrix more.
> >=20
> > 3 kernels, 6 different BIOS config combinations (2x3) =3D 18 test c=
ases
> > Each configuration was booted at least twice; if the result of two =
boots was
> > not identical, I booted a third time and took the majority result.
> >=20
> > All kernels had no boot params involving PCI specified (none of pci=
=3D, pcie*=3D,
> > disable_msi*).
> >=20
> > Kernels:
> > K.1: Ubuntu's 3.16-rc4
> > K.2: 3.2-rc4 3c076351c402 - aspm merged
> > K.3: 3.2-rc4 69166fbf02c7 - aspm merge parent
> > Notes: 3.2* compiled with GCC4.6, 3.16-rc4 with GCC4.8
> >=20
> > BIOS: Boot -> FastBoot:
> > B1.1 Off
> > B1.2 On (CMOS reset default)
> >=20
> > BIOS: Advanced -> PCIe/PCI/PnP Configuration -> ASPM Support
> > B2.1 Force L0s
> > B2.2 BIOS (CMOS reset default)
> > B2.3 Disabled
> >=20
> > Reduced Kernaugh Map of results:
> > Kernels,B1,B2:   Result
> >   *, B1.1,    *  PASS
> >   *, B1.2, B2.1  VARIABLE (9 runs: 5 fail, 4 pass, no kernel consis=
tency)
> > K.1, B1.2, B2.2  FAIL
> > K.1, B1.2, B2.3  FAIL
> > K.2, B1.2, B2.2  FAIL
> > K.2, B1.2, B2.3  FAIL
> > K.3, B1.2, B2.2  PASS
> > K.3, B1.2, B2.3  PASS
>=20
> I'm not very practiced with Karnaugh maps, so correct me if my
> understanding is wrong:
>=20
>   - Fast Boot disabled: all kernels always passed
>=20
>   - Fast Boot enabled, ASPM set to Force L0s enabled: variable; no
>     consistency of results
>=20
>   - Fast Boot enabled, ASPM set to BIOS or Disabled: pre-3c076351c402
>     always passed, post-3c076351c402 always failed
>=20
> Bjorn

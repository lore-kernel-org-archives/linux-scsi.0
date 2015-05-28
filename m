From: Kashyap Desai <kashyap.desai@avagotech.com>
Subject: RE: megaraid_sas: "FW in FAULT state!!", how to get more debug
 output? [BKO63661]
Date: Thu, 28 May 2015 19:05:35 +0530
Message-ID: <9e8b957da24d7b1f532ed83ffb86ca37@mail.gmail.com>
References: <robbat2-20140712T111727-002806026Z@orbis-terrarum.net>
 <CAErSpo5+=33byGqCjFCSfTpfKFtSAHRqYLzGF7yf5d18gEmWsQ@mail.gmail.com>
 <robbat2-20140712T215640-831385120Z@orbis-terrarum.net> <20150429172832.GB7888@google.com>
 <20150528122443.GI10210@google.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=001a11341b465b4f100517246f1c
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <20150528122443.GI10210@google.com>
Sender: linux-pci-owner@vger.kernel.org
To: Bjorn Helgaas <bhelgaas@google.com>, "Robin H. Johnson" <robbat2@gentoo.org>
Cc: Adam Radford <aradford@gmail.com>, Neela Syam Kolli <megaraidlinux@lsi.com>, linux-scsi@vger.kernel.org, arkadiusz.bubala@open-e.com, Matthew Garrett <matthew.garrett@nebula.com>, Sumit Saxena <sumit.saxena@avagotech.com>, Uday Lingala <uday.lingala@avagotech.com>, "PDL,MEGARAIDLINUX" <megaraidlinux.pdl@avagotech.com>, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, Jean Delvare <jdelvare@suse.de>, Myron Stowe <myron.stowe@redhat.com>
List-Id: linux-scsi@vger.kernel.org

--001a11341b465b4f100517246f1c
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Bjorn/Robin,

Apologies for delay. Here is one quick suggestion as we have seen similar
issue (not exactly similar, but high probably to have same issue) while
controller is configured on VM as pass-through and VM reboot abruptly.
In that particular issue, driver interact with FW which may  require chip
reset to bring controller to operation state.

Relevant patch was submitted for only Older controller as it was only seen
for few MegaRaid controller. Below patch already try to do chip reset, but
only for limited controllers...I have attached one more patch which does
chip reset from driver load time for Thunderbolt/Invader/Fury etc. (In
your case you have Thunderbolt controller, so attached patch is required.)

http://www.spinics.net/lists/linux-scsi/msg67288.html

Please post the result with attached patch.

Thanks, Kashyap

> -----Original Message-----
> From: Bjorn Helgaas [mailto:bhelgaas@google.com]
> Sent: Thursday, May 28, 2015 5:55 PM
> To: Robin H. Johnson
> Cc: Adam Radford; Neela Syam Kolli; linux-scsi@vger.kernel.org;
> arkadiusz.bubala@open-e.com; Matthew Garrett; Kashyap Desai; Sumit
Saxena;
> Uday Lingala; megaraidlinux.pdl@avagotech.com;
linux-pci@vger.kernel.org;
> linux-kernel@vger.kernel.org; Jean Delvare; Myron Stowe
> Subject: Re: megaraid_sas: "FW in FAULT state!!", how to get more debug
> output? [BKO63661]
>
> [+cc Jean, Myron]
>
> Hello megaraid maintainers,
>
> Have you been able to take a look at this at all?  People have been
reporting this
> issue since 2012 on upstream, Debian, and Ubuntu, and now we're getting
> reports on SLES.
>
> My theory is that the Linux driver relies on some MegaRAID
initialization done by
> the option ROM, and the bug happens when the BIOS doesn't execute the
option
> ROM.
>
> If that's correct, you should be able to reproduce it on any system by
booting
> Linux (v3.3 or later) without running the MegaRAID SAS 2208 option ROM
(either
> by enabling a BIOS "fast boot" switch, or modifying the BIOS to skip
it).  If the
> Linux driver doesn't rely on the option ROM, you might even be able to
> reproduce it by physically removing the option ROM from the MegaRAID.
>
> Bjorn
>
> On Wed, Apr 29, 2015 at 12:28:32PM -0500, Bjorn Helgaas wrote:
> > [+cc linux-pci, linux-kernel, Kashyap, Sumit, Uday, megaraidlinux.pdl]
> >
> > On Sun, Jul 13, 2014 at 01:35:51AM +0000, Robin H. Johnson wrote:
> > > On Sat, Jul 12, 2014 at 11:29:20AM -0600, Bjorn Helgaas wrote:
> > > > Thanks for the report, Robin.
> > > >
> > > > https://bugzilla.kernel.org/show_bug.cgi?id=3D63661 bisected the
> > > > problem to 3c076351c402 ("PCI: Rework ASPM disable code"), which
> > > > appeared in v3.3.  For starters, can you verify that, e.g., by
> > > > building
> > > > 69166fbf02c7 (the parent of 3c076351c402) to make sure that it
> > > > works, and building 3c076351c402 itself to make sure it fails?
> > > >
> > > > Assuming that's the case, please attach the complete dmesg and
> > > > "lspci -vvxxx" output for both kernels to the bugzilla.  ASPM is a
> > > > feature that is configured on both ends of a PCIe link, so I want
> > > > to see the lspci info for the whole system, not just the SAS
adapters.
> > > >
> > > > It's not practical to revert 3c076351c402 now, so I'd also like to
> > > > see the same information for the newest possible kernel (if this
> > > > is possible; I'm not clear on whether you can boot your system or
> > > > not) so we can figure out what needs to be changed.
> > > TL;DR: FastBoot is leaving the MegaRaidSAS in a weird state, and it
> > > fails to start; Commit 3c076351c402 did make it worse, but I think
> > > we're right that the bug lies in the SAS code.
> > >
> > > Ok, I have done more testing on it (40+ boots), and I think we can
> > > show the problem is somewhere in how the BIOS/EFI/ROM brings up the
> > > card in FastBoot more, or how it leaves the card.
> >
> > I attached your dmesg and lspci logs to
> > https://bugzilla.kernel.org/show_bug.cgi?id=3D63661, thank you! =C2=A0Y=
ou did
> > a huge amount of excellent testing and analysis, and I'm sorry that we
> > haven't made progress using the results.
> >
> > I still think this is a megaraid_sas driver bug, but I don't have
> > enough evidence to really point fingers.
> >
> > Based on your testing, before 3c076351c402 ("PCI: Rework ASPM disable
> > code"), megaraid_sas worked reliably. =C2=A0After 3c076351c402,
> > megaraid_sas does not work reliably when BIOS Fast Boot is enabled.
> >
> > Fast Boot probably means we don't run the option ROM on the device.
> > Your dmesg logs show that in the working case, BIOS has enabled the
> > device. =C2=A0In the failing case it has not. =C2=A0They also show that=
 when
> > Fast Boot is enabled, there's a little less MTRR write-protect space,
> > which I'm guessing is space that wasn't needed for shadowing option
> > ROMs.
> >
> > I suspect megaraid_sas depends on something done by the option ROM,
> > and that prior to 3c076351c402, Linux did something to ASPM that was
> > enough to make megaraid_sas work.
> >
> > I attached a couple debug patches to
> > https://bugzilla.kernel.org/show_bug.cgi?id=3D63661 that log all the
> > ASPM configuration the PCI core does.  One applies to 69166fbf02c7
> > (the pre-3c076351c402 commit), and the other applies to v4.1-rc1.
> > Could you boot both of those with "pci=3Dearlydump" and attach the dmes=
g
> > logs to the bugzilla?  If you boot with the BIOS CMOS reset settings
> > (Fast Boot enabled and ASPM set to "BIOS"), I expect the 69166fbf02c7-
> > based kernel to work, and the v4.1-rc1-based one to fail.
> >
> > > Full boot of the system was difficult on the 3.2 kernels, they
> > > didn't make it to userspace for other stuff being too new. For
> > > testing, I compiled CONFIG_MEGARAID_SAS=3Dy on 3.2, and =3Dm on
> > > 3.16-rc4; that way when the initramfs & userspace failed, the
megaraid load
> was captured over IPMI serial.
> > >
> > > I've done a lot of the analysis below while capturing.
> > >
> > > I was going to be booting many times, so I flipped the 'Fast Boot'
> > > option back to Disabled, so I could more easily get to the BIOS
> > > settings to change options while testing. When I did so, an
> > > accidental boot on a kernel that previously failed suddenly worked,
> > > leading me to raise an eyebrow, and this expanded my test matrix
more.
> > >
> > > 3 kernels, 6 different BIOS config combinations (2x3) =3D 18 test
> > > cases Each configuration was booted at least twice; if the result of
> > > two boots was not identical, I booted a third time and took the
majority
> result.
> > >
> > > All kernels had no boot params involving PCI specified (none of
> > > pci=3D, pcie*=3D, disable_msi*).
> > >
> > > Kernels:
> > > K.1: Ubuntu's 3.16-rc4
> > > K.2: 3.2-rc4 3c076351c402 - aspm merged
> > > K.3: 3.2-rc4 69166fbf02c7 - aspm merge parent
> > > Notes: 3.2* compiled with GCC4.6, 3.16-rc4 with GCC4.8
> > >
> > > BIOS: Boot -> FastBoot:
> > > B1.1 Off
> > > B1.2 On (CMOS reset default)
> > >
> > > BIOS: Advanced -> PCIe/PCI/PnP Configuration -> ASPM Support
> > > B2.1 Force L0s
> > > B2.2 BIOS (CMOS reset default)
> > > B2.3 Disabled
> > >
> > > Reduced Kernaugh Map of results:
> > > Kernels,B1,B2:   Result
> > >   *, B1.1,    *  PASS
> > >   *, B1.2, B2.1  VARIABLE (9 runs: 5 fail, 4 pass, no kernel
> > > consistency) K.1, B1.2, B2.2  FAIL K.1, B1.2, B2.3  FAIL K.2, B1.2,
> > > B2.2  FAIL K.2, B1.2, B2.3  FAIL K.3, B1.2, B2.2  PASS K.3, B1.2,
> > > B2.3  PASS
> >
> > I'm not very practiced with Karnaugh maps, so correct me if my
> > understanding is wrong:
> >
> >   - Fast Boot disabled: all kernels always passed
> >
> >   - Fast Boot enabled, ASPM set to Force L0s enabled: variable; no
> >     consistency of results
> >
> >   - Fast Boot enabled, ASPM set to BIOS or Disabled: pre-3c076351c402
> >     always passed, post-3c076351c402 always failed
> >
> > Bjorn

--001a11341b465b4f100517246f1c
Content-Type: application/octet-stream; name="fastboot_1.patch"
Content-Disposition: attachment; filename="fastboot_1.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: 252c942ef8670855_0.1

ZGlmZiAtYXVycCBtZWdhcmFpZC9tZWdhcmFpZF9zYXMuaCBtZWdhcmFpZF91MS9tZWdhcmFpZF9z
YXMuaAotLS0gbWVnYXJhaWQvbWVnYXJhaWRfc2FzLmgJMjAxNS0wNS0yOCAyMzo1NjoxNC42MTE3
NjgxNTYgKzA1MzAKKysrIG1lZ2FyYWlkX3UxL21lZ2FyYWlkX3Nhcy5oCTIwMTUtMDUtMjkgMDA6
MDY6MDEuMjU5NzY4MTU2ICswNTMwCkBAIC0zMyw3ICszMyw3IEBACiAvKgogICogTWVnYVJBSUQg
U0FTIERyaXZlciBtZXRhIGRhdGEKICAqLwotI2RlZmluZSBNRUdBU0FTX1ZFUlNJT04JCQkJIjA2
LjgwMy4wMS4wMC1yYzEiCisjZGVmaW5lIE1FR0FTQVNfVkVSU0lPTgkJCQkiMDYuODAzLjAxLjEx
LXJjMSIKICNkZWZpbmUgTUVHQVNBU19SRUxEQVRFCQkJCSJNYXIuIDEwLCAyMDE0IgogI2RlZmlu
ZSBNRUdBU0FTX0VYVF9WRVJTSU9OCQkJIk1vbi4gTWFyLiAxMCAxNzowMDowMCBQRFQgMjAxNCIK
IApPbmx5IGluIG1lZ2FyYWlkX3UxLzogbWVnYXJhaWRfc2FzLm1vZC5jCmRpZmYgLWF1cnAgbWVn
YXJhaWQvbWVnYXJhaWRfc2FzX2Z1c2lvbi5jIG1lZ2FyYWlkX3UxL21lZ2FyYWlkX3Nhc19mdXNp
b24uYwotLS0gbWVnYXJhaWQvbWVnYXJhaWRfc2FzX2Z1c2lvbi5jCTIwMTUtMDUtMjggMjM6NTY6
MTQuNjE5NzY4MTU2ICswNTMwCisrKyBtZWdhcmFpZF91MS9tZWdhcmFpZF9zYXNfZnVzaW9uLmMJ
MjAxNS0wNS0yOSAwMDoxNjowMi4xNzk3NjgxNTYgKzA1MzAKQEAgLTIyMDgsNiArMjIwOCw4OSBA
QCBzdGF0aWMgaW50CiBtZWdhc2FzX2FkcF9yZXNldF9mdXNpb24oc3RydWN0IG1lZ2FzYXNfaW5z
dGFuY2UgKmluc3RhbmNlLAogCQkJIHN0cnVjdCBtZWdhc2FzX3JlZ2lzdGVyX3NldCBfX2lvbWVt
ICpyZWdzKQogeworCXUzMiBob3N0X2RpYWcsIGFic19zdGF0ZSwgcmV0cnk7CisKKwkKKwlkZXZf
aW5mbygmaW5zdGFuY2UtPnBkZXYtPmRldiwgIkVudGVyZWQgaW50byAlcyAlZCBcbiIsIF9fZnVu
Y19fLCBfX0xJTkVfXyk7CisKKwl3cml0ZWwoTVBJMl9XUlNFUV9GTFVTSF9LRVlfVkFMVUUsCisJ
ICAgICAgICZpbnN0YW5jZS0+cmVnX3NldC0+ZnVzaW9uX3NlcV9vZmZzZXQpOworCXdyaXRlbChN
UEkyX1dSU0VRXzFTVF9LRVlfVkFMVUUsCisJICAgICAgICZpbnN0YW5jZS0+cmVnX3NldC0+ZnVz
aW9uX3NlcV9vZmZzZXQpOworCXdyaXRlbChNUEkyX1dSU0VRXzJORF9LRVlfVkFMVUUsCisJICAg
ICAgICZpbnN0YW5jZS0+cmVnX3NldC0+ZnVzaW9uX3NlcV9vZmZzZXQpOworCXdyaXRlbChNUEky
X1dSU0VRXzNSRF9LRVlfVkFMVUUsCisJICAgICAgICZpbnN0YW5jZS0+cmVnX3NldC0+ZnVzaW9u
X3NlcV9vZmZzZXQpOworCXdyaXRlbChNUEkyX1dSU0VRXzRUSF9LRVlfVkFMVUUsCisJICAgICAg
ICZpbnN0YW5jZS0+cmVnX3NldC0+ZnVzaW9uX3NlcV9vZmZzZXQpOworCXdyaXRlbChNUEkyX1dS
U0VRXzVUSF9LRVlfVkFMVUUsCisJICAgICAgICZpbnN0YW5jZS0+cmVnX3NldC0+ZnVzaW9uX3Nl
cV9vZmZzZXQpOworCXdyaXRlbChNUEkyX1dSU0VRXzZUSF9LRVlfVkFMVUUsCisJICAgICAgICZp
bnN0YW5jZS0+cmVnX3NldC0+ZnVzaW9uX3NlcV9vZmZzZXQpOworCisJLyogQ2hlY2sgdGhhdCB0
aGUgZGlhZyB3cml0ZSBlbmFibGUgKERSV0UpIGJpdCBpcyBvbiAqLworCWhvc3RfZGlhZyA9IHJl
YWRsKCZpbnN0YW5jZS0+cmVnX3NldC0+ZnVzaW9uX2hvc3RfZGlhZyk7CisJcmV0cnkgPSAwOwor
CXdoaWxlICghKGhvc3RfZGlhZyAmIEhPU1RfRElBR19XUklURV9FTkFCTEUpKSB7CisJCW1zbGVl
cCgxMDApOworCQlob3N0X2RpYWcgPQorCQlyZWFkbCgmaW5zdGFuY2UtPnJlZ19zZXQtPmZ1c2lv
bl9ob3N0X2RpYWcpOworCQlpZiAocmV0cnkrKyA9PSAxMDApIHsKKwkJCXByaW50ayhLRVJOX1dB
Uk5JTkcgIm1lZ2FyYWlkX3NhczogIgorCQkJICAgICAgICJIb3N0IGRpYWcgdW5sb2NrIGZhaWxl
ZCEgIgorCQkJICAgICAgICJmb3Igc2NzaSVkXG4iLAorCQkJCWluc3RhbmNlLT5ob3N0LT5ob3N0
X25vKTsKKwkJCWJyZWFrOworCQl9CisJfQorCWlmICghKGhvc3RfZGlhZyAmIEhPU1RfRElBR19X
UklURV9FTkFCTEUpKQorCQlyZXR1cm4gLTE7CisKKwkvKiBTZW5kIGNoaXAgcmVzZXQgY29tbWFu
ZCAqLworCXdyaXRlbChob3N0X2RpYWcgfCBIT1NUX0RJQUdfUkVTRVRfQURBUFRFUiwKKwkgICAg
ICAgJmluc3RhbmNlLT5yZWdfc2V0LT5mdXNpb25faG9zdF9kaWFnKTsKKwltc2xlZXAoMzAwMCk7
CisKKwkvKiBNYWtlIHN1cmUgcmVzZXQgYWRhcHRlciBiaXQgaXMgY2xlYXJlZCAqLworCWhvc3Rf
ZGlhZyA9IHJlYWRsKCZpbnN0YW5jZS0+cmVnX3NldC0+ZnVzaW9uX2hvc3RfZGlhZyk7CisJcmV0
cnkgPSAwOworCXdoaWxlIChob3N0X2RpYWcgJiBIT1NUX0RJQUdfUkVTRVRfQURBUFRFUikgewor
CQltc2xlZXAoMTAwKTsKKwkJaG9zdF9kaWFnID0KKwkJcmVhZGwoJmluc3RhbmNlLT5yZWdfc2V0
LT5mdXNpb25faG9zdF9kaWFnKTsKKwkJaWYgKHJldHJ5KysgPT0gMTAwMCkgeworCQkJcHJpbnRr
KEtFUk5fV0FSTklORyAibWVnYXJhaWRfc2FzOiAiCisJCQkgICAgICAgIkRpYWcgcmVzZXQgYWRh
cHRlciBuZXZlciAiCisJCQkgICAgICAgImNsZWFyZWQgZm9yIHNjc2klZCFcbiIsCisJCQkJaW5z
dGFuY2UtPmhvc3QtPmhvc3Rfbm8pOworCQkJYnJlYWs7CisJCX0KKwl9CisJaWYgKGhvc3RfZGlh
ZyAmIEhPU1RfRElBR19SRVNFVF9BREFQVEVSKQorCQlyZXR1cm4gLTE7CisKKwlhYnNfc3RhdGUg
PQorCQlpbnN0YW5jZS0+aW5zdGFuY2V0LT5yZWFkX2Z3X3N0YXR1c19yZWcoCisJCQlpbnN0YW5j
ZS0+cmVnX3NldCkgJiBNRklfU1RBVEVfTUFTSzsKKwlyZXRyeSA9IDA7CisKKwl3aGlsZSAoKGFi
c19zdGF0ZSA8PSBNRklfU1RBVEVfRldfSU5JVCkgJiYKKwkgICAgICAgKHJldHJ5KysgPCAxMDAw
KSkgeworCQltc2xlZXAoMTAwKTsKKwkJYWJzX3N0YXRlID0KKwkJaW5zdGFuY2UtPmluc3RhbmNl
dC0+cmVhZF9md19zdGF0dXNfcmVnKAorCQkJaW5zdGFuY2UtPnJlZ19zZXQpICYgTUZJX1NUQVRF
X01BU0s7CisJfQorCWlmIChhYnNfc3RhdGUgPD0gTUZJX1NUQVRFX0ZXX0lOSVQpIHsKKwkJcHJp
bnRrKEtFUk5fV0FSTklORyAibWVnYXJhaWRfc2FzOiBmaXJtd2FyZSAiCisJCSAgICAgICAic3Rh
dGUgPCBNRklfU1RBVEVfRldfSU5JVCwgc3RhdGUgPSAiCisJCSAgICAgICAiMHgleCBmb3Igc2Nz
aSVkXG4iLCBhYnNfc3RhdGUsCisJCQlpbnN0YW5jZS0+aG9zdC0+aG9zdF9ubyk7CisJCXJldHVy
biAtMTsKKwl9CisKKwlkZXZfaW5mbygmaW5zdGFuY2UtPnBkZXYtPmRldiwgIkV4aXQgZnJvbSAl
cyAlZCBcbiIsIF9fZnVuY19fLCBfX0xJTkVfXyk7CisKIAlyZXR1cm4gMDsKIH0KIApAQCAtMjMz
NiwxMyArMjQxOSwxMyBAQCBvdXQ6CiAvKiBDb3JlIGZ1c2lvbiByZXNldCBmdW5jdGlvbiAqLwog
aW50IG1lZ2FzYXNfcmVzZXRfZnVzaW9uKHN0cnVjdCBTY3NpX0hvc3QgKnNob3N0LCBpbnQgaW90
aW1lb3V0KQogewotCWludCByZXR2YWwgPSBTVUNDRVNTLCBpLCBqLCByZXRyeSA9IDAsIGNvbnZl
cnQgPSAwOworCWludCByZXR2YWwgPSBTVUNDRVNTLCBpLCBqLCBjb252ZXJ0ID0gMDsKIAlzdHJ1
Y3QgbWVnYXNhc19pbnN0YW5jZSAqaW5zdGFuY2U7CiAJc3RydWN0IG1lZ2FzYXNfY21kX2Z1c2lv
biAqY21kX2Z1c2lvbjsKIAlzdHJ1Y3QgZnVzaW9uX2NvbnRleHQgKmZ1c2lvbjsKIAlzdHJ1Y3Qg
bWVnYXNhc19jbWQgKmNtZF9tZmk7CiAJdW5pb24gTUVHQVNBU19SRVFVRVNUX0RFU0NSSVBUT1Jf
VU5JT04gKnJlcV9kZXNjOwotCXUzMiBob3N0X2RpYWcsIGFic19zdGF0ZSwgc3RhdHVzX3JlZywg
cmVzZXRfYWRhcHRlcjsKKwl1MzIgYWJzX3N0YXRlLCBzdGF0dXNfcmVnLCByZXNldF9hZGFwdGVy
OwogCiAJaW5zdGFuY2UgPSAoc3RydWN0IG1lZ2FzYXNfaW5zdGFuY2UgKilzaG9zdC0+aG9zdGRh
dGE7CiAJZnVzaW9uID0gaW5zdGFuY2UtPmN0cmxfY29udGV4dDsKQEAgLTI0NTcsODEgKzI1NDAs
MTAgQEAgaW50IG1lZ2FzYXNfcmVzZXRfZnVzaW9uKHN0cnVjdCBTY3NpX0hvcwogCiAJCS8qIE5v
dyB0cnkgdG8gcmVzZXQgdGhlIGNoaXAgKi8KIAkJZm9yIChpID0gMDsgaSA8IE1FR0FTQVNfRlVT
SU9OX01BWF9SRVNFVF9UUklFUzsgaSsrKSB7Ci0JCQl3cml0ZWwoTVBJMl9XUlNFUV9GTFVTSF9L
RVlfVkFMVUUsCi0JCQkgICAgICAgJmluc3RhbmNlLT5yZWdfc2V0LT5mdXNpb25fc2VxX29mZnNl
dCk7Ci0JCQl3cml0ZWwoTVBJMl9XUlNFUV8xU1RfS0VZX1ZBTFVFLAotCQkJICAgICAgICZpbnN0
YW5jZS0+cmVnX3NldC0+ZnVzaW9uX3NlcV9vZmZzZXQpOwotCQkJd3JpdGVsKE1QSTJfV1JTRVFf
Mk5EX0tFWV9WQUxVRSwKLQkJCSAgICAgICAmaW5zdGFuY2UtPnJlZ19zZXQtPmZ1c2lvbl9zZXFf
b2Zmc2V0KTsKLQkJCXdyaXRlbChNUEkyX1dSU0VRXzNSRF9LRVlfVkFMVUUsCi0JCQkgICAgICAg
Jmluc3RhbmNlLT5yZWdfc2V0LT5mdXNpb25fc2VxX29mZnNldCk7Ci0JCQl3cml0ZWwoTVBJMl9X
UlNFUV80VEhfS0VZX1ZBTFVFLAotCQkJICAgICAgICZpbnN0YW5jZS0+cmVnX3NldC0+ZnVzaW9u
X3NlcV9vZmZzZXQpOwotCQkJd3JpdGVsKE1QSTJfV1JTRVFfNVRIX0tFWV9WQUxVRSwKLQkJCSAg
ICAgICAmaW5zdGFuY2UtPnJlZ19zZXQtPmZ1c2lvbl9zZXFfb2Zmc2V0KTsKLQkJCXdyaXRlbChN
UEkyX1dSU0VRXzZUSF9LRVlfVkFMVUUsCi0JCQkgICAgICAgJmluc3RhbmNlLT5yZWdfc2V0LT5m
dXNpb25fc2VxX29mZnNldCk7Ci0KLQkJCS8qIENoZWNrIHRoYXQgdGhlIGRpYWcgd3JpdGUgZW5h
YmxlIChEUldFKSBiaXQgaXMgb24gKi8KLQkJCWhvc3RfZGlhZyA9IHJlYWRsKCZpbnN0YW5jZS0+
cmVnX3NldC0+ZnVzaW9uX2hvc3RfZGlhZyk7Ci0JCQlyZXRyeSA9IDA7Ci0JCQl3aGlsZSAoISho
b3N0X2RpYWcgJiBIT1NUX0RJQUdfV1JJVEVfRU5BQkxFKSkgewotCQkJCW1zbGVlcCgxMDApOwot
CQkJCWhvc3RfZGlhZyA9Ci0JCQkJcmVhZGwoJmluc3RhbmNlLT5yZWdfc2V0LT5mdXNpb25faG9z
dF9kaWFnKTsKLQkJCQlpZiAocmV0cnkrKyA9PSAxMDApIHsKLQkJCQkJcHJpbnRrKEtFUk5fV0FS
TklORyAibWVnYXJhaWRfc2FzOiAiCi0JCQkJCSAgICAgICAiSG9zdCBkaWFnIHVubG9jayBmYWls
ZWQhICIKLQkJCQkJICAgICAgICJmb3Igc2NzaSVkXG4iLAotCQkJCQkJaW5zdGFuY2UtPmhvc3Qt
Pmhvc3Rfbm8pOwotCQkJCQlicmVhazsKLQkJCQl9Ci0JCQl9Ci0JCQlpZiAoIShob3N0X2RpYWcg
JiBIT1NUX0RJQUdfV1JJVEVfRU5BQkxFKSkKLQkJCQljb250aW51ZTsKLQotCQkJLyogU2VuZCBj
aGlwIHJlc2V0IGNvbW1hbmQgKi8KLQkJCXdyaXRlbChob3N0X2RpYWcgfCBIT1NUX0RJQUdfUkVT
RVRfQURBUFRFUiwKLQkJCSAgICAgICAmaW5zdGFuY2UtPnJlZ19zZXQtPmZ1c2lvbl9ob3N0X2Rp
YWcpOwotCQkJbXNsZWVwKDMwMDApOwotCi0JCQkvKiBNYWtlIHN1cmUgcmVzZXQgYWRhcHRlciBi
aXQgaXMgY2xlYXJlZCAqLwotCQkJaG9zdF9kaWFnID0gcmVhZGwoJmluc3RhbmNlLT5yZWdfc2V0
LT5mdXNpb25faG9zdF9kaWFnKTsKLQkJCXJldHJ5ID0gMDsKLQkJCXdoaWxlIChob3N0X2RpYWcg
JiBIT1NUX0RJQUdfUkVTRVRfQURBUFRFUikgewotCQkJCW1zbGVlcCgxMDApOwotCQkJCWhvc3Rf
ZGlhZyA9Ci0JCQkJcmVhZGwoJmluc3RhbmNlLT5yZWdfc2V0LT5mdXNpb25faG9zdF9kaWFnKTsK
LQkJCQlpZiAocmV0cnkrKyA9PSAxMDAwKSB7Ci0JCQkJCXByaW50ayhLRVJOX1dBUk5JTkcgIm1l
Z2FyYWlkX3NhczogIgotCQkJCQkgICAgICAgIkRpYWcgcmVzZXQgYWRhcHRlciBuZXZlciAiCi0J
CQkJCSAgICAgICAiY2xlYXJlZCBmb3Igc2NzaSVkIVxuIiwKLQkJCQkJCWluc3RhbmNlLT5ob3N0
LT5ob3N0X25vKTsKLQkJCQkJYnJlYWs7Ci0JCQkJfQotCQkJfQotCQkJaWYgKGhvc3RfZGlhZyAm
IEhPU1RfRElBR19SRVNFVF9BREFQVEVSKQotCQkJCWNvbnRpbnVlOwogCi0JCQlhYnNfc3RhdGUg
PQotCQkJCWluc3RhbmNlLT5pbnN0YW5jZXQtPnJlYWRfZndfc3RhdHVzX3JlZygKLQkJCQkJaW5z
dGFuY2UtPnJlZ19zZXQpICYgTUZJX1NUQVRFX01BU0s7Ci0JCQlyZXRyeSA9IDA7Ci0KLQkJCXdo
aWxlICgoYWJzX3N0YXRlIDw9IE1GSV9TVEFURV9GV19JTklUKSAmJgotCQkJICAgICAgIChyZXRy
eSsrIDwgMTAwMCkpIHsKLQkJCQltc2xlZXAoMTAwKTsKLQkJCQlhYnNfc3RhdGUgPQotCQkJCWlu
c3RhbmNlLT5pbnN0YW5jZXQtPnJlYWRfZndfc3RhdHVzX3JlZygKLQkJCQkJaW5zdGFuY2UtPnJl
Z19zZXQpICYgTUZJX1NUQVRFX01BU0s7Ci0JCQl9Ci0JCQlpZiAoYWJzX3N0YXRlIDw9IE1GSV9T
VEFURV9GV19JTklUKSB7Ci0JCQkJcHJpbnRrKEtFUk5fV0FSTklORyAibWVnYXJhaWRfc2FzOiBm
aXJtd2FyZSAiCi0JCQkJICAgICAgICJzdGF0ZSA8IE1GSV9TVEFURV9GV19JTklULCBzdGF0ZSA9
ICIKLQkJCQkgICAgICAgIjB4JXggZm9yIHNjc2klZFxuIiwgYWJzX3N0YXRlLAotCQkJCQlpbnN0
YW5jZS0+aG9zdC0+aG9zdF9ubyk7Ci0JCQkJY29udGludWU7Ci0JCQl9CisJCQlpZiAoaW5zdGFu
Y2UtPmluc3RhbmNldC0+YWRwX3Jlc2V0CisJCQkJKGluc3RhbmNlLCBpbnN0YW5jZS0+cmVnX3Nl
dCkpCisgCQkJCWNvbnRpbnVlOwogCiAJCQkvKiBXYWl0IGZvciBGVyB0byBiZWNvbWUgcmVhZHkg
Ki8KIAkJCWlmIChtZWdhc2FzX3RyYW5zaXRpb25fdG9fcmVhZHkoaW5zdGFuY2UsIDEpKSB7Cg==
--001a11341b465b4f100517246f1c--

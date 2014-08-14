From: Anil Gurumurthy <Anil.Gurumurthy@qlogic.com>
Subject: RE: [PATCH v2 RESEND 04/23] bfa: Use pci_enable_msix_exact()
 instead of pci_enable_msix()
Date: Thu, 14 Aug 2014 02:55:06 +0000
Message-ID: <20B1A3CBD98F3845B3F5F56D8597EF59FA1586@avmb2.qlogic.org>
References: <cover.1405533479.git.agordeev@redhat.com>
 <bc13ddf17d035921de994d2f8a52902e0a5d1a60.1405533479.git.agordeev@redhat.com>
 <20140811073902.GB16504@dhcp-27-160.brq.redhat.com>
 <20B1A3CBD98F3845B3F5F56D8597EF59FA0CF6@avmb2.qlogic.org>
 <20140812105014.GB1674@agordeev.usersys.redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="_000_20B1A3CBD98F3845B3F5F56D8597EF59FA1586avmb2qlogicorg_"
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <20140812105014.GB1674@agordeev.usersys.redhat.com>
Content-Language: en-US
Sender: linux-pci-owner@vger.kernel.org
To: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-pci <linux-pci@vger.kernel.org>, Sudarsana Kalluru <Sudarsana.Kalluru@qlogic.com>
List-Id: linux-scsi@vger.kernel.org

--_000_20B1A3CBD98F3845B3F5F56D8597EF59FA1586avmb2qlogicorg_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi Alexander,
  I believe I acked the series already, if not, I am acking all the bfa pat=
ches in this series.

Thanks,
Anil

-----Original Message-----
From: Alexander Gordeev [mailto:agordeev@redhat.com]=20
Sent: 12 August 2014 16:20
To: Anil Gurumurthy
Cc: linux-kernel; Anil Gurumurthy; Vijaya Mohan Guvva; linux-scsi; linux-pc=
i; Sudarsana Kalluru
Subject: Re: [PATCH v2 RESEND 04/23] bfa: Use pci_enable_msix_exact() inste=
ad of pci_enable_msix()

On Mon, Aug 11, 2014 at 11:02:56AM +0000, Anil Gurumurthy wrote:
> Acked-by: Anil Gurumurthy <anil.gurumurthy@qlogic.com>

Many thanks, Anil!

If your Ack apply to this patch only or to all three 'bfa' patches in this =
series?

Thanks!

> -----Original Message-----
> From: Alexander Gordeev [mailto:agordeev@redhat.com]
> Sent: 11 August 2014 13:09
> To: linux-kernel
> Cc: Anil Gurumurthy; Vijaya Mohan Guvva; linux-scsi; linux-pci; Anil=20
> Gurumurthy; Sudarsana Kalluru
> Subject: Re: [PATCH v2 RESEND 04/23] bfa: Use pci_enable_msix_exact()=20
> instead of pci_enable_msix()
>=20
> On Wed, Jul 16, 2014 at 08:05:08PM +0200, Alexander Gordeev wrote:
> > As result of deprecation of MSI-X/MSI enablement functions
> > pci_enable_msix() and pci_enable_msi_block() all drivers using these=20
> > two interfaces need to be updated to use the new
> > pci_enable_msi_range()  or pci_enable_msi_exact() and
> > pci_enable_msix_range() or pci_enable_msix_exact() interfaces.
>=20
> Anil, Sudarsana,
>=20
> Could you please review bfa patches in this series?
>=20
> Thanks!
>=20
> > Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
> > Cc: Anil Gurumurthy <agurumur@brocade.com>
> > Cc: Vijaya Mohan Guvva <vmohan@brocade.com>
> > Cc: linux-scsi@vger.kernel.org
> > Cc: linux-pci@vger.kernel.org
> > Acked-by: Anil Gurumurthy <anil.gurumurthy@qlogic.com>
> > ---
> >  drivers/scsi/bfa/bfad.c |   20 ++++++--------------
> >  1 files changed, 6 insertions(+), 14 deletions(-)
> >=20
> > diff --git a/drivers/scsi/bfa/bfad.c b/drivers/scsi/bfa/bfad.c index
> > c18279f..e90a374 100644
> > --- a/drivers/scsi/bfa/bfad.c
> > +++ b/drivers/scsi/bfa/bfad.c
> > @@ -1234,29 +1234,21 @@ bfad_setup_intr(struct bfad_s *bfad)
> >  	if ((bfa_asic_id_ctc(pdev->device) && !msix_disable_ct) ||
> >  	   (bfa_asic_id_cb(pdev->device) && !msix_disable_cb)) {
> > =20
> > -		error =3D pci_enable_msix(bfad->pcidev, msix_entries, bfad->nvec);
> > +		error =3D pci_enable_msix_exact(bfad->pcidev,
> > +					      msix_entries, bfad->nvec);
> >  		/* In CT1 & CT2, try to allocate just one vector */
> > -		if (error > 0 && bfa_asic_id_ctc(pdev->device)) {
> > +		if (error =3D=3D -ENOSPC && bfa_asic_id_ctc(pdev->device)) {
> >  			printk(KERN_WARNING "bfa %s: trying one msix "
> >  			       "vector failed to allocate %d[%d]\n",
> >  			       bfad->pci_name, bfad->nvec, error);
> >  			bfad->nvec =3D 1;
> > -			error =3D pci_enable_msix(bfad->pcidev,
> > -						msix_entries, bfad->nvec);
> > +			error =3D pci_enable_msix_exact(bfad->pcidev,
> > +						      msix_entries, 1);
> >  		}
> > =20
> > -		/*
> > -		 * Only error number of vector is available.
> > -		 * We don't have a mechanism to map multiple
> > -		 * interrupts into one vector, so even if we
> > -		 * can try to request less vectors, we don't
> > -		 * know how to associate interrupt events to
> > -		 *  vectors. Linux doesn't duplicate vectors
> > -		 * in the MSIX table for this case.
> > -		 */
> >  		if (error) {
> >  			printk(KERN_WARNING "bfad%d: "
> > -			       "pci_enable_msix failed (%d), "
> > +			       "pci_enable_msix_exact failed (%d), "
> >  			       "use line based.\n",
> >  				bfad->inst_no, error);
> >  			goto line_based;
> > --
> > 1.7.7.6
> >=20

--
Regards,
Alexander Gordeev
agordeev@redhat.com

--_000_20B1A3CBD98F3845B3F5F56D8597EF59FA1586avmb2qlogicorg_
Content-Disposition: attachment; filename="winmail.dat"
Content-Transfer-Encoding: base64
Content-Type: application/ms-tnef; name="winmail.dat"

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
bgBpAGwALgBHAHUAcgB1AG0AdQByAHQAaAB5AEAAcQBsAG8AZwBpAGMALgBjAG8AbQAAAB8AAl0B
AAAANgAAAEEAbgBpAGwALgBHAHUAcgB1AG0AdQByAHQAaAB5AEAAcQBsAG8AZwBpAGMALgBjAG8A
bQAAAAAAHwDlXwEAAAA+AAAAcwBpAHAAOgBhAG4AaQBsAC4AZwB1AHIAdQBtAHUAcgB0AGgAeQBA
AHEAbABvAGcAaQBjAC4AYwBvAG0AAAAAAB8AGgwBAAAAIAAAAEEAbgBpAGwAIABHAHUAcgB1AG0A
dQByAHQAaAB5AAAAHwAfDAEAAAA2AAAAQQBuAGkAbAAuAEcAdQByAHUAbQB1AHIAdABoAHkAQABx
AGwAbwBnAGkAYwAuAGMAbwBtAAAAAAAfAB4MAQAAAAoAAABTAE0AVABQAAAAAAACARkMAQAAAHgA
AAAAAAAAgSsfpL6jEBmdbgDdAQ9UAgAAAIBBAG4AaQBsACAARwB1AHIAdQBtAHUAcgB0AGgAeQAA
AFMATQBUAFAAAABBAG4AaQBsAC4ARwB1AHIAdQBtAHUAcgB0AGgAeQBAAHEAbABvAGcAaQBjAC4A
YwBvAG0AAAAfAAFdAQAAADYAAABBAG4AaQBsAC4ARwB1AHIAdQBtAHUAcgB0AGgAeQBAAHEAbABv
AGcAaQBjAC4AYwBvAG0AAAAAAB8A+D8BAAAAIAAAAEEAbgBpAGwAIABHAHUAcgB1AG0AdQByAHQA
aAB5AAAAHwAjQAEAAAA2AAAAQQBuAGkAbAAuAEcAdQByAHUAbQB1AHIAdABoAHkAQABxAGwAbwBn
AGkAYwAuAGMAbwBtAAAAAAAfACJAAQAAAAoAAABTAE0AVABQAAAAAAACAfk/AQAAAHgAAAAAAAAA
gSsfpL6jEBmdbgDdAQ9UAgAAAIBBAG4AaQBsACAARwB1AHIAdQBtAHUAcgB0AGgAeQAAAFMATQBU
AFAAAABBAG4AaQBsAC4ARwB1AHIAdQBtAHUAcgB0AGgAeQBAAHEAbABvAGcAaQBjAC4AYwBvAG0A
AAAfAAldAQAAADYAAABBAG4AaQBsAC4ARwB1AHIAdQBtAHUAcgB0AGgAeQBAAHEAbABvAGcAaQBj
AC4AYwBvAG0AAAAAAB8AMUABAAAAAgAAAAAAAAALAEA6AQAAAB8AMEABAAAAAgAAAAAAAAAfABoA
AQAAABIAAABJAFAATQAuAE4AbwB0AGUAAAAAAAMA8T8JBAAACwBAOgEAAAADAP0/5AQAAAIBCzAB
AAAAEAAAAPbwHjYoLrFLkm/HL1HpauUDABcAAQAAAEAAOQAA4fQma7fPAUAACDD+Hkgna7fPAQsA
KQAAAAAACwAjAAAAAAAfAACAhgMCAAAAAADAAAAAAAAARgEAAAAeAAAAYQBjAGMAZQBwAHQAbABh
AG4AZwB1AGEAZwBlAAAAAAABAAAADAAAAGUAbgAtAFUAUwAAAAsAAIAIIAYAAAAAAMAAAAAAAABG
AAAAAAaFAAAAAAAAHwA3AAEAAAC0AAAAUgBFADoAIABbAFAAQQBUAEMASAAgAHYAMgAgAFIARQBT
AEUATgBEACAAMAA0AC8AMgAzAF0AIABiAGYAYQA6ACAAVQBzAGUAIABwAGMAaQBfAGUAbgBhAGIA
bABlAF8AbQBzAGkAeABfAGUAeABhAGMAdAAoACkAIABpAG4AcwB0AGUAYQBkACAAbwBmACAAcABj
AGkAXwBlAG4AYQBiAGwAZQBfAG0AcwBpAHgAKAApAAAAHwA9AAEAAAAKAAAAUgBFADoAIAAAAAAA
AwA2AAAAAAADAC4AAAAAAB8AQhABAAAAaAAAADwAMgAwADEANAAwADgAMQAyADEAMAA1ADAAMQA0
AC4ARwBCADEANgA3ADQAQABhAGcAbwByAGQAZQBlAHYALgB1AHMAZQByAHMAeQBzAC4AcgBlAGQA
aABhAHQALgBjAG8AbQA+AAAAAgFxAAEAAAAqAAAAAQHPoSElBU1/NNORdUmpsXLfnYwbVJvLoboA
///DjKCAAgQ0AIACKaqgAAAfAHAAAQAAAKwAAABbAFAAQQBUAEMASAAgAHYAMgAgAFIARQBTAEUA
TgBEACAAMAA0AC8AMgAzAF0AIABiAGYAYQA6ACAAVQBzAGUAIABwAGMAaQBfAGUAbgBhAGIAbABl
AF8AbQBzAGkAeABfAGUAeABhAGMAdAAoACkAIABpAG4AcwB0AGUAYQBkACAAbwBmACAAcABjAGkA
XwBlAG4AYQBiAGwAZQBfAG0AcwBpAHgAKAApAAAAHwA1EAEAAAB0AAAAPAAyADAAQgAxAEEAMwBD
AEIARAA5ADgARgAzADgANAA1AEIAMwBGADUARgA1ADYARAA4ADUAOQA3AEUARgA1ADkARgBBADEA
NQA4ADYAQABhAHYAbQBiADIALgBxAGwAbwBnAGkAYwAuAG8AcgBnAD4AAAAfADkQAQAAADYCAAA8
AGMAbwB2AGUAcgAuADEANAAwADUANQAzADMANAA3ADkALgBnAGkAdAAuAGEAZwBvAHIAZABlAGUA
dgBAAHIAZQBkAGgAYQB0AC4AYwBvAG0APgAgADwAYgBjADEAMwBkAGQAZgAxADcAZAAwADMANQA5
ADIAMQBkAGUAOQA5ADQAZAAyAGYAOABhADUAMgA5ADAAMgBlADAAYQA1AGQAMQBhADYAMAAuADEA
NAAwADUANQAzADMANAA3ADkALgBnAGkAdAAuAGEAZwBvAHIAZABlAGUAdgBAAHIAZQBkAGgAYQB0
AC4AYwBvAG0APgAgADwAMgAwADEANAAwADgAMQAxADAANwAzADkAMAAyAC4ARwBCADEANgA1ADAA
NABAAGQAaABjAHAALQAyADcALQAxADYAMAAuAGIAcgBxAC4AcgBlAGQAaABhAHQALgBjAG8AbQA+
ACAAPAAyADAAQgAxAEEAMwBDAEIARAA5ADgARgAzADgANAA1AEIAMwBGADUARgA1ADYARAA4ADUA
OQA3AEUARgA1ADkARgBBADAAQwBGADYAQABhAHYAbQBiADIALgBxAGwAbwBnAGkAYwAuAG8AcgBn
AD4AIAA8ADIAMAAxADQAMAA4ADEAMgAxADAANQAwADEANAAuAEcAQgAxADYANwA0AEAAYQBnAG8A
cgBkAGUAZQB2AC4AdQBzAGUAcgBzAHkAcwAuAHIAZQBkAGgAYQB0AC4AYwBvAG0APgAAAAAAAwDe
P59OAAALAACACCAGAAAAAADAAAAAAAAARgAAAAADhQAAAAAAAAMAAIAIIAYAAAAAAMAAAAAAAABG
AAAAAAGFAAAAAAAAAwCAEP////9AAAcwPrclJmu3zwELAAIAAQAAAAMAJgAAAAAACwArAAAAAAAC
AUcAAQAAAC4AAABjPVVTO2E9IDtwPVFMb2dpYztsPUFWTUIyLTE0MDgxNDAyNTUwNlotNTM5NTUA
AAACARAwAQAAAEYAAAAAAAAApfa6WPiUnECXquZDOkRWvwcAILGjy9mPOEWz9fVthZfvWQAAAPSN
GAAAZwQxjMtxokilXd7HughfeQBLeqYXuwAAAAAfAPo/AQAAACAAAABBAG4AaQBsACAARwB1AHIA
dQBtAHUAcgB0AGgAeQAAAAMACVkBAAAAAwAAgAggBgAAAAAAwAAAAAAAAEYAAAAAEIUAAAAAAAAL
AACACCAGAAAAAADAAAAAAAAARgAAAAAOhQAAAAAAAAMAAIAIIAYAAAAAAMAAAAAAAABGAAAAABiF
AAAAAAAACwAAgAggBgAAAAAAwAAAAAAAAEYAAAAAgoUAAAAAAAAfAACACCAGAAAAAADAAAAAAAAA
RgAAAADYhQAAAQAAABIAAABJAFAATQAuAE4AbwB0AGUAAAAAAAMADTT9PwAAHwAAgIYDAgAAAAAA
wAAAAAAAAEYBAAAAIAAAAHgALQBtAHMALQBoAGEAcwAtAGEAdAB0AGEAYwBoAAAAAQAAAAIAAAAA
AAAAHwAAgIYDAgAAAAAAwAAAAAAAAEYBAAAAIgAAAHgALQBvAHIAaQBnAGkAbgBhAHQAaQBuAGcA
LQBpAHAAAAAAAAEAAAAYAAAAWwAxADAALgAxAC4ANAAuADEAMABdAAAAHwAAgIYDAgAAAAAAwAAA
AAAAAEYBAAAAFgAAAGQAaQBzAGMAbABhAGkAbQBlAHIAAAAAAAEAAAAOAAAAYgB5AHAAYQBzAHMA
AAAAACRk

--_000_20B1A3CBD98F3845B3F5F56D8597EF59FA1586avmb2qlogicorg_--

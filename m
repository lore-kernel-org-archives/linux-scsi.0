From: Pasi =?iso-8859-1?Q?K=E4rkk=E4inen?= <pasik@iki.fi>
Subject: Re: Odd behavior of a "SAS-2" backplane with SGPIO commands
Date: Sun, 19 Aug 2012 13:25:31 +0300
Message-ID: <20120819102531.GP19851@reaktio.net>
References: <CAOeNLuruup-22wAFgR0b+cPc0nCf_jUm0teDHB7DLnRmcHtTog@mail.gmail.com>
 <20120818235247.GO19851@reaktio.net>
 <CAOeNLuob_oq3HBV1w3W64hT4c1qSjE9xsm0_Az3+KTHnEN3QbQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.tele.fi ([192.89.123.25]:60546 "EHLO smtp.tele.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751287Ab2HSKZe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 19 Aug 2012 06:25:34 -0400
Content-Disposition: inline
In-Reply-To: <CAOeNLuob_oq3HBV1w3W64hT4c1qSjE9xsm0_Az3+KTHnEN3QbQ@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rich <rercola@pha.jhu.edu>
Cc: linux-scsi@vger.kernel.org

On Sat, Aug 18, 2012 at 08:10:27PM -0400, Rich wrote:
> I actually have a lot of information I can share about this since I
> wrote this email.
>

Great!
=20
> To be brief, the sas2ircu toolset works perfectly fine with IT mode
> HBAs - just not with passive backplanes AFAICS [e.g. the 846A, versus
> the 846EL2].
>=20

Ok. So with an expander backplane (846EL*) with SES, sas2ircu is able t=
o control leds?
"LOCATE" command works? I haven't been able to try those commands with =
SES backplanes=20
because in these systems I've been trying to avoid expanders :)


> Also, the bug I'm experiencing is not present with the SAS2308
> generation of the HBAs (the 9217 and friends) at the same F/W version
> as the 9211, so this may be a bug - on the controller chip, driver, o=
r
> HBA firmware.
>=20

That's good to know. Did you open any bug reports about the SAS2008/921=
1 SGPIO glitch?=20

Thanks,

-- Pasi

> - Rich
>=20
> On Sat, Aug 18, 2012 at 7:52 PM, Pasi K=E4rkk=E4inen <pasik@iki.fi> w=
rote:
> > On Tue, Jul 03, 2012 at 09:54:58PM -0400, Rich wrote:
> >> [My apologies if this is the wrong mailing list for this, but it
> >> seemed to be the most relevant. Please direct me elsewhere and dis=
card
> >> if this is OT.]
> >>
> >
> > This is a perfectly fine list, hopefully :)
> >
> >> Hi all,
> >>
> >
> > Hello,
> >
> >> I've been beating my head against SGPIO for a bit now, and I can't
> >> tell if I'm just misreading SFF-8485, or this backplane is just no=
t
> >> doing something sane.
> >>
> >
> > I've been struggling with SGPIO LED control aswell!
> >
> >> I have here a Supermicro X8DAH-F+ with a backplane of model
> >> BPN-SAS-836A - which means it has 3 MG9072 controller chips on it.
> >> Supports speaking in-band or out-of-band to read data, control lig=
hts,
> >> &c.
> >>
> >> With two LSI 9201-16i HBA attached, manipulating it via
> >> /dev/bsg/sas_hostN and smp_utils 0.97, SFF-8485 section 8.4.4 seem=
s to
> >> think that changing this:
> >>  00     41 02 00 00 a0 a0 a0 a0  a0 a0 a0 a0 a0 a0 a0 a0
> >>  10     a0 a0 a0 a0 00 00 00 00  00 00 00 00 00 00 00 00
> >>  20     00 00 00 00
> >>
> >> By doing this:
> >> # smp_write_gpio -d a1,a0,a0,a0 -t 3 -i 0 -c /dev/bsg/sas_hostN
> >>
> >> Resulting in:
> >>  00     41 02 00 00 a1 a0 a0 a0  a0 a0 a0 a0 a0 a0 a0 a0
> >>  10     a0 a0 a0 a0 00 00 00 00  00 00 00 00 00 00 00 00
> >>  20     00 00 00 00
> >>
> >> Should enable a single drive's fault LED (drive m+3, by spec above=
).
> >>
> >
> > Wow, I've been trying to figure out how to control SGPIO from Linux=
,
> > and for some reason I didn't find anything about smp_write_gpio ear=
lier.
> >
> > I need to try that. Thanks a lot for this information! :)
> >
> > (earlier I tried getting LSI sas2ircu to do something clever
> > with the LEDS but that didn't work at all - I guess LSI only suppor=
ts
> > SGPIO LED control in IR mode - not IT mode).
> >
> >
> >> In practice, I am in possession of ~90 identical machines, and on
> >> every single one, this controls the fault LED on 3 drives - I have=
 3
> >> SAS ports wired to the backplane (via iPASS cable) per HBA, so I w=
ould
> >> suspect the HBA of setting bit m+3 on each SAS port [and having ea=
ch
> >> of its three ports running to an input controlled by a different S=
GPIO
> >> controller on the backplane]. No permutation of the register bits
> >> beyond the 4 bytes at index 0 changes the behavior of the LEDs tha=
t I
> >> can see, and the output in the beginning [a0 a0 ... 00 00 00 00] i=
s
> >> what is returned on clean cold boot of the machine.
> >>
> >> In contrast, when I have an LSI 9240-8i attached, I can control
> >> per-drive LEDs, though the mechanism it uses for this is opaque to=
 me
> >> (the megaraid_sas driver doesn't expose a virtual SAS host port li=
ke
> >> mpt2sas, so I am manipulating this using LSI's closed-source MegaC=
li
> >> blob); so I know it is possible, through some method, to control
> >> per-drive LEDs.
> >>
> >> I cannot tell, however, whether I am using smp_write_gpio incorrec=
tly
> >> (either by misreading the spec or somehow abusing the virtual SAS
> >> port), or it's a bug somewhere (be it in smp_write_gpio, the kerne=
l,
> >> the HBA firmware, or the upstream MG9072's firmware, that is someh=
ow
> >> magically avoided by the 9240-8i), and there is almost no public
> >> documentation of people using smp_write_gpio.
> >>
> >> I've tried this with kernel 2.6.32-220.7.1.el6, 3.4.4, and 3.5.0-r=
c5
> >> (the last because it includes mpt2sas 13.XX.XX.XX, while 3.4.4 has
> >> 12.XX.XX.XX, and I was curious if anything had changed), and smp_u=
tils
> >> 0.97.
> >>
> >> I wanted to see what the register state was when the 9240-8i was i=
n
> >> use, but I couldn't coax the megaraid_sas driver into disgorging t=
his
> >> information, and upon unplugging the iPASS cable from the backplan=
e to
> >> connect it to the HBA, the backplane appears to reset its internal
> >> state; the LEDs cease blinking in any pattern, and consequent quer=
ying
> >> with the HBA returns expected default initial state.
> >>
> >> Am I insane, or is this backplane crazy? Does anyone have any
> >> experience with cajoling such things into submission?
> >>
> >
> > Hmm, I have some servers with LSI 9211-8i SAS2 HBAs (mpt2sas driver=
)
> > and Supermicro BPN-SAS-846A backplanes, which have 3x MG9072 chips =
in them.
> >
> > I'll let you know how that stuff works for me!
> >
> > Thanks,
> >
> > -- Pasi
> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Pasi =?iso-8859-1?Q?K=E4rkk=E4inen?= <pasik@iki.fi>
Subject: Re: Odd behavior of a "SAS-2" backplane with SGPIO commands
Date: Sun, 19 Aug 2012 16:13:09 +0300
Message-ID: <20120819131309.GQ19851@reaktio.net>
References: <CAOeNLuruup-22wAFgR0b+cPc0nCf_jUm0teDHB7DLnRmcHtTog@mail.gmail.com>
 <20120818235247.GO19851@reaktio.net>
 <CAOeNLuob_oq3HBV1w3W64hT4c1qSjE9xsm0_Az3+KTHnEN3QbQ@mail.gmail.com>
 <20120819102531.GP19851@reaktio.net>
 <5030E0F8.5@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.tele.fi ([192.89.123.25]:43910 "EHLO smtp.tele.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751766Ab2HSNNM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 19 Aug 2012 09:13:12 -0400
Content-Disposition: inline
In-Reply-To: <5030E0F8.5@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Harri Olin <harri.olin@gmail.com>
Cc: Rich <rercola@pha.jhu.edu>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Sun, Aug 19, 2012 at 03:50:00PM +0300, Harri Olin wrote:
> On 19.8.2012 13:25, Pasi K=E4rkk=E4inen wrote:
> >>To be brief, the sas2ircu toolset works perfectly fine with IT mode
> >>HBAs - just not with passive backplanes AFAICS [e.g. the 846A, vers=
us
> >>the 846EL2].
> >Ok. So with an expander backplane (846EL*) with SES, sas2ircu is abl=
e to control leds?
> >"LOCATE" command works? I haven't been able to try those commands wi=
th SES backplanes
> >because in these systems I've been trying to avoid expanders :)
>=20
> I think SGPIO control is disabled intentionally on LSI 9211-8i
> firmware, maybe others. When using expander, the expander controls
> LED's and SGPIO control lines from HBA are unused.
>=20

Yep. The good news is that Rich has been able to control the SM passive=
 backplane
(with AMI MG9072 SGPIO chip) LEDs using SPGIO thru LSI SAS2008 HBAs fro=
m Linux,=20
using smp_utils tools. Those tools directly send SGPIO commands using m=
ptctl/mpt2ctl interface.

The only problem Rich had is with 9211-8i HBAs.. 3 LEDs light up simult=
anously,=20
which sounds like a firmware/driver bug somewhere..

With SAS2308 based HBAs it works properly with the same Supermicro pass=
ive backplane,
and he has been able to control invidual LEDS thru SGPIO using smp_util=
s,=20
If I understood the earlier discussion correctly.


> The thing is, on 9211-8i and 9240 and probably others, multilane
> connectors are wired backwards so that if you connect a normal
> ipass-ipass cable, backplane slots will appear in backwards order to
> the system. Firmware knows this and slot numbers will appear to be
> correct when checking serial numbers etc from bios or with sas2ircu,
> but I suspect this is related to SGPIO not working.
>=20

Yeah, that's really annoying..=20

I wonder if option "phyPolarity" (mentioned here: http://www.xtremesyst=
ems.org/forums/archive/index.php/t-271922.html)
affects that ?=20

=2E. or the "Lane and polarity reversal" feature advertised for LSI SAS=
2308 based HBAs ?=20
http://www.servethehome.com/lsi-sas-2308-raid-controller-hba-informatio=
n-listing/


> You can get the SGPIO working (using sas2ircu) with
> Supermicro-supplied SAS2008 firmware from
> ftp://ftp.supermicro.com/driver/SAS/LSI/2008/IT/Firmware/ but as
> Supermicro SAS2008 HBA's (AOC-USAS2-L8i) use correct lane order on
> multilane connector, SGPIO-controlled LOCATE LED will point to wrong
> slot if not used with Supermicro card. Note that Supermicro
> backplanes will not light the LED if no HDD is in slot.
>=20

Yep..=20

> Tested mainly with Supermicro 846A backplane I think.
>=20
> I think I still have a support request open with LSI but haven't
> heart back for a long time about this issue..
>=20

Me too, they replied once asking what kind of SAS x4 cable I was using,
but no replies after that.. I've been pinging them quite a few times,
but it seems they've redirected me to /dev/null.=20

> Also I haven't yet tested the new SAS2308 based cards, great if
> finally fixed but I kind of doubt it before I see it :)
>=20

Hehe :)=20

Thanks,

-- Pasi

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

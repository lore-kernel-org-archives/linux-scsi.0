From: Harri Olin <harri.olin@gmail.com>
Subject: Re: Odd behavior of a "SAS-2" backplane with SGPIO commands
Date: Sun, 19 Aug 2012 15:50:00 +0300
Message-ID: <5030E0F8.5@gmail.com>
References: <CAOeNLuruup-22wAFgR0b+cPc0nCf_jUm0teDHB7DLnRmcHtTog@mail.gmail.com> <20120818235247.GO19851@reaktio.net> <CAOeNLuob_oq3HBV1w3W64hT4c1qSjE9xsm0_Az3+KTHnEN3QbQ@mail.gmail.com> <20120819102531.GP19851@reaktio.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emh02.mail.saunalahti.fi ([62.142.5.108]:36192 "EHLO
	emh02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299Ab2HSM6u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 19 Aug 2012 08:58:50 -0400
In-Reply-To: <20120819102531.GP19851@reaktio.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?ISO-8859-1?Q?Pasi_K=E4rkk=E4inen?= <pasik@iki.fi>
Cc: Rich <rercola@pha.jhu.edu>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 19.8.2012 13:25, Pasi K=E4rkk=E4inen wrote:
>> To be brief, the sas2ircu toolset works perfectly fine with IT mode
>> HBAs - just not with passive backplanes AFAICS [e.g. the 846A, versu=
s
>> the 846EL2].
> Ok. So with an expander backplane (846EL*) with SES, sas2ircu is able=
 to control leds?
> "LOCATE" command works? I haven't been able to try those commands wit=
h SES backplanes
> because in these systems I've been trying to avoid expanders :)

I think SGPIO control is disabled intentionally on LSI 9211-8i firmware=
,=20
maybe others. When using expander, the expander controls LED's and SGPI=
O=20
control lines from HBA are unused.

The thing is, on 9211-8i and 9240 and probably others, multilane=20
connectors are wired backwards so that if you connect a normal=20
ipass-ipass cable, backplane slots will appear in backwards order to th=
e=20
system. Firmware knows this and slot numbers will appear to be correct=20
when checking serial numbers etc from bios or with sas2ircu, but I=20
suspect this is related to SGPIO not working.

You can get the SGPIO working (using sas2ircu) with Supermicro-supplied=
=20
SAS2008 firmware from=20
ftp://ftp.supermicro.com/driver/SAS/LSI/2008/IT/Firmware/ but as=20
Supermicro SAS2008 HBA's (AOC-USAS2-L8i) use correct lane order on=20
multilane connector, SGPIO-controlled LOCATE LED will point to wrong=20
slot if not used with Supermicro card. Note that Supermicro backplanes=20
will not light the LED if no HDD is in slot.

Tested mainly with Supermicro 846A backplane I think.

I think I still have a support request open with LSI but haven't heart=20
back for a long time about this issue..

Also I haven't yet tested the new SAS2308 based cards, great if finally=
=20
fixed but I kind of doubt it before I see it :)

Quick summary about Supermicro backplane models:
T  - separate SATA connectors, no SGPIO and no locate LED's
TQ - separate SATA connectors for each slot, separate SGPIO header for=20
each 4 slot group
A  - multilane connector for each 4 slots, SGPIO on multilane connector=
s
E1 - single expander
E2 - dual expander
E16 - single 6GB expander
E26 - dual 6GB expander

--=20
Harri.

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

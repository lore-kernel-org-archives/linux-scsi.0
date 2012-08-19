From: Rich <rercola@pha.jhu.edu>
Subject: Re: Odd behavior of a "SAS-2" backplane with SGPIO commands
Date: Sun, 19 Aug 2012 10:01:08 -0400
Message-ID: <CAOeNLuoVQg+3KhjfEn2KMsUpfe3H2rjqkinhC-igMpZBJRBD3Q@mail.gmail.com>
References: <CAOeNLuruup-22wAFgR0b+cPc0nCf_jUm0teDHB7DLnRmcHtTog@mail.gmail.com>
	<20120818235247.GO19851@reaktio.net>
	<CAOeNLuob_oq3HBV1w3W64hT4c1qSjE9xsm0_Az3+KTHnEN3QbQ@mail.gmail.com>
	<20120819102531.GP19851@reaktio.net>
	<5030E0F8.5@gmail.com>
	<20120819131309.GQ19851@reaktio.net>
	<CAOeNLupdpdDqQUhabgQhZjF0rP+XcTV6jF-XhYW3=KUfmW=R4Q@mail.gmail.com>
	<20120819135603.GR19851@reaktio.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:56139 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751687Ab2HSOBK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 19 Aug 2012 10:01:10 -0400
Received: by wgbdr13 with SMTP id dr13so4652559wgb.1
        for <linux-scsi@vger.kernel.org>; Sun, 19 Aug 2012 07:01:08 -0700 (PDT)
In-Reply-To: <20120819135603.GR19851@reaktio.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?UTF-8?B?UGFzaSBLw6Rya2vDpGluZW4=?= <pasik@iki.fi>
Cc: Harri Olin <harri.olin@gmail.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

My short example would be something like the original message, but In
brief, pages 27-28 of SFF-8485 [tables 24-27, in section 8.4.4 "GPIO
transmit registers"] have what you want - I could reproduce the table
here, but that'd be convoluted to do in text. :)


With two LSI 9201-16i HBA attached, manipulating it via
/dev/bsg/sas_hostN and smp_utils 0.97, SFF-8485 section 8.4.4 seems to
think that changing this:
 00     41 02 00 00 a0 a0 a0 a0  a0 a0 a0 a0 a0 a0 a0 a0
 10     a0 a0 a0 a0 00 00 00 00  00 00 00 00 00 00 00 00
 20     00 00 00 00

By doing this:
# smp_write_gpio -d a1,a0,a0,a0 -t 3 -i 0 -c /dev/bsg/sas_hostN

Resulting in:
 00     41 02 00 00 a1 a0 a0 a0  a0 a0 a0 a0 a0 a0 a0 a0
 10     a0 a0 a0 a0 00 00 00 00  00 00 00 00 00 00 00 00
 20     00 00 00 00

Should enable a single drive's fault LED (drive m+3, by spec above).

- Rich

On Sun, Aug 19, 2012 at 9:56 AM, Pasi K=C3=A4rkk=C3=A4inen <pasik@iki.f=
i> wrote:
> On Sun, Aug 19, 2012 at 09:47:17AM -0400, Rich wrote:
>> I've got open discussions with both Supermicro and LSI at the moment=
,
>> and have shipped one of them a backplane and HBA to demonstrate this
>> since they couldn't replicate it easily in-house.
>>
>
> Cool! Let's hope they'll be able to fix it..
>
>> I also wouldn't claim SGPIO is "disabled" on any of these cards - an=
y
>> of the RAID cards don't expose the virtual SMP port, but said blinki=
ng
>> works fine through LSI's magic binary blob MegaCLI. And with the
>> 9211-8i and other SAS2008 HBAs (9201-16i being the one I have a lot
>> of), it works great on any expander I've tried, but on the passive
>> backplanes in these, the behavior is as I described - blinking one L=
ED
>> per SAS port plugged from a given HBA into the backplane. [...which =
is
>> even more fascinating the more you think about it, since that means
>> that the behavior easily straddles multiple passive management chips=
,
>> which looks more like an HBA-end problem...]
>>
>
> Yep..
>
> btw do you have example commands/scripts/tools for SGPIO LED control?
> I should be able to try this stuff in a couple of days..
>
> Otherwise I'll try reading the SFF-8485/SGPIO spec and play with smp_=
write_gpio/smp_read_gpio :)
>
> Thanks,
>
> -- Pasi
>
>
>> - Rich
>>
>> On Sun, Aug 19, 2012 at 9:13 AM, Pasi K=C3=A4rkk=C3=A4inen <pasik@ik=
i.fi> wrote:
>> > On Sun, Aug 19, 2012 at 03:50:00PM +0300, Harri Olin wrote:
>> >> On 19.8.2012 13:25, Pasi K=C3=A4rkk=C3=A4inen wrote:
>> >> >>To be brief, the sas2ircu toolset works perfectly fine with IT =
mode
>> >> >>HBAs - just not with passive backplanes AFAICS [e.g. the 846A, =
versus
>> >> >>the 846EL2].
>> >> >Ok. So with an expander backplane (846EL*) with SES, sas2ircu is=
 able to control leds?
>> >> >"LOCATE" command works? I haven't been able to try those command=
s with SES backplanes
>> >> >because in these systems I've been trying to avoid expanders :)
>> >>
>> >> I think SGPIO control is disabled intentionally on LSI 9211-8i
>> >> firmware, maybe others. When using expander, the expander control=
s
>> >> LED's and SGPIO control lines from HBA are unused.
>> >>
>> >
>> > Yep. The good news is that Rich has been able to control the SM pa=
ssive backplane
>> > (with AMI MG9072 SGPIO chip) LEDs using SPGIO thru LSI SAS2008 HBA=
s from Linux,
>> > using smp_utils tools. Those tools directly send SGPIO commands us=
ing mptctl/mpt2ctl interface.
>> >
>> > The only problem Rich had is with 9211-8i HBAs.. 3 LEDs light up s=
imultanously,
>> > which sounds like a firmware/driver bug somewhere..
>> >
>> > With SAS2308 based HBAs it works properly with the same Supermicro=
 passive backplane,
>> > and he has been able to control invidual LEDS thru SGPIO using smp=
_utils,
>> > If I understood the earlier discussion correctly.
>> >
>> >
>> >> The thing is, on 9211-8i and 9240 and probably others, multilane
>> >> connectors are wired backwards so that if you connect a normal
>> >> ipass-ipass cable, backplane slots will appear in backwards order=
 to
>> >> the system. Firmware knows this and slot numbers will appear to b=
e
>> >> correct when checking serial numbers etc from bios or with sas2ir=
cu,
>> >> but I suspect this is related to SGPIO not working.
>> >>
>> >
>> > Yeah, that's really annoying..
>> >
>> > I wonder if option "phyPolarity" (mentioned here: http://www.xtrem=
esystems.org/forums/archive/index.php/t-271922.html)
>> > affects that ?
>> >
>> > .. or the "Lane and polarity reversal" feature advertised for LSI =
SAS2308 based HBAs ?
>> > http://www.servethehome.com/lsi-sas-2308-raid-controller-hba-infor=
mation-listing/
>> >
>> >
>> >> You can get the SGPIO working (using sas2ircu) with
>> >> Supermicro-supplied SAS2008 firmware from
>> >> ftp://ftp.supermicro.com/driver/SAS/LSI/2008/IT/Firmware/ but as
>> >> Supermicro SAS2008 HBA's (AOC-USAS2-L8i) use correct lane order o=
n
>> >> multilane connector, SGPIO-controlled LOCATE LED will point to wr=
ong
>> >> slot if not used with Supermicro card. Note that Supermicro
>> >> backplanes will not light the LED if no HDD is in slot.
>> >>
>> >
>> > Yep..
>> >
>> >> Tested mainly with Supermicro 846A backplane I think.
>> >>
>> >> I think I still have a support request open with LSI but haven't
>> >> heart back for a long time about this issue..
>> >>
>> >
>> > Me too, they replied once asking what kind of SAS x4 cable I was u=
sing,
>> > but no replies after that.. I've been pinging them quite a few tim=
es,
>> > but it seems they've redirected me to /dev/null.
>> >
>> >> Also I haven't yet tested the new SAS2308 based cards, great if
>> >> finally fixed but I kind of doubt it before I see it :)
>> >>
>> >
>> > Hehe :)
>> >
>> > Thanks,
>> >
>> > -- Pasi
>> >
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

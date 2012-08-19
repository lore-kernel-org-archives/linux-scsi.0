From: Rich <rercola@pha.jhu.edu>
Subject: Re: Odd behavior of a "SAS-2" backplane with SGPIO commands
Date: Sun, 19 Aug 2012 09:47:17 -0400
Message-ID: <CAOeNLupdpdDqQUhabgQhZjF0rP+XcTV6jF-XhYW3=KUfmW=R4Q@mail.gmail.com>
References: <CAOeNLuruup-22wAFgR0b+cPc0nCf_jUm0teDHB7DLnRmcHtTog@mail.gmail.com>
	<20120818235247.GO19851@reaktio.net>
	<CAOeNLuob_oq3HBV1w3W64hT4c1qSjE9xsm0_Az3+KTHnEN3QbQ@mail.gmail.com>
	<20120819102531.GP19851@reaktio.net>
	<5030E0F8.5@gmail.com>
	<20120819131309.GQ19851@reaktio.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:59753 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751687Ab2HSNrT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 19 Aug 2012 09:47:19 -0400
Received: by wicr5 with SMTP id r5so3007995wic.1
        for <linux-scsi@vger.kernel.org>; Sun, 19 Aug 2012 06:47:18 -0700 (PDT)
In-Reply-To: <20120819131309.GQ19851@reaktio.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?UTF-8?B?UGFzaSBLw6Rya2vDpGluZW4=?= <pasik@iki.fi>
Cc: Harri Olin <harri.olin@gmail.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

I've got open discussions with both Supermicro and LSI at the moment,
and have shipped one of them a backplane and HBA to demonstrate this
since they couldn't replicate it easily in-house.

I also wouldn't claim SGPIO is "disabled" on any of these cards - any
of the RAID cards don't expose the virtual SMP port, but said blinking
works fine through LSI's magic binary blob MegaCLI. And with the
9211-8i and other SAS2008 HBAs (9201-16i being the one I have a lot
of), it works great on any expander I've tried, but on the passive
backplanes in these, the behavior is as I described - blinking one LED
per SAS port plugged from a given HBA into the backplane. [...which is
even more fascinating the more you think about it, since that means
that the behavior easily straddles multiple passive management chips,
which looks more like an HBA-end problem...]

- Rich

On Sun, Aug 19, 2012 at 9:13 AM, Pasi K=C3=A4rkk=C3=A4inen <pasik@iki.f=
i> wrote:
> On Sun, Aug 19, 2012 at 03:50:00PM +0300, Harri Olin wrote:
>> On 19.8.2012 13:25, Pasi K=C3=A4rkk=C3=A4inen wrote:
>> >>To be brief, the sas2ircu toolset works perfectly fine with IT mod=
e
>> >>HBAs - just not with passive backplanes AFAICS [e.g. the 846A, ver=
sus
>> >>the 846EL2].
>> >Ok. So with an expander backplane (846EL*) with SES, sas2ircu is ab=
le to control leds?
>> >"LOCATE" command works? I haven't been able to try those commands w=
ith SES backplanes
>> >because in these systems I've been trying to avoid expanders :)
>>
>> I think SGPIO control is disabled intentionally on LSI 9211-8i
>> firmware, maybe others. When using expander, the expander controls
>> LED's and SGPIO control lines from HBA are unused.
>>
>
> Yep. The good news is that Rich has been able to control the SM passi=
ve backplane
> (with AMI MG9072 SGPIO chip) LEDs using SPGIO thru LSI SAS2008 HBAs f=
rom Linux,
> using smp_utils tools. Those tools directly send SGPIO commands using=
 mptctl/mpt2ctl interface.
>
> The only problem Rich had is with 9211-8i HBAs.. 3 LEDs light up simu=
ltanously,
> which sounds like a firmware/driver bug somewhere..
>
> With SAS2308 based HBAs it works properly with the same Supermicro pa=
ssive backplane,
> and he has been able to control invidual LEDS thru SGPIO using smp_ut=
ils,
> If I understood the earlier discussion correctly.
>
>
>> The thing is, on 9211-8i and 9240 and probably others, multilane
>> connectors are wired backwards so that if you connect a normal
>> ipass-ipass cable, backplane slots will appear in backwards order to
>> the system. Firmware knows this and slot numbers will appear to be
>> correct when checking serial numbers etc from bios or with sas2ircu,
>> but I suspect this is related to SGPIO not working.
>>
>
> Yeah, that's really annoying..
>
> I wonder if option "phyPolarity" (mentioned here: http://www.xtremesy=
stems.org/forums/archive/index.php/t-271922.html)
> affects that ?
>
> .. or the "Lane and polarity reversal" feature advertised for LSI SAS=
2308 based HBAs ?
> http://www.servethehome.com/lsi-sas-2308-raid-controller-hba-informat=
ion-listing/
>
>
>> You can get the SGPIO working (using sas2ircu) with
>> Supermicro-supplied SAS2008 firmware from
>> ftp://ftp.supermicro.com/driver/SAS/LSI/2008/IT/Firmware/ but as
>> Supermicro SAS2008 HBA's (AOC-USAS2-L8i) use correct lane order on
>> multilane connector, SGPIO-controlled LOCATE LED will point to wrong
>> slot if not used with Supermicro card. Note that Supermicro
>> backplanes will not light the LED if no HDD is in slot.
>>
>
> Yep..
>
>> Tested mainly with Supermicro 846A backplane I think.
>>
>> I think I still have a support request open with LSI but haven't
>> heart back for a long time about this issue..
>>
>
> Me too, they replied once asking what kind of SAS x4 cable I was usin=
g,
> but no replies after that.. I've been pinging them quite a few times,
> but it seems they've redirected me to /dev/null.
>
>> Also I haven't yet tested the new SAS2308 based cards, great if
>> finally fixed but I kind of doubt it before I see it :)
>>
>
> Hehe :)
>
> Thanks,
>
> -- Pasi
>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

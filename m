From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: Odd behavior of a "SAS-2" backplane with SGPIO commands
Date: Thu, 03 Oct 2013 20:07:14 -0400
Message-ID: <524E06B2.3070408@interlog.com>
References: <20121207134643.GA8912@reaktio.net> <CAOeNLuroRgZUvFWYTx7yr5ERtEpjiOwQgcy4COCLsm7Z9wWaKw@mail.gmail.com> <CAOeNLuqVPQTsBs1eoizHBcEVbGgLrQOQBxqkV38cGwyKS4UTNA@mail.gmail.com> <20121219194142.GO8912@reaktio.net> <20130423001936.GV11427@reaktio.net> <CAOeNLuo+Pti7LfshpOuzDSwWzdtXw0Ouph7ZAoJ9i7CyaUXiAA@mail.gmail.com> <20130423003956.GW11427@reaktio.net> <CAOeNLuqnX9r-jrmq0kV1=kU3XOzFEttDQktcD5338BzaBX3KHg@mail.gmail.com> <20130901171302.GF2924@reaktio.net> <20130902144435.GG2924@reaktio.net> <20131003191100.GW2924@reaktio.net>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:58165 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751374Ab3JDAHu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 3 Oct 2013 20:07:50 -0400
In-Reply-To: <20131003191100.GW2924@reaktio.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?ISO-8859-1?Q?Pasi_K=E4rkk=E4inen?= <pasik@iki.fi>, Rich <rercola@pha.jhu.edu>
Cc: Emmanuel Florac <eflorac@intellique.com>, Harri Olin <harri.olin@gmail.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 13-10-03 03:11 PM, Pasi K=E4rkk=E4inen wrote:
> On Mon, Sep 02, 2013 at 05:44:35PM +0300, Pasi K=E4rkk=E4inen wrote:
>> On Sun, Sep 01, 2013 at 08:13:02PM +0300, Pasi K=E4rkk=E4inen wrote:
>>> On Fri, Aug 30, 2013 at 05:38:04PM -0400, Rich wrote:
>>>>     Apparently, only about 4 months.
>>>>     P17 firmware is out.
>>>>     Tested on a card which was demonstrating the incorrect behavio=
r before, of
>>>>     model 9201-16i.
>>>>     It does appear to contain the fixes for this problem.
>>>
>>> This is great news, finally!
>>> Thanks for testing and reporting!
>>>
>>
>> Hmm, I checked the P17 firmware changelog PDFs for LSI 9211-8i, 9207=
-8i and 9201-16i,
>> and I can't see anything about this issue being fixed..
>>
>> But if you say it's now fixed, then I guess it means LSI doesn't lis=
t every change in the changelog..
>>
>
> I just had some time today to test the new P17 IT firmware with LSI 9=
211-8i SAS HBAs.
>
> It seems also the "LOCATE" function of LSI sas2ircu tool now actually=
 works and makes
> the red/failure leds blink on the Supermicro passive (direct-attach) =
backplane! Finally..
>
> Btw do you guys have any scripts/tools to control the LEDs on these p=
assive backplanes?
> smp_read_gpio/smp_write_gpio isn't the most userfriendly interface ;)=
 Should I try ledmon/ledctl?

There isn't much information about the SMP READ_GPIO and
WRITE_GPIO (and extended variants) in the older SAS
standards and now they have been pushed out of the recent
SAS (SPL-3) drafts. SFF-8485 ain't much help in that
respect either. If anyone has information (not covered by
an NDA) about how these are used, please send it to me.

As for blinking the LED on a SAS disk: in the sdparm package,
in the 'scripts' directory, try the sas_disk_blink script.

Doug Gilbert

> I can probably hack something myself too.. but there are many other t=
asks on the todo-list before this :)
>
> Thanks,
>
> -- Pasi
>
>>
>>>
>>>>     - Rich
>>>>
>>>>     On Mon, Apr 22, 2013 at 8:39 PM, Pasi K=E4rkk=E4inen <[1]pasik=
@iki.fi> wrote:
>>>>
>>>>       On Mon, Apr 22, 2013 at 08:28:58PM -0400, Rich wrote:
>>>>       >    I'm told that the fix won't actually be in until P17, b=
ecause it
>>>>       involved
>>>>       >    touching a large number of codepaths, but that it will =
be in P17.
>>>>       >
>>>>
>>>>       That's unfortunate.. so another 5-6 months.
>>>>
>>>>       Thanks for the info!
>>>>
>>>>       -- Pasi
>>>>
>>>>       >    - Rich
>>>>       >
>>>>       >    On Mon, Apr 22, 2013 at 8:19 PM, Pasi K=C3*rkk=C3*inen
>>>>       <[1][2]pasik@iki.fi>
>>>>       >    wrote:
>>>>       >
>>>>       >      On Wed, Dec 19, 2012 at 09:41:42PM +0200, Pasi K=C3*r=
kk=C3*inen
>>>>       wrote:
>>>>       >      > On Wed, Dec 19, 2012 at 02:35:02PM -0500, Rich wrot=
e:
>>>>       >      > > =C2  =C2 Nope, I'm wrong.
>>>>       >      >
>>>>       >      > :(
>>>>       >      >
>>>>       >      > > =C2  =C2 I flashed P15 on a machine, and the same=
 behavior
>>>>       persisted,
>>>>       >      right up to
>>>>       >      > > =C2  =C2 and including the "groups of 3 devices l=
ight up when I
>>>>       do my
>>>>       >      own
>>>>       >      > > =C2  =C2 smp_write_gpio".
>>>>       >      > > =C2  =C2 Whereas if I flash the experimental blob=
 I was handed by
>>>>       >      support to try
>>>>       >      > > =C2  =C2 and confirm they had resolved the issue,=
 it does the
>>>>       correct
>>>>       >      thing.
>>>>       >      > > =C2  =C2 I wonder why this change didn't make it =
into P15.
>>>>       >      >
>>>>       >      > Hmm.. if you have open contact channel with LSI sup=
port please
>>>>       ask
>>>>       >      them..
>>>>       >      > it'd be nice to get the fix for wider audience..
>>>>       >      >
>>>>       >
>>>>       >      It seems LSI P16 firmware has been released.. in the =
=46W changelog
>>>>       I can
>>>>       >      see at least this:
>>>>       >
>>>>       >      "Disable SGPIO Group ID support in Channel NVDATA XML=
's. This
>>>>       allows the
>>>>       >      use of manufacturing page 7 or default slot mapping s=
etting for
>>>>       direct
>>>>       >      connected drive slots."
>>>>       >
>>>>       >      -- Pasi
>>>>       >
>>>>       >      >
>>>>       >      > > =C2  =C2 - Rich
>>>>       >      > >
>>>>       >      > > =C2  =C2 On Wed, Dec 19, 2012 at 2:00 PM, Rich
>>>>       >      <[1][2][3]rercola@pha.jhu.edu> wrote:
>>>>       >      > >
>>>>       >      > > =C2  =C2  =C2 From the LSI P15 F/W release notes:
>>>>       >      > > =C2  =C2  =C2 SCGCQ00342805 (DFCT) =C3* - SlotSta=
tus updates to SES
>>>>       managed
>>>>       >      Enclosure may
>>>>       >      > > =C2  =C2  =C2 update incorrect slots
>>>>       >      > > =C2  =C2  =C2 "Modified FW to use SES diag page 0=
Ah mapping only if
>>>>       SMP
>>>>       >      Discover
>>>>       >      > > =C2  =C2  =C2 DeviceSlotNum is used for Encl Phy=C3=
* Slot
>>>>       enumeration."
>>>>       >      > > =C2  =C2  =C2 SCGCQ00345867 (DFCT) =C3* - Channel=
 NVDATA internal Phy
>>>>       >      reverse setting for
>>>>       >      > > =C2  =C2  =C2 9207-4i4e 9207-8i 9217-4i4e=C3* 921=
7-8i and 9201-16i
>>>>       >      > > =C2  =C2  =C2 "ISSUE DESC:=C3* Internal PHY order=
s are reversed for
>>>>       the
>>>>       >      channel boards
>>>>       >      > > =C2  =C2  =C2 above."
>>>>       >      > > =C2  =C2  =C2 So I would submit this is likely fi=
xed by this FW
>>>>       rev.
>>>>       >      > > =C2  =C2  =C2 - Rich
>>>>       >      > >
>>>>       >      > > =C2  =C2  =C2 On Fri, Dec 7, 2012 at 8:46 AM, Pas=
i
>>>>       K=C3*=E2*=ACrkk=C3*=E2*=ACinen
>>>>       >      <[2][3][4]pasik@iki.fi>
>>>>       >      > > =C2  =C2  =C2 wrote:
>>>>       >      > >
>>>>       >      > > =C2  =C2  =C2  =C2 On Thu, Nov 01, 2012 at 11:55:=
25AM -0400, Rich
>>>>       wrote:
>>>>       >      > > =C2  =C2  =C2  =C2 > On Sun, Oct 21, 2012 at 8:46=
 AM, Pasi
>>>>       >      K=C3*=E2*=ACrkk=C3*=E2*=ACinen <[3][4][5]pasik@iki.fi=
>
>>>>       >      > > =C2  =C2  =C2  =C2 wrote:
>>>>       >      > > =C2  =C2  =C2  =C2 > > On Mon, Sep 10, 2012 at 07=
:13:15PM +0300, Pasi
>>>>       >      K=C3*=E2*=ACrkk=C3*=E2*=ACinen wrote:
>>>>       >      > > =C2  =C2  =C2  =C2 > >> On Mon, Sep 10, 2012 at 1=
2:07:45PM -0400,
>>>>       Rich
>>>>       >      wrote:
>>>>       >      > > =C2  =C2  =C2  =C2 > >> > On Mon, Sep 10, 2012 at=
 12:04 PM, Pasi
>>>>       >      K=C3*=E2*=ACrkk=C3*=E2*=ACinen
>>>>       >      > > =C2  =C2  =C2  =C2 <[4][5][6]pasik@iki.fi> wrote:
>>>>       >      > > =C2  =C2  =C2  =C2 > >> > > On Mon, Sep 10, 2012 =
at 06:01:42PM +0200,
>>>>       >      Emmanuel Florac
>>>>       >      > > =C2  =C2  =C2  =C2 wrote:
>>>>       >      > > =C2  =C2  =C2  =C2 > >> > >> Le Mon, 10 Sep 2012 =
16:47:11 +0300
>>>>       >      > > =C2  =C2  =C2  =C2 > >> > >> Pasi K=C3*=E2*=ACrkk=
=C3*=E2*=ACinen
>>>>       <[5][6][7]pasik@iki.fi>
>>>>       >      =C3*=C2=A9crivait:
>>>>       >      > > =C2  =C2  =C2  =C2 > >> > >>
>>>>       >      > > =C2  =C2  =C2  =C2 > >> > >> > Any replies from S=
upermicro/LSI ?
>>>>       >      > > =C2  =C2  =C2  =C2 > >> > >> >
>>>>       >      > > =C2  =C2  =C2  =C2 > >> > >>
>>>>       >      > > =C2  =C2  =C2  =C2 > >> > >> Only loosely related=
, but Supermicro
>>>>       replaced
>>>>       >      recently my
>>>>       >      > > =C2  =C2  =C2  =C2 846E26 (dual
>>>>       >      > > =C2  =C2  =C2  =C2 > >> > >> expander backplane) =
with 846E16 (single
>>>>       >      expander).
>>>>       >      > > =C2  =C2  =C2  =C2 Apparently they
>>>>       >      > > =C2  =C2  =C2  =C2 > >> > >> gave up getting the =
E26 to work properly
>>>>       or
>>>>       >      something: LSI
>>>>       >      > > =C2  =C2  =C2  =C2 expander
>>>>       >      > > =C2  =C2  =C2  =C2 > >> > >> firmware problem.
>>>>       >      > > =C2  =C2  =C2  =C2 > >> > >>
>>>>       >      > > =C2  =C2  =C2  =C2 > >> > >> In another (very lar=
ge scale, high end)
>>>>       setup,
>>>>       >      many
>>>>       >      > > =C2  =C2  =C2  =C2 different 60 slots
>>>>       >      > > =C2  =C2  =C2  =C2 > >> > >> 5 LSI expanders chas=
sis had a general
>>>>       failure
>>>>       >      of the 5th
>>>>       >      > > =C2  =C2  =C2  =C2 drawer.
>>>>       >      > > =C2  =C2  =C2  =C2 > >> > >> Another LSI SAS-2 ex=
pander firmware
>>>>       problem.
>>>>       >      > > =C2  =C2  =C2  =C2 > >> > >>
>>>>       >      > > =C2  =C2  =C2  =C2 > >> > >> I could start a rant=
 about the evil of
>>>>       >      proprietary firmware,
>>>>       >      > > =C2  =C2  =C2  =C2 etc. You
>>>>       >      > > =C2  =C2  =C2  =C2 > >> > >> get my meaning :)
>>>>       >      > > =C2  =C2  =C2  =C2 > >> > >>
>>>>       >      > > =C2  =C2  =C2  =C2 > >> > >
>>>>       >      > > =C2  =C2  =C2  =C2 > >> > > Yeah, this is a good =
example why we're
>>>>       trying to
>>>>       >      get the LEDs
>>>>       >      > > =C2  =C2  =C2  =C2 working with
>>>>       >      > > =C2  =C2  =C2  =C2 > >> > > direct attach (non-ex=
pander) backplanes
>>>>       :)
>>>>       >      > > =C2  =C2  =C2  =C2 > >> > >
>>>>       >      > > =C2  =C2  =C2  =C2 > >> > > -- Pasi
>>>>       >      > > =C2  =C2  =C2  =C2 > >> > >
>>>>       >      > > =C2  =C2  =C2  =C2 > >> >
>>>>       >      > > =C2  =C2  =C2  =C2 > >> > I don't have anything u=
seful for people,
>>>>       other
>>>>       >      than that they
>>>>       >      > > =C2  =C2  =C2  =C2 have
>>>>       >      > > =C2  =C2  =C2  =C2 > >> > shown me an HBA firmwar=
e that fixes the LED
>>>>       >      problem but has
>>>>       >      > > =C2  =C2  =C2  =C2 other
>>>>       >      > > =C2  =C2  =C2  =C2 > >> > problems they're still =
debugging.
>>>>       >      > > =C2  =C2  =C2  =C2 > >> >
>>>>       >      > > =C2  =C2  =C2  =C2 > >> > So there does exist cod=
e for this firmware
>>>>       which
>>>>       >      will fix this
>>>>       >      > > =C2  =C2  =C2  =C2 problem.
>>>>       >      > > =C2  =C2  =C2  =C2 > >> >
>>>>       >      > > =C2  =C2  =C2  =C2 > >>
>>>>       >      > > =C2  =C2  =C2  =C2 > >> That's good to know! Let'=
s hope the fix ends
>>>>       up in
>>>>       >      an official
>>>>       >      > > =C2  =C2  =C2  =C2 > >> LSI HBA firmware update i=
n not-so-distant
>>>>       future.
>>>>       >      > > =C2  =C2  =C2  =C2 > >>
>>>>       >      > > =C2  =C2  =C2  =C2 > >
>>>>       >      > > =C2  =C2  =C2  =C2 > > Btw what was the version n=
umber of the
>>>>       LED-fixed LSI
>>>>       >      firmware?
>>>>       >      > > =C2  =C2  =C2  =C2 > > I'm just wondering in whic=
h firmware series
>>>>       the fix
>>>>       >      might end up
>>>>       >      > > =C2  =C2  =C2  =C2 being included..
>>>>       >      > > =C2  =C2  =C2  =C2 > >
>>>>       >      > > =C2  =C2  =C2  =C2 > > Also: Any updates on this?
>>>>       >      > > =C2  =C2  =C2  =C2 > >
>>>>       >      > > =C2  =C2  =C2  =C2 > > Thanks,
>>>>       >      > > =C2  =C2  =C2  =C2 > >
>>>>       >      > > =C2  =C2  =C2  =C2 > > -- Pasi
>>>>       >      > > =C2  =C2  =C2  =C2 > >
>>>>       >      > > =C2  =C2  =C2  =C2 >
>>>>       >      > > =C2  =C2  =C2  =C2 > The fixed FW I had demonstra=
ted for me was still
>>>>       >      14.0.0.0 - I've
>>>>       >      > > =C2  =C2  =C2  =C2 been
>>>>       >      > > =C2  =C2  =C2  =C2 > told it'll be rolled into th=
e FW release
>>>>       currently on
>>>>       >      the site and
>>>>       >      > > =C2  =C2  =C2  =C2 > posted at some point, but th=
at they have no ETA
>>>>       for
>>>>       >      that.
>>>>       >      > > =C2  =C2  =C2  =C2 >
>>>>       >      > >
>>>>       >      > > =C2  =C2  =C2  =C2 I can now see P15 firmware ava=
ilable on LSI's
>>>>       website for
>>>>       >      9211-8i
>>>>       >      > > =C2  =C2  =C2  =C2 (SAS2008 based HBA).
>>>>       >      > > =C2  =C2  =C2  =C2 Sadly it's missing the release=
notes/changelogs for
>>>>       both
>>>>       >      the LSI bios
>>>>       >      > > =C2  =C2  =C2  =C2 and firmware..
>>>>       >      > > =C2  =C2  =C2  =C2 -- Pasi
>>>>       >      > >
>>>>       >      > > References
>>>>       >      > >
>>>>       >      > > =C2  =C2 Visible links
>>>>       >      > > =C2  =C2 1. mailto:[7][8]rercola@pha.jhu.edu
>>>>       >      > > =C2  =C2 2. mailto:[8][9]pasik@iki.fi
>>>>       >      > > =C2  =C2 3. mailto:[9][10]pasik@iki.fi
>>>>       >      > > =C2  =C2 4. mailto:[10][11]pasik@iki.fi
>>>>       >      > > =C2  =C2 5. mailto:[11][12]pasik@iki.fi
>>>>       >      > --
>>>>       >      > To unsubscribe from this list: send the line "unsub=
scribe
>>>>       linux-scsi"
>>>>       >      in
>>>>       >      > the body of a message to [12][13]majordomo@vger.ker=
nel.org
>>>>       >      > More majordomo info at
>>>>       >      =C2 [13][14]http://vger.kernel.org/majordomo-info.htm=
l
>>>>       >
>>>>       > References
>>>>       >
>>>>       >    Visible links
>>>>       >    1. mailto:[15]pasik@iki.fi
>>>>       >    2. mailto:[16]rercola@pha.jhu.edu
>>>>       >    3. mailto:[17]pasik@iki.fi
>>>>       >    4. mailto:[18]pasik@iki.fi
>>>>       >    5. mailto:[19]pasik@iki.fi
>>>>       >    6. mailto:[20]pasik@iki.fi
>>>>       >    7. mailto:[21]rercola@pha.jhu.edu
>>>>       >    8. mailto:[22]pasik@iki.fi
>>>>       >    9. mailto:[23]pasik@iki.fi
>>>>       >   10. mailto:[24]pasik@iki.fi
>>>>       >   11. mailto:[25]pasik@iki.fi
>>>>       >   12. mailto:[26]majordomo@vger.kernel.org
>>>>       >   13. [27]http://vger.kernel.org/majordomo-info.html
>>>>
>>>> References
>>>>
>>>>     Visible links
>>>>     1. mailto:pasik@iki.fi
>>>>     2. mailto:pasik@iki.fi
>>>>     3. mailto:rercola@pha.jhu.edu
>>>>     4. mailto:pasik@iki.fi
>>>>     5. mailto:pasik@iki.fi
>>>>     6. mailto:pasik@iki.fi
>>>>     7. mailto:pasik@iki.fi
>>>>     8. mailto:rercola@pha.jhu.edu
>>>>     9. mailto:pasik@iki.fi
>>>>    10. mailto:pasik@iki.fi
>>>>    11. mailto:pasik@iki.fi
>>>>    12. mailto:pasik@iki.fi
>>>>    13. mailto:majordomo@vger.kernel.org
>>>>    14. http://vger.kernel.org/majordomo-info.html
>>>>    15. mailto:pasik@iki.fi
>>>>    16. mailto:rercola@pha.jhu.edu
>>>>    17. mailto:pasik@iki.fi
>>>>    18. mailto:pasik@iki.fi
>>>>    19. mailto:pasik@iki.fi
>>>>    20. mailto:pasik@iki.fi
>>>>    21. mailto:rercola@pha.jhu.edu
>>>>    22. mailto:pasik@iki.fi
>>>>    23. mailto:pasik@iki.fi
>>>>    24. mailto:pasik@iki.fi
>>>>    25. mailto:pasik@iki.fi
>>>>    26. mailto:majordomo@vger.kernel.org
>>>>    27. http://vger.kernel.org/majordomo-info.html
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-scs=
i" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-scsi=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

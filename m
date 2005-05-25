From: Mogens Valentin <monz@danbbs.dk>
Subject: Re: [ANNOUNCE] sdparm 0.92
Date: Wed, 25 May 2005 17:43:42 +0200
Message-ID: <42949D2E.5020309@danbbs.dk>
References: <428DC633.5050403@torque.net> <4293BD80.1050503@danbbs.dk> <4293D798.4020606@torque.net> <4293E62A.5080408@danbbs.dk> <429466EC.3080801@torque.net> <429478C2.3000003@danbbs.dk> <429480F9.6050802@torque.net>
Reply-To: monz@danbbs.dk
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pfepc.post.tele.dk ([195.41.46.237]:48999 "EHLO
	pfepc.post.tele.dk") by vger.kernel.org with ESMTP id S262379AbVEYPnC
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 May 2005 11:43:02 -0400
In-Reply-To: <429480F9.6050802@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: linux-scsi <linux-scsi@vger.kernel.org>

Douglas Gilbert wrote:
> Mogens Valentin wrote:
>=20
>> Douglas Gilbert wrote:
>>
>>> Mogens Valentin wrote:
>>>
>>>> Douglas Gilbert wrote:
>>>>
>>>>> Mogens Valentin wrote:
>>>>>
>>>>>> Douglas Gilbert wrote:
>>>>>>
>>>>>>> sdparm is a command line utility designed to get and set
>>>>>>> SCSI disk parameters (cf hdparm for ATA disks). ..snip..
>>>>>>
>>>>>> Nice! Just got it and tried on an external usb disk.
>>>>>> One feature I could use, probably others as well:
>>>>>> Could you add the ability to spin down/up a scsi disk?
>>>>>> I'd really like this for exteral (usb) disks.
>>>>>
>>>>> With sg_start (in the sg3_utils package) I have tried
>>>>> to spin up and down an ATA disk inside a USB enclosure
>>>>> without success. The same command on a USB connected
>>>>> CD/DVD combo drive did work.
>>>>>
>>>>> Could you try sg_start on your USB external enclosure
>>>>> which I assume contains an ATA disk rather than a
>>>>> SCSI (SPI) disk and report if it works?
>>>>
>>>> Sure. Got it, compiled, but got the error:
>>>>   .../usr/include/scsi/sg.h /usr/include/scsi/scsi.h
>>>>   /usr/include/stdint.h   sg_lib.h sg_cmds.h llseek.h
>>>>   gcc: cannot specify -o with -c or -S and multiple compilations
>>>>   make: *** [sgp_dd.o] Error 1
>>>>
>>>> I could only find  -o  and  -c  in the makefiles around line 95.
>>>>
>>>> Slack 9.1 / 2.6.10 from sources.
>>>>
>>>> It's 4am, I'm off to bed, sorry :p
>>>
>>> Could you try the sg3_utils-1.15.tgz beta at the
>>> top of http://www.torque.net/sg [in the news section].
>>> Hopefully that cures the compile problem.
>>
>> Nope, but it changes the error. You changed the makefile exactly as =
I=20
>> tried it, removing '-c' in line 95.
>> This results in missing header files compiles:
 >>
>> ...
>> creating sg_dd
>> gcc  -g -O2 -Wall -W -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=3D64=20
>> -D_REENTRANT -c sgp_dd.c ...
>> .../usr/include/stdint.h sg_lib.h sg_cmds.h llseek.h
>> gcc: compilation of header file requested
>> gcc: compilation of header file requested
>> ...
>> make: *** [sgp_dd.o] Error 1
>>
>>
>> Forgot to mention I have gcc version 3.2.3, FWIW..
>> It's not exactly an uncommon problem; I googled a bit :p
>> I haven't pinpointed the problem as yet, but found comments (from=20
>> compiling other apps) that it could be either a gcc versioning=20
>> problem, a problem with -I or -D switches, or simply a Makefile prob=
lem.
>>
> I can make that compile file as well if I place
> rubbish in the INCLUDES environment variable;
> for example:
>  # export INCLUDES=3Dhello.h
>=20
>  # make sgp_dd
> gcc hello.h -g -O2 -Wall -W -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=
=3D64=20
> -D_REENTRANT -c sgp_dd.c
> gcc: hello.h: No such file or directory
> make: *** [sgp_dd.o] Error 1

Ehh.. I don't follow you here..
INCLUDES seems left undefined and hence evaluates empty, so yes, you ca=
n=20
provoke an error by defining some nonsense, but since I cannnot compile=
,=20
something's wrong: my gcc version, your makefile, or my (=BDempty) mind=
=2E

>>> Even if it doesn't you can 'make sg_start' to get
>>> the sg_start executable. 'man ./sg_start' will give
>>> you the usage information.
>>
>> That I could do, doing the 1.15 version.
>> Oh, it's man ./sg_start.8 ..
>=20
> Of course.
>=20
>> Hmm, couldn't run sg_start:
>> .libs/sg_start: error while loading shared libraries: libsgutils.so.=
1:=20
>> cannot open shared object file: No such file or directory
>=20
> ./sg_start in the compile directory should work.

My mistake..

>> No wonder, since libs hadn't been installed, so I copied them to=20
>> /usr/local/lib . Now sg_start runs, but... :
>>
>> bash-2.05b# .libs/sg_start 0 /dev/sdc
>> start_stop: SCSI status: Check Condition
>>  Fixed format, current;  Sense key: Illegal Request
>>  Additional sense: Invalid command operation code
>>  Raw sense data (in hex):
>>         70 00 05 00 00 00 00 0a  00 00 00 00 20 00 00 00
>>         00 00
>> plus...: Driver_status=3D0x08 [DRIVER_SENSE, SUGGEST_OK]
>=20
>=20
> So it doesn't support the SCSI START STOP UNIT command.
> Hence sdparm will be unable to spin up or down that
> disk :-(
>=20
>> Some info:
>> bash-2.05b# cat /proc/scsi/usb-storage/11
>>    Host scsi11: usb-storage
>>        Vendor: Prolific Technology Inc.
>>       Product: ATAPI-6 Bridge Controller
>> Serial Number: 559F
>>      Protocol: Transparent SCSI
>>     Transport: Bulk
>>        Quirks:
>>
>>
>> bash-2.05b# sdparm -lv /dev/sdc
>>     /dev/sdc: ST316002  3A                8.01
>>  >> Read write error recovery mode page not supported
>>  >> Caching (SBC) mode page not supported
>>  >> Control mode page not supported
>>  >> Informational exception control mode page not supported
>=20
>=20
> And the bridge doesn't support the normal mode pages
> for a disk. Seems like a minimal bridge that supports
> the minimal 4 commands:
>   - INQUIRY
>   - READ CAPACITY
>   - READ (10)
>   - WRITE (10)
>=20
> Not exactly "prolific".

Guess not, but that's what they call it. Marketing.. :p
How doy you tell that it's the the interface, not the disk, that has=20
those limitations? For sure, it's a Seagate 7200.7 ATA, so I guess it=20
should have the same features as the other interface-types of the same.=
=2E
Anyways, damn!

> I think you will find that sdparm will be more useful
> on your cd/dvd drive than that disk :-)

Yeah, I just don't need to spin 'em up/down ;)

As I said ealier, I'll keep looking; just got back in the saddle.
I cc'd to linux-scsi, in case someone has interesting input.

--=20
Kind regards,
Mogens Valentin


=2E.but the others are way beyond behind!
   -- Kim, a good friend

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

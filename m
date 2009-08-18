From: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: mpt2sas logged messages
Date: Tue, 18 Aug 2009 20:37:51 +0200
Message-ID: <ac3eb2510908181137ne79d4d7he1731d240bca614c@mail.gmail.com>
References: <4A8AAA26.9090706@redhat.com> <20090818132518.GA4418@kroah.com>
	<4A8AB3DC.4060805@redhat.com> <20090818145710.GA6064@kroah.com>
	<4A8ACE7C.5080501@redhat.com> <20090818164017.GA24305@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.248]:2201 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779AbZHRSiF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Aug 2009 14:38:05 -0400
Received: by an-out-0708.google.com with SMTP id d40so3503271and.1
        for <linux-scsi@vger.kernel.org>; Tue, 18 Aug 2009 11:38:06 -0700 (PDT)
In-Reply-To: <20090818164017.GA24305@kroah.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: Ric Wheeler <rwheeler@redhat.com>, linux-scsi@vger.kernel.org, Tom Coughlan <coughlan@redhat.com>

On Tue, Aug 18, 2009 at 18:40, Greg KH<greg@kroah.com> wrote:
> On Tue, Aug 18, 2009 at 11:53:32AM -0400, Ric Wheeler wrote:
>> On 08/18/2009 10:57 AM, Greg KH wrote:
>> > On Tue, Aug 18, 2009 at 09:59:56AM -0400, Ric Wheeler wrote:
>> >
>> >> On 08/18/2009 09:25 AM, Greg KH wrote:
>> >>
>> >>> On Tue, Aug 18, 2009 at 09:18:30AM -0400, Ric Wheeler wrote:
>> >>>
>> >>>> We have a new toy to test very large& =C2=A0 slow storage with =
built up from 5
>> >>>> SAS expansion shelves (Promise Vtrak J-Class) with 60 S-ATA dri=
ves and
>> >>>> 16 SAS drives (the S-ATA drives each have a Promise Vtrak S-ATA=
 MUX
>> >>>> adapter daughter card in the disk sled).
>> >>>>
>> >>>> The basic idea is to build a cheap& =C2=A0 slow test bed for fi=
le& =C2=A0 storage
>> >>>> system scalability. Collectively, we have about 120TB (raw) of =
capacity
>> >>>> to play with in one server.
>> >>>>
>> >>>> As we work through various issues, a couple of oddities popped =
out.
>> >>>>
>> >>>> The first is that udev grumbles during boot about "file name to=
o long"
>> >>>> like the following:
>> >>>>
>> >>>> Aug 17 06:49:58 megadeth udevd-event[20447]: unable to create d=
b file
>> >>>> '/dev/.udev/db/\x2fdevices\x2fpci0000:00\x2f0000:00:04.0\x2f000=
0:17:00.0\x2f0000:18:0a.0\x2f0000:1f:00.0\x2fhost11\x2fport-11:0\x2fexp=
ander-11:0\x2fport-11:0:0\x2fexpander-11:1\x2fport-11:1:0\x2fexpander-1=
1:2\x2fport-11:2:17\x2fexpander-11:3\x2fport-11:3:1\x2fend_device-11:3:=
1\x2fbsg\x2fend_device-11:3:1':
>> >>>> File name too long
>
> Ok, it looks like the way that udev handles it's internal "database"
> can't handle paths that are larger than a single filename size.
>
> Kay, I think this is all yours :)

Yeah, seems so. Linux can not have filenames longer than 256. We'll
need to change the way we store the DEVPATH in a filename. I'll look
into it.

Thanks,
Kay
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

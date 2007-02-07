From: Mark Rustad <mrustad@gmail.com>
Subject: Re: aic79xx noise on hot insert in 2.6.19.x and 2.6.20
Date: Wed, 7 Feb 2007 13:07:52 -0600
Message-ID: <902A15AF-2552-41DB-B74C-861E31E3E7FD@gmail.com>
References: <C33207EA-8376-4A2F-828C-23B00327C42D@gmail.com> <45C995D0.70108@us.ibm.com> <45C9A5AD.3010102@suse.de>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=WINDOWS-1252;
	delsp=yes	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.251]:21402 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030600AbXBGTHy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Feb 2007 14:07:54 -0500
Received: by an-out-0708.google.com with SMTP id b33so254704ana
        for <linux-scsi@vger.kernel.org>; Wed, 07 Feb 2007 11:07:53 -0800 (PST)
In-Reply-To: <45C9A5AD.3010102@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Darrick J. Wong" <djwong@us.ibm.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Feb 7, 2007, at 4:10 AM, Hannes Reinecke wrote:

> Darrick J. Wong wrote:
>> Mark Rustad wrote:
>>> I have systems with Supermicro X6-class (Nocona/Lindenhurst)
>>> motherboards with Adaptec SCSI and SAFTE backplanes running softwar=
e
>>> RAID-1 (md) on a pair of drives. When I hot-insert a drive, I get =20
>>> a lot
>>> of noise from the kernel apparently due to lack of handling =20
>>> something in
>>> the interrupt routine. So far, life seems to go on after the =20
>>> event, but
>>> not knowing anything about the internals of the driver, I am =20
>>> concerned
>>> enough to want to ask about it.
>>
>> I see the noise too, though I don't know enough about aic79xx (and a=
m
>> too busy with aic94xx) to do anything about it.  As far as I can =20
>> tell,
>> the driver's just being a little trigger happy with the "DUMP CARD
>> STATE" routine.  But that's my totally unqualified opinion. :)
>>
> Yeah, that's default behaviour with aic79xx. First complain and then
> check if it actually was an error.
>
> But anyway, looks like it was actually my fault. Might be an idea to
> clear the bus reset flag again.
>
> Care to try the attached patch?

Happy to try it. Of course the dump card state noise went away, but =20
now upon drive insert I see the following messages:

scsi0: Someone reset channel A
scsi0: Someone reset channel A
scsi0: Someone reset channel A
scsi0: Someone reset channel A
scsi0: Someone reset channel A
scsi0: Someone reset channel A
scsi0: Someone reset channel A
scsi0: Someone reset channel A
scsi0: Someone reset channel A
scsi0: Someone reset channel A
scsi0: Someone reset channel A
scsi0: Someone reset channel A
scsi0: Someone reset channel A
scsi0: Someone reset channel A
scsi0: Someone reset channel A
scsi0: Someone reset channel A
scsi0: Someone reset channel A
scsi0: Someone reset channel A
scsi0: Someone reset channel A
scsi0: Someone reset channel A
sd 0:0:5:0: Attempting to queue a TARGET RESET message:CDB:
scsi0: Device reset code sleeping
(scsi0:A:5:0): Task Management Func 0x8 Complete
Recovery SCB completes
scsi0: device overrun (status 9) on 0:5:0
scsi0: Device reset returning 0x2002
md: unbind<sdb2>
md: export_rdev(sdb2)
md: unbind<sdb3>
md: export_rdev(sdb3)
md: unbind<sdb5>
md: export_rdev(sdb5)
md: unbind<sdb6>
md: export_rdev(sdb6)
SCSI device sdb: 71132959 512-byte hdwr sectors (36420 MB)
sdb: Write Protect is off
sdb: Mode Sense: cb 00 00 08
SCSI device sdb: write cache: disabled, read cache: enabled, doesn't =20
support DPO or FUA
sdb: unknown partition table
SCSI device sdb: 71132959 512-byte hdwr sectors (36420 MB)
sdb: Write Protect is off
sdb: Mode Sense: cb 00 00 08
SCSI device sdb: write cache: disabled, read cache: enabled, doesn't =20
support DPO or FUA
sdb: sdb1 sdb2 sdb3 sdb4 < sdb5 sdb6 >

In other respects, the system is as before =96 life continues, the re-=20
established RAIDs resync, etc. Interestingly, the RAIDs are recyncing =20
in a different order than I usually see, but that is probably not =20
very significant.

--=20
Mark Rustad, MRustad@gmail.com


-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

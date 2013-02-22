From: Darren Lavender <dcl@hppine99.uksr.hp.com>
Subject: Re: [Patch][RFC] st: provide tape statistics via sysfs
Date: Fri, 22 Feb 2013 11:29:47 +0000
Message-ID: <512756AB.2040504@hppine99.uksr.hp.com>
References: <DDB9C85B850785449757F9914A034FCB34340D6F@G4W3219.americas.hpqcorp.net> <1361530259.2372.28.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g1t0029.austin.hp.com ([15.216.28.36]:29950 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756320Ab3BVL3u (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Feb 2013 06:29:50 -0500
In-Reply-To: <1361530259.2372.28.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "Seymour, Shane M" <shane.seymour@hp.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Hi James

On 22/02/13 10:50, James Bottomley wrote:
> On Fri, 2013-02-22 at 02:11 +0000, Seymour, Shane M wrote:
>> First forgive me for using outlook for this, if there are any issues=
 with what I sent let me know and I'll send it again from gmail. This i=
s also my first attempt at a kernel patch so please be gentle.
>>
>> This patch was written to enable tape statistics via sysfs for the d=
t
>> driver based on kernel 3.8.0-rc6. It creates two new files in sysfs
>> and is based on work done previously in 2005 by Kai M=E4kisara. Any
>> feedback would be greatly appreciated.
>
> I'm afraid we can't do it the way you're proposing.  files in sysfs m=
ust
> conform to the one value per file rule (so we avoid the ABI nastiness
> that plagues /proc).  You can create a stat directory with a bunch of
> files, but not a single file that gives all values.

That was initially my understanding, but when I looked at this the prec=
edent had already been set, see for example the block subsys:

[root@darwin ~]# grep . /sys/block/sd*/stat
/sys/block/sda/stat:   27351     6890   609272   228129    36810   9207=
27  7660304  1333950        0   556889  1562009
/sys/block/sdb/stat:    2369     6762    18890    39003        0       =
 0        0        0        0     4059    39002
[root@darwin ~]#

I can only assume it was implemented this way for the sake of efficienc=
y, eg avoid a huge amount of file open/read/close calls in sar/iostat. =
 It's not unusual for us to see a thousand block devices on enterprise =
servers, multiply that by the number of above entries and you would be =
talking about 11 x block-dev-count per iostat read iteration.  Okay for=
 tapes we typically don't see anything like this number but the patch j=
ust follows the precedent set with the block device.  Nevertheless, if =
opinion is really strong against this we could split each stat out in t=
o a single file.




>> Assuming sysfs is mounted at /sys the first file
>> is /sys/bus/scsi/drivers/st/drives which gives a single number
>> indicating what the largest tape drive instance assigned by st_probe
>> in the st module is. If it's 4 it possible that st0, st1, st2, and s=
t3
>> exist on the system. Since tape drives can later be disconnected the=
y
>> don't have to exist, the count is a hint so it's possible to gather
>> statistics in a loop with an upper bound. This makes it easier in
>> iostat to gather statistcs.
>
> I don't really get why you need this.  What's wrong with getting the
> exact information from /sys/class/scsi_tape?

Again efficiency. The sys/class/scsi_tape is a per device entry whilst =
/sys/bus/scsi/drivers/st is essentially a global, it seems to make more=
 sense to place a number-of-attached devices here than on a repeated pe=
r device basis, especially if for example st0 later disappears, perfect=
ly possible with SAN based devices.  If we don't have some hint as to t=
he number of devices currently attached then you don't have any clue as=
 to the device iteration range.

Darren

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

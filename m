From: Chris Clayton <chris2553@googlemail.com>
Subject: Re: 2.6.30-rc8 Oops whilst booting
Date: Mon, 8 Jun 2009 13:53:02 +0100
Message-ID: <c6b1100b0906080553o2aa77a40pe0077b1b10a7d88a@mail.gmail.com>
References: <200906061959.55592.chris2553@googlemail.com>
	 <200906062215.30571.chris2553@googlemail.com>
	 <1244381140.30664.12.camel@ht.satnam>
	 <c6b1100b0906071138g2c46fb34vc1a2beb9438f1f1e@mail.gmail.com>
	 <1244413881.18742.31.camel@ht.satnam>
	 <2f9e3044bafcae848f74a1492b0ea471.squirrel@neil.brown.name>
	 <c6b1100b0906080108y191bb157n67ec681ade2a0d13@mail.gmail.com>
	 <c6b1100b0906080358y4033c402ra236eff3f972d169@mail.gmail.com>
	 <1244460875.12644.2.camel@ht.satnam>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ew0-f210.google.com ([209.85.219.210]:51265 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113AbZFHMxC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Jun 2009 08:53:02 -0400
In-Reply-To: <1244460875.12644.2.camel@ht.satnam>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: NeilBrown <neilb@suse.de>, linux-kernel@vger.kernel.org, James Bottomley <james.bottomley@hansenpartnership.com>, scsi <linux-scsi@vger.kernel.org>, Tejun Heo <tj@kernel.org>, Arjan van de Ven <arjan@linux.intel.com>, Linus Torvalds <torvalds@linux-foundation.org>

2009/6/8 Jaswinder Singh Rajput <jaswinder@kernel.org>:
> Hello Chris,
>
> On Mon, 2009-06-08 at 11:58 +0100, Chris Clayton wrote:
>> 2009/6/8 Chris Clayton <chris2553@googlemail.com>:
>> > Hi Neil,
>> >
>> > Thanks for the reply.
>> >
>> > 2009/6/7 NeilBrown <neilb@suse.de>:
>> >> On Mon, June 8, 2009 8:31 am, Jaswinder Singh Rajput wrote:
>> >>> On Sun, 2009-06-07 at 19:38 +0100, Chris Clayton wrote:
>> >>>> 2009/6/7 Jaswinder Singh Ra
>> >>>> >> > http://img231.imageshack.us/img231/8931/dscn0610.jpg
>> >>
>> >> This message says that it found a vfat filesystem on 8:3x (I cann=
ot see
>> >> what digit should be 'x'). =A0That is probably sdc1 or sdc2. Mayb=
e even
>> >> sdc6 or sdc7.
>> >> However the vfat filesystem didn't have /sbin/init.
>> >>
>> >
>> >>>> http://img99.imageshack.us/my.php?image=3Ddscn0617b.jpg
>> >>
>> >> This one says it couldn't find anything at 8,22, which I think
>> >> should be sdb6.
>> >> It also shows that you have and sdc6, but sdb only goes up to sdb=
3.
>> >>
>> >> So it seems that your disk drives have changed name - not a whole=
ly
>> >> unexpected event these days.
>> >>
>> >> We now need answers to questions like:
>> >> =A0- what device do you expect the root filesystem to be on
>> >> =A0- how is the kernel being told this? =A0Maybe it is hard coded
>> >> =A0 =A0into your initrd. =A0Knowing which distro and what /etc/fs=
tab
>> >> =A0 =A0says might help (though it wouldn't help me, I'm just abou=
t out
>> >> =A0 =A0of my depth at this point)
>> >> Maybe if you changed /etc/fstab to mount by uuid instead of hardc=
oding
>> >> e.g. /etc/sdb3, and then run "mkinitramfs" or whatever, it might =
work.
>> >>
>> >
>> > Yes, I've just been looking at the photographs of the panics again=
 and
>> > I've noticed that two of my discs are being detected in the "wrong
>> > order". There are three HDDS. The first, /dev/sda, is the master o=
n
>> > the first IDE port and contains sda1..sda7. The second, normally
>> > /dev/sdb, is the slave on that port and contains sdb1..sdb6. The
>> > third, normally /dev/sdc, is attached to the first SATA port and
>> > contains sdc1..sdc3. The second photograph I posted shows that sdb=
 and
>> > sdc have been reversed. The first partition on the disc that is
>> > normally /dev/sdb does indeed have a FAT32 filesystem in the first
>> > partition.
>> >
>> > By the way, I should have said that in between the panics that the=
 two
>> > photographs show, I copied contents of /dev/sdc1, which I normally
>> > boot from, to /dev/sdb6, so that I minimised the risk to sdc1 in t=
he
>> > reboot festival that bisecting would involve. I also, of course,
>> > changed the name of the root partition that is passed to the kerne=
l by
>> > GRUB and amended /etc/fstab on /dev/sdb6. That's why the partition=
s
>> > shown in the photographs seem inconsistent. Sorry I forgot to ment=
ion
>> > that - I really shouldn't do these things late at night :-).
>> >
>> > As I indicate above, when booting the partition I have set up to d=
o
>> > this bisecting, =A0I expect the root filesystem to be on /dev/hdb6=
=2E As I
>> > also indicate, this information is passed to the kernel through GR=
UB's
>> > /boot/grub/menu.lst. The kernel is configured specifically for my
>> > system and the drivers needed to boot the system are built in to t=
he
>> > kernel, so I don't use an initrd. IIRC, that's the way Slackware i=
s
>> > installed today, except, of course, it's a big fat kernel with all
>> > drivers needed to boot any system built in. I could be wrong on th=
at
>> > though, it's a while since I installed
>> >
>> > As to the distro, it used to be (the now defunct) Peanut Linux, wh=
ich
>> > was derived from Slackware. However, it's years since I installed =
it
>> > and I have upgraded just about everything in user space and added =
many
>> > other things (udev, dbus...). I don't think that makes any differe=
nce
>> > here, though, because we don't get as far as user space. On a
>> > successful boot, the system is stable and runs trouble-free for
>> > several hours a day, every day.
>> >
>> > Hope this helps.
>> >
>> > I'm a good way through bisecting again and this time the system ha=
s to
>> > boot without a panic 100 times before I mark a kernel as good. I'l=
l
>> > post the result later.
>> >
>>
>> Finally got to the end of the bisection/reboot festival. I ended up =
here:
>>
>> [chris:~/kernel/linux-2.6]$ git bisect good
>> d5a877e8dd409d8c702986d06485c374b705d340 is first bad commit
>> commit d5a877e8dd409d8c702986d06485c374b705d340
>> Author: James Bottomley <James.Bottomley@HansenPartnership.com>
>> Date: =A0 Sun May 24 13:03:43 2009 -0700
>>
>> =A0 =A0 async: make sure independent async domains can't accidentall=
y entangle
>>
>> =A0 =A0 The problem occurs when async_synchronize_full_domain() is c=
alled when
>> =A0 =A0 the async_pending list is not empty. =A0This will cause lowe=
st_running()
>> =A0 =A0 to return the cookie of the first entry on the async_pending=
 list, which
>> =A0 =A0 might be nothing at all to do with the domain being asked fo=
r and thus
>> =A0 =A0 cause the domain synchronization to wait for an unrelated do=
main. =A0 This
>> =A0 =A0 can cause a deadlock if domain synchronization is used from =
one domain
>> =A0 =A0 to wait for another.
>>
>> =A0 =A0 Fix by running over the async_pending list to see if any pen=
ding items
>> =A0 =A0 actually belong to our domain (and return their cookies if t=
hey do).
>>
>> =A0 =A0 Signed-off-by: James Bottomley <James.Bottomley@HansenPartne=
rship.com>
>> =A0 =A0 Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
>> =A0 =A0 Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org=
>
>>
>> :040000 040000 fab1e0c06572605a7015061db4a7e0a77c04fa91
>> 34252dbb7fed3942f5952c25639564bbd77357da M =A0 =A0 =A0kernel
>>
>> I can't claim to know what the change actually means, but the change
>> seems to be a much better candidate than my previous bisection outco=
me
>> where I required only 20 "panicless" boots to regard the kernel as
>> good. As I said earlier today, this time I required 100 such boots.
>>
>> I'll revert that change, give the new kernel the reboot treatment :-=
)
>> and report back later.
>>
>
> Good work. Please also share this info with other signed-off members,=
 So
> adding CC.
>

OK. I reversed that change and built and installed the kernel. It has
withstood 100 reboots without a panic. Additionally, I pulled the
latest changes (that will be rc8-git5, I think) from kernel.org,
reversed the change to that kernel and built and installed it. That
too withstood 100 reboots without a panic.

Let me know if there's anything else I can do to help fix this.

Chris


> Thanks,
> --
> JSR
>
>



--=20
No, Sir; there is nothing which has yet been contrived by man, by
which so much happiness is produced as by a good tavern or inn -
Doctor Samuel Johnson
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

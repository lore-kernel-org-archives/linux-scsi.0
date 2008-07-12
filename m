From: "Alessandro Suardi" <alessandro.suardi@gmail.com>
Subject: Re: [Cbe-oss-dev] [regression/bisected] corrupt CD data after media change and delay
Date: Sat, 12 Jul 2008 14:08:26 +0200
Message-ID: <5a4c581d0807120508m758df950i76fabdb70dfa2d07@mail.gmail.com>
References: <Pine.LNX.4.64.0806061458300.6228@vixen.sonytel.be>
	 <Pine.LNX.4.64.0806131932350.30730@vixen.sonytel.be>
	 <5a4c581d0806180147qf8fc731y527c79bfb73401b2@mail.gmail.com>
	 <Pine.LNX.4.64.0806181156460.13297@vixen.sonytel.be>
	 <5a4c581d0806180515g5f24e9d9m85369bfa0a5f2228@mail.gmail.com>
	 <5a4c581d0806210718m77be63c9l444d8d7d7a5266bd@mail.gmail.com>
	 <Pine.LNX.4.64.0806221018220.9736@vixen.sonytel.be>
	 <5a4c581d0806220614seab6598ufa798d8642295495@mail.gmail.com>
	 <5a4c581d0807111425r72e39528w841e24a9b956c245@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754786AbYGLMIj@vger.kernel.org>
In-Reply-To: <5a4c581d0807111425r72e39528w841e24a9b956c245@mail.gmail.com>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: linux-scsi@vger.kernel.org, Linux Kernel Development <linux-kernel@vger.kernel.org>, "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, Maarten Bressers <mbres@gentoo.org>, Daniel Drake <dsd@gentoo.org>, Cell Broadband Engine OSS Development <cbe-oss-dev@ozlabs.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, Jul 11, 2008 at 11:25 PM, Alessandro Suardi
<alessandro.suardi@gmail.com> wrote:
> On Sun, Jun 22, 2008 at 3:14 PM, Alessandro Suardi
> <alessandro.suardi@gmail.com> wrote:
>> On Sun, Jun 22, 2008 at 10:18 AM, Geert Uytterhoeven
>> <Geert.Uytterhoeven@sonycom.com> wrote:
>>> On Sat, 21 Jun 2008, Alessandro Suardi wrote:
>>>> On Wed, Jun 18, 2008 at 2:15 PM, Alessandro Suardi
>>>> <alessandro.suardi@gmail.com> wrote:
>>>> > On Wed, Jun 18, 2008 at 1:13 PM, Geert Uytterhoeven
>>>> > <Geert.Uytterhoeven@sonycom.com> wrote:
>>>> >> On Wed, 18 Jun 2008, Alessandro Suardi wrote:
>>>> >>> On Fri, Jun 13, 2008 at 7:33 PM, Geert Uytterhoeven
>>>> >>> <Geert.Uytterhoeven@sonycom.com> wrote:
>>>> >>> > On Fri, 6 Jun 2008, Geert Uytterhoeven wrote:
>>>> >>> >> When mounting a CD/DVD more than 30 seconds after inserting it, and reading
>>>> >>> >> from it, we get:
>>>> >>> >
>>>> >>> > Apparently the fix didn't make it to all the CCed lists...
>>>> >>> >
>>>> >>> > http://git.kernel.org/?p=linux%2Fkernel%2Fgit%2Fjejb%2Fscsi-rc-fixes-2.6.git;a=commitdiff_plain;h=d1daeabf0da5bfa1943272ce508e2ba785730bf0
>>>> >>>
>>>> >>> Oh, that's in mainline ? I still have the problem of having to
>>>> >>
>>>> >> Not yet, it's in the scsi-rc-fixes-2.6 tree.
>>>> >>
>>>> >>>  insert DVD / try accessing it and get errors / eject / re-insert
>>>> >>>  and then it magically works... the messages have changed
>>>> >>>  from what they were as reported here
>>>> >>>
>>>> >>> http://bugzilla.kernel.org/show_bug.cgi?id=10116
>>>> >>>
>>>> >>>  (see comments #8 and #9) to these ones, in 2.6.26-rc6-git4:
>>>> >>>
>>>> >>> Jun 17 22:38:43 sandman kernel: sr 1:0:0:0: [sr0] Result:
>>>> >>> hostbyte=0x00 driverbyte=0x08
>>>> >>> Jun 17 22:38:43 sandman kernel: sr 1:0:0:0: [sr0] Sense Key : 0x3 [current]
>>>> >>> Jun 17 22:38:43 sandman kernel: sr 1:0:0:0: [sr0] ASC=0x11 ASCQ=0x0
>>>> >>> Jun 17 22:38:43 sandman kernel: end_request: I/O error, dev sr0, sector 232
>>>> >>> Jun 17 22:38:43 sandman kernel: Buffer I/O error on device sr0, logical block 29
>>>> >>> Jun 17 22:38:43 sandman kernel: Buffer I/O error on device sr0, logical block 30
>>>> >>> Jun 17 22:38:43 sandman kernel: Buffer I/O error on device sr0, logical block 31
>>>> >>> Jun 17 22:38:43 sandman kernel: Buffer I/O error on device sr0, logical block 32
>>>> >>> Jun 17 22:38:43 sandman kernel: Buffer I/O error on device sr0, logical block 33
>>>> >>> Jun 17 22:38:43 sandman kernel: Buffer I/O error on device sr0, logical block 34
>>>> >>> Jun 17 22:38:43 sandman kernel: Buffer I/O error on device sr0, logical block 35
>>>> >>> Jun 17 22:38:43 sandman kernel: Buffer I/O error on device sr0, logical block 36
>>>> >>> Jun 17 22:38:43 sandman kernel: Buffer I/O error on device sr0, logical block 37
>>>> >>> Jun 17 22:38:43 sandman kernel: Buffer I/O error on device sr0, logical block 38
>>>> >>>
>>>> >>> here I eject and reinsert the disc, and:
>>>> >>>
>>>> >>> Jun 17 22:39:10 sandman kernel: UDF-fs: No VRS found
>>>> >>>
>>>> >>>  lo and behold, no problem.
>>>> >>>
>>>> >>> This does not, alas, happen every time. It might be at the first
>>>> >>>  DVD access after booting the laptop, but I haven't investigated
>>>> >>>  in this detail yet.
>>>> >>
>>>> >> Does /sys/block/sr0/size reflect the correct size of the DVD?
>>>> >>
>>>> >> Did you try applying the patch?
>>>> >
>>>> > ATM I'm away from home (as usual), I'll post back when
>>>> >  I have the info you asked for and tried applying the
>>>> >  above patch. Thanks !
>>>>
>>>> Sigh. I haven't been able to reproduce the problem once since
>>>>  I posted this. Will keep trying...
>>>
>>> Perhaps because the fix is now in mainline?
>>
>> Eh, that may be a reason :)
>>
>> I'm indeed tracking mainline and haven't reproduced with
>>  at least six different discs in -rc7.
>
> Just had the symptoms again in -rc9-git9 :(
>
> Relevant part of dmesg:
>
> <mount -r /cdrom, access file with gmplayer>
>
> SELinux: initialized (dev fuse, type fuse), uses genfs_contexts
> ISO 9660 Extensions: Microsoft Joliet Level 3
> ISO 9660 Extensions: RRIP_1991A
> SELinux: initialized (dev sr0, type iso9660), uses genfs_contexts
> attempt to access beyond end of device
> sr0: rw=0, want=8442516, limit=2097151
> Buffer I/O error on device sr0, logical block 2110628
> attempt to access beyond end of device
> sr0: rw=0, want=8442520, limit=2097151
> Buffer I/O error on device sr0, logical block 2110629
> attempt to access beyond end of device
> sr0: rw=0, want=8442524, limit=2097151
> Buffer I/O error on device sr0, logical block 2110630
> attempt to access beyond end of device
> sr0: rw=0, want=8442528, limit=2097151
> Buffer I/O error on device sr0, logical block 2110631
> attempt to access beyond end of device
> sr0: rw=0, want=8442532, limit=2097151
> Buffer I/O error on device sr0, logical block 2110632
> attempt to access beyond end of device
> sr0: rw=0, want=8442536, limit=2097151
> Buffer I/O error on device sr0, logical block 2110633
> attempt to access beyond end of device
> sr0: rw=0, want=8442540, limit=2097151
> Buffer I/O error on device sr0, logical block 2110634
> attempt to access beyond end of device
> sr0: rw=0, want=8442544, limit=2097151
> Buffer I/O error on device sr0, logical block 2110635
> attempt to access beyond end of device
> sr0: rw=0, want=8442516, limit=2097151
> Buffer I/O error on device sr0, logical block 2110628
> attempt to access beyond end of device
> sr0: rw=0, want=8442520, limit=2097151
> Buffer I/O error on device sr0, logical block 2110629
> attempt to access beyond end of device
> sr0: rw=0, want=8442516, limit=2097151
> attempt to access beyond end of device
> sr0: rw=0, want=8442520, limit=2097151
> attempt to access beyond end of device
> sr0: rw=0, want=8442516, limit=2097151
> attempt to access beyond end of device
> sr0: rw=0, want=8442520, limit=2097151
> attempt to access beyond end of device
> sr0: rw=0, want=8442516, limit=2097151
> attempt to access beyond end of device
> sr0: rw=0, want=8442520, limit=2097151
> attempt to access beyond end of device
> sr0: rw=0, want=8442516, limit=2097151
> attempt to access beyond end of device
> sr0: rw=0, want=8442520, limit=2097151
> attempt to access beyond end of device
> sr0: rw=0, want=8442516, limit=2097151
> attempt to access beyond end of device
> sr0: rw=0, want=8442520, limit=2097151
> attempt to access beyond end of device
> sr0: rw=0, want=8442516, limit=2097151
> attempt to access beyond end of device
> sr0: rw=0, want=8442520, limit=2097151
> attempt to access beyond end of device
> sr0: rw=0, want=8442516, limit=2097151
> attempt to access beyond end of device
> sr0: rw=0, want=8442520, limit=2097151
> attempt to access beyond end of device
> sr0: rw=0, want=8442516, limit=2097151
> attempt to access beyond end of device
> sr0: rw=0, want=8442520, limit=2097151
> attempt to access beyond end of device
> sr0: rw=0, want=8442516, limit=2097151
> attempt to access beyond end of device
> sr0: rw=0, want=8442520, limit=2097151
> attempt to access beyond end of device
> sr0: rw=0, want=8442516, limit=2097151
> attempt to access beyond end of device
> sr0: rw=0, want=8442520, limit=2097151
> attempt to access beyond end of device
> sr0: rw=0, want=8442516, limit=2097151
> attempt to access beyond end of device
> sr0: rw=0, want=8442520, limit=2097151
> attempt to access beyond end of device
> sr0: rw=0, want=8442516, limit=2097151
> attempt to access beyond end of device
> sr0: rw=0, want=8442520, limit=2097151
> attempt to access beyond end of device
> sr0: rw=0, want=8442516, limit=2097151
> attempt to access beyond end of device
> sr0: rw=0, want=8442520, limit=2097151
> attempt to access beyond end of device
> sr0: rw=0, want=8442516, limit=2097151
> attempt to access beyond end of device
> sr0: rw=0, want=8442520, limit=2097151
> attempt to access beyond end of device
> sr0: rw=0, want=8442516, limit=2097151
> attempt to access beyond end of device
> sr0: rw=0, want=8442520, limit=2097151
> attempt to access beyond end of device
> sr0: rw=0, want=8442516, limit=2097151
> attempt to access beyond end of device
> sr0: rw=0, want=8442520, limit=2097151
> attempt to access beyond end of device
> sr0: rw=0, want=8442516, limit=2097151
> attempt to access beyond end of device
> sr0: rw=0, want=8442520, limit=2097151
> attempt to access beyond end of device
> sr0: rw=0, want=8442516, limit=2097151
> attempt to access beyond end of device
> sr0: rw=0, want=8442520, limit=2097151
> attempt to access beyond end of device
> sr0: rw=0, want=8442516, limit=2097151
> attempt to access beyond end of device
> sr0: rw=0, want=8442520, limit=2097151
> attempt to access beyond end of device
> sr0: rw=0, want=8442516, limit=2097151
> attempt to access beyond end of device
> sr0: rw=0, want=8442520, limit=2097151
> attempt to access beyond end of device
> sr0: rw=0, want=8442516, limit=2097151
> attempt to access beyond end of device
> sr0: rw=0, want=8442520, limit=2097151
> attempt to access beyond end of device
> sr0: rw=0, want=8442516, limit=2097151
> attempt to access beyond end of device
> sr0: rw=0, want=8442520, limit=2097151
> attempt to access beyond end of device
> sr0: rw=0, want=8442516, limit=2097151
> attempt to access beyond end of device
> sr0: rw=0, want=8442520, limit=2097151
> attempt to access beyond end of device
> sr0: rw=0, want=8442516, limit=2097151
> attempt to access beyond end of device
> sr0: rw=0, want=8442520, limit=2097151
> attempt to access beyond end of device
> sr0: rw=0, want=8442516, limit=2097151
> attempt to access beyond end of device
> sr0: rw=0, want=8442520, limit=2097151
> attempt to access beyond end of device
> sr0: rw=0, want=8442516, limit=2097151
> attempt to access beyond end of device
> sr0: rw=0, want=8442520, limit=2097151
> attempt to access beyond end of device
> sr0: rw=0, want=8442516, limit=2097151
> attempt to access beyond end of device
> sr0: rw=0, want=8442520, limit=2097151
> attempt to access beyond end of device
> sr0: rw=0, want=8442516, limit=2097151
> attempt to access beyond end of device
> sr0: rw=0, want=8442520, limit=2097151
> attempt to access beyond end of device
> sr0: rw=0, want=8442516, limit=2097151
> attempt to access beyond end of device
> sr0: rw=0, want=8442520, limit=2097151
>
> <here I eject, reinsert and remount the DVD>
>
> UDF-fs: No VRS found
> ISO 9660 Extensions: Microsoft Joliet Level 3
> ISO 9660 Extensions: RRIP_1991A
> SELinux: initialized (dev sr0, type iso9660), uses genfs_contexts
>
> <now works fine>
>
> Have to say that I didn't wait N seconds in the beginning,
>  but just rather
>
>  - plop cdrom in
>  - close tray
>  - mount -r /cdrom while disc is still spinning
>
> Unfortunately I only have this after eject/remount:
>
> [asuardi@sandman ~]$ cat /sys/block/sr0/size
> 9133120
>
> Final note, as I said earlier in the thread, this is definitely
>  an occurrence of first device access after boot - as I just
>  rebooted:
>
> [asuardi@sandman ~]$ uptime
>  23:25:28 up 17 min,  6 users,  load average: 0.09, 0.18, 0.15
> [asuardi@sandman ~]$ uname -a
> Linux sandman 2.6.26-rc9-git9 #7 Fri Jul 11 21:59:15 CEST 2008 i686
> i686 i386 GNU/Linux

And yet again, in 2.6.26-rc9-git10 freshly compiled/booted,
 when trying to access the Fedora9 DVD to install a bunch
 of packages needed to build SDLmame...

SELinux: initialized (dev fuse, type fuse), uses genfs_contexts
ISO 9660 Extensions: Microsoft Joliet Level 3
ISO 9660 Extensions: RRIP_1991A
SELinux: initialized (dev sr0, type iso9660), uses genfs_contexts
attempt to access beyond end of device
sr0: rw=0, want=3291924, limit=2097151
Buffer I/O error on device sr0, logical block 822980
attempt to access beyond end of device
sr0: rw=0, want=3291928, limit=2097151
Buffer I/O error on device sr0, logical block 822981
attempt to access beyond end of device
sr0: rw=0, want=3291932, limit=2097151
Buffer I/O error on device sr0, logical block 822982
attempt to access beyond end of device
sr0: rw=0, want=3291936, limit=2097151
Buffer I/O error on device sr0, logical block 822983
attempt to access beyond end of device
sr0: rw=0, want=3291940, limit=2097151
Buffer I/O error on device sr0, logical block 822984
attempt to access beyond end of device
sr0: rw=0, want=3291944, limit=2097151
Buffer I/O error on device sr0, logical block 822985
attempt to access beyond end of device
sr0: rw=0, want=3291948, limit=2097151
Buffer I/O error on device sr0, logical block 822986
attempt to access beyond end of device
sr0: rw=0, want=3291952, limit=2097151
Buffer I/O error on device sr0, logical block 822987
attempt to access beyond end of device
sr0: rw=0, want=3291924, limit=2097151
Buffer I/O error on device sr0, logical block 822980
attempt to access beyond end of device
sr0: rw=0, want=3291928, limit=2097151
Buffer I/O error on device sr0, logical block 822981
attempt to access beyond end of device
sr0: rw=0, want=3291924, limit=2097151
attempt to access beyond end of device
sr0: rw=0, want=3291928, limit=2097151
[asuardi@sandman sdlmame0126]$ h | grep siz
  958  cat /sys/block/sr0/size
 1031  h | grep siz
[asuardi@sandman sdlmame0126]$ !958
cat /sys/block/sr0/size
6993536

<eject, remount DVD>

[asuardi@sandman sdlmame0126]$ !mount
mount -r /cdrom
[asuardi@sandman sdlmame0126]$ cat /sys/block/sr0/size
6993536

<now everything works fine>

Possibly a new bug then - since size is always the same ?

--alessandro

 "Give me love / Or give me hate
 Give me anything that's not just ok"

 (Sophia, 'Weightless')

From: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
Subject: RE: [scsi] RE: mptscsih: ioc2: attempting task abort! (sc=e733b280)
Date: Mon, 16 Nov 2009 17:52:36 +0530
Message-ID: <0D1E8821739E724A86F4D16902CE275C1C93C74829@inbmail01.lsi.com>
References: <20091109132302.50317f5a.akpm@linux-foundation.org>
 <0D1E8821739E724A86F4D16902CE275C1C93C0401E@inbmail01.lsi.com>
 <alpine.LNX.2.01.0911131103520.16724@filesrv1.baby-dragons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:55905 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753781AbZKPMXC convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Nov 2009 07:23:02 -0500
In-Reply-To: <alpine.LNX.2.01.0911131103520.16724@filesrv1.baby-dragons.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, "Moore, Eric" <Eric.Moore@lsi.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>


> -----Original Message-----
> From: Mr. James W. Laferriere [mailto:babydr@baby-dragons.com]
> Sent: Saturday, November 14, 2009 1:49 AM
> To: Desai, Kashyap
> Cc: Andrew Morton; Moore, Eric; linux-scsi@vger.kernel.org
> Subject: Re: [scsi] RE: mptscsih: ioc2: attempting task abort!
> (sc=e733b280)
>
>       Hello Kashyap ,
>
> On Tue, 10 Nov 2009, Desai, Kashyap wrote:
>
> > If your concern is repeated log message " mptscsih: ioc2: attempting
> task
> >abort! (sc=e733b280)", It is intentional debug message in mptfusion.
> > Since SCSI IOs are getting timed out driver is printing this message.
> > - Kashyap
>
>       Yes ,  That is part of my concern .  That message is continuously
> being
> dumped into logs when a device quits responding during a media failure .
> At
> least this is the effect during a media failure in my setup .  But please
> read
> on there is more .
>

Got this point. It is part of your concern. I will plan to target major issue first which you have explained below.

>       IT NEVER ENDS a shutdown & removal of the effected device is
> REQUIRED
> to silence it .  If you just reboot ,  it just starts all over again when
> that
> device is accessed in any form .  The administrator is UNABLE to remotely
> hot dismount/remove the effected device .  All the tools I have seen will
> not
> allow me to remove the device (electronically) from a mount point or from
> an
> array (md) because it is still being accessed by the DRIVER .  IE: I/O is
> still
> detined to the device due to the driver re-examining the device over &
> over .
> Please stop this or give the administrator metheds to remove the drive
> from the
> system electronically !
>

For this I may need few more mail exchanges to understand problem in detail to root cause the issue. I have seen in logs Domain Validation is going into continues loop. I am trying to find out other important debug message from existing logs itself. Meanwhile, Can I expect some more debug logs. In mptfusion we have standard debug level 0x8188.

"echo 0x8188 > /sys/class/scsi_host/hostX/debug_level" is steps to enable debug level.


>
>       The contiuous dumping of error/warning messages would be nice to be
> able to have a method to stop them in /sys or /proc when one has recorded
> the
> failure to be worked on during the next maintenance period .  OR even if
> someone were to create a configurable limiter for the message per
> device/lun/???
> .
Noted this. I will plan for it once main issue is solved.

>
>               Tia ,  JimL
>
> ps:   Please stop top posting .

Thanks for suggestion. Changed my outlook reply post style.

>
> > -----Original Message-----
> > From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Andrew Morton
> > Sent: Tuesday, November 10, 2009 2:53 AM
> > To: Moore, Eric
> > Cc: Mr. James W. Laferriere; linux-scsi@vger.kernel.org
> > Subject: [scsi] Fw: mptscsih: ioc2: attempting task abort! (sc=e733b280)
> >
> > (cc's altered)
> >
> > The below bug report appears to be unresponded-to.
> >
> >
> >
> > Begin forwarded message:
> >
> > Date: Fri, 23 Oct 2009 09:30:52 -0800 (AKDT)
> > From: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
> > To: Linux Kernel Maillist <linux-kernel@vger.kernel.org>
> > Cc: DL-MPTFusionLinux@lsi.com
> > Subject: [scsi] mptscsih: ioc2: attempting task abort! (sc=e733b280)
> >
> >
> >        Hello LSIFusion support team & All ,
> >
> >        That message has been repeating for an extrememly long time
> (Days) on
> > one drive that I was running a 'dd'(*) on .
> >        I was particularly happy to see hundreds of MB/s on a single U320
> drive
> > (LOL) when all th eothers were ~ 62-68 MB/s .
> >
> >        My main question is -WHEN- Is this forever repeating on a broken
> drive
> > going to be fixed ?
> >        Many people have complained & moaned & Bi???ed about this since
> the code
> > came out .
> >        Can the maintainers PLEASE fix this BD approach to recovery ?
> >
> >                Tia ,  JimL
> >
> > (*)     ( time for ((XXX=0; XXX<=5; XXX++)); do dd if=/dev/zero
> of=/dev/sde bs=1048576 count=140299; done ) 2>&1 | tee -a dev-sde-
> format.log
> >
> > 140299+0 records in
> > 140299+0 records out
> > 147114164224 bytes (147 GB) copied, 886.437 seconds, 166 MB/s
> > 140299+0 records in
> > 140299+0 records out
> > 147114164224 bytes (147 GB) copied, 679.693 seconds, 216 MB/s
> > 140299+0 records in
> > 140299+0 records out
> > 147114164224 bytes (147 GB) copied, 1404.15 seconds, 105 MB/s
> > 140299+0 records in
> > 140299+0 records out
> > 147114164224 bytes (147 GB) copied, 1025.8 seconds, 143 MB/s
> >
> >
> >
> > # /usr/src/linux/scripts/ver_linux | tee -a ~/mptscsi-20091023.log
> >
> > If some fields are empty or look unusual you may have an old version.
> > Compare to the current minimal requirements in Documentation/Changes.
> >
> > Linux (none) 2.6.30.6 #1 SMP Sun Oct 11 18:36:23 UTC 2009 i686 pentium4
> i386 GNU/Linux
> >
> > Gnu C                  3.4.6
> > Gnu make               3.81
> > binutils               2.15.92.0.2
> > util-linux             2.12r
> > mount                  2.12r
> > module-init-tools      3.2.2
> > e2fsprogs              1.38
> > jfsutils               1.1.11
> > reiserfsprogs          3.6.19
> > xfsprogs               2.8.10
> > pcmciautils            014
> > pcmcia-cs              3.2.8
> > quota-tools            3.13.
> > PPP                    2.4.4
> > Linux C Library        2.3.6
> > Dynamic linker (ldd)   2.3.6
> > Linux C++ Library      6.0.3
> > Procps                 3.2.7
> > Net-tools              1.60
> > Kbd                    1.12
> > oprofile               0.9.1
> > Sh-utils               5.97
> > udev                   097
> > Modules Loaded
> >
> >
> > # grep 'Oct 23 17:13' /var/log//kernel | tee -a ~/mptscsi-20091023.log
> >
> > Oct 23 17:13:00 (none) kernel:  [<c0166090>] ? worker_thread+0x0/0xc0
> > Oct 23 17:13:00 (none) kernel:  [<c0169ba6>] kthread+0x66/0xb0
> > Oct 23 17:13:00 (none) kernel:  [<c0169b40>] ? kthread+0x0/0xb0
> > Oct 23 17:13:00 (none) kernel:  [<c012331b>]
> kernel_thread_helper+0x7/0x1c
> > Oct 23 17:13:00 (none) kernel: sd 2:0:2:0: [sde] Result:
> hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
> > Oct 23 17:13:00 (none) kernel: end_request: I/O error, dev sde, sector
> 21200
> > Oct 23 17:13:00 (none) kernel: __ratelimit: 1014 callbacks suppressed
> > Oct 23 17:13:00 (none) kernel: Buffer I/O error on device sde, logical
> block 2650
> > Oct 23 17:13:00 (none) kernel: lost page write due to I/O error on sde
> > Oct 23 17:13:00 (none) kernel: Buffer I/O error on device sde, logical
> block 2651
> > Oct 23 17:13:00 (none) kernel: lost page write due to I/O error on sde
> > Oct 23 17:13:00 (none) kernel:  target2:0:2: Domain Validation Initial
> Inquiry Failed
> > Oct 23 17:13:00 (none) kernel: sd 2:0:2:0: [sde] Unhandled error code
> > Oct 23 17:13:00 (none) kernel: sd 2:0:2:0: [sde] Result:
> hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
> > Oct 23 17:13:00 (none) kernel: end_request: I/O error, dev sde, sector
> 32560
> > Oct 23 17:13:01 (none) kernel: Buffer I/O error on device sde, logical
> block 4070
> > Oct 23 17:13:01 (none) kernel: lost page write due to I/O error on sde
> > Oct 23 17:13:01 (none) kernel: Buffer I/O error on device sde, logical
> block 4071
> > Oct 23 17:13:01 (none) kernel: lost page write due to I/O error on sde
> > Oct 23 17:13:01 (none) kernel: Buffer I/O error on device sde, logical
> block 4072
> > Oct 23 17:13:01 (none) kernel: lost page write due to I/O error on sde
> > Oct 23 17:13:01 (none) kernel: Buffer I/O error on device sde, logical
> block 4073
> > Oct 23 17:13:01 (none) kernel: lost page write due to I/O error on sde
> > Oct 23 17:13:01 (none) kernel: Buffer I/O error on device sde, logical
> block 4074
> > Oct 23 17:13:01 (none) kernel: lost page write due to I/O error on sde
> > Oct 23 17:13:01 (none) kernel: Buffer I/O error on device sde, logical
> block 4075
> > Oct 23 17:13:01 (none) kernel: lost page write due to I/O error on sde
> > Oct 23 17:13:01 (none) kernel: Buffer I/O error on device sde, logical
> block 4076
> > Oct 23 17:13:01 (none) kernel: lost page write due to I/O error on sde
> > Oct 23 17:13:02 (none) kernel: Buffer I/O error on device sde, logical
> block 4077
> > Oct 23 17:13:02 (none) kernel: lost page write due to I/O error on sde
> > Oct 23 17:13:02 (none) kernel:  target2:0:2: Ending Domain Validation
> > Oct 23 17:13:02 (none) kernel:  target2:0:2: asynchronous
> > Oct 23 17:13:02 (none) kernel:  target2:0:3: Beginning Domain Validation
> > Oct 23 17:13:02 (none) kernel:  target2:0:3: Domain Validation skipping
> write tests
> > Oct 23 17:13:02 (none) kernel:  target2:0:3: Ending Domain Validation
> > Oct 23 17:13:02 (none) kernel:  target2:0:3: asynchronous
> > Oct 23 17:13:02 (none) kernel:  target2:0:6: Beginning Domain Validation
> > Oct 23 17:13:02 (none) kernel:  target2:0:6: Ending Domain Validation
> > Oct 23 17:13:02 (none) kernel:  target2:0:6: asynchronous
> > Oct 23 17:13:02 (none) kernel:  target3:0:0: mptspi: ioc3: mpt_config
> failed
> > Oct 23 17:13:02 (none) kernel:  target3:0:1: mptspi: ioc3: mpt_config
> failed
> > Oct 23 17:13:02 (none) kernel:  target2:0:0: Beginning Domain Validation
> > Oct 23 17:13:02 (none) kernel:  target2:0:0: Ending Domain Validation
> > Oct 23 17:13:03 (none) kernel:  target2:0:0: FAST-160 WIDE SCSI 320.0
> MB/s DT IU QAS RTI (6.25 ns, offset 127)
> > Oct 23 17:13:03 (none) kernel:  target2:0:1: Beginning Domain Validation
> > Oct 23 17:13:03 (none) kernel:  target2:0:1: Ending Domain Validation
> > Oct 23 17:13:03 (none) kernel:  target2:0:1: FAST-160 WIDE SCSI 320.0
> MB/s DT IU QAS RTI (6.25 ns, offset 127)
> > Oct 23 17:13:03 (none) kernel:  target2:0:2: Beginning Domain Validation
> > Oct 23 17:13:03 (none) kernel: sd 2:0:2:0: timing out command, waited
> 180s
> > Oct 23 17:13:03 (none) kernel: sd 2:0:2:0: [sde] Unhandled error code
> > Oct 23 17:13:03 (none) kernel: sd 2:0:2:0: [sde] Result: hostbyte=DID_OK
> driverbyte=DRIVER_OK
> > Oct 23 17:13:03 (none) kernel: end_request: I/O error, dev sde, sector
> 12160
> > Oct 23 17:13:03 (none) kernel:  target2:0:2: Domain Validation skipping
> write tests
> > Oct 23 17:13:03 (none) kernel:  target2:0:2: Ending Domain Validation
> > Oct 23 17:13:03 (none) kernel:  target2:0:2: FAST-160 WIDE SCSI 320.0
> MB/s DT IU QAS RTI (6.25 ns, offset 127)
> > Oct 23 17:13:03 (none) kernel:  target2:0:3: Beginning Domain Validation
> > Oct 23 17:13:03 (none) kernel:  target2:0:3: Domain Validation skipping
> write tests
> > Oct 23 17:13:04 (none) kernel:  target2:0:3: Ending Domain Validation
> > Oct 23 17:13:04 (none) kernel:  target2:0:3: asynchronous
> > Oct 23 17:13:04 (none) kernel:  target2:0:6: Beginning Domain Validation
> > Oct 23 17:13:04 (none) kernel:  target2:0:6: Ending Domain Validation
> > Oct 23 17:13:04 (none) kernel:  target2:0:6: asynchronous
> > Oct 23 17:13:04 (none) kernel:  target3:0:0: mptspi: ioc3: mpt_config
> failed
> > Oct 23 17:13:04 (none) kernel:  target3:0:1: mptspi: ioc3: mpt_config
> failed
> > Oct 23 17:13:04 (none) kernel:  target2:0:0: Beginning Domain Validation
> > Oct 23 17:13:04 (none) kernel:  target2:0:0: Ending Domain Validation
> > Oct 23 17:13:04 (none) kernel:  target2:0:0: FAST-160 WIDE SCSI 320.0
> MB/s DT IU QAS RTI (6.25 ns, offset 127)
> > Oct 23 17:13:04 (none) kernel:  target2:0:1: Beginning Domain Validation
> > Oct 23 17:13:04 (none) kernel:  target2:0:1: Ending Domain Validation
> > Oct 23 17:13:04 (none) kernel:  target2:0:1: FAST-160 WIDE SCSI 320.0
> MB/s DT IU QAS RTI (6.25 ns, offset 127)
> > Oct 23 17:13:04 (none) kernel: mptscsih: ioc2: attempting task abort!
> (sc=e733b280)
> > Oct 23 17:13:04 (none) kernel: sd 2:0:2:0: [sde] CDB: Write(10): 2a 00
> 00 00 28 78 00 04 00 00
> > Oct 23 17:13:04 (none) kernel: mptbase: ioc2: Initiating recovery
> > Oct 23 17:13:05 (none) kernel: sd 2:0:2:0: mptscsih: ioc2: completing
> cmds: fw_channel 0, fw_id 2, sc=f61d6980, mf = f5c82bc0, idx=a
> > Oct 23 17:13:05 (none) kernel: sd 2:0:2:0: mptscsih: ioc2: completing
> cmds: fw_channel 0, fw_id 2, sc=e4f3e280, mf = f5c849c0, idx=5a
> > Oct 23 17:13:05 (none) kernel: sd 2:0:2:0: mptscsih: ioc2: completing
> cmds: fw_channel 0, fw_id 2, sc=d9d70d80, mf = f5c84fc0, idx=6a
> > Oct 23 17:13:05 (none) kernel: sd 2:0:2:0: mptscsih: ioc2: completing
> cmds: fw_channel 0, fw_id 2, sc=ec8c5980, mf = f5c85080, idx=6c
> > Oct 23 17:13:05 (none) kernel: sd 2:0:2:0: mptscsih: ioc2: completing
> cmds: fw_channel 0, fw_id 2, sc=f36b1380, mf = f5c853e0, idx=75
> > Oct 23 17:13:05 (none) kernel: sd 2:0:2:0: mptscsih: ioc2: completing
> cmds: fw_channel 0, fw_id 2, sc=e733b280, mf = f5c858c0, idx=82
> > Oct 23 17:13:05 (none) kernel: sd 2:0:2:0: mptscsih: ioc2: completing
> cmds: fw_channel 0, fw_id 2, sc=ddb97580, mf = f5c85920, idx=83
> > Oct 23 17:13:05 (none) kernel: sd 2:0:2:0: mptscsih: ioc2: completing
> cmds: fw_channel 0, fw_id 2, sc=d9d70480, mf = f5c85b60, idx=89
> > Oct 23 17:13:05 (none) kernel: sd 2:0:2:0: mptscsih: ioc2: completing
> cmds: fw_channel 0, fw_id 2, sc=f61d6a80, mf = f5c85e00, idx=90
> > Oct 23 17:13:05 (none) kernel: sd 2:0:2:0: mptscsih: ioc2: completing
> cmds: fw_channel 0, fw_id 2, sc=f36b1480, mf = f5c85e60, idx=91
> > Oct 23 17:13:05 (none) kernel: sd 2:0:2:0: mptscsih: ioc2: completing
> cmds: fw_channel 0, fw_id 2, sc=e53d1a80, mf = f5c85f20, idx=93
> > Oct 23 17:13:05 (none) kernel: sd 2:0:2:0: mptscsih: ioc2: completing
> cmds: fw_channel 0, fw_id 2, sc=e4fcb080, mf = f5c86100, idx=98
> > Oct 23 17:13:05 (none) kernel: sd 2:0:2:0: mptscsih: ioc2: completing
> cmds: fw_channel 0, fw_id 2, sc=eb409b80, mf = f5c86220, idx=9b
> > Oct 23 17:13:05 (none) kernel: sd 2:0:2:0: mptscsih: ioc2: completing
> cmds: fw_channel 0, fw_id 2, sc=e2282c80, mf = f5c86400, idx=a0
> > Oct 23 17:13:05 (none) kernel: sd 2:0:2:0: mptscsih: ioc2: completing
> cmds: fw_channel 0, fw_id 2, sc=e2282480, mf = f5c86460, idx=a1
> > Oct 23 17:13:05 (none) kernel: sd 2:0:2:0: mptscsih: ioc2: completing
> cmds: fw_channel 0, fw_id 2, sc=e4094180, mf = f5c86520, idx=a3
> > Oct 23 17:13:06 (none) kernel: sd 2:0:2:0: mptscsih: ioc2: completing
> cmds: fw_channel 0, fw_id 2, sc=d9d70280, mf = f5c86580, idx=a4
> > Oct 23 17:13:06 (none) kernel: sd 2:0:2:0: mptscsih: ioc2: completing
> cmds: fw_channel 0, fw_id 2, sc=de43a280, mf = f5c86700, idx=a8
> > Oct 23 17:13:06 (none) kernel: sd 2:0:2:0: mptscsih: ioc2: completing
> cmds: fw_channel 0, fw_id 2, sc=d9d70a80, mf = f5c86760, idx=a9
> > Oct 23 17:13:06 (none) kernel: sd 2:0:2:0: mptscsih: ioc2: completing
> cmds: fw_channel 0, fw_id 2, sc=ee78b580, mf = f5c867c0, idx=aa
> > Oct 23 17:13:06 (none) kernel: sd 2:0:2:0: mptscsih: ioc2: completing
> cmds: fw_channel 0, fw_id 2, sc=e39c9c80, mf = f5c86880, idx=ac
> > Oct 23 17:13:06 (none) kernel: sd 2:0:2:0: mptscsih: ioc2: completing
> cmds: fw_channel 0, fw_id 2, sc=f61d6380, mf = f5c86d00, idx=b8
> > Oct 23 17:13:06 (none) kernel: sd 2:0:2:0: mptscsih: ioc2: completing
> cmds: fw_channel 0, fw_id 2, sc=f61d6180, mf = f5c86d60, idx=b9
> > Oct 23 17:13:06 (none) kernel: sd 2:0:2:0: mptscsih: ioc2: completing
> cmds: fw_channel 0, fw_id 2, sc=d8811780, mf = f5c86e80, idx=bc
> > Oct 23 17:13:06 (none) kernel: sd 2:0:2:0: mptscsih: ioc2: completing
> cmds: fw_channel 0, fw_id 2, sc=ee755580, mf = f5c86ee0, idx=bd
> > Oct 23 17:13:06 (none) kernel: sd 2:0:2:0: mptscsih: ioc2: completing
> cmds: fw_channel 0, fw_id 2, sc=f36b1080, mf = f5c86f40, idx=be
> > Oct 23 17:13:06 (none) kernel: sd 2:0:2:0: mptscsih: ioc2: completing
> cmds: fw_channel 0, fw_id 2, sc=e53d1b80, mf = f5c87060, idx=c1
> > Oct 23 17:13:06 (none) kernel: sd 2:0:2:0: mptscsih: ioc2: completing
> cmds: fw_channel 0, fw_id 2, sc=d9d70180, mf = f5c871e0, idx=c5
> > Oct 23 17:13:06 (none) kernel: sd 2:0:2:0: mptscsih: ioc2: completing
> cmds: fw_channel 0, fw_id 2, sc=f61d6b80, mf = f5c87240, idx=c6
> > Oct 23 17:13:06 (none) kernel: sd 2:0:2:0: mptscsih: ioc2: completing
> cmds: fw_channel 0, fw_id 2, sc=f36b1280, mf = f5c87540, idx=ce
> > Oct 23 17:13:06 (none) kernel: sd 2:0:2:0: mptscsih: ioc2: completing
> cmds: fw_channel 0, fw_id 2, sc=e2282780, mf = f5c875a0, idx=cf
> > Oct 23 17:13:07 (none) kernel: sd 2:0:2:0: mptscsih: ioc2: completing
> cmds: fw_channel 0, fw_id 2, sc=d9d70880, mf = f5c87900, idx=d8
> > Oct 23 17:13:07 (none) kernel: sd 2:0:2:0: mptscsih: ioc2: completing
> cmds: fw_channel 0, fw_id 2, sc=e39c9b80, mf = f5c879c0, idx=da
> > Oct 23 17:13:07 (none) kernel: sd 2:0:2:0: mptscsih: ioc2: completing
> cmds: fw_channel 0, fw_id 2, sc=ec8c5c80, mf = f5c87b40, idx=de
> > Oct 23 17:13:07 (none) kernel: sd 2:0:2:0: mptscsih: ioc2: completing
> cmds: fw_channel 0, fw_id 2, sc=ec8c5880, mf = f5c87d20, idx=e3
> > Oct 23 17:13:07 (none) kernel: sd 2:0:2:0: mptscsih: ioc2: completing
> cmds: fw_channel 0, fw_id 2, sc=e53d1c80, mf = f5c87d80, idx=e4
> > Oct 23 17:13:07 (none) kernel: sd 2:0:2:0: mptscsih: ioc2: completing
> cmds: fw_channel 0, fw_id 2, sc=e4fdcd80, mf = f5c87de0, idx=e5
> > Oct 23 17:13:07 (none) kernel: sd 2:0:2:0: mptscsih: ioc2: completing
> cmds: fw_channel 0, fw_id 2, sc=e4094b80, mf = f5c87ea0, idx=e7
> > Oct 23 17:13:07 (none) kernel: sd 2:0:2:0: mptscsih: ioc2: completing
> cmds: fw_channel 0, fw_id 2, sc=e4094680, mf = f5c87fc0, idx=ea
> > Oct 23 17:13:07 (none) kernel: sd 2:0:2:0: mptscsih: ioc2: completing
> cmds: fw_channel 0, fw_id 2, sc=f36b1180, mf = f5c88320, idx=f3
> > Oct 23 17:13:07 (none) kernel: sd 2:0:2:0: mptscsih: ioc2: completing
> cmds: fw_channel 0, fw_id 2, sc=e2282980, mf = f5c883e0, idx=f5
> > Oct 23 17:13:07 (none) kernel: sd 2:0:2:0: mptscsih: ioc2: completing
> cmds: fw_channel 0, fw_id 2, sc=e53d1e80, mf = f5c885c0, idx=fa
> > Oct 23 17:13:07 (none) kernel: sd 2:0:2:0: mptscsih: ioc2: completing
> cmds: fw_channel 0, fw_id 2, sc=ec8c5e80, mf = f5c886e0, idx=fd
> > Oct 23 17:13:07 (none) kernel: mptscsih: ioc2: Issue of TaskMgmt failed!
> > Oct 23 17:13:07 (none) kernel: mptscsih: ioc2: task abort: FAILED
> (sc=e733b280)
> > Oct 23 17:13:07 (none) kernel: mptscsih: ioc2: attempting task abort!
> (sc=e53d1b80)
> > Oct 23 17:13:07 (none) kernel: sd 2:0:2:0: [sde] CDB: Write(10): 2a 00
> 00 00 53 18 00 00 08 00
> > Oct 23 17:13:08 (none) kernel: mptscsih: ioc2: task abort: SUCCESS
> (sc=e53d1b80)
> > Oct 23 17:13:08 (none) kernel: mptscsih: ioc2: attempting task abort!
> (sc=f36b1280)
> > Oct 23 17:13:08 (none) kernel: sd 2:0:2:0: [sde] CDB: Write(10): 2a 00
> 00 00 14 b0 00 00 20 00
> > Oct 23 17:13:08 (none) kernel: mptscsih: ioc2: task abort: SUCCESS
> (sc=f36b1280)
> > Oct 23 17:13:08 (none) kernel: mptscsih: ioc2: attempting task abort!
> (sc=d9d70480)
> > Oct 23 17:13:08 (none) kernel: sd 2:0:2:0: [sde] CDB: Write(10): 2a 00
> 00 00 4e 88 00 03 98 00
> > Oct 23 17:13:08 (none) kernel: mptscsih: ioc2: task abort: SUCCESS
> (sc=d9d70480)
> > Oct 23 17:13:08 (none) kernel: mptscsih: ioc2: attempting task abort!
> (sc=f61d6a80)
> > Oct 23 17:13:08 (none) kernel: sd 2:0:2:0: [sde] CDB: Write(10): 2a 00
> 00 00 52 70 00 00 28 00
> > Oct 23 17:13:08 (none) kernel: mptscsih: ioc2: task abort: SUCCESS
> (sc=f61d6a80)
> > Oct 23 17:13:08 (none) kernel: mptscsih: ioc2: attempting task abort!
> (sc=f36b1480)
> > Oct 23 17:13:08 (none) kernel: sd 2:0:2:0: [sde] CDB: Write(10): 2a 00
> 00 00 10 08 00 04 00 00
> > Oct 23 17:13:08 (none) kernel: mptscsih: ioc2: task abort: SUCCESS
> (sc=f36b1480)
> > Oct 23 17:13:09 (none) kernel: mptscsih: ioc2: attempting task abort!
> (sc=e53d1a80)
> > Oct 23 17:13:09 (none) kernel: sd 2:0:2:0: [sde] CDB: Write(10): 2a 00
> 00 00 53 20 00 00 10 00
> > Oct 23 17:13:09 (none) kernel: mptscsih: ioc2: task abort: SUCCESS
> (sc=e53d1a80)
> > Oct 23 17:13:09 (none) kernel: mptscsih: ioc2: attempting task abort!
> (sc=d9d70180)
> > Oct 23 17:13:09 (none) kernel: sd 2:0:2:0: [sde] CDB: Write(10): 2a 00
> 00 00 30 48 00 00 28 00
> > Oct 23 17:13:09 (none) kernel: mptscsih: ioc2: task abort: SUCCESS
> (sc=d9d70180)
> > Oct 23 17:13:09 (none) kernel: mptscsih: ioc2: attempting task abort!
> (sc=e4fcb080)
> > Oct 23 17:13:09 (none) kernel: sd 2:0:2:0: [sde] CDB: Write(10): 2a 00
> 00 00 17 30 00 04 00 00
> > Oct 23 17:13:09 (none) kernel: mptscsih: ioc2: task abort: SUCCESS
> (sc=e4fcb080)
> > Oct 23 17:13:09 (none) kernel: mptscsih: ioc2: attempting task abort!
> (sc=eb409b80)
> > Oct 23 17:13:09 (none) kernel: sd 2:0:2:0: [sde] CDB: Write(10): 2a 00
> 00 00 5b 30 00 04 00 00
> > Oct 23 17:13:09 (none) kernel: mptscsih: ioc2: task abort: SUCCESS
> (sc=eb409b80)
> > Oct 23 17:13:09 (none) kernel: mptscsih: ioc2: attempting task abort!
> (sc=ee78b580)
> > Oct 23 17:13:09 (none) kernel: sd 2:0:2:0: [sde] CDB: Write(10): 2a 00
> 00 00 36 50 00 00 28 00
> > Oct 23 17:13:09 (none) kernel: mptscsih: ioc2: task abort: SUCCESS
> (sc=ee78b580)
> > Oct 23 17:13:10 (none) kernel: mptscsih: ioc2: attempting task abort!
> (sc=e2282780)
> > Oct 23 17:13:10 (none) kernel: sd 2:0:2:0: [sde] CDB: Write(10): 2a 00
> 00 00 2f c8 00 00 28 00
> > Oct 23 17:13:10 (none) kernel: mptscsih: ioc2: task abort: SUCCESS
> (sc=e2282780)
> > Oct 23 17:13:10 (none) kernel: mptscsih: ioc2: attempting task abort!
> (sc=e39c9c80)
> > Oct 23 17:13:10 (none) kernel: sd 2:0:2:0: [sde] CDB: Write(10): 2a 00
> 00 00 33 48 00 03 08 00
> > Oct 23 17:13:10 (none) kernel: mptscsih: ioc2: task abort: SUCCESS
> (sc=e39c9c80)
> > Oct 23 17:13:10 (none) kernel: mptscsih: ioc2: attempting task abort!
> (sc=e2282c80)
> > Oct 23 17:13:10 (none) kernel: sd 2:0:2:0: [sde] CDB: Write(10): 2a 00
> 00 00 2f 40 00 00 10 00
> > Oct 23 17:13:10 (none) kernel: mptscsih: ioc2: task abort: SUCCESS
> (sc=e2282c80)
> > Oct 23 17:13:10 (none) kernel: mptscsih: ioc2: attempting task abort!
> (sc=e4094180)
> > Oct 23 17:13:10 (none) kernel: sd 2:0:2:0: [sde] CDB: Write(10): 2a 00
> 00 00 30 d0 00 02 78 00
> > Oct 23 17:13:10 (none) kernel: mptscsih: ioc2: task abort: SUCCESS
> (sc=e4094180)
> > Oct 23 17:13:10 (none) kernel: mptscsih: ioc2: attempting task abort!
> (sc=e2282980)
> > Oct 23 17:13:10 (none) kernel: sd 2:0:2:0: [sde] CDB: Write(10): 2a 00
> 00 00 2f 70 00 00 10 00
> > Oct 23 17:13:10 (none) kernel: mptscsih: ioc2: task abort: SUCCESS
> (sc=e2282980)
> > Oct 23 17:13:10 (none) kernel: mptscsih: ioc2: attempting task abort!
> (sc=e4094680)
> > Oct 23 17:13:11 (none) kernel: sd 2:0:2:0: [sde] CDB: Write(10): 2a 00
> 00 00 15 00 00 00 98 00
> > Oct 23 17:13:11 (none) kernel: mptscsih: ioc2: task abort: SUCCESS
> (sc=e4094680)
> > Oct 23 17:13:11 (none) kernel: mptscsih: ioc2: attempting task abort!
> (sc=ddb97580)
> > Oct 23 17:13:11 (none) kernel: sd 2:0:2:0: [sde] CDB: Write(10): 2a 00
> 00 00 67 30 00 04 00 00
> > Oct 23 17:13:11 (none) kernel: mptscsih: ioc2: task abort: SUCCESS
> (sc=ddb97580)
> > Oct 23 17:13:11 (none) kernel: mptscsih: ioc2: attempting task abort!
> (sc=ee755580)
> > Oct 23 17:13:11 (none) kernel: sd 2:0:2:0: [sde] CDB: Write(10): 2a 00
> 00 00 57 30 00 04 00 00
> > Oct 23 17:13:11 (none) kernel: mptscsih: ioc2: task abort: SUCCESS
> (sc=ee755580)
> > Oct 23 17:13:11 (none) kernel: mptscsih: ioc2: attempting task abort!
> (sc=d9d70880)
> > Oct 23 17:13:11 (none) kernel: sd 2:0:2:0: [sde] CDB: Write(10): 2a 00
> 00 00 2f f0 00 00 10 00
> > Oct 23 17:13:11 (none) kernel: mptscsih: ioc2: task abort: SUCCESS
> (sc=d9d70880)
> > Oct 23 17:13:11 (none) kernel: mptscsih: ioc2: attempting task abort!
> (sc=de43a280)
> > Oct 23 17:13:11 (none) kernel: sd 2:0:2:0: [sde] CDB: Write(10): 2a 00
> 00 00 04 00 00 04 00 00
> > Oct 23 17:13:11 (none) kernel: mptscsih: ioc2: task abort: SUCCESS
> (sc=de43a280)
> > Oct 23 17:13:11 (none) kernel: mptscsih: ioc2: attempting task abort!
> (sc=f36b1180)
> > Oct 23 17:13:11 (none) kernel: sd 2:0:2:0: [sde] CDB: Write(10): 2a 00
> 00 00 14 d0 00 00 20 00
> > Oct 23 17:13:12 (none) kernel: mptscsih: ioc2: task abort: SUCCESS
> (sc=f36b1180)
> > Oct 23 17:13:12 (none) kernel: mptscsih: ioc2: attempting task abort!
> (sc=f61d6380)
> > Oct 23 17:13:12 (none) kernel: sd 2:0:2:0: [sde] CDB: Write(10): 2a 00
> 00 00 52 60 00 00 10 00
> > Oct 23 17:13:12 (none) kernel: mptscsih: ioc2: task abort: SUCCESS
> (sc=f61d6380)
> > Oct 23 17:13:12 (none) kernel: mptscsih: ioc2: attempting task abort!
> (sc=f61d6180)
> > Oct 23 17:13:12 (none) kernel: sd 2:0:2:0: [sde] CDB: Write(10): 2a 00
> 00 00 52 b0 00 00 20 00
> > Oct 23 17:13:12 (none) kernel: mptscsih: ioc2: task abort: SUCCESS
> (sc=f61d6180)
> > Oct 23 17:13:12 (none) kernel: mptscsih: ioc2: attempting task abort!
> (sc=f61d6b80)
> > Oct 23 17:13:12 (none) kernel: sd 2:0:2:0: [sde] CDB: Write(10): 2a 00
> 00 00 52 98 00 00 10 00
> > Oct 23 17:13:12 (none) kernel: mptscsih: ioc2: task abort: SUCCESS
> (sc=f61d6b80)
> > Oct 23 17:13:12 (none) kernel: mptscsih: ioc2: attempting task abort!
> (sc=d9d70280)
> > Oct 23 17:13:12 (none) kernel: sd 2:0:2:0: [sde] CDB: Write(10): 2a 00
> 00 00 30 30 00 00 18 00
> > Oct 23 17:13:12 (none) kernel: mptscsih: ioc2: task abort: SUCCESS
> (sc=d9d70280)
> > Oct 23 17:13:12 (none) kernel: mptscsih: ioc2: attempting task abort!
> (sc=d8811780)
> > Oct 23 17:13:12 (none) kernel: sd 2:0:2:0: [sde] CDB: Write(10): 2a 00
> 00 00 5f 30 00 04 00 00
> > Oct 23 17:13:13 (none) kernel: mptscsih: ioc2: task abort: SUCCESS
> (sc=d8811780)
> > Oct 23 17:13:13 (none) kernel: mptscsih: ioc2: attempting task abort!
> (sc=f36b1080)
> > Oct 23 17:13:13 (none) kernel: sd 2:0:2:0: [sde] CDB: Write(10): 2a 00
> 00 00 14 f0 00 00 10 00
> > Oct 23 17:13:13 (none) kernel: mptscsih: ioc2: task abort: SUCCESS
> (sc=f36b1080)
> > Oct 23 17:13:13 (none) kernel: mptscsih: ioc2: attempting task abort!
> (sc=e2282480)
> > Oct 23 17:13:13 (none) kernel: sd 2:0:2:0: [sde] CDB: Write(10): 2a 00
> 00 00 3a 78 00 04 00 00
> > Oct 23 17:13:13 (none) kernel: mptscsih: ioc2: task abort: SUCCESS
> (sc=e2282480)
> > Oct 23 17:13:13 (none) kernel: mptscsih: ioc2: attempting task abort!
> (sc=f61d6980)
> > Oct 23 17:13:13 (none) kernel: sd 2:0:2:0: [sde] CDB: Write(10): 2a 00
> 00 00 52 38 00 00 10 00
> > Oct 23 17:13:13 (none) kernel: mptscsih: ioc2: task abort: SUCCESS
> (sc=f61d6980)
> > Oct 23 17:13:13 (none) kernel: mptscsih: ioc2: attempting task abort!
> (sc=e4f3e280)
> > Oct 23 17:13:13 (none) kernel: sd 2:0:2:0: [sde] CDB: Write(10): 2a 00
> 00 00 2c 78 00 00 08 00
> > Oct 23 17:13:13 (none) kernel: mptscsih: ioc2: task abort: SUCCESS
> (sc=e4f3e280)
> > Oct 23 17:13:13 (none) kernel: mptscsih: ioc2: attempting task abort!
> (sc=e39c9b80)
> > Oct 23 17:13:13 (none) kernel: sd 2:0:2:0: [sde] CDB: Write(10): 2a 00
> 00 00 52 48 00 00 18 00
> > Oct 23 17:13:13 (none) kernel: mptscsih: ioc2: task abort: SUCCESS
> (sc=e39c9b80)
> > Oct 23 17:13:14 (none) kernel: mptscsih: ioc2: attempting task abort!
> (sc=d9d70d80)
> > Oct 23 17:13:14 (none) kernel: sd 2:0:2:0: [sde] CDB: Write(10): 2a 00
> 00 00 30 88 00 00 18 00
> > Oct 23 17:13:14 (none) kernel: mptscsih: ioc2: task abort: SUCCESS
> (sc=d9d70d80)
> > Oct 23 17:13:14 (none) kernel: mptscsih: ioc2: attempting task abort!
> (sc=e53d1e80)
> > Oct 23 17:13:14 (none) kernel: sd 2:0:2:0: [sde] CDB: Write(10): 2a 00
> 00 00 52 e8 00 00 10 00
> > Oct 23 17:13:14 (none) kernel: mptscsih: ioc2: task abort: SUCCESS
> (sc=e53d1e80)
> > Oct 23 17:13:14 (none) kernel: mptscsih: ioc2: attempting task abort!
> (sc=ec8c5c80)
> > Oct 23 17:13:14 (none) kernel: sd 2:0:2:0: [sde] CDB: Write(10): 2a 00
> 00 00 36 78 00 04 00 00
> > Oct 23 17:13:14 (none) kernel: mptscsih: ioc2: task abort: SUCCESS
> (sc=ec8c5c80)
> > Oct 23 17:13:14 (none) kernel: mptscsih: ioc2: attempting task abort!
> (sc=ec8c5e80)
> > Oct 23 17:13:14 (none) kernel: sd 2:0:2:0: [sde] CDB: Write(10): 2a 00
> 00 00 6f 30 00 04 00 00
> > Oct 23 17:13:14 (none) kernel: mptscsih: ioc2: task abort: SUCCESS
> (sc=ec8c5e80)
> > Oct 23 17:13:14 (none) kernel: mptscsih: ioc2: attempting task abort!
> (sc=ec8c5980)
> > Oct 23 17:13:14 (none) kernel: sd 2:0:2:0: [sde] CDB: Write(10): 2a 00
> 00 00 73 30 00 04 00 00
> > Oct 23 17:13:15 (none) kernel: mptscsih: ioc2: task abort: SUCCESS
> (sc=ec8c5980)
> > Oct 23 17:13:15 (none) kernel: mptscsih: ioc2: attempting task abort!
> (sc=ec8c5880)
> > Oct 23 17:13:15 (none) kernel: sd 2:0:2:0: [sde] CDB: Write(10): 2a 00
> 00 00 6b 30 00 04 00 00
> > Oct 23 17:13:15 (none) kernel: mptscsih: ioc2: task abort: SUCCESS
> (sc=ec8c5880)
> > Oct 23 17:13:15 (none) kernel: mptscsih: ioc2: attempting task abort!
> (sc=d9d70a80)
> > Oct 23 17:13:15 (none) kernel: sd 2:0:2:0: [sde] CDB: Write(10): 2a 00
> 00 00 30 a0 00 00 18 00
> > Oct 23 17:13:15 (none) kernel: mptscsih: ioc2: task abort: SUCCESS
> (sc=d9d70a80)
> > Oct 23 17:13:15 (none) kernel: mptscsih: ioc2: attempting task abort!
> (sc=f36b1380)
> > Oct 23 17:13:15 (none) kernel: sd 2:0:2:0: [sde] CDB: Write(10): 2a 00
> 00 00 14 08 00 00 a8 00
> > Oct 23 17:13:15 (none) kernel: mptscsih: ioc2: task abort: SUCCESS
> (sc=f36b1380)
> > Oct 23 17:13:15 (none) kernel: mptscsih: ioc2: attempting task abort!
> (sc=e53d1c80)
> > Oct 23 17:13:15 (none) kernel: sd 2:0:2:0: [sde] CDB: Write(10): 2a 00
> 00 00 53 10 00 00 08 00
> > Oct 23 17:13:15 (none) kernel: mptscsih: ioc2: task abort: SUCCESS
> (sc=e53d1c80)
> > Oct 23 17:13:15 (none) kernel: mptscsih: ioc2: attempting task abort!
> (sc=e4fdcd80)
> > Oct 23 17:13:15 (none) kernel: sd 2:0:2:0: [sde] CDB: Write(10): 2a 00
> 00 00 3e 78 00 04 00 00
> > Oct 23 17:13:16 (none) kernel: mptscsih: ioc2: task abort: SUCCESS
> (sc=e4fdcd80)
> > Oct 23 17:13:16 (none) kernel: mptscsih: ioc2: attempting task abort!
> (sc=e4094b80)
> > Oct 23 17:13:16 (none) kernel: sd 2:0:2:0: [sde] CDB: Write(10): 2a 00
> 00 00 1c d0 00 03 a8 00
> > Oct 23 17:13:16 (none) kernel: mptscsih: ioc2: task abort: SUCCESS
> (sc=e4094b80)
> > Oct 23 17:13:16 (none) kernel: mptscsih: ioc2: attempting target reset!
> (sc=e733b280)
> > Oct 23 17:13:16 (none) kernel: sd 2:0:2:0: [sde] CDB: Write(10): 2a 00
> 00 00 28 78 00 04 00 00
> > Oct 23 17:13:16 (none) kernel: mptscsih: ioc2: target reset: SUCCESS
> (sc=e733b280)
> > Oct 23 17:13:16 (none) kernel:  target2:0:2: Beginning Domain Validation
> > Oct 23 17:13:16 (none) kernel: sd 2:0:2:0: timing out command, waited
> 180s
> > Oct 23 17:13:16 (none) kernel: sd 2:0:2:0: timing out command, waited
> 180s
> > Oct 23 17:13:16 (none) kernel: sd 2:0:2:0: [sde] Unhandled error code
> > Oct 23 17:13:16 (none) kernel: sd 2:0:2:0: [sde] Result: hostbyte=DID_OK
> driverbyte=DRIVER_OK
> > Oct 23 17:13:16 (none) kernel: end_request: I/O error, dev sde, sector
> 4104
> > Oct 23 17:13:16 (none) kernel: __ratelimit: 125 callbacks suppressed
> > Oct 23 17:13:16 (none) kernel: Buffer I/O error on device sde, logical
> block 513
> > Oct 23 17:13:16 (none) kernel: lost page write due to I/O error on sde
> > Oct 23 17:13:17 (none) kernel: Buffer I/O error on device sde, logical
> block 514
> > Oct 23 17:13:17 (none) kernel: lost page write due to I/O error on sde
> > Oct 23 17:13:17 (none) kernel: Buffer I/O error on device sde, logical
> block 515
> > Oct 23 17:13:17 (none) kernel: lost page write due to I/O error on sde
> > Oct 23 17:13:17 (none) kernel: Buffer I/O error on device sde, logical
> block 516
> > Oct 23 17:13:17 (none) kernel: lost page write due to I/O error on sde
> > Oct 23 17:13:17 (none) kernel: Buffer I/O error on device sde, logical
> block 517
> > Oct 23 17:13:17 (none) kernel: lost page write due to I/O error on sde
> > Oct 23 17:13:17 (none) kernel: Buffer I/O error on device sde, logical
> block 518
> > Oct 23 17:13:17 (none) kernel: lost page write due to I/O error on sde
> > Oct 23 17:13:17 (none) kernel: Buffer I/O error on device sde, logical
> block 519
> > Oct 23 17:13:17 (none) kernel: lost page write due to I/O error on sde
> > Oct 23 17:13:17 (none) kernel: Buffer I/O error on device sde, logical
> block 520
> > Oct 23 17:13:17 (none) kernel: lost page write due to I/O error on sde
> > Oct 23 17:13:17 (none) kernel: Buffer I/O error on device sde, logical
> block 521
> > Oct 23 17:13:17 (none) kernel: lost page write due to I/O error on sde
> > Oct 23 17:13:18 (none) kernel: Buffer I/O error on device sde, logical
> block 522
> > Oct 23 17:13:18 (none) kernel: lost page write due to I/O error on sde
> > Oct 23 17:13:18 (none) kernel: sd 2:0:2:0: timing out command, waited
> 180s
> > Oct 23 17:13:18 (none) kernel: sd 2:0:2:0: [sde] Unhandled error code
> > Oct 23 17:13:18 (none) kernel: sd 2:0:2:0: [sde] Result: hostbyte=DID_OK
> driverbyte=DRIVER_OK
> > Oct 23 17:13:18 (none) kernel: end_request: I/O error, dev sde, sector
> 5936
> > Oct 23 17:13:18 (none) kernel: sd 2:0:2:0: timing out command, waited
> 180s
> > Oct 23 17:13:18 (none) kernel: sd 2:0:2:0: [sde] Unhandled error code
> > Oct 23 17:13:18 (none) kernel: sd 2:0:2:0: [sde] Result: hostbyte=DID_OK
> driverbyte=DRIVER_OK
> > Oct 23 17:13:18 (none) kernel: end_request: I/O error, dev sde, sector
> 23344
> > Oct 23 17:13:18 (none) kernel: sd 2:0:2:0: timing out command, waited
> 180s
> > Oct 23 17:13:18 (none) kernel: sd 2:0:2:0: [sde] Unhandled error code
> > Oct 23 17:13:18 (none) kernel: sd 2:0:2:0: [sde] Result: hostbyte=DID_OK
> driverbyte=DRIVER_OK
> > Oct 23 17:13:18 (none) kernel: end_request: I/O error, dev sde, sector
> 13128
> > Oct 23 17:13:18 (none) kernel: sd 2:0:2:0: timing out command, waited
> 180s
> > Oct 23 17:13:18 (none) kernel: sd 2:0:2:0: [sde] Unhandled error code
> > Oct 23 17:13:19 (none) kernel: sd 2:0:2:0: [sde] Result: hostbyte=DID_OK
> driverbyte=DRIVER_OK
> > Oct 23 17:13:19 (none) kernel: end_request: I/O error, dev sde, sector
> 12496
> > Oct 23 17:13:19 (none) kernel: sd 2:0:2:0: timing out command, waited
> 180s
> > Oct 23 17:13:19 (none) kernel: sd 2:0:2:0: [sde] Unhandled error code
> > Oct 23 17:13:19 (none) kernel: sd 2:0:2:0: timing out command, waited
> 180s
> > Oct 23 17:13:19 (none) kernel: sd 2:0:2:0: [sde] Result: hostbyte=DID_OK
> driverbyte=DRIVER_OK
> > Oct 23 17:13:19 (none) kernel: end_request: I/O error, dev sde, sector
> 26416
> > Oct 23 17:13:19 (none) kernel: sd 2:0:2:0: [sde] Unhandled error code
> > Oct 23 17:13:19 (none) kernel: sd 2:0:2:0: [sde] Result: hostbyte=DID_OK
> driverbyte=DRIVER_OK
> > Oct 23 17:13:19 (none) kernel: end_request: I/O error, dev sde, sector
> 22320
> > Oct 23 17:13:19 (none) kernel: sd 2:0:2:0: timing out command, waited
> 180s
> > Oct 23 17:13:19 (none) kernel: sd 2:0:2:0: [sde] Unhandled error code
> > Oct 23 17:13:19 (none) kernel: sd 2:0:2:0: [sde] Result: hostbyte=DID_OK
> driverbyte=DRIVER_OK
> > Oct 23 17:13:19 (none) kernel: end_request: I/O error, dev sde, sector
> 21280
> > Oct 23 17:13:20 (none) kernel: sd 2:0:2:0: timing out command, waited
> 180s
> > Oct 23 17:13:20 (none) kernel: sd 2:0:2:0: [sde] Unhandled error code
> > Oct 23 17:13:20 (none) kernel: sd 2:0:2:0: [sde] Result: hostbyte=DID_OK
> driverbyte=DRIVER_OK
> > Oct 23 17:13:20 (none) kernel: sd 2:0:2:0: timing out command, waited
> 180s
> > Oct 23 17:13:20 (none) kernel: end_request: I/O error, dev sde, sector
> 12144
> > Oct 23 17:13:20 (none) kernel: sd 2:0:2:0: [sde] Unhandled error code
> > Oct 23 17:13:20 (none) kernel: sd 2:0:2:0: [sde] <3>sd 2:0:2:0: timing
> out command, waited 180s
> > Oct 23 17:13:20 (none) kernel: Result: hostbyte=DID_OK
> driverbyte=DRIVER_OK
> > Oct 23 17:13:20 (none) kernel: end_request: I/O error, dev sde, sector
> 12360
> > Oct 23 17:13:20 (none) kernel: sd 2:0:2:0: [sde] Unhandled error code
> > Oct 23 17:13:20 (none) kernel: sd 2:0:2:0: timing out command, waited
> 180s
> > Oct 23 17:13:20 (none) kernel: sd 2:0:2:0: [sde] Result: hostbyte=DID_OK
> driverbyte=DRIVER_OK
> > Oct 23 17:13:20 (none) kernel: end_request: I/O error, dev sde, sector
> 12096
> > Oct 23 17:13:20 (none) kernel: sd 2:0:2:0: [sde] Unhandled error code
> > Oct 23 17:13:21 (none) kernel: sd 2:0:2:0: [sde] Result: hostbyte=DID_OK
> driverbyte=DRIVER_OK
> > Oct 23 17:13:21 (none) kernel: end_request: I/O error, dev sde, sector
> 5376
> > Oct 23 17:13:21 (none) kernel: sd 2:0:2:0: timing out command, waited
> 180s
> > Oct 23 17:13:21 (none) kernel: sd 2:0:2:0: [sde] Unhandled error code
> > Oct 23 17:13:21 (none) kernel: sd 2:0:2:0: [sde] Result: hostbyte=DID_OK
> driverbyte=DRIVER_OK
> > Oct 23 17:13:21 (none) kernel: end_request: I/O error, dev sde, sector
> 13904
> > Oct 23 17:13:21 (none) kernel: sd 2:0:2:0: timing out command, waited
> 180s
> > Oct 23 17:13:21 (none) kernel: sd 2:0:2:0: [sde] Unhandled error code
> > Oct 23 17:13:21 (none) kernel: sd 2:0:2:0: [sde] Result: hostbyte=DID_OK
> driverbyte=DRIVER_OK
> > Oct 23 17:13:21 (none) kernel: end_request: I/O error, dev sde, sector
> 12272
> > Oct 23 17:13:21 (none) kernel: sd 2:0:2:0: timing out command, waited
> 180s
> > Oct 23 17:13:21 (none) kernel: sd 2:0:2:0: [sde] Unhandled error code
> > Oct 23 17:13:21 (none) kernel: sd 2:0:2:0: [sde] Result: hostbyte=DID_OK
> driverbyte=DRIVER_OK
> > Oct 23 17:13:21 (none) kernel: end_request: I/O error, dev sde, sector
> 12232
> > Oct 23 17:13:22 (none) kernel: sd 2:0:2:0: [sde] Unhandled error code
> > Oct 23 17:13:22 (none) kernel: sd 2:0:2:0: [sde] Result: hostbyte=DID_OK
> driverbyte=DRIVER_OK
> > Oct 23 17:13:22 (none) kernel: end_request: I/O error, dev sde, sector
> 21104
> > Oct 23 17:13:22 (none) kernel: sd 2:0:2:0: timing out command, waited
> 180s
> > Oct 23 17:13:22 (none) kernel: sd 2:0:2:0: [sde] Unhandled error code
> > Oct 23 17:13:22 (none) kernel: sd 2:0:2:0: [sde] Result: hostbyte=DID_OK
> driverbyte=DRIVER_OK
> > Oct 23 17:13:22 (none) kernel: end_request: I/O error, dev sde, sector
> 1024
> > Oct 23 17:13:22 (none) kernel: sd 2:0:2:0: timing out command, waited
> 180s
> > Oct 23 17:13:22 (none) kernel: sd 2:0:2:0: [sde] Unhandled error code
> > Oct 23 17:13:22 (none) kernel: sd 2:0:2:0: [sde] Result: hostbyte=DID_OK
> driverbyte=DRIVER_OK
> > Oct 23 17:13:22 (none) kernel: end_request: I/O error, dev sde, sector
> 5328
> > Oct 23 17:13:22 (none) kernel:  target2:0:2: Domain Validation skipping
> write tests
> > Oct 23 17:13:22 (none) kernel:  target2:0:2: Ending Domain Validation
> > Oct 23 17:13:22 (none) kernel:  target2:0:2: FAST-160 WIDE SCSI 320.0
> MB/s DT IU QAS RTI (6.25 ns, offset 127)
> > Oct 23 17:13:23 (none) kernel:  target2:0:3: Beginning Domain Validation
> > Oct 23 17:13:23 (none) kernel:  target2:0:3: Ending Domain Validation
> > Oct 23 17:13:23 (none) kernel:  target2:0:3: FAST-160 WIDE SCSI 320.0
> MB/s DT IU QAS RTI WRFLOW PCOMP (6.25 ns, offset 63)
> > Oct 23 17:13:23 (none) kernel:  target2:0:6: Beginning Domain Validation
> > Oct 23 17:13:23 (none) kernel:  target2:0:6: Ending Domain Validation
> > Oct 23 17:13:23 (none) kernel:  target2:0:6: asynchronous
> > Oct 23 17:13:23 (none) kernel:  target3:0:0: mptspi: ioc3: mpt_config
> failed
> > Oct 23 17:13:23 (none) kernel:  target3:0:1: mptspi: ioc3: mpt_config
> failed
> > Oct 23 17:13:23 (none) kernel:  target2:0:0: Beginning Domain Validation
> > Oct 23 17:13:23 (none) kernel:  target2:0:0: Ending Domain Validation
> > Oct 23 17:13:23 (none) kernel:  target2:0:0: FAST-160 WIDE SCSI 320.0
> MB/s DT IU QAS RTI (6.25 ns, offset 127)
> > Oct 23 17:13:23 (none) kernel:  target2:0:1: Beginning Domain Validation
> > Oct 23 17:13:23 (none) kernel:  target2:0:1: Ending Domain Validation
> > Oct 23 17:13:23 (none) kernel:  target2:0:1: FAST-160 WIDE SCSI 320.0
> MB/s DT IU QAS RTI (6.25 ns, offset 127)
> > Oct 23 17:13:23 (none) kernel:  target2:0:2: Beginning Domain Validation
> > Oct 23 17:13:24 (none) kernel: sd 2:0:2:0: timing out command, waited
> 180s
> > Oct 23 17:13:24 (none) kernel: sd 2:0:2:0: timing out command, waited
> 180s
> > Oct 23 17:13:24 (none) kernel: sd 2:0:2:0: [sde] Unhandled error code
> > Oct 23 17:13:24 (none) kernel: sd 2:0:2:0: timing out command, waited
> 180s
> > Oct 23 17:13:24 (none) kernel: sd 2:0:2:0: [sde] Result: hostbyte=DID_OK
> driverbyte=DRIVER_OK
> > Oct 23 17:13:24 (none) kernel: end_request: I/O error, dev sde, sector
> 21144
> > Oct 23 17:13:24 (none) kernel: sd 2:0:2:0: [sde] Unhandled error code
> > Oct 23 17:13:24 (none) kernel: sd 2:0:2:0: [sde] Result: hostbyte=DID_OK
> driverbyte=DRIVER_OK
> > Oct 23 17:13:24 (none) kernel: end_request: I/O error, dev sde, sector
> 12336
> > Oct 23 17:13:24 (none) kernel: sd 2:0:2:0: timing out command, waited
> 180s
> > Oct 23 17:13:24 (none) kernel: sd 2:0:2:0: [sde] Unhandled error code
> > Oct 23 17:13:24 (none) kernel: sd 2:0:2:0: [sde] Result: hostbyte=DID_OK
> driverbyte=DRIVER_OK
> > Oct 23 17:13:24 (none) kernel: end_request: I/O error, dev sde, sector
> 24368
> > Oct 23 17:13:24 (none) kernel: sd 2:0:2:0: timing out command, waited
> 180s
> > Oct 23 17:13:24 (none) kernel: sd 2:0:2:0: timing out command, waited
> 180s
> > Oct 23 17:13:25 (none) kernel: sd 2:0:2:0: [sde] Unhandled error code
> > Oct 23 17:13:25 (none) kernel: sd 2:0:2:0: [sde] Unhandled error code
> > Oct 23 17:13:25 (none) kernel: sd 2:0:2:0: [sde] <3>sd 2:0:2:0: timing
> out command, waited 180s
> > Oct 23 17:13:25 (none) kernel: sd 2:0:2:0: [sde] Result: hostbyte=DID_OK
> driverbyte=DRIVER_OK
> > Oct 23 17:13:25 (none) kernel: end_request: I/O error, dev sde, sector
> 14968
> > Oct 23 17:13:25 (none) kernel: sd 2:0:2:0: [sde] Unhandled error code
> > Oct 23 17:13:25 (none) kernel: Result: hostbyte=DID_OK
> driverbyte=DRIVER_OK
> > Oct 23 17:13:25 (none) kernel: sd 2:0:2:0: [sde] <3>end_request: I/O
> error, dev sde, sector 11384
> > Oct 23 17:13:25 (none) kernel: sd 2:0:2:0: timing out command, waited
> 180s
> > Oct 23 17:13:25 (none) kernel: Result: hostbyte=DID_OK
> driverbyte=DRIVER_OK
> > Oct 23 17:13:25 (none) kernel: end_request: I/O error, dev sde, sector
> 21224
> > Oct 23 17:13:25 (none) kernel: sd 2:0:2:0: [sde] Unhandled error code
> > Oct 23 17:13:25 (none) kernel: sd 2:0:2:0: [sde] Result: hostbyte=DID_OK
> driverbyte=DRIVER_OK
> > Oct 23 17:13:26 (none) kernel: sd 2:0:2:0: timing out command, waited
> 180s
> > Oct 23 17:13:26 (none) kernel: end_request: I/O error, dev sde, sector
> 13944
> > Oct 23 17:13:26 (none) kernel: sd 2:0:2:0: [sde] Unhandled error code
> > Oct 23 17:13:26 (none) kernel: sd 2:0:2:0: [sde] Result: hostbyte=DID_OK
> driverbyte=DRIVER_OK
> > Oct 23 17:13:26 (none) kernel: end_request: I/O error, dev sde, sector
> 21064
> > Oct 23 17:13:26 (none) kernel: sd 2:0:2:0: timing out command, waited
> 180s
> > Oct 23 17:13:26 (none) kernel: sd 2:0:2:0: [sde] Unhandled error code
> > Oct 23 17:13:26 (none) kernel: sd 2:0:2:0: [sde] Result: hostbyte=DID_OK
> driverbyte=DRIVER_OK
> > Oct 23 17:13:26 (none) kernel: end_request: I/O error, dev sde, sector
> 12424
> > Oct 23 17:13:26 (none) kernel: sd 2:0:2:0: timing out command, waited
> 180s
> > Oct 23 17:13:26 (none) kernel: sd 2:0:2:0: [sde] Unhandled error code
> > Oct 23 17:13:26 (none) kernel: sd 2:0:2:0: [sde] Result: hostbyte=DID_OK
> driverbyte=DRIVER_OK
> > Oct 23 17:13:26 (none) kernel: end_request: I/O error, dev sde, sector
> 5360
> > Oct 23 17:13:26 (none) kernel: sd 2:0:2:0: timing out command, waited
> 180s
> > Oct 23 17:13:26 (none) kernel: sd 2:0:2:0: [sde] Unhandled error code
> > Oct 23 17:13:27 (none) kernel: sd 2:0:2:0: [sde] Result: hostbyte=DID_OK
> driverbyte=DRIVER_OK
> > Oct 23 17:13:27 (none) kernel: end_request: I/O error, dev sde, sector
> 21048
> > Oct 23 17:13:27 (none) kernel: sd 2:0:2:0: [sde] Unhandled error code
> > Oct 23 17:13:27 (none) kernel: sd 2:0:2:0: [sde] Result: hostbyte=DID_OK
> driverbyte=DRIVER_OK
> > Oct 23 17:13:27 (none) kernel: end_request: I/O error, dev sde, sector
> 5128
> > Oct 23 17:13:27 (none) kernel: sd 2:0:2:0: timing out command, waited
> 180s
> > Oct 23 17:13:27 (none) kernel: sd 2:0:2:0: [sde] Unhandled error code
> > Oct 23 17:13:27 (none) kernel: sd 2:0:2:0: [sde] Result: hostbyte=DID_OK
> driverbyte=DRIVER_OK
> > Oct 23 17:13:27 (none) kernel: end_request: I/O error, dev sde, sector
> 21088
> > Oct 23 17:13:27 (none) kernel: sd 2:0:2:0: timing out command, waited
> 180s
> > Oct 23 17:13:27 (none) kernel: sd 2:0:2:0: [sde] Unhandled error code
> > Oct 23 17:13:27 (none) kernel: sd 2:0:2:0: [sde] Result: hostbyte=DID_OK
> driverbyte=DRIVER_OK
> > Oct 23 17:13:27 (none) kernel: end_request: I/O error, dev sde, sector
> 21168
> > Oct 23 17:13:27 (none) kernel:  target2:0:2: Domain Validation skipping
> write tests
> > Oct 23 17:13:28 (none) kernel:  target2:0:2: Ending Domain Validation
> > Oct 23 17:13:28 (none) kernel:  target2:0:2: FAST-160 WIDE SCSI 320.0
> MB/s DT IU QAS RTI (6.25 ns, offset 127)
> > Oct 23 17:13:28 (none) kernel:  target2:0:3: Beginning Domain Validation
> > Oct 23 17:13:28 (none) kernel:  target2:0:3: Ending Domain Validation
> > Oct 23 17:13:28 (none) kernel:  target2:0:3: FAST-160 WIDE SCSI 320.0
> MB/s DT IU QAS RTI WRFLOW PCOMP (6.25 ns, offset 63)
> > Oct 23 17:13:28 (none) kernel:  target2:0:6: Beginning Domain Validation
> > Oct 23 17:13:28 (none) kernel:  target2:0:6: Ending Domain Validation
> > Oct 23 17:13:28 (none) kernel:  target2:0:6: asynchronous
> > Oct 23 17:13:28 (none) kernel:  target3:0:0: mptspi: ioc3: mpt_config
> failed
> > Oct 23 17:13:28 (none) kernel:  target3:0:1: mptspi: ioc3: mpt_config
> failed
> > Oct 23 17:13:28 (none) kernel:  target2:0:0: Beginning Domain Validation
> > Oct 23 17:13:28 (none) kernel:  target2:0:0: Ending Domain Validation
> > Oct 23 17:13:28 (none) kernel:  target2:0:0: FAST-160 WIDE SCSI 320.0
> MB/s DT IU QAS RTI (6.25 ns, offset 127)
> > Oct 23 17:13:28 (none) kernel:  target2:0:1: Beginning Domain Validation
> > Oct 23 17:13:28 (none) kernel:  target2:0:1: Ending Domain Validation
> > Oct 23 17:13:29 (none) kernel:  target2:0:1: FAST-160 WIDE SCSI 320.0
> MB/s DT IU QAS RTI (6.25 ns, offset 127)
> > Oct 23 17:13:29 (none) kernel:  target2:0:2: Beginning Domain Validation
> > Oct 23 17:13:29 (none) kernel:  target2:0:2: Domain Validation skipping
> write tests
> > Oct 23 17:13:29 (none) kernel:  target2:0:2: Ending Domain Validation
> > Oct 23 17:13:29 (none) kernel:  target2:0:2: FAST-160 WIDE SCSI 320.0
> MB/s DT IU QAS RTI (6.25 ns, offset 127)
> > Oct 23 17:13:29 (none) kernel:  target2:0:3: Beginning Domain Validation
> > Oct 23 17:13:29 (none) kernel:  target2:0:3: Ending Domain Validation
> > Oct 23 17:13:29 (none) kernel:  target2:0:3: FAST-160 WIDE SCSI 320.0
> MB/s DT IU QAS RTI WRFLOW PCOMP (6.25 ns, offset 63)
> > Oct 23 17:13:29 (none) kernel:  target2:0:6: Beginning Domain Validation
> > Oct 23 17:13:29 (none) kernel:  target2:0:6: Ending Domain Validation
> > Oct 23 17:13:29 (none) kernel:  target2:0:6: asynchronous
> > Oct 23 17:13:29 (none) kernel:  target3:0:0: mptspi: ioc3: mpt_config
> failed
> > Oct 23 17:13:29 (none) kernel:  target3:0:1: mptspi: ioc3: mpt_config
> failed
> > Oct 23 17:13:29 (none) kernel:  target2:0:0: Beginning Domain Validation
> > Oct 23 17:13:30 (none) kernel:  target2:0:0: Ending Domain Validation
> > Oct 23 17:13:30 (none) kernel:  target2:0:0: FAST-160 WIDE SCSI 320.0
> MB/s DT IU QAS RTI (6.25 ns, offset 127)
> > Oct 23 17:13:30 (none) kernel:  target2:0:1: Beginning Domain Validation
> > Oct 23 17:13:30 (none) kernel:  target2:0:1: Ending Domain Validation
> > Oct 23 17:13:30 (none) kernel:  target2:0:1: FAST-160 WIDE SCSI 320.0
> MB/s DT IU QAS RTI (6.25 ns, offset 127)
> > Oct 23 17:13:30 (none) kernel:  target2:0:2: Beginning Domain Validation
> > Oct 23 17:13:30 (none) kernel: sd 2:0:2:0: timing out command, waited
> 180s
> > Oct 23 17:13:30 (none) kernel: sd 2:0:2:0: timing out command, waited
> 180s
> > Oct 23 17:13:30 (none) kernel: sd 2:0:2:0: [sde] Unhandled error code
> > Oct 23 17:13:30 (none) kernel: sd 2:0:2:0: [sde] Result: hostbyte=DID_OK
> driverbyte=DRIVER_OK
> > Oct 23 17:13:30 (none) kernel: end_request: I/O error, dev sde, sector
> 27440
> > Oct 23 17:13:30 (none) kernel: sd 2:0:2:0: timing out command, waited
> 180s
> > Oct 23 17:13:30 (none) kernel: sd 2:0:2:0: timing out command, waited
> 180s
> > Oct 23 17:13:30 (none) kernel: sd 2:0:2:0: [sde] Unhandled error code
> > Oct 23 17:13:30 (none) kernel: sd 2:0:2:0: [sde] Result: hostbyte=DID_OK
> driverbyte=DRIVER_OK
> > Oct 23 17:13:31 (none) kernel: sd 2:0:2:0: [sde] Unhandled error code
> > Oct 23 17:13:31 (none) kernel: end_request: I/O error, dev sde, sector
> 29488
> > Oct 23 17:13:31 (none) kernel: sd 2:0:2:0: [sde] Result: hostbyte=DID_OK
> driverbyte=DRIVER_OK
> > Oct 23 17:13:31 (none) kernel: end_request: I/O error, dev sde, sector
> 21264
> > Oct 23 17:13:31 (none) kernel: sd 2:0:2:0: timing out command, waited
> 180s
> > Oct 23 17:13:31 (none) kernel: sd 2:0:2:0: [sde] Unhandled error code
> > Oct 23 17:13:31 (none) kernel: sd 2:0:2:0: timing out command, waited
> 180s
> > Oct 23 17:13:31 (none) kernel: sd 2:0:2:0: [sde] Result: hostbyte=DID_OK
> driverbyte=DRIVER_OK
> > Oct 23 17:13:31 (none) kernel: end_request: I/O error, dev sde, sector
> 20104
> > Oct 23 17:13:31 (none) kernel: sd 2:0:2:0: [sde] Unhandled error code
> > Oct 23 17:13:31 (none) kernel: sd 2:0:2:0: [sde] Result: hostbyte=DID_OK
> driverbyte=DRIVER_OK
> > Oct 23 17:13:31 (none) kernel: end_request: I/O error, dev sde, sector
> 15992
> > Oct 23 17:13:31 (none) kernel: sd 2:0:2:0: timing out command, waited
> 180s
> > Oct 23 17:13:31 (none) kernel: sd 2:0:2:0: [sde] Unhandled error code
> > Oct 23 17:13:31 (none) kernel: sd 2:0:2:0: [sde] Result: hostbyte=DID_OK
> driverbyte=DRIVER_OK
> > Oct 23 17:13:32 (none) kernel: end_request: I/O error, dev sde, sector
> 28464
> > Oct 23 17:13:32 (none) kernel: sd 2:0:2:0: timing out command, waited
> 180s
> > Oct 23 17:13:32 (none) kernel: sd 2:0:2:0: [sde] Unhandled error code
> > Oct 23 17:13:32 (none) kernel: sd 2:0:2:0: [sde] Result: hostbyte=DID_OK
> driverbyte=DRIVER_OK
> > Oct 23 17:13:32 (none) kernel: end_request: I/O error, dev sde, sector
> 12448
> > Oct 23 17:13:32 (none) kernel: sd 2:0:2:0: timing out command, waited
> 180s
> > Oct 23 17:13:32 (none) kernel: sd 2:0:2:0: [sde] Unhandled error code
> > Oct 23 17:13:32 (none) kernel: sd 2:0:2:0: [sde] Result: hostbyte=DID_OK
> driverbyte=DRIVER_OK
> > Oct 23 17:13:32 (none) kernel: end_request: I/O error, dev sde, sector
> 5296
> > Oct 23 17:13:32 (none) kernel: sd 2:0:2:0: [sde] Unhandled error code
> > Oct 23 17:13:32 (none) kernel: sd 2:0:2:0: [sde] Result: hostbyte=DID_OK
> driverbyte=DRIVER_OK
> > Oct 23 17:13:32 (none) kernel: end_request: I/O error, dev sde, sector
> 21272
> > Oct 23 17:13:32 (none) kernel:  target2:0:2: Domain Validation skipping
> write tests
> > Oct 23 17:13:32 (none) kernel:  target2:0:2: Ending Domain Validation
> > Oct 23 17:13:33 (none) kernel:  target2:0:2: FAST-160 WIDE SCSI 320.0
> MB/s DT IU QAS RTI (6.25 ns, offset 127)
> > Oct 23 17:13:33 (none) kernel:  target2:0:3: Beginning Domain Validation
> > Oct 23 17:13:33 (none) kernel:  target2:0:3: Ending Domain Validation
> > Oct 23 17:13:33 (none) kernel:  target2:0:3: FAST-160 WIDE SCSI 320.0
> MB/s DT IU QAS RTI WRFLOW PCOMP (6.25 ns, offset 63)
> > Oct 23 17:13:33 (none) kernel:  target2:0:6: Beginning Domain Validation
> > Oct 23 17:13:33 (none) kernel:  target2:0:6: Ending Domain Validation
> > Oct 23 17:13:33 (none) kernel:  target2:0:6: asynchronous
> > Oct 23 17:13:33 (none) kernel:  target3:0:0: mptspi: ioc3: mpt_config
> failed
> > Oct 23 17:13:33 (none) kernel:  target3:0:1: mptspi: ioc3: mpt_config
> failed
> > Oct 23 17:13:33 (none) kernel:  target2:0:0: Beginning Domain Validation
> > Oct 23 17:13:33 (none) kernel:  target2:0:0: Ending Domain Validation
> > Oct 23 17:13:33 (none) kernel:  target2:0:0: FAST-160 WIDE SCSI 320.0
> MB/s DT IU QAS RTI (6.25 ns, offset 127)
> > Oct 23 17:13:33 (none) kernel:  target2:0:1: Beginning Domain Validation
> > Oct 23 17:13:33 (none) kernel:  target2:0:1: Ending Domain Validation
> > Oct 23 17:13:34 (none) kernel:  target2:0:1: FAST-160 WIDE SCSI 320.0
> MB/s DT IU QAS RTI (6.25 ns, offset 127)
> > Oct 23 17:13:34 (none) kernel:  target2:0:2: Beginning Domain Validation
> > Oct 23 17:13:34 (none) kernel: sd 2:0:2:0: timing out command, waited
> 180s
> > Oct 23 17:13:34 (none) kernel: sd 2:0:2:0: [sde] Unhandled error code
> > Oct 23 17:13:34 (none) kernel: sd 2:0:2:0: [sde] Result: hostbyte=DID_OK
> driverbyte=DRIVER_OK
> > Oct 23 17:13:34 (none) kernel: end_request: I/O error, dev sde, sector
> 7376
> > Oct 23 17:13:34 (none) kernel:  target2:0:2: Domain Validation skipping
> write tests
> > Oct 23 17:13:34 (none) kernel:  target2:0:2: Ending Domain Validation
> > Oct 23 17:13:34 (none) kernel:  target2:0:2: FAST-160 WIDE SCSI 320.0
> MB/s DT IU QAS RTI (6.25 ns, offset 127)
> > Oct 23 17:13:34 (none) kernel:  target2:0:3: Beginning Domain Validation
> > Oct 23 17:13:34 (none) kernel:  target2:0:3: Ending Domain Validation
> > Oct 23 17:13:34 (none) kernel:  target2:0:3: FAST-160 WIDE SCSI 320.0
> MB/s DT IU QAS RTI WRFLOW PCOMP (6.25 ns, offset 63)
> > Oct 23 17:13:34 (none) kernel:  target2:0:6: Beginning Domain Validation
> > Oct 23 17:13:34 (none) kernel:  target2:0:6: Ending Domain Validation
> > Oct 23 17:13:34 (none) kernel:  target2:0:6: asynchronous
> > Oct 23 17:13:35 (none) kernel:  target3:0:0: mptspi: ioc3: mpt_config
> failed
> > Oct 23 17:13:35 (none) kernel:  target3:0:1: mptspi: ioc3: mpt_config
> failed
> > Oct 23 17:13:35 (none) kernel:  target2:0:0: Beginning Domain Validation
> > Oct 23 17:13:35 (none) kernel:  target2:0:0: Ending Domain Validation
> > Oct 23 17:13:35 (none) kernel:  target2:0:0: FAST-160 WIDE SCSI 320.0
> MB/s DT IU QAS RTI (6.25 ns, offset 127)
> > Oct 23 17:13:35 (none) kernel:  target2:0:1: Beginning Domain Validation
> > Oct 23 17:13:35 (none) kernel:  target2:0:1: Ending Domain Validation
> > Oct 23 17:13:35 (none) kernel:  target2:0:1: FAST-160 WIDE SCSI 320.0
> MB/s DT IU QAS RTI (6.25 ns, offset 127)
> > Oct 23 17:13:35 (none) kernel:  target2:0:2: Beginning Domain Validation
> > Oct 23 17:13:35 (none) kernel:  target2:0:2: Domain Validation skipping
> write tests
> > Oct 23 17:13:35 (none) kernel:  target2:0:2: Ending Domain Validation
> > Oct 23 17:13:35 (none) kernel:  target2:0:2: FAST-160 WIDE SCSI 320.0
> MB/s DT IU QAS RTI (6.25 ns, offset 127)
> > Oct 23 17:13:35 (none) kernel:  target2:0:3: Beginning Domain Validation
> > Oct 23 17:13:35 (none) kernel:  target2:0:3: Ending Domain Validation
> > Oct 23 17:13:35 (none) kernel:  target2:0:3: FAST-160 WIDE SCSI 320.0
> MB/s DT IU QAS RTI WRFLOW PCOMP (6.25 ns, offset 63)
> > Oct 23 17:13:36 (none) kernel:  target2:0:6: Beginning Domain Validation
> > Oct 23 17:13:36 (none) kernel:  target2:0:6: Ending Domain Validation
> > Oct 23 17:13:36 (none) kernel:  target2:0:6: asynchronous
> > Oct 23 17:13:36 (none) kernel:  target3:0:0: mptspi: ioc3: mpt_config
> failed
> > Oct 23 17:13:36 (none) kernel:  target3:0:1: mptspi: ioc3: mpt_config
> failed
> > Oct 23 17:13:36 (none) kernel:  target2:0:0: Beginning Domain Validation
> > Oct 23 17:13:36 (none) kernel:  target2:0:0: Ending Domain Validation
> > Oct 23 17:13:36 (none) kernel:  target2:0:0: FAST-160 WIDE SCSI 320.0
> MB/s DT IU QAS RTI (6.25 ns, offset 127)
> > Oct 23 17:13:36 (none) kernel:  target2:0:1: Beginning Domain Validation
> > Oct 23 17:13:36 (none) kernel:  target2:0:1: Ending Domain Validation
> > Oct 23 17:13:36 (none) kernel:  target2:0:1: FAST-160 WIDE SCSI 320.0
> MB/s DT IU QAS RTI (6.25 ns, offset 127)
> > Oct 23 17:13:36 (none) kernel:  target2:0:2: Beginning Domain Validation
> > Oct 23 17:13:36 (none) kernel:  target2:0:2: Domain Validation skipping
> write tests
> > Oct 23 17:13:36 (none) kernel:  target2:0:2: Ending Domain Validation
> > Oct 23 17:13:36 (none) kernel:  target2:0:2: FAST-160 WIDE SCSI 320.0
> MB/s DT IU QAS RTI (6.25 ns, offset 127)
> > Oct 23 17:13:37 (none) kernel:  target2:0:3: Beginning Domain Validation
> > Oct 23 17:13:37 (none) kernel:  target2:0:3: Ending Domain Validation
> > Oct 23 17:13:37 (none) kernel:  target2:0:3: FAST-160 WIDE SCSI 320.0
> MB/s DT IU QAS RTI WRFLOW PCOMP (6.25 ns, offset 63)
> > Oct 23 17:13:37 (none) kernel:  target2:0:6: Beginning Domain Validation
> > Oct 23 17:13:37 (none) kernel:  target2:0:6: Ending Domain Validation
> > Oct 23 17:13:37 (none) kernel:  target2:0:6: asynchronous
> > Oct 23 17:13:37 (none) kernel:  target3:0:0: mptspi: ioc3: mpt_config
> failed
> > Oct 23 17:13:37 (none) kernel:  target3:0:1: mptspi: ioc3: mpt_config
> failed
> > Oct 23 17:13:37 (none) kernel:  target2:0:0: Beginning Domain Validation
> > Oct 23 17:13:37 (none) kernel:  target2:0:0: Ending Domain Validation
> > Oct 23 17:13:37 (none) kernel:  target2:0:0: FAST-160 WIDE SCSI 320.0
> MB/s DT IU QAS RTI (6.25 ns, offset 127)
> > Oct 23 17:13:37 (none) kernel:  target2:0:1: Beginning Domain Validation
> > Oct 23 17:13:37 (none) kernel:  target2:0:1: Ending Domain Validation
> > Oct 23 17:13:37 (none) kernel:  target2:0:1: FAST-160 WIDE SCSI 320.0
> MB/s DT IU QAS RTI (6.25 ns, offset 127)
> > Oct 23 17:13:38 (none) kernel:  target2:0:2: Beginning Domain Validation
> > Oct 23 17:13:38 (none) kernel:  target2:0:2: Domain Validation skipping
> write tests
> > Oct 23 17:13:38 (none) kernel:  target2:0:2: Ending Domain Validation
> > Oct 23 17:13:38 (none) kernel:  target2:0:2: FAST-160 WIDE SCSI 320.0
> MB/s DT IU QAS RTI (6.25 ns, offset 127)
> > Oct 23 17:13:38 (none) kernel:  target2:0:3: Beginning Domain Validation
> > Oct 23 17:13:38 (none) kernel:  target2:0:3: Ending Domain Validation
> > Oct 23 17:13:38 (none) kernel:  target2:0:3: FAST-160 WIDE SCSI 320.0
> MB/s DT IU QAS RTI WRFLOW PCOMP (6.25 ns, offset 63)
> > Oct 23 17:13:38 (none) kernel:  target2:0:6: Beginning Domain Validation
> > Oct 23 17:13:38 (none) kernel:  target2:0:6: Ending Domain Validation
> > Oct 23 17:13:38 (none) kernel:  target2:0:6: asynchronous
> > Oct 23 17:13:38 (none) kernel:  target3:0:0: mptspi: ioc3: mpt_config
> failed
> > Oct 23 17:13:38 (none) kernel:  target3:0:1: mptspi: ioc3: mpt_config
> failed
> > Oct 23 17:13:38 (none) kernel:  target2:0:0: Beginning Domain Validation
> > Oct 23 17:13:38 (none) kernel:  target2:0:0: Ending Domain Validation
> > Oct 23 17:13:38 (none) kernel:  target2:0:0: FAST-160 WIDE SCSI 320.0
> MB/s DT IU QAS RTI (6.25 ns, offset 127)
> > Oct 23 17:13:39 (none) kernel:  target2:0:1: Beginning Domain Validation
> > Oct 23 17:13:39 (none) kernel:  target2:0:1: Ending Domain Validation
> > Oct 23 17:13:39 (none) kernel:  target2:0:1: FAST-160 WIDE SCSI 320.0
> MB/s DT IU QAS RTI (6.25 ns, offset 127)
> > Oct 23 17:13:39 (none) kernel:  target2:0:2: Beginning Domain Validation
> > Oct 23 17:13:39 (none) kernel:  target2:0:2: Domain Validation skipping
> write tests
> > Oct 23 17:13:39 (none) kernel:  target2:0:2: Ending Domain Validation
> > Oct 23 17:13:39 (none) kernel:  target2:0:2: FAST-160 WIDE SCSI 320.0
> MB/s DT IU QAS RTI (6.25 ns, offset 127)
> > Oct 23 17:13:39 (none) kernel:  target2:0:3: Beginning Domain Validation
> > Oct 23 17:13:39 (none) kernel:  target2:0:3: Ending Domain Validation
> > Oct 23 17:13:39 (none) kernel:  target2:0:3: FAST-160 WIDE SCSI 320.0
> MB/s DT IU QAS RTI WRFLOW PCOMP (6.25 ns, offset 63)
> > Oct 23 17:13:39 (none) kernel:  target2:0:6: Beginning Domain Validation
> > Oct 23 17:13:39 (none) kernel:  target2:0:6: Ending Domain Validation
> > Oct 23 17:13:39 (none) kernel:  target2:0:6: asynchronous
> > Oct 23 17:13:39 (none) kernel:  target2:0:0: Beginning Domain Validation
> > Oct 23 17:13:40 (none) kernel:  target2:0:0: Ending Domain Validation
> > Oct 23 17:13:40 (none) kernel:  target2:0:0: FAST-160 WIDE SCSI 320.0
> MB/s DT IU QAS RTI (6.25 ns, offset 127)
> > Oct 23 17:13:40 (none) kernel:  target2:0:1: Beginning Domain Validation
> > Oct 23 17:13:40 (none) kernel:  target2:0:1: Ending Domain Validation
> > Oct 23 17:13:40 (none) kernel:  target2:0:1: FAST-160 WIDE SCSI 320.0
> MB/s DT IU QAS RTI (6.25 ns, offset 127)
> > Oct 23 17:13:40 (none) kernel:  target2:0:2: Beginning Domain Validation
> > Oct 23 17:13:40 (none) kernel:  target2:0:2: Domain Validation skipping
> write tests
> > Oct 23 17:13:40 (none) kernel:  target2:0:2: Ending Domain Validation
> > Oct 23 17:13:40 (none) kernel:  target2:0:2: FAST-160 WIDE SCSI 320.0
> MB/s DT IU QAS RTI (6.25 ns, offset 127)
> > Oct 23 17:13:40 (none) kernel:  target2:0:3: Beginning Domain Validation
> > Oct 23 17:13:40 (none) kernel:  target2:0:3: Ending Domain Validation
> > Oct 23 17:13:40 (none) kernel:  target2:0:3: FAST-160 WIDE SCSI 320.0
> MB/s DT IU QAS RTI WRFLOW PCOMP (6.25 ns, offset 63)
> > Oct 23 17:13:40 (none) kernel:  target2:0:6: Beginning Domain Validation
> > Oct 23 17:13:40 (none) kernel:  target2:0:6: Ending Domain Validation
> > Oct 23 17:13:40 (none) kernel:  target2:0:6: asynchronous
> > Oct 23 17:13:41 (none) kernel:  target3:0:0: mptspi: ioc3: mpt_config
> failed
> > Oct 23 17:13:41 (none) kernel:  target3:0:1: mptspi: ioc3: mpt_config
> failed
> > Oct 23 17:13:41 (none) kernel:  target2:0:0: Beginning Domain Validation
> > Oct 23 17:13:41 (none) kernel:  target2:0:0: Ending Domain Validation
> > Oct 23 17:13:41 (none) kernel:  target2:0:0: FAST-160 WIDE SCSI 320.0
> MB/s DT IU QAS RTI (6.25 ns, offset 127)
> > Oct 23 17:13:41 (none) kernel:  target2:0:1: Beginning Domain Validation
> > Oct 23 17:13:41 (none) kernel:  target2:0:1: Ending Domain Validation
> > Oct 23 17:13:41 (none) kernel:  target2:0:1: FAST-160 WIDE SCSI 320.0
> MB/s DT IU QAS RTI (6.25 ns, offset 127)
> > Oct 23 17:13:41 (none) kernel:  target2:0:2: Beginning Domain Validation
> > Oct 23 17:13:41 (none) kernel:  target2:0:2: Domain Validation skipping
> write tests
> > Oct 23 17:13:41 (none) kernel:  target2:0:2: Ending Domain Validation
> > Oct 23 17:13:41 (none) kernel:  target2:0:2: FAST-160 WIDE SCSI 320.0
> MB/s DT IU QAS RTI (6.25 ns, offset 127)
> > Oct 23 17:13:41 (none) kernel:  target2:0:3: Beginning Domain Validation
> > Oct 23 17:13:41 (none) kernel:  target2:0:3: Ending Domain Validation
> > Oct 23 17:13:41 (none) kernel:  target2:0:3: FAST-160 WIDE SCSI 320.0
> MB/s DT IU QAS RTI WRFLOW PCOMP (6.25 ns, offset 63)
> > Oct 23 17:13:42 (none) kernel:  target2:0:6: Beginning Domain Validation
> > Oct 23 17:13:42 (none) kernel:  target2:0:6: Ending Domain Validation
> > Oct 23 17:13:42 (none) kernel:  target2:0:6: asynchronous
> > Oct 23 17:13:42 (none) kernel:  target3:0:0: mptspi: ioc3: mpt_config
> failed
> > Oct 23 17:13:42 (none) kernel:  target3:0:1: mptspi: ioc3: mpt_config
> failed
> > Oct 23 17:13:42 (none) kernel:  target2:0:0: Beginning Domain Validation
> > Oct 23 17:13:42 (none) kernel:  target2:0:0: Ending Domain Validation
> > Oct 23 17:13:42 (none) kernel:  target2:0:0: FAST-160 WIDE SCSI 320.0
> MB/s DT IU QAS RTI (6.25 ns, offset 127)
> > Oct 23 17:13:42 (none) kernel:  target2:0:1: Beginning Domain Validation
> > Oct 23 17:13:42 (none) kernel:  target2:0:1: Ending Domain Validation
> > Oct 23 17:13:42 (none) kernel:  target2:0:1: FAST-160 WIDE SCSI 320.0
> MB/s DT IU QAS RTI (6.25 ns, offset 127)
> > Oct 23 17:13:42 (none) kernel:  target2:0:2: Beginning Domain Validation
> > Oct 23 17:13:42 (none) kernel:  target2:0:2: Domain Validation skipping
> write tests
> > Oct 23 17:13:42 (none) kernel:  target2:0:2: Ending Domain Validation
> > Oct 23 17:13:43 (none) kernel:  target2:0:2: FAST-160 WIDE SCSI 320.0
> MB/s DT IU QAS RTI (6.25 ns, offset 127)
> > Oct 23 17:13:43 (none) kernel:  target2:0:3: Beginning Domain Validation
> > Oct 23 17:13:43 (none) kernel:  target2:0:3: Ending Domain Validation
> > Oct 23 17:13:43 (none) kernel:  target2:0:3: FAST-160 WIDE SCSI 320.0
> MB/s DT IU QAS RTI WRFLOW PCOMP (6.25 ns, offset 63)
> > Oct 23 17:13:43 (none) kernel:  target2:0:6: Beginning Domain Validation
> > Oct 23 17:13:43 (none) kernel:  target2:0:6: Ending Domain Validation
> > Oct 23 17:13:43 (none) kernel:  target2:0:6: asynchronous
> > Oct 23 17:13:43 (none) kernel:  target3:0:0: mptspi: ioc3: mpt_config
> failed
> > Oct 23 17:13:43 (none) kernel:  target3:0:1: mptspi: ioc3: mpt_config
> failed
> > Oct 23 17:13:43 (none) kernel:  target2:0:0: Beginning Domain Validation
> > Oct 23 17:13:43 (none) kernel:  target2:0:0: Ending Domain Validation
> > Oct 23 17:13:43 (none) kernel:  target2:0:0: FAST-160 WIDE SCSI 320.0
> MB/s DT IU QAS RTI (6.25 ns, offset 127)
> > Oct 23 17:13:43 (none) kernel:  target2:0:1: Beginning Domain Validation
> > Oct 23 17:13:43 (none) kernel:  target2:0:1: Ending Domain Validation
> > Oct 23 17:13:43 (none) kernel:  target2:0:1: FAST-160 WIDE SCSI 320.0
> MB/s DT IU QAS RTI (6.25 ns, offset 127)
> > Oct 23 17:13:44 (none) kernel:  target2:0:2: Beginning Domain Validation
> > Oct 23 17:13:44 (none) kernel:  target2:0:2: Domain Validation skipping
> write tests
> > Oct 23 17:13:44 (none) kernel:  target2:0:2: Ending Domain Validation
> > Oct 23 17:13:44 (none) kernel:  target2:0:2: FAST-160 WIDE SCSI 320.0
> MB/s DT IU QAS RTI (6.25 ns, offset 127)
> > Oct 23 17:13:44 (none) kernel:  target2:0:3: Beginning Domain Validation
> > Oct 23 17:13:44 (none) kernel:  target2:0:3: Ending Domain Validation
> > Oct 23 17:13:44 (none) kernel:  target2:0:3: FAST-160 WIDE SCSI 320.0
> MB/s DT IU QAS RTI WRFLOW PCOMP (6.25 ns, offset 63)
> > Oct 23 17:13:44 (none) kernel:  target2:0:6: Beginning Domain Validation
> > Oct 23 17:13:44 (none) kernel:  target2:0:6: Ending Domain Validation
> > Oct 23 17:13:44 (none) kernel:  target2:0:6: asynchronous
> > Oct 23 17:13:44 (none) kernel:  target3:0:0: mptspi: ioc3: mpt_config
> failed
> > Oct 23 17:13:44 (none) kernel:  target3:0:1: mptspi: ioc3: mpt_config
> failed
> > Oct 23 17:13:44 (none) kernel: mptscsih: ioc2: attempting task abort!
> (sc=e733b280)
> > Oct 23 17:13:44 (none) kernel: sd 2:0:2:0: [sde] CDB: Write(10): 2a 00
> 00 00 28 78 00 04 00 00
> > Oct 23 17:13:45 (none) kernel: mptscsih: ioc2: task abort: SUCCESS
> (sc=e733b280)
> > Oct 23 17:13:45 (none) kernel: mptscsih: ioc2: attempting task abort!
> (sc=e733b280)
> > Oct 23 17:13:45 (none) kernel: sd 2:0:2:0: [sde] CDB: Write(10): 2a 00
> 00 00 28 78 00 04 00 00
> > Oct 23 17:13:45 (none) kernel: mptscsih: ioc2: task abort: SUCCESS
> (sc=e733b280)
> > Oct 23 17:13:45 (none) kernel: mptscsih: ioc2: attempting task abort!
> (sc=e733b280)
> > Oct 23 17:13:45 (none) kernel: sd 2:0:2:0: [sde] CDB: Write(10): 2a 00
> 00 00 28 78 00 04 00 00
> > Oct 23 17:13:45 (none) kernel: mptscsih: ioc2: task abort: SUCCESS
> (sc=e733b280)
> > Oct 23 17:13:45 (none) kernel: mptscsih: ioc2: attempting task abort!
> (sc=e733b280)
> > Oct 23 17:13:45 (none) kernel: sd 2:0:2:0: [sde] CDB: Write(10): 2a 00
> 00 00 28 78 00 04 00 00
> > Oct 23 17:13:45 (none) kernel: mptscsih: ioc2: task abort: SUCCESS
> (sc=e733b280)
> > Oct 23 17:13:45 (none) kernel: mptscsih: ioc2: attempting task abort!
> (sc=e733b280)
> > Oct 23 17:13:45 (none) kernel: sd 2:0:2:0: [sde] CDB: Write(10): 2a 00
> 00 00 28 78 00 04 00 00
> > Oct 23 17:13:45 (none) kernel: mptscsih: ioc2: task abort: SUCCESS
> (sc=e733b280)
> > Oct 23 17:13:45 (none) kernel: mptscsih: ioc2: attempting task abort!
> (sc=e733b280)
> > Oct 23 17:13:45 (none) kernel: sd 2:0:2:0: [sde] CDB: Write(10): 2a 00
> 00 00 28 78 00 04 00 00
> > Oct 23 17:13:45 (none) kernel: mptscsih: ioc2: task abort: SUCCESS
> (sc=e733b280)
> > Oct 23 17:13:46 (none) kernel: mptscsih: ioc2: attempting task abort!
> (sc=e733b280)
> > Oct 23 17:13:46 (none) kernel: sd 2:0:2:0: [sde] CDB: Write(10): 2a 00
> 00 00 28 78 00 04 00 00
> > Oct 23 17:13:46 (none) kernel: mptscsih: ioc2: task abort: SUCCESS
> (sc=e733b280)
> > Oct 23 17:13:46 (none) kernel: mptscsih: ioc2: attempting task abort!
> (sc=e733b280)
> > Oct 23 17:13:46 (none) kernel: sd 2:0:2:0: [sde] CDB: Write(10): 2a 00
> 00 00 28 78 00 04 00 00
> > Oct 23 17:13:46 (none) kernel: mptscsih: ioc2: task abort: SUCCESS
> (sc=e733b280)
> > Oct 23 17:13:46 (none) kernel: mptscsih: ioc2: attempting task abort!
> (sc=e733b280)
> > Oct 23 17:13:46 (none) kernel: sd 2:0:2:0: [sde] CDB: Write(10): 2a 00
> 00 00 28 78 00 04 00 00
> > Oct 23 17:13:46 (none) kernel: mptscsih: ioc2: task abort: SUCCESS
> (sc=e733b280)
> > Oct 23 17:13:46 (none) kernel: mptscsih: ioc2: attempting task abort!
> (sc=e733b280)
> > Oct 23 17:13:46 (none) kernel: sd 2:0:2:0: [sde] CDB: Write(10): 2a 00
> 00 00 28 78 00 04 00 00
> > Oct 23 17:13:46 (none) kernel: mptscsih: ioc2: task abort: SUCCESS
> (sc=e733b280)
> > Oct 23 17:13:46 (none) kernel: mptscsih: ioc2: attempting task abort!
> (sc=e733b280)
> > Oct 23 17:13:46 (none) kernel: sd 2:0:2:0: [sde] CDB: Write(10): 2a 00
> 00 00 28 78 00 04 00 00
> > Oct 23 17:13:46 (none) kernel: mptscsih: ioc2: task abort: SUCCESS
> (sc=e733b280)
> > Oct 23 17:13:46 (none) kernel: mptscsih: ioc2: attempting task abort!
> (sc=e733b280)
> > Oct 23 17:13:47 (none) kernel: sd 2:0:2:0: [sde] CDB: Write(10): 2a 00
> 00 00 28 78 00 04 00 00
> > Oct 23 17:13:47 (none) kernel: mptscsih: ioc2: task abort: SUCCESS
> (sc=e733b280)
> > Oct 23 17:13:47 (none) kernel: mptscsih: ioc2: attempting task abort!
> (sc=e733b280)
> > Oct 23 17:13:47 (none) kernel: sd 2:0:2:0: [sde] CDB: Write(10): 2a 00
> 00 00 28 78 00 04 00 00
> > Oct 23 17:13:47 (none) kernel: mptscsih: ioc2: task abort: SUCCESS
> (sc=e733b280)
> > Oct 23 17:13:47 (none) kernel: mptscsih: ioc2: attempting task abort!
> (sc=e733b280)
> > Oct 23 17:13:47 (none) kernel: sd 2:0:2:0: [sde] CDB: Write(10): 2a 00
> 00 00 28 78 00 04 00 00
> > Oct 23 17:13:47 (none) kernel: mptscsih: ioc2: task abort: SUCCESS
> (sc=e733b280)
> > Oct 23 17:13:47 (none) kernel: mptscsih: ioc2: attempting task abort!
> (sc=e733b280)
> > Oct 23 17:13:47 (none) kernel: sd 2:0:2:0: [sde] CDB: Write(10): 2a 00
> 00 00 28 78 00 04 00 00
> > Oct 23 17:13:47 (none) kernel: mptscsih: ioc2: task abort: SUCCESS
> (sc=e733b280)
> > Oct 23 17:13:47 (none) kernel: mptscsih: ioc2: attempting task abort!
> (sc=e733b280)
> > Oct 23 17:13:47 (none) kernel: sd 2:0:2:0: [sde] CDB: Write(10): 2a 00
> 00 00 28 78 00 04 00 00
> > Oct 23 17:13:47 (none) kernel: mptscsih: ioc2: task abort: SUCCESS
> (sc=e733b280)
> > Oct 23 17:13:47 (none) kernel: mptscsih: ioc2: attempting task abort!
> (sc=e733b280)
> > Oct 23 17:13:48 (none) kernel: sd 2:0:2:0: [sde] CDB: Write(10): 2a 00
> 00 00 28 78 00 04 00 00
> > Oct 23 17:13:48 (none) kernel: mptscsih: ioc2: task abort: SUCCESS
> (sc=e733b280)
> > Oct 23 17:13:48 (none) kernel: mptscsih: ioc2: attempting task abort!
> (sc=e733b280)
> > Oct 23 17:13:48 (none) kernel: sd 2:0:2:0: [sde] CDB: Write(10): 2a 00
> 00 00 28 78 00 04 00 00
> > Oct 23 17:13:48 (none) kernel: mptscsih: ioc2: task abort: SUCCESS
> (sc=e733b280)
> > Oct 23 17:13:48 (none) kernel: mptscsih: ioc2: attempting task abort!
> (sc=e733b280)
> > Oct 23 17:13:48 (none) kernel: sd 2:0:2:0: [sde] CDB: Write(10): 2a 00
> 00 00 28 78 00 04 00 00
> > Oct 23 17:13:48 (none) kernel: mptscsih: ioc2: task abort: SUCCESS
> (sc=e733b280)
> > Oct 23 17:13:48 (none) kernel: mptscsih: ioc2: attempting task abort!
> (sc=e733b280)
> > Oct 23 17:13:48 (none) kernel: sd 2:0:2:0: [sde] CDB: Write(10): 2a 00
> 00 00 28 78 00 04 00 00
> > Oct 23 17:13:48 (none) kernel: mptscsih: ioc2: task abort: SUCCESS
> (sc=e733b280)
> > Oct 23 17:13:48 (none) kernel: mptscsih: ioc2: attempting task abort!
> (sc=e733b280)
> > Oct 23 17:13:48 (none) kernel: sd 2:0:2:0: [sde] CDB: Write(10): 2a 00
> 00 00 28 78 00 04 00 00
> > Oct 23 17:13:48 (none) kernel: mptscsih: ioc2: task abort: SUCCESS
> (sc=e733b280)
> > Oct 23 17:13:48 (none) kernel: mptscsih: ioc2: attempting task abort!
> (sc=e733b280)
> > Oct 23 17:13:49 (none) kernel: sd 2:0:2:0: [sde] CDB: Write(10): 2a 00
> 00 00 28 78 00 04 00 00
> > Oct 23 17:13:49 (none) kernel: mptscsih: ioc2: task abort: SUCCESS
> (sc=e733b280)
> > Oct 23 17:13:49 (none) kernel: mptscsih: ioc2: attempting task abort!
> (sc=e733b280)
> > Oct 23 17:13:49 (none) kernel: sd 2:0:2:0: [sde] CDB: Write(10): 2a 00
> 00 00 28 78 00 04 00 00
> > Oct 23 17:13:49 (none) kernel: mptscsih: ioc2: task abort: SUCCESS
> (sc=e733b280)
> > Oct 23 17:13:49 (none) kernel: mptscsih: ioc2: attempting task abort!
> (sc=e733b280)
> > Oct 23 17:13:49 (none) kernel: sd 2:0:2:0: [sde] CDB: Write(10): 2a 00
> 00 00 28 78 00 04 00 00
> > Oct 23 17:13:49 (none) kernel: mptscsih: ioc2: task abort: SUCCESS
> (sc=e733b280)
> > Oct 23 17:13:49 (none) kernel: mptscsih: ioc2: attempting task abort!
> (sc=e733b280)
> > Oct 23 17:13:49 (none) kernel: sd 2:0:2:0: [sde] CDB: Write(10): 2a 00
> 00 00 28 78 00 04 00 00
> > Oct 23 17:13:49 (none) kernel: mptscsih: ioc2: task abort: SUCCESS
> (sc=e733b280)
> > Oct 23 17:13:49 (none) kernel: mptscsih: ioc2: attempting task abort!
> (sc=e733b280)
> > Oct 23 17:13:49 (none) kernel: sd 2:0:2:0: [sde] CDB: Write(10): 2a 00
> 00 00 28 78 00 04 00 00
> > Oct 23 17:13:49 (none) kernel: mptscsih: ioc2: task abort: SUCCESS
> (sc=e733b280)
> > Oct 23 17:13:49 (none) kernel: mptscsih: ioc2: attempting task abort!
> (sc=e733b280)
> > Oct 23 17:13:49 (none) kernel: sd 2:0:2:0: [sde] CDB: Write(10): 2a 00
> 00 00 28 78 00 04 00 00
> > Oct 23 17:13:50 (none) kernel: mptscsih: ioc2: task abort: SUCCESS
> (sc=e733b280)
> > Oct 23 17:13:50 (none) kernel: mptscsih: ioc2: attempting task abort!
> (sc=e733b280)
> > Oct 23 17:13:50 (none) kernel: sd 2:0:2:0: [sde] CDB: Write(10): 2a 00
> 00 00 28 78 00 04 00 00
> > Oct 23 17:13:50 (none) kernel: mptscsih: ioc2: task abort: SUCCESS
> (sc=e733b280)
> > Oct 23 17:13:50 (none) kernel: mptscsih: ioc2: attempting task abort!
> (sc=e733b280)
> > Oct 23 17:13:50 (none) kernel: sd 2:0:2:0: [sde] CDB: Write(10): 2a 00
> 00 00 28 78 00 04 00 00
> > Oct 23 17:13:50 (none) kernel: mptscsih: ioc2: task abort: SUCCESS
> (sc=e733b280)
> > Oct 23 17:13:50 (none) kernel: mptscsih: ioc2: attempting task abort!
> (sc=e733b280)
> > Oct 23 17:13:50 (none) kernel: sd 2:0:2:0: [sde] CDB: Write(10): 2a 00
> 00 00 28 78 00 04 00 00
> > Oct 23 17:13:50 (none) kernel: mptscsih: ioc2: task abort: SUCCESS
> (sc=e733b280)
> > Oct 23 17:13:50 (none) kernel: mptscsih: ioc2: attempting task abort!
> (sc=e733b280)
> > Oct 23 17:13:50 (none) kernel: sd 2:0:2:0: [sde] CDB: Write(10): 2a 00
> 00 00 28 78 00 04 00 00
> > Oct 23 17:13:50 (none) kernel: mptscsih: ioc2: task abort: SUCCESS
> (sc=e733b280)
> > Oct 23 17:13:50 (none) kernel: mptscsih: ioc2: attempting task abort!
> (sc=e733b280)
> > Oct 23 17:13:50 (none) kernel: sd 2:0:2:0: [sde] CDB: Write(10): 2a 00
> 00 00 28 78 00 04 00 00
> > Oct 23 17:13:51 (none) kernel: mptscsih: ioc2: task abort: SUCCESS
> (sc=e733b280)
> > Oct 23 17:13:51 (none) kernel: mptscsih: ioc2: attempting task abort!
> (sc=e733b280)
> > Oct 23 17:13:51 (none) kernel: sd 2:0:2:0: [sde] CDB: Write(10): 2a 00
> 00 00 28 78 00 04 00 00
> > Oct 23 17:13:51 (none) kernel: mptscsih: ioc2: task abort: SUCCESS
> (sc=e733b280)
> > Oct 23 17:13:51 (none) kernel: mptscsih: ioc2: attempting task abort!
> (sc=e733b280)
> > Oct 23 17:13:51 (none) kernel: sd 2:0:2:0: [sde] CDB: Write(10): 2a 00
> 00 00 28 78 00 04 00 00
> > Oct 23 17:13:51 (none) kernel: mptscsih: ioc2: task abort: SUCCESS
> (sc=e733b280)
> > Oct 23 17:13:51 (none) kernel: mptscsih: ioc2: attempting task abort!
> (sc=e733b280)
> > Oct 23 17:13:51 (none) kernel: sd 2:0:2:0: [sde] CDB: Write(10): 2a 00
> 00 00 28 78 00 04 00 00
> > Oct 23 17:13:51 (none) kernel: mptscsih: ioc2: task abort: SUCCESS
> (sc=e733b280)
> > Oct 23 17:13:51 (none) kernel: mptscsih: ioc2: attempting task abort!
> (sc=e733b280)
> > Oct 23 17:13:51 (none) kernel: sd 2:0:2:0: [sde] CDB: Write(10): 2a 00
> 00 00 28 78 00 04 00 00
> > Oct 23 17:13:51 (none) kernel: mptscsih: ioc2: task abort: SUCCESS
> (sc=e733b280)
> > Oct 23 17:13:51 (none) kernel: mptscsih: ioc2: attempting task abort!
> (sc=e733b280)
> > Oct 23 17:13:51 (none) kernel: sd 2:0:2:0: [sde] CDB: Write(10): 2a 00
> 00 00 28 78 00 04 00 00
> > Oct 23 17:13:52 (none) kernel: mptscsih: ioc2: task abort: SUCCESS
> (sc=e733b280)
> > Oct 23 17:13:52 (none) kernel: mptscsih: ioc2: attempting task abort!
> (sc=e733b280)
> > Oct 23 17:13:52 (none) kernel: sd 2:0:2:0: [sde] CDB: Write(10): 2a 00
> 00 00 28 78 00 04 00 00
> > Oct 23 17:13:52 (none) kernel: mptscsih: ioc2: task abort: SUCCESS
> (sc=e733b280)
> > Oct 23 17:13:52 (none) kernel: mptscsih: ioc2: attempting task abort!
> (sc=e733b280)
> > Oct 23 17:13:52 (none) kernel: sd 2:0:2:0: [sde] CDB: Write(10): 2a 00
> 00 00 28 78 00 04 00 00
> > Oct 23 17:13:52 (none) kernel: mptscsih: ioc2: task abort: SUCCESS
> (sc=e733b280)
> > Oct 23 17:13:52 (none) kernel: mptscsih: ioc2: attempting task abort!
> (sc=e733b280)
> > Oct 23 17:13:52 (none) kernel: sd 2:0:2:0: [sde] CDB: Write(10): 2a 00
> 00 00 28 78 00 04 00 00
> > Oct 23 17:13:52 (none) kernel: mptscsih: ioc2: task abort: SUCCESS
> (sc=e733b280)
> > Oct 23 17:13:52 (none) kernel: mptscsih: ioc2: attempting task abort!
> (sc=e733b280)
> > Oct 23 17:13:52 (none) kernel: sd 2:0:2:0: [sde] CDB: Write(10): 2a 00
> 00 00 28 78 00 04 00 00
> > Oct 23 17:13:52 (none) kernel: mptscsih: ioc2: task abort: SUCCESS
> (sc=e733b280)
> > Oct 23 17:13:52 (none) kernel: mptscsih: ioc2: attempting task abort!
> (sc=e733b280)
> > Oct 23 17:13:53 (none) kernel: sd 2:0:2:0: [sde] CDB: Write(10): 2a 00
> 00 00 28 78 00 04 00 00
> > Oct 23 17:13:53 (none) kernel: mptscsih: ioc2: task abort: SUCCESS
> (sc=e733b280)
> > Oct 23 17:13:53 (none) kernel: mptscsih: ioc2: attempting task abort!
> (sc=e733b280)
> > Oct 23 17:13:53 (none) kernel: sd 2:0:2:0: [sde] CDB: Write(10): 2a 00
> 00 00 28 78 00 04 00 00
> > Oct 23 17:13:53 (none) kernel: mptscsih: ioc2: task abort: SUCCESS
> (sc=e733b280)
> > Oct 23 17:13:53 (none) kernel: mptscsih: ioc2: attempting task abort!
> (sc=e733b280)
> > Oct 23 17:13:53 (none) kernel: sd 2:0:2:0: [sde] CDB: Write(10): 2a 00
> 00 00 28 78 00 04 00 00
> > Oct 23 17:13:53 (none) kernel: mptscsih: ioc2: task abort: SUCCESS
> (sc=e733b280)
> > Oct 23 17:13:53 (none) kernel: mptscsih: ioc2: attempting task abort!
> (sc=e733b280)
> > Oct 23 17:13:53 (none) kernel: sd 2:0:2:0: [sde] CDB: Write(10): 2a 00
> 00 00 28 78 00 04 00 00
> > Oct 23 17:13:53 (none) kernel: mptscsih: ioc2: task abort: SUCCESS
> (sc=e733b280)
> > Oct 23 17:13:53 (none) kernel: mptscsih: ioc2: attempting task abort!
> (sc=e733b280)
> > Oct 23 17:13:53 (none) kernel: sd 2:0:2:0: [sde] CDB: Write(10): 2a 00
> 00 00 28 78 00 04 00 00
> > Oct 23 17:13:53 (none) kernel: mptscsih: ioc2: task abort: SUCCESS
> (sc=e733b280)
> > Oct 23 17:13:53 (none) kernel: mptscsih: ioc2: attempting task abort!
> (sc=e733b280)
> > Oct 23 17:13:54 (none) kernel: sd 2:0:2:0: [sde] CDB: Write(10): 2a 00
> 00 00 28 78 00 04 00 00
> > Oct 23 17:13:54 (none) kernel: mptscsih: ioc2: task abort: SUCCESS
> (sc=e733b280)
> > Oct 23 17:13:54 (none) kernel: mptscsih: ioc2: attempting task abort!
> (sc=e733b280)
> > Oct 23 17:13:54 (none) kernel: sd 2:0:2:0: [sde] CDB: Write(10): 2a 00
> 00 00 28 78 00 04 00 00
> > Oct 23 17:13:54 (none) kernel: mptscsih: ioc2: task abort: SUCCESS
> (sc=e733b280)
> > Oct 23 17:13:54 (none) kernel: mptscsih: ioc2: attempting task abort!
> (sc=e733b280)
> > Oct 23 17:13:54 (none) kernel: sd 2:0:2:0: [sde] CDB: Write(10): 2a 00
> 00 00 28 78 00 04 00 00
> > Oct 23 17:13:54 (none) kernel: mptscsih: ioc2: task abort: SUCCESS
> (sc=e733b280)
> > Oct 23 17:13:54 (none) kernel: mptscsih: ioc2: attempting task abort!
> (sc=e733b280)
> > Oct 23 17:13:54 (none) kernel: sd 2:0:2:0: [sde] CDB: Write(10): 2a 00
> 00 00 28 78 00 04 00 00
> > Oct 23 17:13:54 (none) kernel: mptscsih: ioc2: task abort: SUCCESS
> (sc=e733b280)
> > Oct 23 17:13:54 (none) kernel: mptscsih: ioc2: attempting task abort!
> (sc=e733b280)
> > Oct 23 17:13:54 (none) kernel: sd 2:0:2:0: [sde] CDB: Write(10): 2a 00
> 00 00 28 78 00 04 00 00
> > Oct 23 17:13:54 (none) kernel: mptscsih: ioc2: task abort: SUCCESS
> (sc=e733b280)
> > Oct 23 17:13:54 (none) kernel: mptscsih: ioc2: attempting task abort!
> (sc=e733b280)
> > Oct 23 17:13:54 (none) kernel: sd 2:0:2:0: [sde] CDB: Write(10): 2a 00
> 00 00 28 78 00 04 00 00
> > Oct 23 17:13:55 (none) kernel: mptscsih: ioc2: task abort: SUCCESS
> (sc=e733b280)
> > Oct 23 17:13:55 (none) kernel: mptscsih: ioc2: attempting task abort!
> (sc=e733b280)
> > Oct 23 17:13:55 (none) kernel: sd 2:0:2:0: [sde] CDB: Write(10): 2a 00
> 00 00 28 78 00 04 00 00
> > Oct 23 17:13:55 (none) kernel: mptscsih: ioc2: task abort: SUCCESS
> (sc=e733b280)
> > Oct 23 17:13:55 (none) kernel: mptscsih: ioc2: attempting task abort!
> (sc=e733b280)
> > Oct 23 17:13:55 (none) kernel: sd 2:0:2:0: [sde] CDB: Write(10): 2a 00
> 00 00 28 78 00 04 00 00
> > Oct 23 17:13:55 (none) kernel: mptscsih: ioc2: task abort: SUCCESS
> (sc=e733b280)
> > Oct 23 17:13:55 (none) kernel: mptscsih: ioc2: attempting task abort!
> (sc=e733b280)
> > Oct 23 17:13:55 (none) kernel: sd 2:0:2:0: [sde] CDB: Write(10): 2a 00
> 00 00 28 78 00 04 00 00
> > Oct 23 17:13:55 (none) kernel: mptscsih: ioc2: task abort: SUCCESS
> (sc=e733b280)
> > Oct 23 17:13:55 (none) kernel: mptscsih: ioc2: attempting task abort!
> (sc=e733b280)
> > Oct 23 17:13:55 (none) kernel: sd 2:0:2:0: [sde] CDB: Write(10): 2a 00
> 00 00 28 78 00 04 00 00
> > Oct 23 17:13:55 (none) kernel: mptscsih: ioc2: task abort: SUCCESS
> (sc=e733b280)
> > Oct 23 17:13:55 (none) kernel: mptscsih: ioc2: attempting task abort!
> (sc=e733b280)
> > Oct 23 17:13:55 (none) kernel: sd 2:0:2:0: [sde] CDB: Write(10): 2a 00
> 00 00 28 78 00 04 00 00
> > Oct 23 17:13:56 (none) kernel: mptscsih: ioc2: task abort: SUCCESS
> (sc=e733b280)
> > Oct 23 17:13:56 (none) kernel: mptscsih: ioc2: attempting task abort!
> (sc=e733b280)
> > Oct 23 17:13:56 (none) kernel: sd 2:0:2:0: [sde] CDB: Write(10): 2a 00
> 00 00 28 78 00 04 00 00
> > Oct 23 17:13:56 (none) kernel: mptscsih: ioc2: task abort: SUCCESS
> (sc=e733b280)
> > Oct 23 17:13:56 (none) kernel: mptscsih: ioc2: attempting task abort!
> (sc=e733b280)
> > Oct 23 17:13:56 (none) kernel: sd 2:0:2:0: [sde] CDB: Write(10): 2a 00
> 00 00 28 78 00 04 00 00
> > Oct 23 17:13:56 (none) kernel: mptscsih: ioc2: task abort: SUCCESS
> (sc=e733b280)
> > Oct 23 17:13:56 (none) kernel: mptscsih: ioc2: attempting task abort!
> (sc=e733b280)
> > Oct 23 17:13:56 (none) kernel: sd 2:0:2:0: [sde] CDB: Write(10): 2a 00
> 00 00 28 78 00 04 00 00
> > Oct 23 17:13:56 (none) kernel: mptscsih: ioc2: task abort: SUCCESS
> (sc=e733b280)
> > Oct 23 17:13:56 (none) kernel: mptscsih: ioc2: attempting task abort!
> (sc=e733b280)
> > Oct 23 17:13:56 (none) kernel: sd 2:0:2:0: [sde] CDB: Write(10): 2a 00
> 00 00 28 78 00 04 00 00
> > Oct 23 17:13:56 (none) kernel: mptscsih: ioc2: task abort: SUCCESS
> (sc=e733b280)
> > Oct 23 17:13:56 (none) kernel: mptscsih: ioc2: attempting task abort!
> (sc=e733b280)
> > Oct 23 17:13:56 (none) kernel: sd 2:0:2:0: [sde] CDB: Write(10): 2a 00
> 00 00 28 78 00 04 00 00
> > Oct 23 17:13:56 (none) kernel: mptscsih: ioc2: task abort: SUCCESS
> (sc=e733b280)
> > Oct 23 17:13:57 (none) kernel: mptscsih: ioc2: attempting task abort!
> (sc=e733b280)
> > Oct 23 17:13:57 (none) kernel: sd 2:0:2:0: [sde] CDB: Write(10): 2a 00
> 00 00 28 78 00 04 00 00
> > Oct 23 17:13:57 (none) kernel: mptscsih: ioc2: task abort: SUCCESS
> (sc=e733b280)
> > Oct 23 17:13:57 (none) kernel: mptscsih: ioc2: attempting task abort!
> (sc=e733b280)
> > Oct 23 17:13:57 (none) kernel: sd 2:0:2:0: [sde] CDB: Write(10): 2a 00
> 00 00 28 78 00 04 00 00
> > Oct 23 17:13:57 (none) kernel: mptscsih: ioc2: task abort: SUCCESS
> (sc=e733b280)
> > Oct 23 17:13:57 (none) kernel: mptscsih: ioc2: attempting task abort!
> (sc=e733b280)
> > Oct 23 17:13:57 (none) kernel: sd 2:0:2:0: [sde] CDB: Write(10): 2a 00
> 00 00 28 78 00 04 00 00
> > Oct 23 17:13:57 (none) kernel: mptscsih: ioc2: task abort: SUCCESS
> (sc=e733b280)
> > Oct 23 17:13:57 (none) kernel: mptscsih: ioc2: attempting task abort!
> (sc=e733b280)
> > Oct 23 17:13:57 (none) kernel: sd 2:0:2:0: [sde] CDB: Write(10): 2a 00
> 00 00 28 78 00 04 00 00
> > Oct 23 17:13:57 (none) kernel: mptscsih: ioc2: task abort: SUCCESS
> (sc=e733b280)
> > Oct 23 17:13:57 (none) kernel: mptscsih: ioc2: attempting task abort!
> (sc=e733b280)
> > Oct 23 17:13:57 (none) kernel: sd 2:0:2:0: [sde] CDB: Write(10): 2a 00
> 00 00 28 78 00 04 00 00
> > Oct 23 17:13:58 (none) kernel: mptscsih: ioc2: task abort: SUCCESS
> (sc=e733b280)
> > Oct 23 17:13:58 (none) kernel: mptscsih: ioc2: attempting task abort!
> (sc=e733b280)
> > Oct 23 17:13:58 (none) kernel: sd 2:0:2:0: [sde] CDB: Write(10): 2a 00
> 00 00 28 78 00 04 00 00
> > Oct 23 17:13:58 (none) kernel: mptscsih: ioc2: task abort: SUCCESS
> (sc=e733b280)
> > Oct 23 17:13:58 (none) kernel: mptscsih: ioc2: attempting task abort!
> (sc=e733b280)
> > Oct 23 17:13:58 (none) kernel: sd 2:0:2:0: [sde] CDB: Write(10): 2a 00
> 00 00 28 78 00 04 00 00
> > Oct 23 17:13:58 (none) kernel: mptscsih: ioc2: task abort: SUCCESS
> (sc=e733b280)
> > Oct 23 17:13:58 (none) kernel: mptscsih: ioc2: attempting task abort!
> (sc=e733b280)
> > Oct 23 17:13:58 (none) kernel: sd 2:0:2:0: [sde] CDB: Write(10): 2a 00
> 00 00 28 78 00 04 00 00
> > Oct 23 17:13:58 (none) kernel: mptscsih: ioc2: task abort: SUCCESS
> (sc=e733b280)
> > Oct 23 17:13:58 (none) kernel: mptscsih: ioc2: attempting task abort!
> (sc=e733b280)
> > Oct 23 17:13:58 (none) kernel: sd 2:0:2:0: [sde] CDB: Write(10): 2a 00
> 00 00 28 78 00 04 00 00
> > Oct 23 17:13:58 (none) kernel: mptscsih: ioc2: task abort: SUCCESS
> (sc=e733b280)
> > Oct 23 17:13:58 (none) kernel: mptscsih: ioc2: attempting task abort!
> (sc=e733b280)
> > Oct 23 17:13:59 (none) kernel: sd 2:0:2:0: [sde] CDB: Write(10): 2a 00
> 00 00 28 78 00 04 00 00
> > Oct 23 17:13:59 (none) kernel: mptscsih: ioc2: task abort: SUCCESS
> (sc=e733b280)
> > Oct 23 17:13:59 (none) kernel: mptscsih: ioc2: attempting task abort!
> (sc=e733b280)
> > Oct 23 17:13:59 (none) kernel: sd 2:0:2:0: [sde] CDB: Write(10): 2a 00
> 00 00 28 78 00 04 00 00
> > Oct 23 17:13:59 (none) kernel: mptscsih: ioc2: task abort: SUCCESS
> (sc=e733b280)
> > Oct 23 17:13:59 (none) kernel: mptscsih: ioc2: attempting task abort!
> (sc=e733b280)
> > Oct 23 17:13:59 (none) kernel: sd 2:0:2:0: [sde] CDB: Write(10): 2a 00
> 00 00 28 78 00 04 00 00
> > Oct 23 17:13:59 (none) kernel: mptscsih: ioc2: task abort: SUCCESS
> (sc=e733b280)
> > Oct 23 17:13:59 (none) kernel: mptscsih: ioc2: attempting task abort!
> (sc=e733b280)
> > Oct 23 17:13:59 (none) kernel: sd 2:0:2:0: [sde] CDB: Write(10): 2a 00
> 00 00 28 78 00 04 00 00
> > Oct 23 17:13:59 (none) kernel: mptscsih: ioc2: task abort: SUCCESS
> (sc=e733b280)
> > Oct 23 17:13:59 (none) kernel: mptscsih: ioc2: attempting task abort!
> (sc=e733b280)
> > Oct 23 17:13:59 (none) kernel: sd 2:0:2:0: [sde] CDB: Write(10): 2a 00
> 00 00 28 78 00 04 00 00
> > Oct 23 17:13:59 (none) kernel: mptscsih: ioc2: task abort: SUCCESS
> (sc=e733b280)
> >
> >
> > --
> > +------------------------------------------------------------------+
> > | James   W.   Laferriere | System    Techniques | Give me VMS     |
> > | Network&System Engineer | 2133    McCullam Ave |  Give me Linux  |
> > | babydr@baby-dragons.com | Fairbanks, AK. 99701 |   only  on  AXP |
> > +------------------------------------------------------------------+
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel"
> in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
>
> --
> +------------------------------------------------------------------+
> | James   W.   Laferriere | System    Techniques | Give me VMS     |
> | Network&System Engineer | 2133    McCullam Ave |  Give me Linux  |
> | babydr@baby-dragons.com | Fairbanks, AK. 99701 |   only  on  AXP |
> +------------------------------------------------------------------+

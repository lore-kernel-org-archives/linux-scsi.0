From: Douglas Gilbert <dougg@torque.net>
Subject: SG_IO ioctl (was: mode sense blacklist how)
Date: Fri, 21 Nov 2003 11:17:16 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3FBD679C.5010405@torque.net>
References: <Pine.LNX.4.44L0.0311131638320.949-100000@ida.rowland.org>	 <1068767049.2851.166.camel@patrh9>	 <1068768796.3fb41e1c8d075@webmail.netregistry.net>	 <1068775834.2851.321.camel@patrh9>	 <20031113181945.I30194@one-eyed-alien.net>	 <1068777510.2851.359.camel@patrh9>	 <1068779468.3fb447ccc6e60@webmail.netregistry.net>	 <1068838908.2852.34.camel@patrh9>	 <1069246502.3fbb6826955dd@webmail.netregistry.net>	 <1069261377.2867.37.camel@patrh9>  <3FBBFDFB.9010406@torque.net> <1069345927.6663.27.camel@patrh9>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bunyip.cc.uq.edu.au ([130.102.2.1]:19463 "EHLO
	bunyip.cc.uq.edu.au") by vger.kernel.org with ESMTP id S262844AbTKUBab
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Nov 2003 20:30:31 -0500
In-Reply-To: <1069345927.6663.27.camel@patrh9>
List-Id: linux-scsi@vger.kernel.org
To: Pat LaVarre <p.lavarre@ieee.org>
Cc: linux-scsi@vger.kernel.org

Pat LaVarre wrote:
>>>>The only really important question IMHO is
>>>>how come SG_IO is not interruptible.
>>>
>>>Yes, now being pursued by Doug G in this thread.
>>
>>block/scsi_ioctl.c...
>>I suspect ... cannot interrupt the sg_io... blk_do_rq...
>>Perhaps someone could enlighten me (and I could document it).
>>
>>Further it looks like the SCSI_IOCTL_SEND_COMMAND is not
>>interruptible either. See scsi_wait_req() in scsi_lib.c .
> 
> 
> Open question I see.
> 
> 
>>Apologies in advance for each reboot these experiments force on you.
>>...
>>sg.c .... coping with orphaned SCSI responses from user killed
>>processes requires a lot of logic ...
> 
> 
> Ouch.
> 
> Designing an lk 2.6 user app to recommend more prominent devie names
> like /dev/hdd and /dev/scd0 in place of less prominent /dev/sg$n names
> thereby steers people into using the less robust pass thru of SG_IO via
> block/scsi_ioctl.c.

Pat,
Well it's a trade-off. If you use the SG_IO in
the block layer then:

Pros:
   - convenience (for block devices)
   - no device mapping problems (sd <-> sg) **

Cons:
   - no help for "non-block" devices: tapes, enclosures,
     OSD, etc
   - inherit block layer policy (e.g. 128 KB xfer limit,
     direct IO alignment)
   - unable to interrupt a SCSI command in progress with
     a signal
   - associated ioctls are dummies or not there, hence unable
     to reset device/bus/host (for example)
   - no driver or host error reporting (only SCSI status)

I'm sure more "cons" will come to light and some will be
addressed. There is probably enough there already to give
the cdrecord author pause for thought.

>>I suspect ... cannot interrupt ...
> 
> 
> Sorry I'm too much of a kernelnewbie to guess confidently the full
> implications of "not interruptible".  Does "not interruptible" mean
> timeouts don't work, or does "not interruptible" mean that only timeouts
> work, or does "not interruptible" mean that only timeouts and resets but
> not SIGINT of the calling process works ...

"Linux Kernel Development" Robert Love ISBN 0-672-32512-8 covers
lk 2.6 pretty well including these issues. [Note in passing: the
book makes no mention of the SCSI or ATA subsystems or aio:-(]

"not interruptible" in this context means that signals (e.g.
control-C from the keyboard or kill-9) have no effect while
waiting for the SCSI response. The SCSI command timeout should
bring things back but often at the expense of a bus reset (on
SPI) which can have some nasty side effects (e.g. if your root
file system is on a disk on the same SPI bus).


** The sd/sr/st <-> sg mapping problem would be much simpler
in lk 2.6 if sg (plus st + osst) had sysfs visibility. Perhaps
udev could work out this mapping but this would still rely
on polling through sg, st and osst file descriptors with the
attendant problems that brings (e.g. blocking, O_EXCL, O(n)).

Doug Gilbert





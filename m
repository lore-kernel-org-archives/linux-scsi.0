From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH] instrument ide-scsi in 2.5.68
Date: Tue, 06 May 2003 18:38:39 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3EB7748F.2030702@torque.net>
References: <3EB11AD3.2070503@torque.net>	<3EB22F09.7060906@torque.net>	<20030502095536.76dba4dd.rddunlap@osdl.org>	<3EB385F3.6010708@torque.net> <20030505095715.6d96e703.rddunlap@osdl.org>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bunyip.cc.uq.edu.au ([130.102.2.1]:43787 "EHLO
	bunyip.cc.uq.edu.au") by vger.kernel.org with ESMTP id S262443AbTEFIXe
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 6 May 2003 04:23:34 -0400
In-Reply-To: <20030505095715.6d96e703.rddunlap@osdl.org>
List-Id: linux-scsi@vger.kernel.org
To: "Randy.Dunlap" <rddunlap@osdl.org>
Cc: linux-scsi@vger.kernel.org, alan@lxorguk.ukuu.org.uk

Randy.Dunlap wrote:
> On Sat, 03 May 2003 19:03:47 +1000 Douglas Gilbert <dougg@torque.net> wrote:
> 
> | > | As Randy has found the setting of kernel boot time parameters
> | > | doesn't work. The problem seems to be that the ide subsystem
> | > | asserts ownership over all parameters that start with "ide".
> | > | I was unable to bend moduleparam.h to accept a leading underscore
> | > | so I went back to the old "__setup" method: the kernel boot time
> | > | parameters are now:
> | > |    - _ide_scsi_debug + _ide_scsi_suppress_reset
> | > 
> | > I'll confirm that those work.  I.e., I saw values 3 and 1 in
> | > /sys/bus/ide/drivers/ide-scsi/*.
> | > 
> | > | Module load time and sysfs parameters remain the same.
> | > | 
> | > | A new patch against lk 2.5.68 is attached.
> | > 
> | > Used that patch instead of v1 of it.  Got an oops in ide-scsi.
> | 
> | Randy,
> | Thanks for testing this. At this stage I have no
> | solution but can offer some analysis.
> | 
> | Firstly, it seems like Mandrake 9.0 has some
> | program like RedHat's "magicdev" that polls
> | cd/dvds every second or so. Nuke it please!
> | It won't fix the problem but will make it easier
> | to see the wood for the trees.
> 
> I'll happily do that if I can find it, since I don't use it anyway.
> However, I don't see it.  I also don't see any periodic activity
> after enabling scsi logging as Mike A. mentioned.
> 
> I did 'cdrecord -scanbus' and then
> cdrecord -v speed=4 dev=2,0,0 -data lca2003.iso
> and got the same oops as before (invalid ptr = 6b6b6bxx, into
> bad memory area).
> 
> 
> New kernel log file is now at
>   http://www.xenotime.net/linux/capture2.txt
> 
> Are there any docs on SCSI logging?

Randy,
The failure looks very similar. This time it timed
out and corrupted on a Mode Sense (10) for page 5
(alloc length=2) while last time its failed on a
Mode Sense (10) for page 0x2a (alloc length=2).
The Mode Sense is not translated (i.e. the app sent a
10 byte Mode Sense). Perhaps there is a weakness
when the allocation length is that short.

This time 141 commands where sent (last time 91)
with lots of Test Unit Readys. Without timestamps
it is hard to say whether a "magicdev" type program
is at work or libscg (cdrecord transport layer) is
solely responsible for that sequence of SCSI commands.
[cdrecord may be accessing the cdwriter via the cdrom
driver and the sg driver.]


Here is the point of failure from Randy's log:

ide-scsi: hdd: que 141, cmd = [ 5a 0 5 0 0 0 0 0 2 0 ]
hdd: lost interrupt
ide-scsi: Reached idescsi_pc_intr interrupt handler
ide-scsi: hdd: DMA complete
ide-scsi: CoD != 0 in idescsi_pc_intr
hdd: DMA disabled
Error handler scsi_eh_2 waking up
scsi_eh_<pr4>t_hfdadi: lA_TstAaPIts r: e2se:t0: 0co:m0 plcmetdse
failiedde:- sc0s,i :c anRecaeclh: ed1
idTeosctsali_ pofc_ 1in ctro mminantdersr oupnt 1  hdanedvliceres
  rePaqcuikrete  ceho mmwoanrdk
....

Ouch, after the error handler starts the dump looks like it
is in Klingon :-) Lots of data but no information. It could
be a result of the corruption or another problem.

BTW I ran Kurt Garloff's rescan-scsi-bus.sh script and
got this:
# lsscsi
[0:0:1:0]    disk    FUJITSU  MAM3184MP        0106  /dev/sda
[2:0:0:0]    cd      CREATIVE CD5233E          1.00  /dev/sr0
[2:0:1:0]    cd      CREATIVE CD5233E          1.00  /dev/sr1
[2:0:2:0]    cd      CREATIVE CD5233E          1.00  /dev/sr2
[2:0:3:0]    cd      CREATIVE CD5233E          1.00  /dev/sr3
[2:0:4:0]    cd      CREATIVE CD5233E          1.00  /dev/sr4
[2:0:5:0]    cd      CREATIVE CD5233E          1.00  /dev/sr5
[2:0:6:0]    cd      CREATIVE CD5233E          1.00  /dev/sr6
[2:0:7:0]    cd      CREATIVE CD5233E          1.00  /dev/sr7
[3:0:6:0]    tape    SONY     SDT-7000         0192  /dev/st0

Another problem ...

Doug Gilbert




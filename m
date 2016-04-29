From: Laurence Oberman <loberman@redhat.com>
Subject: Re: [dm-devel] [Lsf] Notes from the four separate IO track sessions
 at LSF/MM
Date: Fri, 29 Apr 2016 17:51:31 -0400 (EDT)
Message-ID: <2009387014.32589776.1461966691447.JavaMail.zimbra@redhat.com>
References: <1461800389.2311.70.camel@HansenPartnership.com> <20160428121108.GA9903@redhat.com> <1461858038.2307.16.camel@HansenPartnership.com> <5722320E.5080202@sandisk.com> <610090691.32303585.1461860624844.JavaMail.zimbra@redhat.com> <57223D36.60304@sandisk.com> <74308856.32308210.1461862044976.JavaMail.zimbra@redhat.com> <850484819.32589649.1461966427528.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx3-phx2.redhat.com ([209.132.183.24]:56500 "EHLO
	mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751679AbcD2Vvj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 29 Apr 2016 17:51:39 -0400
In-Reply-To: <850484819.32589649.1461966427528.JavaMail.zimbra@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: linux-block@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, Mike Snitzer <snitzer@redhat.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, device-mapper development <dm-devel@redhat.com>, lsf@lists.linux-foundation.org, Benjamin Marzinski <bmarzins@redhat.com>

One small correction

In the cut and past the mpath timing was this. I had a cut and past error in my prior message.

Fri Apr 29 17:16:14 EDT 2016
mpathe (360014052a6f5f9f256d4c1097eedfd95) dm-2 LIO-ORG ,block-13
size=20G features='1 queue_if_no_path' hwhandler='0' wp=rw
`-+- policy='service-time 0' prio=1 status=active
  |- 0:0:0:12 sds  65:32  active ready running
  |- 0:0:1:12 sdbh 67:176 active ready running
  |- 1:0:0:12 sdr  65:16  active ready running
  `- 1:0:1:12 sdbi 67:192 active ready running

Start again here so its the same 5 minutes while we are in the error_handler

Fri Apr 29 17:21:26 EDT 2016
mpathe (360014052a6f5f9f256d4c1097eedfd95) dm-2 LIO-ORG ,block-13
size=20G features='1 queue_if_no_path' hwhandler='0' wp=rw
`-+- policy='service-time 0' prio=1 status=active
  |- 0:0:0:12 sds  65:32  active ready  running
  |- 0:0:1:12 sdbh 67:176 failed faulty offline
  |- 1:0:0:12 sdr  65:16  active ready  running
  `- 1:0:1:12 sdbi 67:192 failed faulty offline

Laurence Oberman
Principal Software Maintenance Engineer
Red Hat Global Support Services

----- Original Message -----
From: "Laurence Oberman" <loberman@redhat.com>
To: "Bart Van Assche" <bart.vanassche@sandisk.com>
Cc: linux-block@vger.kernel.org, "linux-scsi" <linux-scsi@vger.kernel.org>, "Mike Snitzer" <snitzer@redhat.com>, "James Bottomley" <James.Bottomley@HansenPartnership.com>, "device-mapper development" <dm-devel@redhat.com>, lsf@lists.linux-foundation.org, "Benjamin Marzinski" <bmarzins@redhat.com>
Sent: Friday, April 29, 2016 5:47:07 PM
Subject: Re: [dm-devel] [Lsf] Notes from the four separate IO track sessions at LSF/MM

Hello Bart

I will email the entire log just to you. This is a summary only below of pertinent log messages.
I dont think the whole list will have an interest in all thge log messages.
When I sent the dull log to you I will include SCSI debug for the error handler stuff.


I ran the tests. This is a worst case test with 21 LUNS and jammed commands.
Typical failures like a port switch failure or link down wont be like this.
Also where we get RSCN's and we can react quicker we will.

In this case I simulated a hung switch issue like a backplane/mesh problem and believe me I see a lot of these 
black-holed SCSI command situations in real life.
Recovery with 21 LUNS is 300s that have in-flights to abort.

This configuration is a multibus configuration for multipath. 
Two qla2xx ports are connected to a switch and the 2 array pots are connected to the same switch.
This gives me 4 active/active paths for 21 mpath devices 

I start I/O to all 21 reading 64k blocks using dd and iflag=direct

Example mpath device
mpathf (360014056a5be89021364a4c90556bfbb) dm-7 LIO-ORG ,block-14        
size=20G features='1 queue_if_no_path' hwhandler='0' wp=rw
`-+- policy='service-time 0' prio=1 status=active
  |- 0:0:0:13 sdp  8:240  active ready running
  |- 0:0:1:13 sdbf 67:144 active ready running
  |- 1:0:0:13 sdo  8:224  active ready running
  `- 1:0:1:13 sdbg 67:160 active ready running

eh_deadline is set to 10 on the 2 qlogic ports, eh_timeout is set to 10 for all devices
In multipath fast_io_fail_tmo=5

I jam one of the target array ports and discard the commands effectively black-holing the commands and leave it that way until we recover and I watch the I/O.
The recovery takes around 300s even with all the tuning and this effectively lands up in Oracle cluster evictions.

Watching multipath -ll mpathe I will block as expected while in recovery

BLocked here
Fri Apr 29 17:16:14 EDT 2016
mpathe (360014052a6f5f9f256d4c1097eedfd95) dm-2 LIO-ORG ,block-13
size=20G features='1 queue_if_no_path' hwhandler='0' wp=rw
`-+- policy='service-time 0' prio=1 status=active
  |- 0:0:0:12 sds  65:32  active ready running
  |- 0:0:1:12 sdbh 67:176 active ready running
  |- 1:0:0:12 sdr  65:16  active ready running
  `- 1:0:1:12 sdbi 67:192 active ready running

Starte again here
Fri Apr 29 17:16:26 EDT 2016
mpathe (360014052a6f5f9f256d4c1097eedfd95) dm-2 LIO-ORG ,block-13
size=20G features='1 queue_if_no_path' hwhandler='0' wp=rw
`-+- policy='service-time 0' prio=1 status=active
  |- 0:0:0:12 sds  65:32  active ready  running
  |- 0:0:1:12 sdbh 67:176 failed faulty offline
  |- 1:0:0:12 sdr  65:16  active ready  running
  `- 1:0:1:12 sdbi 67:192 failed faulty offline

Tracking I/O
procs -----------memory---------- ---swap-- -----io---- -system-- ------cpu----- -----timestamp-----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa st                 EDT
 0 21      0 15409656  25580 452056    0    0 13740     0  367 2523  0  1 41 59  0 2016-04-29 17:16:17
 0 21      0 15408904  25580 452336    0    0 15872     0  378 2779  0  1 42 57  0 2016-04-29 17:16:18
 2 20      0 15408096  25580 452624    0    0 17612     0  399 3310  0  0 26 73  0 2016-04-29 17:16:19
 0 21      0 15407188  25580 453096    0    0 17860     0  412 3137  0  0 30 70  0 2016-04-29 17:16:20
 0 21      0 15410420  25580 451552    0    0 23116     0  900 6747  0  1 31 69  0 2016-04-29 17:16:21
 0 21      0 15410552  25580 451420    0    0 22664     0  430 3752  0  0 24 76  0 2016-04-29 17:16:22
 0 21      0 15410552  25580 451420    0    0 15700     0  325 2619  0  0 25 75  0 2016-04-29 17:16:23
 0 21      0 15410552  25580 451420    0    0 13648     0  303 2387  0  0 28 71  0 2016-04-29 17:16:24
..
.. Blocked
..
Starts recovering ~= 300s seconds later
..
 0 38      0 15406428  25860 452652    0    0  3208     0  859 2437  0  1 13 86  0 2016-04-29 17:21:20
 0 38      0 15405668  26244 452268    0    0  6640     0  499 3575  0  1  0 99  0 2016-04-29 17:21:21
 0 38      0 15406840  26496 452300    0    0  5372     0  273 1878  0  0  1 98  0 2016-04-29 17:21:22
 0 38      0 15402684  29156 452048    0    0  9700     0  318 2326  0  0 11 88  0 2016-04-29 17:21:23
 0 38      0 15400800  30152 452168    0    0 11876     0  433 3265  0  1 16 83  0 2016-04-29 17:21:24
 0 38      0 15399792  31140 452344    0    0 11804     0  394 2902  0  1 15 85  0 2016-04-29 17:21:25
 0 38      0 15398552  31952 452196    0    0 12908     0  417 3347  0  1  4 96  0 2016-04-29 17:21:26
 0 35      0 15394564  32660 452800    0    0 10904     0  575 4191  1  1  9 89  0 2016-04-29 17:21:27
 0 29      0 15394292  32968 452900    0    0 13356     0  602 3993  1  1  1 96  0 2016-04-29 17:21:28
 0 26      0 15394464  33692 452196    0    0 16124     0  764 5451  1  1  2 96  0 2016-04-29 17:21:29
 0 24      0 15394168  33880 452392    0    0 20156     0  479 3957  0  1  3 96  0 2016-04-29 17:21:30
 0 24      0 15394216  34008 452460    0    0 21760     0  456 3836  0  1  6 94  0 2016-04-29 17:21:31
 0 22      0 15393920  34016 452604    0    0 20104    28  437 3418  0  1 12 87  0 2016-04-29 17:21:32
 0 22      0 15393952  34016 452600    0    0 20352     0  483 3259  0  1 67 32  0 2016-04-29 17:21:33
 0 22      0 15394148  34016 452600    0    0 20560     0  451 3228  0  1 74 25  0 2016-04-29 17:21:34

I see the error handler start in the qlogic.
Keep in mind we are black-holed so after RESET we start the process again.

Apr 29 17:15:26 localhost root: Starting test with eh_deadline=10
Apr 29 17:16:54 localhost kernel: qla2xxx [0000:07:00.1]-801c:1: Abort command issued nexus=1:1:9 --  1 2002.
Apr 29 17:16:54 localhost kernel: qla2xxx [0000:07:00.0]-801c:0: Abort command issued nexus=0:1:7 --  1 2002.
Apr 29 17:16:54 localhost kernel: qla2xxx [0000:07:00.0]-801c:0: Abort command issued nexus=0:1:8 --  1 2002.
Apr 29 17:16:55 localhost kernel: qla2xxx [0000:07:00.1]-801c:1: Abort command issued nexus=1:1:6 --  1 2002.
Apr 29 17:16:55 localhost kernel: qla2xxx [0000:07:00.1]-801c:1: Abort command issued nexus=1:1:4 --  1 2002.
Apr 29 17:16:55 localhost kernel: qla2xxx [0000:07:00.1]-801c:1: Abort command issued nexus=1:1:3 --  1 2002.
Apr 29 17:16:55 localhost kernel: qla2xxx [0000:07:00.0]-801c:0: Abort command issued nexus=0:1:22 --  1 2002.
Apr 29 17:16:55 localhost kernel: qla2xxx [0000:07:00.1]-801c:1: Abort command issued nexus=1:1:23 --  1 2002.
Apr 29 17:16:55 localhost kernel: qla2xxx [0000:07:00.0]-801c:0: Abort command issued nexus=0:1:21 --  1 2002.
Apr 29 17:16:56 localhost kernel: qla2xxx [0000:07:00.1]-801c:1: Abort command issued nexus=1:1:2 --  1 2002.
Apr 29 17:16:56 localhost kernel: qla2xxx [0000:07:00.1]-801c:1: Abort command issued nexus=1:1:19 --  1 2002.
Apr 29 17:16:56 localhost kernel: qla2xxx [0000:07:00.1]-801c:1: Abort command issued nexus=1:1:18 --  1 2002.
Apr 29 17:16:56 localhost kernel: qla2xxx [0000:07:00.0]-801c:0: Abort command issued nexus=0:1:20 --  1 2002.
Apr 29 17:16:56 localhost kernel: qla2xxx [0000:07:00.0]-801c:0: Abort command issued nexus=0:1:1 --  1 2002.
Apr 29 17:16:56 localhost kernel: qla2xxx [0000:07:00.0]-801c:0: Abort command issued nexus=0:1:0 --  1 2002.
Apr 29 17:16:57 localhost kernel: qla2xxx [0000:07:00.1]-801c:1: Abort command issued nexus=1:1:17 --  1 2002.
Apr 29 17:16:57 localhost kernel: qla2xxx [0000:07:00.1]-801c:1: Abort command issued nexus=1:1:16 --  1 2002.
Apr 29 17:16:57 localhost kernel: qla2xxx [0000:07:00.0]-801c:0: Abort command issued nexus=0:1:10 --  1 2002.
Apr 29 17:16:58 localhost kernel: qla2xxx [0000:07:00.1]-801c:1: Abort command issued nexus=1:1:14 --  1 2002.
Apr 29 17:16:58 localhost kernel: qla2xxx [0000:07:00.1]-801c:1: Abort command issued nexus=1:1:13 --  1 2002.
Apr 29 17:16:58 localhost kernel: qla2xxx [0000:07:00.1]-801c:1: Abort command issued nexus=1:1:12 --  1 2002.
Apr 29 17:16:58 localhost kernel: qla2xxx [0000:07:00.0]-801c:0: Abort command issued nexus=0:1:0 --  1 2002.
Apr 29 17:17:00 localhost kernel: qla2xxx [0000:07:00.0]-801c:0: Abort command issued nexus=0:1:10 --  1 2002.
Apr 29 17:17:00 localhost kernel: qla2xxx [0000:07:00.0]-801c:0: Abort command issued nexus=0:1:12 --  1 2002.
Apr 29 17:17:01 localhost kernel: qla2xxx [0000:07:00.0]-801c:0: Abort command issued nexus=0:1:0 --  1 2002.
Apr 29 17:17:02 localhost kernel: qla2xxx [0000:07:00.0]-801c:0: Abort command issued nexus=0:1:1 --  1 2002.
Apr 29 17:17:03 localhost kernel: qla2xxx [0000:07:00.0]-801c:0: Abort command issued nexus=0:1:13 --  1 2002.
Apr 29 17:17:03 localhost kernel: qla2xxx [0000:07:00.0]-801c:0: Abort command issued nexus=0:1:14 --  1 2002.
Apr 29 17:17:03 localhost kernel: qla2xxx [0000:07:00.0]-801c:0: Abort command issued nexus=0:1:16 --  1 2002.
Apr 29 17:17:04 localhost kernel: qla2xxx [0000:07:00.0]-801c:0: Abort command issued nexus=0:1:17 --  1 2002.
Apr 29 17:17:09 localhost kernel: qla2xxx [0000:07:00.1]-8018:1: ADAPTER RESET ISSUED nexus=1:1:12.
Apr 29 17:17:09 localhost kernel: qla2xxx [0000:07:00.1]-00af:1: Performing ISP error recovery - ha=ffff88042a4b0000.
Apr 29 17:17:10 localhost kernel: qla2xxx [0000:07:00.1]-500a:1: LOOP UP detected (4 Gbps).
Apr 29 17:17:10 localhost kernel: qla2xxx [0000:07:00.1]-8017:1: ADAPTER RESET SUCCEEDED nexus=1:1:12.
Apr 29 17:17:30 localhost kernel: qla2xxx [0000:07:00.1]-801c:1: Abort command issued nexus=1:1:12 --  1 2002.
Apr 29 17:17:34 localhost kernel: qla2xxx [0000:07:00.0]-8018:0: ADAPTER RESET ISSUED nexus=0:1:17.
Apr 29 17:17:34 localhost kernel: qla2xxx [0000:07:00.0]-00af:0: Performing ISP error recovery - ha=ffff88042b030000.
Apr 29 17:17:35 localhost kernel: qla2xxx [0000:07:00.0]-500a:0: LOOP UP detected (4 Gbps).
Apr 29 17:17:35 localhost kernel: qla2xxx [0000:07:00.0]-8017:0: ADAPTER RESET SUCCEEDED nexus=0:1:17.
Apr 29 17:17:40 localhost kernel: qla2xxx [0000:07:00.1]-801c:1: Abort command issued nexus=1:1:10 --  1 2002.
Apr 29 17:17:50 localhost kernel: qla2xxx [0000:07:00.1]-801c:1: Abort command issued nexus=1:1:1 --  1 2002.
Apr 29 17:17:56 localhost kernel: qla2xxx [0000:07:00.0]-801c:0: Abort command issued nexus=0:1:17 --  1 2002.
Apr 29 17:18:00 localhost kernel: qla2xxx [0000:07:00.1]-801c:1: Abort command issued nexus=1:1:0 --  1 2002.
Apr 29 17:18:06 localhost kernel: qla2xxx [0000:07:00.0]-801c:0: Abort command issued nexus=0:1:18 --  1 2002.
Apr 29 17:18:10 localhost kernel: qla2xxx [0000:07:00.1]-801c:1: Abort command issued nexus=1:1:13 --  1 2002.
Apr 29 17:18:16 localhost kernel: qla2xxx [0000:07:00.0]-801c:0: Abort command issued nexus=0:1:19 --  1 2002.
Apr 29 17:18:20 localhost kernel: qla2xxx [0000:07:00.1]-801c:1: Abort command issued nexus=1:1:8 --  1 2002.
Apr 29 17:18:26 localhost kernel: qla2xxx [0000:07:00.0]-801c:0: Abort command issued nexus=0:1:8 --  1 2002.
Apr 29 17:18:30 localhost kernel: qla2xxx [0000:07:00.1]-801c:1: Abort command issued nexus=1:1:7 --  1 2002.
Apr 29 17:18:36 localhost kernel: qla2xxx [0000:07:00.0]-801c:0: Abort command issued nexus=0:1:22 --  1 2002.
Apr 29 17:18:40 localhost kernel: qla2xxx [0000:07:00.1]-801c:1: Abort command issued nexus=1:1:22 --  1 2002.
Apr 29 17:18:46 localhost kernel: qla2xxx [0000:07:00.0]-801c:0: Abort command issued nexus=0:1:21 --  1 2002.
Apr 29 17:18:50 localhost kernel: qla2xxx [0000:07:00.1]-801c:1: Abort command issued nexus=1:1:21 --  1 2002.
..
..
We start seeing the hung tasks

Apr 29 17:19:16 localhost kernel: INFO: task dd:10193 blocked for more than 120 seconds.
Apr 29 17:19:16 localhost kernel:      Not tainted 4.6.0-rc5+ #1
Apr 29 17:19:16 localhost kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Apr 29 17:19:16 localhost kernel: dd              D ffff8804303079d8     0 10193  10177 0x00000080
Apr 29 17:19:16 localhost kernel: ffff8804303079d8 ffff880434814140 ffff8800a86515c0 ffff880430308000
Apr 29 17:19:16 localhost kernel: 0000000000000000 7fffffffffffffff 0000000000000000 ffff8804307bfd00
Apr 29 17:19:16 localhost kernel: ffff8804303079f0 ffffffff816ba8e5 ffff880436696e00 ffff880430307aa0
Apr 29 17:19:16 localhost kernel: Call Trace:
Apr 29 17:19:16 localhost kernel: [<ffffffff816ba8e5>] schedule+0x35/0x80
Apr 29 17:19:16 localhost kernel: [<ffffffff816bd661>] schedule_timeout+0x231/0x2d0
Apr 29 17:19:16 localhost kernel: [<ffffffff81315843>] ? __blk_run_queue+0x33/0x40
Apr 29 17:19:16 localhost kernel: [<ffffffff813158ba>] ? queue_unplugged+0x2a/0xb0
Apr 29 17:19:16 localhost kernel: [<ffffffff816b9f66>] io_schedule_timeout+0xa6/0x110
Apr 29 17:19:16 localhost kernel: [<ffffffff81259332>] do_blockdev_direct_IO+0x1b52/0x2180
Apr 29 17:19:16 localhost kernel: [<ffffffff81254320>] ? I_BDEV+0x20/0x20
Apr 29 17:19:16 localhost kernel: [<ffffffff812599a3>] __blockdev_direct_IO+0x43/0x50
Apr 29 17:19:16 localhost kernel: [<ffffffff81254a7c>] blkdev_direct_IO+0x4c/0x50
Apr 29 17:19:16 localhost kernel: [<ffffffff81193ab1>] generic_file_read_iter+0x641/0x7b0
Apr 29 17:19:16 localhost kernel: [<ffffffff8120bcf5>] ? mem_cgroup_commit_charge+0x85/0x100
Apr 29 17:19:16 localhost kernel: [<ffffffff81254e57>] blkdev_read_iter+0x37/0x40
Apr 29 17:19:16 localhost kernel: [<ffffffff81219379>] __vfs_read+0xc9/0x100
Apr 29 17:19:16 localhost kernel: [<ffffffff8121a1ef>] vfs_read+0x7f/0x130
Apr 29 17:19:16 localhost kernel: [<ffffffff8121b6d5>] SyS_read+0x55/0xc0
Apr 29 17:19:16 localhost kernel: [<ffffffff81003c12>] do_syscall_64+0x62/0x110
Apr 29 17:19:16 localhost kernel: [<ffffffff816be4a1>] entry_SYSCALL64_slow_path+0x25/0x25
..
..

Finally after the serialized timeouts we get the offline states

Apr 29 17:19:26 localhost kernel: qla2xxx [0000:07:00.0]-801c:0: Abort command issued nexus=0:1:3 --  1 2002.
Apr 29 17:19:30 localhost kernel: qla2xxx [0000:07:00.1]-801c:1: Abort command issued nexus=1:1:17 --  1 2002.
Apr 29 17:19:36 localhost kernel: qla2xxx [0000:07:00.0]-801c:0: Abort command issued nexus=0:1:7 --  1 2002.
Apr 29 17:19:40 localhost kernel: qla2xxx [0000:07:00.1]-801c:1: Abort command issued nexus=1:1:18 --  1 2002.
Apr 29 17:19:46 localhost kernel: qla2xxx [0000:07:00.0]-801c:0: Abort command issued nexus=0:1:4 --  1 2002.
Apr 29 17:19:51 localhost kernel: qla2xxx [0000:07:00.1]-801c:1: Abort command issued nexus=1:1:19 --  1 2002.
Apr 29 17:19:56 localhost kernel: qla2xxx [0000:07:00.0]-801c:0: Abort command issued nexus=0:1:6 --  1 2002.
Apr 29 17:20:01 localhost kernel: qla2xxx [0000:07:00.1]-801c:1: Abort command issued nexus=1:1:2 --  1 2002.
Apr 29 17:20:06 localhost kernel: qla2xxx [0000:07:00.0]-801c:0: Abort command issued nexus=0:1:9 --  1 2002.
Apr 29 17:20:11 localhost kernel: qla2xxx [0000:07:00.1]-801c:1: Abort command issued nexus=1:1:23 --  1 2002.
Apr 29 17:20:16 localhost kernel: qla2xxx [0000:07:00.0]-801c:0: Abort command issued nexus=0:1:12 --  1 2002.
Apr 29 17:20:21 localhost kernel: qla2xxx [0000:07:00.1]-801c:1: Abort command issued nexus=1:1:3 --  1 2002.
Apr 29 17:20:26 localhost kernel: qla2xxx [0000:07:00.0]-801c:0: Abort command issued nexus=0:1:10 --  1 2002.
Apr 29 17:20:31 localhost kernel: qla2xxx [0000:07:00.1]-801c:1: Abort command issued nexus=1:1:4 --  1 2002.
Apr 29 17:20:37 localhost kernel: qla2xxx [0000:07:00.0]-801c:0: Abort command issued nexus=0:1:0 --  1 2002.
Apr 29 17:20:41 localhost kernel: qla2xxx [0000:07:00.1]-801c:1: Abort command issued nexus=1:1:6 --  1 2002.
Apr 29 17:20:47 localhost kernel: qla2xxx [0000:07:00.0]-801c:0: Abort command issued nexus=0:1:1 --  1 2002.
Apr 29 17:20:51 localhost kernel: qla2xxx [0000:07:00.1]-801c:1: Abort command issued nexus=1:1:9 --  1 2002.
Apr 29 17:20:51 localhost kernel: sd 1:0:1:12: Device offlined - not ready after error recovery
Apr 29 17:20:51 localhost kernel: sd 1:0:1:10: Device offlined - not ready after error recovery
Apr 29 17:20:51 localhost kernel: sd 1:0:1:1: Device offlined - not ready after error recovery
Apr 29 17:20:51 localhost kernel: sd 1:0:1:0: Device offlined - not ready after error recovery
Apr 29 17:20:51 localhost kernel: sd 1:0:1:13: Device offlined - not ready after error recovery
Apr 29 17:20:51 localhost kernel: device-mapper: multipath: Failing path 66:208.
Apr 29 17:20:51 localhost kernel: device-mapper: multipath: Failing path 68:192.
Apr 29 17:20:51 localhost kernel: device-mapper: multipath: Failing path 67:224.
Apr 29 17:20:51 localhost kernel: device-mapper: multipath: Failing path 67:192.
Apr 29 17:20:51 localhost multipathd: mpatha: sdat - path offline
Apr 29 17:20:51 localhost multipathd: checker failed path 66:208 in map mpatha
Apr 29 17:20:51 localhost multipathd: mpatha: remaining active paths: 3
Apr 29 17:20:51 localhost multipathd: mpathb: sdby - path offline
Apr 29 17:20:51 localhost multipathd: checker failed path 68:192 in map mpathb
Apr 29 17:20:51 localhost multipathd: mpathb: remaining active paths: 3
Apr 29 17:20:51 localhost multipathd: mpathc: sdbk - path offline
Apr 29 17:20:51 localhost multipathd: checker failed path 67:224 in map mpathc
Apr 29 17:20:51 localhost multipathd: mpathc: remaining active paths: 3
Apr 29 17:20:51 localhost multipathd: mpathe: sdbi - path offline
Apr 29 17:20:51 localhost multipathd: checker failed path 67:192 in map mpathe
Apr 29 17:20:51 localhost multipathd: mpathe: remaining active paths: 3
Apr 29 17:20:51 localhost kernel: sd 1:0:1:8: Device offlined - not ready after error recovery
Apr 29 17:20:51 localhost kernel: sd 1:0:1:7: Device offlined - not ready after error recovery
Apr 29 17:20:51 localhost kernel: sd 1:0:1:22: Device offlined - not ready after error recovery
Apr 29 17:20:51 localhost kernel: sd 1:0:1:21: Device offlined - not ready after error recovery
Apr 29 17:20:51 localhost kernel: sd 1:0:1:20: Device offlined - not ready after error recovery
Apr 29 17:20:51 localhost kernel: sd 1:0:1:14: Device offlined - not ready after error recovery
Apr 29 17:20:51 localhost kernel: sd 1:0:1:16: Device offlined - not ready after error recovery
Apr 29 17:20:51 localhost kernel: sd 1:0:1:17: Device offlined - not ready after error recovery
Apr 29 17:20:51 localhost kernel: sd 1:0:1:18: Device offlined - not ready after error recovery
Apr 29 17:20:51 localhost kernel: sd 1:0:1:19: Device offlined - not ready after error recovery
Apr 29 17:20:51 localhost kernel: sd 1:0:1:2: Device offlined - not ready after error recovery
..
..
Apr 29 17:20:51 localhost kernel: sd 1:0:1:12: [sdbi] tag#14 FAILED Result: hostbyte=DID_RESET driverbyte=DRIVER_OK
Apr 29 17:20:52 localhost kernel: sd 1:0:1:12: [sdbi] tag#14 CDB: Read(10) 28 00 00 00 00 00 00 00 08 00
Apr 29 17:20:52 localhost kernel: blk_update_request: I/O error, dev sdbi, sector 0
Apr 29 17:20:52 localhost kernel: sd 1:0:1:12: rejecting I/O to offline device
Apr 29 17:20:52 localhost kernel: sd 1:0:1:12: [sdbi] killing request
Apr 29 17:20:52 localhost kernel: sd 1:0:1:12: [sdbi] FAILED Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
Apr 29 17:20:52 localhost kernel: sd 1:0:1:12: [sdbi] CDB: Read(10) 28 00 00 02 5b 80 00 00 80 00
Apr 29 17:20:52 localhost kernel: blk_update_request: I/O error, dev sdbi, sector 154496
Apr 29 17:20:52 localhost kernel: sd 1:0:1:10: [sdbk] tag#13 FAILED Result: hostbyte=DID_RESET driverbyte=DRIVER_OK
Apr 29 17:20:52 localhost kernel: sd 1:0:1:10: [sdbk] tag#13 CDB: Read(10) 28 00 00 00 00 00 00 00 08 00
Apr 29 17:20:52 localhost kernel: blk_update_request: I/O error, dev sdbk, sector 0
Apr 29 17:20:52 localhost kernel: sd 1:0:1:1: [sdby] tag#16 FAILED Result: hostbyte=DID_RESET driverbyte=DRIVER_OK
Apr 29 17:20:52 localhost kernel: sd 1:0:1:1: [sdby] tag#16 CDB: Read(10) 28 00 00 00 00 00 00 00 08 00
Apr 29 17:20:52 localhost multipathd: mpathf: sdbg - path offline
Apr 29 17:20:52 localhost multipathd: checker failed path 67:160 in map mpathf
Apr 29 17:20:52 localhost multipathd: mpathf: remaining active paths: 3
Apr 29 17:20:52 localhost multipathd: mpathg: sdbe - path offline
Apr 29 17:20:52 localhost multipathd: checker failed path 67:128 in map mpathg
Apr 29 17:20:52 localhost multipathd: mpathg: remaining active paths: 3
Apr 29 17:20:52 localhost multipathd: mpathi: sdbc - path offline
Apr 29 17:20:52 localhost multipathd: checker failed path 67:96 in map mpathi
Apr 29 17:20:52 localhost multipathd: mpathi: remaining active paths: 3
Apr 29 17:20:52 localhost multipathd: mpathj: sdba - path offline
Apr 29 17:20:52 localhost multipathd: checker failed path 67:64 in map mpathj
Apr 29 17:20:52 localhost multipathd: mpathj: remaining active paths: 3
Apr 29 17:20:52 localhost multipathd: mpathk: sday - path offline
Apr 29 17:20:52 localhost multipathd: checker failed path 67:32 in map mpathk
Apr 29 17:20:52 localhost multipathd: mpathk: remaining active paths: 3
..
..
Apr 29 17:20:52 localhost kernel: device-mapper: multipath: Failing path 67:160.
Apr 29 17:20:52 localhost kernel: device-mapper: multipath: Failing path 67:128.
Apr 29 17:20:52 localhost kernel: device-mapper: multipath: Failing path 67:96.
Apr 29 17:20:52 localhost kernel: device-mapper: multipath: Failing path 67:64.
Apr 29 17:20:52 localhost kernel: device-mapper: multipath: Failing path 67:32.
Apr 29 17:20:52 localhost kernel: device-mapper: multipath: Failing path 66:240.
Apr 29 17:20:52 localhost kernel: device-mapper: multipath: Failing path 68:160.
Apr 29 17:20:52 localhost kernel: device-mapper: multipath: Failing path 69:0.
Apr 29 17:20:52 localhost kernel: device-mapper: multipath: Failing path 69:32.
Apr 29 17:20:52 localhost kernel: device-mapper: multipath: Failing path 69:64.
Apr 29 17:20:52 localhost kernel: device-mapper: multipath: Failing path 69:96.
Apr 29 17:20:52 localhost kernel: device-mapper: multipath: Failing path 68:128.
Apr 29 17:20:52 localhost kernel: device-mapper: multipath: Failing path 68:96.
Apr 29 17:20:52 localhost kernel: device-mapper: multipath: Failing path 68:64.
Apr 29 17:20:52 localhost kernel: device-mapper: multipath: Failing path 68:224.
Apr 29 17:20:52 localhost kernel: device-mapper: multipath: Failing path 68:32.
Apr 29 17:20:52 localhost kernel: device-mapper: multipath: Failing path 68:0.
Apr 29 17:20:52 localhost kernel: blk_update_request: I/O error, dev sdby, sector 0
Apr 29 17:20:52 localhost kernel: sd 1:0:1:0: [sdat] tag#15 FAILED Result: hostbyte=DID_RESET driverbyte=DRIVER_OK
Apr 29 17:20:52 localhost kernel: sd 1:0:1:0: [sdat] tag#15 CDB: Read(10) 28 00 00 00 00 00 00 00 08 00
Apr 29 17:20:52 localhost kernel: blk_update_request: I/O error, dev sdat, sector 0
Apr 29 17:20:52 localhost kernel: sd 1:0:1:13: [sdbg] tag#17 FAILED Result: hostbyte=DID_RESET driverbyte=DRIVER_OK
Apr 29 17:20:52 localhost kernel: sd 1:0:1:13: [sdbg] tag#17 CDB: Read(10) 28 00 00 00 00 00 00 00 08 00
Apr 29 17:20:53 localhost kernel: blk_update_request: I/O error, dev sdbg, sector 0
Apr 29 17:20:53 localhost kernel: sd 1:0:1:13: rejecting I/O to offline device
Apr 29 17:20:53 localhost kernel: sd 1:0:1:13: [sdbg] killing request
Apr 29 17:20:53 localhost kernel: sd 1:0:1:13: [sdbg] FAILED Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
Apr 29 17:20:53 localhost kernel: sd 1:0:1:13: [sdbg] CDB: Read(10) 28 00 00 02 5d 80 00 00 80 00
Apr 29 17:20:53 localhost kernel: blk_update_request: I/O error, dev sdbg, sector 155008
Apr 29 17:20:53 localhost kernel: sd 1:0:1:8: [sdbo] tag#31 FAILED Result: hostbyte=DID_RESET driverbyte=DRIVER_OK
Apr 29 17:20:53 localhost kernel: sd 1:0:1:8: [sdbo] tag#31 CDB: Read(10) 28 00 00 00 00 00 00 00 08 00
Apr 29 17:20:53 localhost kernel: blk_update_request: I/O error, dev sdbo, sector 0
Apr 29 17:20:53 localhost kernel: sd 1:0:1:7: [sdca] tag#30 FAILED Result: hostbyte=DID_RESET driverbyte=DRIVER_OK
Apr 29 17:20:53 localhost kernel: sd 1:0:1:7: [sdca] tag#30 CDB: Read(10) 28 00 00 00 00 00 00 00 08 00
Apr 29 17:20:53 localhost kernel: blk_update_request: I/O error, dev sdca, sector 0
Apr 29 17:20:53 localhost kernel: sd 1:0:1:22: [sdcg] tag#26 FAILED Result: hostbyte=DID_RESET driverbyte=DRIVER_OK
..
Apr 29 17:21:18 localhost multipathd: checker failed path 66:224 in map mpatha
Apr 29 17:21:18 localhost multipathd: mpatha: remaining active paths: 2
Apr 29 17:21:18 localhost multipathd: mpathb: sdbx - path offline
Apr 29 17:21:18 localhost multipathd: checker failed path 68:176 in map mpathb
Apr 29 17:21:18 localhost multipathd: mpathb: remaining active paths: 2
Apr 29 17:21:18 localhost multipathd: mpathc: sdbj - path offline
Apr 29 17:21:18 localhost multipathd: checker failed path 67:208 in map mpathc
Apr 29 17:21:18 localhost multipathd: mpathc: remaining active paths: 2
Apr 29 17:21:18 localhost multipathd: mpathe: sdbh - path offline
Apr 29 17:21:18 localhost multipathd: checker failed path 67:176 in map mpathe
Apr 29 17:21:18 localhost multipathd: mpathe: remaining active paths: 2
Apr 29 17:21:18 localhost multipathd: mpathf: sdbf - path offline
Apr 29 17:21:18 localhost multipathd: checker failed path 67:144 in map mpathf
Apr 29 17:21:18 localhost multipathd: mpathf: remaining active paths: 2
Apr 29 17:21:18 localhost multipathd: mpathg: sdbd - path offline
Apr 29 17:21:18 localhost multipathd: checker failed path 67:112 in map mpathg
Apr 29 17:21:18 localhost multipathd: mpathg: remaining active paths: 2
Apr 29 17:21:18 localhost multipathd: mpathi: sdbb - path offline
Apr 29 17:21:18 localhost multipathd: checker failed path 67:80 in map mpathi
Apr 29 17:21:18 localhost multipathd: mpathi: remaining active paths: 2
Apr 29 17:21:18 localhost multipathd: mpatho: sdbr - path offline
Apr 29 17:21:18 localhost multipathd: checker failed path 68:80 in map mpatho
Apr 29 17:21:18 localhost multipathd: mpatho: remaining active paths: 2
Apr 29 17:21:18 localhost multipathd: mpathq: sdbp - path offline
Apr 29 17:21:18 localhost multipathd: checker failed path 68:48 in map mpathq
Apr 29 17:21:18 localhost multipathd: mpathq: remaining active paths: 2
Apr 29 17:21:18 localhost multipathd: mpathv: sdbz - path offline
Apr 29 17:21:18 localhost multipathd: checker failed path 68:208 in map mpathv
Apr 29 17:21:18 localhost multipathd: mpathv: remaining active paths: 2
Apr 29 17:21:18 localhost multipathd: mpatht: sdbl - path offline
Apr 29 17:21:18 localhost multipathd: checker failed path 67:240 in map mpatht
Apr 29 17:21:18 localhost multipathd: mpatht: remaining active paths: 2
Apr 29 17:21:18 localhost kernel: device-mapper: multipath: Failing path 66:224.
Apr 29 17:21:18 localhost kernel: device-mapper: multipath: Failing path 68:176.
Apr 29 17:21:18 localhost kernel: device-mapper: multipath: Failing path 67:208.
Apr 29 17:21:18 localhost kernel: device-mapper: multipath: Failing path 67:176.
Apr 29 17:21:18 localhost kernel: device-mapper: multipath: Failing path 67:144.
Apr 29 17:21:18 localhost kernel: device-mapper: multipath: Failing path 67:112.
Apr 29 17:21:18 localhost kernel: device-mapper: multipath: Failing path 67:80.
Apr 29 17:21:18 localhost kernel: device-mapper: multipath: Failing path 68:80.
Apr 29 17:21:18 localhost kernel: device-mapper: multipath: Failing path 68:48.
Apr 29 17:21:18 localhost kernel: device-mapper: multipath: Failing path 68:208.
Apr 29 17:21:18 localhost kernel: device-mapper: multipath: Failing path 67:240.
Apr 29 17:21:18 localhost kernel: blk_update_request: I/O error, dev sdaw, sector 0
Apr 29 17:21:18 localhost kernel: sd 0:0:1:8: [sdbn] tag#25 FAILED Result: hostbyte=DID_RESET driverbyte=DRIVER_OK
Apr 29 17:21:18 localhost kernel: sd 0:0:1:8: [sdbn] tag#25 CDB: Read(10) 28 00 00 00 00 00 00 00 08 00
Apr 29 17:21:18 localhost kernel: blk_update_request: I/O error, dev sdbn, sector 0
Apr 29 17:21:18 localhost kernel: sd 0:0:1:8: rejecting I/O to offline device
Apr 29 17:21:18 localhost kernel: sd 0:0:1:8: [sdbn] killing request


Laurence Oberman
Principal Software Maintenance Engineer
Red Hat Global Support Services

----- Original Message -----
From: "Laurence Oberman" <loberman@redhat.com>
To: "Bart Van Assche" <bart.vanassche@sandisk.com>
Cc: linux-block@vger.kernel.org, "linux-scsi" <linux-scsi@vger.kernel.org>, "Mike Snitzer" <snitzer@redhat.com>, "James Bottomley" <James.Bottomley@HansenPartnership.com>, "device-mapper development" <dm-devel@redhat.com>, lsf@lists.linux-foundation.org
Sent: Thursday, April 28, 2016 12:47:24 PM
Subject: Re: [dm-devel] [Lsf] Notes from the four separate IO track sessions at LSF/MM

Hello Bart, This is when we have a subset of the paths fails.
As you know the remaining path wont be used until the eh_handler is either done or is short circuited.

What I will do is set this up via my jammer and capture a test using latest upstream.

Of course my customer pain points are all in the RHEL kernels so I need to capture a recovery trace
on the latest upstream kernel.

When the SCSI commands for a path are black-holed and remain that way, even with eh_deadline and the short circuited adapter resets 
we simply try again and get back in the wait loop until we finally declare the device offline.

This can take a while and differs depending on Qlogic, Emulex or fnic etc.

First thing tomorrow will set this up and show you what I mean.

Thanks!!

Laurence Oberman
Principal Software Maintenance Engineer
Red Hat Global Support Services

----- Original Message -----
From: "Bart Van Assche" <bart.vanassche@sandisk.com>
To: "Laurence Oberman" <loberman@redhat.com>
Cc: linux-block@vger.kernel.org, "linux-scsi" <linux-scsi@vger.kernel.org>, "Mike Snitzer" <snitzer@redhat.com>, "James Bottomley" <James.Bottomley@HansenPartnership.com>, "device-mapper development" <dm-devel@redhat.com>, lsf@lists.linux-foundation.org
Sent: Thursday, April 28, 2016 12:41:26 PM
Subject: Re: [dm-devel] [Lsf] Notes from the four separate IO track sessions at LSF/MM

On 04/28/2016 09:23 AM, Laurence Oberman wrote:
> We still suffer from periodic complaints in our large customer base
 > regarding the long recovery times for dm-multipath.
> Most of the time this is when we have something like a switch
 > back-plane issue or an issue where RSCN'S are blocked coming back up
 > the fabric. Corner cases still bite us often.
>
> Most of the complaints originate from customers for example seeing
 > Oracle cluster evictions where during the waiting on the mid-layer
 > all mpath I/O is blocked until recovery.
>
> We have to tune eh_deadline, eh_timeout and fast_io_fail_tmo but
 > even tuning those we have to wait on serial recovery even if we
 > set the timeouts low.
>
> Lately we have been living with
> eh_deadline=10
> eh_timeout=5
> fast_fail_io_tmo=10
> leaving default sd timeout at 30s
>
> So this continues to be an issue and I have specific examples using
 > the jammer I can provide showing the serial recovery times here.

Hello Laurence,

The long recovery times you refer to, is that for a scenario where all 
paths failed or for a scenario where some paths failed and other paths 
are still working? In the latter case, how long does it take before 
dm-multipath fails over to another path?

Thanks,

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

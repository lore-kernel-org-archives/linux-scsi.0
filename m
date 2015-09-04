From: Meelis Roos <mroos@linux.ee>
Subject: Re: Another (ESP?) scsi blk-mq problem on sparc64
Date: Fri, 4 Sep 2015 11:33:27 +0300 (EEST)
Message-ID: <alpine.LRH.2.11.1502051507290.9598@math.ut.ee>
References: <20141124162249.GG5050@linux.vnet.ibm.com> <547367DF.5060706@kernel.dk> <alpine.LRH.2.11.1411250022470.31497@siim2.ut.ee> <20141124.172857.1186013178918344826.davem@davemloft.net> <alpine.LRH.2.11.1501290952340.25245@math.ut.ee>
 <54CA61DF.30807@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:55824 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755171AbbIDIcv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 4 Sep 2015 04:32:51 -0400
In-Reply-To: <54CA61DF.30807@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: David Miller <davem@davemloft.net>, paulmck@linux.vnet.ibm.com, hch@infradead.org, linux-scsi@vger.kernel.org, sparclinux@vger.kernel.org

> > > > > > > > Yes, that does look like the case.  Do you have a good trick on
> > > > > > > > how
> > > > > > > > to allocate a map for the highest possible cpu number without
> > > > > > > > first
> > > > > > > > iterating the cpu map?  I couldn't find something that looks
> > > > > > > > like a
> > > > > > > > highest_possible_cpu() helper.
> > > > > > >
> > > > > > > Honestly I think that num_posible_cpus() should return the max of
> > > > > > > number of CPUs (weigt), and the highest numbered CPU. It's a pain
> > > > > > > in
> > > > > > > the butt to handle this otherwise.
> > > > > >
> > > > > > Hear, hear!!!  That would make my life easier, and would make this
> > > > > > sort
> > > > > > of problem much less likely to occur!
> > > > >
> > > > > How about this one?
> > > >
> > > > It make the machine work.
> > >
> > > Thanks for testing!
> > >
> >
> > What's the status of this fix? It is still not applied on yesterdays
> > 3.19.0-rc6-00105-gc59c961 git...
> 
> Hmm, I thought commit a33c1ba29138 took care of it... Does the attached work?

Sorry for taking so long - now I am back to the machine and turned it on 
yesterday. The machine is Sun Fire 3500 with 4 sparsely numbered 4 CPUs 
(6,7,18,19).

First I fetched 4.2.0 and tried it without any patches. That got the 
following error - seems to be blk-mq related but I do not rmemeber if it 
is exactly the same as before.

Next I tried 4.2 + your previously sent map-sz.patch but it makes no 
difference.

spitfire_data_access_exception: SFSR[0000000000801009] 
SFAR[fffffdff01b02310], going.
              \|/ ____ \|/
              "@'/ .. \`@"
              /_| \__/ |_\
                 \__U_/
swapper/6(1): Dax [#1]
CPU: 19 PID: 1 Comm: swapper/6 Not tainted 4.2.0 #67
task: fffff800fe092fe0 ti: fffff800fe0b8000 task.ti: fffff800fe0b8000
TSTATE: 0000000080001602 TPC: 000000000065bad4 TNPC: 000000000065bad8 Y: 
00000003    Not tainted
TPC: <kobject_init+0x14/0xa0>
g0: 0000000000000022 g1: 0000000080000000 g2: 0000000000000000 g3: 0000000000000001
g4: fffff800fe092fe0 g5: fffff800fe404000 g6: fffff800fe0b8000 g7: 0000000000000017
o0: 0000000000000000 o1: fffff800fe359bd0 o2: 00000000009c0c00 o3: 0000000000a2ba00
o4: fffff800fd50a368 o5: 0000000000000000 sp: fffff800fe0bafe1 ret_pc: 000000000065cd4c
RPC: <kobject_uevent_env+0x4c/0x500>
l0: fffff800fe092fe0 l1: fffff800fe042420 l2: 00000000008b15f0 l3: fffff800fe0bb9e0
l4: 00000000009bc415 l5: fffff8017e0bb9df l6: 0000000000000000 l7: fffff800fe193860
i0: 00000dff01b022d8 i1: 0000000000a4afe0 i2: 0000000000000000 i3: 0000000000a4aa28
i4: 00000000009c1448 i5: fffff800fe359bd0 i6: fffff800fe0bb091 i7: 000000000064a2c0
I7: <blk_mq_register_disk+0xe0/0x1a0>
Call Trace:
 [000000000064a2c0] blk_mq_register_disk+0xe0/0x1a0
 [000000000063f880] blk_register_queue+0xa0/0x120
 [000000000064dbfc] add_disk+0x33c/0x480
 [00000000006f3bd0] loop_add+0x190/0x280
 [0000000000a8c5b0] loop_init+0x160/0x1b0
 [0000000000426ea4] do_one_initcall+0xe4/0x1e0
 [0000000000a70b8c] kernel_init_freeable+0x130/0x1e0
 [000000000087cfa4] kernel_init+0x4/0x100
 [0000000000406124] ret_from_fork+0x1c/0x2c
 [0000000000000000]           (null)
Caller[000000000064a2c0]: blk_mq_register_disk+0xe0/0x1a0
Caller[000000000063f880]: blk_register_queue+0xa0/0x120
Caller[000000000064dbfc]: add_disk+0x33c/0x480
Caller[00000000006f3bd0]: loop_add+0x190/0x280
Caller[0000000000a8c5b0]: loop_init+0x160/0x1b0
Caller[0000000000426ea4]: do_one_initcall+0xe4/0x1e0
Caller[0000000000a70b8c]: kernel_init_freeable+0x130/0x1e0
Caller[000000000087cfa4]: kernel_init+0x4/0x100
Caller[0000000000406124]: ret_from_fork+0x1c/0x2c
Caller[0000000000000000]:           (null)
Instruction DUMP: 15002703  02c6401a  03200000 <c45e2038> 82088001  
22c84009  c20e203c  11002704  92100
Kernel panic - not syncing: Attempted to kill init! exitcode=0x00000009

Press Stop-A (L1-A) to return to the boot prom


-- 
Meelis Roos (mroos@linux.ee)

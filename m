From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: RE: tcm_fc+ libfcoe regression on v3.7-rc2
Date: Fri, 26 Oct 2012 18:05:08 -0700
Message-ID: <1351299908.13631.89.camel@haakon2.linux-iscsi.org>
References: <1351294400.13631.22.camel@haakon2.linux-iscsi.org>
	 <138EA028228D124A900F5E6746F3C2162F5AC54A@ORSMSX102.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <138EA028228D124A900F5E6746F3C2162F5AC54A@ORSMSX102.amr.corp.intel.com>
Sender: target-devel-owner@vger.kernel.org
To: "Zou, Yi" <yi.zou@intel.com>
Cc: target-devel <target-devel@vger.kernel.org>, openfcoe-devel <devel@open-fcoe.org>, "Rustad, Mark D" <mark.d.rustad@intel.com>, "Love, Robert W" <robert.w.love@intel.com>, Vasu Dev <vasu.dev@linux.intel.com>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2012-10-26 at 23:59 +0000, Zou, Yi wrote:
> > 
> > Hi MDR, Robert & Co,
> > 
> > During the process of updating target-pending.git/master to v3.7-rc2
> > this afternoon, I noticed the following warnings below when using
> > tcm_fc.
> > 
> > The Poison overwritten appears during each I/O, but the LUN SCAN + I/O
> > are seem to be still working as expected..
> > 
> > AFAICT there has not been anything effecting tcm_fc that has gone in
> > recently, so it looks like some type of libfcoe or libfc regression.
> > 
> > Any ideas where to start looking to track this down..?
> Nick,
> 
> I am seeing somewhat similar but not the same starting from merge window before the 
> rc1 tag but so far I was still not able to pin-down where it is and I am not able to reproduce the 
> problem anymore. The problem was exposed when somehow the initiator was zoned with
> SW target even though itself was not intended to involve the SW target. So I would like to know
> if I can reproduce this in your setup to track it down. The bug was found during lldp enable/disable 
> test w/ I/O running.

I'm not sure that tcm_fc + active I/O shutdown has gotten much testing
recently, so this is not completely surprising.  ;)

>  From what I can tell, it was related to exchange release path that the reference
> count on the exchange somehow is messed up. Originally, I was suspecting the cancel_delayed_work()
> is always returning true even we have no work pending that may have caused us to underflow
> the refcnt on exchange, but it was not the case.  While investigating that, one minor issue
> was fc_exch_find() may return a valid exchange evne though the xid is not matching up, I have
> a patch to fix that, however, the exchange pool must have already been messed up when that happens.
> 

Mmmmm, not sure on this one.  There have definitely been changes in the
TCM active I/O shutdown codepath to support tcm_qla2xxx active I/O
shutdown starting in v3.5 code, so if pre v3.5 code is working as
expected it might very well be it.

I'm happy to have a look at this some point in the next week to try and
reproduce in vn2vn mode.

> Anyway, I would like to mimic your setup to see if I can reproduce it.
> 

Sure, the latest target-pending/master HEAD should easily reproduce with
slub_debug=FPUZ.

Thanks Yi!

--nab

> The trace I had is pasted here FYI:
> ...
> kernel: Pid: 5072, comm: kworker/u:7 Tainted: G        W    3.6.0-upstream-net-next-ixgbe-queue-x86_64-g0b
> kernel: Call Trace:
> kernel: [<ffffffff810541ff>] warn_slowpath_common+0x7f/0xc0
> kernel: [<ffffffff810542f6>] warn_slowpath_fmt+0x46/0x50
> kernel: [<ffffffff8126bb01>] __list_del_entry+0xa1/0xd0
> kernel: [<ffffffff8126bb41>] list_del+0x11/0x40
> kernel: [<ffffffffa03adfaf>] fc_exch_delete+0x6f/0xb0 [libfc]
> kernel: [<ffffffffa03b1074>] fc_exch_timeout+0x124/0x150 [libfc]
> kernel: [<ffffffff81070c27>] process_one_work+0x177/0x430
> kernel: [<ffffffffa03b0f50>] ? fc_exch_rrq+0x220/0x220 [libfc]
> kernel: [<ffffffff8107303e>] worker_thread+0x12e/0x380
> kernel: [<ffffffff81072f10>] ? manage_workers+0x180/0x180
> kernel: [<ffffffff810781ae>] kthread+0xce/0xe0
> kernel: [<ffffffff815311c4>] kernel_thread_helper+0x4/0x10
> kernel: [<ffffffff810780e0>] ? kthread_freezable_should_stop+0x70/0x70
> kernel: [<ffffffff815311c0>] ? gs_change+0x13/0x13
> kernel: ---[] end trace f4c13caf2990c079 ]---
> kernel: ------------[] cut here ]------------
> kernel: WARNING: at lib/list_debug.c:59 __list_del_entry+0xa1/0xd0()
> kernel: Hardware name: PowerEdge T610
> kernel: list_del corruption. prev->next should be ffff88031cfeb2e0, but was ffffe8ffffc80348
> kernel: Pid: 5072, comm: kworker/u:7 Tainted: G        W    3.6.0-upstream-net-next-ixgbe-queue-x86_64-g0b
> kernel: Call Trace:
> kernel: [<ffffffff810541ff>] warn_slowpath_common+0x7f/0xc0
> kernel: [<ffffffff810542f6>] warn_slowpath_fmt+0x46/0x50
> kernel: [<ffffffff8126bb01>] __list_del_entry+0xa1/0xd0
> kernel: [<ffffffff8126bb41>] list_del+0x11/0x40
> kernel: [<ffffffffa03adfaf>] fc_exch_delete+0x6f/0xb0 [libfc]
> kernel: [<ffffffffa03b1074>] fc_exch_timeout+0x124/0x150 [libfc]
> kernel: [<ffffffff81070c27>] process_one_work+0x177/0x430
> kernel: [<ffffffffa03b0f50>] ? fc_exch_rrq+0x220/0x220 [libfc]
> kernel: [<ffffffff8107303e>] worker_thread+0x12e/0x380
> kernel: [<ffffffff81072f10>] ? manage_workers+0x180/0x180
> kernel: [<ffffffff810781ae>] kthread+0xce/0xe0
> kernel: [<ffffffff815311c4>] kernel_thread_helper+0x4/0x10
> kernel: [<ffffffff810780e0>] ? kthread_freezable_should_stop+0x70/0x70
> kernel: [<ffffffff815311c0>] ? gs_change+0x13/0x13
> kernel: ---[] end trace f4c13caf2990c07a ]---
> kernel: ixgbe 0000:05:00.0: Multiqueue Enabled: Rx Queue count = 24, Tx Queue count = 24
> kernel: ixgbe 0000:05:00.0 p3p1: detected SFP+: 5
> kernel: ixgbe 0000:05:00.0 p3p1: NIC Link is Up 10 Gbps, Flow Control: RX/TX
> kernel: BUG: soft lockup - CPU#6 stuck for 23s! [kworker/u:2:390]
> kernel: CPU 6
> kernel: Pid: 390, comm: kworker/u:2 Tainted: G        W    3.6.0-upstream-net-next-ixgbe-queue-x86_64-g0bf
> kernel: RIP: 0010:[<ffffffffa03afe6b>]  [<ffffffffa03afe6b>] fc_exch_reset+0x1b/0xf0 [libfc]
> kernel: RSP: 0018:ffff880326293c90  EFLAGS: 00000286
> kernel: RAX: ffff880326293fd8 RBX: ffff880326293c50 RCX: 0000000000b60300
> kernel: RDX: ffff8803263e00a0 RSI: 0000000000000001 RDI: ffff8803263e0080
> kernel: RBP: ffff880326293cb0 R08: 0000000000000004 R09: 0000000000000000
> kernel: R10: 0000000000000014 R11: 0000000000000001 R12: ffff880326293c68
> kernel: R13: ffff8803263e0100 R14: 0000000000000014 R15: ffff880326293c70
> kernel: FS:  0000000000000000(0000) GS:ffff88032fc60000(0000) knlGS:0000000000000000
> kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> kernel: CR2: 00007f91b6920000 CR3: 0000000001a0b000 CR4: 00000000000007e0
> kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> kernel: Process kworker/u:2 (pid: 390, threadinfo ffff880326292000, task ffff880326219540)
> kernel: Stack:
> kernel: ffff8801a53a06c0 ffffe8ffffc80340 0000000000000000 ffff8803263e0080
> kernel: ffff880326293d00 ffffffffa03affd7 ffff880326293d00 ffffffff00b60300
> kernel: 000000000000002c ffff8801a85b0840 ffffffff81ae6620 ffff8801a53a06c0
> kernel: Call Trace:
> kernel: [<ffffffffa03affd7>] fc_exch_pool_reset+0x97/0xe0 [libfc]
> kernel: [<ffffffffa03b0092>] fc_exch_mgr_reset+0x72/0xb0 [libfc]
> kernel: [<ffffffffa03b8ce0>] fc_rport_work+0x120/0x630 [libfc]
> kernel: [<ffffffff8106f8a2>] ? ftrace_raw_event_workqueue_execute_start+0xb2/0xc0
> kernel: [<ffffffff81070c27>] process_one_work+0x177/0x430
> kernel: [<ffffffffa03b8bc0>] ? fc_rport_recv_els_req+0x1d0/0x1d0 [libfc]
> kernel: [<ffffffff8107303e>] worker_thread+0x12e/0x380
> kernel: [<ffffffff81072f10>] ? manage_workers+0x180/0x180
> kernel: [<ffffffff810781ae>] kthread+0xce/0xe0
> kernel: [<ffffffff815311c4>] kernel_thread_helper+0x4/0x10
> kernel: [<ffffffff810780e0>] ? kthread_freezable_should_stop+0x70/0x70
> kernel: [<ffffffff815311c0>] ? gs_change+0x13/0x13
> kernel: Code: c0 e8 0a 4c 17 e1 e9 2a ff ff ff 0f 1f 44 00 00 55 48 89 e5 48 83 ec 20 48 89 1c 24 4c 89 64
> 4 24 18 <66> 66 66 66 90 48 89 fb e8 88 77 17 e1 31 f6 48 89 df e8 0e ea
> kernel: libfcoe: host3: Missing Discovery Advertisement for fab 20ac000dec96e941 count 1
> 

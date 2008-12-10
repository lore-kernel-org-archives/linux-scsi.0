From: "Shi, Harris" <Harris.Shi@lsi.com>
Subject: RE: question on block-layer timeout change
Date: Wed, 10 Dec 2008 16:11:29 -0700
Message-ID: <3568BBCB98C00041A9E622952FD5F24EA135D754@cosmail03.lsi.com>
References: <3568BBCB98C00041A9E622952FD5F24EA11C9F3A@cosmail03.lsi.com>
 <20081112072919.GB12192@linux.vnet.ibm.com>
 <3568BBCB98C00041A9E622952FD5F24EA1226673@cosmail03.lsi.com>
 <20081114171823.GA16575@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og113.obsmtp.com ([64.18.2.179]:43007 "EHLO
	exprod7og113.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753374AbYLJX2F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Dec 2008 18:28:05 -0500
In-Reply-To: <20081114171823.GA16575@us.ibm.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "malahal@us.ibm.com" <malahal@us.ibm.com>
Cc: Mike Anderson <andmike@linux.vnet.ibm.com>, SCSI development list <linux-scsi@vger.kernel.org>

Mike,

Your suggestion on MPP driver is working pretty good on FC config in term of failover and failback. However, recently when we switched over to iscsi config on SLES11beta6 (2.6.27.7-4-default, SLES11 kernel did not sync up with current upstream one, all of timeout management patch has been pulled in), we were consistently hit by the following panic when we tried to do failover via controller sysReboot or placed offline. Is it something related to the recent timeout management patch introduced into the kernel?

BUG: unable to handle kernel NULL pointer dereference at 00000000000000ba
IP: [<ffffffff80222047>] __ticket_spin_lock+0x5/0x1b
PGD 196cf6067 PUD 196c4f067 PMD 0
Oops: 0002 [1] SMP
last sysfs file: /sys/devices/system/cpu/cpu3/cache/index1/shared_cpu_map
CPU 2
Modules linked in: radeon drm crc32c libcrc32c ib_iser rdma_cm ib_cm iw_cm ib_sa ib_mad ib_core d
Supported: Yes, External
Pid: 0, comm: swapper Tainted: G          2.6.27.7-4-default #1
RIP: 0010:[<ffffffff80222047>]  [<ffffffff80222047>] __ticket_spin_lock+0x5/0x1b
RSP: 0018:ffff88019f187e20  EFLAGS: 00010086
RAX: 0000000000010000 RBX: 0000000000000002 RCX: ffff88019d8c3218
RDX: ffff88019cd3d000 RSI: 0000000000002007 RDI: 00000000000000ba
RBP: ffff880194940918 R08: ffff880194940c78 R09: 0000000000000000
R10: ffffffff80a65b80 R11: ffffffff8021c6ed R12: 0000000000000000
R13: ffff880194940b50 R14: ffff88019f187ed0 R15: ffff880194940c90
FS:  0000000000000000(0000) GS:ffff88019f157ec0(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 00000000000000ba CR3: 0000000196cc7000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 0, threadinfo ffff88019f180000, task ffff88019f17e280)
Stack:  ffffffff804aabe2 ffffffffa0321734 0000000000000000 ffff88018fc97c80
 ffff880194940918 ffffffffa0004f35 ffff88019d8c30d8 ffffffff8034b954
 ffff88019d8c30d8 ffffffff8034ba23 0000000000000282 0000000000000100
Call Trace:
 [<ffffffff804aabe2>] _spin_lock+0x13/0x15
 [<ffffffffa0321734>] iscsi_eh_cmd_timed_out+0x27/0xc0 [libiscsi]
 [<ffffffffa0004f35>] scsi_times_out+0x46/0x72 [scsi_mod]
 [<ffffffff8034b954>] blk_rq_timed_out+0xe/0x4a
 [<ffffffff8034ba23>] blk_rq_timed_out_timer+0x93/0x116
 [<ffffffff8024a5f5>] run_timer_softirq+0x19a/0x228
 [<ffffffff8024696d>] __do_softirq+0x84/0x115
 [<ffffffff8020ddac>] call_softirq+0x1c/0x28
 [<ffffffff8020f177>] do_softirq+0x3c/0x81
 [<ffffffff80246684>] irq_exit+0x3f/0x83
 [<ffffffff8021cf73>] smp_apic_timer_interrupt+0x95/0xae
 [<ffffffff8020d523>] apic_timer_interrupt+0x83/0x90
 [<ffffffff802134f4>] mwait_idle+0x3c/0x46
 [<ffffffff8020b3b5>] cpu_idle+0xa9/0xf1


Code: ff 00 00 c1 ea 10 39 c2 0f 95 c0 0f b6 c0 c3 8b 17 89 d0 c1 f8 10 29 d0 25 ff ff 00 00 ff
RIP  [<ffffffff80222047>] __ticket_spin_lock+0x5/0x1b
 RSP <ffff88019f187e20>
----------------------------------------------------------------------------

Your comment is very much appreciated.

Thanks.
Harris

-----Original Message-----
From: malahal@us.ibm.com [mailto:malahal@us.ibm.com]
Sent: Friday, November 14, 2008 11:18 AM
To: Shi, Harris
Cc: Mike Anderson; SCSI development list
Subject: Re: question on block-layer timeout change

Shi, Harris [Harris.Shi@lsi.com] wrote:
> Mike,
>
> Thanks for your valuable input.
>
> For item 1, how can I make sure that the timed-out command will have
> the timer modified via blk_add_timer given that one of following
> conditions has to be met,
>
> * timer isn't already pending or

I don't completely understand the RDAC architecture, but here are my
comments bases on what I read from your earlier email.

When your timed_out function is called, the timer is already fired

In your case, you should always return 'BLK_EH_RESET_TIMER'. This is
just to make sure that the command doesn't fail before you resubmit the
request to the real HBA adapter, I think.

> * this timeout value is earlier than an existing one.

When you return BLK_EH_RESET_TIMER, the block layer puts the command
again in its timeout queue and waits for another 'timeout' value before
calling your timer again.

You can send the request to real HBA divers after timeout expiry. If you
really want to fail, you can return some other value...

> Also where do I need to have a retry after reset the timer?
There is no retry of the command. If you return 'BLK_EH_RESET_TIMER' the
command is still with your driver and you can take another timeout value
to finish the request.

> For item 2, rq_timed_out_fn is tied with scsi_times_out at the very beginning. What's the purpose to tie a specific mpp method? How do we handle the case if timeout is triggered at this time?
>

When you send the request to the real HBA, the request timeout value
doesn't change. So Mike's suggestion is to have your own timed_out_fun
that returns BLK_EH_RESET_TIMER few times (effectively hijacking the
timeout value). See gdth_timed_out() for this case.

--Malahal.

> Harris
>
> -----Original Message-----
> From: Mike Anderson [mailto:andmike@linux.vnet.ibm.com]
> Sent: Wednesday, November 12, 2008 1:29 AM
> To: Shi, Harris
> Cc: Jens Axboe; Alan Stern; Tejun Heo; SCSI development list
> Subject: Re: question on block-layer timeout change
>
> Shi, Harris <Harris.Shi@lsi.com> wrote:
> >    Due to the current timeout management change, our RDAC (failover) driver
> >    had some difficulties in handling SCSI I/O timeout. The RDAC driver is in
> >    the similar        layer as HBA driver in that it will register into scsi
> >    mid-layer as scsi_host_template and stays below mid-layer. However, all
> >    scsi I/Os coming to RDAC stack are routed by a path then dispatched to the
> >    real HBA driver via mid-layer. We used to rely on the timer in
> >    scsi_cmnd->eh_timeout to deal with scsi i/o coming into the RDAC stack.
> >    Basically when I/O is coming to RDAC stack, we need to delete the timer
> >    for each I/O. Then after selecting a specific path for this I/O, we need
> >    to send the I/O back to mid-layer with a larger timeout value just to
> >    avoid the forced failover. When I/O completes successfully, we added the
> >    original timer back to the I/O and pass it over to upper block layer for
> >    further process.
> >
> >
> >
> >    However, with the current timeout management functions moving to block
> >    layer, it became difficult for us to explicitly control the timeout value
> >    for specific I/O.
> >
> >    Can you shed some lights on how to handle the I/O based timeout in this
> >    case?
> >
>
> Since long term mpp capabilities should be handled by dm-mp and the SCSI
> RDAC handler exporting functions to allow direct adding and deleting of the
> timer may not be something that would be needed long term. It may not be
> really clean to add these interfaces in.
>
> Could similar prior functionality be created by the following?
>         1.) To the RDAC vhba add a hostt->eh_timed_out function. In this
>         timeout function return BLK_EH_RESET_TIMER until it is done with
>         the command. Since the vhba does not have a transport
>         scsi_times_out should call this function on every timeout. There is
>         some overhead here depending on the default timeout value set in
>         timing out and then resetting the timer.
>
>         2.) For each sdev that is taken over store the previous
>         rq_timed_out_fn and then use blk_queue_rq_timed_out to set a mpp
>         specific function for the requests sent to the real HBA drivers.
>
>         3.) Set the timeout in the real HBA driver requests prior to
>         sending it to the mid layer.
>
> -andmike
> --
> Michael Anderson
> andmike@linux.vnet.ibm.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

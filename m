From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH] block: Make blk_drain_queue() work for stopped queues
Date: Wed, 21 Mar 2012 11:35:41 -0700
Message-ID: <CAA9_cmeiFPurvVU9hvHPUjRwRqtaBxoO-PJeWnBd27=XJ-tuEA@mail.gmail.com>
References: <4F65E09D.6010600@acm.org>
	<20120318155703.GB8045@dhcp-172-17-108-109.mtv.corp.google.com>
	<4F663BE3.4000503@acm.org>
	<20120319170435.GH11069@google.com>
	<4F68E34F.1060502@acm.org>
	<CAA9_cmcZUueDCc2dZXayWDqAoggXo1+pqqjpk8VLEbk5wrtdDA@mail.gmail.com>
	<CAA9_cmdp7Ov7ZrCv+NEuxs9WXAk0ts7uOo2UDxBAd_feT6gPLQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:60396 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759941Ab2CUSfm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Mar 2012 14:35:42 -0400
Received: by vbbff1 with SMTP id ff1so612785vbb.19
        for <linux-scsi@vger.kernel.org>; Wed, 21 Mar 2012 11:35:41 -0700 (PDT)
In-Reply-To: <CAA9_cmdp7Ov7ZrCv+NEuxs9WXAk0ts7uOo2UDxBAd_feT6gPLQ@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>, Stanislaw Gruszka <sgruszka@redhat.com>, linux-scsi <linux-scsi@vger.kernel.org>, Bartek Nowakowski <bartek.nowakowski@intel.com>, Jacek Danecki <jacek.danecki@intel.com>

On Tue, Mar 20, 2012 at 8:37 PM, Dan Williams <dan.j.williams@intel.com=
> wrote:
> On Tue, Mar 20, 2012 at 2:01 PM, Dan Williams <dan.j.williams@intel.c=
om> wrote:
>> On Tue, Mar 20, 2012 at 1:06 PM, Bart Van Assche <bvanassche@acm.org=
> wrote:
>> [..]
>>> - Fix a null pointer dereference triggered by sd during device remo=
val.
>>
>> Hi Bart,
>>
>> Do you have a log of the backtrace in this case? =A0I'm going to put
>> this patch into our libsas/isci test environment.
>
> We beat on this patch pretty severely in our environment and appeared
> to only trigger a hung_task timeout when our driver / libata took too
> long to recovery for a 15 device unplug. So...
>
> Acked-by: Dan Williams <dan.j.williams@intel.com>
> Tested-by: Jacek Danecki <jacek.danecki@intel.com>
> Tested-by: Bartek Nowakowski <bartek.nowakowski@intel.com>

So, we're still able to trigger what appears to be improper handling
of kblockd teardown even with this patch applied:

[ 1530.709739] BUG: unable to handle kernel NULL pointer dereference
at 0000000000000008
[ 1530.719307] IP: [<ffffffff8104455a>] __queue_work+0x2e5/0x332
[ 1530.726151] PGD 0
[ 1530.728807] Oops: 0000 [#1] SMP
[ 1530.732860] CPU 5
[ 1530.734924] Modules linked in: isci libsas scsi_transport_sas ipv6
kvm uinput wmi sg iTCO_wdt iTCO_vendor_support i2c_i801 i2c_core igb
e1000e ioatdma dca sd_mod ahci libahci libata [last unloaded:
scsi_wait_scan]
[ 1530.758269]
[ 1530.760337] Pid: 0, comm: swapper/5 Not tainted
3.3.0-rc7-isci-183_test+ #12 Intel Corporation S2600CP/S2600CP
[ 1530.772353] RIP: 0010:[<ffffffff8104455a>]  [<ffffffff8104455a>]
__queue_work+0x2e5/0x332
[ 1530.782294] RSP: 0018:ffff88043fd43bf0  EFLAGS: 00010046
[ 1530.788630] RAX: ffff8803fc7d2c30 RBX: ffff8803fbb6e040 RCX: 0000000=
000000000
[ 1530.797008] RDX: ffff8803fc7d2c38 RSI: ffff88043fd4d378 RDI: 0000000=
000000000
[ 1530.805384] RBP: ffff88043fd43c30 R08: 6b6b6b6b6b6b6b6b R09: 0000000=
000000001
[ 1530.813757] R10: 0000000000000000 R11: ffff88043fd4d358 R12: 0000000=
000000005
[ 1530.822132] R13: ffff88043fd56c00 R14: ffff88043fd4d340 R15: 0000000=
000000086
[ 1530.830503] FS:  0000000000000000(0000) GS:ffff88043fd40000(0000)
knlGS:0000000000000000
[ 1530.840322] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 1530.847136] CR2: 0000000000000008 CR3: 0000000001a05000 CR4: 0000000=
0000406e0
[ 1530.855509] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000=
000000000
[ 1530.863882] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000=
000000400
[ 1530.872261] Process swapper/5 (pid: 0, threadinfo ffff880428cbe000,
task ffff880428cc4160)
[ 1530.882281] Stack:
[ 1530.884913]  ffff880400000000 0000000000000000 ffff88040000024b
ffff8803fbb6dcd0
[ 1530.894018]  ffff8803fb402bc0 ffff8803fb402bc0 0000000000000000
0000000000000001
[ 1530.903144]  ffff88043fd43c40 ffffffff810445f0 ffff88043fd43c50
ffffffff81044745
[ 1530.912276] Call Trace:
[ 1530.915406]  <IRQ>
[ 1530.918157]  [<ffffffff810445f0>] queue_work_on+0x1b/0x22
[ 1530.924583]  [<ffffffff81044745>] queue_work+0x1f/0x21
[ 1530.930745]  [<ffffffff81247df1>] kblockd_schedule_work+0x15/0x17
[ 1530.937972]  [<ffffffff812596dd>] cfq_schedule_dispatch+0x41/0x45
[ 1530.945177]  [<ffffffff8125aacf>] cfq_completed_request+0x539/0x55d
[ 1530.952594]  [<ffffffff812436c2>] elv_completed_request+0x4a/0x4c
[ 1530.959808]  [<ffffffff812487dd>] __blk_put_request+0x38/0xba
[ 1530.966624]  [<ffffffff81248a72>] blk_finish_request+0x213/0x21f
[ 1530.973740]  [<ffffffff812496ec>] blk_end_bidi_request+0x42/0x5d
[ 1530.980851]  [<ffffffff81249743>] blk_end_request+0x10/0x12
[ 1530.987473]  [<ffffffff81249781>] blk_end_request_err+0x3c/0x41
[ 1530.994507]  [<ffffffff8132b244>] scsi_io_completion+0x46d/0x4cf
[ 1531.001661]  [<ffffffff81323e72>] scsi_finish_command+0xec/0xf5
[ 1531.008672]  [<ffffffff8132b3ba>] scsi_softirq_done+0xff/0x108
[ 1531.015600]  [<ffffffff8124ea08>] blk_done_softirq+0x84/0x98
[ 1531.022344]  [<ffffffff81032786>] __do_softirq+0xe8/0x1e5
[ 1531.028772]  [<ffffffff8148c014>] ? _raw_spin_unlock+0x2b/0x2f
[ 1531.035687]  [<ffffffff814941ec>] call_softirq+0x1c/0x26
[ 1531.042023]  [<ffffffff81003bdb>] do_softirq+0x4b/0xa3
[ 1531.048175]  [<ffffffff810324a8>] irq_exit+0x53/0xc8
[ 1531.054127]  [<ffffffff81494295>] do_IRQ+0x9d/0xb4
[ 1531.059882]  [<ffffffff8148c1f3>] common_interrupt+0x73/0x73
[ 1531.066620]  <EOI>
[ 1531.069407]  [<ffffffff812d0ef2>] ? acpi_idle_enter_simple+0xee/0x12=
a
[ 1531.077010]  [<ffffffff812d0eee>] ? acpi_idle_enter_simple+0xea/0x12=
a
[ 1531.084609]  [<ffffffff8148f695>] ? notifier_call_chain+0x63/0x63
[ 1531.091835]  [<ffffffff81397058>] cpuidle_idle_call+0x10b/0x1c7
[ 1531.098854]  [<ffffffff81001e73>] cpu_idle+0xc0/0x10d
[ 1531.104911]  [<ffffffff8148585b>] start_secondary+0x277/0x279
[ 1531.111728] Code: 54 49 8b 45 08 49 8d 76 38 f6 00 10 75 05 48 89
f2 eb 40 49 8b 46 38 eb 1f 4c 8b 00 31 ff 41 f6 c0 04 74 07 4c 89 c7
40 80 e7 00 <48> 8b 7f 08 f6 07 10 74 11 48 8b 40 08 48 83 e8 08 48 8d
50 08
[ 1531.135084] RIP  [<ffffffff8104455a>] __queue_work+0x2e5/0x332
[ 1531.142015]  RSP <ffff88043fd43bf0>
[ 1531.146301] CR2: 0000000000000008
[ 1531.150968] ---[ end trace 0711d1e925c5e6b1 ]---
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

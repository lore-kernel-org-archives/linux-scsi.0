From: Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH] scsi-mq: Always unprepare before requeuing a request
Date: Fri, 11 Aug 2017 11:05:22 +1000
Message-ID: <87r2widict.fsf@concordia.ellerman.id.au>
References: <20170803214014.20332-1-bart.vanassche@wdc.com> <yq14ltj9sjd.fsf@oracle.com> <8760dvn273.fsf@concordia.ellerman.id.au> <1502378800.2309.5.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ozlabs.org ([103.22.144.67]:43595 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751487AbdHKBFY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 10 Aug 2017 21:05:24 -0400
In-Reply-To: <1502378800.2309.5.camel@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "bjking1@us.ibm.com" <bjking1@us.ibm.com>, "jthumshirn@suse.de" <jthumshirn@suse.de>, Damien Le Moal <Damien.LeMoal@wdc.com>, "hch@lst.de" <hch@lst.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hare@suse.com" <hare@suse.com>, "inuxppc-dev@lists.ozlabs.org" <inuxppc-dev@lists.ozlabs.org>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>

Bart Van Assche <Bart.VanAssche@wdc.com> writes:
> On Thu, 2017-08-10 at 20:32 +1000, Michael Ellerman wrote:
>> "Martin K. Petersen" <martin.petersen@oracle.com> writes:
>> > > One of the two scsi-mq functions that requeue a request unprepares a
>> > > request before requeueing (scsi_io_completion()) but the other
>> > > function not (__scsi_queue_insert()). Make sure that a request is
>> > > unprepared before requeuing it.
>> > 
>> > Applied to 4.13/scsi-fixes. Thanks much!
>> 
>> This seems to be preventing my Power8 box, which uses IPR, from booting.
...
>
> Hello Michael,
>
> Thanks for having reported this early.

No worries.

> Is there any chance that you can
> reproduce this state, press SysRq-w on the console and collect the task
> overview that is reported on the console (see also Documentation/admin-guide/
> sysrq.rst)?

Here it is below. Doesn't seem to change over time.

I can do the scsi_logging_level thing as well as soon as I've got some
coffee :)

cheers


sysrq: SysRq : Show Blocked State
  task                        PC stack   pid father
swapper/0       D10080     1      0 0x00000800
Call Trace:
[c0000003f7583890] [c0000003f75838e0] 0xc0000003f75838e0 (unreliable)
[c0000003f7583a60] [c00000000001b3b8] __switch_to+0x2a8/0x460
[c0000003f7583ac0] [c0000000009abc60] __schedule+0x320/0xaa0
[c0000003f7583b90] [c0000000009ac420] schedule+0x40/0xb0
[c0000003f7583bc0] [c000000000110fc4] async_synchronize_cookie_domain+0xd4/0x150
[c0000003f7583c30] [c000000000619f94] wait_for_device_probe+0x44/0xe0
[c0000003f7583c90] [c000000000c64ce4] prepare_namespace+0x58/0x248
[c0000003f7583d00] [c000000000c64478] kernel_init_freeable+0x310/0x348
[c0000003f7583dc0] [c00000000000d6e4] kernel_init+0x24/0x150
[c0000003f7583e30] [c00000000000ba1c] ret_from_kernel_thread+0x5c/0xc0
kworker/u193:0  D12736     6      2 0x00000800
Workqueue: events_unbound async_run_entry_fn
Call Trace:
[c0000003f7597410] [c000000000150d00] console_unlock+0x330/0x770 (unreliable)
[c0000003f75975e0] [c00000000001b3b8] __switch_to+0x2a8/0x460
[c0000003f7597640] [c0000000009abc60] __schedule+0x320/0xaa0
[c0000003f7597710] [c0000000009ac420] schedule+0x40/0xb0
[c0000003f7597740] [c0000000009b09d4] schedule_timeout+0x254/0x440
[c0000003f7597820] [c0000000009aca80] io_schedule_timeout+0x30/0x60
[c0000003f7597850] [c0000000009ad75c] wait_for_common_io.constprop.2+0xbc/0x1e0
[c0000003f75978d0] [c000000000509e6c] blk_execute_rq+0x4c/0x70
[c0000003f7597920] [c000000000654abc] scsi_execute+0xfc/0x260
[c0000003f7597990] [c000000000654f98] scsi_mode_sense+0x218/0x410
[c0000003f7597aa0] [c00000000068ee68] sd_revalidate_disk+0x908/0x1cd0
[c0000003f7597be0] [c000000000690434] sd_probe_async+0xb4/0x220
[c0000003f7597c60] [c000000000110a20] async_run_entry_fn+0x70/0x170
[c0000003f7597ca0] [c000000000103904] process_one_work+0x2b4/0x560
[c0000003f7597d30] [c000000000103c38] worker_thread+0x88/0x5a0
[c0000003f7597dc0] [c00000000010bfcc] kthread+0x15c/0x1a0
[c0000003f7597e30] [c00000000000ba1c] ret_from_kernel_thread+0x5c/0xc0
kworker/u193:1  D12480   412      2 0x00000800
Workqueue: events_unbound async_run_entry_fn
Call Trace:
[c0000003f5907410] [c000000000150d00] console_unlock+0x330/0x770 (unreliable)
[c0000003f59075e0] [c00000000001b3b8] __switch_to+0x2a8/0x460
[c0000003f5907640] [c0000000009abc60] __schedule+0x320/0xaa0
[c0000003f5907710] [c0000000009ac420] schedule+0x40/0xb0
[c0000003f5907740] [c0000000009b09d4] schedule_timeout+0x254/0x440
[c0000003f5907820] [c0000000009aca80] io_schedule_timeout+0x30/0x60
[c0000003f5907850] [c0000000009ad75c] wait_for_common_io.constprop.2+0xbc/0x1e0
[c0000003f59078d0] [c000000000509e6c] blk_execute_rq+0x4c/0x70
[c0000003f5907920] [c000000000654abc] scsi_execute+0xfc/0x260
[c0000003f5907990] [c000000000654f98] scsi_mode_sense+0x218/0x410
[c0000003f5907aa0] [c00000000068ee68] sd_revalidate_disk+0x908/0x1cd0
[c0000003f5907be0] [c000000000690434] sd_probe_async+0xb4/0x220
[c0000003f5907c60] [c000000000110a20] async_run_entry_fn+0x70/0x170
[c0000003f5907ca0] [c000000000103904] process_one_work+0x2b4/0x560
[c0000003f5907d30] [c000000000103c38] worker_thread+0x88/0x5a0
[c0000003f5907dc0] [c00000000010bfcc] kthread+0x15c/0x1a0
[c0000003f5907e30] [c00000000000ba1c] ret_from_kernel_thread+0x5c/0xc0
kworker/u193:2  D12832   421      2 0x00000800
Workqueue: events_unbound async_run_entry_fn
Call Trace:
[c0000003f4103410] [c0000003f41035f0] 0xc0000003f41035f0 (unreliable)
[c0000003f41035e0] [c00000000001b3b8] __switch_to+0x2a8/0x460
[c0000003f4103640] [c0000000009abc60] __schedule+0x320/0xaa0
[c0000003f4103710] [c0000000009ac420] schedule+0x40/0xb0
[c0000003f4103740] [c0000000009b09d4] schedule_timeout+0x254/0x440
[c0000003f4103820] [c0000000009aca80] io_schedule_timeout+0x30/0x60
[c0000003f4103850] [c0000000009ad75c] wait_for_common_io.constprop.2+0xbc/0x1e0
[c0000003f41038d0] [c000000000509e6c] blk_execute_rq+0x4c/0x70
[c0000003f4103920] [c000000000654abc] scsi_execute+0xfc/0x260
[c0000003f4103990] [c000000000654f98] scsi_mode_sense+0x218/0x410
[c0000003f4103aa0] [c00000000068ee68] sd_revalidate_disk+0x908/0x1cd0
[c0000003f4103be0] [c000000000690434] sd_probe_async+0xb4/0x220
[c0000003f4103c60] [c000000000110a20] async_run_entry_fn+0x70/0x170
[c0000003f4103ca0] [c000000000103904] process_one_work+0x2b4/0x560
[c0000003f4103d30] [c000000000103c38] worker_thread+0x88/0x5a0
[c0000003f4103dc0] [c00000000010bfcc] kthread+0x15c/0x1a0
[c0000003f4103e30] [c00000000000ba1c] ret_from_kernel_thread+0x5c/0xc0
kworker/u193:3  D12832   428      2 0x00000800
Workqueue: events_unbound async_run_entry_fn
Call Trace:
[c0000003f4603410] [c000000000150d00] console_unlock+0x330/0x770 (unreliable)
[c0000003f46035e0] [c00000000001b3b8] __switch_to+0x2a8/0x460
[c0000003f4603640] [c0000000009abc60] __schedule+0x320/0xaa0
[c0000003f4603710] [c0000000009ac420] schedule+0x40/0xb0
[c0000003f4603740] [c0000000009b09d4] schedule_timeout+0x254/0x440
[c0000003f4603820] [c0000000009aca80] io_schedule_timeout+0x30/0x60
[c0000003f4603850] [c0000000009ad75c] wait_for_common_io.constprop.2+0xbc/0x1e0
[c0000003f46038d0] [c000000000509e6c] blk_execute_rq+0x4c/0x70
[c0000003f4603920] [c000000000654abc] scsi_execute+0xfc/0x260
[c0000003f4603990] [c000000000654f98] scsi_mode_sense+0x218/0x410
[c0000003f4603aa0] [c00000000068ee68] sd_revalidate_disk+0x908/0x1cd0
[c0000003f4603be0] [c000000000690434] sd_probe_async+0xb4/0x220
[c0000003f4603c60] [c000000000110a20] async_run_entry_fn+0x70/0x170
[c0000003f4603ca0] [c000000000103904] process_one_work+0x2b4/0x560
[c0000003f4603d30] [c000000000103c38] worker_thread+0x88/0x5a0
[c0000003f4603dc0] [c00000000010bfcc] kthread+0x15c/0x1a0
[c0000003f4603e30] [c00000000000ba1c] ret_from_kernel_thread+0x5c/0xc0
kworker/u193:4  D12832   546      2 0x00000800
Workqueue: events_unbound async_run_entry_fn
Call Trace:
[c0000003f4607410] [c0000003f46075f0] 0xc0000003f46075f0 (unreliable)
[c0000003f46075e0] [c00000000001b3b8] __switch_to+0x2a8/0x460
[c0000003f4607640] [c0000000009abc60] __schedule+0x320/0xaa0
[c0000003f4607710] [c0000000009ac420] schedule+0x40/0xb0
[c0000003f4607740] [c0000000009b09d4] schedule_timeout+0x254/0x440
[c0000003f4607820] [c0000000009aca80] io_schedule_timeout+0x30/0x60
[c0000003f4607850] [c0000000009ad75c] wait_for_common_io.constprop.2+0xbc/0x1e0
[c0000003f46078d0] [c000000000509e6c] blk_execute_rq+0x4c/0x70
[c0000003f4607920] [c000000000654abc] scsi_execute+0xfc/0x260
[c0000003f4607990] [c000000000654f98] scsi_mode_sense+0x218/0x410
[c0000003f4607aa0] [c00000000068ee68] sd_revalidate_disk+0x908/0x1cd0
[c0000003f4607be0] [c000000000690434] sd_probe_async+0xb4/0x220
[c0000003f4607c60] [c000000000110a20] async_run_entry_fn+0x70/0x170
[c0000003f4607ca0] [c000000000103904] process_one_work+0x2b4/0x560
[c0000003f4607d30] [c000000000103c38] worker_thread+0x88/0x5a0
[c0000003f4607dc0] [c00000000010bfcc] kthread+0x15c/0x1a0
[c0000003f4607e30] [c00000000000ba1c] ret_from_kernel_thread+0x5c/0xc0
kworker/u193:5  D12848  1893      2 0x00000800
Workqueue: events_unbound async_run_entry_fn
Call Trace:
[c0000003ec46f410] [c0000003ec46f5f0] 0xc0000003ec46f5f0 (unreliable)
[c0000003ec46f5e0] [c00000000001b3b8] __switch_to+0x2a8/0x460
[c0000003ec46f640] [c0000000009abc60] __schedule+0x320/0xaa0
[c0000003ec46f710] [c0000000009ac420] schedule+0x40/0xb0
[c0000003ec46f740] [c0000000009b09d4] schedule_timeout+0x254/0x440
[c0000003ec46f820] [c0000000009aca80] io_schedule_timeout+0x30/0x60
[c0000003ec46f850] [c0000000009ad75c] wait_for_common_io.constprop.2+0xbc/0x1e0
[c0000003ec46f8d0] [c000000000509e6c] blk_execute_rq+0x4c/0x70
[c0000003ec46f920] [c000000000654abc] scsi_execute+0xfc/0x260
[c0000003ec46f990] [c000000000654f98] scsi_mode_sense+0x218/0x410
[c0000003ec46faa0] [c00000000068ee68] sd_revalidate_disk+0x908/0x1cd0
[c0000003ec46fbe0] [c000000000690434] sd_probe_async+0xb4/0x220
[c0000003ec46fc60] [c000000000110a20] async_run_entry_fn+0x70/0x170
[c0000003ec46fca0] [c000000000103904] process_one_work+0x2b4/0x560
[c0000003ec46fd30] [c000000000103c38] worker_thread+0x88/0x5a0
[c0000003ec46fdc0] [c00000000010bfcc] kthread+0x15c/0x1a0
[c0000003ec46fe30] [c00000000000ba1c] ret_from_kernel_thread+0x5c/0xc0

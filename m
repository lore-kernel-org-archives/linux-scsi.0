From: Ren Mingxin <renmx@cn.fujitsu.com>
Subject: Re: [PATCHv3 0/9] New EH command timeout handler
Date: Wed, 07 Aug 2013 18:08:28 +0800
Message-ID: <52021C9C.9050603@cn.fujitsu.com>
References: <1372688671-85639-1-git-send-email-hare@suse.de> <51DF82B9.8030406@cn.fujitsu.com> <51DF9DB0.7080502@suse.de> <51DFD3D9.4080306@cn.fujitsu.com> <51DFDA12.4080905@suse.de> <51E39110.1080004@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:39715 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932372Ab3HGKED (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 7 Aug 2013 06:04:03 -0400
In-Reply-To: <51E39110.1080004@cn.fujitsu.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>, Bart van Assche <bvanassche@acm.org>, Joern Engel <joern@logfs.org>, James Smart <james.smart@emulex.com>, Roland Dreier <roland@purestorage.com>

Hi, Hannes:

On 07/15/2013 02:05 PM, Ren Mingxin wrote:
> On 07/12/2013 06:27 PM, Hannes Reinecke wrote:
>> On 07/12/2013 12:00 PM, Ren Mingxin wrote:
>>> On 07/12/2013 02:09 PM, Hannes Reinecke wrote:
>>>> On 07/12/2013 06:14 AM, Ren Mingxin wrote:
>>>>> On 07/01/2013 10:24 PM, Hannes Reinecke wrote:
>>>>>> With the original SCSI EH I got:
>>>>>> # time dd if=/dev/zero of=/dev/dm-2 bs=4k count=4k oflag=direct
>>>>>> 4096+0 records in
>>>>>> 4096+0 records out
>>>>>> 16777216 bytes (17 MB) copied, 142.652 s, 118 kB/s
>>>>>>
>>>>>> real    2m22.657s
>>>>>> user    0m0.013s
>>>>>> sys    0m0.145s
>>>>>>
>>>>>> With this patchset I got:
>>>>>> # time dd if=/dev/zero of=/dev/dm-2 bs=4k count=4k oflag=direct
>>>>>> 4096+0 records in
>>>>>> 4096+0 records out
>>>>>> 16777216 bytes (17 MB) copied, 52.1579 s, 322 kB/s
>>>>>>
>>>>>> real    0m52.163s
>>>>>> user    0m0.012s
>>>>>> sys    0m0.145s
>>>>>>
>>>>>> Test was to disable RSCN on the target port, disable the
>>>>>> target port, and then start the 'dd' command as indicated.
>>>>>
>>>>> Do you mean disabling RSCN/port is enough? I'm afraid I couldn't
>>>>> reproduce the problem by your steps. Both with and without your
>>>>> patchset are the same 'dd' result: 27s. Please let me know where I
>>>>> neglected or mistook:
>>>>>
>>>>> 1) I made a dm-multipath target 'dm-0' whose grouping policy was
>>>>>      failover;
>>>>> 2) Disable RSCN/port via brocade fc switch:
>>>>>      SW300:root>   portcfg rscnsupr 15 --enable; portDisable 15
>>>>> 3) Start the 'dd' command:
>>>>>      # time dd if=/dev/zero of=/dev/dm-0 bs=4k count=4k oflag=direct
>>>>>      dd: writing `/dev/sde': Input/output error
>>>>>      1+0 records in
>>>>>      0+0 records out
>>>>>      0 bytes (0 B) copied, 27.8588 s, 0.0 kB/s
>>>>>
>>>>>      real    0m27.860s
>>>>>      user    0m0.001s
>>>>>      sys     0m0.000s
>>>>
>>>> You are aware that you have to disable RSCNs on the _target_ port,
>>>> right?
>>>> Disabling RSCNs on the _initiator_ ports is a well-tested case, and
>>>> the one which actually makes sense (and is even implemented in
>>>> QLogic switches).
>>>> Disabling RSCNs for the _target_ port, OTOH, has a very questionable
>>>> nature (hence QLogic switches don't even allow you to do this).
>>>
>>> You're right. By disabling RSCNs on target port, I've reproduced this
>>> problem. Thank you so much. But I've encountered the bug I said
>>> before. I'll test again with your new patchset once you send.
>>>
>>
>> Could you check with the attached patch? That should convert it to
>> delayed_work and avoid this issue.
>
> Unfortunately, the login prompt couldn't be entered in and BUGs were
> printed ceaselessly while os booting with this patch. The BUGs are
> like below:
>
> BUG: scheduling while atomic: swapper/0/0/0x10000100
> Modules linked in: mptsas(F+) mptscsih(F) mptbase(F) 
> scsi_transport_sas(F)
> CPU: 0 PID: 0 Comm: swapper/0 Tainted: GF            3.10.0hannes+ #10
> Hardware name: FUJITSU-SV PRIMEQUEST 1800E/SB-8GDIMM-CN, BIOS 
> PRIMEQUEST 1000 Series BIOS Version 1.39 11/16/2012
>  0000000000000000 ffff88047ee03b68 ffffffff8153ada4 ffff88047ee03b78
>  ffffffff8107389d ffff88047ee03c08 ffffffff8153ca26 ffffffff81a01fd8
>  0000000000012d00 ffffffff81a00010 0000000000012d00 0000000000012d00
> Call Trace:
> <IRQ>  [<ffffffff8153ada4>] dump_stack+0x19/0x1d
>  [<ffffffff8107389d>] __schedule_bug+0x4d/0x60
>  [<ffffffff8153ca26>] __schedule+0x646/0x6f0
>  [<ffffffff8107749a>] __cond_resched+0x2a/0x40
>  [<ffffffff8153cb60>] _cond_resched+0x30/0x40
>  [<ffffffff8105fecc>] start_flush_work+0x2c/0x140
>  [<ffffffff8105fffa>] flush_work+0x1a/0x40
>  [<ffffffff8105fb39>] ? try_to_grab_pending+0x109/0x190
>  [<ffffffff8106027e>] __cancel_work_timer+0x7e/0x110
>  [<ffffffff81060323>] cancel_delayed_work_sync+0x13/0x20
>  [<ffffffff81374ec5>] scsi_put_command+0x65/0xa0

This bug is caused by the sync function 'cancel_delayed_work_sync'
which is invoked in the interrupt context. By replacing it by non-
sync function 'cancel_delayed_work' in 'scsi_put_command' can avoid.

Do you think there is such need to sync in the function 'scsi_put_
command'? Since SCSI command block will be freed here, it is NOT
necessary to wait for the abort work to finish on it, yes?

Thanks,
Ren

>  [<ffffffff8137d5aa>] scsi_next_command+0x3a/0x60
>  [<ffffffff8137dedb>] scsi_end_request+0xab/0xb0
>  [<ffffffff8137e1ef>] scsi_io_completion+0x9f/0x670
>  [<ffffffff813744e4>] scsi_finish_command+0xd4/0x140
>  [<ffffffff8137e927>] scsi_softirq_done+0x147/0x170
>  [<ffffffff81239534>] blk_done_softirq+0x74/0x90
>  [<ffffffff81049a4f>] __do_softirq+0xef/0x260
>  [<ffffffff81049cb5>] irq_exit+0xb5/0xc0
>  [<ffffffff81548406>] do_IRQ+0x66/0xe0
>  [<ffffffff8153e5ea>] common_interrupt+0x6a/0x6a
> <EOI>  [<ffffffff8109b5f2>] ? clockevents_notify+0x52/0x150
>  [<ffffffff8142dce3>] ? cpuidle_enter_state+0x53/0xd0
>  [<ffffffff8142dcdf>] ? cpuidle_enter_state+0x4f/0xd0
>  [<ffffffff8142e10f>] cpuidle_idle_call+0xcf/0x160
>  [<ffffffff8100ab1e>] arch_cpu_idle+0xe/0x30
>  [<ffffffff81093275>] cpu_idle_loop+0x65/0x1f0
>  [<ffffffff81093470>] cpu_startup_entry+0x70/0x80
>  [<ffffffff81529427>] rest_init+0x77/0x80
>  [<ffffffff81b0e1bb>] start_kernel+0x41a/0x427
>  [<ffffffff81b0dbbf>] ? repair_env_string+0x5b/0x5b
>  [<ffffffff81b0d5a1>] x86_64_start_reservations+0x2a/0x2c
>  [<ffffffff81b0d6d2>] x86_64_start_kernel+0x12f/0x136


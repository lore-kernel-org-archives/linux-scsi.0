From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: Re: [GIT PULL] Queue free fix (was Re: [PATCH] block: Free queue
 resources at blk_release_queue())
Date: Tue, 18 Oct 2011 22:31:20 +0900
Message-ID: <4E9D7FA8.9000000@ce.jp.nec.com>
References: <201109221318.p8MDIXPP020015@pentland.suse.de>	 <20110928004722.GA27421@kernel.dk>	 <CA+55aFznvejXWe68BpjsJqCWnDizbHWBOzKLY_H+YqhRiK42sQ@mail.gmail.com>	 <4E82751C.9050908@kernel.dk>	 <CA+55aFyL76hD7o_839G7tKa0y6dFRcK-kC+g_h_coEp=Qk23pw@mail.gmail.com>	 <1317183038.17578.9.camel@dabdike.hansenpartnership.com>	 <4E832A55.30709@kernel.dk>	 <1317219074.19034.4.camel@dabdike.hansenpartnership.com>	 <4E832BD2.50409@kernel.dk>  <4E96E2FF.6070601@linux.vnet.ibm.com>	 <1318608184.3018.42.camel@dabdike.int.hansenpartnership.com>	 <4E9BEB68.1050707@ce.jp.nec.com> <1318860403.4794.12.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from TYO200.gate.nec.co.jp ([202.32.8.215]:54690 "EHLO
	tyo200.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757939Ab1JRNmD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Oct 2011 09:42:03 -0400
In-Reply-To: <1318860403.4794.12.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Steffen Maier <maier@linux.vnet.ibm.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Hannes Reinecke <hare@suse.de>, Linux Kernel <linux-kernel@vger.kernel.org>, Alan Stern <stern@rowland.harvard.edu>, Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>, "Taraka R. Bodireddy" <tarak.reddy@in.ibm.com>, "Seshagiri N. Ippili" <seshagiri.ippili@in.ibm.com>, "Manvanthara B. Puttashankar" <mputtash@in.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>

On 10/17/11 23:06, James Bottomley wrote:
> On Mon, 2011-10-17 at 17:46 +0900, Jun'ichi Nomura wrote:
>> On 10/15/11 01:03, James Bottomley wrote:
>>> On Thu, 2011-10-13 at 15:09 +0200, Steffen Maier wrote:
>>>> This fix also went into 3.0.5 via
>>>> http://git.kernel.org/?p=linux/kernel/git/stable/stable-queue.git;a=blob;f=releases/3.0.5/block-free-queue-resources-at-blk_release_queue.patch
>>>> (originated at http://marc.info/?l=linux-scsi&m=131669751909474&w=2 and 
>>>> http://marc.info/?l=linux-scsi&m=131669414205696&w=2)
>>>>
>>>> However, it seems we still have a use-after-free bug, now causing the 
>>>> following oops with kernel 3.0.6 when removing paths to storage while 
>>>> generating load on device-mapper multipath disks:
>>>>
>>>>> Unable to handle kernel pointer dereference at virtual kernel address 6b6b6b6b6b6b6000
>>>>> Oops: 0038 [#1] PREEMPT SMP DEBUG_PAGEALLOC
>>>>> Modules linked in: iptable_filter ip_tables x_tables dm_round_robin sunrpc qeth_l3 binfmt_misc dm_multipath scsi_dh dm_mod ipv6 qeth ccwgroup [last unloaded: scsi_wait_scan]
>>>>> CPU: 1 Not tainted 3.0.6-50.x.20111006-s390xdefault #1
>>>>> Process blast.LzS_64_SL (pid: 26613, task: 0000000063e2a398, ksp: 0000000064de3560)
>>>>> Krnl PSW : 0704100180000000 000000000048a038 (scsi_print_command+0x44/0xf8)
>>>>>            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:0 CC:1 PM:0 EA:3
>>>>> Krnl GPRS: 000000000000006b 6b6b6b6b6b6b6b6b 000000006717f800 000000000094f2e0
>>>>>            000000000061242e 000000000062bd88 0000000066fb90d8 0000000065391ad7
>>>>>            000000006717f800 000000006717f800 000000006716a090 000000006717f800
>>>>>            0000000000000004 0000000000672f88 0000000064de3838 0000000064de3808
>>>>> Krnl Code: 000000000048a026: f0b80004ebbf        srp     4(12,%r0),3007(%r14),8
>>>>>            000000000048a02c: f0a0000407f4        srp     4(11,%r0),2036,0
>>>>>            000000000048a032: e31020800004        lg      %r1,128(%r2)
>>>>>           >000000000048a038: e31010b00004        lg      %r1,176(%r1)
>>>>>            000000000048a03e: b9020011            ltgr    %r1,%r1
>>>>>            000000000048a042: a7840032            brc     8,48a0a6
>>>>>            000000000048a046: e33020000004        lg      %r3,0(%r2)
>>>>>            000000000048a04c: c04000182f4c        larl    %r4,78fee4
>>>>> Call Trace:
>>>>> ([<000000006717f800>] 0x6717f800)
>>>>>  [<0000000000487f28>] scsi_log_send+0xf0/0x130
>>>>>  [<000000000048824c>] scsi_dispatch_cmd+0xc8/0x4bc
>>>>>  [<0000000000490694>] scsi_request_fn+0x3b8/0x480
>>>
>>> Correct me if I'm wrong, but this seems to be saying that struct
>>> scsi_cmnd was used after free.  This looks to be a different problem
>>> because the command has a separate refcounting model which wasn't
>>> impacted by the change ... it could be we've just exposed yet another
>>> refcounting problem outside of the queue one.
>>>
>>> If I had to guess, I'd say a bio got cloned with a SCSI command already
>>> attached, but the ref count on the SCSI command wasn't correctly
>>> adjusted.
>>
>> As far as dm is concerned, it shouldn't happen.
>> Clone is made from a dm request, not from SCSI one.
>> Also clone is not reused when retrying.
> 
> It was just a guess.  Assuming the command got freed prematurely, there
> has to be something in the dm path to explain why the SCSI refcounting
> model got screwed up.  Cloning a bio with an attached command was what
> first occurred to me, but perhaps there are other ways I'm not seeing.
> 
>>>> Initially, we encountered use-after-free bugs in
>>>> scsi_print_command / scsi_dispatch_cmd
>>>> http://marc.info/?l=linux-scsi&m=130824013229933&w=2
>>
>> It is interesting that both this and the older report
>> got oopsed in scsi_log_send(), while there are other
>> dereferences of 'cmd' around scsi_dispatch_cmd().
>> Are there any reason they are special? Just by accident?
> 
> Right, that's why it looks like the command area got freed rather than
> the command pointer was bogus (6b is a poison free pattern).  Perhaps if
> the reporter could pin down the failing source line, we'd know better
> what was going on?

Yeah, that might be useful.

One remote possibility I imagined is if the submitting process
took very long after blk_start_request until scsi_dispatch_cmd
and timeout handler kicks in, can cmd be freed?

Also Tejun's report here could be related to possible data corruption:
  [PATCH] block: make gendisk hold a reference to its queue
  https://lkml.org/lkml/2011/10/16/148

Though I haven't hit the reported oops myself,
a process closing a removed device may modify freed memory.
And his patch will fix it.

So if the problem is easily reproducible, I think it's worth
trying his patch to see if the problem disappear.

Thanks,
-- 
Jun'ichi Nomura, NEC Corporation

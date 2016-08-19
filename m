From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: Observing Softlockup's while running heavy IOs
Date: Fri, 19 Aug 2016 08:56:34 -0700
Message-ID: <6b7930ca-092c-a03c-d745-b49153aa174c@sandisk.com>
References: <CAK=zhgqkByFSYRYcY75+55kP0ysHbgpk1L9=qxAfLdoFfsa6sQ@mail.gmail.com>
 <DF4PR84MB01696549697831B4CEC4A3FDAB150@DF4PR84MB0169.NAMPRD84.PROD.OUTLOOK.COM>
 <CAK=zhgrOQ_LAbM3RKfq_MtveygqU3vPtChCB9Jdf6AUfFnr0HQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAK=zhgrOQ_LAbM3RKfq_MtveygqU3vPtChCB9Jdf6AUfFnr0HQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sreekanth Reddy <sreekanth.reddy@broadcom.com>, "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "irqbalance@lists.infradead.org" <irqbalance@lists.infradead.org>, Kashyap Desai <kashyap.desai@broadcom.com>, Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>, Chaitra Basappa <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
List-Id: linux-scsi@vger.kernel.org

On 08/19/2016 04:44 AM, Sreekanth Reddy wrote:
> [  +0.000439] __blk_mq_run_hw_queue() finished after 10058 ms
> [ ... ]
> [  +0.000005]  [<ffffffff810c392b>] ? finish_task_switch+0x6b/0x200
> [  +0.000006]  [<ffffffff8176dabc>] __schedule+0x36c/0x950
> [  +0.000002]  [<ffffffff8176e0d7>] schedule+0x37/0x80
> [  +0.000006]  [<ffffffff81116a1c>] futex_wait_queue_me+0xbc/0x120
> [  +0.000004]  [<ffffffff81116da9>] futex_wait+0x119/0x270
> [  +0.000004]  [<ffffffff81116800>] ? futex_wake+0x90/0x180
> [  +0.000003]  [<ffffffff81118d6b>] do_futex+0x12b/0xb00
> [  +0.000005]  [<ffffffff810d348e>] ? set_next_entity+0x23e/0x440
> [  +0.000007]  [<ffffffff810136f1>] ? __switch_to+0x261/0x4b0
> [  +0.000004]  [<ffffffff811197c1>] SyS_futex+0x81/0x180
> [  +0.000002]  [<ffffffff8176e0d7>] ? schedule+0x37/0x80
> [  +0.000004]  [<ffffffff817721ae>] entry_SYSCALL_64_fastpath+0x12/0x71

Hello Sreekanth,

If a "soft lockup" is reported that often means that kernel code is 
iterating too long in a loop without giving up the CPU. Inserting a 
cond_resched() call in such loops usually resolves these soft lockup 
complaints. However, your latest e-mail shows that the soft lockup 
complaint was reported on other code than __blk_mq_run_hw_queue(). I'm 
afraid this means that the CPU on which the soft lockup was reported is 
hammered so hard with interrupts that hardly any time remains for the 
scheduler to run code on that CPU. You will have to follow Robert 
Elliott's advice and reduce the time that is spent per CPU in interrupt 
context.

Bart.

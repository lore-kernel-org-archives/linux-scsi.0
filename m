From: Oleksandr Natalenko <oleksandr@natalenko.name>
Subject: Re: usercopy whitelist woe in scsi_sense_cache
Date: Tue, 17 Apr 2018 11:19:57 +0200
Message-ID: <8faec18239a6104b250d9668bb1d3abc@natalenko.name>
References: <10360653.ov98egbaqx@natalenko.name>
 <CAGXu5j+-PNYxSc3v+QtQLK0S3wdtFthFSxNM_69kFDnPQX0Gaw@mail.gmail.com>
 <CAGXu5j+_UH0h9qeYCKKjhC7jw-mi_=fg4ASHi2=pCF9xGTpA4Q@mail.gmail.com>
 <2864697.7uzmEJovl2@natalenko.name>
 <CAGXu5jLSmJv9AstzsgSscrv-wA7FwfrxAKRxj-FVBmihQvnj1g@mail.gmail.com>
 <CAGXu5j+dh1zm32iBjRVh0s+3gLJYgjwt+z1aBJmrK2Cr8XPWnA@mail.gmail.com>
 <CAGXu5jLhnWnUiscP9B=kTEFNyRw9jgFn7Zr5FxhZrO20553+1Q@mail.gmail.com>
 <CAGXu5jKuZwicyyXH2gB3vp-OjtS+MkG+hqxV1cq1jaG9vAAO=g@mail.gmail.com>
 <CAGXu5jLQuzpjFcfjpT=MvgOxBizFNMjnfmY+E7eCHkDAV5swHg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAGXu5jLQuzpjFcfjpT=MvgOxBizFNMjnfmY+E7eCHkDAV5swHg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: Jens Axboe <axboe@kernel.dk>, Bart Van Assche <bart.vanassche@wdc.com>, Paolo Valente <paolo.valente@linaro.org>, David Windsor <dave@nullcore.net>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>, linux-block@vger.kernel.org, keescook@google.com
List-Id: linux-scsi@vger.kernel.org

Hi.

17.04.2018 05:12, Kees Cook wrote:
>> Turning off HARDENED_USERCOPY and turning on KASAN, I see the same 
>> report:
>> 
>> [   38.274106] BUG: KASAN: slab-out-of-bounds in 
>> _copy_to_user+0x42/0x60
>> [   38.274841] Read of size 22 at addr ffff8800122b8c4b by task 
>> smartctl/1064
>> [   38.275630]
>> [   38.275818] CPU: 2 PID: 1064 Comm: smartctl Not tainted 
>> 4.17.0-rc1-ARCH+ #266
>> [   38.276631] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009),
>> BIOS Ubuntu-1.8.2-1ubuntu1 04/01/2014
>> [   38.277690] Call Trace:
>> [   38.277988]  dump_stack+0x71/0xab
>> [   38.278397]  ? _copy_to_user+0x42/0x60
>> [   38.278833]  print_address_description+0x6a/0x270
>> [   38.279368]  ? _copy_to_user+0x42/0x60
>> [   38.279800]  kasan_report+0x243/0x360
>> [   38.280221]  _copy_to_user+0x42/0x60
>> [   38.280635]  sg_io+0x459/0x660
>> ...
>> 
>> Though we get slightly more details (some we already knew):
>> 
>> [   38.301330] Allocated by task 329:
>> [   38.301734]  kmem_cache_alloc_node+0xca/0x220
>> [   38.302239]  scsi_mq_init_request+0x64/0x130 [scsi_mod]
>> [   38.302821]  blk_mq_alloc_rqs+0x2cf/0x370
>> [   38.303265]  blk_mq_sched_alloc_tags.isra.4+0x7d/0xb0
>> [   38.303820]  blk_mq_init_sched+0xf0/0x220
>> [   38.304268]  elevator_switch+0x17a/0x2c0
>> [   38.304705]  elv_iosched_store+0x173/0x220
>> [   38.305171]  queue_attr_store+0x72/0xb0
>> [   38.305602]  kernfs_fop_write+0x188/0x220
>> [   38.306049]  __vfs_write+0xb6/0x330
>> [   38.306436]  vfs_write+0xe9/0x240
>> [   38.306804]  ksys_write+0x98/0x110
>> [   38.307181]  do_syscall_64+0x6d/0x1d0
>> [   38.307590]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
>> [   38.308142]
>> [   38.308316] Freed by task 0:
>> [   38.308652] (stack is not available)
>> [   38.309060]
>> [   38.309243] The buggy address belongs to the object at 
>> ffff8800122b8c00
>> [   38.309243]  which belongs to the cache scsi_sense_cache of size 96
>> [   38.310625] The buggy address is located 75 bytes inside of
>> [   38.310625]  96-byte region [ffff8800122b8c00, ffff8800122b8c60)
> 
> With a hardware watchpoint, I've isolated the corruption to here:
> 
> bfq_dispatch_request+0x2be/0x1610:
> __bfq_dispatch_request at block/bfq-iosched.c:3902
> 3900            if (rq) {
> 3901    inc_in_driver_start_rq:
> 3902                    bfqd->rq_in_driver++;
> 3903    start_rq:
> 3904                    rq->rq_flags |= RQF_STARTED;
> 3905            }
> 
> Through some race condition(?), rq_in_driver is also sense_buffer, and
> it can get incremented.
> …
> I still haven't figured this out, though... any have a moment to look 
> at this?

By any chance, have you tried to simplify the reproducer environment, or 
it still needs my complex layout to trigger things even with KASAN?

Regards,
   Oleksandr

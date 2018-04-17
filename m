From: Kees Cook <keescook@chromium.org>
Subject: Re: usercopy whitelist woe in scsi_sense_cache
Date: Mon, 16 Apr 2018 20:12:42 -0700
Message-ID: <CAGXu5jLQuzpjFcfjpT=MvgOxBizFNMjnfmY+E7eCHkDAV5swHg@mail.gmail.com>
References: <10360653.ov98egbaqx@natalenko.name> <CAGXu5j+-PNYxSc3v+QtQLK0S3wdtFthFSxNM_69kFDnPQX0Gaw@mail.gmail.com>
 <CAGXu5j+_UH0h9qeYCKKjhC7jw-mi_=fg4ASHi2=pCF9xGTpA4Q@mail.gmail.com>
 <2864697.7uzmEJovl2@natalenko.name> <CAGXu5jLSmJv9AstzsgSscrv-wA7FwfrxAKRxj-FVBmihQvnj1g@mail.gmail.com>
 <CAGXu5j+dh1zm32iBjRVh0s+3gLJYgjwt+z1aBJmrK2Cr8XPWnA@mail.gmail.com>
 <CAGXu5jLhnWnUiscP9B=kTEFNyRw9jgFn7Zr5FxhZrO20553+1Q@mail.gmail.com> <CAGXu5jKuZwicyyXH2gB3vp-OjtS+MkG+hqxV1cq1jaG9vAAO=g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAGXu5jKuZwicyyXH2gB3vp-OjtS+MkG+hqxV1cq1jaG9vAAO=g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Oleksandr Natalenko <oleksandr@natalenko.name>, Jens Axboe <axboe@kernel.dk>, Bart Van Assche <bart.vanassche@wdc.com>, Paolo Valente <paolo.valente@linaro.org>
Cc: David Windsor <dave@nullcore.net>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>, linux-block@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Apr 16, 2018 at 1:44 PM, Kees Cook <keescook@chromium.org> wrote:
> On Thu, Apr 12, 2018 at 8:02 PM, Kees Cook <keescook@chromium.org> wrote:
>> On Thu, Apr 12, 2018 at 3:47 PM, Kees Cook <keescook@chromium.org> wrote:
>>> After fixing up some build issues in the middle of the 4.16 cycle, I
>>> get an unhelpful bisect result of commit 0a4b6e2f80aa ("Merge branch
>>> 'for-4.16/block'"). Instead of letting the test run longer, I'm going
>>> to switch to doing several shorter test boots per kernel and see if
>>> that helps. One more bisect coming...
>>
>> Okay, so I can confirm the bisect points at the _merge_ itself, not a
>> specific patch. I'm not sure how to proceed here. It looks like some
>> kind of interaction between separate trees? Jens, do you have
>> suggestions on how to track this down?
>
> Turning off HARDENED_USERCOPY and turning on KASAN, I see the same report:
>
> [   38.274106] BUG: KASAN: slab-out-of-bounds in _copy_to_user+0x42/0x60
> [   38.274841] Read of size 22 at addr ffff8800122b8c4b by task smartctl/1064
> [   38.275630]
> [   38.275818] CPU: 2 PID: 1064 Comm: smartctl Not tainted 4.17.0-rc1-ARCH+ #266
> [   38.276631] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009),
> BIOS Ubuntu-1.8.2-1ubuntu1 04/01/2014
> [   38.277690] Call Trace:
> [   38.277988]  dump_stack+0x71/0xab
> [   38.278397]  ? _copy_to_user+0x42/0x60
> [   38.278833]  print_address_description+0x6a/0x270
> [   38.279368]  ? _copy_to_user+0x42/0x60
> [   38.279800]  kasan_report+0x243/0x360
> [   38.280221]  _copy_to_user+0x42/0x60
> [   38.280635]  sg_io+0x459/0x660
> ...
>
> Though we get slightly more details (some we already knew):
>
> [   38.301330] Allocated by task 329:
> [   38.301734]  kmem_cache_alloc_node+0xca/0x220
> [   38.302239]  scsi_mq_init_request+0x64/0x130 [scsi_mod]
> [   38.302821]  blk_mq_alloc_rqs+0x2cf/0x370
> [   38.303265]  blk_mq_sched_alloc_tags.isra.4+0x7d/0xb0
> [   38.303820]  blk_mq_init_sched+0xf0/0x220
> [   38.304268]  elevator_switch+0x17a/0x2c0
> [   38.304705]  elv_iosched_store+0x173/0x220
> [   38.305171]  queue_attr_store+0x72/0xb0
> [   38.305602]  kernfs_fop_write+0x188/0x220
> [   38.306049]  __vfs_write+0xb6/0x330
> [   38.306436]  vfs_write+0xe9/0x240
> [   38.306804]  ksys_write+0x98/0x110
> [   38.307181]  do_syscall_64+0x6d/0x1d0
> [   38.307590]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> [   38.308142]
> [   38.308316] Freed by task 0:
> [   38.308652] (stack is not available)
> [   38.309060]
> [   38.309243] The buggy address belongs to the object at ffff8800122b8c00
> [   38.309243]  which belongs to the cache scsi_sense_cache of size 96
> [   38.310625] The buggy address is located 75 bytes inside of
> [   38.310625]  96-byte region [ffff8800122b8c00, ffff8800122b8c60)

With a hardware watchpoint, I've isolated the corruption to here:

bfq_dispatch_request+0x2be/0x1610:
__bfq_dispatch_request at block/bfq-iosched.c:3902
3900            if (rq) {
3901    inc_in_driver_start_rq:
3902                    bfqd->rq_in_driver++;
3903    start_rq:
3904                    rq->rq_flags |= RQF_STARTED;
3905            }

Through some race condition(?), rq_in_driver is also sense_buffer, and
it can get incremented. Specifically, I am doing:

diff --git a/block/blk-mq-sched.c b/block/blk-mq-sched.c
index 25c14c58385c..f50d5053d732 100644
--- a/block/blk-mq-sched.c
+++ b/block/blk-mq-sched.c
@@ -6,6 +6,8 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/blk-mq.h>
+#include <scsi/scsi_request.h>
+#include <linux/hw_breakpoint.h>

 #include <trace/events/block.h>

@@ -428,6 +430,18 @@ void blk_mq_sched_restart(struct blk_mq_hw_ctx *const hctx)
        }
 }

+static void sample_hbp_handler(struct perf_event *bp,
+                               struct perf_sample_data *data,
+                               struct pt_regs *regs)
+{
+        printk(KERN_INFO "sense_buffer value is changed\n");
+        dump_stack();
+        printk(KERN_INFO "Dump stack from sample_hbp_handler\n");
+}
+
+struct perf_event * __percpu *sample_hbp;
+int ok_to_go;
+
 void blk_mq_sched_insert_request(struct request *rq, bool at_head,
                                 bool run_queue, bool async)
 {
@@ -435,6 +449,16 @@ void blk_mq_sched_insert_request(struct request
*rq, bool at_head,
        struct elevator_queue *e = q->elevator;
        struct blk_mq_ctx *ctx = rq->mq_ctx;
        struct blk_mq_hw_ctx *hctx = blk_mq_map_queue(q, ctx->cpu);
+       struct perf_event_attr attr;
+       struct scsi_request *req = scsi_req(rq);
+
+       if (ok_to_go) {
+               hw_breakpoint_init(&attr);
+               attr.bp_addr = (uintptr_t)&(req->sense);
+               attr.bp_len = HW_BREAKPOINT_LEN_8;
+               attr.bp_type = HW_BREAKPOINT_W;
+               sample_hbp = register_wide_hw_breakpoint(&attr,
sample_hbp_handler, NULL);
+       }

        /* flush rq in flush machinery need to be dispatched directly */
        if (!(rq->rq_flags & RQF_FLUSH_SEQ) && op_is_flush(rq->cmd_flags)) {
@@ -461,6 +485,9 @@ void blk_mq_sched_insert_request(struct request
*rq, bool at_head,
 run:
        if (run_queue)
                blk_mq_run_hw_queue(hctx, async);
+
+       if (ok_to_go)
+               unregister_wide_hw_breakpoint(sample_hbp);
 }

 void blk_mq_sched_insert_requests(struct request_queue *q,

Where "ok_to_go" is wired up to a sysctl so I don't trip other things
(?) at boot-time.

I still haven't figured this out, though... any have a moment to look at this?

-Kees

-- 
Kees Cook
Pixel Security

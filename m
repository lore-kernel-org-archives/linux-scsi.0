From: Kees Cook <keescook@chromium.org>
Subject: Re: usercopy whitelist woe in scsi_sense_cache
Date: Tue, 17 Apr 2018 13:03:22 -0700
Message-ID: <CAGXu5jJTMqbXia7TmN2yEW11SM+XC3pkMt=bb+xBrY7-OOf=tw@mail.gmail.com>
References: <10360653.ov98egbaqx@natalenko.name> <CAGXu5j+-PNYxSc3v+QtQLK0S3wdtFthFSxNM_69kFDnPQX0Gaw@mail.gmail.com>
 <CAGXu5j+_UH0h9qeYCKKjhC7jw-mi_=fg4ASHi2=pCF9xGTpA4Q@mail.gmail.com>
 <2864697.7uzmEJovl2@natalenko.name> <CAGXu5jLSmJv9AstzsgSscrv-wA7FwfrxAKRxj-FVBmihQvnj1g@mail.gmail.com>
 <CAGXu5j+dh1zm32iBjRVh0s+3gLJYgjwt+z1aBJmrK2Cr8XPWnA@mail.gmail.com>
 <CAGXu5jLhnWnUiscP9B=kTEFNyRw9jgFn7Zr5FxhZrO20553+1Q@mail.gmail.com>
 <CAGXu5jKuZwicyyXH2gB3vp-OjtS+MkG+hqxV1cq1jaG9vAAO=g@mail.gmail.com> <CAGXu5jLQuzpjFcfjpT=MvgOxBizFNMjnfmY+E7eCHkDAV5swHg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAGXu5jLQuzpjFcfjpT=MvgOxBizFNMjnfmY+E7eCHkDAV5swHg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Oleksandr Natalenko <oleksandr@natalenko.name>, Jens Axboe <axboe@kernel.dk>, Bart Van Assche <bart.vanassche@wdc.com>, Paolo Valente <paolo.valente@linaro.org>
Cc: David Windsor <dave@nullcore.net>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>, linux-block@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Apr 16, 2018 at 8:12 PM, Kees Cook <keescook@chromium.org> wrote:
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

This state continues to appear to be "impossible".

[   68.845979] watchpoint triggered
[   68.846462] sense before:ffff8b8f9f6aae00 after:ffff8b8f9f6aae01
[   68.847196] elevator before:ffff8b8f9a2c2000 after:ffff8b8f9a2c2000
[   68.847905] elevator_data before:ffff8b8f9a2c0400 after:ffff8b8f9a2c0400
...
[   68.856925] RIP: 0010:bfq_dispatch_request+0x99/0xad0
[   68.857553] RSP: 0018:ffff900280c63a58 EFLAGS: 00000082
[   68.858253] RAX: ffff8b8f9aefbe80 RBX: ffff8b8f9a2c0400 RCX: ffff8b8f9a2c0408
[   68.859201] RDX: ffff8b8f9a2c0408 RSI: ffff900280c63b34 RDI: 0000000000000001
[   68.860147] RBP: 0000000000000000 R08: 0000000f00000204 R09: 0000000000000000
[   68.861122] R10: ffff900280c63af0 R11: 0000000000000040 R12: ffff8b8f9aefbe00
[   68.862089] R13: ffff8b8f9a221950 R14: 0000000000000000 R15: ffff8b8f9a2c0770

Here we can see that sense buffer has, as we've seen, been
incremented. However, the "before" values for elevator and
elevator_data still match their expected values. As such, this should
be "impossible", since:

static struct request *__bfq_dispatch_request(struct blk_mq_hw_ctx *hctx)
{
        struct bfq_data *bfqd = hctx->queue->elevator->elevator_data;
...
        if (rq) {
inc_in_driver_start_rq:
                bfqd->rq_in_driver++;
start_rq:
                rq->rq_flags |= RQF_STARTED;
        }
exit:
        return rq;
}

For rq_in_driver++ to touch sense, bfqd must be equal to scsi_request
- 12 bytes (rq_in_driver is 60 byte offset from struct bfq_data, and
sense is 48 bytes offset from struct scsi_request).

The above bfq_dispatch_request+0x99/0xad0 is still
__bfq_dispatch_request at block/bfq-iosched.c:3902, just with KASAN
removed. 0x99 is 153 decimal:

(gdb) disass bfq_dispatch_request
Dump of assembler code for function bfq_dispatch_request:
...
   0xffffffff8134b2ad <+141>:   test   %rax,%rax
   0xffffffff8134b2b0 <+144>:   je     0xffffffff8134b2bd
<bfq_dispatch_request+157>
   0xffffffff8134b2b2 <+146>:   addl   $0x1,0x100(%rax)
   0xffffffff8134b2b9 <+153>:   addl   $0x1,0x3c(%rbx)
   0xffffffff8134b2bd <+157>:   orl    $0x2,0x18(%r12)
   0xffffffff8134b2c3 <+163>:   test   %ebp,%ebp
   0xffffffff8134b2c5 <+165>:   je     0xffffffff8134b2ce
<bfq_dispatch_request+174>
   0xffffffff8134b2c7 <+167>:   mov    0x108(%r14),%rax
   0xffffffff8134b2ce <+174>:   mov    %r15,%rdi
   0xffffffff8134b2d1 <+177>:   callq  0xffffffff81706f90 <_raw_spin_unlock_irq>

Just as a sanity-check, at +157 %r12 should be rq, rq_flags is 0x18
offset from, $0x2 is RQF_STARTED, so that maps to "rq->rq_flags |=
RQF_STARTED", the next C statement. I don't know what +146 is, though?
An increment of something 256 bytes offset? There's a lot of inline
fun and reordering happening here, so I'm ignoring that for the
moment.

So at +153 %rbx should be bfqd (i.e. elevator_data), but this is the
tripped instruction. The watchpoint dump shows RBX as ffff8b8f9a2c0400
... which matches elevator_data.

So, what can this be? Some sort of cache issue? By the time the
watchpoint handler captures the register information, it's already
masked the problem? I'm stumped again. :(

-Kees

-- 
Kees Cook
Pixel Security

From: Kees Cook <keescook@chromium.org>
Subject: Re: usercopy whitelist woe in scsi_sense_cache
Date: Tue, 17 Apr 2018 13:25:49 -0700
Message-ID: <CAGXu5jJmvKcANUSsCz3fjGSv-tv1hceNd3rOpT4WTfYRb65RRA@mail.gmail.com>
References: <10360653.ov98egbaqx@natalenko.name> <CAGXu5j+-PNYxSc3v+QtQLK0S3wdtFthFSxNM_69kFDnPQX0Gaw@mail.gmail.com>
 <CAGXu5j+_UH0h9qeYCKKjhC7jw-mi_=fg4ASHi2=pCF9xGTpA4Q@mail.gmail.com>
 <2864697.7uzmEJovl2@natalenko.name> <CAGXu5jLSmJv9AstzsgSscrv-wA7FwfrxAKRxj-FVBmihQvnj1g@mail.gmail.com>
 <CAGXu5j+dh1zm32iBjRVh0s+3gLJYgjwt+z1aBJmrK2Cr8XPWnA@mail.gmail.com>
 <CAGXu5jLhnWnUiscP9B=kTEFNyRw9jgFn7Zr5FxhZrO20553+1Q@mail.gmail.com>
 <CAGXu5jKuZwicyyXH2gB3vp-OjtS+MkG+hqxV1cq1jaG9vAAO=g@mail.gmail.com>
 <CAGXu5jLQuzpjFcfjpT=MvgOxBizFNMjnfmY+E7eCHkDAV5swHg@mail.gmail.com>
 <CAGXu5jJTMqbXia7TmN2yEW11SM+XC3pkMt=bb+xBrY7-OOf=tw@mail.gmail.com> <CAGXu5j+xX3kDDS_sPY44hPVb=8isMX-evYzPx3ur=rge1rL5JQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAGXu5j+xX3kDDS_sPY44hPVb=8isMX-evYzPx3ur=rge1rL5JQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Oleksandr Natalenko <oleksandr@natalenko.name>, Jens Axboe <axboe@kernel.dk>, Bart Van Assche <bart.vanassche@wdc.com>, Paolo Valente <paolo.valente@linaro.org>
Cc: David Windsor <dave@nullcore.net>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>, linux-block@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Apr 17, 2018 at 1:20 PM, Kees Cook <keescook@chromium.org> wrote:
> On Tue, Apr 17, 2018 at 1:03 PM, Kees Cook <keescook@chromium.org> wrote:
>> The above bfq_dispatch_request+0x99/0xad0 is still
>> __bfq_dispatch_request at block/bfq-iosched.c:3902, just with KASAN
>> removed. 0x99 is 153 decimal:
>>
>> (gdb) disass bfq_dispatch_request
>> Dump of assembler code for function bfq_dispatch_request:
>> ...
>>    0xffffffff8134b2ad <+141>:   test   %rax,%rax
>>    0xffffffff8134b2b0 <+144>:   je     0xffffffff8134b2bd
>> <bfq_dispatch_request+157>
>>    0xffffffff8134b2b2 <+146>:   addl   $0x1,0x100(%rax)
>>    0xffffffff8134b2b9 <+153>:   addl   $0x1,0x3c(%rbx)
>>    0xffffffff8134b2bd <+157>:   orl    $0x2,0x18(%r12)
>>    0xffffffff8134b2c3 <+163>:   test   %ebp,%ebp
>>    0xffffffff8134b2c5 <+165>:   je     0xffffffff8134b2ce
>> <bfq_dispatch_request+174>
>>    0xffffffff8134b2c7 <+167>:   mov    0x108(%r14),%rax
>>    0xffffffff8134b2ce <+174>:   mov    %r15,%rdi
>>    0xffffffff8134b2d1 <+177>:   callq  0xffffffff81706f90 <_raw_spin_unlock_irq>
>>
>> Just as a sanity-check, at +157 %r12 should be rq, rq_flags is 0x18
>> offset from, $0x2 is RQF_STARTED, so that maps to "rq->rq_flags |=
>> RQF_STARTED", the next C statement. I don't know what +146 is, though?
>> An increment of something 256 bytes offset? There's a lot of inline
>> fun and reordering happening here, so I'm ignoring that for the
>> moment.
>
> No -- I'm reading this wrong. The RIP is the IP _after_ the trap, so
> +146 is the offender.
>
> [   29.284746] watchpoint @ ffff95d41a0fe580 triggered
> [   29.285349] sense before:ffff95d41f45f700 after:ffff95d41f45f701 (@ffff95d41a
> 0fe580)
> [   29.286176] elevator before:ffff95d419419c00 after:ffff95d419419c00
> [   29.286847] elevator_data before:ffff95d419418c00 after:ffff95d419418c00
> ...
> [   29.295069] RIP: 0010:bfq_dispatch_request+0x99/0xbb0
> [   29.295622] RSP: 0018:ffffb26e01707a40 EFLAGS: 00000002
> [   29.296181] RAX: ffff95d41a0fe480 RBX: ffff95d419418c00 RCX: ffff95d419418c08
>
> RAX is ffff95d41a0fe480 and sense is stored at ffff95d41a0fe580,
> exactly 0x100 away.
>
> WTF is this addl?

What are the chances? :P Two ++ statements in a row separate by a
collapsed goto. FML. :)

...
                        bfqq->dispatched++;
                        goto inc_in_driver_start_rq;
...
inc_in_driver_start_rq:
                bfqd->rq_in_driver++;
...

And there's the 0x100 (256):

struct bfq_queue {
...
        int                        dispatched;           /*   256     4 */

So bfqq is corrupted somewhere... I'll keep digging. I hope you're all
enjoying my live debugging transcript. ;)

-Kees

-- 
Kees Cook
Pixel Security

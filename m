From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH block/for-3.3/core] block: an exiting task should be allowed
 to create io_context
Date: Tue, 03 Jan 2012 21:20:44 +0100
Message-ID: <4F03631C.8080501@kernel.dk>
References: <20111223004244.GU17084@google.com> <alpine.LSU.2.00.1112232058550.3225@eggly.anvils> <20111225010238.GA6013@htj.dyndns.org> <alpine.LSU.2.00.1112280010550.1398@eggly.anvils> <20111228164836.GP17712@google.com> <alpine.LSU.2.00.1112280939390.3320@eggly.anvils> <CAOS58YOzUcZz41+H+7dk5FteHy+Ufrtpk9dvdPqX6eie-GHi0Q@mail.gmail.com> <20111228211918.GA3516@google.com> <20120103173500.GB31746@google.com> <20120103175922.GC31746@google.com> <20120103200906.GG31746@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20120103200906.GG31746@google.com>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Hugh Dickins <hughd@google.com>, Shaohua Li <shaohua.li@intel.com>, Andrew Morton <akpm@linux-foundation.org>, Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, x86@kernel.org
List-Id: linux-scsi@vger.kernel.org

On 2012-01-03 21:09, Tejun Heo wrote:
> On Tue, Jan 03, 2012 at 09:59:22AM -0800, Tejun Heo wrote:
>> That should have been service tree.  I couldn't find more missing
>> removals other than the one Shaohua's patch already fixed.  Close
>> cooperator selection in cfq_select_queue() seems suspicious tho.  I
>> can't see what prevents it from returning an empty coopeator cfqq.
>> I'm trying to verify whether that's the case.  Will update when I know
>> more.
> 
> While testing, found another bug.
> 
>  Redzone: 0x9f911029d74e35b/0x9f911029d74e35b.
>  Last user: [<ffffffff813a82ee>](cfq_put_queue+0x7e/0xd0)
>  070: e8 32 ab 1d 00 88 ff ff e8 32 ab 1d 00 88 ff ff  .2.......2......
>  Prev obj: start=ffff88001dab3178, len=232
>  Redzone: 0x9f911029d74e35b/0x9f911029d74e35b.
>  Last user: [<ffffffff813a82ee>](cfq_put_queue+0x7e/0xd0)
>  000: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
>  010: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
>  Next obj: start=ffff88001dab3378, len=232
>  Redzone: 0xd84156c5635688c0/0xd84156c5635688c0.
>  Last user: [<ffffffff813a8e53>](cfq_get_queue+0x153/0x670)
>  000: 02 00 00 00 21 01 00 00 e0 c9 b1 1d 00 88 ff ff  ....!...........
>  010: 89 96 ae 18 00 88 ff ff 00 00 00 00 00 00 00 00  ................
> 
> The field at 0x70 which is being updated after being freed is
> cfqq->fifo.  Interestingly, it didn't lead to any visible failure.

That's pretty odd. Given Hughs report as well, it sure does sound like
we now have some life time issues with cfqq's.

-- 
Jens Axboe


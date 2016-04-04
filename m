From: Shaun Tancheff <shaun.tancheff@seagate.com>
Subject: Re: [PATCH 03/12] BUG: Losing bits on request.cmd_flags
Date: Mon, 4 Apr 2016 23:06:03 +0700
Message-ID: <CAJVOszAK5w4qsrKcUot8rm9nZ65hXeUm5YomQU3fT-fARCGXjA@mail.gmail.com>
References: <1459746376-27983-1-git-send-email-shaun@tancheff.com>
 <1459746376-27983-4-git-send-email-shaun@tancheff.com> <x49pou5s6yg.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <x49pou5s6yg.fsf@segfault.boston.devel.redhat.com>
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Shaun Tancheff <shaun@tancheff.com>, linux-ide@vger.kernel.org, dm-devel@redhat.com, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, Jens Axboe <axboe@fb.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, Apr 4, 2016 at 10:56 PM, Jeff Moyer <jmoyer@redhat.com> wrote:
> Shaun Tancheff <shaun@tancheff.com> writes:
>
>> In a few places a temporary value smaller than a cmd_flags
>> is used to test for bits and or build up a new cmd_flags.
>>
>> Change to use explicit u64 values where appropriate.
>
> This is not a bug fix, so please fix your subject.

Oh, okay. It became an issue in the next patch where some internal cmd_flags
temporaries where stored in 32 bit values.

I will fix patch/subject.

Thanks!

> I'm not against cleaning up the mixing of 32 vs 64 bit variables, but if
> you're going to go down that path, then you might as well fix the mixing
> of signed vs unsigned use as well.  And now that I look at it,
> bio->bi_rw is unsigned long whereas req->cmd_flags is u64.  That could
> make for fun bugs in the future.  We should at least add a comment in
> the rq_flag_bits enum to the effect of bio flags need to stay in the
> bottom 32 bits.
>
> Cheers,
> Jeff



-- 
Shaun Tancheff

From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH 03/12] BUG: Losing bits on request.cmd_flags
Date: Mon, 04 Apr 2016 11:56:55 -0400
Message-ID: <x49pou5s6yg.fsf@segfault.boston.devel.redhat.com>
References: <1459746376-27983-1-git-send-email-shaun@tancheff.com>
	<1459746376-27983-4-git-send-email-shaun@tancheff.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1459746376-27983-4-git-send-email-shaun@tancheff.com> (Shaun
	Tancheff's message of "Mon, 4 Apr 2016 12:06:07 +0700")
Sender: linux-ide-owner@vger.kernel.org
To: Shaun Tancheff <shaun@tancheff.com>
Cc: linux-ide@vger.kernel.org, dm-devel@redhat.com, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, Jens Axboe <axboe@fb.com>, Shaun Tancheff <shaun.tancheff@seagate.com>
List-Id: linux-scsi@vger.kernel.org

Shaun Tancheff <shaun@tancheff.com> writes:

> In a few places a temporary value smaller than a cmd_flags
> is used to test for bits and or build up a new cmd_flags.
>
> Change to use explicit u64 values where appropriate.

This is not a bug fix, so please fix your subject.

I'm not against cleaning up the mixing of 32 vs 64 bit variables, but if
you're going to go down that path, then you might as well fix the mixing
of signed vs unsigned use as well.  And now that I look at it,
bio->bi_rw is unsigned long whereas req->cmd_flags is u64.  That could
make for fun bugs in the future.  We should at least add a comment in
the rq_flag_bits enum to the effect of bio flags need to stay in the
bottom 32 bits.

Cheers,
Jeff

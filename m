From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Subject: Re: scsi: non atomic allocation in mempool_alloc in atomic context
Date: Wed, 7 Jan 2015 19:55:42 -0800
Message-ID: <CAADnVQ+wys8mD+QoMVsWAWWryfZBgxct_XFZM44Xoz_1dPUAuA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Sasha Levin <sasha.levin@oracle.com>, bvanassche@acm.org, hare@suse.de, JBottomley@parallels.com, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, Jan 5, 2015 at 11:42 AM, Christoph Hellwig <hch@lst.de> wrote:
> On Mon, Jan 05, 2015 at 12:38:04PM -0700, Jens Axboe wrote:
>> That was true in earlier kernels as well, going back a few versions at
>> least, preempt was disabled on calling __blk_mq_run_hw_queue(). Just
>> checked, and 3.16 and later have that as the behaviour. The only change
>> in 3.19 some shuffling around to avoid double preempt_disable in some
>> cases, it's now using get_cpu() and friends.
>>
>> So we probably want do mark that as stable so we reach back to when
>> scsi-mq was added, unless the originally referenced patch getting rid of
>> the gfp_t mask didn't have the issue.
>
> Before that commit we always passed down GFP_ATOMIC, so we'll only
> need the patch for 3.19.

I'm seeing the same splats... what tree I can pull the fix from ?

Thanks!

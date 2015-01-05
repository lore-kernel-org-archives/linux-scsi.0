From: Christoph Hellwig <hch@lst.de>
Subject: Re: scsi: non atomic allocation in mempool_alloc in atomic context
Date: Mon, 5 Jan 2015 20:42:03 +0100
Message-ID: <20150105194203.GA32107@lst.de>
References: <54A43CFB.2080705@oracle.com> <20150105091516.GA22226@lst.de> <54AADF6A.6090100@kernel.dk> <20150105193213.GA31955@lst.de> <54AAE81C.2080402@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <54AAE81C.2080402@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Sasha Levin <sasha.levin@oracle.com>, bvanassche@acm.org, hare@suse.de, JBottomley@parallels.com, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, Jan 05, 2015 at 12:38:04PM -0700, Jens Axboe wrote:
> That was true in earlier kernels as well, going back a few versions at
> least, preempt was disabled on calling __blk_mq_run_hw_queue(). Just
> checked, and 3.16 and later have that as the behaviour. The only change
> in 3.19 some shuffling around to avoid double preempt_disable in some
> cases, it's now using get_cpu() and friends.
> 
> So we probably want do mark that as stable so we reach back to when
> scsi-mq was added, unless the originally referenced patch getting rid of
> the gfp_t mask didn't have the issue.

Before that commit we always passed down GFP_ATOMIC, so we'll only
need the patch for 3.19.

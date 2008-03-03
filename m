From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [RFC PATCH 1/3] block: add rq->complete_io hook for request stacking
Date: Mon, 3 Mar 2008 18:49:54 +0100
Message-ID: <20080303174953.GE6704@kernel.dk>
References: <20080215.172727.39155014.k-ueda@ct.jp.nec.com> <47CC2652.1080601@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1760212AbYCCRuX@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <47CC2652.1080601@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, dm-devel@redhat.com, j-nomura@ce.jp.nec.com
List-Id: linux-scsi@vger.kernel.org

On Mon, Mar 03 2008, Hannes Reinecke wrote:
> Hi Kiyoshi,
> 
> Kiyoshi Ueda wrote:
> > This patch adds ->complete_io() hook for request stacking.
> > Request stacking drivers (such as request-based dm) can set
> > a callback for completion.
> > (The hook is not called in blk_end_io(), since request-based dm uses
> >  it for clone completion in the following appendix patches.)
> > 
> [ .. ]
> I would rather have rq->complete_io() to be pointing to blk_end_io in the
> default case, this way rq->complete_io() would always be valid and we
> would be saving us the if() clause.

The whole point of this ->complete_io() thread is that we cannot use the
above approach, before all drivers are converted from using
__blk_end_request() to blk_end_request(). And that requires some work.

-- 
Jens Axboe

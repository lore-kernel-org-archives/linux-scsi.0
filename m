From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] block: fix residual byte count handling
Date: Thu, 28 Feb 2008 16:35:43 +0100
Message-ID: <20080228153542.GZ6704@kernel.dk>
References: <1203839683.17463.9.camel@homer.simson.net> <1204019283.8731.11.camel@homer.simson.net> <1204033003.11828.22.camel@homer.simson.net> <20080226150845.2196bc1a.akpm@linux-foundation.org> <1204079075.26640.8.camel@homer.simson.net> <1204092010.9934.31.camel@homer.simson.net> <1204096025.1623.9.camel@homer.simson.net> <47C6661E.9010504@gmail.com> <1204186800.7362.7.camel@homer.simson.net> <47C675C6.8000904@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <47C675C6.8000904@gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>, Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, Feb 28 2008, Tejun Heo wrote:
> rq->raw_data_len introduced for block layer padding and draining
> (commit 6b00769fe1502b4ad97bb327ef7ac971b208bfb5) broke residual byte
> count handling.  Block drivers modify rq->data_len to notify residual
> byte count to the block layer which blindly reported unmodified
> rq->raw_data_len to userland.
> 
> To keep block drivers dealing only with rq->data_len, this should be
> handled inside block layer.  However, how much extra buffer was
> appened is lost after rq->data_len is modified.
> 
> This patch replaces rq->raw_data_len with rq->extra_len and add
> blk_rq_raw_data_len() helper to calculate raw data size from
> rq->data_len and rq->extra_len.  The helper returns correct raw
> residual byte count when called on a rq whose data_len is modified to
> carry residual byte count.
> 
> This problem was reported and diagnosed by Mike Galbraith.

Tejun, this patch isn't much cleaner at all. It really shows the pain of
these two seperate, yet related, variables.

-- 
Jens Axboe


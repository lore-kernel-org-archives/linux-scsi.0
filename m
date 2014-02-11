From: Jens Axboe <axboe@kernel.dk>
Subject: Re: error returns from ->queue_rq
Date: Tue, 11 Feb 2014 08:44:03 -0700
Message-ID: <20140211154403.GE19057@kernel.dk>
References: <20140211092904.GA6229@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140211092904.GA6229@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Feb 11 2014, Christoph Hellwig wrote:
> Hi Jens,
> 
> seems like with the SCSI work I introduced the first
> BLK_MQ_RQ_QUEUE_ERROR error return in the tree, and immediately ran into
> the first pitfall.  The code as-is expects rq->errors set to an error
> value, which otherwise is an  internal field used by the block layer and
> some drivers, but not part of the communication protocol between the
> two.
> 
> We can either make it part of the protocol for blk-mq, which would
> require documenting and praying driver writers get it right, or
> alternatively we could map BLK_MQ_RQ_QUEUE_ERROR to -EIO and if
> nessecary introduce other return values if we need to return other
> errors.  The third option would be to remove BLK_MQ_RQ_QUEUE_ERROR
> entirely and require drivers to call blk_mq_end_io themselves from
> ->queue_rq, mirroring the ->queuecommand error handling.  I'm undecided
> between options 2 and 3, but I'd rather avoid the current pitfall.

Lets go for option #2. I agree that we should not make this a new
depedency, it's a lot more robust to just have it be -EIO and add other
error returns as needed.

-- 
Jens Axboe

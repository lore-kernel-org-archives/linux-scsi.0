From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 5/7] blk-mq: initialize request on allocation
Date: Thu, 17 Apr 2014 16:57:05 +0200
Message-ID: <20140417145705.GA14787@lst.de>
References: <1397464212-4454-1-git-send-email-hch@lst.de> <1397464212-4454-6-git-send-email-hch@lst.de> <CACVXFVMAq0qw5vXqShmhcTTA5nww_OYaVz-yiEaf3_Q3-nrJfQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CACVXFVMAq0qw5vXqShmhcTTA5nww_OYaVz-yiEaf3_Q3-nrJfQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ming Lei <tom.leiming@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Matias Bjorling <m@bjorling.me>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux SCSI List <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, Apr 17, 2014 at 10:54:23PM +0800, Ming Lei wrote:
> On Mon, Apr 14, 2014 at 4:30 PM, Christoph Hellwig <hch@lst.de> wrote:
> > If we want to share tag and request allocation between queues we cannot
> > initialize the request at init/free time, but need to initialize it
> > at allocation time as it might get used for different queues over its
> > lifetime.
> 
> Could you explain the use pattern? Looks you mean there are
> still users of the tag/req even after it is freed, that looks a bit
> weird since the tag/req can still be reallocated in another path
> after it is freed.

No difference in use pattern.  But blk_rq_init initializes the rq->q field,
and a request might get reused for a different queue.

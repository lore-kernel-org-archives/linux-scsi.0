From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 8/8] blk-mq: support per-distpatch_queue flush machinery
Date: Wed, 10 Sep 2014 12:02:47 -0700
Message-ID: <20140910190247.GA28821@infradead.org>
References: <1410267949-21904-1-git-send-email-ming.lei@canonical.com>
 <1410267949-21904-9-git-send-email-ming.lei@canonical.com>
 <20140909184856.GG16750@infradead.org>
 <CACVXFVNhmvy+aSgbJX8zgRVJQS0q6PWJLhmy_XVN_9YvSFdwag@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CACVXFVNhmvy+aSgbJX8zgRVJQS0q6PWJLhmy_XVN_9YvSFdwag@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ming Lei <ming.lei@canonical.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux SCSI List <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

On Wed, Sep 10, 2014 at 09:40:11AM +0800, Ming Lei wrote:
> I am wondering we can do that because lifetime is totally different
> between flush requests and tag_set requests which are initialized
> before request queue is created.

We shouldn't do it in the tag sets, but where we allocate and free
each hctx: blk_mq_init_queue and blk_mq_free_hw_queues.

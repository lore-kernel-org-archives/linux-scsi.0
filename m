From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] scsi-mq: fix hw queue hang caused by timeout
Date: Thu, 18 Sep 2014 18:35:49 +0200
Message-ID: <20140918163549.GB3950@lst.de>
References: <1411055950-28657-1-git-send-email-ming.lei@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1411055950-28657-1-git-send-email-ming.lei@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ming Lei <ming.lei@canonical.com>
Cc: James Bottomley <JBottomley@parallels.com>, Jens Axboe <axboe@fb.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Douglas Gilbert <dgilbert@interlog.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, Sep 18, 2014 at 11:59:10PM +0800, Ming Lei wrote:
> If there are two requests or more timed out, the dispatch queue
> is put into stopped state and never be recoverd, and there
> is no such problem in non-mq mode.
> 
> This patch trys to recover the stopped queue when the queue
> becomes unbusy, then the following retries can move on.
> 
> Basically this patch maintains same behavior for this situation
> with non-mq mode.

This looks somewhat similar to the issues that Doug reported, and I remember
when he was last running into boot problems it was timeout related, too.

As far as the implementation is concerned I think the correct fix is
to clear the BLK_MQ_S_STOPPED queue flags in blk_mq_kick_requeue_list.

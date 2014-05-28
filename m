From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] notify block layer when using temporary change to
 cache_type
Date: Wed, 28 May 2014 04:23:29 -0700
Message-ID: <20140528112329.GA11953@infradead.org>
References: <1401190754-6822-1-git-send-email-vaughan.cao@oracle.com>
 <1401207496.14454.90.camel@dabdike>
 <1401253107-16138-1-git-send-email-vaughan.cao@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1401253107-16138-1-git-send-email-vaughan.cao@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Vaughan Cao <vaughan.cao@oracle.com>
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, May 28, 2014 at 12:58:27PM +0800, Vaughan Cao wrote:
> No, I just want to keep the modification as small as possible. Checked
> the actions of sd_revalidate_disk() again, it seems no harm to call it
> from here. Also actual actions are skipped in sd_read_cache_type() if
> cache_override!=0, so I suppose your original plan is to jump to
> sd_revalidate_disk() from here.

I think the right fix is to factor out a helper like:

static void sd_set_flush_flag(struct scsi_disk *sdkp)
{
	unsigned flush = 0;

	if (sdkp->WCE) {
		flush |= REQ_FLUSH;
		if (sdkp->DPOFUA)
			flush |= REQ_FUA;
	}

	blk_queue_flush(sdkp->disk->queue, flush);
}

which can be called from sd_revalidate_disk and cache_type_store.

> 
> However, that way may not be acceptable after further code review.
> Changing the sdkp->WCE,RCD will cause these real parameters of the
> underlying device *lost*. In sd_shutdown() and sd_suspend_common(), we
> need them to call sd_sync_cache() if necessary. I don't think this
> action is avoidable, just for the performance issue to solve. And we
> can't change the mode just by setting q->flush_flags while leave
> sdkp->WCE,RCD untouched either, because cache_type_show() needs
> sdkp->WCE,RCD to present the temporary config to userspace.

If the user overrides the cache type he should expect data not to be
flushed, so I don't really think this is na issue.  Even if it is it
should be a separate issue as it already exists before your patch.

From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH, RFC] blk-mq: use a delayed work item for timeouts
Date: Mon, 12 Oct 2015 22:22:17 +0200
Message-ID: <20151012202217.GA880@lst.de>
References: <1444678154-24766-1-git-send-email-hch@lst.de> <561C0B3C.70004@fb.com> <561C1324.3030800@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:54686 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751820AbbJLUWT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Oct 2015 16:22:19 -0400
Content-Disposition: inline
In-Reply-To: <561C1324.3030800@fb.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@fb.com>
Cc: Christoph Hellwig <hch@lst.de>, hare@suse.de, linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org

On Mon, Oct 12, 2015 at 02:08:04PM -0600, Jens Axboe wrote:
>> No that's definitely fine with me, imho most error handling callbacks
>> should be in process context for ease of use in the driver.
>
> Took a closer look. The patch looks incomplete. The hot path for blk-mq is 
> blk_add_timer(), looks like you left that one alone in the conversion?

Oh, damn.  I had that part in my initial version that also crudely
converted the old request code and dropped a bit too much.  That should
defintively do the queue_deayed_work.

> Might be easier to just leave the timer alone, and if it actually fires 
> _and_ we have to do something, punt to a workqueue instead of invoking the 
> timeout handler directly.

queue_delayed_work just assigns two additional fields, then sets
timer->experies and does an add_timer.  So it's the generic implementation
of your above scheme.  I'd much rather use the generic version if
possible instead of trying to recreate it.

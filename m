From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/3] block: Introduce blkdev_issue_zeroout_discard()
 function
Date: Fri, 7 Nov 2014 00:26:10 -0800
Message-ID: <20141107082610.GC8394@infradead.org>
References: <1415336894-15327-1-git-send-email-martin.petersen@oracle.com>
 <1415336894-15327-4-git-send-email-martin.petersen@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1415336894-15327-4-git-send-email-martin.petersen@oracle.com>
Sender: linux-ide-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-fsdevel@vger.kernel.org, neilb@suse.de
List-Id: linux-scsi@vger.kernel.org

On Fri, Nov 07, 2014 at 12:08:14AM -0500, Martin K. Petersen wrote:
> blkdev_issue_discard() will zero a given block range on disk. This is
> done by way of either WRITE SAME or regular WRITE. I.e. the blocks on
> disk will be written and thus provisioned.
> 
> There are use cases where the desired behavior is to zero the blocks but
> unprovision them if possible. The blocks must deterministically contain
> zeroes when they are subsequently read back.
> 
> This patch introduces a blkdev_issue_zeroout_discard() call that
> provides this functionality. If a block device guarantees
> discard_zeroes_data the new function will use discard to clear the block
> range. If the device does not support discard_zeroes_data or if the
> discard request fails we will fall back to blkdev_issue_zeroout() to
> ensure predictable results.

I'm not a fan of adding another function here and would prefer a flag,
but it looks correct, so:

Reviewed-by: Christoph Hellwig <hch@lst.de>

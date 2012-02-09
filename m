From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 1/5] block: Implement support for WRITE SAME
Date: Wed, 8 Feb 2012 22:33:52 -0500
Message-ID: <20120209033352.GA17456@redhat.com>
References: <1327969892-5090-1-git-send-email-martin.petersen@oracle.com>
 <1327969892-5090-2-git-send-email-martin.petersen@oracle.com>
 <20120208225023.GA16401@redhat.com>
 <yq139akor65.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58915 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757610Ab2BIDeD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 8 Feb 2012 22:34:03 -0500
Content-Disposition: inline
In-Reply-To: <yq139akor65.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com, jaxboe@fusionio.com, dm-devel@redhat.com

On Wed, Feb 08 2012 at  6:12pm -0500,
Martin K. Petersen <martin.petersen@oracle.com> wrote:

> >>>>> "Mike" == Mike Snitzer <snitzer@redhat.com> writes:
> 
> >> + BUG_ON(length != bdev_logical_block_size(bdev));
> 
> Mike> Why require @length to be passed in if we can easily determine the
> Mike> only correct length, via bdev_logical_block_size, locally?
> 
> Just sanity checking since the caller is passing in a buffer pointer.
> See my comment in the patch series introduction about a page vs a
> buffer. I don't really care whether we pick one or the other. Whatever
> makes the most sense to dm, md and the filesystems...

OK, I see -- might make sense to use a page.  But I don't have a
strong opinion (and not sure I will have one in the near-term).

I wrote a patch for dm-kcopyd (and dm-io) to add support for WRITE_SAME,
but it doesn't use the new blkdev_* interfaces you've provided -- only
because I needed to wire it up to dm-thinp which uses dm_kcopyd_zero()
to provide async zeroing.

So the patch open codes a small portion of bio prep code from
blkdev_issue_write_same() in dm-io's do_region().  I'll post it once I
verify it works.

Mike

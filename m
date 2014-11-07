From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 3/3] block: Introduce blkdev_issue_zeroout_discard()
 function
Date: Fri, 7 Nov 2014 11:20:25 -0500
Message-ID: <20141107162025.GA607@thunk.org>
References: <1415336894-15327-1-git-send-email-martin.petersen@oracle.com>
 <1415336894-15327-4-git-send-email-martin.petersen@oracle.com>
 <20141107082610.GC8394@infradead.org>
 <yq1k3379fvj.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:45146 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752244AbaKGQUg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 Nov 2014 11:20:36 -0500
Content-Disposition: inline
In-Reply-To: <yq1k3379fvj.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-fsdevel@vger.kernel.org, neilb@suse.de

On Fri, Nov 07, 2014 at 10:42:24AM -0500, Martin K. Petersen wrote:
> >>>>> "Christoph" == Christoph Hellwig <hch@infradead.org> writes:
> 
> Christoph> I'm not a fan of adding another function here and would
> Christoph> prefer a flag, but it looks correct, 
> 
> That was my original approach too but I didn't want to stomp over all
> the existing callers. Although there only are few.
> 
> Ted: Which would you prefer?

There are *very* few users of blkdev_issue_zeroout(), and aside for a
single drbd, they are all in the block layer.  It would only start
affecting ext4 when we plumb that flag through to sb_issue_zeroout
(which your patch doesn't currently do), at which point it will affect
4 call sites in ext4, and a call site in gfs2 and hpfs2.

So I'd be in favor of adding a flag to to blkdev_issue_zeroout(), and
I would have a slight preference for also modifying sb_issue_zeroout
so the flag gets plumbed all the way through to the fs-level callers.

Cheers,

							- Ted

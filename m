From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 27/32] scsi_data_buffer
Date: Thu, 18 Oct 2007 09:44:15 -0600
Message-ID: <20071018154415.GD9883@parisc-linux.org>
References: <20071018085400.GB9883@parisc-linux.org> <Pine.LNX.4.44L0.0710181024560.4335-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:48088 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757484AbXJRPoT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Oct 2007 11:44:19 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0710181024560.4335-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Boaz Harrosh <bharrosh@panasas.com>, Benny Halevy <bhalevy@panasas.com>, James Bottomley <James.Bottomley@SteelEye.com>, Jens Axboe <jens.axboe@oracle.com>, FUJITA Tomonori <tomof@acm.org>, Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, Russell King <rmk@arm.linux.org.uk>, "David S. Miller" <davem@davemloft.net>, Christoph Hellwig <hch@infradead.org>, linux-scsi <linux-scsi@vger.kernel.org>, Pete Wyckoff <pw@osc.edu>

On Thu, Oct 18, 2007 at 10:26:58AM -0400, Alan Stern wrote:
> > Even that's still pretty foul (and i have my grave doubts about using
> > stringify in that manner).  It's definitely past my bedtime now ... but
> > a hack like that could save us another 8 bytes on x86-64.
> 
> This may seem heretical, but I doubt there's much point to saving a few 
> bytes if it's going to incur this much work and confusion.  Rearranging 
> the order of structure members is fine, it's easy, it won't bother 
> anybody.  But this sort of thing is just beyond the bounds of reason.

That's a valid point of view.  But we're just 24 bytes shy of going down
from 6 cachelines to 5.  I don't have performance numbers yet, but the
memory savings are significant; we switch from 10 cmds per 4k slab page to
12 cmds per 4k slab page.  By the way, after my patch 4/4 getting rid of
transfersize, we're down to 256 bytes on i386.  That's 16 cmds per 4k slab
page, so we alloc 25% fewer pages to scsi_cmnds.  That's a *huge* win.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."

From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: Some plans for scsi_cmnd
Date: Tue, 25 Sep 2007 08:09:18 -0600
Message-ID: <20070925140918.GU10625@parisc-linux.org>
References: <20070925133733.GT10625@parisc-linux.org> <20070925134750.GA21930@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:57973 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751976AbXIYOJT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Sep 2007 10:09:19 -0400
Content-Disposition: inline
In-Reply-To: <20070925134750.GA21930@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org

On Tue, Sep 25, 2007 at 02:47:50PM +0100, Christoph Hellwig wrote:
> On Tue, Sep 25, 2007 at 07:37:33AM -0600, Matthew Wilcox wrote:
> > 2. Thanks to a thinko, we also discussed the upper-layer ->done.  We think
> > it should be feasible to move this from the scsi_cmnd to the scsi_device
> > since sg doesn't use it.
> 
> I suspect putting it into the scsi_driver would be even better.

That could work, but I don't think we have a pointer from the
scsi_device (or scsi_cmnd) to the scsi_driver.

> I'd prefer to add alloc_mnd and destroy_cmnd methods as per struct
> inode.  That also allows drivers to do things like dma_pool allocations
> ahead of time and not worry about needing to do this kind of allocations
> from softirq context which is at least theoretically deadlockable
> without emergency pool schemes.

OK, we clearly weren't quite envisaging the same thing for this part.
Good job I put some pseudo-code down.  I don't have any objection to
this scheme.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."

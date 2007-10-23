From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC 1/2] scsi core: alloc_cmnd
Date: Tue, 23 Oct 2007 20:27:57 +0100
Message-ID: <20071023192757.GA20713@infradead.org>
References: <20071019183331.GC30807@parisc-linux.org> <471E260D.6030605@panasas.com> <20071023174804.GR27248@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:37798 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752624AbXJWT2B (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Oct 2007 15:28:01 -0400
Content-Disposition: inline
In-Reply-To: <20071023174804.GR27248@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Boaz Harrosh <bharrosh@panasas.com>, linux-scsi@vger.kernel.org

On Tue, Oct 23, 2007 at 11:48:04AM -0600, Matthew Wilcox wrote:
> On Tue, Oct 23, 2007 at 06:49:17PM +0200, Boaz Harrosh wrote:
> > You know Matthew when you first talked about this, I envisioned
> > something else.
> 
> Right, so did I.  Christoph felt that alloc_cmnd/destroy_cmnd a la the
> VFS layer's alloc_inode/destroy_inode was a better route.  I didn't have
> a strong feeling, so I implemented that.

Yeah.  Let me repeat my rationale for the method here:  If we only
have a size member that means we can only allocate things using the
slab allocator.  But there's a variety of drivers requiring other
allocations (e.g. pci_pool or the sym2 allocator) aswell, and having
the methods means we can always have a pre-constructed command for those
aswell, which makes these drivers deadlock-safe without much effort.

From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 03/13] scsi: unify allocation of scsi command and sense
	buffer
Date: Tue, 26 May 2009 09:13:46 -0600
Message-ID: <20090526151346.GB5816@parisc-linux.org>
References: <20090526062952.GB11363@kernel.dk> <20090526162545U.fujita.tomonori@lab.ntt.co.jp> <20090526073229.GC11363@kernel.dk> <20090526163823U.fujita.tomonori@lab.ntt.co.jp> <1243349222.2815.22.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:59151 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249AbZEZPNq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 26 May 2009 11:13:46 -0400
Content-Disposition: inline
In-Reply-To: <1243349222.2815.22.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, jens.axboe@oracle.com, rdreier@cisco.com, bharrosh@panasas.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org, akpm@linux-foundation.org, jack@suse.cz, yanmin_zhang@linux.intel.com, linux-scsi@vger.kernel.org

On Tue, May 26, 2009 at 09:47:02AM -0500, James Bottomley wrote:
> > Yeah, we can inline the sense buffer but as we discussed in the past
> > several times, there are some good reasons that we should not do so, I
> > think.
> 
> There are several other approaches:
> 
>      1. Keep the sense buffer packed in the command but disallow DMA to
>         it, which fixes all the alignment problems.  Then we supply a
>         set of rotating DMA buffers to drivers which need to do the DMA
>         (which isn't the majority).
>      2. Sense is a comparative rarity, so us a more compact pooling
>         scheme and discard sense for reuse as soon as we know it's not
>         used (as in at softirq time when there's no sense collected).
> 
> I'd need a little more clarity on the actual size of the problem before
> making any choices.

I'm not sure if this is what you meant by option 2 or not, but one
proposal was to keep a number of sense buffers around per-host, and only
allocate extras when we run close to empty.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."

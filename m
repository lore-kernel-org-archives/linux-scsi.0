From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: DMA API Re: Remove dma_coherent_mem interface
Date: Wed, 31 Oct 2007 15:34:47 -0600
Message-ID: <20071031213447.GF15111@parisc-linux.org>
References: <1193864605.25899.253.camel@wirenth>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:58314 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754085AbXJaVet (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 31 Oct 2007 17:34:49 -0400
Content-Disposition: inline
In-Reply-To: <1193864605.25899.253.camel@wirenth>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: ian <spyro@f2s.com>
Cc: linux-arch@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, linux-scsi@vger.kernel.org, jejb@steeleye.com, kernel-discuss@handhelds.org

On Wed, Oct 31, 2007 at 09:03:24PM +0000, ian wrote:
> There was a recent patch to remove the coherent memory interface from
> the DMA API.
> 
> I'd like to ask that this not happen - there are several users of this
> code in the handhelds.org tree, which we hope will merge into mainline.
> this code is _essential_ to allow support of these devices.
> 
> Removing this from mainline will only increase the hh.org delta which we
> are working hard to reduce, and there is no other realistic way to
> support these devices.

It's been three years since this API was introduced, and the only
*merged* user is the one that James wrote.  Now it's in the way of some
performance improvements I want to make.  I can't possibly go round every
little platform tree looking for users -- you need to get your drivers
into mainline.  Yes, it's not necessarily a quick process, but equally,
you've had three years.

Now, what driver is it that's going to consume this coherent memory?
Does it use the dma_pool interface, or does it use dma_alloc_coherent
directly?  If the latter, I can retain the dma_declare_coherent_memory
interface.  If the former, then we have to come to a decision between
supporting some drivers that are so unimportant that they haven't been
merged in three years and making a performance win for drivers that are
used every day.

Admittedly, I haven't finished the work to make dma_pool use slub, thus
I don't know what the performance win will turn out to be.  It may not
be significant, so it would be an easy decision to keep the interface.
But if the decision is going to be to keep the interface despite the
lack of users and no matter what the performance win, then I don't need
to finish this work.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."

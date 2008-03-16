From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] [14/20] Don't disable direct_io for unchecked_isa_dma in st.c
Date: Sun, 16 Mar 2008 13:44:09 +0100
Message-ID: <20080316124409.GB613@one.firstfloor.org>
References: <20080307653.720459648@firstfloor.org> <20080307175414.08C981B41AE@basil.firstfloor.org> <20080314135135.GT17940@kernel.dk> <20080314142412.GA30325@infradead.org> <47DD14F7.4070607@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:40806 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752837AbYCPMlu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 16 Mar 2008 08:41:50 -0400
Content-Disposition: inline
In-Reply-To: <47DD14F7.4070607@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <jens.axboe@oracle.com>, Mike Christie <michaelc@cs.wisc.edu>, Andi Kleen <andi@firstfloor.org>, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

On Sun, Mar 16, 2008 at 02:39:19PM +0200, Boaz Harrosh wrote:
> On Fri, Mar 14 2008 at 16:24 +0200, Christoph Hellwig <hch@infradead.org> wrote:
> > On Fri, Mar 14, 2008 at 02:51:35PM +0100, Jens Axboe wrote:
> >> Are you sure? Seems to me that st builds its own list with
> >> get_user_pages() for direct io, where will that get bounced? The block
> >> layer will only bounce things that are mapped directly, so if st used
> >> blk_rq_map_kern() and inserted that request in the queue, we could
> >> proceed with killing that check in st.
> > 
> > Which shouldn't be all too difficult and would be the right thing to
> > do.  We really need someone to sit down and convert st/osst/sg to use
> > the proper block layer helpers.
> > 
> 
> First they do. They all call scsi_execute_async which at the end produces
> a BIO and then calls blk_execute_nowait(). and all is swell.

I thought i had audited them all too, but wasn't 100% sure anymore.
But thanks for double checking.

Jens, that answers your earlier question.

-Andi


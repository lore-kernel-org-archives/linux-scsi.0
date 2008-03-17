From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] [14/20] Don't disable direct_io for unchecked_isa_dma
	in st.c
Date: Mon, 17 Mar 2008 19:55:29 +0900
Message-ID: <20080317195459I.tomof@acm.org>
References: <20080307175414.08C981B41AE@basil.firstfloor.org>
	<20080314135135.GT17940@kernel.dk>
	<20080314142412.GA30325@infradead.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:40841 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752619AbYCQK4i (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Mar 2008 06:56:38 -0400
In-Reply-To: <20080314142412.GA30325@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hch@infradead.org
Cc: jens.axboe@oracle.com, andi@firstfloor.org, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu, tomof@acm.org, fujita.tomonori@lab.ntt.co.jp

On Fri, 14 Mar 2008 10:24:12 -0400
Christoph Hellwig <hch@infradead.org> wrote:

> On Fri, Mar 14, 2008 at 02:51:35PM +0100, Jens Axboe wrote:
> > Are you sure? Seems to me that st builds its own list with
> > get_user_pages() for direct io, where will that get bounced? The block
> > layer will only bounce things that are mapped directly, so if st used
> > blk_rq_map_kern() and inserted that request in the queue, we could
> > proceed with killing that check in st.
> 
> Which shouldn't be all too difficult and would be the right thing to
> do.  We really need someone to sit down and convert st/osst/sg to use
> the proper block layer helpers.

I've been working on this (hopefully, I'll submit an updated patchset
this week).

I think that the main problem was a lack of motivation for these
changes. I bet that nobody reviewed the patchset that Mike posted the
last time. Hopefully, the new patchset will be reviewed and merged.

With sg chaining, drain, padding, etc, building a scatterlist is much
complicated than in the past. I believe that we should kill home-made
scatterlist code and convert the users to use the block layer to avoid
potential scatterlist bugs.

From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH] [14/20] Don't disable direct_io for unchecked_isa_dma
 in st.c
Date: Sun, 16 Mar 2008 14:39:19 +0200
Message-ID: <47DD14F7.4070607@panasas.com>
References: <20080307653.720459648@firstfloor.org> <20080307175414.08C981B41AE@basil.firstfloor.org> <20080314135135.GT17940@kernel.dk> <20080314142412.GA30325@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bzq-219-195-70.pop.bezeqint.net ([62.219.195.70]:38634 "EHLO
	bh-buildlin2.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751712AbYCPMkc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 16 Mar 2008 08:40:32 -0400
In-Reply-To: <20080314142412.GA30325@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Jens Axboe <jens.axboe@oracle.com>, Mike Christie <michaelc@cs.wisc.edu>
Cc: Andi Kleen <andi@firstfloor.org>, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

On Fri, Mar 14 2008 at 16:24 +0200, Christoph Hellwig <hch@infradead.org> wrote:
> On Fri, Mar 14, 2008 at 02:51:35PM +0100, Jens Axboe wrote:
>> Are you sure? Seems to me that st builds its own list with
>> get_user_pages() for direct io, where will that get bounced? The block
>> layer will only bounce things that are mapped directly, so if st used
>> blk_rq_map_kern() and inserted that request in the queue, we could
>> proceed with killing that check in st.
> 
> Which shouldn't be all too difficult and would be the right thing to
> do.  We really need someone to sit down and convert st/osst/sg to use
> the proper block layer helpers.
> 

First they do. They all call scsi_execute_async which at the end produces
a BIO and then calls blk_execute_nowait(). and all is swell.

Second some one did, long a go, and have submitted them rebased more then 3
times. I'd say their time is do long a go. (I mean Mike Christie)

Mike, please, do you have these patches on a public git somewhere I want to help
push them.

Boaz

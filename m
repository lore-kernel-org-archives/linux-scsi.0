From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] [14/20] Don't disable direct_io for unchecked_isa_dma
 in st.c
Date: Thu, 27 Mar 2008 12:26:54 -0500
Message-ID: <47EBD8DE.4080502@cs.wisc.edu>
References: <20080307653.720459648@firstfloor.org> <20080307175414.08C981B41AE@basil.firstfloor.org> <20080314135135.GT17940@kernel.dk> <20080314142412.GA30325@infradead.org> <47DD14F7.4070607@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:36533 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751705AbYC0R2E (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Mar 2008 13:28:04 -0400
In-Reply-To: <47DD14F7.4070607@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <jens.axboe@oracle.com>, Andi Kleen <andi@firstfloor.org>, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

Boaz Harrosh wrote:
> On Fri, Mar 14 2008 at 16:24 +0200, Christoph Hellwig <hch@infradead.org> wrote:
>> On Fri, Mar 14, 2008 at 02:51:35PM +0100, Jens Axboe wrote:
>>> Are you sure? Seems to me that st builds its own list with
>>> get_user_pages() for direct io, where will that get bounced? The block
>>> layer will only bounce things that are mapped directly, so if st used
>>> blk_rq_map_kern() and inserted that request in the queue, we could
>>> proceed with killing that check in st.
>> Which shouldn't be all too difficult and would be the right thing to
>> do.  We really need someone to sit down and convert st/osst/sg to use
>> the proper block layer helpers.
>>
> 
> First they do. They all call scsi_execute_async which at the end produces
> a BIO and then calls blk_execute_nowait(). and all is swell.
> 
> Second some one did, long a go, and have submitted them rebased more then 3
> times. I'd say their time is do long a go. (I mean Mike Christie)
> 
> Mike, please, do you have these patches on a public git somewhere I want to help
> push them.
> 

Sorry I have been so bad with my linux-scsi email. Here is my current 
patches:
http://kernel.org/pub/linux/kernel/people/mnc/sg/sg-bioset17/
They are very broken (patch -p1 wise), because of all the block layer 
changes. I got around to converting st. It is not tested. I just need to 
convert osst and we can kill scsi_execute_async.

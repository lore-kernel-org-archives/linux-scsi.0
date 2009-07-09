From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 2/4] block: use the same failfast bits for bio and
	request
Date: Thu, 9 Jul 2009 19:39:00 +0200
Message-ID: <20090709173900.GO23611@kernel.dk>
References: <1246610898-22350-1-git-send-email-tj@kernel.org> <1246610898-22350-3-git-send-email-tj@kernel.org> <4A5071E5.8030908@panasas.com> <4A553DA4.4080408@kernel.org> <20090709133746.GA21929@infradead.org> <4A5626F2.7070404@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([93.163.65.50]:35722 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752560AbZGIRjB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 9 Jul 2009 13:39:01 -0400
Content-Disposition: inline
In-Reply-To: <4A5626F2.7070404@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Christoph Hellwig <hch@infradead.org>, Tejun Heo <tj@kernel.org>, Boaz Harrosh <bharrosh@panasas.com>, Linux Kernel <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, Niel Lambrechts <niel.lambrechts@gmail.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

On Thu, Jul 09 2009, Jeff Garzik wrote:
> Christoph Hellwig wrote:
>> On Thu, Jul 09, 2009 at 09:45:24AM +0900, Tejun Heo wrote:
>>> What's more disturbing to me is the different between RQ and BIO
>>> flags.  __REQ_* are bit positions, REQ_* are masks while BIO_* are bit
>>> positions.  Sadly it seems it's already too late to change that.  I
>>> personally an not a big fan of simple accessors or flags defined as
>>> bit positions.  They seem to obscure things without much benefit.
>>
>> flags as bit positions generally only make sense if you use
>> test/set/clear_bit, otherwise they just confuse things.  And the
>> accessors are pretty annoying, especially in the block layer.  Trying to
>> find the places where a BIO flag has an actual effect is pretty painful
>> due to the mix of the different flags and the accessors.
>
> Indeed -- the accessors mean in practice that you always have at least  
> _two_ things to grep for, just to catch all accesses.  Block layer is  
> pretty bad about that style of usage :/

Yeah, I'm not too fond of it either, it does add to the confusion. I'll
sanitize it.

-- 
Jens Axboe


From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 2/4] block: use the same failfast bits for bio and	request
Date: Fri, 10 Jul 2009 22:18:49 +0900
Message-ID: <4A573FB9.2090202@kernel.org>
References: <1246610898-22350-1-git-send-email-tj@kernel.org> <1246610898-22350-3-git-send-email-tj@kernel.org> <4A5071E5.8030908@panasas.com> <4A553DA4.4080408@kernel.org> <20090709133746.GA21929@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:56456 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754105AbZGJNTJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Jul 2009 09:19:09 -0400
In-Reply-To: <20090709133746.GA21929@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Boaz Harrosh <bharrosh@panasas.com>, Jens Axboe <jens.axboe@oracle.com>, Linux Kernel <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, Niel Lambrechts <niel.lambrechts@gmail.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Jens Axboe <axboe@kernel.dk>

Hello, Christoph.

Christoph Hellwig wrote:
> On Thu, Jul 09, 2009 at 09:45:24AM +0900, Tejun Heo wrote:
>> What's more disturbing to me is the different between RQ and BIO
>> flags.  __REQ_* are bit positions, REQ_* are masks while BIO_* are bit
>> positions.  Sadly it seems it's already too late to change that.  I
>> personally an not a big fan of simple accessors or flags defined as
>> bit positions.  They seem to obscure things without much benefit.
> 
> flags as bit positions generally only make sense if you use
> test/set/clear_bit, otherwise they just confuse things.

Another shortcoming of bit position flags is masking / multi flag
operations.  It's just awful.  I think it's always better to define
flags as masks even when it's used with test/set/clear_bit().  If such
usages are common enough, we can easily add test/set/clear_bit_mask().
The conversion from mask to bit would be constant most of the time and
it's not like fls/ffs() are expensive.

> And the accessors are pretty annoying, especially in the block
> layer.  Trying to find the places where a BIO flag has an actual
> effect is pretty painful due to the mix of the different flags and
> the accessors.

Yeap, fully agreed.

Thanks.

-- 
tejun

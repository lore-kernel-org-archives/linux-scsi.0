From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 13/17] scsi: push host_lock down into
 scsi_{host,target}_queue_ready
Date: Thu, 06 Feb 2014 10:41:16 -0800
Message-ID: <1391712076.22335.13.camel@dabdike>
References: <20140205123930.150608699@bombadil.infradead.org>
		 <20140205124021.286457268@bombadil.infradead.org>
	 <1391705819.22335.8.camel@dabdike> <52F3C21F.70409@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:49001 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753254AbaBFSlS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Feb 2014 13:41:18 -0500
In-Reply-To: <52F3C21F.70409@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org

On Thu, 2014-02-06 at 18:10 +0100, Bart Van Assche wrote:
> On 02/06/14 17:56, James Bottomley wrote:
> > Could you benchmark this lot and show what the actual improvement is
> > just for this series, if any?
> 
> I see a performance improvement of 12% with the SRP protocol for the
> SCSI core optimizations alone (I am still busy measuring the impact of
> the blk-mq conversion but I can already see that it is really
> significant). Please note that the performance impact depends a lot on
> the workload (number of LUNs per SCSI host e.g.) so maybe the workload I
> chose is not doing justice to Christoph's work. And it's also important
> to mention that with the workload I ran I was saturating the target
> system CPU (a quad core Intel i5). In other words, results might be
> better with a more powerful target system.

On what?  Just the patches I indicated or the whole series?  My specific
concern is that swapping a critical section for atomics may not buy us
anything even on x86 and may slow down non-x86.  That's the bit I'd like
benchmarks to explore.

James



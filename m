From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] Make SG_SET_FORCE_LOW_DMA behave as advertised
Date: Mon, 12 Mar 2007 11:23:22 -0500
Message-ID: <45F57E7A.1040009@cs.wisc.edu>
References: <200703121418.31088.okir@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:54211 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030584AbXCLQXg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Mar 2007 12:23:36 -0400
In-Reply-To: <200703121418.31088.okir@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Olaf Kirch <okir@lst.de>
Cc: linux-scsi@vger.kernel.org

Olaf Kirch wrote:
> Make SG_SET_FORCE_LOW_DMA behave as advertised
> 
> I came across this by accident. I have serious doubts whether ISA DMA
> is really relevant these days :-) but what the heck. Feel free to disregard
> if this code is headed for the recycler anyway.
> 
> The SCSI-HOWTO says this about SG_SET_FORCE_LOW_DMA:
> 
> 	If the "reserved" buffer allocated on open() is not in use then
> 	it will be de-allocated and re-allocated under the 16MB level
> 	(and the latter operation could fail yielding ENOMEM).
> 
> I came across this by accident - the current code will never reallocate
> the buffer during the ioctl, because it first sets sfp->low_dma to 1,
> and then checks the very same variable for equality with 0.
> 
> The patch below changes the order of commands, and also moves
> the buffer reallocation around so that it also happens when
> the device has unchecked_isa_dma set.

It might be needed. The removal was my fault. If you are just worried
about using the right memory and the host had unchecked_isa_dma set, the
buffer is now bounced for sg by the block layer helpers so sg does not
need to worry about that.

The problem with this is that the sg code would allocate large chunks of
memory so it would try to make large segments, and if you were trying to
do a really large IO then the isa_page_pool may not work like the old sg
code.

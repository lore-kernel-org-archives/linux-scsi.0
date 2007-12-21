From: Roland Dreier <rdreier@cisco.com>
Subject: Re: [PATCH 1/2] DMA buffer alignment annotations
Date: Fri, 21 Dec 2007 08:58:50 -0800
Message-ID: <adafxxwx9v9.fsf@cisco.com>
References: <20071221023010.C56B7DDDF3@ozlabs.org>
	<20071221093905.GB31115@flint.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sj-iport-6.cisco.com ([171.71.176.117]:28768 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752679AbXLUQ65 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Dec 2007 11:58:57 -0500
In-Reply-To: <20071221093905.GB31115@flint.arm.linux.org.uk> (Russell King's message of "Fri, 21 Dec 2007 09:39:05 +0000")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>, linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org, davem@davemloft.net, james.bottomley@steeleye.com, ralf@linux-mips.org

 > > +#define __dma_aligned	  	__attribute__((aligned(ARCH_MIN_DMA_ALIGNMENT)))
 > > +#define __dma_buffer		__dma_buffer_line(__LINE__)
 > > +#define __dma_buffer_line(line)	__dma_aligned;\
 > > +				char __dma_pad_##line[0] __dma_aligned

 > You introduce __dma_buffer_line() if ARCH_MIN_DMA_ALIGNMENT is set but
 > not if it isn't...

__dma_buffer_line() is just an internal implementation detail to take
care of string pasting properly.  Perhaps there should be a comment
warning people not to use it directly.

 - R.

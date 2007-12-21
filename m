From: Roland Dreier <rdreier@cisco.com>
Subject: Re: [PATCH 2/2] scsi: Use new __dma_buffer to align sense buffer in scsi_cmnd
Date: Fri, 21 Dec 2007 08:57:47 -0800
Message-ID: <adak5n8x9x0.fsf@cisco.com>
References: <20071221023011.4C4BADDDFA@ozlabs.org>
	<20071221103326.7ce1bc4f@the-village.bc.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755411AbXLUQ6F@vger.kernel.org>
In-Reply-To: <20071221103326.7ce1bc4f@the-village.bc.nu> (Alan Cox's message of "Fri, 21 Dec 2007 10:33:26 +0000")
Sender: linux-kernel-owner@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>, linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org, rmk@arm.linux.org.uk, davem@davemloft.net, james.bottomley@steeleye.com, ralf@linux-mips.org
List-Id: linux-scsi@vger.kernel.org

 > It's also incomplete as a fix because I don't see what guarantees the
 > buffer size will always exceed cache line size

There's a macro trick that adds a pad member after the buffer too, so
that it gets rounded up to the cacheline size:

 > +#define __dma_aligned	  	__attribute__((aligned(ARCH_MIN_DMA_ALIGNMENT)))
 > +#define __dma_buffer		__dma_buffer_line(__LINE__)
 > +#define __dma_buffer_line(line)	__dma_aligned;\
 > +				char __dma_pad_##line[0] __dma_aligned

So that part is OK at least.

 - R.

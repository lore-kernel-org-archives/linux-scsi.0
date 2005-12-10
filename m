From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: Ang: Re: [Stgt-devel] Re: [Iscsitarget-devel] stgt a new
	version of iscsi target?
Date: Sat, 10 Dec 2005 17:46:56 +0900
Message-ID: <20051210174656S.fujita.tomonori@lab.ntt.co.jp>
References: <20051208213514.GA23039@cs.umn.edu>
	<4398ABF9.2030404@cs.wisc.edu>
	<4399A2F5.1060403@vlnb.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:37846 "EHLO
	tama5.ecl.ntt.co.jp") by vger.kernel.org with ESMTP id S965089AbVLJItY
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 10 Dec 2005 03:49:24 -0500
In-Reply-To: <4399A2F5.1060403@vlnb.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: vst@vlnb.net
Cc: michaelc@cs.wisc.edu, boutcher@cs.umn.edu, James.Bottomley@SteelEye.com, johan@capvert.se, iscsitarget-devel@lists.sourceforge.net, mingz@ele.uri.edu, stgt-devel@lists.berlios.de, WRWHITEHEAD@novell.com, scst-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org, hch@infradead.org

From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: Ang: Re: [Stgt-devel] Re: [Iscsitarget-devel] stgt a new	version of iscsi target?
Date: Fri, 09 Dec 2005 18:29:57 +0300

> > There is still memory and scatterlist allocations. If we are not going 
> > to allocate all the memory for a command buffer and request with 
> > GFP_ATOMIC (and can then run from the the HW interrupt or soft irq) we 
> > have to pass that on to a thread. I guess there is disagreement whether 
> > that part is a feature or bad use of GFP_ATOMIC though so... But I just 
> > mean to say there could be a little more to do.
> 
> Actually, there is the way to allocate sg vectors with buffers in SIRQ 
> and not with GFP_ATOMIC. This is the second major improvement, which is 
> pending in scst. I called it sgv_pool. This is a new allocator in the 
> kernel similar to mem_pool, but it contains *complete* sg-vectors of 
> some size with data buffers (pages). Initiator sends data requests 
> usually with some fixed size, like 128K. After a data command completed, 
> its sg vector will not be immediately freed, but will be kept in 
> sgv_pool until the next request (command) or memory pressure on the 
> system. So, all subsequent commands will allocate already built vectors. 
> The first allocations will be done in some thread context. This allows 
> to allocate huge chunks of memory in SIRQ context as well as save a lot 
> of CPU power necessary to always build big sg vectors for each command 
> individually.

ibmvscsis code the same thing, though it is mainly for caching
dma-mapped pages, I guess.

From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC] uas host lock removal conversion
Date: Thu, 16 Dec 2010 05:44:58 -0500
Message-ID: <20101216104458.GA5919@infradead.org>
References: <20101216050257.GC1263@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:33670 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753961Ab0LPKo7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Dec 2010 05:44:59 -0500
Content-Disposition: inline
In-Reply-To: <20101216050257.GC1263@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org

On Wed, Dec 15, 2010 at 10:02:57PM -0700, Matthew Wilcox wrote:
> 
> I thought I'd take a crack at removing the host lock from uas.  I think
> I can now switch to using GFP_NOIO (since interrupts are enabled by
> scsi_request_fn()), and I have to use _irq spinlocks to protect the list
> that is modified from interrupt context (same reason :-).

->qeuecommand can be called from software interrupt context, so you'll
need to stick to GFP_ATOMIC.


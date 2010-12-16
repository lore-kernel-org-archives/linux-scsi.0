From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [RFC] uas host lock removal conversion
Date: Thu, 16 Dec 2010 07:00:36 -0700
Message-ID: <20101216140035.GD1263@parisc-linux.org>
References: <20101216050257.GC1263@parisc-linux.org> <20101216104458.GA5919@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:55115 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756053Ab0LPOAh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Dec 2010 09:00:37 -0500
Content-Disposition: inline
In-Reply-To: <20101216104458.GA5919@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org

On Thu, Dec 16, 2010 at 05:44:58AM -0500, Christoph Hellwig wrote:
> On Wed, Dec 15, 2010 at 10:02:57PM -0700, Matthew Wilcox wrote:
> > 
> > I thought I'd take a crack at removing the host lock from uas.  I think
> > I can now switch to using GFP_NOIO (since interrupts are enabled by
> > scsi_request_fn()), and I have to use _irq spinlocks to protect the list
> > that is modified from interrupt context (same reason :-).
> 
> ->qeuecommand can be called from software interrupt context, so you'll
> need to stick to GFP_ATOMIC.

Ah, I couldn't find a path that did that.  Could you point it out to me?
I'll send a patch to update that documentation.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."

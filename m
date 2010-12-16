From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [RFC] uas host lock removal conversion
Date: Thu, 16 Dec 2010 09:04:52 -0500
Message-ID: <1292508292.3024.5.camel@mulgrave.site>
References: <20101216050257.GC1263@parisc-linux.org>
	 <20101216104458.GA5919@infradead.org>
	 <20101216140035.GD1263@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:48374 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755820Ab0LPOE4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Dec 2010 09:04:56 -0500
In-Reply-To: <20101216140035.GD1263@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org

On Thu, 2010-12-16 at 07:00 -0700, Matthew Wilcox wrote:
> On Thu, Dec 16, 2010 at 05:44:58AM -0500, Christoph Hellwig wrote:
> > On Wed, Dec 15, 2010 at 10:02:57PM -0700, Matthew Wilcox wrote:
> > > 
> > > I thought I'd take a crack at removing the host lock from uas.  I think
> > > I can now switch to using GFP_NOIO (since interrupts are enabled by
> > > scsi_request_fn()), and I have to use _irq spinlocks to protect the list
> > > that is modified from interrupt context (same reason :-).
> > 
> > ->qeuecommand can be called from software interrupt context, so you'll
> > need to stick to GFP_ATOMIC.
> 
> Ah, I couldn't find a path that did that.  Could you point it out to me?
> I'll send a patch to update that documentation.

Well, the documentation (scsi_mid_low_api.txt) says this.  The reason is
the blk_run_queue in softirq context.

James



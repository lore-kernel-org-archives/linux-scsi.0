From: linas@austin.ibm.com (Linas Vepstas)
Subject: Re: [PATCH 2/2]: PCI Error Recovery: Symbios SCSI First Failure
Date: Thu, 27 Sep 2007 17:00:22 -0500
Message-ID: <20070927220022.GC18686@austin.ibm.com>
References: <20070420204114.GL31947@austin.ibm.com> <20070420204720.GM31947@austin.ibm.com> <20070926150216.GH3899@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:44536 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755210AbXI0WAa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Sep 2007 18:00:30 -0400
Content-Disposition: inline
In-Reply-To: <20070926150216.GH3899@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz

On Wed, Sep 26, 2007 at 09:02:16AM -0600, Matthew Wilcox wrote:
> On Fri, Apr 20, 2007 at 03:47:20PM -0500, Linas Vepstas wrote:
> > Implement the so-called "first failure data capture" (FFDC) for the
> > symbios PCI error recovery.  After a PCI error event is reported,
> > the driver requests that MMIO be enabled. Once enabled, it 
> > then reads and dumps assorted status registers, and concludes
> > by requesting the usual reset sequence.
> 
> > +	/* Request that MMIO be enabled, so register dump can be taken. */
> > +	return PCI_ERS_RESULT_CAN_RECOVER;
> > +}
> 
> I'm a little concerned by the mention of MMIO.  It's entirely possible
> for the sym2 driver to be using ioports to access the card rather than
> MMIO.  Is it simply that it can't on the platform you test on?

The comment is misleading. I've been in the bad habit of calling
it "mmio" whenever its not DMA.

The habit is because there are two distinct enable bits in the 
pci-host bridge during error recovery: one to enable mmio/ioports, 
and the other to enable DMA. If the adapter has gone crazy, I don't 
want to enable DMA, so that it doesn't scribble to bad places. But, 
by enabling mmio/ioports, perhaps it can be finessed back into a 
semi-sane state, e.g. sane enough to perform a dump of its internal
state.

--linas

From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 2/2]: PCI Error Recovery: Symbios SCSI First Failure
Date: Thu, 27 Sep 2007 16:10:31 -0600
Message-ID: <20070927221031.GY3899@parisc-linux.org>
References: <20070420204114.GL31947@austin.ibm.com> <20070420204720.GM31947@austin.ibm.com> <20070926150216.GH3899@parisc-linux.org> <20070927220022.GC18686@austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:41528 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757983AbXI0WKd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Sep 2007 18:10:33 -0400
Content-Disposition: inline
In-Reply-To: <20070927220022.GC18686@austin.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linas Vepstas <linas@austin.ibm.com>
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz

On Thu, Sep 27, 2007 at 05:00:22PM -0500, Linas Vepstas wrote:
> On Wed, Sep 26, 2007 at 09:02:16AM -0600, Matthew Wilcox wrote:
> > I'm a little concerned by the mention of MMIO.  It's entirely possible
> > for the sym2 driver to be using ioports to access the card rather than
> > MMIO.  Is it simply that it can't on the platform you test on?
> 
> The comment is misleading. I've been in the bad habit of calling
> it "mmio" whenever its not DMA.

OK, cool, thanks.  I'll update the comment for you.

One last thing (sorry, I only just noticed):
In the error handler, we wait_for_completion(io_reset_wait).
In sym2_io_error_detected, we init_completion(io_reset_wait).
Isn't it possible that we hit the error handler before we hit the
io_error_detected path, and thus the completion wait is lost?
Since the completion is already initialised in sym_attach(), I don't
think we need to initialise it in sym2_io_error_detected().
Makes sense to just delete it?

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."

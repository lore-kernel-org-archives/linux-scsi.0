From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 2/2]: PCI Error Recovery: Symbios SCSI First Failure
Date: Mon, 1 Oct 2007 19:27:30 -0600
Message-ID: <20071002012730.GO12049@parisc-linux.org>
References: <20070420204114.GL31947@austin.ibm.com> <20070420204720.GM31947@austin.ibm.com> <20070926150216.GH3899@parisc-linux.org> <20070927220022.GC18686@austin.ibm.com> <20070927221031.GY3899@parisc-linux.org> <20070927233437.GF18686@austin.ibm.com> <20071001201247.GN12049@parisc-linux.org> <20071001224132.GH4338@austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:44813 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751181AbXJBB1c (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Oct 2007 21:27:32 -0400
Content-Disposition: inline
In-Reply-To: <20071001224132.GH4338@austin.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linas Vepstas <linas@austin.ibm.com>
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz

On Mon, Oct 01, 2007 at 05:41:32PM -0500, Linas Vepstas wrote:
> On Mon, Oct 01, 2007 at 02:12:47PM -0600, Matthew Wilcox wrote:
> > I think the fundamental problem is that completions aren't really
> > supposed to be used like this.  Here's one attempt at using completions
> > perhaps a little more the way they're supposed to be used, 
> 
> Yes, that looks very good to me.  I see it solves a bug that
> I hadn't been quite aware of. I don't understand why 
> struct host_data is preferable to struct sym_shcb (is it because 
> this is the structure that is "naturally protectected" by the 
> spinlock?)

The thing to remember is that sym2 is in transition from being a dual
BSD/Linux driver to being a purely Linux driver.  I know, it's been more
than two years, and I'm still not done.

My latest thing I'm looking at fixing is to make Scsi_Host very
much the primary entity in the sym2 driver, and leave just the
device/scripts-accessible stuff in the hcb.

> My gut instinct is to say "ack", although prudence dictates that 
> I should test first. Which might take a few days...

Fine by me.  Do you have the ability to produce failures on a whim on
your platforms?  I've been vaguely musing a PCI device failure patch for
x86, just so people can test driver failure paths.

> I thought that earlier versions of the driver used waitqueues (I vaguely
> remember "eh_wait" in the code), which were later converted to 
> completions (I also vaguely recall thinking that the new code was
> more elegant/simpler). I converted my patch to use the completions 
> likewise, and, as you've clearly shown, did a rather sloppy job in 
> the conversion.

eh_wait (when I removed it) contained a completion ... I think it used
to be a semaphore, some time before 2.6.12

> I'm tempted to go with this patch; but if you prod, I could attempt
> a wait-queue based patch.

Let's leave it with a completion for now.  I think it works out more
efficiently in the end.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."

From: linas@austin.ibm.com (Linas Vepstas)
Subject: Re: [PATCH 2/2]: PCI Error Recovery: Symbios SCSI First Failure
Date: Mon, 1 Oct 2007 17:41:32 -0500
Message-ID: <20071001224132.GH4338@austin.ibm.com>
References: <20070420204114.GL31947@austin.ibm.com> <20070420204720.GM31947@austin.ibm.com> <20070926150216.GH3899@parisc-linux.org> <20070927220022.GC18686@austin.ibm.com> <20070927221031.GY3899@parisc-linux.org> <20070927233437.GF18686@austin.ibm.com> <20071001201247.GN12049@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:43524 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752164AbXJAWlg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Oct 2007 18:41:36 -0400
Content-Disposition: inline
In-Reply-To: <20071001201247.GN12049@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz

On Mon, Oct 01, 2007 at 02:12:47PM -0600, Matthew Wilcox wrote:
> 
> I think the fundamental problem is that completions aren't really
> supposed to be used like this.  Here's one attempt at using completions
> perhaps a little more the way they're supposed to be used, 

Yes, that looks very good to me.  I see it solves a bug that
I hadn't been quite aware of. I don't understand why 
struct host_data is preferable to struct sym_shcb (is it because 
this is the structure that is "naturally protectected" by the 
spinlock?)

My gut instinct is to say "ack", although prudence dictates that 
I should test first. Which might take a few days...

> although now
> I've written it, I wonder if we shouldn't just use a waitqueue instead.

I thought that earlier versions of the driver used waitqueues (I vaguely
remember "eh_wait" in the code), which were later converted to 
completions (I also vaguely recall thinking that the new code was
more elegant/simpler). I converted my patch to use the completions 
likewise, and, as you've clearly shown, did a rather sloppy job in 
the conversion.

I'm tempted to go with this patch; but if you prod, I could attempt
a wait-queue based patch.

--linas


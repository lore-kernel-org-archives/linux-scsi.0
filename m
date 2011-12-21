From: David Dillow <dillowda@ornl.gov>
Subject: Re: [PATCH 10/14] srp_transport: Simplify attribute initialization
 code
Date: Tue, 20 Dec 2011 22:23:32 -0500
Message-ID: <1324437812.7621.47.camel@obelisk.thedillows.org>
References: <201112011954.25811.bvanassche@acm.org>
	 <201112012008.00502.bvanassche@acm.org>
	 <1324253243.17849.45.camel@obelisk.thedillows.org>
	 <CAO+b5-q7mBJ-K48Oyeh5jzRmiXAx7nnAhG97PpfSp8ESVC6tJQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from matrix.voodoobox.net ([75.127.97.206]:37403 "EHLO
	matrix.voodoobox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750947Ab1LUDXl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Dec 2011 22:23:41 -0500
In-Reply-To: <CAO+b5-q7mBJ-K48Oyeh5jzRmiXAx7nnAhG97PpfSp8ESVC6tJQ@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-rdma@vger.kernel.org, Fujita Tomonori <fujita.tomonori@lab.ntt.co.jp>, Brian King <brking@linux.vnet.ibm.com>, Roland Dreier <roland@purestorage.com>, linux-scsi@vger.kernel.org

On Tue, 2011-12-20 at 10:21 +0000, Bart Van Assche wrote:
> On Mon, Dec 19, 2011 at 12:07 AM, David Dillow <dillowda@ornl.gov> wrote:
> > They use a BUG_ON instead of WARN_ON, which
> > seems more appropriate, since we just overran a buffer...
> 
> Sorry, but I disagree. The guideline for Linux kernel code is to use
> BUG_ON() only if a crash can't be avoided. With SLUB red zoning
> enabled it is still possible to unload kernel modules after a (mild)
> buffer overrun. And if you have a look at mm/slub.c, you will see that
> slab_err() is invoked in case padding has been overwritten. That last
> function does something similar to WARN_ON().

You aren't guaranteed to have SLUB as your allocator, much less having
the red-zoning turned on, so you have no guarantee it is safe to
continue.

-- 
Dave Dillow
National Center for Computational Science
Oak Ridge National Laboratory
(865) 241-6602 office


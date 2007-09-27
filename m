From: linas@austin.ibm.com (Linas Vepstas)
Subject: Re: [PATCH 2/2]: PCI Error Recovery: Symbios SCSI First Failure
Date: Thu, 27 Sep 2007 18:34:37 -0500
Message-ID: <20070927233437.GF18686@austin.ibm.com>
References: <20070420204114.GL31947@austin.ibm.com> <20070420204720.GM31947@austin.ibm.com> <20070926150216.GH3899@parisc-linux.org> <20070927220022.GC18686@austin.ibm.com> <20070927221031.GY3899@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:52646 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759605AbXI0Xe7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Sep 2007 19:34:59 -0400
Content-Disposition: inline
In-Reply-To: <20070927221031.GY3899@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz

On Thu, Sep 27, 2007 at 04:10:31PM -0600, Matthew Wilcox wrote:
> In the error handler, we wait_for_completion(io_reset_wait).
> In sym2_io_error_detected, we init_completion(io_reset_wait).
> Isn't it possible that we hit the error handler before we hit the
> io_error_detected path, and thus the completion wait is lost?
> Since the completion is already initialised in sym_attach(), I don't
> think we need to initialise it in sym2_io_error_detected().
> Makes sense to just delete it?

Good catch. But no ... and I had to study this a bit. Bear with me:

It is enough to call init_completion() once, and not once per use:
it initializes spinlocks, which shouldn't be intialized twice. 

But, that completion might be used multiple times when there are
multiple errors, and so, before using it a second time, one must 
set completion->done = 0.  The INIT_COMPLETION() macro does this. 

One must have completion->done = 0 before every use, as otherwise, 
wait_for_completion() won't actually wait. And since complete_all()
sets x->done += UINT_MAX/2, I'm pretty sure x->done won't be zero
the next time we use it, unless we make it so.

So I need to find a place to safely call INIT_COMPLETION() again, 
after the completion has been used. At the moment, I'm stumped
as to where to do this. 

---- [think ... think ... think] ----

I think the race you describe above is harmless. The first time
that sym_eh_handler() will run, it will be with SYM_EH_ABORT, 
in it doesn't matter if we lose that, since the device is hosed
anyway. At some later time, it will run with SYM_EH_DEVICE_RESET
and then SYM_EH_BUS_RESET and then SYM_EH_HOST_RESET, and we won't 
miss those, since, by now, sym2_io_error_detected() will have run.

So, by my reading, I'd say that init_completion() in
sym2_io_error_detected() has to stay (although perhaps
it should be replaced by the INIT_COMPLETION() macro.)
Removing it will prevent correct operation on the second 
and subsequent errors.

--Linas


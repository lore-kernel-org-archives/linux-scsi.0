From: David Dillow <dillowda@ornl.gov>
Subject: Re: [PATCH 13/14] ib_srp: Implement transport layer ping
Date: Sat, 24 Dec 2011 15:07:18 -0500
Message-ID: <1324757240.3004.28.camel@obelisk.thedillows.org>
References: <201112011954.25811.bvanassche@acm.org>
	  <201112012011.45444.bvanassche@acm.org>
	  <1324255806.17849.68.camel@obelisk.thedillows.org>
	  <CAO+b5-o+-JF61a+8vFWj1rxMuVWuG-CVLQKorr5cKzi-Kc44Ag@mail.gmail.com>
	  <1324333931.7043.52.camel@lap75545.ornl.gov>
	  <CAO+b5-r4AZymMkVyFSXbBzpcc86hL0RJm2j3FnT3=uXSLUkj9A@mail.gmail.com>
	  <1324436736.7621.38.camel@obelisk.thedillows.org>
	  <CAO+b5-p=01KyDv7swOP_K39+i1rSMDsd_VVvSi5rBWveMaov1Q@mail.gmail.com>
	 <1324679698.3004.12.camel@obelisk.thedillows.org>
	 <4EF50705.7090200@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from matrix.voodoobox.net ([75.127.97.206]:36759 "EHLO
	matrix.voodoobox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751782Ab1LXUHl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 24 Dec 2011 15:07:41 -0500
In-Reply-To: <4EF50705.7090200@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Bart Van Assche <bvanassche@acm.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Roland Dreier <roland@purestorage.com>, Fujita Tomonori <fujita.tomonori@lab.ntt.co.jp>, Brian King <brking@linux.vnet.ibm.com>

On Fri, 2011-12-23 at 16:56 -0600, Mike Christie wrote:
> On 12/23/2011 04:34 PM, David Dillow wrote:
> > We should match the rest of the SCSI stack unless there is good reason
> > to go our own way. The iSCSI transport can do what it does because it
> > has a native ping, but I'm not convinced they should have introduced new
> > semantics and/or names when taking advantage of that. As far as I can
> > tell without deeply studying it, replacement_timeout is equivalent to
> > fast_io_fail_tmo.
> > 
> 
> iSCSI replacement_timeout is the same as fast_io_fail_tmo for FC. iSCSI
> replacement_timeout actually came first so you should say FC should have
> copied our name :)

Indeed, some git-foo seems to indicate both stacks had that
functionality mainlined in 2.6.18, with iSCSI getting it first. FC
should have used your name.

> iSCSI had replacement_timeout first, and it only fails IO, because at
> the time things did not handle hotplug removal well, and I did not know
> there was a need for the removal. There is patch to add dev_loss_tmo to
> the iSCSI layer. There have been some bugs though, so I have not pushed
> it. But it will also work like FC where you cannot turn it off.
> 
> SAS has something like the dev_loss_tmo. It does not have something like
> the fast_io_fail/replacement_timeout.

This says to me that SRP should use the dev_loss_tmo semantics, though
the naming of fast_io_fail vs replacement_timeout is a bit more of a
question than I thought. I tend to think of SRP more in terms of FC than
iSCSI, so I still prefer the former, but perhaps not as strongly now.

I still believe consistency is good -- what do the SCSI devs think here?
Should we work on getting a consistent name for this property -- and if
so, which one -- or does the name not matter?
-- 
Dave Dillow
National Center for Computational Science
Oak Ridge National Laboratory
(865) 241-6602 office


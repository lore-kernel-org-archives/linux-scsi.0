From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: Is there a grand plan for FC failover?
Date: 28 Jan 2004 17:14:26 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1075328066.2534.10.camel@mulgrave>
References: <401521A7.5030808@thekelleys.org.uk>
	<1075131446.2290.29.camel@mulgrave>
	<20040128100236.D11527@vienna.EGENERA.COM>
	<1075309052.2254.6.camel@mulgrave>
	<20040128130040.E11527@vienna.EGENERA.COM>
	<20040128124756.A7232@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:62617 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S266209AbUA1WPN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Jan 2004 17:15:13 -0500
In-Reply-To: <20040128124756.A7232@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: "Philip R. Auld" <pauld@egenera.com>, Simon Kelley <simon@thekelleys.org.uk>, SCSI Mailing List <linux-scsi@vger.kernel.org>, dm-devel@sistina.com

On Wed, 2004-01-28 at 15:47, Patrick Mansfield wrote:
> [cc-ing dm-devel]
> 
> My two main issues with dm multipath versus scsi core multipath are:
> 
> 1) It does not handle character devices.

Multi-path character devices are pretty much corner cases.  It's not
clear to me that you need to handle them in kernel at all.  Things like
multi-path tape often come with an application that's perfectly happy to
take the presentation of two or more tape devices.  Do we have a
character device example we need to support as a single device?

> 2) It does not have the information available about the state of the
> scsi_device or scsi_host (for path selection), or about the elevator.

Well, this is one of those abstraction case things.  Can we make the
information generic enough that the pathing layer makes the right
decisions without worrying about what the underlying internals are? 
That's where enhancements to the fastfail layer come in.  I believe we
can get the fastfail information to the point where we can use it to
make good decisions regardless of underlying transport (or even
subsystem).

> If we end up passing all the scsi information up to dm, and it does the
> same things that we already do in scsi (or in block), what is the point of
> putting the code into a separate layer?

It's for interpretation by those modular add-ons that are allowed to
cater to specific devices.

> More scsi fastfail like code is still needed - probably for all the cases
> where scsi_dev_queue_ready and scsi_host_queue_ready return 0 - and more.
> For example, should we somehow make sdev->queue_depth available to dm?

I agree.  We only have the basics at the moment.  Expanding the error
indications is a necessary next step.

> There are still issues with with a per path elevator (i.e. we have an
> elevator for each path rather than the entire device) that probably won't
> be fixed cleanly in 2.6. AFAIUI this requires moving dm from a bio based
> approach to a request based one.

We had the "where does the elevator go" discussion at the OLS bof.  I
think I heard agreement that the current situation of between dm and
block is suboptimal and that we'd like a true coalescing elevator above
dm with a vestigial one for the mid-layer to use for queueing below.  I
think this is a requirement for dm multipath to work well, but it's not
a requirement for it actually to work.

James



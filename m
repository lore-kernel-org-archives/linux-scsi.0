From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: Is there a grand plan for FC failover?
Date: Wed, 28 Jan 2004 16:55:34 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040128165534.A9202@beaverton.ibm.com>
References: <401521A7.5030808@thekelleys.org.uk> <1075131446.2290.29.camel@mulgrave> <20040128100236.D11527@vienna.EGENERA.COM> <1075309052.2254.6.camel@mulgrave> <20040128130040.E11527@vienna.EGENERA.COM> <20040128124756.A7232@beaverton.ibm.com> <1075328066.2534.10.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.101]:44202 "EHLO e1.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S266274AbUA2A4R (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Jan 2004 19:56:17 -0500
Content-Disposition: inline
In-Reply-To: <1075328066.2534.10.camel@mulgrave>; from James.Bottomley@steeleye.com on Wed, Jan 28, 2004 at 05:14:26PM -0500
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: "Philip R. Auld" <pauld@egenera.com>, Simon Kelley <simon@thekelleys.org.uk>, SCSI Mailing List <linux-scsi@vger.kernel.org>, dm-devel@sistina.com

On Wed, Jan 28, 2004 at 05:14:26PM -0500, James Bottomley wrote:
> On Wed, 2004-01-28 at 15:47, Patrick Mansfield wrote:
> > [cc-ing dm-devel]
> > 
> > My two main issues with dm multipath versus scsi core multipath are:
> > 
> > 1) It does not handle character devices.
> 
> Multi-path character devices are pretty much corner cases.  It's not
> clear to me that you need to handle them in kernel at all.  Things like
> multi-path tape often come with an application that's perfectly happy to
> take the presentation of two or more tape devices.  

I have not seen such applications. Standard applications like tar and cpio
are not going to work well.

If you plug a single ported tape drive or other scsi device into a fibre
channel SAN, it will show up multiple times, the hardware itself need not
be multiported.

> Do we have a
> character device example we need to support as a single device?

Not that I know of, but I have not worked in this area recently. I assume
there are also fibre attached media changers.

BTW, we need some sort of udev rules so we can have a multi-path device
(sd part, not dm part) actually show up multiple times.

> > 2) It does not have the information available about the state of the
> > scsi_device or scsi_host (for path selection), or about the elevator.
> 
> Well, this is one of those abstraction case things.  Can we make the
> information generic enough that the pathing layer makes the right
> decisions without worrying about what the underlying internals are? 

I don't think current interfaces and passing up error codes will be
enough, for example: a queue full on a given path (aka scsi_device) when
there is no other IO on that device could lead to starvation, similiar to
one node in a cluster starving other nodes out. 

Limiting IO via some sort of queue_depth in dm would help solve this
particular problem, but there is nothing in place today for dm to have its
own request queue or be request based, limiting the number of bio's to an
aribitrary value would suck, also the sdev->queue_depth is not visible to
dm today.

> That's where enhancements to the fastfail layer come in.  I believe we
> can get the fastfail information to the point where we can use it to
> make good decisions regardless of underlying transport (or even
> subsystem).

> > If we end up passing all the scsi information up to dm, and it does the
> > same things that we already do in scsi (or in block), what is the point of
> > putting the code into a separate layer?
> 
> It's for interpretation by those modular add-ons that are allowed to
> cater to specific devices.

I'm not sure what you mean - adding code or data that is only every used
by dm is wasted if you're not using dm.

> > More scsi fastfail like code is still needed - probably for all the cases
> > where scsi_dev_queue_ready and scsi_host_queue_ready return 0 - and more.
> > For example, should we somehow make sdev->queue_depth available to dm?
> 
> I agree.  We only have the basics at the moment.  Expanding the error
> indications is a necessary next step.

Yes, I was looking into this for use with changes Mike C is working on -
pass up an error via end_that_request_first or such.

> We had the "where does the elevator go" discussion at the OLS bof.  I
> think I heard agreement that the current situation of between dm and
> block is suboptimal and that we'd like a true coalescing elevator above
> dm with a vestigial one for the mid-layer to use for queueing below.  I
> think this is a requirement for dm multipath to work well, but it's not
> a requirement for it actually to work.

If the performance is bad enough, it doesn't matter if it works.

-- Patrick Mansfield

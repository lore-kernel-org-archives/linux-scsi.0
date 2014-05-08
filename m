From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: [PATCH 10/19] hpsa: set irq affinity hints to route MSI-X
 vectors across CPUs
Date: Thu, 8 May 2014 22:04:20 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B402956F07F98@G4W3202.americas.hpqcorp.net>
References: <20140508192239.13481.81880.stgit@beardog.cce.hp.com>
 <20140508192814.13481.56930.stgit@beardog.cce.hp.com>
 <alpine.LNX.2.03.1405090221590.1977@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3426.houston.hp.com ([15.201.208.54]:57185 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754809AbaEHWFc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 May 2014 18:05:32 -0400
In-Reply-To: <alpine.LNX.2.03.1405090221590.1977@cisco.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Govindarajulu Varadarajan <gvaradar@cisco.com>, "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: "james.bottomley@hansenpartnership.com" <james.bottomley@hansenpartnership.com>, "Lindley, Justin" <justin.lindley@hp.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "stephenmcameron@gmail.com" <stephenmcameron@gmail.com>, "Handzik, Joe" <joseph.t.handzik@hp.com>, "thenzl@redhat.com" <thenzl@redhat.com>, "michael.miller@canonical.com" <michael.miller@canonical.com>, "Teel, Scott Stacy" <scott.stacy.teel@hp.com>



> -----Original Message-----
> From: Govindarajulu Varadarajan [mailto:gvaradar@cisco.com]
> Sent: Thursday, 08 May, 2014 4:12 PM
> To: Stephen M. Cameron
> Cc: james.bottomley@hansenpartnership.com; Lindley, Justin;
> martin.petersen@oracle.com; linux-scsi@vger.kernel.org;
> stephenmcameron@gmail.com; Handzik, Joe; thenzl@redhat.com;
> michael.miller@canonical.com; Elliott, Robert (Server Storage); Teel, Scott
> Stacy
> Subject: Re: [PATCH 10/19] hpsa: set irq affinity hints to route MSI-X
> vectors across CPUs
> 
> 
> 
> On Thu, 8 May 2014, Stephen M. Cameron wrote:
> 
> > From: Stephen M. Cameron <scameron@beardog.cce.hp.com>
> >
> > Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
> > ---
> > drivers/scsi/hpsa.c |   17 ++++++++++++++++-
> > 1 files changed, 16 insertions(+), 1 deletions(-)
> >
> > diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> > index 9c44f26..e8090e2 100644
> > --- a/drivers/scsi/hpsa.c
> > +++ b/drivers/scsi/hpsa.c
> > @@ -6608,6 +6608,17 @@ static void hpsa_free_cmd_pool(struct ctlr_info *h)
> > 			h->ioaccel_cmd_pool, h->ioaccel_cmd_pool_dhandle);
> > }
> >
> > +static void hpsa_irq_affinity_hints(struct ctlr_info *h)
> > +{
> > +	int i, cpu, rc;
> > +
> > +	cpu = cpumask_first(cpu_online_mask);
> 
> Maybe consider setting cpu affinity hint based on numa locality 
> of pcie device and cpu? Instead of blindly assigning all online 
> cpu in order.
> 
> Something like
> 
>  	cpu = cpumask_first(cpumask_of_node(numa_node))
> 
> > +	for (i = 0; i < h->msix_vector; i++) {
> > +		rc = irq_set_affinity_hint(h->intr[i], get_cpu_mask(cpu));
> 
> You are not using return value rc. Why declare it?
> 
> Thanks
> Govind
> > +		cpu = cpumask_next(cpu, cpu_online_mask);
> > +	}
> > +}
> > +

We think matching the locality of the application is more 
important - delivering the message write carrying the MSI-X
interrupt across the CPU-to-CPU interconnect is less expensive 
than delivering it to the closest CPU and doing hardirq 
processing there, which causes cache traffic between that 
CPU and the CPU used for:
a) submission by the application and driver stack;
b) softirq processing; and
c) completion processing by the application.

That presumes the application thread is not wandering
to a different CPU after submission before completion.
If so, any choice is bound to be wrong sometimes.

If the block layer queue has rq_affinity=2, the softirq is
handled on the submitting CPU core; if rq_affinity=1, it
is handled on any core sharing the L3 cache (i.e., 
the same physical CPU socket).

With hyperthreading, the hyperthreaded sibling of the
submitting CPU core should be equally good at hardirq 
and softirq processing.  Is there an 
architecture-independent call in linux to report 
the CPUs sharing the same L1 (and L2) cache (i.e.,
the siblings)?  cpus_share_cache(), used by the block 
layer for rq_affinity=1, just reports CPUs sharing the 
same last level (L3) cache domain.  That still results 
in L2 traffic between cores inside a socket.

---
Rob Elliott    HP Server Storage







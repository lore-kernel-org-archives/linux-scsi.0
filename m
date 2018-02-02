From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [RFC 0/2] mpt3sas/megaraid_sas : irq poll and load balancing of
 reply queue
Date: Fri, 2 Feb 2018 20:52:56 +0800
Message-ID: <20180202125251.GA25020@ming.t460p>
References: <92d894a263bf37152fdae9699ccaccff@mail.gmail.com>
 <20180202101343.GA21241@ming.t460p>
 <2975c654e4a4d0c1fdfc3a1d4e86eb1d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45280 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751968AbeBBMxN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 2 Feb 2018 07:53:13 -0500
Content-Disposition: inline
In-Reply-To: <2975c654e4a4d0c1fdfc3a1d4e86eb1d@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kashyap Desai <kashyap.desai@broadcom.com>
Cc: linux-scsi@vger.kernel.org, Peter Rivera <peter.rivera@broadcom.com>

Hi Kashyap,

On Fri, Feb 02, 2018 at 05:08:12PM +0530, Kashyap Desai wrote:
> > -----Original Message-----
> > From: Ming Lei [mailto:ming.lei@redhat.com]
> > Sent: Friday, February 2, 2018 3:44 PM
> > To: Kashyap Desai
> > Cc: linux-scsi@vger.kernel.org; Peter Rivera
> > Subject: Re: [RFC 0/2] mpt3sas/megaraid_sas : irq poll and load
> balancing of
> > reply queue
> >
> > Hi Kashyap,
> >
> > On Mon, Jan 15, 2018 at 05:42:05PM +0530, Kashyap Desai wrote:
> > > Hi All -
> > >
> > > We have seen cpu lock up issue from fields if system has greater (more
> > > than 96) logical cpu count.
> > > SAS3.0 controller (Invader series) supports at max 96 msix vector and
> > > SAS3.5 product (Ventura) supports at max 128 msix vectors.
> > >
> > > This may be a generic issue (if PCI device support  completion on
> > > multiple reply queues). Let me explain it w.r.t to mpt3sas supported
> > > h/w just to simplify the problem and possible changes to handle such
> > > issues. IT HBA
> > > (mpt3sas) supports multiple reply queues in completion path. Driver
> > > creates MSI-x vectors for controller as "min of ( FW supported Reply
> > > queue, Logical CPUs)". If submitter is not interrupted via completion
> > > on same CPU, there is a loop in the IO path. This behavior can cause
> > > hard/soft CPU lockups, IO timeout, system sluggish etc.
> >
> > As I mentioned in another thread, this issue may be solved by SCSI_MQ
> via
> > mapping reply queue into hctx of blk_mq, together with
> > QUEUE_FLAG_SAME_FORCE, especially you have set 'smp_affinity_enable' as
> > 1 at default already, then pci_alloc_irq_vectors(PCI_IRQ_AFFINITY) can
> do IRQ
> > vectors spread on CPUs perfectly for you.
> >
> > But the following Hannes's patch is required for the conversion.
> >
> > 	https://marc.info/?l=linux-block&m=149130770004507&w=2
> >
> 
> Hi Ming -
> 
> I gone through thread discussing "support host-wide tagset". Below Link
> has latest reply on that thread.
> https://marc.info/?l=linux-block&m=149132580511346&w=2
> 
> I think, there is a confusion over mpt3sas and megaraid_sas h/w behavior.
> Broadcom/LSI HBA and MR h/w has only one h/w queue for submission but
> there are multiple reply queue.

That shouldn't be a problem, you still can submit to same hw queue in
all submission paths(all hw queues) just like the current implementation.

> Even though I include Hannes' patch for host-side tagset, problem
> described in this RFC will not be resolved.  In fact, tagset can also
> provide same results if completion queue is less than online CPU. Don't
> you think ? OR I am missing anything ?

If reply queue is less than online CPU, more than one CPU may be mapped
to some(or all) of hw queue, but the completion is only handled on one of
the mapped CPUs, and can be done on the request's submission CPU via the
queue flag of QUEUE_FLAG_SAME_FORCE, please see __blk_mq_complete_request().
Or do you have other requirement except for completing request on its
submission CPU?

> 
> We don't have problem in submission path.  Current problem is MSI-x to
> more than one  CPU can cause I/O loop. This is visible, if we have higher
> number of online CPUs.

Yeah, I know, as I mentioned above, your requirement of completing
request on its submission CPU can be met with current SCSI_MQ without
much difficulty.

Thanks,
Ming

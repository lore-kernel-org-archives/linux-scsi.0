From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [patch 2.5] ips queue depths
Date: Wed, 16 Oct 2002 12:04:36 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021016120436.A1598@eng2.beaverton.ibm.com>
References: <A3B9245C291EEF4785A24A1DBE8D852B0376BC@rtpexc01.adaptec.com> <20021015194705.GD4391@redhat.com> <20021015130445.A829@eng2.beaverton.ibm.com> <20021015205218.GG4391@redhat.com> <20021015163057.A7687@eng2.beaverton.ibm.com> <20021016023231.GA4690@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from westrelay03.boulder.ibm.com (westrelay03.boulder.ibm.com [9.17.194.24])
	by e33.co.us.ibm.com (8.12.2/8.12.2) with ESMTP id g9GJ4gpQ017208
	for <linux-scsi@vger.kernel.org>; Wed, 16 Oct 2002 15:04:42 -0400
Received: from gateway.beaverton.ibm.com (gateway.beaverton.ibm.com [138.95.180.1])
	by westrelay03.boulder.ibm.com (8.12.3/NCO/VER6.4) with ESMTP id g9GJ4fBw079712
	for <linux-scsi@vger.kernel.org>; Wed, 16 Oct 2002 13:04:41 -0600
Received: from eng2.beaverton.ibm.com (eng2.beaverton.ibm.com [9.47.57.17])
	by gateway.beaverton.ibm.com (8.10.0.Beta10/8.11.6) with ESMTP id g9GJ4cv12106
	for <linux-scsi@vger.kernel.org>; Wed, 16 Oct 2002 12:04:38 -0700 (PDT)
Received: (from patman@localhost)
	by eng2.beaverton.ibm.com (8.10.0.Beta10/8.8.5/token.aware-1.2) id g9GJ4aL02704
	for linux-scsi@vger.kernel.org; Wed, 16 Oct 2002 12:04:36 -0700 (PDT)
In-Reply-To: <20021016023231.GA4690@redhat.com>; from dledford@redhat.com on Tue, Oct 15, 2002 at 10:32:31PM -0400
List-Id: linux-scsi@vger.kernel.org
To: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

On Tue, Oct 15, 2002 at 10:32:31PM -0400, Doug Ledford wrote:
> On Tue, Oct 15, 2002 at 04:30:57PM -0700, Patrick Mansfield wrote:
> 
> > If the adapter is setting queue depth based upon what
> > the adapter knows, that is completely wrong
> 
> I strongly disagree here.  Only the adapter driver knows if the card 
> itself has a hard limit of X commands at a time (so that deeper queues are 
> wasted).  Only the adapter driver knows if the particular interconnect has 
> any inherent queue limitations or speed limitations.  There are a thousand 
> things only the adapter driver knows that should be factored into a sane 
> queue depth.

OK, the adapter does not get it completely wrong, but it does not
know about special scsi device limitations, block layer limits, usage
patterns, or total number of scsi devices on the system.

Your changes (set high, adjust lower as we hit queue fulls) should
work fine in most cases, and is much better than the previous state.

Some example cases where we might want to lower queue depth:

System with small amounts of memory compared to the number of devices.

With many disks on a system, some with a very light load, it could be
give the lightly loaded disks a lower queue depth so they use less
memory, or so they can do less IO.

In a 2 node cluster with shared devices, the queue depth could be set to
half of some hard limit on each node of the cluster, and avoid hitting
any hard queue fulls.

(It would really nice if we could modify the number of struct request's 
allocated for little used or unused devices, or on character devices like
tape that don't even use the requests. Current block code allocates 2*128
of these on systems with lots of memory, this could save way more space
than lowering the queue depth.)

> > It would nice to have more device model/kernfs device attributes.
> > 
> > With your new queueing code, if we expose and allow setting new_queue_depth,
> > user code can easily modify the queue depth.
> 
> No.  For the reasons that the driver knows what it's capable of, there 
> really is *very* little tunability here.  But, should you really need it, 
> the drivers should provide it (both mine and Justin's aic7xxx drivers do 
> so run time via module options or boot command options).  Make the default 
> a good common default, let users override if necessary.  But I wouldn't 
> make it a fiddle knob that people can tweak without thinking.  Regardless 
> of where you make it adjustable though, it has to be passed through the 
> low level drivers so that they can adjust their internal data structs as 
> needed (some won't have to do anything, some will have to do allocations 
> or frees on every adjustment, so you *have* to pass all adjustments 
> through them).

I was suggesting a common interface via a Scsi_Device device attribute
so the default depth can be modified as needed, rather than a fixed
boot or module load option that is fixed (once the driver is loaded)
and might be a different option for every adapter driver.

It's too bad we can't modify new_queue_depth and have all the layers
(well mid and lower) adjust accordingly.

-- Patrick Mansfield

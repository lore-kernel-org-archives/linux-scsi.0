From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [patch 2.5] ips queue depths
Date: Thu, 17 Oct 2002 10:01:15 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021017170115.GA4558@beaverton.ibm.com>
References: <A3B9245C291EEF4785A24A1DBE8D852B0376BC@rtpexc01.adaptec.com> <20021015194705.GD4391@redhat.com> <20021015130445.A829@eng2.beaverton.ibm.com> <20021015205218.GG4391@redhat.com> <20021015163057.A7687@eng2.beaverton.ibm.com> <20021016023231.GA4690@redhat.com> <20021016120436.A1598@eng2.beaverton.ibm.com> <3DAE06B9.FBB60D49@splentec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3DAE06B9.FBB60D49@splentec.com>
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben@splentec.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

Luben Tuikov [luben@splentec.com] wrote:
> Valid point, but what kind of memory allocator are you thinking of?
> 
> I'm thinking more of the lines of, what was once suggested by Doug,
> a pool of the objects and if we need one, just unhook it from its
> struct list_head (great solution), and use it... (search linux-scsi for
> the exact message)
> 
> That is, the queue becomes just a NUMBER, an int if you like, and
> the resource management is centralized, thus wasting LESS resources,
> as resource users increases (OS 101).
> 
> Now let's take this step further, and _delegate_. Let's give resource
> management to the lookaside cache (kmem_cache_create() and friends) and let
> that (the) resource manager worry about whether it uses struct list_head,
> or what not and how many pages it has preallocated and what not, and if
> we have a problem with how fast or what not, we can get in touch with its
> maintainers. (Though I've used that solution in my drivers and I get
> _excellent_ performance.)
> 
> So you see, the tagged device queue itself would be a number rather than
> wasted resources.
> 

I assume all devices will be guaranteed a min of the poll otherwise under
memory pressure we could be unable to do IO on swap devices.

> This discussion should be dropped already.
> 
> Just imagine what would happen if a SCSI LLDD suddently finds out that
> its tagged device queue depth has been changed, what is it supposed to do?
> 
> Furthermore, you say ``so the default depth can be modified as needed'',
> which contradicts the meaning of ``default''.
> 
> In fact the default setting wouldn't play much, and would be quickly forgotten
> as soon as the driver is run and disk/devices are connected to it. So in this
> respect it has little significance.
> 
> Even if you have little memory (thin client) it makes sense to have a TCQ depth
> of 200 if you're connected to a monster storage system, since if you send
> 200 tagged commands to /dev/sda they may NOT necessarily go to one ``device''.
> Imagine that!

Just because a device can accept a command and not return busy does not
mean it is always a good thing to give it 200 commands. Most larger
arrays will have dynamic queue depths and accept a lot of IO without
really working on it. If the delta of time is increasing on your IO than
at some point you are inefficient. We have already seen on some adapters
that reducing the queue depths achieved the same amount of IO rate with
reduced CPU overhead. Which is a good thing as users usally want to do
something else besides IO.

If you are using shared resources (i.e. sg_table pool mem, the above
suggested scsi command poll, timers, etc) to avoid resource starvation
you might need to set limits outside of what a single LLDD believes is
best. More efficient implementations would also reduce some of the
overhead.

A administrator may want to adjust the overall policy for a specific
work load. Maybe proper values can be set and feedback information can
allow self adjustment, but there are probably workloads that the
values are incorrect. What that policy is would depend on the resources.
Something similar to vm adjustments.

-andmike
--
Michael Anderson
andmike@us.ibm.com


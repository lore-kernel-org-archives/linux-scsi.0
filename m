From: Luben Tuikov <luben@splentec.com>
Subject: Re: [patch 2.5] ips queue depths
Date: Wed, 16 Oct 2002 20:39:21 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3DAE06B9.FBB60D49@splentec.com>
References: <A3B9245C291EEF4785A24A1DBE8D852B0376BC@rtpexc01.adaptec.com> <20021015194705.GD4391@redhat.com> <20021015130445.A829@eng2.beaverton.ibm.com> <20021015205218.GG4391@redhat.com> <20021015163057.A7687@eng2.beaverton.ibm.com> <20021016023231.GA4690@redhat.com> <20021016120436.A1598@eng2.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from splentec.com (canoe.splentec.com [209.47.35.250])
	by pepsi.splentec.com (8.11.6/8.11.0) with ESMTP id g9H0dKf04699
	for <linux-scsi@vger.kernel.org>; Wed, 16 Oct 2002 20:39:20 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

Patrick Mansfield wrote:
> 
> OK, the adapter does not get it completely wrong, but it does not
> know about special scsi device limitations, block layer limits, usage
> patterns, or total number of scsi devices on the system.
>

This is the dependency graph:

   block layer <-- SCSI core <-- SCSI LLDD.

where ``A <-- B'', means ``A depends on B''.

That is, the block layer (as an UPPER LAYER) should change its
parameters as suggested by the lower layers, since they operate
closer to the real devices, and NOT the other way around, as
has been suggested so many times here. (The whole point of an OS.)

That is, should should NOT force the device and you should NOT restrain
the device.

Also involving the elevator algorithm, merging, etc, is not appropriate
when we talk about such things as TCQ depths, just because those notions
belong to a different layer (upper at that).
 
> Some example cases where we might want to lower queue depth:
> 
> System with small amounts of memory compared to the number of devices.
> 
> With many disks on a system, some with a very light load, it could be
> give the lightly loaded disks a lower queue depth so they use less
> memory, or so they can do less IO.
> 
> In a 2 node cluster with shared devices, the queue depth could be set to
> half of some hard limit on each node of the cluster, and avoid hitting
> any hard queue fulls.
> 
> (It would really nice if we could modify the number of struct request's
> allocated for little used or unused devices, or on character devices like
> tape that don't even use the requests. Current block code allocates 2*128
> of these on systems with lots of memory, this could save way more space
> than lowering the queue depth.)
> 

Valid point, but what kind of memory allocator are you thinking of?

I'm thinking more of the lines of, what was once suggested by Doug,
a pool of the objects and if we need one, just unhook it from its
struct list_head (great solution), and use it... (search linux-scsi for
the exact message)

That is, the queue becomes just a NUMBER, an int if you like, and
the resource management is centralized, thus wasting LESS resources,
as resource users increases (OS 101).

Now let's take this step further, and _delegate_. Let's give resource
management to the lookaside cache (kmem_cache_create() and friends) and let
that (the) resource manager worry about whether it uses struct list_head,
or what not and how many pages it has preallocated and what not, and if
we have a problem with how fast or what not, we can get in touch with its
maintainers. (Though I've used that solution in my drivers and I get
_excellent_ performance.)

So you see, the tagged device queue itself would be a number rather than
wasted resources.

> I was suggesting a common interface via a Scsi_Device device attribute
> so the default depth can be modified as needed, rather than a fixed
> boot or module load option that is fixed (once the driver is loaded)
> and might be a different option for every adapter driver.

This discussion should be dropped already.

Just imagine what would happen if a SCSI LLDD suddently finds out that
its tagged device queue depth has been changed, what is it supposed to do?

Furthermore, you say ``so the default depth can be modified as needed'',
which contradicts the meaning of ``default''.

In fact the default setting wouldn't play much, and would be quickly forgotten
as soon as the driver is run and disk/devices are connected to it. So in this
respect it has little significance.

Even if you have little memory (thin client) it makes sense to have a TCQ depth
of 200 if you're connected to a monster storage system, since if you send
200 tagged commands to /dev/sda they may NOT necessarily go to one ``device''.
Imagine that!

-- 
Luben

From: Luben Tuikov <luben@splentec.com>
Subject: Re: scsi command slab allocation under memory pressure
Date: Wed, 29 Jan 2003 17:26:45 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E385525.9090209@splentec.com>
References: <20030129104731.A2811@beaverton.ibm.com> <3E382E2C.4030201@splentec.com> <20030129121117.A3389@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: linux-scsi@vger.kernel.org

Patrick Mansfield wrote:
>>The problem with N is that I do *not* have a heuristic which will tell me
>>what a suitable value for N is.  How about 5, hmm, what about 10, or maybe
>>1e10?
> 
> 
> We do have bounds on the number of commands.

Yes, and it is can_queue and it is per host -- we all know this.
I was talking about N, which is a bit different matter.

> Assuming N is the minimum number of commands we want available:
> 
> Currently (plain 2.5.59) we have N being at the number of scsi_device's on
> the system, and we always have at least one command available for each
> scsi_device.

This has two problems: 1. ``currently'' and 2. number of scsi_devices
on the system.

1. We should improve, ``currently'' may not be the best policy.
(Thus the slab allocator.)

2. If I had to go this route, I'd say: the number of scsi_devices
per host; but this number is dynamic as devices come and go.
(So we get a hint at a dynamic heuristic.)

> It is not clear if N should be the number of scsi commands that might be
> outstanding on the system (what it used to be prior to Doug L's queue
> depth changes, and what we have in 2.4).

This has two problems: 1. ``It is not clear'' and 2. ``outstanding
on the system''.

1. I think I did mention this in my previous reply. (Thus N = 1.)

2. This is a pickle and might I mention that Doug's queue depth
changes were *for a reason*, so there's no point in saying
``the way it was before''.  Furthermore ``the number of outstanding
commands'' is ambiguous and any which way it is it, is NOT enough.
I.e. outstaning in LLDD, oustanding free, etc. -- it just doesn't
compute.

> So N should be at least the number of scsi_devices on the system, and at
> most the sum of all the commands that can potentially be used by all
> scsi_devices on the system.

How did you deduce this if one of your premises starts with ``It is not clear''?

This has 2 problems: 1. ``number of scsi_devices on the system'' and
2. ``sum off all commands which can potentially be used by all scsi_devices
on the system''.

1. This number is dynamic. N is *per host* and not per SCSI Core, i.e.
it would've been more proper to say, ``number of scsi devices per host'',
which would also not be sufficient, since this number is also dynamic.

Furthermore, if N > 1, and the system is under memory pressure such that
the cache allocator fails, it is true that a single device can starve
the others of scsi commands, for any 1 < N <= can_queue !  So this
doesn't quite do it as well, and a per device back-up would be needed.

Which would *not* be that helpful since we can get in to the same
argument.... how many is good enough.

2. In which case we *do not* need the cache allocator at all.
I.e. you're saying that N = can_queue - number_cmnds_queued + 1,
and I did comment on this in my previous mail and will say it
again: in which case we do NOT need the cache allocator at all.
(homework: show why)

And the whole reason of this is to give memory allocation
to another subsystem.  Hint again: see the flags with which
the caches are created.

>>Furthermore, N may be a constant or it may be a function of how much
>>memory we currently have, how many commands have been queued into the host,
>>etc, or it may just be N = can_queue - num_queued_commands + 1, which is
>>dynamic, which is pointless (Homework: show why).
>>
>>We want to waste as little memory as possible (thus 1 per host), since
>>SCSI Core is not the only subsystem running on the machine.  Hint:
>>see the flags the slabs are allocated with.  Using the Central Limit
>>Theorem, I hope that by the time we get low on memory pressure, the scsi
>>command cache pool size has settled*.  Unless we started with very little
>>memory, which would be quite unusual in this day and age.
> 
> 
> If we must allocate enough space to ensure proper swapout behavour, it is
> not a waste!

Are we creating a problem with generalims like this one?  How much is ``enough''?
Or how long is the long hair?

I think I mentioned this conundrum in my previous email.

> IMO we need something similiar to the request_queue_t free list, where
> we allocate a bunch of items up front out of a slab.

Yes, this a static heuristic. See below for comments on this policy.

>>* Lots of assumptions here, but all valid for a *server* machine.
>>
>>Let's get some experience with this thing running and actually have a
>>*natural* failing example, and we can twiddle with the initial value
>>of N, and/or can develop a f(N) which would be computed occasionally
>>and free_list varied upon scsi_put_command().
> 
> 
> Are you saying we will always be able to get a command under low memory
> situtations? 

The cache allocator page values should've settled after a few hours
of intensive SCSI IO. (Cf. Central Limit Theorem)  And those values
always *round up* by the lookaside cache, which means
that the cache allocator would always have more than can_queue
if in that time can_queue was ever reached.

It would be *quite a rare* circumstance that the cache allocator would fail
(again hint: see the flags which with they are created), and even if it
did fail, chances are that other subsystems would free memory, or a scsi
command would finish, etc. in which case SCSI Core could go on.

It could fail if, e.g., an exorbitant amount of scsi devices were
plugged on the fabric *while* the system was experiencing memory pressure.
Thus the above mentioning average value would not be correct anymore,
as the number of devices has changed.  *BUT* by having N=1, we wouldn't
load the system as much as if we had a different initial N, say N=10.

So this is tricky, it could be the case that in two exact same circumstances
when N=1 the system could survive, but for N=10, we crash it.

So the best policy is a dynamic heuristic.

But I think that *YOU* should be making this argument, since it looks
like you're not happy with the slab allocator being used for scsi commands.

> If not, the code should be changed, otherwise please explain how.

Looks like you have an agenda.  If you have nothing else to do, please
go ahead and rip the code apart and do your own thoughtful and smart
changes.  Go ahead, overengineer as you wish.

> We should not wait for a failure to occur to answer the question.

Another generalism.

If you have a heuristic for N, either *static*, i.e.
	N = can_queue/10 + 1,
or *dynamic*, i.e.:
	N_0 = can_queue/10 + 1,  (no devices yet)
	N_i = host::num_devices + N_(i-1)/2,  i > 0,
*please* suggest it, show it, and prove it. (See bottom of text.)

Just remember, the whole framework is one such that:

1. SCSI Core MUST NOT just blindly call the slab for more
memory -- this *beats the whole purpose* of using the
slab and we could just as well use kmalloc().

2. Adjustment should be done at scsi_put_command(). I.e.
we're *holding off* commands from the slab on scsi_put_command(),
depending on the heuristic. (Which by definition tells us something
about the *future* and this is the whole point.) So that in the
future we can be ok, should memory be scarce.  I.e. do we need
to decrease or increase the commands in free_list, depending on
the current value of N_i.

In the example I gave above for a dynamic heuristic, it is
easiliy shown that
	N_i = 2*(host::num_devices), i -> inf.
To show this is important as we don't want to drain the computer's
memory.

The above heuristic would settle for N being 2 times the number of
devices, which is good, since if can_queue = 255,
we have N_0 = 26, but after a few generations, we don't want to keep
so many commands around, and given we have only one device, we
settle to N_i = 2, i -> inf.

This was just an example, of course.  You can model your work similarly.

BTW, if you are so ardent on this whole issue I can put code in for
the heuristic, and you can supply N_0 and N_i.

-- 
Luben





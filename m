From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: scsi command slab allocation under memory pressure
Date: Wed, 29 Jan 2003 12:11:17 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030129121117.A3389@beaverton.ibm.com>
References: <20030129104731.A2811@beaverton.ibm.com> <3E382E2C.4030201@splentec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3E382E2C.4030201@splentec.com>; from luben@splentec.com on Wed, Jan 29, 2003 at 02:40:28PM -0500
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben@splentec.com>
Cc: linux-scsi@vger.kernel.org

On Wed, Jan 29, 2003 at 02:40:28PM -0500, Luben Tuikov wrote:
> Patrick Mansfield wrote:
> 
> Is this a question, narrative, comment or flame?  I'll try to answer
> this anyway.

Yes, except for the flame part :)

> James had this comment, just because I put the mechanism there to allow
> for more than one command to be in the store of backup command structs.
> See my reply to his email in the archives.
> 
> The reason for populating free_list with just one command on host init,
> is quite obvious, but to elaborate, the choices are 1 and N, where N is
> a natural number greater than 1.
> 
> The problem with N is that I do *not* have a heuristic which will tell me
> what a suitable value for N is.  How about 5, hmm, what about 10, or maybe
> 1e10?

We do have bounds on the number of commands.

Assuming N is the minimum number of commands we want available:

Currently (plain 2.5.59) we have N being at the number of scsi_device's on
the system, and we always have at least one command available for each
scsi_device.

It is not clear if N should be the number of scsi commands that might be
outstanding on the system (what it used to be prior to Doug L's queue
depth changes, and what we have in 2.4).

So N should be at least the number of scsi_devices on the system, and at
most the sum of all the commands that can potentially be used by all
scsi_devices on the system.

> Furthermore, N may be a constant or it may be a function of how much
> memory we currently have, how many commands have been queued into the host,
> etc, or it may just be N = can_queue - num_queued_commands + 1, which is
> dynamic, which is pointless (Homework: show why).
> 
> We want to waste as little memory as possible (thus 1 per host), since
> SCSI Core is not the only subsystem running on the machine.  Hint:
> see the flags the slabs are allocated with.  Using the Central Limit
> Theorem, I hope that by the time we get low on memory pressure, the scsi
> command cache pool size has settled*.  Unless we started with very little
> memory, which would be quite unusual in this day and age.

If we must allocate enough space to ensure proper swapout behavour, it is
not a waste!

IMO we need something similiar to the request_queue_t free list, where
we allocate a bunch of items up front out of a slab.

> * Lots of assumptions here, but all valid for a *server* machine.
> 
> Let's get some experience with this thing running and actually have a
> *natural* failing example, and we can twiddle with the initial value
> of N, and/or can develop a f(N) which would be computed occasionally
> and free_list varied upon scsi_put_command().

Are you saying we will always be able to get a command under low memory
situtations? 

If not, the code should be changed, otherwise please explain how.

We should not wait for a failure to occur to answer the question.

-- Patrick Mansfield

From: Luben Tuikov <luben@splentec.com>
Subject: Re: scsi command slab allocation under memory pressure
Date: Wed, 29 Jan 2003 14:40:28 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E382E2C.4030201@splentec.com>
References: <20030129104731.A2811@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: linux-scsi@vger.kernel.org

Patrick Mansfield wrote:
> James had a similiar comment about this (free_list storing multiple
> commands).
> 
> The linux-scsi.bkbits.net scsi-kmem_alloc-2.5 and scsi-combined-2.5 tree
> include the scsi command slab allocation (Luben's patch).
> 
> How does the use of a single slab for all hosts and all devices allow for
> IO while under memory pressure?
> 
> There is one extra scsi command pre-allocated per host, but don't we
> require at least one (and ideally maybe more) per device? The pre-slab
> (current mainline kernel) command allocation always had at least one
> command per device available, and usually more (because we allocated more
> commands during the scan and upper level init).
> 
> That is - if we have swap on a separate disk and our command pool is small
> enough, IO to another disk could use the single per-host command under
> memory pressure, and we can fail to get a scsi command in order to write
> to the swap disk. 
> 
> scsi_put_command() re-fills the host->free_list if it is empty, but under
> high (or higher) IO loads, the disk/device that generated the
> scsi_put_command will immediately issue a scsi_get_command for the same
> device.
> 
> If all command allocations are failing for a particular device (i.e.
> swap), we will wait a bit (device_blocked and device_busy == 0) and try
> again, we will not retry based on a scsi_put_command(). Even if we did
> retry based on a scsi_put_command, we will can race with the
> scsi_put_command caller.

Is this a question, narrative, comment or flame?  I'll try to answer
this anyway.

James had this comment, just because I put the mechanism there to allow
for more than one command to be in the store of backup command structs.
See my reply to his email in the archives.

The reason for populating free_list with just one command on host init,
is quite obvious, but to elaborate, the choices are 1 and N, where N is
a natural number greater than 1.

The problem with N is that I do *not* have a heuristic which will tell me
what a suitable value for N is.  How about 5, hmm, what about 10, or maybe
1e10?

Furthermore, N may be a constant or it may be a function of how much
memory we currently have, how many commands have been queued into the host,
etc, or it may just be N = can_queue - num_queued_commands + 1, which is
dynamic, which is pointless (Homework: show why).

We want to waste as little memory as possible (thus 1 per host), since
SCSI Core is not the only subsystem running on the machine.  Hint:
see the flags the slabs are allocated with.  Using the Central Limit
Theorem, I hope that by the time we get low on memory pressure, the scsi
command cache pool size has settled*.  Unless we started with very little
memory, which would be quite unusual in this day and age.

* Lots of assumptions here, but all valid for a *server* machine.

Let's get some experience with this thing running and actually have a
*natural* failing example, and we can twiddle with the initial value
of N, and/or can develop a f(N) which would be computed occasionally
and free_list varied upon scsi_put_command().

-- 
Luben

P.S. In my own mini-scsi-core I haven't had any problems with this issue.




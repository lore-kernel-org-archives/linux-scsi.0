From: Luben Tuikov <luben@splentec.com>
Subject: Re: [PATCH / RFC] scsi_error handler update. (1/4)
Date: Thu, 13 Feb 2003 13:55:15 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E4BEA13.50402@splentec.com>
References: <3E492992.90502@splentec.com> <20030211172256.GC3164@beaverton.ibm.com> <3E494977.1070706@splentec.com> <3E495862.3050709@splentec.com> <20030211212048.GC1114@beaverton.ibm.com> <3E49698D.3030402@splentec.com> <20030211224119.A23149@infradead.org> <3E4AAA3F.8040002@splentec.com> <20030212204634.A17425@infradead.org> <3E4AC0B5.9030208@splentec.com> <20030213154748.A1965@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Mike Anderson <andmike@us.ibm.com>, linux-scsi@vger.kernel.org

Christoph Hellwig wrote:
>>If a LLDD drops the lock on entry and gains it again on exit, then clearly
>>it doesn't need it.
>>
>>Else if it doesn't, it then must be relying on it elsewhere, which is
>>asking for trouble from eh_* point of view.  A search and replace
>>will do ok, with a local lock,
> 
> 
> right.
> 
> 
>>unless it sets the pointer, in which case this is much easier.
> 
> 
> which pointer?  the host lock?

Yes.

[On host_lock be gone:]

> I think it's absolutely worth the effort!

[On new queuecommand() prototype]

> James, any comments on this one?  I think it's something that is save for
> 2.5.

Glad to hear that you're agreeing with me, but it doesn't depend on us.

>>>If you have anough time a prototype now won't hurt though - the scsi code
>>>shouldn't really change during early 2.6.
>>
>>Yes, I've been thinking of rewriting SCSI Core completely for 2.7, so maybe
>>this prototype will be its embryonic state?
> 
> 
> Maybe :)

But of course -- you'll probably just use the idea and rewrite everything. :-)

Anyway, one of my greatest beef with the current SCSI Core is the variable
names.  At the bottom I explain/give justification of *why* indeed I have
a problem in general with naming. (I think I gave it away several times before.)

Examples:
scsi_device:
	::siblings -- this is NOT a container of siblings, which
are to be the devices themselves, but is an *entry* into a siblings container.
Thus, in the host we have a siblings container and the scsi_device
should have an ``entry'' into this container.  Furthermore, I'd not choose
``host::siblings'' but something more approachable like ``host::device_list''.

	::same_target_siblings -- this shouldn't exist by design.

	::device_busy -- this should probably be atomic_t and its name should
be more descriptive of what it *is* -- something like ``active_cmd_count''.

	Ideally when there's a queue for each state of a command, say,
incoming_q, pending_q, done_q, those will have also have their own atomic_t
count, like incoming_q_count, pending_q_count, done_q_count, and maybe their
own locks, like incoming_q_lock, pending_q_lock, done_q_lock.
This and other similar features would make new-scsi-core, completely
re-entrant and multithread capable.

scsi_host:
	::sh_list -- this is an entry, but it suggests being a list.

	::my_devices -- ``device_list'' would've been so much better.
We know that those *are* going to be the host's devices -- whom else's
are they going to be?

	::host_busy -- could this have been ever more ambiguous?

	::host_failed -- this suggests a boolean value... but it's
not.

	In general if an object should participate in some sort
of a container like a list or queue, it should do so one at a time.
This way a dependency chart is very clear and there's no loops,
which would lead to poor programming design.  Everyone should
have taken a course in this during their undergrad years at
college/university.

E.g. scsi_core <- portal <- target <- lun <- command,
where each level to the right is 0/1:N.

In fact, programming is done as soon as the *design* of
the object structure and names is complete.  The rest is
just coding the functions to describe the relationships
between the objects.

Blah... blah... blah... am I wasting my time?

>>Some features would be that target/lun scanning will be a completely *distinct*
>>functionality and one can even move it to userspace.
> 
> 
> James, outlined something similar on the last kernel summit.  I think it's
> a worthwile change for 2.7 (let's hope initramfs is useable then)

Yes, I know.  But this ``feature'' is *not* the driving force of the
new design of the new-scsi-core.  In fact, the other way around.

I.e. since new-scsi-core is jus an *interface* to the Service Delivery
Subsystem (aka LLDD), target/lun scanning is NOT part of it.  new-scsi-core
just sits between the application client sending scsi tasks (read/write/etc)
and the LLDD's interface, plus a few minor capabilites.

I.e. target/lun scanning will be an application client sending scsi commands
down the LLDDs, analyzing the results and using a well defined interface
to add/remove devices from new-scsi-core tables (given capabilities).

SCSI scanning could be a kernel module or user space process, XOR both,
depening on how the user felt this morning.

>>Another feature is that new-scsi-core will *not* do any memory allocation
>>for sg lists for commands -- this is the task of the application client
>>(block layer, app, scanning code, etc).
> 
> 
> i.e. the scsi upper layer driver?

Whoever -- the application client... block layer, etc.  new-scsi-core
is not a memory management system, it's just an interface.  This will make
it quite *simpler and smaller*, yet powerful.

>>BTW, what kind of prototype are you talking about, functional or non-functional?
> 
> 
> limited functionality (i.e. just a single driver or so converted)

Time is of the essence and given I've got a lot of my own job-work do to
and catch up with (for which get payed), I'm not sure I can start this now.
I'd need to hear something from the powers that be.  Since this is 2.7 work,
I don't expect it until the summer.  And summer time is always more relaxed.

-- 
Luben

P.S. The naming punctuality comes from the fact that symbols themselves
carry meaning -- and a proper name or symbol would dictate its proper
use.  As an example I gave Newton's and Leibniz's calculus notations.
For more information one can check out any mathematical philosophy book
or as a start, the Pulitzer prize winner ``GEB''.



From: Luben Tuikov <luben@splentec.com>
Subject: Re: [RFC][PATCH] scsi-misc-2.5 software enqueue when can_queue reached
Date: Mon, 03 Mar 2003 17:40:59 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E63D9FB.1010602@splentec.com>
References: <20030228111924.A32018@beaverton.ibm.com> <3E627037.9060809@splentec.com> <20030303125254.A30662@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: linux-scsi@vger.kernel.org

Patrick Mansfield wrote:
> 
> The patch fixes the problem we currently have when the can_queue limit is
> reached, and helps move towards a per scsi_device queue_lock.

Yes, I saw that.  This is why I said ``deferred_cmd_q'', since those
are _deferred_ commands which _became_ *deferred* when the host couldn't
take them (can_queue).

> I coded it in with the idea of moving towards further separation of
> scsi_host versus scsi_device - for example, always decrementing host_busy
> when a command completes, but I'm not trying to address other general
> issues.

Well, you have to make up your mind -- addressing other issues is
inevitable when you want to plug a different approach-idea into
the old infrastructure.  (Kind of reminds me of those baby toys,
where the cube will never fit through the disk shape -- such a clever
toy. :-> )

> I'll rename the field to pending_cmd - it is a command that is pending
> for this host adapter, and just avoid the q vs queue postfix issue.

Ah, yes, sadly I see the [political] compromize -- I promize to
straighten this out with the source right after I finish this email.
In due time you're allowed free thinking. :-)

But isn't it a queue? Furhermore isn't it a queue of _deferred_
*by SCSI Core* commands, because the host command limit were hit?

Then wouldn't it *make sense* to call it ``deferred_q'' or
``deferred_cmd_q''?

Doesn't this just *make sense*?

I really dislike your choice of ``pending_.*'' as I've secretly
reserved it for the queue of commands pending execution status by
the device/LUN, i.e. submitted to the LLDD via queuecommand() --
in a future SCSI Core.  And, btw, this is what I have in my own
mini-scsi-core (incoming_q, pending_q, done_q, plus a few more) --
so, yes, I am biased. :-)  But I hope this is a good bias.

>>2. Just think about how much *easier* your patch would be
>>if SCSI Core had a ``incoming_cmd_q''?   You could just
>>enqueue at the front, while the request fn could enqueue
>>at the end.
> 
> 
> If we do that, for the current code if we never hit can_queue, then we
> would always add to the list and then immediately remove the same command
> from the list for further processing.

This is absolutely correct!  We do not want to buffer scsi commands
in SCSI Core, we just want to redirect and intercept them!

But, we want the *ability* to buffer, in such situations as when
a command queue limit has been reached, which your patch addresses.

But this gets more complicated, as you'll have to check with the
portal, or target or LU, for *what* the reason is that a command
queue limit has been reached!

It may be the case that you cannot afford to buffer commands,
but you'll have to terminate them immediately with CHECK CONDITION
status and an appropriate ASC and ASCQ codes.  Or if the error
was in the portal, it may be the case that you'll have to
return SERVICE DELIVERY FAILURE as service response... (in a new-scsi-core).

> It would be interesting to use a block request queue for sending commands
> to the host adapter, but that is beyond the scope of this patch.

Well, please don't forget that block commands are a special case.
SCSI Core should only work with scsi command structs, as more exotic
sources will send scsi commands directly to SCSI Core, to more exotic
devices (e.g. processors), in the future.
SG, is right now a special case of a general nature. :-)

So in the future, or a new SCSI Core, I see a general entry of
a sort ala-execute_scsi_command().

> The list_head is there because of how we are implementing the lists or
> queueing - we could create a list of scsi_cmnd's that does not require a
> separate field within scsi_cmnd.

Zzzzzzz..... What's new p... ? [Tom Jones :-) ]

(I know why list_head is used -- check linux-scsi archives for when I asked
that next, prev be eliminated for list_head...)

> We can combine the scsi_cmnd list_head pending with the eh_entry, if there
> is agreement that a smaller scsi_cmnd is worth the list_head overloading.

But why should ``a smaller scsi_cmnd'' struct be a driving force in
a queuing design?  This is *the* recipe for disaster!

What you want to say is that: We could combine ... into a single
list_head entry if the queueing design would be finalized in linux-scsi
for scsi core.

The thing is that I don't really see it [queueing design] changing at all,
now that we're so close to 2.6/3.0.

BTW, there is no such thing as ``list_head overloading''.  An entry
can be a member of only one list at a time.

> This is not a queue of commands for the host adapter to process, it is a
> queue of commands the host adapter will be sent in the future, so we are
> either on the queue, or not on the queue.

Uuuh, Logic 101.

But if the host will be sent those commands in the future, then
it will process those commands... :-)

IOW, I know this, Patrick.

What I dislike is that the command is ``either there or it's not''.
And I envision that a command is always a member of a list, depending on
it's state.  The advantage of this is that a thread can *catch up* with the
command to...

So you could have the request fn adding to incoming_q at the tail
*and* SCSI Core adding deferred commands at the front of the incoming_q
*at the same time* via a spin lock (irq), and then when its time
you get fairness *implicitly* since the enqueuing code will read from the
front! I.e. deferred commands first.

So this distinction which you write about can be consolidated with
just one queue -- incoming_q -- and then you don't need a second
argument to the dispatch fn.

> 
>>>-int scsi_dispatch_cmd(Scsi_Cmnd * SCpnt)
>>>+int scsi_dispatch_cmd(Scsi_Cmnd * SCpnt, int resend)
>>
>>
>>Oh, boy!
>>
>>More complication!  Why do you need to change the prototype
>>for the dispatch fn?  (Rhetorical.)
>>
>>Because the rest of the infrastructure of SCSI Core is not
>>up to date to your patch-idea?
> 
> 
> Slightly, but even so it nice to have some sort of priority for the
> scsi_cmnd, and a resend can imply higher priority.

Yes, it is nice to have priority, but not in such a ... way -- via
an added function parameter to tell from which queue we're to read...

> I generally do not like having two lists that we must flush, but I don't
> have a simpler idea that works within the context of the current code.

A-ha!  Now you're talking!

Oh, well, incoming_q comes to the rescue. :-)
Too late for this though.

-- 
Luben



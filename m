From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Discussion: soft unbinding
Date: Sat, 3 May 2008 16:42:39 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0805031556360.20050-100000@netrider.rowland.org>
References: <481C9F43.9040406@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:4389 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751707AbYECUml (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 3 May 2008 16:42:41 -0400
In-Reply-To: <481C9F43.9040406@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Matthew Dharm <mdharm-usb@one-eyed-alien.net>, Oliver Neukum <oliver@neukum.org>, USB Storage list <usb-storage@lists.one-eyed-alien.net>, SCSI development list <linux-scsi@vger.kernel.org>

On Sat, 3 May 2008, Stefan Richter wrote:

> Alan Stern wrote:
> > When talking about "soft" unbinding, the main question seems to be: How 
> > soft?
> > 
> > It would be easy, for instance, to change usb-storage so that unbinding
> > would wait until the current command was finished.  But clearly one
> > wants to do more: Give the upper-level SCSI drivers a chance to
> > shutdown cleanly and issue their FLUSH CACHE commands, wait for all
> > pending commands to complete, and so on.
> 
> scsi_remove_host is potentially able to do this, and unless my memory 
> betrays me, did so in the past.
> 
> > It's the "wait for pending commands to complete" part that is hard.  
> > Some commands have relatively long timeouts.
> 
> Is there reason to be less patient during soft unbinding?
> 
> If so, the decision which commands can be aborted should IMO be made by 
> the application layer.
> 
> > Error handler operations have no timeouts.  Commands submitted through
> > sg can have effectively infinite timeouts.
> 
> Hmm, I can't comment on these two.
> 
> > So how long should we wait?
> 
> I presume if a user launches a "remove safely" command, he means it.  Or 
> if he doesn't mean it, he still can hot-unplug before completion of the 
> shutdown procedures.  The only exception is a locked drive door or a 
> similar ejection mechanism which forces the user to wait for software 
> coming to terms.

That's probably true.  With USB at least, a hot unplug causes all 
outstanding I/O to fail immediately.

On the other hand, since unbinding involves acquiring the host 
adapter's device semaphore, it will block things like suspend.  So it 
would not be a bad idea to have a hard upper limit on how long it can 
wait.

> > Should there be a scsi_soft_remove_host() routine that accepts a
> > timeout value?  It would remove the devices under the host and wait
> > until the timeout expires (if necessary) before aborting all pending
> > commands.  Unlike scsi_remove_host(), it would really abort these
> > commands as though they had timed out, instead of simply cancelling
> > them.  It would guarantee that when it returned, no commands were still
> > running on the host and no more commands would be submitted.
> 
> It would be an API with more guarantees/ clearer semantics than 
> scsi_remove_host() and even also...
> 
> > This would essentially be a standardized version of the special code 
> > Stefan has put into the sbp2 and firewire-sbp2 drivers.
> 
> ...with more guarantees/ clearer semantics than the scsi_remove_device() 
> API which the SBP-2 drivers happen to use.  They use them merely because 
> this has been found to work more satisfyingly at some point, and they 
> don't have difficulties to use this API (i.e. look up the logical units 
> to feed to scsi_remove_device()).

Deciding on the timeout value to use is the hard part.  Or even whether 
there should be a timeout at all.

> Curious; scsi_mid_low_api.txt says in the context of scsi_remove_host:
> 
>      When an HBA is being removed it could be as part of an orderly
>      shutdown associated with the LLD module being unloaded (e.g. with
>      the "rmmod" command) or in response to a "hot unplug" indicated by
>      sysfs()'s remove() callback being invoked. In either case, the
>      sequence is the same [...]

Yeah, well, it also says in the description of scsi_remove_host:

	Returns value: 0 on success, 1 on failure (e.g. LLD busy ??)

So you can't rely on the documentation being up-to-date.

> while it says in the context of scsi_remove_device:
> 
>      In a similar fashion, an LLD may become aware that a SCSI device has
>      been removed (unplugged) or the connection to it has been
>      interrupted. [...] An LLD that detects the removal of a SCSI device
>      can instigate its removal from upper layers with this sequence [...]
> 
> AFAIR scsi_remove_host once simply worked just as if the LLD itself 
> called scsi_remove_device() for each device on that host beforehand. 
> Eventually there was a change in the SCSI core internal state model 
> which reduced what scsi_remove_device(), when called internally from 
> within scsi_remove_host(), was able to do.  This is contrary to the text 
> quoted above.  I haven't tested for some time now how the SCSI core 
> behaves right nowadays.
> 
> Back to scsi_soft_remove_host():
> 
> Does the SCSI core actually need separate APIs for soft unbinding 
> (a.k.a. orderly shutdown) and hot removal?  We surely have different 
> requirements in both cases:  Give pending commands some time to finish 
> and send some finalizing commands (e.g. synchronize cache, unlock door) 
> in the shutdown case, fail all commands and stop any error retries in 
> the hot unplug case.
> 
> But isn't hot unplug just a special case of orderly shutdown --- 
> basically a case where the transport driver's responsibility is to fail 
> commands (pending ones and new ones) quickly?  In addition, fail them 
> with failure indicators which tell upper layers that it is no use to 
> retry them.

That's right.

> Actually, quick failure and suppression of retries in the hot unplug 
> case is IMO not even as critical as the proper execution of pending and 
> finalizing commands in the soft unbinding case.  The only critical 
> aspect of hot unplug is that IO terminates eventually, i.e. applications 
> don't hang.
> 
> So, rather than adding a scsi_soft_remove_host API, wouldn't it be 
> appropriate and possible to make sure that
> 
>    - scsi_remove_host is able to initiate and perform soft unbinding,
> 
>    - LLDs return proper failure codes in the hot unplug case, and SCSI
>      core and upper layers properly interpret them i.e. don't initiate
>      futile retries.

These ideas have not escaped me.  There's really no reason to have a 
separate API for hot unplug at all; the soft unbind sequence would work 
perfectly well (assuming that I/O fails immediately, as it does with 
USB).

No, the reason I suggested a separate new API is because of the bizarre 
way scsi_remove_host() handles -- or used to handle -- outstanding 
commands.  The midlayer would cancel them all by itself, without 
telling the LLD or doing anything else.  There's special code in 
usb-storage to work around this, possibly in other LLDs as well.  I'm 
afraid that changing the midlayer's behavior would cause some LLDs to 
malfunction in this regard.


The last time I looked at this stuff was back in 2004.  This email 
thread may be interesting:

	http://marc.info/?t=109644432800002&r=1&w=2

Of course the midlayer has changed since then (scsi_host_cancel no 
longer exists), so it may not be relevant any more.

Of even more interest and relevance is this thread:

	http://marc.info/?t=109630920600005&r=1&w=2

In one of the messages in that thread, James Bottomley wrote:

------------------------------------------------------------------------
Right.  scsi_remove_host tells the mid-layer that it's OK to trash all
inflight commands because you removed all their users before calling
it.  It also tells us that you won't accept any future commands for this
host (because you'll error any attempt in queuecommand).
------------------------------------------------------------------------

Later on Mike Anderson asked:

------------------------------------------------------------------------
Clarification. James, are you indicating that there needs to be a new
scsi mid api that performs similar function to scsi_remove_host expect
does not cancel commands?
------------------------------------------------------------------------

There was no real answer and things were left hanging.

So I guess part of what I'm asking is whether the situation is now 
significantly different.

Alan Stern


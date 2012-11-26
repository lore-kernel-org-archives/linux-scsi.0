From: James Smart <James.Smart@emulex.com>
Subject: Re: Error handling on FC devices
Date: Mon, 26 Nov 2012 17:32:10 -0500
Message-ID: <50B3EDEA.40008@emulex.com>
References: <50AA290F.8000105@suse.de>
Reply-To: <James.Smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.ext.emulex.com ([138.239.224.100]:30629 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932194Ab2KZWcN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Nov 2012 17:32:13 -0500
In-Reply-To: <50AA290F.8000105@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Chad Dupuis <chad.dupuis@qlogic.com>, James Bottomley <James.Bottomley@HansenPartnership.com>


On 11/19/2012 7:41 AM, Hannes Reinecke wrote:
> Hi all,
>
> just when we thought we'd finally nailed the error handling on FC ...
> A customer of ours recently hit this really nasty issue:
> He had a 'drain' on the SAN, in the sense that the link was still 
> intact, but no commands were coming back from the link.
>
> This caused the FC HBA / driver to not detect a link down, and so the 
> failing command was pushed onto the error handler.
> Which of course resorted back to HBA reset, but by that time the 
> cluster already had kicked out the machine.
> And as all machines in the cluster were connected to the same switch 
> this happened to all machines, resulting on a nice cluster shutdown. 
> And a really unhappy customer.
>
> Looking closer multipathing actually managed to detect and switch 
> paths as desired, but as the initial failing command was pushed onto 
> the error handler all applications had to wait for this command to 
> finish before proceeding.
>
> So the following questions:
> - Why did the FC HBA not detect a 'link-down' scenario?
>   (Incidentally, this happens with QLogic _and_ Emulex :-)
>   I know this is not a typical link-down, but from my naive
>   assumption the HBA should detect that commands are not
>   making progress, and at least after RA TOV was expired
>   it should try to reset the link.

Link up/down is almost always the state of the physical link - TX signal 
is active, and on RX side, we have negotiated speed and acquired sync, 
and are seeing valid characters.  It has nothing to do with the packet 
transmission on the link which is a different story.  There is, within 
the FC std, tracking of credits vs the link, which could reset it 
(although, it's reset, and yours may be a different definition).  So as 
long as the other end kept it's link up, and we saw valid characters - 
the link is fine.

 From the SCSI perspective - there are no requirements about how long a 
command takes (consider format commands - which could take hours between 
the cmd and the response). There is no definition about "making 
progress" that can be enforced.  We have the i/o timers - which usually 
have defaults of 30s/60s/90s by default. R_A_TOV (10s) is too short vs 
these - especially when considering some transparent failover arrays (2 
pieces of hardware, both on the link, but only 1 responding - and after 
one fails, the other takes over the others personality, taking about 90s 
to do so, and resuming the i/os from the new hardware; during this 
entire time there may be no traffic, for much of this window and it's 
still "good").  Additionally, there is no requirement that all targets 
be in use at all times - you could come up with a situation where 1 
target is influencing the link activity decision, thus invoking the link 
bounce, and disrupting i/o load on other targets that are fine. Low 
probability, but possible.

In general, lack of activity is a good indicator, but that's it, only an 
indicator. Not great for a hard policy "choice".  Also, you're asking 
low-level designs to now do something new (time inter-i/o gaps, and 
aggregate gaps), which they may not be prepared to do so.

> - Can we speed up error handling for these cases?
>   Currently we're waiting for eh to complete before returning
>   the affected commands with a final state.
>   However, after we've done a LUN reset there shouldn't be
>   any command state left and we should be able to terminate
>   outstanding commands directly, without having to wait for
>   eh to finally complete. James?

Theoretically, I agree - the affected command only has to stall long 
enough to ensure its own cancellation, which could be just the io abort. 
True, if the abort is not successful, then you still don't know the 
status, so you have to escalate the type of recovery to try to cancel, 
etc.  I expect, given the limbo state of the i/o on lower eh failures, 
you do have to wait to ensure it's "cancelled", at least from a generic 
scsi point of view.  You could try to optimize the local system view - 
where as long as the LLDD ensures it's cancelled, and will protocol-wise 
ensure no bad side effects, then you could release it earlier in the eh 
escalation. I don't believe we have a way for the LLDD to give such a 
notice to the midlayer. Given all the grey areas you touch on, 
especially across different types of scsi protocols and hardware, it 
doesn't surprise me we are waiting until we have confirmation of 
cancellation before continuing.

Given path switching is somewhat separate from the i/o, would it better 
to send a notification of a path-fail condition as part of the eh, 
rather than hinging it on the individual i/o.  Yes, the i/o is still in 
limbo and can't be switched to the new path, but other i/o could without 
incurring the delay.

-- james s

>
> Thanks.
>
> Cheers,
>
> Hannes


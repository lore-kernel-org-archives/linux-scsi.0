From: Luben Tuikov <luben@splentec.com>
Subject: Re: [PATCH / RFC] scsi_error handler update. (1/4)
Date: Tue, 11 Feb 2003 14:05:27 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E494977.1070706@splentec.com>
References: <20030211081351.GA1368@beaverton.ibm.com> <3E492992.90502@splentec.com> <20030211172256.GC3164@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: linux-scsi@vger.kernel.org

Mike Anderson wrote:
> 
> I could change the name.
> 
> I wanted a list just for the error handler I was concerned in the
> timeout (cancel cases) that until ownership was reclaimed that I did not
> want to risk modification of another scsi_cmnd list_head. We should be
> protected by the scsi_done scsi_delete_timer so I could possibly use the
> other list head.

Yes, I see the predicament.

I also wanted to make note as to the choice of names of variables.
This is very important, not so much judging from kernel use, but in
general.  I've been known to change my var names over 10 times until
they've gotten to represent *and* mean what they represent and mean.
I.e. their usage == their name as close as possible.

E.g. this is why we use Leibniz's calculus notation rather than
Newton's.  Sorry for the example, but this is my background.
I.e. symbols carry out meaning in and of themselves.

In fact cmd_list is actually a cmd_q (cmd queue) and eh_cmd_list
is actually eh_cmd_q.  Since both are ordered lists of commands by
arrival time.  And will soon become priority queues when SCSI Core
gets up to date with sending down HOQ (Head Of Queue) commands,
as per SAM-2/3.  It would be nice if someone renamed those...

(back to linux-scsi :-) )

> A command becomes a member of the eh_cmd_list:
> 	- If a scsi_cmnd times out.
> 	- A call to scsi_set_device_offline with scsi_cmnds active.
> 	- A command completes with DID_TIME_OUT and is not a TUR or
> 	  Inquiry.
> 	- A command completes with message byte of != COMMAND_COMPLETE.
> 	- A few other cases in scsi_decide_disposition. I will document
> 	  them.
> 
> A command is removed from this list when:
> 	- Legacy request sense is done.
> 	- Abort was successful.
> 	- A function in the sequence done by scsi_eh_ready_devs is
> 	  successful.

Aaah, very nice.  This should be documented in the code.

Here is some comments (this means that they are comments, just that,
they don't mean that this is necessarily how I want things to be or
that I think it would be a better design... it may be worse -- the
point is to expand the brainstorm pool).

1. Is it possible that when a command times out, or when the application
client sends ABORT_TASK TMF (future), the eh thread wakes up and calls the driver's
abort function, without actually shutting down queueing or any other workings
of the host/driver/device?  Then let the LLDD cancel this command, all the while
the rest of the things can go on.

2. If the device is set off line, then there would be no point in moving
the commands from the cmd_list to eh_cmd_list, since cmd_list _becomes_
eh_cmd_list by the nature of the state of the device.

1 and 2 would mean that we don't really need the eh_cmd_list. (we do
in a different context...)

3. Why are TUR and INQUIRY treated differently on timeout?

4. If a command ``returns'' from a LLDD, and has in the message
byte something of the sort ``task not complete'' this almost
certainly means Service Response of SERVICE DELIVERY OR TARGET FAILURE.

In this case SCSI Core now owns the command and it should bubble up
to the application client and/or cancel the *other* queued commands
and/or fire a hot plug event.

In fact I've wanted for a long time a service_response byte in cmd struct
and status byte as per SAM-2/3.  This would make things so much easier
for SCSI Core.  All LLDDs would need tweaking but it is not that bad.

What are your thoughts that queuecommand() become void queuecommand()?
I.e. the only way a command is given ownerhip to a LLDD is via
queuecommand() and the only way a command is given back to SCSI Core
is via a call to scsi_done()?

Side-side comments:

I saw your done_list -- nice name.  What it the story with this list?

-- 
Luben



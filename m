From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH / RFC] scsi_error handler update. (1/4)
Date: Tue, 11 Feb 2003 13:14:47 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030211211447.GB1114@beaverton.ibm.com>
References: <20030211081351.GA1368@beaverton.ibm.com> <3E492992.90502@splentec.com> <20030211172256.GC3164@beaverton.ibm.com> <3E494977.1070706@splentec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3E494977.1070706@splentec.com>
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben@splentec.com>
Cc: linux-scsi@vger.kernel.org

Luben Tuikov [luben@splentec.com] wrote:
> 1. Is it possible that when a command times out, or when the application
> client sends ABORT_TASK TMF (future), the eh thread wakes up and calls the 
> driver's
> abort function, without actually shutting down queueing or any other 
> workings
> of the host/driver/device?  Then let the LLDD cancel this command, all the 
> while
> the rest of the things can go on.
> 

I have looked at this and for the case where abort cannot fail it
looks like we could handle that, but when it does a recovery sync point
is needed to ensure we do not create a recovery storm with independent
aborts going to the next level of recovery.

	1.) Abort a cmd (effects scsi_cmd).
	2.) LUN reset (effects scsi_device).
	3.) Bus Device Reset. (effect same target siblings).
	4.) Bus reset (effect my_devices).
	5.) host reset (effect my_devices and ??).

> 2. If the device is set off line, then there would be no point in moving
> the commands from the cmd_list to eh_cmd_list, since cmd_list _becomes_
> eh_cmd_list by the nature of the state of the device.
> 

True, but since I kept the error handler behavior similar to what it is
today we may have more that one scsi_device worth of work to do so
having a queue of work per eh seems more efficient for the eh to process.

> 1 and 2 would mean that we don't really need the eh_cmd_list. (we do
> in a different context...)
> 
> 3. Why are TUR and INQUIRY treated differently on timeout?
> 

I believe this is a historical optimization for scanning. 

> 4. If a command ``returns'' from a LLDD, and has in the message
> byte something of the sort ``task not complete'' this almost
> certainly means Service Response of SERVICE DELIVERY OR TARGET FAILURE.
> 
> In this case SCSI Core now owns the command and it should bubble up
> to the application client and/or cancel the *other* queued commands
> and/or fire a hot plug event.
> 
> In fact I've wanted for a long time a service_response byte in cmd struct
> and status byte as per SAM-2/3.  This would make things so much easier
> for SCSI Core.  All LLDDs would need tweaking but it is not that bad.
> 

I was not thinking this broad of change this morning, but when I typed the
comments on when cmds would be added to the eh list based on the result
of the message byte it looked like we could use finer grain decoding /
action.

> What are your thoughts that queuecommand() become void queuecommand()?
> I.e. the only way a command is given ownership to a LLDD is via
> queuecommand() and the only way a command is given back to SCSI Core
> is via a call to scsi_done()?
> 

I think this would be a good direction to head. I would like to hear
from LLDD writers, but it should provide a more consistent interface. In
looking at a few LLD eh handlers there is some holes that if a command
already completed the handler will return failure (believing that the
mid should already know this), but there is no code currently to let the
error handler know causing more severe error handling steps to take
place. This code can be fixed, but if every command had to come though
scsi_done once queuecommand was called it would remove code assumption
on ownership.

> Side-side comments:
> 
> I saw your done_list -- nice name.  What it the story with this list?

Since the error handler can have a mix of work on its queue when woken
up this is a list that holds scsi cmnds that have been processed by the
error handler. In theory some cmnds could have needed canceled and others
are needing a (device recovery / tur / online verification) steps. 

The done list is then flush "disposition-ed" prior to the error handler
sleeping. This gives the previous behavior that no commands are released
from the error handler until completion.

-andmike
--
Michael Anderson
andmike@us.ibm.com


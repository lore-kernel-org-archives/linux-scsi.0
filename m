From: Luben Tuikov <luben@splentec.com>
Subject: Re: [PATCH / RFC] scsi_error handler update. (1/4)
Date: Wed, 12 Feb 2003 15:10:39 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E4AAA3F.8040002@splentec.com>
References: <20030211081351.GA1368@beaverton.ibm.com> <3E492992.90502@splentec.com> <20030211172256.GC3164@beaverton.ibm.com> <3E494977.1070706@splentec.com> <3E495862.3050709@splentec.com> <20030211212048.GC1114@beaverton.ibm.com> <3E49698D.3030402@splentec.com> <20030211224119.A23149@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Mike Anderson <andmike@us.ibm.com>, linux-scsi@vger.kernel.org

Christoph Hellwig wrote:
> On Tue, Feb 11, 2003 at 04:22:21PM -0500, Luben Tuikov wrote:
> 
>>:-)  yes, I know -- I was just saying that I don't like this policy
>>that much.
>>
>>It's an oxymoronic to grab a spin lock and say to someone, ok
>>you can sleep, and then release the spin lock...
> 
> 
> Agreed.  One of the things we really need to do is to change the calling
> conventions of the eh methods to not have the lock held on entry.
> 
> I just wonder how we can archive that best without silently breaking
> drivers.

First we have to figure out *what* is the purpose of having the lock
held before calling eh_* functions.  Is it protecting the driver
from something or is it protecting SCSI Core?

Since the point of having a thread eh is to *sleep*, then why
grab the lock...

(Needless to say in my own LLDDs I *never* need this lock -- all
eh_* and queuecommand() are completely re-entrant.)

That is, eh_* functions of a LLDD should be re-entrant.

While we are this I'd like to give this idea to you, which I've
mentioned before (this will be kind of more formal):

Proposal A: Let's make queuecommand() be void queuecommand().

This will accomplish the following:
	- the only way SCSI Core gives ownership of a scsi command
	structure to a LLDD is by calling queuecommand() -- which
	is currently the case as well.

	- the only way a LLDD gives ownership back to SCSI Core is
	by calling scsi_done(), and let there be *no* other way.

I completely detest the current dualist approach of also checking
the return value of queuecommand().

This will warrant the addition of the old res = queuecommand()
result variable, into the scsi command structure.

Now we can call this member ``service_response'' and this will
be the Service Response of the Service Delivery Subsystem, aka
Low Level Device Driver (LLDD). ((FC folks should back me up here.))

And ``result'' could become ``status''.

Both of the above are in par with SAM-2/3.

This will accomplish the fact that there'd be only one place
where a command is returned to SCSI Core from a LLDD, specifically
in the scsi softirq.  I.e. the queueing method as far as LLDDs
are concerned is clearly defined.

Then SCSI Core can get more inventful in its own queuing techinques.

I think that the above proposal can go into 2.5, with a little
(minimal) tweaking of LLDDs and SCSI Core.

As to the eh_* routines:  The current naming technique follws SPI,
which is now out of SAM and SPC.  Furthermore newer SCSI devices,
not necessarily on a parallel interface, do not define bus_reset,
host_reset and sometimes device_reset, because it is not
always clear what is the device or host or bus...

Proposal B: let the eh_* become tmf_* where TMF is
Task Management Functions.  Those are from SAM-2/3 (all re-entrant):

int tmf_abort_task(scsi command pointer);
	aborts the task sent from this initiator port,
	the LLDD will determine the initiator port.
int tmf_abort_task_set(target, lun);
	aborts all tasks sent from this initiator port,
	like sending multiple tmf_abort_task(...).
int tmf_clear_aca(target, lun);
int tmf_clear_task_set(target, lun);
int tmf_lun_reset(target, lun);
int tmf_query_task(scsi command struct);
int tmf_target_reset(target);
int tmf_wakeup(target);

Some of those are optional and depend on the functionality of the
device. Others depend on the transport.

The result of the function is the service response which is one of:
{ TMF_COMPLETE, TMF_SUCC, TMF_REJ } and Service delivery or target failiure.

I think that this framework will also be very convenient for the USB
people, since they will not define all of those, but the ones they will
define, they can map easily to their own USB infrastructure.

``target'' is a target identifier (type not known at this point).
``lun'' is a 64 bit quantity.

All those methods are to be re-entrant and a command could be cancelled
all the while the LLDD continues to process commands.  (I've done
this myself.)  This would warrant a bit different queueing technique
in SCSI Core but slowly we're getting there.

Maybe this is 2.7 stuff, but as long as ideas are popping up, we're doing
okay.

-- 
Luben



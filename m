From: Luben Tuikov <luben@splentec.com>
Subject: Re: 2.5.59-dcl2
Date: Wed, 29 Jan 2003 13:05:12 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E3817D8.4070300@splentec.com>
References: <20BF5713E14D5B48AA289F72BD372D680211AA4F@AUSXMPC122.aus.amer.dell.com> <20030129065158.GA1758@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: linux-scsi@vger.kernel.org

Mike Anderson wrote:
>>
>>The scsi mid-layer shouldn't free a command that hasn't actually been
>>aborted/reset because it *could* come back from the firmware after the
>>timeout has expired, and the driver has a reference to it (need
>>refcounting...)  This could potentially lead to an exhaustion of the command
>>pool though, if a command *never* comes back.
>>
> 
> 
> This is bad to return the command if the eh cannot cancel it from
> the LLDD. Then again the eh routines provided by the driver are not very
> useful. We could change the error handler to mark cmds that have and
> have not been canceled and then at the end do something with the
> un-canceled ones. The do something is unclear.

1. Right, if the eh_abort_handler() (read: eh_cancel_command())
could *not* complete cancellation of the command, SCSI Core
should *not* repossess it.

OTOH, after successfull eh_device_reset() (use your imagination: UYI),
or eh_host_reset() (again UYI), LLDD is in its full right to *repossess*
all pending LLDD status commands. (See bottom of text.)

2. There are two ways to implement object states.  One is to ``mark them''
via an object variable which represents the state and the other is to
use containers* /representing/ the different states.

* Queues, lists, etc.

The first method is quite, quite trivial and worth no discussion except
to mention that it just adds more cruft to the object itself.

The other is what would normally be implemented in any self respecting program,
and has many, many advantages, e.g. one can use a priority queues, on top of it
being a state queue, etc.

For this reason what you'd want to do is use a per device variable
	struct scsi_device::struct list_head lost_cmds;
where
	struct scsi_cmnd::struct list_head list;    /* scsi_cmnd participates in queue lists */
is hooked. (The comment is copied verbatim from my patches, now in scsi-combined-2.5.)

When a command couldn't be cancelled (eh_* returned failure), you *could* move
the command into that queue and make SCSI Core be aware of it, e.g. when freeing
the device.  I said ``could'' since this is a policy issue and will have to be
decided by more than one knowlegable scsi developer of linux-scsi.

As to LLDD: after ABORT TASK TMF, no further responses should be sent from
the target device to the initiator port regarding that task.  The initiator port
is the LLDD or SCSI Core *if* LLDD does its own queuing.  ((Strictly speaking
the Initiator Port is always the LLDD, but if it does its own queuing it will have
to notice the ABORT TASK TMF.)) What this means is that SCSI Core *can* make some
assumptions.

-- 
Luben




From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: Q: aborting commands
Date: Tue, 15 Oct 2002 15:25:11 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021015222511.GG1049@beaverton.ibm.com>
References: <3DAC7F2F.AA9348F7@splentec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3DAC7F2F.AA9348F7@splentec.com>
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben@splentec.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>


Luben Tuikov [luben@splentec.com] wrote:
> I've been meaning to ask this for some time now:
> What is the consensus on the meaning of an aborted command?
> 
> Most notably in the SCSI LLP standards, a successfully aborted command
> will NOT return status as non-aborted commands would (normally) do.
> 
> 1. Should successfully aborted commands call scsi_done()?
>    (of course with result=DID_ABORT)
The new eh on calling eh_abort_handler on a cmd believes that it is the
owner of the command again.

I also noticed an issue in our current error handling in that if call
eh_abort_handler we may want to call eh_device_reset_handler on the
device later in recovery. The issue is that it at least one
implementation by a LLDD this is a either / or case not a progressive
step of error recovery.

> 
> >From the point of view of:
> Sometimes, a SCSI LLDD can reply with SUCCESS to a command abortion,
> BUT the scsi_cmnd structure, including the sg lists may NOT be freed
> right away, that is, until later time when the driver can get around
> to it to actually yank out/free its own resources, etc. (This is especially
> true in queuing models when the command has been submitted to another
> entity (HW/SF) which also operates on a similar queueing model.)
> Then the SCSI LLDD can notify SCSI core that all its (SCSI core's) memory
> is free by calling scsi_done() with DID_ABORT set -- the mid layer
> would know what has happened and will reuse/reissue/etc the command.
> 
> I do realize that the above IS a two-edged sword in many respects, I just
> rambled it just to show another point of view, aside the one taken
> by SCSI LLP (transports/interconnects).
> 
> 2. Can/Should/Must SCSI core assume that a _successfully_ aborted command
>    did NOT make it to the medium?
> 

How could a LLDD know where the error occurred on a timeout. Take FC for
example the problem could be a dropped response IU (with device
completing the cmd) or a class 3 data frame dropped in the middle.

> This would be especially useful to UL beasts like journalling FSs, databases,
> etc.
> 
> I think that if the device supports it, when SUCCESS has been returned, this
> should also mean that the command did NOT make it to the medium. (This would
> also make it consistent to the semantics of aborting a command.)
> 
> Of couse ``medium'' may just mean some cache/buffer on the lowest point
> of the physical device (or whatever the manuf. decided to muster up), but
> should nevertheless mean that a READ on the media should give consistent
> results with aborting the command not making it to the media.

-andmike
--
Michael Anderson
andmike@us.ibm.com


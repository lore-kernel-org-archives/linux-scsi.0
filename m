From: Luben Tuikov <luben@splentec.com>
Subject: Q: aborting commands
Date: Tue, 15 Oct 2002 16:48:47 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3DAC7F2F.AA9348F7@splentec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from splentec.com (canoe.splentec.com [209.47.35.250])
	by pepsi.splentec.com (8.11.6/8.11.0) with ESMTP id g9FKmjf27497
	for <linux-scsi@vger.kernel.org>; Tue, 15 Oct 2002 16:48:45 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

I've been meaning to ask this for some time now:
What is the consensus on the meaning of an aborted command?

Most notably in the SCSI LLP standards, a successfully aborted command
will NOT return status as non-aborted commands would (normally) do.

1. Should successfully aborted commands call scsi_done()?
   (of course with result=DID_ABORT)

>From the point of view of:
Sometimes, a SCSI LLDD can reply with SUCCESS to a command abortion,
BUT the scsi_cmnd structure, including the sg lists may NOT be freed
right away, that is, until later time when the driver can get around
to it to actually yank out/free its own resources, etc. (This is especially
true in queuing models when the command has been submitted to another
entity (HW/SF) which also operates on a similar queueing model.)
Then the SCSI LLDD can notify SCSI core that all its (SCSI core's) memory
is free by calling scsi_done() with DID_ABORT set -- the mid layer
would know what has happened and will reuse/reissue/etc the command.

I do realize that the above IS a two-edged sword in many respects, I just
rambled it just to show another point of view, aside the one taken
by SCSI LLP (transports/interconnects).

2. Can/Should/Must SCSI core assume that a _successfully_ aborted command
   did NOT make it to the medium?

This would be especially useful to UL beasts like journalling FSs, databases,
etc.

I think that if the device supports it, when SUCCESS has been returned, this
should also mean that the command did NOT make it to the medium. (This would
also make it consistent to the semantics of aborting a command.)

Of couse ``medium'' may just mean some cache/buffer on the lowest point
of the physical device (or whatever the manuf. decided to muster up), but
should nevertheless mean that a READ on the media should give consistent
results with aborting the command not making it to the media.

?
-- 
Luben

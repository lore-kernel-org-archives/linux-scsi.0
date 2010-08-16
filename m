From: Alan Stern <stern@rowland.harvard.edu>
Subject: When should sd runtime-suspend a drive?
Date: Mon, 16 Aug 2010 17:55:40 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1008161721120.1688-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:55320 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754797Ab0HPVzl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Aug 2010 17:55:41 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Oliver Neukum <oliver@neukum.org>, SCSI development list <linux-scsi@vger.kernel.org>

James and everyone else at linux-scsi:

The runtime-PM implementation currently in sd.c is mostly a
proof-of-principle.  It's there to show that the code works okay, but
it's not all that useful yet.  The real problem is deciding when a
drive should be powered down.

>From the point of view of USB mass-storage devices, the most pressing
need for runtime PM lies with card readers.  Lots of computers have
them and most of the time there's no card inserted, yet they continue
to use energy.  It would be great if they could be powered-down
automatically.

Right now I can list four different classes of devices we might like to 
suspend while the system is running:

	(1) Rotating disk drives,

	(2) Solid-state (flash) drives,

	(3) Drives with removable media,

	(4) Buggy card readers.

Entry (4) refers to the fact that lots (probably most) USB card readers
lose track of whether or not a card is inserted when they are powered
down.  Upon returning to full power, if a card is present they always
report a media change -- even if the card was there all along.  As a
result, these devices should be suspended only when there is no medium.

(1) and (2) can be treated more or less the same, as far as I can see,
except that the idle timeouts for suspend will differ by orders of
magnitude.  A rotating disk shouldn't be spun down unless it has been
idle for minutes, whereas a flash drive can go into and out of
low-power mode in a fraction of a second.  (3) may or may not benefit 
from special treatment when there is no medium; I'm not sure of the 
best approach.

It's not easy for sd to tell which class a particular device falls
into.  In the end we may have to rely on guidance from the user,
particularly since the idle timeout has to be set by the user in any
case.

First question: Should there be any scheme for runtime-suspending 
drives based on considerations other than idle time and media present?  
For example, should we care about whether the device file is currently 
open?


If a drive is suspended, it has to be brought back to full power
automatically when a command is ready to be executed.  Changing power
states requires a process context, so it can't be done as part of
sd_prep_fn or anything like that.  Fortunately the PM core provides a
workqueue for asynchronous runtime PM; the trick is to use it properly.

Second question: What's the right way to delay processing of requests
until the device is back to full power?  There's a bunch of stuff in
scsi_lib.c dealing with request-queue handling, and I don't have a
clear enough picture of how it all is meant to work.

Thanks for any suggestions...

Alan Stern


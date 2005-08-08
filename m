From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: Synchronizing scsi_remove_host and the error handler
Date: Tue, 09 Aug 2005 01:59:09 +0200
Message-ID: <42F7F1CD.3080600@s5r6.in-berlin.de>
References: <Pine.LNX.4.44L0.0508081818131.4470-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:10909 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S932368AbVHIAAG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 8 Aug 2005 20:00:06 -0400
In-Reply-To: <Pine.LNX.4.44L0.0508081818131.4470-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, Mike Anderson <andmike@us.ibm.com>

Alan Stern wrote:
> The current code does use
> down_*_trylock, and it does check the device state for
> disconnect-in-progress.  If things don't work out, it sleeps
> for a short while and then tries again.

I think the error handler should rather give SUCCESS back to
scsi if it knows the device was or is being disconnected.

After that, commands would be enqueued again, and these
commands would be immediately done() with an appropriate
result code.

IMO the error handler should return SUCCESS rather than
FAILED because, if the device is diconnected, there is
simply nothing left to do that could advance recovery
from error. Retries (in the error handler) will not help
with error recovery either. Or do you retry in hope that
the device might be reconnected and then a device reset
should happen?


A more general thought: It appears from the example you
explained that maybe the USB highlevel carries too much of a
burden to watch out for concurrency. Tasks like to mutually
exclude port resets and disconnects --- which seems to me to
be a task unspecific to highlevel protocols, correct me if
I'm wrong --- might be better moved into the USB core. Then
the highlevel would have to worry less about how exactly to
avoid races and deadlocks, only about _what_ to do if there
is a conflict. (The kind of conflict should be indicated by
the core by means of return values or status flags or the
like.)

But I am of course speaking without any knowledge about USB
and Linux' USB stack.
-- 
Stefan Richter
-=====-=-=-= =--- -=--=
http://arcgraph.de/sr/

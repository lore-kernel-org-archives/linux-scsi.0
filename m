From: Alan Stern <stern@rowland.harvard.edu>
Subject: SK = 4: Non-recoverable doesn't mean non-retryable
Date: Fri, 10 Jun 2005 11:18:12 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0506101111240.4975-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:60631 "HELO
	iolanthe.rowland.org") by vger.kernel.org with SMTP id S262566AbVFJPSQ
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Jun 2005 11:18:16 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>
Cc: Pat LaVarre <p.lavarre@ieee.org>

Throwing more fuel onto the discussion of whether SK = 4 ("non-recoverable
hardware failure") commands should be retried, here are some comments from
Pat LaVarre, a long-time SCSI hardware developer (originally posted to the
linux usb-storage mailing list):


--------------------------------------------------------------------------

SK 4 is supposed non-retryable by whom?  And why?

I ask because I've heard elsewhere of hosts that switch on SK to decide 
to retry or not.  Thinking as a device, that's plain crazy.

As a device, I never want to trust the host to retry.  I'll fail a 
request only if I must.  For example:

a) I discover a write error after I reuse the RAM that was buffering 
that data.
b) I discover a read error after passing wrong data back thru to the 
host.
c) I'm running in a mode that values thruput over reliability.
d) The request has set reserved bits.
e) etc.

If I must fail, then the only way to discover if a retry helps is to 
burn the time it takes to send one, so far as I know.

I guess I see the Linux host as patched now more closely mirrors this 
conventional device thinking.  I think the Linux default is now 
becoming retry for SK 4, as the default should be for all SK:

> +		sdev->retry_hwerror = 1;

But I'm curious to learn more of the original misconception, and why it 
propagates, on the host side.

Whoever first thought that an SK code could mean do not retry, and why 
did they think that, and is there anything we can do to stop that 
pernicious slander against SK codes?

Curiously yours, Pat LaVarre

P.S. I notice the English of s2-r10l.pdf could mislead this way, if we 
read SK 3 and SK 4 without reading SK 1.  In that lack of context, we 
could think the passive English "non-recoverable" could mean not 
recoverable by the system.  In context, that passive construct more 
clearly means not recoverable by the device, therefore should be 
retried by the host.  Mind you, even if we read SK 4 alone, we're 
specifically reminded parity errors may cause SK 4, and surely 
"everybody knows" parity errors should be retried?

/// page 164 of 502
/// "Table 69" "Sense key (0h-7h) descriptions"

1h RECOVERED ERROR. Indicates that the last command completed 
successfully with some recovery action performed by the target. Details 
may be determinable by examining the additional sense bytes and the 
information field. When multiple recovered errors occur during one 
command, the choice of which error to report (first, last, most severe, 
etc.) is device specific.

...

3h MEDIUM ERROR. Indicates that the command terminated with a 
nonrecovered error condition that was probably caused by a flaw in the 
medium or an error in the recorded data. This sense key may also be 
returned if the target is unable to distinguish between a flaw in the 
medium and a specific hardware failure (sense key 4h).

4h HARDWARE ERROR. Indicates that the target detected a nonrecoverable 
hardware failure (for example, controller failure, device failure, 
parity error, etc.) while performing the command or during a self test.

--------------------------------------------------------------------------


In the light of these comments, does it make sense to retry SK = 4 always?

Alan Stern


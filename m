From: Nathan Bryant <nbryant@optonline.net>
Subject: Re: Incorrect response to SK/ASC/ASCQ = x 02/04/01 (becoming ready)
Date: Mon, 23 Aug 2004 12:05:12 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <412A15B8.2050909@optonline.net>
References: <Pine.LNX.4.44L0.0408221154220.15992-100000@netrider.rowland.org> <412A08D9.7020502@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pegasus.allegientsystems.com ([208.251.178.236]:10257 "EHLO
	pegasus.lawaudit.com") by vger.kernel.org with ESMTP
	id S265978AbUHWQFN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Aug 2004 12:05:13 -0400
In-Reply-To: <412A08D9.7020502@adaptec.com>
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, SCSI development list <linux-scsi@vger.kernel.org>, "Mike R." <turbanator1@verizon.net>

Luben Tuikov wrote:

> If the queue is a _general_ SCSI queue on which _any_ kind of
> SCSI command can be queued to the LU/target (i.e. not necessarily
> medium access), then you must _not_ block it.  HOQ task attribute
> commands could be sent which may operate other components of the
> LU/target.

Since we know that START STOP UNIT is unreliable...

Maybe the solution, then, instead of blocking, is to do something 
similar to quiesce, wherein we block normal user-initiated medium access 
but allow special requests. (?)

Not sure what an HOQ task attribute command is. Where in the t10.org 
specs should I look for a definition of that?

> 
> But you should block the IO (R/W) general queue, yes.  _A_ way
> to do this is to send START STOP UNIT (0x1B) with the IMMED
> bit set to 0.  When the command completes, you'll get status
> and set the device to active, unblock the IO queue, etc.

How would this interact with tagged command queueing? We don't want to 
attempt to queue other commands while START STOP UNIT is pending at the 
device. We don't want to disable disconnects, either, otherwise the bus 
would be blocked while waiting for START STOP UNIT, correct?

Maybe this is a SCSI-novice question, but, does disconnection require 
tagged commands? Is the Linux midlayer smart enough to know that some 
kinds of commands need to block others until they complete?

From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: Synchronizing scsi_remove_host and the error handler
Date: Tue, 09 Aug 2005 20:21:54 +0200
Message-ID: <42F8F442.1000304@s5r6.in-berlin.de>
References: <Pine.LNX.4.44L0.0508091023090.4643-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:30413 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S964920AbVHISWQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 9 Aug 2005 14:22:16 -0400
In-Reply-To: <Pine.LNX.4.44L0.0508091023090.4643-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>
Cc: Alan Stern <stern@rowland.harvard.edu>

Alan Stern wrote:
> On Tue, 9 Aug 2005, Stefan Richter wrote:
...
>> Retries (in the error handler) will not help
>>with error recovery either.
...
> Are you referring to the "try again" part I wrote above?
> That has nothing to do with disconnects.

OK, I confused that.

>>A more general thought: It appears from the example you
>>explained that maybe the USB highlevel carries too much of a
>>burden to watch out for concurrency.
...
> I'm not sure I understand your comment.  Are you saying that the job I 
> outlined above -- trying to acquire the device semaphore while checking 
> for possible disconnects -- should be part of the USB core instead of 
> the high-level USB device driver?

That's what I meant. (Two different things actually: Knowing that
one cannot reset a port after disconnection started, and having
to down a semaphore.) But again: I don't know If this is actually
desirable and feasible.

> It already is in the core.  If you're interested, read 
> drivers/usb/core/usb.c:usb_lock_device_for_reset().

I was actually browsing the usb/storage/scsiglue.c, but only
old code at lxr.linux.no, 2.6.11 in fact. Sorry, I see now that
this is way too old to look at. However the scsiglue.c's
device_reset and bus_reset in Linus' tree are still using down().
-- 
Stefan Richter
-=====-=-=-= =--- -=--=
http://arcgraph.de/sr/

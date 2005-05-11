From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: sg driver and the error handler
Date: Wed, 11 May 2005 15:43:23 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0505111531250.2981-100000@iolanthe.rowland.org>
References: <4282345B.4010102@adaptec.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:40832 "HELO
	iolanthe.rowland.org") by vger.kernel.org with SMTP id S261277AbVEKTnY
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 May 2005 15:43:24 -0400
In-Reply-To: <4282345B.4010102@adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: dougg@torque.net, Patrick Mansfield <patmans@us.ibm.com>, James Bottomley <James.Bottomley@SteelEye.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Wed, 11 May 2005, Luben Tuikov wrote:

> I think Alan even wants to see the QUEUEFULL status not being
> retried.
> 
> That is, other than reclaiming the command from the LLDD, the
> eh code should not retry or do anything with the command, just
> pass it back to the user process who sent it via sg.

Yes.

> Maybe the application client has other tricks up its sleeve
> on QUEUEFULL coming from the device.
> 
> I think scsi generic as a passthrough, where minimal logic
> from SCSI Core is applied and most is left to the application
> client.

That's how I think of it too.

> I think he even wants the stronger condition -- after the command is reclaimed
> from the LLDD, just send back the result to the application client.  And let
> the application client decide whether they want to send TUR or something else.

Absolutely correct.

Now, I have no idea how applications will handle exotic errors like 
QUEUEFULL.  And it might make sense to have the core retry errors like 
that when they come from the LLDD and not from the device.  But when an 
error does come from the device, it certainly should be passed directly 
back to the sg client.  The error handler shouldn't do anything more than 
abort and clean up after a timed-out command.


On Wed, 11 May 2005, Patrick Mansfield wrote:

> The TUR is part of the error recovery, and so it should be sent
> independent of the timed out command.

Or shouldn't be sent, as the case may be.  If the error handler isn't
going to do error recovery and is going to leave it up to the application,
then there's no reason to send the TUR.

> I know we want to have transport specific error (or timeout) handling and
> recovery. But for current usage, we should return the result of the
> timeout to the upper level driver (and implicitly to the application).

Right.  Ultimately I don't know how transport-specific issues need to be
handled.  It would be best if they can be limited to minimal cleanup so
that the application can do device-related error recovery.

Alan Stern


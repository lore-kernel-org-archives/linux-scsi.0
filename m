From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 1/3] SCSI: rearrange code in scsi_io_completion
Date: Tue, 30 Sep 2008 11:08:58 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0809301101000.2451-100000@iolanthe.rowland.org>
References: <1222785705.3232.18.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:52863 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751999AbYI3PI7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Sep 2008 11:08:59 -0400
In-Reply-To: <1222785705.3232.18.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On Tue, 30 Sep 2008, James Bottomley wrote:

> I don't really think this is the right approach, since the retry case
> needs to be split apart again.
> 
> The only time scsi_requeue_command() needs to be called is if the
> request completes successfully but has leftovers.  The reason is that
> the command will be different next time around, so it has to be
> re-prepared.  In all the other cases, the same command can be reused.
> This will have the knock on effect of not resetting the timers or the
> counters, so it has to be done carefully.

All right.  (Incidentally, do you happen to know the derivation of 
"knock on effect"?  The American form, "side effect", seems more 
self-explanatory.)

> Of the three requeue cases:
> 
> UNIT_ATTENTION needs immediate retry
> NOT_READY needs delayed retry
> ILLEGAL_REQUEST with cmd switch (assuming we still do it) needs
> immediate retry

If the command is switched from 10-byte to 6-byte form, won't it need 
to be re-prepared?

> DID_RESET is arguable either way, but probably needs delayed.
> 
> immediate requeue is done by:
> 
> scsi_queue_insert(cmd, SCSI_MLQUEUE_EH_RETRY);
> 
> And delayed by
> 
> scsi_queue_insert(cmd, SCSI_MLQUEUE_DEVICE_BUSY);

Easily fixed.  And it looks like neither of these needs a call to
scsi_next_command(), right?

Alan Stern


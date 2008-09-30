From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/3] SCSI: rearrange code in scsi_io_completion
Date: Tue, 30 Sep 2008 10:43:00 -0500
Message-ID: <1222789380.3232.33.camel@localhost.localdomain>
References: <Pine.LNX.4.44L0.0809301101000.2451-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:44723 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752832AbYI3Pna (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Sep 2008 11:43:30 -0400
In-Reply-To: <Pine.LNX.4.44L0.0809301101000.2451-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On Tue, 2008-09-30 at 11:08 -0400, Alan Stern wrote:
> On Tue, 30 Sep 2008, James Bottomley wrote:
> 
> > I don't really think this is the right approach, since the retry case
> > needs to be split apart again.
> > 
> > The only time scsi_requeue_command() needs to be called is if the
> > request completes successfully but has leftovers.  The reason is that
> > the command will be different next time around, so it has to be
> > re-prepared.  In all the other cases, the same command can be reused.
> > This will have the knock on effect of not resetting the timers or the
> > counters, so it has to be done carefully.
> 
> All right.  (Incidentally, do you happen to know the derivation of 
> "knock on effect"?  The American form, "side effect", seems more 
> self-explanatory.)

The etymology is probably from Rugby: a knock on takes the ball further
than allowed by the rules, usually as an unintended consequence of some
other action.

> > Of the three requeue cases:
> > 
> > UNIT_ATTENTION needs immediate retry
> > NOT_READY needs delayed retry
> > ILLEGAL_REQUEST with cmd switch (assuming we still do it) needs
> > immediate retry
> 
> If the command is switched from 10-byte to 6-byte form, won't it need 
> to be re-prepared?

Yes, sorry, that one needs a re-prepare requeue.

> > DID_RESET is arguable either way, but probably needs delayed.
> > 
> > immediate requeue is done by:
> > 
> > scsi_queue_insert(cmd, SCSI_MLQUEUE_EH_RETRY);
> > 
> > And delayed by
> > 
> > scsi_queue_insert(cmd, SCSI_MLQUEUE_DEVICE_BUSY);
> 
> Easily fixed.  And it looks like neither of these needs a call to
> scsi_next_command(), right?

Right, which is a nice side effect.

James



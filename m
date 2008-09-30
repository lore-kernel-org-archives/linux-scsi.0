From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 1/3] SCSI: rearrange code in scsi_io_completion
Date: Tue, 30 Sep 2008 15:49:21 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0809301538100.3494-100000@iolanthe.rowland.org>
References: <1222789380.3232.33.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:41936 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753494AbYI3TtW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Sep 2008 15:49:22 -0400
In-Reply-To: <1222789380.3232.33.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On Tue, 30 Sep 2008, James Bottomley wrote:

> > > Of the three requeue cases:
> > > 
> > > UNIT_ATTENTION needs immediate retry
> > > NOT_READY needs delayed retry
> > > ILLEGAL_REQUEST with cmd switch (assuming we still do it) needs
> > > immediate retry
> > 
> > If the command is switched from 10-byte to 6-byte form, won't it need 
> > to be re-prepared?
> 
> Yes, sorry, that one needs a re-prepare requeue.
> 
> > > DID_RESET is arguable either way, but probably needs delayed.
> > > 
> > > immediate requeue is done by:
> > > 
> > > scsi_queue_insert(cmd, SCSI_MLQUEUE_EH_RETRY);
> > > 
> > > And delayed by
> > > 
> > > scsi_queue_insert(cmd, SCSI_MLQUEUE_DEVICE_BUSY);
> > 
> > Easily fixed.  And it looks like neither of these needs a call to
> > scsi_next_command(), right?
> 
> Right, which is a nice side effect.

What about the logging code near the end of scsi_io_completion(), the
part which conditionally does scsi_print_result() and possibly
scsi_print_sense()?

The conditions under which those routines get called are pretty
obscure.  It would be nicer to make them more transparent.

For example, do the following rules make sense?

	For retries/requeues there's no need to print anything.
	(Excepting of course the calls to scsi_cmd_print_sense_hdr() 
	under NOT_READY and scsi_print_sense() under VOLUME_OVERFLOW.)

	For failures, we might as well always run the logging code.

Are there types of failure for which we really don't want to print 
anything?  For example, what about UNIT ATTENTION for media changes or 
the DIX/DIF failures (should those both be DIF?)?

Alan Stern


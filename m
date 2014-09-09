From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] scsi_debug: deadlock between completions and surprise
 module removal
Date: Tue, 9 Sep 2014 08:30:39 -0700
Message-ID: <20140909153039.GA32662@infradead.org>
References: <5403AB47.3040706@interlog.com>
 <20140905052402.GA27094@infradead.org>
 <5409C116.5060702@interlog.com>
 <5409D5D0.8060801@acm.org>
 <540B1CC6.8010800@interlog.com>
 <540D72BB.2020100@acm.org>
 <20140908150703.GA30298@infradead.org>
 <540E1205.9060201@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:53050 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932237AbaIIPal (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Sep 2014 11:30:41 -0400
Content-Disposition: inline
In-Reply-To: <540E1205.9060201@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dgilbert@interlog.com>
Cc: Christoph Hellwig <hch@infradead.org>, Bart Van Assche <bvanassche@acm.org>, SCSI development list <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, James Bottomley <james.bottomley@hansenpartnership.com>, Milan Broz <gmazyland@gmail.com>

On Mon, Sep 08, 2014 at 04:31:01PM -0400, Douglas Gilbert wrote:
> stop_all_queued() is doing hrtimer_cancel(), del_timer_sync()
> or tasklet_kill() on all the scsi_cmnd objects that are
> "in play". Unless another mechanism calls the .eh_abort_handler
> entry point reliably on each "in play" command then the module
> cannot be removed. That is because some timer expiry callbacks
> are pending.

scsi_remove_host disabled all queueing of new commands, so all these
timers and tasklets will eventually expire or run and allow the
removal to complete.  Of course this could be sped up by cancelling
them, but you don't need the sync version

> >Something like the (untested) patch below would do the trick.
> >We'd still need Dougs patch for the EH case, though.

> 
> The only other call to stop_all_queued() is from the
> .eh_host_reset_handler entry point.

True, but you also have stop_queued_cmnd for a abort case which
also needs that treatment.


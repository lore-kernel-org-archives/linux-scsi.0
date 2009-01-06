From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: [PATCH] scsi_lib: don't decrement busy counters when inserting
	commands
Date: Tue, 6 Jan 2009 11:48:24 -0800
Message-ID: <20090106194824.GE23842@plap4-2.local>
References: <1229493343215-git-send-email-michaelc@cs.wisc.edu> <1230914541.3304.9.camel@localhost.localdomain> <20090105232825.GA12820@plap4-2.local> <1231206966.3324.65.camel@localhost.localdomain> <20090106070106.GA17332@plap4-2.local> <1231269320.10475.25.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:59515 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751707AbZAFTsZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Jan 2009 14:48:25 -0500
Content-Disposition: inline
In-Reply-To: <1231269320.10475.25.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "michaelc@cs.wisc.edu" <michaelc@cs.wisc.edu>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Alan Stern <stern@rowland.harvard.edu>

On Tue, 06 Jan 2009, James Bottomley wrote:

> On Mon, 2009-01-05 at 23:01 -0800, Andrew Vasquez wrote:
> > This hunk is causing a panic during early SCSI init-time of the server
> > boot disk -- sg_free_table+0x51 (RIP), scsi_release_buffers+0xd4,
> > scsi_io_completion+0x324.  IAC, in looking through the code
> > scsi_end_request() returns NULL when the command has already been
> > requeued (via scsi_requeue_command()).  Modifying your original patch
> > to release-buffers prior to scsi_end_request()'s call to
> > scsi_requeue_command() and dropping the post-scsi_end_request() call
> > to scsi_release_buffers() fixes *both* the panic as well as the original
> > problem I reported regarding commands returned with a DID_RESET status
> > being requeued in an incomplete state.
> 
> Gosh this is a subtle nasty mess.

:O

> > Here's the updated patch.  Any other holes I missed?
> 
> Yes, I'm afraid ... if scsi_release_buffers() is moved into
> scsi_end_request() then it has to be called for every NULL returning
> path otherwise we leak buffers.  The missing release is the NULL return
> at the bottom of the function.  However, you can't call
> scsi_release_buffers() there because we've lost the request and the
> scsi_bidi_cmd() check tries to touch it.
> 
> Hopefully this version has all the holes plugged, if you could give it a
> spin...

Ok... The results look promising -- no panics and I/Os are resuming
properly after being returned with DID_RESET statuses.  Thanks for
working through this.

--
av

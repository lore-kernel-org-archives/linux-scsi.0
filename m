From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] scsi_lib: don't decrement busy counters when inserting
 commands
Date: Fri, 2 Jan 2009 22:39:00 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0901022235300.9777-100000@netrider.rowland.org>
References: <1230914541.3304.9.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:2756 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758798AbZACDjE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Jan 2009 22:39:04 -0500
In-Reply-To: <1230914541.3304.9.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org

On Fri, 2 Jan 2009, James Bottomley wrote:

> On Tue, 2008-12-16 at 23:55 -0600, michaelc@cs.wisc.edu wrote:
> > From: Mike Christie <michaelc@cs.wisc.edu>
> > 
> > This patch fixes a regression in scsi-misc introduced with:
> > 312efe5efcdb02d604ea37a41d965f32ca276d6a
> > [SCSI] simplify scsi_io_completion().
> > 
> > The problem is that in previous kernels scsi_io_completion would call
> > scsi_requeue_command, but now it can call scsi_queue_insert for
> > something like a UNIT_ATTENTION (for netapp targets we get
> > UNIT_ATTENTION when restarting a iscsi session). And scsi_queue_insert
> > will call scsi_device_unbusy, but in the scsi_io_completion code path
> > scsi_finish_command has already called this so we now end up
> > with invalid host, target and device busy values.
> > 
> > Patch was made over scsi-misc.
> 
> This is a bad bug, but not quite the way I'd like to fix it.  Whether
> the queue should be unbusied or not is really separate from the block
> action, so it should have its own flag (plus it's not really a flag many
> people should be using).  Since, really, the wrong use is confined to
> the defining file, how about this:

Seems entirely reasonable.  This points out the potential for trouble
when a non-expert (like me!) tries to modify a complicated subsystem.  
Still, many eyeballs and all that...

Thanks to both of you,

Alan Stern


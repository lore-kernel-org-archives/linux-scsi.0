From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Bugs in scsi system, need help to fix
Date: Mon, 14 Apr 2003 10:20:26 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0304141017580.827-100000@ida.rowland.org>
References: <20030414062333.GA11487@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:10756 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S263015AbTDNOIi (for <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Apr 2003 10:08:38 -0400
In-Reply-To: <20030414062333.GA11487@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: David Brownell <david-b@pacbell.net>, Linux SCSI list <linux-scsi@vger.kernel.org>

On Sun, 13 Apr 2003, Mike Anderson wrote:

> Alan Stern [stern@rowland.harvard.edu] wrote:
> > The first problem is in the error-handling code in scsi_error.c.  The
> > scsi_eh_lock_done() function is the callback for a special request
> > inserted at the beginning of the queue while restarting normal operations.  
> > (It locks the drive's door.)  But this function does not call
> > scsi_io_completion(), scsi_end_request(), or scsi_queue_next_request(),
> > with the result that the device's request queue stops once the door-lock
> > command has been processed.  The callback needs to do _something_ to keep
> > the queue going, but I don't know what.
> 
> The problem you are hitting is related to missing calls to
> scsi_queue_next_request. Patrick created a patch in a previous thread:
> http://marc.theaimsgroup.com/?l=linux-scsi&m=104855818826887&w=2
> 
> though it did not cover the path scsi_eh_lock_done takes. It appears
> that we should add a call to scsi_queue_next_request in
> scsi_release_request if sr_command is set.

<snip>

> The code you point to is incorrect. It looks like the migration of the
> 2.4 code left a few lines behind. The short term fix if you are hitting
> a problem here is to remove (A) add "scmd->request" to (B). The better
> fix is to not call this code anymore.
> 
> -andmike
> --
> Michael Anderson
> andmike@us.ibm.com

Thanks, Mike.  Is it safe to assume that a combined fix for all these 
problems will be posted in the next few weeks, as part of the 
hot-unplugging development effort?

Alan Stern


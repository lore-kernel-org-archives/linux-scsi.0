From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [Patch] Fix oops on rmmod usb-storage
Date: Thu, 30 Sep 2004 14:14:00 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0409301411240.1060-100000@ida.rowland.org>
References: <415BBF38.2080300@suse.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:10244 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S269386AbUI3SOE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Sep 2004 14:14:04 -0400
In-Reply-To: <415BBF38.2080300@suse.de>
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Mike Anderson <andmike@us.ibm.com>, Christoph Hellwig <hch@infradead.org>, James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@osdl.org>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>

On Thu, 30 Sep 2004, Hannes Reinecke wrote:

> Ok, since this is essential the same thread then on linux-scsi
> (cf. "Bug: CD driver sends commands during host removal") the same 
> solution applies here also.
> 
> Alan, I did a different patch which omit the special case handling in
> scsiglue.c and rather reorders usb_stor_control_thread. I'd prefer mine 
> (naturally), but any of those will do.
> And yes, both patches fix the problem.
> 
> Back to the maintainer for patch inclusion.
> 
> Cheers,
> 
> Hannes

No, your patch is incorrect.  In fact, it resembles the way the driver 
used to work -- which caused an occasional oops.  The problem is that by 
the time the usb_stor_control_thread() wakes up and sees that it has a new 
command to process, the SCSI core may already have deallocated the 
scsi_cmnd structure.  So the line where you assign to us->srb->result is 
liable to raise an addressing exception.

Alan Stern


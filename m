From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH 2.5.59] sim710: cleanup/remove most cli()'s
Date: 04 Feb 2003 17:11:38 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1044400300.3485.25.camel@mulgrave>
References: <200302041123.06204@bilbo.math.uni-mannheim.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id PAA10642
	for <linux-scsi@vger.kernel.org>; Tue, 4 Feb 2003 15:11:43 -0800
In-Reply-To: <200302041123.06204@bilbo.math.uni-mannheim.de>
List-Id: linux-scsi@vger.kernel.org
To: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Richard Hirst <rhirst@linuxcare.com>

On Tue, 2003-02-04 at 04:23, Rolf Eike Beer wrote:
> Hi,
> 
> the appended patch does the following:
> 
> -group all includes (except '#include "scsi_module.c"') together
> -add KERN_* to all printk's
> -add error checking for call of request_region
> -remove most cli() and use spin_lock instead
> -move help text to Documentation/scsi/sim710.txt
> -add a new debug target for debugging spinlocks
> -remove the magic numbers for request_region and release_region and use
>  SIM710_IOREGION_SIZE instead
> -same thing for the driver name
> -remove assignement to driver_template.proc_name which is already done before
>  in sim710.h
> 
> I have not broken this into peaces because for all changes (except the first
> of course) the corresponding lines are grouped together so it should be clear
> what I've done.
> 
> A kernel with this modification has booted yesterday and was tested under
> heavy loads succesfully.
> 
> What has to be done is:
> -remove the remaining two cli()
> -port this to the new driver model
> 
> I'm already working on this but it does not boot until now, so I'll delay this
> until it works.

Actually, since you're showing an interest in this driver, I think the
best thing to do would be to port it to use the 53c700 chip driver. 
Since the 53c700 already has all the sti/cli and DMA API issues sorted
out already, the only thing that would need to be done is to convert
sim710 to a template that speaks the new device model and initialises
the chip fields.

This would also bring synchronous operation and tag command queueing
virtually for free.

James



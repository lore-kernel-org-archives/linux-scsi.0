From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: PATCH: scsi device queue depth adjustability patch
Date: Wed, 02 Oct 2002 17:41:12 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200210022141.g92LfCh01941@localhost.localdomain>
References: <dledford@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id OAA06383
	for <linux-scsi@vger.kernel.org>; Wed, 2 Oct 2002 14:41:18 -0700
Received: from localhost.localdomain (midgard.sc.steeleye.com [172.17.6.40])
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) with ESMTP id OAA06294
	for <linux-scsi@vger.kernel.org>; Wed, 2 Oct 2002 14:41:16 -0700
Received: from mulgrave (jejb@localhost)
	by localhost.localdomain (8.11.6/linuxconf) with ESMTP id g92LfCh01941
	for <linux-scsi@vger.kernel.org>; Wed, 2 Oct 2002 17:41:12 -0400
In-Reply-To: Message from Doug Ledford <dledford@redhat.com>
   of "Tue, 01 Oct 2002 20:28:54 EDT." <20021002002854.GF28265@redhat.com>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

dledford@redhat.com said:
> This patch makes it possible to adjust the queue depth of a scsi
> device  after it has been in use some time and you have a better idea
> of what the  optimal queue depth should be.  For the most part this
> should work, but my  2.5.40 test machine is blowing chunks on the
> serverworks IDE support right  now so it isn't tested :-( 

I note that there's a lot more than dynamic queue depth adjustment in this 
patch (PPA inquiry, slave attach etc.).

How do HBA's that don't support this now work?  You've taken any dependency on 
scsi_host.cmd_per_lun out of the code (thus rendering it useless) so every HBA 
driver now is forced to use an initial queue depth adjustment just to start 
tagged command queueing.  Can't we at least start with cmd_per_lun as the 
default depth?

I'm not entirely happy with the idea that we control the queue depth by 
adjusting the number of the device's allocated commands.  I know the patch 
goes to great lengths to move these kmallocs out of the critical path, but 
there are certain environments (multi-initiator) where the queue depth can be 
nastily and randomly variable.  If the allocations were more lazy (wait a 
while before freeing a struct Scsi_Cmnd to see if the queue depth goes up 
again for instance) this would address some of these concerns (perhaps just 
moving to a slab allocator for command blocks would do it?)

> Side note: I left the control of queue depth setting solely in the
> hands  of the low level drivers since they are the *only* ones that
> can get an  accurate queue depth reading at the time of any given
> QUEUE_FULL message  (see what the aic7xxx_old driver has to do in the
> QUEUE_FULL handler to  find out how many commands the drive has seen
> at this exact point in time  vs. how many we may have queued up to the
> card, the difference in numbers  can be significant).  For that
> reason, the adjust_queue_depth call was  made to defer the action
> until later so that it was interrupt context  safe.

I appreciate that the HBA driver is the most exact counter of the queue depth, 
but would it make a significant difference if the adjustments were done 
globally in the mid-layer?  The great advantage is that we would gain dynamic 
queue depth adjustments without having to add specific code to every driver, 
at the cost of not always being entirely accurate about the depth.  Is there a 
good argument that this really, really must be done at the LLD level given the 
cost in terms of LLD modifications?  You could still add hooks for those HBAs 
that really want to do it themselves.

James





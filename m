From: Doug Ledford <dledford@redhat.com>
Subject: Re: Setting queue depths in the scsi mid layer, an intro
Date: Mon, 14 Oct 2002 21:28:09 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021015012809.GG1274@redhat.com>
References: <200210110246.g9B2kQVf027614@flossy.devel.redhat.com> <20021014181512.A7237@eng2.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from flossy.devel.redhat.com (localhost.localdomain [127.0.0.1])
	by flossy.devel.redhat.com (8.12.5/8.12.5) with ESMTP id g9F1SAfv003041
	for <linux-scsi@vger.kernel.org>; Mon, 14 Oct 2002 21:28:10 -0400
Received: (from dledford@localhost)
	by flossy.devel.redhat.com (8.12.5/8.12.5/Submit) id g9F1SAsl003039
	for linux-scsi@vger.kernel.org; Mon, 14 Oct 2002 21:28:10 -0400
Content-Disposition: inline
In-Reply-To: <20021014181512.A7237@eng2.beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On Mon, Oct 14, 2002 at 06:15:12PM -0700, Patrick Mansfield wrote:
> Doug -
> 
> Finally looking at and using the new queue depth code in 2.5.42.
> 
> Why are there two kmalloc()'s in scsi.c scsi_build_commandblocks()? 
> 
> They both use the same flags, including GFP_ATOMIC:
> 
> void scsi_build_commandblocks(Scsi_Device * SDpnt)
> {
> 	unsigned long flags;
> 	Scsi_Cmnd *SCpnt;
> 
> 	if (SDpnt->queue_depth != 0)
> 		return;
> 		
> 	SCpnt = (Scsi_Cmnd *) kmalloc(sizeof(Scsi_Cmnd), GFP_ATOMIC |
> 			(SDpnt->host->unchecked_isa_dma ? GFP_DMA : 0));
> 	if (NULL == SCpnt) {
> 		/*
> 		 * Since we don't currently have *any* command blocks on this
> 		 * device, go ahead and try an atomic allocation...
> 		 */
> 		SCpnt = (Scsi_Cmnd *) kmalloc(sizeof(Scsi_Cmnd), GFP_ATOMIC |
> 			(SDpnt->host->unchecked_isa_dma ? GFP_DMA : 0));
> 		if (NULL == SCpnt)
> 			return;	/* Oops, we aren't going anywhere for now */
> 	}

Oops.  Oversight.  It was from the time when I had the first allocation as 
GFP_KERNEL and then an ATOMIC backup.  I changed that because this is 
called from non-sleep allowed contexts (tasklet/softirq) and therefore 
must always use ATOMIC.  So, it only needs one allocation attempt.


-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  

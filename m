From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] fixes and cleanups for the new command allocation code
Date: 04 Feb 2003 17:03:15 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1044399797.3484.15.camel@mulgrave>
References: <20030204162326.A30755@lst.de>
	<20030204081616.A24105@beaverton.ibm.com> <20030204175146.A31515@lst.de>
	<20030204091955.A24785@beaverton.ibm.com>
	<1044383605.2014.23.camel@mulgrave>  <20030204202935.A325@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id PAA09052
	for <linux-scsi@vger.kernel.org>; Tue, 4 Feb 2003 15:03:22 -0800
In-Reply-To: <20030204202935.A325@lst.de>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Patrick Mansfield <patmans@us.ibm.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, 2003-02-04 at 13:29, Christoph Hellwig wrote:
> --- 1.64/drivers/scsi/scsi_lib.c	Tue Jan 28 23:09:29 2003
> +++ edited/drivers/scsi/scsi_lib.c	Tue Feb  4 20:19:00 2003
> @@ -35,7 +35,6 @@
>  }; 	
>  #undef SP
>  
> -struct scsi_core_data *scsi_core;
>  
>  /*
>   * Function:    scsi_insert_special_cmd()
> @@ -814,9 +813,10 @@
>  		SCpnt = (Scsi_Cmnd *) req->special;
>  		SRpnt = (Scsi_Request *) req->special;
>  		
> -		if( SRpnt->sr_magic == SCSI_REQ_MAGIC ) {
> -			SCpnt = scsi_getset_command(SRpnt->sr_device,
> -						    GFP_ATOMIC);
> +		if (SRpnt->sr_magic == SCSI_REQ_MAGIC) {
> +			if (SDpnt->device_busy >= SDpnt->queue_depth)
> +				return BLKPREP_DEFER;
> +			SCpnt = scsi_get_command(SRpnt->sr_device, GFP_ATOMIC);

Actually, I don't necessarily think we want to do this.

I think we should throttle in the request_fn not in the prep_fn.  The
reason is the way the block queue works:  If we have a prepped request
ready to roll, it will go straight through the request fn (without
sending it back through prep again).  Thus, we can have a fully prepared
command ready for immediate issue as soon as the device returns one of
its slots and therefore we keep the pipeline packed as tightly as
possible given the maximum number of outstanding commands constraint. 
It also means that we have all the memory allocations completed by the
time we try to issue the command, rather than trying the memory
allocations as part of the prep function for the next issue.

James


From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: Handling erroneous READ CAPACITY response in sd.c
Date: Mon, 08 Nov 2004 16:35:54 -0500
Message-ID: <418FE6BA.1060609@adaptec.com>
References: <Pine.LNX.4.44L0.0411081559310.7340-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:60812 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S261243AbUKHVgJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Nov 2004 16:36:09 -0500
In-Reply-To: <Pine.LNX.4.44L0.0411081559310.7340-100000@ida.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Matthew Dharm <mdharm-usb@one-eyed-alien.net>, SCSI development list <linux-scsi@vger.kernel.org>, USB Storage list <usb-storage@lists.one-eyed-alien.net>

Alan Stern wrote:
> On Mon, 8 Nov 2004, Luben Tuikov wrote:
> 
> 
>>This sounds good.  Just to clarify: if we blacklist in usb-storage, then
>>I think there's no need to also blacklist in SCSI Core as well.  Let sd
>>use the flag to decrement the Returned LBA (effectively assign Returned
>>LBA to capacity rather than increment it and then assign it.)
> 
> 
> That's right.  Below is the patch.  I'm never quite sure who these things 

Looks good to me.

	Luben

> should be submitted to because they apply to both the USB and SCSI 
> subsystems.  But if it looks good to both of you, I can send it on to 
> James Bottomley.
> 
> Alan Stern
> 
> 
> 
> Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
> 
> ===== include/scsi/scsi_device.h 1.14 vs edited =====
> --- 1.14/include/scsi/scsi_device.h	2004-10-05 11:47:13 -04:00
> +++ edited/include/scsi/scsi_device.h	2004-11-08 15:42:52 -05:00
> @@ -111,6 +111,7 @@
>  	unsigned allow_restart:1; /* issue START_UNIT in error handler */
>  	unsigned no_uld_attach:1; /* disable connecting to upper level drivers */
>  	unsigned select_no_atn:1;
> +	unsigned fix_capacity:1;	/* READ_CAPACITY is too high by 1 */
>  
>  	unsigned int device_blocked;	/* Device returned QUEUE_FULL. */
>  
> ===== drivers/scsi/sd.c 1.73 vs edited =====
> --- 1.73/drivers/scsi/sd.c	2004-10-20 12:24:44 -04:00
> +++ edited/drivers/scsi/sd.c	2004-11-08 15:42:37 -05:00
> @@ -1104,6 +1104,11 @@
>  			(buffer[9] << 16) | (buffer[10] << 8) | buffer[11];
>  	}	
>  
> +	/* Some devices return the total number of sectors, not the
> +	 * highest sector number.  Make the necessary adjustment. */
> +	if (sdp->fix_capacity)
> +		--sdkp->capacity;
> +
>  got_data:
>  	if (sector_size == 0) {
>  		sector_size = 512;
> ===== drivers/usb/storage/protocol.c 1.25 vs edited =====
> --- 1.25/drivers/usb/storage/protocol.c	2004-10-20 12:38:15 -04:00
> +++ edited/drivers/usb/storage/protocol.c	2004-11-08 15:37:22 -05:00
> @@ -54,39 +54,6 @@
>  #include "transport.h"
>  
>  /***********************************************************************
> - * Helper routines
> - ***********************************************************************/
> -
> -/*
> - * Fix-up the return data from a READ CAPACITY command. My Feiya reader
> - * returns a value that is 1 too large.
> - */
> -static void fix_read_capacity(struct scsi_cmnd *srb)
> -{
> -	unsigned int index, offset;
> -	__be32 c;
> -	unsigned long capacity;
> -
> -	/* verify that it's a READ CAPACITY command */
> -	if (srb->cmnd[0] != READ_CAPACITY)
> -		return;
> -
> -	index = offset = 0;
> -	if (usb_stor_access_xfer_buf((unsigned char *) &c, 4, srb,
> -			&index, &offset, FROM_XFER_BUF) != 4)
> -		return;
> -
> -	capacity = be32_to_cpu(c);
> -	US_DEBUGP("US: Fixing capacity: from %ld to %ld\n",
> -	       capacity+1, capacity);
> -	c = cpu_to_be32(capacity - 1);
> -
> -	index = offset = 0;
> -	usb_stor_access_xfer_buf((unsigned char *) &c, 4, srb,
> -			&index, &offset, TO_XFER_BUF);
> -}
> -
> -/***********************************************************************
>   * Protocol routines
>   ***********************************************************************/
>  
> @@ -174,12 +141,6 @@
>  {
>  	/* send the command to the transport layer */
>  	usb_stor_invoke_transport(srb, us);
> -
> -	if (srb->result == SAM_STAT_GOOD) {
> -		/* Fix the READ CAPACITY result if necessary */
> -		if (us->flags & US_FL_FIX_CAPACITY)
> -			fix_read_capacity(srb);
> -	}
>  }
>  
>  /***********************************************************************
> ===== drivers/usb/storage/scsiglue.c 1.87 vs edited =====
> --- 1.87/drivers/usb/storage/scsiglue.c	2004-11-01 13:59:21 -05:00
> +++ edited/drivers/usb/storage/scsiglue.c	2004-11-08 15:43:05 -05:00
> @@ -152,6 +152,11 @@
>  		sdev->skip_ms_page_3f = 1;
>  #endif
>  
> +		/* Some disks return the total number blocks in response
> +		 * to READ CAPACITY rather than the highest block number.
> +		 * If this device makes that mistake, tell the sd driver. */
> +		if (us->flags & US_FL_FIX_CAPACITY)
> +			sdev->fix_capacity = 1;
>  	} else {
>  
>  		/* Non-disk-type devices don't need to blacklist any pages
> 


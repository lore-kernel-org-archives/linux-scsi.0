From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: Handling erroneous READ CAPACITY response in sd.c
Date: Mon, 25 Oct 2004 16:27:27 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <417D61AF.3090003@adaptec.com>
References: <Pine.LNX.4.44L0.0410251536010.1185-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:12226 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S261297AbUJYU1k (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Oct 2004 16:27:40 -0400
In-Reply-To: <Pine.LNX.4.44L0.0410251536010.1185-100000@ida.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Eero Volotinen <eero@ping-viini.org>, Adriaan Penning <a.penning@luon.net>, Darsen Lu <darsen@micro.ee.nthu.edu.tw>, Andries Brouwer <aebr@win.tue.nl>, SCSI development list <linux-scsi@vger.kernel.org>

Alan Stern wrote:
> On Sun, 24 Oct 2004, Eero Volotinen wrote:
> 
> 
>>Does not work on my machine. It detects disk and then it hangs.
> 
> 
>>   Vendor: HDS72808  Model: 0PLAT20           Rev: PF2O
>>   Type:   Direct-Access                      ANSI SCSI revision: 00
>>sd_read_true_cap: sda: spec behavior
>>sd_read_format_cap: sda: no media or unformatted media
>>SCSI device sda: 160836481 512-byte hdwr sectors (82348 MB)
>>sda: assuming drive cache: write through
>>  sda:SCSI error : <0 0 0 0> return code = 0x70000
>>end_request: I/O error, dev sda, sector 160836480
>>Buffer I/O error on device sda, logical block 160836480
> 
> 
> Okay, so it looks like neither of the earlier suggestions will work.

Well, see my earlier email.  Let's not weed out descriptor type 3,
only 0 (which has no meaning as it is "reserved").  Looks like all
descriptors return _some_ kind of capacity -- let's see what it is
and possibly use it.  That is, since as you said Windows uses it...

> Here's one that I feel certain will work, although it takes a slightly 
> different approach.  Please try it out and see what happens.
> 
> Luben and Andries, what do you think of this patch?

Patch itself looks good.  But...

Brandishing all USB storage disk devices to have even number
capacity isn't something I think we can have in a kernel.  Or can we?

	Luben



> Alan Stern
> 
> 
> 
> Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
> 
> ===== include/scsi/scsi_device.h 1.14 vs edited =====
> --- 1.14/include/scsi/scsi_device.h	2004-10-05 11:47:13 -04:00
> +++ edited/include/scsi/scsi_device.h	2004-10-25 15:10:48 -04:00
> @@ -111,6 +111,7 @@
>  	unsigned allow_restart:1; /* issue START_UNIT in error handler */
>  	unsigned no_uld_attach:1; /* disable connecting to upper level drivers */
>  	unsigned select_no_atn:1;
> +	unsigned even_capacity:1; /* must have an even number of sectors */
>  
>  	unsigned int device_blocked;	/* Device returned QUEUE_FULL. */
>  
> ===== drivers/scsi/sd.c 1.73 vs edited =====
> --- 1.73/drivers/scsi/sd.c	2004-10-20 12:24:44 -04:00
> +++ edited/drivers/scsi/sd.c	2004-10-25 15:19:33 -04:00
> @@ -1133,6 +1133,16 @@
>  		 */
>  		sector_size = 512;
>  	}
> +
> +	/* Handle broken devices that return the total number of sectors
> +	 * rather than the highest sector number, by forcing the total
> +	 * number to be even. */
> +	if (sdp->even_capacity && (sdkp->capacity & 1)) {
> +		printk(KERN_NOTICE "%s : odd number of sectors reported, "
> +			"decreasing by one.\n", diskname);
> +		--sdkp->capacity;
> +	}
> +
>  	{
>  		/*
>  		 * The msdos fs needs to know the hardware sector size
> ===== drivers/usb/storage/protocol.c 1.25 vs edited =====
> --- 1.25/drivers/usb/storage/protocol.c	2004-10-20 12:38:15 -04:00
> +++ edited/drivers/usb/storage/protocol.c	2004-10-25 15:23:32 -04:00
> @@ -57,35 +57,6 @@
>   * Helper routines
>   ***********************************************************************/
>  
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
>  /***********************************************************************
>   * Protocol routines
>   ***********************************************************************/
> @@ -174,12 +145,6 @@
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
> ===== drivers/usb/storage/scsiglue.c 1.86 vs edited =====
> --- 1.86/drivers/usb/storage/scsiglue.c	2004-09-30 16:07:33 -04:00
> +++ edited/drivers/usb/storage/scsiglue.c	2004-10-25 15:25:44 -04:00
> @@ -152,6 +152,12 @@
>  		sdev->skip_ms_page_3f = 1;
>  #endif
>  
> +		/* Some devices return the total number of blocks in
> +		 * response to READ CAPACITY instead of the highest
> +		 * block number.  Deal with this by forcing the number
> +		 * of blocks to be even.  Fortunately no existing USB
> +		 * drive has an odd number of blocks, so far as I know! */
> +		sdev->even_capacity = 1;
>  	} else {
>  
>  		/* Non-disk-type devices don't need to blacklist any pages
> @@ -390,7 +396,7 @@
>  		DO_FLAG(SINGLE_LUN);
>  		DO_FLAG(SCM_MULT_TARG);
>  		DO_FLAG(FIX_INQUIRY);
> -		DO_FLAG(FIX_CAPACITY);
> +		DO_FLAG(IGNORE_RESIDUE);
>  
>  		*(pos++) = '\n';
>  	}
> ===== drivers/usb/storage/unusual_devs.h 1.161 vs edited =====
> --- 1.161/drivers/usb/storage/unusual_devs.h	2004-10-20 12:38:15 -04:00
> +++ edited/drivers/usb/storage/unusual_devs.h	2004-10-25 15:24:29 -04:00
> @@ -171,16 +171,6 @@
>  		"CD-R/RW Drive",
>  		US_SC_8070, US_PR_CB, NULL, 0),
>  
> -/* Reported by Adriaan Penning <a.penning@luon.net>
> - * Note that these cameras report "Medium not present" after
> - * ALLOW_MEDIUM_REMOVAL, so they also need to be marked
> - * NOT_LOCKABLE in the SCSI blacklist (and the vendor is MATSHITA). */
> -UNUSUAL_DEV(  0x04da, 0x2372, 0x0000, 0x9999,
> -		"Panasonic",
> -		"DMC-LCx Camera",
> -		US_SC_DEVICE, US_PR_DEVICE, NULL,
> -		US_FL_FIX_CAPACITY ),
> -
>  /* Most of the following entries were developed with the help of
>   * Shuttle/SCM directly.
>   */
> @@ -483,13 +473,6 @@
>  		US_FL_SINGLE_LUN ),
>  #endif
>  
> -/* Reported by Darsen Lu <darsen@micro.ee.nthu.edu.tw> */
> -UNUSUAL_DEV( 0x066f, 0x8000, 0x0001, 0x0001,
> -		"SigmaTel",
> -		"USBMSC Audio Player",
> -		US_SC_DEVICE, US_PR_DEVICE, NULL,
> -		US_FL_FIX_CAPACITY ),
> -
>  /* Submitted by Benny Sjostrand <benny@hostmobility.com> */
>  UNUSUAL_DEV( 0x0686, 0x4011, 0x0001, 0x0001,
>  		"Minolta",
> @@ -547,13 +530,6 @@
>  		US_SC_QIC, US_PR_FREECOM, freecom_init, 0),
>  #endif
>  
> -/* Reported by Eero Volotinen <eero@ping-viini.org> */
> -UNUSUAL_DEV(  0x07ab, 0xfccd, 0x0406, 0x0406,
> -		"Freecom Technologies",
> -		"FHD-Classic",
> -		US_SC_DEVICE, US_PR_DEVICE, NULL,
> -		US_FL_FIX_CAPACITY),
> -
>  UNUSUAL_DEV(  0x07af, 0x0004, 0x0100, 0x0133, 
>  		"Microtech",
>  		"USB-SCSI-DB25",
> @@ -710,13 +686,6 @@
>  		"MP3 player",
>  		US_SC_RBC, US_PR_BULK, NULL,
>  		US_FL_MODE_XLATE),
> -
> -/* aeb */
> -UNUSUAL_DEV( 0x090c, 0x1132, 0x0000, 0xffff,
> -		"Feiya",
> -		"5-in-1 Card Reader",
> -		US_SC_DEVICE, US_PR_DEVICE, NULL,
> -		US_FL_FIX_CAPACITY ),
>  
>  UNUSUAL_DEV(  0x097a, 0x0001, 0x0000, 0x0001,
>  		"Minds@Work",
> ===== drivers/usb/storage/usb.h 1.64 vs edited =====
> --- 1.64/drivers/usb/storage/usb.h	2004-10-20 12:38:15 -04:00
> +++ edited/drivers/usb/storage/usb.h	2004-10-25 15:23:01 -04:00
> @@ -72,7 +72,7 @@
>  #define US_FL_IGNORE_SER      0		 /* [no longer used]		    */
>  #define US_FL_SCM_MULT_TARG   0x00000020 /* supports multiple targets	    */
>  #define US_FL_FIX_INQUIRY     0x00000040 /* INQUIRY response needs faking   */
> -#define US_FL_FIX_CAPACITY    0x00000080 /* READ CAPACITY response too big  */
> +#define US_FL_FIX_CAPACITY    0		 /* [no longer used]		    */
>  #define US_FL_IGNORE_RESIDUE  0x00000100 /* reported residue is wrong	    */
>  
>  /* Dynamic flag definitions: used in set_bit() etc. */
> 


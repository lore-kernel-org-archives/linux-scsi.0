From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] SCSI: sanitize INQUIRY strings
Date: Mon, 21 Aug 2006 10:14:18 -0600
Message-ID: <20060821161417.GB4340@parisc-linux.org>
References: <Pine.LNX.4.44L0.0608211201020.5792-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:29841 "EHLO
	palinux.external.hp.com") by vger.kernel.org with ESMTP
	id S1750780AbWHUQOT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Aug 2006 12:14:19 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0608211201020.5792-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Mon, Aug 21, 2006 at 12:03:21PM -0400, Alan Stern wrote:
> This patch (as766) sanitizes the Vendor, Product, and Revision strings
> contained in an INQUIRY result, by setting all non-graphic or
> non-ASCII characters to ' '.  Since the standard disallows such
> characters, this will affect only non-compliant devices.

I thiink you attached the wrong patch; it doesn't match the description
at all.  Besides, print_inquiry is gone in scsi-misc.

> The most prominent effect will be to prevent stray NUL characters from
> terminating one of these strings early (which can prevent a blacklist
> match).
> 
> Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
> 
> ---
> 
> There is a small possibility that this may cause a problem for some users.  
> But nobody on the mailing raised any serious objections, so I'm submitting 
> it.  I know of one person it will definitely help.
> 
> Index: usb-2.6/drivers/scsi/scsi_scan.c
> ===================================================================
> --- usb-2.6.orig/drivers/scsi/scsi_scan.c
> +++ usb-2.6/drivers/scsi/scsi_scan.c
> @@ -148,27 +148,19 @@ static void scsi_unlock_floptical(struct
>  static void print_inquiry(unsigned char *inq_result)
>  {
>  	int i;
> +	int n = inq_result[4] + 5;
>  
>  	printk(KERN_NOTICE "  Vendor: ");
>  	for (i = 8; i < 16; i++)
> -		if (inq_result[i] >= 0x20 && i < inq_result[4] + 5)
> -			printk("%c", inq_result[i]);
> -		else
> -			printk(" ");
> +		printk("%c", (i < n ? inq_result[i] : ' '));
>  
>  	printk("  Model: ");
>  	for (i = 16; i < 32; i++)
> -		if (inq_result[i] >= 0x20 && i < inq_result[4] + 5)
> -			printk("%c", inq_result[i]);
> -		else
> -			printk(" ");
> +		printk("%c", (i < n ? inq_result[i] : ' '));
>  
>  	printk("  Rev: ");
>  	for (i = 32; i < 36; i++)
> -		if (inq_result[i] >= 0x20 && i < inq_result[4] + 5)
> -			printk("%c", inq_result[i]);
> -		else
> -			printk(" ");
> +		printk("%c", (i < n ? inq_result[i] : ' '));
>  
>  	printk("\n");
>  
> @@ -463,13 +455,14 @@ void scsi_target_reap(struct scsi_target
>   *     INQUIRY data is in @inq_result; the scsi_level and INQUIRY length
>   *     are copied to the scsi_device any flags value is stored in *@bflags.
>   **/
> -static int scsi_probe_lun(struct scsi_device *sdev, char *inq_result,
> +static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
>  			  int result_len, int *bflags)
>  {
>  	unsigned char scsi_cmd[MAX_COMMAND_SIZE];
>  	int first_inquiry_len, try_inquiry_len, next_inquiry_len;
>  	int response_len = 0;
>  	int pass, count, result;
> +	int i;
>  	struct scsi_sense_hdr sshdr;
>  
>  	*bflags = 0;
> @@ -526,6 +519,12 @@ static int scsi_probe_lun(struct scsi_de
>  		if (response_len > 255)
>  			response_len = first_inquiry_len;	/* sanity */
>  
> +		/* Sanitize the Vendor, Product, and Revision fields. */
> +		for (i = 8; i < 36; ++i) {
> +			if (inq_result[i] < 0x20 || inq_result[i] > 0x7e)
> +				inq_result[i] = ' ';
> +		}
> +
>  		/*
>  		 * Get any flags for this device.
>  		 *
> @@ -628,7 +627,8 @@ static int scsi_probe_lun(struct scsi_de
>   *     SCSI_SCAN_NO_RESPONSE: could not allocate or setup a scsi_device
>   *     SCSI_SCAN_LUN_PRESENT: a new scsi_device was allocated and initialized
>   **/
> -static int scsi_add_lun(struct scsi_device *sdev, char *inq_result, int *bflags)
> +static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
> +		int *bflags)
>  {
>  	/*
>  	 * XXX do not save the inquiry, since it can change underneath us,
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Ronald Kuetemeier <ronald@kuetemeier.com>
Subject: Re: [PATCH/RFT] mode sense madness always use page 8
Date: Thu, 30 Oct 2003 11:14:57 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1067537697.1133.131.camel@ronald.kuetemeier.com>
References: <Pine.LNX.4.44L0.0310301004010.852-100000@ida.rowland.org>
	 <1067531731.4250.11.camel@pathost1.iomegacorp.com>
	 <20031030091808.A6781@beaverton.ibm.com>
	 <1067535485.6411.42.camel@pathost1.iomegacorp.com>
	 <20031030100501.A7250@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 12-254-105-101.client.attbi.com ([12.254.105.101]:61701 "EHLO
	gw.kuetemeier.com") by vger.kernel.org with ESMTP id S262731AbTJ3SPW
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Oct 2003 13:15:22 -0500
In-Reply-To: <20031030100501.A7250@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: Pat LaVarre <p.lavarre@ieee.org>, stern@rowland.harvard.edu, linux-scsi@vger.kernel.org, usb-storage@one-eyed-alien.net, james.bottomley@steeleye.com

Patrick,
should I leave the prev. scsi.h patch in or take it out before this try?
BTW: I will be off for the rest of the week, but will give you feedback
on this one today ( I hope).
Ronald


On Thu, 2003-10-30 at 11:05, Patrick Mansfield wrote:
> Here's a patch, per Pat Lavarre's suggestion, this can't go in without
> others verifying and testing it, and without input or comment from others
> (at least James).
> 
> Again no USB testing here, tested on 2 sets of SPI attached disks, and 2
> sets of FCP attached disks. It really needs testing on removable media to
> actually hit the write protect check.
> 
> Ronald does this work for you?
> 
> ------
> 
> Use MODE SENSE page 8 whether asking for write protect information or
> cache type.  Always use the exact size of the expected result.
> 
> diff -uprN -X /home/patman/dontdiff bl-25/drivers/scsi/scsi_lib.c use_page8_always-bl-2.5/drivers/scsi/scsi_lib.c
> --- bl-25/drivers/scsi/scsi_lib.c	Mon Sep 29 12:21:09 2003
> +++ use_page8_always-bl-2.5/drivers/scsi/scsi_lib.c	Thu Oct 30 09:23:19 2003
> @@ -1377,6 +1377,11 @@ __scsi_mode_sense(struct scsi_request *s
>  	if (use_10_for_ms) {
>  		if (len < 8)
>  			len = 8;
> +		else if (len > 28)
> +			/*
> +			 * 20 bytes + 8 byte header
> +			 */
> +			len = 28;
>  
>  		cmd[0] = MODE_SENSE_10;
>  		cmd[8] = len;
> @@ -1384,6 +1389,11 @@ __scsi_mode_sense(struct scsi_request *s
>  	} else {
>  		if (len < 4)
>  			len = 4;
> +		else if (len > 24)
> +			/*
> +			 * 20 bytes + 4 byte header
> +			 */
> +			len = 24;
>  
>  		cmd[0] = MODE_SENSE;
>  		cmd[4] = len;
> diff -uprN -X /home/patman/dontdiff bl-25/drivers/scsi/sd.c use_page8_always-bl-2.5/drivers/scsi/sd.c
> --- bl-25/drivers/scsi/sd.c	Mon Oct 27 14:28:18 2003
> +++ use_page8_always-bl-2.5/drivers/scsi/sd.c	Thu Oct 30 09:35:53 2003
> @@ -1085,8 +1085,10 @@ sd_do_mode_sense(struct scsi_request *SR
>   */
>  static void
>  sd_read_write_protect_flag(struct scsi_disk *sdkp, char *diskname,
> -		   struct scsi_request *SRpnt, unsigned char *buffer) {
> +		   struct scsi_request *SRpnt, unsigned char *buffer) 
> +{
>  	int res;
> +	int len;
>  	struct scsi_mode_data data;
>  
>  	if (sdkp->device->skip_ms_page_3f) {
> @@ -1094,26 +1096,16 @@ sd_read_write_protect_flag(struct scsi_d
>  		return;
>  	}
>  
> -	/*
> -	 * First attempt: ask for all pages (0x3F), but only 4 bytes.
> -	 * We have to start carefully: some devices hang if we ask
> -	 * for more than is available.
> -	 */
> -	res = sd_do_mode_sense(SRpnt, 0, 0x3F, buffer, 4, &data);
> -
> -	/*
> -	 * Second attempt: ask for page 0
> -	 * When only page 0 is implemented, a request for page 3F may return
> -	 * Sense Key 5: Illegal Request, Sense Code 24: Invalid field in CDB.
> -	 */
> -	if (!scsi_status_is_good(res))
> -		res = sd_do_mode_sense(SRpnt, 0, 0, buffer, 4, &data);
> -
> -	/*
> -	 * Third attempt: ask 255 bytes, as we did earlier.
> -	 */
> -	if (!scsi_status_is_good(res))
> -		res = sd_do_mode_sense(SRpnt, 0, 0x3F, buffer, 255, &data);
> +	if (sdkp->device->use_10_for_ms)
> +		/*
> +		 * __mode_sense auto-retries with a size of 24 if it
> +		 * switches to a 6 byte command.
> +		 */
> +		len = 28; /* 20 + 8 byte header */
> +	else
> +		len = 24; /* 20 + 4 byte header */
> +
> +	res = sd_do_mode_sense(SRpnt, 0, 8, buffer, len, &data);
>  
>  	if (!scsi_status_is_good(res)) {
>  		printk(KERN_WARNING
> @@ -1130,42 +1122,36 @@ sd_read_write_protect_flag(struct scsi_d
>  /*
>   * sd_read_cache_type - called only from sd_revalidate_disk()
>   * called with buffer of length 512
> + *
> + * XXX Combine this with sd_read_write_protect_flag, so we only get the
> + * page once.
>   */
>  static void
>  sd_read_cache_type(struct scsi_disk *sdkp, char *diskname,
> -		   struct scsi_request *SRpnt, unsigned char *buffer) {
> +		   struct scsi_request *SRpnt, unsigned char *buffer) 
> +{
>  	int len = 0, res;
> -
> -	const int dbd = 0;	   /* DBD */
> -	const int modepage = 0x08; /* current values, cache page */
>  	struct scsi_mode_data data;
>  
> -	if (sdkp->device->skip_ms_page_8)
> -		goto defaults;
> -
> -	/* cautiously ask */
> -	res = sd_do_mode_sense(SRpnt, dbd, modepage, buffer, 4, &data);
> -
> -	if (!scsi_status_is_good(res))
> -		goto bad_sense;
> +	sdkp->WCE = 0;
> +	sdkp->RCD = 0;
>  
> -	/* that went OK, now ask for the proper length */
> -	len = data.length;
> -
> -	/*
> -	 * We're only interested in the first three bytes, actually.
> -	 * But the data cache page is defined for the first 20.
> -	 */
> -	if (len < 3)
> -		goto bad_sense;
> -	if (len > 20)
> -		len = 20;
> +	if (sdkp->device->skip_ms_page_8) {
> +		printk(KERN_ERR "%s: assuming drive cache: write through\n",
> +		       diskname);
> +		return;
> +	}
>  
> -	/* Take headers and block descriptors into account */
> -	len += data.header_length + data.block_descriptor_length;
> +	if (sdkp->device->use_10_for_ms)
> +		/*
> +		 * __mode_sense auto-retries with a size of 24 if it
> +		 * switches to a 6 byte command.
> +		 */
> +		len = 28; /* 20 + 8 byte header */
> +	else
> +		len = 24; /* 20 + 4 byte header */
>  
> -	/* Get the data */
> -	res = sd_do_mode_sense(SRpnt, dbd, modepage, buffer, len, &data);
> +	res = sd_do_mode_sense(SRpnt, 0, 8, buffer, len, &data);
>  
>  	if (scsi_status_is_good(res)) {
>  		const char *types[] = {
> @@ -1185,10 +1171,7 @@ sd_read_cache_type(struct scsi_disk *sdk
>  		       diskname, types[ct]);
>  
>  		return;
> -	}
> -
> -bad_sense:
> -	if ((SRpnt->sr_sense_buffer[0] & 0x70) == 0x70
> +	} else if ((SRpnt->sr_sense_buffer[0] & 0x70) == 0x70
>  	     && (SRpnt->sr_sense_buffer[2] & 0x0f) == ILLEGAL_REQUEST
>  	     /* ASC 0x24 ASCQ 0x00: Invalid field in CDB */
>  	     && SRpnt->sr_sense_buffer[12] == 0x24
> @@ -1199,12 +1182,6 @@ bad_sense:
>  		printk(KERN_ERR "%s: asking for cache data failed\n",
>  		       diskname);
>  	}
> -
> -defaults:
> -	printk(KERN_ERR "%s: assuming drive cache: write through\n",
> -	       diskname);
> -	sdkp->WCE = 0;
> -	sdkp->RCD = 0;
>  }
>  
>  /**
> 


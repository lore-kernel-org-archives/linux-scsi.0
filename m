From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: Compaq Fiber Channel Array RM4000 / 2.6.16 kernel patch
Date: Thu, 30 Mar 2006 09:24:29 -0700
Message-ID: <20060330162429.GI13590@parisc-linux.org>
References: <1143656547.3248.36.camel@mulgrave.il.steeleye.com> <Pine.GSO.4.64.0603292025500.4009@filebunker.xip.at> <1143657838.3248.39.camel@mulgrave.il.steeleye.com> <Pine.GSO.4.64.0603292052430.4009@filebunker.xip.at> <1143659029.3248.42.camel@mulgrave.il.steeleye.com> <Pine.GSO.4.64.0603292125370.4009@filebunker.xip.at> <1143666681.3248.48.camel@mulgrave.il.steeleye.com> <Pine.GSO.4.64.0603301252100.595@filebunker.xip.at> <20060330125816.GG13590@parisc-linux.org> <Pine.GSO.4.64.0603301523130.6412@filebunker.xip.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:31961 "EHLO
	palinux.hppa") by vger.kernel.org with ESMTP id S1751012AbWC3QYa
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Mar 2006 11:24:30 -0500
Content-Disposition: inline
In-Reply-To: <Pine.GSO.4.64.0603301523130.6412@filebunker.xip.at>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ingo Flaschberger <if@xip.at>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, Mar 30, 2006 at 04:20:25PM +0200, Ingo Flaschberger wrote:
> >> 	{"CNSi", "G8324", NULL, BLIST_SPARSELUN},	/* Chaparral G8324 
> >> 	RAID */
> >>+	{"COMPAQ", "ARRAY CONTROLLER", "2.60", BLIST_SPARSELUN | 
> >>BLIST_LARGELUN |
> >>+		BLIST_MAX_512K}, /* Compaq RA4x00 */
> >>+	{"COMPAQ", "LOGICAL VOLUME", "2.60", BLIST_MAX_512K}, /* Compaq 
> >>RA4x00 */
> >> 	{"COMPAQ", "LOGICAL VOLUME", NULL, BLIST_FORCELUN},
> >
> >I wonder if you should just be adding BLIST_MAX_512K to the current
> >entry for LOGICAL VOLUME instead?
> 
> The "LOGICAL VOLUME" was there before and I think I will break the SCSI 
> Version.

I meant to do something like:

-	{"COMPAQ", "LOGICAL VOLUME", NULL, BLIST_FORCELUN},
+	{"COMPAQ", "LOGICAL VOLUME", NULL, BLIST_FORCELUN | BLIST_MAX_512K},

> >I'm not sure that's what you meant to do, even.  How about more simply:
> >
> >	/*
> >	 * Only support SCSI-3 and up devices if BLIST_NOREPORTLUN is not 
> >	 set.
> >	 * Also allow SCSI-2 and unknown devices if BLIST_REPORTLUN2 is set
> >	 * and host adapter supports more than 8 LUNs.
> >	 */
> >	if ((bflags & BLIST_NOREPORTLUN)
> >		return 1;
> >	if ((starget->scsi_level < SCSI_2) &&
> >			(starget->scsi_level != SCSI_UNKNOWN))
> >		return 1;
> >	if ((starget->scsi_level < SCSI_3) &&
> >			(!(bflags & BLIST_REPORTLUN2) || shost->max_lun <= 
> >			8))
> >		return 1;
> >
> >
> 
> Attached,, new patch version 3....

> --- linux-2.6.16_org/drivers/scsi/scsi.c	2006-03-20 06:53:29.000000000 +0100
> +++ linux-2.6.16/drivers/scsi/scsi.c	2006-03-30 17:29:26.000000000 +0200
> @@ -567,7 +567,7 @@
>  	/* 
>  	 * If SCSI-2 or lower, store the LUN value in cmnd.
>  	 */
> -	if (cmd->device->scsi_level <= SCSI_2) {
> +	if ((cmd->device->scsi_level <= SCSI_2) && (cmd->device->scsi_level != SCSI_UNKNOWN)) {

Oh, could you break the line so it doesn't go over 80 columns?

>  		sdev->select_no_atn = 1;
>  
>  	/*
> +	* Maximum 512K cdb transfer length
> +	* broken RA4x00 Compaq Disk Array
> +	*/
> +	sdev->max_xfer_len = 0xffff;
> +	if (*bflags & BLIST_MAX_512K) {
> +		sdev->max_xfer_len = 0x200;
> +	}

Do we need the comment?  We don't need the braces.

> +	if (starget->scsi_level < SCSI_3 &&
> +			((!(bflags & BLIST_REPORTLUN2) &&
> +			(starget->scsi_level != SCSI_UNKNOWN)) ||
> +			shost->max_lun <= 8))

Why do we need the SCSI_UNKNOWN check here?

>   *	   Support 32k/1M disks.
> + *	 - Added Compaq RA4x00 Fiber Channel Array support, 29.03.2006
> + *	   crossip communications gmbh - Ingo Flaschberger <if@xip.at>
>   *

This doesn't really describe what you've done to this file.  It's more
 - Limit maximum transfers to new field in scsi_device
... or something

> @@ -89,6 +89,7 @@
>  				 * scsi_devinfo.[hc]. For now used only to
>  				 * pass settings from slave_alloc to scsi
>  				 * core. */
> +	unsigned short max_xfer_len;	/* Maximum xfer length in one cdb */
>  	unsigned writeable:1;
>  	unsigned removable:1;
>  	unsigned changed:1;	/* Data invalid due to media change */

I think you missed my point about where to place it -- due to padding
rules, you've grown the structure by 4 bytes.  If you put it between
current_cmnd and queue_depth, you won't grow the struct at all.


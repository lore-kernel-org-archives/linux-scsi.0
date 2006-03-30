From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: Compaq Fiber Channel Array RM4000 / 2.6.16 kernel patch
Date: Thu, 30 Mar 2006 05:58:16 -0700
Message-ID: <20060330125816.GG13590@parisc-linux.org>
References: <1143653396.3248.34.camel@mulgrave.il.steeleye.com> <Pine.GSO.4.64.0603291949370.4009@filebunker.xip.at> <1143656547.3248.36.camel@mulgrave.il.steeleye.com> <Pine.GSO.4.64.0603292025500.4009@filebunker.xip.at> <1143657838.3248.39.camel@mulgrave.il.steeleye.com> <Pine.GSO.4.64.0603292052430.4009@filebunker.xip.at> <1143659029.3248.42.camel@mulgrave.il.steeleye.com> <Pine.GSO.4.64.0603292125370.4009@filebunker.xip.at> <1143666681.3248.48.camel@mulgrave.il.steeleye.com> <Pine.GSO.4.64.0603301252100.595@filebunker.xip.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:57756 "EHLO
	palinux.hppa") by vger.kernel.org with ESMTP id S932194AbWC3M6R
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Mar 2006 07:58:17 -0500
Content-Disposition: inline
In-Reply-To: <Pine.GSO.4.64.0603301252100.595@filebunker.xip.at>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ingo Flaschberger <if@xip.at>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, Mar 30, 2006 at 12:53:10PM +0200, Ingo Flaschberger wrote:
>   *  out_of_space hacks, D. Gilbert (dpg) 990608
> + *
> + *  Added Compaq RA4x00 Fiber Channel Array support, 29.03.2006
> + *	crossip communications gmbh - Ingo Flaschberger <if@xip.at>
> + *
>   */

I think you can drop the changelog entry here -- it's not been updated
in many years.  Plus, it's not really accurate.

>  	{"CNSi", "G8324", NULL, BLIST_SPARSELUN},	/* Chaparral G8324 RAID */
> +	{"COMPAQ", "ARRAY CONTROLLER", "2.60", BLIST_SPARSELUN | BLIST_LARGELUN |
> +		BLIST_MAX_512K}, /* Compaq RA4x00 */
> +	{"COMPAQ", "LOGICAL VOLUME", "2.60", BLIST_MAX_512K}, /* Compaq RA4x00 */
>  	{"COMPAQ", "LOGICAL VOLUME", NULL, BLIST_FORCELUN},

I wonder if you should just be adding BLIST_MAX_512K to the current
entry for LOGICAL VOLUME instead?

>   * 		or a LUN is seen that cannot have a device attached to it.
> + * 
> + * Modification history:
> + * 	- Added Compaq RA4x00 Fiber Channel Array support, 29.03.2006
> + *		crossip communications gmbh - Ingo Flaschberger <if@xip.at>
> + *
>   */

Definitely don't start a changelog.  That's what SCMs are for.

> @@ -715,6 +721,14 @@
>  	if (*bflags & BLIST_SELECT_NO_ATN)
>  		sdev->select_no_atn = 1;
>  
> +        /*
> +        * Maximum 512K cdb transfer length
> +        * broken RA4x00 Compaq Disk Array
> +        */
> +        if (*bflags & BLIST_MAX_512K) {
> +                sdev->max_512k = 1;
> +        }
> +

Indent with tabs, not spaces.  Also, sdev->max_512k is a bit ...
specific.  How about adding an unsigned short to struct scsi_device
(right above queue_depth, so it fits in the padding) called something
like max_xfer_len?  Then you can do something like:

	sdev->max_xfer_len = 0xffff;
	if (*bflags & BLIST_MAX_512K)
		sdev->max_xfer_len = 0x200;

and later:

> @@ -344,8 +346,14 @@
>  		SCpnt->cmnd[14] = SCpnt->cmnd[15] = 0;
>  	} else if ((this_count > 0xff) || (block > 0x1fffff) ||
>  		   SCpnt->device->use_10_for_rw) {
> -		if (this_count > 0xffff)
> -			this_count = 0xffff;
> +		if (SCpnt->device->max_512k) {
> +			if (this_count > 0x200) {
> +				this_count = 0x200;
> +			}
> +		} else {
> +			if (this_count > 0xffff)
> +				this_count = 0xffff;
> +		}
>  
>  		SCpnt->cmnd[0] += READ_10 - READ_6;
>  		SCpnt->cmnd[1] |= blk_fua_rq(rq) ? 0x8 : 0;

simplifies to:

	if (this_count > SCpnt->device->max_xfer_len)
		this_count = SCpnt->device->max_xfer_len;

> @@ -1089,9 +1103,12 @@
>  	 * support more than 8 LUNs.
>  	 */
>  	if ((bflags & BLIST_NOREPORTLUN) || 
> -	     starget->scsi_level < SCSI_2 ||
> -	    (starget->scsi_level < SCSI_3 && 
> -	     (!(bflags & BLIST_REPORTLUN2) || shost->max_lun <= 8)) )
> +            ((starget->scsi_level < SCSI_2) &&
> +            (starget->scsi_level != SCSI_UNKNOWN)) ||
> +            (starget->scsi_level < SCSI_3 &&
> +            ((!(bflags & BLIST_REPORTLUN2) && 
> +	    (starget->scsi_level != SCSI_UNKNOWN)) || 
> +	    shost->max_lun <= 8)) )
>  		return 1;

That conditional makes my brain hurt.  Can we split it up?

	if ((bflags & BLIST_NOREPORTLUN)
		return 1;
	if ((starget->scsi_level < SCSI_2) &&
			(starget->scsi_level != SCSI_UNKNOWN))
		return 1;
	if ((starget->scsi_level < SCSI_3) &&
	    ((!(bflags & BLIST_REPORTLUN2) &&
	      (starget->scsi_level != SCSI_UNKNOWN) ||
	      shost->max_lun <= 8)))
	      	return 1;

I'm not sure that's what you meant to do, even.  How about more simply:

	/*
	 * Only support SCSI-3 and up devices if BLIST_NOREPORTLUN is not set.
	 * Also allow SCSI-2 and unknown devices if BLIST_REPORTLUN2 is set
	 * and host adapter supports more than 8 LUNs.
	 */
	if ((bflags & BLIST_NOREPORTLUN)
		return 1;
	if ((starget->scsi_level < SCSI_2) &&
			(starget->scsi_level != SCSI_UNKNOWN))
		return 1;
	if ((starget->scsi_level < SCSI_3) &&
			(!(bflags & BLIST_REPORTLUN2) || shost->max_lun <= 8))
		return 1;


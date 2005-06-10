From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] Sanitize PQ3 device handling (Take #2)
Date: Fri, 10 Jun 2005 16:52:02 -0500
Message-ID: <1118440323.5031.41.camel@mulgrave>
References: <428CA4E3.9030601@suse.de> <20050520214030.GA8925@us.ibm.com>
	 <4292E4BA.5040001@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:14785 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261255AbVFJVwJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Jun 2005 17:52:09 -0400
In-Reply-To: <4292E4BA.5040001@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, 2005-05-24 at 10:24 +0200, Hannes Reinecke wrote:
> -		printk(KERN_INFO "scsi: unknown device type %d\n", sdev->type);
> +		if (sdev->inq_periph_qual != 1 && sdev->inq_periph_qual != 3)
> +			printk(KERN_INFO "scsi: unknown device type %d\n", sdev->type);

The device type for PQ1 should be reliable, it's only PQ3 that has 0x1f

Also, we have defines for this (SCSI_INQ_PQ_NOT_CON and
SCSI_INQ_PQ_NOT_CAP)

>  	if (res == SCSI_SCAN_LUN_PRESENT) {
> -		if (scsi_report_lun_scan(sdev, bflags, rescan) != 0)
> +		if (scsi_report_lun_scan(sdev, bflags, rescan) != 0) {
>  			/*
>  			 * The REPORT LUN did not scan the target,
>  			 * do a sequential scan.
>  			 */
> +			if (res == SCSI_SCAN_LUN_IGNORED)

This condition is impossible.

> +				/*
> +				 * There's a target here, but lun 0 is not 
> +				 * connected to a device and does not support
> +				 * the report_lun scan.  Fall back to a 
> +				 * sequential lun scan with a bflags of 
> +				 * SPARSELUN.
> +				 *
> +				 * The old code also used a default scsi level
> +				 * of SCSI_2 which seems a bit spurious. Any
> +				 * misbehaving device should rather be added
> +				 * to the blacklist.
> +				 */
> +				bflags |= BLIST_SPARSELUN;

The reason the old code did all that is because the inquiry data of a
PQ3 device isn't credible and shouldn't be acted on.

>  			scsi_sequential_lun_scan(starget, bflags,
>  				       	res, sdev->scsi_level, rescan);

If you really have the SCSI_SCAN_LUN_IGNORED case here, you've already
released sdev in scsi_probe_and_add_lun, so you can't use it here.

Finally, I think you should probably update the scsi_match function not
to attach on PQ3, just in case someone violates spec and has a valid
type.

James



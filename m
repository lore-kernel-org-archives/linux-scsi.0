From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Sanitize PQ3 device handling
Date: Wed, 18 May 2005 15:01:40 +0100
Message-ID: <20050518140140.GA22570@infradead.org>
References: <428B0E4D.50505@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:9957 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S262216AbVEROBv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 May 2005 10:01:51 -0400
Content-Disposition: inline
In-Reply-To: <428B0E4D.50505@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

>  	res = scsi_probe_and_add_lun(starget, 0, &bflags, &sdev, rescan, NULL);
> -	if (res == SCSI_SCAN_LUN_PRESENT) {
> -		if (scsi_report_lun_scan(sdev, bflags, rescan) != 0)
> +	if (res != SCSI_SCAN_NO_RESPONSE) {
> +		if (scsi_report_lun_scan(sdev, bflags, rescan) != 0) {
>  			/*
>  			 * The REPORT LUN did not scan the target,
>  			 * do a sequential scan.
>  			 */
> +			if (res == SCSI_SCAN_TARGET_PRESENT)
> +				/*
> +				 * There's a target here, but lun 0 is 
> +				 * offline so we can't use the report_lun
> +				 * scan.  Fall back to a sequential lun scan
> +				 * with a bflags of SPARSELUN.
> +				 *
> +				 * The old code also used a default scsi level
> +				 * of SCSI_2 which seems a bit spurious. Any
> +				 * misbehaving device should rather be added
> +				 * to the blacklist.
> +				 */
> +				bflags |= BLIST_SPARSELUN;
> +
>  			scsi_sequential_lun_scan(starget, bflags,
>  				       	res, sdev->scsi_level, rescan);

If scsi_probe_and_add_lun returns SCSI_SCAN_TARGET_PRESENT sdev isn't valid at
this point.  You should probably default to SCSI_2 for that case.


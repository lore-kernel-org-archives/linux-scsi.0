From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 04/23] scsi_dh_alua: use standard logging functions
Date: Tue, 1 Sep 2015 11:48:21 +0200
Message-ID: <20150901094821.GC9485@lst.de>
References: <1440679281-13234-1-git-send-email-hare@suse.de> <1440679281-13234-5-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:34469 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755300AbbIAJsX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Sep 2015 05:48:23 -0400
Content-Disposition: inline
In-Reply-To: <1440679281-13234-5-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org

On Thu, Aug 27, 2015 at 02:41:02PM +0200, Hannes Reinecke wrote:
>  		}
>  
>  		err = alua_check_sense(sdev, &sense_hdr);
> -		if (err == ADD_TO_MLQUEUE && time_before(jiffies, expiry))
> +		if (err == ADD_TO_MLQUEUE && time_before(jiffies, expiry)) {
> +			sdev_printk(KERN_ERR, sdev, "%s: rtpg retry\n",
> +				    ALUA_DH_NAME);
> +			scsi_print_sense_hdr(sdev, ALUA_DH_NAME, &sense_hdr);
>  			goto retry;
> -		sdev_printk(KERN_INFO, sdev,
> -			    "%s: rtpg sense code %02x/%02x/%02x\n",
> -			    ALUA_DH_NAME, sense_hdr.sense_key,
> -			    sense_hdr.asc, sense_hdr.ascq);
> -		err = SCSI_DH_IO;
> +		}
> +		sdev_printk(KERN_ERR, sdev, "%s: rtpg failed\n",
> +			    ALUA_DH_NAME);
> +		scsi_print_sense_hdr(sdev, ALUA_DH_NAME, &sense_hdr);
> +		return SCSI_DH_IO;
>  	}
> -	if (err != SCSI_DH_OK)
> -		return err;

I think you need to keep this if, given that submit_rtpg can return
others error than SCSI_DH_IO as well.

While you're at it you might remove the h->senselen check, and
kill the assignment of the scsi_normalize_sense bool return value
to the err variable similar to how you did in stpg_endio. 

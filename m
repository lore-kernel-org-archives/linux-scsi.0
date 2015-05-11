From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 03/17] scsi_dh_alua: Use vpd_pg83 information
Date: Mon, 11 May 2015 08:48:48 +0200
Message-ID: <20150511064848.GC30516@lst.de>
References: <1430743343-47174-1-git-send-email-hare@suse.de> <1430743343-47174-4-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:38969 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752544AbbEKGst (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 May 2015 02:48:49 -0400
Content-Disposition: inline
In-Reply-To: <1430743343-47174-4-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

> @@ -352,55 +315,42 @@ static int alua_check_tpgs(struct scsi_device *sdev, struct alua_dh_data *h)
>  		sdev_printk(KERN_INFO, sdev, "%s: supports implicit TPGS\n",
>  			    ALUA_DH_NAME);
>  		break;
> -	default:
> -		h->tpgs = TPGS_MODE_NONE;
> +	case TPGS_MODE_NONE:
>  		sdev_printk(KERN_INFO, sdev, "%s: not supported\n",
>  			    ALUA_DH_NAME);
>  		err = SCSI_DH_DEV_UNSUPP;
>  		break;
> +	default:
> +		sdev_printk(KERN_INFO, sdev,
> +			    "%s: unsupported TPGS setting %d\n",
> +			    ALUA_DH_NAME, h->tpgs);
> +		h->tpgs = TPGS_MODE_NONE;
> +		err = SCSI_DH_DEV_UNSUPP;
> +		break;

Can you split this into a separate patch, please?

Otherwise looks fine, so:

Reviewed-by: Christoph Hellwig <hch@lst.de>

for both resulting patches.

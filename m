From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH] convert 53c700 driver to use change_queue_depth API
Date: Mon, 20 Dec 2004 17:04:21 +0100 (CET)
Message-ID: <Pine.LNX.4.60.0412201700350.16691@poirot.grange>
References: <1102812847.5232.6.camel@mulgrave> <Pine.LNX.4.60.0412201605360.15046@poirot.grange>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pop.gmx.net ([213.165.64.20]:56220 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S261547AbULTQE6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Dec 2004 11:04:58 -0500
In-Reply-To: <Pine.LNX.4.60.0412201605360.15046@poirot.grange>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, 20 Dec 2004, Guennadi Liakhovetski wrote:

> Shouldn't it really be something like
> 
>  	if(depth > NCR_700_MAX_TAGS)
> -		return -EINVAL;
> +		depth = NCR_700_MAX_TAGS;
> +	if (depth < 0)
> +		depth = 0;

Ahh, yeah, sure, because of the simple_strtoul incompatibility with glibc 
this check is superfluous, but, the below doubt still remains

>  	scsi_adjust_queue_depth(SDp, MSG_ORDERED_TAG, depth);
>  
> -	return count;
> +	return SDp->queue_depth == depth ? depth : -EFAIL;
>  }
> 


Thanks
Guennadi
---
Guennadi Liakhovetski


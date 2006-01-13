From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] remove target parent limitiation
Date: Fri, 13 Jan 2006 12:22:02 -0600
Message-ID: <43C7EFCA.4020908@cs.wisc.edu>
References: <20060113180400.GA3509@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:34226 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S1422798AbWAMSWV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Jan 2006 13:22:21 -0500
In-Reply-To: <20060113180400.GA3509@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James.Bottomley@steeleye.com, Eric.Moore@lsil.com, James.Smart@Emulex.Com, linux-scsi@vger.kernel.org

Christoph Hellwig wrote:
> ===================================================================
> --- scsi-misc-2.6.orig/drivers/scsi/scsi_scan.c	2006-01-13 17:55:57.000000000 +0100
> +++ scsi-misc-2.6/drivers/scsi/scsi_scan.c	2006-01-13 18:26:17.000000000 +0100
> @@ -334,19 +334,6 @@
>  	struct scsi_target *starget;
>  	struct scsi_target *found_target;
>  
> -	/*
> -	 * Obtain the real parent from the transport. The transport
> -	 * is allowed to fail (no error) if there is nothing at that
> -	 * target id.
> -	 */
> -	if (shost->transportt->target_parent) {
> -		spin_lock_irqsave(shost->host_lock, flags);
> -		parent = shost->transportt->target_parent(shost, channel, id);
> -		spin_unlock_irqrestore(shost->host_lock, flags);
> -		if (!parent)
> -			return NULL;
> -	}


Should we remove the target_parent callout from the trasnport_template 
since it is no longer used or does it make sense to keep it as part of 
the API?

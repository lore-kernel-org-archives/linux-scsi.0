From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] Restart scsi_device_lookup_by_target
Date: Tue, 13 Jan 2009 06:58:56 -0700
Message-ID: <20090113135856.GE29283@parisc-linux.org>
References: <496C9C26.9020106@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:41442 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752119AbZAMN65 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Jan 2009 08:58:57 -0500
Content-Disposition: inline
In-Reply-To: <496C9C26.9020106@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, Jan 13, 2009 at 02:50:30PM +0100, Hannes Reinecke wrote:
> @@ -1131,14 +1137,15 @@ EXPORT_SYMBOL(__scsi_device_lookup_by_target);
>  struct scsi_device *scsi_device_lookup_by_target(struct scsi_target *starget,
>  						 uint lun)
>  {
> -	struct scsi_device *sdev;
> +	struct scsi_device *sdev = NULL;
>  	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
>  	unsigned long flags;
>  
>  	spin_lock_irqsave(shost->host_lock, flags);
> -	sdev = __scsi_device_lookup_by_target(starget, lun);
> + restart:
> +	sdev = __scsi_device_lookup_by_target(starget, sdev, lun);
>  	if (sdev && scsi_device_get(sdev))
> -		sdev = NULL;
> +		goto restart;
>  	spin_unlock_irqrestore(shost->host_lock, flags);
>  
>  	return sdev;

Backwards jumps are generally disapproved of.  How about:

	spin_lock_irqsave(shost->host_lock, flags);
	for (;;) {
		sdev = __scsi_device_lookup_by_target(starget, sdev, lun);
		if (!sdev || !scsi_device_get(sdev))
			break;
	}
	spin_unlock_irqrestore(shost->host_lock, flags);


-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."

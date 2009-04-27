From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [RFC][PATCH] limit state change to SDEV_BLOCK devices in scsi_internal_device_unblock
Date: Mon, 27 Apr 2009 12:03:00 -0600
Message-ID: <20090427180300.GH1926@parisc-linux.org>
References: <49F5E6E5.20904@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:41420 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751857AbZD0SDC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Apr 2009 14:03:02 -0400
Content-Disposition: inline
In-Reply-To: <49F5E6E5.20904@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Takahiro Yasui <tyasui@redhat.com>
Cc: linux-scsi@vger.kernel.org, mchristi@redhat.com, mbarrow@redhat.com

On Mon, Apr 27, 2009 at 01:09:57PM -0400, Takahiro Yasui wrote:
> @@ -2633,9 +2633,12 @@ scsi_internal_device_unblock(struct scsi
>  	unsigned long flags;
>  	
>  	/* 
> -	 * Try to transition the scsi device to SDEV_RUNNING
> -	 * and goose the device queue if successful.  
> +	 * Try to transition the scsi device to SDEV_RUNNING if it is
> +	 * SDEV_BLOCK and goose the device queue if successful.

I think the code looks good, but the edit to the comment dilutes its
flavour somewhat.  How about just moving the comment down below the
check, and then you don't need to edit the comment at all?

>  	 */
> +	if (sdev->sdev_state != SDEV_BLOCK)
> +		return 0;
> +
>  	err = scsi_device_set_state(sdev, SDEV_RUNNING);
>  	if (err) {
>  		err = scsi_device_set_state(sdev, SDEV_CREATED);
> 
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."

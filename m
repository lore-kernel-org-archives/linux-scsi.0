From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] scsi core: fix uninitialized variable error
Date: Sun, 5 Feb 2006 11:11:24 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0602051107120.16521-100000@netrider.rowland.org>
References: <20060205150133.GC16090@parisc-linux.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.rowland.org ([192.131.102.7]:13828 "HELO mx1.rowland.org")
	by vger.kernel.org with SMTP id S1750887AbWBEQL0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 5 Feb 2006 11:11:26 -0500
In-Reply-To: <20060205150133.GC16090@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Sun, 5 Feb 2006, Matthew Wilcox wrote:

> Seems to me it'd be much easier just  to initialise sdev to
> ERR_PTR(-ENODEV) at the top of the function.  That way, __scsi_add_device
> doesn't need to know what the return codes from scsi_probe_and_add_lun
> mean.  Something like this (untested):

> @@ -1278,12 +1277,8 @@ struct scsi_device *__scsi_add_device(st
>  
>  	get_device(&starget->dev);
>  	mutex_lock(&shost->scan_mutex);
> -	if (scsi_host_scan_allowed(shost)) {
> -		res = scsi_probe_and_add_lun(starget, lun, NULL, &sdev, 1,
> -					     hostdata);
> -		if (res != SCSI_SCAN_LUN_PRESENT)
> -			sdev = ERR_PTR(-ENODEV);
> -	}
> +	if (scsi_host_scan_allowed(shost))
> +		scsi_probe_and_add_lun(starget, lun, NULL, &sdev, 1, hostdata);
>  	mutex_unlock(&shost->scan_mutex);
>  	scsi_target_reap(starget);
>  	put_device(&starget->dev);

This assumes that scsi_probe_and_add_lun doesn't assign anything to the 
&sdev pointer if it returns anything other than SCSI_SCAN_LUN_PRESENT.  
Since that assumption is true for the current code, this version of the 
patch will work as well as mine.

Alan Stern


From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: cciss kexec reset_devices commit
Date: Fri, 27 Feb 2009 08:03:54 +0100
Message-ID: <20090227070354.GW6602@kernel.dk>
References: <49A72F6A.3000904@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([93.163.65.50]:35223 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753728AbZB0HD4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Feb 2009 02:03:56 -0500
Content-Disposition: inline
In-Reply-To: <49A72F6A.3000904@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: scsi <linux-scsi@vger.kernel.org>, Mike Miller <mike.miller@hp.com>

On Thu, Feb 26 2009, Randy Dunlap wrote:
> Was commit 5e4c91c84b194b26cf592779e451f4b5be777cba supposed to remove
> the unconditional 30-second delay and replace it with a timeout loop?
> 
> What I see now (in source code) is the 30-second delay followed by
> 30 1-second retries...???
> 
> 
>  		schedule_timeout_uninterruptible(30*HZ);
>  
>  		/* Now try to get the controller to respond to a no-op */
> -		for (i=0; i<12; i++) {
> +		for (i=0; i<30; i++) {
>  			if (cciss_noop(pdev) == 0)
>  				break;
> -			else
> -				printk("cciss: no-op failed%s\n", (i < 11 ? "; re-trying" : ""));
> +
> +			schedule_timeout_uninterruptible(HZ);
> +		}
> +		if (i == 30) {
> +			printk(KERN_ERR "cciss: controller seems dead\n");
> +			return -EBUSY;
>  		}
>  	}

Good catch Randy, that first sleep should have gone away of course. I'll
kill it.

-- 
Jens Axboe


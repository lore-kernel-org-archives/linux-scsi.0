From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 25/20] sysfs: Only support removing emtpy sysfs  directories.
Date: Tue, 26 May 2009 17:39:29 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0905261726300.11998-100000@iolanthe.rowland.org>
References: <1243372199.2815.77.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:57311 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754938AbZEZVj2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 26 May 2009 17:39:28 -0400
In-Reply-To: <1243372199.2815.77.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>, SCSI development list <linux-scsi@vger.kernel.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Andrew Morton <akpm@linux-foundation.org>, Greg Kroah-Hartman <gregkh@suse.de>, Kernel development list <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>, Cornelia Huck <cornelia.huck@de.ibm.com>, linux-fsdevel@vger.kernel.org, "Eric W. Biederman" <ebiederm@aristanetworks.com>

On Tue, 26 May 2009, James Bottomley wrote:

> Um, well, you're right, it's wrong.  The reap needs to be matched with
> the reap_ref++

I was afraid of that.  Not understanding how the reap_ref counts are 
supposed to work makes it hard to get them right...

> It's hard to follow the problem without full context, but if I
> understand correctly the problem is you want all the target directories
> removed before you call device_del() on the host and the thing that gets
> in the way is the necessary user context removal of the host.

Removal of the _target_, not the host.  (Do targets ever get reaped
from non-process context?  I didn't notice any places where that would
happen.)

That's part of the problem.  The other part is that the target isn't
unregistered until all the sdevs have been released, which might not
happen for a long time if the sdevs are pinned for any reason.

That is, the target should be unregistered when all the sdevs are
deleted, in __scsi_remove_device(), not when scsi_device_dev_release()  
or scsi_device_dev_release_usercontext() runs.

>  So a
> simple solution, rather than mucking with the way it works, is to wait
> for the workqueues to complete.  Does this fix it?
> 
> James
> 
> ---
> 
> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index c447838..5846c26 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -1877,6 +1877,12 @@ void scsi_forget_host(struct Scsi_Host *shost)
>  		goto restart;
>  	}
>  	spin_unlock_irqrestore(shost->host_lock, flags);
> +
> +	/*
> +	 * the sdev removal goes through a workqueue for user context, so
> +	 * make sure it's all complete before we return
> +	 */
> +	flush_scheduled_work();
>  }
>  
>  /*

This may well fix Kay's problem, but I think the other point needs to 
be addressed also.

Alan Stern


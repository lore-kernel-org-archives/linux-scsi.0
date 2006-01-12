From: Jens Axboe <axboe@suse.de>
Subject: Re: [patch] Mask capabilities for SCSI-1 CD drive
Date: Thu, 12 Jan 2006 08:41:02 +0100
Message-ID: <20060112074102.GC17718@suse.de>
References: <200601112359_MC3-1-B5B7-409F@compuserve.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:52516 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S1750824AbWALHjM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 Jan 2006 02:39:12 -0500
Content-Disposition: inline
In-Reply-To: <200601112359_MC3-1-B5B7-409F@compuserve.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chuck Ebbert <76306.1226@compuserve.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

On Wed, Jan 11 2006, Chuck Ebbert wrote:
> SCSI-1 CD drives can't do MRW or be opened for writing, so mask off
> those capabilities.
> 
> Signed-off-by: Chuck Ebbert <76306.1226@compuserve.com>
> 
> --- 2.6.15a.orig/drivers/scsi/sr.c
> +++ 2.6.15a/drivers/scsi/sr.c
> @@ -762,8 +762,9 @@ static void get_capabilities(struct scsi
>  		/* failed, drive doesn't have capabilities mode page */
>  		cd->cdi.speed = 1;
>  		cd->cdi.mask |= (CDC_CD_R | CDC_CD_RW | CDC_DVD_R |
> -					 CDC_DVD | CDC_DVD_RAM |
> -					 CDC_SELECT_DISC | CDC_SELECT_SPEED);
> +				 CDC_DVD | CDC_DVD_RAM |
> +				 CDC_SELECT_DISC | CDC_SELECT_SPEED |
> +				 CDC_MRW | CDC_MRW_W | CDC_RAM);
>  		kfree(buffer);
>  		printk("%s: scsi-1 drive\n", cd->cdi.name);
>  		return;

Looks fine, thanks.

Acked-by: Jens Axboe <axboe@suse.de>

-- 
Jens Axboe


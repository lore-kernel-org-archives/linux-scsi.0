From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH] 2.4.X Avoid excessive recursion when setting device offline
Date: Tue, 30 Mar 2004 09:03:53 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040330070353.GN24370@suse.de>
References: <387680000.1080580020@aslan.btc.adaptec.com> <1080581208.3570.10.camel@laptop.fenrus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:49115 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S263304AbUC3HEC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Mar 2004 02:04:02 -0500
Content-Disposition: inline
In-Reply-To: <1080581208.3570.10.camel@laptop.fenrus.com>
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjanv@redhat.com>
Cc: "Justin T. Gibbs" <Justin_Gibbs@adaptec.com>, linux-scsi@vger.kernel.org

On Mon, Mar 29 2004, Arjan van de Ven wrote:
> On Mon, 2004-03-29 at 19:07, Justin T. Gibbs wrote:
> > How to reproduce: Queue up lots of I/O to a device.  Set that device
> > 		  offline.
> > 
> > Result: The SCSI mid-layer blows out the kernel stack due to the inherent
> > 	recursion in its request function.  The repeating stack trace goes
> > 	something like:
> > 
> > 	scsi_request_fn
> > 	__scsi_end_request
> > 	scsi_release_command
> > 	scsi_queue_next_request
> > 	scsi_request_fn
> > 	...
> > 
> > This patch prevents recursive calls through the scsi_request_fn
> > for the same queue:
> 
> won't this achieve the same ?
> 
> diff -urN Linux/drivers/scsi/scsi_lib.c linux/drivers/scsi/scsi_lib.c
> --- Linux/drivers/scsi/scsi_lib.c       2002-10-03 16:50:07.000000000
> +0200
> +++ linux/drivers/scsi/scsi_lib.c       2002-10-03 17:33:20.000000000
> +0200
> @@ -442,7 +442,7 @@
>          * This will goose the queue request function at the end, so we
> don't
>          * need to worry about launching another command.
>          */
> -       scsi_release_command(SCpnt);
> +       __scsi_release_command(SCpnt);
>   
>         if( frequeue ) {
>                 request_queue_t *q;
> 

> diff -urN Linux/drivers/scsi/scsi_lib.c linux/drivers/scsi/scsi_lib.c
> --- Linux/drivers/scsi/scsi_lib.c	2002-10-03 16:50:07.000000000 +0200
> +++ linux/drivers/scsi/scsi_lib.c	2002-10-03 17:33:20.000000000 +0200
> @@ -442,7 +442,7 @@
>  	 * This will goose the queue request function at the end, so we don't
>  	 * need to worry about launching another command.
>  	 */
> -	scsi_release_command(SCpnt);
> +	__scsi_release_command(SCpnt);
>  
>  	if( frequeue ) {
>  		request_queue_t *q;

That is better. If SCSI used blk_start_queue/stop_queue, it has
recursion detection as well (only allowing one reenter).

-- 
Jens Axboe


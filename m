From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] sd: error handling during flushing caches
Date: Tue, 24 Sep 2013 15:41:20 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1309241537440.865-100000@iolanthe.rowland.org>
References: <1379330895-20505-1-git-send-email-oliver@neukum.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:42576 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750774Ab3IXTlV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Sep 2013 15:41:21 -0400
In-Reply-To: <1379330895-20505-1-git-send-email-oliver@neukum.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: oliver@neukum.org
Cc: linux-scsi@vger.kernel.org, hare@suse.de, luto@amacapital.net, Oliver Neukum <oneukum@suse.de>

On Mon, 16 Sep 2013 oliver@neukum.org wrote:

> From: Oliver Neukum <oneukum@suse.de>
> 
> It makes no sense to flush the cache of a device without medium.
> Errors during suspend must be handled according to their causes.
> Errors due to missing media or unplugged devices must be ignored.
> Errors due to devices being offlined must also be ignored.
> The error returns must be modified so that the generic layer
> understands them.
> 
> Signed-off-by: Oliver Neukum <oneukum@suse.de>

Acked-by: Alan Stern <stern@rowland.harvard.edu>

You might want to change the formatting slightly...

> @@ -1448,12 +1448,31 @@ static int sd_sync_cache(struct scsi_disk *sdkp)
>  
>  	if (res) {
>  		sd_print_result(sdkp, res);
> -		if (driver_byte(res) & DRIVER_SENSE)
> +
> +		if (driver_byte(res) & DRIVER_SENSE) 
>  			sd_print_sense_hdr(sdkp, &sshdr);
> +		/* we need to evaluate the error return  */
> +		if ((scsi_sense_valid(&sshdr) &&
> +			/* 0x3a is medium not present */
> +			sshdr.asc == 0x3a))
> +				/* this is no error here */
> +				return 0;

There's a superfluous pair of parens in the "if" condition.  The same 
is true for the statement added to sd_start_stop_device().

Also, the indentation levels aren't quite right (the "return" statement
should be indented by only one additional tab stop, not two).

Of course, these are both extremely minor objections.

Alan Stern


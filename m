From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH] megaraid2 bad queuecommand return
Date: Fri, 19 Nov 2004 16:04:17 +0100
Message-ID: <20041119150417.GN26240@suse.de>
References: <0E3FA95632D6D047BA649F95DAB60E570562CAF1@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:17888 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S261435AbUKSPEv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Nov 2004 10:04:51 -0500
Content-Disposition: inline
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E570562CAF1@exa-atlanta>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Mukker, Atul" <Atulm@lsil.com>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, 'James Bottomley' <James.Bottomley@steeleye.com>

On Fri, Nov 19 2004, Mukker, Atul wrote:
> Linux/Documentation/scsi/scsi_mid_low_api.txt
> 
> "
> ...
> /**
>  *      queuecommand - queue scsi command, invoke 'done' on completion
>  *      @scp: pointer to scsi command object
>  *      @done: function pointer to be invoked on completion
> ...
>  *
>  *      Returns 0 on success.
>  *
>  *      If there's a failure, return either:
>  *
>  *      SCSI_MLQUEUE_DEVICE_BUSY if the device queue is full, or
>  *      SCSI_MLQUEUE_HOST_BUSY if the entire host queue is full
>  *
>  *      On both of these returns, the mid-layer will requeue the I/O
> ...
> "
> 
> So the driver should set the if_busy flag to SCSI_MLQUEUE_DEVICE_BUSY or
> SCSI_MLQUEUE_HOST_BUSY (this is appropriate in this case) instead of setting
> it to 1, isn't it?
> 
> So, the following seems more appropriate
> 
> --- megaraid_mbox.c     2004-09-27 22:14:43.000000000 -0400
> +++ megaraid_mbox.c.mod 2004-11-19 12:15:21.776345776 -0500
> @@ -1675,7 +1675,7 @@
> 
>                         if (!(scb = megaraid_alloc_scb(adapter, scp))) {
>                                 scp->result = (DID_ERROR << 16);
> -                               *busy = 1;
> +                               *busy = SCSI_MLQUEUE_HOST_BUSY;
>                                 return NULL;
>                         }
> 

Nope doesn't work, only if you kill the done() call as well. non-zero
return will always trigger a requeue, which your SCSI done has alread
done. This is the bug.

-- 
Jens Axboe


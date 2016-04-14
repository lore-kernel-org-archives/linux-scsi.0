From: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Subject: Re: [-next] BUG_ON in scsi_target_destroy()
Date: Thu, 14 Apr 2016 11:07:52 +0900
Message-ID: <20160414020752.GA516@swordfish>
References: <20160411090146.GA537@swordfish>
 <2201725.I2to9GCRQJ@c203>
 <1460560474.2322.3.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-next-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1460560474.2322.3.camel@linux.vnet.ibm.com>
Sender: linux-next-owner@vger.kernel.org
To: James Bottomley <jejb@linux.vnet.ibm.com>
Cc: Johannes Thumshirn <jthumshirn@suse.de>, Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>, "Ewan D. Milne" <emilne@redhat.com>, Hannes Reinecke <hare@suse.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Stephen Rothwell <sfr@canb.auug.org.au>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org, linux-next@vger.kernel.org, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Xiong Zhou <jencce.kernel@gmail.com>
List-Id: linux-scsi@vger.kernel.org

Hello,

On (04/13/16 08:14), James Bottomley wrote:
[..]
> How about good grief no!  A device with multiple targets will get it's
> lists screwed with this
> 
> The STARGET_REMOVE state you added only applies to the case we're
> trying to kill a target.  In the natural operation case, which is what
> everyone else is running into, we will try to remove a running target
> when it has no more scsi devices left on it.  So the correct patch
> should be to make the BUG_ON see this:

works for me.
Reported-and-tested-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>

	-ss

> James
> 
> ---
> 
> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index 27df7e7..e0a78f5 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -319,8 +319,7 @@ static void scsi_target_destroy(struct scsi_target *starget)
>  	struct Scsi_Host *shost = dev_to_shost(dev->parent);
>  	unsigned long flags;
>  
> -	BUG_ON(starget->state != STARGET_REMOVE &&
> -	       starget->state != STARGET_CREATED);
> +	BUG_ON(starget->state == STARGET_DEL);
>  	starget->state = STARGET_DEL;
>  	transport_destroy_device(dev);
>  	spin_lock_irqsave(shost->host_lock, flags);
> 

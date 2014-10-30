From: Meelis Roos <mroos@linux.ee>
Subject: Re: blk-mq problem on proliant DL380 G3 (cciss)
Date: Thu, 30 Oct 2014 19:32:52 +0200 (EET)
Message-ID: <alpine.LRH.2.11.1410301916490.13541@adalberg.ut.ee>
References: <alpine.LRH.2.11.1410291233090.12885@adalberg.ut.ee> <alpine.LRH.2.11.1410291344220.12885@adalberg.ut.ee> <545102FE.3010003@kernel.dk> <20141029183828.GA31689@infradead.org> <alpine.LRH.2.11.1410292205060.16678@adalberg.ut.ee> <54514A7A.8050008@kernel.dk>
 <alpine.LRH.2.11.1410301317340.19899@adalberg.ut.ee> <20141030151955.GA12158@infradead.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:37161 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758954AbaJ3Rc4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Oct 2014 13:32:56 -0400
In-Reply-To: <20141030151955.GA12158@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org

> can you try the patch below?  It's a hack and not a proper fix, but it
> addresses what seems to be your culprit, given that it is the only
> place allocating a request from the error handler.

Applied it on top of 3.18-rc2, booted with scsi_mod.use_blk_mq=1 and it 
booted up fine.

> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index fa7b5ec..5804ea0 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -2010,6 +2010,7 @@ static void scsi_restart_operations(struct Scsi_Host *shost)
>  	struct scsi_device *sdev;
>  	unsigned long flags;
>  
> +#if 0
>  	/*
>  	 * If the door was locked, we need to insert a door lock request
>  	 * onto the head of the SCSI request queue for the device.  There
> @@ -2019,6 +2020,7 @@ static void scsi_restart_operations(struct Scsi_Host *shost)
>  		if (scsi_device_online(sdev) && sdev->locked)
>  			scsi_eh_lock_door(sdev);
>  	}
> +#endif
>  
>  	/*
>  	 * next free up anything directly waiting upon the host.  this
> 

-- 
Meelis Roos (mroos@linux.ee)

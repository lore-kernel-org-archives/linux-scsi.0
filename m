From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] updated version of Jens' SATA suspend-to-ram patch
Date: Fri, 23 Sep 2005 16:47:27 -0400
Message-ID: <433469DF.1060900@pobox.com>
References: <20050923163334.GA13567@triplehelix.org> <20050923180711.GH22655@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20050923180711.GH22655@suse.de>
Sender: linux-ide-owner@vger.kernel.org
To: Jens Axboe <axboe@suse.de>, torvalds@osdl.org
Cc: joshk@triplehelix.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Jens Axboe wrote:
> On Fri, Sep 23 2005, Joshua Kwan wrote:
>>I had some time yesterday and decided to help Jens out by rediffing the
>>now-infamous SATA suspend-to-ram patch [1] against current git and
>>test-building it.

Very strange.  I cannot find this patch at all in my email folders.

Can someone resend it to me?



> --- linux-2.6.13/drivers/scsi/libata-core.c~	2005-09-01 12:22:19.000000000 +0200
> +++ linux-2.6.13/drivers/scsi/libata-core.c	2005-09-01 12:24:38.000000000 +0200
> @@ -3738,8 +3738,8 @@
>  	unsigned long flags;
>  	int rc;
>  
> -	qc = ata_qc_new_init(ap, dev);
> -	BUG_ON(qc == NULL);
> +	while ((qc = ata_qc_new_init(ap, dev)) == NULL)
> +		msleep(10);
>  
>  	qc->tf.command = cmd;
>  	qc->tf.flags |= ATA_TFLAG_DEVICE;

Worried now!

If this patch is needed, something VERY VERY WRONG is going on.  This 
patch indicates that the queueing state machine has been violated, and 
something is trying to IGNORE the command synchronization :(

Further, you cannot always assume that msleep() is valid in that 
context.  It should be the caller that waits (libata suspend code), not 
ata_do_simple_cmd() itself.

Does anyone have a link to James Bottomley's proposed patch?  That one 
seemed to do what was necessary -- send a SYNCHRONIZE_CACHE command then 
turn it over to the LLD for further suspend.


Linus wrote:
> Ok. Can we have this in -mm for a few days just to shake out anything 
> interesting, and then merge it into mainline?

Once we get a decent patch, I can merge it into my libata-dev.git 
repository, which is automatically propagated to -mm.

	Jeff



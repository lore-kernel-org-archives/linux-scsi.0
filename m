From: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
Subject: RE: [PATCH] cciss: resubmit - fix spinlock use
Date: Fri, 18 Sep 2009 15:59:35 +0000
Message-ID: <0F5B06BAB751E047AB5C87D1F77A77886953D50183@GVW0547EXC.americas.hpqcorp.net>
References: <4AB39C4F.6070001@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g1t0029.austin.hp.com ([15.216.28.36]:3551 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805AbZIRQAM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Sep 2009 12:00:12 -0400
In-Reply-To: <4AB39C4F.6070001@redhat.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "Patterson, Andrew D (Linux R&D)" <andrew.patterson@hp.com>, James Bottomley <James.Bottomley@HansenPartnership.com>

 

> -----Original Message-----
> From: Tomas Henzl [mailto:thenzl@redhat.com] 
> Sent: Friday, September 18, 2009 9:42 AM
> To: linux-scsi@vger.kernel.org
> Cc: Patterson, Andrew D (Linux R&D); Miller, Mike (OS Dev); 
> James Bottomley
> Subject: [PATCH] cciss: resubmit - fix spinlock use 
> 
> fail_all_cmds is called (only) from do_cciss_intr with 
> spinlock acquired.
> So when in an error-handling situation,
> fail_all_cmds() is called it attempts to *reacquire* the lock.
> This has been found and analysed by Prarit Bhargava.
> 
> This patch removes the spinlock lock/unlock from 
> fail_all_cmds and adds a spin_unlock after the call to 
> fail_all_cmds before return.  
> 
> Signed-off-by: Tomas Henzl <thenzl@redhat.com>

Acked-by: Mike Miller <mike.miller@hp.com>

> 
> diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c 
> index c7a527c..b45776e 100644
> --- a/drivers/block/cciss.c
> +++ b/drivers/block/cciss.c
> @@ -3181,6 +3181,7 @@ static irqreturn_t do_cciss_intr(int 
> irq, void *dev_id)
>  					       "cciss: 
> controller cciss%d failed, stopping.\n",
>  					       h->ctlr);
>  					fail_all_cmds(h->ctlr);
> +					
> spin_unlock_irqrestore(CCISS_LOCK(h->ctlr), flags);
>  					return IRQ_HANDLED;
>  				}
>  
> @@ -4230,8 +4231,6 @@ static void fail_all_cmds(unsigned long ctlr)
>  	printk(KERN_WARNING "cciss%d: controller not 
> responding.\n", h->ctlr);
>  	h->alive = 0;		/* the controller apparently died... */
>  
> -	spin_lock_irqsave(CCISS_LOCK(ctlr), flags);
> -
>  	pci_disable_device(h->pdev);	/* Make sure it is 
> really dead. */
>  
>  	/* move everything off the request queue onto the 
> completed queue */ @@ -4256,7 +4255,6 @@ static void 
> fail_all_cmds(unsigned long ctlr)
>  			complete_scsi_command(c, 0, 0);
>  #endif
>  	}
> -	spin_unlock_irqrestore(CCISS_LOCK(ctlr), flags);
>  	return;
>  }
>  
> 
> -- 1.6.0.6
> 
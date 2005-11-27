From: Marcelo Tosatti <marcelo.tosatti@cyclades.com>
Subject: Re: [patch] drivers/scsi/dpt_i2o.c: fix a NULL pointer dereference
Date: Sun, 27 Nov 2005 10:47:38 -0200
Message-ID: <20051127124738.GC13581@logos.cnet>
References: <20051126233637.GC3988@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:55686 "EHLO hera.kernel.org")
	by vger.kernel.org with ESMTP id S1751141AbVK0Sdz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 27 Nov 2005 13:33:55 -0500
Content-Disposition: inline
In-Reply-To: <20051126233637.GC3988@stusta.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Adrian Bunk <bunk@stusta.de>
Cc: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>, markus.lidel@shadowconnect.com, James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Mark Salyzyn <mark_salyzyn@adaptec.com>

On Sun, Nov 27, 2005 at 12:36:37AM +0100, Adrian Bunk wrote:
> The Coverity checker spotted this obvious NULL pointer dereference.

Hi Adrian,

Could you explain why you remove the adpt_post_wait_lock acquision? 

And if it does not belong there, why don't you remove it instead of
commeting out?

> Signed-off-by: Adrian Bunk <bunk@stusta.de>
> Acked-by: Mark Salyzyn <mark_salyzyn@adaptec.com>
> 
> ---
> 
> This patch was already sent on:
> - 23 Nov 2005
> - 21 Nov 2005
> 
>  drivers/scsi/dpt_i2o.c |    9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> --- linux-2.6.15-rc1-mm2-full/drivers/scsi/dpt_i2o.c.old	2005-11-20 22:13:37.000000000 +0100
> +++ linux-2.6.15-rc1-mm2-full/drivers/scsi/dpt_i2o.c	2005-11-20 22:16:57.000000000 +0100
> @@ -816,7 +816,7 @@
>  static void adpt_i2o_sys_shutdown(void)
>  {
>  	adpt_hba *pHba, *pNext;
> -	struct adpt_i2o_post_wait_data *p1, *p2;
> +	struct adpt_i2o_post_wait_data *p1, *old;
>  
>  	 printk(KERN_INFO"Shutting down Adaptec I2O controllers.\n");
>  	 printk(KERN_INFO"   This could take a few minutes if there are many devices attached\n");
> @@ -830,13 +830,14 @@
>  	}
>  
>  	/* Remove any timedout entries from the wait queue.  */
> -	p2 = NULL;
>  //	spin_lock_irqsave(&adpt_post_wait_lock, flags);
>  	/* Nothing should be outstanding at this point so just
>  	 * free them 
>  	 */
> -	for(p1 = adpt_post_wait_queue; p1; p2 = p1, p1 = p2->next) {
> -		kfree(p1);
> +	for(p1 = adpt_post_wait_queue; p1;) {
> +		old = p1;
> +		p1 = p1->next;
> +		kfree(old);
>  	}
>  //	spin_unlock_irqrestore(&adpt_post_wait_lock, flags);
>  	adpt_post_wait_queue = NULL;

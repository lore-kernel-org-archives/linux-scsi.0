From: Satyam Sharma <satyam@infradead.org>
Subject: Re: [PATCH 2/5] Use mutex instead of semaphore in the OnStream SCSI
 Tape driver
Date: Mon, 30 Jul 2007 08:57:15 +0530 (IST)
Message-ID: <alpine.LFD.0.999.0707300853390.10861@enigma.security.iitk.ac.in>
References: <20070729212909.GC3432@traven> <20070729213633.GE3432@traven>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S937902AbXG3DPM@vger.kernel.org>
In-Reply-To: <20070729213633.GE3432@traven>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
Cc: osst@riede.org, osst-users@lists.sourceforge.net, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org
List-Id: linux-scsi@vger.kernel.org

Hi,


On Sun, 29 Jul 2007, Matthias Kaehlcke wrote:

> The OnStream SCSI Tape driver uses a semaphore as mutex. Use the mutex
> API instead of the (binary) semaphore.
> 
> Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
> [...]
> @@ -3298,7 +3298,7 @@ static ssize_t osst_write(struct file * filp, const char __user * buf, size_t co
>  	char		    * name = tape_name(STp);
>  
>  
> -	if (down_interruptible(&STp->lock))
> +	if (mutex_lock_interruptible(&STp->lock))
>  		return (-ERESTARTSYS);

The () after return existed in the code already, but you could've felt
free to remove them :-)

> @@ -3619,7 +3619,7 @@ static ssize_t osst_read(struct file * filp, char __user * buf, size_t count, lo
>  	char		    * name  = tape_name(STp);
>  
>  
> -	if (down_interruptible(&STp->lock))
> +	if (mutex_lock_interruptible(&STp->lock))
>  		return (-ERESTARTSYS);

Same here.

Reviewed-by: Satyam Sharma <satyam@infradead.org>

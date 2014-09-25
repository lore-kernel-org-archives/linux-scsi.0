From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] scsi_debug: deadlock between completions and surprise
 module removal
Date: Thu, 25 Sep 2014 05:13:17 -0700
Message-ID: <20140925121317.GA16303@infradead.org>
References: <5403AB47.3040706@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5403AB47.3040706@interlog.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Douglas Gilbert <dgilbert@interlog.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@infradead.org>, Milan Broz <gmazyland@gmail.com>
List-Id: linux-scsi@vger.kernel.org

Review ping again?

While I think the shutdown code in scsi_debug needs a bit more of an
overhault I'd really like to include the fix at least for 3.18 and
3.17-stable now that we have missed the 3.17 window.

On Sun, Aug 31, 2014 at 07:09:59PM -0400, Douglas Gilbert wrote:
> A deadlock has been reported when the completion
> of SCSI commands (simulated by a timer) was surprised
> by a module removal. This patch removes one half of
> the offending locks around timer deletions. This fix
> is applied both to stop_all_queued() which is were
> the deadlock was discovered and stop_queued_cmnd()
> which has very similar logic.
> 
> This patch should be applied both to the lk 3.17 tree
> and Christoph's drivers-for-3.18 tree.
> 
> Tested-and-reported-by: Milan Broz <gmazyland@gmail.com>
> Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>

> --- a/drivers/scsi/scsi_debug.c	2014-08-26 13:24:51.646948507 -0400
> +++ b/drivers/scsi/scsi_debug.c	2014-08-30 18:04:54.589226679 -0400
> @@ -2743,6 +2743,13 @@ static int stop_queued_cmnd(struct scsi_
>  		if (test_bit(k, queued_in_use_bm)) {
>  			sqcp = &queued_arr[k];
>  			if (cmnd == sqcp->a_cmnd) {
> +				devip = (struct sdebug_dev_info *)
> +					cmnd->device->hostdata;
> +				if (devip)
> +					atomic_dec(&devip->num_in_q);
> +				sqcp->a_cmnd = NULL;
> +				spin_unlock_irqrestore(&queued_arr_lock,
> +						       iflags);
>  				if (scsi_debug_ndelay > 0) {
>  					if (sqcp->sd_hrtp)
>  						hrtimer_cancel(
> @@ -2755,18 +2762,13 @@ static int stop_queued_cmnd(struct scsi_
>  					if (sqcp->tletp)
>  						tasklet_kill(sqcp->tletp);
>  				}
> -				__clear_bit(k, queued_in_use_bm);
> -				devip = (struct sdebug_dev_info *)
> -					cmnd->device->hostdata;
> -				if (devip)
> -					atomic_dec(&devip->num_in_q);
> -				sqcp->a_cmnd = NULL;
> -				break;
> +				clear_bit(k, queued_in_use_bm);
> +				return 1;
>  			}
>  		}
>  	}
>  	spin_unlock_irqrestore(&queued_arr_lock, iflags);
> -	return (k < qmax) ? 1 : 0;
> +	return 0;
>  }
>  
>  /* Deletes (stops) timers or tasklets of all queued commands */
> @@ -2782,6 +2784,13 @@ static void stop_all_queued(void)
>  		if (test_bit(k, queued_in_use_bm)) {
>  			sqcp = &queued_arr[k];
>  			if (sqcp->a_cmnd) {
> +				devip = (struct sdebug_dev_info *)
> +					sqcp->a_cmnd->device->hostdata;
> +				if (devip)
> +					atomic_dec(&devip->num_in_q);
> +				sqcp->a_cmnd = NULL;
> +				spin_unlock_irqrestore(&queued_arr_lock,
> +						       iflags);
>  				if (scsi_debug_ndelay > 0) {
>  					if (sqcp->sd_hrtp)
>  						hrtimer_cancel(
> @@ -2794,12 +2803,8 @@ static void stop_all_queued(void)
>  					if (sqcp->tletp)
>  						tasklet_kill(sqcp->tletp);
>  				}
> -				__clear_bit(k, queued_in_use_bm);
> -				devip = (struct sdebug_dev_info *)
> -					sqcp->a_cmnd->device->hostdata;
> -				if (devip)
> -					atomic_dec(&devip->num_in_q);
> -				sqcp->a_cmnd = NULL;
> +				clear_bit(k, queued_in_use_bm);
> +				spin_lock_irqsave(&queued_arr_lock, iflags);
>  			}
>  		}
>  	}

---end quoted text---

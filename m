From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH]: HotSwap SCSI in Soft RAID1 (scsi_rescan)
Date: Fri, 20 Sep 2002 12:35:47 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020920193547.GA3237@beaverton.ibm.com>
References: <A5974D8E5F98D511BB910002A50A66470580D1EC@hdsmsx103.hd.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <A5974D8E5F98D511BB910002A50A66470580D1EC@hdsmsx103.hd.intel.com>
List-Id: linux-scsi@vger.kernel.org
To: "Cress, Andrew R" <andrew.r.cress@intel.com>
Cc: linux-raid@vger.kernel.org, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

Cress, Andrew R [andrew.r.cress@intel.com] wrote:
> --- linux-2.4.18-orig/drivers/scsi/scsi.c	Wed Aug 28 20:38:13 2002
> +++ linux-2.4.18/drivers/scsi/scsi.c	Thu Aug 29 08:08:57 2002
> @@ -1999,6 +1999,9 @@
>  				(*sdtpnt->finish) ();
>  			}
>  		}
> +		for (shpnt = scsi_hostlist; shpnt; shpnt = shpnt->next) {
> +			shpnt->init_done = 1;
> +		}
>  	}

This could probably be done in a upper loop (maybe not to avoid unit
attentions)  or at least only on the adapter template that is being
registered.

> +
> +			if (!in_interrupt()) {
> +			   /* Check if we need to rescan after a reset.
> ARC*/
> +			   if (SDpnt->host->need_scan == 1) {
> +				SDpnt->host->need_scan = 2;
> +				spin_unlock_irq(&io_request_lock);
> +				scsi_rescan(SDpnt->host,SDpnt->channel);
> +				spin_lock_irq(&io_request_lock);
> +				SDpnt->host->need_scan = 0;
> +			   }
> +			}
>  		}

I do not have a suggestion on where to move this, but you could be
called under memory pressure which is probably not the best
time to be allocating chunks of memory.

-andmike
-- 
Michael Anderson
andmike@us.ibm.com


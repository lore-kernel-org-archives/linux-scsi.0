From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Deadlock in usb-storage error handling
Date: Thu, 20 Mar 2014 15:49:42 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1403201548160.866-100000@iolanthe.rowland.org>
References: <1395338255.2244.33.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:42505 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757087AbaCTTtm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Mar 2014 15:49:42 -0400
In-Reply-To: <1395338255.2244.33.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andreas Reis <andreas.reis@gmail.com>, USB list <linux-usb@vger.kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>

On Thu, 20 Mar 2014, James Bottomley wrote:

> On Thu, 2014-03-20 at 12:34 -0400, Alan Stern wrote:
> > On Thu, 20 Mar 2014, James Bottomley wrote:
> > 
> > > OK, so I think we have three things to do
> > > 
> > >      1. Investigate SCSI and fix it's abort state problem that's causing
> > >         it not to send the abort second time around
> > >      2. Fix usb-storage to fail a reset it can't do (i.e. device reset
> > >         with outstanding commands)
> > >      3. Find out why we're sending a spurious request sense.
> > > 
> > > I can look at 1 and 3 if you want to take 2.
> > 
> > It's a deal!  Thanks for your help.
> 
> OK, I think this is the fix for 1, if you could try it out.
> 
> Thanks,
> 
> James
> 
> ---
> 
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index 771c16b..c52bfb2 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -145,14 +145,14 @@ scmd_eh_abort_handler(struct work_struct *work)
>  						    "scmd %p retry "
>  						    "aborted command\n", scmd));
>  				scsi_queue_insert(scmd, SCSI_MLQUEUE_EH_RETRY);
> -				return;
> +				goto out;
>  			} else {
>  				SCSI_LOG_ERROR_RECOVERY(3,
>  					scmd_printk(KERN_WARNING, scmd,
>  						    "scmd %p finish "
>  						    "aborted command\n", scmd));
>  				scsi_finish_command(scmd);
> -				return;
> +				goto out;
>  			}
>  		} else {
>  			SCSI_LOG_ERROR_RECOVERY(3,
> @@ -162,6 +162,8 @@ scmd_eh_abort_handler(struct work_struct *work)
>  		}
>  	}
>  
> +	scmd->eh_eflags &= ~SCSI_EH_ABORT_SCHEDULED;
> +
>  	if (!scsi_eh_scmd_add(scmd, 0)) {
>  		SCSI_LOG_ERROR_RECOVERY(3,
>  			scmd_printk(KERN_WARNING, scmd,
> @@ -170,6 +172,10 @@ scmd_eh_abort_handler(struct work_struct *work)
>  		scmd->result |= DID_TIME_OUT << 16;
>  		scsi_finish_command(scmd);
>  	}
> +	return;
> + out:
> +	scmd->eh_eflags &= ~SCSI_EH_ABORT_SCHEDULED;
> +	return;
>  }
>  
>  /**

This worked the first time.  :-)

But I wonder, is it safe to access scmd after calling 
scsi_finish_command()?

Alan Stern


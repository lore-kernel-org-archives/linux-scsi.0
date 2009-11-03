From: James Bottomley <James.Bottomley@suse.de>
Subject: RE: [PATCH ]  scsi-misc-2.6:  File System going into read-only mode
Date: Tue, 03 Nov 2009 09:08:58 -0600
Message-ID: <1257260938.2728.6.camel@mulgrave.site>
References: <4F2B1A2459C7AD4D96A23CE911C352CB1E914C8546@CHN-HCLT-EVS07.HCLT.CORP.HCL.IN>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:51989 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751105AbZKCPJB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 3 Nov 2009 10:09:01 -0500
In-Reply-To: <4F2B1A2459C7AD4D96A23CE911C352CB1E914C8546@CHN-HCLT-EVS07.HCLT.CORP.HCL.IN>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Penchala Narasimha Reddy Chilakala, TLS-Chennai" <narasimhareddyc@hcl.in>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, ServeRAID Driver <ServeRAIDDriver@hcl.in>

On Tue, 2009-11-03 at 15:08 +0530, Penchala Narasimha Reddy Chilakala,
TLS-Chennai wrote:
> Hi James,
> 
> I can do the following thing, I hope which works well and it would not change any existing functionality behavior and I hope you agree with me. I could not able accept your suggestion because of the following reason.
> 
> As the warning fix, here is my suggestion on top of my original patch (I will resubmit a patch with this modification, please let me know if it is ok for you)
> 
> diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
> index d29af45..1712ebe 100644
> --- a/drivers/scsi/aacraid/commsup.c
> +++ b/drivers/scsi/aacraid/commsup.c
> @@ -535,11 +535,11 @@ int aac_fib_send(u16 command, struct fib *fibptr, unsigned long size,
>  				}
>  				udelay(5);
>  			}
> -		} else
> -			down_interruptible(&fibptr->event_wait);
> -
> +		} else if (down_interruptible(&fibptr->event_wait)) {
> +			fibptr->done |= 2;
> +		}
>  		spin_lock_irqsave(&fibptr->event_lock, flags);
> -		if (fibptr->done == 0) {
> +		if (!(fibptr->done & 1)) {
>  			fibptr->done = 2; /* Tell interrupt we aborted */
>  			spin_unlock_irqrestore(&fibptr->event_lock, flags);
>  			return -ERESTARTSYS;
> 
> 
> Reason:
> ---------
> 	Whatever explanation I have given here is based on our test results
> and problems we encountered during our testing. Nobody might have done
> this much testing on this code after replacing the "down ()" with
> "down_interruptible () kernel function. 
> 
> "down_interruptible" is not a single statement or single instruction
> function. It has set of statements, which have to be executed based on
> its conditions. When it receives a soft interrupt signal, a set of
> statements will be executed and when it gets semaphore, some other set
> of statements will be executed. 
> 
> 	Now, assume that down_interruptible received a soft interrupt signal
> from X source and started executing those statements and while
> executing those statements, host driver received a interrupt from
> aacraid controller and suspends the currently executing task and
> starts executing the aacraid driver interrupt service route (ISR).
> The ISR checks the responses for the requests sent to firmware, if it
> gets response for the management request then it sets fibptr->done = 1
> and it comes out of the ISR and starts executing the suspended task.
> Now the suspended task will modify the fibptr->done with 2. This is
> not correct behavior. So, to over come that we have done those
> changes, after doing those changes, we have executed all the test
> cases we executed before the changes and we have not seen the issue we
> encountered before the change.

Yes, I agree with the analysis.  In that case just make it

else if (down_interruptible(&fibptr->event_wait)) {
	/* do nothing ... satisfy down_interruptible must_check */
}

And keep the original.

James



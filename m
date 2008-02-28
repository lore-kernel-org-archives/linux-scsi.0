From: Keith Hopkins <vger@hopnet.net>
Subject: Re: [PATCH] aic94xx: Don't free ABORT_TASK SCBs that are timed out
  (Was: Re: aic94xx: failing on high load)
Date: Thu, 28 Feb 2008 22:56:20 +0800
Message-ID: <47C6CB94.4070904@hopnet.net>
References: <479FB3ED.3080401@hopnet.net>	<20080130091403.GA14887@alaris.suse.cz> <47A05896.40900@hopnet.net>	<20080130192947.GA21785@tree.beaverton.ibm.com>	<47B4682C.4020505@hopnet.net>	<1203089323.3058.20.camel@localhost.localdomain>	<47B9958A.8080104@hopnet.net>	<1203438140.3103.24.camel@localhost.localdomain> <20080219184359.GA5414@tree.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [123.112.10.105] ([123.112.10.105]:33745 "EHLO mail.hopnet.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757004AbYB1Pav (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Feb 2008 10:30:51 -0500
In-Reply-To: <20080219184359.GA5414@tree.beaverton.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: linux-scsi@vger.kernel.org

On 02/20/2008 02:44 AM, Darrick J. Wong wrote:
> If we send an ABORT_TASK ascb that doesn't return within the timeout period,
> we should not free that ascb because the sequencer is still holding onto it.
> Hopefully it will fix what James Bottomley describes below:
> 
> On Tue, Feb 19, 2008 at 10:22:20AM -0600, James Bottomley wrote:
> 
>> Unfortunately, there's a bug in TMF timeout handling in the driver, it
>> leaves the sequencer entry pending, but frees the ascb.  If the
>> sequencer ever picks this up it will get very confused, as it does a
>> while down in the trace:
>>
>>> aic94xx: BUG:sequencer:dl:no ascb?!
>>> aic94xx: BUG:sequencer:dl:no ascb?!
>> That's where the sequencer adds an ascb to the done list that we've
>> already freed.  From this point on confusion reigns and the error
>> handler eventually offlines the device.
>>
>> I'll see if I can come up with patches to fix this ... or at least
>> mitigate the problems it causes.
> 
> Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
> ---
> 
>  drivers/scsi/aic94xx/aic94xx_tmf.c |    7 ++++++-
>  1 files changed, 6 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/scsi/aic94xx/aic94xx_tmf.c b/drivers/scsi/aic94xx/aic94xx_tmf.c
> index b52124f..4b24bd3 100644
> --- a/drivers/scsi/aic94xx/aic94xx_tmf.c
> +++ b/drivers/scsi/aic94xx/aic94xx_tmf.c
> @@ -463,7 +463,7 @@ int asd_abort_task(struct sas_task *task)
>  						       AIC94XX_SCB_TIMEOUT);
>  		spin_lock_irqsave(&task->task_state_lock, flags);
>  		if (leftover < 1)
> -			res = TMF_RESP_FUNC_FAILED;
> +			goto out_not_reported;
>  		if (task->task_state_flags & SAS_TASK_STATE_DONE)
>  			res = TMF_RESP_FUNC_COMPLETE;
>  		spin_unlock_irqrestore(&task->task_state_lock, flags);
> @@ -487,6 +487,11 @@ out:
>  	asd_ascb_free(ascb);
>  	ASD_DPRINTK("task 0x%p aborted, res: 0x%x\n", task, res);
>  	return res;
> +
> +out_not_reported:
> +	spin_unlock_irqrestore(&task->task_state_lock, flags);
> +	ASD_DPRINTK("task 0x%p aborted? but not reported.\n", task);
> +	return res;
>  }
>  
>  /**
> -

Hi Darrick,

  Is this the only patch for ascb sequencer use after free problems, or are you still looking into that?

--Keith
